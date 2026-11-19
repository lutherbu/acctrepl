# Patch proposal: jar-acbc02d94f8a

The Silent Majority: Private U.S. Firms and Financial Reporting Choices

DOI: 10.1111/1475-679X.12306

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata workflow: IRS form harmonization, sample construction, main analyses, the Compustat Table 6 branch and Tables 7–8 audit-change branch. The datasheet/appendix also describe benchmarking with RMA, Sageworks, SUSB and SOI, but the supplied code text has no matching benchmark branches; those are contextual rather than added inputs.

Entry points: `LM_code_IRS 200401.txt`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 3/12306 - The-Silent-Majority-Private-U-S-Firms-and-Financial-Reporting-Choices/limi-datasheet-and-code.zip",
      "sha256": "adbd9879508aa724b648f6ac240fdafd1ce562e135b7ee91a409af1ae868c5d1"
    },
    {
      "path": "JAR-Volume 58/Issue 3/12306 - The-Silent-Majority-Private-U-S-Firms-and-Financial-Reporting-Choices/limi-online-appendix.pdf",
      "sha256": "47c940025ba84d33ffef42c297b780882ac6eb8f8d30edac01db3b8ac358666d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "dd6ad0097e55ad1ec41e6a80b906c86b89025663ecea3e4fe0286f5ba1c1f41d"
}
```

## Proposed actions

### act_confirm_irs_access: Establish whether all three historical IRS filer-family inputs have a current authorized retention/access route and permitted execution environment.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_irs_1120, req_irs_1120s, req_irs_1065, issue_irs_access_status
Evidence: src_irs_names, src_irs_scope, src_irs_m3, src_historical_access, src_historical_purge, src_historical_continuation

Preparation / proposed procedure:

1. Obtain the author or authorized custodian’s current retention/access status and permitted execution environment for Petro.AMS_F_1120_Combo, Petro.AMS_F_1120S_Combo and Petro.AMS_F_1065_Combo.
2. Confirm that any supplied inputs retain the documented parent-consolidated forms, Schedule M-3 fields, 2008–2010 coverage and EIN/fiscal-year linkage within the applicable restrictions.
3. Do not use SOI aggregates or Compustat as substitutes for the private firm-level IRS inputs.

Validation to perform later:

- Before any separately authorized run, verify access for all three filer families and inspect only an approved schema/sample in the permitted environment.

### act_complete_irs_inputs: Resolve the missing IRS input/preprocessing contract and the variable producers absent from the supplied Stata text.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_irs_1120, req_irs_1120s, req_irs_1065, issue_import_redaction, issue_missing_variable_mapping
Evidence: src_stata_and_redactions, src_preprocess_prior, src_redacted_steps, src_three_input_merge, src_master_placeholder, src_taxprd_map, src_dateincorporated_use, src_dateincorporated_mapping, src_tab2_unproduced, src_tab2_unproduced_winsor

Preparation / proposed procedure:

1. Request the complete data-to-Stata import/conversion recipe, the three combined IRS form-family schemas, and the identity of each [file...] placeholder.
2. Request the missing producer or author-prepared input contract for dateincorporated_new and the Table 2 match, winsor and owner-category fields. Do not infer aliases or transformations from similar-looking names.
3. Preserve the documented EIN, tax_prd-to-fyear mapping, sample exclusions and paper/e-filer logic; keep any redacted processing inside its authorized environment.

Validation to perform later:

- Compare each supplied input schema with the raw fields used by its form-specific harmonization block, then verify the merged EIN×fyear handoff and all consumed Table 2 fields before any future execution.

### act_configure_paths: Prepare a working .do copy from the Stata TXT, comment the two human-only A10/A11 headings, and normalize every supplied Windows input/output path to the configured relative execution directory. The abstract [file...] tokens are not replaced by these working-copy preparations.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: issue_paths_driver
Evidence: src_comp_file, src_fixed_effects_file, src_audit_change_file, src_audit_change_file2, src_temp_comp_save, src_temp_audit_save, src_temp_audit_merge, src_appendix_a10_crossref, src_appendix_a11_crossref

**Proposed edit:** `LM_code_IRS 200401.txt:618–618`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Use the documented input name from the configured runtime working directory.

Current text:
```
use "[redacted-path-1f36860da3fc]", clear
```

Proposed replacement:
```
use "comp.dta", clear
```

**Proposed edit:** `LM_code_IRS 200401.txt:686–686`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Write this intermediate relative to the same configured execution directory.

Current text:
```
	save "[redacted-path-fe708d07235f]", replace
