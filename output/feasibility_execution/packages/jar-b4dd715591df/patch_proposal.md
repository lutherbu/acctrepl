# Patch proposal: jar-b4dd715591df

Generative AI Use by Capital Market Information Intermediaries: Evidence from Seeking Alpha

DOI: 10.1111/1475-679X.70053

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full author workflow over the three Python notebooks and Stata do-file. The unchanged SA_setup.py is a support module placed at the documented import path in a working copy; the project root and notebook 1 → notebook 2 → notebook 3 → Stata sequence are known setup/order. Missing prepared inputs and inactive producer handoffs remain explicit.

Entry points: `1_SA_articles_and_author_month.ipynb`, `2_SA_firm_day_month_quarter.ipynb`, `3_SA_intraday.ipynb`, `4_Seeking Alpha and AI - Stata Code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 3/70053 - Generative-AI-Use-by-Capital-Market-Information-Intermediaries-Evidence-from-Seeking-Alpha/bmyz-datasheet-code-identifier-and-log-files.zip",
      "sha256": "62a7237578bd191ae8bd6ffc0561ed5a8905cee2d0952dc212f813baf2ea5e65"
    },
    {
      "path": "JAR-Volume 64/Issue 3/70053 - Generative-AI-Use-by-Capital-Market-Information-Intermediaries-Evidence-from-Seeking-Alpha/bmyz-online-appendix.pdf",
      "sha256": "8b5655cec4007dcb1e6043de133efadf570dd4c31fa33a143eb713595daac472"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "7280c979f3f7e57f1c02643e2aed218a805475bf735398623aa1555f61a21da7"
}
```

## Proposed actions

### ACT_SA_INPUTS: Obtain the authors' prepared Seeking Alpha article, time, author, comment, and Editor's Pick inputs with their original identifiers and collection rules.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_SA_CONTENT, REQ_SA_TIME, REQ_AUTHOR_PROFILE, REQ_AUTHOR_ANON, REQ_COMMENT_COUNTS, REQ_EDITOR_PICKS
Evidence: E_DOC_SA, E_NB1_ARTICLE_INPUT, E_NB1_TIME_INPUT, E_NB1_PROFILE_INPUT, E_SETUP_AUTHOR_ANON, E_SETUP_SOCIAL_PREP

Preparation / proposed procedure:

1. Request the complete SA_all_art_oct2024.pkl archive and SA_article_time.csv together with column definitions, ID mapping, exact timestamps/time-zone semantics, article counts, and date coverage.
2. Request author_info.pkl and author_info_with_anonymous_indicator.csv with author nickname keys, profile field meanings, and the manual anonymity-label rule.
3. Request Artcle_comment_count.csv and Editors_pick.csv with article ID keys, measurement windows, and coverage; do not scrape or reconstruct these data independently.

Validation to perform later:

- Check required columns, identifiers, date types, key uniqueness, and coverage against the June 2022–August 2024 code window before using the author's files.

### ACT_DATE_SCOPE: Resolve the article-sample coverage gap between the documented collection dates and the code's pre-period.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_DATE_SCOPE
Evidence: E_DOC_SA, E_SETUP_ARTICLE_DATES, E_NB1_SAMPLE_WRITE

Preparation / proposed procedure:

1. Ask the authors whether the article archive includes June–November 2022 controls even though the datasheet reports collection beginning December 1, 2022.
2. Obtain the sample and pre-GPT date counts or a revised author-prepared archive manifest; preserve the documented post-GPT and enforcement cutoffs.

Validation to perform later:

- Confirm exact first/last article dates, counts by pre/post period, and that every consumer's date filters use the same author-defined sample.

### ACT_AI_OUTPUT: Obtain and validate the author-prepared Originality.ai scan output; preserve Lite 1.0.0 and its output semantics as provenance.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_AI_SCAN
Evidence: E_DOC_AI, E_SETUP_AI_OUTPUT, E_CAT_ORIGINALITY

Preparation / proposed procedure:

1. Request the original Data/Scanned_arts_new.csv and its scan manifest, article IDs, collection dates, and field definitions for Sent_count, AI_count, and AI_confidence.
2. The supplied consumer only reads the prepared file. If the authors elect to regenerate it, preserve the reported Originality.ai Lite 1.0.0 route and obtain the owner-provided provenance before any separately authorized service work; do not substitute another detector/model.

Validation to perform later:

