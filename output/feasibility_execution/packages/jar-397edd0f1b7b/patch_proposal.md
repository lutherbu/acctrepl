# Patch proposal: jar-397edd0f1b7b

Financial Reporting and Employee Job Search

DOI: 10.1111/1475-679X.12469

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied preparation workflow for the 2012–2016 review-week sample and its companion outputs. The README specifies stages 01–08; the supplied stage 09 is also retained because it actively produces CompqVariables. The scope covers data preparation outputs, not unprovided paper-wide regression programs.

Entry points: `01_ReviewCompletePanel.do`, `02_ReviewsDaily.sas`, `03_Surprise.sas`, `04_FQTR.sas`, `05_NumEmp_Layoff.sas`, `06_AdditionalVariables_v3.sas`, `07_SampleConstruction.do`, `08_AddRegSample.sas`, `09_CompqVariables.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 2/12469 - Financial-Reporting-and-Employee-Job-Search/dlz-datasheet-code-and-identifiers.zip",
      "sha256": "163b6dc71b63d4865470ee577c049c3cdc01fc151b6fe5d17d3528e2d35f9112"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "3f138c2c3ba8bf4c8e66e885525e4341e3592225a69e4d8294c7e92b2541b523"
}
```

## Proposed actions

### A_GLASSDOOR_INPUT: Confirm an approved route to the authors' prepared review input or a compatible licensed local product, including whether GVKEY matching has already been applied and the review population, fields, and history. Do not contact employers or query/recollect Glassdoor records in this assessment.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_GLASSDOOR_REVIEW_INPUT, I_GLASSDOOR_ROUTE
Evidence: E_DATASHEET_NDA, E_CODE_01_PANEL, E_CODE_02_INPUTS, E_CATALOG_ALIAS_SEARCH_001

Preparation / proposed procedure:

1. Identify an already authorized local license or author-prepared copy for the exact review input; do not infer access absence from the NDA or the catalog miss.
2. Compare GVKEY mapping, review-level fields and date/history requirements with stages 01, 02, 07 and 08 before any later run.

Validation to perform later:

- After separate authorization, perform a bounded field and date-coverage check without exposing review text or identifiers.

### A_RAVENPACK_INPUTS: Resolve the exact three consumed RavenPack prepared extracts or confirm a compatible route from the catalogued full-edition RP_EQUITIES yearly tables and RP_ENTITY_MAPPING. Stage 05 and Stage 06 supply candidate producer/filter construction inside block comments; validate those supplied filters, field selections, PERMNO joins, event/date handling, generated schemas against downstream consumers, and required periods against the compatible local product contract. Candidate fields and bounded local reads do not establish compatible history, population, or output mapping.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_RAVENPACK_LAYOFF, R_RAVENPACK_COVERAGE, R_RAVENPACK_MEDIA, I_RAVENPACK_PRODUCERS
Evidence: E_CODE_05_RPNA, E_CODE_06_REVIEW_MEDIA, E_CODE_08_MEDIA, E_CATALOG_CANDIDATE_FOCUS, E_RP_VISIBILITY_002, E_SAS_COMMENT_REFERENCE_001

Preparation / proposed procedure:

1. Locate an authorized copy of the distinct 2012–2018 layoff extract, 2012–2018 company-coverage list, and 2012–2016 media extract, or confirm a documented compatible RP_EQUITIES/entity-mapping route.
2. If using the supplied Stage 05/06 candidate construction, set ordinary host roots in the separate portable working copy and verify its supplied filters, field selections, date/category logic, PERMNO joins, and output schemas against the accessible product fields and required history before execution.

Validation to perform later:

- Confirm permno/time keys, event categories/measures, prepared output fields, and the 2012–2018 versus 2012–2016 history required by each consumer.

### A_J2J_INPUT: Map the official public quarterly J2J product to the exact `industry/year/quarter/j2j` input consumed by Stage 07; the public route is documented, but the chosen count/rate measure, derived NAICS industry levels, and matching periods are not specified.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_J2J_TURNOVER
Evidence: E_DATASHEET_STEPS, E_CODE_07_J2J, E_PUBLIC_J2J_GUIDE, E_PUBLIC_J2J_SCHEMA

