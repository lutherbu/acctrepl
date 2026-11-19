# Patch proposal: jar-f7f2a836da01

Economic Consequences of Transparency Regulation: Evidence from Bank Mortgage Lending

DOI: 10.1111/1475-679X.12498

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The seven data preparation and aggregation stages listed in the author instructions, including the bank and fintech branches, both CART classifiers, and the Table 5/6 lending-shift handoff.

Entry points: `SAS and R code/1_infile_Call_Report.sas`, `SAS and R code/1_infile_HMDA.sas`, `SAS and R code/1_infile_HMDA_7only.sas`, `SAS and R code/2_CART_Banks_LoanPurpose1_HomePurchase.R`, `SAS and R code/2_CART_Banks_LoanPurpose3_Refinancing.R`, `SAS and R code/3_match_HMDA_Call.sas`, `SAS and R code/3_match_HMDA_fintechs.sas`, `SAS and R code/4_sample_screens_banks_HMDA.sas`, `SAS and R code/4_sample_screens_fintechs_HMDA.sas`, `SAS and R code/5_additional_sample_screens_and_aggregate_lending.R`, `SAS and R code/6_additional_sample_screen_applications.sas`, `SAS and R code/7_lending shifts.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 5/12498 - Economic-Consequences-of-Transparency-Regulation-Evidence-from-Bank-Mortgage-Lending/nz-datasheet-code-and-identifiers.zip",
      "sha256": "47361b529f2fa6b8bcf71a00fdf1fa7175a54b29de717ab134bee9f1cf56e402"
    },
    {
      "path": "JAR-Volume 61/Issue 5/12498 - Economic-Consequences-of-Transparency-Regulation-Evidence-from-Bank-Mortgage-Lending/nz-online-appendix.pdf",
      "sha256": "c99a3ef3c7f26a2ca4d9f0769b0a9409634755dc9c56fff63de82711be5b826a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "d38889ba07351432da948278c1e29edcfb3b3a6aa1cdbd784feb7d59f9321bd7"
}
```

## Proposed actions

### act_hmda_acquire: Stage the required 2010-2017 historic-schema and 2018-2019 post-2018 HMDA annual inputs by the supplied year-specific readers. Preserve source-year files, the 2010 history required by code, and each branch; verify the author/current-file field mapping before treating either public route as compatible.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_hmda_historical, req_hmda_new_schema
Evidence: E_DATA_HMDA, E_PUB_HMDA_HIST, E_PUBLIC_STATIC_CHECKS, E_HMDA_RAW_READ, E_HMDA7_RAW_READ, E_ID_BANK, E_ID_FINTECH, E_HMDA_HIST_INPUT_BANK_START, E_HMDA_HIST_INPUT_BANK_END, E_HMDA_HIST_INPUT_FINTECH_START, E_HMDA_HIST_INPUT_FINTECH_END, E_HMDA_HIST_CALL_BANK_2010, E_HMDA_HIST_CALL_BANK_2017, E_HMDA_HIST_CALL_FINTECH_2010, E_HMDA_HIST_CALL_FINTECH_2017

Preparation / proposed procedure:

1. Use the CFPB historic page as the documented product candidate for 2010-2017, while obtaining files whose column order and types match the two supplied import2017_prior 78-position INPUT declarations; resolve 2018-2019 as a separate post-2018 schema input.
2. Keep each annual file and the bank and agency-7 branches distinct. Do not require reverse_mortgage or open_end_line_of_credit from historic files; those fields are in the separate post-2018 readers.

Validation to perform later:

- For 2010-2017, check the historic CSV header/position map, 78 input positions, type expectations, and first-row skip against both import2017_prior definitions and year calls; separately check post-2018 fields and the stated downstream panel/CSV handoffs.

### act_hmda_links: Obtain the bank and fintech year-specific HMDA link-table sets, their source/version, year coverage, field contract, and key construction; do not rebuild either crosswalk independently.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_hmda_crosswalks, iss_hmda_crosswalks
Evidence: E_HMDA_JOIN_BANK, E_HMDA_JOIN_FINTECH, E_CATALOG_COMMON, E_TRACE

Preparation / proposed procedure:

1. Obtain the bank and Link_nonbanks year-specific link-table files or author-prepared equivalents with their source/version, year coverage, keys, and output-field contract.
2. Preserve the historic respondent/agency matching and post-2018 LEI matching as separate documented joins; do not reconstruct either crosswalk independently.

