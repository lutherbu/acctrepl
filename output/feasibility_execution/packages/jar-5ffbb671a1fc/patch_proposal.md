# Patch proposal: jar-5ffbb671a1fc

The Effect of U.S. Country-by-Country Reporting on U.S. Multinationals’ Tax-Motivated Income Shifting and Real Activities

DOI: 10.1111/1475-679X.12594

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | restricted_access_required | blocked |

### full_pipeline

Complete supplied workflow: the Stata analysis program embedded in the DOCX, its prepared IRS analysis inputs, and the separate SAS/Orbis affiliate-financials build and Stata robustness analysis. The package has code and logs but no author data files.

Entry points: `Item 6a. JAR NPSTV - Code ALL_redact.docx`, `Item 6b. JAR NPSTV - Income shifting and real consequences tests - Orbis data 061223.do`, `Item 6c. JAR NPSTV - download aff financials from Orbis.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 2/12594 - The-Effect-of-U-S-Country-by-Country-Reporting-on-U-S-Multinationals-Tax-Motivated-Income-Shifting-and-Real-Ac/npstvdatasheetcodeandlogfiles.zip",
      "sha256": "caed470cff12c116dfc4368e04f5cbc15e067d9528069094d4a29925d0aab2bd"
    },
    {
      "path": "JAR-Volume 63/Issue 2/12594 - The-Effect-of-U-S-Country-by-Country-Reporting-on-U-S-Multinationals-Tax-Motivated-Income-Shifting-and-Real-Ac/npstv-online-appendix.pdf",
      "sha256": "dfa598b7d87f9b09a54eec74b1d37b271bb4b2f69a769b6f00b3642b3a8ee39b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "f34795d87361eedc7c3b5c3433e7b2f5905c1c6435f683ae13c73703288cad71"
}
```

## Proposed actions

### A_IRS_INPUT: Satisfy the documented IRS-controlled access condition for confidential taxpayer inputs before analysis, and separately resolve the exact route and provenance of the two source-inferred T5 panels. This is a conditional authorization prerequisite, not a claim that access was permanently denied.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_CORE_PANEL, R_DESC_IRS, R_FILERS_IRS, R_SCHM_IRS, R_8858_IRS, R_T5_TAX_IRS, R_T5_RDD_IRS, I_IRS_PREP
Evidence: E_PANEL_READ, E_DOCX_DESC_READ, E_DOCX_FILERS_READ, E_DOCX_SCHM_READ, E_DOCX_8858_READ, E_DOCX_T5_TAX_READ, E_DOCX_T5_RDD, E_IRS_CONTROL, E_IRS_LIMIT

Preparation / proposed procedure:

1. For the confidential core and documented Form-derived inputs, arrange the applicable specific NDAs and authorized IRS-computer processing by IRS employees or an IPA agreement. Keep taxpayer data within that approved environment.
2. Within the authorized environment, stage the prepared core panel, descriptive and filer tables, Schedule M table, and Form 8858 table; document each exact field/key/period contract without conflating the distinct files.
3. Because raw-to-final code cannot be supplied for confidentiality, obtain the permitted process description and keep any approved preparation inside the IRS-controlled boundary.
4. For `CbCR_T5_05102022_500.dta` and `CbCR_T5_005102022.dta`, verify actual provenance and an authorized compatible route separately; do not assume their IRS/CbCR origin from names and fields alone.
5. Record the authorized access conditions and confirm which exact prepared inputs can be used under them; do not export taxpayer data outside the approved route.

Validation to perform later:

- Before execution, verify the required NDA/IRS-computer/authorized-employee or IPA access condition for each documented protected input, then check each prepared file's actual schema, identifiers, construction, and year coverage in the secure environment.
- Keep the T5 provenance and access result separate from the documented core and Form-derived IRS inputs; do not classify an unverified T5 route as blocked without its own supported access barrier.

### A_ORBIS_INPUTS: Confirm current licensed Orbis/WRDS access and obtain the four distinct products used by the supplied branch: the manually selected U.S. MNE list, shareholder table, affiliate-individual-financials table, and separate consolidated-financials export.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_ORBIS_MNE_LIST, R_ORBIS_SHAREHOLDER, R_ORBIS_AFFILIATE_FINANCIALS, R_ORBIS_CONSOLIDATED, I_ORBIS_INPUTS
Evidence: E_ORBIS_MANUAL_SAMPLE, E_ORBIS_MANUAL_AFFILIATE, E_ORBIS_MANUAL_CONSOLIDATED, E_ORBIS_STATA_READ, E_SAS_OWNERSHIP_JOIN, E_SAS_FINANCIAL_JOIN, E_SAS_DOWNLOAD, E_CATALOG_ORBIS, E_MOODYS_TERMS

