# Patch proposal: jar-0d503f502470

Responding to Activist Short Sellers: Allegations, Firm Disclosure Choices, and Outcomes

DOI: 10.1111/1475-679X.12356

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Complete author-documented preparation plus both supplied R programs, including the tables workflow and daily/monthly figure branches. The packaged workbook is credited only as a CIK/event-date identifier component; required analysis inputs and full producer closure remain incomplete.

Entry points: `BR-datasheet-and-code/generate_tables.R`, `BR-datasheet-and-code/generate_figures.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 2/12356 - Responding-to-Activist-Short-Sellers-Allegations-Firm-Disclosure-Choices-and-Outcomes/br-datasheet-code-and-identifiers.zip",
      "sha256": "4ce1c7969454af8f4858d5f180467bc4d4a88bc436342eb9a9e7e5874ea0a1a2"
    },
    {
      "path": "JAR-Volume 59/Issue 2/12356 - Responding-to-Activist-Short-Sellers-Allegations-Firm-Disclosure-Choices-and-Outcomes/br-online-appendix.pdf",
      "sha256": "0e567be9fe94d453d594e443ceb5681ec6801c12fe0515f4f5ddb59e8e00b50a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "71b11471aceaee4d954faf6f92be369d5dd3f6a21f33e10e45822721a3c8ab07"
}
```

## Proposed actions

### A-DATA-MASTER: Obtain a complete compatible author-prepared main master and its provenance, or the missing hand-coded inputs plus exact upstream provider extracts and master-building producer/field mappings. Local COMP.FUNDA and dated CCM link tables are a plausible fundamentals preparation route, but do not replace the missing master producer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I001, R-MASTER-PREPARATION, R-CORE, R-RESPONSES, R-MAIN
Evidence: E001, E004, E006, E011, E021, E024, E027

Preparation / proposed procedure:

1. Provide the author-described 421-to-351 sample construction, exclusions, keys, variable construction and master-producing program or equivalent complete field-level handoff.
2. For an author-prepared master route, confirm full analysis rows and all columns consumed by both scripts, plus its relation to the packaged CIK/event-date workbook.
3. For raw-provider routes, identify exact product, identifiers, time coverage, matching sequence and the producer creating this exact master; do not substitute unrelated vendor products.
4. For Table 3 fundamentals, assess local COMP.FUNDA as a candidate and confirm the author's link filters, key conversions, and derived fields; do not require byte-identical CSV input.

Validation to perform later:

- Read bounded workbook metadata and verify exact sheet/header/key/date fields and full sample coverage before execution.
- Statically reconcile produced columns with every downstream table and figure access after the author confirms the handoff.

### A-DATA-FIGURES: Use the checked local Compustat short-interest, CRSP stock/delist/index, and Audit Analytics candidates where compatible; confirm required preparation joins/conversions and the author-specific event-history/population before treating any route as closed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-MEDIA, R-SHORTINT, R-CRSP-DAILY, R-MATCHED-PEERS, R-CRSP-MONTHLY, R-CRSP-MONTHLY-MATCHED, R-AA-AUDITOR, R-AA-RESTATE, R-AAER-I, R-AAER-ANNOUNCE
Evidence: E006, E007, E008, E009, E024, E028, E029, E030, E031, E032, E033, E034, E035

Preparation / proposed procedure:

1. Document exact schema, identifier/date units and historical coverage for media counts, short interest, daily/monthly CRSP, matched controls, AA histories and both AAER figure inputs.
2. Confirm the separate matched-control universe, AAER I workbook and sample announcement-date mapping.
3. Clarify whether the date-parsed crsp_monthly_matched text file is an obsolete read or a required input.
4. Evaluate the current/legacy local short-interest tables and the classic or V2 CRSP stock plus delisting/index sources as combined candidates; document date/key conversions and historical target coverage.

Validation to perform later:

- Check required columns and key/date relationships for each input before building the -90:+90 business-day and -36:+36 month panels.
- Confirm chartdata_monthly.xlsx is generated and consumed inside this same branch, not an input substitute.
- Verify required joined fields, PERMNO/DATE key behavior, and event dates within the author windows; one-row metadata alone does not establish period coverage.

