# Patch proposal: jar-18929bee0e23

Does access to patent information help technological acquisitions? Evidence from patent library openings

DOI: 10.1111/1475-679X.12592

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete supplied SAS/Stata workflow for Tables 1–12 and Figure 3, including SAS deal/control preparation, matching, failed-bid preparation, and the cross-language handoffs.

Entry points: `Code/0.1. SDC M&A Deals with Firm ID.sas`, `Code/0.2. Firm Controls.sas`, `Code/000. main.do`, `Code/2.1. For Matching.do`, `Code/2.2. Size Matched.sas`, `Code/2.3. Size&MB Matched Sample.do`, `Code/4.1. For Deal-level Analysis.do`, `Code/8.1. Failed Bids with Citations of the Target Patents.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 2/12592 - Does-access-to-patent-information-help-technological-acquisitions-Evidence-from-patent-library-openings/mqtzdatasheetcodeidentifiersandlogfiles.zip",
      "sha256": "35bdc726b37e30b0e5e51794700ac1e8fafd75e1bc7d3fbd8e39524e71d26f59"
    },
    {
      "path": "JAR-Volume 63/Issue 2/12592 - Does-access-to-patent-information-help-technological-acquisitions-Evidence-from-patent-library-openings/mqtz-online-appendix.pdf",
      "sha256": "96fc83f3b8f57666472abee0eccaf87730f49a9b9b1c326eb3ca702590bb9487"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "3835f92536bdbb85ab12e8392ddc2cda7aca948a6894d96ac23d1810460e530a"
}
```

## Proposed actions

### ACT_WRDS_INPUTS: Resolve the specific Compustat Annual field contract before staging the controls input; the local COMP.FUNDA candidate is readable at the catalog level but ADDZIP is absent from that product.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_COMPUSTAT_ANNUAL
Evidence: E_COMP_ANNUAL_FILTERS, E_COMP_CONTROL_FIELDS, E_SOURCE_FAMILY_CONTRACTS

Preparation / proposed procedure:

1. Use the compatible COMP.FUNDA annual product fields already confirmed in the bounded catalog metadata.
2. Identify the supported ADDZIP source or the author-prepared Compustat_Annual construction that supplies it; do not infer a separate join or force an unsupported alias.
3. Keep the exact study filters/years from supplied code and treat empirical historical coverage and September 2021 vintage as later validation, not prerequisites to recognizing COMP.FUNDA.

Validation to perform later:

- Before an authorized run, confirm the ADDZIP field mapping and required annual fields/keys in the staged Compustat input.

### ACT_AUTHOR_INPUTS: Locate or obtain the distinct author-prepared mapping, link, age, county, ZIP/SIC, patent, citation and keyword inputs, then confirm the actual schemas and periods.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_ADJ_SIC, REQ_CITATION_WEIGHTED_PATENTS, REQ_COMPUSTAT_LINK, REQ_COMP_AGE, REQ_COUNTY_PANEL, REQ_DEALNUM_GVKEY, REQ_HIST_SIC, REQ_HIST_ZIP, REQ_KEYWORD_COUNTS, REQ_KPSS_5YEAR, REQ_KPSS_PATENTS, REQ_KPSS_PATENT_LEVEL, REQ_KPSS_SIC, REQ_PATENT_BACKWARD_CITATION, REQ_STATE_CAPITALS, REQ_ZIP_COUNTY
Evidence: E_CHECKLIST, E_SCREEN, E_COUNTY_SOURCE, E_PATENT_SOURCE, E_OTHER_SOURCE

Preparation / proposed procedure:

1. Keep Comp_age, the two distinct link tables, historical ZIP/SIC inputs, KPSS products, county panel, ZIP crosswalk, citation products, and keyword counts separate.
2. For each author-prepared file, establish required columns, identifiers, units, date range, and its prepared-versus-raw status before staging it.
3. Do not demand original author bytes or full-population inspection when a compatible documented product and required fields are supported.

