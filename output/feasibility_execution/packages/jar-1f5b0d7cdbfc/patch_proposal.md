# Patch proposal: jar-1f5b0d7cdbfc

Disclosure, Patenting, and Trade Secrecy

DOI: 10.1111/1475-679X.12580

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | local_available | undetermined |
| analysis_only | local_available | preparation_required |

### full_pipeline

Complete author-documented six-step Stata workflow, including supplied preparation, both regression stages, the DOJ distance stage, and index validation.

Entry points: `Stata code/Stata.1  Creating_index.do`, `Stata code/Stata.2  Computing forward citations.do`, `Stata code/Stata.3  Firm-level regressions.do`, `Stata code/Stata.4  Patent-level regressions.do`, `Stata code/Stata.5  Extracting_distance_to_DOJ_offices.do`, `Stata code/Stata.6  Validating indexes.do`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Supplied Step 4 patent-level analysis using the four packaged author-prepared inputs; excludes index construction, citation construction, firm-level preparation, DOJ distance generation and validation.

Entry points: `Stata code/Stata.4  Patent-level regressions.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 1/12580 - Disclosure-Patenting-and-Trade-Secrecy/BV datasheet code identifiers and log files.zip",
      "sha256": "b83a1f904f72e834222b4aa29852c93dc8cc86923273debb2c8b3b7bfb86f8df"
    },
    {
      "path": "JAR-Volume 63/Issue 1/12580 - Disclosure-Patenting-and-Trade-Secrecy/bv-online-appendix.pdf",
      "sha256": "be43d77f0f602bca22c95e86074e7da819f5b789ca9668a0f4d0744cb1d98d61"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "f3aa6b1d8d9e78b12ade16e29b4d0799ff4dfd6db6c2025d47d620515d4f3cf1"
}
```

## Proposed actions

### A_STEP5_REVIEW_LIMIT: Keep the supplied Step 5 program as code and establish its exact producer-consumer contract before treating the distance stage as closed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_STEP5_REVIEW_LIMIT
Evidence: E_STEP6_DISTANCE_INPUT, E_SOURCE_SCREEN

Preparation / proposed procedure:

1. Retain the original Step 5 source and its screening record; use an approved safe review path to identify the exact inputs, produced file, keys, and fields.

Validation to perform later:

- Verify the produced distance_to_DOJ.dta route supplies the gvkey key and chdis field consumed in Step 6, with any required population or history established from the supplied source contract.

### A_PATH_SETUP: Configure the existing pathMAIN roots in a separate working copy and keep all writes within the host-visible run directory.

Scopes: full_pipeline, analysis_only. Type: configuration. Certainty: supported.
Addresses: I_PATH_SETUP
Evidence: E_SOURCE_SCREEN, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Preserve the original package and its opaque log files.
2. Make a separate writable working copy that retains the DATA and Stata code directories.
3. Set each entrypoint's existing pathMAIN root to the working-copy DATA directory using a host-visible relative or [redacted-path-f786df22d09b] path, and choose writable output/log directories in that copy.

Validation to perform later:

- In a separately authorized batch run, confirm each supplied input path resolves and all intermediate files and logs are written to the working copy.

### A_STEP5_REVIEW: Establish the exact supplied Step 5 read, producer, key, field, period and distance-construction contracts from a safe review of the original author source.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_STEP5_REVIEW_LIMIT
Evidence: E_DOC_ORDER, E_SOURCE_SCREEN, E_PACKAGE_INVENTORY, E_STEP6_DISTANCE_INPUT, E_STEP6_DISTANCE_USE, E_DISTANCE

Preparation / proposed procedure:

1. Keep Step 5 as supplied code and preserve its original bytes.
2. Resolve whether the checklist's base_zip.dta and gvkey_zip.dta are active inputs or intermediate products, and document their preceding source and field construction.
3. Confirm that the active Step 5 producer writes distance_to_DOJ.dta with gvkey and the chdis measure expected by Step 6, including the required geography and time coverage.

Validation to perform later:

- Compare the exact safe source contract to the Step 6 join and distance use before any separately authorized full run; do not infer the hidden formulas or reconstruct the distance data independently.

### A_CITATION_HISTORY: For any future authorized fidelity review, document the ten-year follow-up and citation cutoff for the Step 4 1996-2005 cohort. Current evidence confirms the exact packaged inputs and consumed identifiers, but not complete history; endpoint unsampling alone is not an availability barrier.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_PATENTS, REQ_CITES, I_CITATION_HISTORY
Evidence: E_PATENTS, E_CITES, E_STEP2_WINDOWS, E_STEP4_SAMPLE, E_STEP4_WINDOWS

Preparation / proposed procedure:

1. During a later authorized analysis or fidelity review, record available date-coverage and citation-cutoff evidence from existing package documentation or outputs; current bounded metadata are not evidence of a missing input.
2. If new evidence establishes an actual history shortfall, reassess compatibility before interpreting affected outcomes; the current record does not support requesting replacement inputs.

Validation to perform later:

- Document whether ten-year follow-up is established for the Step 4 cohort; if it remains unverified, retain that as an empirical-fidelity limitation without marking the packaged routes unavailable or claiming coverage.

### A_RUN_PROCEDURE: Use the supported Stata environment with the author sequence and preserve the Step 4 prepared-input branch as a separate target.

Scopes: full_pipeline, analysis_only. Type: run_procedure. Certainty: supported.
Addresses: SW_STATA, SW_REGHDFE, SW_FTOOLS, SW_ESTSTO, SW_ESTTAB, SW_COEFPLOT, SW_WINSOR
Evidence: E_DOC_ORDER, E_WORKFLOW_TRACE, E_ENVIRONMENT, E_SOFT_ESTSTO, E_SOFT_COEFPLOT, E_SOFT_WINSOR

