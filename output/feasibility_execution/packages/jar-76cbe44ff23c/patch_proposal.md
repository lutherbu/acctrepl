# Patch proposal: jar-76cbe44ff23c

Reporting Regulation and Private Firms’ Bank Credit

DOI: 10.1111/1475-679X.70025

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author workflow: 00 Master Do.do invokes CIR cleaning/credit, relationship, HHI and new-loan construction (10–13), CBI/CIR merge and samples (20), then descriptive statistics, main results, mechanism/outcomes, and internal-validity/robustness programs (30–60).

Entry points: `00 Master Do.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 2/70025 - Reporting-Regulation-and-Private-Firms-Bank-Credit/moreta-datasheet-code-and-log-files.zip",
      "sha256": "8a79078f7f796830280a46b95691d4a5077071af4b5a538764802ccaf9af5f9f"
    },
    {
      "path": "JAR-Volume 64/Issue 2/70025 - Reporting-Regulation-and-Private-Firms-Bank-Credit/moreta-online-appendix.pdf",
      "sha256": "7fa6206b76fb62e14fa46d10a73808927f1f719e5901872af838d0913580cf38"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "8f23fb1c4815baaa1999b50c928de6c2d7cfdf4ca086db22eeb8622b56bb4b1c"
}
```

## Proposed actions

### A_SETUP: Configure the master driver for a separate portable working copy with the README folder layout.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_SETUP
Evidence: E_SETUP_ROOT, E_FOLDER_LAYOUT, E_MASTER_DRIVER

Preparation / proposed procedure:

1. Place the supplied do-files under 00 Code and authorized source files under 01 Raw Data.
2. Set the master directory placeholder to the chosen project root and ensure the 02 Intermediate Data, 03 Final Data, and 04 Output paths resolve under that same root.
3. Use the supplied master to preserve the 10, 11, 12, 13, 20, 30, 40, 50, 60 order and logging.

Validation to perform later:

- Before any separately authorized run, verify the resolved root, exact raw filenames, writable intermediate/final/output folders, and all include paths.

### A_CBI_INPUT: Confirm an authorized compatible CBI file/route and exact native contract for file 20.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: D_CBI, I_INPUT_ACCESS, I_CBI_WINDOW
Evidence: E_CBI_INPUT, E_CBI_PERIOD, E_CBI_FIELD_MAP, E_CBI_LABOUR_FIELDS, E_CBI_GEO_FIELDS, E_CBI_EXTRA_FIELDS, E_CBI_CLASSIFIERS, E_BDE_CBI, E_BDE_BELAB_ACCESS, E_CATALOG_02

Preparation / proposed procedure:

1. Ask the author or Banco de España route owner for the source intended by `$RAW/2009_2022.dta`, its access conditions, and a field/key dictionary covering D_CBI expected_fields.
2. Reconcile the code’s any>=2010 filter and needed forward/backward values with the datasheet’s 2012–2020 description and the official candidate’s anonymized NIF key.
3. If a compatible current route exists, stage it under the expected name in the separate working copy and validate years, identifiers, field definitions, and joinability before running.

Validation to perform later:

- Confirm exact name/format, `any` coverage, `id`/`cif` semantics, all expected fields and prior-year values, and legal-form/CIR joins; record access explicitly.

### A_CIR_CURRENT_INPUT: Confirm the current-schema 2016–2020 December CIR extracts with the native fields consumed by files 10, 11, and 13.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: D_CIR_CURRENT, I_INPUT_ACCESS
Evidence: E_CIR_PERIOD, E_CIR_CURRENT_10, E_CIR_CURRENT_FIELDS, E_RELATIONSHIP_NEW_INPUT, E_NEWLOAN_CURRENT_INPUT, E_BDE_CIR_CBI, E_BDE_BELAB_ACCESS

Preparation / proposed procedure:

1. Request or identify an authorized route for the 2016–2020 `YYYY12.dta` records and confirm each field in D_CIR_CURRENT.expected_fields, especially native borrower, bank, loan, period, rate-join, exposure, guarantee, maturity, and holder fields.
2. Compare the official 2016–2024 CIR-CBI candidate’s anonymized identifiers and available variables with the native code contract before treating it as compatible.

Validation to perform later:

- Confirm full year range, row unit, native keys, fields/value definitions and cross-year continuity; do not infer user access from the public product page.

