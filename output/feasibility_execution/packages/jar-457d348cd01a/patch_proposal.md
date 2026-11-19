# Patch proposal: jar-457d348cd01a

Real Effects of Non-Streamlined Sales Tax Administration: Evidence from the Florida Hotel Industry

DOI: 10.1111/1475-679X.70001

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full author-documented workflow: the two supplied SAS data-construction programs plus the Stata estimation stage described by the authors. The main SAS branch depends on DOR, EDR, FDLE, QCEW, data1.dta and county adjacency; the room branch additionally depends on STR records, the county/FIPS match and the distinct b-suffixed base panel. The Stata driver and producer for data2022.10.25b.dta are not established.

Entry points: `Replication code for main data set.sas`, `Replication code for room-level data set.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 5/70001 - Real-Effects-of-Non-Streamlined-Sales-Tax-Administration-Evidence-from-the-Florida-Hotel-Industry/bckw-datasheet-code-identifier-and-log-files.zip",
      "sha256": "93e786bd24020676a0224cbf61ae145b82b5f7ad7197843785cb4849d242c4ce"
    },
    {
      "path": "JAR-Volume 63/Issue 5/70001 - Real-Effects-of-Non-Streamlined-Sales-Tax-Administration-Evidence-from-the-Florida-Hotel-Industry/bckw-online-appendix.pdf",
      "sha256": "c233f28bef609a204c658db4af41174387366e0c04d6a635cceedba2217ca7f3"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "493079d5198a70b2f2be9f3f44bf6a7b31dd136154d77097abe02794a15b5814"
}
```

## Proposed actions

### A_DOR: Use the official Florida DOR history as a public candidate and construct the county-year tax-status input expected as splost9.txt after confirming the author variables.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_DOR
Evidence: E_DOR_DESC, E_DOR_PROVIDER, E_MAIN_DOR_IMPORT, E_MAIN_RATE_FIELDS, E_PUBLIC_DOR_HISTORY

Preparation / proposed procedure:

1. Use the official DOR historical-rate page as the candidate source for county tax history; confirm it covers the author definitions of local_admin and tourist.
2. Map each county history into the required fips, year, local_admin and tourist fields, retaining the definitions and year coverage.
3. Stage the prepared input under a coherent project root and map that root to the supplied SAS import.

Validation to perform later:

- Confirm the required fields, county/year keys, historical period, tax-rate units and switch definitions against the official source and author definition.

### A_EDR: Obtain and stack the public annual Florida EDR handbooks into the county-year revenue input expected as gov rev 2022.03.21.txt.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_EDR
Evidence: E_EDR_DESC, E_EDR_PROVIDER, E_DOC_ECON_STACK, E_MAIN_REV_IMPORT, E_MAIN_REV_FIELD, E_PUBLIC_EDR_HANDBOOKS

Preparation / proposed procedure:

1. Use the official EDR index to identify the annual handbook releases needed for the author period; do not infer the hotel_sales_gov measure from the index alone.
2. Inspect the relevant report sections through a bounded authorized method, then stack the source rows into fips, year_ending and hotel_sales_gov.
3. Stage the prepared text input under a relative project root and keep the source-to-field mapping.

Validation to perform later:

- Check source years, county keys, hotel revenue measure/units and join compatibility with the DOR and QCEW panel.

### A_FDLE: Clarify the exact FDLE population-estimate source because the official public product reviewed is a convictions dataset, not documented county-year population data.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FDLE_OFFENSE, R_FDLE_2019
Evidence: E_MAIN_FDLE_COMMENT, E_MAIN_FDLE1_IMPORT, E_MAIN_FDLE2019_IMPORT, E_MAIN_FDLE_STACK, E_MAIN_POP_FIELD, E_PUBLIC_FDLE_CONVICTIONS

Preparation / proposed procedure:

1. Ask the author to identify the exact FDLE population series, its official static documentation and how the 2019 file relates to the earlier component.
2. Confirm the measure, fields fips/year/population, county coverage and overlap/duplication rules; do not substitute the public convictions product.
3. Acquire or reconstruct only the documented tables after the population source is established.

Validation to perform later:

- Check both CSV schemas, county/year keys, the 2019 overlap rule and population units before the SAS join.

