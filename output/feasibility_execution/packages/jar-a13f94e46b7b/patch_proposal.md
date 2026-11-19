# Patch proposal: jar-a13f94e46b7b

Accounting Rules and the Labor Market for Accountants

DOI: 10.1111/1475-679X.70043

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented master.do workflow, including manual Python notebook stages and downstream empirical branches.

Entry points: `01 - Code/master.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 4/70043 - Accounting-Rules-and-the-Labor-Market-for-Accountants/le-datasheet-readme-code-identifier-and-log-files.zip",
      "sha256": "7513faabfd786fee3c88ca7e15775b35293ec6c7d6afb9420817afe95c7eb07e"
    },
    {
      "path": "JAR-Volume 64/Issue 4/70043 - Accounting-Rules-and-the-Labor-Market-for-Accountants/le-online-appendix.pdf",
      "sha256": "68b144a3fc7f243cde79aca28311af66a84f766f6a5d9c6694489291c9b3b6db"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "875a0a68371a381e367bcb74425ef91db4d4c17631b30b064fdbfd857f4137eb"
}
```

## Proposed actions

### A_MAP_INPUTS: Finish the source-to-input map for every registered read and checklist edge, preserving source-proven generated outputs separately from raw inputs.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_INPUT_CLOSURE
Evidence: E_DOC_DATA, E_DOC_DRIVER, E_STATE_LOOP, E_LINKUP_76_INPUT

Preparation / proposed procedure:

1. Reconcile the remaining checklist IDs and all source reads to raw requirements, producers, optional branches, or a specific unresolved issue.
2. Verify each mandatory raw product’s fields, identifiers, years and construction separately.

Validation to perform later:

- Every one of the 78 checklist IDs is covered exactly once and each generated file is linked to its producer.

### A_RESOLVE_LINKUP_HANDOFF: Confirm the documented conversion and staging steps that produce the 76 LinkUp intermediate CSVs consumed by analysis_labor_demand.do.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_LINKUP_HANDOFF
Evidence: E_XML_STAGE, E_WORDCOUNT_DIRS, E_LINKUP_76_INPUT, E_README_LINKUP_DATA

Preparation / proposed procedure:

1. Identify the documented splitter, renaming step, or manual handoff between output.csv, input/*.csv, output/*.csv and intermediate/output/output_i.csv.
2. Record the expected count, names, fields and date coverage of all 76 files.

Validation to perform later:

- A source-supported producer or author-confirmed procedure accounts for every output_i.csv consumed by Stata.

### A_PREP_COMP_PANEL: Prepare the author-compatible Compustat panel from the readable local annual source only after confirming NAICS meaning and year coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_COMP_FUND_PANEL, R_COMP_FUNDAMENTALS
Evidence: E_COMP_INPUT, E_COMP_FIELDS, E_COMP_FUNDA_CORE_PROBE, E_COMP_FUNDA_AT_PROBE, E_COMP_FUNDA_INDFMT_PROBE

Preparation / proposed procedure:

1. Confirm 1990–2020 coverage and identifiers in the annual COMP.FUNDA source.
2. Confirm whether historical NAICSH provides the author’s required NAICS classification.
3. Apply the source-specified INDFMT and duplicate filters and write expected columns only after mapping and period are documented.

Validation to perform later:

- Prepared data match the author code’s INDFMT, CIK, FYEAR, NAICS, GVKEY, AT and SALE requirements and cover the stated years.

### A_PREP_SEC_WORDCOUNT_SERIES: Reconcile annual SEC text and firm-standard word-count products required by the treatment builder.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_SEC_WORDCOUNT_SERIES, I_SEC_COVERAGE, R_SEC_FILINGS
Evidence: E_SEC_NOTE, E_SEC_CONFIG, E_EXPOSURE_OUTPUT, E_STATE_CSV, E_PUBLIC_SEC, E_LOCAL_SEC_LM_DIRS, E_PUBLIC_SEC_TEXT

Preparation / proposed procedure:

1. Verify 1993–2019 year-folder coverage and compatible filing text without relying on directory presence alone.
2. Run or document the manual notebook separately for each filing-year folder, and record each year-suffixed CSV path.
3. Resolve the 1993–1994Q2 gap with a documented permitted source if local files do not cover it.
4. Secure or validate the documented SEC year-folder text route, preserving the 1993–1994Q2 coverage gap if local sources do not cover it.

Validation to perform later:

- Every word-count CSV read by the treatment loop has an identified producer, year, path and fields.
- Required filing text is identified for each 1993–2019 year, with the uncovered early period stated explicitly.

### A_RESOLVE_NSCG_STEMS: Acquire the five NSF-listed public-use waves, then reconcile their author SAS names and required wave fields before treating them as compatible analytic inputs. Public year availability is confirmed; full input compatibility is not.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: I_NSCG_FILE_STEMS, R_NSCG_MICRODATA
Evidence: E_PUBLIC_NSCG, E_README_NSCG_STEMS, E_NSCG_EPCG17, E_NSCG_EPCG15, E_NSCG_EPCG13, E_NSCG_EPCG10, E_NSCG_ECG03, E_PUBLIC_NSCG_YEARS

Preparation / proposed procedure:

1. Acquire the NSF public-use files for 2003, 2010, 2013, 2015 and 2017; this is supported by the cited official year listing.
2. Compare each release filename with the README stems and the author SAS imports, recording any supported local naming or format mapping.
3. Map the required region, occupation, weight and outcome fields for each wave to the author construction before appending; do not infer field presence from year availability.

Validation to perform later:

- The five official public-use years are staged and exact file-name/format mappings are documented.
- Each required wave-specific field is documented against the author construction before the five waves are appended.

### A_PREP_GLASSDOOR: Use the documented raw review CSV to create the DTA file read by the active Glassdoor analysis.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_GLASSDOOR_STAGE
Evidence: E_README_MISC_DATA, E_GLASSDOOR_PREP_1, E_GLASSDOOR_PREP_2

Preparation / proposed procedure:

1. Confirm reviews_external_unc.csv and its expected columns.
2. Apply the commented import/save preparation and verify the resulting DTA path before the main program.

Validation to perform later:

- The staged DTA contains the review fields consumed by the analysis and traces to the documented CSV.

### A_CONFIRM_LINKUP_CASE: Align the master include spelling with the exact registered lower-case LinkUp header filename as portable workflow preparation.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_LINKUP_CASE_PATH
Evidence: E_MASTER_STAGE_12, E_LINKUP_ARCHIVE

**Proposed edit:** `01 - Code/master.do:32–32`
Source SHA-256: `7f289f8eef07696ab9e690f6b5abeedb5a6ca88760fa920f6319c4b4c5f0b029`

Use the exact registered filename case for portable resolution; this is not a claim that an operating-system failure was observed.

Current text:
```
do "${prog}/LinkUp/linkUp_header.do"
```

Proposed replacement:
```
do "${prog}/LinkUp/linkup_header.do"
```

Preparation / proposed procedure:

1. Apply the exact case alignment to the master include when preparing the portable working copy.
2. Keep linkup_header.do as the registered source and preserve its raw archive and generated header outputs.

Validation to perform later:

- The master include path matches the registered filename exactly on case-sensitive filesystems.

### A_CONFIRM_OEWS_MAP_RANGE: Confirm how the 2019 OEWS workbook fits the maps branch, which reads it but appends through 2018.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_OEWS_MAP_YEAR_RANGE
Evidence: E_MAP_OEWS_2019_READ_1, E_MAP_OEWS_2019_READ_2, E_MAP_OEWS_APPEND_1, E_MAP_OEWS_APPEND_2, E_MAP_OEWS_APPEND_3, E_PUBLIC_BLS_STATE_TABLES

Preparation / proposed procedure:

1. Confirm whether 2019 is intentionally read but omitted from the maps series or whether the append end year should include it.
2. Record the exact OEWS vintages needed for each output.

Validation to perform later:

- OEWS input vintages and map output years are explicit and internally consistent.

### A_CONFIRM_MASTER_SCOPE: Preserve master.do’s source-to-source calls as required code stages in the chosen full-pipeline scope.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_SCOPE_CODE_COMPONENTS
Evidence: E_MASTER_STAGE_02, E_MASTER_STAGE_03, E_MASTER_STAGE_04, E_MASTER_STAGE_05, E_MASTER_STAGE_06, E_MASTER_STAGE_07, E_MASTER_STAGE_09, E_MASTER_STAGE_10, E_MASTER_STAGE_11, E_MASTER_STAGE_13, E_MASTER_STAGE_14, E_MASTER_STAGE_15, E_MASTER_STAGE_16, E_MASTER_STAGE_17, E_MASTER_STAGE_18

Preparation / proposed procedure:

1. Retain each master-called source branch and the order shown by master.do when preparing the full workflow.
2. Keep the manually launched exposure and LinkUp notebook steps in the full workflow record.
3. Resolve the LinkUp header case discrepancy through its separate action.

Validation to perform later:

- Each of the 15 master include checklist IDs maps to a scope source; the only path spelling discrepancy is tracked separately.

### A_PREP_WINSOR2: Prepare winsor2 as explicitly requested by master.do before the OEWS wages program uses it.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: I_WINSOR2, SW_WINSOR2
Evidence: E_ENV_ORIGINAL, E_MASTER_SETUP

Preparation / proposed procedure:

1. When software setup is authorized, use the author-specified SSC installation command for winsor2.
2. Record a typed availability/version check before executing the Stata analysis programs.

Validation to perform later:

- winsor2 is available in the execution environment and its version is recorded.

### A_STAGE_FASB_INPUTS: Obtain the two author-named FASB standards inputs used directly by the treatment and industry programs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FASB_YEAR_TOTALS, R_FASB_KEYWORD_SHARES
Evidence: E_FASB_YEAR, E_IND_SHARE_KEYWORDS_1, E_IND_SHARE_KEYWORDS_2, E_README_MISC_DATA

Preparation / proposed procedure:

1. Stage std_year.sas7bdat and share_keywords.xlsx at the exact FASB Standards paths in the code.
2. Confirm the standards-year fields Org, Std_Num, Year and total_modal, and the workbook fields used for standard, year, share, organization, count and parent-standard joins.
3. Track annual firm-standard word-count CSVs as a separate generated workflow stage while preserving these two code-read FASB inputs.

Validation to perform later:

- Both author-read source files are present with the exact fields and vintages required by their separate joins.

### A_ACQUIRE_CBP_2000: Acquire and stage Census’s complete 2000 state CBP file in the author import format.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_CBP_2000
Evidence: E_PUBLIC_CBP_2000, E_CBP_BASE, E_NSCG_CBP_FIELDS_1, E_NSCG_CBP_FIELDS_2, E_NSCG_CBP_FIELDS_3, E_NSCG_CBP_FIELDS_4, E_NSCG_CBP_FIELDS_5

Preparation / proposed procedure:

1. Acquire the Census 2000 Complete State File and its applicable record layout.
2. Prepare the author-named cbp2000st.txt form and verify employment, 1997 NAICS and state FIPS fields before use.

Validation to perform later:

- The staged 2000 state file matches the author’s expected source path and has fields that can be imported as emp, naics and fipstate.

### A_STAGE_CBP_MAPPINGS: Stage the author-named NAICS and state/region mapping files used by both treatment construction and NSCG.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_NAICS_XWALK, R_CBP_STATE_REGION_LOOKUPS
Evidence: E_CBP_XWALK, E_NSCG_XWALK, E_NSCG_STATE_NAMES, E_NSCG_REGION_MAP_1, E_NSCG_REGION_MAP_2, E_NSCG_REGION_MAP_3, E_README_MISC_DATA, E_PUBLIC_CBP_NAICS

Preparation / proposed procedure:

1. Obtain efsy_naics97_to_naics12.csv, state_names.txt and state_to_region.xlsx from the documented author input set.
2. Verify NAICS97, NAICS12 and weight mapping fields, state-to-FIPS keys, and the state-to-NSCG-region join keys.
3. Preserve the 2000 CBP 1997-NAICS vintage when validating the crosswalk.

Validation to perform later:

- All three exact author-named mapping files and required join fields are identified without assuming local availability.

### A_STAGE_TFS_INPUTS: Obtain the two HERI TFS source files read by the student-major and maps branches.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_TFS_MICRODATA
Evidence: E_TFS_DISAGG, E_TFS_DEMOG, E_MASTER_STAGE_06, E_MASTER_STAGE_05

Preparation / proposed procedure:

1. Confirm an authorized route for the author’s TFS DISAGG.dta and DEMOGRAPHICS.dta files.
2. Verify SUBJID, YEAR, MAJOR, STUDWGT, STATE and the documented join keys across the relevant waves before preparation.

Validation to perform later:

- Both raw TFS files are available through a documented route and support the source-proven joins.

### A_ACQUIRE_OEWS_TABLES: Acquire and stage the verified BLS state OEWS tables used by employment and maps.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_OEWS_STATE_FILES
Evidence: E_PUBLIC_BLS_AVAIL, E_PUBLIC_BLS_DOWNLOAD, E_PUBLIC_BLS_STATE_TABLES, E_OEWS_LOOP, E_OEWS_READ, E_MAP_OEWS_2019_READ_1, E_MAP_OEWS_APPEND_1

Preparation / proposed procedure:

1. Acquire state files for the 1997–2018 employment branch and the 2019 map input from the BLS historical tables.
2. Stage each vintage at the exact state_YEAR_dl.xls path or document the required workbook conversion and column names.
3. Keep the 2019 maps read/append discrepancy in its separate clarification action.

Validation to perform later:

- Required OEWS years and fields tot_emp, h_mean, a_mean, st, occ_code and wage percentiles are documented for each branch.

### A_ACCESS_LINKUP_INPUTS: Confirm authorized access to the LinkUp raw postings shards and dated job-description XML archive.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_LINKUP_ARCHIVE, R_LINKUP_XML_DESCRIPTIONS
Evidence: E_LINKUP_ARCHIVE, E_README_LINKUP_DATA, E_XML_STAGE, E_MASTER_STAGE_11, E_MASTER_STAGE_12

Preparation / proposed procedure:

1. Confirm the permitted vendor route for the dated raw postings CSV shards and raw description XML files, documenting the access route and terms.
2. Stage the postings shards and XML files at the author-documented paths after access is confirmed.
3. Let linkup_header.do produce acct_supply_header.csv as a workflow intermediate; do not treat it as a raw input.

Validation to perform later:

- Authorized raw postings and XML inputs are identified separately, and the header file is linked to its registered producer.

### A_ACQUIRE_GLASSDOOR_RAW: Obtain the author-documented raw Glassdoor reviews CSV before the separate DTA preparation stage.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_GLASSDOOR_REVIEWS
Evidence: E_README_MISC_DATA, E_GLASSDOOR_PREP_1, E_GLASSDOOR_PREP_2

Preparation / proposed procedure:

1. Confirm an authorized source for reviews_external_unc.csv and stage it at the exact Other/orig path.
2. Verify the date, state, occupation and review text/rating fields used by the source before applying the existing CSV-to-DTA preparation action.

Validation to perform later:

- The raw CSV is identified with the fields consumed by glassdoor_reviews.do.

### A_ACCESS_REVELIO_INPUTS: Confirm authorized access and stage the two source files required by the Revelio job-switch builder.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_REVELIO_POSITION_DATA
Evidence: E_REVELIO_LOOKUP, E_REVELIO_POSITIONS_1, E_REVELIO_POSITIONS_2, E_REVELIO_POSITIONS_3, E_README_MISC_DATA

Preparation / proposed procedure:

1. Confirm an authorized route for the WRDS Revelio individual positions file and the ONET-to-role lookup bridge.
2. Stage lookup.csv and individual_positions.csv at the exact source paths after access confirmation.
3. Verify role_k1500, user and position identifiers, dates, state and weight fields before producing the generated switch panels.

Validation to perform later:

- Both raw inputs are accessible through a documented route and the role_k1500 bridge keys match.

### A_STAGE_REVELIO_STATE_CODES: Stage the state/territory name crosswalk used by the Revelio outcome branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_REVELIO_STATE_CODES
Evidence: E_REVELIO_STATE_MAP_1, E_REVELIO_STATE_MAP_2, E_REVELIO_STATE_MAP_3, E_REVELIO_STATE_MAP_4

Preparation / proposed procedure:

1. Obtain or locate us_states_and_territories.csv from the author’s input set.
2. Confirm the state-name join key and resulting abbreviation used in the REGION/STATE-year merge.

Validation to perform later:

- The author-named state mapping file resolves state_name to the state abbreviation consumed by the program.

### A_STAGE_OUTREACH_WORKBOOK: Stage the author’s hand-collected accounting outreach program workbook.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_OUTREACH_PROGRAMS
Evidence: E_OUTREACH_INPUT_1, E_OUTREACH_INPUT_2, E_OUTREACH_INPUT_3, E_README_MISC_DATA

Preparation / proposed procedure:

1. Obtain outreach_programs_updated.xlsx from the author’s documented input set.
2. Verify state, year, Tab and Outreach fields and place the workbook at the exact Other/orig path.

Validation to perform later:

- The workbook supplies the state-year outreach rows consumed by the HERI cross-section.

### A_STAGE_SURVEY_AND_EXPERIMENT: Stage the four author-provided survey and experiment response CSVs for their distinct analysis branches.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_SURVEY_RESPONSES, R_EXPERIMENT_RESPONSES
Evidence: E_SURVEY_INPUTS_1, E_SURVEY_INPUTS_2, E_SURVEY_INPUTS_3, E_SURVEY_INPUTS_4, E_SURVEY_INPUTS_5, E_EXPERIMENT_INPUTS_1, E_EXPERIMENT_INPUTS_2, E_EXPERIMENT_INPUTS_3

Preparation / proposed procedure:

1. Confirm the source route for survey_1.csv and survey_2.csv, then stage them under the survey branch.
2. Separately confirm the source route for experiment_prolific.csv and experiment_columbia.csv and stage them under the experiment branch.
3. Validate the source-specific response fields before either append/harmonization step.

Validation to perform later:

- All four exact CSV inputs are identified and each branch’s required variables are present.

### A_STAGE_MAP_SHAPEFILE: Stage the documented U.S. state shapefile needed by maps.do.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MAP_SHAPEFILES
Evidence: E_MAP_SHAPE_1, E_MAP_SHAPE_2, E_MAP_SHAPE_3, E_README_MISC_DATA

Preparation / proposed procedure:

1. Obtain the s_08mr23 shapefile and required sidecar files at the exact map_data path.
2. Confirm its state identifiers align with the treatment panel; generate state_db and state_coordinates only through the documented shp2dta preparation.

Validation to perform later:

- The raw shapefile is complete and the generated map tables can be keyed to the source state abbreviations.

### A_STAGE_SEC_KEYWORDS: Stage the firm-standard keyword workbook expected by the manual exposure notebook.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_SEC_KEYWORD_LIST
Evidence: E_EXPOSURE_YEAR_CONFIG_1, E_EXPOSURE_YEAR_CONFIG_2, E_README_EXPOSURE_OUTPUT

Preparation / proposed procedure:

1. Obtain keyword_list.xlsx from the author’s documented input set.
2. Place it in the notebook working directory and verify the main worksheet expected by the source.

Validation to perform later:

- The exact workbook and main sheet are available to the manually launched exposure notebook.

### A_STAGE_LINKUP_DICTIONARY: Stage the Atalay word-count dictionary required by the manual LinkUp notebook.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_LINKUP_WORDCOUNT_DICTIONARY
Evidence: E_WORDCOUNT_DIRS, E_README_LINKUP_DATA

Preparation / proposed procedure:

1. Obtain atalaywords.xlsx from the documented author input set.
2. Place it at the expected LinkUp intermediate path and verify the mappings worksheet and columns used by the notebook.

Validation to perform later:

- The exact dictionary workbook is present and its mapping sheet supports the source’s word-count construction.

### A_SETUP_PPMLHDFE: Prepare ppmlhdfe, which master.do requests, before the Stata analysis branch runs.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_PPMLHDFE
Evidence: E_MASTER_SETUP, E_ENV_ORIGINAL

Preparation / proposed procedure:

1. When software setup is permitted, follow the author-specified SSC command for ppmlhdfe.
2. Record a typed availability/version check before executing the author programs.

Validation to perform later:

- ppmlhdfe is available in the intended Stata environment and its version is recorded.

### A_SETUP_SHP2DTA: Prepare shp2dta, which master.do requests and maps.do uses to build state geometry tables.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SHP2DTA
Evidence: E_MASTER_SETUP, E_MAP_SHAPE_1, E_ENV_ORIGINAL

Preparation / proposed procedure:

1. When software setup is permitted, follow the author-specified SSC command for shp2dta.
2. Record a typed availability/version check before running maps.do.

Validation to perform later:

- shp2dta is available in the intended Stata environment and its version is recorded.

### A_SETUP_PANDAS: Prepare or confirm pandas for the three registered Python notebook stages before those notebooks run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_PANDAS
Evidence: E_ENV_ORIGINAL, E_XML_PANDAS_IMPORT, E_LINKUP_WORDCOUNT_PANDAS, E_FIRM_EXPOSURE_PANDAS

Preparation / proposed procedure:

1. Through the approved environment setup process, confirm or prepare pandas in the intended Python 3.12 environment and record its exact distribution version and environment identity.
2. Keep the XML conversion, LinkUp word-count and annual firm-standard exposure stages in their documented workflow order; run them only after their input and execution prerequisites are separately authorized.

Validation to perform later:

- A typed environment record identifies pandas and its version in the intended Python environment; availability is not inferred from Python alone.

### A_SETUP_BEAUTIFULSOUP4: Prepare or confirm BeautifulSoup4 for the XML converter’s bs4.BeautifulSoup import.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_BEAUTIFULSOUP4
Evidence: E_ENV_ORIGINAL, E_XML_BS4_IMPORT

Preparation / proposed procedure:

1. Through the approved Python environment setup process, confirm or prepare the BeautifulSoup4 distribution in the intended Python 3.12 environment and record its exact version.
2. Retain the source-selected BeautifulSoup API and defer conversion until its input archive and execution prerequisites are authorized.

Validation to perform later:

- A typed environment record identifies BeautifulSoup4 and its version in the intended Python environment.

### A_SETUP_LXML: Prepare or confirm the lxml parser selected by the XML converter.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_LXML
Evidence: E_ENV_ORIGINAL, E_XML_BS4_IMPORT, E_XML_LXML_PARSER

Preparation / proposed procedure:

1. Through the approved Python environment setup process, confirm or prepare lxml for the intended Python 3.12 environment and record its exact version.
2. Preserve the notebook’s explicit lxml parser selection; defer conversion until package setup and source data are ready.

Validation to perform later:

- A typed environment record identifies lxml and its version in the intended Python environment, with the BeautifulSoup parser dependency documented.

### A_SETUP_PANDAS_XLSX_ENGINE: Resolve compatible pandas XLSX engine support for the LinkUp mapping and firm-standard keyword workbooks.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_PANDAS_XLSX_ENGINE
Evidence: E_ENV_ORIGINAL, E_LINKUP_WORDCOUNT_XLSX_READ, E_WORDCOUNT_DIRS, E_SEC_CONFIG

Preparation / proposed procedure:

1. Identify the actual engine supported by pandas for the source-named .xlsx files and record its distribution name and version; do not presume a particular engine.
2. If the intended Python environment lacks compatible support, prepare it through the approved environment setup process.
3. After the external workbooks are staged and notebook execution is separately authorized, validate the source-named mappings and main sheets through their registered read_excel stages.

Validation to perform later:

- A typed environment record identifies the compatible XLSX engine and version; workbook and sheet compatibility is recorded after upstream inputs are staged.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: Mandatory product-level branches remain to be reconciled across all raw reads and the 78 checklist IDs. Generated intermediates and their producers are reviewed separately from raw requirements.
- I_LINKUP_HANDOFF [unresolved; full_pipeline]: Visible LinkUp stages do not establish how XML output.csv becomes the word-count notebook input/*.csv and then the 76 intermediate/output/output_i.csv files consumed by Stata. An unregistered or manual stage may exist; its split/naming rules and path need confirmation.
- I_COMP_FUND_PANEL [unresolved; full_pipeline]: The author-prepared Compustat input expects NAICS and annual 1990–2020 records. The local raw source is readable and exposes NAICSH, but its mapping to the required NAICS field, full period coverage and prepared-panel construction remain unresolved.
- I_WINSOR2 [preparation; full_pipeline]: winsor2 is requested by the supplied Stata programs but the original environment probe reports it unavailable.
- I_SEC_COVERAGE [unresolved; full_pipeline]: Local SEC/LM directory roots exist, but compatible text files and year coverage were not inspected. EDGAR public indexes start at 1994Q3, leaving the author’s 1993 start and early 1994 route unresolved.
- I_SEC_WORDCOUNT_SERIES [preparation; full_pipeline]: Treatment code reads annual firm-standard word-count CSVs for 1993–2019. The manual notebook is configured for one year at a time; output placement and the complete year series need reconciliation.
- I_NSCG_FILE_STEMS [unresolved; full_pipeline]: README lists NSCG stems ecg17/ecg15/ecg13/ecg10/ecg03, while code imports epcg17/epcg15/epcg13/epcg10 and ecg03. The cited NSF listing confirms the five public-use years, not author-compatible SAS filename spelling or wave-specific required-field compatibility. Those checks remain unresolved; no claim is made that a particular field is absent.
- I_GLASSDOOR_STAGE [preparation; full_pipeline]: README identifies reviews_external_unc.csv as raw input; active analysis reads reviews_external_unc.dta and the source’s CSV import/save preparation is commented out. The conversion and exact input presence are unverified.
- I_LINKUP_CASE_PATH [preparation; full_pipeline]: master.do uses the same LinkUp header source with a different filename case (linkUp_header.do versus registered linkup_header.do). Align the include spelling to the registered path before a portable run; no operating-system failure was tested.
- I_OEWS_MAP_YEAR_RANGE [unresolved; full_pipeline]: maps.do reads OEWS workbooks for 1997–2019 but the subsequent append loop ends in 2018. The 2019 workbook is still read by the script, while its role in the final map series is unclear.
- I_SCOPE_CODE_COMPONENTS [preparation; full_pipeline]: These checklist edges are master.do source-to-source includes. The exact code branches and their order are source-proven members of full_pipeline, so they are preserved here as workflow components rather than converted into false raw-data requirements. D0070 has a separate portable case-alignment preparation.
- R_SEC_FILINGS [undetermined]: The firm-standard exposure stage requires SEC 10-K text organized in filing-year folders for 1993–2019.
- R_FASB_YEAR_TOTALS [undetermined]: The treatment builder requires the standards-by-year SAS dataset.
- R_COMP_FUNDAMENTALS [undetermined]: The treatment program requires annual firm fundamentals joined on CIK and fiscal year, including the named author-prepared panel and industry classification.
- R_CBP_2000 [public_acquisition_required]: The treatment and NSCG workflows require the 2000 state CBP source for employment and NAICS by state.
- R_NAICS_XWALK [undetermined]: The industry construction separately requires a 1997-to-2012 NAICS crosswalk.
- R_TFS_MICRODATA [undetermined]: The HERI student-major analysis requires both TFS DISAGG and DEMOGRAPHICS files, joined on SUBJID and YEAR before producing the merged panel.
- R_OEWS_STATE_FILES [public_acquisition_required]: OEWS employment and maps read annual state workbooks for 1997–2019; employment analysis appends 1997–2018 and maps reads a 2019 file before appending through 2018.
- R_LINKUP_ARCHIVE [undetermined]: The LinkUp pipeline needs the dated raw postings archive split into 16 CSVs.
- R_NSCG_MICRODATA [undetermined]: NSCG analyses require public-use survey waves for 2003, 2010, 2013, 2015 and 2017, with wave-specific occupation, location, weight and outcome fields.
- R_FASB_KEYWORD_SHARES [undetermined]: Industry and state treatment builders use the standard-level share-of-restrictive-words workbook.
- R_CBP_STATE_REGION_LOOKUPS [undetermined]: CBP and NSCG workflows require state-to-FIPS and state-to-NSCG-region lookup tables.
- R_OUTREACH_PROGRAMS [undetermined]: The HERI outreach cross-section uses a state-year workbook of accounting outreach program starts.
- R_GLASSDOOR_REVIEWS [undetermined]: The Glassdoor analysis requires the raw review CSV before its documented CSV-to-DTA preparation.
- R_REVELIO_POSITION_DATA [undetermined]: Revelio job-switch construction requires the occupation lookup bridge and individual position records.
- R_REVELIO_STATE_CODES [undetermined]: The Revelio branch maps source state names to abbreviations before matching generated state-year exposure.
- R_SURVEY_RESPONSES [undetermined]: The survey descriptive branch appends the two author-provided response CSVs.
- R_EXPERIMENT_RESPONSES [undetermined]: The experiment branch combines Prolific and Columbia response CSVs.
- R_MAP_SHAPEFILES [undetermined]: Map construction reads a U.S. state shapefile and uses shp2dta to build state geometry tables.
- R_SEC_KEYWORD_LIST [undetermined]: Manual firm-standard exposure preparation reads keyword_list.xlsx from its working directory.
- R_LINKUP_XML_DESCRIPTIONS [undetermined]: The manual LinkUp description converter requires the dated XML job-description archive. acct_supply_header.csv is generated by linkup_header.do and is tracked as a workflow producer.
- R_LINKUP_WORDCOUNT_DICTIONARY [undetermined]: The manual LinkUp word-count notebook requires the Atalay et al. dictionary workbook.
- SW_WINSOR2 [preparation_required]: Original typed probe reports winsor2 unavailable; the master requests it. No package was installed.
- SW_PPMLHDFE [unverified]: The master requests ppmlhdfe, but the original probe has no exact ppmlhdfe key; availability is unverified.
- SW_SHP2DTA [unverified]: The master requests shp2dta, but the original probe has no exact shp2dta key; availability is unverified.
- SW_PANDAS [unverified]: The registered XML conversion, LinkUp word-count and firm-standard exposure notebooks import pandas. The original typed environment confirms Python 3.12.14 but does not establish pandas availability or version.
- SW_BEAUTIFULSOUP4 [unverified]: The XML conversion notebook imports BeautifulSoup from bs4. The original typed environment confirms Python but does not establish the BeautifulSoup4 distribution or version.
- SW_LXML [unverified]: The XML conversion notebook calls BeautifulSoup(xml, 'lxml'). The original typed environment does not establish lxml parser availability or version.
- SW_PANDAS_XLSX_ENGINE [unverified]: The LinkUp word-count and firm-standard exposure notebooks read .xlsx workbooks with pandas.read_excel. A compatible engine is needed, but its identity and availability are not established by the original typed environment.

## Review notes

- Checkpoint 10 preflight: in full_pipeline, branch-specific actions cover all 21 data requirements, all 7 unresolved/preparation software capabilities and all 11 issues; the 78 dependency IDs remain uniquely classified.
- The package contains five readable aggregate identifier DTA files, not complete analysis panels; each supplied metadata probe sampled one row and marked coverage unverified. Full-pipeline scope remains necessary.
- The local COMP.FUNDA source is a live, readable raw component with the core fields tested. The separately named author-prepared DTA, NAICSH-to-NAICS meaning, full 1990–2020 period and prepared-panel construction remain specific unresolved items.
- Existing software statuses rely on exact keys from the original registered typed environment probe or remain unverified when those keys are absent. Pinned notebook views show pandas imports, a bs4.BeautifulSoup import, an explicit lxml parser call and .xlsx reads; these four capabilities are separately recorded as unverified. No package import, installation or runtime trial was performed.
- The first finalizer pair and captures are preserved. The next and only submission step for this correction is the authorized readonly finalizer call; its result will be preserved for coordinator QA.
- Generation 002 second-attempt correction: R_COMP_FUNDA_LOCAL is now unverified for the composite author-panel requirement because the readable raw source has NAICSH and the NAICS mapping is unresolved. Its core five fields are evidenced by one successful probe; separate successful AT and INDFMT probes remain independently cited, with no augmented probe or discarded evidence. The LinkUp header case difference is treated as supported portable setup preparation, not an unresolved scientific identity or an observed OS failure. No source patch was applied.
- Action coverage distinguishes the manually generated annual firm-standard word-count series (D0057/I_SEC_WORDCOUNT_SERIES) from the separately code-read FASB source files std_year.sas7bdat and share_keywords.xlsx. acct_supply_header.csv and other producer-linked files remain workflow intermediates, not raw input requirements.
- The README specifies notebook placement and workflow but does not name a notebook runner; no runner software is assumed or added.
- Public-route consistency review: NSF confirms the exact five public-use years but not author-compatible SAS stems or required per-wave schema, so the NSCG public route remains unverified for the complete analytic input while its year availability is credited. CBP 2000 source/vintage and 1997 NAICS are supported; field-label mapping and text staging remain preparation. BLS evidence supports OEWS source years 1997–2019; the maps 2019 read-versus-append role remains a separate issue.