### A_CIR_HISTORY_INPUT: Resolve the actual old-schema CIR history required by the relationship pipeline.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: D_CIR_HISTORY, I_INPUT_ACCESS, I_CIR_HISTORY
Evidence: E_CIR_PERIOD, E_CIR_OLD_SCHEMA_10, E_CIR_OLD_HISTORY, E_RELATIONSHIP_OLD_INPUT, E_BDE_CIR_CBI, E_BDE_BELAB_ACCESS

Preparation / proposed procedure:

1. Request the SOC December extracts for 2000–2015 or an evidenced compatible source with the exact old native fields in D_CIR_HISTORY.expected_fields.
2. Confirm the 2000–2009 history used for lags and continuity/translation of old fields into the later 2016–2020 schema.
3. Reconcile why the code needs 2000–2015 while the datasheet describes 2013–2020, and record the author’s actual supported source route/access.

Validation to perform later:

- Check 2000–2015 year coverage, 14-lag relationship construction, key/field continuity, and row semantics before executing file 11.

### A_CIR_SPREAD_INPUT: Confirm the separately required CIR year-end rate text extracts.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: D_CIR_SPREAD, I_INPUT_ACCESS
Evidence: E_CIR_INTEREST, E_CIR_SPREAD_INPUT, E_CIR_SPREAD_CONSUMER, E_CATALOG_01, E_CATALOG_04

Preparation / proposed procedure:

1. Obtain or identify an authorized compatible source for the December 2018, 2019, and 2020 `YYYY12.txt` files with the exact expected fields.
2. Confirm the operation-period key matches current CIR and that the rate definition/units match `hc_tip_efect_def_rest_calc`.

Validation to perform later:

- Verify all three periods, field names, key uniqueness/coverage and rate units before file 10/13 joins.

### A_APPLICATIONS_INPUT: Confirm the request-level CIR application-event file and its lawful source route.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: D_APPLICATIONS, I_INPUT_ACCESS
Evidence: E_APPLICATIONS, E_APP_INPUT, E_APP_FINAL_JOIN, E_BDE_BELAB_ACCESS, E_BDE_CIR_CBI, E_CATALOG_03

Preparation / proposed procedure:

1. Ask the author or source owner for the intended `loan applications.txt` input, its period and event-row definition, native fields, and user-specific authorization.
2. Retain the code’s distinction between lender `cod_entidad`, request date `fn_peticion`, applicant `cod_titular`, and derived CIF-year; do not substitute general CIR aggregates without evidence.

Validation to perform later:

- Confirm each required field, request-event population, date coverage and CIF-year merge semantics before file 50.

### A_FORMA_SOCIAL: Obtain the separate legal-form table contract used by both file 20 and Section 8.4.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: D_FORMA_SOCIAL, I_MAP_CONTRACT
Evidence: E_CBI_FORMASOCIAL, E_60_FORMA_SOCIAL, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Ask for the exact `Forma Social.dta` source/producer and confirm its CIF and `cod_forma_social` fields and coverage.
2. Preserve the source filter C04–C10 in both consumers; stage this table as a distinct input in the separate working copy.

Validation to perform later:

- Confirm CIF join coverage and legal-form values for the code’s population.

### A_MAP_MAIN1: Confirm the distinct first-main-bank province crosswalk.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: D_MAP_MAIN1, I_MAP_CONTRACT
Evidence: E_MAP_CONTRACTS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the source or producer and field dictionary for `cod_entidad_main_bank1.dta`; confirm `cod_entidad_main_bank1` to `cod_provincia_bank` mapping and coverage.

Validation to perform later:

- Verify expected key and province fields, unique key behavior, and historical bank-code coverage.

### A_MAP_MAIN2: Confirm the distinct second-main-bank province crosswalk.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: D_MAP_MAIN2, I_MAP_CONTRACT
Evidence: E_MAP_CONTRACTS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the separate source or producer and field dictionary for `cod_entidad_main_bank2.dta`; confirm `cod_entidad_main_bank2` to `cod_provincia_bank` mapping and its coverage.

Validation to perform later:

- Verify this second-bank key and province mapping independently of the first-main-bank table.

### A_MAP_ENTITY: Confirm the lender-code province crosswalk.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: D_MAP_ENTITY_PROV, I_MAP_CONTRACT
Evidence: E_MAP_CONTRACTS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the source or producer for `cod_entidad.dta` and confirm `cod_entidad` maps to `cod_provincia_bank` for all lender codes consumed by file 11.

