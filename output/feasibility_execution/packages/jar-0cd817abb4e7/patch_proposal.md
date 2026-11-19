# Patch proposal: jar-0cd817abb4e7

Private Equity and Taxes

DOI: 10.1111/1475-679X.12487

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All eight supplied Stata programs and their required shared, firm, spillover, municipal, and county branches. The two text lists are identifiers, not analysis panels; no separate analysis-only route is supported by supplied data.

Entry points: `OlbertSeverin_Replicationpackage/Buyouts_Formatting.do`, `OlbertSeverin_Replicationpackage/PE_Financials.do`, `OlbertSeverin_Replicationpackage/Firms_Taxes_Analysis.do`, `OlbertSeverin_Replicationpackage/Spillovers_Aggregate_Analysis.do`, `OlbertSeverin_Replicationpackage/Municipals_Formatting.do`, `OlbertSeverin_Replicationpackage/Municipals_Taxes_Analysis.do`, `OlbertSeverin_Replicationpackage/Counties_Formatting.do`, `OlbertSeverin_Replicationpackage/Counties_Taxes_Analysis.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 4/12487 - Private-Equity-and-Taxes/os-datasheet-code-and-identifiers.zip",
      "sha256": "a78a6d37e5503dba2a4d85f35d8d2d89f4bca85b6be7c039fde6f76f882dc72f"
    },
    {
      "path": "JAR-Volume 61/Issue 4/12487 - Private-Equity-and-Taxes/os-online-appendix.pdf",
      "sha256": "e00cef4499b057d4178b6a20316b3df2e1b6290d7305d7efa28e6fb44c0ab583"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "1a478105418d7a7d925dd3f096575e45f62583319a3c08dd1f89e2a931ea04e3"
}
```

## Proposed actions

### A_ZEPHYR_PRODUCTS: Confirm and acquire compatible Zephyr PE Results exports and the distinct Zephyr M&A input through an actually available product route. Preserve the four PE result sheets and documented author fields; do not treat the identifier list as an analysis panel.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_ZEPHYR_PE, R_ZEPHYR_MA
Evidence: E_ORBIS_DOC, E_ZEPHYR_CODE, E_IDS_DOC, E_MA_CODE, E_CATALOG_SCAN

Preparation / proposed procedure:

1. Confirm whether the required Zephyr PE and M&A product tables are available in the user's permitted environment; the local catalog scan did not verify a compatible candidate or access.
2. For the PE branch, obtain the four Results-sheet exports required by Buyouts_Formatting.do and check the raw deal, target, acquirer, vendor, status, and date fields against the code mappings.
3. For the M&A branch, identify a compatible Zephyr M&A transaction export for the expected deal_id, bvd, and year transformation; retain its source population and period as a separate contract.
4. Place compatible source files in the package-relative original-data location in a writable working copy, retaining the supplied search list as provenance only.

Validation to perform later:

- Before any authorized run, use bounded metadata inspection to confirm sheet names, required columns, identifier types, and period coverage.
- After authorization, compare formatter-created deal outputs with the consumed names and fields without changing the supplied sample rules.

### A_MA_ENRICHMENT_PANELS: Resolve the missing producers for the acquirer-year deal and haven panels. Use compatible author-prepared files or a specified raw-source transformation as alternatives; do not require both routes.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ZEPHYR_MA_ACQ, R_ZEPHYR_MA_HAVENS, I_AUX_PRODUCERS
Evidence: E_MA_ENRICH_CODE, E_MA_CODE, E_WORKFLOW_TRACE, E_CATALOG_SCAN

Preparation / proposed procedure:

1. Obtain the exact author-prepared zephyr_manda_acquirors.dta and zephyr_manda_acquirors_havens.dta contracts, or obtain the complete source-to-panel transformation and its required inputs.
2. Confirm the transaction/acquirer universe, country and year coverage, deal_manda/deal_manda_local/deal_haven definitions, and bvd_acquiror-year join keys.
3. Select one compatible route for each consumed panel; raw Zephyr inputs are conditional reconstruction sources and are not an additional mandatory AND requirement while prepared panels suffice.

Validation to perform later:

- Use bounded metadata inspection to verify bvd_acquiror and year keys and all three fields retained by the firm-analysis merges.
- After authorization, confirm producer output names and consumer merge keys before the firm analysis stage.

### A_ORBIS_FINANCIAL_EXPORTS: Confirm an available Orbis financial-statement route and export the country files in the format consumed by PE_Financials.do.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_ORBIS_FIN
Evidence: E_ORBIS_DOC, E_ORBIS_CODE, E_CATALOG_SCAN

Preparation / proposed procedure:

1. Confirm a permitted local BvD Orbis product route and the country/year coverage; catalog metadata did not verify a compatible local table or entitlement.
2. Export the documented financial statement fields and raw bvdid/country_alpha2 identifiers required by the supplied import and normalization steps.
3. Retain the code's accounting filters and build each orbis_eur_<country>.txt in the expected original-data location after field mapping is confirmed.

Validation to perform later:

- Use bounded file metadata checks for encoding, delimiter, field names, identifiers, and 1997-2020 observation coverage before any author program is run.
- After authorization, confirm normalized bvd/country/year keys and the financial fields needed by the later joins.

### A_ORBIS_OWNERSHIP_INPUTS: Resolve ownership-file routes and their code-specific history, fields, joins, and transformations, using the formatted full panel actually consumed by Buyouts as the primary candidate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ORBIS_COUNTRY_OWN, R_ORBIS_PANEL_OWN, R_ORBIS_EUROPE_OWN, R_ORBIS_MUNSHARES, I_ORBIS_OWNERSHIP
Evidence: E_ORBIS_DOC, E_ORBIS_CODE, E_PANEL_OWN_CODE, E_EUROPE_OWN_CODE, E_SPILL_MUNSHARE_FIELDS, E_WORKFLOW_TRACE, E_CATALOG_SCAN, E_ORBIS_PANEL_ACTIVE_USE, E_ORBIS_PANEL_ACTIVE_FIELDS

Preparation / proposed procedure:

1. For the full-panel requirement, first confirm a compatible formatted $form/orbis_ownership_panel_full_variables_group.dta with the active bvd/year keys and the exact fields retained at lines 420/432.
2. If the formatted panel is not available, treat the raw $orig_own/orbis_ownership_panel_full_variables_group.dta plus the commented lines 405-408 preparation as one conditional alternative route; do not require raw and formatted versions as separate mandatory inputs.
3. For country, Europe, and municipality-share files, confirm their distinct prepared inputs or exact raw-source transformations, including the separate active joins and share-field definitions.
4. Confirm the full hierarchy history, parent/group construction, populations, and join coverage required by each selected route; preserve 2005-2018 as datasheet context rather than a complete code contract.

Validation to perform later:

- Use bounded metadata checks to confirm each selected table's bvd/year keys, code-retained fields, and geography/history before any run.
- After authorization, verify that the exact producer output path resolves to every consumer, including the separate spillover share-file root.

### A_FAME_UK_PANEL: Confirm and acquire a FAME UK panel route that supplies the two fee fields used by the firm analysis.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FAME_UK
Evidence: E_FAME_CODE, E_ORBIS_DOC, E_CATALOG_SCAN

Preparation / proposed procedure:

1. Confirm a permitted local BvD FAME route and whether the required fees_tax_log_fame and fees_nontax_log_fame measures are available for the code's bvd-year join.
2. Acquire or export the compatible panel to the expected uk_fame root after its history, population, fee definitions, and identifier mapping are established.

Validation to perform later:

- Use bounded metadata inspection to verify bvd/year keys, both fee fields, and the required country and period coverage.
- After authorization, confirm the supplied many-to-one join is compatible with the selected panel.

### A_MACRO_REGULATION_INPUTS: Identify the exact source products or author-prepared panels and producers for country-year macro and regulation inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MACRO, R_REGULATION, I_AUX_PRODUCERS
Evidence: E_MACRO_REG_CODE, E_WORKFLOW_TRACE, E_CATALOG_SCAN

Preparation / proposed procedure:

1. Obtain the source/product and field-definition contract for oecd_countries.dta, including country identifiers, yearly coverage, GDP, rates, corporate tax, credit, incentive, and IP-box variables.
2. Obtain the source/product and producer contract for regulation_countries.dta, including group* definitions, country-year coverage, and the relationship to the macro panel.
3. Use compatible author-prepared panels if supplied; do not infer a table or historical range from the filenames alone.

