# Patch proposal: jar-2f384e60dfbe

Financial Reporting Around Private Firms' Securities Offerings

DOI: 10.1111/1475-679X.12598

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied R cleaning and prediction work plus the Stata master analysis workflow, including cross-language inputs, required raw-source construction and all referenced analysis branches.

Entry points: `R_Code.R`, `Stata_Master.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 2/12598 - Financial-Reporting-Around-Private-Firms-Securities-Offerings/kangdatasheetcodeandlogfiles.zip",
      "sha256": "de1cd5ff303f084006954f129b5d031730454db77aebe896821696c9378665ba"
    },
    {
      "path": "JAR-Volume 63/Issue 2/12598 - Financial-Reporting-Around-Private-Firms-Securities-Offerings/kang-online-appendix.pdf",
      "sha256": "bd17ec2db98ef8c03898cf27e3a7dda729a7571a93568dab8a8878e99b045395"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "a86d2ed90e2aca6c0d4779d5a6d52a7f7bb87e14858e8c9df7cf04f8a973686b"
}
```

## Proposed actions

### A_SEC_FORMD_ACQUIRE: Acquire the documented SEC Form D quarterly data for the required filing window and stage the documented table files under the R relative raw-data tree.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_FORMD
Evidence: E_SEC_LANDING, E_SEC_FORMAT_DOC, E_R_SEC_TABLES, E_R_ISSUERS, E_R_OFFERING, E_R_RECIPIENTS

Preparation / proposed procedure:

1. Use the official SEC Form D data-set landing page and its documentation to select the needed quarterly product; do not require byte-identical copies of the authors’ historical download.
2. Extract the documented submission, issuer, offering and recipient tables into a working copy preserving the relative Data/RawData/Form D layout.
3. Map each R table pattern to the appropriate file family and preserve accession and sequence keys.

Validation to perform later:

- Check UTF-8 tab-delimited headers, ACCESSIONNUMBER keys and period coverage against the selected official quarter metadata.
- Confirm all fields required by R and the approved analysis window before constructing the author tables.

### A_DFPI_ROUTE: Resolve the exact public DFPI batch product and its schema before acquiring or treating it as part of the initial analysis input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DFPI_BATCH
Evidence: E_DATASHEET_PUBLIC, E_DFPI_FILING_PAGE, E_CATALOG_DFPI_LOOKUP

Preparation / proposed procedure:

1. Identify an official current landing/catalog/documentation URL for the author-described batch product, or obtain the author’s exact source URL and data dictionary.
2. Confirm the filing type, columns, key, coverage, release changes and permitted access route; do not infer access from the filing portal or a catalog miss.

Validation to perform later:

- Verify a documented product/source, schema and coverage for the required 25102(f) filings before using the product.

### A_R_PATH_SETUP: Set a coherent working-copy root for the R source’s relative data inputs and outputs.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_R_WORKDIR
Evidence: E_R_WORKDIR, E_R_SURVEY_READ

Preparation / proposed procedure:

1. Place the supplied code in a working copy that preserves Data/RawData/Form D and the expected survey/input/output locations.
2. Replace both empty setwd placeholders with the same validated project root.
3. For later host wrappers, use relative or [redacted-path-196c5886a364] paths and keep the author's separate directory roots coherent.

Validation to perform later:

- Before any separately authorized run, verify the selected working directory is visible and writable on the host and that all relative input/output paths resolve.

### A_R_EARLY_IMPORTS: Load the two packages needed before the first Form D parse calls; keep the working-directory value unresolved for separate configuration.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_R_NAMESPACE_ORDER, SW_DATA_TABLE, SW_LUBRIDATE
Evidence: E_R_FREAD_PARSE, E_R_WORKDIR, E_R_PACKAGE_PROBE

**Proposed edit:** `R_Code.R:16–16`
Source SHA-256: `77dba9d63148551bd5e5a82b5e111b6f3b8b1aa3fb0365e847e37513108db644`

The supplied script calls fread and parse_date_time at lines 19-25 before any package loads and does not otherwise attach data.table or lubridate.

Current text:
```
setwd("")
```

Proposed replacement:
```
library(data.table)
library(lubridate)
setwd("")
```