Validation to perform later:

- Verify exact keys, province values, and coverage.

### A_MAP_CIF: Confirm the firm-CIF province crosswalk.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: D_MAP_CIF_PROV, I_MAP_CONTRACT
Evidence: E_MAP_CONTRACTS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the source or producer for `cif.dta` and confirm `cif` maps to `province_firm` with the necessary historical firm coverage.

Validation to perform later:

- Verify CIF key behavior and province coding separately from bank maps.

### A_IDENTIFIER_PRODUCER: Identify the producer or exact input source for the HHI CIF/province mapping table.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: D_IDENTIFIER_REGION, I_IDENTIFIER_PRODUCER
Evidence: E_IDENTIFIER_MAP_USE, E_HHI_SAVE, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the exact producer/bootstrap or supplied `identifiers_region_industry.dta` table used by file 12.
2. Confirm it contains the consumed `cif` key and `province` value with 2015 SOC coverage; do not infer an industry field merely from the filename.

Validation to perform later:

- Verify the table’s exact producer/path, field names, key mapping and coverage before running file 12.

### A_FIX_60_PATH: In a separate working copy, correct the Section 8.4 lookup to use the directory where file 10 saves the exact generated CIR product.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_60_PATH
Evidence: E_CIR_OLD_CREDIT_APPEND, E_60_PATH_MISMATCH

**Proposed edit:** `60 Internal Validity and Robustness.do:1421–1421`
Source SHA-256: `d12f1624adc68bcade2200a61e6ae4d6ff8165db1e96b1b84dd5916245bd2726`

File 10 writes end_of_year_credit_2013_2020.dta under $FIN at line 410, and file 20 consumes it from $FIN; this consumer alone points at $RAW.

Current text:
```
joinby cif fyear using "$RAW\end_of_year_credit_2013_2020.dta", unmatched(master) //If there are no observations in the CIR, the firm has no debt
```

Proposed replacement:
```
joinby cif fyear using "$FIN\end_of_year_credit_2013_2020.dta", unmatched(master) //If there are no observations in the CIR, the firm has no debt
```

Preparation / proposed procedure:

1. Apply the single-line repair below to a separate working copy after preserving the package source.

Validation to perform later:

- Confirm file 10 and file 20 both use the FIN path and file 60 uses the same exact generated basename after repair.

### A_BIG_PRODUCER: If the large/medium RD plots are intended to use the immediately preceding source-built 2016–2019 sample, persist that completed object before Table 11 first creates opt_h; this adds storage only and leaves the sample and variables unchanged.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: I_BIG_PRODUCER
Evidence: E_BIG_SAMPLE_CONSTRUCTION, E_BIG_CIR_JOIN, E_BIG_MAIN_FILTERS, E_BIG_TRIM_WINSOR, E_BIG_COMPLETED_OBJECT, E_BIG_TABLE11_CONSUMER, E_BIG_RELOAD, E_BIG_PLOT_FIELD_CONSTRUCTION, E_BIG_PLOT_CONSUMERS, E_60_PATH_MISMATCH

**Proposed edit:** `60 Internal Validity and Robustness.do:1496–1496`
Source SHA-256: `d12f1624adc68bcade2200a61e6ae4d6ff8165db1e96b1b84dd5916245bd2726`

Persist the completed large/medium sample after all source-built filters and outcomes, but before line 1501 first creates opt_h. The later reload then reads the same sample without saving opt_h and conflicting with its line 1536 recreation; apply with the existing line 1421 path repair in a separate copy.

Current text:
```
winsor exposure_cfab_end_assets, gen(wexposure_cfab_end_assets) p(0.01) 
```

Proposed replacement:
```
winsor exposure_cfab_end_assets, gen(wexposure_cfab_end_assets) p(0.01) 
save "$FIN\final_database_firml_BIG.dta", replace
```

Preparation / proposed procedure:

1. In a separate working copy, preserve the supplied source and apply the existing supported line 1421 $RAW-to-$FIN path repair.
2. If the large/medium plot section is intended to use the just-built 2016–2019 sample, insert the exact save immediately after line 1496 and before line 1501 first creates opt_h; do not alter filters, variables, weights or estimator settings.
3. Run the affected file only after the named inputs and software are prepared and execution is separately authorized; do not treat the new DTA as an additional raw input.

Validation to perform later:

- Confirm the saved file is written before the first opt_h creation and the later reload; confirm the reload recreates opt_h without a duplicate-variable conflict.
- With the authorized source inputs, compare sample rows, firm IDs, all fields used by Table 11/RD plots, and population against the immediately preceding in-memory object; preserve the author filters and weights.

### A_OUTREG2_SETUP: Prepare the exact missing outreg2 command in the target Stata environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_OUTREG2
Evidence: E_SW_OUTREG2, E_ORIGINAL_ENV

Preparation / proposed procedure:

1. Ask for the author-compatible outreg2 release or confirm an approved institutional Stata add-on source and version.
2. Install only through the authorized environment/package manager if a separate execution is approved; no installation was attempted here.

Validation to perform later:

- Confirm the exact `outreg2` command resolves in Stata 18 and supports the used `stats`, `ctitle`, `append`, and table-output options.

### A_WINSOR_SETUP: Verify the exact winsor command used by the source; the probe key winsor2 is a different command.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR
Evidence: E_SW_WINSOR, E_ORIGINAL_ENV

Preparation / proposed procedure:

1. Ask for the author-compatible `winsor` command/version or confirm an approved installed command that supplies the exact name.
2. Do not substitute winsor2 without an author-supported compatibility check.

Validation to perform later:

- Confirm exact command name and the source’s `gen()` and `p()` options in the target Stata environment before running.

### A_STATA_ADDONS: Resolve DCdensity, whose exact Stata 18 command check returned unavailable, and verify release compatibility for the source-invoked commands and ivreg2 support dependency ranktest; the current checks establish command presence only.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR, SW_IVREG2, SW_RANKTEST, SW_RDBWSELECT, SW_RDROBUST, SW_RDDENSITY, SW_DCDENSITY
Evidence: E_SW_WINSOR, E_SW_IVREG2, E_SW_RDBWSELECT, E_SW_RDROBUST, E_SW_RDDENSITY_DCDENSITY, E_RANKTEST_DOCUMENTATION, E_ORIGINAL_ENV, E_SW_WHICH_WINSOR, E_SW_WHICH_IVREG2, E_SW_WHICH_RDBWSELECT, E_SW_WHICH_RDROBUST, E_SW_WHICH_RDDENSITY, E_SW_WHICH_DCDENSITY, E_SW_WHICH_RANKTEST

Preparation / proposed procedure:

1. Use the exact current Stata 18 metadata results: winsor, ivreg2, rdbwselect, rdrobust, rddensity and ranktest are present; DCdensity is not found (return code 111).
2. Prepare a source-compatible DCdensity package through the approved local or author route; do not substitute another density estimator.
3. Before running the study, confirm installed releases/dependencies and the source-called syntax for winsor, ivreg2, ranktest, rdbwselect, rdrobust and rddensity; the bounded WHICH checks do not report package versions or argument compatibility.

Validation to perform later:

- Record the exact bare-command availability and compatible package release for each listed command, including the documented ivreg2/ranktest relationship; keep DCdensity preparation open until its exact command is found.

### A_RUN_FULL_PIPELINE: After the source, access, path, persistence, input and software prerequisites are resolved, run the complete supplied Stata workflow from a separate working copy.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: SW_STATA, I_SETUP, I_60_PATH, I_BIG_PRODUCER
Evidence: E_README_ORDER, E_MASTER_DRIVER, E_CIR_OLD_CREDIT_APPEND, E_RELATIONSHIP_SAVE, E_HHI_SAVE, E_NEWLOAN_FINAL_SAVE, E_BLOCK1_SAVE, E_FINAL_MAIN_SAVE, E_FINAL_2012_SAVE, E_FINAL_2016_SAVE, E_OTHER_EFFECTS_SAVE, E_60_BIG_UNPRODUCED_USE, E_BIG_SAMPLE_CONSTRUCTION, E_BIG_COMPLETED_OBJECT, E_BIG_TABLE11_CONSUMER, E_BIG_RELOAD, E_BIG_PLOT_FIELD_CONSTRUCTION, E_BIG_PLOT_CONSUMERS, E_RANKTEST_DOCUMENTATION, E_SW_WHICH_WINSOR, E_SW_WHICH_IVREG2, E_SW_WHICH_RDBWSELECT, E_SW_WHICH_RDROBUST, E_SW_WHICH_RDDENSITY, E_SW_WHICH_DCDENSITY, E_SW_WHICH_RANKTEST

Preparation / proposed procedure:

1. Stage the compatible authorized CBI, CIR old/new, spread, applications and separately listed maps under the expected raw names.
2. Resolve the identifiers_region_industry producer and other documented construction/map contracts; apply the supported line 1421 path repair and conditional line 1497 BIG persistence edit in the working copy.
3. Resolve outreg2 and DCdensity preparation and confirm compatible releases for every required Stata add-on, including the ivreg2 ranktest support dependency; current WHICH checks establish presence only.
4. Run 00 Master Do.do once from the project root; it calls 10, 11, 12, 13, 20, 30, 40, 50, and 60 in order.

Validation to perform later:

- Confirm generated products are present only after their source stages run: CIR spread/credit, bank_firm and relationship_lending, HHI, new_loan, Block1, final database variants, and other_effects_2016_2020.
- For the large/medium branch, confirm the 2016–2019 sample persists after line 1496 and before the first opt_h creation; compare row, firm-ID, field and population contracts against the later RD-plot consumers, including wexposure_cfab_end_assets, detailed, LDTB2, controls/fixed effects, resid, LDTB2_bin and the three per-bin means.
- Check exact input/output paths and reviewed log/table/figure existence after an authorized run; generated source products are not additional raw-data requirements.


## Remaining issues and prerequisites

- I_SETUP [preparation; full_pipeline]: The master contains a directory placeholder and the README expects a consistent 00 Code/01 Raw Data/02 Intermediate Data/03 Final Data/04 Output project layout.
- I_INPUT_ACCESS [unresolved; full_pipeline]: The datasheet calls CBI, CIR and CIR-request data proprietary and not publicly distributable. Official BELab products provide controlled-access candidates with anonymized identifiers and reported periods that do not by themselves establish source-field/key compatibility or this user’s authorization. Exact current access is unknown, not proven unavailable.
- I_CBI_WINDOW [unresolved; full_pipeline]: Author documentation describes CBI fiscal years 2012–2020, while file 20 reads 2009_2022.dta and applies any>=2010 for lag/lead construction. Confirm the intended native file, effective period, fields and join keys; the two period descriptions are not interchangeable.
- I_CIR_HISTORY [unresolved; full_pipeline]: The datasheet describes CIR December extracts for 2013–2020, but file 11 reads SOC December files from 2000–2015 for relationship construction and 14-year lags. The additional 2000–2012 history, including 2000–2009, is a real source dependency; verify its native schema and continuity with the later CIR files.
- I_MAP_CONTRACT [unresolved; full_pipeline]: Four independently consumed bank/firm province maps are referenced by exact files/keys, while the datasheet only says bank headquarters provinces were manually identified. Their exact source, construction, value definitions and historical coverage are not supplied.
- I_IDENTIFIER_PRODUCER [unresolved; full_pipeline]: File 12 reads `$FIN/identifiers_region_industry.dta` but no supplied source writes that exact table. The HHI consumer proves only the CIF join and province field used; the exact table producer/mapping remains unestablished.
- I_60_PATH [preparation; full_pipeline]: File 10 saves end_of_year_credit_2013_2020.dta under FIN and file 20 also consumes it under FIN; file 60 line 1421 instead reads the same product under RAW. A one-line working-copy repair is source-supported.
- I_BIG_PRODUCER [preparation; full_pipeline]: File 60 builds the 2016–2019 BIG/MEDIUM object from Block1, applies its visible firm/legal-form/industry/credit filters, complete-case and singleton drops, trims and winsorization, and creates `detailed` plus both exposure/assets outcomes through line 1496. Table 11 immediately uses this in-memory object; the later explicit large/medium RD-plot section reloads `$FIN\final_database_firml_BIG.dta` and recreates `opt_h`. No save connects those source locations. Inference from the matching population label, source order, and downstream fields: the just-built object appears intended for the later reload. A separate save after line 1496 and before the first `gen opt_h` is a conditional persistence repair; row/ID/field/population equivalence remains future validation.
- D_CBI [undetermined]: Annual Spanish firm-level CBI input consumed by file 20 from `$RAW/2009_2022.dta`. The program retains `any>=2010`, uses current and anterior financial fields, and joins legal form and CIR by CIF; the datasheet instead describes fiscal years 2012–2020. Confirm exact field/key contract and effective years (including the 2009 filename versus `any>=2010` filter) against the intended file.
- D_CIR_CURRENT [undetermined]: Current-schema loan-level CIR December files `2016…2020` (`$RAW/YYYY12.dta`), used by files 10, 11, and 13 to construct credit, relationship, and new-loan panels. The source code requires native loan, borrower, bank, period, product, guarantee, exposure, maturity, and holder fields.
- D_CIR_HISTORY [undetermined]: Old-schema CIRBE December files `SOC200012.dta` through `SOC201512.dta`. File 10 uses 2013–2015 to build the main credit panel; file 11 uses 2000–2015 for relationship history and creates 14 lags, so source history includes pre-2010 years 2000–2009 even though later sample rows start after 2012. File 12 also reads SOC201512.dta for 2015 HHI.
- D_CIR_SPREAD [undetermined]: Separate CIR interest-rate text extracts `$RAW/201812.txt`, `$RAW/201912.txt`, and `$RAW/202012.txt`; file 10 imports and joins them to current CIR by `cod_operacion_declarada` and `fn_periodo`. This is a separate product input from the DTA CIR extracts.
- D_APPLICATIONS [undetermined]: Loan-request event file `$RAW/loan applications.txt`, imported by file 50. Required native fields are reporting bank `cod_entidad`, request date `fn_peticion`, and applicant identifier `cod_titular`, from which code derives CIF and preceding fiscal year. It is not established that a general CIR or CIR-CBI product contains the same request-level event records.
- D_FORMA_SOCIAL [undetermined]: Separate legal-form table `$RAW/Forma Social.dta`, joined by CIF in files 20 and 60 to keep legal-form codes C04–C10. Its table is not bundled with the code.
- D_MAP_MAIN1 [undetermined]: Distinct first-main-bank province crosswalk `$RAW/cod_entidad_main_bank1.dta`, used by file 11 to attach headquarters province.
- D_MAP_MAIN2 [undetermined]: Distinct second-main-bank province crosswalk `$RAW/cod_entidad_main_bank2.dta`, used by file 11 when a firm has a second main bank.
- D_MAP_ENTITY_PROV [undetermined]: Separate lender-province crosswalk `$RAW/cod_entidad.dta`, joined by `cod_entidad` in file 11.
- D_MAP_CIF_PROV [undetermined]: Separate firm-province crosswalk `$RAW/cif.dta`, joined by CIF in file 11 to obtain firm province.
- D_IDENTIFIER_REGION [undetermined]: Separate CIF-to-province identifier table `$FIN/identifiers_region_industry.dta`, joined by file 12 for HHI. The supplied HHI code subsequently uses `province`; no source-produced table or required industry field is established.
- SW_OUTREG2 [preparation_required]: The source calls outreg2 throughout; the original typed environment metadata marks the exact outreg2 key unavailable (return code 111). No install or compatibility trial was run.
- SW_DCDENSITY [preparation_required]: Current exact Stata 18 `which DCdensity` metadata reports the command unavailable (return code 111); a compatible installation and release check are still required.