```

Proposed replacement:
```
	save "temp.dta", replace
```

**Proposed edit:** `LM_code_IRS 200401.txt:705–705`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Read the documented merge file from the configured runtime working directory.

Current text:
```
	merge naics_3 using "[redacted-path-a5fefa717b24]" /*Variable name for the industry-level fixed effects in this data set is "fe" */
```

Proposed replacement:
```
	merge naics_3 using "naics_3_fixed_effects.dta" /*Variable name for the industry-level fixed effects in this data set is "fe" */
```

**Proposed edit:** `LM_code_IRS 200401.txt:734–734`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Read the supplied branch input relative to the configured runtime working directory.

Current text:
```
use "[redacted-path-a7cb4609d955]", clear
```

Proposed replacement:
```
use "audit change data.dta", clear
```

**Proposed edit:** `LM_code_IRS 200401.txt:742–742`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Write the 2008 baseline relative to the configured execution directory.

Current text:
```
	save "[redacted-path-fe708d07235f]", replace
```

Proposed replacement:
```
	save "temp.dta", replace
```

**Proposed edit:** `LM_code_IRS 200401.txt:745–745`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Keep the second source read consistent with the first one.

Current text:
```
	use "[redacted-path-a7cb4609d955]", clear
```

Proposed replacement:
```
	use "audit change data.dta", clear
```

**Proposed edit:** `LM_code_IRS 200401.txt:760–760`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Consume the baseline output from the same relative working directory used by its producer.

Current text:
```
	merge ein using "[redacted-path-fe708d07235f]"
```

Proposed replacement:
```
	merge ein using "temp.dta"
