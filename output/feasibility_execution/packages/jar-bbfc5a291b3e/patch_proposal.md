# Patch proposal: jar-bbfc5a291b3e

The Assignment of Intellectual Property Rights and Innovations

DOI: 10.1111/1475-679X.70035

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied R workflow: patent-data construction followed by the reported tables and analyses.

Entry points: `AGPT-create-data.R`, `AGPT-logfile-tables.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 4/70035 - The-Assignment-of-Intellectual-Property-Rights-and-Innovations/agpt-datasheet-code-identifiers-log-files.zip",
      "sha256": "d42e8d0cf1aa7345d656a006c84378a6932c1c1716df06f1947d96a74db13e6e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "5741442339a6ecf48af3863390d03036dab885058408eb715c00e8bcbe5b5f88"
}
```

## Proposed actions

### A_ACQUIRE_INVENTOR_CHUNKS: Acquire the complete author-published inventor chunk set and stage it at the exact read paths.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_INVENTOR_5M, R_INVENTOR_6M, R_INVENTOR_7M, R_INVENTOR_8M, R_INVENTOR_9M, R_INVENTOR_10M, R_INVENTOR_11M, R_INVENTOR_12M, R_INVENTOR_13M
Evidence: E_AUTHOR_INVENTORS, E_INVENTORS_PRODUCER

Preparation / proposed procedure:

1. Download every 5m–13m inventor archive documented by the author repository.
2. Extract each TSV and rename it to Data/inventor_5m.tsv through Data/inventor_13m.tsv without changing rows or fields.
3. Keep all nine chunk files available together before running the supplied construction stage.

Validation to perform later:

- Check each TSV has patnum, inventor_id, last_name, city, state, and country.
- Confirm all nine exact filenames exist and record row counts and coverage before execution.

### A_ACQUIRE_ASSIGNEE_CHUNKS: Confirm the actual type-code convention for the exact author assignee chunk vintage before treating the public route as compatible, then stage all eight chunks.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_ASSIGNEE_5M, R_ASSIGNEE_6M, R_ASSIGNEE_7M, R_ASSIGNEE_8M, R_ASSIGNEE_9M, R_ASSIGNEE_10M, R_ASSIGNEE_11M, R_ASSIGNEE_12M
Evidence: E_AUTHOR_ASSIGNEES, E_ASSIGNEES_PRODUCER, E_CURRENT_ASSIGNEE_TYPES

Preparation / proposed procedure:

1. Use the exact author release metadata or author clarification to identify the type-code meanings in the selected assignee chunks.
2. The supplied code maps 8/9 to universities, while a separate current dictionary labels 8/9 as government. Treat this as a potential vintage/domain mismatch; do not infer the author chunk values from the separate dictionary.
3. If the exact author vintage is incompatible, obtain a compatible historical vintage or a complete supported crosswalk before use.
4. Extract and rename the eight chunks to Data/assignee_5m.tsv through Data/assignee_12m.tsv.

Validation to perform later:

- Check the seven source columns and compare the actual selected vintage’s type-code definitions with each mapping in the supplied case_when transformation.
- Confirm all eight chunk files and expected population coverage before execution.

### A_ACQUIRE_CITATION_CHUNKS: Acquire the complete author-published US citation chunk set and stage it at the exact read paths.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_US_CITES_5M, R_US_CITES_6M, R_US_CITES_7M, R_US_CITES_8M, R_US_CITES_9M, R_US_CITES_10M, R_US_CITES_11M, R_US_CITES_12M
Evidence: E_AUTHOR_CITATIONS, E_CITATIONS_READ

Preparation / proposed procedure:

1. Download every 5m–12m US citation archive documented by the author repository.
2. Extract each TSV and rename it to Data/us_cites_5m.tsv through Data/us_cites_12m.tsv.

Validation to perform later:

- Check each TSV has patnum and patcite_num.
- Confirm all eight exact filenames and preserve their row counts before execution.