- Verify the prepared file contains the consumed fields and article IDs, and confirm confidence semantics, Lite 1.0.0 provenance, and coverage against the article sample.

### ACT_TEXT_OUTPUTS: Obtain all three distinct author-prepared text outputs and their feature contracts; exact model/dictionary resources are conditional on an author-directed regeneration path.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_TEXT_STATS, REQ_TEXT_SPEC, REQ_TEXT_LM, ISSUE_TEXT_PREP
Evidence: E_DOC_TEXT, E_SETUP_TEXT_PREP, E_CAT_LM_SEARCH

Preparation / proposed procedure:

1. Request Art_text.csv, Art_text_spec_3.csv, and SA_art_lm_sep.pkl as three separate required files; none substitutes for another. Obtain the author-prepared schema, article-ID coverage, and construction/meaning for each output.
2. The registered consumer only reads these outputs; no supplied Originality/NER/scoring producer was identified. If the author elects to regenerate, preserve Originality.ai Lite 1.0.0, Stanford NER 4.2.0, and the exact reported Loughran–McDonald 2011 dictionary/scoring provenance. Do not substitute versions or create an analysis-only bypass.

Validation to perform later:

- Check each of the three files separately for its own expected path, article IDs, complete columns, types, and coverage; verify documented text feature, entity, and LM score definitions before use.

### ACT_FINANCE_PRODUCTS: Request the exact CRSP/Compustat data products and dated author extracts needed by the visible financial routines.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_CRSP_MARKET, REQ_CRSP_LINK, REQ_COMP_QTR, ISSUE_CRSP_MARKET_SEMANTICS
Evidence: E_DOC_FINANCE, E_NB1_MARKET_INPUT, E_NB1_CIZ_DATE_FIELD, E_NB1_CIZ_TRADING_CAL, E_NB1_LINK_INPUT, E_SETUP_CRSP_MARKET, E_SETUP_FIN_INPUT, E_SETUP_FIN_FIELDS, E_CAT_COMP_SEARCH, E_CAT_CRSP_MARKET

Preparation / proposed procedure:

1. Request the author-prepared CRSP market file, Compustat–CRSP linking file, and quarterly Compustat panel with the visible identifiers, dates, and fields. For the market file, establish the CIZ DlyCalDt calendar mapping and the exact CIZ market-return field/product, meaning, vintage, and pre-event coverage; do not infer a legacy DSI return equivalence.
2. For quarterly Compustat, preserve the reported April 2025 DLCQ/DLTTQ supplement and obtain the prepared Size, BM, ROA, xsga, and rolling-revenue definitions, joins, period, and extraction vintage. Keep the masked Compustat_QFincls2.csv, Ad_exp.csv, and First_compustat_year.csv as separate unresolved contracts.

Validation to perform later:

- Validate the CIZ calendar and return field semantics, link-date validity, exact quarterly and downstream-prepared fields, dates/lookbacks, and source vintages using one coherent contract per file before merging.

### ACT_CRSP_REBUILD: Supply the author-prepared CRSP universe pickle or restore its exact source-backed producer.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_CRSP_UNI_WIP, ISSUE_CRSP_UNI_WIP
Evidence: E_SETUP_CRSP_DAILY, E_SETUP_CRSP_MARKET, E_SETUP_WRDS_INTRADAY, E_SETUP_CRSP_LINK, E_SETUP_CRSP_WIP_WRITE, E_SETUP_CRSP_WIP_READ, E_CAT_CRSP_DAILY, E_CAT_WRDS_INTRADAY

Preparation / proposed procedure:

1. Request the original CRSP_uni_wip.pkl with its schema and coverage first; if it is unavailable, confirm whether the authors intend the optional CRSP_universe_redo rebuild and obtain its exact CRSP daily-stock, CIZ market-calendar/return, WRDS Intraday Indicator, and linking upstreams.
2. If rebuilding, use the supplied producer specification and preserve the CIZ calendar join, identifier/link-date filters, sample dates, and pickle path; do not treat these upstreams as separate deliverables when the prepared pickle is supplied.

Validation to perform later:

- Verify the single chosen route yields the CRSP universe pickle with required fields and period, correct ID/date coverage, and consumption by notebooks 2 and 3; if rebuilt, check the documented producer output against its exact upstream contracts.

