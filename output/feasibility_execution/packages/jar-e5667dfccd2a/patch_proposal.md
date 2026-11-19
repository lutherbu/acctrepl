# Patch proposal: jar-e5667dfccd2a

AI Democratization and Trading Inequality

DOI: 10.1111/1475-679X.70063

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied SAS and Stata workflow: anomaly and return construction, retail and short-sale measures, transcript/event merges, high-frequency windows and spreads, outage analysis, Stata alignment, and table code. The ten registered programs are all included; stages 5 and 7 require an interleaved two-pass order.

Entry points: `CDMZ-datasheet-code-identifiers-and-log-files 2609/code and identifiers/1_anomaly.sas`, `CDMZ-datasheet-code-identifiers-and-log-files 2609/code and identifiers/2_ret.sas`, `CDMZ-datasheet-code-identifiers-and-log-files 2609/code and identifiers/3_retail.sas`, `CDMZ-datasheet-code-identifiers-and-log-files 2609/code and identifiers/4_short.sas`, `CDMZ-datasheet-code-identifiers-and-log-files 2609/code and identifiers/5_merge_call.sas`, `CDMZ-datasheet-code-identifiers-and-log-files 2609/code and identifiers/6_shortwintrade.sas`, `CDMZ-datasheet-code-identifiers-and-log-files 2609/code and identifiers/7_RetailAIAlign.do`, `CDMZ-datasheet-code-identifiers-and-log-files 2609/code and identifiers/8_outage and trading.sas`, `CDMZ-datasheet-code-identifiers-and-log-files 2609/code and identifiers/9_hfspread.sas`, `CDMZ-datasheet-code-identifiers-and-log-files 2609/code and identifiers/TABLES_CODE.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 3/70063 - AI-Democratization-and-Trading-Inequality/cdmz-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "99b862b0875712be5d2da10690aef4a40a75ea1aa3919f56649e8005bfd4beb1"
    },
    {
      "path": "JAR-Volume 64/Issue 3/70063 - AI-Democratization-and-Trading-Inequality/cdmz-online-appendix.pdf",
      "sha256": "66e49a6ef3aa444937a65a2e103078355c5cbf5d28c557e22f5a6ee61073b7c4"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "56a5e875193b5682bf26df45c1c2cb1d4f78cf4a1d0af61019f72cbd2980acf7"
}
```

## Proposed actions

### ACT_CLOSURE: Obtain a source-to-product handoff manifest for all unverified raw and prepared inputs, including the listed fields, identifier/date keys and rolling history. Keep the ten supplied code stages intact.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS_CLOSURE
Evidence: E_DOC_DATA, I_WORK_ITEM

Preparation / proposed procedure:

1. Record which required input files are already available and their exact provider product, native schema, keys, date range and library/file path.
2. For every generated table, record the producing stage and its first consumer; keep genuinely unknown products as unresolved author questions.

Validation to perform later:

- Reconcile all 135 frozen dependency IDs against the completed source-backed dependency_review before any run.

### ACT_ICLINK: Ask for the exact ICLINK source/include and its author-prepared schema and dated coverage; confirm the visible home.iclink fields score, permno and ticker.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ICLINK, ISS_ICLINK
Evidence: E_S1_ICLINK, I_WORK_ITEM, P_IDENTIFIERS

Preparation / proposed procedure:

1. Provide the authorized ICLINK input or identify its existing compatible location and library assignment.
2. Confirm its score coding, ticker/PERMNO fields, effective dates and any include-file setup without changing the research mapping.

Validation to perform later:

- Check the prepared crosswalk has the code-consumed fields and covers all IBES forecast/announcement and call-event dates.