Preparation / proposed procedure:

1. Use the inspected official Census J2J guide and schema to select the exact quarterly indicator and industry tabulation used by the authors; do not query or fetch a data payload during this assessment.
2. Document the transformation from Stage 07's 2-digit/combined NAICS industry labels to the J2J industry identifiers and construct the author-named lowercase j2j field only from that supported definition.

Validation to perform later:

- After separately authorized acquisition, compare the prepared industry/year/quarter/j2j keys and 2012–2016 coverage with the code's `yq` merge without changing the scientific measure.

### A_TEMPCHGEMP: Identify the intended producer and schema for Data/tempchgemp.dta; retain PercentageChangeEmp.dta as a separate supplied output unless evidence supports an exact mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TEMPCHGEMP, I_TEMPCHGEMP_PRODUCER
Evidence: E_CODE_05_EMP, E_CODE_07_J2J

Preparation / proposed procedure:

1. Provide or identify the producer for tempchgemp.dta and document its GVKEY/fiscal-year keys and the fields stage 07 needs.
2. Compare its fields and definitions with PercentageChangeEmp.dta only after obtaining the missing specification.

Validation to perform later:

- Statically trace the chosen producer-to-consumer handoff before any separately authorized run.

### A_RELATIVE_PATHS: Create a separate portable working copy for any later run, set a coherent per-program working layout, preserve README stages 01–08 in their required order, align each producer/consumer file path and case, and keep Stage 09 as a separate supplied companion branch after its actual inputs are available.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_RELATIVE_PATHS, I_CONNECTION_CONFIG
Evidence: E_CODE_02_OUTPUT, E_CODE_04_FQTR, E_CODE_07_ENTRY, E_CODE_07_FQTR, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. For any later run, make a separate portable working copy and leave this frozen audit generation unchanged. Choose a writable project root with explicit Data, Rawdata, Rawdata2, and Program directories; run Stage 01 with its review input in the current working directory or configure the working directory so the relative read resolves.
2. Set Stata path/data/rawdata globals and SAS path/path1/pathraw/pathraw1/pathraw2/pathout macros plus the needed SAS library-name bindings so each output goes to the exact file location consumed next. Configure ordinary host roots in the portable copy; if a legitimate service connection needs credentials, use the local secure configuration route and keep credentials out of source and logs. Assess product access and entitlement separately from root selection.
3. Route Stage 01's review panel to Stage 02; Stage 02's Reviews20200424 to Stages 05–07; Stage 03's surprise/revision files to Stages 06/07/09; Stage 04's fiscal-quarter file to Stage 07; Stage 05's fundq_lag, employee_lag and layoffs to Stage 07 and employee_lag to Stage 09; Stage 06's growth/peer/media outputs to Stage 07; and Stage 07's regsample_week20210114 to Stage 08.
4. Resolve Stage 04's lowercase fqtr.dta export versus Stage 07's uppercase FQTR.dta input by aligning the output name or staging a case-correct copy at the exact Data/ consumer path; verify the actual configured roots as well as case.
5. Keep Stage 05 PercentageChangeEmp.dta separate from Stage 07 Data/tempchgemp.dta until the intended producer, variables and definitions are documented. Preserve Stage 09 compq_var.dta as a companion output under its own configured path.

Validation to perform later:

- Statically confirm each named producer path and basename/case matches every consumer path for the selected roots, including the cross-language handoffs in the workflow trace.
- Before a separately authorized run, verify only that the configured working directories and approved SAS library roots are visible/writable; do not use a setup check to infer data rights or full-history coverage.

