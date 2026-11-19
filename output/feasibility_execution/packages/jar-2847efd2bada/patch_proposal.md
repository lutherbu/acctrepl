# Patch proposal: jar-2847efd2bada

The Relationship between Non-GAAP Earnings and Aggressive Estimates in Reported GAAP Numbers

DOI: 10.1111/1475-679X.12434

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The three supplied native branches: experimental R conversion/descriptive/sample-reconciliation work, survey R Qualtrics retrieval/filtering, and the embedded archival SAS preparation sequence through WORK.NONGAAP10. The branches have no supplied cross-language file handoff; unprovided paper-wide estimators are outside this scope.

Entry points: `1 - ExperimentCode.R`, `2 - SurveyCode.R`, `3 - ArchivalCode.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 5/12434 - The-Relationship-between-Non-GAAP-Earnings-and-Aggressive-Estimates-in-Reported-GAAP-Numbers/grrw-datasheet-code-and-identifiers.zip",
      "sha256": "dc11ee69afd7f79941317a2a99d945a77a5304459942ba4ee72aacb517e49618"
    },
    {
      "path": "JAR-Volume 60/Issue 5/12434 - The-Relationship-between-Non-GAAP-Earnings-and-Aggressive-Estimates-in-Reported-GAAP-Numbers/grrw-online-appendix.pdf",
      "sha256": "10fcae9922f0a17b50cbf0550d3acc7177aba2ca7f542f2b4df7c155bf97cd78"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "91cacef099abe7aa028a913f25d915a21206c5029c8b5fa749918d7dc582ace4"
}
```

## Proposed actions

### A-EXP-DATA: Obtain the author-prepared anonymized experimental SPSS export through the documented request route. Place the compatible file at rawData/nonGAAPSPSS.sav in a prepared working copy; do not substitute newly collected or synthetic responses.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-EXP-RAW, I-EXP-RAW
Evidence: SRC-DATASHEET-RAW-REQUEST, SRC-EXP-READ, SRC-EXP-SCREEN, SRC-EXP-SAMPLE-END, INSPECT-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Confirm the delivered file is an SPSS export or has an author-supplied compatible field map for gc, WDAmtNI_1, WDAmtAdjwoR_1, WDAmtAdjwR_1, V1, Recon, Prompt, V10, Cond, InvAttn, Q68, Q69, AcctKnow1, AcctKnow2, Comp1, Comp2, Income and term.
2. Prepare the project root and Datasets directory, preserving the raw file unchanged.
3. Run the supplied experimental branch only after separate authorization; it writes Datasets/nonGAAP.csv and keeps descriptive/sample-reconciliation objects in the R session.

Validation to perform later:

- Before execution, compare the delivered export's fields, types and reported collection period with the source reads and datasheet; no one-row or synthetic response test substitutes for full-data validation.
- After separately authorized execution, verify the CSV and reconcile the screening groups against author-supplied documentation.

### A-SURVEY-DATA: Use the documented anonymized author-data request route or obtain authorized access for the named Qualtrics survey. Do not inspect hidden credentials or make an API request during this assessment.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-SURVEY-RAW, I-SURVEY-RAW
Evidence: SRC-SURVEY-FETCH, SRC-DATASHEET-RAW-REQUEST, PUB-QUALTRICS-API, PUB-QUALTRICS-LICENSE

Preparation / proposed procedure:

1. Obtain an author-prepared anonymized response export and field map, or have the account owner establish the required Qualtrics API authorization through an appropriate external process.
2. Confirm the response data include CompletedResponse and V-Consid_OE and cover the documented August 2018 collection period.
3. If the delivered export cannot feed fetch_survey directly, prepare a working-copy input adaptation that preserves the supplied filtering operations and does not expose credentials.

Validation to perform later:

- Before execution, review the authorized input format, required fields and period. No Qualtrics call or participant contact is part of this assessment.

### A-R-PACKAGES: Prepare an R library containing the packages referenced by both R branches: tidyverse, broom, haven, knitr, car, qualtRics, ggthemes, rmarkdown, and psych. No package was installed for this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW-R-PACKAGES
Evidence: INSPECT-R-PACKAGES, SRC-EXP-PACKAGES, SRC-SURVEY-PACKAGES

Preparation / proposed procedure:

1. Set up an authorized project library with compatible versions of all nine required R packages.
2. Keep the experimental and survey branches in their separate package environments only if their package versions differ; do not change their calculations.

