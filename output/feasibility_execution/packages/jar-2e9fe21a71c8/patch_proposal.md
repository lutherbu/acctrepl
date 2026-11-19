# Patch proposal: jar-2e9fe21a71c8

The Roles of Data Providers and Analysts in the Production, Dissemination, and Pricing of Street Earnings

DOI: 10.1111/1475-679X.12457

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author-preparation workflow from WSH and WRDS inputs through SAS 001–009, the five-source Python/F# and RavenPack RAR container 010, R 011, Stata 012, R 013, and Stata 014. The RAR is a source container, not a directly executable driver; its member programs and handoffs are documented in the trace. The final supplied stage creates the analyst-level dataset; no full analysis panel or separate analysis-only route is supplied.

Entry points: `001-import-wsh-to-sas.sas`, `002-merge-initial-sample-data.sas`, `003-collect-future-earnings-data.sas`, `004-collect-analyst-outcome-data.sas`, `005-collect-raw-taq-data.sas`, `006-compute-taq-variables.sas`, `007-collect-analyst-firm-qtr-data.sas`, `008-collect-additional-controls.sas`, `009-link-main-sample.sas`, `011-convert-sas-to-stata.R`, `012-final-wins-firm-qtr-dataset.do`, `013-merge-analyst-firm-qtr-with-wins-sample.R`, `014-final-wins-analyst-firm-qtr-dataset.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 5/12457 - The-Roles-of-Data-Providers-and-Analysts-in-the-Production-Dissemination-and-Pricing-of-Street-Earnings/bmsw-datasheet-code-and-identifiers.zip",
      "sha256": "309c2be291477df7168296134745b3928f64dffe32b31eccfe864cc4d795a60b"
    },
    {
      "path": "JAR-Volume 60/Issue 5/12457 - The-Roles-of-Data-Providers-and-Analysts-in-the-Production-Dissemination-and-Pricing-of-Street-Earnings/bmsw-online-appendix.pdf",
      "sha256": "40e0b21f47c5ec30f85cc60e71feaec3d7197cba405e4ebb328f84e59b064950"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "5649a28ada1f6846806666344cf10d614b011d42e0bd62230e329899148b05a9"
}
```

## Proposed actions

### ACT_WSH_INPUTS: Establish an authorized route to the two WSH annual XML histories and their exact map files before SAS 001 is prepared.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_WSH_LEGACY, REQ_WSH_LEGACY_MAP, REQ_WSH_MODERN, REQ_WSH_MODERN_MAP, ISS_INPUT_CLOSURE
Evidence: E_WSH_LEGACY_SOURCE, E_WSH_MODERN_SOURCE, E_DATASHEET_HISTORY, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Confirm that the permitted WSH delivery includes EPS_ACTUALS legacy XML for 2006–2016 with wshmapv2.map and modern XML for 2017–2019 with wshmap2019.map.
2. Keep the modern-to-legacy field mapping authored in source 001 and confirm file naming, encoding, schema versions, and full year coverage.
3. Resolve the ordinary WSH data root used by SAS_EXECFILEPATH-relative paths without altering the sample or data definitions.

Validation to perform later:

- After authorized files are provisioned, perform bounded XML/map metadata checks for all required years and compare the mapped fields to SAS 001's retained company, period, announcement-time, and EPS schema before running the author workflow.

