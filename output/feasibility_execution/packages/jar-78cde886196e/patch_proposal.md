# Patch proposal: jar-78cde886196e

Non-answers During Conference Calls

DOI: 10.1111/1475-679X.12371

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | undetermined | undetermined |

### full_pipeline

Author's full raw-data preparation workflow: all 15 supplied PostgreSQL-backed R programs through call-level and question-answer-level estimation tables, preserving the documented stage order and full controls branch.

Entry points: `glz_create_data/create_se_link.R`, `glz_create_data/create_nonans_rate.R`, `glz_create_data/create_nonans_ner.R`, `glz_create_data/create_comp_rate.R`, `glz_create_data/create_fundann.R`, `glz_create_data/create_fundqtr.R`, `glz_create_data/create_ibes_mb.R`, `glz_create_data/create_crsp_calls.R`, `glz_create_data/create_crsp_fye.R`, `glz_create_data/create_ciq_offerings.R`, `glz_create_data/create_rscript.R`, `glz_create_data/create_sp1500.R`, `glz_create_data/create_calls_merged.R`, `glz_create_data/create_calls_set.R`, `glz_create_data/create_ner_set.R`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Author's supplied prepared-data replication of the main call-level and question-answer-level results, with Equilar controls omitted and identifiers/dates anonymized as documented.

Entry points: `glz_knit_tables/README.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 4/12371 - Non-answers-During-Conference-Calls/glzdatasheetcodeandidentifiers.zip",
      "sha256": "1c4415f423a8ecaf673a99ce5a343001ae8068b8472c1f9e71eca29b2331ef05"
    },
    {
      "path": "JAR-Volume 59/Issue 4/12371 - Non-answers-During-Conference-Calls/glz-online-appendix.pdf",
      "sha256": "1a0eef103b96335c0a1fc36a6b21b9d2084acd7aa838ce8a9dda030359aaafce"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "cac2f8a6a94ae523e08ba4c7929fcdd429f5269decfe72be3f7da7b6a45fcdbc"
}
```

## Proposed actions

### act_upstream_closure: Before the full raw-data branch can be attempted, configure the PostgreSQL connection and compatible source-table loading handoffs, resolve the outside-scope feature producers and missing hpr_link handoff, and confirm only unresolved data contracts without changing the authored transformations.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_src_comp_fundq, req_src_company_fyear, req_src_se_call_link, req_src_se_calls, req_src_se_qa_pairs, req_src_processed_files, req_src_non_answers, req_src_regexes, req_src_word_counts, req_src_script_measure, req_src_speaker_data, req_src_comp_intensity, req_src_ner_class7, req_src_ner_exclude, req_src_topic_brvb, req_src_topic_mpr, req_src_fog_measure, req_src_tone_measure, req_src_ff_industry49, req_src_co_hgic, req_src_comp_funda, req_src_sec_history, req_src_ibes_id, req_src_ibes_actual, req_src_ibes_analyst, req_src_crsp_mse, req_src_crsp_dsf, req_src_ciq_keydev, req_src_idx_index, req_src_idxcst_his, req_src_executives, req_src_equity_calc, req_src_hp_hhi, req_src_hp_tnic3, req_src_hp_fluidity, req_src_trade_comtrade, req_src_hpr_link, issue_upstream_inputs, issue_hpr_link
Evidence: ev_upstream_omissions, ev_hpr_link_read, ev_workflow_trace, ev_common_source_catalog, ev_common_source_candidates, ev_common_source_capture

Preparation / proposed procedure:

1. Configure the PostgreSQL connection, project role/schema access, and nonans_product search_path. For every source relation in probes/workflow_trace.json, use the fields, join keys, filters, and transformations exposed by the supplied SQL/R code as the starting contract; confirm only remaining physical types, units, compatible feature vintage, population, and date/history coverage.
2. Consider the cataloged local SAS raw-product candidates for source preparation: COMP.FUNDA, COMP.FUNDQ, COMP.CO_HGIC, COMP.SEC_HISTORY, CRSP.DSF, COMP.IDXCST_HIS, CIQ.WRDS_KEYDEV, IBES.ACTU_EPSUS, and IBES.DETU_EPSUS. The exact mapped Compustat, CRSP.DSF, and CIQ fields plus cataloged SAS type/length/format metadata are recorded in the linked lookup; establish a deliberate PostgreSQL field/type/label conversion and vintage/history crosswalk before using any candidate. These are inventory candidates only, with no live file read, DB load, period proof, access check, or license-denial finding.
3. Keep specific unmatched contracts open: the lookup did not identify an exact CRSP.MSE, IBES.ID, COMP.IDX_INDEX, or Fama-French industry_49 table; COMP.IDXCST_HIS lacks the source-required fromdt name; IBES actuals/detail files are raw candidates whose variable/format mapping to the author's prepared relations remains unknown. FF.FACTORS_DAILY and FF.FACTORS_MONTHLY are factor files, not the required 49-industry SIC bounds. Execucomp aggregate tables are cataloged but are not established substitutes for the Equilar company_fyear, executives, and equity_calc inputs. No matching Comtrade, HPR, StreetEvents, non-answer, or language/NER feature product was identified in this bounded catalog search.
4. Identify author-compatible producers and inputs for the outside-scope StreetEvents parsing, non-answer, linguistic-feature, and Stanford NER tables. Resolve the separate hpr_link handoff: confirm its required fields, join coverage, provenance, and compatible mapping for create_crsp_calls.R and create_sp1500.R without assigning it an unsupported producer.
5. Follow the supplied stage order in probes/workflow_trace.json: create_se_link produces se_link; create_nonans_rate, create_nonans_ner, and create_comp_rate consume se_link and produce their feature relations; create_fundann, create_fundqtr, create_ibes_mb, create_crsp_calls, create_crsp_fye, create_ciq_offerings, create_rscript, and create_sp1500 produce the named intermediate relations; create_calls_merged consumes those outputs plus the named external relations and produces calls_merged; create_calls_set produces calls_set; create_ner_set consumes se_link, nonans_ner, and calls_set and produces ner_set. Retain create_crsp_fye as a supplied output-producing stage even though no supplied source reads its result.
6. Preserve all authored PostgreSQL transformations, fiscal/date filters, sample definitions, winsorization, fixed effects, and model handoffs after the remaining input contracts are resolved.

Validation to perform later:

- For each selected cataloged SAS candidate, verify a field-by-field name/type/format/label conversion into the expected PostgreSQL source relation and check compatible population, source vintage, and required date history before using it.
- Statically reconcile every relation read and written by all 15 programs against the ordered producer-consumer map before any later authorized run.
- For the hhi/fluid joined input, verify which source or compatible mapping supplies post-join tnic3tsimm before treating the required field contract as resolved.

### act_analysis_preparation: Prepare a reflowed working-copy R driver from the embedded main-results snippets and establish the two supplied RData inputs' schema and compatibility through an authorized non-destructive validation route.

Scopes: analysis_only. Type: clarification. Certainty: conditional.
Addresses: req_analysis_calls, req_analysis_ner, issue_embedded_analysis, issue_analysis_schema
Evidence: ev_analysis_scope, ev_analysis_inputs, ev_analysis_loads, ev_analysis_methods

Preparation / proposed procedure:

1. Extract and reflow the PDF's analysis code in its documented call-level then question-answer-level order in a working copy; retain get_labels, reg_year_fe, reg, the call/year identifiers, and the two-stage import specification.
2. Set path to the supplied share root with a trailing separator so both documented RData paths resolve.
3. Keep this route scoped to the authors' no-Equilar-controls, CIK/random-file-name, date-suppressed replication; do not treat it as equivalence to the full-control original analysis.

Validation to perform later:

- In a later authorized run, confirm the loaded object names and the columns used by each code section before producing tables; preserve the reported model definitions and clustered covariance correction.

