# Patch proposal: jar-85e23b044255

Delays in Banks’ Loan Loss Provisioning Affect Economic Downturns: Evidence from the U.S. Housing Market

DOI: 10.1111/1475-679X.12415

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete supplied workflow comprises four SAS construction entry points and the Stata analysis entry point. Stage 1 creates delr_call; stage 2 creates foreclosure_my; stage 3 consumes both and creates delr_pre and hmda_13 plus four Stata inputs; stage 4 consumes the stage 1/stage 3 outputs and creates matched_loan.dta; stage 5 loads the four main exports and matched_loan.dta for Tables 2–6. The four packaged .dta files are final-sample identifier lists, not compatible analysis panels, so no analysis_only scope is supported.

Entry points: `1. DLR_Kim_Bank_DLR_Construct.sas`, `2. DLR_Kim_Distressed_Sales_Construct.sas`, `3. DLR_Kim_Main_Construct.sas`, `4. DLR_Kim_Matched_Loan_Construct.sas`, `5. DLR_Kim_Analysis.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 3/12415 - Delays-in-Banks-Loan-Loss-Provisioning-Affect-Economic-Downturns-Evidence-from-the-U-S-Housing-Market/skimdatasheetcodeandidentfiers.zip",
      "sha256": "07ae56a205df3eb42eefb233d2b1e742490eab5faeb0dd6b55f4d0e59838d4a4"
    },
    {
      "path": "JAR-Volume 60/Issue 3/12415 - Delays-in-Banks-Loan-Loss-Provisioning-Affect-Economic-Downturns-Evidence-from-the-U-S-Housing-Market/skimonlineappendix.pdf",
      "sha256": "429615ef5becb03b95bfa516939002c6704fc5fbb71311d98604ac4f1a5aff0f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "8102b7076c42f55b9e7b094b65817988434b8208bee2a07fcf9c6cb747210231"
}
```

## Proposed actions

### A_INPUT_CONTRACTS: Close the author-named source and prepared-table contracts without treating supplied producers as missing files.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_INPUT_CLOSURE
Evidence: E_WORKFLOW_TRACE, E_CATALOG_MATCHES, E_DATA_IDS, E_IDFILE_1, E_IDFILE_2, E_IDFILE_3, E_IDFILE_4

Preparation / proposed procedure:

1. Use any existing authorized author-prepared tables as candidate inputs and record their exact file locations, fields, identifier semantics, and period coverage against the requirement records.
2. For coincident_quarterly, link_crsp, the three jumbo tables, HMDA reporter panel, cbp, irs_all, census_zip, census_msa, FHFA HPI, and CoreLogic HPI, obtain the missing source/version and transformation details where the public or proprietary routes do not establish them.
3. Retain the documented 2010 tract-to-ZCTA largest-population rule and the exact county population join; do not substitute a different crosswalk or geography.
4. Keep delr_call, foreclosure_my, delr_pre, hmda_13, the four Stata analysis exports, and matched_loan.dta as generated producer outputs in their traced order; delr_bank.dta is generated but not consumed by the supplied Stata script.
5. Treat the four packaged .dta files as identifier lists only; they do not form a supported analysis_only route.

Validation to perform later:

- Compare every prepared or acquired source schema, identifier, period, and transformation with the exact SAS join/keep/rename operations before a separately authorized author run.
- Confirm each generated handoff is written before the downstream SAS or Stata consumer reads it.

### A_PUBLIC_INPUTS: Acquire the documented public candidates and prepare their author-compatible SAS tables while retaining the remaining field and construction uncertainties.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CALL, R_COINCIDENT, R_LINK_CRSP, R_TRACT_ZCTA, R_JUMBO_09_16, R_JUMBO_07_08, R_JUMBO_80_07, R_CBP, R_IRS, R_CENSUS_ZIP, R_HPI_FHFA, R_ZCTA_COUNTY, R_CENSUS_MSA
Evidence: E_CODE_CALL, E_CODE_COINCIDENT, E_CODE_LINK_CRSP, E_CODE_HMDA, E_CODE_JUMBO, E_CODE_MATCHED_HMDA, E_CODE_MATCHED_JUMBO, E_CODE_CBPRIRS, E_CODE_HPI, E_CODE_COUNTY, E_CODE_MSA, E_APPENDIX_GEO, E_APPENDIX_HPI, E_PUB_CALL, E_PUB_CRSP_LINK, E_PUB_PHILLY_INDEX, E_PUB_ZCTA_LAYOUT, E_PUB_FHFA_CLL, E_PUB_CBP_ZIP, E_PUB_IRS_ZIP, E_PUB_ACS_ZCTA, E_PUB_FHFA_HPI

