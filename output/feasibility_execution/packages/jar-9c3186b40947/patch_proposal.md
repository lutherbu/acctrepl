# Patch proposal: jar-9c3186b40947

The Long-Term Consequences of Short-Term Incentives

DOI: 10.1111/1475-679X.12410

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete supplied SAS preparation workflow, from author-provided Equilar and manual inputs through vesting, repurchase, M&A, BHAR, insider-sale and all six named Stata DTA exports. The datasheet reports Stata 16 empirical tests, but this package has no Stata analysis driver or analysis-panel consumer; paper-wide tests are outside this supplied-SAS target and remain unassessed.

Entry points: `EFH_SAS_Code.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 3/12410 - The-Long-Term-Consequences-of-Short-Term-Incentives/efh-datasheet-code-and-identifiers.zip",
      "sha256": "85ff31538d5f8a7007bd3f619c3b1c832a507d8d7edae1ea7f28185ef29a1be4"
    },
    {
      "path": "JAR-Volume 60/Issue 3/12410 - The-Long-Term-Consequences-of-Short-Term-Incentives/efh-online-appendix.pdf",
      "sha256": "f2ec39ae0675f01dfa7cf970c69889d44f28cb2e4e1c44ff3b99242ab25cb8d4"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "1ec77fae4bf2c7cf74ca55b3074d3fdb41cbbfe8ab586710c9f1af6bba1890f4"
}
```

## Proposed actions

### A_AUTHOR_MANUAL_INPUTS: Stage the author-specific Equilar 2006–2016 sheet family, separate CUSIP workbook, two separate Compustat manual-match workbooks, two TFN checked_ok workbooks, hand-collected CEO-age data, all ten monthly repurchase workbooks, both distinct annual SDC complete1/complete2 series, the separate repurchase Request 1 workbook, and annual SDC M&A event workbooks.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_EQ, R_CUSIP, R_COMP_MATCH1, R_COMP_MATCH2, R_TFN_DUPKEY_MANUAL, R_TFN_NONMATCH_MANUAL, R_AGETENURE_CHECKED, R_MONTHLY_RP_COLLECTION, R_SDC_COMPLETE1, R_SDC_COMPLETE2, R_SDC_REPURCHASE_ANN, R_SDC_MA_EVENTS
Evidence: E_EQ_COMPANY, E_EQ_CUSIP, E_COMP_MATCH1, E_COMP_MATCH2, E_TFN_MANUAL, E_CEO_HAND, E_MONTHLY_RP, E_SDC_COMPLETE1, E_SDC_COMPLETE2, E_RP_ANNOUNCEMENTS, E_MA_EVENTS

Preparation / proposed procedure:

1. Obtain the exact author workbooks or an author-confirmed compatible copy for each separately listed input; retain the supplied sheet names and original column headers.
2. Preserve distinct Compustat match1/match2, TFN duplicate-key/non-match checked sheets, SDC complete1/complete2, SDC repurchase Request 1, and annual SDC M&A Request 2 products.
3. Record source period, export vintage, identifiers, and manual verification status for each workbook before importing.

Validation to perform later:

- Check that each imported workbook contains every listed code-consumed column and required sheet.
- Confirm all Equilar fiscal years 2006–2016, SDC year files 2006–2016, and exactly ten monthly repurchase source files; do not infer coverage from filenames.
- Confirm manual keys and verified flags preserve the author's separate merge branches.

### A_VENDOR_HISTORY_CHECK: Check each same-provider local candidate for the exact code-consumed fields and history below; choose it when those requirements are met, using authorized WRDS only for uncovered roles.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_ANNUAL, R_COMP_QUARTERLY, R_CCM_LINK, R_CRSP_DSF, R_CRSP_MSF, R_CRSP_DSI, R_CRSP_MSI, R_CRSP_NAMES, R_CRSP_DELIST, R_CRSP_MSEALL, R_CRSP_DSEALL, R_EXEC_CODIRFIN, R_EXEC_COPEROL, R_EXEC_PERSON, R_TFN_TABLE1
Evidence: E_CATALOG_LOOKUPS, E_CANDIDATE_PROBES, E_COMP_ANNUAL, E_COMP_QUARTERLY, E_COMP_SIC, E_CCM_FILTERS, E_CRSP_VOLATILITY, E_DGTW_CRSP, E_DGTW_DELIST, E_CEO_RA, E_TFN_INPUT, E_BS_PRIORITY_ORDER