### ACT_CRSP_WINDOWS: Restore the two CRSP-window outputs in their documented position before notebook 2 reads them.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_CRSP_WINDOW_TRADING, REQ_CRSP_WINDOW_CALENDAR, ISSUE_CRSP_WINDOWS
Evidence: E_NB2_WINDOW_START, E_NB2_WINDOW1_WRITE, E_NB2_WINDOW2_WRITE, E_NB2_WINDOW_END, E_NB2_WINDOW1_READ, E_NB2_WINDOW2_READ, E_NB2_WINDOW_DATES

Preparation / proposed procedure:

1. Request both distinct prepared files together: CRSP_window_measures.csv and CRSP_window_measure2.csv. If either is unavailable, ask the authors to confirm the existing triple-quoted producer path and its upstreams before restoring that documented producer; do not accept one file as satisfying the other.
2. Preserve the exact trading-day windows, the calendar-day 90-day lookback, event dates, keys, and generated measures as written; do not substitute a return measure or infer unrelated raw feeds.

Validation to perform later:

- Verify each file independently against its own keys, columns, event dates, windows, and merge coverage; confirm both files are available to notebook 2 before it creates Firm_day and Firm_month.

### ACT_IBES_PREP: Obtain earnings-announcement and analyst-history inputs, preserving the optional detail rebuild branch.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_IBES_EA, REQ_FIRM_DAY_ANA, ISSUE_ANALYST_PREP
Evidence: E_DOC_FINANCE, E_NB1_IBES_INPUT, E_NB2_IBES_INPUT, E_NB2_ANALYST_NOTE, E_NB2_IBES_DETAIL, E_NB2_ANALYST_WRITE, E_NB2_ANALYST_READ, E_SETUP_IBES_DETAIL, E_CAT_IBES_SEARCH, E_NB1_IBES_KEY_FIELDS

Preparation / proposed procedure:

1. Request the author-prepared IBES_EA.csv extract with oftic, cusip, and anndats and confirm its event-date coverage.
2. Request Firm_day_past_ana.csv as the active analyst-history input with the documented 30/90/365-day fields. Only if that prepared file is unavailable and the authors elect a rebuild, request the exact I/B/E/S Detail history extract, dates, analyst-count definition, and online producer step; do not require raw history when the prepared file is supplied.

Validation to perform later:

- Check identifier/date types and all event/lookback periods for both prepared contracts; when rebuilding analyst history, validate its output keys, 30/90/365-day measures, and coverage before the firm-day merge.

### ACT_SEC_NEWS_OWNERSHIP: Prepare the 8-K input from the verified SEC public indexes; request the separate author-specified Dow Jones and Thomson/Refinitiv extracts with the exact fields used.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_8K, REQ_DJ_NEWS, REQ_TR_IO
Evidence: E_DOC_FINANCE, E_DOC_EVENTS, E_NB1_8K_INPUT, E_NB2_8K_INPUT, E_NB1_DJ_INPUT, E_NB2_DJ_INPUT, E_NB1_DJ_FIELDS, E_NB1_DJ_GVKEY, E_NB1_TR_INPUT, E_NB2_TR_INPUT, E_CAT_SEC, E_CAT_8K, E_CAT_DJ, E_NB1_8K_FILTER_PERIOD, E_SEC_EDGAR_INDEX_DOC, E_NB1_8K_CALENDAR_MAP, E_NB1_CIZ_TRADING_CAL

Preparation / proposed procedure:

1. Use SEC EDGAR company/form/master indexes as the verified public 8-K source for the required date range. In the derived file, map CIK to cik, form type to form, and date filed to fdate; preserve CIK as an identifier without lossy numeric coercion, parse dates, apply the source 8-K substring and date filters, and map filing dates through the separately required CRSP trading calendar. These are ordinary data-preparation steps and do not require author permission or historical author-byte identity.
2. Keep the author-prepared 8K_report.csv and WRDS extract as alternative routes if already supplied or selected by the data owner; do not characterize either as a prerequisite to the verified public route.
3. For Dow Jones, request the article extract keyed by gvkey/CUSIP and UTC article date; for Thomson Reuters/Refinitiv, request firm-quarter CUSIP, report date, and institutional-ownership percent. Do not treat a catalog row as proof of license or compatible data.

Validation to perform later:

- Check that the prepared index-derived file exposes consumed cik, fdate, and form fields with preserved CIK identifiers, parsed dates, the original 8-K filter, and the required date coverage; confirm trading_cal comes from the separately required CRSP calendar.
- Validate the separate Dow Jones/Thomson source products, identifier links, and required event/quarter windows before use.