### ACT_WRDS_CORE_INPUTS: Confirm an authorized WRDS/local route and exact product histories for the Compustat, CRSP, and I/B/E/S sources used by SAS 002–003; separately specify the ICLINK mapping producer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMP_FUNDQ, REQ_COMP_SECURITY, REQ_CRSP_CCMXPF, REQ_IBES_ACTUALS, REQ_IBES_ID, REQ_ICLINK, REQ_CRSP_STOCKNAMES, REQ_CRSP_DSF, ISS_ICLINK_PRODUCER, ISS_SAS_REMOTE_SETUP, ISS_INPUT_CLOSURE
Evidence: E_IBES_RAW_DOWNLOAD, E_IBES_SAMPLE_PERIOD, E_ICLINK_MISSING_INPUT, E_FUTURE_QUARTER_CONSTRUCTION, E_CATALOG_PRODUCT_FIELDS, E_CATALOG_EXACT_LOOKUPS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. For each exact product, establish a permitted authorized library or local file route and confirm the required identifiers and fields: FUNDQ, SECURITY, CCMXPF, ACTU_EPSUS, I/B/E/S ID, STOCKNAMES, and DSF.
2. Resolve the source and construction of bjar.iclink and ic.iclink; do not substitute the separate I/B/E/S ID table or infer a substitute from a catalog miss.
3. Confirm announcement coverage for 2002–2019 and the later records needed to construct four future fiscal quarters for late sample observations.
4. Keep raw product routes distinct from the generated bjar.act1, bjar.master_file, and future-quarter intermediates.

Validation to perform later:

- After authorized provision, compare bounded metadata and date/key coverage to the authored joins, filters, and required forward-quarter horizon; document any unmatched histories or unresolved aliases before execution.

### ACT_RAVENPACK_INPUTS: Resolve the author RavenPack event extract and sample-specific entity mapping while retaining the catalogued RPA tables as candidates only.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_RAVENPACK_EARNINGS, REQ_RAVENPACK_SAMPLE_MAP, ISS_RAVENPACK_SAMPLE_MAPPING, ISS_INPUT_CLOSURE
Evidence: E_RAVENPACK_002_INPUT, E_NESTED_RAR, E_CATALOG_RAVENPACK, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Specify whether the full-pipeline route is the author GVKEY-keyed RavenPack earnings extract or a construction from annual RPA.RP_EQUITIES data.
2. If using the annual RPA candidate, document the sample CIK/GVKEY to RP_ENTITY_ID mapping, effective-date rule, event filters, timestamps, required story identifiers, and event history needed by the authored match.
3. Identify the producer and schema for projects.kb_sample_rp_entity_id and its relationship to the sample staged by nested rp-01; do not query a database during this assessment.

Validation to perform later:

- After the mapping and route are authorized, use bounded field/history checks to confirm timestamps, identifiers, annual coverage, and exact sample join keys before generating the RavenPack inputs.

### ACT_TAQ_INPUTS: Confirm authorized TAQ and CRSP names-history routes for the exact old/new symbol-link and modern trade construction used by SAS 005.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_TAQ_LEGACY_MAST, REQ_CRSP_MSENAMES, REQ_TAQ_MASTM, REQ_TAQ_CTM, ISS_INPUT_CLOSURE, ISS_CRSPDATES_PRODUCER
Evidence: E_TAQ_LEGACY_MAST, E_TAQ_CRSP_CROSSWALK, E_TAQ_MILLISECOND_TRADES, E_TAQ_MINUTE_OUTPUT, E_CATALOG_EXACT_LOOKUPS, E_CATALOG_PRODUCT_FIELDS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Establish availability and dates for monthly TAQ MAST_ tables used by the 1993–2015 legacy link macro, CRSP.MSENAMES, modern TAQMSEC.MASTM tables, and TAQMSEC.CTM trade tables.
2. Retain the source-coded CTM interval of 2016-01-06 through 2020-12-31 and its trade-condition filters; do not infer that raw minute trades are required outside that coded interval.
3. Preserve the supplied TCLINK macro's old/new link construction and confirm the effective-date fields delivered to stage 006.
4. Resolve whether bjar.crspdates is supplied as an author-prepared input or has a documented producer; verify its date and schema contract for the SAS 005 calendar construction.

Validation to perform later:

- After authorized files are available, check table-period presence and the exact date/symbol/condition/price/size and CRSP CUSIP-history fields with bounded metadata before preparing the derived minute tables.