Preparation / proposed procedure:

1. Confirm the license permits the required current Orbis/WRDS tables and exports in the authorized environment.
2. Document fields and definitions for the manually selected MNE list, shareholder table, affiliate financials, and distinct consolidated export, preserving the documented join keys.
3. Verify ownership-snapshot fields, MNE selection output, affiliate close-date coverage, consolidated fields, and mapping from MNE `year` to retained affiliate `fyear`.
4. Stage the SAS-produced `AlldAffiliateFinancials061223` product for the Stata consumer as a compatible DTA/path conversion of the same logical output; do not treat it as another empirical source.

Validation to perform later:

- Verify all required input fields and keys before a separately authorized run; retain the actual selected sample, product documentation, and period coverage.

### A_PUBLIC_SERIES: Acquire the compatible public series and perform ordinary field/key conversion and working-copy staging. The Orbis GDP and statutory-tax-rate source concepts are supported by the supplied consumer and official documentation; the unresolved source mapping is limited to the three DKS inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_DKS_GDP_LAG, R_DKS_POPULATION, R_DKS_POP_LAG2011, R_ORBIS_TAX_RATE, R_ORBIS_GDP, I_PUBLIC_SERIES_MAPPING
Evidence: E_DOCX_DKS_AUX, E_ORBIS_TAX_GDP_MERGES, E_TAXFOUNDATION_PAGE, E_WDI_GDP, E_WDI_POP, E_WDI_HISTORY

Preparation / proposed procedure:

1. For the DKS branch, identify the exact World Bank indicator and country-code mapping behind `GDP.dta`, and document the `GDP_lag1` source-year requirement for 2011-2018.
2. For the DKS branch, identify the population indicator and mapping behind `Population.dta` and the distinct `Population_lag1.dta`; confirm the 2010 value used for the 2011 lag backfill.
3. Acquire historical Tax Foundation corporate statutory-tax-rate data and stage the fields expected as `iso_2`, `year`, and `rate`, with the consumer's `/100` conversion. Validate the actual retained affiliate years and observed values during preparation; an author-vintage copy is not required.
4. Acquire WDI current-USD GDP using the documented `NY.GDP.MKTP.CD` indicator and stage the expected `countrycode2`, `year`, and `gdp_current_usd` fields. Normalize the country key and validate the observed retained affiliate years and values during preparation.
5. Record the selected public release and ordinary conversion steps without requiring original DTA bytes or a full endpoint scan before route availability is credited.

Validation to perform later:

- Before analysis, verify the DKS indicator and key mappings, the separate 2010 population backfill, and the expected Orbis macro fields after staging; check coverage and value completeness against the years actually retained by the code.

### A_STATA_ADDONS: Prepare the two Stata commands that the source uses but the current registered environment does not report as available.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR2, SW_XTILEJ
Evidence: E_ENV, E_DOCX_WINSOR2, E_DOCX_XTILEJ, E_XTILEJ_REPO

Preparation / proposed procedure:

1. Use an authorized Stata package source to provision a compatible `winsor2` command and confirm the source's 1st/99th percentile syntax.
2. Provision the author-linked `xtileJ` command in an authorized Stata environment and confirm the required by-year quantile syntax.
3. Record command versions and setup details in the working-copy environment without changing the supplied document or source files.

Validation to perform later:

- In a separately authorized run, confirm the two command names and required syntax resolve in Stata before running the analysis.

### A_SAS_SETUP: Confirm an authorized SAS runtime and working SAS/CONNECT capability for the supplied remote Orbis producer workflow.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_SAS_CONNECT, I_SAS_RUNTIME
Evidence: E_ENV, E_SAS_REMOTE_OPTIONS, E_SAS_UPLOAD, E_SAS_DOWNLOAD

Preparation / proposed procedure:

1. Identify the approved SAS runtime, version and access route for the environment that can reach the required remote Orbis tables.
2. Confirm the authorized SAS/CONNECT session, upload/download capability, write permissions, and portable output path in that environment.
3. Keep credentials and connection configuration in approved secret-handling systems; do not place them in source, logs, or the assessment.

Validation to perform later:

- Before a separately authorized analysis run, verify runtime and session readiness without exposing credentials or executing the supplied SAS source during this review.

