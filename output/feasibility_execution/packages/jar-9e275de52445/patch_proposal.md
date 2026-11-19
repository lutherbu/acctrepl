# Patch proposal: jar-9e275de52445

Executive Compensation Tied to ESG Performance: International Evidence

DOI: 10.1111/1475-679X.12481

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata data-preparation workflow under master.do, including the firm-year panel and the companion fund-firm-year output; the package does not include paper regression-estimation programs.

Entry points: `master.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 3/12481 - Executive-Compensation-Tied-to-ESG-Performance-International-Evidence/ckor-datasheet-code-and-identifiers.zip",
      "sha256": "525792569acd09262d313192b2aa89a5f137e6f44c66ea1611ef09150710b9b0"
    },
    {
      "path": "JAR-Volume 61/Issue 3/12481 - Executive-Compensation-Tied-to-ESG-Performance-International-Evidence/ckor-online-appendix.pdf",
      "sha256": "adbef5ffe97628dccde4d7e420a3c40d9623de10c52e3e1a07055f152d08c6ae"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "c970f087d5a944bfa29afebb487fc9e74f2d9b28f633b4a8baa56928d0dfe2b0"
}
```

## Proposed actions

### ACT_IDENTIFIER_MAPS: Use packaged identifiers.xlsx to prepare the three ISS-keyed DealScan lookup files and the separate firm-year seed. Only the seed fields company_name and iss_country remain unprovided by this workbook.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_IDENTIFIERS, REQ_ISIN_ECA_LIST, ISS_ISIN_LIST_PRODUCER, ISS_DEALSCAN_ID_MAPS, REQ_DEAL_ID_GVKEY, REQ_DEAL_ID_ISIN, REQ_DEAL_ID_CUSIP
Evidence: SRC_ID_WORKBOOK, PROBE_IDS, SRC_ISIN_LIST_CONTROL, SRC_ISIN_LIST_MAIN, SRC_DEAL_ID_GVKEY, SRC_DEAL_ID_ISIN, SRC_DEAL_ID_CUSIP

Preparation / proposed procedure:

1. Import identifiers.xlsx and preserve iss_company_id, gvkey, isin and cusip without changing identifier values.
2. Save gvkey_list_eca.dta with gvkey and iss_company_id, isin_list_eca1.dta with isin and iss_company_id, and cusip_list_eca.dta with cusip and iss_company_id. These path-specific Stata files are working-copy preparation from packaged data.
3. Obtain a documented source for company_name and iss_country before building temp/isin_list_eca.dta for the main firm sample.

Validation to perform later:

- Check each using-side DealScan key is unique and report unmatched sample firms; the one-row workbook check does not establish full-coverage or uniqueness.
- Confirm the separate main firm seed includes company_name and iss_country from a documented source.

### ACT_ECA_INPUTS: Obtain the author-specific ISS ECA person, ECA metrics and year/currency exchange-rate inputs or a documented compatible local ISS route.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_ECA_PERSON, REQ_ECA_METRICS, REQ_EXCHANGE_RATE
Evidence: SRC_ECA_PERSON, SRC_ECA_METRICS, SRC_EXCHANGE_RATE, INS_LOOKUPS, CAT001

Preparation / proposed procedure:

1. Place the exact source tables at the documented inputs paths.
2. Confirm ISS company ID, fiscal-year, CEO status/title/compensation and ECA metric/date fields against the supplied joins.
3. Confirm currency-year exchange_rate coverage for every CEO compensation observation.

Validation to perform later:

- Check identifiers, field types, fiscal-year history and currency conversion coverage before running CEO/ESG-pay stages.

### ACT_DATASTREAM: Obtain the author controls workbook or verify a supported Datastream construction for every required accounting, market, volatility and board-governance sheet.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_DS_WORKBOOK
Evidence: SRC_DS_WORKBOOK, INS_LOOKUPS, INS_FIELDS, CAT001

Preparation / proposed procedure:

1. Place the author workbook at inputs/controls/new_controls_datastream_eca.xlsx or document an equivalent source mapping.
2. Preserve the source sheet names and identifier/year columns used by the preparation stages.
3. Use the existing code transformations for each sheet; do not replace missing values or infer company links.

Validation to perform later:

