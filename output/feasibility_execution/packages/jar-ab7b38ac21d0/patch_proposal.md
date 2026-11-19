# Patch proposal: jar-ab7b38ac21d0

The Effect of Intangible Asset Classification on Professional Financial Statement Users’ Assessments

DOI: 10.1111/1475-679X.12604

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Reproduce the as-supplied reported Online Appendix A and B results from the author workflow; this release supplies only the results appendix.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 3/12604 - The-Effect-of-Intangible-Asset-Classification-on-Professional-Financial-Statement-Users-Assessments/amm-online-appendix.pdf",
      "sha256": "8d0ecb05bf2df05c2b61bb168c07e6bc415fe023e3ca5a0bdb5fd0624c47b335"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "3c57169dea8479aba853e4dc3cdb6bd5e2b172b49ad11393110a7831514ed20c"
}
```

## Proposed actions

### A_CLARIFY_WORKFLOW: Obtain the author-supplied workflow and analysis inputs needed to reproduce Online Appendix A and B. The supplied release is results-only, so the audit does not infer a separate raw-source reconstruction or software stack.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_ANALYSIS_DATA, I_NO_CODE, I_WORKFLOW_UNKNOWN
Evidence: E_PACKAGE_INVENTORY, E_STATIC_AUDIT, E_SOURCE_APPENDIX

Preparation / proposed procedure:

1. Request the executable programs or complete manual procedure that produced Online Appendix A and B, including their intended order and intermediate files.
2. Request the author-prepared analysis input files or exact input specifications, plus a data dictionary stating the observation unit, required variables, condition coding, file formats, and how the two dependent-variable results are constructed.
3. Ask the authors to identify required software and version and any omitted preparation, transformation, or table-production steps.

Validation to perform later:

- After receiving the materials, trace each required input and producer through both appendix tables and compare the documented field, condition, observation-unit, type, and construction contracts before assessing resource or software availability.


## Remaining issues and prerequisites

- I_NO_CODE [blocking; full_pipeline]: The only inventoried package item is a results appendix PDF; it contains reported results and explanatory prose but no executable program or manual procedure. No supplied entry point is available to run.
- I_WORKFLOW_UNKNOWN [unresolved; full_pipeline]: The appendix gives outcome tables and a short description of participant measures but no data files, executable/manual analysis workflow, field or condition-coding contract, input format, or software specification. The exact required analysis inputs and producer sequence therefore remain unknown.
- R_ANALYSIS_DATA [undetermined]: The participant-level observations or author-prepared analysis input(s) needed to reproduce the reported Online Appendix A and B results; exact files, fields, condition coding, and format are not specified in this release.

## Review notes

- This assessment covers the frozen PDF-only release. The supplied appendix does not state a conflicting paper title or DOI; the frozen header is retained.
- The only package item is the online appendix with reported results. No analysis dataset, executable code, manual procedure, named commercial or public source product, or required software is specified. The required workflow and input contract remain unresolved; no named-product catalog or software/setup check is applicable on the supplied evidence.
- No analysis_only scope is supported because this release contains neither an analysis program nor a usable analysis-input route. The assessment does not infer an independent reconstruction of the reported experiment.
