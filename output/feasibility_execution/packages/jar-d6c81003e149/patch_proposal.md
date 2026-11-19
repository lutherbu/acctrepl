# Patch proposal: jar-d6c81003e149

The Role of Social Media in the Capital Market: Evidence from Consumer Product Recalls

DOI: 10.1111/1475-679X.12074

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The supplied author-package variant consists of the online appendix reporting supplementary and robustness analyses for the paper; no executable author workflow is included.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 2/12074 - The-Role-of-Social-Media-in-the-Capital-Market-Evidence-from-Consumer-Product-Recalls/hutton-fen-lee-shu-online-appendix.pdf",
      "sha256": "cbc8b2ded2ec78c67675f6737dab7e681ba80a951d1e448eb658ff2c39369758"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "400dafbfbc82e2db67309ab3a69af6e38b285fa74a696f84a57be0c1ee67a8a8"
}
```

## Proposed actions

### request_author_replication_materials: Obtain the author-provided executable replication materials and the input specification needed to assess the appendix analyses.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: appendix_analysis_inputs, missing_author_program, unknown_workflow, analysis_input_route_unknown
Evidence: ev_inventory, ev_appendix_scope, ev_a1, ev_a2, ev_a3, ev_a4, ev_a5, ev_a6

Preparation / proposed procedure:

1. Request the author README or run instructions, all scripts and supporting programs for the paper and online appendix, their intended execution order, required software and versions, and any manual configuration or inputs.
2. Request the author-prepared analysis datasets or a data dictionary and full input specification identifying required files, fields, identifiers, time coverage, sample construction, transformations, and any acquisition conditions; clarify which independent analyses produce Tables A1–A6.
3. If the authors point to a public or restricted source instead of supplying analysis inputs, verify a compatible product and permitted acquisition route against those specifications before recording it as usable.

Validation to perform later:

- After materials arrive, map every documented main-paper and Appendix A1–A6 output to its actual entry point and all required supporting stages; verify producer-consumer order and close every dependency.
- Confirm each required data input has compatible fields, identifiers, coverage, and a verified route before a separately authorized execution; compare resulting outputs with the reported appendix tables.


## Remaining issues and prerequisites

- missing_author_program [blocking; full_pipeline]: The frozen package inventory contains only the online-appendix PDF; there is no author entry script, README, preparation code, or other executable program from which to run the reported analyses.
- unknown_workflow [unresolved; full_pipeline]: The release provides no instructions or code defining the full workflow, required stages, software/runtime, or mappings from the appendix outputs to analysis entry points. Dependency closure and stage order cannot be established from the results appendix alone.
- analysis_input_route_unknown [unresolved; full_pipeline]: The reported regressions require compatible analysis inputs, but this release does not include data, identify the input products/files, document required fields and coverage, or establish any compatible local or public acquisition route.
- appendix_analysis_inputs [undetermined]: Author-prepared input data needed to reproduce the supplementary regression analyses in Tables A1–A6. The supplied appendix reports estimates and sample sizes but does not specify the compatible input files, fields, identifiers, full period coverage, or construction workflow.

## Review notes

- The frozen dependency checklist is empty. No software requirement or dependency edge is inferred from the appendix because no runnable author code or workflow instructions are supplied.
- No analysis-only scope is justified: the package contains no author-prepared analysis data or executable analysis entry point.