Preparation / proposed procedure:

1. After path setup, run the six supplied Stata programs in the exact datasheet order in batch mode from the separate working copy.
2. Retain the Step 1 indexes, Step 2 forward_citations_collapsed, Step 3 annual_cleaned and location_SRAF, Step 5 distance_to_DOJ, and Step 6 validation handoffs.
3. For the analysis_only target, use an isolated copy with the four exact packaged Step 4 inputs and run Stata.4 alone after configuring its pathMAIN root.

Validation to perform later:

- For a future authorized run, preserve actual command status and logs, confirm each stage produces the named intermediate before its consumer opens it, and review generated tables/figures without changing the sample or estimator.

### A_LOCATION_CASE: Correct Step 6 to read the exact Step 3 output filename in the separate working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_LOCATION_CASE
Evidence: E_STEP3_LOCATION_SAVE, E_STEP6_LOCATION_JOIN, E_LOCATION_SRAF, E_PACKAGE_INVENTORY

**Proposed edit:** `Stata code/Stata.6  Validating indexes.do:52–52`
Source SHA-256: `899dbcb7ade9f737a65bc86effc4eef3914428d12e77ab4f6309521035657fb6`

Step 3 writes location_SRAF.dta and the exact packaged file uses that case; Step 6 currently uses lowercase location_sraf, which does not match on a case-sensitive host.

Current text:
```
	joinby cik fyear using "$pathMAIN\location_sraf", unmatched(master)
```

Proposed replacement:
```
	joinby cik fyear using "$pathMAIN\location_SRAF", unmatched(master)
```

Preparation / proposed procedure:

1. Apply this exact one-line change only in the separate working copy; preserve the original author file.
2. Keep the distinct sec_location_sraf input used by Step 3 unchanged.

Validation to perform later:

- In a separately authorized run, confirm the Step 3 output location_SRAF.dta exists and Step 6 joins it by cik and fyear with the expected header/address columns.


## Remaining issues and prerequisites

- I_STEP5_REVIEW_LIMIT [unresolved; full_pipeline]: The Step 5 Stata program is supplied and named in the author run order, but the byte-first reader withheld its entire 316-line body. Step 6 documents and consumes distance_to_DOJ.dta by gvkey and uses chdis; the packaged product is readable. The exact Step 5 reads, active producer statement, join keys, fields, history and distance construction remain unreviewed. Static checklist paths base_zip.dta and gvkey_zip.dta cannot be classified as active external inputs or generated intermediates from the available safe view.
- I_PATH_SETUP [preparation; full_pipeline, analysis_only]: Each Stata entrypoint requires pathMAIN to resolve the packaged DATA tree and writable output directories. The authentication/configuration blocks that initialize it were masked as complete logical blocks, so the current value and host path semantics were not reviewed.
- I_LOCATION_CASE [preparation; full_pipeline]: Step 3 saves location_SRAF.dta, while Step 6 reads location_sraf.dta. The package inventory contains the uppercase output and a distinct sec_location_sraf.dta, but no exact lowercase location_sraf.dta. A case-sensitive host needs a consistent working-copy path.
- I_CITATION_HISTORY [preparation; full_pipeline]: Step 2 constructs citation outcomes through ten years for the Step 4 1996-2005 cohort. The exact packaged patents and cites inputs are readable with the required identifiers, so their supplied routes are available. Bounded probes do not establish full date coverage, population or cutoff; this remains an empirical-fidelity validation limit, not evidence that an input is unavailable or that a shortfall exists.

## Review notes

- The full target retains all six Stata programs in the author datasheet order. Step 5 is supplied code; its full screened range remains withheld, so its inputs and distance construction stay unresolved without any absent-code or absent-producer inference.
- Step 1 outputs indexes, and the exact packaged indexes.dta is readable with the fields consumed downstream; the data-description filename “python_indexes” is reconciled by the datasheet and source code naming indexes. The initial alias issue has been removed.
- Confirmed visible chains are Step 1 indexes -> Steps 3/6; Step 2 forward_citations_collapsed -> Step 4; Step 3 annual_cleaned -> Step 4; Step 3 location_SRAF -> Step 6 location_sraf (case mismatch); and Step 5 distance_to_DOJ -> Step 6 (consumer fields are visible, producer contract is not). See probes/workflow_trace_v1.json.
- A separate Step 4 analysis_only target is supported by four packaged readable author-prepared inputs and the supplied patent-level program. It does not claim full-pipeline completion.
- Compustat is present as the exact author file and has a successful bounded metadata probe. The frozen catalog also lists COMP.FUNDA at ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat, but this is a metadata candidate only and was not probed or started through SAS.
- SEC filings are publicly searchable. The current SRAF header product page covers a 1993-2025 product, but its schema and coverage are not verified as a drop-in for the author’s packaged 1993-2021 header file; output_4 text features are not reconstructed from public filings.
- Stata 18 is available. The visible Stata variable abbreviations are supported by Stata 18’s default varabbrev setting; Step 2’s legacy set memory line is ignored by Stata 12 and later. No Stata or author program was executed.
- One-row metadata probes establish readability and sampled fields, not complete population or history. Package logs, raw configuration/authentication text and the entire Step 5 implementation remain opaque.
- A separate invocation-record helper initially failed at process creation because its specified working directory did not exist; it had no process return code or streams. The captured value-free record is probes/invocation_creation_failure_001.json and is not used as scientific evidence.
