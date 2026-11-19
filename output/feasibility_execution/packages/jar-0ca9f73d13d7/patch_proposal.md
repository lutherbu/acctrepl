# Patch proposal: jar-0ca9f73d13d7

Observing Enforcement: Evidence from Banking

DOI: 10.1111/1475-679X.12422

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied SAS and Stata preparation workflow in this release, including the SAS bank/EDO/news/failure branches and the Stata textual-analysis/macro merge companion. This is the as-downloaded supplied workflow; unprovided paper-wide regressions and the confidential thrift extension are not added as mandatory branches.

Entry points: `00_build_data.sas`, `adding_text_analysis.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 4/12422 - Observing-Enforcement-Evidence-from-Banking/kt-datasheet-code-and-identifiers2022.zip",
      "sha256": "4336de7838d42f6b3ff7e61d2ebaaefd6046853949cb7ee02a30877dcf0abad5"
    },
    {
      "path": "JAR-Volume 60/Issue 4/12422 - Observing-Enforcement-Evidence-from-Banking/kleymenovatomy-online-appendix.pdf",
      "sha256": "70bb4394c92b61b96d61def5b928aea3790903192c742e4e41b593e9b9ead85a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "872f8e692c8e67d74e3b61acbb06036dd167cdc260fbc868cfb019c6ebbed685"
}
```

## Proposed actions

### A_CALL_REPORTS: Obtain the author-compatible historical master_commercial.sas7bdat source or its documented historical equivalent. The public FFIEC CDR page's stated 2001 start does not cover the 1983-1997 principal period.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_CALL_REPORTS
Evidence: E_README_STAGES, E_SAS_CALLREPORT_FIELDS, E_PUBLIC_FFIEC_CDR

Preparation / proposed procedure:

1. Request the exact master_commercial file, vintage, and documentation used for the EDO_KT analysis, including the selected RSSD, RCFD, RIAD, and RCON source columns listed in R_CALL_REPORTS.
2. If a current public FFIEC route is proposed, first document a historical source with the required 1983-1997 bank-quarter history and every consumed field; do not assume the current CDR page covers those years.
3. Preserve the supplied SAS variable construction, quarter dates, and lag history; do not replace inputs with guessed aliases or a separate bank panel.

Validation to perform later:

- On an authorized received file, use the assigned row-1 bounded SAS metadata probe to check the expected source columns without loading author code or requesting full counts.
- Confirm documented date and RSSDID coverage includes the full supplied branches and the historical lead-in needed by lag 1-4 construction; keep any undocumented period unresolved.

### A_EDO_SAS_INPUT: Obtain or identify the prepared edo_modified.sas7bdat table consumed by the SAS driver, preserving its documented combined disclosure and pre-disclosure collection sources.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_EDO_SAS
Evidence: E_README_STAGES, E_DATASHEET_SOURCES, E_SAS_BANK_OUTPUT_EDO

Preparation / proposed procedure:

1. Request the author's prepared EDO table and its source/vintage notes: SNL disclosure-period records and the documented termination-document/National Archives manual collection for the non-disclosure period.
2. Confirm the actual RSSDID, YEAR_QTR, and EVENT fields, period coverage through the SAS source filter, and how duplicate or first-event records were retained.
3. Keep this SAS input distinct from the Stata edo_complete.dta input until an explicit compatible producer is documented.

Validation to perform later:

- Check row-1 field metadata and documented quarter/date coverage against the SAS consumer before any author code is run.
- Verify any proposed derived table preserves the documented first enforcement event and authored event coding.

### A_BANK_DISTANCE: Resolve the missing producer and specification for all_bnk_dist_sas, which is consumed by the regulator-distance merge and log_dist calculation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_BANK_DISTANCE, I_BANK_DISTANCE_PRODUCER
Evidence: E_SAS_EDO_DISTANCE

Preparation / proposed procedure:

1. Request the prepared table or exact author producer, including the meanings, units, date grain, period, and source of RSSDID, DATE, REGULATOR, and DIST_REG.
2. Confirm the intended charter/regulator linkage to master_commercial and the join cardinality; do not infer a substitute distance source.

Validation to perform later:

- Check the received table's row-1 fields, date format, history, units, and join keys against the SAS merge.
- Before the future run, verify log_dist is supported by the supplied DIST_REG values without changing the authored transformation.

### A_EDO_MEDIA: Obtain the author-prepared edo_media_coverage.sas7bdat table or its exact NewsBank hand-collection producer and schema.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_EDO_MEDIA, I_EDO_MEDIA_PRODUCER
Evidence: E_README_STAGES, E_DATASHEET_SOURCES, E_SAS_EDO_DISTANCE

Preparation / proposed procedure:

1. Request the hand-collected EDO local-news coverage table identified in the README/datasheet, including all columns used beyond RSSDID and the precise 1985-1997 collection/coverage rules.
2. Confirm what duplicate RSSDID records, missing coverage, and any period outside the named collection window mean; retain the source's intended left join.

Validation to perform later:

- Compare the received field names, RSSDID key and documented history with the SAS left join before running it.
- Verify that the acquired/constructed table represents EDO-media coverage and remains distinct from the county newspaper circulation branch.

### A_FDIC_FAILURES: Obtain the author-compatible FDIC failure input or verify a documented public product/vintage and field mapping for bnk_failure.sas7bdat.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FDIC_FAILURES
Evidence: E_DATASHEET_SOURCES, E_SAS_FDIC, E_PUBLIC_FDIC_FAILURES, E_PUBLIC_FDIC_GUIDE

Preparation / proposed procedure:

1. Request the exact FDIC source and prepared file used by the authors, with its source date, schema, and transformation into CERT, FAIL, CHARTER_CLASS, EFFECTIVE_DATE, INSTITUTION_NAME, LOCATION, and Failure___Assistance.
2. Resolve the official BankFind overview's 1934-present description against the FDIC guide's 1992 start entry before treating that product as a route for failures in 1983-1991.
3. Preserve the supplied commercial-bank CERT-to-RSSDID linkage and 1983-1997 failure filter.

Validation to perform later:

- Check the received data's expected fields, effective-date representation, failure/assistance coding, and documented 1983-1997 coverage.
- Verify its CERT values can be matched to the supplied master_commercial certificate identifiers before the future SAS run.

### A_COUNTY_MAPPING: Resolve the missing producer and time-varying bank-to-county/state mapping consumed as bnk_vars_county.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COUNTY_MAPPING, I_COUNTY_CROSSWALK_PRODUCER
Evidence: E_SAS_NEWS, E_DATASHEET_SOURCES

Preparation / proposed procedure:

1. Request the exact author-prepared mapping or its producer and document RSSDID, COUNTY_FIPS, STATE_FIPS, YEAR, geography vintage, and source coverage.
2. Confirm its intended one-record-per-bank-year behavior after the source's DISTINCT and NODUPKEY operations, plus the county-key convention used by the news merge.
3. Do not substitute the datasheet's Census contextual mention or assume it constructs this bank/county mapping.

Validation to perform later:

- Check row-1 schema and documented RSSDID/county/state/year keys against the SAS consumer.
- Verify date/geography consistency and expected join uniqueness for the supplied years before execution.

### A_COUNTY_NEWS: Obtain the prepared news_county_8397.sas7bdat table or the exact author transformation from ICPSR 30261 into its county-year coverage fields.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_COUNTY_NEWS, I_COUNTY_NEWS_PRODUCER
Evidence: E_DATASHEET_SOURCES, E_SAS_NEWS, E_PUBLIC_ICPSR_30261

Preparation / proposed procedure:

1. Use the named ICPSR 30261 study page to identify the appropriate repository release and confirm access through an ICPSR member institution if using that public candidate; membership status remains unknown.
2. Request the author-prepared county-year output or its exact source subset, county crosswalk, aggregation, coverage period, and meanings for cnty90 and cov_pct.
3. Keep this circulation input separate from the hand-collected NewsBank EDO-media table.

