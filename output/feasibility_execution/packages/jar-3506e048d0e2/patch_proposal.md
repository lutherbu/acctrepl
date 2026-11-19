# Patch proposal: jar-3506e048d0e2

Human Capital Disclosure and Labor Market Outcomes: Evidence from Regulation S-K

DOI: 10.1111/1475-679X.70036

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented source-data preparation followed by Preset.do dataset construction and Analysis.do table/figure generation.

Entry points: `CLM_code/CLM_code - Preset.do`, `CLM_code/CLM_code - Analysis.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 4/70036 - Human-Capital-Disclosure-and-Labor-Market-Outcomes-Evidence-from-Regulation-S-K/clmdatasheetcodeidentiferandlogfiles.zip",
      "sha256": "c342fa7a41f2fbda116dbb550007b41a99e48ba40c8484b0defed3fa916c5872"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "2d2ac9027ad55da812c6c65a62b44c211d6a9c2d130f3422cb528a60d4687602"
}
```

## Proposed actions

### A_RECONCILE_PATHS: Align the documented generated outputs with their consumer paths, select one JPV1 producer route, and retain unresolved Preset and Revelio source-coverage limits without inferring hidden contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DEI_STAGE, I_JPV1_STAGE, I_JPV1_FIELDS, I_ESG_PATH, I_ESG_SOURCE_LABEL, I_REVELIO_PUBLIC_TEXT, I_PRESET_COVERAGE
Evidence: E_PRESET_VISIBLE, E_LINKUP_FINAL_OUTPUT, E_GLASSDOOR_OUTPUT_DEFAULT, E_GLASSDOOR_OUTPUT_OPTION, E_GLASSDOOR_PRECOMP_FIELDS, E_ANALYSIS_JPV1_MONTH_FIELD, E_ESG_SOURCE, E_ESG_OUTPUT, E_DATASHEET_PRODUCTS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Keep the LinkUp-produced Processed_Data/20230227_DEI_data.csv as D0015’s generated product; align the documented output with Preset.do’s Raw_Data/20230227_DEI_data.csv consumer path, then confirm the native fields, rows, and period before relying on basename similarity.
2. For the single JPV1 aggregate, choose either the precomputed-input route or the raw rebuild route. Configure --output to Analysis.do’s jpv1_6_011825_agg.csv path; require all four raw inputs together only for the rebuild branch.
3. For D0006, stage the ESG guide’s 20250605sp_esgscore.dta output at Analysis.do’s Raw_Data consumer path after clarifying whether the guide’s S&P source product is the data-sheet Capital IQ ESG product and confirming field/row compatibility.
4. Request a reviewed readable Preset source representation or author producer/consumer mapping for D0016–D0049; preserve these IDs under I_PRESET_COVERAGE without adding a raw-data requirement from masked coverage alone.
5. Request a readable representation or author clarification for the zero-text Revelio public-firm guide; retain that specific representation limit without inferring absent code, inputs, or data.

Validation to perform later:

- For DEI and ESG, compare the producer output and consumer path plus native keys, fields, rows, and period using an approved bounded metadata view before marking compatibility verified.
- For JPV1, verify the selected precomputed or rebuild output at the Analysis.do path and confirm the imported field names/firm-month meaning using the prescribed reader semantics; do not rename from raw-header spelling alone.
- Keep Preset and Revelio contracts unresolved until readable evidence or author clarification supports each producer, field, period, and consumer link.

