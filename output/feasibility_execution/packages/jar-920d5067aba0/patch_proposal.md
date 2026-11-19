# Patch proposal: jar-920d5067aba0

Public Attention and Audit Behavior: The Case of Hurun Rich List in China

DOI: 10.1111/1475-679X.12309

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All supplied SAS preparation and output branches plus all supplied Stata analyses; includes Table 1 SAS results, main regressions, three matched-sample analyses, placebo, falsification, and the supplied appendix block.

Entry points: `SAS_code_submit.sas`, `STATA_code_submit.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 3/12309 - Public-Attention-and-Audit-Behavior-The-Case-of-Hurun-Rich-List-in-China/wy-datasheet-and-code.zip",
      "sha256": "ade4bfff1ba6af568ad5a293c798ede2578a17232966d12709340a408397b2dd"
    },
    {
      "path": "JAR-Volume 58/Issue 3/12309 - Public-Attention-and-Audit-Behavior-The-Case-of-Hurun-Rich-List-in-China/wy-online-appendix.pdf",
      "sha256": "fef26bca6be1860ed8a4a8e3bb74b6ec739054cdb183252f4b0b74a0aea167ef"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "6e26425ba1685581970be9e52e593cd95b05c46df1853b08058f8efb6f60057c"
}
```

## Proposed actions

### A-CSMAR-PRODUCTS: Obtain the native CSMAR products named by the code with their product-specific contracts and compatible extracts; retain every distinct module as a jointly required input.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-BS, R-IS, R-CFD, R-INDUSTRY, R-LISTING, R-DAILY-PRICE, R-SHARES-OUTSTANDING, R-TQ-OLD, R-WEEKLY-STOCK, R-WEEKLY-MARKET, R-SEO, R-FIXED-ASSET-FOOTNOTES, R-OLD-FINANCIALS, R-SANCTIONS, R-AUDIT-FEE, R-AUDITOR-COMPANY, R-CPA-IDENTITIES, R-IMPAIRMENT, R-SPECIAL-TREATMENT, R-MONTHLY-RETURNS, I-RAW-CONTRACTS
Evidence: E-DATASHEET-AUDIT-NEWS, E-SAS-CORE-STATEMENTS, E-SAS-DAILY-TQ, E-SAS-WEEKLY-STOCK, E-SAS-SANCTIONS, E-SAS-AUDIT-FEE, E-COMMON-CATALOG

Preparation / proposed procedure:

1. For each CSMAR requirement, obtain the actual module/table export and data dictionary for the code-read fields, identifier formats, units, year coverage, and version. Keep the separate BS, IS, CFD, industry, trading-company, daily/weekly/monthly price, CG_Capchg, FR_T6, FN_Fn020, old-balance-sheet, violation, FIN_Audit, audit/CPAS, FN_Fn025, and SPT products; do not substitute Compustat, CRSP, SDC, SEC, or other unrelated resources.
2. Confirm the CSMAR tables’ actual code/firm identifier and date semantics before merges, including Stkcd versus code, Accper/Reptdt, report-type filters, and the different daily, weekly, and monthly fields.
3. Use only a permitted native account or exact user-approved local input. The frozen catalog search is discovery only and does not establish absence of access or licensing.

Validation to perform later:

- After an authorized run, compare every CSMAR input’s imported column names/types and required date coverage with its SAS read and join keys.

### A-MANUAL-AUTHOR-INPUTS: Obtain the exact author-prepared manual workbooks and their field/sheet contracts for supplemental financial values, ownership, auditor/firm locations, exchange rates, and regional corruption.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-HAND-LAG, R-SOE, R-FX, R-AUDITOR-LOCATION, R-FIRM-LOCATION, R-CORRUPTION, R-OWNER-ATTRIBUTES, R-OWNER-FIRM-MAPPING, I-RAW-CONTRACTS
Evidence: E-SAS-LAG-SUPPLEMENTS, E-SAS-SOE, E-SAS-AUDIT-FEE, E-SAS-AUDITORS, E-SAS-FIRM-LOCATION, E-SAS-CORRUPTION, E-SAS-OWNER-ATTRIBUTES, E-DATASHEET-HURUN, E-PACKAGE-MEMBERS

