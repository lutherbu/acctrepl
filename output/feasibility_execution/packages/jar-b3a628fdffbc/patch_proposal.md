# Patch proposal: jar-b3a628fdffbc

Financial Transparency of Private Firms: Evidence from a Randomized Field Experiment

DOI: 10.1111/1475-679X.12568

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented randomized field-experiment workflow: Stata data construction, LimeSurvey processing, crawled-registry merging, sample/variable preparation, main analyses, generated figures, the R CATE figure and the separate firm-activity analysis. Figure 2 and Figure 3 are manual PowerPoint outputs; input coverage and runtime setup remain under review.

Entry points: `2_Code/_Wrapper.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 1/12568 - Financial-Transparency-of-Private-Firms-Evidence-from-a-Randomized-Field-Experiment/gm-datasheet-code-and-log-files.zip",
      "sha256": "f7c78874fe5f3375a4dc9136f6c25f8397eb8e78fcdbf820510b6cf5ddfcd659"
    },
    {
      "path": "JAR-Volume 63/Issue 1/12568 - Financial-Transparency-of-Private-Firms-Evidence-from-a-Randomized-Field-Experiment/gm-online-appendix.pdf",
      "sha256": "5fa7163b50127e06de491c1ac859387b99d7f866188ca5d9bd9d7f1f33bc3293"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "b98f966554b82e85f531a7da18f577fc2b98c7d76a17b24ea623090671e9b797"
}
```

## Proposed actions

### A_AUTHOR_INPUTS: Request or otherwise verify the exact author-prepared staged inputs, identifier/classification lists, their disclosure permissions, fields and time/population coverage; preserve every author transformation and do not independently rebuild the missing lists or assignment.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PREEXP_DAFNE_FREE, R_PREEXP_DAFNE_COSTLY, R_PREEXP_MANUAL_FILTER, R_SURVEY_INVITATION_TOKENS, R_SURVEY_RESPONSES, R_SURVEY_DUPLICATE_REVIEW, I_AUTHOR_INPUT_COVERAGE, R_OTHER_REMOVED_LIST, R_RANDOMIZED_ASSIGNMENT, R_POSTEXP_NONLIMITED, R_POSTEXP_INSOLVENT, R_POSTEXP_ASSETS_TURNOVER_2011_2014, R_POSTEXP_EMPLOYEES_2011, R_POSTEXP_ASSETS_TURNOVER_2010_2012_2013, R_SURVEY_Q3_CLASSIFICATION, R_SURVEY_Q4_CLASSIFICATION, R_SURVEY_COMMENT_CLASSIFICATION, R_NEVERBOUNCE_EMAIL_STATUS, R_POSTAL_DISTRICT_CROSSWALK, R_REGISTER_CRAWLER_2015, R_REGISTER_HANDCOLLECTED_2015, R_REGISTER_CRAWLER_2016, R_FIGURE1_DAFNE_HIT_SUMMARY, R_ARCHIVEORG_WEBSITE_STATUS, R_DAFNE_VVC_ACTIVE_STATUS
Evidence: E_ACTIVITY_INPUTS, E_ACTIVITY_MAINSAMPLE, E_ASSET_2010_12_13_INPUT, E_ASSET_2011_14_INPUT, E_CATALOG_LOOKUP, E_COMMENT_CLASSIFICATION, E_DAFNE_DOC, E_DISTRICT, E_DRIVER, E_FIGURE1_INPUT, E_NEVERBOUNCE, E_OTHER_REMOVED, E_PACKAGE_INVENTORY, E_POSTEXP_EXCLUSIONS, E_Q3_CLASSIFICATION, E_Q4_CLASSIFICATION, E_RANDOMIZED, E_REGISTER_2015_INPUT, E_REGISTER_2016_FILTER, E_REGISTER_2016_INPUT, E_REGISTER_PROCESS, E_SURVEY_PRIVACY

Preparation / proposed procedure:

