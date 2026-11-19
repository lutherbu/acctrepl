# Accounting-paper extraction and reproduction

This repository pairs accounting papers with their extracted samples and reported regressions, assessments of data access, and results obtained from running code. Start with the paper catalog. Each populated result column gives a path relative to the repository root. The 898 rows cover the original 500 citation-ranked papers and 407 JAR package units, with nine overlaps. Some package units share a DOI. [CSV catalog](docs/papers.csv) · [JSONL catalog](docs/papers.jsonl)

## Per-paper publications

| Workflow | Contents | Papers or packages |
| --- | --- | ---: |
| [Samples](output/samples/records/) | Baseline sample sizes, units, periods, data sources and supporting text | 517 |
| [Models](output/models/records/) | Specifications, variable definitions, reported estimates, inference and descriptive statistics | 184 |
| [Reproduction feasibility](output/feasibility_reproduction/records/) | Assessment of independently reconstructing each baseline fit. The accompanying resource catalog identifies datasets and fields | 167 |
| [Execution feasibility](output/feasibility_execution/packages/) | An assessment, proposed patch and review for each author package | 407 |
| [Reproductions](output/reproductions/packages/) | An accepted attempt, SAS construction code, Stata notebook, and native results | 47 |
| [Executions](output/executions/packages/) | A reviewed author analysis, code, available results and a recipe for its minimal inputs | 17 |
| [Extended-sample replications](output/replications/packages/) | Paper-level reports, replay code and results for the default five-year extension | 64 |

The two feasibility skills share one [classification contract](skills/check-replication-feasibility/references/feasibility_classification.schema.json). Read the target and scope alongside the data label. A package can supply the data needed to run its final analysis while a researcher independently rebuilding the panel still needs access to a licensed source. A completed execution establishes that code ran. Each comparison records separately which published estimates it could check.

## Generate indexes and exports

Run these commands from the repository root with Python 3.11 or later. Indexing and catalog linking use the standard library.

```sh
python3 scripts/rebuild_indexes.py
python3 scripts/update_paper_catalog.py --check
python3 scripts/rebuild_exports.py
python3 scripts/verify_current_outputs.py
```

Each workflow gets one Git-ignored `index.json`. Its records contain the stable ID, repository-relative primary result path and SHA-256, sorted by ID. For a reproduction, the builder follows `accepted.json` and checks the outcome hash. `output/manifest.json` lists the workflow directories, indexes and counts found in this checkout. Rebuilding after adding a paper picks it up automatically. Use `rebuild_indexes.py --check` to detect stale indexes and `update_paper_catalog.py` to refresh catalog links.

The export helper writes one JSONL each for samples, models, both feasibility workflows and executions under `.local/exports/`. Pass a workflow name to export just that workflow. The complete sample export is `.local/exports/samples/sample_extractions.jsonl`. Open it in the [manual reviewer](utils/review.html) or the [source filter](utils/filter.html). Both utilities run as standalone HTML files.

## Paper inputs and licensed resources

Place authorized PDFs under `papers/pdf/`, parsed readings under `papers/parsed/`, and author archives under `papers/packages/`. These directories and the working data directories are Git-ignored. Published tables, descriptive statistics, code and the catalog are versioned. Install the relevant Python dependencies from [docs/requirements.txt](docs/requirements.txt).

```sh
python3 scripts/pdf_to_json.py --help
python3 scripts/model_sources.py W2015142764 --verify-inputs
```

Each model record binds the exact reading and PDF used for extraction. These can differ from the bibliographic catalog copy. The model-source helper regenerates the model’s original specification structure under `.local/model_bases/`. With `--crops` it regenerates and verifies the cited page regions from the pinned PDF. Historical evidence retained only as a checksum uses a `urn:sha256:` identifier. Published checksums bind the files in this checkout. Fields marked historical or executed preserve earlier byte identities where path changes altered a file.

