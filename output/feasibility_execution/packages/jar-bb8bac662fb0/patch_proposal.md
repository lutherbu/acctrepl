# Patch proposal: jar-bb8bac662fb0

Labor Market Effects of Spatial Licensing Requirements: Evidence from CPA Mobility

DOI: 10.1111/1475-679X.12342

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All author-supplied Stata preparation and analysis branches: controls, law-adoption prediction, state/county/MSA QCEW, state SUSB, AICPA MAP, pension-plan fees, and the three quality outcomes.

Entry points: `STATA/00_CPAMob_Master.do`, `STATA/01_CPAMob_ControlsPrep.do`, `STATA/02_CPAMob_AdoptionPrediction.do`, `STATA/03_CPAMob_QCEW_State.do`, `STATA/04_CPAMob_SUSB_State.do`, `STATA/05_CPAMob_QCEW_BorderCounty.do`, `STATA/06_CPAMob_QCEW_MSA.do`, `STATA/07_CPAMob_AICPAMap.do`, `STATA/08_CPAMob_PensionPlanFees.do`, `STATA/09_CPAMob_Qual1_AICPAMisconduct.do`, `STATA/10_CPAMob_Qual2_EBSA.do`, `STATA/11_CPAMob_Qual3_CODiscAction.do`, `STATA/reltimedummmies.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 1/12342 - Labor-Market-Effects-of-Spatial-Licensing-Requirements-Evidence-from-CPA-Mobility/ctv-datasheet-code-and-identifiers.zip",
      "sha256": "6bfcd2bdf719f9a4f8165d5217d3472fdf59593fab9bd3fa8020671c73892d6f"
    },
    {
      "path": "JAR-Volume 59/Issue 1/12342 - Labor-Market-Effects-of-Spatial-Licensing-Requirements-Evidence-from-CPA-Mobility/ctv-online-appendix.pdf",
      "sha256": "ac941f17f067438de28cd25c71fde7b41b9af2b6f5e72a90ce39e81349596f43"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "6e0182c1fbddde19d4b2533cfa29e5fd9a9e210746f43e0c2b9a07743153c6fb"
}
```

## Proposed actions

### a_layout: Prepare an assigned working copy whose absolute root changes and Dofiles filenames match the authored paths, while the supplied originals remain immutable.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: i_project_layout
Evidence: e_master, e_helpers

Preparation / proposed procedure:

1. Create an assigned working copy with the expected Data and Output trees under an ordinary project root.
2. In the working copy only, adjust all 12 absolute cd "/CPAMobility/" definitions in STATA/00_CPAMob_Master.do and STATA/01_CPAMob_ControlsPrep.do through STATA/11_CPAMob_Qual3_CODiscAction.do so they resolve to that copy root; leave the supplied originals unchanged.
3. Stage the master and numbered programs under Dofiles/ using the exact names 00_CPAMob_Master.do, 01_CPAMob_ControlsPrep.do, 02_CPAMob_AdoptionPrediction.do, 03_CPAMob_QCEW_State.do, 04_CPAMob_SUSB_State.do, 05_CPAMob_QCEW_BorderCounty.do, 06_CPAMob_QCEW_MSA.do, 07_CPAMob_AICPAMap.do, 08_CPAMob_PensionPlanFees.do, 09_CPAMob_Qual1_AICPAMisconduct.do, 10_CPAMob_Qual2_EBSA.do and 11_CPAMob_Qual3_CODiscAction.do.
4. Stage the exact supplied helper reltimedummmies.do under Dofiles/; preserve all include/helper filenames and all analysis branches.

Validation to perform later:

- Confirm every one of the 12 copied cd definitions resolves to the same working-copy root, all eleven master do-file calls resolve under Dofiles/, and the relative-time include resolves to Dofiles/reltimedummmies.do before any future author run.

