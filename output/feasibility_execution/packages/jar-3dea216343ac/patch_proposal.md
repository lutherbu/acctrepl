# Patch proposal: jar-3dea216343ac

Leveraging Big Data to Study Information Dissemination of Material Firm Events

DOI: 10.1111/1475-679X.12419

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The one supplied SAS program's complete author-documented workflow through its generated main samples; no analysis-only scope is supported because no compatible prepared sample or Stata analysis driver is supplied.

Entry points: `Big data sas codes - Final.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 2/12419 - Leveraging-Big-Data-to-Study-Information-Dissemination-of-Material-Firm-Events/lv-datasheet-and-code.zip",
      "sha256": "933c184996687bcd2889caa0d215ce6337bcbcd0240af2c0d8a650c1525a43cc"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "163dbf16b753f3fff1edc73ad35138928edd3fd44df690408bc90e8e95bed3ec"
}
```

## Proposed actions

### A_ORBITAL: Clarify an authorized, compatible Orbital data route and obtain the author-documented refinery input plus the manually reviewed crosswalk. Preserve the confidentiality terms and the authors' identifier limits.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_ORBITAL_RAW, R_REFINERY_CROSSWALK, I_ORBITAL_ACCESS, SW_SPREADSHEET
Evidence: E_ORBITAL_NDA, E_DOC_ORBITAL, E_ORBITAL_READ, E_CROSSWALK, E_LIBREOFFICE_VERSION

Preparation / proposed procedure:

1. Confirm permitted replication use and any delivery restrictions with the authors or data provider; the NDA history alone does not establish a barrier for this replication.
2. Obtain the compatible full panel workbook and manually reviewed refinery_orbital_v1.xlsx, including the author-required matching keys and downstream location/identifier columns.
3. Select a spreadsheet application and version compatible with the exported crosswalk; version metadata alone is not a workbook compatibility check.

Validation to perform later:

- After separate authorization, use a bounded metadata/readability check and compare imported columns, join keys and date coverage with Step 1 references; do not infer a full population from a sample.

### A_HANDOFFS: Request the omitted producer files or documented compatible author-prepared tables and their field, date, and join contracts for RR2_IBES, OIL_INDEX, and GASBUDDY_CLEAN.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_RR2_IBES, R_OIL_INDEX, R_GASBUDDY_CLEAN, I_UNPRODUCED_HANDOFFS
Evidence: E_IBES_READ, E_RR2_IBES_READ, E_CATALOG_IBES, E_OIL_INDEX_READ, E_GASBUDDY_GAP, E_GASBUDDY_CLEAN_CONSUMER

Preparation / proposed procedure:

1. Obtain the RR2_IBES preparation route and mapping for OFTIC, PENDS and ANNDATS; cataloged IBES candidates are not yet a verified substitute.
2. Obtain the OIL_INDEX producer and exact definition/history of oil_index, beg_date and end_date.
3. Clarify whether GASBUDDY_CLEAN is a distinct author-prepared table or a missing transformation from the supplied GASBUDDY output; do not treat the two names as equivalent.

Validation to perform later:

- Compare documented producer outputs, source fields, intervals and join keys with every consumer before the handoffs are closed.

### A_SOFTWARE: Establish a working SAS 9.4 client and SAS/CONNECT WRDS session; check local SAS/ETS availability for PROC EXPAND and selected-host support for the authored XLSX import and STATA export, then configure author input/output roots and logs for the host paths.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, I_SAS_WRDS
Evidence: E_SAS_REMOTE, E_ENV, E_MSF_LEADS, E_ENDRSUBMIT, E_ORBITAL_READ, E_STATA_EXPORT_ORBITAL, E_EXPAND_FAMILY

Preparation / proposed procedure:

1. Resolve the existing SAS TKELS startup failure or use an authorized working SAS 9.4 host; do not treat the startup failure as an entitlement or component-availability result.
2. Confirm WRDS credentials, SAS/CONNECT support, exact library access, and a Dropbox root macro mapping the Data and Factiva paths.
3. Check SAS/ETS availability for the local PROC EXPAND stage at lines 675-687, which follows ENDRSUBMIT at line 657; the SAS/CONNECT configuration does not establish support for this local stage.
4. Check selected-host/release support for the authored DBMS=XLSX import at lines 21-24 and DBMS=STATA export at lines 1001-1004, including relevant SAS/ACCESS or format support; host/version compatibility remains unverified.
5. Redirect the user-specific Windows PROC PRINTTO path at line 674 to a writable host log and keep all input, intermediate, SAS and Stata-export destinations consistent.

