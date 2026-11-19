# Patch proposal: jar-a31be7963cf0

Competitive Externalities of Tax Cuts

DOI: 10.1111/1475-679X.12403

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The single supplied native SAS entry point covers the author-documented Compustat preparation, AJCA/TNIC preparation, competitor variable construction, rival-action workflow and loan-cost branch. No separate analysis-only route is supported by the three packaged identifier lists.

Entry points: `DJL-datasheet-code-and-identifiers/DJL-program.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 1/12403 - Competitive-Externalities-of-Tax-Cuts/djl-datasheet-code-and-identifiers.zip",
      "sha256": "d8791424704bfd7a8fddb5e1dafa5b9dec85710b62368617cd30f3f902fe3963"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "59f338d733cf1fc1c585752994c751d71ba054ee361741f231aad628e4807902"
}
```

## Proposed actions

### A_INPUTS: Obtain exact author prepared inputs and map every external product to its required table, fields and history before configuring the native run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PATHS, I_ROBERTS_LINK, R_ANNUAL, R_QUARTERLY, R_TNIC, R_RATING, R_TSIM, R_FLUIDITY, R_SPREAD, R_LOAN_FACILITY, R_LOAN_PACKAGE, R_AJCA_INPUT, R_ROBERTS_LINK
Evidence: E_OTHER_DATA, E_TNIC, E_CODE_SCOPE, E_RETURN_DGTW, E_LOAN_INPUTS, E_ROBERTS_LINK, E_WORKFLOW_TRACE, E_PUBLIC_TNIC_COVERAGE, E_PUBLIC_TNIC_YEAR, E_PUBLIC_COMPETITION_COVERAGE, E_PUBLIC_FLUIDITY_PAGE, E_PUBLIC_HHI_PANEL, E_PUBLIC_FLUIDITY_PANEL

Preparation / proposed procedure:

1. Request the exact prepared SAS tables or documented transformations for master, base, qtr, creditrating, hpindex_sample, dgtw, tsim, fluidity, spread, loanfacility, loanpackage, loancompustat and mainsample; record identifiers, fields, period and producer for each.
2. Acquire the official current TNIC-3, HHI/total-similarity and product-market-fluidity files through their verified public product routes, then convert them to the author’s SAS table format while preserving each existing GVKEY/year/measure contract; document the current vintage as a fidelity note.
3. Obtain the exact Michael Roberts Dealscan–Compustat workbook/version and verify facid, bcoid, gvkey and smbl_h; keep it separate from ajca.linktable, which maps gvkey to lpermno.
4. Map each author PATH placeholder to a coherent working location and define ajca library, DTA path and XLSX path in a working copy only.

Validation to perform later:

- Compare actual prepared-table metadata against each source consumer and verify identifiers, units, date periods and field meanings.
- Confirm coverage across source filters and explicit history requirements, including four quarterly observations, first-stage pifo lags and trailing 12-month returns; do not add years solely from an unstated assumption.

### A_HANDOFF: Obtain the documented manual first-stage model and exact probability-file handoff; do not infer or fit the model from the partial SAS code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_HANDOFF, R_FIRST_STAGE_DTA
Evidence: E_FIRST_STAGE_FILTERS, E_FIRST_STAGE_HANDOFF, E_PROB_CONSUMER

Preparation / proposed procedure:

1. Request the first-stage program/software, estimation sample and variable definitions, exact placement of filters following ajca.repat_prob, and the produced DTA path/schema.
2. Confirm that the DTA contains gvkey and the p field consumed at lines 1068–1072, and explain how it maps to the commented repatriation_prob sample.

Validation to perform later:

- Review the supplied export metadata and bounded identifiers before a separately authorized author run; preserve the authored 2003 sample and 1–3 year pifo history.

### A_LINEAGE: Resolve the actual producers and schemas for merge2, combined and mainsample before proposing edits or substituting in-memory outputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_LINEAGE, I_MAINSAMPLE, R_MAINSAMPLE
Evidence: E_MERGE_PATH, E_BASE_COMBINED, E_BASE29, E_PROB_CONSUMER, E_MAINSAMPLE_LOAN

