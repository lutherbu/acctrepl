# Patch proposal: jar-ea71fd24aeff

Anticipated Earnings Announcements and the Customer-Supplier Anomaly

DOI: 10.1111/1475-679X.12158

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented SAS-to-Stata workflow with five SAS builders, six independent Stata table companions, and online appendix analyses.

Entry points: `Customer Demand Final.sas`, `QEA Dates Final.sas`, `Pseudo Dates Final.sas`, `Guidance Dates Final.sas`, `Table 6 CF Replication Final.sas`, `Table 2, 7 and S4 Demand.do`, `Table 3-4.do`, `Table 5.do`, `Table 6.do`, `Table 8a Cust QEA Pseudo.do`, `Table 8b Cust QEA guidance.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 3/12158 - Anticipated-Earnings-Announcements-and-the-Customer-Supplier-Anomaly/madsen-datasheet-and-code.zip",
      "sha256": "555e63cae1009c89ca261a61ce63fe8d6d09df9e51d8fb919454475d004cef8b"
    },
    {
      "path": "JAR-Volume 55/Issue 3/12158 - Anticipated-Earnings-Announcements-and-the-Customer-Supplier-Anomaly/madsen-internet-appendix.pdf",
      "sha256": "adae8266e05045631d213c14eaba829065bd0f7152d621831c015dbc917bcbdf"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "d38ab881b8e643f6c591b6ec3a75930f2f79281ef1fc213260afeb8ce3133ce6"
}
```

## Proposed actions

### A_WRDS: Confirm authorized WRDS products, vintages, fields and study-period coverage for the identified candidates, then map compatible inputs to the author filenames.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SEGMENT, R_COMPANIES, R_DSF, R_MSF14, R_MSF15, R_IND48, R_INDEX15, R_FQ14, R_COMPANY, R_FUNDQ, R_CCM, R_IBESACT, R_IBESSUM, R_S34, R_FACTORS
Evidence: E_DOC_INPUTS, E_CATALOG_WRDS, E_PROBE_SEGMENT, E_PROBE_DSF, E_PROBE_MSF, E_PROBE_DSI, E_PROBE_FUNDQ, E_PROBE_COMPANY, E_PROBE_LINK, E_PROBE_IBES_ACT, E_PROBE_IBES_SUM, E_PROBE_TFN, E_PROBE_FF

Preparation / proposed procedure:

1. Verify account products and extraction vintages against every author-named input; one-row probes establish selected columns/readability only.
2. Confirm customer IDs, CRSP company/industry coverage, Compustat quarterly history, CCM links, IBES actuals and summaries, S34, and Table 6 factors including ps_vwf.
3. Prepare only documented field/date mappings where the source is compatible; otherwise obtain the authorized product or author specification.

Validation to perform later:

- Check bounded metadata for required columns, identifiers and dates after access is confirmed.
- Confirm population and historical coverage before starting downstream stages.

### A_AUTHOR_DATA: Obtain the author-prepared daily SVI, EDGAR activity, First Call, prelinked RavenPack, and DIS date inputs or their exact construction/access details.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SVI4, R_SVI5, R_EDGAR1, R_EDGAR2, R_FIRSTCALL, R_RAVEN, R_DATES
Evidence: E_CATALOG_MISS, E_CUST_SVI4_INPUT, E_QEA_EXTRA_SVI, E_CUST_EDGAR_INPUT, E_QEA_EXTRA_EDGAR, E_CUST_FIRSTCALL_INPUT, E_CUST_RAVEN_INPUT, E_CUST_CALENDAR_INPUT

Preparation / proposed procedure:

1. Request exact versions, variable definitions, identifiers, coverage dates, and authorized route for daily_svi4/daily_svi5, downloads_master/downloads_master2, cig, permno_events and DIS.dates.
2. For supplied prepared files, check bounded metadata against direct joins; if only a construction description is available, leave the data route unresolved until required fields/transforms are specified.

Validation to perform later:

- Check required fields and date/identifier joins after files are authorized and available.
- Confirm coverage with providers/authors; do not treat one-row probes as complete history.

### A_MACROS: Obtain the author SAS autocall library and definitions, including EVENT behavior at asterisk-form calls.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I_SAS_MACROS, SW_MACROS
Evidence: E_QEA_AUTO, E_QEA_EVENT_MACRO, E_GUIDANCE_EVENT, E_PSEUDO_EVENT, E_PSEUDO_CUSTOMER_EVENT, E_SAS_MACRO, E_SAS_COMMENT_SEMANTICS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the referenced autocall directory and versions for event, bharlog, crsp_day, SUE, ind_ff48 and Winsorize_Truncate plus required macro variables.
2. Determine actual output datasets from the macro expansion; SAS documentation establishes that macro references are processed but does not establish their expansion.
3. Leave source calls unchanged until definitions and intended outputs are known.

