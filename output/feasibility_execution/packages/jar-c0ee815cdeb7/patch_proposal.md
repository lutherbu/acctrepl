# Patch proposal: jar-c0ee815cdeb7

Does U.S. immigration policy facilitate financial misconduct?

DOI: 10.1111/1475-679X.12627

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow, including firm-year construction, LCA and dependent/control/cross-sectional variable stages, final sample construction, and the supplied results program.

Entry points: `Code/P1_Firm Year Sample.do`, `Code/P2_Independent Variable of Interest.do`, `Code/P3_Main Dependent Variables.do`, `Code/P4_Whistleblowing Variables.do`, `Code/P5_Other Dependent Variables.do`, `Code/P6_Control Variables.do`, `Code/P7_Cross-sectional Variables.do`, `Code/P8_Merge Datasets to Construct Final Sample.do`, `Code/P9_Generate Results.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 5/12627 - Does-U-S-immigration-policy-facilitate-financial-misconduct/ddst-datasheet-code-identifier-and-log-files.zip",
      "sha256": "bbb6ce33892034484d5bffba30cc44a3cc37acbf821aa6091d6b8b796496302e"
    },
    {
      "path": "JAR-Volume 63/Issue 5/12627 - Does-U-S-immigration-policy-facilitate-financial-misconduct/ddst-online-appendix.pdf",
      "sha256": "664787d9a20c2ad7d7d023c44d9bc051440e5a9f2943645a880edca3ceea8339"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "082d56e71a752df41d943b99499dca68617e6011e1d4e2edeb4c1e51617a29dd"
}
```

## Proposed actions

### act_run_root_configuration: Set one stable author-project root before running the relative input/, output/ and log files/ paths. P1 currently defines an empty base macro and changes to it.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: iss_run_root_configuration
Evidence: ev_p1_root_configuration, ev_readme_whole_workflow

Preparation / proposed procedure:

1. Choose the project root that contains input/, output/ and log files/; create those directories before launching the supplied stages.
2. Set the author’s $base macro to that root in each stage that uses it and make the working directory consistent for relative file paths.
3. Point the SAS lc library to the authorized local source directory and configure table aliases for the P1 Compustat raw candidates consumed as Fundafull, Fundq, CompNames and Company; do not alias a guessed source for CompFn.
4. Use the separate handoff actions to stage P1 compvars, P3 restatement and P7 ShortTermInvestor at the paths their Stata consumers read.

Validation to perform later:

- Confirm each script opens its relative inputs and writes under the same selected project root; confirm logs resolve under log files/ before proceeding to data construction.

### act_sas_runtime_setup: Confirm the SAS runtime/version and required import/export components before any future authorized run. The registered environment evidence leaves SAS unverified; the package does not state an author SAS version.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_sas
Evidence: ev_environment

Preparation / proposed procedure:

1. Use the fixed environment inventory or SAS administrator to confirm the installed SAS version, license and support for the SAS procedures and Stata export method used by the package.
2. Confirm the SAS library/table configuration for the author’s `lc` reads and align its paths with the chosen project root; the CompFn source remains a separate unresolved data contract.
3. Do not run SAS or its autoexec during this assessment.

Validation to perform later:

- Before a future authorized run, document the confirmed SAS version/license and verify required procedures/export support through the approved environment inventory.

### act_stata_addons_setup: Resolve the nine Stata add-ons reported unavailable by bounded Stata 18 metadata checks. Their author-required versions and distribution sources are not established, so obtain those details before installing anything.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_carryforward, sw_quantiles, sw_addbefore, sw_geodist, sw_rangejoin, sw_winsor2, sw_astile, sw_outreg2, sw_sum2docx
Evidence: ev_sw_carryforward, ev_p2_carryforward, ev_sw_quantiles, ev_p5_quantiles, ev_sw_addbefore, ev_p7_addbefore, ev_sw_geodist, ev_p7_geodist_neighbor, ev_p7_geodist_hq, ev_sw_rangejoin, ev_p7_rangejoin, ev_sw_winsor2, ev_p8_winsor2, ev_sw_astile, ev_p8_astile, ev_sw_outreg2, ev_p9_outreg2, ev_sw_sum2docx, ev_p9_sum2docx

Preparation / proposed procedure:

1. Ask the authors for the expected versions/source locations of carryforward, quantiles, addbefore, geodist, rangejoin, winsor2, astile, outreg2 and sum2docx, or confirm compatible Stata 18 releases.
2. After a future installation is authorized, install into the Stata ado path used by the assigned account; no package was installed during this assessment.
3. Retain the already available Stata, reghdfe, ftools and winsor evidence without replacing those tools.

Validation to perform later:

- Use Stata’s `which` and version/help metadata checks after setup to confirm all nine command names resolve to the documented compatible versions before running P2/P5/P7/P8/P9.

