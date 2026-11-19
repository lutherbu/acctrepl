# Patch proposal: jar-dbdde12f5f95

Investor Behavior and the Benefits of Dispersed Stock Ownership

DOI: 10.1111/1475-679X.12198

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | local_available | preparation_required |

### full_pipeline

Complete current documented target: the supplied primary-analysis program plus the published exploratory online appendix branch. The appendix time-series input/producer contract remains unverified.

Entry points: `BCH Stata Code.do`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Primary Stata tables from the author-supplied BCH Data Sheet workbook, retaining the included cleaning, within-university standardization, treatment interactions, and both executed Table 3 model variants. This narrower scope excludes the published exploratory online-appendix branch.

Entry points: `BCH Stata Code.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 2/12198 - Investor-Behavior-and-the-Benefits-of-Dispersed-Stock-Ownership/bch-datasheet-and-code.zip",
      "sha256": "e54bdb92f6406c41fce9a51939e0a3f0bf1d5df5d4ddbcb596225f99e7b6d230"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12198 - Investor-Behavior-and-the-Benefits-of-Dispersed-Stock-Ownership/bch-online-appendix.pdf",
      "sha256": "16138c8cf371903314593cbbd01cfc3ef265199d5d758d5f3d1536bb2604355b"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12198 - Investor-Behavior-and-the-Benefits-of-Dispersed-Stock-Ownership/bernard-cade-hodge-accepted-proposal.pdf",
      "sha256": "a726a2a77a67cf5de61a852b05dad5c566d86a0937d585b918b6acf0cb230af7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "f2e88f439bc3520d753cac36283364d1a8780fcf9142e1b932cd2dc4fb0f1eec"
}
```

## Proposed actions

### A_IMPORT_WORKBOOK: Connect the supplied author-named final workbook to the Stata program. The workbook sheet and all required raw headers are verified; use an explicit Excel import rather than an empty Stata use path.

Scopes: full_pipeline, analysis_only. Type: source_edit. Certainty: supported.
Addresses: R_BCH_DATA, I_DATA_LOAD
Evidence: E_CODE_INPUT, E_DATASET_NAMED, E_PACKAGED_SHEET_PROBE

**Proposed edit:** `BCH Stata Code.do:6–6`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

The packaged and author-named input is an Excel workbook; the current use command has no path and does not import Excel. The probed sheet name and valid unique headers support this import form.

Current text:
```
use ""
```

Proposed replacement:
```
import excel "BCH Data Sheet.xlsx", sheet("BCH Data Sheet") firstrow clear
```

Preparation / proposed procedure:

1. Run from the package directory (or a working copy) so the workbook basename resolves.
2. If the intended author input was instead a Stata-format file, obtain its exact filename and path rather than substituting an unverified file.

Validation to perform later:

- In a disposable working copy, run the import and inspect the resulting variable names and storage types; confirm all 37 required base fields are present and the observation count is nonzero.
- After software setup, run the full supplied BCH Stata Code.do and record any remaining data/type errors without changing the research design.

### A_SETUP_OUTREG2: Make the author-required outreg2 command available to Stata 18 for the Table 4 and Table 5 Excel exports.

Scopes: full_pipeline, analysis_only. Type: software_setup. Certainty: supported.
Addresses: S_OUTREG2
Evidence: E_CODE_OUTREG2, E_CODE_OUTREG2_T5, E_ENVIRONMENT_PROBE, E_OUTREG2_REPOSITORY

Preparation / proposed procedure:

1. Use the repository-documented Stata SSC route to install outreg2 in the authorized Stata environment: ssc install outreg2. This audit did not install or download it.
2. Confirm the installed ado files are on the Stata adopath.

Validation to perform later:

- In Stata, run which outreg2 and confirm it resolves to the installed package; then check help outreg2 before executing the supplied program.

### A_SEPARATE_TABLE4_OUTPUTS: Direct all seven OthersMoney calls and all seven RegulatoryAlignment calls to separate Table 4 output bases, leaving the seven OwnMoney calls at table4_reg. Preserve every regression, option, and first-call replace behavior.

