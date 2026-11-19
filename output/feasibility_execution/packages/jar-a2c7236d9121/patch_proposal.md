# Patch proposal: jar-a2c7236d9121

Do Firms Strategically Internalize Disclosure Spillovers? Evidence from Cash-Financed M&As

DOI: 10.1111/1475-679X.12337

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Supplied author data-preparation workflow: SAS constructs and exports the deal-day input; Stata consumes it and creates bidder_disc.dta. No regression/table estimation code or packaged analysis-ready panel is supplied; the SDC-number CSV is an identifier list only.

Entry points: `kvy_jar_code_part1.sas`, `kvy_jar_code_part2.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 5/12337 - Do-Firms-Strategically-Internalize-Disclosure-Spillovers-Evidence-from-Cash-Financed-M-As/kvy-datasheet-code-and-identifiers.zip",
      "sha256": "9350c17360125f720fc634570fdf72590a4730410fb2b85ffd1c7f579924576b"
    },
    {
      "path": "JAR-Volume 58/Issue 5/12337 - Do-Firms-Strategically-Internalize-Disclosure-Spillovers-Evidence-from-Cash-Financed-M-As/kvy-online-appendix.pdf",
      "sha256": "3831749a3c9b8cbf2b9c237ba8ba2fb3f97a074b001cebaf6bb09c9106bb2246"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "d227c8ff003f27e6f260e6a44c6351194a543357947153877fe5518d97fce81d"
}
```

## Proposed actions

### A001: Resolve the SDC deal-table route, full retained author-column contract, and author-added acquirer/target PERMNO identifiers.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R001, I003
Evidence: E002, E012, E013, E019, E027, E028

Preparation / proposed procedure:

1. Prefer the exact author-modified 1998–2018 SDC extract and verify the complete R001-author field contract, including acquirer_name, target_name, percent_shrs_acquired, percent_owned_after, price_per_share, percent_other, percent_unknown, and both PERMNO identifiers.
2. If using local SDC.WRDS_MA_DETAILS, map only source columns confirmed by its one-row probe and provide a documented PERMNO crosswalk with deal-date logic; do not guess links from CUSIP/name or infer unobserved author fields.
3. Treat deal_value_dollars, num_bidders, deal flags, cyear, and announcement-relative date fields as generated from SDC source columns/dates; activism is joined from the separate SharkWatch input, not requested as an SDC column.

Validation to perform later:

- Check the exact author SDC fields, including the seven retained columns and PERMNO identifiers, against the input contract at SAS lines 123–125; then validate the 2000–2017 announcement sample and author joins before panel construction.
- Confirm deal_value_dollars/num_bidders/flags/date fields are produced from their code inputs and activism is supplied by the separate SharkWatch join, rather than treating them as additional raw SDC columns.

### A002: Obtain the author-compatible SharkWatch deal/activism input through an authorized route.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R002
Evidence: E019, E013

Preparation / proposed procedure:

1. Locate the author-prepared table or an authorized FactSet SharkWatch route with deal_num and activism fields.
2. Keep current product entitlement and historical coverage unverified until the actual input route is checked.

Validation to perform later:

- Confirm one compatible activism value/record per deal_num and verify the join to the SDC sample.

### A003: Use the readable common COMP.FUNDA and CCMXPF_LNKHIST candidates only with verified date coverage and a coherent local or WRDS execution context.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R003, R004
Evidence: E003, E012, E013

Preparation / proposed procedure:

1. The exact local tables and required source columns are readable by bounded one-row probes.
2. Configure the code to use either the existing WRDS remote libraries or the exact local common table paths; if replacing the RSUBMIT branch, preserve COMP.FUNDA filters and CCM date/link criteria.

Validation to perform later:

- Before a full run, verify date ranges from > 01JAN1990 through the required fiscal observations; check CCM linkdt/linkenddt/linktype for acquirer and target mapping and maintain one deal row after sorting/deduplication.

### A004: Use the readable CRSP MSF/DSF/DSI common-table candidates without changing the authored return formulas, and configure table names/paths coherently.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R005, R006, R007
Evidence: E005, E012, E013, E021

Preparation / proposed procedure:

1. Exact local CRSP.MSF, CRSP.DSF and CRSP.DSI tables are readable with the fields used by SAS.
2. The local library file names are msf, dsf and dsi; the code calls crsp.msf inside RSUBMIT and crsp.crsp_dsf/crsp.crsp_dsi outside it. Choose the WRDS route or a working-copy local route and update every affected call consistently; do not assume changing a local LIBNAME affects the remote session.

Validation to perform later:

- Verify the event-window history: MSF must include each target’s first observed date and prior 365-day returns; DSF/DSI must include the full interval beginning about 300 trading days before announcement through 46 trading days after effective date. Confirm date/PERMNO coverage and ret/vwretd compatibility.

### A005: Acquire the exact 2007 BEA IO/crosswalk source tables and produce the author-format inputs only after the source-table and measure mapping are established.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R008, R009
Evidence: E004, E016, E017

