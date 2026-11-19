# Patch proposal: jar-27b2759740c8

Federal Judge Ideology: A New Measure of Ex-Ante Litigation Risk

DOI: 10.1111/1475-679X.12260

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied SAS workflow: all raw-input preparation, required support macros, construction, main analyses, earnings-guidance/8-K branch, and Table 9B/9C branches in HHL_SAS_Code.sas. The final-sample identifier CSV is not a compatible bypass. The online appendix is retained as output-scope context; no separate appendix program is listed in the bounded package inventory.

Entry points: `HHL_SAS_Code.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 2/12260 - Federal-Judge-Ideology-A-New-Measure-of-Ex-Ante-Litigation-Risk/hhl-datasheet-and-code.zip",
      "sha256": "331250facd98b204a4b5f6771fabf5da49f4f263b97c2e4169c13851eba001d4"
    },
    {
      "path": "JAR-Volume 57/Issue 2/12260 - Federal-Judge-Ideology-A-New-Measure-of-Ex-Ante-Litigation-Risk/hhl-online-appendix.pdf",
      "sha256": "a58217770cb66dc05108b4789718cea7232a6f6af114f795f665c972dc2373c8"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "31fa9a599d56c0de8606d96560e860cb8b0a70e5fec07dae66f1720faf79b190"
}
```

## Proposed actions

### A_SUPPORT_CODE: Obtain or identify the referenced SAS helper definitions and verify their documented input/output contracts against every consumer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SUPPORT_CODE, I_IO_TIMESERIES
Evidence: E_SUPPORT_INCLUDE, E_CCM_INCLUDE, E_IO_INCLUDE, E_IBES_CONTRACT, E_EIK_BRANCH, E_APPOINTMENT_MACRO

Preparation / proposed procedure:

1. Provide the exact author versions of winsor.sas, ccm.sas, io_ts.sas, iccmlink.sas, and evtstudy08.sas, or identify a documented provider implementation and demonstrate that its algorithms, input/output fields, sample filters, history windows, and output naming match the supplied calls.
2. Trace each supplied or demonstrated compatible definition from its inputs through generated datasets, fields, sample filters, and history rules to every consumer, including the Table 9C event-study naming convention.

Validation to perform later:

- Perform a read-only source/contract review of each exact or demonstrably compatible helper definition and close its include edge to every consumer before any authorized run.

### A_DATA_UNRESOLVED: Resolve each remaining raw, manual, SEC-derived, or vendor input against its exact author file/product, field contract, period, units/measure, access route, and construction steps. Keep distinct source files as separate requirements.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ELECTIONS, R_FJC_HISTORY, R_SENATE_HISTORY, R_SEC_HQ_INDEX, R_ZIP_DISTRICT, R_SCAC_CASES, R_SCAC_CLASSIFICATION, R_SCAC_SETTLEMENTS, R_SCAC_APPEALS, R_COURT_CIRCUITS, R_TFN_S34, R_ERDPORT1, R_IBES_GUIDANCE, R_EIKITEMS, R_SEC_8K_INDEX, I_INPUT_CLOSURE, R_GDP_NAICS, R_GDP_SIC
Evidence: E_SOURCE_LIST, E_SCAC_METHOD, E_FJC_METHOD, E_LAUS_GDP_SENATE_METHOD, E_WRDS_METHOD, E_HQ_METHOD, E_PACKAGE_INVENTORY, E_FROZEN_CATALOG, E_SAMPLE_PROBE

Preparation / proposed procedure:

1. For elections, Senate history, FJC, court and circuit crosswalks, obtain the exact author-prepared files or the documented compilation schema; confirm coverage and field/date conventions before using the cited public pages.
2. For both BEA inputs, confirm the author’s exact GDP measure, units (real or current dollars), and industry aggregation (all-industry total or another table series) for the pN/ps year columns. The public pages support the source families and history but do not identify this author-specific table choice.
3. For SCAC master, classification, settlements, and dismissal/appeal files, verify that manual case-page access (including current sign-up conditions) supports the required fields, NID matching, time span, and author coding/verification rules. Do not infer that bulk-export limits rule out this permitted route.
4. For SEC 10-K history, inspect only exact documented local paths and confirm 1996–2016 filing/header coverage and the author-built tenkidx index recipe; for 8-Ks, obtain the precise filing index and producer for the year-specific eikitem files.
5. For TFN S34, preserve the 15-second bounded-probe timeout as unverified; for CRSP ERDPORT1, resolve the exact product/path; for I/B/E/S DHGDET.US, confirm current WRDS product access and fields. Do not infer missing data or license from catalog/probe misses.

Validation to perform later:

- Reconcile each unresolved file/product to the SAS parser fields, identifiers, exact study period and lookback windows, allowed route, and its downstream consumer before a future authorized run.