### A_ACQUIRE_VENDOR_DATA: Confirm and stage the distinct author-reported provider products and author-created fund crosswalk required by the full workflow. Use frozen catalog hits only as candidate leads; Glassdoor raw inputs are conditional on selecting the R_JPV1 rebuild route.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: I_PROVIDER_ACCESS, I_PACKAGE_DATA, I_FUND_MATCH, R_PROVIDER_CRSP_MFH, R_PROVIDER_MORNINGSTAR, R_PROVIDER_FACTSET, R_PROVIDER_REVELIO, R_PROVIDER_CIQ_ESG, R_PROVIDER_CIQ_TRANSCRIPTS, R_PROVIDER_COMPUSTAT, R_PROVIDER_RAVENPACK, R_PROVIDER_LINKUP
Evidence: E_DATASHEET_PRODUCTS, E_DATASHEET_ACCESS, E_PACKAGE_INVENTORY, E_FUND_MATCH, E_IDENTIFIER_PROBE, E_GLASSDOOR_BUILD_BRANCH, E_GLASSDOOR_PRECOMP_OPTION, E_CAT_CRSP_MF_PRODUCT, E_CAT_CRSP_PORTFOLIO_FILENAME, E_CAT_CRSP_STOCK_PRODUCT, E_CAT_CRSP_STOCK_FILENAME, E_CAT_MORNINGSTAR_PRODUCT, E_CAT_FUND_CROSSWALK_FILENAME, E_CAT_FACTSET, E_CAT_REVELIO, E_CAT_CIQ_ESG_PRODUCT, E_CAT_ESG_OUTPUT_FILENAME, E_CAT_CIQ_TRANSCRIPTS_PRODUCT, E_CAT_CONFERENCE_CALL, E_CAT_COMPUSTAT_PRODUCT, E_CAT_COMPUSTAT_FILENAME, E_CAT_RAVENPACK, E_CAT_RAVENPACK_OUTPUT_FILENAME, E_CAT_LINKUP_PRODUCT, E_CAT_LINKUP_OUTPUT_FILENAME, E_CAT_GLASSDOOR_CONDITIONAL, E_CAT_JPV1_OUTPUT_FILENAME, E_CAT_CRSP_SHORT, E_CAT_PORTFOLIO_SHORT, E_CAT_STOCK_SHORT, E_CAT_MORNINGSTAR_SHORT, E_CAT_CIQ_SHORT, E_CAT_TRANSCRIPT_SHORT, E_CAT_FUNDA_SHORT, E_CAT_SUSTAINABLE_FUNDS_SHORT

Preparation / proposed procedure:

1. Review the frozen catalog candidates against the specific author contracts before staging: Revelio candidate tables, COMP.FUNDA, and CIQ transcript tables may be relevant; the FactSet-ID mapping, Morningstar-ID table, and RavenPack category taxonomy are not proof of those source products.
2. Confirm subscriber access and acquire/stage each author-reported provider product required by the full workflow: CRSP Mutual Fund Holdings, Morningstar, FactSet, Revelio Labs, Capital IQ ESG Score and Transcripts, Compustat, RavenPack, and LinkUp. Match exact native fields, periods, histories, sample filters, and author transformations before marking any candidate route compatible.
3. Treat Glassdoor raw sentiment, job-posting, rcid-mapping, and cik-mapping files as one conditional AND set only if selecting the R_JPV1 rebuild route. If selecting the precomputed route, do not add those raw files as mandatory inputs.
4. Provide ms_manually_matched_portno_fundno.xlsx separately; CLM_identifiers.xlsx does not establish the six-column crosswalk read by the fund-ownership script. A miss in the SAS dataset catalog does not establish workbook absence.

Validation to perform later:

- For every candidate, compare its actual native schema, period/history, population, and author-specific filtering/construction requirements using permitted bounded metadata before treating it as a route; the catalog alone is not compatibility proof.
- A catalog miss only records that no matching leaf was returned from this SAS catalog query. Do not infer missing subscription, license, data elsewhere, or a blocked route from a miss.
- Record only the Glassdoor input files required by the selected JPV1 branch; the precomputed route and raw rebuild route remain alternatives.

### A_RESTORE_ACCESS: Provide the author scoring inputs and required external-service access for the ChatGPT and conference-call stages.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I_CHATGPT_INPUTS, I_CHATGPT_ACCESS, I_WRDS_ACCESS
Evidence: E_CHATGPT_FIELDS, E_CHATGPT_OPENAI, E_WRDS_CONNECTION, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Stage both frozen ChatGPT scoring input artifacts with the author-provided native schemas; keep credentials outside the source tree.
2. Confirm an authorized OpenAI API account/key for the scoring stage before deciding whether to use it; no API request is part of this assessment.
3. Confirm authorized WRDS access and required CIQ transcript data entitlement before running conference-call extraction.

Validation to perform later:

- Check the API client package and WRDS library using approved environment metadata, and verify account access through approved sign-in without exposing secrets.

