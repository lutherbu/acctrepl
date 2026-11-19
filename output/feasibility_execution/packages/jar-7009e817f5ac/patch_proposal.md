# Patch proposal: jar-7009e817f5ac

The Value of Crowdsourced Earnings Forecasts

DOI: 10.1111/1475-679X.12121

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The single supplied SAS program covers six main-results sections for Tables 1–10 and Figures 1–3. It depends on external/author-prepared mylib inputs, while the included online appendix has supplementary analyses with no executable workflow in the package. No analysis-only dataset route is supplied.

Entry points: `codevaluecrowdsourcedearningsforecastsjar2016.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 4/12121 - The-Value-of-Crowdsourced-Earnings-Forecasts/codevaluecrowdsourcedearningsforecastsjar2016.sas",
      "sha256": "f889f73491eea0dd5e67f4ef7ca682d8ed729ca9e8d78f67677487f8784a2b9b"
    },
    {
      "path": "JAR-Volume 54/Issue 4/12121 - The-Value-of-Crowdsourced-Earnings-Forecasts/datadescriptionsheetjohnstoncrowds.pdf",
      "sha256": "6145c3d576929a10ba07afbd84f8336b543340cd36f2b2c5a695dfd2af54676e"
    },
    {
      "path": "JAR-Volume 54/Issue 4/12121 - The-Value-of-Crowdsourced-Earnings-Forecasts/onlineappendixjohnston.pdf",
      "sha256": "4f1d4846a841233fdbf0ecebb6d6d12ed430852fbcc38d80ad0ecd0282633210"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "ce44772da901d8ff9f9ba4b2ded5bbacbc3376aeb298de27b7eafae7822528a6"
}
```

## Proposed actions

### ACT_ESTIMIZE: Request the author Estimize inputs and resolve the separate unadjusted dataset contract.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_ESTIMIZE, REQ_EST_UNADJ, ISSUE_HIDDEN_INPUTS
Evidence: EV_EST_FIELDS, EV_EST_PERIOD, EV_DS_EST, EV_EST_UNADJ, EV_MYLIB_INTERNAL

Preparation / proposed procedure:

1. Request the 2012–2013 mylib.estimize file or a versioned, documented extract with ticker, fiscal year/quarter, EPS fields, date strings, username, flagged and bio fields.
2. Request mylib.estimize_unadjusted separately and obtain the definition and producer for bad_actuals; do not assume it can be reconstructed from the primary Estimize table.
3. Record current delivery route and data vintage; historical direct provision is not proof of current access.

Validation to perform later:

- Use bounded metadata to verify all fields, types, date interpretations and 2012–2013 event coverage.
- Confirm the unadjusted actual comparison input aligns with the Table 10 ticker/date keys and defines bad_actuals.

### ACT_IBES: Obtain author-compatible IBES detail, summary, recommendation, guidance, and ticker-link inputs.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_IBES_DETAIL, REQ_IBES_SUMMARY, REQ_IBES_RECS, REQ_IBES_GUIDANCE, REQ_IBES_LINK
Evidence: EV_IBES_DETAIL, EV_SUMMARY, EV_REC, EV_GUIDE, EV_LINK, EV_DS_IBES, EV_CATALOG, EV_P_IBES_DETAIL, EV_P_IBES_SUM, EV_P_IBES_GUIDE, EV_P_IBES_LINK

Preparation / proposed procedure:

1. Request the author input tables or exact IBES products and extraction metadata corresponding to the 2014-09-12 download.
2. Confirm detailed EPS fields TICKER/CUSIP/OFTIC/ANALYS/FPI/VALUE/ANNDATS/ACTUAL/ANNDATS_ACT and summary fields OFTIC/CUSIP/NUMEST/MEANEST/MEDEST/STDEV/ACTUAL/ANNDATS_ACT/STATPERS/FPEDATS/FPI.
3. Request detail recommendations with IRECCD/OFTIC/ANNDATS; reconcile the data sheet’s “summary recommendations” label and confirm event-code meanings.
4. Request DHGDET_US with IBES_TKR/Announce_dt and verify whether local DET_GUIDANCE TICKER/ANNDATS fields map to it.
5. Verify the author’s mapping file at the cited page and compare it with local IBCRSPHIST; do not infer sdate/edate aliasing or link equivalence.

Validation to perform later:

- For each source, verify field types, date periods, source product, historical coverage and snapshot before use.
- Confirm every input can be represented under the exact mylib dataset names expected by the SAS program.

### ACT_CRSP: Obtain CRSP author files or a complete documented construction for the daily and size inputs.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_CRSP_RET, REQ_CRSP_VOL, REQ_SIZE_ADJ, ISSUE_HIDDEN_INPUTS
Evidence: EV_CRSP_T2, EV_CRSP_EVENT, EV_SIZE, EV_DS_CRSP, EV_P_CRSP_DSF, EV_P_CRSP_DSI, EV_P_CRSP_NAMES, EV_P_CRSP_MSF

