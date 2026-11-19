# Patch proposal: jar-af1027a3577c

Wisdom of Crowds: Cross-sectional Variation in the Informativeness of Third-Party-Generated Product Information on Twitter

DOI: 10.1111/1475-679X.12183

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: manual SPSS GUI data preparation, local/vendor data acquisition and two supplied SPSS table-analysis syntax files.

Entry points: `TANG_TABLE56.sps`, `TANG_TABLE789.sps`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 3/12183 - Wisdom-of-Crowds-Cross-sectional-Variation-in-the-Informativeness-of-Third-Party-Generated-Product-Information/tang-datasheet-and-data-files.zip",
      "sha256": "7ab2b3e1c71fd4b3dbcc83f1244de37f9b6b488387327c7f74eda15404188c43"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "552000ae09cc8e901610b3239639ce2615db2098978dbc5d39619873c4a56b5c"
}
```

## Proposed actions

### A_LOCAL_FINANCE_COMPAT: Use the readable local Compustat and I/B/E/S candidates, then establish the specific source-field and required-history compatibility before the manual SAV construction. The probe establishes access and candidate columns, not full date coverage or the authors’ field choices.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_Q, R_COMP_A, R_IBES_SALES, I_FINANCE_FIELD_HISTORY
Evidence: E_COMP_Q_SOURCE, E_COMP_Q_LAG, E_COMP_A_SOURCE, E_COMP_MERGE, E_COMP_IBES_MERGE, E_IBES_STEP, E_CATALOG, E_PROBE_COMPQ, E_PROBE_COMPA, E_PROBE_IBES, E_PROBE_IBESU

Preparation / proposed procedure:

1. Check the existing COMP.FUNDQ candidate for the author’s 2010-01-01–2016-12-30 quarterly rows and GVKEY, DATADATE, FYEARQ, FQTR, SALEQ and REVTQ fields. Confirm which sales field feeds the q−4 growth calculation and which revenue field is used for the negative-revenue exclusion; do not widen the source filter from the lag alone.
2. Check the existing COMP.FUNDA candidate for the documented annual-sales and XAD advertising variables and the author’s 2010-01-01–2016-12-31 period; retain a prior-fiscal-year row only where required by the annual lag.
3. Use IBES.STATSUM_XEPSUS as the primary local candidate and identify the MEASURE value that denotes quarterly sales, whether ACTUAL is the matching realized-sales value, and the STATPERS/STATPER naming relationship. Use the author’s 2016-12-09 cutoff and last-forecast selection by official ticker and fiscal-period end. The unadjusted local alternative lacks ACTUAL and is not sufficient alone.
4. If the exact source-field value or alias cannot be established from the current data documentation, request only that specific mapping. The documented dates are source bounds/cutoffs; an identical author-era file vintage is not a prerequisite absent evidence of a vintage-dependent construction.

Validation to perform later:

- Confirm required fields and date ranges in the local products before using them; verify the q−4 and prior-fiscal-year observations for actual retained estimation rows.
- Confirm the I/B/E/S sales measure, actual-sales field, forecast cutoff, and official-ticker/fiscal-period-end join fields.
- After the GUI preparation, check uniqueness/merge behavior on GVKEY plus fiscal year and official ticker plus DATADATE/FPEDATS, and confirm COMPALL.SAV and COMP_IBES.SAV have the documented keys and required variables.

### A_LIKE_DAILY_ACCESS: Obtain an authorized route to the exact historical LikeFolio company-day statistics used by the study. The currently described API/bulk product is only a candidate and is not established as the same 2012–2015 per-million series.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_LIKE_DAILY, I_DAILY_VENDOR_CONTRACT
Evidence: E_VENDOR_DAILY_PERIOD, E_VENDOR_DAILY_FIELDS, E_VENDOR_LICENSE, E_DAILY_TRANSFORM, E_DAILY_WINDOW, E_PUBLIC_LIKE

Preparation / proposed procedure:

1. Request or otherwise establish direct authorized access to the LikeFolio company-day file covering the author-stated 2012-01-01 through 2015-12-31 series, with DATE, TICKER, PRODUCTTWEET, PURCHASETWEET, POSITIVETWEET and NEGATIVETWEET and their per-million units. The author’s data-sharing agreement does not establish that the replicator lacks a separate vendor license.
2. Confirm the same vendor classification and product/brand-to-company mapping contract; do not substitute collected raw tweets or reconstruct vendor classifications.
3. Apply the documented PURCHASE and POSITIVE definitions and 91-day moving average. Check actual retained earliest quarter endpoints against the initial-window treatment; request dates before 2012 only if the retained endpoints and supported author treatment require them.

Validation to perform later:

- Verify the authorized file/API response contains the required company-day keys, four statistics, stated units and 2012–2015 dates.
- Confirm initial rolling-window handling against the actual first retained endpoints, then verify the TWITTER_RAW.SAV and TWITTER_AVG.SAV date/ticker keys before the COMP_IBES.SAV merge.

### A_LIKE_HANDLE_ACCESS_MAP: Obtain the separate authorized monthly B2C tweet-handle statistics and resolve their exact mapping to the table 7–9 analysis variables. No raw-category schema or compatible monthly SAV is packaged.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_LIKE_HANDLES, I_HANDLE_VARIABLE_MAPPING
Evidence: E_VENDOR_LICENSE, E_HANDLE_SOURCE, E_HANDLE_WINDOW, E_HANDLE_DOC_NAMES, E_HANDLE_CODE_NAMES, E_HANDLE_CODE_POS, E_PUBLIC_LIKE

Preparation / proposed procedure:

1. Request/establish authorized access to the separate company-month B2C classification file described as supplied on 2017-03-10, including the raw fields, units, category denominators, product-tweet shares and purchase/positive measures for media, product experts and crowd.
2. Ask for the precise mapping from datasheet labels MEIDA_AVG_PURCHASE, EXPERT_AVG_PURCHASE, CROWD_AVG_PURCAHSE and the three positive averages to the syntax inputs ln_avg_news_purchase, ln_avg_expert_purchase, ln_avg_crowd_purchase, news_positive_corrected, expert_positive_corrected and crowd_positive_corrected. Confirm the intended media/news label and any corrected-positive construction; do not assume aliases from spelling.
3. Preserve the three-month monthly moving average from two months prior through the current month. Determine whether the earliest retained B2C month needs additional source months under the author’s actual initial-window handling before requesting any extension.

Validation to perform later:

- Verify exact source fields, product/period coverage and B2C company-month keys before constructing TWITTERAVG_HANDLE.SAV.
- Confirm every analysis variable consumed by TANG_TABLE789.sps has a documented producer and compare the derived monthly moving averages to the documented input contract.

### A_SAMPLE_FLAGS: Clarify the table-specific sample and B2C membership variables expected by the native analysis syntax. The GVKEY workbooks can be used as firm identifier checks only; they are not analysis input data.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SAMPLE_FLAG_DEFINITIONS
Evidence: E_FINAL56, E_FINAL789, E_SYN56_FILTER5, E_SYN56_FILTER6, E_SYN789_FILTER, E_DOC_GVKEYS, E_PROBE_GVKEY56, E_PROBE_GVKEY789

Preparation / proposed procedure:

1. Obtain the source and construction for INTABLE5, INTABLE6 and INTABLE789, including the exact definition of B2C firms whose major customer base is individuals and the table-specific sample rules.
2. Confirm how the two GVKEY identifier lists relate to the final COMP_TWITTER.SAV and IBES_TWITTER.SAV samples and what any differences mean; do not use the lists as substitutes for the SAV observations.

Validation to perform later:

- Check that each filter flag exists in its corresponding final SAV and that selected firm identifiers agree with the supplied GVKEY list at the documented table scope.
- Confirm B2C membership and all filter outcomes against the clarified author definitions before running the analyses.

### A_MANUAL_PREP_SEQUENCE: Follow the author’s documented SPSS GUI preparation sequence for all tables; the two supplied .sps files do not replace this manual stage.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_MANUAL_GUI_PREP
Evidence: E_MANUAL_GUI, E_IBES_STEP, E_COMP_Q_SOURCE, E_COMP_Q_LAG, E_COMP_A_SOURCE, E_COMP_MERGE, E_COMP_IBES_MERGE, E_DAILY_TRANSFORM, E_DAILY_WINDOW, E_DAILY_MERGE, E_HANDLE_SOURCE, E_HANDLE_WINDOW, E_FINAL56, E_FINAL789

Preparation / proposed procedure:

1. With compatible sources available, prepare the quarterly I/B/E/S sales forecast input and create LASTFORECAST.SAV using the stated ticker/period key, last-forecast selection and realized-sales missing-value rule.
2. Prepare quarterly and annual Compustat inputs; apply documented filters, duplicate handling and q−4/annual lags; prorate quarterly advertising; merge to create COMPALL.SAV, then merge with LASTFORECAST.SAV to create COMP_IBES.SAV.
3. Prepare the exact 2012–2015 LikeFolio company-day data, derive PURCHASE/POSITIVE and AVG_PURCHASE/AVG_POSITIVE using the documented 91-day rule, then merge TWITTER_AVG.SAV to COMP_IBES.SAV by ticker and fiscal-period end date to create ALL.SAV.
4. As a separate input branch, prepare the documented monthly B2C handle-classification averages in TWITTERAVG_HANDLE.SAV. Create COMP_TWITTER.SAV from ALL.SAV for tables 5–6; then join the B2C subset to TWITTERAVG_HANDLE.SAV by ticker and MONTHINDEX, apply the documented rank/missing-value/outlier steps, and create IBES_TWITTER.SAV for tables 7–9.
5. Keep the required output order and intermediate SAV files. The Excel GVKEY workbooks are identification lists only and cannot stand in for any of these generated analysis datasets.

Validation to perform later:

- At each stage, verify the documented file name, keys, output level (company-day/month/quarter), variables and required lags/windows before consuming it downstream.
- Confirm the two final SAV inputs contain all native-syntax predictors, outcomes and INTABLE flags before proceeding to the separate analysis syntax.

### A_ACTIVE_DATASET_RUN: Initialize each supplied syntax file through SPSS’s active dataset state after its corresponding final SAV has been prepared. No GET FILE statement is supplied or inferred.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_ACTIVE_DATASET
Evidence: E_SYN56_INIT, E_SYN789_INIT, E_SYN56_FILTER5, E_SYN56_FILTER6, E_SYN789_FILTER, E_DOC_ANALYSIS, E_FINAL56, E_FINAL789

Preparation / proposed procedure:

1. Open the final COMP_TWITTER.SAV as the active SPSS dataset before running TANG_TABLE56.sps; the first command saves the active data, then INTABLE5 and INTABLE6 control the table filters.
2. Open the final IBES_TWITTER.SAV as the active SPSS dataset before running TANG_TABLE789.sps; the first command saves the active data, then INTABLE789 controls its table filter.
3. Confirm whether the datasheet’s single spelling IBES_TWITTR.SAV is a typo for IBES_TWITTER.SAV, which is the Step 12 output name and native SAVE OUTFILE target.
4. Preserve the supplied GENLIN/GEE specifications, including the NAICS repeated subject, independent working correlation and robust covariance; do not substitute another estimator.

Validation to perform later:

- Before execution, confirm the active dataset identity and required outcomes/predictors/INTABLE flags for each file.
- After an authorized run, verify that each syntax file used the intended sample filter and generated the stated table analysis outputs.

### A_SPSS_PATH_CONFIG: Configure the two SPSS SAVE OUTFILE destinations for the target machine; the author’s absolute macOS paths are not assumed to exist here.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_NONPORTABLE_OUTPUT_PATH
Evidence: E_SYN56_INIT, E_SYN789_INIT

Preparation / proposed procedure:

1. Set the SAVE OUTFILE destination at lines 2–4 of TANG_TABLE56.sps to an accessible writable analysis folder on the target SPSS host while keeping the intended COMP_TWITTER.sav output name.
2. Set the corresponding SAVE OUTFILE destination at lines 2–4 of TANG_TABLE789.sps to an accessible writable folder while keeping the intended IBES_TWITTER.sav output name. No replacement path is guessed in this proposal.

Validation to perform later:

- Confirm both target directories exist and are writable under the actual SPSS runtime account before execution.
- Confirm each output path remains consistent with the prepared active dataset and expected SAV name.

### A_SPSS24_SETUP: Provide the author-specified IBM SPSS Statistics runtime and verify GENLIN/GEE entitlement for the applicable edition. No SPSS command was available on PATH, but this does not establish absence of a desktop installation or license.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SPSS24
Evidence: E_MANUAL_GUI, E_SYN56_GEE, E_SYN789_GEE, E_PUBLIC_IBM24, E_PUBLIC_IBM_CURRENT, E_PROBE_SPSS

Preparation / proposed procedure:

1. Use IBM SPSS Statistics Version 24 as documented, or establish compatibility of the selected IBM SPSS Statistics runtime with these syntax files.
2. Confirm the applicable Standard Edition or Advanced Statistics entitlement supports GENLIN with /REPEATED/GEE in the chosen release; current IBM edition documentation does not establish this machine’s v24 entitlement.
3. Do not replace the author’s GENLIN/GEE analyses with another estimator.

Validation to perform later:

- Record the actual SPSS Statistics release and licensed edition/module before running the native .sps files.
- Confirm GENLIN /REPEATED is available in that licensed runtime, then validate syntax only after the required active SAV is loaded.


## Remaining issues and prerequisites

- I_MANUAL_GUI_PREP [preparation; full_pipeline]: The 12-stage raw-to-analysis preparation workflow is documented as SPSS GUI/menu steps, not supplied executable preparation syntax. It remains part of the full pipeline and must be carried out manually once compatible inputs and SPSS access are available; the two .sps files are output analysis programs only.
- I_ACTIVE_DATASET [preparation; full_pipeline]: Each supplied analysis file starts with SAVE OUTFILE to copy the currently active SPSS dataset and then applies filters; neither opens a named input with GET FILE. The correct author-prepared SAV must be open/active before the corresponding syntax runs, with model variables and INTABLE flags present. The datasheet once says IBES_TWITTR.SAV, whereas Step 12 and the native syntax use IBES_TWITTER.SAV; confirm the intended prepared file name.
- I_NONPORTABLE_OUTPUT_PATH [preparation; full_pipeline]: Both native SPSS files write first to an absolute [redacted-path-dc0585283f88]... path. The destination is author-machine specific and must be configured to an accessible writable folder for the eventual runtime; no replacement path is assumed.
- I_FINANCE_FIELD_HISTORY [unresolved; full_pipeline]: The readable local Compustat and I/B/E/S candidates show relevant columns, but the author’s exact quarterly sales-versus-revenue field, ticker mapping, I/B/E/S sales MEASURE and actual field, STATPER/STATPERS field naming, and complete required history are not established. Quarterly q−4 and annual one-year lag history must be retained; exact earliest required dates cannot be inferred from the broad 2010 filter alone. No identical 2016 download vintage is required absent a documented vintage dependency.
- I_DAILY_VENDOR_CONTRACT [unresolved; full_pipeline]: The LikeFolio requirement is the author’s 2012–2015 per-million company-day series. The current official provider page describes a current daily product with stated history from 2016 but does not verify this same historical series, its fields/classification contract, or an independent access route. For the documented 91-day moving average, first-window history depends on the actual retained endpoints and author handling; additional pre-2012 data are not presumed. This does not establish lack of a license or justify rebuilding proprietary classifications.
- I_HANDLE_VARIABLE_MAPPING [unresolved; full_pipeline]: The monthly vendor documentation names media/expert/crowd measures (including printed labels MEIDA_AVG_PURCHASE and CROWD_AVG_PURCAHSE), while the analysis syntax expects ln_avg_news_purchase plus corrected news/expert/crowd positive variables. Exact raw columns, category denominator/units, media-to-news mapping, typos, and corrected-positive construction are unsupported. The two-month rolling history for the first retained month depends on author initial-window and sample handling; do not guess aliases or reconstruct the proprietary classification.
- I_SAMPLE_FLAG_DEFINITIONS [unresolved; full_pipeline]: The analysis syntax requires INTABLE5, INTABLE6 and INTABLE789 flags, but their producers and membership rules are not present in the supplied syntax. The datasheet describes a B2C subset by major customer base and the Excel files list GVKEYs; neither supplies full analysis rows or the flag construction. Obtain exact B2C, table-sample and GVKEY membership definitions before treating the filtered SAVs as ready.
- R_COMP_Q [undetermined]: Compustat quarterly company data required to form quarterly revenue/sales growth, other quarterly controls and q−4 lagged values. The documented extract starts 2010-01-01 and was downloaded 2016-12-30; each included outcome needs the four-quarter source observation, with the earliest needed date unresolved because the analysis start is not stated. The exact Compustat sales/revenue field and ticker-to-author OFFICIAL TICKER mapping need confirmation.
- R_COMP_A [undetermined]: Compustat annual company name, GVKEY, fiscal year, annual sales and annual advertising expense are required to build lagged annual sales/advertising and prorated quarterly advertising. The author starts 2010-01-01 and downloads through 2016-12-31; the prior-fiscal-year lag requires history before each included row, exact earliest needed date unresolved.
- R_IBES_SALES [undetermined]: I/B/E/S Summary Tape quarterly sales analyst forecasts and realized sales are required to create LASTFORECAST.SAV and unexpected sales growth. The author uses data downloaded 2016-12-09, selects the last calendar-time forecast for each official ticker/fiscal period end using STATPER, and removes 83 rows without realized sales. The start date, sales MEASURE/value, currency, realized-sales mapping and local STATPERS versus documented STATPER field naming are unresolved.
- R_LIKE_DAILY [undetermined]: LikeFolio company-day product information is a mandatory full-pipeline source for 2012-01-01–2015-12-31: DATE, TICKER and the vendor’s per-million PRODUCTTWEET, PURCHASETWEET, POSITIVETWEET and NEGATIVETWEET statistics, built using proprietary tweet-holder/target, purchase and valence classifications and product-to-company mapping. The author uses PURCHASETWEET directly and constructs POSITIVE from the positive and negative fields. The documented moving-average window is 91 days before each quarterly endpoint; whether retained earliest endpoints need pre-2012 history depends on the author’s initial-window and sample handling, which is not specified. Do not widen the stated 2012–2015 source period without evidence. Author redistribution terms do not establish whether a separate replicator license exists.
- R_LIKE_HANDLES [undetermined]: Additional LikeFolio tweet-handle classification statistics are required for the B2C subsample and tables 7–9. The source is company-month data delivered to the author on 2017-03-10, classified as media, product experts and crowd, supporting category shares of product tweets plus category PURCHASE and POSITIVE statistics. The analysis computes three-month monthly moving averages from two months before through the current month. Exact source columns, units, class construction and monthly date range are not specified. The two-month rolling history requirement for the earliest retained month depends on the author’s initial-window and sample handling.
- S_SPSS24 [unverified]: The author requires IBM SPSS Statistics Version 24. Both supplied native SPSS syntax files use GENLIN with /REPEATED for GEE, normal identity models and robust covariance. IBM v24 documentation confirms that GENLIN with REPEATED fits GEE; current IBM documentation lists Standard Edition or Advanced Statistics for GENLIN. A bounded PATH lookup found no spss/statistics/pspp command, but desktop installation, v24 compatibility and applicable module/license entitlement are unverified.

## Review notes

- Expanded source/evidence checkpoint saved after manual review of all 300 datasheet lines and both complete SPSS syntax files. Local catalog/probe/public-page checks are bounded; no author code was executed. Requirements, issues and actions are being added incrementally.
- Prior evidence-update construction attempt failed with SyntaxError: unterminated string literal (detected at line 66); the prior draft checkpoint was retained and the error was logged in draft_build_errors.json.
- Five mandatory data requirements are now checkpointed: Compustat quarterly, Compustat annual, I/B/E/S quarterly sales forecasts/actuals, LikeFolio company-day product stats, and separate monthly tweet-handle classification data. All available routes remain unverified for specific product/field/history compatibility; no redistribution or license absence is inferred.
- Software and issue checkpoint saved. Manual GUI preparation is credited separately from the two substantive analysis syntax files; runtime/license and GENLIN edition remain unverified. Issues distinguish documented preparation from unresolved source history, handle-variable mapping and table-sample flags.
- Calibration update: retained the local readable Compustat/I/B/E/S candidates without adding a blanket license or exact author-vintage prerequisite. The 91-day daily and two-month monthly rolling histories are conditional on actual retained endpoints and author initial-window handling; no pre-2012 extension is presumed.
- The frozen work item contains no dependency checklist IDs; the supplied SPSS sources are manually traced. No analysis_only scope is added because the package has only GVKEY lists, not full compatible COMP_TWITTER.SAV/IBES_TWITTER.SAV analysis data, and no supported standalone analysis-input route.
- The proposal preserves the separate daily LikeFolio 2012–2015 and monthly B2C handle-classification contracts, keeps rolling-window initial history conditional on retained endpoints/author handling, and leaves all author code unexecuted.
- Source quotes were shortened to brief exact fragments while retaining the package-relative evidence line ranges and paraphrased detail.