### ACT_ANALYST_INPUTS: Confirm the distinct I/B/E/S products/snapshots and analyst all-star input required by stages 004, 007, and 008.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IBES_DET_EPSUS, REQ_ANALYST_ALLSTAR, REQ_IBES_GUIDANCE, REQ_IBES_FOLLOWING_2021_SNAPSHOT, REQ_IBES_FOLLOWING_2017_SNAPSHOT, REQ_IBES_STATSUM, ISS_INPUT_CLOSURE
Evidence: E_IBES_DETAIL_DOWNLOAD, E_IBES_DETAIL_FILTERS, E_ALLSTAR_INPUT, E_GUIDANCE_DOWNLOAD, E_GUIDANCE_FIELDS, E_ANALYST_FOLLOWING_INPUTS, E_IBES_SUMMARY_INPUT, E_CATALOG_PRODUCT_FIELDS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Confirm DET_EPSUS history and the exact PDF/FPI, forecast-time, fiscal-period, analyst, and actual fields required for the 2002–2019 sample.
2. Identify the author allstar file by analyst code and year, and resolve the exact 2021-04-09 FPI 1 and 2017-06-02 analyst-following snapshots as separate inputs.
3. Confirm quarterly guidance and STATSUM summary fields/history, retaining the authored filters and consensus-date joins.

Validation to perform later:

- After authorized inputs are provisioned, perform bounded field/date checks for each separate product and snapshot; verify only schema/history contracts, not analyst outcomes or numerical results.

### ACT_CONTROL_INPUTS: Resolve the additional SAS 008 control inputs, including the author-specific IO output and fiscal-quarter map, without equating metadata candidates to the expected prepared files.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_WRDS_IO_TOOL_OUTPUT, REQ_CRSP_DSI, REQ_CRSP_DSP500LIST, REQ_RDQ_FYEARQ_MAP, REQ_COMP_FUNDA_ADVERTISING, ISS_RDQ_MAP_PRODUCER, ISS_INPUT_CLOSURE, ISS_MV20_BEFORE_PRODUCER
Evidence: E_IO_TOOL_INPUT, E_SP500_INPUT, E_RDQ_ADVERTISING_MAPS, E_CATALOG_PRODUCT_FIELDS, E_CATALOG_S34, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Specify the permitted WRDS IO tool output and the definition/units of instown_perc2; decide whether TFN.S34 is an upstream route only after documenting the missing transformation and identifier mapping.
2. Identify the producer or exact source construction for rdq_fyearq and confirm its GVKEY/DATADATE/RDQ keys and FYEARQ/FQTR fields.
3. Confirm DSI dates, the local dated CRSP DSP500LIST file, and annual Compustat XAD data needed for 2002–2019 observations.
4. Verify an author-prepared m.mv_20_bef input or documented producer for the SAS 008 PERMNO/PR_DATE join, including its measure fields and date coverage.

Validation to perform later:

- After authorized files are provisioned, check the stated keys, dates, and ownership/advertising field definitions with bounded metadata before generating the additional control table.

### ACT_EDGAR_TEXT_INPUTS: Establish the complete EDGAR text branch contracts and the producer for the exact text-control DTA consumed by R 011.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_EDGAR_SAMPLE_DTA, REQ_SEC_8K_FILINGS, REQ_TEXT_DICTIONARIES, REQ_R011_TEXT_CONTROL_DTA, ISS_EDGAR_SAMPLE_PRODUCER, ISS_TEXT_CLEANING_HANDOFF, ISS_R011_TEXT_DTA, ISS_RAVENPACK_SAMPLE_MAPPING
Evidence: E_SEC_SEARCH_FILINGS, E_SEC_FULLTEXT, E_NESTED_RAR, E_R011_BRIDGE, E_CATALOG_RAVENPACK, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Obtain the author sample DTA and accession/filename manifest with the field that nested Python reads; match it to the selected public SEC filing bodies and study-period coverage.
2. Identify the unbundled-to-cleaned-directory preparation step, its exact file naming/encoding, and the two dictionary inputs used by F#.
3. Document the producer/aggregation schema that converts the per-filing F# measures and media coverage output into main_sample_KB_Controls_2021.dta with CIK/PENDS and R 011's expected text fields.
4. Resolve the sample entity mapping required by the RavenPack branch independently of generic event-table metadata.

