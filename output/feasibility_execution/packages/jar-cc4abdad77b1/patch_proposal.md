# Patch proposal: jar-cc4abdad77b1

Asymmetric Trading Costs Prior to Earnings Announcements: Implications for Price Discovery and Returns

DOI: 10.1111/1475-679X.12189

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented empirical scope: supplied SAS core construction/analysis and all analyses reported in the online appendix, including separate TAQ, options, event-date, 8-K, leverage and Friday-panel branches.

Entry points: `JohnsonSo_ATC_code.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 1/12189 - Asymmetric-Trading-Costs-Prior-to-Earnings-Announcements-Implications-for-Price-Discovery-and-Returns/js-datasheet-and-code.zip",
      "sha256": "a3eca652a40b3c42015b888dbb49e1e7bef8b63d7bee70560f842c11f49f2afa"
    },
    {
      "path": "JAR-Volume 56/Issue 1/12189 - Asymmetric-Trading-Costs-Prior-to-Earnings-Announcements-Implications-for-Price-Discovery-and-Returns/johnson-so-online-appendix.pdf",
      "sha256": "793c03e969dcfdfb231b991afb902d6c318778f179cc645521807ed29116e61c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "ab011260dad9f69a58c3dfd0971bdcf0f1c938d7447c5e95ba705d7188b7eef6",
  "work_item_sha256": "d11e4c70f3ea1276a082f02ad488f6720bca969c09cd027b4aba6af0b14a6a7a"
}
```

## Proposed actions

### A_WRDS_SETUP_AND_COVERAGE: Establish the supported SAS/CONNECT and WRDS session, set the active MYDIR path, and confirm the exact source vintages, fields, units, identifiers and date coverage for each locally catalogued candidate and WRDS library.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: R_COMPQ, R_COMPNAMESQ, R_COMPFUNDA, R_CCM, R_CRSP_MSP500, R_CRSP_DSF, R_CRSP_DSI, R_CRSP_STOCKNAMES, R_IBES, R_FF_DAILY, S_SAS, I_REMOTE_SETUP, I_SAS_ENV, I_WEEKDAY_OFFSET
Evidence: E_CODE_REMOTE, E_CODE_MYDIR, E_ENV_SAS, E_LOCAL_SAS, E_CODE_FF_FIT, E_APP_TABLE11

Preparation / proposed procedure:

1. Use a supported SAS runtime and confirm SAS/STAT PROC GLM and SAS/CONNECT RSUBMIT/upload/download capability; the recorded TKELS startup error alone does not establish entitlement.
2. Configure the WRDS remote connection and an active MYDIR library path in the user's environment, then confirm each referenced library resolves.
3. For Compustat and IBES, verify underlying data vintages and point-in-time identifiers over the reported 1983-2012 samples; check quarterly lag history, FPI/actual-date fields, annual fundamentals, SIC validity and CCM link-date rules.
4. For CRSP, verify the daily event-window history needed for -60:+30, -41:+41 and -34:+34 windows, CRSP.DSI market returns, name-validity intervals and S&P 500 membership dates.
5. For Fama-French factors, verify date alignment and units for Mkt-RF, SMB, HML, RF and UMD; honor the model's actual -51:+10 fit and -51:-11 baseline despite the broader -262:+41 join.
6. Keep source-level broad filters (1970-2013 and -262:+41) distinct from the reported 1983-2012 event samples and each model's specific history needs.
7. For each CRSP/FF pull, preserve the literal SAS INTCK('WEEKDAY', ActDate, Date) filter and confirm with the authors how its values correspond to reported trading-day windows and observed exchange sessions; do not silently replace the convention.
8. For the factor series, account for the pre-join Mkt-RF lag1-3 construction by confirming predecessor records for each fitted observation; do not infer a calendar start date from the TD bounds alone.

Validation to perform later:

- Record actual source names, vintage, earliest/latest usable dates, required columns and license/session availability.
- Check identifiers, point-in-time link intervals, duplicate keys, merge rates, and the required lag/window observations after author filters.
- Confirm factor units and date matching without executing the author's full program; do not infer population coverage from a row-one probe.
- Compare code-derived INTCK('WEEKDAY') values with the authors' stated event-time convention before treating any offset as an exchange trading-day index.
- Confirm upstream factor records for mktrf lags 1-3 at the earliest fitted rows, while retaining the stated -51:+10 fit and -51:<-11 residual baseline.

