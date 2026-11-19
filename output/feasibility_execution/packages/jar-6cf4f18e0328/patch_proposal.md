# Patch proposal: jar-6cf4f18e0328

Bank Competition: Measurement, Decision-Making, and Risk-Taking

DOI: 10.1111/1475-679X.12117

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented primary-paper and online-appendix workflow, including the datasheet’s manual data construction. The assigned package contains the datasheet and results appendix only, with no executable author program or analysis data.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 3/12117 - Bank-Competition-Measurement-Decision-Making-and-Risk-Taking/bushman-hendricks-williams-online-appendix.pdf",
      "sha256": "5698e5dfc56edef8d6376b31a4e0c28fac5e5c6f991cc96cc4dbec8078eb6982"
    },
    {
      "path": "JAR-Volume 54/Issue 3/12117 - Bank-Competition-Measurement-Decision-Making-and-Risk-Taking/bushmans-hendricks-williams-datasheet.pdf",
      "sha256": "1609eb693bbc918a8fc005bb062246396b74a66efb8203303185c5f8039eff37"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "fc4de3c23683550f79328828066e8e4f0dffee6b95aa211d615f2f5346c0a74a"
}
```

## Proposed actions

### A_request_author_code_and_full_workflow: Request the missing executable workflow and documentation for the primary paper and every included appendix analysis.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_missing_code, I_workflow_incomplete, D_Li_industry_BCE, D_RegIndex, D_Lerner_index, D_local_BCE
Evidence: E_appendix_scope, E_appendix_missing_paper, E_li_index, E_regindex_iv, E_local_bce, E_all_industry_bce, E_package_inventory

Preparation / proposed procedure:

1. Request all SAS, Perl and Stata programs, supporting files, execution order, entry points, file paths, intermediate outputs and the mapping from each main-paper and appendix table/figure to its producing stage.
2. Request the complete primary article and its Appendices A/C, exact sample/variable definitions, the RegIndex and deregulation inputs, the Lerner-index construction, the local-MSA BCE input/mapping, and the exact Feng Li all-industry file used for Table A2.
3. Preserve the documented manual stages and the paper’s distinct BCE periods; do not infer missing variables or rebuild the models independently.

Validation to perform later:

- Map each supplied table and figure to the returned code/manual stages and their complete producer-consumer inputs.
- Confirm the returned code and documentation specify the data fields, identifiers, sample periods and software versions needed to reproduce the author workflow.

### A_obtain_BCE_inputs: Request the author-prepared financial-firm BCE file and confirm separate coverage for the appendix’s broader EDGAR diagnostics.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: D_BCE_financial, D_BCE_diagnostic_filings
Evidence: E_bce_construction, E_bce_diagnostics_period, E_author_bce_page, E_sec_edgar, E_sec_history, E_catalog_candidates

Preparation / proposed procedure:

1. Request the prepared BCE data described on the author page, including its exact GVKEY/year fields, firm roster, 1996–2010 history, 2012 vintage and any access conditions.
2. Separately resolve the appendix’s 20,234 EDGAR filing corpus for 1994–2010, including the 1994–1995 years, filer roster and filing/version selection; do not treat the 1996–2010 financial-firm product as a substitute.
3. Check the cataloged local LM10X and SEC parsed/raw resources only for exact coverage and content compatibility before acquiring duplicate public filings; if raw filing inputs are needed, retain the documented keyword, nearby-negation and whole-10-K denominator procedure.

Validation to perform later:

- Confirm author-prepared BCE rows contain the required GVKEY and annual measure for the stated financial-firm sample.
- Reconcile the appendix diagnostic roster and years independently from the 1996–2010 paper sample before using one product for either purpose.

### A_acquire_dealscan_inputs: Check the cataloged Dealscan tables against the author’s 2012 data vintage and filters before using them; otherwise obtain the documented vendor inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: D_DEALSCAN_contracts
Evidence: E_dealscan_filters, E_catalog_candidates

Preparation / proposed procedure:

1. Confirm the local candidate package, financial-covenant, net-worth-covenant, facility, current-facility-pricing and lender-share tables cover the author’s completed USD original loans and required sample period.
2. Apply the documented package and facility joins, covenant indicators, spread calculation and lead-arranger restriction only after the table/field mapping is confirmed; if local coverage is incompatible, arrange licensed Dealscan access.

Validation to perform later:

- Verify table vintages, package/facility IDs, covenant fields, completion/original/USD filters and lead-arranger fields against the datasheet before constructing the contracting sample.

### A_obtain_identifier_crosswalks: Obtain the exact author-used linking tables that connect Dealscan records and bank securities to the accounting/regulatory panels.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: D_DEALSCAN_GVKEY_links, D_PERMCO_RSSDID_crosswalk
Evidence: E_dealscan_crosswalks, E_bank_y9c, E_catalog_candidates

Preparation / proposed procedure:

1. Request both Dealscan FacilityID-to-GVKEY and CompanyID-to-GVKEY linking tables with their provenance, date logic and author vintage.
2. Request the Federal Reserve Bank of New York PERMCO-to-RSSDID matching table and its key definitions/history; the local catalog does not identify an RSSDID field match.

Validation to perform later:

- Confirm that the returned mappings preserve the author’s borrower/lender roles and link the intended PERMCO observations to Y-9C RSSDID/date records.

### A_acquire_compustat_inputs: Confirm local Compustat candidate coverage and obtain any missing compatible annual, quarterly, bank or monthly-debt inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: D_COMPUSTAT_company_financials, D_COMPUSTAT_monthly_EDF_debt, D_BANK_COMPUSTAT
Evidence: E_dealscan_crosswalks, E_edf_compustat, E_bank_y9c, E_bank_panel_fields, E_catalog_candidates

Preparation / proposed procedure:

1. Check the local COMP.FUNDA/FUNDQ and COMP.BANK_FUNDQ candidates for author-period coverage, consolidation/format selection, required financial statement items and the 2012 historical vintage. For the bank quarterly data, check the primary 1996–2010 sample separately from possible pre-1996 history, potentially back to 1985, for the VaRA liabilities/assets/equity inputs; do not assume that earlier history is present.
2. Verify the separate monthly current and long-term debt observations required for EDF; quarterly Compustat fields do not satisfy that monthly input.
3. Use the author’s prior-to-origination statements and trailing-twelve-month income construction after the sample/crosswalk definitions are supplied; if the local candidates are incomplete, arrange access to the corresponding Compustat products.

Validation to perform later:

- Confirm borrower, lender and bank fields, identifiers and dates for the 1996–2010 primary study sample; separately confirm whether quarterly bank liabilities/assets/equity are available from 1985 for the risk construction or ask the authors to specify the effective risk sample period.

### A_acquire_crsp_inputs: Verify local CRSP history and obtain the documented daily/monthly equity, index and risk-free inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: D_CRSP_equity, D_CRSP_monthly_risk_free
Evidence: E_edf_compustat, E_crsp_beta, E_vara_data, E_var_covar_mes, E_controls, E_catalog_candidates

Preparation / proposed procedure:

1. Check the local CRSP DSF/MSF and DSI/MSI candidates for the author’s 1985–2010 risk and 1996–2010 study periods, required security codes and all return, price, shares and volume fields.
2. Identify and verify the separate monthly CRSP risk-free series required for EDF; the cataloged stock/index tables do not establish that input.
3. Retain the documented 40-trading-day, weekly/quarterly construction and market-return rules; obtain missing CRSP products from the author-accessed source if local history is incompatible.

Validation to perform later:

- Confirm historical coverage, identifiers, adjusted/unadjusted field semantics and monthly risk-free data before using the candidate tables.

### A_acquire_y9c_inputs: Obtain compatible quarterly Y-9C records and resolve the 1996–1999 period not covered by the documented current FFIEC bulk archive.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: D_Y9C_regulatory
Evidence: E_bank_y9c, E_bank_panel_fields, E_ffiec_download, E_ffiec_history, E_frb_y9c_foia

Preparation / proposed procedure:

1. Check the FFIEC NIC quarter/year downloads for all required 2000–2010 Y-9C fields and BHCK item versions.
2. For 1996–1999, verify an author-compatible historical archive or the Board FOIA route and request only missing quarters; do not infer that the bulk download’s 2000 start proves older data unavailable.
3. Join records by the author’s date/RSSDID keys after the exact crosswalk is obtained.

Validation to perform later:

- Confirm coverage for every required quarter and fields BHCK 1766, 1975, 1410 and 4635 under the period-specific Y-9C item definitions.

### A_verify_fed_rates: Check whether local FRB rate tables contain the author-specific series and full historical weekly inputs before deriving macro spreads.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: D_Fed_macro_rates
Evidence: E_vara_data, E_catalog_candidates

Preparation / proposed procedure:

1. Inspect only the cataloged daily/monthly FRB rate candidates for the source series, date coverage, 10-year BAA and Treasury definitions, three-month bill and LIBOR history.
2. Confirm the weekly alignment and source/vintage with the authors; do not equate similar labels such as Moody’s Baa or Eurodollar with a specified author series without confirmation.

Validation to perform later:

- Verify the exact series, full 1985–2010 dates, frequency conversion and spread formulas against the returned author specification.

### A_obtain_vix_history: Resolve VIX history before the documented VaRA sample start; the official Cboe page currently lists VIX from 1990.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: D_CBOE_VIX
Evidence: E_cboe_vix, E_vara_data

Preparation / proposed procedure:

1. Check whether the author’s actual bank-week sample requires VIX values before 1990 and obtain the exact author-compatible series/history if so.
2. Do not replace the stated VIX input with the distinct historical VXO series without an author-supported mapping.

Validation to perform later:

- Confirm full needed history and index definition for the author’s VaR/CoVaR sample.

### A_request_repo_and_event_data: Request exact identifiers, versions and access routes for the Bloomberg repo and merger/spinoff event inputs.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: D_Bloomberg_repo, D_SCD_merger_spinoff_events, D_FRB_Chicago_events
Evidence: E_vara_data

Preparation / proposed procedure:

1. Request the Bloomberg 3-month general-collateral repo series identifier, frequency and historical file/version.
2. Request the SCD and Federal Reserve Bank of Chicago merger/spinoff source files, event definitions, dates, and the documented join/exclusion rule.
3. If an author-prepared event-week intermediate exists, request it with source provenance; do not infer access barriers from the commercial source names.

Validation to perform later:

- Confirm the three inputs cover the VaRA observation period and reproduce the author’s week-to-quarter tagging logic.

### A_verify_sas_runtime: Resolve SAS start-up and version compatibility before future use of the author’s extraction/cleaning stages.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_software_workflow, E_runtime_probe

Preparation / proposed procedure:

1. Confirm the exact SAS version expected by the authors and a usable SAS session in the approved environment; the supplied probe ended at TKELS initialization and does not establish that SAS licensing is absent.
2. After author programs arrive, run only a harmless version/start-up check before any separately authorized study execution.

Validation to perform later:

- Record a successful runtime/version query and confirm the author’s required SAS version is supported.


## Remaining issues and prerequisites

- I_missing_code [blocking; full_pipeline]: The assigned package contains two PDF documents only and no executable author code. The datasheet documents substantial manual and software-assisted processing, which remains a real workflow; no_runnable_code is used because no program is supplied.
- I_workflow_incomplete [unresolved; full_pipeline]: The online appendix supplements the missing primary paper, while the datasheet omits executable files, complete input/output paths, exact loan and bank sample identifiers, the precise matching tables, some supplementary inputs and the equations in paper Appendices A/C. Required histories and compatibility of local/vendor/public candidates remain unverified; full closure is unresolved.
- D_BCE_financial [undetermined]: Author-prepared annual BCE competition measure for the financial-firm sample, linked by GVKEY; the datasheet describes 1996–2010 and a public-on-request data file.
- D_BCE_diagnostic_filings [undetermined]: The supplementary word-level BCE diagnostics use a separate 20,234-filing EDGAR corpus described as covering 1994–2010; the article data sheet instead gives a 1996–2010 study sample.
- D_Li_industry_BCE [undetermined]: Non-bank industry BCE comparison data used by supplementary Table A2, which the appendix attributes to Li et al. (2013) and Feng Li’s website.
- D_DEALSCAN_contracts [undetermined]: Dealscan completed, original, USD loan contracts and package covenant counts; facility terms, spread and lead-arranger lender shares used in the contracting analyses.
- D_DEALSCAN_GVKEY_links [undetermined]: Two author-used identifiers: Dealscan Facility ID to Compustat GVKEY for borrowers, and Dealscan Company ID to GVKEY for lenders.
- D_COMPUSTAT_company_financials [undetermined]: Historical borrower and lender Compustat balance-sheet and income-statement data current immediately before loan origination; income statements are annualized over trailing twelve months.
- D_COMPUSTAT_monthly_EDF_debt [undetermined]: Compustat monthly current and long-term debt observations needed for the borrower expected-default-frequency calculation.
- D_BANK_COMPUSTAT [undetermined]: Bank Compustat quarterly observations for the primary 1996–2010 study sample, including accrual choices, revenue mix, capital, charge-offs and controls. VaRA begins in 1985 and uses quarterly bank liabilities, assets and equity, so earlier bank-quarter history may also be needed for risk construction; the exact earlier coverage is unresolved.
- D_CRSP_equity [undetermined]: CRSP daily/monthly bank security inputs for EDF, equity values, beta, VaR/CoVaR/MES and controls: PERMNO/PERMCO, dates, returns, prices, shares, volume, market value-weighted returns and bank SIC/share codes.
- D_CRSP_monthly_risk_free [undetermined]: Monthly CRSP risk-free rates required by the borrower EDF calculation.
- D_Y9C_regulatory [undetermined]: Quarterly Y-9C regulatory filings merged by date and RSSDID, including BHCK 1766, 1975, 1410 and, for charge-offs, 4635.
- D_PERMCO_RSSDID_crosswalk [undetermined]: Federal Reserve Bank of New York PERMCO-to-RSSDID matching table required to identify bank Compustat/CRSP observations with regulatory reports.
- D_Fed_macro_rates [undetermined]: Weekly macro series used in VaR/CoVaR: 10-year BAA yield, 10-year Treasury/T-bill, 3-month T-bill and LIBOR inputs needed for the documented spreads and changes.
- D_CBOE_VIX [undetermined]: Weekly VIX input for the documented VaR/CoVaR macro-state vector.
- D_Bloomberg_repo [undetermined]: Three-month general-collateral repo rate from Bloomberg used to construct the liquidity spread.
- D_SCD_merger_spinoff_events [undetermined]: SCD event data used to flag merger/spinoff weeks and exclude affected quarters from VaRA estimation.
- D_FRB_Chicago_events [undetermined]: Federal Reserve Bank of Chicago event data jointly used with SCD to tag merger/spinoff weeks.
- D_RegIndex [undetermined]: Author-defined state/interstate branch deregulation index used in the appendix’s timing tests and IV first-stage analyses.
- D_Lerner_index [undetermined]: Author-defined annual bank-year Lerner index used in supplementary analyses, including current/lead values and a rolling 16-quarter equation referenced to the absent paper Appendix A.
- D_local_BCE [undetermined]: Bank-MSA average local BCE measure used in supplementary Table A14, including the bank-to-MSA mapping and compatible annual data.
- SW_SAS [unverified]: Datasheet says SAS was the primary tool for extraction, manipulation and cleaning; no version is specified. The supplied environment probe did not complete start-up after a TKELS initialization error, which does not establish a license barrier.

## Review notes

- There is no analysis_only scope: the package supplies no executable analysis route or compatible complete analysis dataset.
- The datasheet’s financial-firm BCE panel (1996–2010), appendix’s 20,234 EDGAR filings (1994–2010), and Li et al. all-industry comparison are separate products and periods.
- Catalog hits identify candidate local tables and files only; history, live readability, field semantics and author compatibility remain unverified. No license barrier is inferred from missing catalog matches.
- The datasheet’s SAS, Stata and Perl procedures are retained as real workflow stages even though no runnable author code is present; no programs or study data were executed.