Validation to perform later:

- Use bounded metadata checks on the exact selected inputs before any separately authorized full-pipeline execution.

### ACT_MA_FYEAR_HANDOFF: Establish whether the SAS MA_fyear output and the Stata M&A_withID input are the same logical product and document their key/field mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_MA_FYEAR_HANDOFF
Evidence: E_SDC_READ, E_MAIN_ORDER, E_SCREEN

Preparation / proposed procedure:

1. Retain the two products as distinct until the producer output and consumer input schema are shown to align.
2. If they align, stage the required format/path conversion without changing the deal or fiscal-year definitions.

Validation to perform later:

- Validate the handoff keys, field names, dates and row-level construction after authorized preparation.

### ACT_FIRM_CONTROLS_HANDOFF: Identify the actual producer and field mapping for Firm_Controls.dta; do not substitute Comp_control, CRSP_control, or comp_crsp by filename similarity.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_FIRM_CONTROLS_HANDOFF
Evidence: E_CHECKLIST, E_COMP_PRODUCER, E_CRSP_CONTROL, E_COMP_CRSP

Preparation / proposed procedure:

1. Confirm whether a supplied export or copy step creates Firm_Controls.dta and which product fields it carries.
2. Treat a compatible alias/export as staging only after its underlying contract is supported.

Validation to perform later:

- Compare the staged Firm_Controls schema and keys with the consuming code before execution.

### ACT_BASE_SAMPLE_HANDOFF: Resolve the base raw sample and Table 3 sample producer-to-consumer contracts before running downstream analyses.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_BASE_SAMPLE_HANDOFF, ISSUE_TABLE3_HANDOFF
Evidence: E_CHECKLIST, E_MAIN_ORDER, E_SCREEN

Preparation / proposed procedure:

1. Trace Sample 1_Raw.dta from analytical-sample construction into Table 1–4, matching, Table 7, and deal-level analysis.
2. Confirm the exact Sample For Table 3.dta producer and the fields/keys required by Figure 3 and regressions.

Validation to perform later:

- Verify filenames, format, IDs, date fields, filters and branch order in the staged working copy.

### ACT_FIGURE3_HANDOFF: Confirm the independent inputs and producers used by Figure 3 while preserving its separately saved placebo coefficient products.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_FIGURE3_HANDOFF
Evidence: E_CHECKLIST, E_FIG3_OUTPUT, E_SCREEN

Preparation / proposed procedure:

1. Establish the producer and schema for Sample Placebo.dta, info_noCountyCtrl_1.dta and info_withCountyCtrl_1.dta.
2. Keep the source-proven placebocoef_withcountyctrl output as a generated edge and stage its downstream alias if needed.

Validation to perform later:

- Check the actual Figure 3 sample and coefficient outputs against the regression consumers after preparation.

### ACT_MATCHING_HANDOFF: Resolve matching inputs and outputs while preserving the supplied Stata-to-SAS-to-Stata preparation order.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_MATCHING_HANDOFF
Evidence: E_CHECKLIST, E_MAIN_ORDER, E_SAS_POTENTIAL_ACQ, E_SAS_DEALS

Preparation / proposed procedure:

1. Prepare Stata 2.1 before SAS 2.2, then run Stata 2.3 only after its exact matching inputs and SAS outputs are established.
2. Confirm Sample_for_Match, State Capitals, Sample For Table 1, Same_ind_match, Size_matched and Size_MB_matched keys and schemas.
3. Retain the exact Rand1/Rand2 generated loop products and do not replace them with independent datasets.

Validation to perform later:

- Validate each matched branch's identifiers, treatment/control pairing, output filename and downstream consumer before execution.

### ACT_TABLE8_HANDOFF: Obtain a safe specification of the Table 8 source inputs, remote market-data handoff, Eventus models and output schemas before attempting that branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_TABLE8_LIMITED, SW_EVENTUS
Evidence: E_TABLE8_LIMITED, E_TABLE8_VERIFY, E_MAIN_ORDER

