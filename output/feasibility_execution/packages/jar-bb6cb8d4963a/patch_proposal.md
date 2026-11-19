# Patch proposal: jar-bb6cb8d4963a

Corporate Websites: A New Measure of Disclosure

DOI: 10.1111/1475-679X.70007

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow across public firms, private firms, and French nonfinancial disclosure. Entry points are the registered text-code files; the workbook is a data input.

Entry points: `1_Public_Firms/1_Sample_and_Download_Data/1_company_selection.do`, `1_Public_Firms/1_Sample_and_Download_Data/2_download_wayback.bat`, `1_Public_Firms/2_Generate_Website_Measures/1_json_to_csv.py`, `1_Public_Firms/2_Generate_Website_Measures/2_compute_website_size_format.do`, `1_Public_Firms/2_Generate_Website_Measures/3_compute_website_content.do`, `1_Public_Firms/3_Analysis/1_Public_Firms_Generate_Datasets.do`, `1_Public_Firms/3_Analysis/2_Public_Firms_Tables_and_Figures.do`, `2_Private_Firms/1_Sample_and_Download_Data/1_build_transaction_measure.do`, `2_Private_Firms/1_Sample_and_Download_Data/2_extract_orbis_US.sas`, `2_Private_Firms/1_Sample_and_Download_Data/3_extract_sample.do`, `2_Private_Firms/1_Sample_and_Download_Data/4_download_wayback.sh`, `2_Private_Firms/2_Generate_Website_Measures/1_compute_measure.py`, `2_Private_Firms/2_Generate_Website_Measures/2_urlparse.py`, `2_Private_Firms/2_Generate_Website_Measures/3_compute_dictionary.py`, `2_Private_Firms/2_Generate_Website_Measures/4_urlparse_content.py`, `2_Private_Firms/2_Generate_Website_Measures/5_urlparse_format.py`, `2_Private_Firms/2_Generate_Website_Measures/6_dic_to_stata.py`, `2_Private_Firms/3_Analysis/1_generate_dataset.do`, `2_Private_Firms/3_Analysis/2_generate_tables.do`, `3_Non_Financial_Disclosure/1_Sample_and_Download_Data/1_sample_selection.do`, `3_Non_Financial_Disclosure/1_Sample_and_Download_Data/2_wayback_scraping_a.py`, `3_Non_Financial_Disclosure/1_Sample_and_Download_Data/2_wayback_scraping_b.py`, `3_Non_Financial_Disclosure/1_Sample_and_Download_Data/3_generate_measure.do`, `3_Non_Financial_Disclosure/2_Analysis/generate_tables.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70007 - Corporate-Websites-A-New-Measure-of-Disclosure/bbb-datasheet-code-identifier-and-log-files.zip",
      "sha256": "f2331e3456640f577d1dc86dbf85e891de347427bcbd9061899d914e0f949606"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "88287c5c0630a37d6658a376864aae07da319da729a2a5f7cbd973b22f992475"
}
```

## Proposed actions

### A_DICT_ARITY_FIX: Prepare the exact, source-supported same-loader repair for the three topic-dictionary calls in a future authorized working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_DICT_ARITY
Evidence: E_DICT_SIGNATURE, E_DICT_CALLS, E_TOPIC_CALLS_ALL

**Proposed edit:** `2_Private_Firms/2_Generate_Website_Measures/3_compute_dictionary.py:27–29`
Source SHA-256: `47c47f18c946a01f5cd2a9cda203b4de52599a4ba53a73d4bb32b011d3e5d87f`

The current calls pass two positional arguments to a function defined with one parameter.

Current text:
```
csr=load_words(path_dic,'csr.txt')
carbon=load_words(path_dic,'carbon.txt')
diversity=load_words(path_dic,'diversity.txt')
```

Proposed replacement:
```
csr=load_words(os.path.join(path_dic,'csr.txt'))
carbon=load_words(os.path.join(path_dic,'carbon.txt'))
diversity=load_words(os.path.join(path_dic,'diversity.txt'))
```

Preparation / proposed procedure:

1. In a later authorized working copy, apply the existing exact repair: pass each of the three dictionary paths through os.path.join using the same loader pattern as the four adjacent correct calls, so each load_words invocation supplies its declared single argument.
2. Keep the frozen registered source unchanged during this assessment; this ordinary working-copy edit has no separate original-author approval prerequisite.

Validation to perform later:

- Review the proposed before/after block against the one-argument loader signature, the four adjacent correct calls, and the seven present packaged dictionary files; confirm exactly one argument is passed at each of the three sites without executing author code.

### A_PRIVATE_SCHEMA_MAP: Resolve the private producer-to-consumer CSV contract while treating the current headerless positional mapping as unresolved unless an exact source-supported column conflict is established.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_PRIVATE_CSV_SCHEMA, ISS_NONFIN_PRIVATE_INDEX
Evidence: E_PRIVATE_WRITER, E_PRIVATE_CONSUMER, E_INDEX_PRIVATE, E_SRCMAP_18_L153_6fcd5be2d0, E_SRCMAP_18_L153_1861008ac9, E_SRCMAP_18_L163_c10b25ed66, E_SRCMAP_18_L163_186a575b1e, E_SRCMAP_18_L181_2686dc82d2, E_SRCMAP_18_L181_ae0b4cea57, E_SRCMAP_18_L252_d5a5c8645d, E_SRCMAP_18_L252_0b714b5b8d

