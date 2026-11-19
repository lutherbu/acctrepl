# Patch proposal: jar-f1e5e53221e8

How Do Information Access Tools Change Investors’ Reactions to Managers’ Disclosure Choices? The Role of Mobile Devices and Information Choice Within

DOI: 10.1111/1475-679X.12299

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied primary-analysis target: three experiment branches and all embedded SPSS syntax for Tables 1–5, plus the documented raw CSV/Excel preparation handoff. The only supplied program is embedded in Grant Datasheet.pdf; it is not directly executable or a complete driver. The online appendix reports separate-administration tables but supplies no separate analysis program, so these remain contextual.

Entry points: `Grant Datasheet.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 3/12299 - How-Do-Information-Access-Tools-Change-Investors-Reactions-to-Managers-Disclosure-Choices-The-Role-of-Mobile-D/grant-datasheet-and-research-materials.zip",
      "sha256": "f4f6ef4563af9b43351abd411dd888d7b73c2c7f825d1f32d52e3668d71bf7f2"
    },
    {
      "path": "JAR-Volume 58/Issue 3/12299 - How-Do-Information-Access-Tools-Change-Investors-Reactions-to-Managers-Disclosure-Choices-The-Role-of-Mobile-D/grant-online-appendix.pdf",
      "sha256": "0fa50fd623231108d5a818f5f5970ce6e627ee8563a94bc4b836bc6958d15cc8"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "a92ed1c29d16da3d315fd3721091ef40f299a8b6f5e8cf79b6f7c81ec4dbb1e4"
}
```

## Proposed actions

### act_obtain_data: Locate or obtain the author-provided participant response files for all three experiments, with the format, fields and administration coverage documented. Use an author-prepared analysis dataset if supplied; do not substitute a newly run experiment.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: data_exp1, data_exp2, data_exp3, issue_data_missing
Evidence: DS_data, INV_docs_only

Preparation / proposed procedure:

1. Identify the exact author-provided files and their CSV, Excel or SPSS format.
2. Confirm that the files contain all records used in the pooled primary analyses for each experiment and retain the documented administration coverage.
3. Provide a data dictionary with types and coding for condition, spatial_layout, info_choice and each experiment-specific dependent/process variable.

Validation to perform later:

- After a separately authorized run, verify readable files, required columns, coded levels and the primary-analysis sample counts against the author materials.

### act_clarify_prep: Obtain the missing author processing and input contract before attempting the raw-to-final stage. Preserve the three experiment branches and the distinction between the paper’s pooled primary results and the appendix’s separate-administration results.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_prep_import_driver
Evidence: DS_code_claim, DS_vars, MAT_exp2, APP_scope

Preparation / proposed procedure:

1. Document the raw CSV and Excel files, the spreadsheet processing steps and output schema, including how condition is constructed or labeled.
2. Confirm whether the SPSS inputs are pooled files or separate administration files and document the intended merge/append operation.
3. Do not include Mplus as a required runtime unless an actual supplied primary-analysis workflow invokes it; no Mplus program appears in the supplied documents.

Validation to perform later:

- Compare each documented output field and row set with all Tables 1–5 SPSS commands before selecting an input file.

### act_extract_spss: Prepare a working-copy SPSS source from the embedded datasheet syntax after the input contract is known; the PDF is the code container and is not directly executable.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: issue_prep_import_driver
Evidence: DS_code_claim, DS_E1_T1, DS_E1_T2, DS_E2_T3, DS_E2_T4, DS_E3_T5

Preparation / proposed procedure:

1. Extract and reflow the Table 1–5 syntax into a working copy, preserving every author command, factor, dependent variable, criterion and table branch.
2. Organize execution so each experiment uses its compatible dataset and SPLIT FILE state; do not run the syntax against any data until the import contract and experiment boundaries are documented.
3. Add only the confirmed imports and input paths to a future driver; do not infer condition coding or change the authored tests.

Validation to perform later:

- After a separately authorized run, verify the SPSS output tables and sample counts against the matching primary tables.

### act_split_state: In the extracted working copy, preserve the author’s split-file simple-effects and crosstab analyses while controlling state between ungrouped table procedures and experiment datasets.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: issue_split_state
Evidence: DS_E1_T1, DS_E1_T2, DS_E2_T3, DS_E2_T4, DS_E3_T5, IBM_SPLIT_FILE

Preparation / proposed procedure:

1. Organize the extracted syntax into explicit table blocks and bind each block to the confirmed experiment dataset.
2. Run ungrouped MEANS, UNIANOVA and overall CROSSTABS blocks with split processing off; activate SPLIT FILE only for the authored simple-effect or subgroup blocks.
3. After each grouped block, turn splitting off before moving to a later ungrouped procedure or dataset; alternatively run independent blocks in fresh sessions while preserving their active dataset and exact command sequence.

Validation to perform later:

- After a separately authorized run, verify that each output has the expected overall or subgroup structure and matches the corresponding author table.

