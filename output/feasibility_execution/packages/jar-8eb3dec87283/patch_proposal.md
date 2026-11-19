# Patch proposal: jar-8eb3dec87283

Forced rating systems from employee and supervisor perspectives

DOI: 10.1111/1475-679X.12388

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Both supplied Stata branches are retained: the lab main experiment and the additional online experiment. Their programs are printed inside PDFs and are not directly executable until extracted and reflowed. Each analysis program directly consumes its own named author-prepared .dta. The datasheet's historical and manual data-preparation chains are traced as conditional context; historical collection is not assumed to require rebuilding raw data when a compatible prepared input is supplied.

Entry points: `Code Main Experiment Cardinaels and Feichter.pdf`, `Code Additional Online Experiment Cardinaels and Feichter.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 5/12388 - Forced-rating-systems-from-employee-and-supervisor-perspectives/cfdatasheetcodeandexperimentalmaterials.zip",
      "sha256": "d9585ba2a3d4cf6414887bbc537bf0c686ca89f84e88b928ede2993f8569d7ec"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "09f7d38107c004947b8b63041cd2474c740ceabe5ec1a2da82804502cba5f32b"
}
```

## Proposed actions

### extract_pdf_programs: Prepare separate faithful Stata working copies from the two PDF program containers, use relative branch-specific input paths, and preserve the printed historical table grammar with per-command version control.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: pdf_embedded_programs, legacy_table_syntax
Evidence: src_main_use, src_online_use, src_main_tables, src_online_table, pub_table_faq, pub_table16, pub_version_prefix

Preparation / proposed procedure:

1. Extract and reflow the main and additional-online program text from their respective PDFs into separate working copies, preserving command order, source variables, and all analyses.
2. From a common host-visible working root, stage the main input at `inputs/main/Final Dataset JAR.dta` and the online input at `inputs/online/Forced Ratings Prolific Employees JAR Final.dta`. In the respective working copies, replace only the printed Windows `use` paths with `use "inputs/main/Final Dataset JAR.dta", clear` and `use "inputs/online/Forced Ratings Prolific Employees JAR Final.dta", clear`.
3. Prefix `version 16:` to the three main-branch `table` calls and the online-branch `table` call. Do not add a file-wide version statement; this keeps the historical table syntax local to those commands.
4. Keep the two branch working copies and execution order separate; the lab and online files have different input schemas and must not be merged or substituted.

Validation to perform later:

- Before any separately authorized run, compare each extracted working copy against its complete PDF program and verify that its relative input path resolves to the matching author-prepared file.
- In a future authorized Stata run, confirm the version-16-prefixed table commands retain their reported summaries and verify both full branches from their own prepared inputs; no such study execution is established here.

### clarify_main_data: Obtain the author-prepared main-experiment analysis dataset or a documented compatible route and field/coverage contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data_main_final, main_data_route_unknown
Evidence: src_main_use, item_inventory, src_lab_prep, src_lab_readability, src_lab_final, src_main_fk_read, trace_author_workflow

Preparation / proposed procedure:

1. Request `Final Dataset JAR.dta` or the supported route to it, together with its observation unit, required source-field definitions, types, and coverage for the main experiment.
2. Confirm that the prepared main .dta includes FleschKincaid: the Table 4 regression consumes it directly, and the Stata analysis program does not generate it. The datasheet's R calculation is conditional upstream context if the final dataset must be rebuilt, not a separate mandatory AND source when the prepared .dta route supplies the field.
3. If a prepared final file is not available, request the exact .sbj/PEQ, rating, cortisol, and readability inputs plus their source schema, observation unit, and match keys. The datasheet's documented sequence is zTree/Excel combination, Stata export/matching, Dresden LabService cortisol matching, then the named R readability calculation matched into Stata; no standalone producer or complete handoff contract is included, so do not reconstruct it independently.

Validation to perform later:

- When supplied, use a bounded metadata/readability probe and compare its fields, including FleschKincaid, and key/period coverage with the exact variables consumed in the main PDF program.

### clarify_online_data: Obtain the author-prepared additional-online analysis dataset or a documented compatible route and field/coverage contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data_online_final, online_data_route_unknown
Evidence: src_online_use, item_inventory, src_online_prep, src_online_join, trace_author_workflow

Preparation / proposed procedure:

1. Request `Forced Ratings Prolific Employees JAR Final.dta` or the supported route to it, together with its observation unit, required source-field definitions, types, and coverage for the online experiment.
2. If a prepared final file is not available, request the exact Qualtrics/Excel exports and their schemas, person-specific identifier field, and merge contract for the supervisor and independent-rating data. The datasheet documents this order but does not supply a standalone producer or exact key name; do not reconstruct it independently.

Validation to perform later:

- When supplied, use a bounded metadata/readability probe and compare its fields with the variables consumed or generated in the additional-online PDF program.


