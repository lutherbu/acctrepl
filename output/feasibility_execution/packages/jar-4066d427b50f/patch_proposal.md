# Patch proposal: jar-4066d427b50f

Do Earnings Announcements Affect Employee Spending? Evidence from Transaction Data

DOI: 10.1111/1475-679X.70027

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied Replication.do workflow for Tables 1–12, including the README's documented manual Table 1 and Table 2 Panel C steps.

Entry points: `Replication.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 2/70027 - Do-Earnings-Announcements-Affect-Employee-Spending-Evidence-from-Transaction-Data/lntz-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "e33f130993b4bf908cb8ca0aed97e5b839365d8ea4ee7d896c522a1fb4b8c377"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "d46bdd28fc9a499c35718b88d51582293f49c10dbecadad5b62357b447242221"
}
```

## Proposed actions

### A_PREPARE_CRSP_MONTHLY: Prepare the unprovided MonthlyCRSP author input from locally available raw MSF returns and MSENAMES name-history components; date-valid construction and sample coverage remain preparation/validation.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CRSP_MONTHLY_RETURNS, R_CRSP_MONTHLY_NAMES
Evidence: E_MONTHLY_CRSP_READ, E_SAS_CRSP, E_INPUT_CROSSWALK, E_PROBE_CRSP_MSF, E_PROBE_CRSP_MSENAMES

Preparation / proposed procedure:

1. Confirm the CRSP monthly sample dates and coverage required by the earnings-event data.
2. Join MSF returns to MSENAMES by PERMNO and valid monthly name dates; preserve TICKER and SHRCD alongside DATE and RET.
3. Resolve duplicates and date types using the authors' documented convention, then write the exact MonthlyCRSP input expected by Replication.do.

Validation to perform later:

- Check the prepared header and types against shrcd, permno, ticker, date and ret.
- Record date range, distinct permno-date counts and unresolved link/coverage decisions before running the Stata driver.

### A_PREPARE_CRSP_DAILY: Prepare DailyReturns from locally available raw DSF returns and DSENAMES name-history components, while resolving the separate DSI.EWRETD to code EWRET mapping.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CRSP_DAILY_RETURNS, R_CRSP_DAILY_NAMES, R_CRSP_DAILY_INDEX
Evidence: E_DAILY_CRSP_READ, E_DAILY_CAR_WINDOWS, E_SAS_CRSP, E_INPUT_CROSSWALK, E_PROBE_CRSP_DSF, E_PROBE_CRSP_DSENAMES

Preparation / proposed procedure:

1. Confirm that DSF and DSENAMES cover every event date, the ±7 trading-observation windows and the [-375,-10] calendar-day volatility interval.
2. Merge name-history share codes to daily securities by PERMNO and valid dates; resolve whether DSI.EWRETD is the intended source for the code's EWRET field and merge by DATE.
3. Write DailyReturns with the exact consumed columns and preserve the author event-date convention.

Validation to perform later:

- Check exact field names/types and report minimum/maximum dates and PERMNO coverage.
- Confirm nonmissing equal-weight market returns for the relevant event windows before author-code execution.

### A_PREPARE_COMPUSTAT_QUARTERLY: Build the missing CompustatQuarterly prepared input from locally available raw FUNDQ and CCM link components; the output aliases/formulas, SIC mapping and historical filters remain unresolved.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMPUSTAT_FUNDQ, R_COMPUSTAT_CCM_LINK, R_CRSP_MONTHLY_NAMES
Evidence: E_COMPUSTAT_QUARTERLY_READ, E_DOC_COMPUSTAT, E_SAS_COMP, E_INPUT_CROSSWALK, E_PROBE_COMP_FUNDQ, E_PROBE_CRSP_CCMXPF_LINKTABLE

Preparation / proposed procedure:

1. Confirm the FUNDQ reporting-date fields and desired sample period.
2. Apply CCM GVKEY-to-LPERMNO links with valid-date/link-type rules supplied by the authors.
3. Resolve the SIC field: FUNDQ's selected schema has no SIC, while CRSP name history has SICCD; confirm the intended source and mapping.
4. Create the exact CompustatQuarterly input with the fields used by the driver, including LPERMNO and SIC.

