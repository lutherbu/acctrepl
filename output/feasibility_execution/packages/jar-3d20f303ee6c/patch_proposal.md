# Patch proposal: jar-3d20f303ee6c

Institutional Differences and International Private Debt Markets: A Test Using Mandatory IFRS Adoption

DOI: 10.1111/1475-679X.12111

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow for the article and supplementary analyses. The assigned package contains only a results appendix; no executable workflow or reproducible entry point is established.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 3/12111 - Institutional-Differences-and-International-Private-Debt-Markets-A-Test-Using-Mandatory-IFRS-Adoption/brown-online-appendix.pdf",
      "sha256": "20cd77622675fd662db2fe50ee0e69a68f246cbd0da86bf1456cc6c6214405af"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "9994ca34947b819972da9eb9c9867e9155182e27061e90bfc7c7cd29687625b0"
}
```

## Proposed actions

### A_request_author_workflow: Request a complete reproducibility release and clarification of the workflow intended for the article and supplementary appendix.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_missing_code, I_workflow_inputs_unknown
Evidence: E_appendix_scope, E_empirical_sample, E_variable_definitions, E_package_inventory

Preparation / proposed procedure:

1. Request the author-supplied executable programs or complete documented manual procedures for the article analyses and appendix tables, including the intended entry points and execution order.
2. Request the author-prepared analysis data or a precise input specification for every required file, including formats, fields, identifiers, sample years, coverage, and documented transformations; request the main manuscript Appendix A and data-description instructions that define the variables and workflow.
3. Ask the authors to map supplied programs and inputs to the reported primary analyses and appendix tables A1–A18, and identify required software, versions, and access conditions. Treat source names appearing in the appendix as leads until the workflow establishes their role.

Validation to perform later:

- After a response, confirm the supplied materials identify each runnable entry point or complete manual procedure, its required inputs and generated intermediates, and the output analyses it supports.
- Check that author-prepared data or verified source routes document the required fields, identifiers, and historical coverage before defining data requirements or any analysis-only scope.


## Remaining issues and prerequisites

- I_missing_code [blocking; full_pipeline]: No author program or runnable manual procedure is supplied. The only material file is a supplemental appendix reporting results, so there is no supplied executable route to reproduce the paper or appendix analyses.
- I_workflow_inputs_unknown [unresolved; full_pipeline]: The appendix reports empirical loan analyses but refers readers to the manuscript Appendix A for variable definitions and does not specify the complete source-to-analysis workflow, required input files, field mappings, identifiers, or coverage. Data are required for the empirical analyses, but the appendix-only release does not support separate mandatory raw-source requirements or a compatible analysis-only route.

## Review notes

- The appendix contains empirical regression results for loan contracts, so data are required. Its discussion of variables or source names is contextual because no author workflow or main-paper variable definitions were supplied; no raw-source requirements were inferred from those mentions.