### a_public_inputs: Acquire and stage the verified historical public products using the author’s file layouts and filters.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: r_qcew, r_susb, r_state_laus, r_county_laus
Evidence: e_public_qcew, e_public_qcew_msa, e_public_susb, e_public_laus, e_public_colorado

Preparation / proposed procedure:

1. Stage the full year-specific QCEW annual NAICS file layouts for 2001-2017 plus the distinct 2000 and 2005 predictor files; retain the 2002-2017 MSA sample and its 2001 first-difference history.
2. Stage six-digit state SUSB annual files for 2007-2015 and normalize the year-specific employment/payroll names as supplied code does.
3. Prepare state and county LAUS annual histories with the author’s FIPS, year and unemployment fields.
4. Use the DORA CPA All Status dataset for license-history fields only; keep disciplinary case fields as a separate unresolved requirement.

Validation to perform later:

- Compare downloaded product years, full QCEW layouts, identifiers and import fields with the exact branch filters before running the corresponding preparation program.

### a_pension_inputs: Stage the public DOL Form 5500, Schedule H and Schedule C source families using their two code vintages, and separately resolve the author pension-treatment helper.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: r_form5500, r_schedule_h, r_schedule_c, r_law_helpers_pension
Evidence: e_public_dol_forms, e_pension_old, e_pension_new

Preparation / proposed procedure:

1. Stage raw Form 5500, Schedule H and Schedule C files for 2003-2008 and 2009-2015 separately.
2. Retain filing_id in the earlier years and ack_id in later years; require the vintage-specific raw KEEP/DROP/RENAME inputs listed in each contract. P08 generates year in its loops rather than reading it from raw files.
3. Preserve Schedule H acctnt_opinion_type_ind versus later acctnt_opinion_type_cd; preserve Schedule C row_num versus row_order, active foreign/indicator drops, provider_other_* renames and generated provider_01_position/provider_01_srvc_code.
4. Produce the author intermediates in sequence: Schedule H and C; auditor/fee merge; Form 5500; then plan-level merge.
5. Separately resolve LawDummiesPensionPlans.dta with L1_CPAMobility_Effec_longpanel/year/STUSPS, where STUSPS becomes the state join key; its producer is not supplied.

Validation to perform later:

- Check each raw vintage against its exact field contract before import; verify the code-generated year, key, row-order and name transformations before joins by filing/ack key, provider EIN and year.

### a_prediction_contracts: Resolve the source, producer, exact fields and histories for the state prediction/control inputs, without assuming aliases between separately named files.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: r_state_gdp, r_acs_migration, r_prediction_macro, r_bds, r_state_laws, r_political_economy, r_board_survey, r_postal_crosswalk, r_msa_gdp, i_prediction_macro, i_state_controls_contract, i_msa_gdp_history, i_adoption_inputs_contract, r_law_helpers_state
Evidence: e_controls_output, e_prediction_macro, e_public_bea_state, e_public_ipums, e_public_bds, e_adoption_sources, e_board_agreement, e_msa_history, e_public_bea_msa

Preparation / proposed procedure:

1. Match the BEA state series and units to the workbook imported by program 01, and verify the ACS MIGRATE1 source years needed after the year shift.
2. Obtain or document the distinct program-02 macrocontrols.dta contract for area_fips/year/L1_unemprate/L1_realgdp; the program-01 extendedstatecontrols.dta and L1_unemp/L1_gdp are not proven aliases.
3. Confirm the BDS release and raw year/year2 mapping after preserving the lag history; check the joint LawsByState.xls and CPAMob_PoliticalEconomy.xlsx schemas for the consumed legislative fields and separate the raw columns from generated shares/logs.
4. Confirm the StatesPostalCodeCrosswald.xlsx source column and generated State/StatePostal keys, and the ColbertMurray.dta StatePostal key plus PUBPRAC/FUND_AUT/NO_LOCAL/NO_NAT fields; retain current access uncertainty for the board survey.
5. For MSA GDP, preserve 2001-2017 source history for the 2002-2017 analysis and establish an actual archive/series route before using any proxy.
6. Resolve the separate LawDummiesCensusState.dta contract: P02 consumes State/year/area_fips/lq_annual_avg_emplvl, while P03/P04 use area_fips/year/adoption_year/L1_CPAMobility_Effec_longpanel.

