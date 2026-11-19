# Patch proposal: jar-0446429827b1

The Role of Academic Research in SEC Rulemaking: Evidence from Business Roundtable v. SEC

DOI: 10.1111/1475-679X.12358

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | local_available | preparation_required |

### full_pipeline

Complete supplied Stata workflow: sample construction plus all figure and table branches (Figures 3–5 and Tables 3–6).

Entry points: `GL 2021 JAR- Stata code.do`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Supplied final-regression-sample bypass for the complete Table 4, Table 5 and Table 6 regression branches only. It skips sample construction and excludes Table 3 descriptives and Figures 3–5, which need other intermediates; it makes no claim about survey analyses.

Entry points: `GL 2021 JAR- Stata code.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 2/12358 - The-Role-of-Academic-Research-in-SEC-Rulemaking-Evidence-from-Business-Roundtable-v-SEC/gl-datasheet-and-code-files.zip",
      "sha256": "f74b733202018fde3fa9899b11f4226129e89a7dcbd2375cc71cf6fc6e398916"
    },
    {
      "path": "JAR-Volume 59/Issue 2/12358 - The-Role-of-Academic-Research-in-SEC-Rulemaking-Evidence-from-Business-Roundtable-v-SEC/gl-online-appendix.pdf",
      "sha256": "23c636cf38d6d052aa39078facaf8ca800c6c81b96760c747c82e57f27f0b41e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "ac17deb5fd402ee7f2b202caad841cfbb5102ed008f8503d25a933b516f4f060"
}
```

## Proposed actions

### A_RAW_INPUTS: Obtain the exact author-prepared hand-collected inputs required by the full-pipeline imports; do not rebuild their classifications from source filings.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_CITATIONS, R_WORDCOUNT, R_MANDATORY, R_MTURK, I_RAW_INPUTS
Evidence: E_CIT_PROPOSED, E_CIT_FINAL, E_WORDCOUNT, E_MANDATORY, E_MTURK, E_DATASHEET_HAND, E_INVENTORY, E_DATASHEET_MTURK

Preparation / proposed procedure:

1. Request SEC_doc_citations.xlsx with Proposed_Release and Final_Release sheets and the fields used at code lines 31–35 and 113–118.
2. Request SEC_doc_tablecount.xlsx with the two release sheets and DocumentNumber, WordCount and table fields.
3. Request DoddFrankandJOBS.xlsx Sheet1 and Final_mturk.xlsx Final_mturk_noduplicates with the fields named in the code; preserve the authors’ original human/M-turk classifications.
4. Ask for source coverage and any cleaning/inclusion rules needed to identify the same author-prepared products. Do not substitute scraped or independently recreated rows.

Validation to perform later:

- Use bounded metadata inspection to confirm the named worksheets and fields after receipt.
- After the remaining prerequisites are met and execution is authorized, reconcile merge and sample counts with author documentation.

### A_TOPIC_INPUTS: Resolve provenance and the production route for the two topic-number datasets before full sample construction.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PROPOSED_TOPIC, R_FINAL_TOPIC, I_TOPIC_PRODUCERS
Evidence: E_TOPIC_PROPOSED, E_TOPIC_FINAL, E_INVENTORY, E_TOPIC_YEAR_FIELD

Preparation / proposed procedure:

1. Request proposed_topic_N.dta and final_topic_N.dta, or the exact source files and program that generate them.
2. Confirm each dataset has a unique doc_num key and author-assigned topic_num values for its release set; also confirm the source and meaning of PublicationYearLastUpdate used after append, plus coverage and exclusions.
3. Keep proposed and final maps as separate variants; use only the author-confirmed producer or assignment rules.

Validation to perform later:

- Inspect readability, required fields and unique merge keys.
- After authorized execution, inspect the m:1 merge results and reconcile unmatched rows with the documented sample rules.

### A_SURVEY_SCOPE: Clarify survey-analysis scope and obtain the materials referenced by the datasheet.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SURVEY_SCOPE
Evidence: E_DATASHEET_SURVEYS, E_DATASHEET_APPENDIX, E_APPENDIX_TITLE, E_PURPOSE, E_SURVEY2, E_SURVEY1_PROBE, E_SURVEY2_PROBE

Preparation / proposed procedure:

1. Ask whether Survey_1.xlsx and Survey_2.xlsx are supplementary inputs outside this Stata workflow or whether a separate analysis branch is omitted.
2. If survey analyses are in scope, request their author code/entry points, the correct paper-specific appendix/instruments and the variable-construction/exclusion documentation.
3. If survey analysis is outside this code workflow, record that boundary; do not infer a program from the data files alone.

Validation to perform later:

- Match any clarified survey branch to its entry point, survey inputs and appendix instructions before assessing it as executable.

### A_OUTPUT_FILES: Obtain the intended persistent output contract for Figures 3–5 before proposing graph-export commands.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_OUTPUT_FILES
Evidence: E_FIG3, E_FIG4, E_FIG5