### A_VENDOR_PRODUCT_ROUTES: Check exact catalog products and one-row local field routes for each standard Compustat, CCM, CRSP, I/B/E/S and dated S&P membership requirement. Local readability is established for selected source tables, but exact author aliases, complete 2002–2017/2006–2016 history, vintage and join/population behavior remain distinct compatibility questions.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FUNDQ, R_CCMQ, R_CCM_LINK, R_COMPANY, R_CCMA, R_CRS_DAILY, R_CRS_MONTHLY, R_IBES_LINK_STANDARD, R_IBES_LINK_GUIDANCE, R_IBES_ACTUAL, R_IBES_DETAIL, R_SP500_MEMBERSHIP
Evidence: E_FROZEN_RESOURCE_CATALOG, E_CATALOG_CANDIDATE_FOCUS, E_CATALOG_ALIAS_SEARCH_001, E_CATALOG_ALIAS_SEARCH_002, E_REQ_FUNDQ, E_REQ_CCMQ, E_REQ_CCM_LINK, E_REQ_COMPANY, E_REQ_CCMA, E_REQ_CRS_DAILY, E_REQ_CRS_MONTHLY, E_REQ_IBES_LINKS, E_REQ_IBES_ACTUAL_FIELDS, E_REQ_IBES_DETAIL, E_REQ_SP500, E_PROBE_COMP_FUNDA, E_PROBE_COMP_FUNDQ, E_PROBE_COMP_COMPANY, E_PROBE_CRSP_CCMXPF_LINKTABLE, E_PROBE_CRSP_MSF, E_PROBE_CRSP_DSF, E_PROBE_CRSP_MSP500LIST, E_PROBE_IBES_DETU_EPSUS, E_PROBE_IBES_ACTU_EPSUS, E_PROBE_WRDSAPPS_IBCRSPHIST

Preparation / proposed procedure:

1. Use the recorded COMP.FUNDQ/FUNDA/COMPANY, CRSP link/MSF/DSF/MSP500LIST, I/B/E/S ACTU/DETU, and WRDSAPPS.IBCRSPHIST candidates only as local source candidates with their measured fields.
2. Keep the ccmq50to17 merged table and the separate guidance-link input unresolved: the exact ccmq alias is absent, and separately readable underlying products do not prove the authored merge contract or guidance population.
3. Preserve unadjusted ACTU/DETU products, date/link logic, and all author sample windows; do not substitute adjusted I/B/E/S counterparts based on similar names.

Validation to perform later:

- After a separately authorized setup, verify required table history, population and units, effective link behavior, and exact field conversions; one-row reads do not establish coverage.

### A_SAS_RUNTIME: Verify SAS 9.4 Base availability in the intended batch environment before the supplied SAS preparation stages.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS_94, I_SAS_RUNTIME
Evidence: E_CODE_02_COMPQ, E_CODE_03_BASES

Preparation / proposed procedure:

1. Check whether SAS 9.4 Base is available in the target batch environment; if software setup is needed, use the existing legitimate local setup route.
2. Keep SAS startup diagnostics and any authentication values out of the source and assessment logs; host library roots are configured separately in the portable working copy.

Validation to perform later:

- Before a separately authorized run, verify the SAS runtime version and batch startup in the portable working copy; do not treat startup status as evidence of vendor-data entitlement.

### A_STATA_WINSOR2: Make the Stata winsor2 command available to Stage 07 through the approved Stata ado-package setup.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_WINSOR2
Evidence: E_PROBE_WINSOR2, E_CODE_07_EMPLOYEES, E_CODE_07_PEER

Preparation / proposed procedure:

1. Install or add the required winsor2 ado command through the approved local package channel, without editing its calls or cut points.

Validation to perform later:

- Use a bounded Stata `which winsor2` check after setup and confirm that it resolves in the same adopath used for Stage 07.


## Remaining issues and prerequisites

