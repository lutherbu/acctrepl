# Patch proposal: jar-d3560b158ba9

The Tone from above: The Effect of Communicating a Supportive Regulatory Strategy on Reporting Quality

DOI: 10.1111/1475-679X.12205

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented field-experiment workflow, including raw-data preparation, the main analyses, additional analyses, and both pretests reported in the online appendix. The partial Stata preparation code is embedded in vdwm-datasheet.pdf; this is a document-container reference, not a directly executable program or complete driver.

Entry points: `vdwm-datasheet.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 2/12205 - The-Tone-from-above-The-Effect-of-Communicating-a-Supportive-Regulatory-Strategy-on-Reporting-Quality/dmvw-accepted-proposal.pdf",
      "sha256": "08fa2a022d359d4d12f51a48355ccdf7be0e9c77dbac57864a28dcecd759ffcd"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12205 - The-Tone-from-above-The-Effect-of-Communicating-a-Supportive-Regulatory-Strategy-on-Reporting-Quality/dmvw-online-appendix.pdf",
      "sha256": "a108e7c4e7e7161fc82ef86b42a9e528232d322c807ba7acb27bc9caa090b8a6"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12205 - The-Tone-from-above-The-Effect-of-Communicating-a-Supportive-Regulatory-Strategy-on-Reporting-Quality/vdwm-datasheet.pdf",
      "sha256": "8cbcc4b04c938d50c9d0db8624c1e3a78ab6727a7e82217766658264be216215"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "0ca967eb234b5ce321148b96f2fcd11e4dd19265b32379260a23c29bb44892c2"
}
```

## Proposed actions

### A1: Confirm an authorized AFM data-access route and obtain the author-defined input schema and complete preparation/analysis workflow for the field experiment.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R1, I1, I2
Evidence: E1, E2, E3, E4, E5, E7, E8, E9, E10, E17, E18, E19, E20, E21

Preparation / proposed procedure:

1. Ask the authors/AFM whether replication can be conducted through an approved secure setting or another authorized controlled route, or whether the retained author-prepared Stata analysis data can be made available under AFM rules. Do not assume public redistribution.
2. Request the delivered field names, item/column mapping, treatment and batch assignments, submission/admin fields, identifier linkage, and the author mapping of Market Monitor wave labels to the reporting-year variables used in the datasheet.
3. Obtain the complete preparation and analysis program, or author confirmation that the data sheet is the complete manual recipe for the main analysis and all listed additional tests, including its omitted input and output steps.

Validation to perform later:

- After the required authorized inputs and workflow are available, reproduce the author-defined sample and compare all main and additional analysis outputs with the paper and online appendix.

### A2: Request the author-held pretest data and analysis details needed to reproduce the appendix pretest tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R2, I1, I3
Evidence: E11, E12

Preparation / proposed procedure:

1. Request the anonymized respondent-level records, treatment assignments, questionnaire/item definitions, exclusions, covariates, construct/factor scoring and analysis inputs for both pretests, with access conditions.

Validation to perform later:

- Reproduce the pretest sample counts and Tables A-1 through A-3 from the author-supplied data and method details.

### A3: Identify and prepare the exact author-used digidis Stata command for the documented Benford analysis.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S2, I4
Evidence: E5, E15

Preparation / proposed procedure:

1. Ask the authors for the digidis command source/version or other documentation that establishes the exact invoked implementation.
2. If authorized source is provided, install/configure it in the Stata adopath only in a future authorized setup. Do not substitute an inferred command.

Validation to perform later:

- In a future authorized environment, confirm `which digidis` resolves to the documented command before the Benford analysis.

### A4: Verify a compatible spreadsheet runtime for the authors’ documented Excel preparation steps.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S3, I5
Evidence: E4, E16, E21

Preparation / proposed procedure:

1. Obtain any author workbook/template needed for the manual formulas and confirm whether the authors require Microsoft Excel or support a compatible spreadsheet runtime.
2. If using LibreOffice Calc, validate the author-prescribed formulas and imported/exported values against author-prepared examples before relying on it.

Validation to perform later:

- Confirm each documented formula/import step yields the author-specified values and preserves expected variable types and missing-value handling on an authorized validation input.

### A5: Run the full author-confirmed workflow only after required data, preparation instructions and command/software prerequisites are available.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I1, I2, I3, I4, I5
Evidence: E4, E5, E9, E10, E11, E12, E13, E17, E18, E19, E20, E21

Preparation / proposed procedure:

1. Follow the author-confirmed sequence for preparing the AFM response and administrative records, constructing the reporting-quality and control variables, and analyzing the field experiment.
2. Include the documented year-over-year change, fairness, Benford, timeliness and effort analyses, and the separate pretest analyses; do not omit the appendix outputs from the assessed scope.

Validation to perform later:

- Compare the resulting main, additional and pretest samples and reported tables with the paper and online appendix.


## Remaining issues and prerequisites

- I1 [unresolved; full_pipeline]: The package includes substantive partial Stata preparation code embedded in the data sheet (standardization, transformations, interactions, change measures and additional outcomes), together with Excel formulas and manual steps. vdwm-datasheet.pdf is only a document-container reference: it has no complete import/preparation/analysis driver or standalone executable entry point, and no analysis data file. Obtain the complete author workflow or confirmation that the documented manual recipe is complete, along with its input schema and output mapping.
- I2 [unresolved; full_pipeline]: AFM raw Market Monitor data and the retained Stata file are described as proprietary and retained by AFM; the authors had secured/on-site access. The package does not establish a permitted access route for an external replicator or confirm the required historical fields and identifiers.
- I3 [unresolved; full_pipeline]: Pretest respondent data, question/item details and factor-analysis information are described as available upon request but are not included; access and the complete replication inputs remain unverified.
- I4 [preparation; full_pipeline]: The documented Benford analysis calls digidis; the bounded check did not find that command in the checked Stata paths. The available check does not identify the author-used version or a valid replacement.
- I5 [unresolved; full_pipeline]: The documented preparation uses Microsoft Excel formulas. LibreOffice is installed, but the author’s workbook and formula behavior have not been verified in that runtime; exact Microsoft Excel availability is also unconfirmed.
- R1 [undetermined]: AFM Market Monitor response data and linked assignment/administrative records for the field experiment and its main and additional analyses, including historical observations needed for stratification and year-over-year outcomes. Required item fields include the documented reporting-quality, time-horizon, product, experience, branch/franchise, fairness, time, and response measures; exact delivered columns and wave/year mapping are not in the package.
- R2 [undetermined]: Respondent-level data and assignment/covariate fields for pretests 1 and 2, with questionnaire/item definitions and exclusions needed to reproduce the pretest analyses and online Appendix Tables A-1 through A-3.
- S2 [preparation_required]: The authors name the Stata command digidis for Benford digit distributions. A bounded which check under Stata 18 did not find that invoked command in the checked paths; its author-used source/version is not specified.
- S3 [unverified]: The data sheet documents Excel formulas for manual preparation. Microsoft Excel was not found as an excel command in PATH; LibreOffice 25.2.3.2 is present, but compatibility with the specific workbook/formulas has not been tested.

## Review notes

- The frozen dependency checklist contains zero entries; dependencies were derived from the supplied documents and no dependency IDs were invented.
- No analysis_only scope is justified: the package supplies no prepared analysis dataset and no confirmed compatible route to one.
- The supplied PDF contains substantive partial author Stata preparation code and a multi-step Excel/manual recipe. These establish has_code=true. The entry-point field names vdwm-datasheet.pdf only as a document container for those snippets; it is not directly executable and no complete driver is supplied.
- The scope retains all documented main, additional and pretest analyses. Data access and complete input/workflow closure remain unresolved; bounded software checks are linked to their evidence.