### A_RUN_SEQUENCE: After all required inputs and software are available, carry out the supplied DOCX/Stata and SAS/Orbis/Stata branches in the source-backed order recorded in the workflow trace. The DOCX program must first be extracted and reflowed into a working copy; portable input/output paths must be configured there.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_CORE_PANEL, R_DESC_IRS, R_FILERS_IRS, R_SCHM_IRS, R_8858_IRS, R_T5_TAX_IRS, R_T5_RDD_IRS, R_DKS_GDP_LAG, R_DKS_POPULATION, R_DKS_POP_LAG2011, R_ORBIS_MNE_LIST, R_ORBIS_SHAREHOLDER, R_ORBIS_AFFILIATE_FINANCIALS, R_ORBIS_CONSOLIDATED, R_ORBIS_TAX_RATE, R_ORBIS_GDP
Evidence: E_WORKFLOW_TRACE, E_PANEL_500_PRODUCER, E_PANEL_RDD_PRODUCER, E_PANEL_FULLYEAR_PRODUCER, E_DOCX_XC_BUILD, E_DOCX_XC_CONSUMER, E_DOCX_XC_R2_BUILD, E_DOCX_BALANCED_BUILD, E_DOCX_BALANCED_RDD_BUILD, E_SAS_IMPORT, E_SAS_OWNERSHIP_JOIN, E_SAS_FINANCIAL_JOIN, E_SAS_DOWNLOAD, E_ORBIS_STATA_READ, E_ORBIS_TAX_GDP_MERGES

Preparation / proposed procedure:

1. Preserve the original DOCX and source files; extract and reflow the embedded Stata program as a separate working-copy driver, then set its inputs and outputs to the authorized project paths.
2. Stage the separately required prepared IRS inputs and public series after the field/key/period contracts have been verified.
3. Run the DOCX branch in source order, retaining `mydata_500.dta`, `mydata_RDD.dta`, `mydata_RDDfullyears.dta`, `mydata_cross.dta`, `mydata_XC_r2.dta`, `Balanced.dta`, and `BalancedRDD.dta` at their producer/consumer handoffs.
4. Run the SAS branch after confirming remote setup: import/upload the selected MNE list, join shareholder ownership, derive ownership measures, join affiliate financials, and download `AlldAffiliateFinancials061223`.
5. Stage that same logical affiliate product in the DTA form and path expected by the Stata consumer; merge the separate consolidated export, then merge the verified public tax and GDP series.
6. Run the supplied Stata robustness models after verifying software and inputs; retain branch-specific logs and outputs with the working-copy path map.

Validation to perform later:

- Check each generated product exists before its first consumer; verify the matching keys and schemas at each merge; confirm all original mandatory branches and intermediate sample products are retained.
- Record the actual execution environment, input versions, source hashes, and output hashes in a later authorized run; this static assessment does not verify results.


## Remaining issues and prerequisites

