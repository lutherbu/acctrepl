# Patch proposal: jar-e5e35ca3ac13

How Does Judges’ Personal Exposure to Financial Fraud Affect White-Collar Sentencing?

DOI: 10.1111/1475-679X.12584

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented data preparation, manual reconciliation, supporting transformations, and supplied analysis workflow.

Entry points: `2. Fraud_universe_FU_data.do`, `2.1. Fraud_universe_FU_data_redating.do`, `FinancialDisclosure_clean_company_names_8.23.21_final.R`, `3. Financial_disclosure_FD_data.do`, `4. Courtlistener_CL_data.do`, `5. Comprehensive_data_merge_FD_CL.do`, `6. Comprehensive_data_clean.do`, `7. Match_judges_indirect_holdings_to_CRSP.do`, `7.1. Identifying_indirect_fraud_exposure_and_buysell_adjust.do`, `11. Short-term_market_reactions_for_fraud_events.do`, `8. Identifying_direct_fraud_exposure_and_buysell_adjust.do`, `9. Define_treatment_and_control_groups.do`, `10. Case_data_CD.do`, `12. Control_variables.do`, `12.1 Control_variables_continued.do`, `13. Prepare_data_for_tables.do`, `14. Create_tables.do`, `15. Untabulated_analyses_and_JAR_memo.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 2/12584 - How-Does-Judges-Personal-Exposure-to-Financial-Fraud-Affect-White-Collar-Sentencing/nrs-datasheet-code-and-identifier-files.zip",
      "sha256": "286e8b7ff29ab8fb21520a77207133ebfebe71e3b9a5edf912eb018a29660ee3"
    },
    {
      "path": "JAR-Volume 63/Issue 2/12584 - How-Does-Judges-Personal-Exposure-to-Financial-Fraud-Affect-White-Collar-Sentencing/nrs-in-principle-accepted-version.pdf",
      "sha256": "519d18d2efbe32f4cc6b7e19f4578a662f8b8a8e78f4369bb168a76da4d81085"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "c8e9d282a0673c6e09a2f2b1a0fcd2decb3198d8cf0dd51f8959ae20f00cf4b9"
}
```

## Proposed actions

### ACT_DATA_ROUTE_RECONCILIATION: For the remaining separately listed source families, identify the author-prepared file or a compatible permitted route; record exact key/field mapping, product, date coverage, vintage, conversion, and population before treating each route as usable.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_AAER, REQ_STANFORD, REQ_VIOLATION_TRACKER, REQ_REDATED_EVENTS, REQ_PFD_RAW, REQ_COMPUSTAT_ANNUAL, REQ_CALENDAR_RETURNS, REQ_CIVIL_CASES, REQ_CRIMINAL_CASES, REQ_CASE_PARTIES, REQ_COURTLISTENER_RECORDS, REQ_COURTLISTENER_LINKS, REQ_FJC_BIO, REQ_CRSP_DAILY, REQ_CRSP_MONTHLY_PRICE, REQ_CRSP_FUND_REFERENCE, REQ_CRSP_FUND_HOLDINGS, REQ_SP500_MEMBERSHIP, REQ_SP1500_CONSTITUENTS, REQ_RUSSELL_HOLDINGS, REQ_LM10X, REQ_SIC_CROSSWALK, REQ_LAW_SCHOOL_LIST, REQ_FUND_MATCHES, REQ_JUDGE_MATCHES, REQ_DEFENDANT_MATCHES, REQ_DISCLOSURE_COMP_MATCH, REQ_GVKEY_OVERRIDE_MAP, REQ_MUTUAL_FUND_FLAGS, REQ_RA_EYEBALL_LABELS, REQ_TEMP_GVKEY_UPDATE
Evidence: E_MANIFEST, E_SOURCES, E_CATALOG_CANDIDATES, E_CATALOG_FIELDS, E_FUNDA_CATALOG, E_CRSP_FUND_CATALOG, E_ROOT_METADATA, E_SEC_AAER, E_STANFORD_ACCESS, E_VIOLATION_TRACKER, E_FJC_EXPORT, E_COURTLISTENER_HELP, E_CPR_DOWNLOADS

