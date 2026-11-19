# Patch proposal: jar-4d41b76db6f4

Think Twice before Going for Incentives: Social Norms and the Principal's Decision on Compensation Contracts

DOI: 10.1111/1475-679X.12093

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Reproduce Figure A1's path analysis for the additional randomized-contract experiment described in the online appendix. The supplied release contains only the appendix PDF and no executable workflow or analysis data.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 5/12093 - Think-Twice-before-Going-for-Incentives-Social-Norms-and-the-Principal-s-Decision-on-Compensation-Contracts/cardineals_yin_online_appendix.pdf",
      "sha256": "f06d57a6094e01e8591b7395e36a7de1b0ec405b983ce23885d09cba95e4225d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "c579f5dd9d3bde79afc5d46e6a5c118735f618dbb665f425e6b37f2945668319"
}
```

## Proposed actions

### clarify_figure_a1_workflow_and_input: Request the complete author workflow or approved replacement description and the compatible analysis input for the additional-experiment path analysis in Figure A1.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: missing_author_program, figure_a1_workflow_and_input_unknown, figure_a1_analysis_input
Evidence: inventory_only_pdf, appendix_scope, figure_a1_method, figure_a1_constructs

Preparation / proposed procedure:

1. Obtain the executable author program or approved replacement workflow, including the Figure A1 entry point, model specification, estimator settings, and required stages.
2. Obtain the author-prepared data or exact estimation-input contract for N = 32, including format, variable coding, identifiers, sample/exclusion handling, missing-value treatment, and any transformations.
3. Map all documented Figure A1 constructs and confirm how the supplied input corresponds to the author's analysis before assessing an execution attempt.

Validation to perform later:

- Confirm that the documented input and workflow cover the 32 observations and all Figure A1 constructs, and that the future rerun reproduces the reported path coefficients and SRMR without changing the analysis specification.


## Remaining issues and prerequisites

- missing_author_program [unresolved; full_pipeline]: The frozen package inventory contains only cardineals_yin_online_appendix.pdf. The appendix reports Figure A1's path analysis but provides no executable author program or run instructions, so there is no supplied entry point to attempt.
- figure_a1_workflow_and_input_unknown [unresolved; full_pipeline]: The appendix describes an additional experiment, estimates a QML path analysis with N = 32, and defines its constructs, but does not establish the analysis input format, sample/exclusion handling, full model specification and settings, or executable workflow. Dependency closure and a compatible input route remain unknown.
- figure_a1_analysis_input [undetermined]: Author-compatible analysis data or estimation input for Figure A1's path analysis (N = 32), covering the documented contract, perceived norm, perceived trust, and misreport constructs. The appendix supplies results and construct definitions but no input file, schema, identifiers, exclusions, or compatible route.

## Review notes

- This assessment covers the frozen package variant whose only inventoried artifact is the online appendix PDF. It reports one additional-experiment path analysis, but provides neither executable code nor the estimation input; no analysis-only scope is supported.
- The appendix reports QML estimates and describes the four constructs, while model execution details, the compatible input route, and any necessary preprocessing remain unknown.
- No author program was executed, no dataset was read or downloaded, and no software requirement can be established from the supplied release.