Preparation / proposed procedure:

1. Map the producer’s headerless output positions to the consumer’s v3–v7 positional renames and subsequent topic mapping using the complete admitted producer and consumer records.
2. Do not infer a mismatch from header=False or positional renames alone; preserve uncertainty if the exact column lineage is not established.
3. Confirm the source of index_private.csv from a direct admitted producer record before running the private index stage.

Validation to perform later:

- Verify each consumed column, URL meaning, delimiter, header policy, and source-to-output stage; require a direct conflicting column contract before classifying a blocking defect.
- If source excerpts leave positional lineage unresolved, retain the specific mapping question without inventing a replacement schema.

### A_PUBLIC_HANDOFF_PREP: Prepare a supported same-product public nonfinancial handoff across the listed file formats and output columns.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: ISS_NONFIN_PUBLIC_HANDOFF
Evidence: E_SAMPLE_RENAME, E_SAMPLE_EXPORT, E_A_INPUT, E_A_OUTPUT, E_INDEX_PUBLIC, E_INDEX_SENTINEL, E_SRCMAP_23_L22_8eda2301a8, E_SRCMAP_23_L22_053e4b8367

Preparation / proposed procedure:

1. Map the delimited list_public.xls producer to the readable Excel input expected by source A.
2. Map source A result output to index_public.csv with the url_wb field and normalize the No Result/No results sentinel.

Validation to perform later:

- Verify the mapped columns, file type, and sentinel with ordinary staged-file coverage checks before a future run.

### A_RESTRICTED_ROUTE: Confirm the authorized local export route and vintage for distinct Orbis and Zephyr products.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: ISS_RESTRICTED_ROUTES, R_ZEPHYR, R_ORBIS_US, R_ORBIS_FR
Evidence: E_DATASHEET_VENDOR, E_CATALOG, E_SRCMAP_08_L20_a2f73e1b0e, E_SRCMAP_08_L20_0db36e403c, E_SRCMAP_09_L15_10d8a5d214, E_SRCMAP_09_L15_14a8d74575, E_SRCMAP_09_L20_c731a2efc8, E_SRCMAP_09_L20_3c9427a887, E_SRCMAP_09_L27_30133c350c, E_SRCMAP_09_L27_e51691aaac, E_SRCMAP_09_L51_1c2ab726e9, E_SRCMAP_18_L101_b725a30970, E_SRCMAP_18_L101_5ed4f4e366, E_SRCMAP_09_L52_7c70df01a8

Preparation / proposed procedure:

1. Identify which authorized Orbis U.S., Orbis France, and Zephyr exports already match the named source fields and sample years.
2. Keep source products and identifier mappings separate.

Validation to perform later:

- Compare each export schema and coverage with the requirement-specific expected fields and period.

### A_PUBLIC_VINTAGES: Resolve historical versions and field mappings for the France constituent file, both separate equality inputs, the LM summary product, and the source-generated SIREN/GVKEY crosswalk.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: ISS_FR_VINTAGES, ISS_LMD_SCHEMA, R_LMD_SUMMARIES, R_EURONEXT_FR, R_FR_EQUALITY_INDEX, R_FR_FH_DATASET
Evidence: E_EGAPRO, E_LM_POINTER, E_SRAF_10X, E_SRCMAP_06_L281_1aa2926ca9, E_SRCMAP_06_L279_1ccfd340f4, E_SRCMAP_06_L279_5b0341ad6e, E_SRCMAP_20_L35_108e95fa45, E_SRCMAP_20_L35_2d9afc1ad8, E_SRCMAP_20_L56_bab55321bb, E_SRCMAP_20_L56_6c64df139c, E_SRCMAP_20_L133_89c775fefc, E_SRCMAP_20_L133_51bfb3703a, E_SRCMAP_20_L88_dabd4b051e, E_SRCMAP_20_L90_f05c0dd520

Preparation / proposed procedure:

1. Resolve the historical constituent workbook and the two distinct French equality datasets against their source-consumed index-family columns and covered years.
2. Confirm the exact LM summary file, fields, and historical coverage; a year-directory pointer and related SRAF resource do not establish the required summary schema.
3. Treat siren_gvkey as a source-generated crosswalk stage, not a separate external source; validate its input keys, match behavior, and coverage after its Compustat and labor-index inputs are staged.

Validation to perform later:

- Compare each independent route’s columns, keys, vintage, and period to the source-consumed contract; retain separate files/products and report actual coverage.
- Confirm the generated SIREN/GVKEY mapping is produced from its source inputs and covers the required identifiers before downstream France joins.

