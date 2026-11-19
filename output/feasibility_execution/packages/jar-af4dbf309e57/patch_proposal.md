# Patch proposal: jar-af4dbf309e57

Target setting in hierarchies: the role of middle managers

DOI: 10.1111/1475-679X.12508

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete supplied Stata workflow: prepare actual sales, sales targets, headcount and working days; construct the merged subsidiary panel and subsidiaries_final.dta; then run the supplied descriptive, correlation, regression and figure sections. The authors identify sub_id as the subsidiary key.

Entry points: `BHS_dofile.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 1/12508 - Target-setting-in-hierarchies-the-role-of-middle-managers/bhs-datasheet-and-code.zip",
      "sha256": "88f68171b0a84437a322a64fdfd29ef380d0445fcde674d4572e07408c566853"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "a8d065d2d7286a314678e3f0bc099ba4c3290c2cced679485dc0fb30b1305e9e"
}
```

## Proposed actions

### A_FIRM_DATA: Establish a currently authorized route to the three author-described firm inputs. The archive contains no workbooks; the authors' NDA statement is not evidence that this user is unlicensed or barred.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_ACTUAL, R_PLAN, R_HEADCOUNT
Evidence: E_DATA_ACT, E_DATA_PLAN, E_DATA_HC, E_NDA, E_INVENTORY

Preparation / proposed procedure:

1. Identify a currently authorized local, controlled-environment or otherwise shareable route for the actual-sales, sales-target and headcount datasets.
2. Obtain the source inputs or an authorized delivery with their original monthly subsidiary/service-type fields and documented periods; record permissions and storage conditions separately from the authors' NDA history.
3. Keep the actual-sales source period at the datasheet's 2007–2016 history and verify the target and headcount periods against the supplied code and source documentation; do not substitute reconstructed firm data.

Validation to perform later:

- After authorized acquisition, check workbook/table identities and monthly subsidiary/service-type/year coverage using bounded metadata and field checks, then compare the source fields to the existing Stata reshape contracts.
- Confirm the current user's access conditions from actual access evidence; a catalog miss or the authors' NDA alone does not establish a denial.

### A_WORKDAYS_SOURCE: Identify the specific official working-days source and the mapping needed by the supplied merge. No exact public page or compatible product is identified in the package.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_WORKDAYS, I_REGION_MAP
Evidence: E_DATA_WD, E_REGION_KEY, E_WORKDAYS_MERGE, E_INVENTORY

Preparation / proposed procedure:

1. Record the exact official webpage or dataset used by the authors, the unit/definition of a working day, and the relevant year/month coverage.
2. Document how each official region identifier maps to the code-derived sub_region value (the first three characters of sub_id), and identify the source fields corresponding to year, month and sub_working_days.
3. Once a compatible permitted page and field contract are established, collect or convert the documented values into the table expected by the existing Stata merge; do not infer a substitute source or region mapping.

Validation to perform later:

- Use a bounded official static page/documentation check for the identified source, then verify the acquired table's fields, period and region keys against the merge contract without scanning or downloading a payload during this assessment.

### A_INPUT_CONTRACT: Resolve the missing workbook-loading contract before the reshape and cleaning blocks. The supplied code names four Excel inputs but does not give file paths or load/import statements.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_LOAD_CONTRACT
Evidence: E_CODE_INPUT_ACT, E_CODE_INPUT_PLAN, E_CODE_INPUT_HC, E_CODE_INPUT_WD, E_INVENTORY

Preparation / proposed procedure:

1. For each named input, record the workbook/file path, sheet, header row, data range, imported variable names and any Stata import options or manual loading step that produces the variables already used by the code.
2. Keep the existing reshape, aggregation, labels and analysis definitions unchanged; do not write guessed import commands or rename fields without a documented mapping.
3. Place the authorized workbooks and a portable working copy of BHS_dofile.do under a coherent relative execution root so the code's relative DTA and output names resolve there.

Validation to perform later:

- Before running the author workflow, inspect imported column names and types against each existing reshape/merge statement; do not trial the author program or construct synthetic data during this audit.

### A_HISTORY_CONTRACT: Resolve the specific monthly key/history contract used by the supplied row-based prior-year calculations while preserving the authored sample boundary.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_HISTORY_KEYS, R_ACTUAL, R_PLAN, R_HEADCOUNT, R_WORKDAYS
Evidence: E_DATA_ACT, E_DATA_PLAN, E_DATA_HC, E_DATA_WD, E_REGION_LAG, E_LAG_TARGETS, E_LAG_CONTROLS, E_LAG_WORKDAYS, E_FINAL_SAMPLE

Preparation / proposed procedure:

1. For each input, document its available monthly years, subsidiary/region key uniqueness, and missing-month pattern in the authorized source.
2. Check whether the code's sorted [_n-12] offsets refer to the intended prior-year month for each panel; preserve any missing-lag behavior the code permits and do not invent extra years beyond the source and code requirements.
3. Keep the supplied final sample rule year >= 2011; treat missing or incomplete prior rows as a source-compatibility/fidelity gap rather than silently extending the sample or changing the authored calculation.

Validation to perform later:

- After authorized inputs are available, compare bounded key/month coverage and the exact row order used by the source to the documented prior-year calculation; no row-count sweep or estimator is part of this assessment.

### A_ORDERED_RUN: Run the supplied Stata blocks in producer-consumer order while carrying the original clean-memory boundaries with moved sections. The first actual/target merge must create subsidiaries_merged1.dta before its regional and HQ consumers; retain the merge's trailing reset, the reset between region and HQ, and the reset before the headcount use.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I_STAGE_ORDER
Evidence: E_ORDER_EARLY, E_ACTUAL_MERGE_SAVE, E_REGION_PRODUCER, E_HQ_SAVE, E_HEADCOUNT_MERGE, E_WORKDAYS_MERGE, E_REGION_MERGE, E_HQ_MERGE, E_FINAL_SAVE, E_ANALYSIS_T2, E_ANALYSIS_T3, E_ANALYSIS_T4, E_ANALYSIS_FIG1, E_ANALYSIS_T5, E_ANALYSIS_T6, E_ANALYSIS_FIG2, E_WORKFLOW, E_RESET_ACTUAL_TO_PLAN, E_RESET_PLAN_TO_HC, E_RESET_HC_TO_WD, E_RESET_WD_TO_MERGE, E_RESET_REGION_TO_HQ, E_RESET_HQ_TO_HEADCOUNT, E_RESET_MERGED1_TO_REGION

Preparation / proposed procedure:

1. Make a separate working copy of BHS_dofile.do and stage authorized inputs under a coherent relative working root. Begin with a clean Stata session before the first manual actual-sales load (the source has no clear all before its line 11 load comment); keep outputs outside the assigned audit generation and avoid hard-coded Dropbox paths.
2. After resolving the input-loading contract, preserve the original empty-memory boundaries around the four manual sources: run the actual-sales preparation at lines 8–49, then keep clear all at line 52 before the target load comment at 59; run targets at 56–91, then keep clear all at line 94 before headcount at 101; run headcount at 98–125, then keep clear all at line 128 before working days at 135; run working days at 131–148 and keep clear all at line 151 before the moved merge/target-preparation sequence. These blocks create sub_sales_numbers_act.dta, sub_sales_numbers_plan.dta, sub_headcount.dta and sub_working_days.dta.
3. Run the first actual/target merge at lines 270–288 to create subsidiaries_merged1.dta. Carry its original trailing clear all at line 290 with this moved block, so memory is empty before the regional block opens the saved producer at line 158.
4. After that producer, run the regional block at lines 154–205 and retain its clear all at line 208 between the regional and HQ sections. Then run the HQ block at lines 211–257 and retain its clear all at line 260 before the headcount merge section.
5. Enter the headcount merge section at lines 293–303 from empty memory: the existing use at line 297 opens subsidiaries_merged1.dta. Continue through the working-days, region and HQ merges at lines 307–345 without clearing or reloading the in-memory panel; saves at 303, 319, 332 and 345 are checkpoints, not reload points.
6. Run variable construction and final-panel save at lines 351–552 to create subsidiaries_final.dta, then run all supplied analysis branches in order: Table 2 at lines 565–611, Table 3 at 622–637, Table 4 and Figure 1 at 647–962, Table 5 at 963–1108, and Table 6 and Figure 2 at 1109–1161.
7. Retain the source output endpoints: Table3.csv and the outreg2 .xls tables are written in the working directory; descriptives and graph commands produce Results/graph-window output, and the supplied code has no later consumer requiring saved graph files.

