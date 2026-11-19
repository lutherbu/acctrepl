# Patch proposal: jar-74534fc3a2c6

How Do Firms Respond to Corporate Taxes?

DOI: 10.1111/1475-679X.12405

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

As-downloaded Stata data-preparation workflow: construct annual short files, full/clean panels, sample_panel and sample_panel_graham from IRS Form 1120 extracts; then generate sample_bins and zeroes before both supplied Misc consumers. The package does not include a separate paper estimator.

Entry points: `programFiles_Aug2021/generateData.do`, `programFiles_Aug2021/sample_bins.do`, `programFiles_Aug2021/zeroes.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 3/12405 - How-Do-Firms-Respond-to-Corporate-Taxes/cpss-datasheet-code-and-identifiers.zip",
      "sha256": "7262b41f53ec23a02d10a152e6c5807216cffe8b1b50f817b8351261ac9ad63b"
    },
    {
      "path": "JAR-Volume 60/Issue 3/12405 - How-Do-Firms-Respond-to-Corporate-Taxes/cpss-online-appendix.pdf",
      "sha256": "9e707a6124e09c1cb5c7ac521ef55acc2d740847f0c30173ccdb583172cfd703"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "69305a6cb3b5aae338c3462ae88327af4358109f3dedd01ff0f27f9e74c2019f"
}
```

## Proposed actions

### A_ACCESS_TAX1120: Confirm permitted user eligibility and obtain the authorized annual Form 1120 inputs required by the as-downloaded preparation workflow.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_TAX1120, I_TAX_ACCESS
Evidence: E_TAX_SOURCE, E_RESTRICTED_ACCESS, E_MASKING, E_CATALOG, E_CATALOG_LOOKUP

Preparation / proposed procedure:

1. Confirm that the intended user and environment are authorized for the IRS/Treasury records under the applicable IRC §6103 controls.
2. Through the authorized route, stage f1120y2004.dta through f1120y2015.dta with the masked source columns required by generateData.do; keep the authors' historical source date as context, not an extra access prerequisite.
3. Do not replace the taxpayer microdata with public SOI aggregates, Compustat, or another proxy product.
4. Keep the files in a restricted, writable project root and launch from the relative programFiles_Aug2021 working directory only after the field contracts below are resolved.

Validation to perform later:

- After access is separately authorized, use a bounded metadata check in the approved environment to confirm each required annual file and named input column; do not infer the user's access from author affiliation or catalog results.
- Confirm coverage and the masked-column mapping with the authorized data documentation; no taxpayer files were read in this assessment.

### A_RESOLVE_MASKED_FIELDS: Obtain the authors' permitted crosswalk for the two revenue variables consumed downstream and determine how they are preserved in the generated sample panel.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MASKED_FIELD_CONTRACT, R_TAX1120
Evidence: E_INPUT_KEEP_LIST, E_CONSUMED_MASKED_FIELDS, E_RESTRICTION_CONSUMER, E_MASKING

Preparation / proposed procedure:

1. Obtain the documented source or derived-variable definitions for totIncm and toid_varcm, including their intended relationship to the retained receipts field, if any.
2. Confirm which variable is used for the restriction regression and percentile globals and which is used by the two Misc trims; preserve the distinct names until the crosswalk is supported.
3. Only after a documented mapping, update a working copy's producer/keep steps so the required values survive through sample_panel.dta. Do not guess a rename or substitute receipts.

Validation to perform later:

- In a later authorized run, confirm the mapped variables exist in sample_panel before each restrictions.do invocation and at both Misc trim conditions.
- Check the full producer-to-consumer mapping without changing the revenue restrictions or sample definitions.

### A_RESTORE_CF_LB: In a working copy, separate the existing cf_lb assignment from its star-comment line; the expression exactly matches the active lower-bound definition in zeroes.do.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_CF_LOWER_BOUND_BINDING
Evidence: E_CF_COMMENTED, E_CF_ACTIVE_COMPARATOR, E_COMMENT_MANUAL, E_CF_USE

**Proposed edit:** `programFiles_Aug2021/generateData.do:274–275`
Source SHA-256: `bf421128392f444199626c7362c70c435906ad3a1d1f50aaa802716169df0311`

The leading asterisk causes Stata to ignore all of line 274, including the local assignment. generateData.do already defines cf_lb1=500, uses cf_lb in the next active filter, and zeroes.do contains the same active expression; restoring it on its own line preserves the authored 500-unit buffer definition.

