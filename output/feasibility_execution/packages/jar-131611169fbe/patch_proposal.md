# Patch proposal: jar-131611169fbe

Anonymous Equity Research

DOI: 10.1111/1475-679X.12359

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied author workflow embedded in DK Program_file.pdf: SAS firm-quarter and article preparations, Perl article text attributes, and Stata Table 2–7 analyses. All substantive stages are present as code, but source extraction, runtime handoffs, prepared-input contracts and complete data routes remain unresolved.

Entry points: `DK Program_file.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 2/12359 - Anonymous-Equity-Research/dk-datasheet-code-and-identifiers.zip",
      "sha256": "a3030b0553df5b1dfd0ae41bf4e1a1bb442cc9b7d4065f02e40f4f147c7df8bf"
    },
    {
      "path": "JAR-Volume 59/Issue 2/12359 - Anonymous-Equity-Research/dk-online-appendix.pdf",
      "sha256": "97e716e816bb98cfb81487d966ae453446b59d963e4de74c577b41cd9f5aaeee"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "ee6b6b5e538252123edd956e9bb1b94bacf8604ebd719d091713bb74430d9885"
}
```

## Proposed actions

### A-data-contracts-and-coverage: Close the exact author input contracts and compatible history for every independent SAS/Perl source and prepared table, keeping separate namespaces and source products distinct.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-compustat-quarterly, R-compustat-annual-employees, R-compustat-names, R-crsp-daily, R-crsp-daily-index, R-crsp-compustat-links, R-crsp-stocknames, R-crsp-monthly-shares, R-tfn-s34, R-bushee-classifications, R-tfn-insider-table1, R-ibes-summary, R-ibes-detail, R-ibes-iclink, R-compustat-short-interest, R-ravenpack-firm-quarter-counts, R-ravenpack-article-counts, R-sa-dk-matched-articles, R-sa-store-matched-articles, R-sa-text-corpus, R-sa-comments-likes, R-sec-8k-filings, I-data-compatibility-history, I-unresolved-sas-aliases
Evidence: E-datasheet-sources, E-datasheet-profiles, E-datasheet-sa-terms, E-identifiers-probe, E-catalog-field-matrix, E-workflow-trace, E-probe-tfn-s34, E-probe-rpa-2006, E-probe-rpa-2018

Preparation / proposed procedure:

1. For each named table in the trace, record whether the intended input is the authors’ prepared table or a specific raw vendor product; verify field names/types, identifiers, unit of observation, source/version, and full period/population with a bounded metadata route before treating any local candidate as compatible.
2. Keep dk.matched_article3 separate from store.matched_article3, dk.rp_count_deter separate from store.rp_count_ret, and preserve the distinct missing names dk.ibes_sum, dk.ibesdetail_09292019, dk.iclink, dk.comp_shortint, dk.compa_employee, dk.table1, dk.comments_data_like and dk.edgar_filings_1993to2018 until author producer/schema information resolves them.
3. Resolve the COMP.FUNDA employee-table contract: the catalog comparison shows the local candidate lacks sic while the consumed employee table selects sic; identify the intended compatible annual field route and date coverage.
4. Confirm the S34, CRSP, Compustat, I/B/E/S, Thomson Table 1, Bushee and RavenPack product contracts and histories, including security/manager identifiers and all source lookback/event windows stated in code. Catalog presence, a one-row readable probe, or a timed-out probe does not establish complete coverage or entitlement.
5. Establish a permitted and complete route for Jan 2006–Oct 2018 Seeking Alpha article metadata/author categorization, profile fields actually present in matched tables, text files/ID list, and comments/likes. The documented NDA limits sharing the author-received confidential dataset but does not prove that every other route is barred.
6. Use DK_identifiers.xlsx only as a firm-quarter identifier list. It is not a substitute for Compustat/CRSP panels, article records, text, or the prepared analysis tables.

Validation to perform later:

- Compare every confirmed dataset to the exact consuming code fields and keys, and verify complete date/population coverage from source metadata before any authorized future full-pipeline run.

### A-sec-index-acquisition: Acquire or stage the public SEC filing-index metadata needed to replace the code’s prepared 8-K list, then map its fields to the SAS filing join.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R-sec-8k-filings
Evidence: E-sec-public-index, E-sas-sec-filings, E-sec-100day-window, E-sec-name-map

Preparation / proposed procedure:

