# Patch proposal: jar-1875038d4031

Public Firm Presence, Financial Reporting, and the Decline of US Manufacturing

DOI: 10.1111/1475-679X.12411

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Run.sas earnings-quality construction followed by the R data preparation and main analyses, including its supplied companion branches.

Entry points: `JAR Code Archive/Run.sas`, `JAR Code Archive/JAR Accepted Version.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 3/12411 - Public-Firm-Presence-Financial-Reporting-and-the-Decline-of-US-Manufacturing/go-datasheet-code-and-identifiers.zip",
      "sha256": "9585b3283dde0add77b2232d6b8172e131879fe8e65b25643c71c0d07d084728"
    },
    {
      "path": "JAR-Volume 60/Issue 3/12411 - Public-Firm-Presence-Financial-Reporting-and-the-Decline-of-US-Manufacturing/go-internet-appendix.pdf",
      "sha256": "bb1ecc6d11743705eff32ff1cd89cf81ac13922952b77e8d000503059d63a0c8"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "81c8c6747280e7aec1fdbf80df2939b3e6f73aee1e22562a86f9789243e02359"
}
```

## Proposed actions

### A_PATHS: Map the author-specific R and SAS input/output roles to a coherent host-visible working tree, including ordinary local/remote SAS session library bindings.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATHS, I_SAS_LOCAL_LIBREF
Evidence: E_R_PATHS, E_SAS_START, E_SAS_FIRST_OUTPUT, E_SAS_TRANSFERS, E_SAS_CIK, E_R_FS_EQ

Preparation / proposed procedure:

1. Create distinct host-visible roots for R trade, ASM, Compustat, Pierce-Schott, SOX, concentration, Orbis, guidance, BACI and output roles; preserve the separate author path purposes in a working copy.
2. For SAS, define home in every local or remote session before the first use in that session, and make the filings directory visible in the session that performs the join.
3. After SAS produces home.FS_EQ_Qlty, copy or rename that same generated table to the R consumer path as fs_eq_qlty.sas7bdat; preserve naicsh, fyearq and the four R-square columns and the YEAR=fyearq+1 join.
4. Set the R working directory and all hard-coded inputs/identifier outputs to the mapped roots without altering the authored measures or sample rules.

Validation to perform later:

- Before a separately authorized run, resolve every input path from its session working directory and confirm each intended output folder is writable.
- Confirm the generated SAS handoff filename, path, field names and join key match the R consumer exactly.

### A_CLOSURE: Use the complete author-supplied SAS-to-R sequence and preserve its remote/local context and companion branches.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_CLOSURE
Evidence: E_README_ORDER, E_WORKFLOW_TRACE, E_SAS_TRANSFERS, E_SAS_RSQ, E_R_UK

Preparation / proposed procedure:

1. Start Run.sas: connect to WRDS, build annual Compustat/CCM/monthly-CRSP inputs and PROC DOWNLOAD addcrsp to local WORK; run the local annual earnings-quality block and save home.BLKEarningsQlty.
2. Continue Run.sas in native order: remote quarterly Compustat/annual lags/CCM/daily CRSP match and download work.compustat; run the second remote daily-CRSP block and download work.crsp; return to the local CIK/filing join and peer/sample construction; generate four home.rsquare_* tables and home.FS_EQ_Qlty.
3. Stage the generated FS_EQ_Qlty output to the R input path using the configuration action, then run JAR Accepted Version.R from its mapped root through the main panel, SOX companion, Germany disclosure, guidance/analyst, and UK falsification branches.
4. Resolve the CIK/GVKEY producer and FLAG data definitions, filing-event table contract, and every unverified input/software action before declaring closure; preserve the separate FLAG queries and all other native source order.

Validation to perform later:

- For any future authorized attempt, retain each stage's actual working directory, source transfers, output path, separate streams and exit status; confirm the expected generated producer exists before its consumer runs.
- Check that the resulting R scope includes all supplied branches and unchanged authored estimation definitions.

### A_R_SETUP: Prepare an R environment matching the README's runtime and package set before running the supplied driver.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_R
Evidence: E_README_SOFTWARE, E_R_PACKAGES

Preparation / proposed procedure:

