# Patch proposal: jar-59f09391a9da

Negative News and Investor Trust: The Role of $Firm and #CEO Twitter Use

DOI: 10.1111/1475-679X.12217

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow for the primary, follow-up, supplemental, and replication experiments, including embedded SPSS analysis fragments and the manual AMOS model recipe.

Entry points: `egh-datasheet-and-code.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 5/12217 - Negative-News-and-Investor-Trust-The-Role-of-Firm-and-CEO-Twitter-Use/egh-datasheet-and-code.pdf",
      "sha256": "ead394fe8e0076c29f9ae467d1b65d04d4a9b9cf28f9871eb863f25245455abd"
    },
    {
      "path": "JAR-Volume 56/Issue 5/12217 - Negative-News-and-Investor-Trust-The-Role-of-Firm-and-CEO-Twitter-Use/egh-research-materials.pdf",
      "sha256": "01216cdeac4f18f17ce059ebcba2d6fb2a6888db289c54ecdfea068a8e7a107e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "b244db86688aa03c98c0f2147fe203c634700645bb582dd54ecc2e5af03692f6"
}
```

## Proposed actions

### A_DATA_AND_PREP_SPEC: Obtain the experiment-level inputs and missing raw-to-final preparation contract before attempting the full workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EXPERIMENT_DATA, I_EXPERIMENT_DATA, I_PREPARATION_WORKFLOW
Evidence: E_COLLECTION, E_PROMISED_PREPARATION, E_PACKAGE_INVENTORY, E_TABLE1_DESCRIPTIVES, E_TABLE1_ANCOVA, E_SPSS_FIELDS

Preparation / proposed procedure:

1. Ask the authors for the complete response CSVs and processing contract for the primary, follow-up, supplemental, and replication experiments. If only an author-prepared final dataset is offered, record it as a potential analysis-only route only after verifying its compatibility and completeness.
2. Request the omitted Excel preparation steps or code that transforms raw responses into the final analysis dataset, including file/worksheet selection and variable construction.
3. Reconcile the supplied primary-analysis fields prelimwillinvest, finalwillinvest, condition, medium, source, AFFECTIVE1–5, and COGNITIVE1–5; request the field mappings for any other experiments and analyses.

Validation to perform later:

- Confirm the received input route and its file formats, fields, sample coverage, and preparation status against the authors’ specifications.
- After inputs are available, run bounded readability/metadata checks and compare the prepared analysis variables with all supplied SPSS and AMOS steps.

### A_COMPLETE_ANALYSIS_SPEC: Complete the analysis map beyond the supplied Table 1/Table 2 syntax and Table 3/Figure 3 manual recipe.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_OTHER_ANALYSES
Evidence: E_SPSS_TABLES, E_AMOS_RECIPE, E_AMOS_SPEC

Preparation / proposed procedure:

1. Request exact SPSS syntax or complete executable instructions for the remaining reported tables and experiment-specific analyses; the datasheet says similar code was used but provides only selected analysis fragments.
2. Confirm the AMOS estimation, missing-data, and output settings intended for the described two-group model if defaults are not sufficient to identify the reported results.
3. Map each supplied and returned analysis entry point to the paper tables and figures without omitting any reported branch.

Validation to perform later:

- Verify that every reported analysis has a documented input, entry point, software step, and output target before execution.

### A_VERIFY_SOFTWARE: Verify compatible statistical and spreadsheet applications after the intended analysis and data-preparation steps are known.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SPSS, S_AMOS, S_EXCEL, I_REQUIRED_SOFTWARE
Evidence: E_COLLECTION, E_SOFTWARE_PATH

Preparation / proposed procedure:

1. Check whether an available IBM SPSS Statistics release runs the supplied MEANS and UNIANOVA syntax while preserving the documented methods and defaults; the reported historical versions are 23 and 24, but no incompatibility is established.
2. Check whether an available IBM SPSS Amos release can implement the documented two-group model while preserving its indicators, paths, grouping, and intended defaults; versions 23 and 24 are reported historically, not established as mandatory.
3. Once the Excel preparation recipe is available, assess Microsoft Excel or the available LibreOffice 25.2.3.2 as the spreadsheet application for that exact recipe; do not assume or reject equivalence before checking the required features.

Validation to perform later:

- Record bounded version checks for the exact SPSS/AMOS and spreadsheet applications considered.
- Validate syntax/model behavior and the spreadsheet preparation against author instructions before any execution with the study data.

