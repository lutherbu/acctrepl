# Patch proposal: jar-dd3731e0fe21

International Mergers and Acquisition Laws, the Market for Corporate Control and Accounting Conservatism

DOI: 10.1111/1475-679X.12247

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied-code workflow from KW2018_SASCODE1.sas through KW2018_SASCODE2.sas and the documented Stata handoff: law-country sample creation, Global daily-return and control construction, country inputs, and the final DID/event-study exports. The appendix documents separate SDC, DealScan, and Capital IQ analyses, but no companion analysis programs are supplied; their executable input requirements remain undetermined pending the missing handoff materials.

Entry points: `KW2018_SASCODE1.sas`, `KW2018_SASCODE2.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 1/12247 - International-Mergers-and-Acquisition-Laws-the-Market-for-Corporate-Control-and-Accounting-Conservatism/kw-datasheet-and-code.zip",
      "sha256": "f9ba22792318e899c8a1250343da35a32f82a04e9b6f387fe4051363cf2cbe3c"
    },
    {
      "path": "JAR-Volume 57/Issue 1/12247 - International-Mergers-and-Acquisition-Laws-the-Market-for-Corporate-Control-and-Accounting-Conservatism/kw-online-appendix.pdf",
      "sha256": "dbab9da04e95b60a39b189479ad8b98f8934ffb88a2ddba39d30a4c3a892a23a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "8232aac5625beb096b4b64319b5d1adc63dd1dae5ddb34272cdd733f2d7ff39e"
}
```

## Proposed actions

### A001: Obtain the missing author country inputs and prepared-file specifications for the supplied SAS workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I001, R001, R006, R007, R008, R009, R010, R011, R012, R013, R014, R015, R016
Evidence: E006, E021, E022, E023, E024, E025, E026, E027, E028, E029, E030, E047, E048, E049, E050

Preparation / proposed procedure:

1. Request the exact takeover-law, GDP-per-capita, Economic Freedom, financial-reform, insider-trading, short-selling, and EPL inputs or author-specified source/series, including field names, units, country keys, years, and any crosswalks. Ask which financial-reform release/series is intended: the datasheet cites Abiad (2010), CODE2 comments cite Abiad (2012), and the filename says Dec 2008; those labels alone do not establish different data vintages.
2. Request the prepared `c.takeoverprovision`, `c.nontakeoverprovision`, `a.cons_item`, `a.sga`, and `a.accrual_cf` files or their author producers, with exact field definitions, identifier/year mappings, source vintage, filters, and construction history. For Worldscope, the author mapping to gvkey, country splits, and PROBD construction must be specified.
3. Do not independently reconstruct these author intermediates; preserve the enacting and nonenacting inputs as separate requirements.

Validation to perform later:

- Compare each delivered workbook or prepared file to its exact CODE2 import/read, required fields and key joins; confirm the years and country/firm coverage used by the supplied sample and rolling/lead windows before running.

### A002: Configure the known author-specific library, workbook, and output paths consistently; retain only the specific Global history and matching-key checks that current evidence does not establish.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I003, R002, R003, R004, R005
Evidence: E007, E008, E009, E010, E011, E012, E013, E014, E015, E016, E031, E032, E035, E036, E039, E040, E041, E042, E046

Preparation / proposed procedure:

1. Set the same writable `a` library location in CODE1 and CODE2 so the two country datasets produced by CODE1 are consumed in CODE2. Bind the supplied `b` reads to the catalogued local Compustat Global Fundamentals, Names, Security Daily, and currency tables where their schemas and paths match; configure `c` only after the Worldscope producer/mapping is supplied.
2. After the missing country workbooks are obtained, replace the hardcoded author-specific input and export locations with consistent local paths and confirm output directories exist. Retain the Code1-before-Code2 order and all takeover/non-takeover remote branches.
3. Use the local Global products as supported candidates where documented fields match. Before relying on the Fundamentals, Security Daily, and monthly FX tables, check the needed annual years, sample identifiers/security linkage, daily windows, and currency/date pairs; do not require author-vintage byte identity or a full-file sweep.

Validation to perform later:

- Confirm configured tables resolve to the documented products and fields. Validate only the code-relevant gvkey/fyear years, security identifiers/date windows, and currency/date pairs needed by the supplied joins; no full-data sweep or author-snapshot identity is a prerequisite.

### A003: Resolve local SAS startup and confirm the SAS capabilities used by the supplied imports, exports, and remote Global-data branches.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW001, SW002, SW003
Evidence: E006, E013, E014, E031, E032, E037, E038, E045, E051, E054

Preparation / proposed procedure:

1. After correcting or configuring the local SAS environment, confirm the SAS 9.4 runtime starts. PROC UNIVARIATE is covered under the core SAS requirement; no separate SAS/STAT dependency is asserted.
2. Confirm the installed SAS/ACCESS PC Files engines support the workbook imports and required export formats, and confirm SAS/CONNECT plus the user’s intended WRDS session for signon/rsubmit/upload/download. The startup failure does not establish a missing license or account.

Validation to perform later:

- Use a minimal local capability check for the required SAS procedure and import/export engines, then verify the WRDS remote session and transfers only after credentials and access are configured; do not launch the author programs until these checks pass.

