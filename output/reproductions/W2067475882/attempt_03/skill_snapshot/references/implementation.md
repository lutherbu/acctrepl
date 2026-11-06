# Paper implementation rules

## Inputs and authority

`work_item.json` contains frozen paper/model/sample/feasibility/temporal records, exact source paths, the source catalog, expected fit IDs, and the template snapshot. Do not edit it. Read only needed pages/records rather than printing an entire extraction. Original source evidence controls scientific choices. Document every material conflict with inherited extraction.

No scan of `/home/luther`, shared data trees, or the PDF corpus. The user authorized full read-only reconstruction from the catalog-listed tables required for these 47 papers. Output, SAS work, and scratch files (including documentation extracts) stay under the assigned attempt directory. Additional outside resources require coordinator review. Do not modify source libraries, install packages, or fetch authors' replication code.

## SAS construction

- Use exact local library paths with `access=readonly`. Do not depend on the machine autoexec or pre-existing WORK tables. Use literal relative paths for writable libraries under this attempt's `data/`, so a copied review cannot write into its predecessor.
- Check every raw mnemonic against the exact catalog table before execution; a field on COMPANY need not exist on FUNDA. For legacy numbered items, verify the item-number-to-mnemonic crosswalk with provider documentation; similar labels do not establish equivalence. Categorical vendor codes require a documented codebook, not interpretation as names or a guessed numeric grouping. The coordinator's `output/reproduction_runs/resource_documentation.json` records reusable provider-documentation pointers.
- Use date restrictions and `keep=` early, but retain the complete supporting population and raw construction horizon. Do not use arbitrary observation limits for a final run.
- Before repeating a large scan after changing joins or procedure-output handling, test that changed block on bounded scratch data or matching schemas. Keep smoke-test limits out of the delivered build.
- Make Compustat format/consolidation/population filters, duplicate policy, historical name/security links, link validity dates, and sample frequency explicit. Never use `nodupkey` to hide a many-to-many merge without a justified selection rule.
- Check source keys and revision/vintage dimensions before aggregating; a unique final key does not rule out upstream double counting. Select a coherent report vintage and align currency and split-adjustment bases across merged quantities.
- Check currency codes at every period used in monetary differences and cross-year denominators, and when combining accounting amounts with market values. Unlike units require a documented conversion or an unavailable construction; a small number of mismatches does not justify ignoring them. Preserve same-currency observations unless a separate source-supported screen applies.
- Align by actual dates/fiscal periods and entity keys, not row positions. SAS `lag()` is a queue, not a grouped temporal join; use keyed joins or explicit continuity tests. Gaps must remain gaps. Never use a later observation to fill earlier missing data.
- Preserve character identifiers and leading zeroes; use SAS numeric doubles for measures. Keep missing versus zero distinct. Handle special missing values deliberately. Avoid unreported rounding.
- Respect signs of legacy cash-flow items, signed denominators, denominator dates, units, industry definitions, winsorization versus trimming, and whether cutoffs are pooled or grouped. No generic default winsorization.
- Preserve source-defined composite signs; economic rationale alone does not authorize reversing reported terms. Use algebraic identities and reported distributions to check sample and coding interpretations.
- Estimate supporting regressions with standard PROC procedures, at the specified population/group/window and minimum observations. Their residuals/coefficients are construction intermediates, not extra baseline models. Propagate unavailable or singular supporting fits as missing and report their count.
- Preserve baseline eligibility flags rather than applying the most restrictive fit's complete-case filter to all models. Joint systems use the appropriate common sample. Separate genuine samples or grains into separate final files.
- Set `options errorabend;` so unexpected errors cannot yield a stale apparent success. Use ordinary PROC counts/summaries and log messages for merge/sample checks; do not print raw records. Do not use `obs=` for final data.
- Supporting resampling/simulation, when required by a baseline, uses a fixed documented seed and preserves the original repetition count when feasible. Any reduction is explicitly a limitation, never a complete reproduction.
- For simulation inference, verify that the observed statistic is finite and report valid nonmissing replications, tail counts, and the empirical probability. A requested repetition count alone does not establish valid inference; zero tail hits do not establish zero probability.
- Treat published sample counts as results to compare, not selection rules, unless the paper explicitly prescribes a fixed-size draw. Preserve the stated randomization unit and keep an entity's observations together when the split is at entity level; record unknown seeds or allocation details as assumptions.

## Stata cells

Notebook kernel: `stata`. Each code cell has a stable `id`, starts with `version 18` and `set more off`, defines every global it uses, uses its own `reg.dta`, and clears estimates before/after table production. The runner's working directory is the attempt root; use relative paths. Do not include package installs, `cd`, Python/R calls, source-data imports, or external do/ado-file calls in analysis cells.

Use literal table output paths without filename macros so the runner can verify all four files. Estimator loops and variable-list macros remain allowed as in the template.

