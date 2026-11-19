# Patch proposal: jar-2069b33ca1b1

Inheriting Versus Developing Data Analytic Tests and Auditors’ Professional Skepticism

DOI: 10.1111/1475-679X.70014

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The full analysis target uses participant responses collected through CentERdata. The document-only release includes the experimental instrument and a datasheet with multiple pasteable SPSS syntax blocks and manual PROCESS steps; the datasheet PDF is the code container, not a directly executable complete driver.

Entry points: `LBGL datasheet.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 2/70014 - Inheriting-Versus-Developing-Data-Analytic-Tests-and-Auditors-Professional-Skepticism/lbgl-datasheet-and-instrument.zip",
      "sha256": "7f9b046d40fe733bd03ae97d4d974e4c60aebd12dc937ab7a280f9b36b8f4362"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "be620741b5af24d379d25f3807713e6bff801f2a01349044548124c68a2d112f"
}
```

## Proposed actions

### A_DATA_ACCESS: Confirm whether a replication analyst can use the archived participant responses under CentERdata's permitted secure-environment process; do not export materials contrary to the stated agreement.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_PARTICIPANT_RESPONSES, ISSUE_DATA_ACCESS
Evidence: E_SAMPLE, E_REMOTE_ENVIRONMENT, E_EXPORT_BARRIER, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Ask the authors, FAR, or CentERdata whether supervised access for a replication analyst is available and what output controls apply.
2. Use only a permission-granted secure-environment route; do not copy or export data contrary to the nondisclosure agreement.
3. Request the permitted data dictionary and response-field/condition coding metadata needed to map the archived responses to the documented analysis variables.

Validation to perform later:

- Before any separately authorized analysis, confirm that the input covers the stated 173-participant study and that required response and condition fields map to the datasheet definitions.

### A_WORKFLOW_MAPPING: Resolve the response-export schema and raw-field mapping into the named outcomes and condition variables. The supplied PDF syntax is usable after careful reflow; an absent standalone .sps file is not itself a blocker.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_WORKFLOW_CLOSURE
Evidence: E_CODE_IN_DATASHEET, E_ADDITIONAL_TESTING_DEFINITION, E_COMMUNICATE_FLAG_DEFINITION, E_RECODE_SYNTAX, E_MEDIATOR_SYNTAX, E_TRAIT_EMPATHY_SYNTAX, E_CONDITION_CODING, E_H1_VARIABLE_DESIGN, E_H2_VARIABLE_DESIGN, E_PROCESS_MODELS, E_PDF_LAYOUT

Preparation / proposed procedure:

1. Confirm the response-file columns and coding for participant choices, open-ended communication measures, five experimental conditions, and the four analysis-condition codes.
2. Confirm whether INHERIT_DEVELOP, INFORM_INHERIT, and the multicategorical IV are present in the response file or are constructed from the condition field, using the documented definitions without inventing replacement rules.
3. If materializing syntax in a separate working copy, reflow the PDF line wrap in the TRAIT_EMPATHY expression so Item8 remains one variable name; preserve the remaining author definitions and model settings.
4. Confirm whether the secure environment contains a complete original syntax or ordered analysis procedure beyond the selected blocks and PROCESS GUI steps in the datasheet.

Validation to perform later:

- Before a separately authorized run, compare the response-field map and every recode/computed variable against the source definitions and verify the input-to-analysis order.

### A_SOFTWARE_SETUP: Confirm authorized access to the required SPSS, PROCESS, and Excel products and their versions in the chosen analysis environment; no license or installation absence is inferred from the PATH-only check.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SPSS, S_PROCESS, S_EXCEL
Evidence: E_SPSS_LOGISTIC, E_PROCESS_V41, E_EXCEL_FIGURE, E_SOFTWARE_PATH_CHECK

Preparation / proposed procedure:

1. Confirm the available SPSS Statistics release in the authorized environment; the author documentation does not specify a version.
2. Confirm that PROCESS version 4.1 is available within the selected SPSS release and that its documented model options are supported.
3. Confirm access to Microsoft Excel for the reported Figure 1 construction; do not assume another spreadsheet application is equivalent without separate support.
4. If required software is not available in the authorized environment, arrange it through the appropriate licensed or approved distribution channel.

Validation to perform later:

- Use read-only version, installation, or help metadata to confirm the selected software and add-on before any separately authorized analysis; do not run a syntax or statistical trial during this assessment.

