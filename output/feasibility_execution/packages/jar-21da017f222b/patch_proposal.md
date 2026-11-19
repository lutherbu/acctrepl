# Patch proposal: jar-21da017f222b

Public Disclosure of Private Meetings: Does Observing Peers’ Information Acquisition Affect Analysts’ Attention Allocation?

DOI: 10.1111/1475-679X.12603

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete supplied Stata workflow in code_RZZ.do, including its preparation stages, all code-defined analysis/table branches, and supporting controls. The supplied identifier files are reference lists, not an analysis-only input route.

Entry points: `code_RZZ.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 4/12603 - Public-Disclosure-of-Private-Meetings-Does-Observing-Peers-Information-Acquisition-Affect-Analysts-Attention-A/rzzdatasheetcodeidentifierandlogfiles.zip",
      "sha256": "4169a08d9c9b094243bf4154163bed3b4700463196f798badcc93cdeeebb5313"
    },
    {
      "path": "JAR-Volume 63/Issue 4/12603 - Public-Disclosure-of-Private-Meetings-Does-Observing-Peers-Information-Acquisition-Affect-Analysts-Attention-A/rzz---online-appendix.pdf",
      "sha256": "0f88eff1f4c41563fe1ebbb484e503a7e704869350c5cfb7dd38251484c44ed3"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "bd2681b4e985a100de6a1a84e4ab6db3e38c9ac1668b14b0817505f082992f8f"
}
```

## Proposed actions

### A_INPUT_CONTRACTS_AND_STAGING: Obtain or stage the exact author-prepared inputs consumed by the driver, with documented source-to-file mappings and field/key/period contracts for each independent table. Preserve the current source-specific forecast, visit, control, event and supporting stages.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FORECAST_CSMAR, R_FORECAST_RESSET, R_FORECAST_CNRDS, R_VISIT_BROKER_PANEL, R_VISITS_QUARTERLY_SEMIANNUAL, R_VISITS_ANNUAL, R_VISITS_ANNUAL_WEEK, R_VISITS_SEMIANNUAL_WEEK, R_CALENDAR_DAY_WEEK, R_CALENDAR_YEAR_WEEK, R_CALENDAR_WEEK_OFFSETS, R_CALENDAR_WEEK_OFFSETS_52, R_CALENDAR_WEEK_QUARTER, R_CALENDAR_QUARTER_OFFSETS, R_SECURITY_REFERENCE, R_ASSET_LEVERAGE, R_ROA, R_MB_Q, R_TRADING_VOLUME, R_SHARES_OUTSTANDING, R_DAILY_STOCK_RETURNS, R_DAILY_MARKET_RETURNS, R_STAR_ANALYST_RANKING, R_OWNERSHIP, R_SOE_STATUS, R_INDUSTRY_CLASSIFICATION, R_EXTRA_CHECK, R_UNDISCLOSED_VISITS_GEM, R_UNDISCLOSED_VISITS_MAIN, R_UNDISCLOSED_VISITS_SUPPLEMENT, R_ANALYST_SCHOOL_NAME_LOOKUP, R_EXECUTIVE_SCHOOL_PANEL, R_ID_UNDERWRITER_LINKS, R_UNDERWRITER_PANEL, R_FIRM_CITY_MAP, R_BROKER_CITY_MAP, R_EARNINGS_ACTUALS, R_ANNUAL_OPENING_PRICE, R_ANALYST_REPORT_WEEK, R_EARNINGS_EVENT_WEEKS, R_MA_EVENT_WEEKS, R_SEO_RIGHTS_EVENT_WEEKS, R_SEO_PUBLIC_EVENT_WEEKS, R_VISIT_INSTITUTION_DETAIL, R_VISIT_TEXT_LENGTH, R_FUND_VISIT_PANEL, I_MISSING_REPLICATION_INPUTS, I_EXTERNAL_INPUT_PRODUCERS_UNSPECIFIED, R_UNCLEAN_ID_YEAR_LOOKUP
Evidence: E_INVENTORY, E_DOC_SOURCES, E_DOC_CSMAR, E_DOC_FORECAST_AND_CSVD, E_CODE_FORECAST_INPUTS, E_CODE_REPORT_DATE_AND_FORECAST_FIELDS, E_CODE_VISIT_COUNTS, E_CODE_REPORT_VISIT_INPUTS, E_CODE_WEEKLY_VISIT_EXTERNAL_INPUTS, E_CODE_WEEK_DATE_MAP, E_CODE_FIRM_WEEK_UNIVERSE, E_CODE_WEEK_OFFSETS, E_CODE_WEEK_OFFSETS52, E_CODE_WEEK_QUARTER_MAP, E_CODE_FINANCIAL_PANEL, E_CODE_DAILY_RETURNS, E_CODE_STAR_ANALYST_SOURCE, E_CODE_EVENT_INPUTS, E_CODE_VISIT_DETAIL_AND_LENGTH, E_CODE_FUND_VISIT_INPUT, E_CATALOG_PROVIDER_ALIAS_MISSES, E_CATALOG_FORECAST_CANDIDATES, E_CODE_UNCLEAN_ID_YEAR_USE_1, E_CODE_UNCLEAN_ID_YEAR_USE_2, E_CODE_DAILY_MARKET_CAP, E_CODE_EVENT_WEEK_KEYS