Validation to perform later:

- Compare raw workbook columns, merge keys, source-year coverage and code-generated variables with program 01/02/06 merge and xtset statements; do not infer aliases or workbook ownership without the actual source schemas.

### a_geography_contracts: Resolve the author-prepared treatment and historical geography inputs that feed state, county, MAP and auxiliary quality panels.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: r_fips_crosswalk, r_county_adjacency, r_border_ids, i_missing_helpers, i_geo_source_contract, r_law_helpers_county, r_county_map_database, r_county_map_coordinates
Evidence: e_helpers, e_qcew_border, e_public_adjacency, e_county_map, e_county_coordinates, e_workflow_trace

Preparation / proposed procedure:

1. Resolve LawDummiesCensusCounty.dta using its area_fips/year merge after P05 recodes the county key to state FIPS, and verify CPAMobility_Effec plus L1_CPAMobility_Effec_longpanel fields.
2. Establish the producer or compatible source for FIPSandNamesCrosswalk.dta (area_fips/area_title), CPAMobility_AdjanctCountiesBorderIDs.dta (area_fips/BORDINDX/statepair/homestate), and the separate us_county_db.dta (area_fips/NAME/BORDINDX).
3. Establish a distinct us_county_coord producer and the spmap id/stateicp/polygon-coordinate layout; do not infer its schema from the county database filename.
4. Treat Census county_adjacency2010.txt as a candidate only; verify county definitions, area_fips and BORDINDX mapping before using it.
5. Do not rebuild author border treatment or substitute current county boundaries without a documented compatible transformation.

Validation to perform later:

- Verify the actual county/year/state FIPS/BORDINDX joins separately from the map-database key and spmap coordinate identifier/geometry contract before the border branch runs.

### a_quality_inputs: Resolve the remaining historical quality-source contracts and prepare each outcome without treating historical sharing terms as current access decisions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: r_map_sheets, r_map_adoption, r_aicpa_misconduct, r_ebsa_ocats, r_ebsa_frame, r_colorado_discipline, i_aicpa_historical_routes, i_ebsa_current_route, i_colorado_discipline_fields, r_colorado_license, r_law_helpers_misconduct
Evidence: e_map, e_map_adoption, e_public_aicpa_map, e_map_agreement, e_misconduct_agreement, e_public_ebsa_portal, e_ebsa_frame, e_public_colorado, e_colorado_code

Preparation / proposed procedure:

1. Establish the 23 AICPA MAP state workbooks in total across the 2002, 2004, 2006, 2008, 2010, 2012 and 2014 biennial years, plus the separate treatment workbook; current MAP reports are not verified substitutes.
2. Keep AICPA misconduct case fields/years and historical non-sharing agreement distinct from the MAP source; a current compatible route remains unverified.
3. Identify the exact 2003-2015 OCATS public dataset/file and fields and the separate DataCollectionFrame state/adoption-year producer.
4. Treat the public Colorado individual-license listing as a candidate only; establish a compatible FRM public-accounting-firm license history and resolve firm disciplinary case/date fields separately.
5. Resolve LawDummiesAICPAMisconduct.dta separately with ST/year merge keys, STATE fixed-effect field and L1_CPAMobility_Effec_longpanel treatment field.

Validation to perform later:

- Confirm source years, panel keys and every code-consumed quality field before stacking or constructing the author outcome panels.

### a_susb_weight_contract: Conditionally correct the SUSB establishment-total name mismatch after confirming the imported file does not provide estbtotal.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: i_susb_weight_mismatch
Evidence: e_susb_weight

