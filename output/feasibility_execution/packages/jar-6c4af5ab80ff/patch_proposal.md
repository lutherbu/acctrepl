# Patch proposal: jar-6c4af5ab80ff

The Effectiveness of White-Collar Crime Enforcement: Evidence from the War on Terror

DOI: 10.1111/1475-679X.12343

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Complete author-documented workflow in README order: all seven supplied Stata programs embedded in PDFs, including the treatment/control preparation and the independent case referrals, NIBRS wire fraud, insider trading, aggregate SAR, and elasticity branches.

Entry points: `_TNguyen_Code_SUBMIT/1.Generate_treatment_FBIoffice_Muslim.do.pdf`, `_TNguyen_Code_SUBMIT/2.Generate_control_variables.do.pdf`, `_TNguyen_Code_SUBMIT/3.Changes_in_cases_referred.do.pdf`, `_TNguyen_Code_SUBMIT/4.Wire_fraud.do.pdf`, `_TNguyen_Code_SUBMIT/5.Insider_trading.do.pdf`, `_TNguyen_Code_SUBMIT/6.SAR.do.pdf`, `_TNguyen_Code_SUBMIT/7.Elasticity.do.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 1/12343 - The-Effectiveness-of-White-Collar-Crime-Enforcement-Evidence-from-the-War-on-Terror/nguyen-datasheet-code-and-identifiers.zip",
      "sha256": "202b6400d6d4cce02c14b0aab83f5ceaedc851aaba10e19d8b1e97d5415eba28"
    },
    {
      "path": "JAR-Volume 59/Issue 1/12343 - The-Effectiveness-of-White-Collar-Crime-Enforcement-Evidence-from-the-War-on-Terror/nguyen-online-appendix.pdf",
      "sha256": "f06ec4cea2c7356bd2e08cfaf05718478d6402ac74ca5c3441ed9e5da1430d01"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "a2288a4e345f4cd76a51cb65b8b0f45773bac54d8145f4c266435ca4f872f873"
}
```

## Proposed actions

### act_workflow_closure: Prepare a coherent working copy of the seven PDF-embedded Stata programs while preserving their supplied sequence and relative source names.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: issue_embedded_driver
Evidence: ev_readme, ev_workflow_trace, ev_io_inventory

Preparation / proposed procedure:

1. Extract and reflow each of the seven named PDF programs into a working-copy .do file, keeping the original package-relative PDF path in the evidence record.
2. Choose one coherent working-copy root that preserves package-relative input/output names; no recovery of the author’s exact home directory is needed.
3. Spot-check visually ambiguous wrapped lines against the PDF pages and keep separate branch entry points in README order.

Validation to perform later:

- Compare each reflowed program with its cached source text, then check only visually ambiguous wrapped lines against the PDF.
- Confirm the working copy retains all seven source branches and expected package-relative paths.

### act_handoff_resolution: Resolve the named author-prepared inputs, producers, schemas and source-order gaps, keeping every filename variant distinct until the intended compatible handoff is documented.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_unclosed_handoffs, issue_filename_mismatches
Evidence: ev_workflow_trace, ev_p2_county_saved, ev_p2_county_loaded, ev_p5_treat_input, ev_p5_stlouis_saved, ev_p5_stlouis_loaded

Preparation / proposed procedure:

1. Obtain the named missing author-prepared inputs or producer specifications for the FBI/TRAC, district-control, referrals and insider crosswalk files; record field names and source years.
2. Resolve the unsuffixed/suffixed P2 county-control and P5 FBI-treatment/St Louis filename pairs against actual supplied producers and consumers before configuring any path.
3. Account for the state/year and branch order across all seven programs; do not run a consumer before its documented producer or an identified prepared-input route.

Validation to perform later:

- For every read/save in the manual workflow trace, confirm an exact input path, fields and history from a supplied producer or compatible source route.
- Review the complete producer-consumer chain after the intended filenames and schemas are documented.

### act_code_consistency_clarification: Resolve the confirmed P6 duplicate generation and separately clarify P6 variable/command intent and P6-to-P7 state-variable/model handoffs before proposing source edits.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_sar_source_consistency, issue_state_elasticity_handoff, issue_sar_duplicate_gen
Evidence: ev_p6_early_treat_after, ev_p6_duplicate_treat_after, ev_p6_treat_years_generated, ev_p6_treat_years_requested, ev_p6_reg_absorb, ev_p6_state_keep, ev_p7_treat_consumption, ev_p7_reghdfe_areg, ev_p7_restore_model, ev_stata_regress_manual

