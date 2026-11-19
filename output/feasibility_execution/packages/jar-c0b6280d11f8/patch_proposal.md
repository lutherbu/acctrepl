# Patch proposal: jar-c0b6280d11f8

Disclosure Prominence and the Quality of Non-GAAP Earnings

DOI: 10.1111/1475-679X.12344

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Complete author-documented workflow: prominence preparation, other-data construction, final assembly, and supplied LCA analysis.

Entry points: `Downloading EA Press Releases from 8-Ks.sas`, `DownloadFilings.py`, `CheckEPS.py`, `Setup for SA CC Data Parsing in Python.sas`, `CheckEPS_CC.py`, `Process Prominence Output from Python_v1.6.sas`, `EA dates -- COMPUSTAT & IBES.sas`, `Book to Market -- COMPUSTAT & CRSP.sas`, `Institutional Ownership -- TFN & CRSP.sas`, `Gathering Other Data.sas`, `Assembling Final Dataset.sas`, `LCA Analyses.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 1/12344 - Disclosure-Prominence-and-the-Quality-of-Non-GAAP-Earnings/cgn-datasheet-code-and-identifiers.zip",
      "sha256": "d05044c5584a33fdf5bbebc9a8ae904d57991c893de936b5dd31ed52f03b858d"
    },
    {
      "path": "JAR-Volume 59/Issue 1/12344 - Disclosure-Prominence-and-the-Quality-of-Non-GAAP-Earnings/cgn-online-appendix.pdf",
      "sha256": "409e3afb65c5468ae3737a2b3a7607f2c0285c6e295dadb90a1e519d84a8608d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "4b26cf93f77f8a790ffa148338f0eef5985d60ebaca46ea39f0648e377d761f7"
}
```

## Proposed actions

### A_LOCAL_PRODUCTS: Use the listed local Compustat, CRSP, I/B/E/S and CIQ product files as candidate inputs, preserving product/adjustment families, and confirm that their record populations and construction history support the supplied field joins and date windows. The one-row probes establish readability and fields only.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMP_FUNDQ, R_COMP_FUNDA, R_CRSP_CCM, R_CRSP_MSF, R_CRSP_DSF, R_CRSP_DSI, R_CRSP_STOCKNAMES, R_IBES_ACTUALS, R_IBES_STATSUMU, R_IBES_XEPSUS, R_CIQ_KEYDEV
Evidence: E_WORKFLOW_TRACE, E_CATALOG_DISCOVERY, SAS_COMP_FUNDQ, SAS_COMP_FUNDA, SAS_CRSP_CCM, SAS_CRSP_MSF, SAS_CRSP_DSF, SAS_CRSP_DSI, SAS_CRSP_STOCKNAMES, SAS_IBES_ACTUALS, SAS_IBES_STATSUMU, SAS_IBES_XEPSUS, SAS_CIQ_KEYDEV

Preparation / proposed procedure:

1. Trace each source product to the fields and joins in its consuming SAS block; retain the author filters, firm identifiers and quarterly/annual distinctions.
2. Validate the source period and required history: Compustat event/annual joins; CRSP link periods, monthly lags and daily event/next-EA windows; I/B/E/S period and forecast/actual date matching; and CIQ event-date population.
3. Keep the raw source products as separate joint requirements; do not use the one-row catalog observation as a population or coverage count.

Validation to perform later:

- Confirm the exact product, native field names, identifiers, units and periods for each source requirement; confirm that all required rows/joins exist for the supplied events and construction windows before running the dependent program.