- Verify each required sheet, firm/year fields, 1999–2020 control history and mapping to the identifier list before executing the control build.

### ACT_EPI_VINTAGES: Prepare the six specified EPI releases from the official prior-version data route using the exact supplied worksheet and conversion blocks; preserve the authored sequence.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_EPI_2010, REQ_EPI_2012, REQ_EPI_2014, REQ_EPI_2016, REQ_EPI_2018, REQ_EPI_2020
Evidence: PUB_EPI_VERSIONS, PUB_EPI_FAQ, SRC_EPI_URL, SRC_EPI_2010, SRC_EPI_2012, SRC_EPI_2014, SRC_EPI_2016, SRC_EPI_2018, SRC_EPI_2020, SRC_EPI_CONTRACT_2010, SRC_EPI_MISSING_SCORE_2010, SRC_EPI_CONTRACT_2012, SRC_EPI_MISSING_SCORE_2012, SRC_EPI_CONTRACT_2014, SRC_EPI_CONTRACT_2016, SRC_EPI_CONTRACT_2018, SRC_EPI_CONTRACT_2020

Preparation / proposed procedure:

1. Obtain the six named EPI vintages from the official prior-release materials and place them at their documented input paths.
2. Use each supplied worksheet and its stated source fields; keep the existing ISO-to-iss_country, score-to-epi, numeric and vintage-specific missing-value handling.
3. Preserve the supplied two-year expansion that constructs country-year scores from 2009 through 2020. The FAQ caveat is method context; no author permission is needed merely to prepare the unchanged supplied sequence.

Validation to perform later:

- For each vintage, confirm the named worksheet and required source headers, country identifiers and score coverage against the source-code contract.
- Check the authored release-to-year mapping and resulting country-year keys while preserving the supplied transformation sequence.

### ACT_REFINITIV: Use the author-prepared ISIN/year Refinitiv score panel, or validate the WRDS summary plus identity tables together as one local reconstruction alternative.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_REFINITIV_SCORES
Evidence: SRC_REF_ESG, INS_TRESG, CAT001, INS_PROBE_TRESG_COMPANY_SUMMARY, INS_PROBE_TRESG_COMPANY_INFO

Preparation / proposed procedure:

1. Use the author-prepared score file if its FisYear, Isin and score fields and 2008–2020 coverage match the supplied t−1 merge.
2. Alternatively, for the local route only, join WRDS_COMPANY_SMRY to WRDS_COMPANY_INFO by OrgID and use Isin after confirming the actual historical link and score-year coverage.
3. Do not require the local identity table when the prepared ISIN/year score route is selected.

Validation to perform later:

- For the prepared route, check ISIN/year keys, the five score fields and lagged input years.
- For the local alternative, check OrgID key uniqueness, OrgID-to-Isin link validity and the same year/score contract before building the lagged panel.

### ACT_KLD: Obtain the author KLD file or verify KLD.HISTORY as the same annual source and complete firm/year history.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_KLD
Evidence: SRC_KLD, INS_FIELDS, CAT001

Preparation / proposed procedure:

1. Map the exact strength/concern field names to the existing KLD construction only after confirming product version and identifier keys.
2. Place a compatible source file at inputs/esg/msci lkd esg.dta or document the conversion.

Validation to perform later:

- Verify year history, CUSIP/ticker/company identifiers and all required category fields before running the KLD stage.

### ACT_SUST: Obtain the complete author Sustainalytics score inputs and additional ISIN map.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_SUST_OLD, REQ_SUST_P1, REQ_SUST_P2, REQ_SUST_P3, REQ_SUST_MAP
Evidence: SRC_SUST_OLD, SRC_SUST_P1, SRC_SUST_P2, SRC_SUST_P3, SRC_SUST_MAP, INS_LOOKUPS

Preparation / proposed procedure:

1. Place the older weighted-score file and all three 2022 partitions at the exact inputs paths.
2. Obtain the additional ISIN workbook/sheet used to match EntityId to ISIN.
3. Preserve the authors' partitions and duplicate-resolution steps.

Validation to perform later:

- Check headers, identifiers, source dates and combined year coverage before executing the Sustainalytics blocks.

