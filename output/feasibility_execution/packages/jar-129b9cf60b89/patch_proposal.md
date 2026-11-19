# Patch proposal: jar-129b9cf60b89

Does Foreign Investors’ Information Access Vary with Geopolitical Tensions? Evidence from Corporate Conference Calls

DOI: 10.1111/1475-679X.70009

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied workflow from raw transcript, GDELT, UN-vote and China filing/press sources through Python/SAS/Stata preparation and all listed analysis drivers. The package includes substantive preparation code, but several exact panels, route contracts and specific handoffs remain unresolved.

Entry points: `code, identifiers, and log files/analysis_code/Figure 1.do`, `code, identifiers, and log files/analysis_code/Figure OA4.do`, `code, identifiers, and log files/analysis_code/Table 1.do`, `code, identifiers, and log files/analysis_code/Table 10.do`, `code, identifiers, and log files/analysis_code/Table 11.do`, `code, identifiers, and log files/analysis_code/Table 2.do`, `code, identifiers, and log files/analysis_code/Table 3.do`, `code, identifiers, and log files/analysis_code/Table 4.do`, `code, identifiers, and log files/analysis_code/Table 5.do`, `code, identifiers, and log files/analysis_code/Table 6.do`, `code, identifiers, and log files/analysis_code/Table 7.do`, `code, identifiers, and log files/analysis_code/Table 8.do`, `code, identifiers, and log files/analysis_code/Table 9.do`, `code, identifiers, and log files/analysis_code/Table OA1.do`, `code, identifiers, and log files/analysis_code/Table OA10.do`, `code, identifiers, and log files/analysis_code/Table OA11.do`, `code, identifiers, and log files/analysis_code/Table OA2.do`, `code, identifiers, and log files/analysis_code/Table OA3.do`, `code, identifiers, and log files/analysis_code/Table OA8.do`, `code, identifiers, and log files/data_cleaning_code/China analysis/PD.py`, `code, identifiers, and log files/data_cleaning_code/China analysis/WhiteHouse.ipynb`, `code, identifiers, and log files/data_cleaning_code/China analysis/cfm.py`, `code, identifiers, and log files/data_cleaning_code/China analysis/match_abfile.do`, `code, identifiers, and log files/data_cleaning_code/China analysis/polWord.ipynb`, `code, identifiers, and log files/data_cleaning_code/China analysis/twitter.py`, `code, identifiers, and log files/data_cleaning_code/Global analysis/GDELT_download.txt`, `code, identifiers, and log files/data_cleaning_code/Global analysis/callPart.ipynb`, `code, identifiers, and log files/data_cleaning_code/Global analysis/call_part_all.sas`, `code, identifiers, and log files/data_cleaning_code/Global analysis/gdelt.sas`, `code, identifiers, and log files/data_cleaning_code/Global analysis/parseCall.ipynb`, `code, identifiers, and log files/data_cleaning_code/Global analysis/parseSpeech.ipynb`, `code, identifiers, and log files/data_cleaning_code/Global analysis/speechMeasures.ipynb`, `code, identifiers, and log files/data_cleaning_code/Global analysis/un_vote.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70009 - Does-Foreign-Investors-Information-Access-Vary-with-Geopolitical-Tensions-Evidence-from-Corporate-Conference-C/lwy-datasheet-code-identifiers-log-files.zip",
      "sha256": "77d936a6390fa0629ed440ff82ca100ca18c60cb53a04b6c1c022b4b4a79194a"
    },
    {
      "path": "JAR-Volume 64/Issue 1/70009 - Does-Foreign-Investors-Information-Access-Vary-with-Geopolitical-Tensions-Evidence-from-Corporate-Conference-C/lwy-online-appendix.pdf",
      "sha256": "21414b0797770a2da850513e4491a7474984f85e7989ee72edfaffaaa042bc90"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "e525fc2366c74a3ad589db3ddd34bf6c0bde5d31292f232364e1389a8d814b2b"
}
```

## Proposed actions

### A_CALLPART_PATH: In a working copy, change the callPart notebook writer to join the configured root and relative output path. Configure the SAS import to resolve to that same output after the approved data root is chosen.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_CALLPART_PATH
Evidence: E_CALLPART_WRITE, E_SAS_PARTICIPANT_EXPORT

