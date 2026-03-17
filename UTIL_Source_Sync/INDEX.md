# IBM i → Git Source Sync Utility

Complete solution for one-way sync of IBM i source members to Git-ready directory structure.

## 📁 Files in This Directory

| File | Purpose | Read When |
|------|---------|-----------|
| **[GETTING_STARTED.md](GETTING_STARTED.md)** | Step-by-step setup checklist | 👈 **START HERE** |
| **[README.md](README.md)** | Complete reference documentation | After setup, for reference |
| **[NAMING_STRATEGY.md](NAMING_STRATEGY.md)** | Member text naming guide | Choosing filename format |
| **[sync_ibmi_to_git.py](sync_ibmi_to_git.py)** | The Python script | Edit to configure |
| **INDEX.md** (this file) | Overview and navigation | You are here |

## 🚀 Quick Start (5 minutes)

```bash
# 1. Copy script to IBM i
scp sync_ibmi_to_git.py user@ibmi:/path/to/script/

# 2. SSH to IBM i
ssh user@ibmi

# 3. Edit configuration
vim /path/to/script/sync_ibmi_to_git.py
# Set INCLUDE_MEMBER_TEXT and STRIP_TRAILING_SPACES

# 4. Dry run test
python3 sync_ibmi_to_git.py \
    --library MYLIB \
    --target /home/GitRepos/MYLIB \
    --dry-run

# 5. Real sync
python3 sync_ibmi_to_git.py \
    --library MYLIB \
    --target /home/GitRepos/MYLIB

# 6. Initialize Git
cd /home/GitRepos/MYLIB
git init
git add .
git commit -m "Initial import from IBM i"
```

## 🎯 Key Features

✅ **Content-based change detection** – Only updates when content differs  
✅ **UTF-8 + LF normalization** – Git-friendly encoding  
✅ **Tobi-like naming** – Optional member text in filenames  
✅ **Orphan cleanup** – Removes deleted members automatically  
✅ **Dry run mode** – Preview before committing  
✅ **Metadata tracking** – JSON manifest per source file  

## 📖 Documentation Map

### First Time Setup

1. **Read:** [GETTING_STARTED.md](GETTING_STARTED.md) – Complete checklist
2. **Decide:** [NAMING_STRATEGY.md](NAMING_STRATEGY.md) – Filename format
3. **Configure:** Edit `sync_ibmi_to_git.py` (Config class at top)
4. **Test:** Run with `--dry-run`
5. **Deploy:** Run for real

### Daily Use

- **Sync command:**
  ```bash
  python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB
  ```