- I_GLASSDOOR_ROUTE [unresolved; full_pipeline]: An exact prepared Glassdoor review/GVKEY route is required, but current local entitlement and input compatibility are unknown. The NDA establishes a public-sharing restriction only; the frozen catalog miss does not establish absent access.
- I_RAVENPACK_PRODUCERS [unresolved; full_pipeline]: Active stages consume three distinct author-prepared RavenPack extracts. A hash-bound lexical review confirms that Stage 05 lines 20–142 and Stage 06 lines 23–77 contain candidate producer code entirely inside SAS `/*...*/` block comments, with no active statements in those ranges. The supplied commented construction and filters reference candidate interfaces including rpna.rp_entity_mapping and rpna.rp_equities_2012; the official SAS comment reference confirms that this comment form hides contents from macro processing, so its in-span macro include and triggers do not activate a producer in the current files. This code is supplied as candidate construction, but compatibility of its supplied filters and fields with the local product, the intended PERMNO mapping, the schemas expected by downstream consumers, and 2012–2018 versus 2012–2016 coverage remains unverified. Catalog candidates and bounded local reads do not establish those contracts.
- I_TEMPCHGEMP_PRODUCER [unresolved; full_pipeline]: Stage 07 actively merges Data/tempchgemp.dta by GVKEY/fiscal year. Supplied Stage 05 instead exports PercentageChangeEmp.dta (GVKEY, DATADATE, FYEAR, pct_chng_emp) and employee_lag.dta; neither is proven to be the named input.
- I_RELATIVE_PATHS [preparation; full_pipeline]: Stage 01 uses current-directory-relative paths; SAS roots/macros are blank or unresolved; Stage 07 derives Data/Rawdata/Program from an empty root global; producers and consumers use different configured roots; and Stage 04 exports fqtr.dta while Stage 07 imports FQTR.dta. Configure exact cross-language handoffs and case on the host filesystem.
- I_CONNECTION_CONFIG [preparation; full_pipeline]: The supplied SAS stages use library and root bindings that need host-specific values for a later run. Set those ordinary path/configuration values in a separate portable working copy; choosing the local physical roots does not require the authors' original paths or approval. Protected statement bodies remain omitted from this assessment. SAS runtime and each data product's access/field/history contracts are assessed separately.
- I_SAS_RUNTIME [unresolved; full_pipeline]: SAS 9.4 Base is required for the supplied SAS stages; its availability in the intended batch environment remains unverified. The prior TKELS initialization failure is retained only as limited process history and does not establish absence of SAS or a license barrier.
- R_GLASSDOOR_REVIEW_INPUT [undetermined]: The Glassdoor-derived review input consumed under review_licw_wrds_20161206.dta, including the author-prepared GVKEY mapping or its separately specified lookup.
- R_RAVENPACK_LAYOFF [undetermined]: Prepared RavenPack layoff extract consumed by stage 05.
- R_RAVENPACK_COVERAGE [undetermined]: Prepared RavenPack company-coverage/permno list consumed by stage 05.
- R_RAVENPACK_MEDIA [undetermined]: Prepared RavenPack media extract consumed by stages 06 and 08.
- R_J2J_TURNOVER [undetermined]: Quarterly Census Job-to-Job turnover input merged in stage 07.
- R_TEMPCHGEMP [undetermined]: Unproduced Data/tempchgemp.dta input explicitly merged by stage 07.
- R_FUNDQ [undetermined]: Compustat quarterly fundamentals used in stages 02, 04, and 05.
- R_CCMQ [undetermined]: Compustat–CRSP merged quarterly table used in stages 03, 06, and 09.
- R_CCM_LINK [undetermined]: Dated CCMXPF Compustat–CRSP link table used by stages 02 and 05 under two author aliases.
- R_COMPANY [undetermined]: Compustat company data used for SIC/state/NAICS and firm-industry joins.
- R_CCMA [undetermined]: Compustat annual employee data used by stage 05 to calculate annual employee changes and quarterly employee lags.
- R_CRS_DAILY [undetermined]: CRSP daily stock file used for split factors, event-date prices, and share counts in stage 03.
- R_CRS_MONTHLY [undetermined]: CRSP monthly stock file used for price and market-value scaling in stage 03.
- R_IBES_LINK_STANDARD [undetermined]: Standard I/B/E/S–CRSP ticker/PERMNO link table appended in stage 03.
- R_IBES_LINK_GUIDANCE [undetermined]: Guidance-specific I/B/E/S–CRSP ticker/PERMNO link table appended in stage 03.
- R_IBES_ACTUAL [undetermined]: I/B/E/S actual EPS records used to form the I/B/E/S earnings-surprise measure.
- R_IBES_DETAIL [undetermined]: Unadjusted I/B/E/S detailed analyst forecasts used for surprise consensus and forecast revisions.
- R_SP500_MEMBERSHIP [undetermined]: Dated S&P 500 membership table used in stages 06 and 09.
- S_SAS_94 [unverified]: Required by stages 02–06, 08 and 09 for DATA steps, PROC SORT/SQL and import/export. Availability remains unverified in the intended batch environment; the earlier TKELS initialization failure is limited process background, not proof SAS is absent or unlicensed. This assessment did not start SAS.
- S_WINSOR2 [preparation_required]: Stage 07 calls winsor2 for emp_lag and revision. The frozen Stata 18 version/which helper found no winsor2 command in the active search path; no installation was attempted.