### A_QCEW: Acquire the public BLS annual QCEW single-file CSV series for 1990–2019 and prepare its field names and historic coverage for the supplied SAS filters.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_QCEW
Evidence: E_QCEW_DESC, E_DOC_QCEW_STACK, E_MAIN_QCEW_COMMENT, E_MAIN_QCEW_RANGE, E_MAIN_QCEW_ESTAB, E_PUBLIC_QCEW_FILES, E_PUBLIC_QCEW_LAYOUT, E_PUBLIC_QCEW_HISTORY

Preparation / proposed procedure:

1. Acquire and stage all 30 official annual QCEW single-file CSVs for 1990–2019 with a documented relative-path mapping.
2. Compare annual headers to the official layout; where the source header is annual_avg_estabs_count, map that same measure to the supplied code name annual_avg_estabs in a prepared working copy or documented import step.
3. Retain the source versions and validate the year-specific NAICS codes, ownership/size/aggregation filters, area_fips conversion, suppressed-cell treatment and 1990–2000 reconstructed data before building county-industry panels.

Validation to perform later:

- Confirm every required year and column, including the establishment-count mapping; validate area_fips-to-fips and year normalization, then inspect generated county-industry coverage before joining.

### A_UNEMP: Resolve the producer and complete field contract for data1.dta, using public LAUS for the unemployment-rate component only unless the author documents another source.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_UNEMP, I_UNEMPLOYMENT_CONTRACT
Evidence: E_MAIN_UNEMP_COMMENT, E_MAIN_UNEMP_FIELDS, E_MAIN_QCEW1_PAY_FIELD, E_MAIN_QCEWT_START, E_MAIN_JOIN, E_PUBLIC_LAUS_COUNTY, E_PUBLIC_LAUS_TABLES, E_QCEW_FLOW_SCAN

Preparation / proposed procedure:

1. Confirm the exact LAUS county/year series and mapping that produces ue_rate for the author period.
2. Request the producer and schema for data1.dta, including the provenance and construction of ann_avg_pay_tot; do not treat the separate qcew1 intermediate as its producer or as a proven duplicate in tb.
3. Prepare the county-year data1.dta contract only after the source and any required pay-field transformation are documented.

Validation to perform later:

- Check LAUS county/year coverage, the exact data1.dta fields and source for ann_avg_pay_tot, and the output schema of the downstream join before analysis.

### A_ADJ: Acquire and stage the documented public 2010 NBER county-adjacency product, then verify the supplied SAS field names.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_ADJ
Evidence: E_MAIN_ADJ_IMPORT, E_MAIN_ADJ_FIELD1, E_MAIN_ADJ_FIELD2, E_ROOM_ADJ_IMPORT, E_ROOM_ADJ_FIELDS, E_PUBLIC_NBER_ADJ

Preparation / proposed procedure:

1. Use the official NBER page to select the Census-sourced 2010 county-adjacency product in its listed SAS7BDAT format or another documented format.
2. During staging, verify the county and neighbor FIPS fields; map the neighbor identifier to fipsneighbor only if the source documents the equivalent field.
3. Place the compatible dataset in the configured Florida SAS library under a relative execution root.

Validation to perform later:

- Check field types, county coverage and 2010 adjacency definition against the source, then verify the join keys used by both SAS scripts.

### A_STR: Request the permitted access route and exact schema/history for the STR hotel room demand and pricing data required by the room-level branch.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_STR_RECORDS
Evidence: E_STR_DESC, E_STR_ACCESS, E_ROOM_STR_COMMENT, E_ROOM_MEASURES, E_ROOM_AGG

Preparation / proposed procedure:

1. Ask for the authorized route to the STR county/hotel records and the fields county, date, Rooms_Demand, Average_Daily_Rate, Rooms_Revenue and Census_Prop_Count.
2. Confirm record unit, county assignment, date granularity, product definition, years and permitted use; do not infer a licensing barrier from the word proprietary.
3. Stage the source file for the documented county-year sum/mean aggregation.

Validation to perform later:

- Confirm the source fields and temporal coverage support the room-level aggregation and the Table 6 variables.

### A_STR_MATCH: Obtain the STR county-to-FIPS match file and its matching/coverage rules.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STR_MATCH
Evidence: E_ROOM_MATCH_IMPORT, E_ROOM_MATCH_FILTER, E_ROOM_MATCH_JOIN