**Proposed edit:** `STATA/04_CPAMob_SUSB_State.do:187–187`
Source SHA-256: `5d5af932192a5c71e37b0e988877be4501fecfe774c607dc688050534c7dbfe2`

Apply only if the imported SUSB fields do not already supply estbtotal: the next source line divides estb by estbtotal, while this code line computes estbtotal3.

Current text:
```
bysort naics_size_year_id: egen estbtotal3 = total(estb)
```

Proposed replacement:
```
bysort naics_size_year_id: egen estbtotal = total(estb)
```

Preparation / proposed procedure:

1. Check the documented SUSB import schema for estbtotal. If absent, change only the source line below so the created denominator matches the following line’s use.
2. Retain the original SUSB years, filters, size classes, weights and analyses.

Validation to perform later:

- After authorized input preparation, confirm estbshare is computed from the intended total for each naics_size_year_id before the SUSB estimates.

### a_missing_software: Configure the six missing Stata commands required by the author programs using an approved local/project setup.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: s_11_filelist, s_12_sxpose, s_13_renvars, s_14_binscatter, s_15_spmap, s_16_winsor2
Evidence: e_probe_filelist, e_probe_sxpose, e_probe_renvars, e_probe_binscatter, e_probe_spmap, e_probe_winsor2

Preparation / proposed procedure:

1. Provide filelist, sxpose, renvars, binscatter, spmap and winsor2 on the Stata 18 adopath from an already approved source.
2. Preserve Stata 18 and the available commands; do not install or fetch packages during this feasibility assessment.

Validation to perform later:

- Run bounded which checks for each named command under the intended user adopath before the author workflow is attempted.

### a_run_procedure: Run the complete author workflow only after the data contracts, software and staging configuration are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: e_master, e_workflow_trace

Preparation / proposed procedure:

1. From the configured project root in Stata 18, run the master driver in Dofiles/00_CPAMob_Master.do.
2. Keep all preparation and analysis branches enabled, including prediction, state/county/MSA QCEW, SUSB, MAP, pension fees and all three quality outcomes.

Validation to perform later:

- Confirm each branch finishes and creates its expected Output tables/figures; keep execution_verified false until a future authorized run is performed.


## Remaining issues and prerequisites

