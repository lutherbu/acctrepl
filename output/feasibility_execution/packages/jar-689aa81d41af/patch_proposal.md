# Patch proposal: jar-689aa81d41af

Strategic (Inconsistent) Disclosures and Sophisticated Investors: Evidence from Hedge Funds

DOI: 10.1111/1475-679X.70013

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full replication pipeline: raw TASS/SEC/manual input preparation in LMZ 2025 Code_raw file.do followed by the five prepared-panel analyses in LMZ 2025 Code_main.do. The identifier list is not a substitute for the prepared inputs, and no analysis_only scope is supported by a compatible supplied panel.

Entry points: `LMZ 2025 Code_raw file.do`, `LMZ 2025 Code_main.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 2/70013 - Strategic-Inconsistent-Disclosures-and-Sophisticated-Investors-Evidence-from-Hedge-Funds/lmz-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "64308e064cd3fd10b175d74d31ed363fe5df4cef96fd8207d09c8f0732a7ef89"
    },
    {
      "path": "JAR-Volume 64/Issue 2/70013 - Strategic-Inconsistent-Disclosures-and-Sophisticated-Investors-Evidence-from-Hedge-Funds/lmz-online-appendix.pdf",
      "sha256": "b6c520f93748efa8b52d117e40b7a3a3bf57ad0d763540a89adcb70853dcc44a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "e4a726235adc72916e276ddb291fa7b35abe2885c3d0730bf9e6483e6657f95a"
}
```

## Proposed actions

### ACT_RESOLVE_DATA_INPUTS: Stage the exact author-prepared input tables or their documented compatible source routes, then reconcile their native columns, join keys, periods, units and selection against both scripts.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_COMPANY_DETAILS, REQ_PRODUCT_PERFORMANCE, REQ_PRODUCT_PERFORMANCE_NEW, REQ_SERVICE_PROVIDER, REQ_RIA_LIST, REQ_HF_LIST_1, REQ_HF_LIST_2, REQ_HF_LIST_3, REQ_Q11_RAW1, REQ_Q11_RAW2, REQ_Q11_PARTITION1, REQ_Q11_PARTITION2, REQ_EX_FULL, REQ_HIGHRISK_FULL, REQ_Q5_FULL, REQ_Q11_MENTION, REQ_EX_MENTION, REQ_RISK_MENTION_1, REQ_RISK_MENTION_2, REQ_RISK_MENTION_3, REQ_MUTUALFUND, REQ_FIDUCIARY, REQ_OWNERSHIP, REQ_CHAR1, REQ_CHAR2, REQ_PENSIONPLANS, REQ_CHAR1_ADDITIONAL, REQ_CHAR2_ADDITIONAL, REQ_READABILITY, REQ_DEREG_LIST, REQ_DEREG_Q11_RAW1, REQ_DEREG_Q11_RAW2, REQ_DEREG_EX, REQ_DEREG_HIGHRISK, REQ_STOPREPORTING, REQ_RISKFREE_CLEAN, REQ_RISKFREE_FINAL, REQ_CRSP_CLEAN, REQ_CRSP_FINAL, REQ_FF_CLEAN, REQ_FF_FINAL, REQ_HSIEH_FINAL, REQ_HSIEH_NEW, REQ_UNSMOOTH, REQ_CHARA_MISREPORT_1, REQ_CHARA_MISREPORT_2, REQ_CHARA_MISREPORT_3, REQ_CHARA_MISREPORT_4, ISS_INPUT_CLOSURE, ISS_ANNOTATION_SCHEMA_MAP, ISS_CHARA_PRODUCERS, ISS_PRODUCT_PANEL_CONSTRUCTION
Evidence: E_PACKAGE_INVENTORY, E_RAW_IO_INDEX, E_MAIN_IO_INDEX, E_RAW_L00094, E_TASS_CATALOG, E_TASS_COMPANY_PROBE, E_TASS_SERVICE_PROBE, E_FF_MONTHLY_PROBE, E_PUBLIC_HSIEH, E_PUBLIC_SEC_ADV

Preparation / proposed procedure:

1. Obtain or locate only the named author-prepared TASS, factor, SEC, manually coded disclosure, auxiliary and survival inputs listed in requirements; do not rebuild manual judgments from public sources.
2. For every input, verify the exact source table, required native fields, identifier format, units, date coverage, key uniqueness and the transformation into the source-relative file used by Stata.
3. For the four Q11 files, record which file supplies each Q11/materiality variable; for the four chara_misreporting files, identify each producer and map the pct_finterms output columns to the file that supplies them.
4. Keep the TASS company/service and Fama-French probes as component evidence only; do not treat them as proof of the richer prepared performance, CRSP excess-return or Hsieh files.

Validation to perform later:

- Confirm each named source-relative file resolves to a documented candidate route and has all consumed native fields before any authorized future execution.
- Confirm monthly/annual date coverage and entity keys for the requested 2012–2019 branches; one-row probes do not establish history or population.

### ACT_ALIGN_RAW_MAIN_PATHS: Configure a portable same-data directory handoff so the five raw-stage generated panels resolve to the exact five basenames read by the main stage.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISS_MAIN_RAW_PATH_HANDOFF
Evidence: E_MAIN_L00022, E_MAIN_L00053, E_MAIN_L00133, E_MAIN_L00176, E_MAIN_L00224, E_RAW_L01236, E_RAW_L01469, E_RAW_L01685, E_RAW_L01378, E_RAW_L01635, E_MASKED_ROOT_LINES

Preparation / proposed procedure:

1. In a working-copy run layout, choose a stage root that contains a Data directory; configure the raw entry's relative Data outputs to write within that staged Data directory.
2. Configure the main entry's input working directory or explicit data base so each bare reader resolves to that same staged Data file; do not rely on the historical private root values.
3. Keep the generated panels from the raw entry as the main entry's inputs. If the chosen layout stages copies, document that they are the same generated panels and preserve their identifiers and columns.

Validation to perform later:

- For each of maintest_full_2022, quarterly flow_full_2022, test1_new1_2022, maintest_2022_full and maintest2_full, resolve the raw save target and main reader to one staged file before starting the main entry.
- Check each generated file's main-consumed columns, join keys and identifier/population continuity against the supplied source contracts before the later analysis branch uses it.

### ACT_FINALRESULT_ALIAS: Propose a separate save of the source-built merge2_finalresult object under the path consumed later as finalresult, without changing the existing merge2 output or the intervening monthly panel branch.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: ISS_FINALRESULT_ALIAS
Evidence: E_RAW_L00626, E_RAW_L00661, E_RAW_L00670, E_RAW_L00685, E_RAW_L00687, E_RAW_L00808, E_RAW_L00849, E_RAW_L00996, E_RAW_L01148, E_RAW_L01241, E_RAW_L01666

**Proposed edit:** `LMZ 2025 Code_raw file.do:661–661`
Source SHA-256: `0ff043ebc8cea4eab837e150786af6842f8fc192b76b52822f7fbea9f5efedc4`

The preceding source-built product-level object retains productreference, organizationcrd and companyid. The later finalresult consumers use those keys only. Saving a second path at this exact point preserves the original merge2 result and avoids relying on the intervening main_step0 in-memory panel; the data IDs and row population still need future validation.

Current text:
```
save "Data\merge2_finalresult 9.24.dta", replace
```

Proposed replacement:
```
save "Data\merge2_finalresult 9.24.dta", replace
save "Data\finalresult 9.24.dta", replace
```

Preparation / proposed procedure:

1. Apply the proposed second save only in a working copy after confirming the required input population has been built by the existing preceding code.
2. Keep the existing merge2_finalresult save unchanged and write the same in-memory product-level object to Data\finalresult 9.24.dta before the RIA import and monthly return merge.

Validation to perform later:

- Compare the row count and sorted productreference/organizationcrd/companyid keys in both saved paths in a later authorized data-validation step.
- Confirm the finalresult consumers' required identifier set and uniqueness before using the alias for auditor, disclosure, auxiliary and characteristic merges.

