# Patch proposal: jar-fe150ff72df4

Why do Individual Investors Disregard Accounting Information? The Roles of Information Awareness and Acquisition Costs?

DOI: 10.1111/1475-679X.12248

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Complete author-documented Steps 1–6, including the independent size-BTM and size-BTM-momentum return constructions, intraday TAQ volatility, all main Tables 1–6, and Figure 3 manual graphing. Substantive SAS and Stata programs are embedded in seven PDFs rather than supplied as standalone scripts.

Entry points: `1_Initial Data Collection.pdf`, `2_Additional Data Collection.pdf`, `3a_CAR - Size BTM.pdf`, `3b_CAR - Size BTM Momentum.pdf`, `4_Intraday TAQ Volatility.pdf`, `5_Variable Creation.pdf`, `6_Main Tables.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 1/12248 - Why-do-Individual-Investors-Disregard-Accounting-Information-The-Roles-of-Information-Awareness-and-Acquisitio/bdwz-datasheet-and-code.zip",
      "sha256": "bf5ed3020182d42a83035c5f2be95d0c2df45651533f640a26f9d6501f282b91"
    },
    {
      "path": "JAR-Volume 57/Issue 1/12248 - Why-do-Individual-Investors-Disregard-Accounting-Information-The-Roles-of-Information-Awareness-and-Acquisitio/bdwz-online-appendix.pdf",
      "sha256": "2f828c66ec40bccebe3dcd85698ad18878a3d674d5f82e825046e2f70e885f74"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "d900521bc7bd8c4588ed466e8bab8fe9cb026d6c7c0d694cbe366d7d064018b9"
}
```

## Proposed actions

### act_author_prepared_inputs: Obtain the current compatible author-prepared inputs and their producer/schema contracts for the AP match, trading calendar, parsed AI articles, intraday data, and TAQ event-id merge.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_ap_matched, req_trading_calendar, req_ai_article_data, req_intraday_data, req_taqid_merge, issue_ap_current_route, issue_missing_prepared_producers
Evidence: ev_step1_core, ev_step2_inputs, ev_step2_ai, ev_step2_intraday, ev_step2_calendar, ev_step4_inputs, ev_datasheet_ap_nda, ev_datasheet_withheld, ev_identifiers_inspection

Preparation / proposed procedure:

1. Request the exact current file or approved local location, producer, key fields, formats, sample coverage, and event-window history for each named prepared table.
2. For AP data, separately confirm whether the matched prepared table can be used under the applicable agreement; do not infer its current access status from historical provenance.
3. Do not substitute Identifiers.txt for any analytic input.

Validation to perform later:

- Compare delivered schemas and keys to every supplied read/join, including GVKEY/FYEARQTR, PERMNO/date, and the required offset-date columns.
- Verify the required sample and lookback/future windows from source documentation before any separately authorized run.

### act_verify_local_catalog_routes: Resolve the custom stocknames and mycstlink aliases against their readable local candidate products.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_wrds_mycstlink, req_stocknames
Evidence: ev_local_catalog, ev_step1_link_inputs, ev_crsp_link_probe, ev_crsp_stocknames_probe, ev_step4_mast_handoff

Preparation / proposed procedure:

1. Confirm whether wrds.mycstlink is the CCM link table and document the linkenddt/extlinkenddt mapping.
2. Confirm whether wrds.stocknames_new and crspq.stocknames are the catalogued CRSP Stocknames product or author-specific versions.
3. Configure the confirmed librefs with the documented host working directory and relative or [redacted-path-1a992106d3ff] paths; preserve separate library assignments.

Validation to perform later:

- Check the custom alias fields and link validity against the author reads before upgrading either route from unverified.
- Treat coverage confirmation for verified core local products as a future execution validation, not a prerequisite for recognizing the matching local route.

