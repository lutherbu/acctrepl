# Patch proposal: jar-5c0d5d557dc2

Facial Structure and Achievement Drive: Evidence from Financial Analysts

DOI: 10.1111/1475-679X.12259

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied SAS sample and variable-preparation workflow, preserving all main-sample and subsample construction branches through the generated analysis-ready WORK tables.

Entry points: `HYZZZ JAR_2018.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 4/12259 - Facial-Structure-and-Achievement-Drive-Evidence-from-Financial-Analysts/hyzzz-datasheet-and-code.zip",
      "sha256": "8fbe4c6a3ca3b3f33b25d0d9e8321cf9e271c9fd518a204fb5131ccdbb2e5563"
    },
    {
      "path": "JAR-Volume 57/Issue 4/12259 - Facial-Structure-and-Achievement-Drive-Evidence-from-Financial-Analysts/hyzzz-online-appendix.pdf",
      "sha256": "f28625b6295964c83095f237a2c183615bbdd5733fb33d595b1e4d21bdb1399c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "3ae19128a0373ab99fee53ca4e3e15fdf0814a63a8808ae3f1206fddda735e53"
}
```

## Proposed actions

### ACT01: Verify authorized access to the author-documented CBAS/CNRDS products or obtain compatible author-prepared tables for the forecast, actual-earnings, analyst-basic, and broker-financial inputs. Keep these Chinese analyst products distinct from US I/B/E/S and Compustat files.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ01, REQ04, REQ07, REQ08
Evidence: E006, E007, E010, E012, E020, E025, E027

Preparation / proposed procedure:

1. Confirm the exact CBAS/CNRDS product and prepared-file variant for annual analyst forecasts, actual earnings, analyst basics, and broker financial data; current entitlement and local availability remain unknown.
2. Supply or map the forecast input fields a_code, s_code, fpenddt, anndats, anndats_act, feps, and b_code; preserve the code filter on forecast period end years 2004–2014.
3. Supply actuals keyed by s_code and fpenddt with eps_act, and broker assets with b_code, date, source, and t_assets.
4. Include the earlier announcement year needed by the prior-year coverage branch; ayear is derived from anndats and is not established by the fpenddt filter.
5. Supply analyst basic fields a_code, sex, high_degree, and birth_year with documented population coverage. Do not treat a catalog miss as evidence of absent license.

Validation to perform later:

- Use bounded schema/readability checks on each product and compare exact source/region, identifiers, date semantics, expected fields, and required period coverage before a separately authorized SAS attempt.

### ACT02: Verify authorized access to the separate CSMAR products and obtain compatible prepared inputs or source-to-input mappings for prices, industry, balance sheet, cash flow, IPO/listing dates, R&D, and annual market sentiment.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ05, REQ06, REQ10, REQ11, REQ12, REQ13, REQ14
Evidence: E008, E009, E014, E015, E016, E017, E019, E025

Preparation / proposed procedure:

1. Check current local entitlement and identify the exact Chinese CSMAR product/release for each required table; no CSMAR substitute is verified by the frozen catalog.
2. Keep daily prices, annual industry records, balance-sheet statements, cash-flow statements, IPO/listing dates, R&D expense, and market-sentiment inputs as separate jointly required products. Do not substitute US Compustat or US return products.
3. Provide the code-facing fields and transformations: daily stock/date/close price; annual stock/accounting-period/report-type/industry code; balance-sheet A004000000; cash-flow C001000000; listing date; cleaned stock/year/R&D; and year/bull.
4. For the five-prior-year volatility branch, provide matched balance-sheet and cash-flow fiscal years ayear−6 through ayear−1 after the code’s one-year join. Confirm the earliest ayear from the actual forecast panel rather than inferring it from the forecast-period-end filter.
5. Provide daily prices from 20 to 2 days before each forecast issue date (andat−20 through andat−2), retaining the nearest eligible prior observation by minimum date difference; also provide annual December industry records and all sample firms’ listing dates.

Validation to perform later:

- Run bounded schema checks against each distinct product and confirm matching identifiers/report types/date windows, complete required history, and the documented source-to-SAS field mapping.

### ACT03: Resolve the prepared analyst-measurement, identity-crosswalk, and title-interval contracts using existing author-prepared materials where possible.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ02, REQ03, REQ09, ISS02, SOF03
Evidence: E003, E013, E020, E023

Preparation / proposed procedure:

1. Treat analyst_fwhr.xls as supplied partial prepared information. Ask for its field/header specification and the author-prescribed transformation into the SAS-facing a_code, whr, and lowquality fields, or a compatible prepared table already containing those fields.
2. Clarify the manual name/work-experience crosswalk to CBAS a_code and its required population coverage. A verified prepared route can bypass historical SAC photo retrieval and ImageJ measurement; do not make new image collection or measurement a prerequisite.
3. Obtain the prepared fwhr.title table or its supported author preparation specification with a_code, startdate, enddate, and highstatus covering the forecast issue dates.
4. Identify the spreadsheet/manual matching tool only if a prepared, already-linked input does not bypass that stage. No individual rows or measurement values are needed for this schema clarification.

Validation to perform later:

- Use a header-only or otherwise bounded schema inspection to confirm each prepared table’s exact fields, date types, keys, and coverage; do not inspect person-level values for this assessment.

### ACT04: Resolve the active winsor include with the original macro or a documented compatible provider; preserve the authored macro call and data semantics.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS01
Evidence: E011

Preparation / proposed procedure:

1. Obtain winsor.txt or a documented compatible SAS macro implementation that accepts the called dsetin/dsetout/byvar/vars/type/pctl arguments.
2. Confirm the implementation preserves no-grouping behavior (byvar=none), applies the stated 1st/99th percentile treatment to the listed variables, and leaves the same forecast table structure.
3. A byte-identical original winsor.txt is not required if the provider semantics and compatibility are documented.

Validation to perform later:

- Before a separately authorized workflow run, confirm the macro resolves and its documented interface and percentile semantics match the call at line 283.

### ACT05: Replace every hard-coded Windows data/library/include path with one coherent relative inputs/ directory, then run from the folder containing the edited SAS program through the documented host batch wrapper.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS03
Evidence: E007, E009, E011, E012, E014, E016, E028

**Proposed edit:** `HYZZZ JAR_2018.sas:13–13`
Source SHA-256: `855de1709fe4e73ca95cf9a6fbb5cf49f1e547a5801897cf7e42ac9333afa06c`

Map the permanent fwhr SAS datasets to one coherent host-visible relative input directory.

Current text:
```
libname fwhr "[redacted-path-b97940cf325c]";
```

Proposed replacement:
```
libname fwhr "inputs";
```

**Proposed edit:** `HYZZZ JAR_2018.sas:63–63`
Source SHA-256: `855de1709fe4e73ca95cf9a6fbb5cf49f1e547a5801897cf7e42ac9333afa06c`

Use the same relative inputs directory for the CBAS actual-earnings workbook.

Current text:
```
datafile="[redacted-path-ecc03db8733a]" /*the dataset including actual earnings from CBAS*/
```

Proposed replacement:
```
datafile="inputs/actual.xlsx" /*the dataset including actual earnings from CBAS*/
```

**Proposed edit:** `HYZZZ JAR_2018.sas:222–222`
Source SHA-256: `855de1709fe4e73ca95cf9a6fbb5cf49f1e547a5801897cf7e42ac9333afa06c`

Keep the CSMAR industry DBF under the same relative input root.

Current text:
```
datafile='[redacted-path-1a8f2c25688f]'/*dataset including industry code from CSMAR*/
```

Proposed replacement:
```
datafile='inputs/FI_T1.dbf'/*dataset including industry code from CSMAR*/
```

**Proposed edit:** `HYZZZ JAR_2018.sas:352–352`
Source SHA-256: `855de1709fe4e73ca95cf9a6fbb5cf49f1e547a5801897cf7e42ac9333afa06c`

Keep the CBAS broker workbook under the same relative input root.

Current text:
```
datafile="[redacted-path-f3e325003b15]" /*dataset including financial information of brokerage firms from CBAS*/
```

Proposed replacement:
```
datafile="inputs/Broker_financial.xlsx" /*dataset including financial information of brokerage firms from CBAS*/
```

**Proposed edit:** `HYZZZ JAR_2018.sas:420–420`
Source SHA-256: `855de1709fe4e73ca95cf9a6fbb5cf49f1e547a5801897cf7e42ac9333afa06c`

Keep the distinct CSMAR balance-sheet file under the same relative input root.

Current text:
```
datafile='[redacted-path-de84bbcb7c23]'/*dataset including financial data from balance sheet of listed firms from CSMAR*/
```

Proposed replacement:
```
datafile='inputs/FS_COMba.dbf'/*dataset including financial data from balance sheet of listed firms from CSMAR*/
```

**Proposed edit:** `HYZZZ JAR_2018.sas:426–426`
Source SHA-256: `855de1709fe4e73ca95cf9a6fbb5cf49f1e547a5801897cf7e42ac9333afa06c`

Keep the distinct CSMAR cash-flow file under the same relative input root.

Current text:
```
datafile='[redacted-path-4408ce86000d]'/*dataset includingfinancial data from cash flow statement of listed firms from CSMAR*/
```

