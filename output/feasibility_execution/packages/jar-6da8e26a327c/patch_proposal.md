# Patch proposal: jar-6da8e26a327c

Corporate Loan Securitization and the Standardization of Financial Covenants

DOI: 10.1111/1475-679X.12186

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The authors’ full documented dataset preparation and reported main/appendix workflow, beginning at BLV_code.do and including manual inputs and handoffs that the supplied program leaves external.

Entry points: `BLV_code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 1/12186 - Corporate-Loan-Securitization-and-the-Standardization-of-Financial-Covenants/blv-datasheet-and-code.zip",
      "sha256": "b380f91045bfbd08171dc5da07f19b4b4aa95943aff589f71603dea707229c88"
    },
    {
      "path": "JAR-Volume 56/Issue 1/12186 - Corporate-Loan-Securitization-and-the-Standardization-of-Financial-Covenants/blv_internetappendix.pdf",
      "sha256": "10a70acf0297f908d7d2e1d3cf734eafd03b329fe9f2e62d3ae438ba4b874b48"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "0e4b6c793c2c18d83eded93825874a9b86a385514c4a2f9fb585f6081821adcd",
  "work_item_sha256": "8718b7b2ce06b1d59fbd0cb584de4f9c4fa362ac705ecee2fd0c9c9547893718"
}
```

## Proposed actions

### A_CLO_INPUTS: Obtain the author versioned CLO-i holdings, performance and trades files or identify an authorized compatible source export.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_CLO_HOLD, R_CLO_PERF
Evidence: E001, E006, E030, E029, P_CATALOG

Preparation / proposed procedure:

1. Request holdingsTOTAL_original.dta, CLOperformance.dta and CLO_trades.dta with the exact version/date ranges used by the authors, or the source product/version and extraction fields needed to prepare them.
2. Document mappings for deal identifiers, reporting dates/months/quarters, issuer and loan fields, balances, ratings, performance/default thresholds, trade dates and face amounts.
3. Preserve the author-stated June 2013 data vintage and provide monthly/quarter history needed by all loan and CLO-quarter branches.

Validation to perform later:

- Run a bounded one-row metadata/readability probe on each supplied file and compare the resulting names/types with the documented code inputs.
- Verify complete period and prior-quarter coverage using file metadata or author documentation; do not infer population coverage from a one-row probe.

### A_DEALSCAN: Resolve the DealScan/Chava-Roberts input files, their field mappings and exact source vintage before using the local catalog candidates.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DEALSCAN, I_SOURCE_COMPAT
Evidence: E001, E004, E010, E026, P_CATALOG, P_FAC, P_PKG, P_LENDERS, P_MARKET

Preparation / proposed procedure:

1. Request the exact author facilityid.dta, packageid.dta, lendershares.dta and mkt_segment.dta files, the June 2013 Chava-Roberts database, and their source/version metadata.
2. For each file, map the author code fields (including facility/package IDs, company/country, loan type and dates, amounts, all-in-drawn, gvkey and lender fields) to the actual supplied source columns; keep unmatched names unresolved until the authors identify a mapping.
3. Verify the full loan sample and earlier facility/package/lender history required for the 1,800-day relationship calculations.

Validation to perform later:

- Use bounded metadata probes on supplied author files and compare exact source columns to every code consumer.
- Use author source documentation to verify 2000–2009 sample coverage and earlier history; do not treat the one-row SAS candidate probes as coverage evidence.

### A_COMPUSTAT: Obtain the author Compustat file or a documented compatible mapping from the local annual fundamentals candidate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMPUSTAT, I_SOURCE_COMPAT
Evidence: E001, E004, E014, E015, P_COMPUSTAT, P_CATALOG

Preparation / proposed procedure:

1. Request compustat.dta and its source vintage, key fields and sample/history documentation, or exact instructions mapping COMP.FUNDA fields to the names used in BLV_code.do.
2. Resolve the author code’s year/sic fields against the candidate source fyear/sich fields before selecting or renaming any variables.
3. Retain five preceding cash-flow observations for each analysis row and document how gaps or repeated fiscal years are handled.

Validation to perform later:

- Boundedly inspect supplied data columns and merge keys; verify all required firm-control fields before attempting the merge.
- Confirm the full yearly history required by lag1–lag5 from author/file metadata; a one-row probe is not coverage evidence.

### A_CONTRACTS: Obtain the author filing/contract crosswalk and manual sample annotations, then verify the supported local or EDGAR route.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_CONTRACTS, R_SEC_PACKAGES, I_MANUAL
Evidence: E003, E005, E008, E009, E010, E_SEC_EDGAR, P_SEC_RAW, P_SEC_PARSED, P_LM10X, E_INV

Preparation / proposed procedure:

1. Request the sample borrower-to-CIK/filing/exhibit crosswalk, the exact 440 securitized and 703 control contracts, and the annotated securitized_packages.dta plus manual matching corrections.
2. For the local SEC raw/parsed and LM10-X candidates, check only the exact author-identified documents and sections; use EDGAR full-text search for specific filings only after the filer and filing list are identified.
3. Document the manual false-match review, Excel matching rules, source of at_origination flags and the complete-contract selection procedure.

Validation to perform later:

- Verify document/section readability and crosswalk against the author sample before creating contract-derived fields.
- Reconcile the author-reported sample and complete-contract counts after the documented selection; do not infer coverage from directory presence.

### A_COVENANT_INPUTS: Request the author-prepared loan and covenant-score intermediates and the missing producer-to-consumer instructions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COV_PAIRS, R_LOAN_SAMPLE, I_DATA_HANDOFF
Evidence: E011, E015, E016, E017, E_INV

Preparation / proposed procedure:

1. Request covenant_similarity_score_pairs.dta, similarity_loan.dta, collected covenant definitions, and the exact author producer or construction record for each file.
2. Obtain the specified keys, labels, output columns and transformation order for joining covenant_similarity_score.dta and packageid_add.dta into the loan-level file; request the missing 1% winsorization and final-save steps if they are part of the published workflow.
3. Do not independently recalculate covenant text similarity or infer the final analysis dataset from a filename.

Validation to perform later:

- Confirm that the supplied score pair file contains the code-used identifiers, covenant types, origination dates and score field, and that its package-level output is consumed downstream.
- Compare the final loan table’s names and labels with each documented downstream analysis consumer before a future authorized run.

### A_AUX_FILES: Resolve the missing helper reads and give a complete input/output root mapping for the hard-coded paths.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HELPERS, I_UNLISTED_INPUTS, I_PATHS
Evidence: E018, E019, E028, E007, E026, E027

Preparation / proposed procedure:

1. Request syndicates.dta, leadid.dta and DealAmt.dta with their source, producer, expected columns, date coverage and intended downstream consumers.
2. Clarify whether syndicates.dta is an author-prepared input or should be produced by the earlier lender-share calculation; do not assume an alias or remove the read.
3. Request the author’s intended [redacted-path-b34a3bdd389e] directory structure and a concrete mapping of all input and generated output paths for the assessment workspace.

Validation to perform later:

- Review the complete supplied producer/consumer graph and verify each direct read has a source or an earlier producer.
- Before any separate authorized execution, confirm all input/output paths resolve to the intended files without overwriting source inputs.

### A_LOANCONNECTOR: Obtain the LoanConnector values or author-documented manual fallback for the rating, secured-status and arranger-share variables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_LOANCONNECTOR, I_APPENDIX_CODE
Evidence: E001, E012, E023, P_LCID, P_CATALOG

Preparation / proposed procedure:

1. Request the exact July 2015 LoanConnector data extract or author file containing initial ratings, secured status and lead-arranger loan shares, plus its facility/package identifier crosswalk.
2. For loans with missing LoanConnector ownership values, request the manual contract collection rules and author-recorded values; do not treat the local ID crosswalk as the data itself.
3. Identify how these variables feed the main analysis and Appendix Tables 6–7.

Validation to perform later:

- Confirm the required field names, sample linkage, and presence of values for the stated loan samples before building any analysis variable.
- Reconcile any reported Appendix 6–7 samples only after the author data and preparation route are verified.

### A_APPENDIX_PROGRAMS: Request executable programs and supporting inputs for every reported Internet Appendix analysis branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_APPENDIX_CODE
Evidence: E020, E021, E022, E023, E024, E025, E_INV

Preparation / proposed procedure:

1. Request analysis code, entry points and prepared inputs for Appendix Tables 1–8 and Figures 1–2, including their exact table/figure output names and column labels.
2. Ask authors to document the matching, legal-counsel/legal-content/LSTA, CLO 2.0 and technical-default sale workflows and the event-data source/linkage for Figures 1–2.
3. Treat Roberts-Sufi and LSTA mentions as clarification leads for the missing branch; do not independently construct an alternative analysis.

Validation to perform later:

- Trace each requested table/figure to a supplied analysis entry point and verify every required input is produced earlier in the documented workflow.
- Compare generated table and column labels with the Internet Appendix before any authorized execution.

### A_HISTORY_WINDOWS: Resolve the exact historical coverage needed for lagged variables and prior-loan calculations.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_HISTORY
Evidence: E002, E013, E014, E016, E029

Preparation / proposed procedure:

1. Ask authors to specify the full raw date coverage and row-selection rules for five prior Compustat cash-flow observations, preceding borrower/lender deals within 1,800 days, and prior CLO quarters.
2. Obtain the exact analysis sample dates and report any data gaps, fiscal-year irregularities and cutoff rules; do not infer start dates from the 2000–2009 loan-cohort range.

Validation to perform later:

- Verify the dated source files cover every required prior record for the target sample using documented full-file metadata or author coverage notes.
- Ensure all period and lag claims remain specific to the input that uses them.

### A_MANUAL_EXCEL: Obtain the manual Excel workbooks or a reproducible description of author-entered matching and review steps.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: S_EXCEL, I_MANUAL
Evidence: E008, E009, E010, E023, E_INV

Preparation / proposed procedure:

1. Request the original matching/correction workbook or an author-maintained record of exact-match review, false-match removals, fourth-attempt candidates, final Excel matches and manual ownership entries.
2. Confirm which spreadsheet application/version and input/export format the authors used; preserve all manual branch outcomes as author data.

Validation to perform later:

- Check that each manual decision maps to a documented source row/key and that the resulting author file has the expected IDs and columns.
- Do not substitute a different spreadsheet program or infer hand-edited values without a supported mapping.

### A_CLO_THRESHOLD: Request the author-confirmed producer and merge recipe for the CLO overcollateralization threshold fields used in the two score formulas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_CLO_THRESHOLD
Evidence: E031, E032, E033

Preparation / proposed procedure:

1. Ask the authors to identify the source file/table and original field names for senior_oc_threshold and junior_oc_threshold, including the deal/month keys and whether the fields originate in holdings or performance data.
2. Request the exact stage and join keys that carry both thresholds through the holdings and performance collapses to the score-generation lines.
3. Preserve the existing collapse specifications and score formulas until the authors confirm the intended source columns and merge recipe.

Validation to perform later:

- Use a bounded metadata probe on the author-identified source to confirm both threshold columns and their identifier/date fields.
- Before any separately authorized execution, confirm the two thresholds are available at the deal/reporting_month row before the score formulas and verify resulting score columns against the author-described mapping.


## Remaining issues and prerequisites

