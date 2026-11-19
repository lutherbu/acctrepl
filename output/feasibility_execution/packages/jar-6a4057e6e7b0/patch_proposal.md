# Patch proposal: jar-6a4057e6e7b0

Corporate Scandals and Regulation

DOI: 10.1111/1475-679X.12201

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata analysis workflow from required source and author-prepared input datasets through country-year panel construction, merges, descriptive statistics, and Tables 5–6 regressions. A distinct analysis-only scope is not supported: the only consolidated scandal DTA is one panel component and does not establish all required macro/crisis inputs or a separate complete analysis entry.

Entry points: `HTW Data Description/STATA code/HTW_analyses.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 2/12201 - Corporate-Scandals-and-Regulation/htw-datasheet-and-code.zip",
      "sha256": "530aa6042e69104fe5b78da52c444a330bdc6290939dd7fc9509a60c4f0e6794"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12201 - Corporate-Scandals-and-Regulation/hail-tahoun-wang-accepted-proposal.pdf",
      "sha256": "be1af849a252d173b5606a1dcef4c085d28b4306f7ace32de1e16c160550e160"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12201 - Corporate-Scandals-and-Regulation/htw-online-appendix.pdf",
      "sha256": "e4ced92d891448e29910adad72692bcecd015737d9414176c5af3ccd60dd92ec"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a257ea088bca727f8f8088228131f6ac1f3b836552dafe971698f13dacc231ee",
  "work_item_sha256": "f31334a08ac817769b3bfe8b1e35dd638123b90837d470607dd4b12071d84013"
}
```

## Proposed actions

### action_maddison_acquire: Acquire the authors’ specified Maddison Project Database version 2013 workbook for the historical GDP base series.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: req_maddison_gdp
Evidence: ev_maddison_public, ev_gdp_source_spec

Preparation / proposed procedure:

1. Use the official University of Groningen Maddison Project Database 2013 page and its Excel download.
2. Retain the release/version and attribution information.
3. Map the source country, year, and GDP-per-capita observations in 1990 international dollars into the historical component of the macro panel; keep country-year gaps for the separately documented author fill procedure.

Validation to perform later:

- Confirm the acquired workbook is the 2013 release and covers the required country-year observations through 2010.
- Confirm the unit is the 1990 international-dollar GDP-per-capita measure used by the authors before combining it with 2011–2015 values.

### action_missing_inputs: Obtain the missing complete macro panel and RR crisis inputs, and resolve how the already supplied author fill values are assembled with historical baseline series and indicator flags.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_macro_panel, req_rr_inflation, req_imf_inflation_extension, req_israel_inflation, req_rr_crisis_panel, issue_missing_inputs
Evidence: ev_country_file_inputs, ev_crisis_source_spec, ev_gdp_recent_spec, ev_inflation_source_spec, ev_macro_fill_file, ev_macro_fill_method, ev_macro_fill_profile, ev_macro_required_fields, ev_probe_macro_file, ev_probe_scandal_panel, ev_rr_inflation_public, ev_rr_varieties_public, ev_scandal_analysis_data_available, ev_scandal_panel_profile

Preparation / proposed procedure:

1. Request the complete `inflation_gdp.dta` or the exact author assembly instructions for historical GDP/inflation baselines and `gdppc_est`/`infl_est` indicators. The packaged `inflation_gdp_est.dta` already contains the author-filled values and the 130 recent GDP values; do not request the Conference Board 2016 workbook merely to reacquire those values.
2. Request the IMF dataset/series and January 2017 vintage used for the 2009–2015 inflation extension, and the corresponding World Bank/WDI source vintage for Israel.
3. Request the exact `RR_replication.dta` or author-supplied mapping/program to create its crisis variables from the referenced Reinhart–Rogoff files. Confirm source columns, country coverage, and years.
4. Use the verified local GDP/inflation fill-value components through action_macro_fill_preparation only after historical baseline inputs and the author indicator/overlap convention are established.
5. Use the supplied HTW_scandal_data.dta as the conditional local route for the country-year scandal/regulation panel, following action_combined_panel_adapter. If future validation does not support the required values or merges, request the 26 per-country `.dta` files or their author construction program as a fallback.
6. Keep historical newspaper/archive sources as provenance of the already supplied author-collected scandal data, not as live acquisition requirements; do not infer an access barrier from subscription markers or catalog absence.

Validation to perform later:

- After acquiring or receiving the complete macro inputs, confirm the final country-year panel includes `country`, `year`, `gdppc`, `gdppc_est`, `infl`, and `infl_est`, with baseline periods and fill flags documented.
- Confirm the R&R source variables, country coverage, and year treatment before creating the crisis panel.
- Use bounded metadata checks for keys, row counts, and date ranges; do not substitute unverified current source values.

### action_macro_fill_preparation: Use the author-supplied fill-value file and recent-GDP observations as local components of the complete macro panel after its historical baselines are available.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_macro_panel, req_recent_gdp, req_macro_gapfills
Evidence: ev_macro_fill_profile, ev_macro_fill_file, ev_macro_fill_method, ev_gdp_recent_spec, ev_macro_required_fields

Preparation / proposed procedure:

1. Retain inflation_gdp_est.dta as the author-prepared source of 539 nonmissing GDP values (including 130 for 2011–2015) and 145 nonmissing inflation values. These recent GDP values are already included and described as adjusted to the Maddison 1990 international-dollar base; do not reacquire the Conference Board workbook just to recover them.
2. After compatible historical GDP and inflation baselines are available, merge the fill-value file by country/year and apply its nonmissing `gdppc`/`infl` values to the corresponding author-filled country-years, subject to confirmation of the authors’ overlap and overwrite convention.
3. Assemble `gdppc_est` and `infl_est` flags for rows filled from the local file using the author-confirmed indicator convention. The fill file has no flags, so do not infer their exact values or missing-value treatment without confirmation.
4. Write the resulting complete `inflation_gdp.dta` with `country`, `year`, `gdppc`, `gdppc_est`, `infl`, and `infl_est`; the local fill file alone is not a substitute for the historical baselines.

Validation to perform later:

- Before merging, confirm 539 nonmissing GDP values, 145 nonmissing inflation values, and 130 nonmissing GDP values in 2011–2015 in the local author file; confirm unique country-year keys and country names match the scandal panel.
- After assembly, verify the full expected columns, historical period, country-year keys, GDP units, and indicator counts against author instructions.
- Keep complete macro-panel readiness unresolved until the historical GDP/inflation baselines and flag convention are confirmed.

### action_combined_panel_adapter: Use the bundled author-prepared combined scandal panel as the local alternative to the absent 26 per-country Stata files, at the same panel stage before combined variables and macro/RR merges.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_country_dta
Evidence: ev_scandal_panel_profile, ev_panel_decade_scale, ev_panel_derived_vars, ev_merge_gdp_order, ev_merge_rr_order

Preparation / proposed procedure:

1. In an authorized working copy, bypass the original Austria-plus-25-country `.dta` load/append block and load `HTW scandal data/HTW_scandal_data.dta` as the scandal panel.
2. Place this adapter at the equivalent stage after the original decade normalization point (cached main-do line 240) and before the generated `scand_acct_near` and `regl_acct_oth` fields (lines 247 and 250). The bundled DTA already stores decades as 1800/1810/etc.; skip the multiplication for this route.
3. Continue with the existing derived variables, indicators, moving averages, and then merge `temp_inflation_gdp.dta` followed by `temp_RR_replication.dta` in the supplied order. Do not treat the combined panel as a substitute for either missing macroeconomic input.

Validation to perform later:

- Before any authorized execution, verify the panel still has 5,616 rows, 26 countries, unique country-year keys, and the expected fields after adaptation.
- Inspect nonmissing count-field values and confirm the retained observations match the paper’s intended panel; the supplied profile did not inspect these values.
- After macro/RR inputs are available, check country/year merge coverage and duplicates. The profile does not establish macro/RR merge compatibility.

### action_project_paths: Create a project-local working layout and direct the main script to it after required input files are available.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: issue_path_layout
Evidence: ev_macro_path, ev_macro_includes_tab11, ev_macro_includes_tab10, ev_inventory

Preparation / proposed procedure:

1. Use a working copy of the supplied project and set `$m4` to a staged root containing `01 Input_datasets` and the regression-code directory. Include `02 Countries - done` only if the original per-country branch is retained; the combined-panel adapter instead requires a project-local path to `HTW_scandal_data.dta`.
2. Place or point the included tab10/tab11 files at the path used by the do-file, or update only those include paths to their actual `HTW Data Description/STATA code` locations after the staging layout is chosen.
3. Set the working directory to a dedicated output folder so logs and table files are written there.
4. Do not finalize path values until the missing macro/RR inputs and directory structure are supplied.

Validation to perform later:

- Before execution, use Stata `confirm file` checks for inflation_gdp.dta, RR_replication.dta, and both included regression macros. If the combined-panel adapter is selected, confirm its project-local HTW_scandal_data.dta path; if retaining the original branch, confirm all 26 country-specific inputs instead.
- Confirm `$m4` resolves to the intended staged root and the working directory is writable.

### action_crisis_years: Resolve the documented 2009–2015 no-crisis statement against the do-file’s 2011–2015 zero-fill stage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_crisis_year_boundary
Evidence: ev_crisis_source_spec, ev_rr_source_input, ev_rr_zero_years

Preparation / proposed procedure:

1. Ask the authors to confirm whether crisis observations for 2009–2010 should remain sourced from the Reinhart–Rogoff data and whether the code’s 2011–2015 zero fill is intended.
2. Retain the existing code and data as separate evidence until the author confirms the target years; do not extend or change the zero-fill range by inference.

Validation to perform later:

- After clarification, inspect the assembled crisis panel for the confirmed source/zero-fill boundary and verify the five-year synthetic key expansion does not duplicate or omit any country-year.

### action_stata_addons: Install or configure the three author-required Stata user commands in the project user ado path.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: sw_corrtab, sw_tabout, sw_outreg2
Evidence: ev_probe_corrtab, ev_probe_tabout, ev_probe_outreg2, ev_corrtab_call, ev_tabout_call, ev_outreg2_call

Preparation / proposed procedure:

1. Install or configure `corrtab`, `tabout`, and `outreg2` from their documented Stata package sources in the project user ado path.
2. Keep setup local to the user/project adopath; do not modify shared catalogs during this assessment.

Validation to perform later:

- In Stata 18, run `which corrtab`, `which tabout`, and `which outreg2` after setup and confirm each resolves to the intended ado file.

### action_run_procedure: Future execution sequence for the full author workflow after the unresolved inputs, source-vintage questions, path configuration, and software setup are resolved. No code or regression is run in this assessment.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: ev_analysis_program_scope, ev_macro_temp_producer, ev_rr_source_input, ev_rr_temp_producer, ev_country_file_inputs, ev_merge_gdp_order, ev_merge_rr_order, ev_macro_includes_tab11, ev_macro_includes_tab10, ev_env

Preparation / proposed procedure:

1. With all source data prepared, run HTW_analyses.do from a configured Stata 18 working copy.
2. Preserve the coded producer/consumer order: first create temp_inflation_gdp.dta from inflation_gdp.dta; next create and append temp.dta to RR_replication.dta, then create temp_RR_replication.dta; then supply the scandal panel. For the conditional local route, load HTW_scandal_data.dta after the decade-normalization stage without re-multiplying decade and before the combined variables are generated; otherwise use the original Austria-plus-25-country inputs. Merge the scandal panel first to temp_inflation_gdp.dta and then to temp_RR_replication.dta.
3. After the panel is assembled, execute the descriptive statistics and Table 3/4 outputs, then the tab11 Table 5 regressions and tab10 Table 6 regressions. The code creates intermediate files before their consumers and erases temporary files after use.

Validation to perform later:

- For a future authorized run, check the log for errors and confirm Table 3, Table 4, Table 5 panels A/B, and Table 6 panels A/B are produced.
- Verify the resulting analysis panel has the author-required country-year keys and control variables and the confirmed 2009–2015 crisis treatment.
- Execution remains unverified until a future authorized run completes and outputs are checked.


## Remaining issues and prerequisites