Validation to perform later:

- Use bounded metadata inspection to verify countryiso/year keys and every field named by the corresponding consumer.
- After authorization, confirm that both country-year panels join at the expected keys without changing the supplied filters.

### A_MUNICIPAL_INPUTS: Resolve municipal raw/public source products, workbook schemas, municipality coverage, and the municipal GDP source-year mapping before choosing compatible inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MUN_TAX, R_MUN_REVENUE, R_MUN_SPENDING, R_GV_CROSSWALK, R_MUN_GDP, I_MUN_GDP_YEAR, I_ADMIN_CONTRACT
Evidence: E_ADMIN_DOC, E_MUN_FORMAT, E_MUN_CROSSWALK_CODE, E_MUN_GDP_CODE, E_PUBLIC_GV_FIELDS, E_PUBLIC_GV_2010, E_PUBLIC_MUNICIPAL_FINANCE, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Obtain either the author's code-format municipal tax, revenue, and spending workbooks or exact compatible official products; confirm source definitions, municipality population, years, and the source columns imported by the code.
2. For the 2010 Gemeindeverzeichnis crosswalk, confirm the Gemeindedaten sheet and the C/D/E/G ID, H name, N postcode, I area, and J population mapping before forming the county and postcode joins.
3. Identify the exact municipal GDP product and source-year layout for GDP 2000-2018.xlsx. Keep the supplied 2000/2017 loop unchanged until the 2018-versus-2017 mapping is clarified.
4. Select the compatible author or public route for each consumed input; treat candidate sources as alternatives and do not substitute the distinct county GDP product for municipal GDP.

Validation to perform later:

- Use bounded metadata checks to compare each selected workbook's imported column positions, keys, year coverage, and definitions with the formatter's mappings.
- After authorization, confirm that formatter-created municipal panels retain the supplied municipality, county, postcode, and year keys before analysis.

### A_COUNTY_FISCAL_INPUTS: Confirm county fiscal source products, category definitions, county-year coverage, and the workbooks' compatibility with the supplied merges.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COUNTY_GDP, R_COUNTY_REVENUE, R_COUNTY_SPENDING, R_COUNTY_TAX, R_COUNTY_DEBT, I_ADMIN_CONTRACT
Evidence: E_ADMIN_DOC, E_COUNTY_FORMAT, E_COUNTY_FINAL_MERGES, E_PUBLIC_COUNTY_GDP, E_PUBLIC_MUNICIPAL_FINANCE, E_PUBLIC_DEBT, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. For county GDP, revenues, spending, taxes, and debt, obtain either the offered author-format inputs or an exact official public series and document county identifiers, measure definitions, and source years.
2. Confirm that the 2000-2015 and 2016-2019 tax files, and the 2000-2009 and 2010-2019 debt files, remain comparable at their supplied range boundaries and match the merge keys.
3. Use the county GDP page only as a product candidate; establish historical vintage, county coverage, and field mapping before treating it as compatible with the author workbook.

Validation to perform later:

- Use bounded metadata inspection to confirm county ID, year, source columns, total/per-worker/per-capita GDP, and each fiscal category required by the formatter.
- After authorization, confirm the prepared category panels merge at the supplied county_id-year keys with their documented ranges.

### A_COUNTY_COMPLEMENTARY_INPUTS: Resolve the county personnel, insolvency, and business-registration products and their required historical county-year definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COUNTY_STAFF, R_COUNTY_INSOLV, R_COUNTY_REGISTRATION, I_ADMIN_CONTRACT
Evidence: E_ADMIN_DOC, E_COUNTY_FINAL_MERGES, E_PUBLIC_PERSONNEL, E_PUBLIC_INSOLVENCY, E_PUBLIC_BUSINESS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Obtain the offered author-format staff, insolvency, and business-registration workbooks or exact public tables that match the code's county-level measures.
2. Confirm county identifiers, count/category definitions, source columns, and coverage for the staff range split 2000-2005/2006-2019, insolvency 2007-2020, and registrations 1998-2020.
3. Treat official portal pages and search snippets as product candidates only; do not assume they verify the author files' county schemas or years.