1. Use a compatible R 4.0.5 x86_64 Windows environment or document compatibility for the available R 4.5.0 runtime; the current metadata probe found 14 of 15 listed packages absent and survival at a different version.
2. Prepare the README's named packages and requested versions, including data.table, readstata13, sas7bdat, readxl, haven, lfe, car and tikzDevice; do not replace the author workflow with another reader or estimator.
3. Keep package setup separate from data preparation and retain all package/version declarations for future reproducibility.

Validation to perform later:

- Before a future run, verify the R version and each required package/version via installed-package metadata and confirm the author-used functions are available.
- Confirm the prescribed R platform can read the packaged Excel, CSV, Stata and SAS inputs.

### A_SAS_SETUP: Confirm the intended SAS runtime and remote WRDS sign-on or local-library configuration before the SAS preparation stage.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_SAS_START, E_ENVIRONMENT

Preparation / proposed procedure:

1. Use the required SAS/CONNECT configuration for the author-coded WRDS remote libraries if following the remote route; remote access was not tested and no missing license is inferred.
2. If the matched local SAS products are used instead, configure their local library paths in the correct SAS session and apply the explicit sample-relative date windows recorded for each input.
3. Keep SAS code in its native language and preserve both PROC DOWNLOAD transfers and the local follow-on steps.

Validation to perform later:

- Before any separately authorized execution, confirm the supported SAS/CONNECT runtime and the selected local or remote source path; retain the exact selected data route.
- Confirm session library definitions exist before each local or remote use.

### A_PUBLIC_INPUTS: Acquire or select the compatible public trade, related-party, BACI and NTR inputs used by the supplied R transformations.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_RP_2005_2016, R_RP_2000_2004, R_US_TRADE, R_HS_CONCORDANCES, R_BACI_COUNTRIES, R_BACI_FLOWS, R_NTR
Evidence: E_README_TRADE_CENSUS, E_DATASHEET_TRADE, E_DATASHEET_CONCORDANCE, E_R_IMPORT_COUNTRY, E_R_RELATED, E_R_CONCORDANCE, E_R_BACI, E_R_NTR, E_SCHOTT_PUBLIC, E_CEPII_PUBLIC, E_DATASHEET_ACCESS

Preparation / proposed procedure:

1. For US imports/exports, use the author-documented Schott annual files and verify year, HS vintage, import/export direction, NAICS fields and December aggregation compatibility for 1989-2017.
2. Obtain the separate 2018.10.15 Schott import and export concordances or map a compatible later author release to their exact code-used fields/years. Preserve the supplied R lines 501-504 mapping as written, including both naicsX vectors from import.concordance; any suspected directional output difference is context before a method change.
3. Obtain the two Census related-party series for 2000-2004 and 2005-2016 and confirm their year, NAICS, import total and related-party fields match the separate R transformations.
4. Select the current CEPII BACI product and its five HS-vintage country tables; verify the official delivery format and source-year-to-vintage mapping for bilateral 1995-2017 flows before preparing the R yearly archives. Reconcile the README's free-download statement with the historical datasheet description using current official product terms rather than inferring a present barrier.
5. Use the official AEA replication route for the two Pierce-Schott NTR Stata inputs, then confirm the named files, fields and vintage before staging them under PS.data.dir.

Validation to perform later:

- Check each required period, key, measure units and vintage against the R reader and transformations; keep the import-derived naicsX mapping unchanged unless a later separately authorized method change is supported.
- Verify current BACI source/access and the exact HS92/96/02/07/12 crosswalks; retain any unmet current route as unresolved instead of treating old access wording as a block.

### A_ASM_CMF: Align the source-listed public Census ASM/CMF tabulation files with the R input vector and package paths.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_ASM_CMF
Evidence: E_R_ASM, E_README_TRADE_CENSUS, E_DATASHEET_CENSUS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Use the public ASM/CMF statistical tabulations documented by the README/datasheet; do not substitute confidential Census microdata.
2. Resolve every exact .dat filename in the R vector against the package inventory or the matching Census public publication/source, including the special multiple-file years and pre-2002 publication inputs.
3. Stage the compatible public tabulations under the mapped ASM root using the filenames and reader conventions the source expects.

Validation to perform later:

- Confirm each explicit R vector member is available from a public tabulation source and can be read by the supplied parsing branch with its source-defined year/NAICS role.
- Verify the resulting year-industry joins retain the authored ASM/CMF panel and do not introduce confidential microdata.