- i_project_layout [preparation; full_pipeline]: The master and all eleven numbered programs set the working directory with absolute cd "/CPAMobility/" commands, while the master calls exact ./Dofiles/<filename> paths and the supplied programs/helper are under STATA/. A future working COPY must adjust all 12 absolute cd definitions and stage the exact include/helper names; changing only directories would leave those cd overrides unchanged.
- i_missing_helpers [unresolved; full_pipeline]: No producers or compatible files are supplied for four distinct LawDummies panels, the MAP adoption workbook, FIPS/name crosswalk, county border-ID file, separate us_county_db and us_county_coord inputs, state/postal crosswalk or DataCollectionFrame. Record each actual field/key contract separately; similar filenames do not establish shared schemas.
- i_prediction_macro [unresolved; full_pipeline]: Program 01 writes Data/Controls/extendedstatecontrols.dta with L1_gdp and L1_unemp (plus migration lags); program 02 separately reads Data/LawPrediction/macrocontrols.dta and expects L1_realgdp and L1_unemprate. No supplied producer or demonstrated alias joins these paths/fields.
- i_state_controls_contract [unresolved; full_pipeline]: The state GDP workbook’s series/units and the ACS MIGRATE1 route/coverage must match the author controls. The supplied code shifts source years forward and requires source-year history for its analysis years; the IPUMS candidate does not verify 2002-2004 migration coverage.
- i_msa_gdp_history [unresolved; full_pipeline]: MSA GDP is needed for 2002-2017 and its 2002 first difference requires 2001 history. BEA no longer publishes metropolitan aggregate statistics; an exact compatible archived annual MSA series and units for the author CSV are not established.
- i_adoption_inputs_contract [unresolved; full_pipeline]: The BDS author-named release and separate raw year/year2 mapping, hand-collected law and political-economy workbooks, and postal crosswalk are not matched to compatible source artifacts. P02 derives Senate_Dem_Share, House_Dem_Share, logbills, logenact, mobilitytaskforce, CPAinBoard, Big4inBoard, pubprac, fundingautonomy and localCPAs from raw fields; its model has no Senate/House/bill L1 terms. The Colbert-Murray survey has historical non-publication terms, but current access is not established as denied.
- i_geo_source_contract [unresolved; full_pipeline]: A Census 2010 county adjacency file is only a candidate for the author BORDINDX construction. County FIPS/name, border-ID joins, the separate us_county_db area_fips/NAME/BORDINDX schema, and us_county_coord spmap id/stateicp/geometry mapping remain unverified for the 2003-2017 boundary series.
- i_aicpa_historical_routes [unresolved; full_pipeline]: The MAP workbooks and AICPA misconduct cases have author-reported historical non-sharing agreements; current compatible delivery routes are not established. A current PCPS MAP platform and its contemporary reports do not demonstrate access to the 23 historical state workbooks total across the seven biennial years or 1999-2015 case workbook. Do not infer a blanket current access denial.
- i_ebsa_current_route [unresolved; full_pipeline]: The datasheet’s former OCATS URL now resolves to a general DOL data portal. The exact OCATS dataset identifier, 2003-2015 delivery and fields are unresolved; the separate DataCollectionFrame workbook also has no supplied producer.
- i_colorado_discipline_fields [unresolved; full_pipeline]: The DORA CPA All Status page explicitly covers individual license holders, while P11 reads an FRM public accounting firm file. Neither firm-license history coverage nor the firm case/action/date fields consumed by the code is established by this listing. Keep the firm-license and firm-discipline contracts separate and unresolved.
- i_susb_weight_mismatch [unresolved; full_pipeline]: At SUSB lines 187-188, code creates estbtotal3 but uses estbtotal for estbshare. No producer for estbtotal is visible in the supplied block; confirm the imported SUSB schema before applying the conditional one-line correction.
- r_qcew [public_acquisition_required]: Annual BLS QCEW files used for CPA and lawyer observations at state, county, and MSA aggregation levels, including 2000/2005 wage-employment controls and years required by each branch.
- r_susb [public_acquisition_required]: Census SUSB six-digit NAICS annual text files for state CPA/lawyer firm-size, employment, payroll, and establishment outcomes, plus years used for the balanced 2007–2015 panels.
- r_state_gdp [undetermined]: State GDP workbook imported by program 01, reshaped from GeoFips/GeoName and annual columns, then lagged to L1_gdp.
- r_state_laus [public_acquisition_required]: State annual unemployment rates used with state GDP to create the author L1_unemp control.
- r_acs_migration [undetermined]: IPUMS USA ACS person records used by program 01 to collapse MIGRATE1 categories 3 and 4 by state/year and shift year forward one.
- r_prediction_macro [undetermined]: Separate macrocontrols.dta read by program 02, keyed on area_fips/year and expected to contain L1_unemprate and L1_realgdp.
- r_county_laus [public_acquisition_required]: County LAUS workbook staged under CPAMobility_BLS_LAUS_CountyEmployment.dta; program 05 retains area_fips, year, area_title_LAUS and unemploymentrate.
- r_msa_gdp [undetermined]: Author-prepared BEA MSA GDP CSV consumed by program 06; code reshapes geofips/geoname annual series into msagdp, merges to QCEW area/year, and forms d1logmsagdp for the 2002-2017 analysis with a 2002-2005 preperiod.
- r_state_laws [undetermined]: The P02 law/adoption frame reads State and Year from LawsByState.xls and also consumes Session, IntroBill, IntroResol, EnactBill, EnactResol, LengthSession, Senate_Dem/Rep and House_Dem/Rep after its workbook merges. Verify exact raw-field ownership across the two hand-collected workbooks against their source schemas.
- r_bds [undetermined]: Census BDS state-by-year establishment births and net job-creation inputs used to construct lagged firm_birth and jobcreation_netbirth.
- r_political_economy [undetermined]: State-level CPAMob_PoliticalEconomy.xlsx input merged on State. The P02 code derives mobilitytaskforce, CPAinBoard and Big4inBoard from raw columns; raw legislative-field ownership across this and LawsByState.xls remains a source-schema check.
- r_board_survey [undetermined]: Colbert-Murray board-survey file Data/LawPrediction/ColbertMurray.dta, merged by StatePostal and consumed through raw PUBPRAC, FUND_AUT, NO_LOCAL and NO_NAT fields. P02 then creates pubprac, fundingautonomy and localCPAs; those derived names are not raw input columns.
- r_postal_crosswalk [undetermined]: Author-named StatesPostalCodeCrosswald.xlsx is imported from its source column A; P02 derives State and StatePostal, merges on State, then joins ColbertMurray.dta on StatePostal. No producer or compatible sheet is supplied.
- r_fips_crosswalk [undetermined]: FIPSandNamesCrosswalk.dta is joined to the QCEW state panel by area_fips; P03 uses area_title for state-name cleanup. No producer or compatible file is supplied.
- r_county_adjacency [undetermined]: Historical county adjacency source needed to construct the author CPAMobility_AdjanctCountiesBorderIDs.dta border segments.
- r_border_ids [undetermined]: Author-prepared CPAMobility_AdjanctCountiesBorderIDs.dta is joined by area_fips and supplies BORDINDX for border_id plus statepair/homestate fields used in checks; no producer or compatible schema is supplied.
- r_map_sheets [undetermined]: Twenty-three AICPA MAP state workbooks total, distributed across the biennial years 2002, 2004, 2006, 2008, 2010, 2012 and 2014; staffing/compensation cells are imported through filelist, sxpose and renvars.
- r_map_adoption [undetermined]: Separate CPAMobility_MAPSurvey_Adoption.xlsx Mobility_Effective sheet, reshaped from its v_ year columns using effective_sequence/stateicp_string/stateicp/stateicp_valuelabel/ST/STATE/statefip/area_fips/Effective_Date; P07 carries ST/year and merges the generated treatment panel on area_fips/year. No producer or compatible workbook is supplied.
- r_form5500 [public_acquisition_required]: Form 5500 plan raw CSVs for 2003-2015, joined to auditor/fee schedules by filing_id in 2003-2008 and ack_id in 2009-2015. P08 generates year in its loops; 2009-2015 mail-city/state and entity-type columns are renamed before append.
- r_schedule_h [public_acquisition_required]: Schedule H raw auditor and financial records for the separate 2003-2008 filing_id and 2009-2015 ack_id vintages; P08 generates year and transforms EIN/opinion fields as specified.
- r_schedule_c [public_acquisition_required]: Schedule C Part 1 service-provider/fee raw records joined to Schedule H by filing_id/provider_01_ein/year for 2003-2008 and ack_id/provider_01_ein/year for 2009-2015. P08 generates year and normalizes later provider_other_* fields into the earlier provider_01_* names.
- r_aicpa_misconduct [undetermined]: Complete Data Set Disciplinary Sanctions_1999-2015.xlsx; code retains 2003-2015 cases and builds weighted severity counts by State and year.
- r_ebsa_ocats [undetermined]: EBSA OCATS enforcement CSV used to classify deficient-filer cases by plan administrator state and close date.
- r_ebsa_frame [undetermined]: DataCollectionFrame.xls supplies the state and adoption_year rows expanded into the 2003-2015 deficient-filer panel.
- r_colorado_license [undetermined]: Colorado CPA license history used to derive firm entry, exit and identifiers for 2003-2015.
- r_colorado_discipline [undetermined]: Colorado disciplinary case rows required by code in the same named CPA CSV: casenumber, programaction, disciplineeffectivedate and disciplinecompletedate.
- r_law_helpers_state [undetermined]: Separate LawDummiesCensusState.dta helper used by P02/P03/P04. P02 keeps State/year/area_fips/lq_annual_avg_emplvl and merges State/year; P03/P04 keep area_fips/year/adoption_year/L1_CPAMobility_Effec_longpanel and merge area_fips/year. No producer or compatible schema is supplied.
- r_law_helpers_county [undetermined]: Separate LawDummiesCensusCounty.dta helper read by P05 after county area_fips is recoded to its state FIPS. The merge uses area_fips/year; downstream code consumes CPAMobility_Effec and L1_CPAMobility_Effec_longpanel. No producer or compatible schema is supplied.
- r_law_helpers_pension [undetermined]: Separate LawDummiesPensionPlans.dta panel used by P08; code keeps L1_CPAMobility_Effec_longpanel, year and STUSPS, renames STUSPS to state and joins plan records by state/year. No producer or compatible schema is supplied.
- r_law_helpers_misconduct [undetermined]: Separate LawDummiesAICPAMisconduct.dta frame used by P09; code merges misconduct rows 1:1 on ST/year and consumes L1_CPAMobility_Effec_longpanel plus STATE for the state fixed effect. No producer or compatible schema is supplied.
- r_county_map_database [undetermined]: Separate us_county_db.dta join file read by P05 with merge key area_fips; code uses NAME in unmatched-area diagnostics and BORDINDX to construct border_id. No producer or compatible file is supplied.
- r_county_map_coordinates [undetermined]: Separate us_county_coord coordinate file used by P05 spmap. The call consumes id(id) and filters stateicp != 81 alongside polygon coordinates; exact record structure, identifier mapping and compatible geometry vintage are unresolved, and no producer is supplied.
- s_11_filelist [preparation_required]: Not found by the bounded command probe; required by raw-file inventory stages.
- s_12_sxpose [preparation_required]: Not found by the bounded command probe; required by the MAP transpose stage.
- s_13_renvars [preparation_required]: Not found by the bounded command probe; required by the MAP renaming stage.
- s_14_binscatter [preparation_required]: Not found by the bounded command probe; required by the MSA figure/regression workflow.
- s_15_spmap [preparation_required]: Not found by the bounded command probe; required by the county map output.
- s_16_winsor2 [preparation_required]: Not found by the bounded command probe; required by the prediction model input preparation.

