# Patch proposal: jar-64f9149f78be

Treatment of Accounting Changes and Covenant Violation Errors

DOI: 10.1111/1475-679X.12515

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author SAS preparation workflow. The datasheet also names Python and Stata analyses, but those later analyses are not included in this archive; the packaged facility-ID list does not support a separate analysis-only scope.

Entry points: `Import and Prepare Data and Define Variables.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 2/12515 - Treatment-of-Accounting-Changes-and-Covenant-Violation-Errors/zhu-datasheet-code-and-identifiers.zip",
      "sha256": "002509c41731c0a4361805443a43748ba2c064ba5818f6428d0b52a4e73d5635"
    },
    {
      "path": "JAR-Volume 62/Issue 2/12515 - Treatment-of-Accounting-Changes-and-Covenant-Violation-Errors/zhu-online-appendix.pdf",
      "sha256": "97c21950f366be4dd4f2ff46c5e8b0a8b9ebcd2a08c082276a1781bbf6aa77b0"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "1f956292de3a32da16c8446d2f0948590e3538f36c1ee9c0fc21f9085d0b5961"
}
```

## Proposed actions

### A_INPUT_CLOSURE: Reconcile every externally read THESIS table with an author-prepared input or a documented compatible source and producer before an execution attempt.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_INPUT_CLOSURE
Evidence: E_SOURCE_STRUCTURE, E_PACKAGE_MEMBER_LIST, E_DOC_SUPPLIED_WORKFLOW

Preparation / proposed procedure:

1. For each unverified requirement, request or locate the author-side table name, field schema, identifiers, period, and documented producer/cleaning steps.
2. Record which tables are author-provided inputs, generated intermediates, or joint source inputs; preserve all supplied code branches and filters.
3. Map the resolved files through the intended secure THESIS library configuration without writing credential values into the source.

Validation to perform later:

- Compare each resolved input schema with the exact source fields and required dates before any separately authorized run.
- Keep required historical and sample construction gaps open until evidence supports their closure.

### A_SEC_EXHIBITS: Use the documented SEC public filing route or a compatible local corpus to prepare the requested Exhibit 10 text while preserving the author’s form and content selection.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_SEC_EXHIBITS
Evidence: E_DOC_SEC_SCOPE, E_SEC_PUBLIC_ACCESS, E_SEC_PUBLIC_PERIOD, E_PROBE_SEC_RAW_DIR, E_PROBE_SEC_PARSED_DIR

Preparation / proposed procedure:

1. Confirm period coverage at the January 1994 boundary and identify filings in 10-K, 10-Q, and 8-K forms with Exhibit 10 documents for 1994–2017.
2. Apply the author’s stated credit-agreement, GAAP, and covenant-term filters and preserve filing identifiers, dates, form types, and text-cleaning choices.
3. Use only a documented fair-access workflow for any future public retrieval; this assessment did not request filing payloads.

Validation to perform later:

- Compare expected form/date coverage and identifiers with the author-provided sample scope.
- Check selected Exhibit 10 records and text fields against the supplied SAS program before running it.

### A_GAAP_INPUT: Obtain the author-prepared GAAP-provision input and its schema/provenance rather than independently reconstructing the hand-coded classifications.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_GAAP_PROVISIONS
Evidence: E_DOC_SUPPLIED_WORKFLOW, E_SAS_GAAP_INPUT, E_SAS_CIK_LINK, E_PACKAGE_MEMBER_LIST

Preparation / proposed procedure:

1. Request the compatible THESIS.EXHIBIT10_GAAP input or a documented authorized location and its identifier, date, coding, and field definitions.
2. Request the exact producer and manual-coding rules needed to understand its relationship to the SEC Exhibit 10 records.
3. Retain the author’s classifications and contract sample without substituting an independently reconstructed dataset.

Validation to perform later:

- Check that required CIK, filing/effective dates, classification fields, and later facility identifiers align with the consuming code.
- Check date-effective CIK/GVKEY joins only after the input and link-field contract is documented.

