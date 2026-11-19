# Patch proposal: jar-cbaa6897647c

Reproducibility of Accounting Research: Views of the Research Community

DOI: 10.1111/1475-679X.12305

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | local_available | undetermined |

### full_pipeline

Supplied survey response workflow: use the author-provided raw responses and the Excel computations workbook to summarize 15 survey questions plus two demographic questions and calculate the manuscript percentages. Survey administration is historical context, not a live stage.

Entry points: `03 HLL Survey - Computations.xlsx`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 2/12305 - Reproducibility-of-Accounting-Research-Views-of-the-Research-Community/hll-datasheet-and-instrument-files.zip",
      "sha256": "f85712add1f251ff844419b5fdd4e5607897c85bb828a2aae792c8d026b7e40b"
    },
    {
      "path": "JAR-Volume 58/Issue 2/12305 - Reproducibility-of-Accounting-Research-Views-of-the-Research-Community/hll-online-appendix.pdf",
      "sha256": "7aaecf6d893d8e0ae036fcd5041d950f3d6776182721ca15ca9dfc293f26d480"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "69d7ba65cb1b2b997c7b6b1eece81c15079979594530d58872d174398df390f2"
}
```

## Proposed actions

### a_reconcile_data_handoff: Use the supplied author-prepared raw response workbook as the primary input and establish how its rows populate the computation workbook's Data sheet before refreshing calculations.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: r_survey_raw, i_data_handoff
Evidence: e_datasheet_raw, e_raw_probe, e_computations_probe, e_header_compatibility, e_pivot_example, e_workbook_coverage_v4, e_workflow_trace_v2

Preparation / proposed procedure:

1. Make a working copy of both XLSX files, preserving the original hashes recorded in the work item.
2. Use the computations workbook with original SHA-256 ad397efb6999bfe32e36033dcb33240b970279003fda586d78004596f1ffc7d5 as the base. Its exact formula and PivotTable locations are in probes/workbook_program_coverage_v4.json.
3. Confirm the Data sheet's 52 named columns and the response-row range against 02 HLL Survey - Raw Data.xlsx; record whether the source is copied, linked, or otherwise staged and keep helper-formula columns aligned.
4. Do not infer row-level equality from matching headers or the one-row probe; resolve any missing or stale handoff in the working copy.

Validation to perform later:

- Record the raw input and Data-sheet source relationship and verify the intended survey rows are present before pivot refresh.

### a_refresh_excel_workbook: Run the supplied Excel computations workbook in a compatible Excel release after the Data-sheet handoff is established.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: s_excel, i_excel_runtime, i_data_handoff
Evidence: e_datasheet_excel, e_static_method, e_formula_example, e_pivot_example, e_workbook_coverage_v4, e_workflow_trace_v2

Preparation / proposed procedure:

1. Identify and record the Microsoft Excel release used for recalculation and PivotTable refresh; do not assume compatibility from an installed LibreOffice executable.
2. In the working copy, recalculate the Data-sheet IF formulas, refresh the 42 PivotTables whose source ranges are on Data and destinations are on Computations, then recalculate the 29 GETPIVOTDATA-containing result formulas on Computations.
3. Save the refreshed workbook copy and preserve formula/pivot error messages and engine/version details.
4. Compare workbook percentages with the manuscript only when the expected manuscript values are available; the article's numerical results are not part of the frozen material set.

Validation to perform later:

- Check that all listed pivot tables refresh, all formula outputs are populated without errors, and the workbook's summaries/percentages can be reconciled to the author-reported results when available.


## Remaining issues and prerequisites

- i_data_handoff [unresolved; full_pipeline]: All 42 PivotTables read worksheet ranges on the Computations workbook's internal Data sheet. Header metadata matches the separate raw workbook, but the supplied documentation and bounded inspection do not establish whether/how those response rows are copied, linked, or refreshed from 02 HLL Survey - Raw Data.xlsx; external links are marked not dereferenced, so their presence or relationship is not established.
- i_excel_runtime [unresolved; full_pipeline]: The workbook contains 5,440 IF formula cells, 29 formulas using GETPIVOTDATA, and 42 PivotTables. The author-used Excel version and a compatible runtime for recalculation and pivot refresh are not established; static formula visibility does not demonstrate that another spreadsheet engine is compatible.
- s_excel [unverified]: The authors state that they conducted the survey analyses in Excel. The compatible Excel release, recalculation behavior, and PivotTable refresh behavior are unverified. No spreadsheet application was launched.

## Review notes

- The computation workbook is substantive supplied author code and the full-pipeline entry point; stored formulas and PivotTables perform the documented survey computations.
- No analysis-only scope is justified; the supplied workbook is the analysis workflow itself, and no separate prepared analysis dataset route is documented.
- The survey was already collected through Qualtrics; no respondent recollection, contact, collection reenactment, or independent reconstruction is in scope.
- The raw workbook is a locally supplied author-prepared input, and its 52 named headers match the Computations.Data named headers on bounded probes. Whole-file response coverage and the transfer/link path to Data remain unverified.
- The static inspection accounts for 5,440 Data-sheet IF formulas, 29 Computations formulas containing GETPIVOTDATA, and all 42 PivotTables. The author-used Excel release, pivot refresh state, and output agreement remain unverified. No Office application was launched and no formula or pivot was evaluated.
- The frozen work item contains no dependency-checklist edges; the ordered spreadsheet source and range trace covers the observed program and input handoff.
