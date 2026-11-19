# Patch proposal: jar-e1e92956797e

Consequences for Culpable Auditors

DOI: 10.1111/1475-679X.12608

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied two-part Stata/SAS workflow for culpable- and comparison-auditor analyses, with the documented manual inputs, Revelio/Compustat/IPA handoffs, and real-estate companion scope. The code is embedded in a PDF; the supplied final program section stops after sorting the 200-person comparison sample.

Entry points: `KLMP Code.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 4/12608 - Consequences-for-Culpable-Auditors/klmp-datasheet-code-and-log-files.zip",
      "sha256": "f11fd91c294162a2d501315a5df1981c28a9d08dd0a440450fb2662356b8e9d4"
    },
    {
      "path": "JAR-Volume 63/Issue 4/12608 - Consequences-for-Culpable-Auditors/klmp-online-appendix.pdf",
      "sha256": "10fa3bc81127ab6957e4d01f3b71fdb0148b43f4ce209a92851168a3a0021fc1"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "b82f107db3be734590e50b104c564f0e7f24be251a0d53689c1c917bfa28bedf"
}
```

## Proposed actions

### ACTION_AAER_ACCESS: Obtain the author-specific Audit Analytics AAER respondent CSV or an author-approved licensed route and data dictionary.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_AAER_RESPONSE
Evidence: SRC_AAER_IMPORT, SRC_AAER_FIELDS, SRC_AUTHOR_DATA_SOURCE_SCOPE, PUB_AAER_DATASHEET

Preparation / proposed procedure:

1. Confirm the product, licensed delivery route, extraction date/version, and fields date, aaerreleaseno, and aaereventkey.
2. Keep the authors' 2003–2019 sample restriction and do not substitute an unverified public feed.

Validation to perform later:

- After an authorized file is obtained, compare its field names, date coverage, and row-level event keys to the source contract without running the author program.

### ACTION_AUTHOR_CULPABLE_INPUTS: Resolve the author-prepared workbook, partner-master, manual classification, and prior-snapshot contracts as a single versioned input set.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_SEC_KLMP, REQ_PCAOB_KLMP, REQ_KLMP_FINAL, REQ_PARTNER_MASTER, REQ_REMAINING_COMPANY_CLASSIFICATION, REQ_REMAINING_FINAL, REQ_TITLE_CROSSWALK, REQ_PRIOR_PARTB_FINAL, ISSUE_MISSING_CULPABLE_AUTHOR_INPUTS, ISSUE_MANUAL_CROSSWALKS, ISSUE_PRIOR_PARTB_SNAPSHOT
Evidence: SRC_SEC_KLMP_IMPORT, SRC_PCAOB_KLMP_IMPORT, SRC_KLMP_FINAL_IMPORT, SRC_PARTNER_MASTER_IMPORT, SRC_REMAINING_COMPANY_CONSUMER, SRC_REMAINING_FINAL_CONSUMER, SRC_TITLE_CLASSIFICATION_CONSUMER, SRC_PARTB_PRIOR_SNAPSHOT_NOTE, INV_ASSIGNED_PACKAGE

Preparation / proposed procedure:

1. Request the exact SEC.KLMP.xlsx, PCAOB.KLMP.xlsx, KLMP.xlsx, match partner list.dta, b.remaining/b.remaining_final, b.goodluck, and b.partb_final artifacts with their original dates and data dictionaries.
2. Clarify the producer and manual-review rules for each crosswalk, whether old b.partb_final must be used for paper tables, and the intended refresh/version rule.
3. Preserve filenames, workbook sheets, license restrictions, and hashes; do not reconstruct the manual classifications from public sources without an authorized specification.

Validation to perform later:

- When authorized artifacts are supplied, confirm sheet/table names and the consumed fields in the routes, then check join-key uniqueness and version consistency before any author execution.

### ACTION_REVELIO_PRODUCT: Resolve the exact Revelio product bundle, as-of dates, and author-side field mapping for the Position, User, and Education stages.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_REVELIO_POSITION, REQ_REVELIO_USER, REQ_EDUCATION_MATCHED
Evidence: SRC_REVELIO_POSITION_IMPORT, SRC_REVELIO_USER_CONSUMER, SRC_EDUCATION_IMPORT_SET, SRC_BACHELOR_DATE_CONSUMER, CATALOG_PRODUCT_FIELDS, PROBE_REVELIO_POSITION, PROBE_REVELIO_USER, PROBE_REVELIO_EDUCATION, PUB_REVELIO_DICTIONARY