Validation to perform later:

- Before a separately authorized full run, confirm each generated DTA path exists and its produced key/columns support the next supplied merge; preserve the four source branches and all downstream analyses.
- After add-on setup, use Stata 18 in the portable working directory and run the ordered full workflow with authorized data; compare its outputs to the paper only after execution is separately authorized.

### A_OUTREG2_SETUP: Make the required outreg2 Stata command available in the runtime adopath before running Tables 4–6. The assigned environment probe did not find it in the checked default or configured paths; no package was installed.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_OUTREG2
Evidence: E_ENV, E_ANALYSIS_T4, E_ANALYSIS_T5, E_ANALYSIS_T6

Preparation / proposed procedure:

1. Set up an authorized compatible release of outreg2 in the Stata runtime environment used for the portable working copy.
2. Keep the add-on path visible to the future batch Stata process; do not change any regression or table-writing options to avoid the dependency.

Validation to perform later:

- Before a future authorized run, use read-only Stata which/help metadata to confirm outreg2 resolves from that runtime path; do not run estimators during setup validation.

### A_INTEFF_SETUP: The supplied Table 5 section requires the inteff command, which was not found by the assigned Stata 18 which probe. Its interface/version compatibility remains unverified; no estimator or syntax trial was run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_INTEFF
Evidence: E_INTEFF, E_ANALYSIS_INTEFF

Preparation / proposed procedure:

1. Set up an authorized inteff release that provides the command and documents support for the supplied invocation after logit; do not substitute a different interaction calculation.
2. Keep this command on the adopath used by the same Stata 18 runtime that will execute the workflow.

Validation to perform later:

- Use read-only which/help or official static documentation to confirm the command interface and required dependencies before an authorized run; no logit or inteff invocation is part of this audit.


## Remaining issues and prerequisites

- I_LOAD_CONTRACT [unresolved; full_pipeline]: The supplied do-file has comments naming four Excel loads, then uses/reshapes already-loaded variables without any import command. Workbook paths, sheets, header rows, source ranges, imported variable names and the exact working-days source/definition are absent. These are unresolved input contracts; no import syntax or replacement field definitions are inferred.
- I_STAGE_ORDER [preparation; full_pipeline]: The regional and HQ preparation sections use subsidiaries_merged1.dta before the later supplied merge block creates it. The producer is present, so this is a supported run-order preparation step, not an absent empirical input; execute the regional/HQ blocks after the first merge in a working copy.
- I_HISTORY_KEYS [unresolved; full_pipeline]: The code sorts monthly observations by subsidiary or region plus year/month and forms target, headcount and working-day lags with [_n-12], then retains years from 2011. The datasheet documents monthly data and actual-sales years 2007–2016, but does not establish the exact target, headcount or working-days period, continuity, missing-month pattern, or uniqueness of the joined keys. Therefore it is unknown whether row twelve earlier is the intended prior-year month for all input series. Preserve the authored boundary behavior: the code does not explicitly require a nonmissing lag for every first retained observation, and no extra years are inferred beyond actual code needs.
- I_REGION_MAP [unresolved; full_pipeline]: The do-file derives sub_region as substr(sub_id,1,3) and later merges the working-days table on sub_region/year/month. The datasheet describes counts per region but gives no mapping from the official webpage's region identifiers or labels to these code-derived keys, so join compatibility and the precise working-day definition remain unresolved.
- R_ACTUAL [undetermined]: Firm-provided monthly subsidiary actual sales by service type, combined by the supplied Stata preparation. The datasheet reports 2007–2016; the code expects the named actual-sales workbook fields and writes sub_sales_numbers_act.dta.
- R_PLAN [undetermined]: Firm-provided monthly subsidiary sales targets by service type, combined by the supplied Stata preparation and merged with actual sales. The code's target field family covers 2010–2016; the datasheet does not specify the series' full period.
- R_HEADCOUNT [undetermined]: Firm-provided monthly total headcount by subsidiary, used to form prior-row and relative-change controls and merged into the subsidiary panel. The code expects a preloaded sub_id/sub_headcount_total reshape input; exact source workbook and period are not supplied.
- R_WORKDAYS [undetermined]: Working-day counts by region, year and month used for controls and prior-year changes. The code expects sub_region, year, month and sub_working_days, where sub_region is formed from the first three characters of sub_id. The datasheet says the values were hand-collected from official webpages but names no source or period.
- SW_OUTREG2 [preparation_required]: The assigned environment probe did not find outreg2 in either checked adopath; the do-file invokes it throughout Tables 4–6. Installation/setup is not performed here.
- SW_INTEFF [preparation_required]: The Stata 18 which probe returned 111 for inteff in the checked runtime path; this is a command-availability result, not an entitlement finding. The code uses inteff in Table 5.

