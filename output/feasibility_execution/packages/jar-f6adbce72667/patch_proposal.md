# Patch proposal: jar-f6adbce72667

ESG Disclosures in the Private Equity Industry

DOI: 10.1111/1475-679X.12570

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow covering the Stata source-preparation programs, the README-documented TRI name-matching interleave, website-disclosure stages 1–6, Python language/10-K/8-K/LLM/LDA branches, and final code_analysis.do consumers. Independent TRI, dynamic analysis, OSHA, RepRisk, and Trucost inputs are separately scoped; the missing matching-script source and specific input/history/producer gaps leave mandatory branch closure unresolved. All 159 frozen dependency IDs remain source-traced once.

Entry points: `code_preqin.do`, `code_hedgeFunds.do`, `code_publicFirms.do`, `code_languageDetection.py`, `code_worldbank.do`, `code_TRI.do`, `code_trucost.do`, `code_reprisk.do`, `code_osha.do`, `code_10KSize_Boulland.py`, `code_8Kwordcount_Boulland.py`, `codes_websiteScraping/step1_APICalls.py`, `codes_websiteScraping/step2_urlList.py`, `codes_websiteScraping/step3_scrapping/step3_wrapper.py`, `codes_websiteScraping/step4_measure_construction.py`, `codes_websiteScraping/step5_combine.py`, `codes_websiteScraping/step6_winsorizeLabel.do`, `LLM GPT/Code/ESG File Cleaning Block.py`, `LLM GPT/Code/ESG File Word Count Block.py`, `LLM GPT/Code/Main GPT Block.py`, `LLM GPT/Code/LDA Topics and Topic Distributions.py`, `LLM GPT/Code/Perplexity & Coherence LDA.py`, `LLM GPT/Code/GPT Topic Modeling.py`, `code_analysis.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 5/12570 - ESG-Disclosures-in-the-Private-Equity-Industry/aov-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "e3a3d4e64b03289ea0ddc6abbf792db9e76b19edfefdaf4834d316060cde423f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "318ecf1f58fb156033166d413fbe5fe1385cc7b1fa3c080c1b696a9ba69fb9de"
}
```

## Proposed actions

### ACT_COMPLETE_SOURCE_TRACE: Follow the documented upstream producer chain and resolve each separately scoped source/input contract before running code_analysis.do; do not let a partial source route stand in for unrelated inputs.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: REQ_TRI_MANUAL_MATCH_TABLE, REQ_TRI_BASICPLUS_YEARLY_US4_FILES, REQ_TRI_STD_MATCHED_FILE, REQ_TRI_VIN_MATCHED_FILE, REQ_TRI_VINSTD_MATCHED_FILE, REQ_TRI_SUB_MATCHED_FILE, REQ_TRI_FAC_MATCHED_FILE, REQ_RSEI_CHEMICAL_DATA_FILE, REQ_CLEAN_AIR_ACT_CHEMICAL_LIST, REQ_ANALYSIS_TA_DYNAMIC_FILES, REQ_OSHA_ACCIDENTS_CSV, REQ_OSHA_ACCIDENT_INJURY_CSV, REQ_REPRISK_COMPANY_IDENTIFIERS_FILE, REQ_REPRISK_ANNUAL_RRI_FILES, REQ_TRUCOST_RAW_DATA_FILE, ISS_DEPENDENCY_TRACE, ISS_INPUT_COMPATIBILITY, REQ_FIRM_TEXT, REQ_ESG_DICTIONARY, REQ_LDA_TEXTFILES, ISS_LLM_INPUT_ROUTE, ISS_API_SETUP, REQ_PE_ROUND_EXAMPLE, REQ_HF_ROUND_EXAMPLE, REQ_FINAL_DICTIONARIES, REQ_WAYBACK_ARCHIVE, ISS_ROUND_LIST_PRODUCERS, ISS_STEP4_DICTIONARY_ROUTE, ISS_SCRAPE_RUNTIME_ROUTE, REQ_PREQIN_MANAGER_FILE, REQ_PEIRANK_2022_FILE, REQ_PEIRANK_2021_FILE, REQ_PEIRANK_2020_FILE, REQ_PEIRANK_2019_FILE, REQ_PREQIN_FUNDS_FILE, REQ_PREQIN_PERFORMANCE_FILES, REQ_PREQIN_BUYOUT_INVESTORS_FILE, REQ_PREQIN_BUYOUT_DETAILS_FILE, REQ_PREQIN_BUYOUT_EXITS_FILE, REQ_PREQIN_VC_DEALS_FILE, REQ_PREQIN_VC_INVESTORS_FILE, REQ_PREQIN_VC_EXITS_FILE, REQ_PREQIN_LPS_FILE, REQ_PRI_SIGNATORY_FILE, REQ_PREQIN_MAP_20230307_FILE, REQ_PREQIN_MAP_20230418_FILE, REQ_WEBSITE_EXCLUSION_FILE, REQ_EIKON_HF_US_FILE, REQ_EIKON_HF_NONUS_FILE, REQ_COMPUSTAT_NA_IPO_FILE, REQ_COMPUSTAT_GLOBAL_IPO_FILE, REQ_IPODATES_US_PREPARED, REQ_CIK_GVKEY_LINK_FILE, REQ_GVKEY_PERMCO_FILE, REQ_PERMNO_IBES_LINK_FILE, REQ_IBES_GUIDANCE_FILE, REQ_COMPUSTAT_FS_ITEMS_FILE, REQ_EIKON_IPO_DATES_1_FILE, REQ_EIKON_IPO_DATES_2_FILE, REQ_FACTSET_IPO_DATES_FILE, REQ_CIQ_IPO_2000_2009_FILE, REQ_CIQ_IPO_2010_2016_FILE, REQ_CIQ_IPO_2017_2020_FILE, REQ_CIQ_IPO_2021_2022_FILE, REQ_COUNTRY_ISO_FILE, REQ_FACTSET_MANUAL_IPO_FILE, REQ_10K_METADATA_FILE, REQ_8K_ITEMS_METADATA_FILE, REQ_MANDATORY_DISCLOSURE_YEARS_FILE, REQ_WORLD_BANK_COUNTRY_CONTROLS, ISS_PREQIN_SOURCE_ROUTES, ISS_PUBLICFIRM_SOURCE_ROUTES, ISS_HEDGEFUND_SOURCE_ROUTES, ISS_MANDATORY_DISCLOSURE_INPUT, ISS_LANGUAGE_SCHEMA_HANDOFF, ISS_WORLD_BANK_PUBLIC_ROUTE, ISS_TRI_MATCHING_SCRIPT, ISS_ESG_DICTIONARY_HEADER_HANDOFF, ISS_TRUCOST_SOURCE_COMPATIBILITY
Evidence: E_SOURCES, E_CODES_README, E_MAIN_GPT_PATHS, E_LDA_INPUTS, E_GPT_SAMPLE_FILES, E_PACKAGE_INVENTORY, E_STEP1_EXAMPLES, E_STEP2_CHAIN, E_STEP4_DICTIONARY, E_STEP5_OUTPUTS, E_STEP6_PE, E_PUB_10K_INTERMEDIATE, E_PUB_8K_INTERMEDIATE, E_PUB_VOLUNTARY_OUTPUTS, E_LANG_INPUT_OUTPUT, E_ANALYSIS_DEAL_COHORT, E_ANALYSIS_LP_WEIGHTS, E_ANALYSIS_CONTROLS, E_ANALYSIS_ESG_PANEL, E_ANALYSIS_FUNDRAISING, E_ANALYSIS_TRI_OUTCOME, E_ANALYSIS_TRUCOST_OUTCOME, E_ANALYSIS_REPRISK_OUTCOME, E_ANALYSIS_OSHA_OUTCOME, E_PREQIN_MANAGER_IMPORT, E_PREQIN_FUNDS, E_PREQIN_BUYOUT_IMPORT, E_PREQIN_VC_DEALS, E_PREQIN_LPS, E_PREQIN_MAP_INPUTS, E_PREQIN_ROUNDS_1_4, E_PREQIN_ROUNDS_5_8, E_HF_ROUND_OUTPUT, E_WORLDBANK_API, E_ANALYSIS_MANDATORY_YEARS, E_ANALYSIS_PRI_SIGNATORIES, E_WORLDBANK_API_DOCS, E_SEC_EDGAR_PUBLIC_DOCS, E_WAYBACK_CDX_DOCS, E_TRI_MATCHING_INTERLEAVE, E_TRI_MATCHING_SOURCE_INVENTORY, E_STATA_IMPORT_DELIMITED_DOC, E_PUBLIC_DATA, E_IO_P_G0009, E_IO_P_G0010, E_IO_P_G0011, E_IO_P_G0014, E_IO_P_G0015, E_IO_P_G0016, E_IO_P_G0017, E_IO_P_G0019, E_IO_P_G0020, E_IO_P_G0021, E_IO_P_G0068, E_IO_P_G0069, E_IO_P_G0070, E_IO_P_G0071, E_IO_P_G0072, E_IO_P_G0073, E_IO_P_G0075, E_IO_P_G0076, E_IO_P_G0077, E_IO_P_G0132, E_IO_P_G0133, E_IO_P_G0134, E_IO_P_G0135, E_IO_P_G0138, E_IO_P_G0141, E_IO_P_G0142, E_IO_P_G0143, E_IO_P_G0144, E_PROBE_PACKAGED_ESG_DICTIONARY, E_ESG_DICTIONARY_CLEANER, E_ESG_DICTIONARY_WORDCOUNT, E_IO_C_D0018, E_IO_C_D0022, E_IO_C_D0023, E_IO_C_D0024, E_IO_C_D0025, E_IO_C_D0026, E_IO_C_D0027, E_IO_C_D0028, E_IO_C_D0029, E_IO_C_D0062, E_IO_C_D0078, E_IO_C_D0079, E_IO_C_D0136, E_IO_C_D0137, E_IO_C_D0145, E_PROBE_COMPANY_IPODATE, E_PROBE_GCOMPANY_IPODATE, E_PROBE_CRSP_CCM_LINK, E_PROBE_IBES_GUIDANCE_TICKER, E_PROBE_REPRISK_RRI, E_PROBE_REPRISK_IDS, E_PROBE_TRUCOST_ENV, E_PROBE_TRUCOST_COMPANIES