Validation to perform later:

- Perform future authorized macro lookup/trace and verify generated dataset names before full execution.

### A_HANDOFFS: Resolve SAS library assignments and all SAS-to-Stata dataset names before editing, retaining separate analyses and output variants.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_FULLSAMPLE_PATH, I_PSEUDO_PATH, I_DATES, I_DEMAND7, I_QEA3, I_QTRS5
Evidence: E_QEA_WORK_COMPFULL, E_CUST_COMPFULL_INPUT, E_PSEUDO_DATE_WORK, E_CUST_PSEUDO_INPUT, E_CUST_CALENDAR_INPUT, E_DEMAND7_WORK, E_TABLE2_INPUT, E_QEA_COMPJAR3_WORK, E_TABLE34_INPUT, E_QEA_EDGAR_EXPORT, E_QEA_SVI_EXPORT, E_TABLE6_QTR_EDGAR, E_TABLE6_QTR_SVI

Preparation / proposed procedure:

1. Ask whether comp_full_sample, pseudo_dates and dates should be persistent DIS datasets and identify their intended producers/periods.
2. Confirm demand7’s SAS-to-Stata transfer and whether comp_jar3 should feed cust_qea3.dta or a different named file.
3. Confirm qtrs5_2_Edgar/SVI versus qtrs_Edgar/SVI compatibility for Table 6; retain both variants pending clarification.
4. Map confirmed Windows libraries/output paths only after intended names and routes are known.

Validation to perform later:

- Compare producer names, fields, identifiers and dates with every consuming SAS/Stata use.
- Reconcile all six Stata companions with the correct upstream files.

### A_SETUP: Establish SAS runtime and map supplied Windows library, autocall and output paths to accessible directories after input specifications are resolved.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_SAS_PATHS, SW_SAS
Evidence: E_PROBE_ENV, E_QEA_LIB, E_QEA_AUTO, E_TABLE2_INPUT, E_TABLE8A_INPUT

Preparation / proposed procedure:

1. Confirm authorized SAS 9.4 startup and supported autoexec/library configuration; the bounded startup result is unverified.
2. Map required Windows data, autocall, Stata working and output directories without editing package sources.

Validation to perform later:

- Check SAS startup, macro lookup and read/write access to every mapped directory before running author code.

### A_RUN_ORDER: After sources, macros, paths, and handoffs are reconciled, preserve all five SAS builders and six independent Stata companions in producer/consumer order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_CLOSURE
Evidence: E_DOC_WORKFLOW, E_DOC_QEA_MAP, E_DOC_PSEUDO_MAP, E_DOC_GUIDANCE_MAP, E_QEA_WORK_COMPFULL, E_QEA_SORT_EXPORT, E_CF_EXPORT, E_PSEUDO_EXPORT, E_GUIDANCE_EXPORT, E_TABLE2_INPUT, E_TABLE34_INPUT, E_TABLE5_INPUT, E_TABLE6_INPUT, E_TABLE8A_INPUT, E_TABLE8B_INPUT

Preparation / proposed procedure:

1. Run QEA Dates first after resolving its direct inputs/macros because it builds the earnings/event/customer intermediates and quarterly sorts.
2. Run Customer Demand, Guidance Dates, and Pseudo Dates for their separate datasets, plus Table 6 CF Replication Final.sas for its CF and customer-sort exports.
3. Run all six Stata companions separately: Table 2/7/S4 Demand; Table 3-4; Table 5; Table 6; Table 8a pseudo; Table 8b guidance, after confirming each input handoff.
4. Keep QEA qtrs_Edgar/SVI and Table 6 qtrs5_2 variants distinct until author clarification confirms compatibility.

Validation to perform later:

- Record each stage’s consumed/created names and check the next consumer receives compatible fields, identifiers and dates.
- After future authorized execution, compare outputs from all six Stata companions with the paper and S1–S4 appendix.


## Remaining issues and prerequisites