1. Use the documented public EDGAR index/interface for filing form, CIK and filing date, covering filings after 2004 and the 100-calendar-day pre-article windows.
2. Map the public metadata fields to formtype, cik and date expected by the supplied SAS joins, retaining the COMP.NAMES CIK/GVKEY effective-year matching step.

Validation to perform later:

- Check the acquired index period spans the full article sample and all required pre-event dates, then compare exact field and identifier mappings to the SAS statements.

### A-extract-and-map-workflow: Prepare a reviewable text working copy from the supplied PDF and specify the real cross-language execution order and handoff contracts before running anything.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-workflow-handoffs, I-unresolved-sas-aliases
Evidence: E-datasheet-code-and-ids, E-workflow-trace, E-perl-text-root, E-perl-output-root, E-perl-id-text-input, E-sas-text-import-handoff, E-stata-entry, E-sas-remote-context

Preparation / proposed procedure:

1. Extract and reflow the SAS, Perl and Stata sections into separate working-copy text files while retaining the original source, syntax, line attribution and supplied macro bodies.
2. Document the ordered producer/consumer chain: SAS firm-quarter and article-preparation blocks; Perl id/text processing to produce the text-attribute CSV before SAS imports it; resume SAS article merge/output; then hand separate firm-quarter and article datasets to Stata.
3. Resolve the [redacted-path-0f83384a8f18]: paths in a user-authorized working configuration and specify SAS local/remote libraries and the SAS/CONNECT session host; do not assume an unshown signon/connection.
4. Identify the producer and exact schema/history for article5, tempBas, outofhere, and the article-specific illiqtemp input; retain dk./store. tables as distinct until their keys and mappings are documented.
5. Identify the actual data files and field mapping loaded in memory for the Stata Table 2 and Tables 3–7 branches; the supplied Stata excerpt has no visible use/import or SAS export contract.

Validation to perform later:

- Perform a static path/key/schema comparison for every handoff; only validate execution later after data, software and runtime access are separately ready.

### A-fix-sas-sort-text: Correct the four confirmed SAS keyword spellings in the extracted plain-text working copy after preserving the original PDF.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I-source-sort-keywords
Evidence: E-sort-spelling-1, E-sort-spelling-2, E-sort-spelling-3, E-sort-spelling-4, E-visual-source-review, E-sas-sort-doc

Preparation / proposed procedure:

1. At original cached-source lines 596, 987, 1050 and 1416 in the extracted working-copy text, replace the printed token decending with the SAS keyword descending, preserving the following sort variable and all surrounding logic.
2. Do not edit the binary PDF or infer any replacements for the separate unresolved aliases.

Validation to perform later:

- Review the four text lines against the original PDF and official PROC SORT BY syntax; do not run or compile the author program as part of this assessment.

### A-sas-runtime-setup: Confirm the intended SAS runtime and any SAS/CONNECT remote session needed by the supplied code.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-SAS-remote
Evidence: E-sas-remote-context, E-workflow-trace, E-environment-probe

Preparation / proposed procedure:

1. Confirm the authorized SAS runtime/version, SAS/CONNECT availability and remote host/session context, then document the required local/remote librefs and PROC UPLOAD/DOWNLOAD destinations.
2. Do not treat the earlier unverified SAS startup probe or a catalog listing as proof of a missing license or a confirmed blocker.

Validation to perform later:

- Verify the connection/library configuration independently before a future authorized workflow run.

### A-perl-modules: Confirm the Perl text-processing module set in the intended runtime and resolve how the Bigram namespace is loaded.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-Perl-modules
Evidence: E-perl-modules, E-perl-bigram-call, E-perl-runtime-probe

Preparation / proposed procedure:

1. Check availability/version for the directly imported File::Slurp, Text::CSV, Lingua::StopWords, Lingua::Stem::En, Lingua::EN::Fathom and Lingua::EN::Sentence modules, and the Lingua::EN::Bigram constructor, without importing or running the author program during this audit.
2. If the module entry point is absent or its load path is unclear, preserve the exact Perl module/initialization question for the code owner rather than assuming it is unavailable or editing the source.

Validation to perform later:

- Confirm each named package/constructor is available in the intended Perl environment before a future authorized execution.

### A-stata-outreg2: Make the source-required outreg2 output command available in the target Stata 18 environment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S-outreg2
Evidence: E-stata-outreg2, E-outreg2-probe

Preparation / proposed procedure:

1. Provide outreg2 in the authorized Stata 18 environment using the organization’s approved software source; no installation was performed in this audit.

Validation to perform later:

- Repeat a non-estimating availability check for the outreg2 command before any future table run.


## Remaining issues and prerequisites

- I-source-sort-keywords [preparation; full_pipeline]: Four PROC SORT BY lists in the original PDF spell the SAS modifier as decending (cached source lines 596, 987, 1050 and 1416; visually confirmed on original PDF pages 14, 22, 24 and 31). SAS documents DESCENDING as the modifier. Once the code is extracted to an editable text working copy, these four spellings require the exact correction decending → descending; do not alter the archival PDF.
- I-unresolved-sas-aliases [unresolved; full_pipeline]: The complete supplied source uses article5, tempBas and outofhere without visible producers; the article-return branch reuses the firm-quarter illiqtemp table whose visible schema lacks the article id/m_date fields consumed later. Several author-prepared dk./store. tables are also read without producers. The RavenPack comment names dk.rp_count_ret but executable code reads store.rp_count_ret, so preserve both namespace references until mapped. One %WT invocation repeats parameter names, so its expansion/output remains unresolved without macro-call behavior evidence. Preserve names and request exact producer/schema/key/history contracts; do not guess replacements.
- I-data-compatibility-history [unresolved; full_pipeline]: The package lacks full compatible analysis inputs. The identifiers workbook is only gvkey/datadate; local commercial catalog candidates and bounded one-row probes do not prove required product versions, matching fields, population, history or complete coverage. The supplied code also consumes author-prepared tables whose producers/contracts are absent. Historical Seeking Alpha article, profile/category, text and comment/like data need compatible 2006–2018 records and ID links.
- I-workflow-handoffs [unresolved; full_pipeline]: SAS, Perl and Stata programs are embedded in a PDF rather than supplied as driver-ready files. The actual order must interleave SAS article preparation, the Perl-generated text CSV, and later SAS import/join. Perl writes a C: path while SAS imports the same-named CSV from a J: path; the SAS remote session/library setup is not shown; and the separate Stata table branches begin without a visible input load/export contract. SAS macros dupl, trading_days and WT are fully defined in the PDF and are not missing merely because they are not standalone files.
- R-compustat-quarterly [undetermined]: Compustat quarterly fundamentals consumed directly to build firm-quarter records and article-date fundamentals. The code filters raw datadate after 1990, later retains final firm-quarter observations from 2007 onward, and uses 2006–October 2018 article records.
- R-compustat-annual-employees [undetermined]: Employee/SIC/CIK/CUSIP annual Compustat records joined into firm-quarter data through dk.compa_employee; required data are not supplied as analysis inputs.
- R-compustat-names [undetermined]: Compustat Name File rows are downloaded and joined by CIK and name-effective years to add gvkey to the SEC filing list.
- R-crsp-daily [undetermined]: CRSP daily security records for firm-quarter market characteristics and article event returns, spreads and turnover.
- R-crsp-daily-index [undetermined]: CRSP daily value-weighted market returns merged to firm-quarter and article daily return observations.
- R-crsp-compustat-links [undetermined]: CRSP/Compustat CCM link-history rows map gvkey and datadate to permno for firm-quarter market joins.
- R-crsp-stocknames [undetermined]: CRSP stock-name history maps Thomson Reuters CUSIP observations to PERMNO by effective name dates.
- R-crsp-monthly-shares [undetermined]: CRSP monthly shares outstanding supplies denominators for institutional ownership rates.
- R-tfn-s34 [undetermined]: Thomson Reuters S34 13F holdings used to construct institutional ownership measures, with report dates from 1993 onward and share/CUSIP/manager fields.
- R-bushee-classifications [undetermined]: Bushee institutional ownership classification CSV used to assign manager classes before the S34 holdings are aggregated.
- R-tfn-insider-table1 [undetermined]: Thomson Reuters Insider Data Table 1 transaction and ownership records, filtered to open-market trades and officer/director roles; used for 92-day trading and up to 1,095-day ownership windows.
- R-ibes-summary [undetermined]: I/B/E/S quarterly summary forecasts and actuals used for earnings surprise. The code consumes dk.ibes_sum and requires FPI 6, ticker, announcement/summary dates, fiscal period end, median estimate, actual and standard deviation.
- R-ibes-detail [undetermined]: I/B/E/S analyst-detail history used to count analysts announcing forecasts during the 365 days before each firm-quarter and article date.
- R-ibes-iclink [undetermined]: Ticker-to-PERMNO link table dk.iclink is required by both I/B/E/S summary and analyst-detail joins.
- R-compustat-short-interest [undetermined]: Compustat short-interest observations consumed from dk.comp_shortint and matched to quarter-end-derived dates and to article dates up to 92 days earlier.
- R-ravenpack-firm-quarter-counts [undetermined]: Prepared RavenPack firm-quarter count table dk.rp_count_deter with Dow Jones article counts at relevance >=95 and SA coverage excluded.
- R-ravenpack-article-counts [undetermined]: Separate prepared RavenPack article-level count table store.rp_count_ret, keyed by article id and describing Dow Jones counts over event days [-6,0] at relevance >=95 excluding SA coverage.
- R-sa-dk-matched-articles [undetermined]: Author-categorized Seeking Alpha article table dk.matched_article3 used to build article event returns; article ids, dates, author categories and security/company keys must match later inputs.
- R-sa-store-matched-articles [undetermined]: The separate store.matched_article3 table used to join per-article comments/likes back to article ids; keep distinct from dk.matched_article3 until a schema/key mapping is documented.
- R-sa-text-corpus [undetermined]: Perl article-text corpus and okids.csv identifier list needed to calculate text measures and match text output to SAS article ids.
- R-sa-comments-likes [undetermined]: Article comment and like records dk.comments_data_like are aggregated by article id and used to construct each author’s prior-year comment/like history measures.
- R-sec-8k-filings [public_acquisition_required]: 8-K filing metadata used to construct the latest filing date in the 100 calendar days before each article; code filters filing years after 2004.
- S-SAS-remote [unverified]: The PDF supplies dupl, trading_days and WT macro definitions and uses RSUBMIT, PROC UPLOAD and PROC DOWNLOAD. The pre-existing workspace environment probe reports SAS startup unverified/failed; this does not establish that SAS or SAS/CONNECT is unavailable. The runtime, SAS/CONNECT session/host, entitlement and library assignments remain unverified; no new SAS startup or author-code execution was performed for this assessment.
- S-Perl-modules [unverified]: Perl 5.40.1 is present, but imported text modules remain unverified. The source imports File::Slurp, Text::CSV, Lingua::StopWords, Lingua::Stem::En, Lingua::EN::Fathom and Lingua::EN::Sentence, and calls Lingua::EN::Bigram->new without a visible import; module availability and initialization remain unresolved.
- S-outreg2 [preparation_required]: The Stata source writes tables with outreg2. The bounded which check reports it unavailable in the checked Stata 18 adopath.

