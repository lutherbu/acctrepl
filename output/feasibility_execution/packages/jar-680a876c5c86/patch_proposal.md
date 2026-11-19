# Patch proposal: jar-680a876c5c86

Asset-Level Transparency and the (E)valuation of Asset-Backed Securities

DOI: 10.1111/1475-679X.12389

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-supplied SAS EDGAR log preparation and Stata deal/default, loan-risk, regression/figure, and SEC-download-count workflow.

Entry points: `ABS EDGAR download code.sas`, `Data preparation and analysis code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 3/12389 - Asset-Level-Transparency-and-the-E-valuation-of-Asset-Backed-Securities/nrwx-datasheet-code-and-identifiers.zip",
      "sha256": "190d0b6c8a1d237d915862d930ad01c0e47ce79434efc69e52323b83c7adb0fc"
    },
    {
      "path": "JAR-Volume 60/Issue 3/12389 - Asset-Level-Transparency-and-the-E-valuation-of-Asset-Backed-Securities/nrwx-online-appendix.pdf",
      "sha256": "788f389d5fcd4d02b0250f577193f88e921c083bcec229944a9baacddc37e743"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "dd93b247f48cd77ca95e24a199cb5632aa8a4f2920898d351abd9e0d6c18b00c"
}
```

## Proposed actions

### ACT_BLOOMBERG_DATA: Confirm the June 2019 Bloomberg ABS sample export or a compatible author-prepared tranche/deal table. Identify exact licensed content and deliverable for the Stata input fields; current general Data License information does not establish that specific product, field coverage, or entitlement.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_BLOOMBERG_DEAL
Evidence: E_DATASHEET_DEAL_DEFAULT, E_BLOOMBERG_PUBLIC, E_CATALOG, E_CATALOG_LOOKUPS, E_STATA_DEAL_FIELDS

Preparation / proposed procedure:

1. Obtain the author-prepared table or confirm Bloomberg ABS product, release/vintage, sample population, field names, units, and permitted access for the required tranche/deal variables.
2. Keep the source fields for deal/tranche names, ratings, coupon type/rate, principal amount, weighted-average life, security type, issue date, issuer, and rf/flt_spread inputs aligned with the do-file.

Validation to perform later:

- Before author-code execution, confirm field mapping, sample-period coverage, unique deal/tranche keys, and source entitlement without changing the paper sample or formulas.

### ACT_MOODY_DATA: Identify the exact Moody's ABS database vintage and monthly author input used for principal balances and cumulative write-offs; confirm the native-to-Stata field mapping and history needed by the +183-day measure.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_MOODY_DEFAULT
Evidence: E_DATASHEET_DEAL_DEFAULT, E_MOODY_PUBLIC, E_CATALOG, E_CATALOG_LOOKUPS, E_STATA_DEFAULT_INPUTS, E_STATA_DEFAULT_WINDOW, E_STATA_CC_DEFAULT

Preparation / proposed procedure:

1. Provide the monthly source table or document the Moody's product/release, sample deal universe, date units, and source columns mapped to mtg_deal_name, date/t, losses, balances, and credit-card charge-off/pool-balance fields.
2. Specify the available history for each deal from origination through the monthly observation nearest issue_date + 183 days; preserve the code's cumulative construction and nearest-date rule.

Validation to perform later:

- Check the source periods, deal identifiers, units, non-credit-card and credit-card branches, and the constructed nearest-date observation against the supplied specification before running Stata.

### ACT_SEC_10D_FALLBACK: For observations missing from the Moody's source, provide the author-used Form 10-D filings or extracted values with a mapping from issuer filing/accession to the affected deal, month, and missing variable.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_SEC_10D_FALLBACK
Evidence: E_DATASHEET_DEAL_DEFAULT, E_SEC_FILINGS_SEARCH

Preparation / proposed procedure:

1. Obtain the author missingness list and exact 10-D filing/accession references for the values filled from EDGAR.
2. Retain the source filing and documented extraction fields for each missing principal-balance or cumulative-write-off observation; do not assume Form 10-D prose alone reproduces the monthly panel.