### A_LIBRARY_CONFIG: Configure SAS library and project paths for the verified local Compustat, CRSP, and I/B/E/S product candidates, and confirm the generated FCI/output location.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_LIBRARY_SETUP
Evidence: E_SAS_PATHS, E_FROZEN_CATALOG

Preparation / proposed procedure:

1. Confirm the intended runtime working directory, visibility of fci_data and helper includes, and a writable output directory in the execution host.
2. Map COMP, CRSP, and IBES to the exact catalogued ${ACCTREPL_SAS_ROOT} candidate paths whose products/fields were verified; identify the TFN library and required S34 route separately after its timed-out read is resolved.
3. Create/use a project-relative or [redacted-path-ebdcdf2c6984] location for the generated FCI library and preserve all author stages; do not embed the Dropbox workspace path in future executable configuration.

Validation to perform later:

- Before a separately authorized run, verify each LIBNAME resolves to the intended product labels and performs a non-author-code writeability check on the selected output location.

### A_SAS_RUNTIME: Resolve the bounded SAS initialization failure in the existing runtime environment or identify a supported host runtime before attempting the supplied SAS program.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS_94, I_SAS_RUNTIME
Evidence: E_ENV_PROBE

Preparation / proposed procedure:

1. Use the documented SAS 9.4 TS1M8 invocation and host runtime guidance to diagnose TKELS initialization without rerunning the author source or reading study data.
2. Confirm required SAS procedures and output engine support in the selected runtime.

Validation to perform later:

- Record a successful independent SAS version/startup check and required procedure availability before a future authorized workflow run.

### A_RUN_PROCEDURE: After all unresolved inputs, helper contracts, library paths, and SAS startup are resolved, run the complete supplied SAS entry point in its author stage order and preserve all branches and exports.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_DOC_WORKFLOW, E_MAIN_BRANCH, E_APPOINTMENT_BRANCH, E_PACKAGE_CONTENTS

Preparation / proposed procedure:

1. Use HHL_SAS_Code.sas as the entry point from its documented project working directory after prerequisite inputs and includes are available.
2. Execute every supplied stage in source order, including Table 9B/9C and the earnings-guidance/8-K branch; retain the supplied sample filters, intermediate construction, analysis procedures, and exports.
3. Do not substitute Final_sample.csv for the data construction workflow; its bounded probe found only gvkey.

Validation to perform later:

- Compare generated dataset names/fields and exports against every supplied consumer and author output declaration; this is future validation, not execution evidence from this assessment.

### A_PUBLIC_ACQUISITION: Acquire and prepare the verified public LAUS and 2012 ZIP Business Patterns sources for the supplied parser contracts.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_LAUS, R_ZBP
Evidence: E_PUBLIC_BLS_AVAIL, E_PUBLIC_BLS_SCHEMA, E_PUBLIC_BLS_HISTORY, E_PUBLIC_CENSUS_2012, E_PUBLIC_CENSUS_LAYOUT

Preparation / proposed procedure:

1. Download BLS LAUS annual-average source series and the exact series/area mappings, then format county/year labor, employed, and unemployed values to the parser’s fixed-width row shape; preserve the author’s county-to-state sum and rate formula.
2. Retrieve the 2012 Census ZIP Code Totals File with its 2010–2013 record layout, preserving positional import order so official CTY_NAME maps to the SAS variable city_name.

Validation to perform later:

- Check the downloaded source series and data dictionaries for the documented geography, identifiers, year coverage, and measure before creating the BLS author input.
- Compare generated parser-input schemas and derived state-year/ZIP fields with the supplied SAS code before the full workflow is authorized.


## Remaining issues and prerequisites

