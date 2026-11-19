# Patch proposal: jar-996050ae2044

Public Information, Relative Overconfidence, and Capital Flows

DOI: 10.1111/1475-679X.70031

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The full release includes the Stata archival-data construction and table-analysis programs and a separate Qualtrics-to-JMP experiment-analysis path. All author-documented branches are retained. Required horse-racing and experiment datasets are not listed in the package inventory; source readability and the exact producer/consumer order remain unresolved. No separately executable analysis-only route is established.

Entry points: `Racing code and log files/_JAR Stata code start data.do`, `Racing code and log files/_JAR Stata code main data.do`, `Racing code and log files/_JAR Stata code Beyer data.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 4/70031 - Public-Information-Relative-Overconfidence-and-Capital-Flows/bbrsdatasheetcodeidentifierandlogfiles.zip",
      "sha256": "ad4f4d53db1629b7a56b54e49f216d6c811586c4b93931e7ea399a05bc105c1d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "3ad16e93effd0e367b40102bc33bf2c3c6774137f73328dd7ad68a27c661ff52"
}
```

## Proposed actions

### act_trackmaster_acquisition: Confirm and acquire the authors’ historical TrackMaster Race and Start files as separate required inputs, with their native specifications.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_trackmaster_race, req_trackmaster_start
Evidence: ev_trackmaster_docs, ev_beyer_table, ev_trackmaster_public, ev_catalog_lookup_review

Preparation / proposed procedure:

1. Confirm with the authors or TrackMaster whether the 1991–1995 Race and Start files are still available or obtain the exact retained author files; the current Past Performances page does not establish this historical product route.
2. Obtain the native file formats, data dictionary, field names, race/date/horse identifiers, coverage bounds and the documented relationship between Race and Start records.
3. Keep Race and Start as separate inputs and stage them in the author workflow’s expected layout after the readable Stata source reveals exact paths and imports.

Validation to perform later:

- Use bounded metadata inspection to compare each native file’s fields to the actual Stata reads once the source is readable.
- Confirm the required 1991–1995 coverage and the race/start key mapping from source metadata and author documentation; do not infer historical coverage from the product page alone.

### act_microfiche_and_wps_access: Obtain the authors’ converted microfiche results and WPS handle extraction with source-page and exception documentation, or verify an equivalent library/archive route field by field.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_microfiche_wps
Evidence: ev_microfiche_docs, ev_wps_docs, ev_keeneland_public, ev_drf_archive_public, ev_drf_charts_public, ev_catalog_lookup_review

Preparation / proposed procedure:

1. Request the 1991–1995 scans or author-prepared results, the extracted WPS handle data, the complete list of years/pages with exceptions, and the extraction notes used for both PDF batches.
2. If author copies are unavailable, ask Keeneland Library or the DRF archive to confirm exact issue-level coverage and the lawful research/copy route for the needed race-result pages and WPS measure.
3. Obtain the actual WPS variable meaning, units, race/date/track key and transformation into the Stata input; keep the chart source and derived handle table separate until the code confirms the join.

Validation to perform later:

- Check issue/page coverage and the author’s exception map against the requested 1991–1995 interval.
- Compare the WPS data fields and identifiers with the actual Stata source reads; inspect only a bounded header/sample after an allowed data copy is supplied.
- Verify that each WPS value is linked to the intended race and that no missing years or pages are silently treated as complete.

### act_beyer_data_access: Request the authors’ hand-collected Beyer figures and their Table 6 field/race specification; compare the current DRF report only as an unverified alternative.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_beyer_figures
Evidence: ev_beyer_docs, ev_beyer_table, ev_drf_beyer_public, ev_catalog_lookup_review

Preparation / proposed procedure:

1. Ask the authors for their transcribed Beyer dataset, codebook, race-year range, horse/race identifiers and any adjustments made when values were taken from print DRF copies.
2. Determine whether the DRF Lifetime Beyer Figures Report (1992 onward) covers the same horses, race dates and figure version needed by Table 6; do not use it as a substitute until those contracts match.
3. If the target period includes years not covered by the current report, retain the paper-copy or author-prepared source route for those years rather than dropping observations.

Validation to perform later:

- Confirm native fields, race dates, horse identifiers and figure definitions against the readable Stata consumer and author specification.
- Check period coverage and duplicate/missing horse-race records before using the file in Table 6; compare the final prepared sample with author logs once readable.

### act_qualtrics_export_access: Request a de-identified Qualtrics export or the exact author-prepared experimental analysis file, with its codebook and participant-round map.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_experiment_qualtrics
Evidence: ev_qualtrics_docs, ev_experiment_adjustments, ev_experiment_n, ev_package_inventory

