# Patch proposal: jar-189cb8693dae

Diversity Washing

DOI: 10.1111/1475-679X.12542

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented data construction and analysis workflow.

Entry points: `analysis_code/figures/01. time_series_and_heat_maps.R`, `analysis_code/figures/02. dei_words_over_time.R`, `analysis_code/figures/03. diversity_box_plots.R`, `analysis_code/figures/04. dei_topics_over_time.R`, `analysis_code/tables/01. summary_statistics.R`, `analysis_code/tables/02. correlation_tables.R`, `analysis_code/tables/03. determinants_disclosure_analyses.R`, `analysis_code/tables/04. bivariate_diversity_washing.R`, `analysis_code/tables/06. univariate_sample_comparisons.R`, `analysis_code/tables/07. diversity_washing_multivariate.R`, `analysis_code/tables/08. goodjobsfirst_analyses.R`, `analysis_code/tables/09. reprisk_diversity_washer_analysis.R`, `analysis_code/tables/10. refinitiv_target_policy_analyses.R`, `analysis_code/tables/11. csr_twitter_analyses.R`, `analysis_code/tables/12. employee_outcome_analyses_diversity.R`, `analysis_code/tables/13. cross_diversity_gender_ethnic.R`, `analysis_code/tables/14. dw_forwardlooking_weasels_dei.R`, `analysis_code/tables/15. analysis_dw_interactions.R`, `analysis_code/tables/16. esg_rating_analyses.R`, `analysis_code/tables/17. ownership_analyses.R`, `analysis_code/tables/18. analysis_dei_sentence_fraction_among_topics.R`, `analysis_code/tables/19. vagueness_weasel_analysis.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 5/12542 - Diversity-Washing/blmsw-datasheet-code-and-identifiers.zip",
      "sha256": "27f4bed6967363516ecb09a4a82c79440dd56d277f1f1cdd8b75a5ea13cab1d8"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "bdc2c854358024c20f7125693def508e6bfa55b458009c41befdac7f130c2d51"
}
```

## Proposed actions

### ACT_PREP_KEYWORDS_IDENTIFIERS: Stage the separate packaged keyword files and firm-identifier input at their source-configured locations. Follow reader settings actually supported by source evidence; validate coverage during preparation without inferring headers or requiring downstream keys on the identifier list.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_FIRM_IDENTIFIERS, R_KEYWORDS, R_KEYWORDS_DROPPED, R_KEYWORDS_GENDER, R_KEYWORDS_ETHNIC, R_KEYWORDS_FORWARD, R_GENERIC_KEYWORDS_BOTH, R_GENERIC_KEYWORDS_NEITHER, ISSUE_IDENTIFIER_MAPPING
Evidence: E_PACKAGE_INVENTORY, E_FINAL_MERGE_KEYS, E_README_PIPELINE

Preparation / proposed procedure:

1. Use the observed packaged locations and file-level readability metadata; keep the lists separate.
2. Apply the pipe-delimited/header=None interpretation only where the approved CSR source expressly specifies it; do not treat generic first-record labels as variable names for header=None readers.
3. Validate firm coverage and downstream join compatibility during data preparation; require extra columns only where a reviewed consumer reads them.

Validation to perform later:

- Confirm headers, encodings, identifier types, and mapping coverage with bounded metadata checks.
- Confirm each keyword list is consumed by the intended disclosure or CSR branch.

### ACT_PREP_SEC_EDGAR: Use the supported SEC EDGAR public index and filing-text route for the documented form/period selection, and stage the separate author-format form-index CSV. Align the index, filing documents, and downstream feature paths; verify local form, year, and section coverage before running the EDGAR branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_SEC_FILINGS, R_WRDS_FORM_INDEX, ISSUE_SEC_DOCUMENT_COVERAGE, ISSUE_EDGAR_PATH_ALIGNMENT
Evidence: E_SEC_PUBLIC_INDEX, E_SEC_PUBLIC_RAW, E_EDGAR_FORM_PERIOD, E_WRDS_INDEX_CONFIG, E_EDGAR_CONSUMER_PATH_CONFIG, E_DATASHEET_SEC

Preparation / proposed procedure:

1. Prepare the author-format form-index CSV as a separate input.
2. Stage SEC index and raw filing text using the documented EDGAR route and expected local layout.
3. Map filing identifiers and form/year selection through the index and feature stages.

Validation to perform later:

- Check bounded index-to-document matches for the documented forms and construction years.
- Confirm local document and text-section coverage and producer-consumer path alignment.

### ACT_PREP_REVELIO: Stage the author-format monthly Revelio records as a distinct input. Preserve the monthly rows needed by annual construction and confirm gvkey, permno, month, and selected measures against the supplied producer. Confirm the exact annual output path/schema connection to the final merge under ISSUE_REVELIO_OUTPUT_CONTRACT before treating that product as generated.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_REVELIO_MONTHLY, ISSUE_VENDOR_SCHEMA_KEYS, ISSUE_REVELIO_OUTPUT_CONTRACT
Evidence: E_DATASHEET_REVELIO, E_REVELIO_FIELDS

Preparation / proposed procedure:

1. Locate the author-prepared monthly Revelio collection and verify its format.
2. Map the consumer fields and identifiers while retaining the original monthly observations.
3. Confirm the producer's annual output contract and final-merge path before execution.

Validation to perform later:

- Check required columns, identifier types, month coverage, and annual aggregation keys with bounded metadata.
- Confirm the producer's annual output name/schema against the final consumer before marking the dependency generated.

### ACT_PREP_COMPUSTAT_CRSP: Stage Compustat annual fundamentals, Compustat names, and CRSP monthly stock records as distinct inputs. Confirm their specific columns, identifier links, and date coverage against each supplied producer, then construct annual stock/fundamentals outputs through the documented workflow.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMPUSTAT_FUNDAMENTALS, R_COMPUSTAT_NAMES, R_CRSP_STOCK_MONTHLY, ISSUE_VENDOR_SCHEMA_KEYS, ISSUE_FINAL_PANEL_KEYS_HISTORY
Evidence: E_DATASHEET_COMPUSTAT, E_DATASHEET_CRSP, E_CATALOG_COMP_FUNDA, E_CATALOG_COMP_NAMES, E_CATALOG_CRSP_MSF, E_FINAL_MERGE_KEYS, E_FINAL_MERGE_HISTORY

Preparation / proposed procedure:

1. Keep Compustat fundamentals, Compustat names, and CRSP monthly records separate.
2. Check each catalog candidate's fields, identifiers, and year coverage against its producer.
3. Generate annual stock/characteristics intermediates from these inputs before the final merge.

Validation to perform later:

- Confirm identifier mapping, key uniqueness assumptions, and monthly/annual date coverage.
- Confirm generated outputs use the final merge's gvkey/permno/year keys.

### ACT_PREP_OWNERSHIP: Keep the raw CRSP fund-holdings inputs, ownership SAS product, and cleaned by-name/by-list measures distinct. Confirm the author-prepared holdings and ownership_SAS_output.csv fields, identifiers, years, and producer-consumer paths; no SAS execution is required to establish this contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CRSP_HOLDINGS, ISSUE_OWNERSHIP_PATH_ALIGNMENT, ISSUE_OWNERSHIP_SAS_OUTPUT
Evidence: E_DATASHEET_CRSP, E_OWNERSHIP_SOURCE_INPUTS, E_OWNERSHIP_RAW_SOURCE, E_OWNERSHIP_OUTPUT_PATHS, E_FINAL_MERGE_INPUTS, E_OWNERSHIP_BYNAME_PRODUCER, E_OWNERSHIP_BYLIST_PRODUCER, E_OWNERSHIP_RAW_HOLDINGS_PRODUCER

Preparation / proposed procedure:

1. Stage the author-prepared CRSP holdings and identifier tables separately.
2. Confirm the annual SAS output schema and source path from an approved non-executing review or existing author-prepared artifact.
3. Align the raw producer, cleaner outputs, and annual merge input paths.

Validation to perform later:

- Check bounded headers, identifier types, years, and output-path agreement.
- Confirm the by-name/by-list products are generated by the supplied cleaner before final merge.

### ACT_PREP_CSR: Stage the author-prepared Corporate Register report text and CSR-to-CRSP/CCM link as separate inputs. Confirm report coverage, company identifiers, and link keys before generating CSR features.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CSR_REPORT_TEXT, R_CSR_LINK
Evidence: E_DATASHEET_CORPREG, E_CSR_KEYWORD_PARSE, E_CSR_FEATURE_OUTPUT

Preparation / proposed procedure:

1. Locate the author-prepared Corporate Register text collection.
2. Stage the separate CSR-to-CRSP/CCM link table.
3. Run the supplied parser only after the report and link inputs are aligned.