### ACT_MAPS: Request the author-prepared retail and symbol-link tables or their documented compatible source products, with field and date-key contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CFRAC, R_TCLINK, R_TCLINK2504, R_TAQMCLINK, ISS_MAPS
Evidence: E_S3_CFRAC, E_S3_CFRAC_FIELDS, E_S3_CFRAC_FRACTION, E_S3_CFRAC_KEYS, E_S3_TCLINK, E_S3_TCLINK_DATES, E_S3_TCLINK_JOIN, E_S3_TCLINK_MATCH, E_S4_TAQMCLINK, E_S4_TAQMCLINK_PERMNO, E_S4_TAQMCLINK_KEYS, E_S4_TAQMCLINK_SYMBOL, E_S9_TCLINK, E_S9_TCLINK_DATES, E_S9_TCLINK_ENDDATE, E_S9_TCLINK_MATCH, E_S9_TCLINK_KEYS, P_IDENTIFIERS, C_WRDSAPPS_TAQMCLINK

Preparation / proposed procedure:

1. Confirm cfrac has vwap, shsvol, centfrac, date and symbol.
2. Confirm tclink and tclink2504 have score, begdate, enddate, symbol and permno with the intended date convention.
3. Confirm TAQMCLINK has sym_root, sym_suffix, date and permno and identify the exact compatible local/provider table.

Validation to perform later:

- Join a bounded approved metadata sample on the specified symbol/date keys later; verify score filters and effective-date coverage without substituting the packaged permno-only CSV.

### ACT_FINRA: Resolve whether the target is FINRA monthly transaction detail or daily aggregate volume, then confirm the named monthly table source and required history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FINRA, ISS_FINRA
Evidence: E_DOC_DATA, E_S4_FINRA_IMPORT, E_S4_FINRA_FIELDS_FULL, E_S6_FINRA_BRANCH, E_S6_SHORT_FILTER, E_S6_FINRA_FIELDS_USE, E_S6_FINRA_SYMBOL, E_S6_FINRA_TIME, E_FINRA_PUBLIC, C_FINRA

Preparation / proposed procedure:

1. Obtain the documented FINRA monthly short-sale transaction files for the code’s transaction-level import if that is the intended source.
2. Confirm whether the stage 6 SS.FINRA monthly tables map to that source and preserve the code-consumed date, symbol, time, shorttype and size fields. The stage 4 importer declares matching native field names; the library/product mapping is not established.
3. Preserve at least the 252 trading days preceding each rolling window in addition to the event dates.

Validation to perform later:

- Compare product unit, imported field names, report-date/time convention, transaction filters, monthly date coverage and 252-day rolling-history coverage with the supplied code and datasheet before running.

### ACT_TAQ: Arrange authorized access to the TAQ CTM and complete NBBO products used by the supplied intraday readers; the exact catalog probes returned no matching candidate, which does not establish an access barrier.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_TAQ_CTM, R_NBBO
Evidence: E_S6_CTM, E_S6_CTM_FIELDS, E_S6_CTM_FILTER, E_S6_CTM_TIME, E_S6_CTM_SIZE, E_S6_CTM_SYMBOL, E_S6_CTM_DATE, E_S9_NBBO_FIELDS, C_CT_CTM, C_NBBO_COMPLETE_NBBO, E_DOC_DATA

Preparation / proposed procedure:

1. Identify the permitted TAQ CTM and complete NBBO source tables available to this project.
2. Supply daily event and adjacent trading-day CTM data with the code-required symbol-root/suffix, correction, price, size, exchange, date and time fields.
3. Supply NBBO quote/depth fields and daily coverage for the event-window requests.

Validation to perform later:

- Check native field names, time zone/time precision, symbol suffix behavior, corrected/cancelled trade handling, positive quote/depth conditions, and event-window coverage against the code.

### ACT_CALL_DATA: Request the prepared transcript, CIQ headline/date join and precomputed sentiment outputs with their documented scoring provenance.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TRANSCRIPT, R_CIQ_KEYDEV_DATES, R_CALL_GPT, ISS_CALL_DATA
Evidence: E_DOC_DATA, E_S5_TRANSCRIPT, E_S5_CIQ_DATES, E_S5_CALL_GPT

Preparation / proposed procedure:

1. Provide transcript titles, timestamps and types for the documented 2021–2024 period.
2. Provide the keyDevId/headline/mostImportantDateUTC join table and explain the event-date selection.
3. Provide file_name/gpt_sent scores and the consistent prompt/model-vintage documentation; do not call a model or API during this static assessment.