```

**Proposed edit:** `LM_code_IRS 200401.txt:1385–1385`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Make this human-only appendix heading a Stata comment in the extracted working .do copy; the next line is the actual cross-reference comment.

Current text:
```
Table A10: Characteristics of Firms Ending Audited GAAP Financial Statement Production
```

Proposed replacement:
```
* Table A10: Characteristics of Firms Ending Audited GAAP Financial Statement Production
```

**Proposed edit:** `LM_code_IRS 200401.txt:1392–1392`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Make this human-only appendix heading a Stata comment in the extracted working .do copy; the next line is the actual cross-reference comment.

Current text:
```
Table A11: 2x2 Contingency Tables Conditional on Age, Ownership, and Debt
```

Proposed replacement:
```
* Table A11: 2x2 Contingency Tables Conditional on Age, Ownership, and Debt
```

Preparation / proposed procedure:

1. Extract/reflow LM_code_IRS 200401.txt to a separate working .do copy; comment the bare A10 and A11 headings at lines 1385 and 1392 while retaining their Table 7/8 cross-reference comments; retain the frozen TXT unchanged.
2. Apply the listed relative-path substitutions only in the working copy. Keep comp.dta, naics_3_fixed_effects.dta and audit change data.dta as distinct named inputs.
3. Set the future batch wrapper working directory to the working-copy folder and stage compatible inputs there or at approved [redacted-path-c6c4d17b962e] locations. Do not put absolute Dropbox paths in executable configuration.
4. Before any separately authorized run, verify the host wrapper sees the chosen directory and can read required inputs and write outputs.
5. When the full TXT is extracted, keep A10/A11 as cross-references to the already supplied Tables 7–8 code above; do not treat them as separate runnable analysis blocks.

Validation to perform later:

- Review all seven edits together; confirm the two temp.dta writers and Table 7/8 consumer share the intended working directory, and all named inputs are visible from that directory.

### act_resolve_compustat: Resolve the Table 6 Compustat file, field construction and period contract before treating the catalog candidate as usable.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_compustat, issue_compustat_contract
Evidence: src_compustat_scope, src_compustat_claim, src_comp_file, src_table6_yearkey, src_table6_period, src_table6_raw_fields, src_table6_lag, src_table6_collapse_count, src_table6_collapse_ratios, catalog_comp_funda, probe_comp_funda, src_table6_var_producers, src_table6_sd_output, src_table6_sd_input

Preparation / proposed procedure:

1. Request the exact author comp.dta or its complete documented extraction/preparation code and source schema. Confirm how `year` is supplied separately from `fyear`, and how count2, comp, ca_ratio, ar_inv_ratio, che_ratio, ppe_to, ca_to, cash_to and emp_to are produced; preserve the code’s existing producers for lev, btm, mtb, roa, pm, ppe_ratio, growth and related variables.
2. Compare the locally readable COMP.FUNDA candidate with the resolved Table 6 preparation contract: establish the 2005–2010 coverage and map its raw columns into the prepared comp.dta fields, including the separate `year` key and the fields absent from the supplied branch. Do not add a separate current-entitlement inquiry as a prerequisite for this catalog-listed local candidate.
3. If an authorized compatible route is confirmed, acquire/convert only the documented annual input to the expected comp.dta format; do not invent mappings for missing columns.
4. Clarify whether the first collapse output `roa_sd_win` is meant to supply the later `roa_sd` input; do not rename it without author confirmation.

Validation to perform later:

- Run a bounded schema probe on the actual selected input and verify exact year/fyear names, expected fields, key assumptions and required period before a future authorized Table 6 run.

### act_clarify_audit_change: Resolve the separate audit-change handoff used by Tables 7–8.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_audit_change, issue_missing_handoffs
Evidence: src_audit_change_file, src_audit_change_file2, inspect_package_inventory

Preparation / proposed procedure:

1. Request the author-prepared audit change data file or its complete supplied producer and input contract, including the path, expected fields, production order and relationship to the IRS master data.
2. Do not assume it is generated by the earlier masterfile or fabricate missing observations.

Validation to perform later:

- Compare the delivered file/producer with each field read by the Tables 7–8 branch and verify the intended 2008–2010 firm-year structure before a future run.

### act_clarify_fixed_effects: Resolve the industry fixed-effects file merged in Table 6.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_fixed_effects, issue_missing_handoffs
Evidence: src_fixed_effects_file, src_table6_period, inspect_package_inventory, src_table6_median_fields, src_table6_percent_public

Preparation / proposed procedure:

1. Request the author-prepared naics_3_fixed_effects.dta file or the complete supplied producer, including its 3-digit NAICS key, fe variable, med_assets, med_sales and perc_public fields, coverage and source regression.
2. Do not assume the earlier cross-sectional estimates are exported or substitute independently computed effects.

Validation to perform later:

- Verify the exact merge key, row uniqueness and required industry coverage before a future authorized Table 6 run.

### act_run_procedure: After all unresolved inputs, access and code contracts are resolved, execute the supplied branches from a working copy in their authored sequence.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: issue_paths_driver, issue_appendix_state_reload
Evidence: src_three_input_merge, src_irs_efile_sample, src_comp_file, src_fixed_effects_file, src_audit_change_file, src_temp_audit_merge, src_estout_call, src_winsor_call, src_audit_branch_open, src_audit_branch_drops, src_appendix_a3_state, src_appendix_a9_state, src_appendix_a10_crossref, src_appendix_a11_crossref, inspect_appendix_state_scan

Preparation / proposed procedure:

1. Use the host Stata batch wrapper with the extracted working-copy directory as the runtime directory and consistent relative or approved [redacted-path-c6c4d17b962e] paths.
2. Run the three form-family harmonization blocks, merge by EIN×fyear, construct the documented sample and required variables, then run the main Tables 2–5 code.
3. Run Table 6 against comp.dta and its fixed-effects handoff, then preserve the 2008 baseline temp.dta and run Tables 7–8 against the separately loaded audit-change dataset. These are distinct in-memory branches; do not assume one dataset remains loaded across the transitions.
4. Apply the supported version 16: prefix to each legacy table contents() call in the working copy before any Stata 18 run; retain each call’s variables, conditions and options.
5. Do not continue directly from Tables 7–8 into A3–A9: line 745 replaces the currently active dataset by loading audit change data.dta with clear, line 749 drops f1120, and no later reload/restore is present. First load a documented post-main-analysis snapshot with the A3–A9 fields or obtain its exact producer, schema and reload point; do not assume [masterfile2] is that snapshot.
6. Treat A10 and A11 as cross-references to Tables 7 and 8 above, not independent code blocks. Continue to those references only after the corresponding Tables 7–8 branch has run.

Validation to perform later:

- Before any separately authorized run, verify that all required inputs and handoffs match their recorded schemas and that the documented main-analysis state is restored before A3–A9.
- The self-written two-row Stata 18 probe confirms the minimal version 16: prefix for both a one-way contents call and a Table 4-style two-way row/col call; it does not test the author program or study data.

### act_resolve_appendix_state_reload: Identify and document the main IRS analysis-state snapshot and the point at which A3–A9 must reload it after the Tables 7–8 audit-change branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_appendix_state_reload
Evidence: src_audit_branch_open, src_audit_branch_drops, src_masterfile2_preselection, src_paper_efile_section_start, src_appendix_a3_state, src_appendix_a9_state, inspect_appendix_state_scan

Preparation / proposed procedure:

1. Request the exact post-main-analysis file, its producer, location and schema that contains the fields consumed by A3–A9, including paper, the required p1_* variables, f1120 and the state variables.
2. Confirm the reload point after the Tables 7–8 branch and preserve the audit-change temp.dta branch order. Do not assume the earlier [masterfile2] save supplies the later paper/e-filer and derived analysis fields.
3. If no compatible saved state exists, request the author-documented restore/reconstruction point; do not invent a dataset identity or continue A3–A9 on the audit-change data in memory.

Validation to perform later:

- Before a separately authorized run of A3–A9, inspect the documented restored schema for the actual variables consumed by those blocks and confirm the intended sample/state.

### act_prefix_legacy_table_calls: Prefix each of the 20 legacy table contents() calls with Stata’s built-in version 16: command-version control in the extracted working .do copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: issue_legacy_table_syntax
Evidence: src_legacy_table_calls, src_legacy_appendix_table_calls, probe_legacy_table_compat

**Proposed edit:** `LM_code_IRS 200401.txt:581–581`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
        table inc_cat own_cat  if paper==0,  c(n gaap_aud mean gaap_aud) row col
```