- I_IRS_PREP [blocking; full_pipeline]: The package contains none of the separately required prepared core, descriptive, filer, Schedule M, Form 8858, or two T5 tax inputs. For the core panel and the documented IRS-prepared/form-derived inputs, the datasheet explicitly requires confidential taxpayer work to remain on IRS computers under specific NDAs with IRS employees or an IPA agreement and prohibits outside taxpayer disclosure; their restricted routes are blocked absent that authorization. This is a supported access prerequisite, not a catalog inference or permanent denial. Complete schemas, coverage, and some table construction details remain unknown, and the datasheet says raw-to-final code cannot be supplied. The two `CbCR_T5` panels remain a separate case: their IRS/CbCR origin is inferred from names and fields, so their exact provenance, access route, and preparation contract remain unverified.
- I_ORBIS_INPUTS [unresolved; full_pipeline]: The Orbis branch needs four separate inputs: the author-selected U.S. MNE list, the shareholder table, the affiliate-individual-financials table, and a distinct MNE consolidated-financials export. None is in the package. The source supports their product identities and keys, but current licensed access, required fields/coverage and the MNE-year versus affiliate-fiscal-year mapping are not verified. Moody's terms are license-specific; the catalog miss is not evidence that access is absent. The SAS output and Stata consumer share the `AlldAffiliateFinancials061223` product name, so conversion/path staging is preparation rather than a separate missing empirical input.
- I_PUBLIC_SERIES_MAPPING [unresolved; full_pipeline]: The DKS branch reads three distinct country-year files (`GDP.dta`, `Population.dta`, and `Population_lag1.dta`). Although the datasheet identifies World Bank data generally, it does not map these filenames to their exact indicators or country-key transformations. The separate 2011 population-lag backfill also requires confirming its 2010 source value. The two Orbis macro inputs have compatible named public sources; acquisition, key normalization, staging, and validation of observed values/coverage are ordinary preparation, not unresolved source availability.
- I_SAS_RUNTIME [unresolved; full_pipeline]: The Orbis producer branch uses SAS/CONNECT remote submit, upload, and download operations. The registered environment probe does not verify a usable SAS runtime, and current SAS/CONNECT configuration or entitlement was not established. No SAS executable or connection configuration was exercised.
- R_CORE_PANEL [restricted_access_required]: The prepared IRS analysis panel `mydata_S1_r3.dta`, directly read by the embedded Stata program and used to produce the 500-bandwidth, RDD and full-year RDD analysis panels. The supplied source uses firm, country and year identifiers and variables including `EIN1`, `year`, `Year`, `Country`, `IRS_Country`, `Treatment`, `revt_lag_comp`, `C`, `prft_lss_5`, `log_comp_5`, `l_tngbl_assts_5`, `Net_Payments`, `log_GDP` and `log_ROA_5471`; this is not an exhaustive schema. The 2011–2018 analysis windows and a 2011 population-lag backfill are explicit, but the base panel's full date extent and complete schema are not supplied.
- R_DESC_IRS [restricted_access_required]: The separately consumed prepared IRS descriptive dataset `cbcr_desc_060623_fyc`, read by the embedded Stata program for the descriptive tables. The active program's consumed variables and period must be matched to this exact prepared table.
- R_FILERS_IRS [restricted_access_required]: The separately consumed prepared IRS filer table `cbcrfilers_8975_5471_8858cons`, read in the embedded Stata program for filer/sample construction. It is an independent input from the descriptive table and the main analysis panel.
- R_SCHM_IRS [restricted_access_required]: The distinct prepared Schedule M file `CbCR_Sample_P3_080323_SchM.dta` merged into two analysis branches. The code requests `Dividends_Recd_F`, `Hybrid_Dividends_Recd_F`, `Dividends_Recd`, `Hybrid_Dividends_Recd`, `prft_lss_nodivs_5`, `tot_divs_5`, `prft_lss_5`, `oth_inc_5471` and `Age` on `EIN1`, `Year`, and `Country`.
- R_8858_IRS [restricted_access_required]: The separately consumed prepared Form 8858 file `f8858_fy.dta`, merged into the main and RDD analysis branches on `EIN1` and `year`. The supplied Stata code requests `F8858` and `F8858_any`.
- R_T5_TAX_IRS [undetermined]: The distinct prepared tax panel `CbCR_T5_05102022_500.dta` used by the tax-avoidance regressions. The code consumes `EIN1`, `year`, `Treatment_firmXPost`, `nmo`, `etr`, `cetr`, and the specified firm controls, including `size_comp`, `roa_comp`, `lev_comp`, `intan_intensity_comp`, `capex_intensity_comp`, `rnd_comp`, `Loss_comp`, `perc_for_income_comp`, `missing_perc_for_income_comp`, and `Num_Countries_5471`.
- R_T5_RDD_IRS [undetermined]: The separate prepared panel `CbCR_T5_005102022.dta` used in the tax-avoidance RDD branch. The supplied code reads `EIN1`, `revt`, `Treatment`, `revt_lag_comp`, `Post`, `nmo`, `etr`, `cetr`, year indicators, and the named firm controls.
- R_DKS_GDP_LAG [undetermined]: The direct country-year input `GDP.dta` to the DKS branch. The code requests `GDP_lag1` on `Country` and `Year`; the corresponding current `GDP` comes from the prepared panel. The required one-year lag is needed for 2011–2018 calculations, including a 2010 value for the 2011 observation.
- R_DKS_POPULATION [undetermined]: The separate country-year input `Population.dta`, merged for `Population` and `Population_lag1` on `Country` and `Year` in the DKS branch.
- R_DKS_POP_LAG2011 [undetermined]: The independently consumed `Population_lag1.dta` country-year backfill, providing `Population_lag2011` for the code's 2011 replacement of `Population_lag1`.
- R_ORBIS_MNE_LIST [undetermined]: The external Orbis MNE-list input imported by SAS as `WORK.CbCR_MNEs052323`, sourced from `US MNEs - 51X-50.01Y Consolidated Rev 051723.dta`. The downstream Stata branch requires `BvDIDnumber`, `mnefyear` and `mnel1revenue` for owner linkage and 2008–2021 treatment construction; those file-level fields are not independently verified.
- R_ORBIS_SHAREHOLDER [undetermined]: The independent Orbis shareholder table `bvd.ob_basic_shareholder_info_lms`, joined by MNE `BvDIDnumber` to `GUO_9105`. The SAS producer requires `bvdid`, `ctryiso`, `_9499`, and `GUO_9100`, `GUO_9105`, `GUO_9102`, `GUO_9108`, `GUO_9109`, and `GUO_9114`; it then derives direct and total ownership percentages.
- R_ORBIS_AFFILIATE_FINANCIALS [undetermined]: The separate Orbis affiliate-individual-financials table `bvd.ob_w_ind_g_fins_cfl_usd_lms`, joined by `bvdid` into the SAS output. Consumer-side fields expected from this `b.*` input include `bvdid`, `CLOSDATE_year`, `CLOSDATE`, `nr_months`, `oppl`, `opre`, `tfas`, `staf`, `plbt`, `toas`, `fias`, `naics2022corecode4digits`, `conscode`, and `filing_type`. `BvDIDnumber` is a separate MNE-list field passed through `a.*`; exact table schema and aliases remain unverified.
- R_ORBIS_CONSOLIDATED [undetermined]: The distinct manual Orbis export `USMNEs_consolidatedfinancials_061423.dta`, merged into the affiliate file on `BvDIDnumber` and `CLOSDATE_year`. Its consolidated-account columns used downstream and their provenance versus the MNE-list fields are not identified by the supplied code's data headers.
- R_ORBIS_TAX_RATE [public_acquisition_required]: The country-year statutory-tax-rate input `Corporate-Tax-Rates-Data-1980-2019.dta`, merged on `iso_2` and `year`. The Stata code reads `rate`, converts it to numeric and divides by 100.
- R_ORBIS_GDP [public_acquisition_required]: The country-year current-USD GDP input `gdp_current_usd.dta`, merged on `countrycode2` and `year` for the affiliate-country calculations.
- SW_WINSOR2 [preparation_required]: The registered environment probe reports winsor2 unavailable; the embedded Stata program uses it for 1st/99th percentile winsorization.
- SW_XTILEJ [preparation_required]: A bounded Stata metadata probe reports xtileJ unavailable. The author-linked repository documents by-group behavior, but no package was downloaded or installed.
- SW_SAS [unverified]: The registered environment probe marks SAS unavailable/status unverified. SAS was not launched during this review, so a working SAS runtime is not established.
- SW_SAS_CONNECT [unverified]: The supplied SAS branch requires a remote SAS/CONNECT session and upload/download operations. Current SAS/CONNECT configuration and entitlement were not tested or established.