### ACT_SBTI: Confirm the intended 2021 SBTi workbook and missing company-name/ISIN map; current official exports are a candidate route with a changed field convention.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_SBTI, REQ_SBTI_MAP, ISS_SBTI_MAP
Evidence: SRC_SBTI, SRC_SBTI_MAP, PUB_SBTI_DATA, PUB_SBTI_SCHEMA

Preparation / proposed procedure:

1. Obtain the author workbook or identify a compatible current by-company export and map legacy Date, BA15Date, CompanyName, ISIN, Country and OrganizationType fields.
2. Provide or document the sbti_isin.dta mapping source; do not infer links from company names without author confirmation.

Validation to perform later:

- Verify company identifiers, date fields and year coverage used for the 2008–2020 panel before running the SBTi stage.

### ACT_TRUCOST_INPUTS: Obtain exact Trucost CSV vintages, the intended 2021 future-carbon panel producer and both 2022 name-to-ISIN maps.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_TRUCOST_2021_CSV, REQ_TRUCOST_2022_CSV, REQ_TRUCOST_2021_PANEL, REQ_TRUCOST_MAP_A, REQ_TRUCOST_MAP_B, ISS_TRUCOST_PANEL, ISS_TRUCOST_MAPS
Evidence: SRC_TRUCOST_2021, SRC_TRUCOST_2022, SRC_TRUCOST_PANEL, SRC_TRUCOST_LAG_OUTPUT, SRC_TRUCOST_MAP_A, SRC_TRUCOST_MAP_B, CAT001, INS_FIELDS

Preparation / proposed procedure:

1. Place each author CSV at its documented input path and verify source year, ISIN, scope units, restatement and effective-date fields.
2. Ask the authors which prepared file is intended for temp/trucost_2021.dta; do not substitute ltrucost_2021.dta without confirming its year shift.
3. Obtain both name-to-ISIN crosswalks and document the distinct isin2/isin3 mappings.

Validation to perform later:

- Confirm raw and prepared panels cover all lags/leads used by the supplied code and that IDs/units align before execution.

### ACT_VOTES: Obtain the exact US and global ISS vote/recommendation files and the separately prepared global vote rows.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_US_VOTES, REQ_GLOBAL_ISS, REQ_GLOBAL_VOTES, ISS_GLOBAL_VOTES
Evidence: SRC_US_VOTE, SRC_GLOBAL_ISS, SRC_GLOBAL_VOTES, SRC_PRODUCTS

Preparation / proposed procedure:

1. Place US and global ISS source files at their documented input paths.
2. Obtain the distinct temp/va_global_votes.dta producer or prepared file with the append schema (ISS ID, year, support, recommendation and agenda text).
3. Do not treat va_global_issrec.dta as the prepared votes file absent a verified transform.

Validation to perform later:

- Confirm company identifiers, meeting dates, vote/share fields and year coverage before support and meeting-date stages.

### ACT_ENGAGEMENTS: Obtain the author-prepared engagement panels and State Street 2019–2020 sheet used by the supplied workflow.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_ENG_BLACKROCK, REQ_ENG_SS_OLD, REQ_ENG_SS_NEW, REQ_ENG_VANGUARD
Evidence: SRC_ENG_BLACKROCK, SRC_ENG_SS_OLD, SRC_ENG_SS_XLSX, SRC_ENG_VANGUARD, SRC_PRODUCTS

Preparation / proposed procedure:

1. Place each four separate BlackRock, State Street and Vanguard inputs at the exact paths in the main builder.
2. Provide SSGA_2019-2020.xlsx with the `SSGA Final` sheet so the supplied stage can create its 2019–2020 file.
3. Do not independently reconstruct author hand-collected classifications from engagement reports.

Validation to perform later:

- Verify ISIN/year and engagement flag fields and 2014–2020 panel years before the main merge.

### ACT_DEALSCAN: Obtain the two DealScan partitions and the author link/crosswalk files required by the supplied DealScan preparation stage.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_DEAL_2010, REQ_DEAL_2016, REQ_DEAL_CS_LINK, REQ_DEAL_LPC_MAP, REQ_DEAL_FUZZY, REQ_DEAL_WS_LINK
Evidence: SRC_DEAL_2010, SRC_DEAL_2021, SRC_DEAL_CS_LINK, SRC_DEAL_LPC_MAP, SRC_DEAL_FUZZY, SRC_DEAL_WS_LINK, SRC_DEAL_WS_LINK_DIRECT, INS_FIELDS, CAT001