## Review notes

- All nine supplied programs and both author documents were statically inspected with credential-safe redacted source views. README stages 01–08 are retained in order; stage 09 is retained as a supplied output-producing companion branch.
- Local table probes read one requested row only. Successful fields confirm local source-table readability, not full history, population, product vintage, entitlement, or authored merged-table construction. The eight RavenPack entity/event timeout artifacts remain with their 15-second capture limit but are unreferenced in scientific evidence lists; candidate routes rely on successful catalog and source evidence.
- The datasheet NDA concerns public sharing and does not establish absence of a current local Glassdoor license or prepared input. No person, employer, review, court, issuer, or Glassdoor record query or contact was made; only official static Census J2J documentation was inspected.
- Identifiers.dta is a GVKEY/DATADATE membership list, not a full analytic panel. `tempchgemp.dta` remains an unproduced supplied input distinct from Stage 05's PercentageChangeEmp.dta. The Stage 04 `fqtr.dta` to Stage 07 `FQTR.dta` case/path handoff remains to be configured.
- The copy-only frozen helper --help attempt failed because the copied script could not import its sibling `packages` module; the failure capture limitation and actual diagnostic are retained in probes/frozen_helper_help_failure_001.json. Subsequent bounded checks used the exact-hash registered catalog and the byte-matching helper source under git/skills/check-execution-feasibility.
- The mixed environment artifact remains referenced only for its successful Stata 18 subrecord. The separate SAS TKELS launch failure is unreferenced process history and does not establish SAS absence or license status; SAS remains unverified. The Stata 18 `which` probe successfully found no winsor2 command in the active path; no packages were installed, no SAS process was started, and no author code was executed.
- The first frozen-controller finalizer attempt rejected the available Stata software record because its name was `Stata 18` instead of the exact successful probe-map key `Stata`; the submitted draft, controller stdout/stderr and invocation record are preserved under probes/finalize_001_* and the subsequent draft update aligns the name to the probe.
- The earlier credential-safe structural summary remains unreferenced and records only redaction boundaries. A separate hash-bound lexical review of the Stage 05/06 spans is referenced by I_RAVENPACK_PRODUCERS and A_RAVENPACK_INPUTS: both spans are inside block comments, contain candidate DATA/PROC SQL construction, and have no active SAS statements. The official SAS reference confirms `/*...*/` hides comment contents from macro processing, so in-span macro triggers and `%include` do not activate those blocks. The source supplies candidate construction and filters; compatibility with local product fields/history, PERMNO mapping and output contracts remains unverified. No SAS or author-code execution was performed.
- All 39 frozen dependency IDs and all 18 data requirements remain in scope. The Stage 07 `tempchgemp.dta` consumer stays distinct from Stage 05's `PercentageChangeEmp.dta`; the code does not establish an alias or require the author's original-byte copy.
- The first saved visibility wrapper failed its post-run safe-output audit after its child returned 0 because a static explanatory string contained a path separator. The child stdout/stderr and wrapper source are preserved; the outer wrapper output was retained by the exec tool as one combined field, so separate wrapper streams are unavailable. Its unreferenced process-history record states this capture limit. The structural review report was derived from the saved child stdout; the source scan was not rerun.
- Frozen controller finalizer attempt 004 returned status 1 because E_SAS_COMMENT_REFERENCE_001 lacked the schema-required description. Its exact separate stdout/stderr, argv, cwd, status, and byte-exact submitted copy are preserved; the prior output pair remained unchanged. The evidence descriptor was corrected before the new submission.
