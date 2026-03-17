# Member Text Naming Strategy Guide

## Quick Decision Matrix

| Your Situation | Recommendation | Setting |
|---------------|----------------|---------|
| **New project, clean slate** | Include text for readability | `INCLUDE_MEMBER_TEXT = True` |
| **Team uses Tobi or similar** | Include text (matches convention) | `INCLUDE_MEMBER_TEXT = True` |
| **Migrating from older tooling** | Exclude text (exact name match) | `INCLUDE_MEMBER_TEXT = False` |
| **Tools rely on exact member names** | Exclude text | `INCLUDE_MEMBER_TEXT = False` |
| **High churn in member text fields** | Exclude text (avoid renames) | `INCLUDE_MEMBER_TEXT = False` |

## Visual Comparison

### Example Source Members

```
Library: MYLIB
Source File: QRPGLESRC

┌────────────┬──────────┬────────────────────────────────┐
│ Member     │ Type     │ Text                           │
├────────────┼──────────┼────────────────────────────────┤
│ CUSTAPI    │ SQLRPGLE │ Customer API - CRUD operations │
│ ORDPRC     │ RPGLE    │ Order Processor                │
│ INVUPD     │ SQLRPGLE │ Inventory Update               │
│ UTIL       │ RPGLEINC │ Common utilities               │
│ @WORK      │ RPGLE    │ Scratch workspace              │
└────────────┴──────────┴────────────────────────────────┘
```

## Strategy 1: Include Member Text (Tobi-like)

### Configuration
```python
INCLUDE_MEMBER_TEXT = True
TEXT_SEPARATOR = "-"
TEXT_MAX_LENGTH = 40
```

### Result
```
QRPGLESRC/
├── custapi-customer_api_crud_operations.sqlrpgle
├── ordprc-order_processor.rpgle
├── invupd-inventory_update.sqlrpgle
├── util-common_utilities.rpgleinc
└── .metadata.json

(@WORK is excluded by pattern)
```

### Pros
✅ **Self-documenting** – Filename tells you what it does  
✅ **Grep-friendly** – Search by description: `ls *customer*`  
✅ **Team-friendly** – New devs understand code structure  
✅ **Matches Tobi** – Familiar to Tobi users  

### Cons
⚠️ **Longer names** – Can be unwieldy in some tools  
⚠️ **Git renames** – Changing text = rename in Git history  
⚠️ **Name mapping** – Tools must strip text to get member name  

### Best For
- New projects
- Large teams
- Code shared across dev/ops
- When member names are cryptic (e.g., `PRCR001`)

---

## Strategy 2: Member Name Only (Classic)

### Configuration
```python
INCLUDE_MEMBER_TEXT = False
TEXT_SEPARATOR = "-"  # (ignored)
TEXT_MAX_LENGTH = 40  # (ignored)
```

### Result
```
QRPGLESRC/
├── custapi.sqlrpgle
├── ordprc.rpgle
├── invupd.sqlrpgle
├── util.rpgleinc
└── .metadata.json
```

### Pros
✅ **Exact match** – Filename = member name  
✅ **Stable** – Text changes don't affect Git  
✅ **Shorter** – Easier to type/reference  
✅ **Tool-friendly** – Old scripts work as-is  

### Cons
⚠️ **Less descriptive** – Must check member text separately  
⚠️ **Cryptic names** – `PGM001.rpgle` tells you nothing  

### Best For
- Migrating from ARCAD, Turnover, etc.
- Tools that expect exact member names
- Teams with strict naming conventions (e.g., `CUS_API_01`)

---

## Strategy 3: Hybrid (Custom Separator)

### Configuration
```python
INCLUDE_MEMBER_TEXT = True
TEXT_SEPARATOR = "--"  # Double dash
TEXT_MAX_LENGTH = 30   # Shorter text
```

### Result
```
QRPGLESRC/
├── custapi--customer_api_crud.sqlrpgle
├── ordprc--order_processor.rpgle
├── invupd--inventory_update.sqlrpgle
├── util--common_utilities.rpgleinc
└── .metadata.json
```

### When to Use
- Visual distinction between name and text
- Easier parsing in scripts: `MEMBER="${filename%%--*}"`

---

## Text Sanitization Examples

### Input → Output Mapping