Preparation / proposed procedure:

1. Match each remaining author-named input to an existing author-prepared deliverable or an underlying source product with an explicit field/key and date mapping.
2. For remaining local candidates, use only bounded one-row header/readability checks after the exact required fields are known; retain unverified outcomes and preserve existing captures.
3. Verify required history and population from source/provider documentation or an explicit author extract specification; a one-row sample or catalog count does not establish coverage.
4. Confirm access terms for the selected route; preserve unknown entitlements and do not substitute a narrower product for the paper input without a documented mapping.

Validation to perform later:

- Record the final selected route separately for each remaining requirement and retain exact fields, identifiers, units, coverage, and source dates.
- Keep route status unverified where product, history, keys, or conversion compatibility is unresolved.

### ACT_REDATED_EVENTS: Recover the author’s checked fraud-date handoff or its explicit row/key/date contract, then preserve the same event-selection and date-reconciliation decisions in downstream files.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_REDATED_HANDOFF, REQ_REDATED_EVENTS
Evidence: E_REDATE, E_REDATE_USE, E_MANIFEST

Preparation / proposed procedure:

1. Locate the author-prepared fraud_universe_new_date handoff, if available, and check its event identifiers and accepted-date fields against the supplied stages.
2. If it is unavailable, use only the author-described manual selection/re-date process and retain the original evidence and decision history; do not impute or introduce new event rules.

Validation to perform later:

- Confirm every downstream event key and date field used by Codes 7.1, 8, 11, and 12 is supplied or produced under the documented author process.

### ACT_R_MATCHING_HANDOFFS: Resolve the three separately identified Code 3 mapping/flag products and the two named R-stage RA/GVKEY updates; keep D0116–D0124 as a separate unresolved role/producer issue until their screened roles are established.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_R_MATCHING_HANDOFFS, REQ_DISCLOSURE_COMP_MATCH, REQ_GVKEY_OVERRIDE_MAP, REQ_MUTUAL_FUND_FLAGS, REQ_RA_EYEBALL_LABELS, REQ_TEMP_GVKEY_UPDATE
Evidence: E_WORKFLOW, E_R_PACKAGES, E_DEP_INVENTORY

Preparation / proposed procedure:

1. Map each R-stage file to its producer, fields, identifiers, and manual review step without treating a masked path as absent.
2. Use the author-prepared matching outputs if their keys and scope match the consuming R/Stata stage; otherwise request the exact author input specification and permitted access route.
3. Keep the source-name and Compustat key construction unchanged; do not add a new name normalization or matching threshold.

Validation to perform later:

- Confirm that the resulting output names/keys are exactly those consumed by Code 3 and preserve the author’s manual update file.

### ACT_PRODUCER_MACRO_SETUP: Resolve dynamic upstream file producers and configure the author path macros/working directory so every supplied program and its called helper can resolve authored inputs and outputs.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_UNKNOWN_PRODUCER, ISS_PATH_CONFIGURATION
Evidence: E_PATH_MACROS, E_WORKFLOW, E_DEP_INVENTORY, E_DEP_LINE_MAP

Preparation / proposed procedure:

1. Confirm the producer and required fields for the comprehensive judge list and macro-selected file_fd/fuzzy_match/union_database2 inputs.
2. Declare path, path_code, path_raw_data, and path_output from the actual project layout and preserve the authored Raw_data and Code_output directory distinction.
3. Confirm Code 5 can include the supplied 5.1 helper from the chosen working directory.

Validation to perform later:

- Check each configured path against the exact author input/output basename and confirm every macro-selected input has a documented producer before running that stage.