### act_acquire_vendor_inputs: Identify the current permitted and compatible source route or exact author-prepared data for the unverified vendor products and matched tables.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_ibes_iclink, req_zacks_company, req_zacks_eps_surp, req_zacks_preann, req_ibes_guidance, req_wsh_history, req_raven_matched, req_whalewisdom, req_taq_trade_history, req_taq_ctm, req_taq_master
Evidence: ev_step1_zacks_company, ev_step1_zacks_eps, ev_step1_iclink, ev_step1_ibes, ev_step1_wsh, ev_step1_raven, ev_step1_whale, ev_step1_taq, ev_step2_vendor_inputs, ev_step2_iclink, ev_step4_taq, ev_step4_mast_handoff, ev_local_catalog, ev_raven_raw_probe

Preparation / proposed procedure:

1. Confirm product names, fields, years, file formats, and current entitlements for Zacks, I/B/E/S guidance/ICLINK, WSH, TAQ, and WhaleWisdom.
2. Request the author-matched RavenPack earnings table or its documented producer and sample coverage; the local RP_EQUITIES_2012 raw table is not that matched table.
3. Keep vendor tables that are jointly required as separate inputs; do not treat different products as alternatives.
4. Do not infer that a datasheet statement of public availability proves free access to a paid vendor.

Validation to perform later:

- Compare each obtained product to the literal code schema, units, keys, window and sample filters before classifying a route as compatible.
- For RavenPack, verify the 2012–2015 event coverage plus GVKEY/FYEARQTR/edition matching; raw story identifiers alone do not close the handoff.

### act_resolve_language_handoffs: Specify a coherent SAS-to-Stata handoff and working-directory contract for each produced table, preserving every independent branch and its schema.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_step1_handoff, req_step2_handoff, req_sizebtm_handoff, req_sizebtmmom_handoff, req_rv_handoff, req_regression_data_handoff, issue_cross_language_handoffs, issue_runtime_paths, issue_taq_master_handoff
Evidence: ev_step1_export, ev_step2_inputs, ev_step2_output, ev_step3a_output, ev_step3b_output, ev_step5_handoffs, ev_step4_output, ev_step5_output, ev_step6_analysis

Preparation / proposed procedure:

1. Document how Step1_final.csv becomes master.Step1_final and which library owns each table.
2. Document the conversion and exact keys/columns for Step2_Final, sizebtm, sizebtmmom, and home.RVtoUse before Step 5 reads their Stata counterparts.
3. Confirm whether temp.master and taqmast.master resolve to the same physical directory/table; map the generated master output to the later consumer without assuming equal placeholders.
4. Confirm the final dataset filename, capitalization, current working directory, and whether Step 6 is intended to load the Step 5 output or a separately supplied author-prepared panel.
5. Use a relative execution root or [redacted-path-1a992106d3ff] paths for host wrappers; verify host visibility and output writability before a separately authorized run.

Validation to perform later:

- Compare each produced schema and key to the exact next-stage merge/read, including all final variables used in Tables 1–6 and Figure 3.
- Confirm Step 5 output and Step 6 input resolve to the same author dataset without assuming it is a Stata example file.

### act_extract_embedded_programs: Prepare standalone SAS and Stata scripts from the seven supplied program PDFs for any future authorized execution.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: issue_embedded_programs
Evidence: ev_overview_steps4to6, ev_source_checks

Preparation / proposed procedure:

1. Transcribe/extract each program without changing analysis content, preserving the seven exact entry points and separate Step 3a/3b branches.
2. Check PDF line wraps, comments, macros, and syntax against original rendered pages where extraction is ambiguous.

Validation to perform later:

- Review every extracted line against the source PDF and keep an extraction log; do not run a program before the unresolved data, helper, path, and software contracts are closed.

### act_resolve_external_sas_helpers: Identify the exact supplied or authorized sources for the external SAS macros and WRDS ICLINK include used by the pipeline.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_external_sas_helpers, req_ibes_iclink
Evidence: ev_step3_core, ev_step2_iclink, ev_source_checks

