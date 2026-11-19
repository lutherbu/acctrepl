# Patch proposal: jar-b2e8bb843056

Shareholder Litigation and Corporate Disclosure: Evidence from Derivative Lawsuits

DOI: 10.1111/1475-679X.12191

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: controls.sas preparation, blw_jar_code.sas panel construction, and the reported downstream Stata analyses. The author package supplies two substantive SAS programs and a GVKEY/year identifier CSV, but no complete analysis dataset or Stata stage.

Entry points: `controls.sas`, `blw_jar_code.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 3/12191 - Shareholder-Litigation-and-Corporate-Disclosure-Evidence-from-Derivative-Lawsuits/blw-datasheet-and-code.zip",
      "sha256": "3d1aa3a018a44fcc207cd6a57ceba2b65d6cb9deb9156a3c5a48d26ed7e34fcb"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "55be0367c16b62cb64b0e9a015ef9c7ef208af857b1ce7a126d497d0df5d6eda"
}
```

## Proposed actions

### A-HEADER: Acquire and convert the verified SRAF 10-X header dataset for the header input.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R-HEADER-10K
Evidence: E-PUB-HEADER, E-PUB-HEADER-PERIOD, E-SAS-HEADERS

Preparation / proposed procedure:

1. After data-acquisition authorization, obtain the SRAF 1993-2025 header CSV from the cited repository page.
2. Filter the author-required 10-K variants and 1995-2007 report years; map filer_cik, company name, incorporation state, business state, filed date and conformed report period to the SAS header schema without substituting submission CIK for filer CIK.
3. Preserve duplicates/multiple filer rows until the author’s deduplication and historical CIK-link rules are confirmed.

Validation to perform later:

- Check the downloaded CSV metadata and required source columns, then validate 1995-2007 10-K coverage, period/date mappings and state-field missingness before conversion into the legacy SAS input.

### A-COMPUSTAT: Validate the local Compustat candidate against both author SAS input contracts and required history.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-COMPUSTAT
Evidence: C-COMPUSTAT, E-PROBE-COMP, E-SAS-COMP, E-CTRL-FUNDA, E-CTRL-YEARS, E-CTRL-EARNVOL

Preparation / proposed procedure:

1. Confirm whether local COMP.FUNDA can reproduce the author-specific wrds.compustat_1985_2015 input and its field types/identifier conventions.
2. Verify fyear 1980-2011 coverage for controls and 1985-2011 for the main panel; retain the ten-year prior-ROA window and five-observation rule.
3. Do not infer full-period coverage from the one-row probe or catalog observation metadata.

Validation to perform later:

- Check the required columns and historical fiscal-year coverage using a future authorized bounded metadata/date-coverage procedure; then validate derived control inputs for target years.

### A-CRSP: Use the verified local standard CRSP CCM, STOCKNAMES, MSF and MSI routes; resolve the separate legacy ERMPORT1 source.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CRSP-CCM, R-CRSP-STOCKNAMES, R-CRSP-MSF, R-CRSP-ERMPORT1, R-CRSP-MSI
Evidence: C-CRSP, E-PROBE-CCM, E-PROBE-STOCK, E-PROBE-MSF, E-PROBE-MSI, E-CTRL-MSF, E-CTRL-ERP, E-CTRL-MSI, E-CTRL-12MONTH

Preparation / proposed procedure:

1. Use the matching standard local CCM, STOCKNAMES, MSF and MSI products; exact author download-vintage identity is not required. During routine execution QA, check date-specific CCM links, CUSIP/NCUSIP match rates and the code-required twelve-month windows for actual control rows.
2. Identify the exact CRSP.ERMPORT1 source or author-confirmed equivalent and its decret/capn fields; do not guess a replacement table.
3. Preserve the code’s historical CUSIP/NCUSIP matching and exact twelve-month prior-return construction.

Validation to perform later:

- Run standard field/format and required-date checks for the readable local products as ordinary input QA; confirm ERMPORT1 field provenance before building controls.

