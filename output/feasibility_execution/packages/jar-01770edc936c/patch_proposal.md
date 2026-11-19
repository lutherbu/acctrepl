# Patch proposal: jar-01770edc936c

Why Do Politicians Intervene in Accounting Regulation? The Role of Ideology and Special Interests

DOI: 10.1111/1475-679X.12300

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full author-documented workflow across the 108th Congress stock-option branch and 110th/111th Congress fair-value branch, including code-document preparation programs, manual source/match stages and all supplied main/robustness branches. Substantial Stata programs are embedded in BDS JAR 2020 Code.pdf, which is not a standalone executable driver.

Entry points: `BDS JAR 2020 Code.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 3/12300 - Why-Do-Politicians-Intervene-in-Accounting-Regulation-The-Role-of-Ideology-and-Special-Interests/bds-datasheet-and-code.zip",
      "sha256": "243e9fd9a35e7091d3fc351c027c8acb98e69a8486e8d507f23f1484d106a01b"
    },
    {
      "path": "JAR-Volume 58/Issue 3/12300 - Why-Do-Politicians-Intervene-in-Accounting-Regulation-The-Role-of-Ideology-and-Special-Interests/bds-online-appendix.pdf",
      "sha256": "f129ecfe3fac3d9cc041cefc8688c5c4f4c760facc4975bb883d04815a4122f6"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "00221f8ca114c1a78cef9f415f0608b33402ce7226b6db842d932910212370f5"
}
```

## Proposed actions

### a-prepare-driver: In a working copy, extract/reflow the document-embedded Stata modules, preserve their section boundaries, and configure coherent FILEPATH/RESULTSPATH/workdir roots. Follow the source-supported producer-consumer sequence recorded in a-run-workflow; do not infer new scientific definitions.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: embedded_stata_not_driver
Evidence: e-code-mable, e-code-qcew, e-code-master, e-code-fv-main, e-code-option-main, e-code-option-branch

Preparation / proposed procedure:

1. Recover each complete embedded preparation/analysis section from the code PDF into text source files, preserving source page/line provenance and the original section boundaries.
2. Configure FILEPATH, RESULTSPATH and workdir in a working copy and keep separate input/output directories coherent across all producers and consumers.
3. Expose the two packaged statement DTA inputs at the exact filenames expected by the fair-value and stock-option consumer merges, retaining the supplied files unchanged.
4. Wire the recovered modules in the dependency order given in the run-procedure action; leave only the mcl producer, Farber total-assets source and 108th district-key compatibility as named source questions.

Validation to perform later:

- Review the extracted source and path map against all 5,799 cached source lines without executing them.
- Verify every generated filename below has one identified source producer and the named next consumer; flag only the specifically stated unresolved handoffs.

### a-resolve-input-contracts: Reconcile each unresolved input requirement against the exact source reads and producer/consumer order in the embedded code. Ask for the author-prepared files or specific historical source release, rights/access route, period and raw schemas, including all distinct manual match/revision workbooks.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: input_contracts_incomplete
Evidence: e-code-mable, e-code-qcew, e-code-master, e-ds-fv, e-code-crp, e-code-fasb, e-code-fasb-match, e-code-farber, e-code-bhc, e-code-compbank, e-code-crsp, e-code-crsp-window, e-code-hmda, e-code-bea, e-appendix-scope

Preparation / proposed procedure:

1. Match each named input requirement to its authored source/product, fields, periods, identifiers and transformations, and preserve separate/manual versions.
2. Use the explicit generated-intermediate sequence in a-run-workflow to identify any missing source file; do not treat documented produced .dta files as extra raw acquisitions.
3. Retain the specific mcl producer, 2003 total-assets source and 108th GDP district-key gaps until the actual source/schema or compatibility is established.
4. For the readable WRDS/CRSP/Compustat common-table candidates, verify the required periods, native fields, author-prepared export and identifier construction; retain only those concrete compatibility gaps.

Validation to perform later:

- Reconcile the input map to each external raw read and the named producer-consumer stages in a-run-workflow.
- Check each source extract’s key uniqueness, period, field mappings and merge coverage against the authored code before a future run.

### a-clarify-mcl: Identify the omitted pre-merge source/producer for mcl and the politician FASB/SEC letter fields in a working copy of the extracted code. Keep this separate from the later CONGRESS_MEMBER_SEC_COMMENT_LETTER_DATA merge, which creates mfasbsec.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: missing_mcl_producer
Evidence: e-code-mcl-gap

Preparation / proposed procedure:

1. Recover the complete page-8/page-9 source and execution order in the extracted code copy.
2. Trace the origin of mcl, lastname, firstname, accintcl and prevcl and identify the exact matching key and schema.
3. If the producer or required prepared table is absent, document that specific source and request only its path/field specification.

Validation to perform later:

- Confirm each field has one documented producer before the later FASB/SEC indicator merge.

### a-clarify-assets: Resolve the total-assets source used by the 2003 Farber data branch without assuming that an imported matching workbook contains Compustat fundamentals.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: stock_option_assets_source
Evidence: e-code-stockassets, e-code-farber

Preparation / proposed procedure:

1. Inspect the full extracted section and the input workbook contract, including exact presence of gvkey, fyear, fye and at.
2. Identify whether the row-level 2003 assets originate in a supplied prepared file or a separate Compustat input.
3. Retain adjusted Farber items 398/399 and the authored sample; do not substitute unadjusted generic fields.

Validation to perform later:

- Check 2003 GVKEY uniqueness and the exact numerator/total-assets match before running the branch.

### a-repair-paths: Extract/reflow the document-embedded Stata programs into a working copy and prepare a coherent path wrapper, correcting only the evidenced path defects.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: path_setup_and_bea_import
Evidence: e-code-inventory, e-code-bea-path, e-code-outputpath, e-code-fv-main

Preparation / proposed procedure:

1. In the extracted 2007 BEA program, change the sheet-2 input prefix from `3$FILEPATH/...` to the same `$FILEPATH/...` root used by sheets 1, 3, 4 and 5.
2. Set FILEPATH, RESULTSPATH and workdir through host-visible relative execution roots; do not embed absolute Dropbox workspace paths.
3. Align the Table 5B output path with the date directory created under RESULTSPATH, or explicitly provision/record its FILEPATH output folder if preserving the literal source path.
4. Preserve separate input and results roots and all author branches; verify each changed producer and consumer path as a set.

Validation to perform later:

- Static path-map review confirms all required folders exist in the planned execution root and all generated intermediates are consumed after production.

### a-clarify-gdp108: Confirm the intended district-geography key for the 108th Congress stock-option GDP control.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: district_gdp_108_key
Evidence: e-code-district108, e-code-option-main, e-code-gdp109-producer

Preparation / proposed procedure:

1. Compare the prepared 108th Congress politician district codes with the source MABLE/BEA districtcd109 keys.
2. Ask for the author-defined mapping or compatibility statement if the keys represent different district definitions.
3. Do not silently replace districtcd109 with districtcd108 or map one geography onto the other.

Validation to perform later:

- Validate the documented key mapping and unmatched/duplicate behavior before the stock-option analysis.

### a-clarify-car-window: Confirm the CAR event-window documentation while preserving the supplied March 11–13, 2009 code predicate for any future attempt.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: car_comment_window
Evidence: e-code-crsp, e-code-crsp-window, e-code-inventory

Preparation / proposed procedure:

1. Use the actual March 11–13 predicate as the current source-defined computational window.
2. Request confirmation of the inconsistent comment text and update that comment only in the extracted working copy after documenting the intended date convention.

Validation to perform later:

- Confirm the three included trading dates are centered on March 12, 2009 and the 2008 beta-estimation records cover the required year.

### a-configure-fs: Make the Stata `fs` command available in the Stata 18 adopath before running the embedded directory-enumeration loops.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: stata_fs
Evidence: e-probe-fs, e-code-qcew, e-code-fasb

Preparation / proposed procedure:

1. Use the authorized Stata environment to configure an existing compatible `fs` ado installation, or install it there under the environment owner’s normal package process.
2. Keep the directory enumeration limited to the intended intermediate folders so similarly named or unrelated files are not appended.

Validation to perform later:

- Run `which fs` in Stata 18 and confirm its location.
- In a temporary empty test folder, confirm `fs` returns the intended local file list without opening any study data.

### a-verify-excel-manual: Confirm an Excel-compatible author workflow/runtime for the documented manual hand-collection and PAC/letter matching stages, and identify which prepared match workbooks can be supplied or created from documented author decisions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: excel_manual
Evidence: e-ds-tools, e-code-fasb, e-code-fasb-match, e-code-farber, e-code-bhc

Preparation / proposed procedure:

1. Verify the chosen spreadsheet application can preserve and edit the referenced XLSX workbooks and formulas/cells used by the authors.
2. Recover the documented manual matching inputs and decisions; do not create new links by independent research.

Validation to perform later:

- Open each supplied/recovered workbook in a compatible application and compare the relevant sheet names, columns and manual match rows with Stata import expectations before any execution.

### a-source-public-historical: Resolve and, if available under the applicable terms, stage the exact historical agency releases used by the geographic/employment/lending/GDP preparation code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: mable_geography, qcew_employment, hmda_county_summaries, bea_gdp_releases
Evidence: e-code-mable, e-code-qcew, e-code-hmda, e-code-bea, e-code-bea-path, e-code-gdp109-producer

Preparation / proposed procedure:

1. Identify compatible MABLE/Geocorr congressional-vintage crosswalks; BLS QCEW title plus 2003/2008 annual files; CFPB county summary CSVs for 2007–2010; and both separately dated BEA metro-GDP releases.
2. Check release and schema before acquisition or conversion; keep the 2007 and 2011 BEA vintages separate and preserve the authored congressional codes and MABLE allocations.
3. Resolve the demonstrated 3$FILEPATH sheet-2 typo and configure the required roots in the author working copy only; do not change the GDP series or geographic definition.

Validation to perform later:

- Inspect workbook/CSV headers and units, covered years and geography keys before reshaping.
- Check all joins and district allocation output keys against the code’s intended 108th/109th Congress crosswalks.