Preparation / proposed procedure:

1. Request the exact definitions/version/path for %ff48, %Winsorize_Truncate, and %dupl.
2. Confirm the permitted WRDS/CONNECT route and existence/version of [redacted-path-ca3c3bb28b4e].

Validation to perform later:

- Inspect macro bodies and emitted statements without changing data definitions; verify required dependencies and output columns before execution.

### act_confirm_momentum_overwrite: Resolve the Step 3b overwrite of the MOM-bearing table before attempting the momentum portfolio branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_3b_momentum_overwrite, req_sizebtmmom_handoff
Evidence: ev_step3b_momentum, ev_step3b_overwrite, ev_step3b_consumer

Preparation / proposed procedure:

1. Ask the authors to confirm the intended source for target_benchmark5 after the n<7 MOM rule and provide a corrected standalone source file.
2. Keep both size-BTM and size-BTM-momentum return products in scope; do not infer or apply the intended replacement line.

Validation to perform later:

- Before any authorized run, verify that the corrected branch retains MOM through mom_quintile assignment and still produces the documented size-BTM-momentum output schema.

### act_resolve_figure3: Resolve the Figure 3 input variables and documented manual spreadsheet graph step.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_figure3_variables, soft_excel
Evidence: ev_step6_figure3, ev_source_checks

Preparation / proposed procedure:

1. Ask whether avol_treat and avol_treat_count are present in a named unprovided input or request their author-defined producers and exact meanings.
2. Request the Excel graph recipe, required grouped output, and a compatible spreadsheet application.

Validation to perform later:

- Confirm the variables exist in the final Step 5 panel and reproduce the Figure 3 groups/means before any authorized manual graphing.

### act_prepare_software: Resolve software setup and runtime component availability for the supplied SAS/Stata workflow.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: soft_winsor2, soft_outreg2, soft_cgmreg, soft_sas_base, soft_sas_connect, soft_sas_ets, soft_sas_xlsx
Evidence: ev_environment, ev_software_cgmreg, ev_step3b_momentum, ev_step1_wsh

Preparation / proposed procedure:

1. After the separately reported Stata command checks, prepare approved sources for missing winsor2, outreg2, and cgmreg if needed; do not install them during this assessment.
2. Verify SAS startup and Base SAS, SAS/CONNECT, SAS/ETS PROC EXPAND, and XLSX import capability in the target host environment; the existing TKELS error is not evidence of an absent license.
3. Keep Stata 18/reghdfe/ftools and unique as available in checked paths.

Validation to perform later:

- Record exact runtime/component versions and command availability in the target environment without loading study data or running author code.


## Remaining issues and prerequisites

