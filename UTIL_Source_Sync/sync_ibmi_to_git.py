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
    
    # Timestamp comparison (faster incremental syncs)
    USE_TIMESTAMP_COMPARISON = False  # Set True for timestamp-based detection (faster)
    TIMESTAMP_FILE = '.member_timestamps.json'  # Stored in target directory


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


def check_bad_chars_in_member(library: str, srcfile: str, member: str, conn) -> str:
    """Check for x'0F' characters in source member using alias
    Returns empty string if OK, or error message if bad character found
    """
    try:
        cursor = conn.cursor()
        
        # Drop alias if it exists
        try:
            cursor.execute(f"DROP ALIAS {library.upper()}.GITSRCMBR")
        except:
            pass  # Alias may not exist
        
        # Create alias pointing to the member (use lowercase for schema.file, uppercase for member)
        create_alias_sql = f"CREATE ALIAS {library.upper()}.GITSRCMBR FOR {library.lower()}.{srcfile.lower()} ({member.upper()})"
        cursor.execute(create_alias_sql)
        
        # Query for bad characters - WHERE clause filters to only rows with x'0F'
        check_sql = f"""
            Select SrcSeq,
                   PosStr(SrcDta, x'0F') As BadCol
              From {library.upper()}.GITSRCMBR
             Where PosStr(SrcDta, x'0F') > 0
        """
        
        cursor.execute(check_sql)
        row = cursor.fetchone()
        
        # Clean up alias
        try:
            cursor.execute(f"DROP ALIAS {library.upper()}.GITSRCMBR")
        except:
            pass
        
        cursor.close()
        
        # If we found a bad character, return error message
        if row:
            seq = row[0]
            col = row[1]
            return f"Bad Character found at column {col} in line {seq}"
        
        return ""
        
    except Exception as e:
        # If we can't check, just return empty
        return ""


def export_member_to_temp(library: str, srcfile: str, member: str) -> Tuple[Optional[str], str]:
    """Export member to temporary UTF-8 file, return (temp_path, command)"""
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
        return None, cmd
    
    return temp_path, cmd


# ═══════════════════════════════════════════════════════════════════════════
# File System Operations
# ═══════════════════════════════════════════════════════════════════════════

def sanitize_text_for_filename(text: str, max_length: int = Config.TEXT_MAX_LENGTH) -> str:
    """Convert member text to filesystem-safe string"""
    if not text:
        return ""
    
    # Replace problematic characters while preserving case and special chars (#, (), &, @)
    safe = re.sub(r'[^a-zA-Z0-9#()&@]+', '_', text)  # Replace unsafe chars with underscore
    safe = re.sub(r'_+', '_', safe)                  # Collapse multiple underscores
    safe = safe.strip('_')                           # Remove leading/trailing underscores
    
    # Truncate if needed
    if len(safe) > max_length:
        safe = safe[:max_length].rstrip('_')
    
    return safe