Preparation / proposed procedure:

1. Obtain both lagsale_lagta_etc workbooks with Sheet$ schemas; confirm key/value columns and how the two year blocks supplement rather than replace the CSMAR statements.
2. Obtain SOE.xlsx, audlocation, listed_firm_location, rich_share_pos.xlsx, and the author’s exact currency-rate file. Preserve the separate variable definitions and manual corrections; obtain worksheets, field dictionaries, keys, and coverage for each.
3. For Corrupt.xlsx, obtain the exact Procuratorial Yearbook edition/pages and sheet-to-measure/year mapping for provincial persons, cases, and employment before repeating SAS transpose and ratio construction.
4. Obtain the author-coded controller-to-public-firm crosswalk with entry/until/classify and family/person IDs; annual reports and prospectuses are source evidence but do not replace the specific author mapping.

Validation to perform later:

- For each workbook/table, confirm the exact source columns, worksheet names, key uniqueness, units, year coverage, and output variable definitions against the SAS merge/transpose steps.

### A-HURUN-LISTS: Preserve both supplied Hurun input branches: top-200 treatment construction for 1999–2012 and the combined 1999–2014 ranks required for non-top-200 falsification.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R-HURUN-MAIN, R-HURUN-FALSIFY, R-OWNER-FIRM-MAPPING, I-RAW-CONTRACTS
Evidence: E-DATASHEET-HURUN, E-SAS-HURUN-MAIN, E-SAS-FALSIFICATION, P-HURUN-2008, P-HURUN-2012, P-HURUN-2013, P-HURUN-2014

Preparation / proposed procedure:

1. Obtain the 1999–2007 source from the cited book or exact author-prepared file and all datasheet-listed yearly rank inputs for 2008–2014. The inspected Sina pages establish only candidate ranked-list sources for selected years.
2. Obtain the author-prepared 1999–2012 and 2013–2014 workbooks with rank, wealth, year, identity/family codes, birthyear where used, and source field for the later workbook. Confirm rank coverage through 600 for every year used in the falsification branch.
3. Keep the `namecode`/`familycode2` identity codes and separate code_namecode firm-control crosswalk aligned. Do not infer/replace missing identity or control mappings from a partial public list page.

Validation to perform later:

- Confirm unique person/family-year records, rank range, rank top-200 versus 201–600 coverage, and stable identity/crosswalk joins across all years before SAS sample construction.

### A-DATAGO-CONTRACT: Resolve the native Datago data extract and sentiment-measure contract used by the press coverage analyses.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-DATAGO-NEWS, I-NEWS-COVERAGE, I-RAW-CONTRACTS
Evidence: E-DATASHEET-AUDIT-NEWS, E-SAS-DATAGO, E-ORIGINAL-SAS-ENCODING, E-COMMON-CATALOG

Preparation / proposed procedure:

1. Obtain the actual Datago extract and schema, its byte encoding, and provider definitions for Top_Ment_Stkcd, publication date, All_Mentioned_Stkcd, News_Id, and Overall_Senti_Score, including the Chinese-news sentiment scoring rules and source population.
2. Confirm the datasheet’s 1998–2014 coverage against the SAS `year<=2016` filter and document which rows are required by the final through-2014 panel and positive-news lead/lag measures.
3. Retain the author’s mention-count threshold (<=4), sentiment-sign definitions, and annual count/share construction. Do not replace with generic SEC, LM, or non-Chinese news data.

Validation to perform later:

- Before analysis, verify the incoming file encoding and imported field mapping against the provider contract, then confirm annual news/positive/negative counts over the exact required period.

