# Patch proposal: jar-3dfed51c3145

Improving Experienced Auditors’ Detection of Deception in CEO Narratives

DOI: 10.1111/1475-679X.12181

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented historical experiment and analysis workflow represented by the datasheet, instrument and all table, figure and footnote blocks in Program Code.pdf. The experiment was conducted in 2012–2013; no new participant collection is inferred as a replication prerequisite.

Entry points: `Program Code.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 5/12181 - Improving-Experienced-Auditors-Detection-of-Deception-in-CEO-Narratives/hmpvdatasheetinstrumentandcode.zip",
      "sha256": "d800afdac8b8bcb1bb3fb984702b93956d96b50222749c15c66f87a196d07c46"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "fe0b135fe9d92e42bcaf43d86c8570e459342ad3bd0244b8d239c7033732c67a",
  "work_item_sha256": "3261a84dfc60168f71bd8c495309ee169b0b5fb0747e7675076df286e4b45c26"
}
```

## Proposed actions

### A-REQUEST-ANALYSIS-DATA: Request the existing author-prepared analysis datasets and data dictionaries needed by the supplied analyses, together with permitted sharing/access details. The datasheet’s historical Qualtrics access statement is not evidence that a third party can obtain the data.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: DATA-FULLDATAFINAL, DATA-CMPNYSENTFRAUDFINAL, DATA-DISFLUENCIES-FIRM, ISS-INPUTS-ABSENT
Evidence: EV-DATASHEET-RAWACCESS, EV-DATASHEET-RETENTION, EV-CODE-FULLDATA, EV-CODE-CMPNY, EV-CODE-DISFLUENCY, EV-INVENTORY

Preparation / proposed procedure:

1. Request fulldatafinal with a dictionary covering every referenced variable, sample and exclusion history, and confirmation that acc_demean is included or separately produced.
2. Request CmpnySentFraudFinal and Disfluencies_firm as distinct required inputs with their field dictionaries and documented coding/construction provenance.
3. Clarify whether the authors can share these historical records and what privacy/access conditions apply; do not recollect participants or independently reconstruct anonymous survey responses.

Validation to perform later:

- After an authorized copy is supplied, inspect exact file metadata and verify every expected field, participant/company keys, sample filters and documented period before analysis.
- Confirm that both companion datasets correspond to the specified table/footnote analyses and are not substitutes for fulldatafinal.

### A-REQUEST-PRODUCERS-AND-SETUP: Request the omitted raw-to-analysis preparation program or complete documented manual recipe, plus exact SAS/Stata file boundaries and handoff instructions for the supplied analyses.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-PRODUCERS-OMITTED, ISS-MIXED-CODE-SETUP
Evidence: EV-DATASHEET-CODE, EV-CODE-FULLDATA, EV-CODE-STATA, EV-CODE-CMPNY, EV-CODE-DISFLUENCY, EV-CODE-LAG-SUBJECT, EV-CODE-LAG-COMPANY

Preparation / proposed procedure:

1. Ask which author-prepared files feed each analysis block and what produces fulldatafinal, CmpnySentFraudFinal, Disfluencies_firm and acc_demean.
2. Request the execution order, SAS and Stata program boundaries, data-loading commands, working-directory/path setup and any separate manual coding steps.
3. Keep the two observed lag-based deduplication steps and all table/figure/footnote blocks in scope; do not infer missing transformations, row history or sample rules.

Validation to perform later:

- Trace each raw data read and final analysis-variable producer once the authors provide the missing program/specification.
- Confirm every supplied table, figure and footnote block has its correct input and language/runtime, and that the existing estimators and sample filters remain unchanged.

### A-VERIFY-SAS-ENVIRONMENT: Resolve SAS environment uncertainty by confirming a working runtime and the required SAS procedures after the observed TKELS startup failure; do not treat the failure as evidence of a missing license.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS, ISS-SAS-ENV-UNVERIFIED
Evidence: EV-ENVIRONMENT, EV-CODE-GLIMMIX, EV-CODE-DISFLUENCY

Preparation / proposed procedure:

1. Have the environment administrator confirm the installed SAS release and a clean session startup, then verify availability of PROC GLIMMIX and PROC MIXED used by the paper analyses.
2. Record any required site-specific runtime configuration or SAS/STAT access condition; do not install or alter packages as part of this assessment.

Validation to perform later:

- A later bounded non-author-code probe should establish successful SAS startup and procedure availability before any authorized analysis run.


## Remaining issues and prerequisites

- ISS-INPUTS-ABSENT [unresolved; full_pipeline]: The frozen package contains no analysis datasets. Program Code.pdf names fulldatafinal, CmpnySentFraudFinal and Disfluencies_firm as inputs; available fields, periods, sample/exclusion history, access terms and compatibility are unverified.
- ISS-PRODUCERS-OMITTED [unresolved; full_pipeline]: Program Code.pdf supplies downstream statistical analyses and two in-program SAS temporary/deduplication datasets, but does not show how the three named analysis inputs or Stata variable acc_demean are produced from the historical Qualtrics responses.
- ISS-MIXED-CODE-SETUP [unresolved; full_pipeline]: Program Code.pdf interleaves SAS procedures and Stata reg commands in one PDF without executable-file boundaries, data-loading instructions, working paths, variable handoff or run order. The two lag uses are only in-program deduplication after sorting (by subject; by company and subject), not a documented rolling or annual history.
- ISS-SAS-ENV-UNVERIFIED [unresolved; full_pipeline]: The frozen SAS startup probe failed with a TKELS extension initialization error. This leaves SAS and the required procedure environment unverified and does not establish an absent license.
- DATA-FULLDATAFINAL [undetermined]: Author-prepared participant/company analysis dataset fulldatafinal used by the main SAS analyses and the Stata acc_demean snippets. Required fields are those named throughout Program Code.pdf; exact file, sample/exclusion history, variable construction and period coverage are not supplied.
- DATA-CMPNYSENTFRAUDFINAL [undetermined]: Separate company-sentence analysis dataset CmpnySentFraudFinal used for the Table 3/Figure 2 sentence-level results and related analyses. Its producer and field/sample history are not supplied.
- DATA-DISFLUENCIES-FIRM [undetermined]: Independent firm-level disfluency dataset Disfluencies_firm required by the Section 3.4 footnote analysis. Its producer, fields beyond those used in the model and history are not supplied.
- SW-SAS [unverified]: Program Code.pdf uses SAS DATA steps and PROC MEANS, SORT, GLIMMIX, MIXED, CORR and PRINT. The existing environment startup probe failed during TKELS initialization; runtime/version and procedure availability are not established, and no license conclusion follows.

## Review notes

- Program Code.pdf contains substantial author code despite having no standalone source extension and zero frozen static dependency edges; manual review identified SAS analysis, Stata regression snippets, and three separate named data inputs.
- The supplied SAS lag() uses are preceded by sorts and create within-program deduplication outputs (fordescriptives and temp3343); the supplied code has no lead or rolling-window construction. No additional raw-history requirement was inferred.
- No analysis_only scope is included because no compatible author-prepared analysis input is present or verified. The three author-named analysis datasets remain unresolved requirements; the historical Qualtrics origin is not treated as a new live participant-collection dependency.
- The shared environment artifact was reused as supplied. SAS remains unverified after TKELS initialization failure; no license status is inferred.