Preparation / proposed procedure:

1. Keep Table 8 code present and retain the exact market-value, acquirer CAR, target CAR, long-term return, innovative-acquirer and Table 8 sample contracts as unknown.
2. Confirm authorized Eventus and market-data access and model/output definitions without a connection, query or credential test during this assessment.
3. Stage any compatible same-product control aliases as preparation, while validating required Table 8 consumer fields separately.
4. Confirm whether CRSP Daily is actually consumed by the withheld Table 8 branch; do not create a separate daily-source gate until its exact fields and role are established.

Validation to perform later:

- Before a separately authorized run, verify the exact model parameters, security identifiers, event windows, output keys, data period and Eventus software availability.

### ACT_INTERNAL_TEMP_HANDOFF: Verify the active producer statements and local tempfile lifetimes for the Table 9 and failed-bid temporary products.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_INTERNAL_TEMP_HANDOFF
Evidence: E_CHECKLIST, E_SCREEN

Preparation / proposed procedure:

1. Confirm the saves and consumers for pre_announcement and deal_expand in Table 9 and pre_announcement in failed-bid preparation.
2. Keep each tempfile within its creating program and do not treat its name as a separate raw input.

Validation to perform later:

- Check each tempfile is populated by its upstream stage before the consuming statement in a separately authorized run.

### ACT_FAILED_BID_HANDOFF: Establish the matched failed-bid sample producers and the citation-matched Table 12 outputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_FAILED_BID_HANDOFF
Evidence: E_CHECKLIST, E_SCREEN

Preparation / proposed procedure:

1. Confirm the exact source and identifiers for Failed Bids_Size Matched and Failed Bids_Size&MB Matched.
2. Run failed-bid citation preparation before Table 12 only after its patent-level and backward-citation inputs are supported.
3. Confirm the final citation-matched output filenames, schemas and consumers.

Validation to perform later:

- Validate failed-bid/acquirer/target IDs, patent keys, matching definitions and output names before authorized execution.

### ACT_REGRESSION_HANDOFF: Complete the remaining table-sample producer and regression handoff map, then retain the supplied main-driver order.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_REGRESSION_HANDOFF, ISSUE_INITIAL_CLOSURE
Evidence: E_MAIN_ORDER, E_FIG3_OUTPUT, E_CHECKLIST, E_SCREEN

Preparation / proposed procedure:

1. Resolve Sample For Table 1, Sample For Table 3, Sample2_Size, Sample2_Size_MB, Sample For Table7, Table 9/10/11 samples and both Table 12 matched samples.
2. Prepare SAS 0.1/0.2 before Stata 0.3; prepare matching (2.1, 2.2, 2.3) before 2.4; prepare 4.1 before Table 8; prepare 8.1 before Table 12.
3. Then retain the main driver sequence through Table 1–4, Table 5–6, Table 7, Table 8, Tables 9–12, Figure 3 and regressions.

Validation to perform later:

- Review all 101 dependency IDs and all source-hidden handoffs before authorizing a run; keep execution_verified false until an authorized execution occurs.

### ACT_CONTROL_STAGING: Stage the source-proven SAS Comp_control and CRSP_control products into the downstream Stata paths/formats without adding new raw-data requirements.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: ISSUE_CONTROL_FORMAT_STAGING
Evidence: E_COMP_PRODUCER, E_CRSP_CONTROL, E_MAIN_ORDER

Preparation / proposed procedure:

1. Use a working copy and apply only compatible export, filename, library and extension mapping for the same control products.
2. Preserve the documented annual controls and 12-month CRSP construction; do not alter their definitions.

Validation to perform later:

- After authorized staging, compare actual field names, identifiers and periods with each visible Stata consumer; retain whole-history validation for later.