### act_spss_runtime: Verify an authorized IBM SPSS Statistics installation and its version before executing the embedded syntax; the bounded PATH result is inconclusive about separate GUI installations.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: software_spss
Evidence: DS_code_claim, PROBE_REQUIRED_SOFTWARE

Preparation / proposed procedure:

1. Confirm the SPSS Statistics installation and release available for a future authorized run.
2. Record version and verify support for the invoked MEANS, UNIANOVA, T-TEST, CROSSTABS and SPLIT FILE commands without changing the authored statistical specifications.

Validation to perform later:

- In a future authorized run, confirm the syntax parses in the verified SPSS release and review the output diagnostics.

### act_excel_runtime: Verify the spreadsheet software and exact workbook used for the documented CSV-to-Excel preparation once the author processing instructions are available.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: software_excel
Evidence: DS_data, MAT_exp2, PROBE_REQUIRED_SOFTWARE

Preparation / proposed procedure:

1. Obtain the author’s processing workbook or precise instructions and confirm whether Microsoft Excel is required for its formulas, macros or import behavior.
2. Verify a compatible authorized spreadsheet application; do not treat an untested alternative as equivalent.

Validation to perform later:

- After the input contract is documented, compare the spreadsheet-generated output schema and values to the expected SPSS input before a separately authorized run.


## Remaining issues and prerequisites

- issue_data_missing [unresolved; full_pipeline]: The frozen package inventory contains no participant response files. The required experiment inputs and any author-prepared acquisition route remain unspecified. The datasheet marks proprietary data as not applicable, so no access barrier or license restriction is inferred.
- issue_prep_import_driver [unresolved; full_pipeline]: The datasheet says code converts raw data to a final dataset, but the supplied document contains only embedded analysis syntax: no CSV/Excel processing recipe, file paths, import steps, complete executable driver, or mapping for condition. The exact input data and preparation outputs therefore cannot be closed.
- issue_split_state [preparation; full_pipeline]: The syntax excerpts turn SPLIT FILE on for the authored simple-effect and subgroup blocks and do not show resets before later ungrouped table procedures. IBM documents the setting as session-persistent. In the extracted working copy, run overall MEANS, UNIANOVA and CROSSTABS blocks with splitting off, then activate only the authored grouped tests and reset afterward or use fresh per-table sessions. This is a supported runner configuration; preserve all grouped tests and table branches.
- data_exp1 [undetermined]: Participant-level Experiment 1 data used by the pooled primary analyses in Tables 1–2, with the consumed fields condition, spatial_layout, info_choice, valuation and time_spent. The documented administrations were collected in November 2016 and December 2017–February 2018 (324 participants total); confirm how the administrations are represented and combined.
- data_exp2 [undetermined]: Participant-level Experiment 2 data used by the pooled primary analyses in Tables 3–4, with the consumed fields condition, spatial_layout, info_choice, fundamental_value and ni_adjustment. The documented administrations were collected in September 2015 and December 2017–February 2018 (238 participants total); confirm how the administrations are represented and combined.
- data_exp3 [undetermined]: Participant-level Experiment 3 data used by the pooled primary analyses in Table 5, with the consumed fields condition, spatial_layout, info_choice and valuation. The documented administrations were collected in November 2016 and December 2017–February 2018 (225 participants total); confirm how the administrations are represented and combined.
- software_spss [unverified]: The embedded Tables 1–5 syntax requires SPSS commands MEANS, UNIANOVA, T-TEST and CROSSTABS. The author release is unspecified. The bounded lookup did not find `spss` in PATH, but did not inspect for a separate GUI installation or infer a license barrier.
- software_excel [unverified]: The datasheet documents Excel processing of the downloaded CSV data. No Excel release is specified; the bounded lookup did not find `excel` in PATH and does not establish whether a separate GUI or compatible installation is available.

## Review notes

- The datasheet title is “How Does Using a Mobile Device Change Investors’ Reactions to Firm Disclosures?”; retain the frozen work-item title and DOI in the assessment header.
- The supplied SPSS syntax covers the primary Tables 1–5 for Experiments 1–3. The appendix’s per-administration tables are described as additional analyses but no corresponding code is supplied; do not expand the required supplied-program target to infer those analyses.
- SPSS command blocks repeat SPLIT FILE and do not show explicit resets between table excerpts. IBM command documentation confirms persistence within a session; the proposal preserves the grouped tests and controls state before the next ungrouped table block.
- The datasheet marks the proprietary nature of the data “Not applicable”; the package has no participant response files, but no restricted-access barrier or public acquisition route is established.
- The static audit’s no_supported_code result is a parser coverage limitation for PDF-embedded syntax; the datasheet itself contains substantial SPSS programs, so has_code is true and the syntax is retained in scope.
- The datasheet describes Microsoft Excel and Mplus historically. The supplied analysis syntax is SPSS; Mplus is not a required runtime absent an invoked workflow. SPSS and Excel availability remain unverified; IBM documentation confirms SPLIT FILE persistence, handled through the supported runner configuration above.
