# Patch proposal: jar-7cfa662fd759

Does Sensationalism Affect Executive Compensation? Evidence from Pay Ratio Disclosure Reform

DOI: 10.1111/1475-679X.12458

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Full supplied program workflow only: main SAS pre-stage, two Stata programs, proxy-return SAS companion, retail-trade SAS companion, and the resumed main SAS final section, in the explicit author-commented order. Input/producer, field-history, path/library, and remote-session/runtime gaps remain. Keeping the main SAS process and WORK tables available through the interleaved stages is a supported run-preparation procedure. The package contains no full analysis dataset or supported separate analysis-only route.

Entry points: `CEO Pay Ratio Disclosure_SAS Program (Jul 2022 JAR).sas`, `Stata Program_UnexpectedPayRatio.do`, `Stata Program_UnexpectedCEOPay.do`, `CEO Pay Ratio_Proxy Returns_SAS Program (Jul 2022 JAR).sas`, `CEO Pay Ratio_Retail Trades_SAS Program (Jul 2022 JAR).sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 1/12458 - Does-Sensationalism-Affect-Executive-Compensation-Evidence-from-Pay-Ratio-Disclosure-Reform/cdss-datasheet-code-and-identifiers.zip",
      "sha256": "c677daba748a4ed9cbf2176e2239a4fb71076d30d72bbb0fbd406c203f6b619e"
    },
    {
      "path": "JAR-Volume 61/Issue 1/12458 - Does-Sensationalism-Affect-Executive-Compensation-Evidence-from-Pay-Ratio-Disclosure-Reform/cdss-online-appendix.pdf",
      "sha256": "7ec3dbaa15920370cb084151bb381bf6ee5742b591974b5c49c460a249fee5a0"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "9a0cec1b366be99b65d900edeebded03fcd73fcfbcdb2a5b171982a26843b557"
}
```

## Proposed actions

### ACT_INPUT_CLOSURE: Prepare the same-data SAS-to-Stata handoff by aligning the existing main-SAS export name and path with the supplied Stata consumer, and obtain the genuinely missing author-prepared files and TAQ CSV producer contract without changing fields, periods or methods.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_INPUT_CLOSURE
Evidence: EV_HANDOFF, EV_STATA_INPUT, EV_TAQ_CSV, EV_PR_EXPORT, EV_PR_BASE, EV_PR_FIELDS

Preparation / proposed procedure:

1. Use one coherent project-relative working root for the main SAS exports, the Stata local file setting and the resumed SAS imports; align the exported UnexpPR dataset name with the existing Stata input name in a working copy.
2. Obtain the missing Equilar and hand-collected files named by the main SAS program and the employee-pay coefficient CSV, with original schemas and required dates.
3. Obtain the Jupyter Hub TAQ CSV producer and its fixed 504-file output contract, or the author-prepared CSV files with their original schema and date coverage.
4. Confirm source fields, identifier/link mappings, and required date history for each consumed file before any authorized execution.

Validation to perform later:

- After inputs and producer contracts are supplied, conduct a separately authorized static input-schema and date-coverage review before execution.

### ACT_CATALOG_PRODUCTS: Use the exact catalog-listed local Compustat, CRSP, and SEC Analytics candidates already checked, and resolve the specified WRDSSEC.FORMS and IBES table routes. The row-one checks establish only sampled readability and named-column presence for successful files; verify complete fields, identifiers, historical dates, and join compatibility for the required workflow window. The I/B/E/S input route must supply the unadjusted annual EPS forecast and report-date fields used by the missing author macros; do not infer a substitute from catalog discovery alone.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_COMP_FUNDA, REQ_COMP_COMPANY, REQ_COMP_CODIRFIN, REQ_COMP_ANNCOMP, REQ_COMP_OUTSTANDINGAWARDS, REQ_COMP_FUNDQ, REQ_CRSP_MSENAMES, REQ_CRSP_MSIX, REQ_CRSP_DSIX, REQ_CRSP_DSF, REQ_CRSP_DSEDELIST, REQ_CRSP_MSF, REQ_CRSP_MSEDELIST, REQ_CRSP_CCMXPF, REQ_WRDSSEC_EXHIBITS, REQ_WRDSSEC_FORMS, REQ_IBES_FORECASTS
Evidence: EV_RESOURCE_CATALOG, EV_CATALOG_PRODUCT_LOOKUP, EV_CATALOG_EXACT_TABLE_LOOKUP, EV_ROW1_COMP_FUNDA, EV_ROW1_COMP_COMPANY, EV_ROW1_COMP_CODIRFIN, EV_ROW1_COMP_ANNCOMP, EV_ROW1_COMP_OUTSTANDING, EV_ROW1_COMP_FUNDQ, EV_ROW1_CRSP_MSENAMES, EV_ROW1_CRSP_MSIX, EV_ROW1_CRSP_DSIX, EV_ROW1_CRSP_DSF, EV_ROW1_CRSP_DSEDELIST, EV_ROW1_CRSP_MSF, EV_ROW1_CRSP_MSEDELIST, EV_ROW1_CRSP_CCMXPF, EV_ROW1_WRDSSEC_EXHIBITS, EV_COMP_WRDS_INPUT, EV_COMP_CRSP_INPUT, EV_CRSP_RETURNS_INPUT, EV_EXECUCOMP_INPUT, EV_EXECUCOMP_AWARDS_INPUT, EV_WRDSSEC_FORMS_INPUT, EV_PROXY_CRSP_INPUT, EV_PROXY_FUNDQ_INPUT, EV_IBES_MISSING_MACROS

