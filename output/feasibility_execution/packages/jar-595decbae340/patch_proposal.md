# Patch proposal: jar-595decbae340

Listen Closely: Measuring Vocal Tone in Corporate Disclosures

DOI: 10.1111/1475-679X.70015

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied Python workflow: independent Table 2 and Table 3 analyses; author sample construction; and market outcomes using the constructed call-level sample plus a separate Fama-sorted portfolio panel. Includes the shared regression helper as supporting code. Tab4 and Tab5 are byte-identical copies and represent one market-outcome source path to run once.

Entry points: `code/Tab2_ModelEval.py`, `code/Tab3_InnerWorkings.py`, `code/create_sample.py`, `code/Tab4_9_MarketOutcomes.py`, `code/Tab5_9_MarketOutcomes.py`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70015 - Listen-Closely-Measuring-Vocal-Tone-in-Corporate-Disclosures/eknr-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "2ae8999f124664116926eb1ef342a965192b10db1e28c0bef540e0516d002f8f"
    },
    {
      "path": "JAR-Volume 64/Issue 1/70015 - Listen-Closely-Measuring-Vocal-Tone-in-Corporate-Disclosures/eknr-online-appendix.pdf",
      "sha256": "03356167317092acdc4a9997d408c051aff7bafff17d95330aaf4af09f395782"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "df514908a1ab86cb9790860b5478cb408cd9246ec7dbce150a40d6addcd59959"
}
```

## Proposed actions

### A_AUTHOR_PREPARED_DATA: Obtain the exact author-prepared workbook and required Parquet panels, together with producer/version notes, schemas, identifiers, filters and date coverage. Keep the Table 3 sentence-level and sample-construction paragraph-level inputs distinct.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_MODEL_PREDICTIONS, R_TURN_DATA, R_TAB3_PHONETICS, R_SPEAKER_MASTER, R_FINVOC_SENTENCE, R_F2V_CALL, R_PRAAT_PARAGRAPH, I_SOURCE_CLOSURE
Evidence: E_DOC_CODE_RELEASE, E_FIELD_COMPARISON, E_WORK_ITEM

Preparation / proposed procedure:

1. Request or locate 241108model_predictions_mastersheet_all.xlsx with its default, EC pyaudio and Actor pyaudio sheets and the listed columns.
2. Request or locate df_turn_data.parquet and document the complete numeric-column schema and its producer because create_sample.py dynamically averages numeric columns beyond its fixed field list.
3. Request or locate df_sent_phonetics.parquet, tic_callid_speaker_master.parquet and FinVoc2Wav_sentid.parquet with their recorded join keys and native fields for Tab3_InnerWorkings.py.
4. Request or locate FinVoc2Wav_neu_emo_call.parquet and df_par_phonetics.parquet with their recorded call-level and paragraph-level fields for create_sample.py.
5. Record file checksums, sample period, row/key uniqueness expectations and the producer or canonical author release location for each delivered file.

Validation to perform later:

- Use bounded metadata checks to confirm each exact file path, expected columns, types and join-key null/duplicate rules before attempting analysis.
- Confirm with the package owner that the supplied extracts cover the intended author sample and that their producer steps are complete.

### A_CRSP_EVENT_PANEL: Obtain the exact author-prepared CRSP event-window file or its documented producer. The local DSF schemas are raw security/date products and do not establish the call-linked cumulative-return panel.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_CRSP_CAR_WINDOWS, I_CRSP_CAR_CONSTRUCTION
Evidence: E_FIELD_COMPARISON, E_CATALOG_CRSP

Preparation / proposed procedure:

1. Ask for CRSP_CAR_DAILY_FULL_WINDOWS.parquet with callid, car_0_1, car_2_61, t-1 and the full set of source columns retained by the code.
2. If the author expects the raw-CRSP branch, obtain the call-to-security mapping, event-date rule, return adjustment and window definitions, and the exact producer code/version before constructing anything.
3. Do not treat the raw catalog candidates as a verified substitute until the mapping, field semantics and required period are documented.

Validation to perform later:

- Check the delivered schema and bounded date/key coverage against the author's definitions for all required event-window fields.
- Compare the producer's call and security identifiers to the packaged identifier universe without inferring missing mappings.

### A_IBES_PANELS: Obtain both exact author-prepared call-linked I/B/E/S panels or their versioned producer and mapping rules. Catalogued raw detail, actual and summary tables are candidates only and do not directly match the prepared fields.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_IBES_SUMMARY, R_IBES_EARNINGS_CHANGES, I_IBES_PANEL_MAPPING
Evidence: E_FIELD_COMPARISON, E_CATALOG_IBES

Preparation / proposed procedure:

1. Request EarningsSurprises_IBES_Summary_inclREVISION.parquet with its complete schema, callid mapping and revision-selection rule.
2. Request IBES_EarningsChanges_q.parquet with the recorded callid/gvkey, PENDS_q0-q4, earn_chg_drift_q1-q4, PRC_SPLITADJ_q1-q4 and ibes_count_drift_q1 fields.
3. If raw I/B/E/S sources are intended, obtain the author-approved ticker/call crosswalk, fiscal-quarter alignment, forecast/actual selection and split-adjustment procedures before deriving either panel.

Validation to perform later:

- Verify callid uniqueness/merge behavior and quarter field definitions against the supplied Python merge code.
- Use bounded schema and period checks to confirm all required prepared fields; do not infer a successful mapping from raw ticker or CUSIP fields alone.

### A_FF5_SORTED_PANEL: Obtain the prepared tone-sorted portfolio file and producer description, because the market-outcome scripts contain a read but no construction step for this study-specific panel.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_FF5_SORTS, I_FF5_PRODUCER
Evidence: E_MARKET_FAMA_INPUT, E_FIELD_COMPARISON

Preparation / proposed procedure:

1. Request REPLICATION_2_FF5_VocalToneSorts_FF5.parquet or the exact author procedure that creates it.
2. Document the datetime_crsp convention, quintile assignment and voice-tone measures, portfolio-return construction, factor source, frequency and date coverage.
3. Retain the code's required Mkt-RF, SMB, HML, RMW, CMA and RF columns without substituting a generic factor file for the study-specific portfolio panel.

Validation to perform later:

- Check the exact prepared schema, factor/return units, sort-date alignment and intended period before running the market-outcome stage.
- Confirm which of the identical Tab4/Tab5 source copies is retained for the single execution.

### A_COMP_FUNDQ_EXPORT: Stage the verified local COMP.FUNDQ fields into the CSV layout expected by create_sample.py, while validating needed dates after the author call/quarter keys are known.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMP_QUARTER
Evidence: E_COMP_FUNDQ_PROBE, E_COMP_FUNDQ_SCHEMA, E_FIELD_COMPARISON

Preparation / proposed procedure:

1. After author call and gvkey/quarter keys are confirmed, extract gvkey, datadate, prccq and atq from COMP.FUNDQ for those keys plus the preceding quarter needed for atql1.
2. Write the CSV input expected by the source code and format datadate in the parser's MM/DD/YYYY string format.
3. Record extracted date bounds and row counts without treating the one-row metadata probe as a coverage count.

Validation to perform later:

- Confirm exact column names, date parsing and quarter-lag alignment on bounded rows before the sample-building run.
- Confirm the needed date range against the author-prepared turn panel; the current probe did not establish it.

### A_FULL_RUN_ORDER: Use a working copy with the source path constants configured, then follow the actual producer/consumer order. The independent Table 2/Table 3 stages are retained, and the generated call-level sample precedes the market analysis.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I_SOURCE_CLOSURE
Evidence: E_DOC_CODE_RELEASE, E_SAMPLE_OUTPUT, E_MARKET_SAMPLE_INPUT, E_WORK_ITEM

Preparation / proposed procedure:

1. Stage the supplied code and shared reg_functions helper in a working directory and set the path constants to the verified input and output locations.
2. Run Tab2_ModelEval.py and Tab3_InnerWorkings.py as separate analyses after their workbook/panel inputs are available.
3. Run create_sample.py after df_turn_data, identifiers, CRSP, I/B/E/S, Compustat, call-tone and paragraph-phonetics inputs are staged; ensure its CALL_LEVEL_SAMPLE.parquet output is placed in the market scripts' current directory.
4. Run either Tab4_9_MarketOutcomes.py or Tab5_9_MarketOutcomes.py once; their frozen source hashes are identical. Retain both source paths in the package inventory.

Validation to perform later:

- Before execution, check that every consumed file resolves from the configured paths and that the generated CALL_LEVEL_SAMPLE.parquet is present in the market scripts' current directory.
- Confirm no required input or producer was skipped; the current assessment does not establish execution success.

### A_LINEARMODELS_ENTRYPOINT: Confirm the actual linearmodels.PanelOLS entry point in the target Python environment. The bounded distribution lookup did not find linearmodels, but no import or analysis trial was performed.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_LINEARMODELS
Evidence: E_PYTHON_DISTRIBUTIONS, E_FIELD_COMPARISON

Preparation / proposed procedure:

1. When environment management is available, check whether `from linearmodels import PanelOLS` is usable in the target environment.
2. If the actual entry point is absent, install a version-compatible linearmodels package in the target project environment and record the version; do not install into the managed base environment without its administrator.

Validation to perform later:

- Confirm the exact PanelOLS import used by the source code in the project environment before starting the market-outcome stage.


## Remaining issues and prerequisites

- I_SOURCE_CLOSURE [unresolved; full_pipeline]: The package includes five analysis/preparation entry scripts and a shared helper, but only the identifier subset is packaged among the consumed analysis inputs. Required author workbook/panels, the prepared phonetics and call-level tone files, and the source procedures for several panels remain unprovided. create_sample.py writes CALL_LEVEL_SAMPLE.parquet and the market-outcome scripts read it; there is no supported complete source-to-output closure until the missing inputs and their producers are supplied.
- I_CRSP_CAR_CONSTRUCTION [unresolved; full_pipeline]: Catalogued local CRSP.DSF and CRSP.DSF_V2 are raw security/date products whose inspected schemas do not contain callid, car_0_1, car_2_61 or t-1. The supplied code does not construct the call-linked event-window panel or document the event dates, security mapping or return-window rules. The raw candidates do not establish a compatible route, access barrier, or absence of data.
- I_IBES_PANEL_MAPPING [unresolved; full_pipeline]: The author-prepared I/B/E/S files are call-linked panels, while catalogued raw detail, actual and statistics candidates do not supply callid and the prepared quarter dates, drift measures and split-adjusted prices. No source maps calls to I/B/E/S identifiers, selects revisions or constructs the prepared panels. Catalog results do not establish access or prove the prepared files are absent elsewhere.
- I_FF5_PRODUCER [unresolved; full_pipeline]: The market-outcome scripts consume a study-specific quintile-sorted voice-tone panel with Fama-French factors, but the package contains no producer or schema for it. A catalog miss for a Fama-specific product is not evidence of nonexistence or access restriction.
- R_MODEL_PREDICTIONS [undetermined]: Missing author workbook 241108model_predictions_mastersheet_all.xlsx, read by Tab2_ModelEval.py. Consumed workbook fields are model, y_true, y_pred, y_pred_proba_-1, y_pred_proba_0, y_pred_proba_1 and y_pred_proba; the default sheet plus separate EC pyaudio and Actor pyaudio sheets are used. No workbook/schema is packaged.
- R_TURN_DATA [undetermined]: Missing author-prepared df_turn_data.parquet consumed by create_sample.py. Fixed source-consumed fields: CEO_DUMMY, CFO_DUMMY, LEV, MTB, SALE_GROW, STDEV, UE_MED, adjscript_m, call_year, call_year_month, call_year_quarter, callid, end_m, end_score_m, fb_net_a, fb_net_m, fqtr, fyearq, litigious_w_m, lnSIZE, marker_m, mod_fog_m, non_answer_total_m, parid_m, prccq, pre_sigma_60_1, pyaudio_librosa_m, pyaudio_librosa_roll_sc_m, pyaudio_librosa_sc_m, pyaudio_praat_m, pyaudio_praat_roll_sc_m, pyaudio_praat_sc_m, ric, sic, speaker_info_m, speaker_m, specific_w_a, specific_w_m, start_m, start_score_m, text_m, tic, turnid, uncertainty_w_m, vmp_tone_librosa_m, vmp_tone_librosa_roll_sc_m, vmp_tone_librosa_sc_m, vmp_tone_praat_m, vmp_tone_praat_roll_sc_m, vmp_tone_praat_sc_m, vocal_tone_m, vocal_tone_roll_sc_m and vocal_tone_sc_m. In addition, the code averages every numeric input column outside its exclusion list, so the complete consumed schema and upstream producer contract remain unknown.
- R_TAB3_PHONETICS [undetermined]: Missing sentence-level df_sent_phonetics.parquet used by Tab3_InnerWorkings.py, joined by callid, parid and sentid. Consumed fields: callid, parid, sentid, gender, mean_pitch, sd_pitch, min_pitch, max_pitch, mean_intensity, min_intensity, max_intensity, num_pulses, num_periods, mean_period, sd_period, frac_unvoiced, num_voicebreaks, degree_voicebreaks, jitter_local, jitter_local_abs, jitter_rap, jitter_ppq5, jitter_ddp, shimmer_local, shimmer_local_db, shimmer_apq3, shimmer_apq5, shimmer_dda, mean_autocorrel, mean_nhr and mean_hnr. The producer and period coverage are not supplied.
- R_SPEAKER_MASTER [undetermined]: Missing tic_callid_speaker_master.parquet used by Tab3_InnerWorkings.py. Consumed fields: callid, tic, call_year_month, call_year_quarter, fyearq, fqtr and sic; callid is deduplicated and the calendar/fiscal fields support analysis keys. No producer or coverage evidence is packaged.
- R_FINVOC_SENTENCE [undetermined]: Missing FinVoc2Wav_sentid.parquet used by Tab3_InnerWorkings.py. Consumed fields: callid, parid, sentid, marker, FULLNAME_clean_final, vocal_tone, vmp_tone_praat and pyaudio_praat; the join uses callid/parid/sentid and keeps presentation/Q&A markers. Its producer is not supplied.
- R_CRSP_CAR_WINDOWS [undetermined]: Missing prepared CRSP_CAR_DAILY_FULL_WINDOWS.parquet consumed by create_sample.py. Required fields are callid, car_0_1, car_2_61 and t-1; the script also carries every source column whose name contains the case-sensitive substring 'car'. Local raw CRSP.DSF and CRSP.DSF_V2 are catalog candidates, but neither schema has these event-window fields or callid, and no supplied code maps calls to securities or constructs the prepared windows.
- R_IBES_SUMMARY [undetermined]: Missing prepared EarningsSurprises_IBES_Summary_inclREVISION.parquet, which create_sample.py merges by callid and passes through. The source explicitly consumes callid but retains the whole table, so its complete schema and revision-selection rule are not specified in the package. Local raw IBES.STATSUM_EPSUS is a catalog candidate but lacks callid; it is not a verified route to the prepared panel.
- R_IBES_EARNINGS_CHANGES [undetermined]: Missing prepared IBES_EarningsChanges_q.parquet. Consumed fields are callid, gvkey, PENDS_q0, PENDS_q1, PENDS_q2, PENDS_q3, PENDS_q4, earn_chg_drift_q1, earn_chg_drift_q2, earn_chg_drift_q3, earn_chg_drift_q4, PRC_SPLITADJ_q1, PRC_SPLITADJ_q2, PRC_SPLITADJ_q3, PRC_SPLITADJ_q4 and ibes_count_drift_q1. Catalogued raw IBES detail/actual tables lack callid and these prepared drift/adjusted-price fields; the call-to-ticker/gvkey mapping, revision selection and quarter construction are not supplied.
- R_F2V_CALL [undetermined]: Missing author-prepared FinVoc2Wav_neu_emo_call.parquet merged by callid in create_sample.py. Consumed fields: callid, vocal_tone_sc_neu_m_pr, vocal_tone_sc_neu_m, vocal_tone_sc_emo_m_pr and vocal_tone_sc_emo_m. No producer or call-level schema is supplied.
- R_PRAAT_PARAGRAPH [undetermined]: Missing paragraph-level df_par_phonetics.parquet consumed by create_sample.py; it is distinct from the sentence-level Table 3 panel. Consumed fields: callid, parid, marker, FULLNAME_clean_final, mean_pitch, sd_pitch, min_pitch, max_pitch, mean_intensity, min_intensity, max_intensity, num_pulses, num_periods, mean_period, sd_period, frac_unvoiced, num_voicebreaks, degree_voicebreaks, jitter_local, jitter_local_abs, jitter_rap, jitter_ppq5, jitter_ddp, shimmer_local, shimmer_local_db, shimmer_apq3, shimmer_apq5, shimmer_dda, mean_autocorrel, mean_nhr and mean_hnr. The supplied code standardizes and aggregates these variables, but the input producer is not supplied.
- R_FF5_SORTS [undetermined]: Missing REPLICATION_2_FF5_VocalToneSorts_FF5.parquet read by both market-outcome script paths. Exact consumed fields: datetime_crsp, vocal_tone_roll_sc_m_q1, vocal_tone_roll_sc_m_q2, vocal_tone_roll_sc_m_q3, vocal_tone_roll_sc_m_q4, vocal_tone_roll_sc_m_q5, vmp_tone_praat_roll_sc_m_q1, vmp_tone_praat_roll_sc_m_q2, vmp_tone_praat_roll_sc_m_q3, vmp_tone_praat_roll_sc_m_q4, vmp_tone_praat_roll_sc_m_q5, pyaudio_praat_roll_sc_m_q1, pyaudio_praat_roll_sc_m_q2, pyaudio_praat_roll_sc_m_q3, pyaudio_praat_roll_sc_m_q4, pyaudio_praat_roll_sc_m_q5, Mkt-RF, SMB, HML, RMW, CMA, RF. The supplied programs contain no producer for this study-specific tone-sorted portfolio panel.
- S_LINEARMODELS [unverified]: The market-outcome code uses PanelOLS. Distribution metadata did not find linearmodels, but no import/function test was run under the bounded metadata-only audit; confirm the actual PanelOLS entry point before treating installation as necessary or complete.

## Review notes

- Source reading used the saved byte-first masking workflow. Its first fixture run exposed an off-by-one block-comment range before any author source was displayed; the original helper and result were preserved, the corrected v2 helper passed the saved fixture set, and only the v2 manifest is cited. The raw code_execution_log.log was skipped as opaque and never opened or displayed. Normal withheld markers were handled as masking, not treated as an incident. Process-only incident records E_PROCESS_READER_V1 and E_PROCESS_FIELD_V1 are preserved as unused evidence rows; neither ID appears in any evidence_ids array. Their original helper sources are preserved in probes, while scientific claims cite only the corrected v2 screen and comparison.
- The first source-field comparison helper wrote intermediate artifacts but exited while serializing its compact summary because the summary used PosixPath dictionary keys. The failed helper and outputs were preserved and are not cited; the corrected v2 comparison and its eight selected full native schemas are the cited records.
- Bounded checks were limited to the existing packaged identifier metadata, one row from COMP.FUNDQ, the typed environment snapshot, frozen catalog lookups, and Python distribution metadata. No source row values were retained. Catalog and one-row metadata do not establish historical coverage, author extract identity or population completeness.
- The verified COMP.FUNDQ route establishes a readable local quarterly product with the exact native fields needed by the CSV extraction stage; the required date coverage remains unverified. No author code, SAS startup, model fit, regression, installation, download, authentication test or external request was performed.
- Only full_pipeline is assessed because the packaged Identifiers.parquet is an identifier subset rather than a prepared analysis panel. Tab2_ModelEval.py and Tab3_InnerWorkings.py are independent stages; create_sample.py produces CALL_LEVEL_SAMPLE.parquet for the market-outcome scripts; the two market-outcome source files have the same frozen content hash and should be run once.
- The first complete Draft 2020-12 validation helper attempt failed during artifact hash verification because the preserved v1 field-comparison failure row had a one-character SHA-256 transcription error. The exact submitted input, helper source, combined diagnostic and value-only hash-classifier capture are preserved. The corrected digest now matches the actual JSON object; process-only evidence rows E_PROCESS_READER_V1, E_PROCESS_FIELD_V1, E_PROCESS_DRAFT_VALIDATOR_V2, E_PROCESS_HASH_CAPTURE_V1 and E_PROCESS_VALIDATOR_INPUT_V2 are deliberately unused in every evidence_ids list.
- After correcting the process-only digest, the actual Draft202012Validator returned zero errors for the frozen output.schema.json. The saved v3 validation capture also checked nested typed IDs and dependency targets, every evidence_ids array, action coverage, exact source-consumed fields, JSON-object artifact shape and artifact hashes. This audit did not execute the author programs or verify analysis results.