Preparation / proposed procedure:

1. Resolve each separately listed author-named input, source history, and missing upstream source body; do not substitute unlike local products based on one-row readability alone.
2. Prepare the documented upstream Stata products with code_preqin.do, code_hedgeFunds.do, code_publicFirms.do, code_worldbank.do, code_TRI.do, code_trucost.do, code_reprisk.do, and code_osha.do in dependency order.
3. Run code_TRI_name_matching.py at the documented code_TRI.do line 833 interleave once its missing source is available; preserve its exact source/input/output mapping.
4. Run the website-disclosure chain from Step 1 through Step 6 with the intended full PE/HF lists and required runtime; the supplied Step 1 branch selects example files, so sample outputs alone do not establish full-sample coverage.
5. Run the Python language, 10-K/8-K, LLM, and LDA branches only after their named input tables/text and software resources are prepared; preserve an isolated working copy for the Main GPT branch's temporary-directory recreation.
6. Run code_analysis.do after the required PE, HF, public-firm, World Bank, TRI, Trucost, RepRisk, and OSHA producer outputs are present.
7. Confirm the bundled dictionary's header treatment and required term-list vintage when interpreting cleaning or word-count results; do not alter the author source during this assessment.
8. Keep the matched-disclosure public route and SEC filing documentation scoped to the prepared/public products they describe; neither closes unrelated raw or prepared input contracts without exact compatibility evidence.

Validation to perform later:

- Confirm all 159 dependency IDs are covered exactly once by source-supported producers or specifically named unresolved inputs before any author execution; this assessment did not execute the workflow.

