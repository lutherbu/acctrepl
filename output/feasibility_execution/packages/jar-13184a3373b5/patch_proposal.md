# Patch proposal: jar-13184a3373b5

Do Strict Regulators Increase the Transparency of Banks?

DOI: 10.1111/1475-679X.12255

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Author-provided Stata workflow from raw bank data through sample construction, main tables and figures, including the separate loan-loss-provision timing companion at the end of code.do.

Entry points: `code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 3/12255 - Do-Strict-Regulators-Increase-the-Transparency-of-Banks/cgw-datasheet-and-code.zip",
      "sha256": "a41d15f6ed4e962e7a862814b7762931ca1fa16b22fe371722a88af365a515c7"
    },
    {
      "path": "JAR-Volume 57/Issue 3/12255 - Do-Strict-Regulators-Increase-the-Transparency-of-Banks/cgw-internet-appendix-tables.pdf",
      "sha256": "fd26e1c8db1b61dd78d79c4ba0c089b3b0d976e97d232d44979885b17b9c9c5d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "1cbd00a607160430428aa0c4aa3aad8d4cb48aee3dca59c36e3c951a3474825e"
}
```

## Proposed actions

### A001: Resolve and stage the required Call Report source files and their conversion contracts before any run.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R001, R002, R003, R004, I001, I002
Evidence: E001, E002, E003, E008, E009, E010, E011, E012, E022

Preparation / proposed procedure:

1. Confirm the intended older Call Report source window against the code comment, datasheet and quarter filters; document the 2010Q1 WRDS/FFIEC handoff and target sample endpoint.
2. Obtain the author-described RSSD, RIAD and RCON/RCFD schedule .dta files if available, or document a compatible official bulk-data-to-Stata preparation route for the required quarter/schedule fields.
3. Stage the FFIEC-era RC.dta and every schedule named in local d, preserving the source quarter keys and field mappings; no downstream variable definitions should be replaced.
4. Keep the code’s source branches and merge/update behavior intact while resolving the raw file vintages and any duplicate bank-quarter handling.

Validation to perform later:

- Check each expected input filename and field against its actual source layout.
- Validate rssd9001-quarter keys, input history, cross-source boundary and 2010Q1–2012Q4 FFIEC coverage before a separately authorized execution.

### A002: Obtain and prepare the state-level regulatory index in the exact format consumed by both analyses.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R005, I003
Evidence: E006, E019, E027

Preparation / proposed procedure:

1. Retrieve or identify the author-linked State Level index file and its documentation.
2. Verify the columns rssd9200 and b, the key uniqueness expected by the m:1 merges, and how the 1996–2011 index period maps to the analysis sample.
3. Prepare alst_cross_states.dta under the configured cleaned-files directory only after confirming the author file’s field mapping; preserve the FedReg replacement rule in code.do.

Validation to perform later:

- Confirm the prepared file and rssd9200 key against both merge sites before any authorized run.

### A003: Establish the compatible quarterly TED input and its historical source before creating TEDRATE.csv.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R006
Evidence: E004, E020, E021, E026

Preparation / proposed procedure:

1. Choose the documented TED source with verified observation history; the local FRB daily file is a candidate, and FRED documents a daily series.
2. Recover the author’s quarterly observation rule or other documented conversion that matches the one-row-per-quarter input expected by code.do; do not assume a quarterly mean or choose a different series.
3. Map the selected series to date and tedrate, retain the required lead/lag window, and save the expected TEDRATE.csv/cleaned TED inputs under the configured root.

Validation to perform later:

- Check one observation per assigned quarter, nonmissing values, date parsing and four-quarter lead/lag availability at both estimation endpoints.

### A004: Acquire the author-compatible HPI and branch-deposit products and prepare them using the code’s specified geographic and column contracts.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R007, R008, R009, R010
Evidence: E005, E013, E014, E023, E024, E025

Preparation / proposed procedure:

1. Identify the correct 2013-era FHFA MSA, state-nonmetro and Puerto Rico input vintages (or documented compatible releases) and preserve each product’s distinct index family.
2. Retrieve the FDIC SOD branch file and verify year, cert, depsumbr, msabr, divisionb and stalpbr against the actual definitions.
3. Prepare the three HPI source layouts to match the code’s positional imports, state/area identifiers and quarter keys; retain the four-quarter forward/backward ratio construction.
4. Confirm that branch geography and HPI geography use compatible identifiers before the SOD-weighted bank-quarter collapse.

Validation to perform later:

- Check actual imported column names, units, geographic code vintages, HPI history and SOD year coverage before the construction stage.

### A005: Recover the full RIE input manifest and both required sets of FFIEC RIE text files.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R011, R012, I004
Evidence: E015, E016, E022

Preparation / proposed procedure:

1. Identify the exact Source Data/filelist.txt expected by the current working-directory transition and verify that each listed filename exists in the RIE quarter directory.
2. Retrieve the dated files generated by the manifest and the additional fixed-date Call Schedule RIE files named in the do-file.
3. Confirm the header rows, textb526/textb527/idrssd fields, filename date substrings and resulting quarter mapping without dropping either RIE branch.

Validation to perform later:

- Check that the generated RIE_data and RIE_data_final keys cover the documented quarters and that the requested source fields survive Stata import.

### A006: Verify and stage the submission-date POR inputs used for the amendment-timeliness regressions.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R013, I002
Evidence: E017, E018, E022

Preparation / proposed procedure:

1. Obtain the exact 21 quarter-end POR files enumerated in code.do and verify idrssd and lastdatetimesubmissionupdatedon in the official historical layouts.
2. Confirm that the expected 2005Q2–2010Q4 file history is intentional for the late dependent variable and resolve whether results after 2010Q4 are expected when other branches append data through 2012Q4.
3. Prepare the dates files at the configured source path while retaining the author’s stated >15-day and >45-day definitions.

Validation to perform later:

- Check quarter coverage and key uniqueness after combining the POR quarters and before the merge to the generated sample.

### A007: Locate or configure the five Stata community commands that the source invokes.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S002, S003, S004, S005, S006, I006
Evidence: E028, E029, E030, E031, E032, E033, E034, E035, E036, E037

Preparation / proposed procedure:

1. Check the Stata 18 adopath for outtable, outreg2, winsor2, eqprhistogram and fastxtile.
2. Where a required command is absent, use its approved installation channel or provide the existing package path in Stata configuration; no installation was performed during this assessment.
3. Record installed package versions and ensure output directories are writable.

Validation to perform later:

- Run `which` for each invoked command in the intended Stata 18 batch environment and confirm that each resolves before a separately authorized project run.

### A008: Configure a coherent host-visible project root for the author’s Stata working-directory changes.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I005
Evidence: E001, E018

Preparation / proposed procedure:

1. Choose the deployed project location under [redacted-path-59bf254f867f] and set the Data root used at the initial A stage and B stage to the same Data directory.
2. Set the C-stage root to that Data directory’s parent so Data/work files/sample resolves to the panel generated in B; preserve the Source Data, cleaned files, work files and Final Results subdirectories.
3. Make the required input and output directories readable/writable in the Stata batch account; do not insert Dropbox workspace paths.

Validation to perform later:

- Confirm each configured absolute [redacted-path-59bf254f867f] path from the corresponding working directory and check write access for generated intermediate/output folders before any authorized run.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The supplied ZIP contains code and documentation but no required raw Call Report schedules, regulator index, TED file, SOD/HPI files, RIE inputs, POR files, or author-generated final sample. The code consumes several different local formats and exact key/field layouts. Public sources document candidate products, but the code-compatible vintages, formats, and required fields are not verified.
- I002 [unresolved; full_pipeline]: The code header describes WRDS 2000Q1–2010Q4 while the datasheet says 2001Q1–2010Q4, followed by FFIEC 2010Q1–2012Q4. Construction filters use quarter<200 and quarter>199, while analysis filters use quarter>163 without a terminal cap. TED uses four-quarter leads/lags, HPI builds four-quarter forward/backward ratios, and late-call-date input files stop at 2010Q4. Exact estimation endpoints and the full supporting raw history (including the HPI forward window) are not reconciled.
- I003 [unresolved; full_pipeline]: alst_cross_states.dta is merged in both the main analysis and independent Figure 6 branch using rssd9200 and index b, but no import or cleaning producer appears in code.do. The author page identifies a state-level index and download link, but the file schema, uniqueness and preparation into the required Stata file remain unverified.
- I004 [unresolved; full_pipeline]: The RIE loop reads ../filelist.txt and imports every listed file; neither the manifest nor its producer is included. The actual date coverage and file-name contract therefore remain unknown, in addition to the separately enumerated dated RIE files.
- I005 [preparation; full_pipeline]: The source sets author-specific absolute Dropbox roots and writes to several relative and nested output directories. A host-visible [redacted-path-59bf254f867f] root and writable directory tree are not configured here. The two root resets themselves are coherent: B saves Data/work files/sample and C reads that same file from the parent root.
- I006 [preparation; full_pipeline]: Five invoked Stata community commands (outtable, outreg2, winsor2, eqprhistogram and fastxtile) were not found by their same-runtime Stata 18 command probes and need to be located or installed from an approved source.
- R001 [undetermined]: RSSD bank identity, charter, regulator and geography quarterly source used to create regmaster. The code reads RSSD and constructs quarter from rssd9999; the input is not packaged and no producer is supplied.
- R002 [undetermined]: RIAD quarterly income-statement and loan-loss items merged to the bank panel and differenced to form quarterly income, charge-offs and provisions. No RIAD source file is packaged.
- R003 [undetermined]: WRDS-era RCON and RCFD Call Report schedule files are read under the named schedule stems, then their actual data columns are selected, merged on rssd9001-quarter and combined with the FFIEC-era branch. The code uses schedule measures for loan, asset, deposit, capital and commitment construction; the complete field/layout contract remains to be checked.
- R004 [undetermined]: FFIEC-era bank Call Report base RC.dta plus the named additional schedule files merged by rssd9001-quarter and converted into the panel variables used in the main analysis.
- R005 [undetermined]: State-level Agarwal–Lucca–Seru–Trebbi regulatory leniency index, consumed as alst_cross_states.dta and merged m:1 on rssd9200 in the main panel and the independent Figure 6 branch. No producer for this Stata file appears in code.do.
- R006 [undetermined]: TED spread observations used to construct quarterly av_ted plus four-quarter leads and lags for the timing specifications. The code reads TEDRATE.csv and does not aggregate daily observations to quarters.
- R007 [undetermined]: FHFA metropolitan-area quarterly all-transactions HPI source, imported from 3q13hpi_cbsa.csv by positional columns; code constructs same-MSA four-quarter forward and backward ratios and later merges on msabr/quarter.
- R008 [undetermined]: FHFA state nonmetropolitan HPI workbook (indexes_nonmetro_thru_13q3.xls), sheet hpi_stsbal; code imports Excel columns A-D as state abbreviation, year, quarter and HPI, then computes four-quarter forward/backward ratios.
- R009 [undetermined]: FHFA Puerto Rico HPI workbook (PR_Downloadable_alltransactions.xls), sheet Puerto Rico--All Transactions; code drops the first six rows, drops column A, reads B-D as year/quarter/HPI, assigns state code PR, and computes four-quarter ratios.
- R010 [undetermined]: FDIC Summary of Deposits branch file SOD_all.dta, used for certificate, branch MSA/division/state geography, year, and deposit weights in the bank-specific HPI construction.
- R011 [undetermined]: Quarterly FFIEC RIE schedule text files dynamically selected by the mandatory ../filelist.txt manifest; code keeps textb526, textb527 and idrssd to construct RIE_data.dta and final restatement text classifications. The manifest and listed source files are not packaged or produced.
- R012 [undetermined]: Additional explicitly enumerated dated FFIEC Call Schedule RIE text files imported separately with textb527 and idrssd and appended to the dynamic RIE_data.dta source.
- R013 [undetermined]: FFIEC CDR Call Bulk POR submission-date text files used to derive lastcalldate, calldate and diffcalldate, then the late amendment indicator in the main analysis.
- S002 [preparation_required]: The supplied code invokes outtable; its Stata 18 `which` probe returned available=false. Locate the ado command in the configured Stata path or set it up from an approved source before an execution attempt.
- S003 [preparation_required]: The supplied code invokes outreg2; its Stata 18 `which` probe returned available=false. Locate the ado command in the configured Stata path or set it up from an approved source before an execution attempt.
- S004 [preparation_required]: The supplied code invokes winsor2; its Stata 18 `which` probe returned available=false. Locate the ado command in the configured Stata path or set it up from an approved source before an execution attempt.
- S005 [preparation_required]: The supplied code invokes eqprhistogram; its Stata 18 `which` probe returned available=false. Locate the ado command in the configured Stata path or set it up from an approved source before an execution attempt.
- S006 [preparation_required]: The supplied code invokes fastxtile; its Stata 18 `which` probe returned available=false. Locate the ado command in the configured Stata path or set it up from an approved source before an execution attempt.

## Review notes

- The scope is the complete supplied code.do program: Call Report and ancillary data construction, the main published-paper tables/figures, and the independent Figure 6 loan-loss-provision timing branch near the end. The companion reloads regmaster and char and separately merges the state index.
- The 6,148-line final_log.smcl is historical output, not evidence of a current run and not a second program. The appendix reports OA tables/sections, but no separate appendix-specific executable workflow is supplied.
- The final bank-quarter sample is created by code.do and is not packaged as an analysis-only input. No compatible prepared-sample route was verified.
- The two Data-root resets in B and C are coherent: B writes Data/work files/sample and C sets its root to the project parent then reads Data/work files/sample. The remaining path issue is that author Dropbox roots and output directories need a host-visible [redacted-path-59bf254f867f] configuration.
- regcoefs.xls is generated by putexcel matrices A1/B1 and read immediately with import excel without firstrow; it is not an external data dependency. Stata default column names A/B feed the Figure 6 calculations.
- No author code was run and no regressions, data downloads, installations, source edits or result generation were performed.
