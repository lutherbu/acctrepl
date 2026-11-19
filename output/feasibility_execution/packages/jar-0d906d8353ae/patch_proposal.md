# Patch proposal: jar-0d906d8353ae

Generative AI in Financial Reporting

DOI: 10.1111/1475-679X.70050

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete documented workflow for SEC and conference-call text acquisition, text processing and measures, sample and control construction, GPTZero scoring and validation, final analysis datasets, and regression tables and figures.

Entry points: `_nested_code/code/1_data_processing/1_pull_documents/pull_sec_filings.R`, `_nested_code/code/1_data_processing/1_pull_documents/pull_conference_calls.py`, `_nested_code/code/1_data_processing/4_sample_selection/sample_selection.Rmd`, `_nested_code/code/1_data_processing/4_sample_selection/sample_selection_S1.Rmd`, `_nested_code/code/1_data_processing/5_control_variables/pull_control_variables.Rmd`, `_nested_code/code/1_data_processing/5_control_variables/pull_gics.Rmd`, `_nested_code/code/1_data_processing/5_control_variables/pull_vwret_by_decile.ipynb`, `_nested_code/code/1_data_processing/7_merge/create_final_datasets.Rmd`, `_nested_code/code/2_validation_test/1_sample_selection_and_preparation/1_validation_sample_selection.R`, `_nested_code/code/2_validation_test/1_sample_selection_and_preparation/2_generate_samples.py`, `_nested_code/code/2_validation_test/1_sample_selection_and_preparation/3_ChatGPT_API_batch_sentence_level.py`, `_nested_code/code/2_validation_test/1_sample_selection_and_preparation/4_split_into_chunks_and_ChatGPT_API_batch.py`, `_nested_code/code/2_validation_test/1_sample_selection_and_preparation/5_check_for_stickiness.py`, `_nested_code/code/2_validation_test/1_sample_selection_and_preparation/6_combine_gptzero_results.py`, `_nested_code/code/2_validation_test/1_sample_selection_and_preparation/7_overlap_between_original_and_modified_reports.py`, `_nested_code/code/2_validation_test/1_sample_selection_and_preparation/8_assemble_validation_dataset.R`, `_nested_code/code/2_validation_test/2_run_through_GPTZero/ai.py`, `_nested_code/code/2_validation_test/3_analysis/GPTZero_Analysis_Part_I.do`, `_nested_code/code/2_validation_test/3_analysis/GPTZero_Analysis_Part_II.do`, `_nested_code/code/2_validation_test/3_analysis/confusion_matrix.do`, `_nested_code/code/2_validation_test/3_analysis/regressions_lingOnValid.do`, `_nested_code/code/3_regression/data_prep.do`, `_nested_code/code/3_regression/figures_and_regressions.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 3/70050 - Generative-AI-in-Financial-Reporting/bdldatasheetcodeidentifiersandlogfiles.zip",
      "sha256": "a55c97e6b6eff919a6378eacac11b12ed8abda08c08a5906025e088ade21df26"
    },
    {
      "path": "JAR-Volume 64/Issue 3/70050 - Generative-AI-in-Financial-Reporting/bdl-online-appendix.pdf",
      "sha256": "aba673a92b36a23ab0c56301c5bdc3b9bec5ee4fa9bb310b1f5446a04a3e5f02"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a8cbf5e695a6e10d7a77e89a38a3e3f5dced12707905b6c96bbf159d449a0039",
  "work_item_sha256": "3dc5966f5bf9457c953846d92c2783e7e024aa1d076f86d92989ae60ea8aa0f5"
}
```

## Proposed actions

### A_EDGAR_FULL_SAMPLE: Expand the EDGAR notebook demo loops to process the full filing list, including a partial final batch.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_EDGAR_DEMO
Evidence: E_EDGAR_OUTER, E_EDGAR_SLICE, E_EDGAR_INNER