Proposed replacement:
```
        version 16: table inc_cat own_cat  if paper==0,  c(n gaap_aud mean gaap_aud) row col
```

**Proposed edit:** `LM_code_IRS 200401.txt:584–584`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
        table inc_cat debt_cat if paper==0,  c(n gaap_aud mean gaap_aud) row col
```

Proposed replacement:
```
        version 16: table inc_cat debt_cat if paper==0,  c(n gaap_aud mean gaap_aud) row col
```

**Proposed edit:** `LM_code_IRS 200401.txt:1042–1042`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table young owner_inc, c(n beg_gaap_aud)
```

Proposed replacement:
```
				version 16: table young owner_inc, c(n beg_gaap_aud)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1043–1043`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table young owner_inc if beg_gaap_aud==1, c(n beg_gaap_aud)
```

Proposed replacement:
```
				version 16: table young owner_inc if beg_gaap_aud==1, c(n beg_gaap_aud)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1044–1044`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table young owner_inc, c(mean beg_gaap_aud)
```

Proposed replacement:
```
				version 16: table young owner_inc, c(mean beg_gaap_aud)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1054–1054`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table young debt_inc, c(n beg_gaap_aud)
```

Proposed replacement:
```
				version 16: table young debt_inc, c(n beg_gaap_aud)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1055–1055`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table young debt_inc if beg_gaap_aud==1, c(n beg_gaap_aud)
```

Proposed replacement:
```
				version 16: table young debt_inc if beg_gaap_aud==1, c(n beg_gaap_aud)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1056–1056`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table young debt_inc, c(mean beg_gaap_aud)
```

Proposed replacement:
```
				version 16: table young debt_inc, c(mean beg_gaap_aud)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1067–1067`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any owner_inc, c(n gaap_audit)
```

Proposed replacement:
```
				version 16: table raise_eq_any owner_inc, c(n gaap_audit)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1068–1068`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any owner_inc if gaap_audit==1, c(n gaap_audit)
```

Proposed replacement:
```
				version 16: table raise_eq_any owner_inc if gaap_audit==1, c(n gaap_audit)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1069–1069`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any owner_inc, c(mean gaap_audit) 
```

Proposed replacement:
```
				version 16: table raise_eq_any owner_inc, c(mean gaap_audit) 
```

**Proposed edit:** `LM_code_IRS 200401.txt:1079–1079`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any debt_inc, c(n gaap_audit)
```

Proposed replacement:
```
				version 16: table raise_eq_any debt_inc, c(n gaap_audit)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1080–1080`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any debt_inc if gaap_audit==1, c(n gaap_audit)
```