Preparation / proposed procedure:

1. Ask for the exact author CSV bundle and product vintage that supplies company_name, title_raw, first/last name, and the matched bachelor_date output.
2. Clarify conversions from the local SAS product fields, including rcid/company-name mapping, name derivation, Education-to-bachelor_date logic, and the output split/match procedure.
3. Keep local catalog candidates as unresolved alternatives until every consumed field, coverage period, and producer role is documented.

Validation to perform later:

- For any approved local or vendor route, compare the full product schema and snapshot dates to the exact author fields and check representative historical coverage without executing the Stata/SAS program.

### ACTION_PART_A_AND_USER_SPLITS: Resolve the full part_a input and the distinct three-file User handoff before defining a Stata-to-SAS run order.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_PART_A_MASTER, REQ_REVELIO_USER_SPLITS, ISSUE_PART_A_PRODUCER, ISSUE_USER_SPLIT_PRODUCER
Evidence: SRC_PART_A_RELOAD, SRC_PART_A_USER_MERGE, SRC_PART_A_FIRST_SPLIT, SRC_PART_A_SECOND_SPLIT, SRC_SAS_PART_A_IMPORT_1, SRC_SAS_PART_A_IMPORT_2, SRC_USER_SPLIT_IMPORT_1, SRC_USER_SPLIT_IMPORT_2, SRC_USER_SPLIT_IMPORT_3, SRC_USER_SPLIT_ASSEMBLY

Preparation / proposed procedure:

1. Ask the authors to identify the producer and version of part_a.dta and document how user1.dta/user2.dta/user3.dta are created.
2. Map each generated filename to its exact Stata or SAS consumer and supply the original column definitions, partition boundaries, and file locations.
3. Keep the existing part_a_1/part_a_2 handoff distinct from the user1/user2/user3 inputs until the authors confirm their relationship.

Validation to perform later:

- After the producer contract is supplied, verify each named output exists in the authorized working tree and carries the consumer's required keys/fields before running any author program.

### ACTION_IPA100_LIST: Acquire the historical IPA100 input matching the authors' 2024 ipa_070424.dta file or obtain its exact author-approved route.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_IPA100
Evidence: SRC_IPA100_IMPORT, SRC_IPA100_CONSUMER, SRC_REVELIO_IPA_METHOD, PUB_IPA_LIST

Preparation / proposed procedure:

1. Confirm the exact 2024 list, firm_1 field preparation, and any title/company normalization from the authors.
2. Treat the public IPA page as a candidate route only; its current Excel offering does not establish the 2024 input file.

Validation to perform later:

- Check the acquired list's vintage, firm-name coverage, and firm_1 mapping before using it in any authorized program run.

### ACTION_COMPUSTAT_MATCH: Resolve the licensed Compustat inputs, fuzzy-match handoff, manual checks, and the author market_cap construction.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMPUSTAT_MATCHED_OUTPUT, REQ_COMPUSTAT_COMPANY_NAMES, REQ_COMPUSTAT_FIRM_YEAR, ISSUE_COMPUSTAT_MATCH_PRODUCER
Evidence: SRC_NOMATCH_HANDOFF, SRC_FUZZY_MATCH_STAGE_HEADER, SRC_FUZZY_MATCH_RESULT_IMPORT, SRC_FUZZY_MATCH_RESULT_JOIN, SRC_COMPUSTAT_CONSUMER, SRC_COMPUSTAT_JOIN_KEYS, SRC_AUTHOR_DATA_SOURCE_SCOPE, CATALOG_PRODUCT_FIELDS, PROBE_COMPUSTAT_COMPANY, PROBE_COMPUSTAT_FUNDA

Preparation / proposed procedure:

1. Request the exact Compustat COMPANY/FUNDA vintages, the author-generated funda_matched.dta and b.klmp products, and any manual match adjudication file.
2. Confirm the mapping from COMP.COMPANY.conm to the author name-match fields and from local FUNDA mkvalt/prcc_f/csho fields to author market_cap, gvkeyn, fyear, and tic.
3. Clarify match score thresholds and enforcement-year joins; do not infer or substitute a market-cap definition.

Validation to perform later:

- Before any execution, verify the full schema, vintage, unique gvkey-year coverage, the author mapping, and matched-file producer/consumer consistency.

### ACTION_EDUCATION_HANDOFF: Obtain the exact six education matched-file producers and bachelor_date definition used by the real-estate comparison.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_EDUCATION_MATCHED, ISSUE_EDUCATION_HANDOFF
Evidence: SRC_EDUCATION_FILE_IMPORT, SRC_EDUCATION_IMPORT_SET, SRC_BACHELOR_DATE_CONSUMER, CATALOG_PRODUCT_FIELDS, PROBE_REVELIO_EDUCATION

Preparation / proposed procedure:

1. Request the producer, matching keys, degree filters, date interpretation, and output schema for education1_1 through education3_2 matched files.
2. Resolve whether the local raw Education candidate is the author's source and how startdate/enddate/degree are transformed to bachelor_date.

Validation to perform later:

- Confirm all six named inputs, bachelor_date definition, and user_id coverage against the comparison sample before any author run.

### ACTION_REALESTATE_DATA_AND_CODE: Resolve the licensed manual real-estate records and the omitted transaction-analysis stage needed for the documented companion analysis.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_REALESTATE_TRANSACTIONS, ISSUE_REALESTATE_STAGE_GAP
Evidence: SRC_AUTHOR_DATA_SOURCE_SCOPE, SRC_MANUAL_PERSONAL_OUTCOME_SEARCH, SRC_MANUAL_TRANSACTION_WINDOW, SRC_REALESTATE_SAMPLE_METHOD, SRC_REALESTATE_CODE_END

Preparation / proposed procedure:

1. Ask for any author-held transaction/address-history tables, their data dictionary, selection keys, collection period, and permissible access route.
2. Clarify whether a separate transaction-analysis script or results file exists beyond the supplied final sort, and whether the 200-person comparison sample is the intended full extent of the code package.

Validation to perform later:

- If authorized files or code are supplied, verify sample links, three-year before/after dates, transaction fields, and the documented 200-person sample without running analysis code.

### ACTION_CODE_EXTRACTION_AND_PATHS: Prepare a working copy of the embedded Stata/SAS code and replace author-machine paths with coherent batch-mode roots before a separately authorized run.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_CODE_CONTAINER_AND_PATHS
Evidence: SRC_CODE_CONTAINER, SRC_SAS_HANDOFF, SRC_PART_A_RELOAD, SRC_SAS_PART_A_IMPORT_1

Preparation / proposed procedure:

1. Extract/reflow the PDF code into versioned working-copy files while preserving the original PDF and documenting the source line mapping.
2. Choose one working directory and consistent relative paths for each Stata/SAS producer-consumer handoff; keep absolute Dropbox paths out of executable configuration.
3. Preserve the original program design, samples, variable definitions, and manual inputs while resolving paths.

Validation to perform later:

- Review the proposed file map against every active import/export and library reference; verify each path resolves inside the approved working tree before any authorized execution.

### ACTION_SAS_SETUP: Confirm an authorized batch SAS environment and its Stata DTA import/export support using deployment documentation when available.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, ISSUE_SAS_RUNTIME_UNVERIFIED
Evidence: PROBE_ENVIRONMENT, SRC_SAS_HANDOFF, SRC_SAS_PART_A_IMPORT_1, SRC_USER_SPLIT_IMPORT_1

Preparation / proposed procedure:

1. Confirm SAS version, batch invocation, required DBMS=STATA engine, and the approved work-directory setup through documented host configuration.
2. Use no interactive startup, executable, version, or autoexec check in this feasibility assessment.

Validation to perform later:

- After the host setup is confirmed, verify only the documented SAS/DBMS capability and path configuration before a separately authorized author-code run.

