# Patch proposal: jar-22be17983990

The Innovation and Reporting Consequences of Financial Regulation for Young Life-Cycle Firms

DOI: 10.1111/1475-679X.12398

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow across SAS and Stata: accrual-quality and financial-constraint construction, PatentsView/KPSS/claims patent preparation, main and pseudo SOX samples, manually run 17 Zhang and 7 EHW WRDS Eventus events, final regressions, extra-years branch and entropy-balanced footnote panels.

Entry points: `1a-FRQ variables.sas`, `1b-citations.sas`, `1c-patent variables.do`, `1d-financial_constraints.sas`, `2a-variable creation and sample selection.sas`, `2b-event study.sas`, `3-dataset compilation and regressions.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 1/12398 - The-Innovation-and-Reporting-Consequences-of-Financial-Regulation-for-Young-Life-Cycle-Firms/alv-datasheet-code-and-identifiers.zip",
      "sha256": "74c4d0e9de4a2cf288324ead86638a713666d60ae054992c377708509e8eb0ed"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "41c8f19b6375df5242ed4e85a6a010ee752fb6bdf658680b676f903e77c4f613"
}
```

## Proposed actions

### A_VERIFY_LOCAL_ROUTES: Map the sampled local Compustat, CCM, CRSP MSF and Audit Analytics candidates to the author WRDS library names; confirm allowed product vintage, identifier joins and required full date coverage before creating author-compatible working tables.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMPUSTAT, R_LINKTABLE, R_CRSP_MSF, R_AUDIT_ACCEL, R_AUDIT_SOX
Evidence: E_CATALOG, E_CATALOG_SLICE, E_FUNDA_PROBE, E_LINK_PROBE, E_MSF_PROBE, E_AUDIT_ACCEL_PROBE, E_AUDIT_SOX_PROBE

Preparation / proposed procedure:

1. Use the exact candidate paths in the frozen workspace catalog and preserve original variables and units.
2. Confirm dates and link rules against the author code, including CCM linktype/linkdt/linkenddt filters and the required 2001-2008 event/control window.
3. Record the mapping from local library/table aliases to WRDS.FUNDA, WRDS.CCMXPF_LINKTABLE, WRDS.MSF and the two Audit Analytics feeds.

Validation to perform later:

- Using metadata-only or authorized bounded checks, verify required field names and storage types and verify the needed history before later execution; do not treat the existing row_limit=1 probes as coverage evidence.

### A_RESOLVE_AUDIT_FIELDS: Obtain the authorized Audit Analytics restatement table/version or a documented field mapping for every source KEEP-list field before filling the author restatement join.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AUDIT_RESTATE, I_AUDIT_FIELD_MAP
Evidence: E_AUDIT_SOURCE, E_AUDIT_RESTATE_PROBE, E_CATALOG_SLICE

Preparation / proposed procedure:

1. Ask the data provider or author which current fields correspond to RES_CLER_ERR, RES_SEC_INVEST and the six missing RES_*_LIST fields reported by the one-row probe.
2. Only map fields when definitions and keys match; otherwise locate the correct authorized product release.

Validation to perform later:

- Confirm all author KEEP-list names or explicitly documented equivalents, the company-key mapping and date coverage before running 2a.

### A_ACQUIRE_KPSS: Acquire the author-maintained KPSS_2025 public panel through its repository and review the effect of the later vintage before using it in the 1c Stata import.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_KPSS
Evidence: E_KPSS_PUBLIC, E_PATENT_SOURCE

Preparation / proposed procedure:

1. Download the repository's KPSS_2025.csv product using the documented repository route.
2. Confirm patent_num, permno, issue_date and filing_date formats against the 1c import and joins.
3. Record that this route uses a later vintage with updated values than KPSS_2019_public.csv; retain the author-vintage file if supplied separately.

Validation to perform later:

- Check field types, identifiers and required patent-year range before conversion; compare resulting analysis period with the author sample after authorized execution.

### A_MAP_PATENTSVIEW: Resolve current USPTO Open Data Portal products and schema mappings for the four PatentsView TSV inputs, then prepare permitted files for the documented SAS/Stata import steps.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PV_CITATIONS, R_PV_CPC, R_PV_PATENT, R_PV_APPLICATION
Evidence: E_PATENTSVIEW_PUBLIC, E_PV_SOURCE, E_APP_SOURCE

Preparation / proposed procedure:

1. Use the current USPTO ODP bulk product search and complete required account/API-key registration if using that route.
2. Identify the exact replacements for uspatentcitation.tsv, cpc_current.tsv, patent.tsv and application.tsv and obtain file/schema documentation for the author-relevant vintage.
3. Map required identifiers and CPC order/class fields; do not infer a current table from a generic ODP landing page.

Validation to perform later:

- Verify file format, required identifiers/fields, CPC sequence and period coverage before importing; compare generated citations.dta and patent variables only in a separately authorized run.

### A_MAP_CLAIMS: Verify the current availability and schema of the author-named BigQuery table before preparing patent_claims.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PATENT_CLAIMS
Evidence: E_GOOGLE_CLAIMS_PUBLIC, E_CLAIMS_SOURCE

Preparation / proposed procedure:

1. Open the documented patents-public-data.uspto_oce_claims.patent_document_stats_2014 table in the authorized BigQuery environment and inspect its current schema.
2. Confirm pat_no, pat_clm_ct and pat_dep_clm_ct and the required patent coverage, then export/convert using the author-prescribed format.

Validation to perform later:

- Check key uniqueness and required field types before merge; do not infer current coverage from the archived 2017 table index.

### A_REQUEST_BENFORD: Request the prepared Benford fsd dataset or the permitted producer specification, including its exact schema, date coverage and join keys.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_BENFORDS, I_INITIAL_CLOSURE
Evidence: E_BENFORD_SOURCE, E_PREPARED_INPUTS

Preparation / proposed procedure:

1. Ask the authors/data provider whether a compatible perm.benfords table or data-only export is available for the supplied package.
2. If only producer code is offered, request allowed access and the exact input/output contract; do not reconstruct the proprietary Benford measure independently.

Validation to perform later:

- Confirm gvkey, datadate, fsd and date coverage before the 2a join.

### A_REQUEST_DGTW: Request the exact author-prepared DGTW monthly return dataset from Professor Mike Drake or a compatible authorized export.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DGTW, I_INITIAL_CLOSURE
Evidence: E_DGTW_SOURCE, E_PREPARED_INPUTS

Preparation / proposed procedure:

1. Confirm the prepared file, period, firm/date keys and dgtw_bhar construction with the provider.
2. Keep the commented CRSP buy-and-hold fallback inactive unless the author confirms it as an intended alternative.

Validation to perform later:

- Verify data key fields, monthly history and firm-date matching before using the prepared table.

### A_REQUEST_IO: Confirm the authorized WRDS institutional-ownership source, recipe output and exact fields needed to create perm.io_timeseries.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_IO, I_INITIAL_CLOSURE
Evidence: E_WRDS_IO_PUBLIC, E_IO_SOURCE, E_CATALOG, E_CATALOG_SLICE

Preparation / proposed procedure:

1. Use the author-linked institutional-ownership recipe after appropriate account access is available.
2. Ask for the prepared io_timeseries output or provider-confirmed recipe inputs, including rdate, permno and ior definitions.
3. Treat catalogued TFN.S34 as a conditional raw discovery candidate only; establish whether its fields, keys and history support the author's documented ownership recipe before any reconstruction, and do not treat it as the prepared perm.io_timeseries panel.

Validation to perform later:

- Check join keys, scale and coverage against the author sample before the 2a merge; do not infer access from the login page alone.

### A_RUN_EVENTUS: Confirm authorized WRDS Eventus access and output handling, then preserve all 17 Zhang and 7 EHW manual queries with their documented settings and windows.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EVENTUS_RESULTS, S_EVENTUS, I_INITIAL_CLOSURE
Evidence: E_EVENT_REQUESTS, E_EHW_REQUESTS, E_EVENT_SETTINGS, E_EVENT_WINDOWS, E_EVENT_RESULTS, E_EHW_RESULTS

Preparation / proposed procedure:

1. Generate and retain the 24 supplied request files without changing event dates or windows.
2. Through an authorized WRDS Eventus Cross-sectional Daily workflow, use the documented market index, MAR benchmark, no group/pool, autodate and estimation period settings.
3. Save each returned result in the SAS table names expected by 2b, with documented conversion steps and checksums.

Validation to perform later:

- Before 2b import, verify each of 24 result files, result type MAR, permno and both CAR window fields; confirm no event request/result is missing.

### A_DEFINE_SHARED_ROOT: Select one authorized shared writable working root and document consistent SAS WRDS/PERM library mappings and Stata relative paths for all generated cross-language files.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_SHARED_PATHS
Evidence: E_ROOT_PLACEHOLDER, E_STATA_ROOT, E_SAS_EXPORT, E_EXTRA_BRANCH

Preparation / proposed procedure:

1. Choose a shared path visible to SAS and Stata and replace every * placeholder in the execution configuration with consistent paths.
2. Ensure the 1a/1d/2a/2b SAS outputs and 1b/1c/3 Stata outputs resolve to the same named files and working directory.
3. Keep all author-created outputs separate from source data and preserve original files.

Validation to perform later:

- Static path review should show every producer file has a matching consumer path across main, pseudo, extra-years and Eventus branches.

### A_GET_TRIMWINSOR: Obtain the author macro definition for %TrimWinsor and its required include/autocall setup; do not guess its implementation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_TRIMWINSOR
Evidence: E_TRIMWINSOR

Preparation / proposed procedure:

1. Ask the authors for the exact macro source and the version/include path used with 2a.
2. If the macro cannot be supplied, request written confirmation of the intended winsorization behavior and parameter semantics before drafting a replacement.

Validation to perform later:

- Statically confirm the resolved macro implementation uses the author-specified byvar, variables, percentile bounds and output dataset before any authorized run.

### A_CONFIRM_PSEUDO_RULE: Ask the authors for the pseudo branch's event date, post definition and implementation-year logic; preserve the 1993-1999 sample and market-value filer instructions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PSEUDO_EVENT_RULE
Evidence: E_PSEUDO_BRANCH, E_SOX_RULE

Preparation / proposed procedure:

1. Request the intended pseudo event and period flags, including fiscal-year cutoffs.
2. Retain the branch's stated market-value accelerated-filer rule and comment-out of the main 404(b) filter.
3. Do not carry forward or replace 2004/2005 flags without author confirmation.

Validation to perform later:

- Compare the confirmed branch logic with pseudo sample dates before execution and document it as a distinct alternative.

### A_FIX_EXTRA_YEAR_HANDOFF: Align the Stata extra-year consumer with the filename explicitly requested by the 2a extra-years instructions; keep all sample filters and variables unchanged.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_EXTRA_YEAR_HANDOFF
Evidence: E_EXTRA_BRANCH, E_STATA_EXTRA_INPUT

**Proposed edit:** `3-dataset compilation and regressions.do:337–337`
Source SHA-256: `beac79747a68a0cbf8c6f862636cd9aaaeb383d645e34ed9d30ead1c1ed6fb45`

Match the Stata consumer to the author-directed extra-year export name so the documented branch can hand off its produced panel.

Current text:
```
use soxdata_xtrayrs, clear
```

Proposed replacement:
```
use soxdata101920_xtrayrs, clear
```

Preparation / proposed procedure:

1. When the extra-years branch is selected, set its SAS export to the documented soxdata101920_xtrayrs.dta name.
2. Apply the proposed one-line Stata rename so the consumer uses the same basename.

Validation to perform later:

- Statically verify SAS export and Stata input basenames match, then later confirm the produced file exists before importing; no author code was edited in this assessment.

### A_PREP_STATA_PACKAGES: Prepare compatible Stata commands winsor2, outreg2, mipolate and univar in the Stata 18 adopath before running the supplied Stata branches.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_WINSOR2, S_OUTREG2, S_MIPOLATE, S_UNIVAR
Evidence: E_ENVIRONMENT, E_MIPOLATE, E_STATA_EXTRA_INPUT, E_ENTROPY, E_UNIVAR_PROBE, E_UNIVAR_SOURCE

Preparation / proposed procedure:

1. Use an authorized package source or site-managed installation to make winsor2, outreg2, mipolate and univar resolvable to Stata 18.
2. Record versions and adopath/configuration for reproducible use; do not install packages during this assessment.

Validation to perform later:

- Use Stata which/help metadata checks for each command after setup; do not run any author analysis command.

### A_VERIFY_SAS: Resolve the metadata-only SAS launcher service error and confirm the authorized SAS/STAT component for PROC REG without treating the error as an absent license.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: S_SAS, S_SAS_STAT
Evidence: E_ENVIRONMENT, E_FRQ_SOURCE

Preparation / proposed procedure:

1. Ask the site SAS administrator to confirm SAS 9.4 service health and whether SAS/STAT is included for the authorized account.
2. Use only metadata/version/component checks when the service is available; do not start or run supplied author code as part of this assessment.

Validation to perform later:

- Record SAS version and PROC REG/SAS-STAT availability by metadata or official component inventory before considering execution readiness.

### A_RETAIN_EVENT_SOFTWARE: Confirm that the researcher has an authorized WRDS Eventus interface and can export the prescribed Eventus result tables.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: S_EVENTUS
Evidence: E_EVENT_SETTINGS, E_EVENT_REQUESTS, E_EHW_REQUESTS

