# Patch proposal: jar-8d1c43019ceb

Analyst Coverage Overlaps and Interfirm Information Spillovers

DOI: 10.1111/1475-679X.12391

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All author-supplied preparation blocks in the embedded R program, including the pair-year panel, closure/merger event branch and separate He/Tian analyst-information preparation. The supplied code has no model-estimation call; the datasheet's Stata Oster statement is contextual and no unprovided estimation branch is inferred.

Entry points: `MS JAR 2021 Code Package.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 4/12391 - Analyst-Coverage-Overlaps-and-Interfirm-Information-Spillovers/ms-datasheet-code-and-identifiers.zip",
      "sha256": "4154dcb2e0c41ac3fa5a069332492207c159ea2535fa9ba96b2ecd8ec17e6755"
    },
    {
      "path": "JAR-Volume 59/Issue 4/12391 - Analyst-Coverage-Overlaps-and-Interfirm-Information-Spillovers/ms-online-appendix.pdf",
      "sha256": "b6e7d259d74ca962bb2f5a514a0bf0a14784b0519dc4542224ba81a59d0582bd"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "831709452a6eebf9a2e14e0952123a5b03d9924aa1293c23c3cd20fa9b38d43b"
}
```

## Proposed actions

### A_EXTRACT_SETUP_AND_FIX_HANDOFF: Prepare an auditable working copy of the PDF-embedded R program, configure its root and correct the exact IBES path mismatch.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_IBES_EXPERTISE_HANDOFF, I_EXECUTION_SETUP
Evidence: E_CODE_ROOT_SETUP, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Faithfully extract and reflow the substantial R blocks into a working copy while preserving code order; keep the source PDF unchanged.
2. Set a valid working directory and explicit package setup in the working copy; do not run the embedded automatic-install loop.
3. Change the expertise block's .ibes_ibes_crsp_link_processed.Rdata input to ibes_ibes_crsp_link_processed.Rdata, matching the supplied producer, and preserve other paths and object names.

Validation to perform later:

- Statically compare the extracted producer and consumer path and ensure downstream users retain the authored filenames.
- Before a separately authorized execution, check that the configured root contains or can read the required inputs and can write generated files.

### A_VERIFY_AND_STAGE_INPUTS: Verify exact local or public routes for the 18 author inputs against the source-specific fields and historical contracts recorded in the workflow trace, then stage compatible files under the configured root.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_ROUTE_CLOSURE, D_CRSP_HEADER, D_PATENTS, D_PATENT_CITES, D_US_PATENT_CITATION, D_BROKER_CLOSURE, D_BROKER_MERGER, D_IBES_CRSP_LINK, D_IBES_DETAIL, D_HISTORICAL_SEGMENTS, D_FUNDAMENTALS, D_TNIC2, D_SIC2, D_PATENT_INVENTOR, D_COMMON_OWNERSHIP, D_SDC_ALLIANCES, D_IBES_SUMMARY, D_13F_SUMMARY, D_CRSP_DAILY
Evidence: E_WORKFLOW_TRACE, E_IDENTIFIERS_PROBE, E_CATALOG_CONTRACTS

Preparation / proposed procedure:

1. For each input, establish the actual product and its requested fields, identifiers, history and date coverage before selecting a route.
2. Use a prepared compatible route where the supported local/public product already meets the contract; otherwise retain the original raw-preparation branch and record the remaining specific access or field gap.
3. Preserve the pair-year master and closure/merger branches and the separate He/Tian data-preparation branch; do not substitute identifiers.csv for these inputs.

Validation to perform later:

- Confirm every required input has a compatible supported route or a specific unresolved field/history/access item.
- Verify generated intermediate producer-consumer names in the supplied R trace, including the IBES handoff, before any authorized execution.

### A_CONFIGURE_R_DEPENDENCIES: Prepare the 17 packages named by the supplied R setup in an explicit environment and record their versions before a later authorized run.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_R, I_EXECUTION_SETUP
Evidence: E_R_PACKAGE_LOOP, E_R_PACKAGE_PROBE

Preparation / proposed procedure:

1. Create an explicit, reproducible R package environment containing all 17 author-listed packages.
2. Retain a package/version record for that environment; leave package installation outside this assessment.
3. Extract the code into a working copy, set its working root and replace automatic installation with explicit dependency setup.

Validation to perform later:

- Confirm every author-listed package is available in the prepared environment and record the R version and package versions.
- Confirm the extracted working copy uses the configured project root and contains no runtime auto-install loop before any separately authorized execution.


## Remaining issues and prerequisites

