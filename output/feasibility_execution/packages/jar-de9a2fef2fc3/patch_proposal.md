# Patch proposal: jar-de9a2fef2fc3

Flu Fallout: Information Production Constraints and Corporate Disclosure

DOI: 10.1111/1475-679X.12486

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied main-sample construction and main forecast-issuance branch in Sample_Construction.do; other paper-wide tables and appendix tests without supplied entry code are contextual.

Entry points: `Sample_Construction.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 4/12486 - Flu-Fallout-Information-Production-Constraints-and-Corporate-Disclosure/cllw-datasheet-code-and-identifiers.zip",
      "sha256": "39dc4eff8cabba3c6e916e4902b5ce1db122c382e922a7639d0ec74afcba1881"
    },
    {
      "path": "JAR-Volume 61/Issue 4/12486 - Flu-Fallout-Information-Production-Constraints-and-Corporate-Disclosure/cllw-online-appendix.pdf",
      "sha256": "3b3e4ec487c2349e3ff4b2599c627d1573079fd07c3b8555732e2ef15cea812f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "9f5b706e7544cf804379f6f0c6725065af138771f2ad2986db93c5712a07baea"
}
```

## Proposed actions

### ACT_FLU_PREP: Use the supplied weekly Flu_Data.dta as the primary author-prepared flu source. In a separate working copy, normalize its State and Weekend keys to the daily State_HQ/date contract and expand weekly Flu values to daily observations as described by the supplied code; stage that prepared input as Flu.dta.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_FLU_PREPARED, ISS_FLU_HANDOFF
Evidence: SRC_IDENTIFIER_ROLE, SRC_FLU_EXPECTATION, PROBE_FLU

Preparation / proposed procedure:

1. Preserve the original Flu Data.dta bytes; in a separate working copy map State to State_HQ, Weekend to the daily date key, and carry Flu into the daily-expanded Flu.dta input.
2. Use the authored week/date convention for partial first and last weeks; do not replace the author-prepared route with mandatory CDC/Google raw-data reconstruction.
3. Confirm field types, state labels, units, full date coverage and the Sep 2009–Oct 2010 gap against the required information-production windows; the bounded one-row probe does not establish these properties.

Validation to perform later:

- After a separately authorized run, verify that every retained information-production window has one daily Flu observation for each date and that Flu_CG follows the documented weekly-to-daily measure convention.

### ACT_IBES_ACTUAL: Prepare the local IBES.Actuals candidate for IBES_Actual_Raw.dta while confirming the author DTA's field casing and required 2003–2018 history.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_IBES_ACTUAL
Evidence: SRC_MAIN_INPUTS, PROBE_IBES_ACTUAL, CAT_RESOURCE

Preparation / proposed procedure:

1. Use the catalog-listed IBES.ACTU_EPSUS candidate only after confirming its US/EPS population and required period; the bounded probe confirms readable source columns but not historical coverage.
2. Convert/stage the needed actuals fields as IBES_Actual_Raw.dta with the names and case expected by the supplied Stata code, preserving ticker, period-end, announcement, periodicity, currency and US-firm fields.
3. Keep Gvkey-IBES.dta as a separate required linkage handoff addressed by ACT_IBES_LINK.

Validation to perform later:

- Before a separately authorized run, check the Stata DTA header, field casing, date types and 2003–2018 coverage against the actual code reads.

### ACT_IBES_GUIDANCE: Prepare the local IBES Guidance candidate for MF_Raw.dta using the fields and announcement period consumed by the supplied branch.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_IBES_GUIDANCE
Evidence: SRC_GUIDANCE_INPUT, PROBE_IBES_GUIDANCE, CAT_RESOURCE

Preparation / proposed procedure:

1. Use IBES.DET_GUIDANCE as a candidate source for the code's currency, periodicity, EPS measure, announcement date, forecast period, consensus and guidance-range fields.
2. Stage MF_Raw.dta in a separate working copy, preserving the case and exact source field names or using a documented export mapping; the one-row metadata probe does not establish the 2001–2018 coverage.
3. Retain the supplied `range_de` and `guidance` references only if the Stata varabbrev setting and imported names support those unique prefixes of range_desc and guidance_code.

