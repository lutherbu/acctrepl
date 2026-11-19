# Patch proposal: jar-c253f25e7227

Social Comparison on Multiple Tasks - Sacrificing Overall Performance for Local Excellence?

DOI: 10.1111/1475-679X.12535

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied Stata workflow prepares a transaction and employee workfile, constructs an employee-week analysis panel and runs the documented treatment, robustness, power and survey analyses.

Entry points: `1_Transform Combined Data to Workfile Dataset.do`, `2_Analysis.do`, `3_Survey.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 4/12535 - Social-Comparison-on-Multiple-Tasks-Sacrificing-Overall-Performance-for-Local-Excellence/kmsv-datasheet-and-code.zip",
      "sha256": "6bf75874437d6afb7069edb743d6041fd8ac2cf41008b60b6e58f87c0be3d9bb"
    },
    {
      "path": "JAR-Volume 62/Issue 4/12535 - Social-Comparison-on-Multiple-Tasks-Sacrificing-Overall-Performance-for-Local-Excellence/kmsv-online-appendix.pdf",
      "sha256": "a62d7ea8689e860b07bae06812e493ce42e098bc573b28f6ea3739bee0150236"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "8f350180bf32774a6cce49b24fdadbcbda41525e0ce1961a8f1638a59d050040"
}
```

## Proposed actions

### A_ACCESS_DATA: Seek an authorized restricted route to the exact author-prepared study inputs. The datasheet rules out public sharing; it does not establish whether a secure author/company-controlled workspace or execution arrangement can be approved.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_TRANSACTIONS, R_STORES, R_PERSONNEL, R_DEPT_ASSIGN, R_PRIOR_TREATMENT, R_CURRENT_TREATMENT, R_APP_USAGE, R_WORKTIME, R_SURVEY, I_PRIVATE_INPUTS
Evidence: E_DOC_PRIVATE, E_DOC_SOURCES, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Ask the authors or company representative whether an approved secure environment can provide the exact named DTA inputs or run the supplied workflow without externally sharing employee or customer records.
2. Keep public release and controlled access as separate routes; if no permitted controlled route is available, retain the input as unresolved rather than reconstructing or substituting data.
3. Do not seek to retrieve proprietary records through Google Analytics or Qualtrics product pages; those pages document product functionality, not the authors’ study exports.

Validation to perform later:

- After authorized access, confirm each named input is the same source product and format consumed by the corresponding do-file.
- Record only permitted local access conditions and bounded metadata; do not redistribute restricted records.

### A_INPUT_CONTRACT: Obtain the missing data dictionaries and coverage descriptions for the nine exact DTA inputs. Keep the authored join definitions and derived variables intact while resolving source-column ownership, identifier units and period coverage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TRANSACTIONS, R_STORES, R_PERSONNEL, R_DEPT_ASSIGN, R_PRIOR_TREATMENT, R_CURRENT_TREATMENT, R_APP_USAGE, R_WORKTIME, R_SURVEY, I_INPUT_CONTRACT
Evidence: E_DOC_SOURCES, E_DOC_TXN_PERIOD, E_DOC_HR_PERIOD, E_DOC_GA_PERIOD, E_DOC_QUALTRIX, E_DOC_WORKTIME_REVISION, E_DOC_SURVEY_WINDOW, E_ANALYSIS_AGE_FIELDS, E_ANALYSIS_TENURE_FIELD, E_ANALYSIS_GENDER_FIELD, E_ANALYSIS_STORE_FIELDS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. For 220718 Combined Dataset.dta, map v1-v17 to the source fields the transformation expects and document its employee/store/date units and full required period.
2. For StoreData and personnel records, identify the fields supplied under idstore and IDEMPLSTNR, including where persnr, age, gender, tenure and the store attributes used in the analysis originate.
3. For department assignment and both treatment files, document the source columns and population for persnr/idstore and the required assignment variables without changing the supplied merges.
4. For app usage and work-time records, document employee/week keys, active, hours and absence fields, source periods, and the complete coverage needed by the authored panel.
5. For QuestShort.dta, map Qualtrics response identifiers, completion/treatment fields and all question columns to the variables named by 3_Survey.do, including numeric-versus-label coding.