## Review notes

- This assessment covers every supplied program: the master driver, eleven numbered Stata programs and reltimedummmies.do. No analysis_only path is supported because no complete prepared estimation datasets are supplied.
- The frozen 60 dependency IDs each have a source-linked disposition. Five additional actual reads absent from that checklist are separately documented in the workflow trace: program-02 macrocontrols.dta, program-03 FIPSandNamesCrosswalk.dta, and program-05 LawDummiesCensusCounty.dta, us_county_db.dta and us_county_coord.
- The four QCEW/SUSB identifier lists contain 49, 220, 249 and 42 lines respectively; they are identifiers only, not empirical analysis datasets.
- Preserve the MSA 2002-2017 sample, 2002-2005 preperiod, and 2001 source history needed for first differences; retain full year-specific QCEW layouts and separate 2000/2005 prediction inputs.
- DOL Form 5500, Schedule H and Schedule C are three jointly required public candidate datasets with code-specific filing_id/ack_id vintages. Pension plan populations do not imply private-only access.
- Historical AICPA MAP, misconduct and board-survey sharing terms are recorded as historical restrictions. Current compatible routes remain unknown; no blanket access denial is inferred.
- The SUSB denominator edit is conditional on imported fields; code produces estbtotal3 and consumes estbtotal, but the raw input schema was not available for confirmation.
- Only bounded source/software metadata and necessary official public pages were checked. No author code, regressions, package installation or data download was performed.
