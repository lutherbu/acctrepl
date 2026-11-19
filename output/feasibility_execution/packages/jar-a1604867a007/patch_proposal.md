# Patch proposal: jar-a1604867a007

Do Jobseekers Value Diversity Information? Evidence from a Field Experiment and Human Capital Disclosures

DOI: 10.1111/1475-679X.12474

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Author-documented field experiment, follow-up survey, human-capital-disclosure and archival workflow, including described manual construction and companion Figure 3 analysis.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 3/12474 - Do-Jobseekers-Value-Diversity-Information-Evidence-from-a-Field-Experiment-and-Human-Capital-Disclosures/cprt-datasheet-step-by-step-description-identifiers.zip",
      "sha256": "0f6a4e2a482767a72a4228efbc7bd99a67cb5a98c0dab665b1d76ff5512b0c42"
    },
    {
      "path": "JAR-Volume 61/Issue 3/12474 - Do-Jobseekers-Value-Diversity-Information-Evidence-from-a-Field-Experiment-and-Human-Capital-Disclosures/cprt-internet-appendix.pdf",
      "sha256": "89c72cf7b53c51717229f8551448554332e8751a0c8ef14ceb5068b5a2c6770c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "d5709b43928eeb3af56cd855334dcd9efd62f6491e0d4ab0b327a34b389b4eef"
}
```

## Proposed actions

### obtain_historical_zippia_bundle: Establish an authorized route to the authors' historical anonymized Zippia experiment bundle and its file-level schema; this is needed for the experimental profiles, engagement, company, click, ratings, and recommended-company analyses.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: zippia_experiment_inputs, empirical_inputs_missing, workflow_closure_unresolved
Evidence: ev_zippia_history, ev_zippia_confidential, ev_main_user_profile, ev_profile_attributes, ev_email_metrics, ev_company_and_click, ev_recommended_company_sample, ev_package_inventory

Preparation / proposed procedure:

1. Use only the permitted author or institutional route for the already-collected, anonymized June–August 2021 observations, subject to the stated confidentiality terms; do not recollect observations or query participants, employers, jobs, or accounts.
2. Confirm the presence, date range, keys, and column definitions of userProfile.csv, userProfile_gender.csv, userProfile_preferredLevel.csv, userProfile_locations.csv, userProfile_ethnicityDistribution.csv, userProfile_emailsSent.csv, userProfile_emailsOpened.csv, userProfile_emailsClicked.csv, companyDataResults.csv, and userProfile_companyRatings.csv.
3. Map each supplied file to its documented producer and consumer before building the profile, engagement, clicked-company, and recommended-company intermediates; keep unknown mappings unresolved rather than infer them from filenames.

Validation to perform later:

- Confirm authorized custody and compatibility with the documented June–August 2021 experiment, then record schemas and join-key coverage without exposing participant-level content.

### obtain_historical_survey_workbook: Locate the historical FormattedSurveyResponses.xlsx workbook for the independent Table 7 response-count and percentage summaries.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: followup_survey_responses, empirical_inputs_missing, workflow_closure_unresolved
Evidence: ev_survey, ev_survey_history, ev_appendix_visual, ev_package_inventory

Preparation / proposed procedure:

1. Obtain the existing December 9–20, 2021 response workbook through a permitted author-prepared route; do not recreate the survey, contact participants, or query the historical Qualtrics account.
2. Use the appendix instrument, including its Q1-dependent Q2 branch, to map workbook response fields to the relevant sample denominators and Panels A–C; retain the authors' response-count and percentage definitions.

Validation to perform later:

- Confirm that the workbook contains the historical survey responses and that its question/branch fields support the reported Table 7 summaries before producing them.

### verify_fy2020_hcd_filing_coverage_and_code: Verify an authorized local or public route for the authors' complete FY2020 10-K sample and prepare the manual HCD classifications and subsection texts using the supplied rules.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: hcd_fy2020_10k_text, empirical_inputs_missing, workflow_closure_unresolved, table8_model_specification_unresolved
Evidence: ev_hcd, ev_hcd_classification, ev_hcd_merges, ev_table8_definition, ev_table8_classification, ev_table8_regression_scope, ev_sec_raw_root, ev_sec_parsed_root, ev_lm10x_2020, ev_lm10x_2021, ev_sec_edgar_page, ev_identifier_probe

Preparation / proposed procedure:

1. Check coverage for all FY2020 10-K filings available by the end of March 2021, including filing dates and HCD sentences, tables, and figures; compare candidate local parsed/LM sources or public EDGAR access with the author's period and content needs without requesting filing payloads during this assessment.
2. Use the supplied demographic-group list to identify candidate sentences containing a group and percentage/fraction, then manually apply the described fiscal-year, workforce-scope, and geography rules: gender disclosures count when location is unspecified/global, non-US-only gender disclosures do not count, and US-only gender disclosures are dropped; people-of-color disclosures count when location is unspecified/US-based, non-US-only disclosures do not count, and global-only disclosures are dropped. Diversity disclosure is either qualifying gender or people-of-color disclosure.
3. Retain the manual sentence/table/figure review and classification record; the supplied GVKEY file is only a final-sample identifier list and does not replace the filing sample or author coding decisions.
4. Before estimating Table 8 Panel B, obtain the missing empirical formula, covariates, and exact sample restrictions; the Table 8 prose specifies heteroskedasticity-consistent standard errors only.

Validation to perform later:

- Reconcile filing count, period, firm identifiers, text/table/figure coverage, and the manual classifications to the author-defined FY2020 sample before joining other sources.

### map_compustat_hcd_inputs: Resolve author-to-product and point-in-time mappings for the Compustat annual and incorporation inputs used with the HCD sample.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: compustat_annual_fundamentals, compustat_incorporation, workflow_closure_unresolved
Evidence: ev_archival_source_names, ev_hcd_merges, ev_catalog_products, ev_comp_funda_probe, ev_comp_company_probe, ev_table8_definition

Preparation / proposed procedure:

1. For the exact catalog-listed COMP.FUNDA and COMP.COMPANY candidates, confirm GVKEY joins, FY2020 date alignment, sample coverage, the authors' mapping to SIC, market value, EBIT, total assets, and state of incorporation, including units and historical validity.
2. Treat the one-row probes as evidence of readability and column presence only; do not infer population coverage, year-validity, author transformations, or missing fields from their first-row values.
3. Keep Compustat's required fields separate from the distinct CRSP Stock File route and the author's manually collected 10-K text.

Validation to perform later:

- Document the source product, field mapping, period alignment, merge key, and matched-sample counts for each Compustat input before forming the HCD analysis sample.

### clarify_crsp_stock_file_contract: Clarify which CRSP Stock File product, frequency, fields, time window, identifiers, and transformation the authors used; the current monthly securities candidate is not established as the needed product.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: crsp_stock_file, workflow_closure_unresolved
Evidence: ev_archival_source_names, ev_catalog_products, ev_crsp_msf_probe

Preparation / proposed procedure:

1. Obtain the author's source-file/product mapping, required observations, dates, join keys, and market-value or other transformations for the CRSP portion of the archival analysis.
2. Do not assume CRSP.MSF, daily/monthly frequency, PRC multiplied by SHROUT, or a substitute product solely because a bounded one-row MSF probe was readable.

Validation to perform later:

- Match the selected CRSP product and field/date contract to the author's stated analysis before including it in a reconstructed archival sample.

### reconstruct_blm_state_measure: Verify compatible ACLED U.S. event history and BEA population fields, then construct the documented state-level BLM measure without filling in the omitted anti-actor list or source mappings.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: acled_us_events, bea_state_population, blm_actor_classification_unresolved, workflow_closure_unresolved
Evidence: ev_blm_raw_sources, ev_blm_main, ev_acled_download, ev_acled_us_access, ev_acled_us_history, ev_acled_registration, ev_bea_state_page, ev_bea_table_docs

Preparation / proposed procedure:

1. Using an authorized ACLED U.S. route, confirm that the author-named 2018-05-21 through 2021-05-30 history, field schema, event dates/geographies, and actor fields support the documented 2020 event classification; ACLED registration is a preparation step, not an established barrier.
2. Obtain the complete author anti-BLM actor list and raw-field mapping. Apply the supplied pro-BLM list and the stated anti_blm == F, pro_blm == T, pro_missing == F rule only after those definitions and the ACLED vintage are resolved.
3. Verify BEA SAINC4's 2020 population measure, units, state/DC identifiers, and source vintage against the author-named file; official static documentation alone does not establish the required row mapping.
4. Count qualifying 2020 events by state, divide by 2020 population and multiply by 100,000, produce the documented 51-state/DC summary, calculate the equally weighted median across those 51 rows, and set events_above_median to 1 only above that median; merge by state into mainUserProfile and the later analyses.

Validation to perform later:

- Record ACLED period/schema and actor-classification provenance, BEA series/units/geography, state/DC coverage, and the 51-row denominator and median construction before using events_per_capita_100k or events_above_median.

### resolve_empirical_models_and_figure3_dictionaries: Obtain the omitted empirical specifications and Figure 3 function/dictionary definitions before attempting those analyses; retain the documented manual and companion branches in scope.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: table5_model_specification_unresolved, table8_model_specification_unresolved, figure3_dictionary_unresolved, workflow_closure_unresolved, no_executable_program
Evidence: ev_table5_scope, ev_table8_regression_scope, ev_hcd_merges, ev_figure3, ev_manual_workflow, ev_appendix_visual

Preparation / proposed procedure:

1. For Table 5, obtain the probit dependent variable, regressors, controls, treatment coding, and estimation sample; the document supplies the recommended_companies construction, exclusions, and user-clustered standard errors but not the complete empirical formula.
2. For Table 8 Panel B, obtain the regression formula, covariates, and exact restrictions; preserve the documented HCD/Compustat/BLM/Zippia/mainClickedData joins, highest-gender_total duplicate rule, and 2-digit SIC by user_group experiment_delta definition.
3. For Figure 3, obtain the actual Python function source, section-name list, ten topic dictionaries, token matching rules, and any subsection text normalization; do not infer these from the prose description of all-words matching.
4. Preserve Table 7 as its own survey branch and Figure 3 as a companion HCD text-analysis branch alongside the Table 2–6 experiment analyses and the Table 8 archival analysis.

Validation to perform later:

- Check that the supplied specifications reproduce the described outcomes, samples, clusters/standard errors, subgroup/topic definitions, and branch inputs before estimating or counting results.

### confirm_named_software_availability: Confirm suitable versions and availability of the named R, Python, SAS, and JMP products once the historical inputs and executable specifications are available.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: r_language, python_runtime, sas_product, jmp_product, workflow_closure_unresolved
Evidence: ev_authors_software, ev_environment, ev_figure3, ev_survey

Preparation / proposed procedure:

1. Record R and Python version compatibility with any later-supplied author programs; the supplied environment probe reports R 4.5.0 and Python 3.12.14 but does not test those programs.
2. Verify SAS and JMP versions/availability through an authorized runtime inventory. Preserve the supplied SAS TKELS initialization failure as an unverified runtime condition, not a license or entitlement conclusion; do not start SAS as part of this assessment.

Validation to perform later:

- Confirm each program's required runtime and version before a separately authorized execution attempt; software presence does not resolve missing inputs or model specifications.

### follow_documented_branch_order: After inputs, missing definitions, and an executable workflow are supplied, follow the authors' producer-consumer order across the experiment, survey, HCD, archival, and Figure 3 branches.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: no_executable_program, workflow_closure_unresolved, empirical_inputs_missing
Evidence: ev_main_user_profile, ev_profile_attributes, ev_blm_main, ev_blm_raw_sources, ev_email_metrics, ev_company_and_click, ev_recommended_company_sample, ev_table2_scope, ev_table3_scope, ev_table4_scope, ev_table5_scope, ev_table6_scope, ev_survey, ev_hcd, ev_hcd_merges, ev_table8_definition, ev_figure3, ev_manual_workflow

Preparation / proposed procedure:

1. Build mainUserProfile from the documented user, gender, preferred-level, location, and ethnicity inputs: merge by user_id/user_group where stated, classify hasbach from education terms, set blank education to NA, keep the first de-duplicated location, assign state.region, and derive poc from the maximum non-missing/non-Unknown/non-White ethnicity score.
2. Prepare Data/blm_events.csv from compatible ACLED and BEA inputs under the resolved actor and field mappings; then merge the state rate and above-median indicators into the profile before the relevant analyses.
3. Construct emailsSent_by_id, emailsOpened_by_id, and emailsClicked_by_id from timestamp indicators and user_id/user_group totals; build mainCompanyDataResults from the company file and documented logged non-missing/nonzero diversity, salary, and median-salary scores; then build mainClickedData and recommended_companies with the documented company/user/click/rating joins.
4. Produce Table 2's stated panels: baseline/diversity user-profile and engagement summaries (N=178,862); all-company statistics from mainCompanyDataResults (N=107,810, with 66,694 nonmissing diversity scores); and clicked-company statistics after excluding missing company_id (7,871 unique company_id values, 7,304 with nonmissing diversity scores).
5. Produce Table 3's baseline/diversity covariate proportions and engagement means with treatment-condition t-tests. For Table 4, compare nonmissing diversity scores in baseline/diversity mainClickedData, repeat that test for each user's first email campaign after ordering by user_id and time_stamp, then compare nonmissing salary scores for baseline/salary conditions.
6. For Table 5, use recommended_companies with the documented nonmissing education, preferred job level, and diversity-score restrictions, and estimate the probit with user-clustered standard errors only after the missing formula is supplied. For Table 6, retain the baseline/diversity sample and run the described panel-specific means/ANOVAs for gender, hasbach, preferred job level, and events_above_median, excluding missing panel variables.
7. Run Table 7 independently from the historical response workbook using the supplied survey instrument and response denominators; this is a descriptive survey branch without supporting code.
8. For Table 8, manually classify the complete FY2020 HCD disclosures, apply the documented geography/scope rules, join Compustat, BLM, Zippia company data, and mainClickedData, keep the duplicate with the highest gender_total, and form experiment_delta by two-digit SIC and user_group; estimate Panel B only after its missing formula/sample definition is supplied.
9. Run Figure 3 on the Table 8 Panel B firm set only after the Python functions, section-name list, and ten topic dictionaries are supplied; keep its subsection-name and topical counts as a companion analysis.

Validation to perform later:

- At each documented handoff, record input/output schemas, join keys, sample restrictions, missing-value rules, and branch counts; compare only the corresponding defined table or figure outputs after all unresolved author definitions are supplied.


## Remaining issues and prerequisites

- no_executable_program [blocking; full_pipeline]: The supplied documents give substantive manual and procedural specifications, including data transformations, manual human-capital coding, and Figure 3 function behavior, but contain no executable driver or function source. The substantive workflow description is credited; it does not provide runnable code.
- empirical_inputs_missing [unresolved; full_pipeline]: The package inventory contains documentation and a final-sample GVKEY identifier list, but not the historical Zippia experiment files, Table 7 response workbook, or HCD/archival analysis inputs. Zippia acquisition and survey collection are historical provenance; the documented workflow does not require live recollection.
- workflow_closure_unresolved [unresolved; full_pipeline]: The substantive manual procedure identifies many sources and transformations, but no executable driver or complete input package is supplied. Product compatibility, several source-field mappings, exact Table 5/Table 8 regressions, the complete BLM anti-actor list, and Figure 3 topic dictionaries remain unresolved.
- blm_actor_classification_unresolved [unresolved; full_pipeline]: The described BLM construction gives a pro-BLM actor list and an anti_blm/pro_blm/pro_missing decision rule, but says the anti list includes several additional actors without naming them. The raw ACLED field mapping and complete actor lists are needed to construct the 2020 state counts without changing classification.
- table5_model_specification_unresolved [unresolved; full_pipeline]: The supplied Table 5 procedure identifies a probit and user-clustered standard errors but does not specify its dependent variable, regressors, controls, or complete estimation formula. The theoretical appendix equation is not the missing empirical regression specification.
- table8_model_specification_unresolved [unresolved; full_pipeline]: The supplied Table 8 description identifies a regression and heteroskedasticity-consistent standard errors but omits the empirical formula, covariates and exact sample restrictions needed to reproduce Panel B.
- figure3_dictionary_unresolved [unresolved; full_pipeline]: Figure 3 describes functions that count section-name words and ten topics, but neither the executable functions nor the section/topic word lists are supplied. Exact frequency outputs cannot be reproduced from the prose alone.
- zippia_experiment_inputs [undetermined]: The historical anonymized Zippia files needed for the experimental user/profile, campaign engagement, company, ratings, click and recommended-company intermediates used in Tables 2–6 and Table 8.
- followup_survey_responses [undetermined]: The historical follow-up survey response workbook used for the independent Table 7 response-count and percentage summaries.
- hcd_fy2020_10k_text [undetermined]: The author-defined full sample of FY2020 10-K filing text, tables and figures needed for manual human-capital-disclosure classification and Figure 3 text analysis.
- compustat_annual_fundamentals [undetermined]: Compustat annual firm data for the Table 8 SIC, market-value, EBIT, and total-assets inputs; exact field definitions, sample, filters and date alignment must match the authors' 2020 disclosure observations.
- compustat_incorporation [undetermined]: The Compustat state-of-incorporation field named for the Table 8 merge, including its identifier and point-in-time mapping to the FY2020 HCD sample.
- crsp_stock_file [undetermined]: The distinct CRSP Stock File source named in the datasheet for the archival analysis; the step-by-step Table 8 description does not identify its frequency, fields, sampling window, or use.
- acled_us_events [undetermined]: Author-named ACLED U.S. event data used to construct the state-level pro-BLM events measure and its derived profile/Table 6/Table 8 variables.
- bea_state_population [undetermined]: The author-named BEA state-population source used as the 2020 denominator for state-level pro-BLM events per 100,000 people.
- sas_product [unverified]: SAS is named for survey analysis. Supplied environment evidence reports that the prior SAS startup probe could not initialize TKELS; this is not evidence of missing license or entitlement. No SAS process was started for this assessment.
- jmp_product [unverified]: JMP is named for the historical survey analysis; its current availability and version are not established by the supplied environment probe.

## Review notes

- Content-reviewed scope includes the full documented experiment tables, the independent follow-up survey Table 7, the Table 8 human-capital/archival analysis, and companion Figure 3 text/topic analysis.
- The step-by-step PDF supplies substantive manual procedures, variable definitions, sample sizes/restrictions, merge keys, and data handoffs. The authors state Table 1, Figure 1, and Figure 2 are qualitative/descriptive and unsupported by underlying code. The inspected package contains no executable driver or function bodies; the stated Figure 3 Python functions and dictionaries are described but not supplied. Appendix A equations are theoretical exposition, not data-processing code.
- The authors expressly describe the survey workbook as having no supporting code. The original appendix pages 8–12 contain the historical instrument omitted by cached-text extraction; visual inspection confirms its Q1-branching Q2 and later questions. The instrument does not imply live participant recruitment.
- Sample_Table8_Gvkey.csv is a final-sample identifier list, not the analysis dataset. Exact catalog lookup and bounded one-row probes establish selected local product readability and requested column presence only; sample coverage, author mappings, dates, and source compatibility remain unverified.
- Frozen title wording differs only in capitalization ('From' versus 'from'); no material title or DOI attribution conflict is supported by the inspected documents.
- Unresolved scientific specifications remain specific: Table 5 and Table 8 empirical regressions are not fully defined by the supplied prose, the complete anti-BLM actor list and raw-field mappings are omitted, and Figure 3's function source and section/topic dictionaries are not supplied.
- No generic requirement is inferred from unknown file names or the static scan. Historical Zippia collection and survey recruitment are provenance; proposed routes concern already collected records and do not request recollection or contact.