### A-DATA-TABLE3: Use checked local Compustat and Audit Analytics candidates as possible sources for Table 3 Panel B, while obtaining the separate matched-firm population and author construction contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-FUNDA, R-MATCHED-UNIVERSE, R-AAER-D, R-AA-AUDITOR, R-AA-RESTATE
Evidence: E011, E024, E027, E034, E035

Preparation / proposed procedure:

1. Provide funda_prepped.csv and master_matched_firms.xlsx separately, including target/comparison population and identifiers.
2. Provide the AAER D/release-date workbook and separate AA event histories with date fields, coverage and fiscal-year relationship.
3. Confirm the intended rolling-match direction and horizon without changing the design.
4. Assess the bounded COMP.FUNDA and Audit Analytics components as candidates; confirm author-specific transformations, key normalization, populations, and periods.

Validation to perform later:

- Compare actual field names, identifiers and dates with source joins and author comments before branch execution.
- Confirm char company-key to CIK conversion, numeric SAS date conversion, rolling join conventions and required history before branch execution.

### A-IDLIST: For later end-to-end sample-fidelity reporting, compare workbook rows with the author-documented event target. This check does not gate credit for the verified CIK/event-date component.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R-IDLIST
Evidence: E001, E019, E021

Preparation / proposed procedure:

1. At a later authorized full-pipeline stage, compare the workbook's event-date/CIK pairs with the author-documented 351-event target and 1996–2018 period.
2. Record row count, unique event-key counts, and date range; reconcile differences against the documented exclusions.

Validation to perform later:

- Report the resulting population and period comparison as sample-fidelity validation, separate from the verified header-level identifier/date component.

### A-HELPER: Supply the exact shared-helper source and function contracts or an author-approved equivalent.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I002
Evidence: E003, E014, E015, E021

Preparation / proposed procedure:

1. Resolve my_favorite_shared_functions.R, EnsurePackage, fread.zip and winsorize without invoking the installer helper.
2. Document where the helper belongs under the confirmed project root.

Validation to perform later:

- Statically confirm each function used by both programs has a definition and compatible input/output behavior.

### A-PATHBASE: Configure pathbase consistently in both entrypoints so Data and the shared helper resolve under the author project layout.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I003
Evidence: E014, E015

Preparation / proposed procedure:

1. Set pathbase from the documented launch root in both entrypoints.
2. Launch each script from the project root that contains Data and preserve the author directory layout.

Validation to perform later:

- Before a later authorized run, confirm each pathbase/Data and pathbase/Data/R path resolves under the same project root.

### A-WORKDIR: Configure workdir for the target host so the table entrypoint's working-directory change aligns with the project and input layout.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I004
Evidence: E015, E016

Preparation / proposed procedure:

1. Set workdir to the host-visible project directory required by the supplied tables workflow.

Validation to perform later:

- Before a later authorized run, confirm setwd(workdir) resolves to the intended input/output directory.

### A-R-STRING: Remove the unnecessary backslash before the space in the Core data workbook path.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I005
Evidence: E012, E013

**Proposed edit:** `BR-datasheet-and-code/generate_figures.R:33–33`
Source SHA-256: `893c42d092bd3677c41bd6b60826b3c31c33ac1df1172673dbcb443c1f7d54c7`

Remove the invalid backslash-space escape while preserving the intended workbook path and analysis logic.

Current text:
```
master <- data.table(read_excel(paste(data.dir,"/Core\ data/Master_Report_File/Master_Report_Data_Core_V08.xlsx",sep=""),3))
```

Proposed replacement:
```
master <- data.table(read_excel(paste(data.dir,"/Core data/Master_Report_File/Master_Report_Data_Core_V08.xlsx",sep=""),3))
```

Preparation / proposed procedure:

1. Correct only the quoted path spelling and retain the intended Core data directory and analysis logic.

Validation to perform later:

- Compare the source text with the official R escape list; in a later authorized execution, confirm the resolved workbook path before running analyses.

### A-OBJECT-NAMES: Change the two stargazer references to the model names defined immediately above.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I006
Evidence: E017

**Proposed edit:** `BR-datasheet-and-code/generate_tables.R:3648–3649`
Source SHA-256: `572142f544fb426de4449733b8f4085145404145af8c96ace7cd4e67488a00e0`