def build_target_filename(member: str, member_type: str, member_text: str) -> str:
    """Build target filename with optional member text"""
    # Use member type directly as extension (default to TXT if blank)
    ext = member_type.upper() if member_type else 'TXT'
    
    # Base filename
    filename = member.upper()
    
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
    conn = None,
    files_remaining: int = 0,
    total_files: int = 0,
    failures: Optional[List[Dict]] = None,
    timestamps: Optional[Dict[str, str]] = None
) -> Dict[str, int]:
    """
    Sync one source file to target directory.
    Returns stats dict.
    """
    if failures is None:
        failures = []
    
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
    total_members = len(members)
    
    # Process each member
    for idx, member_data in enumerate(members):
        member = member_data['name']
        member_type = member_data['type']
        member_text = member_data['text']
        
        stats['scanned'] += 1
        members_remaining = total_members - idx - 1
        progress = f"{files_remaining:03d}/{total_files:03d} {members_remaining:05d}/{total_members:05d}"
        
        # Check exclusions
        if should_exclude_member(member):
            stats['excluded'] += 1
            if verbose:
                # Build filename for display
                temp_filename = build_target_filename(member, member_type, member_text)
                print(f"   ⊘  {progress} {srcfile}.{member}.{member_type.upper()} -> {temp_filename} (excluded)")
            continue
        
        # Build target filename
        target_filename = build_target_filename(member, member_type, member_text)
        target_path = target_dir / target_filename
        exported_files.add(target_filename)
        
        # Show progress counter
        print(f"\r   Processing: {progress} (files/members remaining/total)", end='', flush=True)
        
        # Export to temp
        temp_path, cpytostmf_cmd = export_member_to_temp(library, srcfile, member)
        if not temp_path:
            stats['failed'] += 1
            
            # Check for bad characters in the source
            error_msg = check_bad_chars_in_member(library, srcfile, member, conn)
            
            print(f"\n   ✗  {progress} {srcfile}.{member}.{member_type.upper()} -> {target_filename} (export failed)")
            if error_msg:
                print(f"      ⚠️  {error_msg}")
            else:
                print(f"      ⚠️  CPYTOSTMF failed - check member for invalid characters or encoding issues")
            
            failures.append({
                'library': library.upper(),
                'srcfile': srcfile.upper(),
                'member': member.upper(),
                'type': member_type.upper() if member_type else 'TXT',
                'target_filename': target_filename,
                'reason': 'CPYTOSTMF export failed',
                'error_message': error_msg
            })
            continue
        
        try:
            # Apply normalization to temp file
            with open(temp_path, 'r', encoding='utf-8') as f:
                content = normalize_content(f.read())
            with open(temp_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            # Check if file has changed (timestamp or content comparison)
            if target_path.exists():
                is_unchanged = False
                
                if Config.USE_TIMESTAMP_COMPARISON and timestamps is not None:
                    # Timestamp-based comparison
                    ts_key = f"{srcfile.upper()}.{member.upper()}"
                    last_ts = timestamps.get(ts_key, '')
                    current_ts = member_data['timestamp']
                    is_unchanged = (last_ts == current_ts)
                    if is_unchanged:
                        # Update timestamp even if unchanged (keeps dict current)
                        timestamps[ts_key] = current_ts
                else:
                    # Content-based comparison
                    is_unchanged = files_are_identical(temp_path, str(target_path))
                
                if is_unchanged:
                    stats['unchanged'] += 1
                    if verbose:
                        compare_method = "timestamp" if Config.USE_TIMESTAMP_COMPARISON else "content"
                        print(f"\n   =  {progress} {srcfile}.{member}.{member_type.upper()} -> {target_filename} (unchanged - {compare_method})")
                    continue
            
            # Update timestamp tracking for new or changed files
            if timestamps is not None:
                ts_key = f"{srcfile.upper()}.{member.upper()}"
                timestamps[ts_key] = member_data['timestamp']
            
            # Content differs or file is new - copy it
            is_new = not target_path.exists()
            
            if dry_run:
                action = "would create" if is_new else "would update"
                print(f"\n   ⋯  {progress} {srcfile}.{member}.{member_type.upper()} -> {target_filename} ({action})")
            else:
                target_dir.mkdir(parents=True, exist_ok=True)
                with open(temp_path, 'r', encoding='utf-8') as src:
                    with open(target_path, 'w', encoding='utf-8') as dst:
                        dst.write(src.read())
                
                # Print add/update status on new line
                if verbose:
                    print(f"\n   ✓  {progress} {srcfile}.{member}.{member_type.upper()} -> {target_filename}")
            
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
        orphaned = existing_files - exported_files
        
        if orphaned:
            progress = f"{files_remaining:03d}/{total_files:03d} 00000/{total_members:05d}"
            for filename in orphaned:
                orphan_path = target_dir / filename
                if dry_run:
                    print(f"\n   ⊗  {progress} {filename} (would delete - no matching member)")
                else:
                    orphan_path.unlink()
                    print(f"\n   ⊗  {progress} {filename} (deleted - no matching member)")
                stats['deleted'] += 1
    
    # Print final newline to clear progress line
    print()
    
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


def write_sync_log(target_base: Path, library: str, failures: List[Dict], stats: Dict[str, int], files_processed: int, start_time: datetime, end_time: datetime):
    """Write sync log file with failures and summary"""
    log_path = target_base / f'{library.upper()}_sync_log.txt'
    elapsed = end_time - start_time
    
    with open(log_path, 'w', encoding='utf-8') as f:
        f.write(f"{'═' * 70}\n")
        f.write(f"IBM i → Git Source Export Log\n")
        f.write(f"{'═' * 70}\n")
        f.write(f"Library: {library.upper()}\n")
        f.write(f"Target: {target_base}\n")
        f.write(f"Start:  {start_time.strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"End:    {end_time.strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"Elapsed: {elapsed}\n")
        f.write(f"{'═' * 70}\n\n")
        
        if failures:
            f.write(f"FAILURES ({len(failures)})\n")
            f.write(f"{'-' * 70}\n")
            for idx, failure in enumerate(failures, 1):
                f.write(f"\n[{idx}] {failure['library']}/{failure['srcfile']}.{failure['member']}.{failure['type']}\n")
                f.write(f"    Target:  {failure['target_filename']}\n")
                f.write(f"    Reason:  {failure['reason']}\n")
                
                # Include error message if found
                if 'error_message' in failure and failure['error_message']:
                    f.write(f"    Error:   {failure['error_message']}\n")
                
                f.write(f"{'-' * 70}\n")
        else:
            f.write(f"FAILURES\n")
            f.write(f"{'-' * 70}\n")
            f.write(f"  None\n\n")
        
        f.write(f"{'═' * 70}\n")
        f.write(f"SUMMARY\n")
        f.write(f"{'═' * 70}\n")
        f.write(f"  Source files:     {files_processed}\n")
        f.write(f"  Members scanned:  {stats['scanned']}\n")
        f.write(f"  Added:            {stats['added']}\n")
        f.write(f"  Updated:          {stats['updated']}\n")
        f.write(f"  Unchanged:        {stats['unchanged']}\n")
        f.write(f"  Deleted:          {stats['deleted']}\n")
        f.write(f"  Excluded:         {stats['excluded']}\n")
        f.write(f"  Failed:           {stats['failed']}\n")
        f.write(f"  Elapsed time:     {elapsed}\n")
        f.write(f"{'═' * 70}\n")


def write_sync_log_markdown(target_base: Path, library: str, failures: List[Dict], stats: Dict[str, int], files_processed: int, start_time: datetime, end_time: datetime):
    """Write markdown-formatted sync log file"""
    # Place markdown log in parent directory
    md_log_path = target_base.parent / f"{library.upper()}_sync_log.md"
    elapsed = end_time - start_time
    
    with open(md_log_path, 'w', encoding='utf-8') as f:
        # Header
        f.write(f"# IBM i → Git Source Export Log\n\n")
        f.write(f"## Export Details\n\n")
        f.write(f"| Property | Value |\n")
        f.write(f"|----------|-------|\n")
        f.write(f"| **Library** | `{library.upper()}` |\n")
        f.write(f"| **Target** | `{target_base}` |\n")
        f.write(f"| **Start Time** | {start_time.strftime('%Y-%m-%d %H:%M:%S')} |\n")
        f.write(f"| **End Time** | {end_time.strftime('%Y-%m-%d %H:%M:%S')} |\n")
        f.write(f"| **Elapsed** | {elapsed} |\n\n")
        
        # Summary Stats
        f.write(f"## Summary Statistics\n\n")
        f.write(f"| Metric | Count |\n")
        f.write(f"|--------|------:|\n")
        f.write(f"| Source Files | {files_processed} |\n")
        f.write(f"| Members Scanned | {stats['scanned']} |\n")
        f.write(f"| Added | ✅ {stats['added']} |\n")
        f.write(f"| Updated | 🔄 {stats['updated']} |\n")
        f.write(f"| Unchanged | ⏸️ {stats['unchanged']} |\n")
        f.write(f"| Deleted | ❌ {stats['deleted']} |\n")
        f.write(f"| Excluded | ⊘ {stats['excluded']} |\n")
        f.write(f"| **Failed** | ❗ **{stats['failed']}** |\n\n")
        
        # Failures section
        if failures:
            f.write(f"## ❌ Failures ({len(failures)})\n\n")
            
            for idx, failure in enumerate(failures, 1):
                f.write(f"### {idx}. `{failure['library']}/{failure['srcfile']}.{failure['member']}.{failure['type']}`\n\n")
                f.write(f"- **Target File:** `{failure['target_filename']}`\n")
                f.write(f"- **Reason:** {failure['reason']}\n")
                
                # Include error message if found
                if 'error_message' in failure and failure['error_message']:
                    f.write(f"- **Error:** {failure['error_message']}\n\n")
                else:
                    f.write(f"\n")
                
                f.write(f"---\n\n")
        else:
            f.write(f"## ✅ Failures\n\n")
            f.write(f"No failures occurred during this sync.\n\n")
        
        # Footer
        f.write(f"---\n\n")
        f.write(f"*Generated by IBM i Source Sync - {end_time.strftime('%Y-%m-%d %H:%M:%S')}*\n")


def sync_library(
    library: str,
    target_base: Path,
    source_files: Optional[List[str]] = None,
    dry_run: bool = False,
    verbose: bool = False,
    use_timestamp: bool = False,
    conn = None
):
    """
    Sync entire library or specific source files.
    """
    # Override config with runtime argument
    if use_timestamp:
        Config.USE_TIMESTAMP_COMPARISON = True
    
    start_time = datetime.now()
    
    print(f"\n{'═' * 70}")
    print(f"IBM i → Git Source Export")
    print(f"{'═' * 70}")
    print(f"Library: {library.upper()}")
    print(f"Target:  {target_base}")
    if dry_run:
        print(f"Mode:    DRY RUN (no changes will be made)")
    if Config.USE_TIMESTAMP_COMPARISON:
        print(f"Mode:    TIMESTAMP comparison (faster incremental)")
    print(f"Started: {start_time.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'═' * 70}")
    
    # Load timestamp tracking if enabled (always load/maintain even if not using)
    timestamps = {}
    timestamp_file = target_base / Config.TIMESTAMP_FILE
    if timestamp_file.exists():
        try:
            with open(timestamp_file, 'r', encoding='utf-8') as f:
                timestamps = json.load(f)
            print(f"\n📅 Loaded {len(timestamps)} timestamp entries from cache")
        except Exception as e:
            print(f"\n⚠️  Warning: Could not load timestamps: {e}")
            timestamps = {}
    
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
    
    all_failures = []
    files_processed = 0
    total_files = len(source_files)
    for file_idx, srcfile in enumerate(source_files):
        files_remaining = total_files - file_idx
        target_dir = target_base / srcfile.upper()
        stats = sync_source_file(library, srcfile, target_dir, dry_run, verbose, conn, files_remaining, total_files, all_failures, timestamps)
        
        # Only count files that had members
        if stats['scanned'] > 0:
            files_processed += 1
        
        # Accumulate stats
        for key in total_stats:
            total_stats[key] += stats[key]
    
    # Summary
    end_time = datetime.now()
    elapsed = end_time - start_time
    
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
    print(f"  Elapsed time:     {elapsed}")
    print(f"{'═' * 70}\n")
    
    # Write sync logs
    if not dry_run:
        write_sync_log(target_base, library, all_failures, total_stats, files_processed, start_time, end_time)
        write_sync_log_markdown(target_base, library, all_failures, total_stats, files_processed, start_time, end_time)
        
        # Save timestamp tracking (always maintain even if not using for comparison)
        try:
            target_base.mkdir(parents=True, exist_ok=True)
            with open(timestamp_file, 'w', encoding='utf-8') as f:
                json.dump(timestamps, f, indent=2)
            print(f"📅 Saved {len(timestamps)} timestamp entries to cache\n")
        except Exception as e:
            print(f"⚠️  Warning: Could not save timestamps: {e}\n")
        
        # Ensure .gitignore includes timestamp file
        gitignore_path = target_base / '.gitignore'
        try:
            existing_ignores = set()
            if gitignore_path.exists():
                with open(gitignore_path, 'r', encoding='utf-8') as f:
                    existing_ignores = set(line.strip() for line in f if line.strip() and not line.startswith('#'))
            
            if Config.TIMESTAMP_FILE not in existing_ignores:
                with open(gitignore_path, 'a', encoding='utf-8') as f:
                    if gitignore_path.exists() and gitignore_path.stat().st_size > 0:
                        f.write('\n')
                    f.write(f"# Timestamp cache for incremental syncs\n")
                    f.write(f"{Config.TIMESTAMP_FILE}\n")
        except Exception as e:
            print(f"⚠️  Warning: Could not update .gitignore: {e}\n")
        
        print(f"📄 Sync logs written to:")
        print(f"   - {target_base / f'{library.upper()}_sync_log.txt'}")
        print(f"   - {target_base.parent / f'{library.upper()}_sync_log.md'}\n")
    
    # Return True if there were actual changes (added, updated, or deleted members)
    has_changes = (total_stats['added'] + total_stats['updated'] + total_stats['deleted']) > 0
    return has_changes


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
  
  # Fast incremental sync using timestamps (good for frequent runs)
  python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB --use-timestamp
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
    
    parser.add_argument(
        '--use-timestamp',
        action='store_true',
        help='Use timestamp comparison instead of file content (faster incremental syncs)'
    )
    
    args = parser.parse_args()
    
    # Validate inputs
    target_path = Path(args.target)
    
    # Establish database connection
    print(f"\n🔗 Connecting to database...")
    conn = get_db_connection()
    
    try:
        has_changes = sync_library(
            library=args.library,
            target_base=target_path,
            source_files=args.srcfiles,
            dry_run=args.dry_run,
            verbose=args.verbose,
            use_timestamp=args.use_timestamp,
            conn=conn
        )
        
        # Exit with code indicating if Git commit is needed
        # 0 = changes made (commit needed)
        # 10 = no changes (skip commit)
        if has_changes:
            sys.exit(0)
        else:
            sys.exit(10)
            
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
