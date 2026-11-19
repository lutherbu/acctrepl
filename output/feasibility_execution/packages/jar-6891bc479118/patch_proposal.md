# Patch proposal: jar-6891bc479118

How Stock Market Participants Use Generative Artificial Intelligence: Evidence from User- Platform Interaction Data

DOI: 10.1111/1475-679X.70051

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full documented workflow: Python platform preparation/classification, daily and annual Stata construction, supplementary construction, cleaning, main tables, and documented R figure/robustness branches.

Entry points: `stata code and log/01_process_csmar_daily.do`, `stata code and log/02_process_csmar_yearly.do`, `stata code and log/03_other_dataset_construction.do`, `stata code and log/04_dataset_cleaning.do`, `stata code and log/05_main_tables.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 3/70051 - How-Stock-Market-Participants-Use-Generative-Artificial-Intelligence-Evidence-from-User-Platform-Interaction-D/ellw-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "b1b79d9c390c911eb403cae573991edb4a3552d0ee1c243ff1765f030045b087"
    },
    {
      "path": "JAR-Volume 64/Issue 3/70051 - How-Stock-Market-Participants-Use-Generative-Artificial-Intelligence-Evidence-from-User-Platform-Interaction-D/ellw-online-appendix.pdf",
      "sha256": "60f0a3ded19c43a39360ced79b8a6b9980ac2f8f82c59c8ccb0a720c7a779f70"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a8cbf5e695a6e10d7a77e89a38a3e3f5dced12707905b6c96bbf159d449a0039",
  "work_item_sha256": "be2862cccc2c02955adce3423abdf20472f36d6e4af815ab57d460e7edac101b"
}
```

## Proposed actions

### A_CSMAR_ACCESS: Confirm an authorized CSMAR route and obtain the exact exports and split parts used by stages 01 and 02.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_CSMAR_TRD_DALYR, R_CSMAR_ER_REL, R_CSMAR_ER_ANNOUNCEMENT, R_CSMAR_FIN_QT, R_CSMAR_FIN_FORECAST, R_CSMAR_AF_FORECAST, R_CSMAR_TRD_MKSTRUCTD, R_CSMAR_TRD_BWARD, R_CSMAR_TRD_CNDALYM, R_CSMAR_FS_COMINS, R_CSMAR_AMIHUD, R_CSMAR_HF_STOCKJUMP, R_CSMAR_HF_SPREAD, R_CSMAR_HF_VPIN, R_CSMAR_CMS_INTERACTION, R_CSMAR_FS_COMBAS, R_CSMAR_STK_LISTEDCOINFOANL, R_CSMAR_STK_INDUSTRYCLASSANL, R_CSMAR_EN_EQUITYNATUREALL, R_CSMAR_INI_HOLDERSYSTEMATICS, R_CSMAR_TRD_MNTH, R_CSMAR_FN_FN061, R_CSMAR_AF_CFEATUREPROFILE, R_CSMAR_PT_LCDETAIL
Evidence: E_PDF_CSMAR, E_CATALOG, E_RET_1, E_COMBAS_INPUT

Preparation / proposed procedure:

1. Confirm existing user/institution authorization and permitted export method for each named product.
2. Export all listed products/splits with required fields and daily/annual history.
3. Boundedly compare fields, identifiers, date coverage, and split completeness before author execution.

Validation to perform later:

- Verify names, fields, identifiers, dates, and split parts against the requirements.

### A_MEDIA_SOURCE: Resolve the source contract behind the screened media import rows.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MEDIA_INPUT, I_MEDIA_SOURCE
Evidence: E_MEDIA_SAVE1, E_MEDIA_SAVE2, E_MEDIA_FIELDS

Preparation / proposed procedure:

1. Request source/provider, export dates, and complete field dictionary for both media inputs.
2. Confirm symbol, declaredate, and newsid map to the downstream firm-date count.
3. Keep the input unresolved until an approved view or author data dictionary establishes it.

Validation to perform later:

- Compare both extracts' fields, keys, and date coverage to the visible media construction.

### A_PLATFORM_INPUTS: Request compatible author-prepared regression inputs or permitted preprocessing implementation and full data contract.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_FIRM_DATE, R_USER_INTERACTION, R_USER_DATASET, I_PYTHON_PREPROCESSING
Evidence: E_PDF_FINAL_DATA, E_PDF_PYTHON, E_PDF_NDA, E_README_PREP_INPUT, E_README_PREP_OUTPUT, E_FIELD_ROUTE

