# Patch proposal: jar-b3592737eca0

The Impact of Open Data on Public Procurement

DOI: 10.1111/1475-679X.12479

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full author-documented pipeline: SQL Server preparation of OpenTender/TED and hand-collected inputs, Stata construction of Eurostat and Factiva variables, SQL append into SAMPLE_FOR_ANALYSES, then Stata sample conditioning for four reported-table regression samples. No analysis-only scope is supported by the described identifier list alone.

Entry points: `1-Data cleaning and sample preparation.sql`, `2-Clean Eurostat and Factiva data.do`, `3-Append variables.sql`, `4-Prepare analysis sample.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 4/12479 - The-Impact-of-Open-Data-on-Public-Procurement/drs-datasheet-code-and-identifiers.zip",
      "sha256": "1a3042cd1e5470c35097d4eb42fae106eeefbd187352dc396932efb6015e0aeb"
    },
    {
      "path": "JAR-Volume 61/Issue 4/12479 - The-Impact-of-Open-Data-on-Public-Procurement/drs-online-appendix.pdf",
      "sha256": "7dbe3bfec69bb276401aa9312d512c0cd9697fab1b472ed8235ab446a0594265"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "85eb1d6e4d27e4f4d4658981d2c4f438d578643850da304d1acd41c234df47e3"
}
```

## Proposed actions

### A_RESOLVE_SOURCE_INPUTS_AND_DATABASE_MAPPING: Resolve the source and database mapping for the supplied full pipeline, then verify each input product, schema, period and producer-consumer handoff before an authorized run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_INPUTS_AND_HANDOFFS_UNVERIFIED, R_OPENTENDER_RAW, R_TED_CAN, R_TED_CN, R_EC_SURVEY, R_MONITORING_REPORTS, R_AWARD_CONTRACT, R_AWARD_LOT, R_DIRECTIVE, R_DIRECTIVE_ROBUST, R_COUNTRY_NAMES, R_CPV_NAMES, R_EUROSTAT_GDP, R_FACTIVA_NGO, R_FACTIVA_ALL, R_FACTIVA_KEYWORDS, S_SQL_SERVER_ODBC
Evidence: E_README_ORDER_SETUP, E_DATASHEET_PUBLIC_PRODUCTS, E_SQL_OPENTENDER_INPUT, E_SQL_TED_CAN_INPUT, E_SQL_TED_CN_INPUT, E_SQL_EC_SURVEY_INPUT, E_SQL_AWARD_CONTRACT_INPUT, E_SQL_AWARD_LOT_INPUT, E_SQL_AWARD_TECHNICAL_INPUTS, E_SQL_DIRECTIVE_INPUTS, E_SQL_MONITORING_INPUT, E_SQL_COUNTRY_CPV_NAMES_INPUT, E_STATA_GDP_INPUT, E_STATA_GDP_CONSTRUCTION, E_STATA_FACTIVA_INPUT, E_STATA_FACTIVA_NGO_COUNTRY_LIST, E_STATA_FACTIVA_ALL_MEDIA, E_STATA_FACTIVA_KEYWORDS, E_STATA_TEMPORARY_DTA_PRODUCER, E_STATA_TEMPORARY_DTA_CONSUMER, E_APPENDIX_FACTIVA_RECIPE, E_SQL3_APPEND_HANDOFF, E_STATA4_INPUT_SAMPLES, E_WORKFLOW_TRACE, E_EUROSTAT_PRODUCT, E_TED_PUBLIC_PRODUCT, E_EC_COUNTRY_REPORTS, E_FACTIVA_PRODUCT, E_OPENTENDER_PUBLIC_PRODUCT, E_SOFTWARE_ENVIRONMENT

Preparation / proposed procedure:

1. Identify author-compatible Opentender Batch1, TED CAN and TED CN source inputs, then verify exact historical table schemas, fields, identifiers, country mapping and notice/award coverage before import.
2. Obtain the EC survey and monitoring-report author-prepared tables and both hand-collected award-criteria tables; document question/response coding, report-derived flags, contract/lot keys and the country transposition dates used in the two Directive tables.
3. Obtain or identify the Eurostat nama_10r_3gdp workbook and confirm the Sheet 2 geography/year/unit layout, NUTS3 codes and 2009–2014 observations before applying the documented Stata mean transform.
4. For Factiva, identify the author-prepared exports or obtain the documented compatible exports after confirming permitted entitlement; preserve the country/version file names, v1/v2 columns, all-media/keyword/NGO search variants and 2010–2019 annual coverage. Confirm the AUT_1 NGO seed is present.
5. Establish one execution root for the relative GDP Raw Data, Factiva Raw Data and temporary-file paths, and configure the empty Procurement database plus the separate read-only Proc_[Data Source Name] databases described in the README.
6. Record the SQL Server 2017 product/version and exact installed ODBC driver name/version using approved local software metadata; the author package names only the `Procurement` DSN and does not specify a driver version. Do not inspect external DSN configuration or infer connection success from package presence. Preserve the four stages and the table operations summarized in the hashed workflow trace.

