# Patch proposal: jar-2972d4583abe

Run EDGAR run: SEC Dissemination in a high-frequency world

DOI: 10.1111/1475-679X.12167

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Author-documented construction of the SEC disclosure timing and insider-transaction sample, TAQ variables, CRSP filters, and supplementary firm/media analyses; the package supplies step descriptions and a filename-level sample but no executable programs.

Entry points: `detailed data steps.pdf`, `RSZ_Data Description Sheet.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 2/12167 - Run-EDGAR-run-SEC-Dissemination-in-a-high-frequency-world/rsz-datasheet-files.zip",
      "sha256": "9f7a4135a04d7a46ed0e14c18838a7fbd4018e7b350a9d13317cc4d777276c05"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "a47b9ca0727022e2c4f601be20d32d25ba3b0401eaf4223ffaaf6156a03f6e64"
}
```

## Proposed actions

### A_AUTHOR_WORKFLOW: Request author-supplied SAS/Stata/Python entry programs or an approved runnable, fully specified step-by-step workflow; map each reported analysis/table to its required script, inputs, output and order. Treat final_sample.xlsx only as the filename-level sample pointer until a full compatible analysis dataset is documented.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_NO_EXECUTABLE_WORKFLOW, I_FINAL_SAMPLE_NOT_PANEL
Evidence: E_PACKAGE_MEMBERS, E_WORKFLOW_IMPLEMENTATION, E_SAMPLE_DOC, E_FINAL_SAMPLE_PROBE

Preparation / proposed procedure:

1. Obtain the authorized code or the complete remaining author procedures, including SEC parsing, sample filters, TAQ construction, supplementary analyses and output mapping.
2. Obtain a field/data dictionary and version list for any author-prepared analytical inputs; do not infer a compatible analysis panel from the filename list.

Validation to perform later:

- Confirm every reported Table/Figure maps to a supplied executable entry point or documented manual stage.
- Verify the final analysis input contains the fields and observations consumed by those entry points.

### A_PDS_ACCESS: Request an authorized timing dataset route and verify whether another PDS subscriber’s data is acceptable for the target replication; retain the authors’ exact-subscriber limitation for exact timestamp identity.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_PDS_TIMES, I_PDS_TIMING_COMPATIBILITY
Evidence: E_STEPS_PDS, E_PDS_PROPRIETARY, E_SEC_PDS_SPEC

Preparation / proposed procedure:

1. Confirm authorized access to PDS/SEC post-time data for the 2012–2013 sample and the time precision, event identifiers and source flags.
2. If using a different subscriber, document its permitted use and the expected timestamp variation; do not treat public EDGAR headers as equivalent to millisecond subscriber receipt times.

Validation to perform later:

- Check event/file coverage against the 4,782 listed SEC filenames and verify units, timezone, receipt/post definitions and time precision.

### A_SEC_FILINGS: Use the verified official SEC route for 2012–2013 public filing indexes and raw filings; obtain or write author-approved parsing instructions for company/insider fields and acceptance times. Follow SEC fair-access guidance.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SEC_FILINGS, I_NO_EXECUTABLE_WORKFLOW
Evidence: E_SEC_PUBLIC, E_SAMPLE_DOC, E_STEPS_SEC

Preparation / proposed procedure:

1. Retrieve only the required quarterly/daily index entries and filings after confirming each sample filename and form 4/4A coverage.
2. Extract filing date, acceptance time, company CIK/name and insider CIK/name using author-confirmed parsing logic.
3. Use an appropriate declared user agent and moderate request rate in any later authorized retrieval.

Validation to perform later:

- Reconcile retrieved filing names to the sample list, check form/date coverage, and compare parsed fields to any author-prepared header data.

### A_LOCAL_SEC: Check the bounded local SEC archive against the author filename list before considering a new public retrieval; the present root-level check found candidate corpora but did not verify matching records.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SEC_FILINGS, I_FINAL_SAMPLE_NOT_PANEL
Evidence: E_CORPUS_ROOTS, E_SAMPLE_DOC, E_FINAL_SAMPLE_PROBE

Preparation / proposed procedure:

1. Use exact filenames and the documented `${ACCTREPL_SEC_RAW}` and `${ACCTREPL_SEC_PARSED}` roots for any future bounded match check.
2. Verify filing period, form coverage, parsed section/header fields and completeness before crediting a local route.

Validation to perform later:

- Match sample filenames and required SEC fields, with no inference from root-directory presence alone.

