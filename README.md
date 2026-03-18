# IBM i Legacy Source Sync (HSRC1 → Git)

This repository is a **one-way mirror of IBM i source** from library **`HSRC1`** into Git.

It contains:
- **`HSRC1/`**: exported IBM i source members (the mirrored content)
- **`UTIL_Source_Sync/`**: the Python/Bash tooling that exports to the IFS and pushes changes to Git
- **`HSRC1_sync_log.md`**: a summary report from the most recent sync run

---

## HSRC1 (source mirror)

**HSRC1 is a one-way download of changed IBM i source members from library `HSRC1`.**

The exported source is stored under `HSRC1/`, typically organized by:
- source physical file (e.g., `ARPGSRC`, `ADSPSRC`, etc.)
- member exported as a stream file (e.g., `.RPG`, `.DSPF`, etc.)

> This repo is intended as an **IBM i → Git export**. It is not a bidirectional sync.

---

## UTIL_Source_Sync (sync tooling)

**`UTIL_Source_Sync` contains the Python/Bash code that:**
1. Scans IBM i source members in a library (e.g., `HSRC1`)
2. Exports members to the IFS (commonly using `CPYTOSTMF`)
3. Writes/updates files under the target directory (this repo working tree)
4. Commits and pushes updates to Git

For detailed setup, configuration, scheduling, and troubleshooting, see:
- `UTIL_Source_Sync/README.md`
- `UTIL_Source_Sync/INDEX.md`

---

## HSRC1_sync_log.md (last run summary)

`HSRC1_sync_log.md` is a generated summary of the **latest sync run**, including:
- start/end time and elapsed duration
- counts of members scanned and how many were added/updated/unchanged/deleted
- failures (including the member name and any export error text)

If you see failures like **“CPYTOSTMF export failed”** / **“Bad Character found …”**, the fix is typically to reproduce the export for that member and resolve CCSID/encoding/authority issues on the IBM i side.

---

## Direction of sync (important)

This process is **one-way only**:

**IBM i (`HSRC1`) → IFS → Git**

Git → IBM i import is **not** performed by this tooling.
