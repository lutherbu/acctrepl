# Patch proposal: jar-e7f70068b051

The Role of the Observed Punishment in Deterring the Spillover Effects of Corporate Misconduct Among Non-Peers

DOI: 10.1111/1475-679X.70002

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow for Experiments 1 and 2, with their separate Stata entry files, inputs, data preparation, and tabulated analyses.

Entry points: `05 Exp1DoFile_Tabulated.do`, `07 Exp2DoFile_Tabulated.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70002 - The-Role-of-the-Observed-Punishment-in-Deterring-the-Spillover-Effects-of-Corporate-Misconduct-Among-Non-Peers/hmrs-datasheet-code-and-log-files.zip",
      "sha256": "f47c94d931dfb4f77bb753e91389db1d7869fed118b05615090a5e2b7faac19a"
    },
    {
      "path": "JAR-Volume 64/Issue 1/70002 - The-Role-of-the-Observed-Punishment-in-Deterring-the-Spillover-Effects-of-Corporate-Misconduct-Among-Non-Peers/hmrs-online-appendix.pdf",
      "sha256": "b870326f38f47d546819f16e4827f9c7898cf458f4cb3fdaa20ba8e003918963"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "8a7670eed539b55e98e1669dc4cd3a9938108a584903ace2cc1d31a763989a6d"
}
```

## Proposed actions

### A_INPUTS: Obtain a complete compatible author-data bundle and field/merge-key documentation for the five code-consumed files; confirm the Experiment 2 correction route as part of the adjusted-workbook input.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_E1_MAIN, R_E1_INITIAL, R_E1_DEMOGRAPHICS, R_E2_MAIN, R_E2_INITIAL, I_INPUTS, I_E2_MANUAL
Evidence: E_DOC_INPUTS, E_DOC_MANUAL, E_E1_MAIN, E_E1_INITIAL, E_E1_DEMOGRAPHICS, E_E2_MAIN, E_E2_INITIAL, E_WORK_ITEM, E_DOC_DATES, E_DOC_SAMPLE_FLOW, E_E1_FILTER_FLAGS, E_E1_FILTER_DROPS, E_E2_FILTER_PAY, E_E2_FILTER_TIMER, E_E2_FILTER_DURATION, E_E2_FILTER_DROPS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request the Experiment 1 main-study workbook, initial-survey file, and Prolific demographic export, or compatible author-prepared equivalents covering the same participant-level data and fields.
2. Request the Experiment 2 adjusted main-study workbook and initial-survey file. If the adjusted workbook is not available, request the original main-study export together with the MTurk payment-code/approval data and the exact documented correction procedure.
3. Obtain a data dictionary that identifies the key/field ownership across files, sheet names, participant/period structure, exclusion variables, and the corrected Experiment 2 row without repeating participant identifiers in the assessment.
4. Stage files in an isolated portable project copy; preserve the source package unchanged.

Validation to perform later:

- Use only bounded metadata checks on delivered workbooks and DTA files to confirm readability, sheets, keys, and required fields before a separately authorized execution.
- Compare supplied file roles and participant/period coverage with the two source programs and the datasheet; do not infer missing access from the frozen-catalog miss.

### A_PATH: Configure a disposable working copy with relative paths while keeping the two experiment folders distinct; do not republish the author-specific directory strings in a proposed exact edit.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_SETUP
Evidence: E_E1_MAIN, E_E1_INITIAL, E_E1_DEMOGRAPHICS, E_E2_MAIN, E_E2_INITIAL

Preparation / proposed procedure:

1. Create a writable portable copy of the two do-files and keep the original package files unchanged.
2. Place Experiment 1 and Experiment 2 inputs under distinct relative subdirectories and update every affected import/merge path in the working copy consistently, preserving file basenames, sheet names, merge keys, sample rules, and calculations.
3. Run the Stata host wrapper in batch mode from a documented relative working directory; keep logs and outputs outside the preserved source package.

Validation to perform later:

- Before a separately authorized run, check that each referenced input resolves under the configured relative root and that the output/log directory is writable.

### A_RUN: Run the two independent supplied Stata entry files after their respective inputs and path configuration are ready; retain the author sequence and do not add a cross-experiment handoff.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_E1_MAIN, R_E1_INITIAL, R_E1_DEMOGRAPHICS, R_E2_MAIN, R_E2_INITIAL, SW_STATA, I_PATH_SETUP, I_E2_MANUAL
Evidence: E_E1_MAIN, E_E1_ANALYSIS, E_E1_MEDIATION, E_E2_MAIN, E_E2_ANALYSIS, E_STATA_PROBE, E_E1_ULMAX, E_STATA_TOBIT_DOC, E_E1_FILTER_FLAGS, E_E1_FILTER_DROPS, E_E2_FILTER_PAY, E_E2_FILTER_TIMER, E_E2_FILTER_DURATION, E_E2_FILTER_DROPS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. In the portable working copy, run 05 Exp1DoFile_Tabulated.do in Stata batch mode after staging the three Experiment 1 source files.
2. Run 07 Exp2DoFile_Tabulated.do independently after staging the two code-consumed Experiment 2 files and, if reconstructing the adjusted workbook, completing the documented manual correction first.
3. Keep experiment-specific outputs and logs separate; the supplied do-files build their analysis data in memory and run their own analyses.