### act_compfn_contract: Identify the exact CompFn source product and the sale_fn field contract required by P1. The bounded local search did not identify the named table, so no substitute is assumed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_compustat_footnote
Evidence: ev_p1_compfn_read

Preparation / proposed procedure:

1. Ask the authors or data custodian for the CompFn table/product name, permitted access route, sale_fn definition, key, and period used by P1.
2. If the source is supplied, compare its fields and identifiers with the P1 read and preserve the authors’ stated source/filter rules.

Validation to perform later:

- Confirm sale_fn is present with the documented type, keys and coverage before starting the P1 SAS branch.

### act_identifier_history_contract: Resolve the producer and construction contract for the separately consumed Identifiers_CompustataAnnual_1980_2023 panel. The local COMP.FUNDA table is a raw candidate, while the supplied workflow reads a prepared historical panel and does not write that exact input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_compustat_identifier_history, iss_identifier_history_producer
Evidence: ev_registered_catalog, ev_metadata_comp_funda, ev_p1_identifier_input, ev_p1_identifiers_panel_output, ev_p7_identifier_history_read

Preparation / proposed procedure:

1. Request the authors’ prepared identifier panel or the omitted producer program, including all source products, field definitions, filters, fiscal-year/duplicate-selection rules and history bounds.
2. Confirm the requested panel supplies gvkey, fiscal year, datadate, ticker, CIK, CUSIP and company name for the source-required 1980–2023 history; do not treat the separate final-sample GVKEY workbook as the panel.
3. Only if the authors confirm COMP.FUNDA is the intended source, prepare the panel under their original construction rules and stage it at input/Identifiers_CompustataAnnual_1980_2023.

Validation to perform later:

- Check required field names/types, fiscal-year and datadate coverage, duplicate resolution, and expected identifier keys against the authors’ specification before P1/P6/P7 consume it.

### act_p1_compvars_staging: Stage the complete P1 SAS lc.compvars product as input/compvars.dta before the Stata portion reads input/compvars. This is a cross-language format/path handoff; preserve the same gvkey-fyear product and all source-created fields.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: iss_compvars_format_handoff
Evidence: ev_p1_compvars_sas_write, ev_p1_compvars_stata_output

Preparation / proposed procedure:

1. Run the P1 SAS producer only after its required sources are authorized and configured.
2. Use a supported SAS-to-Stata export method (the package demonstrates PROC EXPORT with DBMS=STATA in its P7 SAS block) to write the same lc.compvars rows to the project input/compvars.dta path before the P1 Stata consumer runs.
3. Keep the Stata consumer’s documented cleaning and output/compvars.dta write unchanged.

Validation to perform later:

- Confirm the converted table retains gvkey and fyear keys plus all fields referenced by the Stata consumer, and that the input path resolves from the configured project root.

### act_industry_msa_contract: Confirm the exact prepared Industry_Classification and MSA tables, their construction or source mapping, and the required firm-year/geographic fields. The authors point to Notre Dame SRAF, but the public 10-X header product alone does not verify both author tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_industry_classification, req_notre_dame_msa
Evidence: ev_public_sraf_header, ev_p1_industry_input, ev_p1_msa_input

Preparation / proposed procedure:

1. Request the authors’ exact prepared input files or the original code/specification that creates them from Notre Dame SRAF and any other source.
2. Keep the two mappings distinct: Industry_Classification must provide gvkey/year with sic_num and ff12_sic_num; MSA must provide CIK/year with ba_state, ba_county, ba_city, ba_latitude, ba_longitude and msa_ba_fips_ND.
3. Stage the confirmed products at input/Industry_Classification and input/MSA without inferring missing fields from filing headers.

Validation to perform later:

- Check identifier keys, field names/types and required firm-year/geography coverage against the P1 merge statements before P1 consumes either table.

### act_lca_acquisition_contract: Acquire or obtain the author-prepared 2001–2009 LCA input, then confirm the DOL records and cleaning contract needed by P2. The official DOL page identifies historical OFLC disclosures where available but does not verify every required year or the author’s prepared file.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_lca_prepared
Evidence: ev_public_dol_lca, ev_p2_lca_construction_steps, ev_p2_lca_prepared_input

Preparation / proposed procedure:

1. Use the official Foreign Labor Certification Data Center route identified by DOL for the prior-year disclosure files where available, or request the authors’ prepared LCA_COMP_2001_2009.dta if the required historical files or schema cannot be confirmed.
2. Combine the authors’ specified fiscal-year files, retain unique certified applications with nonmissing case_no and job titles, and apply only the documented cleaning rules.
3. Retain the authors’ employer-name matching and match-review outputs; do not infer an independent matching rule.

Validation to perform later:

- Check that 2001–2009 coverage, application keys, status, job-title fields and employer identifiers match the authors’ expected prepared input before P2.

### act_jobtitle_crosswalk: Obtain the author-created JobTitle.dta crosswalk and its manual classification rules for the four job-title flags used by P2.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_lca_jobtitle_crosswalk
Evidence: ev_p2_jobtitle_input, ev_p2_jobtitle_manual_review

Preparation / proposed procedure:

1. Request the prepared JobTitle.dta, including job_title1 and Acct_JobTitle, Mgr_Acct_JobTitle, Egr_JobTitle and HR_JobTitle, plus the RA coding instructions or review log.
2. Stage the confirmed file at input/JobTitle.dta; preserve the supplied merge and keepusing behavior.

Validation to perform later:

- Check the four fields, job_title1 key uniqueness/merge behavior and documented classification values before running P2.

### act_lca_match_helper: Obtain the missing Python employer-name matching helper and its author-defined matching/review contract; the README documents its use but the package inventory contains no matching program.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss_lca_python_matching_helper
Evidence: ev_readme_lca_construction, ev_p2_lca_construction_steps, ev_package_inventory_summary

Preparation / proposed procedure:

1. Request the original Python matching program, runtime/library requirements, source-name fields, normalization/match criteria, tie-breaking and manual-review output.
2. If the authors instead supply a prepared LCA_COMP_2001_2009.dta and matching decisions, retain those as the primary input and document whether the Python helper is bypassed.

Validation to perform later:

- Confirm the program or prepared input produces the same LCA-to-Compustat identifiers and RA-reviewed matches described by the authors; do not invent or trial a matching model.

### act_audit_analytics_access: Obtain authorized access to the two distinct Audit Analytics products consumed by P3 and P7: AuditNonreliance and the SOX 302 internal-control-weakness input. No exact local catalog match or compatible public route was confirmed for either product.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_audit_restatements, req_audit_icw
Evidence: ev_registered_catalog, ev_p3_auditnonreliance_input, ev_datasheet_audit_restatement, ev_p7_audit_analytics_input, ev_datasheet_audit_icw_source

Preparation / proposed procedure:

1. Request the author-compatible AuditNonreliance product and field/key documentation for the P3 restatement-period construction.
2. Separately request the author-compatible SOX 302/internal-control-weakness product used as input/auditsox302.dta, including its identifier and year fields.
3. Use an authorized local subscription or obtain the authors’ prepared inputs; do not treat the two products as interchangeable.

Validation to perform later:

- Confirm each dataset’s required fields, identifier/date coverage and version against its distinct P3 or P7 consumer before staging.

### act_p3_restperiod_staging: Stage the complete P3 SAS lc.ResPeriod_M1 table as input/resperiod_m1.dta before the Stata consumer. Preserve the SAS-produced record fields; do not change restatement classification logic.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: iss_restperiod_format_handoff
Evidence: ev_p3_sas_restperiod_producer, ev_p3_stata_restperiod_consumer

Preparation / proposed procedure:

1. Run the P3 SAS producer after the AuditNonreliance and Compustat inputs are configured.
2. Export or convert that same ResPeriod_M1 product with a supported SAS-to-Stata method into the project input/resperiod_m1.dta path.
3. Then run the supplied P3 Stata segment, which creates output/restatement.dta.

Validation to perform later:

- Verify the converted fields used by P3 (gvkey, fyear and restatement classification fields) and confirm the staged file exists at the consumer’s relative path before the Stata step.

### act_whistleblower_inputs: Obtain the two distinct author-used whistleblower inputs: the media-mention workbook and the OSHA complaint workbook. The datasheet identifies different studies and dates for these products; their exact prepared workbook bytes are absent.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_wb_press, req_wb_osha
Evidence: ev_p4_wb_press_input, ev_datasheet_whistleblower_sources, ev_p4_wb_osha_input

Preparation / proposed procedure:

1. Request WB.xls Sheet1 (press/media mentions) with gvkey and eventdate and its author/source version.
2. Separately request WB Allegations.xlsx Sheet1 (OSHA allegations) with gvkey and date and its author/source version.
3. Stage each at the exact input filename and retain the supplied P4 construction code.

Validation to perform later:

- Check that each sheet has the expected key/date columns and the authors’ intended records before P4 creates WB.dta; keep the two sources separately identified.

### act_bea_state_income: Acquire the compatible annual state per-capita personal-income series from the verified official BEA SAINC1 route and prepare the P6 workbook sheet.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: req_bea_state_income
Evidence: ev_public_bea_state_income, ev_public_bea_sainc1, ev_p6_percap_income_input, ev_datasheet_bea_source

Preparation / proposed procedure:

1. Download the required state/year per-capita personal-income series from BEA SAINC1 using the official table/download route.
2. Prepare the Per capita personal income sheet in input/H1B_CS.xlsx in the layout expected by P6; retain BEA units and state/year labels.
3. Apply only the year/lag and state-name transformations already present in P6.

Validation to perform later:

- Verify the annual years, all needed state labels, per-capita values and units against the acquired BEA table before P6; confirm the sheet can be read by the supplied Stata import.

### act_ibes_analyst_contract: Obtain the exact SAS AnalystCoverage producer specification and any required IBES access; the sensitive source block was withheld before display, so the query, identifier mapping and date/count construction remain unknown.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_ibes_analyst_coverage, iss_analystcoverage_mapping
Evidence: ev_registered_catalog, ev_metadata_ibes_statsum, ev_p6_analyst_sas_header, ev_p6_analyst_consumer, ev_datasheet_ibes_source

Preparation / proposed procedure:

1. Request the unredacted producer code through an authorized channel or a complete author-prepared AnalystCoverage output, together with its source product and version.
2. Ask for the ticker-to-gvkey mapping, date/count fields, output key, period and any remote server/library configuration needed to create datadate, analyst_year and gvkey.
3. Treat local IBES.STATSUM_EPSUS as an unverified candidate only; its sampled TICKER, STATPERS and NUMEST fields do not establish the hidden producer mapping.

Validation to perform later:

- Confirm the producer or prepared output yields datadate, analyst_year and gvkey with the required period/keys before P6 transforms it; do not run or reconstruct the withheld query during this assessment.

### act_dyreng_file_contract: Obtain the exact Dyreng foreign-subsidiary input used by P6. The datasheet identifies the author page, but the bounded direct check redirected to sign-in and did not verify the prepared file or field definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_dyreng_subsidiaries
Evidence: ev_datasheet_dyreng_source, ev_p6_dyreng_input

Preparation / proposed procedure:

1. Request country31may2015.dta or the exact downloadable product and version from the authors, including CIK, fiscal year, foreign-subsidiary and country fields.
2. Stage only the author-confirmed product at input/country31may2015.dta; preserve P6’s China/India and lag rules.

Validation to perform later:

- Check the identifier/year fields, date coverage and subsidiary country coding against P6 before constructing Subsidiary_Dyreng.dta.

### act_city_crosswalk_contract: Obtain the author-created dependency_check.dta manual city/year crosswalk and its matching rules. The cited Kerr–Lincoln article supports the source citation, not the prepared firm-city crosswalk or complete field contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_dependency_city_crosswalk
Evidence: ev_public_kerr_lincoln_article, ev_datasheet_kerr_source, ev_p6_dependency_crosswalk

Preparation / proposed procedure:

1. Request the prepared city-year crosswalk and its source list, including the author’s top-city definition and Notre Dame headquarters-city matching rules.
2. Confirm the expected gvkey, xid, fyear and Dependent_ba_city_Census_Old fields and stage the confirmed file at input/dependency_check.dta.
3. Keep the manual headquarters match decisions with the delivered crosswalk.

Validation to perform later:

- Verify the documented keys, city coverage and dependency indicator coding against the P6 merge before running P6.

### act_coordinates_table: Obtain the exact US_Coordinates.dta table or author-specified coordinate source and construction. No compatible local/public route was verified for the state/city coordinate input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_us_coordinates
Evidence: ev_p7_coordinates_and_focal

Preparation / proposed procedure:

1. Request the author-prepared coordinate table or its source/version and matching rules, including state_id, city, lat and lng.
2. Stage it at input/US_Coordinates.dta; do not independently geocode or change the author’s state/city identifiers.

Validation to perform later:

- Check coordinate fields, state/city key behavior, coordinate units and required city coverage against P7 before forming focal/neighbor pairs.

### act_noncompete_index: Obtain the author-used state NonCompIdx table or confirm the compatible Aobdia index release and exact start/end-year fields. The article page supports the index concept but no downloadable compatible table was verified.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_noncompete_index_raw
Evidence: ev_public_aobdia_article, ev_datasheet_aobdia_source, ev_p7_noncompete_input_output

Preparation / proposed procedure:

1. Request the prepared input/NonCompIdx data or the author-specified Aobdia data release and acquisition instructions.
2. Confirm state, index, start and end columns, effective-year coding, release/version and any author corrections before staging input/NonCompIdx.
3. Retain the source-defined RI end-year adjustment and P7 range-join logic.

Validation to perform later:

- Check state keys, year bounds and index values are compatible with P7’s construction before producing output/NonCompeteIndex.dta.

### act_dhs_pr_contract: Confirm the author-used DHS permanent-resident PR series and its input sheet contract. The datasheet names a DHS LPR County page, but the bounded static check did not establish the exact PR product, years or state/year fields.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_dhs_permanent_residents
Evidence: ev_datasheet_dhs_source, ev_p7_pr_input

