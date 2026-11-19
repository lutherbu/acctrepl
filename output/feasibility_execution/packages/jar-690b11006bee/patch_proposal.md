# Patch proposal: jar-690b11006bee

The Economic Consequences of Financial Audit Regulation in the Charitable Sector

DOI: 10.1111/1475-679X.12417

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-supplied SQL Server 2017 raw-source cleansing and state/county sample construction, followed by the Stata 17 ODBC Table 2-6 program, preserving all five exact samples SMPL_A through SMPL_E.

Entry points: `1- Data cleansing and processing.sql`, `2- Tables.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 4/12417 - The-Economic-Consequences-of-Financial-Audit-Regulation-in-the-Charitable-Sector/duguay-datasheet-code-and-identifiers.zip",
      "sha256": "351dbba3e1142d44c5586c1e681cf537e5633753d4960d853bce53bed20bff01"
    },
    {
      "path": "JAR-Volume 60/Issue 4/12417 - The-Economic-Consequences-of-Financial-Audit-Regulation-in-the-Charitable-Sector/duguay-online-appendix.pdf",
      "sha256": "ad7e0a906758c32a6cc1a730552ea50d5f879233d00f9f95bcc818e21c0d4124"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "207ae7120c4f50618b80982a5ede940959d27c68098b5652e3689655374d81d5"
}
```

## Proposed actions

### act-acquire-charity-source-families: Identify compatible NCCS Core PC, NCCS BMF and four distinct GuideStar source products, then map them into the author-referenced raw database/table contracts.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: data-nccs-core, data-nccs-bmf, data-guidestar-nccs, data-guidestar-2003-2008, data-guidestar-post2008, data-guidestar-990ez, issue-source-contracts
Evidence: src_datasheet_downloads, src_datasheet_nonproprietary, src_sql_nccs, src_sql_bmf, src_sql_guidestar_nccs, src_sql_guidestar_20032008, src_sql_guidestar_post2008, src_sql_guidestar_990ez, pub_nccs_core_classic, pub_nccs_bmf_legacy, pub_candid_academic_period

Preparation / proposed procedure:

1. For NCCS Core, identify a classic 501(c)(3) PC/full-990 annual product with compatible tax-year coverage and verify the SQL-required columns, tax period, EIN format, NTEE, revenue, asset, contribution, FIPS and rule-date fields.
2. For BMF, identify a compatible historical annual product and verify CTAXPER, EIN, FIPS, LEVEL1, NTEECC and RULEDATE fields and the state/status history required by the SQL.
3. For each of the four GuideStar branches, identify a product family compatible with its named header/schedule tables, member or Form 990 variant, join key (nccskey, FIN_ID/EIN, or XML_DOCUMENT_ID/EIN), and code-required year coverage. The author datasheet's acquisition date records provenance; matching original download bytes is not a requirement. Current Candid academic years 2014-2018 do not establish compatibility for other branch years or table contracts.

Validation to perform later:

- Compare table/column names, types, EIN/FIPS formatting, member/table coverage and annual periods against every author FROM/JOIN/filter before importing compatible products under the author-referenced raw names.
- Keep all raw source databases read-only during the author SQL run and retain all four distinct GuideStar source branches with their separate contracts.

### act-prepare-irs-sources: Prepare compatible IRS SOI state and county inputs under the SQL-consumed table contracts and verify item, AGI and geography fields before construction.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: data-irs-state, data-irs-county, issue-source-contracts
Evidence: src_sql_irs_state, src_sql_irs_county, src_sql_irs_county_vintages, pub_irs_state, pub_irs_state_year_index, pub_irs_county, src_sql_irs_state_fips_producer

Preparation / proposed procedure:

1. For state SOI, preserve STATE_1997_2001, STATE_2002_2003, STATE_2004_2009, STATE_2010_2011 and STATE_2012_2015; verify the year-specific AGI brackets and return/itemized-deduction/contribution item names and units.
2. For county SOI, verify all six 2010-2015 tables and the state/county FIPS, AGI_STUB, A00100, N04470, N19700 and N1 meanings against the official record layouts.
3. The supplied SQL also projects DISTINCT STATEFIPS and STATE from the 2015 county table into working JMP.STATE_FIPS_CROSSWALK. Verify those source fields and keep this as a generated working output from the already-required IRS county input, not an additional external raw-data requirement.

Validation to perform later:

- Check each source vintage maps to the authored annual sample without changing the SQL's pivot/unpivot definitions, FIPS joins, bracket construction or sample years.
- Do not infer missing FIPS/name values or assume generated-map field types and geography coverage until the imported 2015 county source contract is checked.