Preparation / proposed procedure:

1. Acquire the Call Report quarter history named in code (1997Q1–2010Q4) from the documented Chicago Fed/FFIEC public sources and convert it to compatible quarter members only after checking the required bank and financial fields; preserve rolling-window, lag, and lead history.
2. Prepare the monthly Philadelphia Fed state coincident series as the source for the author's quarterly state/year/quarter/g_index table; record the selected aggregation and state-code mapping because the package does not define them.
3. Obtain the Chicago Fed CRSP-FRB Link candidate for the author-commented 20161231 vintage and verify its entity/permco/date contract before creating link_crsp.
4. Acquire Census 2010 ZCTA-to-tract and ZCTA-to-county relationship files. Use the author-documented largest-population tract assignment for link_zip1, and map STATE, COUNTY, and COPOP for the county-population table.
5. Acquire and prepare the distinct FHFA loan-limit products using the authored keys: the 2009–2016 table is joined on year/county for the supplied 2009–2010 HMDA rows, the 2007–2008 table is joined on year/county, and the year-only 1980–2007 table intersects the main program's combined HMDA 2001–2010 inputs for 2001–2007 and the matched-loan branch for 2004–2006. Verify the one-field mapping and retain the exact authored fallback and missing behavior. The 1980–2000 rows are not required solely because they appear in the source table's filename, and no extra years should be added to fill missing values.
6. Acquire public ZIP-level CBP and IRS SOI source tables and document the transformations into g_emp, g_est, avg_income, and g_gross_income; preserve the authored 2003-from-2004 fill and the actual historical windows.
7. Prepare static Census ACS 2007–2011 ZCTA geography controls as described by the appendix; map each code-used demographic, poverty, education, and population variable to the exact source tables and denominators.
8. Acquire the public FHFA annual ZIP HPI candidate and verify the index variant, ZIP/year keys, and d_hpi transformation before populating hpi_fhfa_zip.
9. Identify the exact public Census MSA population source for msa/total_population. Treat Census 2010 CBSA/MPOP relationship fields as a candidate requiring a demonstrated metro key and deduplication mapping, not as an already-compatible table.

Validation to perform later:

- Before an authorized run, verify that public products cover each code-used year and geography and that every prepared column maps to a source field or documented transformation.
- Check join keys and uniqueness at the code's actual key level; compare generated source tables with the prepared SAS member names and types without changing the authored definitions.

### A_HMDA_INPUTS: Stage the historical HMDA application records and reporter panel in the two formats required by the supplied SAS code.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_HMDA_01_03, R_HMDA_04_10, R_HMDA_REPORTER
Evidence: E_CODE_HMDA, E_CODE_REPORTER, E_APPENDIX_HMDA, E_PUB_HMDA_ARCHIVE, E_PUB_HMDA_CFPB

Preparation / proposed procedure:

1. Use the NARA 1981–2014 public HMDA series as the coverage candidate for the 2001–2006 years; compare the CFPB 2007–2017 records and institution-panel products for 2007–2010 before selecting the appropriate vintage and format.
2. Keep 2001–2003 legacy records separate during preparation and map them to the legacy variable names/format expected by the code; preserve the supplied separate 2004–2010 import and its filters.
3. Prepare the reporter panel with respondent, agency, year, respondent_rssd_id, and name mappings; retain the main program's explicit use of 2004 reporter rows for pre-2004 applications.
4. Prepare and verify the census tract and application fields consumed by both the main and matched-loan programs without changing the authored sample rules.

Validation to perform later:

- Check each year-specific panel's fields, action/type codes, respondent identifiers, tract geography, and format against its exact source code before the SAS construction is separately authorized.
- Verify 2004 reporter fallback behavior and year joins from static field mappings; do not treat a later-year panel as a substitute for earlier HMDA records.

### A_RESTRICTED_INPUTS: Establish an authorized route to the three separate DataQuick products and the CoreLogic HPI variant, without inferring that a catalog miss means no entitlement.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_DQ_TXN, R_DQ_ASSESS, R_DQ_LOAN, R_HPI_CORELOGIC
Evidence: E_APPENDIX_DQ, E_CODE_DQ, E_CODE_DQ_LOAN, E_APPENDIX_HPI, E_CODE_HPI, E_CATALOG_MATCHES