### A-SAS-STARTUP-COMPONENTS: Prepare a session-compatible SAS source working copy and verify SAS startup, required product components, and file I/O.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I-SAS-STARTUP, I-SAS-COMPONENTS, I-SAS-ENCODING, SW-SAS, SW-SAS-DTA-EXPORT, SW-SAS-ETS, SW-SAS-PCFILES, SW-SAS-STAT
Evidence: E-ENVIRONMENT-PROBE, E-SAS-PROC-EXPAND, E-SAS-PROC-STAT, E-SAS-PSM-LOGISTIC, E-SAS-PLACEBO-SURVEYSELECT, P-SAS-EXPAND, P-SAS-SURVEYSELECT, P-SAS-PCFILES, E-ORIGINAL-SAS-ENCODING

Preparation / proposed procedure:

1. Create a working copy of the supplied SAS source. Decode its verified GBK bytes and encode to UTF-8 or another chosen SAS-session-compatible encoding; round-trip-check the Chinese literals and path against the original inspection, and leave the original source unchanged. This is deterministic source preparation and does not establish the incoming Datago CSV encoding.
2. In a separately authorized runtime session, resolve the recorded TKELS startup failure and establish an active SAS version/session without inferring missing entitlement from the probe.
3. Verify SAS/ETS for PROC EXPAND, SAS/STAT for PROC REG/GLM/LOGISTIC/SURVEYSELECT, and the required Base SAS procedures/macros. Verify SAS/ACCESS PC Files and the author’s DBMS=EXCEL `.xls`/`.xlsx` calls on the actual host; only if the current engine is unsupported, use the documented platform-supported reader while preserving sheet/range, GETNAMES, MIXED, SCANTEXT, date, and variable-name semantics across every affected import.
4. Verify `PROC EXPORT DBMS=STATA` for all six output files.

Validation to perform later:

- Confirm the source working-copy round trip, SAS startup/version and product status; perform bounded, authorized checks of exact workbook and Stata-DTA interfaces before a full author-code run.

### A-TTABLE2-SETUP: Provide the exact ttable2 command used by the Table 4 univariate comparison.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I-TTABLE2, SW-TTABLE2
Evidence: E-STATA-TTABLE2, E-TTABLE2-PROBE

Preparation / proposed procedure:

1. Locate the exact author-compatible ttable2 distribution and make the command available on the Stata adopath in the authorized run environment.
2. Keep the existing ttable2 command, variables, and grouping option until a compatible implementation is verified; do not silently substitute a different test/table command.

Validation to perform later:

- Run `which ttable2` in the target Stata session, then verify its Table 4 output variables and treatment/control grouping.

### A-PATH-ROOTS: Rebase the complete supplied SAS/Stata workflow to one coherent host-visible project root while retaining the separate CSMAR source library roots.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I-PATHS
Evidence: E-SAS-TRDCO, E-SAS-DAILY-TQ, E-SAS-WEEKLY-STOCK, E-SAS-MAIN-EXPORT, E-STATA-ENTRY, E-STATA-MATCH-CONSUMERS, E-STATA-PLACEBO-CONSUMER, E-STATA-FALSIFICATION-CONSUMER

Preparation / proposed procedure:

1. In a working copy, map the SAS `rich` library and all [redacted-path-f89e5d2a542f] paths to a writable project root under a relative path or `[redacted-path-2e4a1c6a9a42]`; separately map the daily, weekly, and monthly [redacted-path-e4637297c603] library roots to their verified data locations.
2. Update every supplied SAS read/write in the exact external dependency lines D0001–D0021, D0025–D0034, D0036, D0038–D0039, D0041–D0042, D0056–D0062, plus SAS `libname` roots; make all six exported DTA paths resolve under the same project output root.
3. Update Stata `cd` and every `use` for reg1_main through reg6_falsify to that exact output root. Keep distinct inputs/outputs and use only host-visible relative or `[redacted-path-2e4a1c6a9a42]` paths in batch wrappers; do not embed an absolute Dropbox path.

Validation to perform later:

- Before execution, verify all input paths are readable and output paths writable from the host wrapper, and compare every SAS producer path to its Stata consumer path by dependency ID.