### A_CIK_LINK: Resolve whether the readable WRDS historical CIK-link candidate supports the author’s date-window and FLAG=3 semantics, then map it without assuming field equivalence.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CIK_GVKEY_LINK
Evidence: E_PROBE_CIK_GVKEY, E_SAS_CIK_LINK

Preparation / proposed procedure:

1. Compare candidate source and SEC start/end dates with the author-side DATADATE1, DATADATE2, and FLAG fields and their code meanings.
2. If the candidate’s `source` and date fields support the intended valid-link selection, document the conversion into the required author table; otherwise obtain the compatible link input.
3. Preserve the author’s filing-date comparison and FLAG=3 filter.

Validation to perform later:

- Confirm date type, interval boundaries, multiple-link resolution, and filing-period coverage against the documented link definition.
- Do not treat the one-row probe as evidence of full link coverage.

### A_COMP_ANNUAL: Map annual Compustat inputs to the author’s SIC-year, Model 1 control, and dividend tables while resolving the SICH/SIC and fiscal-year construction gap.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_ANNUAL
Evidence: E_PROBE_COMP_FUNDA, E_PROBE_COMP_FUNDA_SICH, E_CATALOG_COMP_FUNDA_VARIANTS, E_SAS_ANNUAL_CONTROLS, E_SAS_CIK_LINK, E_SAS_DIVIDEND

Preparation / proposed procedure:

1. Use the readable COMP.FUNDA candidate as a source candidate for the verified annual fundamentals and SICH/INDFMT fields.
2. Obtain or document how the supplied FYEAR_SIC table obtains SIC, whether SICH is intended, and how rows are aligned to fiscal year.
3. Construct or map the Model 1 and dividend inputs using the author’s fields and transformations; retain the existing annual lag and filters.

Validation to perform later:

- Check the exact source columns, annual identifier/date keys, and full required years before conversion.
- Confirm the SIC crosswalk and year mapping with author documentation; do not replace SIC with SICH by assumption.

### A_COMP_QUARTER: Map the readable quarterly Compustat candidate to the author’s quarter panel and controls while preserving all quarter windows.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMP_QUARTER
Evidence: E_PROBE_COMP_FUNDQ, E_SAS_QUARTER_KEYS, E_SAS_QUARTERLY_CONTROLS

Preparation / proposed procedure:

1. Document how COMP.FUNDQ fields map into THESIS.GVKEY_QUARTER and THESIS.CONTROLVARIABLE_COMPUSTAT.
2. Preserve the four-quarter lag/lead expansion, the annual-to-quarter operating-cash-flow calculation, and the four/eight-quarter control windows.
3. Obtain any additional source fields required by the author-prepared panel and its sample filters.

Validation to perform later:

- Check fiscal-quarter ordering, unique GVKEY/date keys, and required observation history at sample boundaries.
- Confirm the candidate and author table cover the target years; a one-row probe does not establish history.

### A_DEALSCAN_INPUTS: Resolve the facility, borrower crosswalk, lender, facility-lender, and historical facility inputs, then complete the author-required manual contract comparison.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_DEALSCAN_FACILITY, R_DEALSCAN_COMPUSTAT_LINK, R_DEALSCAN_FACILITY_LENDER, R_DEALSCAN_LENDER, R_DEALSCAN_FACILITY_HISTORY, I_DEALSCAN_MANUAL_CHECK
Evidence: E_PROBE_DEALSCAN_FACILITY, E_PROBE_DEALSCAN_LENDERSHARES, E_CATALOG_QUERY_001, E_CATALOG_QUERY_004, E_SAS_DEALSCAN, E_SAS_FACILITY_LENDER_INPUT, E_SAS_LENDER_REPUTATION, E_DOC_MANUAL_CONTRACTS

Preparation / proposed procedure:

1. Map the readable DEALSCAN.FACILITY candidate to the author’s facility table and confirm amount, dates, maturity units, currency, country, and facility/package identifiers.
2. Obtain the exact FACID-to-GVKEY/FIC crosswalk and lender/CompanyID mapping used by the author tables; do not substitute a similarly named company product without evidence.
3. Resolve the LENDERSHARES candidate’s FacilityID/Lender/role fields and the lead-arranger/company identifier contract for the 1990–2021 history.
4. Preserve the source’s U.S./United States Dollar filters, maturity threshold, exact date window, and yearly reputation construction.
5. Complete the source-documented manual comparison of contract lenders, loan type, amount, and maturity against DealScan.

Validation to perform later:

- Confirm full required coverage and key uniqueness for facility, borrower-link, and lender inputs before constructing the author tables.
- Record manual comparison outcomes for the 448-contract sample without changing contract inclusion or terms.
- Check all joins and time filters against the supplied source logic before any separately authorized run.

### A_ACCOUNTING_CHANGE: Obtain the author’s annual accounting-change count input and document the definition transition used to form the 1993–2017 count series.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_ACCOUNTING_CHANGE
Evidence: E_SAS_ACCOUNTING_CHANGE, E_PACKAGE_MEMBER_LIST

Preparation / proposed procedure:

1. Request the THESIS.ACCOUNTING_CHANGE table or documented compatible input with year and number_ac definitions.
2. Request the source and construction notes for the 1993–2008 standards counts and 2009–2017 update counts.
3. Map the year+1 join exactly as supplied.

Validation to perform later:

- Check annual key uniqueness and the required year range, including the prior year needed by the join.
- Confirm the value definition at the 2008/2009 transition before a future run.

### A_WORDCOUNT: Resolve the author’s WRDS SEC Analytics Suite word-count input or its documented compatible preparation route.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_SEC_WORDCOUNT
Evidence: E_SAS_WORDCOUNT, E_DOC_SUPPLIED_WORKFLOW, E_PROBE_SEC_RAW_DIR, E_PROBE_SEC_PARSED_DIR, E_SEC_PUBLIC_ACCESS

Preparation / proposed procedure:

1. Request the source table or product description for WORDCOUNT and its most-recent 10-K selection, cleaning, and GVKEY/fiscal-year alignment.
2. If using SEC filing text instead, obtain the author's tokenization and filing-selection contract and preserve the source-era filters.
3. Keep the word-count panel separate from the Exhibit 10 text table because it is a distinct table consumed by the program.

Validation to perform later:

- Check the exact GVKEY, fiscal-year, and WORDCOUNT fields and historical coverage before attaching the measure.
- Confirm the most-recent 10-K mapping and boundary years against author documentation.

### A_CRSP_INPUTS: Resolve the two distinct author-prepared CRSP panels, the separate monthly-return input, and the dated CCM link while mapping common source candidates and preserving both supplied model branches.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CRSP_MONTHLY_RETURN, R_CRSP_MODEL2_PANEL, R_CRSP_MODEL3_PANEL, R_CRSP_CCM_LINK
Evidence: E_PROBE_CRSP_MSF, E_PROBE_CRSP_MSI, E_PROBE_CRSP_CCM, E_SAS_CRSP_VOLATILITY, E_SAS_MODEL2_CRSP, E_SAS_MODEL3_WINSOR

Preparation / proposed procedure:

1. Use CRSP.MSF as the RET candidate and CRSP.MSI as the VWRETD candidate; document date and identifier alignment for each author table.
2. Request the producer or author-prepared form for THESIS.MODEL2_CRSP_20220124 and THESIS.MODEL3_CRSP_MONTHLY separately; retain their different branch-specific fields, date filters, and source histories.
3. Map CCM link fields to the author table and preserve LINKPRIM, LINKTYPE, LINKDT, LINKENDDT, and open-ended validity handling.
4. Resolve the distinct THESIS.MONTHLY_RETURN input for the 36-month volatility construction, preserving the supplied positive/negative return and model date filters.

Validation to perform later:

- Check required monthly history, date types, and security-link validity across the author sample; one-row probes do not establish complete coverage.
- Verify the separate Model 2 and Model 3 panel schemas/populations and the distinct RET and VWRETD source fields before any future execution attempt.