Preparation / proposed procedure:

1. Request the raw response export or exact prepared analysis workbook, the survey instrument/online appendix, field labels and a de-identified mapping needed to apply the four documented manual adjustments.
2. Ask the authors to identify the two reset-only records, the duplicate response retained/removed, the participant-ID recoding, and how Qualtrics response columns map to participant-round observations.
3. Preserve the delivered file and codebook separately from the cleaned analysis file; no current data access restriction is documented.

Validation to perform later:

- Confirm the raw and final response counts against the author statement (127 initial, 124 reported after adjustments).
- Verify the four documented changes on a copy of the supplied export and confirm one row per intended participant-round in the stacked file.
- Compare the prepared fields with the registered JMP analysis source once that source is made reviewable.

### act_qualtrics_prepare: Reproduce the documented experimental response corrections and participant-round reshape in a traceable working copy after the source export and fields are supplied.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_experiment_qualtrics
Evidence: ev_experiment_adjustments, ev_experiment_n, ev_experiment_stack

Preparation / proposed procedure:

1. Implement the four author-documented corrections on a copy of the supplied Qualtrics export, retaining an audit table of excluded, retained and recoded records.
2. Reshape the analysis data so each participant-round is a separate observation, as described for JMP random-effects analysis.
3. Keep the original response export, corrected participant-level data and stacked analysis file as distinct artifacts with a short field mapping.

Validation to perform later:

- Reconcile the cleaned participant count to N=124 and verify all four corrections against the source record map.
- Check uniqueness of the participant-round key, round labels and nonmissing analysis fields against the codebook and readable JMP source.
- Compare the resulting JMP estimates/table output only in a future authorized execution; do not infer them from the logs.

### act_restore_readable_workflow: Obtain a reviewable representation of the supplied Stata and JMP code and close the actual input/output dependency and execution-order map.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss_stata_source_view, iss_jmp_source_registration, iss_dependency_closure
Evidence: ev_stata_workflow_docs, ev_jmp_workflow_docs, ev_package_inventory

Preparation / proposed procedure:

1. Request readable copies or a reviewer-approved source view for the three registered Stata .do files; do not bypass the approved viewer or decode the NUL-filled capture.
2. Have Experiment_DataAnalysisLog.jsl registered as a readable source and request text-readable Stata/JMP logs where needed; retain each original package path and hash.
3. Trace every actual import/use/read, save/export/write, include and software/add-on call. Map the archival Stata producers and consumers separately from the experiment branch: Qualtrics Excel export, documented manual adjustments, participant-round reshape and JMP analysis. Record only edges shown by the readable sources.
4. Use the resulting source facts to complete dependency_review with the real mandatory, generated, optional and software dispositions; do not convert the empty parser checklist into an absence claim.

Validation to perform later:

- Verify that every actual source read has a requirement or a supported generated/optional disposition, and every generated record cites its direct writer source.
- Confirm that each producer runs before its first consumer and that no unregistered file is used as an entry_point.
- Reconcile source inputs and output locations against readable logs or an author-provided run manifest without running author code during this assessment.

### act_jmp_setup: Verify and provision a compatible JMP environment for the documented experimental analysis; availability and version are currently unverified.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_jmp
Evidence: ev_jmp_workflow_docs

Preparation / proposed procedure:

1. Confirm the JMP version used by the authors and whether that version can read the supplied experimental workbook and run the registered JSL source.
2. If no compatible environment is present, arrange an authorized JMP installation or a compatible environment through the organization’s normal software process; no license or access barrier is inferred here.

Validation to perform later:

- Record successful availability under the exact software key JMP and capture its version in the future environment record.
- After inputs and code are ready, validate the JMP import/analysis workflow in a separately authorized execution and confirm the expected experimental model outputs.

### act_author_run_procedure: After the data, readable source, exact dependencies and runtime checks are complete, run the full author workflow while preserving the separate archival and experiment branches.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: iss_dependency_closure, iss_stata_source_view, iss_jmp_source_registration, sw_stata, sw_jmp
Evidence: ev_stata_workflow_docs, ev_jmp_workflow_docs, ev_environment_stata, ev_experiment_stack

Preparation / proposed procedure:

1. Use the readable sources to determine the precise order for the three Stata entry points from actual writers and first consumers; do not infer order from filenames alone.
2. Run the Stata data-construction and table-analysis branch with the separately supplied TrackMaster, microfiche/WPS and Beyer inputs after their schemas and period contracts match.
3. On the experiment branch, apply the documented response adjustments, create the participant-round stack and run the registered JSL in the verified JMP environment.
4. Capture run logs, input hashes, output files and software versions for both branches; do not treat the supplied historical logs as proof of a new execution.