Validation to perform later:

- Check report identifiers, dates, text availability, and link keys with bounded metadata.
- Confirm the generated CSR feature output matches the downstream consumer.

### ACT_PREP_TWITTER: Use compatible author-prepared/local Twitter handle, raw-record, firm-year-feature, and company-link artifacts as four distinct inputs. Confirm each artifact's fields, collection period, population, feature definitions, and company-link keys from an approved safe specification before running the supplied Twitter stages.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_TWITTER_HANDLES, R_TWITTER_RAW, R_TWITTER_FEATURES, R_TWITTER_LINK, ISSUE_TWITTER_SCHEMA_CONTRACT
Evidence: E_DATASHEET_TWITTER, E_FROZEN_DEPENDENCIES, E_FINAL_MERGE_INPUTS

Preparation / proposed procedure:

1. Stage the four author-prepared/local Twitter artifacts separately.
2. Record their field, period, population, and link contracts without exposing protected configuration or source values.
3. Align the feature and link outputs with the disclosure consumer.

Validation to perform later:

- Check bounded schemas, dates, and company-link coverage against the supplied consumers.
- Confirm feature and link files are generated or supplied before disclosure construction.

### ACT_PREP_GJF: Stage the current Good Jobs First tracker and its current Compustat crosswalk as separate inputs for the annual enforcement measures. The supplied script also opens an older snapshot and crosswalk for a column-difference diagnostic; provide both for an unchanged run, or obtain an owner-reviewed change that skips only those diagnostic reads.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_GJF_CURRENT, R_GJF_LINK_NEW, ISSUE_GJF_LEGACY_READS
Evidence: E_DATASHEET_GJF, E_GJF_ACTIVE_LINK, E_GJF_FIELDS, E_FROZEN_DEPENDENCIES

Preparation / proposed procedure:

1. Stage the current tracker and current company-history crosswalk separately.
2. Confirm the current raw fields, crosswalk keys, and penalty-year coverage.
3. Satisfy both legacy diagnostic reads for an unchanged source run, or document an owner-reviewed narrow change before execution.

Validation to perform later:

- Check the current tracker/link fields and company identifiers with bounded metadata.
- Confirm the unedited script's legacy-read prerequisites or the reviewed source change before running the branch.

### ACT_PREP_ESG_INPUTS: Keep the Refinitiv summary, social, environment, and company-information tables separate from the Sustainalytics weighted-score table and from both provider-specific CRSP/CCM links. Confirm required fields, identifiers, dates, and duplicate handling against the ESG producer before joining them.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_REFINITIV_SUMMARY, R_REFINITIV_SOCIAL, R_REFINITIV_ENVIRONMENT, R_REFINITIV_INFO, R_SUSTAINALYTICS_WEIGHTS, R_REFINITIV_LINK, R_SUSTAINALYTICS_LINK, ISSUE_VENDOR_SCHEMA_KEYS
Evidence: E_DATASHEET_REFINITIV, E_DATASHEET_SUSTAINALYTICS, E_CATALOG_REFINITIV_SUMMARY, E_CATALOG_REFINITIV_INFO, E_CATALOG_SUSTAINALYTICS, E_ESG_REFINITIV_SOURCE_TABLES, E_ESG_REFINITIV_INFO_SOURCE, E_ESG_REFINITIV_LINK, E_ESG_SUSTAINALYTICS_LINK, E_ESG_JOIN

Preparation / proposed procedure:

1. Stage each provider table and link file as a distinct input.
2. Map provider identifiers and reporting dates to the producer's join keys.
3. Run the supplied ESG producer after the separate inputs and paths are confirmed.

Validation to perform later:

- Check each source table's required columns, keys, period, and duplicates with bounded metadata.
- Confirm the generated ESG product preserves the documented full join and downstream keys.

### ACT_PREP_REPRISK_INPUTS: Stage the RepRisk company-ID table, company-identifiers table, and risk-incidents table as separate inputs. Confirm their exact keys, fields, date coverage, and crosswalk behavior against the supplied retrieval/link/cleaning stages; the annual incident count is a generated product.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_REPRISK_COMPANY_ID_TABLE, R_REPRISK_COMPANY_IDENTIFIERS, R_REPRISK_RISK_INCIDENTS, ISSUE_VENDOR_SCHEMA_KEYS
Evidence: E_DATASHEET_REPRISK, E_CATALOG_REPRISK_COMPANY_ID, E_CATALOG_REPRISK_IDENTIFIERS, E_CATALOG_REPRISK_V2, E_REPRISK_LINK_SOURCE, E_REPRISK_AGG

