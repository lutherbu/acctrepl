# Patch proposal: jar-53a026da6db9

Fraud Allegations and Government Contracting

DOI: 10.1111/1475-679X.12258

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full author-documented preparation and Stata analysis workflow, including the SAS panel construction and every supplied regression table branch.

Entry points: `Data_Cleaning.sas`, `Regressions.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 3/12258 - Fraud-Allegations-and-Government-Contracting/hcp-datasheet-and-code-files.zip",
      "sha256": "5140b69f8a9521ffdba2aabf6af752c6df91907feb6638a3e799503fc55d6376"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "8da7396d604dca75af3bcbc678b01b9983479c9e54f987c31faef7f228b3b1ca"
}
```

## Proposed actions

### A_CONFIRM_INPUT_CONTRACTS: Confirm the author-prepared inputs and exact product, identifiers, fields, types, history and matching contracts before a full-pipeline attempt.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CONTRACTS, R_ALL_CONTRACTS, R_CASES, R_COMPUSTAT_ANNUAL, R_COMPUSTAT_QUARTERLY, R_POLITICAL, R_BOARD, R_LINK_TABLE_COMPLETE, R_COMP_SIC, I_UNAVAILABLE_PREPARED_INPUTS
Evidence: E_ARCHIVE_CONTENTS, E_SAS_INPUTS, E_SAS_CONTRACT_FIELDS, E_SAS_CONTRACT_LINK, E_SAS_CASE_JOIN, E_SAS_FYEND, E_SAS_QUARTERLY, E_SAS_POLITICAL, E_SAS_BOARD, E_SAS_TOP100_JOIN, E_SAS_COMP_SIC, E_DOC_CASE_SOURCE, E_DOC_CONTRACT_SOURCE, E_DOC_POLITICAL, E_USA_PERIOD, E_USA_CONTRACT_PRODUCT, E_USA_FIELD_DICTIONARY, E_DB_FIELDS, E_PROBE_FUNDA, E_PROBE_FUNDQ, E_PROBE_COMPANY_SIC, E_PROBE_NAMES_SIC

Preparation / proposed procedure:

1. Inventory only the prepared author inputs named by the scripts, then compare their field names/types, identifiers, date coverage and joins with the stated contracts.
2. For contract files, verify all 17 annual inputs for 2000–2016, the legacy obligation/pricing/agency/PSC fields and numeric parent-DUNS normalization; the local June 2025 database metadata does not establish this contract.
3. Confirm whether cases_wb, all_contracts, link_table_complete, political_connections2 and Board are currently available in their author-prepared form and how the two DUNS link tables differ.
4. Confirm whether wb.funda maps to COMP.FUNDA, whether the unused fyearq reference can be removed, the intended quarterly equity field used for Stata seq, and the author-selected compustat_sic source.
5. Do not reconstruct manual case, parent-company, PAC/lobby or board matches from source names alone.
6. Confirm quarterly Compustat firm-quarter history needed for the ten-quarter leads/lags; a one-row local probe does not establish population or historical coverage.

Validation to perform later:

- After an independently authorized data access step, use bounded metadata and field/type/date checks, then confirm join keys and event-window coverage without a full-data sweep.

### A_CONFIGURE_PATHS: Select a host working directory and data subdirectory using relative or [redacted-path-7783becbf1ed] paths, keeping the SAS and Stata roots consistent.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_PATH_CONFIGURATION
Evidence: E_SAS_LIBREF, E_STATA_INPUT

Preparation / proposed procedure:

1. In a future working copy, set the SAS wb directory to the confirmed project data directory and set the Stata jarpaper global to the confirmed project root; do not use the Windows placeholder or a Dropbox absolute path.
2. Run the host wrappers from the project root and preserve the relative layout for all SAS reads and generated files.

Validation to perform later:

- Before any separately authorized author run, confirm the configured relative or [redacted-path-7783becbf1ed] paths resolve on the host and the intended directories are writable.

### A_RESOLVE_GOVT_LIBREF: After locating the prepared political input, map its directory to govt or reuse an existing host autoexec assignment in the future SAS run configuration.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_GOVT_LIBREF
Evidence: E_SAS_LIBREF, E_SAS_POLITICAL