Preparation / proposed procedure:

1. Keep the catalog-listed local paths as the primary route where the exact-file probe succeeded; do not equate a sampled row with complete history or coverage.
2. Resolve the exact WRDSSEC.FORMS and IBES forecast tables and field/time contracts from the documented source route, retaining their current unverified status until confirmed.
3. Check the 2000–2019 main-source window, 2005–2020 proxy window, identifiers, and rolling-history coverage against each supplied query before a separately authorized run.

Validation to perform later:

- Record exact resolved table IDs, probed fields, coverage dates, and join keys without running the SAS programs or querying empirical rows beyond the already approved single-row checks.

### ACT_EQILAR_PREPARED_FILES: Restore the six author-prepared Equilar SAS inputs named by the main program, together with their actual schemas, identifier crosswalks, and historical coverage. Preserve the supplied file-level source and derived award contracts; do not reconstruct Equilar observations independently.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_EQILAR_ID, REQ_EQILAR_OUTSTANDING, REQ_EQILAR_ANNCMP, REQ_EQILAR_OPTIONS, REQ_EQILAR_STOCK, REQ_EQILAR_IP
Evidence: EV_EQILAR_FILES, EV_EQILAR_ID_FIELDS, EV_EQILAR_OUTSTANDING_FIELDS, EV_EQILAR_ANNCMP_FIELDS, EV_EQILAR_OPTION_FIELDS, EV_EQILAR_STOCK_FIELDS, EV_EQILAR_IP_FIELDS

Preparation / proposed procedure:

1. Obtain the six named Equilar SAS files through the prepared author-data route.
2. Retain the documented CompID, ExecID, award, date, metric, and annual compensation field mappings; verify source-period coverage and link keys before execution.

Validation to perform later:

- Compare each supplied file's actual schema, identifier cardinality, and date coverage with the quoted consumers without opening or transforming empirical rows in this assessment.

### ACT_GEOGRAPHY_AND_INDUSTRY_INPUTS: Use the author-prepared headquarters ZIP, ZIP reference, ZIP-to-MSA, FF48, and 2017/2018 Census/QCEW tables as the primary compatible inputs. The official public source pages establish candidate source products, but the exact author MSA and industry-region transformations, joins, and consumed fields are not established; preserve those contracts rather than independently reconstructing them from broad raw data.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_FIRMHQZIP, REQ_ZIPCODE, REQ_ZIPTOMSA, REQ_CENSUS_EDUC_2017, REQ_CENSUS_EDUC_2018, REQ_QCEW_2017, REQ_QCEW_2018, REQ_FF48
Evidence: EV_ZIP_CROSSWALK, EV_CENSUS_FIELDS, EV_QCEW_FIELDS, EV_QCEW_CPI_HANDCOLLECT, EV_DOC_PUBLIC_INPUTS, EV_DOC_PUBLIC_VARIABLES, PUB_CENSUS_S1501, PUB_BLS_QCEW, PUB_JOSH_LEE

Preparation / proposed procedure:

1. Restore the named author-prepared crosswalk and industry tables, including the exact firm ZIP, ZIP-to-ZCTA/MSA, region, and FF48 contracts.
2. Use official 2017/2018 ACS S1501 and QCEW source routes only as documented alternatives for constructing the prepared tables; preserve the unresolved geography, population-weight, industry, and field mappings until the author contract is available.

Validation to perform later:

- Verify exact variable names and the required 2017/2018 dates, ZIP/MSA identifiers, industry crosswalks, and join keys before execution.

### ACT_RIGHT_TO_WORK_CLASSIFICATION: Use the verified named public right-to-work timeline to prepare the state classification used in the author's 2017–2018 panel, while retaining the prepared SAS table as the expected primary input. The source table's exact state-code mapping remains to be checked.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_RIGHT_TO_WORK
Evidence: PUB_RIGHT_TO_WORK, EV_HC_STATUS_FIELDS, EV_DOC_PUBLIC_VARIABLES