### A_UNMAPPED_NATIVE_PRODUCTS: Resolve the exact local/native table routes for source-named COMPHIST, CO_FILEDATE, the quarterly and annual as-unrestated snapshots, IBES.IDSUM, storage.iclink and TFN.S34. Frozen catalog misses and the TFN timeout leave availability uncertain; they are not evidence of absence or licensing barriers.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CRSP_COMPHIST, R_COMP_CO_FILEDATE, R_COMP_SNAPSHOT_Q, R_COMP_SNAPSHOT_A, R_IBES_IDSUM, R_ICLINK, R_TFN_S34
Evidence: E_CATALOG_DISCOVERY, E_TFN_PROBE, E_COMP_HISTORY_FILEDATE, E_COMP_SNAPSHOTS, E_IBES_IDSUM, E_ICLINK, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Map each source name to its exact table/file, preserving separate quarterly and annual snapshot products and the identifier/dilution histories.
2. For the local TFN.S34 catalog candidate, resolve the bounded read timeout without treating it as an absent table; confirm the report-date/share fields and 1987-2015 history.
3. If an exact route is not available locally, identify the compatible source needed for the documented fields and periods; do not infer from catalog misses or substitute unrelated products.

Validation to perform later:

- Confirm matching native tables and actual required fields: CRSP history fields for CIK joins; CO_FILEDATE filename/date/source type; snapshot period/identifier fields; IDSUM dilution history; iclink PERMNO/TICKER mapping; and TFN report-date holdings.

### A_8K_AUTHOR_INPUTS: Obtain or map the four distinct Bentley-derived 8-K branch inputs through the author-documented product/source route, and reconcile exact native fields, file format and population before running the sample/list producer.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_BCGW_NG_INPUT, R_KOOLAID_SAMPLE, R_KOOLAID_SAMPLE_2013, R_EDGAR_FILINGS_INDEX
Evidence: E_8K_CANDIDATE_INPUTS, E_8K_JOIN_INPUTS, E_AUTHOR_MANAGER_DATASET, E_CATALOG_DISCOVERY, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Verify whether the author page’s Manager Non-GAAP EPS dataset is the source for prom2.bcgw_2018_ng_data_2003to2016, koolaid.sample and koolaid.sample_2013; keep the three table requirements separate until their mapping is proven.
2. Confirm the filing-index join key/filename and date schema for storage.Edgar_filings_1993to2016.
3. Confirm the event/year population and fields that flow into the six generated filing lists; do not treat NG_FIRST/NG_FIRST_CC as a substitute for these source tables.

Validation to perform later:

- Compare native input fields and periods with the 8-K program’s source reads, derived URLs, filing dates, EPS values and the downstream parser row positions.

### A_SEC_DOCUMENTS: Assess the approved local raw and parsed SEC corpus roots against the actual filing-list population and the complete-submission/exhibit text consumed by the supplied downloader and parser.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SEC_FILING_TEXT
Evidence: E_SEC_RAW_ROOT, E_SEC_PARSED_ROOT, E_DOWNLOAD_FILINGS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Match the generated filing-list identifiers and dates to the selected local corpus records using an approved bounded route.
2. Confirm whether required complete-submission text or press-release exhibits are retained, including multiple-exhibit selection, filing sections, encoding and prior cleaning.
3. Preserve the author’s extraction/cleaning rules; use the SEC URL path already in the source only under its permitted public conditions if a local route does not provide the required text.

Validation to perform later:

- Confirm record population, 8-K type, document section, source encoding and text compatibility against the produced parser input; retain coverage and cleaning gaps explicitly.

### A_CC_AUTHOR_INPUTS: Obtain or map the nine executive lookup CSVs and the transcript text corpus referenced by the supplied crosswalk and CheckEPS_CC.py. The historical Stanford provision does not establish a current route or coverage.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_CC_EXECUTIVE_LOOKUPS, R_CC_TRANSCRIPTS
Evidence: E_CC_EXECUTIVES_SOURCE, E_CC_TRANSCRIPT_DOC, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Identify the exact versions and native rows for executives_1.csv through executives_9.csv and the CC PresSplit Management transcript directory.
2. Document transcript record unit, company/event coverage, filename convention, preparation/cleaning and period; keep transcript text distinct from the published NG_FIRST_CC measure.
3. Preserve the supplied date-link rule: transcript date is linked to earnings-announcement dates from one day before through seven calendar days after.

Validation to perform later:

- Confirm each sa_cclist_full.txt filename_cc resolves to the intended transcript and that the executive/company crosswalk preserves the expected gvkey and date keys.