### A-SEC-8K: Use the supported local 8-K item product and resolve the separate legacy CIK-GVKEY link-schema gap.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-SEC-LINK, R-8K-ITEMS, I-SEC-LINK-SCHEMA
Evidence: C-SEC, E-PROBE-WCIK, E-PROBE-ITEMS8K, E-PUB-WRDS-8K, E-PUB-WRDS-ACCESS, E-SAS-WCIK, E-SAS-WCIK-DATES, E-SAS-8K

Preparation / proposed procedure:

1. Use readable local WRDSSEC.ITEMS8K as the verified standard source for the 1995-2007 tests. Confirm its test-period slice and the supplied NITEM categorization in ordinary input QA; identical bytes to the 2017 extract are not required.
2. The alternate WRDS SEC Analytics Suite routes require subscription, but the replicator’s entitlement is unknown; do not treat them as blocked absent an actual denial or evidence of absent access.
3. Ask the authors to specify how legacy FLAG values 2/3 and FNDATE/LNDATE/CONM map to current CIK-GVKEY link fields before changing any SAS code.
4. If local raw SEC filings are considered for 8-K construction, obtain the exact form/item extraction and identifier-link rules before treating that route as compatible.

Validation to perform later:

- Perform normal input checks for the 1995-2007 8-K item slice and NITEM treatment. Resolve CIK-GVKEY link-key/date/flag semantics against the SAS consumer before running; do not require byte identity to the author extract.

### A-MDA: Obtain a compatible Brown MD&A length input or its exact author construction contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-MDA-LENGTH
Evidence: E-DOC-MDA, E-SAS-MDA, E-PUB-BROWN, C-SEC-LOCAL, E-PROBE-RAW, E-PROBE-LM10X

Preparation / proposed procedure:

1. Ask for the exact Brown.bmda release with GVKEY, datadate and num_words fields, date coverage and preprocessing description.
2. The current Brown page’s 2011 Data link is not verified as this input; do not assume it matches.
3. If considering local SEC/LM 10-K text, first obtain the author’s MD&A section boundary, cleaning and word-count rules; do not use whole-10-K text as MD&A.

Validation to perform later:

- Verify the source fields and 1995-2007 coverage, then confirm that MD&A-only word counts and GVKEY/date joins match the author’s specification.

### A-FIRSTCALL: Identify the exact First Call CIG and actuals extract required by the supplied forecast construction.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-FIRSTCALL
Evidence: C-FIRSTCALL, E-SAS-CIG-A, E-SAS-CIG-Q, E-SAS-ACT-A, E-SAS-ACT-Q, E-DOC-OWNERSHIP

Preparation / proposed procedure:

1. Ask for the exact First Call CIG and actuals release, field definitions, local access route and history; do not treat I/B/E/S as an equivalent without author confirmation.
2. Confirm CUSIP and split-factor fields, FPE/announcement dates, periodicity, EPS type, estimate codes and values used by the code.
3. Retain FPE filter years 1994-2010 separately from the 1998-2007 test window.

Validation to perform later:

- Verify required columns, product vintage and period coverage for annual and quarterly forecast and actual records before constructing forecast counts/widths.

### A-CUSTOM-INPUTS: Resolve the undocumented Thomson Reuters ownership, Audit Analytics derivative-lawsuit and Appel UD Laws branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-THOMSON-OWNERSHIP, R-AUDIT-LAWSUITS, R-UDLAWS, I-OWNERSHIP-PRODUCER, I-AUDIT-PRODUCER, I-UDLAWS-PRODUCER
Evidence: E-DOC-OWNERSHIP, E-DOC-AUDIT, E-DOC-APP15, E-DOC-APP16, E-WORKFLOW-TRACE, C-AUDIT, C-TFN, E-PROBE-AUDIT13, E-PROBE-AUDIT14, E-PROBE-TFN

Preparation / proposed procedure:

1. Ask the authors for each input’s exact release/file, required fields, sample/history, identifiers and merge producer; the current local TFN and Audit Analytics tables are discovery candidates only.
2. Confirm whether and how Thomson Reuters institutional ownership enters the control set, since no ownership read or construction is visible in controls.sas.
3. Confirm the derivative-case selection/linkage from Audit Analytics and whether current FEED13/FEED14 records are compatible.
4. Resolve the Appel (2015) versus Appel (2016) citation and identify the precise UD Laws table/layout and GVKEY/firm-year merge; do not reconstruct the state/laws dataset independently.

