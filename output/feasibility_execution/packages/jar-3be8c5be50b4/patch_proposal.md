# Patch proposal: jar-3be8c5be50b4

Corporate Tax System Complexity and Investment Sensitivity to Tax Policy Changes

DOI: 10.1111/1475-679X.70040

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full author-documented Stata workflow: ordered preparation produces the primary firm-year sample, then runs the primary analysis and supplied stacked DiD branch.

Entry points: `0_master.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 4/70040 - Corporate-Tax-System-Complexity-and-Investment-Sensitivity-to-Tax-Policy-Changes/agwdatasheetcodeidentifiersandlogfiles.zip",
      "sha256": "853f58b5a9c80fd538925845af22cf431a25e2aef6453c01958ada51349e0e43"
    },
    {
      "path": "JAR-Volume 64/Issue 4/70040 - Corporate-Tax-System-Complexity-and-Investment-Sensitivity-to-Tax-Policy-Changes/agw-online-appendix.pdf",
      "sha256": "548b57bafced751e3802ff0047e6e99dc914d50b9bc4e12421ef56477203622e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "5dd3e0a39aeec2141c70ab75ea1a68c3946c4dcd02429fcb88a400d0516e0b68"
}
```

## Proposed actions

### A_ORBIS_MAIN: Obtain the author-described main Orbis extract using the supplied sample identifiers and documented filters.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_ORBIS_MAIN
Evidence: E_AUTHOR_ORBIS_ACCESS, E_AUTHOR_ORBIS_EXTRACTS, E_AUTHOR_ORBIS_FILTERS_1, E_AUTHOR_ORBIS_FILTERS_2, E_MAIN_LOOP, E_MAIN_FILTER, E_MAIN_FIELDS, E_MAIN_PERIOD, E_MAIN_SEVEN_YEARS, E_PACKAGED_IDS, E_BVD_PROBE

Preparation / proposed procedure:

1. Use the bundled BvD ID list only as a retrieval list. Obtain the 504 numbered main files through an authorized Orbis route using the author’s active-company/geography/ownership criteria and 2012–2019 financial fields.
2. Stage the files in the configured working-copy input tree without changing sample or analysis rules.

Validation to perform later:

- Check the numbered set, BvD IDs, status/NACE filters, year columns and required financial field families before sample preparation.

### A_ORBIS_ADDITIONAL: Obtain and stage the separate 37-file supplemental Orbis pull before the BvD-key merge.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_ORBIS_ADDITIONAL
Evidence: E_AUTHOR_ORBIS_EXTRACTS, E_ADD_LOOP, E_ADD_FIELDS, E_ADD_KEYS, E_ADD_SAVE, E_MAIN_SUPP_MERGE

Preparation / proposed procedure:

1. Retrieve the supplemental depreciation/long-term-debt files for the sample IDs through an authorized route.
2. Preserve the supplied producer; confirm raw field labels and keep the supplemental merge on bvdidnumber.

Validation to perform later:

- Check all 37 files, BvD match and depreciation/long-term-debt years before the main sample merge.

### A_COUNTRY_YEARS: Request the exact country-year master or its supported producer specification.

Scopes: full_pipeline. Type: clarification. Certainty: blocked.
Addresses: R_COUNTRY_YEARS, I_COUNTRY_YEARS
Evidence: E_COUNTRY_YEARS_READ

Preparation / proposed procedure:

1. Ask the authors for country_years.dta source/producer, country list, year endpoints and staging order.
2. Preserve the 1:1 countryisocode/year TCI merge and following author backfill.

Validation to perform later:

- Confirm key types, unique country-year rows and required country/year coverage.

### A_DB_PAYTAX: Recover the exact Paying Taxes workbook or its source-series mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DB_PAYTAX
Evidence: E_AUTHOR_PAYTAX, E_CTRY_WB, E_CTRY_WB_FIELDS, E_SAMPLE_MERGES, E_PUBLIC_DB_ARCHIVE, E_PUBLIC_DOING_BUSINESS

Preparation / proposed procedure:

1. Request the March 2022 machine-readable input or exact historical series mapping; do not infer fields from a different release.
2. Stage the workbook’s Data sheet with ISO2, year and the listed variables.

Validation to perform later:

- Check all fields, keys and country-year data before the country merge.

### A_WDI_MACRO: Obtain the four WDI indicator codes and exact macro-control input contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_WDI_MACRO
Evidence: E_AUTHOR_WDI, E_CTRY_CONTROLS, E_COUNTRY_CONTROLS_ANALYSIS, E_PUBLIC_WDI

Preparation / proposed procedure:

1. Request the author’s WDI codes, units and transformations for GDP growth, inflation, unemployment and GDP per capita.
2. Prepare countryisocode/year rows in country_controls.xlsx only after definitions are confirmed.

Validation to perform later:

- Confirm each field and required 2012–2019 sample-country coverage.

### A_WGI: Recover the author’s WGI 2023 workbook or exact variable crosswalk.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_WGI
Evidence: E_AUTHOR_WGI, E_CTRY_WGI, E_WGI_ANALYSIS, E_PUBLIC_WGI

Preparation / proposed procedure:

1. Request the September 2023 vintage or source-variable mapping for gee and pve, plus ISO2/year handling.
2. Do not substitute the recalculated current release without author-supported mapping.

Validation to perform later:

- Confirm iso2, year, gee and pve and required sample coverage.

### A_TCI: Recover the exact TCI download and its field/vintage contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TCI
Evidence: E_AUTHOR_TCI, E_CTRY_TCI, E_CTRY_TCI_MERGE, E_PUBLIC_TCI

Preparation / proposed procedure:

1. Request the February 2025 source file or exact public wave/vintage with country, countryisocode, year and TaxComplexityIndex.
2. Supply country_years separately and retain the author merge/backfill.

Validation to perform later:

- Check country-year uniqueness and years before backfill.

### A_HASSAN_RISK: Recover the author’s exact tax-policy-risk CSV vintage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HASSAN_RISK
Evidence: E_AUTHOR_RISK, E_CTRY_RISK, E_PUBLIC_RISK

Preparation / proposed procedure:

1. Request the August 2023 author file or exact documented public download matching firmquarter_2022q1.csv.
2. Confirm date/hqcountrycode/priskt_tax and preserve the country-year averaging code.

Validation to perform later:

- Check source history, country code conversion and required 2012–2019 observations.

### A_EATR: Recover the author’s cited EATR report table or original workbook.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EATR
Evidence: E_AUTHOR_EATR, E_CTRY_EATR, E_PUBLIC_EATR

Preparation / proposed procedure:

1. Request the exact cited European Commission 2020 table or eatr.xlsx, including EATR definition, country codes and report years.
2. Stage the wide country/year columns consumed by the supplied reshape.

Validation to perform later:

- Confirm country-year coverage and the reshaped countryisocode/year/EATR fields.

### A_COMP_GLOBAL: Stage the local Compustat Global candidate as the author-required CSV after confirming year and country coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_GLOBAL
Evidence: E_AUTHOR_COMPUSTAT, E_CTRY_COMP, E_COMP_GLOBAL_CATALOG, E_COMP_GLOBAL_PROBE

Preparation / proposed procedure:

1. Confirm the local COMP.G_FUNDA candidate covers 2012–2019 and the author FIC country set; the one-row probe only confirms field names.
2. Export fic, fyear, spi, pi, txpd and at to compustatglobal.csv.
3. Retain the author’s missing-spi rule and asset-weighted country-year ETR computation.

Validation to perform later:

- Check fields, fiscal years, FIC codes and countrycode/year/cash_etr_aggr output before merging.

### A_OECD_TAXADMIN: Recover the author’s OECD 2015 extraction workbook and exact report tables/years.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_OECD_TAXADMIN
Evidence: E_AUTHOR_OECD, E_CTRY_OECD, E_OECD_ANALYSIS, E_PUBLIC_OECD

Preparation / proposed procedure:

1. Request tax_enforcement_OECD.xls or exact table/page and extraction instructions, including country/year, verification_all, revenue denominator and units.
2. Do not substitute a later OECD survey or independently rebuild missing values.

Validation to perform later:

- Check country/year keys, selected survey year and the numerator/denominator used in analysis.

### A_IMF_DEBT: Confirm the exact IMF debt series, sector, unit and vintage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_IMF_DEBT
Evidence: E_AUTHOR_FISCAL, E_CTRY_DEBT, E_FISCAL_ANALYSIS, E_PUBLIC_IMF

Preparation / proposed procedure:

1. Request the IMF DataMapper series code and central-government definition/vintage used in government_debt_IMF.xlsx.
2. After identification, prepare countryisocode and annual government_debtIMF year columns for the supplied reshape.

Validation to perform later:

- Verify sector, units, country/year mapping and required period.

### A_WB_INTEREST: Acquire the author-specified World Bank interest series and prepare its expected workbook.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_WB_INTEREST
Evidence: E_AUTHOR_FISCAL, E_CTRY_INTEREST, E_FISCAL_MERGES, E_PUBLIC_INTEREST

Preparation / proposed procedure:

1. Use the named Interest payments (% of revenue) indicator as a candidate and preserve the author’s July 2025 vintage if available.
2. Confirm required sample-country years and map to the existing wide workbook contract.