Preparation / proposed procedure:

1. Use the official BEA annual Input-Output page for 2007 benchmark data and the linked BEA Industry and Commodity Codes/NAICS concordance candidate.
2. The SAS input fields are bea_code_supplier, bea_code_customer, importance_supplier_to_customer and importance_customer_to_supplier, plus NAICS6-to-2 crosswalk fields. Ask for the author-prepared tables or exact mapping/measure instructions if the official files do not expose these fields directly.

Validation to perform later:

- Check 2007 industry/commodity code version, row keys, supplier/customer direction, units/importance definition and NAICS mapping before joining to deal records.

### A006: Resolve the separate US_public_earncorr producer/input required by the supplied SAS stage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R010, I001
Evidence: E005

Preparation / proposed procedure:

1. Obtain the author-prepared US_public_earncorr table or the separate SAS program plus its inputs/schema. Do not infer a quarterly Compustat computation from the variable name alone.

Validation to perform later:

- Confirm deal_num and earncorr_12q fields and one compatible row per deal_num before the unconditional SAS join.

### A007: Locate the author-compatible RavenPack PR Edition input or its authorized historical WRDS route.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R011
Evidence: E001, E005, E018

Preparation / proposed procedure:

1. Use the PR Edition product family named in the author source, not an assumed Full Edition substitute.
2. Verify delivery/access and the required date, PERMNO, story, source, relevance, ensemble and CSS fields; current access remains unknown.

Validation to perform later:

- Confirm author sample period and four wire-source codes, then validate PR Edition variable names and date/PERMNO joins before aggregation.

### A008: Obtain the author-processed Factiva text result table or a sufficiently specified authorized collection/processing route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R012
Evidence: E001, E009, E020

Preparation / proposed procedure:

1. Prefer the author file data.kvy_factiva_import_20190604 containing article dates, distributors, word counts and positive/negative/macro-word counts.
2. If reproducing from Factiva articles, confirm the deal/article search, pre-negotiation-to-completion+60 windows, source filters and 50-word rule; do not substitute raw news access for the coded result table.

Validation to perform later:

- Check fields dealnumber/date/distributor/word counts and deduplicated story IDs, then validate deal-day count/sums and the Stata article-count filter.

### A009: Verify SAS and its required modules in the host execution context, keep Stata 18, and provide the two missing Stata add-on commands.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SAS, SASCONNECT, SASPCFILES, STATA, WINSOR2, CENTER, XTILE
Evidence: E011, E014, E015, E025, E026

Preparation / proposed procedure:

1. Resolve SAS startup/runtime availability and SAS/CONNECT plus SAS/ACCESS Interface to PC Files component availability; the TKELS startup error does not establish a missing license.
2. Install or vendor compatible winsor2 and center commands in an accessible Stata adopath; do not change their authored options.
3. Keep the installed _gxtile function and Stata 18 runtime available.

Validation to perform later:

- Record `which winsor2`, `which center`, `which _gxtile`, and SAS host/module checks before running the author workflow.

### A010: Set a coherent project root, shared SAS export/Stata import location, and authorized source library paths in a working copy.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I002
Evidence: E003, E006, E007, E020, E025

Preparation / proposed procedure:

1. Follow common/README.md: run through the host wrapper using relative or [redacted-path-365ff871b7de] paths, not Dropbox absolute paths.
2. Set the SAS DTA output and Stata current directory/import to the same project `data/kvy_cash.dta` path with an explicit .dta extension; preserve all source table names/data.
3. For external author/vendor files, configure only locations actually supplied or verified. Do not point missing inputs at the package root.

Validation to perform later:

- Confirm SAS wrote a readable DTA with all Stata-consumed variables to the configured path, then confirm Stata reads that exact file before continuing the Step 9-12 sequence.

### A011: Resolve the missing SDC-to-CRSP PERMNO field/mapping needed by the author-modified deal table.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I003
Evidence: E002, E012, E013

Preparation / proposed procedure:

1. Provide the author-modified SDC table with acquirer_permno and target_permno or the author-specified identifier crosswalk and date-matching procedure.
2. Do not infer a replacement from available CUSIPs, names or a different release without the documented mapping.

Validation to perform later:

- Confirm each included SDC deal retains the same author acquirer/target PERMNO identifiers and joins to CRSP data.

### A012: Run the supplied preparation sequence only after inputs, software and coherent paths are supplied and verified; no table-estimation code is included.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R001, R002, R003, R004, R005, R006, R007, R008, R009, R010, R011, R012, I001, I002, I003, SAS, SASCONNECT, SASPCFILES, STATA, WINSOR2, CENTER, XTILE
Evidence: E021

Preparation / proposed procedure:

1. Run kvy_jar_code_part1.sas first and confirm its kvy_cash DTA export.
2. Then run kvy_jar_code_part2.do from the shared project root; preserve its generated temp1, temp2, rank, ret_std, temp3 and final bidder_disc files.
3. Record output counts, schemas, expected periods and log/status without claiming the paper regressions were reproduced.