Preparation / proposed procedure:

1. Ask for rooms booked match.txt or an authoritative equivalent, including county-name normalization and any manual match decisions.
2. Document missing-FIPS handling and the county coverage over the STR history.
3. Prepare the two tables so the supplied county-name merge maps to numeric FIPS keys.

Validation to perform later:

- Check that all retained STR counties map to valid FIPS codes and that excluded unmatched records are understood.

### A_ROOM_BASE: Identify the actual producer and schema for data2022.10.25b.dta before running the room-level SAS program.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ROOM_BASE, I_ROOM_BASE_PRODUCER
Evidence: E_ROOM_BASE_IMPORT, E_ROOM_BASE_MERGE, E_MAIN_EXPORT, E_BASENAMES

Preparation / proposed procedure:

1. Request the source, production steps, period and fields for data2022.10.25b.dta.
2. Determine whether it is an intentionally distinct prepared panel; do not substitute data2022.10.25.dta solely because it is the main script’s export.
3. If its producer is missing, obtain the exact missing stage and dependencies before proposing any run-order or path change.

Validation to perform later:

- Compare the two panel schemas and measures, then verify a documented producer writes the exact b-suffixed product before the room-level consumer.

### A_STATA_CODE: Recover the Stata estimation entry point and its run instructions because the supplied readable package content does not establish the analysis program.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_STATA_ANALYSIS_CODE
Evidence: E_DOC_STATA_STAGE, E_WORK_ITEM, E_XLSX_PROBE

Preparation / proposed procedure:

1. Request the actual Stata do-file(s), table-generation code, required intermediate files, intended order, and any author-defined branches.
2. Request the command/add-on requirements and versions that correspond to the supplied analyses; do not infer add-ons from the environment inventory.
3. Use the author-declared analysis input(s), keeping the full raw-data workflow separate from any supported analysis-only route.

Validation to perform later:

- After code and inputs are established, confirm every estimator, table and branch maps to the paper’s reported analysis before a separately authorized run.

### A_SAS_ENV: Confirm a usable SAS batch runtime for the two SAS entry points; the registered environment record is unverified and this audit did not start SAS.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_ENV, E_DOC_LANG

Preparation / proposed procedure:

1. Confirm the intended licensed SAS batch installation and version in the actual execution environment.
2. Configure a coherent relative or [redacted-path-022d61d15f0c] root and the Florida library without inserting the author’s absolute path.

Validation to perform later:

- In a separately authorized execution setup, verify SAS batch availability and read/write access to the staged project directories before invoking any supplied program.

### A_RUN: After the missing producers, data contracts and analysis source are resolved, run the supplied preparation stages in their documented order and then the recovered analysis driver.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_STATA_ANALYSIS_CODE, I_ROOM_BASE_PRODUCER, I_UNEMPLOYMENT_CONTRACT
Evidence: E_MAIN_EXPORT, E_ROOM_BASE_IMPORT, E_ROOM_OUTPUT, E_DOC_STATA_STAGE, E_BASENAMES

Preparation / proposed procedure:

1. Stage the exact input products and named files under a coherent relative project root; keep the DOR, EDR, FDLE, QCEW, unemployment, adjacency, STR and match inputs distinct.
2. Run Replication code for main data set.sas after its own input producers; it exports data2022.10.25.dta.
3. Resolve and run the distinct producer for data2022.10.25b.dta before Replication code for room-level data set.sas; the supplied main export is not a proven substitute.
4. Run Replication code for room-level data set.sas after both STR inputs, the base panel and adjacency file are staged; it exports data2023.09.27 rooms.dta.
5. Run the recovered Stata analysis code only after its required datasets and commands are established.

Validation to perform later:

- Verify each expected output is written before its first consumer, confirm county/year keys and required measures at each handoff, and compare the recovered table outputs against the author documentation.


## Remaining issues and prerequisites

