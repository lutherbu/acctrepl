# Patch proposal: jar-ff6f2676d030

Adopting a Label: Heterogeneity in the Economic Consequences Around IAS/IFRS Adoptions

DOI: 10.1111/1475-679X.12005

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | local_available | no_runnable_code |

### full_pipeline

Full author workflow for the paper cannot be established from this data-only archive. The author-prepared IAS/IFRS firm-year dataset is present, but the package supplies no executable analysis workflow or entry point.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 51/Issue 3/12005 - Adopting-a-Label-Heterogeneity-in-the-Economic-Consequences-Around-IAS-IFRS-Adoptions/iasdatadhlv2013.zip",
      "sha256": "4acc0010bc0bd737ed533205d551fca28bb1ac02f0b1bbf8dc7b8c85763bfdc5"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a257ea088bca727f8f8088228131f6ac1f3b836552dafe971698f13dacc231ee",
  "work_item_sha256": "2cd6cd5a05bf880bcd390097a7a4541eacb99cf0c088e52c898044ebf91e6b8d"
}
```

## Proposed actions

### ACTION-REQUEST-WORKFLOW: Obtain the authors' runnable programs for the reported analyses or a complete documented manual/GUI procedure. Request the actual entry points, ordered stages, each required input and transformation, required software/version, and mapping from stages to the paper's reported outputs. Clarify whether the annual-report and database materials described as sources for historical dataset construction must be reacquired by any supplied execution stage; retain them as provenance unless the workflow establishes a current dependency.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISSUE-MISSING-CODE, ISSUE-WORKFLOW-CLOSURE
Evidence: E-README-DATA, E-APPENDIX-HISTORY, E-ARCHIVE-INVENTORY, E-STATIC-AUDIT

Preparation / proposed procedure:

1. Ask the authors to provide the executable scripts/project or, for a manual or GUI process, all steps needed to reproduce the reported analyses from the supplied dataset.
2. Request the documented execution order, any additional input files and required fields/periods, transformations, software and versions, and which outputs correspond to each reported table or figure.
3. After receiving the workflow, reassess every input and producer-consumer dependency; define a separate analysis-only scope only if the authors document an analysis entry point using the supplied dataset.

Validation to perform later:

- Confirm every mandatory workflow stage and input has an identified producer or verified compatible route, and that producer-consumer order is documented.
- Confirm all reported tables and figures are mapped to reproducible output artifacts and that a later authorized run can be checked against the paper.


## Remaining issues and prerequisites

- ISSUE-MISSING-CODE [blocking; full_pipeline]: The archive inventory contains two documentation PDFs and one Stata dataset, but no executable script or project container. No author analysis can be attempted from the supplied package.
- ISSUE-WORKFLOW-CLOSURE [unresolved; full_pipeline]: Without executable code or a complete run procedure, the author's analysis entry points, required inputs beyond the supplied dataset, transformations, software, stage order, and reported-output mapping are unknown. The README and coding appendix describe historical construction of the attached hand-coded dataset; those collection sources are not treated as live inputs absent a workflow that requires their reuse.

## Review notes

- No analysis_only scope is recorded because this archive contains no analysis entry point or separate documented analysis route; inferring one would invent the authors' workflow.
- The attached author-prepared dataset is assessed as the supplied input. Its hand-collection history does not by itself require live acquisition of annual reports or historical source databases.