### a-source-politician: Recover the author-prepared politician master/covariate/election inputs and retain distinct manual letter and CRP mapping files.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: politician_roster_covariates, politician_election_inputs, politician_sec_comment_inputs, politician_crp_match
Evidence: e-code-master, e-code-mcl-gap, e-code-crp, e-ds-fv, e-ds-option

Preparation / proposed procedure:

1. Identify the exact input files/schemas for member roster, tenure, DW-NOMINATE, CV/business covariates, 2002/2006/2008 election data, special elections, SEC comment-letter controls and CONGRESS_MEMBER_CRP_MATCH.
2. Keep CONGRESS_MEMBER_CRP_MATCH separate from cr1congmem_osmatch.dta and keep the later SEC comment-letter merge separate from the missing mcl producer.
3. Obtain the documented special-election/career/letter decisions and preserve the authored politician identifiers/cycles.

Validation to perform later:

- Compare each file’s member key, Congress/cycle, field names and row/key coverage with the corresponding merge and keep statements in the full master code.

### a-source-crp-fasb: Recover the specific historical CRP extracts and author-curated FASB/SIFI/SCAP letter and match workbooks, preserving separate checked and revised versions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: crp_candidate_pac_sources, crp_individual_committee_contributions, sifi_scap_pac_match, fasb_issue_letters, fasb_manual_match_workbooks
Evidence: e-code-crp, e-ds-crp, e-code-fasb, e-code-fasb-match, e-code-bhc, e-code-fasb-contributor-source, e-code-inventory

Preparation / proposed procedure:

1. Resolve the CRP_PAC_DATA, CRP_OTHER_PAC_DATA, CRP_Categories, CRP_CANDIDATE_DATA, cr1congos_indivs_contributors.dta, CRP_INDIV_DATA and CRP_CMTES_DATA vintages, access terms and fields; keep the preformatted contributor file distinct because the supplied code has no producer for it.
2. Recover all six separate FASB issue files and the specifically named checked affiliation workbook plus the separate 1CS, 2TP and RELCL match workbooks.
3. Retain the CHICAGOFED_SIFI_SCAP_MATCH in its own bank/PAC link role; do not substitute an unreviewed name-based match or infer that historic noncommercial wording proves present rights.

Validation to perform later:

- Compare recipient/committee/candidate identifiers, cycles, affiliation text and match status against each consuming merge; preserve manual check/revision rows.

### a-source-stock-option: Recover the stock-option branch’s adjusted Farber source and separate manually authored historical-name/company/PAC/member crosswalk inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: farber_adjusted_option_data, historical_company_names, farber_pac_match_workbooks, iesoc_company_pac_map, stock_option_os_match
Evidence: e-code-farber, e-ds-farber, e-code-option-main, e-code-crp

Preparation / proposed procedure:

1. Obtain the specific FJP2007 corrected items 398/399 CSV and compatible historical company-name extract; do not substitute generic Compustat compensation values.
2. Recover PAC_MATCHING.XLSX and PAC_MATCHING_REVISED.XLSX as separate versions, the IESOC 2003–2004 firm/PAC mapping and cr1congmem_osmatch.dta.
3. Keep the unresolved total-assets source separate and identify its actual producer, fields gvkey/fye/fyear/at and 2003 selection before connecting it to this branch.

Validation to perform later:

- Inspect only bounded headers/metadata, then verify GVKEY, fiscal-year, company/PAC/member identifiers and match coverage against the downstream code.

### a-source-bank: Use the readable catalog-listed Compustat Bank Quarterly and CRSP daily tables as local source candidates, then verify the exact historical slices and author-prepared exports/links. The bounded BHC/Y9C lookup found no match and leaves that route unknown.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: bhc_fr_y9c_panel, compustat_bank_quarterly, crsp_bank_market_inputs, bank_identifier_and_pac_matches
Evidence: e-code-bhc, e-code-compbank, e-code-crsp, e-code-crsp-window, e-ds-banks, e-catalog-bank-search, e-catalog-bhc-search, e-probe-compb-bank-fundq, e-probe-crsp-dsf, e-probe-crsp-dsi, e-probe-crsp-ccmxpf

Preparation / proposed procedure:

1. For WRDS_COMPUSTAT_BANK_DATA, use only the readable COMPB.BANK_FUNDQ (Bank Interim Quarterly File) as a local candidate; do not substitute the separate annual COMPB.BANK_FUNDA table. Verify the authored 2006–2009 quarters, updq==3 final-update filter, native-to-Stata field mapping, and exact WRDS_COMPUSTAT_BANK_DATA export contents before use.
2. For WRDS_CRSP_DATA, CRSP.DSF and CRSP.DSI are readable candidates for PERMNO/DATE/RET and DATE/SPRTRN. Verify how the author prepared the combined input and its 2008 beta/event-history coverage; do not create or assume an undocumented index join.
3. CRSP.CCMXPF_LINKTABLE is a readable historical Compustat/CRSP link candidate for GVKEY/LPERMNO/LPERMCO and link intervals. It does not provide RSSD or the manually prepared TICKER_MATCH_FILE/CHICAGOFED_PAC_MATCH; preserve those separate mappings and verify their source-compatible identifiers.
4. The bounded Y9C/BHCK/BHC catalog search found no candidate for WRDS_BHC_DATA. Record this as a catalog discovery miss only; clarify the exact FR Y-9C/BHC extract, fields and historical population without inferring that a route is unavailable.
5. Preserve the authored bank accounting, CAR and beta histories and the actual March 11–13, 2009 CAR predicate; keep the inconsistent comment as a separate clarification.

