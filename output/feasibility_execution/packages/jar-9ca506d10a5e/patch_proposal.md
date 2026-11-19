# Patch proposal: jar-9ca506d10a5e

Relative Performance Evaluation and Competitive Aggressiveness

DOI: 10.1111/1475-679X.12431

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied workflow: one native R data-preparation route followed by the substantive table-analysis program embedded in FMT-log-file-tables.pdf. FMT-create-data.pdf is a duplicate rendering of the preparation program, not a second required preparation stage. The final Data assembly/RData producer and some source-to-analysis variable handoffs remain unresolved.

Entry points: `FMT-create-data.R`, `FMT-log-file-tables.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 5/12431 - Relative-Performance-Evaluation-and-Competitive-Aggressiveness/fmt-datasheet-code-and-identifiers.zip",
      "sha256": "4446e10e5eb9d4a367c6521d46864bfb81fd423c22a06b399e96b28e6d8be83c"
    },
    {
      "path": "JAR-Volume 60/Issue 5/12431 - Relative-Performance-Evaluation-and-Competitive-Aggressiveness/fmt-online-appendix.pdf",
      "sha256": "8a80d217200809dec581cb59aa94a634fbfe5dc6ca77507dba34464af8e57db1"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "89db4da7d80375f322ffa5dabf9fa3664b41ec4ff13b89fd5dea53d9455036f3"
}
```

## Proposed actions

### ACT_RAVENPACK_ROUTE: Select one documented RavenPack route and, if using raw events, apply the source-bound writer symbol correction. Input availability, completeness and licensing remain unverified.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: REQ_RAVENPACK_EVENTS, ISSUE_RAVENPACK_HANDOFF
Evidence: E_DASHBOARD_SOURCES, E_R_RAVEN_RAW, E_R_RAVEN_CLEAN, E_R_RAVEN_HANDOFF, E_PACKAGE_INVENTORY

**Proposed edit:** `FMT-create-data.R:783–783`
Source SHA-256: `aebd69449b686f33658213cc0cb3345b9c7b5ed08a0ec9aa729ca06bbc98fa77`

Lines 737-781 construct Ravenpack2 and select GVKEY, DATE, ACTION and all seven action indicators. The commented writer uses the separate raw Ravenpack object, while both downstream consumers read the exact cleaned basename; writing the existing Ravenpack2 object aligns producer, fields and path without changing its filters or transformations.

Current text:
```
# write_csv(Ravenpack, "Ravenpack All (Cleaned).csv")
```

Proposed replacement:
```
write_csv(Ravenpack2, "Ravenpack All (Cleaned).csv")
```

Preparation / proposed procedure:

1. Use a compatible Ravenpack All (Cleaned).csv file if available; it matches the ten-column Ravenpack2 output, and the raw-building segment can be bypassed through setup without requiring a new author permission gate.
2. If the raw route is used, apply the proposed line-783 change from write_csv(Ravenpack, ...) to write_csv(Ravenpack2, ...) so the existing cleaned output is written to the exact basename read at lines 785 and 797.
3. Keep D0001-D0017 as the optional raw alternative only; do not build the raw route as an extra mandatory copy when the compatible prepared file route is used.
4. Preserve the existing source filters, event categories, GVKEY mapping and field order; the actual prepared or raw data files, history and licensing are not verified in this assessment.

Validation to perform later:

- After authorized inputs are available, verify the cleaned file has GVKEY, DATE, ACTION and the seven action indicators, covers the documented years, and is read from the same basename by both downstream consumers.
- For the raw route, review the unapplied line-783 diff against the frozen source hash before any future authorized execution.

### ACT_WRDS_INPUTS: Confirm licensed WRDS product access, exact query schemas and temporal coverage for the annual, incentive, monthly-return and compensation inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMPUSTAT_ANNUAL, REQ_COMPUSTAT_GICS, REQ_ISS_RPE, REQ_CRSP_MONTHLY, REQ_CRSP_LINKS, REQ_EXECCOMP, ISSUE_WRDS_CCM_SETUP, ISSUE_GICS_HISTORY
Evidence: E_DASHBOARD_SOURCES, E_R_WRDS, E_R_COMP_IDS, E_R_GICS, E_R_FUNDA, E_R_ISS, E_R_CRSP_PEERS, E_R_CCM_WRDS2, E_R_CCM_SECOND_LOOKUP, E_R_CRSP_EXECUCOMP, E_CATALOG_LOOKUPS, E_CATALOG_CCM_LOOKUPS, E_CATALOG_SCHEMAS

