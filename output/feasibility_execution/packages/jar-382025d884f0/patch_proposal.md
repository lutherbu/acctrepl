# Patch proposal: jar-382025d884f0

Profit Persistence in the U.S. Audit Market

DOI: 10.1111/1475-679X.70029

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | restricted_access_required | no_runnable_code |

### full_pipeline

Complete author-documented manual and analytical workflow, including ADR data construction, inspection-finding classification, the paper analyses and online-appendix analyses; no executable program is supplied.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 2/70029 - Profit-Persistence-in-the-U-S-Audit-Market/ck-datasheet.pdf",
      "sha256": "f2f4b01b06b41d2f066f17824763e75319b8a2472331fbffe8fa5435788a39f3"
    },
    {
      "path": "JAR-Volume 64/Issue 2/70029 - Profit-Persistence-in-the-U-S-Audit-Market/ck-online-appendix.pdf",
      "sha256": "0b14e9c3ba1bfa445d961283d31482c2d3a2e988f59aef046457b4c368bf6771"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "25e7496956644a32aab90afae558e79ea3e979533ed0e3f5d095a69677b7e3d2"
}
```

## Proposed actions

### action_request_pcaob_access: Request authorized access to the study-period ADR data and the inspected-engagement findings data, with all analysis performed in the PCAOB-approved secure environment.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: req_pcaob_adr, req_pcaob_findings
Evidence: ev_secure_server, ev_permission, ev_adr_sample, ev_inspection_fields, ev_adr_filters, ev_adr_variables, ev_adr_dependency, ev_adr_partner

Preparation / proposed procedure:

1. Ask the authors/PCAOB for permission to replicate using the ADR and non-public inspection-finding inputs.
2. Confirm the approved PCAOB secure-server environment and permitted analysis workflow; do not move protected records outside the approved environment.
3. Obtain the author data dictionary and coverage details needed to verify the 2008–2016 sample, CIK matching and inspected-engagement subset.

Validation to perform later:

- Confirm authorization, approved environment and data dictionary for both PCAOB inputs.
- Within the approved environment, verify the ADR sample period/filters and the finding fields and inspection-subset coverage against the documented workflow.

### action_request_programs: Request authorized access to the retained PCAOB programs and logs and the missing workflow specifications; the provided manual steps should be preserved as the documented workflow rather than treated as absent.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: issue_missing_author_program, issue_workflow_closure
Evidence: ev_program_status, ev_permission, ev_manual_workflow, ev_process_sections

Preparation / proposed procedure:

1. Ask the authors/PCAOB for permission and access to the programs and logs they retain for replication.
2. Request the program language/version, actual entry/supporting files, invoked packages, execution order, generated files and required manual steps.
3. Request the data dictionaries and output/merge contracts needed to connect the retained workflow to the five documented data requirements.

Validation to perform later:

- Inventory only the authorized delivered program materials and confirm they cover the documented conversion, analysis and online-appendix branches.
- Confirm the required runtime and software from the received author instructions before selecting any local software route.

### action_clarify_commercial_inputs: Clarify the author-selected Compustat, Audit Analytics and CRSP products and their exact field, key, vintage, period and history contracts before relying on local catalog candidates or acquiring any provider data.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: req_compustat, req_audit_analytics, req_crsp_returns, issue_workflow_closure
Evidence: ev_catalog, ev_sources, ev_comp_aa_intersection, ev_crsp_returns, ev_lagged_compustat, ev_cik_match

Preparation / proposed procedure:

1. Ask for the exact source tables/files, release or vintage, fields, identifiers, date coverage and transformations used from each provider.
2. Confirm the CIK-based matching/intersection rules for Compustat and Audit Analytics and the date/security mapping, return frequency and prior-period requirement for CRSP.
3. After those specifications are available, map them to any licensed local candidate or obtain the required provider inputs under the applicable license; use bounded metadata probes before treating a route as compatible.

Validation to perform later:

- Check each candidate against the author-specified product, fields, identifiers, period and required lag history; do not infer compatibility from provider labels or catalog hits.
- Confirm any local route with a successful bounded readability probe and the complete expected native field set from one underlying source.

### action_conditional_author_run: Once the required permissions, inputs, specifications, author programs and runtime are available, follow the author workflow in its documented order and keep PCAOB analyses within the approved secure environment.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: req_pcaob_adr, req_pcaob_findings, req_compustat, req_audit_analytics, req_crsp_returns, issue_missing_author_program, issue_workflow_closure
Evidence: ev_secure_server, ev_manual_workflow, ev_adr_sample, ev_online_scope, ev_adr_filters, ev_process_sections, ev_adr_dependency

Preparation / proposed procedure:

1. Use the actual author-provided entry program and supporting programs after their identity and execution order have been confirmed.
2. Apply the documented ADR sample filters and CIK matching, construct the variables through the author-provided workflow, classify Part I findings for inspected engagements and execute the required main and online-appendix analyses.
3. Use only the author-prescribed environment and data access method; keep restricted PCAOB material on its approved secure servers.

Validation to perform later:

- Compare reproduced sample counts, regression tables and figures with the manuscript and supplied online appendix, preserving documented analyses and sample definitions.
- Record environment, data coverage, run logs and any remaining discrepancy without exporting restricted PCAOB data.


## Remaining issues and prerequisites

- issue_missing_author_program [blocking; full_pipeline]: The assigned package inventory contains only the datasheet and online appendix. The datasheet says the programs that convert raw data to the final dataset and perform the analysis, including logs, are proprietary to PCAOB and retained there for replication with permission. The package documents manual source and sample-construction steps and analytical procedures, but supplies no runnable program; this is a no-code package outcome, not evidence that no workflow exists. The runtime, language and required software are not identified.
- issue_workflow_closure [unresolved; full_pipeline]: The datasheet gives a high-level manual workflow: select/filter the ADR sample, match by CIK, construct variables and classify findings; it points to manuscript Sections 3–6, Appendix A and OA6 for definitions. Without the referenced program, data dictionary and exact input files, the specific source tables/fields, join and construction details, producer-consumer order, output contracts, software and required history remain unresolved. The frozen dependency checklist has zero IDs, which does not establish complete workflow closure.
- req_pcaob_adr [restricted_access_required]: PCAOB Annual Data Request (ADR) engagement-level data used for the Big 4 sample and the realization, projected-realization, hours, partner and persistence measures. The data sheet identifies a 2008–2016 sample, exclusions for non-operating/benefit-plan/shell/blank-check companies and observations without CIK, and CIK matching to Audit Analytics and Compustat. Exact ADR file/release and native field names are not supplied.
- req_pcaob_findings [restricted_access_required]: PCAOB non-public inspection-findings data for the subset of inspected engagements, including issuer, CIK, auditor, fiscal year and Part I finding information; the datasheet also describes finding text, standards and accounting area. Exact file/schema and subset coverage are not supplied.
- req_compustat [undetermined]: Compustat inputs used for firm financial variables and for CIK matching to the ADR sample. The submitted materials do not identify the exact Compustat product/table, release, native fields or file format. Variable definitions indicate prior-year Compustat values are needed for some constructed variables.
- req_audit_analytics [undetermined]: Audit Analytics inputs used for audit-related variables and matched with Compustat for the publicly available data analyses. The exact Audit Analytics products/tables, fields, release, match keys beyond the documented CIK use, and coverage are not specified.
- req_crsp_returns [undetermined]: CRSP return input used to construct Returns and Lag(Returns). The supplied materials do not specify the CRSP product/table, return frequency, security identifier mapping, date window or delisting treatment; the prior return period required for Lag(Returns) must be confirmed.

## Review notes

- The approved registered-source viewer covered all 241 datasheet rows and all 1,698 online-appendix rows in bounded ranges; no row was masked. The documents provide manual data/source steps, equations, variable definitions and analytical tables, not an embedded runnable program.
- The zero-row dependency checklist was not treated as proof of an empty workflow. No analysis_only scope was added because no author-prepared analysis dataset or executable analysis route is supplied.
- No program language, runtime/version or required software can be identified from the submitted materials; software remains unspecified pending author instructions.
- The readiness classification should use the literal no_runnable_code value because the package supplies no executable program, while retaining the documented manual workflow and named inputs.