### ACT_RUNTIME_CONFIRM: Confirm the authorized SAS runtime and SAS/ETS component required for the supplied SAS controls workflow.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_SAS_ETS
Evidence: E_TWO_LANGUAGES, E_ENV, E_CRSP_CONTROL

Preparation / proposed procedure:

1. Use the authorized environment and version metadata; do not start SAS during this assessment.
2. Confirm that PROC EXPAND is available in the intended runtime before a separate authorized run.

Validation to perform later:

- Record the runtime/component availability and version context for the future run.

### ACT_WINSOR2_SETUP: Make winsor2 available in the authorized Stata environment before the supplied analysis is attempted.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2
Evidence: E_WINSOR2_PROBE

Preparation / proposed procedure:

1. Install or configure the author's required winsor2 command only through the authorized package-management process; no installation was performed here.

Validation to perform later:

- After setup, run a future exact which winsor2 metadata check and preserve its provider/version context.

### ACT_SDC_STAGE: Stage the verified local SDC M&A fields under the aliases expected by the supplied SAS code.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_SDC_MA
Evidence: E_SDC_ACQ_FIELDS, E_SDC_TARGET_FIELDS, E_SDC_SCHEMA, E_SDC_MA_PROBE

Preparation / proposed procedure:

1. In a working copy, map MASTER_DEAL_NO to deal_number, ACUSIP to Acquirer_CUSIP, MASTER_CUSIP to Target_CUSIP, and DATEANN to Date_Announced.
2. Preserve the six-character CUSIP identifiers and DATEANN's SAS date format when staging the same SDC deal product.
3. Keep the separate DealNumber-to-GVKEY mapping input as its own required route.

Validation to perform later:

- Check the staged aliases, 6-character CUSIP widths, deal key and announcement-date type against the visible SAS joins before a separately authorized run.

### ACT_LINKING_2019_STAGE: Stage the verified CRSP.CCMXPF_LINKTABLE fields through the separate 2019 linking-file consumer contract.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_LINKING_2019
Evidence: E_LINKING_TABLE_2019, E_CCM_READ, E_CCMXPF_PROBE

Preparation / proposed procedure:

1. In a working copy, map the local CCMXPF fields GVKEY, LPERMNO, LPERMCO, LINKPRIM, LINKTYPE, USEDFLAG, LINKDT, and LINKENDDT to the DATA.LINKING_TABLE_UPTO2019 consumer path.
2. Preserve the visible 1973-2019 period, replace missing LINKENDDT with 31 Dec 2019, retain LINKPRIM C/P, exclude LINKTYPE NR/NU and USEDFLAG -1, and preserve the source Begyear/Endyear adjustment.
3. Keep this separately consumed contract distinct from the SDC `link.sas7bdat` input, even though both can use independently justified routes.

Validation to perform later:

- Confirm mapped field names, key types and date semantics against the visible SAS consumer; defer full historical coverage and author-vintage fidelity to later validation.


## Remaining issues and prerequisites