Preparation / proposed procedure:

1. Request or obtain the three cleaned forecast-provider files separately, plus the annual actual-EPS, opening-price and analyst-report-week lookups; document the common columns, identifier crosswalk, periods and forecast-year alignment.
2. Request the prepared broker-named visit panel and the separate annual and semiannual/quarterly report inputs; retain the distinct annual/semiannual weekly tables and specify source dates, duplicate/overlap rules and the post-2012 CSMAR versus earlier CSVD handoff.
3. Provide the week/year-week/shifted-week/quarter calendars and stock reference table, including the date keys and trading/fiscal-week conventions used by the Stata merges.
4. Provide each accounting, volume, shares, ownership, SOE, industry and daily return input with definitions, units, firm/date keys and complete required history; identify the actual table mappings for each named file.
5. Provide the analyst ranking, school/underwriter/city link inputs, uncertain-visit samples, four event-week tables, report-level text-detail/length tables and fund visit table with their producer or source specifications.
6. For each file without an in-driver producer, supply the exact author-prepared version or the missing upstream preparation steps. Do not substitute identifiers, guessed data or unrelated catalog candidates.
7. Provide the non-clean firm-year update table 不干净id_year_updated.dta or identify its upstream producer, meaning, keys and coverage.

Validation to perform later:

- After authorized files are staged, use bounded format-aware metadata/readability checks and compare each table separately with the consumed field names and join keys documented in the driver.
- Verify each required date/security range and author-prepared transformation from source documentation; a one-row read or catalog count does not establish historical or population coverage.
- Trace every externally prepared table to its producer and confirm that the stage order satisfies its consumers before a later authorized full run.

### A_PORTABLE_ROOT: Use a portable working copy with the selected project root as the current directory.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_PORTABLE_PROJECT_ROOT
Evidence: E_CODE_ROOT

**Proposed edit:** `code_RZZ.do:1–1`
Source SHA-256: `eb05e8a57cb273935c936f954bdab4e6c08ed18018e9731565b569270ce7537c`

Run the unchanged relative input/output names from the prepared working-copy root instead of the author-machine absolute volume path.

Current text:
```
 cd [redacted-path-afc3e230e038]

```

Proposed replacement:
```
 cd "."

```

Preparation / proposed procedure:

1. Prepare an isolated working copy containing the supplied files and all required relative input/output directories.
2. In the working copy only, replace line 1 with cd "."; retain the imported driver unchanged as the source artifact.

Validation to perform later:

- Before any later authorized run, confirm the working directory is the intended project root and that all relative input/output names resolve beneath that working copy.

### A_STATA_ADDON_SETUP: Expose the registered asreg installation in the batch Stata ado path and provide the unavailable add-ons used by the supplied driver.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_ASREG, S_WINSOR2, S_OUTREG2, S_SUM2DOCX
Evidence: E_ENV, E_SUM2DOCX_PROBE, E_CODE_ASREG, E_CODE_WINSOR2, E_CODE_TABLES_1_2, E_CODE_SUM2DOCX