### A004: Obtain the missing Stata handoff and companion analysis materials before determining downstream paper inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I002
Evidence: E005, E031, E032, E033, E034, E044, E052, E053

Preparation / proposed procedure:

1. Request the author Stata programs and a map from the supplied `total.dta` and `event.dta` exports to every reported table and figure.
2. For the appendix SDC merger-activity, DealScan loan, and Capital IQ CEO compensation analyses, request any companion drivers, exact prepared inputs, and their fields/keys/periods; confirm whether those analyses are part of the intended deliverable. The appendix descriptions alone do not make these live inputs to the supplied SAS files.

Validation to perform later:

- Trace each received analysis entry point to its exact input files and outputs. Only then add downstream requirements for any appendix branch that the supplied companion workflow actually consumes.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: CODE2 reads two Worldscope provision subsets and three custom Compustat Global intermediates that are not in the package and have no supplied producers. For Worldscope, the local raw table probe shows item/year identifiers but does not establish a gvkey mapping or the author-prepared country splits and PROBD construction. These remain separate input requirements.
- I002 [unresolved; full_pipeline]: The two supplied SAS programs create final DID and event-study datasets and export them for Stata, but the package contains no Stata regression programs or output-to-table/figure map. The packaged DTA is an identifier list, not full analysis data. The appendix also documents DealScan, Capital IQ, and SDC analysis branches whose detailed inputs are not mapped by the supplied scripts.
- I003 [preparation; full_pipeline]: Both SAS files hardcode author-specific library roots and external workbook/export paths. The `a` library must resolve to the same writable directory in CODE1 and CODE2 for the generated takeovercountry datasets to be consumed; all input and output paths need a coherent project configuration.
- R001 [undetermined]: Author M&A law workbook `international takeover acts.xlsx` with countrycode and takeoverlaw_year for enacting and nonenacting countries.
- R002 [undetermined]: Compustat Global Fundamentals Annual `g_funda` for sample construction, Basu measures, controls, and real-effects variables read by the supplied CODE1/CODE2 programs.
- R004 [undetermined]: Compustat Global Security Daily `g_secd` for fiscal-year daily returns, market capitalization, and lagged volatility.
- R005 [undetermined]: Compustat Global Exchange Rate Monthly `g_exrt_mth` used to convert assets into USD before size construction.
- R006 [undetermined]: World Bank GDP-per-capita country-year input imported from `GDP per capita.xlsx`, lagged by country and used to form gdpgrowth.
- R007 [undetermined]: Economic Freedom of the World workbook from the 2014 Annual Report, used for judicial impartiality and state-owned-enterprise measures.
- R008 [undetermined]: Abiad financial-reform country-year index imported from `Financial Reform Dataset Dec 2008.xls`, sheet Data.
- R009 [undetermined]: Country-level insider-trading enforcement-year input imported from `international data.xlsx`.
- R010 [undetermined]: Country-year short-selling regulation input imported from `Short selling.xlsx`.
- R011 [undetermined]: OECD employment-protection indicator workbook, `EPL-timeseries.xlsx`, sheet `Summary indicators`.
- R012 [undetermined]: Author-prepared `c.takeoverprovision` firm-year input used for PROBD in enacting countries.
- R013 [undetermined]: Author-prepared `c.nontakeoverprovision` firm-year input used for PROBD in nonenacting countries.
- R014 [undetermined]: Author-prepared Compustat Global `a.cons_item` intermediate with gvkey, fyear, spi_mv, and accxp_sale.
- R015 [undetermined]: Author-prepared Compustat Global `a.sga` intermediate with gvkey, fyear, and sga.
- R016 [undetermined]: Author-prepared Compustat Global `a.accrual_cf` intermediate with gvkey, fyear, accrual1, chgcfo1, and accrual2.
- SW001 [unverified]: Both supplied entry programs require SAS, including the Base SAS procedure used by CODE2 for PROC UNIVARIATE. The bounded SAS 9.4 environment startup probe failed during TKELS initialization; availability of the runtime is unverified, and the failure does not establish a missing license.
- SW002 [unverified]: CODE2 uses signon, remote=WRDS, rsubmit, PROC UPLOAD and PROC DOWNLOAD. Availability of SAS/CONNECT and a working WRDS session is not established.
- SW003 [unverified]: The supplied programs import XLS and XLSX workbooks and export Stata files. The required local SAS interface/engine availability was not established because the bounded SAS startup probe failed.

## Review notes

- Read the complete frozen datasheet, both SAS source files, online appendix, static audit, product catalog, bounded Global and Worldscope probes, packaged identifier-file metadata, environment probe, and all 28 frozen dependency checklist items. Bounded table probes support product/field matches; they do not establish the specific annual, daily, or currency/date coverage still called out for Global Fundamentals, Security Daily, and monthly FX. The Names lookup is verified for its gvkey/SIC use and has no year-history requirement.
- The assessed executable boundary is the supplied CODE1→CODE2 workflow and its Stata handoff. Appendix SDC, DealScan, and Capital IQ analyses are documented, but the package has no companion drivers or mapping; the sources remain contextual handoff leads rather than mandatory inputs to the supplied SAS branch.
- The packaged firm/year DTA is an identifier list rather than analysis data, so no analysis-only scope is supported. Author wording that data were public or purchased does not establish current access or a license barrier.
