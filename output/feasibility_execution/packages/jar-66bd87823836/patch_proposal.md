# Patch proposal: jar-66bd87823836

The Role of Tacit Knowledge in Audit Expertise and Human Capital Development

DOI: 10.1111/1475-679X.12220

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented analyses for Study 1 and Study 2, including the supplied main and robustness programs embedded in the code PDF. The code blocks require prepared inputs and are not standalone drivers.

Entry points: `BEMP - Code document.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 4/12220 - The-Role-of-Tacit-Knowledge-in-Audit-Expertise-and-Human-Capital-Development/bemp-datasheet-and-code.zip",
      "sha256": "87fd98640f4c414c594828ebfbc73740a3b874f5a7a258b254c5983ed347a82c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "1a0a2433767ce817d3e4a409e59a5d1e1e4ae669f822cc211f1e67880cb08720"
}
```

## Proposed actions

### A_TRANSCRIBE_CODE: Create working .sas and .do copies from the code blocks embedded in the PDF, preserving all supplied model and robustness branches. The PDFs remain the source evidence, not executable files.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_CODE_CONTAINER
Evidence: E_INVENTORY, E_S1_SCOPE, E_S2_SCOPE, E_S1_TABLE4, E_S1_TABLE5, E_S1_TABLE6, E_S1_TABLE7, E_S2_T10A, E_S2_T10B, E_S2_T11

Preparation / proposed procedure:

1. Transcribe the Study 1 SAS code block and the Study 2 Stata code block into separate working files, retaining the shown order and all listed Table 4–7 and Table 10–11 robustness calls.
2. Keep source PDFs unchanged and record the exact transcription against the corresponding pages.
3. Add no guessed data path or import command; configure each working program only after the author-approved input format and location are known.

Validation to perform later:

- Review each transcribed statement and branch against the PDF page images and cached source lines.
- After input specifications are supplied, verify the SAS BEMP and Stata in-memory setup before any authorized full run.

### A_S1_BEMP_ROUTE: Ask for an author-approved, SAS-readable BEMP analysis dataset and its field/format notes, or a permitted secure route to it. If the authors instead require raw-source preparation, request the complete supported BEMP construction workflow; do not infer it from collection history.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_S1_BEMP, I_S1_INPUT
Evidence: E_CONF, E_INVENTORY, E_S1_DATA, E_S1_SCOPE, E_ORIGINS

Preparation / proposed procedure:

1. Confirm whether the prepared BEMP dataset can be shared or accessed under the stated confidentiality terms; the clause explicitly covers raw data and does not establish the status of a derived BEMP file.
2. Obtain the dataset in a format the authors confirm SAS can read, plus its data dictionary and any required session/library configuration.
3. If only raw firm/survey inputs are permitted, obtain the exact author preparation program and approved access procedure instead of independently reconstructing the research.

Validation to perform later:

- Use a bounded read-only metadata check on the authorized file to verify the expected BEMP variables, including manager and idmgr for Footnote 17.
- After the SAS runtime and data route are resolved, confirm the code sees BEMP in the intended session before executing analyses.

### A_S2_PANEL_ROUTE: Request a compatible author-prepared linked/scored Study 2 panel, or author-provided raw-round data and the complete supported scoring/linkage preparation if that is the permitted route.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_S2_PANEL, I_S2_INPUT, I_S2_ALIAS
Evidence: E_CONF, E_INVENTORY, E_S2_SETUP, E_S2_MAP, E_S2_T10A, E_S2_T10B, E_S2_T11, E_MATERIALS_R1, E_MATERIALS_R2

Preparation / proposed procedure:

1. Ask for a Stata-ready panel with the variables consumed by the code, a data dictionary and the authorized access terms. The program already assumes the data are loaded.
2. If the panel is not supplied, request the permitted Round 1 Part 2 and Round 2 Parts 1, 3 and 4 response route, the respondent linkage key, and the complete score/change construction specification; Round 2 Part 2 is explicitly not part of this study.
3. First compare the candidate panel and dictionary to the invoked `change_tkbep` field; if that field is present and consistently defined, leave code unchanged. Request author clarification only if it is absent or ambiguous; do not rename from the crosswalk spelling alone.