**Proposed edit:** `_nested_code/code/1_data_processing/4_sample_selection/edgar_scraper_filen.ipynb:35–35 (cell 3ffec493-41ba-49a3-98db-456feebe69a7)`
Source SHA-256: `f6594a0811c9c1c6cb5f0654c41835f23c12c78322ec04f9e9f17ed6ee913ea4`

Iterate over every 100-row chunk of the imported filing list.

Current text:
```
for i in range(1):
```

Proposed replacement:
```
for i in range((len(df_full) + 99) // 100):
```

**Proposed edit:** `_nested_code/code/1_data_processing/4_sample_selection/edgar_scraper_filen.ipynb:42–42 (cell 3ffec493-41ba-49a3-98db-456feebe69a7)`
Source SHA-256: `f6594a0811c9c1c6cb5f0654c41835f23c12c78322ec04f9e9f17ed6ee913ea4`

Process only the available rows in a partial final chunk.

Current text:
```
    for j in range(100):
```

Proposed replacement:
```
    for j in range(len(df)):
```

Preparation / proposed procedure:

1. Preserve 100-row chunking and existing per-filing pacing.
2. Confirm the full source list and eligibility filters before full processing.

Validation to perform later:

- Check every source row belongs to one batch, including a shorter last batch.
- Confirm producer/consumer order and complete intended filing coverage.

### A_SCORE_MAPPING: Confirm whether the public score CSV matches the dated full-sample and S-1 score RDS files and all authored key/variant joins.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SCORE_MAPPING, R_SCORE_COMPONENT, R_SCORE_RDS
Evidence: E_DATASHEET, E_SCORE_CSV_PROBE, E_SCORE_MAIN_JOIN, E_SCORE_S1_JOIN

Preparation / proposed procedure:

1. Compare row keys, item/disclosure coding, score definitions, sticky/non-sticky variants, and S-1 filename coverage.
2. If not equivalent, supply the author-prepared main and S-1 score RDS files.

Validation to perform later:

- Use the CSV as a supplemental route unless the authored joins and variants are matched.

### A_SDC_INPUTS: Supply the author SDC IPO records, EDGAR filing list, and dated S-1 index.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_SDC_FILEN_LIST, R_S1_INPUTS
Evidence: E_S1_IPO, E_S1_LIST, E_S1_INDEX

Preparation / proposed procedure:

1. Provide the dated IPO RDS and EDGAR list.
2. Provide the S-1 index with CIK and filing-date keys.
3. Preserve the authored IPO flag, filename, and WRDS link joins.

Validation to perform later:

- Check filing-number, CIK, IPO flag, filename, and date coverage before sample selection.

### A_WRDS_ROUTES: Confirm authorized access and exact product/vintage routes for the WRDS and Audit Analytics sources used by the workflow.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_SEC_FILINGS, R_CIQ_TRANSCRIPTS, R_CRSP_DSF, R_COMP_FUNDA, R_COMP_FUNDQ, R_CRSP_MSENAMES, R_CRSP_CCM, R_WRDSSEC_CIKLINK, R_AUDIT_FEED03, R_COMPHIST
Evidence: E_DOC_SEC, E_DOC_CIQ, E_DOC_CONTROLS, E_DSF_TABLE, E_COMPHIST_LOOKUP

Preparation / proposed procedure:

1. Confirm product entitlements and required periods.
2. Resolve a precise CRSP.COMPHIST route and confirm GVKEY/history-date/HGSECTOR fields.
3. Map local table candidates to author-prepared RDS/query outputs.

Validation to perform later:

- Check exact fields, date filters, and joins before substituting native tables.

### A_LOCAL_FILING_MAPPING: Check the documented local filing-source candidates against the filing forms and text fields consumed by EDGAR processing.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SEC_FILINGS
Evidence: E_LOCAL_SEC_PATHS, E_EDGAR_PDF, E_DOC_SEC

Preparation / proposed procedure:

1. Use exact-path metadata only to confirm the year-directory and exhibit-directory candidates; no recursive listing or document reads were performed.
2. Map available CIK, filing ID, form, date, and section text for the required 2010–2024 10-K, 10-Q, 8-K, and S-1 branches before relying on these local corpora.
3. Treat LM10-X as a possible 10-K/10-Q text source only, and exhibits as partial filing material until coverage is established; retain WRDS SEC and public routes as separate alternatives.

Validation to perform later:

- Verify filing population, section coverage, and cleaning compatibility before marking any local route verified.

### A_CONTROL_FILES: Provide dated IR, institutional-ownership, IBES, SDC M&A, segment, return-decile, and control RDS inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: I_CONTROL_INPUTS, R_CONTROL_SUPPLEMENTAL
Evidence: E_DOC_CONTROLS, E_CONTROL_IR, E_CONTROL_INSTOWN, E_CONTROL_IBES, E_CONTROL_MA, E_CONTROL_SEGMENTS, E_CONTROL_RETURNS

Preparation / proposed procedure:

1. Identify exact author file vintages and input-to-control field mappings.
2. Confirm IR coverage through the required analysis period.
3. Preserve CUSIP/date, link, segment, and audit joins.

Validation to perform later:

- Check the complete 2010–2024 panel and source-specific join keys.

### A_NATIVE_COVERAGE: Verify full-period coverage and map local one-row field candidates to the author-prepared data products.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_NATIVE_COVERAGE, R_CRSP_DSF, R_COMP_FUNDA, R_COMP_FUNDQ, R_CRSP_MSENAMES, R_CRSP_CCM, R_WRDSSEC_CIKLINK, R_AUDIT_FEED03
Evidence: E_CRSP_DSF_PROBE, E_COMP_FUNDA_PROBE, E_COMP_FUNDQ_PROBE, E_CRSP_MSENAMES_PROBE, E_CRSP_CCMXPF_PROBE, E_WRDSSEC_CIKLINK_PROBE, E_AUDIT_FEED03_PROBE

Preparation / proposed procedure:

1. Use authored date filters and join keys to define the required coverage.
2. Compare the native table fields and periods to the dated author RDS products.

Validation to perform later:

- Record full date coverage and verify join-key completeness before building analysis panels.

### A_ROOTS_AND_OVERLAPS: Align portable producer/consumer roots and prepare model-specific overlap files in the format and suffixes expected by R.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_ROOT_ALIGNMENT, I_OVERLAP_FORMAT, I_OVERLAP_MODELS
Evidence: E_ROOT_GPTZERO, E_ROOT_VALIDATION, E_D2_LITERAL, E_D3_LITERAL, E_OVERLAP_CSV, E_OVERLAP_PKL, E_ASM_OV35, E_ASM_OV4, E_ASM_OVG

Preparation / proposed procedure:

1. Use one project-relative working root while preserving sticky/non-sticky, model, and alpha suffixes.
2. Convert the supported GPT-3.5 overlap output to RDS and stage at its first-consumer path.
3. Identify or obtain the matching GPT-4o and Gemini overlap outputs.

Validation to perform later:

- Resolve each exact path, format, key, and model suffix before validation assembly.

### A_VALIDATION_GAPS: Resolve the batch-result producer, Part II sample inputs, outcome DTAs, and variable alias contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_VALIDATION_BATCH, I_PARTII_ALIAS, R_VALIDATION_BATCH, R_PARTII_SAMPLE, R_VALIDATION_OUTCOMES
Evidence: E_OVERLAP_INPUT, E_API_WRITER_COMMENT, E_API_BATCH_READ, E_P2_INPUT, E_OUTCOME_35, E_OUTCOME_4, E_OUTCOME_G, E_ASM_SCORE_NAME, E_P2_DYNAMIC

Preparation / proposed procedure:

1. Identify the exact author model/sample batch pickle and its producer.
2. Provide or map each item-specific analysis sample and the three validation outcome files.
3. Confirm every Part II probability field against the R consolidated dataset.

Validation to perform later:

- Check model, sample, item/id keys, expected fields, and the dynamic suffix loops without substituting new service responses.

### A_PYTHON_SETUP: Prepare missing Python distributions from a reviewed environment specification.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_PY_SCRAPE, S_PY_WRDS, S_PY_FINBERT, S_PY_LDA
Evidence: E_PY_SELENIUM, E_PY_WEBDRIVER_MANAGER, E_PY_PIKEPDF, E_PY_WRDS, E_PY_TRANSFORMERS, E_PY_GENSIM, E_PY_SEABORN, E_PY_WORDCLOUD

Preparation / proposed procedure:

1. Resolve compatible versions for selenium, webdriver-manager, pikepdf, wrds, transformers, gensim, seaborn, and wordcloud.
2. Record the environment without running author code or external services.

Validation to perform later:

- Confirm source-imported distribution metadata before author workflow execution.

### A_R_SETUP: Check the R package stack imported by the author Rmds and prepare a reproducible library.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_R_PACKAGES
Evidence: E_R_IMPORT

Preparation / proposed procedure:

1. Check imported R packages and compatible versions, including RPostgres, haven, dplyr, fixest, readxl, and fabricatr.

Validation to perform later:

- Confirm all required namespaces resolve in the selected R environment.

### A_STATA_SETUP: Prepare the missing Stata winsorization and table/export commands used by the source.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_STATA_EXPORT
Evidence: E_ASDOC_PROBE, E_TABOUT_PROBE, E_DP_WINSOR, E_FIG_OUTREG2, E_FIG_TABOUT, E_FIG_ASDOC

Preparation / proposed procedure:

1. Resolve compatible winsor2, outreg2, asdoc, and tabout versions.
2. Configure and record the selected Stata ado path.

Validation to perform later:

- Use bounded command-availability checks before author analysis.

### A_SAS_CONFIGURATION: Keep documented SAS 9.4 as an unverified configuration item only if a later source review establishes an executable SAS stage.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: S_SAS
Evidence: E_ENV, E_CONTROL_IR

Preparation / proposed procedure:

1. No SAS command was run in this assessment.
2. Use the visible R haven route for SAS7BDAT unless direct source establishes an SAS-coded stage.

Validation to perform later:

- Do not treat the machine's documented SAS executable as a workflow dependency without direct source evidence.

### A_MODEL_RESOURCES: Verify the exact FinBERT weights/tokenizer and local NLTK resources.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_MODEL_RESOURCES, S_MODEL_RESOURCES
Evidence: E_FINBERT_MODEL, E_LDA_NLTK

Preparation / proposed procedure:

1. Identify the expected FinBERT revision and tokenizer files.
2. Confirm local tokenizer, stopword, and WordNet data or an approved resource route.

Validation to perform later:

- Record model/resource versions and preserve authored tokenization settings.

### A_FULL_ORDER: After resolving the documented input, service, software, resource, and handoff gaps, follow the authored stage order through regressions.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_WORKFLOW_CLOSURE
Evidence: E_DOC_SEC, E_DOC_CIQ, E_DOC_CONTROLS, E_SCORE_MAIN_READ, E_ASM_JOIN, E_P2_READ, E_FIG_STICKY

Preparation / proposed procedure:

1. Preserve separate main/S-1, filing-type, sticky/non-sticky, model, and alpha branches.
2. Preserve the source loops, seeds, 100 simulation repetitions, filters, and first-consumer ordering.
3. Do not claim full-pipeline readiness until required inputs and aliases are mapped.

Validation to perform later:

- Check all 94 edges against producer, consumer, fields, keys, dates, and branch order before execution.

### A_MAIN_SAMPLE_PANEL: Locate or request the author-prepared CRSP-Compustat annual panel consumed by the main sample Rmd.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MAIN_SAMPLE_PANEL
Evidence: E_SAMPLE_PANEL, E_SAMPLE_PERIOD, E_SAMPLE_LINK

Preparation / proposed procedure:

1. Locate the exact supplied panel or request the author-prepared CSV and its release details.
2. Preserve the 2010–2024 period and LINKPRIM P/C filter; do not independently reconstruct the panel from raw tables without documented author preparation.

Validation to perform later:

- Confirm the expected fields, identifiers, dates, and complete input coverage against the consuming Rmd.

### A_LINGUISTIC_RDS: Locate the author-prepared linguistic-measure RDS inputs or obtain their exact producer specifications.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_LINGUISTIC_RDS
Evidence: E_DP_LING

Preparation / proposed procedure:

1. Identify the exact length/fog, sentiment, and specificity RDS files and their release/version.
2. If they are not supplied, request the authored producer and input specification rather than independently regenerating the measures.

Validation to perform later:

- Check required measure fields and ITEM, disclosure, stickiness, identifier, and date joins against the consumer.

### A_MODEL_SERVICE_ACCESS: Clarify the authorized service and output route for GPTZero scoring and ChatGPT batch validation.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I_MODEL_SERVICE
Evidence: E_PROD_AI_1A, E_API_OPENAI, E_API_BATCH_READ

Preparation / proposed procedure:

1. Confirm the required service versions, approved account/configuration route, and output handoff locations, or obtain matching author-produced outputs.
2. No API, authentication, or service trial was performed during this assessment.

Validation to perform later:

- Check that service outputs retain the model/batch identifiers and fields expected by the downstream producers and validation assembler.


## Remaining issues and prerequisites

