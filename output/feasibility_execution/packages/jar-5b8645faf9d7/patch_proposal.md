# Patch proposal: jar-5b8645faf9d7

Internal Forecasts in Multi-Location Firms

DOI: 10.1111/1475-679X.70003

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All three supplied code branches: the main Census SAS-to-panel R program, the separate R1A prepared-CSV/MOPS R program, and the Stata IBES analyst-forecast appendix program. Cross-branch outputs are not inferred.

Entry points: `code/InternetAppendixAnalystAnalysis.do`, `code/Redacted_JARReplication1A-CVarsChanged.R`, `code/Redacted_JARReplicationVarsChanged.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70003 - Internal-Forecasts-in-Multi-Location-Firms/glo-datasheet-code-and-log-files.zip",
      "sha256": "97bff6698d298af09f538401f7305e5e038f8b59222b233b44cf54b12302d786"
    },
    {
      "path": "JAR-Volume 64/Issue 1/70003 - Internal-Forecasts-in-Multi-Location-Firms/glo-online-appendix.pdf",
      "sha256": "c8677beb93f8301481770ebac1eb8af8e2431df3e4f9c2d20b4572813e0f70c7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "f22e952a652d9caa96ebef7673d5e6c72cba1425eb4f131e8cc04921e2411927"
}
```

## Proposed actions

### ACTION_CENSUS_ACCESS_AND_CROSSWALK: Confirm the approved Census research route and obtain the author raw-name crosswalk for each Census input family before staging the listed files.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_CENSUS_ASM_CMF_PANEL, REQ_CENSUS_LBD_LINKAGE, REQ_CENSUS_TFP, REQ_CENSUS_LBDREV_WORKFORCE, REQ_CENSUS_CSB_2015, REQ_CENSUS_MOPS_2015, REQ_CENSUS_QFRCEN_2012, ISSUE_CENSUS_ACCESS_AND_RAW_CROSSWALK
Evidence: E_CENSUS_ACCESS, E_CENSUS_PRODUCTS, E_RMAIN_RAW_VECTORS, E_RMAIN_PANEL_INPUTS, E_RMAIN_TFP_MOPS, E_RMAIN_LBDREV_HISTORY, E_RMAIN_QFR_CMF_MAP, E_R1A_MOPS_ACTIVE, E_CENSUS_FIELD_LIMIT

Preparation / proposed procedure:

1. Confirm current approved researcher access and permitted working locations for the Census files; the datasheet documents the application route but does not establish this user’s access status.
2. Obtain the raw-column mapping for the redacted R vectors, exact dataset vintages, identifiers, units and annual history. Preserve native field names and case in expected_fields; map to the code’s normalized target variables only during preparation.
3. Stage the exact files named in the R source under an authorized root and ensure the 2015 MOPS and CSB / QFRCEN inputs are included for their distinct roles.
4. Do not derive a local route from the frozen catalog miss; it is only catalog coverage metadata.

Validation to perform later:

- After authorized access, inspect metadata for the exact native columns, types and periods required by each file and verify the specified R normalization targets without reading or reconstructing the research results.

### ACTION_R1A_CSV_SOURCE: Identify the actual producer or author-prepared source route for the five active R1A CSV files and confirm their raw field headers and transformations.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_R1A_ASM2015_CSV, REQ_R1A_ASM2016_CSV, REQ_R1A_CMF2017_CSV, REQ_R1A_ASM2015_TFP_CSV, REQ_R1A_CMF2017_TFP_CSV, ISSUE_R1A_CSV_PRODUCERS
Evidence: E_R1A_CSV_READS, E_R1A_CSV_CONSUMERS, E_RMAIN_PANEL_INPUTS, E_RMAIN_PANEL_NORMALIZATION, E_CENSUS_FIELD_LIMIT

Preparation / proposed procedure:

1. Confirm whether the five active CSVs are supplied elsewhere or are created by a manual/export process; the supplied main R program does not establish that it creates them.
2. Obtain their native-to-normalized field crosswalks because the `tfp.varnames` and ASM/CMF raw-column vectors are redacted.
3. Stage the CSVs at the exact relative paths consumed by R1A after the local.directory root is configured.