Validation to perform later:

- For each future export, compare all required fields, fiscal-quarter/date coverage, identifiers and row/key uniqueness to the code, including GVKEY/DATADATE and PERMNO/RSSD mapping intervals.
- Check the author-provided TICKER_MATCH_FILE and CHICAGOFED_PAC_MATCH against the distinct CCMXPF and NYFed/FRB links; a catalog table alone does not close the RSSD/PAC handoff.
- The one-row common-file probes establish readability and listed columns only; verify the required periods and exact native-field/export mappings before a run.

### a-source-political-supplements: Recover the separate political endorsement, CFscore, voting, CCES and stock-option bill cosponsorship data preparations used by the supplied branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: organization_endorsement_inputs, dime_cfscore_inputs, voting_data, cces_survey_data, stock_option_cosponsorship
Evidence: e-code-fv-main, e-code-option-main, e-code-option-branch

Preparation / proposed procedure:

1. Identify the exact author-prepared data and source route for FreedomWorks, Tea Party Express, Republican Study Committee, voting, CCES and 108th Congress cosponsorship variables.
2. Retain both cycle-specific and non-cycle CFscore files as separate inputs and verify their candidate/member IDs and coverage.
3. Do not reconstruct these political measures from external sources or substitute a different release without author-compatible field/key evidence.

Validation to perform later:

- Compare each input’s unit of observation, identifier, cycle/year and variables with the exact branch merge and sample conditions before an attempt.

### a-run-workflow: After the unresolved inputs and named compatibility issues are resolved, extract and run the supplied Stata sections in this source-supported producer-consumer order. Keep each module’s authored definitions, cycles and robustness branch; generated files below are workflow intermediates, not separate raw-data acquisitions.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: embedded_stata_not_driver, input_contracts_incomplete, path_setup_and_bea_import, missing_mcl_producer, stock_option_assets_source, district_gdp_108_key, car_comment_window, mable_geography, qcew_employment, politician_roster_covariates, politician_election_inputs, politician_sec_comment_inputs, politician_crp_match, crp_candidate_pac_sources, crp_individual_committee_contributions, sifi_scap_pac_match, fasb_issue_letters, fasb_manual_match_workbooks, farber_adjusted_option_data, historical_company_names, farber_pac_match_workbooks, iesoc_company_pac_map, stock_option_os_match, bhc_fr_y9c_panel, compustat_bank_quarterly, crsp_bank_market_inputs, bank_identifier_and_pac_matches, hmda_county_summaries, bea_gdp_releases, organization_endorsement_inputs, dime_cfscore_inputs, voting_data, cces_survey_data, stock_option_cosponsorship, statement_fv_input, statement_option_input
Evidence: e-code-mable, e-code-mable-county-outputs, e-code-qcew, e-code-qcew-district-output, e-code-master, e-code-master-qcew-consumer, e-code-master-cycle-splits, e-code-crp, e-code-crp-candidate-consumer, e-code-sifi-contribution-output, e-code-fasb, e-code-fasb-letter-output, e-code-fasb-employee-output, e-code-fasb-pac-output, e-code-stock-pac-composite, e-code-farber, e-code-stockassets, e-code-bhc, e-code-bhc-accounting-output, e-code-compbank, e-code-compbank-accounting-output, e-code-crsp, e-code-crsp-car-output, e-code-bank-annual-output, e-code-bank-politician-output, e-code-hmda, e-code-hmda-district-output, e-code-bea, e-code-bea-path, e-code-bea-stockoption-output, e-code-bea-fairvalue-output, e-code-fairvalue-generated-consumers, e-code-fv-main, e-code-option-main, e-code-stockoption-generated-consumers, e-code-option-branch, e-code-fasb-contributor-source, e-code-inventory

Preparation / proposed procedure:

1. 1. Extract and configure first: keep the PDF modules separate, set FILEPATH/RESULTSPATH/workdir in the working copy, and repair only the documented 2007 BEA sheet-2 `3$FILEPATH` typo and the Table 5B result root. The PDF has no cohesive driver; these are source-order modules.
2. 2. Run the three “PREPARE MABLE DATA” blocks before any geographic merge: MSA-to-Congress creates mable_cbsa-congdis_alloc.dta; county-to-Congress 108th and 109th create mable_county2002-congdis_alloc_2k-cd108.dta and ...cd109.dta.
3. 3. Run “COUNTY LABOR DATA”: import QCEW title files and 2003/2008 annual CSVs; build cr1bls_empcounty_singlefile.dta, split the 108th and 109th year panels, join each to its matching county MABLE file, collapse/reshape to cr1disemp_singlefile_wide.dta. “START WITH CONGRESS MEMBER FILE” consumes that output by statepcd/district.
4. 4. Build “START WITH CONGRESS MEMBER FILE”: begin at CONGRESS_MEMBER_FILE, then tenure, DW-NOMINATE, 2002/2006/2008 election files, special-election candidates, CV/business data and letter controls; add CONGRESS_MEMBER_CRP_MATCH and QCEW district employment; then save cr2master_politicians.dta and its 108th/110th/111th slices. The mcl/lastname/firstname/accintcl/prevcl producer remains unresolved: the later CONGRESS_MEMBER_SEC_COMMENT_LETTER_DATA merge produces the separate mfasbsec/letter fields.
5. 5. Build general CRP contributions before any FASB-PAC, SIFI/SCAP, bank-PAC or analysis consumer: append CRP_PAC_DATA and CRP_OTHER_PAC_DATA, merge CRP_Categories, and produce cr1congos_candspacs.dta, its cycle PAC totals, quarterly and industry-wide outputs. Then merge CRP_CANDIDATE_DATA and CONGRESS_MEMBER_CRP_MATCH with generated PAC/industry totals to create cr1congos_candscont.dta.
6. 6. Run “MATCH SIFI/SCAP 2009 LIST WITH CAMPAIGN CONTRIBUTION FILE” after cr1congos_candspacs.dta; CHICAGOFED_SIFI_SCAP_MATCH joins that file to create cr2chicagofed_contmatch_paclist_SiFiTARP.dta, which the fair-value branch later merges.
7. 7. Run the FASB comment-letter preparation: import the six issue sheets and append to cr1stop_fasbcl.dta. The employee-affiliation path reads the separate cr1congos_indivs_contributors.dta input (no producer is visible in the supplied document), then uses the dated checked workbook, CRP_INDIV_DATA and CONGRESS_MEMBER_CRP_MATCH to produce cr1stop_fasbcl_empindiv.dta. In the separate PAC path, use CRP_CMTES_DATA, FASB_PAC_MATCH_1CS, FASB_PAC_MATCH_2TP and FASBCL_PAC_MATCH_RELCL to produce clpacam_pacam.dta; keep those manual matches distinct.
8. 8. Run the Farber and 108th-PAC preparation: the corrected option-expense CSV plus historical names, CRP_CMTES_DATA and PAC_MATCHING/PAC_MATCHING_REVISED produce Farber-to-committee mappings; the distinct 2003 total-assets block must first be tied to its actual producer before the corrected data can generate expense ratios and FJP2007_maxfirmvars.dta. Combine general PAC totals, IESOC/technology PAC measures, clpacam_pacam.dta, FJP2007_maxfirmvars.dta and the separate cr1congmem_osmatch.dta to produce cr2stop_pacam.dta. Do not substitute CONGRESS_MEMBER_CRP_MATCH for that distinct OpenSecrets match.
9. 9. Prepare bank inputs in their source order: WRDS_BHC_DATA -> cr2bhc_accdata.dta; WRDS_COMPUSTAT_BANK_DATA -> cr2bank_accdata_compustat.dta; WRDS_CRSP_DATA plus TICKER_MATCH_FILE -> crsp_0107-1209rssdid.dta -> 2008 daily beta and March 11–13, 2009 CAR calculation -> cr2crsp_cars_firmlevel.dta. Merge the three prepared panels by the authored RSSD/GVKEY/date keys to cr2bankdata_master.dta, then create cr2bankdata_av2008.dta.
10. 10. Build politician-bank controls after the politician master and general CRP PAC file exist: CHICAGOFED_PAC_MATCH joins cr1congos_candspacs.dta and cr2master_politicians.dta, outputs connection tables and a unique politician/RSSD file, then merges cr2bankdata_av2008.dta to produce cr3aggbank_contdata.dta. The fair-value master consumes this generated control file.
11. 11. Build mortgage/GDP district controls before analysis: append the 2007–2010 HMDA county summaries, join the 109th county MABLE allocation and collapse to cr1ffiec_hdma_sumtab.dta. Separately, the September 2007 BEA release plus MABLE MSA allocation creates cr2stategdp_districtlevel_2001-2005.dta; the September 2011 release plus that MABLE output creates cr2stategdp_districtlevel_2007-2009.dta. The 108th stock-option code consumes the former using districtcd109; confirm that authored key’s compatibility rather than translating it.
12. 12. Run the fair-value 110th/111th branch from cr2master_politicians.dta: merge cr3aggbank_contdata.dta, cr1congos_candscont.dta, quarterly PAC measures, SIFI/SCAP data, political controls, 2007–2009 GDP and HMDA; save cr2masterdata_fairvalueaccounting.dta; merge the supplied fair-value statement coding data under the source-expected filename to create cr2masterdata_fairvalueaccounting_wstats.dta; retain the main tables and OF1/OF2 robustness branches.
13. 13. Run the 108th stock-option branch from cr2master_politicians108.dta: merge bill cosponsorship, cr2stop_pacam.dta, cr1stop_fasbcl_empindiv.dta and 2001–2005 GDP; save cr2masterdata_stockoptions.dta; merge the supplied stock-option statement coding data under the source-expected filename to create cr2masterdata_stockoptions_wstats.dta; retain Tables 3/4/8/9/10 and the supplied panel/switcher analyses.
14. 14. Before the first attempt, verify every required source/product and manual workbook, Stata fs availability and Excel-compatible manual stages; resolve the three named producer/key gaps. Preserve the actual CAR date predicate while recording its conflicting comment for clarification.