### A_VENDOR_ACCESS: First assess the bounded local COMP.FUNDQ, COMP.FUNDA, CRSP.DSF, TFN.TABLE1 and RavenPack category-metadata candidates. Confirm whether the exact author-compatible historical Thomson-Reuters insider and RavenPack Dow Jones archive inputs can be accessed, including vintages and field coverage. Do not silently replace a vendor product or vintage.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_TR, R_FUNDQ, R_CRSP, R_FUNDA, R_RAVENPACK, I_VENDOR_VINTAGES
Evidence: E_SOURCE_LIST, E_TR_FILTERS, E_TR_CUSIP, E_CRSP_PRICE, E_SUPPLEMENTARY_DATA, E_CATALOG_FUNDQ, E_CATALOG_FUNDA, E_CATALOG_DSF, E_CATALOG_TFN, E_CATALOG_TAQ_CQ, E_CATALOG_TAQ_CT, E_CATALOG_RAVENPACK, E_CATALOG_RAVENPACK_DJ, E_PROBE_COMP_FUNDQ, E_PROBE_COMP_FUNDA, E_PROBE_CRSP_DSF

Preparation / proposed procedure:

1. Inspect the sampled local Compustat and CRSP schemas for author-required fields beyond the reused probes, especially fundq CUSIP/CIK and dsf bidlo/askhi; confirm period and source vintage.
2. If local schemas do not meet the source contract, confirm each subscription/source license and access period for 2012–2013 plus the 52-week TAQ control lookback.
3. Request source schemas, identifier definitions and historical-vintage notes for the exact TR, fundq, funda, dsf and RavenPack fields used.
4. If proposing a current alternative product, compare transaction universe, fields and historical definitions before treating it as compatible.

Validation to perform later:

- Verify fields, dates, identifiers and join keys against the documented filters and supplementary analysis steps.
- Document local candidates as usable only after confirming the required source fields and period/history.

### A_TAQ_ACCESS: Confirm WRDS/NYSE Daily TAQ and CRSP access, plus exact versions of the TCLINK and NBBO code that reproduce the authors’ CQ/CT inputs and quote construction. Public product pages support period coverage and macro existence but do not establish this package-specific route.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_TAQ, R_CRSP, S_TCLINK, S_NBBO, I_NBBO_PROGRAM
Evidence: E_TAQ_WORKFLOW, E_TAQ_HISTORY, E_TAQ_LICENSE, E_TCLINK_PUBLIC, E_WRDS_LINK_ACCESS, E_CATALOG_TCLINK, E_CATALOG_NBBO

Preparation / proposed procedure:

1. Request authorized 2011–2013 TAQ quote/trade files, CRSP link fields and the author-compatible TCLINK/NBBO versions.
2. Confirm the source fields, symbol/CUSIP matching, timezone, one-second aggregation, 121-second window and 52-week volume-control logic.
3. Keep current NYSE/WRDS products as preparation leads until exact file definitions and author workflow compatibility are verified.

Validation to perform later:

- Verify coverage for all sample dates and the full 52-week lookback, required quote/trade fields and link-table match rates.

### A_FTP_CLARIFICATION: Ask the authors to identify the FTP date-time files, fields and place in the documented timing workflow; retain them as an unresolved source until the consumer and producer are clear.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SEC_FTP_TIMES, I_FTP_TIMING_ROLE
Evidence: E_FTP_SOURCE, E_STEPS_PDS, E_STEPS_SEC

Preparation / proposed procedure:

1. Request exact source/file names, extraction dates, timestamp meaning and whether the FTP values are mandatory or only historical provenance.
2. Confirm order relative to SEC filing parsing, PDS feeds and the final dissemination-time panel.

Validation to perform later:

- Document the producer, consumer, period, time precision and joins for each included timestamp source.

### A_SAS_RUNTIME: Verify SAS 9.4 startup and the licensed environment when author programs and WRDS inputs are available; the TKELS probe failure alone does not identify the cause or establish a missing entitlement.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS, I_SAS_RUNTIME
Evidence: E_ENV, E_WORKFLOW_IMPLEMENTATION

Preparation / proposed procedure:

1. Have the system administrator resolve the reported TKELS initialization condition or confirm the supported SAS launch environment.
2. Do not infer license absence from the existing failed probe.

Validation to perform later:

- Run only a bounded SAS version/startup check before any later author-program execution is authorized.


## Remaining issues and prerequisites