Validation to perform later:

- Use a bounded header/metadata inspection to confirm exact source columns, row period and identifier roles; verify R1A’s normalized targets before running the branch.

### ACTION_IBES_PREPARE_FILES: Stage the two author-consumed DTA inputs from the compatible local I/B/E/S Detail History with Actuals and Actuals File candidates, applying the explicit author query and code filters.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_IBES_FORECASTS, REQ_IBES_ACTUALS
Evidence: E_IBES_DATE, E_STATA_FORECAST, E_STATA_CONSUMED_ACTUAL, E_STATA_ACTUALS, E_STATA_ACTUALS_FILTERS, E_IBES_RAW_FIELD_CONTRACT, E_IBES_FORECAST_PROBE, E_IBES_ACTUALS_PROBE

Preparation / proposed procedure:

1. Prepare Analyst_Forecast_2018_Full.dta from the local IBES.DET_XEPSUS source using the author-documented annual-sales forecast query and FPI 1–4 selection; preserve the exact fields TICKER, FPI, FPEDATS, MEASURE, ANALYS, ANNDATS, REVDATS, VALUE and ACTUAL.
2. Prepare Actuals_2015_2017.dta separately from the local IBES.ACT_XEPSUS source with the source-defined PENDS windows, MEASURE == SAL and CURR_ACT == USD; preserve TICKER, PENDS, CURR_ACT, MEASURE and VALUE.
3. Keep the two input roles distinct. The Stata source obtains ACTUAL from the forecast detail file and separately uses actuals to construct SALES_2015/SALES_2017; do not join actuals into DETU to synthesize ACTUAL.
4. Stage the prepared files in the Stata working directory with the names used by the code; conversion/staging is preparation and no original author-file byte identity is required.

Validation to perform later:

- Confirm exact native fields and author filters in both staged DTA files; verify the forecast/actual period windows and TICKER key.
- Use the supplied Stata ACTUAL versus SALES_2017 ±0.01 check as a later same-scale validation after the inputs are staged; it is part of the authored procedure and does not require a separate trial or source-data reconstruction in this assessment.

### ACTION_CONFIGURE_PATH_ROOTS: Configure the redacted R data.directory/local.directory roots and Stata working directory only after the authorized data locations and prepared-file contracts are confirmed.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: REQ_IBES_FORECASTS, REQ_IBES_ACTUALS, REQ_CENSUS_ASM_CMF_PANEL, REQ_CENSUS_LBD_LINKAGE, REQ_CENSUS_TFP, REQ_CENSUS_LBDREV_WORKFORCE, REQ_CENSUS_CSB_2015, REQ_CENSUS_MOPS_2015, REQ_CENSUS_QFRCEN_2012, REQ_R1A_ASM2015_CSV, REQ_R1A_ASM2016_CSV, REQ_R1A_CMF2017_CSV, REQ_R1A_ASM2015_TFP_CSV, REQ_R1A_CMF2017_TFP_CSV, ISSUE_CENSUS_ACCESS_AND_RAW_CROSSWALK, ISSUE_R1A_CSV_PRODUCERS
Evidence: E_RMAIN_RAW_VECTORS, E_R1A_CSV_READS, E_STATA_FORECAST, E_STATA_ACTUALS

Preparation / proposed procedure:

1. Set data.directory in each R branch to the authorized Census file root and local.directory in R1A to the location containing the five active prepared CSVs.
2. Set the Stata current directory to a working folder containing the two prepared IBES .dta files; keep the script’s generated intermediates in that working folder.
3. Do not infer exact personal paths from redacted strings or treat a generic documented path as an access decision.

Validation to perform later:

- Before any author program runs, verify each exact relative input path resolves to the intended file and each generated file will be written in the same intended working directory.