Validation to perform later:

- Review extracted modules in the sequence above and check that each named generated intermediate has the specified producer before its consumer; do not execute the author programs during this review.
- For the future run, confirm each handoff’s output filename, fields, merge key, period, row/key uniqueness and coverage at the exact downstream merge, including the supplied statement-DTA filename mappings.
- Confirm the unresolved mcl source, 2003 total-assets producer and 108th GDP district-key compatibility have been supplied or documented before closing the workflow; preserve the source CAR predicate pending clarification.


## Remaining issues and prerequisites

- embedded_stata_not_driver [preparation; full_pipeline]: Substantial Stata preparation and analysis programs are embedded in BDS JAR 2020 Code.pdf rather than supplied as standalone do-files, and FILEPATH/RESULTSPATH/workdir are undefined. The ordered producer-consumer procedure is documented in a separate action; recover the sections as working-copy source files and configure roots before an attempt.
- input_contracts_incomplete [unresolved; full_pipeline]: Complete source review finds unresolved, absent input contracts across the active code: MABLE/QCEW and agency releases; politician roster/election/letter/PAC crosswalks; CRP contribution/candidate tables plus the separately read, unproduced cr1congos_indivs_contributors.dta input; six FASB issue files and distinct checked match workbooks; Farber adjusted options and manual company/PAC maps; WRDS/FR Y-9C, Compustat Bank and CRSP inputs plus bank identity/PAC links; four HMDA years, two BEA historical vintages, and political endorsement, CFscore, voting, CCES and bill-cosponsorship files. Bounded common-resource probes now verify readable Compustat Bank Quarterly and CRSP daily/index/link-table candidates, but do not establish full date coverage or the author-specific exports/links; retain the two exact producer gaps separately. The section-level producer-consumer sequence is now traced in the run-procedure action; remaining uncertainty is the named input route/schema and the specific mcl, total-assets and 108th-GDP key gaps below, not a blanket unknown workflow order.
- missing_mcl_producer [unresolved; full_pipeline]: The politician master drops mcl and then drops/uses comment-letter variables (lastname, firstname, accintcl, prevcl) without a visible producer in the supplied code document. A later merge from CONGRESS_MEMBER_SEC_COMMENT_LETTER_DATA creates mfasbsec and uses different fields, so it does not establish the earlier mcl/letter variables. Clarify the missing prior data stage and exact table/schema.
- stock_option_assets_source [unresolved; full_pipeline]: The stock-option Farber section filters GVKEY/fyear 2003 and saves a total-assets intermediate but the visible code has no input read before `keep gvkey fye at`; the source, period and relationship to PAC_MATCHING.XLSX are unknown. Resolve the actual `at`/fyear producer and key contract before treating this branch as closed.
- path_setup_and_bea_import [preparation; full_pipeline]: The code PDF does not define FILEPATH, RESULTSPATH or workdir. In addition, the September 2007 BEA sheet-2 import contains a literal `3$FILEPATH` prefix, and Table 5B writes under FILEPATH even though date folders are created under RESULTSPATH. The author program must be extracted and path setup/recovery checked in a working copy.
- district_gdp_108_key [unresolved; full_pipeline]: The 2001–2005 BEA/GDP producer maps MSAs to districtcd109 and the stock-option (108th Congress) branch merges that output using districtcd109. The intended compatibility with 108th Congress district identifiers is not documented; confirm this authored geographic key rather than translating it by assumption.
- car_comment_window [unresolved; full_pipeline]: The CAR section comment states an event-window date range that differs from the literal March 11–13, 2009 predicate. Other source text describes a three-day CAR centered on March 12, 2009. Preserve the actual supplied predicate pending confirmation of the intended window/comment.
- mable_geography [undetermined]: Four MABLE/Geocorr products are read or built as crosswalk inputs: MABLE_DATAFILE_MSA-CONG, MABLE_DATAFILE_COUNTY-CONG108, MABLE_DATAFILE_COUNTY-CONG109 and the county2002-congdis_alloc_2k CD108/CD109 files. They must map the source metro/county geography to the authored congressional vintage and preserve allocation/population and district codes used downstream. Exact raw schemas and compatible release vintages remain unverified.
- qcew_employment [undetermined]: BLS QCEW source bundle: area_titles.xlsx, industry_titles.xlsx, 2003.annual.singlefile.csv and 2008.annual.singlefile.csv. The code imports these, keeps area_fips, own_code, industry_code, agglvl_code, size_code, year, qtr and annual_avg_emplvl, filters private county aggregation levels, constructs total/nonagricultural/finance/high-tech employment and joins area/industry labels.
- politician_roster_covariates [undetermined]: Author-specific politician master inputs: CONGRESS_MEMBER_FILE, CONGRESS_MEMBER_TENURE_DATA, DW-NOMINATE_DATA and CONGRESS_MEMBER_CV_DATA. They supply member identity/tenure, ideology and career/business variables used to construct the master politician panels; merge keys/field mappings must match the code and must be checked across the 108th, 110th and 111th Congress branches.
- politician_election_inputs [undetermined]: Election and special-election inputs: cr1congmem_elec02.dta, cr1congmem_elec06.dta, cr1congmem_elec08.dta and CANDIDATES_SPEC_ELEC_DATA. These supply contest/candidate results and special-election records joined to member IDs/cycles in the politician master; raw field names, election-cycle coverage and the manual special-election construction are not verified.
- politician_sec_comment_inputs [undetermined]: CONGRESS_MEMBER_SEC_COMMENT_LETTER_DATA is a distinct supplied-code input for the later mfasbsec/letter-control merge. It does not supply the earlier mcl/lastname/firstname/accintcl/prevcl variables whose producer is absent; retain that gap as its own issue.
- politician_crp_match [undetermined]: The manually prepared CONGRESS_MEMBER_CRP_MATCH member-to-campaign/PAC crosswalk is read in multiple politician/FASB sections. Preserve its authored member IDs, cycle/recipient mapping and separate it from cr1congmem_osmatch.dta used in the stock-option branch.
- crp_candidate_pac_sources [undetermined]: CRP_PAC_DATA, CRP_OTHER_PAC_DATA, CRP_Categories and CRP_CANDIDATE_DATA are separate named candidate/committee/category input tables used to construct cycle-specific recipient/PAC and industry files. Their original vintage, schema, noncommercial-use terms and current route are unverified; historical author wording does not prove current license/access.
- crp_individual_committee_contributions [undetermined]: The FASB employee-affiliation route first reads the separate prepared cr1congos_indivs_contributors.dta file (no producer is visible in the supplied code), and later uses CRP_INDIV_DATA plus CRP_CMTES_DATA for individual/committee contribution totals. Keep all three source tables distinct; downstream matching uses contributor/recipient/committee IDs, cycle/date and employer/occupation fields as defined in code. Source editions, field compatibility and access remain unresolved.
- sifi_scap_pac_match [undetermined]: The author-specific CHICAGOFED_SIFI_SCAP_MATCH workbook/input links SIFI/SCAP bank identifiers and exposure classifications to PAC/recipient records for the fair-value robustness branch. Its manual matches and historical bank/PAC mapping are not packaged or independently verified.
- fasb_issue_letters [undetermined]: Six separate FASB issue spreadsheets are read by the supplied comment-letter preparation block, tagged by issue and appended into the author-prepared letter file. Preserve them as distinct source issues for the later contributor and PAC matching workflow, including the stock-option branch; the 1101/1102 issue identifiers do not establish Congress numbers. The workbooks are absent from the package.
- fasb_manual_match_workbooks [undetermined]: Keep the author’s distinct manual matching artifacts: cr1stop_fasbcl_empindiv_match_checkDND20180509.xlsx, FASB_PAC_MATCH_1CS.XLSX, FASB_PAC_MATCH_2TP.XLSX and FASBCL_PAC_MATCH_RELCL.XLSX. These are separate checked affiliation/individual-to-PAC and relative-comment-letter match inputs; they cannot be collapsed or regenerated from names without the authored decisions.
- farber_adjusted_option_data [undetermined]: FJP2007_Corrected Option Expense.csv is the coauthor-provided adjusted Compustat-items 398/399 dataset used in the 108th Congress analysis. Preserve this specific adjusted source and its firm/year/GVKEY variables; generic Compustat compensation fields are not a supported substitute.
- historical_company_names [undetermined]: wrds_raw_historicalcompanynames.dta supplies historical company names/GVKEY links used to map Farber firms before the PAC joins. The required name-history period, GVKEY/name fields and a matching WRDS export are not verified.
- farber_pac_match_workbooks [undetermined]: PAC_MATCHING.XLSX and the distinct PAC_MATCHING_REVISED.XLSX author workbooks provide manual Farber company-to-PAC matching/revision inputs for the 108th Congress analysis. Preserve their revisions and committee IDs; no compatible workbook is included.
- iesoc_company_pac_map [undetermined]: IESOCMembers_20032004_firms_PACs.dta is a separate hand-collected firm/PAC crosswalk for the 2003–2004 company association stage; its firm identity, PAC IDs and mapping coverage are not supplied or verified.
- stock_option_os_match [undetermined]: cr1congmem_osmatch.dta is a distinct politician-to-OpenSecrets/PAC match consumed by the stock-option branch. Do not equate it with CONGRESS_MEMBER_CRP_MATCH; exact coverage and identifier contract are unresolved.
- bhc_fr_y9c_panel [undetermined]: WRDS_BHC_DATA is the bank-holding-company panel input used to build quarterly bank accounting variables. The datasheet names FR Y-9C; quarterly RSSD/company identifiers, statement items and historical coverage needed by the code require verification. A bounded frozen-catalog search for Y9C, BHCK and BHC aliases found no catalog row; this is a discovery miss only, not evidence that the underlying data or a route are unavailable.
- compustat_bank_quarterly [undetermined]: WRDS_COMPUSTAT_BANK_DATA is the distinct Compustat Bank Fundamentals Quarterly source. The local COMPB.BANK_FUNDQ candidate contains the code-relevant quarterly fields; required 2006–2009 coverage, final update selection and the author-file mapping remain unverified. A Compustat annual or generic-company file is not interchangeable.
- crsp_bank_market_inputs [undetermined]: WRDS_CRSP_DATA is the CRSP market-data source used for bank stock returns/market controls and the CAR/beta computation; the code also consumes generated crsp_0107-1209rssdid.dta and cr2crsp_beta2008daily.dta. Required CRSP identifier, daily return/date and 2008/2009 event-estimation history must be matched to the supplied transformations.
- bank_identifier_and_pac_matches [undetermined]: TICKER_MATCH_FILE and CHICAGOFED_PAC_MATCH are separate authored ticker/RSSD/PERMCO and Chicago Fed bank-to-PAC linkage inputs. The datasheet describes a CRSP-FRB RSSD/PERMCO link; exact manual versions, key uniqueness and bank/PAC coverage are unverified.
- hmda_county_summaries [undetermined]: Four CFPB HMDA county summary CSV inputs are read for 2007, 2008, 2009 and 2010. They feed county-level lending totals and the congressional district aggregation; required county/geography codes and loan-summary columns must match each historical CSV layout.
- bea_gdp_releases [undetermined]: Two distinct BEA metro GDP/GMP workbooks are required: gdp_metro0907.xls (September 2007 vintage, used to build 2001–2005 district GDP) and gmp0911.xls (September 2011 vintage, used for 2007–2009). Preserve both release vintages, metro identifiers, year/value columns and MABLE allocation; code also has the `3$FILEPATH` path typo on sheet 2.
- organization_endorsement_inputs [undetermined]: Three separate author-named political-organization inputs are read: FREEDOMWORKSSCORE_DATA, TEAPARTYEXPRESS_ENDORSEMENT_DATA and CONGRESS_MEMBER_REPUBICAN_STUDY_COMMITTEE_DATA. They supply endorsement/membership indicators used in the fair-value robustness work; identity keys, timing and manual source provenance are not provided.
- dime_cfscore_inputs [undetermined]: The two prepared candidate_cfscores_st_fed_1979_2012_relids_cycle.dta and candidate_cfscores_st_fed_1979_2012_relids.dta inputs supply CFscore measures for separate election-cycle/member analyses. Preserve both authored versions, candidate identity and cycle/year mappings; neither file is packaged.
- voting_data [undetermined]: VOTING_DATA is a separately named input for member voting behavior in the fair-value analysis. The exact vote IDs/roll calls, Congress-cycle coverage and member-key mapping are not documented in a compatible supplied extract.
- cces_survey_data [undetermined]: CCES_ELECTION_SURVEY_DATA is a separate election-survey input used for an authored political-preference measure. Respondent/representative identifiers, survey wave and aggregation fields remain unverified.
- stock_option_cosponsorship [undetermined]: STOCK_OPTION_COSPONSORSHIP_DATA is the stock-option branch’s separate bill cosponsorship input; preserve its bill/member keys, sponsor/cosponsor roles and 108th Congress coverage used by the code. It is not in the supplied package.
- excel_manual [unverified]: The datasheet says Excel was used for hand collection; no local Excel runtime probe was supplied. Any required manual spreadsheet stage and its files remain to be resolved from the full workflow.
- stata_fs [preparation_required]: Stata 18 is available, but `which fs` returned 111. The embedded QCEW/FASB and BEA directory loops invoke `fs`; configure a compatible `fs` ado command in the author-run Stata environment before a run.