Preparation / proposed procedure:

1. Request firm_date.dta, user_interaction.dta, and user_dataset.dta with data dictionary, keys, date coverage, and completeness statement.
2. If reproducing proprietary preparation, request permitted code/specification, inputs, training labels, BERT checkpoint settings, LLM prompts/model/version, manual-review decisions, and Stanza resources.
3. Preserve the main classification and separate LLM robustness branch; do not substitute a reconstructed workflow.

Validation to perform later:

- Boundedly compare keys, fields, labels, period, and population coverage to documented first consumers.

### A_CROSSWALK: Obtain the company name/ticker mapping used for symbol refinement.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_COMPANY_CROSSWALK
Evidence: E_README_KEY, E_README_CROSSWALK, E_STKCD

Preparation / proposed procedure:

1. Request stock code to official name/common alias/ticker abbreviation mapping and market-prefix normalization rules.
2. Keep stkcd.dta as an identifier list; its bounded probe does not establish the crosswalk.

Validation to perform later:

- Boundedly verify mapping fields and stock-code formats before query processing.

### A_ACC_QUALITY: Resolve the producer and contents of acc_quality.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ACC_QUALITY, I_ACC_QUALITY
Evidence: E_ACC_INPUT, E_ACC_FIELDS

Preparation / proposed procedure:

1. Request the compatible prepared file or permitted source/construction contract and definitions for aemjones, NewsCount, and ifRestate.
2. Confirm unique stkcd/year keys and yearly master coverage.

Validation to perform later:

- Check fields, key uniqueness, and year coverage with bounded metadata.

### A_GUIDANCE: Resolve source and headers for mgt_guidance.csv.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MGT_GUIDANCE
Evidence: E_GUIDANCE_INPUT, E_GUIDANCE_CODE, E_GUIDANCE_DATE, E_GUIDANCE_CONTENT, E_GUIDANCE_REASON, E_GUIDANCE_NAMED

Preparation / proposed procedure:

1. Obtain permitted source or prepared CSV and complete data dictionary.
2. Confirm scode, publidate, all content/reason wildcard fields, and named Chinese reason-word fields.
3. Preserve firm identifiers and publication dates through stage 03 and stage 04.

Validation to perform later:

- Use bounded CSV metadata to verify headers, dates, and firm codes; then check guidance_formerge keys.

### A_SVI: Resolve SVI source, construction, period, and relationship to SVI_All.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SVI, I_SVI_SOURCE_NAMESPACE
Evidence: E_SVI_INPUT, E_DAILY_FIELDS, E_SVI_ALL, E_MAIN_FIRM

Preparation / proposed procedure:

1. Request intended SVI.dta or authorized source, measure definition, keys, history, and coverage.
2. Ask authors to specify whether SVI_All is separate or another field; keep names distinct until documented.
3. Do not infer aliases or treat catalog misses as proof of no data.

Validation to perform later:

- Check definitions and firm-date coverage against daily and table consumers.

### A_DAILY_PATH: Propose daily consumer path alignment in a future working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_DAILY_PATH
Evidence: E_DAILY_ROOT, E_DAILY_SAVE, E_DAILY_FIELDS, E_DAILY_FIRST, E_FIELD_ROUTE

**Proposed edit:** `stata code and log/04_dataset_cleaning.do:15–15`
Source SHA-256: `578b8071e0e1cc54f748b7df73ecabbab51267305e4eda196cc322a7ec8952f7`

Stage 01 writes datasets/daily/daily.dta; stage 04 asks for datasets/daily.dta. Producer fields and firm-date keys match.

Current text:
```
use "$dataset\daily", clear
```

Proposed replacement:
```
use "$dataset\daily\daily", clear
```

Preparation / proposed procedure:

1. Apply only in an authorized future working copy; no source file changes here.

Validation to perform later:

- Check resolved paths and stkcd/date fields before stage 04.

### A_YEARLY_PATH: Propose annual consumer path alignment in a future working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_YEARLY_PATH
Evidence: E_YEARLY_ROOT, E_YEARLY_SAVE, E_YEARLY_FIRST, E_YEARLY_FILTER, E_YEARLY_INDUSTRY, E_FIELD_ROUTE