Preparation / proposed procedure:

1. Check whether a permitted local or institutional route already exists for the DataQuick transaction, assessor, and loan files and the author's single-family-detached CoreLogic ZIP HPI product.
2. If a usable route exists, map transaction property/transaction identifiers and sale fields, assessor property/ZIP fields, loan transaction/value/lender fields, and HPI ZIP/year/index fields separately to the supplied code.
3. If source access or file compatibility is not established locally, obtain the permitted author-prepared inputs or the required access/data dictionary; do not substitute unrelated products or bypass source restrictions.

Validation to perform later:

- Confirm permitted access and the exact product, vintage, identifiers, fields, and years before assigning any local availability status or attempting construction.
- Check that the DataQuick joins preserve the authored property/transaction/loan matching rules and that the CoreLogic series is the documented index variant.

### A_PATH_CONFIG: Stage working copies under a coherent host-visible [redacted-path-7ddd666e9867] project tree and point every producer and consumer at the same relative outputs.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_CONFIG
Evidence: E_WORKFLOW_TRACE, E_CODE_MACRO, E_CODE_EXPORT_ZIPR, E_CODE_EXPORT_BANKZIP, E_CODE_EXPORT_APPLICATION, E_CODE_EXPORT_MSA, E_CODE_EXPORT_MATCHED, E_CODE_OUTPUTS

Preparation / proposed procedure:

1. Use a host-visible project root such as [redacted-path-dd92a1ec8309] with distinct code, data/call, data/hmda, data/project, and results directories; do not place Dropbox workspace paths in SAS or Stata configuration.
2. Run SAS from the code directory and configure call, hmda, and dlr LIBNAMEs to the corresponding relative data subdirectories. Copy the supplied macro_winsor.sas into code and change all six authored include calls across the main and matched-loan sources to the staged macro filename.
3. Update every affected raw-input LIBNAME/path and each SAS OUTFILE path in working copies so dlr.delr_call, dlr.foreclosure_my, dlr.delr_pre, and dlr.hmda_13 use the same project data library, and all five Stata-consumed DTA exports land in results.
4. Run Stata from results and change all five authored use paths to the relative basenames delr_zip_r.dta, delr_zip_bank.dta, delr_msa.dta, delr_application.dta, and matched_loan.dta. Keep myreg.xls in the results working directory and preserve the authored replace/append sequence.
5. Use the host's documented batch wrappers with relative or [redacted-path-7ddd666e9867] paths and verify that the selected directories are visible and writable from the host before a separately authorized run.

Validation to perform later:

- Statically compare every changed path across all SAS producers, the six export statements, and all five Stata use statements; verify macro_winsor.sas is present at the include path.
- Before any authorized execution, confirm host-wrapper current directories, data/library visibility, output writability, and preservation of all source files and generated handoffs.

### A_EXPORT_ALIAS: In working copies, align all six supplied Stata-format PROC EXPORT calls to the SAS/ACCESS 9.4 documented DTA identifier. Preserve every output dataset, .dta path, REPLACE behavior, and call order. This supported preparation edit is unapplied; it does not establish or test the installed SAS/ACCESS runtime.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_EXPORT_ALIAS
Evidence: E_PUB_SAS_STATA_FORMAT, E_COORD_DBMS_STATIC_REVIEW, E_CODE_EXPORT_BANK_DLR, E_CODE_EXPORT_ZIPR, E_CODE_EXPORT_BANKZIP, E_CODE_EXPORT_APPLICATION, E_CODE_EXPORT_MSA, E_CODE_EXPORT_MATCHED, E_ENVIRONMENT

**Proposed edit:** `3. DLR_Kim_Main_Construct.sas:375–375`
Source SHA-256: `27c33d67b5c5e479126ac9a63e833bf3978d27f90ba8089fbd6b4a4839aa605f`

Use the documented SAS/ACCESS 9.4 DTA identifier for this Stata .dta export, preserving the dataset and target path.

Current text:
```
            DBMS=STATA REPLACE;
```

Proposed replacement:
```
            DBMS=DTA REPLACE;
```

**Proposed edit:** `3. DLR_Kim_Main_Construct.sas:681–681`
Source SHA-256: `27c33d67b5c5e479126ac9a63e833bf3978d27f90ba8089fbd6b4a4839aa605f`

