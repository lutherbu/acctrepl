# Patch proposal: jar-5e3f248fa491

Do managers of U.S. defined benefit pension plan sponsors use regulatory freedom strategically?

DOI: 10.1111/1475-679X.12182

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All supplied Stata preparation and analysis stages for Sections 4, 5 and 6, with the online-appendix sponsor, cash-contribution, robustness and DOL branches retained. Stage 6 period documentation conflict is recorded as unresolved.

Entry points: `JAR_codes/(0a) preparation_all_raw_BC.do`, `JAR_codes/(0b) prep_2011_DOL.do`, `JAR_codes/(0c) prep_2012_DOL.do`, `JAR_codes/(1) preparation.do`, `JAR_codes/(2) G and assumptions.do`, `JAR_codes/(3) Leeway and cash contributions.do`, `JAR_codes/(4a) prepare compustat.do`, `JAR_codes/(4b) merge_compustat_5500.do`, `JAR_codes/(5) sponsor analysis.do`, `JAR_codes/(6) clean_DOL.do`, `JAR_codes/(7) analysis.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 5/12182 - Do-managers-of-U-S-defined-benefit-pension-plan-sponsors-use-regulatory-freedom-strategically/kks-datasheet-and-code.zip",
      "sha256": "f913620a7390030c9acbe010e1d53230aaf258e051da2f187a29d25a4a3e46e0"
    },
    {
      "path": "JAR-Volume 55/Issue 5/12182 - Do-managers-of-U-S-defined-benefit-pension-plan-sponsors-use-regulatory-freedom-strategically/kisser-et-al-online-appendix.pdf",
      "sha256": "9cee26aa1c8086263978c5b1e478a55edeafab44baba229191577508661f252b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "fe0b135fe9d92e42bcaf43d86c8570e459342ad3bd0244b8d239c7033732c67a",
  "work_item_sha256": "cb2386e4022d8f202280694687a9cf3a6e067978eac1a98f40ecd5c3c29cf57f"
}
```

## Proposed actions

### A_BC_INPUT: Obtain the exact 1999–2007 author-format BC Stata inputs or confirm a compatible DOL historical-file substitute.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_BC_RAW
Evidence: E_DOC_BC, E_DOC_DOL_RATES, E_BC_PATTERN, E_PUBLIC_BC

Preparation / proposed procedure:

1. Request the nine raw5500-YYYY-1.dta files and their field/sample notes from the authors.
2. If relying on DOL Pension Research Files, first confirm that their variables and sample reproduce the supplied Stage 1 expectations; the current BC page establishes a candidate source, not compatibility.
3. Place the files under an agreed data root, then run Stage 0a followed by Stage 1 without changing the sample or transformations.

Validation to perform later:

- Confirm all nine 1999–2007 inputs and Stage 0a intermediates resolve.
- After authorized execution, verify raw5500_all.dta contains the expected 1999–2007 years and fields consumed by Stage 1.

### A_DOL_INPUTS: Acquire and stage the six public DOL Latest CSV datasets required by the supplied 2011–2012 workflow.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_DOL_2011_12, I_DOL_LAYOUT
Evidence: E_PUBLIC_DOL11, E_PUBLIC_DOL12, E_PUBLIC_DOL_GUIDE, E_PUBLIC_DOL_ACK, E_STAGE6_DOL11, E_STAGE6_DOL11_H, E_STAGE6_DOL12, E_STAGE6_DOL12_H, E_STAGE6_APPEND, E_STAGE6_LAG, E_APPENDIX_DOL_FIELDS

Preparation / proposed procedure:

1. Retrieve the 2011 and 2012 Latest Form 5500, Schedule H and Schedule SB CSV datasets from the DOL page and extract the zipped CSV contents.
2. Preserve the file names expected by Stages 0b and 0c and place them under the configured data root.
3. Run Stages 0b and 0c before Stage 6 so the latter appends raw_2011.dta and raw_2012.dta in the delivered order.
4. Before treating the route as compatible, compare the official 2011 and 2012 Schedule H/Schedule SB file layouts with the exact fields used by the delivered code and Online Appendix Table 10.

