# Patch proposal: jar-beb9ba902a10

The Firm Next Door: Using Satellite Images to Study Local Information Advantage

DOI: 10.1111/1475-679X.12360

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied initial R data-preparation program and all supplied SAS data-preparation branches and exports. This scope covers the documented supplied workflow, not unprovided paper-wide estimators.

Entry points: `initial_data_collection.R`, `all_final.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 2/12360 - The-Firm-Next-Door-Using-Satellite-Images-to-Study-Local-Information-Advantage/ksw-datasheet-and-code.zip",
      "sha256": "cb0a72acda2534ed3ad1cefcc6dcb542bcf591cab64fcc763ea6b46e9eb443d3"
    },
    {
      "path": "JAR-Volume 59/Issue 2/12360 - The-Firm-Next-Door-Using-Satellite-Images-to-Study-Local-Information-Advantage/ksw-online-appendix.pdf",
      "sha256": "998b32fe167123be48248c70e9ed8e7c16ec3dd7d437f945f4145298772252a9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "6652ca285e56279fa46ae0b14d6a9379247fc6e3200e084d6e9fe1601ec9a7bc"
}
```

## Proposed actions

### A-ORBITAL-EXPORT: Use an authorized export of the documented Orbital Insight USRetailMicro v4.2.1 June 2018 product under the applicable author NDA, resolving its data contract before R preparation. A byte-identical author copy is not required when product, vintage, fields and history are compatible.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-SATELLITE, I-R-DRIVER
Evidence: E-DATASHEET-OI, E-DATASHEET-NDA, E-R-SATELLITE, E-R-SAT-COLUMNS, E-R-DISTANCE-SCHEMA

Preparation / proposed procedure:

1. Confirm an authorized Orbital Insight USRetailMicro v4.2.1 export with the June 2018 observation period is available under permitted NDA terms; a byte-identical author copy is not required when product, vintage, field semantics and history match. Do not replace it with a different imagery, computer-vision or retail-footfall product.
2. Obtain the exact native header/data dictionary, field order, units, observation unit, geography and history for store_id and imaging_timestamp__local_time and positions 3, 4, 7-13.
3. Identify the actual source columns and types for the later state_store, lat_p and lon_p aliases and explain the contamination/store-quarter columns consumed by the code before binding any positional renames.
4. Retain an authorized working copy and document provider access date and export version without redistributing NDA material.

Validation to perform later:

- Before any authorized R run, compare the exact ordered header and types with every positional rename and later selected field; verify unique store/timestamp keys and the time/coverage needed by the observed quarter joins.
- Confirm that coordinate units and state/ZIP codes support the supplied county and distance transformations; do not infer missing aliases.

### A-R-FINANCIAL-PREPARED: Stage the distinct author-prepared quarterly, daily-return, Eventus, analyst, store-contamination and sales-change inputs, or prepare field-compatible local products where the existing catalog and bounded samples support candidates.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-COMP-QUARTERLY, R-CRSP-RETURNS, R-EVENTUS-CARS, R-EVENTUS-EA-CARS, R-IBES-FORECASTS, R-CONTAMINATION, R-SALES-CHANGE
Evidence: E-R-COMP-QUARTER, E-R-QUARTER-MAP, E-R-RETURN-HISTORY, E-R-EVENTUS, E-R-IBES, E-R-SALES-CHANGE, E-PROBE-COMP-FUNDQ, E-PROBE-COMP-COMPANY, E-PROBE-CRSP-DSF, E-PROBE-CRSP-CCM, E-PROBE-IBES-DET

Preparation / proposed procedure:

1. Prefer the author's prepared 4.R CSVs when available; otherwise assess the local COMP.FUNDQ/COMP.COMPANY, CRSP.DSF with CCM link history, and IBES.DET_EPSUS products as common starting resources, preserving author-specific firm-quarter, ticker, period and duplicate rules.
2. Obtain the two Eventus outputs separately (event-window car_1/car_2 and earnings-announcement car_ea/car_ea_2); keep them distinct from SAS profit.car3, which has a different four-factor car/cr construction.
3. Resolve the prepared ret_2.csv positions to ticker/date/return and retain the exact strict RDQ-minus-365-to-RDQ window with more than 60 nonmissing returns; a raw CRSP product needs an explicit compatible identifier/date mapping.
4. Obtain the exact analyst file and check EPS/FPI, analyst, forecast-period, forecast-date and actual-announcement fields used to retain each analyst's latest pre-announcement forecast.
5. Obtain the store_id contamination lookup and quarterly gvkey/datacqtr/saleq sales_change file or prepare compatible products from local Compustat after identifying the author's quarter and lag transformations.

Validation to perform later:

- Check identifiers, units, fiscal/calendar-quarter mappings, merge keys and required historical periods against the R joins before any authorized execution.
- For sampled local candidates, verify only the source columns and bounded readability already observed; obtain and validate full history and selection coverage later without treating one-row probes as population evidence.
- Keep missing price_q_lag and sue_mean_ibes producer definitions unresolved until their exact source/transform is documented.

### A-R-HOLDINGS-AND-LOCATIONS: Preserve the two 13F holdings sources, identifier crosswalk, quarterly SIC history and historical 10-K location table as separate required inputs, checking compatible content and periods before constructing the R joins.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-13F-THOMSON, R-13F-WRDS-SEC, R-PERMNO-GVKEY, R-SIC-HISTORY, R-HISTORICAL-LOCATIONS
Evidence: E-DATASHEET-13F-IBES-BUSHEE, E-DATASHEET-SEC-LOCATIONS, E-R-13F-PROVIDER-FIELDS, E-R-13F-APPEND, E-R-PERMNO-GVKEY, E-R-HIST-LOCATION-READS, E-R-HIST-LOCATION-YEAR, E-PROBE-TFN-S34, E-PROBE-CRSP-CCM, E-PROBE-COMP-COMPANY, E-CATALOG-LOCAL-CANDIDATES

Preparation / proposed procedure:

1. Stage the prepared Thomson 13F and WRDS SEC Analytics 13F files as distinct products and retain each provider's report-date, manager/security, CIK, price/share, ownership and investment fields before the supplied normalization and row-bind.
2. Use the cataloged local TFN.S34 only as a Thomson product candidate; its bounded read timed out, and no full compatible holdings history or author-specific CIK/address/qrank/pricing construction is established.
3. Treat the local SEC raw/parsed corpus as a separate 13F filing reconstruction candidate only after inspecting actual filing contents, CIK/report-period coverage and required identifier mappings; the general WRDSSEC exhibit index is not itself a 13F holdings table.
4. For PERMNO/GVKEY mapping, retain the author crosswalk as primary and assess local CCMXPF_LINKTABLE effective-date fields with COMP.COMPANY as candidate inputs; preserve the link-date/duplicate resolution needed by the author merges.
5. For historical 10-K locations, prefer a compatible prepared historical_locations.csv; its author-described Perl extraction can be bypassed if that exact dated file is supplied. Otherwise assess actual local 10-K filing content, CIK/date and address parsing inputs; current COMPANY addresses or LM10-X alone do not establish full dated 10-K, 13F or Form 497 coverage.
6. Retain the quarter-level author sic.csv requirement; the sampled current COMPANY SIC field is not a substitute for gvkey/fyearq/fqtr SIC history.

Validation to perform later:

- Verify each provider's row unit, CIK/CUSIP/PERMNO/manager mappings, report dates, quarter ranks, share/price fields, historical coverage and duplicate policy before appending the two 13F sources.
- Confirm the historical-location file has dated gvkey/bus_zip rows covering the filing-year joins; a current-address table or corpus directory listing alone is insufficient.
- Keep the author-described Perl parser and any SEC file selection logic as unresolved preparation unless compatible prepared location rows and their required history are documented.

### A-R-GEOGRAPHY: Prepare the exact county/MSA/super-county and missing-county inputs and resolve the R zipcode/helper and coordinate contracts required by its distance-based store/investor joins.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-ZIP-COUNTY-CROSSWALK, R-MSA-CROSSWALK, R-SUPER-COUNTY-CROSSWALK, R-INVESTOR-COUNTY-CORRECTIONS, R-STORE-COUNTY-CORRECTIONS, I-R-DRIVER
Evidence: E-R-COUNTY-CROSSWALKS, E-R-COUNTY-MISSING-MAPS, E-R-STORE-COUNTY-MAP, E-R-DISTANCE-SCHEMA, E-R-DISTANCE-BINS, E-R-UNPRODUCED-KSW, E-R-SAT-COLUMNS

Preparation / proposed procedure:

1. Stage ZIP_COUNTY_032019.csv, msa.csv, super_county.csv, county_inv_missing.csv and county_store_missing.csv in the project-relative 4.R location expected by the source, preserving the specified ZIP/county/MSA fields and mapping vintages.
2. Document the package/provider for data(zipcode) and clean.zipcodes, and identify the missing ksw producer or exact prepared object; do not invent a ZIP table or replacement helper.
3. Map the Orbital provider's actual state, latitude and longitude columns into state_store, lat_p and lon_p as supported by its native schema, then retain the source's county fallback and coordinate-distance construction.
4. Preserve separate investor/store county corrections and the generated investor_county.csv and store_county.csv outputs.

Validation to perform later:

- Check ZIP/county codes, residential-ratio selection, numeric county-to-MSA conversion, correction keys and mapping vintages against the source merges.
- Verify coordinate units and resulting geodesic distance/bin fields with bounded data inspection before any later authorized run; do not assume county outputs are the Local_info_state/county/100_160 SAS tables.

### A-R-DRIVER-SETUP: Prepare the R project root, documented package environment and missing helper/object contracts while preserving the supplied analysis transformations.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-R-PACKAGES, I-R-DRIVER
Evidence: E-R-DRIVER-ROOT, E-R-UNDEFINED-OBJECTS, E-R-UNPRODUCED-KSW, E-R-MISSING-DERIVED-FIELDS, E-R-SUE-UNDEFINED, E-R-WINSOR2-HELPER, E-ENV-SOFTWARE

Preparation / proposed procedure:

1. Map the authored Windows Dropbox root and the case-variant historical_locations.csv roots to one consistent project configuration, checking every producer and consumer path rather than changing only the first read.
2. Document and verify the required data.table, dplyr, sqldf, stringr, lubridate and geosphere package/function entry points in the authorized R environment; identify the provider of data(zipcode) and clean.zipcodes.
3. Obtain exact producer definitions for f13_1, ksw, price_q_lag and sue_mean_ibes and the state_store/lat_p/lon_p source aliases before editing; do not guess formulas or derive them from similarly named columns.
4. Keep the supplied inline winsor2(data, vars, groups, pct) helper and its calls; it is separate from the missing SAS macro. The inv_class.csv object is read but unused later in this R source, so it can be omitted from a prepared working copy if unavailable without dropping any active input.

Validation to perform later:

- Check R package namespace/function availability and helper/object definitions in a separately authorized setup; do not run the author R program as part of this assessment.
- Before any future run, statically confirm all project paths and required in-memory objects are assigned before use and that the inline winsor2 definition remains intact.

### A-SAS-BASE-AND-HANDOFF: Stage the exact positional SAS base CSV, Bushee classifications and post_pano indicator, and map the supported R-to-SAS handoff as a separate table conversion rather than treating same-topic or similarly named files as identical.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-SAS-INVFIRM-BASE, R-BUSHEE-CLASSIFICATIONS, R-POST-PANO, I-R-SAS-HANDOFF, I-SAS-UNDEFINED-FIELDS
Evidence: E-SAS-INPUT, E-SAS-HANDOFF, E-R-OUTPUT, E-R-LOCAL-50KM-FIELDS, E-SAS-UNPRODUCED-3G, E-WORKFLOW-TRACE, E-DATASHEET-13F-IBES-BUSHEE

Preparation / proposed procedure:

1. First stage the exact [redacted-path-2ec9c702435c] expected by SAS line 11, preserving the complete positional INPUT order; it remains a separate prepared input because supplied R writes 4.R/inv_firm_agg_14july.csv.
2. Run the R preparation workflow before the later SAS branch only after its inputs and schema are resolved; treat R inv_firm_agg_14july.csv -> SAS Local_50k_nostate as a distinct documented handoff requiring an explicit supported import/format conversion and matching gvkey/cik/qrank keys.
3. Obtain Bushee manager/year/type classifications and the external post_pano indicator table; check the SAS join key yearmake and the declared base fields before merging.
4. Preserve the SAS internal order: base panel -> Bushee/post_pano merges -> TASS/manual match -> subscriber branches -> local-information/return branches -> exports.

Validation to perform later:

- Compare the 12july input field order and types with every declared SAS informat/input field; do not substitute the 14july R CSV without an explicit supported schema mapping.
- Check the 14july R output, SAS imported Local_50k_nostate table and joining keys/fields after format conversion; verify any source working-directory change across all reads and writes.
- Keep yearmake/gvkey1/cik1 producer definitions unresolved until the exact prepared inputs or setup supply them.

### A-SAS-TASS-MANUAL-MATCH: Identify compatible TASS company and service-provider files, manager-name history and the author-curated brokerfunds manual crosswalk used by the subscriber classification branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-TASS-COMPANYDETAILS, R-TASS-SERVICEPROVIDER, R-SAS-MGRNAME, R-BROKERFUND-MATCH, I-MANUAL-MATCH
Evidence: E-SAS-TASS-INPUTS, E-SAS-TASS-MATCH, E-SAS-MANUAL-MATCH, E-SAS-MATCH-CONSUMER, E-PROBE-TASS-COMPANY, E-PROBE-TASS-SERVICE, E-SAS-MANUAL

Preparation / proposed procedure:

1. Map SAS librefs cd, sp and sub to the exact author TASS companydetails and serviceprovider datasets and manager-name table; resolve the documented `cd.cd`/cataloged companydetails.sas7bdat member difference.
2. Confirm service-provider ProductReference, CompanyName and CompanyID joins and supply the datadate field/date meaning used as provider-start information; the sampled local TASS service-provider product lacks this field, so retain the gap until a compatible source is identified.
3. Obtain the prepared mgrname history and brokerfunds matched.xlsx Sheet1$ workbook with its manual name-to-manager decision rules; preserve the author's `unsure` handling and deduplication keys rather than auto-matching names.
4. Continue the authored sequence: company type filter -> ProductReference provider join -> prime-broker cleaning -> manager list -> manual workbook -> manager/prior-subscriber indicators.

Validation to perform later:

- Check TASS identifier types, ProductReference cardinality, service-provider datadate coverage and manager-name history before joins; a company-detail sample does not verify the service-provider date contract.
- Inspect the manual workbook fields and manager-ID coverage before any SAS import; confirm the required Excel engine only after the SAS runtime is verified.

### A-SAS-SUBSCRIBER-INPUTS: Stage the named subscriber-branch retailer-count, lagged holdings, super-county, four-factor Eventus, social-capital, newspaper and poor-signal summary inputs while resolving the actual library roots and missing 3g producer.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-SAS-CO-LIST, R-SAS-LAG-INVESTMENT-CHANGES, R-SAS-STATE-SUPER-COUNTY, R-SAS-EVENTUS-CAR3, R-SOCIAL-CAPITAL, R-NEWSPAPER-CLOSURES, R-POOR-SIGNAL-SUMMARY, I-SAS-UNPRODUCED-STAGES, I-SAS-ROOTS
Evidence: E-SAS-UNPRODUCED-3G, E-SAS-STATE-SUPER-COUNTY, E-SAS-CAR3-QUARTERS, E-DATASHEET-NEWS-TASS-SOCIAL, E-SAS-NEWS-INPUT, E-SAS-POOR-SIGNAL-INPUT, E-SAS-UNASSIGNED-LIBS, E-DATASHEET-ADV-497

Preparation / proposed procedure:

1. Supply raw1.co_list3 with retailer gvkey1/qrank and n_store fields, sub.lag_chg_inv with gvkey/cik/qrank investment-change measures, and cs.State_super_cty with the state/super-county car-change fields; no supplied program creates these tables.
2. Supply the distinct SAS profit.car3 four-factor Eventus table with car/cr and gvkey/qrank history. The subscriber return branch uses t-1 and t, forward-return branches use t+1, and the store poor-signal branch uses car3 at t through t-3; its separate store car-change inputs extend from t-1 through t-4. Do not substitute either R Eventus CSV.
3. Stage the social-capital input used by the SAS state/year aggregation and identify its exact needed years; the datasheet names Northeast Regional Center for Rural Development data for 2009/2014 but the SAS table's full period is not established.
4. Supply the Han Stice newspaper closure/wage-drop dataset accessed through news, plus the out_cik8_jk1 poor-signal summary with its exact match/count construction; neither producer is included.
5. Resolve raw1/news library assignments and the upstream source or prepared table for sub.Inv_firm_agg3g before its line-591 self-read; do not classify that self-read as a generated table.

Validation to perform later:

- Check each table's observation unit, identifier types, qrank/date coverage, lags/leads, duplicate policy and join cardinality against the actual SAS clauses.
- Confirm the `car`/`cr` product and history independently from R event/announcement CARs; verify social-capital and newspaper rows match state/year or gvkey/cik/qrank keys.
- Inspect any SEC performance-fee or Form 497 content only as an exact candidate after verifying real filing content, CIK/manager identifiers and periods; neither datasheet mentions nor LM10-X directory presence establishes the required max_max_performance_fee input.

### A-SAS-LOCAL-INFORMATION: Resolve the SAS local-information tables, source/format conversions and first investor-store local50 input without inferring that similarly named R exports or the later store-outcome AWS list satisfy them.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-LOCAL-INFO-STATE, R-LOCAL-INFO-COUNTY, R-LOCAL-INFO-100-160, R-LOCAL50-INVESTOR-STORE, I-R-SAS-HANDOFF, I-SAS-ROOTS
Evidence: E-SAS-LOCAL-HANDOFFS, E-SAS-UNPRODUCED-LOCAL-TABLES, E-R-LOCAL-SUMMARY-FIELDS, E-R-LOCAL-50KM-FIELDS, E-R-LOC-INFOR-FIELDS, E-SAS-LOCAL50-INVESTOR, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Obtain the exact Local_info_state.csv, county.csv and Local_info_100_160.csv rows and define their desk libref, identifier columns, distances and time coverage; R writes investor_county.csv/store_county.csv but does not write those three named tables.
2. For Local_infor_store, retain the documented R loc_infor.csv producer and provide the author conversion mapping, but resolve the absent local_infor_car_wd_inv_50k field explicitly; the supplied R output has same-state and 50/100/160 km car-change sum fields, not this named distance-weighted investor field.
3. Obtain the first branch's investor-store local50 list with its actual store/investor/quarter/local_50k contract; the R source has no writer for it.
4. Keep the later AWS store-outcome local50 list as a separate requirement and branch with store_id/qrank aggregation semantics.