Proposed replacement:
```
datafile='inputs/FS_COMSC.dbf'/*dataset includingfinancial data from cash flow statement of listed firms from CSMAR*/
```

**Proposed edit:** `HYZZZ JAR_2018.sas:461–461`
Source SHA-256: `855de1709fe4e73ca95cf9a6fbb5cf49f1e547a5801897cf7e42ac9333afa06c`

Keep the CSMAR IPO file under the same relative input root.

Current text:
```
datafile='[redacted-path-0f31edbb4efc]'/*dataset including IPO characteristics from CSMAR*/
```

Proposed replacement:
```
datafile='inputs/IPO_Cobasic.xlsx'/*dataset including IPO characteristics from CSMAR*/
```

**Proposed edit:** `HYZZZ JAR_2018.sas:282–282`
Source SHA-256: `855de1709fe4e73ca95cf9a6fbb5cf49f1e547a5801897cf7e42ac9333afa06c`

Use the same relative input root for the supplied or documented compatible winsor macro.

Current text:
```
%include "[redacted-path-bef23e322d90]";
```

Proposed replacement:
```
%include "inputs/winsor.txt";
```

Preparation / proposed procedure:

1. Create the future authorized run’s inputs/ directory adjacent to the SAS program and place the verified fwhr SAS datasets, direct-import files, and compatible macro there while preserving separate source products.
2. Run the SAS host wrapper in batch mode from the program directory, with no absolute Dropbox path in executable configuration.

Validation to perform later:

- Review that the libname, all PROC IMPORT datafile paths, and the macro include resolve to the same directory structure and preserve their exact basenames before any separately authorized run.

### ACT06: Confirm the actual SAS runtime and required import capability on the authorized host; do not infer absent licensing from the existing TKELS startup failure.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SOF01, SOF02, SOF03
Evidence: E001, E024, E026

Preparation / proposed procedure:

1. Confirm the SAS 9.4 runtime version and successful batch startup through the documented host wrapper. The existing probe’s TKELS failure leaves availability unverified.
2. Confirm local SAS/ACCESS Interface to PC Files capability for the active DBMS=XLSX, EXCEL, and DBF imports, including DBMS=EXCEL with the supplied .xlsx extension, on the actual host platform.
3. Confirm the spreadsheet/manual tool only if the existing prepared fWHR/title tables do not bypass manual matching. The supplied DATA steps and PROC SQL/SORT/MEANS do not establish SAS/STAT use.

Validation to perform later:

- Record observed SAS version and module/engine availability from supported installation or runtime metadata before the workflow run; retain an explicit compatibility gap if the exact DBMS identifiers remain unverified.

### ACT07: After compatible data, macro, paths, and software are verified, run the supplied preparation program in its source order and inspect its actual generated tables.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ01, REQ02, REQ03, REQ04, REQ05, REQ06, REQ07, REQ08, REQ09, REQ10, REQ11, REQ12, REQ13, REQ14, ISS01, ISS02, ISS03, SOF01, SOF02
Evidence: E001, E004, E006, E008, E011, E015, E018, E019

Preparation / proposed procedure:

1. Keep the authored order: import/prepare forecast and actual data; join fWHR and prices; derive announcement dates, accuracy inputs, and forecast controls; apply the compatible winsor macro; then execute the broker, title, cash-flow, IPO, R&D, coverage, and market-sentiment subsample branches.
2. Run only HYZZZ JAR_2018.sas through the SAS batch wrapper after each input and include is resolved; preserve all supplied branches.
3. The program generates temporary WORK tables, including the final forecast table with constructed variables. No persistent export or paper-wide estimation stage is supplied; if a later authorized consumer needs the table beyond the SAS session, preserve it using an explicit run-output configuration without adding new analyses.

Validation to perform later:

- Confirm all 14 frozen dependency IDs are accounted for, the final WORK.FORECAST schema and every supplied subsample variable are present, and the SAS log contains no unresolved input/include/import failures. This is a future validation instruction; no author code was run in this audit.


## Remaining issues and prerequisites

