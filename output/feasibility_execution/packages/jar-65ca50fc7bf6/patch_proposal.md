# Patch proposal: jar-65ca50fc7bf6

Do Analyst Stock Recommendations Piggyback on Recent Corporate News? An Analysis of Regular-Hour and After-Hour Revisions

DOI: 10.1111/1475-679X.12083

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow for the paper and both supplied Online Appendix analyses; the imported package does not contain a runnable workflow.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 4/12083 - Do-Analyst-Stock-Recommendations-Piggyback-on-Recent-Corporate-News-An-Analysis-of-Regular-Hour-and-After-Hour/li_ramesh_shen_wu_online_appendix.pdf",
      "sha256": "f0fb375a2ca47a86c9484a1496784415b062bb15916f4f023dbf8cb11eee87f8"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "a03dbb8f4495b7b5c058ab99e6de76f2a32957344dfacbc7d907831d28594311"
}
```

## Proposed actions

### obtain_author_workflow: Request the missing author workflow and full input specification before assessing feasibility or attempting replication.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: analysis_inputs_unknown, author_code_missing, workflow_spec_missing
Evidence: package_inventory, static_audit_no_code, appendix_contents, appendix_data_context

Preparation / proposed procedure:

1. Obtain the complete author-provided replication materials for this package variant, including runnable programs, README or data description, supplied analysis data or documented authorized acquisition routes, and any execution logs.
2. Ask the authors to map all main-paper outputs and both appendix analyses (TRNA validity checks and intraday trading volume) to their entry points, then document each required input product, fields, identifiers, periods, transformation and preparation steps, generated files and producer order, software, and any data-sharing limits or approved alternatives.
3. Treat the appendix’s historical references to TRNA, Factiva, Compustat, First Call, I/B/E/S, and newswire services as context until the complete author workflow establishes which inputs are live requirements and provides compatible routes.

Validation to perform later:

- After the materials arrive, trace every entry point and branch to all documented paper and appendix outputs and account for each required input and intermediate.
- Use bounded metadata and software probes to check specified input formats, fields, periods, and runtimes; record unresolved access or coverage conditions.
- Only after workflow closure, schedule an authorized run using the author-prescribed command and compare outputs with the cited appendix tables; the current package provides no command to run.


## Remaining issues and prerequisites

- author_code_missing [blocking; full_pipeline]: The imported author package contains only the Online Appendix PDF. No runnable program or entry point is supplied, so the full author workflow cannot be attempted from this variant.
- workflow_spec_missing [unresolved; full_pipeline]: The appendix describes a news-coverage validity check and a separate intraday-volume analysis, but supplies no run instructions, program-to-output mapping, complete input definitions, preparation steps, generated intermediates, software requirements, or execution logs. Required inputs and dependency closure remain unknown; no analysis-only route is supported by the supplied materials.
- analysis_inputs_unknown [undetermined]: Data inputs for the main paper and both supplemental analyses (TRNA validity checks and intraday trading volume). The appendix names some historical source products, but the package does not specify the complete author workflow, supplied analysis data, exact fields and identifiers, full coverage, transformations, or acquisition routes.

## Review notes

- Assessment is limited to the imported package variant: its only material file is the Online Appendix PDF. The dependency checklist is empty, but that does not establish workflow closure because no author program or run specification is supplied.
- The complete target retains both appendix components. Historical source descriptions are not treated as verified local/public input routes, and no independent reconstruction or analysis-only bypass is proposed.