## Review notes

- Source review uses only the assigned registered v1c screened author views and exact line windows; no author program was executed, parsed by a compiler, or tested against data. Mixed outputs/logs/workbooks were not opened.
- The complete required native inputs include distinct CBI, current CIR, old CIR history, CIR spread, and request-level applications contracts plus Forma Social, four separate bank/firm province maps, and the HHI CIF/province identifier table.
- Generated source products are traced to their active writers and consumers; they are not classified as missing raw data. File 12 also produces the 2015 HHI output and file 13 produces new_loan.dta, which file 50 consumes; those additional source-owned chains are cited in the run procedure evidence.
- The official BDE pages establish candidate controlled-access products and listed coverage/identifier characteristics only. They do not establish this user’s authorization or source-field compatibility.
- The original registered environment probe remains the source for its exact reported keys; separate bounded Stata 18 version/WHICH metadata probes now establish exact command presence for winsor, ivreg2, rdbwselect, rdrobust, rddensity and ranktest, while DCdensity returned unavailable. The typed original-environment projection is not cited as a probe, package releases and estimator compatibility remain unverified, and raw query logs remain unopened.
- Author documentation describes ranktest as part of the ivreg2 package; the current exact which ranktest result confirms local command presence but not package-version compatibility.
- The proposed BIG persistence edit is an inference from file 60 source order and matching large/medium consumer fields. It saves after all sample construction and outcomes at line 1496, before the first opt_h at 1501; row, ID, field and population equivalence remains future validation.