### ACTION_R_PACKAGE_SETUP: Install or configure the nine missing R packages in a user-controlled R 4.5.0 library after selecting versions compatible with the local runtime.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_R_DATA_TABLE, SW_R_DESCTOOLS, SW_R_PBAPPLY, SW_R_BIT64, SW_R_FIXEST, SW_R_GGPLOT2, SW_R_HAVEN, SW_R_PSYCH, SW_R_TRANSPORT
Evidence: E_ENVIRONMENT_PROBE, E_R_PACKAGE_METADATA, E_RMAIN_LIBRARIES, E_R1A_LIBRARIES

Preparation / proposed procedure:

1. Provide the R packages data.table, DescTools, pbapply, bit64, fixest, ggplot2, haven, psych and transport in the R library used for both entry points.
2. Record installed package versions; the task’s metadata-only check found them unavailable and did not install or trial-load them.

Validation to perform later:

- Use installed-package metadata to confirm all nine exact package names are available in the selected R library before any supplied R code runs.

### ACTION_R1A_REMOVE_DEAD_READS: Propose deleting two unused R1A CSV reads that are not consumed downstream; the read of the MOPS CSV is overwritten by the active SAS MOPS load before first use.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE_R1A_UNUSED_CSV_READS
Evidence: E_R1A_CSV_READS, E_R1A_MOPS_ACTIVE

**Proposed edit:** `code/Redacted_JARReplication1A-CVarsChanged.R:16–17`
Source SHA-256: `44ef8f7df73acc931af21f9b3f75e20eec950417dddfb494f8993af5442675cf`

The lbd2015 CSV object has no later consumer; the mops2015 CSV object is overwritten by the SAS MOPS read at line 70 before its first use. Removing these reads prevents unnecessary path failures without changing downstream objects or analyses.

Current text:
```
lbd2015 <- fread(paste0(local.directory,'lbd2015.csv'))
mops2015 <- fread(paste0(local.directory, "forecasts/asm2015mops.csv"))
```

Proposed replacement:
```

```

Preparation / proposed procedure:

1. Make this change only in a reviewable work copy; do not edit the imported author package in place.
2. Keep the active asm2015.csv, asm2016.csv, cmf2017.csv, asm2015tfp.csv and cmf2017tfp.csv reads and the SAS MOPS input unchanged.

Validation to perform later:

- Textually confirm the deleted variables have no downstream consumers and the active MOPS SAS object is defined before its first consumer; do not run the author code as part of this assessment.

### ACTION_RUN_BRANCHES: Run the three supplied entry points as separate branches after their own inputs, roots and software are prepared; retain the code-supported within-branch producer/consumer order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISSUE_CROSS_ENTRY_ORDER
Evidence: E_RMAIN_PANEL_INPUTS, E_RMAIN_TFP_MOPS, E_RMAIN_LBDREV_HISTORY, E_RMAIN_QFR_CMF_MAP, E_R1A_CSV_READS, E_R1A_MOPS_ACTIVE, E_R1A_CSV_CONSUMERS, E_STATA_GENERATED_WRITE, E_STATA_ACTUALS_STAGE, E_STATA_OUTPUTS, E_STATIC_AUDIT

Preparation / proposed procedure:

1. Run code/Redacted_JARReplicationVarsChanged.R as its own Census-based panel and analysis branch after its restricted SAS inputs and R packages are ready.
2. Run code/Redacted_JARReplication1A-CVarsChanged.R as a separate branch after its five active prepared CSVs, SAS MOPS 2015 and R packages are ready; no source evidence says the main R entry point creates these CSVs.
3. Run code/InternetAppendixAnalystAnalysis.do as a separate Stata branch after its two prepared IBES .dta inputs are ready. Within Stata, preserve source order: produce Analyst_Forecast_Clean_2018.dta then read it; produce ACTUAL_to_merge.dta from actuals then merge by TICKER; only then save the two Stata analysis outputs and run regressions.
4. Do not infer a single cross-branch master order or claim a shared handoff without an author-documented producer.

Validation to perform later:

- Before and during any later authorized run, confirm all read paths, output paths and within-branch producer/consumer edges resolve in the intended working directories; capture exact output artifacts separately from console tables.


