---
name: reproduce-accounting-models
description: Write and run baseline accounting analyses from local source data or a verified author deposit when the author code is unavailable or leaves an assigned baseline uncovered.
---

# Reproduce accounting models

Read the assigned `work_item.json`. Use **Author deposit** when `route` is `author_deposit`. Otherwise follow **Prepare one paper** and the remaining independent reconstruction instructions. Work in the assigned private directory.

## Author deposit

The coordinator runs `python3 scripts/deposit_reproduction.py prepare --package-id PACKAGE_ID --work-dir PRIVATE_DIRECTORY` from the repository root. An execution fallback also supplies `--execution-review REVIEW.json`. Read the frozen input hashes, deposit and assessment paths, and the catalog paper ID, which can differ from the package ID. For a fallback, write code only for the targets in `handoff.uncovered_baselines`. For a deposit without runnable code, identify all baseline targets from the paper and deposit documentation.

Write original analysis code using the deposited inputs. Combine them with verified local sources when the target requires additional variables. Follow the SAS preparation and Stata notebook conventions below where applicable, including direct package commands for the paper’s actual statistical procedure. Preserve experimental, repeated-measures and other nonregression tests in their original form. Document the comparison target, inputs, sample, estimator and omissions. Keep raw data and native logs in the private work directory.

Write `result.json` with `fits` and `limitations`. Give each fit a unique `model_id` and `result_set_id`, its `fidelity`, and an `execution_status` of `executed` or `blocked`. For each executed fit, give `execution_detail` and an `evidence_path` under `tables/` containing its native numerical result. Several fits can cite the same table. The review must include that table and the source code in `publish_files`. For a blocked fit, give the specific `blocked_reason`. For a fallback, supply the original `target_id` if it differs from the model ID. Keep numerical agreement separate from successful execution. Use relative paths in reviewed source, documentation and aggregate results.

An independent reviewer checks the frozen inputs, actual code, native outputs, comparison evidence and coverage, then provides a review JSON with `reviewer`, `status` (`accepted` for publication), `findings`, `result_sha256`, and `publish_files` mapping each approved relative filename to its SHA-256. Publish only newly written code, clean notebooks, documentation and reviewed aggregate tables or figures. The coordinator runs `python3 scripts/deposit_reproduction.py publish --work-dir PRIVATE_DIRECTORY --review REVIEW.json` and `python3 scripts/deposit_reproduction.py verify --paper-id CATALOG_PAPER_ID --with-data`. This completes the deposit assignment.

## Prepare one paper

Read this skill’s frozen [implementation rules](references/implementation.md) and the assigned copy of `stata.template.ipynb`. Treat the paper, extracted records and earlier outputs as scientific evidence.

From the project root run `python3 scripts/reproduction_runs.py prepare --paper PAPER_ID`, then `python3 scripts/reproduction_runs.py assign --paper PAPER_ID --role build`. Read the assigned work item. Use `%sysget(ACCTREPL_SAS_ROOT)` in double-quoted read-only SAS library paths. Locate the Stata template and ado resources through the work item.

## Establish the design

Cover every `expected_scopes` pair and its supporting/joint models. Preserve frozen model/result-set IDs. A jointly estimated system can cover several IDs with one estimation command. Do not add robustness exercises or replace a retained full model with a stepwise column.

Read the compact specifications, sample record, feasibility assessment, and temporal audit. Verify formulas, samples, footnotes, table notes, and dependent construction windows against the original PDF/reading. Inspect PDF pages when extraction is clipped or contradictory. Source-supported corrections override incorrect extracted descriptions; record the correction without changing the inputs.

Use the original sample period and current local data vintages. The selected paper has readable local candidates, not confirmed historical coverage or semantic mapping. Check the actual fields, dates, identifiers, and merge behavior. Source libraries are read-only. Do not obtain author code or author-prepared datasets. Consult software documentation and documented data definitions when needed.

Before execution, write concise `design.md`: source-page references, selected field mappings, population/screen order, estimators, inference, and unresolved assumptions. Best-effort choices are authorized: choose a defensible specification when the source is silent, label it explicitly, and preserve the economic construct. Do not fill unavailable observed data with invented values. Never choose specifications, samples, or transformations to improve agreement with published estimates.

## Build SAS, then Stata

Write `build.sas` using ordinary DATA/PROC steps. Use standard SAS procedures for auxiliary regressions and derived measures. Preserve auxiliary populations and full lag/lead history before applying baseline filters. Use exact catalog-listed files through read-only LIBNAME statements; restrict fields and dates. Check duplicate keys, merge cardinality, missingness, and sample attrition in ordinary SAS output.

