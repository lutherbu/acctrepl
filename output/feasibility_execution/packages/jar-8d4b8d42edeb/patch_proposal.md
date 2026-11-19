# Patch proposal: jar-8d4b8d42edeb

Global Evolution of Environmental and Social Disclosure in Annual Reports

DOI: 10.1111/1475-679X.12582

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: global report acquisition and parsing, Word2Vec dictionary construction, disclosure measures, SAS panel preparation and merges, and supplied main and online-appendix Stata analyses.

Entry points: `Python code/script/download/step-1-get-search-results.py`, `Python code/script/download/step-2-download-pdf.py`, `Python code/script/parse/parse-to-txt.py`, `Python code/script/gen-word2vec/step1-preprocessing.py`, `Python code/script/gen-word2vec/step2-dump-sentences.py`, `Python code/script/gen-word2vec/step3-run-bigram-trigram.py`, `Python code/script/gen-word2vec/step4-run-word2vec.py`, `Python code/script/gen-word2vec/step5-gen-dictionary.py`, `Python code/script/gen-word2vec/step6-list-common-keywords.py`, `Python code/script/score/gen-boilerplate.py`, `Python code/script/score/gen-intensity-specificity.py`, `Python code/script/score/gen-stickyness.py`, `Python code/script/score/gen-table-statistics.py`, `Python code/script/score/gen-visual-statistics.py`, `Python code/script/gen-figure/figure-1.py`, `Python code/script/gen-figure/figure-2.py`, `Python code/script/gen-figure/figure-3.py`, `Python code/script/gen-figure/figure-4.py`, `Python code/script/gen-figure/figure-5.py`, `Python code/script/gen-figure/figure-IA.py`, `SAS and STAT code and log/get vars for global ESG.sas`, `SAS and STAT code and log/merge text data and vars_JAR resubmit.sas`, `SAS and STAT code and log/get earnings opacity rank_JAR resubmit.sas`, `SAS and STAT code and log/JAR Main Tables.do`, `SAS and STAT code and log/JAR OA Tables.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "identity_notes": [
    "The same source DOI is associated with multiple paper folders; no folders were merged.",
    "Source titles conflict for this DOI; original publication metadata is retained for review."
  ],
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 5/12582 - Global-Evolution-of-Environmental-and-Social-Disclosure-in-Annual-Reports/lswy-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "93ecf0f8cf4446c07b3d420974002b638964cc7e31334815980204105e7afc5b"
    },
    {
      "path": "JAR-Volume 62/Issue 5/12582 - Global-Evolution-of-Environmental-and-Social-Disclosure-in-Annual-Reports/lswy-online-appendix.pdf",
      "sha256": "c1868e7eef9eca6ac3aaad650ceb36c87db452ecf2b732aa3abe192cb282f89f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "ece30f8c18a01c1512281558dfb8f9fe6ff2c7f798461f3cea8c8f927871e7ce"
}
```

## Proposed actions

### A_REPORT_CORPUS: Stage the author-described global annual-report corpus through an authorized RGF/RKD route, or document an alternative source with the same global report population. The local SEC raw/parsed and LM10-X roots remain candidates; their presence does not establish RGF-equivalent global coverage.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_REPORT_CORPUS
Evidence: E_RGF_SOURCE, E_SEC_RAW_ROOT, E_SEC_PARSED_ROOT, E_LM10X_ROOT, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Confirm the authorized source route and available report years/identifiers.
2. If a local filing corpus is proposed as an alternative, document its coverage and relation to the required global report set before using it.

Validation to perform later:

- Record the selected route, period, and report identifier mapping; do not infer equivalence from directory presence alone.

### A_REPORT_LIST: Obtain the producer and curation contract for short_listed_pdf.csv. The supplied code consumes DCNs, filters ITEM2999, intersects available TXT files, and uses report/year/ownership identifiers; the full list history, period, and identity mapping are not supplied.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_REPORT_LIST, I_REPORT_LIST_PRODUCER
Evidence: E_REPORT_LIST_FILTER, E_REPORT_LIST_FIGURE_FIELDS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Supply or regenerate the report list with its filter rules and source period.
2. Retain the DCN, ITEM2999, fyear, OAPermID, periodEndDate, txt_file_size, OrgPermID, WsId, and countryCode fields used by supplied code.

Validation to perform later:

- Confirm the list joins to the staged reports and parsed TXT by the source-defined identifiers and filters.

### A_KEYWORD_LISTS: Provide the exact eight scoring inputs, including general.txt, and the final common-word filtering/manual-review result. The supplied seed module and step 5 produce seven category lists; step 6 reads eight lists, while the appendix describes top-1,500 common-word removal and manual inspection. The repository directory lists ES-dictionary.xlsx as a candidate, but its contents were not inspected.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_KEYWORD_LISTS, I_DICTIONARY_CONSTRUCTION
Evidence: E_STEP5_OUTPUT, E_STEP6_EIGHT, E_DICT_MANUAL, E_SEEDWORD_SOURCE, E_SEEDWORD_IMPORT, E_GITHUB_DATA_CANDIDATE, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Obtain the final category and general lists or the exact reproducible producer and manual-review record.
2. Preserve the seven generated category lists separately from the general list and the appendix's common-word/manual filtering step.

