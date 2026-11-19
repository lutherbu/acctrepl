# Patch proposal: jar-32c234776b7b

Regulatory Transparency and Regulators’ Effort: Evidence from Public Release of the SEC’s Review Work

DOI: 10.1111/1475-679X.12513

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Assess the supplied Python preparation workflow: GT_FirmMonth_Sample.py and GT_Filing_Sample.py with their shared macFunction.py helper, ending at data.csv and filing reg.csv. The datasheet also mentions subsequent Stata regressions, but no Stata analysis consumer/program or analysis panel is in this assigned variant; the audit does not treat that absent paper-wide stage as a supplied-code dependency or offer an analysis-only bypass.

Entry points: `GT-datasheet-code-identifier/GT_Filing_Sample.py`, `GT-datasheet-code-identifier/GT_FirmMonth_Sample.py`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 1/12513 - Regulatory-Transparency-and-Regulators-Effort-Evidence-from-Public-Release-of-the-SECs-Review-Work/gt-datasheet-code-identifier.zip",
      "sha256": "01b52bd8420961ed31ef69fd638d2789a449884810bf20d57b9e88f126aa10fc"
    },
    {
      "path": "JAR-Volume 62/Issue 1/12513 - Regulatory-Transparency-and-Regulators-Effort-Evidence-from-Public-Release-of-the-SECs-Review-Work/gt-online-appendix.pdf",
      "sha256": "751d41beb7335ba64c45642879085d247db0dae4b9e0ec7121453ef3e6fe7a70"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "630bb7bfd2e8d5b02e1da8a0e2fed3817420bea4fc3cd3a75f8525a4d030c94a"
}
```

## Proposed actions

### A_FINANCIAL_INPUTS: Confirm the quarterly, link, daily-return and restatement inputs required for the supplied financial intermediates.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_QUARTERS, R_CCM_LINKS, R_CIK_GVKEY_LINK, R_CRSP_DAILY, R_AUDIT_RESTATEMENTS
Evidence: E_SAFE_HELPER_SOURCE, E_CATALOG_CANDIDATES, E_PROBE_COMP_FUNDQ, E_PROBE_CCM_LINK, E_PROBE_CRSP_DSF, E_PROBE_AUDIT_FEED39

Preparation / proposed procedure:

1. Use the supplied ccmq() filters and construction contract to assess whether COMP.FUNDQ and CCMXPF, together with the separate historical CIK/GVKEY map, satisfy the generated intermediate. Treat ccmq.csv as generated; do not require byte identity to ccmq.dta when a compatible field-preserving route is supported.
2. Confirm genuinely unprobed fields (including fyq, SIC/state, issuer IDs and source-format flags as applicable) and pre/post-sample quarters needed for firm minimum-date and one-quarter lead/lag calculations.
3. Confirm the daily CRSP date range required by ret_volatility() and match its identifier/date/value fields to the readable DSF candidate.
4. Match the FEED39 candidate's company/date semantics and historical coverage to non_reliance_restatement_95_20.dta before using it to generate restated.dta.

Validation to perform later:

- Before a separately authorized run, compare source columns, identifiers, date intervals, filters and required pre/post history against each consumer and helper transform.
- Verify generated ccmq.csv and restated.dta have the exact columns and keys expected by both sample builders.

### A_CONTROLS_AND_EVENT_EXPORTS: Resolve each independently consumed audit, segment, accrual, comment-letter, readability and event-study table with its own producer and schema contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SOX302, R_SOX404, R_PAC, R_AUDIT_ANALYTICS, R_SEGMENTS, R_DACC, R_COMMENT_RECEIVED, R_COMMENT_COMBINED, R_EVTAR, R_SUE, R_CAR_EVENT, R_ANNUAL_BETA, R_EARNINGS_PERSISTENCE, R_INST_CLASS, R_ACCF, R_SEC_READABILITY
Evidence: E_SAFE_FIRM_SOURCE, E_SAFE_FILING_SOURCE, E_SAFE_HELPER_SOURCE, E_WI_INVENTORY, E_CATALOG_CANDIDATES, E_PROBE_AUDIT_FEED10, E_PROBE_AUDIT_FEED11

Preparation / proposed procedure:

1. Supply or specify aduit analytics.csv, segments.csv and dacc.csv as three distinct tables with separate fields, keys, transformations and periods.
2. Supply receieve cl.csv and cl combined.csv as separate tables with each population, identifiers, accession normalization and coverage.
3. Resolve evtar.csv, sue.csv, car evtstudty short.csv, annual beta.csv, earnings persistence.csv, inst class.csv and accf.csv separately; preserve their distinct event/issuer/date contracts.
4. Supply readability.dta with its accession, WordCount and Gunning_Fog_Index contract and filing coverage.
5. Treat FEED10 and FEED11 as partial local candidates only; confirm outcome, date, issuer and period fields before mapping them to sox302.dta or sox404.dta.

Validation to perform later:

- Check each file's required consumer columns, date ranges, units, ID keys, duplicates and transformations before joining.
- Confirm event-study inputs cover the helper's preceding/following event windows and the authors' full filing/sample periods.

### A_SEC_INPUTS: Obtain or document the SEC access, filing-list and supporting author exports with their safe field and production contracts.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_SEC_VIEW_EXPORT, R_SEC_FILING_LIST, R_SEC_DOCINFO, R_SEC_DE8K, R_OTHER_VIEW_COUNTS, R_NSV10K, R_SEC_MONTH_DE8K_8K, R_TREAT_YM_DE8K, R_R34, R_SEC_DISTANCE, R_NSCLV, R_PRIOR_REVIEW_COUNT, R_CIK_GVKEY_LINK, R_SEC_READABILITY, I_INPUT_CLOSURE, I_OPAQUE_SOURCE_BLOCKS
Evidence: E_DOC_WORKFLOW, E_DOC_CODEFILES, E_SAFE_FIRM_SOURCE, E_SAFE_FILING_SOURCE, E_SAFE_HELPER_SOURCE, E_WI_INVENTORY

Preparation / proposed procedure:

1. Provide the prepared sec views.csv, document information.pkl and filing-list source/output specification, including accession/CIK/GVKEY/date fields and historical coverage; do not deserialize the pickle during this audit.
2. For each separate SEC branch table, identify whether it is prepared data or an opaque producer output, then document its fields, keys and history: secv_de8k.csv, other views.csv, nsv10k.csv, secview month de8k and 8k accompanied.csv, treat ym de8k.csv, r34.csv, sec distance.csv, nsclv.csv and prior-review counts.
3. Resolve the opaque helper and firm-month ranges through a sanitized source view or author-prepared contract that omits credentials but states actual reads, writes, invocation order, fields and history.
4. Keep sec views.csv as a prepared-input requirement; the historical description of EDGAR log processing does not by itself establish that raw logs reproduce the author's prepared export.

Validation to perform later:

- Check each SEC export's parser-required fields, ID/date validity, transformations and every downstream join key against both sample builders.
- Confirm each source/output pair covers the documented periods and that every required intermediate is written before its first reader.

### A_ANALYST_INPUTS: Resolve the recommendation-detail and ticker-link inputs used by analyst_num().

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_IBES_CROSSWALK, R_IBES_RECOMMENDATIONS
Evidence: E_SAFE_HELPER_SOURCE, E_CATALOG_CANDIDATES

Preparation / proposed procedure:

1. Provide the exact iclink.pkl and recommendation - detail.csv exports or field-level source specifications, with ticker-to-issuer keys, recommendation fields and date coverage.
2. Do not substitute cataloged guidance data for the recommendation-detail input without an author-supported equivalence mapping.

Validation to perform later:

- Check the crosswalk join key and recommendation date/value fields against analyst_num() and the analyst.csv consumer joins.
- Confirm the period covers all required firm-month and filing windows.

### A_RAVENPACK_INPUTS: Resolve full-history RavenPack news and entity mappings for the two monthly firm aggregates.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_RAVENPACK_NEWS, R_RAVENPACK_ENTITY_MAP, R_RAVENPACK_SOURCE_MAP
Evidence: E_SAFE_HELPER_SOURCE, E_CATALOG_CANDIDATES, E_PROBE_RP_2000, E_PROBE_RP_MAPPING_TIMEOUT, E_PROBE_RP_2009_TIMEOUT

Preparation / proposed procedure:

1. Use the readable 2000 news table only as field/readability evidence; preserve the 2009 and mapping timeouts and verify those exact routes through the already documented local catalog without retrying for a positive result.
2. Confirm all required annual partitions, entity mapping validity intervals, country/relevance/source filters and CUSIP/ticker crosswalk fields for the author's specified period.
3. Run the author's stated mapping and aggregation transforms only after the exact local source contracts and output keys have been confirmed.
4. Confirm RP sources.csv contains the four code-selected DATA_VALUE labels and their corresponding SOURCE map; retain the specified labels and do not guess SOURCE IDs.

Validation to perform later:

- Verify the full required date range and field schema before constructing rp_cusip.csv and rp_tic.csv.
- Check generated key/date uniqueness and the exact ticker/CUSIP joins expected by the two entry scripts.

### A_OTHER_HELPER_INPUTS: Resolve the supervisor, investigation and regulation-period source files used by helper routines.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_SUPERVISOR_FOIA, R_INVESTIGATION_PERIODS, R_CMSW_PERIOD_DATA, R_KME_CROSSWALK
Evidence: E_SAFE_HELPER_SOURCE, E_SAFE_FILING_SOURCE, E_WI_INVENTORY

Preparation / proposed procedure:

1. Provide the named SEC supervisor FOIA workbook and Blackburne investigation workbook, or their authored preparation specifications.
2. Provide CMSW_WB_final.dta and kme.xlsx as two distinct inputs to reg_period(), or their separate preparation specifications; confirm the company/date and company-to-GVKEY/CIK roles.
3. Confirm worksheet names, selected columns, IDs, interval semantics and sample-period coverage before using helper outputs.

Validation to perform later:

- Check each workbook/data file against the exact helper input columns and generated monthly keys before the helper outputs are used.
- Confirm the resulting supervisor and investigation outputs join on the documented month/PERMNO keys and cover the required time range.

### A_FIRM_MONTH_EXPORTS: Confirm individual firm-month auxiliary tables and distinguish prepared inputs from outputs of the opaque source range.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SEC_DE8K, R_OTHER_VIEW_COUNTS, R_NSV10K, R_SEC_MONTH_DE8K_8K, R_TREAT_YM_DE8K, R_R34, R_SEC_DISTANCE, R_NSCLV, R_PRIOR_REVIEW_COUNT, R_COMMENT_RECEIVED, R_COMMENT_COMBINED, R_AUDIT_ANALYTICS, R_SEGMENTS, R_DACC
Evidence: E_SAFE_FIRM_SOURCE, E_SAFE_HELPER_SOURCE, E_WI_INVENTORY

Preparation / proposed procedure:

1. Obtain each named table's individual source/producer, schema, key/date normalization and coverage: secv_de8k.csv, other views.csv, nsv10k.csv, secview month de8k and 8k accompanied.csv, treat ym de8k.csv, r34.csv, sec distance.csv, nsclv.csv and number of times reviewed in the previous 2 years.csv.
2. Match aduit analytics.csv, segments.csv, dacc.csv, receieve cl.csv and cl combined.csv as distinct tables to their separate consumer joins.
3. Identify which outputs are generated in the opaque range and which are prepared inputs; leave unknown producer contracts unresolved.

Validation to perform later:

- Match every read path to one verified prepared input or an ordered supplied producer, with a compatible schema and history.
- Check the 2003-07 through 2005-09 sample window and the code's additional 2005-06 through 2008-10 non-SEC click window separately.

### A_RUN_ORDER: Record the producer-consumer sequence and remaining handoffs for the supplied preparation workflow.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_INPUT_CLOSURE, I_RUN_ORDER, I_OPAQUE_SOURCE_BLOCKS
Evidence: E_DOC_WORKFLOW, E_SAFE_FIRM_SOURCE, E_SAFE_FILING_SOURCE, E_SAFE_HELPER_SOURCE, E_MAC_CCMQ_READ, E_MAC_CCMQ_WRITE, E_FIRM_SEC_OUTPUT, E_FIRM_FINAL_OUTPUT, E_FILING_FINAL_OUTPUT

Preparation / proposed procedure:

1. In a portable copy, order each confirmed source input before its helper: ccmq.csv before restated.dta and both sample builders; other known helper outputs before their named consumers.
2. Resolve and document the invocations for treatment(), sec_accesses(), read_filing_list(), filter_click() and the opaque firm-month range before assigning the full order.
3. After all required helper outputs are confirmed, run the two supplied sample builders as separate outputs, preserving data.csv and filing reg.csv.
4. Limit this target to the supplied sample-construction workflow. The datasheet mentions subsequent Stata regressions, but the assigned inventory provides no Stata analysis program or analysis panel.
5. Keep the RavenPack chain distinct: RP sources.csv maps code-selected labels to SOURCE values; the news stream is separately filtered and then validity-date joined to the entity map for CUSIP and ticker outputs.

Validation to perform later:

- Before any separately authorized execution, verify every required path has exactly one declared source/producer and is created before its earliest consumer.
- Check each generated intermediate's schema/keys against the next consumer, retain separate log and output captures, and leave execution_verified false until an authorized run is independently reviewed.

### A_PYTHON_DEPS: Prepare a compatible isolated Python environment for the two missing imported distributions.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: I_PYTHON_DEPS, SW_PYTHON_DEPS
Evidence: E_PYTHON_PACKAGE_METADATA, E_SAFE_FIRM_SOURCE, E_SAFE_FILING_SOURCE, E_SAFE_HELPER_SOURCE

Preparation / proposed procedure:

1. Confirm the author's expected Python and package versions, including business-calendar and pandas-market-calendars, then prepare them in a separate environment when a future run is authorized.
2. Preserve the current runtime and package state; no installation was performed during this assessment.

Validation to perform later:

- In the future isolated environment, verify the required import entry points and package versions without loading author data during the setup check.

### A_PORTABLE_ROOTS: Map the authors' data and output roots coherently in a separate portable working copy.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_ROOT_CONFIGURATION
Evidence: E_MAC_ROOTS, E_SAFE_HELPER_SOURCE

Preparation / proposed procedure:

1. Choose distinct readable source-data and writable analysis-output roots for a separate copy or wrapper; the authored helper currently defines Windows-style roots.
2. Apply one consistent mapping to the helper and both scripts without modifying the frozen package or putting output over source inputs.

Validation to perform later:

- Before a future authorized run, confirm all required source roots resolve and output roots are writable and distinct from the frozen package.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: The package is a code/document/identifier-list release, while the two supplied sample builders and helper consume many external author-prepared inputs and generated intermediates. The GVKEY workbook is an identifier list, not the analysis panel. Each missing or unverified input is listed as a requirement; no absent local file or license is inferred from catalog misses or timeout probes.
- I_RUN_ORDER [unresolved; full_pipeline]: Known helper writers feed named intermediate readers: ccmq() writes ccmq.csv; restated() consumes it and writes restated.dta; treatment() and sec_accesses() define treat ym2.csv and secview month.csv; secvsup(), ret_volatility(), rpnews(), analyst_num(), disclosure_timeliness() and investigating_Blackburne2020() define further producer outputs. RP news filtering depends on the separate RP sources.csv label map and distinct entity-validity crosswalk. Additional firm-month tables may be produced in the opaque range. Full invocation order and those contracts remain unresolved; known generated outputs are not reclassified as raw requirements.
- I_OPAQUE_SOURCE_BLOCKS [unresolved; full_pipeline]: Credential/connection candidate regions in the helper and the firm-month lines 225-265 were withheld from the safe source view. Their function bodies, producers, dynamic reads and effect on the driver cannot be claimed absent. The package remains unchanged; exact source/data contract and order for these regions are unresolved.
- I_PYTHON_DEPS [preparation; full_pipeline]: The supplied code imports pandas_market_calendars and business_calendar; their distributions are not present in the metadata-only environment check. Author-compatible versions and an isolated future environment need confirmation before an authorized attempt.
- I_ROOT_CONFIGURATION [preparation; full_pipeline]: macFunction.py defines separate Windows-style analysis and data roots, and the entry scripts use both. A consistent portable mapping is needed in a separate working copy before a future authorized run.
- R_COMP_QUARTERS [undetermined]: Quarterly Compustat fields needed to prepare the author's ccmq.csv intermediate, including financial measures and quarterly dates. The supplied helper applies link/format filters, ratios and within-GVKEY lead/lag operations; required pre-sample and post-sample history has not been established.
- R_CCM_LINKS [undetermined]: Quarterly GVKEY-to-PERMNO/Company linking fields required by the author's ccmq input and the sample merges. The author filter uses primary/secondary links of specified link types; exact match rules and historical coverage remain to be confirmed against the delivered input.
- R_CIK_GVKEY_LINK [undetermined]: Historical CIK-to-GVKEY link export read by macFunction.sec_link(), including date intervals used to match the filing date to an issuer. It is a separate input from CRSP CCM links and has not been packaged or field-validated.
- R_CRSP_DAILY [undetermined]: Daily CRSP input read by the supplied price-volatility preparation function and transformed into price volatility.csv. The sample needs dates beyond the visible estimation window for the author's rolling calculations; exact history remains unverified.
- R_AUDIT_RESTATEMENTS [undetermined]: Non-reliance financial restatements input used to produce restated.dta; the helper uses COMPANY_FKEY and restatement start/end dates, links the company to CIK/GVKEY, and joins against ccmq history.
- R_SOX302 [undetermined]: Author-prepared quarterly SOX 302 input sox302.dta, merged by GVKEY and datadate in the sample builders. The package does not supply the export or its construction specification.
- R_SOX404 [undetermined]: Author-prepared annual SOX 404 input sox404.dta, merged by GVKEY and fiscal year. The package does not supply the export or its construction specification.
- R_RAVENPACK_NEWS [undetermined]: RavenPack equity-news records used by the helper to form monthly firm aggregates and two linked outputs, rp_tic.csv and rp_cusip.csv. The source filter and 2000-2009 history are part of the construction requirements.
- R_RAVENPACK_SOURCE_MAP [undetermined]: RP sources.csv maps DATA_VALUE publication labels to SOURCE filter values. At safe helper lines 232-235, the author selects WALL STREET JOURNAL, THE NEW YORK TIMES, THE WASHINGTON POST and USA TODAY. The SOURCE IDs, map contents, presence and history were not inspected or guessed.
- R_RAVENPACK_ENTITY_MAP [undetermined]: RavenPack entity-to-CUSIP/ticker crosswalk used before producing rp_cusip.csv and rp_tic.csv. The mapping probe timed out; no result is treated as absence.
- R_IBES_CROSSWALK [undetermined]: I/B/E/S iclink.pkl crosswalk consumed by analyst_num() to link recommendation tickers to issuer identifiers before creating analyst.csv. The expected join keys and historical coverage require confirmation.
- R_IBES_RECOMMENDATIONS [undetermined]: Author-provided I/B/E/S recommendation-detail input recommendation - detail.csv used to compute analyst recommendation counts. The local discovery results identify guidance products but do not establish recommendation-detail compatibility; guidance is not credited as a substitute.
- R_SEC_VIEW_EXPORT [undetermined]: Prepared SEC EDGAR access export SEC investigation from EDGAR logfile/sec views.csv consumed by both sample builders. The readers rely on filing/accession identifiers, filing dates, event date/time, form and click fields; exact full header and coverage must be confirmed.
- R_SEC_FILING_LIST [undetermined]: Filing records returned by macFunction.read_filing_list(), consumed by both treatment construction and the filing-level sample. The helper implementation is in an opaque candidate-bearing block, so its source product, output fields and history cannot be reconstructed safely from this view.
- R_SEC_DOCINFO [undetermined]: document information.pkl read by macFunction.read_docinfo() and joined to filing records on accession. The pickle was not deserialized; its complete fields and coverage remain unknown.
- R_SEC_DE8K [undetermined]: 8-K/de8-K SEC-view table secv_de8k.csv read by the firm-month builder. This may be prepared input or an output of an opaque producer; the visible read does not prove either classification or that its producer is absent.
- R_OTHER_VIEW_COUNTS [undetermined]: External EDGAR view-count table other views.csv read by the firm-month builder. This may be prepared input or an output of an opaque producer; the visible read does not prove either classification or that its producer is absent.
- R_NSV10K [undetermined]: 10-K SEC-view table nsv10k.csv read by the firm-month builder. This may be prepared input or an output of an opaque producer; the visible read does not prove either classification or that its producer is absent.
- R_SEC_MONTH_DE8K_8K [undetermined]: Combined 8-K/de8-K monthly SEC-view table read by the firm-month builder. This may be prepared input or an output of an opaque producer; the visible read does not prove either classification or that its producer is absent.
- R_TREAT_YM_DE8K [undetermined]: 8-K/de8-K treatment-month table read by the firm-month builder. This may be prepared input or an output of an opaque producer; the visible read does not prove either classification or that its producer is absent.
- R_R34 [undetermined]: R34 table r34.csv read by the firm-month builder. This may be prepared input or an output of an opaque producer; the visible read does not prove either classification or that its producer is absent.
- R_SEC_DISTANCE [undetermined]: SEC-distance table sec distance.csv read for the 2004 distance indicator. This may be prepared input or an output of an opaque producer; the visible read does not prove either classification or that its producer is absent.
- R_NSCLV [undetermined]: Non-SEC comment-letter access table nsclv.csv read and linked to issuer/month. This may be prepared input or an output of an opaque producer; the visible read does not prove either classification or that its producer is absent.
- R_PRIOR_REVIEW_COUNT [undetermined]: Prior-review count table read by the firm-month builder; its source and history are not supplied. This may be prepared input or an output of an opaque producer; the visible read does not prove either classification or that its producer is absent.
- R_SEC_READABILITY [undetermined]: SEC filing readability.dta input used by the filing sample to derive accession-level WordCount and Gunning_Fog_Index. Exact archive coverage and schema are not part of the package.
- R_PAC [undetermined]: Prepared political-contribution/PAC input pac hh.dta merged to the sample by GVKEY and fiscal year. The exact construction, source fields and year coverage are not supplied.
- R_AUDIT_ANALYTICS [undetermined]: Audit Analytics prepared export aduit analytics.csv used by both sample builders; its producer, field contract, identifiers and history are not included.
- R_SEGMENTS [undetermined]: Segment-level prepared export segments.csv merged by GVKEY and fiscal year in both builders; its producer, schema and coverage are not supplied.
- R_DACC [undetermined]: Discretionary-accrual export dacc.csv consumed by both builders; exact construction, fields and historical coverage are not supplied.
- R_COMMENT_RECEIVED [undetermined]: Received comment-letter file receieve cl.csv used in the firm-month builder; its construction, identifiers, periods and relation to the combined accession table are not established.
- R_COMMENT_COMBINED [undetermined]: Combined comment-letter accession file cl combined.csv used for filing accessions and firm-month comment-letter activity; its construction, normalization and coverage are not supplied.
- R_EVTAR [undetermined]: Event-study return table evtar.csv consumed by disclosure_timeliness() to generate erc timeliness.csv; event windows, keys, units and history are not supplied.
- R_SUE [undetermined]: Standardized unexpected earnings table sue.csv consumed by the filing sample; its construction and coverage are not supplied.
- R_CAR_EVENT [undetermined]: Filing event-study CAR table car evtstudty short.csv; event-window construction and coverage are not supplied.
- R_ANNUAL_BETA [undetermined]: Annual beta table annual beta.csv; its PERMNO/date fields, estimator and history are not supplied.
- R_EARNINGS_PERSISTENCE [undetermined]: Earnings persistence table earnings persistence.csv; its GVKEY/date fields and construction are not supplied.
- R_INST_CLASS [undetermined]: Institutional-class table inst class.csv; its identifier/date contract and coverage are not supplied.
- R_ACCF [undetermined]: ACCF table accf.csv consumed in the firm-month builder; keys, construction and history are not supplied.
- R_SUPERVISOR_FOIA [undetermined]: SEC DCF supervisor FOIA workbook read by secvsup() to construct supvisor count.csv. Its historical period and name/office coding compatibility with the sample months remain unverified.
- R_INVESTIGATION_PERIODS [undetermined]: SECInvestigations.xlsx sheet PERMNO input used by the helper to create investigating.csv with monthly PERMNO periods. The workbook's presence and compatible investigation coverage are not verified.
- R_CMSW_PERIOD_DATA [undetermined]: Regulation-period source CMSW_WB_final.dta consumed by reg_period() to create monthly investigation intervals; its coverage and schema are not supplied.
- R_KME_CROSSWALK [undetermined]: Company-to-GVKEY/CIK workbook kme.xlsx jointly consumed with CMSW_WB_final.dta; code selects company, GVKEY and cik, but workbook contents and coverage are not supplied.
- SW_PYTHON_DEPS [preparation_required]: Source imports pandas_market_calendars and business_calendar; metadata-only inspection found distributions pandas-market-calendars and business-calendar absent. No install or author-code import was attempted. Other checked external imports are present by distribution metadata.

## Review notes

- This is the integrated static assessment of the supplied sample-construction code. The work item, frozen schema/rules, inventory, bounded probes and safe-screened sources were used; no author module was imported, compiled or executed, no author credentials were used, and no study data were opened beyond the explicitly bounded metadata/one-row probes.
- The GVKEY workbook was probed only as an identifier list, not treated as an analysis panel. Catalog candidates and successful one-row probes support local fields/readability only; complete history, population coverage and author-export compatibility remain distinct open checks. Both RavenPack probe timeouts are preserved and are not interpreted as absent data or licensing barriers.
- Opaque candidate-bearing ranges remain withheld in the safe source artifacts. The assessment records their unresolved producer, output-contract and order effects without claiming they contain no producers. Known visible helper writes and consumer reads are mapped separately.
- The supplied datasheet mentions Stata regressions downstream, but this assigned package variant contains no regression consumer/program or analysis panel. Stata is therefore not listed as required software for the assessed supplied-code workflow; the scope description states this limit explicitly.
- During bounded preparation, the first safe-view helper failed because a candidate scan artifact had a different JSON shape than expected; its original helper and traceback/addendum captures are preserved, and a versioned helper generated the safe views. Two wrong-working-directory process starts and one read-only jq summary failure are also preserved with their corrections. No author or data process ran.
- Narrow source-map/input-granularity correction: independently consumed audit, segment, accrual, comment-letter, event-study, CMSW/crosswalk and firm-month SEC tables now have separate requirements/routes/actions. RP sources.csv is separately required for the four publication labels explicitly selected by the helper; SOURCE IDs remain unverified. Known ccmq filters/formulas and row-based leads/lags are credited, while unprobed fields and time/history remain open. Time partitions remain one product, and known generated ccmq.csv, restated.dta, secview month.csv and treat ym2.csv remain producer outputs rather than raw requirements.
- A finalizer validation attempt rejected a new source quote because it did not match the cached source lines. That failed attempt and its raw diagnostic are preserved. The corrected draft relies on the existing hash-bound safe helper inspection artifact at displayed lines 232-235 for the RP source-map contract and does not repeat the unsupported source quote.
- One draft-only correction-helper attempt stopped before writing because its safe-view line-indexing code omitted the standard-library re import. The exact process failure is preserved in probes/stage_003b_helper_failure_001.json; the saved helper was corrected before this successful attempt.