**Proposed edit:** `code, identifiers, and log files/data_cleaning_code/Global analysis/callPart.ipynb:76–76 (cell 729ad20c)`
Source SHA-256: `da3c1a5d359f5e0076955e11353820a4d83f7c407e12f688f7b169aab342fd04`

Evaluate the configured path_dropbox root and write to the DTA location expected by the next SAS stage; preserve all fields and transformations.

Current text:
```
calls_final.to_stata("path_dropbox + \Conference Call Transcript\calls_part_full_0227.dta", version=118, write_index = False)
```

Proposed replacement:
```
calls_final.to_stata(os.path.join(path_dropbox, "Conference Call Transcript", "calls_part_full_0227.dta"), version=118, write_index = False)
```

Preparation / proposed procedure:

1. Apply the exact one-line cell edit below in a working copy of callPart.ipynb.
2. Set call_part_all.sas's import location to the same staged calls_part_full_0227.dta path; retain the event/participant field transformations.

Validation to perform later:

- Before ordinary execution, confirm the Python output path and SAS import path resolve to the same file.
- After the authorized workflow is run, compare the DTA native columns with the SAS retained-field list; do not run either program during this static assessment.

### A_RESTORE_PANEL_PIPELINES: Recover the omitted sample-building source or exact author-prepared inputs for the named analysis panels. Keep separate filenames and contracts. Credit Table 10.do as the sample_abshare producer, while resolving its sample_20240217 and auxiliary input chain.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_GLOBAL_PANEL, R_IV_PANEL, R_QA_PANEL, R_PRIVATE_MEETINGS_RAW, R_PM_PANEL_TABLE7, R_PM_PANEL_COUNTRY_20240222, R_PM_PANEL_20240912, R_PM_PANEL_20240217, R_T10_BASE_SAMPLE, R_T10_FIGURE_CHARACTERISTICS, R_T10_CSMAR_COMPANY, R_T10_INSTOWN_PCT, R_T10_GJD, R_T10_QFII, R_SUPPLY_PANEL, I_MISSING_PANEL_COMPILERS
Evidence: E_README_GLOBAL_CLEAN, E_README_CHINA_CLEAN, E_README_ABSHARE_CLEAN, E_PACKAGE_INVENTORY, E_T10_ABSHARE_PRODUCER, E_T10_BASE_PANEL, E_TABLE4_IV_PANEL, E_TABLE6_QA_PANEL, E_TABLE7_PRIVATE_A, E_TABLE8_SUPPLY_FIELDS

Preparation / proposed procedure:

1. Request the Clean – Global Sample and Clean – AB Share Private Meeting source stages or their exact author-approved inputs.
2. Confirm fields, identifiers, source period and pre-sample history separately for sample_gdelt_qtr1.dta, sample_qa.dta, sample_iv.dta, private_meetings.dta, all four private-meeting panels and sample_supply.dta.
3. For AB-share discount, recover sample_20240217.dta and Table 10's named auxiliary files; do not replace the supplied sample_abshare producer or infer a missing file alias.

Validation to perform later:

- Compare recovered files' native fields and identifiers against each quoted consumer contract.
- Confirm producer order and period/history before ordinary analysis; preserve all sample restrictions and estimators.

### A_STAGE_GLOBAL_INPUTS: Stage the documented transcript, GDELT, mapping, UN-vote and TPU products in the exact locations expected by the supplied code. Public source names do not establish local coverage; obtain commercial or manually collected files through the user's authorized channels.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_TRANSCRIPT_XML, R_COUNTRY_CODE_WORKBOOK, R_INSTITUTION_NONUS_WORKBOOK, R_INSTITUTION_HEADQUARTERS_WORKBOOK, R_GDELT_GLOBAL_MONTHLY, R_GDELT_CHINA_DAILY, R_GDELT_REGION_MAP, R_UNVOTE_SOURCE, R_UNVOTE_COUNTRY_MAP, R_TRADE_POLICY_INPUT, SW_BIGQUERY_ACCESS
Evidence: E_DS_REFINITIV, E_DS_GDELT, E_DS_UN, E_DS_CHINA, E_PARSE_XML_YEARS, E_GDELT_QUERY_GLOBAL, E_GDELT_QUERY_PERIOD, E_UNVOTE_INPUT_RESOLUTION, E_OA10_TPU_INPUT