Validation to perform later:

- Confirm each input was available before its first consumer and each generated file was written before use.
- Reconcile the experimental final sample to N=124 and compare study outputs to the author-reported tables and results after code and data contracts are resolved.
- Check that the Stata output covers the stated Tables 1–7 and Table 6 Beyer branch, and that all required logs are present.


## Remaining issues and prerequisites

- iss_stata_source_view [unresolved; full_pipeline]: The datasheet identifies three Stata .do files as data-construction and analysis programs, and the package inventory includes them. The approved source viewer returns each registered .do as one physical NUL-filled row with no readable statements. Actual reads, writes, order, output files and add-on calls cannot be traced; this is a viewer/source coverage limit, not evidence that the files contain no workflow.
- iss_jmp_source_registration [unresolved; full_pipeline]: The datasheet identifies Experiment_DataAnalysisLog.jsl as the JMP analysis source, and the package inventory lists that file, but it is not among work_item.sources. It therefore cannot be used as an entry_point or read through the approved registered-source interface in this assessment.
- iss_dependency_closure [unresolved; full_pipeline]: The parsed dependency checklist is empty, but the Stata sources are unreadable and the experimental JSL is unregistered. Those conditions leave actual raw reads, generated intermediates, software calls and the branch-specific producer/consumer order unresolved; dependency closure is incomplete.
- req_trackmaster_race [undetermined]: TrackMaster Race file(s) containing the authors’ 1991–1995 racing results input. The datasheet says TrackMaster race and start inputs were used for Tables 1–7; actual consumed fields, identifiers, file format and transformations cannot be traced until the Stata sources are readable.
- req_trackmaster_start [undetermined]: TrackMaster Start file(s) containing the authors’ 1991–1995 racing results input, required alongside Race files. Exact native fields, identifiers, format and how the two products are joined are unknown while the Stata sources remain unreadable.
- req_microfiche_wps [undetermined]: Converted 1991–1995 racing-result microfiche and the WPS betting-handle values extracted from the PDFs, with the authors’ noted source exceptions. The exact field names, coverage exceptions, key mapping and whether the consumer uses other chart fields are unknown.
- req_beyer_figures [undetermined]: The author-collected Beyer Speed Figure data used in Table 6, transcribed from paper Daily Racing Form copies. The datasheet gives collection dates but the exact horse/race period, row keys, figure fields and any corrections cannot be traced from the unreadable code.
- req_experiment_qualtrics [undetermined]: The experiment’s Qualtrics response export or author-prepared analysis data and codebook. The datasheet describes 127 initial responses, four manual adjustments yielding N=124, and conversion to stacked participant-round rows for JMP; no response data are listed in the package inventory.
- sw_jmp [unverified]: The author uses JMP for the experimental-data analysis, but no successful JMP availability/version proof is present in the registered software evidence. Its availability is unverified, not confirmed unavailable.

## Review notes

- The approved source-view interface returned the entire BBRS datasheet as 140 readable lines. For each of the three registered .do sources it returned one physical row composed of NUL codepoints, with no masks and no readable Stata statements. The four registered execution-log PDFs have zero cached text lines. These are source-view coverage limits; no raw-source, cache or log fallback was used.
- The frozen dependency checklist contains zero parsed IDs. It is treated only as a discovery checklist result, not proof that there are no actual dependencies. The Stata source views and JMP source-registration gap leave closure incomplete; dependency_review is empty because there are no frozen dependency IDs to disposition.
- The work-item package inventory lists the three Stata .do files, four log PDFs, the datasheet and Experiment_DataAnalysisLog.jsl (inventory kind “other”); it lists no data files. The JSL path is not a registered text source, so it is intentionally excluded from entry_points and no JSL statements are inferred.
- Required local catalog checks were performed using exact terms Trackmaster, Equibase, Beyer, Daily Racing Form and WPS; all returned zero entries. Short queries Race, Start and DRF returned only unrelated bond, legal, BoardEx or CRSP records. The unchanged list outputs and their object wrappers are preserved in the generation catalog_search_review artifact. Catalog misses are not treated as data unavailability or a license barrier; no irrelevant file was probed.
- The official TrackMaster Past Performances page search result mentioned EXE/XML formats, but direct page access returned HTTP 403; no current 1991–1995 Race/Start file contract was confirmed. Keeneland/DRF and official Beyer pages were checked for static product documentation only; none establishes WPS-handle schema, exact author extract coverage or equivalence to the unreadable code.