Preparation / proposed procedure:

1. For FUNDA, confirm filtered fyear>=2004 core records, fyear>=1998 dividend observations for each five-prior-year average, and DGTW USD datadate records from 01JAN1991; catalog metadata lists SEQ and ITCB, while the saved one-row probe did not request those two fields.
2. For FUNDQ, confirm the fyearq>=2003 filtered quarter rows and date/key matches used by controls, goodwill and repurchase construction. The verified COMPANY route is a current gvkey/SIC fallback; no historical SIC input is required.
3. For CCM, check linkprim/linktype filters and effective-date intervals for required gvkey/permno joins. For CODIRFIN, check the consumed company-years against the supplied order Equilar(t-1), Equilar(t), ExecuComp(t-1), ExecuComp(t), Compustat(t-1), Compustat(t). The local 2005-and-prior candidate may serve the legacy source window; verify whether actual Equilar fallback observations need post-2005 CODIRFIN values, without presuming that later observations are required. For COPEROL/PERSON, confirm CEO role/date and execid/name joins separately.
4. For CRSP DSF/MSF, check the exact dates and fields stated on each route; for DSI/MSI, check fixed CAR dates and the event-relative monthly horizons; for DSENAMES, check effective intervals for 2006–2016 announcement CUSIPs; for DSEDELIST, check the DGTW delisting period.
5. MSEALL/DSEALL are catalog-only candidates. Obtain the author %crspmerge definition, then confirm the macro's actual monthly/daily security-history source fields and 01JAN1991-to-configured-end window before using them.
6. For TFN.TABLE1, confirm cdate>=2005 and transaction-date coverage through the 2005–2016 sale windows, preserving the separate checked_ok name-review workbooks.

Validation to perform later:

- Compare each source against the concrete fields, filters, date bounds, merge keys and role described in its requirement; do not require original bytes when a compatible source product and specified conversion suffice.
- Record only the required history/field/key gap that remains. A bounded row probe does not prove later dates or key coverage, and catalog metadata establishes column names rather than row coverage.
- Keep current-vintage/output-fidelity comparisons as contextual notes unless the code or authors require a specific vintage.

### A_CEO_RA_STAGE: Stage the generated CEO review sheets under the filenames the supplied imports request, then preserve the manual review stage.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: R_CEO_EXECUCOMP_RA, R_CEO_UNMATCHED_RA
Evidence: E_CEO_RA

Preparation / proposed procedure:

1. After generating ceo_execucomp.xls and ceo_unmatched.xls, copy each to ceo_execucomp_ra.xls and ceo_unmatched_ra.xls respectively in the configured data root before the author imports.
2. Do not change the sheet name ceo or rename any source columns; complete the required RA fields in the copied files.

Validation to perform later:

- Confirm the imported sheets are the copied generated candidates with all original rows/columns preserved.
- Confirm the matched branch has verified, becameceo_filled and birth_date, and the unmatched branch has its required filled date/birth fields.

### A_CEO_RA_DECISIONS: Obtain the completed CEO RA review workbooks and the authors’ decision rules for the matched and unmatched CEO handoffs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_CEO_RA_HANDOFF, R_CEO_EXECUCOMP_RA, R_CEO_UNMATCHED_RA
Evidence: E_CEO_RA, E_CEO_HAND

Preparation / proposed procedure:

1. Request the completed ceo_execucomp_ra.xls and ceo_unmatched_ra.xls sheets, including filled dates, birth years and verified flags.
2. Request the intended handling for unmatched records, multiple ExecuComp matches and the explicit executive_id2=114202 exception.
3. Keep the two workbook outputs distinct and retain their matching keys.

Validation to perform later:

- Check company_id/executive_id2 keys and required manual fields on both sheets.
- Confirm verified rows and exception handling reproduce the supplied code's filters without filling unknown decisions by guesswork.

### A_SDC_WRDS_ALTERNATIVE: Confirm whether the local SDC catalog tables can supply the author-specific Excel products, while keeping those four extraction contracts separate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SDC_COMPLETE1, R_SDC_COMPLETE2, R_SDC_REPURCHASE_ANN, R_SDC_MA_EVENTS
Evidence: E_CANDIDATE_PROBES, E_SDC_COMPLETE1, E_SDC_COMPLETE2, E_RP_ANNOUNCEMENTS, E_MA_EVENTS