### ACT_STATA_SETUP: Prepare the missing Stata command dependencies required by the author workflow, and record versions/paths compatible with the supplied command syntax.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_OUTREG2, SW_RECLINK, SW_MATCHIT, SW_TSEGEN, SW_RANGEJOIN
Evidence: E_COMMAND_REFERENCES, E_STATA_OUTREG2, E_STATA_RECLINK, E_STATA_MATCHIT, E_STATA_TSEGEN, E_STATA_RANGEJOIN

Preparation / proposed procedure:

1. Install or configure the exact missing command names outreg2, reclink, matchit, tsegen, and rangejoin in the Stata 18 environment using their documented permitted sources.
2. Preserve the resolved ado-path and command versions for reproducibility.

Validation to perform later:

- Use frozen version/which metadata for the exact command names to confirm availability; do not execute the author programs as part of dependency setup.

### ACT_R_PACKAGE_SETUP: Prepare the five required R packages confirmed not installed in the queried active R 4.5.0 library paths; no packages were loaded during this review.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_READXL, SW_DPLYR, SW_STRINGR, SW_TIDYR, SW_RESHAPE2
Evidence: E_R_PACKAGES, E_ENV_PROBE, E_ENV_PROJECTION, E_R_DISTRIBUTION_METADATA

Preparation / proposed procedure:

1. Install the missing readxl, dplyr, stringr, tidyr, and reshape2 packages from their ordinary repositories in the intended R 4.5.0 active library.
2. Record package versions and the library path used for setup.

Validation to perform later:

- Confirm the exact installed DESCRIPTION metadata for all five package names in the intended active library path; do not load target packages or execute the author script as part of this verification.

### ACT_WORKFLOW_ORDER: Once inputs, handoffs, macros, and software are ready, follow the supplied stage order and validate each authored handoff before its consumers.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS_PATH_CONFIGURATION, ISS_DEPENDENCY_CLOSURE
Evidence: E_WORKFLOW, E_WORKFLOW2, E_REDATE, E_FUND_MATCH, E_CAR_PRODUCER, E_CAR_CONSUMER, E_CASE_MATCH

Preparation / proposed procedure:

1. Run R name cleaning before Code 3; run Codes 2 and 2.1 with the author re-date handoff; run Codes 3 and 4 before Code 5 and its included 5.1 helper, then Code 6.
2. Run Code 7 and complete the fund review before Code 7.1; run Code 11 to produce fraud_CARs before Code 8; run Code 9 before Code 10.
3. Run Codes 12 and 12.1 before Code 13, then Code 14 and Code 15 with the authored regression and untrimmed inputs.
4. Keep all supported author alternatives/robustness branches and authored sample/model definitions intact.

Validation to perform later:

- At each boundary, verify the expected file basename, identifiers, period, and author review state before the next consuming stage.
- Record output provenance and stage status without treating success as execution verification for this static assessment.

### ACT_FUND_MATCH_HANDOFF: Recover the author-checked fund identity crosswalk as a separate handoff and confirm its source/target keys and decisions before either exposure consumer uses it.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_FUND_MATCHES, ISS_FUND_MATCH_HANDOFF
Evidence: E_FUND_MATCH, E_FUNDHOLD_CONTRACT

Preparation / proposed procedure:

1. Locate fund_true_matches_final.csv or the author’s explicit match-key specification.
2. Retain only author-confirmed fund mappings and their decision history; do not substitute unreviewed candidates.

Validation to perform later:

- Check the checked fund map’s keys and match decisions against Code 7 candidates and both Code 7.1/8 consumers.

### ACT_JUDGE_MATCH_HANDOFF: Recover the checked judge-to-case crosswalk as its own handoff, preserving the author check flag and judge identifier mapping.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_JUDGE_MATCHES, ISS_JUDGE_MATCH_HANDOFF
Evidence: E_CASE_MATCH

Preparation / proposed procedure:

1. Locate judge_list_final_checked.xlsx and confirm judge_append_id/check fields and the target judge-name mapping.
2. Preserve the author’s check==1 selection and candidate ordering/review provenance.