### A_BUSHEE_TFN_INPUTS: Verify the documented Bushee manager/year classification file at its authored URL and its match to the independently required TFN.S34 holdings route.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_BUSHEE_CLASSIFICATION
Evidence: E_TFN_BUSHEE, E_AUTHOR_MANAGER_DATASET, E_TFN_PROBE, E_CATALOG_DISCOVERY

Preparation / proposed procedure:

1. Use only the documented public URL if currently available under its posted conditions; do not infer the data route from brand or a catalog label.
2. Verify the fixed-width manager ID/year fields and TQD_Class categories needed by the supplied ownership code.
3. Match classification years and manager identifiers to TFN.S34 holdings reports.

Validation to perform later:

- Confirm the QIX/TRA/DED classifications and report-year coverage against the code’s 1987-2015 holdings period.

### A_PROFORMA_SAMPLE: Resolve the distinct storage.Proforma_sample input used by the supplied Ted Christensen 1998-2003 assembly branch, including source, row unit, fields and producer history.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_PROFORMA_SAMPLE
Evidence: E_PROFORMA_SOURCE, E_CATALOG_DISCOVERY, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Identify the exact sample file/table and original fields gvkey, fqenddt and profirst; retain its 1998-2003 population.
2. Do not synthesize or replace this branch with NG_FIRST data or with another sample.

Validation to perform later:

- Confirm the sample’s firm-quarter key and pro forma indicator coding match the supplied merge and branch conditions.

### A_EXTERNALDATA2_CONTRACT: Resolve the supported producer, schema and aliases for the table named promin.externaldata2 before assembly or LCA; the supplied Gathering Other Data.sas output named promin.externaldata does not prove that it is the same file or field contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_LCA_INPUTS, I_EXTERNALDATA2
Evidence: E_FINAL_CONSUMERS, E_LCA_CONSUMERS, E_EXTERNALDATA_PRODUCER, E_LCA_FIELDS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Identify the exact source file/table and producer for promin.externaldata2, including working directory/library and gvkey/datadate keys.
2. Reconcile the source variable names and transformations required by final assembly and LCA, retaining ff10, calyear_1 and MEETBEAT as specific unresolved fields; do not assume FF48/calyear/eayear or rename externaldata to externaldata2.
3. If a compatible route requires conversion, document the exact input-to-output mapping without changing scientific definitions.

Validation to perform later:

- Compare every required input field and join key at both assembly and LCA consumers to the supported producer output before either branch is run.

### A_STARTUP_CONFIGURATION: Resolve the author Startup File and the real library, remote-session and utility-macro setup in a working copy while preserving source library names and source/output directory roles.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SOURCE_PATHS
Evidence: E_STARTUP_INCLUDE, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Locate or obtain the exact Startup File.sas referenced by the supplied programs; identify its WRDS/SAS-Connect configuration and utility macro definitions, including %dupl and %ff48 where invoked.
2. Set a coherent runtime working directory and writable work/output roots while preserving the authored library references such as promin, prom2, koolaid, storage, sadata and remote product libraries.
3. Resolve all author-machine paths consistently across SAS and Python producer/consumer calls, including filing-list, transcript, filing-text, parser-output and exhibit-log files.

Validation to perform later:

- Confirm that every include, library assignment, macro call and cross-language file path resolves to the intended location and writable run directory without changing the source variable definitions or stage order.

### A_SAS_RUNTIME_SETUP: Resolve the current SAS TKELS initialization failure and verify the SAS runtime and required components before any authorized future run; the bounded probe does not establish a missing license.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS, S_SAS_CONNECT, S_SAS_ETS, S_SAS_STAT, I_SAS_RUNTIME
Evidence: E_SAS_RUNTIME, E_SAS_CONNECT_SOURCE, E_SAS_DOWNLOAD_SOURCE, E_SAS_EXPAND_SOURCE, E_SAS_SURVEYSELECT_SOURCE

Preparation / proposed procedure:

1. Repair or configure the environment so the selected SAS runtime starts an empty session successfully.
2. Verify the required SAS/CONNECT RSUBMIT/PROC DOWNLOAD capability, PROC EXPAND capability, and PROC SURVEYSELECT capability with non-estimator availability checks.
3. Retain the author code version and scientific procedures; do not run the supplied programs until runtime and component availability are known.