Validation to perform later:

- After the author contracts are supplied, compare fields, identifiers, periods and producer schemas to the actual SAS consumers; retain unresolved items until then.

### A-ANALYSIS-STAGE: Obtain the missing downstream Stata analysis and handoff materials.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-ANALYSIS-STAGE
Evidence: E-DOC-STATA, E-SAS-OUTPUT, E-DOC-STATE, E-DOC-ZERO-CIG, E-DOC-ZERO-8K, E-WORKITEM-INVENTORY

Preparation / proposed procedure:

1. Request the Stata analysis program(s), SAS export/import instructions, expected dataset path/schema, and mapping from final SAS tables to paper tables/figures.
2. Confirm where the datasheet’s state fallback/exclusions, nonmissing-control sample restriction, forecast tests, and forecast/8-K zero-fills are implemented.
3. Do not create an analysis_only scope from gvkey.csv; its probe shows only identifiers and year.

Validation to perform later:

- Trace each named table/figure to supplied executable Stata entry points and confirm its input schema and analysis window before any run.

### A-SAS-RUNTIME: Resolve the captured SAS runtime startup failure without changing or running author code.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS
Evidence: E-ENV

Preparation / proposed procedure:

1. Have the SAS runtime environment administrator review the recorded TKELS Launch Service load failure and establish a working SAS 9.4 command/runtime.
2. After the environment is repaired, perform a version/runtime-only check; do not retry author programs as part of this assessment.

Validation to perform later:

- Record a successful SAS 9.4 runtime/version check and preserve the author-version compatibility question if the authors specify a different release.

### A-SAS-ORDER: Run the supplied controls producer before the main SAS program in the same session so WORK.controls persists.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E-CTRL-FUNDA, E-CTRL-MACRO-CALL, E-SAS-CONTROLS, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Once required inputs and SAS runtime are ready, run controls.sas first and blw_jar_code.sas second within the same SAS session; both programs use the default WORK controls table, and the main script reads it.
2. A separate SAS session between these programs would lose WORK.controls.

Validation to perform later:

- Confirm WORK.controls is produced before blw_jar_code.sas consumes it and that the final WORK.udlawsmf and WORK.udlaws8kmda tables are created; this does not establish the missing Stata handoff or execution success.


## Remaining issues and prerequisites