### A_COMP_INPUTS: Prepare compatible annual and segment Compustat inputs for the R public-firm-presence construction using the source fields and restatement logic.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_ANNUAL_CSV, R_COMP_SEGMENT_CSV
Evidence: E_R_COMP, E_R_COMP_FIELDS, E_R_SEGMENT_FIELDS, E_SAS_COMP_FUNDA, E_CATALOG_1, E_CATALOG_2, E_README_TRADE_CENSUS

Preparation / proposed procedure:

1. Use the author-prepared CSVs if available, or identify a compatible annual/segment export from the recorded local Compustat and COMPSEG.WRDS_SEGMERGED candidates; original CSV byte identity is not required when the fields and construction match.
2. For the annual file, preserve GVKEY/date/fyear, NAICSH/NAICS, US/USD selection, sale, COGS, NI, CAPX, DT, AT and EMP roles; confirm the 1993-onward file's exact terminal year and the DT/debt input mapping.
3. For segments, retain GVKEY/SID/datadate/srcdate/sales/geotp/stype/NAICSS1, keep the newest restatement per key, filter missing sales, and join to annual GVKEY/datadate rows before the geographic/business segment aggregation.

Validation to perform later:

- Verify source column names, types, key uniqueness and date coverage against each R operation, including the annual-to-segment match and 1993-onward source period.
- Confirm that the resulting industry-year panel uses the exact authored units and separate main/segment-adjusted firm measures.

### A_EUROSTAT: Stage and validate the packaged author Eurostat workbook series against the Value-sheet positional mappings used in Germany and UK branches.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_EUROSTAT_WORKBOOKS
Evidence: E_PACKAGE_INVENTORY, E_XLSX_15, E_XLSX_24, E_R_EUROSTAT, E_R_UK_EUROSTAT

Preparation / proposed procedure:

1. Use the supplied 1995-2018 workbooks and preserve the distinct Website-snapshot and Website_snapshot filename patterns in the R path mapping.
2. For each country/year family, confirm the Value sheet and the source-selected columns: Germany 10 (1995-2002 and 2013-2018), 19 (2003-2005), 16 (2006-2012); UK 32 (1995-2002 and 2013-2018), 41 (2003-2005), 38 (2006-2012).
3. Install no changes during this assessment; address readxl separately through the R software setup action.

Validation to perform later:

- Confirm the remaining workbook members' Value-sheet and positional column semantics and that their exact names resolve from both R branch paths.
- Check that imported production code and value columns map to the expected NACE/year output before the authored aggregation.

### A_SOX_INPUTS: Obtain or regenerate the three author-compatible WRDS Event Study output tables used in the SOX branch.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_SOX
Evidence: E_DATASHEET_SOX, E_R_SOX, E_README_IDENTIFIERS

Preparation / proposed procedure:

1. Request the event return, StocksForEvent and StocksMarketCap tables with their exact code-used columns and PERMNO coverage, or the author's precise WRDS Event Study recipe for those same outputs.
2. Preserve the event start and 12-trading-day, 100-day exposure window after the 50-day gap documented for this branch; SoxIdentifiers.csv remains only an ID list.

Validation to perform later:

- Confirm all three tables join on the supplied PERMNO set and contain the return, industry and market-cap fields consumed by R.
- Check the authored event/sample windows without changing the event study specification.

### A_ORBIS_INPUTS: Confirm a permitted compatible route to the historical Orbis financial, legal and industry extracts used by German and UK branches.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_ORBIS_DE, R_ORBIS_UK
Evidence: E_DATASHEET_IC_ORBIS, E_R_GERMANY, E_R_UK, E_DATASHEET_ACCESS

Preparation / proposed procedure:

1. Obtain or identify the June-2019 Orbis snapshot exports corresponding to the German key-financial/legal/industry inputs and the UK financial/industry inputs; do not infer a current access barrier from the historical license description.
2. Preserve the code's positional selected fields, BvD identifiers, consolidation/filing status, dates, currency and exchange rates, industry-code roles, and country filters.
3. Keep the UK raw-to-RDS producer stages in order and do not treat the generated RDS files as external inputs.

Validation to perform later:

- Confirm the extract schema and the actual country/year/identifier coverage needed by each R branch.
- Validate that the German and UK source columns map to the R positional selections before aggregation.