Validation to perform later:

- Check the eight expected filenames/categories and record the final word-list inputs used for scoring.

### A_FIGURE_INPUTS: Supply the three independent figure inputs and their source contracts: country_name and code.xlsx Sheet3 (sample/code), inter_industry.dta (WsId/fyear/ffind5), and esg_framework_keywords_counts.pkl (fyear plus six long/short framework fields). No producer for these files is supplied.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_COUNTRY_LOOKUP, R_INTER_INDUSTRY, R_FRAMEWORK_COUNTS
Evidence: E_COUNTRY_LOOKUP_CONTRACT, E_INTER_INDUSTRY_CONTRACT, E_FRAMEWORK_COUNTS_CONTRACT, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Locate or produce each input independently from its documented source.
2. Keep the country, industry, and framework-count inputs separate because the figures consume different products.

Validation to perform later:

- Check only each source-defined key/field contract and required years before generating its figure.

### A_VENDOR_SOURCES: Configure or acquire the individually consumed commercial source tables at their registered local candidates with the source-defined fields, keys, and date windows. One-row probes support some source-field indications only; they do not verify full panels or periods. The Worldscope fundamentals probe timed out once and was not repeated; that timeout does not establish absence or an access barrier.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_WS_FUNDA, R_WS_COMPANY, R_WS_STOCK, R_DS2WS_LINK, R_DATASTREAM, R_IBES, R_OWNERSHIP, R_REFINITIV_ESG_SUMMARY, R_REFINITIV_ESG_INFO
Evidence: E_FROZEN_CATALOG, E_WS_FUNDA_SOURCE, E_WS_FUNDA_LAG, E_PROBE_WS_FUNDA, E_WS_COMPANY_SOURCE, E_PROBE_WS_COMPANY, E_WS_STOCK_SOURCE, E_PROBE_WS_STOCK, E_DS2WS_SOURCE, E_PROBE_DS2WS_LINK, E_DATASTREAM_SOURCE, E_DATASTREAM_WINDOW, E_PROBE_DATASTREAM, E_IBES_SOURCE, E_PROBE_IBES, E_OWNERSHIP_SOURCE, E_PROBE_OWNERSHIP, E_REFINITIV_ESG_SOURCE, E_PROBE_REFINITIV_SUMMARY, E_PROBE_REFINITIV_INFO, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Use the registered candidate tables or the authorized source subscription identified by the project.
2. Retain the SAS source-defined keys, item/frequency filters, prior-year lag, daily return interval, and ownership-quarter selection when preparing the analysis inputs.
3. Resolve any required file/library naming and same-data format conversion as preparation.

Validation to perform later:

- Check source-defined required fields and the windows/keys used by the supplied SAS joins; one-row probe evidence is not a coverage claim.
- Keep the Worldscope fundamentals timeout recorded as unverified without retrying it.

### A_PROJECT_AUXILIARIES: Supply or identify the nine separate SAS auxiliary products: country_trans, wb_data, population, esg_framework, esg_report_list_link, mandate_date, wgidata, captogdp, and country_iso. For wb_data and population, the World Bank is a public candidate, but exact indicator/series, units, period, and transformation are unspecified; for the project tables, their consumed fields/joins are visible but their producers and some construction are not.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_COUNTRY_TRANS, R_WB_DATA, R_POPULATION, R_ESG_FRAMEWORK, R_REPORT_LINK, R_MANDATE_DATE, R_WGI, R_CAPTOGDP, R_COUNTRY_ISO, I_PROJECT_AUXILIARIES
Evidence: E_COUNTRY_TRANS_USE, E_WB_DATA_USE, E_POPULATION_USE, E_WB_DATASHEET, E_WB_PUBLIC, E_WB_POPULATION_PUBLIC, E_ESG_FRAMEWORK_USE, E_REPORT_LINK_USE, E_MANDATE_DATE_USE, E_WGI_USE, E_CAPTOGDP_USE, E_COUNTRY_ISO_USE, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Locate each project table separately and identify the source/producer, key, units, and analysis period consumed by the SAS code.
2. For the World Bank candidate, identify the exact series and year/country mapping required by the supplied joins before acquisition.
3. Preserve the source-defined framework counts, report links, mandate/rank dates, governance indicators, cap-to-GDP, and country crosswalk as distinct inputs.

Validation to perform later:

- Validate each input against its own SAS join key and consumed fields; a single vendor or public table does not replace the other joint inputs.

