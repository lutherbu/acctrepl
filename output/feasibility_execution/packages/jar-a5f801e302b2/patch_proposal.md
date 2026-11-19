# Patch proposal: jar-a5f801e302b2

Syndicated Lending Relationships, Information Asymmetry, and Market Making in the Secondary Loan Market

DOI: 10.1111/1475-679X.70000

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete documented multi-language workflow, in datasheet order: A1 DealScan deduplication; A2 Stata preparation (lines 1–174 of A2_Stata_2025.do); WRDS SUECARS; A2 SAS; A2 Stata analysis (lines 175 through end of the same do-file). Includes supported inter-language handoffs and unresolved masked producer/input contracts.

Entry points: `A1_DS_LA_DEDUP.sas`, `A2_Stata_2025.do`, `esurprises (WRDS).sas`, `A2_SAS_2025.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 5/70000 - Syndicated-Lending-Relationships-Information-Asymmetry-and-Market-Making-in-the-Secondary-Loan-Market/phillips-datasheet-code-identifier-and-log-files.zip",
      "sha256": "78524f6be71e0ecc45e97ae1162124c14a2556732e586c283bf06c4a12c08aa1"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "1482beb10bd8e35825709b711753f53ce5b6b00d8ab5dea9055a1a26823aadf3"
}
```

## Proposed actions

### ACT_DS_NEW: Secure the author-compatible new-vintage DealScan input for A1 through the existing authorized source route, then stage it under a user-controlled data root.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_DS_NEW
Evidence: E_DATASHEET_ORDER, E_A1_DEDUP, E_WORK_ITEM

Preparation / proposed procedure:

1. Confirm the exact release and complete source fields expected by A1, including LIN/tranche keys and lead-arranger variables.
2. Use the documented or already authorized source route; no access barrier is evidenced by this assessment.
3. Keep the data root configurable and preserve the author input rather than replacing it with the local older-vintage DealScan candidate.

Validation to perform later:

- Use an approved bounded metadata probe to confirm required identifiers, fields, and file format.
- Confirm the source's documented study-period coverage and transformation lineage; do not infer full coverage from a sample row.

### ACT_QUOTES: Obtain and stage the monthly Historical Loan Price File inputs used by the early Stata quote preparation.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_QUOTES
Evidence: E_DATASHEET_QUOTES, E_STATA_QUOTE_DATE, E_STATA_QUOTES

Preparation / proposed procedure:

1. Obtain the documented monthly CSV files through the user's existing authorized LPC/Refinitiv route.
2. Retain source files and configure the early Stata input/output directories without changing quote definitions or deduplication keys.

Validation to perform later:

- Confirm the prescribed reader can consume the files and that LIN, quote date, broker identifiers, and spread fields map to the source code.
- Check the code's YMD date conversion and LIN/date deduplication on staged inputs without changing quote logic.

### ACT_TRADE_HISTORY: Stage the documented annual CLO workbooks and preserve the source-proven Excel normalization, append and later CLO consumer.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_CLO_TRADES
Evidence: E_DATASHEET_TRADES, E_STATA_XLSX, E_STATA_TRADE_APPEND, E_STATIC_AUDIT, E_READER_METHOD, E_STATA_TRADE_USE, E_STATA_TRADE_FIELDS, E_STATA_TRADE_AMOUNT, E_STATA_TRADE_PRICE_TYPE

Preparation / proposed procedure:

1. Stage annual LPC_Collateral_TradeHistory Excel inputs through the documented route.
2. Preserve first-row headers, lowercase conversion, all annual files and the combined tradehistory_all handoff.
3. Keep the visible CLO trade calculations and source fields intact.

Validation to perform later:

- Confirm imported LIN/date/settlement/amount/price/type headers and append compatibility across annual workbooks.
- Check relevant period coverage as preparation; the later source consumer is already evidenced.

### ACT_LPC_MAP: Stage an LPC tranche-to-DealScan facility crosswalk compatible with A2 join keys; catalog candidate WRDS LoanConnector IDs remains unprobed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_LPC_IDMAP
Evidence: E_A2_LPC, E_WORK_ITEM, E_CATALOG, E_SOURCE_COVERAGE_CHECKPOINT

Preparation / proposed procedure:

1. Use the source key pair loanconnector_tranche_id → facilityid; the catalog candidate exposes LoanConnector_Tranche_ID and WRDS_facility_id.
2. Treat case/field aliasing and staging as preparation, then validate mapping semantics and relevant rows; do not require byte-identical files.

Validation to perform later:

- Confirm the full source join-key pair and facility resolution before A2 joins; no new probe or source download is part of this correction.

### ACT_DEALSCAN_TABLES: Use five source-matched, row-probed native DealScan products for active pricing, package and covenant stages alongside verified facility, lender-share and company products; keep ds_2023 distinct.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_DS_FACILITY, REQ_DS_LENDERSHARES, REQ_DS_COMPANY, REQ_DS_2023, REQ_DS_PERFORMANCEPRICING, REQ_DS_CURRFACPRICING, REQ_DS_PACKAGE, REQ_DS_FINANCIALCOVENANT, REQ_DS_NETWORTHCOVENANT
Evidence: E_CATALOG, E_PROBE_FACILITY_FULL, E_PROBE_LENDERSHARES, E_PROBE_COMPANY, E_A2_FACILITY, E_A2_LENDERSHARES, E_A2_COMPANY, E_A2_DS2023, E_A2_PERFORMANCEPRICING, E_PROBE_PERFORMANCEPRICING, E_A2_CURRFACPRICING, E_PROBE_CURRFACPRICING, E_A2_PACKAGE, E_PROBE_PACKAGE, E_A2_FINANCIALCOVENANT, E_PROBE_FINANCIALCOVENANT, E_A2_NETWORTHCOVENANT, E_PROBE_NETWORTHCOVENANT, E_SOURCE_COVERAGE_CHECKPOINT

Preparation / proposed procedure:

1. Configure the verified native facility, lender-share, company, pricing, package and covenant products under the source library aliases; preserve all active joins and listed fields.
2. Validate facility/package period and identifier coverage against staged source records during ordinary preparation; a bounded sample does not establish full coverage, and no endpoint sweep is required.
3. Keep ds_2023 separate: its explicit GVKEY/DS_TICKER fields and b.* projection are not supplied by the facility-table candidate.
4. Retain A2 source filters and transformations; use only compatible inputs with complete consumed fields.

Validation to perform later:

- Use retained row_limit=1 probes for the eight positively supported native DealScan tables and approved catalog metadata for field/product checks.
- Check actual identifiers and period coverage before dependent joins; do not equate an unsampled endpoint or ordinary alias conversion with missing access.

### ACT_BROKER_MAPS: Prepare and validate the two supplied complementary manual broker mappings as the base-plus-extension input A2 SAS expects.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_TR_BROKER_MAP, REQ_MAP_EXTEND
Evidence: E_A2_MAP_BASE, E_A2_MAP_APPEND, E_PACKAGED_2, E_PACKAGED_3, E_DATASHEET_IDENTITY

Preparation / proposed procedure:

1. Retain both packaged maps, preserve their identifiers and rows, and append `map_extend` to the base map as the source does.
2. If new market-maker IDs must be mapped, use the documented manual Refinitiv-to-DealScan process and preserve resulting `ds_upid` values.
3. Do not treat either mapping artifact as a complete alternative to the other.

Validation to perform later:

- Confirm matching field names/types and that broker identifiers used by staged quotes resolve through the combined map.
- Document unresolved IDs rather than dropping them or inventing parent identifiers.

### ACT_COMPQ_A2: Match the quarterly Compustat fields and date filters used by A2; local catalog candidate lists the full consumed field set, while the saved bounded probe remains unverified.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_COMPQ_A2
Evidence: E_A2_COMPQ, E_PROBE_COMP_FUNDQ, E_CATALOG, E_A2_COMPQ_FIELDS, E_A2_COMPQ_CONTROLS, E_A2_COMPQ_MTB, E_SOURCE_COVERAGE_CHECKPOINT

Preparation / proposed procedure:

1. Stage a compatible quarterly source under the A2 compq.funda_2024 alias and preserve source filters and listed control fields.
2. The COMP.FUNDQ catalog candidate carries the visible source field contract; map its vintage/period as ordinary preparation without inferring absence from the unverified probe.

Validation to perform later:

- Compare source filters, GVKEY/date/quarter keys, lag construction and the full consumed field set.
- Confirm period coverage before dependent joins; do not substitute annual Compustat.

### ACT_A2_LATER_INPUTS: Match active A2 link, analyst-detail, management-forecast and event inputs to source-compatible local products using their actual fields, validity dates and measurement definitions.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_A2_COMP_CRSP_LINK, REQ_A2_IBES_CRSP_LINK, REQ_A2_IBES_DETAIL, REQ_A2_MGT_FCAST, REQ_A2_EVENT_INPUT
Evidence: E_A2_COMP_CRSP_LINK, E_A2_IBES_CRSP_LINK, E_A2_IBES_CRSP_JOIN, E_A2_IBES_DETAIL, E_A2_MGT_FCAST, E_A2_EVENTS, E_CATALOG, E_SOURCE_COVERAGE_CHECKPOINT

Preparation / proposed procedure:

1. Use source-defined aliases and field contracts; compatible catalog candidates can support ordinary alias/staging preparation when their product meaning matches.
2. Preserve the Compustat–CRSP CUSIP requirement because the CCM candidate lacks that field; do not trim the contract to fit an incomplete table.
3. For IBES detail and MGT_FCAST, verify the series/record definition and historical measure used by the analyst-count and guidance indicators; field-name overlap alone is insufficient.
4. Use the local KeyDev candidate only after the GVKEY mapping and event-period coverage match the source event set.

Validation to perform later:

- Reconcile complete source field sets, key/date validity rules, and measurement/history definition before dependent joins.
- No new download, endpoint sweep or author-program execution is part of this mapping correction; ordinary coverage validation follows after compatible data are staged.

### ACT_A2_BRANCHES: Resolve only remaining A2 producer/handoff rows whose source bytes remain withheld; admitted later pricing, covariate, link, event and SUE consumers are now source-mapped.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_A2_SAS_MASKED
Evidence: E_STATIC_AUDIT, E_WORK_ITEM, E_READER_METHOD, E_A2_PREREQS, E_STATA_SYND_LENDS_USE, E_SOURCE_COVERAGE_CHECKPOINT

Preparation / proposed procedure:

1. Keep the connected A2 SAS mask unchanged; resolve only exact still-withheld producer/path/schema rows for broker-day, lender-level, facility/fundamental, event and SUE exports.
2. For each remaining static candidate, require admitted producer/consumer proof before labeling it active or generated; preserve the source-proven synd_lends consumer while its A2 writer remains unresolved.
3. Do not reclassify source-proven pricing, covenant, Compustat/CRSP, IBES, event or SUE inputs as absent or optional.

Validation to perform later:

- Reconcile each remaining issue edge against its individual source mask and unchanged 48-ID list.
- No new source discovery, author execution or scientific edit is needed.

### ACT_STATA_BRANCHES: Resolve the producer and construction contracts for admitted Stata inputs keepusing and sample_2023_jar2; tradehistory_all has a source-proven producer and consumer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_STATA_MASKED, REQ_STATA_KEEPUSING, REQ_STATA_SAMPLE2023
Evidence: E_STATIC_AUDIT, E_WORK_ITEM, E_READER_METHOD, E_DATASHEET_TRADES, E_STATA_KEEPUSING_USE, E_STATA_KEEPUSING_KEYS, E_STATA_KEEPUSING_MARKET, E_STATA_KEEPUSING_EVENT_SUE, E_STATA_KEEPUSING_CONTROLS, E_STATA_SAMPLE2023_USE, E_STATA_TRADE_USE, E_SOURCE_COVERAGE_CHECKPOINT

Preparation / proposed procedure:

1. Preserve keepusing and its observed identifiers, dates, quote, market, event and SUE fields; identify its upstream construction without inventing a raw data product.
2. Preserve the sample_2023_jar2 merge by FacilityID; identify its producer and any forwarded fields before relying on that handoff.
3. Keep the source-proven annual Excel → tradehistory_all → CLO-consumer sequence intact.

Validation to perform later:

- Confirm producer-to-consumer keys, schema and history for keepusing and sample_2023_jar2 from source evidence before a future authorized workflow.
- Do not treat these unresolved handoffs as absent or bypass their source-defined use.