Preparation / proposed procedure:

1. Place the 2010–2015 and 2016–2021 DealScan partitions and the supplied Compustat, LoanConnector, fuzzy-ISS and Worldscope link files at their documented paths.
2. Keep the two source partitions and their date/segment filters distinct; use the supplied matching and merge sequence.
3. Treat local catalog candidates only as unverified alternatives until their product identity, required entity keys and historical coverage are established.

Validation to perform later:

- Verify the two partition periods, deal-date and segment filters, borrower identifiers, source link keys and match coverage before generating the green/ESG loan panel.

### ACT_FACTSET: Obtain both FactSet products and the FSYM_ID-to-ISS sample crosswalk; catalogued 13F data are not a verified replacement.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_FACTSET_IO, REQ_FUND_HOLDINGS, REQ_SAMPLE_ISS_MAP, ISS_FSX_MAP
Evidence: SRC_FACTSET_IO, SRC_FUND_HOLDINGS, SRC_SAMPLE_ISS, INS_LOOKUPS, INS_FIELDS, CAT001, PROBE_IDS

Preparation / proposed procedure:

1. Place the FactSet ownership-summary input and fund-holdings panel with the author years and exact fields.
2. Obtain the sample_iss_eca.dta mapping FSYM_ID to iss_company_id.
3. Confirm the authorized local account route; do not substitute TFN.S34/S12 without an author-approved mapping/specification.

Validation to perform later:

- Verify FactSet identifiers, period coverage, fund/report dates and reported/adjusted holdings before the companion table build.

### ACT_BONDS: Obtain the Bloomberg SLB and green-bond workbooks plus the author issuer-to-ISS mapping workbook used on sheets 3 and 6.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_BOND_MAP, REQ_SLB, REQ_GREEN_BONDS, ISS_BOND_LOOKUP
Evidence: SRC_BOND_CODE, SRC_BOND_SLB, SRC_BOND_GREEN

Preparation / proposed procedure:

1. Place both Bloomberg files and temp/slb_iss_code.xlsx at the code's paths.
2. Preserve the separate issuer mappings and the exact worksheet/range contracts.

Validation to perform later:

- Verify issuer names, ISS company IDs and the code's screening columns before running bond preparation.

### ACT_GLOBAL_LINKS: Request the exact missing prepared crosswalks and producer instructions for SBTi and both Trucost name-to-ISIN maps.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_SBTI_MAP, REQ_TRUCOST_MAP_A, REQ_TRUCOST_MAP_B
Evidence: SRC_GLOBAL_VOTES_DIRECT, SRC_SBTI_MAP_DIRECT, SRC_TRC_MAP_A_DIRECT, SRC_TRC_MAP_B_DIRECT

Preparation / proposed procedure:

1. Obtain each author-prepared file or its exact source, key fields and transformation steps.
2. Do not reuse similarly named files or infer matches without a documented mapping.

Validation to perform later:

- Check each producer's output path, key uniqueness and target fields against its consuming merge before execution.

### ACT_DISCLOSURE: Obtain regressions4.dta and the source/definition for disclosure1 used by the fund-firm-year stage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_DISCLOSURE, ISS_DISCLOSURE_PRODUCER
Evidence: SRC_COMPANION_DISCLOSURE

Preparation / proposed procedure:

1. Ask the authors for the intended disclosure1 file or its producing script and construction definition.
2. Keep the fund-firm-year stage in scope after the source is supplied.

Validation to perform later:

- Verify `isin`, `year` and disclosure1 fields and the period alignment to holdings before the companion merge.

### ACT_CHROA_SELECTOR: Remove only the unused ch_roa keepusing selector; do not replace it with lroa or calculate a new change variable.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_CHROA_SELECTOR
Evidence: SRC_CHROA_SELECTOR, SRC_CONTROL_LROA, SRC_CONTROL_SAVE, PUB_STATA_MERGE

**Proposed edit:** `code/Prepare Data - Regressions File firm-year.do:11–11`
Source SHA-256: `15d3b8637cac4a2229e9ed1a4879580a89e922630eede397c7ae383c31752eb2`