Preparation / proposed procedure:

1. After the required packages are available, apply the proposed import-order edit to a working copy only.
2. Keep both empty working-directory values as a separate configuration decision.

Validation to perform later:

- Confirm library resolution for data.table and lubridate with package metadata before any authorized run; inspect the exact edited source text without running the author program.

### A_R_PACKAGE_SETUP: Provide the free R packages used by the supplied cleaning and conversion code in the execution library.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_DATA_TABLE, SW_LUBRIDATE, SW_HAVEN, SW_TIDYVERSE
Evidence: E_R_PACKAGE_PROBE, E_R_FREAD_PARSE, E_R_SURVEY_READ, E_R_PRED_OUTPUT

Preparation / proposed procedure:

1. Install or expose data.table, lubridate, haven and tidyverse in the intended host R library; no package installation was performed in this assessment.
2. Start the future script in an environment that loads data.table and lubridate before line 19 and loads haven/tidyverse before their later calls.

Validation to perform later:

- Use read-only package metadata to confirm package names and versions in the intended R library before any authorized run.

### A_R_FORMD_BINDINGS: Obtain the missing table-binding and join-key definitions for the R Form D assembly.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FORMD, I_R_FORMD_BINDING
Evidence: E_R_ISSUERS, E_R_OFFERING, E_R_RECIPIENTS, E_R_FORMD_JOIN

Preparation / proposed procedure:

1. Identify the intended primary_issuers table, the row-bound offering table and the role of each parsed file list.
2. Confirm the exact broker join key and table cardinality; do not infer or silently replace the author join expressions.

Validation to perform later:

- Confirm that each joined object is a data frame with the documented ACCESSIONNUMBER/recipient keys and that the intended source fields are present.

### A_SURVEY_ACCESS_AND_MAPPING: Establish permitted access to the survey analysis data and map the three distinct code-level aliases without assuming they are interchangeable.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_SURVEY, R_SURVEY_STATA, R_SURVEY_CSV, I_SURVEY_VARIANTS
Evidence: E_DATASHEET_SURVEY, E_DATASHEET_PRIVACY, E_R_SURVEY_READ, E_R_RCSV_INPUTS, E_STATA_SURVEY_READ

Preparation / proposed procedure:

1. Request an authorized analysis-use copy or documented access path at the appropriate aggregation level, together with the data-sharing/replication-use terms and a field dictionary.
2. Document whether survey.dta, the CSV named survey and survey data.dta are the same source, transformations or distinct samples; keep their separate role/field contracts until established.

Validation to perform later:

- Check permitted use, data de-identification, keys, fields and December 2022-March 2023 collection window without treating confidentiality language as permanent denial.

### A_FORMD_CSV_SOURCE: Identify the producer and schema for the separate formd CSV input used by R Part 3.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FORMD_CSV
Evidence: E_R_RCSV_INPUTS, E_R_CB_JOIN_OUTPUT

Preparation / proposed procedure:

1. Request the exact file/source, producer step, field dictionary and key rules for the formd input, including entityname and state_last_formd.
2. Confirm whether it is a prepared SEC Form D product or a distinct dataset; do not assume the raw SEC table merge produced it.

Validation to perform later:

- Verify the source fields, observation unit, identifiers and history against the actual R join contract before staging the CSV.

### A_FORMD_PRED_SOURCE: Request the missing producer and field contract for the nonrespondent prediction input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FORMD_PRED
Evidence: E_R_PRED_INPUT, E_APP_NONRESP

Preparation / proposed procedure:

1. Obtain the source/preparation steps and schema for formd_prediction.dta, including cik, broad_indus, lamount_fdw and lofferingw and the later outcome/control fields.
2. Confirm the nonrespondent population, survey exclusion key and industry categories used by the supplied prediction branch.

Validation to perform later:

- Check that the documented keys/fields match the R joins and the Stata predicted_info consumer before creating the input.

### A_CRUNCHBASE_SOURCE: Resolve the Crunchbase snapshot and missing cb_company producer/field mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CRUNCHBASE, I_CRUNCHBASE_BINDING
Evidence: E_R_RCSV_INPUTS, E_R_CB_JOIN_OUTPUT, E_CATALOG_CRUNCHBASE_LOOKUP

