# Patch proposal: jar-3704824cc27b

From implicit to explicit: The impact of disclosure requirements on hidden transaction costs

DOI: 10.1111/1475-679X.12340

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All six supplied R programs: prepare TRACE BTDS trades with Mergent FISD issuer, issue and ratings inputs; construct both the small/large and tranche datasets; run the main, tranche and cross-sectional analyses.

Entry points: `Replication Code/1_data_cleaning_selection.R`, `Replication Code/2_create_liquidity_proxies_sm_lg.R`, `Replication Code/3_create_liquidity_proxies_tranches.R`, `Replication Code/4_main_markup_analyses.R`, `Replication Code/5_tranche_markup_analyses.R`, `Replication Code/6_cross_sectional_markup_analyses.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 1/12340 - From-implicit-to-explicit-The-impact-of-disclosure-requirements-on-hidden-transaction-costs/ctw-datasheet-code-and-identifiers.zip",
      "sha256": "fc904cf45b9529bc435156901398544e9f51ef14d45faf1cfe5dc0864b08e239"
    },
    {
      "path": "JAR-Volume 59/Issue 1/12340 - From-implicit-to-explicit-The-impact-of-disclosure-requirements-on-hidden-transaction-costs/ctw-internet-appendix.pdf",
      "sha256": "12528efea5a67ebf09ec1c9f64239afffa9cb1f3e973d4a3e14d070b1deeb57c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "81aefbcfbbc958e5f99133b5aa392595667787d052d48f1c0e397fa6993fc455"
}
```

## Proposed actions

### A_TRACE_CONTRACT: Resolve the exact permitted TRACE BTDS delivery and author-export contract, including the preceding-bid lookback, before staging corp_trade_data.csv.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TRACE, I_TRACE_CONTRACT
Evidence: E_README_RAW, E_TRACE_READ, E_STATUS_FILTER, E_WRDS_TRACE_PRODUCT, E_FINRA_BTDSSPEC, E_TRACE_CATALOG, E_DATATABLE_ROLLING_JOIN, E_SMALL_LARGE_MATCH, E_TRANCHE_MATCH

Preparation / proposed procedure:

1. Confirm the available WRDS/TRACE route and whether its historical time-and-sales extract is the BTDS source used by the authors; retain the approved access conditions.
2. Map the export columns to all 13 fields selected by the cleaner and verify date/time, units, CUSIP, reported-side and counterparty meanings.
3. Resolve trc_st values and corrected/cancelled report handling against the exact BTDS export contract. Extract raw dates at least 2017-10-31 through 2018-11-21, retaining the May exclusion-window dates until after the rolling join, before creating the author-named CSV.

Validation to perform later:

- Check the staged CSV header and types against the 13 source fields selected in step 1.
- Reconcile status/correction examples to the exact BTDS specification and verify raw history starts no later than 2017-10-31 and reaches 2018-11-21, with May gap dates retained for matching.
- Confirm the staged extract does not require post-2018-11-21 trade rows for the supplied ask-anchored joins, and does not substitute generic bond or link data for corporate TRACE transactions.

### A_FISD_CONTRACT: Verify the catalog-listed native FISD candidates and prepare only the documented CSV contract if their schema and history fit.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_FISD_ISSUER, R_FISD_ISSUE, R_FISD_RATINGS, I_FISD_CONTRACT
Evidence: E_FISD_CATALOG, E_PROBE_FISD_ISSUER, E_PROBE_FISD_ISSUE_TIMEOUT_1, E_PROBE_FISD_ISSUE_TIMEOUT_2, E_PROBE_FISD_RATINGS, E_FISD_OVERVIEW, E_CLEAN_FISD_FIELDS, E_RATING_RESHAPE, E_POSITIONAL_RENAME, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Use only the exact catalog-listed FISD native candidates; resolve the issue-table timeout by an approved bounded metadata/read method, without inferring absence from the two timeouts.
2. Check issuer and issue keys/fields and STATE meaning, then map the FISD rating ISSUE_ID through issue COMPLETE_CUSIP before shaping the author's ratings input.
3. Verify rating_type values MR/SPR, duplicates and effective-date history sufficient for rolling joins on all needed TRACE rows; confirm the actual merged/joined 14-column order matches the cleaner's positional output names before running.

Validation to perform later:

- Confirm bounded readability and required field names for all three native sources.
- Check the issue_id-to-CUSIP bridge, rating categories and history over the required transaction/pair period.
- Compare the resulting prepared input headers and joined column order to the frozen cleaner source before author execution.