## Review notes

- Review covered the datasheet, native Stata do-file and supporting PDF mirror. No author program, estimator, data import, SAS startup or installation was run; one bounded lookup of official static Stata merge documentation is recorded as E_MERGE_COMPAT.
- The datasheet's NDA statement describes the authors' firm-data arrangement. Current-user authorization remains unknown; the supplied archive does not establish either entitlement or a denial.
- The package contains no prepared analysis dataset or analysis-only bypass route, so the supported route is full_pipeline. The four source inputs are not included.
- Static stage trace E_WORKFLOW covers actual/target/headcount/working-days preparation, producer-consumer ordering, the final panel and all authored analysis branches. The two source sections that consume subsidiaries_merged1.dta precede its producer in the native file; the supplied producer supports an ordered working-copy run.
- The frozen dependency IDs D0001–D0003 are all retained. Their supplied line locators do not identify the native do-file reads (D0001 line 152 and D0003 line 553 are blank; D0002 line 261 is a separator); E_WORKFLOW records the actual consumers and producers.
- Process history: the first draft-construction helper hashed decoded text after newline normalization and returned ValueError for BHS_dofile.do. Its exact run record, stderr and read-only source copy are retained under probes/archive; the byte-based correction succeeded. E_PROCESS_01 is intentionally unreferenced by scientific evidence links.
- Process history: a later evidence-stage helper guard incorrectly treated its process-row ID as a scientific evidence_ids reference. The exact run record, stderr and read-only source copy are retained under probes/archive; the corrected guard checks only recursive evidence_ids lists. E_PROCESS_02 is intentionally unreferenced by scientific evidence links.
- Process history: the first saved schema preflight found missing evidence_ids arrays on the four routes; its actual run record and stderr are retained as E_PROCESS_03. Source evidence links were added to the routes before rerunning preflight. E_PROCESS_03 remains intentionally unreferenced by scientific evidence links.
- Process history: the second schema preflight failed because its trace-line check normalized CRLF before comparing saved line hashes; the exact run record/stderr and archived original helper are retained as E_PROCESS_04. The corrected v2 checker verifies raw cached bytes and passed. E_PROCESS_04 remains intentionally unreferenced by scientific evidence links.
- The ordered-run proposal and static trace now preserve the native clear all boundaries when moving whole sections: after each manual-input preparation, after the first merged1 save, between regional and HQ target preparation, and after HQ before the line 297 headcount use. The later line 297–345 panel remains continuous in memory. This is a documentation/proposal correction only; no Stata program was executed and no empirical data were read.