Preparation / proposed procedure:

1. Obtain the exact Crunchbase product/snapshot, field dictionary, entity identifier and coverage/entitlement terms for crunchbase.csv.
2. Clarify how cb_company is created from cb and how permalink/state_code map to formD_filers; do not infer a licensing barrier or an undocumented transformation.

Validation to perform later:

- Confirm the selected product's permitted acquisition route and matching keys/fields before building the join input.

### A_CRSP_DAILY_PREP: Prepare both CRSP daily aliases from the available source products using their common identifiers and documented effective-date rules.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CRSP_DAILY, R_CRSP_DSI, R_CRSP_DSENAMES
Evidence: E_PROBE_DSF, E_PROBE_DSI, E_PROBE_DSENAMES, E_STATA_CRSP_DAILY_ERC, E_STATA_CRSP_RET_CALC

Preparation / proposed procedure:

1. Convert the daily SAS source tables to Stata-readable files in the author-relative input tree.
2. Join DSF to DSI by DATE, then attach DSENAMES share/exchange codes by PERMNO and the source-defined NAMEDT/NAMEENDT effective interval.
3. Preserve PERMNO, DATE, RET, PRC, VWRETD, SHRCD and EXCHCD in the Data/Original/CRSP_daily alias used by both daily branches.

Validation to perform later:

- Verify the exact field names and documented effective-date rule before constructing the aliases; confirm the daily source dates support both consumers without a new whole-data sweep.

### A_CRSP_MONTHLY_PREP: Prepare the monthly CRSP alias from MSF and its date-effective name-history codes.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CRSP_MONTHLY, R_CRSP_MSENAMES
Evidence: E_PROBE_MSF, E_PROBE_MSENAMES, E_STATA_CRSP_MONTHLY

Preparation / proposed procedure:

1. Convert MSF and MSENAMES to Stata-readable tables in the author-relative input tree.
2. Join monthly stock rows to date-effective name-history rows by PERMNO and the source-defined NAMEDT/NAMEENDT interval, retaining PERMNO, DATE, RET, SHRCD and EXCHCD.
3. Write the resulting alias at the relative CRSP.dta path expected by the Stata master.

Validation to perform later:

- Confirm the source-defined effective-date rule and required monthly fields before creating the alias.

### A_COMP_LINK_PREP: Use the local Compustat annual and CCM source products to prepare the LPERMNO/date-linked annual file under the author's relative path.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMPU_ANNUAL, R_CCM_LINK
Evidence: E_PROBE_FUNDA, E_PROBE_CCM, E_STATA_COMPU_IBES

Preparation / proposed procedure:

1. Prepare annual Compustat observations from COMP.FUNDA and add the CRSP PERMNO through GVKEY and the documented CCM date/link selection rules.
2. Export the prepared file to Data/Original/Compu_annual.dta with the source-supported financial fields and link identifier.

Validation to perform later:

- Confirm the active link date/type policy from the applicable CCM documentation before preparing the file.
- Resolve the separate SICH-versus-SIC definition issue before claiming the industry field is compatible.

### A_COMP_SIC_DEFINITION: Obtain the actual definition/time contract for the Stata SIC variable before mapping it to local SICH.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMPU_ANNUAL, I_COMP_SIC_MEANING
Evidence: E_PROBE_FUNDA, E_CATALOG_SICH, E_STATA_SIC_CONSUMPTION

Preparation / proposed procedure:

1. Request the author's source dictionary or prepared Compustat schema explaining whether the consumed SIC is historical/current and how it was constructed.
2. Use a confirmed field mapping only after definition and time semantics match; do not rename SICH to SIC by spelling alone.

Validation to perform later:

- Check the confirmed definition and effective period against every SIC consumer before producing Compu_annual.dta or permno_sic.dta.

### A_IBES_MAPPING: Resolve the standalone ibes.dta producer, measure and date/identifier mappings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_IBES, I_IBES_MAPPING
Evidence: E_STATA_COMPU_IBES, E_STATA_SUE, E_PROBE_IBES_SURPSUM, E_PROBE_IBES_DETU, E_PROBE_IBES_ACTU, E_CATALOG_IBES

