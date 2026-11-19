# Patch proposal: jar-6042eb116efd

How Do Firms Respond to Uncertainty? Evidence from U.S. Gubernatorial Elections

DOI: 10.1111/1475-679X.12482

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: Stata data construction followed by the separate Stata exhibits driver, retaining all figure/table branches and prepared-data handoffs. No analysis-only route is supported because estimationdata is generated and not packaged.

Entry points: `politicaluncertainty_dataconstruction.do`, `politicaluncertainty_exhibits.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 4/12482 - How-Do-Firms-Respond-to-Uncertainty-Evidence-from-U-S-Gubernatorial-Elections/bkr-datasheet-code-and-identifiers.zip",
      "sha256": "49ffd3d2a93b7bd61ddfb7f2d7f2a30c53dc504c9a69a53329473d0ff6889d8b"
    },
    {
      "path": "JAR-Volume 61/Issue 4/12482 - How-Do-Firms-Respond-to-Uncertainty-Evidence-from-U-S-Gubernatorial-Elections/bkr-online-appendix.pdf",
      "sha256": "47d54916ea1d407b0cc065140b55fdf3d2d5a3b8cbb228beca68a816a3b5f4f7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "889ba718ebc0cf74264745838480ecbcd63c2926e174aba45f3391d0ad55cbc0"
}
```

## Proposed actions

### ACT_DATA_DIRECTORY_STAGE: Prepare a separate author working copy with the exact author-provided DTA files staged in the documented Data folder, preserving original bytes and using the package inventory as the source.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_AGGSTATE, REQ_8KCONTENT, REQ_POLLPANEL
Evidence: E_README_SETUP, E_CODE_DATADIR, E_PROBE_AGGSTATE, E_PROBE_8KCONTENT, E_PROBE_POLLPANEL, E_DATASHEET_PACKAGE

Preparation / proposed procedure:

1. Create a disposable copy of the author package and a Data/ folder beneath its package root.
2. Copy aggregatestate_nodc.dta, 8kcontent.dta and pollpanel.dta into Data/ without conversion; retain their package SHA-256 values.

Validation to perform later:

- Before any separately authorized run, confirm the staged names and SHA-256 values match the author package and confirm the bounded-probe field contracts.

### ACT_CONFIRM_8K_PRODUCER: Obtain the author-supplied 8kaggregate input or its producer and exact field/date/identifier contract; do not substitute the separate packaged 8kcontent file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_8KAGGREGATE, ISSUE_8K_PRODUCER
Evidence: E_CODE_8KAGGREGATE, E_CODE_8K_AGGREGATE_RETURN_STAGE, E_CODE_8KFULLMONTHLY_OUTPUT, E_DATASHEET_PACKAGE

Preparation / proposed procedure:

1. Resolve the intended 8kaggregate.dta producer or prepared author file, required item/count fields, identifiers and period.

Validation to perform later:

- Compare the delivered input and both direct reads with the documented input contract before running downstream construction.

### ACT_CONFIRM_EVENT_RETURNS: Resolve the author-prepared CRSP daily event-study result that maps to announcementreturns, including the return definition, keys, source period and access route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_ANNOUNCEMENT_RETURNS, ISSUE_EVENT_RETURN_INPUT
Evidence: E_CODE_ANNOUNCEMENT_RETURNS, E_CODE_8K_AGGREGATE_RETURN_STAGE, E_README_CRSP_LM, E_PUBLIC_WRDS_EVENT

Preparation / proposed procedure:

1. Obtain the exact author-prepared announcementreturns file or its documented producer and field mapping for CIK, repdate, CUSIP and aret3day.
2. Confirm the required CRSP daily stock access route and current entitlement without inferring access from a catalog result or generic product terms.

Validation to perform later:

- Confirm the event-window and three-day cumulative-return definition, join keys and required observation coverage before the return-panel merge.