Current text:
```
		*identifying the counterfactual sample: 				local cf_lb = `v' + `cf_lb1'
			local cf_ub = `v' + `cf_ub1'
```

Proposed replacement:
```
		*identifying the counterfactual sample:
			local cf_lb = `v' + `cf_lb1'
			local cf_ub = `v' + `cf_ub1'
```

Preparation / proposed procedure:

1. Apply this proposal only to a working copy of programFiles_Aug2021/generateData.do; preserve the original CRLF source and indentation in the staged copy.
2. Keep the local expression and all existing kink, window, and buffer values exactly as authored.

Validation to perform later:

- After data access is authorized, verify the staged file contains the standalone local cf_lb assignment and retain the later filter unchanged; do not use a syntax or data trial during this assessment.

### A_STAGE_GENERATED_INPUTS: Interleave the supplied sample_bins and zeroes producers after sample_panel exists and before generateData.do's two Misc consumers.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I_DRIVER_ORDER
Evidence: E_WORKFLOW_OUTPUTS, E_MISC_CONSUMERS, E_SAMPLE_BINS_CHAIN, E_SAMPLE_BINS_OUTPUT, E_ZEROES_CHAIN, E_ZEROES_FILTER, E_ORDEREDTRACE

Preparation / proposed procedure:

1. Use a writable host-visible staging root and set the current directory to its programFiles_Aug2021 subdirectory so every relative use, save, append, do, and merge resolves in one coherent authored folder.
2. Run the generateData.do preparation section through line 317 in a staged copy. It produces annual f1120_YYYY_short.dta files, full_panel.dta, clean_panel.dta, sample_panel.dta, and sample_panel_graham.dta.
3. Run sample_bins.do after sample_panel.dta exists. It calls restrictions.do, uses sample_panel.dta, and writes sample_bins (with Stata's default .dta extension).
4. Run zeroes.do after the panel is ready. It creates cross_2.dta, writes an initial zeroes.dta grid, then filters and overwrites zeroes.dta with the authored bin subset.
5. Resume the two generateData.do Misc sections, lines 329–368, only after both companion outputs exist. Each Misc branch calls restrictions.do before consuming the corresponding generated file.
6. Keep all runs under the same relative project working directory so the companion files and main driver's unqualified filenames identify the same files; do not treat them as independent external data requirements.

Validation to perform later:

- In a later authorized run, verify the generated filenames and current-directory resolution at each stage before allowing the matching downstream merge; check no stale same-name file is consumed.
- Confirm the response branch's merge uses the generated sample_bins and the bunching-bin merge uses the final overwritten zeroes.dta; no output-fidelity calculation is authorized here.

### A_DROP_UNPRODUCED_SAMPLE: Remove the unproduced sample token from both Step Four and Step Five drop lists in a working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_DROP_UNPRODUCED_SAMPLE
Evidence: E_INPUT_KEEP_LIST, E_SAMPLE_KEEP_NEW_SAMPLE, E_DROP_SAMPLE4, E_DROP_SAMPLE5, E_DROP_MANUAL

**Proposed edit:** `programFiles_Aug2021/generateData.do:299–299`
Source SHA-256: `bf421128392f444199626c7362c70c435906ad3a1d1f50aaa802716169df0311`

sample is excluded by the earlier explicit keep list and never generated; new_sample is the actual sample flag.

Current text:
```
	drop post_time_var mode_mo tax_year_var tax_mo wtf sample new_sample
```

Proposed replacement:
```
	drop post_time_var mode_mo tax_year_var tax_mo wtf new_sample
```

**Proposed edit:** `programFiles_Aug2021/generateData.do:315–315`
Source SHA-256: `bf421128392f444199626c7362c70c435906ad3a1d1f50aaa802716169df0311`

sample is excluded by the earlier explicit keep list and never generated; no later sample token is needed when retaining the everSample subset.

Current text:
```
	drop post_time_var mode_mo tax_year_var tax_mo wtf sample
```

Proposed replacement:
```
	drop post_time_var mode_mo tax_year_var tax_mo wtf