The producer does not create ch_roa and the supplied workflow does not consume it downstream; remove the unsupported selector only.

Current text:
```
merge 1:1 iss_company_id year using "$temp\controls_eca.dta", keepusing(lsize lroa llev lppe llog_bm ldividends lcapx lreturn sic return ch_roa) keep(match master) nogen
```

Proposed replacement:
```
merge 1:1 iss_company_id year using "$temp\controls_eca.dta", keepusing(lsize lroa llev lppe llog_bm ldividends lcapx lreturn sic return) keep(match master) nogen
```

Preparation / proposed procedure:

1. Apply this proposal to a working copy only.

Validation to perform later:

- Confirm all remaining requested variables exist in controls_eca.dta and the full master reaches the main merge.

### ACT_FUND_HANDOFF: Point the companion's first regression merge at the file produced immediately before it in master.do.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_REGRESSIONS_HANDOFF
Evidence: SRC_COMPANION_HANDOFF, SRC_MAIN_OUTPUT, SRC_MASTER_LAST, PUB_STATA_MERGE

**Proposed edit:** `code/Prepare Data - Regressions File fund-firm-year.do:51–51`
Source SHA-256: `a2357768e91191876dc6b6811c8caa6e5d9d936813971d11e75683d2a88d9bd4`

The main builder has just produced the same firm-year variables under $temp/regressions.dta; preserve the merge keys and fields.

Current text:
```
merge m:1 iss_company_id year using regressions_eca4.dta, keepusing(csr1 carbon3 environment3 safety3 governance3 compliance3 culture3 people3 diversity3 other3 lsize_w llog_bm_w lroa_w llev_w lppe_w ldividends_w lreturn_w control firm_id isin) keep(match master) nogen 
```

Proposed replacement:
```
merge m:1 iss_company_id year using $temp\regressions.dta, keepusing(csr1 carbon3 environment3 safety3 governance3 compliance3 culture3 people3 diversity3 other3 lsize_w llog_bm_w lroa_w llev_w lppe_w ldividends_w lreturn_w control firm_id isin) keep(match master) nogen 
```

Preparation / proposed procedure:

1. Change only the path in the companion merge to $temp/regressions.dta; preserve the keepusing list and all transformations.

Validation to perform later:

- Text-check the master ordering and confirm every named keepusing field is produced before the fund-firm-year stage.

### ACT_WINSOR2: Prepare winsor2 in the permitted Stata ado path and remove the in-script installer so the pipeline does not install packages during execution.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2, ISS_WINSOR2_SETUP
Evidence: PROBE_WINSOR2, SRC_COMPANION_INSTALL

**Proposed edit:** `code/Prepare Data - Regressions File fund-firm-year.do:48–48`
Source SHA-256: `a2357768e91191876dc6b6811c8caa6e5d9d936813971d11e75683d2a88d9bd4`

The assessment does not install packages or permit an in-script download; preserve the required winsor2 commands and provision the dependency separately.

Current text:
```
ssc install winsor2
```

Proposed replacement:
```
* winsor2 must be provisioned in Stata's ado path before running.
```

Preparation / proposed procedure:

1. Install or provision the authors' winsor2 command through the approved Stata ado setup before the future run.
2. In a working copy, replace the ssc install winsor2 statement with a comment that winsor2 must be provisioned before running.

Validation to perform later:

- Use Stata's metadata-only `which winsor2` check after setup; verify every supplied winsor2 call remains unchanged.

### ACT_WORKDIR: Set up a writable working copy and directory tree for the complete master sequence.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_WORKING_COPY
Evidence: SRC_MASTER_SETUP, SRC_MASTER_INPUTS, SRC_MASTER_LAST, PUB_STATA_DO

Preparation / proposed procedure:

1. Create inputs, temp, code and output at the working-copy root and place all required input paths beneath inputs.
2. Run master.do from that root so the captured author-specific cd may fail harmlessly while relative macros resolve.
3. Keep outputs and generated files in the working copy, including the State Street generated file that the source writes beneath inputs.

Validation to perform later:

- Before running, confirm current directory is the working root, all 28 supplied programs are present and Stata resolves every master include; after a future authorized run, verify regressions.dta and fund_firm_year10.dta outputs.