Preparation / proposed procedure:

1. Map each exact catalog candidate to its distinct author input table.
2. Confirm source columns, company identifiers, incident dates, and required history.
3. Generate linked and annual RepRisk products through the supplied stages.

Validation to perform later:

- Check required fields and coverage for each table without treating a catalog hit as proof of compatibility.
- Confirm generated annual rows use the final panel's identifier/year keys.

### ACT_PREP_LM_SENTENCE_RESOURCES: Stage a compatible Loughran–McDonald dictionary, author-format cleaned sentence Feather corpus, and all-mpnet-base-v2 model resource. Map the exact sentence consumer columns and category definitions; the public current dictionary is a supported route, and its revision label alone is not a byte-identity gate. Separately confirm the wholly withheld final topic-fraction cleaner's input/output contract before treating its RDS as generated.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_LM_DICTIONARY, R_SENTENCE_CORPUS, R_SENTENCE_MODEL, R_TOPIC_FRACTION_RDS, SW_NLTK_CORPORA, SW_SENTENCE_MODEL_RESOURCE, ISSUE_LM_SCHEMA_COMPATIBILITY, ISSUE_SENTENCE_SCHEMA_RESOURCES, ISSUE_TOPIC_FRACTION_PRODUCER
Evidence: E_LM_CURRENT_VERSION, E_LM_ACADEMIC_USE, E_LM_SCHEMA_FIELDS, E_SENTENCE_CORPUS_READ, E_SENTENCE_MODEL_NAME, E_SENTENCE_FEATURE_OUTPUT, E_SENTENCE_TOPIC_OUTPUT, E_SENTENCE_TOPIC_FRACTION_OUTPUT, E_NLTK_RESOURCES

Preparation / proposed procedure:

1. Compare the dictionary's supported category fields to the consumer's required fields.
2. Confirm the corpus format, columns, history, and sentence-to-firm-year mapping.
3. Check whether the named model and required NLTK resources already exist in an authorized local cache.
4. Obtain an approved specification for the withheld topic-fraction cleaner and its final RDS contract.

Validation to perform later:

- Check dictionary categories and corpus/model resource availability with bounded metadata only.
- Confirm exact input/output fields and firm-year keys for each sentence stage before running it.
- Confirm the topic-fraction final product is supported by its actual producer or author-prepared artifact.

### ACT_RESOLVE_FINAL_PANEL_INPUTS: Confirm the actual producer or author-prepared route and schema for the annual DEI/ESG hiring product and final twenty-topic fraction product. Resolve their firm-year keys and history alongside the final merge's gvkey/permno/year joins, 2008–2021 estimation filter, and one-to-four-year leads; generated panel intermediates need not exist before their producers run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DEI_HIRING_RDS, R_TOPIC_FRACTION_RDS, ISSUE_DEI_HIRING_PRODUCER, ISSUE_TOPIC_FRACTION_PRODUCER, ISSUE_FINAL_PANEL_KEYS_HISTORY, ISSUE_DISCLOSURE_OUTPUT_CONTRACT
Evidence: E_FINAL_MERGE_INPUTS, E_FINAL_MERGE_KEYS, E_FINAL_MERGE_YEAR_FILTER, E_FINAL_MERGE_HISTORY, E_SENTENCE_TOPIC_FRACTION_OUTPUT, E_EDGAR_FORM_PERIOD

Preparation / proposed procedure:

1. Confirm the DEI/ESG hiring product's source, fields, keys, and year coverage.
2. Confirm the final topic-fraction cleaner's actual inputs, output schema, and construction history.
3. Map all generated products to their producer and consumer paths before the annual panel merge.

Validation to perform later:

- Check key uniqueness, date coverage, and lead-variable history against the actual producer outputs.
- Confirm final merge input schemas and the order in which annual products are generated.