```

Preparation / proposed procedure:

1. Apply both line changes to the same staged copy; retain each other listed drop variable and all sample/everSample conditions.

Validation to perform later:

- After a later authorized data run, confirm Steps Four and Five complete their variable cleanup while retaining the authored sample definitions and output variables.

### A_CLOSE_SAMPLE_BINS_COMMENT: Close the trailing block comment at the end of sample_bins.do in a working copy so the archived printed counts remain comment text.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_SAMPLE_BINS_COMMENT_TAIL
Evidence: E_SAMPLE_COMMENT_TAIL, E_SAMPLE_BIN_OUTPUT, E_COMMENT_MANUAL

**Proposed edit:** `programFiles_Aug2021/sample_bins.do:81–81`
Source SHA-256: `b35b1f753042f54b262b8629199a005d8a34ebd02d87189fbba36b57fe3cc90b`

The file opens a block comment after the active save sample_bins command and ends without the matching delimiter. Closing it at EOF preserves the printed counts as comments and exposes no additional commands.

Current text:
```

```

Proposed replacement:
```
*/
```

Preparation / proposed procedure:

1. Apply the closer only in the staged working copy at the file tail; leave the commented session counts untouched.

Validation to perform later:

- In a later authorized Stata run, confirm the supplied count text stays commented and sample_bins.do reaches its save command; do not trial the code in this assessment.


## Remaining issues and prerequisites

- I_TAX_ACCESS [unresolved; full_pipeline]: The workflow requires confidential annual Form 1120 taxpayer extracts. The package supplies programs and documentation, not the data. The authors state IRC §6103 access restrictions, but the user's eligibility and access are unknown.
- I_MASKED_FIELD_CONTRACT [unresolved; full_pipeline]: The annual input is reduced to the explicit keep list in generateData.do. Later restrictions.do consumes totIncm, and the misc branches consume toid_varcm; neither is generated or retained by the supplied preparation code. Do not assume either name aliases receipts or another input field.
- I_CF_LOWER_BOUND_BINDING [preparation; full_pipeline]: The only generateData.do cf_lb assignment is swallowed onto a line beginning with the Stata asterisk comment marker. The exact local formula is already defined actively in zeroes.do, and generateData.do defines cf_lb1=500 before using cf_lb; a source-mapped newline restoring that authored statement is supported preparation, without changing the counterfactual definition.
- I_DRIVER_ORDER [preparation; full_pipeline]: The exact producer-consumer sequence is source-supported but not orchestrated by the released main file: generateData.do first creates sample_panel; sample_bins.do and zeroes.do then create the intermediates; only after that should generateData.do's Misc branches consume them. A staged working-copy procedure can preserve the authored files and calculations.
- I_DROP_UNPRODUCED_SAMPLE [preparation; full_pipeline]: Step Four and Step Five both name sample in a drop varlist. The earlier explicit keep list excludes sample, and supplied sample construction generates new_sample instead; no producer for sample appears in generateData.do. Remove only the unsupported token from both drop lists in a working copy.
- I_SAMPLE_BINS_COMMENT_TAIL [preparation; full_pipeline]: sample_bins.do opens a block comment after saving sample_bins and the supplied file ends without a matching closer. The apparent console-count text is therefore comment content, not three live commands. Add the closing delimiter at EOF in a working copy; the author sample/bin calculations remain unchanged.
- R_TAX1120 [undetermined]: Annual consolidated U.S. IRS Form 1120 administrative-tax extracts for 2004–2015, with the masked source fields read or retained by the supplied preparation programs. The extracted taxpayer microdata are not included in this package; exact masked-field availability and authorized user access remain unresolved.

## Review notes

- Source review and route discovery are complete; prepared author data are absent from the package, and the restricted route remains user-specific and unverified.
- Datasheet title matches the frozen registered title; README and program headers use 'How Do Private Firms Respond to Corporate Taxes'. Frozen title and DOI remain unchanged, with the actual delivered workflow credited as downloaded.
- The target is the delivered data-preparation workflow and its supplied branches. The source leaves the branch results in memory and contains no separate native bunching estimator; no missing paper-wide estimator has been added as a mandatory prerequisite.
- The static audit was used as discovery only. Its lines 70/73/76 in sample_bins.do are inside the trailing block comment; its seed advisory confuses the deterministic labor-cost fallback with random simulation; its output-table advisory treats the revenue-cutoff helper regression as a paper table.
- No author program, syntax trial, estimator, descriptive/statistical calculation, data read, dataset generation, edit application, or SAS process was run. Catalog discovery and official documentation checks were static only.