Validation to perform later:

- Confirm each year-specific table contains the key and RSSD/agency fields used by its branch and aligns to the corresponding HMDA year before running either join.

### act_call_report: Resolve a compatible author-prepared annual Call Report route or WRDS access for the two tables named in source; the official CDR bulk files are a public alternative candidate, but quarterly-to-annual construction and the complete field mapping remain unverified.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_call_report
Evidence: E_DATA_WRDS, E_CALL_REPORT_READ, E_PUB_CDR, E_CATALOG_COMMON

Preparation / proposed procedure:

1. Request or stage the exact author-compatible call_2007_2011_annual and call_2012_2019_annual inputs with their field/year documentation, or establish the documented WRDS route.
2. If using FFIEC CDR bulk data, obtain an explicit field mapping and annualization specification before deriving these author tables; preserve the early years used to create lagged controls.

Validation to perform later:

- Check source-year coverage, date and RSSD identifiers, and every Call Report item consumed by the supplied producer before matching the controls into bank HMDA observations.

### act_cra_acquire: Acquire or obtain author-prepared CRA lending tables compatible with all0715/all1618/all19. The current FFIEC page documents candidate annual products through the code-required 2010-2019 span, but the author conversion, table versions, and field contract remain unverified.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_cra_lending
Evidence: E_DATA_CRA, E_STAGE7_CRA_READ, E_PUB_CRA_2010, E_PUB_CRA_2019, E_CATALOG_COMMON

Preparation / proposed procedure:

1. Request the author-prepared all0715/all1618/all19 files and source/version notes, or use the official CRA annual products after their exact mappings to those tables are documented.
2. Keep year coverage at the code-required 2010 lower bound and preserve the separate aggregate/disclosure product structure when resolving the conversion contract.

Validation to perform later:

- Check table identifiers, year spans, geography, respondent/agency keys, loan/action fields, and any original-versus-revised file selection against the Stage 7 reader.

### act_cra_transmittal: Resolve the source and construction contract for transmittal_full. The official page lists annual CRA transmittal sheets, but the required combined table and RSSD mapping fields are not documented in this release.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_cra_transmittal, iss_cra_transmittal
Evidence: E_STAGE7_CRA_JOIN, E_PUB_CRA_2010, E_PUB_CRA_2019, E_CATALOG_COMMON

Preparation / proposed procedure:

1. Request the author-prepared transmittal_full table or the code and mapping specification that constructs it from the chosen annual public transmittal sheets.
2. Keep respondent_id2, activity_year, agency_code, rssdid and id_rssd roles distinct until their source and join direction are documented.

Validation to perform later:

- Check unique keys and year/agency coverage against the Stage 7 CRA rows and confirm the RSSD field mapping before joining.

### act_macros: Obtain the exact author macro definitions used for Winsorize_Truncate in both Stage 4 branches and WT in the Stage 7 branches, or a complete documented equivalent specification that preserves their variable lists and 1st/99th-percentile behavior.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: iss_macros
Evidence: E_MACRO_WINSOR, E_STAGE7_WT, E_TRACE

Preparation / proposed procedure:

1. Request Macros.sas and macro_repository.sas with their relevant macro definitions and any required setup dependencies.
2. Keep the bank and fintech input/output names and the authors' declared winsorization variables, percentile bounds, and stage order unchanged.

Validation to perform later:

- Before any separately authorized execution, statically confirm each macro call resolves to the intended definition and output dataset.

### act_paths: Prepare a working-copy root mapping for the author directory tree and configure every affected SAS/R input, output, working-directory, Data, Results, and macro path consistently.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: iss_paths
Evidence: E_CART_R_ROOT, E_MACRO_WINSOR, E_TRACE

Preparation / proposed procedure:

1. Preserve distinct Data, Results, HMDA-link, fintech-link, SAS_Macros, master-bank-files, and CRA locations under a writable host root; do not insert absolute Dropbox workspace paths into executable configuration.
2. Update all affected producing and consuming path calls together in a working copy, retaining the author stages and outputs.
3. Confirm path visibility and write access before any separately authorized run.

Validation to perform later:

- Statically review every producer and consumer path for consistent roots and distinct output directories; no author code is run during this audit.

