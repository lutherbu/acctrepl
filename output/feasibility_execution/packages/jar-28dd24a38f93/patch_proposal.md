# Patch proposal: jar-28dd24a38f93

Audit Term Tenure, Non-Audit Services and Internal Investments on Audit Quality

DOI: 10.1111/1475-679X.12078

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow for the paper and supplied supplemental appendix; the imported package does not contain a runnable workflow.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 3/12078 - Audit-Term-Tenure-Non-Audit-Services-and-Internal-Investments-on-Audit-Quality/knechel-online-appendix.pdf",
      "sha256": "b0f5ad42e90370182ff4debaacfe660b4e9ce37af272b3feb6d0ef6c589023e2"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "4fefce17406800d9a2b17e6b8afd2a00059c94bac138b04e0ed8785a4f283994"
}
```

## Proposed actions

### obtain_author_workflow: Request the missing author workflow and input specification before assessing feasibility or attempting replication.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: analysis_inputs_unknown, author_code_missing, workflow_spec_missing
Evidence: package_inventory, static_audit_no_code, appendix_empirical_output

Preparation / proposed procedure:

1. Obtain the complete author-provided replication materials for this package variant, including runnable programs, README or data description, supplied analysis data or documented authorized acquisition routes, and any execution logs.
2. Ask the authors to map each paper and appendix output to its entry point and document required input products, fields, identifiers, periods, transformations, manual preparation, generated files and producer order, software, and any data-sharing limits or approved alternatives.
3. If the authors identify an approved replacement or a prebuilt analysis-data route, document its exact scope and limitations separately; the appendix tables alone do not establish a runnable analysis-only route.

Validation to perform later:

- After the materials arrive, trace all entry points and branches to the documented outputs and account for every required input and intermediate.
- Use bounded metadata and software probes to check the specified input formats, fields, periods, and runtimes; record unresolved access or coverage conditions.
- Only after workflow closure, schedule an authorized run using the author-prescribed command and compare produced outputs with the cited appendix tables; the current package provides no command to run.


## Remaining issues and prerequisites

- author_code_missing [blocking; full_pipeline]: The imported author package contains only the online appendix PDF. No runnable program or entry point is supplied, so the full author workflow cannot be attempted from this variant.
- workflow_spec_missing [unresolved; full_pipeline]: The appendix reports supplemental empirical results but provides no run instructions, program-to-output mapping, full data and variable specifications, preparation steps, generated intermediates, software requirements, or logs. Required inputs and dependency closure therefore remain unknown; no analysis-only route is supported by the supplied materials.
- analysis_inputs_unknown [undetermined]: Data inputs for reproducing the paper and supplemental empirical analyses. The supplied appendix reports regression results, but this package does not specify the author workflow, exact input products, fields, identifiers, date coverage, transformations, or acquisition routes.

## Review notes

- Assessment is limited to the imported package variant: its only material file is the online appendix PDF. The dependency checklist is empty, but that does not establish workflow closure because no author program or run specification is supplied.
- The reported supplemental regression table is evidence of empirical analysis, not a complete source-data specification or a verified data-acquisition route. No independent reconstruction is proposed.
