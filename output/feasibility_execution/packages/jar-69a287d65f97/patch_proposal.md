# Patch proposal: jar-69a287d65f97

Relative Target Setting and Cooperation

DOI: 10.1111/1475-679X.12244

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented Stata workflow: exchange-rate/deflator preparation, annual and monthly variable construction, sample formation, Q/M peer-noise measures, cooperation measures, MIMIC model, target-setting analyses, and Tables 1–6.

Entry points: `Code_RTS and Cooperation.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 1/12244 - Relative-Target-Setting-and-Cooperation/hkmh-datasheet-and-code.zip",
      "sha256": "a99b7215ba13f9160d1c76668e89e1402c948341f2c2c43561c61ce850ac09bd"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "c83811cf51d574c3f509a51770a75bd26578e24acefe00d1333126c87ed5fa3b"
}
```

## Proposed actions

### A001: Request compatible author-prepared annual, monthly, crosswalk, external-revenue, industry-task, capacity/cost, capacity-hours, and geocodes inputs with data dictionaries and delivery specifications, or ask the authors to confirm which files can be shared under applicable company restrictions.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R001, R002, R003, R004, R005, R006, R007, R008, R009, R010, I001
Evidence: E001, E002, E003, E005, E010, E011, E015, E019, E025, E026

Preparation / proposed procedure:

1. Ask for the exact author-prepared files consumed by the do-file, retaining identifiers, required keys, fields, units, and FY2012–2014 / monthly history.
2. For each file, obtain its producer/schema or a data dictionary that explains merge keys, field meanings, units, and missing-value conventions.
3. Use a compatible prepared geocodes workbook if available; the datasheet's historical Google Maps collection need not be repeated when that workbook is supplied.

Validation to perform later:

- After authorized receipt, use bounded metadata/readability checks on each exact file and verify required keys, columns, and stated period.
- Check the intended merge cardinalities and preserve the author-defined 2013–2014 sample and all listed analyses.

### A002: Use the official WDI GDP-deflator product for 2010–2014 and prepare the code-required country/year aliases from it; use ECB reference-rate history for the separate exchange-rate input after confirming needed currency coverage.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R011, R012
Evidence: E008, E009, E043, E046, E080, E081, E082

Preparation / proposed procedure:

1. Obtain WDI NY.GDP.DEFL.ZS values for 2010–2014 through the official data/API interface; construct the CountryName, CountryCode, and year2010–year2014 fields required by the Stata workflow as a supported data-preparation step. The original 2015 workbook filename/layout is not required.
2. Obtain ECB 2012 reference-rate series for currencies present in the author BUA_Currency crosswalk; the Nigeria series remains a separate R013 requirement.
3. Keep the WDI deflator series distinct from ECB exchange rates and map each prepared source into the separate import contracts used by the code.

Validation to perform later:

- After the confidential BUA/country mapping is available, check that the exact required country codes have 2010–2014 source values and that the prepared fields feed the author-specified lag and monthly-interpolation calculations.
- Confirm ECB currency coverage against BUA_Currency, then inspect source sheet/header or API field mappings and reshape contracts before a future workflow run.

### A003: Clarify the source contract for exchange11052015.xlsx because its NGR sheet is a separate required input from the ECB reference-rate file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R013
Evidence: E004, E033

Preparation / proposed procedure:

1. Ask the authors for the workbook provider/source, the NGR series definition and units, the RateYear range, and the correct 2012 exchange-rate value/conversion direction.
2. Request the exact compatible workbook or an author-prepared series with the same fields.

Validation to perform later:

- After confirmation, verify the NGR and RateYear columns and the year range with a bounded workbook inspection.

### A004: Ask the authors to resolve the GDP-per-capita indicator discrepancy before choosing a public product or changing either import branch.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R014, I004
Evidence: E004, E012, E013, E014, E044, E045

Preparation / proposed procedure:

1. Confirm whether the intended series is NY.GDP.PCAP.CD (current US dollars) or NY.GDP.PCAP.PP.CD (current international dollars), and provide or identify the original 2012–2014 workbook.
2. Confirm the omitted BUA_MODE/country mapping and whether both GDP_Growth branches should use the same series.

Validation to perform later:

- Verify the selected workbook's product code, 2012–2014 values, and imported column positions against the confirmed author specification.
- If a source edit is required, keep the selection consistent in both import branches and preserve the 2013/2014 growth formulas.

### A005: Request the confidentially removed data-construction, BUA mapping/aggregation, sample-exclusion, and table-output steps or compatible author-prepared outputs with exact schemas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I002
Evidence: E006, E013, E014, E036, E064

Preparation / proposed procedure:

1. Ask for the redacted source blocks or an author-prepared intermediate that the supplied program can consume without undocumented reconstruction.
2. Obtain exact specifications for the removed BUA/country mapping and the company-identifying exclusions, plus the intended output location.

Validation to perform later:

- Compare returned procedures and field contracts against the code's downstream merge keys and variables.
- Check that the author-described sample rules and outputs remain consistent with the datasheet and all Tables 1–6.

### A006: Configure one local data root for the future run so the relative dta-files paths and S-drive spellings resolve to the same directory; normalize BUA_Temp casing on case-sensitive filesystems. The redacted table-output destination remains a separate I002 prerequisite.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I003
Evidence: E018, E019, E020, E027, E035, E065, E066, E067, E068

Preparation / proposed procedure:

1. Choose a local root containing the run data; map the source [redacted-path-04dfd54b375b] and [redacted-path-04dfd54b375b] references to its dta-files directory and set the working directory so relative dta-files references resolve there too.
2. On a case-sensitive filesystem, normalize the BUA_Temp/BUA_temp spelling or provide a single canonical alias so the producer and consumer calls resolve to the same intermediate.
3. Keep the missing final table-output destination separate; obtain that redacted location under I002 rather than inferring it from the input root.

Validation to perform later:

- Before any author workflow attempt, check that every producer/consumer pair for BUA_Sample, Peers_in_Sample, BUA_Temp, and capacity-hours intermediates resolves to the same canonical path under the selected root.
- Record the chosen run root and verify the separately specified output destination once the confidential output block is supplied.

### A007: Confirm the geocodes workbook's actual coordinate-column meanings and align them with geodist's documented latitude-then-longitude argument order before making any source edit.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R010, I005
Evidence: E003, E025, E042, E048

Preparation / proposed procedure:

1. Request the workbook or a column dictionary showing what the Longitude and Latitude columns contain and their units.
2. If the workbook confirms conventional coordinate meanings, update the geodist argument order consistently for both points; do not infer a repair from variable names alone.

Validation to perform later:

- Check the coordinate fields are numeric and use one known point pair to verify distance and the downstream distance_scaled_BUA units.

### A008: Set up the exact missing Stata commands without substituting similarly named commands: outreg, winsor2, and geodist from their documented SSC packages, plus tabstatout.ado from its author's page.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S002, S003, S004, S005
Evidence: E021, E025, E039, E040, E047, E049, E050, E051, E074, E075, E076, E077

Preparation / proposed procedure:

1. In a later authorized setup, install outreg, winsor2, and geodist with their exact SSC package names.
2. Place the author's tabstatout.ado in an active Stata ado directory and keep its provenance.
3. Do not substitute outreg2 for outreg or tabout for tabstatout.

Validation to perform later:

- Use which on each exact command in Stata 18 and confirm the ado path resolves.
- On self-written synthetic data, validate outreg clear/merge/replay, winsor2 trim/cuts/suffix, geodist coordinate order, and tabstatout tf/c/f output before running the author workflow.

### A009: After the inputs, redacted steps, path root, indicator choice, coordinate contract, and exact commands are resolved, run the supplied single do-file from its configured data root to produce the prepared panel and documented tables.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R001, R002, R003, R004, R005, R006, R007, R008, R009, R010, R011, R012, R013, R014, S002, S003, S004, S005, I001, I002, I003, I004, I005
Evidence: E007, E027, E028, E029, E030, E031, E041, E072, E073

