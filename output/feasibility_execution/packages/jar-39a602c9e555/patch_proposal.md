# Patch proposal: jar-39a602c9e555

Greenhouse Gas Disclosure and Emissions Benchmarking

DOI: 10.1111/1475-679X.12473

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied build.R workflow: combine US and Canadian facility emissions, owner and policy matches, pollutant inputs and emissions-factor model, firm and political controls, and Tables 1–9 including the Table 7 similarity branch.

Entry points: `build.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 2/12473 - Greenhouse-Gas-Disclosure-and-Emissions-Benchmarking/tomar-datasheet-code-and-identifiers.zip",
      "sha256": "b91e98c763b4728e839b06e2d4caf83db22cd23fe63809d3e4e27b95d4b8233e"
    },
    {
      "path": "JAR-Volume 61/Issue 2/12473 - Greenhouse-Gas-Disclosure-and-Emissions-Benchmarking/tomar-online-appendix.pdf",
      "sha256": "1c97be2438f1af7d3e5c377222b6e98af81ee566cbfa24d860036e3652e83733"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "d5224cb307ddc30033eabca64b9af42c9a1c08775eb60f1d0acf8a1257a7054b"
}
```

## Proposed actions

### A_ENVIRONMENTAL_INPUTS: Recover the documented author-prepared source objects first; otherwise select official public source products only after confirming their historical version and exact code-level mappings. Preserve US versus Canada GHGRP identifiers, reporting year, units and emissions fields, and keep NEI, EIS and NPRI as distinct systems.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_US_GHGRP, R_CA_GHGRP, R_NEI_EIS, R_WEBFIRE, R_NAICS, R_OTHER_POLLUTANTS, R_GDP
Evidence: E_CODE_GHGRP, E_CODE_CA_GHGRP, E_CODE_NEI, E_CODE_WEBFIRE, E_CODE_NAICS, E_CODE_OTHER_POLLUTANTS, E_CODE_GDP, E_PUBLIC_US_GHGRP, E_PUBLIC_CA_GHGRP, E_PUBLIC_NEI, E_PUBLIC_EIS_GATEWAY, E_PUBLIC_WEBFIRE, E_PUBLIC_NPRI, E_PUBLIC_BEA, E_PUBLIC_STATCAN_GDP

Preparation / proposed procedure:

1. Obtain the exact eight US and Canadian GHGRP vintages and compare their documented source fields to the code mappings before staging.
2. Request neiUS.rdata and otherPollutants.rdata with object names, source vintages, units, facility/process keys and matching history; do not reconstruct their author matches from raw inventories.
3. Obtain the dated WebFIRE factor table and 2012 NAICS title object or document a compatible source and transformation.
4. Obtain gdp.rdata with its country/industry/year, chained-dollar and forex conventions.

Validation to perform later:

- After authorized acquisition, inspect headers/object metadata without evaluating code and compare required fields, years, IDs and units.
- Confirm that the independent US/Canada routes preserve the source-specific ID and country-flag rules before merging.

### A_OWNER_MATCH: Recover the two author mapping files and the decisions needed to preserve the US majority-owner and Canadian name paths.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_OWNER_MATCH, I_OWNER_MATCH
Evidence: E_DOC_MATCHING, E_CODE_OWNER

Preparation / proposed procedure:

1. Request ids/ghgp_data_parent_company_9_29_15.csv and namesByHand.csv with their exact fields, ownership/year history, highest-level parent choices, gvkey and orgType mappings, notes and Canadian handling.
2. Keep the supplied manual name matching and country-specific join keys; do not query individual firms or facilities.

Validation to perform later:

- Compare supplied headers and keys to the build.R joins and confirm the >50% ownership rule and unique name crosswalk decisions.

### A_NEI_PRODUCER: Recover the prepared NEI/EIS object and its upstream construction contract, which is not present in the supplied script.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_NEI_EIS, I_NEI_PRODUCER
Evidence: E_CODE_NEI, E_DOC_NEI, E_PUBLIC_NEI, E_PUBLIC_EIS_GATEWAY