- issue_missing_inputs [unresolved; full_pipeline]: The main script’s complete inflation_gdp.dta and RR_replication.dta inputs are absent. The bundled inflation_gdp_est.dta now has a verified author-filled-value component route: its 539 GDP, 145 inflation, and 130 2011–2015 GDP values match the data description. It still contains only country/year/gdppc/infl, lacks the required gdppc_est/infl_est flags and historical baseline series, and therefore cannot replace the complete macro input. The R&R crisis input and its exact construction remain unresolved.
- issue_path_layout [preparation; full_pipeline]: The main script hard-codes the authors’ workstation root and Desktop working directory. It includes regression files from a `03 STATA code` folder, while the package places both files under `HTW Data Description/STATA code`. The `01 Input_datasets` layout is also absent; `02 Countries - done` is needed only if the original per-country branch is retained rather than using the combined panel adapter.
- issue_crisis_year_boundary [unresolved; full_pipeline]: The data description says the authors assume no financial crises for 2009–2015; the supplied code instead fills rr_* values with zero only for years 2011–2015 after extending the R&R key by five years. It is unclear whether 2009–2010 remain observed in RR_replication.dta and which boundary is intended. Do not alter crisis values until clarified.
- req_macro_panel [undetermined]: The direct input inflation_gdp.dta required by the main do-file. Required source columns include country, year, gdppc, gdppc_est, infl, and infl_est; these become GDP/inflation levels and filled-value flags before lagged transforms.
- req_maddison_gdp [public_acquisition_required]: Historical annual GDP per capita source used to build the GDP portion of inflation_gdp.dta. The author documentation specifies the 2013 Maddison release in 1990 international dollars; missing years are handled separately.
- req_rr_inflation [undetermined]: Historical annual inflation input for the macro panel from the online data accompanying Reinhart and Rogoff (2011), for country-years not covered by the authors’ later extension.
- req_imf_inflation_extension [undetermined]: Annual inflation extension for 2009–2015 from the IMF, as named by the authors; exact IMF dataset/series and 2017 vintage are not identified in the package.
- req_israel_inflation [undetermined]: Israel annual inflation observations, which the authors source from World Bank data because Israel is not covered by the cited Reinhart–Rogoff inflation data.
- req_rr_crisis_panel [undetermined]: The RR_replication.dta annual country-year crisis dataset used to construct rr_crisis, crisis-type, first-year, and lagged moving-average controls. Code names source variables including currcrisis, inflcrisis, mktcrash, dc_dom, dc_ext, bc, and first-year fields. Authors exclude Israel from specifications requiring these crisis measures.
- sw_corrtab [preparation_required]: User-written Stata command called by HTW_analyses.do at line 74; not found in checked ado paths.
- sw_tabout [preparation_required]: User-written Stata command called for Table 3 exports; not found in checked ado paths.
- sw_outreg2 [preparation_required]: User-written Stata command called for Table 4 and regression exports; not found in checked ado paths.

## Review notes

- Single full_pipeline scope only. The bundled HTW_scandal_data.dta is a locally verified scandal-panel component alternative: its profile reports 5,616 rows, 26 countries, 1800–2015 country/year range, unique keys, and all 13 required columns. The profile read only country/year/decade values; count-field nonmissingness, full sample fidelity, and macro/RR merge compatibility remain unresolved. It does not support a separate complete analysis-only branch because the main analyses still require missing macroeconomic and RR crisis inputs.
- The Stata code order was traced directly: build temp_inflation_gdp.dta from inflation_gdp.dta; create a shifted five-year temp.dta from RR_replication.dta, append it before generating lags and saving temp_RR_replication.dta; supply the scandal panel; merge first to temp_inflation_gdp.dta and then temp_RR_replication.dta; produce Tables 3–4 and invoke tab11/tab10 for Tables 5–6. The combined-panel adapter belongs after decade normalization and before the derived scandal/regulation combinations; its already-scaled decade values must not be multiplied again.
- The author-supplied inflation_gdp_est.dta profile verifies 539 nonmissing GDP values, 145 nonmissing inflation values, and 130 nonmissing GDP values in 2011–2015; the 26 country names match the scandal panel and country-year keys are unique. The Conference Board 2016 source is provenance for those local recent-GDP values, not a required reacquisition. The file remains a fill component only: it lacks the complete historical baselines and the gdppc_est/infl_est indicators required by inflation_gdp.dta.
- The archive contains 26 country Excel workbooks, the combined HTW_scandal_data.dta, and inflation_gdp_est.dta. The combined DTA profile establishes the scandal-panel schema and identifier grid; it does not establish count-value completeness or macro/RR merge compatibility. No inflation_gdp.dta or RR_replication.dta is present.
- The country appendix and data description explain where already collected scandal evidence came from. Those historical source origins are not treated as live dependencies because author-collected country workbooks and the combined panel are supplied. Subscription symbols in source descriptions and catalog misses are not evidence of an access barrier.
- The data description says no crisis observations for 2009–2015, while the do-file zero-fills only 2011–2015 after shifting the RR year key by five. This data/code discrepancy is retained as unresolved; no range or crisis values were changed.
- The Maddison 2013 route is verified for the historical GDP base product; historical inflation sources, complete macro assembly/indicators, and RR inputs remain unresolved. No current source revision is substituted for the authors’ historical vintages.
- The static audit is syntax/dependency discovery, not evidence of a successful execution. No author code, regression, data download, or installation was run.