Preparation / proposed procedure:

1. Once the political_connections2 file location is confirmed, use its containing directory for the govt libref; if the documented host autoexec already assigns that directory, retain the existing assignment.
2. Keep the wb and govt assignments explicit and separate unless the confirmed prepared-input layout places both tables in the same directory.

Validation to perform later:

- In a future authorized empty-session check, confirm the govt libref and the exact political_connections2 member resolve before running author code.

### A_CONFIRM_FINAL_HANDOFF: Obtain the author-specified SAS-to-Stata producer, export format, schema and path before treating the supplied two-language workflow as closed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_FINAL_HANDOFF
Evidence: E_SAS_OUTPUT_END, E_STATA_INPUT, E_STATA_VARIABLES, E_STATA_TOP100

Preparation / proposed procedure:

1. Identify the exact prepared SAS table and export statement that create final_data and confirm the required names and types for all Stata-consumed variables.
2. Retain all table and panel branches in Regressions.do while reconciling the export contract.

Validation to perform later:

- Compare the confirmed export schema with every variable used by Regressions.do before any separately authorized regression run.

### A_CONFIRM_SEQ_MAPPING: Confirm the author’s intended quarterly shareholder-equity field and its source-to-export mapping for Stata seq.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_QUARTERLY_SEQ
Evidence: E_PROBE_FUNDQ, E_SAS_QUARTERLY, E_STATA_VARIABLES

Preparation / proposed procedure:

1. Trace seq through the author-prepared fundq input, SAS panel and final_data export.
2. If the local Compustat source is the intended input, obtain the documented mapping or author-prepared seq field; do not substitute seqq without confirmation.

Validation to perform later:

- Confirm the exact variable exists and matches the author definition in the export metadata before the Stata analysis.

### A_CONFIRM_TOP100_MAPPING: Confirm how the generated contractor-rank tables supply largest_100_Max to the regression dataset while preserving the 2000–2016 top-contractor branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_TOP100_HANDOFF
Evidence: E_SAS_TOP100_FIELDS, E_SAS_TOP100_MACRO, E_SAS_TOP100_JOIN, E_STATA_TOP100

Preparation / proposed procedure:

1. Confirm the intended parent-DUNS-to-GVKEY/year join, aggregation and panel destination for the annual largest_100 and largestdod_100 indicators.
2. Confirm the definition of largest_100_Max and whether any omitted prepared step produces it; do not guess a maximum or substitute the annual indicator.

Validation to perform later:

- Compare the author-confirmed Table 10 variable and sample across all years with the joined panel schema before running regressions.

### A_REMOVE_UNUSED_FYEARQ: Conditionally remove the unused fyearq reference from the fiscal-year-end KEEP list if wb.funda maps to the probed COMP.FUNDA source; the required output remains gvkey2 and fyr.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: I_FYEND_FYEARQ
Evidence: E_PROBE_FUNDA, E_SAS_FYEND

**Proposed edit:** `Data_Cleaning.sas:191–191`
Source SHA-256: `e278054a0df95105a4a248272b838fa57982c62a371699e7871cd6192f91a92c`

The bounded COMP.FUNDA probe lacks fyearq, and the next step drops it before the join; retaining fyr and GVKEY preserves the stated fiscal-year-end output.

Current text:
```
keep fyearq fyr gvkey2;
```

Proposed replacement:
```
keep fyr gvkey2;
```

Preparation / proposed procedure:

1. Verify that the future wb.funda mapping is the probed COMP.FUNDA table before applying this cleanup proposal in a separately authorized source-edit step.

Validation to perform later:

- After an authorized edit, confirm the fyend table still contains GVKEY and fiscal-year-end values for the intended firm history.

### A_FIX_DUPLICATE_IF: Delete one duplicate if token on the Table 9A regression line; this proposal changes no sample or regression terms.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_STATA_SYNTAX
Evidence: E_STATA_DUP_IF

**Proposed edit:** `Regressions.do:138–138`
Source SHA-256: `e712dde44400b7216fc7c2e191c7cdc401c84640bcb9ee874e9a7084d7d9a1bb`