Validation to perform later:

- Check each required column and the quarter/security join keys.
- Record link-date filters, duplicate handling and coverage limits before running the driver.

### A_PREPARE_ICLINK: Prepare the separate iclink join input from a compatible IBES/CRSP historical linking product after confirming the author's definition.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_ICLINK
Evidence: E_ICLINK_READ, E_SAS_IBES, E_INPUT_CROSSWALK

Preparation / proposed procedure:

1. Confirm the intended WRDS IBES/CRSP link product and its date-valid fields.
2. Apply the authors' validity and duplicate rules and retain the expected permno/ticker columns.
3. Place the resulting iclink table beside Replication.do.

Validation to perform later:

- Check the join keys, link-date range and uniqueness relevant to the CompustatQData construction.

### A_PREPARE_IBES: Obtain the author's EarningsSurprises table or an author-documented construction of its SUE3, announcement dates and GVKEY mapping.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_IBES_SURPRISES
Evidence: E_IBES_SURPRISE_READ, E_DOC_IBES, E_SAS_IBES, E_INPUT_CROSSWALK

Preparation / proposed procedure:

1. Request the exact EarningsSurprises input and the definition of SUE3, RDQ/REPDATS and actual EPS.
2. If reconstructing from IBES detail/summary products, apply the authors' forecast horizon, actual-date convention and historical ticker-to-GVKEY link rules.
3. Write the ready table with gvkey, rdq, repdats, act and sue3 as consumed by the script.

Validation to perform later:

- Compare the resulting schema and event-date/forecast-period conventions to the authors' source notes before analysis.

### A_PREPARE_HEADQUARTERS: Use the locally readable CIK-GVKEY raw link component and check the documented LM 10-X and SEC exhibit source-document roots before any new acquisition; confirm the exact quarterly header product, date basis and BA_state construction.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_LM_HEADER, R_GVKEY_CIK_LINK
Evidence: E_LM_HEADER_READ, E_GVKEY_CIK_LINK_READ, E_DOC_HQ_SOURCE, E_SAS_IBES, E_INPUT_CROSSWALK, E_LOCAL_LM_SEC_CORPORA, E_PROBE_WRDSSEC_WCIKLINK_GVKEY

Preparation / proposed procedure:

1. Check the documented local LM 10-X source-document candidate at ${ACCTREPL_LM10X}/{YEAR}/ and SEC exhibit candidates at ${ACCTREPL_SEC_PARSED} and ${ACCTREPL_SEC_RAW} before proposing any new download; their ability to produce the combined header CSV is unverified and no recursive scan or payload read is part of this assessment.
2. Confirm the source's CIK, fiscal-quarter f_yq and BA_state fields, header-cleaning/date basis and continuous 1993–2021 coverage; retain the exact author-named CSV route as unverified until those contracts are established.
3. Treat the local WCIKLINK_GVKEY candidate as a readable raw link component with its native keys and validity fields; apply a period-appropriate link rule only when the author's selection convention is supported.
4. Build the exact cik/f_yq/ba_state and gvkey/yq output only after the source and period rules are confirmed.

Validation to perform later:

- Check CIK/GVKEY/date linkage, state-field semantics and 1993–2021 sample-period coverage before building HeadquarterState.
- Record which local source-document candidate, if any, supports each required field and the exact header-cleaning rule.

### A_ACQUIRE_YODLEE: Obtain each required employee, weekly/daily consumption, stock-transaction, SD and category/event-time table under the authors' permitted data arrangements; these are separate products and should not be treated as one verified file.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_EMPLOYEE_PANEL, R_CONSUMPTION_WEEKLY, R_BANK2BROKER, R_SD_WEEKLY, R_CATEGORY_CONSUMPTION, R_DAILY_CONSUMPTION, R_CALENDAR_WEEK_CONSUMPTION
Evidence: E_DOC_YODLEE, E_DOC_YODLEE_RIGHTS, E_EMPLOYEE_PANEL_READ, E_CONSUMPTION_READ, E_BANK2BROKER_READ, E_SD_WEEKLY_READ, E_CATEGORY_CONSUMPTION_READ, E_DAILY_CONSUMPTION_READ, E_CALENDAR_WEEK_READ