### A_AUTHOR_PRODUCERS: Request the authors' exact upstream producers or prepared data definitions for AEPD, Q_PAR24 and mydir.aeprevdpre, including expected variables, keys, filters and ordering, before completing either analysis branch.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_AEPD, I_QPAR24, I_AEPREVDPRE, I_INCOMPLETE_BRANCHES
Evidence: E_CODE_AEPD, E_CODE_BASEDATA, E_CODE_QPAR24, E_CODE_AEPREVD, E_CODE_AEPREVDPRE

Preparation / proposed procedure:

1. Ask whether AEPD is an intended supplied input or an omitted transformation of JSATC_BASEDataSet, and obtain its exact producer and column mapping.
2. Ask which upstream step creates Q_PAR24 and how it is linked into OIYEAR/OIYEARBase; preserve the named variable until authors confirm its construction.
3. Ask for the producer of aeprevdpre and its relationship to the generated aeprevd/ALPALL; obtain the required sample, ordering and variables.
4. Incorporate only the author-confirmed upstream program or compatible prepared data in a future authorized update.

Validation to perform later:

- Trace each confirmed output to a source producer and verify expected columns, identifiers, row keys, sample filters and order before downstream analysis.
- Check that AEPD and AEPREVDPRE are actually available at the exact read locations and that Q_PAR24 is generated before it is retained or filtered.

### A_TAQ_INPUT_AND_CODE: Request authorized TAQ input access and the authors' actual TAQ query and calculation workflow for AOI, effective spreads, ask depth and Table 12 Friday panels.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_TAQ, I_TAQ_CODE, I_FRIDAY_PANEL, I_INCOMPLETE_BRANCHES
Evidence: E_CODE_TAQ_NOTE, E_APP_TAQ, E_APP_TAQ_COSTS, E_APP_FRIDAY

Preparation / proposed procedure:

1. Confirm the exact WRDS TAQ product, tables, date coverage, identifiers, quote/trade timestamps and available sizes for 1993-2012.
2. Request the supplied Lee-Ready order-direction code and the author definitions/aggregation for daily AOI, effective spread and ask depth.
3. Request the code for the Friday firm-week panel, including price-above-$1 prior-week rule, three-month minimum volatility history and full-week nonmissing-price rule.
4. Preserve the event and baseline windows t-51:-11 and t-4:-2 and the appendix sample definitions.

Validation to perform later:

- Verify raw trade/quote timestamps, identifiers, effective-spread and depth variables, and daily aggregation on author-designated observations.
- Reconcile Friday panel row counts and all published sample filters only after authorized input and code are supplied.

### A_OPTIONMETRICS_ACCESS: Confirm an authorized IvyDB US route and obtain the author-compatible historical option file and options-analysis program/specification.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_OPTIONMETRICS, I_INCOMPLETE_BRANCHES
Evidence: E_OPTIONMETRICS, E_APP_OPTION, E_APP_OPTION_WINDOW

Preparation / proposed procedure:

1. Confirm user access and the exact IvyDB US vintage that covers 1996-2012.
2. Obtain the author option filters and identifier mapping for standardized at-the-money call/put pairs with common strike and expiry.
3. Obtain the analysis code or exact calculation specification for the t-4:-2 spread and t-51:-11 firm standardization.

Validation to perform later:

- Verify underlying/date/strike/expiry/option-type fields, implied-volatility availability and required event/baseline days.
- Compare final eligible sample period and counts with the appendix after the source and author rules are confirmed.

### A_REGSHO_MAPPING: Confirm the treatment-list files, extension dates and CRSP/event-identifier mapping used in the authors' 2005-2007 Reg SHO test.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_REGSHO, I_INCOMPLETE_BRANCHES
Evidence: E_SEC_SHO, E_APP_SHO

Preparation / proposed procedure:

1. Obtain the exact pilot-category list and any applicable extension orders covering the study's 2005-2007 window.
2. Obtain the author mapping from security identifiers to event firms and the date logic for temporary exemptions.
3. Keep the SEC's documented original pilot period separate from the paper's 2005-2007 sample until authors confirm treatment timing.

Validation to perform later:

- Check treatment assignments against the author-defined sample dates and identifier mapping, including boundary dates and extensions.

### A_MIA_INPUT_AND_METHOD: Request the MIA firm-day dataset or the authors' exact Johnson and So (2016a) source fields, computation code and compatibility specification.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_MIA, I_MIA_METHOD, I_INCOMPLETE_BRANCHES
Evidence: E_APP_MIA, E_APP_MIA_INPUTS

Preparation / proposed procedure:

1. Ask whether the authors used a prepared MIA series or constructed it from raw stock and options volume, and obtain the exact product, fields and aggregation period.
2. Request the estimator/code, identifier mapping, sample exclusions and the t-51:-11 standardization procedure.

Validation to perform later:

- Confirm one row per firm-day or author-defined key, period coverage from 1993 through 2012, units and match rate to earnings dates.
- Reproduce only the documented transformation and compare to author-provided checkpoints or table sample counts.

### A_WSH_DATA_AND_PERIOD: Confirm the exact Wall Street Horizon historical earnings-date product and archive, obtain authorized records, and resolve the appendix's conflicting Table 6 endpoints.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_WSH, I_WSH_PERIOD, I_INCOMPLETE_BRANCHES
Evidence: E_WSH_PUBLIC, E_DATASHEET_WSH, E_APP_WSH_NARRATIVE, E_APP_WSH_TABLE

Preparation / proposed procedure:

1. Ask which WSH historical dataset and snapshot/vintage the authors used, and confirm access to historical expected dates and public-verification status/timestamps.
2. Resolve whether the intended sample is 2006-2012 as stated in the narrative or 2006-2014 as stated in the Table 6 caption.
3. Obtain author rules for the five-trading-day public-verification cutoff and event-date/identifier matching.

Validation to perform later:

- Verify product coverage and status/timestamp fields against the selected period.
- Reconcile event counts and the narrative/table period after authors confirm the target sample.

### A_8K_EVENT_DATA: Verify the local WRDSSEC candidate or another authorized filing source against the authors' 1993-2012 8-K event definition and obtain the event-exclusion workflow.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_8K, I_INCOMPLETE_BRANCHES
Evidence: E_LOCAL_SAS, E_CATALOG, E_SEC_EDGAR, E_APP_8K, E_APP_8K_PERIOD

Preparation / proposed procedure:

1. Confirm which local ITEMS8K date field represents the authors' filing date and whether the local product covers 1993-2012 completely.
2. If using SEC indexes, establish a documented source for 1993 because the published indexes begin in 1994Q3; do not assume the later index period covers the missing year.
3. Obtain the author's filing deduplication, firm mapping and ten-day earnings exclusion code.

Validation to perform later:

- Check filing form, CIK, filing date, accession uniqueness and date coverage against author definitions.
- Verify the earnings-window exclusion and only then compare the resulting 1993-2012 sample to the appendix count.

### A_REPO_AND_LEVFAC: Identify the exact weekly New York Fed financing series and determine whether and how it yields the appendix's quarterly LevFac variable, including the 1993-1997 history gap.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_FRBNY_REPO, R_LEVFAC, I_FRBNY_LEVFAC, I_INCOMPLETE_BRANCHES
Evidence: E_DATASHEET_REPO, E_APP_LEVFAC, E_NYFED_PUBLIC

Preparation / proposed procedure:

1. Request the authors' exact February 2015 downloaded series, source fields, transformation code and seasonal adjustment for Table 8.
2. Clarify whether the weekly repo source is the input for LevFac or whether a separate Adrian, Etula, and Muir dealer-leverage series is required.
3. Identify a verified source for the 1993-1997 period, because the current official Primary Dealer Statistics page begins in 1998.

Validation to perform later:

- Verify source-series dates, aggregation to quarterly values, seasonally adjusted log-change calculation, within-year quartile ranking and reported 1993-2009 sample period.