Validation to perform later:

- Check the received panel's row-1 fields, county coding, year grain, and supported 1983-1997 history against the SAS parsing and merge keys.
- Verify the prescribed city/county panel-to-county-year transformation before treating ICPSR 30261 itself as compatible.

### A_BEA_INPUTS: Obtain the author-named county_econ.csv and state_econ.csv inputs or the exact historical BEA vintage and column contract used by adding_emp_growth.do.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_BEACOUNTY, R_BEASTATE
Evidence: E_BEACOUNTY, E_BEASTATE, E_PUBLIC_BEA_CAINDOC, E_PUBLIC_BEA_IMPACT, E_PUBLIC_BEA_STATE_IMPACT, E_PUBLIC_ROUTE_INSPECTION

Preparation / proposed procedure:

1. Request both original CSVs or exact author vintage/version, including geofips, year, per_capita_personal_inc, personal_income, population, and emp; also confirm the state geoname/geofips fields.
2. Resolve which source-line codes and units produced emp. Current BEA documentation marks county CAINC30 employment-related lines 240-310 and state SAINC30 lines 270, 280, and 310 eliminated; the legacy archive link was not verified.
3. Confirm that both files retain consecutive-year history required by the helper's prior-year calculations, and preserve its county-to-state fill order and /1000 scaling. Do not substitute a different employment measure or guess the author's vintage.

Validation to perform later:

- Check the CSV header names, geographic identifiers, units, and years against the helper's exact imports and merge keys.
- Verify consecutive years and state/county coverage for every used bank-year; treat Stata's unique emp/population prefixes after the shown drop/rename as valid where unambiguous, not as a confirmed missing-variable defect.

### A_TEXT_OLD_RESULTS: Obtain the author-prepared old_results_modified.dta text/SNL input used by the Stata companion, including its original field metadata.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_TEXT_OLD
Evidence: E_TEXT_OLD, E_STATA_ROA_KEEP, E_DATASHEET_SOURCES

Preparation / proposed procedure:

1. Request the exact prepared file/version and the data dictionary for its regulatory-action, date, identifier, and text-metric fields.
2. Confirm compatibility with the supplied keep/filter/rename operations and preserve the included readability and text metrics rather than rebuilding them independently.

Validation to perform later:

- Check the received .dta metadata for the fields retained at adding_text_analysis.do lines 40-43 and key/date types before using it.
- Resolve the separate lowercase roa omission through A_TEXT_ROA_CLARIFICATION before treating the append/rename chain as closed.

### A_TEXT_MERGED: Obtain the author-prepared merged_modified.dta extraction input consumed by the Stata text companion.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_TEXT_MERGED
Evidence: E_TEXT_MERGED, E_STATA_ROA_KEEP, E_DATASHEET_SOURCES

Preparation / proposed procedure:

1. Request the exact prepared file/version and a field dictionary covering the Docket, ISSUE_DATE, RSSDID, and text-extraction variables retained by the supplied keep statement.
2. Confirm how this input is intended to append to old_results_modified and retain the authors' text-extraction and metric definitions.

Validation to perform later:

- Check the received .dta metadata against the supplied keep/rename fields and confirm compatible ISSUE_DATE and RSSDID types.
- Resolve the separately recorded roa field gap without deriving it from bank bnk_vars.

### A_EDO_COMPLETE: Obtain edo_complete.dta and its producer/schema contract for the Stata termination merge; do not assume it is the SAS edo_modified input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EDO_COMPLETE, I_STATA_EDO_COMPLETE_PRODUCER
Evidence: E_STATA_EDO_COMPLETE, E_SAS_BANK_OUTPUT_EDO

Preparation / proposed procedure:

1. Request the Stata file or exact author producer with rssdid, ISSUE_DATE, and EDO_LENGTH definitions, date formats, matching rules, and history.
2. Ask whether/how this file relates to edo_modified.sas7bdat; keep the SAS RSSDID/YEAR_QTR/EVENT fields separate unless an explicit conversion and date mapping are supplied.