Validation to perform later:

- Use bounded metadata checks to verify county/year keys and each selected source measure against the formatter's expected transformations.
- After authorization, confirm these panels are present at the paths consumed by the county final merge.

### A_PATH_CONFIGURATION: Configure known supplied roots and the same-data alias for the PE-produced spillover input in a host-visible working copy; configure the separate municipality-share root only after independently supplying and verifying that input; keep cleanup limited to its existing target directory.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_SETUP
Evidence: E_MACRO_STRUCTURE, E_WORKFLOW_TRACE, E_PREP_DOC

Preparation / proposed procedure:

1. Map each program's original, formatted, final, buyout, financial, ownership, macro, regulation, UK FAME, and merged roots to distinct writable relative paths under the selected working directory.
2. Activate the root assignments in a working-copy configuration or driver; preserve original source files and keep every documented branch directory distinct.
3. Point the first literal W-drive spillover read, orbis_<country>.dta, to the corresponding Orbis output produced by PE_Financials.
4. Configure the separate root for orbis_<country>_munshares.dta only after R_ORBIS_MUNSHARES has been independently supplied and verified; the package has no producer for this product.
5. Configure the existing Windows-style shell cleanup for the host while preserving its current target path and scope; do not broaden deletion or cleanup behavior.
6. Use only relative or approved [redacted-path-f3e309678cfb] runtime paths; do not embed absolute Dropbox workspace paths in executable configuration.

Validation to perform later:

- Before execution, verify each resolved root is host-visible and writable where the supplied programs save outputs.
- Confirm the first spillover path resolves to the corresponding PE_Financials output; separately verify the municipality-share product has been supplied before resolving its consumer path, and keep cleanup within its existing target.
- Walk the ordered trace to confirm all producer and consumer paths agree across the supplied branches.

### A_MISSING_STATA_ADDONS: Establish compatible Stata ado-path availability for winsor2 and distinct, which the exact metadata probes did not find.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR2, SW_DISTINCT
Evidence: E_SOFT_WINSOR2, E_WINSOR_CODE, E_SOFT_DISTINCT, E_DISTINCT_CODE

Preparation / proposed procedure:

1. Confirm whether compatible winsor2 and distinct ado files are available in the intended Stata 18 environment or can be added through the user's permitted package setup.
2. Preserve the supplied commands and analysis variables; do not replace winsorization or distinct-count behavior with another method.

Validation to perform later:

- After authorized setup, use exact which and version/help metadata checks for winsor2 and distinct in the intended Stata adopath.
- Before any authorized author run, confirm both commands resolve from the runtime environment used for the package.

### A_ASDF_CLARIFICATION: Resolve the meaning and namespace of each literal asdf command before changing or attempting the affected scripts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SW_ASDF, I_ASDF
Evidence: E_ASDF_CODE, E_SOFT_ASDF, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Review the six exact asdf locations in the saved workflow trace and determine which belong to operative branches.
2. Obtain the intended command namespace and operation from the author or project documentation; the Stata which result alone does not identify an appropriate replacement.
3. Keep every source line unchanged and do not install, delete, or substitute a command until the intended operation is known.

Validation to perform later:

- After clarification, use bounded which/find-package/help metadata to establish the exact command provider and supported syntax.
- Before any authorized run, verify all six call sites against that confirmed namespace without changing the scientific workflow.

### A_FULL_WORKFLOW_ORDER: Preserve the supplied producer-consumer order for every included firm, spillover, municipal, and county branch.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_DEPENDENCY_CLOSURE, I_PATH_SETUP
Evidence: E_WORKFLOW_TRACE, E_ANALYSIS_DOC, E_PREP_DOC, E_MACRO_STRUCTURE

Preparation / proposed procedure:

1. In a resolved writable working copy, run Buyouts_Formatting.do to create the PE deal intermediates and Data_Final/zephyr_privateequity.dta from its Zephyr exports and the selected full ownership route; the commented raw block is optional preparation for the same formatted ownership input.
2. Run PE_Financials.do after the PE deal producer; it consumes country Orbis financials/ownership, the Zephyr M&A input, and macro controls, then creates financial, treated-control, matching-control, and M&A-control outputs.
3. Run Municipals_Formatting.do before Municipals_Taxes_Analysis.do, and Counties_Formatting.do before Counties_Taxes_Analysis.do. These local-data preparation branches are independent of each other, while their analyses also require the shared German Orbis, PE, and M&A inputs.
4. Run Firms_Taxes_Analysis.do after PE_Financials.do and after its FAME, M&A-acquirer/haven, macro, regulation, and European ownership inputs are available.
5. Run Spillovers_Aggregate_Analysis.do after the PE/Orbis producer stages and only after its separate Orbis municipality-share input and same-data root alias are configured.
6. Retain every supplied program and branch; keep missing data producers and scientific history/field contracts as prerequisites, and handle the known root map as routine setup.

Validation to perform later:

- Before a future authorized run, verify each named producer output exists at the path resolved by its consumer and retains the documented keys/fields.
- After authorization, record separate return codes and streams for each entry point in the stated order; execution remains unverified in this assessment.


## Remaining issues and prerequisites