Validation to perform later:

- Verify file_name joins to the supplied title/headline fields; document GPT-3.5-Turbo-16k for 2021–2023, GPT-4o Mini for 2024, and the -10 to +10 score range.

### ACT_OUTAGE_INPUTS: Request the historical outage panel and incident-impact CSV with event timestamp semantics and complete date coverage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_OUTAGE_OLD, R_OUTAGE_IMPACTS, ISS_OUTAGE
Evidence: E_S8_OLD_PANEL, E_S8_OLD_BEG, E_S8_OLD_END, E_S8_OLD_FALLBACK, E_S8_OLD_DOWNTIME, E_S8_OLD_KEEP, E_S8_IMPACTS, E_S8_IMPACT_FIELDS_FULL, E_S8_IMPACT_INPUT

Preparation / proposed procedure:

1. Provide the old panel fields used for outage start/end timestamps, title, text, type and downtime.
2. Provide the incident export fields and document raw timestamp timezone, missing-end convention, component selection and URL/status semantics.

Validation to perform later:

- Confirm the old/new outage cutoff and verify date/time coverage before constructing the combined outage panel.

### ACT_HF_PRODUCTS: Resolve the documented high-frequency product, partition, library/path and field contracts while preserving the supplied treatment-plus-spread producer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HFRETAIL_SPREAD, R_HF_SPREAD_HALVES, R_DID_BETART, ISS_HF_PRODUCER, ISS_HFBAS_ALIAS
Evidence: E_S9_SPREAD_PARAMETERS, E_S9_SPREAD_MEASURES, E_S9_CALLS_WITH_KEYS, E_S9_EXPORT, E_S9_SPREAD_DTA_EXPORT, E_S9_HALVES, E_S9_HALVES_TAIL, E_S9_HFRETAIL, E_S9_HFRETAIL_KEYS, E_S9_DID_INPUT, E_S9_DID_FIELDS, E_S9_DID_PRODUCER, E_S9_DID_EXPORT, E_TABLE_HFBAS_USE, E_S9_NBBO_FIELDS

Preparation / proposed procedure:

1. Confirm the source and field contract for the separate hfrt.ret_gpt_hfretailw input; preserve its distinction from the stage 6 mydata.gpt_hfretailw output.
2. Map the supplied OUT.RET_GPT_HFBAS_&SPL. producer and its active 2021/month 1–12 parameters to the eight HFIID half-year consumers, including the exact partition, destination library/path, and spread schema. CALLSTDTTIME and TIME_ADJ_DATE are both carried into the exported producer dataset; validate their timing semantics and values without treating either field as absent. Call inputs and the separate NBBO product remain unresolved.
3. Identify the producer and exact macro values, field schema and destination of the upstream IID.DID_BETART&ORDTYPE.&TIME._MAC input; retain the supplied DID_BETARTGPT2124_HFBAS writer and confirm whether its expanded DTA filename and fields match the fixed Stata request.

Validation to perform later:

- Confirm each of the eight half-year files covers the required period, with PERMNO, event-time join key and table-consumed spread fields; reconcile the macro-expanded output basename and schema to the literal Stata input without assuming alias equivalence.

### ACT_OUTAGE_FILENAME: Confirm the masked Stata consumer filename against the macro-expanded stage 8 export before staging the generated outage result.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_OUTAGE_FILENAME
Evidence: E_S8_DATASET_NAME, E_S8_EXPORT, I_WORK_ITEM

Preparation / proposed procedure:

1. Resolve the intended dataset_hf and type macro values and confirm the Stata input basename from the author source.
2. Document one exact export/consumer name mapping; do not rename either side based on a guessed expansion.

Validation to perform later:

- Compare the completed stage 8 DTA basename with the exact Stata use statement and confirm its required fields.