- issue_ap_current_route [unresolved; full_pipeline]: The matched AP article table required by Step 1 is absent. The datasheet confirms historical AP NDA terms and withheld matching/cleaning code, but current access to the exact prepared table is unknown; do not infer that the historical restriction alone blocks that prepared input.
- issue_missing_prepared_producers [unresolved; full_pipeline]: The supplied code reads AI_article_data, intraday_data, trading_dates_final, and taqid_merge without supplying their producers or a compatible prepared input. Identifiers.txt is only the GVKEY/DATADATE sample list and cannot replace these datasets.
- issue_cross_language_handoffs [unresolved; full_pipeline]: The supplied workflow does not document the CSV-to-SAS handoff from Step 1, SAS-to-Stata conversion for Step 2/3/4 outputs, or final dataset path/schema. Step 5 saves Regression_data_Final while Step 6 uses sysuse Regression_data_final; the latter is an author output name, not evidence of a Stata example dataset.
- issue_runtime_paths [unresolved; full_pipeline]: SAS library assignments and WSH paths use YOUR_DIR placeholders, and the programs mix local libraries with WRDS RSUBMIT paths. The executable working directory, host visibility, and writable output roots are not established. Preserve separate library meanings and use relative or [redacted-path-1a992106d3ff] paths with the documented host wrappers.
- issue_external_sas_helpers [unresolved; full_pipeline]: The Step 3 PDFs invoke %ff48, %Winsorize_Truncate, and %dupl without defining them in the seven supplied program PDFs. Step 2 also includes [redacted-path-ca3c3bb28b4e]. Exact helper versions, source locations, and remote access are unresolved.
- issue_embedded_programs [preparation; full_pipeline]: The substantive SAS/Stata programs are embedded in seven PDFs rather than standalone scripts. Extraction and line-wrap repair need checking against the original pages before any separately authorized run.
- issue_3b_momentum_overwrite [blocking; full_pipeline]: Step 3b calculates MOM and its count into target_benchmark4, applies the n<7 rule into target_benchmark5, then immediately replaces target_benchmark5 from target_benchmark3. Later portfolio matching uses a.MOM. The supplied branch therefore loses the constructed MOM before consuming it; the intended correction cannot be inferred safely.
- issue_figure3_variables [unresolved; full_pipeline]: Figure 3 collapses avol_treat and avol_treat_count, but those names have no producer anywhere in the supplied program PDFs. Whether they are present in an unprovided intermediate is unknown. The documented manual Excel graph step also lacks a graph recipe.
- issue_taq_master_handoff [unresolved; full_pipeline]: The TAQ master macro writes temp.master, while the later TAQ-to-PERMNO section reads taqmast.master. Both librefs use YOUR_DIR placeholders, and the release does not establish whether the paths are the same or how the generated table reaches the consumer.
- req_ap_matched [undetermined]: Step 1 reads the author-matched Associated Press earnings-article table oldwork.EA_ticker3_hand. At minimum the code selects GVKEY, DATADATE, RDQ, FYEARQTR, PERMNO, sumAP, an_article, AI_cov, AP_cov, post, and pre for the 2012–2015 announcement sample. The prepared table is not packaged. The datasheet's AP NDA and withheld matching/cleaning code describe historical provenance; they do not establish the current route or sharing status of this exact prepared input.
- req_trading_calendar [undetermined]: A trading-date calendar is read as sas.trading_dates_final, master.trading_dates_final, and char.trading_dates_final across Steps 1–3. Required keys include orig_date and trading_date, with event offsets such as plus1/plus2/plus40/plus60/plus75 and min1/min5/min11/min41. No producer is supplied. It must cover the event sample and all explicitly constructed pre-event and future windows.
- req_wrds_mycstlink [undetermined]: Step 1 reads the author/WRDS alias wrds.mycstlink and expects lpermno, lpermco, gvkey, linkdt, and extlinkenddt. No producer or alias definition is supplied. The catalogued CCM link table lacks the literal extlinkenddt name, so it is only a candidate pending a documented mapping and matching history.
- req_stocknames [undetermined]: Step 1 reads wrds.stocknames_new and Step 4 reads crspq.stocknames to map permno, ticker, CUSIP, and effective name dates. The package does not define these aliases. A local CRSP Stocknames file is a candidate, but the newer/custom version and coverage are unverified.
- req_ibes_iclink [undetermined]: Step 1 reads wrds.iclink and Step 2 includes the WRDS ICLINK sample SAS program to create/download ticker-to-PERMNO links with SCORE. The external include path and current WRDS route are not packaged or verified.
- req_zacks_company [undetermined]: Step 1 uses Zacks company_info to map CUSIP to ZID before joining Zacks quarterly earnings data. Required inputs include CUSIP, ZID, and the current/inactive identifier fields; no compatible file or current access route is established.
- req_zacks_eps_surp [undetermined]: Step 1 separately joins Zacks eps_surp on ZID and report month/year for actual EPS, consensus EPS, analyst count, and report date. This is a jointly required product with company_info, not an alternative to it.
- req_zacks_preann [undetermined]: Step 2 reads raw.zacks_preann_raw and constructs earnings guidance indicators in the −1 to +2 calendar-day window around the report date. Required fields include ZID, ticker, measure/period type, reference period, announcement date, guidance values and consensus fields. Current product route and coverage are unknown.
- req_ibes_guidance [undetermined]: Step 2 reads author/WRDS-prepared raw.ibes_guide and constructs matching guidance indicators around the report date. The code expects ticker, measure/period classification, reference period, announcement date, guidance values and consensus fields. Catalogued I/B/E/S DET_GUIDANCE and DET_GUIDANCE_EXT files are discovery candidates, not verified substitutes for this prepared schema.
- req_wsh_history [undetermined]: Step 1 imports WSH_EA_History_2006_2016.xlsx from sheets 2012, 2013, 2014-2, 2015, and 2016 to match earnings-announcement dates. The workbook is not in the package and no current route, entitlement, or schema has been verified.
- req_raven_matched [undetermined]: Step 1 reads raven.matched_earns for Dow full/flash article matches and joins by GVKEY/FYEARQTR; expected fields include GVKEY, FYEARQTR, EDITION, NEWS_TYPE, and RP_STORY_ID. A local RP_EQUITIES_2012 raw file is not this author-matched product and lacks the author join fields; no producer is supplied.
- req_whalewisdom [undetermined]: Step 1 reads ww.matched_IO_2001_to_2016 and matches institutional ownership by PERMNO and end-of-quarter date, using observations from RDQ−100 days through RDQ. No compatible local file or current vendor route is established.
- req_taq_trade_history [undetermined]: Step 1 directly reads taq.trades_2003to2017 to obtain retail, buy, and sell volume measures by PERMNO/date for event-window variables. This is separate from the TAQ millisecond CTM product used in Step 4. No compatible local source or period coverage is verified.
- req_taq_ctm [undetermined]: Step 4 reads TAQ CTM trade files for 2011–2015, retaining symbol root/suffix, price, correction code, time, and date. It filters 9:30–16:01, correction 00, and positive prices to calculate 5-minute intraday realized volatility. No exact local route is listed in the frozen catalog.
- req_taq_master [undetermined]: Step 4's macro reads daily TAQ master files mastm_YYYYMMDD for 2011–2015 to map symbol and CUSIP/date. It writes temp.master but a later block reads taqmast.master; the required source tables and physical handoff are unresolved.
- req_ai_article_data [undetermined]: Step 2 reads master.AI_article_data and merges cons_earn_amt by GVKEY/FYEARQTR. This parsed article file has no producer in the supplied PDFs and is not packaged; expected date coverage follows the Step 1 event sample.
- req_intraday_data [undetermined]: Step 2 reads master.intraday_data as prepared intraday activity data and merges all columns by GVKEY/FYEARQTR. No producer, column dictionary, or compatible input route is supplied.
- req_taqid_merge [undetermined]: Step 4 reads home.taqid_merge, with at least PERMNO, CUSIP, FYEARQTR, trading_date, trading_date_plus2, trading_date_min41, and trading_date_min11; it joins TAQ volatility over [0,+2] and [−41,−11]. No producer is supplied.
- req_step1_handoff [undetermined]: Step 1 exports Step1_final.csv, while Step 2 reads master.Step1_final as a SAS dataset. The release does not document or supply the CSV-to-SAS import, path, or library assignment.
- req_step2_handoff [undetermined]: Step 2 produces master.Step2_Final for Step 3 and a Stata Step2_final input for Step 5. The overview says SAS outputs are converted to Stata, but no transfer/import commands or file paths are supplied.
- req_sizebtm_handoff [undetermined]: Step 3a generates master.sizebtm; Step 5 merges a Stata file named sizebtm. No explicit SAS-to-Stata conversion, output path, or schema validation is supplied.
- req_sizebtmmom_handoff [undetermined]: Step 3b independently generates master.sizebtmmom; Step 5 merges a Stata file named sizebtmmom. No explicit SAS-to-Stata conversion, output path, or schema validation is supplied.
- req_rv_handoff [undetermined]: Step 4 produces home.RVtoUse; Step 5 consumes Stata rvtouse_main. The SAS-to-Stata name, file, path, and field mapping are not supplied.
- req_regression_data_handoff [undetermined]: Step 5 saves Regression_data_Final and Step 6 reads Regression_data_final with sysuse. The final analysis file is generated by Step 5 and is not packaged as an analysis-only input; exact path, capitalization, and sysuse resolution are unspecified.
- soft_winsor2 [preparation_required]: The exact command is used in Steps 5–6 but was not found in the checked default or shared ado paths. This is a setup gap, not evidence of a license or global availability barrier.
- soft_outreg2 [preparation_required]: The exact output command is used throughout Steps 6 and was not found in the checked default or shared ado paths.
- soft_cgmreg [preparation_required]: The exact multiway-cluster regression command used for Table 6 was not found in the checked Stata 18 adopath.
- soft_sas_base [unverified]: SAS startup failed at TKELS initialization, so Base SAS availability is unverified. The code uses PROC SQL, SORT, RANK, MEANS, FREQ, APPEND, IMPORT, EXPORT, and data-step I/O; the failure does not establish an absent license.
- soft_sas_connect [unverified]: Steps 2–4 use RSUBMIT and PROC UPLOAD/DOWNLOAD; this SAS/CONNECT capability could not be verified because SAS did not initialize.
- soft_sas_ets [unverified]: Both portfolio programs use PROC EXPAND; SAS/ETS component availability could not be checked after the runtime startup failure.
- soft_sas_xlsx [unverified]: Step 1 imports five WSH workbook sheets with DBMS=XLSX; the SAS XLSX engine capability is unverified.
- soft_excel [unverified]: Figure 3 instructions move collapsed values to Excel for manual graphs. The required spreadsheet application and graph recipe are not verified.