### act-prepare-census-and-maps: Match compatible Census population vintage blocks and separately resolve the state-name and state-FIPS table contracts at their exact Census database paths.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data-census-population, data-census-state-name-crosswalk, data-census-state-fips-crosswalk, issue-handcollected-crosswalks
Evidence: src_sql_census_pop_2010, src_sql_census_pop_1997_2009, pub_census_vintages, src_sql_census_fips_consumer, src_sql_irs_state_fips_producer

Preparation / proposed procedure:

1. Identify official Census estimate vintages/products and verify the named 1997-1999, 2000-2010 and 2010-2017 blocks, reference years, fields and geography. Preserve the code's source-year choices without requiring byte identity to an author file; do not mix incompatible vintages.
2. Resolve the separate JMP_Census_Bureau_Pop_State.dbo.STATE_ABBREVIATION_handcollected state-name map and verify STATE_NAME/STATE_ABBREVIATION meanings, types and coverage; no rows are inferred from names.
3. For JMP_Census_Bureau_Pop_State.dbo.STATE_FIPS_CROSSWALK_handcollected, first check whether the SQL-generated JMP.STATE_FIPS_CROSSWALK projection from the already-required 2015 IRS county source matches STATEFIPS/STATE type, values and geography required by Pop_1997_1999.FIPS_STATE. If compatible, determine whether that same-data map can be staged under the exact Census target table name in a prepared source-database copy before the consumer runs; otherwise retain a compatible separately supplied Census table route. The staging route and map contract are unverified.

Validation to perform later:

- Confirm the three Census source blocks and exact table paths match the authored joins while keeping original source inputs read-only during the author SQL run.
- Keep state-name-to-abbreviation mapping separate from FIPS-to-state mapping; do not fabricate or combine crosswalk rows.

### act-prepare-bea-sources: Verify the BEA state/county source products and obtain the author state-name map; preserve county GDP and county population as separate raw inputs.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: data-bea-state-gdp, data-bea-state-crosswalk, data-bea-county-gdp, data-bea-county-population, issue-source-contracts, issue-handcollected-crosswalks
Evidence: src_sql_bea_state, src_sql_bea_county_gdp, src_sql_bea_county_population, pub_bea_state, pub_bea_county

Preparation / proposed procedure:

1. Match a compatible state GDP source to the per-capita real GDP component and 1997-2015 fields, then resolve the separate JMP_BEA_GDP_STATE.dbo.STATE_ABBREVIATION_Handcollected STATE_NAME/STATE_ABBREVIATION map; no IRS-derived FIPS route applies to this name map.
2. Separately match the county all-industry GDP and BEA population raw files through 2016; verify county FIPS, years, labels/units and denominator joins.

Validation to perform later:

- Confirm state and county identifiers, source vintage and units against the SQL filters and same-FIPS/same-year merge before loading any author database.

### act-prepare-bls-source: Match BLS LAUS annual state/county fields and evaluate the same-data IRS FIPS map as a conditional route for the separate BLS state table.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: data-bls-unemployment, data-bls-state-crosswalk, issue-handcollected-crosswalks, issue-source-contracts
Evidence: src_sql_bls, pub_bls_state, pub_bls_county, src_sql_irs_state_fips_producer

Preparation / proposed procedure:

1. Verify annual UNEMPLOYED and LABOR_FORCE values, year, state/county code layout and record types for the author-covered years.
2. For JMP_BLS_Unemployment.dbo.STATE_FIPS_CROSSWALK_Handcollected, check whether the same 2015 IRS STATEFIPS/STATE projection used by working JMP.STATE_FIPS_CROSSWALK matches BLS_unemployment_raw.STATE_FIPS types, values and coverage. If compatible, determine whether it can be staged into the exact BLS target table in a prepared source-database copy before the state join; otherwise use a compatible separate table source. This database-path staging and field contract remain unverified.

Validation to perform later:

- Compare prepared BLS fields and FIPS joins to the SQL while retaining the authored state aggregation and county-rate formula.
- Keep BLS and IRS raw source inputs read-only during the author SQL run; do not assume equal field names imply equal values or types.

### act-prepare-charity-navigator: Confirm the author-compatible Charity Navigator historical annual ratings route and its permitted access method before populating the author raw table.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: data-charity-navigator
Evidence: src_datasheet_downloads, src_datasheet_nonproprietary, src_sql_charity_navigator, pub_cn_api_fields, pub_cn_api_access

Preparation / proposed procedure:

1. Ask the author for the 2019 source archive/product and its field/year definition, or verify a current permitted route that supplies EIN, publication date, and overall-score values for the required historical years.
2. If evaluating the current API, confirm plan/access, rating history and exact score-field compatibility without querying or downloading API payloads during this assessment.

