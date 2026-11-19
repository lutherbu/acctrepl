# Patch proposal: jar-e7b56575956a

Beyond Performance: Does Assessed Potential Matter to Employees' Voluntary Departure Decisions?

DOI: 10.1111/1475-679X.12476

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author-documented raw-to-final dataset workflow using both Stata programs; this scope ends at the analysis-ready Analysis_Data_FINAL.dta file and does not claim to estimate the paper's tables.

Entry points: `Deller_Beyond Performance_Code 1.do`, `Deller_Beyond Performance_Code 2.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 4/12476 - Beyond-Performance-Does-Assessed-Potential-Matter-to-Employees-Voluntary-Departure-Decisions/deller-datasheet-and-code.zip",
      "sha256": "d0ef60bdb959226c110d9a340a40dcf146313289b44bbb358d9be8806ad543f6"
    },
    {
      "path": "JAR-Volume 61/Issue 4/12476 - Beyond-Performance-Does-Assessed-Potential-Matter-to-Employees-Voluntary-Departure-Decisions/deller-online-appendix.pdf",
      "sha256": "ccf9d333a6aebd1909e42242af75b8a76eb7fe95ef3dae3100b563451b536548"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "a227b0fe90fef0d4a177c1f72ab5d48bbdcda473311b6bddee7d0c8d8e45b390"
}
```

## Proposed actions

### A001: Use an already-authorized compatible route for each separate input family, or prepare the author-specified raw workbooks. Confirm the actual source columns, PersonID mapping, annual/rating years and complete ML0/exit coverage before loading; preserve the revised 2010-2014 ratings and the distinct Function mapping. Resolve the updated-rating filename placeholder against the local authorized copy. The unused country-region spreadsheet is not a separate code input.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R001, R002, R003, R004, R005, I001, I003, I004
Evidence: E001, E002, E003, E004, E005, E010, E016, E018, E020, E023, E032, E033, E046, E049

Preparation / proposed procedure:

1. Keep the annual employee snapshots, 2009-2014 exits, 2015 exits, ML0 source, supplemental ratings and Functions_wCount mapping as distinct input families; do not substitute a general public dataset for company employee records.
2. If raw workbooks are used, compare their actual first-row headers and sheet periods with the source fields listed for the relevant year-specific import; preserve the annual t-to-t-1 rating shift and the updated 2010-2014 rating source.
3. If a compatible prepared input is already authorized and documented, assess it as an alternative for only the stage(s) whose schemas and periods it covers; this release does not document a prepared-data bypass.
4. Use the documented workbook copy/save-as preparation only when the authorized source requires it; the availability of Excel is unverified.

Validation to perform later:

- Before any separately authorized run, document the file route, sheet/period coverage, actual input headers, PersonID conversion and every required join key for all five requirements.
- Do not treat masked person-specific source filters as missing scientific definitions; preserve their original operations and order.

### A002: In an isolated working copy, map the shared author project root to a host-visible writable `[redacted-path-ba60ef031de2]` project root and set the Stata working directory there. Align Program 20's Processed_Data_2.dta read directory with Program 19's known same-data output directory, retaining the `Beyond Performance Project/JAR Data` relative path. Preserve separate Data Received, JAR Data, Data Processing_Validity Testing and code directories; use relative subdirectory paths and do not hardcode the Dropbox workspace path into executable configuration.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I002
Evidence: E034, E035, E047, E048

Preparation / proposed procedure:

1. Before any separately authorized batch run, choose a writable host-visible `[redacted-path-ba60ef031de2]` project root and set the Stata working directory there; retain the distinct author Data Received, JAR Data, Data Processing_Validity Testing and code subdirectories beneath the mapped root.
2. In the isolated working copy, align Program 20's read of Processed_Data_2.dta to Program 19's output at `Beyond Performance Project/JAR Data/Processed_Data_2.dta`; these are the same produced data by name, and the omitted Project segment is a known path difference to prepare consistently under the mapped root.
3. Check that mapped output directories are writable and that source-code cleanup commands target only the isolated working copy.

Validation to perform later:

- Statically verify in the working copy that Program 20's relative read resolves to the exact Processed_Data_2.dta produced by Program 19, and that the mapped root preserves the separately named source, intermediate, validation and code directories.
- Before a separately authorized batch run, confirm the chosen `[redacted-path-ba60ef031de2]` root is visible and writable and that required output directories are writable.

### A003: Use the available Stata runtime with its installed `unique` command for the author workflow. Confirm the Excel workbook-preparation route or use already-importable authorized workbook copies; no Stata syntax or data test was performed in this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW001, SW002, SW003, I004
Evidence: E045, E047, E048, E050, E051

Preparation / proposed procedure:

1. Retain the supplied `version 15` declarations when preparing the Stata 18 environment; do not infer incompatibility from the version difference alone.
2. Confirm whether the documented manual Excel operation is needed for the authorized workbook copies; do not assume another spreadsheet editor is equivalent.

Validation to perform later:

- Before a separately authorized run, confirm command availability under the intended host Stata environment and inspect only the returned output artifacts for the expected named stages.

### A004: Only after compatible authorized inputs, the updated-rating filename, spreadsheet preparation (if needed) and host paths are resolved, run Code 1 followed by Code 2 in batch mode from the configured `[redacted-path-ba60ef031de2]` project working directory to create Analysis_Data_FINAL.dta. Keep this as a future procedure; no author code or data run was performed.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R001, R002, R003, R004, R005, I001, I002, I003, I004
Evidence: E005, E006, E008, E027, E031, E043, E049, E050, E051

Preparation / proposed procedure:

1. Invoke each supplied Stata program through the host batch wrapper with the configured project root as its working directory and relative subdirectory paths, using an isolated writable copy of the author folder structure.
2. Preserve the input and output folder structure expected by both ordered Stata programs.
3. Run Code 1 to create annual, exit, ML0, supplemental-rating and merged-panel intermediates; then run Code 2 to create the final analysis-ready panel.
4. Retain the final dataset and the exact run environment; note that the authored programs remove some intermediate files as they proceed.
5. In Code 1, Programs 1-8 convert annual sheets into year-specific employee files; Program 11 appends those into the 2008-2015 panel; Programs 14-15 resolve person-year rows and merge the supplemental ratings; Programs 9-10 feed Program 16's combined exit file.
6. In Code 2, Program 17 consumes the prepared employee panel and combined exits; Program 18 applies the separate Function-to-NEW_FUNCTION mapping; Program 19 writes Processed_Data_2.dta and Program 20 consumes that same named intermediate after A002 aligns its read directory to the producer output; Programs 20-23 build analysis and manager-linked stages; Program 24 consumes Analysis_Data_Prepared.dta and writes Analysis_Data_FINAL.dta.

Validation to perform later:

- Confirm the expected final analysis dataset is present and preserve a separate run log; no estimate/table reproduction claim follows from creation of this dataset alone.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The package contains code and documentation but not the private personnel workbooks. The NDA statement establishes that the authors cannot share their underlying data; it does not establish that this user lacks an authorized compatible source. Current access, identifiers, exact source fields and histories therefore remain unverified.
- I002 [preparation; full_pipeline]: Both supplied Code 2 programs use the same author project root. Program 19 writes Processed_Data_2.dta under Beyond Performance Project/JAR Data; Program 20 reads the same basename under Beyond Performance/JAR Data, omitting the Project segment. The producer-consumer identity and order are supported. In an isolated working copy, map the shared project root to a host-visible writable [redacted-path-ba60ef031de2] root and align Program 20's read directory with Program 19's output directory, preserving the separate Data Received, JAR Data, Data Processing_Validity Testing and code directories. This is a known path-configuration preparation step; no old-machine alias needs proof.
- I003 [unresolved; full_pipeline]: The Code 1 import path for the required updated 2010-2014 ratings retains the literal [HR contact last name] filename placeholder. Resolve it only against an already-authorized local source; do not infer a real name or request contact.
- I004 [preparation; full_pipeline]: For raw Excel inputs, the author documents a manual copy/save-as step that removes the workbook-open protection before Stata imports the files. No such data workbook is packaged, and the environment probe does not confirm Excel availability; if the current compatible source is already in the required importable form, this step may not apply.
- R001 [undetermined]: Annual year-end employee records for management levels 1-5, 2008-2015. Code 1 normalizes varying workbook headers into a PersonID-Year panel with demographics, management/employment history, country/region, unit/function, supervisors, compensation and performance fields. The workbook's performance rating for calendar-year snapshot t is for t-1; 2015 supplies 2014 ratings, not 2015 ratings.
- R002 [undetermined]: Separate employee exit listings for 2009-2014 and 2015. Code 1 converts action dates to Year_Exit and standardizes PersonID and exit reason, employee group, management level, Region and Country fields; Code 2 joins and reconciles these records to employee-year histories on PersonID and Year_Exit_MERGE.
- R003 [undetermined]: Supplemental performance/potential rating inputs: the 2008-2009 two-tab rating workbook and the updated 2010-2014 workbook that replaced an earlier filtered version. These are merged by PersonID and Year into the annual panel; the updated workbook filename in Code 1 contains an unresolved HR-contact-name placeholder.
- R004 [undetermined]: Management-level-0 records used to identify promotion to ML0. The author-named 2009-2014 workbook is read by separate year sheets and also supplies a 2015 sheet; Code 1 creates ML_Year and PromotionDateML0 fields, then Code 2 uses these records in the promotion and manager-characteristic stages.
- R005 [undetermined]: Author-created Functions_wCount workbook used to map raw Function values to broader NEW_FUNCTION categories in Program 18. It is a separate join input and cannot be inferred from employee rows alone.
- SW003 [unverified]: Code 1 documents a manual spreadsheet copy/save-as/unlock preparation step before import. The existing environment probe does not establish Microsoft Excel availability or compatible behavior from another editor; Stata import excel is a separate built-in stage.

## Review notes

- The frozen title matches the datasheet title apart from typographic apostrophe style.
- The author documentation describes these two Stata programs as raw-to-final dataset code. Code 2 ends after saving Analysis_Data_FINAL.dta; no model/table estimation script is supplied here, so this scope does not claim reproduction of the paper's reported estimates.
- The datasheet describes a separate country-to-region spreadsheet, but the supplied complete programs do not read a separate crosswalk; they carry Country and Region fields from employee/exit workbooks. Code 2 separately reads Functions_wCount.xlsx, which is a required join input represented by R005.
- The 2009-2014-named ML0 workbook also has a 2015 sheet in Code 1; the separate ML0 stage is retained through Code 2 manager/promotion processing.
- The first secret-safe scanner helper failed during compilation before source inspection; its helper and capture were preserved. The final strict scan found zero authentication/connection candidates. Its identifier-mask count records conservative presentation candidates only, not the number of people or credentials. Original source programs remain unchanged; structural operation summaries and line hashes are in probes/source_structure.json.
- The only runtime query was a Stata `which unique` metadata lookup. No author program, parser, syntax check, data import, model, descriptive statistic, SAS process or data trial was run.
- Program 19's Processed_Data_2.dta output and Program 20's same-named input form a supported producer-consumer handoff; align the omitted Project directory segment as ordinary working-copy path preparation under the host `[redacted-path-ba60ef031de2]` root.