Validation to perform later:

- Confirm field names, types, missing-value encodings, wave linkage and the author-defined change calculations from the supplied panel/data dictionary.
- Once permitted data are available, verify that the input contains all columns referenced by the Stata code before running it; do not infer participant counts from instrument pages.

### A_F17_COMPLETE: Configure the Footnote 17 jackknife wrappers from the DV/IV choices already specified by the adjacent Table 4, Table 5 and Table 7 calls; derive each `#` from the corresponding regression sample once BEMP is available.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_F17_TEMPLATE
Evidence: E_F17_PLACEHOLDER, E_F17_MACROS, E_S1_IVMACROS, E_S1_TABLE4, E_S1_TABLE5, E_S1_TABLE7, E_S1_DATA

Preparation / proposed procedure:

1. Map the logit wrapper to Table 4 outcomes `potential_manager` and `potential_partner` with `ivs1`, `ivs2` and `ivs3`; map the OLS wrapper to Table 5 `Overall_Eval` with `ivs2`, `ivs3`, `ivs4` and Table 7 `FirmCommitment` with the printed `ivs5`, `ivs5`, `ivs6` sequence.
2. After the compatible BEMP dataset and each model’s analytic sample are available, derive the corresponding number of managers for each `#` from that sample; do not insert counts from comments or assume one count applies to every regression.
3. Preserve the repeated Table 7 `ivs5` specification as printed unless later authorized evidence supports a correction.

Validation to perform later:

- Check the working wrapper has no `#` placeholders and its DV/IV values match the cited main-table calls, including the repeated Table 7 `ivs5`.
- Verify each substituted manager count against the corresponding regression sample before an authorized run.

### A_ROBUSTNESS_SPEC: Obtain the paper or an author specification list for the robustness variants whose added/replaced independent variables are described only by reference to the paper.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_ROBUSTNESS_SPEC
Evidence: E_S1_SCOPE, E_S2_SCOPE, E_S2_T10B, E_S2_T11

Preparation / proposed procedure:

1. Request the exact Table 4–7 Study 1 and Table 10–11 Study 2 alternative variable/model specifications for branches not fully enumerated in the code document.
2. Keep all visible code branches, including Study 1 Table 6 matching/common-support checks and Study 2 Footnotes 35, 37 and 39; do not drop a branch or guess a substitute regressor.

Validation to perform later:

- Compare the completed branch list with the paper and the code document before execution; record the corresponding model and output for each branch.

### A_SAS_RUNTIME: Resolve the local SAS TKELS startup-service failure and establish the installed SAS release/runtime through an empty-session check; the current evidence does not establish license absence.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, I_SAS_RUNTIME
Evidence: E_ENV, E_SOFTWARE

Preparation / proposed procedure:

1. Have the local SAS environment owner review the TKELS launch-service initialization failure and confirm the approved runtime configuration/entitlement.
2. Do not retry startup until the environment issue is addressed; this assessment does not install software or infer an absent license.

Validation to perform later:

- After remediation, perform one bounded empty-session version query and verify the needed SAS components before loading study data: PROC LOGISTIC, PROC REG, PROC NPAR1WAY, PROC SURVEYSELECT, PROC SURVEYLOGISTIC, PROC SURVEYREG, PROC FREQ, PROC RANK, PROC UNIVARIATE, ODS OUTPUT and the SAS macro facility.

### A_NORMALIZE_OPERATOR: When transcribing the Stata compensation-change line, normalize only the printed U+2010 typography to the ASCII subtraction operator while preserving the author’s square-bracket grouping and formula.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_OPERATOR
Evidence: E_COMPCHANGE, E_STATA_COMBINED, E_STATA_ISOLATED