1. Identify and authorize access to each exact author-prepared raw export, identifier list, manual classification, email-status mapping and geographic crosswalk used in the supplied stages.
2. Provide the original per-file inventory, schema, firm/response identifiers, year/population coverage and the authors' approved handling conditions for confidential assignment and survey records.
3. Retain the documented author sequence and conversions; do not regenerate the randomization, manual review lists, crawler supplement or field data independently.

Validation to perform later:

- After authorized files are supplied, perform bounded format/readability and underlying-column checks for each exact input, then confirm the required batches and year/identifier coverage against the documented author workflow.

### A_MANUAL_FIGURES_2_3: Ask the authors for the Figure 2/3 editable PowerPoint source or exact manual construction instructions and the underlying values/inputs, then reproduce those two specified outputs in the documented author workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MANUAL_FIGURES_2_3, SW_POWERPOINT
Evidence: E_FIGURES23_MANUAL, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Obtain the source deck or author-approved figure values, labels and layout steps for Figures 2 and 3.
2. Confirm the required PowerPoint version and input file locations before preparing the outputs.
3. Confirm that Microsoft PowerPoint is available in the authorized environment; do not assume another presentation application preserves the intended manual output.

Validation to perform later:

- After the missing author instructions and approved software are available, compare recreated Figures 2 and 3 with the paper's specified outputs and retain the editable deck.

### A_PUBLIC_REGISTER_CANDIDATE: Evaluate the authors' cited public Company Register route only for the specific archival branches and years the authors confirm; the official search/cost pages establish a possible interface and cost schedule, not compatibility with the author exports.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_PREEXP_DAFNE_FREE, R_PREEXP_DAFNE_COSTLY, R_POSTEXP_NONLIMITED, R_POSTEXP_INSOLVENT, R_POSTEXP_ASSETS_TURNOVER_2011_2014, R_POSTEXP_ASSETS_TURNOVER_2010_2012_2013, R_REGISTER_CRAWLER_2015, R_REGISTER_CRAWLER_2016
Evidence: E_DAFNE_DOC, E_PUBLIC_COMPANY_SEARCH, E_PUBLIC_COMPANY_SEARCH_FREE, E_PUBLIC_COMPANY_FINANCIALS, E_PUBLIC_COMPANY_COST

Preparation / proposed procedure:

1. Confirm with the authors which required inputs may be sourced from the Company Register and obtain the needed firm-ID-to-register search mapping.
2. For authorized candidate records, account for the page's date/deletion limits, required security query and per-document retrieval fee; do not assume bulk coverage.
3. Map retrieved information into the documented author fields only after the exact schema and complete population/year coverage are confirmed.

Validation to perform later:

- Before treating this route as usable, verify that every required firm/year is retrievable and that the output supports the author merge keys and needed fields; retain gaps as unresolved.

### A_WAYBACK_CANDIDATE: Verify the official Wayback URL/date-range search as a candidate for the firm-activity status file without assuming it can reproduce the author CSV.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_ARCHIVEORG_WEBSITE_STATUS
Evidence: E_PUBLIC_ARCHIVE, E_ACTIVITY_INPUTS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Obtain the authors' URL-to-firm-ID mapping and exact URL/date coverage rules.
2. Check whether the author status CSV is available as an author-prepared file; if not, confirm approved retrieval and the authors' isalive/isalive_request construction before gathering pages.

Validation to perform later:

- After authorized inputs are available, compare URL/date coverage and resulting status variables with the author schema; the Wayback help page alone does not establish completeness.

### A_PRIVATE_SURVEY_ACCESS: Confirm the authors' approved private provision and handling route for the randomization/identifier file, LimeSurvey token and response records, and the associated response-ID classifications.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I_CONFIDENTIAL_SURVEY_ROUTE, R_RANDOMIZED_ASSIGNMENT, R_SURVEY_INVITATION_TOKENS, R_SURVEY_RESPONSES, R_SURVEY_DUPLICATE_REVIEW, R_SURVEY_Q3_CLASSIFICATION, R_SURVEY_Q4_CLASSIFICATION, R_SURVEY_COMMENT_CLASSIFICATION
Evidence: E_SURVEY_PRIVACY, E_RANDOMIZED, E_TOKENS, E_RESPONSE, E_DUPLICATES, E_Q3_CLASSIFICATION, E_Q4_CLASSIFICATION, E_COMMENT_CLASSIFICATION