Validation to perform later:

- Record the exact SAS release and successful empty-session launch, then confirm the named SAS/CONNECT, SAS/ETS and SAS/STAT components are available.

### A_LCA_RUNTIME_SUPPORT: Resolve the active supplied LCA branch’s PROC LCA add-on and macro/include dependencies, separately from the unprovided paper-wide general estimators.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_PROC_LCA, I_LCA_DEPENDENCIES
Evidence: E_LCA_SOFTWARE_SOURCE, E_LCA_ACTIVE_CALLS, E_DOC_WORKFLOW, E_SAS_RUNTIME

Preparation / proposed procedure:

1. Verify the exact PROC LCA add-on and compatible versions of LCA_Distal_BCH_v110.sas and LCAGraphicsV2.sas referenced by the source.
2. Resolve the definition and behavior of the invoked %winsorize_truncate macro; do not invent its winsorization or truncation science.
3. Keep omitted general estimation/tabulation code as a contextual limitation outside this supplied-code scope.

Validation to perform later:

- Confirm that the active LCA calls, output tables and external macro arguments match the supplied program and that the required components are callable in the selected runtime before any authorized analysis.

### A_PYTHON_COMPATIBILITY: Resolve whether the downloader will use a compatible Python 2 runtime or be ported to Python 3.12; retain the author parsing/extraction behavior and decide the encoding conversion from actual SEC text.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PYTHON_COMPAT
Evidence: E_PYTHON_IMPORT, E_PYTHON_URL_CALL, E_PYTHON_RUNTIME, E_PYTHON_URL_DOC

Preparation / proposed procedure:

1. Choose a supported runtime for DownloadFilings.py; the observed Python 3 runtime uses urllib.request, not the source’s urllib2 import.
2. If porting to Python 3, replace the URL import/call as supported and define how response bytes are decoded before text regexes and text-mode file writes; do not guess an encoding.
3. Keep the original filing selection, exhibit extraction and text cleaning rules.

Validation to perform later:

- On a separately authorized representative filing fixture, confirm URL response decoding, regex behavior, output text and section retention match the intended author preprocessing.

### A_EXHIBIT_LOG_CONFIGURATION: Initialize exhibit_id_errors.txt as an empty per-run log in the same working directory used by DownloadFilings.py and the SAS import, then let the parser append only its multiple-exhibit rows.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_EXHIBIT_LOG_CONTRACT
Evidence: E_EXHIBIT_LOG_PRODUCER, E_EXHIBIT_LOG_CONSUMER

Preparation / proposed procedure:

1. Before each new run, create/truncate a zero-row-compatible exhibit_id_errors.txt at the configured shared run path.
2. Ensure DownloadFilings.py appends to that exact path and Process Prominence Output from Python_v1.6.sas imports the same current-run file.
3. Keep file_read_errors.txt distinct from the exhibit log.

Validation to perform later:

- Confirm the SAS import completes when the log has no rows and that multiple-exhibit rows written by the current run have the required filename, extension, directory and exhibit-count fields.

### A_ORDERED_RUN_PROCEDURE: After all data, field-contract, software and compatibility prerequisites are resolved, follow the supplied producer-consumer order documented in the workflow trace.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_WORKFLOW_TRACE, E_DOC_WORKFLOW, E_CC_PRODUCER, E_CC_PARSER, E_CC_OUTPUT, E_EXTERNALDATA_PRODUCER, E_LCA_CLASS_OUTPUT

Preparation / proposed procedure:

1. Run EA dates -- COMPUSTAT & IBES.sas to produce storage.EADates_1971to2016; run Book to Market -- COMPUSTAT & CRSP.sas to produce storage.book_to_market_1970to2017; run Institutional Ownership -- TFN & CRSP.sas to produce storage.instown_1987to2015.
2. Run Downloading EA Press Releases from 8-Ks.sas to produce promin.sample and filinglist_full.txt/filinglist_1.txt through filinglist_6.txt; then DownloadFilings.py to create Filings/<input-basename>/ filing text and the conditional exhibit log; then CheckEPS.py to produce the six 8-K position files.
3. Run Setup for SA CC Data Parsing in Python.sas with storage.EADates_1971to2016, promin.sample and the nine executive CSVs; it produces SA crosswalk tables, promin.sa_cclinkfile and sa_cclist_full.txt. Run CheckEPS_CC.py against that list and CC PresSplit Management/ transcripts after its schema repair.
4. Run Process Prominence Output from Python_v1.6.sas to combine the 8-K and CC position outputs into promin.sample_promindata.
5. Run Gathering Other Data.sas with the Compustat, CRSP, I/B/E/S, TFN, Bushee and CIQ inputs plus the generated EA-date, book-to-market and ownership tables; it writes WORK.externaldata and promin.externaldata.
6. Only after resolving the distinct promin.externaldata2 producer/schema gap, run LCA Analyses.sas to create promin.lca_classes and Assembling Final Dataset.sas with its separate storage.Proforma_sample branch.

Validation to perform later:

- Before the authorized run, verify each producer output exists at the exact current-run path and has the next consumer’s input columns; compare the cross-language list formats and table keys at every named handoff.

### A_CC_SCHEMA_REPAIR: In a working copy of CheckEPS_CC.py, align the parser indices and output field order with the supplied ten-column, no-header SAS producer and its seven-column SAS consumer.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_CC_SCHEMA
Evidence: E_CC_PRODUCER, E_CC_PARSER, E_CC_OUTPUT, E_WORKFLOW_TRACE

**Proposed edit:** `CheckEPS_CC.py:23–25`
Source SHA-256: `ed09da3df618571fc97a045c2773e2ea472a373d9f591169612ba30ad036b1e0`

Match the ten no-header producer columns: filename_cc is field 1, epsfiq is field 9 and mgr_ng_eps is field 8. Preserve the source variable meanings.

Current text:
```
			filename=row[3]
			filedict['GAAP_EPS']=row[8]
			filedict['NG_EPS']=row[7]
```

Proposed replacement:
```
			filename=row[1]
			filedict['GAAP_EPS']=row[9]
			filedict['NG_EPS']=row[8]
```

**Proposed edit:** `CheckEPS_CC.py:86–86`
Source SHA-256: `ed09da3df618571fc97a045c2773e2ea472a373d9f591169612ba30ad036b1e0`

Create the same cleaned-text length field used by CheckEPS.py after the existing transcript preprocessing.

Current text:
```
				text = __preProcessing(text)
```

Proposed replacement:
```
				text = __preProcessing(text)

				# Capture file length (for output later)
				len_text = len(text)
```

**Proposed edit:** `CheckEPS_CC.py:49–52`
Source SHA-256: `ed09da3df618571fc97a045c2773e2ea472a373d9f591169612ba30ad036b1e0`

Align the output header with the seven fields consumed by the SAS import, inserting fileLength after filename.

Current text:
```
	f.write('filename')
	f.write(dlm)
	f.write('EPS')
	f.write(dlm)
```

Proposed replacement:
```
	f.write('filename')
	f.write(dlm)
	f.write('fileLength')
	f.write(dlm)
	f.write('EPS')
	f.write(dlm)
```

**Proposed edit:** `CheckEPS_CC.py:222–222`
Source SHA-256: `ed09da3df618571fc97a045c2773e2ea472a373d9f591169612ba30ad036b1e0`

Emit fileLength for the no-match row as the SAS consumer expects.

Current text:
```
					stringtowrite=stringtowrite+filename+dlm+str(EPS)+dlm+str(matchid)+dlm+str(charpos)+dlm+str(sentenceid)+dlm+'[_null_]'+'\n'
```

Proposed replacement:
```
					stringtowrite=stringtowrite+filename+dlm+str(len_text)+dlm+str(EPS)+dlm+str(matchid)+dlm+str(charpos)+dlm+str(sentenceid)+dlm+'[_null_]'+'\n'
```