Preparation / proposed procedure:

1. Stage transcript XML for 2001–2023 and the three participant mapping workbooks with the quoted native field names.
2. For GDELT, export the supplied global monthly and China daily SQL results as gdelt1.csv and CHN_daily.csv; do not query BigQuery during this assessment.
3. Stage the region-classification workbook, UN workbook and country map, then the exact ReportKey0818_TPU_robust.dta source for 2015–2017.

Validation to perform later:

- Use a bounded metadata check at the authorized staged paths to confirm exact native fields and date bounds.
- Do not treat a one-row probe as population or history coverage; retain the required 2000–2023 GDELT and 2001–2023 transcript windows.

### A_FIX_GDELT_OA4: Prepare a working-copy SAS-to-Stata handoff from the supplied quarterly gdelt_qtr product to the visible Figure OA4 input gdelt_qtr0216.dta. The producer and consumer use the same actor-country, year/quarter and tension contract; only output-name, location and format staging remains.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_GDELT_OA4_NAME
Evidence: E_GDELT_SAS_QTR_OUTPUT, E_GDELT_SAS_QTR_TENSION_MEASURE, E_GDELT_SAS_QTR_GROUP, E_OA4_PANEL_INPUT, E_OA4_ACTOR1_CONSUMER, E_OA4_ACTOR2_CONSUMER, E_OA4_QUARTER_CONSUMER, E_OA4_TENSION_CONSUMER

Preparation / proposed procedure:

1. Stage the supplied gdelt_qtr output in the working copy as gdelt_qtr0216.dta in a Stata-readable format; preserve the masked source destination without reconstructing or repointing it.
2. Carry Actor1CountryCode, Actor2CountryCode, year, quarter and tension through the handoff.
3. Run Figure OA4 after the quarterly producer and ordinary staging step.

Validation to perform later:

- Check the staged fields and expected year/quarter period in the ordinary Figure OA4 workflow.
- Keep source selection, population and tension construction unchanged.

### A_EXPORT_UNVOTE_HANDOFF: Resolve how vote_dif_final becomes the vote_dif field in sample_iv.dta. The visible SAS export is vote_crimea, so provide an author-approved durable handoff or compiler for the analysis panel.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_UNVOTE_HANDOFF, R_IV_PANEL
Evidence: E_UNVOTE_PAIR_OUTPUT, E_UNVOTE_ONLY_EXPORT, E_TABLE4_IV_PANEL, E_TABLE4_VOTE_WINDOW

Preparation / proposed procedure:

1. Ask for the exact supported export/merge step for vote_dif_final and the sample_iv panel.
2. Retain the UN source fields, distinct country pairs and Table 4's 2014–2016 window.

Validation to perform later:

- Confirm the produced field is vote_dif with country-pair/year keys before Table 4.
- Do not substitute vote_crimea or manufacture a vote-difference series.

### A_RECONCILE_CSMAR_NAME: Confirm whether Table 10 should merge the workbook it saved as csmar_company_file.dta or a distinct csmar_company_file_cn dataset. Table OA10 uses the former; preserve separate products if the _cn file is intentional.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_CSMAR_FILE_NAME, R_T10_BASE_SAMPLE, R_T10_FIGURE_CHARACTERISTICS, R_T10_CSMAR_COMPANY, R_T10_INSTOWN_PCT, R_T10_GJD, R_T10_QFII
Evidence: E_T10_CSMAR_FIELDS, E_T10_CSMAR_SAVE, E_T10_CSMAR_MERGE, E_OA10_CSMAR_MERGE

Preparation / proposed procedure:

1. Obtain the intended CSMAR mapping file and its stkcd/industry schema.
2. Only after matching the data product, update the working copy's merge name or stage the separate _cn producer.

Validation to perform later:

- Confirm merge key and retained industry fields against the actual workbook before changing the source.

### A_CONFIRM_TABLE1_NCALL: Check the recovered sample_gdelt_qtr1.dta schema for ncall1 and confirm whether the source's newly created ncall11 is an intentional separate field or an output-name mismatch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_TABLE1_NCALL, R_GLOBAL_PANEL
Evidence: E_TABLE1_NCALL_CREATE, E_TABLE1_NCALL_KEEP, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the exact prepared panel field definition and source compiler.
2. If ncall1 is not present, obtain the intended author correction before editing the keep statement.