- I_EDGAR_DEMO [preparation; full_pipeline]: The EDGAR notebook restricts the scraper and combine loops to one 100-row batch, so it is a demo subset rather than evidence of full filing-list coverage.
- I_SCORE_MAPPING [unresolved; full_pipeline]: The published CSV contains document-level scores, while the authored final-data Rmd reads separate dated full-sample/S-1 RDS files and joins by main item/stickiness/id/GVKEY/date or S-1 filename. Exact replacement mapping is unresolved.
- I_VALIDATION_BATCH [unresolved; full_pipeline]: The overlap script reads a GPT-3.5-labelled combined pickle; the API script comments a writer for a differently named generic pickle and then reads that generic file. Exact producer/model/sample mapping is unresolved.
- I_OVERLAP_MODELS [unresolved; full_pipeline]: The assembler reads GPT-4o and Gemini overlap RDS files, but the visible overlap producer handles GPT-3.5 and writes CSV/pickle. Matching GPT-4o/Gemini producers remain unresolved.
- I_OVERLAP_FORMAT [preparation; full_pipeline]: The GPT-3.5 overlap producer writes CSV/pickle while R expects RDS at a different configured root; convert and stage the data for the actual consumer.
- I_ROOT_ALIGNMENT [preparation; full_pipeline]: Byte-only comparisons show distinct literal roots for scoring producers/combiner and validation producer/consumer layouts. Configure portable roots and preserve suffix-specific handoffs.
- I_PARTII_ALIAS [unresolved; full_pipeline]: The R assembler creates a GenScore-based consolidated file, while Part II expects named model/stickiness probability fields. The intended field mapping is not established.
- I_NATIVE_COVERAGE [preparation; full_pipeline]: Seven local table checks confirm one-row readability and fields but not historical coverage or equivalence to dated author-prepared RDS/query outputs.
- I_CONTROL_INPUTS [unresolved; full_pipeline]: IR, institutional ownership, IBES, SDC M&A, segments, and return-decile/control products are dated author inputs whose availability and full 2010–2024 joins are unverified.
- I_MODEL_SERVICE [unresolved; full_pipeline]: GPTZero scoring and ChatGPT batch validation need external model/service outputs and account configuration. No authentication, API, model, or service trial was performed.
- I_MODEL_RESOURCES [preparation; full_pipeline]: FinBERT weights/tokenizer and NLTK tokenizer, stopword, and WordNet resources are unverified.
- I_WORKFLOW_CLOSURE [unresolved; full_pipeline]: All 94 registered edges are classified, but data routes, model outputs, root/suffix handoffs, and Part II field mappings remain unresolved; full execution closure is incomplete.
- R_SEC_FILINGS [undetermined]: SEC indexes and filing text for 10-K, 10-Q, 8-K, and S-1 processing.
- R_CIQ_TRANSCRIPTS [undetermined]: Capital IQ earnings-call transcripts and author-prepared transcript text.
- R_SDC_FILEN_LIST [undetermined]: SDC filing-number list consumed by the EDGAR scraper.
- R_MAIN_SAMPLE_PANEL [undetermined]: Author-prepared CRSP-Compustat annual sample CSV filtered to 2010–2024 and LINKPRIM P/C.
- R_S1_INPUTS [undetermined]: SDC IPO RDS, EDGAR filing list, and SEC S-1 index used for filing-name and IPO matching.
- R_SCORE_RDS [undetermined]: Dated author-prepared full-sample and S-1 GPTZero score RDS files consumed by the final-data Rmd.
- R_COMPHIST [undetermined]: Compustat history table used to construct time-varying GICS sector data.
- R_CONTROL_SUPPLEMENTAL [undetermined]: Author-prepared IR, institutional ownership, IBES, M&A, segment, and return-decile control inputs.
- R_LINGUISTIC_RDS [undetermined]: Author-prepared length/fog, sentiment, and specificity RDS measures joined to main text disclosures.
- R_VALIDATION_BATCH [undetermined]: GPT-3.5-labelled combined validation batch pickle read by the overlap script; exact producer/model/sample mapping unresolved.
- R_PARTII_SAMPLE [undetermined]: Four item-specific sample DTA inputs required by Part II.
- R_VALIDATION_OUTCOMES [undetermined]: Author-prepared model-specific linguistic-validation outcome DTA files.
- S_SAS [unverified]: Runtime remains unverified in this assessment. No SAS command was invoked; the inspected R SAS7BDAT path uses read_sas.
- S_STATA_EXPORT [preparation_required]: All four are used in the source; winsor2/outreg2 were not found, and bounded metadata probes report asdoc/tabout unavailable.
- S_R_PACKAGES [unverified]: The control Rmd imports RPostgres, dplyr, data.table, tibble, stringr, farr, lubridate, ggplot2, purrr, tidyverse, knitr, haven, fixest, readxl, and fabricatr; package presence was not checked.
- S_PY_SCRAPE [preparation_required]: selenium, webdriver-manager, and pikepdf are unavailable; BeautifulSoup, pandas, tqdm, and openpyxl are available by distribution metadata.
- S_PY_WRDS [preparation_required]: wrds is unavailable by metadata; pandas, numpy, and python-dateutil are available.
- S_PY_FINBERT [preparation_required]: transformers is unavailable; scipy, nltk, pandas, numpy, and tqdm are available. FinBERT weights and NLTK corpora are separate unverified resources.
- S_PY_LDA [preparation_required]: gensim, seaborn, and wordcloud are unavailable; numpy, pandas, matplotlib, and nltk are available.
- S_MODEL_RESOURCES [unverified]: The code requests yiyanghkust/finbert-tone and uses NLTK tokenization, stopwords, and WordNet resources; exact local resources were not checked.

## Review notes

- Generation 2 covers full_pipeline; analysis_only is not offered because no complete compatible analysis input was verified.
- All 94 registered dependency edges are classified. Generated means a source-supported producer path, not a completed run or verified output file.
- Native SAS7BDAT checks were one-row Python ReadStat field/readability probes only; they do not establish full history or equivalence to author RDS/query outputs.
- No author code, API/authentication trial, model trial, data deserialization, download, install, or SAS command was performed in this assessment.
- The EDGAR sample limit, model service outputs, private data routes, model resources, roots/suffixes, and Part II aliases remain explicit prerequisites.
- Registered source masks are treated only as reading limits; no masked text is quoted or interpreted as absent code or data.