Use the two model object names defined immediately above the output calls.

Current text:
```
stargazer(selection6_table5a, type="text") 
stargazer(probit_mfx_selection6_table5a, type="text") 
```

Proposed replacement:
```
stargazer(selection6_table5, type="text") 
stargazer(probit_mfx_selection6_table5, type="text") 
```

Preparation / proposed procedure:

1. Correct only the two inconsistent object references.

Validation to perform later:

- Statically confirm both corrected names resolve to earlier definitions and no inconsistent reference remains.

### A-CRSP-MATCHED-READ: Clarify the purpose of the monthly matched CRSP file before editing or waiving the read.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I007, R-CRSP-MONTHLY-MATCHED
Evidence: E008, E021

Preparation / proposed procedure:

1. Confirm whether the parsed object is required, vestigial or omitted from downstream use.

Validation to perform later:

- If confirmed unnecessary, remove only after a source review of later references; otherwise obtain and verify the exact file.

### A-SOFTWARE: Prepare a controlled R library for the packages explicitly requested by the supplied scripts; current approved metadata does not establish their package-level availability or versions. Do not invoke EnsurePackage because its implementation may install packages.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-RPKG-broom, S-RPKG-colorRamps, S-RPKG-corrplot, S-RPKG-data.table, S-RPKG-grDevices, S-RPKG-gtools, S-RPKG-Hmisc, S-RPKG-janitor, S-RPKG-kableExtra, S-RPKG-knitr, S-RPKG-lubridate, S-RPKG-margins, S-RPKG-mefa4, S-RPKG-mfx, S-RPKG-miceadds, S-RPKG-networkD3, S-RPKG-nonpar, S-RPKG-openxlsx, S-RPKG-plyr, S-RPKG-pscl, S-RPKG-psych, S-RPKG-qpcR, S-RPKG-readxl, S-RPKG-RQuantLib, S-RPKG-sampleSelection, S-RPKG-scales, S-RPKG-stargazer, S-RPKG-texreg, S-RPKG-tidyverse, S-RPKG-xtable
Evidence: E038, E039

Preparation / proposed procedure:

1. Resolve the shared helper and its EnsurePackage behavior before any execution.
2. Prepare a controlled R library with the exact package names requested by the tables and figures entrypoints.
3. Record package versions and library paths without running the author programs or invoking the installer helper.

Validation to perform later:

- Before a later authorized execution, verify each package name and compatible version in the chosen R library.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The package supplies the identifier/date workbook and two R programs, not the author-described full master, coded report/response inputs, or the named analysis workbooks. Bounded current metadata confirms some local Compustat, CRSP, short-interest, and Audit Analytics components, but not the author joins, full histories, sample population, or master-producing program. No provider access barrier is established.
- I002 [blocking; full_pipeline]: Both entrypoints source the absent my_favorite_shared_functions.R file. Custom functions include EnsurePackage and fread.zip; winsorize is also called. Their implementation and I/O contracts are unavailable. Do not run the helper because EnsurePackage may install packages.
- I003 [preparation; full_pipeline]: Figure and table entrypoints use pathbase to form data and shared-helper paths; the table entrypoint shows a commented pathbase assignment. Configure a coherent project root before running.
- I004 [preparation; full_pipeline]: The table entrypoint changes the working directory through workdir; configure that directory for the target host and align it with the project root and input layout.
- I005 [blocking; full_pipeline]: The figure entrypoint contains a literal backslash followed by a space in an ordinary R workbook-path string. R documentation states that an escape outside the recognized table is an error; no parser or author-program trial was performed.
- I006 [blocking; full_pipeline]: At table lines 3648–3649 stargazer is passed selection6_table5a and probit_mfx_selection6_table5a. The immediately preceding assignments define selection6_table5 and probit_mfx_selection6_table5; the suffixed names do not occur elsewhere in the supplied file.
- I007 [unresolved; full_pipeline]: The monthly figure source reads and date-parses crsp_monthly_matched_1994-2019.txt, but its required downstream role is not established in the supplied workflow; retain the input requirement pending clarification.
- R-MASTER-PREPARATION [undetermined]: Author-described upstream construction of the final master from hand-coded reports/responses and licensed provider data. The supplied code does not implement this producer or establish exact upstream field contracts.
- R-CORE [undetermined]: Core report workbook sheet 3, the event/report coding source used by the figure program and upstream master preparation.
- R-RESPONSES [undetermined]: Coded press response workbook for event response indicators and upstream master preparation.
- R-MAIN [undetermined]: Main prepared master_matched_firms_funda_crsp.xlsx consumed by both table and figure programs. Distinct from master_matched_firms.xlsx and matched_sample_all_variables.xlsx.
- R-MEDIA [undetermined]: FactSet media-count events keyed by event_id/date for the daily figure baseline and abnormal-media series.
- R-SHORTINT [undetermined]: Short-interest history keyed by gvkey/datadate and shortint, nearest-date matched to daily event panels.
- R-CRSP-DAILY [undetermined]: Daily CRSP history used for return, delisting, volume, quote and market-return fields in the -90:+90 NYSE business-day figure panel.
- R-MATCHED-PEERS [undetermined]: Separate matched_sample_all_variables.xlsx used to form monthly controls, filtered on targeted, cik, funda_permno and fyear.
- R-CRSP-MONTHLY [undetermined]: Monthly CRSP input for target and matched-firm return/delist/price/volume history.
- R-CRSP-MONTHLY-MATCHED [undetermined]: Monthly matched CRSP text file read/date-parsed by the figure program. It has no later source reference, but remains an unmodified-script read pending clarification.
- R-AA-AUDITOR [undetermined]: Audit Analytics auditor-change history used separately for table fiscal-year controls and monthly figures.
- R-AA-RESTATE [undetermined]: Audit Analytics restatement history used separately for table fiscal-year controls and monthly figures.
- R-AAER-I [undetermined]: AAER DGLS I workbook used by the monthly figure branch, distinct from the D/release-date table input and sample announcement workbook.
- R-AAER-ANNOUNCE [undetermined]: Sample AAER announcement-date mapping keyed by event_id and ann_date for monthly figure event timing.
- R-FUNDA [undetermined]: Prepared annual fundamentals CSV used in the Table 3 targeting branch and rolling fiscal-date match.
- R-MATCHED-UNIVERSE [undetermined]: Distinct master_matched_firms.xlsx target/comparison population input used in Table 3 Panel B.
- R-AAER-D [undetermined]: AAER DGLS D workbook with release-date field used by Table 3 and table analyses, distinct from the I variant.
- S-RPKG-broom [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-colorRamps [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-corrplot [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-data.table [unverified]: R package explicitly requested by the tables program and figures program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-grDevices [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-gtools [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-Hmisc [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-janitor [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-kableExtra [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-knitr [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-lubridate [unverified]: R package explicitly requested by the tables program and figures program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-margins [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-mefa4 [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-mfx [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-miceadds [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-networkD3 [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-nonpar [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-openxlsx [unverified]: R package explicitly requested by the tables program and figures program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-plyr [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-pscl [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-psych [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-qpcR [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-readxl [unverified]: R package explicitly requested by the tables program and figures program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-RQuantLib [unverified]: R package explicitly requested by the figures program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-sampleSelection [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-scales [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-stargazer [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-texreg [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-tidyverse [unverified]: R package explicitly requested by the tables program and figures program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.
- S-RPKG-xtable [unverified]: R package explicitly requested by the tables program; the approved current metadata confirms the R runtime but does not establish this package's availability or version.

## Review notes

- This revision credits only the packaged workbook's event_date/cik_key identifier/date component. Its one-row readable probe does not establish population completeness, unique event coverage, target-period coverage, or a complete analysis panel.
- The author-documented 351-event target and 1996–2018 period remain fidelity context for a later end-to-end check; they do not gate the limited component route.
- The full-pipeline scope and all non-identifier data, code, input, and model gaps remain represented. No analysis_only scope or overall readiness outcome was inferred.
- Only current approved source-view quotes and existing registered probe/catalog artifacts are referenced. Withheld source text and source-view/capture manifests are excluded from scientific evidence.
- No new dataset/resource probe, author execution, SAS startup, package install, download, or source patch was performed.