### ACTION_NATIVE_RUN_SEQUENCE: Conditional native run sequence for the embedded Stata and SAS workflow, preserving the observed Stata-to-SAS, Stata Step 8, and return-to-SAS handoffs and pausing at the documented missing input and producer contracts.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ_AAER_RESPONSE, REQ_SEC_KLMP, REQ_PCAOB_KLMP, REQ_KLMP_FINAL, REQ_REVELIO_POSITION, REQ_REVELIO_USER, REQ_PART_A_MASTER, REQ_PARTNER_MASTER, REQ_IPA100, REQ_REVELIO_USER_SPLITS, REQ_EDUCATION_MATCHED, REQ_COMPUSTAT_MATCHED_OUTPUT, REQ_COMPUSTAT_COMPANY_NAMES, REQ_COMPUSTAT_FIRM_YEAR, REQ_REMAINING_COMPANY_CLASSIFICATION, REQ_REMAINING_FINAL, REQ_TITLE_CROSSWALK, REQ_PRIOR_PARTB_FINAL, REQ_REALESTATE_TRANSACTIONS, ISSUE_MISSING_CULPABLE_AUTHOR_INPUTS, ISSUE_PART_A_PRODUCER, ISSUE_USER_SPLIT_PRODUCER, ISSUE_EDUCATION_HANDOFF, ISSUE_COMPUSTAT_MATCH_PRODUCER, ISSUE_MANUAL_CROSSWALKS, ISSUE_PRIOR_PARTB_SNAPSHOT, ISSUE_CODE_CONTAINER_AND_PATHS, ISSUE_REALESTATE_STAGE_GAP, ISSUE_SAS_RUNTIME_UNVERIFIED
Evidence: SRC_CODE_CONTAINER, SRC_AAER_IMPORT, SRC_SEC_KLMP_IMPORT, SRC_PCAOB_KLMP_IMPORT, SRC_KLMP_FINAL_IMPORT, SRC_MODEL_SOFTWARE, SRC_REVELIO_POSITION_IMPORT, SRC_POSITION_MATCH_STAGE, SRC_PART_A_FIRST_SPLIT, SRC_PART_A_RELOAD, SRC_PART_A_SECOND_SPLIT, SRC_DEPARTING_USERS, SRC_DEPARTING_HISTORY_OUTPUT, SRC_REVELIO_USER_CONSUMER, SRC_PART_A_USER_MERGE, SRC_SAS_HANDOFF, SRC_SAS_PART_A_IMPORT_1, SRC_SAS_PART_A_IMPORT_2, SRC_SAS_PART_A_ASSEMBLY, SRC_PARTNER_MASTER_IMPORT, SRC_PARTNER_MATCH_KEYS, SRC_TURNOVER_WINDOW, SRC_IPA100_IMPORT, SRC_IPA100_CONSUMER, SRC_NOMATCH_HANDOFF, SRC_FUZZY_MATCH_STAGE_HEADER, SRC_FUZZY_MATCH_RESULT_IMPORT, SRC_FUZZY_MATCH_RESULT_JOIN, SRC_COMPUSTAT_CONSUMER, SRC_COMPUSTAT_JOIN_KEYS, SRC_REMAINING_COMPANY_PRODUCER_COMMENT, SRC_REMAINING_COMPANY_CONSUMER, SRC_REMAINING_FINAL_COMMENT_IMPORT, SRC_REMAINING_FINAL_CONSUMER, SRC_TITLE_CLASSIFICATION_COMMENT_IMPORT, SRC_TITLE_CLASSIFICATION_CONSUMER, SRC_PARTB_PRIOR_SNAPSHOT_NOTE, SRC_PARTB_PRIOR_SNAPSHOT_CONSUMER, SRC_USER_SPLIT_IMPORT_1, SRC_USER_SPLIT_IMPORT_2, SRC_USER_SPLIT_IMPORT_3, SRC_USER_SPLIT_ASSEMBLY, SRC_USER_SPLIT_MATCH, SRC_PARTC_KEYS_HANDOFF, SRC_EDUCATION_FILE_IMPORT, SRC_EDUCATION_IMPORT_SET, SRC_BACHELOR_DATE_CONSUMER, SRC_REALESTATE_CODE_END, SRC_MANUAL_PERSONAL_OUTCOME_SEARCH, SRC_MANUAL_TRANSACTION_WINDOW, SRC_REALESTATE_SAMPLE_METHOD

Preparation / proposed procedure:

1. Before any separately authorized run, reflow the PDF-embedded Stata and SAS sections into versioned working copies, map source lines, and configure coherent batch working roots and libraries. Confirm the SAS runtime and DBMS=STATA import setup; preserve the source statements and do not execute while required contracts remain unresolved.
2. Culpable-auditor Stata block: first resolve the AAER response extract, the SEC and PCAOB workbooks, the KLMP Final manual sheet, their dates, fields, and rights. Then run the supplied block in its source order through its eststo logit models and esttab output. Stop before this block if any required author-prepared input contract is absent.
3. Comparison-auditor Stata preparation: import and filter the Revelio Position inputs as supplied, preserve the user/employer/state/date/title fields, run the position-matching stage, and construct its m_/i_ intermediates and departing-user history outputs. Keep these products distinct from the full part_a master and the later SAS User split inputs.
4. At the full part_a gate, obtain the producer, version, schema, and working-tree location for part_a.dta. The source shows part_a_1.dta and part_a_2.dta being split from an existing full part_a and a later User merge using part_a.dta by user_id_new; do not infer the full producer from those consumers. Pause until that contract is supplied.
5. Once part_a.dta is confirmed, continue the supplied Stata sequence: create the two part_a partitions, then carry out the later User merge by user_id_new. Hand part_a_1.dta and part_a_2.dta to SAS as the code specifies; do not map them to the separate three-file User input branch without author confirmation.
6. Part 2 comparison-auditor SAS stage: after SAS batch/runtime and library setup, import both Stata partitions with DBMS=STATA and append them into a.part_a. Continue in source order using the author partner master and its documented state/title matching fields, the specified t-2 through t+1 turnover window, and the top-100 list joined by firm_1. Pause at any missing author master, list, runtime, or field contract.
7. At the SAS-to-Stata Step 8 handoff, form the documented a.test subset with company_name1, row_num, and enforcement_year for Compustat name matching. The source labels a Stata fuzzy-match stage and SAS later consumes funda_matched.dta, but the active producer, match thresholds, manual decisions, and output contract are unresolved. Do not run or infer that stage until those exact details are supplied.
8. After the Step 8 producer and output are confirmed, return to SAS: import funda_matched.dta, join the matched names by company_name1, then join the Compustat firm-year data by gvkey and enforcement year/fyear. Resolve the author market_cap construction and all consumed company/fundamentals fields before proceeding; do not substitute a definition or infer a match score.
9. Continue the SAS branch with the author-prepared b.remaining, b.remaining_final, and b.goodluck inputs consumed by active joins. The shown workbook-import blocks are commented; keep them inactive and obtain their separate producer/schema contracts. Confirm the old b.partb_final snapshot and intended refresh rule because the paper-table path reads it instead of the newly made a.partb_final.
10. For the later User and education branch, resolve the producer and schema for each of the three distinct SAS User imports before appending and matching by state/title. Preserve that branch separately from part_a_1/part_a_2. Then follow the supplied real-estate section: form its unique user_id key set, stack the six matched education tables, and join bachelor_date by user_id.
11. The supplied real-estate code proceeds to select the 200-person comparison controls and ends at a sort. Stop at that code endpoint unless the authors supply the transaction records and the omitted transaction-analysis stage, including its producer, keys, date window, and consumed fields; do not claim the companion transaction analysis is supplied or executed.

Validation to perform later:

- Before each authorized native stage, verify its exact source files, workbook sheets/tables, runtime, and all consumed fields/keys; stop at unresolved producer and version gates instead of inferring filenames or substituting another branch.
- After a separately authorized stage, check the documented handoffs and key continuity for part_a_1/part_a_2 to a.part_a, the SAS no-match subset to the Step 8 result and back to SAS, and the distinct User/education branch without changing the source analysis.
- Treat the final 200-person control selection and sort as the endpoint of the supplied real-estate code. Transaction analysis requires the missing transaction source and analysis-stage contract; this procedure asserts no execution outcome.


## Remaining issues and prerequisites

