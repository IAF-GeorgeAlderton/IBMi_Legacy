#!/QOpenSys/pkgs/bin/python3
"""
IBM i Source → Git Exporter
One-way sync of IBM i source members to Git-ready IFS directory structure.

Usage:
    python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB [options]
"""

import os
import sys
import json
import re
import subprocess
import tempfile
import argparse
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple, Set, Optional
import ibm_db_dbi


# ═══════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════

class Config:
    """Export configuration"""
    
    # CPYTOSTMF parameters
    STMFCCSID = 1208        # UTF-8
    ENDLINFMT = "*LF"       # LF line endings
    STMFOPT = "*REPLACE"    # Replace if exists
    DBFCCSID = "*FILE"      # Use file's CCSID
    
    # Trailing space handling
    STRIP_TRAILING_SPACES = True  # Set False to preserve exactly
    
    # Member text in filename (Tobi-like)
    INCLUDE_MEMBER_TEXT = True    # NAME-text.ext vs NAME.ext
    TEXT_SEPARATOR = "-"          # Separator between name and text
    TEXT_MAX_LENGTH = 40          # Max length of text portion
    
    # Exclusion patterns (regex on member name)
    EXCLUDE_PATTERNS = [
        # r'^@.*',      # @WORK, @START, etc.
        # r'^#.*',      # Temp markers
        # r'^\$.*',     # System temp
        # r'.*_BAK$',   # Backup files
        # r'.*_OLD$',   # Old versions
    ]
    
    # File extensions by source type
    EXTENSIONS = {
        'RPGLE': 'rpgle',
        'SQLRPGLE': 'sqlrpgle',
        'RPGLEINC': 'rpgleinc',
        'CLLE': 'clle',
        'CLEINC': 'cleinc',
        'CMD': 'cmd',
        'DSPF': 'dspf',
        'PRTF': 'prtf',
        'LF': 'lf',
        'PF': 'pf',
        'SQL': 'sql',
        'C': 'c',
        'H': 'h',
        'BND': 'bnd',
        'TXT': 'txt',
    }


# ═══════════════════════════════════════════════════════════════════════════
# IBM i Interface
# ═══════════════════════════════════════════════════════════════════════════

def run_cl_command(cmd: str) -> Tuple[int, str, str]:
    """Execute a CL command via system -i"""
    result = subprocess.run(
        ['system', '-i', cmd],
        capture_output=True,
        text=True
    )
    return result.returncode, result.stdout, result.stderr