Validation to perform later:

- Check 2012–2019 coverage, percent-of-revenue units and countryisocode3digit/year output.

### A_IMF_BALANCE: Confirm the exact IMF primary-balance series, sector, units and vintage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_IMF_BALANCE
Evidence: E_AUTHOR_FISCAL, E_CTRY_BALANCE, E_FISCAL_ANALYSIS, E_PUBLIC_IMF

Preparation / proposed procedure:

1. Request the author’s IMF DataMapper series code and definition for government primary balance, including sector, units and fiscal/calendar year.
2. Prepare countryisocode and annual primary_balanceIMF columns only after source identification.

Validation to perform later:

- Check required country/year coverage and primary-balance definition before merge.

### A_TAX_RATE_FILES: Request both author tax-rate spreadsheets and source crosswalk; preserve them as separate inputs.

Scopes: full_pipeline. Type: clarification. Certainty: blocked.
Addresses: R_TAX_RATE_ANN, R_TAX_RATE_ASEFFECTIVE, I_TAX_RATE_SCHEMA
Evidence: E_AUTHOR_TAX_RATES, E_TAX_ANN_INPUT, E_TAX_ANN_FORWARD_1, E_TAX_ANN_FORWARD_2, E_TAX_EFFECTIVE_INPUT

Preparation / proposed procedure:

1. Request announced/enacted and as-effective workbooks with per-country sources, event dates, rate definitions and update history through March 2025.
2. Stage countryisocode/year/anneffective_TR and countryisocode/year/effective_TR separately; let 0_3 create t+1/t+2 files.

Validation to perform later:

- Check unique country-year keys, rate definitions and forward-year coverage.

### A_PATH_SETUP: Map registered scripts into one working-copy root while preserving author sequence.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_PATH_SETUP
Evidence: E_README_MASTER, E_README_RUN_ORDER, E_MAIN_LOOP, E_CTRY_WB, E_WORK_ITEM_SOURCE_SCOPE

Preparation / proposed procedure:

1. Bind the existing directory globals consistently across registered preparation and analysis scripts.
2. Map master includes to registered sibling files; masked tokens prevent exact replacement proposals.
3. Preserve 0_1–0_4, then 1, 2 and the supplied stacked branch.

Validation to perform later:

- Review all input/output mappings as a coherent set and confirm registered includes resolve before an authorized run.

### A_SOFTWARE_SETUP: Prepare required Stata commands reported unavailable.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR2, SW_OUTREG2
Evidence: E_ENVIRONMENT, E_SOFTWARE_WINSOR_SOURCE, E_SOFTWARE_OUTREG_SOURCE, E_README_SSC

Preparation / proposed procedure:

1. Before a separate authorized run, confirm winsor2 and outreg2 in the intended Stata environment and use the author-documented SSC setup if still unavailable.
2. Assess Stata 18 compatibility with the documented Stata 19 without changing estimators.

Validation to perform later:

- Record exact package/runtime versions and command availability; do not modify the authored analysis.


## Remaining issues and prerequisites