Preparation / proposed procedure:

1. Resolve the P6 duplicate treat_after_new generation: the authored source saves and reloads the already-created variable, then issues a second bare gen. Obtain a supported decision about intended reuse/redefinition; do not invent a replacement expression.
2. Separately confirm the intended after_new versus after_2002 relationship and the generated treat_year_* versus requested treat5_pop_year_* names.
3. Confirm how treat_islam_w_pop_state is meant to reach P7 and which saved estimation result is intended by reghdfe_first1.
4. Resolve the literal reghdfe areg command and P6 reg-with-absorb calls from source/version documentation without substituting estimators or changing model definitions.

Validation to perform later:

- Compare the exact P6 reg calls with the Stata 18 Release 18 Base Reference Manual; retain the authored estimator until its intended command is clarified.
- After a supported correction and separate execution authorization, verify that treat_after_new is created once or intentionally reused, then check the remaining variables and stored estimates at producer/consumer boundaries.

### act_stata_addons: Configure a future Stata environment for the missing invoked commands ivreghdfe and tabmiss, then verify those exact commands and their dependencies.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: sw_stata_addons
Evidence: ev_addon_checks

Preparation / proposed procedure:

1. Use an approved Stata package source or existing package directory to configure ivreghdfe and tabmiss; do not change estimator calls or package code during this assessment.
2. Preserve and document the currently found commands esttab, eststo, estfe, reghdfe and ivpoisson.

Validation to perform later:

- In a future authorized setup, repeat exact `which ivreghdfe` and `which tabmiss` checks and verify any required helper commands.
- Before execution, confirm Stata 18 add-on dependencies and command syntax in the configured environment.

### act_data_route_closure: Resolve each separately named data contract against an exact compatible author-prepared file or a supported product route, including fields, identifiers, periods and transforms. Current public and local candidates remain unverified; no access barriers or substitute products are inferred.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_trac, req_rcms, req_nibrs, req_insiderfeed, req_insider_crosswalks, req_fincen_aggregate, req_controls_saipe, req_controls_census, req_controls_bea_population, req_controls_bea_income, req_controls_bls, req_controls_fdic, req_controls_minority, req_county_geography, req_fbi_judicial_geo, req_geocorr_zip, req_sec_litigation, req_crsp_history, req_company_address_link, req_compustat_quarterly, issue_missing_author_data
Evidence: ev_public_sources, ev_public_trac, ev_public_rcms, ev_public_nibrs, ev_public_fincen, ev_public_sec, ev_public_saipe, ev_public_bea, ev_public_fdic, ev_public_census_race, ev_catalog_candidates, ev_workflow_trace, ev_pkg_county_ids, ev_pkg_firm_ids, ev_pkg_judicial_ids, ev_pkg_state_ids, ev_public_fincen_period, ev_funda_catalog_lookup

Preparation / proposed procedure:

1. For every requirement, confirm the exact author-prepared file or source product, source columns, identifier keys, geography vintage, period and required cleaning; keep TRAC case referrals, NIBRS incidents, InsiderFeed trades, FinCEN aggregate counts, county controls, SEC litigation releases and market data as distinct contracts.
2. For public routes, verify the precise historical file/interface and required fields before acquisition; the ARDA, ICPSR, FinCEN, BEA, FDIC, SAIPE, Census and SEC pages establish only the product route described in their evidence.
3. For the local CRSP/Compustat candidates, compare full product history, identifiers and target variable construction with the named prepared DTA files; bounded one-row readability is not coverage or a prepared-data match.
4. Retain author-prepared crosswalks and unproduced TRAC/FBI/insider/state-population intermediates as unresolved until their producers and schemas are identified.

Validation to perform later:

- Use bounded format-aware metadata checks on each exact prepared input and compare required columns, types, key uniqueness, period and coverage to its consuming code.
- Confirm all requirements independently; a route or table for one product does not satisfy another jointly required source.

### act_trac_access: Confirm an authorized TRACFED route for the author’s case-referral/prosecutorial-outcome extracts or obtain the compatible prepared files and schema.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_trac
Evidence: ev_public_trac, ev_trac_source, ev_workflow_trace

Preparation / proposed procedure:

1. Confirm permitted access to the subscription route or obtain the author-prepared 1992–2003/2004–2013 extracts and district/year/county mapping specifications.
2. Do not treat public summary tables as a substitute for the case-level author records.

Validation to perform later:

- Check the exact case outcome/referral fields, district identifiers, year span and mapping keys against the supplied P3 consumer before use.