### ACT_CONFIRM_ELECTION_IMPORT: Resolve the election workbook's intended worksheet, range, header and mapping to the extensionless Stata electiondata input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_ELECTIONDATA, ISSUE_ELECTION_WORKBOOK_CONTRACT
Evidence: E_CODE_ELECTION_JOIN, E_CODE_ELECTION_FIELDS, E_PROBE_ELECTION_XLSX, E_DATASHEET_PACKAGE

Preparation / proposed procedure:

1. Obtain the supported sheet/header/range and import conventions for state, electionyear, electiondate, margin, term, contested and gridlock.
2. Do not infer missing data fields from the workbook title or blank first-sheet headers.

Validation to perform later:

- After an authorized conversion, verify the join keys and retained election fields against the code's state/electiondate and state/electionyear operations.

### ACT_CONFIRM_8KCONTENT_CIK_MONTH: Resolve the exact producer or prepared input for the CIK-month 8-K content panel consumed as 8kcontent_cik_ym.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_8KCONTENT_CIK_MONTH, ISSUE_8KCONTENT_CIK_MONTH_PRODUCER
Evidence: E_CODE_8KCONTENT_CIK_MONTH_READ, E_CODE_8KCONTENT_FIRST_OUTPUT, E_CODE_8KCONTENT_SECOND_SAVE, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Obtain the author-supplied 8kcontent_cik_ym producer/input and its CIK/month keys and risk-field contract; keep it separate from the CIK-state-month outputs.

Validation to perform later:

- Verify the exact basename, CIK/ym keys and allrisk/top10risk/top20risk fields before the estimation merge.

### ACT_CONFIRM_COMPSTAT_FIELDS: Resolve the author-compatible annual and quarterly Compustat release/preparation, including the quarterly history/population and field contract used before sample-specific estimation filters.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMPANNUAL, REQ_COMPQUARTERLY, ISSUE_COMPQUARTERLY_FIELD_CONTRACT
Evidence: E_CODE_COMPANNUAL, E_CODE_COMPQUARTERLY, E_RESOURCE_CATALOG, E_LOOKUP_COMPANNUAL, E_LOOKUP_COMPQUARTERLY, E_PROBE_COMPANNUAL, E_PROBE_COMPQUARTERLY

Preparation / proposed procedure:

1. For annual data, verify the intended NAICS field/release behind the code's `naics` keep; the local candidate exposes `naicsh`.
2. For quarterly data, resolve the intended imported history/population, confirm yq exists at the earlier duplicates drop, and document sic/cusip6 fields later retained; do not guess aliases or infer the historical extract from the one-row probe.

Validation to perform later:

- Compare the exact input schema and documented period/population with every field used before a separately authorized merge/model run.

### ACT_CONFIRM_LM_HEADER: Resolve the author-named 1994-2017 LM header CSV or a documented mapping from the current repository release to the exact code fields.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_LM_HEADER
Evidence: E_CODE_LMHEADER, E_README_CRSP_LM, E_PUBLIC_LM_PERIOD, E_PUBLIC_LM_FORMAT, E_PUBLIC_LM_FIELD, E_LOCAL_DOC_PATHS, E_PUBLIC_SEC_FILINGS, E_PUBLIC_LM_CIK_FIELD, E_PUBLIC_LM_FISCAL_FIELD

Preparation / proposed procedure:

1. Request the exact augmented-header CSV or documented source-field/date mapping for f_year, f_quarter, f_yq, state_of_incorp, ba_state, ma_state and cik.
2. Treat the checked cleaned LM corpus and SEC filing directories as candidates only; no exact file or text-to-header producer was verified.

Validation to perform later:

- Before running the state merge, confirm source fields, filing/population coverage for 1994-2017, and CIK/fiscal-year keys.

### ACT_CONFIRM_BEA_COLUMNS: Resolve the exact BEA 2002 source file, table level/sheet and column mapping that produces bea_output_table.csv and pctstate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_BEA_IO
Evidence: E_CODE_BEA, E_PUBLIC_BEA, E_README_EPU_BEA_VIX

Preparation / proposed procedure:

1. Obtain the author-specified BEA file or a documented XLS-to-CSV transformation that preserves v1, required s/f/t columns, industry rows and pctstate.
2. Do not choose a detailed, summary or supplementary table or infer field formulas from a similar page description.

Validation to perform later:

- Compare imported fields and NAICS4 identifiers against the required GovUse and annual-Compustat join before execution.

### ACT_CONFIRM_MACRO_INPUTS: Complete the three macro-input contracts and monthly key transformations used to create macro controls.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CRSP_MONTHLY, REQ_VIX, REQ_GLOBAL_EPU
Evidence: E_CODE_MARKET_CONTROLS, E_LOOKUP_CRSP_MONTHLY, E_PROBE_CRSP_MONTHLY, E_PUBLIC_CBOE_VIX, E_PUBLIC_EPU_HISTORY, E_PUBLIC_EPU_CURRENT_PRICE

Preparation / proposed procedure:

1. For local CRSP.MSI, document the source DATE-to-ym conversion and confirm coverage while preserving vwretd/sprtrn.
2. For Cboe VIX, obtain the author's required month statistic and column mapping from daily closes; do not pick an aggregation without support.
3. For Global EPU, obtain the current-price monthly series and document the exact input header/key mapping to GlobalEPUIndexwithCurrentPr.

Validation to perform later:

- Verify all three inputs use the same Stata monthly ym convention and cover the actual estimation event windows before constructing macro controls.

### ACT_CONFIRM_EXHIBIT_FIELDS: Obtain the source/producer definitions for assets, stateelection and uncertaintrend used by the exhibits companion.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_EXHIBIT_VARIABLE_PRODUCERS
Evidence: E_EXHIBITS_ASSETS, E_EXHIBITS_STATEELECTION, E_EXHIBITS_UNCERTAINTYTREND, E_CODE_POLL_TREND_PRODUCER, E_CODE_COMPQUARTERLY, E_CODE_8KAGGREGATE

Preparation / proposed procedure:

1. Ask which supplied producer or prepared field supplies assets and stateelection and how uncertaintrend is constructed.
2. Do not substitute Compustat atq for assets or annpollmargintrend for uncertaintrend without an author-supported mapping.

Validation to perform later:

- Before the companion run, verify each named field is present in estimationdata or its stated companion input and has the documented meaning.

### ACT_MAPTILE_SETUP: Set up the two missing author-named mapping commands and the separate state geography required by geo(state) in the author-selected Stata environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SOFT_MAPTILE, SOFT_SPMAP, ISSUE_MAPTILE_STATE_GEOGRAPHY
Evidence: E_CODE_EXHIBITS_ADDONS, E_PROBE_SOFTWARE_MAPTILE, E_PROBE_SOFTWARE_SPMAP, E_EXHIBITS_STATE_PANEL, E_PUBLIC_MAPTILE, E_PUBLIC_MAPTILE_SPMAP

Preparation / proposed procedure:

1. In a separately authorized environment, install/version-pin maptile and spmap from their documented Stata source after recording the current Stata/ado paths.
2. Resolve the state geography template used by geo(state) and its local location; keep this resource separate from author data files.
3. Do not rely on the code's runtime ssc install statements to silently mutate the environment during a production run.

Validation to perform later:

- Use bounded package/geography metadata checks to confirm the exact maptile, spmap and geo(state) resources are present before the Figure 2 branch.

### ACT_FUTURE_RUN_PROCEDURE: After every unresolved producer, field contract and setup item above is resolved, run the author's two supplied Stata programs in their documented order from a disposable working copy.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_README_ENTRYPOINTS, E_README_SETUP, E_CODE_DATADIR, E_EXHIBITS_INPUTS, E_WORKFLOW_TRACE, E_ENVIRONMENT, E_DATASHEET_REGHDFE_WARNING

Preparation / proposed procedure:

1. Start each driver from the author package root so its `cd Data/` resolves to the staged folder; run politicaluncertainty_dataconstruction.do first.
2. Run politicaluncertainty_exhibits.do as a second process from the package root, or explicitly return to the root before invoking it because both drivers change into Data/.
3. Record the exact Stata and add-on versions, source/input hashes, working directory, exit status, and separate stdout/log streams; keep generated outputs in Data/.

Validation to perform later:

- Confirm all construction intermediates are produced in order, required field contracts hold, all figures/tables complete, and any scope-specific unknowns are resolved; this assessment itself did not verify execution.


## Remaining issues and prerequisites

- ISSUE_8K_PRODUCER [unresolved; full_pipeline]: The construction program reads 8kaggregate.dta and extensionless 8kaggregate, then uses them to produce 8kmonthly and 8kfullmonthlypanel. The package contains 8kcontent.dta instead and supplies no producer or exact schema for 8kaggregate; the two packaged files must not be treated as interchangeable.
- ISSUE_EVENT_RETURN_INPUT [unresolved; full_pipeline]: The supplied code joins announcementreturns to 8kaggregate on CIK and repdate and uses CUSIP/aret3day. The author source names CRSP U.S. Daily Event Study three-day returns, while the WRDS page's upload route requires CRSP daily stock-file subscription; the prepared result, field mapping and current entitlement are unknown.
- ISSUE_ELECTION_WORKBOOK_CONTRACT [unresolved; full_pipeline]: The packaged electiondata.xlsx is not established as the extensionless Stata dataset consumed by joinby. The intended worksheet, data range, header row and mapping to state/electionyear/electiondate/margin/term/gridlock remain unknown.
- ISSUE_8KCONTENT_CIK_MONTH_PRODUCER [unresolved; full_pipeline]: The estimation build reads 8kcontent_cik_ym, but the supplied construction code saves 8kcontent_cik_state_ym and 8kstate_cik_state_ym; neither is the named CIK-month input and no producer for the required allrisk/top10risk/top20risk panel is supplied.
- ISSUE_COMPQUARTERLY_FIELD_CONTRACT [unresolved; full_pipeline]: The exact local COMP.FUNDQ candidate is readable but lacks yq, sic and cusip6 in its observed columns. The supplied code uses yq in duplicates drop before generating yq from datadate, then winsorizes roa, size, m2b and lev on the imported quarterly input before later estimation filters. The intended release history/population and an author-compatible field preparation are not documented; do not infer them from the one-row local probe.
- ISSUE_EXHIBIT_VARIABLE_PRODUCERS [unresolved; full_pipeline]: The exhibits companion uses assets, stateelection and uncertaintrend, but the supplied source does not document their producers. The construction code creates annpollmargintrend, yet no evidence supports substituting it for uncertaintrend; assets may depend on the unresolved 8kaggregate content or another omitted producer.
- ISSUE_MAPTILE_STATE_GEOGRAPHY [unresolved; full_pipeline]: Figure 2 calls maptile with geo(state). The actual maptile and spmap commands are not found on the checked Stata paths, and maptile documentation requires a separately installed geography template; the state template has not been checked under the approved local paths.
- REQ_ELECTIONDATA [undetermined]: Gubernatorial election dates, margins, terms and gridlock fields joined to the generated poll summary; the supplied workbook-to-Stata input mapping remains unresolved.
- REQ_8KAGGREGATE [undetermined]: The missing 8-K aggregate input read twice to produce CIK-month filing/item measures and link announcement returns; its producer, source fields and coverage are not supplied.
- REQ_ANNOUNCEMENT_RETURNS [undetermined]: CRSP U.S. Daily Event Study three-day cumulative returns around SEC Form 8-K dates, joined on CIK and repdate; exact prepared-file contract is unresolved.
- REQ_COMPANNUAL [undetermined]: Annual Compustat fundamentals used to join CIK/fyear/NAICS industry codes to the BEA panel.
- REQ_COMPQUARTERLY [undetermined]: Quarterly Compustat fundamentals used for firm-quarter ratios, identifiers and estimation-data joins; code uses yq before it generates yq from datadate.
- REQ_LM_HEADER [undetermined]: Author-named augmented 10-X header CSV, 1994-2017, whose fiscal-year/quarter/year-quarter and incorporation/business/mailing state fields are normalized into HQdata.
- REQ_BEA_IO [undetermined]: BEA domestic 2002 benchmark summary make/use data imported from bea_output_table.csv to derive NAICS-use measures and retain pctstate.
- REQ_CRSP_MONTHLY [undetermined]: Monthly CRSP market-index return series required under Data/sp500 return, joined by ym for value-weighted and S&P 500 returns.
- REQ_VIX [undetermined]: Monthly VIX series joined by ym into macro controls; the code's required month-level aggregation is not specified in the supplied workflow.
- REQ_GLOBAL_EPU [undetermined]: Monthly Global EPU current-price series joined by ym; exact source header and field mapping to the author variable are not established.
- REQ_8KCONTENT_CIK_MONTH [undetermined]: The estimation code consumes Data/8kcontent_cik_ym at CIK-month level to derive allrisk/top10risk/top20risk measures; no supplied producer or compatible packaged input is identified.
- SOFT_MAPTILE [preparation_required]: The exact Stata `which maptile` probe returned 111 on the checked ado paths. Figure 2 requires geo(state), whose separate geography template is not locally checked.
- SOFT_SPMAP [preparation_required]: The exact Stata `which spmap` probe returned 111 on the checked ado paths; the author maptile documentation says maptile requires spmap.