### ACT_CHECK_REQUIRED_SOFTWARE: Reconcile source-used Python distributions, Stata commands, and scraper executables using exact bounded version/distribution/which metadata. The checks identify installed prerequisites and specific missing packages/commands; no author code or data was run.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_PYTHON, SW_STATA, SW_OPENAI_API, SW_NLTK, SW_SCIKIT_LEARN, SW_GENSIM, ISS_API_SETUP, SW_REQUESTS, SW_SELENIUM_WIRE, SW_BEAUTIFULSOUP, SW_LXML, SW_CHROME, SW_CHROMEDRIVER, SW_PROXY_CONFIG, ISS_SCRAPE_RUNTIME_ROUTE, SW_WBOPENDATA, SW_KOUNTRY, ISS_WORLD_BANK_PUBLIC_ROUTE, SW_DISTINCT, SW_WINSOR2, SW_REGHDFE, SW_ESTOUT, SW_PPMHDFE, SW_STACKEDEV, SW_DROPMISS, SW_USTRDIST, SW_CARRYFORWARD, SW_GXTILE, SW_GNVALS, SW_SELENIUM, SW_TIKTOKEN, SW_LANGDETECT, SW_PYCLD2, SW_SCHEDULE, SW_PANDAS, SW_NUMPY, SW_PYTHON_DOTENV, SW_OPENPYXL
Evidence: E_CLEANING_LANGUAGES, E_CODES_README, E_MAIN_GPT_API, E_LDA_MODEL, E_NLTK_RESOURCES, E_STEP1_IMPORTS, E_STEP1_DRIVER_PATH, E_STEP3_SETUP, E_STEP3_DRIVER, E_STEP3_FETCH, E_STEP3_URL_IMPORTS, E_PROXY_HELPER_SHAPE, E_PROXY_HELPER_RETURN, E_WORLDBANK_API, E_WORLDBANK_OUTPUT, E_STATA_SOFTWARE_METADATA, E_STATA_DISTINCT, E_STATA_WINSOR2, E_STATA_REGRESSION_COMMANDS, E_STATA_ESTOUT, E_STATA_PPMHDFE, E_STATA_USTRDIST, E_STATA_EGEN_NVALS, E_PROBE_STATA_DISTINCT, E_PROBE_STATA_WINSOR2, E_PROBE_STATA_REGHDFE, E_PROBE_STATA_ESTOUT, E_PROBE_STATA_ESTSTO, E_PROBE_STATA_ESTADD, E_PROBE_STATA_PPMLHDFE, E_PROBE_STATA_STACKEDEV, E_PROBE_STATA_DROPMISS, E_PROBE_STATA_USTRDIST, E_PROBE_STATA_CARRYFORWARD, E_PROBE_STATA_WBOPENDATA, E_PROBE_STATA_KOUNTRY, E_PROBE_STATA_GXTILE, E_PROBE_STATA_GNVALS, E_PROBE_PY_RUNTIME, E_PROBE_PY_DIST_SCIKIT_LEARN, E_PROBE_PY_DIST_NLTK, E_PROBE_PY_DIST_NUMPY, E_PROBE_PY_DIST_PANDAS, E_PROBE_PY_DIST_GENSIM, E_PROBE_PY_DIST_REQUESTS, E_PROBE_PY_DIST_SELENIUM_WIRE, E_PROBE_PY_DIST_SELENIUM, E_PROBE_PY_DIST_BEAUTIFULSOUP4, E_PROBE_PY_DIST_LXML, E_PROBE_PY_DIST_OPENAI, E_PROBE_PY_DIST_TIKTOKEN, E_PROBE_PY_DIST_LANGDETECT, E_PROBE_PY_DIST_PYCLD2, E_PROBE_PY_DIST_SCHEDULE, E_PROBE_WHICH_GOOGLE_CHROME, E_PROBE_BROWSER_VERSION_GOOGLE_CHROME, E_PROBE_WHICH_CHROMEDRIVER, E_PROBE_PACKAGE_CHROMEDRIVER_PATH, E_PYTHON_DIST_METADATA_SUMMARY, E_PROBE_REGISTERED_ENVIRONMENT, E_PROBE_SOFTWARE_METADATA_BATCH, E_MAIN_GPT_DOTENV_IMPORT, E_GPT_TOPIC_DOTENV_IMPORT, E_STEP4_XLSX_READ, E_PANDAS_30_XLSX_ENGINE_DOCS, E_PROBE_NEW_SOURCE_DEPENDENCY_METADATA_BATCH

Preparation / proposed procedure:

1. Set up the source-used distributions and Stata add-ons absent from exact local checks before attempting a complete run.
2. Align requests, pandas, and beautifulsoup4 with the supplied Step 3 version ranges before attempting the scraper.
3. Resolve Selenium, Selenium Wire, and a compatible ChromeDriver; Chrome is present, but the driver and Selenium distributions were not found.
4. Check required NLTK corpora and OpenAI/proxy configuration only through the normal authorized project process; keep credential values opaque.
5. Do not issue World Bank, SEC, or Wayback data requests during this assessment.

Validation to perform later:

- Confirm each source-used distribution and Stata command has a matching exact metadata record or a specifically stated unresolved setup requirement.