- I_AUX_PRODUCERS [unresolved; full_pipeline]: The supplied programs consume the FAME UK panel, Zephyr M&A acquirer/haven panels, country macro and regulation panels, and Orbis municipality-share file without a complete producer/export contract. The primary file names and consumer fields are recorded in linked requirements; no producer or compatible complete source route is confirmed for the missing panels.
- I_ORBIS_OWNERSHIP [unresolved; full_pipeline]: The active Buyouts consumers read the formatted full ownership panel from $form; country, European, and municipality-share ownership products have separate active consumers. The raw full-panel step at lines 405-408 is a commented conditional preparation route, not an additional mandatory input. The active field lists are known, but datasheet history of 2005-2018 is not a complete population/history contract and parent links, grouping, hierarchy history, and share definitions remain unresolved. Prepared and raw routes are alternatives, not cumulative requirements.
- I_ADMIN_CONTRACT [unresolved; full_pipeline]: Official public pages and search snippets identify candidate German directory, regional-account, municipal-finance, debt, personnel, registration, and insolvency products, but do not verify all author workbook schemas, county/municipality populations, years, category definitions, or revisions. The author offers raw administrative data in code format on request; candidate routes remain unverified.
- I_PATH_SETUP [preparation; full_pipeline]: Six supplied programs place global-root assignments inside block comments, so a host-visible relative root map must be configured in a working copy. Spillovers reads two literal Windows W-drive paths: orbis_<country>.dta, produced by PE_Financials, and orbis_<country>_munshares.dta, a separate R_ORBIS_MUNSHARES input with no supplied producer. Root portability for both paths is routine preparation, but configuring the second path does not supply the missing municipality-share product; it must be independently supplied and verified before use. PE_Financials also has a Windows-style shell cleanup command, which needs host adaptation within its existing target scope. No new data or author approval is required solely for portable path setup.
- I_ASDF [unresolved; full_pipeline]: Six supplied program locations contain a bare literal asdf command. One exact Stata which lookup did not find a command named asdf, but the namespace, placeholder intent, and whether any location is operative remain unknown. Preserve every location and do not remove or replace it without author clarification.
- I_MUN_GDP_YEAR [unresolved; full_pipeline]: The municipal GDP workbook label states 2000-2018, while the supplied year-marker loop is 2000/2017. The exact source-year mapping and whether a 2018 observation is present are unresolved; keep the supplied loop unchanged pending clarification.
- I_DEPENDENCY_CLOSURE [unresolved; full_pipeline]: The frozen checklist and static trace retain all supplied branches, but mandatory original inputs are absent or lack exact producer/source contracts. Full closure remains incomplete until linked data, ownership history/construction, and producer gaps are resolved. The known root/path handoffs are routine preparation separately represented by I_PATH_SETUP.
- R_ZEPHYR_PE [undetermined]: The four Results-sheet workbooks Data_Original/Zephyr_Export_1penew through Zephyr_Export_4penew used by Buyouts_Formatting.do. The code normalizes deal, target, acquirer, vendor, and date fields and retains completed PE deals for 2000-2018. The supplied 1990-2019 Zephyr file is an identifier list, not an analysis panel.
- R_ORBIS_FIN [undetermined]: Country exports Data_Original/orbis_eur_<country>.txt imported by PE_Financials.do, with the code's raw bvdid and country_alpha2 names normalized to bvd and country before country-year preparation and matching.
- R_ORBIS_COUNTRY_OWN [undetermined]: Country ownership files Data_Original/orbis_ownership_<country>.dta joined to Orbis statements by bvd and year. PE preparation and spillovers also use group_firms, group_international, treelevel, and bvd_guo fields.
- R_ORBIS_PANEL_OWN [undetermined]: The active Buyouts_Formatting.do consumers at lines 419/420 and 431/432 read the formatted full ownership table $form/orbis_ownership_panel_full_variables_group.dta by bvd and year, retaining the listed parent, hierarchy, haven, and group fields. The Data_Original raw panel read/save block at lines 405-408 is inside a Stata block comment and is only a conditional preparation route to this same formatted input.
- R_ORBIS_EUROPE_OWN [undetermined]: European ownership panel $ownership/orbis_ownership_europe.dta merged by bvd and year in Firms_Taxes_Analysis.do, with the supplied merge retaining taxspread*, haven_group*, subs_*, bvd_parent, bvd_guo, treelevel, and *box* fields.
- R_ZEPHYR_MA [undetermined]: The Zephyr M&A input $buyout/zephyr_manda.dta read by PE_Financials.do before its supplied transformation to zephyr_manda_form.dta. The package does not contain a producer or complete export-to-file contract for this input.
- R_ZEPHYR_MA_ACQ [undetermined]: Prepared acquirer-year panel $buyouts/zephyr_manda_acquirors.dta consumed by Firms_Taxes_Analysis.do; it must supply bvd_acquiror, year, deal_manda, and deal_manda_local. No producer is included.
- R_ZEPHYR_MA_HAVENS [undetermined]: Prepared acquirer-year haven panel $buyouts/zephyr_manda_acquirors_havens.dta consumed by Firms_Taxes_Analysis.do, with bvd_acquiror, year, and deal_haven. No producer is included.
- R_ORBIS_MUNSHARES [undetermined]: Country-specific municipality-share inputs orbis_<country>_munshares.dta appended in Spillovers_Aggregate_Analysis.do from a separate literal W-drive root. The supplied package has no producer; the consumer keeps bvd, year, share_tr*, targets_pe, and municipal.
- R_FAME_UK [undetermined]: UK FAME panel $uk_fame/fame_ukfirms.dta joined by bvd and year in Firms_Taxes_Analysis.do, providing fees_tax_log_fame and fees_nontax_log_fame. No source export or producer is included.
- R_MACRO [undetermined]: Country-year file $macro/oecd_countries.dta merged by countryiso and year in Firms_Taxes_Analysis.do. It must provide GDP, interest, corporate-tax, credit, incentive, and IP-box fields; the exact OECD table, source, years, and any upstream producer are not identified.
- R_REGULATION [undetermined]: Country-year file $regulation/regulation_countries.dta merged in Firms_Taxes_Analysis.do by countryiso and year, keeping group* variables. No source product, source fields, producer, geography, or observation period is specified.
- R_MUN_TAX [undetermined]: Annual Data_Original/Steuern <year>.xlsx municipality tax workbooks for 2008-2019. The formatter imports column-letter fields A/B/C/D/E/H/I/J/K/L/M/N/O and builds the normalized tax panel.
- R_MUN_REVENUE [undetermined]: Annual Data_Original/Bruttoeinnahmen <year>.xlsx municipality revenue workbooks for 2008-2014. The formatter maps the source columns A-K to municipality keys and total, administration, tax, transfer, fee, financial, contribution, subsidy, and credit measures.
- R_MUN_SPENDING [undetermined]: Annual Data_Original/Bruttoausgaben <year>.xlsx municipality spending workbooks for 2008-2014. The formatter maps source columns A-J to municipality keys and gross, administration, personnel, operating, financial, credit, investment, and net spending measures.
- R_GV_CROSSWALK [undetermined]: Data_Original/31122010_Auszug_GV.xlsx, sheet Gemeindedaten, used to construct municipality, postcode, area, population, and county lookup keys. The code forms IDs from columns C/D/E/G and maps H, N, I, J to names, postcodes, area, and population; the required edition is year-end 2010.
- R_MUN_GDP [undetermined]: Data_Original/GDP 2000-2018.xlsx imported as municipality ID/name and local GDP, GDP per worker, and per capita GDP from columns A-E. The filename states 2000-2018, but the supplied code constructs year markers only for 2000-2017; the source year mapping is unresolved.
- R_COUNTY_GDP [undetermined]: Data_Original/Kreise GDP 2000-2018.xlsx imported by Counties_Formatting.do with county ID/name and total, per-worker, and per-capita GDP from columns A-E; merged by county and year.
- R_COUNTY_REVENUE [undetermined]: Data_Original/Kreise Einnahmen 2000-2014.xlsx county revenue workbook, columns A-K for county keys and gross, administration, tax, transfer, fee, financial, contribution, subsidy, and credit measures; the formatter expands rows by year.
- R_COUNTY_SPENDING [undetermined]: Data_Original/Kreise Ausgaben 2000-2014.xlsx county spending workbook, columns A-J for county keys and gross, administration, personnel, operating, financial, credit, investment, and net spending measures; the formatter expands rows by year.
- R_COUNTY_TAX [undetermined]: Two Data_Original/Kreise Steuern workbooks, labelled 2000-2015 and 2016-2019, appended by Counties_Formatting.do into the county tax panel for 2000-2019. Tax and transfer categories vary across the two ranges; exact imported source columns and cross-period definitions remain to be confirmed.
- R_COUNTY_DEBT [undetermined]: Two Data_Original/Kreise Schulden workbooks for 2000-2009 and 2010-2019, combined by Counties_Formatting.do into a county debt panel. The exact county coverage, measures, and comparability across ranges are not established.
- R_COUNTY_STAFF [undetermined]: Two Data_Original/Kreise Personal workbooks for 2000-2005 and 2006-2019, combined into a county personnel panel. The required staff measure, county-unit coverage, source columns, and continuity between periods are not specified.
- R_COUNTY_INSOLV [undetermined]: Data_Original/Kreise Unternehmensinsolvenzen 2007-2020.xlsx used by Counties_Formatting.do to prepare county insolvency measures. The exact county-level table, count definition, source layout, and year coverage are not specified by the code consumer.
- R_COUNTY_REGISTRATION [undetermined]: Data_Original/Kreise Gewerbean-abmeldungen 1998-2020.xlsx used to prepare county business-registration measures. The source table, county grouping, event definition, imported fields, and required years are not specified beyond the workbook name.
- SW_WINSOR2 [preparation_required]: The exact Stata which lookup did not find winsor2; the supplied spillover analysis calls it. A future authorized setup check must establish a compatible ado and version.
- SW_DISTINCT [preparation_required]: The exact Stata which lookup did not find distinct; the supplied firm analysis calls it. A future authorized setup check must establish a compatible ado and version.
- SW_ASDF [unverified]: The exact Stata which lookup did not find asdf. Six literal locations are preserved; command namespace and intent are unresolved, so installation or removal is not supported.

## Review notes

- The frozen package header remains Private Equity and Taxes / DOI 10.1111/1475-679X.12487. The README uses the wording Private Equity and Local Public Finances and identifies the author pair and 2023 release; this title variation is discovery metadata only and is not treated as evidence of a wrong package. The direct DOI-page open failed, so no attribution conclusion is drawn from that request.
- The scope includes all eight supplied Stata programs and their documented branches. The two supplied text lists are identifiers, not full firm panels, so no separate analysis-only scope is supported.
- Prepared author tables and raw-source routes are alternatives where both could supply one consumed file. Commercial catalog candidates, official public product pages, snippets, and author-shared inputs remain unverified until fields, geography, years, and construction are matched.
- E_PUBLIC_ATTEMPTS and E_PROCESS_HISTORY are deliberately unreferenced process-only evidence rows. They preserve failed, truncated, and bounded audit attempts with their capture limits; no such incident is used to claim data absence, licensing, a public access barrier, or source incompatibility.
- No author program or analysis, dataset, estimator, plot, synthetic example, or installation was run. No source edit or proposal was applied; the controller will render the patch proposal from the linked actions. Execution remains unverified.
