# Patch proposal: jar-41d0de598b9f

It’s a Small World: The Importance of Social Connections with Auditors to Mutual Fund Managers’ Portfolio Decisions

DOI: 10.1111/1475-679X.12395

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete author-documented Stata workflow embedded in the DOCX, including data preparation, manual person/school links, annual and semiannual stages, and all Table 1–11 branches. The executable driver, compatible inputs and several producer/consumer handoffs remain unresolved.

Entry points: `Stata code.docx`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 3/12395 - Its-a-Small-World-The-Importance-of-Social-Connections-with-Auditors-to-Mutual-Fund-Managers-Portfolio-Decisio/chlp-datasheet-code-and-identifiers.zip",
      "sha256": "c99779d62441a9283ab6ebfa4ed66ab4ea47e1bc2dc42ce5e8c1058d3789f735"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "a31f4815679a8dcf43e26f0a190c97618f3a0735ebdde8d4c7523f7e6f17eac5"
}
```

## Proposed actions

### acquire_csmar_exports: Obtain the documented CSMAR source extracts or a compatible author-prepared input set for the annual and semiannual firm, fund, holdings, auditor, analyst, specialist-audit, return, forecast, visit and trading branches. Product IDs and complete field contracts are not specified for every alias in the DOCX, so confirm the exact source tables, periods and identifiers with the authors before ordering exports.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: analyst_forecasts_csmar, analyst_identities_csmar, analyst_school_updates_2017, audit_opinion_dates_csmar, close_prices_csmar, executive_education_csmar, firm_address_inputs_csmar, firm_analyst_auditor_csmar, firm_annual_returns_csmar, firm_auditor_identities_csmar, firm_balance_sheet_csmar, firm_daily_returns_csmar, firm_industry_csmar, firm_market_bm_csmar, firm_profit_csmar, firm_real_eps_csmar, firm_soe_csmar, firm_turnover_csmar, fund_balance_sheet_csmar, fund_company_links_csmar, fund_fee_age_csmar, fund_holdings_csmar, fund_index_csmar, fund_manager_characteristics_csmar, fund_manager_education_csmar_wind, fund_manager_experience_csmar, fund_net_assets_csmar, fund_net_profit_csmar, fund_qdii_equity_listed_csmar, fund_size_csmar, fund_type_csmar, institution_shareholding_csmar, monthly_shares_csmar, public_firm_audit_firms_csmar, related_party_transactions_csmar, semiannual_beta_csmar, semiannual_dividend_csmar, semiannual_eps_csmar, semiannual_returns_csmar, semiannual_sales_csmar, semiannual_volume_csmar, site_visit_csmar, specialist_audit_fees_csmar, specialist_auditor_csmar, specialist_firm_revenue_csmar, specialist_total_assets_csmar
Evidence: src_docx_return_volume_semi, src_docx_firm_address, src_docx_fund_fee_age, src_docx_specialist_revenue, src_docx_fund_control_tables, src_docx_firm_profit, src_docx_firm_analyst_auditor, src_docx_firm_industry, src_docx_site_visits, src_docx_fund_size, src_docx_manager_experience, src_docx_eps_semi, src_docx_beta_semi, src_docx_analyst_forecasts, src_docx_turnover, src_docx_firm_soe, src_docx_daily_returns, src_docx_fund_company, src_docx_specialist_audit_inputs, src_docx_close_price, src_docx_manager_education, src_datasheet_sources, src_docx_opinion_dates, src_docx_dividend_semi, src_docx_firm_balance, src_docx_institution_holdings, src_docx_firm_auditor, src_docx_analyst_list, src_docx_real_eps, src_docx_specialist_auditfee, src_docx_fund_type_index, src_docx_firm_returns, src_docx_holdings, src_datasheet_manual_reports, src_docx_sales_semi, src_docx_analyst_update, src_docx_analyst_update_manual, src_docx_firm_market, src_docx_manager_characteristics, src_docx_related_party, src_docx_executive_education, src_docx_management_education, src_docx_share_month, src_docx_firmauditfirm, catalog_frozen_snapshot, catalog_query_record, catalog_query_record_001

Preparation / proposed procedure:

1. Ask the authors to map each CSMAR alias named in the DOCX to its exact module/table, selected fields, units, identifier crosswalk, year-part files and report-period rules; include the 2002–2018 holdings inputs, 2004–2019 specialization/audit inputs, firm and fund controls, and the separate Table 7/8/10/11 inputs.
2. Acquire the permitted source extracts or request the authors' compatible prepared inputs; retain all specified year chunks and annual versus semiannual branches, and do not infer a China source from unrelated local catalog entries.
3. Build a source-to-working-file manifest for each extract and confirm that every field consumed by the embedded preparation blocks is present with matching types, units and stock/fund/year keys before generating intermediate files.

Validation to perform later:

- After authorized acquisition, reconcile each file's product, field names, identifiers, units, year coverage and annual/semiannual boundaries with the corresponding requirement and embedded transformation.
- Check intended key uniqueness and merge coverage at each documented join; keep the authors' filters, samples, outcomes and table branches unchanged.

### acquire_wind_exports: Obtain the documented WIND index-fund, mutual-fund raw/Jensen return, fund-company asset and audit-fee inputs or compatible author-prepared inputs. The DOCX's wide-year fields, fund/company keys and coverage need confirmation before mapping.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: fund_audit_fees_wind, fund_company_assets_wind, fund_jensen_returns_wind, fund_manager_education_csmar_wind, fund_raw_returns_wind, index_fund_wind
Evidence: src_docx_fund_type_index, src_docx_wind_fund_returns, src_docx_wind_fund_assets, src_docx_manager_education, src_datasheet_sources, src_docx_wind_fund_auditfee, catalog_frozen_snapshot, catalog_query_record, catalog_query_record_001

Preparation / proposed procedure:

1. Ask the authors to identify exact WIND source products, field definitions, units, company/fund code mappings and year coverage for index_wind, rawreturn, jensen, fundfirm_ta and fund_auditfee.
2. Acquire the permitted exports or compatible author-prepared files and retain the year-wide inputs and code-defined annual reshaping; preserve Table 9 returns and Table 10 fees as separate branches.
3. Resolve the separately named 2003 rawreturn_2003.dta and jensen_2003.dta seeds under the local-input action before appending them; do not infer their values from later-year series.

Validation to perform later:

- Check fund/company identifiers, units, year suffixes and complete author-required periods against each source block before reshaping or appending.
- Confirm the 2003 seed-file source and schema before appending; preserve the authors' annual return definitions and sample rules.

### request_profiles_reports_crosswalks: Request author-compatible profile, report and person-school crosswalk files plus exact source/access and matching documentation. The supplied datasheet and DOCX name CICPA, Caixin, websites/Baidu, annual reports, NERI and manual CV/report work but provide no packaged matching data or complete collection contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: analyst_education_caixin, analyst_school_updates_2017, annual_report_audit_office, annual_report_business_industry, cicpa_auditor_birthdates, cicpa_auditor_education, cicpa_auditor_major, cicpa_auditor_partner_status, executive_manual_cv_crosswalk, fund_auditor_manual_reports, fund_manager_education_csmar_wind, neri_marketization_index
Evidence: src_docx_cicpa_schools, src_datasheet_sources, src_docx_fund_auditor_reports, src_datasheet_manual_reports, src_docx_top174_manual, src_docx_cicpa_partner, src_docx_caixin_education, src_docx_analyst_list, src_docx_cicpa_birthdate, src_docx_annual_report_audit_office, src_docx_cicpa_major, src_docx_business_opacity, src_docx_mktlaw_index, src_docx_manager_education, src_docx_analyst_update, src_docx_analyst_update_manual, catalog_query_record_001

Preparation / proposed procedure:

1. Ask the authors for compatible manager, auditor, analyst and executive education crosswalks, including the manual CSMAR/WIND CV resolution, CICPA school/major/birthdate/partner fields, the 2,295-profile addition, and post-July-2017 Caixin/website/Baidu analyst updates.
2. Request the exact annual-report-derived fund auditor, audit-office/city, operating-industry, university-anniversary, C9/985, Big 10 and NERI files or documented source and collection rules; include person/entity-name normalization and stock/fund/year matching keys.
3. For each file, obtain the authors' expected population, fields, code mappings, coverage and handling of unresolved or duplicate identities. Treat public-profile access and any manual collection route as unverified until documented; do not substitute other people, schools, firms or sources.

Validation to perform later:

- Check author-supplied schemas and date/population coverage against the exact crosswalk fields used by the relevant full-pipeline branch.
- Review a documented key map and unresolved-match counts before joining profiles to holdings, analysts, auditors, executives or fund companies.

### clarify_local_file_contracts: Request the exact producer, source, schema, coverage and intended handoff for every named but unsupplied author-working-directory file. Preserve files created by supplied code as generated dependencies and resolve their order separately; do not silently classify them as missing raw inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: auditor_code_2016_2017, auditor_rotation_change_panel, big10_auditor_lookup, elite_university_lists, executive_manual_cv_crosswalk, firm_synchronicity_panel, firm_year_change_controls, fund_auditor_2017_records, fund_auditor_2018_records, fund_auditor_change_flags, fund_auditor_code_2017_records, fund_company_id_crosswalk, fund_fee_2017_input, public_firm_auditor_change_history, related_party_total_revenue, share_denominator_total_share, share_denominator_totalshare, university_anniversary_data, named_unproduced_inputs, workflow_closure_unresolved
Evidence: src_docx_site_visits, src_docx_fund_auditor_year_inputs, src_docx_top174_manual, src_datasheet_manual_reports, src_docx_fund_auditor_codes, src_docx_changecontrol, src_docx_elite_university_inputs, src_docx_synch, src_docx_totalshare_inputs, src_docx_totalshares_trading, src_docx_anniversary_input, src_docx_related_party, src_docx_big10_codes, src_docx_rotation_input, src_docx_firm_auditor_change_history, probe_workflow_trace

Preparation / proposed procedure:

1. Ask for compatible copies or contracts for the local files named in the trace, including firm_add.dta, fundcompany_add.dta, firmauditor_full.dta, auditor_code2016.dta, auditor_code2017.dta, big10code.dta, totalrevenue.dta, synch.dta, fundfirmcodenew.dta, total_share.dta, totalshare.dta, changeauditor.dta, fundfee2017.dta, auditor_2018.dta, change19902016.dta, change2017.dta and changecontrol.dta.
2. Request the source/schema for the two separately spelled total-share files, rawreturn_2003.dta and jensen_2003.dta, and the source, in-memory variables and change_cpa definition used to save auditorcpa_change5.dta.
3. For Table 10, ask which auditor2017.dta, auditorcode_2017.dta, fund_auditfee.dta, fundcontrol.dta, fund_cpa1.dta and fund_cpa2.dta files are intended to be pre-existing inputs versus later outputs, and obtain the exact execution order or author-supplied intermediate files.
4. Keep firmcpaschool.dta, fund_managercollege_full.dta, do_full_jar.dta, holding_jar.dta and holding_full_jar.dta as generated files where their producers are in the supplied document; resolve their consumer-before-producer order from the workflow trace rather than requesting them as independent raw data by default.

Validation to perform later:

- For each author-supplied file, record producer or source, fields, keys, units, coverage and whether it is a required prepared input or a generated intermediate.
- Before constructing the full driver, verify the resolved Table 5, Table 6, Table 7, Table 8, Table 10 and Table 11 handoffs against their source sections and do not merge the total_share and totalshare contracts without author evidence.

### extract_and_reflow_docx_program: Prepare a lossless working Stata source and separate line map from the 18,797-line cached text extracted from the original Stata code.docx (SHA-256 ba6f43747dc5e62f3d20cd8f71f37228196294240530fe2f7f78cebe406273a8; cached text SHA-256 30014342436b39cf8f85fcc48ef0f4492fdd52a09b95b4c3a483dd73feaffb12). The embedded program contains the actual preparation, manual matching, table and appendix branches; no .do file is supplied.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: workflow_closure_unresolved, generated_file_order_gaps
Evidence: probe_workflow_trace, src_docx_holdings, src_docx_rotation_input, src_docx_anniversary_input, src_docx_site_visits, src_docx_wind_fund_returns, src_docx_fund_auditor_reports, src_docx_changecontrol

Preparation / proposed procedure:

1. Extract/reflow the complete embedded Stata text into a working-copy .do source while retaining all 18,797 cached lines, every table/appendix branch, year chunk, manual matching block, macro, sample restriction, model and output statement; keep a line crosswalk to the original DOCX hash and cached-text line numbers.
2. Create a separate input/output manifest that marks each file as a supplied-code generated intermediate, an already-in-memory vendor extract, a manually prepared crosswalk, or an unresolved author input. Preserve annual and semiannual panels and all branches.
3. Build an ordered driver only after the author confirms inputs first saved from memory, producer/consumer order, and the named Table 10 handoffs; use a coherent relative project data root or documented host paths, not the Dropbox workspace path.

Validation to perform later:

- Compare the reflowed source and line map against the full cached text without running Stata; verify all table/appendix sections and every year loop/chunk remain present.
- Statically reconcile each generated filename to its actual producer and all consumers, including Table 10 producer-fed files, before adding driver calls.

### repair_table1_working_copy_basename: In the extracted working-copy Stata source, correct the Table 1 consumer basename using the source-mapped original DOCX/cached text (DOCX SHA-256 ba6f43747dc5e62f3d20cd8f71f37228196294240530fe2f7f78cebe406273a8; cached text SHA-256 30014342436b39cf8f85fcc48ef0f4492fdd52a09b95b4c3a483dd73feaffb12). This is a working-copy instruction only; the binary DOCX is not edited and no text edit record is attached to it.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: table1_filename_mismatch
Evidence: src_docx_table1_typo_consumer, src_docx_table1_producer_name, probe_workflow_trace

Preparation / proposed procedure:

1. At the extracted statement mapped to cached DOCX line 11509, replace only the filename token `do_bigsample.dta_jar` with `do_bigsample_jar.dta`, the basename saved at cached line 11465 and used by the other Table 1 references.
2. Retain the existing `use` options, filters, variables, sample and all other code exactly as supplied; do not edit or repackage the source DOCX.

Validation to perform later:

- Statically compare all references to the Table 1 big-sample output in the working copy and confirm they point to the producer basename `do_bigsample_jar.dta`.

### prepare_missing_stata_output_addons: Prepare the two Stata output commands used by the author blocks. The metadata checks found `outreg2` and `asdoc` absent in the checked adopath; other required commands listed in the assessment were available.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: outreg2, asdoc, missing_stata_output_commands
Evidence: src_docx_outreg2_command, src_docx_asdoc_command, probe_software_outreg2, probe_software_asdoc, probe_stata_environment

Preparation / proposed procedure:

1. In the future authorized Stata environment, install or provision `outreg2` and `asdoc` from an approved Stata package source into the intended adopath; record source, version and installed path for both.
2. Keep the author-specified calls and table output options unchanged; do not replace the commands with a different table exporter.

Validation to perform later:

- Confirm `which outreg2` and `which asdoc` resolve to the recorded paths before the future workflow run.
- During an authorized run with compatible inputs, confirm the Table 2/3 output files are created using the documented author calls.

### run_author_workflow_after_prerequisites: After the inputs, handoffs, source order and add-ons are supplied and prepared, run the complete author-documented Stata workflow in the confirmed stage order. Preserve every preparation branch, appendix, table, sample restriction, model and parameter. The present assessment did not run author code or study data.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: workflow_closure_unresolved, named_unproduced_inputs, generated_file_order_gaps, missing_stata_output_commands
Evidence: probe_workflow_trace, probe_stata_environment, src_docx_reghdfe_command, src_docx_outreg2_command, src_docx_asdoc_command

Preparation / proposed procedure:

1. Use the confirmed driver and relative data root; load each author-documented in-memory vendor extract and manually prepared input before its consuming stage, then follow the author-confirmed producer/consumer order for all saved intermediates.
2. Run the full annual holdings/control and person/auditor preparation, annual tie and analyst/sample stages, Table 4 semiannual/alternative branches, Table 5 rotation, Table 6 supplementary panels and Tables 7–11; retain all original years, chunks and branch-specific samples.
3. Use Stata 18 with the documented `winsor`, `expandcl`, `logout`, `xi: reghdfe`, `esttab`, `asdoc` and `outreg2` commands; retain the stated regression absorbs, clusters, output options and sample rules.

Validation to perform later:

- At each stage, record command/log status, input/output basenames, row/key counts and merge results, then compare the table/sample outputs with the source-documented table panels without changing specifications.
- Review every unresolved mismatch, omitted branch or empty output with the authors before claiming a complete reproduction; no assessment outcome itself establishes successful execution.


## Remaining issues and prerequisites

- workflow_closure_unresolved [unresolved; full_pipeline]: The DOCX embeds data preparation and analysis but no executable master driver. Its first stages save CSMAR/WIND extracts that are already in memory, and later branches depend on vendor tables and hand-built person-school crosswalks. Supplementary Table 5–11 inputs, semiannual/table-specific handoffs and all raw-data contracts remain under review; the package inventory contains an identifier list rather than a full analysis panel. The scanned DOCX also contains Table 5 rotation and Table 6 university, auditor, annual-report, related-party and private-information branches with additional named inputs. Table 7–11 and Table 8 trading paths add CSMAR/WIND return, forecast, visit, fund-auditor and public-firm audit inputs plus unproduced ID crosswalks and change-control panels.
- named_unproduced_inputs [unresolved; full_pipeline]: The source trace finds named files with no producer or source/schema contract in the supplied DOCX, including firmauditor_full.dta, auditor_code2016.dta, auditor_code2017.dta, big10code.dta, totalrevenue.dta, synch.dta, fundfirmcodenew.dta, total_share.dta, totalshare.dta, rawreturn_2003.dta, jensen_2003.dta, changeauditor.dta, fundfee2017.dta, auditor_2018.dta, change19902016.dta, change2017.dta, and changecontrol.dta. It also records firm_add.dta and fundcompany_add.dta without a producer, and auditorcpa_change5.dta saved from memory without the change_cpa input definition/source. These are unresolved contracts, not confirmed access barriers.
- generated_file_order_gaps [unresolved; full_pipeline]: The source map finds supplied producers for firmcpaschool.dta, fund_managercollege_full.dta, do_full_jar.dta, holding_jar.dta, and holding_full_jar.dta after their first consumers. Table 10 also reads several files before later save/producer sections. The documented blocks may depend on prior prepared files or a different stage order; intended handoffs must be confirmed before building the driver.
- table1_filename_mismatch [preparation; full_pipeline]: The Table 1 consumer at cached DOCX line 11509 names do_bigsample.dta_jar, while the supplied Table 1 producer at line 11465 and the other references use do_bigsample_jar.dta. This is a supported one-token working-copy correction; no edit is proposed against the binary DOCX.
- missing_stata_output_commands [preparation; full_pipeline]: The embedded Table 2/3 output blocks use asdoc and outreg2. The bounded metadata checks did not find either command in the checked Stata adopath, so the exact author commands need setup before these outputs can be attempted.
- fund_holdings_csmar [undetermined]: CSMAR fund-holding year-part extracts used to build annual and semiannual stock/fund holdings, including the fund and stock identifiers, report type, end date and holding proportion consumed downstream.
- firm_balance_sheet_csmar [undetermined]: CSMAR annual firm accounting inputs used to derive total assets, total debt, equity and leverage.
- firm_market_bm_csmar [undetermined]: CSMAR year-end firm market-value, book-to-market and industry fields used for size, BM and industry controls.
- firm_profit_csmar [undetermined]: CSMAR annual firm income statement input used to construct net income and ROA/ROE.
- firm_analyst_auditor_csmar [undetermined]: CSMAR firm analyst-attention and Big Four auditor fields used in annual firm controls.
- firm_soe_csmar [undetermined]: CSMAR firm ownership-nature observations used to create the SOE indicator.
- fund_fee_age_csmar [undetermined]: CSMAR fund age and management-fee observations used in fund controls.
- fund_size_csmar [undetermined]: CSMAR fund-size observations used in fund controls and lagged fund size.
- fund_company_links_csmar [undetermined]: CSMAR fund-company membership and company-address inputs used to construct fund-company controls.
- fund_type_csmar [undetermined]: CSMAR fund-type records used to distinguish fund categories in the analysis.
- index_fund_wind [undetermined]: WIND index-fund input used by the fund-control pipeline.
- fund_manager_experience_csmar [undetermined]: CSMAR fund-manager experience records used to attach names, resumes and manager-year histories to fund observations.
- fund_manager_education_csmar_wind [undetermined]: Author-prepared manager education records manually extracted from CSMAR/WIND CVs and used for manager-school ties.
- firm_auditor_identities_csmar [undetermined]: CSMAR listed-company auditor/signatory records used to create annual audit-firm and individual-auditor keys.
- cicpa_auditor_education [undetermined]: CICPA auditor education-profile records, including the manually searched additional 2,295 profile set, used to map signatories to universities.
- executive_education_csmar [undetermined]: CSMAR listed-firm executive and board-member CV/education inputs used for fund-manager-to-firm ties.
- analyst_identities_csmar [undetermined]: CSMAR firm-analyst records used to build the analyst-name by stock/year tie panel.
- analyst_education_caixin [undetermined]: Caixin analyst education profiles and the author-updated post-July-2017 analyst-school crosswalk used in analyst ties.
- firm_annual_returns_csmar [undetermined]: CSMAR annual firm return, market value, price and trading-volume fields used to build lagged returns and firm controls.
- firm_daily_returns_csmar [undetermined]: CSMAR daily stock-return chunks used to calculate annual return volatility.
- firm_turnover_csmar [undetermined]: CSMAR stock-turnover observations used to derive annual turnover controls.
- firm_address_inputs_csmar [undetermined]: CSMAR firm-place and firm-address tables used to construct normalized firm location and same-province ties.
- firm_industry_csmar [undetermined]: CSMAR firm-industry input used to construct industry controls and firm-industry identifiers.
- cicpa_auditor_major [undetermined]: CICPA auditor-major records used in the same-major auditor/manager tie measures.
- cicpa_auditor_birthdates [undetermined]: CICPA auditor birthdate records used to construct auditor birth years for age-cohort ties.
- fund_manager_characteristics_csmar [undetermined]: CSMAR manager records used for manager gender, education, tenure, career and fund-year histories.
- executive_manual_cv_crosswalk [undetermined]: Author-prepared school assignments from manual review of unresolved listed-firm executive CVs.
- analyst_school_updates_2017 [undetermined]: Post-July-2017 analyst identity and school updates used in the updated analyst-tie panel.
- auditor_rotation_change_panel [undetermined]: Auditor/partner change-year panel supplying stock_code, year and change_cpa for Table 5 event windows.
- university_anniversary_data [undetermined]: University founding/anniversary-year data used in the Table 6 anniversary interaction.
- elite_university_lists [undetermined]: Separate C9 and 985 university lists used to classify manager/auditor school connections in Table 6.
- specialist_total_assets_csmar [undetermined]: CSMAR firm total-assets observations used to weight audit-industry specialization.
- specialist_auditor_csmar [undetermined]: CSMAR auditor/engagement records for the 2004–2019 audit-specialization panel.
- specialist_firm_revenue_csmar [undetermined]: CSMAR firm revenue observations used with assets and audit engagements in specialization measures.
- specialist_audit_fees_csmar [undetermined]: CSMAR audit-fee observations used in the audit-specialization measures.
- cicpa_auditor_partner_status [undetermined]: CICPA auditor partner-status records used to classify signatory auditor partner roles.
- auditor_code_2016_2017 [undetermined]: Auditor-code observations for 2016 and 2017 used by Table 6 Panel F.
- big10_auditor_lookup [undetermined]: Big 10 audit-firm classification used to create non-Big-10 interactions in Table 6.
- annual_report_audit_office [undetermined]: Firm audit-office location records collected from annual reports for investor-protection analyses.
- neri_marketization_index [undetermined]: Provincial marketization/law index data from the cited NERI report, joined by audit province and year.
- annual_report_business_industry [undetermined]: Firm operating-industry records manually collected from annual reports for business-opacity measures.
- related_party_transactions_csmar [undetermined]: CSMAR related-party transaction observations used to build firm-year transaction concentration.
- related_party_total_revenue [undetermined]: Firm-year revenue fields from `totalrevenue.dta` used to scale related-party transaction amounts.
- firm_synchronicity_panel [undetermined]: Synchronicity input used in the Table 6 private-information analysis.
- site_visit_csmar [undetermined]: CSMAR corporate site-visit observations used for Table 7 visit measures.
- audit_opinion_dates_csmar [undetermined]: CSMAR audit-opinion date observations used to time corporate site visits.
- fund_company_id_crosswalk [undetermined]: Institution-name to fund-company-ID crosswalk used to link site visits to mutual-fund families.
- institution_shareholding_csmar [undetermined]: CSMAR institution shareholding data used for Table 7 fund-share controls.
- semiannual_beta_csmar [undetermined]: CSMAR semiannual beta observations used for lagged risk controls in Table 8.
- semiannual_sales_csmar [undetermined]: CSMAR sales observations used to construct semiannual growth changes.
- monthly_shares_csmar [undetermined]: CSMAR monthly share observations used to measure semiannual changes in shares outstanding.
- semiannual_eps_csmar [undetermined]: CSMAR EPS fields used to construct semiannual earnings-to-price controls.
- semiannual_dividend_csmar [undetermined]: CSMAR dividend fields used to construct semiannual dividend-to-price controls.
- semiannual_returns_csmar [undetermined]: CSMAR monthly firm returns used for lagged semiannual return controls.
- semiannual_volume_csmar [undetermined]: CSMAR monthly trading volume used for lagged volume-ratio controls.
- share_denominator_total_share [undetermined]: The `total_share.dta` share/volume input used in Table 8 volume controls.
- share_denominator_totalshare [undetermined]: The distinct `totalshare.dta` input used for Table 8 trading-share denominators.
- close_prices_csmar [undetermined]: CSMAR closing-price observations used to construct lagged close price for the Table 8 earnings-surprise model.
- analyst_forecasts_csmar [undetermined]: CSMAR analyst forecast EPS observations used in the Table 8 earnings-surprise model.
- firm_real_eps_csmar [undetermined]: CSMAR real EPS observations used to calculate earnings surprises.
- fund_raw_returns_wind [undetermined]: WIND mutual-fund raw return series used in Table 9 fund-performance tests.
- fund_jensen_returns_wind [undetermined]: WIND Jensen-return series used in Table 9 fund-performance tests.
- fund_company_assets_wind [undetermined]: WIND fund-company total assets used to construct fund-company size in Table 9.
- fund_auditor_manual_reports [undetermined]: Fund-level auditor and CPA-name data manually collected from mutual-fund annual reports.
- fund_audit_fees_wind [undetermined]: WIND fund-audit-fee observations used in Table 10 fee and auditor-choice models.
- fund_fee_2017_input [undetermined]: 2017 fund fee observations appended to WIND fund-audit-fee data in Table 10.
- fund_auditor_2017_records [undetermined]: 2017 fund-auditor observations used to build fund auditor identity and choice panels.
- fund_auditor_code_2017_records [undetermined]: Auditor-name to auditor-code mapping used in Table 10 fund-auditor panels.
- fund_auditor_2018_records [undetermined]: 2018 fund-auditor observations appended to the Table 10 fund-auditor panel.
- fund_auditor_change_flags [undetermined]: Fund-year auditor-change flags used to identify switching auditors in Table 10.
- fund_net_assets_csmar [undetermined]: CSMAR mutual-fund net assets used to construct fund total net assets in Table 10.
- fund_net_profit_csmar [undetermined]: CSMAR mutual-fund net-profit observations used in Table 10 controls.
- fund_balance_sheet_csmar [undetermined]: CSMAR mutual-fund assets/liabilities/equity observations used to construct Table 10 leverage.
- fund_qdii_equity_listed_csmar [undetermined]: CSMAR fund QDII, equity-category and listed-fund classifications used in Table 10 controls.
- fund_index_csmar [undetermined]: CSMAR fund index-fund status used in Table 10 fund controls.
- public_firm_audit_firms_csmar [undetermined]: CSMAR public-firm audit-firm and audit-unit observations used in Table 11.
- public_firm_auditor_change_history [undetermined]: Public-firm auditor-change histories used to create auditor-change/event panels for Table 11.
- firm_year_change_controls [undetermined]: Firm-year controls in `changecontrol.dta` used by all three Table 11 regressions.
- outreg2 [preparation_required]: The author workflow calls `outreg2`; the bounded command lookup did not find it in the checked Stata adopath.
- asdoc [preparation_required]: The author workflow calls `asdoc`; the bounded command lookup did not find it in the checked Stata adopath.

## Review notes

- Partial checkpoint now covers named source families through Table 11. Exact produced-stage order, unresolved intermediates, software, fixes and run/acquisition actions remain under review.
- The full cached DOCX was inspected as an embedded Stata program. The static parser's zero supported-code edges are a parser limitation, not evidence of no code. Catalog lookups are metadata-only discovery and do not establish license/access or source absence. The frozen environment evidence used here is limited to Stata and required Stata commands; no SAS fact is asserted.
- Process history only: probes/attempt_draft_stage_004_runner_failure.json (SHA-256 fa9837c1a51375e74337def21afae8445ef4a469341c139f50f88f03065d07f) records the outer failed runner/path attempt. The child command's separate streams/status were not saved, so they are not reconstructed or cited as evidence; the corrected runner completed and its preserved record is probes/draft_stage_004_tables_7_11_corrected_run.json.
- No author/study code, imports, data, models, statistical/descriptive calculations or syntax trials were executed. No downloads, installs, APIs, submissions, SAS startup/license/metadata checks or external source scans were performed. The catalog is the frozen workspace snapshot only; its misses do not establish licensing or source absence.
- Process history: finalizer attempt 001 returned schema validation error for duplicate evidence IDs in three action records. The exact controller stdout/stderr, status and input snapshot are preserved in probes/finalizer_001_pre.json, probes/finalizer_001_result.json and probes/finalizer_001.*.txt; action evidence arrays were deduplicated without changing evidence or readiness claims.
- Process history: finalizer attempt 002 rejected the available `stata_18` software record because its name `Stata 18` did not match the frozen environment probe's exact software-map key `Stata`. The exact input snapshot, controller streams, status and hashes are preserved in probes/finalizer_002_pre.json, probes/finalizer_002_result.json and probes/finalizer_002.*.txt; the record now uses the matching key while retaining the reported Stata 18 version.
