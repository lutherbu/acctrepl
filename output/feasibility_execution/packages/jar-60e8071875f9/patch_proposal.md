# Patch proposal: jar-60e8071875f9

Does Fair Value Accounting Exacerbate the Procyclicality of Bank Lending?

DOI: 10.1111/1475-679X.12103

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented empirical workflow: the Part I annual loan-level mortgage sample and analyses, the Part II quarterly bank-level analysis, and the supplemental analyses reported in the online appendix. Only documentation is supplied, so there is no supported executable analysis-only path.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 1/12103 - Does-Fair-Value-Accounting-Exacerbate-the-Procyclicality-of-Bank-Lending/xie_online-appendix.pdf",
      "sha256": "82370cedfe101b11c82e0f6429c02449c59c726146722ef024e5b1542a978fe4"
    },
    {
      "path": "JAR-Volume 54/Issue 1/12103 - Does-Fair-Value-Accounting-Exacerbate-the-Procyclicality-of-Bank-Lending/xie_voluntary-compliance-to-journal-of-accounting-research-data-policy.pdf",
      "sha256": "458120329953553b9310b3daed196b8253e24351fdcbfdf9d7b217f13cbd6aa0"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "a16e9a403f0045e35d796faa7ed6259ee3e440a22f2ac0aa5a53e6c2dec823cb"
}
```

## Proposed actions

### action_author_materials: Request the author-provided SAS preparation and Stata analysis programs, or an approved executable replacement, with a complete entry-point and output map for the paper and online appendix. Request exact source file/product vintages, schemas, generated intermediates, working-directory assumptions, sample construction details (including the stratified sampling procedure), the selected HMDA LAR/Panel versions, and the intended order across programs. Specifically confirm the 2004–2009 Reporter Panel Respondent RSSD ID linkage and the 2004 mapping reused for 1997–2003. The policy already gives a narrative outline; do not independently recreate the study.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: issue_no_runnable_code, issue_workflow_contract, issue_panel_rssd_mapping
Evidence: ev_inventory, ev_software_workflow, ev_sampling_msa, ev_quarterly_sample, ev_appendix_outputs, ev_identifier_merge, ev_cfpb_panel_0709, ev_nara_hmda

Preparation / proposed procedure:

1. Obtain the author's executable programs or an explicitly accepted non-code alternative and associated input/output manifest.
2. Map each supplied entry point to the reported paper and appendix outputs, including the supplementary robustness analyses.
3. Resolve exact raw-data products, field mappings, periods, generated filenames, and producer-consumer order from the supplied author materials.
4. Resolve the exact 2004–2009 Reporter Panel source and RSSD field/mapping needed for 1997–2003; do not treat Parent Identification Number as a substitute.

Validation to perform later:

- Confirm every documented paper and appendix output maps to a supplied entry point or author-approved replacement.
- Confirm each data input and generated intermediate has a documented file/schema/period and a supported producer before assessing run order.
- Confirm the historical Panel field bridge and year-specific HMDA file versions against the author-supplied manifest before using current public files.

### action_documented_data_routes: Use the verified CFPB public route for 2007–2012 LAR records and 2010–2012 Reporter Panel records after author compatibility checks. NARA currently lists HMDA LAR and Panel products for 1981–2014/1990 onward with Catalog download access, but the precise 1997–2006 field layouts and Final/Ultimate vintages remain unverified. The CFPB 2007–2009 Reporter Panel specification does not document the Respondent RSSD ID required by the author’s method, so obtain the author-compatible historical bridge before use. FR Y-9C/Call Report/CRSP searches found no verified local input; catalog misses are not evidence of absent access or licensing. Current CFPB HMDA records are privacy-modified, so validate study-variable compatibility from the author manifest.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_y9c_annual, req_y9c_quarterly, req_call_report_ids, req_otti_10k, req_crsp_macro, req_fed_macro, req_msa_crosswalk, req_hmda_lar_1997_2006, req_hmda_lar_2007_2012, req_reporter_panel_1997_2009, req_reporter_panel_2010_2012
Evidence: ev_policy_sources, ev_hmda_source, ev_bank_source, ev_call_source, ev_tenk_source, ev_crsp_source, ev_macro_source, ev_identifier_merge, ev_sampling_msa, ev_inventory, ev_nara_hmda, ev_cfpb_hmda, ev_cfpb_downloads, ev_cfpb_lar_format, ev_cfpb_lar_ids, ev_cfpb_lar_action, ev_cfpb_panel_0709, ev_cfpb_panel_1017, ev_catalog_hmda, ev_catalog_y9c, ev_catalog_rssd9001, ev_catalog_crsp, ev_catalog_cpi, ev_catalog_riskfree

Preparation / proposed procedure:

1. Acquire the verified 2007–2012 CFPB LAR and 2010–2012 Reporter Panel products through the official public downloads after obtaining the author’s exact variable/vintage manifest; preserve their published CSV or Panel format and provenance.
2. For 1997–2006 LAR and 1997–2009 Panel inputs, inspect the NARA Catalog’s matching files and technical documentation; confirm the exact field layouts and Final/Ultimate vintage before treating them as compatible.
3. Resolve the 2004–2009 Panel Respondent RSSD ID bridge from an author-compatible source; do not replace it with Parent Identification Number without author evidence.
4. Verify current routes, history, fields, and authorized access for the remaining FR Y-9C, Call Report, SEC/10-K, CRSP/WRDS, macro-series, and MSA-crosswalk inputs only after the author manifest identifies exact products; no catalog miss proves absence or lack of license.
5. Perform only author-specified cleaning, merges, and format conversion after compatible inputs and author programs are established.

Validation to perform later:

- Match each acquired HMDA file to the author-declared year, product, fields, identifier mapping, action coding, and selected Final/Ultimate vintage.
- Check whether CFPB privacy modifications affect the specific fields used by the author before treating those data as fully compatible.
- Keep unresolved source history, field bridges, access conditions, and author transformations explicit until verified; do not substitute datasets.

### action_sas_environment: Resolve the SAS startup/TKELS initialization problem in the approved SAS environment, or obtain an author-supported working SAS environment. The current probe is inconclusive about license or entitlement; no installation or license inference is supported.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: soft_sas, issue_sas_runtime
Evidence: ev_sas_runtime, ev_software_workflow

Preparation / proposed procedure:

1. Have the environment administrator diagnose the TKELS initialization failure or provide a supported SAS runtime for the author's preparation program.
2. Confirm the required SAS version and any SAS/ACCESS or other components after the author supplies code.

Validation to perform later:

- Run a bounded empty-session/version probe successfully before attempting the author-provided preparation workflow.
- Compare runtime version and required components with author documentation once provided.

### action_conditional_run: No command can be specified for this package variant because no author entry points are included. Once the author programs and data manifest are supplied, execute the documented preparation and analysis branches in their verified producer-consumer order, retaining SAS and Stata logs and mapping each output to its paper or appendix result.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: issue_no_runnable_code, issue_workflow_contract
Evidence: ev_inventory, ev_annual_sample, ev_quarterly_sample, ev_software_workflow, ev_appendix_outputs

Preparation / proposed procedure:

1. Use only the author-provided entry points and input manifest; establish actual interleaving from generated intermediates before running any consumer.
2. Run the SAS preparation and Stata analysis steps in the author-confirmed order and preserve logs, session details, and output files.
3. Record the mapping between each executed entry point and every reported paper/appendix output.

Validation to perform later:

- Verify that every consumed intermediate has a completed documented producer and that every listed output was generated by its mapped author program.
- Review logs and output presence without treating execution as proof of numerical agreement; this assessment does not verify execution.


## Remaining issues and prerequisites

- issue_no_runnable_code [blocking; full_pipeline]: The supplied variant contains two PDFs only. No SAS data-preparation program, Stata analysis program, runnable entry point, data file, or analysis-only dataset is included. The narrative workflow is useful context but cannot be executed as code; the appendix's supplementary outputs have no supplied script mapping.
- issue_workflow_contract [unresolved; full_pipeline]: The policy describes source families and high-level construction steps, but exact file manifests, product/vintage/field contracts, generated intermediate filenames, full code-stage order, variable construction details, and the mapping from online-appendix outputs to entry points are not supplied. The new HMDA route evidence verifies some public product and period coverage but not every historical field/vintage; the author-specific 2004–2009 Reporter Panel RSSD linkage remains a separate unresolved gap. The frozen dependency checklist is empty, so executable closure cannot be established from these documents.
- issue_sas_runtime [preparation; full_pipeline]: SAS startup is unverified in this environment: the bounded environment probe failed while loading TKELS. The result does not establish whether the required SAS entitlement is present.
- issue_panel_rssd_mapping [unresolved; full_pipeline]: The author states that 2004–2009 Call Report RSSD9001 is matched to Reporter Panel Respondent RSSD ID, and that the 2004 mapping is reused for 1997–2003. The current CFPB 2007–2009 Panel specification documents respondent and parent identification fields but does not list Respondent RSSD ID. NARA lists historical Panel files but the exact 2004–2009 field layout/vintage has not been verified. Do not substitute Parent Identification Number or infer the missing bridge.
- req_y9c_annual [undetermined]: FR Y-9C bank financial records used in Part I to construct annual bank variables and merge with the mortgage sample; exact files, fields, and coverage are unverified.
- req_y9c_quarterly [undetermined]: FR Y-9C quarterly bank-holding-company records used for Part II's quarterly sample; the policy states a period but does not identify the exact products, variables, or compatible files.
- req_call_report_ids [undetermined]: Call Report identifier data used to connect HMDA commercial-bank lenders to FR Y-9C parent holding companies; historical linkage fields are described, but files and current coverage are not verified.
- req_otti_10k [undetermined]: Other-than-temporary impairment observations hand-collected from publicly listed banks' 10-K filings for 2008–2009; the filing list, extraction fields, and final data file are absent.
- req_crsp_macro [undetermined]: CRSP risk-free-rate and CPI series used in the annual analysis; exact product, fields, subscription entitlement, and file are not supplied.
- req_fed_macro [undetermined]: Term spread, default spread, and real GDP growth series used in the annual analysis; exact series identifiers, fields, and files are not supplied.
- req_msa_crosswalk [undetermined]: NBER mapping data connecting old MSAs for 1997–2003 to revised MSAs for 2004–2012, retaining unmatched old MSAs; the precise file/version and compatibility are not verified.
- req_hmda_lar_1997_2006 [undetermined]: HMDA Loan Application Register records for residential mortgage applications and approval/denial decisions for 1997–2006. NARA currently lists the historical HMDA LAR series and download access, but the year-level schema, file version, and required field mapping for this period have not been verified against the author workflow.
- req_hmda_lar_2007_2012 [public_acquisition_required]: HMDA LAR application and approval/denial records for 2007–2012. The current CFPB historical files expose the documented merge and action fields, but their privacy-modified values need comparison to the author’s 2013-era workflow before exact analysis-variable compatibility is concluded.
- req_reporter_panel_1997_2009 [undetermined]: HMDA Reporter Panel identifiers for 2004–2009 and the 2004 RSSD9001-to-Respondent ID mapping applied to 1997–2003. The author specifically needs a Reporter Panel Respondent RSSD ID field for the 2004–2009 linkage; the inspected public 2007–2009 panel specification does not document that field, and the NARA year-level schema is not verified.
- req_reporter_panel_2010_2012 [public_acquisition_required]: HMDA Reporter Panel fields for 2010–2012 used to connect HMDA lenders with FR Y-9C parent holding companies. The author uses Top Holder RSSD ID for these years; the current CFPB Panel specification documents that field.
- soft_sas [unverified]: The author states SAS converts raw data into analysis datasets. The supplied environment probe did not establish a working SAS session because TKELS initialization failed; this does not establish a missing entitlement or license.

## Review notes

- The assigned package contains only the online appendix and data-policy PDF; no author programs or datasets are included.
- Official current sources verify downloadable HMDA LAR 2007–2012 data and Reporter Panel 2010–2012 fields. The CFPB historic LAR data are privacy-modified; author-variable compatibility still needs confirmation.
- NARA lists downloadable HMDA LAR and Panel products covering the required historical years, but field layout and Final/Ultimate vintage for the author’s 1997–2006 LAR and 1997–2009 Panel inputs remain unresolved.
- The author-required 2004–2009 Reporter Panel Respondent RSSD ID is not listed in the CFPB 2007–2009 Panel specification; the 2010–2012 Top Holder RSSD ID is listed in the current Panel specification. No mapping substitution is proposed.
- Bounded catalog lookups found no HMDA or FR Y-9C local entries; CRSP hits were stock, link, and metadata resources, while CPI/risk-free-rate lookups were empty. These are catalog results only, not proof of absent access or licenses.
- No author code, regressions, data downloads, installations, or dataset reads were performed; no analysis_only route is supported.