Validation to perform later:

- After package setup, confirm the required packages are available to the chosen R 4.5.0 environment before running either author branch.

### A-EXP-PSYCH-IMPORT: In a working copy of the experimental R script, load psych before its describeBy calls; this preserves the supplied descriptive calculations.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-EXP-PSYCH
Evidence: SRC-EXP-PACKAGES, SRC-EXP-DESCRIBE, PUB-PSYCH-DESCRIBEBY

**Proposed edit:** `1 - ExperimentCode.R:10–10`
Source SHA-256: `da74787ad5fbb151d875b47432215dc88ff8b9503f8540fa203393ed47e8d374`

describeBy is a psych function, and the supplied import block does not load psych.

Current text:
```
library(knitr)
```

Proposed replacement:
```
library(knitr)
library(psych)
```

Preparation / proposed procedure:

1. Apply this edit only to a working copy after adding psych to the R package library; the cached author source remains unchanged.

Validation to perform later:

- Statically confirm the working copy contains the psych import before the first describeBy call; after separate authorization, check the descriptive objects without modifying the formulas.

### A-ARCH-DATA: Resolve the author custom-member mapping and the concrete field/key contracts for the five NONGAAP inputs. Catalog and bounded candidates are discovery evidence only; do not guess a substitute for the missing TIC field or choose between distinct IBES families.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-ARCH-NONGAAP, R-ARCH-LINK, R-ARCH-COMPUSTAT, R-ARCH-CRSP, R-ARCH-IBES, I-ARCH-SCHEMA, I-ARCH-IBES-FAMILY, I-ARCH-STDEV
Evidence: SRC-DS-ARCH-PROV, SRC-DS-COMMERCIAL, SRC-ARCH-LINKTABLE, SRC-ARCH-NONGAAP, SRC-ARCH-CSTAT-MERGE, SRC-ARCH-CRSP, SRC-ARCH-IBES, SRC-ARCH-WINSOR-CALL, CATALOG-RESOURCE, INSPECT-CANDIDATES, INSPECT-IBES-REFINEMENT, PROBE-CRSP-LINKTABLE, PUB-COMPUSTAT, PUB-CRSP-PRODUCT, PUB-CRSP-ACCESS, PUB-IBES, INSPECT-CATALOG-LOOKUP

Preparation / proposed procedure:

1. Request the exact author-provided NONGAAP.NONGAAPDATA member and its schema, identifier and coverage documentation.
2. Map NONGAAP.LINKTABLE to a source carrying TIC, LINKDT, LINKENDDT and LPERMNO; the local CCMXPF_LINKTABLE candidate lacks TIC and is not a verified replacement.
3. Check whether COMP.FUNDQ supplies the author NONGAAP.COMPUSTATDATA fields over the required history, and resolve the supplied sort-by-TIC/FYEARQ/FQTR versus merge-by-TIC/DATAFQTR contract using documented schema and field types.
4. Check whether CRSP.MSF supplies the required PERMNO/DATE/PRC observations and author-compatible monthly coverage.
5. Confirm the intended IBES summary family (EPSUS versus the distinct XEPSUS family), its mapping to NONGAAP.IBESDATA, and the actual source of STDEV before building that custom member.

Validation to perform later:

- Before any separately authorized SAS run, compare each input's actual schema, types, identifiers, keys, sort order and period with its merge/read block; record the author's mapping for STDEV.
- After separately authorized execution, confirm the event/link/Compustat/CRSP/IBES chain produces the intended pre/post sample, without inferring coverage from one-row reads.

### A-ARCH-PREP: Prepare a runnable working copy from the substantial SAS program embedded in the archival PDF, preserving its supplied transformations and using a relative project library/macro setup. The exact embedded macro inconsistency has a supported same-operation repair.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I-ARCH-BYVAR
Evidence: SRC-ARCH-PATHS, SRC-ARCH-BYVAR, SRC-ARCH-WINSOR, INSPECT-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Extract and reflow the embedded SAS program and its winsor macro into a working-copy SAS file; do not edit the PDF source.
2. Replace the hard-coded [redacted-path-9727810b64a3] library and external [redacted-path-4a31371ddedd] Codes macro include with a prepared project-relative NONGAAP library and the macro extracted from the same PDF.
3. In the extracted macro's no-byvar DATA step, change `byvar = 1;` to `xbyvar = 1;`, retaining the existing downstream SORT/MERGE/DROP key name.
4. Stage the five documented NONGAAP members in that library before the archival sequence; keep the steps in one SAS session so WORK.NONGAAP10 remains available as the supplied endpoint.