| Original Member Text | Sanitized (40 chars) |
|---------------------|----------------------|
| `Customer API` | `customer_api` |
| `Build - Production Version` | `build_production_version` |
| `Test (DO NOT USE)` | `test_do_not_use` |
| `Web Service - JSON REST API v2` | `web_service_json_rest_api_v2` |
| `This is a really long description that goes way beyond the limit` | `this_is_a_really_long_description_th` |
| ` ` (blank) | *(text omitted - just `member.ext`)* |
| `ABC-123` | `abc_123` |
| `Français (été)` | `fran_ais_t` |

### Rules
1. Lowercase
2. Replace `[^a-z0-9]` with `_`
3. Collapse multiple `_` to single
4. Strip leading/trailing `_`
5. Truncate to `TEXT_MAX_LENGTH`

---

## Switching Strategies Mid-Project

### ⚠️ WARNING: This rewrites Git history

If you change `INCLUDE_MEMBER_TEXT` after commits:

**Before:**
```
custapi.sqlrpgle
ordprc.rpgle
```

**After:**
```
custapi-customer_api_crud_operations.sqlrpgle
ordprc-order_processor.rpgle
```

**Git sees this as:**
- Delete `custapi.sqlrpgle`
- Add `custapi-customer_api_crud_operations.sqlrpgle`

Every file is "renamed" in Git history.

### Recovery Plan

If you must switch:

1. **Announce** to team (Git pull before you start)
2. **Delete all IFS files**:
   ```bash
   rm -rf /home/GitRepos/MYLIB/*
   ```
3. **Update config** in script
4. **Run sync**
5. **Commit as "Restructure"**:
   ```bash
   git add -A
   git commit -m "Restructure: add member text to filenames"
   ```
6. **Tell team** to pull and handle merge conflicts

**Better:** Decide before first sync.

---

## Testing Before Commit

### Side-by-Side Preview

```bash
# Test with text
vim sync_ibmi_to_git.py  # Set INCLUDE_MEMBER_TEXT = True
python3 sync_ibmi_to_git.py --library MYLIB --target /tmp/with_text --dry-run

# Test without text
vim sync_ibmi_to_git.py  # Set INCLUDE_MEMBER_TEXT = False
python3 sync_ibmi_to_git.py --library MYLIB --target /tmp/no_text --dry-run

# Compare
ls -l /tmp/with_text/QRPGLESRC/
ls -l /tmp/no_text/QRPGLESRC/
```

Pick the one that makes sense for your team, then run for real.

---

## Parsing Filenames Back to Members

### With Text (extract member name)

```bash
# Bash
filename="custapi-customer_api_crud_operations.sqlrpgle"
member="${filename%%-*}"  # custapi
ext="${filename##*.}"      # sqlrpgle

# Python
import re
match = re.match(r'^([^-]+)(?:-.*)?\.(.+)$', filename)
member = match.group(1).upper()  # CUSTAPI
ext = match.group(2)              # sqlrpgle
```

### Without Text (direct map)

```bash
# Bash
filename="custapi.sqlrpgle"
member="${filename%.*}"  # custapi
ext="${filename##*.}"     # sqlrpgle

# Python
member, ext = filename.rsplit('.', 1)
member = member.upper()  # CUSTAPI
```

---

## Recommendation Summary

**Default recommendation: `INCLUDE_MEMBER_TEXT = True`**

Why:
- Git is for humans, not just compilers
- Member text exists for a reason - use it
- Most IBM i shops have descriptive text fields
- Easier onboarding for new devs

**Exception:** Use `False` if you have existing tooling that expects exact member names.

**Don't** flip-flop. Pick once and commit.

---

## Questions?

**"What if some members have no text?"**  
→ Falls back to `member.ext` (no dash, no empty text)

**"What if two members have the same name+text?"**  
→ Impossible - IBM i enforces unique member names per source file

**"What if text has Unicode?"**  
→ Sanitized to ASCII alphanumeric + `_`

**"Can I use a different separator like `.` or `_`?"**  
→ Yes, change `TEXT_SEPARATOR`. Avoid `.` (conflicts with extension)

**"What about Git LFS for large sources?"**  
→ Source members are tiny (<100KB typically). LFS unnecessary.

**"Can I version member text changes?"**  
→ With `INCLUDE_MEMBER_TEXT = True`, yes (rename shows in Git history)  
→ With `False`, no (text changes are invisible to Git)