Validation to perform later:

- Confirm the checked workbook maps the intended case-side judge identifiers into the supplied merge fields without changing the sample or fuzzy threshold.

### ACT_DEFENDANT_MATCH_HANDOFF: Recover the checked defendant party-name-to-GVKEY crosswalk separately from judge and fund mappings.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_DEFENDANT_MATCHES, ISS_DEFENDANT_MATCH_HANDOFF
Evidence: E_DEFENDANT_MATCH

Preparation / proposed procedure:

1. Locate the named checked party/GVKEY CSV and confirm its party-name key, GVKEY target, review date, and manual adjustment history.
2. Use only author-checked matches and preserve unmatched/ambiguous rows.

Validation to perform later:

- Confirm the checked-file key/target fields join to the generated candidate file and Code 12.1 outputs without forcing matches.

### ACT_LAW_SCHOOL_HANDOFF: Recover the separately required checked law-school reference list and its normalization/review history.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_LAW_SCHOOL_LIST, ISS_LAW_SCHOOL_HANDOFF
Evidence: E_LAW_SCHOOL

Preparation / proposed procedure:

1. Locate all_law_schools_manual_CHECKED.csv and verify its school field and author-approved normalized entries.
2. Preserve the authored duplicate-drop and downstream template merge.

Validation to perform later:

- Confirm the checked school key is consistent with the judge-school input before control construction.

### ACT_CCM_LINK_PREPARATION_V2: Use the field-compatible local CCM link-table source to prepare the author-named GVKEY/PERMNO handoff while preserving authored link rules and downstream keys.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_CCM_LINK
Evidence: E_CCM_LINK_RAW_PROBE, E_CAR_PRODUCER, E_CAR_CONSUMER, E_DEP_INVENTORY

Preparation / proposed procedure:

1. Use the readable local table and its gvkey, lpermno, linkdt, linkenddt, linktype, and linkprim fields for the author-named link-table handoff.
2. Preserve the authored LINKTYPE, LINKPRIM, date, and identifier filters and the authored export/rename to gvkey_permno_linktable.dta.
3. Before treating the handoff as complete, validate interval and key coverage over the author event/holdings period under the authored rules.

Validation to perform later:

- Confirm complete required link-interval coverage and resulting key population under authored filters; assess date edge handling, missing-link behavior, and vintage separately.

### ACT_DAILY_MARKET_INDEX_PREPARATION_V2: Map the readable daily DSIX market-return source into the existing Code 11 event-return contract while retaining the author's daily date alignment and keeping stock and monthly products separate.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_CRSP_MARKET_INDEX
Evidence: E_CRSP_DAILY_MARKET_PROBE, E_CRSP_MONTHLY_MARKET_PROBE, E_CAR_PRODUCER, E_CAR_CONSUMER, E_DEP_INVENTORY

Preparation / proposed procedure:

1. Use CRSP.DSIX CALDT and VWRETD for the daily market-return component named in the Code 11 workflow trace.
2. Preserve the author's daily date alignment, event windows, and transformations when mapping the source into the existing market-return input.
3. Keep the stock-price/return route and the monthly MSIX observation as separate products; do not substitute monthly returns for the daily event-return input.
4. Validate the author-period daily date and nonmissing-value coverage before treating the prepared market series as complete.

Validation to perform later:

- Confirm required daily VWRETD observations across author event dates in 1990-2022 under authored alignment; the one-row result establishes local readability and field presence only.


## Remaining issues and prerequisites