### ACT_SOFTWARE_SETUP: Prepare the two Stata command dependencies whose exact environment probes show a missing command or configured-only lookup.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_MATCHIT, SW_XTFMB
Evidence: E_RAW_L00163, E_MATCHIT_PROBE, E_MAIN_L00349, E_SOFTWARE_ENV

Preparation / proposed procedure:

1. Install or stage a compatible matchit ado package using its documented source and record the resolved command/version; do not run the author program during setup.
2. Configure the existing xtfmb ado lookup path in the Stata environment and record that the source command resolves under the intended run configuration.

Validation to perform later:

- Use a non-author-code command-availability check after setup to confirm matchit and xtfmb resolve and record their versions/configuration.

### ACT_CONDITIONAL_RAW_THEN_MAIN: Conditional future run procedure for LMZ 2025 Code_raw file.do followed by LMZ 2025 Code_main.do after all named inputs and exact software setup are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ_COMPANY_DETAILS, REQ_PRODUCT_PERFORMANCE, REQ_PRODUCT_PERFORMANCE_NEW, REQ_SERVICE_PROVIDER, REQ_RIA_LIST, REQ_HF_LIST_1, REQ_HF_LIST_2, REQ_HF_LIST_3, REQ_Q11_RAW1, REQ_Q11_RAW2, REQ_Q11_PARTITION1, REQ_Q11_PARTITION2, REQ_EX_FULL, REQ_HIGHRISK_FULL, REQ_Q5_FULL, REQ_Q11_MENTION, REQ_EX_MENTION, REQ_RISK_MENTION_1, REQ_RISK_MENTION_2, REQ_RISK_MENTION_3, REQ_MUTUALFUND, REQ_FIDUCIARY, REQ_OWNERSHIP, REQ_CHAR1, REQ_CHAR2, REQ_PENSIONPLANS, REQ_CHAR1_ADDITIONAL, REQ_CHAR2_ADDITIONAL, REQ_READABILITY, REQ_DEREG_LIST, REQ_DEREG_Q11_RAW1, REQ_DEREG_Q11_RAW2, REQ_DEREG_EX, REQ_DEREG_HIGHRISK, REQ_STOPREPORTING, REQ_RISKFREE_CLEAN, REQ_RISKFREE_FINAL, REQ_CRSP_CLEAN, REQ_CRSP_FINAL, REQ_FF_CLEAN, REQ_FF_FINAL, REQ_HSIEH_FINAL, REQ_HSIEH_NEW, REQ_UNSMOOTH, REQ_CHARA_MISREPORT_1, REQ_CHARA_MISREPORT_2, REQ_CHARA_MISREPORT_3, REQ_CHARA_MISREPORT_4, SW_STATA18, SW_MATCHIT, SW_REghdfe, SW_FTOOLS, SW_ESTSTO, SW_ESTTAB, SW_ESTADD, SW_COEFPLOT, SW_RANGESTAT, SW_XTFMB, ISS_INPUT_CLOSURE, ISS_MAIN_RAW_PATH_HANDOFF, ISS_ANNOTATION_SCHEMA_MAP, ISS_CHARA_PRODUCERS, ISS_PRODUCT_PANEL_CONSTRUCTION, ISS_FINALRESULT_ALIAS
Evidence: E_PACKAGE_INVENTORY, E_RAW_L00094, E_RAW_IO_INDEX, E_MAIN_IO_INDEX, E_MAIN_L00008, E_MAIN_L00009, E_MAIN_L00010, E_MAIN_L00011, E_MAIN_L00012, E_MAIN_L00022, E_MAIN_L00053, E_MAIN_L00133, E_MAIN_L00176, E_MAIN_L00224, E_RAW_L00661, E_RAW_L00670, E_RAW_L00685, E_RAW_L00687, E_RAW_L01236, E_RAW_L01378, E_RAW_L01469, E_RAW_L01635, E_RAW_L01685, E_SOFTWARE_ENV, E_RAW_L00163, E_MATCHIT_PROBE, E_MAIN_L00120, E_ESTSTO_PROBE, E_MAIN_L00290, E_MAIN_L00282, E_MAIN_L00310, E_COEFPLOT_PROBE, E_RAW_L00725, E_RANGESTAT_PROBE, E_MAIN_L00349, E_RAW_L00060, E_RAW_L00064, E_RAW_L00248, E_RAW_L00024, E_TASS_COMPANY_PROBE, E_TASS_CATALOG, E_TASS_PRODUCTREF_CATALOG, E_RAW_L00068, E_RAW_L00069, E_RAW_L00070, E_RAW_L00692, E_RAW_L00793, E_TASS_PRODUCT_PROBE, E_TASS_RETURN_CATALOG, E_RAW_L01246, E_RAW_L01249, E_RAW_L01398, E_RAW_L00783, E_RAW_L00785, E_RAW_L00802, E_TASS_SERVICE_PROBE, E_RAW_L00008, E_RAW_L00338, E_RAW_L00665, E_RAW_L00019, E_RAW_L00021, E_PUBLIC_SEC_ADV, E_RAW_L00445, E_RAW_L00449, E_RAW_L00611, E_RAW_L00980, E_RAW_L01012, E_RAW_L01037, E_RAW_L00984, E_RAW_L00988, E_RAW_L00992, E_RAW_L01019, E_RAW_L01028, E_RAW_L01023, E_RAW_L01033, E_RAW_L01051, E_RAW_L01056, E_RAW_L01067, E_RAW_L01070, E_RAW_L01076, E_RAW_L01079, E_RAW_L01085, E_RAW_L01086, E_RAW_L01090, E_RAW_L01091, E_RAW_L01095, E_RAW_L01124, E_RAW_L01128, E_RAW_L01132, E_MAIN_L00517, E_RAW_L01136, E_RAW_L01140, E_RAW_L01144, E_RAW_L01640, E_MAIN_L00137, E_RAW_L01644, E_MAIN_L00140, E_RAW_L01648, E_MAIN_L00166, E_RAW_L01479, E_RAW_L01506, E_RAW_L01483, E_RAW_L01518, E_RAW_L01487, E_RAW_L01498, E_RAW_L01502, E_RAW_L01611, E_RAW_L01618, E_RAW_L00707, E_RAW_L00710, E_FF_MONTHLY_PROBE, E_FF_CATALOG, E_RAW_L00026, E_RAW_L01278, E_RAW_L00711, E_RAW_L00029, E_PUBLIC_CRSP, E_RAW_L01282, E_RAW_L00714, E_RAW_L00730, E_PUBLIC_FF, E_RAW_L01285, E_RAW_L00717, E_RAW_L00735, E_RAW_L00027, E_PUBLIC_HSIEH, E_RAW_L00863, E_RAW_L00874, E_RAW_L01372, E_RAW_L01375, E_RAW_L01677, E_MAIN_L00514, E_MAIN_L00515, E_RAW_L01679, E_RAW_L01681, E_RAW_L01683