### A_TABLE10_SOURCE: Ask the authors to identify the non-WRDS Table 10 source and supporting program or confirm whether it reuses previously described data; obtain the precise ALP t-6:-2 branch.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_TABLE10_SOURCE, I_INCOMPLETE_BRANCHES
Evidence: E_DATASHEET_WRDS, E_APP_TABLE10, E_DATASHEET_MAIN_PAPER

Preparation / proposed procedure:

1. Clarify why Table 10 is the datasheet's only exception to WRDS and identify its specific source, product and data file.
2. Obtain the Table 10 calculation program and any omitted sample, input, or variable definitions from the referenced main-paper Sections 3 and 4.

Validation to perform later:

- Confirm that the identified source and program reproduce the documented t-6:-2 alternative ALP window without changing the stated sample or estimand.


## Remaining issues and prerequisites

- I_REMOTE_SETUP [unresolved; full_pipeline]: The initial RSUBMIT block assumes an existing WRDS connection and leaves MYDIR as a commented example. The active MYDIR assignment appears only in the later ALP block, so the core remote library/path setup is not self-contained.
- I_SAS_ENV [unresolved; full_pipeline]: The bounded local SAS probe fails during TKELS initialization before reporting a version. This leaves SAS, SAS/CONNECT for RSUBMIT and SAS/STAT for PROC GLM unverified; the diagnostic does not establish a missing license.
- I_AEPD [unresolved; full_pipeline]: The basic analysis reads AEPD, but no AEPD producer appears in the complete SAS source. The program instead constructs and downloads JSATC_BASEDataSet; its compatibility with AEPD is not documented.
- I_QPAR24 [unresolved; full_pipeline]: OIYEAR is built from EAFile identifiers and return fields, but OIYEARBase keeps Q_PAR24 and later filters on it. No producer for Q_PAR24 appears in the supplied source; no proxy or replacement is assumed.
- I_AEPREVDPRE [unresolved; full_pipeline]: The code creates mydir.aeprevd and downloads it as ALPALL, then a later macro reads mydir.aeprevdpre to produce ALPSUM. No producer for aeprevdpre appears in the file.
- I_TAQ_CODE [unresolved; full_pipeline]: The authors state that TAQ buy/sell imbalance code is not posted. The package does not supply the intraday Lee-Ready construction for AOI, effective spreads and ask depth, so the documented TAQ analyses cannot be reproduced from the supplied program alone.
- I_INCOMPLETE_BRANCHES [unresolved; full_pipeline]: The package includes core SAS construction and partial analysis blocks, but not code/data closure for the appendix options, Reg SHO, MIA, WSH, 8-K, broker-dealer leverage and Friday-effects analyses. The datasheet also points to missing main-paper Sections 3 and 4. The CUSIP file is only an identifier list, not a prepared-data bypass.
- I_WSH_PERIOD [unresolved; full_pipeline]: The appendix narrative gives 2006-2012 for Wall Street Horizon tests, while the Table 6 caption reports 2006-2014. The exact vendor archive, verification definition and intended sample endpoints need author confirmation.
- I_TABLE10_SOURCE [unresolved; full_pipeline]: The datasheet says Table 10 is the exception to the WRDS data route but names no alternative source or workflow. The appendix describes a t-6 to t-2 ALP window, and the referenced main-paper sections are not included.
- I_MIA_METHOD [unresolved; full_pipeline]: MIA is defined as a firm-day fraction based on stock and options trading volumes following Johnson and So (2016a), but this package supplies neither the MIA file nor its calculation program and fields.
- I_FRBNY_LEVFAC [unresolved; full_pipeline]: The datasheet names weekly New York Fed repo/financing data, while Table 8 describes a seasonally adjusted log change in broker-dealer leverage over 1993-2009. The current NY Fed page begins in 1998 and does not establish the pre-1998 observations or the transformation from repo data to LevFac.
- I_FRIDAY_PANEL [unresolved; full_pipeline]: Table 12 requires a Friday-effects firm-week panel at the CRSP/Compustat/TAQ intersection for 1993-2012, with prior-week price above $1, at least three prior months of prices and nonmissing prices for every day in the week. No panel construction or output code is supplied.
- I_WEEKDAY_OFFSET [unresolved; full_pipeline]: The SAS program defines TD with INTCK('WEEKDAY', ActDate, observation date) and applies event filters to that value. The source does not establish that this weekday-interval convention corresponds to exchange-session/trading-day indices or the appendix's externally reported TAQ/options windows; do not silently substitute another calendar convention.
- R_COMPQ [undetermined]: Compustat Quarterly earnings and fundamentals for reported event samples beginning in 1983 and continuing through 2012 (Table 11); the source code's 1970 RDQ and 1970-2013 linked-event filters are broader than the reported sample. CVOL uses up to eight prior ROA observations. QAE is current EPS less EPS four quarters earlier and its standardization uses up to eight prior QAE values (full uninterrupted QAE history can reach twelve quarters before the focal event; the code allows up to four missing prior QAE values).
- R_COMPNAMESQ [undetermined]: Compustat NamesQ SIC classification joined by GVKEY for the event sample (reported events 1983-2012); active date/history validity remains to be checked.
- R_COMPFUNDA [undetermined]: Annual Compustat fundamentals joined through GVKEY and link-date criteria to supply CIK/TIC, AT, SALE and CUSIP for event-year construction; reported analysis history spans 1983-2012, while code event filters extend 1970-2013.
- R_CCM [undetermined]: CRSP/Compustat CCM historical link records and validity windows to map GVKEY to PERMNO for the event history; point-in-time link validity for the reported 1983-2012 sample must be confirmed.
- R_CRSP_MSP500 [undetermined]: CRSP S&P 500 membership history used to flag membership on each announcement date; membership dates must overlap the 1983-2012 event history.
- R_CRSP_DSF [undetermined]: CRSP daily stock file with prices, returns, volume, shares, bid/ask and opening price for reported 1983-2012 event samples. The supplied SAS code selects INTCK('WEEKDAY', ActDate, Date) values -60:+30; baseline-turnover and ALP branches also use -41:+41 and -34:+34. These are code-defined weekday-interval offsets, not verified exchange-session indices. The paper describes its external event windows in trading-day terms; correspondence to the code offsets and actual market sessions remains unresolved. Preserve the literal code convention pending author clarification.
- R_CRSP_DSI [undetermined]: CRSP Daily Index market return VWRETD joined to DSF by calendar date for the supplied code's SAS INTCK('WEEKDAY') offsets -60:+30 and additional baseline/ALP offsets over reported 1983-2012 events. Those values are not shown in the source to be exchange-session indices; preserve the literal code convention and verify its correspondence to paper-reported windows.
- R_CRSP_STOCKNAMES [undetermined]: CRSP Stocknames validity intervals and first CRSP date used to derive firm age and exchange code for reported 1983-2012 events.
- R_IBES [undetermined]: IBES Summary Statistics EPS forecasts and actuals, including FPI=6 quarterly announcement forecasts and the FPI=1 standard-deviation comparison, with CUSIP/ticker, period, stats, actual date/time and sufficient 1983-2012 sample coverage. The code's ANNDATS_ACT >= 1970 filter is broader than reported sample years.
- R_FF_DAILY [undetermined]: Daily Fama-French market, SMB, HML and RF factors plus momentum UMD, joined by date to CRSP for the idiosyncratic-volatility branch. The program sorts the factor series and computes mktrf lags 1-3 before the event join (lines 559-565). The join filters SAS INTCK('WEEKDAY') TD values -262:+41, while GLM uses TD -51:+10 and the residual baseline is -51 to before -11. The fitted rows therefore also rely on upstream factor predecessor records for the lagged regressors; the exact minimum calendar start/history cannot be inferred from these relative filters alone, and the TD values are not verified exchange-session indices.
- R_TAQ [undetermined]: NYSE TAQ intraday trades and quotes for Lee-Ready daily order imbalance, effective spreads, quoted ask depth and the Friday firm-week panel; reported TAQ analyses cover 1993-2012 and retain the appendix's stated t-51:-11 baseline and t-4:-2 event windows. Correspondence of those paper-reported trading-day windows to the SAS INTCK('WEEKDAY') offsets and to actual TAQ sessions is unverified. The supplied code explicitly omits the imbalance calculation.
- R_OPTIONMETRICS [undetermined]: IvyDB US daily option observations with matched standardized at-the-money call and put options, common strike and expiration, implied volatility and underlying identifier for the reported 1996-2012 options sample. Retain the appendix's stated t-4:-2 event window and t-51:-11 standardization window; correspondence to SAS INTCK('WEEKDAY') offsets and actual exchange sessions is unverified.
- R_REGSHO [undetermined]: SEC Reg SHO pilot treatment/status data mapped to event firms for the 2005-2007 earnings announcement test; treated securities are temporarily exempt from the bid-test/uptick rule.
- R_MIA [undetermined]: A firm-day MIA series or the author-specified inputs and program to construct it for 1993-2012, using observed stock and options trading volumes; the appendix standardizes MIA over t-51:-11 and reports a 39,388-announcement sample.
- R_WSH [undetermined]: Wall Street Horizon expected earnings dates and public-verification event history for the appendix's Table 6; narrative says 2006-2012 but the table caption says 2006-2014. The author definition requires verification at least five trading days before the actual announcement.
- R_8K [undetermined]: 8-K filing event records and filing dates mapped to firms, 1993-2012, excluding all filings within 10 days of quarterly earnings; the appendix reports 161,051 observations.
- R_FRBNY_REPO [undetermined]: Weekly aggregate repurchase-agreement/financing data used for the Table 8 supplement, with a February 2015 author download. The appendix reports 1993-2009 events; exact source series and whether the repo data produce LevFac are unresolved.
- R_LEVFAC [undetermined]: Quarterly broker-dealer leverage factor (LevFac), defined as the seasonally adjusted log change in broker-dealer leverage and sorted into within-year quartiles for 1993-2009 Table 8 tests. The supplied package does not specify a complete data file or transformation mapping from the datasheet's weekly repo series.
- S_SAS [unverified]: The author program requires SAS DATA/PROC SQL/SUMMARY/TRANSPOSE/UNIVARIATE operations, PROC GLM, macros, remote RSUBMIT and SAS/CONNECT upload/download. Local runtime probe failed at TKELS initialization before version/capability checks; SAS/STAT and SAS/CONNECT availability is unverified.