Preparation / proposed procedure:

1. Set the confirmed working directory and Stata ado paths, then invoke Code_RTS and Cooperation.do as the complete preparation-plus-analysis entry point.
2. Retain both monthly and quarterly noise branches, the author-specified sample exclusions, all MIMIC/target-setting model settings, and all descriptive, validation, baseline, hypothesis, and supplementary table branches.

Validation to perform later:

- Confirm each generated intermediate exists at the path consumed by its next stage and has the required keys/columns before proceeding.
- Record the actual derived sample counts and table outputs from a future authorized execution; none are estimated in this static assessment.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The package inventory has no datasets. The do-file directly reads several author/company .dta inputs, including the annual and monthly panels and companion currency, third-party-revenue, industry-task, capacity/cost, capacity, and 2013/2014 hours files. Several have no producer in the supplied program, and no compatible delivery/schema route has been confirmed. This is an unresolved data/producer contract, not evidence that data are unavailable.
- I002 [unresolved; full_pipeline]: The program explicitly removes confidential code around country/business-group mapping and aggregation, irregular-unit sample exclusions, and table-output configuration. Exact upstream variable construction, exclusion implementation, and output path therefore remain unresolved; request the omitted procedures or author-prepared compatible intermediates and specifications.
- I003 [preparation; full_pipeline]: The do-file mixes relative dta-files paths with S-drive paths and varies slash/case spellings for related BUA_Sample, Peers_in_Sample, and BUA_Temp intermediates. A future run can map the S-drive tree and relative dta-files directory to one chosen local root and normalize case as a supported configuration (A006); the current source does not establish that configuration.
- I004 [unresolved; full_pipeline]: The code imports a workbook named for NY.GDP.PCAP.CD, while the datasheet specifies NY.GDP.PCAP.PP.CD. Official WDI pages identify current-US-dollar and PPP products as distinct series. The intended product and workbook content are unresolved; do not silently substitute one.
- I005 [unresolved; full_pipeline]: The source names fields Longitude and Latitude and passes Longitude, Latitude, peer-mean Longitude, peer-mean Latitude to geodist. The command author's documented example uses latitude then longitude for each point. The required workbook is absent, so its actual column meanings cannot be checked; confirm the workbook contract before proposing a coordinate-order edit.
- R001 [undetermined]: Author-prepared annual business-unit financial and target data. The workflow joins by BUA_MODE/year and BUA/year and needs dept_id, year, BUA_MODE, BUA, actual and budget revenue/margin/cost/personnel measures, Currency, and restructuring status. FY2012 is retained for lag construction even though the final sample drops 2012; the datasheet describes company data for 2012–2014.
- R002 [undetermined]: Author-prepared monthly business-unit financial data used to deflate and reshape monthly actual and budget values into calendar months, then construct monthly and quarterly peer-noise measures. Required fields include dept_id, year, BUA_MODE, Currency, and the 12-month actual and budget series for revenue, margin, and direct costs.
- R003 [undetermined]: Author-prepared BUA currency and World Bank country-code crosswalk used to expand yearly exchange rates and merge country deflators into each BUA_MODE.
- R004 [undetermined]: Author-prepared business-group third-party revenue and charged-hours data merged into the annual panel; the script later uses A_LY_3rd_P_Rev and A_LY_3rd_P_ChaHrs to construct competition intensity.
- R005 [undetermined]: Author-prepared industry-task revenue input used to calculate the BUA-year HHI similarity measure.
- R006 [undetermined]: Author-prepared capacity-and-cost input merged by BUA/year. Later code uses A_LY_C611 and A_LY_Theo_Cap_Hrs to construct the internal wage rate, so those fields and their units must match the author's panel.
- R007 [undetermined]: Author-prepared capacity input merged separately by BUA/year to supply A_LY_Contract_hours and A_LY_Overtime_hours.
- R008 [undetermined]: Author-prepared 2013 capacity-hours input. The program collapses hours* and capacity* fields by BUA_MODE/year and appends the result to the 2014 file.
- R009 [undetermined]: Author-prepared 2014 capacity-hours input. The program collapses hours* and capacity* fields by BUA_MODE/year and appends the result to the 2013 file.
- R010 [undetermined]: Author-prepared geocodes workbook imported from A1:G287 and joined by Name_Geo before the peer-group midpoint distance is calculated. The datasheet describes historical coordinates derived from company intranet addresses using Google Maps; the supplied workflow can use a compatible prepared workbook without repeating that collection.
- R011 [undetermined]: World Bank GDP deflator series used to create the 2012-base annual and interpolated monthly deflators. The code selects 2010–2014 values; L1/L2 and monthly interpolation require the source history rather than only the final estimation years.
- R012 [undetermined]: ECB euro foreign-exchange reference-rate history, reshaped by currency and year and used to derive the 2012 conversion rate for each BUA. The required currency set depends on the missing BUA_Currency crosswalk.
- R013 [undetermined]: Separate NGR/NGN exchange-rate workbook read from a sheet named NGR and renamed to NGN/RateYear. Its provider, units, source interface, and year coverage are not specified; it is distinct from the ECB file and needed to complete the exchange-rate reshape. The NGR series must be confirmed for at least 2012 (and adjacent year values used by the reshape); the source workbook needs NGR and RateYear fields.
- R014 [undetermined]: World Bank GDP-per-capita data used to calculate GDP_growth for 2013 and 2014 from 2012–2014 values and then merge by BUA_MODE/year. The code names a NY.GDP.PCAP.CD workbook, while the datasheet documents NY.GDP.PCAP.PP.CD; the correct series and workbook-to-BUA_MODE mapping must be confirmed.
- S002 [preparation_required]: The exact outreg command is used repeatedly with clear, merge, and replay options; it is not found in the checked Stata 18 adopaths. The SSC package named outreg is a supported setup route; exact option compatibility still needs a synthetic-data check after setup.
- S003 [preparation_required]: The workflow uses winsor2 with trim, cuts(1 99), and suffix(_t1); the exact command is not found in the checked adopaths. The SSC package is documented and needs setup followed by option validation.
- S004 [preparation_required]: The workflow calls geodist to build distance_scaled_BUA; the exact command is not found in the checked adopaths. The SSC package exists and documents a Stata 9.2 minimum, which is below the available Stata 18 runtime.
- S005 [preparation_required]: The workflow calls tabstatout for Table 1; the exact command is not found in the checked adopaths. The command's author page provides a separate tabstatout.ado download; setup and exact-option validation remain.