### ACT_BROK_LOAN: Verify the A2 SAS `brok_loan` producer and consumer use the same user-controlled staging root and compatible schema.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISSUE_BROK_LOAN_HANDOFF
Evidence: E_STATIC_AUDIT, E_WORK_ITEM, E_READER_METHOD

Preparation / proposed procedure:

1. Review the producer statement at line 294 through a safe view and confirm its writer target is the same object consumed at line 488.
2. Set portable SAS data-root configuration after confirming the actual source semantics; do not create a duplicate raw-input requirement.

Validation to perform later:

- Confirm the output table's key fields and format match the later consumer before the analysis run.

### ACT_WRDS_CLOSURE: Resolve the withheld WRDS SUE source body and exact authorized source products before attempting the SUECARS stage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_WRDS_CLOSURE, REQ_SUE_TICKERS, REQ_SUE_COMPQ, REQ_SUE_COMPA, REQ_SUE_SECURITY, REQ_SUE_DSF, REQ_SUE_MSF, REQ_SUE_IBES, REQ_SUE_CCM
Evidence: E_WRDS_SUE, E_WRDS_DATA, E_WRDS_DATA_FAMILIES, E_STATIC_AUDIT, E_READER_METHOD, E_A2_PREREQS, E_A2_SUECARS_USE

Preparation / proposed procedure:

1. Obtain a credential-free safe source view or authoritative dependency manifest for lines 48–339; keep credentials and connection secrets outside source files.
2. Identify exact WRDS macro includes, ticker-file role, CRSP/Compustat/IBES/CCM tables, consumed fields, data periods, and SUECARS output schema.
3. Use the authors' intended WRDS environment and data source route; do not reconstruct the hidden SUE algorithm from the paper or static edges.

Validation to perform later:

- Verify exact input libraries and fields through authorized bounded metadata, preserving unresolved coverage/history where unknown.
- Confirm the SUECARS output keys and variables match the A2 SAS consumer before proceeding.

### ACT_SAS_SETUP: Confirm a compatible SAS runtime and WRDS library/macro configuration using approved environment metadata; SAS was not invoked in this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_ENVIRONMENT, E_DATASHEET_ORDER, E_WRDS_DATA

Preparation / proposed procedure:

1. Use fixed environment metadata or administrator-provided configuration evidence to confirm the required SAS version and access to prescribed libraries/macros.
2. Keep credentials in approved external configuration; do not embed secrets in code or logs.
3. Do not start SAS as part of this feasibility assessment.

Validation to perform later:

- Record verified version and macro/library configuration from an approved metadata source without launching author code or a SAS session.

### ACT_WINSOR2_SETUP: Install/configure the missing Stata `winsor2` command from an approved configured package source in a future authorized setup step.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2
Evidence: E_ENVIRONMENT, E_STATA_WINSOR

Preparation / proposed procedure:

1. Use the site's approved Stata package source to install `winsor2`; no installation is performed in this assessment.
2. Keep existing winsorization cuts, variables, and in-place behavior unchanged.

Validation to perform later:

- Run a permitted `which winsor2` command-entrypoint check in Stata without loading study data or invoking author programs.

### ACT_STATA_ADDONS: Verify the three unverified Stata command entry points and configure them from approved package sources only if absent.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_ESTSTO, SW_UNIQUE, SW_TABSTATMAT
Evidence: E_ENVIRONMENT, E_STATA_ESTSTO_REHDFE, E_STATA_UNIQUE, E_STATA_TABSTATMAT

Preparation / proposed procedure:

1. Use small `which` checks for `eststo`, `unique`, and `tabstatmat`; do not run the study do-file or load study data.
2. If a command is absent, restore it from the approved Stata package source and preserve all calls in the author script.

Validation to perform later:

- Record command discovery/version metadata and verify the Stata adopath contains each required command before the full workflow.

### ACT_WORKFLOW_ORDER: Run the author-documented sequence after linked data, branch-closure, and software prerequisites are resolved; no author program was run during this review.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E_DATASHEET_ORDER, E_DATASHEET_ORDER_REST, E_A2_PREREQS, E_WRDS_SUE

Preparation / proposed procedure:

1. Configure portable project, input, and output roots for the user environment while keeping each producer and consumer on the same staged object.
2. Preserve the order: A1 SAS; A2 Stata preparation lines 1–174; WRDS SUECARS; A2 SAS; A2 Stata analysis from line 175 through end.
3. Retain the supplied manual Refinitiv-to-DealScan map and append its supplied extension as the A2 SAS source specifies.
4. Once masked branches and prerequisites are resolved, run the documented active branches without changing sample definitions, variables, estimators, or study outputs.

Validation to perform later:

- Before any separately authorized execution, reconcile active dependency edges with producers, consumers, fields, library aliases, and configured roots.
- After execution authorization, validate output schemas and source-defined transformations; do not infer success from prior author logs.


## Remaining issues and prerequisites

- ISSUE_WRDS_CLOSURE [unresolved; full_pipeline]: The WRDS SUE source lines 48–339 are wholly withheld by the byte-first reader as a connected remote block. Its active statements, include/macro dependencies, ticker handling, source fields, history, and SUECARS output details therefore remain unresolved; the visible header and A2 comments do establish the intended stage and broad source families.
- ISSUE_A2_SAS_MASKED [unresolved; full_pipeline]: Admitted later A2 SAS rows directly establish pricing/covenant reads and fields, quarterly Compustat controls, the separate ds_2023 join, link/IBES/event inputs and SUECARS consumption. Remaining A2-related cross-file edges are limited to producer or consumer statements that remain withheld: the A2 producer for the source-proven Stata synd_lends read at line 1152, and static candidate handoffs whose writer/consumer rows remain masked. Keep those paths, schemas and activation status unresolved; do not treat static edges as source proof.
- ISSUE_STATA_MASKED [unresolved; full_pipeline]: The admitted Stata alternative-spec code reads keepusing and exposes downstream field use; a separate relationship-stage merge reads sample_2023_jar2 by FacilityID. The upstream producers, complete forwarded schemas and historical/source definitions for those two objects remain unestablished. The annual trade-history import, combined tradehistory_all writer and later CLO consumer are source-proven and are no longer covered by this issue.
- ISSUE_BROK_LOAN_HANDOFF [unresolved; full_pipeline]: The static graph records an A2 SAS write/read pair for `brok_loan.dta` at lines 294 and 488, while the producer statement itself was withheld. Confirm the actual staging directory and schema before relying on this in-file handoff; this edge is not treated as a separate raw-data requirement.
- REQ_DS_NEW [undetermined]: New-vintage DealScan source used by A1 to deduplicate loan/tranche records and retain lead-arranger fields.
- REQ_QUOTES [undetermined]: Monthly Historical Loan Price File inputs used to construct loan quote observations and broker combinations.
- REQ_CLO_TRADES [undetermined]: Annual LPC_Collateral_TradeHistory Excel inputs imported and combined by early Stata, then consumed in later CLO analysis for quote–trade measures.
- REQ_SUE_TICKERS [undetermined]: IBES unofficial ticker text file consumed by the WRDS SUE program; the body that specifies its use is withheld.
- REQ_SUE_COMPQ [undetermined]: Compustat Quarterly source family documented in the WRDS SUE program header; exact fields and transformations are unknown because its program body is withheld.
- REQ_SUE_COMPA [undetermined]: Compustat Annual source family documented in the WRDS SUE program header; exact fields and transformations are unknown.
- REQ_SUE_SECURITY [undetermined]: Compustat security source identified by the static dependency audit for the withheld WRDS SUE body.
- REQ_SUE_DSF [undetermined]: CRSP daily stock data documented by the WRDS SUE header and identified by the static dependency audit.
- REQ_SUE_MSF [undetermined]: CRSP monthly stock data documented by the WRDS SUE program header; no matching dependency edge was resolved from the withheld body.
- REQ_SUE_IBES [undetermined]: IBES source family documented by the WRDS SUE program header; exact products, fields, and period remain unknown.
- REQ_SUE_CCM [undetermined]: CRSP/Compustat merged source family documented by the WRDS SUE program header; exact product and use remain unknown.
- REQ_LPC_IDMAP [undetermined]: A2 maps LPC tranche IDs to DealScan facility IDs through the author-named new_ds.lpc_id_map product. The catalog has a compatible WRDS LoanConnector IDs candidate; retain its unverified read/coverage state and perform case/alias preparation without treating name alone as proof.
- REQ_COMPQ_A2 [undetermined]: A2 reads compq.funda_2024, applies source filters, and uses mapped quarterly fields for loan-date fundamentals and controls.
- REQ_DS_2023 [undetermined]: A2 joins a distinct ds_2023 product to covenant/facility rows by FacilityID, passes b.* into covariants2, and later explicitly uses GVKEY and DS_TICKER. The full forwarded field set remains broader than the explicit mapping.
- REQ_A2_COMP_CRSP_LINK [undetermined]: A2 Compustat–CRSP link input attaches PERMNO/CUSIP to GVKEY observations within LINKDT/LINKENDDT validity intervals. The CCM candidate lacks CUSIP required by A2, so it is not a complete source-compatible route.
- REQ_A2_IBES_CRSP_LINK [undetermined]: A2 historical IBES–CRSP link input maps PERMNO to ticker over SDATE/EDATE intervals. The catalog candidate has the complete consumed field set and compatible link-history role; alias and relevant-period validation are preparation.
- REQ_A2_IBES_DETAIL [undetermined]: A2 IBES detail input counts analyst records by TICKER and ANNDATS around each loan-quarter. The selected detail-series/universe changes the analyst-count measurement; source does not identify whether its alias is EPSUS, EPSINT, adjusted, or another detail series.
- REQ_A2_MGT_FCAST [undetermined]: A2 management-forecast input sets a row indicator and counts records by TICKER/ANNDATS within a one-year window. The guidance candidate has the join fields, but the MGT_FCAST event definition and record/history contract remain to match.
- REQ_A2_EVENT_INPUT [undetermined]: A2 KeyDev event input filters event-type IDs 59, 32, 11, 21, 25, 137 and 80, and joins events to loans using GVKEY and announcement date.
- REQ_STATA_KEEPUSING [undetermined]: A2 Stata alternative-spec intermediate read as keepusing. Admitted consumer rows use DS_UPID, FACILITYID, DATE_OF_QUOTE2, LIN, MONTH/DAY/YEAR, AVG_OF_ASK/AVG_OF_BID, NUMBER_OF_QUOTES, IN_SYND, DISTRESS, TIME_SINCE, MATURITY, EVENT_DIFF/EVENT, ABS_SUE1/ABS_SUE3 and SUE_DIFF. Upstream producer, construction and coverage remain unestablished.
- REQ_STATA_SAMPLE2023 [undetermined]: A2 Stata relationship-stage merge input sample_2023_jar2, required at least by FACILITYID. Producer, complete forwarded fields and time/population definition are not established by admitted rows. Do not infer whether it is raw or generated.
- SW_SAS [unverified]: SAS source is required for A1, A2, and the WRDS SUE stage. The fixed environment metadata did not verify an available/versioned SAS runtime; no SAS process was started under the task restriction.
- SW_WINSOR2 [preparation_required]: The supplied Stata source calls `winsor2`; the fixed environment metadata reports it unavailable.
- SW_ESTSTO [unverified]: The supplied Stata source invokes `eststo`; the assigned environment metadata did not verify this command entry point.
- SW_UNIQUE [unverified]: The supplied Stata source calls the `unique` command; the assigned environment metadata did not verify this command entry point.
- SW_TABSTATMAT [unverified]: The supplied Stata source calls the `tabstatmat` command; the assigned environment metadata did not verify this command entry point.

## Review notes

- Method note: an owned bounded byte-first reader emitted candidate hashes/ranges before safe views; withheld bytes were skipped before UTF-8 decoding and original one-based rows were retained. Raw logs and SMCL files were never displayed.
- Catalog metadata and one-row probes establish only the evidence recorded for each candidate; they do not establish complete population, study-period coverage, or absence of an unlisted source. No author program, model, source-data download, install, or SAS invocation was performed.
- Preserved author stage order from the datasheet: A1 SAS → A2 Stata lines 1–174 → WRDS SUECARS → A2 SAS → A2 Stata line 175 to end. `map_extend` is appended to the base broker map; it is not treated as an alternative complete map.
- The supplied `jar_facilityids.dta` has an assigned one-row probe but is not a source-supported full analysis entry point; no analysis_only scope is claimed.