### act_full_software_setup: Prepare a compatible R database client/package environment and PostgreSQL service configuration for the full preparation branch.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_postgres_service, sw_rpostgresql, sw_dbi, sw_rpostgres, sw_dplyr, sw_tidyr, sw_psych
Evidence: ev_native_r_packages, ev_native_db_packages, ev_native_rpostgres, ev_native_psych, ev_r_packages, ev_workflow_trace

Preparation / proposed procedure:

1. In a project library, prepare the exact R packages used by the native programs: RPostgreSQL, DBI, RPostgres, dplyr, tidyr, and psych; preserve the authors' R implementation and verify package/runtime compatibility before any later authorized run.
2. Configure the selected PostgreSQL service, database connection, role grants, and nonans_product schema/search path through the site's supported configuration; the probe did not establish a reachable author database or grant access.

Validation to perform later:

- Confirm package availability and versions using package metadata and confirm the configured PostgreSQL connection/schema access without running the author programs or model code.

### act_analysis_software_setup: Prepare the R packages explicitly used by the embedded analysis snippets in the selected environment.

Scopes: analysis_only. Type: software_setup. Certainty: conditional.
Addresses: sw_dplyr, sw_sandwich, sw_lmtest, sw_stargazer, sw_tidyverse
Evidence: ev_analysis_sandwich_lmtest, ev_analysis_stargazer, ev_r_packages

Preparation / proposed procedure:

1. In an appropriate project library, prepare the analysis dependencies dplyr, sandwich, lmtest, stargazer, and tidyverse; the metadata probe found them absent from the selected R runtime's default library paths.

Validation to perform later:

- Confirm package availability and versions for the reflowed analysis driver before a later authorized table run, preserving the documented regression and covariance methods.


## Remaining issues and prerequisites

