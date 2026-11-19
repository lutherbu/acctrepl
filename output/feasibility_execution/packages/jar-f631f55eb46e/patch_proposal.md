# Patch proposal: jar-f631f55eb46e

Auditors' Quantitative Materiality Judgements: Properties and Implications for Financial Reporting Reliability

DOI: 10.1111/1475-679X.12286

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The raw author-documented PCAOB materiality-data preparation and validation workflow, including engagement-profile and IIS source materials, manual table preparation, conversion and coding, Compustat-based checks, and the Stata sample review. The corrected author-prepared panel is an unverified, narrower bypass lead and does not close this raw-source target. The release supplies no estimation driver for paper-wide results.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 5/12286 - Auditors-Quantitative-Materiality-Judgements-Properties-and-Implications-for-Financial-Reporting-Reliability/cms-datasheet-and-files.zip",
      "sha256": "47577f51384657618f90c4d026241649db4f612f701ebeedf3ab5b48193a3101"
    },
    {
      "path": "JAR-Volume 57/Issue 5/12286 - Auditors-Quantitative-Materiality-Judgements-Properties-and-Implications-for-Financial-Reporting-Reliability/cms-internet-appendix.pdf",
      "sha256": "446a902cef73cfe177479c5fd1a58dd406a6120ec001bc901ed08ed0284a1d67"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "99043ba77d6e9b3bd57f944f57350c1e314979f5d2ed6f5ec642c9d59a7b92e1"
}
```

## Proposed actions

### request-pcaob-ep-iis: Confirm the current permission route and availability for the raw EP and IIS inputs separately; the historical access and retention statements do not establish present access. Obtain the raw source materials only under current PCAOB terms and output-review conditions.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: pcaob_engagement_profiles, pcaob_iis_records, current_private_data_access
Evidence: src-datasheet-access, src-datasheet-program-retention, pub-pcaob-fellowship, pub-pcaob-approval, pub-pcaob-confidentiality

Preparation / proposed procedure:

1. Ask the authors/PCAOB whether the study-specific EP documents and IIS records remain available, what access location/delivery is permitted, and which current approvals/output-review terms apply.
2. If access is authorized, obtain EP source documents by inspection period and the separate IIS records used for the 2014–2015 overlaps and 2015 extraction; confirm the IIS period/fields beyond the detailed examples.
3. If a corrected author-prepared panel is offered instead, assess it as a separate narrower bypass target and verify its fields/coverage; do not treat it as closing this raw-source workflow.

Validation to perform later:

- Confirm the approved source period, field schema, 2014–2015 overlap, identifiers, prior-year materiality coverage, and allowed output handling before any run.

### request-programs-and-mappings: Obtain the actual conversion/validation programs and the missing manual lookup and handoff specifications. Do not construct replacements from prose or appendix output.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: missing_executable_workflow, missing_raw_handoff, materiality_category_crosswalk, firm_fiscal_year_linkage
Evidence: src-datasheet-program-retention, src-process-manual-software, src-process-categories, src-process-raw-merge, src-process-category-rules, src-process-compustat, src-process-stata, src-appendix-results

Preparation / proposed procedure:

1. Request the author/PCAOB Excel VBA and SAS files, with exact input/output filenames, schemas, current working directories, import/export formats, called macros/procedures and software/component requirements.
2. Request the complete wording-to-category mapping and the engagement/issuer/CIK/fiscal-year-end linkage rules used to merge source records to Compustat.
3. Obtain the exact Stata sampling command/seed or reproducible selection instructions for the 56-observation manual check.
4. If paper-wide estimates later become a separate target, request the actual analysis driver and input/output handoff then; this is a future-scope lead, not a dependency of the current raw preparation target.

Validation to perform later:

- Compare each delivered producer output schema to every next consumer and confirm the source/identifier/year handoff before attempting a run.

### confirm-compustat-contract: Verify the exact Compustat annual product and author mapping; COMP.FUNDA is only a readable local candidate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: compustat_fundamentals, firm_fiscal_year_linkage
Evidence: src-process-compustat, probe-compustat-row1, cat-compustat

Preparation / proposed procedure:

1. Confirm Compustat entitlement, product/table, raw fields for each materiality basis, company and date-link keys, fiscal-year definitions, and the required sample and lookback years.
2. Use the local COMP.FUNDA candidate only if its source fields and identifiers match the supplied author contract; a catalog hit and one-row read do not close the period or merge.

Validation to perform later:

- After the author contract is available, verify the required columns with a bounded row_limit=1 probe and validate complete year/key coverage only in a separately authorized data run.

### verify-raw-route-software: Confirm availability and compatible versions for the actual manual and conversion tools before using the raw EP/IIS route.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_word, sw_pdf_converter, sw_excel_vba, sw_sas
Evidence: src-process-manual-software, src-datasheet-program-retention, insp-environment

Preparation / proposed procedure:

1. Verify Word, PDF Converter Enterprise and Excel/VBA availability and current entitlement; do not substitute an unverified converter or spreadsheet runtime for the authored process.
2. Resolve SAS runtime availability through the supported environment owner and verify the exact version and any components required by the received program; the existing TKELS failure does not establish a missing SAS license, and this audit does not retry startup.
3. Keep Stata 18 as available for the documented sampling stage; obtain the author sampling command/seed before relying on exact sample repeatability.

Validation to perform later:

- Match verified runtime versions and SAS procedures/macros/import-export capabilities to the actual programs before a future authorized run.

### run-documented-data-workflow: After current access, source inputs, programs, mappings, product contracts and software are confirmed, run the author raw-data workflow on a working copy and preserve its stage order. No executable command can be specified from the present release.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: pcaob_engagement_profiles, pcaob_iis_records, compustat_fundamentals, materiality_category_crosswalk, firm_fiscal_year_linkage, missing_executable_workflow, missing_raw_handoff
Evidence: src-process-manual-software, src-process-raw-merge, src-process-iis-overlap, src-process-2015, src-process-compustat, src-process-stata, src-process-loop-fix, src-process-informat-fix

Preparation / proposed procedure:

1. Normalize Word/PDF tables and manually transcribe nonconvertible PDFs as the author documents; use the Excel VBA extraction stage for non-Excel EP tables, then import spreadsheets into SAS.
2. Apply the author-specified raw merge, manual corrections, EP/IIS validation and Compustat checks in the program-provided order; run the Stata sample-review step only with the author selection instructions.
3. Preserve source copies, intermediate schemas and any current PCAOB output review; do not add a locally invented regression or reapply the documented temporary-dataset-loop or SAS-informat fixes, which the authors say were already corrected.

Validation to perform later:

- Check the generated materiality fields, CIK/FYE/inspection-year linkage, period, and author-reported validation summaries against the supplied program/data documentation; do not treat appendix output as a driver or certify results from source text alone.


## Remaining issues and prerequisites

- missing_executable_workflow [blocking; full_pipeline]: No executable author program is present in this release. The complete PDF review found narrative instructions and results only; the narrative describes an Excel VBA extractor and SAS conversion programs, and the datasheet says the conversion programs are retained by PCAOB. The manual/GUI workflow is real and documented, but its executable preparation and validation code is absent.
- missing_raw_handoff [unresolved; full_pipeline]: The raw branch lacks the complete 800-variant wording crosswalk, the firm/CIK/fiscal-year-end linkage contract, actual input/output schemas, and exact inter-stage file handoffs. The documentation reports historical validation and correction decisions but does not provide the programs or author mapping artifacts needed to reproduce them.
- current_private_data_access [unresolved; full_pipeline]: The datasheet records historical Board approval, onsite-only access, output review, and a six-year retention request. Current approval terms, present access location/method, and whether the study-specific records/programs are still retained or deliverable are unverified. The current official fellowship page says applications are not being accepted; a separate 2025 research-data notice required PCAOB approval and terms but does not confirm current access to this dataset.
- pcaob_engagement_profiles [undetermined]: Raw PCAOB engagement-profile (EP) documents used to collect the materiality fields. The author-described source formats include Word, PDF and Excel. Raw EP records are required for this selected raw-construction workflow and for the 2014–2015 EP/IIS cross-checks; the four focus fields are final materiality, planning materiality, materiality base and materiality percent.
- pcaob_iis_records [undetermined]: PCAOB internal IIS materiality records used as an additional source and validation input, separate from the EP documents. The process uses 2014 EP/IIS overlap for checks and obtains 2015 materiality data from IIS with EP records as supplementary review.
- compustat_fundamentals [undetermined]: Compustat financial-statement data merged with corrected materiality data to derive/check materiality bases, including EBITDA and a normalized pretax measure based on a three-year average. Exact author source-table mapping and full historical window are not documented.
- materiality_category_crosswalk [undetermined]: For the raw route, the author mapping from roughly 800 materiality-wording variants to the four categories, including the actual field-level assignments. The narrative describes manual classification and broad categories but does not supply the complete crosswalk. A corrected prepared panel would be a different stage that may already contain these classifications.
- firm_fiscal_year_linkage [undetermined]: Author linkage/crosswalk needed to associate source engagements with the proper firm identifiers and fiscal-year ends before joining Compustat; the detailed process also describes CIK and fiscal-year-end corrections. Exact source keys, link table and transformations are not supplied.
- sw_word [unverified]: The authors manually opened Word source documents to normalize materiality-table formatting and created Word tables for PDFs that could not be converted. Local availability and version are unverified.
- sw_pdf_converter [unverified]: The authors used PDF Converter Enterprise to convert convertible EP PDFs to Word and reviewed conversion correctness; nonconvertible PDFs were manually entered. Local availability/version/entitlement are unverified.
- sw_excel_vba [unverified]: The PCAOB data analyst used an Excel VBA script to extract normalized materiality tables, except where EP tables were already in Excel. The script and local compatible Excel/VBA availability are unverified.
- sw_sas [unverified]: The authors imported the Excel spreadsheets into SAS and describe SAS conversion/correction programs retained by PCAOB. The environment probe could not initialize TKELS, so SAS runtime availability remains unverified; this is not evidence that the SAS license is absent. The source code is missing, so active procedures, macros and any extra SAS components cannot be inventoried.

## Review notes

- Target choice: full raw EP/IIS materiality-data construction and validation workflow. EP files and IIS records are separate jointly used private sources; a compatible corrected author panel is an unverified, narrower bypass and does not close this target. No analysis_only scope is supported by the supplied code/data.
- Original PDF pages 2–3 resolve the lost bold emphasis: the four focus fields are final materiality, planning materiality, materiality base, and materiality percent. Other planning-materiality and tolerable-error variants shown unbolded are not treated as the four focus fields.
- PCAOB access and retention are historical facts only: Board approval, onsite-only access and output review were stated for the authors’ access; they requested six-year retention. Current access, present location/method, and current retention of study-specific files remain unverified.
- The temporary-dataset loop fix and SAS informat correction are described as implemented and reprocessed. No source edit or reapplication of those fixes is proposed.
- COMP.FUNDA row_limit=1 proves one-row readability and listed columns only. It does not establish complete year coverage, author mapping, link correctness, or licensing/entitlement.
- The proprietary PCAOB EP/IIS materiality records are not interchangeable with Audit Analytics data. The appendix names Audit Analytics for audit fees in a results-table description; that does not add an Audit Analytics requirement to this selected raw materiality-preparation scope.
- Paper-wide estimates are outside the selected raw data-preparation scope and are not supported by this release. The appendix reports results without a driver; if article-wide replication is later assigned as a separate target, request the author estimator and input/output handoff then. This is contextual only, not a blocker for the raw preparation scope.