## Review notes

- The full_pipeline scope includes both supplied Stata entry points. No analysis_only scope is supported: estimationdata.dta is generated by the construction driver and is not included in the package inventory.
- All frozen dependency IDs D0001-D0015 are individually reviewed in dependency_review. The source-bound workflow trace also records direct reads omitted from the static checklist, including announcementreturns, electiondata, vix, epu monthly and 8kcontent_cik_ym.
- The assigned catalog was searched only through bounded exact/literal product queries. Local COMP.FUNDA, COMP.FUNDQ and CRSP.MSI SAS files were checked with the frozen bounded Python metadata reader at row_limit=1; no SAS process was launched. Catalog hits and one-row probes do not establish entitlement, full population or required time coverage.
- The local LM/SEC checks used only stat on the exact documented directories. Directory existence does not establish corpus contents, filing coverage, or a producer for the author-specific LM header CSV.
- The public-source ledger records static page excerpts only; no data, workbook, CSV, archive, API or payload URL was downloaded or opened. The BEA XLS mapping, LM header mapping, EPU schema and daily-to-monthly VIX construction remain unresolved.
- A conservative pre-saved source-secret scan redacted one candidate line in the exhibits source and several appendix lines from the reading view. Those contents were not read or disclosed. Heuristic redaction can miss other sensitive forms, so source visibility is not claimed complete; the line's program role is unknown and closure remains false.
- The source comment says the election expansion covers 24 months on both sides. The saved 48-row construction, as written, produces electiondistance -24 through +23 inclusive; preserve this actual boundary and confirm the intended end month before any source change.
- The code writes a second 8kcontent-derived state-mention output that is not consumed later in the supplied code. It is retained in the workflow trace; it is not silently dropped from the author's program.
- The author documents Stata 15.1 or newer and cautions that reghdfe updates may alter syntax or clustered standard errors. The environment has Stata 18, reghdfe 6.12.3 and ftools 2.49.1, but no estimator or code path was tested.
- The exact installed command probes found winsor and estout; maptile and spmap were not found. The WRDS event-study page's subscription condition is limited to that service route and is not evidence about current user entitlement.
- Title metadata: the frozen record retains its literal title “How Do Firms Respond to Uncertainty? Evidence from U.S. Gubernatorial Elections”; the author README and Internet Appendix use “How do Firms Respond to Political Uncertainty? Evidence from U.S. Gubernatorial Elections.” The wording differs, but the available author/DOI evidence does not conflict. Retain both spellings as discovery metadata; the title difference is not an execution-closure issue.