## Remaining issues and prerequisites

- ISSUE_CENSUS_ACCESS_AND_RAW_CROSSWALK [unresolved; full_pipeline]: The Census-based R branches depend on application-controlled confidential business microdata. The datasheet describes application access for approved researchers, while current authorization and exact working roots are unknown. Raw SAS/CSV field vectors and some path roots are redacted, so native field and full history contracts cannot be completed from the supplied material. This is not a finding that the data or a permitted route is absent.
- ISSUE_R1A_CSV_PRODUCERS [unresolved; full_pipeline]: The R1A branch consumes five prepared CSVs under a redacted local.directory, but the package does not contain those files or a source-supported producer/handoff from the main R entry point. The raw field mappings are redacted. Their exact source paths, columns and transformations remain unresolved.
- ISSUE_CROSS_ENTRY_ORDER [unresolved; full_pipeline]: Three executable programs are supplied, but no master program or documented cross-entry handoff links their outputs. Main R reads restricted SAS inputs, R1A reads separate prepared CSVs plus its own SAS MOPS read, and Stata reads two prepared IBES files. Keep these branches separate unless the author supplies a combined order; the supplied evidence does not support deriving the R1A CSVs from main R.
- ISSUE_R1A_UNUSED_CSV_READS [preparation; full_pipeline]: R1A executes reads of lbd2015.csv and forecasts/asm2015mops.csv at the start, but lbd2015 is not used later and the mops2015 CSV object is overwritten by a SAS read before its first use. Without a proposed deletion, the current script still attempts to open both files. The two reads can be removed without changing downstream computation based on the source trace.
- REQ_CENSUS_ASM_CMF_PANEL [undetermined]: Annual manufacturing survey panel inputs read by the main R entry point: ASM 2010–2011, 2013–2016 and CMF 2012, 2017. The code uses shared raw-field vectors whose values are redacted, maps the visible source field lbdrevlnk to lbdlinkage, and also reads CMF 2012 FIRMID and EIN for a later firm mapping. Other native field names require the author crosswalk.
- REQ_CENSUS_LBD_LINKAGE [undetermined]: Annual ASM/CMF-to-LBDREV linkage files read by the main R program for 2010–2017 and joined to matching annual panel files. The raw linkage field vectors are redacted; after mapping the code uses lbdlinkage and lbdnum_vintage21.
- REQ_CENSUS_TFP [undetermined]: ASM 2015 and CMF 2017 TFP estimates read and joined by the main R entry point. Raw `tfp.cols` values are redacted; code normalizes the inputs to lbdlinkage and ln_tfp.
- REQ_CENSUS_LBDREV_WORKFORCE [undetermined]: Standalone annual LBDREV workforce records read for 2010–2015 and the 2015 base read used for employment, payroll, and first-year employment/payroll values. The 2015 file is read in two roles; raw selection vectors are redacted.
- REQ_CENSUS_CSB_2015 [undetermined]: Compustat Bridge file (CSB) for 2015, read by main R and used to link firmid_lbd to gvkey for the MOPS/firm analysis.
- REQ_CENSUS_MOPS_2015 [undetermined]: MOPS supplement to ASM for 2015, read from the same SAS file by the main R and R1A programs. It supplies the BLEU sample and survey variables; R1A also uses 2010 historical data-availability/use responses from this 2015 MOPS input.
- REQ_CENSUS_QFRCEN_2012 [undetermined]: QFRCEN 2012 Q4 input used by the main R program to construct financial-constraint interest-rate measures. The author raw-name vector is redacted and the script normalizes selected source fields to ID, EINUM, int.exp and liability categories.
- REQ_R1A_ASM2015_CSV [undetermined]: Active prepared ASM 2015 CSV input used by the separate R1A program; exact source column names are among the redacted `setnames` vectors.
- REQ_R1A_ASM2016_CSV [undetermined]: Active prepared ASM 2016 CSV input used by the separate R1A program; exact source column names are among the redacted `setnames` vectors.
- REQ_R1A_CMF2017_CSV [undetermined]: Active prepared CMF 2017 CSV input used by the separate R1A program; exact source column names are among the redacted `setnames` vectors.
- REQ_R1A_ASM2015_TFP_CSV [undetermined]: Active prepared ASM 2015 TFP CSV input used by the separate R1A program. The selected raw `tfp.varnames` vector is redacted.
- REQ_R1A_CMF2017_TFP_CSV [undetermined]: Active prepared CMF 2017 TFP CSV input used by the separate R1A program. The selected raw `tfp.varnames` vector is redacted.
- SW_R_DATA_TABLE [preparation_required]: R library package `data.table` is called by the supplied R program and was unavailable in the metadata-only installed.packages check for R 4.5.0. No package was installed or trial-loaded.
- SW_R_DESCTOOLS [preparation_required]: R library package `DescTools` is called by the supplied R program and was unavailable in the metadata-only installed.packages check for R 4.5.0. No package was installed or trial-loaded.
- SW_R_PBAPPLY [preparation_required]: R library package `pbapply` is called by the supplied R program and was unavailable in the metadata-only installed.packages check for R 4.5.0. No package was installed or trial-loaded.
- SW_R_BIT64 [preparation_required]: R library package `bit64` is called by the supplied R program and was unavailable in the metadata-only installed.packages check for R 4.5.0. No package was installed or trial-loaded.
- SW_R_FIXEST [preparation_required]: R library package `fixest` is called by the supplied R program and was unavailable in the metadata-only installed.packages check for R 4.5.0. No package was installed or trial-loaded.
- SW_R_GGPLOT2 [preparation_required]: R library package `ggplot2` is called by the supplied R program and was unavailable in the metadata-only installed.packages check for R 4.5.0. No package was installed or trial-loaded.
- SW_R_HAVEN [preparation_required]: R library package `haven` is called by the supplied R program and was unavailable in the metadata-only installed.packages check for R 4.5.0. No package was installed or trial-loaded.
- SW_R_PSYCH [preparation_required]: R library package `psych` is called by the supplied R program and was unavailable in the metadata-only installed.packages check for R 4.5.0. No package was installed or trial-loaded.
- SW_R_TRANSPORT [preparation_required]: R library package `transport` is called by the supplied R program and was unavailable in the metadata-only installed.packages check for R 4.5.0. No package was installed or trial-loaded.