### A_PREPARE_SOFTWARE: Prepare the exact Stata/Python dependencies used by the author code before any run attempt.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_OUTREG2, I_SOFTWARE_UNVERIFIED, SW_PYTHON, SW_PANDAS, SW_NUMPY, SW_TQDM, SW_SWIFTER, SW_PANDAS_READ_XML, SW_FAKE_USERAGENT, SW_OPENAI, SW_WRDS, SW_STATA, SW_REGHDFE, SW_FTOOLS, SW_OUTREG2, SW_ASDOC, SW_COEFPLOT
Evidence: E_ENVIRONMENT, E_ANALYSIS_SW_OUTREG2, E_ANALYSIS_SW_REGHDFE, E_ANALYSIS_SW_ASDOC, E_ANALYSIS_SW_COEFPLOT, E_LINKUP_PYTHON_IMPORTS, E_LINKUP_XML_IMPORTS, E_CHATGPT_OPENAI, E_WRDS_CONNECTION

Preparation / proposed procedure:

1. Preserve the existing typed proof for Python 3.12.14, Stata 18, reghdfe 6.12.3, and ftools 2.49.1 as exact available-name findings; do not treat them as proof for other modules.
2. Provide outreg2 through the approved Stata 18 package setup, then verify that exact command. The current typed proof reports it unavailable.
3. Check asdoc, coefplot, pandas, numpy, tqdm, swifter, pandas_read_xml, fake_useragent, openai, and wrds through approved package/environment metadata before deciding whether setup is needed; their current status is unverified, not known-missing.
4. Keep OpenAI and WRDS account/session access as separate unresolved service-access requirements; this action covers software records only.

Validation to perform later:

- Record the exact command/module name and version/status for every software record before a run is considered ready.
- Keep runtime status, add-on/module status, and external account access separate; no import trial or author-code execution is part of this proposal.

### A_RUN_AFTER_CLOSURE: Attempt the author pipeline only after source contracts, files, access, and software have been resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_PRESET_COVERAGE, I_PACKAGE_DATA, I_OUTREG2, I_PROVIDER_ACCESS, I_DEI_STAGE, I_JPV1_STAGE, I_ESG_PATH, I_CHATGPT_INPUTS, I_CHATGPT_ACCESS, I_WRDS_ACCESS, I_FUND_MATCH
Evidence: E_README_ENTRYPOINTS, E_SOURCE_PIPELINE, E_LINKUP_FINAL_OUTPUT, E_GLASSDOOR_BUILD_BRANCH, E_FUND_PORTFOLIO_OUTPUT, E_ANALYSIS_VISIBLE

Preparation / proposed procedure:

1. Follow the order documented in Readme.txt for RavenPack, LinkUp, Revelio, ChatGPT, Glassdoor, ESG score, fund ownership, and conference-call preparation; within each source preserve its numbered/process-guide sequence.
2. Run Preset.do only after its unresolved dependency set and all exact producer paths are reconciled.
3. Run Analysis.do as a separate downstream step when every required prepared input and Stata add-on is available.

Validation to perform later:

- Check that each required author output appears at the exact consumer path and carries native key/period fields expected by the consumer.
- Compare generated tables/figures with the paper outputs only after a complete authorized run; record a new run log without using historic logs as evidence.

### A_STAGE_AUTHOR_DATA: Stage author-produced or author-prepared products at documented consumer paths, preserve the native producer order, and keep unsupported field/source contracts unresolved.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_ANALYSIS_READY_DATA, R_JPV1, R_CHATGPT_INPUTS, R_CRSP_PORTFOLIO, R_CRSP_STOCK, R_FUND_CROSSWALK, I_DEI_STAGE, I_JPV1_STAGE, I_JPV1_FIELDS, I_ESG_PATH, I_ESG_SOURCE_LABEL, I_PRESET_COVERAGE, I_CHATGPT_INPUTS, I_FUND_MATCH
Evidence: E_README_ENTRYPOINTS, E_ANALYSIS_VISIBLE, E_ANALYSIS_D0003, E_ANALYSIS_D0004, E_ANALYSIS_D0005, E_ANALYSIS_D0006, E_ANALYSIS_D0007_PROD, E_ANALYSIS_D0007_READ, E_ANALYSIS_D0008, E_ANALYSIS_D0009_PROD, E_ANALYSIS_D0009_READ, E_ANALYSIS_D0010_PROD, E_ANALYSIS_D0010_READ, E_ANALYSIS_D0011, E_ANALYSIS_D0012, E_ANALYSIS_D0013, E_ANALYSIS_D0014, E_ANALYSIS_JPV1, E_ANALYSIS_JPV1_MONTH_FIELD, E_GLASSDOOR_OUTPUT_DEFAULT, E_GLASSDOOR_OUTPUT_OPTION, E_GLASSDOOR_PRECOMP_OPTION, E_GLASSDOOR_PRECOMP_FIELDS, E_GLASSDOOR_BUILD_BRANCH, E_PRESET_VISIBLE, E_LINKUP_FINAL_OUTPUT, E_ESG_SOURCE, E_ESG_OUTPUT, E_CHATGPT_FIELDS, E_PACKAGE_INVENTORY, E_FUND_MATCH, E_FUND_MATCH_FIELDS, E_FUND_PORTFOLIO_READ, E_FUND_PORTFOLIO_FIELDS, E_FUND_STOCK_READ, E_FUND_STOCK_FIELDS, E_IDENTIFIER_PROBE