### A_GUIDANCE_ANALYST_INPUTS: Prepare compatible forecast and identifier-link inputs for the guidance and analyst companion branches.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_GUIDANCE, R_GUIDANCE_IDS, R_IBES_SUMMARY, R_CRSP_HEADER, R_GUIDANCE_ID_LINK, R_GUIDANCE_CCM_LINK
Evidence: E_R_GUIDANCE, E_R_GUIDANCE_FIELDS, E_R_ANALYST_USE, E_CATALOG_1, E_CATALOG_2, E_README_IDENTIFIERS, E_GUIDANCE_IDS_PROBE

Preparation / proposed procedure:

1. Use a compatible author-prepared or WRDS guidance export with the source-used measure, US-firm, ticker, announcement date, forecast year and month fields; preserve EPS/SAL/GRM/CPX coding and date-based forecast selection.
2. Stage the packaged author GuidanceDataIdentifiers.csv under the GuidanceIDs.csv input path; the source reads and re-exports only ticker. This is the identifier-list role and does not replace the full Guidance.csv input.
3. Prepare id_guidance ticker/CUSIP validity dates and CCM GVKEY/LPERMNO links joined to CRSP_header PERMNO/CUSIP; retain the source's identifier joins and any required validity history.
4. Use the c2a86a194c1438ad.csv role or a compatible I/B/E/S summary export containing NUMEST, CUSIP, MEASURE, FPI and STATPERS; the used code groups analyst counts by CUSIP/measure/FPI/year from STATPERS and joins Compustat from fyear 1996 onward.
5. Do not require the unused Forecasts.csv, ffbfca07a57fdbca.csv, GVKEY_CUSIP.csv or id_guidance_ext.sas7bdat reads after applying the separately proposed dead-read edits.

Validation to perform later:

- Confirm the exact code-used columns, ticker/CUSIP/GVKEY/LPERMNO mappings, forecast codes and announcement/fiscal-year coverage before running the branch.
- Confirm the ticker-only identifier route and the full guidance/analyst data remain separate inputs.

### A_SAS_DATA_INPUTS: Select compatible local SAS files or the author-coded WRDS products for each SAS source, preserving the exact source windows and native transfers.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SAS_FUNDA, R_SAS_FUNDQ, R_SAS_CCM, R_SAS_MSF, R_SAS_DSF
Evidence: E_SAS_FIRST, E_SAS_SECOND, E_SAS_TRANSFERS, E_SAS_COMP_FUNDA, E_SAS_COMP_FUNDQ, E_SAS_CRSP_CCMXPF_LINKTABLE, E_SAS_CRSP_MSF, E_SAS_CRSP_DSF

Preparation / proposed procedure:

1. For COMP.FUNDA, retain at least fyear 1996 for the predecessor used with annual rows fyear>1996 and every annual/quarterly Compustat row used by the target sample.
2. For COMP.FUNDQ, retain source-consumed quarterly rows with fyearq>1995. For CCM, preserve LU/LC/LS links and link-date validity over the corresponding Compustat datadate range.
3. For CRSP.MSF, supply returns 3-14 months after retained annual datadates; for CRSP.DSF, supply daily volume/return/shares 1-3 months after quarterly datadates with fyearq>1995.
4. If local candidates meet these contracts, map SAS libraries to their exact paths; otherwise use the separate WRDS routes if available. Local source use does not require remote WRDS access.

Validation to perform later:

- Confirm all selected input columns and the required sample-relative date windows before SAS execution.
- Preserve the actual PROC DOWNLOAD stages and verify returned local WORK tables exist before downstream SAS processing.

### A_CIK_FILINGS_CONTRACT: Identify the CIK/GVKEY and filing-event input producers and their exact source fields and histories while preserving the authored SAS query sequence.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CIK_GVKEY, R_FILINGS_EVENTS, I_CIK_PRODUCER, I_FILINGS_CONTRACT
Evidence: E_SAS_CIK, E_CATALOG_2, E_DATASHEET_IC_ORBIS

Preparation / proposed procedure:

1. Identify how cikgvkey.sas7bdat is supplied, including the CIK/GVKEY/FLAG columns, the definitions of the FLAG values used by the source, and the required date coverage.
2. Preserve the two successive CREATE TABLE crsp_cik blocks in their authored order (FLAG=2, then FLAG=3) with the intervening home LIBNAME statement; do not choose, combine or rewrite populations as part of this assessment.
3. Identify the producer/source for filings.sas7bdat and its event population/history. The supplied code requires only CIK, date and formtype for 10-K/10-Q flags; EDGAR server logs and IP-country data are not required by this code path.

Validation to perform later:

- Verify exact CIK/GVKEY/FLAG and filing CIK/date/formtype names, types and date alignment with daily CRSP observations.
- Configure local/remote library placement through A_PATHS, retain the source's FLAG filter order, and validate the input data definitions without changing the authored queries.

### A_DEAD_READS: Remove only static-confirmed unused R file reads and the orphaned GVKEY/CUSIP normalization in a working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_DEAD_READS
Evidence: E_R_GUIDANCE, E_R_ANALYST_USE

**Proposed edit:** `JAR Code Archive/JAR Accepted Version.R:1085–1086`
Source SHA-256: `594b066079d6cd7d5e5cf56b64bf6e14a88ed68242e02b2e3e8345dee07891d5`

Remove the Forecasts.csv and ffbfca07a57fdbca.csv reads after static cross-reference found their loaded objects have no later consumer in this supplied R workflow.

Current text:
```
forecasts <- fread('[redacted-path-b348c37f715e]')
forecasts_all <- fread('[redacted-path-bb4bba94fca4]')
```

Proposed replacement:
```

```

**Proposed edit:** `JAR Code Archive/JAR Accepted Version.R:1089–1089`
Source SHA-256: `594b066079d6cd7d5e5cf56b64bf6e14a88ed68242e02b2e3e8345dee07891d5`

Remove the unused GVKEY_CUSIP.csv read; the resulting object is only transformed at line 1103 and has no later consumer.

Current text:
```
gvkey_cusip <- fread('[redacted-path-fcbd6f2456c2]')
```

Proposed replacement:
```

```

**Proposed edit:** `JAR Code Archive/JAR Accepted Version.R:1099–1099`
Source SHA-256: `594b066079d6cd7d5e5cf56b64bf6e14a88ed68242e02b2e3e8345dee07891d5`

Remove the id_guidance_ext.sas7bdat read because id_guidance_ext has no later consumer in this supplied R workflow.

Current text:
```
id_guidance_ext <- data.table(read_sas('[redacted-path-6307f7e372f5]'))
```

Proposed replacement:
```

```

**Proposed edit:** `JAR Code Archive/JAR Accepted Version.R:1102–1103`
Source SHA-256: `594b066079d6cd7d5e5cf56b64bf6e14a88ed68242e02b2e3e8345dee07891d5`

Remove the now-unneeded GVKEY/CUSIP transformation and its comment after deleting the unused source read.

Current text:
```
# cross-reference of cusips and gvkeys by fiscal year
gvkey_cusip <- unique(gvkey_cusip[cusip != '',.(gvkey,cusip=substr(cusip,1,8))])
```

Proposed replacement:
```

```

Preparation / proposed procedure:

1. Apply the exact source-hashed edits below after reviewing the unchanged branch flow; keep guidance, c2a86a194c1438ad.csv, CRSP_header.csv and active id_guidance/CCM inputs intact.
2. Do not edit the original archive or remove any analysis-consuming source.

Validation to perform later:

- Statically confirm the removed object names have no later use and that the used analyst and guidance calculations remain unchanged.
- Before any separately authorized run, confirm each surviving input read has a compatible route.


## Remaining issues and prerequisites

