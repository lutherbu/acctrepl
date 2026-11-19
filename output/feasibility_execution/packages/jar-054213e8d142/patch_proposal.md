# Patch proposal: jar-054213e8d142

The Impact of Information Processing Costs on Firm Disclosure Choice: Evidence from the XBRL Mandate

DOI: 10.1111/1475-679X.12268

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied data-preparation branch: active SAS construction through dxbrl.final2 plus the embedded Stata variable-preparation fragment. The release does not supply the upstream raw SEC/XBRL producers or the regression programs; those remain outside an independent reconstruction target and are recorded as unresolved input/driver contracts.

Entry points: `Code Description.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 4/12268 - The-Impact-of-Information-Processing-Costs-on-Firm-Disclosure-Choice-Evidence-from-the-XBRL-Mandate/blankespoor-datasheet-and-code.zip",
      "sha256": "ba9ce4b66576a8274454bc9f80384708f3335a21343041edbe8e255e676cbcbd"
    },
    {
      "path": "JAR-Volume 57/Issue 4/12268 - The-Impact-of-Information-Processing-Costs-on-Firm-Disclosure-Choice-Evidence-from-the-XBRL-Mandate/blankespoor-internet-appendix.pdf",
      "sha256": "480e2eaf01a5afefe56038ed63124c785c6a63f8f018d2bb38755a31c98aec8d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "89eb88035392bc4a0badf29663ac006f8e69f9647dd17dd906e480f8f46f69aa"
}
```

## Proposed actions

### ACT_sec_acquisition: Use the official EDGAR route for the author-defined 10-K population once study endpoints, accession rules and filing versions are established. Raw filings still require the author-specific section, text-statistic, float and correction preparation documented separately.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_sec_filing_text
Evidence: EV_SEC_PUBLIC, E018, E019

Preparation / proposed procedure:

1. Resolve exact sample years, accession inclusion rules and document types from the supplied study materials.
2. Acquire only the identified SEC filing documents through the official EDGAR route if no compatible prepared text input is supplied.
3. Apply or obtain the documented author preprocessing and correction outputs; do not substitute generic LM files or a broad corpus scan.

Validation to perform later:

- Confirm complete expected accession coverage and document-version selection for the sample.
- Compare output schema and selected filing-level fields with dxbrl.final_10k_withxbrl before downstream use.

### ACT_local_historical_sources: Validate the catalog-identified licensed local candidates and obtain compatible sample-period extracts using the study filters and linking rules. The candidates do not establish the user’s entitlement, full historical coverage, or exact author-specific field mapping.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_compustat_annual, REQ_ccm_permno_link, REQ_cik_gvkey_links, REQ_cik_cusip_links, REQ_crsp_daily, REQ_crsp_market_index, REQ_crsp_sharecodes, REQ_ibes_analyst_summary, REQ_ibes_crsp_link, REQ_compustat_segments, REQ_institutional_holdings
Evidence: E004, E005, E006, E008, EV_COMP_FUNDA, EV_CCM_LINK, EV_CIK_GVKEY, EV_CIK_CUSIP, EV_CRSP_DSF, EV_CRSP_DSI, EV_CRSP_STOCKNAMES, EV_IBES_SUMMARY, EV_IBES_LINK, EV_COMP_SEGMENTS, EV_TFN_S34

Preparation / proposed procedure:

1. Confirm current entitlement and required historical coverage for each listed licensed product.
2. Match the exact source fields, date windows, identifiers, link filters and transformations in the supplied SAS descriptions.
3. Treat CRSP daily security returns and DSI VWRETD as separate inputs; resolve the author’s share-code date-variable mapping.
4. Resolve IBES period/value and ICLINK fields against the supplied PDICITY/VALUE/score logic before mapping a candidate.
5. Confirm S34 readability, coverage and share aggregation/denominator contract; the one-row probe timed out and was not retried.
6. Produce only the named study-period extracts after field and transformation contracts are confirmed.

Validation to perform later:

- Verify required variables and date ranges for each table, including the exact join keys and validity periods.
- Reconcile source row counts and constructed intermediate fields with the supplied program descriptions.