## Review notes

- The scope includes all seven PDFs containing substantive SAS/Stata program text, the complete supplied Steps 1–6, both required Step 3 companions, and the Figure 3 manual stage. The online appendix describes other supplementary materials, but separate supplementary programs are not supplied and were not added as analyses.
- No analysis_only scope is supported: Regression_data_Final is generated by Step 5 and is not supplied as an independent prepared analysis dataset. Identifiers.txt has a datadate/gvkey header and 29,776 sample rows, not executable code or a full analysis panel.
- There are zero frozen parser dependency IDs. The program PDFs were inspected directly, including source reads, producers, macro calls, and cross-language handoffs.
- The datasheet calls non-AP data publicly available, but that wording does not establish a free route or current entitlement for WRDS and other vendor products. AP historical NDA provenance is kept distinct from current access to the exact matched prepared input.
- Successful one-row reads establish local readability and field names only. They do not establish full history, sample coverage, vendor entitlement, or that custom author aliases map to the catalogued product.
- The RavenPack RP_EQUITIES_2012 local file is raw and single-year by product name; it lacks the author-matched GVKEY/FYEARQTR/EDITION schema. It is not a substitute for raven.matched_earns.
- The MOM overwrite was checked against original page 10 of the PDF. The issue is recorded without guessing which line the authors intended.
- Figure 3 consumes avol_treat and avol_treat_count without a producer in the seven supplied program PDFs; an unprovided upstream file may still exist.
- Stata 18 and its checked commands are reported separately from SAS. SAS startup failed at TKELS, leaving SAS and its components unverified rather than unavailable; no SAS retry, author program, regression, install, download, or contact was performed.
- Future host-wrapper paths should use a coherent relative execution root or [redacted-path-1a992106d3ff] paths, preserve distinct library directories, and confirm host visibility/writability before any separately authorized run.