## Review notes

- Expanded checkpoint after complete datasheet, supplied 1,168-line SAS program, online appendix and exact author package review. The source package includes the CUSIP final-sample identifier list but no prepared analysis dataset; the source code does not read that list, so no analysis_only scope is supported.
- All 544 frozen dependency IDs are assigned exactly once. External raw reads directly observed but omitted by the parser checklist—COMP.FUNDA, CRSPA.CCMXPF_LINKTABLE and CRSP.DSI—are included as mandatory requirements from the actual source lines 318, 311 and 374, with no invented dependency IDs.
- The local SAS row-one probe proves only path readability and column presence. It records one sampled row, not file totals, population or historical coverage; local versions, product vintage, units and identifier/date compatibility remain unverified.
- SAS runtime probe failed with the recorded diagnostic ERROR: TK Could not Initialize; Launch: Launch Service Load Failure; ERROR: The TKELS extension could not be loaded. This does not establish missing SAS entitlement. No SAS startup troubleshooting or author code execution was performed.
- Do not equate broad code filters with study minimum history or assume SAS TD values are market sessions: supplied code filters IBES/linked events from 1970-2013 and uses SAS INTCK('WEEKDAY', ActDate, Date) for CRSP/factor relative offsets; the FF join spans TD -262:+41, while GLM uses -51:+10 and the residual baseline -51 to before -11. The factor series also creates Mkt-RF lag1-3 before joining, so predecessor factor records are needed and the exact minimum calendar start is unresolved. Appendix Table 11 reports samples beginning in 1983, and external TAQ/options windows are retained as reported pending confirmation of their mapping.
- Official-source checks are candidate-route evidence only. SEC EDGAR indexes begin at 1994Q3; NY Fed Primary Dealer Statistics page begins at 1998; original Reg SHO pilot dates end in 2006 while the paper reports 2005-2007; WSH historical availability varies by dataset. None resolves the authors' exact historical vintage or mappings.
- No route is marked verified. No exact output was run and no study regression or independent reconstruction was attempted.