### A_VARIANT_BRANCHES: Resolve the fourteen separately consumed SAS variant tables individually: bp_alt, bp_simple, bp_simple_update, bp_fh, intensity_fh, specificity_fh, sticky_fh, visual_fh, visual_new, total_bp, total_specificity, total_sticky, total_visual_p, and total_visual_t. Their producer code and exact variant constructions are not supplied; first-half filters, updated definitions, denominators, and table/picture splits must remain specific to each branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_BP_ALT, R_BP_SIMPLE, R_BP_SIMPLE_UPDATE, R_BP_FH, R_INTENSITY_FH, R_SPECIFICITY_FH, R_STICKY_FH, R_VISUAL_FH, R_VISUAL_NEW, R_TOTAL_BP, R_TOTAL_SPECIFICITY, R_TOTAL_STICKY, R_TOTAL_VISUAL_P, R_TOTAL_VISUAL_T, I_ALT_BRANCH_PRODUCERS
Evidence: E_BP_ALT_USE, E_BP_SIMPLE_USE, E_BP_SIMPLE_UPDATE_USE, E_BP_FH_USE, E_INTENSITY_FH_USE, E_SPECIFICITY_FH_USE, E_STICKY_FH_USE, E_VISUAL_FH_USE, E_VISUAL_NEW_USE, E_TOTAL_BP_USE, E_TOTAL_SPECIFICITY_USE, E_TOTAL_STICKY_USE, E_TOTAL_VISUAL_P_USE, E_TOTAL_VISUAL_T_USE, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request the producer, sample period, keys, and exact definition for each of the fourteen tables.
2. Preserve first-half, updated, total-text, and picture/table branches as distinct inputs; do not infer one branch from another.

Validation to perform later:

- For each table, check its source-defined dcn key and consumed field names/definition before the SAS merge.

### A_IBES_LIBREF: Resolve the ibes SAS libref used by get vars for global ESG.sas for the already identified statsumu_epsint source. The source table candidate is present in the frozen catalog, while that program does not show its library assignment.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: R_IBES, I_IBES_LIBNAME
Evidence: E_IBES_SOURCE, E_PROBE_IBES, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Use the environment/project SAS setup to map the ibes libref to the intended table library.
2. Do not alter the source query or assume the setup assignment without checking the configured environment.

Validation to perform later:

- Confirm the assigned libref resolves the source-defined table and required fields before the full workflow run.

### A_PYTHON_SAS_HANDOFF: Prepare the source-supported Python-to-SAS metric bridge. The code supports seven-category intensity sum as overall, doc_word_count to SAS word_count, report-list year to fyear, separate specificity fields, country boilerplate counts and Figure 1 ratio, stickyness fields (SAS calls the field stickiness), and picture/table counts with visuals as their sum. PyArrow is available for the Feather reads/writes.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_PYTHON_SAS_HANDOFF, SW_PYARROW
Evidence: E_INTENSITY_SCHEMA, E_INTENSITY_SPECIFICITY_SCHEMA, E_INTENSITY_OUTPUT, E_FIGURE4_MAPPING, E_SAS_INTENSITY_USE, E_SAS_SPECIFICITY_USE, E_BOILERPLATE_OUTPUT, E_BOILERPLATE_FIGURE_CONCAT, E_FIGURE1_BP_RATIO, E_SAS_BOILERPLATE_USE, E_STICKY_OUTPUT, E_SAS_STICKY_USE, E_VISUAL_OUTPUT, E_TABLE_OUTPUT, E_SAS_VISUAL_USE, E_FEATHER_USE, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Stage each source-produced metric table with the defined report key and map only the documented names/sums into SAS columns.
2. Keep the intensity, specificity, boilerplate, stickyness, picture, and table products separate until their documented merge/figure operation.

Validation to perform later:

- Confirm the mapped key and exact source-defined columns at each handoff; do not substitute a different metric or combine independent products.

### A_VISUAL_PATH_PREPARATION: Align the separate visual and table producer outputs with the Figure 1 read layout after they are produced. The source expects visuals_r1 and a sibling visuals_tables path, while the generators write distinct roots; keep both outputs separate and account for the shared visual.dta target path when staging them.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_VISUAL_PATHS
Evidence: E_VISUAL_OUTPUT, E_TABLE_OUTPUT, E_FIGURE1_VISUAL_PATH, E_SAS_VISUAL_USE, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Choose the configured result root and stage the picture and table pickle files into the paths expected by Figure 1.
2. Preserve the distinct pic_count and table_count products before the source-defined sum.

Validation to perform later:

- Confirm Figure 1 reads the intended two files and the SAS bridge retains both counts plus visuals.

### A_SAS_ALIAS_FORMAT_PREPARATION: Align the source-defined SAS output/input table names and convert same-logical-data SAS7BDAT outputs to the Stata DTA input where needed. inter_data_2024 feeds the suffixless inter_data name; Esg_and_allvars_resubmit_2024 feeds its suffixless earnings-stage name; the final SAS panel feeds the Stata filename. These aliases and standard format conversion are preparation when the source-defined key/schema is retained.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_SAS_ALIAS_HANDOFF
Evidence: E_INTERDATA_OUTPUT, E_INTERDATA_INPUT, E_MERGE_OUTPUT, E_MERGE_INPUT, E_FINAL_SAS_OUTPUT, E_STATA_MAIN_INPUT, E_STATA_OA_INPUT, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Configure table/file aliases at the run root or create same-data aliases after each producer completes.
2. Convert the final SAS output to DTA for Stata while preserving its source-defined variables and keys.