- I-ANALYSIS-STAGE [unresolved; full_pipeline]: The datasheet requires exporting the SAS panel to Stata and conducting the main analyses there, but this package contains no Stata source, export/import procedure or analysis input schema. The SAS code ends with two WORK subsets; paper-described state fallback/exclusions and forecast/8-K zero-filling cannot be assigned to a supplied stage.
- I-AUDIT-PRODUCER [unresolved; full_pipeline]: The datasheet requires Audit Analytics derivative-lawsuit data, but neither supplied SAS file reads a lawsuit table or shows its firm mapping/merge. The current local Audit Analytics legal-case/company-party feeds are candidates only; author-specific population, date and identifier rules remain unknown.
- I-UDLAWS-PRODUCER [unresolved; full_pipeline]: The datasheet describes merging Appel UD Laws data but the supplied SAS code does not read that input. It cites Appel (2016) in the data-handling section and Appel (2015) Table 1 in the workflow steps; exact source/table, layout and GVKEY merge are unresolved.
- I-OWNERSHIP-PRODUCER [unresolved; full_pipeline]: The datasheet names Thomson Reuters institutional ownership as a control input, but controls.sas has no visible Thomson/TFN read or ownership measure construction. TFN.S34 is only a catalog candidate and its bounded probe timed out; the required measure/fields remain unspecified.
- I-SEC-LINK-SCHEMA [unresolved; full_pipeline]: The supplied SAS expects FLAG values and FNDATE/LNDATE/CONM from wciklink_gvkey. The current local WRDSSEC.WCIKLINK_GVKEY candidate exposes source/link dates and names instead; no field/status mapping is established. Do not rename or substitute fields without the release-specific definitions.
- R-COMPUSTAT [undetermined]: Compustat fundamentals for the main panel and controls. Main filter: 1985-2011; controls filter: 1980-2011, with up to ten prior fiscal years and at least five prior nonmissing ROA observations.
- R-CRSP-ERMPORT1 [undetermined]: Legacy CRSP ERMPORT1 monthly return/capitalization source used for SRET and turnover.
- R-SEC-LINK [undetermined]: Historical CIK-GVKEY links to merge header and 8-K records into the firm panel.
- R-HEADER-10K [public_acquisition_required]: 10-K header fields for CIK, company name, incorporation/business state, filing date and report period for 1995-2007 tests.
- R-MDA-LENGTH [undetermined]: Brown MD&A length table aggregated by GVKEY/year from num_words for 1995-2007 tests.
- R-FIRSTCALL [undetermined]: First Call CIG annual/quarterly forecasts and actual EPS records with CUSIP, announcement/FPE dates, EPS type, estimates/actual, CIG codes and split factors. Code filters FPE years 1994-2010; tests use 1998-2007.
- R-THOMSON-OWNERSHIP [undetermined]: Thomson Reuters institutional-ownership input is named in the datasheet but no supplied SAS source read, field construction or resulting control variable is shown.
- R-AUDIT-LAWSUITS [undetermined]: Audit Analytics derivative-lawsuit input is named in the datasheet; date range, required fields, company mapping and merge producer are absent from the delivered SAS.
- R-UDLAWS [undetermined]: Appel UD Laws/Table 1 data named by the datasheet, with one Appel (2016) mention and another Appel (2015) Table 1 mention; no file, layout, identifier mapping or producer is supplied.
- SW-SAS [unverified]: The frozen environment probe did not establish SAS 9.4 startup and records a TKELS Launch Service load failure; no version is confirmed. The probe also says this is not evidence of missing licensing; no further startup retry is authorized.

## Review notes

- Only full_pipeline is assessed. gvkey.csv is a one-row-probed gvkey/cyear identifier list, not a complete analysis dataset; no analysis_only route is established.
- The work-item checklist omits visible controls.sas reads of CRSP.MSF, CRSP.ERMPORT1 and CRSP.MSI; these are manually included as separate data requirements.
- The documented author workflow cites Audit Analytics, Appel UD Laws and Thomson Reuters ownership, but the complete supplied SAS code has no corresponding read/producer; these remain unresolved rather than independently reconstructed.
- The local SEC/LM roots were checked only by bounded directory stat. No recursive listing or population coverage was examined. LM 10-X and parsed/exhibits paths were not treated as complete 8-K or MD&A-only inputs.
- The supported visible producer order is controls.sas then blw_jar_code.sas in the same SAS session because the consumer reads the WORK.controls table. The later Stata analysis/export is absent.
- Local one-row probes establish bounded readability/columns, not complete history/population. The exact standard CRSP products and WRDSSEC.ITEMS8K match the supplied source contracts and required fields/types, so the local routes are treated as compatible; required-date, match-rate, format and population checks are ordinary future input QA, not a demand for a full-data sweep or identical author vintage. The official WRDS subscription condition does not establish this replicator’s entitlement or lack. Catalog misses and the TFN probe timeout are not proof that data or licenses are absent.
- Execution was not verified. No author SAS/Stata program was run, no dataset was downloaded, no author code was changed, and no restricted service was accessed.
- Validation checkpoint retained at draft.checkpoint.finalizer-error.json. The first controller finalization found R-CRSP-ERMPORT1 expected_period had been placed in expected_fields; this field assignment was corrected without changing the unresolved evidence claim.
- A second controller validation checkpoint is retained at draft.checkpoint.finalizer-error-2.json; two remaining positional helper arguments placed period descriptions in expected_fields and were corrected into expected_period.
- Pre-acceptance correction snapshot saved under archive/pre_acceptance_20261107T202957Z. Compustat FUNDA remains unverified for the author-specific main compustat_1985_2015 input even where it matches the controls read; the SEC-link FLAG/FNDATE/LNDATE/CONM mapping, missing Audit Analytics/UD Laws/ownership producers, missing Stata analysis/export, First Call and ERMPORT1 contracts remain unresolved.
