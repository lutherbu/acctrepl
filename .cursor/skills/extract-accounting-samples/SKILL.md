---
name: extract-accounting-samples
description: Extract the baseline/main samples, periods, data sources, and relevant data-section text from empirical accounting papers into page-linked JSON. Use for a supplied paper or paper manifest, accounting sample extraction, reading JSON plus PDF pairs, or when the user asks to extract samples from papers in this repo.
---

# Extract accounting samples

Follow the canonical skill in this repository. Do not re-implement the workflow here.

1. Read `skills/extract-accounting-samples/SKILL.md` in full and follow it.
2. Then read its `references/output.schema.json`, `references/sample_units.json`, and `references/databases.json`.
3. Keep paper PDFs, reading JSON, and the manifest unchanged.
4. Run assemble and validate from that skill directory, not from `.cursor/skills/`:

```bash
python skills/extract-accounting-samples/scripts/assemble_data_sections.py result.json --paper-text /path/to/paper.json
python skills/extract-accounting-samples/scripts/validate_extraction.py result.json --paper-text /path/to/paper.json
```