Validation to perform later:

- Check the mapped table name, DTA readability, and source-defined keys/columns; no original-byte or vintage match is required.

### A_PATH_CONFIGURATION: Configure the author-supplied data/result/keyword roots and replace Windows-only paths with the host's relative or [redacted-path-5e6361f62a8d] paths. Use configured runtime paths rather than absolute Dropbox workspace paths.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_SETUP
Evidence: E_PATH_PLACEHOLDERS, E_STATA_MAIN_INPUT, E_STATA_OA_INPUT, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Set the run roots and SAS librefs in the host execution wrapper.
2. Map author path placeholders to the staged report, results, keyword, SAS, and Stata paths.

Validation to perform later:

- Resolve each path from the actual producer output to its next consumer before starting the workflow.

### A_DOCX_CONVERSION: Prepare the documented manual PDF-to-DOCX step with the named Solid Commander or a documented compatible converter; availability and converted report outputs are unverified. Scanned reports may need OCR, as described in the appendix.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_DOCX_CONVERSION, SW_SOLID_COMMANDER
Evidence: E_DOCX_PREP, E_DOCX_APPENDIX, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Confirm the conversion tool and OCR path in the run environment.
2. Convert the acquired PDFs to DOCX before invoking the supplied TXT parser.

Validation to perform later:

- Confirm DOCX outputs are readable by the supplied parser and retain the report/DCN mapping.

### A_PYTHON_ENVIRONMENT: Prepare the documented Python environment: required Fire, Gensim, Pebble, and seaborn distributions are missing, installed versions differ from some author pins, and spaCy/model distribution presence does not verify model-weight loading. Do not treat an installed distribution as a successful model or pipeline run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_PYTHON_PACKAGES, SW_SPACY_MODEL
Evidence: E_PYTHON_REQUIREMENTS, E_PYTHON_METADATA, E_GENSIM_SOURCE, E_SEABORN_SOURCE, E_SPACY_MODEL_CALL, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Resolve the documented package/version requirements in an isolated project environment when setup is authorized.
2. Confirm the configured en_core_web_sm model resource is available to the future run.

Validation to perform later:

- Check distribution versions and model-resource availability during environment preparation, without treating metadata alone as execution verification.

### A_SAS_STATA_ENVIRONMENT: Confirm the SAS runtime/library setup and provide the missing Stata winsor2 and outreg2 ado dependencies in the analysis environment. Stata 18, reghdfe, ftools, and sicff are present; SAS readiness and the two missing ado commands remain unverified/preparation items.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_WINSOR2, SW_OUTREG2
Evidence: E_ENV_PROBE, E_STATA_VERSION, E_REHDFE_CALL, E_SICFF_PROBE, E_SICFF_CALL, E_WINSOR_CALL, E_OUTREG2_CALL, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Configure the SAS runtime and required project librefs in the future host wrapper.
2. Make the required Stata ado commands available through the approved analysis environment.

Validation to perform later:

- Confirm software command availability and expected version/configuration before the full run; no startup or syntax trial was performed in this assessment.

### A_OA8_GENERATOR_EDIT: Conditional two-line edit proposal for the supplied OA8 generator. Consider activation only after confirming that the staged OA input does not already supply compatible v_framework_r, sig_mandate_ro, and postsig_ro values and that author-intended regeneration is required. The commented save targets the same data_ready_resubmit_test.dta basename loaded by OA; preserve existing prepared values and do not regenerate or replace them when they are already supplied. No source file was edited.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: I_OA_RANDOM_GENERATOR
Evidence: E_OA_RANDOM_BLOCK, E_OA_RANDOM_END, E_OA_RANDOM_FORMULAS, E_OA_ACTIVE_RANDOM_VARS, E_OA_ACTIVE_PLACEBO, E_OA_INPUT_NAMESPACE_FACTS, E_STATA_OA_INPUT

**Proposed edit:** `SAS and STAT code and log/JAR OA Tables.do:17–17`
Source SHA-256: `0a045f17e1993705b54d8ed49d41aebb4fc9e719f13d9fa7304695d1fc14cb49`

Conditional only: activate the supplied generator after confirming the OA input lacks compatible prepared variables and the author intended regeneration.

Current text:
```
/* gen randome mandate year sig and voluntary framework 
```

Proposed replacement:
```
* gen randome mandate year sig and voluntary framework
```

**Proposed edit:** `SAS and STAT code and log/JAR OA Tables.do:35–35`
Source SHA-256: `0a045f17e1993705b54d8ed49d41aebb4fc9e719f13d9fa7304695d1fc14cb49`

