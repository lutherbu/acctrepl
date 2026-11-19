# Patch proposal: jar-30918de27844

Mobile communication and local trading activity: Evidence from distracted driving laws

DOI: 10.1111/1475-679X.12077

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete reproduction workflow for the supplied online appendix and its referenced main-paper analyses, including appendix Tables A1–A6 and Figure A1.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 2/12077 - Mobile-communication-and-local-trading-activity-Evidence-from-distracted-driving-laws/brownsticewhite-online-appendix.pdf",
      "sha256": "94c75a2d7dd7214b0f83293bc7466de40619c1988802abcf235441098f4a46fd"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "e46aeda25a8883eb69a449a46bf69f833960fa2855116f5e865aa4dbc5169872"
}
```

## Proposed actions

### request_author_replication_materials: Request the confirmed appendix version, executable author workflow, and compatible input specification before attempting reproduction.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: author_analysis_inputs, missing_author_program, unknown_workflow, analysis_input_route_unknown, appendix_version_confirmation
Evidence: ev_inventory, ev_frozen_title, ev_cover_title, ev_a1, ev_panel_period, ev_a2, ev_a3, ev_taq_detail, ev_a4, ev_a5, ev_a6, ev_fig_a1

Preparation / proposed procedure:

1. Ask the authors to confirm that the appendix titled “Mobile communication and local information flow” is the intended online appendix/version for DOI 10.1111/1475-679X.12077, whose frozen package title uses “local trading activity.”
2. Request the author README/run instructions and all scripts and supporting programs for the main-paper analyses and Appendix Tables A1–A6 and Figure A1, including their actual execution order, required software and versions, configuration, and manual inputs.
3. Request author-prepared analysis panels or a complete data dictionary and input specification covering files, fields, identifiers, units, source products, transformations, and coverage; clarify monthly 2002–2011 and event-window panels, TAQ intraday input, and the data/randomization procedure (including any required seed) for Figure A1.
4. If analysis inputs are not supplied, obtain the authors’ documented public or restricted acquisition routes and verify those routes against the required data product and coverage before treating them as usable.

Validation to perform later:

- After receipt, map every documented main-paper and Appendix A1–A6/Figure A1 output to its actual entry point, all supporting stages, and data inputs; verify producer-consumer order and close each dependency.
- Confirm the author-approved appendix version and that each input route covers the stated panels, event windows, identifiers, and TAQ interval data before any separately authorized execution; compare results with the appendix outputs.


## Remaining issues and prerequisites

- missing_author_program [blocking; full_pipeline]: The frozen package inventory contains only the online-appendix PDF. No author entry script, README, preparation code, or other executable program is supplied.
- unknown_workflow [unresolved; full_pipeline]: There are no instructions or code defining required stages, entry points, software, configuration, or order for the appendix and referenced main-paper analyses. The complete dependency closure cannot be established from result tables alone.
- analysis_input_route_unknown [unresolved; full_pipeline]: No compatible author analysis data are supplied, and the appendix does not provide full file-level schemas, identifiers, source products, coverage, construction steps, or a verified acquisition route for the reported panel, event-study, intraday, and randomization analyses.
- appendix_version_confirmation [unresolved; full_pipeline]: The supplied appendix cover uses the title “Mobile communication and local information flow,” while the frozen DOI/package header uses “Mobile communication and local trading activity.” The authors should confirm this appendix version is the intended supplement for the frozen DOI before output comparisons.
- author_analysis_inputs [undetermined]: Author-prepared inputs needed to reproduce the analyses reported in the supplied appendix and referenced main-paper tables. The appendix documents monthly and daily stock panels, event-study samples, TAQ intraday trading panels, and a 1,000-permutation exercise, but provides no row-level files or complete input/source specification.

## Review notes

- The frozen dependency checklist is empty. No language, software version, code dependency, or input-file graph can be established from this results-only appendix.
- The appendix contains summary statistics and reported results, not row-level analysis inputs; no analysis-only scope is supported.
- The appendix cover title differs from the frozen DOI/package title, so version identity needs author confirmation.