## Review notes

- This is a full-pipeline assessment of the supplied author package. The SAS, Perl and Stata programs were read as PDF-embedded code; no author code, regression, estimator, parser, compilation or model was run.
- The SAS macros dupl, trading_days and WT have definitions and matching mend statements in the supplied program. They are not classified as missing standalone dependencies.
- Execution order follows producer/consumer dependencies: SAS article preparation, Perl text-attribute generation before SAS import, later SAS article output, and separate Stata branches. The PDF section order is not itself a complete driver.
- DK_identifiers.xlsx is a firm-quarter identifier list. The bounded probe read one row and found gvkey and datadate with coverage_verified false; it is not complete analysis data.
- Catalog entries and bounded one-row metadata probes identify candidate local sources only. They do not verify access entitlement, historical coverage, sample population, exact author-prepared table mappings or full-data compatibility. The TFN.S34 and RPA 2018 row probes timed out; neither timeout establishes absence or denied access.
- Datasheet NDA language concerns the authors sharing their received confidential Seeking Alpha data. It does not establish that every other public or permitted acquisition route is barred; compatible historical article, profile/category, text and comments coverage remains unverified.
- The SEC public index is a compatible candidate route for the filing fields and history used by the code; acquisition and SAS field conversion remain preparation steps.
- No analysis_only scope is supported: the package has partial Stata analysis code but no verified compatible analysis input route or data handoff independent of the full pipeline.
- The RavenPack count tables, article matched tables and other author-prepared dk./store. inputs are treated as consumed data requirements unless a producer is visible. Raw catalogued candidates do not establish their missing aggregates, crosswalks or coverage.
- No author-code run, estimator, data download, install, new SAS startup, external contact, or applied source edit was performed. The pre-existing environment probe records a SAS startup failure/unverified state and is not treated as proof of absence or entitlement.