Validation to perform later:

- In a separately authorized setup step, use software metadata, version/help information, or primary release documentation to check SAS version, SAS/CONNECT, local SAS/ETS/PROC EXPAND availability, and selected-host XLSX/STATA DBMS support; also check library connections and writable configured paths. The SAS/ETS family guide is not an exact SAS 9.4 compatibility certificate.

### A_FINANCIAL_DATA: Verify that the readable local candidate tables or the source code's WRDS route provide the exact authored fields and complete firm/date coverage for the source-generated quarterly, daily and monthly panels.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_COMP_FUNDQ, R_CRSP_DSF, R_CRSP_DSEDELIST, R_FF_FACTORS_DAILY, R_CRSP_MSF, R_CRSP_MSEDELIST, R_FF_FACTORS_MONTHLY, I_SOURCE_COVERAGE
Evidence: E_COMP_REMOTE, E_COMP_LAGS, E_DAILY_BOUNDS, E_CRSP_DSF_READ, E_CRSP_DELIST, E_FF_DAILY, E_MSF_READ, E_MSF_DELIST_FF, E_MSF_LEADS, E_MSF_OUTPUT, E_PROBE_COMP_FUNDQ, E_PROBE_CRSP_DSF, E_PROBE_CRSP_DSEDELIST, E_PROBE_FF_DAILY, E_PROBE_CRSP_MSF, E_PROBE_FF_MONTHLY

Preparation / proposed procedure:

1. Keep COMP.FUNDQ at the authored FYEARQ >= 2012 filter and verify the matched-firm history needed for one-quarter and four-quarter lags.
2. Verify CRSP daily/monthly and delisting tables plus daily/monthly FF factors over the per-PERMNO windows derived as local_date minimum minus 18 calendar months through maximum plus 18 calendar months.
3. For RR2_MSF1, preserve the code's order: source monthly observations, construct lag 1 and leads 1-9, then apply the date >= 2017 filter. Do not extend source bounds to fabricate additional tail observations.
4. Use the WRDS route or an authorized local configuration only after confirming exact table/version and complete time/population coverage; the six one-row probes establish columns/readability only.

Validation to perform later:

- After authorized access, perform bounded metadata/range and source-field checks for each selected table; compare to exact authored filters and all lead/lag/event bounds before running the author stages.

### A_EIA_DATA: Acquire the two official EIA monthly products at the authored PAD District level and prepare the Date/PADD series consumed by Step 5.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_EIA_ACQ_COST, R_EIA_GAS_STOCK
Evidence: E_EIA_ACQ_PAGE, E_EIA_ACQ_DISTRICTS, E_EIA_STOCK_PAGE, E_EIA_STOCK_DISTRICTS, E_EIA_ACQ_CODE, E_EIA_STOCK_CODE

Preparation / proposed procedure:

1. Select and export EIA refiner acquisition cost by PAD District for January 2015 through December 2019; preserve dollars-per-barrel units.
2. Select and export EIA total motor-gasoline stocks by PAD District for January 2015 through December 2019; preserve thousand-barrel units.
3. Prepare the two inputs with Date plus the district series, then follow the author transformations that drop US, transpose to PADD/date, use month-end dates and merge the products.

Validation to perform later:

- Check source series, PAD District labels, units, 2015-2019 monthly coverage and Date/PADD alignment before Step 5; do not substitute other petroleum products or measurements.

### A_MEDIA_DATA: Obtain the combined author Bloomberg/Factiva workbook and enough field/coverage documentation to reproduce the supplied event-window joins.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MEDIA_COMBINED
Evidence: E_DOC_REFO_FACTIVA, E_BBG_MEDIA, E_MEDIA_FIELDS, E_FACTIVA_FIELDS

Preparation / proposed procedure:

1. Obtain the author-named bbg_refo_media_v3.xlsx or a documented compatible author-prepared equivalent with coordinates, Bloomberg start/end/type, and Factiva media date/count fields.
2. Confirm join-key provenance and event-window coverage for all refinery local_date observations in the selected 2017-2019 panel; preserve the authors' product definitions.

Validation to perform later:

- Use bounded workbook metadata and compare imported field names/date coverage to the source columns before running the event merges.