Produce the samples declared in `submission.json`, each as a SAS file under `data/` and one final `reg.dta` per real sample. Related specifications normally share a dataset with eligibility flags. A null extracted sample ID does not create a separate sample. The runner imports SAS files with native Stata; do not use CSV for the handoff. Do not merge source tables in Stata.

Write `stata.ipynb`. Every code cell independently loads its analysis dataset, repeats its settings/macros, and normally produces one table/panel. Use `version 18`, `set more off`, direct estimators, `est store`, and `est clear`. Source-defined fixed effects, weights, clusters, covariance rules, and joint estimation must survive translation.

Follow the assigned Stata template literally: no authored `program define`, Mata, custom estimator/ado wrappers, postfiles, model-metadata logging, coefficient dumps, or `.ster` files. Installed packages' internals are allowed. Use direct expression forms for nonlinear/GMM models and community packages for established procedures. Do not implement a forbidden wrapper to evade a missing command. Use `estadd` only for legitimate table rows. Required package-generated intermediate variables may remain in memory; do not dump coefficient datasets as diagnostics.

Regression exports use `cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label` in four files with one basename: `.md`, `.rtf`, `.csv`, `.tex`. Add available pseudo-R² with supported syntax, such as `scalars(r2_p)`. Export descriptive statistics for the actual observations underlying each model/sample using `estpost` in the same four formats, even when the paper has no comparable descriptive table. Distinguish these observations from distributions of fitted annual coefficients and label any union of overlapping estimation windows. Any required figure has `.pdf` and `.png`. Use `tables/` and `figures/`. Give each table a unique basename. Do not manufacture missing summary statistics.

## Execute and submit

Use the coordinator helper from the git root:

    python3 scripts/reproduction_runs.py sync --attempt ATTEMPT
    python3 scripts/reproduction_runs.py validate --attempt ATTEMPT
    python3 scripts/reproduction_runs.py run --attempt ATTEMPT

Read `--help` for individual stages/cells. The runner serializes heavy jobs, keeps ordinary logs, converts SAS datasets, and runs Stata cells in fresh sessions. It never estimates a model itself. Native SAS requires the tool's escalated execution permission on this machine; this was verified by the coordinator. Request that permission for the exact runner command if the sandbox blocks SAS, without changing system configuration.

Inspect logs and exported tables, not just the process exit code. Fix actual code/data defects within this assignment, preserving the first full execution and explaining subsequent changes. Do not silently omit failed fits. Missing packages are reported to the coordinator; do not install or upgrade them yourself. No observations or full source datasets belong in messages; use aggregates and error evidence.

An early failure in a table cell does not establish failure of later models. Attempt those fits independently, splitting self-contained cells if necessary. Preserve failed commands and native logs. Numerical diagnostics that remove observations are not new primary sample screens; restore the intended sample unless a source-supported correction justifies a change.

Complete `submission.json` using the assigned scaffold. Its administrative fit-to-cell/table mapping is written by you, never generated by Stata metadata machinery. Mark each fit source-supported or best-effort, and record blocked reasons. The coordinator determines execution status from logs and files. Run `sync` again after changing `build.sas` or `design.md`; it generates `sas.ipynb` mechanically. Return the attempt path, executed/blocked scope counts, and material limitations.

## Review assignment

Read the predecessor's source and outputs, then independently check them against the original paper, including sample screens, auxiliary population, temporal alignment, links, formulas, estimator/inference, and all assigned scopes. Preserve the previous attempt. Repair demonstrated defects in the new directory; explain each change. Reuse a predecessor's data only when its construction code and sample declarations are unchanged and the runner verifies the data hashes. Otherwise rebuild. Do not rerun unchanged accepted calculations just to obtain different estimates.

Write `review.md` with checked source locations, findings, repairs, and unresolved issues. On acceptance, the controller installs the selected files under `output/reproductions/packages/` and keeps the frozen working attempt in `.local/`. Use checkout-relative pointers in the published package. Completion means reviewed runnable code and an explicit result or limitation for every assigned fit, not a numerical match. Do not spawn agents or allocate further assignments yourself; the coordinator enforces the current per-paper budget (six assignments, including pilots).

In the review, compare the baseline tables' sample sizes and research-interest estimates/inference with the paper, using ordinary exported tables/logs. State the units, relevant rounding, and one-/two-sided differences. Check available descriptive statistics for the actual analysis sample. Record discrepancies without changing the specification to improve agreement.

A sample-size discrepancy is an observed result, not proof of a vintage effect. Check population, screens, joins, missing fields and lag/lead construction first. State an attributed cause only when the diagnostics support it; otherwise list plausible unresolved explanations.