### A_COVIOL_INPUT: Obtain the author-prepared covenant-violation input and its schema/provenance while preserving the author's hand-collected sample and exclusions.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_COVENANT_VIOLATION
Evidence: E_DOC_VIOLATIONS, E_SAS_COVENANT_WINDOW, E_DOC_SUPPLIED_WORKFLOW

Preparation / proposed procedure:

1. Request the exact THESIS.COVENANTVIOLATION_9517 data input or documented authorized location, with its GVKEY/date/violation fields and sample coverage.
2. Request provenance and field definitions for the 1996–2007 and 2008–2017 procedures and the documented exclusions.
3. Do not independently rebuild the hand-collected violation data or infer that it is unavailable to the current user.

Validation to perform later:

- Check date units, unique loan/quarter keys, retained sample periods, and current/following-quarter match boundaries against the supplied code.
- Verify required coverage before any separately authorized run.

### A_PVIOL_INPUT: Resolve the exact package-level probability-of-violation input and its producer/interface before the positive-return branch is attempted.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_PVIOL_2022
Evidence: E_SAS_PVIOL, E_PACKAGE_MEMBER_LIST

Preparation / proposed procedure:

1. Request the author-prepared THESIS.PVIOL_2022 input or documented compatible route, its PackageID and score fields, and its population/date definition.
2. Request the exact SAS code/input specification the authors used for the Demerjian–Owens probability field.
3. Keep the supplied join and score values unchanged; do not rederive the score independently.

Validation to perform later:

- Check PackageID type/uniqueness and required coverage against the input contract.
- Confirm the score definition and data version with author documentation before a future run.

### A_FISD_INPUTS: Resolve the supplied author-prepared FISD panel and its independent bond–CRSP link input, retaining the supplied rating filters and branch construction.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_FISD_PREPARED_PANEL, R_BOND_CRSP_LINK
Evidence: E_PROBE_FISD_RATINGS, E_CATALOG_QUERY_003, E_PROBE_BONDCRSP, E_SAS_FISD, E_DOC_VENDOR_SOURCES

Preparation / proposed procedure:

1. Request the author-prepared THESIS.MODEL2_FISD_1950_2020 panel schema and producer; confirm the rating fields, rating types SPR/FR/MR, 1996–2017 date filters, and COMPLETE_CUSIP required by the supplied code.
2. Treat FISD.FISD_RATINGS and FISD.FISD_MERGEDISSUE metadata/probes as possible upstream support within the prepared-panel contract. If that route is needed, establish author-compatible construction and coverage; the issue-file timeout is a read limitation, and neither raw table is a separate visible program input on current evidence.
3. Map the prepared panel COMPLETE_CUSIP to the independently required WRDSAPPS.BONDCRSP_LINK input and resolve CUSIP conventions and link-validity dates.
4. Preserve the downstream rating-upgrade and rating-downgrade branches and their linkage through CRSP–Compustat.

Validation to perform later:

- Check the prepared panel rating type/date/value fields, COMPLETE_CUSIP, required 1996–2017 rating period, and any upstream history against the author contract; candidate metadata and a sampled row do not establish coverage.
- Verify the prepared-panel-to-bond-link CUSIP match and valid-date coverage, then check the downstream branches against the supplied code.

### A_SAS_RUNTIME: Verify the existing SAS runtime and SAS/ETS product in the intended execution environment and resolve secure library/session configuration before attempting the supplied program.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_SAS, S_SAS_ETS, I_SAS_SETUP, I_SAS_ETS
Evidence: E_SAS_EXHIBIT_INPUTS, E_SAS_QUARTER_KEYS, E_SAS_ETS_DOC, E_SOURCE_STRUCTURE

Preparation / proposed procedure:

1. Confirm SAS and SAS/ETS product availability through authorized administrative metadata; do not infer a license state from the retained startup failure.
2. Obtain the secure THESIS libref mapping and required session startup/configuration contract without placing credentials or defaults in source files or logs.
3. Identify any required data-table roots, helper definitions, and session macros before an execution attempt.

