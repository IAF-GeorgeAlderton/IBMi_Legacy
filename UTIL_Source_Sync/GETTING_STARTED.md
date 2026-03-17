# Getting Started Checklist

Complete this checklist before your first sync to avoid rework.

## ☐ 1. Prerequisites

### IBM i Environment
```bash
# Check Python 3 is installed
python3 --version  # Should be 3.6+

# Check db2 CLI is available
which db2

# Test QSYS2 access
db2 "SELECT * FROM QSYS2.SYSTABLES WHERE TABLE_SCHEMA = 'QSYS2' FETCH FIRST 1 ROWS ONLY"
```

### IFS Directory
```bash
# Create target directory
mkdir -p /home/GitRepos/MYLIB

# Check write permission
touch /home/GitRepos/MYLIB/test.txt && rm /home/GitRepos/MYLIB/test.txt
```

### Git (optional for later)
```bash
# Check Git is installed
git --version

# Initialize repo (if not already)
cd /home/GitRepos/MYLIB
git init
```

---

## ☐ 2. Configure the Script

### Open for editing
```bash
vim sync_ibmi_to_git.py
# or use VS Code, VS Code for i, etc.
```

### Make these decisions:

#### A. Member Text in Filenames?
```python
INCLUDE_MEMBER_TEXT = True  # ← DECISION: True or False?
```
- **True** = `custapi-customer_api.sqlrpgle` (Tobi-like)
- **False** = `custapi.sqlrpgle` (classic)

See [NAMING_STRATEGY.md](NAMING_STRATEGY.md) for guidance.

**Your choice:** _____________

---

#### B. Trailing Spaces?
```python
STRIP_TRAILING_SPACES = True  # ← DECISION: True or False?
```
- **True** = Strip trailing spaces (recommended for free-format)
- **False** = Preserve exactly (for fixed-format)

**Your choice:** _____________

⚠️ **Never change this after first sync** or Git sees every file as changed.

---

#### C. Exclusion Patterns?
```python
EXCLUDE_PATTERNS = [
    r'^@.*',      # @WORK, @START
    r'^#.*',      # #TEMP
    r'^\$.*',     # $SCRATCH
    r'.*_BAK$',   # Backups
    r'.*_OLD$',   # Old versions
]
```

**Add your patterns:** (Examples: `r'^TEST.*'`, `r'.*_SAVE$'`)
```python




```

---

#### D. File Extensions?
```python
EXTENSIONS = {
    'RPGLE': 'rpgle',
    'SQLRPGLE': 'sqlrpgle',
    # ...
}
```

**Add custom types if needed:**
```python
'RPGLE38': 'rpgle',     # Custom type
'MYTYPE': 'txt',        # Unknown → txt
```

---

## ☐ 3. Preview with Dry Run

```bash
# Test on a small source file first
python3 sync_ibmi_to_git.py \
    --library MYLIB \
    --target /home/GitRepos/MYLIB \
    --srcfiles QRPGLESRC \
    --dry-run
```

### Check the output:
- [ ] Are filenames what you expected?
- [ ] Are exclusions working correctly?
- [ ] Are extensions correct?

**If not, go back to step 2 and adjust.**

---

## ☐ 4. Test Real Sync (Small Batch)

```bash
# Sync ONE source file for real
python3 sync_ibmi_to_git.py \
    --library MYLIB \
    --target /home/GitRepos/MYLIB \
    --srcfiles QRPGLESRC
```

### Verify the results:
```bash
# List created files
ls -la /home/GitRepos/MYLIB/QRPGLESRC/

# Check a file
cat /home/GitRepos/MYLIB/QRPGLESRC/somemember.sqlrpgle

# Check encoding
file /home/GitRepos/MYLIB/QRPGLESRC/*.sqlrpgle
# Should say "UTF-8 Unicode text"

# Check line endings
od -c /home/GitRepos/MYLIB/QRPGLESRC/*.sqlrpgle | head -20
# Should see \n (LF), not \r\n (CRLF)
```