### A_NATIVE_COVERAGE: Stage source-compatible native products, preserve distinct prepared Compustat handoffs, and validate full-history coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: ISS_NATIVE_COVERAGE, ISS_WAYBACK_COVERAGE, R_COMP_US, R_COMP_US_IDENTIFICATION, R_COMP_US_QUARTERLY, R_COMP_US_SALES, R_COMP_US_EMPLOYMENT, R_COMP_GLOBAL_FR
Evidence: E_NATIVE_01, E_NATIVE_06, E_NATIVE_07, E_NATIVE_08, E_NATIVE_09, E_NATIVE_10, E_NATIVE_11, E_WAYBACK_DOCS, E_SRCMAP_06_L60_f8f1e009bd, E_SRCMAP_06_L60_9dfbbbc0cb, E_SRCMAP_06_L63_6e1431c766, E_SRCMAP_06_L63_af6cd79b4b, E_SRCMAP_07_L43_a993323608, E_SRCMAP_07_L43_277aa2dab2, E_COMPUS_COMPU_FIELDS, E_COMPUS_COMPU_FYEAR, E_COMPUS_IDENT_FIELDS, E_COMPUS_QUARTERLY_FIELDS, E_COMPUS_SALES_FIELDS, E_COMPUS_EMPLOYMENT_FIELDS, E_SRCMAP_20_L46_20d8fecfce, E_NATIVE_02, E_NATIVE_03, E_NATIVE_04, E_NATIVE_05

Preparation / proposed procedure:

1. Keep prepared compu and compu_global_fr distinct from their separate COMPANY/FUNDA and G_COMPANY/G_FUNDA native components; do not infer an unobserved join or selection.
2. For compuq_small, derive q from datadate, apply the source fyearq cutoff, deduplicate gvkey-q, and merge through the separate compu_identification input; preserve each source read/save boundary.
3. For compu_sales, derive q from datadate and deduplicate gvkey-q; for comp_empl, deduplicate gvkey-fyear. Keep these prepared outputs distinct.
4. Use the documented separate joins for weburl, SHRCD, and gvkey/permno, and establish full history/population coverage for each source period.

Validation to perform later:

- Verify each source-consumed field and its meaning against the exact local native route, then validate the prepared mapping/export and source duplicate/year rules.
- Check the identification input separately; cik/gind/sic are not established by the current native probe columns.
- Validate full period and population coverage after ordinary staging; one-row field probes do not establish it.

### A_SOFTWARE_READINESS: Resolve only branch-specific runtime packages, resources, and tools established by admitted imports and consumers; no install or runtime trial is part of this proposal.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: ISS_DICT_ARITY, ISS_NONFIN_PUBLIC_HANDOFF, SOFT_CHROME, SOFT_CHROME_DRIVER, SOFT_NLTK, SOFT_NUMPY, SOFT_PANDAS, SOFT_RECLINK, SOFT_REQUESTS, SOFT_SAS, SOFT_SELENIUM, SOFT_WGET, SOFT_WINSOR, SOFT_WSL
Evidence: E_ENV, E_A_SELENIUM, E_A_CHROMEDRIVER, E_B_REQUESTS, E_NLTK_STOPWORDS, E_WGET, E_WSL, E_REGHDFE, E_RECLINK

Preparation / proposed procedure:

1. For the private Python consumers, verify pandas, NumPy, requests, Selenium, and NLTK availability in the intended approved runtime; verify the NLTK stopwords corpus separately from the Python package.
2. Check the browser and driver as a compatible Selenium/Chrome/ChromeDriver set for the source A branch; record exact versions and paths before any authorized run.
3. For public batch and private shell retrieval, select the required branch and its compatible WSL/wget or shell/wget route; do not test downloads or require both platform variants for one branch.
4. Keep SAS and the Stata user commands separate: SAS status/version remains unverified, winsor is not proven by a winsor2 lookup, and reclink requires its own exact availability check.

Validation to perform later:

- Compare each runtime item to its cited consumer and target branch; distinguish Python packages from corpus data and browser/driver dependencies.
- Record the intended platform path and exact tool versions through an approved environment procedure before a future run; no package installation, download, SAS startup, or author execution is proposed here.

### A_PUBLIC_ANALYSIS_INPUTS: Resolve distinct public-analysis determinant and crosswalk inputs by native product, field, key, and vintage; keep the source-generated determinant_reg handoff out of raw acquisition.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_8KPLUMLEE, R_COMP_COMPLEXITY, R_COMP_SEGMENTS, R_DQ, R_GVKEY_DATE, R_IBES_LINK, R_IORSC, R_NAICS, R_SUPPLYCHAIN, ISS_MANUAL_INPUT_ROUTES
Evidence: E_SRCMAP_06_L358_1ff2ce1dd2, E_SRCMAP_06_L379_5847101e8f, E_SRCMAP_06_L493_a9cab1dd7e, E_SRCMAP_06_L503_db556343b9, E_SRCMAP_06_L516_ea21033a34, E_SRCMAP_06_L533_5f04c6710a, E_SRCMAP_06_L537_3b92048e25, E_SRCMAP_06_L551_dbf5bcdb97, E_SRCMAP_06_L556_2e0ef58982, E_SRCMAP_06_L636_8f730325ca, E_SRCMAP_06_L645_4a44745690, E_SRCMAP_07_L50_2f094ffee2