Preparation / proposed procedure:

1. Compare authorized local or WRDS SDC fields and query definitions with each distinct author export: complete1, complete2, repurchase Request 1 and annual M&A Request 2.
2. Use the local WRDS_MA_DETAILS/WRDS_MA_EVENTS rows only as discovery candidates; do not substitute them until needed columns, event definitions, year filters and joins are verified.

Validation to perform later:

- Confirm deal identifiers and party/date fields support the supplied deal_number/CUSIP matching logic.
- Confirm exact period, population and transaction variables for each SDC product before constructing author-compatible inputs.

### A_FF49_PUBLIC_FILES: Acquire the official monthly and daily FF49 products and reshape their public value-weighted/equal-weighted return series into the wide SAS input layout. The author workbook sheet format is a known adapter contract, not an unknown data source.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_FF49_MONTHLY, R_FF49_DAILY
Evidence: E_FF49_PUBLIC, E_FF49_CURRENT_CHANGES, E_FF49_MONTHLY, E_FF49_DAILY

Preparation / proposed procedure:

1. Acquire the official French Library monthly and daily 49 Industry Portfolios products for the author-consumed event and DGTW windows.
2. Convert the public series into separate vw and ew worksheets with a date key and one return column per industry, preserving the actual source values and missing-value meaning.
3. At staging, confirm the source numeric scale against the SAS code's divide-by-100 transform; retain the product source and date range with the converted files.

Validation to perform later:

- Confirm both products include date-aligned value-weighted and equal-weighted returns for all 49 industries and the stated required date windows.
- Verify the converted workbook has the vw/ew sheets and date/industry layout used by PROC IMPORT and PROC TRANSPOSE; this is format preparation, not a missing author-file prerequisite.
- Preserve missing-value semantics when mapping source sentinels into SAS numeric missing values.

### A_FF49_CROSSWALK: Obtain the actual author SIC-to-FF49 interval crosswalk and its source/definition; the return portfolio file does not produce it.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FF49_CROSSWALK, I_FF49_CROSSWALK
Evidence: E_FINAL_JOIN, E_FF49_PUBLIC, E_FROZEN_CATALOG

Preparation / proposed procedure:

1. Request the source and exact rows/definitions for v.ff49 fields ind, ind1 and ind2, including whether the SIC intervals reflect a particular French-library mapping year.
2. Request the author-provided SAS dataset or a documented reproducible table construction; do not infer interval bounds from the annual code or return workbook.

Validation to perform later:

- Confirm one intended industry assignment for each consumed four-digit SIC value and reconcile the interval boundaries with the author source.
- Confirm no overlapping or unassigned ranges in the required historical SIC population before rerunning the annual merge.

### A_FRED_RATES: Acquire the eleven source-named FRED series and assemble them into the explicit interest-rate table shape used by the supplied SAS join.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FRED_INTEREST
Evidence: E_FRED_CONSUMER, E_FRED_PUBLIC

Preparation / proposed procedure:

1. Acquire DGS1, DGS2, DGS3, DGS5, DGS7, DGS10, DGS20, DGS30, DGS1MO, DGS3MO and DGS6MO as daily series from FRED.
2. Verify official daily units and dates from 2004 onward for each named series; the current metadata citation directly confirms DGS1MO, while the other ten series are the remaining source-metadata gap.
3. Construct date plus all eleven series in the explicit v.interestrates_2017 table shape, then preserve the supplied percent scaling, YEAR(date)>=2004 filter, latest observation within the five-calendar-day pre-date window, and nearest-lagterm maturity rule.

Validation to perform later:

- Confirm each of the eleven columns uses the percent units expected by the source's 0.01 conversion and has observations for the required date window.
- Check that the selected date is the latest available within the five calendar days ending at the one-year-prior Compustat month end and that the maturity follows the source's nearest-term rule.

### A_DGTW_MACROS: Obtain the exact external DGTW macro definitions needed to identify their actual CRSP source roles and preserve the supplied filters and joins.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DGTW_MACROS, R_CRSP_MSEALL, R_CRSP_DSEALL
Evidence: E_DGTW_CRSP, E_DGTW_COMPUSTAT, E_DGTW_MACRO_CALL_MONTHLY, E_FFI48_CALL_MONTHLY, E_CATALOG_LOOKUPS

