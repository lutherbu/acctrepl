# Patch proposal: jar-8043a8cd4936

Do Shared Auditors Facilitate Follow-on Innovation?

DOI: 10.1111/1475-679X.70010

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-supplied five-file Stata workflow: raw-source cleaning, main pair-year construction, companion panels, and manuscript/appendix tables and figures.

Entry points: `Codes for JAR/0_master.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70010 - Do-Shared-Auditors-Facilitate-Follow-on-Innovation/tyz-datasheet-code-identifier-and-log-files.zip",
      "sha256": "5e05712f16cccb522561622e5d950b4db3285e4776ffee0ad2edb8376adac3d8"
    },
    {
      "path": "JAR-Volume 64/Issue 1/70010 - Do-Shared-Auditors-Facilitate-Follow-on-Innovation/tyz-online-appendix.pdf",
      "sha256": "234e6a3a59078b2ef32b56f3624b55061d3e5eaac5b3fd0a1c4450a19ec72e56"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "6cdff00381d16c3dd61a035ab8987dd5123140e30bc8b3e79aa7882c430033bc"
}
```

## Proposed actions

### A_WORKING_COPY_LAYOUT: Stage a separate, self-contained working tree whose relative paths match the master and analysis scripts.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_WORKDIR_LAYOUT
Evidence: E_README_WORKFLOW, E_MASTER_ROOT, E_MASTER_ORDER

Preparation / proposed procedure:

1. Create a separate project root and copy the unmodified 0_master.do into it.
2. Create its data directory and stage the four called preparation/analysis do-files there so the relative calls resolve after cd data.
3. Stage inputs under that runtime data directory and pre-create the output and TNIC\tnic_all_data directories referenced by the scripts.

Validation to perform later:

- Before a later run, check each relative do-file/data/output path from the master’s post-cd working directory.

### A_STAGE_VERIFIED_RAW_SOURCES: Prepare Stata-format working copies from the readable local raw products while preserving native identifiers, dates and source case mappings.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_IBCRSPHIST, R_COMP_FUNDAMENTALS_RAW, R_COMP_COMPANY, R_CCM_LINKTABLE, R_CRS_MSNAMES, R_CRS_DSF, R_DET_EPSUS, R_AUDIT_OPINIONS
Evidence: E_RAWPROBE_MATRIX_V6, E_SCHEMA_COMP, E_SCHEMA_IBES, E_PROBE_IBCRSPHIST, E_PROBE_COMP_FUNDA, E_PROBE_COMP_COMPANY, E_PROBE_CCMXPF, E_PROBE_MSENAMES, E_PROBE_DSF, E_CCM_COMP_CONSTRUCTION, E_PROBE_DET_EPSUS, E_DET_EPSUS_CONTRACT, E_PROBE_AUDIT_OPINIONS_CANDIDATE, E_SCHEMA_AUDIT, E_AUDIT_AND_LINK_INPUTS, E_RANGEJOIN_GRAMMAR

Preparation / proposed procedure:

1. In the separate data directory, stage the probed raw IBCRSPHIST, COMP.FUNDA, COMP.COMPANY, CCMXPF_LINKTABLE, MSENAMES and DSF files using their exact locations and native field names.
2. Convert the SAS inputs to Stata files required by the author paths; apply the explicit case(upper) mappings only where the supplied import specifies them.
3. Build the author-named funda_allvar.dta and other derived aliases from the raw Compustat/CCM/CRSP sources only after preserving the documented date and link rules; do not treat the one-row probes as coverage checks.
4. Stage DET_EPSUS as the using point file with CUSIP/ACTDATS/ANALYS; keep SDATE/EDATE on the IBCRSPHIST master. Stage the raw audit-opinion keys separately from the AA office and CIK/GVKEY/PERMNO handoffs.

Validation to perform later:

- Check staged field names/types against the source consumers and full selected native schemas; then verify the intended historical spans and identifier/date mappings on the prepared files before any authorized execution.