Preparation / proposed procedure:

1. Request the producer or data dictionary for ibes.dta and the exact SURP definition, including actual/estimate measure, ticker-to-PERMNO mapping and DATADATE/EADATE construction.
2. Keep SURPSUM, detailed estimates and actuals as distinct candidate source products until a supported mapping establishes which are required.

Validation to perform later:

- Confirm PERMNO, DATADATE, EADATE and SURP columns and the fiscal-period/event-date matching rules before merging into Compustat.

### A_STATA_INITIAL_DATA: Identify the missing variable-ready initial dataset and its active preparation producer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATA_INITIAL, I_STATA_INITIAL_INPUT
Evidence: E_STATA_INITIAL, E_DATASHEET_CODE_ROLES

Preparation / proposed procedure:

1. Request the exact initial Stata input path, its field dictionary and the upstream producer that supplies disclosure, offering, size and intermediary variables.
2. Map the confirmed producer to the full pipeline; do not invent a filename or treat later CRSP/Compustat files as the initial analysis dataset.

Validation to perform later:

- Verify that the input is loaded after clear all in the working copy and contains all variables used before the first later use statement.

### A_YE_INPUT: Resolve the fiscal-year-end table source and producer used in annual-return alignment.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_YE
Evidence: E_STATA_ANNUAL_RETURN_INPUTS

Preparation / proposed procedure:

1. Obtain the ye.dta producer, schema, PERMNO/FYR history and its rule for the three-month fiscal-year-end date alignment.
2. Keep the file separate from annualreturns.dta and annualreturns1.dta, which are actual outputs in this Stata branch.

Validation to perform later:

- Confirm one documented PERMNO/FYR mapping per intended fiscal-year/date before the monthly-return merge.

### A_EVENT_WINDOW_INPUT: Resolve the announcement-window date set used for daily-return aggregation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EARN_WINDOW
Evidence: E_STATA_EVENT_WINDOW_INPUT

Preparation / proposed procedure:

1. Obtain the producer and field dictionary for earn_annc_window_permnos, including announcement-date source, event-window bounds and PERMNO/date matching rules.

Validation to perform later:

- Confirm the input has the PERMNO and DATE keys and the intended event window before joining daily returns.

### A_PERMNO_SIC_INPUT: Resolve the SICCD definition and producer for the PERMNO-to-industry input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PERMNO_SIC
Evidence: E_STATA_PERMNO_SIC_INPUT, E_CATALOG_SICH

Preparation / proposed procedure:

1. Obtain the permno_sic.dta producer and its SICCD source, effective date and historical/current classification definition.
2. Keep its SICCD mapping separate from Compustat SICH unless a source dictionary confirms equivalence for the consumed period.

Validation to perform later:

- Confirm the file's PERMNO/SICCD keys, observation dates and classification contract before industry aggregation.

### A_ERC_FF_INPUT: Resolve the FF-industry summary input without exposing or guessing the withheld connected block.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ERC_FF, I_OPAQUE_PRODUCER_BLOCKS
Evidence: E_STATA_ERCFF_READ, E_SOURCE_SCREEN

Preparation / proposed procedure:

1. Request a safe, non-sensitive description of the producer and schema for erc_ff.dta and the FF classification vintage used.
2. Keep the screened connected block opaque; do not infer its contents or request credentials/connection text.

Validation to perform later:

- Confirm the seven FF code keys and required ERC summary fields match the merge and downstream variables.

### A_SURVEY_WEBSITE_INPUT: Resolve the website-survey merge input and its producer using safe schema/source documentation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SURVEY_WEBSITE, I_OPAQUE_PRODUCER_BLOCKS
Evidence: E_STATA_WEBSITE_INPUT, E_SOURCE_SCREEN

Preparation / proposed procedure:

1. Request the non-sensitive producer, schema and source/collection route for survey_website.dta; the connected block immediately before its merge remains withheld.
2. Confirm entityname normalization/matching rules and the disclosure-length variables used downstream.

Validation to perform later:

- Verify the entityname key, merge cardinality and fields used by the website regression before preparing the input.