Preparation / proposed procedure:

1. Ask for the author source/staging contract that creates merge2 and combined and its exact fields; confirm whether combined1 inherits add_reapt and how add_repat is derived.
2. Request the producer and row unit for ajca.mainsample, including the firm-year fields consumed by probability and loan branches; do not treat base29 as a replacement.

Validation to perform later:

- Trace each named output to the next consumer by table and field labels, preserving source names and branch boundaries until confirmed.

### A_DEFLATOR: Resolve the required gdp_2004 field against the exact packaged deflator before computing HP size.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DEFLATOR_FIELD, R_DEFLATOR
Evidence: E_DEFLATOR_FIELD, E_P_DEFLATOR

Preparation / proposed procedure:

1. Ask the author release documentation to identify the intended 2004-base GDP field or a separately supplied compatible deflator.
2. Only if the documentation establishes a numeric mapping, make that mapping in a working copy and preserve the package file unchanged.

Validation to perform later:

- Verify the mapped field name, units and fiscal-year coverage with bounded metadata before downstream size calculations.

### A_DGTW: Obtain the prepared DGTW return panel or its documented producer, identifiers and factor-adjustment method.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DGTW_INPUT, R_DGTW
Evidence: E_RETURN_DGTW, E_P_DSF, E_P_DSI, E_CATALOG_DGTW

Preparation / proposed procedure:

1. Request the exact ajca.dgtw source or author transformation that produces permno, date, ret and vwret, including required history and any risk-adjustment inputs.
2. Do not replace the DGTW panel with raw CRSP DSF/DSI based only on matching field names.

Validation to perform later:

- Check actual prepared columns and coverage for each Compustat datadate trailing window before return12/abret12 construction.

### A_SOFTWARE: Verify SAS Base runtime and the SAS/ETS and SAS/ACCESS Interface to PC Files modules required by the native program.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_SOFTWARE, S_SAS_BASE, S_SAS_ETS, S_SAS_PCFILES
Evidence: E_ENVIRONMENT, E_SAS_EXPAND_DOC, E_SAS_ACCESS_DOC, E_STAGE_LINES

Preparation / proposed procedure:

1. On the intended SAS host, confirm the installed release and SAS/ETS availability for PROC EXPAND.
2. Confirm SAS/ACCESS Interface to PC Files is licensed for the DTA and XLSX imports; no PC Files Server is assumed for direct local XLSX import on UNIX.

Validation to perform later:

- Verify module/version evidence from supported installed metadata or administrator records; the current TKELS initialization result remains unverified and is not a license diagnosis.

### A_NATIVE_ORDER: After inputs, lineage, paths and software are resolved, follow the supplied native SAS stages in their authored sequence.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_PATHS, I_LINEAGE, I_HANDOFF
Evidence: E_STAGE_LINES, E_WORKFLOW_TRACE, E_LOAN_INPUTS, E_ROBERTS_LINK, E_LAG_LEAD

Preparation / proposed procedure:

1. Run only from a working copy with the configured ajca library and exact imported DTA/XLSX inputs, following Compustat preparation, AJCA/TNIC preparation, competitor-variable construction, rival actions, then loan-cost analysis.
2. Keep the CRSP/Compustat ajca.linktable separate from the Dealscan workbook work.linktable; preserve the authored chained comparisons, source filters, lag/lead naming and missing-boundary fills.

Validation to perform later:

- Before any separately authorized execution, statically confirm every read has a named producer or supplied input and its next consumer schema is documented.


## Remaining issues and prerequisites