- I_NO_EXECUTABLE_WORKFLOW [unresolved; full_pipeline]: The package contains two PDF descriptions and final_sample.xlsx but no author SAS, Stata or Python program. The data sheet says SAS and Stata programs performed the conversion and analyses; the detailed steps do not provide executable entry points or the table/figure-to-script mapping.
- I_PDS_TIMING_COMPATIBILITY [unresolved; full_pipeline]: The author describes proprietary PDS subscriber timing with up to millisecond receipt times. The current SEC PDS specification documents acceptance time only at HHMMSS precision and does not establish a public historical subscriber-receipt archive or the exact author data. Access and vintage remain unverified.
- I_FINAL_SAMPLE_NOT_PANEL [unresolved; full_pipeline]: final_sample.xlsx is described as 4,782 SEC filenames and its existing one-row probe shows only CIK, file_name and secdate. It is not a verified full analysis panel, so it does not support an analysis_only scope.
- I_FTP_TIMING_ROLE [unresolved; full_pipeline]: The data sheet lists scraped SEC FTP date-times, while the detailed workflow does not specify the FTP file, schema or how those times enter the three-source timing panel. Clarify whether this is a mandatory stage and its producer/consumer order.
- I_SAS_RUNTIME [unresolved; full_pipeline]: SAS 9.4 initialization failed at TKELS in the supplied environment probe. SAS availability and entitlement remain unverified; the failure is not evidence of an absent license.
- I_NBBO_PROGRAM [unresolved; full_pipeline]: The workflow names TCLINK and NBBO.sas, but no code is packaged; only TCLINK has a bounded official WRDS page match. NBBO code/version and fit to the documented TAQ quote derivation remain unverified.
- I_VENDOR_VINTAGES [unresolved; full_pipeline]: Local catalog discovery found readable COMP.FUNDQ, COMP.FUNDA and CRSP.DSF candidates plus TFN.TABLE1 and RPA.RAVENPACK_CATEGORIES metadata candidates. The bounded probes do not verify author-required CUSIP/CIK or BIDLO/ASKHI fields, subscriber vintages or 2012–2013 history; the RavenPack categories table is not the required Dow Jones archive. Exact TAQ.CQ/CT lookups found no catalog match. These findings do not establish absent access or licenses.
- R_PDS_TIMES [undetermined]: Primary/secondary PDS receipt times and SEC post/dissemination times for the reported filings; source records say the author timing data came from a PDS subscriber and exact event timing varies by subscriber.
- R_SEC_FILINGS [public_acquisition_required]: EDGAR indexes and Form 4/Form 4/A filing contents for March 2012–December 2013, including author-needed filing, acceptance and insider/company fields.
- R_SEC_FTP_TIMES [undetermined]: SEC FTP date-time observations scraped by the authors in May 2015; relationship to the PDS and website timing rows must be clarified.
- R_TR [undetermined]: Thomson-Reuters Insider Trading Table 1 with the documented transaction, role, date, cleanse, CUSIP, price and share fields.
- R_FUNDQ [undetermined]: Compustat fundq observations used for the nine-digit-CUSIP link that supplies CIK and gvkey before joining EDGAR data.
- R_TAQ [undetermined]: Daily TAQ quote and trade files (author CQ/CT), linked to CRSP, for event windows and the 52-week normal-volume construction.
- R_CRSP [undetermined]: CRSP daily stock file (dsf) for bidlo/askhi and CRSP identifiers in the TAQ-CRSP link.
- R_FUNDA [undetermined]: Compustat funda total assets, joined by gvkey and acceptance year for supplementary analyses.
- R_RAVENPACK [undetermined]: RavenPack Dow Jones story archive matched to permno/CUSIP and filtered by relevance, story category and time after first dissemination.
- S_SAS [unverified]: The author documentation says SAS was used. The bounded local startup probe failed to initialize TKELS and returned no version; this does not establish a missing license or prove SAS unavailable.
- S_TCLINK [preparation_required]: The official WRDS page publishes the named link macro, but WRDS data subscriptions and compatibility of the documented historical macro with the authors’ period and required CUSIP/symbol match remain to be confirmed. No local catalog hit was found.
- S_NBBO [unverified]: The authors cite NBBO.sas, but it is not in the package, the bounded catalog query returned no candidate, and the old source URL could not be accessed during the bounded page check. Current equivalent code and version are not verified.

## Review notes

- Expanded draft saved after complete reading of the two author PDFs, package member inventory and existing one-row workbook/environment probes, plus bounded SEC-root metadata, exact frozen catalog lookups and official SEC/WRDS/NYSE source pages. No dataset downloads, author code, installations or applied patches were performed.
- There are no frozen dependency IDs for this item. The assessment independently covers each source named by the authors and links unresolved data, software and workflow issues to actions.
- The SEC index/filing route is verified for public index coverage from 1994Q3 onward and the official raw filing archive. Author-specific parser outputs, sample-level match and the proprietary PDS subscriber timing series remain distinct unresolved inputs.
- The NYSE Daily TAQ archive and WRDS TCLINK page are public product/macro leads. Historical license access, WRDS CQ/CT file compatibility, current NBBO.sas and author-specific macro versions remain unresolved. No catalog miss implies absence of licensing.
- The bounded local SEC check confirmed only that two documented corpus roots exist. It did not read filings, match filenames or establish period/form/field coverage.
- The workbook identifies 4,782 SEC filenames; its supplied one-row probe contains only CIK, file_name and secdate and does not establish a full analysis input. No analysis_only scope is justified.
- SAS 9.4 is unverified because startup failed at TKELS. Python 3.12.14 and Stata 18 are available, but author programs are absent. execution_verified remains false.
- Common-resource QA update saved: frozen catalog discovery found local Compustat fundq/funda, CRSP dsf/dsf_v2, Thomson Reuters TFN Table 1/2, and RavenPack category metadata candidates; exact TAQ.CQ/CT lookups returned no match. Reused same-run one-row fundq/funda/dsf probes only where exact file paths matched. Missing fields, coverage, archives and vintage remain explicit.
