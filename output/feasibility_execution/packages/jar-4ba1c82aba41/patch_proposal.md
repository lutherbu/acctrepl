# Patch proposal: jar-4ba1c82aba41

Auditors’ Use of In-House Specialists

DOI: 10.1111/1475-679X.12485

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

All analyses and manual preparation procedures actually documented in the supplied online appendix (A1–A10); publication-wide programs or outcomes not present in this release are not invented as stages.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 4/12485 - Auditors-Use-of-In-House-Specialists/zblm-online-appendix.pdf",
      "sha256": "f2698b0333e55bb770a0397f89e0bf51df9bc575873f925cc1b46e029c3aa233"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "610764ac4f4e81401f337aa9e368d99f2b5041c2fcee48fe32b85c457a9b980f"
}
```

## Proposed actions

### act_recover_author_workflow: Recover the contemporaneous author workflow, prepared input manifest/data dictionary, source-to-field map, full Appendix A definitions, and manual preparation handoffs. Clarify whether the A6 Anantharaman comparison is an in-scope branch and, if so, obtain its documented author-data handoff.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_remaining_appendix_variables, iss_no_executable_workflow, iss_input_and_method_contract, iss_a6_related_data_branch
Evidence: EV_SOURCE_TRACE, EV_SRC_A2, EV_SRC_A4_SAMPLE, EV_SRC_A6_DATA, EV_SRC_A7, EV_SRC_A10_HISTORY, EV_SRC_A10_10K

Preparation / proposed procedure:

1. Locate the actual archived contemporaneous programs, run instructions, prepared data manifest, dictionary, and intermediate-table handoffs for the appendix analyses.
2. Record the documented data unit, identifiers, raw fields, joins, periods, sample restrictions, producer order, and variable definitions from those materials.
3. Confirm whether the A6 comparison is part of the required branch and identify its actual author-shared input and merge instructions only if it is.
4. Retain the appendix's A7 keyword crosswalk and A10/A2 construction recipes while resolving the source columns and matching rules from the archived workflow.

Validation to perform later:

- Statically reconcile every in-scope A1–A10 procedure with its archived producer, source fields, row unit, and input handoff before any separately authorized execution.

### act_resolve_pcaob_specialist_input: Identify the actual documented route to the PCAOB proprietary specialist-hour/category records or a compatible author-prepared file, together with the fields and matching rules needed for the A7 manual classification.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_pcaob_specialist_records
Evidence: EV_SRC_A7, EV_PCAOB_CATALOG_CANDIDATE, EV_SOURCE_TRACE

Preparation / proposed procedure:

1. Check the archived input manifest and contemporaneous preparation notes for the actual specialist-hour file, its identifiers, period, and authorized delivery route.
2. Recover the source-column mapping and the documented text matching, normalization, and collision-precedence rules for the A7 category keywords.
3. If the source remains restricted, record the documented authorization route; do not treat the firm/report-level catalog candidate as a substitute.

Validation to perform later:

- Compare a documented input's field names, unit, identifiers, period, and matching rules to the actual A7 recipe before marking a route verified.

### act_resolve_compustat_fields: Recover the Compustat fields, accounting definitions, firm identifiers, periods, and joins used in the A4 selection sample and other in-scope appendix models; the local COMP.FUNDA metadata probe establishes readability only.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_compustat_firm_data
Evidence: EV_SRC_A4_SAMPLE, EV_REGISTERED_CATALOG, EV_COMP_FUNDADATA

Preparation / proposed procedure:

1. Obtain the author field map and sample-selection specification for the six-largest-firm FY 2004–2018 A4 sample and any other required Compustat models.
2. Map each specified raw field and key to the candidate COMP.FUNDA columns and establish the required period and observation unit from authorized metadata.

Validation to perform later:

- Keep the route unverified until the documented fields, identifiers, sample population, and required historical coverage match the author specification.

### act_resolve_audit_analytics_feeds: Recover the Audit Analytics feed/table and field mapping, observation timing, and joins used for the A4 inspected and uninspected engagement sample; catalog candidates alone do not identify the author's sources.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_audit_analytics_selection_sample
Evidence: EV_SRC_A4_SAMPLE, EV_REGISTERED_CATALOG, EV_AUDIT_CATALOG_CANDIDATES

Preparation / proposed procedure:

1. Use the contemporaneous author data dictionary or input manifest to identify the exact Audit Analytics feed(s), unit, fields, and inspected/uninspected sample rules.
2. Document the report/fiscal-year timing and link keys joining Audit Analytics, Compustat, and the specialist records.

Validation to perform later:

- Verify the selected feed metadata and author field/period mapping against the six-largest-U.S.-firm FY 2004–2018 sample before marking the local route verified.

### act_resolve_10k_matching: Recover the authors' exact 10-K filing selection, client/fiscal-year match, amendment handling, sample median, and source-version rule before using the documented Loughran–McDonald N_Words product or local cleaned 10-X texts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_10k_word_length
Evidence: EV_SRC_A10_10K, EV_LM10X_PUBLIC, EV_REGISTERED_CATALOG

Preparation / proposed procedure:

1. Recover the archived filing-to-client/fiscal-year key and selection rule, including treatment of amended or duplicate filings and required sample coverage.
2. After the required keys and source version are specified, select the documented public summary or compatible local 10-X route and map N_Words to H_CL_COMPLEX as described.

Validation to perform later:

- Check the specified filing identifiers, FORM_TYPE, source period/version, duplicate-selection rule, and sample-median calculation against the author instructions before verifying the route.

### act_verify_stata_command: Stata 18 is present, but the A4-named heckprobit_fixedrho command was not found on the checked default adopath. Recover its actual author-cited release/provenance and intended path before deciding whether setup is needed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: soft_stata, soft_heckprobit_fixedrho, iss_command_not_found_default
Evidence: EV_ENV, EV_SRC_A4_CMD, EV_HECKPROBIT_METADATA

Preparation / proposed procedure:

1. Recover the command version, source, invocation syntax, and path/setup instructions from the contemporaneous author materials and cited implementation.
2. Check the exact command on the documented Stata 18 environment after its intended configuration is established; defer any installation until the actual required source and compatibility are known.

Validation to perform later:

- Confirm the documented command resolves on the intended Stata path and its supported call matches the archived A4 procedure before planning an authorized run.


## Remaining issues and prerequisites

- iss_no_executable_workflow [blocking; full_pipeline]: The assigned release contains one online-appendix PDF and no executable author program or complete driver. It does provide manual specialist classification and analytic variable-construction recipes, which are credited, but they are not directly executable.
- iss_input_and_method_contract [unresolved; full_pipeline]: No empirical data, source-to-field map, data dictionary, manual crosswalk, or complete variable definitions are supplied. The appendix identifies some products, populations and selected construction rules but leaves exact identifiers, joins, source fields, history, keyword matching behavior, and many definitions unresolved.
- iss_command_not_found_default [unresolved; full_pipeline]: A4 explicitly names heckprobit_fixedrho. The Stata 18 command-specific query did not find it on the checked default adopath; its intended release, provenance, alternate path and supported interface remain unknown, so this does not establish a general access barrier.
- iss_a6_related_data_branch [unresolved; full_pipeline]: A6 describes an Anantharaman comparison using author-shared data for overlapping years 2004–2012, but the appendix does not establish whether this is an in-scope execution branch or provide its exact data/driver handoff. Clarify that branch before treating it as a required input; Form 5500 is not added as a mandatory source.
- req_pcaob_specialist_records [undetermined]: PCAOB proprietary engagement-level specialist-hour/category records needed by the A7 manual category mapping and by specialist-use measures. The appendix does not name source columns, engagement/firm identifiers, data period, or record-level matching and preparation. No compatible author-prepared records are included.
- req_compustat_firm_data [undetermined]: Compustat-derived firm financial characteristics needed in the A4 six-largest-firm selection sample and other appendix models. The appendix does not identify exact source variables, identifiers, financial-statement definitions, joins, or all required periods.
- req_audit_analytics_selection_sample [undetermined]: Audit Analytics inputs for the inspected and uninspected audit-engagement selection sample of the six largest U.S. firms described in A4. Exact required feeds, observation unit, report/fiscal-year timing, fields and joins to Compustat/PCAOB are not given.
- req_10k_word_length [undetermined]: Filing-level 10-K word-length input used by A10 to construct H_CL_COMPLEX. The appendix names Loughran and McDonald (2020) and compares word length to the sample median; exact filing-to-client/fiscal-year matching and amendment/duplicate selection are not specified.
- req_remaining_appendix_variables [undetermined]: All other empirical inputs needed for A1–A10, including outcome measures, client and auditor controls, team/specialist histories, sample partitions, entropy-balancing covariates and linked model variables. The appendix delegates many definitions to the absent paper Appendix A and does not give a complete data dictionary, input panel, row unit, IDs, sample restrictions or producer order.
- soft_heckprobit_fixedrho [unverified]: A4 explicitly names this Stata command. A command-specific Stata 18 which query completed but did not find it on the checked default adopath; any alternate configured path, package provenance and supported interface remain unverified.

## Review notes

- An early populated source checkpoint and trace were saved before optional resource probes; the trace covers the full 870-line cached appendix.
- The coordinator README-selector helper asserted no records before source display. That is retained as a documented selector limitation, was not retried, and is not treated as evidence that no workflow exists.
- The appendix supplies substantive manual A7 specialist classification and A2/A4/A10 construction procedures, but no executable author program, complete driver, or empirical data. One full_pipeline scope covers all procedures actually documented in A1–A10; no separate analysis_only route or publication-wide implementation is invented.
- A6's author-shared Anantharaman data for overlapping 2004–2012 are retained as a conditional related-analysis branch. The assessment does not make Form 5500 or another underlying source a mandatory input without evidence that the branch is required.
- Catalog and bounded metadata evidence show a readable one-row COMP.FUNDA probe, multiple Audit Analytics table candidates, and a PCAOB-named firm/report aggregate table that does not match specialist-hour records. All remain unverified against the authors' exact fields, keys, periods, and sample.
- The author-hosted 10X Summaries page documents a current 1993–2025 product with filing identifiers and N_Words; no payload was requested, and exact filing/sample matching, amendment selection, and source-version compatibility remain unresolved.
- The A4 command-specific Stata 18 query completed but did not find heckprobit_fixedrho on the checked default adopath. This is recorded as unresolved rather than a general access barrier; no installation was attempted.
- The frozen named-product CLI failed because its sibling resources.py was absent; a first direct catalog helper also stopped on a tuple/list construction error, before yielding findings. Both failures and their captured process streams/status are preserved separately from the corrected bounded catalog results.
- A first resource-expansion helper likewise failed before draft mutation because it named a nonexistent probe artifact; its exact status/traceback is preserved, and a corrected version completed. The initial `python` command failure has unknown exit/stream capture and remains process-only.
- EV_AUTH_SCAN_PROCESS, EV_BAD_PYTHON_PROCESS, EV_LOOKUP_CLI_PROCESS, and EV_DIRECT_CATALOG_FAIL_PROCESS are process-history evidence only and are intentionally absent from all scientific evidence_ids lists.
- No author program was run or imported, no model/estimator was executed, no source data or external payload was downloaded, and no source edits or installations were made.