Validation to perform later:

- Before a separately authorized run, verify source columns, Stata names, dates, US firm/currency filters and announcement coverage for 2001–2018.

### ACT_COMPUSTAT_QTR: Stage the quarterly Compustat source used for Comp_Raw.dta from a compatible candidate while preserving the supplied financial fields and fiscal-quarter order.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_COMPUSTAT_QTR, ISS_MISSING_PRIMARY_INPUTS
Evidence: SRC_COMPUSTAT_INPUT, PROBE_COMP_QTR, CAT_RESOURCE

Preparation / proposed procedure:

1. Use COMP.FUNDQ as a local candidate for the probed GVKEY, DATADATE, FYEARQ/FQTR, FIC and financial variables; verify its required 2003–2019 coverage and output names before staging Comp_Raw.dta.
2. Do not represent COMP.FUNDQ as a complete substitute while its SIC field is absent; resolve the separate SIC/SIC2 handoff under ACT_COMP_SIC.

Validation to perform later:

- Check the prepared Comp_Raw.dta against every field listed by the source comment and the later joins; confirm fiscal-year and fiscal-quarter keys before any run.

### ACT_COMP_SIC: Resolve the actual SIC and SIC2 producer/key contract for the Comp_Raw.dta and IndIssue.dta handoff before running the supplied branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMPUSTAT_QTR, ISS_COMP_SIC
Evidence: SRC_COMP_SIC, SRC_INDISSUE_KEY, PROBE_COMP_QTR

Preparation / proposed procedure:

1. Obtain the missing author Comp_Raw.dta schema or its documented producer and establish where SIC and SIC2 enter the main panel.
2. Confirm the exact conversion from the source SIC value to the SIC2 key used by IndIssue.dta; the supplied code creates sicc but does not visibly create sic2, and the local COMP.FUNDQ candidate has no SIC-named field.
3. Do not guess that sicc, a different classification, or a particular Compustat table is the intended substitute.

Validation to perform later:

- After a separately authorized run, verify that the SIC2/FYEARQ merge key exists in the master and the producer output without changing the industry population.

### ACT_IBES_LINK: Recover the documented producer contract for Gvkey-IBES.dta, the ticker/year-to-GVKEY1 link consumed by Step 1.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IBES_ACTUAL, ISS_WRDS_LINK, SW_SAS
Evidence: SRC_IBES_LINK, INSP_WORKFLOW_TRACE_FINAL

Preparation / proposed procedure:

1. Use an authorized WRDS route to inspect the cited IBES ticker-to-Compustat GVKEY sample program or obtain the author-generated Gvkey-IBES.dta and its schema.
2. Confirm the ticker/year join history, GVKEY output field, source inputs and SAS runtime requirement before producing or staging the file.
3. Keep the historical GVKEY-CIK source listed in the datasheet contextual unless an actual supplied producer consumes it.

Validation to perform later:

- Check that Gvkey-IBES.dta has the ticker, year and gvkey1 keys used by the supplied m:1 merge and that its history covers the retained announcements.

### ACT_CRSP_HANDOFFS: Resolve the CRSP producer contracts for Lag_Price.dta and Ret_Quarterly.dta without assuming a daily/monthly product or link transformation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CRSP_PANEL, ISS_AUXILIARY_PRODUCERS, ISS_CONTROL_HANDOFF
Evidence: SRC_CRSP_PRICE, SRC_EPS_RET, PROBE_CRSP_MSF, PROBE_CRSP_LINK, CAT_RESOURCE

Preparation / proposed procedure:

1. Confirm the author source table, adjustment convention, security link and date rules that produce Lag_Price keyed by GVKEY1/DATADATE and Ret_Quarterly keyed by GVKEY1/FYEARQ.
2. Evaluate CRSP.MSF and the catalog-listed CCMXPF_LINKTABLE only as candidates; the bounded probes establish columns, not the author producer or required history.
3. Document whether the Ret_Quarterly output contains Ret or Return and how Return_w is produced; do not silently rename the series.

Validation to perform later:

- Check quarter-end price fallback, GVKEY/security-link validity, return aggregation and fiscal-quarter keys after a separately authorized producer run.