### ACT_CONFIGURE_PRODUCER_PATHS: Configure the documented workspace-relative locations for the EDGAR index/features and ownership raw/cleaned outputs so each producer writes the product consumed by the next stage. Keep the configured relative corpus filepath as ordinary workflow metadata and preserve each producer-consumer relationship.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISSUE_EDGAR_PATH_ALIGNMENT, ISSUE_OWNERSHIP_PATH_ALIGNMENT
Evidence: E_EDGAR_CONSUMER_PATH_CONFIG, E_WRDS_INDEX_CONFIG, E_OWNERSHIP_SOURCE_INPUTS, E_OWNERSHIP_OUTPUT_PATHS, E_OWNERSHIP_BYNAME_PRODUCER, E_OWNERSHIP_BYLIST_PRODUCER, E_OWNERSHIP_RAW_HOLDINGS_PRODUCER

Preparation / proposed procedure:

1. Resolve the relative data layout under the intended project workspace.
2. Map each producer output to the matching consumer path without changing the data contract.
3. Record path-only configuration separately from source and data requirements.

Validation to perform later:

- Check that expected directories exist and producer and consumer path strings resolve to the same files.
- Confirm no generated output is mistaken for an independent pre-run data requirement.

### ACT_SETUP_REQUIRED_SOFTWARE: Use the checked Python and R runtimes and prepare only the missing Python/R packages listed in the software inventory in an approved environment. Confirm the required NLTK corpora and sentence-model resource from an authorized local source; no package installation or model download has been performed.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_PYTHON, SW_R, SW_PY_NUMPY, SW_PY_PANDAS, SW_PY_NLTK, SW_PY_TQDM, SW_PY_GENSIM, SW_PY_SENTENCE_TRANSFORMERS, SW_PY_SCIKIT_LEARN, SW_PY_PYTHON_DOTENV, SW_R_TIDYVERSE, SW_R_DPLYR, SW_R_READR, SW_R_TIDYR, SW_R_LUBRIDATE, SW_R_GGPLOT2, SW_R_DESCTOOLS, SW_R_STRINGR, SW_R_PURRR, SW_R_OPENXLSX, SW_R_READXL, SW_R_DATA_TABLE, SW_R_SQLDF, SW_R_COWPLOT, SW_R_RPOSTGRES, SW_R_HERE, SW_R_LMTEST, SW_R_SANDWICH, SW_R_TIBBLE, SW_R_FIXEST, SW_R_MODELSUMMARY, SW_R_BINSREG, SW_R_GGTHEMES, SW_R_PALS, SW_R_PATCHWORK, SW_PY_PYARROW, SW_R_KABLEEXTRA, SW_R_GLUE, SW_NLTK_CORPORA, SW_SENTENCE_MODEL_RESOURCE
Evidence: E_SOFTWARE_MAIN, E_SOFTWARE_R_MAIN, E_SOFTWARE_R_EXTRA, E_SOFTWARE_R_ANALYSIS, E_NLTK_RESOURCES, E_SENTENCE_MODEL_NAME, E_SOFTWARE_RUNTIME_ORIGINAL, E_SOFTWARE_PY_DISTRIBUTIONS_NORMALIZED, E_SOFTWARE_PY_DISTRIBUTIONS_SOURCE

Preparation / proposed procedure:

1. Retain the available Python, R, and package versions recorded in the safe software captures.
2. Install or configure only the missing packages required by the complete workflow after selecting a compatible environment.
3. Check NLTK corpora and the named model resource using a safe availability check, without loading study data or author programs.

Validation to perform later:

- Confirm every required package is available in the intended Python/R environments.
- Confirm NLTK corpora and model-resource availability, or keep their status unresolved until confirmed.

### ACT_RUN_FULL_ORDERED_WORKFLOW: After inputs, paths, producer contracts, software, and actual master calls/order are confirmed, follow the confirmed cleaning workflow through its producers and final annual merge, then run all 22 documented figure/table analysis entry points. Preserve the documented branches and verify generated intermediate outputs before downstream consumers run.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISSUE_FINAL_PANEL_KEYS_HISTORY, ISSUE_DISCLOSURE_OUTPUT_CONTRACT, ISSUE_TOPIC_FRACTION_PRODUCER, ISSUE_OWNERSHIP_SAS_OUTPUT, ISSUE_GJF_LEGACY_READS, ISSUE_MASTER_STAGE_CALLS
Evidence: E_README_PIPELINE, E_PACKAGE_INVENTORY, E_FINAL_MERGE_INPUTS, E_FINAL_MERGE_KEYS, E_SENTENCE_TOPIC_FRACTION_OUTPUT, E_OWNERSHIP_OUTPUT_PATHS, E_GJF_FIELDS

Preparation / proposed procedure:

1. Prepare and verify each distinct raw input and required software dependency.
2. Confirm the actual master stage calls and order from an approved complete source view or other authorized confirmation; treat the frozen dependency list as recorded edges, not proof of executable calls.
3. Follow the confirmed cleaning workflow, checking each producer output before its downstream consumer.
4. Run the final annual merge after every required input and generated product is ready.
5. Run the complete supplied analysis entry-point set after the final panel is produced.

Validation to perform later:

- Compare generated product schemas, keys, and periods to their consumers at each stage.
- Confirm final panel keys, year coverage, and one-to-four-year lead history.
- Record command exit status and output presence for every documented branch.
- Confirm the actual master-script include order and producer outputs before relying on those annual intermediates.


## Remaining issues and prerequisites

- ISSUE_IDENTIFIER_MAPPING [preparation; full_pipeline]: Bounded package metadata confirms a readable firm-identifier CSV with a physical gvkey header, but it did not inspect row values, firm coverage, or periods. Validate that coverage against the actual consumer during panel preparation. Do not infer that this separate list must itself supply permno and year without a specific consumer contract.
- ISSUE_SEC_DOCUMENT_COVERAGE [unresolved; full_pipeline]: The SEC filings route and form-period selection are documented, but the required filing population, local document coverage, and resulting text-section coverage have not been verified for the construction period.
- ISSUE_DISCLOSURE_OUTPUT_CONTRACT [unresolved; full_pipeline]: The supplied EDGAR disclosure stage is part of the documented workflow and the final merge consumes its annual disclosure products. Confirm the producer's exact output names, fields, identifier keys, and construction history from an approved complete source view before treating those products as ready.
- ISSUE_EDGAR_PATH_ALIGNMENT [preparation; full_pipeline]: The index and feature stages use configured paths whose alignment with the checked workspace and the documented downstream paths has not been verified. Configure the expected layout and confirm the producer-consumer paths before running those stages.
- ISSUE_OWNERSHIP_PATH_ALIGNMENT [preparation; full_pipeline]: The ownership workflow has distinct raw and cleaned outputs; confirm that the configured producer paths resolve to the paths consumed by the annual stock-characteristics merge.
- ISSUE_OWNERSHIP_SAS_OUTPUT [unresolved; full_pipeline]: The annual stock-characteristics stage reads ownership_SAS_output.csv, but its exact producer, columns, identifier keys, and year coverage are not established. Confirm a compatible author-prepared/local output and its contract; no SAS execution was used to infer it.
- ISSUE_GJF_LEGACY_READS [preparation; full_pipeline]: The older Good Jobs First snapshot and crosswalk feed a column-difference diagnostic, not the annual analytical product, but the supplied unedited script reads them. To run that script unchanged, provide both files at the expected paths; alternatively, an owner-reviewed change may skip only these unused diagnostic reads. No such edit is applied or assumed here.
- ISSUE_FINAL_PANEL_KEYS_HISTORY [preparation; full_pipeline]: The reviewed workflow defines final joins on gvkey/permno/year or gvkey/year and constructs one- through four-year leads. Check key uniqueness, observed period coverage, and lead availability as ordinary validation after the separate inputs are prepared; those empirical results are not shown by bounded package metadata and do not by themselves imply a missing input.
- ISSUE_VENDOR_SCHEMA_KEYS [unresolved; full_pipeline]: Catalog records identify candidate Compustat, CRSP, Revelio, Refinitiv, Sustainalytics, and RepRisk tables, but do not establish all consumer-required column names, identifier mappings, duplicate handling, and period coverage. Confirm those specific schemas against each separate input and link table before combining them.
- ISSUE_DEI_HIRING_PRODUCER [unresolved; full_pipeline]: The final merge consumes dei_esg_hiring_annual.RDS, but no producer or compatible field/key/history contract is established in the reviewed workflow. Confirm the supplied author-prepared product or its supported producer before treating this required final input as available.
- ISSUE_TOPIC_FRACTION_PRODUCER [unresolved; full_pipeline]: The sentence-topic stage supplies an intermediate, but the final topic-fraction cleaner's implementation is wholly withheld from the safe view. Its exact input/output fields, firm-year keys, and construction/history contract remain unknown; confirm those details before treating sentence_topic_mention_fraction_20topics.RDS as produced.
- ISSUE_TWITTER_SCHEMA_CONTRACT [unresolved; full_pipeline]: The datasheet documents the Twitter source, and the workflow has separate handle, raw, feature, and firm-link artifacts. Their exact schemas, population/time coverage, feature construction, and company-link keys cannot be confirmed from the wholly withheld Twitter program bodies; use compatible author-prepared/local artifacts and confirm those specific contracts.
- ISSUE_LM_SCHEMA_COMPATIBILITY [unresolved; full_pipeline]: A current public academic-use Loughran–McDonald dictionary is a supported route and documents seven sentiment category identifiers. The exact consumer-required category fields and definitions still need to be mapped to the supplied sentence-feature code; the revision label alone is not treated as a missing-data or byte-identity gate.
- ISSUE_SENTENCE_SCHEMA_RESOURCES [unresolved; full_pipeline]: The workflow names a Feather corpus input and the all-mpnet-base-v2 sentence model, but corpus columns and period, exact feature/topic output schema, and local NLTK/model-resource availability have not been verified. Confirm the consumer fields and existing compatible resources before running the sentence branch.
- ISSUE_REVELIO_OUTPUT_CONTRACT [unresolved; full_pipeline]: The master includes a Revelio annual-construction stage and the final merge consumes a diversity-metrics annual RDS. The reviewed source evidence establishes the monthly Revelio field selection and final consumption, but does not bind that producer to the exact final input path/schema. Confirm the producer output path, fields, and period from the approved safe producer view before treating that RDS as a generated dependency.
- ISSUE_MASTER_STAGE_CALLS [unresolved; full_pipeline]: The pinned safe view of the cleaning master script is wholly withheld. The frozen dependency list records seven producer/merge include edges for Compustat, CRSP, Revelio, stock/ownership, ESG, Good Jobs First, and the final merge, but no literal call or execution order is visible to verify those edges from the master. The package inventory lists the producer sources, and separately reviewed stage code supports producer/product facts; neither proves that the hidden master calls them. Exact master calls and ordering remain unresolved, and no output or order is inferred from filenames or the ledger alone.
- R_REVELIO_MONTHLY [undetermined]: Monthly author-format Revelio RDS records required to construct annual diversity measures.
- R_SEC_FILINGS [public_acquisition_required]: SEC filing index and raw documents for the author forms and study period.
- R_WRDS_FORM_INDEX [undetermined]: Author-format form-index CSV read by the EDGAR index producer.
- R_KEYWORDS_DROPPED [undetermined]: Dropped-keyword list referenced by the disclosure preparation branch; bounded metadata found the packaged file empty, and the consumer's empty-list handling remains unknown.
- R_GENERIC_KEYWORDS_BOTH [undetermined]: Separate generic keyword list referenced by disclosure preparation.
- R_GENERIC_KEYWORDS_NEITHER [undetermined]: Separate generic keyword list referenced by disclosure preparation.
- R_CSR_REPORT_TEXT [undetermined]: Corporate Register report text files used to create CSR-based disclosure features.
- R_CSR_LINK [undetermined]: CSR-to-CRSP-CCM company link table used by disclosure construction.
- R_TWITTER_HANDLES [undetermined]: Author-defined company handle list consumed by the Twitter branch.
- R_TWITTER_RAW [undetermined]: Author-format Twitter records required by the feature branch.
- R_TWITTER_FEATURES [undetermined]: Twitter firm-year feature CSV consumed by disclosure analysis.
- R_TWITTER_LINK [undetermined]: Separate Twitter-to-CRSP-CCM company link table.
- R_COMPUSTAT_FUNDAMENTALS [undetermined]: Compustat annual fundamentals used by stock/fundamentals construction.
- R_COMPUSTAT_NAMES [undetermined]: Compustat names used to link RepRisk company identifiers.
- R_CRSP_STOCK_MONTHLY [undetermined]: CRSP monthly stock records used for annual return and characteristic construction.
- R_CRSP_HOLDINGS [undetermined]: CRSP fund holdings and identifier inputs required by the separate ownership branch.
- R_GJF_CURRENT [undetermined]: Current Good Jobs First input used to construct annual enforcement measures.
- R_GJF_LINK_NEW [undetermined]: Current Good Jobs First-to-Compustat company crosswalk.
- R_REFINITIV_SUMMARY [undetermined]: Distinct Refinitiv company-summary table consumed by ESG construction.
- R_REFINITIV_SOCIAL [undetermined]: Distinct Refinitiv social table consumed by ESG construction.
- R_REFINITIV_ENVIRONMENT [undetermined]: Distinct Refinitiv environment table consumed by ESG construction.
- R_REFINITIV_INFO [undetermined]: Distinct Refinitiv company-information table used in ESG mapping.
- R_SUSTAINALYTICS_WEIGHTS [undetermined]: Sustainalytics weighted-score source table consumed separately from Refinitiv inputs.
- R_REFINITIV_LINK [undetermined]: Refinitiv-to-CRSP-CCM link table with author-prepared identifiers.
- R_SUSTAINALYTICS_LINK [undetermined]: Separate Sustainalytics-to-CRSP-CCM link table.
- R_REPRISK_COMPANY_ID_TABLE [undetermined]: Distinct RepRisk company-id source table used by the author query branch.
- R_REPRISK_COMPANY_IDENTIFIERS [undetermined]: Distinct RepRisk company-identifiers source table used by the author query branch.
- R_REPRISK_RISK_INCIDENTS [undetermined]: Distinct RepRisk risk-incidents source table used by the author query branch.
- R_LM_DICTIONARY [undetermined]: Loughran–McDonald dictionary resource used by the sentence-feature branch; the hidden consumer leaves its required columns and category mapping unresolved.
- R_SENTENCE_CORPUS [undetermined]: Author-format cleaned sentence Feather corpus required by topic construction.
- R_SENTENCE_MODEL [undetermined]: all-mpnet-base-v2 model resource required to generate sentence embeddings.
- R_DEI_HIRING_RDS [undetermined]: Separate annual DEI/ESG hiring RDS read by the final merge.
- R_TOPIC_FRACTION_RDS [undetermined]: Twenty-topic firm-year fraction RDS read by the final merge.
- SW_PY_GENSIM [preparation_required]: Not available in the checked Python environment; setup is required before the author step can run.
- SW_PY_SENTENCE_TRANSFORMERS [preparation_required]: Not available in the checked Python environment; setup is required before the author step can run.
- SW_R_TIDYVERSE [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_DPLYR [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_READR [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_TIDYR [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_LUBRIDATE [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_GGPLOT2 [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_DESCTOOLS [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_STRINGR [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_PURRR [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_OPENXLSX [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_READXL [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_DATA_TABLE [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_SQLDF [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_COWPLOT [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_RPOSTGRES [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_HERE [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_LMTEST [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_SANDWICH [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_TIBBLE [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_FIXEST [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_MODELSUMMARY [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_BINSREG [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_GGTHEMES [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_PALS [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_PATCHWORK [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_KABLEEXTRA [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_R_GLUE [preparation_required]: Not available in the checked vanilla R library; package setup is required before the author step can run.
- SW_NLTK_CORPORA [unverified]: NLTK is installed and the author source names these corpora; corpus availability was not checked.
- SW_SENTENCE_MODEL_RESOURCE [unverified]: The author source names the model; local cache/version availability is unverified. No model was loaded or downloaded.

## Review notes

- The assessment used the coordinator-pinned, independently verified safe source views. Protected authentication, connection, endpoint, and private configuration blocks were withheld; all Twitter source bodies were wholly withheld. The reviewed source programs remain present in the package. These view limits are implementation-review limits, not findings that source code or data are absent, and no credential validity, use, or effect is inferred.
- A configured relative sentence-corpus filepath was reviewed for producer-consumer alignment; its value is omitted. This is ordinary workflow path metadata and does not create a separate entitlement or original-path identity condition.
- One current-turn Sustainalytics lookup stdout was overwritten before its first bytes were separately preserved. No first-output, argv, or wrapper reconstruction is claimed; only the surviving current capture is used as evidence.
- No author code, model, or SAS execution/import/compilation, package installation, payload download, API query, external contact, or applied source edit was performed.
- Generated intermediates are accounted for through their supplied producers and do not have to pre-exist before the full pipeline runs. Remaining requirements are raw inputs or final products whose producer contracts remain specifically unresolved.
- Source evidence metadata was rechecked against the coordinator-pinned safe views. Exact visible nonsecret fragments are quoted with original one-based line numbers; configured or structurally distributed statements are cited by the in-work safe-view hash. Redacted path values and unverified producer-output identity are not reconstructed.
- Base Python and R availability uses the original registered successful environment proof. Python distribution rows use a shape-normalized copy of the saved successful typed capture; no package was installed, loaded, or newly checked.
