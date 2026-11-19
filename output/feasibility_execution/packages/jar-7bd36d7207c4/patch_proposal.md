# Patch proposal: jar-7bd36d7207c4

Hedge Fund Regulation and Fund Governance: Evidence on the Effects of Mandatory Disclosure Rules

DOI: 10.1111/1475-679X.12270

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented preparation, matching and all embedded Table 1–8 analyses. The historical log contains Stata commands and output, but its Table*.do files, $path initialization and a complete run driver are not included. The online appendix's S6–S12 tables have no separate supplied driver and remain contextual.

Entry points: `2. Stata Code to Generate Primary Datasets/Generate Control Variables/DF_Controls.do`, `2. Stata Code to Generate Primary Datasets/Generate Control Variables/Gold_Controls.do`, `2. Stata Code to Generate Primary Datasets/Generate Control Variables/HF_Controls.do`, `2. Stata Code to Generate Primary Datasets/Generate Control Variables/z_3Period_Controls.do`, `2. Stata Code to Generate Primary Datasets/Generate Measures of Misreporting/DF - Cookie Jar Flag.do`, `2. Stata Code to Generate Primary Datasets/Generate Measures of Misreporting/DF - Kink Flag.do`, `2. Stata Code to Generate Primary Datasets/Generate Measures of Misreporting/Gold - Cookie Jar Flag.do`, `2. Stata Code to Generate Primary Datasets/Generate Measures of Misreporting/Gold - Kink Flag.do`, `2. Stata Code to Generate Primary Datasets/Generate Measures of Misreporting/HF - Cookie Jar Flag.do`, `2. Stata Code to Generate Primary Datasets/Generate Measures of Misreporting/HF - Kink Flag.do`, `2. Stata Code to Generate Primary Datasets/Generate Measures of Misreporting/z_3Period - Cookie Jar Flag.do`, `2. Stata Code to Generate Primary Datasets/Generate Measures of Misreporting/z_3Period - Kink Flag.do`, `2. Stata Code to Generate Primary Datasets/Matching/PSM_DF.do`, `2. Stata Code to Generate Primary Datasets/Matching/PSM_Gold.do`, `2. Stata Code to Generate Primary Datasets/Matching/PSM_HF.do`, `3. Log File of Analysis/Output File with Tables.txt`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 4/12270 - Hedge-Fund-Regulation-and-Fund-Governance-Evidence-on-the-Effects-of-Mandatory-Disclosure-Rules/honigsberg-datasheet-and-code-files.zip",
      "sha256": "b1aa608fadeac4c1f5baf922cde04233b52317e7d26cf39fa06a99322e29dc0e"
    },
    {
      "path": "JAR-Volume 57/Issue 4/12270 - Hedge-Fund-Regulation-and-Fund-Governance-Evidence-on-the-Effects-of-Mandatory-Disclosure-Rules/honigsberg-online-appendix.pdf",
      "sha256": "6407de06a65267dabe72365c670df481d2b2b76a3415a576e81b2921bca76924"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "6e17deeb047e3e8b9c56c7b07af3d90586f7c0511b59b7a4773d4dd8922c52fa"
}
```

## Proposed actions

### A_RAW_BUILD: Establish the four raw-panel inputs and the omitted ADV–TASS producer contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_RAW_HF, R_RAW_GOLD, R_RAW_DF, R_RAW_3P, R_SEC_ADV, R_TASS_CORE, I_RAW_MERGE
Evidence: E001, E002, E003, E007, E008

Preparation / proposed procedure:

1. Use the author-endorsed SEC historical Form ADV archive for SEC filings; do not require new FOIA requests or state archives unless a specific field contract establishes that they are necessary.
2. Use the early-2014 TASS vintage if legitimately available. An alternative vintage is acceptable when its fund cohort, observation history and revision coverage are demonstrably compatible; author confirmation can inform that assessment but is optional.
3. Obtain the author merge specification/code and manual adviser-name crosswalk, then create Raw_HF_Data, Raw_Goldstein_Data, Raw_DF_Data and Raw_3period_Data with the documented event windows and exact status/treatment fields.

Validation to perform later:

- Read each prepared panel's metadata and verify required fields, productreference keys, month coverage, event classifications and expected 60-month or middle-segment shapes before running preparation code.

### A_CONTROL_SIDECARS: Resolve and supply the separately merged CV_sadka and CV_audit panels for all settings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CVSADKA_HF, R_CVSADKA_GOLD, R_CVSADKA_DF, R_CVSADKA_3PERIOD, R_CVAUDIT_HF, R_CVAUDIT_GOLD, R_CVAUDIT_DF, R_CVAUDIT_3PERIOD, I_CVSADKA, I_CVAUDIT
Evidence: E009, E011, E012, E052, E053, E054, E055, E056, E057, E058, E059, E060, E061

Preparation / proposed procedure:

1. Obtain compatible author-prepared CV_sadka and CV_audit files for HF, Goldstein, Dodd-Frank and the three-period segment, or obtain the missing producers and exact inputs from the authors.
2. Preserve the keys used by each active merge: productreference/post for the three two-period settings and productreference for the three-period segment; confirm CV_sadka and CV_audit variable names/types.
3. Treat the commented Sadka recipe as a separate derivation option only after confirming variablepermanent, ID grouping, beta_cons/_stat_1 naming and the producer order; a compatible prepared CV_sadka file bypasses this route.

Validation to perform later:

- Check merge-key uniqueness and field types for each sidecar against its corresponding prepared control panel; compare historical audit-month and Sadka-control coverage to the author specification.

### A_FACTOR_INPUTS: Acquire and format the four documented Fung–Hsieh factor inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_TREND, R_BONDYIELD, R_MOODY, R_DATASTREAM
Evidence: E009, E035, E036, E037, E039

Preparation / proposed procedure:

1. Download the author-linked monthly Hsieh trend-factor Excel data and preserve its citation/source date.
2. Obtain FRED DGS10 and DBAA monthly series and compute the month-end-to-month-end changes defined on Hsieh's page; preserve yld_chg and chg_moody for the code's crdt_sprd calculation.
3. Confirm a valid Datastream route for S&PCOMP(RI) and FRUSS2L(RI), including monthly history and entitlement; map its index mnemonics to equity and sizespread without substituting another factor.

Validation to perform later:

- Before merging, confirm each factor source has unique year/month keys, expected monthly periods, units and target columns, and that the four merges retain the author samples.

### A_TABLE_SIDECARS: Resolve the separate audit, provider, custody, red-flag, ADV and fund-death analysis inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FULL_AUDIT, R_FULL_PROVIDER, R_HF_CUSTODY, R_DF_CUSTODY, R_HF_REDFLAGS, R_DF_REDFLAGS, R_DF_ADV, R_HF_FUNDDEATH, R_HF_APPEND, R_DF_FUNDDEATH, R_DF_APPEND, I_AUXILIARY_DATA, I_T8_HISTORY
Evidence: E006, E023, E024, E025, E026, E027, E028, E029, E030, E031

Preparation / proposed procedure:

1. Obtain the author-described sidecars or the exact generation recipe for each; use the public SEC archive for Form ADV based construction where applicable, and do not assume that similarly named TASS tables have the historical status fields.
2. Validate the exact keys and fields read in each Table4–8 branch, including date alignment for monthly audit/provider histories, custody, red-flag components, Q5f2c AUM and mainofficecountry.
3. For Table8, retain both FundDeath and Append inputs and the full population/history used by winsorization; retain at least the prior seven month positions needed by L2–L7 at each event-window start, plus the prior month NAV/return for flows.

Validation to perform later:

- Check each file's format, columns, keys, expected populations and periods; verify event-window filters and pre-event lag coverage against the logged code before an authorized run.

### A_VARIABLE_CONTRACTS: Resolve the exact HF treatment alias, DF matching fields, and three-period count input at their producer-consumer handoffs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_HF_ALIAS, I_DF_FIELDS, I_3P_TOTAL
Evidence: E013, E014, E015, E016, E017, E018, E019, E020, E041, E042

Preparation / proposed procedure:

1. For HF, keep reg2006 in the authored producer outputs and create the datasheet-documented NEW alias only at the HF-specific consumer handoff after checking that NEW is absent or consistent and the values match the stated treatment definition; validate both PSM_HF and the logged tables. Table8’s local NEW generation does not prove an earlier alias.
2. For DF, inspect the actual prepared DF_FLAGS and DF_Controls inputs used by PSM_DF for the exact ERA and previous_registrant fields. The included producers discard them; if these supplied outputs are used, clarify where previous_registrant comes from and carry the exact names to the PSM consumer. Do not guess a renamed substitute.
3. For z_3Period Kink, determine whether the prepared Raw_3period input already contains total_obs and what it counts. Confirm the intended denominator and any filter from the author specification; do not add a generated constant or assume the 30-month rule from other branches.

Validation to perform later:

- Check the exact output columns and values at each named producer, merge them into the actual consumer schemas, and verify the stated treatment/counter definitions before an authorized run.

### A_LOG_AND_ADJDEC: Assemble the complete supplied Table1–8 analysis driver and resolve the four active adjdecember handoffs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_LOG_DRIVER, I_ADJDEC
Evidence: E005, E021, E022, E032, E033, E062, E063, E064, E065

Preparation / proposed procedure:

1. Use the actual command blocks in the historical log to assemble a complete Table1–8 driver, preserving all documented branches; the package lacks the separately called Code/Tables/Table1 tree and a standalone run entry point.
2. For each HF, Goldstein, three-period and DF cookie-jar branch, either activate the author-provided commented statsby/transform block in that branch before its active *_adjdecember merge or use a compatible prepared sidecar. Keep each file name, key (ID versus productreference), and t_adjdec schema tied to its actual branch.

Validation to perform later:

- Compare the assembled driver and each cookie-jar sidecar producer/consumer in source order; verify merge key uniqueness, t_adjdec fields and that all logged Table1–8 branches remain present.

### A_PATH_CONFIG: Configure a host-visible relative project root for the supplied Stata sources and analysis log.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_WINDOWS_PATHS
Evidence: E002, E011, E021

Preparation / proposed procedure:

1. Set the Stata working directory to the recovered project root and define $path relative to that root (for example, .); keep Data/ and Output/Tables/Temp under that root.
2. Normalize all redacted [redacted-path-e6338825a968]... input and output paths coherently to relative Data/ or Output/ paths across every affected producer and consumer. Preserve the authors’ separate Code and Data structure, and do not put a Dropbox absolute path into executable configuration.

Validation to perform later:

- Inspect every same-named producer and consumer path in the recovered tree, then verify the chosen relative directories are visible and writable from the authorized Stata batch environment.

### A_SOFTWARE_SETUP: Make the four required Stata commands missing from the checked Stata 18 adopath available before an authorized run.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_CARRYFORWARD, SW_WINSOR2, SW_PSMATCH2, SW_MAT2TXT
Evidence: E066, E068, E069, E070, E043, E044, E046, E047

Preparation / proposed procedure:

1. Provision compatible releases of carryforward, winsor2, psmatch2 and mat2txt on the Stata ado-path used by the batch run; do not substitute winsor for winsor2 because the logged commands and options differ. No installation was performed during this assessment.

Validation to perform later:

- In the intended batch environment, use which on each exact command and confirm it resolves before the first preparation or analysis do-file is run.

### A_RUN_PROCEDURE: Run the complete author workflow in source order after unresolved data, schema and driver contracts have been resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_RAW_MERGE, I_CVSADKA, I_CVAUDIT, I_ADJDEC, I_HF_ALIAS, I_DF_FIELDS, I_3P_TOTAL, I_LOG_DRIVER, I_WINDOWS_PATHS, I_AUXILIARY_DATA, I_T8_HISTORY
Evidence: E003, E004, E005, E006, E021, E022, E028, E029, E030, E031

Preparation / proposed procedure:

1. Stage the compatible SEC ADV/TASS-derived raw panels, monthly Fung–Hsieh factor files, setting-specific CV_sadka/CV_audit inputs, four adjdecember files, and the separate audit/provider, custody, red-flag, DF_ADV and FundDeath/Append sidecars under the configured relative Data root.
2. Run each supplied setting-specific controls producer and kink/cookie-jar flag producer in dependency order. Make the matching adjdecember inputs available before each cookie-jar merge, and inspect the resulting *_FLAGS and *_Controls schemas before proceeding.
3. Resolve and verify the exact HF NEW/reg2006 handoff, the DF ERA/previous_registrant fields, the three-period total_obs input, and all merge keys against the actual prepared datasets; do not infer producer code where it is absent.
4. Run PSM_DF, PSM_Gold and PSM_HF only after their actual FLAGS and Controls inputs contain the fields each consumer names.
5. Use the extracted historical log commands as the complete Table1–8 analysis driver with each table’s required sidecars. For Table8 retain the full input population used by winsorization and the preceding monthly history required by L2–L7 and prior-month flow variables.

Validation to perform later:

- Run Stata in batch mode from the coherent relative project root after prerequisites are cleared; capture the full log and return code, confirm every expected Table1–8 output is produced, and check merge keys, required columns, sample windows and Table8 history before interpreting results.


## Remaining issues and prerequisites

- I_RAW_MERGE [unresolved; full_pipeline]: All setting-specific Raw_*_Data.dta files are absent. The authors omitted the Form ADV–TASS merge program and its manual name adjustments; exact field/date classification and delivered-panel compatibility are unresolved. The three packaged DTA files are identifier lists only.
- I_CVSADKA [unresolved; full_pipeline]: Each controls program actively merges a setting-specific precomputed CV_sadka file, while the accompanying statsby/transform recipe is block-commented after that merge. Its variablepermanent source and exact output contract are unresolved; the recipe references beta_cons without a visible _stat_1 rename. A compatible prepared CV_sadka file can bypass the recipe.
- I_CVAUDIT [unresolved; full_pipeline]: Each controls program actively merges a setting-specific CV_audit_*.dta. No producer is supplied; the source says the control depends on historical audit data outside the standard WRDS download. The required historical month counts and compatibility route remain unresolved.
- I_ADJDEC [preparation; full_pipeline]: Each of the four cookie-jar programs contains a commented statsby/transform block for its setting-specific *_adjdecember file, then actively merges that file. The package has no compatible prepared sidecars; activate the supplied block as a preparation step or supply compatible prepared inputs.
- I_HF_ALIAS [preparation; full_pipeline]: The datasheet explicitly says the HF treatment field NEW may be named reg2006. HF_Controls and HF_KinkFlags preserve reg2006 while PSM_HF and earlier logged analysis consume NEW. Table8 later constructs NEW from reg2006 in its own branch, which does not establish an earlier alias. At the HF handoff, retain reg2006 and materialize the documented NEW alias only after checking that NEW is absent or consistent and the values match the datasheet definition; do not rename globally.
- I_DF_FIELDS [unresolved; full_pipeline]: PSM_DF consumes DF_FLAGS plus DF_Controls and then refers to the exact fields ERA and previous_registrant. The supplied cookie-jar and kink producers explicitly keep only productreference/post/adj_dec and productreference/post/abn_kink/NEW, respectively; the controls collapse does not output ERA or previous_registrant. ERA is listed in the raw-panel notes, but previous_registrant has no specified source. A compatible externally prepared DF_FLAGS or DF_Controls could carry these exact fields; check those inputs and preserve the names without inferring aliases.
- I_3P_TOTAL [unresolved; full_pipeline]: The three-period kink program collapses total_obs without generating it in that program. The raw-panel description does not list total_obs, but the actual prepared raw input could supply it; its producer, meaning and period denominator remain unknown. Clarify the intended field and any count restriction; do not manufacture a constant or transfer the other settings’ 30-month rule.
- I_LOG_DRIVER [unresolved; full_pipeline]: The log's Table1–Table8 command blocks are substantive analysis code, but the first command invokes an external $path/Code/Tables/Table1 tree and the package contains no standalone analysis driver or initialized $path. Extract/assemble a complete driver while preserving all logged branches.
- I_WINDOWS_PATHS [preparation; full_pipeline]: The preparation sources contain redacted [redacted-path-e6338825a968]... paths, and the log expects a project-root $path. Selecting the host working directory and making these paths coherent is routine run configuration; the package still needs a complete driver and compatible inputs before execution.
- I_AUXILIARY_DATA [unresolved; full_pipeline]: Tables 4–8 consume separate TASS/ADV sidecars (audit/provider history, custody, red flags, DF_ADV and fund-death/append panels) not included in this package. Their direct input field and period contracts require validation from the log; no data acquisition or producer is supplied.
- I_T8_HISTORY [unresolved; full_pipeline]: Table8 winsorizes rateofreturn on each entire FundDeath+Append input before restricting dates, and its lag6 construction reads L2–L7 plus previous-month NAV/return. Exact full-input population/history and at least seven prior monthly observations for the first event month must be preserved/validated; 60-month target windows alone do not establish it.
- R_RAW_HF [undetermined]: Setting-specific raw monthly TASS/Form ADV panel consumed by the HF Rule control and flag programs.
- R_RAW_GOLD [undetermined]: Setting-specific raw monthly TASS/Form ADV panel consumed by the Goldstein control and flag programs.
- R_RAW_DF [undetermined]: Setting-specific raw monthly TASS/Form ADV panel consumed by the Dodd-Frank control and flag programs.
- R_RAW_3P [undetermined]: Setting-specific raw monthly TASS/Form ADV panel consumed by the three-period middle segment control and flag programs.
- R_SEC_ADV [public_acquisition_required]: Historical SEC Form ADV Part 1/ADV-W records needed for the SEC-registration, ERA, audit/red-flag, custody, AUM and office-country inputs used by this workflow.
- R_TASS_CORE [undetermined]: TASS monthly returns/NAV, fund identifiers and fund attributes needed to build the setting-specific raw panels and table 8 panels; the authors' 2014 cohort/vintage is not supplied.
- R_CVSADKA_HF [undetermined]: Precomputed Sadka liquidity sensitivity merge input for the HF control panel; a compatible prepared file can bypass the commented derivation.
- R_CVAUDIT_HF [undetermined]: Historical CV_audit merge input for the HF control panel; the source says it relies on nonstandard historical audit data and no producer is supplied.
- R_CVSADKA_GOLD [undetermined]: Precomputed Sadka liquidity sensitivity merge input for the Goldstein control panel; a compatible prepared file can bypass the commented derivation.
- R_CVAUDIT_GOLD [undetermined]: Historical CV_audit merge input for the Goldstein control panel; the source says it relies on nonstandard historical audit data and no producer is supplied.
- R_CVSADKA_DF [undetermined]: Precomputed Sadka liquidity sensitivity merge input for the Dodd-Frank control panel; a compatible prepared file can bypass the commented derivation.
- R_CVAUDIT_DF [undetermined]: Historical CV_audit merge input for the Dodd-Frank control panel; the source says it relies on nonstandard historical audit data and no producer is supplied.
- R_CVSADKA_3PERIOD [undetermined]: Precomputed Sadka liquidity sensitivity merge input for the three-period control panel; a compatible prepared file can bypass the commented derivation.
- R_CVAUDIT_3PERIOD [undetermined]: Historical CV_audit merge input for the three-period control panel; the source says it relies on nonstandard historical audit data and no producer is supplied.
- R_TREND [public_acquisition_required]: Hsieh bond/currency/commodity trend-following factors merged by year and month into every supplied cookie-jar branch.
- R_BONDYIELD [public_acquisition_required]: Monthly change in the 10-year Treasury constant-maturity yield, merged by year/month and named yld_chg.
- R_MOODY [public_acquisition_required]: Monthly change in Moody's Baa yield, merged by year/month and named chg_moody; the supplied script subtracts yld_chg to form crdt_sprd.
- R_DATASTREAM [undetermined]: Monthly Datastream S&P 500 and small-minus-large equity total-return factors merged by year/month as equity and sizespread.
- R_FULL_AUDIT [undetermined]: TASS historical audit-date panel used in Tables 4–5 and 8. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- R_FULL_PROVIDER [undetermined]: TASS historical auditor/provider panel used in Tables 4–5 and 8. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- R_HF_CUSTODY [undetermined]: HF-setting Form ADV custody indicator merged in Tables 4–5 and 8. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- R_DF_CUSTODY [undetermined]: Dodd-Frank-setting Form ADV custody indicator merged in Tables 4–5 and 8. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- R_HF_REDFLAGS [undetermined]: HF-setting Form ADV red-flag indicators merged for Table7. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- R_DF_REDFLAGS [undetermined]: Dodd-Frank-setting Form ADV red-flag indicators merged for Table7. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- R_DF_ADV [undetermined]: Dodd-Frank Form ADV AUM and main-office-country fields merged for Table6. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- R_HF_FUNDDEATH [undetermined]: HF TASS monthly fund-death panel used for the unbalanced Table8 analysis. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- R_HF_APPEND [undetermined]: HF TASS monthly append panel for funds without the primary balanced 60-month history. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- R_DF_FUNDDEATH [undetermined]: Dodd-Frank TASS monthly fund-death panel used for the unbalanced Table8 analysis. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- R_DF_APPEND [undetermined]: Dodd-Frank TASS monthly append panel for funds without the primary balanced 60-month history. The author-described sidecar is not included in the package; exact coverage/field schema needs validation.
- SW_CARRYFORWARD [preparation_required]: Used in all four setting-specific controls programs to carry dateaddedtotass forward by productreference. Exact `which` check did not find it on the checked Stata 18 adopath; provision it before a run. Stata runtime checked: 18.
- SW_WINSOR2 [preparation_required]: Used by logged Goldstein Table2 code to winsorize CV_std with the documented 0/99.88 cutpoints. Exact `which` check did not find it on the checked Stata 18 adopath; provision it before a run. Stata runtime checked: 18.
- SW_PSMATCH2 [preparation_required]: Used in each supplied propensity-score matching program and the logged Table6 matching analysis. Exact `which` check did not find it on the checked Stata 18 adopath; provision it before a run. Stata runtime checked: 18.
- SW_MAT2TXT [preparation_required]: Used in the logged Table1 and Tables4–6 output branches. Exact `which` check did not find it on the checked Stata 18 adopath; provision it before a run. Stata runtime checked: 18.

## Review notes

- The assignment uses source evidence from the cached reading/ paths named in work_item.json. No author program, regression, install, data download, external contact, or applied edit has been run.
- The three packaged DTA probes show one-column productreference identifier lists (793 DF, 446 Goldstein, 361 HF); they are not full monthly panels and no analysis-only scope is justified.
- The supplied historical log contains actual Stata commands and analysis branches for Tables1–8; it is not output-only. The online appendix's S6–S12 result descriptions do not add unsupplied analyses to this scope.
- A later bounded metadata/software check may refine catalog candidates and exact command availability; unverified historical periods, product access, and source contracts remain unresolved until supported.
- A source scan found no invoked Stata diff command; diff appears as a generated variable in the kink programs. The actual logged add-on winsor2 is included and has its own exact-command software probe.
- Four exact-command probes did not find carryforward, winsor2, psmatch2 or mat2txt on the checked Stata 18 adopath. The successful probes found winsor, eststo, esttab, estpost and estadd.
- The assessment draft construction checkpoint records the initial source_map KeyError and its corrected frozen source key in construction_diagnostics.json; the prior expanded draft is preserved as draft_checkpoint_pre_qa.json.
