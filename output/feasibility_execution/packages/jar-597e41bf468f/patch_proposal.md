# Patch proposal: jar-597e41bf468f

Taxes and Financial Constraints: Evidence from Linguistic Cues

DOI: 10.1111/1475-679X.12081

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow for the paper and supplied Internet Appendix; the imported package does not contain a runnable workflow.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 4/12081 - Taxes-and-Financial-Constraints-Evidence-from-Linguistic-Cues/lawmills-online-appendix.pdf",
      "sha256": "48b6badf569e43bfb1bc8427452e9bd881c0c1970577dacce16e0208b23c5c63"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "79eb75db32dc6403f6a4398c3dcc11a5cb40388514af6cec3cfd4084b8c99091"
}
```

## Proposed actions

### obtain_author_workflow: Request the missing author workflow and complete input specification before assessing feasibility or attempting replication.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: analysis_inputs_unknown, author_code_missing, workflow_spec_missing
Evidence: package_inventory, static_audit_no_code, appendix_empirical_output

Preparation / proposed procedure:

1. Obtain the complete author-provided replication materials for this package variant, including runnable programs, README or data description, supplied analysis data or documented authorized acquisition routes, and any execution logs.
2. Ask the authors to map every main-paper and Internet Appendix output to its entry point and document required input products, fields, identifiers, periods, transformations, manual preparation, generated files and producer order, software, and any data-sharing limits or approved alternatives.
3. Treat historical source references in the appendix as leads only; verify their exact role and compatibility against the supplied author workflow before recording them as live input routes.

Validation to perform later:

- After the materials arrive, trace all entry points and branches to the documented outputs and account for every required input and intermediate.
- Use bounded metadata and software probes to check specified input formats, fields, periods, and runtimes; record unresolved access or coverage conditions.
- Only after workflow closure, schedule an authorized run using the author-prescribed command and compare outputs with the cited tables; the current package provides no command to run.


## Remaining issues and prerequisites

- author_code_missing [blocking; full_pipeline]: The imported author package contains only the Internet Appendix PDF. No runnable program or entry point is supplied, so the full author workflow cannot be attempted from this variant.
- workflow_spec_missing [unresolved; full_pipeline]: The appendix reports multiple empirical analyses and describes selected historical source products, but supplies no run instructions, program-to-output mapping, full data and variable specifications, preparation steps, generated intermediates, software requirements, or execution logs. Required inputs and dependency closure therefore remain unknown; no analysis-only route is supported by the supplied materials.
- analysis_inputs_unknown [undetermined]: Data inputs for reproducing the main paper and supplemental empirical analyses. The Internet Appendix describes some source products and reports regression results, but the package does not specify the complete author workflow, input products, fields, identifiers, coverage, transformations, or acquisition routes.

## Review notes

- Assessment is limited to the imported package variant: its only material file is the Internet Appendix PDF. The dependency checklist is empty, but that does not establish workflow closure because no author program or run specification is supplied.
- The appendix describes selected historical sources for supplemental analyses, but this is not a complete live input inventory or verified acquisition route. No independent reconstruction is proposed.