Preparation / proposed procedure:

1. Request the exact input inventory and approved secure access/handling conditions from the authors or editors.
2. Confirm identifier mapping and required fields for the invitation, assignment, responses and manual classification files; do not regenerate assignment or survey records.

Validation to perform later:

- After the permitted files are supplied, verify bounded schema/readability and check response/firm-ID linkage coverage against the author workflow.

### A_STATA_COMMAND_SETUP: Four separate frozen Stata 18 version/which-only probes completed successfully and report `software:here`, `software:distinct`, `software:fsum` and `software:rscript` unavailable (each available=false with which return code 111). Configure these author-required commands in a future authorized native Stata setup.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_HERE, SW_DISTINCT, SW_FSUM, SW_STATA_RSCRIPT
Evidence: E_WRAPPER_PATH_SETUP, E_DRIVER, E_REGISTER_2015_INPUT, E_DUPLICATES, E_FSUM_CALL, E_PACKAGE_INVENTORY, E_STATA_WHICH_HERE, E_STATA_WHICH_DISTINCT, E_STATA_WHICH_FSUM, E_STATA_WHICH_RSCRIPT_COMMAND

Preparation / proposed procedure:

1. In a future authorized environment setup, enable the four missing exact Stata commands here, distinct, fsum and rscript; no software was installed for this assessment.
2. Confirm project-root resolution for here separately. The rscript result concerns the Stata command used by the wrapper; the separate Rscript executable path and all R packages remain unverified by these Stata-only probes.

Validation to perform later:

- Before any separately authorized study-data run, confirm the exact four Stata command names resolve in the selected native environment and that here resolves the assigned project root.
- Assess the Rscript executable and R package setup independently; these Stata command checks do not establish their availability.

### A_WINSOR2_SETUP: Install the missing Stata winsor2 command in the authorized future replication environment, following the wrapper's commented installation instruction.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR2
Evidence: E_WINSOR2_CALL, E_WRAPPER_PATH_SETUP, E_ENVIRONMENT

Preparation / proposed procedure:

1. After authorization, install winsor2 using its author-documented Stata package source; do not install during this assessment.
2. Verify the exact winsor2 command is discoverable before running the author stages.

Validation to perform later:

- Confirm winsor2 availability and version with an exact-name software check, without a study-data trial.

### A_R_PACKAGE_SETUP: Verify the independent R package dependencies haven, grf, ggplot2, ExPanDaR and scales in the R environment selected by the wrapper.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SCALES, SW_R_HAVEN, SW_R_GRF, SW_R_GGPLOT2, SW_R_EXPANDAR
Evidence: E_R_SCRIPT_STACK, E_R_SCRIPT_OUTPUT, E_ENVIRONMENT

Preparation / proposed procedure:

1. Check the five exact R package names and versions in the approved R environment.
2. Install only missing packages after future authorization and confirm ExPanDaR provides treat_outliers and scales provides both namespaced label functions.

Validation to perform later:

- Confirm each package loads and each called function is available before an authorized study-data run.

### A_RSCRIPT_PATH: Configure the wrapper's R_PATH value to the verified Rscript executable for the intended host and confirm the compatible R/package version; the current Windows 4.4.2 path has no verified match in the registered R 4.5.0 environment.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: SW_RSCRIPT_EXECUTABLE, I_RSCRIPT_HOST_PATH
Evidence: E_WRAPPER_PATH_SETUP, E_ENVIRONMENT, E_R_SCRIPT_STACK

Preparation / proposed procedure:

1. Identify the authorized host's actual Rscript executable path and the required author-compatible R release.
2. Update the wrapper's single R_PATH configuration only after both values are verified; keep the existing Stata-to-R stage and Figure 7 output.