Proposed replacement:
```
				version 16: table raise_eq_any debt_inc if gaap_audit==1, c(n gaap_audit)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1081–1081`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any debt_inc, c(mean gaap_audit) 
```

Proposed replacement:
```
				version 16: table raise_eq_any debt_inc, c(mean gaap_audit) 
```

**Proposed edit:** `LM_code_IRS 200401.txt:1091–1091`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any owner_inc if young==1, c(n gaap_audit)
```

Proposed replacement:
```
				version 16: table raise_eq_any owner_inc if young==1, c(n gaap_audit)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1092–1092`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any owner_inc if young==1 & gaap_audit==1, c(n gaap_audit) 
```

Proposed replacement:
```
				version 16: table raise_eq_any owner_inc if young==1 & gaap_audit==1, c(n gaap_audit) 
```

**Proposed edit:** `LM_code_IRS 200401.txt:1093–1093`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any owner_inc if young==1, c(mean gaap_audit) 
```

Proposed replacement:
```
				version 16: table raise_eq_any owner_inc if young==1, c(mean gaap_audit) 
```

**Proposed edit:** `LM_code_IRS 200401.txt:1103–1103`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any debt_inc if young==1, c(n gaap_audit)
```

Proposed replacement:
```
				version 16: table raise_eq_any debt_inc if young==1, c(n gaap_audit)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1104–1104`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any debt_inc if young==1 & gaap_audit==1, c(n gaap_audit)
```

Proposed replacement:
```
				version 16: table raise_eq_any debt_inc if young==1 & gaap_audit==1, c(n gaap_audit)
```

**Proposed edit:** `LM_code_IRS 200401.txt:1105–1105`
Source SHA-256: `370d9d97137b02017ff93f9bdb2a09b930cf8a3d3188a105b8cec098699dda5b`

Run this legacy contents() table call under the tested Stata 16 command-version compatibility layer; preserve all existing variables, conditions and options.

Current text:
```
				table raise_eq_any debt_inc if young==1, c(mean gaap_audit) 
```

Proposed replacement:
```
				version 16: table raise_eq_any debt_inc if young==1, c(mean gaap_audit) 
```

Preparation / proposed procedure:

1. Apply the listed prefixes only to the extracted working .do copy; keep the frozen TXT unchanged.
2. Leave the existing variables, conditions, statistics, row and column options unchanged.

Validation to perform later:

- The preserved two-row synthetic Stata 18 probes show rc 198 for current-version legacy contents syntax and rc 0 for the corresponding version 16: calls.
- During any separately authorized full run, inspect the table outputs after applying the prefix; this assessment did not execute the author program or data.


## Remaining issues and prerequisites