Preparation / proposed procedure:

1. Confirm account permissions and current Eventus GUI release through the institution's WRDS administrator.
2. Follow the author settings only after access is confirmed.

Validation to perform later:

- Verify that the Eventus interface offers the required Cross-sectional Daily analysis, market index and MAR output fields before preparing result tables.

### A_RESOLVE_OVERALL_CLOSURE: Resolve the remaining external prepared-input and result-schema specifications before recording full-pipeline closure.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_INITIAL_CLOSURE
Evidence: E_README_ORDER, E_DATASHEET_INPUTS, E_PREPARED_INPUTS, E_PATENTSVIEW_PUBLIC, E_GOOGLE_CLAIMS_PUBLIC, E_EVENT_RESULTS

Preparation / proposed procedure:

1. Retain the full ordered 1a-1d, 2a, 2b and 3 workflow and both author-defined sample alternatives.
2. Obtain compatible inputs and the missing code/specifications listed by the linked requirements and issues.
3. Keep the analysis-only scope omitted because no standalone author-provided route bypasses the required preparation stages.

Validation to perform later:

- Review the completed producer-consumer map and all 41 frozen dependency IDs before a future authorized execution decision.

### A_VERIFY_PCFILES: Confirm SAS/ACCESS Interface to PC Files availability for the supplied DTA exports; if unavailable, prepare an authorized compatible SAS-to-Stata serialization/configuration that preserves the analysis data.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS_ACCESS_PCFILES
Evidence: E_PCFILES_DOC, E_CITATIONS_DTA_EXPORT, E_SAS_EXPORT, E_EVENTUS_DTA_EXPORT

Preparation / proposed procedure:

1. Ask the site SAS administrator to confirm the installed/licensed SAS/ACCESS Interface to PC Files product for the SAS 9.4 account.
2. If it is unavailable, configure a SAS Foundation-supported delimited or other Stata-readable handoff with matching Stata import paths, preserving the same observations, variables, values, storage meaning and labels; do not alter scientific definitions or samples.

Validation to perform later:

- Confirm the selected export/import route preserves the required fields, identifiers, values, date meaning and labels before a future authorized run; do not execute a SAS conversion during this assessment.


## Remaining issues and prerequisites