Validation to perform later:

- At a separately authorized run, confirm every source table/file maps to the expected fields, IDs, country/year coverage and transformation; verify stage 1 creates SAMPLE_FOR_ANALYSES, stage 2 reads it and writes LOCAL_GDP_CLEANSED plus Media_Coverage_TED, stage 3 joins both outputs, and stage 4 creates the six e(sample) indicators without changing the author samples or estimators.

### A_PREPARE_WINSOR2: Before an authorized run, provide and verify the author-required winsor2 command in the Stata adopath.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_WINSOR2
Evidence: E_STATA4_SAMPLE_FILTER, E_SOFTWARE_ENVIRONMENT

Preparation / proposed procedure:

1. Obtain the compatible winsor2 ado package through an authorized software source and place it in the approved Stata adopath; do not substitute a different winsorization procedure.

Validation to perform later:

- Use the frozen software probe to confirm which winsor2 resolves in the intended Stata adopath before any author program is run.


## Remaining issues and prerequisites

- I_INPUTS_AND_HANDOFFS_UNVERIFIED [unresolved; full_pipeline]: The supplied programs establish 15 concrete raw/file inputs, their consumed fields, transformations and ordered SQL/Stata table handoffs, but the source histories, compatible payloads, hand-collected mappings, Factiva file coverage and runtime database mapping are not verified. Relative data paths also lack a supplied working-directory setup. No compatible analysis-only panel is supplied; Identifiers.txt is documented as final-sample identifiers.
- R_OPENTENDER_RAW [undetermined]: SQL stage 1 requires Proc_Opentender_Batch1.DBO.OpenTender_Batch1 with RECORD_ID and FIELD key/value rows; the source table is reshaped into contract-level fields before joining TED.
- R_TED_CAN [undetermined]: SQL stage 1 requires Proc_TED.dbo.TED_CSV_CAN with ID_NOTICE_CAN, LOTS_NUMBER, ISO_COUNTRY_CODE, CPV and NUMBER_OFFERS to form contract-lot award records.
- R_TED_CN [undetermined]: SQL stage 1 requires Proc_TED.dbo.TED_CSV_CN with FUTURE_CAN_ID, DT_DISPATCH and ID_NOTICE_CN to map contract notices to award notices and retain dispatch timing.
- R_EUROSTAT_GDP [undetermined]: Stata stage 2 requires the Eurostat regional GDP workbook NAMA_10R_3GDP.xlsx, sheet Sheet 2. It reshapes NUTS3/year GDP, averages 2009–2014 values by region, keeps the 2014 row and writes NUTS3/LOCAL_GDP to LOCAL_GDP_CLEANSED.
- R_EC_SURVEY [undetermined]: SQL stage 1 requires Proc_ECReport.DBO.Survey_handcollected with COUNTRY, COUNTRY_NAME, REGULATOR, QUESTION and RESPONSE; nine named questions are transformed and collapsed into EC_SURVEY_CLEANSED.
- R_MONITORING_REPORTS [undetermined]: SQL stage 1 requires Proc_ECReport.dbo.MonitoringReports with COUNTRY and REGULATOR_USES_DATA2, joined by country to populate the second regulator-data-use measure.
- R_AWARD_CONTRACT [undetermined]: SQL stage 1 requires the hand-collected contract-level award criteria table Proc_AwardCriteriaHandCollected.dbo.AWARD_CRIT_HANDCOLLECTED_CONTRACT_LEVEL with CONTRACT_ID_DIGI, PRICE_WEIGHT and TECHNICAL_WEIGHT.
- R_AWARD_LOT [undetermined]: SQL stage 1 requires the hand-collected lot-level award criteria table Proc_AwardCriteriaHandCollected.dbo.AWARD_CRIT_HANDCOLLECTED_LOT_LEVEL with CONTRACT_ID_DIGI, LOT_NO_DIGI, PRICE_WEIGHT and TECHNICAL_WEIGHT.
- R_DIRECTIVE [undetermined]: SQL stage 1 requires Proc_DirectiveTranspoHandCollected.dbo.Directive_Transpo with ISO_COUNTRY_CODE and TRANSPO_DATE to construct PROCUREMENT_DIRECTIVE.
- R_DIRECTIVE_ROBUST [undetermined]: SQL stage 1 requires Proc_DirectiveTranspoHandCollected.dbo.Directive_Transpo_robustness with ISO_COUNTRY_CODE and TRANSPO_DATE to construct PROCUREMENT_DIRECTIVE_ROBUST.
- R_COUNTRY_NAMES [undetermined]: SQL stage 1 requires Proc_CountryIndustryNames.dbo.COUNTRY_ABBREVIATIONS with COUNTRY and COUNTRY_NAME to label the final sample.
- R_CPV_NAMES [undetermined]: SQL stage 1 requires Proc_CountryIndustryNames.dbo.CPV_NAMES with CPV_2DIG and CONTRACT_TYPE_NAME to label two-digit CPV contract types.
- R_FACTIVA_NGO [undetermined]: Stata stage 2 requires Factiva Raw Data/<ISO3>_<1-5>.csv series for the listed AUT, BEL, BGR, CHE, CZE, DEU, DNK, ESP, FRA, GBR, HUN, IRL, ITA, NOR, POL, PRT, SVK and SWE codes. It reads v1/v2 as date/publications for 2010–2019; the AUT_1 tempfile is later used as the unconditional append seed.
- R_FACTIVA_ALL [undetermined]: Stata stage 2 requires the explicitly named Factiva Raw Data/<country>_All_Media_Coverage.csv file for each of 31 hard-coded countries. Each unguarded import expects v1/v2 date and publication count, then retains 2010–2019.
- R_FACTIVA_KEYWORDS [undetermined]: Stata stage 2 requires the explicitly named Factiva Raw Data/<country>_Only_Keywords_Yearly.csv file for each of 19 hard-coded countries. Each unguarded import expects v1/v2 date and publication count, then retains 2010–2019.
- S_WINSOR2 [preparation_required]: The final Stata program calls winsor2, but the environment probe did not find it in the checked default or shared adopaths. Provision and verify this command before a future authorized run; no install was attempted.
- S_SQL_SERVER_ODBC [unverified]: The README specifies SQL Server 2017. Stata calls an ODBC DSN named Procurement for table reads/writes; the installed driver name/version, server mapping and connectivity were not established. No external DSN configuration was read and no connection/query was attempted.