Validation to perform later:

- After permission is established, use bounded DTA metadata/header probes to check the listed source columns, types and keys; do not use full-file row counts as a coverage proxy.
- Compare documented complete date and population coverage with the authored analysis windows and the survey's three-month recall period.
- Preserve merge m:1/m:m choices as written; resolve any actual key, field or coverage mismatch from the data dictionary and observed metadata rather than guessing replacements.

### A_STATA_ADDONS: Configure the eight Stata commands that the supplied source uses but the bounded software probes did not find: winsor2, asdoc, mrtab, stddiff, distinct, pc_simulate, xtqreg and ivreghdfe. Keep Stata 18 and resolve package dependencies through approved sources.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2, SW_ASDOC, SW_MRTAB, SW_STDDIFF, SW_DISTINCT, SW_PCSIM, SW_XTQREG, SW_IVREGHDFE
Evidence: E_SOFTWARE_ENV, E_SW_ASDOC, E_SW_MRTAB, E_SW_STDDIFF, E_SW_DISTINCT, E_SW_PC_SIMULATE, E_SW_XTQREG, E_SW_IVREGHDFE, E_CMD_WINSOR2, E_CMD_ASDOC_MRTAB, E_CMD_STDDIFF, E_CMD_DISTINCT, E_CMD_PCSIM, E_CMD_XTQREG, E_CMD_IVREGHDFE

Preparation / proposed procedure:

1. Install or enable each missing command in the Stata 18 adopath using an authorized package source; record package versions and required dependencies, especially for ivreghdfe.
2. Keep the already found reghdfe, esttab, eststo, unique and coefplot commands available in the same Stata environment.

Validation to perform later:

- Run only command lookup/version checks for the required add-ons and record the resolved paths and versions; do not use author data or execute the study programs during setup.

### A_RELATIVE_PATHS: In a disposable working copy, keep analysis outputs in one Analysen directory and make each panel read point back to the file produced in the project root. This preserves the authored analyses and all generated power-simulation handoffs.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_RELATIVE_PATHS
Evidence: E_ANALYSIS_READY_SAVE, E_ANALYSIS_READY_READ, E_RELATIVE_CDS, E_RELATIVE_CDS2, E_ANALYSIS_POWER_READ, E_RELATIVE_CDS3, E_ANALYSIS_MAIN_READ, E_WORKFLOW_TRACE

**Proposed edit:** `2_Analysis.do:341–341`
Source SHA-256: `739d3abd0a55380f96058eaa9ea4a0107bf645d0c85fa113d2d034a238a5de5a`

The panel is saved in the project root at line 335; line 341 runs after entering Analysen, so the relative parent path selects that same generated file.

Current text:
```
use "weekly_data_empl_exp2_win_MK.dta",clear
```

Proposed replacement:
```
use "../weekly_data_empl_exp2_win_MK.dta",clear
```

**Proposed edit:** `2_Analysis.do:463–463`
Source SHA-256: `739d3abd0a55380f96058eaa9ea4a0107bf645d0c85fa113d2d034a238a5de5a`

Stay in the already entered Analysen directory rather than creating a nested Analysen/Analysen directory.

Current text:
```
cd "Analysen"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `2_Analysis.do:464–464`
Source SHA-256: `739d3abd0a55380f96058eaa9ea4a0107bf645d0c85fa113d2d034a238a5de5a`

Read the same panel generated at line 335 from the parent project root after remaining in Analysen.

Current text:
```
use "weekly_data_empl_exp2_win_MK.dta",clear
```

Proposed replacement:
```
use "../weekly_data_empl_exp2_win_MK.dta",clear
```

**Proposed edit:** `2_Analysis.do:508–508`
Source SHA-256: `739d3abd0a55380f96058eaa9ea4a0107bf645d0c85fa113d2d034a238a5de5a`

Keep the main-results branch in the same Analysen output directory.

Current text:
```
cd "Analysen"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `2_Analysis.do:509–509`
Source SHA-256: `739d3abd0a55380f96058eaa9ea4a0107bf645d0c85fa113d2d034a238a5de5a`