## Review notes

- The R main program, the separate R1A correction/appendix program, and the Stata analyst-forecast appendix program are retained as distinct entry points. No cross-program handoff was established: in particular, the R1A CSVs are not shown as outputs of the main R program.
- The Stata program additionally creates ACTUAL_to_merge.dta from its actuals input and then consumes it by TICKER; this source-visible producer/consumer is described in the run procedure but is not an invented frozen dependency ID. The frozen D0003 intermediate is separately reviewed as generated.
- The only packaged analyst sample inspected is a one-row metadata probe with a CUSIP column; it is not consumed by the supplied Stata code and does not establish a compatible analysis-only route. No analysis_only scope is added.
- The IBES crosswalk credits the complete local DET_XEPSUS forecast-detail and ACT_XEPSUS actuals candidates based on the exact native fields, successful bounded probes, author-described detail/actuals roles, FPI 1–4, MEASURE == SAL, CURR_ACT == USD and code-defined periods. DETU_XEPSUS is separately recorded as missing ACTUAL; unadjusted alternatives are not required to establish the chosen base-product pair. The code’s ACTUAL versus SALES_2017 ±0.01 check is retained as later preparation validation, not an access barrier.
- Census raw-name vectors are visibly redacted in the supplied R sources. The named normalized variables are recorded as preparation targets, not substituted for native expected_fields. Current approved access and exact author field crosswalk remain unverified.
- Rout logs and the Stata RTF log were left opaque. A single attempted text conversion of README.rtf failed; that process history is not used as source or feasibility evidence. No author program, model, or regression was executed and no input data values were inspected.