Validation to perform later:

- Check row-1 fields and key/date types against the m:1 Stata merge at adding_text_analysis.do line 202.
- Verify the supplied EDO_LENGTH field and date alignment before running the text companion.

### A_BNKVARS_FORMAT_HANDOFF: After the existing master_commercial requirement is met and SAS produces mod.bnk_vars, convert that generated table to a Stata-compatible bnk_vars.dta in the configured working-copy modified-data directory, aligning the known source field names with the Stata consumer.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CALL_REPORTS, I_FORMAT_HANDOFF
Evidence: E_SAS_CALLREPORT_FIELDS, E_SAS_BANK_TIME_KEYS, E_SAS_BNKVARS_OUTPUT, E_STATA_BNKVARS_USE, E_STATA_ROOTS

Preparation / proposed procedure:

1. After the supplied SAS bank-source stage creates mod.bnk_vars.sas7bdat from var7_3, use an approved available SAS-to-Stata export/conversion path to create bnk_vars.dta in the directory mapped to the Stata modified-data root; preserve the complete generated panel and values.
2. Align only the source columns with the names used by the companion: SAS RSSDID to Stata source rssdid, DATE to date, and YEAR to year; retain FDIC_CERT, YEAR_QTR, STATE_FIPS and COUNTY_FIPS for the named Stata consumers. Do not invent aliases or values.
3. Leave date_stata, yq, RSSDID, Parent_Regulatory_ID_, sc_fips and the state_fips rename to their supplied Stata producers after `use bnk_vars`; those are not required columns in the exported source DTA.
4. If an actual field used by the supplied Stata source is absent from mod.bnk_vars or lost in conversion, record that exact field/type/history difference before proposing any further change. Do not require author approval merely because the source release omitted an export statement.

Validation to perform later:

- On an authorized converted output, inspect bounded DTA metadata and compare the exact source keys and every preserved mod.bnk_vars column with the Stata consumers; confirm the normalized field names date, rssdid, year, FDIC_CERT, YEAR_QTR, STATE_FIPS and COUNTY_FIPS.
- Verify the converted file is in the configured Stata working-copy path and retains the bank-quarter history needed by the text and macro merges; keep any history gap tied to R_CALL_REPORTS rather than adding a second data requirement.
- After a future authorized Stata run, check that date_stata, yq, RSSDID and Parent_Regulatory_ID_ are created by the supplied lines 111-119 and that the native merge sequence is unchanged.

### A_WINSOR_INCLUDE: Obtain or identify the exact external winsor.SAS macro referenced by the supplied SAS driver before the %winsor calls can be interpreted or run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_WINSOR_INCLUDE
Evidence: E_SAS_INPUTS, E_SAS_BANK_OUTPUT_EDO

Preparation / proposed procedure:

1. Request the author-supplied [redacted-path-76bce5fd35ae] file, its version, and its invocation contract for dsetin/dsetout/byvar/vars/type/pctl.
2. Preserve the source's 1/99 percentile settings and separate main/sub-period groups; do not create a replacement macro from recollection.

Validation to perform later:

- Review the received macro definition and confirm the supplied calls' arguments and output variable names before a later authorized SAS run.
- Keep its required inclusion path consistent with the configured SAS working-copy roots.

### A_TEXT_ROA_CLARIFICATION: Resolve the source of lowercase roa before the supplied Stata rename roa roa_text at line 105.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_TEXT_ROA_FIELD
Evidence: E_STATA_ROA_KEEP, E_STATA_ROA_APPEND, E_STATA_BNKVARS_USE

Preparation / proposed procedure:

1. Ask the authors to identify the intended input/producer and field type or provide the intended source correction: both current keep lists omit lowercase roa, and bnk_vars loads only later.
2. Do not substitute bank ROA, move a merge earlier, or change the text sample without author confirmation.