### ACT_10K_HEADER: Verify and acquire the author-named historical SRAF Augmented 10-X Header product needed for the State_HQ merge.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_10K_HEADER
Evidence: SRC_HEADER, SRC_DOC_HEADER, CAT_RESOURCE

Preparation / proposed procedure:

1. Locate an accessible current official SRAF product landing page or static documentation page and verify the product, public access conditions, historical coverage and GVKEY/year/state fields.
2. If compatible, obtain the documented header data through its permitted route and stage a working-copy 10K_Header.dta that supplies State_HQ by GVKEY1/fyear.
3. The supplied author URL and frozen catalog search do not currently establish a verified route or substitute product.

Validation to perform later:

- Confirm that the prepared header file covers the required firm-years and keys before the 10-K merge; do not request data payloads during this audit.

### ACT_ANALYST_PRODUCER: Resolve the missing IBES analyst-forecast producer for Analyst_Quarterly.dta and its three consumed variables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IBES_ANALYST, ISS_AUXILIARY_PRODUCERS, ISS_CONTROL_HANDOFF
Evidence: SRC_ANALYST, PROBE_IBES_SUMMARY, CAT_RESOURCE, INSP_WORKFLOW_TRACE_FINAL

Preparation / proposed procedure:

1. Identify the author source table and filters for Coverage_Q, Dispersion and MBanalyst, including ticker/GVKEY linking and DATADATE mapping.
2. Treat IBES.STATSUM_EPSUS as a local summary candidate only; its readable NUMEST, STDEV and MEANEST fields do not establish the quarterly output definitions or history.
3. Stage Analyst_Quarterly.dta only after its GVKEY1/DATADATE keys and output names are documented.

Validation to perform later:

- Check the produced identifiers, period, coverage and values against the author definitions before the 1:1 merge.

### ACT_IOR_PRODUCER: Resolve the source and producer for IOR_Quarterly.dta using the documented 13F ownership-ratio workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IOR_13F, ISS_IOR_PRODUCER, SW_SAS, ISS_AUXILIARY_PRODUCERS
Evidence: SRC_IOR, SRC_DOC_ANALYTICS, CAT_RESOURCE, INSP_WORKFLOW_TRACE_FINAL

Preparation / proposed procedure:

1. Use an authorized route to obtain the cited WRDS SAS program or the author-generated IOR_Quarterly output and its schema.
2. Confirm the 13F source period, CUSIP/security-to-GVKEY linkage, manager/quarter aggregation, IOR definition and GVKEY1/FYEARQ output keys.
3. Treat TFN.S34 as an unverified local catalog candidate; its 15-second one-row read timed out, so no full metadata or access conclusion is claimed.

Validation to perform later:

- Verify the IOR_Quarterly output schema and period before the 1:1 merge; if SAS sample code is used, perform only future authorized runtime checks in a separate working copy.

### ACT_AUDIT_PRODUCER: Resolve the Audit Analytics restatement source and producer for Restatement.dta and Error.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_AUDIT_RESTATEMENT, ISS_AUXILIARY_PRODUCERS
Evidence: SRC_RESTATEMENT, SRC_DOC_ANALYTICS, PROBE_AUDIT_FEED39, CAT_RESOURCE

Preparation / proposed procedure:

1. Confirm the exact author-named Non-Reliance/restatement product and its period, entity mapping and Error definition.
2. Evaluate AUDIT.FEED39_FINANCIAL_RESTATEMENTS only as a readable candidate: its company-fkey, restatement type and file-date columns do not directly establish GVKEY1/DATADATE/Error.
3. Stage Restatement.dta only after the source-to-GVKEY/date construction is documented.

Validation to perform later:

- Verify one source row per author merge key and the required restatement indicator definition before the 1:1 merge.

### ACT_OTHER_PRODUCERS: Close the remaining specifically identified auxiliary producer handoffs before running the supplied control-variable branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_AUXILIARY_PRODUCERS, ISS_CONTROL_HANDOFF, REQ_COMPUSTAT_QTR, REQ_CRSP_PANEL, REQ_IBES_GUIDANCE, REQ_AUDIT_RESTATEMENT
Evidence: SRC_EPS_RET, SRC_INDISSUE, SRC_RESTATEMENT, SRC_CONTROL_HANDOFF, INSP_WORKFLOW_TRACE_FINAL