Preparation / proposed procedure:

1. Apply the listed effective dates to the states and years in the supplied panel, then map the resulting indicator to the source's State_Code and righttowork field contract.
2. Use the existing author-prepared righttowork.sas7bdat if supplied; do not infer the table's actual schema from the public timeline alone.

Validation to perform later:

- Confirm state codes, law effective dates, and the author's as-of-year convention against the documented merge before execution.

### ACT_RISKFREE_AND_CPI_SERIES: Resolve the exact risk-free Treasury series/tenor and units used by the option-sensitivity construction, and the CPI series and annualization used to create CPI_Annual. FRED documents a monthly CPIAUCSL series, but not the author's annual value construction; the riskfree transformation also remains unspecified.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_RISKFREE, REQ_CPI_ANNUAL
Evidence: EV_RISKFREE_TRANSFORM, EV_QCEW_CPI_HANDCOLLECT, PUB_FRED_CPI, EV_DOC_PUBLIC_INPUTS

Preparation / proposed procedure:

1. Identify the author's actual Treasury rate source, maturity, date conversion, and units for riskfree.sas7bdat.
2. Identify the exact CPI series and annualization rule for cpi_annual.sas7bdat; use CPIAUCSL only if that mapping matches the supplied author transformation.

Validation to perform later:

- Compare units, date keys, annualization, and required historical coverage with the author source fields before executing dependent computations.

### ACT_HANDCOLLECTED_INPUTS: Restore the hand-collected pay-ratio/status, proxy-date, ISS Voting Analytics, and bonus-pay delta files using the named author-prepared routes. Their research-specific coding and sample contracts are not derivable from the package's two firm-listing CSVs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_HCDATA_PAYRATIO_STATUS, REQ_CPR_SAMPLE_PROXYDATES, REQ_HCDATA_PROXYDATES, REQ_ISS_VA, REQ_BONUS_PAY_DELTA
Evidence: EV_DOC_HANDCOLLECT, EV_DOC_PUBLIC_INPUTS, EV_HC_STATUS_FIELDS, EV_PROXY_DATE_INPUTS, EV_VOTING_INPUT, EV_DOC_PUBLIC_VARIABLES

Preparation / proposed procedure:

1. Obtain each named author-prepared table and its codebook or field mapping, including pay-ratio status, EGC/source flags, missing proxy dates, ISS vote measures, and the matched-pair bonus delta.
2. Preserve the stated panel date ranges and individual author selections; do not reconstruct hand-collected content.

Validation to perform later:

- Check each original field name, firm/year/date key, and panel period against the exact supplied joins before any separately authorized run.

### ACT_EMPLOYEE_PAY_COEFFICIENTS: Restore the specific predicted-employee-pay coefficient CSV consumed by the resumed SAS section, with its category/variable labels and coefficient schema. It is an applied author input; do not refit or substitute newly estimated coefficients.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_PRED_EMP_PAY_COEFF
Evidence: EV_DOC_HANDCOLLECT, EV_HANDOFF, EV_DOC_PUBLIC_VARIABLES

Preparation / proposed procedure:

1. Obtain Predicted Employee Pay_Coeff Estimates v20210723.CSV or a documented exact copy through the author-prepared route.
2. Preserve the supplied coefficient definitions and the Intercept/SIC mappings used in the SAS joins.

Validation to perform later:

- Verify imported column labels, coefficient categories, and the SIC2 keys consumed by the supplied source; do not refit the coefficient table.

### ACT_FRENCH_PREPARED_INPUTS: Supply the three author-prepared SAS tables read by the proxy companion: daily equal-weighted 5x5 Size/BM reference returns, monthly ME breakpoints, and annual BE/ME breakpoints. The official author pages document the candidate products and history, while the exact equal-weighted table layout and SAS schema remain unverified.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_FF_PORTFOLIO_DAILY, REQ_FF_ME_BREAKPOINTS, REQ_FF_BEME_BREAKPOINTS
Evidence: EV_FRENCH_INPUTS, EV_FRENCH_RESHAPE, EV_DOC_FRENCH, PUB_FF_PORTFOLIO, PUB_FF_ME_BREAKPOINTS, PUB_FF_BEME_BREAKPOINTS

Preparation / proposed procedure:

1. Use the author's named data pages as the supported public product route or restore the prepared CPR tables.
2. Prepare the exact equal-weighted daily portfolio columns and ME/BM breakpoint key/value columns expected by the supplied SAS joins; preserve the code's portfolio assignment and return calculations.