Preparation / proposed procedure:

1. Confirm authorized WRDS access and the exact Compustat funda/co_industry, ISS Incentive Lab, CRSP monthly and ExecuComp anncomp products; frozen catalog hits are static candidates, not proof that a file is readable or an account can query it.
2. Preserve annual Compustat history needed for the 2006-2017 sample, the prior-year joins and the five-observation rolling statistic; confirm exact row/date bounds after the missing Data sample contract is supplied.
3. Preserve the source's co_hgic query and first-row-per-GVKEY distinct rule as written; record that the historical table's indfrom/indthru ordering can affect which gind is retained, rather than demanding a new current-versus-historical method choice.
4. Confirm ISS coverage through the sample and the prior-year lag, and identify the earliest author-used history for RPE_duration rather than assuming a start year.
5. Provide the exact supported CCM lookup view(s), fields and valid-link rules for both CRSP queries; define or remove the unbound wrds2 reference only after confirming the intended connection/schema. Do not substitute the catalogued CCMXPF tables without field and history compatibility.
6. Confirm CRSP monthly history for each three-year pre/post peer synchronicity window and the matched monthly price dates, plus the ExecuComp annual fields and adjacent year mapping.

Validation to perform later:

- After authorized access, inspect bounded headers/metadata and confirm the queried fields, firm identifiers, effective dates and complete required history for each joint product before running the author code.

### ACT_GET_HP_TNIC3: Acquire the documented official TNIC-3 product for the study's HP peer measures, then prepare both reader formats required by the source.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_HP_TNIC3
Evidence: E_R_HOBERG_TXT, E_R_HP_CSV, E_HP_OFFICIAL_LIBRARY, E_HP_OFFICIAL_README, E_HP_OFFICIAL_YEAR

Preparation / proposed procedure:

1. Use the official Hoberg-Phillips Data Library baseline TNIC-3 product route; no data payload was downloaded in this audit.
2. Retain a single product version and verify it covers the authors' 2006-2017 firm-year range; the current official page reports 1989-2021 coverage, but the historical version used by the authors remains a preparation check.
3. Prepare the tab-delimited tnic3_data.txt and comma-delimited tnic3_data.csv representations from that same product, preserving gvkey1, gvkey2, score and year as read by the native code.

Validation to perform later:

- Before a future run, compare both prepared representations' bounded headers and year coverage with the R read calls, and confirm that year follows the Compustat datadate-year convention.

### ACT_CONFIRM_DATA_PRODUCER: Obtain the missing author-defined final analysis-data producer and the source-to-table measure mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_DATA_ASSEMBLY, ISSUE_SYNCHRONICITY_HANDOFF
Evidence: E_TABLE_RDATA_AND_DATA_FIELDS, E_PDF_PAGE1_RENDER, E_R_SYNCHRO_OUTPUT, E_R_SYNCHRO_RETURN, E_R_SOURCE_END, E_TRACE_WORKFLOW, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the supplied R code that constructs Data and saves FMT-environment.RData, or the exact author documentation needed to identify that producer, its input files and its ordered merge keys.
2. Request the lineage and definition of every Data field consumed by the table program, with specific clarification of PG_SYNCHRONICITY versus the native ACTUAL_IN/ACTUAL_OUT outputs.
3. Extract the full table-analysis program from FMT-log-file-tables.pdf in its original order only after its Data producer/consumer contract is known; retain all tables and model specifications.
4. Do not deserialize an RData file, load author code, build a guessed save.image/fullmerge product, or substitute an unsupported synchronization measure during this feasibility assessment.

Validation to perform later:

- After the authors supply the producer and authorized inputs, compare its exact Data columns and merge keys with the table-code select list, resolve PG_SYNCHRONICITY from documented definitions, and then run the complete supplied sequence under a separately authorized execution step.