### act_closure: After the named external datasets, author crosswalks, and macro definitions are obtained or their documented compatible public routes are resolved, reconcile each handoff against the saved ordered trace and confirm the supplied branch outputs before any workflow attempt.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss_closure
Evidence: E_TRACE, E_CATALOG_COMMON, E_HMDA_JOIN_BANK, E_HMDA_JOIN_FINTECH, E_STAGE7_CRA_JOIN, E_MACRO_INCLUDE_BANK, E_MACRO_INCLUDE_FINTECH, E_STAGE7_MACRO_INCLUDE

Preparation / proposed procedure:

1. Use the saved workflow trace as the run-order checklist: both HMDA imports; both CART branches; Call Report controls; bank and fintech matching/screens; Stage 5 bank and combined files; Stage 6 screen.csv; then Stage 7 lending-shift outputs.
2. Resolve the missing HMDA crosswalks, CRA inputs/transmittal, macro definitions, runtime package requirements, and root configuration without changing author analyses.

Validation to perform later:

- Before a future run, confirm each expected generated intermediate exists with the schema and path required by its next consumer; preserve Stage 5 Table 7 aggregates as in-memory objects unless a supplied consumer requires persistence.

### act_sas_setup: Resolve a supported licensed SAS runtime and its initialization configuration; the supplied environment metadata leaves SAS initialization/entitlement unverified.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_sas
Evidence: E_ENV, E_INS_STEP1

Preparation / proposed procedure:

1. Identify a supported SAS installation and confirm entitlement and required runtime components through authorized environment documentation.
2. Record the runtime and initialization settings that can support the supplied SAS sources after the external data, paths, and macro definitions are ready.

Validation to perform later:

- Confirm the intended SAS runtime and its authorized configuration are available before any future workflow execution; do not substitute an unverified runtime.

### act_r_packages: Prepare the seven missing R packages explicitly loaded by the supplied R programs in a supported R environment; preserve the installed rpart 4.1.24 metadata and check compatibility with R 4.5.0.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: sw_r_packages
Evidence: E_R_PACKAGE_META, E_CART_R_LIBS, E_STAGE5_R_LIBS

Preparation / proposed procedure:

1. Install or otherwise provide data.table, caret, rpart.plot, pROC, fixest, dplyr, and tidyverse in the selected R environment using the project environment policy.
2. Record exact package versions and resolve any conflicts with the available R 4.5.0 runtime before a future execution attempt.

Validation to perform later:

- Check package availability for the names imported by both CART branches and Stage 5 without fitting models or changing author code during this assessment.


## Remaining issues and prerequisites

- iss_hmda_crosswalks [unresolved; full_pipeline]: Both HMDA import programs require year-specific respondent/agency crosswalk tables. The two author-specific link directories and join keys are visible in code, but the tables and their source, field contract, and construction steps are absent from the supplied inventory.
- iss_cra_transmittal [unresolved; full_pipeline]: The Table 5 branch joins CRA rows to an absent author transmittal_full mapping to obtain RSSD identifiers. A public annual transmittal-sheet product exists, but its conversion into the required table and exact field contract cannot be established from this release.
- iss_macros [unresolved; full_pipeline]: The two Stage 4 programs include an external Macros.sas file for Winsorize_Truncate, and Stage 7 includes an external macro_repository.sas for WT. The definitions and behavior are not supplied.
- iss_paths [preparation; full_pipeline]: Supplied R and SAS stages use hard-coded D: drive and UNC roots, distinct Data and Results folders, and two external macro roots. A consistent writable host mapping is needed before an attempted run.
- iss_closure [unresolved; full_pipeline]: Mandatory upstream HMDA and Call Report data, two distinct HMDA-to-RSSD/agency link-table sets, CRA lending files, the transmittal_full mapping, and external macro definitions still lack a verified compatible author-prepared or public route. All checklist edges and the supplied producer-consumer order are now accounted for, but the full workflow remains open until those contracts and inputs are resolved.
- req_hmda_historical [undetermined]: Annual HMDA loan-level CSVs for 2010-2017 consumed by both bank and agency-7 import branches. Each import2017_prior macro reads a positional 78-variable historical INPUT declaration, assigns those historical variable names, and is called for each year; it does not include the two post-2018 variables reverse_mortgage or open_end_line_of_credit.
- req_hmda_new_schema [undetermined]: Annual HMDA loan-level CSVs for 2018-2019 in the post-2018 schema. Both import programs use the year-specific post-2018 branch and join on LEI before constructing their distinct bank and agency-7 panels.
- req_hmda_crosswalks [undetermined]: Year-specific HMDA-to-regulatory-identifier link tables in separate bank and Link_nonbanks directories. Historical imports add respondent_rssd and agency_code; post-2018 rows link by LEI. The tables, their schema, and their construction are absent from this release inventory.
- req_call_report [undetermined]: Bank Call Report annual data used to create lagged balance-sheet, funding, profitability, asset-quality, and mortgage-loan controls joined into the bank HMDA sample. The author statement documents 2010-2019 through WRDS; the supplied producer reads call_2007_2011_annual and call_2012_2019_annual, retaining 2009 and later rows before writing 2010 and later output.
- req_cra_lending [undetermined]: CRA disclosure lending tables joined to the bank-county-year lending-shift panel for the Table 5 branch. The code reads all0715, all1618, and all19 then retains activity_year >= 2010; the author statement documents 2011-2019, leaving the 2010 input history to verify.
- req_cra_transmittal [undetermined]: CRA transmittal_full table with respondent_id2, activity_year, agency_code, rssdid, and id_rssd used to map CRA respondents to RSSD identifiers before merging CRA totals into bank-county-year observations. Its source, schema, and construction are not documented in the package.
- sw_sas [unverified]: SAS data preparation and screening scripts are supplied. Supplied environment metadata records unresolved SAS initialization/entitlement; this assessment did not start SAS, query its version, or use startup files.
- sw_r_packages [preparation_required]: The supplied R entry points explicitly use data.table, rpart, caret, rpart.plot, pROC, fixest, dplyr, and tidyverse. Bounded installed-package metadata found rpart 4.1.24 only; the other seven named packages were absent. No package was loaded and no model or author program was run.