Validation to perform later:

- Compare acquired/prepared field names, date and breakpoint keys, historical coverage, portfolio weighting, and 2005–2020 proxy window against the source contract before execution. A request was made to the daily TXT ZIP URL; the web tool reported a 400 unsupported ZIP content-type error. No usable payload is saved or reported, and no transfer-byte telemetry was exposed, so transfer volume is unknown.

### ACT_RAVENPACK_PRODUCTS: Resolve the restricted WRDS RavenPack mapping, source list, press-release equities, and Dow Jones/full-edition products named by the supplied main SAS workflow. The supplied year macro uses the 2011–2020 annual tables; exact current route, fields, identifiers, and coverage remain unverified.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_RP_COMPANY_MAPPING, REQ_RP_SOURCE_LIST, REQ_RP_PR_EQUITIES, REQ_RP_DJ_EQUITIES
Evidence: EV_RAVENPACK_TABLES, EV_DOC_PUBLIC_INPUTS, EV_DOC_PUBLIC_VARIABLES

Preparation / proposed procedure:

1. Use the documented WRDS route for the four exact RavenPack product families and annual tables.
2. Preserve the supplied CUSIP-to-entity interval join, RP_ENTITY_ID keys, and release types; do not substitute another RavenPack product family without field/coverage evidence.

Validation to perform later:

- Confirm product edition, annual table coverage, link identifiers and interval fields, and all consumed release measures before a later authorized run.

### ACT_TAQ_CLASSIFIER_AND_CSVS: Recover the author's Jupyter Hub TAQ classification source and its 504 numbered daily CSV outputs, or the already prepared CSV files with the same contract. The SAS reader and final aggregates are supplied, but the specific classifier construction and CSV schema are missing; do not create a replacement classifier from the SAS consumer alone.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_TAQ_RETAIL_CSV, ISS_TAQ_PRODUCER
Evidence: EV_TAQ_CSV, EV_TAQ_LINK_READ, EV_DOC_HANDCOLLECT

Preparation / proposed procedure:

1. Obtain the actual Jupyter Hub notebook/source and its existing 504-file output set from the authorized project route, or restore the author's prepared CSVs.
2. Document exact numbering/date coverage, columns, retail-trade classification outputs, and join key mapping expected by the SAS loop.

Validation to perform later:

- Compare the original notebook or prepared CSV contract with the supplied retail SAS importer and downstream aggregate fields; do not execute the notebook or rebuild the classification in this assessment.

### ACT_TAQ_CRSP_LINK: Resolve the exact WRDS Apps TAQMCLINK route and field/history contract used to map TAQ daily rows to PERMNO after 2016. Catalog lookup did not verify a matching local table; this is not evidence of missing entitlement or licensing.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_TAQ_CRSP_LINK
Evidence: EV_TAQ_LINK_DOC, EV_TAQ_LINK_READ, EV_CATALOG_PRODUCT_LOOKUP, EV_CATALOG_EXACT_TABLE_LOOKUP

Preparation / proposed procedure:

1. Use the documented WRDS Apps source route for WRDSAPPS.TAQMCLINK or confirm its exact supported table equivalent.
2. Preserve the supplied date, symbol, CUSIP, and PERMNO link logic.

Validation to perform later:

- Confirm table availability, field names, date range, and symbol/identifier compatibility before the retail aggregate stage.

### ACT_IBES_MACRO_SOURCES: Restore the four referenced macro source files and their exact macro interfaces, then map their IBES forecast, report-date, ICLINK, and CCM inputs. The source code uses annual EPS forecasts; exact table, identifier, fiscal-period, and history contracts are not established until the actual macro files are available.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_MISSING_MACRO_SOURCES, REQ_IBES_FORECASTS
Evidence: EV_IBES_MISSING_MACROS, EV_PROXY_DATE_INPUTS, EV_COMP_WRDS_INPUT, EV_COMP_CRSP_INPUT, EV_CATALOG_PRODUCT_LOOKUP

Preparation / proposed procedure:

1. Obtain cibeslink.sas, IBES_Sample.sas, iclink.sas, and winsorize.sas from their actual author/WRDS source route.
2. Resolve the unadjusted XEPS/annual EPS forecast and actuals fields, report dates, ICLINK identifiers, and CCM GVKEY/PERMNO link through the actual macro logic; do not write replacement macros.

Validation to perform later:

- Statically inspect the restored macro text and source-table contracts with credential-safe redaction before any separately authorized run.