### act_insiderfeed_access: Confirm an authorized WRDS route to the author’s Thomson Reuters Insider Filing Data Feed exports or obtain the compatible prepared person/company and trade-level files.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_insiderfeed
Evidence: ev_public_sources, ev_insider_code, ev_workflow_trace

Preparation / proposed procedure:

1. Confirm current product access and the author export’s covered dates, identifiers, transaction fields and trade-level/person-company schema.
2. Obtain the separately named CUSIP/PERMNO and city/county/FBI crosswalk specifications under req_insider_crosswalks.

Validation to perform later:

- Compare source columns and identifiers with the P5 joins and prepared insider_trade_level.dta output before any authorized execution.


## Remaining issues and prerequisites

- issue_missing_author_data [unresolved; full_pipeline]: The release contains documentation, seven substantial Stata programs embedded in PDFs, an online appendix, and four identifier-only CSVs (county, firm, judicial district and state); it does not contain the raw or prepared panels consumed by the workflow. Product-specific coverage/field compatibility and the named author-prepared intermediates remain unverified.
- issue_embedded_driver [preparation; full_pipeline]: The seven substantial Stata programs are embedded in PDFs rather than supplied as .do files. Extracting/reflowing them and choosing a coherent working-copy root that preserves package-relative names are preparation; no exact author home-directory root is required. Only visually ambiguous wrapped lines need spot-checking during preparation.
- issue_unclosed_handoffs [unresolved; full_pipeline]: Specific author-prepared producers/schemas are absent from the seven supplied programs: FBI_merged_district_ALL.dta (commented as created later), TRACdistrict_county.dta, fbiofficename_fbi_county_district.dta, personal_income_2000_2005_part1.dta and part2, district_prep_for_control_merge.dta, extract9203_renamed.dta, year_refer_all.csv, sum_whitecol_03_92_03_all_new.dta, sum_whitecol_03_92_03_all_bytype_new.dta, InsiderFeed hand-filled/geography crosswalks, and fbi_state_pop.dta. Resolve each named producer, input schema and order before execution.
- issue_filename_mismatches [unresolved; full_pipeline]: P2 saves county_control_new_1990_2010_1.dta but later joins county_control_new_1990_2010.dta. P1 names fbi_office_distance_county_islam.dta while P5 reads fbi_office_distance_county_islam_treat5_forinsider.dta. P5 saves insider_fbi_stlouis_treat_90.dta but later appends insider_fbi_stlouis_treat.dta. Preserve these as distinct producer/consumer paths until a supported consistent route is established.
- issue_sar_source_consistency [unresolved; full_pipeline]: P6 uses after_new in the later treat_after_new expression although the earlier supplied block creates after_2002, and its year loop creates treat_year_* while a later local requests treat5_pop_year_1998–2006; intended aliases and definitions remain unknown. P6 also calls reg with absorb(state), while the Stata 18 Release 18 regress option table does not list absorb(). Resolve those command/variable intentions without inventing substitutions.
- issue_state_elasticity_handoff [unresolved; full_pipeline]: P6 writes state_treat_2.dta after dropping treat_islam_w_pop_state, which P7 later consumes. P7 also contains the literal command prefix reghdfe areg and restores reghdfe_first1, whose producer is absent from all seven programs. Resolve intended variable/object names and command structure without replacing the estimator.
- issue_sar_duplicate_gen [blocking; full_pipeline]: P6 creates treat_after_new, saves/reloads the SAR panel, carries it into the prepared regression file, then issues a second uncaptured gen of the same variable after reloading that prepared file. No intervening drop or capture is present in the supplied path. Stata gen cannot create a variable that already exists, so this is a confirmed run-stopping source defect, distinct from the unknown after_new/yearly alias intent. No replacement expression is inferred.
- req_trac [undetermined]: TRACFED FBI case referrals and prosecutorial outcomes used by the case-referral branch, including 1992–2003 and 2004–2013 author CSV extracts and the unproduced district/year and county mappings.
- req_rcms [undetermined]: ARDA Religious Congregations and Membership Study 2000 county data needed for the Muslim-concentration treatment measures, with county identifiers and the ISLAMRT/ISLAMAD/ISLAMCG source fields consumed by P1.
- req_nibrs [undetermined]: NIBRS incident inputs imported by the wire-fraud branch, including the offense code and population/date/county fields V20061, B2005 and B2008; P4 reads 1994–2011 files and later prepares 1997–2006 outcomes.
- req_insiderfeed [undetermined]: WRDS Thomson Reuters Insider Filing Data Feed person/company and trade-level inputs consumed by P5, including the source identifiers and transaction fields used to create insider.dta and insider_trade_level.dta.
- req_insider_crosswalks [undetermined]: Separate author-prepared insider inputs: permno_ncusip_append_cusip.dta plus hand-filled city/state/county and insider-to-FBI-office crosswalks used by P5; these are not the Insider Filing Data Feed itself.
- req_fincen_aggregate [undetermined]: FinCEN aggregate depository-institution SAR activity by state/year and suspicious-activity category consumed by P6. The code expects aggregate counts; it does not require confidential individual SAR reports.
- req_controls_saipe [undetermined]: County/state poverty counts and rates and median household income used by P2, including the author CSV families in_pov_*, pov_num_*, pov_pct_* and med_income_*.
- req_controls_census [undetermined]: County controls from USA Counties/Census data families used by P2, including high-school education, divorce and land-area source files; the author’s dated CSV names and data definitions remain the target.
- req_controls_bea_population [undetermined]: BEA county/state population inputs referenced by P2, including bea_population_1990_2010_part1.csv through part4.csv and the named population joins.
- req_controls_bea_income [undetermined]: Author-prepared personal_income_2000_2005_part1.dta and part2.dta consumed by P2 for the district/state control construction.
- req_controls_bls [undetermined]: County/state unemployment, unemployment-rate and labor-force CSV families imported by P2, including unemp_1990_2010_part*, laborforce_1990_2010_part* and unemp_rate_1990_2010_part*.
- req_controls_fdic [undetermined]: Author BNK01 bank/savings office and deposit control CSV families consumed by P2 for county/state controls.
- req_controls_minority [undetermined]: Author NBER minority-population inputs stch1995.dta through stch2010.dta used in county/state control construction.
- req_county_geography [undetermined]: Census county/state/FIPS geography inputs used by the authored joins, including fixed-width county2000.txt and state name/abbreviation keys.
- req_fbi_judicial_geo [undetermined]: FBI field-office/jurisdiction/address inputs and judicial-district county crosswalks used in P1, including Fieldoffice.csv, named FBI prepared tables and hand-filled FBI/TRAC/RCMS links.
- req_geocorr_zip [undetermined]: ZIP-to-county/centroid lookup and geocoding intermediates named by P1/P5, including countyziplonglat.dta and geocorr2k_zipcode_string.dta.
- req_sec_litigation [undetermined]: SEC litigation-release data and the exact author mapping file findgvkeyaffiliate_sec_release.csv used to build firm/county/year investigation geography and later controls.
- req_crsp_history [undetermined]: CRSP author-prepared return and size panels, including crsp_size_1985_2011.dta and crsp_1986_2010_ret_1.dta used by the insider/elasticity branches.
- req_company_address_link [undetermined]: Prepared CRSP/Compustat company-address and identifier-link inputs, including crsp_compu_address.dta and any affiliate/firm link data consumed by the SEC and insider branches.
- req_compustat_quarterly [undetermined]: Author quarterly accounting/market inputs, including the exact P5/P7 prepared file compsutat_crsp_quarter_clean_84_11.dta and its consumed GVKEY/date/accounting fields.
- sw_stata_addons [preparation_required]: Exact command probes found esttab, eststo, estfe, reghdfe and ivpoisson; ivreghdfe and tabmiss were not found. Configure/install the two missing commands in a future authorized setup and recheck the exact entry points; no installation was attempted.

## Review notes

- All seven embedded programs, README, datasheet, appendix, source/resource catalog candidates, file-level workflow trace, public route evidence, and exact runtime/add-on checks have been reviewed. No analysis_only scope is supported because the release contains no prepared analysis panels.
- COMP.FUNDA was inspected as required by the frozen catalog instructions, but its annual product is not treated as a substitute for the author’s quarterly input; COMP.FUNDQ is only a readable local candidate, not a verified match. Public source pages are recorded as product-route evidence with compatibility left unverified.
- An unauthorized self-written Stata probe (not author code or study data) was run: it fitted areg on four synthetic observations and returned r(198) for regress with absorb(). The probe is excluded from assessment evidence pending coordinator/root disposition; its do-file, batch log, empty stdout capture, exit-code record, JSON capture and invocation/cwd manifest remain preserved under probes/stata_absorb_probe*. The original outer tool-wrapper source bytes and separate stderr bytes were not preserved. No supplied author program or study dataset was executed, and no data were downloaded, software installed, or source edited. The reg/absorb assessment uses only the Stata 18 Release 18 manual and supplied source.