Preparation / proposed procedure:

1. For each named raw product, record its own readable route, source-consumed schema and key/date meaning: 8kplumlee, dq_2017, NAICS, supply-chain, IOR/SC, Compustat complexity (aqc/rcp), segment (stype/gvkey/datadate/sid), list_gvkey_date, and the IBES link product. Keep these products separate.
2. Map only source-supported date, identifier, join, duplicate, and sample-window rules for each consumer; the current source names and partial probes do not prove the exact full-history local exports.
3. Do not add determinant_reg as raw input: source 6 produces it and source 7 consumes it through generated dependency edges D0032/D0039. Keep the source-owned handoff in the branch procedure; completeness and runtime readability remain unverified.

Validation to perform later:

- Compare every distinct product’s exact consumed fields, key semantics, vintage, and period with a product-specific staged export; validate ordinary full-period coverage after authorized staging.
- Confirm source-defined joins and deduplication per product and verify D0032/D0039 as generated handoffs, without requesting a separate raw determinant_reg file.

### A_WAYBACK_BRANCH_HANDOFF: Map the public archive route and public website-measure products to their branch-specific consumers while preserving unresolved local Wayback producer contracts.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_WAYBACK, R_PUBLIC_WAYBACK_HANDOFF, R_PUBLIC_WEBSITE_MEASURES
Evidence: E_WAYBACK_DOCS, E_A_INPUT, E_A_OUTPUT, E_A_SENTINEL, E_B_GET, E_AUTHOR_REPOSITORY, E_SRCMAP_06_L208_c17e1e373d, E_SRCMAP_06_L395_e4e62940ac, E_SRCMAP_07_L408_d28f570ea9, E_SRCMAP_05_L123_ecb7b52b12

Preparation / proposed procedure:

1. For the archive branch, preserve the source’s URL/timestamp/statuscode request contract and its branch-specific sentinel handling; documentation of the public route does not establish firm coverage or a complete historical capture.
2. Reconcile the direct public-analysis consumers of wb_full and wb_full_updated with an actual producer, exact file/field contract, and coverage before treating either local handoff as verified; keep unresolved producer mappings unresolved.
3. Map the compatible author-repository public-firm size/topic products to the analysis handoff fields and years, then validate staged coverage; these products do not replace financial, determinant, or other branch-specific inputs.

Validation to perform later:

- Validate exact URL, timestamp, status, sentinel, file format, consumer fields, and covered period for each source-supported handoff after authorized staging.
- Keep source-specific capture completeness and wb_full/wb_full_updated producer identity open until direct producer and output evidence are available.

### A_TEXT_RESOURCE_MAP: Map the packaged topic workbook, topic dictionaries, English wordlist, and NLTK stopwords corpus to their separate consumers without substituting one resource for another.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_TOPIC_WORKBOOK, R_TOPIC_DICTIONARIES, R_PRIVATE_WORDLIST, R_NLTK_STOPWORDS
Evidence: E_PACKAGE_PROBE, E_TOPIC_PACKAGE_READABILITY_MATCH, E_TOPIC_CALLS_ALL, E_DICT_CALLS, E_WORDS_ALPHA, E_WORDS_ALPHA_SOURCE, E_NLTK, E_NLTK_STOPWORDS

Preparation / proposed procedure:

1. Before a future topic classification run, map the workbook’s consumed keyword sheets and fields from the registered consumer; the partial Summary-row read does not establish those sheets or their coverage.
2. Retain the verified seven-file plain-text topic-dictionary collection as its own packaged route. Keep it distinct from the words_alpha public wordlist and the separate NLTK stopwords corpus.
3. For each resource, confirm the consumer-selected location, format/encoding, version, and source role after approved staging; do not infer the wordlist payload or license from its README, and do not infer stopwords corpus availability from the NLTK package.

Validation to perform later:

- Verify that each consumer resolves to its designated resource and expected sheet/line format; document exact version and coverage separately for each source.
- Preserve the existing topic-dictionary readability proof and do not substitute its contents for the workbook, wordlist, or stopwords corpus.

### A_EMPLOYEE_LINEAGE: Resolve the nonfinancial employee-variable branch using the supplied source namespace and variable-abbreviation context before proposing any code change.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_EMPLOYEE_LINEAGE
Evidence: E_EMPLOYEE_CREATE, E_EMPLOYEE_KEEP, E_EMPLOYEE_FOLLOW

Preparation / proposed procedure:

1. Trace the create/keep/follow statements within the nonfinancial sample-selection branch and establish the actual variable namespace and applicable varabbrev setting; Stata can accept a unique variable-name abbreviation.
2. If the registered source context does not establish whether the later reference resolves to the created variable, preserve the issue as unresolved and request a branch-specific clarification before considering an edit.
3. Do not replace log_emp with log_employees, or the reverse, without source-supported proof of a broken reference.