**Proposed edit:** `stata code and log/03_other_dataset_construction.do:41–41`
Source SHA-256: `625812a2828ef00332e30865378946b9ee84360c7a9703b48cb5afba68987393`

Stage 02 writes datasets/yearly/merged_yearly_controls.dta; stage 03 requests the same object at datasets root. Keys and industrycodec match.

Current text:
```
use "$dataset\merged_yearly_controls.dta", clear
```

Proposed replacement:
```
use "$dataset\yearly\merged_yearly_controls.dta", clear
```

Preparation / proposed procedure:

1. Apply only in an authorized future working copy; no source file changes here.

Validation to perform later:

- Check path and stkcd/year/industrycodec before stage 03.

### A_R_FIGURE: Confirm the executable R figure entrypoint and its inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_R_FIGURE, S_GGPLOT2
Evidence: E_README_R, E_INV

Preparation / proposed procedure:

1. Confirm whether the inventoried hyphenated HTML is source, rendered output, or another artifact, and reconcile its name with README.
2. Obtain exact R entrypoint and figure input files; verify ggplot2/version after that.

Validation to perform later:

- Compare the identified entrypoint inputs/package needs with produced analysis data.

### A_LLM_VARIANT: Preserve and resolve the fully LLM-based topic robustness branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_LLM_VARIANT
Evidence: E_README_LDA, E_README_LLM_VARIANT

Preparation / proposed procedure:

1. Request appendix prompts, model/provider/version, category mapping, output contract, and branch-specific inputs.
2. Confirm how its results compare with the LDA main path without merging variant outputs.

Validation to perform later:

- Verify branch inputs and labels against the referenced robustness appendix.

### A_STATA_ADDONS: Resolve Stata add-ons not found in checked paths.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_LABONE, S_WINSOR2, S_TTABLE2, S_OUTREG2, S_PWCORR_A
Evidence: E_ENV, E_LABONE, E_TTABLE2, E_MAIN_WINSOR2, E_MAIN_OUTREG2, E_PWCORR_A

Preparation / proposed procedure:

1. Confirm author-compatible releases and authorized sources for labone, ttable2, winsor2, outreg2, and pwcorr_a.
2. Place approved releases on the intended ado path only in a future authorized setup; nothing is installed here.

Validation to perform later:

- Run non-author which checks in the intended environment and confirm syntax/version before future author execution.

### A_ASREG_PATH: Make the available local asreg ado visible in a future Stata working environment.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: S_ASREG
Evidence: E_ENV, E_RET_CAR60

Preparation / proposed procedure:

1. Add the checked local ado root to a future Stata adopath or configure an equivalent authorized project-local ado location.
2. Do not copy/download/install a replacement during this assessment.

Validation to perform later:

- Confirm which asreg resolves in the intended future session before author execution.

### A_PYTHON_DEPS: Resolve Python dependencies/resources for preprocessing and Figure 1.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_PY_STACK, S_AKSHARE
Evidence: E_README_KEY, E_README_BERT_TRAIN, E_README_BERT_LOAD, E_README_LDA, E_README_STANZA, E_README_AKSHARE, E_ENV

Preparation / proposed procedure:

1. Request author package/version list, checkpoints/tokenizers, and Stanza Chinese-language resources.
2. Verify Python dependencies and akshare period after data contract is known.
3. Install/fetch only under a separately authorized setup.

Validation to perform later:

- Record versions and resource identifiers against the author workflow before execution.

### A_AKSHARE_CALENDAR: Verify the permitted trading-day calendar route used for Figure 1.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_AKSHARE_CALENDAR
Evidence: E_README_AKSHARE, E_README_PANEL

Preparation / proposed procedure:

1. Confirm the author's akshare endpoint/version and calendar semantics for January-June 2024.
2. Check coverage for all sample dates through an approved, bounded metadata method; do not make an API call in this assessment.

Validation to perform later:

- Compare the verified calendar dates with the author-defined trading-day filter before a future figure run.

### A_LLM_ACCESS: Clarify LLM provider, model version, prompts, and permitted inference route.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: S_LLM
Evidence: E_README_LLM_VARIANT, E_README_MANUAL, E_README_CROSSWALK, E_README_FORWARD_RETURN

Preparation / proposed procedure:

1. Request exact service/model and an authorized data-handling route.
2. If service use is unavailable, request compatible author-prepared classification outputs; no API calls or model substitution here.