### A_ACQUIRE_PATEX_INPUTS: Select and obtain compatible public PatEx files for the six distinct application, continuity, foreign-priority, transaction, and inventor input contracts.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_APPLICATION_DATA, R_CONTINUITY_PARENTS, R_CONTINUITY_CHILDREN, R_FOREIGN_PRIORITY, R_TRANSACTIONS, R_ALL_INVENTORS
Evidence: E_PATEX_RELEASE, E_PATEX_TECH, E_PATEX_COUNTRY, E_CODE_READS, E_PARENTS_READ, E_CHILDREN_READ, E_FOREIGN_READ, E_TRANSACTIONS_READ, E_ALL_INVENTORS_READ, E_PATEX_PARENT_FIELDS, E_PATEX_CONTINUITY, E_PATEX_OLD_APPLICATION_TYPE, E_PCT_PARENTS_READ, E_PCT_CHILDREN_READ

Preparation / proposed procedure:

1. Use the official PatEx release page to select a vintage with documented fields and coverage compatible with each supplied read.
2. Keep application_data, continuity_parents, continuity_children, foreign_priority, transactions, and all_inventors as separate required input contracts.
3. Keep the raw continuity_children read separate. It requires application_number, child_application_number, and continuation_type; the source also separately reads parent and child feeds for PCT-child detection. The inspected current release documents continuation_type only in continuity_parents, and existing evidence does not prove a parent-row reversal covers all child rows, types, and PCT cases. Obtain a compatible child feed or author-supported complete mapping. Until that equivalence is supported, do not substitute a parent-row reversal.
4. For foreign priority, confirm the exact current country labels and map them to the source’s US versus non-US comparison without changing its meaning.
5. Extract and convert files to the exact Data/*.csv.zip paths after checking their native schemas.

Validation to perform later:

- Compare every source-required field and event/category value with the selected release documentation and downloaded headers.
- Verify application-period and post-filing coverage required by the supplied workflow before running create-data.R.
- Confirm the chosen child source supplies the complete application_number, child_application_number, and continuation_type contract for both child and PCT-detection reads; do not treat parent-row reversal as equivalent without source-supported coverage.

### A_ACQUIRE_HIST_MASTERFILE: Obtain a historical masterfile with the source-required patent, class, and date fields and confirm it covers the construction inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_HIST_MASTERFILE
Evidence: E_HIST_MASTERFILE, E_HIST_MASTERFILE_DOC, E_MASTER_READ

Preparation / proposed procedure:

1. Review the official 2014 masterfile candidate and compare its native columns with patent, uspc, uspc_sub, prior_dt, pub_dt, disp_dt, and exp_dt.
2. If its vintage cannot satisfy the supplied construction period, locate an authorized compatible release or request the authors’ precise source vintage and mapping.
3. Stage the compatible file at Data/historical_masterfile.zip without changing the target sample.

Validation to perform later:

- Check every required field and document the supported date/application coverage before execution.

### A_ACQUIRE_PERMCO: Obtain the required 1976–2023 patent-to-PERMCO mapping or confirm that a later full rematch is acceptable and consistent at both reads.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_PATNUM_PERMCO
Evidence: E_AUTHOR_PERMCO, E_XWALK_READ_ONE, E_XWALK_READ_TWO

Preparation / proposed procedure:

1. Locate the 1976–2023 author vintage used by the source, or obtain author confirmation and a consistent replacement for both code reads.
2. Stage the file as Data/patnum_permco_1976_2023.tsv after verifying patnum and permco.

Validation to perform later:

- Verify both source read sites use the same prepared crosswalk and record its vintage and coverage.

### A_INSTALL_R_PACKAGES: Install the five required R packages in the R 4.5.0 environment before running either supplied script.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_TIDYVERSE, SW_LUBRIDATE, SW_FIXEST, SW_DATA_TABLE, SW_PSYCH
Evidence: E_CODE_SETUP, E_ANALYSIS_SETUP, E_R_PACKAGE_PROBE, E_ENVIRONMENT, E_PSYCH_USE

Preparation / proposed procedure:

1. Install tidyverse, lubridate, fixest, data.table, and psych in the selected R library using an authorized package-management procedure.
2. Keep the R runtime version at the version required by the environment or confirm compatibility before execution.

Validation to perform later:

- Confirm each required package is available to the same R 4.5.0 environment used for both scripts.

### A_CONFIGURE_PROJECT_ROOT: Configure the project root for both supplied R programs so their relative reads and writes resolve.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_WORKING_DIRECTORY
Evidence: E_CREATE_SETUP, E_ANALYSIS_SETUP

Preparation / proposed procedure:

1. Choose the project root containing Data/ and Environments/.
2. Configure setwd in both scripts to that same root, or launch both from a consistent working directory after author-approved setup.
3. Create the Environments directory before the generated RData handoff.

Validation to perform later:

- Check that relative Data/ inputs resolve and that Environments/AGPT - Environment.RData resolves from the analysis script.

### A_EXPORT_RDATA_HANDOFF: Prepare the generated analysis workspace at the exact path and with the exact eight objects consumed by the second script.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_RDATA_HANDOFF
Evidence: E_ANALYSIS_RDATA, E_DATA_FINAL, E_FIRM_PRODUCER, E_AGGLOMERATION_PRODUCER, E_MOVES_ALL_PRODUCER, E_MOVES_CONTROL_PRODUCER, E_INVENTORS_PRODUCER, E_ASSIGNEES_PRODUCER, E_COMBINED_PRODUCER, E_ASSIGNEE_CONSUMER, E_ANALYSIS_CONSUMERS, E_DATA_CONSUMER, E_AGG_CONSUMER, E_FIRM_CONSUMER

Preparation / proposed procedure:

1. After the supplied construction stage creates Data, Data.firm, Data.agglomeration, Moves.all, Moves.to_control, Inventors, Combined, and Assignees, serialize exactly these objects to Environments/AGPT - Environment.RData.
2. Preserve the order: construct first, save the named handoff, then run AGPT-logfile-tables.R, whose startup clears the workspace before loading that file.
3. Do not use save.image or add unconsumed session objects.

Validation to perform later:

- Before running the analysis script, verify the RData contains exactly the eight named objects and the expected file path exists.
- After authorized execution, check that each analysis consumer finds its named object.

### A_REVIEW_MASKED_RANGE: Keep create-data.R lines 242–243 and the additionally observed withheld physical line 276 as bounded unread coverage; request only a reviewed safe source view if closure of these ranges is required.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MASKED_COVERAGE
Evidence: E_SOURCE_INVENTORY

Preparation / proposed procedure:

1. Do not infer an additional input, defect, or inactive branch from the masked ranges alone.
2. Obtain a safe reviewed view of only the bounded ranges before making any further closure claim.

Validation to perform later:

- Reassess the source dependency contract only after a safe view is available.


## Remaining issues and prerequisites

- I_WORKING_DIRECTORY [preparation; full_pipeline]: Both supplied R scripts still contain setwd("...") placeholders. Set the project root consistently so relative Data/ and Environments/ paths resolve.
- I_RDATA_HANDOFF [preparation; full_pipeline]: The analysis script clears its workspace and loads Environments/AGPT - Environment.RData. The construction script produces the eight consumed objects Data, Data.firm, Data.agglomeration, Moves.all, Moves.to_control, Inventors, Combined, and Assignees; prepare that generated handoff after construction by serializing exactly this object set. This is export/handoff preparation, not an additional raw input or unknown scientific construction.
- I_MASKED_COVERAGE [unresolved; full_pipeline]: Approved static source coverage leaves create-data.R lines 242–243 unread and a targeted view also reported physical line 276 withheld as an absolute-path line. These bounded ranges do not establish an additional raw read, defect, or inactive branch; closure remains incomplete pending safe coverage.
- R_APPLICATION_DATA [undetermined]: Raw PatEx application_data source required at Data/application_data.csv.zip; code reads application_number, patent_number, application_type, filing_date, and patent_issue_date.
- R_HIST_MASTERFILE [undetermined]: Raw historical masterfile required at Data/historical_masterfile.zip; source reads patent, uspc, uspc_sub, prior_dt, pub_dt, disp_dt, and exp_dt.
- R_CONTINUITY_PARENTS [public_acquisition_required]: Raw continuity parent relationships required at Data/continuity_parents.csv.zip; code consumes parent_application_number, application_number, and continuation_type.
- R_CONTINUITY_CHILDREN [undetermined]: Raw child continuity file required at Data/continuity_children.csv.zip. The source reads application_number (parent), child_application_number (child), and continuation_type, then normalizes those to internal parent_application_number/application_number names. It separately reads the child feed for PCT-child detection as well.
- R_FOREIGN_PRIORITY [undetermined]: Raw foreign-priority input required at Data/foreign_priority.csv.zip; source expects application_number, foreign_parent_date, and parent_country_code.
- R_TRANSACTIONS [undetermined]: Raw transactions input required at Data/transactions.csv.zip; source consumes application_number, event_code, and recorded_date for EPRQ/NPRQ.
- R_ALL_INVENTORS [undetermined]: Raw all_inventors input required at Data/all_inventors.csv.zip; source consumes application_number, inventor_name_last, and inventor_rank.
- R_INVENTOR_5M [public_acquisition_required]: Required raw inventor chunk Data/inventor_5m.tsv; all 5m–13m chunks are read jointly to construct Inventors.
- R_INVENTOR_6M [public_acquisition_required]: Required raw inventor chunk Data/inventor_6m.tsv; all 5m–13m chunks are read jointly to construct Inventors.
- R_INVENTOR_7M [public_acquisition_required]: Required raw inventor chunk Data/inventor_7m.tsv; all 5m–13m chunks are read jointly to construct Inventors.
- R_INVENTOR_8M [public_acquisition_required]: Required raw inventor chunk Data/inventor_8m.tsv; all 5m–13m chunks are read jointly to construct Inventors.
- R_INVENTOR_9M [public_acquisition_required]: Required raw inventor chunk Data/inventor_9m.tsv; all 5m–13m chunks are read jointly to construct Inventors.
- R_INVENTOR_10M [public_acquisition_required]: Required raw inventor chunk Data/inventor_10m.tsv; all 5m–13m chunks are read jointly to construct Inventors.
- R_INVENTOR_11M [public_acquisition_required]: Required raw inventor chunk Data/inventor_11m.tsv; all 5m–13m chunks are read jointly to construct Inventors.
- R_INVENTOR_12M [public_acquisition_required]: Required raw inventor chunk Data/inventor_12m.tsv; all 5m–13m chunks are read jointly to construct Inventors.
- R_INVENTOR_13M [public_acquisition_required]: Required raw inventor chunk Data/inventor_13m.tsv; all 5m–13m chunks are read jointly to construct Inventors.
- R_ASSIGNEE_5M [undetermined]: Required raw assignee chunk Data/assignee_5m.tsv; all 5m–12m chunks are read jointly to construct Assignees.
- R_ASSIGNEE_6M [undetermined]: Required raw assignee chunk Data/assignee_6m.tsv; all 5m–12m chunks are read jointly to construct Assignees.
- R_ASSIGNEE_7M [undetermined]: Required raw assignee chunk Data/assignee_7m.tsv; all 5m–12m chunks are read jointly to construct Assignees.
- R_ASSIGNEE_8M [undetermined]: Required raw assignee chunk Data/assignee_8m.tsv; all 5m–12m chunks are read jointly to construct Assignees.
- R_ASSIGNEE_9M [undetermined]: Required raw assignee chunk Data/assignee_9m.tsv; all 5m–12m chunks are read jointly to construct Assignees.
- R_ASSIGNEE_10M [undetermined]: Required raw assignee chunk Data/assignee_10m.tsv; all 5m–12m chunks are read jointly to construct Assignees.
- R_ASSIGNEE_11M [undetermined]: Required raw assignee chunk Data/assignee_11m.tsv; all 5m–12m chunks are read jointly to construct Assignees.
- R_ASSIGNEE_12M [undetermined]: Required raw assignee chunk Data/assignee_12m.tsv; all 5m–12m chunks are read jointly to construct Assignees.
- R_PATNUM_PERMCO [undetermined]: Required patent-to-PERMCO crosswalk Data/patnum_permco_1976_2023.tsv; code reads it at two separate points and requires patnum and permco.
- R_US_CITES_5M [public_acquisition_required]: Required US citation chunk Data/us_cites_5m.tsv; all 5m–12m chunks are read jointly to construct Citations.
- R_US_CITES_6M [public_acquisition_required]: Required US citation chunk Data/us_cites_6m.tsv; all 5m–12m chunks are read jointly to construct Citations.
- R_US_CITES_7M [public_acquisition_required]: Required US citation chunk Data/us_cites_7m.tsv; all 5m–12m chunks are read jointly to construct Citations.
- R_US_CITES_8M [public_acquisition_required]: Required US citation chunk Data/us_cites_8m.tsv; all 5m–12m chunks are read jointly to construct Citations.
- R_US_CITES_9M [public_acquisition_required]: Required US citation chunk Data/us_cites_9m.tsv; all 5m–12m chunks are read jointly to construct Citations.
- R_US_CITES_10M [public_acquisition_required]: Required US citation chunk Data/us_cites_10m.tsv; all 5m–12m chunks are read jointly to construct Citations.
- R_US_CITES_11M [public_acquisition_required]: Required US citation chunk Data/us_cites_11m.tsv; all 5m–12m chunks are read jointly to construct Citations.
- R_US_CITES_12M [public_acquisition_required]: Required US citation chunk Data/us_cites_12m.tsv; all 5m–12m chunks are read jointly to construct Citations.
- SW_TIDYVERSE [preparation_required]: The supplied scripts require the tidyverse R package, and the read-only package metadata probe reports it is not installed.
- SW_LUBRIDATE [preparation_required]: The supplied scripts require the lubridate R package, and the read-only package metadata probe reports it is not installed.
- SW_FIXEST [preparation_required]: The supplied scripts require the fixest R package, and the read-only package metadata probe reports it is not installed.
- SW_DATA_TABLE [preparation_required]: The supplied scripts require the data.table R package, and the read-only package metadata probe reports it is not installed.
- SW_PSYCH [preparation_required]: The supplied scripts require the psych R package, and the read-only package metadata probe reports it is not installed.

## Review notes

- Assessed one full-pipeline scope using both supplied R programs. The packaged identifier CSV is a one-row schema/readability sample with coverage_verified=false and is not a full analysis dataset.
- D0001–D0026 remain 26 separate raw-file requirements. D0027 is the generated RData handoff, supported by the supplied producers and the analysis consumer, not an additional raw delivery.
- The generated handoff contains exactly Data, Data.firm, Data.agglomeration, Moves.all, Moves.to_control, Inventors, Combined, and Assignees. Prepare it at Environments/AGPT - Environment.RData before the second script loads it.
- The approved source viewer leaves create-data.R lines 242–243 unread, and a targeted view also reported physical line 276 withheld as an absolute-path line. These bounded limitations are unresolved only; they do not confirm another read, a defect, or a blocker.
- Public routes retain known version and schema differences: the newer PatEx application field is application_invention_type, while earlier releases included application_type; the 2017 full set remains a candidate pending full field/coverage confirmation. continuation_type is carried by continuity_parents, while the distinct raw child-file/type/PCT contract remains unverified. Foreign parent_country needs a verified US/non-US mapping. The supplied assignee code maps 8/9 to universities; a separate current dictionary labels those codes government, but the actual author-chunk convention remains unknown. The PERMCO candidate is a 1976–2025 full rematch.