Validation to perform later:

- Check the exact table member and format after conversion, each required source field, join keys and quarters before SAS consumes it.
- Confirm county, state, 100 km and 160 km inputs' source construction and distinguish generated R county outputs from SAS desk inputs; do not invent table mappings.

### A-SAS-STORE-OUTCOMES: Resolve the store-level outcome panel and distinct AWS local-store inputs, then clarify the self-read between the in-scope poor-signal output and local-store branch before preparing store exports.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-KSWCAR13-STORE-PANEL, R-LOCAL50-STORE-AWS, R-LOCAL-STORE-OTHER-50K, R-CAR-CHANGE-FIRM-AWS, I-SAS-UNPRODUCED-STAGES, I-SAS-UNDEFINED-FIELDS
Evidence: E-SAS-STORE-INPUT, E-SAS-FORWARD-RETURN, E-SAS-POOR-SIGNAL-LAGS, E-SAS-POOR-SIGNAL-COUNT, E-SAS-LOCAL50-AWS, E-SAS-AWS-NEARBY, E-SAS-KSWCAR-SELFREAD, E-SAS-MAX-FEE, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Obtain the prepared ow.Kswcar13 store-quarter panel with the fields actually read by SAS; R computes some in-memory store/firm measures but does not write this table.
2. Supply the separate AWS store_id/qrank local50 investor-flag file, the Local_store_other_50k nearby-store car-count file and the car_chg_firm gvkey1/qrank average-change file; the first investor-store local50 input does not replace these products.
3. Resolve the source and intended construction of ow.Kswcar13q_local before the SAS self-read at line 1031; do not substitute ow.Kswcar13q without an author-supported mapping.
4. Clarify the source of max_max_performance_fee and the import/rename mismatch between car_q_tod_chg_n1 and later car_q_tod_chg1_n; preserve the authored performance-fee/poor-signal definitions until source fields are identified.
5. Retain the SAS sequence: store panel -> numeric conversions -> car3 t+1 forward return and t/t-1..t-3 return joins -> separate t-1..t-4 store car-change joins -> four-quarter mismatch count -> second local50 store aggregation -> nearby-store and firm car-change joins -> local-only export; then firm-level outcome construction/export.

Validation to perform later:

- Check store_id/qrank and gvkey1/qrank keys, the four-prior-quarter counts, output columns and merge coverage before any later authorized run.
- Verify the exact row unit/history of each AWS input and confirm the generated local502/local501 tables are derived from the second store-level local50 list only.
- Confirm the final SAS DTA exports are preparation outputs; no Stata analysis source is supplied in this package.

### A-SAS-WINSOR-MACRO: Obtain or document the exact SAS winsorize.sas macro body and %winsor call contract; retain the supplied R inline winsor2 implementation as a separate helper.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-WINSOR-HELPER
Evidence: E-SAS-WINSOR, E-R-WINSOR2-HELPER, E-SAS-WINSOR-EXPORT

Preparation / proposed procedure:

1. Identify the exact winsorize.sas file included by all_final.sas and the variables, BY groups, percentile limits and output behavior used by its %winsor invocation.
2. Supply that macro at a configured include path or document the existing authorized macro path; do not replace its behavior with the R winsor2 function or invent SAS macro syntax/settings.
3. Keep the SAS export after the macro stage and maintain the active subscriber data branch.

Validation to perform later:

- After separate authorization and runtime setup, statically verify the included macro path and invocation contract before any data execution.
- Check that the macro's documented variables and group keys match the SAS table and preserve the author's percentile/sample behavior.

### A-SAS-ROOTS-AND-SOFTWARE: Map the supplied SAS placeholder/Windows roots to a coherent project configuration and separately verify the installed SAS runtime and required Excel/Stata import/export engines before a later authorized attempt.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I-SAS-ROOTS, SW-SAS-94, SW-SAS-IMPORT-EXPORT-ENGINES
Evidence: E-SAS-ROOTS, E-SAS-UNASSIGNED-LIBS, E-SAS-MANUAL, E-SAS-STATA-EXPORTS, E-ENV-SOFTWARE

Preparation / proposed procedure:

1. Choose consistent local roots for the Cross Section, Subscriber, TASS service-provider/companydetails, Profit, Overweight, input CSV, and output directories; explicitly assign raw1, news and desk from supported locations.
2. Keep the absolute post_pano path and initial 12july CSV as separate inputs until each source is mapped; verify all output paths and every later read after changing the project root.
3. Verify SAS 9.4 TS1M8 startup in its authorized environment and the PROC IMPORT DBMS=EXCEL and PROC EXPORT DBMS=STATA engine capabilities; the existing TKELS initialization failure does not establish a missing license or installation.
4. Retain SAS Base DATA/PROC SQL/PROC SORT/PROC IMPORT/PROC EXPORT and ZIPSTATE usage without inferring SAS/STAT from these procedures. Stata is an output format only because no Stata source program is supplied.

Validation to perform later:

- Before execution, check librefs, file existence, Excel/Stata engine availability, include paths and write destinations across all SAS branches; do not start SAS or install software during this assessment.
- Confirm future execution uses the authorized analysis data and does not execute this assessment's static or metadata helper code as an author program.


## Remaining issues and prerequisites

- I-R-DRIVER [unresolved; full_pipeline]: The supplied R program contains substantive preparation code, including an inline winsor2 helper, but has no package loading and only incomplete project setup (it sets a Windows working directory). The provider header and later state_store/lat_p/lon_p aliases are unresolved; zipcode/clean.zipcodes setup is absent, and f13_1, ksw, price_q_lag and sue_mean_ibes are consumed without producers in the supplied R file. The datasheet describes Perl parsing for historical 10-K locations, while the R program consumes a prepared historical_locations.csv; its compatible table/history remains unverified.
- I-R-SAS-HANDOFF [unresolved; full_pipeline]: The R export 4.R/inv_firm_agg_14july.csv and the first SAS input [redacted-path-2ec9c702435c] are distinct files, paths and dates. A later SAS comment names the R 14july output for Local_50k_nostate, but no import/conversion or exact field mapping is supplied. R loc_infor.csv does not produce the SAS-required local_infor_car_wd_inv_50k; SAS comments also name Local_info_state, Local_info_county and Local_info_100_160 files with no supplied R writers.
- I-SAS-ROOTS [unresolved; full_pipeline]: The SAS source retains placeholder roots and an absolute Windows path. It reads raw1.co_list3, news.Inv_firm_agg3g and desk local-information tables through library references that are not assigned in the supplied program. The path/library configuration and the source files behind those references remain unresolved.
- I-WINSOR-HELPER [unresolved; full_pipeline]: The supplied R file defines and applies its inline winsor2 helper. Separately, SAS includes winsorize.sas and invokes %winsor, but that SAS macro body is not supplied and its exact behavior/settings are unresolved.
- I-MANUAL-MATCH [unresolved; full_pipeline]: The SAS workflow imports the manually matched brokerfunds matched.xlsx workbook to map manager IDs to TASS prime-broker records. The workbook and matching instructions are absent, so the manual crosswalk and identifier coverage remain unresolved.
- I-SAS-UNPRODUCED-STAGES [unresolved; full_pipeline]: SAS self-reads sub.Inv_firm_agg3g before any supplied producer, and creates ow.Kswcar13q_local from a table of the same name without an earlier producer. SAS also consumes out_cik8_jk1, the store panel ow.Kswcar13, and AWS local-store/car-change inputs that have no producer in the supplied R/SAS sources. Keep the investor-store and store-outcome local50 inputs distinct.
- I-SAS-UNDEFINED-FIELDS [unresolved; full_pipeline]: The SAS source uses gvkey1, cik1, yearmake, year_temp and inv_p without a supplied producer in the reviewed input/setup; its initial positional CSV declares gvkey and cik. The store branch imports car_q_tod_chg_n1 but later references car_q_tod_chg1_n. max_max_performance_fee is also used without a source table or producer, and the datasheet's SEC ADV lead does not identify compatible source rows, identifiers or periods.
- R-SATELLITE [undetermined]: The R program reads Orbital Insight USRetailMicro v4.2.1 store-level car counts as car_store.csv. It deduplicates by store_id and imaging_timestamp__local_time, renames positions 3, 4 and 7-13, and later consumes store/ticker/time, contamination, car-count, ZIP, location and store-quarter aliases. The full provider header, positional contract, population/history, and the source columns for state_store/lat_p/lon_p aliases are not supplied.
- R-COMP-QUARTERLY [undetermined]: Author-prepared Compustat quarterly table used to assign each provider store month to a retailer reporting quarter, merge firm fundamentals and construct lags/controls. The complete fields, firm universe, output history and construction are not in the package.
- R-CRSP-RETURNS [undetermined]: Prepared daily stock-return file used to compute each Compustat observation's return volatility over the year preceding RDQ. The code requires more than 60 nonmissing daily returns in the strict 365-day pre-RDQ window.
- R-EVENTUS-CARS [undetermined]: Prepared Eventus event-window return output merged into the R firm-quarter panel by CUSIP and RDQ; the code requires car_1 and car_2, while the event window/factor construction and covered period are not included.
- R-EVENTUS-EA-CARS [undetermined]: Separate prepared Eventus earnings-announcement return output merged into the R panel by CUSIP and RDQ; this is a distinct file and uses car_ea and car_ea_2, not the event-window fields above.
- R-IBES-FORECASTS [undetermined]: Prepared IBES detail analyst forecast file used to count analysts and calculate dispersion across each analyst's most recent EPS forecast before the actual announcement date. Exact fiscal-period mapping and full time coverage are not stated.
- R-CONTAMINATION [undetermined]: Author-prepared store contamination lookup joined to the R panel by store_id; its source/aggregation logic is not in the supplied programs even though the provider export is filtered on contamination earlier.
- R-13F-THOMSON [undetermined]: Thomson 13F prepared holdings rows are required and row-bound with a second, distinct WRDS SEC 13F input. The code needs processed manager/security, CIK, price/share, address, quarterly rank, ownership and investment fields; their preparation and date/identifier rules are unprovided.
- R-13F-WRDS-SEC [undetermined]: A distinct WRDS SEC Analytics 13F holdings input is required alongside Thomson holdings before the R code harmonizes and appends both sources. The complete input field construction, CIK/address mapping and quarter history are unknown.
- R-PERMNO-GVKEY [undetermined]: Author-prepared PERMNO-to-Compustat/CIK/company/ZIP/SIC crosswalk required to link holdings to firms and investor/firms' locations. Code keeps one row per PERMNO without an explicit period selection, so crosswalk effective dates and duplicate resolution remain important.
- R-SIC-HISTORY [undetermined]: Prepared quarter-level SIC classification used to identify retail firms among holdings. It is keyed by gvkey/fyearq/fqtr; current company SIC does not establish the required quarterly history.
- R-HISTORICAL-LOCATIONS [undetermined]: Historical firm ZIP/address table parsed from SEC 10-K filings; the R code reads it twice, once for a firm ZIP and once for holdings-year headquarters ZIP. It requires dated gvkey-level history rather than only current headquarters data.
- R-ZIP-COUNTY-CROSSWALK [undetermined]: Prepared ZIP-to-county crosswalk used to select a county by residential ratio and assign investor/store counties.
- R-MSA-CROSSWALK [undetermined]: Prepared county-to-MSA mapping used after county assignment for investors and stores.
- R-SUPER-COUNTY-CROSSWALK [undetermined]: Author-prepared ZIP-to-super-county mapping required for investor/store geographic grouping and downstream location calculations.
- R-INVESTOR-COUNTY-CORRECTIONS [undetermined]: Author-supplied investor ZIP missing-county correction table used to fill investor county assignments.
- R-STORE-COUNTY-CORRECTIONS [undetermined]: Author-supplied store missing-county correction table used to fill store county assignments.
- R-SALES-CHANGE [undetermined]: Prepared Compustat sales series used to derive one-quarter and four-quarter sales changes, including a shifted one-quarter lag; no producer for this CSV appears in the supplied R/SAS programs.
- R-SAS-INVFIRM-BASE [undetermined]: Positional investor-firm-quarter CSV imported at the start of all_final.sas. Its filename differs from the R 14july output; the declared INPUT list fixes a broad column order and the exact file/header/history are not supplied.
- R-BUSHEE-CLASSIFICATIONS [undetermined]: Bushee institutional-investor classification table used to append type1/type2 by manager and year; the code sorts by mgrno/year but joins with yearmake, whose producer is unresolved.
- R-POST-PANO [undetermined]: Pano-paper indicator table merged into the base investor-firm panel and carried forward to output. The source is an external prepared file not present in the package.
- R-TASS-COMPANYDETAILS [undetermined]: TASS company-detail table used to select management companies and join ProductReference/CompanyID/CompanyName with service-provider records.
- R-TASS-SERVICEPROVIDER [undetermined]: TASS service-provider table supplies the prime-broker name/ID and datadate joined to companydetails by ProductReference. The local cataloged table does not contain datadate, so its sampled product is not a complete match for the author input contract.
- R-SAS-MGRNAME [undetermined]: Prepared manager-name/report-date/type-code table joined to the manager numbers in the investor panel. The SAS source reads it but does not create it from the two R CSV inputs.
- R-BROKERFUND-MATCH [undetermined]: Manual broker-fund/manager name match imported from an Excel workbook to map institutional manager IDs to TASS prime-broker subscribers. The workbook and match instructions are absent.
- R-SAS-CO-LIST [undetermined]: Retailer-quarter store-count table used to add n_store to the subscriber panel; no producer for raw1.co_list3 appears in the supplied programs and raw1 has no LIBNAME.
- R-SAS-LAG-INVESTMENT-CHANGES [undetermined]: Prepared lagged investment-change table joined on gvkey/cik/qrank to create q1/q2 monitoring variables.
- R-SAS-STATE-SUPER-COUNTY [undetermined]: State/super-county car-change measures joined to the investor-firm-quarter panel for robustness controls; no supplied R/SAS program produces this table.
- R-SAS-EVENTUS-CAR3 [undetermined]: Distinct SAS Eventus 4-factor abnormal-return table with car and cumulative return cr. The subscriber branch uses t-1/t, forward-return branches use t+1, and the store poor-signal return lags use t through t-3. Separate store car-change lags reach t-4. This is not either R Eventus CSV, whose fields are event CARs and earnings-announcement CARs.
- R-SOCIAL-CAPITAL [undetermined]: Annual county ZIP social-capital data aggregated by state/fyear and joined to investor-year fields. Datasheet identifies Northeast Regional Center for Rural Development data for 2009 and 2014; broader period coverage is not established.
- R-NEWSPAPER-CLOSURES [undetermined]: Local newspaper-closure/wage-drop table attributed to Han Stice and joined into the investor-firm-quarter panel; the `news` library has no assignment in supplied SAS.
- R-LOCAL-INFO-STATE [undetermined]: State-level local-information summary file named in the SAS comments and joined by cik/qrank; the supplied R program writes no Local_info_state.csv.
- R-LOCAL-INFO-COUNTY [undetermined]: County-level local-information table named in SAS comments and joined by cik/qrank. Its detailed output columns and the supplied R producer are missing.
- R-LOCAL-INFO-100-160 [undetermined]: Combined 100 km and 160 km local-information file named in SAS comments and joined by cik/qrank. Its detailed output columns and the supplied R producer are missing.
- R-LOCAL50-INVESTOR-STORE [undetermined]: Investor-store local50 list used by the subscriber proximity branch. The code derives a ticker from store_id and requires investor/quarter/store/local_50k keys; the R file has no writer for this list.
- R-POOR-SIGNAL-SUMMARY [undetermined]: Investor-firm-quarter summary of car-change/return sign matches and available quarters used to define the poor-local-signal flag; no producer is supplied.
- R-KSWCAR13-STORE-PANEL [undetermined]: Store-quarter outcome/control panel read by SAS as ow.Kswcar13. R computes some such variables in memory, but does not write a Kswcar13 file or establish its output schema.
- R-LOCAL50-STORE-AWS [undetermined]: Separate store-outcome local50 list used to total local-investor flags by store_id/qrank. Keep this distinct from the investor-store local50 file in the subscriber branch.
- R-LOCAL-STORE-OTHER-50K [undetermined]: AWS nearby-store-car-count file joined to each store-quarter outcome panel; no producer is supplied.
- R-CAR-CHANGE-FIRM-AWS [undetermined]: AWS firm-quarter average car-change file joined into the store-outcome branch; no producer is supplied.
- SW-R-PACKAGES [unverified]: The source calls data.table/fread, dplyr grouping and pipe helpers, sqldf, stringr::str_replace_all, lubridate date helpers and geosphere::distHaversine; it also loads data(zipcode) and calls clean.zipcodes without package-loading/setup. The file does define and apply its own winsor2 helper at lines 245–258. Package versions, namespace availability and the zipcode/clean.zipcodes provider are unverified.
- SW-SAS-94 [unverified]: The configured sas_u8 executable is present, but the frozen environment record reports startup failure while loading TKELS. This does not establish missing license or missing installation; no SAS startup was repeated for this assignment.
- SW-SAS-IMPORT-EXPORT-ENGINES [unverified]: The supplied SAS program invokes PROC IMPORT DBMS=EXCEL for the manual match workbook and PROC EXPORT DBMS=STATA for output files. The required installed SAS import/export engines cannot be confirmed while the SAS runtime remains unverified; Stata itself is not required because no Stata program is supplied.

## Review notes

- Scope includes both supplied preparation programs and every supplied SAS branch/export; no paper-wide estimator without source code is inferred.
- Dependency review covers all frozen IDs D0001-D0098. Generated SAS/R intermediates are retained as in-scope workflow stages; unresolved external inputs and self-reads remain linked to requirements/issues and actions.
- No author R/SAS program was executed. The bounded catalog/readability probes and frozen environment observation do not establish full population/history coverage, current provider access, SAS startup, or a successful execution.