### ACT_xbrl_access: Confirm whether current XBRL-US access provides the required historical filing listing, taxonomy/tag fields, presentation sections and detailed TextBlock footnote data. Exact historical schemas and user entitlement are unverified; SEC company-facts fields are not treated as equivalent.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_xbrl_filing_tags, REQ_xbrl_footnote_detail
Evidence: EV_XBRL_PUBLIC, E003, E009, E011

Preparation / proposed procedure:

1. Verify available years and current user entitlement for the XBRL-US filing database.
2. Obtain the historical field dictionary/schema for filing identifiers, taxonomy/element, presentation section and footnote TextBlock content.
3. Confirm whether description, raw block text and Perl-derived counts are available or require the missing author producer.

Validation to perform later:

- Verify schema and historical coverage against raw_extra_footnotes and final_10k_withxbrl consumers.
- Confirm accession/date correction and manual adoption-adjustment requirements before selecting any substitute.

### ACT_prepared_input_or_scripts: First determine whether compatible prepared dxbrl.final_10k_withxbrl and dxbrl.raw_extra_footnotes inputs are available. If not, obtain the exact upstream producer programs, schemas and correction records; the supplied release does not support independently recreating those author-specific outputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_upstream_preparation, REQ_sec_filing_text, REQ_xbrl_filing_tags, REQ_xbrl_footnote_detail
Evidence: E002, E003, E009, E018, EV_ITEM_INVENTORY, EV_SEC_PARSED_ROOT, EV_LM10X_ROOT

Preparation / proposed procedure:

1. Check the supplied release and expected user-provided project inputs for compatible prepared tables and documentation.
2. If absent, request the specific missing author preparation materials and verify their source fields, sample coverage, manual correction records and output schema.
3. Keep SEC raw filing collection, section extraction/text cleaning, float construction and XBRL-US raw tag/footnote preparation as distinct upstream contracts.

Validation to perform later:

- Confirm the prepared tables satisfy all SAS consumer fields and accession/date keys.
- If producer materials are unavailable, record these upstream outputs as unresolved and do not run the downstream pipeline.

### ACT_rank_table: Resolve the source, path, contents and generation rules for dxbrl.element_typerank, including the FOOTNOTE_TYPE to RANK mapping used to select a category for multiply classified footnote elements.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_footnote_type_rank, ISS_footnote_rank_lookup
Evidence: E012, EV_ITEM_INVENTORY

Preparation / proposed procedure:

1. Locate the exact rank lookup expected by the supplied SAS program or obtain its documented producer and versioned values.
2. Do not infer ranking values from labels or substitute an undocumented ordering.

Validation to perform later:

- Verify the table contains FOOTNOTE_TYPE and RANK with the expected keys, uniqueness and coverage.

### ACT_handoff: Resolve the dxbrl SAS library reference to the confirmed compatible input/output directory and define the cross-language handoff for the embedded Stata preparation. Selecting the working data directory is a configuration choice and does not require recovering an author-original directory. Confirm upstream schemas, aliases, Stata import format and panel-time declaration rather than guessing the SCall_/SC* mapping or inherited a.* variables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_library_and_handoff_driver, ISS_stata_scaling_contract
Evidence: E001, E010, E014, E015, E016, E017, EV_ITEM_INVENTORY

Preparation / proposed procedure:

1. Select the confirmed directory containing the compatible input tables and intended output location, then configure the SAS dxbrl LIBNAME to that directory using a relative path or an approved [redacted-path-4ef6a7e509db] path.
2. Keep the active SAS body as its own SAS stage; the Stata fragment is enclosed in a SAS comment and is not executable as part of that SAS body.
3. Copy or extract the supplied Stata fragment at cached Code Description.sas lines 543–627 into a separate working .do file; the working filename and location may be chosen for this run, using a relative path or an approved [redacted-path-4ef6a7e509db] path.
4. Identify the exact SAS output delivered to Stata, its import process and whether SCnum_tags_notes/SCtagsa_* are created in an omitted upstream step.
5. Confirm definitions and sources for inherited fields including MV, CSHR, XYEAR, XBRL1–3 and distinct note-level versus *_total counts.
6. Confirm the Stata panel identifier and time variable setup required before D. operators.

