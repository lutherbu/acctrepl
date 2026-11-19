# Patch proposal: jar-cfa99a155f1b

Show Your Hand: The Impacts of Fair Pricing Requirements in Procurement Contracting

DOI: 10.1111/1475-679X.12561

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full native author workflow: acquire/convert/compile annual contract-award source data, use the supplied author key list, prepare the analysis dataset, then run both supplied Stata entry points and the bundled helper.

Entry points: `JAR_show_your_hand_prepare_data_for_analysis.do`, `JAR_show_your_hand_analyze_data.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 4/12561 - Show-Your-Hand-The-Impacts-of-Fair-Pricing-Requirements-in-Procurement-Contracting/Nathan datasheet code and identifiers.zip",
      "sha256": "44eb92afb6fc5803eab6e44d399f9fafe11ba315ebf7782fe3a886f87637c442"
    },
    {
      "path": "JAR-Volume 62/Issue 4/12561 - Show-Your-Hand-The-Impacts-of-Fair-Pricing-Requirements-in-Procurement-Contracting/nathan-online-appendix.pdf",
      "sha256": "02e85c8ba752acda979d4234252aab693d8a58d55602b4ea5f7c82502a6dd11f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "5b4bc637e0429b5178bd43a6dbef6601677ca2d6ec40e31154b325c72a424e47"
}
```

## Proposed actions

### A_USASPENDING: Obtain the author-specified full annual USASpending contract-award CSV source. The official documentation identifies Contracts_Full, but exact annual availability and compatibility remain to be checked.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_USASPENDING
Evidence: E_README_ACCESS, E_DATASHEET_ARCHIVE, E_PREP_IMPORT, E_PUBLIC_USASPENDING_GUIDE, E_PUBLIC_DOCS_TRACE

Preparation / proposed procedure:

1. Use the authors' documented USASpending.gov contract-award download workflow for FY2013 through FY2020 and choose Full files rather than Delta/changes.
2. Stage the annual CSVs under Data/USASpending/ using filenames recognized by the preparation script's directory loop.
3. Verify the downloaded years, all-agency population, headers, and unique Stata varlist resolution for every author `keep` token; retain file metadata and do not require byte identity with the authors' 2020 download.

Validation to perform later:

- Confirm one compatible full contract-award CSV for each FY2013-FY2020 year and that all required transaction, date, agency, pricing and contract fields map to the source headers.
- If any year, field or population is not supported, leave the public route unresolved and preserve the specific gap; do not infer unavailability from the catalog miss.

### A_AWARD_KEYS: Retain and use the supplied author transaction-key list at its documented merge point. The exact local file and required field names are present; its sampled probe does not establish population count.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_AWARD_KEYS
Evidence: E_README_FILES, E_PREP_KEYS_COMPILED, E_KEYS_PROBE, E_PREP_COMPILED_PRODUCER, E_PUBLIC_DOCS_TRACE

Preparation / proposed procedure:

1. Keep Data/Unique IDs/usaspending_awards_list.dta with the package; do not replace it with a synthetic or inferred key list.
2. After the annual source files are available, run the author merge on contract_transaction_unique_key and action_date and retain the supplied primary_key for author ordering.
3. Record actual matched/unmatched rows and confirm the merged key types and first_award ordering during the normal preparation run; treat any mismatch as a concrete source-compatibility gap rather than a reason to require author approval or historical byte identity.

Validation to perform later:

- Confirm the author key-list fields are available and the actual preparation merge consumes them without changing the authors' first-award construction.
- The one-row probe is a readability/field check only; no full-population count or historical coverage is claimed.

### A_SOFTWARE_SETUP: Prepare the four invoked Stata commands that the direct local `which` checks did not find.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_TEXSAVE, SW_DISTINCT, SW_FINDNAME, SW_XTPQML
Evidence: E_SOFTWARE_PROBE, E_SOFT_TEXSAVE, E_SOFT_DISTINCT, E_SOFT_FINDNAME, E_SOFT_XTPQML, E_PUBLIC_TEXSAVE, E_PUBLIC_DISTINCT, E_PUBLIC_FINDNAME, E_PUBLIC_XTPQML

Preparation / proposed procedure:

1. Install/enable texsave from its author-documented SSC route or author repository.
2. Obtain distinct from the Stata Journal archive, following Stata's documented search guidance.
3. Install/enable findname from SSC, following the author's package announcement.
4. Install/enable xtpqml from SSC using the RePEc module record's documented package route.
5. Do not change the estimators or omit outputs that invoke these commands.

Validation to perform later:

- In the same Stata 18 environment planned for the run, use `which texsave`, `which distinct`, `which findname`, and `which xtpqml` and record the resolved command locations/versions.
- Confirm available reghdfe and ftools remain on the active Stata adopath; no package installation was performed during this assessment.

### A_RUN: After data and software preparation, follow the authors' complete supplied workflow in package-relative order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_USASPENDING, R_AWARD_KEYS, SW_STATA, SW_REGHDFE, SW_FTOOLS, SW_ESTTAB, SW_ESTADD, SW_ESTSTO, SW_COEFPLOT, SW_TEXSAVE, SW_DISTINCT, SW_FINDNAME, SW_XTPQML
Evidence: E_README_SEQUENCE, E_README_OUTPUTS, E_PREP_IMPORT, E_PREP_KEYS_COMPILED, E_PREP_ANALYSIS_DATA, E_ANALYSIS_INCLUDE, E_AUX_MERGEMODELS, E_PREP_MAIN_PRODUCER, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Set the working directory to the package root so the relative `Data/` and `Results/` paths point into this package.
2. Run JAR_show_your_hand_prepare_data_for_analysis.do first; retain the generated per-CSV files, compiled transactions, single-offer lookup and Data/data_ready_for_analysis.dta.
3. Then run JAR_show_your_hand_analyze_data.do; it loads Additional Code/00_Auxiliar Define Programs.do and produces the supplied body and online-appendix outputs under Results/.
4. Confirm mixed forward/backslash path literals resolve in the local Stata environment before treating either entry point as attempted.
5. Create Figures 1, 2 and Online Appendix Figure A.1 manually as the README specifies; they are contextual manual outputs, not omitted estimators.

Validation to perform later:

- Record actual exit codes/messages and verify the main analysis dataset is produced before the analyzer reads it.
- Confirm every generated dependency D0002-D0008 has its direct producer and consumer in the executed sequence; assess observed data/software compatibility without replacing inputs or changing the research design.
- Execution remains unverified until a later authorized run is actually completed.


## Remaining issues and prerequisites

No separate issues were identified; data and software requirements still retain their stated verification limits.
- R_USASPENDING [undetermined]: The preparation program requires annual full USASpending.gov contract-award CSV files for FY2013-FY2020 and retains the author-listed transaction, award, action, fiscal-year, valuation, agency, performance, offer, pricing, competition, set-aside, product/service and related fields. The `keep` names are Stata varlist tokens; verify each maps uniquely to the official file header rather than assuming truncated tokens are literal column names.
- SW_TEXSAVE [preparation_required]: The analysis invokes texsave to create LaTeX outputs; the local `which` check reports it unavailable.
- SW_DISTINCT [preparation_required]: The analysis invokes distinct; the local `which` check reports it unavailable.
- SW_FINDNAME [preparation_required]: The preparation program invokes findname; the local `which` check reports it unavailable.
- SW_XTPQML [preparation_required]: The analysis invokes xtpqml in its supplied bunching analysis; the local `which` check reports it unavailable.

## Review notes

- The assessment follows only the supplied native Stata workflow and its full_pipeline scope. The preparation entry point is required before the analysis entry point; the auxiliary mergemodels program is supplied and must remain included.
- The USASpending guide confirms the Contracts_Full product for Contracts award type. Exact FY2013-FY2020 file availability, all required source columns, all-agency coverage and construction compatibility remain unresolved; this is not evidence of a license or access barrier.
- The packaged usaspending_awards_list.dta probe reads one row and confirms contract_transaction_unique_key, action_date and primary_key. Author documentation supports its intended key-list role; the probe does not establish a total row count, and no historical byte-identity or author-approval condition is imposed.
- The separate analysis_awards_list.dta is not read by either entry point and is reference-only. No analysis_only scope is supported because no prepared analysis dataset is supplied; the packaged lists alone are not an analysis panel.
- The README describes Figures 1, 2 and Online Appendix Figure A.1 as manual outputs. They remain contextual manual work, not an inferred missing estimator. All five Results DTA files and the preparation intermediates have direct producer/consumer evidence.
- Stata 18 and the available invoked commands were checked through bounded metadata/which probes. texsave, distinct, findname and xtpqml were not found and need setup before execution. Raw Stata log contents were excluded from the sanitized evidence summary.
- The source uses relative paths with mixed slash styles and declares no directory change. Run from the package root and verify path resolution under local Stata before any future execution; no source change is proposed without an observed failure.
- No author code, model, statistical estimation or SAS executable was run; no data were downloaded and no software was installed. The frozen catalog alias miss is discovery-only.
- Registered document and note sources were byte-screened in original format before cached text decoding; candidate contact/private-path lines were withheld. Source citations were checked against screened safe views.
