# Copilot / AI Agent Instructions for random-number-app

Purpose: concise, project-specific guidance for AI coding agents to be productive immediately.

- **Repo Type**: Small utility + minimal static UI. Key files: `import_csv.py`, `index.html`, and `ANALYTICS_API/` (currently empty).
- **Primary intent**: `import_csv.py` converts CSV files (with headers) to JSON using UTF-8 encoding; `index.html` is a placeholder static page.

**Quick Start**
- **Run converter**: project has no deps file; use system Python 3. Run:

  `python3 import_csv.py`

- **Dev environment**: create a virtualenv if you plan to add packages:

  `python3 -m venv venv`
  `source venv/bin/activate`

**Project-specific patterns (do not change without reason)**
- **Hard-coded input path**: `import_csv.py` uses an absolute path variable named `dossier` (French). Example: `dossier = "/home/sdd/Téléchargements/Dataset"`. Avoid changing this silently — tests and runs expect a real directory.
- **Encoding & JSON output**: the script opens files with `encoding='utf-8'` and writes JSON with `ensure_ascii=False, indent=4` to preserve non-ASCII characters (accents). Keep that when modifying I/O behavior.
- **CSV parsing**: uses `csv.DictReader(..., delimiter=",")` — files are expected to be comma-delimited with a header row.
- **User-facing output**: the script prints progress messages in French with emoji markers (e.g., `✔` and `🎉`). Preserve message style/language when making small UX or logging changes.

**Architecture & boundaries**
- This repo currently comprises a single utility script and a static HTML file. There are no services, background jobs, or DB connections to discover in the codebase.
- `ANALYTICS_API/` exists as a placeholder directory (empty). Treat it as a separate component boundary; do not assume any server code exists there unless new files are added.

**When editing or extending**
- If you parameterize `import_csv.py`, add an explicit CLI interface (use `argparse`) rather than silently replacing `dossier`. Example flags: `--input-dir`, `--output-dir`, `--indent`.
- Preserve the `encoding='utf-8'` and `ensure_ascii=False` behavior by default to avoid corrupting accented characters.
- Keep CSV delimiter as comma by default unless you detect and safely handle a different delimiter.

**Testing & debugging**
- There are no tests. To validate changes locally: run `python3 import_csv.py` against a small sample CSV in the expected directory.
- For step-by-step debugging, run `python3 -m pdb import_csv.py` or add temporary logging prints.

**Files to review for context**
- `import_csv.py` — converter logic and conventions (encoding, delimiter, prints).
- `index.html` — minimal static UI; safe to update.
- `ANALYTICS_API/` — placeholder for any future API code.

If anything here is unclear or you want the agent to follow stricter rules (commit message format, branching strategy, or tests), tell me which conventions to add and I will incorporate them.