Validation to perform later:

- Require direct source evidence of the variable binding and branch context for any proposed fix; otherwise retain an unresolved lineage note and no source edit.

### A_OUTPUT_EXPORT_CONFIRMATION: Treat the frozen static-parser warning as a coverage limitation until the supplied source or README establishes a missing required export.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_OUTPUT_EXPORTS
Evidence: E_STATIC_AUDIT

Preparation / proposed procedure:

1. Compare each flagged table-output name with the supplied source’s explicit producer statements, downstream consumers, and any documented output contract.
2. If direct source/README evidence establishes a required but absent output, document that exact producer-consumer mismatch and propose only the supported correction; otherwise keep the static-audit warning as a limitation with no author patch.

Validation to perform later:

- Every claimed export defect must have direct source or README output-contract evidence; the static warning alone cannot establish missing runtime outputs.

### A_BRANCH_RUN_PROCEDURE: Follow the three supplied research branches only when needed, using source-proved producer-consumer handoffs, conditional branch selection, and the documented cross-language file boundaries.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_WAYBACK, R_PUBLIC_WAYBACK_HANDOFF, R_PUBLIC_WEBSITE_MEASURES
Evidence: E_WORK_ITEM, E_SRCMAP_01_L15_683ddb8687, E_WSL, E_WGET, E_SRCMAP_05_L123_ecb7b52b12, E_SRCMAP_06_L636_8f730325ca, E_SRCMAP_06_L645_4a44745690, E_SRCMAP_07_L50_2f094ffee2, E_SRCMAP_08_L20_a2f73e1b0e, E_SRCMAP_09_L15_10d8a5d214, E_SRCMAP_10_L20_255c46fc91, E_PRIVATE_WRITER, E_PRIVATE_CONSUMER, E_SRCMAP_12_L110_b5cecde291, E_SRCMAP_14_L33_76ab2657d8, E_SRCMAP_17_L27_473862289f, E_SRCMAP_18_L22_7b9353bfa6, E_SRCMAP_19_L30_44cd0a6c3d, E_SRCMAP_20_L52_fe5c3dc650, E_SRCMAP_20_L75_c04f96ea12, E_A_INPUT, E_A_OUTPUT, E_B_GET, E_INDEX_PRIVATE, E_INDEX_PUBLIC, E_SRCMAP_23_L22_8eda2301a8, E_SRCMAP_24_L118_2efaa7e527, E_SRCMAP_24_L127_e803d3f1f0

Preparation / proposed procedure:

1. The full_pipeline scope covers the paper’s documented public, private, and nonfinancial research branches. Include every mandatory branch for the declared target and source conditions; do not omit a branch because an input, license, or software route is unavailable. Preserve branch-local producer-consumer edges and do not impose a total order across independent branches. Before each handoff, stage its inputs under the separate route-specific actions and verify the producer output’s file type, key, and consumed fields.
2. Public-firm branch, registered entrypoints: 1_Public_Firms/1_Sample_and_Download_Data/1_company_selection.do, 1_Public_Firms/1_Sample_and_Download_Data/2_download_wayback.bat, 1_Public_Firms/2_Generate_Website_Measures/1_json_to_csv.py, 1_Public_Firms/2_Generate_Website_Measures/2_compute_website_size_format.do, 1_Public_Firms/2_Generate_Website_Measures/3_compute_website_content.do, 1_Public_Firms/3_Analysis/1_Public_Firms_Generate_Datasets.do, 1_Public_Firms/3_Analysis/2_Public_Firms_Tables_and_Figures.do. Keep sample selection before public retrieval and conversion; then complete the source-defined website-measure handoffs before public dataset generation and the tables/figures stage. The source-proved D0032/D0039 edge is source 6 generating determinant_reg for source 7; it is not a separate raw input. Keep wb_full and wb_full_updated producer identity/history unresolved until their exact producer and output contracts are evidenced.
3. Private-firm branch, registered entrypoints: 2_Private_Firms/1_Sample_and_Download_Data/1_build_transaction_measure.do, 2_Private_Firms/1_Sample_and_Download_Data/2_extract_orbis_US.sas, 2_Private_Firms/1_Sample_and_Download_Data/3_extract_sample.do, 2_Private_Firms/1_Sample_and_Download_Data/4_download_wayback.sh, 2_Private_Firms/2_Generate_Website_Measures/1_compute_measure.py, 2_Private_Firms/2_Generate_Website_Measures/2_urlparse.py, 2_Private_Firms/2_Generate_Website_Measures/3_compute_dictionary.py, 2_Private_Firms/2_Generate_Website_Measures/4_urlparse_content.py, 2_Private_Firms/2_Generate_Website_Measures/5_urlparse_format.py, 2_Private_Firms/2_Generate_Website_Measures/6_dic_to_stata.py, 2_Private_Firms/3_Analysis/1_generate_dataset.do, 2_Private_Firms/3_Analysis/2_generate_tables.do. Prepare transaction-measure and authorized Orbis products as separate inputs for sample selection; then follow the branch shell retrieval and Python measurement/parsing/dictionary/content/format/conversion handoffs into the Stata dataset and tables stages. Preserve the CSV producer-consumer header/arity mapping and each resource’s distinct role. The current evidence does not establish every relative ordering among the Python content/format sub-stages, so use only source-defined edges there.
4. Nonfinancial branch, registered entrypoints: 3_Non_Financial_Disclosure/1_Sample_and_Download_Data/1_sample_selection.do, 3_Non_Financial_Disclosure/1_Sample_and_Download_Data/2_wayback_scraping_a.py, 3_Non_Financial_Disclosure/1_Sample_and_Download_Data/2_wayback_scraping_b.py, 3_Non_Financial_Disclosure/1_Sample_and_Download_Data/3_generate_measure.do, 3_Non_Financial_Disclosure/2_Analysis/generate_tables.do. Run sample selection before its website-scraping/measurement handoff and final tables stage. Keep the nonfinancial branch in scope. Select scraper A or B only under the supplied source condition; the admitted evidence does not prove that both are required or establish a total A/B order. If the source-selected route/input is unresolved, retain the branch as not prepared rather than skipping it. Source 20 generates siren_gvkey from the preceding Compustat and labor-index inputs through reclink; preserve those upstream inputs and verify match coverage after an authorized run, without treating siren_gvkey as raw data. Source 20 produces compustat_fr consumed by source 24 (D0077/D0090); source 23 consumes the separate index_private.csv/index_public.csv handoffs. Keep employee-variable lineage unresolved unless its source namespace/settings prove the binding.
5. For cross-platform retrieval, choose the branch’s source-compatible batch or shell implementation for the target environment; platform choice does not waive a mandatory research branch. Do not run duplicate platform alternatives unless a direct source condition requires them. Preserve SAS-to-Stata and Python/CSV-to-Stata boundaries and verify their actual output formats/paths before downstream stages; no downloads, author-code execution, SAS startup, or outcome generation are part of this proposal.