## Review notes

- The release contains substantial executable Stata preparation and analysis code; the only entry point is the supplied do-file. No companion analysis program or usable final BUA_Temp.dta is supplied.
- No analysis_only scope is supported: the data-analysis section reads BUA_Temp.dta after earlier construction, but this author-prepared analysis dataset is not present and no compatible route to it is verified.
- The script itself specifies the Q and M period branches, 1/99 trims, MIMIC mlmv models, robust variants, controls, sample rules, and all Table 1–6 analyses. These settings are retained. Data-derived sample counts are unknown and are not invented.
- All 26 frozen dependency IDs have explicit reviews. Manual source scanning also found BUA_Currency, BUA_Hours_3rdP_Rev, BUA_Capacity_Cost, and BUA_Capacity reads not represented by the checklist.
- Stata18 self-written synthetic-file evidence confirms use with replace is accepted in this runtime; no repair is proposed for that line.
- The browse call displays peer counts; no manual selection result is consumed by later code. A compatible prepared geocodes workbook can serve as the primary input route without repeating the historical Google Maps lookup.
- The relative/S-drive and BUA_Temp case variations are addressable through one chosen local-root configuration and case normalization (A006); this is a supported setup step, not an author clarification. The final table-output directory and confidential mapping steps remain unresolved under I002.