The current source contains two consecutive if tokens; one if is the Stata qualifier and the intable9a sample condition remains unchanged.

Current text:
```
areg  pct_def_agency c.inter8q##c.serious_doj  log_at hhi cogs lev  i.def_ag##i.fyearq  i.def_ag##i.fqtr  i.ind_code##i.fyearq  if   if  intable9a==1, absorb(gvkeyn) cluster(gvkeyn)  
```

Proposed replacement:
```
areg  pct_def_agency c.inter8q##c.serious_doj  log_at hhi cogs lev  i.def_ag##i.fyearq  i.def_ag##i.fqtr  i.ind_code##i.fyearq  if  intable9a==1, absorb(gvkeyn) cluster(gvkeyn)  
```

Preparation / proposed procedure:

1. Apply this exact single-line proposal only in an authorized future working copy after the final_data handoff is confirmed.

Validation to perform later:

- Review the edited line text and syntax-check the affected Stata command in a separately authorized run; preserve the original regression terms and sample flag.

### A_VERIFY_SAS_RUNTIME: Resolve or confirm the SAS 9.4 startup environment and record a successful empty-session batch startup before any future author-code run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_SAS_RUNTIME, SW_SAS
Evidence: E_ENVIRONMENT, E_DOC_WORKFLOW

Preparation / proposed procedure:

1. Use the documented host batch flags after the TKELS startup issue is repaired or confirmed.
2. Do not infer missing SAS entitlement from the current initialization error.

Validation to perform later:

- Record version and empty-session startup evidence without loading study data or executing author programs.

### A_PREPARE_YQ_CODES: Prepare yq_codes from the fully specified quarter calendar or reuse an existing compatible lookup; author-original bytes and formula clarification are unnecessary.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_YQ_CODES
Evidence: E_SAS_YQ, E_SAS_YQ_KEY

Preparation / proposed procedure:

1. For each year 1990–2018 and quarter 1–4, create yq=10*year+quarter and yq_n=4*(year-1990)+quarter, retaining only 1990Q1 through 2018Q4.
2. Write or otherwise make this 116-row lookup available as wb.yq_codes for the future SAS run; a compatible existing local table can be used if it matches the same formula.
3. Do not mark a not-yet-created lookup as locally available.

Validation to perform later:

- Confirm yq is unique and follows the YYYYQ key convention created by the SAS signed-date code.
- Confirm yq_n is the consecutive sequence 1–116 for 1990Q1–2018Q4 and each key maps one-to-one.
- After the required case, contract and Compustat history is available, verify every needed quarter and the ten-quarter pre/post event windows fall within the lookup interval.


## Remaining issues and prerequisites