### ACT_VERIFY_SOURCE_INPUT_ROUTES: Reconcile each independently consumed input against only existing exact local/public route evidence; retain one-row readability as partial field credit when the full input contract, mapping, or history remains unverified.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_PREQIN_MANAGER_FILE, REQ_PEIRANK_2022_FILE, REQ_PEIRANK_2021_FILE, REQ_PEIRANK_2020_FILE, REQ_PEIRANK_2019_FILE, REQ_PREQIN_FUNDS_FILE, REQ_PREQIN_PERFORMANCE_FILES, REQ_PREQIN_BUYOUT_INVESTORS_FILE, REQ_PREQIN_BUYOUT_DETAILS_FILE, REQ_PREQIN_BUYOUT_EXITS_FILE, REQ_PREQIN_VC_DEALS_FILE, REQ_PREQIN_VC_INVESTORS_FILE, REQ_PREQIN_VC_EXITS_FILE, REQ_PREQIN_LPS_FILE, REQ_PRI_SIGNATORY_FILE, REQ_PREQIN_MAP_20230307_FILE, REQ_PREQIN_MAP_20230418_FILE, REQ_WEBSITE_EXCLUSION_FILE, REQ_EIKON_HF_US_FILE, REQ_EIKON_HF_NONUS_FILE, REQ_COMPUSTAT_NA_IPO_FILE, REQ_COMPUSTAT_GLOBAL_IPO_FILE, REQ_IPODATES_US_PREPARED, REQ_CIK_GVKEY_LINK_FILE, REQ_GVKEY_PERMCO_FILE, REQ_PERMNO_IBES_LINK_FILE, REQ_IBES_GUIDANCE_FILE, REQ_COMPUSTAT_FS_ITEMS_FILE, REQ_EIKON_IPO_DATES_1_FILE, REQ_EIKON_IPO_DATES_2_FILE, REQ_FACTSET_IPO_DATES_FILE, REQ_CIQ_IPO_2000_2009_FILE, REQ_CIQ_IPO_2010_2016_FILE, REQ_CIQ_IPO_2017_2020_FILE, REQ_CIQ_IPO_2021_2022_FILE, REQ_COUNTRY_ISO_FILE, REQ_FACTSET_MANUAL_IPO_FILE, REQ_10K_METADATA_FILE, REQ_8K_ITEMS_METADATA_FILE, REQ_MANDATORY_DISCLOSURE_YEARS_FILE, REQ_WORLD_BANK_COUNTRY_CONTROLS, ISS_PREQIN_SOURCE_ROUTES, ISS_PUBLICFIRM_SOURCE_ROUTES, ISS_HEDGEFUND_SOURCE_ROUTES, ISS_MANDATORY_DISCLOSURE_INPUT, ISS_LANGUAGE_SCHEMA_HANDOFF, ISS_WORLD_BANK_PUBLIC_ROUTE, REQ_TRI_MANUAL_MATCH_TABLE, REQ_TRI_BASICPLUS_YEARLY_US4_FILES, REQ_TRI_STD_MATCHED_FILE, REQ_TRI_VIN_MATCHED_FILE, REQ_TRI_VINSTD_MATCHED_FILE, REQ_TRI_SUB_MATCHED_FILE, REQ_TRI_FAC_MATCHED_FILE, REQ_RSEI_CHEMICAL_DATA_FILE, REQ_CLEAN_AIR_ACT_CHEMICAL_LIST, REQ_ANALYSIS_TA_DYNAMIC_FILES, REQ_OSHA_ACCIDENTS_CSV, REQ_OSHA_ACCIDENT_INJURY_CSV, REQ_REPRISK_COMPANY_IDENTIFIERS_FILE, REQ_REPRISK_ANNUAL_RRI_FILES, REQ_TRUCOST_RAW_DATA_FILE, REQ_WAYBACK_ARCHIVE, ISS_TRI_MATCHING_SCRIPT, ISS_TRUCOST_SOURCE_COMPATIBILITY, ISS_INPUT_COMPATIBILITY
Evidence: E_NAMED_INPUT_INVENTORY, E_PREQIN_MANAGER_IMPORT, E_PREQIN_BUYOUT_IMPORT, E_PREQIN_VC_DEALS, E_HF_EIKON_INPUTS, E_PUB_COMPUSTAT_SOURCES, E_PUB_GUIDANCE_INPUTS, E_PUB_FINANCIAL_ITEMS, E_PUB_10K_INTERMEDIATE, E_PUB_8K_INTERMEDIATE, E_ANALYSIS_MANDATORY_YEARS, E_WORLDBANK_API_DOCS, E_SEC_EDGAR_PUBLIC_DOCS, E_WAYBACK_CDX_DOCS, E_PUBLIC_DATA, E_TRI_MATCHING_INTERLEAVE, E_TRI_MATCHING_SOURCE_INVENTORY, E_STATA_IMPORT_DELIMITED_DOC, E_IO_C_D0018, E_IO_C_D0022, E_IO_C_D0023, E_IO_C_D0024, E_IO_C_D0025, E_IO_C_D0026, E_IO_C_D0027, E_IO_C_D0028, E_IO_C_D0029, E_IO_C_D0062, E_IO_C_D0078, E_IO_C_D0079, E_IO_C_D0136, E_IO_C_D0137, E_IO_C_D0145, E_PROBE_COMPANY_IPODATE, E_PROBE_GCOMPANY_IPODATE, E_PROBE_CRSP_CCM_LINK, E_PROBE_IBES_GUIDANCE_TICKER, E_PROBE_REPRISK_RRI, E_PROBE_REPRISK_IDS, E_PROBE_TRUCOST_ENV, E_PROBE_TRUCOST_COMPANIES

Preparation / proposed procedure:

1. Resolve the separate TRI manual match table and code_TRI_name_matching.py interleave, the Basic Plus yearly US_4_yr files, and each stdMatched, vinMatched, vinStdMatched, subMatched, and FacMatched mapping input independently.
2. Resolve the separate RSEI chemical_data_rsei_v2311.csv source and clean air act.xlsx chemical-list workbook; keep source history and route compatibility unresolved where existing evidence does not establish them.
3. Keep the macro-expanded analysis ta_i.txt family as a separate unresolved requirement because no matching producer is present in the supplied source.
4. Resolve the dated OSHA accident CSV and accident-injury CSV as two separate inputs and preserve their unknown upstream raw-data history.
5. Resolve RepRisk companyIdentifiers_20230609.txt separately from the annual `i'_20230410.txt RRI family; the one-row local product probes support only RepRisk_ID/current_RRI fields and do not establish full file/year compatibility.
6. Resolve the author-named trucost_rawData_20230608.txt separately. Preserve WRDS_ENVIRONMENT fields as partial evidence and WRDS_COMPANIES institutionid as a component lead, not as a verified substitute for that raw input.
7. Keep the six Compustat/CRSP/IBES routes for the five IPO/link/guidance requirements unverified where only ipodate, lpermno/linkdt, or ticker was checked and the complete fields, ticker/PERMNO mapping, dates, or prepared transformation remain unknown.
8. Retain the authors' matched-disclosure page as an unverified prepared-data route lead and SEC EDGAR documentation as public underlying-filing evidence only; do not use either to close different raw or prepared inputs.
9. Retarget the US and non-US Eikon workbooks, the PE and hedge-fund example lists, and the final-dictionary workbook to their existing separate requirements.

Validation to perform later:

- Confirm every public or local route remains scoped to its cited product/fields and does not replace unresolved author-specific prepared inputs.


## Remaining issues and prerequisites

- ISS_DEPENDENCY_TRACE [unresolved; full_pipeline]: All 159 frozen dependency IDs are grouped once and traced to exact supplied consumers and active in-supplied producers where present, including distinct PE/HF, native source-product, and macro-expanded branches. The separately required unresolved inputs include the manual TRI match table, Basic Plus yearly raw files, five distinct TRI mapping tables, RSEI and Clean Air Act files, dynamic analysis ta_i files, separate OSHA accident and injury CSVs, RepRisk company identifiers and annual RRI files, and the Trucost raw text file. The missing code_TRI_name_matching.py source and the specific source/history/mapping gaps remain unresolved; these do not establish product-wide absence or an entitlement barrier.
- ISS_INPUT_COMPATIBILITY [unresolved; full_pipeline]: Bounded local probes confirm selected fields/readability in Compustat North America and Global, IBES ID_GUIDANCE, CRSP CCMXPF_LINKTABLE, RepRisk PM_RRI_DATA/PM_COMPANY_IDENTIFIERS, and Trucost WRDS_ENVIRONMENT/WRDS_COMPANIES. Local candidate routes are assigned only to the matching RepRisk annual-RRI, RepRisk company-identifier, and Trucost raw-data requirements and remain unverified where author-file fields, identifiers, dates, history, or preparation mappings are unresolved; WRDS_COMPANIES remains a component lead in the separate Trucost issue. The authors' public data page describes PE-firm disclosures and EPA TRI, Trucost, OSHA, and RepRisk firms matched to Preqin; this is a prepared/matched-data route lead only. Exact files and contracts, coverage, and raw-to-prepared equivalence are unverified, so it does not close the separate raw-input requirements. These gaps do not establish product-wide absence, incompatibility, or a license barrier.
- ISS_LLM_INPUT_ROUTE [unresolved; full_pipeline]: The Python workflow consumes separate website-text and LDA-report directories. Its README describes 100 demonstration pages and seven 2021 reports, but neither input directory is present in the frozen package inventory; the stated author-page route and its full-workflow coverage remain unverified.
- ISS_API_SETUP [unresolved; full_pipeline]: The supplied Python scripts call OpenAI ChatCompletion, but current API access and credential configuration are not verified. Credential-bearing statements and the .env contents were kept opaque; this is not evidence of an access barrier.
- ISS_ROUND_LIST_PRODUCERS [unresolved; full_pipeline]: The sources do identify the full-list producers: code_preqin generates PE rounds 1–8 and code_hedgeFunds generates rounds/hedgeFunds.txt. Step 1 initially reads PE rounds 1–7 and hedgeFunds.txt, omits generated round 8, then overwrites both lists with separate PE/HF example files. The operative scrape therefore depends on the example files; how that example branch relates to the paper-wide full scrape remains unresolved.
- ISS_STEP4_DICTIONARY_ROUTE [unresolved; full_pipeline]: The Step 4 word-mapping workbook and its three sheet contracts are required for snapshot-level ESG construction, but the exact workbook is not listed in the package inventory and no compatible route has been verified.
- ISS_SCRAPE_RUNTIME_ROUTE [unresolved; full_pipeline]: The source uses public Wayback CDX and archived-page routes; Internet Archive's official documentation confirms the CDX route family, but no specific URL coverage query was made. requests is installed at 2.34.2 outside the supplied 2.30.x range; pandas 3.0.6 and beautifulsoup4 4.15.0 are also outside their declared Step 3 ranges. Selenium and Selenium Wire are absent, Chrome is present, no ChromeDriver path was found, and proxy configuration remains opaque. These are concrete preparation/runtime gaps, not a documented entitlement barrier.
- ISS_PREQIN_SOURCE_ROUTES [unresolved; full_pipeline]: The supplied Preqin preparation source requires separate manager, fund, performance, buyout, VC, LP, ranking, and investor-mapping inputs. Their named paths are absent from the frozen package inventory; compatible local/product routes and source-to-prepared field/history mappings remain unverified. Package omission does not establish product-wide absence or a license barrier.
- ISS_PUBLICFIRM_SOURCE_ROUTES [unresolved; full_pipeline]: The public-firm workflow names separate Eikon, FactSet, Capital IQ, Compustat, IBES/CRSP-link, and prepared 10-K/8-K metadata inputs. Official SEC documentation confirms public underlying filing/API routes, but the author-named metadata tables and exact mappings remain unresolved. Local one-row checks verify only Compustat ipodate, IBES ticker, and CRSP lpermno/linkdt product fields; other required fields, source vintage/history, and crosswalks remain unverified. These gaps do not establish product absence or an access barrier.
- ISS_HEDGEFUND_SOURCE_ROUTES [unresolved; full_pipeline]: The hedge-fund branch requires two separate Eikon workbooks to prepare hedge-fund websites; the named paths are not listed in the frozen package inventory and no compatible local/product route has yet been verified.
- ISS_MANDATORY_DISCLOSURE_INPUT [unresolved; full_pipeline]: The analysis requires a separate country-year mandatory-disclosure workbook to construct regulation exposure. The named path is not listed in the frozen package inventory and no compatible route has yet been verified.
- ISS_LANGUAGE_SCHEMA_HANDOFF [unresolved; full_pipeline]: The language script writes a CSV with a `website available` header that code_preqin later references as `websiteavailable`. Stata 18 import delimited documentation says it translates headers into valid variable names and lowercases by default, so this is not a demonstrated spelling mismatch. The exact imported field name/label and row compatibility remain unverified without a parser trial, which was not performed.
- ISS_WORLD_BANK_PUBLIC_ROUTE [unresolved; full_pipeline]: Official World Bank documentation confirms a public Indicators API v2 route with no authentication requirement, while the exact source-used wbopendata command is absent locally and kountry is also absent. The command's v2 compatibility, exact returned fields, and 1999-2023 historical coverage remain unverified; no data request was made.
- ISS_TRI_MATCHING_SCRIPT [unresolved; full_pipeline]: Both the README and code_TRI.do line 833 identify code_TRI_name_matching.py as an interleaved step, but the script is absent from the assigned source inventory. Its exact raw inputs, outputs, and matching behavior therefore remain unknown; do not infer or reconstruct them from later tables.
- ISS_ESG_DICTIONARY_HEADER_HANDOFF [preparation; full_pipeline]: The packaged one-column dictionary is readable, and both supplied Python consumers add row[0] for each csv.reader row without explicitly skipping a header. Thus the literal code will include the header text in the term set if it is present as a row. Whether this is intended is a measurement/definition question; it does not establish an execution blocker. No raw term values or author execution were used.
- ISS_TRUCOST_SOURCE_COMPATIBILITY [unresolved; full_pipeline]: The author source edge imports trucost_rawData_20230608.txt. The bounded WRDS_ENVIRONMENT probe confirms only institutionid and di_319413 in one readable row; WRDS_COMPANIES confirms only institutionid in one readable row. These are partial source-field/component leads and do not establish the author's raw text file, other consumed variables, date coverage, company-name matching, or source-to-prepared output mapping. The supplied dependency ledger has no separate edge that consumes WRDS_COMPANIES as a standalone input, so it is not a verified alternative to the raw text requirement.
- REQ_TRI_MANUAL_MATCH_TABLE [undetermined]: The TRI workflow consumes a separate manually matched TRI name table. Its exact file name, source history, matching keys, and compatible route remain unresolved; the documented code_TRI_name_matching.py interleave is absent from the assigned source set.
- REQ_TRI_BASICPLUS_YEARLY_US4_FILES [undetermined]: The TRI workflow directly imports the macro-expanded Basic Plus yearly US_4_`yr'.txt source-file family. No producer for those raw yearly files is present in the supplied source; file-year coverage and source history remain unresolved.
- REQ_TRI_STD_MATCHED_FILE [undetermined]: The TRI matching workflow imports the separate author-named stdMatched.txt mapping input. Its preparation history, matching keys, and compatible route remain unresolved.
- REQ_TRI_VIN_MATCHED_FILE [undetermined]: The TRI matching workflow imports the separate author-named vinMatched.txt mapping input. Its preparation history, matching keys, and compatible route remain unresolved.
- REQ_TRI_VINSTD_MATCHED_FILE [undetermined]: The TRI matching workflow imports the separate author-named vinStdMatched.txt mapping input. Its preparation history, matching keys, and compatible route remain unresolved.
- REQ_TRI_SUB_MATCHED_FILE [undetermined]: The TRI matching workflow imports the separate author-named subMatched.txt mapping input. Its preparation history, matching keys, and compatible route remain unresolved.
- REQ_TRI_FAC_MATCHED_FILE [undetermined]: The TRI matching workflow imports the separate author-named FacMatched.txt mapping input. Its preparation history, matching keys, and compatible route remain unresolved.
- REQ_RSEI_CHEMICAL_DATA_FILE [undetermined]: The TRI workflow imports the named RSEI chemical_data_rsei_v2311.csv source file. Its source history, exact route, and compatibility with the consuming workflow remain unresolved.
- REQ_CLEAN_AIR_ACT_CHEMICAL_LIST [undetermined]: The TRI workflow imports a separate clean air act.xlsx chemical-list workbook. Its preparation history, exact route, and compatibility remain unresolved.
- REQ_ANALYSIS_TA_DYNAMIC_FILES [undetermined]: code_analysis.do imports the macro-expanded ta_`i'.txt files in several branches. No matching producer for this dynamic file family is present in the supplied source; the family contract and history remain unresolved.
- REQ_OSHA_ACCIDENTS_CSV [undetermined]: The OSHA workflow imports the author-named dated accident CSV. Its upstream raw-data route and source-vintage history are not established by the supplied source edge.
- REQ_OSHA_ACCIDENT_INJURY_CSV [undetermined]: The OSHA workflow imports the separate author-named dated accident-injury CSV. Its upstream raw-data route and source-vintage history are not established by the supplied source edge.
- REQ_REPRISK_COMPANY_IDENTIFIERS_FILE [undetermined]: The RepRisk workflow imports the separate companyIdentifiers_20230609.txt identifier file. The author-specific text source, identifier/date preparation, and compatible route remain unresolved.
- REQ_REPRISK_ANNUAL_RRI_FILES [undetermined]: The RepRisk workflow imports a macro-expanded annual series of `i'_20230410.txt source files. Year coverage, raw-to-prepared history, and full source-field compatibility remain unresolved.
- REQ_TRUCOST_RAW_DATA_FILE [undetermined]: The Trucost workflow imports the author-named trucost_rawData_20230608.txt input. The local WRDS environment table provides only a partial underlying product field check; the raw text source, other fields, dates, company-name matching, and prepared-output mapping remain unresolved.
- REQ_FIRM_TEXT [undetermined]: The LLM GPT cleaning stage requires raw website .txt files under LLM GPT/Data/Firmfiles; the cleaner generates Firmfiles_cleaned, which the Main GPT and word-count branches consume. The README describes 100 demonstration pages, but the frozen package inventory does not list those text inputs; full-sample availability and compatibility remain unresolved.
- REQ_LDA_TEXTFILES [undetermined]: The independent LDA topic-distribution and perplexity/coherence scripts consume .txt reports from LLM GPT/Data/LDA_textfiles. The README says its separate demonstration uses seven firms' 2021 ESG reports; no matching input path appears in the frozen package inventory.
- REQ_PE_ROUND_EXAMPLE [undetermined]: Step 1's operative PE branch reads roundPE example.txt relative to the Data/Data_website/Scrapping working directory after overwriting its initially read full round lists. Its producer, identifier/URL schema, and population coverage remain to be reconciled with the Preqin code.
- REQ_HF_ROUND_EXAMPLE [undetermined]: Step 1's operative hedge-fund branch separately reads roundHF example.txt relative to the Data/Data_website/Scrapping working directory after overwriting the initial list. Its producer, identifier/URL schema, and population coverage remain unresolved.
- REQ_FINAL_DICTIONARIES [undetermined]: Step 4 requires Dictionaries_final.xlsx with the full lists, esg dictionaries, and individual lists sheets to map word counts into ESG and non-ESG measures. It is a separate workbook from LLM GPT/Data/ESG_Dictionary.csv; its local/public route and field compatibility are unverified.
- REQ_WAYBACK_ARCHIVE [undetermined]: The website branch obtains Wayback CDX URL/date/metadata records and archived HTML snapshots for the supplied PE and hedge-fund URLs. Code requests cover 1996–2022 and derive annual snapshots; official route/access and population compatibility remain unverified.
- REQ_PREQIN_MANAGER_FILE [undetermined]: Preqin fund-manager source workbook used to create the processed manager table.
- REQ_PEIRANK_2022_FILE [undetermined]: The PEI 2022 ranking workbook contributes a separate top-manager ranking list.
- REQ_PEIRANK_2021_FILE [undetermined]: The PEI 2021 ranking workbook contributes a separate top-manager ranking list.
- REQ_PEIRANK_2020_FILE [undetermined]: The PEI 2020 ranking workbook contributes a separate top-manager ranking list.
- REQ_PEIRANK_2019_FILE [undetermined]: The PEI 2019 ranking workbook contributes a separate top-manager ranking list.
- REQ_PREQIN_FUNDS_FILE [undetermined]: Preqin fund-level source table used to create the processed fund table.
- REQ_PREQIN_PERFORMANCE_FILES [undetermined]: Quarterly Preqin performance tables checked over 2000–2022 and appended when present.
- REQ_PREQIN_BUYOUT_INVESTORS_FILE [undetermined]: Preqin buyout investor/lender source workbook used to construct deal and investor tables.
- REQ_PREQIN_BUYOUT_DETAILS_FILE [undetermined]: Separate Preqin buyout deal-detail workbook joined to the processed deal table.
- REQ_PREQIN_BUYOUT_EXITS_FILE [undetermined]: Separate Preqin buyout exit workbook used to build exit outcomes.
- REQ_PREQIN_VC_DEALS_FILE [undetermined]: Separate Preqin venture-capital deal source workbook.
- REQ_PREQIN_VC_INVESTORS_FILE [undetermined]: Separate Preqin venture-capital investor/lender source workbook.
- REQ_PREQIN_VC_EXITS_FILE [undetermined]: Separate Preqin venture-capital exits source workbook.
- REQ_PREQIN_LPS_FILE [undetermined]: Preqin LP source workbook used to create the processed LP table.
- REQ_PRI_SIGNATORY_FILE [undetermined]: PRI signatory workbook used by both Preqin linkage and the analysis appendix.
- REQ_PREQIN_MAP_20230307_FILE [undetermined]: First dated Preqin investor-to-fund mapping workbook.
- REQ_PREQIN_MAP_20230418_FILE [undetermined]: Second dated Preqin investor-to-fund mapping workbook appended to the first mapping table.
- REQ_WEBSITE_EXCLUSION_FILE [undetermined]: Author-relative website exclusion list imported during manager preparation.
- REQ_EIKON_HF_US_FILE [undetermined]: Eikon US hedge-fund workbook used to construct the hedge-fund website panel.
- REQ_EIKON_HF_NONUS_FILE [undetermined]: Eikon non-US hedge-fund workbook appended to the US hedge-fund table.
- REQ_COMPUSTAT_NA_IPO_FILE [undetermined]: Compustat North America IPO/link table used in the public-firm IPO merge.
- REQ_COMPUSTAT_GLOBAL_IPO_FILE [undetermined]: Compustat Global IPO/link table used in the public-firm IPO merge.
- REQ_IPODATES_US_PREPARED [undetermined]: Prepared US IPO panel read before the public-firm source rewrites it after CIK linking.
- REQ_CIK_GVKEY_LINK_FILE [undetermined]: Prepared GVKEY/ticker/CIK linking table used by the public-firm source.
- REQ_GVKEY_PERMCO_FILE [undetermined]: Prepared GVKEY/PERMCO/CRSP linking table used by the management-guidance branch.
- REQ_PERMNO_IBES_LINK_FILE [undetermined]: Prepared PERMNO/IBES ticker-date linking table used by the management-guidance branch.
- REQ_IBES_GUIDANCE_FILE [undetermined]: IBES guidance observations used to derive management forecast counts.
- REQ_COMPUSTAT_FS_ITEMS_FILE [undetermined]: Compustat financial-statement items table used to build the disaggregation measure.
- REQ_EIKON_IPO_DATES_1_FILE [undetermined]: First Eikon IPO-date workbook used to build the public-firm date panel.
- REQ_EIKON_IPO_DATES_2_FILE [undetermined]: Second Eikon IPO-date workbook appended to the public-firm date panel.
- REQ_FACTSET_IPO_DATES_FILE [undetermined]: FactSet IPO-date source workbook used in the public-firm date merge.
- REQ_CIQ_IPO_2000_2009_FILE [undetermined]: Capital IQ IPO source workbook for the first date range.
- REQ_CIQ_IPO_2010_2016_FILE [undetermined]: Capital IQ IPO source workbook for the second date range.
- REQ_CIQ_IPO_2017_2020_FILE [undetermined]: Capital IQ IPO source workbook for the third date range.
- REQ_CIQ_IPO_2021_2022_FILE [undetermined]: Capital IQ IPO source workbook for the fourth date range.
- REQ_COUNTRY_ISO_FILE [undetermined]: Country ISO-code workbook used to merge country labels into the public-firm list.
- REQ_FACTSET_MANUAL_IPO_FILE [undetermined]: Manually collected FactSet IPO-date workbook used to supplement the processed date table.
- REQ_10K_METADATA_FILE [undetermined]: Prepared 10-K filing metadata table joined to US CIKs before a generated Python URL table is created.
- REQ_8K_ITEMS_METADATA_FILE [undetermined]: Prepared 8-K filing/item metadata table joined to US CIKs before a generated Python index-URL table is created.
- REQ_MANDATORY_DISCLOSURE_YEARS_FILE [undetermined]: Country-by-year mandatory-disclosure workbook used to construct regulation exposures.
- REQ_WORLD_BANK_COUNTRY_CONTROLS [undetermined]: The analysis requires country-year GDP, GDP growth, population, labor-force participation, and women-in-parliament controls. The supplied preparation source calls the World Bank Open Data Stata command and writes worldbank.dta.
- SW_OPENAI_API [unverified]: The openai Python distribution is installed, but the source's ChatCompletion API compatibility, API access, and secure credential configuration remain unverified. The credential-bearing statements and .env contents were kept opaque.
- SW_GENSIM [preparation_required]: The source imports gensim; the exact distribution check did not find it installed.
- SW_REQUESTS [preparation_required]: The requests distribution is installed at 2.34.2, while the supplied Step 3 requirements specify requests~=2.30.0. Set up a version within the declared range before attempting the scraper; no Wayback or other outbound request was made.
- SW_SELENIUM_WIRE [preparation_required]: The Step 1 source imports Selenium Wire; the exact selenium-wire distribution check did not find it installed.
- SW_BEAUTIFULSOUP [preparation_required]: The beautifulsoup4 distribution is installed at 4.15.0, while the supplied Step 3 requirements specify beautifulsoup4~=4.12.2. Set up a version within the declared range before attempting the scraper.
- SW_CHROMEDRIVER [preparation_required]: No chromedriver executable was found on PATH, and the exact source-named packaged chromedriver.exe path is absent. A compatible driver route remains to be prepared.
- SW_PROXY_CONFIG [unverified]: Step 1 and page-fetch code pass a proxy configuration supplied by proxy_webshare.py. The credential-bearing proxy values were withheld; this does not prove a required paid account or an access barrier.
- SW_WBOPENDATA [preparation_required]: The World Bank preparation source invokes wbopendata. The exact Stata 18 `which` check did not find it locally; availability can be addressed by setting up the required command. No World Bank request was made.
- SW_KOUNTRY [preparation_required]: The World Bank preparation source invokes kountry for ISO conversion. The exact Stata 18 `which` check did not find it locally; availability can be addressed by setting up the required command. No data request was made.
- SW_DISTINCT [preparation_required]: The analysis source uses distinct; the exact Stata 18 `which` check did not find it locally.
- SW_WINSOR2 [preparation_required]: The TRI and website-measure sources use winsor2; the exact Stata 18 `which` check did not find it locally.
- SW_STACKEDEV [preparation_required]: The analysis source uses stackedev; the exact Stata 18 `which` check did not find it locally.
- SW_DROPMISS [preparation_required]: The World Bank preparation source uses dropmiss; the exact Stata 18 `which` check did not find it locally.
- SW_USTRDIST [preparation_required]: The Preqin and RepRisk matching sources use ustrdist; the exact Stata 18 `which` check did not find it locally.
- SW_CARRYFORWARD [preparation_required]: The analysis, TRI, Preqin, public-firm, and OSHA workflows use carryforward; the exact Stata 18 `which` check did not find it locally.
- SW_SELENIUM [preparation_required]: The scraper imports Selenium; the exact selenium distribution check did not find it installed.
- SW_LANGDETECT [preparation_required]: The language-detection source uses langdetect; its exact distribution check did not find it installed.
- SW_PYCLD2 [preparation_required]: The language-detection source uses pycld2; its exact distribution check did not find it installed.
- SW_SCHEDULE [preparation_required]: The supplied Step 3 requirements file declares schedule; the exact distribution check did not find it installed.
- SW_PANDAS [preparation_required]: The pandas distribution is installed at 3.0.6, while the supplied Step 3 requirements specify pandas~=2.0.1. Set up a version within the declared range before attempting the scraper.