Validation to perform later:

- Confirm the intended environment can initialize the SAS session and expose the authorized data libraries before separately authorized execution.
- Confirm PROC EXPAND is available through SAS/ETS and that all intended THESIS inputs resolve to the documented files.

### A_WINSOR_MACRO: Obtain the supported %winsor macro definition/runtime binding and confirm its argument contract without changing the supplied call.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: S_WINSOR, I_WINSOR_MACRO
Evidence: E_SAS_MODEL3_WINSOR

Preparation / proposed procedure:

1. Request the exact macro source or documented installed macro path and version used by the authors.
2. Confirm the meaning of dsetin, dsetout, byvar=none, vars=return, type=winsor, and pctl=1 99.
3. Keep the supplied return variable and percentile settings unchanged pending that definition.

Validation to perform later:

- Check that the documented macro supports the supplied parameters and output behavior in the intended SAS session.
- Validate the implementation later on the actual author panel only under separate execution authorization.

### A_NVALUES_CONTRACT: Resolve whether nvalues_new is carried by the imported monthly-return input or whether the authors intended the locally computed nvalues field.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_NVALUES_CONTRACT
Evidence: E_SAS_NVALUES, E_SAS_CRSP_VOLATILITY

Preparation / proposed procedure:

1. Obtain the THESIS.MONTHLY_RETURN input schema and determine whether nvalues_new exists before PROC EXPAND.
2. If it exists, request its definition and producer; if it does not, obtain author confirmation of the intended filter variable before proposing any source edit.
3. Do not silently substitute nvalues for nvalues_new or change the 30-observation threshold.

Validation to perform later:

- Compare the confirmed input field definition and filter semantics with the later nvalues/nmiss outputs.
- After author clarification and separate execution authorization, validate that the confirmed rule preserves intended observations and sample history.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: The supplied workflow consumes author-prepared and intermediate THESIS tables whose exact producer, field contract, history, identifiers, and transformation routes are not verified. Common catalog candidates exist for several named products, but the packaged facility-ID file is not the required panel input.
- I_SAS_SETUP [unresolved; full_pipeline]: The actual THESIS libref root, data-table mapping, session configuration, and secure runtime setup are not established by the supplied safely reviewed interface. Existing SAS initialization metadata is retained as process history only; it is not a license or access finding.
- I_SAS_ETS [unresolved; full_pipeline]: PROC EXPAND is required for the supplied quarterly and monthly series transformations, but local SAS/ETS availability is unverified.
- I_WINSOR_MACRO [unresolved; full_pipeline]: The supplied Model 3 branch invokes %winsor, but its definition, load path, and supported parameter contract are not established.
- I_NVALUES_CONTRACT [unresolved; full_pipeline]: The code assigns the 36-return nonmissing count to nvalues, then filters on nvalues_new; the supplied source has no visible nvalues_new assignment. The THESIS.MONTHLY_RETURN input could carry an external field, or the intended filter could differ, so the impact and any correction remain unresolved.
- I_DEALSCAN_MANUAL_CHECK [preparation; full_pipeline]: The supplied workflow explicitly calls for manually checking contract lenders, loan type, amount, and maturity against DealScan. This check is a known preparation step and has not been established as complete for the current sample.
- R_SEC_EXHIBITS [undetermined]: SEC Exhibit 10 text inputs from 10-Q, 10-K, and 8-K filings, selected by the author’s stated credit-agreement, GAAP, and covenant terms and used for the supplied preparation workflow.
- R_GAAP_PROVISIONS [undetermined]: Author-prepared GAAP provision and contract classification table consumed as THESIS.EXHIBIT10_GAAP; its manual coding, identifiers, fields, and effective-date contract are not established by the packaged facility-ID list.
- R_CIK_GVKEY_LINK [undetermined]: Date-effective CIK-to-GVKEY link required to attach Compustat identifiers to the hand-coded exhibit sample; the code expects date-bound fields and retains link flag 3.
- R_COMP_ANNUAL [undetermined]: Annual Compustat inputs for fiscal-year/SIC joins, Model 1 controls, and dividend variables; annual periods, SIC transformation, and source-to-THESIS table construction remain unresolved.
- R_COMP_QUARTER [undetermined]: Quarterly Compustat inputs for GVKEY_QUARTER and quarterly control construction, including date-ordered lag/lead windows and quarterly cash-flow transformations.
- R_DEALSCAN_FACILITY [undetermined]: DealScan facility data joined to the coded loan-contract sample by borrower and effective date; the code filters maturity and later relies on borrower-to-GVKEY mapping.
- R_DEALSCAN_COMPUSTAT_LINK [undetermined]: DealScan-to-Compustat linking table used with FACID, GVKEY, and FIC to identify U.S. facilities; its producer, field mapping, and exact product version are not supplied.
- R_DEALSCAN_FACILITY_LENDER [undetermined]: Facility-to-lender input used to count distinct lenders by facility and construct the lender-count control; the THESIS table producer and exact role/identifier mapping are unresolved.
- R_DEALSCAN_LENDER [undetermined]: Lead-arranger and lender identity input used to construct annual lender reputation; the code relies on LEADARRANGERCREDIT, COMPANYID, and lender/facility linkage.
- R_DEALSCAN_FACILITY_HISTORY [undetermined]: Facility history used to count each lead arranger’s prior facilities by year; the source code filters country and currency and references 1990–2021 input history.
- R_ACCOUNTING_CHANGE [undetermined]: Annual accounting-change count input joined to the sample as lag_number_ac; the source comments specify annual counts for 1993–2008 and FASB updates for 2009–2017.
- R_SEC_WORDCOUNT [undetermined]: Most-recent 10-K word-count control keyed by GVKEY and fiscal year; the author program attributes the measure to the WRDS SEC Analytics Suite.
- R_CRSP_MONTHLY_RETURN [undetermined]: Monthly stock returns consumed as THESIS.MONTHLY_RETURN and transformed into a 36-month volatility measure.
- R_CRSP_MODEL2_PANEL [undetermined]: Author-prepared monthly CRSP input THESIS.MODEL2_CRSP_20220124, read by the supplied program before it creates the positive and negative return branches.
- R_CRSP_MODEL3_PANEL [undetermined]: Author-prepared monthly CRSP input THESIS.MODEL3_CRSP_MONTHLY, read by the supplied program to create the Model 3 return-shock branch.
- R_CRSP_CCM_LINK [undetermined]: Date-effective CRSP–Compustat link input named THESIS.CCM and used to map PERMNO to GVKEY under link-primary, link-type, and validity-date filters.
- R_COVENANT_VIOLATION [undetermined]: Hand-collected covenant-violation input THESIS.COVENANTVIOLATION_9517, joined by GVKEY and quarterly date across the current and following three quarters.
- R_PVIOL_2022 [undetermined]: Package-ID keyed probability-of-violation input THESIS.PVIOL_2022, consumed by the positive-return branch; the source dataset's producer and schema are not included.
- R_FISD_PREPARED_PANEL [undetermined]: Prepared bond-rating panel consumed as THESIS.MODEL2_FISD_1950_2020. The supplied code filters rating type and date, consumes COMPLETE_CUSIP, and then joins the separately required bond–CRSP link.
- R_BOND_CRSP_LINK [undetermined]: Date-effective CUSIP-to-PERMNO link input used to attach bond-rating observations to CRSP securities.
- S_SAS [unverified]: The supplied entry point is a SAS preparation program. Available environment metadata does not establish successful SAS initialization or license/product availability; this assessment did not invoke a SAS executable. The program requires Base SAS data steps, PROC SQL, SORT, and RANK.
- S_SAS_ETS [unverified]: The supplied workflow calls PROC EXPAND for quarterly lags/leads and monthly return windows. Official SAS documentation identifies SAS/ETS as a PROC EXPAND requirement; local product availability remains unverified.
- S_WINSOR [unverified]: The supplied third branch invokes %winsor with a 1st/99th percentile request; the safe source review did not establish a definition or supported runtime binding.