### A_RUN_PROCEDURE: After authorized response-data access, input mapping, and software confirmation, reproduce the documented analysis in a separate working copy while preserving the PDFs and original definitions.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_PARTICIPANT_RESPONSES, ISSUE_WORKFLOW_CLOSURE, S_SPSS, S_PROCESS, S_EXCEL
Evidence: E_ADDITIONAL_TESTING_DEFINITION, E_COMMUNICATE_FLAG_DEFINITION, E_RECODE_SYNTAX, E_MEDIATOR_SYNTAX, E_TRAIT_EMPATHY_SYNTAX, E_CONDITION_CODING, E_TABLE1_SYNTAX, E_H1_VARIABLE_DESIGN, E_HYPOTHESIS_LOGIT_SYNTAX, E_H2_VARIABLE_DESIGN, E_H2_LOGISTIC_SYNTAX, E_PROCESS_MODELS, E_PROCESS4_SETTINGS, E_PROCESS8_SETTINGS, E_EXCEL_FIGURE

Preparation / proposed procedure:

1. Work only with the authorized CentERdata response data and first map its fields and condition codes to the instrument definitions.
2. Materialize the supplied SPSS outcome definitions, reverse-code the seven specified trait-empathy items, compute PSYCHOLOGICAL_OWNERSHIP and TRAIT_EMPATHY, and preserve the documented condition contrasts.
3. Produce the Table 1 means by CONDITION and create Figure 1 in Excel from those means.
4. Run the two H1 logistic models with INHERIT_DEVELOP and the two H2 logistic models with INFORM_INHERIT, for ADDITIONAL_TESTING and COMMUNICATE_RED_FLAG, retaining the specified one-tailed tests.
5. Run PROCESS version 4.1 Model 4 and Model 8 for both outcomes with the documented 90% confidence intervals and 5,000 bootstrap samples; use PSYCHOLOGICAL_OWNERSHIP as mediator and TRAIT_EMPATHY as the Model 8 moderator.
6. Preserve the supplied condition coding and reported sequence; do not replace or omit any documented analysis branch.

Validation to perform later:

- In a separately authorized execution, verify the 173-participant input and condition mapping, then compare Tables 1–3 and Figures 1–3 with the published outputs while retaining any permitted secure-environment output restrictions.


## Remaining issues and prerequisites

- ISSUE_DATA_ACCESS [unresolved; full_pipeline]: The participant-level response data are not included, and the authors state that their nondisclosure agreement prohibits export from CentERdata. Whether a replication team can obtain controlled analysis access is unspecified.
- ISSUE_WORKFLOW_CLOSURE [unresolved; full_pipeline]: The datasheet provides selected SPSS syntax and PROCESS GUI steps, but no CentERdata response export, data dictionary, or mapping from the response export and condition codes to the named analysis variables. The input-to-analysis handoff therefore remains unverified; the missing standalone .sps file alone is treated as preparation, not a blocker.
- R_PARTICIPANT_RESPONSES [undetermined]: Participant-level responses and analysis input for the 173-practitioner experiment. The instrument supplies fictional Ruiter case stimuli, not the study response file; the exact exported field schema and replication-team access route are unspecified.
- S_SPSS [unverified]: SPSS is named for the logistic analyses and PROCESS workflow; the author version is unspecified. A bounded PATH lookup found neither spss nor stats, which does not establish whether a licensed installation exists outside PATH or what version would be available.
- S_PROCESS [unverified]: The authors use the PROCESS add-on (version 4.1) within SPSS for Models 4 and 8. The package and bounded software-path check do not establish that this macro is installed or compatible with an available SPSS release.
- S_EXCEL [unverified]: The authors report creating Figure 1 in Excel from Table 1 means; the author version is unspecified. A bounded PATH lookup did not find an excel command and is not a full installation or license check.

## Review notes

- Only one scope is included: full_pipeline. No analysis_only scope is supported because the package has no participant-response file or verified compatible analysis-input route.
- The datasheet contains study-specific SPSS syntax and manual PROCESS steps. This substantive partial code is credited, while the full response-schema and input-to-analysis mapping remain unverified; the missing standalone .sps file alone is not treated as a blocker.
- The exact frozen catalog lookup for CentERdata returned no candidate records. This discovery was not used as evidence of missing data, unavailable licensing, or an access barrier.
- The instrument describes an Excel download/upload used by Develop ADA participants. It is not a separate mandatory analysis input for re-analyzing the existing participant responses; if the target changes to repeating the live experiment, that workbook's availability must be confirmed.
- The PATH-only lookup did not find spss, stats, or excel, but does not prove the software is uninstalled or unlicensed. PROCESS version 4.1 availability and compatibility remain unverified.
- The source caches were byte-screened before display. Candidate contact or connection spans remained withheld and were not treated as proof of secret content or source absence; mask reports and reader-test captures are process-only and are not cited as scientific evidence.
- The original author-page rendering confirmed that Item8 is wrapped across visual lines in the PDF; its variable name is retained when reflowing a working copy. No author source was edited or executed.