Validation to perform later:

- Reconcile only the reported missing observations and confirm the extracted values, dates, identifiers, and units against the author-provided monthly input.

### ACT_ABSEE_SCHEMA: Provide the author-prepared 108-deal ABS-EE loan table or the exact filing list, extractor, and source-field mapping that produced the Stata loan-level columns.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SEC_ABSEE
Evidence: E_STATA_ABSEE_FIELDS, E_STATA_ACTPAY_DEF, E_STATA_LAYER_THRESHOLDS, E_SEC_FILINGS_SEARCH

Preparation / proposed procedure:

1. Identify the 108 deals and their ABS-EE filing/accession documents, date/vintage coverage, loan-row unit, and any author extraction program or manual steps.
2. Map source filing fields to the Stata columns for balances, FICO, loan amount/vehicle value/acquisition cost, actual/scheduled payments, payment-to-income, and income/employment verification; preserve the authored caps, constants, and thresholds.

Validation to perform later:

- Confirm all required source fields and deal identifiers against the author table before the risk-layer block; do not infer mappings from filing document titles or the SEC access logs.

### ACT_SEC_LOGS: Acquire only the official historical daily EDGAR log files named by the supplied SAS SET list and prepare them for the documented CSV-to-SAS import flow, retaining the unresolved author member name.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_SEC_LOGS
Evidence: E_SAS_SOURCE_STEPS, E_SAS_NAME_FILTER_FIELDS, E_SAS_NAME_FILTER_IMPORT, E_SAS_LOG_IMPORT, E_SAS_SET_START, E_SAS_INVALID_MEMBER, E_SAS_SET_END, E_SEC_LOG_PAGE, E_SEC_LOG_VARS, E_SEC_LOG_2017_LIST

Preparation / proposed procedure:

1. Use the SEC historical log list for the code's 2016-11-16 through 2017-06-30 period; download only the required source payloads during a later authorized acquisition step.
2. Create the documented three-column name_filter CSV from the selected log members and chosen libnames/destlib values, then import it as abssas.name_filter; this is generated configuration for the daily logs, not a separate empirical input.
3. Map CSV fields ip/date/time/cik/accession into the SAS import table and retain SEC's data-quality caveats.
4. Keep log20170229 and the code's omission of April 29-30 unchanged until the author confirms any member/file mapping; do not delete, replace, or extend dates based on filenames alone.

Validation to perform later:

- Before processing, document the exact source filename to each SAS member mapping and check the imported fields/period against the author list; do not treat the SEC dataset as filing text or as local LM/exhibit documents.

### ACT_SEC_INDEX: Build the period-matched SAS filings table from the official SEC quarterly master indexes and apply the author's filename-to-accession derivation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_SEC_INDEX
Evidence: E_SAS_SOURCE_STEPS, E_SAS_INDEX_ACCESSION, E_SAS_LOG_TRANSFORM, E_SEC_INDEX_FIELDS, E_SEC_INDEX_2016Q4, E_SEC_INDEX_2017Q1, E_SEC_INDEX_2017Q2

Preparation / proposed procedure:

1. Acquire the SEC master.idx files covering the relevant quarter range and parse company name, form type, CIK, date filed, and file path into the SAS columns expected by the source.
2. Apply the supplied accession extraction from filename and save the SAS table as abssas.filings.

Validation to perform later:

- Confirm the parsed CIK/formtype/date/filename and accession columns and verify period coverage for the supplied log join and filing-date lookup before executing the author macro.

### ACT_NAME_FILTER_SETUP: Create the author-described name_filter control table from selected daily-log members and host library names; it is generated SAS setup, not an independent research-data requirement.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: R_SEC_LOGS
Evidence: E_SAS_NAME_FILTER_FIELDS, E_SAS_NAME_FILTER_IMPORT, E_SAS_LOG_IMPORT, E_SAS_LOG_TRANSFORM, E_SAS_SET_START, E_SAS_SET_END

Preparation / proposed procedure:

1. Create the Step 3 CSV with the specified member/libname/destlib columns for the actual daily-log members and chosen SAS libraries, then import it as abssas.name_filter.
2. Retain the literal SET list and resolve the log20170229 source/member mapping through the separate unresolved issue before any run.

Validation to perform later:

- Check that each selected member maps to the intended source CSV and destination SAS library; the configuration rows do not establish that the log payloads are available or change the sample.

### ACT_ACCESSION_MAP: Provide the author hand-collected abs_cik table or a deal-by-deal mapping to the first prospectus, second prospectus, and ABS-EE accession numbers used by SAS, using the supplied final-sample deal/tranche names as the lookup reference.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ACCESSION_MAP
Evidence: E_SAS_MANUAL_MAP, E_SAS_MAP_JOIN, E_SEC_FILINGS_SEARCH, E_DATASHEET_IDENTIFIERS, E_IDENTIFIER_PROBE

Preparation / proposed procedure:

1. Use the packaged final-sample identifier workbook as the deal/tranche lookup; separately map each treatment deal to CIK, pros1_acc, pros2_acc, abs_acc, and auto_ind using the authors' intended filing selection and SEC index records.
2. The workbook does not itself provide or prove completeness of the hand-collected accession mapping.
3. Preserve the supplied SAS joins and +60-day windows; do not substitute the separate All_abs2017_win table for the Stata consumer.

Validation to perform later:

- Check the manual mapping keys and returned p1filedate/p2filedate/absfiledate against the author accession table before the filtering step.

### ACT_STATA_INPUT_STATE: Obtain the author loading/reset sequence and source/schema contracts for the tranche, non-credit-card monthly, credit-card monthly, and ABS-EE loan datasets expected in Stata memory.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_STATA_INPUT_STATE
Evidence: E_STATA_DEAL_FIELDS, E_STATA_DEFAULT_INPUTS, E_STATA_CC_DEFAULT, E_STATA_ABSEE_FIELDS

Preparation / proposed procedure:

1. Identify each source file, current working directory, import or manual loading command, and exact point at which the dataset in memory changes between the supplied blocks.
2. Provide identifiers, date/time units, required history, and all native columns after author import/renaming.

Validation to perform later:

- Before running the do-file, trace each input table to its intended producer and confirm the table in memory at each block boundary without changing the sample or formulas.

### ACT_STATA_FIELDS: Confirm where type, series, period, and cluster are created and how they should be carried through the deal-level keep; do not guess a synonym or silently add an undefined definition.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_STATA_FIELDS
Evidence: E_STATA_DEAL_KEEP, E_STATA_TYPE_USE, E_STATA_SERIES, E_STATA_PERIOD, E_STATA_CLUSTER

Preparation / proposed procedure:

1. Supply the source/derived-variable definitions, sample units, and intended retained fields for type, series, period, and cluster.
2. Only after that contract is confirmed, preserve those fields in the correct loading/keep boundary without altering the estimators or authors' period categories.

Validation to perform later:

- Check that each cited variable is present in the correct table before its first use and that unique name resolution is unambiguous.

### ACT_ACTPAY_KEEP: Retain actpay_miss in the control-table keep so the subsequent authored 0.829676 replacement can read the flag.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_ACTPAY_MISS
Evidence: E_STATA_ACTPAY_DEF, E_STATA_CONTROL_KEEP

**Proposed edit:** `Data preparation and analysis code.do:212–212`
Source SHA-256: `5c29dfd8181d38c0fa353a6f8a47b69641abaa1b8066271bc4db9c33b9ba8282`

actpay_miss is created for the three named deals and referenced immediately after the keep; retaining it makes the existing authored condition available without changing its constant or formula.

Current text:
```
keep mtg_deal_name fico_vw ltv_vw ats_vw p2i_vw low_doc_vw 
```

Proposed replacement:
```
keep mtg_deal_name fico_vw ltv_vw ats_vw p2i_vw low_doc_vw actpay_miss
```

Preparation / proposed procedure:

1. Apply this proposal only in a working copy after review; the original source bytes are not changed by this assessment.

Validation to perform later:

- On a later authorized Stata run, confirm the variable survives the keep and the replacement condition executes for the three authored deals; compare all other retained fields and formulas unchanged.

### ACT_SAS_SORT_ORDER: Ask the authors whether line 398 intentionally reads an existing All_abs2017 table or whether it depends on an earlier state omitted from the supplied SAS file; retain the written line and apr11 output until resolved.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SAS_SORT_ORDER
Evidence: E_SAS_SORT_ORDER

Preparation / proposed procedure:

1. Provide the original table source/order for str.All_abs2017 at the sort call and explain whether All_abs2017_apr11 is an intended deliverable or unused output.
2. Keep the later All_abs2017 producer and Stata's raw-table consumer distinct.

Validation to perform later:

- Verify producer order and table identity from the author-supplied source before any SAS run; do not reorder or remove the sort based only on this static review.

### ACT_SAS_LOG_NAME: Confirm the author-side source/member mapping for log20170229. Keep the literal SAS SET list and April 29-30 omission intact until supported mapping is supplied.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SAS_LOG_NAME
Evidence: E_SAS_INVALID_MEMBER, E_SEC_LOG_2017_LIST

Preparation / proposed procedure:

1. Request the original source archive/list and the intended SAS member corresponding to the literal log20170229 entry.
2. Do not delete the entry, replace it with a neighboring date, or append dates that the source omits.

Validation to perform later:

- Reconcile all supplied SET members to the author list after confirmation; report any unresolved member explicitly before executing the SAS program.

### ACT_SAS_STATA_PATHS: Configure one host-visible staging location and align the SAS export with the Stata consumer through a same-table copy/name mapping.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_SAS_STATA_HANDOFF
Evidence: E_SAS_EXPORT, E_STATA_EDGAR_INPUT

Preparation / proposed procedure:

1. Translate [redacted-path-cf82ecace3a6] and [redacted-path-b576d23c8e31] locations to relative or [redacted-path-9cacf8cb6f3a] host paths accepted by the project wrapper; do not put Dropbox absolute paths in executable configuration.
2. Export the SAS All_abs2017 table into the shared staging location and either stage that same table as All_abs_2017.dta in the Stata working directory or configure Stata to read the exact producer path.
3. Keep All_abs2017_win separate; Stata's current source reads raw All_abs2017.

Validation to perform later:

- Before later execution, confirm the producer and consumer see the same DTA table with the required fields and that staging paths are readable/writable by both wrappers.

### ACT_SAS_RUNTIME: Confirm the permitted host SAS runtime and Base SAS import/export, SQL, and sort capabilities before an authorized run; this assessment did not start SAS or check its version/license.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_SAS_SOURCE_STEPS, E_SAS_LOG_IMPORT, E_SAS_LOG_TRANSFORM, E_SAS_EXPORT

Preparation / proposed procedure:

1. Use the project's supplied host wrapper and verify SAS/runtime availability and required Base SAS procedures through the later authorized setup process.
2. Set host-visible library and export paths consistently with the Stata handoff.

Validation to perform later:

- Record the confirmed SAS runtime and required procedure availability before running the supplied SAS source; no runtime result is claimed here.


## Remaining issues and prerequisites

