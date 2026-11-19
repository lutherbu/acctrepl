# Patch proposal: jar-e3eea3d8648e

Strategic Scientific Disclosure: Evidence from the Leahy-Smith America Invents Act

DOI: 10.1111/1475-679X.12605

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Author-documented full workflow: form the firm/publication sample, construct patent and publication-field links, and run the documented firm-year-patent-class analyses and appendix subgroups.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 4/12605 - Strategic-Scientific-Disclosure-Evidence-from-the-Leahy-Smith-America-Invents-Act/vzz-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "7704026b1a28ffae984c5648af5432e4544908fc38bf683f6d87ed5c31a91531"
    },
    {
      "path": "JAR-Volume 63/Issue 4/12605 - Strategic-Scientific-Disclosure-Evidence-from-the-Leahy-Smith-America-Invents-Act/vzz-online-appendix.pdf",
      "sha256": "c4f6413e9bba5a45eccf90ebad780412af89043ad6d54e2dee934a4f6331a76b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "57c6d258d53861e86d46207b7c7aa0f8eb0f752ab9cc312860fc32c62323af67"
}
```

## Proposed actions

### A_READABLE_CODE: Request a readable, byte-integrity-preserving copy of each registered program source and the intended ordered launch procedure; preserve the current package members as received.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_SOURCE_BYTES
Evidence: E_DS_CODE, E_PROGRAM_BYTES

Preparation / proposed procedure:

1. Ask the authors to provide intact contents for 1_Sample Firms.do, 2_Sample and Variables Construction.py, and 3_Regressions.do, plus the intended run order and working-directory assumptions.
2. Record hashes of any newly supplied files separately; do not replace or reinterpret the frozen package members.

Validation to perform later:

- Before any separately authorized run, inspect the replacement source bytes and confirm the entry points, included helpers, reads, writes, and handoffs from the complete source text.

### A_INPUT_CONTRACTS: Resolve exact product/table inputs and their consumed fields, identifiers, history, joins and producer-consumer order for the documented sample, patent, rejection and publication-field workflows; for publication fields, take the author-selected OpenAlex provider as established and clarify its remaining field contract.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_COMPUSTAT, R_ARORA_PUBLICATIONS, R_OPENALEX_RECORDS, R_KOGAN_PATENTS, R_PATENTSVIEW_CPC, R_GOOGLE_PATENT_FAMILY, R_PUBLICATION_FIELDS, R_RELIANCE_ON_SCIENCE, R_PATENT_REJECTION, I_INPUT_CLOSURE, I_FIELD_SOURCE
Evidence: E_APP_SAMPLE, E_APP_OPENALEX, E_APP_FIELD_SOURCE, E_APP_KOGAN, E_APP_CPC, E_APP_RELSCIENCE, E_PROGRAM_BYTES, E_APP_SAMPLE_PERIOD, E_DS_OFFICE_ACTIONS

Preparation / proposed procedure:

1. For each author-named source, identify the exact file or table, source release, source columns, record unit, entity and time keys, and required historical coverage.
2. Provide the complete construction and handoff sequence, including how the corporate-publication counts, firm-affiliation matches, patent identifiers/classes/families, citation records and publication-field labels form the analysis panel.
3. The appendix selects OpenAlex instead of Web of Science; request the exact OpenAlex release, field taxonomy/categories, publication identifiers, mapping and patent-class crosswalk, plus the fields actually consumed by the unreadable programs.
4. For Patent Application Office Actions Research, identify the exact release/table, record unit, rejection/disposition fields, patent/application keys, event-date history and join to the patent analysis records; distinguish a packaged author input from raw source records.

Validation to perform later:

- Once readable sources and contracts are available, reconcile each supplied read with the selected route and verify each producer's exact output identity before preparing a separately authorized run.
- Once the Office Actions product and author-consumed fields are identified, compare its observation keys, disposition meaning and event history with the supplied program reads and patent merge order before any separately authorized run.

### A_SOFTWARE_COMPATIBILITY: Confirm the author-required Python and Stata versions, pinned reghdfe release, and add-on/back-end dependencies; compare exact source calls with the local environment once readable source bytes are available.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: SW_PYTHON, SW_STATA, SW_REGHDFE, I_SOFTWARE_COMPATIBILITY
Evidence: E_DS_REGHDFE, E_ENV_PROBE, E_DS_CODE, E_PROGRAM_BYTES

Preparation / proposed procedure:

1. Ask the authors to specify the Python and Stata versions, exact reghdfe version, all required Stata add-ons/backends, and version-specific options or commands used by the programs.
2. Use the restored readable source to identify exact calls and compare them with the stated versions; do not infer compatibility from the installed package names alone.

Validation to perform later:

- Before any separately authorized execution, compare the exact author calls and options with the pinned runtime and reghdfe documentation and confirm the required packages are present.


## Remaining issues and prerequisites

- I_SOURCE_BYTES [blocking; full_pipeline]: The three registered program members are present at their recorded sizes but every byte is NUL; each cached copy matches the registered hash and original package-member bytes. Their executable logic cannot be read, so the intended programs are documented but the code actually available here is not interpretable. This establishes a supplied-byte integrity/readability limitation, not that the authors never supplied code.
- I_INPUT_CLOSURE [unresolved; full_pipeline]: The documentation names the Office Actions Research source for patent rejection decisions in addition to Compustat, publication, patent, technology-class, family and citation-field sources. The appendix describes an OpenAlex affiliation match with manual adjudication, patent-class enrichment and a citation-based class-field crosswalk, but all registered program bytes are NUL, leaving the exact consumed tables, fields, keys, rejection record joins, interleaved producers, file handoffs and run order unresolved.
- I_FIELD_SOURCE [unresolved; full_pipeline]: The appendix explicitly selects OpenAlex, instead of Web of Science, for scientific-field-level corporate publications because of data availability. The exact OpenAlex release, field taxonomy, publication-to-field mapping/crosswalk and program-consumed schema remain unresolved because the registered program bytes are unreadable.
- I_SOFTWARE_COMPATIBILITY [unresolved; full_pipeline]: The datasheet says reghdfe version changes can affect syntax and clustered-standard-error calculations. Local environment metadata reports Python 3.12.14, Stata 18 and reghdfe 6.12.3, but the author-required versions, add-ons and call compatibility cannot be established while the registered program bytes are unreadable.
- R_COMPUSTAT [undetermined]: Compustat financial observations used for the 2008–2010 and 2013–2015 firm-year sample and financial controls; the annual table, source columns, keys and extraction contract are not recoverable from the supplied NUL-filled programs.
- R_ARORA_PUBLICATIONS [undetermined]: Arora, Belenzon, and Sheer corporate-publication data and firm/subsidiary identifiers used to select firms and support the publication crosswalk; the exact shared files, keys and fields remain unspecified.
- R_OPENALEX_RECORDS [undetermined]: OpenAlex publication-level records and author affiliations for matching sample firms to individual scientific publications; exact fields, query/version and complete matching history are not supplied in readable code.
- R_KOGAN_PATENTS [undetermined]: Kogan et al. corporate patent data linking patents to firms; exact files, patent identifiers, fields and history required by the programs are unknown.
- R_PATENTSVIEW_CPC [undetermined]: PatentsView patent-characteristics data supplying CPC subclass technology classes for the patent records; exact identifiers, class history and join fields remain unverified.
- R_GOOGLE_PATENT_FAMILY [undetermined]: Google Patents BigQuery global-family data used for patent-family classification; the exact table, fields, family mapping and period remain unknown.
- R_PUBLICATION_FIELDS [undetermined]: OpenAlex corporate-scientific-publication records at scientific-field level required for the patent-class/publication-field crosswalk. The appendix explicitly selects OpenAlex instead of Web of Science; the exact OpenAlex release, field taxonomy, crosswalk, identifiers/history and code-consumed schema remain unverified because the registered programs are unreadable.
- R_RELIANCE_ON_SCIENCE [undetermined]: Reliance on Science patent-to-publication citation records used to rank scientific fields within patent classes using 1991–2010 publications; the table schema, identifiers and construction history are not specified.
- R_PATENT_REJECTION [undetermined]: Patent-application rejection-decision records from the Patent Application Office Actions Research source named in the datasheet; the exact product, observation unit, disposition fields, application/patent identifiers, event history and joins are not specified in readable code.

## Review notes

- Initial populated checkpoint only: frozen-resource catalog, public-route and software-availability checks have not yet been completed.
- The datasheet and online appendix identify the intended workflow and input families. The three registered code members and their cached copies are byte-for-byte identical and contain only NUL bytes; the saved byte-only integrity audit is the supporting inspection. This is a present package-byte limitation, not evidence that the authors never supplied code.
- The preliminary source-screen outputs for those all-NUL program files are retained but unused: the byte content has no readable source text, and the heuristic encoding label is not treated as evidence of source language or missing/available logic.
- FirmList.xlsx is described as a permno identifier list, not a full analysis panel. Its existing package probe is unverified after BadZipFile and is preserved without use in any scientific evidence_ids list; no availability or data-absence inference is made from it.
- The appendix lines 76-78 explicitly select OpenAlex instead of Web of Science for corporate scientific publications at the scientific-field level because of data availability. OpenAlex is the author-selected provider. The exact release, field taxonomy, crosswalk and consumed schema remain unresolved because the registered programs are NUL-filled.
- Fixed environment viewer succeeded against the original registered environment.json hash. Python 3.12.14, Stata 18 and reghdfe 6.12.3 are available in the registered environment; availability does not establish author-version compatibility or make the NUL-filled programs readable.
- Frozen catalog checks used the exact registered catalog file and hash. Broad Compustat results were narrowed by the required funda and COMP.FUNDA queries. COMP.FUNDA is a local catalog candidate at ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat; its 949 variables/941,340 catalog observations do not establish consumed fields, historical coverage, entitlement or route compatibility.
- The frozen one-row COMP.FUNDA probe returned readable:true at the catalogued physical path, but only the first ten columns and one row; coverage_verified=false. This supports a local candidate component while the consumed source-field contract remains unknown. The saved preflight/path and all-NUL screen records remain unused process-only inspection evidence.
- Exact literal frozen-catalog queries for Arora, OpenAlex, PatentsView, Google Patents, Office Actions Research, Reliance on Science, Web of Science and Kogan returned zero selected records. These are unused catalog-search records, not evidence that the source families are absent, unavailable or unlicensed; short aliases are being checked.
- Concise catalog aliases returned a potentially relevant WRDSAPPS patent-to-GVKEY leaf, but no public-product identity or consumed-field compatibility is established. Patent-citation leaves represent patent-to-patent citations, and CRSP index families/CPC text hits are unrelated to the named scientific-citation, Google patent-family and PatentsView CPC products. All alias lookups are preserved as selected metadata; no catalog miss is treated as source absence or an access barrier.
- The local WRDSAPPS.USPATENTS_GVKEY_LINKING candidate is readable in one bounded row and contains patent/firms keys plus link metadata. It is credited as a local patent-link component only; author-product equivalence, consumed field selection, key definitions and required historical coverage remain unresolved because the author programs are all NUL bytes. The probe does not establish the complete Kogan patent-data contract.
- The datasheet explicitly names Patent Application Office Actions Research as the source for the patent rejection decision, so it is retained as a separate mandatory input. The exact product, fields, record keys, event window and compatibility with the patent analysis cannot be recovered from the NUL-filled program members; the empty catalog search is not evidence of source absence or licensing.
- The package manifest registers three author program members, but each registered original/cache pair is entirely NUL bytes. The assessment treats these as intended supplied program files while no executable logic, entry point or run order can be read; this is a source-byte integrity/readability limitation and does not establish that the authors never supplied code.
- The official USPTO search result lists Stata and CSV formats for the Office Actions product. Opening the explicit static product page redirected to the generic data.uspto.gov home page with no readable lines. No dataset or payload was requested; the exact release, fields, event history and compatibility remain unresolved.
- Local environment evidence shows Python 3.12.14, Stata 18 and reghdfe 6.12.3 are present. The datasheet warns that reghdfe version changes can alter syntax and clustered-standard-error calculations, while author-required versions and calls are unreadable. Compatibility remains unresolved and is linked to a same-scope clarification action.
- The frozen snapshot sets has_code=false because the three registered program members contain no readable executable statements: every byte is NUL. The manifest and datasheet identify intended program filenames, but no executable logic or entry point is available in these bytes. This does not establish that the authors never supplied code; it records the state of this downloaded package copy.