Preparation / proposed procedure:

1. Request the exact DHS product or author-prepared PR sheet, including definitions, geographic level, year span and state/year field names.
2. If the author confirms a public DHS product, acquire it through that official route and stage the PR sheet separately from the BEA income sheet in input/H1B_CS.xlsx.
3. Preserve P7’s stated PR ratio and pre-period construction.

Validation to perform later:

- Confirm PR and total-resident fields are compatible with the source-defined state-year calculation and cover all years consumed by P7 before running that branch.

### act_13f_products: Obtain the two separate Thomson Reuters 13F inputs required by P7: InstitutionHold_1980_2018 holdings and ThomsonReuters13F_Summary_1980-2019 with shrout. P7 joins them to create DKT.dta; neither raw input can replace the other. The local TFN.S34 candidate read timed out and remains unverified.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_13f_institution_holdings, req_13f_summary
Evidence: ev_registered_catalog, ev_p7_thomson_holdings_input, ev_datasheet_thomson_13f, ev_p7_thomson_summary_input

Preparation / proposed procedure:

1. Use the authors’ authorized Thomson Reuters 13F/WRDS access route or request the exact prepared holdings and summary tables from the authors.
2. Confirm separate schemas: holdings manager/CUSIP/report-date/shares fields used by the short-term measure; summary CUSIP/report-date/shrout fields used in the join.
3. Stage the two distinct products at their exact input filenames; allow P7 to generate output/DKT.dta using the supplied join and measure construction.

Validation to perform later:

- Check each table’s own key fields and required history (named holdings 1980–2018; summary 1980–2019) against the source before P7; do not infer population coverage from the timed-out one-row probe.

### act_ccma_link_contract: Resolve the exact annual Compustat–CRSP link input consumed by the P7 SAS/Stata short-term-investor branch. The local CCMXPF_LINKTABLE candidate lacks ncusip and datadate in its selected schema, so it is not yet a compatible substitute for CCMA_NCUSIP_Link.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_ccma_ncusip_link
Evidence: ev_registered_catalog, ev_p7_shortterm_sas_handoff, ev_p7_ccma_link_and_weak_relation_output

Preparation / proposed procedure:

1. Request the author-prepared CCMA_NCUSIP_Link.dta or exact authorized Compustat–CRSP source/version and author construction filters.
2. Confirm it supplies gvkey, ncusip and datadate at the annual link level expected by the SAS join.
3. Stage the confirmed same product under the P7 project input path; do not infer missing variables from the current catalog candidate.

Validation to perform later:

- Check key fields, link-date behavior and coverage against the P7 SAS consumer before calculating ShortTermInvestor.

### act_p7_shortterm_staging: Align the P7 SAS-created ShortTermInvestor product with its Stata consumer by staging the same exported dataset at output/ShortTermInvestor.dta under the configured project root.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: iss_shortterminvestor_path_handoff
Evidence: ev_p7_shortterm_sas_handoff, ev_p7_shortterm_pre_output

Preparation / proposed procedure:

1. After P7 has produced output/DKT.dta from the distinct InstitutionHold and ThomsonReuters13F_Summary inputs, and the required CCMA_NCUSIP_Link input is staged, run the supplied SAS block with its DKT and link inputs pointing to the configured project tree.
2. Export ShortTermInvestor.dta to the project output/ directory, or copy that exact exported product there if the SAS export destination remains separately configured.
3. Do not replace the 13F holdings, summary or CCMA products with one another; this step only aligns the SAS output path with the Stata read.

Validation to perform later:

- Before the P7 Stata consumer, confirm the staged dataset has the keys and downstream fields gvkey, datadate, ihsht_dkt and shrout_cda and is the same product exported by the SAS branch.

### act_russell_files: Obtain both distinct Russell reconstitution inputs required by P7, including their source/release, dates and field layouts. No compatible local route was confirmed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_russell2000_constituents, req_russell1000_2000_recon
Evidence: ev_p7_russell_inputs_and_outputs

Preparation / proposed procedure:

1. Request input/Russell 2000.csv with its asofdate, cusip and indexshortname fields and the source-defined dated constituent records.
2. Separately request input/Russell 1000-2000 Recon.csv with the corresponding reconstitution fields and the source definition of the indexshortname values.
3. Stage each at its distinct P7 filename and retain the supplied date conversion, CUSIP truncation and MoveIn construction.

Validation to perform later:

- Confirm each input has the required dated records, valid date strings and CUSIP/index fields before P7 derives RU1000, RU2000, RU3000 and MoveIn outputs.