Validation to perform later:

- Confirm each CSV exposes ACK_ID/ack_id and the source fields required by the supplied transformations.
- After authorized execution, inspect the ACK_ID merges and confirm Stage 6 creates the 2012 lagged contribution change from the 2011 predecessor.

### A_COMP_CORE: Resolve the Compustat annual input and its author-specific column and identifier mapping.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_CORE
Evidence: E_DOC_COMP_TAX_GIM, E_COMP_INPUT, E_COMP_1998, E_COMP_LAGS, E_COMP_PERIOD, E_COMP_CATALOG, E_LOCAL_FUNDA, E_LOCAL_COMPANY

Preparation / proposed procedure:

1. Request pension.dta and its field definitions, or confirm that local COMP.FUNDA plus COMP.COMPANY can be combined into a compatible input.
2. For the local candidate, reconcile the FUNDA sich column with the Stage 4a sic use and establish how COMPANY sic and EIN map by gvkey and year; preserve the expected numeric/string types.
3. Include 1998 prior-year observations for every relevant firm and 1999–2007 analysis years, then prepare the exact pension.dta columns expected by Stage 4a.

Validation to perform later:

- Before execution, confirm required Compustat keys, raw fields and 1998 history against the supplied code.
- After authorized preparation, verify annual coverage and that Stage 4a retains the documented 1999–2007 sample after generating its lag-based variables.

### A_COMP_PENSION: Resolve the pension-accounting input needed for Stage 4a and Stage 5.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_PENSION
Evidence: E_DOC_COMP_TAX_GIM, E_COMP_MERGES, E_STAGE5_TABLES, E_COMP_CATALOG, E_LOCAL_PENSION

Preparation / proposed procedure:

1. Request the author-prepared pension_robust.dta or confirm the local COMP.ACO_PNFNDA candidate is compatible.
2. Verify coverage and key uniqueness for gvkey/datadate and retain ppror and pbarr for matched 1999–2007 sponsor years.
3. Prepare the expected Stata input without changing Stage 4a merge rules.

Validation to perform later:

- After authorized preparation, confirm the Stage 4a merge key and year coverage and that Stage 5 receives ppror and pbarr.

### A_GRAHAM_TAX: Obtain and identify the Graham marginal tax-rate file used for the Section 5 robustness analyses.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_GRAHAM_TAX
Evidence: E_DOC_COMP_TAX_GIM, E_DOC_DOL_RATES, E_COMP_MERGES, E_STAGE5_TABLES

Preparation / proposed procedure:

1. Request taxrates.dta and its field/key notes from the authors or confirm an authorized delivery route for the Graham marginal tax-rate input.
2. Confirm the file supplies the merge keys gvkey/fyear and the tax1 value for the 1999–2007 sample.
3. Place the confirmed file at the configured data root expected by Stage 4a.

Validation to perform later:

- After authorized execution, verify the Stage 4a merge by gvkey/fyear and confirm tax1 is available for the documented Stage 5 robustness models.

### A_GIM_INPUT: Verify the author workbook and local RISK.GSET candidate, conversion, overlapping sample coverage and model observation counts before preparing Gindex.dta.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_GIM, I_GIM_COVERAGE
Evidence: E_PUBLIC_GIM, E_DOC_COMP_TAX_GIM, E_COMP_MERGES, E_STAGE5_TABLES, E_COMP_PERIOD, E_LOCAL_RISK_GSET, E_LOCAL_GINDEX_FIELD

Preparation / proposed procedure:

1. Under an authorized data-acquisition or preparation step, inspect the author-page workbook header and/or the listed local RISK.GSET source fields YEAR, CIK, TICKER and GINDEX.
2. Map YEAR/CIK/TICKER to the Stage 4a gvkey/fyear merge key and confirm the exact GINDEX-to-g mapping against author guidance; no compatible conversion is assumed from the catalog label alone.
3. Confirm the overlap with the sponsor sample and compare nonmissing-g model observations with the intended results; the supplied code filters some g models, so do not require or impute 2007 values without author guidance.
4. Prepare the exact Gindex.dta input only after the field and sample mapping is confirmed.

Validation to perform later:

- After authorized preparation, verify key uniqueness and overlap with the sponsor sample and compare Stage 5 model Ns to the author targets; document missing-g handling.

### A_DOL_PERIOD: Resolve the mismatch between the appendix period statement and the delivered DOL workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DOL_PERIOD
Evidence: E_APPENDIX_DOL_PERIOD, E_STAGE6_DOL11, E_STAGE6_DOL12, E_STAGE6_APPEND, E_STAGE7_ANALYSIS

Preparation / proposed procedure:

1. Ask the authors whether Section 6 is intended to use 2009–2011 as stated in the appendix or the supplied 2011–2012 path.
2. If 2009–2011 is intended, request the missing raw-year preparation and analysis instructions; do not infer a replacement stage from the current scripts.
3. If the delivered 2011–2012 path is the intended version, record that resolution and keep the six-file DOL input route.

Validation to perform later:

- Confirm the selected years against the author’s intended Section 6 sample before execution.

### A_PATH_MAP: Map the author-specific absolute data and results roots to the authorized current execution layout.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_PATH_MAPPING
Evidence: E_ABSOLUTE_PATHS, E_BC_APPEND, E_COMP_INPUT, E_COMP_MERGES, E_4B_IN, E_STAGE6_APPEND, E_STAGE7_DATA

Preparation / proposed procedure:

1. Once the required raw and prepared files are available, establish one data root and one results root for the Stata workflow.
2. Update or configure the absolute [redacted-path-83ec4cc1f6ff] paths in the supplied Stata stages to those roots, keeping all producer and consumer filenames aligned.
3. Keep the order (0a)->(1)->(2)/(3), (4a)->(4b)->(5), and (0b)/(0c)->(6)->(7).

Validation to perform later:

- Before authorized execution, confirm every referenced input path exists and every prior-stage output is located where its consumer expects it.

### A_SOURCE_BYTE: Obtain an author-confirmed clean source statement for the Stage 4a CD default assignment.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SOURCE_BYTE
Evidence: E_SOURCE_CONTROL_BYTE

Preparation / proposed procedure:

1. Ask the authors for the intended line 355 or an uncorrupted copy of the Stage 4a source.
2. Do not infer or silently replace the token from adjacent lines; preserve the confirmed source before deciding whether an exact edit is warranted.

Validation to perform later:

- After receiving the confirmed source, inspect the affected line and its file hash before any separately authorized execution.

### A_XTSCC_SETUP: Provision the required xtscc command in the Stata 18 environment using its documented repository route.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_XTSCC
Evidence: E_SW_XTSCC, E_XTSCC_CALL, E_PUBLIC_XTSCC, E_ENV_STATA

Preparation / proposed procedure:

1. In a separately authorized setup step, obtain the SSC xtscc package and place the ado files on the Stata 18 adopath.
2. Preserve the supplied xtscc estimator options and commands.

Validation to perform later:

- In the intended Stata 18 environment, run which xtscc and confirm the command resolves before executing the author programs.

### A_FM_SETUP: Provision the author-documented fm command required by Stage 2.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_FM
Evidence: E_SW_FM, E_FM_CALL, E_PUBLIC_FM, E_ENV_STATA

Preparation / proposed procedure:

1. In a separately authorized setup step, obtain fm.ado from the author’s linked source and place it on the Stata 18 adopath.
2. Confirm the supplied command supports the byfm(year) syntax used by Stage 2; do not replace the estimator.

Validation to perform later:

- In Stata 18, run which fm and confirm the ado command resolves with the expected syntax.