### ACT_STAGING: Persist and stage source-proven generated products under the next consumer’s intended library/path before their first read.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: ISS_STAGING
Evidence: E_S4_FRDAY_OUT, E_S6_FRDAY_READ, E_S6_HFRT_CALL, E_S6_HFRT_READ, E_S3_RETAIL_OUT, E_S5_FULLMERGE_OUT, E_S6_FULLMERGE, E_S6_HFSHORT_CALL, E_S6_HFSHORT_READ, E_S8_HFRET_CONSUMER

Preparation / proposed procedure:

1. Persist WORK.fr_day from stage 4 before stage 6 reads MYDATA.fr_day.
2. Stage the stage 6 macro outputs scratch.hfretail and WORK.hfshort to the expected MYDATA readers before their first read.
3. Stage the generated weekly retail, short-sale and fullmerge panels in a consistent library/file path for stages 5, 6 and Stata; preserve the generated schema and both Mac/manual variants.
4. Stage the stage 6 high-frequency retail product under the HF library expected by stage 8 after verifying same-product schema.

Validation to perform later:

- Check each producer and consumer library/path, keys and native fields; confirm writes occur before consumers and before any destructive WORK cleanup.

### ACT_ORDER: Preserve the supplied stage 5 / stage 7 interleave for the betartonly2124_mac.dta exchange.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: ISS_ORDER
Evidence: E_S5_RETAIL_MAC, E_S5_SHORT_MAC, E_S5_BETART_IMPORT, E_S7_BETART_INIT, E_S7_BETART_APPEND

Preparation / proposed procedure:

1. Run 5_merge_call.sas through its retail/short exports and stop before the betartonly2124_mac.dta import.
2. Run 7_RetailAIAlign.do to create and append betartonly2124_mac.dta.
3. Resume 5_merge_call.sas at the import and complete its remaining outputs; run TABLES_CODE.do only after its generated inputs exist.

Validation to perform later:

- Confirm the imported DTA was written by stage 7 and that the SAS continuation writes the return/short-sale Table 7 panel consumed by Stata.

### ACT_SAS_SETUP: Configure the documented SAS runtime, WRDS libraries and project staging paths for the supplied SAS scripts.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: SW_SAS
Evidence: P_ENVIRONMENT, E_S1_FUNDQ, E_S5_TRANSCRIPT

Preparation / proposed procedure:

1. Set up the required SAS 9.4/18-compatible execution environment and project library assignments without changing the authors’ data transformations.
2. Use the typed environment metadata only; a SAS startup or author-code trial was not performed in this assessment.

Validation to perform later:

- Before an authorized run, verify the configured libraries resolve to the exact probed/authorized source tables and staged generated products.

### ACT_WINSOR2_SETUP: Install or otherwise provision the free Stata winsor2 command in the authorized Stata environment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2
Evidence: P_ENVIRONMENT, E_S7_WINSOR, E_TABLE_WINSOR

Preparation / proposed procedure:

1. Provision the winsor2 command using the project’s approved Stata package setup.

Validation to perform later:

- In a later authorized preparation step, confirm the exact winsor2 command resolves for the calls in stages 7 and TABLES_CODE.do; do not alter cut points or grouping options.

### ACT_STATA_ADDONS: Resolve the installed status of the exact Stata commands eststo and psmatch2 before running the table source.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_ESTSTO, SW_PSMATCH2
Evidence: P_ENVIRONMENT, E_TABLE_ESTSTO, E_TABLE_PSMATCH2

Preparation / proposed procedure:

1. Check the authorized Stata command environment for eststo and psmatch2; install only if absent and approved.

Validation to perform later:

- Confirm both exact commands are available with the required table calls; preserve the supplied matching and estimation syntax.


## Remaining issues and prerequisites