- ISSUE_INITIAL_CLOSURE [unresolved; full_pipeline]: All 101 frozen dependency IDs are assigned exactly once below, but several consumed inputs and producer-consumer handoffs remain specifically unresolved. Source-hidden programs remain present; this is not a missing-code or missing-data finding.
- ISSUE_MA_FYEAR_HANDOFF [unresolved; full_pipeline]: The SAS SDC preparation's MA_fyear construction and the Stata analytical-sample M&A_withID handoff must remain distinct until their fields, keys, and exact conversion are established.
- ISSUE_FIRM_CONTROLS_HANDOFF [unresolved; full_pipeline]: The Firm_Controls.dta input to analytical-sample construction is not proven to be the same logical product as SAS Comp_control, CRSP_control, or comp_crsp. Confirm the producer and field mapping before treating it as a generated alias.
- ISSUE_BASE_SAMPLE_HANDOFF [unresolved; full_pipeline]: Sample 1_Raw.dta is consumed by the Table 1–4, matching, Table 7, and deal-level preparation branches, but the reviewed evidence does not establish its exact producer, field contract, or cross-language handoff.
- ISSUE_TABLE3_HANDOFF [unresolved; full_pipeline]: Sample For Table 3.dta is consumed by Figure 3 and the regression script; its active producer and keys are not established by the retained source evidence.
- ISSUE_FIGURE3_HANDOFF [unresolved; full_pipeline]: The Figure 3 branch consumes Sample Placebo.dta and info_noCountyCtrl_1/info_withCountyCtrl_1 products. The active producers and input contracts remain unresolved; the known placebocoef_withcountyctrl output is separately source-proven.
- ISSUE_MATCHING_HANDOFF [unresolved; full_pipeline]: The matching branch requires Sample_for_Match, Sample For Table 1, Same_ind_match, Size_matched, and Size_MB_matched. The exact producer paths, keys, and format handoffs are not established; preserve the SAS/Stata interleaving.
- ISSUE_TABLE8_LIMITED [unresolved; full_pipeline]: The supplied Table 8 program remains present but its entire 310-line body is withheld in the verified safe view. Exact CRSP market-value, acquirer/target CAR, long-term-return, innovative-acquirer, Eventus, model/output and Table 8 sample contracts remain unknown. The datasheet mentions CRSP Daily, but this review cannot establish whether Table 8 consumes it. Do not infer missing code, missing data, or service availability.
- ISSUE_INTERNAL_TEMP_HANDOFF [unresolved; full_pipeline]: The dependency ledger identifies pre_announcement/deal_expand temporary products in Table 9 and pre_announcement in failed-bid preparation, but the retained source-evidence record does not establish the active save/consumer contract for these dynamic tempfile aliases.
- ISSUE_FAILED_BID_HANDOFF [unresolved; full_pipeline]: The failed-bid branch reads two matched failed-bid samples and later Table 12 citation-matched samples; exact active producers, keys, and matching-branch formats remain unresolved.
- ISSUE_REGRESSION_HANDOFF [unresolved; full_pipeline]: The regression script consumes multiple table-specific samples from earlier branches. Except for the source-proven Figure 3 coefficient file, the retained evidence does not establish the exact active producers and field contracts for these outputs.
- ISSUE_CONTROL_FORMAT_STAGING [preparation; full_pipeline]: SAS produces Comp_control and CRSP_control products used by visible Stata branches. Export, working-library, filename, and DTA format alignment are preparation steps for the same supported products; do not add new raw-data requirements solely for those aliases.
- REQ_DEALNUM_GVKEY [undetermined]: The author mapping imported by SAS 0.1 joins SDC deal_number to mapping DealNumber and supplies acquirer/target GVKEY links. Its source path is withheld as a filesystem candidate and the file itself has not been probed.
- REQ_COMPUSTAT_ANNUAL [undetermined]: Compustat Annual fundamentals used by both SAS preparation programs. The visible code applies INDL/STD/D/C filters and consumes annual fields for controls; its controls construction also selects ADDZIP.
- REQ_COMPUSTAT_LINK [undetermined]: The separate link.sas7bdat input read in the SDC preparation. Its product and relationship to CCMXPF are not established, so it remains separate.
- REQ_COMP_AGE [undetermined]: Comp_age.dta, an author-prepared control input; its required fields and producer are not verified.
- REQ_HIST_ZIP [undetermined]: Historical ZIP-code input used by the controls construction; variable meaning, history, and route remain unverified.
- REQ_ADJ_SIC [undetermined]: Adjusted SIC input used by the controls construction; its mapping and author-compatible history remain unverified.
- REQ_HIST_SIC [undetermined]: Historical_SIC.dta used by analytical-sample construction; required mapping and period remain unverified.
- REQ_KPSS_SIC [undetermined]: KPSS_SIC.dta is a distinct author-prepared SIC input used by the analytical sample; its definition and period are unverified.
- REQ_KPSS_5YEAR [undetermined]: KPSS_5Year.dta is a distinct author-prepared five-year patent input; its construction and period are unverified.
- REQ_COUNTY_PANEL [undetermined]: County_population_1969-2018.dta is the prepared county panel consumed in multiple study branches. The datasheet names NCI population and BEA personal-income sources; the file's complete county/year construction and fields are not verified.
- REQ_ZIP_COUNTY [undetermined]: ZIP_COUNTY_032020.xlsx supplies the ZIP-to-county mapping used by analytical-sample construction; workbook fields and import mapping are unverified.
- REQ_STATE_CAPITALS [undetermined]: State Capitals.xlsx is a separate manual lookup input for the matching branch; its keys and construction are unverified.
- REQ_CITATION_WEIGHTED_PATENTS [undetermined]: Citation_wt_Patents.dta is a separate patent citation-weighted input required by the post-merger innovation branch.
- REQ_KEYWORD_COUNTS [undetermined]: Deal-level Keywords Count.dta is the actual prepared keyword-count input to the Table 11 branch; SEC and patent-abstract source references do not establish this file's fields or coverage.
- REQ_KPSS_PATENT_LEVEL [undetermined]: KPSS_Patent_level.dta is a required patent-level input to failed-bid citation preparation.
- REQ_PATENT_BACKWARD_CITATION [undetermined]: Patent_Backward_Citation.dta is a distinct patent citation input to failed-bid citation preparation.
- REQ_KPSS_PATENTS [undetermined]: kpss_patents.dta is a distinct product from KPSS_Patent_level.dta and remains a separate required input.
- SW_SAS [unverified]: The datasheet and supplied SAS programs require SAS, while the registered environment projection reports SAS unverified. The audit did not start SAS.
- SW_SAS_ETS [unverified]: PROC EXPAND appears in the supplied controls workflow; SAS/ETS availability and version context were not verified.
- SW_EVENTUS [unverified]: Eventus is part of the unresolved Table 8 market-data/event-study handoff; its availability and exact required model/output contract were not verified.
- SW_WINSOR2 [preparation_required]: The exact Stata command probe reports winsor2 unavailable. This is an ordinary software-setup task; no installation was performed.