## Remaining issues and prerequisites

- main_data_route_unknown [unresolved; full_pipeline]: The main branch names `Final Dataset JAR.dta`, but no matching data file, schema probe, or supported acquisition/author-prepared route is supplied. The input field and sample-coverage contract therefore remains unverified.
- online_data_route_unknown [unresolved; full_pipeline]: The additional-online branch names `Forced Ratings Prolific Employees JAR Final.dta`, but no matching data file, schema probe, or supported acquisition/author-prepared route is supplied. The input field and sample-coverage contract therefore remains unverified.
- pdf_embedded_programs [preparation; full_pipeline]: Both substantive Stata analysis programs are printed in PDFs rather than supplied as standalone `.do` files. They require faithful extraction/reflow into separate working copies and ordinary working-directory/path setup before an authorized run; this is a preparation step, not evidence that no code was supplied.
- legacy_table_syntax [preparation; full_pipeline]: The two PDFs contain four table calls using the historical contents()/c() syntax, while the available environment is Stata 18 and the program text has no version-control statement. StataCorp documents that table was redesigned in Stata 17 and that old behavior is preserved under version control; the Stata 16 manual documents the historical contents() grammar. A per-call version 16 prefix on the four table commands is a supported working-copy configuration to preserve that grammar; no whole-file version change is proposed.
- data_main_final [undetermined]: The main-experiment Stata branch directly opens the author-prepared `Final Dataset JAR.dta`. No compatible route, data file, or complete type/period contract is provided. The code consumes source fields Type, treatment, Period, Code, SessionID, Group, Rematching, Forced, Gender, TimeSpent, Stress1, Rating, Idea1, PSS1-PSS10, R1404, R1412, R1403, R1408, R1401, R1406, R1402, R1411, Cortisol1-Cortisol3, and FleschKincaid. The analysis code does not create FleschKincaid; the datasheet identifies an R readability calculation as its historical producer. TypeA, creativity, NoIdeaReceived, PSS, SupervisorID, CortEnd, and other analysis variables are generated by the Stata program. The datasheet describes manual upstream matches but does not supply input filenames, schemas, or exact join contracts; the prepared final dataset is the preferred input route if available, with FleschKincaid included in its field contract.
- data_online_final [undetermined]: The additional-online-experiment Stata branch directly opens the author-prepared `Forced Ratings Prolific Employees JAR Final.dta`. No compatible route, data file, or complete type/period contract is provided. The code consumes SC0, Process_9, Gender, R1/R3/R4/R5/R6/R8, Sliders, CreativeTask, ComputerMouse, Q49 (renamed to Internet), ForcedRating, Process_3-Process_5, StressEvaluation_2, and Engagement_1-Engagement_3. Attention, Creativity, Performance, PerformanceRank, Internet, and other analysis variables are generated or renamed by the program. `PerformanceR` references are case-matched prefixes of the generated `PerformanceRank`; no separate raw `PerformanceR` field is established. The unknown input schema must still be checked for a competing prefix before execution.

## Review notes

- The target retains both actual Stata branches in their separate PDF containers and their distinct prepared-data contracts. The package contains neither named .dta file nor a compatible acquisition route, so no analysis_only scope is justified. The Experimental Materials attachment is experimental instructions/survey material rather than another analysis driver.
- The static audit reports no supported code for this PDF-only package, but that parser result is superseded for code presence by direct reading of the embedded commands: both Stata program containers are substantive code and are retained as entry points.
- The datasheet's lab and online data-preparation chains are preserved in probes/author_workflow_trace.json, including the Stata, zTree/Excel, R, and Qualtrics/Excel handoffs. The main Stata program uses FleschKincaid directly without generating it, and the datasheet identifies R as its historical producer. When the prepared final .dta route is used, FleschKincaid is part of that file's required field contract and the R producer is not a separate mandatory AND input. If no prepared .dta route is available, exact raw schemas, producer sources, identifiers, and joins remain unresolved and must not be reconstructed independently.
- The online program first generates PerformanceRank and then uses PerformanceRa/PerformanceR. These are case-matched prefixes of the generated variable; no separate raw PerformanceR requirement is asserted. Because the input schema is absent, future metadata review should still check for a competing prefix.
- The per-command version 16 table configuration is supported by StataCorp's public FAQ and the Stata 16 table manual; the currently served version-prefix manual is for 19/19.5, and no inaccessible Stata 18 manual is claimed as reviewed. The saved environment probe establishes Stata 18 availability, not successful execution.
- A self-written Stata trial did run descriptive table calculations on four synthetic rows using source-derived table syntax. The coordinator determined this exceeded the authorized metadata/version/help-only software scope. The original do-file, request, log, streams, return code, and incident record are preserved under probes/incident_stata_table_trial.json; the synthetic output is excluded from compatibility, readiness, and scientific findings. No author program or study data was run, and root disposition/acceptance remains pending.
