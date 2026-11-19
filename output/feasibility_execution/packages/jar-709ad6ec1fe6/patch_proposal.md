# Patch proposal: jar-709ad6ec1fe6

The Performance Effect of Feedback Frequency and Detail: Evidence from a Field Experiment in Customer Satisfaction

DOI: 10.1111/1475-679X.12184

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Complete datasheet workflow: the Stata table-generation program plus the independent monthly and weekly R randomization-test programs for Tables 2 and 4.

Entry points: `detalle_post_cluster_reparaciones_jar.do`, `monthly_jar.R`, `weekly_jar.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 5/12184 - The-Performance-Effect-of-Feedback-Frequency-and-Detail-Evidence-from-a-Field-Experiment-in-Customer-Satisfact/clm-datasheet-and-code-files.zip",
      "sha256": "24432011cf24efdfb60fb53adb297208e49aac917e1b7e5bd92bda77b11de9d8"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "fe0b135fe9d92e42bcaf43d86c8570e459342ad3bd0244b8d239c7033732c67a",
  "work_item_sha256": "8c5e132059620e7ff12332080a027e3d5f44fab3f6a001bdab1641947c085598"
}
```

## Proposed actions

### ACT_AUTHOR_DATA: Request the author-prepared, de-identified analysis files or their actual preparation programs, and clarify the CSV’s role and input history. Do not request names/official IDs or reconstruct the proprietary experiment data independently.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_STATA_CSV, REQ_STATA_POST, REQ_STATA_PDA, REQ_STATA_REGION, REQ_R_MONTHLY, REQ_R_WEEKLY, ISS_DATA, ISS_PRODUCERS, ISS_CSV_ROLE, ISS_HISTORY
Evidence: EV_DS_PERIOD, EV_DS_ANON, EV_DS_NDA, EV_DS_PRE_SURVEY, EV_STATA_READS, EV_STATA_TRANSFORMS, EV_STATA_MERGES, EV_MONTHLY_READ, EV_WEEKLY_READ, EV_STATA_WEEKLY_LAGS, EV_STATA_MONTH_LAGS, EV_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Ask the authors for a shareable, de-identified version of the repair-level post DTA and the operator-month PDA and operator-region DTA used by Stata, with source column definitions and merge keys.
2. Ask for fontaneros_seth_monthly.dta and fontaneros_seth_weekly.dta or the documented programs that actually produce them; confirm their producer-consumer order because the supplied Stata file does not save those files.
3. Ask whether the preliminary CSV is still a required input. The current code reads and renames it, then clears it; if it is obsolete, request author confirmation before removing this no-op read.
4. For each file, obtain exact fields, row unit, period, key uniqueness, transformation notes and coverage. Confirm weekly prior-period history and monthly two- and six-period lead/lag history; do not use estimation end dates as coverage evidence.
5. Request only data with project-generated identifiers. The datasheet says the name/official-ID link was destroyed and the supplied analyses use project codes; no real-name crosswalk is needed. Confirm the permitted sharing route for de-identified files under the recorded agreement.

Validation to perform later:

- Once files are provided, use bounded format-aware metadata probes to check expected Stata columns, merge-key cardinality, date bounds and explicit lead/lag coverage before any authorized program execution.

### ACT_STATA_SOFTWARE: Make the Stata commands used by the main entry program available in the intended Stata ado path. confirmdir is only needed when the Mac path branch is used.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_OUTREG2, SW_DISTINCT, SW_CONFIRM_DIR
Evidence: EV_OUTREG2, EV_DISTINCT, EV_CONFIRMDIR, EV_STATA_OUTPUTS, EV_STATA_DISTINCT, EV_STATA_PATH

Preparation / proposed procedure:

1. Install or configure outreg2 and distinct from an approved Stata ado source, then ensure they resolve in the Stata 18 ado path.
2. If running the Mac branch, also provide confirmdir; on another platform, use a supported path configuration rather than invoking the Mac-only command.
3. Do not treat built-in Stata test, mtest() or Stata 18 as missing dependencies.