## Review notes

- The first source screen's observed stdout was an empty list because its pattern omitted dsn(...); its original argv/cwd/separate-stderr capture was not retained. The saved observation records that limitation. The earlier raw reader display showed generic DSN/table statement text; the corrected structural trace retains only operation, table, source line and line hash, omitting ODBC statement text. No credential value was included in the assessment and no ODBC connection/query was made.
- All four supplied programs and the supplied README, datasheet, appendix and dependency checklist were reviewed. The populated input contracts retain all 15 raw/file inputs and all eight frozen checklist dependencies: D0001 and D0006–D0008 are generated stage-2 intermediates, D0002 is the GDP workbook, and D0003–D0005 are the required Factiva file families.
- The native sequence is SQL stage 1 → Stata stage 2 → SQL stage 3 → Stata stage 4. Stata writes LOCAL_GDP_CLEANSED and Media_Coverage_TED, SQL stage 3 joins those into SAMPLE_FOR_ANALYSES, and the final Stata program conditions six regression samples in memory.
- Public product pages support candidate sources only; they do not verify the historical author data, exact schemas, country/year coverage, hand-collected coding, Factiva entitlement or the table import mapping. The static open of the author-named opentender.eu root returned no readable lines; this is a capture limit, not evidence of absence. The local catalog alias search is metadata-only and its empty results are not evidence of source absence.
- The README and datasheet identify the title consistently. Identifiers.txt is documented as final-sample identifiers and is not an analysis panel; no analysis-only route is established.
- The first finalizer wrapper invocation launched the controller child but failed while saving its result to a nonexistent directory. The exact observed wrapper exception, read-only submission hash/mode and preserved first output-pair hashes are in probes/finalizer_attempt001_capture_failure.json. The child's return status and separate stdout/stderr were not persisted and are not reconstructed; the corrected controller invocation is captured separately.
- Public quote QA checked all five public evidence rows against the observed source/tool returns and retained literal contiguous fragments. The Eurostat quote is now only the exact dataset title; the separate static open returned only a navigation line, so no coverage claim is made from that open. The Factiva quote has no added terminal period. TED, EC and Opentender fragments remain exact; the Opentender page is the current Uganda site and does not verify the historical European Batch1 input.