Preparation / proposed procedure:

1. Configure the batch Stata environment to expose the already registered asreg ado path.
2. Install winsor2, outreg2 and sum2docx from their approved package sources in the authorized environment; do not change the estimators or table commands.

Validation to perform later:

- Run bounded version/which metadata checks for each command in the selected batch environment without loading study data.

### A_ORDERED_FULL_WORKFLOW: After the separately documented input, project-root and Stata add-on prerequisites are complete, build the financial-control panel before its first use, then run the complete supplied Stata workflow.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_FINANCIAL_CONTROL_BOOTSTRAP_ORDER
Evidence: E_DOC_CODE, E_CODE_ROOT, E_CODE_FINANCIAL_PANEL, E_D0003_CONSUMER_1, E_D0003_PRODUCER_1, E_CODE_NON_TIMELY_VISITS, E_CODE_DAILY_RETURNS, E_CODE_TABLES_1_2, E_CODE_COEFPLOT, E_CODE_ASREG, E_CODE_WINSOR2, E_CODE_EVENT_INPUTS, E_CODE_SCHOOL_ANALYST_LOOKUP, E_CODE_VISIT_DETAIL_AND_LENGTH, E_CODE_FUND_VISIT_INPUT

Preparation / proposed procedure:

1. Complete A_INPUT_CONTRACTS_AND_STAGING, A_PORTABLE_ROOT and A_STATA_ADDON_SETUP in an isolated working copy first; resolve the 47 distinct input contracts and the required runtime setup before this sequence.
2. Before the first top-to-bottom pass through code_RZZ.do, run its existing financial-control block at lines 577–606 from the selected project root. This block reads the five separately required files Asset_Leverage.dta, ROA.dta, MB_Q.dta, tradingVol.dta and sharesn.dta, then writes 财务数据_new.dta for the earlier consumer at line 233.
3. After that generated panel is present, run the complete, unabridged code_RZZ.do from line 1 in Stata batch mode from the same root. Keep every author stage and branch, including the later lines 577–606 rebuild and all subsequent tables, robustness checks, social-tie, event, text-length and fund branches.
4. Do not claim that a single cold top-to-bottom pass can satisfy the first line-233 use before the later line-606 producer. Do not remove, reorder, substitute, or redesign any analysis branch; if the conditional bootstrap stage cannot be executed as supplied, request author clarification before running the full script.
5. Retain the comprehensive log and generated table files in the working copy for later review.

Validation to perform later:

- Before running the bootstrap block, verify the five input tables and their required join keys/fields have been supplied and staged; confirm the block creates 财务数据_new.dta before line 233 is reached.
- During the subsequent full run, confirm the first line-233 consumer succeeds from the bootstrap output and record the effect of the later in-script rebuild at lines 577–606 without assuming byte identity.
- Use the full log to confirm every code-defined table, robustness, social-tie, event, text-length and fund branch remains in the executed workflow and its expected outputs are captured.


## Remaining issues and prerequisites