### A_FIRM_CAPACITY: Obtain the separate author firm-capacity workbook and its field/date provenance, since no compatible product or construction route is documented in the package.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FIRM_CAPACITY
Evidence: E_FIRM_CAPACITY_IMPORT, E_CAPACITY_JOIN_ROA, E_CAPACITY_JOIN_RETURN

Preparation / proposed procedure:

1. Request the author-named firm_capacity.xlsx plus the source schema and meanings for Ticker, Date_beg, Date_end, GVKEY/PERMNO, capacity1k and the capacity units.
2. Confirm interval coverage and identifier mappings for both the ROA and monthly return joins; do not infer a substitute from the EIA refinery-capacity product.

Validation to perform later:

- Compare workbook fields and date/identifier coverage with both source joins using a bounded read before Step 5.

### A_GASBUDDY_DATA: Obtain the author's historically collected GasBuddy workbook or a documented permitted full-data route; the cited chart URL is not a verified export route.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_GASBUDDY_RAW
Evidence: E_DOC_EIA_GAS, E_GASBUDDY_PRODUCER

Preparation / proposed procedure:

1. Request the author-collected gasbuddy_combined.xlsx or a permitted compatible author-prepared table with city/date/price and the required 2017-2019 coverage.
2. Do not infer complete coverage from the datasheet's two scrape dates or replace the supplied median/sparse-grid preparation.

Validation to perform later:

- Check only authorized workbook readability, source fields and city/date coverage before using the provided Step 6 producer.

### A_INTERVAL: Resolve Step 10's macro binding before any future run; the later Step 11 month setting does not specify the intended Step 10 interval.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_INTERVAL_STEP10
Evidence: E_INTERVAL_STEP10, E_INTERVAL_LATE_DEF

Preparation / proposed procedure:

1. Ask the authors which interval Step 10 is intended to use and where the macro should be defined before its first use.
2. If the authors specify the value, configure that binding before Step 10 and keep the existing Step 11 month selection unless authors direct otherwise.

Validation to perform later:

- Statically verify the declared macro precedes Step 10 and that both interval-dependent date calculations use the documented value; do not infer month or quarter.

### A_RUN_ORDER: After input, software and contract gaps are resolved, follow the eleven supplied SAS stages in source order; the trace records the producer/consumer chains and all checklist IDs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_UNPRODUCED_HANDOFFS, I_INTERVAL_STEP10, I_SAS_WRDS
Evidence: E_WORKFLOW_TRACE, E_PACKAGE_INVENTORY, E_INTERVAL_STEP10, E_INTERVAL_LATE_DEF, E_GASBUDDY_PRODUCER, E_GASBUDDY_CLEAN_CONSUMER, E_EIA_ACQ_CODE, E_FIRM_CAPACITY_IMPORT, E_MSF_LEADS, E_MSF_OUTPUT

Preparation / proposed procedure:

1. Import Orbital, manually match and return refinery_orbital_v1.xlsx, merge the combined Bloomberg/Factiva workbook, and write REFINERY.orbital_new.
2. Join REFINERY.orbital_new firm keys to COMP.FUNDQ, construct the authored one-quarter/four-quarter lags, and write REFINERY.rr2_fundq.
3. Read CRSP.DSF, CRSP.DSEDELIST and FF.FACTORS_DAILY over the Orbital-derived bounds and write REFINERY.rr2_dsf. Join rr2_fundq, the unresolved RR2_IBES handoff and rr2_dsf, apply the author event-window procedure and oil_index joins, and write rr2_dsf1.
4. Read CRSP.MSF, CRSP.MSEDELIST and FF.FACTORS_MONTHLY over the same derived bound rule and write rr2_msf. Construct mktcap_l1 and ret_f1-ret_f9 in monthly observation order, then filter date >= 2017 and write rr2_msf1.
5. Import the two EIA monthly series, reshape/merge them into oil_acq_cost, then import firm_capacity.xlsx and write firm_capacity.
6. Import gasbuddy_combined.xlsx, form city/date median prices and the sparse grid, and write GASBUDDY; retain this supplied branch even though it does not produce GASBUDDY_CLEAN.
7. Use orbital_new and rr2_dsf to build rr2_orbital and its Stata export.
8. Consume rr2_orbital with the distinct unresolved gasbuddy_clean input, generated oil_acq_cost and unresolved oil_index to create rr2_gas_price_test.
9. Build rr2_roa_test from rr2_orbital, rr2_fundq, firm_capacity, oil_index and generated rr2_dsf1.
10. Build rr2_media_test_month from rr2_orbital, oil_acq_cost and oil_index only after the Step 10 interval value is author-specified; the current source uses it before its later Step 11 assignment.
11. Keep the supplied Step 11 month setting and combine rr2_orbital, oil_acq_cost, firm_capacity, rr2_fundq, rr2_msf1 and oil_index into rr2_return_test_month.