- I_PATHS [unresolved; full_pipeline]: Exact file locations and author-prepared table mappings remain unresolved for annual/quarterly Compustat, ratings, CRSP/DGTW and Dealscan inputs; catalog candidates and one-row probes establish only sampled fields, not author-table equivalence or historical coverage. Official public TNIC-3, HHI/total-similarity and fluidity product routes are verified; downloading and converting those products into the source’s SAS aliases remain preparation.
- I_HANDOFF [unresolved; full_pipeline]: The source prepares ajca.repat_prob, places filters after that DATA step, comments a manual regression using a “repatriation_prob” sample, and imports ajca.pr_repat from a PATH DTA. It does not identify the model/software, exact estimation sample, filter placement, exported file schema or producer for p, which is later merged by gvkey.
- I_LINEAGE [unresolved; full_pipeline]: The first stage creates merge1 from ajca.master, but the next SQL statement creates merge2 from merge2; the supplied file contains no merge2 producer. The source also creates combined1 by copying combined, derives add_repat, then selects add_reapt. Since the combined producer/schema is absent, the presence/meaning of add_reapt cannot be diagnosed.
- I_DEFLATOR_FIELD [unresolved; full_pipeline]: The exact packaged deflator passes a one-row bounded read, but the columns sampled are FYEAR, GDP_2009, GDP_1992 and GDP_2001 while source code selects gdp_2004. The code-to-file mapping needs documentation or a supported compatible file/field; do not assume a column alias.
- I_DGTW_INPUT [unresolved; full_pipeline]: Code consumes ajca.dgtw fields ret, vwret, date and permno in a trailing return calculation. No prepared DGTW producer/product is established. Raw CRSP DSF/DSI probes do not establish an equivalent DGTW panel or its author-compatible construction.
- I_MAINSAMPLE [unresolved; full_pipeline]: The supplied code reads ajca.mainsample for firm membership and firm-year loan fields. It does not write that dataset; in-memory base29 is visibly a separate output and is not evidence of an ajca.mainsample producer.
- I_ROBERTS_LINK [unresolved; full_pipeline]: The code names a Michael Roberts website and imports an XLSX worksheet into WORK.LINKTABLE with facility crosswalk fields, but the exact workbook, version, fields and coverage are not verified. Keep it distinct from ajca.linktable used for CRSP/Compustat mapping.
- I_SOFTWARE [unresolved; full_pipeline]: The native entry point requires SAS procedures including PROC EXPAND and PROC IMPORT for DTA/XLSX. The inspected SAS binary has unverified runtime status after TKELS initialization failure, and SAS/ETS plus SAS/ACCESS Interface to PC Files availability/license are unverified.
- R_ANNUAL [undetermined]: Author annual Compustat staging tables ajca.master, ajca.base, ajca.hpindex_sample and ajca.loancompustat are read. The source expects firm-year identifiers and fields including pifo, fyear, datadate, at, earnings, assets/liabilities, market-value and loan-control inputs. Annual first-stage pifo lags 1–3 imply FY2000–2003 for that operation; later source filters include FY2002–2008 and FY2003–2007. Candidate raw annual data does not establish the author staging producers or full period.
- R_QUARTERLY [undetermined]: Author quarterly staging table ajca.qtr supplies gvkey, fiscal year/quarter, saleq and atq; the source computes a four-quarter moving variance and uses fqtr=4. Population and earliest history are not established.
- R_TNIC [public_acquisition_required]: The author datasheet records 2017 collection, while the official current TNIC-3 public product has the required pairwise firm identifiers, year and score and covers the code years 2002–2008. This is a verified public acquisition route; download and conversion to the author’s SAS table format are preparation. The current product vintage can be recorded as a fidelity note.
- R_DGTW [undetermined]: The author return construction reads ajca.dgtw and consumes permno, date, ret and vwret for the trailing date window. Its prepared DGTW panel/producer is not supplied or found in the frozen catalog. Raw CRSP files are candidate source material, not an equivalent prepared panel.
- R_RATING [undetermined]: The author staging table ajca.creditrating provides gvkey, datadate and splticrm; code derives a rating flag for 2002–2008 and joins the 2003 constraint.
- R_DEFLATOR [undetermined]: Exact packaged deflator file is present and readable with a bounded one-row probe, but the author code requires gdp_2004 while the sampled file has GDP_2009, GDP_1992 and GDP_2001. No mapping is evidenced.
- R_TSIM [public_acquisition_required]: The source reads a separate firm-year TNIC HHI and total-similarity input at year 2003. The official current public product documents the expected gvkey/year identifiers and tnic3hhi/tnic3tsimm measures and covers 2003; acquisition and SAS-table conversion are preparation, with current vintage recorded as a fidelity note.
- R_FLUIDITY [public_acquisition_required]: The source reads a distinct firm-year product-market fluidity input at year 2003. The official current product readme documents the expected gvkey/year identifiers and prodmktfluid measure and its product page covers the required year; acquisition and SAS-table conversion are preparation, with current vintage recorded as a fidelity note.
- R_FIRST_STAGE_DTA [undetermined]: Manual first-stage output imported into ajca.pr_repat from a placeholder PATH DTA file; subsequent code expects gvkey and probability p. The external model, sample, file name and export contract are undocumented in the supplied release.
- R_MAINSAMPLE [undetermined]: The author source consumes ajca.mainsample to construct firm membership and later reads firm-year chg_amt_rival_repat, repatriation, firmtotalrepat and sic. A producer is not present in the supplied file; base29 is not saved under this name.
- R_SPREAD [undetermined]: Author-prepared ajca.spread is facility-level and supplies allindrawn to the loan branch. The source does not establish the exact spread series, period or construction.
- R_LOAN_FACILITY [undetermined]: Author-prepared ajca.loanfacility provides facility/package identifiers, start/end dates and loan attributes used in loan-level construction.
- R_LOAN_PACKAGE [undetermined]: Author-prepared ajca.loanpackage supplies package-level dealpurpose keyed by packageid.
- R_AJCA_INPUT [undetermined]: Hand-collected AJCA repatriation inputs underpin the author code. The datasheet states that amounts were hand-collected from SEC filings and may be available from the researchers; exact combined-file schema/history are not included. Do not independently re-collect or infer the `combined` producer.
- R_ROBERTS_LINK [undetermined]: The loan branch requires a separate Michael Roberts Dealscan–Compustat XLSX linktable imported into WORK.LINKTABLE, with facid, bcoid, gvkey and smbl_h. This is distinct from ajca.linktable, the CRSP/Compustat link history.
- S_SAS_BASE [unverified]: The author entry point is SAS. An environment record shows a SAS binary path but records runtime status as unverified after TKELS initialization failure; do not treat that as proof of missing license or retry startup. Author SAS release remains unspecified.
- S_SAS_ETS [unverified]: PROC EXPAND is used for quarterly rolling variance and multiple annual lag/lead operations; official SAS documentation places the procedure in SAS/ETS. Installation/license is not verified.
- S_SAS_PCFILES [unverified]: The source imports a Stata DTA and XLSX linktable through PROC IMPORT. Official SAS documentation states the PC Files interface must be licensed for Excel import; module availability is not verified.

## Review notes

- Static execution-feasibility assessment only. No author source was executed, imported, compiled, transformed or edited; execution_verified remains false.
- The exact packaged deflator and three identifier lists received bounded one-row checks. The deflator route is credited, with the concrete gdp_2004 field mismatch recorded. Identifier lists are not analysis panels.
- Every frozen dependency D0001–D0017 is reviewed. Author-specific producer and handoff gaps remain explicit; no data coverage is inferred from catalog observations or one-row probes.
- The duplicate SAS text file was compared with the .sas source; code body matches and only opening comment formatting differs. The .sas remains the sole author entry point.
- Current official TNIC-3, HHI/total-similarity and fluidity products are credited as verified public acquisition routes for the source’s required identifiers, measures and years. Download and SAS-table conversion remain preparation; the datasheet’s 2017 collection date is recorded as a fidelity note, not a route prerequisite.