**Proposed edit:** `CheckEPS_CC.py:231–231`
Source SHA-256: `ed09da3df618571fc97a045c2773e2ea472a373d9f591169612ba30ad036b1e0`

Emit fileLength for each match row as the SAS consumer expects.

Current text:
```
						stringtowrite=stringtowrite+filename+dlm+str(EPS)+dlm+str(matchid)+dlm+str(charpos)+dlm+str(sentenceid)+dlm+str(sentence_dict[sentenceid]['text'])+'\n'
```

Proposed replacement:
```
						stringtowrite=stringtowrite+filename+dlm+str(len_text)+dlm+str(EPS)+dlm+str(matchid)+dlm+str(charpos)+dlm+str(sentenceid)+dlm+str(sentence_dict[sentenceid]['text'])+'\n'
```

Preparation / proposed procedure:

1. Use the Setup program’s field order: article_id, filename_cc, date_cc, gvkey, datadate, eadate, filename, date_8k, mgr_ng_eps, epsfiq.
2. Read filename from row[1], GAAP EPS from row[9], and non-GAAP EPS from row[8].
3. After transcript preprocessing, calculate len_text using the cleaned text; add fileLength after filename in the output header and in both no-match and matched output rows.
4. Keep the original EPS matching, cleaning and sentence-position logic unchanged.

Validation to perform later:

- Inspect one generated transcript-list row against the ten source fields and confirm the corrected parser reads filename_cc, epsfiq and mgr_ng_eps.
- Confirm each parser output row and header have the seven fields filename, fileLength, EPS, MatchID, CharacterPosition, SentenceID and SentenceText in the order read by Process Prominence Output from Python_v1.6.sas.
- In a separately authorized future run, confirm SAS imports the CC result with expected fileLength and uses the matched gvkey/datadate keys.


## Remaining issues and prerequisites