- I_MANUAL [unresolved; full_pipeline]: The code requires manual CLO-i/DealScan false-match cleanup, additional Excel matching, securitized-at-origination flags and complete-contract/covenant collection. The package has no matching workbook, manual corrections or prepared outputs; ID_borrowerid.txt is an identifier list, not the underlying analysis data.
- I_SOURCE_COMPAT [unresolved; full_pipeline]: The local catalog hits are discovery candidates only. Bounded DealScan probes expose source names such as FacilityAmt/CountryOfSyndication and Lender/CompanyID, while the author files expect a different set of fields; the Compustat candidate has fyear/sich where the Stata code uses year/sic. The LoanConnector candidate is only an ID crosswalk. Exact author file versions, mappings, transformations and coverage remain unverified.
- I_UNLISTED_INPUTS [unresolved; full_pipeline]: Static dependency discovery missed direct reads of [redacted-path-18f983015b6c] and [redacted-path-f841d942d98e]. The frozen D0017 syndicates.dta read also has no producer/save step in the supplied code. Their origin, expected fields and compatible preparation routes are not documented.
- I_DATA_HANDOFF [unresolved; full_pipeline]: The do-file creates separate outputs such as covenant_similarity_score.dta, packageid_add.dta and avg_sim.dta, but does not show how these are merged into the final loan/CLO analysis inputs; the later loan branch reads similarity_loan.dta and only merges Compustat. Comments refer to subsequent merging and 1% winsorization that are not implemented here. No final analysis entry point or output schema for the reported tables is supplied.
- I_APPENDIX_CODE [unresolved; full_pipeline]: The Internet Appendix reports Tables 1–8 and Figures 1–2, but the package contains no executable analysis programs for these branches. Appendix methods mention matching, legal-content/LSTA comparisons, arranger ownership, the CLO 2.0 indicator and Roberts-Sufi covenant-violation event sales; required programs, variable producers and supporting data are not provided. These are clarification leads, not reconstructed requirements.
- I_HISTORY [unresolved; full_pipeline]: The code requires five preceding Compustat cash-flow rows, prior loan history within 1,800 days with additional backward iterations, and prior CLO quarters for lags. Only a 2000–2009 origination sample is documented; raw-input histories, exact first/last years, and gaps are unknown, so no start date or completeness can be inferred.
- I_PATHS [unresolved; full_pipeline]: The author code uses hard-coded [redacted-path-7503566e2f51] paths throughout and provides no data-root mapping or portable project configuration. The intended runtime layout and files to overwrite/create must be clarified before an authorized attempt.
- I_CLO_THRESHOLD [unresolved; full_pipeline]: The CLO performance input is collapsed to senior_oc, junior_oc, ccc_bucket and defaultpct by deal/month, then merged into holdingsTOTAL; the next two lines calculate senior_oc_score and junior_oc_score from senior_oc_threshold and junior_oc_threshold. The earlier holdingsTOTAL collapse also retains only its listed fields, which exclude both thresholds. No producer or merge of either threshold variable is shown. The authors must identify the correct source columns, keys and stage; do not invent values or edit either collapse list without confirmation.
- R_CLO_HOLD [undetermined]: Author-named CLO-i monthly U.S. CLO holdings input holdingsTOTAL_original.dta (author version as of June 2013). Code expects deal/issuer/loan-type/maturity/date/balance and related ratings/industry fields; complete observation period and author field mapping are not supplied.
- R_CLO_PERF [undetermined]: CLOperformance.dta and CLO_trades.dta feed monthly performance merges and CLO-quarter trade/turnover variables. The code needs performance, thresholds, default and trade-amount fields, with prior-quarter coverage for lagged controls; dates/history are unknown.
- R_DEALSCAN [undetermined]: DealScan inputs used for facility/package matching, controls, lender shares, market segment, loan histories, and author-specific Chava-Roberts files: facilityid.dta, packageid.dta, lendershares.dta, mkt_segment.dta, and DealAmt.dta. Required fields in BLV_code.do include FacilityID/PackageID, Company/Country, LoanType, maturity and origination dates, FacilityAmount/FacilityAmt, allindrawn, gvkey, borrowerid/lenderid, lead_bank, and DealAmount; exact source-to-author file mappings and versions are unresolved. Loan relationships also need earlier records within a 1,800-day window.
- R_COMPUSTAT [undetermined]: compustat.dta used for gvkey/year merges and firm controls. Code requires at least gvkey, year, at, act, lct, oiadp, oancf, dltt and sic, and five preceding cash-flow observations per firm. Exact year mapping, author file and historical coverage are unresolved.
- R_CONTRACTS [undetermined]: Complete loan contracts used to identify and hand-collect financial covenant definitions (and, in appendix analyses, legal counsel/arranger ownership information). Author reports 440 securitized and 703 non-securitized complete contracts, with SEC EDGAR retrieval; exact filer/CIK, filings, exhibits and text coverage are unknown.
- R_SEC_PACKAGES [undetermined]: Manual securitized-at-origination annotation and author sample file securitized_packages.dta, including the package-level securitized flag and at_origination indicator. The code uses this as input but the workbook/annotations and producer are not packaged.
- R_COV_PAIRS [undetermined]: Author-prepared covenant_similarity_score_pairs.dta, produced after manually grouping complete contract definitions in 12 categories and calculating pairwise similarity; code expects pair identifiers, covenant type, origination dates and covenant_similarity. The computation/hand-collected data and file are not supplied.
- R_LOAN_SAMPLE [undetermined]: similarity_loan.dta is read directly as the loan-level analysis input and merged with Compustat by gvkey/year. Its producer, required columns (including var used to filter), creation history, and relationship to the separately created covenant_similarity_score.dta are not specified.
- R_LOANCONNECTOR [undetermined]: LoanConnector values for initial rating, secured status and, in Appendix Tables 6–7, lead-arranger loan share; the appendix permits manual contract collection of arranger share where LoanConnector has no value. Required loan/facility linkage, product version, sample coverage and fallback procedures are not supplied.
- R_HELPERS [undetermined]: Additional author-specific reads required by the supplied code include syndicates.dta, leadid.dta and DealAmt.dta. The do-file reads syndicates.dta after a separate syndicate calculation, but gives no saved producer; leadid.dta and DealAmt.dta are not in the frozen dependency checklist and have no documented source/producer or compatible replacements.
- S_EXCEL [unverified]: The author workflow calls for manual Excel review/matching of DealScan and CLO-i records and some ownership information; no Excel version or equivalent manual workbook/procedure is supplied or verified.

## Review notes

- The prepared package has one Stata dataset-creation entry point, a datasheet, a DealScan borrower-ID list, and an Internet Appendix; no author DTA data or appendix analysis programs are included.
- CLO-i/Creditflux source-name lookups returned no catalog matches. The catalog contains DealScan, Compustat and LoanConnector candidates; bounded one-row reads establish source readability/columns only, not author-file compatibility, entitlement or historical coverage.
- SEC raw, parsed and LM 10-X roots were checked by exact root metadata only. No directory listing, target filing scan or data download was performed.
- No author program, regression, installation, data download or package/source change was performed.
- Coordinator replay review identified an unresolved CLO threshold-field handoff: neither collapse retains senior_oc_threshold/junior_oc_threshold, but both score formulas consume them. The pair remains unverified pending the authors’ source and merge recipe.