Validation to perform later:

- After authorized sample and text products are available, check a bounded set of file headers/keys and path names against the declared producer/consumer contract; do not query the SEC or author database during this assessment.

### ACT_PATH_CONFIGURATION: Choose and document one host working/output root for the authored producer-consumer chain, retaining each distinct filename and format.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_MASTER_FILE_HANDOFF, ISS_PATH_HANDOFFS
Evidence: E_MAIN_SAMPLE_SETUP, E_R011_BRIDGE, E_R013_INPUTS, E_STATA_RMISS2, E_STATA_ANALYST, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Map the SAS 002 bjar/dbox master file and SAS 008 dr library to the same intended master-file artifact, then confirm the actual producer path.
2. Map SAS 009's SAS_EXECFILEPATH-relative main sample to R 011's SAS input path and map the text-control DTA to its exact consumer path.
3. Align R 011's DTA output with Stata 012's ..\Data input; align Stata 012's firm-quarter output with R 013's D: path; align R 013's analyst-level output with Stata 014's ..\Data input.
4. Keep output filenames, SAS/DTA formats, CIK/PENDS and IBES ticker/PENDS join keys unchanged while selecting ordinary roots.

Validation to perform later:

- Before any authorized full run, compare the chosen paths at all listed producer and consumer calls and confirm the generated file is the same artifact at each boundary.

### ACT_SOFTWARE_SETUP: Prepare the specified runtimes, libraries, remote services, and Stata add-ons after authorized access and environment ownership are confirmed.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_SAS_CONNECT_WRDS, SW_PYTHON, SW_PANDAS, SW_PYTHON_DATEUTIL, SW_SQLALCHEMY, SW_PSYCOPG2, SW_POSTGRESQL_SERVICE, SW_DOTNET_FSHARP, SW_R, SW_R_PACKAGES, SW_STATA, SW_STATA_REGHDFE, SW_STATA_RMISS2, SW_STATA_WINSOR2, ISS_SAS_REMOTE_SETUP, ISS_FSHARP_RUNTIME, SW_STATA_FTOOLS
Evidence: E_SOFTWARE_ENV, E_SOFTWARE_PACKAGE_META, E_STATA_ADDON_META, E_NESTED_RAR, E_STATA_RMISS2, E_STATA_WINSOR2, E_STATA_REGRESSIONS

Preparation / proposed procedure:

1. Confirm SAS 9.4 and SAS/CONNECT/WRDS configuration without reusing embedded author connection values; document licensed remote libraries and the intended local roots.
2. If required by the approved stages, install/configure the missing psycopg2 driver, .NET/F# runtime, R haven/tidyverse packages, Stata rmiss2(), and winsor2; do not install during this assessment.
3. Keep the metadata-confirmed Python, pandas, python-dateutil, SQLAlchemy, R, Stata, reghdfe, and ftools versions recorded; verify database service/schema access only through separately authorized means.

Validation to perform later:

- Use software/version and exact-command availability checks only after setup; before any program execution, confirm each language/runtime and library expected by the author workflow is available.