- I_SOURCE_PATHS [preparation; full_pipeline]: The supplied programs contain author-machine paths and Startup File includes; the ordered cross-language handoffs, active macros and input roots need a project working-copy setup.
- I_LCA_DEPENDENCIES [unresolved; full_pipeline]: The supplied LCA branch requires PROC LCA plus LCA_Distal_BCH_v110.sas, LCAGraphicsV2.sas and the invoked winsorization macro; their availability and the supported installation/field contract have not been verified. The paper-wide general estimation/tabulation code omitted from the release is contextual and outside this supplied-code target.
- I_CC_SCHEMA [blocking; full_pipeline]: The SAS producer exports ten positional columns without names; CheckEPS_CC.py reads filename, GAAP EPS and non-GAAP EPS from indices 3/8/7, and emits six columns without fileLength although its SAS consumer reads seven fields including fileLength. Correct the indices and output field contract in a working copy before this branch can be used.
- I_EXTERNALDATA2 [blocking; full_pipeline]: Assembling Final Dataset.sas and LCA Analyses.sas consume promin.externaldata2, but the supplied Gathering Other Data.sas creates promin.externaldata. Its required field aliases also remain unproven: LCA keeps ff10, calyear_1 and MEETBEAT while the supplied producer visibly creates FF48, calyear/eayear and does not visibly create MEETBEAT. Do not infer a rename or fill the handoff without a source contract.
- I_EXHIBIT_LOG_CONTRACT [blocking; full_pipeline]: DownloadFilings.py writes exhibit_id_errors.txt only in the multiple-exhibits branch, while Process Prominence Output from Python_v1.6.sas imports the file unconditionally. A clean per-run working directory must ensure a zero-row-compatible log exists before the SAS import; stale logs must not be reused.
- I_PYTHON_COMPAT [unresolved; full_pipeline]: The observed Python 3.12.14 runtime uses urllib.request, while DownloadFilings.py imports urllib2 and relies on byte strings in regex/text-file processing. A compatible Python 2 runtime was not established; if retaining Python 3, the URL import and decoding/text I/O contract need a supported source update.
- I_SAS_RUNTIME [blocking; full_pipeline]: The currently configured SAS executable fails an empty-session launch at TKELS initialization, preventing a run in this environment. This probe does not establish a missing license; the runtime launch configuration/component must be resolved before future execution.
- R_COMP_FUNDQ [undetermined]: Quarterly Compustat fundamentals used in earnings-date, book-to-market and other-data construction.
- R_COMP_FUNDA [undetermined]: Annual Compustat fundamentals joined into the supplied firm-quarter construction.
- R_CRSP_CCM [undetermined]: CRSP/Compustat link-history records used to map gvkey and permno in several supplied branches.
- R_CRSP_MSF [undetermined]: Monthly CRSP price, volume, return and shares-outstanding fields used by book-to-market, ownership and lagged-market calculations.
- R_CRSP_DSF [undetermined]: Daily CRSP returns used for event and next-event return windows.
- R_CRSP_DSI [undetermined]: Daily value-weighted market returns paired with CRSP.DSF event-window dates.
- R_CRSP_STOCKNAMES [undetermined]: CRSP stock-name/CUSIP bridge fields consumed in institutional-ownership preparation.
- R_IBES_ACTUALS [undetermined]: I/B/E/S quarterly actual EPS records used in earnings-date and other-data joins.
- R_IBES_STATSUMU [undetermined]: I/B/E/S unadjusted analyst-summary forecasts used in firm-quarter forecast construction.
- R_IBES_XEPSUS [undetermined]: I/B/E/S adjusted EPS summary data used to construct actual/forecast measures.
- R_CIQ_KEYDEV [undetermined]: Capital IQ key-development event identifiers, announcement dates and gvkey used by the supplied other-data program.
- R_CRSP_COMPHIST [undetermined]: Historic CIK for firm-quarter filings; required report-date history is not verified.
- R_COMP_CO_FILEDATE [undetermined]: Compustat periodic filing date and source type for each firm-quarter; coverage is not verified.
- R_COMP_SNAPSHOT_Q [undetermined]: Quarterly Compustat un-restated/as-first-reported measures; no compatible local file was mapped.
- R_COMP_SNAPSHOT_A [undetermined]: Annual Compustat un-restated measures joined to quarterly firm-years; no compatible local file was mapped.
- R_IBES_IDSUM [undetermined]: I/B/E/S identifier/dilution history required to convert forecast and actual EPS; period and matching are unknown.
- R_ICLINK [undetermined]: Supplied crosswalk from CRSP PERMNO to I/B/E/S TICKER; no producer or verified catalog location is supplied.
- R_TFN_S34 [undetermined]: Thomson-Reuters 13F holdings used for 1987-2015 institutional ownership; the bounded read timed out and coverage remains unknown.
- R_BCGW_NG_INPUT [undetermined]: Bentley et al. 2018 source dataset prom2.bcgw_2018_ng_data_2003to2016 used to create the 8-K candidate sample.
- R_KOOLAID_SAMPLE [undetermined]: The first Bentley-derived koolaid.sample input supplying firm-quarter identifiers, 8-K filename and EPS values to the filing-search branch.
- R_KOOLAID_SAMPLE_2013 [undetermined]: The separate koolaid.sample_2013 dataset concatenated with koolaid.sample by the supplied 8-K candidate program.
- R_EDGAR_FILINGS_INDEX [undetermined]: storage.Edgar_filings_1993to2016 filing metadata index joined on URL/filename to obtain filing dates.
- R_SEC_FILING_TEXT [undetermined]: The complete-submission SEC 8-K text or compatible filing text consumed by DownloadFilings.py and CheckEPS.py, after the source program selects/cleans filing exhibits.
- R_CC_EXECUTIVE_LOOKUPS [undetermined]: The nine executives_1.csv through executives_9.csv lookup files that seed the supplied SeekingAlpha executive/company crosswalk.
- R_CC_TRANSCRIPTS [undetermined]: SeekingAlpha conference-call transcript text in the CC PresSplit Management/ directory, including the files referenced by sa_cclist_full.txt.
- R_BUSHEE_CLASSIFICATION [undetermined]: Bushee manager/year classification text used to classify TFN holdings into QIX, TRA and DED ownership groups.
- R_PROFORMA_SAMPLE [undetermined]: storage.Proforma_sample, the distinct 1998-2003 sample used in the supplied final-assembly branch.
- R_LCA_INPUTS [undetermined]: promin.externaldata2 consumed by both Assembling Final Dataset.sas and LCA Analyses.sas; this input is not produced by the supplied Gathering Other Data.sas.
- S_SAS [unverified]: The supplied programs require SAS; the configured sas_u8 runtime failed twice during TKELS initialization in the bounded empty-session probe, so runtime availability is unverified and no license conclusion is drawn.
- S_SAS_CONNECT [unverified]: The supplied workflow uses RSUBMIT and remote PROC DOWNLOAD; installed SAS/CONNECT availability is unverified.
- S_SAS_ETS [unverified]: The supplied other-data program calls PROC EXPAND; SAS/ETS component availability is unverified.
- S_SAS_STAT [unverified]: The supplied processor calls PROC SURVEYSELECT; SAS/STAT component availability is unverified.
- S_PROC_LCA [unverified]: The supplied independent LCA branch invokes PROC LCA; the licensed/add-on procedure availability was not established by the package or bounded runtime probe.