### A_RESOLVE_PREPARED_HANDOFFS: Resolve the prepared-file contracts that the source names but the retained package/probes do not yet establish.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMMON_ALLIANCE, R_AA_PREPARED, R_CIK_GVKEY_LINK, R_GVKEY_PERMNO_LINK, R_FUNDA_PREPARED, R_OFFICIAL_KAPPAS, R_PAIR_YEAR, R_INSTOWN_PERCENT, R_INNOVATION_VALUE_INPUT, I_INPUT_PRODUCER_CLOSURE
Evidence: E_COMMON_ALLIANCE_CONTRACT, E_AUDIT_AND_LINK_INPUTS, E_AA_PREPARED_INPUT, E_FUNDA_PANEL_CONSUMER, E_OFFICIAL_KAPPAS, E_PAIR_YEAR_CONSUMER, E_INSTOWN_INPUT, E_INNOVATION_VALUE_INPUT, E_PROBE_DET_EPSUS, E_SCHEMA_SDC, E_SCHEMA_TFN, E_RANGEJOIN_GRAMMAR

Preparation / proposed procedure:

1. Confirm the exact alliance pair/date source and population for CommonAlliance_CUSIP; the using file must supply date and CUSIP1/CUSIP2 while IBCRSPHIST supplies SDATE/EDATE intervals.
2. Confirm the source/creation rules for company-pair-year_2000-2018.dta, FUNDA.dta, official-kappas.dta and innovation_value_to_merge.dta.
3. Resolve the separate CIK_GVKEY2.dta and GVKEY2PERMNO.dta link histories/year rules, plus the AA.dta auditor-office input; do not collapse these into the verified raw audit-opinion product.
4. For InstOwn_Perc.dta, specify the required holdings-to-PERMNO/year percentage construction before using a 13F candidate.
5. Do not infer a producer for source ranges that remain opaque; bind any clarified handoff to its exact field, date and identifier contract.

Validation to perform later:

- Compare each clarified file to its active consumer keys, measures, period and producer source; retain separate history/measurement definitions where the product differs.

### A_PIN_PUBLIC_DATA_VINTAGES: Acquire or stage the supported author/official raw products and resolve only the remaining table-schema gaps; do not require original filenames or bytes when the documented product contract matches.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_PATENT_CITATION, R_G_APPLICATION, R_KPSS, R_PATENT_CPC, R_TNIC_ANNUAL, R_PATENT_INVENTOR
Evidence: E_PATVIEW_CURRENT, E_PATVIEW_FINAL_RELEASE, E_KPSS_AUTHOR_README, E_HOBERG_PHILLIPS, E_PATENT_CITATION_CONSTRUCTION, E_CPC_CONSTRUCTION, E_TNIC_INPUT, E_KPSS_YEAR_PARSERS, E_RANGEJOIN_GRAMMAR, E_SOURCE2_PATVIEW_FRAME_CREATE, E_SOURCE2_G_APPLICATION_IMPORT, E_SOURCE2_KPSS_FRAME, E_SOURCE2_KPSS_KEEP_IDS, E_SOURCE2_PATVIEW_FILDATE_OWNER

Preparation / proposed procedure:

1. For PatentsView citation/application products, confirm that the public tables expose the source-consumed patent_id, citation_id/category and filing_date fields with the date encoding required by the Stata consumers; then stage the compatible release under the relative aliases. Source2's filing_date is fetched from the patentview frame loaded from g_application.dta; verify that PatentsView field's encoding separately from the KPSS panel field.
2. Acquire the author KPSS 1926-2025 panel and patent-CPC match products using their documented fields and pin their current hashes. Record that updated CRSP matches/KPSS estimates can differ from the QJE vintage; do not treat that vintage difference or current filename as a missing-data barrier.
3. Use the documented CPC patent_num/cpc fields with the source's split/truncate/merge preparation; identify the separate patent-inventor handoff and exact 2000-2018 TNIC annual files/score fields through their author/official routes.

Validation to perform later:

- After any authorized acquisition, verify the documented source fields, date encodings, identifiers and periods against the consumers; preserve the KPSS release/matching vintage. No data payload was downloaded for this assessment.