- ISS01 [unresolved; full_pipeline]: The active %include points to winsor.txt, which is absent from the supplied package, and the following statement invokes %winsor. The exact original bytes are not mandatory if a documented compatible provider preserves the called variables, no-grouping behavior, and 1st/99th percentile semantics; the macro source/semantics must be confirmed before running.
- ISS02 [unresolved; full_pipeline]: The SAS input fwhr.fwhr requires a_code, whr, and lowquality. The packaged analyst_fwhr.xls is only partially inspectable by header metadata and does not expose a verified mapping to these fields; the analyst-ID crosswalk and quality-field contract remain unresolved. This does not require collecting or measuring new photos if an existing prepared route can supply the compatible input.
- ISS03 [preparation; full_pipeline]: The SAS library and direct input/include statements use the Windows path [redacted-path-e54a9fbe816b] JAR. A future batch attempt needs one coherent host-visible relative or [redacted-path-9f221af0c260] root mapped consistently across the library, every PROC IMPORT input, and the macro include.
- REQ01 [undetermined]: CBAS-derived annual analyst forecast panel consumed as fwhr.forecast; includes the analyst-firm-period fields used to form the sample and forecasting covariates.
- REQ02 [undetermined]: Prepared analyst fWHR and picture-quality table joined to the forecast panel as fwhr.fwhr.
- REQ03 [undetermined]: Manual analyst identity crosswalk linking the prepared fWHR records to CBAS analyst IDs using names and work experience, if those identifiers are not already present in a compatible prepared table.
- REQ04 [undetermined]: Actual earnings input imported as actual.xlsx and joined by stock code and forecast-period end date.
- REQ05 [undetermined]: Daily share-price input fwhr.price for the forecast-accuracy construction.
- REQ06 [undetermined]: Industry-classification input FI_T1.dbf used for annual December industry assignment.
- REQ07 [undetermined]: Analyst basic-information input fwhr.basic, including the CBAS and manual fields used in sample filtering and covariate construction.
- REQ08 [undetermined]: Broker financial input Broker_financial.xlsx used to construct lagged brokerage assets for the subsample branch.
- REQ09 [undetermined]: Manually cleaned analyst title intervals in fwhr.title for the title-status subsample branch.
- REQ10 [undetermined]: CSMAR annual balance-sheet input FS_COMba.dbf used to scale the cash-flow field and construct cash-flow volatility.
- REQ11 [undetermined]: CSMAR annual cash-flow input FS_COMSC.dbf joined to the balance-sheet input for cash-flow volatility.
- REQ12 [undetermined]: CSMAR IPO/listing-date input IPO_Cobasic.xlsx for firm age and treatment of young firms in the volatility branch.
- REQ13 [undetermined]: Author-cleaned CSMAR-derived research and development expense input fwhr.rd.
- REQ14 [undetermined]: Annual CSMAR-derived market-sentiment input fwhr.mktsentiment used in the subsample branch.
- SOF01 [unverified]: The supplied preparation file uses SAS DATA steps and PROC SQL, SORT, MEANS, and IMPORT. The available SAS 9.4 command did not initialize in the existing probe; runtime and Base SAS availability remain unverified, not evidence of absent entitlement. No SAS/STAT estimator dependency is observed in the supplied source.
- SOF02 [unverified]: The active import steps use DBMS=XLSX, EXCEL, and DBF. SAS 9.4 Linux documentation lists Excel and dBase file formats under SAS/ACCESS Interface to PC Files; this local component and exact DBMS=EXCEL-on-XLSX compatibility are unverified.
- SOF03 [unverified]: The datasheet documents manual matching of the analyst measurement records to CBAS IDs by names and work experience. It does not name the spreadsheet or matching software. A compatible author-prepared linked table could bypass this manual stage.

## Review notes

- Scope is the complete supplied sample/variable-preparation program and every provided main/subsample branch. The appendix and datasheet describe paper-wide estimations, but no estimator or results-export stage follows the final preparation marker; those absent analyses are contextual and are not added as mandatory stages or an analysis-only scope.
- The packaged analyst_fwhr.xls is credited as partial prepared information. Its first two physical rows do not expose fields matching the code contract; the required a_code, whr, and lowquality mapping remains unverified. A compatible existing prepared-data route may bypass historical SAC photo acquisition and ImageJ measurement; no new image collection is required by this assessment.
- The packaged firm identifier workbook is an auxiliary S_code list, not a forecast panel or full analyst-level analysis input.
- Frozen catalog misses for Chinese products do not establish unavailable entitlement. US I/B/E/S and Compustat candidates are not treated as substitutes for CBAS/CNRDS or CSMAR products.
- Code sources are kept distinct: CBAS/CNRDS analyst forecasts and related products, CSMAR financial/price inputs, and author-cleaned manual tables. Every supplied subsample branch remains in target scope.
- The missing winsor.txt include is a requirement for compatible macro semantics, not a byte-identical original file. A documented compatible provider can satisfy it if the called arguments and 1/99 percentile behavior match.
- The SAS 9.4 startup probe did not initialize TKELS, so runtime and SAS/ACCESS component availability remain unverified rather than blocked or unlicensed.
- The program writes its preparation outputs as temporary WORK tables and has no persistent export call. This is reported as the actual output boundary; no missing exporter or regression driver is made a mandatory issue for the supplied preparation target.