### A_R_PACKAGE_SETUP: Prepare the 11 packages directly loaded by the supplied R programs in an approved user R library.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_DATA_TABLE, SW_TIDYVERSE, SW_LUBRIDATE, SW_STRINGR, SW_DESCTOOLS, SW_GGPLOT2, SW_GGTHEMES, SW_STARGAZER, SW_LFE, SW_DUMMIES, SW_CAR
Evidence: E_R_PACKAGE_SCAN, E_PACKAGE_LIBS_STEP1, E_PACKAGE_LIBS_STEP2, E_PACKAGE_LIBS_ANALYSIS, E_PACKAGE_LIBS_TRANCHE_ANALYSIS, E_PACKAGE_LIBS_CROSS_ANALYSIS

Preparation / proposed procedure:

1. Select compatible versions of data.table, tidyverse, lubridate, stringr, DescTools, ggplot2, ggthemes, stargazer, lfe, dummies and car for the chosen R environment; do not install during this assessment.
2. Record the selected package versions, especially the DescTools Winsorize interface, and make the user library available to the future R session.

Validation to perform later:

- In the authorized future R environment, query packageVersion() for each listed package and confirm each required library() call loads.
- Confirm the selected DescTools formals support either the unchanged author call or the conditional source edit in A_WINSORIZE_API.

### A_WINSORIZE_API: If the selected DescTools release uses the current val interface, replace both legacy calls with the same 1st/99th quantile limits.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: I_WINSORIZE_API
Evidence: E_WINSORIZE_SMALL, E_WINSORIZE_TRANCHE, E_DESCTOOLS_CHANGE, E_DESCTOOLS_CURRENT_API

**Proposed edit:** `Replication Code/2_create_liquidity_proxies_sm_lg.R:85–85`
Source SHA-256: `c542a74eea8f1e3861cfa2a40f9397c3749ebbbfed1072fed3c920d5ccc1bef1`

Current DescTools documents val as the quantile limit pair; this retains the author's 1st/99th percentiles and NA removal.

Current text:
```
winsorize <- function(x){Winsorize(x, minval = NULL, maxval = NULL, probs = c(0.01, 0.99), na.rm = TRUE)}
```

Proposed replacement:
```
winsorize <- function(x){Winsorize(x, val = quantile(x, probs = c(0.01, 0.99), na.rm = TRUE))}
```

**Proposed edit:** `Replication Code/3_create_liquidity_proxies_tranches.R:85–85`
Source SHA-256: `39cd413814132a244302ef6e054b480002f53410568bb2aee89fc552817b4bed`

Current DescTools documents val as the quantile limit pair; this retains the author's 1st/99th percentiles and NA removal.

Current text:
```
winsorize <- function(x){Winsorize(x, minval = NULL, maxval = NULL, probs = c(0.01, 0.99), na.rm = TRUE)}
```

Proposed replacement:
```
winsorize <- function(x){Winsorize(x, val = quantile(x, probs = c(0.01, 0.99), na.rm = TRUE))}
```

Preparation / proposed procedure:

1. Check the chosen DescTools version before applying; retain the author call unchanged if that version supports its legacy arguments.

Validation to perform later:

- Under the selected DescTools release, confirm the call computes the same 1st/99th quantile limits with na.rm=TRUE in both construction branches.

### A_DTABLE_NULL_REMOVAL: Verify the two branches' NULL-removal chains against the selected data.table version after confirming the cleaner's actual output columns.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DTABLE_NULL_REMOVAL
Evidence: E_CLEAN_RDS_PRODUCER, E_DROPPED_ABSENT_FIELDS, E_DROPPED_ABSENT_FIELDS_TRANCHE, E_R_PACKAGE_SCAN

Preparation / proposed procedure:

1. After package versions are fixed, confirm from the selected data.table reference/version behavior how the NULL-removal chain treats offer_price_takedown_indicator and callable when absent; do not add either as a raw input field.
2. If the selected data.table version rejects the operation, propose a branch-local removal expression that intersects the deletion list with existing cleaned columns.

Validation to perform later:

- Confirm both branch cleanup chains proceed with the cleaner-produced column set and preserve all variables consumed downstream.

### A_RUN_ALL_PROGRAMS: After data contracts and package preparation are resolved, run both construction branches and all supplied analyses from the shared relative-path root.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_README_SCOPE, E_README_BRANCHES, E_README_ANALYSES, E_STEP2_RELATIVE_ROOT, E_CLEAN_RDS_PRODUCER, E_SMALL_LARGE_PERIOD, E_TRANCHE_PERIOD, E_MAIN_ANALYSIS_CONSUMER, E_TRANCHE_ANALYSIS_CONSUMER, E_CROSS_ANALYSIS_CONSUMER

Preparation / proposed procedure:

1. From Replication Code, run 1_data_cleaning_selection.R; then run both 2_create_liquidity_proxies_sm_lg.R and 3_create_liquidity_proxies_tranches.R.
2. Run 4_main_markup_analyses.R and 6_cross_sectional_markup_analyses.R against liq_dt_corp_sm_lg.RDS, and run 5_tranche_markup_analyses.R against liq_dt_corp_tranches.RDS.