Validation to perform later:

- Verify the configured dxbrl library points to the confirmed input/output directory and contains the expected inputs.
- Verify the SAS-to-Stata handoff schema against every field consumed in the Stata fragment.
- Confirm the extracted .do file contains the supplied fragment and that panel-time declaration and variable names are resolved before running it.

### ACT_sas_runtime: Resolve the existing SAS 9.4 TKELS initialization failure and verify the available runtime and project configuration before any author preparation is attempted. The recorded startup error does not establish missing licensing.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, ISS_sas_runtime
Evidence: EV_ENV, E004, E010, E012, E013

Preparation / proposed procedure:

1. Review the existing environment probe diagnostics and SAS site configuration with the workspace administrator.
2. After initialization is understood, perform only the designated non-author runtime availability check through the approved environment workflow.

Validation to perform later:

- Confirm SAS starts and the required Base SAS procedures are available.
- Confirm the project’s SAS data library configuration is explicitly defined.

### ACT_run_after_setup: After all required inputs, upstream contracts and SAS configuration are resolved, run the active SAS body as its own stage through dxbrl.final2. The Stata fragment is inside a SAS comment, so copy or extract cached Code Description.sas lines 543–627 into a separate working .do file and run that as the following Stata stage, after its import, field and panel-time contracts are confirmed. The working .do filename/path may be selected for the run; no author-original path is required. No program was executed for this assessment.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E010, E013, E014, E016, E017

Preparation / proposed procedure:

1. Configure dxbrl to the confirmed compatible input/output directory and run the verified SAS preparation through dxbrl.final2.
2. Copy or extract the supplied Stata fragment at cached Code Description.sas lines 543–627 into a separate working .do file.
3. After confirming the SAS output import schema, all consumed fields/aliases and the panel-time setup, run the working .do file as the separate Stata preparation stage.

Validation to perform later:

- Check expected dataset schemas, key uniqueness and sample coverage at each handoff.
- Confirm the extracted .do file has the intended supplied fragment and Stata reports successful completion with the final prepared-panel schema.


## Remaining issues and prerequisites