Use the documented SAS/ACCESS 9.4 DTA identifier for this Stata .dta export, preserving the dataset and target path.

Current text:
```
            DBMS=STATA REPLACE;
```

Proposed replacement:
```
            DBMS=DTA REPLACE;
```

**Proposed edit:** `3. DLR_Kim_Main_Construct.sas:796–796`
Source SHA-256: `27c33d67b5c5e479126ac9a63e833bf3978d27f90ba8089fbd6b4a4839aa605f`

Use the documented SAS/ACCESS 9.4 DTA identifier for this Stata .dta export, preserving the dataset and target path.

Current text:
```
            DBMS=STATA REPLACE;
```

Proposed replacement:
```
            DBMS=DTA REPLACE;
```

**Proposed edit:** `3. DLR_Kim_Main_Construct.sas:1003–1003`
Source SHA-256: `27c33d67b5c5e479126ac9a63e833bf3978d27f90ba8089fbd6b4a4839aa605f`

Use the documented SAS/ACCESS 9.4 DTA identifier for this Stata .dta export, preserving the dataset and target path.

Current text:
```
            DBMS=STATA REPLACE;
```

Proposed replacement:
```
            DBMS=DTA REPLACE;
```

**Proposed edit:** `3. DLR_Kim_Main_Construct.sas:1270–1270`
Source SHA-256: `27c33d67b5c5e479126ac9a63e833bf3978d27f90ba8089fbd6b4a4839aa605f`

Use the documented SAS/ACCESS 9.4 DTA identifier for this Stata .dta export, preserving the dataset and target path.

Current text:
```
            DBMS=STATA REPLACE;
```

Proposed replacement:
```
            DBMS=DTA REPLACE;
```

**Proposed edit:** `4. DLR_Kim_Matched_Loan_Construct.sas:471–471`
Source SHA-256: `dbe54afbe5613c30805bedef380ad049e2a8dfa2ad40a5ab305d896d6f5fed2a`

Use the documented SAS/ACCESS 9.4 DTA identifier for this Stata .dta export, preserving the dataset and target path.

Current text:
```
            DBMS=STATA REPLACE;
```

Proposed replacement:
```
            DBMS=DTA REPLACE;
```

Preparation / proposed procedure:

1. Create working copies of both SAS source files and change only the six listed DBMS tokens from STATA to DTA, retaining each dataset, .dta output path, REPLACE option, and order.
2. Keep the unconsumed delr_bank.dta export aligned with the five analysis-consumed exports so all six calls use the same documented Stata .dta interface.
3. Keep SAS/SAS-ACCESS runtime availability and entitlement as separate host prerequisites; the static preparation proposal does not establish either.

Validation to perform later:

- In a separately authorized compatible SAS/ACCESS environment, verify the six .dta outputs are produced and can be loaded by the supplied Stata script, checking their expected fields and producer-consumer handoffs before evaluating any analysis output. This assessment did not apply the edits or test the syntax/runtime.

### A_SAS_RUNTIME: Confirm the required SAS runtime, statistical and PC-files products, and function lookup table in the execution host.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS_BASE, SW_SAS_STAT, SW_SAS_ACCESS_PCFILES, R_SASHELP_ZIPCODE
Evidence: E_ENVIRONMENT, E_PUB_SAS_EXPORT, E_PUB_SAS_ZIPCITYDISTANCE, E_CODE_DLR, E_CODE_SURVEYSELECT, E_CODE_DISTANCE

Preparation / proposed procedure:

1. Check the existing host SAS 9.4 runtime and appropriate SAS/STAT and SAS/ACCESS Interface to PC Files entitlements; the recorded TKELS startup failure does not establish license absence.
2. Confirm SASHELP.ZIPCODE is installed and has usable ZIP coverage for the six ZIPCITYDISTANCE calls; the table vintage is part of the execution environment.
3. Do not repeat SAS startup, PROC CONTENTS, or other SAS probes in this source assessment.

Validation to perform later:

- Once the runtime is available in a separately authorized execution context, verify the installed products and ZIP lookup table using the platform's ordinary administrative/documentation checks before author execution.

### A_STATA_PACKAGES: Prepare the two missing Stata commands in the selected writable ado path and retain the found IV dependencies.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_IVREGHDFE, SW_OUTREG2
Evidence: E_STATA_METADATA, E_PUB_IVREGHDFE_DEPS, E_PUB_OUTREG2_SSC, E_CODE_STATA_IV, E_CODE_STATA_REG