### ACT_PATH_AND_LIBRARY_CONFIGURATION: Prepare a coherent host-visible project-relative or [redacted-path-3541f21a562b] execution root across main SAS, both Stata programs, and the proxy and retail companions. Retain separate input/output folders, align every affected producer and consumer, and avoid embedding the Dropbox workspace path in executable configuration.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_WINDOWS_PATHS
Evidence: EV_HANDOFF, EV_STATA_INPUT, EV_TAQ_CSV, EV_FRENCH_INPUTS, EV_ORDER

Preparation / proposed procedure:

1. Choose one project-relative working root and map each supplied [redacted-path-c93181d4ae5c], [redacted-path-e2866afaed39], [redacted-path-be3261a9729f] and library reference to its corresponding host-visible path.
2. Apply the same path map to all producing and consuming statements, including main SAS imports/exports, Stata local file settings, proxy SAS prepared inputs/outputs, and retail CSV/library paths.
3. Keep the source working directory and persistent output locations distinct from SAS WORK; preserve the authored stage sequence.

Validation to perform later:

- Before any authorized execution, statically review all changed producer/consumer paths and check host visibility and writability without starting SAS or Stata.

### ACT_REMOTE_WRDS_CONFIGURATION: Resolve the author's WRDS remote SAS session and library setup in an approved local configuration. Keep authentication values out of the assessment and logs; the current safe source review did not verify connection state or credentials.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISS_REMOTE_WRDS_SETUP
Evidence: EV_COMP_WRDS_INPUT, EV_PROXY_CRSP_INPUT, EV_WRDSSEC_FORMS_INPUT, EV_RAVENPACK_TABLES, EV_TAQ_LINK_READ

Preparation / proposed procedure:

1. Identify the authorized host-side WRDS/SAS session and library configuration required by the supplied remote submit/upload/download steps.
2. Map only the required Compustat, CRSP, SEC Analytics, IBES, RavenPack, and TAQ libraries; preserve source-specific routes and do not expose connection statements.

Validation to perform later:

- Confirm library visibility and remote session setup through a separately authorized configuration check; this assessment made no connection attempt.

### ACT_FILENAME_ALIGNMENT: Align the Stata pay-ratio consumer's local filename/path with the existing main-SAS UnexpPR export, preserving the same source fields and data content.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_FILENAME_ALIGNMENT
Evidence: EV_PR_EXPORT, EV_STATA_INPUT, EV_PR_FIELDS, EV_HANDOFF

Preparation / proposed procedure:

1. Set the Stata input path to the main SAS export named Stata Table_UnexpPR.dta within the selected execution root, or configure the producer to write the existing _OLD consumer name.
2. Keep the UnexpPR variables, sample, and construction unchanged.

Validation to perform later:

- Check the output filename and path at the main SAS export and Stata import statements; compare the already documented fields without executing either program.

### ACT_SOURCE_ALIAS_CLARIFICATION: Clarify the intended aliases and join keys in the final EQ_IPMetrics_Sum join, where dEQ and d0 are not defined in that query's FROM/JOIN scope. Do not guess a substitution or alter the scientific join.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_SOURCE_ALIASES
Evidence: EV_SOURCE_ALIAS_ISSUE

Preparation / proposed procedure:

1. Resolve the intended executive/company key and date source for the final d14 join from an author-provided source explanation or authoritative code history.
2. Once clarified, prepare a working-copy edit that follows the supported table and alias schema.

Validation to perform later:

- Check the alias scope and key names statically against the supplied FROM/JOIN block and resolved source fields; do not compile or run the proposed statement.

### ACT_ORDER_AND_SESSION_HANDOFF: Follow the supplied interleaved order while keeping the original main SAS process and its WORK state available: run the main SAS pre-stage through the documented pause, run Stata UnexpectedPayRatio, Stata UnexpectedCEOPay, proxy-return SAS, and retail-trade SAS in that order, then resume the main SAS source at lines 1508–1877. The pause comment identifies the boundary and sequence; setting up the live session is a run procedure, not a missing data construction.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: ISS_MAIN_SESSION_ORCH
Evidence: EV_ORDER, EV_HANDOFF, EV_WORKFLOW_TRACE_COMPLETE

Preparation / proposed procedure:

1. Run the main SAS source through the section ending at line 1507 and keep that SAS process and its WORK library alive; do not close, restart, or clear its state.
2. While the main SAS session is held, run the two supplied Stata programs in order, then the proxy-return SAS companion, then the retail-trade SAS companion, using the configured producer/consumer paths.
3. Resume the same main SAS process at line 1508 after the companion outputs are available; retain the exact stage order recorded in the workflow trace.

Validation to perform later:

- Before a separately authorized run, statically account for each cross-stage producer/consumer table and file, and verify the SAS runtime and WRDS library configuration separately without changing or reconstructing the authored tables.

