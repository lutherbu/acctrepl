# Patch proposal: jar-6a0fef0ff1cb

Fair Value Accounting and Debt Contracting: Evidence from Adoption of SFAS 159

DOI: 10.1111/1475-679X.12126

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The package contains only an online appendix with nine supplementary result tables and descriptive model/data definitions. It includes no code, dataset, or full replication instructions. The exact author workflow and analysis inputs are not established.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 4/12126 - Fair-Value-Accounting-and-Debt-Contracting-Evidence-from-Adoption-of-SFAS-159/onlineappendixdemerjian.pdf",
      "sha256": "941de79e46dc8613f6387ceccac25a2887541808c7150fa146893028cc53cf70"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "9de78625c7ddc47c1289eecc3c555d757c6e6a62ebe5fbdeb86572be97e28b7b"
}
```

## Proposed actions

### request_workflow_and_data: Request the authors’ complete replication workflow and identify the approved data inputs for Tables OA1–OA9.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: analysis_data, missing_program, missing_workflow_and_inputs
Evidence: appendix_tables, appendix_data_leads, audit_no_code

Preparation / proposed procedure:

1. Request the executable programs and run instructions, or a complete documented manual procedure if no runnable code exists, for every supplemental branch: OA1–OA9, including alternate control groups, the matched sample, Heckman stages, and cross-sectional tests.
2. Request the exact author-prepared datasets or input specifications, including file names, fields, identifiers, periods, sample construction, and mappings to OA1–OA9; request the manuscript Table 1 and Table S1 definitions referenced by the appendix.
3. Treat Dealscan and Compustat labels/formulas in the appendix as clarification leads. Confirm exact source products and any permitted local/public routes only after authors identify the workflow inputs.

Validation to perform later:

- After the workflow and inputs are identified, trace all table-producing branches and verify input fields, identifiers, sample periods, control definitions, generated intermediates, and row counts against the authors’ instructions.


## Remaining issues and prerequisites

- missing_program [unresolved; full_pipeline]: No executable program is included in the package; the PDF is an online appendix containing supplementary analyses and results.
- missing_workflow_and_inputs [unresolved; full_pipeline]: The appendix supplies nine supplemental result tables and partial model/variable definitions, but no entry points, preparation steps, exact analysis datasets, identifiers, or output-generation instructions. It references controls defined in manuscript Table 1 and Table S1, which are not included here. Dealscan/Compustat labels and formulas are clarification leads, not separate mandatory raw-data requirements absent a supplied workflow.
- analysis_data [undetermined]: Author-approved analysis data and any inputs required to reproduce the nine supplemental tables OA1–OA9. The appendix reports empirical estimates but contains no data files or workflow that identifies the exact files, fields, histories, or construction required.

## Review notes

- The supplied artifact is an online appendix with nine supplemental empirical tables; the data requirement follows from those reported regressions, not from inferred raw-data sources.
- The appendix has no executable entry point. Source names, formulas, and references to manuscript Table 1/Table S1 remain clarification leads rather than independent mandatory data requirements until a workflow is supplied.
- No local datasets were probed and no external source pages were checked because the appendix does not specify compatible files or a source route; no data were downloaded and no author code was run.