**Issues?** See [Troubleshooting](#troubleshooting) below.

---

## ☐ 5. Test Unchanged Detection

```bash
# Run sync again - should show all files as "unchanged"
python3 sync_ibmi_to_git.py \
    --library MYLIB \
    --target /home/GitRepos/MYLIB \
    --srcfiles QRPGLESRC \
    --verbose
```

### Expected output:
```
📂 QRPGLESRC
   =  CUSTAPI → custapi-customer_api.sqlrpgle (unchanged)
   =  ORDPRC → ordprc-order_processor.rpgle (unchanged)
   ...
```

**If files show as "updated" on second run:**
- ⚠️ Normalization is inconsistent
- Fix: Delete all files and re-sync
- See [README.md - Troubleshooting](README.md#troubleshooting)

---

## ☐ 6. Test Change Detection

```bash
# Edit a member on IBM i
STRSEU SRCFILE(MYLIB/QRPGLESRC) SRCMBR(CUSTAPI)
# Add a comment or blank line, save

# Run sync again
python3 sync_ibmi_to_git.py \
    --library MYLIB \
    --target /home/GitRepos/MYLIB \
    --srcfiles QRPGLESRC
```

### Expected output:
```
📂 QRPGLESRC
   ✓  CUSTAPI → custapi-customer_api.sqlrpgle
   =  ORDPRC → ordprc-order_processor.rpgle (unchanged)
   ...
```

Only CUSTAPI should show as updated.

**Verify:**
```bash
# Check file was updated
ls -l /home/GitRepos/MYLIB/QRPGLESRC/custapi*.sqlrpgle
# Timestamp should be recent
```

---

## ☐ 7. Test Orphan Cleanup

```bash
# Delete a member on IBM i
RMVM FILE(MYLIB/QRPGLESRC) MBR(TESTMBR)

# Run sync
python3 sync_ibmi_to_git.py \
    --library MYLIB \
    --target /home/GitRepos/MYLIB \
    --srcfiles QRPGLESRC
```

### Expected output:
```
📂 QRPGLESRC
   ⊗  testmbr.sqlrpgle (deleted - no matching member)
```

File should be removed from IFS.

---

## ☐ 8. Full Library Sync

If all tests passed, sync the whole library:

```bash
# Dry run entire library
python3 sync_ibmi_to_git.py \
    --library MYLIB \
    --target /home/GitRepos/MYLIB \
    --dry-run

# Review counts - make sense?

# Real run
python3 sync_ibmi_to_git.py \
    --library MYLIB \
    --target /home/GitRepos/MYLIB
```

---

## ☐ 9. Initialize Git Repo

```bash
cd /home/GitRepos/MYLIB

# Create .gitignore
cat > .gitignore << 'EOF'
# Temp files
*.tmp
*~

# Metadata (optional - can commit for audit trail)
# **/.metadata.json
EOF

# Create .gitattributes (enforce LF)
cat > .gitattributes << 'EOF'
* text=auto eol=lf
*.rpgle text eol=lf
*.sqlrpgle text eol=lf
*.clle text eol=lf
*.cmd text eol=lf
*.dspf text eol=lf
*.prtf text eol=lf
EOF

# Initialize Git
git init

# First commit
git add .
git commit -m "Initial import from IBM i"
```

---

## ☐ 10. Set Up Remote (Optional)

```bash
# Add GitHub/GitLab/Bitbucket remote
git remote add origin https://github.com/yourorg/mylib.git

# Or Azure DevOps
git remote add origin https://dev.azure.com/yourorg/myrepo

# Push
git push -u origin main
```

---

## ☐ 11. Schedule Regular Syncs (Optional)

### Option A: Cron (simple)
```bash
# Edit crontab
crontab -e

# Add line (sync every 30 minutes)
*/30 * * * * /QOpenSys/pkgs/bin/python3 /path/to/sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB >> /home/logs/git_sync.log 2>&1
```

### Option B: CL Program (IBM i native)
```cl
PGM

    CHGCURDIR DIR('/path/to/script')

    CALL PGM(QP2SHELL) +
         PARM('/QOpenSys/pkgs/bin/python3' +
              'sync_ibmi_to_git.py' +
              '--library' 'MYLIB' +
              '--target' '/home/GitRepos/MYLIB')

ENDPGM
```

Schedule with:
```
ADDJOBSCDE JOB(GITSYNC) +
           CMD(CALL PGM(GITSYNCCL)) +
           FRQ(*HOURLY)
```

### Option C: Jenkins/CI (advanced)
- Set up Jenkins job
- Poll Git or run on schedule
- Automatic commit + push

---

## ☐ 12. Document Your Choices

**Create a `SYNC_CONFIG.md` in your repo:**

```markdown
# Sync Configuration

**Library:** MYLIB  
**Target:** /home/GitRepos/MYLIB  
**Sync Frequency:** Every 30 minutes  

## Decisions

- **Member text in filenames:** YES (Tobi-like)
- **Trailing spaces:** Stripped
- **Exclusions:** @*, #*, *_BAK, *_OLD
- **Encoding:** UTF-8, LF line endings

## Never Change

These settings are locked-in (would rewrite Git history):
- ✓ INCLUDE_MEMBER_TEXT
- ✓ STRIP_TRAILING_SPACES  
- ✓ CPYTOSTMF parameters

## Contacts

- **Owner:** [Your Name]
- **Questions:** [Team chat/email]
```

Commit this to Git so the team knows the rules.

---

## Troubleshooting

### Python not found
```bash
# Install Python 3 from IBM i Access Client Solutions
# Or use yum
yum install python3
```

### db2 not found
```bash
# Add to PATH
export PATH=/QOpenSys/pkgs/bin:$PATH

# Or use full path in script
/QOpenSys/pkgs/bin/db2
```

### "No members found"
- Check library name (case-insensitive, but must exist)
- Check authority: `DSPOBJAUT OBJ(MYLIB/*ALL) OBJTYPE(*FILE)`
- Try manual query:
  ```bash
  db2 "SELECT * FROM QSYS2.SYSPARTITIONSTAT WHERE SYSTEM_TABLE_SCHEMA = 'MYLIB' FETCH FIRST 5 ROWS ONLY"
  ```

### "Export failed"
- Check CPYTOSTMF manually:
  ```
  CPYTOSTMF FROMMBR('/QSYS.LIB/MYLIB.LIB/QRPGLESRC.FILE/TEST.MBR') +
             TOSTMF('/tmp/test.txt') +
             STMFOPT(*REPLACE) +
             STMFCCSID(1208) +
             ENDLINFMT(*LF)
  ```
- Check joblog: `DSPJOBLOG`

### Files always show as "updated"
- Normalization issue (trailing spaces, line endings)
- **Fix:** Delete all IFS files, re-sync
- Second sync should show "unchanged"

### Git shows huge diffs
- Check line endings: `git config core.autocrlf false`
- Check .gitattributes is in place
- Run `git diff` to see what changed

---

## ✅ You're Ready!

Once you've completed this checklist:
- ✓ Script is configured
- ✓ Dry run tested
- ✓ Change detection works
- ✓ Orphan cleanup works
- ✓ Git repo initialized

**Next steps:**
1. Run regular syncs (manual or scheduled)
2. Train team on workflow
3. Document any custom exclusions or extensions
4. Plan for future Git → IBM i import phase

---

## Need Help?

- **Documentation:** [README.md](README.md)
- **Naming Guide:** [NAMING_STRATEGY.md](NAMING_STRATEGY.md)
- **Issues:** [GitHub issues / your team chat]