- I_ROUTE_CLOSURE [unresolved; full_pipeline]: The 18 source contracts are mapped, but most exact routes, live readability and history remain unverified. Frozen catalog metadata identifies candidate CRSP.DSF and IBES detail/summary tables with matching named fields, but no row probe or period coverage; COMP.FUNDA lacks lpermno/state/linkdt/linkenddt/sic from the author's merged input; SDC.JOINT_VENTURES does not expose the author's wide participant fields; TFN.S34 lacks instown_perc. Remaining patents/citations, broker events, TNIC2, SIC2, inventor links, common ownership and link/history inputs have no verified compatible route in this assessment. No access barrier is established.
- I_IBES_EXPERTISE_HANDOFF [preparation; full_pipeline]: The IBES-CRSP link producer saves ibes_ibes_crsp_link_processed.Rdata, while expertise loads .ibes_ibes_crsp_link_processed.Rdata. No matching leading-dot producer appears in the supplied code; the ordinary-basename working-copy correction is supported by the exact producer/consumer contract.
- I_EXECUTION_SETUP [preparation; full_pipeline]: The substantial R program is embedded in a 3,875-line PDF text extraction, begins with an empty setwd(), and contains automatic package-install setup. R 4.5.0 is present but all 17 author-listed packages are absent from installed.packages metadata. It needs faithful extraction/reflow, a configured root and explicit package preparation before a future authorized run.
- D_CRSP_HEADER [undetermined]: The supplied R preparation code reads crsp_stock_header_information_20180307.dta. Exact compatible route, source field availability and coverage are not yet verified.
- D_PATENTS [undetermined]: The supplied R preparation code reads patents_20180112.csv. Exact compatible route, source field availability and coverage are not yet verified.
- D_PATENT_CITES [undetermined]: The supplied R preparation code reads cites_20180112.csv. Exact compatible route, source field availability and coverage are not yet verified.
- D_US_PATENT_CITATION [undetermined]: The supplied R preparation code reads uspatentcitation_20190306.tsv. Exact compatible route, source field availability and coverage are not yet verified.
- D_BROKER_CLOSURE [undetermined]: The supplied R preparation code reads broker_closure_20180706cs.xlsx. Exact compatible route, source field availability and coverage are not yet verified.
- D_BROKER_MERGER [undetermined]: The supplied R preparation code reads broker_merger.xlsx. Exact compatible route, source field availability and coverage are not yet verified.
- D_IBES_CRSP_LINK [undetermined]: The supplied R preparation code reads ibes_crsp_link_20180516.dta. Exact compatible route, source field availability and coverage are not yet verified.
- D_IBES_DETAIL [undetermined]: The supplied R preparation code reads detail_history_detail_file_with_actuals_20180315.dta. Exact compatible route, source field availability and coverage are not yet verified.
- D_HISTORICAL_SEGMENTS [undetermined]: The supplied R preparation code reads crsp_compustat_merged_database_historical_segments_20180613.dta. Exact compatible route, source field availability and coverage are not yet verified.
- D_FUNDAMENTALS [undetermined]: The supplied R preparation code reads crsp_compustat_merged_fundamentals_annual_20180318.dta. Exact compatible route, source field availability and coverage are not yet verified.
- D_TNIC2 [undetermined]: The supplied R preparation code reads tnic2_allyears_extend_scores_HIGRAN_20180701.txt. Exact compatible route, source field availability and coverage are not yet verified.
- D_SIC2 [undetermined]: The supplied R preparation code reads sic2_20190326.csv. Exact compatible route, source field availability and coverage are not yet verified.
- D_PATENT_INVENTOR [undetermined]: The supplied R preparation code reads patent_inventor_20190306.tsv. Exact compatible route, source field availability and coverage are not yet verified.
- D_COMMON_OWNERSHIP [undetermined]: The supplied R preparation code reads ggl_measures_of_common_ownership_bi-directional_pair_year_data_20200330.dta. Exact compatible route, source field availability and coverage are not yet verified.
- D_SDC_ALLIANCES [undetermined]: The supplied R preparation code reads SDC_1962_2019_20200312.xlsx. Exact compatible route, source field availability and coverage are not yet verified.
- D_IBES_SUMMARY [undetermined]: The supplied R preparation code reads summary_history_summary_statistics_20200226.dta. Exact compatible route, source field availability and coverage are not yet verified.
- D_13F_SUMMARY [undetermined]: The supplied R preparation code reads wrds_thomson_reuters_institutional_13f_holdings_stock_ownership_summary_20200224.dta. Exact compatible route, source field availability and coverage are not yet verified.
- D_CRSP_DAILY [undetermined]: The supplied R preparation code reads crsp_daily_stock_20200227.dta. Exact compatible route, source field availability and coverage are not yet verified.
- S_R [preparation_required]: R 4.5.0 is available, but the read-only package metadata probe found all 17 packages declared in the supplied R setup missing. Prepare these dependencies explicitly; the embedded auto-install loop was not run. The code PDF contains no supplied estimation branch. The datasheet's separate Stata Oster note remains context only.

## Review notes

- Full source reading covers all 130 datasheet lines, 3,875 code-extraction lines and 809 appendix lines. The PDF contains substantial R code even though the initial static parser reported zero code parser IDs.
- The static trace records 18 raw files, 59 producer-backed RData files and 116 source I/O events; a separate consumer-only leading-dot IBES path is preserved as a handoff issue.
- The patent CSV contract uses literal xi and does not interpret it as an inventor measure. inventor_id is from the separate patent-inventor TSV.
- Local frozen catalog metadata is discovery evidence, not a live row read or historical-coverage test. Candidate routes remain unverified; no data outcome is forced.
- identifiers.csv supplies pair-year PERMNO identifiers, not an analysis panel. No analysis_only shortcut or absent Oster estimator branch is inferred.
- No author R code, model or estimator was run; no RData/RDS or other executable serialized object was loaded; no package was installed, no data downloaded, no contact made and no patch applied.