- I_PATHS [preparation; full_pipeline]: The R driver reads and writes multiple author-specific Windows Box/Dropbox roots, while the SAS writer and R consumer use different roots and filename casing. Map each input/output role to a coherent host-visible root and stage the generated FS_EQ_Qlty handoff without changing fields or calculations.
- I_CLOSURE [unresolved; full_pipeline]: Full native SAS-to-R closure and every supplied companion branch are traced, but multiple specific required input field/date contracts and producer/path handoffs remain unresolved and must be addressed by their linked actions.
- I_CIK_PRODUCER [unresolved; full_pipeline]: Run.sas requires home.cikgvkey and names cikgvkey.sas7bdat, but the supplied source does not establish the table producer, CIK/GVKEY/FLAG field definitions or date coverage. Configuring the known FSQltyData path is handled separately; confirm the data meaning/coverage of the FLAG values used by both source queries without changing their sequence.
- I_FILINGS_CONTRACT [unresolved; full_pipeline]: The source consumes only CIK/date/formtype from filings.filings to flag 10-K and 10-Q events. Its actual author table producer, event population and history remain unspecified; the historical datasheet and an unused R processed-log directory do not establish an EDGAR server-log or IP-country dependency.
- I_DEAD_READS [preparation; full_pipeline]: Static cross-reference finds unused R loads for Forecasts.csv, ffbfca07a57fdbca.csv, GVKEY_CUSIP.csv and id_guidance_ext.sas7bdat; remove only these dead reads and the unused GVKEY/CUSIP normalization in a working copy to avoid requiring files that feed no supplied analysis.
- I_SAS_LOCAL_LIBREF [preparation; full_pipeline]: Bind home to the mapped author FSQltyData role in each local or remote SAS session before its first use. The author path role is specified; this is ordinary session/path configuration, not an author-confirmation gate. The separate CIK/GVKEY data producer and fields remain unresolved under I_CIK_PRODUCER.
- R_RP_2005_2016 [undetermined]: Census related-party trade CSV for 2005-2016.
- R_RP_2000_2004 [undetermined]: Census related-party exhibit 4 series for 2000-2004.
- R_US_TRADE [undetermined]: Annual US import/export detail to construct ImportComp for 1989-2017; code aggregates December observations and requires vintage-aware HS/NAICS fields.
- R_HS_CONCORDANCES [undetermined]: Separate import and export HS/SIC/NAICS Stata concordances; source expects files from the 2018.10.15 archive.
- R_ASM_CMF [undetermined]: Public Census ASM/CMF statistical tabulations read by the explicit source file vector; no confidential Census microdata is inferred.
- R_COMP_ANNUAL_CSV [undetermined]: The R panel consumes author-prepared compustatfrom1993debt.csv. The supplied code uses GVKEY/date/fiscal year, NAICSH or NAICS, US/USD filters, sales, COGS, net income, CAPX, DT, assets and employment; the input name indicates 1993 onward, while exact DT/debt construction and upper year remain unverified.
- R_COMP_SEGMENT_CSV [undetermined]: The R panel consumes compsegment.csv. Code deduplicates restatements by GVKEY/SID/datadate keeping newest srcdate, filters missing sales, merges to Compustat on GVKEY/datadate, and uses geographic and business segments with NAICSS1; exact source-years must match the annual Compustat dates beginning 1993.
- R_BACI_COUNTRIES [undetermined]: Five BACI HS-vintage country-code crosswalk CSVs.
- R_BACI_FLOWS [undetermined]: BACI bilateral country-product-year flows for 1995-2017 in five HS vintages; yearly zip/CSV transformation is in R.
- R_NTR [undetermined]: Two Pierce-Schott AER 2016 NTR Stata inputs read by R.
- R_SOX [undetermined]: Three WRDS Event Study tables for the SOX companion analysis; packaged SoxIdentifiers.csv is only a PERMNO list.
- R_ORBIS_DE [undetermined]: German Orbis key financial, legal and industry slices from the UMich June-2019 snapshot.
- R_EUROSTAT_WORKBOOKS [undetermined]: Author-provided Eurostat manufacturing workbooks for 1995-2018. Both R branches read the Value sheet by position: Germany uses column 10 for 1995-2002 and 2013-2018, 19 for 2003-2005, and 16 for 2006-2012; UK uses column 32 for 1995-2002 and 2013-2018, 41 for 2003-2005, and 38 for 2006-2012.
- R_GUIDANCE [undetermined]: The guidance companion branch uses guidance measure codes EPS, SAL, GRM and CPX, US-firm indicator, ticker, announcement date anndats, forecast year prd_yr and month prd_mon, then joins ticker/CUSIP histories to Compustat fiscal year. Keep the exact field coding, date/history and preparation mapping unresolved; a compatible exported guidance table is sufficient without byte-identical author CSVs.
- R_IBES_SUMMARY [undetermined]: The used author analyst-count extract c2a86a194c1438ad.csv is grouped by CUSIP, MEASURE, FPI and year from STATPERS and provides NUMEST; Compustat matches begin at fyear>=1996. The exact historical export/mapping remains to confirm.
- R_CRSP_HEADER [undetermined]: CRSP_header.csv contributes PERMNO/CUSIP to the CCM lpermno/GVKEY linkage used by guidance and analyst branches; match identity history for announcement/fiscal-year samples.
- R_ORBIS_UK [undetermined]: UK Orbis raw financials and industry classifications for the UK falsification branch.
- R_SAS_FUNDA [undetermined]: Required source product COMP.FUNDA; its bounded local candidate and separate documented WRDS route are listed independently. Required fields and authored sample-relative period are stated; sampled rows do not establish full period coverage.
- R_SAS_FUNDQ [undetermined]: Required source product COMP.FUNDQ; its bounded local candidate and separate documented WRDS route are listed independently. Required fields and authored sample-relative period are stated; sampled rows do not establish full period coverage.
- R_SAS_CCM [undetermined]: Required source product CRSP.CCMXPF_LINKTABLE; its bounded local candidate and separate documented WRDS route are listed independently. Required fields and authored sample-relative period are stated; sampled rows do not establish full period coverage.
- R_SAS_MSF [undetermined]: Required source product CRSP.MSF; its bounded local candidate and separate documented WRDS route are listed independently. Required fields and authored sample-relative period are stated; sampled rows do not establish full period coverage.
- R_SAS_DSF [undetermined]: Required source product CRSP.DSF; its bounded local candidate and separate documented WRDS route are listed independently. Required fields and authored sample-relative period are stated; sampled rows do not establish full period coverage.
- R_CIK_GVKEY [undetermined]: The second SAS stage uses CIK/GVKEY/FLAG from home.cikgvkey and also names cikgvkey.sas7bdat; identify the source table's producer, flag definitions and date coverage. Preserve the supplied successive FLAG=2 then FLAG=3 queries.
- R_FILINGS_EVENTS [undetermined]: Run.sas joins filings.filings to CRSP/CIK rows on date and numeric CIK and reads formtype only to create 10-K and 10-Q flags. Required construction source, exact event population and date history are unresolved; no supplied stage reads EDGAR server request logs or IP-country fields.
- R_GUIDANCE_ID_LINK [undetermined]: Active id_guidance.sas7bdat ticker/CUSIP and validity-window mapping used to link guidance tickers to announcement years.
- R_GUIDANCE_CCM_LINK [undetermined]: CCMXPF GVKEY/LPERMNO history joined to CRSP_header.csv for R guidance and analyst linkage. The source then reduces it to unique GVKEY/CUSIP without a date filter.
- SW_R [preparation_required]: README specifies R 4.0.5 on x86_64 Windows and 15 named packages. The current metadata-only probe reports only survival installed (3.8-3 rather than the README's 3.2-10); the other 14 packages, including readxl and readers used by the workflow, are absent in this environment.
- SW_SAS [unverified]: Run.sas requires a remote WRDS SAS session, WRDS libraries and a writable home output location. This assessment did not start SAS or test sign-on; the existing environment record is not evidence of current WRDS access or a license barrier.

## Review notes

- The complete ordered trace preserves remote WRDS SAS blocks, ENDRSUBMIT boundaries, local SAS processing and both PROC DOWNLOAD transfers. Define the known FSQltyData home library role in each SAS session before use; missing CIK/GVKEY and filing-event input definitions remain separate data gaps.
- Annual and quarterly SAS local catalog probes and documented WRDS sources are separate alternatives. Local sampled columns do not establish the source-relative construction windows or full period; remote access is not a condition on using local candidates.
- Run.sas consumes filing event fields CIK, date and formtype for 10-K/10-Q indicators. No supplied branch reads EDGAR server request logs or IP-country data; historical source descriptions are not elevated into additional mandatory dependencies.
- The R source derives both naicsX vectors from import.concordance at lines 501-504; preserve the deterministic authored mapping for the unchanged run and treat any suspected direction difference as output-fidelity context before a method change.
- Run.sas contains successive FLAG=2 and FLAG=3 CREATE TABLE crsp_cik statements with a home library rebind. Preserve the authored sequence; the actual CIK/GVKEY/FLAG input definitions remain unresolved without adding a population-choice requirement.
- Public Census ASM/CMF tabulations are used; no confidential microdata is inferred. Process history remains preserved under probes, with incident-only evidence rows unused.