- ISS_upstream_preparation [unresolved; full_pipeline]: The SAS program reads dxbrl.final_10k_withxbrl and dxbrl.raw_extra_footnotes as prepared inputs. The datasheet describes upstream Perl filing extraction, section/float processing, XBRL-US tag construction and manual review/corrections, but those producer programs, correction records and input schemas are not in this release. SEC/LM roots and the SEC public route do not establish equivalent section or raw-tag outputs.
- ISS_library_and_handoff_driver [unresolved; full_pipeline]: The active SAS body reads/writes dxbrl tables but the release supplies no SAS LIBNAME/autoexec or complete orchestration driver. The Stata preparation code is embedded inside a SAS comment and has no import/handoff program or panel-time declaration for D. operators. The regressions are outside this supplied-preparation target.
- ISS_stata_scaling_contract [unresolved; full_pipeline]: The supplied Stata fragment creates scaled variables with the SCall_ prefix, then reads SCnum_tags_notes and SCtagsa_* for differences. The prepared upstream schema, any alias-producing step, import format and panel-time setup are not supplied, so the consumer contract cannot be resolved by guessing. Other consumed fields such as MV, CSHR, XYEAR and XBRL1–3 may be inherited through a.*; their definitions/history remain unverified. SAS also creates separate num_tags_notes_total/num_words_notes_total aggregates while the Stata fragment uses both note-level and total fields; their upstream definitions must be preserved as separate concepts.
- ISS_footnote_rank_lookup [unresolved; full_pipeline]: The supplied code reads dxbrl.element_typerank.FOOTNOTE_TYPE and RANK to resolve dual-classified footnote elements, but no producer, file path or rank values are supplied.
- ISS_sas_runtime [unresolved; full_pipeline]: The existing bounded SAS 9.4 startup probe failed while loading TKELS. This leaves the runtime unverified; it does not establish a missing license or a study-specific incompatibility.
- REQ_sec_filing_text [public_acquisition_required]: SEC 10-K filing documents needed for the author’s section extraction, number/word counts, fog measures, textual market-float fallback and filing identifiers. Exact study endpoints and complete accession population are not stated in this release.
- REQ_xbrl_filing_tags [undetermined]: Historical XBRL-US filing listing and tag data used to classify basic/detail adoption, match SEC filings, compute numeric tags by presentation section, and assign adoption tiers; accession/date correction and manual adoption adjustments are part of the author contract.
- REQ_xbrl_footnote_detail [undetermined]: Detailed block-tagged footnote data required by dxbrl.raw_extra_footnotes and the classification/transpose stage, including accession, element/namespace/description, footnote text and Perl-derived number/word counts.
- REQ_compustat_annual [undetermined]: Annual Compustat source for GVKEY/FYEAR/DATADATE, assets, income, price/share/equity and EPS variables. The volatility construction uses fiscal years t−5 through t: changes are computed for t−4 through t, with the t−5 EPS value needed for the oldest change.
- REQ_ccm_permno_link [undetermined]: CRSP/Compustat link-history rows needed to add PERMNO to annual Compustat inputs using the author’s date/type/primary-link rules.
- REQ_cik_gvkey_links [undetermined]: Historical CIK-to-GVKEY linkage used to connect SEC filing CIKs to Compustat/CRSP information; the author names a CRSPQ.COMPHIST-derived link.
- REQ_cik_cusip_links [undetermined]: CIK/CUSIP link records used to link filing CIKs to historical Compustat/CRSP information; the datasheet says links were obtained from both providers.
- REQ_crsp_daily [undetermined]: Daily CRSP security data used for filing-window return volatility and abnormal returns; the supplied SAS code joins by PERMNO and filing date, and keeps price, volume and shares outstanding inputs.
- REQ_crsp_market_index [undetermined]: CRSP daily value-weighted market index returns used with security returns to compute abnormal returns; this is a separate table from daily security prices.
- REQ_crsp_sharecodes [undetermined]: CRSP stocknames/share-code history used to attach the share code active on each Compustat DATADATE.
- REQ_ibes_analyst_summary [undetermined]: IBES annual analyst-coverage summary and actual/estimate fields used to rank duplicate ticker matches and produce NUMANALYSTS. The supplied consumer expects PERMNO, FPEDATS, PDICITY, STATPERS, SCORE, VALUE and NUMEST.
- REQ_ibes_crsp_link [undetermined]: IBES-to-CRSP historical ticker/PERMNO link and score used to link analyst coverage to CRSP/Compustat firm-years.
- REQ_compustat_segments [undetermined]: Historical Compustat segment input used to create NUMSEGMENTS by GVKEY and DATADATE, counting SID where STYPE is not GEOSEG.
- REQ_institutional_holdings [undetermined]: Firm-level institutional ownership input from Thomson Reuters S34, converted to shares_instit/shares_total and matched by GVKEY/PERMNO within 100 days before filing.
- REQ_footnote_type_rank [undetermined]: Required local lookup dxbrl.element_typerank joined by FOOTNOTE_TYPE and used to rank dual-classified elements; exact ranking values and producer are not supplied.
- SW_SAS [unverified]: The active preparation code uses SAS DATA steps, PROC SQL, PROC SORT and PROC TRANSPOSE. The assigned environment probe failed during TKELS initialization, so current SAS runtime availability is unverified; no author code was run.

## Review notes

- This checkpoint is now expanded with all 13 frozen dependency IDs classified. Every external table named in the SAS code has a separate requirement; generated intermediates are linked to their supplied producers.
- The resource catalog and one-row probes identify candidates only. All local product routes remain unverified where period, entitlement, author filters or construction mapping is unresolved; the S34 read timed out once and was not retried.
- The SEC/parsed/LM probes only stat-checked the documented roots. SEC public EDGAR supports raw filing acquisition; it does not establish the authors’ section metrics, float corrections or XBRL-US tag output.
- The sample spreadsheet is an identifier list, not a compatible analysis panel, so no analysis_only scope is supported.
- The appendix describes additional analyses without supplying their programs; its inputs and estimations are contextual, not added as mandatory gaps in this supplied-preparation target.
- No author code, regression, data download, installation, applied edit or SAS retry was performed.