Validation to perform later:

- After setup, verify the exact invoked command names with which outreg2, which distinct and, only for the Mac branch, which confirmdir.

### ACT_STATA_PATH: Confirm the intended local data/project root and configure the Stata path macro for this operating system.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_STATA_PATH
Evidence: EV_STATA_PATH, EV_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Ask the authors for the complete project directory tree corresponding to the Dropbox paths in the script, including analysis/JAR final program/control_reparaciones, experiment preliminary data and stata import data post.
2. Add a platform-appropriate mypath setup or launch convention only after the actual path is confirmed; the current Mac/Windows branches do not establish a Unix path.

Validation to perform later:

- Before running the do-file, confirm the configured root resolves the log/output directory and every referenced relative input path without changing the source data.

### ACT_R_PACKAGES: Install/configure the missing R packages required by the active monthly and weekly programs.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_DPLYR, SW_VGAM, SW_AER, SW_HAVEN, SW_LFE, SW_PLYR, SW_DOSNOW, SW_SNOW, SW_FOREACH, SW_DATATABLE, SW_AOD
Evidence: EV_R_PACKAGES, EV_MONTHLY_READ, EV_MONTHLY_PARALLEL, EV_WEEKLY_READ, EV_WEEKLY_PARALLEL, EV_SNOW_API, EV_FOREACH_API

Preparation / proposed procedure:

1. Install dplyr, VGAM, AER, haven, lfe, plyr, doSNOW, snow, foreach, data.table and aod in the R library used by R 4.5.0, including their declared dependencies.
2. Keep R 4.5.0 and the installed survival and parallel packages recorded; no author-specific package versions are documented.

Validation to perform later:

- Use a read-only namespace/version probe to verify every package and the required functions before any authorized author-program run.

### ACT_R_NAMESPACE: Resolve the weekly script’s standalone namespace setup. Preserve its A–F sections and run it without relying on monthly_jar.R having attached packages in a shared R session.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_R_NAMESPACE
Evidence: EV_WEEKLY_READ, EV_WEEKLY_PARALLEL, EV_R_PACKAGES, EV_SNOW_API, EV_FOREACH_API

Preparation / proposed procedure:

1. Confirm whether weekly_jar.R is intended to run as a standalone script or only in a preloaded shared R session.
2. For standalone use, explicitly attach or namespace the provider for makeSOCKcluster and cluster helpers, and attach/namespace foreach for times() and %dopar%; do not infer those symbols from a prior monthly run.

Validation to perform later:

- In a fresh R 4.5.0 session after package setup, verify all cluster and foreach calls resolve before running the author code.

### ACT_WEEKLY_CASE: Match the weekly Table 4 C section’s character switch key to the uppercase type passed by its active lapply call, preserving the intended model and uppercase output filename.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_WEEKLY_CASE
Evidence: EV_WEEKLY_SWITCH, EV_WEEKLY_C_CALL, EV_R_SWITCH

**Proposed edit:** `weekly_jar.R:147–147`
Source SHA-256: `8eb80aaa522f290f865d0a4cf55deb521cd7bd46a9aa15460a469468a137a5c9`

The active section passes regType "C", and R matches character-valued switch alternatives exactly. Changing only the switch label preserves the existing model formula and uppercase output filename.

Current text:
```
                         c = AER::tobit(detractor ~ as.factor(aleatorioTratamiento)*firstpart1 +
```

Proposed replacement:
```
                         C = AER::tobit(detractor ~ as.factor(aleatorioTratamiento)*firstpart1 +
```

Preparation / proposed procedure:

1. Apply the single switch-label correction in a future authorized source copy.

Validation to perform later:

- In a future authorized run, confirm the C model produces a non-NULL model result and writes results/tableIVRegCWeekly.csv with the stated columns.

### ACT_MONTHLY_DEBUG: Optionally remove the one-time interactive breakpoint in a future authorized source copy if the intended launcher requires a noninteractive workflow or debugger interaction is unwanted.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: ISS_MONTHLY_DEBUG
Evidence: EV_MONTHLY_DEBUG, EV_DEBUG_PROBE