Validation to perform later:

- Check EIN formatting, publication-date year, duplicate/latest-publication rule, historical 2003-2015 coverage, and RATING_SCORE_OVERALL semantics before import.

### act-supply-regulation-table: Obtain the exact author hand-collected state audit-regulation table and provenance/mapping notes, including threshold units and effective dates.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: data-audit-regulations, issue-handcollected-rules
Evidence: src_sql_handcollected_rules, src_sql_output_samples, inspection_current_workflow_trace

Preparation / proposed procedure:

1. Identify the original workbook or table, source law references, state rows, DATE_EFFECTIVE/DATE_INEFFECTIVE, REVENUE_TOTAL_CUTOFF, REV_LESS_GRANTS_CUTOFF, AVG_REV_3YR_CUTOFF and CONTRIB_LESS_GRANTS_CUTOFF definitions/units.
2. Preserve author missing-date conventions, source period and threshold construction in the SQL Server database named by the code.

Validation to perform later:

- Review the actual source rows and field mapping against each observed/simulated mandate use in SQL; do not infer legal thresholds or substitute a new construction.

### act-verify-sqlserver-and-dsn: Establish and verify a native SQL Server 2017 environment and the author JMP database/ODBC DSN configuration before any separately authorized execution.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: software-sqlserver2017, issue-sql-odbc-setup
Evidence: src_readme_versions, src_readme_database_setup, src_stata_table2_samples, probe_native_sqlserver_path, inspection_current_workflow_trace

Preparation / proposed procedure:

1. Confirm the actual SQL Server engine/version and a Stata-compatible ODBC driver/connection route; the PATH check did not establish a local engine and no connection was attempted.
2. Create the empty working database JMP; import every verified raw source as its exact JMP_[Data Source Name] database and keep those sources read-only.
3. Ensure the active SQL context is JMP for unqualified output tables, then configure DSN JMP to the same SQL Server database. Preserve SMPL_A, SMPL_B, SMPL_C, SMPL_D and SMPL_E.

Validation to perform later:

- Without running author programs, verify database/table visibility and DSN target; later, under separate authorization, run the authored SQL followed by the Stata consumer in its documented order.


## Remaining issues and prerequisites