- issue_irs_access_status [unresolved; full_pipeline]: The only documented IRS access terms are historical: access was limited to two years, the contract required purge after the related project, and a petition to retain data was contemplated. The historical note describes then-current continuation on related projects, but present 2026 retention, user grant and authorized execution route are unknown; do not presume these inputs remain available.
- issue_import_redaction [unresolved; full_pipeline]: The text starts with transformations on already-loaded IRS form-family datasets and uses abstract [file...] placeholders for form and master files. The datasheet says some raw-to-Stata preprocessing occurred before Stata and some confidential steps are redacted. Exact imports, input schemas, placeholder-to-dataset identities and secure processing setup are not supplied.
- issue_missing_handoffs [unresolved; full_pipeline]: The supplied code consumes audit change data.dta twice and naics_3_fixed_effects.dta once, but this text has no producer for either handoff. The Table 6 merge file must supply naics_3 and fe and is followed by reads of med_assets, med_sales and perc_public; its schema, path and production order remain unresolved.
- issue_missing_variable_mapping [unresolved; full_pipeline]: The complete text has unresolved variable contracts: the Form 1065 mapping creates dateincorporated but the age block consumes dateincorporated_new; Table 2 consumes match/winsor/owner-category fields such as gaap_aud_match, p1_gaap_match, audit_match, wtot_income_new_mil, wowner and owner_eq_1 without a producer in this file. These may be supplied by an undocumented input, so confirm the producer/schema rather than inventing aliases or transformations.
- issue_compustat_contract [unresolved; full_pipeline]: Table 6 requires prepared comp.dta and uses year separately from fyear for de-duplication/lags. The exact raw-to-prepared `year` mapping is not supplied. The branch expects count2, comp and ratio fields at collapse but does not define them; it does construct lev, btm, mtb, roa, pm, ppe_ratio, growth and other core ratios from raw Compustat fields. It also emits roa_sd_win in the first collapse but consumes roa_sd in the second. The locally readable COMP.FUNDA candidate does not establish the prepared-file mapping, missing aliases or required history, so the route remains unverified for those reasons.
- issue_paths_driver [preparation; full_pipeline]: The Stata code is stored in a TXT document and contains Windows-specific roots for three inputs and temporary outputs. Preparing a working .do copy and converting all affected paths to a consistent relative execution directory is routine setup. The separate [file...] identities, absent inputs and producers remain unresolved under the other issues.
- issue_appendix_state_reload [unresolved; full_pipeline]: The supplied text opens `audit change data.dta` with `clear` at line 745 and drops `f1120` at line 749. Later A3–A9 code consumes main IRS analysis state such as `paper`, `p1_*`, `f1120` and the state variables, but the source contains no subsequent `use`, `restore` or `preserve` command. The named `[masterfile2]` save is at line 172, before the paper/e-filer classification begins at line 177, and is not established as the required analysis snapshot. The exact post-main-analysis file, schema and reload point remain unknown. A10/A11 refer back to Tables 7/8 rather than supplying independent analysis code.
- issue_legacy_table_syntax [preparation; full_pipeline]: The Stata source contains 20 legacy `table ..., c(...)` calls. A self-written two-row Stata 18 probe returns rc 198 with the default command version (`option contents() not allowed since Stata 17`); the same one-way and Table 4-style two-way calls return rc 0 under the built-in `version 16:` prefix. A minimal supported source-preparation edit is available for the calls.
- req_irs_1120 [undetermined]: Parent-level consolidated Form 1120 C-corporation input combined with its Schedule M-3 fields, for fiscal years 2008–2010 and the documented asset/e-filing population. One of three jointly required IRS filer-family inputs.
- req_irs_1120s [undetermined]: Parent-level consolidated Form 1120S S-corporation input combined with its Schedule M-3 fields, for fiscal years 2008–2010 and the documented asset/e-filing population. Jointly required with the 1120 and 1065 inputs.
- req_irs_1065 [undetermined]: Parent-level consolidated Form 1065 partnership/LLC input combined with its Schedule M-3 fields, for fiscal years 2008–2010 and the documented asset/e-filing population. Jointly required with the 1120 and 1120S inputs.
- req_compustat [undetermined]: The Compustat input used by the supplied Table 6 code. It needs annual firm-year fields and derived variables for the code’s 2005–2010 filter, industry-year construction, lags and collapse. The code reads a prepared comp.dta file; the exact author extraction/field mapping is not verified.
- req_audit_change [undetermined]: Separate prepared audit-change data file directly consumed by the supplied Tables 7–8 branch. Its producer, current path, full fields and compatibility with the preceding IRS workflow are unresolved.
- req_fixed_effects [undetermined]: The naics_3_fixed_effects.dta file merged by the supplied Table 6 branch. Its producer, fields beyond the documented fe variable, path and compatible industry keys are unresolved.

## Review notes

- LM_code_IRS 200401.txt is classified as a document in inventory, but its full contents are substantive Stata preparation and analysis code. The target has code, requires extraction/reflow, and is not a no-code release.
- All supplied branches remain in the full-pipeline scope. The data sheet and appendix describe benchmarking with RMA, Sageworks, SUSB and SOI, but the bounded whole-word scan of the 1,403-line Stata text finds no such input branch. Compustat is mandatory because code reads comp.dta and merges the Table 6 fixed-effects file.
- The package inventory contains no prepared .dta or .sas7bdat input. Three IRS filer-family inputs, Compustat data and the two named handoffs are separately required; no analysis-only scope is justified without a compatible analysis-input route.
- Historical IRS access/retention/purge language does not establish present 2026 retention, user authorization or a usable secure route. No current status is inferred.
- The frozen dependency checklist is empty; literal source reads and merges were manually traced. No author code, regression, compile, installation or dataset download was run. The only data read was a row_limit=1 metadata probe of the exact catalog-listed COMP.FUNDA SAS file; Stata probes only queried runtime version and actual command availability.