## Review notes

- The supplied InSample_GVKEY_Year.csv is an identifier list, not a full analysis panel; no analysis_only scope is supported.
- The local SDC.WRDS_MA_DETAILS product has source-labeled deal ID, acquirer/target CUSIP and announcement-date fields matching the visible SAS contract; alias and format staging is preparation. The separate DealNumber-to-GVKEY mapping remains unverified.
- CRSP.MSF is a readable local monthly product with every field selected in the visible controls source. COMP.FUNDA is a compatible annual candidate except that the visible controls source also requires ADDZIP; that specific field/producer mapping remains unresolved.
- CRSP.MSENAMES and CRSP.CCMXPF_LINKTABLE are separately verified underlying products with their consumed fields. Bounded probes do not establish full populations or exact author vintage; no whole-data sweep is required.
- Keep MA_fyear separate from M&A_withID, CCMXPF_LINKTABLE separate from linking_table_upto2019 and link.sas7bdat, and KPSS_Patent_level separate from kpss_patents until source contracts support a mapping.
- The complete Table 8 program is present but wholly withheld in coordinator-verified safe metadata. Its exact remote source/model/output contracts remain limited-review unknowns; CRSP Daily is not asserted as a mandatory independent input because the withheld body prevents confirming its use.
- Source-proven generated controls, matching work tables, main-driver stages and the Figure 3 coefficient file are reviewed as generated edges. Future output files need not exist before execution; unresolved producers remain issue-linked.
- No author code, SAS process, data payload, remote service, or software installation was executed. This assessment does not verify execution success.