### A_RUN_WORKFLOW: After the input, preparation, and software gaps are resolved, execute the documented workflow without changing samples, variables, or analyses.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_EXPERIMENT_DATA, I_PREPARATION_WORKFLOW, I_OTHER_ANALYSES, I_REQUIRED_SOFTWARE
Evidence: E_COLLECTION, E_SPSS_TABLES, E_AMOS_RECIPE, E_AMOS_SPEC

Preparation / proposed procedure:

1. Apply the author-provided CSV-to-final-dataset preparation steps in Microsoft Excel or a spreadsheet application verified against the recipe.
2. Run the supplied SPSS MEANS and UNIANOVA fragments and all returned syntax for the remaining tables and experiments in a verified compatible SPSS release.
3. Build the documented two-group AMOS model with its stated indicators, paths, coding, and source groups, then produce Table 3 and Figure 3 outputs.

Validation to perform later:

- Compare all outputs against the paper’s reported tables and figures and record exact runtime versions and any unresolved discrepancies.


## Remaining issues and prerequisites

- I_EXPERIMENT_DATA [unresolved; full_pipeline]: This release supplies no participant response or analysis dataset. Author-prepared data availability, route, schema, and coverage across the primary, follow-up, supplemental, and replication experiments remain unverified; no access barrier has been established.
- I_PREPARATION_WORKFLOW [unresolved; full_pipeline]: The datasheet says code to convert raw data into the final dataset is included, but the document supplies no Excel/raw-to-final transformation steps or code. CSV processing in a spreadsheet is mentioned; the exact preparation recipe and resulting schema remain unknown.
- I_OTHER_ANALYSES [unresolved; full_pipeline]: The PDF supplies SPSS syntax for Table 1 and Table 2 and a manual AMOS recipe for Table 3/Figure 3, but describes rather than supplies similar syntax for other tables. Exact coverage and code for other tables and experiment-specific analyses are not provided; the scope of the selected fragments beyond the primary experiment is unresolved.
- I_REQUIRED_SOFTWARE [unresolved; full_pipeline]: Availability and compatibility of the authors’ SPSS/AMOS software and spreadsheet workflow are not verified. The bounded PATH lookup found no spss, stats, amos, or excel command, which does not establish absence elsewhere. LibreOffice is available as a spreadsheet candidate; its compatibility cannot be assessed until the author preparation recipe is known.
- R_EXPERIMENT_DATA [undetermined]: Participant response CSVs or compatible final analysis datasets for the primary, follow-up, supplemental, and replication experiments. The supplied analyses require prelimwillinvest, finalwillinvest, condition, medium, source, AFFECTIVE1–AFFECTIVE5, and COGNITIVE1–COGNITIVE5 for documented primary analyses; inputs and fields for other reported analyses remain unspecified.
- S_SPSS [unverified]: The authors report using SPSS versions 23 and 24. The bounded PATH probe found neither spss nor stats; installation and compatibility of any local release are unverified. No incompatibility evidence makes the historical versions mandatory.
- S_AMOS [unverified]: The authors report using AMOS versions 23 and 24 for the manual Table 3/Figure 3 model. No amos command was found by the bounded PATH probe; installation and compatibility of any local release are unverified. No incompatibility evidence makes the historical versions mandatory.
- S_EXCEL [unverified]: The datasheet says CSV data were processed in Excel but gives no version or preparation recipe. No excel command was found by the bounded PATH probe. LibreOffice 25.2.3.2 is available as a candidate; its suitability cannot be assessed until the required preparation steps are known.

## Review notes

- No analysis_only scope is supported: the package supplies no prepared analysis dataset or verified compatible route to one. A route can be reconsidered if the authors provide a complete, compatible prepared dataset.
- The static parser reports no supported code, but the PDF itself contains substantive SPSS syntax and a manual AMOS recipe; has_code is therefore true and the document is the exact entry point/container, not a standalone driver.
- The research-materials PDF is primary-experiment experimental stimuli. It is not evidence of participant response data or a complete analysis workflow.
- No commercial raw-data source is named, and the work item has no dependency checklist entries. The author-prepared data route and preparation contract remain unverified; this uncertainty is not evidence of a restricted or unavailable route.
- The PATH software probe is bounded and does not establish absence from other locations or licensing. LibreOffice is a candidate for the spreadsheet stage, pending comparison with the actual preparation recipe.