Conditional only: remove the paired block terminator if the generator is confirmed necessary; do not overwrite compatible prepared values.

Current text:
```
*/
```

Proposed replacement:
```

```

Preparation / proposed procedure:

1. Before considering the proposed edit, confirm from the staged OA input schema and its documented preparation history whether the three consumed variables are already present and compatible; no input dataset was inspected in this assessment.
2. If compatible prepared values are present, preserve and use them without running the generator or replacing the input file.
3. Only if the variables are absent and author-intended regeneration is confirmed, apply the exact two-line diff to a working copy and follow the supplied generator/save recipe.

Validation to perform later:

- Confirm the input namespace and intended generation state before applying the diff or saving; line 11 input and line 33 save target the same file basename.
- When compatible variables already exist, verify they remain unchanged and do not generate new draws; if regeneration is explicitly intended, check the resulting variables against the supplied formulas before OA8 consumes them.

### A_OA8_SEED_CLARIFICATION: Ask for the original random-number seed/state only when rebuilding the generator-created placebo assignments or comparing their exact outputs. If the staged OA input already carries compatible prepared values, preserve and use them; the unknown seed/state is not a general OA8 run condition.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_OA_RANDOM_SEED
Evidence: E_OA_RANDOM_FORMULAS, E_OA_ACTIVE_PLACEBO

Preparation / proposed procedure:

1. If exact reconstruction or comparison of newly generated placebo assignments is required, request the original seed/state and intended generation history.
2. If compatible prepared values are already supplied, retain them without regenerating draws or requiring a seed for ordinary OA8 execution.

Validation to perform later:

- Record seed/state only for a confirmed rebuild or exact-output comparison; otherwise retain the supplied prepared values and document their source.

### A_FULL_PIPELINE_ORDER: After the individually identified report/list/dictionary, source, auxiliary, and variant inputs and runtime/path preparations are resolved, follow the supplied producer-consumer order. For OA8, resolve the prepared-input namespace before deciding whether to run the commented generator; existing compatible values are preserved, and regeneration is conditional on confirmed absence and author intent.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_DEPENDENCY_CLOSURE
Evidence: E_README_ORDER, E_WORKFLOW_TRACE, E_MERGE_OUTPUT, E_FINAL_SAS_OUTPUT, E_STATA_MAIN_INPUT, E_STATA_OA_INPUT, E_OA_INPUT_NAMESPACE_FACTS

Preparation / proposed procedure:

1. Stage reports, convert PDF to DOCX, parse TXT, preprocess to Feather, create sentences/phrases/Word2Vec, prepare the eight final keyword lists, and score intensity/specificity.
2. Generate boilerplate, stickyness, and separate visual/table metrics; run the figure scripts with their independent figure inputs.
3. Run SAS get-vars, align its inter_data output, run the text merge with main metrics and every variant, then run the earnings/auxiliary stage.
4. Convert/alias the final same-data SAS output to the Stata DTA input; run Main and OA workflows. Before OA8, confirm whether the input already contains compatible random/framework variables; preserve them when present and use the exact conditional generator edit only if absence and author-intended regeneration are confirmed.

Validation to perform later:

- At each handoff, check the specific producer output key/fields and downstream source-defined join; preserve all 57 registered dependency edges.
- For OA8, confirm input variable presence and intended generation before any same-file save; do not overwrite prepared values. Seed/state is needed only for a requested rebuild or exact comparison.
- Record final input paths and versions. This assessment performs no code or statistical execution.


## Remaining issues and prerequisites