### A_SETUP_STATA_COMMANDS: Make the checked active Stata commands available through a supported ado path before a later run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_FSUM, S_RANGEJOIN, S_GDUPLICATES, S_GEGEN, S_GROUPS, S_WINSOR2, I_STATA_ADDON_SETUP
Evidence: E_ENVIRONMENT, E_SW_FSUM, E_SW_RANGEJOIN, E_SW_GDUPLICATES, E_SW_GEGEN, E_SW_GROUPS, E_ANALYSIS_MAIN_AND_TABLE4, E_ANALYSIS_GROUPS

Preparation / proposed procedure:

1. Use the site's supported package source/setup for fsum, rangejoin, gduplicates, gegen, groups and winsor2; do not replace the author commands until any alternative is checked for matching behavior.
2. Add the installed ado locations to the intended Stata profile or run environment without changing author scripts.

Validation to perform later:

- Run Stata which checks for each exact command on the final adopath and record versions; inspect the resolved commands before a separately authorized full workflow run.

### A_RUN_AFTER_PREPARATION: After all data and software prerequisites are resolved, follow the author master sequence and retain generated outputs in the working copy.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_MASTER_ORDER, E_MAIN_OUTPUT, E_MAIN_1980_OUTPUT, E_ANALYSIS_MAIN_AND_TABLE4, E_ANALYSIS_EXTENDED_AND_INNOVATION

Preparation / proposed procedure:

1. Run 0_master.do from the project root only after the data, producer, working-directory and ado contracts are confirmed.
2. Keep main.dta and main_1980_2018.dta as separate output variants and produce the companion tables/figures in the designated output directory.

Validation to perform later:

- Compare the later run's generated samples, variables and tables with the author outputs and paper/appendix specifications; execution remains unverified in this static assessment.


## Remaining issues and prerequisites

- I_WORKDIR_LAYOUT [preparation; full_pipeline]: The master first changes into a relative data directory and then calls four do-files by relative name, while the package stores all five scripts under Codes for JAR. A separate staged working tree needs a coherent root, data subdirectory and output/TNIC directories.
- I_INPUT_PRODUCER_CLOSURE [unresolved; full_pipeline]: Required handoffs still lack verified field/history/producer contracts: the CommonAlliance pair/date population, prepared FUNDA and company-pair-year panels, separate CIK/GVKEY and GVKEY/year/PERMNO links, AA.dta office data, official-kappas.dta, InstOwn_Perc.dta and innovation_value_to_merge.dta. PatentsView citation/application fields, inventor data and exact TNIC annual score files also remain unresolved. The raw DET_EPSUS and audit-opinion components are supported; their separate prepared link/office dependencies remain distinct. Source2's PatentsView filing_date comes from g_application.dta; its date encoding remains a separate unresolved contract and is not supplied by the KPSS README.
- I_STATA_ADDON_SETUP [preparation; full_pipeline]: Stata itself and core estimation/table tools are available, but active calls to fsum, rangejoin, gduplicates, gegen, groups and winsor2 are not found in the checked adopaths; they need a supported ado setup before a run.
- R_COMMON_ALLIANCE [undetermined]: Prepared alliance CUSIP-pair observations with CUSIP1, CUSIP2 and a date point variable, joined against the SDATE/EDATE effective interval on the IBCRSPHIST master. The exact alliance population and producer remain unresolved.
- R_PATENT_CITATION [undetermined]: PatentsView citation-level records with patent/citation IDs and citation category used to build pair-year citations and applicant/examiner splits.
- R_G_APPLICATION [undetermined]: PatentsView g_application.dta application-level patent_id/filing_date input used to date citation pairs; source2 obtains filing_date from the separate patentview frame, not from the KPSS panel.
- R_KPSS [public_acquisition_required]: Author-provided KPSS patent panel linking patent_num to PERMNO with issue_date and filing_date across the 1980-2018 construction period; the current release documents updated CRSP matching and KPSS measurement vintage.
- R_PATENT_CPC [public_acquisition_required]: Patent-to-CPC history used to construct time-varying technological similarity.
- R_PATENT_INVENTOR [undetermined]: Patent-inventor rows with patent_id, inventor_id and location_id used for common-inventor construction.
- R_AA_PREPARED [undetermined]: Prepared auditor-office records consumed from AA.dta with form, office, year and PERMNO fields.
- R_CIK_GVKEY_LINK [undetermined]: CIK-to-GVKEY link used to map audit-opinion company keys.
- R_GVKEY_PERMNO_LINK [undetermined]: Effective-dated GVKEY-to-PERMNO mapping keyed by year for audit-opinion linkage.
- R_FUNDA_PREPARED [undetermined]: Prepared FUNDA.dta firm-year panel with PERMNO/YEAR and Compustat measures consumed by size and innovation construction.
- R_OFFICIAL_KAPPAS [undetermined]: Pair-year official CommonOwnership input used for main and extended samples.
- R_PAIR_YEAR [undetermined]: Prepared company-pair-year 2000-2018 panel consumed by other-dataset construction.
- R_INSTOWN_PERCENT [undetermined]: Prepared PERMNO-year institutional ownership percentage used as InstOwn_Perc in firm-year controls.
- R_INNOVATION_VALUE_INPUT [undetermined]: Prepared innovation_value_to_merge.dta with PERMNO/YEAR and the scope/originality/novelty outcomes used by table 8.
- R_TNIC_ANNUAL [undetermined]: Annual 2000-2018 TNIC firm-pair GVKEY similarity files joined to the analysis pairs.
- S_FSUM [preparation_required]: Active summary-statistic calls use fsum; exact which metadata did not find it in the checked adopath.
- S_RANGEJOIN [preparation_required]: Active dated interval joins use rangejoin; exact which metadata did not find it.
- S_GDUPLICATES [preparation_required]: Active source construction invokes gduplicates; exact which metadata did not find it.
- S_GEGEN [preparation_required]: Active source construction invokes gegen; exact which metadata did not find it.
- S_GROUPS [preparation_required]: Appendix analysis invokes groups; exact which metadata did not find it.
- S_WINSOR2 [preparation_required]: Active winsorization calls need winsor2; it was not found in the retained checked adopath metadata.