Preparation / proposed procedure:

1. For R_ANALYSIS_READY_DATA, stage the Analysis.do inputs at their cited relative paths only when their producer and field/period contracts are established; request clarification for unresolved upstream links and retain those unknown contracts as unresolved.
2. For R_JPV1, select the author precomputed route or the raw rebuild route. The rebuild requires the sentiment CSV, job-posting pickle, rcid mapping Stata file, and cik mapping Stata file together; the precomputed branch does not require them. Set --output to Analysis.do’s import path and confirm imported headers/firm-month meaning before any proposed rename.
3. For D0015, retain the LinkUp-generated 20230227_DEI_data.csv and align its documented Processed_Data output with Preset.do’s Raw_Data input path; check full native fields, rows, and period before treating it as compatible.
4. For D0006, retain the ESG guide-generated 20250605sp_esgscore.dta and align its output with Analysis.do’s Raw_Data input path; clarify S&P versus Capital IQ identity and verify the consumer’s gvkey and assessmentyear contract before relying on it.
5. For R_CHATGPT_INPUTS, stage both author scoring inputs using their author-provided schemas once those paths/contracts are clarified; keep API credentials/access as a separate issue.
6. For R_CRSP_PORTFOLIO and R_CRSP_STOCK, stage both source files with their respective code-level field contracts. Keep R_FUND_CROSSWALK as a third required input with its six listed columns; do not substitute CLM_identifiers.xlsx.

Validation to perform later:

- Before a later run, compare each staged file’s exact path, native fields/keys, and applicable period with the cited producer and consumer contracts; record only checks supported by available metadata.
- Keep provider files, portfolio and stock files, the fund crosswalk, and both ChatGPT inputs as separate required inputs. Treat only the JPV1 precomputed/rebuild choices as alternatives, with raw inputs required together only in the rebuild branch.
- Do not mark a path, field map, or producer verified from a shared basename or registered-package inventory when the corresponding author contract remains unread or unresolved.


## Remaining issues and prerequisites