- issue_upstream_inputs [unresolved; full_pipeline]: The 15 supplied R programs expose named PostgreSQL relations, many consumed fields and join keys, sample filters, and authored transformations. This package does not provide the PostgreSQL connection/database settings or loading handoffs for those external relations, and the compatible table contents, field types/units, and required history are not verified. The README explicitly places StreetEvents transcript parsing and non-answer, linguistic-feature, and NER feature creation outside this shared code note, leaving those required upstream producers and their compatible inputs unresolved.
- issue_hpr_link [unresolved; full_pipeline]: Both create_crsp_calls.R and create_sp1500.R consume the project relation hpr_link, but none of the supplied programs creates it. Its exact schema, construction recipe, and compatible local route remain unresolved.
- issue_embedded_analysis [preparation; analysis_only]: The complete main-results analysis is embedded as R snippets in a PDF note rather than a standalone driver. Extract and reflow the snippets in order in a working copy, preserving the authored helper functions, model definitions, and handoffs before attempting execution.
- issue_analysis_schema [unresolved; analysis_only]: The two packaged .RData files are identified by the author as prepared call-level and question-answer-level estimation inputs and are loaded by the embedded analysis, but their object names, columns, identifiers, period, and compatibility could not be established through safe bounded non-evaluating metadata. Do not deserialize them for this static assessment; retain the analysis-input contract as unresolved.
- req_analysis_calls [undetermined]: Author-prepared call-level dataset used by the embedded main-results code to reproduce call-level analyses. This is a distinct sanitized/no-controls target, not evidence of full original controls or date/identifier equivalence.
- req_analysis_ner [undetermined]: Author-prepared question-answer-level dataset used by the embedded main-results code to reproduce Q&A analyses; its direct file contract remains unverified.
- req_src_comp_fundq [undetermined]: Quarterly Compustat relation used in se_link and quarterly fundamental construction.
- req_src_company_fyear [undetermined]: Company/fiscal-year relation used for call linkage and fiscal-year-end CRSP variables.
- req_src_se_call_link [undetermined]: Security/company link relation joining StreetEvents transcript identifiers to companies and CRSP securities.
- req_src_se_calls [undetermined]: StreetEvents calls relation supplying transcript identifier, update date, and call start date for se_link construction.
- req_src_se_qa_pairs [undetermined]: StreetEvents question-answer relation used to identify question and answer speaker numbers in call- and question-level construction.
- req_src_processed_files [undetermined]: Processed-transcript index restricting the source universe used by call- and question-level non-answer construction.
- req_src_non_answers [undetermined]: Prepared non-answer detections joined to answer numbers and transcript identifiers for call- and question-level outcomes.
- req_src_regexes [undetermined]: Non-answer regex/category lookup used to classify refusal, inability, and after-call responses.
- req_src_word_counts [undetermined]: StreetEvents word-count features used for answer length, question text measures, number indicators, and the spontaneity measure.
- req_src_script_measure [undetermined]: StreetEvents script-length measure joined into the supplied spontaneity residualization stage.
- req_src_speaker_data [undetermined]: StreetEvents speaker data used to identify presentation speakers and qualify competition-utterance counts.
- req_src_comp_intensity [undetermined]: StreetEvents utterance-level competition intensity flags used to construct conference-call competition rates.
- req_src_ner_class7 [undetermined]: Stanford NER-derived utterance tags used to identify organization/product and entity-type mentions.
- req_src_ner_exclude [undetermined]: NER organization exclusion dictionary used to remove financial/regulator abbreviations before the product indicator is formed.
- req_src_topic_brvb [undetermined]: Topic indicators from the Brav and Bhattacharya source used for forward-looking and earnings-question measures.
- req_src_topic_mpr [undetermined]: Topic indicators from the Matsumoto-Pronk-Roelofsen source used to identify performance-related questions.
- req_src_fog_measure [undetermined]: Fog index feature data used to compute Q&A-level text complexity measures.
- req_src_tone_measure [undetermined]: Positive, negative, and uncertainty tone counts used to construct Q&A-level normalized text measures.
- req_src_ff_industry49 [undetermined]: Fama-French 49-industry classification bounds and labels used in annual fundamentals construction.
- req_src_co_hgic [undetermined]: Historical Compustat GICS classification relation used for fiscal-year industry controls.
- req_src_comp_funda [undetermined]: Annual Compustat fundamentals used to construct scaled accounting variables, SIC, annual lags/leads, and the quarterly SIC join.
- req_src_sec_history [undetermined]: Historical exchange-membership records used to derive exchange lists at each annual accounting date.
- req_src_ibes_id [undetermined]: IBES ticker/CUSIP interval relation used to map analyst and actual estimates to CRSP permno securities.
- req_src_ibes_actual [undetermined]: Unadjusted actual quarterly IBES data used to pair realized EPS and announcement dates with estimates.
- req_src_ibes_analyst [undetermined]: Unadjusted analyst quarterly estimates used to compute consensus, meet-or-beat, and dispersion measures.
- req_src_crsp_mse [undetermined]: CRSP monthly security-event table used to build historical permno/CUSIP validity intervals.
- req_src_crsp_dsf [undetermined]: CRSP daily stock file used for call-window returns/volatility, fiscal-year-end returns, and split-adjusted IBES prices/EPS.
- req_src_ciq_keydev [undetermined]: Capital IQ key-development announcements used to construct debt/equity-offering indicators after conference calls.
- req_src_idx_index [undetermined]: Compustat index catalog used to identify S&P 500, S&P 400, and S&P 600 index identifiers.
- req_src_idxcst_his [undetermined]: Compustat historical index-constituent intervals used to determine S&P 1500 membership at call start_date.
- req_src_executives [undetermined]: Equilar executive table used to select CEOs and merge annual title, tenure, and cash/stock compensation controls.
- req_src_equity_calc [undetermined]: Equilar equity-based compensation calculations joined to executive-management firm-year keys for full-control construction.
- req_src_hp_hhi [undetermined]: Hoberg-Phillips TNIC3-HHI relation used as an input to the merge with fluidity measures.
- req_src_hp_tnic3 [undetermined]: Hoberg-Phillips TNIC3 pairwise similarity scores used to calculate other-firm competition intensity around each call.
- req_src_hp_fluidity [undetermined]: Hoberg-Phillips fluidity relation full-joined with the TNIC3-HHI relation before a required post-join tnic3tsimm field is selected and matched to annual fundamentals.
- req_src_trade_comtrade [undetermined]: UN Comtrade imports relation aggregated by SIC and U.S./non-U.S. source for the growth-in-imports analysis.
- req_src_hpr_link [undetermined]: Hollander-Pronk-Roelofsen call-link relation consumed by CRSP call-window and S&P 1500 stages; no producer is supplied.
- sw_postgres_service [unverified]: The native programs create a PostgreSQL connection and set search_path to nonans_product, public, then read and write named PostgreSQL relations. No server endpoint, database, credentials, role/schema setup, or relation access was probed.
- sw_rpostgresql [preparation_required]: Native preparation scripts explicitly load RPostgreSQL. The exact package was not found in the selected R runtime's default library paths; prepare it in an appropriate project library and verify compatibility later.
- sw_dbi [preparation_required]: The spontaneity preparation script explicitly loads DBI. The package was not found in the selected R runtime's default library paths.
- sw_rpostgres [preparation_required]: The spontaneity preparation script creates its database connection with RPostgres::Postgres(). The package was not found in the selected R runtime's default library paths.
- sw_dplyr [preparation_required]: The native data programs and analysis snippets explicitly use dplyr. The package was not found in the selected R runtime's default library paths.
- sw_tidyr [preparation_required]: The spontaneity preparation program explicitly loads tidyr for its authored data reshaping. The package was not found in the selected R runtime's default library paths.
- sw_psych [preparation_required]: The final call and question-answer estimation-set scripts explicitly load psych for winsorization. The package was not found in the selected R runtime's default library paths.
- sw_sandwich [preparation_required]: The embedded analysis loads sandwich for the two-way clustered covariance calculation. The package was not found in the selected R runtime's default library paths.
- sw_lmtest [preparation_required]: The embedded analysis loads lmtest for coeftest. The package was not found in the selected R runtime's default library paths.
- sw_stargazer [preparation_required]: The embedded analysis loads stargazer to render regression tables. The package was not found in the selected R runtime's default library paths.
- sw_tidyverse [preparation_required]: The embedded analysis explicitly loads tidyverse. The package was not found in the selected R runtime's default library paths.