Validation to perform later:

- Statically check the extracted file's path/include edits across all affected statements and confirm the no-byvar assignment matches XBYVAR before any execution.
- After the required data contracts and SAS runtime are established and separately authorized, run once and inspect only the specified generated endpoint against author documentation.

### A-SAS-RUNTIME: Establish an authorized SAS 9.4 runtime check after the supplied probe's TKELS initialization failure. The failure does not prove that a license or required component is absent.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS, I-SAS-RUNTIME
Evidence: ENV-R-SAS, SRC-DS-PROGRAMS, SRC-ARCH-WINSOR

Preparation / proposed procedure:

1. Use the assigned SAS 9.4 environment setup only after the owner confirms the runtime and access path; do not start SAS as part of this assessment.
2. Confirm that the program's used DATA step, PROC SORT, PROC UNIVARIATE, PROC MEANS and macro functionality are available in that runtime.

Validation to perform later:

- Record a successful bounded runtime/version check before attempting the author branch; do not treat the current TKELS error as license evidence.

### A-ORDERED-WORKFLOW: Execute only the three supplied conversion/preparation branches after their input, software and handoff prerequisites are resolved. Their order is operational; no supplied file passes from one branch to another.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: INSPECT-WORKFLOW-TRACE, SRC-README-EXPERIMENT, SRC-README-SURVEY, SRC-README-ARCH

Preparation / proposed procedure:

1. From a project root containing rawData and Datasets, run 1 - ExperimentCode.R after staging rawData/nonGAAPSPSS.sav and resolving R package/import setup; retain Datasets/nonGAAP.csv and in-session descriptives/reconciliation.
2. From the survey project root, run 2 - SurveyCode.R only after using an authorized API route or a documented anonymized export; preserve the raw CSV written before filters and retain the final filtered workfile and StartingCases in the same R session as the supplied branch endpoint.
3. Prepare and run the extracted 3 - ArchivalCode.pdf workflow after staging the five NONGAAP library members; follow the ordered LINK -> NONGAAP2 -> CSTAT/NONGAAP3 -> CRSP/NONGAAP4 -> IBES/NONGAAP6 -> price/winsor -> pre/post -> WORK.NONGAAP10 chain in workflow_trace.json.

Validation to perform later:

- Confirm each branch reads and writes within its configured working root, preserve the raw inputs, and compare each supplied endpoint with author-specified output contracts after separate execution authorization.
- Do not claim completion of the paper's later estimators; those analysis programs and any survey cleaned-file consumer are not supplied here.


## Remaining issues and prerequisites