Preparation / proposed procedure:

1. Confirm current access and delivery for each author-named table; the datasheet's no-publication-restriction statement is specific to the purchased transaction data.
2. Request field dictionaries, date ranges, member/merchant identifiers and the author's preparation/crosswalk rules for each delivery.
3. Deliver separate ready tables for employee-month characteristics, event-week total consumption, stock transactions, weekly SD, category measures, daily consumption and calendar-week sensitivity.

Validation to perform later:

- Check exact consumed fields, member/event keys, frequency and retrieval-date coverage for each table independently.
- Record any table that is unavailable or has a different identifier or date basis before the run.

### A_PREPARE_MERCHANT_MAP: Provide the employer merchant-to-ticker mapping with valid listing/delisting dates used to form EmployeeCharData.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_MERCHANT_MAPPING
Evidence: E_MERCHANT_MAPPING_READ, E_INPUT_CROSSWALK

Preparation / proposed procedure:

1. Obtain the authors' primary_merchant_name-to-ticker mapping and its source/cleaning notes.
2. Use listing and delisting dates to form the employee-month link, preserving ambiguous or unmatched merchant names for review.

Validation to perform later:

- Check mapping key uniqueness and validity intervals against the monthly employee observations.

### A_PREPARE_NEWS: Prepare the RavenPack monthly news input and both firm identifier crosswalks; confirm the 108-month import loop versus 100-file consolidation range.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_RAVENPACK_MONTHLY, R_NCUSIP_TICKER_LINK, R_RP_ENTITY_NCUSIP_LINK, I_RAVENPACK_APPEND_RANGE
Evidence: E_DOC_RAVENPACK, E_RP_MONTH_RANGE, E_RP_FIELD_CONSUMPTION, E_NEWS_APPEND, E_NCUSIP_TICKER_READ, E_RP_ENTITY_LINK_READ, E_RP_ENTITY_LINK_REUSE, E_INPUT_CROSSWALK

Preparation / proposed procedure:

1. Obtain the author-provided RavenPack monthly exports and required ticker-to-NCUSIP and NCUSIP-to-RP-entity crosswalks.
2. Verify the export has the fields consumed by the script; the selected local annual RPA schema differs on headline/reporting-period/sentiment fields and its bounded reads timed out.
3. Confirm whether all 108 months should be included; if so, update the append and cleanup bounds to match the intended range before execution.

Validation to perform later:

- Check monthly file coverage and crosswalk keys over 2013–2021.
- Reconcile the article-level fields and date window with the authors' RavenPack export definition.

### A_PROVIDE_OTHER_INPUTS: Provide the unproduced EAevents and CompustatData inputs and document their source/table-building logic.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_EA_EVENTS, R_COMPUSTAT_DATA, I_COMPUSTAT_DATA_UNPRODUCED
Evidence: E_EAEVENTS_READ, E_COMPUSTAT_DATA_PANEL_B, E_COMPUSTAT_DATA_PANEL_C, E_WORKFLOW_CLOSURE, E_INPUT_CROSSWALK

Preparation / proposed procedure:

1. Request the author-defined EAevents table and its employee/event inclusion rules.
2. Request CompustatData or implement its documented quarterly Compustat/CRSP/IBES construction; the current supplied driver reads it twice but never writes it.
3. Place both ready inputs at the exact dataset names consumed by the code.

Validation to perform later:

- Check announcement date, ticker, member and security keys for EAevents.
- Check CompustatData quarter, permno, gvkey, ratios, SIC and event date fields, including the yq 215–242 branch coverage.