## Review notes

- The full 5,799-line embedded Stata document was reviewed. The producer-consumer sequence for MABLE/QCEW, politician and CRP masters, FASB and Farber preparation, bank/CRSP, HMDA/BEA, fair-value and stock-option branches is enumerated in a-run-workflow with named intermediate files and consumers. The frozen dependency checklist is empty, so dependency_review remains empty rather than inventing frozen IDs.
- Remaining specific workflow gaps are the missing earlier mcl/letter producer, the visible Farber 2003 total-assets block with no explicit input read, and compatibility of the 2001–2005 BEA producer key districtcd109 with the 108th stock-option consumer. Path configuration and the shown BEA/Table 5B path defects remain preparation tasks; the CAR comment/predicate conflict remains a separate specification clarification.
- The two packaged statement DTA probes establish readable files and matching columns for the actual fair-value and stock-option statement merges. They do not establish complete analysis panels, so no analysis_only scope is supported.
- No author data/code execution, author recontact, downloads, installs, source edits or broad external-file scans were performed. Other public/manual/vendor inputs remain route-unverified; historical CRP noncommercial wording does not establish a license conclusion. Readable common SAS candidates are recorded as local resources; their remaining questions concern required coverage, native field/export mapping and crosswalk construction.
- The one bounded common-catalog check found readable local candidates for Compustat Bank quarterly fundamentals (COMPB.BANK_FUNDQ), CRSP daily stock/index data (CRSP.DSF/DSI), and the Compustat/CRSP link-history table (CRSP.CCMXPF_LINKTABLE); each was probed for one row with metadataonly=false. The catalog’s 272,168-observation BANK_FUNDQ figure is a frozen metadata snapshot, not an observed total from the one-row probe. Full periods/populations and author-specific export, RSSD and Chicago Fed PAC construction remain unverified. No BHC/Y9C alias matched; that is a discovery miss only.