**Proposed edit:** `monthly_jar.R:217–217`
Source SHA-256: `f2dd3337d43ba7a6b4ee0a24f2ea18bc308a58f7181c7199af3cd18a1a10d356`

This single-line cleanup removes the supplied debugger setting while preserving the regression call. The closed-stdin probe completed successfully, so removal is conditional on the intended launcher and is not required to establish batch feasibility.

Current text:
```
debugonce(replacementRegressMonthly)
```

Proposed replacement:
```

```

Preparation / proposed procedure:

1. Check whether the intended R launcher allows the debugger trace to complete unattended; retain the supplied setting if that behavior is acceptable.
2. If a clean noninteractive run is required or the intended launcher stalls for input, remove only the debugonce line in a future authorized source copy.

Validation to perform later:

- Under the intended launcher, confirm the direct diagnostic call completes without waiting for manual debugger input; if the line is removed, verify the regression call remains unchanged.

### ACT_R_OUTPUT_DIR: Create or verify the R output directory in each script’s launch working directory.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_R_OUTPUT_DIR
Evidence: EV_MONTHLY_PARALLEL, EV_WEEKLY_PARALLEL, EV_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Before running each R program, ensure a writable relative results/ directory exists beside the intended working directory.
2. Keep the monthly CSV/RData files and weekly Table IV CSVs in the documented results/ location.

Validation to perform later:

- Verify the results/ directory exists and is writable before launching either R script.

### ACT_RNG: Clarify how the authors intended Monte Carlo and parallel random-number streams to be reproduced.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_RNG
Evidence: EV_R_RANDOM, EV_MONTHLY_PARALLEL, EV_WEEKLY_PARALLEL

Preparation / proposed procedure:

1. Ask whether exact randomization-test files are expected to match across runs and, if so, request the original seed and parallel RNG stream convention.
2. If no seed was used, document stochastic variability and retain the original analysis rather than inserting a guessed seed.

Validation to perform later:

- When author instructions are known, record the RNG setup and compare a future authorized 1,000-repetition output against the expected reproducibility standard.

### ACT_RUN_SEQUENCE: After data, producer, path and software gaps are resolved, run the three author entrypoints as documented, keeping the independent R inputs distinct from Stata’s in-memory aggregations.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS_PRODUCERS, ISS_STATA_PATH, ISS_R_OUTPUT_DIR
Evidence: EV_DS_WORKFLOW, EV_STATA_WEEKLY_COLLAPSE, EV_STATA_MERGES, EV_MONTHLY_READ, EV_WEEKLY_READ, EV_STATA_OUTPUTS, EV_MONTHLY_PARALLEL, EV_WEEKLY_PARALLEL

Preparation / proposed procedure:

1. Run detalle_post_cluster_reparaciones_jar.do from the author-confirmed Stata root after setting mypath; it produces Stata table exports and four graph files.
2. Run monthly_jar.R with fontaneros_seth_monthly.dta and a writable results/ directory for the monthly Table 2 simulation outputs.
3. Run weekly_jar.R with fontaneros_seth_weekly.dta and a writable results/ directory for the weekly Table 4 simulation outputs.
4. Do not treat Stata’s collapsed in-memory data as the producer of either R DTA; obtain the missing author producer or intended prepared inputs first.

Validation to perform later:

- After an authorized execution, confirm the listed table/graph outputs exist and compare them to the table mapping in the datasheet; execution remains unverified until then.


## Remaining issues and prerequisites