### ACT_ORDERED_RUN_PROCEDURE: After each input, software, and handoff gap is resolved, use the saved trace as the ordered run plan for the full author-preparation target.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS_INPUT_CLOSURE, ISS_RAVENPACK_SAMPLE_MAPPING, ISS_EDGAR_SAMPLE_PRODUCER, ISS_TEXT_CLEANING_HANDOFF, ISS_R011_TEXT_DTA, ISS_MASTER_FILE_HANDOFF, ISS_PATH_HANDOFFS
Evidence: E_README_SCOPE, E_NESTED_RAR, E_R011_BRIDGE, E_R013_INPUTS, E_STATA_RMISS2, E_STATA_ANALYST, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Run SAS 001 with both WSH variants/maps to produce the conformed bjar.wsh history and bjar.wsh2 consumed by SAS 002.
2. Run SAS 002 after its WSH, Compustat, I/B/E/S, CRSP, ICLINK, and RavenPack inputs are ready; its master_file/actuals intermediates feed SAS 003, 004, 006, 007, 008, and 009.
3. Run SAS 003 after 002 for four-forward-quarter variables; run SAS 004 after 002 for fanalyst3/fanalyst4/diff4; run SAS 005 to create the old/new TAQ-CRSP link and minute-trade intermediate before SAS 006.
4. Run SAS 006 after 002/004/005 to produce WMRT and analyst-event delay; run SAS 007 after 004/006 to produce all_analysts5; run SAS 008 after 002 and its separate control inputs; run SAS 009 only after the required upstream outputs, including stages 003–008, to write the firm-quarter SAS sample.
5. Within nested stage 010, the Python unbundler reads the EDGAR sample/filing references and writes per-filing 8-K documents; the missing cleaning handoff must prepare the distinct directory read by F# 8KMeasures.fs, which also needs its dictionaries and emits per-filing measures. The separate rp-01 / rp-03 / rp-05 helpers stage a sample, generate RavenPack SQL text, and produce a media-coverage DTA; their authorized SQL execution and integration into R 011 remain unresolved.
6. After the exact text-controls DTA and SAS 009 output are aligned, R 011 joins them on CIK/PENDS and writes main_sample_2021.dta; Stata 012 produces wins_sample_2021.dta; R 013 joins that with SAS 007 all_analysts5 by IBES ticker/PENDS; Stata 014 produces the final analyst-level dataset.

Validation to perform later:

- At every transition, verify the actual output path, format, expected fields, identifiers, date/history coverage, and sample-preserving join before starting the next supplied stage; execution is not verified by this static assessment.


## Remaining issues and prerequisites