- I_SUPPORT_CODE [unresolved; full_pipeline]: The supplied SAS entry point actively includes winsor.sas, ccm.sas, io_ts.sas, iccmlink.sas, and evtstudy08.sas, but none is listed in the extracted package inventory. Their macro bodies, produced dataset schemas, timing/history rules, and output naming conventions cannot be verified from the entry file alone. The Table 9C evtstudy call uses outset=carjapp_madj while its consumer reads carjapp_madj0; preserve this as a macro-contract unknown rather than guessing a suffix change.
- I_IO_TIMESERIES [unresolved; full_pipeline]: The code comment says io_ts.sas generates fci.io_timeseries, but that producer is absent; its fields, holdings source, date history, and compatibility with the downstream PERMNO/date join are unresolved.
- I_INPUT_CLOSURE [unresolved; full_pipeline]: The full supplied workflow depends on 31 distinct raw, curated, or vendor inputs. Twelve local commercial product candidates have matching bounded field probes, four verified public product routes remain to be acquired/prepared, and the remaining distinct source/curated inputs retain specific unresolved route or construction questions. Final_sample.csv exposes only a gvkey column, so it does not support a separate analysis-only path.
- I_LIBRARY_SETUP [unresolved; full_pipeline]: The SAS entry point hard-codes [redacted-path-2e0b279e56d6], [redacted-path-d9f18d2760ed], [redacted-path-75f4a0e34c3a] and a tilde project/output directory. Frozen local product candidates live under ${ACCTREPL_SAS_ROOT}; path, permission, required library mappings, relative input directory, and output writeability have not been validated.
- I_SAS_RUNTIME [unresolved; full_pipeline]: A bounded environment probe found the installed SAS 9.4 TS1M8 executable but it failed TKELS initialization. The failure does not establish a missing license or entitlement; runtime availability for the author workflow remains unverified.
- R_ELECTIONS [undetermined]: Presidential state-election party indicators imported from fci_data/Pres_Elec_State.csv and used from 1988 through 2012.
- R_LAUS [public_acquisition_required]: BLS county unemployment fixed-width history aggregated by state-year for the state control series.
- R_GDP_NAICS [undetermined]: BEA state GDP input for 1997–2014, with annual pn1997–pn2014 fields.
- R_GDP_SIC [undetermined]: BEA SIC state GDP input for 1963–1997, with annual ps1963–ps1997 fields.
- R_FJC_HISTORY [undetermined]: Federal Judicial Center judge appointment and service history imported to construct circuit and district judge panels.
- R_SENATE_HISTORY [undetermined]: Author hand-collected Senate history CSV with party and service-date intervals for presidential appointee confirmation context.
- R_SEC_HQ_INDEX [undetermined]: Prepared EDGAR 10-K filing-header index used to obtain historical headquarters by CIK and filing date.
- R_ZBP [public_acquisition_required]: Census ZIP Business Patterns 2012 totals used to map ZIPs to cities and states.
- R_ZIP_DISTRICT [undetermined]: AO federal district court and ZIP-code crosswalk, read as ZIP plus long district name.
- R_SCAC_CASES [undetermined]: SCAC master lawsuit case records supplying NID, event/outcome, defendant, class period, HQ, issuer, market, and court fields.
- R_SCAC_CLASSIFICATION [undetermined]: Additional SCAC NID-level 10b5/IPO and case-category classification file.
- R_SCAC_SETTLEMENTS [undetermined]: NID-level manually verified settlement amounts from SCAC case pages.
- R_SCAC_APPEALS [undetermined]: NID-level district-dismissal and circuit-appeal outcomes collected from SCAC case pages.
- R_COURT_CIRCUITS [undetermined]: Court-reference to circuit crosswalk used to assign the circuit for each SCAC case.
- R_TFN_S34 [undetermined]: Thomson Financial 13F institutional holdings S34.
- R_ERDPORT1 [undetermined]: CRSP erdport1 daily decile-return product used in market-adjusted daily return estimation.
- R_IBES_GUIDANCE [undetermined]: I/B/E/S management-guidance DHGDET.US file, filtered by the SAS code to EPS, P/S, annual or quarterly guidance.
- R_EIKITEMS [undetermined]: Prepared SEC 8-K filing-item text data, one tab-delimited file per year 1996–2015; no producer is supplied.
- R_SEC_8K_INDEX [undetermined]: SEC 8-K filing index containing issuer, filing type, CIK, filing date, and document URL.
- SW_SAS_94 [unverified]: The documented author language is SAS. The program requires SAS data steps, SQL, sort/means/export, PROC REG, and PROC LOGISTIC. The machine has a SAS 9.4 TS1M8 executable, but an independent runtime probe failed during TKELS initialization; this does not establish procedure entitlement or a missing license.

## Review notes

- Read all supplied cached source content: 191-line data description, 2,288-line SAS program, and 1,259-line online appendix. All 53 frozen dependency IDs are classified exactly once; all actually supplied SAS branches, including independent Table 9B/9C builders, remain in full_pipeline.
- Twelve exact local Compustat/CRSP/I/B/E/S product candidates have successful one-row field probes and verified local routes; the separate path-configuration issue remains. The S34 read probe ended at its 15-second timeout and is left unverified. One-row results do not assert full row counts or full history coverage.
- The package’s Final_sample.csv probe reads one row with only gvkey; it is an identifier list and does not support analysis_only. No individual judge-level attributes were calculated or inferred.
- Exact local history checks statted only the SEC raw/parsed roots and LM annual directories 1996–2016. They did not list or read filing contents and do not establish 10-K/8-K coverage or the author-prepared index/item transformations.
- The appendix lists IA1–IA18 but no separate appendix source program is listed in the package. This remains scope context; no additional mandatory requirement was inferred from appendix table titles alone.
- All routes are based on the assigned package variant and bounded evidence. No author program was executed, no dataset was downloaded, and no code or patch was applied.