- I_COUNTRY_YEARS [unresolved; full_pipeline]: The country-level program reads country_years.dta as the master for a 1:1 countryisocode/year TCI merge. Its producer and required period/coverage contract remain unresolved for this assessment.
- I_PATH_SETUP [preparation; full_pipeline]: The ordered author workflow uses directory macros to locate its inputs and registered sibling do-files. A consistent working-copy root and mapping of those inputs/includes must be configured before a run.
- I_TAX_RATE_SCHEMA [unresolved; full_pipeline]: The authors describe separate announced/enacted and as-effective spreadsheets with later updates, but the exact files, country-level source map, effective-date rules and workbook vintage are not supplied. Forward-year files are generated from the announced/enacted source.
- R_ORBIS_MAIN [undetermined]: Required 504-file main Orbis firm extract, selected by the author’s documented active-status, geography, company-type, financial-history and ultimate-owner criteria. The code keys by bvdidnumber, filters status and NACE, reshapes wide financial fields into 2012–2019 firm-year rows, drops 2020 onward and retains firms with seven observations. Required variable families include employees, fixed and intangible/tangible assets, cash, total assets, current/noncurrent liabilities, sales, operating profit, pretax profit, tax, net income, employee costs, loans, cost of goods sold and long-term debt; depreciation is supplied through the separate pull. The packaged CSV contains BvD identifiers only.
- R_ORBIS_ADDITIONAL [undetermined]: Separate required supplemental Orbis extract imported by 0_1 and merged to the main sample on bvdidnumber. It contains 37 numbered files, with depreciation fields renamed for 2012–2021; the final primary reshape also consumes long-term debt. The exact supplemental raw long-term-debt labels remain to check.
- R_COUNTRY_YEARS [undetermined]: Required country_years.dta master for the 1:1 countryisocode/year TCI merge and backfill. The readable workflow does not identify its producer or year endpoints.
- R_DB_PAYTAX [undetermined]: Required world_bank_final.xlsx Data sheet from the World Bank Doing Business Paying Taxes source. Keys ISO2/year; 0_2 destrings the listed fields and the primary analysis consumes Paying Taxes measures. Exact author workbook and source-series mapping are missing.
- R_WDI_MACRO [undetermined]: Separate author-prepared country_controls.xlsx from WDI. Analysis uses GDP growth, inflation, unemployment and GDP per capita; keys are countryisocode/year. Exact indicator codes, units and workbook vintage are not supplied.
- R_WGI [undetermined]: Separate wgi.xlsx country-year input. Code renames iso2 to countryisocode; analysis uses gee and pve. Author downloaded the September 2023 vintage; current WGI values are not silently substituted.
- R_TCI [undetermined]: Separate tax_complexity_index.xlsx, Original Data sheet, with country/countryisocode/year/TaxComplexityIndex. Author code joins this source to country_years.dta, backfills within country and writes the analysis field.
- R_HASSAN_RISK [undetermined]: Separate firmquarter_2022q1.csv from Hassan et al. The code consumes date/hqcountrycode/priskt_tax, derives year, computes country-year mean tax risk, and merges mean_taxriskyear.
- R_EATR [undetermined]: Separate eatr.xlsx from the EC report cited as final_report_2020_effective_tax_levels_revised_en.pdf / Spengel et al. (2020). Code reshapes country-wide EATR years to countryisocode/year; analysis consumes EATR.
- R_COMP_GLOBAL [undetermined]: Compustat Global annual fundamentals. Author code consumes fic/fyear/spi/pi/txpd/at, filters its listed FIC countries, sets missing spi to zero and computes asset-weighted country-year cash ETR.
- R_OECD_TAXADMIN [undetermined]: Separate tax_enforcement_OECD.xls manually extracted from OECD Tax Administration 2015. Required fields include countryisocode/year, verification_all and taxrevenuecollectedinmillio; analysis uses their ratio.
- R_IMF_DEBT [undetermined]: Separate government_debt_IMF.xlsx. Code reshapes countryisocode and wide government_debtIMF year columns to countryisocode3digit/year; datasheet identifies central-government gross debt.
- R_WB_INTEREST [undetermined]: Separate interest_expense_WorldBank.xlsx from the named World Bank Interest payments (% of revenue) series. Code reshapes country/year and analysis consumes interest_expense.
- R_IMF_BALANCE [undetermined]: Separate primary_balance_IMF.xlsx from IMF DataMapper. Code reshapes country/year fields; analysis consumes primary_balanceIMF. Datasheet identifies government primary balance; exact sector and units must match.
- R_TAX_RATE_ANN [undetermined]: Separate author-prepared corporate_tax_rates_announced_enacted source. Required fields countryisocode/year/anneffective_TR. The same source generates one- and two-year forward intermediates; authors describe multi-source public collection and updates through March 2025.
- R_TAX_RATE_ASEFFECTIVE [undetermined]: Distinct author-prepared corporate_tax_rates_aseffective source, required as countryisocode/year/effective_TR for the country-year merge. It is not an alternative to announced/enacted rates.
- SW_WINSOR2 [preparation_required]: Preparation code invokes winsor2; typed environment metadata reports it unavailable. No installation was performed.
- SW_OUTREG2 [preparation_required]: Primary analysis invokes outreg2; typed environment metadata reports it unavailable.

## Review notes

- The registered entry point is 0_master.do. README supports ordered preparation, the primary analysis and the separate secondary stacked DiD branch; both remain in full_pipeline.
- primary_sample_BVD_IDs.csv is an identifier-only retrieval aid, not the Orbis financial dataset or an author-prepared analysis panel; no analysis_only scope is supported.
- The main Orbis and supplemental Orbis pulls are separate jointly required inputs. The supplemental producer is supplied and is joined on BvD identifiers; no raw-file alternatives were invented.
- Targeted frozen-catalog queries identify one local Compustat Global candidate. A one-row probe confirms its six fields but not fiscal-year or country coverage. Catalog misses for other named products are not access-barrier evidence.
- No author program, statistical model, SAS startup, installation or data download was run.
- Process limitation: the approved source viewer left some master/country setup ranges unread. This is recorded as coverage context only; it is not evidence that code, an input producer, or data are absent.
