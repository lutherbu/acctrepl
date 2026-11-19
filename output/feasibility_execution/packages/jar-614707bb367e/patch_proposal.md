# Patch proposal: jar-614707bb367e

Promote Internally or Hire Externally? The Role of Gift Exchange and Performance Measurement Precision

DOI: 10.1111/1475-679X.12475

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The full supplied author workflow includes the main Stata analysis do-file, a named Table 2 Panel B long-format ANOVA companion supplied in a commented note, and manual Excel construction for Figures 2 and 3. The main do-file assumes its own experiment dataset is already loaded in Stata memory, and the package does not include that dataset or an active main-data loader/preparation driver. The companion names a separate long-format .dta input and is retained in scope despite its comment status; its use, clear command requires an isolated Stata data state so later main-data analyses are not displaced. The Excel workbook, chart recipe, and mapping between two active Figure 3 result blocks and the plotted figure remain unresolved.

Entry points: `Online Suppplements - Do-file.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 2/12475 - Promote-Internally-or-Hire-Externally-The-Role-of-Gift-Exchange-and-Performance-Measurement-Precision/clm-datasheet-code-and-identifiers.zip",
      "sha256": "dffbc1e8d46a1d6b1722131b80da61854b3bcacf0a9f29820f4d9790829270d9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "8aef3953fb1d07d4e8a7a415ee1c3a3336b0d4a550372921f3e646178a0769b5"
}
```

## Proposed actions

### ACT_REQUEST_DATA_AND_LOADER: Request the exact author-prepared Stata input that the analysis file expects, plus its file format, required columns, and the supported loading/preparation steps that place it in memory. If those analysis variables are constructed from raw experiment exports, request the supplied author preparation code and its inputs rather than rebuilding them independently.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ_ANALYSIS_DATA, ISSUE_ANALYSIS_INPUT_CONTRACT
Evidence: ev_datasheet_run_instruction, ev_codebook_fields, ev_analysis_commands, ev_package_inventory, ev_workflow_trace

Preparation / proposed procedure:

1. Obtain the exact dataset or documented author-prepared equivalent used by the supplied analysis file.
2. Document the current file name and format, variable names/codes, and any author-supplied transformations needed before Stata runs the analysis file.
3. For a future authorized attempt, place a separate portable working copy of the author files and input in a clean execution directory, preserving the assigned generation and original package; use a coherent relative execution root.
4. Keep the historical Lioness/private-server collection description as provenance; do not assume that the server itself is a current execution dependency.

Validation to perform later:

- With a future authorized run, load the documented dataset and use Stata metadata inspection to confirm the required variables before running the supplied do-file.
- Compare generated Stata outputs with the supplied historical log only as a fidelity check; the log is not a substitute for current input data or current execution.

### ACT_DOCUMENT_EXCEL_FIGURES: Request the Figure 2 and Figure 3 Excel workbook or the author-prescribed chart recipe, including the Stata output-to-series mapping, axes, labels, and worksheet layout. In particular, ask which of the two active Figure 3 result blocks feeds the plotted figure; preserve both authored Stata blocks pending that mapping. Confirm the compatible Excel version for this manual stage.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISSUE_EXCEL_FIGURE_HANDOFF, SW_EXCEL
Evidence: ev_excel_figures, ev_figure3_margins_block, ev_workflow_trace

Preparation / proposed procedure:

1. Obtain the original figure workbook or written chart-construction steps from the authors.
2. Map the workbook inputs to the Figure 2 summaries and to the specific Figure 3 result block or blocks the authors used; do not substitute EarlyEffort for EarlyEffortT or change the authored filters.
3. Confirm an Excel runtime/version for the manual chart stage; do not assume another spreadsheet application is equivalent.

Validation to perform later:

- After a future authorized run, compare the reconstructed figures with the supplied author figure artifact or an author-provided specification.

### ACT_REQUEST_TABLE2_PB_INPUT: Request the author-named CLM EmpDataLongFormatTypes.dta input or its exact author-supplied producer/preparation procedure and source inputs. Also request definitions and the observation unit for effort, cond, id, period, tot_comp, and tot_ind, period coverage relevant to period < 4, and any documented relationship to the separate main analysis dataset. Do not infer a reshape or mapping from the main dataset.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ_TABLE2_PB_LONGDATA, ISSUE_TABLE2_PB_INPUT_CONTRACT
Evidence: ev_table2_commented_input, ev_package_inventory, ev_workflow_trace

Preparation / proposed procedure:

1. Obtain the exact author-named long-format file or author-provided preparation code with its documented inputs.
2. Obtain field definitions, unit of observation, and period coverage for the companion commands, plus any author-supported relationship to the main analysis dataset.
3. Keep the companion data requirement separate from the main in-memory dataset unless the authors provide a producer/mapping that supports a shared route.

Validation to perform later:

- Before a future authorized run, inspect Stata metadata for the six required field names and the documented period coverage without displaying participant identifiers or values.

### ACT_STAGE_TABLE2_PB_BRANCH: After the exact input or supported producer is supplied, stage it under a relative path in a separate portable working copy and activate the authored Table 2 Panel B note as a companion-only Stata driver. Retain its three ANOVA specifications and period < 4 filter in source order; adjust only the author-machine file location in that working copy. Run the companion in an isolated Stata data state so its use, clear statement cannot replace the main analysis dataset needed by later Table 3 and figure stages. No author file is edited in this assessment.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ_TABLE2_PB_LONGDATA, ISSUE_TABLE2_PB_INPUT_CONTRACT
Evidence: ev_table2_commented_input, ev_workflow_trace, ev_environment_stata