Read the same panel generated at line 335 from the parent project root after remaining in Analysen.

Current text:
```
use "weekly_data_empl_exp2_win_MK.dta",clear
```

Proposed replacement:
```
use "../weekly_data_empl_exp2_win_MK.dta",clear
```

Preparation / proposed procedure:

1. Use a separate portable working copy, start both preparation do-files from its project root, and create the Analysen subdirectory before 2_Analysis.do reaches line 340.
2. Keep line 340's cd Analysen so result tables, graphs and power CSV/DTA intermediates are written to the intended output folder.
3. Apply the five exact path edits in this proposal to the working copy only; line 341, 464 and 509 then read the root-generated panel, while line 463 and 508 remain in Analysen.

Validation to perform later:

- In a future authorized run, confirm line 335 writes the analysis-ready panel in the project root and all three corrected reads resolve to that same file.
- Confirm all branches stay in the single Analysen directory and the pc_simulate CSV to imported DTA to append sequence remains intact.

### A_FULL_RUN: Run every supplied branch in order from a clean working copy after authorized inputs, the missing add-ons and the proposed path setup are available. The survey file is a separate input and branch.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_TRANSACTIONS, R_STORES, R_PERSONNEL, R_DEPT_ASSIGN, R_PRIOR_TREATMENT, R_CURRENT_TREATMENT, R_APP_USAGE, R_WORKTIME, R_SURVEY, I_PRIVATE_INPUTS, I_INPUT_CONTRACT, I_RELATIVE_PATHS
Evidence: E_WORKFLOW_TRACE, E_TRANSFORM_READ, E_TRANSFORM_OUTPUT, E_ANALYSIS_INPUTS, E_ANALYSIS_STAGES, E_ANALYSIS_STEP1_SAVE, E_ANALYSIS_READY_SAVE, E_SURVEY_INPUT, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Copy the three author do-files and required documentation into a portable working copy; place only authorized exact DTA inputs at their documented paths and keep the original generation/archive files untouched.
2. From the working-copy project root, run 1_Transform Combined Data to Workfile Dataset.do; it reads 220718 Combined Dataset.dta, STATA/StoreData.dta and personell records stata.dta, then produces 2200718 Workfile Dataset.dta.
3. From the same root, run the prepared 2_Analysis.do: it reads the generated workfile plus department assignment, prior and current treatment, app-usage and work-time inputs; it produces the collapsed weekly panel, STEP1 panel and analysis-ready panel before the analysis branches.
4. With the five path edits applied and Analysen present, keep all power, treatment, robustness, compliance, LATE and additional-analysis outputs in that one folder; pc_simulate produces CSVs that the supplied code converts to DTA and appends.
5. Run 3_Survey.do from a fresh Stata session whose working directory contains QuestShort.dta; it is a separate author-provided survey analysis, not an optional substitute for the transaction panel.

Validation to perform later:

- In a future authorized run, record the exact Stata invocation, working directory, return code and raw stdout/stderr; then verify every generated handoff exists before its consumer and each required analysis branch completes.
- Compare the produced analysis and survey outputs with the author-documented tables and figures; do not infer completion of any unprovided paper-wide estimator.


## Remaining issues and prerequisites