### A_SETUP_STATA: Prepare the two invoked Stata commands whose metadata checks report them unavailable: winsor2 and asdoc. The other five exact helper checks are recorded with their observed Stata 18 results; their command behavior/version compatibility remains separate.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR2, SW_ASDOC
Evidence: E_ORIGINAL_ENV, E_WINSOR2_CALL, E_RANGESTAT_CALL, E_FFIND_CALL, E_ESTSTO_REGHDFE_CALL, E_ASDOC_CALL, E_NVALS_CALL, E_WHICH_RANGESTAT, E_WHICH_FFIND, E_WHICH_ESTSTO, E_WHICH_ASDOC, E_WHICH_GNVALS

Preparation / proposed procedure:

1. Install or configure winsor2 and asdoc in the selected Stata ado path; the registered environment probe reports winsor2 unavailable and the exact Stata 18 `which asdoc` check reports asdoc unavailable.
2. Retain the exact metadata positives for rangestat, ffind, eststo and _gnvals; these checks establish command/helper presence only, not author-call syntax or release compatibility.
3. Keep the original successful Stata, reghdfe, ftools, esttab, estpost and estadd metadata and ensure the configured search path is preserved.

Validation to perform later:

- After configuration, record exact availability for winsor2 and asdoc in the selected Stata environment; no package installation or author-code trial was performed here.
- Resolve the separate Stata 18 versus documented StataNow 19.5 compatibility question before running the full workflow.

### A_CONFIRM_STATA_VERSION: Resolve whether Stata 18 is supported or use the documented StataNow 19.5 replication release.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: SW_STATA, I_STATA_VERSION_DIFFERENCE
Evidence: E_README_WORKFLOW, E_ORIGINAL_ENV

Preparation / proposed procedure:

1. Check the authors' required Stata release and any release-specific commands after input preparation.
2. Use StataNow 19.5 or record an author-supported Stata 18 compatibility determination.

Validation to perform later:

- Record the selected runtime version and any author-confirmed compatibility notes.

### A_COMPLETE_MANUAL_TABLES: Complete the README's post-run manual calculations for Table 1 and Table 2 Panel C.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_MANUAL_TABLE_STEPS
Evidence: E_README_MANUAL_T1, E_README_MANUAL_T2

Preparation / proposed procedure:

1. For Table 1, calculate the observation differences between the reported sample counts after each restriction.
2. For Table 2 Panel C, copy the code-produced unique-firm counts and percentages for the main sample and Compustat-CRSP-IBES universe into the table.

Validation to perform later:

- Reconcile the manually completed values to the source sample-count and industry outputs and preserve the completed table artifact.

### A_RUN_AFTER_READY: Run the full Stata workflow only after all required tables, crosswalks, software and manual-output instructions are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_CRSP_MONTHLY_RETURNS, R_CRSP_MONTHLY_NAMES, R_CRSP_DAILY_RETURNS, R_CRSP_DAILY_NAMES, R_CRSP_DAILY_INDEX, R_COMPUSTAT_FUNDQ, R_COMPUSTAT_CCM_LINK, R_ICLINK, R_IBES_SURPRISES, R_EMPLOYEE_PANEL, R_MERCHANT_MAPPING, R_LM_HEADER, R_GVKEY_CIK_LINK, R_EA_EVENTS, R_CONSUMPTION_WEEKLY, R_BANK2BROKER, R_NCUSIP_TICKER_LINK, R_RP_ENTITY_NCUSIP_LINK, R_RAVENPACK_MONTHLY, R_SD_WEEKLY, R_CATEGORY_CONSUMPTION, R_DAILY_CONSUMPTION, R_COMPUSTAT_DATA, R_CALENDAR_WEEK_CONSUMPTION, SW_STATA, SW_REGHDFE, SW_FTOOLS, SW_ESTTAB, SW_ESTPOST, SW_ESTADD, SW_WINSOR2, SW_RANGESTAT, SW_FFIND, SW_ESTSTO, SW_ASDOC, SW_GNVALS, I_COMPUSTAT_DATA_UNPRODUCED, I_RAVENPACK_APPEND_RANGE, I_MANUAL_TABLE_STEPS, I_STATA_VERSION_DIFFERENCE, I_WINSOR2_MISSING
Evidence: E_README_WORKFLOW, E_INPUT_CROSSWALK, E_WORKFLOW_CLOSURE, E_ORIGINAL_ENV

