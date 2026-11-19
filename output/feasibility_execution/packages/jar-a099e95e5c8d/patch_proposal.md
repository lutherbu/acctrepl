# Patch proposal: jar-a099e95e5c8d

Is Investor Attention for Sale? The Role of Advertising in Financial Markets

DOI: 10.1111/1475-679X.12257

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: SAS daily-panel preparation and table branches, followed by Stata attention, timing, robustness, liquidity, and return analyses.

Entry points: `MadsenNiessner_JAR_SASCode.txt`, `MadsenNiessner_JAR_StataCode.txt`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 3/12257 - Is-Investor-Attention-for-Sale-The-Role-of-Advertising-in-Financial-Markets/mn-datasheet-and-code.zip",
      "sha256": "6fd75a916d9b1ba102dd3929cc7a9bac3a0ccb8af3546df42b0bb9fb77d75333"
    },
    {
      "path": "JAR-Volume 57/Issue 3/12257 - Is-Investor-Attention-for-Sale-The-Role-of-Advertising-in-Financial-Markets/mn-online-appendix.pdf",
      "sha256": "b66ae5d5e189c152ce882c7003bc605d99035db2484e4d0958e8e4a18e7f925e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "dc825d6d26eb7952f8f7df337946841b0dd6e674a75e0ee0c1339e8f86adb048"
}
```

## Proposed actions

### act_mr_calendar_match: Provide the compatible Excel-derived print.dates and matched print.list5 lookup, or document the exact author recipe that creates them.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_mr_calendar, req_mr_matchlist, sw_excel
Evidence: ev_data_sources, ev_workflow, ev_sas_calendar_ads

Preparation / proposed procedure:

1. Use prepared print.dates to bypass Excel creation when available; otherwise retain Excel as the documented manual stage.
2. Confirm the date range and the print.list5 fields used by the join, including company_num and lpermno and identifiers consumed later.
3. Preserve the supplied Media-company exclusions and nonmissing lpermno restriction.

Validation to perform later:

- Check dates are unique at daily level and cover the observed ad panel.
- Check matched company_num/lpermno links are nonmissing without inventing a new crosswalk.

### act_mr_ads_circ: Confirm current entitlement or obtain the author-prepared Media Radar advertisement and circulation rows required by print.ads4.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_mr_ads, req_mr_circulation
Evidence: ev_data_sources, ev_sas_calendar_ads

Preparation / proposed procedure:

1. Confirm current delivery/rights for the historical Media Radar and AAM-derived materials; the 2013–2014 dates alone do not establish them.
2. Supply join/filter fields company_num, date, daily and lpermno, plus publication_num, est_value2, business, national, new_brand and large_ad.
3. Confirm the circulation source and sun_sat field required for weekend circ before using the supplied aggregation.

Validation to perform later:

- Check company/date coverage and field definitions against the exact SAS joins and filters.
- Check weekend circ uses sun_sat as written and aggregates at lpermno/date.

### act_rp_news: Supply matched RavenPack print.rp_news or a documented compatible preparation from local story and entity-mapping products.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_rp_news
Evidence: ev_data_sources, ev_sas_news_holidays_ids, ev_catalog, ev_rp_probe, ev_rp_mapping_probe

Preparation / proposed procedure:

1. Confirm current entitlement or provide the historical prepared matched table; the timed-out bounded probes are inconclusive.
2. If evaluating RPA.RP_EQUITIES_2014 and RPA.RP_ENTITY_MAPPING together, establish date/category/relevance fields and entity-to-lpermno mapping.
3. Preserve stock-prices/order-imbalances filters, relevance=100, story identifiers, category handling and the lpermno/date join.

Validation to perform later:

- Check field definitions and date/firm coverage against the supplied SAS where clause and joins before selecting a route.

### act_crsp_ids: Provide or verify the exact CRSP holiday and permno identifier-crosswalk tables used by SAS preparation.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_crsp_holidays, req_crsp_companies
Evidence: ev_data_sources, ev_sas_news_holidays_ids, ev_catalog

Preparation / proposed procedure:

1. Resolve the exact local catalog product or access route for crsp.holidays and crsp.companies; readable CRSP.DSF is not proof of either.
2. Preserve supplied manual permno corrections after linking permno to permco and cusip.

Validation to perform later:

- Check holiday date coverage and key uniqueness/coverage of the required permno-to-permco/cusip mapping.

### act_thomson_ownership: Provide the author-prepared Thomson f13_2007_20132 interval panel or confirm a compatible local 13F preparation route.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_thomson_ownership
Evidence: ev_data_sources, ev_sas_news_holidays_ids, ev_catalog, ev_tfn_probe

Preparation / proposed procedure:

1. Confirm current access or deliver cusip, date, lag_date and inst_inv_share.
2. If evaluating the TFN.S34 candidate, verify the exact source and recipe required for the interval panel; the timeout is inconclusive.
3. Preserve the half-open as-of interval date <= panel date < lag_date.

Validation to perform later:

- Check CUSIP format, interval boundaries, date coverage and multiple-match behavior before joining.

### act_google_svi: Supply both distinct historical Google scaled-query panels used by the code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_google_ticker_svi, req_google_name_svi
Evidence: ev_data_sources, ev_sas_google

Preparation / proposed procedure:

1. Supply daily_svi4 ticker-query rows with permco, date, svi_d_scaled, returns_box, any_flag and ticker.
2. Separately supply daily_fullnames2 full-name rows with permco, date and svi_d_scaled.
3. Confirm historical scaling and query/firm mapping; do not substitute an unrelated current search index.

Validation to perform later:

- Check the two panels separately for keys, scale, date coverage and fields used to generate lnsvi, lnsvi_name, returns_box and ticker_flag.

### act_sec_access_logs: Provide the SEC downloads_master access-count panel or its documented producer.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_sec_access_logs
Evidence: ev_data_sources, ev_sas_edgar, ev_sec_raw_probe, ev_sec_parsed_probe, ev_lm10x_probe

Preparation / proposed procedure:

1. Obtain author-compatible daily gvkey/date counts annual, all and fundamental, or the producer and schema for those counts.
2. Keep SEC filing text and filing-date products separate from downloads_master access logs.

Validation to perform later:

- Check count semantics, gvkey/date keys and author-required observation period before forming log-hit variables.

### act_sec_filing_dates: Provide the exact SEC filing-date table or verify a bounded preparation route from already documented local filing corpora.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_sec_filing_dates
Evidence: ev_sas_edgar, ev_sec_raw_probe, ev_sec_parsed_probe, ev_lm10x_probe

Preparation / proposed procedure:

1. Verify exact schema, coverage and gvkey-to-filing-identifier mapping against the existing documented directories using a bounded check; do not recursively discover files.
2. If compatible, prepare the author-required 8-K/10-K/10-Q table with gvkey and file_date; otherwise supply the prepared edgar_8k_10k_10q_filing input.
3. Preserve the source gvkey normalization and file_date join.

Validation to perform later:

- Check form/date classification, identifier crosswalk and filing-date coverage against the supplied SAS logic.

### act_qea_input: Supply the preprocessed quarterly earnings-announcement input dis.comp_full_sample or its author preparation specification.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_quarterly_ea
Evidence: ev_sas_qea_funda_macro, ev_stata_timing

Preparation / proposed procedure:

1. Provide fields used by the filter/join: year, eadate_crsp, eadate_ibes, shrcd, permno and retained earnings-surprise controls.
2. Preserve the 2006–2014 year filter, matched event dates and share codes 10/11; do not assume raw I/B/E/S files are compatible.

Validation to perform later:

- Check event-date matches and firm/date coverage including the Stata qea_10 plus/minus five-day construction.

### act_comp_funda: Verify the local COMP.FUNDA candidate against the author comp.funda_2013 source and date convention.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_annual_funda
Evidence: ev_sas_qea_funda_macro, ev_comp_funda_probe

Preparation / proposed procedure:

1. Treat the successful one-row probe as candidate readability and field evidence only; verify author-era vintage and historical/sample coverage.
2. Confirm the alias/selection producing comp.funda_2013 and retain datadate rather than substituting fyear.
3. Preserve the join interval from one year before daily date up to but not including daily date.

Validation to perform later:

- Check required columns and exact historical coverage with a bounded table validation before full preparation.

### act_return_volatility: Provide the prepared print.ret_volatility table and its producer/variable definitions.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_return_volatility
Evidence: ev_sas_return_market_inputs, ev_stata_liquidity_returns, ev_stata_return_branch

Preparation / proposed procedure:

1. Supply author-compatible permno/date rows and definitions for abret_mkt, abret_mkt_0_3 and volatility_abret_mkt.
2. Keep this SAS join distinct from FF3F_abnormal_ret.dta until field overlap and producer are confirmed.

Validation to perform later:

- Check key uniqueness, field definitions and whether SAS-generated instrument_lag retains the variables under the names Stata reads.

### act_crsp_dsf_index: Verify local CRSP.DSF or provide the author-prepared crsp.dsf_index_2013 panel and exact derivation.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_crsp_dsf_index
Evidence: ev_sas_return_market_inputs, ev_crsp_dsf_probe

Preparation / proposed procedure:

1. Treat the bounded raw CRSP.DSF read as a candidate only; confirm date/security coverage and author vintage.
2. Obtain the recipe for prc_lag, size and bm and the expected shrout/vol/prc variables, or supply the prepared table; do not invent transformations.

Validation to perform later:

- Check permno/date key compatibility, derived field definitions and date coverage before joining.

### act_taq: Provide the prepared TAQ mr_taq daily liquidity panel or its compatible licensed source and author preparation.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_taq_mr_taq
Evidence: ev_data_sources, ev_sas_return_market_inputs

Preparation / proposed procedure:

1. Confirm current access or supply daily permno/date fields with dollar_depth, effectivespread_percent_sw, quotedspread_percent and turn.
2. Document the TAQ product, unit/aggregation definitions and join fields; historical WRDS access does not establish current entitlement or prepared-table compatibility.

Validation to perform later:

- Check field units, daily aggregation, identifier mapping and date coverage against the supplied join.

### act_ff3f_input: Provide FF3F_abnormal_ret.dta and its separate producer/variable specification.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_ff3f_returns, iss_ff3f_producer
Evidence: ev_stata_handoff, ev_stata_liquidity_returns, ev_sas_return_market_inputs

Preparation / proposed procedure:

1. Locate or obtain the exact Stata merge file and producer/version keyed by permno/date.
2. Confirm which nonconflicting return series it contributes, including ret used by business_d3, and which abnormal return fields instead come from print.ret_volatility/instrument_lag.
3. Keep the SAS handoff and FF3F merge as distinct inputs until exact overlap is documented.

Validation to perform later:

- Check key uniqueness, variable collision behavior, return definitions and resulting names before analysis.

### act_sas_macros: Obtain or document compatible SAS autocall definitions and industry mapping that meet the supplied macro call and output contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss_sas_industry_macros
Evidence: ev_sas_paths, ev_sas_qea_funda_macro

Preparation / proposed procedure:

1. Locate supplied definitions or select a documented compatible provider implementing %ind_ff48 and %ind_ff12; byte-identical author originals are not required when the documented interface and category contract match.
2. Confirm accepted input table, sich variable, macro argument order, and outputs bin_var, ind_code and ind_code12 expected by later code.
3. Keep category and mapping semantics explicit; do not invent or silently substitute a crosswalk.

Validation to perform later:

- Check the selected definitions accept the exact supplied macro call forms and output the required variables.
- Check the documented industry categories align with downstream code and table labels.

### act_reghdfe_compat: Resolve the exact legacy reghdfe IV/stages behavior required by the supplied Stata program before any author regression.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: iss_reghdfe_legacy
Evidence: ev_stata_iv, ev_analysis_branches, ev_stata_return_branch, ev_environment_probe, ev_reghdfe_v5_source, ev_reghdfe_legacy_help, ev_ivreg2_probe

Preparation / proposed procedure:

1. Identify the author-era release or documented legacy invocation compatible with the parenthesized IV calls and stages(ols); command presence alone is insufficient.
2. Confirm documentation for e(cdf), e(jp) and saving the OLS stage as reghdfe_ols, as required by the source.
3. Do not replace the estimator or install a package automatically.

Validation to perform later:

- Compare every IV/stages call and stored-result reference to the selected pinned command documentation before author execution.

### act_share_branch_order: Schedule the separate ad-sharing extract after the supplied mn.day1 producer in the full workflow.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: iss_ads_share_order
Evidence: ev_sas_share_branch, ev_sas_calendar_ads

Preparation / proposed procedure:

1. For the supplied same-file run, place the mn.ads4_JAR block after the mn.day1 producer and its weekend circulation update.
2. Preserve the sharing block publication_num filter, selected fields and the main analysis/table branches.
3. A previously produced mn.day1 can remain a separate optional route only if its provenance and schema are later documented.

Validation to perform later:

- Check the share extract reads the mn.day1 created in the same workflow and retains its documented keep-list/filter.
- Check no main daily-panel or analysis branch is removed or redirected.

### act_path_configuration: Configure all SAS and Stata paths consistently for the current workspace and generated-file handoff.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: iss_path_configuration
Evidence: ev_sas_paths, ev_stata_handoff, ev_sas_export

Preparation / proposed procedure:

1. Set all SAS LIBNAME roots and SASAUTOS to available relative or [redacted-path-a86ec39c89f0] paths; do not edit only the first libref.
2. Set SAS output to Programs/instrument_lag.dta under a chosen project run root and set Stata working directory to that Programs directory.
3. Keep FF3F_abnormal_ret.dta explicit and separate until its producer/input is supplied.

Validation to perform later:

- Review all affected SAS path assignments and Stata cd/read paths together.
- After authorized preparation, confirm SAS output and Stata input resolve to the same file before starting Stata.

### act_sas_runtime: Verify SAS 9.4 TS1M8 startup/configuration independently of author code.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_sas
Evidence: ev_environment_probe

Preparation / proposed procedure:

1. Confirm batch startup after the documented autoexec/work configuration; the current TKELS initialization failure leaves runtime unverified, not missing or unlicensed.

Validation to perform later:

- Record the verified runtime version and environment-only startup result.

### act_sas_export_capability: Verify local SAS-to-Stata DTA export capability used by the supplied producer.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_sas_access_pcfiles
Evidence: ev_sas_export, ev_sas_stata_local_export, ev_sas_pcfs_mode, ev_sas_pcfiles_capability

Preparation / proposed procedure:

1. Confirm deployment metadata for SAS/ACCESS Interface to PC Files and support for the local DBMS=STATA export.
2. Preserve local mode when SAS writes the DTA file to the same host. PCFS is a separate remote server mode; do not require PC Files Server or Office without a deployment change that needs it.

Validation to perform later:

- Confirm the deployment component/version and documented local Stata export mode before the author preparation.


## Remaining issues and prerequisites

- iss_ff3f_producer [unresolved; full_pipeline]: Stata explicitly merges FF3F_abnormal_ret.dta, but no producer for that independent file is supplied. Preserve this input separately from SAS print.ret_volatility; the exact overlapping/nonconflicting return fields and producer are unknown.
- iss_sas_industry_macros [unresolved; full_pipeline]: The supplied package does not include macro definitions or document the industry-category/output semantics for %ind_ff48 and %ind_ff12. A documented compatible provider could satisfy the calls; the exact mapping/version semantics remain unresolved. Required outputs are bin_var, ind_code and ind_code12.
- iss_reghdfe_legacy [unresolved; full_pipeline]: The Stata program uses legacy reghdfe IV syntax, stages(ols), e(cdf), e(jp) and estimates restore reghdfe_ols. The installed reghdfe 6.12.3 command is present, but official pinned source documents the IV/2SLS move, and its current syntax is not a demonstrated match for these calls. Exact compatible author-era command/version, diagnostics and saved estimate naming remain unresolved; do not substitute an estimator automatically.
- iss_ads_share_order [preparation; full_pipeline]: The distinct mn.ads4_JAR sharing extract appears before the supplied same-file mn.day1 producer. This is a routine ordering preparation: schedule the extract after the producer and preserve its selected fields/filter; it does not indicate failure of the main daily-panel workflow.
- iss_path_configuration [preparation; full_pipeline]: The supplied SAS librefs/SASAUTOS and Stata working directory use machine-specific Windows paths. Configure every affected producer and consumer cohesively for the current workspace and preserve the generated DTA handoff.
- req_mr_calendar [undetermined]: Author-created daily date grid print.dates, created in Excel then imported in SAS; must cover the observed advertising panel dates.
- req_mr_matchlist [undetermined]: Matched-company lookup print.list5 used to link company_num to lpermno and carry firm identifiers such as gvkey/companyname; retains the supplied exclusions.
- req_mr_ads [undetermined]: Media Radar daily advertisement table print.ads4 joined on company_num/date with daily=1 and nonmissing lpermno; the code uses publication_num, est_value2, business, national, new_brand and large_ad among its measures.
- req_mr_circulation [undetermined]: Circulation input carried with the ad rows, including sun_sat; SAS assigns weekend circ from sun_sat and aggregates circ by lpermno/date.
- req_rp_news [undetermined]: Prepared matched RavenPack table print.rp_news joined by lpermno/date, with group, relevance, rp_story_id and category; SAS filters stock-prices/order-imbalances and relevance=100.
- req_crsp_holidays [undetermined]: CRSP holiday dates in crsp.holidays, joined to the daily panel to create holiday.
- req_crsp_companies [undetermined]: CRSP identifier crosswalk crsp.companies used to add permco and cusip from permno; preserve the supplied manual corrections to selected permnos.
- req_thomson_ownership [undetermined]: Prepared Thomson ownership interval panel thomson.f13_2007_20132 with cusip, date, lag_date and inst_inv_share, joined as date <= panel date < lag_date.
- req_google_ticker_svi [undetermined]: Google ticker-query panel go.daily_svi4 with permco/date/svi_d_scaled, returns_box, any_flag and ticker; used for lnsvi, ticker_flag, returns_box and ticker.
- req_google_name_svi [undetermined]: Separate Google full-name query panel go.daily_fullnames2 with permco/date/svi_d_scaled; used for lnsvi_name.
- req_sec_access_logs [undetermined]: SEC downloads_master access-count panel with gvkey/date and annual, all, fundamental counts; joined to construct the three log-hit controls.
- req_sec_filing_dates [undetermined]: Separate edgar_8k_10k_10q_filing input with gvkey and file_date; SAS normalizes gvkey and joins filing dates to the daily panel.
- req_quarterly_ea [undetermined]: Preprocessed dis.comp_full_sample quarterly earnings-announcement panel. Code filters year 2006–2014, matches eadate_crsp to eadate_ibes, keeps shrcd 10/11, then joins permno/eadate_crsp to the daily panel to form qea_dummy.
- req_annual_funda [undetermined]: Annual comp.funda_2013 fundamentals joined by gvkey for datadate in [one year before daily date, daily date); used for prcc_f, csho, ib, at, lt, ceq, revt, ni, xad and sich.
- req_return_volatility [undetermined]: Prepared print.ret_volatility table with permno/date and return-volatility fields consumed by Stata: abret_mkt, abret_mkt_0_3 and volatility_abret_mkt.
- req_crsp_dsf_index [undetermined]: Prepared CRSP crsp.dsf_index_2013 daily panel with permno/date, shrout, vol, prc, prc_lag, size and bm.
- req_taq_mr_taq [undetermined]: Prepared taq.mr_taq daily panel joined by permno/date, with dollar_depth, effectivespread_percent_sw, quotedspread_percent and turn.
- req_ff3f_returns [undetermined]: Separate Stata merge input FF3F_abnormal_ret.dta, keyed by permno/date. Later code reads ret for business_d3 construction; confirm the file’s exact overlapping and nonconflicting return fields with the SAS-generated instrument_lag before use.
- sw_sas [unverified]: Machine inventory identifies SAS 9.4 TS1M8, but the frozen probe did not verify startup after a TKELS initialization failure. Supplied code actively uses DATA steps, PROC SQL, PROC SORT, PROC UNIVARIATE, PROC MEANS and PROC EXPORT DBMS=STATA. PROC UNIVARIATE is Base SAS. The required local Stata export capability is tracked separately as unverified SAS/ACCESS Interface to PC Files; the supplied local DBMS=STATA mode does not establish a PC Files Server or Office requirement.
- sw_sas_access_pcfiles [unverified]: The supplied PROC EXPORT DBMS=STATA step requires Stata DTA export capability. SAS 9.4 documentation identifies PC Files formats and limits unlicensed local Import/Export to JMP and delimited formats. Current component availability/license is unverified. PCFS is a separate remote server mode and is not used by the supplied local export.
- sw_excel [unverified]: The supplied workflow says print.dates was created in Excel and imported to SAS. No Excel runtime check was performed; the stage can be bypassed only if a compatible prepared print.dates is supplied.

## Review notes

- Resource and software checks are now recorded in the evidence, requirements and software sections. Read-only checks include successful bounded COMP.FUNDA and CRSP.DSF reads, directory-existence-only SEC/LM checks, and timed-out proprietary probes retained as unverified; no author code was run.
- The archive contains substantive 498-line SAS and 860-line Stata programs. The static parser reported no code IDs, but actual source contents establish code and both are full-pipeline entry points.
- The supplied permnos.txt is a 637-firm identifier list, not an analysis dataset. The package does not include the prepared analysis tables or panel datasets.
- Historical 2013–2014 acquisition/access statements do not establish current licenses, delivery, or prepared-data compatibility. All unresolved route outcomes remain undetermined; bounded probe timeouts are not evidence of absent products or entitlements.
- The SAS-to-Stata generated handoff is coherent after configuration: SAS creates Programs/instrument_lag.dta and Stata reads instrument_lag from its Programs working directory. Keep this producer/consumer order when configuring paths. FF3F_abnormal_ret.dta is a separate Stata merge input with no supplied producer, and should not be conflated with SAS print.ret_volatility.
- Stata input history follows supplied operations: lag 28 is used in robustness instruments, attention/news operations include leads through day +3, qea_10 uses the ±5-day event window, and business_d3 checks up to three prior returns. Validate source coverage against those operations; do not infer exact start dates from the source filters.
- The SAS mn.ads4_JAR sharing extract appears before the later same-file mn.day1 producer. Schedule the distinct extract after the producer and weekend update, preserving its filter and keep-list; this is routine order preparation, not a main-panel failure.
- The frozen local corpus probes for SEC and LM10-X established directory existence only. They do not establish SEC downloads_master access logs, the filing-date table, coverage or security crosswalks.
- Appendix-only descriptions contextualize results but do not add unsupplied appendix analysis code as target scope. All supplied SAS table branches and Stata first-stage, IV, robustness, timing, liquidity and return branches remain in full_pipeline.
- SAS capability inventory includes DATA steps, SQL, SORT, UNIVARIATE, MEANS and PROC EXPORT DBMS=STATA. SAS/ACCESS Interface to PC Files for Stata DTA export is unverified. Official SAS documentation distinguishes the supplied local DBMS=STATA mode from remote DBMS=PCFS; no Office or PC Files Server requirement is inferred for this workflow.