### A_TABSORT_SETUP: Identify the author-required tabsort ado/package source before preparing the Stage 5 portfolio-sort branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: S_TABSORT
Evidence: E_SW_TABSORT, E_TABSort_CALL, E_ENV_STATA

Preparation / proposed procedure:

1. Ask the authors to identify the exact tabsort ado/package version and provide its authorized distribution route.
2. Place the confirmed command and any documented dependencies on the Stata 18 adopath; do not substitute a different sorting command.

Validation to perform later:

- In the intended Stata 18 environment, run which tabsort and confirm both Stage 5 calls resolve.

### A_DOL_LAYOUT: Verify year-specific DOL file-layout columns against the supplied 2011/2012 transformations.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_DOL_LAYOUT, R_DOL_2011_12
Evidence: E_PUBLIC_DOL11, E_PUBLIC_DOL12, E_PUBLIC_DOL_GUIDE, E_PUBLIC_DOL_ACK, E_APPENDIX_DOL_FIELDS, E_STAGE6_DOL11_H, E_STAGE6_DOL12_H

Preparation / proposed procedure:

1. For 2011 and 2012 separately, compare the official Form 5500, Schedule H and Schedule SB dictionaries/layouts to the supplied `insheet` input names and transformation fields.
2. Confirm each file contains the expected ACK_ID and relevant filing/year fields and note any year-specific naming or removed-field differences.
3. If a required variable is unavailable or has a different raw name, request author guidance before changing code or claiming compatibility.

Validation to perform later:

- Record an exact 2011/2012 column-to-code mapping for the six input CSVs and confirm the Stage 6/7 variables are supported before authorized execution.


## Remaining issues and prerequisites

- I_PATH_MAPPING [unresolved; full_pipeline]: Supplied stages use absolute [redacted-path-83ec4cc1f6ff] paths for raw data, intermediate files and results; the intended current workspace roots and output locations are unspecified.
- I_SOURCE_BYTE [unresolved; full_pipeline]: Stage 4a line 355 contains a literal backspace byte between C and D in a replace statement, adjacent to the CD industry-variable assignments. Its parse/execution effect and intended token are not confirmed; do not guess a repair.
- I_DOL_PERIOD [unresolved; full_pipeline]: Online appendix narrative says Section 6 uses DOL 2009–2011, whereas the supplied preparation scripts process 2011 and 2012 and the analysis uses 2012. No supplied code closes the 2009–2010 branch; confirm whether the appendix narrative or delivered code is the intended target.
- I_GIM_COVERAGE [unresolved; full_pipeline]: The author page and local RiskMetrics catalog candidate list GIM coverage through 2006 while the sponsor dataset includes 2007. Stage 5 conditions a governance regression on nonmissing g; exact author/local source mapping, overlap coverage and expected model observation counts remain unverified. No requirement for complete 2007 g values or imputation is inferred.
- I_DOL_LAYOUT [unresolved; full_pipeline]: The official page and general guide establish the 2011/2012 DOL product, CSV format and ACK_ID linkage, and the appendix supplies variable definitions; the year-specific Schedule H/SB file-layout fields needed by the supplied transformations have not been compared directly. Confirm exact headers before treating the public route as compatible.
- R_BC_RAW [undetermined]: Nine author-format BC Form 5500 Stata files raw5500-1999-1.dta through raw5500-2007-1.dta. Stage 0a appends these into raw5500_all.dta for the Section 4 workflow; required years are 1999–2007.
- R_DOL_2011_12 [undetermined]: Joint 2011 and 2012 DOL Form 5500, Schedule H and Schedule SB Latest CSVs. Stages 0b/0c create raw_2011.dta and raw_2012.dta; Stage 6 appends them and needs 2011 as the prior year for the 2012 contribution-change calculation; Stage 7 analyzes 2012.
- R_COMP_CORE [undetermined]: Compustat annual fundamentals input pension.dta used by Stage 4a. The analysis sample is 1999–2007, but Stage 4a explicitly uses 1998 prior-year values to construct lag-based accrual, sales-growth and industry-growth variables for 1999.
- R_COMP_PENSION [undetermined]: Compustat pension-accounting input pension_robust.dta, merged by gvkey and datadate in Stage 4a. Stage 5 uses the resulting ppror and pbarr values for sponsor robustness analyses; the matched analysis years are 1999–2007.
- R_GRAHAM_TAX [undetermined]: Graham marginal tax-rate file taxrates.dta, merged in Stage 4a by gvkey and fyear and used as tax1 in Stage 5 robustness analyses. Matched years are 1999–2007.
- R_GIM [undetermined]: Gompers–Ishii–Metrick governance input Gindex.dta, merged by gvkey and fyear in Stage 4a and used as g in Stage 5 sponsor regressions. The author page and a local RiskMetrics catalog candidate list 1990–2006; exact field/key mapping and expected model observation counts remain to be confirmed.
- S_XTSCC [preparation_required]: xtscc is invoked in Sections 4 and 5 but is not found in the checked Stata adopaths; the repository route documents SSC distribution.
- S_FM [preparation_required]: fm is invoked in Stage 2 and is not found in the checked Stata adopaths; the author documents the command and linked fm.ado source.
- S_TABSORT [preparation_required]: tabsort is invoked for Stage 5 portfolio-sorting results and is not found in the checked Stata adopaths; its source/package identity remains to be obtained from the authors.