Preparation / proposed procedure:

1. Stage all prepared direct inputs and their source dictionaries in the working directory used by Replication.do.
2. Confirm the documented software dependencies, version choice, CompustatData producer and RavenPack append range are resolved.
3. Execute Replication.do in Stata from the assigned project working directory, preserving generated CSV/DOC outputs and the run record.
4. Complete the Table 1 and Table 2 manual steps after the code outputs are available.

Validation to perform later:

- Compare output tables 1–12 with the paper's stated sample counts, variable definitions and reported results.
- Record runtime, exact input hashes, output paths and any discrepancies; this assessment itself did not execute the program.


## Remaining issues and prerequisites

- I_COMPUSTAT_DATA_UNPRODUCED [preparation; full_pipeline]: CompustatData is consumed at two Table 2 branches but no matching save is present in the complete supplied driver. Obtain the author table or add a documented producer from compatible source data before a full run.
- I_RAVENPACK_APPEND_RANGE [preparation; full_pipeline]: The code iterates 9 years × 12 months (108 monthly paths) but appends and erases only News_1–News_100. If all imports succeed, the final eight generated monthly News files are omitted from consolidation; confirm whether this is intentional and align the ranges.
- I_MANUAL_TABLE_STEPS [preparation; full_pipeline]: README requires manual calculation of Table 1 sample-count differences and manual entry of Table 2 Panel C unique-firm counts/percentages after running the code.
- I_STATA_VERSION_DIFFERENCE [unresolved; full_pipeline]: README identifies StataNow 19.5 as the replication environment; the registered local runtime is Stata 18. No compatibility run is authorized or performed, so the version match remains unresolved.
- I_WINSOR2_MISSING [preparation; full_pipeline]: winsor2 is explicitly unavailable in the registered environment and is invoked in the analysis driver; install/configure it before a full run.
- R_CRSP_DAILY_INDEX [undetermined]: Daily equal-weighted market-return series used as the benchmark in DailyReturns CAR calculations.
- R_ICLINK [undetermined]: IBES-to-CRSP ticker/security crosswalk used separately while constructing CompustatQData; the code joins by permno and carries ticker.
- R_IBES_SURPRISES [undetermined]: Prepared earnings-surprise table used to construct SUEData. The driver requires announcement/report dates, GVKEY, actual EPS and SUE3; no formula or producer for this table appears in the supplied code.
- R_EMPLOYEE_PANEL [undetermined]: Envestnet|Yodlee employee-month panel required to construct EmployeeCharData; its member, merchant, wage, month, state and income-class fields are consumed directly.
- R_MERCHANT_MAPPING [undetermined]: Merchant-name-to-ticker mapping with listed and delisted dates; jointly required with pub_employee_panel to create employee characteristics.
- R_LM_HEADER [undetermined]: Prepared quarterly CIK/headquarters-state header input used to create HeadquarterState; required fields are cik, f_yq and ba_state.
- R_EA_EVENTS [undetermined]: Prepared earnings-announcement/employee event table used to seed the main sample with eadate, ticker and unique_mem_id. No producer or source is identified in the supplied driver.
- R_CONSUMPTION_WEEKLY [undetermined]: Weekly employee event-time consumption table joined on unique_mem_id, gvkey, eadate and ea_week; it supplies tot_cons_adj2 for the main results.
- R_BANK2BROKER [undetermined]: Employee stock-transaction table joined to employee-date observations to construct HasInvExp.
- R_NCUSIP_TICKER_LINK [undetermined]: Month-keyed ticker-to-NCUSIP crosswalk used before matching company news; required fields include ticker, ym and ncusip.
- R_RP_ENTITY_NCUSIP_LINK [undetermined]: RavenPack entity-to-NCUSIP monthly mapping required to attach news entities to event firms; no direct combined mapping producer is supplied.
- R_RAVENPACK_MONTHLY [undetermined]: RavenPack monthly event files for the 2013–2021 loop; the script filters and consumes headline, event type, country, timestamps, reporting-period dates, story/entity IDs and sentiment.
- R_SD_WEEKLY [undetermined]: Separate weekly-consumption standard-deviation input used to create the HighSD moderator and Table 10 results.
- R_CATEGORY_CONSUMPTION [undetermined]: Category-level event consumption table joined on member, GVKEY, event date and AfterEA; downstream results require the listed more/less-discretionary consumption measures.
- R_DAILY_CONSUMPTION [undetermined]: Daily event-window consumption table joined by member, calendar date and event date; the driver uses tot_cons_adj2.
- R_COMPUSTAT_DATA [undetermined]: Separate CompustatData table read for Table 2 Panels B/C; code requires quarter/date, GVKEY/PERMNO, size, BM, leverage, ROA and SIC inputs, joins CAR/SUE data, and does not create this table in the supplied driver.
- R_CALENDAR_WEEK_CONSUMPTION [undetermined]: Weekly event-time sensitivity input used by Table 7; code consumes tot_cons_adj2, ln_wage, timetoevent, week_begin_stata, EventFE, unique and gvkey.
- SW_WINSOR2 [preparation_required]: Original registered probe reports winsor2 unavailable, while the driver invokes it repeatedly for sample and outcome winsorization.
- SW_ASDOC [preparation_required]: Exact frozen `which asdoc` metadata reports this command unavailable under Stata 18; configure it before the Table 2B output step. No package installation was attempted; StataNow 19.5 compatibility remains separate.