### ACT_SAS_RUNTIME_SETUP: Verify the host's SAS 9.4 TS1M8 runtime, required batch wrapper settings, remote library visibility, and working-directory permissions through an authorized metadata/setup check. The assessment did not start SAS and does not establish license or session readiness.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS_94
Evidence: EV_ENVIRONMENT, EV_ORDER, EV_HANDOFF

Preparation / proposed procedure:

1. Use the documented batch wrapper and a project-relative or [redacted-path-3541f21a562b] working directory when a later run is authorized.
2. Confirm required local roots are visible and writable and the remote library configuration is available; keep SAS WORK and persistent handoffs distinct.

Validation to perform later:

- Perform only a separately authorized setup check before any author-code execution; do not start SAS as part of this static assessment.


## Remaining issues and prerequisites

- ISS_INPUT_CLOSURE [unresolved; full_pipeline]: The full five-program workflow has multiple unresolved inputs/products and specific producer or handoff gaps. Main SAS's UnexpPR export supplies the fields consumed by Stata; its OLD-suffix/path mismatch is preparation, not a missing scientific producer. Genuine unresolved items are enumerated in the linked requirement and issue records, including author-prepared files, commercial/public field and history coverage, missing macro sources, the TAQ classifier/CSV producer, remote setup, an unresolved SAS session handoff, and one unsupported join alias.
- ISS_MISSING_MACRO_SOURCES [blocking; full_pipeline]: The supplied main and proxy SAS sources reference cibeslink.sas, IBES_Sample.sas, iclink.sas, and winsorize.sas, but those include files are not in the package inventory. Their macro definitions and exact supported input contracts are needed to resolve the annual IBES and link construction; do not independently recreate them.
- ISS_TAQ_PRODUCER [blocking; full_pipeline]: The retail SAS companion reads numbered daily TAQ CSV inputs from an author-named Jupyter Hub directory, iterating over 504 files, but the package contains neither the notebook/source that creates them nor those inputs. The classifier and CSV schema/date contract are not supplied, so their research construction cannot be inferred.
- ISS_MAIN_SESSION_ORCH [preparation; full_pipeline]: The main SAS source gives the interleaved run sequence and pause/resume point in its comments at lines 1502–1506. Prepare the run procedure to keep the original SAS process and its WORK tables alive while the two Stata programs and two SAS companions run, then resume the main source at line 1508. This is operational session/order preparation, not a missing scientific producer or a requirement to reconstruct earlier tables. SAS runtime and WRDS configuration remain separately unverified.
- ISS_WINDOWS_PATHS [preparation; full_pipeline]: The supplied programs contain machine-specific Windows working, input, and output paths and library references across main SAS, Stata, and companion sources. Prepare one coherent host-visible project-relative or [redacted-path-3541f21a562b] execution root, preserve distinct source/output folders, and align every producer/consumer path in a working copy; do not put the Dropbox workspace path in executable configuration.
- ISS_FILENAME_ALIGNMENT [preparation; full_pipeline]: Main SAS exports the assembled UnexpPR data under Stata Table_UnexpPR.dta, while the supplied Stata consumer opens Stata Table_UnexpPR_OLD.dta. The consumer's variables derive from the same UnexpPR dataset; align the name/path as routine preparation and do not treat it as a missing scientific producer.
- ISS_SOURCE_ALIASES [unresolved; full_pipeline]: In the final CEOPR0 query, the join to EQ_IPMetrics_Sum references dEQ.ExecID, dEQ.CompID, and d0.datadate, but those aliases are not defined in that query's FROM/JOIN block. The intended join aliases and keys are unsupported by the supplied text; clarify them without guessing a replacement.
- ISS_REMOTE_WRDS_SETUP [unresolved; full_pipeline]: The SAS programs use WRDS/remote libraries and remote submit/upload/download operations. The author-specific authentication/session and library configuration are not established by the safe static source review, and the programs were not connected or executed. Confirm a valid authorized host configuration before a later separately authorized run; no credentials or connection statements are reproduced here.
- REQ_COMP_FUNDA [undetermined]: Compustat annual fundamentals required by the main and proxy SAS programs, including financial controls, identifiers and annual history.
- REQ_COMP_COMPANY [undetermined]: Compustat company metadata used to obtain headquarters and company identifiers for the study panel.
- REQ_COMP_CODIRFIN [undetermined]: Compustat director-finance data used to construct dividend-yield inputs.
- REQ_COMP_ANNCOMP [undetermined]: Execucomp annual compensation data used for CEO/CFO compensation, tenure and ownership measures.
- REQ_COMP_OUTSTANDINGAWARDS [undetermined]: Execucomp outstanding-awards data used for year-end option-award sensitivity measures.
- REQ_COMP_FUNDQ [undetermined]: Compustat quarterly fundamentals used by the proxy-return companion.
- REQ_CRSP_MSENAMES [undetermined]: CRSP security name history used for PERMNO, CUSIP, ticker and date-range links.
- REQ_CRSP_MSIX [undetermined]: CRSP monthly market-index series used by the main SAS stage.
- REQ_CRSP_DSIX [undetermined]: CRSP daily market-index series used by the main and proxy SAS programs.
- REQ_CRSP_DSF [undetermined]: CRSP daily security returns, prices, bid/ask and volume used to construct proxy returns.
- REQ_CRSP_DSEDELIST [undetermined]: CRSP daily delisting returns used with daily security returns.
- REQ_CRSP_MSF [undetermined]: CRSP monthly security returns and characteristics used by the main and proxy SAS programs.
- REQ_CRSP_MSEDELIST [undetermined]: CRSP monthly delisting returns used with monthly security returns.
- REQ_CRSP_CCMXPF [undetermined]: CRSP–Compustat historical link table used to connect GVKEY to PERMNO/PERMCO.
- REQ_WRDSSEC_EXHIBITS [undetermined]: SEC Analytics exhibits used to assemble proxy, 10-K and 10-Q filing information.
- REQ_EQILAR_ID [undetermined]: Author-prepared Equilar company/executive crosswalk used to link Equilar records to Compustat/Execucomp.
- REQ_EQILAR_OUTSTANDING [undetermined]: Author-prepared Equilar outstanding-awards input used to construct option and stock award measures.
- REQ_EQILAR_ANNCMP [undetermined]: Author-prepared Equilar annual compensation input used to supplement executive compensation history.
- REQ_EQILAR_OPTIONS [undetermined]: Author-prepared Equilar option-award input used with annual executive compensation.
- REQ_EQILAR_STOCK [undetermined]: Author-prepared Equilar stock-award input used with annual executive compensation.
- REQ_EQILAR_IP [undetermined]: Author-prepared Equilar incentive-pay award input, including performance-metric information.
- REQ_RISKFREE [undetermined]: Prepared dated Treasury-yield series used to compute option-award sensitivities and risk-free rates.
- REQ_FIRMHQZIP [undetermined]: Prepared company-headquarters ZIP crosswalk from the cited Jennings, Lee, and Matsumoto source.
- REQ_ZIPCODE [undetermined]: ZIP reference data used for ZIP-number matching, names, state and coordinates.
- REQ_ZIPTOMSA [undetermined]: Prepared ZCTA-to-CBSA/Metro Statistical Area crosswalk with population-overlap weights.
- REQ_CENSUS_EDUC_2017 [undetermined]: 2017 ACS S1501 educational-attainment estimates used to construct MSA-level college-graduate shares.
- REQ_CENSUS_EDUC_2018 [undetermined]: 2018 ACS S1501 educational-attainment estimates used to construct MSA-level college-graduate shares.
- REQ_QCEW_2017 [undetermined]: Author-prepared 2017 QCEW industry-region average-pay table used to construct compensation controls.
- REQ_QCEW_2018 [undetermined]: Author-prepared 2018 QCEW industry-region average-pay table used to construct compensation controls.
- REQ_RIGHT_TO_WORK [public_acquisition_required]: State right-to-work law classification joined to each firm's headquarters state for the 2017–2018 disclosure window.
- REQ_CPI_ANNUAL [undetermined]: Annual CPI series joined by calendar year and used to deflate compensation.
- REQ_FF48 [undetermined]: SIC-to-Fama-French 48-industry mapping used by the main SAS program.
- REQ_HCDATA_PAYRATIO_STATUS [undetermined]: Hand-collected pay-ratio, emerging-growth-company status and employee-median-pay data used in the main firm panel.
- REQ_CPR_SAMPLE_PROXYDATES [undetermined]: Prepared proxy-filing-date sample supplement used when SEC Analytics filing dates are absent.
- REQ_HCDATA_PROXYDATES [undetermined]: Hand-collected proxy-filing dates for observations missing in SEC Analytics.
- REQ_ISS_VA [undetermined]: Author-prepared ISS Voting Analytics meeting and say-on-pay voting data.
- REQ_PRED_EMP_PAY_COEFF [undetermined]: Author-prepared coefficient estimates for predicted employee pay, imported from a CSV and applied in the resumed main SAS stage.
- REQ_BONUS_PAY_DELTA [undetermined]: Hand-collected earnings-based annual-bonus pay delta for the author's matched-pair subsample.
- REQ_WRDSSEC_FORMS [undetermined]: WRDS SEC Analytics Forms data filtered to DEF 14A for proxy filing dates and meeting windows.
- REQ_IBES_FORECASTS [undetermined]: Annual IBES EPS forecast input and linked report-date data required by the supplied missing include macros.
- REQ_FF_PORTFOLIO_DAILY [undetermined]: Daily equal-weighted 5x5 Size/Book-to-Market reference portfolio returns used to calculate proxy abnormal returns.
- REQ_FF_ME_BREAKPOINTS [undetermined]: Monthly market-equity breakpoints used to assign the size component of the proxy reference portfolio.
- REQ_FF_BEME_BREAKPOINTS [undetermined]: Annual book-to-market breakpoints used to assign the book-to-market component of the proxy reference portfolio.
- REQ_RP_COMPANY_MAPPING [undetermined]: RavenPack company mapping product used to link study firms to RavenPack entity IDs.
- REQ_RP_SOURCE_LIST [undetermined]: RavenPack source-list product required by the supplied media workflow.
- REQ_RP_PR_EQUITIES [undetermined]: RavenPack Web Edition Press Release equities data consumed by the annual link/aggregation macro.
- REQ_RP_DJ_EQUITIES [undetermined]: RavenPack Dow Jones equities/full-edition data consumed by the annual link/aggregation macro.
- REQ_TAQ_RETAIL_CSV [undetermined]: Prebuilt daily retail-investor TAQ classification CSV files expected from the cited Jupyter Hub preparation stage.
- REQ_TAQ_CRSP_LINK [undetermined]: WRDS TAQ–CRSP link table used to assign PERMNO to the retail TAQ CSV rows.
- SW_SAS_94 [unverified]: The inherited environment snapshot lists the SAS 9.4 TS1M8 executable and records a prior startup attempt with return code 1. That does not establish a missing license; runtime/session initialization, WORK-state continuity, and libname visibility remain unverified. This assessment did not start SAS.

