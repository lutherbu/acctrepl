# Accounting-paper extraction and reproduction

This project contains 500 candidate papers, 100 each from TAR, JAR, JAE, CAR
and RAST, for journal issue years 2000–2020. Selection uses the saved OpenAlex
total-citation ranking after empirical screening; FWCI is a separate field.
The source-filtered shortlist has 167 papers. The completed reproduction
campaign covers 47 selected papers.

## Current deliverables

`output/` contains only the latest accepted publications in four stage folders.
[The layout manifest](output/manifest.json) identifies the current files, working
run roots, archive, and relocations of historical artifact references.

| Folder | Current contents |
| --- | --- |
| [samples](output/samples/) | `sample_extractions.jsonl` (500 papers) and `sample_extractions.filtered.jsonl` (167 papers). These are distinct views, not competing versions. |
| [models](output/models/) | Schema-3 `model_results.jsonl`, matching `model_results/` per-paper records, index, review queue and paper input manifest. Specifications, variable definitions, coefficients and descriptive statistics are organized together. |
| [feasibility](output/feasibility/) | Reviewed schema-1.2 assessments for 167 papers, per-paper copies, index, summary CSVs, resource catalog and validation evidence. |
| [reproductions](output/reproductions/) | The latest accepted attempt for each of 47 papers, plus current execution summaries, shared ado packages and publication comparisons. |

The manifest `papers.csv` / `papers.jsonl` at the project root describes the 500
papers, citation snapshot, DOI, year, cached PDF/reading paths and checksums.
There are 500 PDFs in `papers/pdf/` and 500 original reading JSONs in
`papers/parsed/`. Current verified reading derivatives are in
`papers/parsed/verified/`; their byte contents and physical page numbers are
preserved. Five manifest pairs use the cached reading's matching PDF version;
nine original readings omit only a verified blank trailing page.

## Reproduction status and comparisons

The completed campaign has 47 closed independent reviews and 114 assignments.
Its 178 baseline model definitions expand to 239 model/result-set scopes;
33 additional model definitions support data construction. Of the 239 scopes,
235 executed and four remain numerically blocked.

- [Execution summary](output/reproductions/summary.md)
- [All 47 paper comparisons](output/reproductions/comparison/report.md)
- [All 239 model/result-set comparisons](output/reproductions/comparison/all_models.md)
- [Model consistency summary](output/reproductions/comparison/model_consistency_summary.md)
- [Model consistency CSV](output/reproductions/comparison/model_consistency.csv)

The saved focal-sign/5%-inference assessment counts 152 consistent scopes,
76 with at least one focal discrepancy, seven lacking sufficient published
inference targets, and four blocked. All implementations are best effort;
qualitative consistency does not imply equal coefficients or samples.

Each paper directory retains its accepted `attempt_NN` identifier. It includes
`build.sas`, SAS/Stata notebooks, `design.md`, `review.md`, `submission.json`,
`outcome.json`, frozen instructions/template, current datasets, native tables,
and required execution records. Example read-only validation:

```bash
/opt/tljh/user/bin/python scripts/reproduction_runs.py validate \
  --attempt output/reproductions/W3122547505/attempt_03
/opt/tljh/user/bin/python scripts/reproduction_runs.py summarize
/opt/tljh/user/bin/python scripts/verify_current_outputs.py
```

`run --attempt ...` executes SAS/Stata; it is separate from the read-only
commands above. Follow the reproduction skill and frozen Stata template.
The shared ado folder is `output/reproductions/ado/`. New work items give its
absolute path; retained notebooks use their verified relative path.

## Skills and tools

| Location | Purpose |
| --- | --- |
| [Sample skill](skills/extract-accounting-samples/SKILL.md) | Extract main sample counts, units, periods, sources and data-section text. Editable database names are in its `references/databases.json`. |
| [Model/results skill](skills/extract-accounting-models/SKILL.md) | Extract baseline regression specifications, focal/control roles, reported results and variable statistics. Current output schema is 3.0; regression methods are an editable vocabulary. Statistical derivations use Python helpers. |
| [Feasibility skill](skills/check-replication-feasibility/SKILL.md) | Assess independent reconstruction resources, temporal coverage and unresolved implementation gaps. Readable source candidates remain distinct from confirmed coverage. |
| [Reproduction skill](skills/reproduce-accounting-models/SKILL.md) | Prepare data with SAS and run baseline regressions with template-compliant Stata and documented packages. |
| `scripts/model_extraction_runs.py`, `scripts/model_results_runs.py` | Manage frozen assignments, quotas, verification and publication. These scripts do not call AI models. |
| `scripts/validate_feasibility_run.py`, `scripts/summarize_feasibility.py` | Replay frozen feasibility evidence and summarize assessments. Historical runs are resolved through the layout manifest. |
| `project_layout.py` | Resolve current publications and immutable historical paths; validate the narrow notebook-path relocation proofs. |

New working runs, pilots, specification-only intermediates and superseded
publications belong under `../candidate_search/runs/`. The original campaign
quota/history has been retained; reorganizing files does not reset it.

## Manual review and filtering

Open [utils/review.html](utils/review.html) directly in a browser, load
`output/samples/sample_extractions.jsonl`, edit fields and export the revised
JSONL. Changes remain in the browser until exported. The utility supports
session recovery and preserves unchanged record lines.

Open [utils/filter.html](utils/filter.html), load a sample-extraction JSONL,
select allowed data sources and export papers whose sources satisfy that
selection. Papers with no observed data are excluded. Both utilities are
standalone files and require no server or API key.

## PDF conversion and environment

Python dependencies are listed in `requirements.txt`. The single-file converter
requires no OpenAlex index, API key or language model:

```bash
/opt/tljh/user/bin/python scripts/pdf_to_json.py --help
/opt/tljh/user/bin/python scripts/pdf_to_json.py papers/pdf/example.pdf \
  --output papers/parsed
```

The converter accepts one PDF or all PDFs directly in a directory. See its help
for OCR thresholds and defaults. The project also uses SAS 9.4 and Stata 18;
shared data catalogs and the Stata template are in the workspace's `../common/`.

## Archives, provenance and Git exclusions

Earlier outputs, schema-2 results, specification-only publications, pilots,
sweeps, superseded attempts and unreferenced runtime diagnostics were archived
to `../candidate_search/archive/git-output-20261106T131416Z/`. Loose root SAS/Stata
logs and listings are in that archive's `root_diagnostics/`.

The archive contains the pre-move inventory, checksums, move journal, original
comparison reports and original executed notebooks. Current sample, model and
feasibility records retain their original bytes. Their historical path strings
are resolved through `output/manifest.json`, including paths to archived evidence.
The narrow ado-path notebook edits preserve all research commands and existing
console outputs. Validation binds them to the original executed notebook and
unchanged dataset hashes; it does not claim a fresh estimation run.

Raw/analysis data remain local and Git-ignored: PDFs, parsed readings, SAS/Stata
and other binary dataset formats, per-paper data directories, row-level audit
CSVs and working caches. Folder `.gitkeep` placeholders remain trackable.
Extraction JSON/JSONL, schemas, vocabularies, metadata manifests, numeric result
CSVs, code and readable reports remain eligible for version control.

Tests are under `tests/`. `scripts/reorganize_outputs.py verify --archive PATH`
checks the archived inventory; `scripts/verify_current_outputs.py` verifies
current publications and native result/data signatures without rerunning models.