Scopes: full_pipeline, analysis_only. Type: source_edit. Certainty: supported.
Addresses: I_TABLE4_EXPORT
Evidence: E_CODE_TABLE4_REPLACE_A, E_CODE_TABLE4_REPLACE_B, E_CODE_TABLE4_REPLACE_C

**Proposed edit:** `BCH Stata Code.do:144–144`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this OthersMoney model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(1) replace
```

Proposed replacement:
```
outreg2 using table4_reg_othersmoney, stats(coef tstat) bdec(3) tdec(2) excel ctitle(1) replace
```

**Proposed edit:** `BCH Stata Code.do:146–146`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this OthersMoney model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(2) 
```

Proposed replacement:
```
outreg2 using table4_reg_othersmoney, stats(coef tstat) bdec(3) tdec(2) excel ctitle(2) 
```

**Proposed edit:** `BCH Stata Code.do:148–148`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this OthersMoney model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(3) 
```

Proposed replacement:
```
outreg2 using table4_reg_othersmoney, stats(coef tstat) bdec(3) tdec(2) excel ctitle(3) 
```

**Proposed edit:** `BCH Stata Code.do:150–150`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this OthersMoney model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(4) 
```

Proposed replacement:
```
outreg2 using table4_reg_othersmoney, stats(coef tstat) bdec(3) tdec(2) excel ctitle(4) 
```

**Proposed edit:** `BCH Stata Code.do:152–152`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this OthersMoney model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(5) 
```

Proposed replacement:
```
outreg2 using table4_reg_othersmoney, stats(coef tstat) bdec(3) tdec(2) excel ctitle(5) 
```

**Proposed edit:** `BCH Stata Code.do:154–154`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this OthersMoney model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(6) 
```

Proposed replacement:
```
outreg2 using table4_reg_othersmoney, stats(coef tstat) bdec(3) tdec(2) excel ctitle(6) 
```

**Proposed edit:** `BCH Stata Code.do:156–156`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this OthersMoney model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(7) 
```

Proposed replacement:
```
outreg2 using table4_reg_othersmoney, stats(coef tstat) bdec(3) tdec(2) excel ctitle(7) 
```

**Proposed edit:** `BCH Stata Code.do:159–159`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this RegulatoryAlignment model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(1) replace
```

Proposed replacement:
```
outreg2 using table4_reg_regulatoryalignment, stats(coef tstat) bdec(3) tdec(2) excel ctitle(1) replace
```

**Proposed edit:** `BCH Stata Code.do:161–161`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this RegulatoryAlignment model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(2) 
```

Proposed replacement:
```
outreg2 using table4_reg_regulatoryalignment, stats(coef tstat) bdec(3) tdec(2) excel ctitle(2) 
```

**Proposed edit:** `BCH Stata Code.do:163–163`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this RegulatoryAlignment model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(3) 
```

Proposed replacement:
```
outreg2 using table4_reg_regulatoryalignment, stats(coef tstat) bdec(3) tdec(2) excel ctitle(3) 
```

**Proposed edit:** `BCH Stata Code.do:165–165`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this RegulatoryAlignment model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(4) 
```

Proposed replacement:
```
outreg2 using table4_reg_regulatoryalignment, stats(coef tstat) bdec(3) tdec(2) excel ctitle(4) 
```

**Proposed edit:** `BCH Stata Code.do:167–167`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this RegulatoryAlignment model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(5) 
```

Proposed replacement:
```
outreg2 using table4_reg_regulatoryalignment, stats(coef tstat) bdec(3) tdec(2) excel ctitle(5) 
```