- ISSUE_MISSING_CULPABLE_AUTHOR_INPUTS [unresolved; full_pipeline]: The culpable-auditor program names the AAER response CSV and three manually prepared Excel workbooks. None is in the assigned package; their author-specific fields, versions, and rights need confirmation.
- ISSUE_PART_A_PRODUCER [unresolved; full_pipeline]: The Stata source splits an existing full part_a into part_a_1/part_a_2 and later merges User records using part_a.dta by user_id_new. The exact producer and version of the full part_a dataset remain unresolved.
- ISSUE_USER_SPLIT_PRODUCER [unresolved; full_pipeline]: The SAS source has three separate User import blocks, outputs them as a.partc_1/a.partc_2/a.partc_3, appends them, and matches by state/title. The supplied Stata evidence shows part_a_1/part_a_2 and m_/i_ position intermediates; their producer relation and exact schema remain unresolved.
- ISSUE_EDUCATION_HANDOFF [unresolved; full_pipeline]: SAS imports six education*_matched tables and consumes bachelor_date, while the local raw Revelio Education product has different fields. The code does not establish the matched-file producer, match inputs, or bachelor_date derivation.
- ISSUE_COMPUSTAT_MATCH_PRODUCER [unresolved; full_pipeline]: The source labels a Compustat fuzzy-match step and SAS consumes funda_matched.dta, but the exact match producer, score rules, and manual verification records are unresolved; screened code blocks are not used to infer them.
- ISSUE_MANUAL_CROSSWALKS [unresolved; full_pipeline]: The active SAS path joins b.remaining, b.remaining_final, and b.goodluck; the shown manual import/recoding blocks are commented, leaving the classifications as author-prepared inputs with no supplied producer artifact.
- ISSUE_PRIOR_PARTB_SNAPSHOT [unresolved; full_pipeline]: The supplied SAS comments say paper labor-market tables use old b.partb_final instead of the newly created a.partb_final, and the active analysis reads b.partb_final. The historical snapshot and intended refresh rule are unresolved.
- ISSUE_CODE_CONTAINER_AND_PATHS [preparation; full_pipeline]: The Stata/SAS code is embedded in a PDF and uses distinct file/library handoffs. Extract/reflow and coherent batch-root configuration are needed before any separately authorized run; no path literal is reproduced in the corrected excerpts.
- ISSUE_REALESTATE_STAGE_GAP [unresolved; full_pipeline]: The appendix and datasheet describe manual real-estate transaction collection and a 200-person comparison sample, but the supplied code ends after sorting the sample and does not include transaction-analysis code or a produced transaction file.
- ISSUE_SAS_RUNTIME_UNVERIFIED [unresolved; full_pipeline]: SAS availability/version and DBMS=STATA import support were not verified under the authorized checks; no SAS executable or startup was invoked.
- REQ_AAER_RESPONSE [undetermined]: Audit Analytics AAER respondent CSV used to establish the culpable-auditor enforcement-order/event counts. The supplied program consumes date, aaerreleaseno, and aaereventkey and filters 2003–2019.
- REQ_SEC_KLMP [undetermined]: Author-curated SEC AAER audit-related workbook sheet used for individual auditor, U.S., and PCAOB-registration counts. Its manual classification rules and workbook are not included.
- REQ_PCAOB_KLMP [undetermined]: Separate author-curated PCAOB enforcement workbook sheet used for year, case, release, and individual-order counts.
- REQ_KLMP_FINAL [undetermined]: Author-prepared Final sheet for culpable-auditor descriptive and model analyses, including enforcement status, auditor attributes, departures, penalties, and labor/personal outcomes. Exact complete schema requires the workbook.
- REQ_REVELIO_POSITION [undetermined]: Revelio Position CSV product used for U.S. comparison-auditor employment histories, employer/title matching, turnover, and subsequent-employer outcomes.
- REQ_REVELIO_USER [undetermined]: Revelio User CSV product used to derive user keys and match culpable auditors using U.S. location, names, sex, and profile URL.
- REQ_PART_A_MASTER [undetermined]: Full author-prepared part_a.dta employment/match dataset consumed by the Stata User merge and used to create the two SAS partitions. The program reloads it from an author-local path; its full producer and delivery are unresolved.
- REQ_PARTNER_MASTER [undetermined]: match partner list.dta is the SAS master file of sampled culpable auditors; comparison construction joins it to employment records by state and title class.
- REQ_IPA100 [undetermined]: The author imports ipa_070424.dta and joins the comparison sample to the firm_1 field for the 2024 IPA100 firm screen.
- REQ_REVELIO_USER_SPLITS [undetermined]: SAS imports three prepared user1/user2/user3 DTA splits and appends them before matching. The supplied Stata code creates different part_a_1/part_a_2 outputs; the producer of these user splits is unresolved.
- REQ_EDUCATION_MATCHED [undetermined]: The real-estate section imports six education*_matched DTA tables and uses user_id/bachelor_date to derive education timing. No matching producer is established in the supplied workflow.
- REQ_COMPUSTAT_MATCHED_OUTPUT [undetermined]: The SAS stage consumes Stata's funda_matched.dta to classify unmatched employer names and attach Compustat gvkey mappings; the exact matched-file producer remains unresolved.
- REQ_COMPUSTAT_COMPANY_NAMES [undetermined]: Compustat company names are a source product for the manual/fuzzy employer matching stage. The local COMPANY candidate offers gvkey/conm, but it is not the author's matched output and no matching/version mapping is supplied.
- REQ_COMPUSTAT_FIRM_YEAR [undetermined]: The author SAS library's Compustat firm-year table supplies gvkey, fyear, market_cap, and tic, joined on enforcement year. Compustat was a subscription source in the datasheet.
- REQ_REMAINING_COMPANY_CLASSIFICATION [undetermined]: Active SAS code consumes b.remaining with company_name1/accounting_firm for manually classifying unmatched employers. The shown import stub is commented and no workbook is included.
- REQ_REMAINING_FINAL [undetermined]: Active SAS code consumes b.remaining_final with company_name/accounting_firm_2. The manual Excel preparation/import lies inside a block comment; no completed crosswalk is included.
- REQ_TITLE_CROSSWALK [undetermined]: Active SAS code joins b.goodluck by title_raw1 and consumes partner, CEO/CFO/COO, other-chief, and board flags. The Excel production/import block is commented and the crosswalk is absent.
- REQ_PRIOR_PARTB_FINAL [undetermined]: The paper's comparison labor-market tables explicitly consume an older b.partb_final snapshot instead of the new a.partb_final output. The prior snapshot is not included.
- REQ_REALESTATE_TRANSACTIONS [undetermined]: The datasheet describes manually collected LexisNexis real-estate purchase/sale and cash-flow records. The supplied code stops after selecting/sorting a 200-person comparison sample and does not show a transaction analysis consumer.
- SW_SAS [unverified]: The comparison workflow requires SAS and PROC IMPORT DBMS=STATA support. The registered environment metadata projection did not verify SAS availability/version compatibility; no SAS executable, startup, version, or autoexec check was run.

