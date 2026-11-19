# Patch proposal: jar-edfaefd88238

Foreign Institutional Ownership and the Global Convergence of Financial Reporting Practices

DOI: 10.1111/1475-679X.12076

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Full reproduction workflow for the supplied Internet Appendix, including its definition table and supplemental outputs Tables IA1–IA13 for the referenced paper.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 3/12076 - Foreign-Institutional-Ownership-and-the-Global-Convergence-of-Financial-Reporting-Practices/fangmaffettzhang-online-appendix.pdf",
      "sha256": "dcdc51f05b777fe644a40cea74ebeab5eb3d2bf9757c1c60bfc0049ed0587fdf"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "1ad63f86a63fe31e7553750b00c1e716c834a71ba49d06d63e5ee62dd8e3f38d"
}
```

## Proposed actions

### request_author_replication_materials: Request the executable workflow, complete variable documentation, and compatible data specification for the full set of supplied appendix outputs.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: author_analysis_data, missing_author_program, unknown_workflow, analysis_input_route_unknown, paper_variable_definitions_missing
Evidence: ev_inventory, ev_appendix_scope, ev_outputs, ev_variable_definitions, ev_period, ev_appendix_a_reference

Preparation / proposed procedure:

1. Request the author README/run instructions and all scripts and supporting programs used for the main-paper workflow and supplemental Internet Appendix Tables IA1–IA13, with their actual execution order, software/runtime versions, configuration, and manual inputs.
2. Request the missing main-paper Appendix A variable definitions and any other data dictionary/codebook needed to interpret derived variables and controls referenced by the Internet Appendix.
3. Request author-prepared analysis datasets or a complete input specification listing each file/product, fields, firm/country/year identifiers, units, construction, and coverage for the 1998–2009 analyses; identify which inputs are already author-prepared and which, if any, require acquisition.
4. Clarify the documented data sources and permitted routes for any required inputs not supplied by the authors; do not treat mentioned historical source products as usable routes until their product, compatibility, coverage, and access conditions are verified.

Validation to perform later:

- After receipt, map the definition table and each supplemental Table IA1–IA13 to actual entry points and required producer stages, then verify complete dependency coverage and execution order.
- Confirm that every data route supports the required variables, identifiers, transformations, market/country coverage, and 1998–2009 history before any separately authorized execution; compare the resulting outputs to the appendix tables.


## Remaining issues and prerequisites

- missing_author_program [blocking; full_pipeline]: The frozen package inventory contains only the Internet Appendix PDF; there is no author README, runnable entry point, data-preparation code, or supporting program.
- unknown_workflow [unresolved; full_pipeline]: No author instructions identify stages, entry points, runtime/software, configuration, or execution order for the supplemental analyses. The package contains results and definitions, not an executable workflow, so dependency closure cannot be established.
- analysis_input_route_unknown [unresolved; full_pipeline]: The appendix reports sample summaries and regression results, but this release supplies no row-level analysis data and no compatible file-level specification, identifiers, field coverage, transformations, or verified local/public/restricted route for those inputs.
- paper_variable_definitions_missing [unresolved; full_pipeline]: The Internet Appendix refers to the main paper’s Appendix A for detailed variable definitions. That documentation is not included in the supplied package, leaving some controls and derived variables unspecified for a future workflow assessment.
- author_analysis_data [undetermined]: Author-prepared analysis inputs needed to reproduce the supplemental analyses listed as Tables IA1–IA13. The appendix reports results for the 1998–2009 sample and defines some appendix-only variables, but does not supply row-level analysis files, full variable specifications, file schemas, or a compatible acquisition route.

## Review notes

- The frozen dependency checklist is empty. The appendix is results-only documentation and does not identify code stages or software dependencies.
- The supplied PDF includes aggregate sample statistics, correlations, and reported regression results, but no row-level analysis inputs or executable entry point; no analysis-only scope is supported.
- Several table notes refer to detailed variable definitions in the main paper’s Appendix A, which is not part of the supplied package.