Preparation / proposed procedure:

1. Obtain the producer or output contract for EPS_Vol.dta from Compustat Quarterly, including the volatility window and GVKEY1/FYEARQ fields.
2. Obtain the producer or output contract for IndIssue.dta, including its IBES population, SIC2/FYEARQ keys and the IndIssue, IndIssue_Short and IndIssue_Long definitions.
3. For each intermediate, record exact source tables, construction history, output schema and the next supplied consumer; do not add separate raw-source AND inputs without a documented producer route.

Validation to perform later:

- Check that each intermediate exists in the portable working copy with the keys and variables consumed by the next step before execution.

### ACT_STATA_SETUP: Add the exact missing Stata commands used by the supplied workflow to a future authorized Stata18 execution environment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_RANGEJOIN, SW_WINSOR2, SW_SUM2DOCX, SW_CORR2DOCX, SW_OUTREG2
Evidence: PROBE_SW_RANGEJOIN, PROBE_SW_WINSOR2, PROBE_SW_SUM2DOCX, PROBE_SW_CORR2DOCX, PROBE_SW_OUTREG2, SRC_FLU_EXPECTATION, SRC_CONTROLS, SRC_TABLE_OUTPUTS

Preparation / proposed procedure:

1. Set up compatible providers for rangejoin, winsor2, sum2docx, corr2docx and outreg2 in the authorized Stata ado path; do not change the authored estimator or output procedure.
2. Verify each exact command/function with a version/which metadata check before running the driver; this assessment did not install anything.

Validation to perform later:

- Confirm `which` succeeds for all five commands in the selected Stata18 batch environment.

### ACT_SAS_RUNTIME: If the two WRDS sample-program producers are used, verify the SAS runtime in the separately authorized execution environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, ISS_WRDS_LINK, ISS_IOR_PRODUCER
Evidence: PROBE_ENVIRONMENT, SRC_IBES_LINK, SRC_IOR

Preparation / proposed procedure:

1. Use the supplied environment evidence only as an inconclusive startup diagnostic; it does not establish license status.
2. Before a future authorized run of the WRDS SAS sample programs, confirm a compatible batch runtime and preserve the original input/output directories.

Validation to perform later:

- Use a read-only version/availability check in a separately authorized environment before running any WRDS sample program.

### ACT_RUN_PROCEDURE: After all required inputs, producer handoffs and commands are resolved, execute the single supplied Stata driver in order from a portable working copy.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ_IBES_ACTUAL, REQ_IBES_GUIDANCE, REQ_COMPUSTAT_QTR, REQ_FLU_PREPARED, REQ_CRSP_PANEL, REQ_10K_HEADER, REQ_IBES_ANALYST, REQ_IOR_13F, REQ_AUDIT_RESTATEMENT, SW_STATA, SW_REghdfe, SW_FTOOLS, SW_GNVALS, SW_RANGEJOIN, SW_WINSOR2, SW_SUM2DOCX, SW_CORR2DOCX, SW_OUTREG2, SW_SAS, ISS_FLU_HANDOFF, ISS_MISSING_PRIMARY_INPUTS, ISS_AUXILIARY_PRODUCERS, ISS_COMP_SIC, ISS_CONTROL_HANDOFF, ISS_WRDS_LINK, ISS_IOR_PRODUCER
Evidence: SRC_STATA_WORKFLOW, INSP_WORKFLOW_TRACE_FINAL, SRC_MAIN_OUTPUTS, PROBE_ENVIRONMENT

Preparation / proposed procedure:

1. Create a separate portable run folder; stage the unmodified Sample_Construction.do and all resolved inputs under the exact authored filenames, including the prepared Flu.dta, while keeping package/evidence files intact.
2. Set the Stata process working directory to that folder because the program uses unqualified filenames and does not change directories.
3. Run Step 1 (IBES actuals plus Gvkey-IBES to EA_Dates), Step 2 (IBES Guidance to MF), Step 3 (Compustat and all documented joins/flu/control intermediates), then Step 4 (MF range join, outcomes, sample, winsorization and main regressions). Use the approved host batch wrapper and relative `do Sample_Construction.do` path.
4. Retain Table2.docx and results.xls in the working copy; the analysis dataset remains in memory because the supplied driver has no final dataset save command.
5. Treat paper-wide tables and online-appendix tests without supplied executable branches as outside this selected target.

Validation to perform later:

- After a separately authorized execution, verify each named input handoff and output file, the expected daily flu coverage, merge keys and actual regression sample without changing the authored sample or estimator.
- Compare any final firm-quarter output to Sample_Identifiers.dta only as an optional post-run check; do not use the identifier list as analysis input.


## Remaining issues and prerequisites

- ISS_FLU_HANDOFF [unresolved; full_pipeline]: The supplied weekly author-prepared Flu_Data.dta is the primary route and its State/Weekend-to-State_HQ/date mapping plus daily expansion are supported preparation. The bounded probe does not establish its actual field types, state-label compatibility, units, complete IPW date coverage or partial-week boundary behavior. The code notes a Sep 2009–Oct 2010 flu-data gap and requires one daily observation for every IPW date before retaining Flu_CG.
- ISS_MISSING_PRIMARY_INPUTS [unresolved; full_pipeline]: The IBES Actual, IBES Guidance and Compustat Quarterly source files named by the supplied driver are not among the five package files. Readable local catalog candidates exist, but exact author-file mappings, required histories and Compustat SIC source/key are unresolved.
- ISS_AUXILIARY_PRODUCERS [unresolved; full_pipeline]: Beyond the two intermediates generated in-script, the author driver consumes unprovided Lag_Price, Analyst_Quarterly, EPS_Vol, Ret_Quarterly, IndIssue and Restatement outputs. Their producer code, source-table mappings, field/key contracts and histories are not supplied; each handoff is listed in the linked ordered trace.
- ISS_COMP_SIC [unresolved; full_pipeline]: The exact readable COMP.FUNDQ candidate has no SIC-named column, while the code calls destring sic and later merges IndIssue on sic2. The supplied code creates sicc but does not visibly establish sic2; the absent author Comp_Raw producer or another source must document both fields and their construction.
- ISS_CONTROL_HANDOFF [unresolved; full_pipeline]: The supplied regression control list uses dEPS, FutureEPS, Return and LogLag without visibly constructing all of them. The driver imports Ret from Ret_Quarterly.dta but later winsorizes and uses Return; source/intermediate schemas must establish the intended mapping and producers before any repair is proposed.
- ISS_WRDS_LINK [unresolved; full_pipeline]: Gvkey-IBES.dta is required to link ticker/year to GVKEY1. The source says a WRDS SAS sample program generates it, but the program and output schema are not supplied, and the bounded official page check redirected to login. The data route or producer remains unverified; the redirect is process history, not a data access barrier.
- ISS_IOR_PRODUCER [unresolved; full_pipeline]: IOR_Quarterly.dta is required and the source says it is generated using a WRDS SAS ownership-ratio program, but its code, GVKEY/security linkage, fiscal-quarter mapping and IOR formula are absent. The local 13F catalog candidate is not a demonstrated output route.
- REQ_IBES_ACTUAL [undetermined]: IBES Actual source for earnings-announcement dates (IBES_Actual_Raw.dta; 2003–2018 per the driver comment) and its unprovided WRDS ticker/year-to-GVKEY linkage handoff.
- REQ_IBES_GUIDANCE [undetermined]: IBES Guidance management-forecast source read as MF_Raw.dta; code retains announcements from 2001–2018 and uses the prepared MF.dta in the 2003–2018 main event sample.
- REQ_COMPUSTAT_QTR [undetermined]: Compustat Quarterly input read as Comp_Raw.dta for fiscal-quarter construction, 2003–2019, including financial fields and an SIC key needed for the later IndIssue merge.
- REQ_FLU_PREPARED [undetermined]: Author-prepared weekly state-level flu source used to construct the main Flu variable. The packaged Flu Data.dta is the primary input route; the supplied comment supports routine State/Weekend-to-daily normalization, while units, full history, coverage and partial-week boundaries remain to be checked.
- REQ_CRSP_PANEL [undetermined]: CRSP security-price/return source needed for Lag_Price.dta and Ret_Quarterly.dta, which the supplied driver joins by GVKEY1/DATADATE and GVKEY1/FYEARQ.
- REQ_10K_HEADER [undetermined]: Historical headquarters state by firm-year, read as 10K_Header.dta and merged into the main panel as State_HQ.
- REQ_IBES_ANALYST [undetermined]: IBES analyst-forecast input needed to produce Analyst_Quarterly.dta with Coverage_Q, Dispersion and MBanalyst by GVKEY1/DATADATE.
- REQ_IOR_13F [undetermined]: Institutional ownership source needed to produce IOR_Quarterly.dta keyed by GVKEY1/FYEARQ, as described in the supplied program comment.
- REQ_AUDIT_RESTATEMENT [undetermined]: Audit Analytics restatement input needed to produce Restatement.dta and the Error indicator merged by GVKEY1/DATADATE.
- SW_RANGEJOIN [preparation_required]: The exact invoked Stata command is not found in the checked adopath; the supplied code itself notes that rangejoin must be installed.
- SW_WINSOR2 [preparation_required]: The exact invoked Stata command is not found in the checked adopath; the code uses it for the main control/flu winsorization.
- SW_SUM2DOCX [preparation_required]: The exact descriptive-output command is not found in the checked adopath.
- SW_CORR2DOCX [preparation_required]: The exact correlation-output command is not found in the checked adopath.
- SW_OUTREG2 [preparation_required]: The exact regression-output command is not found in the checked adopath.
- SW_SAS [unverified]: SAS is named only as the potential WRDS producer runtime for the IBES-GVKEY and IOR intermediates. The assigned environment artifact reports an earlier TKELS startup failure, which does not establish license or runtime unavailability; no SAS process was started in this assessment.