### ACT_INSTALL_R_PACKAGES: Prepare the local R 4.5.0 environment with the package set explicitly or functionally required by the native and embedded analysis programs.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_R_PACKAGE_SET, ISSUE_R_PACKAGE_BINDINGS
Evidence: E_R_NATIVE_PACKAGES, E_R_FREAD, E_R_ROLLAPPLYR, E_R_TABLE_PACKAGE_SETUP, E_TABLE_PSYCH, E_R_PACKAGE_METADATA

Preparation / proposed procedure:

1. Install author-compatible versions of tidyverse, lubridate, broom, RPostgres, data.table, zoo, fixest and psych for the installed R 4.5.0 runtime; the supplied files do not pin versions.
2. Use the RPostgres connection only after secure WRDS credentials are configured through an authorized mechanism; do not place secrets in the source file.

Validation to perform later:

- Use a later metadata-only installed.packages/version inventory to confirm the required package versions are present, then defer any author-code execution to a separately authorized run after all data and producer gaps close.

### ACT_BIND_R_HELPERS: Attach the packages providing the native source's unqualified data.table and zoo helpers after those packages are installed.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE_R_PACKAGE_BINDINGS
Evidence: E_R_NATIVE_PACKAGES, E_R_FREAD, E_R_ROLLAPPLYR, E_R_PACKAGE_METADATA

**Proposed edit:** `FMT-create-data.R:4–4`
Source SHA-256: `aebd69449b686f33658213cc0cb3345b9c7b5ed08a0ec9aa729ca06bbc98fa77`

The native code calls fread and rollapplyr without attaching their provider packages; package metadata confirms data.table and zoo are currently absent. This proposed source edit only binds the functions required by the supplied workflow and does not change its transformations.

Current text:
```
lapply(c("tidyverse", "lubridate", "broom"), library, character.only = TRUE)
```

Proposed replacement:
```
lapply(c("tidyverse", "lubridate", "broom", "data.table", "zoo"), library, character.only = TRUE)
```

Preparation / proposed procedure:

1. Apply this proposed line change only during the authorized preparation stage, after installing the packages; psych is called with an explicit namespace and only needs to be installed, while the table source already attaches fixest.

Validation to perform later:

- Review the exact diff against the frozen source hash, then confirm the two function bindings in a later author-approved runtime setup before executing the full program.

### ACT_CONFIGURE_WORKDIRS: Configure the five placeholder working directories for the source's separated input stages.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_WORKDIR_SETUP
Evidence: E_WORKDIR_PLACEHOLDER_1, E_WORKDIR_PLACEHOLDER_2, E_WORKDIR_PLACEHOLDER_3, E_WORKDIR_PLACEHOLDER_4, E_WORKDIR_PLACEHOLDER_5, E_R_RAVEN_RAW, E_R_HOBERG_TXT, E_R_HP_CSV

Preparation / proposed procedure:

1. At FMT-create-data.R lines 719, 918, 1123, 1382 and 1530, set each working directory to the actual directory for that stage's authorized input files and intended outputs; the current literal path is ... in every location.
2. Keep the RavenPack raw/clean handoff and both TNIC-3 representations in the paths consumed by their exact read calls, and record each actual working directory before a future authorized run.

Validation to perform later:

- Before the full run, verify each configured current directory contains the expected input names and that produced intermediates are written where later stages read them; preserve full streams and exit status.

### ACT_EXECUCOMP_PIPELINE_CONTINUATION: Continue the supplied ExecuComp CEO-filter pipeline into its existing transmute so the downstream compensation joins receive the authored fields.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: REQ_EXECCOMP, ISSUE_EXECUCOMP_PIPELINE_CONTINUATION
Evidence: E_R_CRSP_EXECUCOMP, E_R_EXECUCOMP_DOWNSTREAM, E_PDF_EXECUCOMP_DISCONNECTED

**Proposed edit:** `FMT-create-data.R:1343–1343`
Source SHA-256: `aebd69449b686f33658213cc0cb3345b9c7b5ed08a0ec9aa729ca06bbc98fa77`