## Remaining issues and prerequisites

- ISS_ISIN_LIST_PRODUCER [unresolved; full_pipeline]: No supplied stage creates temp/isin_list_eca.dta. The packaged identifier workbook contains identifiers but not the company_name/iss_country fields consumed by the main firm-year builder.
- ISS_DEALSCAN_ID_MAPS [preparation; full_pipeline]: The three DealScan lookup files are generated intermediates, not independent missing empirical inputs: identifiers.xlsx supplies iss_company_id with gvkey, isin and cusip. Create each two-column lookup in the working copy; check using-side key uniqueness and sample match coverage before the m:1 merges.
- ISS_TRUCOST_PANEL [unresolved; full_pipeline]: The future-carbon stage reads temp/trucost_2021.dta, while the supplied lagged stage writes ltrucost_2021.dta after shifting year; the intended producer/alignment cannot be inferred safely.
- ISS_TRUCOST_MAPS [unresolved; full_pipeline]: The 2022 Trucost update merges two separately named name-to-ISIN maps with no producers or supplied crosswalk specifications.
- ISS_SBTI_MAP [unresolved; full_pipeline]: SBTi code merges inputs/isin/sbti_isin.dta for CompanyName-to-ISIN mapping; no producer is supplied.
- ISS_GLOBAL_VOTES [unresolved; full_pipeline]: Vote-support builders append temp/va_global_votes.dta, which has no producer. The separate va_global_issrec.dta input is not shown to have the required prepared vote schema.
- ISS_BOND_LOOKUP [unresolved; full_pipeline]: Both bond stages import different sheets from temp/slb_iss_code.xlsx, but the author issuer-to-ISS lookup workbook is not supplied or generated.
- ISS_FSX_MAP [unresolved; full_pipeline]: The companion fund panel requires sample_iss_eca.dta to map FactSet FSYM_ID to ISS company IDs; the packaged identifier workbook has no FSYM_ID and no producer is supplied.
- ISS_DISCLOSURE_PRODUCER [unresolved; full_pipeline]: The fund-firm-year stage reads regressions4.dta for disclosure1; no producing stage or variable definition appears in the supplied workflow.
- ISS_CHROA_SELECTOR [preparation; full_pipeline]: The main firm-year merge requests ch_roa from controls_eca.dta, but the full supplied producer saves lagged lroa and does not define ch_roa; no supplied downstream code consumes ch_roa. Remove only the unused selector; do not substitute or calculate a new measure.
- ISS_REGRESSIONS_HANDOFF [preparation; full_pipeline]: The main firm-year stage writes $temp/regressions.dta before the companion stage, which requests regressions_eca4.dta. Its named keepusing fields are produced in the preceding output; a same-operation path correction is supported.
- ISS_WINSOR2_SETUP [preparation; full_pipeline]: Stata 18 cannot find winsor2; the companion includes an ssc installer. Prepare the add-on in the authorized ado path and remove the workflow's implicit installer.
- ISS_WORKING_COPY [preparation; full_pipeline]: The master defines relative inputs/temp/code/output roots after a captured author-specific cd. Run a working copy from its root with the required directory tree and supplied inputs in place.
- REQ_ISIN_ECA_LIST [undetermined]: Working firm-year seed `temp/isin_list_eca.dta`, including ISS ID, ISIN, CUSIP, company name and country; no supplied producer is present.
- REQ_ECA_PERSON [undetermined]: ISS ECA person/CEO records used for disclosed CEO status, title, compensation and fiscal year; supplied file fields include ISS company ID, fiscal year and compensation columns.
- REQ_ECA_METRICS [undetermined]: ISS ECA performance-metric records used to build environmental/CSR compensation flags and fiscal-year-end dates.
- REQ_EXCHANGE_RATE [undetermined]: Currency-year exchange rates (`curcd`, `year`, `exchange_rate`) used to express CEO pay in USD.
- REQ_DS_WORKBOOK [undetermined]: Author Datastream controls workbook, with its price/volatility, board, diversity, insider ownership and accounting sheets, used to build annual controls and governance variables.
- REQ_EPI_2010 [undetermined]: EPI 2010 release input: sheet `EPI2010_onlyEPIcountries`, fields code, ISO3V10, EPI; the supplied code maps the ISO field to iss_country, the score field to numeric epi and expands each country to 2009–2010. Exact workbook field/history coverage remains unverified.
- REQ_EPI_2012 [undetermined]: EPI 2012 release input: sheet `EPI2012`, fields code, ISO3V10, EPI; the supplied code maps the ISO field to iss_country, the score field to numeric epi and expands each country to 2011–2012. Exact workbook field/history coverage remains unverified.
- REQ_EPI_2014 [undetermined]: EPI 2014 release input: sheet `Indicator Scores`, fields ISO3v10, Country, EPIScore; the supplied code maps the ISO field to iss_country, the score field to numeric epi and expands each country to 2013–2014. Exact workbook field/history coverage remains unverified.
- REQ_EPI_2016 [undetermined]: EPI 2016 release input: sheet `Indicator Scores`, fields ISO3, Country, EPIScore; the supplied code maps the ISO field to iss_country, the score field to numeric epi and expands each country to 2015–2016. Exact workbook field/history coverage remains unverified.
- REQ_EPI_2018 [undetermined]: EPI 2018 release input: sheet `2018EPI_ScoresCurrent`, fields code, iso, country, EPIcurrent; the supplied code maps the ISO field to iss_country, the score field to numeric epi and expands each country to 2017–2018. Exact workbook field/history coverage remains unverified.
- REQ_EPI_2020 [undetermined]: EPI 2020 release input: sheet `3_EPI_Results`, fields code, iso, country, EPInew; the supplied code maps the ISO field to iss_country, the score field to numeric epi and expands each country to 2019–2020. Exact workbook field/history coverage remains unverified.
- REQ_REFINITIV_SCORES [undetermined]: Annual Refinitiv company ESG scores at t−1, satisfied by either the author-prepared ISIN/year score panel or one local reconstruction using the score summary together with its OrgID-to-ISIN identity table.
- REQ_KLD [undetermined]: MSCI/KLD annual ESG strength/concern indicators; author program uses CompanyName/year/CUSIP/Ticker and issue-category fields.
- REQ_FACTSET_IO [undetermined]: FactSet/LionShares institutional ownership summary used for lagged firm-year IO (source years 2000–2019).
- REQ_TRUCOST_2021_CSV [undetermined]: Trucost 2021 carbon-emissions source CSV, with company/ISIN/year and scope 1–3 values used in the lagged file.
- REQ_TRUCOST_2022_CSV [undetermined]: 2022 Trucost update CSV used to refresh forward emissions.
- REQ_TRUCOST_2021_PANEL [undetermined]: Intermediate `temp/trucost_2021.dta` required by the future-carbon builder.
- REQ_TRUCOST_MAP_A [undetermined]: Trucost A author name-to-ISIN crosswalk used in the 2022 update.
- REQ_TRUCOST_MAP_B [undetermined]: Trucost B author name-to-ISIN crosswalk used in the 2022 update.
- REQ_SUST_OLD [undetermined]: Older Sustainalytics weighted ESG score file used to construct lagged company-year scores.
- REQ_SUST_P1 [undetermined]: Sustainalytics 2022 ESG ratings workbook partition P1, jointly imported by the new-score stage.
- REQ_SUST_P2 [undetermined]: Sustainalytics 2022 ESG ratings workbook partition P2, jointly imported by the new-score stage.
- REQ_SUST_P3 [undetermined]: Sustainalytics 2022 ESG ratings workbook partition P3, jointly imported by the new-score stage.
- REQ_SUST_MAP [undetermined]: Sustainalytics additional ISIN mapping workbook, sheet 3.
- REQ_SBTI [undetermined]: Science Based Targets company-action workbook used to derive commitment/target flags.
- REQ_SBTI_MAP [undetermined]: Missing `sbti_isin.dta` map from CompanyName to `isin1` used when company workbook ISIN is blank.
- REQ_US_VOTES [undetermined]: US ISS Voting Analytics recommendations and vote outcomes used in pay/director support and recommendation panels (2009–2021).
- REQ_GLOBAL_ISS [undetermined]: Global ISS recommendation file used to derive global meeting dates.
- REQ_GLOBAL_VOTES [undetermined]: Prepared global vote rows appended in support builders; expected fields are iss_company_id, year, support, iss_recommendation and AgendaGeneralDesc.
- REQ_ENG_BLACKROCK [undetermined]: BlackRock annual engagement firm-year file.
- REQ_ENG_SS_OLD [undetermined]: Earlier State Street annual engagement file.
- REQ_ENG_VANGUARD [undetermined]: Vanguard annual engagement firm-year file.
- REQ_ENG_SS_NEW [undetermined]: State Street 2019–2020 engagement source workbook (sheet `SSGA Final`) used to create the later panel.
- REQ_DEAL_2010 [undetermined]: DealScan 2010–2015 raw loan tranche partition.
- REQ_DEAL_2016 [undetermined]: DealScan 2016–2021 raw loan tranche partition.
- REQ_DEAL_CS_LINK [undetermined]: DealScan–Compustat link workbook.
- REQ_DEAL_LPC_MAP [undetermined]: LoanConnector-to-company identifier map workbook.
- REQ_DEAL_FUZZY [undetermined]: DealScan borrower-name fuzzy match to ISS company workbook.
- REQ_DEAL_WS_LINK [undetermined]: DealScan company-to-Worldscope link file supplying ISIN and CUSIP.
- REQ_BOND_MAP [undetermined]: Author `slb_iss_code.xlsx` issuer-to-ISS lookup workbook, sheet 3 for SLB and sheet 6 for green bonds.
- REQ_SLB [undetermined]: Bloomberg sustainability-linked bond screening workbook.
- REQ_GREEN_BONDS [undetermined]: Bloomberg green corporate bond workbook.
- REQ_FUND_HOLDINGS [undetermined]: FactSet fund-level holdings panel for 2002–2020, including fund ID, report date, FSYM_ID, reported holdings and adjusted holdings.
- REQ_SAMPLE_ISS_MAP [undetermined]: Fund holdings crosswalk `sample_iss_eca.dta` mapping FSYM_ID to ISS company ID.
- REQ_DISCLOSURE [undetermined]: Fund-firm-year companion merge input `regressions4.dta`, including `isin`, `year` and `disclosure1`.
- SW_WINSOR2 [preparation_required]: Required by controls and fund-firm-year preparation but absent from current Stata 18 adopath.

