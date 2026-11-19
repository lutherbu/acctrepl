# Patch proposal: jar-5b71b782256f

Linguistic Complexity in Firm Disclosures: Obfuscation or Information?

DOI: 10.1111/1475-679X.12179

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow through supplied SAS sample construction and all main and Appendix IA-1–IA-10 analyses. The local SAS ends at the analysis comment; it does not contain regression entry code.

Entry points: `BGTv4.3_JAR.SAS`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 1/12179 - Linguistic-Complexity-in-Firm-Disclosures-Obfuscation-or-Information/bgt-datasheet-and-code.zip",
      "sha256": "685ef1f5ba727875af66013ddf38d4af85699610a9b7d6edbe602aeec7ae0ab3"
    },
    {
      "path": "JAR-Volume 56/Issue 1/12179 - Linguistic-Complexity-in-Firm-Disclosures-Obfuscation-or-Information/bgt-internet-appendix.pdf",
      "sha256": "c8be66b4faca4a64bce2393d4d39b3f75ecd0526c1552322b09b9f178986b06d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "fe0b135fe9d92e42bcaf43d86c8570e459342ad3bd0244b8d239c7033732c67a",
  "work_item_sha256": "89ac91b34c0c808eaee29f801b8c38bd2fffaa6260e335bac99cd2b8a31c3545"
}
```

## Proposed actions

### A_CALL_INPUTS: Request the exact author-prepared bgt.measures_confcall and bgt.fog_data3 files (or identify how the updated author SAS file covers both), their dictionaries and date coverage, and the versioned transcript-processing code/recipe. Confirm authorized StreetEvents access and the ticker/date-to-PERMNO/GVKEY and speaker-order procedure. The public repository README is a candidate producer lead; compare its version and output columns with BGTv4.3 before using it.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R_CALL_INPUTS, I_NLP_PRODUCERS
Evidence: E_DOC_ACCESS, E_DOC_STEPS1, E_DOC_AUTHOR_ROUTE, E_CODE_MEASURES, E_CODE_FOG, E_REPO_CODE

Preparation / proposed procedure:

1. Confirm whether the author-request SAS file is a final analysis dataset or the two intermediate files read by BGTv4.3.
2. Obtain exact input schemas, key uniqueness, types, sample coverage and transcript-processing/version information for both file names.
3. If using raw StreetEvents, verify authorized subscription or historical-copy access and obtain the documented producer before creating either input.

Validation to perform later:

- Check required fields and keys PERMNO, GVKEY, RDQ and CALL_DATE in both inputs; confirm call-date coverage and speaker/text-derived measure availability for 2002–2011.
- Compare the actual supplied input names and fields with the SAS reads and confirm an author-supported output-to-input mapping before running Steps 1–5.

### A_IBES_INPUTS: Confirm authorized WRDS access or a compatible author-prepared route for the exact STATSUMU_EPSUS, ACTU_EPSUS, ACTPSUMU_EPSUS and ICLINK products; also obtain DET_GUIDANCE and the author mapping for the appendix Management Forecast control. Use local candidates only after proving product/version, fields and history.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R_IBES_SUMMARY, R_IBES_ACTUALS, R_IBES_PRICING, R_IBES_LINK, R_IBES_GUIDANCE
Evidence: E_DOC_PRODUCTS, E_DOC_SUBSCRIPTION, E_CODE_IBES_SUMMARY, E_CODE_IBES_ACTUALS, E_CODE_IBES_PRICE, E_CODE_IBES_LINK, E_P_IBES_SUM, E_P_IBES_ACT, E_P_IBES_LINK, E_P_IBES_GUID, E_CATALOG_MAP, E_APP_IA10_GUIDANCE

Preparation / proposed procedure:

1. For STATSUMU_EPSUS and ACTU_EPSUS, confirm full required date ranges and preserve the USD/EPS/US-firm filters and ticker/fiscal-period/announcement joins.
2. Obtain the exact ACTPSUMU_EPSUS schema with PRICE, SHOUT and PRDAYS and verify 2000–2012 coverage; the local catalog candidate list does not establish this product.
3. Compare WRDSAPPS.IBCRSPHIST score meaning, effective dates and vintage with author ICLINK2013, including the stated score threshold and one-to-one tie removal.
4. For DET_GUIDANCE, obtain author timing/matching rules mapping raw guidance rows to Management Forecast for IA-10.

Validation to perform later:

- Confirm field definitions, units/currency, identifier map and history on full source metadata rather than one-row probes.
- Reconcile local column mappings and row/date coverage with the exact author data requirements before considering any route verified.

### A_COMPUSTAT: Confirm local or authorized WRDS Compustat quarterly and annual product vintages and the required fiscal periods, then map their raw fields to the author inputs while preserving the supplied filters and joins. The FYEARQ>=1990 condition is a source filter, not proof that the full dataset from 1990 onward is required.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMPUSTAT_Q, R_COMPUSTAT_A
Evidence: E_DOC_PRODUCTS, E_CODE_COMPQ, E_CODE_COMPQ_LAGS, E_CODE_COMPA, E_P_COMPQ, E_P_COMPA

Preparation / proposed procedure:

1. Preserve the supplied quarterly FYEARQ>=1990 filter, but establish needed quarterly coverage from actual matched sample fiscal periods, Q/Q−1/Q−4 joins, and consecutive-quarter flow construction; the filter alone does not establish the earliest required source date.
2. Confirm source identifiers, date fields, INDFMT/DATAFMT/POPSRC/CONSOL filters, and fields used for Q, Q−1, Q−4 and annual controls.
3. Use the documented joins and variable definitions; do not infer coverage from catalog counts or one-row probe samples.

Validation to perform later:

- Check quarterly date ranges against observed 2002–2011 call/fiscal-period records and the Q, Q−1, Q−4 and flow-change construction; do not assume all observations from 1990 onward are needed.
- Compare merged keys and expected control calculations with the author’s exact SAS input schema before an authorized execution.

### A_CRSP_INPUTS: Verify CRSP monthly and daily coverage, source definitions and author-file mappings; use exact local MSF/name-history candidates only if a documented effective-date join reproduces fields consumed by the code.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CRSP_MONTHLY, R_CRSP_DAILY
Evidence: E_DOC_PRODUCTS, E_CODE_CRSP_MONTHLY, E_CODE_CRSP_DAILY, E_P_CRSP_M, E_P_CRSP_N, E_P_CRSP_D

Preparation / proposed procedure:

1. Confirm daily DSF history for the event dates and code windows: two calendar months before datadate through datadate for returns, and weekdays 0–25 after call_date for illiquidity.
2. Confirm monthly MSF and MSENAMES fields/date intervals and author crspmonthly70to12dlst mapping for PERMNO, DATE, PRC, SHROUT, CFACPR, CFACSHR, SHRCD, SICCD and EXCHCD.
3. Do not assume a custom delisting-augmented file is equivalent solely from the filename; obtain its schema or author construction notes.

Validation to perform later:

- Verify date and PERMNO joins over all 2002–2011 calls and their required pre/post windows.
- Check price/adjustment/share and name-history field definitions against author inputs before treating either local route as verified.

### A_FF_FACTORS: Verify the local or author-prepared daily Fama–French/UMD factor file, its factor units/vintage, and overlap with the CRSP return window.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_FF_DAILY
Evidence: E_CODE_CRSP_DAILY, E_P_FF, E_CATALOG_MAP

Preparation / proposed procedure:

1. Confirm daily DATE, RF, MKTRF, SMB, HML and UMD fields and the factor units used in the author-prepared FFandUMDdaily70to12 file.
2. Verify factor date coverage for the same pre-event daily CRSP observations used to estimate idiosyncratic volatility.

Validation to perform later:

- Check factor units and date joins with the author schema and confirm full required event-window coverage.

### A_SEGMENTS: Obtain the author analysis recipe for constructing NumBusSegments and NumGeoSegments from WRDS_SEGMERGED, including segment-type filters and date mapping; then verify authorized access or use the local candidate only if compatible.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_SEGMENTS
Evidence: E_DOC_PRODUCTS, E_APP_IA3, E_P_SEG, E_CATALOG_MAP

Preparation / proposed procedure:

1. Confirm the exact segment categories and date/identifier matching used in Appendix IA-3.
2. Verify full 2002–2011 coverage in the local or WRDS source and preserve the author count definitions.

Validation to perform later:

- Reconcile the derived business/geographic segment counts with author definitions and source fields before entering IA-3 analysis.

### A_TAQ: Confirm authorized access to the TAQ intraday trade/quote product and obtain the exact author cleaning, signing and lambda estimation program for Appendix IA-1.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R_TAQ
Evidence: E_APP_IA1, E_DOC_SUBSCRIPTION, E_CATALOG_MAP

Preparation / proposed procedure:

1. Identify the authorized historical TAQ route, field schema, firm/PERMNO mapping and event-date coverage.
2. Obtain the author-supported cleaning, trade-sign, lambda estimation, and 1%/99% winsorization procedure; do not infer variable names or estimation code from the formula alone.

Validation to perform later:

- Confirm the daily event windows (0), (0,+1) and (0,+25), at least ten trades per firm-day, and the appendix sample coverage after applying author specifications.

### A_ANALYSIS_CODE: Obtain the actual author regression programs and execution order for the primary analyses and every Appendix IA-1–IA-10 branch. The public repository is a code lead for fog construction; it does not verify the missing regression programs or their compatibility with this package.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: I_ANALYSIS_CODE
Evidence: E_DOC_STEPS2, E_CODE_SAMPLE, E_APP_TOC, E_APP_IA1, E_APP_IA3, E_APP_IA6, E_APP_IA7, E_APP_IA8, E_APP_IA9, E_APP_IA10_GUIDANCE, E_APP_IA10_MODEL, E_REPO_PUBLIC, E_REPO_CODE

Preparation / proposed procedure:

1. Request versioned main-table and IA-1–IA-10 scripts, any required supporting data/code, exact analysis order, sample filters, and estimators.
2. Confirm whether Appendix IA-9 invokes the supplied winsor macro or another procedure; the local macro is defined but not called in BGTv4.3_JAR.SAS.
3. Preserve all appendix branches, including TAQ, segment controls, speaker-half decomposition, FathomFog, outlier sensitivity, and single-stage estimation.

Validation to perform later:

- Verify each reported table has an identified input producer and analysis entry point before execution.
- After authorized execution with complete inputs, compare table-specific sample counts and output values to the paper/appendix; do not infer analysis code from printed tables.

### A_SAS_RUNTIME: Confirm a compatible working SAS 9.4 runtime and version through an authorized environment; the existing probe did not establish runtime availability.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_SAS, I_SAS_RUNTIME
Evidence: E_P_ENV, E_CODE_ENTRY

Preparation / proposed procedure:

1. Resolve the environment prerequisite through the approved SAS administrator or a compatible authorized runtime; no license conclusion follows from the TKELS probe.
2. Before author code execution is authorized, confirm the intended runtime version and that a minimal SAS session can initialize.

Validation to perform later:

- Record the working SAS version and verify a minimal session starts successfully before running any author program.

### A_FATHOM_RUNTIME: Identify the author-supported Lingua::EN::Fathom version/runtime required for Appendix IA-8 and verify availability only after the analysis code and intended execution environment are known.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_FATHOM, I_FATHOM_RUNTIME
Evidence: E_APP_IA8, E_APP_TOC

Preparation / proposed procedure:

1. Request the package/version and any companion setup notes from the author analysis program.
2. If it is not available, determine the authorized setup route before any installation.

Validation to perform later:

- Confirm the installed routine/version and compare its output on author-provided examples or checks before estimating IA-8.

### A_PATH_CONFIG: After confirming compatible author inputs, configure the SAS bgt and wrds librefs to the intended Linux staging/input roots and writable output root. Stage inputs under the exact member names referenced by the program; do not infer conversions or replacement data. Preserve bgt.finalsample_JAR as the intermediate supp output created before the later in-memory addcalldata cleaning.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_CONFIGURATION
Evidence: E_CODE_LIBNAMES, E_CODE_FINALSAMPLE_STAGE, E_CODE_SAMPLE

Preparation / proposed procedure:

1. Confirm the actual Linux directories and which verified author-compatible SAS files belong in the bgt and wrds libraries.
2. Configure the two librefs for those confirmed roots and preserve the expected member names, including measures_confcall, the IBES/Compustat/CRSP/factor inputs, and writable bgt output.
3. Keep bgt.finalsample_JAR at the documented point after supp is formed; treat addcalldata as the later WORK dataset containing the final filters and derived controls.

Validation to perform later:

- Confirm each required member resolves from the configured libraries and that the bgt output root is writable before author-program execution is authorized.
- After authorized execution, verify bgt.finalsample_JAR contains the pre-final supp rows and distinguish it from the subsequently cleaned WORK.addcalldata dataset.


## Remaining issues and prerequisites

- I_NLP_PRODUCERS [unresolved; full_pipeline]: The supplied SAS reads bgt.measures_confcall and bgt.fog_data3 but does not produce them. The datasheet describes NLP processing and later transcript supplements; the public repository is a candidate workflow but its version/output compatibility with BGTv4.3 is unverified.
- I_ANALYSIS_CODE [unresolved; full_pipeline]: BGTv4.3_JAR.SAS ends at “STEP #6: BEGIN ANALYSIS” after preparing addcalldata and PERMNOs; no executable code for the main regressions or Appendix IA-1–IA-10 is supplied. The appendix includes separate TAQ, segment, speaker-half, Fathom, outlier, and single-stage branches that must be represented in the actual analysis scripts.
- I_SAS_RUNTIME [unresolved; full_pipeline]: The available environment artifact records a SAS 9.4 startup failure while loading TKELS. SAS runtime availability/version therefore remains unverified; the probe does not establish a missing license.
- I_FATHOM_RUNTIME [unresolved; full_pipeline]: Appendix IA-8 specifies Lingua::EN::Fathom, but no implementation/version or runnable analysis code is supplied and availability is unverified.
- I_PATH_CONFIGURATION [unresolved; full_pipeline]: BGTv4.3_JAR.SAS hard-codes Windows D: roots for both bgt and wrds at lines 1–2. An intended Linux run needs confirmed compatible input locations and a writable output location configured under those library names. The program writes bgt.finalsample_JAR from supp before later cleaning in the WORK addcalldata step, so that permanent output is an intermediate, not the final cleaned analysis sample. Actual replacement paths and any source conversions remain conditional on confirmed inputs.
- R_CALL_INPUTS [undetermined]: StreetEvents conference-call transcript inputs and the author-prepared call/language files consumed as bgt.measures_confcall and bgt.fog_data3.
- R_IBES_SUMMARY [undetermined]: IBES unadjusted US EPS summary forecasts used to select the last consensus before earnings announcements.
- R_IBES_ACTUALS [undetermined]: IBES unadjusted US EPS actuals and announcement dates joined to the forecast ticker and fiscal period.
- R_IBES_PRICING [undetermined]: IBES unadjusted EPS pricing/shares-outstanding observations used in the forecast merge and market-value controls.
- R_IBES_LINK [undetermined]: IBES–CRSP ticker/PERMNO linkage used to create the code’s one-to-one match.
- R_IBES_GUIDANCE [undetermined]: Company-issued guidance source for the Management Forecast control in Appendix IA-10.
- R_COMPUSTAT_Q [undetermined]: Compustat quarterly fundamentals for current-quarter controls, quarterly flow changes and Q−1/Q−4 comparisons.
- R_COMPUSTAT_A [undetermined]: Compustat annual fundamentals for annual controls and five-year standard deviations.
- R_CRSP_MONTHLY [undetermined]: CRSP monthly price/share and name-history fields used at the call quarter and three months prior.
- R_CRSP_DAILY [undetermined]: CRSP daily security returns, volume and price for idiosyncratic volatility, buy-and-hold return and Amihud illiquidity.
- R_FF_DAILY [undetermined]: Daily Fama–French and momentum factors joined to CRSP returns for the idiosyncratic-volatility regression.
- R_SEGMENTS [undetermined]: WRDS Compustat segments needed to construct NumBusSegments and NumGeoSegments for Appendix IA-3.
- R_TAQ [undetermined]: TAQ intraday trades and quotes used only for Appendix IA-1 adverse-selection lambda estimates.
- S_SAS [unverified]: Required to run BGTv4.3_JAR.SAS. The copied environment probe names the SAS 9.4 command but could not initialize TKELS; this does not establish license absence or author-code compatibility.
- S_FATHOM [unverified]: Named in Appendix IA-8 for the original Gunning Fog alternative; the package/version and availability in the intended Perl environment have not been verified.

## Review notes

- Read the complete 128-line datasheet, all 384 lines of BGTv4.3_JAR.SAS, and all 623 lines of the supplied internet appendix. The appendix contains ten independent analysis tables; their branch-specific sources and software are represented even though the local SAS ends before analysis.
- A catalog lookup was made by source/product and variable labels. One-row helper probes are readable for listed candidates and confirm only sampled columns/readability; no probe establishes full date or population coverage, version identity, factor units, or author-schema compatibility.
- IBES source columns map as follows: STATSUMU_EPSUS -> TICKER/STATPERS/FISCALP/FPI/MEASURE/CURCODE/NUMEST/MEDEST/STDEV/USFIRM/FPEDATS; ACTU_EPSUS -> TICKER/PENDS/MEASURE/PDICITY/ANNDATS/VALUE/USFIRM; local IBCRSPHIST has TICKER/PERMNO/SCORE plus SDATE/EDATE but is not proven equivalent to ICLINK2013; local DET_GUIDANCE exposes raw guidance values but no confirmed Management Forecast mapping. No exact local ACTPSUMU_EPSUS or TAQ dataset candidate was identified in the frozen catalog; this is not evidence that the product or license is unavailable.
- Compustat quarterly and annual, CRSP DSF/MSF/monthly names, FF daily factors and WRDS_SEGMERGED local candidates expose the raw source columns used by the program or appendix. Periods, author-era vintages and needed joins remain unverified; the monthly custom file requires an author-confirmed mapping, and segment counts are not direct source variables.
- The published `PERMNOs.txt` is only a firm-identifier list, not a full analysis dataset. No analysis_only scope is supported because neither a compatible analysis-ready file nor regression code has been verified.
- For history, the final SAS sample filters call dates to 2002–2011; IBES inputs are filtered 2000–2012; the supplied quarterly Compustat code filters FYEARQ>=1990, but that filter does not establish a complete 1990-onward data requirement. Actual quarterly history follows the observed current, prior-quarter, prior-year-quarter and within-year flow construction; exact earliest alignment to observed fiscal/event dates remains unknown. Annual sigma controls use five prior fiscal years, CRSP idvol/BHR uses daily data from two months before datadate through datadate, and illiquidity uses weekdays 0–25 after call_date. Appendix IA-1 additionally requires TAQ at days 0 through +25; exact extended endpoints depend on observed dates and are not guessed.
- The winsor macro is present but uninvoked in the supplied SAS entry point; its dynamic input and temporary table checklist edges are optional for the assessed supplied program. The finalsample_JAR edge is generated within the program.
- The Windows D: LIBNAME roots at lines 1–2 require a conditional platform configuration for an intended Linux run. Confirm actual compatible staging/input and writable output roots before setting librefs; preserve member names and the intermediate bgt.finalsample_JAR write before the later WORK.addcalldata cleaning.