- ISS_INPUT_CLOSURE [unresolved; full_pipeline]: The workflow's multiple commercial, author-local and public inputs have only metadata or source-name evidence. Required rows, permissions, product snapshots, field compatibility, join coverage and full sample history have not been verified; the four-forward-quarter construction may extend beyond 2019.
- ISS_ICLINK_PRODUCER [unresolved; full_pipeline]: SAS 002 and SAS 008 read ICLINK data to assign PERMNO, but no producer or exact local path for `bjar.iclink` / `ic.iclink` is supplied. The mapping is not replaced by the separate IBES ID table.
- ISS_RDQ_MAP_PRODUCER [unresolved; full_pipeline]: SAS 008 reads `rdq_fyearq` and joins it by GVKEY, DATADATE, and RDQ to add FYEARQ/FQTR. No producer, deduplication rule, or exact history contract for that map is supplied; COMP.FUNDQ metadata is only an upstream candidate.
- ISS_MASTER_FILE_HANDOFF [unresolved; full_pipeline]: SAS 002 creates `bjar.master_file` and a `dbox.master_file` copy, while SAS 008 reads `dr.master_file` from a separate author Data root. The configured library mapping, exact file identity, and field compatibility across this handoff are unspecified.
- ISS_RAVENPACK_SAMPLE_MAPPING [unresolved; full_pipeline]: SAS 002 consumes an author GVKEY-keyed RavenPack earnings table; nested SQL generation instead requires the sample-specific `projects.kb_sample_rp_entity_id` mapping. The generic RPA entity-mapping catalog candidate does not establish this sample join, its producer, or its effective dates.
- ISS_EDGAR_SAMPLE_PRODUCER [unresolved; full_pipeline]: Nested Python expects an author-prepared EDGAR sample DTA with `fname` filing references; no producer matching the SAS main sample or sample-ID list is supplied. The accession/filename mapping and exact sample period remain unknown.
- ISS_TEXT_CLEANING_HANDOFF [unresolved; full_pipeline]: The Python unbundler writes filing documents to one directory, while F# reads a distinct cleaned-input directory; the field-preserving cleaning, renaming and copy handoff is not supplied. The F# dictionaries are also absent from the five-member container.
- ISS_R011_TEXT_DTA [unresolved; full_pipeline]: R 011 requires `main_sample_KB_Controls_2021.dta` with CIK/PENDS and named text-control fields. None of the five nested programs produces this exact file or schema; per-filing measures and the separate media-coverage output do not establish the required combined table.
- ISS_PATH_HANDOFFS [preparation; full_pipeline]: The authored stages mix SAS_EXECFILEPATH-relative output, author D: roots and Stata ..\Data roots. In particular SAS 009 to R 011, R 011 to Stata 012, Stata 012 to R 013, and R 013 to Stata 014 need one explicit shared output/current-directory configuration and exact path verification.
- ISS_SAS_REMOTE_SETUP [unresolved; full_pipeline]: SAS sources require WRDS remote sessions, remote LIBNAMEs, local libraries, and author-specific roots. Runtime/license/SAS CONNECT availability and authorized account access are unverified; embedded author connection values were not used or reproduced.
- ISS_FSHARP_RUNTIME [preparation; full_pipeline]: The supplied F# preparation program is substantive code, but the bounded software metadata check found no .NET/F# runtime command. Runtime setup and the exact invocation remain to be prepared; no compile or execution was attempted.
- ISS_CRSPDATES_PRODUCER [unresolved; full_pipeline]: SAS 005 reads bjar.crspdates to construct the NYSE/NASDAQ minute calendars, but none of the 14 supplied stages produces this table or identifies its exact author-prepared source. Its schema, date population, and route remain unverified. An author-prepared table or documented compatible construction remains the route to check; the absent producer does not establish unavailable CRSP access or a confirmed code blocker.
- ISS_MV20_BEFORE_PRODUCER [unresolved; full_pipeline]: SAS 008 joins m.mv_20_bef on PERMNO and PR_DATE while building a control intermediate, but no supplied stage produces this table or specifies its measure fields and date coverage. An author-prepared input or documented compatible construction remains the route to verify. The missing producer is an unresolved input contract, not evidence that data or entitlement is unavailable.
- REQ_WSH_LEGACY [undetermined]: WSH EPS_ACTUALS legacy XML history used by SAS 001 for 2006–2016, with company/security identifiers, fiscal period, announcement timestamp, and EPS values.
- REQ_WSH_LEGACY_MAP [undetermined]: The WSH XML map file `wshmapv2.map` required to read the legacy EPS_ACTUALS XML through SAS XMLV2.
- REQ_WSH_MODERN [undetermined]: WSH modern EPS XML history used by SAS 001 for 2017–2019 and normalized to the legacy company/ticker/time/EPS fields.
- REQ_WSH_MODERN_MAP [undetermined]: The WSH XML map file `wshmap2019.map` required to read each modern EPS XML file through SAS XMLV2.
- REQ_COMP_FUNDQ [undetermined]: Quarterly Compustat fundamentals used by SAS 002, 003, and 008 for sample matching, future earnings/cash-flow measures, special items, and fiscal-quarter fields. Late 2019 observations may require four later quarters.
- REQ_COMP_SECURITY [undetermined]: Compustat security identifiers used by SAS 002 to link WSH/security records into the firm-quarter sample.
- REQ_CRSP_CCMXPF [undetermined]: CRSP/Compustat CCM link history used by SAS 002 to map PERMNO to GVKEY at announcement dates.
- REQ_IBES_ACTUALS [undetermined]: I/B/E/S unadjusted actual EPS records used by SAS 002 and 003, including announcement/activation dates and future quarterly observations.
- REQ_IBES_ID [undetermined]: I/B/E/S ID history used to map identifiers and construct primary/diluted basis (PDI) intervals for the earnings data.
- REQ_ICLINK [undetermined]: I/B/E/S-to-CRSP ICLINK ticker/PERMNO score link referenced by SAS 002 and SAS 008.
- REQ_CRSP_STOCKNAMES [undetermined]: CRSP historical names and security attributes used to filter and map I/B/E/S and WSH announcements to PERMNO.
- REQ_CRSP_DSF [undetermined]: CRSP daily stock file used for two-trading-day lag prices/adjustment factors and later event-window/firm-size/age measures.
- REQ_RAVENPACK_EARNINGS [undetermined]: RavenPack earnings-event history consumed by SAS 002 as an author-prepared GVKEY-keyed table with UTC timestamps and story-strength fields.
- REQ_IBES_DET_EPSUS [undetermined]: I/B/E/S detailed EPS forecast and realized-value data used in SAS 004 to construct analyst outcomes and analyst-level merges.
- REQ_TAQ_LEGACY_MAST [undetermined]: Monthly legacy TAQ MAST tables read by the supplied TCLINK macro to build the older symbol/PERMNO link used by SAS 005.
- REQ_CRSP_MSENAMES [undetermined]: CRSP names history used in SAS 005's TAQ–CRSP link construction by CUSIP and effective date.
- REQ_TAQ_MASTM [undetermined]: Modern millisecond TAQ MASTM period tables used to construct the newer TAQ symbol/PERMNO link in SAS 005.
- REQ_TAQ_CTM [undetermined]: TAQMSEC consolidated trade records used by SAS 005 to derive minute-level trade counts, sizes, values, and VWAP.
- REQ_ANALYST_ALLSTAR [undetermined]: Author-local analyst all-star list joined in SAS 007 by analyst code and year to create the allstar indicator.
- REQ_WRDS_IO_TOOL_OUTPUT [undetermined]: The WRDS institutional-ownership-tool output read by SAS 008, expected to contain PERMNO, report date, and the author-defined ownership percentage.
- REQ_IBES_GUIDANCE [undetermined]: I/B/E/S detail guidance records used by SAS 008 to construct quarterly EPS guidance measures.
- REQ_CRSP_DSI [undetermined]: CRSP daily security index dates used by SAS 008 to assign trading days and construct event-relative calendar windows.
- REQ_CRSP_DSP500LIST [undetermined]: Dated CRSP S&P 500 membership list read by SAS 008 to construct the sample's index-membership indicator.
- REQ_IBES_FOLLOWING_2021_SNAPSHOT [undetermined]: The April 9, 2021 I/B/E/S FPI 1 detail snapshot used by SAS 008 to seed firm-months for the twelve-month analyst-following measure.
- REQ_IBES_FOLLOWING_2017_SNAPSHOT [undetermined]: The June 2, 2017 I/B/E/S detail snapshot used by SAS 008 to count analysts issuing one-year-ahead forecasts in the preceding twelve-month window.
- REQ_IBES_STATSUM [undetermined]: I/B/E/S summary statistics used by SAS 008 for consensus surprise and bad-news measures.
- REQ_RDQ_FYEARQ_MAP [undetermined]: The author-local `rdq_fyearq` map read by SAS 008 to add fiscal-year and quarter fields from GVKEY, DATADATE, and RDQ.
- REQ_COMP_FUNDA_ADVERTISING [undetermined]: Annual Compustat fundamentals advertising expense used by SAS 008 to attach XAD to the firm-quarter sample.
- REQ_EDGAR_SAMPLE_DTA [undetermined]: The author-prepared EDGAR sample DTA consumed by nested Python, including the `fname` filing-body reference needed to locate each 8-K.
- REQ_SEC_8K_FILINGS [undetermined]: SEC 8-K filing bodies selected by the author sample and consumed by nested Python/F# to produce text-based measures.
- REQ_RAVENPACK_SAMPLE_MAP [undetermined]: Author-specific sample-to-RavenPack entity mapping required by the nested RP SQL generator to attach events to the study's CIK/sample.
- REQ_TEXT_DICTIONARIES [undetermined]: The author dictionary files used by F# `8KMeasures.fs` to classify unexcluded charges and generate document-level text measures.
- REQ_R011_TEXT_CONTROL_DTA [undetermined]: The exact text-control DTA read by R 011, with sample keys and the per-filing/text aggregate fields expected by the SAS-to-Stata bridge.
- SW_SAS [unverified]: SAS programs 001–009 require SAS. The machine has a SAS 9.4 executable path in the existing metadata record, but runtime startup, license state, autoexec libraries, and execution context remain unverified; no SAS session was started.
- SW_SAS_CONNECT_WRDS [unverified]: The SAS stages use remote WRDS sessions and downloads. Availability of SAS/CONNECT, author library setup, and authorized remote access was not tested or inferred from embedded connection text.
- SW_PSYCOPG2 [preparation_required]: Both psycopg2 and psycopg2-binary distributions were absent from the metadata check. Any future authorized PostgreSQL stage would need the prescribed driver and connection setup; no database was contacted.
- SW_POSTGRESQL_SERVICE [unverified]: The nested program references PostgreSQL staging, but service reachability, schema, and authorization were not checked; source-embedded connection information was not used.
- SW_DOTNET_FSHARP [preparation_required]: No dotnet, F# interactive/compiler, or Mono command was found by the saved bounded software metadata inspection; the F# source was not compiled or run.
- SW_R_PACKAGES [preparation_required]: Metadata reports haven and tidyverse are not installed, while the supplied R bridges use R data import and tidyverse operations. No packages were installed or loaded.
- SW_STATA_RMISS2 [preparation_required]: The exact Stata function lookup did not find rmiss2() or its checked helper; install/configure the required add-on in a future authorized preparation step.
- SW_STATA_WINSOR2 [preparation_required]: The exact Stata command lookup did not find winsor2 in the checked adopaths; configure the required add-on before future execution.