### ACT_CIQ_EVENTS: Obtain the S&P Capital IQ Key Development event extract required by the article event window.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_CIQ_KEYDEV
Evidence: E_DOC_EVENTS, E_NB1_CIQ_INPUT, E_CAT_CIQ_SEARCH

Preparation / proposed procedure:

1. Request the author-prepared CIQ_Keydev.csv with the six selected event fields and the exact product/query date, then preserve the role and event-type filters and UTC-to-Eastern conversion.

Validation to perform later:

- Check gvkey coverage, event categories, UTC timestamp type, September 2025 vintage, and event-date coverage through September 1, 2024.

### ACT_RAVENPACK: Identify the RavenPack table and transformation behind the documented article-timing variable.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_RAVENPACK_TIMING, ISSUE_RAVENPACK_MAPPING
Evidence: E_DOC_EVENTS, E_CAT_RAVENPACK, E_WORK_ITEM_SOURCES

Preparation / proposed procedure:

1. Ask the authors for the exact RavenPack product/table, query, identifiers, fields, time-zone treatment, extraction vintage, and the producer that feeds the article-timing variable.
2. Treat the local RavenPack categories catalog row as an unrelated candidate until field and product compatibility are established; do not substitute it for event records.

Validation to perform later:

- Verify a documented mapping from the author-specified RavenPack fields to the article-level timing output, identifiers, and sample dates.

### ACT_TAQ: Rebuild or obtain the author's TAQ trade and NBBO windows with the original cleaning rules.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_TAQ_TRADE_WINDOW, REQ_TAQ_QUOTE_WINDOW, ISSUE_TAQ_PREP
Evidence: E_DOC_TAQ, E_NB3_TRADE_RAW, E_NB3_TRADE_SYMBOL_FIELDS, E_NB3_TRADE_TIME_FIELD, E_NB3_TRADE_SALE_CONDITION, E_NB3_TRADE_SIZE_FIELD, E_NB3_TRADE_PRICE_FIELD, E_NB3_TRADE_WRITE, E_NB3_TRADE_READ, E_NB3_TRADE_FIELDS, E_NB3_QUOTE_RAW, E_NB3_QUOTE_TIME_FIELD, E_NB3_QUOTE_SYMBOL_FIELDS, E_NB3_QUOTE_BIDASK, E_NB3_QUOTE_SIZE_FIELDS, E_NB3_QUOTE_WRITE, E_NB3_QUOTE_READ, E_NB3_QUOTE_FILTERS, E_NB3_QUOTE_OUTPUT_FIELDS, E_CAT_TAQ_SEARCH

Preparation / proposed procedure:

1. Request both active prepared outputs: TAQ_wct_second_level_win.csv and NBBO_sec_level_win.csv. Treat them as separate required window files and validate each independently; supplying them does not require separate raw TAQ deliveries.
2. Only if a prepared window is unavailable and the authors choose to rebuild, obtain the exact raw trade or complete-NBBO source extracts and restore the supplied commented cleaning/writer path. Preserve trade and quote separation, symbol root/suffix mapping, time zones, sales/quote condition rules, normal-hours filters, article-relative [-30,+30]-minute windows, and reported extraction vintages; do not substitute another vendor.

Validation to perform later:

- For each active prepared window, verify article/security/time keys, expected columns, timestamps, and [-30,+30]-minute coverage; if rebuilding, validate raw fields and every documented cleaning rule before checking the produced output.

### ACT_ARTICLE_UNIVERSE: Obtain the producer and exact schema for the intraday article universe.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_ARTICLE_UNIVERSE, ISSUE_ARTICLE_UNIVERSE
Evidence: E_NB3_ARTICLE_UNIVERSE, E_NB1_SAMPLE_WRITE, E_IDENTIFIER_PROBE, E_WORK_ITEM_SOURCES

Preparation / proposed procedure:

1. Ask the authors whether SA_article_sample_uni.csv is derived from Sample_response.csv, the identifier workbook, or another author-prepared source; request the exact inclusion filters and merge keys.
2. Use the identifier workbook only for its documented identifiers, not as a substitute for article text, scan output, or firm/time data.

Validation to perform later:

- Verify the resulting article IDs, post-GPT flag, publication date/time, ticker/permno link, and complete intraday sample coverage.