### act_hq_manual_review: Obtain the author-reviewed headquarters-coordinate file or the manual review criteria and decisions required between output/location_hq.dta and output/location_hq_check.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_hq_coordinate_manual_review
Evidence: ev_p7_manual_location_review, ev_p7_manual_check_name_conflict, ev_package_inventory_summary

Preparation / proposed procedure:

1. Request the checked location_hq_check.dta or the author’s review checklist and treatment of unmatched/invalid coordinates.
2. If the authors direct reviewers to repeat the check, retain a review log and save the checked product at output/location_hq_check.dta before P7 consumes it.

Validation to perform later:

- Confirm the checked file has the same gvkey/year and coordinate fields expected downstream and records the author-defined corrections.

### act_working_city_manual_review: Resolve the P7 work-city manual-check filename conflict and obtain the intended reviewed working-city coordinate artifact or review procedure. The source writes h1b_working.dta, its comment names location_hq_check.dta, and the following consumer reads h1b_working_check.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_h1b_working_coordinate_manual_review, iss_working_coordinate_filename
Evidence: ev_p7_lca_working_coordinates, ev_p7_manual_check_name_conflict, ev_package_inventory_summary

Preparation / proposed procedure:

1. Ask the authors which checked file belongs to the h1b_working.dta review and whether the intended consumed filename is h1b_working_check.dta.
2. Request the checked artifact or the precise manual-review rules and reviewer corrections; keep it separate from the headquarters-coordinate check file.
3. Only after confirmation, stage that same reviewed work-city product at the path read by the next P7 statement.

Validation to perform later:

- Confirm the chosen checked file has the expected firm-year/work-city coordinates and that the producer, review artifact and consumer filenames align before P7 runs.

### act_kld_history_staging: Use the verified local KLD.HISTORY product and stage input/KLD_MSCI.dta by mapping its native CUSIP, Ticker, year, EMP_con_num and EMP_str_num fields to P7 target names cusip, ticker, year, emp_con_num and emp_str_num. Stata variable names are case-sensitive; P7 expects those lowercase names at the input boundary and then renames cusip to ncusip, derives dates and relation flags, and writes output/KLD_MSCI.dta. This is a known staging conversion; the bounded header probe does not establish complete 2001-2019 history, which remains a later validation task.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: req_kld_msci_employee_relations
Evidence: ev_registered_catalog, ev_metadata_kld_history, ev_p7_kld_msci_input_output, ev_datasheet_msci_source

Preparation / proposed procedure:

1. Convert the local KLD Historical Data product to the Stata input format at input/KLD_MSCI.dta, mapping native CUSIP to cusip, Ticker to ticker, year to year, EMP_con_num to emp_con_num, and EMP_str_num to emp_str_num without filtering or changing values.
2. Run the supplied P7 normalization only after other prerequisites are met; it expects the lowercase input fields, then renames cusip to ncusip, pads ncusip, makes year/date fields, and produces output/KLD_MSCI.dta.
3. Preserve the supplied employee-relation matching and pre-period logic; do not infer unobserved history from the one-row probe.

Validation to perform later:

- Confirm the staged schema uses exactly cusip, ticker, year, emp_con_num and emp_str_num before P7; check required 2001-2019 history during a later authorized run, treating unsampled endpoints as a coverage limit rather than evidence that the local route is absent.

### act_dependency_closure_preflight: Keep full-pipeline closure unresolved until each mandatory source read, manual stage and generated intermediate has a supported route and a producer/consumer path. The trace accounts for all 52 frozen parser edges plus source-visible SAS, manual and cross-language dependencies, but unresolved requirements remain.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss_dependency_closure
Evidence: ev_package_inventory_summary, ev_readme_whole_workflow, ev_p1_compustat_input, ev_p7_identifier_history_read, ev_p8_final_run_panel_write, ev_p9_run_panel_input

Preparation / proposed procedure:

1. Resolve each named input/producer request and manual review action before execution, including the 1980–2023 identifier panel, the exact P6 AnalystCoverage producer contract, distinct public/commercial sources and coordinate-review files.
2. Confirm generated P1–P7 outputs exist with the consumed names and fields before P8; do not consume any intermediate before its producer.
3. Reconcile the actual P1–P9 source reads against the registered requirement list and dependency review; treat the masked AnalystCoverage mapping and any unverified history/schema as open questions.

Validation to perform later:

- Close this issue only after every mandatory input is either compatible/available or explicitly access-approved, all generated edges have ordered producers, and the manual file names/contracts are confirmed.


## Remaining issues and prerequisites