Preparation / proposed procedure:

1. Install or stage ivreghdfe from its upstream repository and outreg2 from SSC in the selected writable Stata ado path during a separately authorized software-setup step; no package was installed in this assessment.
2. Keep the already-found ivreg2, ranktest, reghdfe, and ftools packages and record versions; compare them with the selected ivreghdfe release before author analysis.
3. Do not replace the authored IV estimator or output command.

Validation to perform later:

- After setup, use Stata metadata-only which/help checks for ivreghdfe, ivreg2, ranktest, reghdfe, ftools, and outreg2; validate exact option compatibility from version-specific static help before a separately authorized run.

### A_RUN_PROCEDURE: Run the complete supplied producer/consumer chain in its source-supported order after all routes, paths, and software are prepared.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E_README_FLOW, E_WORKFLOW_TRACE, E_CODE_CALL_OUTPUT, E_CODE_DQ_OUTPUT, E_CODE_PRE, E_CODE_HMDA13, E_CODE_EXPORT_ZIPR, E_CODE_EXPORT_BANKZIP, E_CODE_EXPORT_APPLICATION, E_CODE_EXPORT_MSA, E_CODE_EXPORT_MATCHED, E_CODE_OUTPUTS

Preparation / proposed procedure:

1. From the code working directory, run 1. DLR_Kim_Bank_DLR_Construct.sas to produce dlr.delr_call.
2. Run 2. DLR_Kim_Distressed_Sales_Construct.sas to produce dlr.foreclosure_my.
3. Run 3. DLR_Kim_Main_Construct.sas after stages 1 and 2; it consumes delr_call and foreclosure_my, creates delr_pre and hmda_13, and writes delr_zip_r.dta, delr_zip_bank.dta, delr_application.dta, and delr_msa.dta. It also writes delr_bank.dta, which the supplied Stata program does not load.
4. Run 4. DLR_Kim_Matched_Loan_Construct.sas after stages 1 and 3; it consumes delr_call, delr_pre, hmda_13, DataQuick transaction/assessor/loan inputs, and supporting fields to produce matched_loan.dta.
5. From the results working directory, run 5. DLR_Kim_Analysis.do after all five Stata-consumed DTA files exist; it analyzes the four main exports plus matched_loan.dta for the supplied Table 2–6 sections and writes myreg.xls using its authored replace/append sequence.

Validation to perform later:

- For any later authorized run, confirm each named producer output exists at the staged path and is readable with the exact downstream keys/fields before starting the next stage.
- Keep execution unverified until the full ordered pipeline completes with the actual required input panels and licensed software; this proposal does not execute it.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: The archive supplies four SAS construction programs, a Stata analysis program, and four readable identifier lists, but no compatible analysis panels or most required source/prepared tables. Required source routes are recorded individually. Remaining gaps include exact field/history mappings for the author-named coincident, bank-link, reporter, jumbo, CBP, IRS, Census, HPI, and DataQuick/CoreLogic inputs. The intermediate producers and consumers traced in the draft are accounted for; the packaged identifier lists do not establish an analysis_only route.
- I_PATH_CONFIG [preparation; full_pipeline]: The supplied SAS LIBNAME/OUTFILE settings and Stata use statements point to absolute Windows paths, and six macro include calls point outside the package even though macro_winsor.sas is supplied beside the scripts. These are staging/path configuration items; the macro itself is present.
- I_EXPORT_ALIAS [preparation; full_pipeline]: The six supplied PROC EXPORT calls spell DBMS=STATA. The SAS/ACCESS 9.4 reference documents DBMS=DTA for Stata .dta import/export, so a coherent six-call DTA alignment is supported working-copy preparation. The coordinator's bounded documentation note also records a historical 9.3 indexed STATA hit but could not retrieve the direct PDF; neither static record establishes the exact installed alias behavior or an execution failure. SAS and SAS/ACCESS runtime availability remain separately unverified in SW_SAS_BASE and SW_SAS_ACCESS_PCFILES.
- R_CALL [undetermined]: The bank-level SAS entry reads the explicitly listed Call Report quarters 1997Q1–2010Q4. Its rolling twelve-quarter construction, lags, and leads require the authored range and compatible input history; the code does not establish those table fields or cross-release mappings.
- R_COINCIDENT [undetermined]: The bank-level construction reads quarterly coincident_quarterly and joins state, year, quarter, and g_index. No producer for that prepared table or exact quarterly aggregation is included.
- R_LINK_CRSP [undetermined]: The bank-level source uses link_crsp to join RSSD entity identifiers to permco and the link's start/end dates. The source comment identifies a 20161231 link vintage; the needed product's author-compatible location and exact fields are not established.
- R_DQ_TXN [undetermined]: DataQuick transaction records feed the 2004–2010 ZIP-year distressed-sales construction and the matched-loan branch. The supplied sources filter by sale type, arm's-length status, date, geography, property ID, and transaction ID.
- R_DQ_ASSESS [undetermined]: DataQuick assessor records are joined to transactions by property ID and provide the site ZIP used to construct ZIP-year distressed-sales measures; the matched-loan workflow also uses assessor geography.
- R_DQ_LOAN [undetermined]: The matched-loan branch joins the separate DataQuick loan product to transaction identifiers and uses the loan value and lender name while matching to HMDA 2004–2006 records.
- R_HMDA_01_03 [undetermined]: The main SAS source separately reads legacy HMDA partitions for 2001–2003, noting the historical format difference, and appends them to 2004–2010 records. These years are explicit code inputs even though the appendix describes the application sample as 2004–2010.
- R_HMDA_04_10 [undetermined]: The main construction reads HMDA 2004–2010; the matched-loan branch reads the 2004–2006 subset. Required fields include application, borrower, property, geography, and lender identifiers; the source tables are not packaged.
- R_HMDA_REPORTER [undetermined]: The main and matched-loan SAS programs consume a separate HMDA reporter panel to map respondent and agency codes to RSSD IDs; the main source also reuses 2004 panel rows for pre-2004 HMDA records.
- R_TRACT_ZCTA [public_acquisition_required]: The main and matched-loan branches require the author-described 2010 tract-to-ZCTA relationship, assigning a tract to the ZCTA containing its largest population. The supplied code consumes the resulting link_zip1 table keyed by fips_code, tract, and zcta5.
- R_JUMBO_09_16 [undetermined]: The main construction reads jumbo_2009_2016 and joins by year and county. Within the supplied HMDA years, only 2009–2010 rows are needed; the code uses its one field as the primary threshold before falling back to the older tables.
- R_JUMBO_07_08 [undetermined]: The main construction reads jumbo_2007_2008 as an earlier fallback in its HMDA threshold chain. Only the code-used 2007–2008 threshold rows matter to this workflow.
- R_JUMBO_80_07 [undetermined]: Main code combines HMDA 2001–2003 with HMDA 2004–2010 before joining the year-only dlr.jumbo_1980_2007 table and constructing jumbo flags ahead of later sample filters, lags, and aggregations; that initial source-relative join intersects 2001–2007. The matched-loan branch separately year-joins the same table for HMDA 2004–2006. The filename's full 1980–2007 span does not make 1980–2000 rows mandatory. Preserve the authored fallback and missing-value behavior; verify the actual joined years without adding rows solely to fill missing values.
- R_CBP [undetermined]: The main and matched-loan constructions consume ZIP-by-year g_emp and g_est from a prepared CBP table. The appendix says these growth rates are constructed from County Business Patterns; the package does not include that source-table producer. Main code uses its 2003 row with the broader panel, while matched loans consume 2004–2006.
- R_IRS [undetermined]: The main and matched-loan constructions consume ZIP-year avg_income and g_gross_income from an IRS SOI table; the appendix says these are author-derived measures. The main code fills 2003 values from 2004. The target input history and transformations are not fully supplied.
- R_CENSUS_ZIP [undetermined]: The main and matched-loan programs join a prepared Census ZIP table and consume demographics, poverty, education, population, and related variables. The appendix names the 2007–2011 ACS five-year ZCTA product and applies static ZIP values across study years, but no source-field table mapping is packaged.
- R_HPI_FHFA [undetermined]: The main SAS program joins a separate FHFA ZIP HPI table by year and ZIP and consumes hpi and d_hpi. The appendix describes the annual FHFA ZIP HPI as public; the supplied package does not include the prepared table or its d_hpi construction.
- R_HPI_CORELOGIC [undetermined]: The main construction reads a separate CoreLogic ZIP HPI table and consumes HOME_PRICE_INDEX and d_price2. The appendix describes this as proprietary and specifies a single-family detached series; local access and author-field compatibility are unknown.
- R_ZCTA_COUNTY [public_acquisition_required]: The main construction reads the 2010 ZCTA-county relationship and joins state/county population into its county-level control construction.
- R_CENSUS_MSA [undetermined]: The main construction reads census_msa and joins total_population by msa_code. The package does not identify the specific Census source year, table, or MSA-to-CBSA mapping.
- R_SASHELP_ZIPCODE [undetermined]: The bank-level source calls ZIPCITYDISTANCE six times. SAS documentation requires SASHELP.ZIPCODE; this implicit lookup dataset is not checked because SAS could not initialize in the supplied environment.
- SW_SAS_BASE [unverified]: Required SAS runtime for the supplied construction programs and ZIPCITYDISTANCE function. The recorded environment probe failed to initialize TKELS at startup; this does not establish a missing SAS license or functional availability. No further SAS executable start was attempted.
- SW_SAS_STAT [unverified]: Required for PROC REG in the bank-level construction and PROC SURVEYSELECT in the matched-loan construction. SAS product entitlement and exact installed functionality remain unknown after the recorded SAS startup failure.
- SW_SAS_ACCESS_PCFILES [unverified]: PROC EXPORT writes six Stata files and SAS documentation says SAS/ACCESS Interface to PC Files must be licensed for DBMS-table export. The environment probe cannot establish this license or resolve the author's DBMS=STATA spelling.
- SW_IVREGHDFE [preparation_required]: The supplied Stata analysis invokes ivreghdfe, but Stata's metadata-only which check did not find it. Its upstream package manifest lists four dependencies—ftools, reghdfe, ivreg2, and ranktest—and all four were found in the checked Stata adopaths. The required ivreghdfe release is not pinned.
- SW_OUTREG2 [preparation_required]: The supplied Stata scripts invoke outreg2 throughout; the metadata-only which check did not find it. The official SSC module record gives a standard installation route. No installation was performed.