## Review notes

- The frozen work item lists no dependency IDs; dependency_review is therefore empty. The code and datasheet were reviewed directly through the bounded source-screening helper; candidate blocks at KLMP Code.pdf cached lines 399 and 593 and appendix cached lines 338–345 were withheld and not quoted or used to infer their contents.
- The source-screening capture is process provenance only and is not cited in scientific evidence_ids. The bounded Revelio company-mapping probe timed out; its capture is retained but omitted from evidence_ids, not retried, and not used to claim a route. No unsuccessful probe or historical log is used as positive scientific evidence.
- Successful one-row product probes establish only readability and columns, not sample coverage, historical completeness, license, or full-file compatibility. Local Revelio/Compustat routes remain unverified where the author-consumed fields or transformation are not present.
- The assigned package contains source documents and historical logs only; the logs are not treated as current execution or software evidence. No author program was executed, imported, compiled, parsed, or statistically/descriptively trialed; no SAS executable/startup/version/autoexec was invoked; no data payload, connection, credential test, install, download, or outgoing message was attempted.
- Public routes were checked as static official documentation pages only. They establish product/source descriptions, not acquisition of any dataset or equivalence to the authors' curated files.
- The first pinned finalizer attempt exited with child return code 2; its exact run.json and raw stream captures remain under probes/controller_readonly_20261112T165253766649Z/run.json (manifest SHA256 888186f393cba69f203a477dc1f9dc7ccef0f74ca9bffcee60eefe41b0c2cc9d). The owned typed classifier output at historical artifact luna_package_314_finalizer_classification_20261113T0004.json (SHA256 081d4b824d980ee60277c46648b53383d764944f1166646bd507194d5db27db1) matched only the SW_STATA proof-key/name rule. The software.name values were corrected to the registered exact keys (Stata, eststo, esttab, SAS); the original environment and eststo probes were reused and no software probe was rerun.
- This cumulative correction replaces 17 source quotes that included author Windows home roots with exact screened source windows containing substantive product, field, or handoff logic; no roots were redacted inside a quote. The prior submitted input and output pair remain preserved in read-only generation copies. No author execution, import, compile, or software startup occurred.
- An initial source-window preflight stopped at the private-path guard for line 1515; its helper and separate capture are preserved. The corrected quote uses the separately screened 1517-1519 window.