- I_MISSING_REPLICATION_INPUTS [unresolved; full_pipeline]: The supplied package inventory contains the driver, documentation, historical log and two identifier lists, but none of the analysis/preparation DTA inputs. The driver consumes many separate provider, calendar, financial, social-tie, event and visit-text tables; fields, keys, period coverage and construction are incompletely documented. The identifier lists are not the analysis panel.
- I_EXTERNAL_INPUT_PRODUCERS_UNSPECIFIED [unresolved; full_pipeline]: Several exact files are consumed without an in-driver producer, including annual/semiannual report visit-week tables, lookup/calendar tables, school and underwriter link panels, event-week tables, and report-text/fund visit inputs. Obtain the author-prepared files or their complete field, key, period and construction handoffs; do not infer that these are generated by the supplied script.
- I_PORTABLE_PROJECT_ROOT [preparation; full_pipeline]: The Stata driver starts by changing into an absolute author-machine volume path. Select a portable working-copy root so relative reads and outputs resolve in an isolated project directory.
- I_FINANCIAL_CONTROL_BOOTSTRAP_ORDER [preparation; full_pipeline]: The first use of 财务数据_new.dta is at line 233, while the supplied driver writes it later at line 606. A fresh line-1-to-end invocation therefore cannot rely on that output at its first consumer. The existing lines 577–606 are the supported producer block and use five separate financial inputs; run that block first as a conditional bootstrap stage after those inputs are supplied, then retain and execute the complete driver.
- R_FORECAST_CSMAR [undetermined]: CSMAR analyst forecast source read as Forecast_CSMAR_clean_全部.dta. The driver uses report publication date, EPS, analyst/broker names and a CSMAR source indicator; exact provider-to-author field mapping, record period and download contract are not supplied.
- R_FORECAST_RESSET [undetermined]: RESSET analyst forecast source appended as 分析师预测_RESSET_clean_全部.dta. Its common cleaned schema, provider field mapping, country/security identifiers and historical coverage are not independently documented.
- R_FORECAST_CNRDS [undetermined]: CNRDS analyst forecast source appended as Forecast_CNRDS_clean_全部.dta. Its common cleaned schema, provider field mapping, country/security identifiers and historical coverage are not independently documented.
- R_VISIT_BROKER_PANEL [undetermined]: Prepared broker-named site-visit records consumed as 访客合并_brokername.dta, with firm id, visit date and institution/broker name used in the driver. The datasheet attributes post-July-2012 site visits to CSMAR and earlier visits to CSVD; source fields, coverage and the combined-file construction are unspecified.
- R_VISITS_QUARTERLY_SEMIANNUAL [undetermined]: Hand-collected semiannual/quarterly-report visit input 季报半年报不干净的调研记录_brokername.dta. Code uses firm id, visit date and institution name, but the hand-collection population, overlap rules and exact source fields are not supplied.
- R_VISITS_ANNUAL [undetermined]: Annual-report visit input 年报不干净的调研记录_brokername.dta, appended separately to semiannual/quarterly records. The code uses firm id, visit date and institution name; its source construction and overlap rules are unspecified.
- R_VISITS_ANNUAL_WEEK [undetermined]: Separately prepared weekly annual-report visit table 年报不干净的调研记录_brokername_week.dta, merged by firm id and year_week in the main sample; no producer appears in the supplied driver.
- R_VISITS_SEMIANNUAL_WEEK [undetermined]: Separately prepared weekly semiannual/quarterly visit table 季报半年报不干净的调研记录_brokername_week.dta, merged by firm id and year_week; no producer appears in the supplied driver.
- R_CALENDAR_DAY_WEEK [undetermined]: Date-to-week lookup week.dta, joined by trddt to assign year_week for report dates and visit/trading dates. Exact calendar conventions and coverage are not supplied.
- R_CALENDAR_YEAR_WEEK [undetermined]: Year-week universe year_week.dta used to construct the Shenzhen firm-week panel by year; row universe, exchange calendar and date boundaries are not supplied.
- R_CALENDAR_WEEK_OFFSETS [undetermined]: Current/shifted week mapping 上下week.dta, merged by year_week to create leads/lags for visit, forecast, return and event windows. Shift conventions and exact fields are not specified.
- R_CALENDAR_WEEK_OFFSETS_52 [undetermined]: 52-week shifted calendar 上下week_前52周.dta used to match forecast years over the past and future windows; exact boundary behavior is unknown.
- R_CALENDAR_WEEK_QUARTER [undetermined]: 每周对应quarter.dta mapping firm-week to quarter for quarterly controls; exact fiscal/calendar convention is not specified.
- R_CALENDAR_QUARTER_OFFSETS [undetermined]: 上下quarter.dta quarter-window lookup used to align adjacent quarterly controls with firm-weeks; exact offsets are not specified.
- R_SECURITY_REFERENCE [undetermined]: 股票信息.dta firm reference table merged by id to identify exchange/listing status and filter the firm-week universe; exact id format, variables and coverage are not supplied.
- R_ASSET_LEVERAGE [undetermined]: Asset_Leverage.dta accounting/control input. The code keeps firm-year records from 2003 and later and uses total assets and total liabilities with id/date/year/quarter fields; source product, units and coverage remain unknown.
- R_ROA [undetermined]: ROA.dta firm accounting return input merged by id and 截止日期 to the financial panel; exact source field definition and reporting coverage are not supplied.
- R_MB_Q [undetermined]: MB_Q.dta valuation input merged by id and 截止日期; code renames 市净率 to MB, but source definition, units and coverage are unspecified.
- R_TRADING_VOLUME [undetermined]: tradingVol.dta quarterly turnover input merged by id and quarter and used as ynshrtrd; unit and source coverage are not specified.
- R_SHARES_OUTSTANDING [undetermined]: sharesn.dta shares input merged by id/year and used as nshrn to scale turnover; exact units and security class rules are unknown.
- R_DAILY_STOCK_RETURNS [undetermined]: Daily stock trading input 日度数据合并.dta used for Dretwd and market-cap-weighted returns; the driver needs firm id, date, daily return and Dsmvtll, but the product, units and history are unspecified.
- R_DAILY_MARKET_RETURNS [undetermined]: 日市场回报率.dta daily market benchmark input merged on date and used through Cdretwdos to form BHAR; benchmark definition, units and coverage are unspecified.
- R_STAR_ANALYST_RANKING [undetermined]: AF_Anarank.dta analyst-award/rank input used to select rank<=3 and create analyst/broker/year star indicators; field definitions and history are not supplied.
- R_OWNERSHIP [undetermined]: ownership.dta firm-year ownership input; the code uses shrcr1 for the first shareholder share, but source definition, units and year coverage are unspecified.
- R_SOE_STATUS [undetermined]: SOE_new.dta firm-year state-ownership indicator merged into the regression panel; construction and period are not supplied.
- R_INDUSTRY_CLASSIFICATION [undetermined]: 公司行业.dta firm-year industry classification used both in regressions and daily industry-return construction; classification system, time mapping and firm identifiers are unknown.
- R_EXTRA_CHECK [undetermined]: 额外check.dta firm-year cross-check used to classify pre-2012 visit records; exact source, indicator meaning and coverage are unspecified.
- R_UNDISCLOSED_VISITS_GEM [undetermined]: 未披露调研信息sample_创业板_updated.dta firm-year sample of firms with uncertain/unreported visits; inclusion rules and fields are unspecified.
- R_UNDISCLOSED_VISITS_MAIN [undetermined]: 未披露调研信息sample_updated.dta firm-year sample of firms with uncertain/unreported visits; inclusion rules and fields are unspecified.
- R_UNDISCLOSED_VISITS_SUPPLEMENT [undetermined]: 未披露调研信息sample_补充.dta supplemental firm-year sample of firms with uncertain/unreported visits; inclusion rules and fields are unspecified.
- R_ANALYST_SCHOOL_NAME_LOOKUP [undetermined]: 证券分析师姓名_整理_reshape.dta analyst name/broker lookup used to join analyst-school records; name normalization, panel years and source are unspecified.
- R_EXECUTIVE_SCHOOL_PANEL [undetermined]: 1.公司高管panel_school.dta firm executive-school-year panel joined by id, school and year; source, school normalization and coverage are unspecified.
- R_ID_UNDERWRITER_LINKS [undetermined]: id_underwriter.dta firm/underwriter-name/business-year linkage table used in firm-analyst business ties; join keys and construction are undocumented.
- R_UNDERWRITER_PANEL [undetermined]: underwriter.dta firm/name/business-year records used in event-level business ties; source and coverage are undocumented.
- R_FIRM_CITY_MAP [undetermined]: 省份与城市.dta firm-to-city lookup merged by id to estimate geographic ties; identifier, city definition and years are unspecified.
- R_BROKER_CITY_MAP [undetermined]: 券商城市.dta broker-name-to-city lookup merged by institution name; name standardization and coverage are unspecified.
- R_EARNINGS_ACTUALS [undetermined]: 0.盈余公告EPS_年度.dta annual actual diluted EPS input matched by firm and forecast year; units, fiscal-year alignment and coverage are unspecified.
- R_ANNUAL_OPENING_PRICE [undetermined]: 年开盘价.dta firm-year opening price input used to scale forecast error; price units, adjustment convention and period are unspecified.
- R_ANALYST_REPORT_WEEK [undetermined]: 分析师报告week.dta report-date/week mapping used to exclude event-week forecasts and identify valid forecast years; key and construction are unspecified.
- R_EARNINGS_EVENT_WEEKS [undetermined]: 盈余公告事件所在周.dta earnings-event firm-week input; code appends it to other events and matches around shifted year_week windows. Event dates and matching rules are unspecified.
- R_MA_EVENT_WEEKS [undetermined]: 兼并收购事件所在周.dta merger/acquisition firm-week input; event source and year_week construction are unspecified.
- R_SEO_RIGHTS_EVENT_WEEKS [undetermined]: 定向增发事件所在周.dta rights/private-placement firm-week input; event source and year_week construction are unspecified.
- R_SEO_PUBLIC_EVENT_WEEKS [undetermined]: 公开增发事件所在周.dta public-offering firm-week input; event source and year_week construction are unspecified.
- R_VISIT_INSTITUTION_DETAIL [undetermined]: 调研机构分类明细表_券商参与.dta detailed visit/institution records, de-duplicated by firm and report id and joined to text-length data; source fields and population are unspecified.
- R_VISIT_TEXT_LENGTH [undetermined]: 文本长度.dta report-level visit-text length joined by id and 报告ID; text definition, language handling and sample coverage are unspecified.
- R_FUND_VISIT_PANEL [undetermined]: Fund-named visit input 访客合并_fundname.dta used in the buy-side joint-visit exclusion branch. The code directly uses firm id and visit date for date-to-week matching; the consumed fund-name fields, source construction and coverage are not spelled out.
- R_UNCLEAN_ID_YEAR_LOOKUP [undetermined]: Unclean firm-year update lookup 不干净id_year_updated.dta is merged by id/year in the regression-sample and full firm-week construction stages. The source, record definition, period and producer are not documented in the supplied driver.
- S_ASREG [preparation_required]: The registered metadata reports asreg available only through its configured Stata ado path; the default path lookup failed. Configure the verified path for the selected batch environment before running.
- S_WINSOR2 [preparation_required]: The registered metadata reports winsor2 unavailable in the default and configured Stata path.
- S_OUTREG2 [preparation_required]: The registered metadata reports outreg2 unavailable in the default and configured Stata path.
- S_SUM2DOCX [preparation_required]: Bounded Stata metadata check reports sum2docx unavailable.