- I_REPORT_LIST_PRODUCER [unresolved; full_pipeline]: short_listed_pdf.csv is consumed by preprocessing, score scripts, and figures, but no supplied producer or curation history establishes its DCN/ITEM2999 filters, period, and identifiers.
- I_DICTIONARY_CONSTRUCTION [unresolved; full_pipeline]: The supplied generator writes seven seed-category files, while scoring expects eight files including general; the appendix also describes top-1,500 common-word removal and manual inspection. The final eight-file product/hand-off is not established. The author repository's Excel candidate remains uninspected.
- I_PROJECT_AUXILIARIES [unresolved; full_pipeline]: SAS consumes named project tables for country controls, World Bank measures and population, framework counts, report links, mandate dates/ranks, governance indicators, cap-to-GDP, and country ISO mapping. Several exact keys/fields are visible, but the producers, exact measure definitions/units, and complete coverage are not supplied.
- I_ALT_BRANCH_PRODUCERS [unresolved; full_pipeline]: The supplied SAS merge independently reads fourteen bp_alt/simple/update, first-half, updated-visual, and total-text variant tables. Their producers and exact variant constructions are not present in the registered sources; preserve each as a separate required input.
- I_IBES_LIBNAME [unresolved; full_pipeline]: The SAS source reads ibes.statsumu_epsint but does not resolve the ibes library assignment in that source. The configured assignment may come from separately supplied setup; it was not inspected or tested.
- I_PYTHON_SAS_HANDOFF [preparation; full_pipeline]: Python producers emit pickle/DTA intermediates while the SAS merge expects named SAS tables. Source-supported mappings exist for intensity (seven-pillar sum as overall, doc_word_count as word_count, report-list fyear as year), boilerplate counts/ratio, specificity, stickyness, and picture/table/visuals totals. Export/aggregation and field/type checks remain preparation.
- I_VISUAL_PATHS [preparation; full_pipeline]: Visual and table producers write separate pickles under visuals/results and visuals_tables/results; the supplied figure expects a different visuals_r1/sibling layout, and both producer .dta statements use the same visual.dta target. Align the configured roots or stage the separate pickles before merging, preserving picture and table counts.
- I_SAS_ALIAS_HANDOFF [preparation; full_pipeline]: Supplied producer names include inter_data_2024 and Esg_and_allvars_resubmit_2024, while downstream SAS reads suffixless names; final SAS output is consumed in Stata as a DTA under a different name. Source fields and keys support same-logical-data name/format preparation; no byte-identical original file is required.
- I_PATH_SETUP [preparation; full_pipeline]: Python scripts contain unresolved data/result roots and Stata inputs contain Windows absolute paths. Configure coherent execution roots and relative or [redacted-path-5e6361f62a8d] paths in the authorized host wrappers; this is setup, not a missing-data or private-access barrier.
- I_DOCX_CONVERSION [preparation; full_pipeline]: The documented text pipeline requires a manual PDF-to-Word conversion before parse-to-txt.py. Solid Commander is named, but its availability and converted document output are unverified.
- I_OA_RANDOM_GENERATOR [unresolved; full_pipeline]: OA8 consumes v_framework_r, sig_mandate_ro, and postsig_ro. The supplied commented generator can define them, but it saves back to the exact data_ready_resubmit_test.dta basename loaded by the active OA analysis. The input columns and generation state are uninspected, so their absence and any need to regenerate or replace them are unknown. Keep the generator proposal conditional on confirming both the input namespace and author-intended regeneration.
- I_OA_RANDOM_SEED [unresolved; full_pipeline]: The supplied placebo generator calls runiform() without an explicit seed. The original seed/state is unknown and matters only if rebuilding generator-created draws or comparing exact placebo assignments/output; it is not a general execution condition when compatible prepared values are supplied.
- I_DEPENDENCY_CLOSURE [unresolved; full_pipeline]: Full-pipeline closure remains incomplete until the report-list and dictionary products, project-specific auxiliary tables, and all fourteen SAS variant-table producers are resolved. The linked requirements preserve each exact input and known local/public candidate.
- R_REPORT_CORPUS [undetermined]: Global annual-report documents are the raw-text input for the author's acquisition, parsing, and text-measure stages. The datasheet names Refinitiv Global Filings through RKD and says the authors downloaded them in early July 2022. Python analysis uses fiscal years 2001–2020; stickiness compares each selected report with the prior year's report for the same OAPermID. The exact report population, acquisition query, coverage, and document identities remain unspecified.
- R_REPORT_LIST [undetermined]: The supplied Python scripts and figures read short_listed_pdf.csv. Required fields include dcn, ITEM2999, fyear, OAPermID, periodEndDate, txt_file_size, OrgPermID, WsId, and countryCode. Preprocessing filters on ITEM2999 and intersects report-list DCNs with available text-file DCNs. No producer or exact curation/filter history for this list was found in the registered workflow.
- R_KEYWORD_LISTS [undetermined]: Scoring and SAS handoffs consume final category keyword lists. The scoring/common-keyword code requires eight text files, including general; the supplied seed-word generator writes seven category files using a top-500 candidate step. The appendix describes later top-1,500 common-word removal and manual dictionary inspection. The author repository lists ES-dictionary.xlsx as a candidate, but its contents and compatibility with the eight consumed lists are uninspected.
- R_COUNTRY_LOOKUP [undetermined]: Figure 4 reads country_name and code.xlsx, Sheet3, and uses sample and code to map country labels and codes. No producer or local workbook probe is registered.
- R_INTER_INDUSTRY [undetermined]: Figure IA reads inter_industry.dta and merges ffind5 by WsId and fyear. The code does not supply its producer or the underlying industry-code definition.
- R_FRAMEWORK_COUNTS [undetermined]: Figure 5 reads esg_framework_keywords_counts.pkl, filters fyear, and uses six long framework names and their short codes. No producer for this figure input appears in the registered sources.
- R_COUNTRY_TRANS [undetermined]: SAS joins xxx.country_trans by nation and year_. The earnings program uses mag_accrual_cf, ratio_small, smooth_acc_cf, and corr_cf for its country-year ranks; exact table history, row construction, and other columns remain unspecified.
- R_WB_DATA [undetermined]: The earnings SAS program joins xxx.wb_data by iso3=country and fyear=year, then includes its fields in the country-year panel. The specific World Bank indicator series, units, and variable names needed by the output are not fully specified.
- R_POPULATION [undetermined]: SAS independently joins xxx.population by country and year and consumes population. The exact series definition, units, and required period are unspecified.
- R_ESG_FRAMEWORK [undetermined]: The earnings SAS program joins xxx.esg_framework on ws_id=wsid and fyear, then reads counts for CDSB, CDP, GRI, IIRC, TCFD, and SASB. Their source fields, construction, and coverage are not supplied.
- R_REPORT_LINK [undetermined]: The earnings SAS program reads xxx.esg_report_list_link, filters form_name values, and links wsid/fyear records to the panel. No producer, report-list coverage, or identifier mapping is supplied.
- R_MANDATE_DATE [undetermined]: The earnings SAS program uses mandate_date for ISO2 joins, effective dates, integrated-report flags, and rank1–rank6 assignments. The source and construction of those dates, flags, and ranks are not supplied.
- R_WGI [undetermined]: The earnings SAS program joins xxx.wgidata by iso3=code and fyear=year, consuming 12 governance fields. The indicators' exact definitions, units, and period remain unspecified.
- R_CAPTOGDP [undetermined]: The earnings SAS program joins xxx.captogdp by country_code/year and renames col1 to captogdp. The calculation behind col1, units, and coverage are not provided.
- R_COUNTRY_ISO [undetermined]: The text-data SAS merge joins xxx.country_iso by lowercased nation/WBCountryName and consumes iso2, iso3, and WBCountryName. No mapping-table producer or coverage specification is supplied.
- R_WS_FUNDA [undetermined]: SAS uses annual Worldscope fundamentals keyed by code/year, filters on frequency, item6105, year_, item5350, and item2999, and maps the listed fundamentals and controls. It joins the prior fiscal-year record (current fyear=prior fyear+1) to construct lagged values; exact beginning coverage and full history are unverified.
- R_WS_COMPANY [undetermined]: SAS uses Worldscope company fields to map nation, GIC, industry group, and SIC by code, then joins that row to the annual panel. This is a current company/identifier lookup in the supplied code; no separate historical entity panel is established.
- R_WS_STOCK [undetermined]: SAS joins annual Worldscope stock fields to fundamentals on code and year_. The full required annual panel and its field coverage remain unverified.
- R_DS2WS_LINK [undetermined]: SAS maps Worldscope code to the DataStream infocode through the DS2WS link table. Required link coverage and any historical link changes are not verified.
- R_DATASTREAM [undetermined]: SAS computes yr_ret=exp(sum(log(1+ret)))-1 and ret_vol=std(ret) over rows with l1datadate < marketdate <= datadate, joined by infocode. It needs daily observations for that source-defined date span for each annual row; full coverage, adjustment/product definition, and history are not established by a one-row probe.
- R_IBES [undetermined]: SAS filters I/B/E/S statsumu_epsint to fpi="1", retains ticker, fiscal-period/date and forecast-dispersion/count fields, and joins to the fundamentals by ticker and year/month of datadate/fpedats. Its LIBNAME assignment is unresolved in the supplied source; full date and identifier coverage are unverified.
- R_OWNERSHIP [undetermined]: SAS aggregates institutional SharesHeld by Sedol/QtrDate and selects the maximum qualifying QtrDate for each datadate. Its authored YYYYMM condition is qtrdate_yyyymm <= datadate_yyyymm < qtrdate_yyyymm+100. The candidate probe does not establish matching history or full coverage of those per-row windows.
- R_REFINITIV_ESG_SUMMARY [undetermined]: SAS reads Refinitiv WRDS company summary scores, filters nonmissing overall_score and nonzero OrgID, and retains OrgID, score, fiscal year, and fiscal year-end date. Identifier mapping and full firm-year coverage are unverified.
- R_REFINITIV_ESG_INFO [undetermined]: SAS joins Refinitiv company info to score data by OrgID and later matches Sedol/ISIN fields to the annual panel. The probe does not verify identifier-history or panel coverage.
- R_BP_ALT [undetermined]: The text-data merge consumes the bp_alt variant by dcn for boiler_alter_count_per and boiler_alter_word_count_per; no producer is supplied.
- R_BP_SIMPLE [undetermined]: The text-data merge consumes bp_simple by dcn and uses esg_boilerplate_percent; no producer is supplied.
- R_BP_SIMPLE_UPDATE [undetermined]: The text-data merge separately consumes bp_simple_update by dcn and uses esg_boilerplate_percent; no producer is supplied.
- R_BP_FH [undetermined]: The text-data merge consumes the first-half boilerplate variant bp_fh by dcn; no producer or first-half filter is supplied.
- R_INTENSITY_FH [undetermined]: The merge consumes intensity_fh by dcn and reads the seven category intensities, general, and doc_word_count; no first-half producer is supplied.
- R_SPECIFICITY_FH [undetermined]: The merge consumes specificity_fh by dcn for esg_specificity; no first-half producer is supplied.
- R_STICKY_FH [undetermined]: The merge consumes sticky_fh by dcn for stickyness; no first-half producer is supplied.
- R_VISUAL_FH [undetermined]: The merge consumes visual_fh by dcn for picture and table counts; no first-half visual/table producer is supplied.
- R_VISUAL_NEW [undetermined]: The merge separately consumes visual_new by dcn for picture count, table count, and visuals; no updated-visual producer is supplied.
- R_TOTAL_BP [undetermined]: The merge consumes total_bp by dcn and derives boilerplate_percent_total from count_boilerplate/count_sents; no producer is supplied.
- R_TOTAL_SPECIFICITY [undetermined]: The merge consumes total_specificity by dcn for specificity; no producer is supplied.
- R_TOTAL_STICKY [undetermined]: The merge consumes total_sticky by dcn for stickyness; no producer is supplied.
- R_TOTAL_VISUAL_P [undetermined]: The merge consumes total_visual_p by dcn for pic_count; no producer is supplied.
- R_TOTAL_VISUAL_T [undetermined]: The merge consumes total_visual_t by dcn for table_count; no producer is supplied.
- SW_PYTHON_PACKAGES [preparation_required]: requirements.txt pins Fire 0.5.0, Gensim 4.2.0, Pebble 5.0.3 and other versions. Current metadata shows Fire, Gensim, and Pebble missing; figure code imports seaborn, also missing. Several installed distributions differ from the pins. No package was installed.
- SW_SPACY_MODEL [unverified]: The preprocessing calls spacy.load("en_core_web_sm"). Distribution metadata exists, but model weights were not loaded; metadata alone does not verify that the required model is usable.
- SW_SOLID_COMMANDER [unverified]: The appendix names Solid Commander for the manual PDF-to-Word stage. Its availability and output compatibility were not checked.
- SW_SAS [unverified]: The registered environment probe reports SAS status unverified. No SAS process or startup diagnostic was run; SAS 9.4 is required by the supplied SAS programs.
- SW_WINSOR2 [preparation_required]: The supplied main-table script calls winsor2. The registered environment probe reports it unavailable in the default environment.
- SW_OUTREG2 [preparation_required]: The supplied main and OA tables call outreg2. The registered environment probe reports it unavailable in the default environment.

