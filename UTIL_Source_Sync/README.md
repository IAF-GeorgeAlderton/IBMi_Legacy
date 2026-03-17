# IBM i → Git Source Exporter

One-way sync of IBM i source members to Git-ready IFS directory structure.

## Quick Start

```bash
# Export entire library
python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB

# Dry run first (recommended)
python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB --dry-run

# Export specific source files
python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB \
    --srcfiles QRPGLESRC QCLSRC QSRVSRC

# Verbose output (see unchanged files)
python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB --verbose
```

## Features

✅ **Content-based change detection** – Only updates files when content differs  
✅ **UTF-8 + LF normalization** – Git-friendly encoding and line endings  
✅ **Member text in filenames** – Tobi-like naming: `member-description.ext`  
✅ **Orphan cleanup** – Removes IFS files for deleted members  
✅ **Exclusion patterns** – Skip temp/backup members  
✅ **Metadata tracking** – JSON manifest per source file  
✅ **Dry run mode** – Preview changes before committing  

## Directory Structure

```
/home/GitRepos/MYLIB/
├── QRPGLESRC/
│   ├── custapi-customer_api.sqlrpgle
│   ├── ordprc-order_processor.rpgle
│   ├── .metadata.json
├── QCLSRC/
│   ├── build-compile_all.clle
│   ├── deploy-deploy_to_prod.clle
│   ├── .metadata.json
└── QSRVSRC/
    ├── custsrv-customer_service.sqlrpgle
    ├── .metadata.json
```

## Member Text Handling

### Configuration Options

Edit the `Config` class at the top of `sync_ibmi_to_git.py`:

```python
class Config:
    # Member text in filename (Tobi-like)
    INCLUDE_MEMBER_TEXT = True    # True = NAME-text.ext, False = NAME.ext
    TEXT_SEPARATOR = "-"           # Separator between name and text
    TEXT_MAX_LENGTH = 40           # Max length of text portion
```

### Naming Examples

Given a source member:
- **Name**: `CUSTAPI`
- **Type**: `SQLRPGLE`
- **Text**: `Customer API - CRUD operations`

#### With `INCLUDE_MEMBER_TEXT = True`:
```
custapi-customer_api_crud_operations.sqlrpgle
```

#### With `INCLUDE_MEMBER_TEXT = False`:
```
custapi.sqlrpgle
```

### Text Sanitization Rules

Member text is made filesystem-safe:
1. Converted to lowercase
2. Non-alphanumeric characters → `_`
3. Multiple underscores collapsed to one
4. Trimmed to `TEXT_MAX_LENGTH` characters
5. Leading/trailing underscores removed

| Original Text | Sanitized |
|--------------|-----------|
| `Customer API` | `customer_api` |
| `Build - Production` | `build_production` |
| `Test (DO NOT USE)` | `test_do_not_use` |
| ` ` (empty) | *(omitted)* |

### Why Include Member Text?

**Advantages:**
- ✅ Self-documenting filenames
- ✅ Easier to browse in file explorer
- ✅ Matches Tobi conventions
- ✅ Useful for teams unfamiliar with member names

**Disadvantages:**
- ⚠️ Longer filenames
- ⚠️ Git history shows renames if text changes
- ⚠️ Some tools rely on exact member name

**Recommendation:**  
Use `INCLUDE_MEMBER_TEXT = True` for new projects.  
Use `False` if migrating from existing tools that expect exact names.

## Trailing Space Handling

```python
class Config:
    STRIP_TRAILING_SPACES = True  # False = preserve exactly
```

**⚠️ CRITICAL:** Pick one policy and never change it. Flipping this mid-project rewrites your entire Git history.

### Recommendation by Source Type

| Source Type | Recommendation | Reason |
|------------|----------------|---------|
| **Free RPG** (`**FREE`) | `STRIP_TRAILING_SPACES = True` | No fixed columns; trailing spaces are noise |
| **Fixed RPG** (col 6-80) | `STRIP_TRAILING_SPACES = False` | May need exact column alignment |
| **CL** | `True` | No column dependency |
| **SQL** | `True` | No column dependency |
| **DDS** | `False` | Position-sensitive |

**Best practice:** Use `True` unless you have a specific reason to preserve trailing spaces.

## Exclusion Patterns

Edit `Config.EXCLUDE_PATTERNS` to skip members:

```python
EXCLUDE_PATTERNS = [
    r'^@.*',      # @WORK, @START, etc.
    r'^#.*',      # Temp markers
    r'^\$.*',     # System temp
    r'.*_BAK$',   # Backup files
    r'.*_OLD$',   # Old versions
]
```

Patterns are Python regex, case-insensitive.

## File Extensions

The script maps source types to extensions:

```python
EXTENSIONS = {
    'RPGLE': 'rpgle',
    'SQLRPGLE': 'sqlrpgle',
    'RPGLEINC': 'rpgleinc',
    'CLLE': 'clle',
    'CMD': 'cmd',
    'DSPF': 'dspf',
    'PF': 'pf',
    'LF': 'lf',
    'BND': 'bnd',
    # ... add more as needed
}
```

Unknown types default to `.txt`.

## CPYTOSTMF Parameters

```python
STMFCCSID = 1208        # UTF-8
ENDLINFMT = "*LF"       # LF line endings (not CRLF)
STMFOPT = "*REPLACE"    # Replace if exists
DBFCCSID = "*FILE"      # Use source file's CCSID
```

**⚠️ DO NOT CHANGE** these mid-project. Git will see every file as changed.

## Metadata Files

Each source file directory gets a `.metadata.json`:

```json
{
  "source_library": "MYLIB",
  "source_file": "QRPGLESRC",
  "last_sync": "2026-03-17T14:32:00Z",
  "member_count": 47,
  "stats": {
    "scanned": 52,
    "excluded": 3,
    "exported": 12,
    "unchanged": 35,
    "failed": 2
  },
  "config": {
    "strip_trailing_spaces": true,
    "include_member_text": true,
    "stmfccsid": 1208,
    "endlinfmt": "*LF"
  }
}
```

Useful for:
- Auditing syncs
- Debugging discrepancies
- Tool integrations

## Workflow

1. **Initial export** (dry run):
   ```bash
   python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB --dry-run
   ```

2. **Review** what will be created/updated

3. **Real run**:
   ```bash
   python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB
   ```

4. **Git commit**:
   ```bash
   cd /home/GitRepos/MYLIB
   git add .
   git commit -m "Sync from IBM i"
   git push
   ```

5. **Schedule** (optional):
   ```bash
   # Add to crontab or use SBMJOB for periodic sync
   */30 * * * * /QOpenSys/pkgs/bin/python3 /path/to/sync_ibmi_to_git.py \
       --library MYLIB --target /home/GitRepos/MYLIB
   ```

## Dry Run Mode

**Always test with `--dry-run` first:**

```bash
python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB --dry-run
```

Output shows:
- `⋯ member → filename (would create)` – New file
- `⋯ member → filename (would update)` – Changed content
- `⊗ filename (would delete)` – Orphaned file

No changes are made to the IFS.

## Testing Different Text Strategies

Want to preview different naming schemes?

1. **Test with text**:
   ```python
   INCLUDE_MEMBER_TEXT = True
   ```
   ```bash
   python3 sync_ibmi_to_git.py --library MYLIB --target /tmp/test_with_text --dry-run
   ```

2. **Test without text**:
   ```python
   INCLUDE_MEMBER_TEXT = False
   ```
   ```bash
   python3 sync_ibmi_to_git.py --library MYLIB --target /tmp/test_no_text --dry-run
   ```

3. **Compare** the output and pick your preference

4. **Commit to one approach** before your first real sync

## Performance

Typical performance on IBM i:
- **10 members**: ~3 seconds
- **100 members**: ~20 seconds
- **1000 members**: ~3 minutes

Most time is spent in:
1. `CPYTOSTMF` (unavoidable)
2. Content comparison (UTF-8 file reads)

**Optimization tip:** Content comparison only happens if the file already exists. First sync is fastest.

## Troubleshooting

### "No members found"

**Cause:** Library or source file doesn't exist, or no authority.

**Fix:**
```bash
# Verify library exists
system "DSPLIB MYLIB"

# Verify authority
system "DSPOBJAUT OBJ(MYLIB/*ALL) OBJTYPE(*FILE)"
```

### "Export failed"

**Cause:** CPYTOSTMF error (authority, CCSID conversion, etc.)

**Debug:**
```bash
# Try manual export
CPYTOSTMF FROMMBR('/QSYS.LIB/MYLIB.LIB/QRPGLESRC.FILE/MYMEMBER.MBR') +
           TOSTMF('/tmp/test.txt') +
           STMFOPT(*REPLACE) +
           STMFCCSID(1208) +
           ENDLINFMT(*LF)
```

Check joblog for specific error.

### "Files are always exported (never 'unchanged')"

**Cause:** Inconsistent normalization (trailing spaces, line endings).

**Fix:** 
1. Delete all IFS files
2. Run sync again
3. Second run should show all files as "unchanged"

If still happening, check:
- `STRIP_TRAILING_SPACES` is consistent
- `CPYTOSTMF` parameters haven't changed
- No manual edits to IFS files

## Git Best Practices

### .gitignore

Add to `/home/GitRepos/MYLIB/.gitignore`:

```gitignore
# Metadata files (optional - can commit these for audit trail)
**/.metadata.json

# Temp files
*.tmp
*~
```

### .gitattributes

Force LF on checkout (Windows safety):

```gitattributes
* text=auto eol=lf
*.rpgle text eol=lf
*.sqlrpgle text eol=lf
*.clle text eol=lf
*.cmd text eol=lf
```

### Commit Messages

Automated sync:
```bash
git commit -m "Sync from IBM i: $(date +'%Y-%m-%d %H:%M')"
```

Manual sync with context:
```bash
git commit -m "Sync: Added new CUSTAPI module and updated order processing"
```

## Future: Git → IBM i Import

This script is one-way (IBM i → Git) only.

For bidirectional sync, you'll need:
1. Parse Git changes (added/modified/deleted files)
2. Map filenames back to members (handle text portion)
3. Use `CPYFRMSTMF` to import
4. Handle compile dependencies
5. Conflict resolution strategy

**Hold off on this until export is proven stable.**

## CL Wrapper (Optional)

For scheduling or ops integration:

```cl
PGM

    CHGCURDIR DIR('/path/to/sync_script')

    CALL PGM(QP2SHELL) +
         PARM('/QOpenSys/pkgs/bin/python3' +
              'sync_ibmi_to_git.py' +
              '--library' 'MYLIB' +
              '--target' '/home/GitRepos/MYLIB')

    IF COND(&RETURNED_STATUS *NE 0) THEN(DO)
        SNDMSG MSG('Git sync failed - check joblog') +
               TOUSR(QSYSOPR)
    ENDDO

ENDPGM
```

## License

[Your choice - MIT, Apache 2.0, etc.]

## Support

Issues? Questions?  
Open a GitHub issue or contact [your team/email].