## Review notes

- Static review covers all 15 supplied PostgreSQL-backed R programs, the complete embedded analysis note, the author data-sheet, and workflow documentation. The full pipeline retains every supplied stage, including create_crsp_fye, and remains unresolved for compatible upstream relation contents, outside-scope transcript/non-answer/feature producers, hpr_link, PostgreSQL setup, and the post-join tnic3tsimm source mapping.
- The separate prepared-data analysis route is supported by the author's calls_set_glz.RData and ner_set_glz.RData candidates and embedded analysis code. It reproduces the documented modified main-results branch without Equilar controls, using CIK and randomized file_name_alt identifiers while omitting call dates; it is not full-original equivalence. Both RData schemas and compatibility remain unknown because no deserialization was performed.
- The bounded frozen catalog lookup identifies candidate local SAS source tables for Compustat annual/quarterly data, GICS/security history, CRSP daily stock data, CIQ key-development events, IBES raw actuals/detail files, and index constituent history. It records metadata-backed field/format matches where available; it does not establish data readability, product entitlement, PostgreSQL conversion, actual time coverage, or compatible author-specific prepared-feature contracts. Cataloged Fama-French factor files are not a substitute for the required industry_49 classification, and the source-required fromdt field was not identified in the cataloged COMP.IDXCST_HIS candidate.
- Only runtime/package metadata and the frozen workspace catalog were inspected. No author program was sourced, loaded, compiled, or run; no database query, package installation, dataset read/download/construction, RData deserialization, regression, or model was performed. R 4.5.0 is available, while ten exact R packages were absent from the selected runtime's default library paths.
