# Patch proposal: jar-180549c186c0

Trust and Financial Reporting Quality

DOI: 10.1111/1475-679X.12063

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Produce all 13 Internet Appendix tables supplied in the document. The appendix reports supplementary regression results and variable definitions, but the package provides no executable workflow, analysis files, or complete input lineage.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 52/Issue 5/12063 - Trust-and-Financial-Reporting-Quality/hoitash-appendix.pdf",
      "sha256": "662a324112b46276a7fefd706463a6889236adb62466a43a988a45fb9e9f6197"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "f2a41693868a97415f8c7cee0abb2f3631a9d073e9ea263bc5d54586e5f632c5"
}
```

## Proposed actions

### request_workflow: Request the author workflow and compatible data materials needed to regenerate all 13 Internet Appendix tables; do not infer or independently reconstruct historical inputs from the variable definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: analysis_inputs, missing_code
Evidence: first_stage, last_table, package_inventory

Preparation / proposed procedure:

1. Obtain the author-provided executable workflow or an explicitly approved alternative, including entry points, required stage order, and software/runtime requirements for every supplied appendix table.
2. Obtain compatible author-prepared analysis data or a complete input inventory and documented acquisition/build instructions that identify files, fields, identifiers, periods, formats, and generated intermediates.
3. Ask the author to identify any survey, analysis, or other supporting files and programs required to construct the inputs used in the 13 tables.

Validation to perform later:

- After receipt, verify that every supplied appendix table has a documented producer and that each required input has specified fields and compatible coverage.
- Run the complete supplied workflow and compare generated tables with the appendix only under a separately authorized execution step.


## Remaining issues and prerequisites

- missing_code [unresolved; full_pipeline]: The assigned package contains only an online appendix PDF with reported results and variable definitions. No runnable author code, entry point, run instructions, or producer map is supplied; the actual workflow and full dependency closure remain unknown.
- analysis_inputs [undetermined]: Author-provided analysis data and any upstream inputs needed to reproduce all 13 Internet Appendix tables are required; the document describes supplementary regression analyses, including first-stage 2SLS models, but does not supply compatible input files, complete field/identifier/coverage specifications, or a build workflow.

## Review notes

- No analysis_only scope is supported because the assigned package contains neither runnable analysis code nor author-prepared analysis data.