Validation to perform later:

- Confirm ordered SAS-to-Stata handoff and intermediate schemas; run only after separate execution authorization and data access are in place.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: SAS unconditionally joins data.US_public_earncorr and retains earncorr_12q; the package header says the alternative proxy comes from another SAS program, but that producer/program/schema is absent. This table is a required input to the supplied SAS output-producing stage even though Stata does not subsequently read the field.
- I002 [preparation; full_pipeline]: SAS exports kvy_cash with DBMS=DTA under the author Windows Data folder; Stata sets the author Windows project root and reads data/kvy_cash.dta. Configure one coherent project root, Data/data subfolder and explicit .dta output/consumer path in a working copy. This is routine setup; do not change data definitions.
- I003 [unresolved; full_pipeline]: The author SDC extract adds acquirer_permno and target_permno. The readable local SDC.WRDS_MA_DETAILS candidate has deal/date/party/payment fields but no PERMNO columns, and no supplied code maps its CUSIPs to CRSP PERMNOs. The local table is not a compatible replacement until that specific mapping/author extract is supplied.
- R001 [undetermined]: SDC M&A deal table used for the U.S. public cash-deal sample. The author-modified table adds acquirer_permno and target_permno; the bundled CSV is only deal_num identifiers.
- R002 [undetermined]: FactSet SharkWatch deal-to-activism input joined to the SDC deal sample.
- R003 [undetermined]: Annual Compustat fundamentals read inside the WRDS RSUBMIT block to create fiscal-date acquirer/target controls.
- R004 [undetermined]: CRSP/Compustat historical link table used to map Compustat GVKEY to PERMNO.
- R005 [undetermined]: CRSP monthly stock file for target first observation/firm age and target one-year return.
- R006 [undetermined]: CRSP daily stock file for acquirer and target daily returns and deal-day panels.
- R007 [undetermined]: CRSP daily market index file for value-weighted market returns paired to CRSP daily stock returns.
- R008 [undetermined]: BEA-to-NAICS industry-code mapping used to assign BEA codes.
- R009 [undetermined]: BEA 2007 input-output commodity-flow table used for horizontal and vertical merger classification.
- R010 [undetermined]: Precomputed quarterly earnings-covariance input joined into the SAS output as earncorr_12q.
- R011 [undetermined]: RavenPack Press Release Edition data for issuer press releases. The author code reads the PR Edition SAS table, not Full Edition.
- R012 [undetermined]: Author-processed Factiva article-level word-count/text-analysis results for daily deal aggregation.
- SAS [unverified]: Code uses DATA steps, PROC SQL, SORT and CORR. Environment probe failed during TKELS initialization, so runtime/product availability is unverified, not established absent.
- SASCONNECT [unverified]: The program uses SIGNON, RSUBMIT/ENDRSUBMIT and PROC UPLOAD/DOWNLOAD against WRDS. No remote connection or SAS/CONNECT component check was completed.
- SASPCFILES [unverified]: PROC EXPORT uses DBMS=DTA. SAS documentation lists Stata .dta import/export under SAS/ACCESS Interface to PC Files; component availability is unverified.
- WINSOR2 [preparation_required]: The Stata program calls winsor2 twice; the existing runtime probe did not find it in the checked adopaths.
- CENTER [preparation_required]: The Stata program calls center; a self-written Stata 18 which probe returned unavailable in checked adopaths.

## Review notes

- First expanded review checkpoint. The selected target is the actual supplied SAS preparation followed by the supplied Stata panel-construction file. The work-item dependency checklist contains 15 SAS reads plus five Stata file dependencies; all 20 IDs are now reviewed, with WORK/temp files classified as generated. The trace at probes/workflow_trace.json records the full producer-consumer sequence and input history.
- The author-documented SEC Background-of-the-Merger search is not read by either supplied program. The code constructs date_negstart as 60 weekdays before announcement; the SEC narrative is contextual only for this target, not a mandatory dependency or prerequisite.
- The packaged SDC CSV is identifiers only. The local SDC.WRDS_MA_DETAILS one-row schema lacks the acquirer/target PERMNO variables added to the author extract. Local COMP.FUNDA, CCMXPF_LNKHIST, MSF, DSF and DSI tables are readable candidates with row-limited probes; their history, population and code-context compatibility remain unverified.
- No author code was executed and no dataset downloaded/installed. R010 US_public_earncorr has a missing separate producer, FactSet SharkWatch and Factiva-processed results are absent, RavenPack input must remain PR Edition-specific, and BEA public routes still need exact author-format mapping.
- The Stata file stops after saving a constructed bidder_disc.dta. It does not estimate or export the paper tables. No compatible analysis-ready panel is packaged, so an analysis_only scope is not supported. Appendix results are contextual and do not add entry points.
- The Stata helper probes find center and winsor2 unavailable in checked adopaths, while _gxtile and Stata 18 are available. SAS startup was unverified after the TKELS error; SAS/CONNECT and SAS/ACCESS Interface to PC Files also remain unverified.