- ISS_CLOSURE [unresolved; full_pipeline]: The code package includes ten preparation/analysis sources, but mandatory prepared inputs, local map contracts, several product producers and path/order handoffs remain unverified. The full pipeline is not closed.
- ISS_ICLINK [unresolved; full_pipeline]: The ICLINK include target is partly masked; visible consumers use home.iclink, but the supplied include identity, field contract, and local route are not established. The packaged Identifiers.csv contains only permno and cannot replace the crosswalk.
- ISS_MAPS [unresolved; full_pipeline]: The retail and high-frequency paths rely on prepared cfrac, tclink, tclink2504 and TAQMCLINK mapping records with date/symbol keys. Their compatible sources and full contracts are not verified; the packaged identifier CSV has only permno.
- ISS_FINRA [unresolved; full_pipeline]: The datasheet describes daily security-level aggregate FINRA volume, while stage 4 imports monthly transaction-level fields and stage 6 separately reads SS.FINRA monthly tables using date, symbol, time, shorttype and size. The stage 6 table-to-import mapping and intended product remain unresolved; the stage 4 input declarations include the field names used by stage 6.
- ISS_CALL_DATA [unresolved; full_pipeline]: Transcript files, the CIQ headline/date join, and precomputed call_gpt scores are not supplied or verified. The documented model vintages, consistent prompt and score range are provenance requirements; no model or API call is part of this assessment.
- ISS_OUTAGE [unresolved; full_pipeline]: The outage stage requires a prepared historical event panel and a separate incident-impact CSV; their full schemas, event-time semantics, and sample coverage remain unverified.
- ISS_HF_PRODUCER [unresolved; full_pipeline]: The supplied spread program creates and exports a macro-named ret_gpt_hfbas product from four relative-spread measures; current parameters select SPL=21 and year 2021 with months 1–12. It explicitly carries both CALLSTDTTIME and TIME_ADJ_DATE into CALLS_WITH_SPREADS, but the output partition and OUT/path mapping to the eight HFIID 2021H1–2024H2 consumer tables, time semantics and value-level compatibility remain unvalidated. The separate hfrt retail input, macro-selected upstream DID_BETART input, masked call-input contract, and NBBO product also remain unresolved.
- ISS_STAGING [preparation; full_pipeline]: Several supplied products are produced in WORK/SCRATCH or one SAS library and consumed from another: fr_day, hfretail, hfshort, retail/short panels, and the outage high-frequency source. Stage the exact generated product before its first consumer and preserve its schema.
- ISS_ORDER [preparation; full_pipeline]: 5_merge_call.sas imports betartonly2124_mac.dta after its earlier retail/short exports. 7_RetailAIAlign.do creates that DTA. Run SAS stage 5 through its preceding exports, then Stata stage 7, resume SAS stage 5 at the import, and only then proceed to tables.
- ISS_HFBAS_ALIAS [unresolved; full_pipeline]: The supplied SAS source creates DID_BETARTGPT2124_HFBAS from GPT_HFBAS and DID_TREAT and exports did_betart&ordtype.&time._hfbas.dta. Stata separately requests did_betartonly2124_hfbas.dta. Resolve macro values, destination and output-schema alignment; do not infer that the two basenames are aliases.
- ISS_OUTAGE_FILENAME [unresolved; full_pipeline]: The 8_outage export uses macro-expanded dataset_hf and type components. The assigned dependency checklist records a Stata input name for the outage panel, but its source window is masked; confirm the exact expanded export filename and consumer before staging it.
- R_ICLINK [undetermined]: The ICLINK score/PERMNO/ticker crosswalk used by the anomaly and short-window codes; the include source is masked and no matching probe is available.
- R_CFRAC [undetermined]: Prepared TAQ trade classification table consumed by the retail construction, with VWAP, share volume, cent fraction, date, and symbol.
- R_TCLINK [undetermined]: Prepared ticker-to-PERMNO mapping with score and effective begin/end dates, used by the retail and short-window programs.
- R_FINRA [undetermined]: The datasheet describes daily aggregate short-sale volume, while supplied stage 4 imports monthly transaction-detail fields and stage 6 separately reads SS.FINRA monthly tables using date, symbol, time, shorttype and size. The intended product and whether the stage 6 tables map to the stage 4 import remain unresolved.
- R_TAQMCLINK [undetermined]: TAQ master link table mapping symbol root/suffix and date to PERMNO for FINRA trades.
- R_TRANSCRIPT [undetermined]: Prepared Capital IQ transcript dataset, including titles, event timestamp, and type fields consumed by the event merge.
- R_CIQ_KEYDEV_DATES [undetermined]: Separate CIQ key-development headline and most-important-event-date fields joined by keyDevId.
- R_CALL_GPT [undetermined]: Precomputed author sentiment-score file joined to transcript/CIQ events by file_name; prompt text, model outputs and score provenance are not in the supplied code.
- R_TAQ_CTM [undetermined]: TAQ CTM consolidated trade messages used to construct intraday retail trade classifications around calls. The supplied filter and joins require correction code, price, size, exchange, date, time, and symbol-root/suffix fields across event and adjacent trading dates; no matching catalog candidate or readable probe establishes the local product.
- R_OUTAGE_OLD [undetermined]: Prepared outage event panel used as the historical baseline for the outage merge; the source consumes embedded start/end timestamps, timestamp_end_et_ fallback, title, text, type and downtime fields.
- R_OUTAGE_IMPACTS [undetermined]: Incident-impact CSV parsed into incident ID, raw start/end times, component, status, group, and URL fields.
- R_NBBO [undetermined]: TAQ complete NBBO quote observations used for intraday bid-ask spread/depth measures.
- R_TCLINK2504 [undetermined]: Prepared ticker/PERMNO mapping with effective dates and score for the 2025-vintage after-hours spread branch.
- R_HFRETAIL_SPREAD [undetermined]: Separate high-frequency retail response panel read by 9_hfspread.sas from HFIID/HFRT libraries; no exact supplied producer establishes this product.
- R_HF_SPREAD_HALVES [undetermined]: The consumer reads eight HFIID half-year spread panels. The supplied program creates OUT.RET_GPT_HFBAS_&SPL. and exports CALLS_WITH_SPREADS with both CALLSTDTTIME and TIME_ADJ_DATE explicitly selected; the existing sources therefore establish that both fields are carried. Current parameters are SPL=21, YR=2021 and MBeg/MEnd=1/12, while exact mapping, partition, destination library/path, full output schema, time semantics and value-level compatibility for the 2021H1–2024H2 consumer remain unvalidated.
- R_DID_BETART [undetermined]: Macro-selected upstream treatment/alignment panel read by the supplied spread program; its producer, ordtype/time values, exact filename and full time-window/betartgpt field schema are not established.
- SW_SAS [unverified]: SAS is required by stages 1–6, 8 and 9. The typed environment viewer marked SAS unverified; no SAS process or startup probe was performed.
- SW_ESTSTO [unverified]: The table source invokes eststo; the typed environment projection has no matching exact software proof key.
- SW_PSMATCH2 [unverified]: The table source directly invokes psmatch2; the typed environment projection has no matching exact software proof key.
- SW_WINSOR2 [preparation_required]: winsor2 is called in both Stata alignment and table code; the typed environment metadata reports it unavailable.