## Review notes

- This is a cumulative update to the populated stage-one draft; the exact prior bytes are preserved read-only at probes/draft_checkpoint_stage1.json.
- All 38 frozen dependency IDs are mapped. Ten are direct external inputs and twenty-eight are generated by the supplied Stata driver; generated classifications cite both producer and consumer lines.
- The input requirements include direct table reads beyond the dependency checklist, including separate annual/semiannual visit-week tables, week/calendar maps, social-tie panels, report/event inputs, visit text and fund records.
- The two packaged DTA files are readable identifier lists (4,003 analyst identifiers and 814 firm identifiers); they do not replace the absent analysis/preparation input tables and are not read by code_RZZ.do.
- Official CSMAR/CNRDS/RESSET pages and local catalog searches are candidate discovery evidence only. No public route is marked verified; no product entitlement, source-to-file mapping, field contract or coverage is inferred from a provider name or a generic landing page.
- Only code_RZZ.do, its documentation, registered metadata, bounded helper probes and named catalog/public metadata were reviewed. No author workflow was executed.
- The screened full read/write inventory also surfaced 不干净id_year_updated.dta as an external id/year input outside the frozen dependency checklist; it is retained as an additional unresolved requirement rather than treated as generated.
- D0003 is an out-of-order generated edge: the driver first reads 财务数据_new.dta at line 233 and only writes it at line 606. The existing lines 577–606 provide the supported conditional bootstrap using five separately identified inputs; a fresh single top-to-bottom run is not claimed to satisfy this first use.