- ISS_REDATED_HANDOFF [unresolved; full_pipeline]: Code 2.1 prepares a manual re-date review, but the downstream fraud_universe_new_date handoff has no verified producer, row/key mapping, accepted-date record, or availability. Preserve author date selection and all downstream construction.
- ISS_R_MATCHING_HANDOFFS [unresolved; full_pipeline]: The screened R-stage evidence names multiple Capital IQ/RA products, but the exact roles of the likely/unlikely/unsure/matched/update/cleaning files cannot be established from the retained path-masked view. Their producer, alias/partition relationships, consumed keys, and generated-versus-manual status remain unresolved; do not treat all as independent raw inputs or absent files.
- ISS_UNKNOWN_PRODUCER [unresolved; full_pipeline]: The comprehensive judge-list and macro-selected inputs do not have a fully evidenced producer/field contract in the screened source review. Resolve exact upstream file names and keys before the dependent stage; do not treat dynamic names as absent.
- ISS_PATH_CONFIGURATION [preparation; full_pipeline]: Supplied programs require path/path_code/path_raw_data/path_output macros and a working directory compatible with their relative Raw_data/Code_output references, including the called 5.1 helper. Actual values were not inferred from protected configuration material.
- ISS_DEPENDENCY_CLOSURE [unresolved; full_pipeline]: Required source families, author handoffs, generated producers, and compatible history/field routes remain unresolved; the full author pipeline is not closed.
- ISS_FUND_MATCH_HANDOFF [unresolved; full_pipeline]: The checked fund_true_matches_final.csv file is a separate fund-identity handoff. Its required keys, match decisions, and local availability remain unresolved; fuzzy candidates are not accepted matches.
- ISS_JUDGE_MATCH_HANDOFF [unresolved; full_pipeline]: The judge_list_final_checked.xlsx workbook is a separate judge-to-case handoff. Candidate/check keys are documented, but workbook availability, complete name mapping, and reviewer decisions remain unresolved.
- ISS_DEFENDANT_MATCH_HANDOFF [unresolved; full_pipeline]: The checked party-name-to-GVKEY file is a separate defendant handoff. The candidate-side party_name_1 key is visible, but checked-file keys, decisions, and availability remain unresolved.
- ISS_LAW_SCHOOL_HANDOFF [unresolved; full_pipeline]: The manually checked law-school file is a distinct school-reference product already represented by REQ_LAW_SCHOOL_LIST; its checked rows and normalization history remain unresolved.
- REQ_AAER [undetermined]: Fraud-event construction uses distinct AAER annual/quarterly/detail, announcement, and crawler source families; row identifiers, event-date mapping, coverage, and release history remain open.
- REQ_STANFORD [undetermined]: Fraud-universe construction joins the 2016 Stanford GSB workbook and author-named 2021 HBS dataset; record linkage keys, population, and date coverage are not yet established.
- REQ_VIOLATION_TRACKER [undetermined]: The fraud-event stage consumes an author-named Violation Tracker basic CSV with manual date reconciliation; exact version, filters, fields, and historical coverage remain open.
- REQ_REDATED_EVENTS [undetermined]: An author/manual fraud-date handoff is consumed downstream as fraud_universe_new_date; the package inventory does not include that materialized handoff.
- REQ_PFD_RAW [undetermined]: The supplied R/Stata chain requires judges’ Personal Financial Disclosure transaction data; original fields, court coverage, and author collection vintage must be checked.
- REQ_COMPUSTAT_ANNUAL [undetermined]: Compustat annual fundamentals are consumed across fraud linking, defendant matching, and firm controls; the author-named 1995–2020 panel and fields must be matched to any local source.
- REQ_CALENDAR_RETURNS [undetermined]: The control stage separately consumes a Compustat calendar-year returns file; its underlying fields, transformation, and coverage are not specified by the bounded inspection.
- REQ_CIVIL_CASES [undetermined]: The civil-case branch consumes docket/judgment source files and constructs case outcomes; exact case population, judge keys, outcome fields, and author extract dates remain unknown.
- REQ_CRIMINAL_CASES [undetermined]: The criminal-case branch consumes criminal docket/judgment files and constructs outcomes; population, person/organization coverage, and outcome-field history must be confirmed.
- REQ_CASE_PARTIES [undetermined]: Civil/criminal party and attorney rows are consumed by the control construction; party-to-case and party-to-company keys, periods, and source provenance need confirmation.
- REQ_COURTLISTENER_RECORDS [undetermined]: CourtListener judge financial-disclosure rows are processed before being combined with PFD holdings; exact snapshot dates, fields, and identifier linkage remain unknown.
- REQ_COURTLISTENER_LINKS [undetermined]: The CourtListener stage also consumes an author-named disclosure-to-Compustat mapping workbook; its join keys, firm coverage, and review history are unknown.
- REQ_FJC_BIO [undetermined]: Judge biographical, education, appointment, and term variables feed judge controls and crosswalks; author field mappings and historical population remain unverified.
- REQ_CRSP_DAILY [undetermined]: Daily CRSP security returns/prices feed event returns and annualized firm controls; exact product, identifiers, units, and 1990–2022 coverage must be verified.
- REQ_CRSP_MONTHLY_PRICE [undetermined]: Indirect exposure construction consumes a monthly price/Compustat identifier panel to price fund positions; keys, unit scaling, and 1998–2020 coverage remain unverified.
- REQ_CRSP_FUND_REFERENCE [undetermined]: The mutual-fund matching stage needs a CRSP fund-name/reference source in addition to author-reviewed match candidates; exact product, fields, and period are unresolved.
- REQ_CRSP_FUND_HOLDINGS [undetermined]: Indirect exposure uses six mutual-fund holdings files spanning author-named periods 2001–2022 and deduplicates by CRSP portfolio/year/security and report date.
- REQ_SP500_MEMBERSHIP [undetermined]: S&P 500 membership data are used to derive year-start/year-end membership intervals; source vintage and historical coverage remain open.
- REQ_SP1500_CONSTITUENTS [undetermined]: S&P Composite 1500 membership controls use a constituent CSV keyed by GVKEY and effective date; index naming and historic coverage remain open.
- REQ_RUSSELL_HOLDINGS [undetermined]: Russell holdings membership is merged by CUSIP and year and filtered to Russell 1000 status; identifier and annual coverage remain open.
- REQ_LM10X [undetermined]: Firm headquarters controls use Loughran–McDonald 10-X-derived CIK/state/year data; the documented local root metadata does not establish the author aggregate or coverage.
- REQ_SIC_CROSSWALK [undetermined]: Industry expertise controls use a SIC range workbook with sic_start/sic_end mapping; workbook provenance and categories are not verified.
- REQ_LAW_SCHOOL_LIST [undetermined]: Judge school controls use a manually checked law-school reference list; exact rows, identifier normalization, and edit history remain unknown.
- REQ_FUND_MATCHES [undetermined]: Code 7 exports fund-match candidates and Code 7.1/8 consume the separately checked fund_true_matches_final.csv. The fund universe is distinct from judge-name and defendant-company matching; checked columns, join keys, human dispositions, row history, and availability remain unknown.
- REQ_JUDGE_MATCHES [undetermined]: Code 10 uses a manually checked judge-to-case crosswalk after fuzzy judge-name candidate generation. The supported candidate/check keys are judge_append_id and check; the checked workbook’s exact target-name mapping, field types, date history, and availability remain unresolved.
- REQ_DEFENDANT_MATCHES [undetermined]: Code 12.1 separately links case party names to Compustat GVKEYs after fuzzy candidate generation. The supported candidate-side name key is party_name_1; the checked-file column spelling/types, exact firm key mapping, manual decisions, and availability remain unresolved.
- REQ_DISCLOSURE_COMP_MATCH [undetermined]: Code 3 consumes the author-named potential disclosure-to-Compustat match workbook as a separate PFD company-linking product. Whether it contains candidates or accepted matches, and its source/target fields and review history, remain unverified.
- REQ_GVKEY_OVERRIDE_MAP [undetermined]: Code 3 consumes an author-named updated all-GVKEY mapping file as a separate identity-update product. Its keys, edit provenance, field spelling, period, and availability remain unresolved.
- REQ_MUTUAL_FUND_FLAGS [undetermined]: Code 3 consumes a separate GVKEY mutual-fund flag file used to distinguish fund holdings from other disclosure positions. The flag encoding, key integrity, vintage, and availability remain unverified.
- REQ_RA_EYEBALL_LABELS [undetermined]: The R-stage chain references a specifically named RA eyeball-label product as a distinct review handoff. Its exact label/key fields, population, producer, and availability remain unknown.
- REQ_TEMP_GVKEY_UPDATE [undetermined]: The R-stage chain separately references temp_gvkey_update.xlsx for manual GVKEY updates. Its keys, changed values, provenance, temporal scope, and availability remain unresolved.
- SW_READXL [preparation_required]: Required by the supplied R name-cleaning program; coordinator’s exact DESCRIPTION-only metadata check reports readxl not installed in the queried active R 4.5.0 library paths. No package was loaded.
- SW_DPLYR [preparation_required]: Required by the supplied R name-cleaning program; coordinator’s exact DESCRIPTION-only metadata check reports dplyr not installed in the queried active R 4.5.0 library paths. No package was loaded.
- SW_STRINGR [preparation_required]: Required by the supplied R name-cleaning program; coordinator’s exact DESCRIPTION-only metadata check reports stringr not installed in the queried active R 4.5.0 library paths. No package was loaded.
- SW_TIDYR [preparation_required]: Required by the supplied R name-cleaning program; coordinator’s exact DESCRIPTION-only metadata check reports tidyr not installed in the queried active R 4.5.0 library paths. No package was loaded.
- SW_RESHAPE2 [preparation_required]: Required by the supplied R name-cleaning program; coordinator’s exact DESCRIPTION-only metadata check reports reshape2 not installed in the queried active R 4.5.0 library paths. No package was loaded.
- SW_OUTREG2 [preparation_required]: Author code invokes the exact Stata command name outreg2; the frozen version/which metadata reports not installed on the checked path. No author program was run.
- SW_RECLINK [preparation_required]: Author code invokes the exact Stata command name reclink; the frozen version/which metadata reports not installed on the checked path. No author program was run.
- SW_MATCHIT [preparation_required]: Author code invokes the exact Stata command name matchit; the frozen version/which metadata reports not installed on the checked path. No author program was run.
- SW_TSEGEN [preparation_required]: Author code invokes the exact Stata command name tsegen; the frozen version/which metadata reports not installed on the checked path. No author program was run.
- SW_RANGEJOIN [preparation_required]: Author code invokes the exact Stata command name rangejoin; the frozen version/which metadata reports not installed on the checked path. No author program was run.

## Review notes

- Static execution-feasibility assessment only; no author source code or data/model execution was performed.
- Fund, judge, defendant, law-school, disclosure-to-Compustat, author GVKEY override, mutual-fund flag, RA eyeball, and temporary GVKEY update products are represented as distinct contracts where the retained evidence identifies distinct products. Masked R-file roles remain linked issues.
- All 129 frozen checklist IDs remain covered exactly once. Generated and optional stages retain their prior evidence and dispositions; manual decisions are not invented.
- Five R packages are confirmed not installed in the queried active R 4.5.0 library paths by DESCRIPTION metadata only. This is ordinary setup preparation; no package was loaded and no license barrier is inferred.
- The full native workflow, Code 11 CAR production before Code 8 direct exposure, Code 5.1 helper, Code 12 template producer, authored filters, and unresolved source branches remain in the trace.
- Bounded one-row results support readable, field-compatible local routes for the CCM link fields and daily DSIX market-return fields. Complete link history, authored link filters, event-date/nonmissing market coverage, combined-panel construction, and vintage remain unverified. The monthly MSIX result is recorded independently and is not used as a substitute; the retained workflow identifies a daily market-return consumer only.