- I_CLOSURE [unresolved; full_pipeline]: Required data routes, macro-generated panels, and several producer/consumer handoffs remain unresolved; direct reads outside the 53-edge checklist were added to the closure.
- I_SAS_MACROS [unresolved; full_pipeline]: Custom autocall macros event, bharlog, crsp_day, SUE, ind_ff48 and Winsorize_Truncate are not supplied. *%event calls remain macro expansion uncertainty because SAS processes macro references in this comment form; do not infer disabled calls or their outputs.
- I_SAS_PATHS [unresolved; full_pipeline]: SAS library/autocall locations and Stata working/output directories use hard-coded Windows paths without a verified runtime mapping.
- I_FULLSAMPLE_PATH [unresolved; full_pipeline]: QEA creates WORK comp_full_sample, while Customer Demand, Guidance, Pseudo, and Table 6 CF read DIS.comp_full_sample; no persistent DIS write is visible.
- I_PSEUDO_PATH [unresolved; full_pipeline]: Pseudo Dates creates WORK pseudo_dates but Customer Demand reads DIS.pseudo_dates; the library handoff is not shown.
- I_DATES [unresolved; full_pipeline]: Customer Demand reads DIS.dates, but no supplied entry identifies the producer, source or coverage.
- I_DEMAND7 [unresolved; full_pipeline]: SAS leaves demand7 as a one-level dataset; the Table 2/7/S4 Stata companion uses demand7. No explicit DTA export/transfer is visible.
- I_QEA3 [unresolved; full_pipeline]: QEA creates WORK comp_jar3 and comments it is for Table 3–4, while Table 3-4.do reads cust_qea3; no such export is shown and DIS.comp_jar3 has no visible write.
- I_QTRS5 [unresolved; full_pipeline]: QEA invokes loop5_5 once, applies Edgar and Google deletion blocks sequentially to the same qtrs2 object, then exports qtrs_Edgar and qtrs_SVI. Table 6 reads qtrs5_2_Edgar/SVI; exact filename/variant/branch compatibility is unknown.
- R_SEGMENT [undetermined]: Author-compatible Segment customer file cust_final.
- R_COMPANIES [undetermined]: CRSP company crosswalk containing PERMNO/PERMCO/CUSIP.
- R_SVI4 [undetermined]: Daily Google SVI panel daily_svi4.
- R_SVI5 [undetermined]: Daily Google SVI panel daily_svi5 used by QEA.
- R_EDGAR1 [undetermined]: EDGAR activity panel downloads_master.
- R_EDGAR2 [undetermined]: EDGAR activity panel downloads_master2 used by QEA.
- R_FIRSTCALL [undetermined]: First Call cig guidance records.
- R_RAVEN [undetermined]: Author-prelinked RavenPack permno_events panel.
- R_DSF [undetermined]: CRSP daily stock file dsf_2015 for pseudo-event construction.
- R_MSF14 [undetermined]: CRSP monthly stock file msf_2014.
- R_MSF15 [undetermined]: CRSP monthly stock file msf_2015.
- R_IND48 [undetermined]: CRSP daily 48-industry return file.
- R_INDEX15 [undetermined]: CRSP market/index returns for Table 6.
- R_FQ14 [undetermined]: Compustat quarterly source fundq_2014.
- R_COMPANY [undetermined]: Compustat company metadata.
- R_FUNDQ [undetermined]: Compustat quarterly fundamentals.
- R_CCM [undetermined]: CRSP/Compustat CCM link table.
- R_IBESACT [undetermined]: IBES actual earnings file.
- R_IBESSUM [undetermined]: IBES analyst summary file.
- R_S34 [undetermined]: Thomson Reuters S34 institutional ownership.
- R_FACTORS [undetermined]: Table 6 monthly factors including ps_vwf.
- R_DATES [undetermined]: Persistent DIS date calendar.
- SW_SAS [unverified]: Bounded startup probe did not establish SAS runtime readiness; no license absence inference.
- SW_MACROS [unverified]: Required macro definitions are outside the supplied package and access to the external autocall directory is not established.

## Review notes

- All five SAS builders and all six Stata companions are retained; Table 5 and Table 6 remain distinct QEA output consumers.
- All 53 frozen dependency IDs were reviewed. Additional direct reads outside the checklist are represented as explicit requirements or issues.
- Catalog candidates and bounded one-row probes establish discovery, selected readability, or columns only; they do not establish licenses, full historical coverage, or author-construction compatibility.
- The asterisk-form *%event calls remain unresolved macro expansion/definition dependencies. Official SAS documentation says macro references in this comment form are processed.
- No analysis_only scope is supported: the packaged workbook is an identifier list, not compatible full analysis data.
- Static assessment only; no author program execution, dataset downloads, software installation, or source patches.