Preparation / proposed procedure:

1. Stage and verify the required raw/prepared input tables and manually coded products, then resolve the two software setup actions before either author entry program is started.
2. Use a portable working-copy root with a Data directory and configure the raw relative outputs and main bare-name readers to resolve to the same five generated panels.
3. Run the raw entry through its supplied source order and branches. At the source-built merge2_finalresult writer after line 661, apply only the conditional second save proposed by ACT_FINALRESULT_ALIAS; retain the original merge2 save and the monthly branch order, and compare IDs/population before later consumers.
4. Complete the raw stage and confirm all five named generated panels are present with the expected fields and keys before starting the main entry.
5. Then run the original main entry branches as supplied and check their declared table/figure outputs and source-defined panel usage; do not substitute a reconstructed analysis path.

Validation to perform later:

- Record resolved raw save/main reader file pairs for all five panels and verify that every pair refers to the same staged product before the main entry begins.
- Confirm required input and panel schemas, identifiers and branch populations; retain the source-supported merge2/finalresult key comparison for the later alias consumers.
- Verify the original main branches reach their declared output destinations and preserve the expected produced tables and figures for review.


## Remaining issues and prerequisites

- ISS_INPUT_CLOSURE [unresolved; full_pipeline]: Input closure remains incomplete because the package supplies code and an identifier list but omits many required prepared panels and author-coded inputs. Readable TASS company-details/service-provider fields and native Fama-French monthly factors are positively established as components. The richer prepared product-performance contract, manual crosswalks/disclosures, CRSP excess-return panels, Hsieh/unsmoothed panels and several auxiliary/text-characteristic producers remain specifically unverified or unprovided.
- ISS_MAIN_RAW_PATH_HANDOFF [preparation; full_pipeline]: The raw entry writes five named panels under its Data directory, while the main entry reads the same five basenames without a Data prefix. The supplied raw-stage saves and main-stage readers establish a same-data directory-alignment task; a portable working-copy layout needs no historical absolute root values. No different source population, missing output field, or scientific identity contradiction is established by the admitted evidence.
- ISS_ANNOTATION_SCHEMA_MAP [unresolved; full_pipeline]: The Q11 files are merged by organizationcrd/year and downstream code uses Q11/materiality flags, but the supplied source does not allocate each payload field to its individual CSV. The risk-mention and additional characteristic tables also have incomplete file-specific payload mapping.
- ISS_CHARA_PRODUCERS [unresolved; full_pipeline]: The raw script merges four Data\chara_misreporting files by productreference but contains no producer for them. The main analysis expects pct_finterms negative, positive, uncertainty, constraining, litigious and modal feature columns from test1_new1; the source does not map those fields to the four individual inputs.
- ISS_PRODUCT_PANEL_CONSTRUCTION [unresolved; full_pipeline]: The author-prepared product-performance tables carry a much richer contract than the six-variable catalogued TASS.PRODUCTPERFORMANCE table. The supplied programs do not show how those author tables are assembled from the available TASS components, and the bounded full-field request is unverified; no absent-data or license conclusion is drawn.
- ISS_FINALRESULT_ALIAS [preparation; full_pipeline]: The raw program builds and saves a product-level merge2_finalresult object containing keys used by later finalresult consumers, then reads that object into the monthly branch and clears memory with main_step0 before the later consumers. The distinct finalresult path is a supported conditional same-object setup handoff at the actual writer's lifecycle point, not a separately missing author data product; preserve future ID/population checks.
- REQ_PRODUCT_PERFORMANCE [undetermined]: The raw and main programs require the prepared monthly product-performance table. Its source contract includes productreference, date, rateofreturn, nav, estimatedassets, live_graveyard, currencycode, primarycategory, inceptiondate, subscriptionfrequency, redemptionfrequency, lockupperiod, redemptionnoticeperiod, private, payoutperiod, managementfee, incentivefee, highwatermark, leveraged, minimuminvestment, maxleverage, avgleverage, margin, auditdate and opentopublic.
- REQ_PRODUCT_PERFORMANCE_NEW [undetermined]: A second prepared product-performance table supplies the 2019 branch, including productreference, date, rateofreturn, estimatedassets and subscription/redemption restrictions and fees.
- REQ_RIA_LIST [undetermined]: The raw matching and fund-classification stages require the author-built RIA_list.csv. The supplied code consumes organizationcrd, sec, primarybusinessname, legalname, mainofficecity, mainofficestate, mainofficecountry, seccurrentstatus, secstatuseffectivedate, b and v201.
- REQ_HF_LIST_1 [undetermined]: Manual hedge-fund matching list 1 is an input to the source-built company/product crosswalk; the code retains companyid and organizationcrd.
- REQ_HF_LIST_2 [undetermined]: Manual hedge-fund matching list 2 is an input to the source-built company/product crosswalk; the code retains companyid and organizationcrd.
- REQ_HF_LIST_3 [undetermined]: Manual hedge-fund matching list 3 is an input to the source-built company/product crosswalk; the code retains companyid and organizationcrd.
- REQ_Q11_RAW1 [undetermined]: Manually coded Q11 disclosure input q11_raw1.csv is required. The source merges the four files by organizationcrd/year and then uses Q11 flags and materiality fields, but does not assign each non-key field to an individual CSV.
- REQ_Q11_RAW2 [undetermined]: Manually coded Q11 disclosure input q11_raw2.csv is required. The source merges the four files by organizationcrd/year and then uses Q11 flags and materiality fields, but does not assign each non-key field to an individual CSV.
- REQ_Q11_PARTITION1 [undetermined]: Manually coded Q11 disclosure input q11_partition1_raw.csv is required. The source merges the four files by organizationcrd/year and then uses Q11 flags and materiality fields, but does not assign each non-key field to an individual CSV.
- REQ_Q11_PARTITION2 [undetermined]: Manually coded Q11 disclosure input q11_partition2_raw.csv is required. The source merges the four files by organizationcrd/year and then uses Q11 flags and materiality fields, but does not assign each non-key field to an individual CSV.
- REQ_EX_FULL [undetermined]: Manually coded COI disclosure input; the composite stage uses ex_full and exnondis_full and merges by organizationcrd/year.
- REQ_HIGHRISK_FULL [undetermined]: Manually coded high-risk disclosure input; the composite stage merges by productreference/year and consumes highrisk_full, risk1_full and risk2_full.
- REQ_Q5_FULL [undetermined]: Manually coded additional disclosure input used to form q5_i, q6_i, q7_i and q9_i.
- REQ_Q11_MENTION [undetermined]: Opposite-direction Q11 annotation input joined to the raw Q11 variables by organizationcrd/year.
- REQ_EX_MENTION [undetermined]: Opposite-direction COI annotation input joined by organizationcrd/year and used to create ex_mention_full.
- REQ_RISK_MENTION_1 [undetermined]: Risk-mention annotation input 1 is joined by productreference/year; the first two files create named tercile flags, while no non-key field from file 3 is inspected downstream.
- REQ_RISK_MENTION_2 [undetermined]: Risk-mention annotation input 2 is joined by productreference/year; the first two files create named tercile flags, while no non-key field from file 3 is inspected downstream.
- REQ_RISK_MENTION_3 [undetermined]: Risk-mention annotation input 3 is joined by productreference/year; the first two files create named tercile flags, while no non-key field from file 3 is inspected downstream.
- REQ_MUTUALFUND [undetermined]: Membership by adviser key is converted into a mutualfund flag.
- REQ_FIDUCIARY [undetermined]: Membership by adviser key is converted into a fiduciary flag.
- REQ_OWNERSHIP [undetermined]: Ownership attributes are merged by adviser key; the exact CSV payload columns are not named in the supplied source.
- REQ_CHAR1 [undetermined]: Fund-manager characteristic input is merged by product key; later models use director/ownership fields, but this file's exact payload mapping is not declared.
- REQ_CHAR2 [undetermined]: CCO characteristic input is merged by adviser key; exact payload mapping is not declared.
- REQ_PENSIONPLANS [undetermined]: Pension-plan input is merged by adviser key and appears in the later characteristic model.
- REQ_CHAR1_ADDITIONAL [undetermined]: Additional fund-manager gender and education input.
- REQ_CHAR2_ADDITIONAL [undetermined]: Additional CCO gender and education input.
- REQ_READABILITY [undetermined]: Readability input; the main program later consumes indexrsq2.
- REQ_DEREG_LIST [undetermined]: The deregistration/survival branch requires dereg_list.csv; source keys and downstream fields are listed where the supplied code names them.
- REQ_DEREG_Q11_RAW1 [undetermined]: The deregistration/survival branch requires q11_raw1_dereg.csv; source keys and downstream fields are listed where the supplied code names them.
- REQ_DEREG_Q11_RAW2 [undetermined]: The deregistration/survival branch requires q11_raw2_dereg.csv; source keys and downstream fields are listed where the supplied code names them.
- REQ_DEREG_EX [undetermined]: The deregistration/survival branch requires ex_full_dereg.csv; source keys and downstream fields are listed where the supplied code names them.
- REQ_DEREG_HIGHRISK [undetermined]: The deregistration/survival branch requires highrisk_full_dereg.csv; source keys and downstream fields are listed where the supplied code names them.
- REQ_STOPREPORTING [undetermined]: The deregistration/survival branch requires stopreporting.csv; source keys and downstream fields are listed where the supplied code names them.
- REQ_CRSP_CLEAN [undetermined]: The raw program merges this cleaned CRSP-derived input on yearmonth and requires excess_crsp for rolling factor regressions. Its author construction is not supplied.
- REQ_CRSP_FINAL [undetermined]: The raw program separately merges this final CRSP-derived input on yearmonth and requires excess_crsp for rolling factor regressions. Its author construction is not supplied.
- REQ_HSIEH_FINAL [undetermined]: The main/survival branches merge the seven-factor author-prepared Fung-Hsieh panel and consume excesssprt, sc_lc, monthlychange, changeinspread, ptfsbd, ptfsfx and ptfscom by yearmonth.
- REQ_HSIEH_NEW [undetermined]: A separate Hsieh factor file is merged into the 2012–2018 product-performance branch; it must supply the same factor family and yearmonth key.
- REQ_UNSMOOTH [undetermined]: The 2022 panel merges an unsmoothed-return input by productreference/yearmonth and creates performance1_unsmooth from rateofreturn_unsmooth and rf. Its source product and construction are not identified in supplied code.
- REQ_CHARA_MISREPORT_1 [undetermined]: The final characteristic dataset merges Data\chara_misreporting1 by productreference. The source supplies no producer or per-file payload schema; downstream Table 5/7 code consumes pct_finterms sentiment/modal variables from the combined test1_new1 input.
- REQ_CHARA_MISREPORT_2 [undetermined]: The final characteristic dataset merges Data\chara_misreporting2 by productreference. The source supplies no producer or per-file payload schema; downstream Table 5/7 code consumes pct_finterms sentiment/modal variables from the combined test1_new1 input.
- REQ_CHARA_MISREPORT_3 [undetermined]: The final characteristic dataset merges Data\chara_misreporting3 by productreference. The source supplies no producer or per-file payload schema; downstream Table 5/7 code consumes pct_finterms sentiment/modal variables from the combined test1_new1 input.
- REQ_CHARA_MISREPORT_4 [undetermined]: The final characteristic dataset merges Data\chara_misreporting4 by productreference. The source supplies no producer or per-file payload schema; downstream Table 5/7 code consumes pct_finterms sentiment/modal variables from the combined test1_new1 input.
- SW_MATCHIT [preparation_required]: The raw matching program calls matchit; the exact command probe reports it unavailable in the checked Stata environment.
- SW_XTFMB [preparation_required]: The supplied analysis code calls xtfmb; the typed environment viewer reports it only with configured lookup, so the Stata ado path/configuration must be made explicit before execution.