- iss_identifier_history_producer [unresolved; full_pipeline]: P1 and P6/P7 consume input/Identifiers_CompustataAnnual_1980_2023, but no supplied P1-P9 stage writes that exact 1980-2023 panel. COMP.FUNDA is a matching raw annual candidate, while the prepared-panel creation/coverage contract remains unverified.
- iss_compvars_format_handoff [preparation; full_pipeline]: P1's SAS stage creates lc.compvars, and its Stata stage reads input/compvars then writes output/compvars.dta; no explicit export/copy or DTA conversion is shown between the languages. Align the same keyed product and path before the Stata stage.
- iss_restperiod_format_handoff [preparation; full_pipeline]: P3's SAS stage creates lc.ResPeriod_M1, and its Stata stage reads input/resperiod_m1.dta; the supplied source does not show the SAS-to-Stata export/path step.
- iss_shortterminvestor_path_handoff [preparation; full_pipeline]: P7 constructs and prepares a joined ih table in its SAS block, then the Stata stage reads output/ShortTermInvestor.dta. The exact producer-to-consumer path cannot be confirmed from the current safe source view, so keep this handoff unresolved and confirm or stage the product at the consumer path; this does not establish an absent producer or a separate raw-data need.
- iss_analystcoverage_mapping [unresolved; full_pipeline]: P6 identifies a SAS AnalystCoverage producer, but the connection-sensitive block is withheld before display. The Stata consumer needs datadate, analyst_year and gvkey, and the datasheet names IBES; the exact query, identifier mapping, date/count construction and output contract cannot be verified from safe lines.
- iss_working_coordinate_filename [unresolved; full_pipeline]: P7 saves h1b_working.dta, but the manual-review comment says the checked file is location_hq_check.dta, while the subsequent Stata statement reads h1b_working_check.dta. Confirm the intended checked work-city file and provide the reviewed artifact/rules.
- iss_lca_python_matching_helper [unresolved; full_pipeline]: The README says Python matches LCA employer names to Compustat and RAs manually inspect matches; the package inventory includes no matching program or prepared LCA/JobTitle input. Obtain the matching script or exact mapping protocol and retained review output.
- iss_run_root_configuration [preparation; full_pipeline]: The supplied stages use relative input/, output/ and log files/ paths. P1 sets the project base to an empty string and changes to that value, so the run procedure must establish a consistent working root and SAS library location before invoking the stages.
- iss_dependency_closure [unresolved; full_pipeline]: The 52 frozen parser edges are individually reviewed, but full workflow closure remains unresolved because the 1980-2023 identifier panel has no supplied producer, P6's AnalystCoverage producer contract is hidden, and a P7 manual work-city file name conflicts with the consumed path. Additional named inputs and manual reviews also require author/source confirmation.
- req_compustat_footnote [undetermined]: Compustat footnote source named CompFn, supplying sale_fn used to construct P6 merger indicators. The exact field/table did not appear in bounded catalog queries, and the package does not include the source table.
- req_compustat_identifier_history [undetermined]: The separately consumed input/Identifiers_CompustataAnnual_1980_2023 firm-identifier panel, including gvkey, fiscal year, datadate, ticker, CIK, CUSIP and company name across the named 1980-2023 history. The supplied P1-P9 workflow reads this prepared panel but does not produce it.
- req_lca_prepared [undetermined]: The 2001-2009 firm-year LCA file consumed as input/LCA_COMP_2001_2009.dta, prepared from Department of Labor LCA records with cleaning, Compustat employer matching, and manual review of the matches.
- req_lca_jobtitle_crosswalk [undetermined]: The input/JobTitle.dta crosswalk consumed with LCA records, containing job_title1 and the accounting, managerial-accounting, engineering, and HR classifications used in variable construction; the authors say RAs manually assign these flags.
- req_industry_classification [undetermined]: The input/Industry_Classification firm-year mapping used to add sic_num and ff12_sic_num to the Compustat panel.
- req_notre_dame_msa [undetermined]: The input/MSA firm-year headquarters/geography mapping merged by cik and year, including state, county, city, latitude, longitude and msa_ba_fips_ND.
- req_audit_restatements [undetermined]: The Audit Analytics AuditNonreliance input used by P3 to link restatement cases to Compustat firms and construct restatement-period outcomes.
- req_audit_icw [undetermined]: The distinct input/auditsox302.dta internal-control-weakness dataset used by P7 to construct Low_WB_ICW302.
- req_wb_press [undetermined]: The separate input/WB.xls Sheet1 media-mention table used to create WB_Press, keyed by gvkey and eventdate.
- req_wb_osha [undetermined]: The distinct input/WB Allegations.xlsx Sheet1 OSHA whistleblower-allegation table used to create WB_OSHA, keyed by gvkey and date.
- req_bea_state_income [public_acquisition_required]: Annual state-level per-capita personal income from the Per capita personal income sheet of input/H1B_CS.xlsx, reshaped into state-year values and lagged for P8.
- req_dhs_permanent_residents [undetermined]: The distinct PR sheet in input/H1B_CS.xlsx, a state-year permanent-resident series used by P7 to form Pct_PR and the pre-period treatment measure. The exact year span and source-sheet field definitions remain unverified.
- req_ibes_analyst_coverage [undetermined]: The AnalystCoverage product created by the P6 SAS block from I/B/E/S and consumed in Stata with datadate, analyst_year and gvkey.
- req_dyreng_subsidiaries [undetermined]: The input/country31may2015.dta foreign-subsidiary observations used by P6 to construct lagged China/India subsidiary status by CIK and fiscal year. Its exact source fields and history bounds are not verified.
- req_dependency_city_crosswalk [undetermined]: The manually constructed input/dependency_check.dta city-year firm crosswalk based on Kerr and Lincoln's top-15 H-1B-dependent cities and Notre Dame headquarters-city matching; the Stata consumer requires gvkey, xid, fyear and Dependent_ba_city_Census_Old.
- req_us_coordinates [undetermined]: The input/US_Coordinates.dta state/city coordinate table with state_id, city, latitude and longitude used for employer-working-city and firm-neighbor distances.
- req_noncompete_index_raw [undetermined]: The separate input/NonCompIdx state-level non-compete index table, with index and effective-year bounds, used to build gvkey-year exposures.
- req_13f_institution_holdings [undetermined]: The separate input/InstitutionHold_1980_2018.dta Thomson Reuters 13F holdings table used by P7 to construct short-term institutional holdings, with manager/CUSIP/date/share fields and 1980-2018 history.
- req_13f_summary [undetermined]: The distinct input/ThomsonReuters13F_Summary_1980-2019.dta table joined to holdings and used for shrout; it is not interchangeable with the holdings table.
- req_ccma_ncusip_link [undetermined]: The input/CCMA_NCUSIP_Link.dta annual Compustat-CRSP link table used by P7's SAS and Stata branches, requiring gvkey, ncusip and datadate to construct investor and employee-relation merges.
- req_russell2000_constituents [undetermined]: The separate input/Russell 2000.csv dated constituent/reconstitution records used to form the RU2000 list.
- req_russell1000_2000_recon [undetermined]: The separate input/Russell 1000-2000 Recon.csv dated reconstitution records used with RU2000 to form RU1000/RU3000 and MoveIn.
- req_hq_coordinate_manual_review [undetermined]: The manually checked output/location_hq_check.dta coordinate review file created from P7's initial headquarters-location coordinate product before distance construction.
- req_h1b_working_coordinate_manual_review [undetermined]: The manually checked output/h1b_working_check.dta working-city coordinate product read by P7 for headquarters-to-worksite distances; the preceding comment names a different checked file.
- sw_sas [unverified]: The supplied P1, P3, P6 and P7 workflows contain SAS stages. The registered environment probe status is unverified; no SAS process was started in this assessment, and the author version is not specified in the package.
- sw_carryforward [preparation_required]: The Stata 18 command metadata probe reports carryforward unavailable; P2 and P7 invoke it to propagate constructed values.
- sw_quantiles [preparation_required]: The Stata 18 command metadata probe reports quantiles unavailable; P5 invokes quantiles for the discretionary-accrual construction.
- sw_addbefore [preparation_required]: The Stata 18 command metadata probe reports addbefore unavailable; P7 invokes it to pad CUSIP identifiers.
- sw_geodist [preparation_required]: The Stata 18 command metadata probe reports geodist unavailable; P7 invokes it for the 50-mile firm-neighbor and headquarters-to-working-city distances.
- sw_rangejoin [preparation_required]: The Stata 18 command metadata probe reports rangejoin unavailable; P7 invokes it for date- and range-based joins.
- sw_winsor2 [preparation_required]: The Stata 18 command metadata probe reports winsor2 unavailable; P8 invokes it to winsorize final-sample variables.
- sw_astile [preparation_required]: The Stata 18 command metadata probe reports astile unavailable; P8 invokes it to construct sample-group indicators.
- sw_outreg2 [preparation_required]: The Stata 18 command metadata probe reports outreg2 unavailable; P9 invokes it to export regression tables.
- sw_sum2docx [preparation_required]: The Stata 18 command metadata probe reports sum2docx unavailable; P9 invokes it to export descriptive statistics.

## Review notes

- P7 KLD staging maps native CUSIP, Ticker, year, EMP_con_num and EMP_str_num to the lowercase target names expected by its current Stata consumer. The local KLD route remains available; the one-row header probe does not establish full 2001-2019 history.
- A prior bounded TFN.S34 metadata read timed out. The local 13F candidate remains unverified; the timeout does not establish absence or a licensing/access barrier, and its failure artifact is not cited as scientific evidence.
- The current approved P7 view does not establish the exact short-term producer path; D0033 remains an unresolved handoff without implying an absent producer or separate raw input.