- I-EXP-RAW [unresolved; full_pipeline]: The experimental R entry reads rawData/nonGAAPSPSS.sav, absent from the supplied inventory. The datasheet documents an author request route, but no input was acquired or checked for the complete field/period contract.
- I-SURVEY-RAW [unresolved; full_pipeline]: SurveyCode.R requests Qualtrics survey SV_e8pXNaxn0ZCL0Vv using a private key intentionally hidden in the package. No response data or authorized API route was verified; no credential inspection or request was performed.
- I-EXP-PSYCH [preparation; full_pipeline]: ExperimentCode.R calls describeBy but loads tidyverse, broom, haven and knitr without importing psych. psych is absent from the local package inventory; a working-copy import and package setup are required for this call.
- I-ARCH-SCHEMA [unresolved; full_pipeline]: Five custom NONGAAP input members are named but not supplied with schemas or member lineage. The program sorts NONGAAP2 and CSTAT by TIC/FYEARQ/FQTR but then merges by TIC/DATAFQTR; source ownership, types, intended key and compatible sort order are unresolved, so no replacement key is inferred.
- I-ARCH-IBES-FAMILY [unresolved; full_pipeline]: Two distinct local IBES candidate families have required named fields, but the author-created NONGAAP.IBESDATA family and transformation are unspecified. EPSUS and XEPSUS are retained as distinct candidates, not treated as interchangeable alternatives.
- I-ARCH-STDEV [unresolved; full_pipeline]: STDEV is included in the archival winsor call but is not created by the supplied code. The bounded IBES candidates expose an STDEV field, but the intended family and custom-member source mapping remain unverified.
- I-ARCH-BYVAR [preparation; full_pipeline]: In the embedded no-byvar branch, the DATA step creates BYVAR while subsequent macro logic sorts and merges by XBYVAR and drops XBYVAR. In an extracted working copy, change the assignment to xbyvar = 1; so the created key matches the downstream name.
- I-SAS-RUNTIME [unresolved; full_pipeline]: The provided SAS probe failed at TKELS initialization. This does not establish license absence or component availability; a bounded authorized environment check remains to be done before any author workflow execution.
- R-EXP-RAW [undetermined]: The author-prepared Qualtrics experimental SPSS export read at rawData/nonGAAPSPSS.sav; preserve the fields used by the supplied cleaning, outcome, condition, attention and sample-reconciliation code.
- R-SURVEY-RAW [undetermined]: The raw survey responses for survey ID SV_e8pXNaxn0ZCL0Vv used by the supplied Qualtrics retrieval and cleaning branch.
- R-ARCH-NONGAAP [undetermined]: Author-prepared firm/event data consumed as NONGAAP.NONGAAPDATA to identify non-GAAP disclosures around Regulation G.
- R-ARCH-LINK [undetermined]: The link table consumed as NONGAAP.LINKTABLE and joined to NONGAAPDATA by TIC with validity dates.
- R-ARCH-COMPUSTAT [undetermined]: Compustat Fundamentals Quarterly records consumed as NONGAAP.COMPUSTATDATA for excluded-item variables, controls and the quarterly merge.
- R-ARCH-CRSP [undetermined]: CRSP Monthly Stock File observations consumed as NONGAAP.CRSPDATA and joined by PERMNO, calendar year and month.
- R-ARCH-IBES [undetermined]: IBES Summary History observations consumed as NONGAAP.IBESDATA; the program derives DAYSTOGO from actual announcement date and STATPERS, selects/deduplicates announcements, and merges by CUSIP and announcement year/month. STDEV is also consumed by the later winsor call but its source/member mapping is unresolved.
- SW-SAS [unverified]: The supplied environment probe failed to initialize SAS at TKELS. SAS entitlement and required component availability remain unverified; this assessment did not start SAS.
- SW-R-PACKAGES [preparation_required]: The metadata-only inventory found all nine packages named or called by the two R branches absent from the current R library. Install/use a compatible library before execution; psych is specifically called by describeBy but is not imported in ExperimentCode.R.

## Review notes

- Final target is the three supplied native conversion/preparation branches. The title in the datasheet agrees with the frozen header; no title/attribution conflict was found. The paper's later estimators are contextual and not supplied entry points.
- The archival PDF contains substantial SAS preparation code and the winsor macro. The reviewed sequence ends at WORK.NONGAAP10 and the Final Sample heading; no later archival estimator code or persistent endpoint is supplied. The survey script writes the unfiltered raw CSV before filters and retains its cleaned workfile and StartingCases in memory as the supplied endpoint; no later survey consumer is included.
- The supplied package includes no experimental/survey raw response files or five archival NONGAAP members. The author documents anonymized experimental/survey files on request and an author-provided proprietary event dataset. No participant contact, author contact, Qualtrics key inspection, API request, data payload, reconstruction or synthetic response was performed.
- The exact frozen catalog and bounded one-row local probes identify COMP.FUNDQ and CRSP.MSF candidates with the named code fields; the CCMXPF link candidate lacks TIC. IBES.STATSUM_EPSUS and IBES.STATSUM_XEPSUS are distinct readable candidates with relevant fields; the author's family/member mapping remains unresolved. These checks establish candidate metadata and sampled readability, not full history, coverage or entitlement.
- R 4.5.0 is available, while all nine packages named or called by the R branches were absent in a successful metadata-only inventory. SAS startup remains unverified after the supplied TKELS failure; no SAS startup or author program was attempted.
- An earlier optional psych help lookup failed after package metadata inspection. Its original JSON result is retained as INSPECT-R-PACKAGES-FAILED but is deliberately unused for proof; the later clean inventory is the package-status evidence. The prior static audit covers the two R scripts and was not treated as a review of the embedded SAS program.
- Identifiers.pdf was classified from the README and datasheet as a sample identifier list, not an analysis panel; it was not fully read or counted.