- I_UNAVAILABLE_PREPARED_INPUTS [unresolved; full_pipeline]: The archive contains only the datasheet, identifiers, SAS source and Stata source. The author-prepared contract crosswalk, case/events, political and board tables, Compustat mappings, and full contract-history contract are not established as compatible runnable inputs. The yq_codes file is not supplied, but its calendar formula is documented and can be prepared deterministically. No present NDA or other access barrier is evidenced.
- I_PATH_CONFIGURATION [preparation; full_pipeline]: The SAS wb libref and Stata global use placeholders; select the confirmed project/data directories and set relative or [redacted-path-7783becbf1ed] paths in a future host working copy.
- I_GOVT_LIBREF [preparation; full_pipeline]: The supplied SAS file has no explicit govt libname. Once the prepared political input location is confirmed, map its directory to govt or reuse an already configured host assignment.
- I_FINAL_HANDOFF [unresolved; full_pipeline]: Regressions.do reads final_data while Data_Cleaning.sas ends at an export comment. The producing dataset, export step, exact variable schema and handoff path are not shown.
- I_QUARTERLY_SEQ [unresolved; full_pipeline]: Stata uses seq for leverage, while the probed local COMP.FUNDQ candidate exposes seqq and not seq; the SAS panel/export mapping is not shown. No alias is assumed.
- I_TOP100_HANDOFF [unresolved; full_pipeline]: Stata consumes largest_100_Max, while the supplied SAS code creates annual largest_100 and largestdod_100 indicators in a separate contractor branch and does not join that branch to panel8. Its intended firm-quarter construction is unresolved.
- I_FYEND_FYEARQ [preparation; full_pipeline]: The local COMP.FUNDA candidate lacks fyearq, but that KEEP reference is discarded by the next step; it is a conditional cleanup note if wb.funda maps to this source, not a required data field.
- I_STATA_SYNTAX [preparation; full_pipeline]: Regressions.do line 138 has a duplicated if token; a narrow proposal-only deletion of one token preserves the stated Table 9A sample flag and regression.
- I_SAS_RUNTIME [unresolved; full_pipeline]: The frozen SAS 9.4 startup probe failed while initializing TKELS. This does not establish missing entitlement or an absent SAS installation; runtime availability remains unverified.
- R_CONTRACTS [undetermined]: The 17 USAspending contract-year inputs Contracts2000–Contracts2016, retaining the original author fields and contract transaction/history conventions for the full period.
- R_ALL_CONTRACTS [undetermined]: Author-prepared all_contracts crosswalk mapping normalized parentdunsnumber_n values to GVKEY for the contract-year joins.
- R_CASES [undetermined]: Author-prepared cases_wb event/case data with GVKEY and case count, received/election dates, agency codes, and the intervention and severity fields used in the quarter panel.
- R_YQ_CODES [undetermined]: Quarter lookup yq_codes mapping the code-generated YYYYQ quarter key to the documented numeric index for event-time construction; an equivalent table can be deterministically prepared from the source comment.
- R_COMPUSTAT_ANNUAL [undetermined]: Annual Compustat funda input used to build the GVKEY-to-fiscal-year-end lookup.
- R_COMPUSTAT_QUARTERLY [undetermined]: Quarterly Compustat fundq input used for the firm-quarter panel and Stata analysis variables.
- R_POLITICAL [undetermined]: Prepared political_connections2 table with firm-year PAC and lobbying indicators and amounts used in political controls.
- R_BOARD [undetermined]: Prepared Board firm-year table with author-defined politically connected board indicator.
- R_LINK_TABLE_COMPLETE [undetermined]: Separate link_table_complete input read by the contractor-rank branch and joined by parentdunsnumber.
- R_COMP_SIC [undetermined]: Prepared compustat_sic input with GVKEY and SIC fields for the industry-code join in the full panel.
- SW_SAS [unverified]: The SAS source uses ordinary Base SAS DATA steps, PROC SORT, PROC SQL and PROC MEANS. The installed SAS 9.4 runtime remains unverified because the frozen startup probe failed loading TKELS; no PC Files export procedure is present in the supplied source.

## Review notes

- Expanded checkpoint after bounded input/source and software review. Prepared author inputs and the full period/field contracts remain unverified; all 17 annual contract files and every supplied output branch remain in scope.
- The archive contains only the datasheet, Identifiers.txt, Data_Cleaning.sas and Regressions.do. Identifiers.txt is a GVKEY list, not the panel data.
- Local USAspending connection and exact relation metadata were checked only through the common read-only PostgreSQL resource, with a single bounded follow-up for three named relations. Sampled planner date statistics do not establish exact history; no further database discovery is planned.
- The local Compustat row_limit=1 metadata probes establish readability/columns only, not population or historical coverage. SAS startup remains unverified after TKELS initialization failure.
- No analysis_only scope is included because no compatible prepared analysis dataset or route is established. Native Stata use, replace is valid and is not recorded as a defect.
- Dependency review now covers all 146 frozen IDs, grouping only repeated annual/generated branches with identical supported dispositions. D0146 is recorded as a missing SAS-to-Stata producer issue, not as a presumed generated output.
- Calibration: path selection and the missing govt LIBNAME assignment are routine preparation once directories are known; the unused fyearq KEEP reference is a conditional cleanup note because fyend retains only GVKEY/fyr. SAS usage is ordinary Base DATA/SORT/SQL/MEANS; no export licensing requirement is inferred from an export comment.
- The yq_codes calendar formula is explicitly specified in Data_Cleaning.sas: yq is numeric YYYYQ and yq_n runs 1–116 over 1990Q1–2018Q4. A compatible lookup may be generated deterministically or reused; the output remains unverified until materialized and checked against required event/quarter history.