- I_PRESET_COVERAGE [unresolved; full_pipeline]: The admitted Preset.do source view covers its opening and early producer chain only. Frozen dependency IDs D0016–D0049 remain under this unresolved source-coverage issue because their complete producer, native field, period, and consumer contracts are not established by the readable excerpts. This unread coverage does not itself establish additional mandatory raw datasets or prove data absence.
- I_DEI_STAGE [preparation; full_pipeline]: The LinkUp guide writes Processed_Data/20230227_DEI_data.csv, and Preset.do reads the same basename from Raw_Data/ before renaming the_key_x. D0015 is credited as an author-generated product; aligning the documented output with the consumer directory is a preparation step. The basename alone does not establish complete field, row, or period compatibility.
- I_JPV1_STAGE [preparation; full_pipeline]: Analysis.do imports jpv1_6_011825_agg.csv from its working directory. The Glassdoor guide supports a precomputed-input route and a raw rebuild route and exposes --output from a nested default path. Select one route and configure/stage its single aggregate at the consumer path; the four raw inputs are needed together only for the rebuild route. Local output availability is unverified.
- I_JPV1_FIELDS [unresolved; full_pipeline]: The precomputed-input check lists month-year, rcid, and rating_diversity_and_inclusion, while Analysis.do refers to monthyear after import delimited. The source excerpt does not specify enough import-normalization semantics or actual CSV metadata to establish a field defect; Stata may normalize a hyphenated header. Confirm the selected route’s imported field names and firm-month meaning before proposing any rename.
- I_ESG_PATH [preparation; full_pipeline]: The ESG guide writes 20250605sp_esgscore.dta and Analysis.do reads the matching basename under Raw_Data, then renames assessmentyear to year. D0006 is credited as an author-generated product; moving/configuring that output at the consumer path is preparation. Full source identity and field/row compatibility remain unresolved.
- I_ESG_SOURCE_LABEL [unresolved; full_pipeline]: The data sheet lists Capital IQ ESG Score, while the ESG guide labels its CSV as downloaded from S&P ESG ratings. The evidence does not establish whether these refer to the same native source export.
- I_PROVIDER_ACCESS [preparation; full_pipeline]: The author data sheet says provider inputs are subscriber-accessible. The assigned catalog returned some local candidates and product/file-name misses, but neither candidate compatibility nor account, subscription, or delivery access was verified. A catalog miss is not evidence of a missing license or data absence outside this SAS catalog.
- I_PACKAGE_DATA [preparation; full_pipeline]: The registered package inventory contains no raw or processed vendor data files. The assigned SAS catalog lookup nevertheless returned candidate Revelio tables, Compustat annual-fundamentals tables, Capital IQ transcript tables, and several identifier/taxonomy tables; these candidates do not establish author-file compatibility, complete source data, or availability of other formats/workspaces.
- I_CHATGPT_INPUTS [preparation; full_pipeline]: The ChatGPT scoring stage has author-prepared input artifacts D0050 and D0051, but their full input paths/contracts are not available in the admitted source evidence and no matching data files are in the registered inventory.
- I_CHATGPT_ACCESS [unresolved; full_pipeline]: The scoring script imports the OpenAI client; the typed environment proof does not establish the module, account, credential, or API-access status. This is an access uncertainty, not proof of an unavailable account. No external API call was made.
- I_WRDS_ACCESS [unresolved; full_pipeline]: The conference-call guide establishes a WRDS connection, but the account/session route is not verified in the environment evidence. This is an access uncertainty, not proof of unavailable access.
- I_FUND_MATCH [preparation; full_pipeline]: The fund-ownership script requires the Morningstar-manually-matched fund/portfolio workbook. The registered CLM identifiers workbook is distinct; the assigned SAS dataset-catalog lookup found no SAS dataset matching the XLSX filename, which does not establish whether that workbook exists in a separate author workspace.
- I_REVELIO_PUBLIC_TEXT [unresolved; full_pipeline]: The registered Revelio public-firm processing guide has zero readable extracted text in the frozen work item. This is a representation limit for this review; it does not show that the guide or code is absent.
- I_OUTREG2 [preparation; full_pipeline]: Analysis.do uses outreg2, while the typed environment proof reports the exact command unavailable.
- I_SOFTWARE_UNVERIFIED [unresolved; full_pipeline]: Several direct Python and Stata imports/commands are visible in the author sources but are not included as verified keys in the typed environment projection. Their availability is unresolved; import statements do not establish that a module is missing.
- R_PROVIDER_CRSP_MFH [undetermined]: Author reports CRSP Mutual Fund Holdings Database as a source dataset used in the paper; it is an independent source requirement within the complete documented workflow.
- R_PROVIDER_MORNINGSTAR [undetermined]: Author reports Morningstar annual Sustainable Funds U.S. Landscape Report as a source dataset used in the paper; it is an independent source requirement within the complete documented workflow.
- R_PROVIDER_FACTSET [undetermined]: Author reports FactSet as a source dataset used in the paper; it is an independent source requirement within the complete documented workflow.
- R_PROVIDER_REVELIO [undetermined]: Author reports Revelio Labs as a source dataset used in the paper; it is an independent source requirement within the complete documented workflow.
- R_PROVIDER_CIQ_ESG [undetermined]: Author reports Capital IQ ESG Score as a source dataset used in the paper; it is an independent source requirement within the complete documented workflow.
- R_PROVIDER_CIQ_TRANSCRIPTS [undetermined]: Author reports Capital IQ Transcripts as a source dataset used in the paper; it is an independent source requirement within the complete documented workflow.
- R_PROVIDER_COMPUSTAT [undetermined]: Author reports Compustat as a source dataset used in the paper; it is an independent source requirement within the complete documented workflow.
- R_PROVIDER_RAVENPACK [undetermined]: Author reports RavenPack as a source dataset used in the paper; it is an independent source requirement within the complete documented workflow.
- R_PROVIDER_LINKUP [undetermined]: Author reports LinkUp as a source dataset used in the paper; it is an independent source requirement within the complete documented workflow.
- R_ANALYSIS_READY_DATA [undetermined]: Analysis.do reads author-prepared datasets at the relative Raw_Data/ and Processed_Data/ paths represented by D0003, D0004, D0008, and D0011–D0014. These are inputs to the complete documented workflow; where the admitted source excerpts do not show their upstream producers, full native field and period contracts, or local availability, those details remain unverified.
- R_JPV1 [undetermined]: Analysis.do imports jpv1_6_011825_agg.csv. The author Glassdoor script documents two alternative producer routes for this aggregate: a precomputed JPV1 input, or a rebuild from raw inputs that are all required together. Raw Glassdoor inputs are conditional on choosing the rebuild route and are not a global requirement when the precomputed route is selected; output staging, actual field/period compatibility, and local availability remain unverified.
- R_CHATGPT_INPUTS [undetermined]: The ChatGPT scoring stage uses author-prepared posting input artifacts retained as D0050 and D0051. Both inputs are needed for the documented scoring workflow; their full native contracts and workspace routes remain unverified.
- R_CRSP_PORTFOLIO [undetermined]: The fund-ownership stage requires crsp_portfolio_20.dta. The source code selects June 2020 rows and keeps crsp_portno, year, month, permco, permno, cusip, and nbr_shares.
- R_CRSP_STOCK [undetermined]: The fund-ownership stage also requires crsp_stock.dta to create the monthly shares-outstanding input.
- R_FUND_CROSSWALK [undetermined]: The fund-ownership stage requires an author-created Morningstar matching workbook with crsp_fundno, crsp_portno, begdt, enddt, InceptionDate, and ESGStartDate.
- SW_PANDAS [unverified]: Used in the Python preprocessing guides; module availability/version was not probed.
- SW_NUMPY [unverified]: Used in the Python preprocessing guides; module availability/version was not probed.
- SW_TQDM [unverified]: Imported by the Python preprocessing guides; module availability/version was not probed.
- SW_SWIFTER [unverified]: Imported by the LinkUp processing guide; module availability/version was not probed.
- SW_PANDAS_READ_XML [unverified]: Imported by the LinkUp/XML processing guide; module availability/version was not probed.
- SW_FAKE_USERAGENT [unverified]: Imported by the LinkUp processing guide; module availability/version was not probed.
- SW_OPENAI [unverified]: The ChatGPT scoring script imports the OpenAI client; module/auth availability was not probed.
- SW_WRDS [unverified]: The conference-call guide imports wrds and establishes a connection; module/account availability was not probed.
- SW_OUTREG2 [preparation_required]: Analysis.do uses outreg2, and typed environment proof reports the exact command unavailable.
- SW_ASDOC [unverified]: Analysis.do uses asdoc; its availability was not verified.
- SW_COEFPLOT [unverified]: Analysis.do uses coefplot; its availability was not verified.