def get_db_connection():
    """Get local IBM i database connection"""
    try:
        conn = ibm_db_dbi.connect()
        return conn
    except Exception as e:
        print(f"❌ Error: Could not connect to database: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)


def get_source_files(library: str, conn) -> List[str]:
    """Get list of source physical files in library"""
    sql = f"""
        Select Distinct Trim(System_Table_Name) as Source_File
          From QSYS2.SysTables       
         Where Table_Schema  = '{library.upper()}'
           And (Table_Type, File_Type) = ('P', 'S')
         Order By 1       
    """
    
    try:
        cursor = conn.cursor()
        cursor.execute(sql)
        files = []
        for row in cursor.fetchall():
            if row[0]:
                files.append(row[0].strip())
        cursor.close()
        return files
    except Exception as e:
        print(f"⚠️  Warning: Could not query source files: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return []


def get_source_members(library: str, srcfile: str, conn) -> List[Dict[str, str]]:
    """Get list of members in a source file with metadata"""
    sql = f"""
        Select Trim(System_Table_Member) Member,
               Trim(Coalesce(Source_Type, '')) Type,
               Trim(Coalesce(Partition_Text, '')) AS Text,
               Last_Source_Update_Timestamp
          From QSys2.SysPartitionStat
         Where System_Table_Schema = '{library.upper()}'
           And System_Table_Name = '{srcfile.upper()}'
         Order by System_Table_Member
    """
    
    try:
        cursor = conn.cursor()
        cursor.execute(sql)
        members = []
        for row in cursor.fetchall():
            if row[0]:
                members.append({
                    'name': row[0].strip(),
                    'type': row[1].strip() if row[1] else '',
                    'text': row[2].strip() if row[2] else '',
                    'timestamp': str(row[3]) if row[3] else ''
                })
        cursor.close()
        return members
    except Exception as e:
        print(f"⚠️  Warning: Could not query members: {e}", file=sys.stderr)
        return []
    
    return members


def export_member_to_temp(library: str, srcfile: str, member: str) -> Optional[str]:
    """Export member to temporary UTF-8 file, return temp path"""
    temp_fd, temp_path = tempfile.mkstemp(prefix=f'ibmi_sync_{member}_', suffix='.tmp')
    os.close(temp_fd)  # Close the file descriptor, we just need the path
    
    qsys_path = f'/QSYS.LIB/{library.upper()}.LIB/{srcfile.upper()}.FILE/{member.upper()}.MBR'
    
    cmd = (
        f"CPYTOSTMF "
        f"FROMMBR('{qsys_path}') "
        f"TOSTMF('{temp_path}') "
        f"STMFOPT({Config.STMFOPT}) "
        f"STMFCCSID({Config.STMFCCSID}) "
        f"ENDLINFMT({Config.ENDLINFMT}) "
        f"DBFCCSID({Config.DBFCCSID})"
    )
    
    rc, stdout, stderr = run_cl_command(cmd)
    
    if rc != 0:
        if os.path.exists(temp_path):
            os.unlink(temp_path)
        return None
    
    return temp_path


# ═══════════════════════════════════════════════════════════════════════════
# File System Operations
# ═══════════════════════════════════════════════════════════════════════════

def sanitize_text_for_filename(text: str, max_length: int = Config.TEXT_MAX_LENGTH) -> str:
    """Convert member text to filesystem-safe string"""
    if not text:
        return ""
    
    # Convert to lowercase and replace problematic characters
    safe = text.lower()
    safe = re.sub(r'[^a-z0-9]+', '_', safe)  # Replace non-alphanumeric with underscore
    safe = re.sub(r'_+', '_', safe)          # Collapse multiple underscores
    safe = safe.strip('_')                   # Remove leading/trailing underscores
    
    # Truncate if needed
    if len(safe) > max_length:
        safe = safe[:max_length].rstrip('_')
    
    return safe


def build_target_filename(member: str, member_type: str, member_text: str) -> str:
    """Build target filename with optional member text"""
    # Determine extension
    ext = Config.EXTENSIONS.get(member_type.upper(), 'txt')
    
    # Base filename
    filename = member.lower()
    
    # Add member text if configured
    if Config.INCLUDE_MEMBER_TEXT and member_text:
        safe_text = sanitize_text_for_filename(member_text)
        if safe_text:
            filename = f"{filename}{Config.TEXT_SEPARATOR}{safe_text}"
    
    return f"{filename}.{ext}"


def normalize_content(content: str) -> str:
    """Normalize content for comparison (handle trailing spaces)"""
    if Config.STRIP_TRAILING_SPACES:
        lines = content.split('\n')
        lines = [line.rstrip() for line in lines]
        return '\n'.join(lines)
    return content


def files_are_identical(path1: str, path2: str) -> bool:
    """Compare two UTF-8 files for content equality"""
    try:
        with open(path1, 'r', encoding='utf-8') as f1:
            content1 = normalize_content(f1.read())
        
        with open(path2, 'r', encoding='utf-8') as f2:
            content2 = normalize_content(f2.read())
        
        return content1 == content2
    
    except Exception as e:
        print(f"⚠️  Warning: Could not compare files: {e}", file=sys.stderr)
        return False


def should_exclude_member(member_name: str) -> bool:
    """Check if member matches exclusion patterns"""
    for pattern in Config.EXCLUDE_PATTERNS:
        if re.match(pattern, member_name, re.IGNORECASE):
            return True
    return False


# ═══════════════════════════════════════════════════════════════════════════
# Sync Logic
# ═══════════════════════════════════════════════════════════════════════════

def sync_source_file(
    library: str,
    srcfile: str,
    target_dir: Path,
    dry_run: bool = False,
    verbose: bool = False,
    conn = None
) -> Dict[str, int]:
    """
    Sync one source file to target directory.
    Returns stats dict.
    """
    stats = {
        'scanned': 0,
        'excluded': 0,
        'added': 0,
        'updated': 0,
        'unchanged': 0,
        'deleted': 0,
        'failed': 0,
    }
    
    print(f"\n📂 {srcfile}")
    
    # Get members
    members = get_source_members(library, srcfile, conn)
    if not members:
        print(f"   ⏭️  Skipping - no members found")
        return stats
    
    # Track exported filenames for cleanup
    exported_files: Set[str] = set()
    
    # Process each member
    for member_data in members:
        member = member_data['name']
        member_type = member_data['type']
        member_text = member_data['text']
        
        stats['scanned'] += 1
        
        # Check exclusions
        if should_exclude_member(member):
            stats['excluded'] += 1
            if verbose:
                print(f"   ⊘  {member} (excluded)")
            continue
        
        # Build target filename
        target_filename = build_target_filename(member, member_type, member_text)
        target_path = target_dir / target_filename
        exported_files.add(target_filename)
        
        # Export to temp
        temp_path = export_member_to_temp(library, srcfile, member)
        if not temp_path:
            stats['failed'] += 1
            print(f"   ✗  {member} → {target_filename} (export failed)")
            continue
        
        try:
            # Apply normalization to temp file
            with open(temp_path, 'r', encoding='utf-8') as f:
                content = normalize_content(f.read())
            with open(temp_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            # Compare with existing file
            if target_path.exists():
                if files_are_identical(temp_path, str(target_path)):
                    stats['unchanged'] += 1
                    if verbose:
                        print(f"   =  {member} → {target_filename} (unchanged)")
                    continue
            
            # Content differs or file is new - copy it
            is_new = not target_path.exists()
            
            if dry_run:
                action = "would create" if is_new else "would update"
                print(f"   ⋯  {member} → {target_filename} ({action})")
            else:
                target_dir.mkdir(parents=True, exist_ok=True)
                with open(temp_path, 'r', encoding='utf-8') as src:
                    with open(target_path, 'w', encoding='utf-8') as dst:
                        dst.write(src.read())
                
                action = "created" if is_new else "updated"
                print(f"   ✓  {member} → {target_filename}")
            
            if is_new:
                stats['added'] += 1
            else:
                stats['updated'] += 1
        
        finally:
            # Clean up temp file
            if os.path.exists(temp_path):
                os.unlink(temp_path)
    
    # Cleanup: remove IFS files that no longer have corresponding members
    if target_dir.exists():
        existing_files = set(f.name for f in target_dir.iterdir() if f.is_file() and not f.name.startswith('.'))
        orphaned = existing_files - exported_files - {'.metadata.json'}  # Keep metadata
        
        if orphaned:
            for filename in orphaned:
                orphan_path = target_dir / filename
                if dry_run:
                    print(f"   ⊗  {filename} (would delete - no matching member)")
                else:
                    orphan_path.unlink()
                    print(f"   ⊗  {filename} (deleted - no matching member)")
                stats['deleted'] += 1
    
    return stats


def write_metadata(target_dir: Path, library: str, srcfile: str, stats: Dict[str, int], dry_run: bool = False):
    """Write metadata file to source file directory"""
    metadata = {
        'source_library': library.upper(),
        'source_file': srcfile.upper(),
        'last_sync': datetime.now().isoformat(),
        'member_count': stats['added'] + stats['updated'] + stats['unchanged'],
        'stats': stats,
        'config': {
            'strip_trailing_spaces': Config.STRIP_TRAILING_SPACES,
            'include_member_text': Config.INCLUDE_MEMBER_TEXT,
            'stmfccsid': Config.STMFCCSID,
            'endlinfmt': Config.ENDLINFMT,
        }
    }
    
    if dry_run:
        return
    
    target_dir.mkdir(parents=True, exist_ok=True)
    metadata_path = target_dir / '.metadata.json'
    
    with open(metadata_path, 'w', encoding='utf-8') as f:
        json.dump(metadata, f, indent=2)


def sync_library(
    library: str,
    target_base: Path,
    source_files: Optional[List[str]] = None,
    dry_run: bool = False,
    verbose: bool = False,
    conn = None
):
    """
    Sync entire library or specific source files.
    """
    print(f"\n{'═' * 70}")
    print(f"IBM i → Git Source Export")
    print(f"{'═' * 70}")
    print(f"Library: {library.upper()}")
    print(f"Target:  {target_base}")
    if dry_run:
        print(f"Mode:    DRY RUN (no changes will be made)")
    print(f"{'═' * 70}")
    
    # Discover source files if not specified
    if not source_files:
        print(f"\n🔍 Discovering source files in {library}...")
        source_files = get_source_files(library, conn)
        if not source_files:
            print(f"❌ No source files found in library {library}")
            return
        print(f"   Found {len(source_files)} source file(s)")
    
    # Process each source file
    total_stats = {
        'scanned': 0,
        'excluded': 0,
        'added': 0,
        'updated': 0,
        'unchanged': 0,
        'deleted': 0,
        'failed': 0,
    }
    
    files_processed = 0
    for srcfile in source_files:
        target_dir = target_base / srcfile.upper()
        stats = sync_source_file(library, srcfile, target_dir, dry_run, verbose, conn)
        
        # Only count files that had members
        if stats['scanned'] > 0:
            files_processed += 1
        
        # Write metadata
        write_metadata(target_dir, library, srcfile, stats, dry_run)
        
        # Accumulate stats
        for key in total_stats:
            total_stats[key] += stats[key]
    
    # Summary
    print(f"\n{'═' * 70}")
    print(f"Summary")
    print(f"{'═' * 70}")
    print(f"  Source files:     {files_processed}")
    print(f"  Members scanned:  {total_stats['scanned']}")
    print(f"  Added:            {total_stats['added']}")
    print(f"  Updated:          {total_stats['updated']}")
    print(f"  Unchanged:        {total_stats['unchanged']}")
    print(f"  Deleted:          {total_stats['deleted']}")
    print(f"  Excluded:         {total_stats['excluded']}")
    print(f"  Failed:           {total_stats['failed']}")
    print(f"{'═' * 70}\n")


# ═══════════════════════════════════════════════════════════════════════════
# CLI
# ═══════════════════════════════════════════════════════════════════════════

def main():
    parser = argparse.ArgumentParser(
        description='Export IBM i source members to Git-ready directory structure',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Export entire library
  python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB

  # Export specific source files
  python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB \\
      --srcfiles QRPGLESRC QCLSRC

  # Dry run (no changes)
  python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB --dry-run

  # Verbose output
  python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB --verbose
        """
    )
    
    parser.add_argument(
        '--library', '-l',
        required=True,
        help='IBM i library name'
    )
    
    parser.add_argument(
        '--target', '-t',
        required=True,
        help='Target IFS directory (e.g., /home/GitRepos/MYLIB)'
    )
    
    parser.add_argument(
        '--srcfiles', '-s',
        nargs='+',
        help='Specific source files to export (default: all)'
    )
    
    parser.add_argument(
        '--dry-run', '-n',
        action='store_true',
        help='Show what would be done without making changes'
    )
    
    parser.add_argument(
        '--verbose', '-v',
        action='store_true',
        help='Show all members including unchanged'
    )
    
    args = parser.parse_args()
    
    # Validate inputs
    target_path = Path(args.target)
    
    # Establish database connection
    print(f"\n🔗 Connecting to database...")
    conn = get_db_connection()
    
    try:
        sync_library(
            library=args.library,
            target_base=target_path,
            source_files=args.srcfiles,
            dry_run=args.dry_run,
            verbose=args.verbose,
            conn=conn
        )
    except KeyboardInterrupt:
        print("\n\n⚠️  Interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)
    finally:
        if conn:
            conn.close()


if __name__ == '__main__':
    main()