Validation to perform later:

- For each executed branch edge, verify the actual producer output exists and matches the next consumer’s registered file format, field names/meanings, key, and covered period; report unresolved outputs as unresolved.
- Retain D0032/D0039 and D0077/D0090 as source-proved generated handoffs, not separate raw-data routes; do not claim those outputs were built or read in this assessment.
- Record the chosen branch and platform path, the concrete handoff mapping, and any source-supported conditional skips; do not run both A/B or platform variants unless a direct source branch requires them.


## Remaining issues and prerequisites

- ISS_DICT_ARITY [preparation; full_pipeline]: The one-argument load_words(file) definition is followed by three active calls that pass two positional arguments. This is a static source mismatch; no Python author code was run.
- ISS_PRIVATE_CSV_SCHEMA [unresolved; full_pipeline]: The private Python producer writes headerless CSV rows and the Stata consumer renames positional variables and maps columns into topics. The admitted producer/consumer excerpts do not establish an exact conflicting column mapping; preserve this as an unresolved schema question, not a confirmed incompatibility.
- ISS_NONFIN_PUBLIC_HANDOFF [preparation; full_pipeline]: Source 20 exports list_public.xls; source A reads list_public.xls.xlsx and consumes a website column, then writes results_public.csv. Source 23 separately consumes index_public.csv. The compatible case, path, format, and field mapping between these stages remains unresolved; these names are kept as distinct products pending a supported mapping.
- ISS_NONFIN_PRIVATE_INDEX [unresolved; full_pipeline]: Source 23 directly consumes index_private.csv, but the admitted direct evidence does not establish its producer, field schema, or relationship to the public index. The unresolved producer contract is retained without inferring absence or private-data content.
- ISS_EMPLOYEE_LINEAGE [unresolved; full_pipeline]: The nonfinancial source creates log_employees, keeps log_emp in an intermediate branch, and later keeps log_employees. The admitted static record does not establish which branch supplies the later field or the applicable variable-abbreviation context. Stata may resolve a unique variable-name abbreviation; this remains a field-lineage question, not a confirmed runtime break.
- ISS_NATIVE_COVERAGE [unresolved; full_pipeline]: Eleven one-row native probes establish the listed column readability and separate joins, not full population, history, or all required years. COMPANY.weburl and DSENAMES.SHRCD remain separate inputs joined by their keys/effective dates.
- ISS_WAYBACK_COVERAGE [unresolved; full_pipeline]: Public CDX documentation and the packaged JSON examples do not establish complete firm-level snapshot coverage. Public analysis also consumes wb_full and wb_full_updated, whose producer and field/history handoff remain unverified in the admitted workflow.
- ISS_LMD_SCHEMA [unresolved; full_pipeline]: A documented LM 2018 year directory is a positive discovery pointer. Source 6 consumes LM_10X_Summaries_2018.csv fields fye, form_type, n_words, n_unique_words, grossfilesize, and netfilesize; the exact local file schema/readability and required history remain unverified.
- ISS_RESTRICTED_ROUTES [unresolved; full_pipeline]: The datasheet identifies commercial data vendors and source code names distinct Orbis/Zephyr inputs. Local catalog misses do not establish that a dataset, license, or route is absent; exact authorized exports, fields, and vintages remain unverified.
- ISS_MANUAL_INPUT_ROUTES [unresolved; full_pipeline]: The source consumes distinct 8kplumlee, dq_2017, NAICS, supply-chain, IOR/SC, list_gvkey_date, IBES-link, complexity, and segment products. determinant_reg is source-generated in the public-firm dataset stage and consumed downstream; it is not a separate raw acquisition. The other named inputs still lack complete local field/readability and historical-coverage proof.
- ISS_FR_VINTAGES [unresolved; full_pipeline]: The author workflow consumes list_public_france.xlsx, index-egalite-fh.csv, and the distinct fh-dataset.csv. The current Egapro download is a discovery route only; historical provenance, exact schemas, and vintages remain unverified.
- ISS_OUTPUT_EXPORTS [preparation; full_pipeline]: A frozen static audit warns of partial structural coverage and no validated export for three table outputs. That parser warning alone does not establish a missing source-declared export or a runtime defect.
- R_COMP_US [undetermined]: The author workflow consumes the prepared compu.dta for U.S. company/annual website measures. The source contracts include gvkey/weburl plus annual datadate, fyear, at, emp, and sale; separate local probes cover COMPANY and FUNDA components, but no result verifies the prepared join, full history, or population.
- R_COMP_US_IDENTIFICATION [undetermined]: The author workflow separately consumes prepared compu_identification.dta, derives quarter from datadate, and retains gvkey, cik, gind, and sic. The prepared file and exact field provenance are unresolved; native one-row probes do not show cik/gind/sic.
- R_COMP_GLOBAL_FR [undetermined]: The France branch consumes the single prepared compu_global_fr.dta input with gvkey/fic/weburl and annual accounting fields. Local G_COMPANY and G_FUNDA probes verify separate native components, but the prepared join, field alignment, France sample history, and coverage remain unverified.
- R_IBES_LINK [undetermined]: I/B/E/S ticker-to-company link handoff used by public analysis.
- R_WAYBACK [undetermined]: Internet Archive snapshots/CDX records used to construct website measures for the public, private, and nonfinancial branches.
- R_PUBLIC_WEBSITE_MEASURES [public_acquisition_required]: Public-firm website size and content measure products; author repository outputs are a compatible same-product staging route.
- R_TOPIC_WORKBOOK [undetermined]: Packaged keyword-classification workbook supplying topic keyword sheets.
- R_LMD_SUMMARIES [undetermined]: Loughran–McDonald 10-X summary fields consumed by the public-firm analysis.
- R_8KPLUMLEE [undetermined]: 8-K measure dataset consumed by public analysis.
- R_DQ [undetermined]: DQ 2017 dataset consumed by public analysis.
- R_NAICS [undetermined]: NAICS classification data used for public determinants.
- R_SUPPLYCHAIN [undetermined]: B2B/supply-chain categorization product used by public determinants.
- R_IORSC [undetermined]: Institutional ownership/supply-chain product used by public analysis.
- R_COMP_COMPLEXITY [undetermined]: Compustat complexity fields used by public analysis.
- R_COMP_SEGMENTS [undetermined]: Compustat segment records used by public analysis.
- R_GVKEY_DATE [undetermined]: GVKEY/date crosswalk used to align public analysis inputs.
- R_ZEPHYR [undetermined]: Zephyr deal export and derived deal sample for private firms.
- R_ORBIS_US [undetermined]: Orbis U.S. company identifiers and historical company/website table for private firms.
- R_PRIVATE_WORDLIST [public_acquisition_required]: Separate English wordlist used by private website content scripts.
- R_NLTK_STOPWORDS [undetermined]: NLTK English stopwords corpus resource used by private content scripts.
- R_EURONEXT_FR [undetermined]: French listed-firm universe file used by the nonfinancial sample branch.
- R_FR_EQUALITY_INDEX [undetermined]: French company equality-index dataset used for the public sample.
- R_FR_FH_DATASET [undetermined]: Separate French gender-equality data file used in the nonfinancial sample branch.
- R_ORBIS_FR [undetermined]: Orbis France financial and identifier data, kept separate from U.S. Orbis products.
- R_PUBLIC_WAYBACK_HANDOFF [undetermined]: Public analysis consumes named local intermediates wb_full.dta and wb_full_updated.dta. The exact producer, consumed field contract, and full-period history remain unresolved in the admitted workflow.
- SOFT_SAS [unverified]: The package has a SAS source entrypoint; the existing environment capture leaves SAS status and version unverified. No SAS process was started.
- SOFT_PANDAS [unverified]: Imported by private and nonfinancial Python source; package availability/version was not tested.
- SOFT_NUMPY [unverified]: Imported by private Python source; package availability/version was not tested.
- SOFT_NLTK [unverified]: Imported by private Python source; the stopwords corpus is a separate data resource and was not checked.
- SOFT_REQUESTS [unverified]: Imported and used by the nonfinancial Wayback query source; package availability/version was not tested.
- SOFT_SELENIUM [preparation_required]: Source imports Selenium; package availability/version was not tested.
- SOFT_CHROME_DRIVER [preparation_required]: Admitted source rows reference the driver; local driver presence/version was not tested.
- SOFT_CHROME [preparation_required]: Admitted source rows reference Chrome; local browser presence/version was not tested.
- SOFT_WGET [preparation_required]: The public and private retrieval scripts invoke wget; no binary or download was tested.
- SOFT_WSL [unverified]: The public batch retrieval path uses WSL; availability and path mapping were not tested.
- SOFT_WINSOR [unverified]: Source uses winsor; the environment capture only reports winsor2 lookup results, which do not establish winsor availability.
- SOFT_RECLINK [unverified]: Nonfinancial source invokes reclink; current availability/version was not tested.