Preparation / proposed procedure:

1. Request neiUS.rdata plus the source year list, fields, units, FRS identifier provenance and documented unmatched facility name/coordinate/industry matching rules.
2. Keep publicly documented NEI, EIS gateway access, and the author’s directly supplied EIS input distinct; the gateway user condition does not establish a barrier to the prepared author file.

Validation to perform later:

- Compare object names and schemas with ghgNeiUS references in the script; retain source-specific years and facility/process identifiers.

### A_POLICY_FILES: Recover the dated DSIRE source tables and the author’s manually reviewed US and Canada policy files, including the manual decisions that connect them.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DSIRE_RAW, R_REGS_US, R_REGS_CA, I_MANUAL_POLICY_OUTPUT
Evidence: E_CODE_DSIRE, E_CODE_POLICY_MANUAL, E_CODE_POLICY_CANADA, E_PUBLIC_DSIRE

Preparation / proposed procedure:

1. Request the 2020-07 DSIRE CSV table set, regsByHand.csv, regsCanada.csv, and the manual inclusion/exclusion/date/sector decisions.
2. Preserve US and Canadian regulation counts as separate country-specific inputs and use the supplied manual coding rather than rebuilding eligibility rules.

Validation to perform later:

- Check the 2008–2019 start/end years, state/province keys, federal/provincial flags, sector codes and program IDs after the exact files are received.

### A_GAS_PRICE_DATA: Recover the author-prepared gas-price data and pricing-point geography mapping, including SNL/AER provenance and vintage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_GAS_PRICES, R_GAS_LOCATIONS
Evidence: E_CODE_GAS, E_DOC_SOURCES

Preparation / proposed procedure:

1. Request gasPrices.csv and gasPrices/gasLocations.csv with pricing point, date frequency, geographic coverage, units, lag construction and historical vintage.
2. Keep SNL Financial and Alberta Energy Regulator source components distinct; the datasheet’s N/A contact field does not establish that every source is freely available.

Validation to perform later:

- Compare Date, state, gasPrice, lagGasPrice and gasPricingPoint fields and verify the state/province-to-pricing-point mapping for the study years.

### A_COMPUSTAT_FIELDS: Use the exact prepared Compustat panels if available; treat local annual Compustat metadata as a candidate requiring a field and history map.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMPUSTAT, R_COMP_FOR_CDP, I_COMP_SCHEMA
Evidence: E_CODE_COMPUSTAT, E_CODE_COMP_FOR_CDP, E_PROBE_COMP_FUNDA, E_CATALOG_COMP_FUNDA, E_CATALOG_COMPANY, E_PUBLIC_COMPUSTAT

Preparation / proposed procedure:

1. Request compustat.rdata and the distinct compForCdp.Rdata with their firm/year selection rules and notes.
2. If using local COMP.FUNDA, document fyear-to-year, market-value, NAICS and ZIP mappings, plus company crosswalk and all filters; retain the catalog candidate as an option without assuming access or coverage.
3. Do not substitute the unsuccessful COMP.COMPANY field request for a missing-data conclusion; use only the successful catalog metadata and preserve that failed request separately.

Validation to perform later:

- Compare gvkey/year, capx, at, lt, mv, gp, revt, naicscomp, zipcode, cogs and CDP note fields against each prepared object.
- Confirm 2008–2018 general panel and 2008–2013 CDP subset coverage and country/firm matching rules.

### A_EDGAR_PREPARED: Recover the study’s prepared EDGAR cross-search object and provenance rather than reprocessing raw SEC filings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EDGAR
Evidence: E_CODE_EDGAR, E_DOC_SOURCES

Preparation / proposed procedure:

1. Request edgar.rdata with dlsCopy/dlsPrCopy schemas, covered years, firm keys and the meaning of verified versus predicted cross-search data.
2. Keep the author-prepared Bernard et al. search object as primary; build.R does not consume raw filing text.

Validation to perform later:

- Compare object names, gvkey1/gvkey2/year keys and search-count definitions against Table 6 joins.

### A_LCV_AND_GEOGRAPHY: Recover the historical LCV issue/score files, ZIP-to-district crosswalk and state FIPS table used by the Table 8 branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_LCV_FILES, R_CDZIP, R_FIPS
Evidence: E_CODE_LCV, E_PUBLIC_LCV

Preparation / proposed procedure:

1. Request exact annual 2007–2019 House/Senate score and issue CSVs, the 2010–2019 CD_ZIP_03 crosswalk versions, and State_FIPS_Codes.csv with source/version metadata.
2. Preserve the code’s distinction between vote files, issue labels, state/district identifiers and ZIP crosswalk years.

Validation to perform later:

- Compare vote/issue names, chamber, legislator, score, ZIP, district, year, FIPS and abbreviation fields; verify the district-to-ZIP source vintage for every required year.

### A_POLITICAL_LINKS: Recover the prepared political-contribution match and the exact Senate election returns file without reconstructing individual matches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PAC, R_ELECTIONS, I_ELECTIONS_SOURCE
Evidence: E_CODE_PAC_ELECTIONS, E_DOC_SOURCES

Preparation / proposed procedure:

1. Request pac.rdata with its Hassan et al. source/vintage, candidate/committee/ultimate-organization keys, fuzzy-match audit and cycle-to-panel-year mapping.
2. Request the exact 1976-2020-senate.csv source, version, data dictionary and candidatevotes/year/state/candidate field definitions.

Validation to perform later:

- Compare the PAC cycle and gvkey join keys, 95-point match threshold, 2004–2012 Senate winner selection and panel-year assignment to the documented prepared files.

### A_CDP_DATA: Recover the author’s historical CDP report files and manual GHGRP-to-CDP name crosswalk, retaining the report-year shift and firm-history rules.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CDP_MATCH, R_CDP_REPORTS
Evidence: E_CODE_CDP, E_DOC_CDP, E_DOC_MATCHING, E_PUBLIC_CDP

Preparation / proposed procedure:

1. Request namesForRA.xlsx, cdpNameCrosswalk.csv and the annual cdp/ CSVs with source/vintage, access conditions and name/date/gvkey lineage.
2. Keep the author-prepared manual matches and current CDP portal products distinct; do not infer historical company data availability from current portal documentation.

Validation to perform later:

- Verify crosswalk name/nameRaw/firstDate/lastDate/gvkey keys, report-year to emissions-year shift, 2008–2013 coverage, status/scope1 fields and six-year firm panel.

### A_STAN_SOURCE: Materialize the exact inline Stan model supplied at build.R lines 623–659 as myStan.stan in a separate working copy, then remove the unused logYNew saved-parameter name. Preserve the supplied model and calculate predictions in R as the code already does. No source has been edited or executed.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_STAN_MODEL
Evidence: E_CODE_STAN, E_CODE_STAN_PREDICTION, E_PUBLIC_RSTAN_EXTRA_DATA, E_PUBLIC_RSTAN_PARS

**Proposed edit:** `build.R:678–678`
Source SHA-256: `506aa5ccd59493c859ee7faeffca82e9cdd17c4034eb6b39a30e3632b8b81c31`

The inline model declares betaYesPriors, betaNoPriors and sigma, while logYNew is not declared and no later code reads it. The RStan pars argument selects saved parameters; removing this unused name keeps the model and downstream beta-based prediction calculation unchanged.

Current text:
```
                pars = c("betaYesPriors", "betaNoPriors", "sigma", "logYNew"),
```

Proposed replacement:
```
                pars = c("betaYesPriors", "betaNoPriors", "sigma"),
```

Preparation / proposed procedure:

1. In a separate working copy, materialize the Stan content supplied in the commented block at lines 623–659 into the relative file myStan.stan by removing only each enclosing R comment prefix and optional following space; preserve the supplied Stan declarations, equations, model logic, and embedded // comments unchanged. Leave the author source untouched.
2. Apply the one-line saved-parameter selector change shown above only in that working copy; retain all model declarations, priors, data, iterations, chains and downstream R prediction calculations.
3. Record the chosen RStan version and confirm its documented saved-parameter selector behavior without using a toy model or author-code trial.

Validation to perform later:

- Review the working-copy diff to confirm the author source is untouched, the staged myStan.stan content differs from the supplied block only by removal of enclosing R comment prefixes and optional following spaces (with embedded Stan // comments, declarations, equations, and model logic preserved), and the sole proposed source edit removes only the unused logYNew selector name.
- In a future separately authorized full run, confirm model compilation and the beta-draw prediction path; this assessment did not execute or compile the model.

### A_TABLE7_SIMILARITY: Resolve the prepared-object routes or separate manual producer for all three Table 7 similarity objects. Use the supplied Appendix A8 formula and code-defined grouping/years/thresholds; do not infer that earlier loaded RData lacks these objects.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_T7_DATA_SIMILARITY, R_T7_INDSIMILARITY, R_T7_DATA_CHJAC, I_TABLE7_PRODUCER
Evidence: E_CODE_TABLE7, E_CODE_TABLE7_MERGE, E_DOC_SIMILARITY

Preparation / proposed procedure:

1. Identify whether dataSimilarity, dataIndSimilarity and dataChJac are included in any author-prepared object already loaded by build.R, or provide the separate calculation stage that produces them; no container filename is inferred.
2. For dataSimilarity, preserve jacOld/jacNew as the facility-level 2010 baseline and 2013 comparison specified in code comments; identify row grain and facility/peer/year keys.
3. For dataIndSimilarity, preserve groupVar formed from NAICS4/state and the 2010 peer-group mean jacMean.
4. For dataChJac, preserve the idFrs merge key. Code comments tie the carbon-light (<=0.33) comparison to 2013 facilities and their 2010 peers; the analogous carbon-intense comparison names peers with carbon intensity >0.67 in 2013. Keep any remaining row/year/peer construction unresolved pending the prepared-object or producer contract.
5. Use Appendix A8’s representative state-industry peer and weighted prevalence Jaccard formula; request clarification only for implementation details that the source and code leave unspecified.

Validation to perform later:

- Compare the three prepared objects or producer outputs against their exact consumed fields/keys: jacOld/jacNew; groupVar/jacMean; idFrs/chJacAbove/chJacBelow.
- Confirm year and peer roles against Appendix A8 and code comments; do not treat a schema or one object sample as proof of full facility/year coverage.

### A_R_STATA_SETUP: Prepare a separate portable working copy, install the missing free R packages in an authorized R library, and set RStata to the installed Stata command/version. Preserve the audited generation and use the available reghdfe/ftools installations.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_R, SW_STATA, SW_REGHDFE, SW_FTOOLS, SW_RPKG_DATATABLE, SW_RPKG_DPLYR, SW_RPKG_DESCTOOLS, SW_RPKG_GGPLOT2, SW_RPKG_GTOOLS, SW_RPKG_HAVEN, SW_RPKG_LFE, SW_RPKG_LUBRIDATE, SW_RPKG_READXL, SW_RPKG_RSTAN, SW_RPKG_RSTATA, SW_RPKG_SCALES, SW_RPKG_STRINGI, SW_RPKG_STRINGR, SW_RPKG_TABLES, SW_RPKG_ZOO
Evidence: E_CODE_SETUP, E_PROBE_R_PACKAGES, E_PROBE_ENVIRONMENT

Preparation / proposed procedure:

1. In a separate working copy, install the 16 imported R packages that installed-package metadata reports unavailable and record the installed versions.
2. Configure the RStata placeholders to the available stata executable and Stata 18 in the working copy.
3. Use the available R 4.5.0, Stata 18, reghdfe 6.12.3 and ftools 2.49.1 as the current candidates; do not treat author-comment version differences alone as incompatibility.

Validation to perform later:

- Check that the exact imported R package names and versions are available in the chosen R library and that RStata can find the configured Stata executable in a separately authorized future setup.

### A_DEPENDENCY_CLOSURE: Close the remaining full-pipeline input contracts. Table 7 has three jointly required but unverified prepared-object or manual-stage routes; the supplied inline Stan model is a separate staging step.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DEPENDENCY_CLOSURE
Evidence: E_DOC_WORKFLOW, E_CODE_GHGRP, E_CODE_NEI, E_CODE_STAN, E_CODE_TABLE7_MERGE, E_CODE_LCV, E_CODE_CDP

Preparation / proposed procedure:

1. Obtain or identify the enumerated prepared inputs, manual crosswalks, year-specific files and the source/container or producer contracts for all three Table 7 objects.
2. In a separate working copy, materialize the supplied inline Stan model as directed and apply only the supported saved-parameter cleanup if adopted.
3. Keep the full build.R scope, its separate US/Canada paths and all Table 1–9 branches; the optional Table 3 column 4 shortcut is not the assessed target.
4. Do not add unused datasheet products such as Fama-French or Sautner sources as build.R inputs unless an actual code dependency is supplied.

Validation to perform later:

- After exact inputs and producers are documented, recheck each of the 29 frozen checklist edges and all additional dynamic directory/year-file reads before proposing any full-pipeline run.


## Remaining issues and prerequisites

- I_NEI_PRODUCER [unresolved; full_pipeline]: build.R loads neiUS.rdata and relies on ghgNeiUS with facility/process rows and matching keys. The release contains neither the prepared object nor code specifying the documented upstream FRS/name/coordinate/industry matching. The public NEI and EIS systems are distinct and cannot be assumed to reproduce this author object.
- I_OWNER_MATCH [unresolved; full_pipeline]: The active US parent-company and namesByHand.csv inputs are absent. Highest-level owner decisions, gvkey/orgType joins and preserved Canadian name path are required for the main panel.
- I_STAN_MODEL [preparation; full_pipeline]: The supplied source contains a full commented Stan model block and explicitly instructs the reader to place it in myStan.stan. The separate file is absent, so it must be materialized in a working copy. RStan documentation permits unused extra data-list objects, and build.R computes new-sample predictions in R from beta draws; logYNew appears only in the pars save selector and is not consumed downstream. Removing that unused selector name is a source-supported same-model cleanup. Exact author RStan-version behavior is not runtime-verified.
- I_TABLE7_PRODUCER [unresolved; full_pipeline]: The active Table 7 branch jointly requires dataSimilarity (jacOld/jacNew), dataIndSimilarity (groupVar/jacMean) and dataChJac (idFrs/chJacAbove/chJacBelow). Appendix A8 supplies the representative state-industry peer and weighted Jaccard formula; code supplies the NAICS4/state group and intensity thresholds. Its comments tie 2010 to the carbon-light peer comparison and describe the analogous >0.67 carbon-intense peers as in 2013; the complete row/year/peer construction of the output objects remains unspecified. build.R has no local assignment or explicit load for these names in the Table 7 branch, but earlier load() calls can introduce additional objects and those RData namespaces were not inspected; static review therefore cannot establish that the prepared objects are absent. The exact prepared-object container or separate manual producer/schema route remains unresolved.
- I_MANUAL_POLICY_OUTPUT [unresolved; full_pipeline]: The code computes a DSIRE candidate and comments that it should be exported for manual review, then reads regsByHand.csv; no export or review-decision record is supplied. The Canadian regsCanada.csv is separately described as a hand-coded NRCan table.
- I_ELECTIONS_SOURCE [unresolved; full_pipeline]: The required 1976-2020-senate.csv has no identified source or format contract in the package; the code needs state, year, candidatevotes and candidate to select 2004–2012 winners.
- I_COMP_SCHEMA [unresolved; full_pipeline]: The prepared compustat.rdata and compForCdp.Rdata are absent. A local COMP.FUNDA candidate confirms some raw annual fields, but does not establish the prepared year, market value, NAICS, ZIP, notes, sample and firm mappings required by the two code branches.
- I_DEPENDENCY_CLOSURE [unresolved; full_pipeline]: The package contains build.R and documentation but not the required source files, prepared RData objects, manual crosswalks, historical policy/vote/CDP files or verified contracts for the three Table 7 similarity objects and any separate producer. The Stan source itself is included inline with an explicit instruction to stage it as myStan.stan, so this is preparation rather than a missing model-source blocker. Earlier RData object namespaces were not inspected; routes for dataSimilarity, dataIndSimilarity and dataChJac remain unknown rather than proven absent. Most other data routes remain unverified; exact author inputs and contracts must be recovered before full-pipeline execution can be assessed.
- R_US_GHGRP [undetermined]: Eight US GHGRP direct-emitter CSVs, assigned report years 2010–2017 and normalized into the US/Canada facility-year panel.
- R_CA_GHGRP [undetermined]: Canadian GHGRP facility-year emissions CSV; code maps Canadian facility, year, parent, province, NAICS, postal code, GHG and CO2 columns into the shared panel.
- R_OWNER_MATCH [undetermined]: US GHGRP parent-company file and hand-built firm crosswalk used to select majority owner names and join gvkey and organization type; preserve the country-specific Canadian owner-name path.
- R_NEI_EIS [undetermined]: Author-prepared neiUS.rdata containing US NEI/EIS facility-process-pollutant inputs and the GHGRP crosswalk required for emissions construction and imputation.
- R_WEBFIRE [undetermined]: WebFIRE-derived SCC factor table used to construct CO2 and CO priors, with hard-coded conversion factors and rules in build.R.
- R_NAICS [undetermined]: 2012 NAICS code-to-title object used to add two-to-six-digit industry classifications and labels.
- R_OTHER_POLLUTANTS [undetermined]: Author-prepared non-combustion pollutant object joined by NEI/Federal Registry identifier, reporting year and country.
- R_GDP [undetermined]: Prepared country-by-year two-digit NAICS GDP object in chained 2012 dollars, with the code’s documented Canada-to-US 2012 forex conversion.
- R_DSIRE_RAW [undetermined]: Dated DSIRE CSV directory actively read and processed into the raw US policy candidate before the hand-reviewed policy file is loaded.
- R_REGS_US [undetermined]: Manually reviewed US state/federal policy inputs consumed as regsByHand.csv and converted to state-year regulation counts.
- R_REGS_CA [undetermined]: Hand-coded Canadian provincial/federal regulation file constructed from NRCan’s Directory of Energy Efficiency and Alternative Energy Programs.
- R_GAS_PRICES [undetermined]: Prepared US and Canadian natural gas market-price series from SNL Financial and Alberta Energy Regulator, used by state/province and year.
- R_GAS_LOCATIONS [undetermined]: Separate US state and Canadian province to gas-pricing-point mapping used to align prices to facility geography.
- R_COMPUSTAT [undetermined]: Prepared Compustat firm-year panel used for gvkey joins and ratios, requiring capex, leverage, market-to-book, margin, NAICS, ZIP, market value and COGS fields.
- R_EDGAR [undetermined]: Author-prepared EDGAR cross-firm search objects used for verified and predicted search count by Compustat gvkey and year.
- R_LCV_FILES [undetermined]: Annual LCV issue lists and House/Senate score files read by Table 8 for Congress years 2007–2019.
- R_CDZIP [undetermined]: Year-specific ZIP-to-congressional-district crosswalk used to map facility ZIP to House scores for 2010–2019.
- R_FIPS [undetermined]: State FIPS-to-abbreviation table used to map congressional district codes to states.
- R_PAC [undetermined]: Research-prepared PAC/candidate/committee/ultimate-organization matching object used to link political contributions to firm and legislator winners.
- R_ELECTIONS [undetermined]: Senate election returns CSV used to identify winning candidates for 2004–2012 and connect PAC Senate cycles to incumbents.
- R_CDP_MATCH [undetermined]: Manual GHGRP-to-CDP name crosswalk built from namesForRA.xlsx and cdpNameCrosswalk.csv, including the code’s date-span and gvkey compatibility rules.
- R_CDP_REPORTS [undetermined]: Historical CDP report CSVs read from the cdp directory and mapped back one year to emissions, then joined to Compustat for Table 9.
- R_COMP_FOR_CDP [undetermined]: Separate prepared Compustat subset for CDP firms, joined by gvkey and year and used to construct leverage, market-to-book and NAICS controls.
- R_T7_DATA_SIMILARITY [undetermined]: Facility-level Table 7 similarity object used by test1: code comments identify jacOld as the 2010 facility-to-peer index and jacNew as the 2013 comparison. The actual object row keys/period layout remain unspecified by the consuming expression.
- R_T7_INDSIMILARITY [undetermined]: Table 7 peer-group 2010 similarity summary merged into the analysis branch by groupVar and consumed as jacMean.
- R_T7_DATA_CHJAC [undetermined]: Table 7 facility-level change-in-similarity object merged by idFrs and consumed for carbon-light and carbon-intense peer-change specifications.
- SW_RPKG_DATATABLE [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_DPLYR [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_DESCTOOLS [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_GGPLOT2 [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_GTOOLS [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_HAVEN [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_LFE [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_LUBRIDATE [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_READXL [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_RSTAN [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_RSTATA [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_SCALES [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_STRINGI [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_STRINGR [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_TABLES [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.
- SW_RPKG_ZOO [preparation_required]: R package imported by build.R; installed-package metadata reports it is not installed.

## Review notes

- Scope is the complete supplied build.R program and its active Table 1–9 and model branches. The author-commented Table 3 column 4 shortcut is not the assessed target. identifiers.txt is documented as Table 4 Column 3 sample IDs, not a full panel; its values were not inspected.
- No author code, dataset, Stan model, statistical/descriptive trial, or SAS runtime was executed. Successful checks were bounded software metadata, one COMP.FUNDA row without displayed values, frozen catalog metadata, and official static product/API documentation only.
- The model source is included in build.R at lines 623–659, with an explicit instruction to save it as myStan.stan. RStan documentation supports omitting unused extra data objects and defines pars as a saved-parameter selector; code computes new-sample predictions from beta draws in R. The proposal removes only the unused logYNew selector name; exact author RStan-version behavior and model execution remain untested.
- Appendix A8 supplies the representative state-industry peer and weighted Jaccard process-similarity formula. Code further specifies NAICS4/state grouping; its comments tie the carbon-light (<=0.33) comparison to 2013 facilities and their 2010 peers, then describe the analogous carbon-intense (>0.67) peers as in 2013. The actual unresolved Table 7 gap is the missing executable producer or loaded dataSimilarity/dataIndSimilarity/dataChJac objects and any remaining implementation details the supplied recipe does not resolve.
- The local Compustat candidate does not verify the prepared firm or CDP fields/history. US and Canadian GHGRP field normalization and identifiers, manual owner matching, NEI versus EIS versus NPRI distinctions, SNL/AER gas pricing, prepared research inputs, policy coding, and CDP manual mapping remain explicitly separate. Datasheet N/A contact metadata does not establish that every source is public.
- The four complete candidate statements flagged by the safe structural scan remain withheld; no source route, credential, authentication status, facility mapping or scientific outcome is inferred from their literals. Known project-root and RStata path/version configuration is ordinary preparation.
- Failed lookup/probe/helper invocations remain in process-history artifacts only. In particular, the failed COMP.COMPANY request is not linked from any scientific evidence_ids field and does not establish missing data or unavailable access; only successful catalog metadata and the separate COMP.FUNDA bounded probe support the local candidate review.
- Datasheet sources not read by build.R, including Sautner/Fama-French/firm political-risk datasets, are not introduced as dependencies. Proposal execution, if later authorized, should use a separate working copy and leave this audited generation unchanged.