- I_PRIVATE_INPUTS [unresolved; full_pipeline]: None of the nine consumed DTA inputs appears in the frozen package inventory. The datasheet says proprietary data cannot be shared externally, which rules out a public release, but it does not establish whether authorized author/company-controlled access is available. No compatible local route or complete input coverage has been verified.
- I_RELATIVE_PATHS [preparation; full_pipeline]: 2_Analysis.do saves its prepared panel before entering Analysen, then issues repeated relative cd "Analysen" commands before reopening that panel. The straight-through producer/consumer paths therefore require reconciliation; preserve the ordered branches and identify a consistent working-directory setup or path correction.
- I_INPUT_CONTRACT [unresolved; full_pipeline]: The code names the input keys and many downstream variables, but no DTA schemas or data dictionary are supplied. The source does not establish which merged file supplies several store attributes and employee age, gender and tenure; input field mappings, key populations, and complete date coverage therefore remain unverified. Preserve the authored merge definitions and obtain authorized field/coverage documentation rather than reconstructing the study data.
- R_TRANSACTIONS [undetermined]: Author-prepared transaction input 220718 Combined Dataset.dta; the transform program expects source fields v1–v17 and derives transaction, employee, store, department and date/week fields.
- R_STORES [undetermined]: STATA/StoreData.dta, independently merged by idstore; downstream store attributes and experimental-store membership must match the supplied code.
- R_PERSONNEL [undetermined]: personell records stata.dta, independently merged m:m by IDEMPLSTNR; the record key, persnr and employee fields used downstream need to match the supplied code.
- R_DEPT_ASSIGN [undetermined]: departmentassignment.dta, merged by persnr; the analysis uses final_department and referencegroup.
- R_PRIOR_TREATMENT [undetermined]: treatmentassignment_priorexp.dta, merged by idstore and retained as the prior-experiment treatment.
- R_CURRENT_TREATMENT [undetermined]: treatmentassignment_exp_final.dta, merged by idstore and renamed to the current treatment variable.
- R_APP_USAGE [undetermined]: usage_rate til 07.07.22_collapsed.dta, merged by persnr and time; the analysis uses employee-week active usage.
- R_WORKTIME [undetermined]: 220715 Work Time Records Collapsed.dta, merged by persnr and time; the analysis uses work hours and absence status.
- R_SURVEY [undetermined]: QuestShort.dta, used by the independent survey analysis; treatment, completion, survey questions and survey identifiers must match the do-file.
- SW_WINSOR2 [preparation_required]: The environment probe did not find winsor2 in the checked Stata adopaths.
- SW_ASDOC [preparation_required]: The exact command lookup did not find asdoc in the checked Stata paths.
- SW_MRTAB [preparation_required]: The exact command lookup did not find mrtab in the checked Stata paths.
- SW_STDDIFF [preparation_required]: The exact command lookup did not find stddiff in the checked Stata paths.
- SW_DISTINCT [preparation_required]: The exact command lookup did not find distinct in the checked Stata paths.
- SW_PCSIM [preparation_required]: The exact command lookup did not find pc_simulate in the checked Stata paths.
- SW_XTQREG [preparation_required]: The exact command lookup did not find xtqreg in the checked Stata paths.
- SW_IVREGHDFE [preparation_required]: The exact command lookup did not find ivreghdfe in the checked Stata paths.

## Review notes

- The frozen title and the datasheet title describe the same paper; the dash punctuation differs typographically only.
- The only author-named external platforms are Google Analytics and Qualtrix/Qualtrics, used to produce author-specific data; their official product documentation and exact frozen-catalog names were checked. Those checks do not provide or verify the authors’ private exports.
- No author-stated data/code URL appears in the supplied datasheet or appendix; no data, archive, API or account payload was requested.
- The public-sharing barrier applies to public release only; authorized restricted access remains unverified.
- An early draft-construction helper had a quoting typo and failed before writing a draft. Its exact failed helper copy and the tool's merged diagnostic are retained in probes; the corrected writer produced the populated checkpoint.
- The byte-first reader recorded one candidate at 2_Analysis.do line 462 by line hash only and redacted the whole statement; no candidate text was displayed or used as scientific evidence.
- The first finalizer construction attempt reported that E_DOC_SURVEY_WINDOW's quote crossed its cited source line; the captured controller run and raw stderr are retained in probes, and the quote now matches cached line 125 exactly.
- This clean submission corrects the transaction input contract to v1-v17 and omits optional scalar Q13 from the survey contract; Q13_12, Q13_13 and Q13_14 remain represented as fields.