## Review notes

- Scope is the complete supplied five-program workflow with the main SAS program split before and after the two Stata programs and the two SAS companions. No separate analysis-only scope is supported by supplied analysis data or an independent analysis-input route.
- Static inspection only: no author program, SAS process, Stata estimation, data transformation, or empirical trial was run. Stata 18 is present in the inherited environment snapshot; SAS 9.4 is listed but the runtime/session and license state remain unverified.
- The exact local row-one probes demonstrate only sampled readability and requested column presence. They do not establish the full population, date coverage, identifiers/joins, or five-year rolling-history sufficiency.
- Credential-sensitive source statements were excluded from displayed excerpts; authentication/session configuration remains unresolved. Author source files were not edited.
- A request was made to the French daily portfolio TXT ZIP URL during static page inspection; the web tool reported a 400 unsupported ZIP content-type error. No usable payload is saved or reported, and the tool exposed no transfer-byte telemetry, so transfer volume is unknown. The saved process-only incident and click-capture records preserve visible arguments, output, and URL, but not the raw wrapper/outer transport or original click timestamp. This incident is not evidence for any scientific route, data availability, or compatibility claim, and its evidence ID is unused.
- Other saved helper and invocation failures remain retained as process-only records. They are not used as scientific evidence; their exact capture limits are preserved in the corresponding records.
- Two saved metadata-preflight attempts found only source-quote construction errors: one quote boundary and code excerpts normalized from CRLF to LF. The corrected excerpts were refreshed from exact cached content_path byte ranges after checking each range against the saved credential-candidate line scan. The two failed attempts and their incomplete outer output captures remain as unused process-only records.
- The first manually written descriptor for the successful third metadata pass was malformed JSON. Its original bytes and the parser error are retained, alongside a corrected descriptor that points to the full helper-written result; this bookkeeping event has no scientific effect and remains unused as evidence.
- Controller finalizer attempt 1 rejected SW_STATA_18 because the software name was written as 'Stata 18' while the inherited successful probe is keyed by the exact name 'Stata'. The retained environment probe identifies version 18, so the software record now uses its matching key; the read-only submitted draft copy and separate-stream finalizer result remain preserved as unused process history.
- Controller finalizer attempt 2 recomputed full_pipeline data_status as undetermined because no mandatory local route is verified for complete field/history coverage, and execution_readiness as blocked because the missing macro-source and TAQ producer issues are classified blocking. The scope claims now match those evidence-derived outcomes; the rejected attempt and read-only submitted copy remain as unused process history.
- The supplied main-SAS comment specifies the interleaved pause/resume sequence. Holding the same SAS process and WORK tables while the other supplied stages run, then resuming at line 1508, is treated as run setup; runtime startup and WRDS session configuration remain separate unresolved checks.