### ACT_STATA_APPENDIX_INPUTS: Locate or obtain the two author-prepared intraday DTA files used only by the Stata appendix.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_STATA_INTRADAY_TRADE, REQ_STATA_INTRADAY_QUOTE, ISSUE_STATA_INTRADAY_FILES
Evidence: E_STATA_TRADE_APPENDIX_READ, E_STATA_QUOTE_APPENDIX_READ, E_WORK_ITEM_SOURCES

Preparation / proposed procedure:

1. Request the original producers or the exact SA_intraday_trade.dta and SA_intraday_quote.dta with data dictionaries, source files, sample periods, and prior event exclusions.
2. Do not synthesize these datasets from different measures or infer compatibility from similarly named notebook outputs.

Validation to perform later:

- Compare both DTA schemas, sample rows/counts, and variable definitions to the Stata appendix before running the analysis.

### ACT_FINANCIALS_MASKED: Resolve the hidden financial-file contracts without exposing or testing author credentials.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMP_QTR2, REQ_AD_EXP, REQ_FIRST_COMP_YEAR, ISSUE_FINANCIALS_MASKED
Evidence: E_DEPENDENCY_REGISTRY, E_SETUP_FIN_CONTEXT, E_SETUP_FIN_INPUT, E_CAT_COMP_QTR2

Preparation / proposed procedure:

1. Ask for a safe, credential-free data dictionary and producer description for Compustat_QFincls2.csv, Ad_exp.csv, and First_compustat_year.csv, including source product, fields, period, and join keys.
2. Alternatively request author-prepared outputs plus a sanitized statement of how they feed financials(); keep hidden connection/auth statements out of the review.

Validation to perform later:

- Confirm each registered input's role, columns, types, period, and join order from an author-approved description before marking closure complete.

### ACT_PYTHON_RUNTIME: Verify the notebook runtime and third-party Python imports in a dedicated project environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_PYTHON_LIBS, SW_NOTEBOOK_ENGINE
Evidence: E_NB1_PY_IMPORTS, E_SETUP_PY_IMPORTS, E_ENV_PROBE

Preparation / proposed procedure:

1. Confirm a notebook kernel compatible with Python 3.12.14 and the exact availability/version of pandas, numpy, pytz, requests, and wrds.
2. Install only author-required versions in the project environment after the package layout and data files are staged; the wrds import does not establish a database connection or data access.

Validation to perform later:

- Record environment versions and verify imports without executing the author notebooks until a separately authorized run.

### ACT_STATA_ADDONS: Confirm the Stata add-on commands required by the analysis and install compatible versions only if missing.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_ESTSTO, SW_PPMLHDFE, SW_WINSOR2, SW_TTABLE3, SW_DISTINCT
Evidence: E_ENV_PROBE, E_STATA_PPM, E_STATA_WINSOR, E_STATA_TTABLE3, E_STATA_DISTINCT

Preparation / proposed procedure:

1. In Stata 18, check which eststo, ppmlhdfe, winsor2, ttable3, and distinct resolve in the intended user ado path.
2. winsor2 is reported unavailable; identify its compatible distribution and pin the ado version. Verify the other unreported commands before installing anything; preserve the specified estimators and tables.

Validation to perform later:

- Record command/version resolution for each exact name and confirm the already reported reghdfe/ftools/esttab/estadd versions remain available.

### ACT_RUN_SEQUENCE: Configure the known Python module/root layout, resolve the specified prepared-input and producer handoffs, and run the documented author workflow in order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISSUE_CRSP_UNI_WIP, ISSUE_CRSP_WINDOWS, ISSUE_ANALYST_PREP, ISSUE_ARTICLE_UNIVERSE, ISSUE_TAQ_PREP, ISSUE_STATA_INTRADAY_FILES
Evidence: E_DOC_PROGRAMS, E_NB1_SAMPLE_WRITE, E_NB2_FIRM_DAY_WRITE, E_NB2_FIRM_MONTH_WRITE, E_NB2_EARNINGS_WRITE, E_NB3_TRADE_DTA_WRITE, E_NB3_QUOTE_DTA_WRITE, E_STATA_ART1_WRITE, E_WORK_ITEM_SOURCES, E_NB1_IMPORT, E_NB2_IMPORT, E_NB3_IMPORT, E_PYTHON_PACKAGE_SUBMODULE_DOC, E_PYTHON_NAMESPACE_PACKAGE_DOC

Preparation / proposed procedure:

1. In a working copy, set one project-relative root and place the unchanged registered SA_setup.py at Code/setup_code/SA_setup.py so the notebooks’ from Code.setup_code import SA_setup can resolve it as a submodule under Python 3.12 package/namespace-package rules; keep SA_setup.py as a support dependency, not a launch point.
2. Stage the author-prepared article, scan, text, finance, event, and intraday files. Resolve the distinct active handoffs before their consumers: the CRSP universe pickle; both CRSP window files; analyst-history output; notebook 3 article universe; both TAQ windows; and the Stata appendix trade/quote DTA inputs. For each disabled producer, choose the prepared output or its source-backed conditional rebuild path, without requiring both.
3. Run notebook 1 to produce Sample_response.csv, Author_M.dta, and SA_art_sample1_keydev_exact.dta; then notebook 2 to produce Firm_day.dta, Firm_month.dta, firm_day_controls.pkl, and Earnings_ann.dta; then notebook 3 to produce its trade/quote Stata datasets; run the Stata do-file last.
4. Keep all required source versions and appendix DTA inputs in the same documented project root.

Validation to perform later:

- Before a separately authorized run, check the chosen module placement/root and every prepared handoff, then verify each stage’s expected paths, identifiers, dates, and fields. After any authorized run, compare reported sample counts and tables without changing the model, sample, estimators, or event windows.


## Remaining issues and prerequisites