Preparation / proposed procedure:

1. Once the input/preparation contract is supplied, make a portable working copy outside the assigned generation and stage the exact file at a relative data path.
2. Create a companion-only driver in that working copy from the supplied commented note, preserving all three ANOVA commands and their source order while changing only the author-machine path to the staged relative path.
3. Run the companion in a separate Stata session/data state; retain the main do-file and its in-memory dataset for the active Table 3 onward and figure workflow.
4. Keep this branch's output separate unless an author-supplied handoff establishes that another stage consumes it.

Validation to perform later:

- After the input contract is supplied and a future run is authorized, confirm required variable names from Stata metadata before the companion analysis; do not print participant identifiers or raw values.


## Remaining issues and prerequisites

- ISSUE_ANALYSIS_INPUT_CONTRACT [unresolved; full_pipeline]: The active analysis file assumes a Stata dataset is already loaded in memory; it contains no active file-loading or variable-construction stage. The datasheet gives a generic raw-data placement instruction but no input filename, format, schema, or reproducible producer. The required current input is therefore unresolved even though its historical collection source and non-proprietary designation are documented.
- ISSUE_EXCEL_FIGURE_HANDOFF [unresolved; full_pipeline]: The Stata file supplies summary outputs for Figure 2 and two distinct active Figure 3 result blocks, then labels Figure 2 and the later Figure 3 margins as done in Excel. The earlier Figure 3 block uses a logit with EarlyEffortT and requests dydx(Precise) at values 5 through 100 within Choice==1; the later block uses EarlyEffort and requests margins by Precise at values 0 through 20 without that Choice filter. This release supplies no workbook or chart recipe mapping either result block to plotted series, axes, or labels. Both authored blocks are retained without selecting or changing one. The missing handoff prevents confirming reproduction of those figure stages but does not create a separate raw-data requirement.
- ISSUE_TABLE2_PB_INPUT_CONTRACT [unresolved; full_pipeline]: The supplied source note names CLM EmpDataLongFormatTypes.dta for a long-format Table 2 Panel B companion and its three ANOVA specifications consume effort, cond, id, period, tot_comp, and tot_ind for period < 4. The file, field definitions/coverage, and author-supported producer or mapping from the main in-memory dataset are not supplied. The branch is a comment in the main .do, so it requires working-copy activation after the input is established. Its use, clear statement replaces Stata memory; run it in a separate companion driver/session to preserve the main dataset. No access barrier is established.
- REQ_ANALYSIS_DATA [undetermined]: An author-prepared Stata dataset loaded in memory before the supplied analysis do-file runs. The active script assumes a variable-column analysis dataset with fields such as Choice, subjectnr, Precise, promote, effort measures, pay measures, and demographic/scale variables; it does not define how those fields are loaded or constructed. The exact file, format, field profile, and preparation chain are not specified.
- REQ_TABLE2_PB_LONGDATA [undetermined]: A separate author-named Stata long-format dataset for the Table 2 Panel B ANOVA companion. The source note names CLM EmpDataLongFormatTypes.dta and its commands consume effort, cond, id, period, tot_comp, and tot_ind for observations satisfying period < 4. These are command-consumer fields, not a verified file schema or variable-definition contract. The package supplies no matching data file, producer, mapping from the main in-memory dataset, or supported reshape; do not infer one.
- SW_EXCEL [unverified]: The author labels the Figure 2 and Figure 3 construction as done in Excel. Current Excel availability and version are not established by the supplied environment evidence; no application was launched.

## Review notes

- The datasheet title includes a leading 'External' that is absent from the frozen registered title; frozen metadata is retained, and the wording difference is recorded as context rather than an execution prerequisite.
- The archive inventory and hashes for 25 declared package/cache/catalog/frozen artifacts were checked; all declared hashes matched. The five archive members include no dataset or Excel workbook.
- The frozen checklist has zero dependency rows, but manual source tracing identifies the required main in-memory dataset, the separate named Table 2 Panel B long-format input, and the Excel figure handoff; an empty checklist is not treated as closure.
- The supplied Stata logs are historical artifacts. No log output is treated as current execution or as a supplied input dataset, and no participant-level values are quoted or displayed.
- A sanitized historical-log helper was first invoked with an incorrect second cached-text path; it failed with exit code 1 before that file could be read. Its captured stderr and empty stdout target are preserved under probes/ and are process history only. The corrected bounded command-token index is separately retained and is not used as proof of data availability or current execution.
- The process-history evidence rows ev_log_command_index_history, ev_process_helper_failure, ev_process_failure_preservation, ev_failed_draft_patch_process, and ev_failed_draft_patch_02_process are intentionally unused in every recursive evidence_ids list.
- No standard commercial accounting/financial product or current public data product is required by the supplied target workflow. Lioness is cited only as historical experiment infrastructure; no server/API or data payload was checked.
- Two attempted draft patches failed because their expected context did not match the current draft. Neither changed draft bytes; the exact patch inputs and tool diagnostics are preserved under probes/draft_update_failed*. The corrected update was applied separately.
- The source-QA correction retains the author-named Table 2 Panel B long-format ANOVA companion in the full target despite its commented status. Its separate file and preparation/mapping contract remain unresolved; its use, clear command is isolated in a future portable working copy so the main Stata dataset is preserved.
- A malformed apply_patch helper-construction request failed before writing a helper or changing the draft/trace. Its actual patch payload and diagnostic are preserved under probes/draft_update_table2_section1_failed.*; no process-history evidence IDs are used as scientific evidence.