Line 1343 ends the assignment after the CEO filter while line 1344 starts the intended transmute as a separate expression. The downstream joins at lines 1407-1410, 1421-1424 and 1437-1441 select GVKEY, FYEAR, TOTAL_COMP and CASH_COMP from Execucomp. Appending %>% carries the filtered rows into the existing authored transmute and preserves all listed field definitions and calculations.

Current text:
```
  filter(ceoann == "CEO") 
```

Proposed replacement:
```
  filter(ceoann == "CEO") %>%
```

Preparation / proposed procedure:

1. During ordinary source preparation, append %>% to the end of the line-1343 CEO filter so it flows into the existing transmute on lines 1344-1350; keep the CEO filter, selected fields, replacement rules and compensation calculation unchanged.
2. Treat the same break in FMT-create-data.pdf as a duplicate confirmation of the native source, not a second stage to repair or run.

Validation to perform later:

- At a later authorized full-workflow run, confirm the existing Execucomp object exposes GVKEY, FYEAR, TOTAL_COMP and CASH_COMP at all three downstream joins; no source code was parsed or executed for this audit.


## Remaining issues and prerequisites

- ISSUE_RAVENPACK_HANDOFF [preparation; full_pipeline]: The cleaning block builds Ravenpack2 and selects the ten event-level fields consumed downstream, but the commented writer names the raw Ravenpack object. A source-hash-bound one-line writer change aligns that existing cleaned object with the exact basename read twice later. A compatible prepared cleaned file can instead bypass raw-building through setup; actual files, coverage and licensing remain unverified.
- ISSUE_WRDS_CCM_SETUP [unresolved; full_pipeline]: The native driver contains placeholder WRDS credentials, uses an undefined wrds2 connection for crsp_a_ccm.ccm_lookup, and later queries unqualified ccm_lookup. Frozen catalog hits are different CCMXPF history tables and do not expose all requested CUSIP/TIC/CIK fields; authorized connection, exact schemas, historical link selection and field mapping are unresolved.
- ISSUE_GICS_HISTORY [preparation; full_pipeline]: The supplied code queries gvkey/gind from co_hgic and keeps the first returned row per GVKEY with distinct(GVKEY, .keep_all = TRUE); the frozen catalog labels co_hgic as a history table with indfrom/indthru. Preserve this literal authored row-selection behavior and record its source-order sensitivity as a fidelity limitation; no new current-versus-historical research choice is required to attempt the code as written.
- ISSUE_DATA_ASSEMBLY [unresolved; full_pipeline]: The table program loads FMT-environment.RData and consumes Data, while the complete native preparation source ends at Overlap_match and contains no final Data assembly or environment save. The producer and variable lineage for the analysis-ready environment are not supplied; no RData object was deserialized or guessed at.
- ISSUE_SYNCHRONICITY_HANDOFF [unresolved; full_pipeline]: The native Peer_synchro function returns ACTUAL_IN and ACTUAL_OUT, but the table code requires PG_SYNCHRONICITY. No supported mapping, aggregation or final Data producer documents this measure.
- ISSUE_WORKDIR_SETUP [preparation; full_pipeline]: Five active setwd calls contain literal ... placeholders in the RavenPack, Hoberg-Phillips, peer-match, incentive and overlap-match stages. The intended directories are not documented in the supplied source and need ordinary path configuration.
- ISSUE_R_PACKAGE_BINDINGS [preparation; full_pipeline]: All required R packages checked are absent in the R 4.5.0 environment. The source also calls fread and rollapplyr without attaching their provider packages; install/setup and binding changes are needed before a future run.
- ISSUE_EXECUCOMP_PIPELINE_CONTINUATION [preparation; full_pipeline]: The native ExecuComp assignment filters CEO rows but ends before the following transmute expression, so the intended uppercase GVKEY/FYEAR/TOTAL_COMP/CASH_COMP fields are not constructed by this handoff. Three downstream joins select those fields. Appending a pipe at line 1343 continues the existing CEO-filtered rows into the supplied transmute without changing its calculations; the duplicate preparation PDF shows the same break.
- REQ_RAVENPACK_EVENTS [undetermined]: RavenPack event-level actions used to derive annual action volume, complexity and action-type indicators. Use either the prepared Ravenpack All (Cleaned).csv input or the source's raw 2005-2019 files plus two identifier crosswalks and the supported writer-symbol alignment; do not require both routes.
- REQ_COMPUSTAT_ANNUAL [undetermined]: Compustat annual fundamentals and dated SIC values used to create firm identifiers, performance, size and return measures. The packaged firm-year identifier CSV is an ID aid only; it does not replace this source workflow.
- REQ_COMPUSTAT_GICS [undetermined]: Compustat company GICS classifications used in the peer-match outputs; the local product is historical, while the supplied code takes one row per GVKEY without an effective-date match.
- REQ_ISS_RPE [undetermined]: ISS Incentive Lab companyFY, gpbagrant, gpbarel and gpbarelpeer tables jointly produce RPE plans, goals, peer groups, overlap and duration measures.
- REQ_CRSP_MONTHLY [undetermined]: CRSP monthly returns and prices used for peer synchronicity and compensation valuation.
- REQ_CRSP_LINKS [undetermined]: CRSP/Compustat identifier mapping for the source's peer-return and monthly-price merges, including GVKEY, CUSIP, ticker, PERMNO/PERMCO and CIK fields.
- REQ_EXECCOMP [undetermined]: ExecuComp annual CEO compensation fields used in the supplied robustness and RPE-incentive analyses.
- REQ_HP_TNIC3 [public_acquisition_required]: Official Hoberg-Phillips TNIC-3 pair data consumed as tnic3_data.txt for competition/similarity and tnic3_data.csv for pair-match measures. One source release can feed the two reader formats; do not count duplicate raw downloads as separate inputs.
- SW_R_PACKAGE_SET [preparation_required]: R 4.5.0 is installed, but metadata-only inspection found none of the required packages. Native code calls fread and rollapplyr without explicit attachment; the table program loads fixest and calls psych::describe. No author code or packages were executed for trials.

