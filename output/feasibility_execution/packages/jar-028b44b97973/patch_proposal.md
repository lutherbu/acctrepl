# Patch proposal: jar-028b44b97973

How Does Carbon Footprint Information Affect Consumer Choice? A Field Experiment

DOI: 10.1111/1475-679X.12505

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: Makefile all/power/findings/rdf targets with default static caches and documented rebuild, the README dashboard after make rdf, and the separately documented review-time simulation companion. The last two are distinct branches; they do not replace the make all DAG.

Entry points: `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/README.md`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/disc_choice_sim.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/exp_additional_analyses.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/exp_debriefing_figures.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/exp_preregistered_analyses.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/exp_utils.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/linear_hypothesis_testing_fixest.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/prepare_exp_samples.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/rdf_create_spec_curves.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/rdf_design.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/rdf_display.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/rdf_exhaust_design.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/code/R/survey_results.R`, `_nested_carbonfood-v1.0/trr266-carbonfood-9029a82/doc/power_analysis.Rmd`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 1/12505 - How-Does-Carbon-Footprint-Information-Affect-Consumer-Choice-A-Field-Experiment/bceggs-datasheet-and-code.zip",
      "sha256": "ef5dfad126d6c91ddde437d9ed5f8a6d5fe6f0ed7d60e6414c10ab3995bae86e"
    },
    {
      "path": "JAR-Volume 62/Issue 1/12505 - How-Does-Carbon-Footprint-Information-Affect-Consumer-Choice-A-Field-Experiment/bceggs-in-principle-accept.pdf",
      "sha256": "d9660300f62afa7e047007edb37a3ddb206ac8c27db436a73a78717d2476cdbb"
    },
    {
      "path": "JAR-Volume 62/Issue 1/12505 - How-Does-Carbon-Footprint-Information-Affect-Consumer-Choice-A-Field-Experiment/bceggs-online-appendix.pdf",
      "sha256": "8db11c2d8623541a9dd2aec6af26e8fbc0fa49c8a3136af0be3513f2d7e0c079"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "b83ec0d49558c62e6839b38964169afd3d730e858c8a7ad9b828aad0fbc31dfa"
}
```

## Proposed actions

### A-CONFIRM-PREPARED-DATA: Confirm the unresolved RDS/RData object and field contracts for the exact author-prepared inputs without rebuilding them from historical raw sources.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-DISH-CHOICES, R-TMENT-DATA, R-SURVEY-DATA, I-PREPARED-DATA-METADATA
Evidence: E-EXP-DATA, E-EXP-TMENT-DOC, E-SURVEY-DATA, E-SURVEY-FIELDS, E-PROBE-DISH-CHOICES-RDS, E-PROBE-TMENT-RDS, E-PROBE-SURVEY-RDATA

Preparation / proposed procedure:

1. Confirm that dish_choices.rds, tment_data.rds and survey_data.RData contain the documented author-prepared objects, fields and full observation/match extent used by the supplied scripts; provide a non-executable object/column/type/row-count manifest or a bounded reader result.
2. Keep the packaged prepared datasets as the primary routes. Do not reconstruct cash-register transactions, treatment schedules or survey matching independently.

Validation to perform later:

- Compare a supplied safe field/type manifest with the joins and reads in prepare_exp_samples.R, rdf_design.R and survey_results.R.
- Confirm the prepared experiment, treatment-window and survey-match extent before any author-code run; assess CSV full-row coverage separately through later join/output validation.

### A-PIN-REMOTE-R-HELPER: Confirm the revision and availability of the known external theme_trr.R helper source; no source payload was fetched or executed during this review.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-REMOTE-R-SOURCE
Evidence: E-STRUCTURE, E-SOURCE-EDGE-MAP, E-README-PACKAGE-INSTALL, E-SEMANTIC-PRECHECK

Preparation / proposed procedure:

1. The two supplied scripts call devtools::source_url for the same theme_trr.R helper on raw.githubusercontent.com; preserve those actual source calls.
2. Ask the authors to confirm the intended immutable revision/version and expected availability, or to provide a pinned offline copy if the existing coordinate is mutable or inaccessible.
3. Do not guess a replacement, fetch the URL or execute downloaded code during this assessment.

Validation to perform later:

- Before any future authorized run, verify the intended helper revision and source availability separately from the known file/host coordinate, then check that both scripts still source the same helper without displaying literal URL contents.

### A-VERIFY-R-SOFTWARE: Verify the author-listed R add-ons and Pandoc path before running the Makefile workflow; no installation was performed during this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-R-ADDONS, S-PANDOC, I-R-SOFTWARE-UNVERIFIED
Evidence: E-README-PACKAGE-INSTALL, E-README-RMARKDOWN, E-README-GITHUB-PACKAGES, E-README-PANDOC, E-BUILD-TOOLS, E-RDF-LIBS

Preparation / proposed procedure:

1. Check availability/version of the README-listed CRAN and GitHub packages plus packages directly named by the supplied sources, including DBI/RPostgres for the RDF worker-library argument.
2. Confirm an Rscript-accessible Pandoc executable or an RStudio-provided path; if it is unavailable, follow the authors' documented setup guidance before any render.
3. Install or configure only packages confirmed missing, using the authors' instructions and an authorized environment; no package changes are part of this submission.

Validation to perform later:

- Verify Rscript can find the required packages and Pandoc from the same environment used by make, then perform the author-prescribed build only after the data and remote-source issues are resolved.

### A-RUN-AUTHOR-WORKFLOW: Run the supplied author workflow after input, remote-code and software contracts are confirmed.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E-REPO-MAKE, E-REPO-STATIC, E-README-DASHBOARD, E-README-COMPANION, E-TRACE

Preparation / proposed procedure:

1. Create a separate portable, writable working copy of the complete supplied nested repository, including its source, data and static cache files. Run all author targets only from the nested repository root in that copy; preserve the original author package and its source, data, static caches and frozen audit directories unchanged.
2. For the documented default path, run make all from the working copy; it reuses the packaged static power/RDF caches where applicable.
3. Before any regeneration path, archive the working copy's existing generated outputs and supplied static power/RDF results or caches that clean/dist-clean may remove. Then run make dist-clean followed by make all only inside that working copy; the supplied original and frozen audit tree remain untouched.
4. After make rdf, run code/R/rdf_display.R for the local dashboard. Run code/R/disc_choice_sim.R separately only when reproducing the review-time model-comparison companion; it is not a make all target and has no external empirical input.

Validation to perform later:

- After the run, validate dish_plan joins across the used experimental days/dishes and confirm the prior-results branch represents the intended full study set; these are future output checks, not barriers to verifying either packaged CSV input route.
- Confirm the Makefile-declared generated and output artifacts appear at the documented paths; keep the dashboard and review-time companion results distinct from the core make all outputs.
- Record the actual software versions and any remaining input or source issues; execution_verified remains false until a future authorized run is independently reviewed.


## Remaining issues and prerequisites

- I-PREPARED-DATA-METADATA [unresolved; full_pipeline]: The supplied dish_choices.rds, tment_data.rds and survey_data.RData are documented author-prepared inputs at the exact paths used by the workflow, but the frozen helper returned unverified because it has no bounded reader for these formats. Their actual stored objects/columns and complete observation/match coverage therefore remain unknown; the probe does not imply that files or licenses are absent.
- I-REMOTE-R-SOURCE [unresolved; full_pipeline]: The two unconditional devtools::source_url calls in exp_additional_analyses.R and exp_debriefing_figures.R target the same known helper coordinate: theme_trr.R hosted on raw.githubusercontent.com. The identical URL literal has SHA-256 85d40f5089ce806431cfdc9a8120c5916a633d5d0a5f009fcdfc889eed1f508d; the literal itself and payload are not reproduced. The intended source revision/version and current retrieval availability remain unverified because no source payload was fetched or executed.
- I-R-SOFTWARE-UNVERIFIED [unresolved; full_pipeline]: R, Rscript and make are available, but the listed add-on/GitHub package versions were not checked. Pandoc is not on PATH and any RStudio or package-provided path remains unverified. No package was installed.
- R-DISH-CHOICES [undetermined]: Author-prepared transaction-item data, present at the exact path consumed by sample preparation and RDF design. The README describes its cash-register origin, transaction keys and fields; historical collection does not add a raw register source to this supplied workflow. Actual RDS object/readability/column compatibility and full experiment-period coverage remain unverified because the frozen helper has no bounded reader for this format.
- R-TMENT-DATA [undetermined]: Author-prepared treatment schedule and timing input read by sample preparation, preregistered analyses and RDF design. The README documents the timing/assignment fields; actual RDS object/field readability and complete treatment-window coverage remain unverified because the frozen helper has no bounded reader for this format.
- R-SURVEY-DATA [undetermined]: Author-prepared post-experimental survey and receipt-match data. The README names dta_survey_matched and dta_receipt_matched and documents their fields; survey_results.R loads the file directly. Actual RData objects/columns, readability and matched-response coverage remain unverified because the frozen helper has no bounded reader for this format.
- S-R-ADDONS [unverified]: The README install block and supplied source require R add-ons including tidyverse, lubridate, fixest, mlogit, truncnorm, rmarkdown, knitr, kableExtra, modelsummary, ggridges, ggbeeswarm, ggforce, emojifont, car, marginaleffects, devtools, rsvg, RPostgres, binom, plus GitHub packages DiagrammeRsvg and rdfanalysis; code also names lmtest, broom, htmltools and pbapply. Installed versions were not checked or changed.
- S-PANDOC [unverified]: The Makefile renders power_analysis.Rmd through rmarkdown. The bounded PATH check did not find pandoc; a configured RStudio or package-bundled Pandoc path was not checked, so availability remains unverified.

## Review notes

- The supplied static audit is treated as discovery only; all 24 frozen dependency IDs are mapped in dependency_review, including guarded examples and generated/static-cache handoffs.
- Candidate source statements were scanned and redacted before program text inspection. The redacted structural report is used only for call categories and guard state; credential/connection literals and external source payloads were not disclosed or used.
- The first source-edge path-presence artifact is preserved under probes/history and excluded because it used the wrong path base; the corrected source_edge_map_v2.json is the evidence artifact.
- The early valid draft and trace are preserved byte-for-byte under probes/history/checkpoint_001_*; this draft supersedes that checkpoint.
- No author code, statistical/synthetic program, parser/import/compile operation, dataset reconstruction, SAS startup, installation, source edit, external contact, or external content fetch was performed.
- Existing bounded CSV probes and the coordinator's hash-bound semantic precheck verify local readability and every expected field for dish_plan.csv and prior_results.csv. Full dish/period and study-set coverage remain future join/output validation, not input-availability prerequisites.
- Safe metadata identifies both unconditional source_url calls as the same theme_trr.R helper on raw.githubusercontent.com and records the URL-literal digest; the URL value and source payload remain undisclosed, and version/current availability are unverified.
- Candidate source statements were scanned and redacted before program text inspection. The structural report is used only for call categories and guard state; no credential/connection literal or external source payload was disclosed or used.
- The supplied Makefile clean/dist-clean removes generated outputs and supplied STATIC_TARGETS. Any future regeneration is proposal-only and must use a separate working copy after archiving that copy's existing results and caches; keep the original/frozen package and audit tree untouched.