## Review notes

- The title matches the frozen output header. The frozen DOI is preserved; no conflicting title was found in reviewed lines.
- The authors' April–June 2023 dataset vintage remains provenance context only; it is not treated as byte identity or a separate access prerequisite.
- The log README describes illustrative website-scraping logs for three firms. Those logs do not establish full-sample coverage or a required data input.
- The GPT README identifies demonstration inputs of 100 webpages and seven firms' 2021 reports. No matching Firmfiles or LDA_textfiles path is listed in the assigned package inventory; these samples do not establish a full prepared-input route.
- The GPT topic-summary program uses a literal topic string and calls the API directly; its supplied code does not read the LDA CSV outputs. Those outputs remain generated branch results rather than inputs to this script.
- The Main GPT script deletes and recreates temporary directories before processing. A future run procedure should use a separate working copy and preserve author originals.
- The observed website chain is PE/HF round lists → Wayback CDX URL-list pickles → Step 2 snapshotURLlevelList/scrapeList pickles → Step 3 raw-data ZIPs and ESGcounts pickles → Step 4 ESGmetrics pickles and snapshot tables joined with Dictionaries_final.xlsx → separate PE/HF Step 5 Stata tables → Step 6 labels/winsorization and PE Preqin merge.
- Step 1 reads larger PE/HF lists but then selects example files. This operative example branch is retained; it does not establish full-list coverage or the relationship to paper-wide analysis.
- Step 3 writes zipped scraped text under raw_data, while Step 4 consumes enriched ESGcounts pickles. The supplied sources do not demonstrate a handoff from those raw ZIPs to the separate LLM GPT Firmfiles directory.
- Step 6 and several Python wrappers use Windows-style relative paths. A future run needs a compatible working directory or consistent path preparation; no source path was edited.
- The README and assigned package identify the full upstream programs: Preqin, hedge funds, public firms, World Bank, TRI with its documented name-matching interleave, Trucost, RepRisk, and OSHA; the website and Python LLM/LDA stages feed the final analysis consumer.
- The public-firm Stata source generates 10KGrossSizeforPy.dta and 8KitemsforPy.dta for the Python consumers, but it requires separate prepared metadata tables. It also reads IPODatesUS.dta before rewriting it after CIK linking; no initial producer appears in code_publicFirms.do.
- The language script writes a website-availability header later referenced by code_preqin as websiteavailable. Stata 18 import delimited documentation describes lowercase valid-name normalization, so no spelling mismatch is asserted; exact post-import name and row compatibility were not trialed.
- The 159-edge ledger is complete with each ID covered once and exact active producer/consumer citations where the supplied source establishes them. Dynamic analysis text tables and specifically named raw source mappings remain unresolved.
- The authors state that matched disclosure materials are publicly available. That route is credited only for the matched/prepared dataset described; it does not identify all raw product inputs or exact file vintages.
- Local one-row SAS checks establish selected fields/readability for Compustat, IBES, CRSP, RepRisk, and Trucost only; they do not establish author-file equivalence, history, coverage, or merge completeness.
- Official static documentation identifies public World Bank Indicators API v2, SEC EDGAR filing/API access, and Internet Archive CDX documentation. No data/API payload or archive page was requested.
- Stata 18 was confirmed. Exact `which` checks found reghdfe, estout/eststo/estadd, ppmlhdfe, and `_gxtile`/`_gnvals`; distinct, winsor2, stackedev, dropmiss, ustrdist, carryforward, wbopendata, and kountry require preparation.
- The original registered environment probe confirms Python 3.12.14 and Stata 18. Bounded metadata-only batches confirm installed versions python-dotenv 1.2.4, openpyxl 3.1.5, nltk 3.10.3, scikit-learn 1.9.1, lxml 6.1.3, tiktoken 0.14.0, numpy 2.5.3, and Chrome 156.0.8078.79. The supplied requirements bands requests~=2.30.0, pandas~=2.0.1, and beautifulsoup4~=4.12.2 do not match the installed versions; gensim, selenium-wire, selenium, langdetect, pycld2, and declared schedule were not found. No chromedriver path was found, and NLTK corpora, API access, and proxy settings remain unverified.
- The scope has unresolved required source/input contracts, including the missing TRI matching script and unknown prepared-input history. The frozen finalizer will derive data and execution status from the completed requirements, issues, actions, and closure facts; execution remains unverified.
- The assigned package contains code_TRI.do, code_trucost.do, code_reprisk.do, and code_osha.do; their exact generated I/O statements and corresponding analysis handoffs are linked in the scope evidence. The README's TRI matching interleave remains a separate absent script.
- The bundled ESG dictionary is locally readable as one CSV column, but both Python consumers add row[0] for every row without explicitly skipping a header. Whether the dict_esg2 header is intended to be a term and whether this is the required full term list remain unresolved.