## Review notes

- Final target is the complete supplied workflow: the Stata analysis embedded in the DOCX and the separate SAS/Orbis/Stata branch. All nine registered sources were read using their exact cached content paths; source statements and frozen dependency IDs were statically traced.
- The DOCX contains substantive but not directly executable Stata code; extraction/reflow and working-copy path configuration are preparation. The source-backed trace records generated intermediate products and each downstream handoff. The SAS-produced and Stata-consumed AlldAffiliateFinancials product is one logical dataset; DTA/path staging is preparation, not a distinct empirical input.
- The package contains no prepared data files. The core prepared panel and independently documented IRS/Form-derived inputs have a supported IRS-controlled access barrier: applicable NDAs and IRS-computer processing by authorized IRS employees or an IPA agreement are required, and taxpayer data cannot be disclosed outside that route. Their restricted routes are blocked here absent authorization; this is not permanent denial. Their exact schemas, periods, and some construction remain unknown. The two T5 panels remain unverified because their IRS/CbCR provenance and access route are inferred rather than documented at file level.
- The four Orbis licensed/data inputs remain distinct; current licensing, field coverage, MNE selection, ownership snapshot, consolidated fields, and the MNE-year to affiliate-fyear mapping are unresolved. The two Orbis public macro routes remain verified compatible sources; key normalization, DTA staging, and checks on actual retained-year values remain preparation.
- Official documentation and the supplied consumer support compatible public routes for Orbis current-USD GDP (WDI `NY.GDP.MKTP.CD`) and historical corporate statutory-tax rates (Tax Foundation historical data). The DKS GDP/population indicators and country-key transformations remain unresolved, including the separate 2010 population backfill. No link was clicked, data payload or API was requested, or external dataset inspected.
- The registered environment probe and bounded metadata probes were inspected only through fixed safe fields. Stata and named Stata dependencies are reported as available except winsor2 and xtileJ, which need setup; SAS and SAS/CONNECT remain unverified. No SAS executable, author program, regression, installation, or data payload was run.
- Two bounded metadata inspection commands had clerical errors and are preserved in `probes/work_item_inspection_bad_attempt_001.json` and `probes/schema_inspection_bad_attempt_001.json`; neither changed source bytes, the draft, or data. A prior finalizer clerical failure and its fixed-owned classification remain preserved.