Preparation / proposed procedure:

1. Request the author's %crspmerge and %FFI48 macro definitions and their intended versions/options; neither definition appears in the complete supplied source.
2. Read the macro definitions statically to identify source tables/fields, date bounds, filters, security-history joins and industry classification behavior.
3. Only then match the catalog-listed MSEALL/DSEALL fields and the separately required MSF/DSF inputs to the macro's actual reads.

Validation to perform later:

- Confirm the macro outputs expose the fields consumed by the adjacent DGTW construction and preserve its 01JAN1991 start, common-share filter and formation/holding joins.
- Confirm monthly and daily source histories cover the actual authored date conditions without extending the sample or changing portfolio logic.

### A_SAS_PATHS_AND_COMPONENTS: Configure a host-visible data root and the author-required SAS import/remote components before running the supplied source.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_SAS_HOST_PATHS, S_SAS, S_SAS_EXCELCS, S_SAS_CONNECT
Evidence: E_SAS_INPUTS, E_EQ_COMPANY, E_EQ_CUSIP, E_FINAL_EXPORTS, E_DOC_METHOD, E_COMP_ANNUAL, E_CCM_FILTERS

Preparation / proposed procedure:

1. Choose and document the host-visible directory corresponding to the source's [redacted-path-840a278f9d74] root, and stage each required workbook/dataset there with exact expected names.
2. Confirm the available SAS release/procedures and EXCELCS support for the specified XLS/XLSX imports and XLS/DTA exports.
3. Configure SAS/CONNECT endpoint and required WRDS libraries only through the authorized account and environment.

Validation to perform later:

- Statically verify every path-consuming block resolves to the intended staged file in the configured root.
- In a later authorized run, check the required import/export engine and remote library connections before invoking the study workflow.
- No SAS process, license/startup, metadata or data execution was attempted in this assessment.

### A_WRDS_ACCESS: Confirm authorized WRDS account access and the exact source libraries as an alternative route for unverified local vendor candidates.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: S_WRDS_ACCESS, R_COMP_ANNUAL, R_COMP_QUARTERLY, R_COMP_COMPANY, R_CCM_LINK, R_CRSP_DSF, R_CRSP_MSF, R_CRSP_DSI, R_CRSP_MSI, R_CRSP_NAMES, R_CRSP_DELIST, R_EXEC_CODIRFIN, R_EXEC_COPEROL, R_EXEC_PERSON, R_TFN_TABLE1
Evidence: E_COMP_ANNUAL, E_CCM_FILTERS, E_MONTHLY_PRICE, E_TFN_INPUT, E_COMP_QUARTERLY, E_COMP_SIC, E_CEO_RA

Preparation / proposed procedure:

1. Confirm authorized WRDS access for the required Compustat annual/quarterly/company, CCM, CRSP, ExecuComp and TFN sources.
2. Confirm library paths and any date restrictions for the requested source tables; download only the fields needed by supplied joins when authorized.
3. For any unavailable author source, retain the local candidate's unresolved history/field differences rather than treating a catalog listing as access.

Validation to perform later:

- Confirm connection and authorized library visibility in a later authorized environment check.
- Compare field availability and source periods with each requirement's stated input history before selecting a route.


## Remaining issues and prerequisites