- I_STATA_ANALYSIS_CODE [unresolved; full_pipeline]: The documentation says Stata code estimates the reported regressions, but the readable supplied program sources are the two SAS data-construction scripts. The named XLSX static inspection extracts zero program elements; logs remain opaque and are not treated as source. The estimation entry point and required commands are therefore not established.
- I_ROOM_BASE_PRODUCER [unresolved; full_pipeline]: The room-level SAS script consumes data2022.10.25b.dta. The main SAS script exports data2022.10.25.dta, a different basename, and no supplied source produces the b-suffixed input. Do not substitute the main output without a documented compatible producer/schema.
- I_UNEMPLOYMENT_CONTRACT [unresolved; full_pipeline]: The main code imports data1.dta as ue and requires fips, year, ue_rate and ann_avg_pay_tot. A separate qcew1 intermediate assigns ann_avg_pay_tot from avg_annual_pay, but qcewt rereads the annual QCEW inputs and is the distinct path used to build the downstream panels; a bounded source scan found qcew1 only at its definition. The supplied source does not identify the producer or exact origin of data1.dta fields. The evidence does not establish that qcew1 feeds tb or that ann_avg_pay_tot is duplicated in the downstream join.
- R_DOR [undetermined]: Florida county-year sales-tax rate and administration-switch panel imported from splost9.txt; public source history exists, but the author-specific annual fields and switch construction remain unverified.
- R_EDR [undetermined]: Florida county-year hotel revenue panel imported from annual Local Government Financial Information Handbook files; exact measure, years and extraction remain unverified.
- R_FDLE_OFFENSE [undetermined]: FDLE county-year population component imported from fdle_offense.csv.
- R_FDLE_2019 [undetermined]: FDLE 2019 county-year population supplement imported from fdle_2019.csv and stacked with the other FDLE component.
- R_QCEW [public_acquisition_required]: BLS QCEW annual single-file CSV inputs for 1990–2019 used to build the Florida county-industry employment and wage panel; the verified public product needs a same-measure establishments-field mapping and historical-code checks before use.
- R_UNEMP [undetermined]: Prepared county-year unemployment input data1.dta, imported as ue and reduced to fips, year, ue_rate and ann_avg_pay_tot; public LAUS supports the rate component, but the prepared-file producer and pay-field source remain unknown.
- R_ADJ [undetermined]: NBER 2010 county-adjacency input loaded as florida.county_adjacency2010 in both supplied programs; public product route is documented, while field-name compatibility and staged-file availability remain unverified.
- R_STR_RECORDS [undetermined]: STR hotel-level or date-level room demand, rate, revenue and property-count records imported from rooms booked.txt and collapsed to county-year.
- R_STR_MATCH [undetermined]: County-name to FIPS match table rooms booked match.txt used to assign STR records to county-year keys.
- R_ROOM_BASE [undetermined]: Prepared county-year base panel data2022.10.25b.dta consumed by the room-level branch before joining STR measures.
- SW_SAS [unverified]: Required by both supplied data-construction entry scripts. The original registered environment probe reports SAS as unverified with return code 1 and no version; this audit did not start SAS.

## Review notes

- The full author-documented workflow has two supplied SAS data-construction entry points and a Stata estimation stage described by the authors. All 41 assigned dependency edges are covered.
- The main SAS branch reads the DOR, EDR, two FDLE components, 30 QCEW annual files, data1.dta and 2010 adjacency; it writes data2022.10.25.dta.
- The room branch reads STR records, the county/FIPS match, data2022.10.25b.dta and the shared adjacency; it writes data2023.09.27 rooms.dta. The main output is not established as the distinct room-base producer.
- Official QCEW annual files cover 1990–2019. The official establishment field annual_avg_estabs_count needs a same-measure mapping to the supplied code name annual_avg_estabs; reconstructed and suppressed historical data need coverage checks.
- Official LAUS supports the unemployment-rate component but not the complete data1.dta producer or ann_avg_pay_tot source. The separate qcew1 intermediate does not appear in the downstream QCEW panel path.
- DOR and EDR are public candidates with exact author-field, measure and period mappings unresolved. FDLE public materials reviewed document convictions rather than the claimed population series. STR and local prepared inputs remain unverified; no licensing barrier was established.
- NBER documents the public 2010 adjacency product and SAS7BDAT format; confirm the neighbor-field name while staging. The Stata analysis entry point is unestablished; XLSX static inspection found zero program elements and logs stayed opaque. SAS runtime is unverified; Stata 18 is available. No author program, model, statistics, SAS runtime or data payload was used.