Validation to perform later:

- Compare the confirmed field producer with the exact line-105 rename and append sequence before a proposed source edit is prepared.
- Verify any authorized correction preserves the authored text append and analysis sample.

### A_PATH_CONFIGURATION: Prepare one coherent host working-copy layout for the supplied Windows E:, F:, and Z: roots and stage the supplied helper at the dynamic Stata do-file path.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_PATH_ROOTS
Evidence: E_SAS_INPUTS, E_SAS_MAIN_EXPORTS, E_STATA_ROOTS, E_BEACOUNTY, E_BEASTATE, E_STATA_HELPER_CALL

Preparation / proposed procedure:

1. After the data handoffs are specified, map the SAS E: library roots, F: failure/output roots, Stata Z: root, and the [redacted-path-3a8feb6e0252] BEA path into one coherent host working copy without mixing their distinct folders.
2. Stage the supplied adding_emp_growth.do at the path expanded by $rootDir\01 Analysis\adding_emp_growth.do and place the named county/state CSVs and Stata inputs at their authored relative paths.
3. Ensure every referenced output directory exists and is writable; choose a concrete host path only after confirming actual mounts and permissions.

Validation to perform later:

- Statically inspect every configured path for consistent source and consumer roots before running either program.
- After authorized setup, verify mounted visibility and write permissions for the actual input/output directories without changing source data.

### A_SAS_RUNTIME: Confirm the prescribed SAS 9.4 runtime and site configuration using authorized environment metadata; the existing toolkit note does not prove that SAS is unavailable or unlicensed.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_ENVIRONMENT, E_SAS_INPUTS, E_SAS_EXPAND_DOC

Preparation / proposed procedure:

1. Before execution, have the environment owner verify that the installed SAS 9.4 runtime is configured for the assigned working directory and can use the required libraries.
2. Record the runtime build/configuration and any site entitlement status from approved metadata; do not infer a license barrier from the failed toolkit initialization note.

Validation to perform later:

- Retain an authorized successful runtime/version and site-configuration record before scheduling the author program.
- Do not use a SAS startup, autoexec, sample, or study-data command as a static compatibility test.

### A_SASETS_COMPONENT: Verify the SAS/ETS component needed by PROC EXPAND as an explicit environment capability; official documentation supports the dependency but installation/entitlement is unverified.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SASETS
Evidence: E_SAS_EXPAND, E_SAS_EXPAND_DOC, E_SAS_ETS_94_DOC, E_ENVIRONMENT

Preparation / proposed procedure:

1. Use approved static installed-product/component metadata or administrator confirmation to determine whether SAS/ETS for the installed SAS 9.4 runtime is available.
2. Preserve the documented PROC EXPAND lag construction and do not conduct syntax trials, launch SAS, or infer component access from SAS base availability.

Validation to perform later:

- Record SAS/ETS version/component availability through a permitted static environment record before the future SAS workflow.
- Keep PROC EXPAND syntax and the author workflow unchanged.

### A_MDESC_SETUP: Configure the Stata mdesc command required by adding_text_analysis.do; the read-only Stata 18 which query did not find it in the checked adopath.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_MDESC
Evidence: E_STATA_MDESC, E_MDESC_PROBE

Preparation / proposed procedure:

1. Provide or configure an approved local mdesc ado installation in the Stata 18 adopath; no install was performed during this assessment.
2. Keep the supplied calls to mdesc and their variables unchanged.

Validation to perform later:

- After setup, verify Stata resolves mdesc with `which mdesc` before running the companion.
- Record the resolved ado path and version in the approved environment note.