## Review notes

- Both supplied Stata sources were read in full through the saved byte-first reader; one-based physical source rows are cited. Raw logs were not displayed. The five raw save names and main read basenames match; a portable same-data directory layout is a preparation step and does not depend on historical private root values.
- All 108 frozen dependency IDs are covered. Source I/O closure also includes the additional merge/append/join inputs; every generated review cites its direct source save and consumers. Catalogue discovery is not treated as live compatible data proof.
- The packaged identifier.dta is a one-row identifier-list probe only; it is not used as a full analysis input. The work item lists no related packages.
- Company-details and service-provider TASS candidates, plus FF.FACTORS_MONTHLY, had bounded one-row readable-field probes; their historical or full-sample coverage is not verified. The full TASS product-performance contract and author-derived CRSP/Hsieh/unsmoothed panels remain unverified.
- The finalresult path is treated as a source-supported same-object setup handoff at the actual merge2 writer; a conditional second save preserves the existing output and future identifier/population checks remain required.
- No author program, SAS startup, statistical model, dataset download, package installation, source-data mutation, external message or applied patch was performed.
- A conditional run_procedure action sequences verified input/software preparation, portable raw/main directory alignment, the source-ordered raw branches and same-object alias, five generated panels, and the original main analysis/output checks; no author program or model was run during this assessment.