## Review notes

- Target scope is the complete supplied Sample_Construction.do main-sample/forecast-issuance workflow, including its Table 2 descriptive outputs and Table 3 Panel A regressions. The supplied program does not implement the other paper-wide or online-appendix analyses, and no extra branches have been added.
- The author-prepared weekly Flu_Data.dta is the primary route for the main Flu variable. State/Weekend field and date-key normalization plus weekly-to-daily expansion are preparation supported by the author documentation/code. Full history, field types, units, state compatibility, complete IPW coverage and partial-week boundary behavior remain unresolved; CDC/Google raw-origin reconstruction is not a mandatory AND input.
- Sample_Identifiers.dta is a GVKEY/DATADATE/Flu identifier list and the supplied driver does not read it. It is not a full analysis dataset, so no analysis_only scope is justified.
- The workflow trace records all direct reads, generated EA_Dates.dta and MF.dta intermediates, unprovided auxiliary producer handoffs, the in-memory analysis endpoint, and the actual ordered consumer chain. No cleaned final DTA was invented.
- The 10-K Header and WRDS sample-program static checks returned a 404 or login redirects; the exact captured limits are in probes/public_checks_history.json. This process-only record is unreferenced as scientific evidence and does not establish product unavailability, a license barrier or data access status.
- The frozen catalog lookup CLI failed on a missing snapshot sibling module; its exact command results are retained in probes/catalog_lookups.json. Direct frozen-catalog queries succeeded and are cited separately. The TFN.S34 one-row metadata read timed out at the 15-second child guard; its process record is unreferenced as scientific evidence and is not treated as absence or an access barrier.
- Stata 18, reghdfe, ftools and the actual egen nvals() function entry point _gnvals are available. The exact commands rangejoin, winsor2, sum2docx, corr2docx and outreg2 are not found in the checked adopath and need future setup. SAS is mentioned only as a possible producer runtime and remains unverified from assigned environment evidence; no SAS process was started.
- No author program, estimator, synthetic/descriptive data trial, data payload, installation, applied edit or SAS process was run. Source and author package bytes were left unchanged. All preparation, access and run steps are proposals for a separately authorized execution.
