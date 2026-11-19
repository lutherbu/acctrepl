# Patch proposal: jar-4c117d677a95

Political Connections and the Cost of Bank Loans

DOI: 10.1111/1475-679X.12038

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow. The supplied variant is an internet appendix with supplementary loan-spread analyses and table notes, but contains no runnable source, full workflow, or analysis data.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 52/Issue 1/12038 - Political-Connections-and-the-Cost-of-Bank-Loans/houston-online-appendix.pdf",
      "sha256": "77676a85c48f8d96a020d3fe2482274a03c2664a4191c879a41622acc617ca0d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a257ea088bca727f8f8088228131f6ac1f3b836552dafe971698f13dacc231ee",
  "work_item_sha256": "72391f3c909bec7e0d19a4c3c54a0e282a4d9299c02aa0ce37fee9c60ba9656e"
}
```

## Proposed actions

### request-complete-code-data-spec: Obtain the executable research package and complete loan-level input specification before assessing full-pipeline execution.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: loan-analysis-inputs-unknown, missing-workflow-and-code
Evidence: appendix-table1, crisis-sample, iv-geography, matching-design, election-sample, covenant-sample, package-contents

Preparation / proposed procedure:

1. Request or locate the complete author-provided code package, README/data guide, entry points, supporting programs, and any author-prepared loan-level analysis files.
2. Request the paper Table 1 definitions and identify the actual input files/products, stored fields, loan and firm identifiers/crosswalks, full periods, sample restrictions, construction, and author-documented acquisition/preparation route for each analysis branch.
3. After the workflow is supplied, trace the producer-consumer order and assess the supplied inputs and prescribed software; do not independently reconstruct the historical loan-level research data.

Validation to perform later:

- Confirm each documented main and appendix analysis stage has a supplied entry point and documented inputs, with any missing producer or handoff retained as an unresolved issue.
- Verify candidate loan/firm fields, identifiers, variable construction, and branch-specific coverage against the author specification before recording an input route as compatible.


## Remaining issues and prerequisites

- missing-workflow-and-code [unresolved; full_pipeline]: The supplied inventory contains only the internet appendix PDF. It has reported supplementary tables and references definitions in the paper, but no executable programs, README/data guide, entry points, complete analysis data, or producer-consumer instructions. The full workflow and analysis-input route therefore remain unresolved.
- loan-analysis-inputs-unknown [undetermined]: The appendix analyses single bank-loan spreads and identifies borrower political-connection/board information, firm and loan controls, and instrument inputs based on firm age and headquarters distance. Its supplemental samples include a 2003–2008 financial-crisis test and 2005–2007 election tests, with additional matching and covenant-restricted analyses. The appendix defers many variable definitions to Table 1 of the paper and does not provide analysis data, raw input files, stored-field names, identifiers/joins, complete sample construction, or a compatible acquisition route for the full workflow.

## Review notes

- This is a document-only release. The appendix reports supplementary results and describes some branch-specific samples and variables, but does not provide analysis data or code; no analysis-only execution scope is supported.