## Review notes

- The target is the complete author workflow, not an analysis-only bypass: the only packaged data probe is a firm-year identifier list (GVKEY/CIK/FYEAR), while the table program loads an unprovided FMT-environment.RData file and no compatible analysis panel or Data producer is supplied.
- Source order reviewed in full: one native R preparation route (FMT-create-data.R; FMT-create-data.pdf is a duplicate code rendering, not a second preparation stage), followed by the substantive table-analysis code embedded in FMT-log-file-tables.pdf. The preparation order is WRDS/Compustat firm IDs and industries plus GICS; RavenPack cleaned events or the optional raw/crosswalk route; Compustat fundamentals/HHI and TNIC-3 text measures; ISS RPE goals and peers; CRSP monthly returns plus CCM links and peer synchronicity; ISS overlap/duration; CRSP prices and ExecuComp; TNIC-3 CSV peer/overlap matches; the native source ends at Overlap_match, then the table program consumes the separate Data/RData environment.
- The 20 frozen local-file dependency IDs are all accounted for: D0001-D0015 raw RavenPack annual files and D0016-D0017 company-ID crosswalks are the optional raw route; D0018 is the prepared cleaned file or raw-route output; D0019 and D0020 are two reader representations of one TNIC-3 product. RavenPack remains one requirement with alternatives, not a raw rebuild plus a second mandatory cleaned input.
- Catalog lookups are static candidates only. No SAS session, WRDS connection, author code, data transformation, RData deserialization, download or package installation was performed. The only R invocation was a saved --vanilla installed.packages()/R.version metadata script. The only original-page render was page 1 of FMT-log-file-tables.pdf to verify the visually wrapped FMT-environment.RData path; original PDF, selected-page text and PNG hashes are recorded in probes/pdf_p001_review.json.
- The official Hoberg-Phillips library/readme supports a public TNIC-3 route and its GVKEY-pair/score/year fields, with reported coverage through 2021. The author's exact historic release and the two text/CSV representations remain future preparation checks.
- The two public TNIC-3 readme evidence quotes share one URL and total 18 words.