## Review notes

- Assessment covers the complete full_pipeline only. The packaged identifier_permnos.csv is a readable pair-identifier list, not prepared analysis data; no analysis_only scope is supported.
- Verified local routes refer to compatible raw source products with direct one-row probe evidence and complete selected native schemas. They do not establish sample coverage or prebuilt Stata aliases; required format conversion and ordinary staging remain preparation.
- Rangejoin field ownership is assigned from its author's command description: IBCRSPHIST master rows retain SDATE/EDATE intervals; DET_EPSUS using rows supply ACTDATS/CUSIP/ANALYS; the CommonAlliance using file supplies date/CUSIP pairs while IBCRSPHIST remains the interval master. DET_EPSUS is a verified raw component; CommonAlliance population/producer remains unresolved.
- The raw revised audit-opinion candidate has the matching product label, all three source-consumed keys and a readable direct probe. Its source filter/deduplication is ordinary preparation; AA.dta office data, CIK_GVKEY2.dta and GVKEY2PERMNO.dta are separate unresolved handoffs.
- The KPSS README's mm/dd/yyyy representation applies to the KPSS panel used in source1. Source2 fetches its filing_date from the separate patentview frame, loaded from g_application.dta; the PatentsView date encoding remains unresolved. The existing first-four-character operation is recorded as source behavior only; no parser error is asserted and no source edit is proposed.
- The retained rawprobe_matrix_v6 records existing full-schema/probe relationships and missing v5 stdout/stderr/return/timing retention; those values were not reconstructed. TFN.S34's retained bounded read timed out and remains a readability unknown, not evidence of missing data or a license barrier; no retry was made.
- The screened ranges remain opaque/unclassified and the associated source-screen manifests are process metadata only. No claim about masked content, active/absent producers or secret absence derives from them.
- PatentsView field/date contracts and TNIC annual file fields remain unverified public inputs; no data payloads were downloaded. No author source was changed or executed, and no regression, statistical or synthetic trial was run.