Validation to perform later:

- Compare provider/model and output schema with author classifications before future authorized execution.


## Remaining issues and prerequisites

- I_PYTHON_PREPROCESSING [unresolved; full_pipeline]: README documents Python company filtering, BERT training/checkpoint inference, LDA and LLM classification, manual review, Stanza features, and preparation of three regression inputs. Raw-processing code is not publicly released and compatible full inputs/configuration are not inventoried, so the proprietary-server branch cannot be fully run or audited from this release.
- I_ACC_QUALITY [unresolved; full_pipeline]: Annual stage reads acc_quality.dta with four specified fields, but no producer/source contract appears in the supplied stages.
- I_SVI_SOURCE_NAMESPACE [unresolved; full_pipeline]: Daily producer merges an unproduced SVI.dta and keeps SVI; cleaning/main tables also reference SVI_All/logSVI_All. Source, definition, history, and relationship are unknown; the names remain distinct.
- I_MEDIA_SOURCE [unresolved; full_pipeline]: Dependency metadata names two ER_NewsInfo workbook parts, but their import rows are screened. Visible code saves two intermediates and counts newsid by stkcd/date; source association, full fields, and history cannot be verified.
- I_DAILY_PATH [preparation; full_pipeline]: Daily producer saves datasets/daily/daily.dta while stage 04 consumes datasets/daily.dta. Writer fields and stock-date keys align; path adjustment is preparation in a future working copy.
- I_YEARLY_PATH [preparation; full_pipeline]: Annual producer saves datasets/yearly/merged_yearly_controls.dta while stage 03 consumes datasets/merged_yearly_controls.dta. Writer keys and industrycodec/year match; path adjustment is preparation in a future working copy.
- I_R_FIGURE [unresolved; full_pipeline]: README says R/ggplot2 and references ELLW2026_figure.html; inventory lists R code/ELLW2026-figure.html as other. Its executable role and inputs are unverified, not treated as absent code.
- I_LLM_VARIANT [unresolved; full_pipeline]: README documents fully LLM-based topic robustness alongside the LDA-guided main path; branch-specific prompts, config, output contract, and appendix relationship are not supplied.
- R_CSMAR_TRD_DALYR [undetermined]: Four daily return workbooks are appended and used for daily price, return, volume, market-value and liquidity construction.
- R_CSMAR_ER_REL [undetermined]: Quarterly report release-date product produces EA by firm, fiscal period, report type and release date.
- R_CSMAR_ER_ANNOUNCEMENT [undetermined]: Company announcement data form event types and announcement size by firm-date.
- R_CSMAR_FIN_QT [undetermined]: Quarterly briefings produce positive/negative briefing flags by firm-date.
- R_CSMAR_FIN_FORECAST [undetermined]: Management forecasts produce positive/negative/neutral firm-date forecast measures.
- R_CSMAR_AF_FORECAST [undetermined]: Analyst report data are counted by firm and report date.
- R_CSMAR_TRD_MKSTRUCTD [undetermined]: Daily market-structure input supplies turnover by market code/date.
- R_CSMAR_TRD_BWARD [undetermined]: Three backward-quotation parts supply daily share-count fields.
- R_CSMAR_TRD_CNDALYM [undetermined]: Daily market returns join by date/market type for abnormal returns and CAR.
- R_CSMAR_FS_COMINS [undetermined]: Income statements are used in quarterly earnings surprises and annual controls; both source paths and distinct histories are required.
- R_CSMAR_AMIHUD [undetermined]: Amihud D and D1 daily exports are appended to form illiquidity inputs.
- R_CSMAR_HF_STOCKJUMP [undetermined]: Base and numbered stock-jump exports are collapsed by firm-date.
- R_CSMAR_HF_SPREAD [undetermined]: Base and second bid-ask spread exports feed the rolling abnormal spread.
- R_CSMAR_HF_VPIN [undetermined]: Base and numbered VPIN exports are appended/de-duplicated by firm-date.
- R_CSMAR_CMS_INTERACTION [undetermined]: Three investor-interaction exports are counted by date and symbol.
- R_CSMAR_FS_COMBAS [undetermined]: Annual balance sheets build asset, cash, PPE, intangible and leverage controls.
- R_CSMAR_STK_LISTEDCOINFOANL [undetermined]: Annual listed-company data form the BasicInfo master.
- R_CSMAR_STK_INDUSTRYCLASSANL [undetermined]: Annual industry classification supplies firm-year industry codes/names.
- R_CSMAR_EN_EQUITYNATUREALL [undetermined]: Annual equity-nature data supply ownership controls.
- R_CSMAR_INI_HOLDERSYSTEMATICS [undetermined]: Institutional-holdings data supply annual ownership fields.
- R_CSMAR_TRD_MNTH [undetermined]: Monthly returns form annual return, volatility, market-value and valuation controls.
- R_CSMAR_FN_FN061 [undetermined]: Subsidiary/segment data are counted by firm-year.
- R_CSMAR_AF_CFEATUREPROFILE [undetermined]: Company profile data supply auditor and analyst-attention controls.
- R_CSMAR_PT_LCDETAIL [undetermined]: Patent detail is grouped into valid/invalid/application/failure counts.
- R_MEDIA_INPUT [undetermined]: Two screened media branches save MediaCoverageRaw1/2 and count newsid by stkcd/date. Dependency metadata names ER_NewsInfo workbook parts, but the raw import/source contract and history remain unverified.
- R_ACC_QUALITY [undetermined]: Annual stage reads acc_quality.dta and keeps stkcd/year/aemjones/NewsCount/ifRestate; no producer is supplied.
- R_MGT_GUIDANCE [undetermined]: Stage 03 imports mgt_guidance.csv, uses scode/publidate, wildcard content/reason fields, and named Chinese reason fields.
- R_FIRM_DATE [undetermined]: Author-prepared firm_date.dta feeds stage 03 annual aggregation and stage 04 firm-date join; it is not inventoried.
- R_USER_INTERACTION [undetermined]: Author-prepared user_interaction.dta is transformed in stage 04 and used by main tables; full schema/population are not supplied.
- R_USER_DATASET [undetermined]: Author-prepared user_dataset.dta is transformed in stage 04 and used by main tables; full schema/population are not supplied.
- R_SVI [undetermined]: Stage 01 merges SVI.dta by stkcd/date and keeps SVI; no producer is supplied and meaning/history/SVI_All relation are unresolved.
- R_COMPANY_CROSSWALK [undetermined]: README requires stock codes, official names, and common abbreviations. Packaged stkcd.dta probe exposes only stkcd, not the name crosswalk.
- R_AKSHARE_CALENDAR [undetermined]: Figure 1 restricts platform queries to trading days using akshare; a compatible 2024 calendar route and coverage have not been verified.
- S_PY_STACK [unverified]: Package versions, checkpoints, tokenizers, and language resources unverified.
- S_AKSHARE [unverified]: Package version and trading-day coverage unverified.
- S_GGPLOT2 [unverified]: Only R runtime was checked.
- S_LLM [unverified]: Provider, model, prompts, output schema, and authorized access unspecified.
- S_LABONE [preparation_required]: Import stages use it; bounded lookup did not find it.
- S_ASREG [preparation_required]: Daily code uses it; found only with a configured ado root.
- S_WINSOR2 [preparation_required]: Main tables use it; checked paths did not contain it.
- S_TTABLE2 [preparation_required]: Main tables use it; bounded lookup did not find it.
- S_OUTREG2 [preparation_required]: Main tables use it; checked paths did not contain it.
- S_PWCORR_A [preparation_required]: Main tables use it; bounded lookup did not find it.

## Review notes

- Full documented workflow is the target. No analysis_only scope is added because no regression-ready dataset is supplied; the only inventoried DTA is an identifier list.
- The five Stata do-files are listed in README order. Python raw processing is documented but not publicly released, and compatible author-prepared regression inputs are not inventoried.
- Bounded CSMAR catalog misses are discovery results only; they do not prove the user lacks a license or that the data are unavailable. TFN stkcd hits are stock-class fields, not a company crosswalk.
- Screened rows are coverage limits. Media source and SVI producer/meaning/history remain unresolved; no inactive-code or absent-source conclusion is inferred.
- Daily/yearly generated object paths are preparation alignments because writer/consumer fields and keys match. Proposed edits are future-working-copy only and were not applied.
- SVI and SVI_All are retained as distinct names until their relationship is documented.
- Only approved captured source views, work-item metadata, and bounded JSON probes were used. No author code, study-data body, external service, or SAS runtime was invoked.