### A-ORDERED-PROCEDURE: Run the entire supplied program sequence in its authored order after source inputs, paths, and required software setup are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E-SAS-OUTPUT-HEADER, E-STATA-OUTPUT-HEADER, E-SAS-MAIN-EXPORT, E-SAS-MATCH-TA, E-SAS-MATCH-TA-ROA, E-SAS-MATCH-PSM, E-SAS-PLACEBO, E-SAS-FALSIFICATION, E-STATA-ENTRY, E-STATA-MATCH-CONSUMERS, E-STATA-PLACEBO-CONSUMER, E-STATA-FALSIFICATION-CONSUMER

Preparation / proposed procedure:

1. Run SAS_code_submit.sas from the top in a stable writable project root. First build the base `findata` panel, save/reload `rich.findata_temp`, construct `rich.rich`/`rich.control`/`rich.findata`, and export reg1_main.dta.
2. Continue the same SAS run through the Table 1 descriptive-statistics branch, exact matching by TA (reg2_match_TA), exact matching by TA and ROA (reg3_match_TA_ROA), PSM (reg4_match_PSM), placebo (reg5_placebo), and non-top-200 falsification (reg6_falsify). Preserve each branch and the rich/control/findata SAS library intermediates.
3. After all six DTA producers have succeeded, run STATA_code_submit.do from the top: consume reg1_main for the main regressions and tables, reg2/reg3/reg4 for the three Table 7 matching columns, reg5 for the placebo branch, and reg6 for the falsification and Table 3 Panel B branches. The Stata Appendix block reuses reg1_main.

Validation to perform later:

- In an authorized run, confirm each of the six SAS DTA exports exists and contains the actual columns read by its Stata branch; record logs and check the generated outputs. For later publication comparison, note that the supplied Stata sanction/regulatory-risk block labels its output Table A1, while online appendix Table A1 describes a distinct rich-list prediction model; this crosswalk is not a prerequisite to running the supplied block, and no prediction model is reconstructed.


## Remaining issues and prerequisites