## Review notes

- This is a static feasibility assessment of supplied source, work-item metadata, existing value-free captures, and bounded one-row catalog probes. No author code, models, regressions, statistical or synthetic trials, SAS executable/startup/autoexec/PROC, downloads, installs, API/authentication tests, outgoing messages, or applied source edits were performed.
- Earlier in the assessment, the cached text representation of 3_Non_Financial_Disclosure/2_Analysis/generate_tables.do was accidentally replaced by helper output. Root authorized exact-byte restoration; the registered source hash df0921b44a7f44c541a5815a0da63c35e7b016c8eaed4aa7dbe924538b673fc8 was restored and read back. The wrong-cache bytes remain preserved opaque. They were not opened or copied during the root-released restoration and the current routefix corrections; this is not an audit-wide access/effects claim. The inline helper source and original stdout/stderr/timestamps were not retained, so the earlier mutation/access/effects interval cannot be reconstructed completely.
- The earlier runner-version record was not pinned before the earlier call; the current environment capture is not a before-call pin. SAS remains unverified in the existing capture, and no SAS process was run.
- Source A and B were cited only through coordinator-admitted views. A lines 65–68 and B lines 15–20 and 59–87 remain masked and unknown; this assessment does not infer source, data, credentials, secret presence, absence, or effects from those withheld rows.
- The 2018 LM year directory is a positive discovery pointer only; no listing or file payload was read. Exact Orbis/Zephyr catalog lookup misses do not establish a missing license or unavailable local route.
- The 12 inventoried Data/JSON_sample fixtures passed bounded UTF-8/JSON structure checks (E_PACKAGE_MEMBER_READABILITY). They are optional/demo examples, not a full Wayback corpus, and are not modeled as a mandatory full-pipeline input.
- The topic collection has seven bounded-readable text members and seven author-named loader basenames; exact path-variable binding and term coverage remain unresolved.
- Compustat prepared inputs are represented separately by their actual consumed filenames. Native local probes support specific raw components but do not prove prepared-file construction, joins, or full history.
- The source-proved compustat_fr intermediate is represented by generated handoff edges D0077 and D0090, not a separate raw requirement or output-readability claim. Upstream compu_global_fr and France/list contracts remain separate.
- The supplied source saves compustat_fr before a later use; generated dependency rows D0077 and D0090 preserve that producer/consumer order. compustat_fr is not modeled as a separate raw requirement or as a verified output read.
- The dictionary route uses a typed projection of the saved bounded-read capture for the frozen matcher; it normalizes recorded metadata and does not reread any member.
- Available Python, Stata, and reghdfe records cite the original registered environment probe by frozen path/hash. The typed viewer projection is retained only for provenance, exact-key, availability-flag, and version context; the original payload was not opened in this draft update.
- R_DETERMINANTS was removed as a duplicate raw-data route because source 6 generates determinant_reg and source 7 consumes it; source-proved generated edges D0032/D0039 remain, and no runtime output is claimed.
- The static export warning, employee-variable lineage, and private CSV positional mapping remain limitations/questions; none is treated as a confirmed runtime defect or used to invent an author-code patch.
- The proposed run procedure preserves branch-local source order and all three documented research branches across the 24 registered programs; it does not impose a cross-branch total order. Conditional platform/scraper variants are selected only by source-defined conditions and do not waive a mandatory paper branch.
- The earlier superseded-view scan/display and its limited retained capture are documented separately in the value-free method note probes/method_event_old_view_scan_331_20261113.json (SHA256 5813d79297270f775a0134096a07fba00ad0e49ea4210bcb078a2c62ea51f55b). This handling note is procedural, not source evidence; the earlier command/stream history was incomplete, so no audit-wide content/effects claim is made.
- R_FR_SIREN_GVKEY was removed as a duplicate raw-data requirement because source 20 generates siren_gvkey and later consumes it. Generated source-proof edges D0079/D0080 remain; the actual Compustat and labor-index inputs and reclink prerequisite remain separate, and the generated match output was not built or read here.