Preparation / proposed procedure:

1. In the working .do copy, transcribe the line as `gen compchange = [(bonus + salary_current) - salary_init]/salary_init`; retain the square brackets and all operands.
2. Do not use the initial one-observation check to justify a bracket change: it changed both the grouping delimiter and the subtraction character. The isolated zero-observation check confirms bracket grouping parses and isolates U+2010 as the failing character.
3. Do not edit the source PDF or alter the formula/estimator.

Validation to perform later:

- Before using study data, verify the faithfully transcribed line in a bounded empty Stata 18 syntax check.
- After an authorized panel is available, compare the generated value to the author-confirmed compensation-change definition.


## Remaining issues and prerequisites

- I_CODE_CONTAINER [preparation; full_pipeline]: The substantial SAS Study 1 and Stata Study 2 programs are embedded in a PDF, not supplied as directly executable .sas/.do entry files. Both blocks assume that their input datasets have already been made available in-session; the Study 1 block expects BEMP and the Study 2 block operates on the current Stata dataset.
- I_S1_INPUT [unresolved; full_pipeline]: No BEMP dataset, import/staging path or complete raw-to-BEMP producer is supplied. The SAS program therefore cannot be connected to its required prepared input from this package alone. Study 1 collection history is contextual; a compatible author-prepared BEMP dataset is a valid input route and is not assumed unavailable.
- I_S2_INPUT [unresolved; full_pipeline]: No Stata-ready panel is supplied. The program consumes TK levels and changes without producing them, and the packet does not identify the merge key or complete scoring/field mapping. A compatible prepared panel is a valid primary input; reconstruction from raw rounds is only an unverified alternative requiring author specifications.
- I_S2_ALIAS [unresolved; full_pipeline]: Potential spelling discrepancy: the variable crosswalk spells `chage_tkbep`, while the regressions invoke `change_tkbep`. No analysis panel or dictionary is supplied to check the actual input. Compare the candidate panel to the invoked `change_tkbep` field first; if it is present and consistently defined, leave the code unchanged. Request author clarification only if the supplied field is missing or ambiguous.
- I_F17_TEMPLATE [preparation; full_pipeline]: The Study 1 Footnote 17 wrapper contains `#` placeholders and comment-only DV/IV selector bodies. The relevant DV/IV choices map to the same document’s Table 4, Table 5 and Table 7 calls and `ivs1`–`ivs6` definitions; the per-regression manager count can be derived from each actual regression sample after BEMP is supplied. This is a preparation/configuration task, not a request for authors to resupply known model choices or counts now. Preserve the duplicate Table 7 `ivs5` call as printed.
- I_ROBUSTNESS_SPEC [unresolved; full_pipeline]: The code document says several Study 1 and Study 2 robustness variations add or replace independent variables as detailed in the paper, but the paper/specification list is not among the three package files. The visible branches are retained; unspecified replacements are not guessed.
- I_SAS_RUNTIME [unresolved; full_pipeline]: A bounded empty-session SAS start failed at TKELS initialization. The local environment has not established SAS availability/version; this is not evidence of absent entitlement or a missing license.
- I_OPERATOR [preparation; full_pipeline]: The original page and cached text show a U+2010 hyphen in the Stata `compchange` subtraction expression. A zero-observation Stata 18 check rejects that character while accepting ASCII subtraction; the square-bracket grouping itself is accepted. The expression needs faithful typography normalization when transcribed from the PDF into a runnable .do file.
- R_S1_BEMP [undetermined]: A SAS-readable Study 1 analysis dataset named BEMP, loaded in the SAS session before the supplied code runs. It must contain the source columns used for Tables 4–7 and the Footnote 17 jackknife branch: TK_Subordinate, TK_Supervisor, Technical_Perf, Competencies, TeK_Subordinate, TeK_Supervisor, job_level, job_tenure, age, firm_tenure, Overall_Eval, find_job, potential_manager, potential_partner, FirmCommitment, manager, and idmgr. The datasheet describes historical collection sources and periods, but those sources are not separate live inputs to the supplied SAS code when a compatible author-prepared BEMP file is provided.
- R_S2_PANEL [undetermined]: A Stata-ready, linked and scored Study 2 analysis panel already in memory before the supplied Stata code runs. It must include Firm, CPA_BEC, CPA_AUD, CPA_REG, CPA_FAR, perfeval_overall, tk_all, tk_bep, tk_tl, change_tkall, change_tkbep, change_tktl, bonus, salary_init and salary_current. The code does not import or merge rounds, create the three TK measures or calculate the change variables. Study materials say Round 1 Part 2 supplies initial TK measures used for change calculations, Round 2 Parts 1, 3 and 4 are used, and Round 2 Part 2 is outside this study. The `change_tkbep` field is invoked in regressions, while the variable map spells `chage_tkbep`; the intended alias and producer need confirmation.
- SW_SAS [unverified]: The document requires SAS. The local SAS executable path was present, but the bounded empty-session startup failed while initializing TKELS; the SAS release and entitlement were not established, and the failure does not prove a missing license.