## Review notes

- The frozen paper identity matches the explicit author README and datasheet. This assessment credits the downloaded package workflow and does not infer unprovided paper-wide analyses from the final supplied dataset-preparation programs.
- The selected scope is the full supplied 14-stage workflow, including SAS 001–009, the five source members statically bound to nested RAR stage 010, R 011, Stata 012, R 013, and Stata 014. The RAR is a source container rather than a directly executable driver. sample_ids.csv is an identifier list, not a prepared analysis panel; no separate analysis-only route is established.
- All 167 checklist dependency IDs are reviewed. Generated chains cite source statements and the ordered trace for producer/consumer names, fields, and order. Data and software metadata are bounded candidates only and do not establish row access, license, product equivalence, or complete history. The author-prepared bjar.crspdates and m.mv_20_bef contracts remain unresolved; neither a missing producer nor a catalog result is treated as proof of unavailable access.
- Source interpretation used credential-safe scanned views; no credential value or complete credential-bearing statement is included in new evidence or prose. Process-history evidence rows E_PROCESS_INCIDENT and E_REDACTION_SCAN are unused in every scientific evidence_ids list. The root disposition releases this same worker for redacted static completion only and is neither retrospective authorization nor acceptance. It records an out-of-scope display; no connection, query, or author execution is reported, and credential validity or external use was not tested. No separate worker-saved original stdout/stderr/return-code capture or before-source-copy exists; those limits are retained without reconstructing lost bytes.
- No author program was run, imported, parsed, or compiled; no SAS session was started; no database/API was queried; no data/model/API payload was retrieved; and no installation, source edit, or acquisition was made. execution_verified remains false. The coordinator will perform the independent secret-safe QA and frozen replay; this pair is not marked accepted.