**Proposed edit:** `BCH Stata Code.do:169–169`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this RegulatoryAlignment model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(6) 
```

Proposed replacement:
```
outreg2 using table4_reg_regulatoryalignment, stats(coef tstat) bdec(3) tdec(2) excel ctitle(6) 
```

**Proposed edit:** `BCH Stata Code.do:171–171`
Source SHA-256: `29aecb67aaecb5db752bbbd143028992a7b80410566b38f87ee13b70de18d292`

Route this RegulatoryAlignment model to its panel-specific export file while retaining the original command options and model specification.

Current text:
```
outreg2 using table4_reg, stats(coef tstat) bdec(3) tdec(2) excel ctitle(7) 
```

Proposed replacement:
```
outreg2 using table4_reg_regulatoryalignment, stats(coef tstat) bdec(3) tdec(2) excel ctitle(7) 
```

Preparation / proposed procedure:

1. Leave the OwnMoney panel on table4_reg. Use table4_reg_othersmoney for all seven OthersMoney export calls and table4_reg_regulatoryalignment for all seven RegulatoryAlignment calls. Keep replace on lines 144 and 159 only, as currently specified for each panel’s first call.

Validation to perform later:

- Review all 21 Table 4 outreg2 calls to confirm only output bases changed and the existing replace setting remains on the first call of each panel.
- After a future run in a disposable working copy, confirm three distinct Table 4 workbooks are created and each contains its seven panel specifications.

### A_RUN_MAIN_PROGRAM: After the workbook loader and Stata add-on setup are resolved, run the supplied primary-analysis program in Stata 18 from a disposable copy of the package. The full_pipeline also requires a separately supplied and reviewed appendix weekly-panel branch.

Scopes: full_pipeline, analysis_only. Type: run_procedure. Certainty: supported.
Addresses: R_BCH_DATA, S_STATA, S_OUTREG2, I_DATA_LOAD, I_TABLE4_EXPORT
Evidence: E_CODE_INPUT, E_ENVIRONMENT_PROBE, E_PACKAGED_SHEET_PROBE

Preparation / proposed procedure:

1. Set the Stata working directory to the copied package folder.
2. Run do "BCH Stata Code.do" after applying the agreed Excel import and Table 4 output configuration and confirming outreg2 is available.
3. Retain Stata Results output and the table4_reg, table4_reg_othersmoney, table4_reg_regulatoryalignment, and table5_reg exports. The appendix branch remains pending its author-provided input/producer contract.

Validation to perform later:

- Confirm the main analysis reaches all documented code sections, including both executable Table 3 variants, and its outputs are captured. For the full scope, separately validate the appendix branch only after its author-compatible panel or producer is supplied. No author code was executed for this assessment.

### A_CLARIFY_WEEKLY_PANEL: Obtain the author-compatible weekly-panel input or producer contract required by the published appendix time-series branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_WEEKLY_PANEL, I_WEEKLY_PANEL_PRODUCER
Evidence: E_APPENDIX_SCOPE, E_APPENDIX_WEEKLY_A, E_APPENDIX_WEEKLY_B, E_APPENDIX_WEEKLY_C, E_PACKAGED_SHEET_PROBE, E_MAIN_TABLE7_CODE

Preparation / proposed procedure:

1. Confirm the exact author-prepared 94-observation university-by-treatment-group-week dataset or request the author-supplied producer code and its required inputs.
2. Obtain the defined week period, TotalSpend construction, monthly reminder dates, and Salient_1week/Salient_2weeks construction so the participant workbook candidate can be assessed compatibly.
3. Do not reconstruct the appendix analysis or infer missing weekly inputs from historical survey/source descriptions.

Validation to perform later:

- Verify the supplied input/producer yields the appendix-described 94 university-group-week observations, weekly outcome, and reminder flags before including this branch in an executable full workflow.

### A_REQUEST_APPENDIX_SUBGROUP_CODE: Obtain the author-supplied workflow or exact output instructions for the appendix university-specific and subsample analyses.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_APPENDIX_SUBGROUP_ANALYSIS
Evidence: E_APPENDIX_UNIVERSITY, E_APPENDIX_UNIV_MEASURES, E_APPENDIX_INCOME, E_APPENDIX_INVESTMENTS, E_APPENDIX_USNATIONAL, E_APPENDIX_USNATIONAL_SPLIT, E_MAIN_TABLE7_CODE

Preparation / proposed procedure:

1. Request the author program or exact execution procedure for the university-specific primary-outcome tests and by-school process, cross-sectional, social-connection, and financial-variable analyses.
2. Request the workflow for the Income >= 4 and Income = 1 exclusions, NumberInvestments = 0 versus > 0 splits, and the US-national NumberInvestments subsamples.
3. Obtain the table-to-code mapping, sample restrictions, and any standardization/setup instructions; keep the weekly time-series panel contract separate and do not invent regression code.

Validation to perform later:

- After the author workflow is supplied, map each documented subgroup output to a supplied execution path and verify the implemented sample definitions match the appendix text.


## Remaining issues and prerequisites

- I_DATA_LOAD [preparation; full_pipeline, analysis_only]: Line 6 is use "" with no path. The only packaged dataset is BCH Data Sheet.xlsx, so the current Stata command does not load the supplied Excel workbook. The data description names this workbook as the final dataset and the bounded probe confirms its sheet and consumed headers; the missing step is an explicit Excel import (or an author-specified Stata-format file/path).
- I_TABLE4_EXPORT [preparation; full_pipeline, analysis_only]: The first outreg2 export for each Table 4 outcome panel writes to table4_reg with replace (lines 129, 144, 159). Thus the OthersMoney panel resets the OwnMoney export and the RegulatoryAlignment panel resets the OthersMoney export; only the final panel remains at that shared output base.
- I_WEEKLY_PANEL_PRODUCER [unresolved; full_pipeline]: The published appendix reports an investment-salience time-series analysis at the university-group-week level but the supplied main Stata code ends with Bayesian Table 7 analyses and contains no weekly panel producer or appendix analysis entry point. The candidate participant workbook does not establish the required 94-observation group-week panel, weekly outcome construction, or reminder-event flags. The exact prepared input or author-provided producer contract is unresolved; do not derive it independently.
- I_APPENDIX_SUBGROUP_ANALYSIS [unresolved; full_pipeline]: The full target also includes the appendix analyses by university and the documented Income, NumberInvestments, and US-national subsamples. The supplied Stata program contains the main-table workflow but no corresponding appendix subgroup analysis entry point or output instructions. The appendix identifies the subgroup definitions and reports results, but the package does not supply an executable procedure for these branches. Obtain the author workflow/specification; do not invent or independently implement regression code. The weekly time-series data/producer gap is tracked separately.
- R_WEEKLY_PANEL [undetermined]: The full target includes the appendix investment-salience time-series branch. It requires an author-compatible university-by-treatment-group-week panel of 94 observations, with the weekly outcome TotalSpend (defined as OwnMoney at that aggregation level) and reminder overlap flags Salient_1week and Salient_2weeks. The package does not specify the input period, weekly source, reminder-date/event construction, or an executable panel producer. The supplied participant workbook is only a candidate because its probed participant fields do not verify the 94-row weekly aggregation or event flags.
- S_OUTREG2 [preparation_required]: Required by the supplied program to export Table 4 and Table 5 regression results. It was not found in the checked default or shared Stata ado paths; a repository package route is documented, but this audit did not install it.

## Review notes

- The frozen dependency checklist contains zero entries; manual inspection of actual Stata reads, generated variables, software calls, and output branches was still required. The main program has one blank top-level input statement and no additional file reads, merges, or raw-source acquisition commands.
- The supplied workbook probe read one row for metadata and found 276 unique Stata-valid raw headers; all 37 base fields directly consumed by the main code appear. The probe does not establish full row coverage or population fidelity.
- The data description documents Qualtrics surveys, manually coded paper-poll responses, and Starbucks purchase records as historical construction sources for the supplied final workbook. They are not treated as separate live execution inputs for the supplied analysis routes.
- Both the original and alternative Table 3 command sections execute in sequence; the cortesti call is inside a block comment and is not a required add-on.
- The only required nonbuilt-in Stata command identified for the primary program is outreg2. It is absent from the checked default/shared ado paths. Table 4 panel exports replace the same target at lines 129, 144, and 159; the proposal retargets all seven calls in each later outcome panel.
- The campaign full_pipeline includes the published exploratory appendix: both its 94-observation university-by-treatment-group-week time-series and its university-specific and Income/NumberInvestments/US-national subgroup analyses. The weekly input/producer contract and subgroup program/output instructions are not supplied; each remains a distinct full-scope issue. The analysis_only scope is limited to the supplied primary program and author-prepared workbook.