## Review notes

- Scope is the full author-supplied preparation sequence, not a fabricated analysis-only route. The master has 27 preparation .do includes plus master.do (28 programs); the frozen checklist contains 51 data-use and 27 include edges, and every one is reviewed above.
- The packaged identifiers.xlsx is an identifier list, not the study data. It exposes iss_company_id, isin, cusip, ticker and gvkey; the packaged first-row probe does not establish its full 4,395-company coverage and it lacks company_name, iss_country and fsym_id.
- Local catalog records are discovery metadata and bounded probes only. They establish candidate product names/fields and one-row readability where referenced, not entitlement, date coverage, population coverage or compatibility with the author's 2021/2022 vendor files.
- No author program, statistical model, descriptive statistic, synthetic-data trial or SAS executable was run. The Stata software helper executed only its self-written version/which queries. No access barrier was established for any vendor source; the datasheet's statement that proprietary restrictions are not applicable does not establish current account entitlement.
- The source scanner masked one conservative candidate statement in the ESG-pay components file. It is a display guard only; no scientific or data-access issue is inferred from that redaction.
- The authors' EPI code appends multiple releases; the official EPI FAQ cautions that assembling scores from different releases into a time series is not appropriate. This caveat is methodological context only; the assessment preserves the supplied sequence and does not require author permission merely to prepare it.
- The online appendix contains regression-result tables, but no separate regression-estimation source program is supplied. The assessed endpoints are the two data-preparation outputs named by the included source workflow.
- The full secret-safe source inventory contains ch_roa only in the main controls merge's keepusing selector. The Controls ECA producer creates lroa and saves controls_eca.dta; the supplied files contain no downstream ch_roa use. The proposal removes that selector only and does not substitute lroa or invent a change calculation.
- Process history only: the prepared DealScan row-1 query timed out at 15 seconds; the requested ISS GPBAABS catalog field was absent before row read. Both exact statuses, request bounds and output hashes are retained in an unreferenced inspection record; neither result is treated as evidence that a source is absent.