## Review notes

- Source-first checkpoint: the frozen title agrees with the paper title in the data statement; author instructions enumerate seven actual preparation and aggregation stages. The delivered entry-point set is the twelve inventoried SAS/R programs, not paper-wide analyses inferred from article or appendix tables.
- The Instructions name the refinance program with a LoanPurpose1_RefinancingLoan variation; the supplied file is LoanPurpose3_Refinancing.R and its actual content classifies loan_purpose 3 (refinancing). Preserve the actual as-downloaded program and its workflow.
- The two packaged DTA files are bank-year and fintech-year identifier lists. Their metadata probes read one row and report file metadata counts of 7,237 and 78 respectively; they are not full HMDA loan-level analysis inputs.
- Stage 5 creates bank_applications.csv and banks_nonbanks_sample_final.csv for later consumers. Its Table 7 branch builds data_banks and data_banks_closed in memory and the supplied file ends without a save or downstream consumer; no output filename is inferred.
- The online appendix describes other analyses using CFPB complaints, RateWatch, and SOD, but corresponding programs are not in this bundle; those paper/appendix descriptions are contextual and do not add stages to this supplied-workflow scope.
- The paper data statement says primary analyses used Stata and R, but this release's supplied code is SAS/R data preparation and aggregation. No Stata entry point or Stata analysis stage is supplied, so it is not added as a required software dependency here.
- The current official static checks were limited to the CFPB HMDA historic page, FFIEC CDR help, and FFIEC CRA flat-file page. The 2018-2019 HMDA page returned only a JavaScript shell; the older author-cited CRA URL returned 404. Both observations and limits are saved in probes/public_static_checks.json; no data links, payloads, endpoints, or forms were requested.
- The official CRA page lists annual transmittal and disclosure products in both 2010 and 2019. This is a candidate public route only: it does not establish the exact all0715/all1618/all19 conversion or the transmittal_full field construction.
- The frozen resource lookup summary contains 13 exact HMDA, Call Report, CRA, crosswalk, and field-name searches, each empty. Catalog misses do not establish local access, licensing, or absence of a compatible author-prepared route.
- R installed-package metadata found rpart 4.1.24 only among the eight package names imported by the supplied R entry points; the other seven were absent. The metadata output and command record are saved; no author program, package import, or model was run.
- An initial evidence-summary aggregation attempt failed because a frozen catalog path was outside the generation directory; its diagnostic is preserved in probes/lookup_named_aggregation_failure.json. A second bounded lookup capture completed with status 0 for all eight named HMDA/CRA queries; the first attempt changed no source or draft evidence.
- Historic HMDA route expectations now follow the two supplied import2017_prior positional INPUT declarations (78 named positions, called for 2010-2017). reverse_mortgage and open_end_line_of_credit are defined only in the post-2018 import branch and remain only under req_hmda_new_schema; historic header/order compatibility remains unverified.
