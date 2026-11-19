# Patch proposal: jar-e00ce9bb6ed8

The Real Effects of Supply Chain Transparency Regulation – Evidence from Section 1502 of the Dodd-Frank Act

DOI: 10.1111/1475-679X.12530

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | local_available | undetermined |

### full_pipeline

All author-documented branches and supplied companions: Responsible Sourcing (EDGAR preparation, SAS and Stata), Smelters (SAS production plus both Stata exports), and Conflict Minerals (SAS production plus all seven Stata do-files). SAS-created exports are internal producer-to-consumer handoffs in this scope. The two selected in-memory additional-analysis callers also require author-confirmed input and order after SAS production; the generated export set does not resolve that mapping.

Entry points: `1_Responsible_Sourcing/Responsible_Sourcing/edgar_log_downloads/EDGAR_DownloadForms_v2.1.py`, `1_Responsible_Sourcing/Responsible_Sourcing/edgar_log_downloads/EDGAR_log_main.ipynb`, `1_Responsible_Sourcing/Responsible_Sourcing/responsible_sourcing.sas`, `1_Responsible_Sourcing/Responsible_Sourcing/Export/proc_logistic.do`, `1_Responsible_Sourcing/Smelters/smelters.sas`, `1_Responsible_Sourcing/Smelters/Export/smelters.do`, `1_Responsible_Sourcing/Smelters/Export/smelter_level_analysis.do`, `2_Conflict_Minerals/Conflict_Minerals/conflicts_in_covered_countries.sas`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Eastern_DRC_do_file.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Full_Sample_do_file.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Full_Sample_do_file_for_an_additional_analysis.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period_Mining_Regions_do_file.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period_do_file.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period_do_file_for_an_additional_analysis.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/TTTG_Mining_Regions_do_file.do`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

A separate, partial prepared-input route for the two Smelters and all seven Conflict Minerals Stata companion do-files. It uses package-local analysis exports without imposing their SAS raw inputs; caller-load setup is required where a do-file starts with data already in memory. The Mining_Region_Sub_Sample export is retained as a bounded-header candidate but has no established selected caller and is not mandatory.

Entry points: `1_Responsible_Sourcing/Smelters/Export/smelters.do`, `1_Responsible_Sourcing/Smelters/Export/smelter_level_analysis.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Eastern_DRC_do_file.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Full_Sample_do_file.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Full_Sample_do_file_for_an_additional_analysis.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period_Mining_Regions_do_file.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period_do_file.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period_do_file_for_an_additional_analysis.do`, `2_Conflict_Minerals/Conflict_Minerals/Exports/TTTG_Mining_Regions_do_file.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 2/12530 - The-Real-Effects-of-Supply-Chain-Transparency-Regulation-Evidence-from-Section-1502-of-the-Dodd-Frank-Act/o7cm5bgly2hyuprio8s3xyuf9f5tvnq7.zip",
      "sha256": "eeee51bd81a4b281cfdde76a249b8b681c3f1db0c3d0dce69ff0e703fc89df2e"
    },
    {
      "path": "JAR-Volume 62/Issue 2/12530 - The-Real-Effects-of-Supply-Chain-Transparency-Regulation-Evidence-from-Section-1502-of-the-Dodd-Frank-Act/behp-online-appendix.pdf",
      "sha256": "e1c20656ca6bba92e1149d867c3724659ef4e67a25af30c64f415b9eead41b16"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "f2770943e6e1f7577616f92abfe93b90a12a9bb832fd1586659e599ef2d1d380"
}
```

## Proposed actions

### A-RESP-SOURCE-MAP: Confirm the exact author-compatible sources and member contracts for the six missing Responsible Sourcing tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-RESP-INPUTS, R-RESP-BAYER-BASE, R-RESP-COMPU-FUNDA, R-RESP-COMPU-FUNDA-SGNA, R-RESP-MECH-DI-DATA, R-RESP-CUSIP, R-RESP-CCM-LINK
Evidence: E-RESP-SAS-INPUTS, E-READMES-RESP, E-CATALOG-CHECKS, E-CATALOG-FUNDA, E-CATALOG-CCM, E-CATALOG-SEC

Preparation / proposed procedure:

1. Confirm the exact source/export and field, key and period contract separately for Bayer_Base, Compu_Funda, Compu_Funda_SGNA, Mech_DI_DATA, CUSIP and CCM_Link.
2. Treat the frozen COMP.FUNDA, CCM link-history and CIK–CUSIP catalog rows as candidates only; verify exact member mapping and current authorized access before later use.
3. Preserve the authored joins and transformations; do not substitute a catalog candidate solely because its product name is similar.

Validation to perform later:

- Before any later authorized run, confirm each SAS libref member and exact required fields, keys and period against the supplied SAS code.

### A-RESP-PACKAGED-READ: Resolve the two packaged SAS files' unsupported-character-set metadata errors through an author-confirmed supported encoding or a sanitized header/metadata export.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-RESP-READABILITY, R-RESP-EDGAR, R-RESP-HANDCOLLECTED
Evidence: E-PACKAGED-INPUT-META, E-RESP-SAS-INPUTS

Preparation / proposed procedure:

1. The frozen metadata helper exposes no encoding option; do not repeat the same failing read or start SAS during this assessment.
2. Ask the author for the intended encoding/read settings or a safe metadata export for edgar_log_data.sas7bdat and handcollected_combined.sas7bdat.

Validation to perform later:

- Confirm only the required field names, types and period; do not infer full coverage from a header-only check.

### A-EDGAR-HANDOFF: Confirm the intended EDGAR log period, exact notebook input route and temporary lookup/error-file handoff without requesting secrets or issuing requests.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-EDGAR-SCOPE, I-EDGAR-TEMP-HANDOFF, R-RESP-EDGAR, R-EDGAR-LM-INDEX, R-EDGAR-INDEX, R-EDGAR-LOOKUP, R-EDGAR-ERROR
Evidence: E-READMES-RESP, E-EDGAR-DATE-CONFIG, E-EDGAR-IDX-CONFIG, E-EDGAR-TEMP-BRANCH, E-REDACTED-HELPERS, E-PUB-SRAF-EDGAR, E-PUB-SEC-EDGAR

Preparation / proposed procedure:

1. Ask whether the April 2017 notebook settings and 2016–2017 index are an intended distinct branch or stale settings relative to the documented 2014–2016 log table.
2. Ask for a sanitized description of the LookupEDGAR request route and the producer/consumer contract for temp_lookup_df.pkl and temp_error_df.pkl; never provide credential values.
3. Confirm whether the packaged edgar_log_data table is the intended prepared-input bypass for SAS.

Validation to perform later:

- Use the author-confirmed branch order and exact package-relative files; do not access SEC payloads or deserialize pickles as part of this audit.

### A-SMELTER-PREP: Obtain the author-prepared smelter_level_data input and the omitted preparation code/specification for its historical issuer and conformance mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-SMELTER-UPSTREAM, R-SMELTER-LEVEL
Evidence: E-READMES-SMELTERS, E-SMELTER-SAS-INPUT, E-PACKAGE-INVENTORY, E-PUB-RMI

Preparation / proposed procedure:

1. Confirm whether the documented smelter_downloads code exists in another release and provide the matching smelter_level_data table.
2. Confirm Entity_ID, year, conformance status, SEC issuer counts, source coverage, RMI ID match history and exact source-to-output contract.
3. Keep the packaged smelters.dta analysis route separate from the missing SAS preparation input.

Validation to perform later:

- Before any later authorized run, match the supplied prepared input's fields and period to both the SAS producer and Stata consumers.

### A-SAS-WORKDIR: Configure all SAS branch roots and exports in an isolated working copy while preserving branch names and producer/consumer order.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I-SAS-PATHS
Evidence: E-RESP-SAS-PATHS, E-SMELTER-SAS-INPUT, E-CONFLICT-SAS-PATHS

Preparation / proposed procedure:

1. Map the Responsible_Sourcing libname and includes to its supplied branch folder.
2. Map the Smelters libname and winsor include to the supplied Smelters folder.
3. Map the Conflict_Minerals libname and winsor include to the supplied Conflict_Minerals folder and Exports directory.
4. Keep generated names used by each downstream analysis and do not alter the originals.

Validation to perform later:

- Review every configured input, include and output against package inventory before any later authorized run.

### A-SAS-RUNTIME: Resolve the SAS runtime startup state in a separately authorized, properly initialized SAS 9.4 environment.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-SAS-STARTUP, SW-SAS
Evidence: E-ENVIRONMENT

Preparation / proposed procedure:

1. Confirm runtime startup and site configuration where later execution is explicitly authorized; the recorded TKELS diagnostic does not establish license absence.

Validation to perform later:

- Confirm SAS 9.4 initializes successfully before any author SAS workflow is attempted.

### A-SMELTER-ANALYSIS-PATH: Map both Smelters Stata companions to the SAS-produced smelters.dta in full_pipeline or the exact package-local smelters.dta in analysis_only, while preserving their distinct results.

Scopes: full_pipeline, analysis_only. Type: configuration. Certainty: supported.
Addresses: I-SMELTER-ANALYSIS-PATH, R-SMELTER-EXPORT
Evidence: E-SMELTER-DO-PATHS, E-ANALYSIS-DTA-META, E-READMES-SMELTERS

Preparation / proposed procedure:

1. For full_pipeline, map the authored [redacted-path-79efc1d300d5] path in smelters.do to the SAS stage's smelters.dta output under the Smelters branch.
2. For analysis_only, map both companions to the package-local Smelters/Export/smelters.dta file.
3. Retain the separate smelter_level_analysis.do and its Table_3 output, plus smelters.do and its T3_smelters output.

Validation to perform later:

- Confirm both drivers resolve to the exact packaged Stata file and write to their intended output folders.

### A-CONFLICT-SAS-META: Resolve the unsupported-character-set metadata errors for the eleven Conflict Minerals SAS inputs before relying on their schemas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-CONFLICT-SAS-METADATA, R-CONFLICT-SAS-ACLED-NEW, R-CONFLICT-SAS-IPIS-FULL, R-CONFLICT-SAS-BCRT-BASELINE, R-CONFLICT-SAS-BCRT-BASELINE-1-1, R-CONFLICT-SAS-ISO-CODES, R-CONFLICT-SAS-YEAR, R-CONFLICT-SAS-YEAR-YYYYMM, R-CONFLICT-SAS-POLITY-DATA-CSV, R-CONFLICT-SAS-THEGLOBALECON-2, R-CONFLICT-SAS-TERR, R-CONFLICT-SAS-PLOS-MLMV-B, R-CONFLICT-SAS-MINERAL-PRICES
Evidence: E-PACKAGED-CONFLICT-META, E-ENVIRONMENT, E-CONFLICT-SAS-INPUTS

Preparation / proposed procedure:

1. Ask for supported encoding/read settings or a sanitized metadata export for the eleven affected package-local SAS tables.
2. Keep the successful mineral_prices header result bounded to the one-row metadata sample.

Validation to perform later:

- Confirm fields, types and period needed by the SAS branch without inferring full coverage from the metadata sample.

### A-PROCLOGIT-HANDOFF: Load the SAS-generated proc_logistic.dta into Stata memory before invoking the supplied proc_logistic.do companion.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I-PROCLOGIT-HANDOFF
Evidence: E-READMES-RESP, E-PROCLOGIT-PRODUCER, E-PROCLOGISTIC-DOFILE

Preparation / proposed procedure:

1. Complete the Responsible Sourcing SAS stage so it writes Table_1a to proc_logistic.dta.
2. In the Stata caller, load that exact generated file before running the five-line do-file, which begins with egen and has no use statement.
3. Keep the authored model and output path unchanged; no author code was run during this review.

Validation to perform later:

- Check that the caller's loaded dataset is the SAS-generated proc_logistic.dta before any later authorized Stata run.

### A-EASTERN-QUOTE: Propose the exact closing-quote repair for the Eastern_DRC use line in a separate working copy; resolve the path there as a separate configuration step.

Scopes: full_pipeline, analysis_only. Type: source_edit. Certainty: supported.
Addresses: I-EASTERN-LOAD, R-CONFLICT-EASTERN
Evidence: E-EASTERN-LOAD, E-ANALYSIS-DTA-META

**Proposed edit:** `2_Conflict_Minerals/Conflict_Minerals/Exports/Eastern_DRC_do_file.do:1–1`
Source SHA-256: `889f0f61bcc9bf9f93fbc611bf0b68e337235066c88f9e01a8610f1825918451`

The existing first line opens a quoted path but has no closing double quote; this exact edit only closes the string.

Current text:
```
use "[redacted-path-68354cee593b]
```

Proposed replacement:
```
use "[redacted-path-68354cee593b]"
```

Preparation / proposed procedure:

1. Apply only the quoted-line repair to a separate working copy if approved for later execution.
2. Configure the path to the packaged Eastern_DRC.dta for the operating system and working directory.

Validation to perform later:

- Review the revised path and source line statically; no syntax trial or author-code run was performed.

### A-TTTG-HANDOFF: Load the same TTTG_Mining_Regions.dta export into the Stata caller before the in-memory TTTG companion: use the SAS-produced output in full_pipeline or the separately packaged file in analysis_only.

Scopes: full_pipeline, analysis_only. Type: configuration. Certainty: supported.
Addresses: I-TTTG-HANDOFF, R-CONFLICT-TTTG
Evidence: E-TTTG-PRODUCER, E-TTTG-DOFILE, E-ANALYSIS-DTA-META

Preparation / proposed procedure:

1. After the Conflict SAS producer completes, load its TTTG_Mining_Regions.dta output before invoking the Stata do-file.
2. For analysis_only, load the packaged TTTG_Mining_Regions.dta route before invoking the same do-file.
3. Retain the one-row header and full-period coverage limitation; do not infer data completeness from load setup.

Validation to perform later:

- Review the caller's loaded-file path against the selected producer or packaged route before any later authorized analysis run.

### A-STATA-ADDONS: Make required Stata commands available in an authorized environment; no installs were performed during this assessment.

Scopes: full_pipeline, analysis_only. Type: software_setup. Certainty: conditional.
Addresses: I-STATA-ADDONS, SW-STATA-ADDONS
Evidence: E-SOFTWARE-REVIEW, E-SAFE-COMMAND-SCAN, E-CONFLICT-README-REQUIREMENTS, E-PUB-SSC, E-PUB-OUTREG2, E-PUB-XTPSSE, E-PUB-FECT

Preparation / proposed procedure:

1. Identify and authorize suitable sources for missing outreg2, xtpsse and fect packages.
2. Identify the exact tmpdir command or helper expected by my_reg2hdfespatial.ado; do not substitute another command without confirmation.
3. Do not install _gwtmean or ihstrans unless the author confirms those install-only lines are required.

Validation to perform later:

- Before later execution, use exact bounded which checks to confirm required commands and versions in the configured Stata adopath.

### A-LOCAL-ADO-PATH: Add the package's supplied Conflict_Minerals/Personal folder to the working-copy Stata adopath so the provided spatial helper files can resolve.

Scopes: full_pipeline, analysis_only. Type: configuration. Certainty: supported.
Addresses: I-LOCAL-ADO-PATH, SW-LOCAL-ADO
Evidence: E-CONFLICT-README-REQUIREMENTS, E-SOFTWARE-REVIEW, E-SAFE-COMMAND-SCAN

Preparation / proposed procedure:

1. Configure the ado path to the supplied Personal folder in an isolated working copy.
2. Keep my_reg2hdfespatial.ado, reg2hdfe.ado and my_ols_spatial_HAC.ado together.

Validation to perform later:

- Confirm Stata which resolves the local helper paths after the configuration is set.

### A-OPTIONAL-INSTALL-LINES: Confirm whether the supplied install-only statements for _gwtmean and ihstrans support any out-of-package stage; the bounded package review found no selected supplied callers for either.

Scopes: full_pipeline, analysis_only. Type: clarification. Certainty: conditional.
Addresses: SW-STATA-ADDONS
Evidence: E-SAFE-COMMAND-SCAN, E-SOFTWARE-REVIEW

Preparation / proposed procedure:

1. Ask the author whether the two install-only statements support an external step not included in this package.
2. Leave them unresolved until that confirmation; no package installation was attempted.

Validation to perform later:

- Retain any required package only if the author identifies a supplied or documented caller.

### A-HDFE-PRODUCER-CLARIFICATION: Confirm the caller-side source and producer contracts for the unresolved helper datasets before relying on the dependent Stata branches.

Scopes: full_pipeline, analysis_only. Type: clarification. Certainty: conditional.
Addresses: I-HDFE-INPUT-PRODUCERS
Evidence: E-MY-REG2HDFE-IDS-READ, E-REG2HDFE-IMPROVE-IDS-READ, E-REG2HDFE-INDATA-IDS-READ, E-REG2HDFE-ORIGDATA-READ, E-SAFE-COMMAND-SCAN

Preparation / proposed procedure:

1. Ask the author for a sanitized caller-side mapping for _ids.dta, improve_ids and indata_ids, including the exact selected branch and required key fields.
2. Clarify whether origdata is an internal temporary snapshot for reg2hdfe error recovery and identify its save point in the supplied workflow.
3. Preserve the supplied helper code and do not reconstruct these datasets independently.

Validation to perform later:

- Before any later authorized run, confirm each selected caller, producer, file or tempfile, and downstream helper read from the author-confirmed workflow.

### A-PYTHON-DEPS: If a later authorized run exposes a compatibility discrepancy or an additional visible dependency, compare it with the author-specified Python environment; a missing version pin by itself is not a current blocker.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SW-PYTHON-DEPS
Evidence: E-ENVIRONMENT, E-REDACTED-HELPERS, E-PYTHON-DIST-METADATA

Preparation / proposed procedure:

1. Retain the current bounded metadata result for pandas, requests and pytz without treating it as an author-module runtime test.
2. If an authorized compatibility run later identifies a concrete mismatch or additional dependency, request only the relevant author version constraint; do not install packages during this assessment.

Validation to perform later:

- Any later authorized compatibility check should compare the exact visible imports and installed distributions; no author module was run here.

### A-CONFLICT-ADDITIONAL-CALLERS: Request the author-specified input file and caller order for each in-memory additional-analysis companion in both scopes; after SAS generation, keep all outputs distinct until that mapping is documented.

Scopes: full_pipeline, analysis_only. Type: clarification. Certainty: conditional.
Addresses: I-CONFLICT-ADDITIONAL-CALLERS
Evidence: E-ADDITIONAL-CALLER-REVIEW, E-READMES-CONFLICT, E-ANALYSIS-DTA-META

Preparation / proposed procedure:

1. For Full_Sample_do_file_for_an_additional_analysis.do, record the exact prepared dataset path, whether the caller must reload a fresh copy, and its order relative to the other selected analyses.
2. For Pre_Period_do_file_for_an_additional_analysis.do, record the exact prepared dataset path, whether the caller must reload a fresh copy, and its order relative to the other selected analyses.
3. Do not assign any route from the source filename or shared header fields alone, and do not add Mining_Region_Sub_Sample.dta or other candidate exports as extra mandatory inputs.
4. Retain the listed caller fields and one-row header/coverage limits in the review record; do not infer full rows, period coverage, or sample identity from those headers.
5. For full_pipeline, confirm which SAS-produced export each caller should load after the SAS stage; the presence of raw inputs and generated outputs does not resolve this mapping.

Validation to perform later:

- Confirm each documented caller path and fresh initial state against the selected file and an existing bounded header contract before a later authorized execution; no author file or data is run in this assessment.


## Remaining issues and prerequisites

- I-RESP-INPUTS [unresolved; full_pipeline]: The Responsible Sourcing SAS entry actively reads six absent external members; each now has a separate mandatory input contract. Bounded catalog records are product candidates only, and exact source, field, join, period and current access remain unresolved.
- I-RESP-READABILITY [unresolved; full_pipeline]: The packaged edgar_log_data and handcollected_combined SAS files are read by the author entry, but the bounded metadata helper returned unsupported-character-set/readstat errors for both. Required columns and periods remain unverified.
- I-EDGAR-SCOPE [unresolved; full_pipeline]: Author documentation describes 2016 EDGAR log preparation and 2014–2015 SRAF log inputs, while the supplied notebook selects April 2017 SD/SD-A files and refers to an index covering 2016–2017. The intended data period, upstream files and handoff into edgar_log_data need author clarification.
- I-EDGAR-TEMP-HANDOFF [unresolved; full_pipeline]: The notebook conditionally merges temp_lookup_df.pkl and temp_error_df.pkl returned through LookupEDGAR. The helper files contain candidate credential/connection statements that the saved reader withheld as whole blocks; the temporary-file producer and request route cannot be verified from the visible text. No candidate values are retained in this report.
- I-SMELTER-UPSTREAM [unresolved; full_pipeline]: The Smelters SAS branch requires smelter_level_data.sas7bdat, which is not in the package. The README also describes a smelter_downloads preparation folder/code that is absent from the inventory; its manual collection, conformance review and RMI fuzzy-match history are not supplied.
- I-SAS-PATHS [preparation; full_pipeline]: All three SAS branch drivers use C-drive LIBNAME, include or export paths. Their package-relative libraries, helper macros and output locations must be mapped consistently in an isolated working copy.
- I-SAS-STARTUP [unresolved; full_pipeline]: The SAS 9.4 environment startup record fails while loading TKELS, so the author-required SAS runtime remains unverified. The diagnostic is not evidence of absent licensing.
- I-SMELTER-ANALYSIS-PATH [preparation; full_pipeline, analysis_only]: The packaged smelters.dta is under Smelters/Export. One of the two supplied Stata companions points to [redacted-path-b4910de8e4e5] while the other points to [redacted-path-e8e1cfb7677b]. Keep both analyses and map the first to the same packaged export in the working copy.
- I-CONFLICT-SAS-METADATA [unresolved; full_pipeline]: The Conflict Minerals SAS stage separately reads twelve package-local SAS tables. Eleven bounded metadata probes returned unsupported-character-set/readstat errors; mineral_prices yielded a one-row header only, so full schemas and coverage remain unresolved.
- I-PROCLOGIT-HANDOFF [preparation; full_pipeline]: The README places the proc_logistic Stata companion after the SAS stage, and SAS exports Table_1a to the same proc_logistic.dta path. The five-line do-file starts with egen and has no use statement, so the caller must load that same generated file before invoking it. This is ordinary full-pipeline setup; header and row coverage were not independently verified.
- I-EASTERN-LOAD [preparation; full_pipeline, analysis_only]: Eastern_DRC_do_file.do line 1 opens a quoted use path without a closing double quote. The exact one-character repair remains proposed and unapplied. In full_pipeline the SAS stage produces Eastern_DRC.dta; in analysis_only the same intended file is packaged. Configure the selected route path in a working copy.
- I-TTTG-HANDOFF [preparation; full_pipeline, analysis_only]: The Conflict SAS stage exports TTTG_Mining_Regions.dta, the exact package-local export is present, and its bounded header includes the variables used by the 14-line Stata companion. Because that do-file starts in memory and has no use statement, load this same generated file for full_pipeline or the packaged copy for analysis_only before invoking it. The one-row probe does not establish full period coverage.
- I-STATA-ADDONS [preparation; full_pipeline, analysis_only]: Stata 18 is available, but bounded which checks did not find outreg2 and xtpsse (used by the supplied analyses), fect (used in conflict analyses), or tmpdir (called by the supplied spatial helper). These required commands must be identified and made available before later execution.
- I-LOCAL-ADO-PATH [preparation; full_pipeline, analysis_only]: The supplied Personal ado helpers are present but are not found by default Stata which checks. The README directs users to place the Personal folder on the Stata ado path; this needs a working-copy configuration.
- I-HDFE-INPUT-PRODUCERS [unresolved; full_pipeline, analysis_only]: Selected Conflict Minerals Stata helpers read _ids.dta and macro-expanded improve_ids and indata_ids datasets; the reviewed local source context does not establish their producers or caller-side sources. A reg2hdfe error-recovery branch also reads macro origdata without a producer established by the reviewed context. These are unresolved producer/caller mappings, not findings that the referenced files are absent.
- I-CONFLICT-ADDITIONAL-CALLERS [unresolved; full_pipeline, analysis_only]: Full_Sample_do_file_for_an_additional_analysis.do and Pre_Period_do_file_for_an_additional_analysis.do both start in memory, have no explicit use statement, build panel keys, and use iso_3/iv_cov_country. Their required input fields are recorded in E-ADDITIONAL-CALLER-REVIEW. Five distinct bounded export headers contain those field names, but the README and selected sources do not establish which file or caller order is intended; the one-row headers do not establish sample or period equivalence. Keep the five exports distinct, do not treat Mining_Region_Sub_Sample.dta as mandatory from its filename, and retain this exact mapping/order as unresolved. A later caller must load a fresh author-confirmed data state before each companion because the files modify in-memory variables and observations. This same unresolved mapping applies to both full_pipeline after the Conflict SAS stage and analysis_only with caller-prepared inputs; the existence of raw inputs or generated exports does not identify the intended caller route.
- R-RESP-EDGAR [undetermined]: Responsible Sourcing consumes the package-local edgar_log_data SAS table. The author documents EDGAR log sources and a 2014–2016 preparation/handoff, but exact table coverage and metadata remain unverified.
- R-RESP-HANDCOLLECTED [undetermined]: Responsible Sourcing consumes the package-local handcollected_combined SAS table. Its required schema and coverage remain unverified because bounded metadata reading failed.
- R-RESP-BAYER-BASE [undetermined]: Responsible Sourcing separately requires external SAS member Bayer_Base. The exact table, field, join, period and current access contract are not established; No exact compatible catalog candidate was found in the bounded frozen search.
- R-RESP-COMPU-FUNDA [undetermined]: Responsible Sourcing separately requires external SAS member Compu_Funda. The exact table, field, join, period and current access contract are not established; COMP.FUNDA is a product candidate; the exact alias, fields, period and access contract remain unverified.
- R-RESP-COMPU-FUNDA-SGNA [undetermined]: Responsible Sourcing separately requires external SAS member Compu_Funda_SGNA. The exact table, field, join, period and current access contract are not established; The exact SGNA mapping was not established by the bounded frozen catalog queries.
- R-RESP-MECH-DI-DATA [undetermined]: Responsible Sourcing separately requires external SAS member Mech_DI_DATA. The exact table, field, join, period and current access contract are not established; The bounded frozen catalog did not establish an exact compatible Development International source.
- R-RESP-CUSIP [undetermined]: Responsible Sourcing separately requires external SAS member CUSIP. The exact table, field, join, period and current access contract are not established; WRDSSEC.WCIKLINK_CUSIP is a candidate CIK–CUSIP table, not a verified alias or join contract.
- R-RESP-CCM-LINK [undetermined]: Responsible Sourcing separately requires external SAS member CCM_Link. The exact table, field, join, period and current access contract are not established; CRSP.CCMXPF_LINKTABLE is a candidate link-history table, not a verified alias, date rule or access contract.
- R-EDGAR-LM-INDEX [undetermined]: The EDGAR notebook's distinct package-local lm_idx.pkl input is required by its parsed read edge; its object schema was not inspected by pickle deserialization.
- R-EDGAR-INDEX [undetermined]: The EDGAR notebook separately reads the package-local idx.pkl index; the supplied notebook comment describes an index spanning 2016–2017, but its object contents and actual coverage were not deserialized.
- R-EDGAR-LOOKUP [undetermined]: The EDGAR notebook separately uses the package-local lookup_df.pkl state. In its temp==1 branch it appends temp_lookup_df.pkl into lookup_df; the files are distinct, and their object schemas were not inspected.
- R-EDGAR-ERROR [undetermined]: The EDGAR notebook separately uses the package-local error_df.pkl state. In its temp==1 branch it appends temp_error_df.pkl into error_df; the files are distinct, and their object schemas were not inspected.
- R-SMELTER-LEVEL [undetermined]: The Smelters SAS stage requires smelter_level_data.sas7bdat, which is absent. The author describes a webscraped and handcollected disclosure table, conformance review and fuzzy matching to RMI IDs; the prepared-table contract and source code are not supplied.
- R-CONFLICT-SAS-ACLED-NEW [undetermined]: The Conflict Minerals SAS branch separately reads package-local acled_new.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-IPIS-FULL [undetermined]: The Conflict Minerals SAS branch separately reads package-local ipis_full.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-BCRT-BASELINE [undetermined]: The Conflict Minerals SAS branch separately reads package-local bcrt_baseline.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-BCRT-BASELINE-1-1 [undetermined]: The Conflict Minerals SAS branch separately reads package-local bcrt_baseline_1_1.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-ISO-CODES [undetermined]: The Conflict Minerals SAS branch separately reads package-local iso_codes.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-YEAR [undetermined]: The Conflict Minerals SAS branch separately reads package-local year.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-YEAR-YYYYMM [undetermined]: The Conflict Minerals SAS branch separately reads package-local year_yyyymm.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-POLITY-DATA-CSV [undetermined]: The Conflict Minerals SAS branch separately reads package-local polity_data_csv.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-THEGLOBALECON-2 [undetermined]: The Conflict Minerals SAS branch separately reads package-local theglobalecon_2.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-TERR [undetermined]: The Conflict Minerals SAS branch separately reads package-local terr.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-PLOS-MLMV-B [undetermined]: The Conflict Minerals SAS branch separately reads package-local plos_mlmv_b.sas7bdat; The exact file is present and named as a SAS input. Its bounded metadata probe returned an unsupported-character-set/readstat error, so its required fields and full coverage remain unverified.
- R-CONFLICT-SAS-MINERAL-PRICES [undetermined]: The Conflict Minerals SAS branch separately reads package-local mineral_prices.sas7bdat; The file is present. Its bounded metadata probe returned a one-row header with mainmineral, year, mm_price and mma_price; schema beyond this header and full coverage remain unverified.
- SW-PYTHON-DEPS [unverified]: A bounded importlib.metadata query found visible pandas, requests and pytz distributions installed (pandas 3.0.6, requests 2.34.2, pytz 2026.4). The author package has no pinned dependency manifest; no author module was imported and runtime compatibility was not tested. Installed metadata is not a successful software-runtime probe, and the missing pin alone is not treated as an execution barrier.
- SW-STATA-ADDONS [preparation_required]: Bounded Stata which checks did not find outreg2, xtpsse, fect or tmpdir. coefplot, ivreg2 and eststo were found; reghdfe, ftools, esttab, estpost and estadd were previously found. No package was installed. The package software review classed _gwtmean and ihstrans as install-only, and geodist as belonging to the uncalled spatial-2SLS helper.
- SW-LOCAL-ADO [preparation_required]: The package includes my_reg2hdfespatial.ado, reg2hdfe.ado and my_ols_spatial_HAC.ado, but default Stata which checks did not resolve the first two. Configure the supplied Personal folder on the working-copy adopath before any later authorized run.
- SW-SAS [unverified]: The frozen environment record reports a TKELS extension startup failure. This does not establish absent licensing or current SAS runtime availability.

## Review notes

- Assessment covers this supplied author package variant and all three documented branches, including all nine selected analysis_only Stata companions. No author code/import, compilation, syntax/model/statistical/synthetic trial, installation, SAS startup, payload/API/data request, download or pickle deserialization was performed. Static official documentation requests were made; the TheGlobalEconomy terms-page attempt returned HTTP 429.
- The full_pipeline scope models SAS outputs as internal producer-to-consumer handoffs. The separate analysis_only scope has individual prepared-input requirements for the packaged Smelters export and each of six Conflict exports; these files are not treated as one interchangeable bundle or ANDed with the raw-builder SAS inputs.
- Bounded package-data probes read at most one row/header. The two Responsible SAS tables and eleven Conflict SAS tables remain present even where the metadata helper returned character-set errors; those errors do not establish absent data or unsupported SAS runtime behavior. mineral_prices yielded only a one-row header.
- Source-quote history is preserved: the initial seven cached-text quote ranges were emitted without an exclusion-aware reader call preceding quote construction, a process-method lapse. The later retained known-candidate-line comparison found no overlap in those seven ranges. The 20/20 and 42/42 checks remain preserved intermediate history. The current 49/49 source citations match saved redacted_reader.py output, with zero cited-interval overlaps against known candidate lines. The candidate manifest covers only known candidate lines and does not establish exhaustive absence of sensitive content.
- The saved fail-closed reader withheld whole candidate blocks in the EDGAR helpers; retained candidate records contain path, line and hash metadata only. The EDGAR temporary lookup/error producer route remains unresolved from visible safe output. This does not establish credential validity, whether an author request occurred, or current user access.
- The bounded frozen catalog and static documentation results do not establish licensing, entitlement, or full data coverage. The TGE 429 record is process-only and is not used as scientific evidence; no data endpoint or payload was accessed.
- The proc_logistic and TTTG files have supported same-data caller-load setup: each is linked to its exact SAS export and the Stata file starts with in-memory commands. One-row metadata does not prove full-period coverage; the current configuration actions address the caller load step without inventing sample data.
- Earlier helper, inspection, access-barrier and submission history remains preserved in probes/command_history.json and immutable predecessor snapshots. H028 records the exact pinned-finalizer failure; H029 records the local review-row-count guard failure and preserved partial state. Historical runner details not retained at their time remain unknown rather than reconstructed from later outputs or hashes.
- The source-QA workflow trace records the native branch and handoff distinctions using retained source citations and package metadata; no author execution or workflow outcome is implied.
- The two selected Conflict additional-analysis companions have no explicit data load. Their required fields and safe-reader windows are recorded in probes/continuation_caller_contract_review_v1.json, but five distinct export headers share those fields and the supplied README does not establish caller input or order. The mapping remains unresolved; no extra mandatory input was added. Mining_Region_Sub_Sample.dta remains credited as a produced/header-probed export without an assigned selected caller.