## Remaining issues and prerequisites

- I_STATA_INITIAL_INPUT [unresolved; full_pipeline]: The Stata master clears all in-memory data and immediately generates information_count from pre-existing disclosure variables. No initial analysis dataset or producer is identified before this use, so the first Stata analysis block has an unresolved input handoff.
- I_R_WORKDIR [preparation; full_pipeline]: R_Code.R contains empty setwd settings before its relative raw-data and survey paths. The working-copy root and output directories must be set coherently before a future run.
- I_R_NAMESPACE_ORDER [preparation; full_pipeline]: R calls fread and parse_date_time before any package library statements and does not visibly attach data.table or lubridate. A clean entry session needs those namespaces loaded before first use.
- I_R_FORMD_BINDING [unresolved; full_pipeline]: The issuer and offering files are parsed into a generic all_files list, but the later joins use primary_issuers and offering objects. Their table-binding, primary-issuer selection and broker join-key construction are not established by the supplied R statements.
- I_CRUNCHBASE_BINDING [unresolved; full_pipeline]: R reads the CSV into cb but later joins against cb_company; no producer for cb_company is visible. Its field preparation and identifier/name/state matching contract remain unknown.
- I_SURVEY_VARIANTS [unresolved; full_pipeline]: The R branch reads survey.dta and a separate CSV named survey, while Stata reads survey data.dta. The package does not establish that these are the same source, compatible exports or the same analysis sample.
- I_COMP_SIC_MEANING [unresolved; full_pipeline]: The Stata industry branch consumes SIC, while local COMP.FUNDA metadata exposes SICH, a historical SIC field. The source/dictionary definition and time contract needed to compare them are not established; do not automatically rename SICH to SIC.
- I_IBES_MAPPING [unresolved; full_pipeline]: Stata merges a separate ibes.dta file on PERMNO and DATADATE, then consumes EADATE and SURP. The producer, EPS measure and mapping from available I/B/E/S products to those variables are unknown.
- I_OPAQUE_PRODUCER_BLOCKS [unresolved; full_pipeline]: Two connected Stata blocks remain wholly withheld by the required byte-first source screen. The adjacent erc_ff.dta and survey_website.dta consumers are known, but the hidden text is not used to infer their producers or other dependencies.
- R_FORMD [public_acquisition_required]: SEC Form D raw tables read by R Part 1. The program selects submission, issuer, offering and recipient files; public table/field documentation supports these source products, while the in-code bindings for primary_issuers and offering remain a separate source issue.
- R_SURVEY [undetermined]: Private survey analysis input read by R as survey.dta and used to train/predict information provision; file, schema, release/permissions and exact relation to other survey aliases are not supplied.
- R_FORMD_PRED [undetermined]: Nonrespondent Form D prediction input read as formd_prediction.dta. The supplied code consumes cik, broad_indus, lamount_fdw and lofferingw and later preserves additional outcome/control fields, but its producer and complete schema are unknown.
- R_CRUNCHBASE [undetermined]: Crunchbase company/funding input read from crunchbase.csv in R Part 3. The code then joins through cb_company, whose producer is not visible in the supplied R source; product/version, fields, identifiers and history are unknown.
- R_COMPU_ANNUAL [undetermined]: Stata consumes Data/Original/Compu_annual.dta with LPERMNO, DATADATE, FYEAR/FYR, financial fields and SIC for annual-return, IBES and industry analyses. The local COMP.FUNDA candidate contains SICH rather than the code’s SIC name; the actual definition/time mapping and prepared-file producer remain unresolved.
- R_IBES [undetermined]: The Stata code separately consumes ./Data/Output/ibes.dta and requires PERMNO, DATADATE, EADATE and SURP for fiscal-period/announcement-date matching and earnings surprise. Its producer and measure mapping from the available I/B/E/S products are unknown.
- R_DFPI_BATCH [undetermined]: California DFPI 25102(f) batch data named by the author datasheet; the supplied source does not expose its schema, exact file/product definition, link keys or coverage.
- R_FORMD_CSV [undetermined]: Separate formd CSV input read by R Part 3 and joined by issuer name/state; its producer and relationship to the SEC Form D raw tables are not shown.
- R_SURVEY_CSV [undetermined]: Separate CSV survey input read by R Part 3, used for response.id and recipient.first.name matching; its producer and relation to survey.dta and Stata’s survey data file are unknown.
- R_SURVEY_STATA [undetermined]: Separate Stata survey input loaded in the Stata master for industry-level EA-return analyses; its relationship to the R survey.dta and CSV survey input is unestablished.
- R_STATA_INITIAL [undetermined]: The first Stata analysis block requires a variable-ready dataset containing Form D disclosure, offering, intermediary and size fields, but clear all is followed by variable generation without an identified load or producer.
- R_YE [undetermined]: Fiscal-year-end mapping input ye.dta used with monthly CRSP returns to select the fiscal-year-end-plus-three-month window; producer, fields, key and date rules are not supplied.
- R_EARN_WINDOW [undetermined]: earn_annc_window_permnos input merged to daily returns by PERMNO and DATE before announcement returns are aggregated; its event-window construction and producer are unknown.
- R_PERMNO_SIC [undetermined]: permno_sic.dta maps PERMNO to SICCD for the EA-return industry summaries; source, classification definition and effective-date mapping are unknown.
- R_ERC_FF [undetermined]: erc_ff.dta is merged on FF5/10/12/17/30/38/48 classifications in the ERC/industry branch; its producer, full schema and classification version are unresolved.
- R_SURVEY_WEBSITE [undetermined]: survey_website.dta is separately merged by entityname for the website disclosure/length regression branch; its producer, source, full schema and matching rules are unknown.
- SW_DATA_TABLE [preparation_required]: R --vanilla package metadata did not find data.table in the clean library paths. R calls fread before any package loads; configured user-library availability was not inspected.
- SW_LUBRIDATE [preparation_required]: R --vanilla package metadata did not find lubridate in the clean library paths. The code calls parse_date_time before package loads; configured user-library availability was not inspected.
- SW_HAVEN [preparation_required]: R --vanilla package metadata did not find haven in the clean library paths; the script uses read_stata and write_dta.
- SW_TIDYVERSE [preparation_required]: R --vanilla package metadata did not find tidyverse in the clean library paths; the supplied code uses its attached dplyr/tidyverse operations.