- ISS_DATA [unresolved; full_pipeline]: The archive contains the datasheet and three programs but none of the CSV/DTA inputs referenced by those programs. The datasheet documents author-prepared, de-identified professional data. Ask only for compatible de-identified analysis files or a supported producer; the destroyed real-name crosswalk is historical/privacy context and is not an input required by the supplied code. A permitted shareable route remains unverified.
- ISS_PRODUCERS [unresolved; full_pipeline]: The supplied Stata program collapses data in memory and writes tables; it does not save fontaneros_seth_monthly.dta or fontaneros_seth_weekly.dta. It also reads fontaneros_pda.dta and fontaneros_region.dta without supplied producers. Confirm which files are intended author-prepared primary inputs and supply their compatible producer/specification and order; do not infer that Stata creates them.
- ISS_CSV_ROLE [unresolved; full_pipeline]: The Stata program insheets and renames the preliminary CSV, then immediately replaces the in-memory data with use ..., clear; no later command uses those imported values. Because this read is active, an absent file prevents an unmodified run, but its analytical role and whether the read is obsolete must be confirmed before proposing its removal.
- ISS_HISTORY [unresolved; full_pipeline]: The Stata workflow uses the prior weekly detractor observation and monthly l2/f2 and l6/f6 operator comparisons; the R inputs contain corresponding precomputed boundary fields. Required start/end periods, continuity and preparation history are not supplied. Do not infer history from the estimation filters alone.
- ISS_STATA_PATH [unresolved; full_pipeline]: The Stata file defines local mypath only for Mac and Windows, with Dropbox-specific paths. No path setup for other operating systems is supplied, and the project-relative directory tree is not part of the archive.
- ISS_WEEKLY_CASE [blocking; full_pipeline]: weekly_jar.R calls replacementRegressMonthly with regType "C", but its switch alternative is named lowercase c. R matches character switch alternatives exactly; this section has no matching model branch, so the Table 4 C simulation cannot produce its intended model output. The output name uses uppercase C, so correct the switch key while preserving the model formula and filename.
- ISS_R_NAMESPACE [unresolved; full_pipeline]: The weekly script starts with dplyr/survival/VGAM/lfe but later calls makeSOCKcluster, clusterExport, clusterEvalQ, stopCluster, times and %dopar% without an explicit namespace or package attachment. doSNOW::registerDoSNOW is qualified, but does not make the other names available in a clean session. The clean-session metadata probe found none of these names; do not rely on monthly_jar.R having run first.
- ISS_MONTHLY_DEBUG [preparation; full_pipeline]: monthly_jar.R arms debugonce immediately before its direct regression call. The supplied setting enters the debugger, but unattended behavior depends on the R launcher and input handling: a bounded vanilla R probe with closed stdin completed the call with return code 0 while printing the debugger trace. Treat this as launcher-dependent interactive friction and an optional cleanup candidate, not an unconditional batch-run blocker.
- ISS_R_OUTPUT_DIR [preparation; full_pipeline]: Both R scripts write into relative results/ paths but do not create that directory. Confirm it exists and is writable in the launch working directory before running; no output folder is included in the packaged inventory.
- ISS_RNG [unresolved; full_pipeline]: The R simulations draw replacement treatment assignments with sample() and run 1,000 parallel repetitions without a supplied seed or parallel RNG stream setup. Exact Monte Carlo outputs have no documented deterministic replay setting. Ask whether exact seed-level matching is expected and record the authors’ intended RNG setup; do not invent a seed.
- REQ_STATA_CSV [undetermined]: The Stata entry reads the preliminary bonus/detractor CSV and renames delegacion/provincia, then the subsequent use ..., clear discards that dataset. Its substantive role is unclear, but the current unmodified script requires the file to open.
- REQ_STATA_POST [undetermined]: Author-prepared repair-level DTA read by Stata; the program derives date_fin, mes, semana2, experiment flags, detractor/promotor and operator-week/month outcomes from these fields. Exact schema, date bounds and complete lag history are not supplied.
- REQ_STATA_PDA [undetermined]: PDA data merged by codigo_op and mes after monthly aggregation; the merge requires the pda field.
- REQ_STATA_REGION [undetermined]: Region data merged by codigo_op for regional/provincial balance tabulations.
- REQ_R_MONTHLY [undetermined]: Author-prepared monthly analysis DTA directly read by monthly_jar.R for its separate Table 2 randomization-test companion. No producer or compatible release is supplied.
- REQ_R_WEEKLY [undetermined]: Author-prepared weekly analysis DTA directly read by weekly_jar.R for its separate Table 4 randomization-test companion. No producer or compatible release is supplied.
- SW_OUTREG2 [preparation_required]: The Stata entry program invokes outreg2 for its table exports; the actual command was not found in the checked Stata 18 ado paths.
- SW_DISTINCT [preparation_required]: The Stata entry program invokes distinct for operator counts; the actual command was not found in the checked Stata 18 ado paths.
- SW_CONFIRM_DIR [preparation_required]: The script calls confirmdir only in its Mac path branch; the command was not found in the checked Stata 18 ado paths. It is unnecessary on a non-Mac branch if mypath is configured another way.
- SW_DPLYR [preparation_required]: Required by both R programs and not installed in the current R library.
- SW_VGAM [preparation_required]: Loaded by both R programs and used for variance/covariance work; not installed.
- SW_AER [preparation_required]: Used for Tobit models in the R programs; not installed.
- SW_HAVEN [preparation_required]: Required by haven::read_dta in both R programs; not installed.
- SW_LFE [preparation_required]: Required for felm models in active monthly and weekly branches; not installed.
- SW_PLYR [preparation_required]: Required by plyr::rlply in both R programs; not installed.
- SW_DOSNOW [preparation_required]: Required for doSNOW::registerDoSNOW and loaded by monthly code; not installed. Weekly calls the namespace-qualified registration function without loading it at the top.
- SW_SNOW [preparation_required]: Required for the unqualified makeSOCKcluster and cluster helpers used in the R programs; not installed.
- SW_FOREACH [preparation_required]: Required for unqualified times() and %dopar% calls in both R programs; not installed.
- SW_DATATABLE [preparation_required]: Required by data.table::rbindlist in the monthly output stage; not installed.
- SW_AOD [preparation_required]: Required by aod::wald.test for the weekly randomization tests; not installed.