### A_ORDERED_RUN_PROCEDURE: Once the preceding input, handoff, path, and software actions are resolved, run the supplied preparation workflow in source order and retain its native outputs, dates, scales, merges, and branch samples. The release does not include the paper-wide regression programs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_CALL_REPORTS, R_EDO_SAS, R_BANK_DISTANCE, R_EDO_MEDIA, R_FDIC_FAILURES, R_COUNTY_MAPPING, R_COUNTY_NEWS, R_BEACOUNTY, R_BEASTATE, R_TEXT_OLD, R_TEXT_MERGED, R_EDO_COMPLETE, I_FORMAT_HANDOFF, I_PATH_ROOTS, SW_SAS, SW_SASETS, SW_STATA, SW_MDESC
Evidence: E_README_STAGES, E_SAS_BANK_OUTPUT_EDO, E_SAS_EDO_DISTANCE, E_SAS_MAIN_EXPORTS, E_SAS_FDIC, E_SAS_NEWS, E_TEXT_OLD, E_TEXT_MERGED, E_STATA_M_MERGE, E_STATA_HELPER_CALL, E_STATA_EDO_COMPLETE, E_SAS_BNKVARS_OUTPUT, E_STATA_BNKVARS_USE

Preparation / proposed procedure:

1. First configure all [redacted-path-c71e1e003c46]: roots and stage the supplied adding_emp_growth.do helper at the expanded Stata path; verify required source inputs and configure the conditional mod.bnk_vars-to-DTA handoff before starting either entry point.
2. Run 00_build_data.sas only after the winsor macro and SAS/SAS-ETS capability are verified: create mod.bnk_vars from master_commercial, then read edo_modified, join all_bnk_dist_sas and edo_media_coverage, and write surv_data_complete.
3. From surv_data_complete, retain both authored periods and exports: surv_data_8397 (1983.1-1997.4) and surv_data_8307 (1983.1-2007.4). Follow the separate FDIC branch from bnk_failure plus master_commercial identifiers through surv_data_fail; follow the separate county-news branch from bnk_vars_county and news_county_8397 through county/state-year averaging and surv_data_news.
4. After mod.bnk_vars is created by the SAS stage, convert it to the working-copy bnk_vars.dta with the documented source-name/path alignment; run adding_text_analysis.do in order: old_results_modified creates text_data_ck; merged_modified is appended; bnk_vars creates temp_text_ck and Stata creates its date/RSSDID/quarter keys; preserve the authored m:1 RSSDID/yq and Parent_Regulatory_ID_/yq merges, then m:m FDIC_CERT/yq; call adding_emp_growth.do with both BEA files; then merge edo_complete on rssdid and ISSUE_DATE and create the supplied final text measures.
5. Do not alter the native merge types, input order, quarter/date logic, source scales, filters, or text sample. Treat the final Stata in-memory dataset as the supplied endpoint; no final save or regression program is present in this release.

Validation to perform later:

- For each authorized future stage, capture the exact command, working directory, separate stdout/stderr or native log, and return status.
- Check output presence, fields, historical periods, keys, join behavior, and authored branch samples; compare the converted Stata bnk_vars.dta field set and dates with the SAS mod.bnk_vars producer before using the text consumer.
- Confirm the Stata script reaches its documented endpoint without adding unprovided paper-wide regressions; execution remains unverified until such a future authorized run.


## Remaining issues and prerequisites