- issue-source-contracts [unresolved; full_pipeline]: The author SQL consumes multiple raw database/table families plus distinct county GDP/population series. Official product pages identify plausible public product families and some historical spans, but exact imported columns/types, year-vintage/member coverage, identifiers, units and join compatibility remain unverified. The raw source databases are not part of the package inventory.
- issue-handcollected-rules [unresolved; full_pipeline]: The SQL requires JMP_AuditRegulations_Handcollected.dbo.STATE_AUDITREG_HANDCOLLECTED, but neither the package inventory nor the author datasheet identifies its source file, fields' units, values, period coverage or mapping. The four thresholds and date rules must be supplied or documented by the author.
- issue-handcollected-crosswalks [unresolved; full_pipeline]: The SQL names separate Census state-name/abbreviation, Census state-FIPS, BEA state-name/abbreviation, and BLS state-FIPS tables. The Census/BLS FIPS tables have a conditional common candidate producer: the supplied SQL derives distinct STATEFIPS/STATE from the already-required IRS 2015 county table. Whether source types, values and geography match the distinct Census/BLS joins, and whether the generated map can be staged into their separate database paths without altering author SQL, is unverified. The Census and BEA name maps remain separate unresolved mappings; no rows are inferred.
- issue-sql-odbc-setup [preparation; full_pipeline]: The README requires an empty SQL working database JMP and separate read-only source databases named JMP_[Data Source Name]. The SQL uses unqualified SELECT INTO/DROP statements, and Tables.do reads exact SMPL_A-E tables through ODBC DSN JMP. Server/database context and DSN target are not packaged or verified.
- data-nccs-core [undetermined]: NCCS Core PC full Form 990 charity filings from which the SQL creates CORE_PC-based organization-year records for 1998-2015.
- data-nccs-bmf [undetermined]: NCCS Business Master File annual vintage table used to supply organization, status, state, FIPS, rule-date and NTEE fields from 1998 onward.
- data-guidestar-nccs [undetermined]: The author SQL's NCCS-GuideStar source family: Master_Header joined to Functional_Expenses, Balance_Sheet, Revenue_and_Expenses and Other_Info by nccskey.
- data-guidestar-2003-2008 [undetermined]: GuideStar 2003-2008 raw header, functional expenses, balance sheets, revenue/expenses, addresses, BMF, other-info and header-supplement tables.
- data-guidestar-post2008 [undetermined]: GuideStar Post2008 Form 990 header and parts I, III, IV, VI, VIII, IX, X and XII plus BMF tables used in the charity panel and Sample E.
- data-guidestar-990ez [undetermined]: GuideStar 990EZ header, Parts I, II, V and III plus BMF tables required by the charity-year panel.
- data-irs-state [undetermined]: IRS SOI state/AGI-size source vintages used to create state-year return, AGI, itemized-deduction and charitable-contribution measures for 1997-2015.
- data-irs-county [undetermined]: IRS SOI county annual data used for Sample D, including FIPS, AGI bracket, itemized deductions, charitable contributions and return counts for 2010-2015.
- data-census-population [undetermined]: Census state population estimate vintages Pop_1997_1999, Pop_2000_2010 and Pop_2010_2017 used to create the state-year population series.
- data-bea-state-gdp [undetermined]: BEA state GDP_STATE_RAW values for the per-capita real GDP component, state geography and years 1997-2015.
- data-bea-state-crosswalk [undetermined]: Separate author-hand-collected BEA state-name to state-abbreviation table used by the state GDP import.
- data-bea-county-gdp [undetermined]: BEA county GDP_COUNTY_RAW all-industry-total annual GDP values for county FIPS and 2001-2016.
- data-bea-county-population [undetermined]: Separate BEA county POP_COUNTY_RAW annual population values used with county GDP to compute per-capita GDP.
- data-bls-unemployment [undetermined]: BLS annual unemployment and labor-force source fields used to construct state and county unemployment rates.
- data-bls-state-crosswalk [undetermined]: BLS state unemployment's separate STATE_FIPS_CROSSWALK_Handcollected table; a same-data IRS-derived map is a conditional staging route.
- data-charity-navigator [undetermined]: Charity Navigator EIN/publication-date/overall-score records used to select the latest publication per EIN-year and build rated/coverage SMPL_B measures.
- data-audit-regulations [undetermined]: Hand-collected state audit-regulation table with effective/inactive dates and revenue/contribution thresholds used in observed and simulated audit mandates.
- data-census-state-name-crosswalk [undetermined]: Separate Census state-name-to-abbreviation table STATE_ABBREVIATION_handcollected used by population vintages from 2000 onward.
- data-census-state-fips-crosswalk [undetermined]: Census 1997-1999 state FIPS-to-state table required at JMP_Census_Bureau_Pop_State.dbo.STATE_FIPS_CROSSWALK_handcollected.
- software-sqlserver2017 [unverified]: The README specifies SQL Server 2017. PATH-only metadata found no sqlservr, sqlcmd, odbcinst or isql command; this does not test for a remote or non-PATH server. A SQL Server 2017 instance, driver and author JMP database/DSN are not established.

## Review notes

- Scope is the complete supplied SQL Server 2017 cleansing/sample-building program and Stata 17 ODBC Table 2-6 consumer. Generated SQL tables are native workflow outputs, not extra external raw-data requirements. Appendix-only analyses without supplied entry code were not added as missing program branches.
- The author datasheet says the source data were not obtained on a proprietary basis. Current official landing/catalog checks are used only to identify candidate public products and bounded current interfaces; exact author field/year/member/ID compatibility remains unverified where stated. Empty frozen-catalog lookups do not establish absent licenses or inaccessible source data.
- The early partial draft and ordered trace were saved before optional catalog/public/software checks; probes/workflow_trace_early.json and probes/early_checkpoint_execution.json remain preserved. probes/workflow_trace_current.json supersedes the early trace with the complete source-to-sample-to-Stata ordering.
- The first early-checkpoint runner launch failed on a relative-path/cwd error before the helper ran. Its full process record is retained as unreferenced process-only inspection evidence; it does not bear on code or data feasibility.
- Identifiers.txt was treated as data and was not read; its values are not included or used as a prepared analysis panel. No author SQL/Stata, estimator, database connection, SAS, source payload or API query was executed.
- The pre-correction draft/output pair/current trace are preserved in probes/archive_before_crosswalk_revision_20261110T130449692725Z/ (manifest SHA-256 10aba48a3446cb108a435d9f869b5b8661d8e2872b1f5f225d91893b05ce1d77). The current correction treats the SQL-produced IRS STATEFIPS/STATE projection as a conditional same-data route for separately named Census/BLS FIPS tables, while preserving unresolved source type, geography and path staging checks; no crosswalk values are inferred.
- Compatible public NCCS/GuideStar/Census source products may satisfy the authored fields, variants, keys, vintage-sensitive choices and periods without byte-for-byte identity to an author download. Census source vintages remain distinct as indicated by the official past-vintage documentation; exact input schema/history checks remain open.
