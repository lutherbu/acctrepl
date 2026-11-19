# Patch proposal: jar-aad012f028ac

The Role of Gatekeepers in Capital Markets

DOI: 10.1111/1475-679X.12266

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The frozen paper title is “The Role of Gatekeepers in Capital Markets,” while the sole supplied appendix is headed “Measuring Disclosure Using 8-K Filings.” If intended for this package, Appendix A documents an SEC 8-K/exhibit workflow for 2005–2016: classify items, match exhibits, remove images and unmatched exhibits, aggregate counts/word counts by firm-quarter, apply keyword searches, and screen firms using a Compustat CIK match. The appendix is substantive workflow documentation, but no executable program is supplied and its relationship to the frozen paper remains unresolved.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 2/12266 - The-Role-of-Gatekeepers-in-Capital-Markets/rs-internet-appendix-a.pdf",
      "sha256": "2be4c1dea7a71312fb267a87be30ef3e822c33bd19872df0b62cde51301264e9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "cce6155aea465b829a03f36de4d9cd571b33c6854401e683f1d53818f70014e5"
}
```

## Proposed actions

### acquire_edgar_inputs_after_scope_confirmation: After confirming that Appendix A belongs to this paper, check the documented local SEC filing/exhibit corpus against the required 2005–2016 input contract; use the verified SEC EDGAR route for any missing or incompatible inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: sec_8k_filings_and_exhibits
Evidence: src_doc_title, src_sec_scope, src_flowchart, src_matching, src_keyword_rules, pub_sec_access, pub_sec_2005, pub_sec_2016, local_sec_corpus_doc

Preparation / proposed procedure:

1. After the authors confirm the appendix-to-paper association and exact input contract, perform only bounded checks against the documented local paths: raw full filings in ${ACCTREPL_SEC_RAW} and parsed exhibits in ${ACCTREPL_SEC_PARSED}. Do not recursively scan the corpus.
2. Verify whether the local material supplies 2005–2016 Form 8-K records, item text and exhibit text with the identifiers needed for the appendix matching rules. Its period and compatibility are currently unknown.
3. Use the local material if it meets the confirmed contract; otherwise obtain the missing 8-K filings and linked exhibits from official SEC EDGAR, whose public route is verified.
4. Preserve filing date, CIK, accession, item number and exhibit identity; apply the appendix’s image-exclusion, item classification, exhibit-matching, unmatched-exhibit, word-count and keyword rules using the confirmed author workflow.

Validation to perform later:

- After bounded local checks or acquisition, verify the required period and filing/exhibit document structure and record any unavailable or mismatched fields.
- After a future separately authorized run of the supplied workflow, compare constructed samples and measures with the author’s documented counts and outputs.

### confirm_package_and_compustat_specification: Ask the authors or package curator to confirm the appendix-to-paper association and provide the executable replication workflow or complete author-prepared analysis input, together with Compustat frequency/date alignment and exact input/table specifications.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: compustat_screening_records, missing_executable_code, appendix_title_scope_mismatch, compustat_frequency_and_mapping_unresolved
Evidence: inv_package, src_doc_title, src_compustat, src_flowchart, cat_local_candidates, probe_comp_funda, probe_comp_fundq

Preparation / proposed procedure:

1. Confirm whether the supplied “Measuring Disclosure Using 8-K Filings” appendix is intended for “The Role of Gatekeepers in Capital Markets”; if not, obtain the correct workflow materials for the frozen paper.
2. Request executable preparation and analysis code, or a complete author-prepared analysis dataset and its file formats, fields, identifiers, period, and construction specifications.
3. Ask which Compustat frequency/table and observation-date rule are used for the CIK match and assets/net-income screen; assess COMP.FUNDA and COMP.FUNDQ only against that answer, without treating them as interchangeable.
4. Once confirmed, map every supplied input and processing stage to the appendix rules and identify the prescribed software/version requirements.

Validation to perform later:

- Use bounded metadata checks on received author inputs to verify exact fields and formats, then verify date coverage and CIK matching rules.
- Only after a separately authorized execution step, run the supplied entry points and compare outputs with author results.


## Remaining issues and prerequisites

- missing_executable_code [blocking; full_pipeline]: The assigned inventory contains only an explanatory appendix PDF. It documents a manual/narrative processing workflow and measurement rules but supplies no executable program or complete author-prepared data file; there is no runnable entry point.
- appendix_title_scope_mismatch [unresolved; full_pipeline]: The PDF heading “Measuring Disclosure Using 8-K Filings” conflicts with the frozen package title “The Role of Gatekeepers in Capital Markets.” Confirm whether this appendix belongs to the assigned paper; do not assume it defines the complete frozen-paper workflow.
- compustat_frequency_and_mapping_unresolved [unresolved; full_pipeline]: The Compustat screen is named, but annual/quarterly frequency, observation-date alignment and the exact table/field mapping are not specified. Local COMP.FUNDA and COMP.FUNDQ metadata are distinct candidate tables; their full period coverage and intended use are unverified.
- sec_8k_filings_and_exhibits [public_acquisition_required]: The documented workflow uses all available SEC EDGAR Form 8-K filings and attached exhibits from January 2005 through December 2016. The appendix specifies item/exhibit identification and matching, image removal, unmatched-exhibit treatment, word counting and keyword rules. No source files are included in this package.
- compustat_screening_records [undetermined]: The appendix requires Compustat records joined by SEC CIK and screens for nonzero total assets and nonmissing net income. It does not identify annual versus quarterly frequency, the Compustat observation date/alignment rule, or exact table. Local metadata identifies candidate Compustat tables, but compatibility with the appendix input contract is unresolved.

## Review notes

- Appendix A is credited as substantive workflow documentation: its flowchart, matching rules, word-count rules and keyword strings are concrete, but they are not executable code.
- The SEC public-route finding is an inference from official SEC access guidance and official filing-detail pages at 2005 and 2016. It establishes a public source route, not that a complete population has been acquired or that author cleaning has been reproduced.
- Bounded one-row reads establish that catalogued SEC metadata and Compustat candidate tables are locally readable and expose relevant columns. They do not establish full-period coverage, exhibit text compatibility, or the intended Compustat frequency. COMP.FUNDA and COMP.FUNDQ are not treated as interchangeable.
- No analysis-only scope is supported because this package supplies no executable analysis program or prepared analysis dataset.
- common/README.md documents a local raw-full-filing directory and a parsed-exhibit directory. This is an unverified candidate; item/full-text/exhibit matching compatibility and 2005–2016 coverage were not checked, and no recursive scan was performed.