## Review notes

- The assigned scope is the complete supplied author workflow across report acquisition/parsing, Word2Vec and scoring, figure generation, SAS preparation/merges, and the main and OA Stata analyses. The packaged JAR_identifier.dta probe is an identifier-list sample, not an analysis panel, so it does not support a separate analysis_only scope.
- All 57 registered dependency edges were reviewed in producer-consumer order. The 45 review rows group only homogeneous edges to the same logical input; the fourteen independently consumed SAS variants remain separate requirements. See E_WORKFLOW_TRACE.
- Known source-supported preparation includes report/field mapping across Python and SAS, documented same-data filename aliases, standard SAS7BDAT-to-DTA conversion, configured path alignment, separate visual/table pickle staging, and the proposed OA8 generator edit. No original-byte or data-vintage gate is imposed.
- Specific unresolved contracts remain for the global report route, short_listed_pdf.csv producer/filter history, final eight keyword lists and manual filtering, three figure-only inputs, nine distinct SAS auxiliary tables and exact public World Bank/population series, fourteen variant producers/definitions, and the ibes libref. Source-known fields, keys, and calculation windows remain credited where supplied; unknown fields, history, coverage, and constructions remain specific unknowns.
- Commercial candidate probes were bounded to one row and do not establish whole-product coverage. The Worldscope fundamentals probe timed out once; it was not repeated and is not treated as absence or an access barrier. Other local candidates remain subject only to their stated required source fields, keys, and periods.
- Public checks and local document-root checks were metadata/listing observations only. SEC raw/parsed files and LM10-X are candidates, not presumed substitutes for the described global RGF report population. No PDF, workbook, archive, report, model, or data payload was requested or downloaded.
- The exact NLTK and PyArrow availability rows cite a new saved stdlib importlib.metadata-only probe. The NLTK source locator was also static source/token/hash inspection only; no NLTK module, corpus, model, or author NLP code was imported or called.
- Registered source files were fully byte-screened before candidate-free source windows were displayed. Authentication, connection, example, and raw-log blocks remain opaque. No author program, SAS, Stata, statistical, parser, model, or syntax trial was run, and no packages were installed.
- Earlier helper, safe-reader range, and draft-construction errors/captures remain preserved under probes. They are process-only records and are not cited as scientific, data-access, or software feasibility barriers.
- The supplied OA8 generator edit remains conditional and proposal-only. The safe source-fact record shows the active OA input and commented save share the data_ready_resubmit_test.dta basename; the input namespace and generation state remain uninspected, so neither missing variables nor a need to regenerate is established. Preserve compatible prepared values if supplied. The seed/state remains unknown only for a confirmed rebuild or exact placebo-output comparison, not as a general OA8 gate.
