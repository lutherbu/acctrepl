# Accounting-paper extraction and reproduction

This repository pairs accounting papers with their extracted samples and reported regressions, assessments of data access, and results obtained from running code. The catalog covers 500 citation-ranked papers published in 2000–2020 and 159 author packages from the Journal of Accounting Research (JAR), volumes 51–58, issue years 2013–2020. Nine packages overlap the citation cohort. One JAR paper has two separately archived packages, giving 650 catalog records and 649 distinct DOIs. The CSV and JSONL link each record to its outputs using repository-relative paths. [Browse papers on GitHub Pages](https://lutherbu.github.io/acctrepl/#papers) · [CSV catalog](docs/papers.csv) · [JSONL catalog](docs/papers.jsonl)

## Per-paper publications

| Workflow | Contents | Papers or packages |
| --- | --- | ---: |
| [Samples](output/samples/records/) | Baseline sample sizes, units, periods, data sources and supporting text | 506 |
| [Models](output/models/records/) | Specifications, variable definitions, reported estimates, inference and descriptive statistics | 173 |
| [Reproduction feasibility](output/feasibility_reproduction/records/) | Assessment of independently reconstructing each baseline fit with the resources available when it was assessed | 167 |
| [Reproductions](output/reproductions/packages/) | An accepted attempt, SAS construction code, Stata notebook, and native results | 47 |
| [Execution feasibility](output/feasibility_execution/packages/) | An assessment, proposed patch and review for each author package | 159 |
| [Executions](output/executions/packages/) | A reviewed author analysis, code, available results and a recipe for its minimal inputs | 6 |
| [Extended-sample replications](output/replications/packages/) | Paper-level reports, replay code and results for the default five-year extension | 53 |

The project ran code for 53 studies. Of those, 47 used independently reconstructed code and six used author packages. Three author analyses completed all required stages and three completed part of the analysis. These six packages contain 70 published result files.

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

The paper catalog appears below Deliverables on the homepage and reads `docs/papers.jsonl` directly. The package and documentation reader uses a separate list of published filenames. After staging additions, renames or removals in those directories, run `python3 scripts/rebuild_site_inventory.py` and include `site/files.json` in the commit. Use `--check` to verify the list. To preview Pages locally, serve a public checkout with `python3 -m http.server --bind 127.0.0.1` and open `index.html#papers` through the server.

The two homepage bars read `site/progress.json` and display the UTC time of its most recent update. Colors identify the five feasibility classes, and stripes identify unexecuted work. The chart denominators are 500 citation-ranked papers and 159 JAR packages. Partial runs count as executed when at least one selected scope or required analysis stage succeeded.

The homepage applies the project author's [manual verdicts](site/progress_overrides.json) to the assessed data classes. In the citation cohort, the listed paper IDs set the data class and blocked includes manual exclusions. For JAR, the rule assigns undetermined package scopes to public acquisition. Individual verdicts take precedence over cohort rules. The JSON snapshot reports how many entries in each class received a manual verdict. Execution counts always come from the run records.

After updating the catalog, assessments, runs, or manual verdicts, run `python3 scripts/site_progress.py` in a terminal. When manual verdicts exist, the script asks twice before writing: first to apply the verdicts, then to write the counts. Enter `yes` separately at each prompt. Use `python3 scripts/site_progress.py --check` for an unattended, read-only freshness check.

Use the [feasibility verdict editor](utils/verdict.html) to search the paper catalog and change a classification. Shared papers have separate controls for independent reconstruction and their JAR package. Select the inherited verdict to remove an individual override. **Export verdicts** downloads the complete `progress_overrides.json`, including cohort rules and edits outside the current view. Place it in `site/` and run the refresh command above, or use **Import verdicts** to continue editing a saved file.

When serving the checkout on localhost, the editor links to available files under `papers/pdf/` beside each DOI. On GitHub Pages, use **Choose PDF folder** to open those same files from your computer. PDFs stay in the browser. If you open the HTML file directly in a browser with directory access, select **Open local checkout** and choose the repository root.

The export helper writes one JSONL each for samples, models, both feasibility workflows and executions under `.local/exports/`. Pass a workflow name to export just that workflow. The complete sample export is `.local/exports/samples/sample_extractions.jsonl`. Open it in the [manual reviewer](utils/review.html) or the [source filter](utils/filter.html). Both utilities run as standalone HTML files.

## Paper inputs and licensed resources

Place authorized PDFs under `papers/pdf/`, parsed readings under `papers/parsed/`, and author archives under `papers/packages/`. The JAR importer, `scripts/import_jar_packages.py`, selects volumes 51 through 58 inclusive by default. These directories and the working data directories are Git-ignored. Published tables, descriptive statistics, code and the bibliographic paper catalog are versioned. Install the relevant Python dependencies from [docs/requirements.txt](docs/requirements.txt).

```sh
python3 scripts/pdf_to_json.py --help
python3 scripts/model_sources.py W2015142764 --verify-inputs
```

Each model record binds the exact reading and PDF used for extraction. These can differ from the bibliographic catalog copy. The model-source helper regenerates the model’s original specification structure under `.local/model_bases/`. With `--crops` it regenerates and verifies the cited page regions from the pinned PDF. Historical evidence retained only as a checksum uses a `urn:sha256:` identifier. Published checksums bind the files in this checkout. Fields marked historical or executed preserve earlier byte identities where path changes altered a file.

### Build a local resource catalog

Build this catalog before starting a feasibility assessment or assigning a reproduction. Supply a directory containing your SAS `PROC CONTENTS` text listing named `data_description.txt` and a `README.md` describing your other resources. For SAS holdings, set `ACCTREPL_SAS_ROOT` to the absolute research-library root used in the listing. Sites using only the supported file or PostgreSQL resources can supply an empty `data_description.txt`. From the repository root, replace `../common` with your metadata directory.

```sh
python3 skills/check-replication-feasibility/scripts/feasibility.py catalog \
  --common ../common \
  --output output/feasibility_reproduction/resources/catalog.json
```

Git ignores the generated catalog. For local provider names or SAS librefs, pass `--aliases FILE.json` using the same structure as the [bundled aliases](skills/check-replication-feasibility/references/resource_aliases.json).

SASHELP probes use `ACCTREPL_SASHELP_ROOT`. For optional filing resources, declare `ACCTREPL_SEC_RAW`, `ACCTREPL_SEC_PARSED` or `ACCTREPL_LM10X` in the resource README or environment. The builder recognizes the PostgreSQL database names `wrds` and `data_store_api` in that README. Probes use the operator’s libpq settings. Run a new feasibility assessment to establish access, dates and field coverage at your site.

Published runs record the checksum of the catalog they used. Keep a copy if you need to verify those exact inputs later. Each rebuild records its generation time and can produce different bytes even from the same metadata. The standard public-output check runs with or without a local catalog.

## Run a skill for one paper

| Skill | Starting inputs |
| --- | --- |
| [Extract accounting samples](skills/extract-accounting-samples/SKILL.md) | A parsed paper. The skill directory holds the editable list of standardized databases |
| [Extract accounting models](skills/extract-accounting-models/SKILL.md) | The paper PDF, matching reading and its sample record |
| [Check reproduction feasibility](skills/check-replication-feasibility/SKILL.md) | A sample record, model record and resource catalog |
| [Reproduce accounting models](skills/reproduce-accounting-models/SKILL.md) | The baseline model, sample, assessment, local resource catalog, authorized source data and [Stata notebook template](skills/reproduce-accounting-models/references/stata.template.ipynb) |
| [Check execution feasibility](skills/check-execution-feasibility/SKILL.md) | The author archive, its bibliographic identity and a local resource catalog |
| [Execute author analysis](skills/execute-author-analysis/SKILL.md) | A reviewed analysis scope and its author package |
| [Replicate on an extended sample](skills/replicate-extended-samples/SKILL.md) | A completed predecessor, sample period and sources supporting additional observations |

For a published author package, use its `local_inputs.json` to restore the minimum required data from an authorized ZIP. The recipe gives its expected archive checksum and exact members, including nested archives. It also identifies the template for each executable file. Running the materializer twice reuses verified inputs. This example stages a reviewed Stata plan without launching it.

```sh
python3 scripts/materialize_execution_inputs.py --package-id jar-5b21d99d25c5
python3 scripts/materialize_execution_inputs.py --package-id jar-5b21d99d25c5 --check
python3 scripts/prepare_author_replay.py jar-5b21d99d25c5
```

Use `--archive PATH` for a ZIP stored elsewhere and `--verify-archive` to check every selected member even when working data already exist. Each recipe lists software dependencies and the working directory for each stage. Install authorized local R and Stata packages in `output/executions/resources/` and reconstruction ado files in `output/reproductions/resources/ado/`. Configure installed executables with `ACCTREPL_STATA`, `ACCTREPL_R`, `ACCTREPL_MATLAB` or `ACCTREPL_SAS` when they are outside PATH.

The replay preparer prints a frozen plan path beneath a fresh `.local/` attempt. After reviewing that plan and authorizing the run, invoke the native runner with `run --attempt ATTEMPT --plan PLAN`. It retains limits, file checksums, native logs and exit status. Stata and R use Linux bubblewrap. MATLAB host mode requires the current operator’s explicit approval file passed with `--matlab-authorization`. It uses that operator’s normal activation, filesystem and network access. [Native runner](skills/execute-author-analysis/scripts/runner.py)

## Publishing one paper

After validation, use `python3 scripts/publish_record.py samples RECORD.json` or substitute `models`. For a reviewed author-package assessment, run `python3 scripts/publish_record.py feasibility_execution ASSESSMENT.json --item WORK_ITEM.json --review REVIEW.json` with the finalized patch proposal alongside the assessment. The command checks the review and source quotations before preparing the public files.

To install a reviewed author execution, keep the replay recipe and its sibling `code/` templates together and run `python3 scripts/author_analysis_runs.py promote --campaign CAMPAIGN --package-id PACKAGE_ID --recipe RECIPE.json`. The command verifies the accepted plan, archive, input members and reviewed code, installs the package, and refreshes the workflow indexes. The controller’s `publish` command produces the private campaign summary.

A `[redacted-path-…]` marker in saved evidence represents a filesystem location. A package’s `publication_receipt.json` binds edited files to their original and distributed SHA-256 digests. For edited source quotations it also records the source digest, line range and both quote digests. The controller retains the working evidence privately. Executable paths needed for replay use repository-relative paths, configuration or template substitution.

To verify the original inputs, run `python3 scripts/verify_current_outputs.py --with-data` with the recorded PDFs, readings and retained datasets in place. It checks the catalog against each paper’s recorded hash. If your active catalog has changed, pass `--catalog-snapshot FILE` for the original copy. Repeat this option for papers assessed with different catalogs.