- I-RAW-CONTRACTS [unresolved; full_pipeline]: The supplied SAS workflow reads 31 distinct external input products/files: native CSMAR statement/market/audit modules, Datago sentiment data, author-manual workbooks and crosswalks, and a yearbook-derived workbook. None are in this ZIP. Product-specific field names are traced from the source, but exact source contracts, IDs, formats, period coverage, and compatible routes remain unresolved; catalog misses do not establish absent access or licensing.
- I-NEWS-COVERAGE [unresolved; full_pipeline]: The datasheet describes Datago data for 1998–2014, while SAS filters the imported news data through year<=2016. The final panel is through 2014; the incoming CSV encoding, source-vendor field/sentiment contract, and reason for the extra two years are unresolved. This input contract is distinct from the known GBK encoding of the SAS source code.
- I-SAS-STARTUP [unresolved; full_pipeline]: The frozen SAS empty-session probes fail with a TKELS initialization error before establishing a SAS session. This does not show that a SAS license or any product component is absent.
- I-SAS-COMPONENTS [unresolved; full_pipeline]: The workflow requires SAS/ETS PROC EXPAND, SAS/STAT PROC REG/GLM/LOGISTIC/SURVEYSELECT, Excel/CSV import, and Stata DTA export. Product/component availability and DBMS=EXCEL compatibility on the local SAS platform are unverified.
- I-SAS-ENCODING [preparation; full_pipeline]: The source bytes are verified as GBK and contain Chinese literals and a Chinese Datago filename. A GBK-to-UTF-8 or other session-compatible conversion on a working copy is deterministic preparation; round-trip-check the literals and path and leave the original unchanged. SAS startup and session/component availability are assessed separately under I-SAS-STARTUP and the SAS software records.
- I-PATHS [preparation; full_pipeline]: Both programs hard-code Windows E: paths. The SAS path tree distinguishes the richlist project root from daily, weekly, and monthly CSMAR libraries, and Stata reads outputs under the project root. A consistent writable host-visible relative or [redacted-path-2e4a1c6a9a42] mapping has not been prepared.
- I-TTABLE2 [preparation; full_pipeline]: The exact ttable2 command required by the Table 4 branch was not found in the checked default/shared Stata adopaths; no distribution/source was verified.
- R-BS [undetermined]: CSMAR annual consolidated balance-sheet data read as rich.bs; SAS uses these fields for control variables, lagged balances, NOA, tax inputs, and several downstream measures.
- R-IS [undetermined]: CSMAR annual consolidated income-statement data read as rich.is; SAS uses sales, operating income, and net-income fields.
- R-CFD [undetermined]: CSMAR annual consolidated direct-method cash-flow data read as rich.cfd; used for operating cash flow and discretionary-accrual construction.
- R-INDUSTRY [undetermined]: CSMAR FI_T10 industry classification used to join and fill the annual firm-industry panel.
- R-LISTING [undetermined]: CSMAR TRD_Co company/trading table supplies listing date, industry, and market type for the base panel.
- R-HAND-LAG [undetermined]: Two jointly required author-collected opening-balance workbooks supplement missing CSMAR values for lagged assets, sales, receivables, and inventory.
- R-DAILY-PRICE [undetermined]: Six jointly required CSMAR daily stock-price shards supply annual closing prices used in Tobin Q.
- R-SHARES-OUTSTANDING [undetermined]: CSMAR CG_Capchg supplies total shares outstanding jointly with the daily closing price to calculate Tobin Q after 1998.
- R-TQ-OLD [undetermined]: CSMAR FR_T6 supplies the directly reported Tobin Q measure for years through 1998.
- R-WEEKLY-STOCK [undetermined]: CSMAR TRD_Week weekly stock returns and market values are required to construct stock-specific synchronicity.
- R-WEEKLY-MARKET [undetermined]: CSMAR TRD_WeekCM weekly market return series is jointly required with TRD_Week to estimate synchronicity.
- R-DATAGO-NEWS [undetermined]: Datago Chinese news data are used to derive firm-year news counts, negative and positive sentiment counts, sentiment shares, and log outcomes.
- R-SEO [undetermined]: Author-coded CSMAR RS_Capc data are used to construct SEO and a one-year lead in the supplied SAS preparation branch.
- R-FIXED-ASSET-FOOTNOTES [undetermined]: CSMAR FN_Fn020 footnote data supply fixed assets for DACC after 2006; Chinese item-description values are filtered in SAS.
- R-OLD-FINANCIALS [undetermined]: CSMAR old balance-sheet database supplies fixed assets and impairment items through 2006 and for early-year tax variables.
- R-SANCTIONS [undetermined]: CSMAR STK_Violation_Main data are used to classify firm-year accounting/disclosure violations and create sanction.
- R-SOE [undetermined]: Author-cleaned SOE workbook from CSMAR is required for SOE controls and state-asset acquisition partitions.
- R-AUDIT-FEE [undetermined]: CSMAR FIN_Audit data supply annual audit opinions and fees used in the main outcomes.
- R-FX [undetermined]: A separate exchange-rate file is jointly required to translate HKD/USD audit fees into RMB.
- R-AUDITOR-COMPANY [undetermined]: CSMAR audit table supplies auditor names and firm-level auditor-code fields used for size/rank and switch measures.
- R-CPA-IDENTITIES [undetermined]: CSMAR CPAS data supply individual CPA identifiers and multi-CPA annual firm assignments for auditor fixed effects and switches.
- R-AUDITOR-LOCATION [undetermined]: Manually collected auditor-location data are required to create the nonlocal variable.
- R-FIRM-LOCATION [undetermined]: Manually collected listed-firm province data are required for regional corruption matching.
- R-CORRUPTION [undetermined]: Provincial corruption measures are constructed from three annual measures in Corrupt.xlsx, attributed to China Procuratorial Yearbooks.
- R-IMPAIRMENT [undetermined]: CSMAR FN_Fn025 reserve-for-asset-impairment data are required for the deferred-tax/impairment component of ETR.
- R-SPECIAL-TREATMENT [undetermined]: CSMAR SPT_Trdchg data are used to derive firm-year ST special-treatment status.
- R-HURUN-MAIN [undetermined]: The 1999–2012 author-prepared Hurun ranking file supplies rank, wealth, list year, coded person/family identities, and birth year for treatment/control construction and Table 1.
- R-OWNER-FIRM-MAPPING [undetermined]: Author-curated identity-to-public-firm/control-period crosswalk is required to identify controlled listed firms, entry/until dates, and classifications.
- R-OWNER-ATTRIBUTES [undetermined]: Author-collected rich_share_pos data jointly provide cash-flow/control rights and entrepreneur/family executive positions for SAS Table 1.
- R-MONTHLY-RETURNS [undetermined]: CSMAR monthly stock market values are required to calculate August firm market value for the Table 1 wealth ratio.
- R-HURUN-FALSIFY [undetermined]: The 2013–2014 Hurun file is jointly required with R-HURUN-MAIN for the non-top-200 falsification rankings.
- SW-SAS [unverified]: The SAS command is present, but the frozen empty-session startup probe fails at TKELS before establishing an active session/version; no entitlement conclusion is supported.
- SW-SAS-ETS [unverified]: The supplied SAS source repeatedly invokes PROC EXPAND for lead/lag series. Official product documentation places EXPAND in SAS/ETS; local component availability is unverified because SAS startup failed.
- SW-SAS-STAT [unverified]: The source actively invokes PROC REG, GLM, LOGISTIC, and SURVEYSELECT. SAS/STAT availability was not established in the failed startup probe.
- SW-SAS-PCFILES [unverified]: The source imports many XLS/XLSX workbooks using DBMS=EXCEL. SAS/ACCESS/Excel driver availability and platform compatibility are unverified; the official 9.4 reference documents separate XLS/XLSX identifiers for Unix.
- SW-SAS-DTA-EXPORT [unverified]: All six analysis datasets are exported with DBMS=STATA; local SAS runtime and DTA export capability were not established.
- SW-TTABLE2 [preparation_required]: The exact ttable2 command invoked for Table 4 is not found in the checked Stata adopaths; locate and provide the exact compatible command before that branch is run.