## Review notes

- The assigned scope is a complete static source closure of Replication.do; all 21 checklist dependencies are reviewed, and all direct table inputs outside that list are included in the input crosswalk and requirements.
- The input crosswalk preserves full catalog schemas and exact field case for selected candidates, compares every one of the 20 direct inputs, and includes the exact fields from the existing readable FirmIdentifiers probe. FirmIdentifiers.dta is not cited as a route because the supplied code does not consume it.
- All local data reads were bounded to one row through the frozen helper. Positive source rows do not establish historical or population coverage. The RPA boundary probes timed out and are recorded as unverified, not as missing data.
- The original environment.json was never read directly. Six original successful software positives use the original registered probe/hash and exact key names; its typed viewer was used only for the fixed safe metadata projection. The five exact add-on/helper names were checked separately through the frozen software/which helper under Stata 18: rangestat, ffind, eststo and _gnvals are available, while asdoc is unavailable. Presence does not establish author-call or StataNow 19.5 compatibility.
- Source quotes rely on the v6 byte-first captures, which preserve source line identity and mask only the RavenPack import path. The masked path was not unmasked, quoted or used to infer inactivity; the visible year loop and downstream field consumers were used instead.
- Earlier reader self-test failures and the v5 underinclusive screen remain preserved in probes/ but are not used for scientific source evidence; v6 passed the required fictional fixtures and is the sole source view used here.
- The logfile was not read, and no author program, SAS invocation, model/statistical/import/compiler trial, data download, package install or test was run. The only runtime checks were five bounded frozen Stata version/which metadata queries. No applied edits to the author program are proposed.
- This is a conditional static readiness assessment only. Historical coverage, vendor entitlement, derived-table construction, field aliases, exact source mappings, Stata 18 versus 19.5 compatibility and numerical results remain unresolved until the listed preparation steps are completed.
- Seven local raw components (CRSP MSF/MSENAMES/DSF/DSENAMES, Compustat FUNDQ/CCM, and WCIKLINK_GVKEY) have bounded successful native-field metadata support. That does not establish full history, author extract identity, date selection or any derived prepared table; the EWRETD/EWRET mapping, ICLink variant, unselected NCUSIP field and genuine prepared-input gaps remain separate.
- Workspace instructions document local cleaned LM 10-X and SEC exhibit source-document roots as conditional candidates for the headquarters header input. No recursive scan, document payload inspection, download or reconstruction was performed; CIK/fiscal-quarter/state fields, cleaning and 1993–2021 coverage remain unknown.