- ISSUE_DATE_SCOPE [unresolved; full_pipeline]: The datasheet reports article collection beginning 2022-12-01, while the supplied helper sets a June 2022 start and the Stata sample divides pre/post-GPT articles. The completeness and construction of the June–November 2022 pre-period are unverified.
- ISSUE_TEXT_PREP [unresolved; full_pipeline]: The active helper reads and merges all three distinct prepared text outputs; no registered producer establishes tokenization, specificity/structure features, LM scoring, NER, or completeness. Originality.ai Lite 1.0.0, Stanford NER 4.2.0, and the reported Loughran–McDonald 2011 dictionary are provenance only when their outputs are supplied; exact versions are conditional prerequisites only if those outputs must be regenerated.
- ISSUE_FINANCIALS_MASKED [unresolved; full_pipeline]: The dependency registry names Compustat_QFincls2.csv, Ad_exp.csv, and First_compustat_year.csv in SA_setup.py; the safe source view withholds parts of financials(), so their exact products, fields, and periods cannot be verified. Treat the gaps as unread coverage, not absent code or access denial.
- ISSUE_CRSP_UNI_WIP [unresolved; full_pipeline]: Notebook 2 and notebook 3 call CRSP_universe(), which reads CRSP_uni_wip.pkl; the only visible writer is commented in a separate rebuild function. Supply the prepared pickle, or use the optional documented rebuild branch; raw writer inputs are not independent delivery requirements when the pickle is supplied.
- ISSUE_CRSP_WINDOWS [unresolved; full_pipeline]: Notebook 2 separately and jointly requires CRSP_window_measures.csv and CRSP_window_measure2.csv; each only visible writer is inside a triple-quoted block. These are two distinct prepared workflow outputs, not alternatives and not additional raw-source requirements when both prepared files are supplied.
- ISSUE_ANALYST_PREP [unresolved; full_pipeline]: Notebook 2 marks analyst-history preparation as online work, encloses the I/B/E/S Detail producer and Firm_day_past_ana.csv writer in a triple-quoted block, then reads Firm_day_past_ana.csv actively. The prepared file is the active input; raw detail history is only needed if rebuilding it.
- ISSUE_ARTICLE_UNIVERSE [unresolved; full_pipeline]: Notebook 3 actively reads SA_article_sample_uni.csv, but no producer for this prepared article universe appears in the registered program sources. The supplied identifier workbook is not a verified compatible dataset.
- ISSUE_TAQ_PREP [unresolved; full_pipeline]: Notebook 3 actively reads two prepared second-level windows. Its raw TAQ and complete-NBBO cleaning/writers are commented and constitute optional producer paths. Request both prepared windows as the active inputs, or confirm a conditional raw rebuild; the raw feeds are not separate mandatory requirements when their prepared outputs are supplied.
- ISSUE_STATA_INTRADAY_FILES [unresolved; full_pipeline]: The Stata appendix reads SA_intraday_trade.dta and SA_intraday_quote.dta, but no producer for either file appears in the registered sources. They remain author-prepared inputs with unknown schemas.
- ISSUE_RAVENPACK_MAPPING [unresolved; full_pipeline]: The datasheet says RavenPack was used for an article-timing variable, but the registered programs do not identify its table, fields, or transform. The local catalog hit is a category table with no matched fields, not a compatible event extract.
- ISSUE_CRSP_MARKET_SEMANTICS [unresolved; full_pipeline]: Notebook 1 and the support module map CIZ DlyCalDt to the daily date/trading calendar, and the support module merges the CRSP market file with the daily stock data. The exact CIZ return-column identity, market-return meaning/version, sample/look-back coverage, and compatibility with downstream abnormal-return windows are not established. Do not assume legacy DSI return equivalence.
- REQ_SA_CONTENT [undetermined]: Author-collected Seeking Alpha article archive. The source documentation covers 2022-12-01 through 2024-08-31, while code retains a June 2022 pre-period; required article text, IDs, publication dates, author identifiers, and full coverage are not established by the identifier workbook.
- REQ_SA_TIME [undetermined]: Separate article publication-time file used to align each article to trading minutes; exact IDs, timestamp semantics, and full date coverage must match the article archive.
- REQ_AI_SCAN [undetermined]: Author-prepared Originality.ai scan output used to assign article-level AI measures; preserve the reported Lite 1.0.0 provenance and author-defined output semantics.
- REQ_AUTHOR_PROFILE [undetermined]: Author profile archive used for author identifiers and profile characteristics.
- REQ_AUTHOR_ANON [undetermined]: Author profile and manually assigned anonymous-author indicator used in article-level controls.
- REQ_TEXT_STATS [undetermined]: Mandatory author-prepared article text-statistics file, consumed in addition to the specificity and Loughran–McDonald score files.
- REQ_TEXT_SPEC [undetermined]: Mandatory author-prepared text-specificity/structure file, consumed in addition to the text-statistics and Loughran–McDonald score files.
- REQ_TEXT_LM [undetermined]: Mandatory author-prepared Loughran–McDonald article-score pickle, consumed in addition to the text-statistics and specificity/structure files.
- REQ_COMMENT_COUNTS [undetermined]: Seeking Alpha article comment-count outputs used as article controls.
- REQ_EDITOR_PICKS [undetermined]: Seeking Alpha Editor's Pick flags used as article controls.
- REQ_CRSP_MARKET [undetermined]: Author-prepared CRSP market file used to construct the daily trading calendar and merged into the CRSP universe. Notebook source uses the CIZ DlyCalDt calendar field; the exact required market-return field/product, CIZ version, and historical look-back remain unresolved.
- REQ_CRSP_LINK [undetermined]: Compustat–CRSP identifier-link table used to map tickers and firms to CRSP, CUSIP, CIK, and industry fields.
- REQ_COMP_QTR [undetermined]: Quarterly Compustat preparation file used for financial controls. The visible routine requires quarterly keys/leverage inputs and a prepared panel including Size, BM, ROA, xsga, and rolling revenue; these feature constructions, joins, and source semantics are not all established. The datasheet reports DLCQ/DLTTQ were added in April 2025.
- REQ_IBES_EA [undetermined]: I/B/E/S earnings-announcement dates used in article and firm-day event controls.
- REQ_8K [public_acquisition_required]: 8-K filing events used to flag recent and exact filings. SEC EDGAR public indexes expose the consumed CIK, form-type, and filing-date fields across the required period; mapping them to the prepared columns and applying the source filters are ordinary preparation steps. The author-prepared CSV and WRDS extracts remain alternative routes.
- REQ_DJ_NEWS [undetermined]: Dow Jones news articles used to count recent press coverage by gvkey/CUSIP and date.
- REQ_TR_IO [undetermined]: Thomson Reuters/Refinitiv quarterly institutional-ownership data used in firm controls.
- REQ_CIQ_KEYDEV [undetermined]: Capital IQ Key Development events used to construct event controls immediately before article publication.
- REQ_RAVENPACK_TIMING [undetermined]: RavenPack records are documented as an upstream for an article-timing variable, but no exact product, file, fields, or producer is present in the registered program sources.
- REQ_CRSP_UNI_WIP [undetermined]: Prepared CRSP universe pickle actively consumed by notebooks 2 and 3. Its only visible writer is commented and its rebuild routine is not called by CRSP_universe(); if this prepared output is supplied, the writer inputs are not additional delivery requirements.
- REQ_CRSP_WINDOW_TRADING [undetermined]: Mandatory prepared CRSP trading-day event-window file, separately read by notebook 2 in addition to its calendar-day window file.
- REQ_CRSP_WINDOW_CALENDAR [undetermined]: Mandatory prepared CRSP calendar-day event-window file, separately read by notebook 2 in addition to its trading-day window file.
- REQ_FIRM_DAY_ANA [undetermined]: Prepared analyst-history controls file actively read by notebook 2; its only visible writer is inside a triple-quoted online-preparation block. The prepared file is the active contract; I/B/E/S Detail is only a conditional rebuild upstream.
- REQ_ARTICLE_UNIVERSE [undetermined]: Prepared intraday article universe actively read by notebook 3; no producer appears in the registered workflow sources and the identifier workbook does not establish a compatible substitute.
- REQ_TAQ_TRADE_WINDOW [undetermined]: Mandatory prepared second-level trade-window file actively read by notebook 3. The commented cleaner/writer is an optional rebuild path from raw trades; a prepared window satisfies this file contract without a separate raw-feed requirement.
- REQ_TAQ_QUOTE_WINDOW [undetermined]: Mandatory prepared second-level NBBO-window file actively read by notebook 3. The commented cleaner/writer is an optional rebuild path from complete-NBBO quotes; a prepared window satisfies this file contract without a separate raw-feed requirement.
- REQ_COMP_QTR2 [undetermined]: The financial routine dependency inventory names Compustat_QFincls2.csv; the safe source view does not establish its field or date contract.
- REQ_AD_EXP [undetermined]: The financial routine dependency inventory names Ad_exp.csv; the safe source view does not establish its field or date contract.
- REQ_FIRST_COMP_YEAR [undetermined]: The financial routine dependency inventory names First_compustat_year.csv; the safe source view does not establish its field or date contract.
- REQ_STATA_INTRADAY_TRADE [undetermined]: Author-prepared SA_intraday_trade.dta required by the Stata appendix; no producer is present in the registered sources.
- REQ_STATA_INTRADAY_QUOTE [undetermined]: Author-prepared SA_intraday_quote.dta required by the Stata appendix; no producer is present in the registered sources.
- SW_PYTHON_LIBS [unverified]: The notebooks and helper import these third-party packages; the original environment probe does not report their package versions or availability.
- SW_NOTEBOOK_ENGINE [unverified]: The data-construction entrypoints are notebooks; the registered environment projection does not verify a notebook kernel or compatible execution host.
- SW_ESTSTO [unverified]: Stata stored-estimation command used by the do-file; the environment projection does not report this exact command.
- SW_PPMLHDFE [unverified]: Stata Poisson pseudo-maximum-likelihood estimator used by the do-file; the environment projection does not report it.
- SW_WINSOR2 [preparation_required]: Stata winsorization command used throughout the supplied analysis; the original probe reports it unavailable.
- SW_TTABLE3 [unverified]: Stata group-comparison command used by the do-file; the environment projection does not report its availability or version.
- SW_DISTINCT [unverified]: Stata distinct-count command used by the do-file; the environment projection does not report its availability or version.