Preparation / proposed procedure:

1. Request mylib.ret11_13, mylib.volume_shrout11_13, and mylib.size_adjustments or their exact extraction/merge recipes for the author’s 2014-09-14 CRSP snapshot.
2. Verify ret11_13 contains PERMNO/ticker/CUSIP/NCUSIP/date/PRC/RET and EWRETD/VWRETD; verify volume_shrout11_13 contains PERMNO/date/VOL/SHROUT.
3. For size_adjustments, obtain the year coverage and source-to-author mapping of DATE/PERMNO/PRC/SHROUT/SHRCD/EXCHCD. Local CRSP tables are candidates, not a verified author preparation.

Validation to perform later:

- Verify full required dates, units, identifiers and vintage from source metadata or author documentation.
- Confirm size_adjustments supplies the December records and share/exchange codes used by the original ranking procedure.

### ACT_COMP: Obtain or verify the annual Compustat CEQ input.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_COMP_CEQ
Evidence: EV_COMP, EV_DS_COMP, EV_P_COMP

Preparation / proposed procedure:

1. Request mylib.compustat10_14 or the exact Compustat annual extract corresponding to the 2015-07-18 download.
2. Confirm DATADATE/CUSIP/TIC/CEQ and 2010–2014 coverage; the supplied main code uses annual CEQ.

Validation to perform later:

- Verify field types, CUSIP formatting, period and CEQ units.
- Confirm the prepared input joins on the code’s year and CUSIP keys.

### ACT_CUMDAY: Request the missing cumday map and confirm its origin/count contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CUMDAY, ISSUE_CUMDAY_SPEC
Evidence: EV_CUMDAY_HEAD, EV_CUMDAY_CODE, EV_INVENTORY

Preparation / proposed procedure:

1. Ask for the prepared DATE/CUMDAY file or its exact construction and all event-window dates.
2. Resolve the header’s January 1, 2013 phrase against the listed Dec. 30, 2011=0, Jan. 3, 2012=1 and Dec. 31, 2013=502 mapping.

Validation to perform later:

- Verify unique date-to-day rows for the complete date range used by each event study.
- Check the author-specified boundary counts before execution.

### ACT_MYLIB: Resolve the SAS mylib assignment and input/output location.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISSUE_MYLIB
Evidence: EV_MYLIB, EV_AUDIT, EV_INVENTORY

Preparation / proposed procedure:

1. Obtain the physical location, formats and any author include/autoexec that assigns mylib.
2. Configure the libref only after the directory is known and all input datasets are available; document a separate writable location for generated outputs.

Validation to perform later:

- Confirm SAS resolves mylib and bounded PROC CONTENTS lists the required input names/fields.
- Confirm output paths are writable and do not overwrite author source data.

### ACT_APPENDIX: Request the separate executable workflow and input contracts for the online appendix analyses.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_APPENDIX
Evidence: EV_SCOPE, EV_APPENDIX, EV_APPENDIX_IA8, EV_INVENTORY

Preparation / proposed procedure:

1. Ask the authors for code, preparation steps and input schemas for the robustness and supplementary analyses reported in the online appendix.
2. Keep the supplied SAS file scoped to main results; do not reconstruct appendix estimates from formulas or result tables.

Validation to perform later:

- Map each supplemental table to its entry point and required inputs before claiming full paper coverage.

### ACT_SAS: Verify the SAS runtime and procedures after the local startup failure is resolved.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, ISSUE_SAS
Evidence: EV_ENV, EV_PROCS

Preparation / proposed procedure:

1. Ask the SAS environment owner to diagnose the TKELS/Launch Service Load Failure; do not infer a license problem from this probe.
2. Confirm the runtime version and needed statistical procedures before any authorized study run.

Validation to perform later:

- Perform a minimal environment-only startup/version query after remediation.
- Check required procedures without executing the study program.

### ACT_COMMENT: Confirm the standalone block-comment terminator at line 486.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_COMMENT
Evidence: EV_COMMENT_LINE, EV_COMMENT_SCAN

Preparation / proposed procedure:

1. Ask the source maintainer whether line 486 is an unmatched terminator or whether an intended opener is missing.
2. Do not delete or move the token without confirmation.

Validation to perform later:

- After author confirmation, syntax-check a copy and confirm the annual char2 construction remains active.


## Remaining issues and prerequisites