Validation to perform later:

- Verify the table's ncall measure against the recovered input and construction code; do not rename from inference.

### A_CONFIGURE_MATCH_ABFILE_ROOT: In a working copy, replace the hardcoded Windows data root with the user-approved staged data directory containing the filing inputs and outputs.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_MATCH_ABFILE_ROOT
Evidence: E_MATCH_ABFILE_ROOT, E_MATCH_ABFILE_INPUT, E_MATCH_ABLIST

Preparation / proposed procedure:

1. Choose a project-local or explicitly configured data directory only after the required files are staged.
2. Set the global wd value in match_abfile.do to that exact directory; leave relative file names and matching logic unchanged.

Validation to perform later:

- Before running, resolve all relative reads/writes under the configured directory and confirm no output targets a source/cache path.

### A_RECOVER_CHINA_INPUTS: Recover the exact Cninfo/Factiva/MFA/White House/Twitter inputs, local sentiment resources and active handoffs that the China sources need. Preserve each source product and its own output; do not map the packaged stkcd list to ab_list or activate commented writers without author confirmation.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_CHINA_FILING_ALL, R_CHINA_AB_LIST, R_POLWORD_PDF_CORPUS, R_FACTIVA_PD, R_MFA_PICKLE_1, R_MFA_PICKLE_2, R_MFA_PICKLE_0311, R_MFA_TEXT874, R_WHITEHOUSE_WORKBOOK, R_TRUMP_TWEETS_CSV, R_LM_NEGATIVE_CSV, R_LM_POSITIVE_CSV, R_NLTK_OPINION_LEXICON, R_NLTK_ENGLISH_STOPWORDS, R_STANFORD_NER_CLASSIFIER_JAR, R_STANFORD_NER_MODEL, I_AB_LIST_CONTRACT, I_CFM_INTERMEDIATES, I_TWITTER_WSJ_HANDOFF
Evidence: E_DS_CHINA, E_MATCH_ABLIST, E_POLWORD_PDF_SCAN, E_CFM_TEXT_INPUT, E_CFM_UNPRODUCED_PICKLE, E_WHITEHOUSE_INPUT, E_TWITTER_WRITER_BLOCK, E_WSJ_CHECKPOINT_WRITER_BLOCK, E_SENTIMENT_LEXICON_NLTK, E_SENTIMENT_LEXICON_LM_NEG, E_SENTIMENT_LEXICON_LM_POS

Preparation / proposed procedure:

1. Obtain the author-approved filing_all/ab_list inputs and the exact PDF corpus; then run the supplied polWord producer to stage polWordCount.xlsx and its Stata handoff after the corpus and Python dependencies are staged.
2. Recover the two path-screened MFA pickles, embassy_eng0311.pkl and text874.txt with provenance for the press-briefing branch.
3. Obtain the source files and explicit output handoff for Factiva, White House and Twitter sentiment; confirm whether a maintained WSJ producer exists.
4. Stage Neg_LM.csv, Pos_LM.csv and required NLTK opinion_lexicon/stopwords resources.

Validation to perform later:

- Check each product's native keys/periods and generated output columns before merging into the AB-share panel.
- Confirm that active writers produce the exact sentiment fields consumed by Table 10; do not treat checkpoint code as an entry point.

### A_VERIFY_SOFTWARE: Verify the author-required runtimes, user-written Stata commands, Python packages, NLTK resources, Java/Stanford NER files and BigQuery setup in the intended environment. No installs or external authentication checks were performed here.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_PYTHON_STACK, SW_REGHDFE, SW_FTOOLS, SW_WINSOR2, SW_OUTREG2, SW_ASDOC, SW_RANGESTAT, SW_XTSCC, SW_IVREGHDFE, SW_SAS_RUNTIME, SW_BIGQUERY_ACCESS, SW_STANFORD_NER, R_STANFORD_NER_CLASSIFIER_JAR, R_STANFORD_NER_MODEL, R_LM_NEGATIVE_CSV, R_LM_POSITIVE_CSV, R_NLTK_OPINION_LEXICON, R_NLTK_ENGLISH_STOPWORDS, I_STATA_ADOS
Evidence: E_ENVIRONMENT_PROBE, E_STANFORD_NER_USE, E_SENTIMENT_LEXICON_NLTK, E_GDELT_QUERY_GLOBAL, E_TABLE8_SUPPLY_FIELDS