## Review notes

- The available Identifier_article.xlsx probe is only a bounded identifier sample with unverified header semantics and coverage; it does not establish a compatible analysis-only route or replace the article, timestamp, scan, financial, event, and TAQ inputs.
- The frozen catalog identifies local WRDSSEC.EXHIBITS and RPA.RAVENPACK_CATEGORIES candidates, but neither has matching fields for the required event contract. The Loughran–McDonald and exact prepared-file queries returned no local catalog row; these bounded nonmatches do not establish absence of a license, public source, or prepared author data.
- The authors' datasheet says articles were collected from December 2022 onward, while the code constructs a June 2022 start and pre-GPT period. Keep that coverage gap unresolved until author data or a manifest establishes the intended pre-period.
- The source view leaves some financial/authentication spans unread. Their masks are coverage limits; no conclusion is drawn about code absence, credentials, or access, and no private path or credential is reproduced.
- The target remains the full Python-notebook and Stata workflow. No compatible analysis-only dataset or independent reconstruction route is established by the identifier workbook or catalog metadata.
- Process note: an initial queue lookup treated the coordinator’s R/ shorthand as a literal workspace-root directory and failed; the coordinator supplied the exact sweep_01/semantic_prechecks path, whose expected SHA-256 was verified. This lookup did not alter source, prior outputs, or scientific evidence.