- I_DGTW_MACROS [unresolved; full_pipeline]: The supplied monthly and daily DGTW sections invoke %crspmerge and %FFI48, but their macro definitions and version/configuration are absent from the complete supplied SAS source. Local MSEALL/DSEALL catalog candidates do not establish a compatible macro or its exact fields, filters and merge behavior.
- I_FF49_CROSSWALK [unresolved; full_pipeline]: The annual sample consumes v.ff49(ind, ind1, ind2) to assign four-digit SIC intervals to FF49 industries, but no producer, crosswalk source, or compatible local copy is supplied. The return workbook does not define this author interval table.
- I_CEO_RA_HANDOFF [unresolved; full_pipeline]: The code exports ceo_execucomp.xls and ceo_unmatched.xls, then imports ceo_execucomp_ra.xls and ceo_unmatched_ra.xls. The copy/rename setup can be staged, but the completed RA verification fields, date/birth-year decisions, review rules and exception handling are absent.
- I_SAS_HOST_PATHS [preparation; full_pipeline]: The SAS program hardcodes [redacted-path-1cc316ae4270]. A host-visible mapping for those paths and confirmation of the required components are preparation steps; no SAS startup or process was tested.
- R_EQ [undetermined]: Equilar annual Excel workbooks for 2006–2016, with six separate consumed sheets: Company Financials, Executive Data - ND, Option Award Details - ND, Stock Award Details - ND, IP Award Details - ND and Outstanding Equity - ND. These raw manager, award and company records feed the vesting and compensation branches.
- R_CUSIP [undetermined]: Separate CUSIP workbook with a CUSIPs worksheet, deduplicated by company_id and joined to Equilar Company Financials before v.cf is written.
- R_COMP_ANNUAL [undetermined]: Compustat annual firm-year data for Equilar links, option assumptions and dividends, historical SIC, the embedded DGTW book-equity construction, and M&A target financials.
- R_COMP_MATCH1 [undetermined]: Manually reviewed Compustat-link worksheet for the author’s second-stage ticker/name candidate matches, imported from the checked_ok sheet of manualmatch1 after a to_be_check worksheet is exported.
- R_COMP_MATCH2 [undetermined]: Separately manually reviewed Compustat-link worksheet for name-score candidates, imported from the checked_ok sheet of manualmatch2.
- R_EXEC_CODIRFIN [undetermined]: ExecuComp codirfin company-year Black-Scholes assumptions, used as the third-priority fallback for option volatility and dividend yield after Equilar values and before Compustat alternatives.
- R_EXEC_COPEROL [undetermined]: ExecuComp coperol records used to identify CEO role, title and becameceo dates by gvkey/execid before joining to person names.
- R_EXEC_PERSON [undetermined]: ExecuComp person identity/name records joined to coperol on execid and used in the CEO-name match to Equilar executives.
- R_CCM_LINK [undetermined]: CRSP/Compustat CCM link history used to map gvkey and permno/permco across effective periods for volatility, returns and M&A/repurchase joins.
- R_CRSP_DSF [undetermined]: CRSP daily security returns/prices and shares used for option-volatility fallbacks, DGTW daily construction and pre-announcement MVE calculations.
- R_CRSP_MSF [undetermined]: CRSP monthly security returns/prices and share counts used for Equilar monthly prices, repurchase valuation, monthly BHAR and DGTW benchmarks.
- R_CRSP_DSI [undetermined]: CRSP daily market-index returns used in announcement CAR and the daily DGTW return branch.
- R_CRSP_MSI [undetermined]: CRSP monthly value- and equal-weight market-index returns used alongside CRSP monthly firm returns for market-adjusted BHAR.
- R_CRSP_NAMES [undetermined]: CRSP historical name/CUSIP history used to match SDC acquirer/target and repurchase announcement records to permno.
- R_CRSP_DELIST [undetermined]: CRSP delisting returns and delisting codes used in the supplied DGTW market-adjusted portfolio-return construction.
- R_CRSP_MSEALL [undetermined]: CRSP monthly security-history fields required by the embedded WRDS crspmerge call for month-level DGTW portfolio formation.
- R_CRSP_DSEALL [undetermined]: CRSP daily security-history fields required by the embedded WRDS crspmerge call for daily DGTW portfolio returns.
- R_COMP_QUARTERLY [undetermined]: Compustat quarterly firm data used to build quarterly controls, investment/R&D/capital-expenditure measures, goodwill impairment windows and the monthly repurchase panel.
- R_TFN_TABLE1 [undetermined]: Thomson/Refinitiv insider transaction records from table1 used for Equilar-name matching, executive stock-sale measures and pre/post-announcement sale windows.
- R_TFN_DUPKEY_MANUAL [undetermined]: Manual verification of ambiguous duplicate-key TFN-to-Equilar insider-name matches, imported from the checked_ok sheet and filtered to verified records.
- R_TFN_NONMATCH_MANUAL [undetermined]: Manual verification of TFN-to-Equilar insider-name candidates that failed the supplied perfect-name match rules, imported from the separate checked_ok sheet.
- R_SDC_COMPLETE1 [undetermined]: First SDC M&A annual Excel extract (Request 2), providing deal, parties, dates, SIC, assets, market values and consideration fields for the author’s combined M&A deal-size product.
- R_SDC_COMPLETE2 [undetermined]: Second, distinct SDC M&A annual Excel extract (Request 2), supplying deal number, sought percentage, offer prices and premium windows joined to the first SDC extract.
- R_AGETENURE_CHECKED [undetermined]: Hand-collected checked CEO age and CEO start-date observations keyed by company_id and executive_id2; SAS retains the earliest fy_end per key.
- R_CEO_EXECUCOMP_RA [undetermined]: Research-assistant review of CEO matches generated from ExecuComp; imported checked sheet supplies verified match decisions and filled CEO start dates/birth dates.
- R_CEO_UNMATCHED_RA [undetermined]: Research-assistant review of CEOs not matched by the supplied CEO-age or ExecuComp candidate joins; imported rows provide manually filled start dates and birth years.
- R_MONTHLY_RP_COLLECTION [undetermined]: Ten separately collected monthly share-repurchase workbooks, cleaned and combined into the author’s monthly repurchase collection keyed by CIK, Compustat date and month number.
- R_SDC_REPURCHASE_ANN [undetermined]: SDC repurchase program Request 1 records used to form announcement dates and CUSIPs before historical-CRSP-name and CCM matching.
- R_SDC_MA_EVENTS [undetermined]: Annual SDC M&A Request 2 event records for 2006–2016, including acquiror/target CUSIPs and names, announcement/effective dates, transaction size, payment composition and status, used in the separate event-matching branch.
- R_FF49_MONTHLY [undetermined]: Monthly Fama–French 49 Industry Portfolios value-weighted and equal-weighted return sheets; SAS converts percentage returns, reshapes to industry-month records and merges both series.
- R_FF49_DAILY [undetermined]: Daily Fama–French 49 Industry Portfolios value-weighted and equal-weighted return sheets, merged by date and industry for daily event/abnormal-return calculations.
- R_FF49_CROSSWALK [undetermined]: Author-provided FF49 SIC interval crosswalk v.ff49 with ind, ind1 and ind2, used to map annual Compustat historical SIC values to the French industry return series.
- R_FRED_INTEREST [undetermined]: FRED Treasury constant-maturity and bill-rate series assembled in v.interestrates_2017; used for rates dated from 2004 and up to five calendar days before the one-year-prior Compustat datadate, choosing the maturity nearest lagterm.
- S_SAS [unverified]: The author identifies SAS 9.4 and the package supplies a substantial SAS preparation program. This audit did not start SAS or inspect license/startup behavior; runtime and required procedure compatibility remain unverified.
- S_SAS_EXCELCS [unverified]: The workflow imports many .xls files through DBMS=EXCELCS and also exports RA workbooks. Engine availability, supported spreadsheet formats and host compatibility have not been established.
- S_SAS_CONNECT [unverified]: Supplied SAS sections use COMAMID=TCP, SIGNON and RSUBMIT/ENDRSUBMIT to access WRDS libraries. Client configuration, network reachability and successful remote session are unverified.
- S_WRDS_ACCESS [unverified]: The code requests Compustat, CRSP, ExecuComp and TFN SAS libraries on WRDS. This audit establishes neither active account entitlement nor access/history parity for those remote products.

## Review notes

- The source trace preserves the prior partial checkpoint and records a complete static read through line 7484. No author program, parser, syntax, statistical or descriptive trial was run.
- Catalog results and row_limit=1 probes establish only the specified static metadata and sampled readability/columns, not full sample coverage, field history or data entitlement.
- The datasheet reports Stata 16 empirical tests, but the assessed target ends with the six DTA exports produced by the supplied SAS workflow. No standalone Stata test driver or analysis-panel consumer is supplied, so paper-wide tests are outside this execution-feasibility scope and are not claimed.
- The official French Library currently identifies a FIZ-to-CIZ series transition beginning with the January 2025 release and notes historical updates. This is retained as output-fidelity context; exact author workbook or vintage confirmation is not a prerequisite for converting the public series.
- The FRED code explicitly names all eleven maturity series and their assembly rules. The current official metadata citation in this assessment directly supports DGS1MO only; daily units/history for the other ten named series remain the precise metadata follow-up.