## Review notes

- The assessed target is the supplied SAS data-preparation program. The datasheet also mentions Python/SAS/Stata analyses, but this archive contains no later analysis driver; the packaged one-column facility-ID DTA is not an analysis panel, so no separate analysis-only scope is supported.
- The author states that no data were obtained from an organization on a proprietary basis and separately notes that hand-collected datasets were not publicly available. This assessment does not infer current-user access or licensing status from either statement and does not independently reconstruct hand-collected inputs.
- Common catalog candidates and successful bounded probes establish product-file candidates and selected schema fields only. They do not establish full-population or historical coverage, author-table mapping, or current entitlement. The authorized same-catalog COMP.FUNDA SICH/INDFMT probe is retained as a candidate; it is not asserted to be equivalent to the source's SIC/FYEAR_SIC input. The exact SIC request failure is preserved in probes/catalog_probe_capture_comp_funda_sic.json.
- The exact FISD.MERGEDISSUE one-row reader timed out after its 15-second bound. Its failure is preserved in probes/catalog_probe_capture_001.json. The ratings sample and issue metadata/timeout remain possible upstream support under R_FISD_PREPARED_PANEL, not separate mandatory visible raw inputs; no raw-to-prepared construction or full coverage is verified. The SEC raw, parsed, and LM10X checks were directory-metadata checks with no listing or coverage verification.
- The SAS credential-screened ranges [[20,21],[27,147],[606,610],[621,622]] remain wholly opaque. Screening/redaction helpers and outputs are retained. E_SOURCE_SCREEN_PROCESS, E_ENVIRONMENT_PROCESS, and E_WORKER_PROCESS_TRACE are process-only evidence rows and are intentionally unreferenced by every scientific evidence_ids list. No credentials, connection defaults, or raw candidate lines are reproduced.
- The source's nvalues_new filter at line 904 follows a visible nvalues count at lines 887–889; no nvalues_new assignment appears in the safely reviewed source. An imported monthly-return field remains possible, so this is a conditional contract issue and no source change was proposed or applied.
- All 35 frozen dependency IDs are reviewed once; D0021 and D0033 now map separately to the supplied MODEL2_CRSP_20220124 and MODEL3_CRSP_MONTHLY input panels. The literal-free source structure scan also identified CIK/GVKEY, CCM, and WRDSAPPS bond-link reads outside that frozen list, represented as requirements without inventing dependency IDs. Generated panel/branch tables remain distinct from imported inputs.
- The first incremental draft and source-close snapshot are preserved. A first capture-wrapper path error temporarily merged the old partial draft; the resulting checkpoint is retained, the working draft was reset from the template, and the expanded draft was rebuilt in captured sections. A merger that assumed an id key failed before writing; its exact captured failure is preserved, and the versioned merger handled dependency_id/dependency_ids. No faulty helper was deleted or overwritten.
- The supplied program requires Base SAS and SAS/ETS PROC EXPAND and calls %winsor. SAS initialization/product availability and the %winsor definition remain unverified. No SAS executable, author-code compile/parser/syntax run, model, regression, installation, or data payload download was run during this assessment.
- The only web checks were official static SEC and SAS documentation pages; no filing, data, archive, or document payload was requested or followed.
- The author’s nonproprietary-data statement is quoted in E_DOC_NONPROPRIETARY and is not treated as proof of current-user access or entitlement.
- The current supplemental process trace is worker_process_trace_003.json. It preserves worker_process_trace_002.json and its earlier trace ancestry, and adds the queued-hold hash verification/small snapshots, safe metadata inspection, the missing-python-alias attempt with unknown capture fields null, and the semantic-route normalization capture. The trace builder/link update, preflight capture, and pinned readonly finalizer record are retained separately in probes.