## Review notes

- Static review covers only the assigned frozen package variant and all five supplied entry points. Main construction and matched-loan analysis include the authored Tables 2–6 Stata sequence even though the README summarizes Tables 2–5.
- Verified public field routes are limited to the Census 2010 tract-to-ZCTA relationship used under the appendix's largest-population assignment rule and the Census 2010 ZCTA-to-county population relation; acquisition and SAS preparation remain.
- Other source contracts remain unresolved where exact fields, period, identifiers, vintages, or transformations are not established. DataQuick and CoreLogic are documented proprietary products, but their local entitlements are unknown; no absent license is inferred from catalog results.
- The supplied macro_winsor.sas is present. Its six absolute include calls, author Windows paths, and cross-language output locations require the staged configuration in A_PATH_CONFIG.
- The packaged .dta files are identifier lists, not compatible analysis panels, so this draft retains only the full_pipeline scope. Generated delr_call, foreclosure_my, delr_pre, hmda_13, DTA exports, and matched_loan handoffs are not classified as unavailable external inputs.
- Stata 18 metadata found all four declared ivreghdfe dependencies—ftools, reghdfe, ivreg2, and ranktest—while the invoked ivreghdfe command and outreg2 were not found. The prior environment record's SAS TKELS startup failure does not establish license absence; this worker did not start SAS.
- The official SAS/ACCESS 9.4 reference documents DTA for Stata .dta export, supporting a coherent unapplied DTA alignment across all six supplied exports as preparation. The coordinator's bounded static note records a historical 9.3 indexed STATA hit but a timed-out direct PDF fetch; neither establishes the installed 9.4 alias behavior or an execution failure. SAS/SAS-ACCESS runtime availability remains a separate unverified prerequisite, and no source edit or syntax trial was performed.
- The year-only jumbo_1980_2007 join is applied to the main program's combined HMDA 2001–2003 and 2004–2010 source panels before later filters, lags, and aggregations, so its source-relative intersection is 2001–2007; the matched-loan branch uses 2004–2006. The table name does not make 1980–2000 mandatory. Preserve the authored fallback/missing behavior and do not add years solely to fill missing values.
- A malformed first local requirements-section construction was rejected before merging and did not affect findings. The failed helper, input section, captured error, and corrected structured section are preserved in probes as process history and are not used as scientific evidence.
- No author program, regression, estimator, statistical trial, dataset reconstruction, download, installation, or source edit was performed. The only Stata run was the saved metadata-only version/which check; execution_verified remains false.