Validation to perform later:

- Confirm step 1 creates corp_trd_dt_cleaned.RDS; step 2 and step 3 create their named branch RDS files; each named analysis reads the intended producer output.
- Review all six programs' regression/table outputs and the retained sample, tranche definitions, seven-day pairing and analysis splits against the supplied code and paper targets.


## Remaining issues and prerequisites

- I_TRACE_CONTRACT [unresolved; full_pipeline]: The required corporate BTDS export's precise WRDS fields, status mapping and correction/cancellation handling are unresolved. The code forms combined_bid[combined_ask, roll=7] before filtering: ask-side dates anchor each result and preceding bids carry forward by up to seven calendar-Date units. The raw period therefore needs a lookback to 2017-10-31 and history through 2018-11-21, with May gap dates retained until after matching; the prior late-November post-window extension was unsupported.
- I_FISD_CONTRACT [unresolved; full_pipeline]: Native FISD candidates have useful matching field names, but the issue table has no successful bounded row read, ratings use ISSUE_ID rather than the author's COMPLETE_CUSIP, rating labels/history are unverified, and the cleaner's 14-position post-join rename requires confirming actual join column order and STATE mapping.
- I_WINSORIZE_API [unresolved; full_pipeline]: Both construction branches call Winsorize with minval/maxval/probs/na.rm, while current DescTools documentation uses val and its 0.99.55 notes describe the interface change. The author package version is unspecified and DescTools is absent locally, so the source edit is conditional on the selected target version.
- I_DTABLE_NULL_REMOVAL [unresolved; full_pipeline]: Both construction scripts attempt to remove offer_price_takedown_indicator and callable although the cleaner's selected output omits them. Their behavior under the eventual data.table version is unverified; treat this as a conditional cleanup check, not a raw-source field requirement or a confirmed blocker.
- R_TRACE [undetermined]: Corporate TRACE BTDS transaction history in the author's corp_trade_data.csv contract, including all 13 selected fields, retained ask-side dates 2017-11-07 through 2018-11-21, and preceding customer-purchase history back through 2017-10-31 for the seven-day calendar-Date roll; preserve intervening dates, including the May exclusion window, until after matching, with source status/correction/cancellation semantics resolved.
- R_FISD_ISSUER [undetermined]: Mergent FISD issuer records keyed by ISSUER_ID and providing STATE for the issue/issuer merge used by the cleaner.
- R_FISD_ISSUE [undetermined]: Mergent FISD issue records keyed for the cleaner's join, with COMPLETE_CUSIP, ISSUE_ID, ISSUER_ID, offering/maturity/coupon fields and bond filter indicators.
- R_FISD_RATINGS [undetermined]: Historical Mergent FISD issue ratings sufficient for the cleaner's rolling trade-date joins, with rating type, date and value history mapped to the issue CUSIP.
- SW_DATA_TABLE [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: data.table.
- SW_TIDYVERSE [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: tidyverse.
- SW_LUBRIDATE [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: lubridate.
- SW_STRINGR [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: stringr.
- SW_DESCTOOLS [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: DescTools.
- SW_GGPLOT2 [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: ggplot2.
- SW_GGTHEMES [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: ggthemes.
- SW_STARGAZER [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: stargazer.
- SW_LFE [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: lfe.
- SW_DUMMIES [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: dummies.
- SW_CAR [preparation_required]: Required by the supplied R scripts but absent from the checked clean R 4.5.0 --vanilla library paths: car.

## Review notes

- Coverage includes the README-required six-program workflow, both small/large and tranche construction branches, and all three supplied analyses. The prepared RDS files are generated by included producers and were not treated as external inputs.
- The packaged CUSIP CSV is an identifier list only. No author R program, estimator, model, or generated RDS was executed or deserialized.
- Native FISD issuer and ratings files yielded bounded one-row reads; the larger issue file timed out twice. Those timeouts leave issue-table readability unresolved and do not indicate absence. Rating history/key mapping and positional join output are unresolved.
- TRACE product/export, exact BTDS fields, status meanings, correction/cancellation handling and full pairing history remain unresolved. WRDS or ‘free through WRDS’ wording was not treated as public/open access.
- The repeated S&P investment-grade term in the supplied high_yield expression is explicit executable code; preserve it as authored unless a supported paper definition justifies a conditional change.
- The later NULL-removal chains name fields omitted from the cleaner's selected output. Their target-version data.table behavior remains a software/API check, not a raw-field requirement or asserted blocker.
- DescTools is unavailable in the checked runtime, and the author package version is unspecified. The current-interface edit is conditional; no package was installed.