## Review notes

- The assessed target is the full supplied R cleaning/prediction work and Stata master workflow. No separate analysis-only route is supported by a complete compatible prepared input; the first Stata block’s initial dataset remains an explicit unresolved handoff.
- Source programs were screened byte-first before display. Exact source quotes use the saved screened reader. Two Stata connected blocks remain withheld; their contents and any producers within them are not inferred. The R Part 3 formd_cb_stata.dta output is retained as a supplied branch, but no visible Stata consumer is established. The two Stata dailyreturns products have different fields and roles and remain distinct.
- Local catalog and one-row metadata evidence identifies CRSP daily/monthly stock, index and name-history products plus Compustat Funda, CCM and I/B/E/S candidates. One-row field metadata does not establish row coverage or empirical period coverage. CRSP path/format staging is preparation; Compustat SICH is not renamed to SIC; ibes.dta remains a separate unverified measure/producer mapping.
- The SEC public Form D product and static documentation support the public raw-table route. The author-described DFPI batch product remains unverified: bounded official pages/snippets document filing/forms, while direct static-page requests returned HTTP 403 without bodies. That retrieval result is not treated as a data-access barrier or as proof of data absence. Survey privacy language is treated as an access/terms question, not permanent denial.
- No author program, dataset payload, statistical/model trial, SAS process, source edit or remote job was run. Bounded metadata requests with wrong paths/field selections and their corrections were preserved as separate artifacts; the malformed original catalog-failure capture was not replaced. One quote-capture JSON verification command used an unavailable generic python alias; the saved quote file was subsequently parsed and hashed with the documented Miniforge interpreter.
- The first saved metadata preflight found duplicate evidence rows, three dangling inherited scope references and a non-schema requirement-kind token. The duplicate rows were identical and deduplicated; the dangling references were removed because the current scope already cites the replacement evidence; every requirement kind now uses the frozen schema token. The failed preflight artifact is preserved.