- **Troubleshooting:** See [README.md - Troubleshooting](README.md#troubleshooting)

### Reference

- **All options:** [README.md](README.md)
- **Config guide:** See `Config` class in `sync_ibmi_to_git.py` (lines 15-60)
- **Text handling:** [NAMING_STRATEGY.md](NAMING_STRATEGY.md)

## ⚙️ Configuration Quick Reference

Edit these in `sync_ibmi_to_git.py`:

```python
class Config:
    # Member text in filenames (Tobi-like)
    INCLUDE_MEMBER_TEXT = True    # True = name-text.ext, False = name.ext
    TEXT_SEPARATOR = "-"
    TEXT_MAX_LENGTH = 40
    
    # Trailing space handling
    STRIP_TRAILING_SPACES = True  # True = strip, False = preserve
    
    # Exclusion patterns
    EXCLUDE_PATTERNS = [
        r'^@.*',      # @WORK, @START
        r'^#.*',      # Temp markers
        r'.*_BAK$',   # Backups
    ]
```

## 🌳 Directory Structure

### On IBM i (before)
```
MYLIB
├── QRPGLESRC (source file)
│   ├── CUSTAPI (member)
│   ├── ORDPRC (member)
│   └── INVUPD (member)
└── QCLSRC (source file)
    ├── BUILD (member)
    └── DEPLOY (member)
```

### On IFS (after sync)
```
/home/GitRepos/MYLIB/
├── QRPGLESRC/
│   ├── custapi-customer_api.sqlrpgle
│   ├── ordprc-order_processor.rpgle
│   ├── invupd-inventory_update.sqlrpgle
│   └── .metadata.json
└── QCLSRC/
    ├── build-compile_all.clle
    ├── deploy-deploy_to_prod.clle
    └── .metadata.json
```

## 🔄 Typical Workflow

### Initial Setup
```bash
# Configure script
vim sync_ibmi_to_git.py

# Test
python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB --dry-run

# Sync
python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB

# Git
cd /home/GitRepos/MYLIB
git init
git add .
git commit -m "Initial import"
git remote add origin https://github.com/yourorg/mylib.git
git push -u origin main
```

### Daily/Scheduled Sync
```bash
# Sync (manual or cron)
python3 sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB

# Commit & push
cd /home/GitRepos/MYLIB
git add .
git commit -m "Sync from IBM i: $(date +'%Y-%m-%d %H:%M')"
git push
```

## 🤔 Common Questions

### "Which naming strategy should I use?"

**New project?** Use `INCLUDE_MEMBER_TEXT = True` (Tobi-like)  
**Migrating from old tools?** Use `INCLUDE_MEMBER_TEXT = False` (classic)

See [NAMING_STRATEGY.md](NAMING_STRATEGY.md) for detailed comparison.

### "Can I change settings later?"

⚠️ **NO** for these (rewrites Git history):
- `INCLUDE_MEMBER_TEXT`
- `STRIP_TRAILING_SPACES`
- CPYTOSTMF parameters

✅ **YES** for these (safe to change):
- `EXCLUDE_PATTERNS`
- `TEXT_MAX_LENGTH`
- `TEXT_SEPARATOR`

### "How do I schedule syncs?"

**Cron (simple):**
```bash
*/30 * * * * python3 /path/to/sync_ibmi_to_git.py --library MYLIB --target /home/GitRepos/MYLIB
```

**IBM i job scheduler (native):**
```
ADDJOBSCDE JOB(GITSYNC) CMD(CALL PGM(SYNCGITCL)) FRQ(*HOURLY)
```

See [README.md - CL Wrapper](README.md#cl-wrapper-optional) for full example.

### "What about Git → IBM i import?"

This script is **one-way only** (IBM i → Git).

Bidirectional sync requires:
- Parsing Git changes
- Mapping filenames back to members
- CPYFRMSTMF with compile
- Conflict resolution

**Recommendation:** Wait until export is proven stable before attempting import.

### "Does this work with Tobi?"

Yes! If you set `INCLUDE_MEMBER_TEXT = True`, filenames match Tobi's format:
```
member-description.ext
```

Tobi users will feel right at home.

## 🛠️ Troubleshooting Quick Reference

| Problem | Solution |
|---------|----------|
| Python not found | `yum install python3` or add to PATH |
| "No members found" | Check library name, authority, QSYS2 access |
| "Export failed" | Test CPYTOSTMF manually, check joblog |
| Files always "updated" | Delete IFS files, re-sync (normalization issue) |
| Git shows huge diffs | Check line endings, .gitattributes |

Full troubleshooting: [README.md - Troubleshooting](README.md#troubleshooting)

## 📋 Pre-Flight Checklist

Before first sync:

- [ ] Python 3 installed on IBM i
- [ ] db2 CLI available
- [ ] Target IFS directory exists and writable
- [ ] Configured `INCLUDE_MEMBER_TEXT`
- [ ] Configured `STRIP_TRAILING_SPACES`
- [ ] Reviewed exclusion patterns
- [ ] Tested with `--dry-run`
- [ ] Verified one source file syncs correctly
- [ ] Checked unchanged detection works

See [GETTING_STARTED.md](GETTING_STARTED.md) for full checklist.

## 🎓 Learning Path

**Beginner (just trying it out):**
1. [GETTING_STARTED.md](GETTING_STARTED.md) steps 1-4
2. Run on single source file
3. Review output

**Intermediate (deploying to production):**
1. Complete [GETTING_STARTED.md](GETTING_STARTED.md) checklist
2. Read [NAMING_STRATEGY.md](NAMING_STRATEGY.md)
3. Configure exclusions and extensions
4. Set up Git repo with .gitignore and .gitattributes

**Advanced (automation):**
1. Study [README.md](README.md) fully
2. Write CL wrapper or cron job
3. Integrate with CI/CD
4. Plan Git → IBM i import strategy

## 📞 Support

- **Documentation bugs:** Open issue or PR
- **Usage questions:** [Your team chat/email]
- **Feature requests:** [Your issue tracker]

## 📄 License

[Your choice - MIT, Apache 2.0, etc.]

---

**Ready to get started?** → [GETTING_STARTED.md](GETTING_STARTED.md)