Preparation / proposed procedure:

1. Ask whether Figures 3–5 are meant to remain as Stata display output or be saved as files.
2. If files are required, request exact filenames, formats, destination and styling; then prepare only the matching line-anchored graph-export changes.
3. Keep all Figure 3–5 calculations and branches unchanged.

Validation to perform later:

- After author clarification and an authorized run, confirm all named figure files are created with the specified formats.

### A_PATHS: Configure the do-file data root and output directory for a local writable execution tree.

Scopes: full_pipeline, analysis_only. Type: configuration. Certainty: supported.
Addresses: I_PATHS
Evidence: E_PATHS

Preparation / proposed procedure:

1. Before a future authorized run, set the global main assignment at line 13 to a local writable root containing expected Raw_data and Cleaned_data subdirectories.
2. Set the local outdir assignment at line 14 to a writable results directory.
3. Keep input names, model specifications and output names unchanged.

Validation to perform later:

- Confirm the configured root resolves every required import/use path before executing the do-file.
- Confirm the results directory is writable for the Table4.xls, Table5.xls and Table6.xls outputs.

### A_STAGE_ANALYSIS_DATA: Stage the two compatible packaged final regression datasets under the directory layout expected by the Table 4–6 code.

Scopes: analysis_only. Type: data_preparation. Certainty: supported.
Addresses: R_DOCREG_ANALYSIS, R_CLREG_ANALYSIS
Evidence: E_DOCREG_PROBE, E_CLREG_PROBE, E_PATHS, E_FINAL_DATASET_ASSERTION

Preparation / proposed procedure:

1. Create a local staging root with a Cleaned_data subdirectory and copy document_regsample.dta and CL_regsample.dta from the package into it without modifying their bytes.
2. Set global main to that staging root so the Table 4–6 use statements resolve the two files.

Validation to perform later:

- Run bounded metadata probes on the staged copies and confirm the required fields match the packaged files.
- Confirm the Table 4–6 use paths resolve before any future authorized run.

### A_OUTREG2: Add the required outreg2 Stata package to the active Stata 18 ado path.

Scopes: full_pipeline, analysis_only. Type: software_setup. Certainty: supported.
Addresses: SW_OUTREG2
Evidence: E_TABLE4, E_TABLE5, E_TABLE6, E_OUTREG2, E_PUBLIC_OUTREG2

Preparation / proposed procedure:

1. In a future authorized software-preparation step, install the SSC outreg2 package into the active Stata 18 user ado path; no installation was performed in this assessment.

Validation to perform later:

- Use Stata which outreg2 to confirm it resolves from the active ado path.
- After data/path setup and an authorized run, confirm the three Excel files are written under the configured output directory.

### A_RUN_FULL: Run the complete supplied workflow only after the unresolved data, scope, output and software prerequisites are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_CITATION_OUTPUT, E_DOCLEVEL_OUTPUT, E_WORDCOUNT_OUTPUT, E_MANDATORY_OUTPUT, E_CL_OUTPUT, E_DOCREG_OUTPUT, E_DOCCL_OUTPUT, E_CLREG_OUTPUT, E_FIG3, E_FIG4, E_FIG5, E_TABLE3, E_TABLE4, E_TABLE5, E_TABLE6, E_FIG3_INPUT, E_FIG4_INPUT, E_FIG5_INPUT, E_TABLE3_AGE, E_TABLE3_CL, E_TABLE4_INPUT, E_TABLE5_INPUT, E_TABLE6_INPUT

Preparation / proposed procedure:

1. Run GL 2021 JAR- Stata code.do from the beginning through line 687 in Stata 18 after the author data, output, path and package prerequisites are met.
2. Preserve producer order: build citation_merged2 and citation_merged_doc_level from both release sheets and topic maps; create word.dta from table-count sheets; create mandatory.dta from DoddFrankandJOBS.xlsx; create CL.dta from Final_mturk.xlsx; merge citation/word/mandatory to document_regsample.dta; merge CL with document_regsample to doc_CL_sample.dta and CL_regsample.dta; then execute Figures 3–5, Table 3, Tables 4–5 and Table 6 in the Part B order.
3. Retain every supplied model, test, filter and branch.

Validation to perform later:

- After authorized execution, compare merge/sample counts with the author documentation.
- Verify confirmed figure/table deliverables and the Table 4–6 Excel outputs; this assessment does not certify execution.

### A_RUN_ANALYSIS: Run all supplied Table 4–6 regression branches directly on the author-prepared final datasets after path and outreg2 setup.

Scopes: analysis_only. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E_TABLE4, E_TABLE5, E_TABLE6, E_FINAL_DATASET_ASSERTION, E_DOCREG_PROBE, E_CLREG_PROBE

Preparation / proposed procedure:

1. After staging the supplied final files and setting local paths, execute Table 4 at lines 545–591, Table 5 at lines 598–645, and Table 6 at lines 652–687 in Stata 18.
2. Keep all listed regressions, post-estimation tests, filters and outreg2 append/replace calls unchanged.
3. This route excludes Table 3, Figures 3–5, raw-data construction and survey-analysis branches.

Validation to perform later:

- Confirm Table4.xls, Table5.xls and Table6.xls appear under the configured output path with the six Table 4 models, six Table 5 models and four Table 6 models.
- Numerical agreement remains unverified until a future authorized run.


## Remaining issues and prerequisites

- I_RAW_INPUTS [unresolved; full_pipeline]: The full sample-construction branch requires four hand-collected workbooks named by the do-file, but they are not in the package inventory. The datasheet describes human collection/coding and M-turk classification, so rebuilding the authors’ classifications from public SEC releases is not a supported substitute.
- I_TOPIC_PRODUCERS [unresolved; full_pipeline]: The do-file merges proposed_topic_N.dta and final_topic_N.dta but supplies no producer or construction instructions. Both files are absent, and the topic assignments affect the analysis sample. The post-append step also consumes PublicationYearLastUpdate, so the final topic file’s required fields must be confirmed.
- I_SURVEY_SCOPE [unresolved; full_pipeline]: The datasheet identifies two survey datasets and references paper-specific online-appendix instructions, but the supplied Stata workflow does not identify a survey-analysis entry point. The bundled appendix title concerns Relative Valuation with Machine Learning and does not appear to match this paper. Clarify whether survey analyses are outside this code scope or provide the missing workflow and correct appendix.
- I_OUTPUT_FILES [unresolved; full_pipeline]: The Figure 3–5 branches issue twoway graph commands but do not specify persistent figure files. Confirm filenames, format and destination before proposing graph-export edits; do not infer an output format.
- I_PATHS [preparation; full_pipeline, analysis_only]: The do-file hard-codes Windows paths for the data root and table output directory. Configure these assignments for a local writable tree with the expected Raw_data/Cleaned_data layout and output path before execution.
- R_CITATIONS [undetermined]: Author-prepared SEC_doc_citations.xlsx workbook with Proposed_Release and Final_Release sheets. Imports use DocumentNumber, JournalBook, Date, Topic, Authors, ArticleTitle, PublicationYear, cost, benefit, neutral and release-specific costfn/benfn/neufn/Qunsure or costfn/benfn/neuft/Unsure fields to construct citation and tone measures.
- R_WORDCOUNT [undetermined]: SEC_doc_tablecount.xlsx with Proposed_Release and Final_Release sheets and DocumentNumber, WordCount and table fields, used to create word.dta and lnWord.
- R_MANDATORY [undetermined]: DoddFrankandJOBS.xlsx Sheet1 with DocumentNumber, DoddFrank and JOBS fields, used to construct Mandatory.
- R_MTURK [undetermined]: Final_mturk.xlsx sheet Final_mturk_noduplicates with Answersentiment, DocumentNumber and Year, used to form CL.dta and comment-letter outcomes.
- R_PROPOSED_TOPIC [undetermined]: proposed_topic_N.dta, merged many-to-one by doc_num to supply proposed-release topic_num; producer and construction are undocumented.
- R_FINAL_TOPIC [undetermined]: final_topic_N.dta, merged many-to-one by doc_num to supply final-release topic_num; producer and construction are undocumented. The post-append code also consumes PublicationYearLastUpdate after the merge.
- SW_OUTREG2 [preparation_required]: The Table 4–6 branches use outreg2 to write Excel tables; the bounded Stata which probe does not find it. A repository entry documents its SSC route.

## Review notes

- The full_pipeline scope covers every section of the provided Stata file; closure remains incomplete because the topic maps have no producer, hand-collected source workbooks are absent, and the datasheet describes survey inputs without a matching survey-analysis entry point.
- analysis_only is intentionally limited to all Table 4, Table 5 and Table 6 regression models. The datasheet identifies the two packaged datasets as the final regression samples. Fresh bounded probes confirm readability, required fields, 357 and 105 file-level observations, respectively; each sampled one row for column metadata and coverage_verified remains false.
- Actual producer order is citation_merged2/citation_merged_doc_level, then word.dta, mandatory.dta and CL.dta, then document_regsample, followed by doc_CL_sample and CL_regsample, then Part B figures and tables. Figure 3–4 and Table 3 use citation_merged2; Figure 5 uses doc_CL_sample; Tables 4–5 use document_regsample; Table 6 uses CL_regsample.
- Stata 18 and unique are available from bounded probes. The full workflow invokes nvals(); its exact _gnvals entry point was confirmed available. The separate package-name which egenmore result was not treated as evidence that this function was absent. All Table 4–6 branches need outreg2, which remains missing. No author code, regressions, installs or dataset downloads were run.