- I_FORMAT_HANDOFF [preparation; full_pipeline]: The supplied SAS program creates mod.bnk_vars.sas7bdat from var7_3, while the Stata companion expects a Stata-format bnk_vars in its modified-data working directory. The source chain identifies the consumed bank fields and Stata creates date_stata, yq, RSSDID and Parent_Regulatory_ID_ after load, so a conditional export/conversion with known column-case and path alignment is preparation. The future converted file still needs field/history verification; this is not a separate empirical-data requirement or evidence that a same-basename DTA already exists.
- I_WINSOR_INCLUDE [unresolved; full_pipeline]: 00_build_data.sas includes [redacted-path-76bce5fd35ae] and later invokes %winsor, but that macro is not included in this release. Its definition/version and compatible route are unresolved.
- I_BANK_DISTANCE_PRODUCER [unresolved; full_pipeline]: 00_build_data.sas reads all_bnk_dist_sas with RSSDID, DATE, REGULATOR and DIST_REG, then logs distance and merges it into the EDO bank-quarter panel. No supplied program produces this table; its source, units, period and bank/regulator matching contract are unresolved.
- I_EDO_MEDIA_PRODUCER [unresolved; full_pipeline]: The SAS code left-joins edo_media_coverage by RSSDID, but no producer or coverage-field definition is supplied. The datasheet describes a hand-collected NewsBank local-media EDO dataset for 1985–1997; obtain the prepared table or its exact construction contract and preserve the authored join.
- I_COUNTY_CROSSWALK_PRODUCER [unresolved; full_pipeline]: The SAS news branch reads bnk_vars_county for RSSDID, COUNTY_FIPS, STATE_FIPS and YEAR, but no supplied source constructs this bank-to-county-year mapping. Its population, dates, county assignment and join cardinality remain unresolved; do not assume the separately documented Census urbanization API is this mapping.
- I_COUNTY_NEWS_PRODUCER [unresolved; full_pipeline]: The SAS code consumes news_county_8397, derives state_fips/county_fips from cnty90 and uses cov_pct, but no producer for this prepared county-year panel is supplied. The datasheet names ICPSR 30261 and the U.S. Newspaper Panel, but the required subset, county-key mapping, aggregation and field conversion are not documented in this release.
- I_STATA_EDO_COMPLETE_PRODUCER [unresolved; full_pipeline]: adding_text_analysis.do separately merges edo_complete on rssdid and ISSUE_DATE and then uses EDO_LENGTH. No supplied program produces edo_complete. The SAS input edo_modified (RSSDID/YEAR_QTR/EVENT) is not shown to be the same table or a compatible producer; do not conflate the two names or infer the date/termination mapping.
- I_TEXT_ROA_FIELD [unresolved; full_pipeline]: The old_results_modified keep list and the merged_modified keep list both omit lowercase roa; after appending those data the code executes rename roa roa_text, with no preceding producer visible in the text branch. The later bnk_vars load occurs after this rename. Confirm the intended source field or author correction; do not substitute bank ROA or assume case normalization.
- I_PATH_ROOTS [preparation; full_pipeline]: The SAS source uses E: and F: data/output roots; Stata uses a Z: project root and an additional [redacted-path-3a8feb6e0252] path for BEA files. For the host wrapper, stage a working copy under one chosen [redacted-path-9e5595281d32] run root and map all roots/outputs/helper paths coherently while preserving their separate source folders. Actual host visibility/writability and author-drive mapping have not been verified.
- R_CALL_REPORTS [undetermined]: The quarterly FFIEC commercial-bank Call Reports file master_commercial supplies the bank-level fields used to construct mod.bnk_vars, the bank-quarter identifiers and observables consumed by the supplied Stata companion after a conditional format/path handoff, and regulatory identifiers for FDIC matching.
- R_EDO_SAS [undetermined]: The prepared SNL/hand-collected enforcement-action table edo_modified supplies RSSDID, YEAR_QTR and EVENT to the SAS merge.
- R_BANK_DISTANCE [undetermined]: The prepared all_bnk_dist_sas table supplies RSSDID, DATE, REGULATOR and DIST_REG to the SAS regulator-distance merge.
- R_EDO_MEDIA [undetermined]: The prepared edo_media_coverage table supplies the hand-collected local-news coverage merged onto the SAS panel.
- R_FDIC_FAILURES [undetermined]: The FDIC failure file bnk_failure supplies failure events and certificate identifiers for the SAS failure branch.
- R_COUNTY_MAPPING [undetermined]: The prepared bnk_vars_county table supplies bank-to-county/state FIPS assignments by year for the SAS news-coverage merge.
- R_COUNTY_NEWS [undetermined]: The prepared news_county_8397 table supplies county-year newspaper coverage for the SAS news branch.
- R_BEACOUNTY [undetermined]: The county-level BEA county_econ.csv source supplies county-year employment, population, personal income and per-capita income for the Stata macro construction.
- R_BEASTATE [undetermined]: The state-level BEA state_econ.csv source supplies state-year values used to fill missing county measures in the Stata macro construction.
- R_TEXT_OLD [undetermined]: The prepared old_results_modified Stata file supplies SNL/C&D order fields and existing text metrics consumed by adding_text_analysis.do.
- R_TEXT_MERGED [undetermined]: The prepared merged_modified Stata file supplies document-extraction text metrics and fields appended into text_data_ck.
- R_EDO_COMPLETE [undetermined]: The Stata text companion consumes edo_complete as an additional SNL enforcement-action termination input after its text/bank/macroeconomic merges.
- SW_SAS [unverified]: The source header identifies SAS 9.4. The assigned environment record notes SAS could not initialize its toolkit but explicitly does not establish missing license entitlement. Runtime availability remains unverified; no SAS invocation was made in this assessment.
- SW_SASETS [unverified]: The supplied code invokes PROC EXPAND for lag construction. Official SAS/ETS documentation places EXPAND in SAS/ETS and lists SAS/ETS 15.4 under SAS 9.4 documentation, but the installed SAS/ETS component and its entitlement are unverified; the authors specify only SAS 9.4.
- SW_MDESC [preparation_required]: adding_text_analysis.do invokes mdesc. A read-only Stata 18 which query did not find mdesc in the checked adopath; no installation or code run occurred.