Validation to perform later:

- Verify the configured R_PATH resolves to the selected Rscript executable and that required packages are available before the full wrapper is attempted.

### A_WINDOWS_CLEANUP: Verify the target host's handling of the source's Windows-specific rmdir options and configure a safe cleanup for only the generated bak.stunicode directory if needed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_WINDOWS_CLEANUP
Evidence: E_WRAPPER_CLEANUP, E_REGISTER_PROCESS, E_ENVIRONMENT

Preparation / proposed procedure:

1. Confirm whether the target Stata host accepts the source cleanup options after Unicode translation.
2. If it does not, use a host-appropriate command that removes only the generated bak.stunicode directory and preserves translated data.

Validation to perform later:

- Before an authorized run, verify cleanup behavior on the target host and confirm the translation backups are not required by later stages.


## Remaining issues and prerequisites

- I_AUTHOR_INPUT_COVERAGE [unresolved; full_pipeline]: The frozen inventory contains no author data files. The code consumes unbundled Dafne batches, manual firm-ID exclusions, author randomization, crawler files and the hand-collected supplement, manual response classifications, NeverBounce status and a postal-code crosswalk. Exact fields, identifier links and full population/period coverage are not verified. The authors mention public Company Register data as an archival source, but no source matches the code's exact batch schema or coverage; candidate public routes are separately left unverified. Confidential survey/treatment access is tracked in a separate issue.
- I_MANUAL_FIGURES_2_3 [unresolved; full_pipeline]: The authors' full workflow includes Figures 2 and 3 as a manual PowerPoint stage, but the supplied package inventory has no editable deck, values or detailed reproduction instructions. The missing details prevent confirming and repeating these outputs.
- I_CONFIDENTIAL_SURVEY_ROUTE [unresolved; full_pipeline]: The authors describe LimeSurvey field records and randomized treatment identifiers as confidential and state that they retained archives for private provision to editors. The exact approved access route, file inventory and handling conditions are not verified; this does not establish a universal access barrier.
- I_RSCRIPT_HOST_PATH [preparation; full_pipeline]: The wrapper hard-codes a Windows R 4.4.2 executable path. The registered environment reports R 4.5.0, but the native host's Rscript path, required version and R package compatibility are unverified.
- I_WINDOWS_CLEANUP [preparation; full_pipeline]: The Unicode conversion stage invokes shell rmdir /S /Q on the generated bak.stunicode directory. These are Windows-specific options; verify whether that one cleanup command is supported by the chosen native Stata host, then use a host-appropriate cleanup limited to that generated temporary directory. This is a platform preparation step, not a missing data or undocumented analysis branch.
- R_PREEXP_DAFNE_FREE [undetermined]: The five free Dafne export workbooks used to form the pre-experiment sample. The exact columns beyond the matching firm identifier and complete historical coverage are not verified.
- R_PREEXP_DAFNE_COSTLY [undetermined]: The nine costly Dafne export workbooks used to form the pre-experiment sample. The exact columns and full historical coverage are not verified.
- R_PREEXP_MANUAL_FILTER [undetermined]: The author-prepared Full-Pot-Hinterleger workbook used to remove firms identified as restricting 2014 statements.
- R_SURVEY_INVITATION_TOKENS [undetermined]: The LimeSurvey invitation-token and randomized-arm linkage CSV used to remove internal test invitations and match participants to responses.
- R_SURVEY_RESPONSES [undetermined]: The full LimeSurvey response workbook used for answer recoding and the survey-only and response-conditional analyses.
- R_SURVEY_DUPLICATE_REVIEW [undetermined]: The manually reviewed duplicate-answer workbook used to remove duplicate participant responses.
- R_OTHER_REMOVED_LIST [undetermined]: The author-prepared firm-ID exclusion list used after iterative manual eligibility review and correction of names, email addresses and domains; this is a filtered identifier list, not a raw firm dataset.
- R_RANDOMIZED_ASSIGNMENT [undetermined]: The author-created randomization/identifier linkage file used to attach treatment arm and cleaned email to each firm; it is an assignment list, not a firm-level raw dataset.
- R_POSTEXP_NONLIMITED [undetermined]: The separate Dafne export of non-limited-liability firms, converted by the author code into an ID-only exclusion dataset.
- R_POSTEXP_INSOLVENT [undetermined]: The separate 2011–2014 Dafne export of insolvent firms, converted by the author code into an ID-only exclusion dataset.
- R_POSTEXP_ASSETS_TURNOVER_2011_2014 [undetermined]: Twelve author-obtained Dafne Excel batches for assets, turnover and industry fields in 2011 and 2014; these are raw construction inputs, not an analysis-ready file.
- R_POSTEXP_EMPLOYEES_2011 [undetermined]: Six author-obtained Dafne Excel batches containing 2011 employee counts and industry codes; these feed the firm-year merges and size classification.
- R_POSTEXP_ASSETS_TURNOVER_2010_2012_2013 [undetermined]: Fifteen author-obtained Dafne Excel batches for 2010, 2012 and 2013 assets and turnover, used with 2011/2014 records to form capital-intensity inputs.
- R_SURVEY_Q3_CLASSIFICATION [undetermined]: The manually classified Q3 free-text response-ID list used to recode 'other' answers as unaware; it is a response-ID classification, not the full survey response data.
- R_SURVEY_Q4_CLASSIFICATION [undetermined]: The separate manually prepared Q4 response-ID classification list used to recode 'other' answers; it is not the full survey response data.
- R_SURVEY_COMMENT_CLASSIFICATION [undetermined]: The author-prepared Comment-Unwissend.dta response-ID classification used to derive survey uncertainty; this is a manually classified subset of survey responses, not a full response dataset.
- R_NEVERBOUNCE_EMAIL_STATUS [undetermined]: The author-prepared NeverBounce match/status file used to exclude invalid and disposable firm email addresses; it is a status mapping keyed by firm ID, not a raw firm dataset.
- R_POSTAL_DISTRICT_CROSSWALK [undetermined]: The author-used postal-code to district crosswalk merged to construct district_id; it is a mapping table, not a firm-level dataset.
- R_REGISTER_CRAWLER_2015 [undetermined]: The author-prepared 2015 company-register crawler file used to identify filings/restrictions and match firms to the pre-experiment sample. Its full historical firm/statement coverage and field schema are unverified.
- R_REGISTER_HANDCOLLECTED_2015 [undetermined]: The manually collected supplement of 104 unmatched firms appended to the 2015 crawler output; this is a narrow author-prepared match-recovery subset, not the full crawler dataset.
- R_REGISTER_CRAWLER_2016 [undetermined]: The author-prepared 2016 company-register crawler file used to form the separate post-period restriction outcome. Its complete population and statement-period coverage are unverified.
- R_FIGURE1_DAFNE_HIT_SUMMARY [undetermined]: The manually assembled Dafne search-hit summary used only for Figure 1; the author source describes percentages from manual 2019/2020 searches. It is an aggregate summary, not firm-level analysis data or a full Dafne population.
- R_ARCHIVEORG_WEBSITE_STATUS [undetermined]: The author-prepared website-year status CSV used for the firm-activity outcome, keyed by website_id and containing isalive and November 2023 request status. The URL population and historical years are unverified.
- R_DAFNE_VVC_ACTIVE_STATUS [undetermined]: The separate Bureau van Dijk/VVC active-firm workbook used as a second status source in the firm-activity analysis; it is a status subset, not the full firm dataset.
- SW_WINSOR2 [preparation_required]: The 11-stage code invokes winsor2; the registered exact-name probe reports it unavailable in the default and configured Stata contexts.
- SW_HERE [preparation_required]: The wrapper and author stages require the exact Stata command here for project-root discovery. Its frozen Stata 18 version/which-only probe completed and returned unavailable (which return code 111); project-root resolution itself remains a separate configuration check.
- SW_DISTINCT [preparation_required]: The author preparation requires the exact Stata command distinct. Its frozen Stata 18 version/which-only probe completed and returned unavailable (which return code 111).
- SW_FSUM [preparation_required]: The author table program requires the exact Stata command fsum. Its frozen Stata 18 version/which-only probe completed and returned unavailable (which return code 111).
- SW_STATA_RSCRIPT [preparation_required]: The author wrapper requires the exact Stata command rscript for the CATE handoff. Its frozen Stata 18 version/which-only probe completed and returned unavailable (which return code 111); this does not test the separate Rscript executable or R packages.
- SW_RSCRIPT_EXECUTABLE [unverified]: The wrapper sets a Windows R 4.4.2 path, while the registered environment reports R 4.5.0; the actual native-host Rscript executable/path and package compatibility are unverified.
- SW_R_HAVEN [unverified]: The CATE script loads haven to read MainSample.dta; local availability and version were not verified.
- SW_R_GRF [unverified]: The CATE script loads grf and calls causal_forest; local availability and version were not verified.
- SW_R_GGPLOT2 [unverified]: The CATE script loads ggplot2 to build the Figure 7 plot; local availability and version were not verified.
- SW_R_EXPANDAR [unverified]: The CATE script loads ExPanDaR and calls treat_outliers; local availability and version were not verified.
- SW_SCALES [unverified]: The CATE script calls scales::label_percent and scales::label_comma; local package availability and version were not verified.
- SW_POWERPOINT [unverified]: The authors state that Figures 2 and 3 are manually made in PowerPoint; local availability and required version are unverified.