## Review notes

- This assessment covers the full supplied pipeline only; no analysis_only path is supported by a complete compatible prepared panel and code route.
- The original environment probe is opaque and is referenced only by hash. Software status comes from the pinned typed metadata viewer; SAS was never started.
- All raw SAS probes are bounded one-row readability/field checks. They do not establish empirical history, full population coverage, or original author extract/vintage fidelity.
- No logs, run outputs, model/API trials, SQL payloads, protected raw bodies, or source-view manifests are scientific evidence. The unverified PostgreSQL metadata artifact was not cited.
- The approved source viewer masked credential/path tokens and some block-comment rows. In particular the table-code outage use-site window around line 696 is masked; D0128 is retained as a checklist-linked issue and not quoted as visible source.
- The D0123 SAS output uses ordtype/time macro components and is not assumed equal to the fixed Stata filename. The D0128 outage export/consumer basename also needs explicit confirmation.
- Exact catalog lookup misses for TAQ CTM, NBBO, TAQMCLINK and FINRA do not establish unavailable data or licensing barriers. The FINRA public notice distinguishes monthly transaction-detail files from daily aggregates.
- The 5_merge_call / 7_RetailAIAlign interleave is source-proven. Stage 5 outputs first, run stage 7, resume stage 5 at the import, then run table code.