- ISSUE_MYLIB [unresolved; full_pipeline]: The program expects and writes numerous mylib datasets, but its physical library location or include/autoexec assignment is unresolved; the static audit marks the mylib edges dynamic.
- ISSUE_HIDDEN_INPUTS [unresolved; full_pipeline]: The source reads mylib.size_adjustments and mylib.estimize_unadjusted without producing them. Their source construction, exact coverage, and (for bad_actuals) definition are unknown.
- ISSUE_CUMDAY_SPEC [unresolved; full_pipeline]: The required cumday helper is absent and has no producer. Its header says January 1, 2013 while its listed values and later comment establish a 2012 mapping; obtain the prepared file and confirm the intended origin.
- ISSUE_APPENDIX [unresolved; full_pipeline]: The supplied SAS entry covers the main Tables 1–10 and Figures 1–3; the included online appendix documents separate robustness/supplementary analyses without executable code or input contracts.
- ISSUE_SAS [unresolved; full_pipeline]: The local SAS startup probe fails at TKELS/Launch Service Load Failure before establishing a usable runtime/version; it is not evidence that SAS is unlicensed.
- ISSUE_COMMENT [unresolved; full_pipeline]: The source-text marker scan finds a standalone */ at line 486, before the only other block-comment opener at line 2117. Confirm the intended boundary before execution; no replacement is inferable from the package.
- REQ_ESTIMIZE [undetermined]: Author-provided Estimize forecasts read as mylib.estimize. Required fields include ticker, fiscal year/quarter, epsactual, epswallstreet, eps, estdate, actdate, username, flagged, and bio1–bio3; the analysis sample uses 2012–2013.
- REQ_IBES_DETAIL [undetermined]: IBES detailed EPS forecast history read as mylib.detail_forecasts; code uses TICKER/CUSIP/OFTIC, ANALYS, FPI, VALUE, ANNDATS, ACTUAL and ANNDATS_ACT for the 2012–2013 sample.
- REQ_CRSP_RET [undetermined]: mylib.ret11_13 supplies daily return/price and identifiers, plus EWRETD/VWRETD for event studies. Required author fields include PERMNO, ticker, CUSIP/NCUSIP, date, PRC, RET, EWRETD and VWRETD.
- REQ_CRSP_VOL [undetermined]: mylib.volume_shrout11_13 supplies daily PERMNO/date/volume/shares outstanding for turnover and size measures.
- REQ_COMP_CEQ [undetermined]: mylib.compustat10_14 supplies annual CEQ matched by year/CUSIP; code reads DATADATE, CUSIP, TIC and CEQ.
- REQ_IBES_LINK [undetermined]: mylib.ibes_ticker_permno requires TICKER, PERMNO, STARTDATE and ENDDATE; the program keeps links whose end year is 2011 or later.
- REQ_IBES_SUMMARY [undetermined]: mylib.ibes_consensus supplies IBES summary EPS observations; the code uses OFTIC, CUSIP, NUMEST, MEANEST, MEDEST, STDEV, ACTUAL, ANNDATS_ACT, STATPERS, FPEDATS and FPI.
- REQ_CUMDAY [undetermined]: mylib.cumday is a prepared date-to-trading-day lookup with DATE and CUMDAY; comments specify Dec. 30, 2011=0, Jan. 3, 2012=1, and Dec. 31, 2013=502.
- REQ_SIZE_ADJ [undetermined]: Unproduced mylib.size_adjustments requires DATE, PERMNO, PRC, SHROUT, SHRCD and EXCHCD; code selects December observations for SHRCD 10–11 and EXCHCD 1. Exact year coverage and source construction are unknown.
- REQ_IBES_RECS [undetermined]: mylib.detail_recs supplies IRECCD, OFTIC and ANNDATS for recommendation-event exclusion. Data sheet calls out summary recommendations, so product/event-code equivalence is unresolved.
- REQ_IBES_GUIDANCE [undetermined]: mylib.DHGDET_US supplies IBES_TKR and Announce_dt for 2011–2013 guidance events.
- REQ_EST_UNADJ [undetermined]: Unproduced mylib.estimize_unadjusted is read for ticker, act_date, epsactual and bad_actuals; code does not define the table’s construction or bad_actuals meaning.
- SW_SAS [unverified]: SAS is required by the supplied entry program. The local SAS launcher fails at TKELS initialization, leaving usable runtime/version and procedure availability unverified; this does not prove a missing license.

## Review notes

- All 18 frozen dependency IDs are reviewed. The bounded local probes read 10 rows each and establish readability/sampled columns only, not population, period, vintage, or author-preparation equivalence.
- The data sheet documents historical source downloads and no agreed data restrictions; current access was not verified and no access barrier is inferred.
- No analysis_only scope is supported because the package contains no prepared analysis dataset and the raw-to-author input construction is incomplete.
- The supplied author SAS program and regressions were not executed. A first draft-generation command stopped on a Python syntax typo before writing; the corrected builder below writes the checkpoint.