## Review notes

- The frozen assignment, worker prompt, skill snapshot, source package, parser-omitted inputs, and all 21 frozen dependency edges were reviewed. The only supported entry points in this release are 00_build_data.sas and adding_text_analysis.do, with adding_emp_growth.do called from the latter.
- FullSampleIDs.csv is a separate RSSDID identifier listing, not the panel or analysis data required by either workflow. Its bounded packaged probe and header inspection are recorded; they do not establish full bank-quarter coverage.
- The datasheet mentions Census 1990 variables and confidential FRB thrift work, but the supplied programs consume no Census input and provide no thrift extension consumer. Those references remain context, not additional mandatory execution branches.
- The Stata bnk_vars read is traced to the existing SAS bank-source chain, not a separate missing empirical input: master_commercial maps RSSD identifiers/date/certificate/geography fields, SAS derives YEAR/YEAR_QTR and writes mod.bnk_vars from var7_3, and Stata then creates date_stata/yq/RSSDID/Parent_Regulatory_ID_ from the normalized source keys. A conditional export to the Stata working-copy path with known column-case alignment is preparation; retain master_commercial history uncertainty and verify the converted field set without assuming a same-basename DTA exists. old_results_modified, merged_modified, and edo_complete remain distinct author-prepared inputs.
- The external winsor.SAS include is absent. SAS/ETS is an explicit PROC EXPAND capability requirement; official docs identify the procedure and component, while runtime/component availability was not tested. SAS was not started.
- The Stata text chain renames lowercase roa to roa_text after keeping two prepared inputs whose listed keep statements omit lowercase roa. The field producer remains a specific unresolved question; no bank ROA substitution is proposed.
- Stata's emp and population references after the shown numeric creation/drop and state rename can be unique variable-name prefixes; no fatal-variable claim or guessed alias is made. Native m:m merge, source scales, date logic, filters, and sample are preserved.
- The Stata source ends after creating in-memory text measures and includes no final save or paper-wide regression commands; those unprovided regressions are not added to this supplied-workflow scope.
- Official static checks found product/documentation candidates for FFIEC Call Reports, BEA CAINC30/SAINC30, FDIC Failures and Assistance, and ICPSR 30261. The evidence records known history/schema gaps, a BEA legacy archive link that could not be verified, and the FDIC start-year discrepancy. No data payload, download, API query, or external contact was made.
- Preserve the supplied SAS output-definition detail that AVG_ASSETS is created while OITA is calculated from AVG_ASSET; no alias or correction is inferred. This does not change the source-to-Stata handoff proposal, and no paper-wide regression consumer is supplied here.