## Review notes

- The assessed scope is the complete documented workflow through Preset.do dataset construction and Analysis.do table/figure generation. The JPV1 aggregate has two alternative author-script routes: a precomputed input or a raw rebuild requiring all four raw inputs together. Glassdoor raw inputs are conditional on the rebuild route, not globally required for the precomputed route.
- Frozen dependency IDs D0001–D0055 remain present exactly once. D0006 (ESG score) and D0015 (DEI data) are credited as author-generated products from cited producer/consumer basename matches; path staging and unresolved source/field/row/period contracts remain explicit.
- The registered Revelio public-firm guide has zero readable extracted text in the frozen work item, recorded as a specific unread representation limit rather than absent code or data.
- The original environment artifact body remains opaque. Software facts are cited only through the approved typed environment projection. No author/statistical/model/API code was executed; no SAS startup, package installation, data import, or historic log reading occurred.
- The required bounded frozen-catalog lookups are preserved as 28 original helper arrays plus 28 object wrappers. Each wrapper records the exact query, lookup success, catalog/helper hashes, original-array path/hash, and exact returned matches; `status: ok` means lookup success only and is not native data readability or compatibility. The assigned catalog hash is 4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27 and the generation-pinned helper hash is ba500b6fe708850c8c47edf35a4773998ecb676a6190ed1b7a741d28ae75eb4d. Returned local candidates include Revelio tables, COMP.FUNDA annual fundamentals, and CIQ transcript tables; identifier-mapping and taxonomy tables are noted as non-equivalent candidates. Product/file-name misses remain limited to the assigned SAS catalog and do not show unavailable data, licensing, or access. Native fields, periods, historical coverage, population, and author construction compatibility remain unresolved.