Set `ACCTREPL_SAS_ROOT` to your authorized research library root. For `SASHELP.ZIPCODE`, set `ACCTREPL_SASHELP_ROOT` to the directory containing `zipcode.sas7bdat`. Optional filing resources use `ACCTREPL_SEC_RAW`, `ACCTREPL_SEC_PARSED` and `ACCTREPL_LM10X`. PostgreSQL probes use your libpq connection settings. A catalog entry records a dataset and its fields. The verification for a new attempt must establish access, dates and field coverage on the current installation. The catalog and the Stata notebook template are included. [Resource catalog](output/feasibility_reproduction/resources/catalog.json) · [Stata template](skills/reproduce-accounting-models/references/stata.template.ipynb)

## Run a skill for one paper

| Skill | Starting inputs |
| --- | --- |
| [Extract accounting samples](skills/extract-accounting-samples/SKILL.md) | A parsed paper. The skill directory holds the editable list of standardized databases |
| [Extract accounting models](skills/extract-accounting-models/SKILL.md) | The paper PDF, matching reading and its sample record |
| [Check reproduction feasibility](skills/check-replication-feasibility/SKILL.md) | A sample record, model record and resource catalog |
| [Check execution feasibility](skills/check-execution-feasibility/SKILL.md) | The author archive and its bibliographic identity |
| [Reproduce accounting models](skills/reproduce-accounting-models/SKILL.md) | The baseline model, sample, assessment and operator-authorized source data |
| [Execute author analysis](skills/execute-author-analysis/SKILL.md) | A reviewed analysis scope and its author package |
| [Replicate on an extended sample](skills/replicate-extended-samples/SKILL.md) | A completed predecessor, sample period and sources supporting additional observations |

For a published author package, use its `local_inputs.json` to restore the minimum required data from an authorized ZIP. The recipe gives its expected archive checksum and exact members, including nested archives. It also identifies the template for each executable file. Running the materializer twice reuses verified inputs. This example stages a reviewed Stata plan without launching it.

```sh
python3 scripts/materialize_execution_inputs.py --package-id jar-61d59a577016
python3 scripts/materialize_execution_inputs.py --package-id jar-61d59a577016 --check
python3 scripts/prepare_author_replay.py jar-61d59a577016
```

Use `--archive PATH` for a ZIP stored elsewhere and `--verify-archive` to check every selected member even when working data already exist. Each recipe lists software dependencies and the working directory for each stage. Install authorized local R and Stata packages in `output/executions/resources/` and reconstruction ado files in `output/reproductions/resources/ado/`. Configure installed executables with `ACCTREPL_STATA`, `ACCTREPL_R`, `ACCTREPL_MATLAB` or `ACCTREPL_SAS` when they are outside PATH.

The replay preparer prints a frozen plan path beneath a fresh `.local/` attempt. After reviewing that plan and authorizing the run, invoke the native runner with `run --attempt ATTEMPT --plan PLAN`. It retains limits, file checksums, native logs and exit status. Stata and R use Linux bubblewrap. MATLAB host mode requires the current operator’s explicit approval file passed with `--matlab-authorization`. It uses that operator’s normal activation, filesystem and network access. [Native runner](skills/execute-author-analysis/scripts/runner.py)

## Publishing one paper

After validation, use `python3 scripts/publish_record.py samples RECORD.json` or substitute `models`. For a reviewed author-package assessment, run `python3 scripts/publish_record.py feasibility_execution ASSESSMENT.json --item WORK_ITEM.json --review REVIEW.json` with the finalized patch proposal alongside the assessment. The command checks the review and source quotations before preparing the public files.

To install a reviewed author execution, keep the replay recipe and its sibling `code/` templates together and run `python3 scripts/author_analysis_runs.py promote --campaign CAMPAIGN --package-id PACKAGE_ID --recipe RECIPE.json`. The command verifies the accepted plan, archive, input members and reviewed code, installs the package, and refreshes the workflow indexes. The controller’s `publish` command produces the private campaign summary.

A `[redacted-path-…]` marker in saved evidence represents a filesystem location. A package’s `publication_receipt.json` binds edited files to their original and distributed SHA-256 digests. For edited source quotations it also records the source digest, line range and both quote digests. The controller retains the working evidence privately. Executable paths needed for replay use repository-relative paths, configuration or template substitution.

To check a holdings-complete local checkout, run `python3 scripts/verify_current_outputs.py --with-data`. This also verifies pinned PDFs, readings and retained study data without launching a regression.