## Review notes

- The assessed full scope is the native author workflow launched by 2_Code/_Wrapper.do: Stata import and construction, survey processing, registry merges, tables, Stata figures, the separate R CATE Figure 7 stage, and the final firm-activity analysis. Figure 2 and Figure 3 remain documented manual PowerPoint outputs. No analysis_only scope is supported because no author-prepared MainSample or other analysis dataset is supplied.
- All 39 frozen dependency IDs are reviewed. Generated dependencies cite active source producers; direct code reads omitted from the frozen checklist are separately recorded as requirements or as source-confirmed generated intermediates. closure_complete remains false because exact author inputs and the Figure 2/3 manual source steps remain unresolved; execution_verified is false.
- The frozen inventory lists no data files. The requirements separate full Dafne batches, author identifier/exclusion lists, 2011/2014 and earlier-year export sets, crawler datasets, a 104-firm hand-collected supplement, full survey responses, response-ID classification subsets, email-status and postal mappings, the Figure 1 search-hit aggregate, and two distinct activity-status inputs. Required fields, ID links, full populations and history remain unverified.
- Commercial Dafne, the authors' cited public Company Register and Internet Archive Wayback are recorded as unverified candidate routes. No access_barrier claim is made. Confidential survey/treatment records are a separate unresolved access route: the datasheet says they are confidential but retained for private provision to editors.
- The original environment probe supports Stata, R, reghdfe and ftools and shows winsor2 unavailable. Four frozen Stata 18 version/which-only probes for here, distinct, fsum and the Stata command rscript completed successfully and returned available=false with which return code 111; those four commands are preparation_required. The separate Rscript executable/path, R packages haven, grf, ggplot2, ExPanDaR and scales, and PowerPoint remain unverified. The hard-coded Windows R path and Windows cleanup options are specific host-configuration preparation steps.
- Process history: the first source-view redirection failed before the reader started and the diagnostic plus successful retry were retained. Stage 2 and stage 4 first attempts failed on duplicate dependency D0014 and a requirement-ID typo respectively; their actual helpers, separate streams/status records and successful retries were preserved. One own-generation recursive file listing was filtered and a later combined command included a second own-generation listing; that output was truncated and the raw streams/status were not preserved. The exact retrospective note is probes/own_generation_listing_incident_note.json; no other package or generation was traversed and no completeness claim is based on those listings.
- No author program or study data was executed, installed, requested, downloaded or edited. Public documentation was limited to the official Company Register search/cost pages and Internet Archive Wayback help.