Preparation / proposed procedure:

1. Check Python imports used by the supplied code and record package versions; confirm NLTK corpora and Stanford NER JAR/model paths.
2. Check winsor2 and outreg2; verify asdoc, rangestat, xtscc and ivreghdfe; retain the registered reghdfe 6.12.3 and ftools 2.49.1 proofs.
3. Confirm the intended SAS installation/library configuration and BigQuery access through the user's normal authorized process.

Validation to perform later:

- Record versions and exact paths before the first ordinary run.
- Install or download nothing until a separate user-approved environment plan is in place.

### A_RUN_ORDER: After access, source closure, paths and software are resolved, execute the supplied workflow in producer order and then the analysis drivers. This is a future run plan; no author source was executed in this assessment.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_MISSING_PANEL_COMPILERS, I_CALLPART_PATH, I_GDELT_OA4_NAME, I_UNVOTE_HANDOFF
Evidence: E_README_GLOBAL_CLEAN, E_PARSE_TRANSCRIPT_OUTPUT, E_CALLPART_WRITE, E_SAS_PARTICIPANT_EXPORT, E_GDELT_QUERY_GLOBAL, E_GDELT_SAS_QTR_OUTPUT, E_UNVOTE_PAIR_OUTPUT, E_README_CHINA_CLEAN, E_README_ANALYSIS, E_GDELT_SAS_QTR_TENSION_MEASURE, E_GDELT_SAS_QTR_GROUP, E_OA4_PANEL_INPUT, E_OA4_ACTOR1_CONSUMER, E_OA4_ACTOR2_CONSUMER, E_OA4_QUARTER_CONSUMER, E_OA4_TENSION_CONSUMER

Preparation / proposed procedure:

1. Parse transcript XML to transcript.pkl and conversation.pkl; build participant-country handoff before call_part_all.sas.
2. Stage GDELT SQL outputs before gdelt.sas; after the quarterly producer, align the same generated GDELT product for Figure OA4 in a working copy. Stage UN vote inputs and a durable vote_dif handoff before sample_iv.
3. Run China filing/word/sentiment preparation only after inputs and resources are resolved; restore the missing panel compilation stages.
4. Run the supplied table/figure drivers after each prepared panel's producer and field contract are confirmed.

Validation to perform later:

- Record producer output locations and native fields at each handoff.
- Keep sample definitions, time windows, estimators and required analyses unchanged.


## Remaining issues and prerequisites