- I_INITIAL_CLOSURE [unresolved; full_pipeline]: The full workflow depends on prepared Benford/DGTW/IO tables, PatentsView/claims sources and manually saved Eventus outputs whose exact compatible current routes or schemas remain unresolved. The identifier-only sample_id.dta is not those analysis inputs.
- I_TRIMWINSOR [unresolved; full_pipeline]: 2a invokes %TrimWinsor but its macro definition is absent from the supplied programs; the intended macro body/parameters and available include path must be obtained before this stage can close.
- I_PSEUDO_EVENT_RULE [unresolved; full_pipeline]: Pseudo branch instructions change sample years and accelerated-filer classification but do not define replacement pseudo event/post/implementation logic; active code otherwise retains main 2004/2005 flags. Do not infer a replacement rule.
- I_EXTRA_YEAR_HANDOFF [preparation; full_pipeline]: 2a instructions direct an extra-years export named soxdata101920_xtrayrs.dta while the Stata consumer reads soxdata_xtrayrs.dta. Align the author-directed producer output and consumer path for that branch.
- I_AUDIT_FIELD_MAP [unresolved; full_pipeline]: The sampled local FEED39 candidate lacks eight names in the author's restatement KEEP list. Determine an authorized compatible Audit Analytics source field mapping before using it; do not assume similarly named fields are interchangeable.
- I_SHARED_PATHS [preparation; full_pipeline]: SAS LIBNAMEs and Stata cd statements are * placeholders, while generated SAS/Stata filenames are passed across languages. Select and document a shared writable root plus aliases before running the programs.
- R_COMPUSTAT [undetermined]: Compustat annual fundamentals used by accrual quality, financial-constraint construction, main/pseudo samples, and Eventus controls.
- R_LINKTABLE [undetermined]: CRSP/Compustat CCM link table needed to map GVKEY observations to PERMNO using valid link periods.
- R_CRSP_MSF [undetermined]: CRSP monthly stock file needed for 12 monthly observations around 2001 controls and Eventus-related return measures.
- R_AUDIT_RESTATE [undetermined]: Audit Analytics restatement notices and author KEEP-list fields required for restatement outcomes.
- R_AUDIT_ACCEL [undetermined]: Audit Analytics accelerated-filer history and event dates required for the main SOX sample.
- R_AUDIT_SOX [undetermined]: Audit Analytics SOX 404(b) internal-control opinion history used for implementation classification.
- R_PV_CITATIONS [undetermined]: PatentsView citation records used to construct citations.dta and forward citation counts.
- R_PV_CPC [undetermined]: PatentsView CPC current classification records required for patent technology class joins.
- R_PV_PATENT [undetermined]: PatentsView patent.tsv input used to create patent.dta and patent_id.
- R_PV_APPLICATION [undetermined]: PatentsView application.tsv read and converted by the supplied patent preparation program.
- R_KPSS [public_acquisition_required]: Author-prepared Kogan et al. patent-level panel file used as KPSS_2019_public.csv.
- R_PATENT_CLAIMS [undetermined]: Google BigQuery claims table used to merge pat_no and patent_claims.dta claim-count fields.
- R_BENFORDS [undetermined]: Prepared perm.benfords dataset supplying fsd for firm-date observations.
- R_DGTW [undetermined]: Prepared monthly DGTW return series supplying dgtw_bhar.
- R_IO [undetermined]: Prepared institutional-ownership time series supplying ior by PERMNO and report date.
- R_EVENTUS_RESULTS [undetermined]: Manual saved Eventus MAR result tables for all 17 Zhang and 7 EHW event requests.
- S_SAS [unverified]: Executable path is present, but the previous metadata-only startup probe returned a TKELS service-load error; do not infer license absence or runtime failure from that probe.
- S_SAS_STAT [unverified]: The active 1a regression requires PROC REG; installed SAS/STAT component and version were not verified.
- S_EVENTUS [unverified]: Manual Eventus GUI and version are described by the author; present account, access and release were not checked.
- S_WINSOR2 [preparation_required]: Required by both final Stata dataset preparation branches; not found by the metadata-only Stata which check in checked adopaths.
- S_OUTREG2 [preparation_required]: Required for supplied regression tables and entropy-balanced footnote tables; not found by the metadata-only Stata which check in checked adopaths.
- S_MIPOLATE [preparation_required]: Required for two interpolation steps in final Stata program; metadata-only which check reports unavailable in checked adopaths.
- S_UNIVAR [preparation_required]: The supplied Stata program uses univar for four descriptive panels; metadata-only which probe reports it unavailable in checked adopaths.
- S_SAS_ACCESS_PCFILES [unverified]: Three active SAS PROC EXPORT statements write .dta handoffs. Official SAS 9.4 documentation limits unlicensed IMPORT/EXPORT support to JMP and delimited formats; installed PC Files product/license capability is unverified.

## Review notes

- Static assessment only: read all seven supplied programs, README and datasheet; no author program, import, compile, statistical/descriptive command, syntax trial or data transformation was run.
- All 41 frozen dependency checklist IDs have an explicit review disposition. Generated intermediates and manual Eventus GUI handoffs are retained; the checklist was treated as discovery evidence and each edge was traced against source text.
- Bounded local SAS metadata probes used row_limit=1 only. They establish sampled readability/field presence, not total records, full-period coverage, source vintage or access entitlement. No whole-file row or line counts were run.
- sample_id.dta contains GVKEY/datadate identifiers only and is not credited as analysis data.
- The current public KPSS route is a compatible later public vintage; using it requires acquisition and careful interpretation because its estimates and vintage differ from the 2019 filename in the supplied code.
- Catalog misses, ODP registration, a WRDS recipe login, and a SAS launcher error are not treated as proof of absent licenses or global access barriers.
- SAS/STAT, live WRDS/Eventus access, exact external source contracts, the missing TrimWinsor macro, pseudo event rules, shared path root and extra-year filename remain unresolved. Execution is not verified.
- Software completeness correction: Stata's active univar descriptive-panel calls are recorded and the metadata-only which check reports univar unavailable. eststo is separately confirmed by a metadata-only which probe; esttab, estpost, estadd, reghdfe, ftools and ebalance use exact successful environment/probe keys.
- Three active SAS PROC EXPORT statements write Stata .dta handoffs. Official SAS 9.4 PC Files documentation says unlicensed IMPORT/EXPORT access is limited to JMP and delimited formats; PC Files component/license status remains unverified, with no SAS retry or license inference.
- Coordinator QA correction: exact frozen-catalog evidence now uses the absolute work_item catalog path and registered hash. TFN.S34 is recorded as an unverified conditional raw ownership discovery lead only; it is not a verified IOR panel or an additional mandatory AND input. Shared paths and the supported extra-year filename edit are preparation tasks.