- I_STATA_INPUT_STATE [unresolved; full_pipeline]: The Stata do-file begins with in-memory tranche data and switches to monthly performance and ABS-EE loan data without author-supplied imports or exact reset/load boundaries. The input files, schemas, source-to-Stata mapping, and working directory for those sections remain unresolved.
- I_STATA_FIELDS [unresolved; full_pipeline]: The deal keep at line 55 does not retain type before line 82 uses it. series, period, and cluster are referenced later but have no supplied producer or retained-field contract in this source. Do not infer aliases or replacements.
- I_ACTPAY_MISS [preparation; full_pipeline]: actpay_miss is generated at line 173, dropped by the line 212 keep, and immediately referenced at line 214. A source-hashed supported edit can retain the flag through that statement.
- I_SAS_SORT_ORDER [unresolved; full_pipeline]: SAS sorts str.All_abs2017 at line 398 before the later CREATE TABLE at line 401 and writes All_abs2017_apr11, which is not consumed in the supplied source. Whether the sort input is a deliberate pre-existing state is unresolved.
- I_SAS_LOG_NAME [unresolved; full_pipeline]: The literal SAS SET list includes log20170229, while the SEC static list shows February 28 and March 1 entries. The supplied materials do not explain an author-side rename or member mapping; preserve the literal list and do not infer a missing file or substitute another date.
- I_SAS_STATA_HANDOFF [preparation; full_pipeline]: SAS exports [redacted-path-1c06966df207] while Stata reads All_abs_2017 from its current directory. Host path/name staging must align before a run; the same-table copy/rename is a supported preparation step.
- R_BLOOMBERG_DEAL [undetermined]: Bloomberg ABS tranche/deal source table used by the Stata deal-level block, described by the datasheet as the ABS sample and all variables other than initial principal balance and cumulative write-offs.
- R_MOODY_DEFAULT [undetermined]: Monthly ABS performance/default input used for cumulative write-offs/losses, balances, and the nearest observation to issue_date +183 days. The exact author input table, native-to-Stata field mapping, and required history are not supplied.
- R_SEC_10D_FALLBACK [undetermined]: Issuer Form 10-D information used to fill missing Moody's principal-balance or cumulative-write-off observations; exact deals, missing fields, extraction rules, and periods are not provided.
- R_SEC_ABSEE [undetermined]: Loan-level ABS-EE records for 108 auto deals used to construct FICO, LTV, actual-to-scheduled payment, payment-to-income, verification, and risk-layer measures; the raw-to-Stata mapping is absent.
- R_SEC_LOGS [undetermined]: Historical SEC EDGAR access-log CSV files selected by the literal SAS daily SET list from 16-Nov-2016 through 30-Jun-2017 and transformed into filtered log tables.
- R_SEC_INDEX [public_acquisition_required]: SEC quarterly master filing index consumed by SAS to add form type/date to EDGAR log rows and resolve filing dates for the accession map.
- R_ACCESSION_MAP [undetermined]: Hand-collected CIK and accession map for first and second prospectuses and ABS-EE filings of sampled treatment auto deals, consumed by SAS as abs_cik.
- SW_SAS [unverified]: The source invokes SAS PROC IMPORT, PROC SQL, PROC SORT, PROC EXPORT, and macros; SAS runtime/version/license/component availability was not tested under this audit's scope.

## Review notes

- Static review only: no SAS startup, version/license/PROC CONTENTS check, Stata author-code execution, estimator or syntax trial, dataset transformation, installation, download, API contact, or applied source edit was performed. execution_verified remains false.
- Only a full_pipeline scope is supported. The datasheet identifies Identifiers.xlsx as the final-sample deal/tranche name lookup, and the bounded probe confirms its readability and consumed headers. It is not a full analysis panel or the separate CIK/accession map; the one-row probe limit is not treated as evidence that the lookup is incomplete.
- The SEC official log page supports the broad historical product/period/CSV route, but the exact SAS daily member mapping remains unverified because the literal list includes log20170229. Preserve the list and its April 29-30 omission; the list itself does not prove absent source files.
- Bloomberg/Moody's catalog misses are discovery results only and do not establish absent data or licensing. Official product pages establish candidate services but not the specific 2019 ABS vintage, field coverage, or current entitlement.
- Preserve the operative SAS +60-day variables despite the 14-day comment; preserve Stata's issue_date+183-day default selection, 0-12-day EDGAR counts, payment caps, 0.829676 replacement, 0.48 factor, and authored risk-layer thresholds. Do not silently switch branches or populations.
- SAS All_abs2017_win is a separate output; Stata reads the exported raw All_abs2017 table after same-data path/name staging. The pre-producer SAS sort remains unresolved. The final prospectus/absee/common Stata merge stays in memory and has no documented external output target in the supplied source.