## Review notes

- The frozen static audit reports `no_supported_code` and zero dependency edges because PDF-embedded programs were not parsed. Manual review found substantial SAS and Stata programs. The work-item dependency list is empty, so dependency_review is empty rather than inventing IDs; manual gaps are captured as requirements and issues.
- Study 1 code directly consumes a prepared SAS dataset named BEMP. The datasheet’s interviews, proprietary archival collection, and Qualtrics survey are historical provenance; they are not separate live requirements if an author-prepared BEMP dataset is supplied. The package has no BEMP data file.
- Study 2 Stata code starts with a current in-memory dataset and needs a linked/scored panel containing its direct variables. A compatible prepared panel is a valid input route. Round 1 and Round 2 response construction is an alternative only if supplied/authorized; no merge key, score construction, or change-variable producer is documented in the code. The study-materials PDF is instrument/screenshot material, not participant data.
- The confidentiality sentence says the firm identity and raw data from both studies are protected by agreements. This supports a barrier to open redistribution of raw records. It does not establish that author-mediated access is impossible or that processed/anonymized BEMP or Stata panels cannot be made available. Missing files and access conditions are recorded separately.
- Study 1 branches reviewed: Tables 4 and 5; Table 6 Panel A’s two propensity-score matching calls (comments say n=28 and n=40, preserved only as comments) and Panel B common-support OLS; Table 7; and Footnote 17 jackknife logistic and OLS wrappers. Footnote 17 DV/IV selections are available from the same document’s table calls and ivs1–ivs6 definitions; derive per-model `#` counts from the compatible regression samples, and retain the repeated Table 7 ivs5 call. Only paper-referenced robustness variants beyond the visible calls remain unresolved.
- Study 2 branches reviewed: Table 10 Panel A mean/median performance splits across TK-All/TK-BEP/TK-TL; Panel B base, three level/change models and Footnote 35 specifications; Table 11 base/three models, Footnote 37 excluding TK level, total compensation and compensation-change alternatives, and Footnote 39 Big 4-only models. No sample/group counts were added.
- The first one-observation Stata syntax probe changed both square-bracket grouping and the subtraction character; its JSON is preserved and explicitly treated as confounded. The separate copied zero-observation check establishes square brackets parse and the U+2010 character fails, so the proposal normalizes only the subtraction glyph.
- No analysis_only scope is added: there is no supplied or verified compatible analysis dataset route, despite substantial embedded analysis code. No author program or regression, data import, download, installation, SAS retry, source edit, or external contact was performed.
- For `change_tkbep`, inspect an actual candidate panel/dictionary against the code-invoked name first. The crosswalk difference warrants author clarification only if the supplied data remain missing or ambiguous.