## Review notes

- The scope includes all eleven supplied Stata stages and every one of the 25 frozen dependency IDs. Additional source reads not represented by frozen IDs are recorded manually: Stage 4a also reads pension_robust.dta, taxrates.dta and Gindex.dta; Stage 6 appends raw_2011.dta after raw_2012.dta; Stage 7 consumes the data file created by Stage 6.
- Producer-consumer order is (0a)->(1)->(2) and (3) independently; (4a)->(4b)->(5), with Stage 4b also consuming longevity from Stage 1; and (0b)/(0c)->(6)->(7). Stage 6 needs 2011 as the prior year for the 2012 contribution-change variable.
- No analysis_only scope is supported: Ident_Sec4.xlsx, Ident_Sec5.xlsx and Ident_Sec6.xlsx are sample identifier lists, not full analysis datasets. Their bounded first-row probes establish columns/readability only and do not prove data coverage.
- The online appendix says Section 6 uses 2009–2011, but the provided cleaning and analysis code imports 2011–2012 and analyzes 2012. The assessment follows supplied executable code for actual raw reads and records the documentary mismatch as unresolved rather than inventing a missing 2009–2010 workflow.
- DOL publicly lists the required 2011/2012 products and general CSV/ACK_ID structure, but the exact year-specific Schedule H/SB fields have not been directly compared with the author transformations; the DOL route therefore remains unverified pending that comparison.
- The datasheet mentions hand-collected mortality information, but Stage 1 reads mortality-table labels from Form 5500 and embeds life-expectancy values in code. Stage 7 embeds 2010–2013 monthly three-segment rates and generates twelve-month leads/lags. These historical origins do not create separate raw-file requirements to run the supplied workflow.
- Local Compustat SAS probes are one-row field/readability checks. They do not establish author-file equivalence, 1998–2007 coverage, merge-key uniqueness or complete required-variable coverage.
- Stata 18 and estout are available by same-run probes; xtscc, fm and tabsort are not found in the checked adopaths. No author programs were executed, no datasets downloaded, and no software installed.
- The frozen local catalog also lists RISK.GSET at ${ACCTREPL_SAS_ROOT}/riskmetrics/governance/gset.sas7bdat, labeled RiskMetrics Governance Legacy 1990–2006, with GINDEX labeled Governance Index (Gompers, Ishii, Metrick) and source fields YEAR, CIK and TICKER. This is an unverified local candidate only; it was not probed, and mapping to author gvkey/fyear/g remains unknown.