Validation to perform later:

- After a separately authorized run, compare the produced sample/variable summaries and table analyses with the manuscript and author documentation; do not treat the bundled SMCL logs as a new environment execution.


## Remaining issues and prerequisites

- I_INPUTS [unresolved; full_pipeline]: The assigned archive contains code, logs, the datasheet, and the appendix, but no raw XLSX/DTA source inputs. The datasheet specifies three raw files per experiment. The supplied Experiment 1 do-file directly imports/merges the main workbook, initial-survey file, and Prolific demographics file. The Experiment 2 do-file imports the adjusted main workbook and merges the initial-survey file; the separately listed payment-code/approval file is described as feeding the upstream manual ID correction and is not imported by the supplied Experiment 2 do-file. Complete input schemas and coverage remain unverified. The author-data routes are unverified; no explicit access barrier is evidenced.
- I_E2_MANUAL [unresolved; full_pipeline]: The datasheet records a manual correction before the Experiment 2 Stata run, while the code consumes an adjusted workbook and does not include the crosswalk step. Clarify whether the supplied adjusted workbook already embodies that correction or provide the source/crosswalk and exact correction procedure. This is a preparation/contract gap, not evidence of a restricted license or access barrier.
- I_PATH_SETUP [preparation; full_pipeline]: The two Stata files refer to inputs under author-specific Windows directory roots. A portable working copy needs one coherent relative input root across each producer/consumer call; the directory components are omitted from quoted evidence.
- R_E1_MAIN [undetermined]: Experiment 1 main-study response workbook used by the supplied Stata do-file. The do-file uses PROLIFIC_PID, Condition, duration, and repeated-period report/performance/questionnaire fields after import and merges; exact field ownership across the workbook and merged sources, and the complete schemas, remain unverified.
- R_E1_INITIAL [undetermined]: Experiment 1 initial-survey input merged with the main-study data on PROLIFIC_PID. The code uses baseline age, sex, education, experience and questionnaire fields across merged sources, but exact source-column ownership is not established without the files.
- R_E1_DEMOGRAPHICS [undetermined]: Experiment 1 Prolific demographic export merged on PROLIFIC_PID. The code references Age and Sex for comparison and filtering; exact input fields and values must be confirmed against the absent file.
- R_E2_MAIN [undetermined]: Experiment 2 corrected main-study response workbook consumed by the supplied do-file. The code uses MTURK_ID, Pay, Condition, timer/duration, and repeated-period report/performance/questionnaire fields after import and merge; exact field ownership across the corrected workbook and merged initial-survey source, and the complete schemas, remain unverified. Confirm whether the documented manual ID correction is already reflected.
- R_E2_INITIAL [undetermined]: Experiment 2 initial-survey input merged with the main-study data on MTURK_ID. The file and its complete field schema are not included or probed.

## Review notes

- The first populated checkpoint was saved after bounded environment metadata and named survey-platform catalog queries, then source review continued. This records the actual sequence and makes no claim of platform entitlement or input coverage.
- The source archive's five members are the two do-files, two SMCL logs, and datasheet; the appendix is separately supplied. No XLSX/DTA source data are included. The SMCL files remain opaque and are not supporting evidence.
- No analysis_only scope is included: the assigned package has no prepared analysis dataset or supported bypass around the missing author inputs.
- Experiment 2's adjusted workbook and the raw-main-plus-payment-crosswalk reconstruction are alternative routes to the same corrected workbook input; do not make both routes mandatory when the adjusted workbook is supplied.
- The appendix discusses a supplementary Experiment 2 mediation analysis that is not present in the supplied Experiment 2 do-file; it is retained as publication context outside the supplied-workflow target, not a mandatory stage added to this scope. The contextual appendix evidence is E_APPENDIX_CONTEXT.
- The frozen catalog query for the named recruitment/survey platforms returned zero matching catalog records. That metadata miss does not establish absence, entitlement, or a restricted-access barrier.
- E_READER_PROCESS is a process-only artifact and is intentionally unused in every recursive evidence_ids list. Earlier reader fixtures and the value-free method note are preserved under probes/.
- The final checkpoint incorporates the assigned source set, dependency trace, and input-contract review; unresolved data and manual-preparation gaps are preserved.
- The official Stata Tobit manual documents observation-specific censoring limits, so the supplied ul(Max) call is not treated as a syntax blocker; no runtime trial was performed.
- Expected survey dates and participant counts are recorded from the datasheet as acquisition/coverage checks; no endpoint or byte-identity requirement is imposed and no sampled coverage is claimed.
- The failed attempt to open a Stata 18 manual URL is preserved in an unused inspection artifact; the successful official manual record supports only the variable-limit syntax check.
- Workflow trace in probes/workflow_trace.json covers both supplied experiments, all frozen dependency IDs, additional merge inputs, the E2 manual correction route, and the in-memory endpoints.