## Review notes

- Source checkpoint: all 12 supplied SAS/Python programs, datasheet, documentation and appendix were reviewed. Ordered workflow trace is saved at probes/workflow_trace.json. The CC positional schema mismatch and externaldata/externaldata2 plus LCA field-contract gap are supported source findings; general omitted estimation/tabulation code is contextual, outside the selected supplied-code scope. Dependency mapping and remaining requirement routes are being expanded. No author code or study data was executed.
- Section 2: added separate local-route requirements for 11 catalog-listed Compustat, CRSP, I/B/E/S and Capital IQ products. Each successful bounded SAS probe read one row and confirmed only readability and listed columns; it does not establish population or history. TFN.S34 and other unmatched author-specific inputs are addressed separately.
- Section 3: added seven distinct unresolved other-data inputs (CRSP.COMPHIST, COMP.CO_FILEDATE, two Compustat snapshot products, IBES.IDSUM, storage.iclink and TFN.S34) with actual source fields/history and catalog/probe evidence. The catalog miss and TFN timeout remain uncertainties, not absent-data or license findings. The author data page lists two candidate prepared datasets, but this is not closure for the raw SEC/transcript branches or downstream schemas.
- Section 4: added separate 8-K, conference-call, Bushee and Pro Forma inputs. Candidate SEC corpus roots and author/Bentley download page remain unverified for exact population, fields, sections and history; no public route was treated as blocked or as automatic closure. Added the conditional exhibit-log handoff and Python urllib2/bytes compatibility issues. General estimation omission and the appendix-described 75-observation manual check remain contextual to this selected supplied-code target.
- Section 5: software inventory now covers SAS, SAS/CONNECT, SAS/ETS/PROC EXPAND, SAS/STAT/PROC SURVEYSELECT, PROC LCA and Python 3.12.14. SAS runtime startup failed at TKELS without establishing a license issue; required module/add-on availability remains unverified. Unknown CSV/transcript columns are not fabricated.
- Section 6: replaced the two broad placeholder requirements with the separate consumed source products and exact generated intermediates. The produced chain is documented through EADates, book-to-market, ownership, 8-K/CC parsing, other-data output, LCA classes and final assembly; unprovided paper-wide estimators and the appendix manual review remain context only.
- Section 7: all 105 frozen dependency IDs now have exactly one disposition. Source-produced SAS WORK tables, supplied branch outputs and named support tables are classified generated; source products map to distinct requirements; absent Startup File/includes and conditional exhibit log map to specific issues. No checklist edge is treated as proof of data coverage.
- Section 8: added proposal actions for every data input, unresolved software dependency and issue except the separately prepared exact CheckEPS_CC schema edit, which follows in the next section. Action order preserves all supplied preparation branches and makes externaldata2 a specific stop condition before assembly/LCA.
- Section 9: added a frozen-source-hash edit proposal for CheckEPS_CC.py. It corrects the supported CSV column mapping and seven-field output contract without applying changes or altering EPS matching definitions.