## Review notes

- No analysis_only scope is justified: the R analysis inputs are absent and no supported compatible route or supplied producer is available. The complete three-program workflow remains the target.
- The datasheet says study records were de-identified with generated professional_id values and the identity crosswalk was destroyed. The supplied scripts use project codes; no real-name or official-ID link is an execution input.
- The datasheet says the pre-experiment survey was not used in the paper analyses; it is not a separate mandatory input to this workflow.
- Stata firstpart1 and secondpart1 are unique abbreviations for generated firstpart1b and secondpart1b under default variable-abbreviation behavior; they are not recorded as missing raw fields.
- The monthly script’s final lets assignment overrides its earlier vector and selects h, j, l, n, p, r, z, ee, gg and ii. sandwich/lmtest calls are confined to unselected function branches and are not current-scope requirements.
- The main Stata script writes tables and graphs but no monthly/weekly R input DTA; producer-consumer order for the R companions remains unresolved.
- No author program or regression was executed, no package was installed and no dataset was downloaded; execution_verified remains false.
- Finalizer validation history: `ERROR: Not a plain source/artifact file: historical artifact work_item.json` was corrected by changing EV_PACKAGE_INVENTORY artifact_path to `work_item.json`. `ERROR: Unknown action targets: ['SW_DATATABLE']` was corrected by aligning the software record ID to `SW_DATATABLE`.
- Finalizer validation history: `ERROR: Unknown scope software: ['SW_DATA.TABLE']` showed the scope list also retained the former ID; it was aligned to `SW_DATATABLE`.
- Coordinator-provided bounded vanilla R probe (closed stdin, no author code/data/regression) shows debugonce entered a trace and returned rc 0. The monthly debugger line is launcher-dependent interactive friction; its removal is optional conditional cleanup, not a confirmed batch blocker.
- Finalizer validation history: `ERROR: Probe/inspection artifact is outside the assigned work directory and frozen artifact registry` was corrected by copying the coordinator-provided bounded JSON probe unchanged to `probes/feedback_debugonce_batch_probe.json` and pointing EV_DEBUG_PROBE to that assigned-work copy (SHA-256 preserved).