- I_MISSING_PANEL_COMPILERS [unresolved; full_pipeline]: README names Clean – Global Sample, Clean – AB Share Private Meeting and Clean – AB Share Discount stages, but the package has no executable sources under those names and no sample_gdelt_qtr1/sample_qa/sample_iv/private-meeting/sample_supply panels. Table 10.do is a supplied producer for sample_abshare.dta at line 415; its sample_20240217 and auxiliary inputs remain unresolved, so it is credited as partial source code rather than called absent.
- I_CALLPART_PATH [preparation; full_pipeline]: callPart.ipynb passes a quoted expression containing path_dropbox plus the relative output name, so Python treats the root as literal text. The SAS participant stage consumes this DTA handoff.
- I_TABLE1_NCALL [unresolved; full_pipeline]: Table 1 creates ncall11 from eventId but later retains ncall1. The missing sample_gdelt_qtr1 producer prevents confirming whether ncall1 is already in the input; do not rename it without that schema.
- I_GDELT_OA4_NAME [preparation; full_pipeline]: The supplied gdelt.sas quarterly construction and Figure OA4 consumer use the same actor-country/year/quarter fields and tension measure. The producer name gdelt_qtr differs from the consumer handoff name gdelt_qtr0216.dta; align the output name and SAS-to-Stata format in a working copy, then validate ordinary fields and period. The supplied consumer does not define a distinct OA4 population or tension construction.
- I_UNVOTE_HANDOFF [unresolved; full_pipeline]: un_vote.sas constructs vote_dif_final but the visible export is vote_crimea; Table 4 consumes vote_dif inside sample_iv.dta. The package does not establish the durable vote_dif/sample_iv handoff.
- I_CSMAR_FILE_NAME [unresolved; full_pipeline]: Table 10 saves the imported CSMAR workbook as csmar_company_file.dta and then merges csmar_company_file_cn; Table OA10 instead merges csmar_company_file. Confirm the intended file and schema before changing the merge name or supplying a distinct _cn producer.
- I_AB_LIST_CONTRACT [unresolved; full_pipeline]: match_abfile.do merges a separate ab_list on code_b. The packaged China identifier probe reports native field stkcd, and no supplied source maps that product or key to ab_list/code_b.
- I_CFM_INTERMEDIATES [unresolved; full_pipeline]: cfm.py reads embassy_eng0311.pkl and text874.txt without a visible producer for either in the package. The earlier embassy pickle inputs are also not packaged; no complete press-briefing source-to-output route is established.
- I_TWITTER_WSJ_HANDOFF [unresolved; full_pipeline]: twitter.py calculates tweet sentiment but its visible CSV writer is inside a triple-quoted block. The only WSJ code is an .ipynb_checkpoints file with its writer also commented; Table 10's sentiment fields therefore lack an established active handoff in the supplied preparation sources.
- I_MATCH_ABFILE_ROOT [preparation; full_pipeline]: match_abfile.do sets its data root to a hardcoded Windows D: path. This Linux workspace has no matching configured path in the package, so the working-copy root must be set before its relative reads/writes.
- I_STATA_ADOS [preparation; full_pipeline]: The existing Stata probe reports winsor2 and outreg2 not found in checked adopaths; analysis sources call them. Other user-written commands used by the workflow were not all checked.
- R_TRANSCRIPT_XML [undetermined]: Raw conference-call XML is required by both supplied parsers. parseCall reads per-year folders for 2001–2023 and extracts event identifiers, event metadata, CUSIP/SEDOL/ISIN and participants; parseSpeech extracts eventId, speaker, speechId and content. The derived transcript.pkl and conversation.pkl are generated by supplied code, but raw XML is not in the package.
- R_GLOBAL_PANEL [undetermined]: The analysis drivers require sample_gdelt_qtr1.dta. Visible consumers use part_ctry_ratio, tension_h_p/tension_p_h, CountryRisk, CountrySentiment, epu, GPRC, prisk, nprisk, lngdp_d/lngdp_o, lndist, lntrade, firm and country identifiers, yq, size, mtb, lev, roa, invest, rd, cash and foreign_own; Table 1 also consumes isin/eventId/firm_ctry/part_ctry and ncall1. README names a Clean – Global Sample stage, but no matching producer or prepared panel is in the package. The datasheet identifies control-source families, but the absent compiler prevents a source-to-field and history matrix for them.
- R_UNVOTE_SOURCE [undetermined]: un_vote.sas imports the Resolution Summary and Voting Details sheets from the UN voting workbook. It consumes Vote, Country, ID and Vote_date to construct pairwise vote differences and yearly vote_tension/vote_count.
- R_UNVOTE_COUNTRY_MAP [undetermined]: The UN-voting workflow also imports country_map.xlsx and joins Country to Alpha_2_code and Alpha_3_code before constructing pairwise vote_dif.
- R_IV_PANEL [undetermined]: Table 4 consumes sample_iv.dta and uses vote_dif in 2014–2016 with part_ctry_ratio, tension_h_p, country/firm controls and firm-country-quarter identifiers. No prepared panel producer is supplied. un_vote.sas creates vote_dif_final but its visible export writes vote_crimea, leaving the Table 4 handoff unresolved.
- R_QA_PANEL [undetermined]: Table 6 consumes sample_qa.dta with n_qa, len_a and question/answer textual measures. speechMeasures.ipynb parses conversation.pkl, creates qa_pairs.pkl and qa_pairs.dta, and produces ner_results_q.csv/ner_results_a.csv; the supplied code does not identify a producer for the exact sample_qa.dta consumed by Table 6.
- R_SUPPLY_PANEL [undetermined]: Tables 8, 9 and OA8 and Table OA10 consume sample_supply.dta. Visible consumers use stkcd, type, wordCount, relative_size, ratio_pol, stop_b, tension_CN_Others and firm/country controls. match_abfile.do produces matched filing intermediates, but no supplied source produces the exact sample_supply.dta panel.
- R_TRADE_POLICY_INPUT [undetermined]: Table OA10 reads ReportKey0818_TPU_robust.dta, expects code/year/anfre_tpu/totcharlen, constructs a mean TPU measure and limits the source to 2015–2017. No copy or field probe is present.
- R_COUNTRY_CODE_WORKBOOK [undetermined]: The participant-construction country-code workbook is a separate required input. callPart joins ctry to native `Alpha-2 code`; the SAS stage also retains Alpha_2_code/Alpha_3_code values.
- R_INSTITUTION_NONUS_WORKBOOK [undetermined]: The non-US institution-country workbook is independently required by participant construction.
- R_INSTITUTION_HEADQUARTERS_WORKBOOK [undetermined]: The remaining institution-headquarters workbook is independently required by participant construction.
- R_GDELT_GLOBAL_MONTHLY [public_acquisition_required]: The global monthly GDELT query result is a distinct raw input to gdelt.sas; it is staged as gdelt1.csv before quarterly aggregation.
- R_GDELT_CHINA_DAILY [public_acquisition_required]: The China-involving daily GDELT query result is a separate raw input to gdelt.sas and is staged as CHN_daily.csv.
- R_GDELT_REGION_MAP [undetermined]: gdelt.sas imports the workbook sheet Distinction as of May 2022 and joins its ISO_alpha3_Code to Actor2CountryCode or Actor1CountryCode to classify developed/developing regions.
- R_PRIVATE_MEETINGS_RAW [undetermined]: The separate private_meetings.dta input consumed by Table OA10 is distinct from the four prepared analysis panels.
- R_PM_PANEL_TABLE7 [undetermined]: Table 7 consumes sample_private_meeting.dta as its own prepared analysis panel.
- R_PM_PANEL_COUNTRY_20240222 [undetermined]: Table 7 consumes sample_private_meeting_by_country_20240222.dta as a distinct by-country panel.
- R_PM_PANEL_20240912 [undetermined]: The 20240912 private-meeting panel is consumed by Table 7, Table 11 and OA11 and is not an alias for the other variants.
- R_PM_PANEL_20240217 [undetermined]: Table OA10 consumes sample_private_meeting_20240217.dta as a distinct prepared panel.
- R_T10_BASE_SAMPLE [undetermined]: Table 10 starts from sample_20240217.dta; its producer and complete field/period contract are not in the supplied package.
- R_T10_FIGURE_CHARACTERISTICS [undetermined]: Table 10 separately merges the Figure_Characteristics quarterly country-risk input; its masked path and source contract remain unresolved.
- R_T10_CSMAR_COMPANY [undetermined]: Table 10 imports CSMAR_Company_File.xlsx, retains the listed security/industry columns, saves csmar_company_file.dta and later merges csmar_company_file_cn; the alias mismatch is an issue.
- R_T10_INSTOWN_PCT [undetermined]: Table 10 separately merges instown_pct.dta on stkcd/year/qtr and uses instown_pct.
- R_T10_GJD [undetermined]: Table 10 separately merges gjd.dta on stkcd/year and uses gjd.
- R_T10_QFII [undetermined]: Table 10 separately merges qfii.dta on stkcd/year/qtr and uses qfii and nqfii.
- R_CHINA_FILING_ALL [undetermined]: The filing branch reads the separate filing_all product before building cleaned filing intermediates.
- R_CHINA_AB_LIST [undetermined]: match_abfile.do separately merges ab_list on code_b. The packaged China identifier file has only stkcd and is not demonstrated to be an alias or compatible mapping.
- R_POLWORD_PDF_CORPUS [undetermined]: The supplied polWord notebook scans a configured tree for PDF documents; the exact document collection and dates are not specified by the package.
- R_FACTIVA_PD [undetermined]: The People's Daily sentiment branch reads its distinct Factiva source file before producing sentiment_renmin0712.csv.
- R_MFA_PICKLE_1 [undetermined]: The CFM branch reads a first, distinct path-screened MFA press-briefing pickle. Its exact path is withheld by safe screening.
- R_MFA_PICKLE_2 [undetermined]: The CFM branch reads a second, distinct path-screened MFA press-briefing pickle. Its exact path is withheld by safe screening.
- R_MFA_PICKLE_0311 [undetermined]: cfm.py reads embassy_eng0311.pkl, with no matching active producer in the package.
- R_MFA_TEXT874 [undetermined]: cfm.py separately reads text874.txt as a manual press-text correction input.
- R_WHITEHOUSE_WORKBOOK [undetermined]: The White House sentiment notebook reads a distinct briefing workbook and writes a sentiment CSV.
- R_TRUMP_TWEETS_CSV [undetermined]: The Twitter sentiment source reads a distinct CSV with date/text fields; the active writer for the downstream sentiment output is commented out.
- R_LM_NEGATIVE_CSV [undetermined]: sentiment.py independently reads Neg_LM.csv as its Loughran–McDonald negative-word source.
- R_LM_POSITIVE_CSV [undetermined]: sentiment.py independently reads Pos_LM.csv as its Loughran–McDonald positive-word source.
- R_NLTK_OPINION_LEXICON [undetermined]: sentiment.py loads the NLTK opinion_lexicon positive and negative lists as a separate resource.
- R_NLTK_ENGLISH_STOPWORDS [undetermined]: The sentiment helper separately calls stopwords.words('english') for English text preprocessing.
- R_STANFORD_NER_CLASSIFIER_JAR [undetermined]: speechMeasures instantiates StanfordNERTagger with a classifier JAR at a path screened from the source view.
- R_STANFORD_NER_MODEL [undetermined]: speechMeasures instantiates StanfordNERTagger with a pretrained model at a separate path screened from the source view.
- SW_PYTHON_STACK [unverified]: The supplied code uses pandas, numpy, lxml, BeautifulSoup, nltk and PyPDF2. The environment probe did not verify these third-party package versions or imports; NLTK corpora and Stanford NER model files are tracked as separate data requirements.
- SW_WINSOR2 [preparation_required]: The supplied Table 10 code calls winsor2; the registered probe did not find it in checked adopaths.
- SW_OUTREG2 [preparation_required]: The supplied Table 3 code calls outreg2; the registered probe did not find it in checked adopaths.
- SW_ASDOC [unverified]: The supplied Table 10 code calls asdoc; the registered probe did not check this command.
- SW_RANGESTAT [unverified]: The supplied Table 10 code calls rangestat; the registered probe did not check this command.
- SW_XTSCC [unverified]: The supplied Table 10 code calls xtscc; the registered probe did not check this command.
- SW_IVREGHDFE [unverified]: The supplied Table 4 code calls ivreghdfe; the registered probe did not check this command.
- SW_SAS_RUNTIME [unverified]: SAS sources are present, but the registered environment metadata leaves SAS unverified. No SAS executable, startup, autoexec or PROC run was performed for this assessment.
- SW_BIGQUERY_ACCESS [unverified]: The SQL names gdelt-bq.full.events and its field contract, but no query, authentication check or API test was performed.
- SW_STANFORD_NER [unverified]: The StanfordNERTagger wrapper and Java runtime/version were not checked; its classifier JAR and pretrained model are recorded as separate resource requirements.

## Review notes

- Static assessment only: no author source execution/import/AST/compile, regression, synthetic trial, SAS executable/startup/autoexec/PROC, download, installation or authentication/API test was performed. The only external data read was the authorized exact catalog-listed COMP.G_SECURITY bounded one-row metadata probe.
- COMP.G_SECURITY's native ISIN and gvkey fields and a one-row readable route are verified; the probe explicitly does not verify population or historical match coverage. Other local and public routes remain specific to the source products and fields identified in the supplied workflow.
- The two packaged identifier lists are positively credited as readable packaged files, but no source establishes either as sample_gdelt_qtr1.dta or ab_list/code_b. No false alias is inferred.
- The result is an unapplied patch proposal. The author package, cached readings and frozen artifacts were not changed.
- The JSON inspection record E_PUBLIC_PAGE_FAILURES documents four direct public-page opens that returned 403 (two UN library pages and two NBER pages). It is an unreferenced process record only; it is not evidence of route unavailability, and those pages were not retried.
- Notebook evidence binds file and sha256 to the original packaged notebook bytes; line_begin and line_end refer to physical lines in the registered extracted-code cache and its screened view, as recorded in the source preflight. This two-layer representation does not indicate source mutation.