## Review notes

- All 62 frozen dependency IDs are reviewed exactly once. The 37 external source edges are preserved as 31 product-specific data requirements; same-product daily price shards and the two hand-collected lag files are grouped only where their fields and disposition match. The remaining work-table/macro and six SAS-export edges are documented as generated.
- The SAS header names six Stata datasets and their output tables. The SAS source creates the base panel and every match/placebo/falsification branch; the Stata source consumes all six datasets. No branch was omitted because it is not the main analysis.
- Firm ID.xlsx is only a one-column code identifier list in the bounded probe and is described by the datasheet as final-sample firm IDs. It is not a complete panel or any of the six Stata analysis datasets; no analysis_only scope is supported.
- The common catalog has no CSMAR or Datago candidate. This is a discovery result only and does not establish absent access, entitlement, or licensing; no generic SEC/LM, SDC, Compustat, CRSP, or unrelated substitute is proposed.
- Exact Sina pages listed in the datasheet were inspected for selected years; they confirm public rank-list segments but not the author workbooks, full rank coverage, coded identities, or controller-to-firm crosswalk.
- The supplied Stata sanction/regulatory-risk block is present and can run once its actual inputs, software, and setup are available; its source labels its output Table A1, while the online appendix labels Table A1 as a distinct rich-list prediction model. Treat this as a publication/output crosswalk for interpreting or comparing results after running the supplied code, not as a missing estimator or a prerequisite to execute the block. No prediction model is reconstructed. Other online-appendix analyses remain outside the supplied-code workflow.
- The SAS source encoding is confirmed as GBK with Chinese literals and a Chinese Datago filename. A round-trip-safe GBK-to-UTF-8/session-compatible conversion on a working copy is deterministic preparation; original source bytes and the inspection artifact are preserved. This does not establish the encoding, schema, or provider contract of the incoming Datago CSV, which remains unresolved under its own data requirement.