Inspect the exported tables for the intended N and available R² rows; custom `stats()` options can suppress the template's fit statistics. Check values in each format, not just file existence.

Conventional loops and macros are allowed as in the template. Call built-in or installed package estimators directly. For firm/group coefficient-distribution results, package-generated in-memory results and `estpost` summaries are allowed when they are the paper's actual target; a pooled regression is not an equivalent replacement. Preserve the distinction between Fama–MacBeth averaging and pooled OLS, between two-way and interacted fixed effects, and between covariance and GMM weighting matrices. Panel HAC ordering must be justified, not created by concatenating firms into a false time series.

For cross-group coefficient means, retain one record per qualifying fit and consider native `mean` for the means and their standard errors, with descriptive quantiles reported separately. Its N counts fits; do not weight groups implicitly by their repeated firm-year records. Use the template's p-value presentation and compare with published t-statistics through ordinary logs.

Use estimator defaults only when they are appropriate documented best-effort choices. Do not add clustering or fixed effects simply because they are common today. Do not replace unavailable standard errors with invented p-values. Table p-values follow the template; note any difference from a paper's one-sided convention rather than altering estimates to reproduce stars.

Check installed specialized commands before declaring estimation blocked. An equivalent native/package formulation is allowed when its moments, estimates, and covariance treatment are justified. Nonconverged estimates or missing required inference are diagnostic outputs, not successful fits. Use model-appropriate native hypothesis tests; a raw residual-sum ratio is not a likelihood-ratio test unless the required likelihood and weighting derivation applies.

Missing commands are reported as `required_commands` in the submission. The coordinator handles approved package installation. Do not redefine commands or implement custom estimators with `ereturn post`, matrix-to-data dumps, `statsby` dump files, or postfiles. Native nonlinear/GMM equation expressions and estimator-required initialization matrices are allowed.

The existing user ado directory is not writable. The coordinator installs approved additional commands in `output/reproduction_runs/ado`. If using such commands, repeat `adopath ++ "../../../output/reproduction_runs/ado"` in every relevant analysis cell (relative to the attempt root). Existing global commands remain available. `xtfmb` and `asreg` installation has been authorized; consult the coordinator's preflight log for availability.

## Output contract

The assigned `submission.json` scaffold contains:

- `paper_id`, `attempt`, `required_commands`, `samples`, `fits`, `limitations`.
- `source_datasets`: qualified catalog names actually read. Include a source-corrected table even if the earlier feasibility record named a different frequency/product; explain that correction in `design.md`.
- Each sample: `sample_id`, `sas_file`, `dta_file`, `key`, `description`. Paths are relative, inside this attempt; a Stata entry file is named `reg.dta`.
- Each fit: frozen `model_id`/`result_set_id`, `cell_id`, `table_basename`, `fidelity` (`source_supported` or `best_effort`), `assumptions`, and `blocked_reason`.
- A blocked fit has null cell/table references and an explicit reason. Do not mark a fit blocked merely because the prior feasibility result was undetermined. Readable local candidates should be attempted using the authorized best-effort policy.
- `table_basename` excludes its extension and normally begins `tables/`. Several fits may share a table/cell. Baselines in one joint system remain separately represented in this map.

Write the scientific interpretation/assumptions in `design.md`; reference evidence with physical PDF page and table/equation. Put review findings in `review.md` for review/repair assignments. Do not copy published coefficient values into generated result tables. The coordinator separately compares executed outputs at their available precision.

The helper-generated administrative records and normal logs are outside Stata analysis code. They track file integrity, attempts and execution only, and are not an exception permitting Stata model-metadata or coefficient dumps.

## Runtime

SAS executable: `/usr/local/SAS/SASFoundation/9.4/bin/sas_u8`; Stata: `/usr/local/bin/stata`; Python: `/opt/tljh/user/bin/python`. The helper uses isolated SAS WORK/SASUSER paths, a shared heavy-job lock, and fresh batch Stata processes. Retain the tool's session/cell identifiers, including nested `exec_command` results, and poll the existing execution without starting duplicate jobs. Sandboxed process listings cannot establish that an escalated runner exited. Errors after the SAS launcher or Stata nonzero `r()` must be addressed even if the outer process returns zero.

Run `sync`, `validate`, and `run` from the git root, with the absolute assigned attempt path. You may use `run --stage sas`, `run --stage stata`, or `run --cell CELL_ID` for a genuine repair; unchanged successful stages should not be repeated. Every execution is retained under `runtime/`. A stage can be skipped only when the helper verifies unchanged inputs and existing outputs.

Finish SAS construction diagnostics before the final Stata execution. Any rebuild regenerates the handoff files and clears the current Stata execution record, even when the change only adds diagnostic output; final analysis must be verified against the current data.