Validation to perform later:

- Before any future author-stage run, confirm each prior producer output and field contract, exact path/cwd mapping, output locations, the two missing-table handoffs, and Step 10's interval; do not skip branches or treat sample identifiers as a complete panel.

### A_SPREADSHEET: Select a spreadsheet tool/version that preserves the exported refinery crosswalk headers and fields during the required manual matching step.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SPREADSHEET
Evidence: E_CROSSWALK, E_LIBREOFFICE_VERSION

Preparation / proposed procedure:

1. Confirm which application is used for the manual refinery/crosswalk editing and whether it preserves names/values when saving refinery_orbital_v1.xlsx.
2. Treat the recorded LibreOffice version as metadata only; no workbook was opened or compatibility tested.

Validation to perform later:

- After obtaining a compatible source workbook, compare headers and keyed rows before importing it back into SAS.


## Remaining issues and prerequisites

- I_ORBITAL_ACCESS [unresolved; full_pipeline]: The datasheet documents Orbital data obtained under an NDA and says sample identifiers are withheld; it does not establish a present compatible dataset route or authorize assuming the agreement bars all permitted replication use. The matching workbook is a separate manual handoff.
- I_UNPRODUCED_HANDOFFS [unresolved; full_pipeline]: RR2_IBES and OIL_INDEX have no supplied producers, and the code writes GASBUDDY but later reads GASBUDDY_CLEAN. These are distinct closure gaps pending author source/contract clarification.
- I_SAS_WRDS [unresolved; full_pipeline]: SAS launch, WRDS credentials/connection, remote libraries and a Dropbox macro/path setup are not verified for this environment. In addition, local SAS/ETS availability for PROC EXPAND after ENDRSUBMIT and selected-host support for the authored DBMS=XLSX import and DBMS=STATA export remain unverified; neither is a finding of absence. The SAS/ETS guide-family title does not establish SAS 9.4 host compatibility. Existing SAS initialization failure is not evidence of missing entitlement; path/root/log configuration remains ordinary preparation.
- I_INTERVAL_STEP10 [unresolved; full_pipeline]: Step 10 uses &interval before the only in-file assignment at Step 11, which selects month and comments out quarter. The intended Step 10 interval cannot be inferred from the later definition.
- I_SOURCE_COVERAGE [unresolved; full_pipeline]: Six bounded one-row probes establish readability and columns for selected Compustat/CRSP/FF tables only. They do not verify the required firm population, quarterly lags, daily event windows, monthly source bounds, or forward-return tails; CRSP.MSEDELIST and author-prepared inputs remain unprobed.
- R_ORBITAL_RAW [undetermined]: The supplied program imports the author-named Orbital refinery workbook and derives the refinery/event panel used by every later stage. The release contains only code and the datasheet, so compatible file presence, columns and coverage are not established.
- R_REFINERY_CROSSWALK [undetermined]: Step 1 exports the unique refinery/name/capacity rows for manual cleaning and then imports refinery_orbital_v1.xlsx to map the raw Orbital workbook. The reviewed workbook and its field contract are not in the release.
- R_RR2_IBES [undetermined]: The earnings-announcement return stage reads REFINERY.rr2_ibes and joins its oftic, pends and anndats fields. No producer for this dataset appears in the supplied program.
- R_OIL_INDEX [undetermined]: Several sample-building stages read REFINERY.oil_index with oil_index, beg_date and end_date; the supplied code does not create this dataset.
- R_GASBUDDY_CLEAN [undetermined]: The gas-price test reads REFINERY.gasbuddy_clean, whereas the supplied import/aggregation stage writes REFINERY.gasbuddy. Their intended relationship and schema are not documented in the supplied sources.
- R_MEDIA_COMBINED [undetermined]: Step 1 imports the combined Bloomberg REFO and Factiva media workbook to create event-date features for the refinery panel. The author-named workbook is not in this release, and its complete historical coverage is unverified.
- R_COMP_FUNDQ [undetermined]: Step 2 reads COMP.FUNDQ, filters FYEARQ >= 2012 and the stated Compustat population, links the matched refinery firms, and uses prior one-quarter and four-quarter records. A local catalog copy is readable for one row, but the required coverage remains unverified.
- R_CRSP_DSF [undetermined]: Step 3A reads CRSP.DSF for matched public refinery PERMNOs. The local table is readable for one row with requested fields, but full PERMNO and date coverage remains unverified.
- R_CRSP_DSEDELIST [undetermined]: Step 3A joins daily CRSP delisting date, code and return values by PERMNO and date. A one-row local copy is readable, but population and history are not established.
- R_FF_FACTORS_DAILY [undetermined]: Step 3A joins daily Fama-French factor fields to the authored daily CRSP panel by date. The local table is readable for one row with requested columns, but complete historical coverage is unknown.
- R_CRSP_MSF [undetermined]: Step 4A reads CRSP.MSF for public refinery PERMNOs, then Step 4B constructs monthly size lags and one-to-nine-observation forward returns before applying the 2017 date filter. Local readability is verified for one row only; tail/history coverage is unknown.
- R_CRSP_MSEDELIST [undetermined]: Step 4A joins monthly CRSP delisting date/code/return fields to MSF by PERMNO and date. This distinct monthly table was not present in the bounded local catalog lookup result and its access/coverage remain unverified.
- R_FF_FACTORS_MONTHLY [undetermined]: Step 4A joins monthly Fama-French factor fields by month to the CRSP.MSF panel. The local table is readable for one row with requested columns, but date coverage is unknown.
- R_EIA_ACQ_COST [public_acquisition_required]: Step 5 imports the EIA crude-refiner acquisition-cost workbook, drops the U.S. column, and reshapes monthly PAD values to PADD/date records. The official series provides monthly domestic, imported and composite acquisition costs by U.S. and PAD Districts, with history predating the authored window.
- R_EIA_GAS_STOCK [public_acquisition_required]: Step 5 separately imports the EIA gasoline-stock workbook and merges its PADD/month values with acquisition costs. The official EIA series identifies motor-gasoline stocks by U.S. and PAD District, monthly, in thousand barrels.
- R_FIRM_CAPACITY [undetermined]: Step 5 imports a separate author-named firm_capacity.xlsx file and writes REFINERY.firm_capacity. Later joins require firm capacity values and start/end dates by GVKEY or PERMNO; the source workbook's field ownership, population and interval coverage are not documented.
- R_GASBUDDY_RAW [undetermined]: Step 6 imports the author-collected combined GasBuddy workbook, reduces prices to city/date medians, and fills a sparse city/date grid to produce REFINERY.gasbuddy. The raw historical coverage is not in this release.
- SW_SAS [unverified]: The supplied program uses SAS and SAS/CONNECT RSUBMIT to WRDS. It also invokes local PROC EXPAND after ENDRSUBMIT and imports/exports using DBMS=XLSX and DBMS=STATA. The environment record reports SAS could not initialize TKELS, which does not establish an absent license or working local/remote execution. Selected-host SAS/ETS availability and XLSX/STATA DBMS or format support remain unverified; no component absence is established. The official 2024.09 guide identifies the SAS/ETS family but does not certify SAS 9.4 host compatibility.
- SW_SPREADSHEET [unverified]: Step 1 exports refinery_orbital.xlsx for manual cleaning and matching; LibreOffice version metadata is present, but crosswalk workbook compatibility or the intended application has not been tested.

## Review notes

- This assessment targets the one supplied SAS preparation program through its generated main samples and Stata exports; no Stata regression driver or prepared analysis panel is present in this package variant, so no analysis-only scope is supported.
- The full 11-stage order and all 33 frozen checklist IDs are source-mapped. Two additional CRSP source reads (DSF and MSF) found in the native code are recorded as requirements even though the checklist omits them.
- Six bounded one-row catalog probes establish readability and selected columns only, not full population or historical coverage. The official EIA monthly acquisition-cost and gasoline-stock products provide a documented public route; author workbook matching, units, time windows and field preparation still require checking.
- The RR2_IBES producer/field mapping, OIL_INDEX definition/history, GASBUDDY versus GASBUDDY_CLEAN relationship, Orbital-compatible route, firm-capacity schema, and Step 10 interval binding remain unresolved. The Step 10 month/quarter choice is not inferred from the later Step 11 month definition.
- No author program, import, compilation, estimator, data transformation, SAS startup or workbook-compatibility trial was run. SAS/ETS PROC EXPAND availability and selected-host DBMS=XLSX/DBMS=STATA support remain unverified; the 2024.09 SAS/ETS guide is family evidence only. execution_verified remains false.
