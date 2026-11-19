# Patch proposal: jar-66704f3e4f9e

Do consumers vote with their feet in response to negative ESG news? Evidence from consumer foot traffic to retail locations

DOI: 10.1111/1475-679X.70034

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied SAS and Stata workflow: main event-panel construction, spending and stacked branches, graph extensions, CAR and Google branches, ESG/traffic and sales aggregation, industry distribution, Compustat comparison, and GSS survey analysis. The producer-first sequence and cross-language output handoffs are reviewed with explicit unresolved gaps. The CAR branch uses DSI, DSENAMES, DSF and DSEDELIST as separate required raw components; partial local matches do not satisfy the joint workflow.

Entry points: `SAS Code & Log/1. Main sample code.sas`, `SAS Code & Log/2. Spending.sas`, `SAS Code & Log/3. Stacked.sas`, `SAS Code & Log/4. Graph_day_extended.sas`, `SAS Code & Log/5. Rep_CAR.sas`, `SAS Code & Log/6. Google Search.sas`, `SAS Code & Log/7. ESG. Sale and Foot Traffic.sas`, `SAS Code & Log/8. Industry distribution and ESG distrubition.sas`, `SAS Code & Log/9. Compare with Compustat sample.sas`, `Stata Code & Log/1_Main_Sample.do`, `Stata Code & Log/2_Alternative_FE_Cluster.do`, `Stata Code & Log/3_Spend.do`, `Stata Code & Log/4_Stacked.do`, `Stata Code & Log/5_1_Extension_30d.do`, `Stata Code & Log/5_2_Service_45_60d.do`, `Stata Code & Log/5_3_Graph.do`, `Stata Code & Log/6_7_RepRisk_CAR_Google.do`, `Stata Code & Log/8_Aggregate ESG, FT.do`, `Stata Code & Log/9_ Compare Compustat.do`, `Stata Code & Log/10_Survey.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 4/70034 - Do-consumers-vote-with-their-feet-in-response-to-negative-ESG-news-Evidence-from-consumer-foot-traffic-to-reta/dlw-datasheet-code-identifier-and-log-files.zip",
      "sha256": "377d15bb49d94c5912caf0389e9f8ee7ebadc91c30ac0b40e123b7c6e4557c4d"
    },
    {
      "path": "JAR-Volume 64/Issue 4/70034 - Do-consumers-vote-with-their-feet-in-response-to-negative-ESG-news-Evidence-from-consumer-foot-traffic-to-reta/dlw-online-appendix.pdf",
      "sha256": "c5120f3f17253f70e6357980a9f1372d26ea9567f0bb789da13726190f6403c3"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "0d5eefa89375b14224dfc040caae0958248057e28514e46a320bb3cf80cc787b"
}
```

## Proposed actions

### A-REPRISK-PRODUCT: Confirm whether the separately probed PM_NEWS_DATA and PM_COMPANY_IDENTIFIERS products can together satisfy the author-named News Legacy input, including the RepRisk_ID join, the intended ISIN field and complete 2018–2020 event history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-REPRISK-NEWS, ISS-REPRISK-LEGACY-PRODUCT
Evidence: E-SAS-REPRISK-READ, E-PROBE-REPRISK-NEWS, E-PROBE-REPRISK-IDENTIFIERS, E-DOC-INPUTS

Preparation / proposed procedure:

1. Obtain the authors' product/version and identifier-mapping specification or a compatible prepared event input.
2. If the two local products are approved, document the join through RepRisk_ID and confirm primary_ISIN versus all_ISINs before constructing the author-required CUSIP6 field.

Validation to perform later:

- Check readable field names, selected identifier mapping and date coverage for the exact event sample before producing the main panel.

### A-COMPUSTAT-MAP: Confirm that the readable local COMP.FUNDQ product is the intended compatible quarterly source for data.compustat_quarter and verify the full required date span.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-COMPUSTAT-QUARTERLY
Evidence: E-SAS-COMPUSTAT-READ, E-PROBE-COMP-FUNDQ, E-SAS-GOOGLE-COMPUSTAT, E-SAS-MONTHLY-COMPUSTAT

Preparation / proposed procedure:

1. Map the local table to the author-named source in the approved SAS session while preserving the source filters and fields.
2. Verify that the available history covers each event characteristic, quarterly lead/lag calculation and comparison branch.

Validation to perform later:

- Confirm all required columns and date ranges before generating any author panel or comparison output.

### A-SAFEGRAPH-DAILY: Establish an authorized route to the author-compatible daily SafeGraph traffic product and confirm 2017 pre-event history plus the 2018–2020 event windows.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-SAFEGRAPH-DAILY, ISS-SAFEGRAPH-2017-PREHISTORY
Evidence: E-DOC-INPUTS, E-SAS-SAFEGRAPH-READ, E-SAS-GRAPH-PREWINDOW, E-LOCAL-CATALOG-03

Preparation / proposed procedure:

1. Check the authors' SafeGraph/Dewey delivery and local institutional access path; do not infer absence or licensing from a catalog miss.
2. Confirm fields stock_symbol, fips, totalvisits_day and visitday and the date coverage needed for main, spending, monthly and pre-window branches.

Validation to perform later:

- Use a bounded field/date check after authorized access, then confirm the producer's year filter retains every required date.

### A-SAFEGRAPH-SPEND: Confirm access to the author-named SafeGraph Spend source and its exact measure, ticker, FIPS, date and coverage contract.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-SAFEGRAPH-SPEND
Evidence: E-SAS-SPEND-RAW, E-SAS-SPEND-JOIN, E-DOC-INPUTS, E-LOCAL-CATALOG-03

Preparation / proposed procedure:

1. Ask the authors or the documented data provider for the compatible annual Spend product and the exact local `data.allspend` delivery route.
2. Preserve the ticker/FIPS/visitday join and confirm the required spend measure and dates before panel construction.

Validation to perform later:

- Check keys, measure fields and date coverage before generating spend_rep_10_20.

### A-TICNEWSDATE-MAP: Obtain the prepared ticker/GVKEY/news-date map and its field, identifier-vintage and date-coverage definition.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-TICNEWSDATE-MAP, ISS-TICNEWSDATE-MAP-SPEC
Evidence: E-WIP-DEPENDENCIES, E-SAS-CAR-MAP-IMPORT, E-SAS-GOOGLE-MAP-IMPORT, E-SAS-INDUSTRY-MAP-IMPORT

Preparation / proposed procedure:

1. Ask for the exact ticnewsdate1013.dta input, producing code or author-prepared data and its path/format.
2. Confirm ticker, GVKEY, CUSIP/ISIN, news-date and industry fields and how the map is shared across CAR, Google and industry branches.

Validation to perform later:

- Check keys, duplicate policy, identifier validity dates and sample coverage before starting any importing SAS program.

### A-GOOGLE-SOURCE: Identify the exact author Google data source behind data.google_all, its company-name/ticker query construction, daily scale and historical extract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-GOOGLE-SEARCH
Evidence: E-SAS-GOOGLE-RAW, E-SAS-GOOGLE-JOIN, E-PUB-GOOGLE-TRENDS, E-LOCAL-CATALOG-03

Preparation / proposed procedure:

1. Request the authors' prepared Google input or source specification, including ticker/name mapping and query date range.
2. Confirm that any proposed route preserves the author's measure and scaling rather than substituting an unverified Trends series.

Validation to perform later:

- Check date, ticker, search field and event-window coverage before creating googleesg.

### A-CCM-HISTORY: Confirm whether local CRSP.CCMXPF_LNKHIST is the intended version-compatible counterpart to crsp.ccmxpf_lnkhist2023 and verify event-date coverage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-CRSP-LINK-HISTORY, ISS-CCM-2023-VERSION
Evidence: E-SAS-CAR-BASE-PRODUCER, E-PROBE-CCM-LINK, E-LOCAL-CATALOG-03

Preparation / proposed procedure:

1. Check the local CCM product/version and the author's 2023 alias with the authorized CRSP/WRDS session owner.
2. Preserve the source filters on GVKEY, LINKPRIM, LINKTYPE, LINKDT and LINKENDDT when selecting compatible links.

Validation to perform later:

- Verify all required link fields and valid-date coverage for the complete event sample before producing the linked CAR input.

### A-CRSP-COMPONENTS: Resolve DSENAMES NCUSIP compatibility and verify the DSI, DSF and DSEDELIST date spans and field contracts used by CAR as separate required raw components.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-CRSP-DAILY-RETURNS, R-CRSP-DSENAMES-IDENTIFIERS, R-CRSP-DSF-RETURNS, R-CRSP-DSEDELIST-ADJUSTMENT, ISS-DSENAMES-NCUSIP-FIELD
Evidence: E-SAS-CAR-LINK-PRODUCER, E-SAS-CAR-CALENDAR-PRODUCER, E-SAS-CAR-RETURNS-PRODUCER, E-SAS-CAR-ADJUSTMENT-PRODUCER, E-PROBE-CRSP-DSI, E-PROBE-CRSP-DSENAMES, E-PROBE-CRSP-DSF, E-PROBE-CRSP-DSEDELIST

Preparation / proposed procedure:

1. Identify a compatible local DSENAMES product/field mapping that provides NCUSIP without assuming ticker is interchangeable.
2. Confirm DSI trading-calendar, DSF return and DSEDELIST fields/date coverage for each 110-day estimation period, gap and event window.

Validation to perform later:

- Verify the DSENAMES NCUSIP/name-date mapping and each component’s required fields and full date coverage before the CAR macro is run.

### A-FF-COVERAGE: Use the readable local FF.FACTORS_DAILY fields and confirm date coverage before the CAR event study.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R-FF-DAILY-FACTORS
Evidence: E-SAS-CAR-FACTORS-PRODUCER, E-PROBE-FF-FACTORS

Preparation / proposed procedure:

1. Verify DATE, SMB, HML and UMD coverage for all trading dates used by the CAR estimation and event windows.

Validation to perform later:

- Confirm one-to-one date joins with the CRSP trading calendar and preserve UMD as the supplied momentum factor.

### A-ESG-PREFERENCE-CROSSWALK: Obtain the author-prepared county ESG preference file or exact construction rules for the LCV, Yale and AFL-CIO measures.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-ESG-PREF-CROSSWALK, ISS-COUNTY-CROSSWALK-SPECS
Evidence: E-STATA-CROSSWALK-MERGES, E-DOC-ESG-PREF-INTRO, E-DOC-LCV-SOURCE, E-DOC-YALE-SOURCE, E-DOC-AFL-CIO-SOURCE, E-PUB-LCV-2018, E-PUB-YALE-COUNTY, E-PUB-AFLCIO

Preparation / proposed procedure:

1. Request esgpref2018.dta or its documented source tables, score definitions, county aggregation and FIPS mapping.
2. Confirm each score's year/version and transformations before constructing the crosswalk.

Validation to perform later:

- Check FIPS uniqueness, fields consumed by Stata and year/score scaling before merging to the event panel.

### A-ACS-2018-COUNTY: Identify the ACS tables/variables and transformations used to create demo2018.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-ACS-2018-COUNTY, ISS-COUNTY-CROSSWALK-SPECS
Evidence: E-DOC-INPUTS, E-STATA-CROSSWALK-MERGES, E-PUB-ACS-2018

Preparation / proposed procedure:

1. Request the author-prepared demo2018.dta or its 2018 ACS 5-year table IDs, variable list, county FIPS format and transformations.
2. Use the documented 2018 Census source only after the required table/field contract is known.

Validation to perform later:

- Check county FIPS keys and expected field names against the Stata merge before use.

### A-HOUSE-2018-COUNTY: Identify the exact 2018 county House-results file and aggregation used to create house2018.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-HOUSE-2018-COUNTY, ISS-COUNTY-CROSSWALK-SPECS
Evidence: E-DOC-INPUTS, E-STATA-CROSSWALK-MERGES, E-PUB-MEDSL-2018

Preparation / proposed procedure:

1. Request house2018.dta or the MEDSL source release, candidate/party aggregation, vote/outcome fields and county FIPS procedure.
2. Preserve the author-described county merge and do not infer a county return file from precinct or state sources.

Validation to perform later:

- Check unique FIPS keys, 2018 House outcome fields and merge compatibility before analysis.

### A-NAICS-SERVICE: Obtain naics_service.dta and the definition of its firm-quarter service indicator.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-NAICS-SERVICE-CLASSIFICATION
Evidence: E-STATA-CROSSWALK-MERGES, E-STATA-EXTENSION-45D

Preparation / proposed procedure:

1. Request the prepared file or its producer, including GVKEY, datadate, classification source, service flag and period rules.
2. Confirm date alignment and the coding expected by the service robustness branch.

Validation to perform later:

- Check GVKEY/datadate uniqueness and the service field before the merge.

### A-GSS-2021: Acquire the NORC individual-year 2021 GSS Stata data and verify the source variables used by the survey branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R-GSS-2021-SURVEY, ISS-GSS-FIELD-COMPATIBILITY
Evidence: E-PUB-GSS-2021, E-STATA-SURVEY-VARIABLES, E-WIP-DEPENDENCIES

Preparation / proposed procedure:

1. Use the official 2021 individual-year Stata source and place the compatible file at the author-required GSS2021.dta input location.
2. Confirm the exact variables age, relpers, nobuygrn, partyid, news, coninc, degree, marital and finalter.

Validation to perform later:

- Check variable presence, labels, missing-value codes and sample count before running the survey analysis.

### A-STATA-ADDONS: Install or configure the six Stata add-ons reported unavailable in the Stata 18 checks.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW-WINSOR2, SW-HDFE, SW-ASDOC, SW-TTABLE2, SW-TTABLE3, SW-OUTREG2
Evidence: E-SW-WINSOR2, E-SW-HDFE, E-SW-ASDOC, E-SW-TTABLE2, E-SW-TTABLE3, E-SW-OUTREG2, E-STATA-HDFE-COMMAND, E-STATA-CAR-ASDOC, E-STATA-COMPARE-TTABLE, E-STATA-OUTREG2

Preparation / proposed procedure:

1. Add winsor2, hdfe, asdoc, ttable2, ttable3 and outreg2 to the active Stata 18 ado search path using the institution's approved package source.
2. Keep the available reghdfe, ppmlhdfe and unique commands in place.

Validation to perform later:

- Run Stata `which` checks for all six commands in the intended Stata 18 session before analysis.

### A-SAS-ENVIRONMENT: Confirm the supported SAS version and remote SAS/CONNECT library/session setup for the supplied SAS programs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SW-SAS
Evidence: E-ENVIRONMENT, E-SAS-CAR-BASE-PRODUCER

Preparation / proposed procedure:

1. Ask the environment owner to confirm SAS availability, the remote session used by rsubmit/proc upload/download, and authorized CRSP/Compustat/RepRisk library bindings.
2. Use the original registered environment metadata for the SAS software key; do not rely on author logs as local execution proof.

Validation to perform later:

- After approved confirmation, validate library and session handoffs with a minimal non-author metadata check before attempting the supplied workflow.

### A-GRAPH-EXTENSION-PRODUCER: Resolve the graph_ext_day producer, output path/schema and positive post-event rows needed by the 30/45/48/60-day Stata branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-GRAPH-EXT-PRODUCER-WINDOW, R-SAFEGRAPH-DAILY
Evidence: E-SAS-GRAPH-PREWINDOW, E-STATA-EXTENSION-30D, E-STATA-EXTENSION-45D, E-STATA-EXTENSION-60D, E-STATA-EXTENSION-48D, E-SAS-PANEL-PRODUCER

Preparation / proposed procedure:

1. Request a reviewed readable source view for the masked SAS4 producer/export block or an author description of its exact output and date window.
2. Confirm that generated rows include each branch's requested positive post-event window and match the appended Stata file's keys/columns.
3. Keep the raw SafeGraph requirement as the existing upstream source; do not add graph_ext_day as an independent raw dataset.

Validation to perform later:

- Verify output path, keys, fields and per-event coverage before running the Stata extension analyses.

### A-CORE-PANEL-HANDOFF: Confirm the SAS export destinations and exact Stata input paths for the main, spending and stacked event panels.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-CORE-PANEL-HANDOFF-PATHS
Evidence: E-SAS-PANEL-PRODUCER, E-STATA-PANEL-CONSUMER, E-SAS-SPEND-PANEL, E-STATA-SPEND-CONSUMER, E-SAS-STACKED-PANEL, E-STATA-STACKED-CONSUMER

Preparation / proposed procedure:

1. Map each producer output sg_rep_10_20, spend_rep_10_20 and stacked_rep_10_20 to the exact Stata file, format and working directory.
2. Confirm the producer runs complete before the matching Stata consumer and preserve the panel keys/columns.

Validation to perform later:

- Check each output exists in the declared path and has the variables consumed by its Stata entry point.

### A-CAR-HANDOFF: Resolve the CAR branch's generated object names and the export consumed by Stata.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-CAR-OUTPUT-HANDOFF, ISS-CAR-AGGREGATE-ALIAS
Evidence: E-SAS-CAR-BASE-PRODUCER, E-SAS-CAR-OUTPUTS, E-SAS-CAR-WORKDOWNLOAD, E-SAS-CAR-AGG-PRODUCER, E-SAS-CAR-TICNEWS-EXPORT, E-WIP-DEPENDENCIES

Preparation / proposed procedure:

1. Confirm whether allcar is the same intended object as the checklist's work.car and identify the actual export file expected as rep_car.dta.
2. Confirm SAS/remote session order, output format, destination path and the CAR variables read by Stata.

Validation to perform later:

- Check file identity and fields car1, car2, car3, severity, reach and novelty at the Stata input before analysis.

### A-GOOGLE-HANDOFF: Resolve the SAS googleesg output and the Stata google.dta input contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-GOOGLE-OUTPUT-HANDOFF, R-GOOGLE-SEARCH
Evidence: E-SAS-GOOGLE-RAW, E-SAS-GOOGLE-JOIN, E-SAS-GOOGLE-EXPORT, E-WIP-DEPENDENCIES

Preparation / proposed procedure:

1. Confirm the exact destination, file format, output alias and variable names generated from googleesg.
2. Confirm producer order and whether firm-name/ticker search fields and the event-window dates survive the export.

Validation to perform later:

- Check the declared Stata path and required `date`, ticker, gvkey and search measures before the Google regressions.

### A-ESG-FT-HANDOFF: Resolve the SAS sg3/rep5 exports and the Stata month_esg_ft.dta/esg_qtr_sale.dta inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-ESG-FT-OUTPUT-HANDOFF
Evidence: E-SAS-MONTHLY-FT-EXPORT, E-SAS-QUARTERLY-SALE-EXPORT, E-WIP-DEPENDENCIES

Preparation / proposed procedure:

1. Confirm exact output paths, formats and field mappings for the monthly foot-traffic/ESG and quarterly sales/ESG products.
2. Document the producer-before-consumer order for Stata8.

Validation to perform later:

- Check the Stata files contain the expected date, gvkey, ESG/sales/traffic and control fields before analysis.

### A-COMPARE-HANDOFF: Resolve the SAS qcompustat export and Stata comp_compare.dta comparison input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-COMPUSTAT-COMPARE-HANDOFF
Evidence: E-SAS-COMPARE-RAW, E-SAS-COMPARE-EXPORT, E-WIP-DEPENDENCIES

Preparation / proposed procedure:

1. Confirm exact output path, format, field aliases and producer order for the qcompustat product expected as comp_compare.dta.

Validation to perform later:

- Check the Stata file contains the comparison sample flags and Compustat fields required by Stata9.

### A-CAR-WORK-CONTEXT: Resolve the SAS WORK CRSP and _evtrets_temp producer/source context using a reviewed readable source view or author documentation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-CRSP-WORK-PRODUCER-CONTEXT, ISS-EVTRETSTEMP-SOURCE-CONTEXT
Evidence: E-WIP-DEPENDENCIES, E-SAS-CAR-BASE-PRODUCER, E-SAS-CAR-UPLOAD, E-SAS-CAR-WORKDOWNLOAD, E-SAS-CAR-RETURNS-PRODUCER

Preparation / proposed procedure:

1. Identify the actual SAS library/session that produces and consumes the WORK CRSP object and the upstream table in the masked _evtrets_temp statement.
2. Preserve remote upload/download and execution order; do not substitute another CRSP table based only on a similar basename.

Validation to perform later:

- Verify source table identity and session availability before running the CAR macro.

### A-WIP-DIRECT-EDGES: Reconcile the frozen dependency checklist with the visible direct reads for the four county crosswalks and CCM link-history input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-WIP-OMITTED-DIRECT-INPUTS
Evidence: E-STATA-CROSSWALK-MERGES, E-SAS-CAR-BASE-PRODUCER, E-WIP-DEPENDENCIES

Preparation / proposed procedure:

1. Record the direct read contracts for esgpref2018.dta, demo2018.dta, house2018.dta, naics_service.dta and crsp.ccmxpf_lnkhist2023 in the maintained dependency inventory.
2. Keep this generation's frozen 62 IDs unchanged and do not invent checklist IDs in the assessment.

Validation to perform later:

- Before a future execution attempt, verify the expanded inventory covers every direct raw read and links to the corresponding requirement.


## Remaining issues and prerequisites

- ISS-REPRISK-LEGACY-PRODUCT [unresolved; full_pipeline]: Separate one-row probes establish readable PM news fields and separate company-identifier fields, but they do not verify one matching product/field contract for the composite author input. Exact News Legacy equivalence, the RepRisk_ID-to-ISIN join and the author's primary_ISIN versus all_ISINs choice, and 2018–2020 history remain unresolved.
- ISS-SAFEGRAPH-2017-PREHISTORY [unresolved; full_pipeline]: The main sample begins after 10 Jan 2018 and the graph preparation builds a −21 to −11 pre-event window, so the earliest included events can require December 2017 traffic. The supplied filter only removes years after 2020; no local history probe verifies the required 2017 tail.
- ISS-GRAPH-EXT-PRODUCER-WINDOW [unresolved; full_pipeline]: The readable SAS graph block constructs pre-event observations, while the Stata extensions append graph_ext_day.dta and include +30, +45, +48 and +60 analyses. The remaining SAS producer/export block is unread, so its exact file path, schema and positive post-event coverage cannot be verified; this does not establish that those rows are absent.
- ISS-CORE-PANEL-HANDOFF-PATHS [unresolved; full_pipeline]: SAS constructs the main, spending and stacked event panels, and Stata consumes files with the corresponding names, but the SAS export destinations are masked. Confirm the actual output paths, formats and run order before invoking the consumers.
- ISS-CAR-OUTPUT-HANDOFF [unresolved; full_pipeline]: The CAR SAS program exports its generated ticnews table to a masked path, while the Stata dependency inventory expects rep_car.dta; the intended file alias, export format, fields and producer-to-consumer path are not verified.
- ISS-CAR-AGGREGATE-ALIAS [unresolved; full_pipeline]: The readable SAS source creates and consumes allcar as the merged CAR aggregate, while the frozen dependency inventory identifies a work.car intermediate. The supplied source does not prove these are the same artifact or session object.
- ISS-GOOGLE-OUTPUT-HANDOFF [unresolved; full_pipeline]: The Google SAS program exports googleesg to a masked path, while the Stata dependency inventory expects google.dta. The intended alias, format, path and required columns remain unverified.
- ISS-ESG-FT-OUTPUT-HANDOFF [unresolved; full_pipeline]: The ESG/traffic SAS program exports sg3 and rep5 to masked paths, while Stata expects month_esg_ft.dta and esg_qtr_sale.dta. The intended file aliases, formats, paths and variable contracts remain unverified.
- ISS-COMPUSTAT-COMPARE-HANDOFF [unresolved; full_pipeline]: SAS9 exports qcompustat to a masked path, while the Stata comparison dependency expects comp_compare.dta. Confirm the actual alias, output format, location and field contract.
- ISS-TICNEWSDATE-MAP-SPEC [unresolved; full_pipeline]: The CAR, Google and industry programs import prepared ticker/news-date or ticker/industry mapping files, but their quoted paths are masked and no supplied producer specifies the fields, identifiers, date vintage or coverage.
- ISS-CRSP-WORK-PRODUCER-CONTEXT [unresolved; full_pipeline]: The dependency checklist includes a SAS WORK CRSP component, but the readable source windows do not establish its producer/session identity or its relation to the local CRSP tables. The remote connection block is masked; no SAS startup or configuration inspection resolves this.
- ISS-EVTRETSTEMP-SOURCE-CONTEXT [unresolved; full_pipeline]: The CAR macro visibly creates _evtrets_temp, but the source-join statement that defines its upstream table and session context is masked. Preserve it as a generated workflow intermediate while leaving that specific raw/producer link unresolved.
- ISS-DSENAMES-NCUSIP-FIELD [unresolved; full_pipeline]: The bounded DSENAMES probe observed PERMNO, TICKER and name-date fields; its sampled field list did not include NCUSIP, while the visible CAR link branch selects NCUSIP. A compatible local product/field mapping has not been established; this probe does not establish product-wide absence.
- ISS-CCM-2023-VERSION [unresolved; full_pipeline]: The local CCMXPF_LNKHIST product has readable matching link fields, but the author source names crsp.ccmxpf_lnkhist2023. Its 2023 alias and event-date coverage are not verified by the unversioned local candidate.
- ISS-WIP-OMITTED-DIRECT-INPUTS [unresolved; full_pipeline]: The supplied code directly reads esgpref2018.dta, demo2018.dta, house2018.dta and naics_service.dta, and SAS reads crsp.ccmxpf_lnkhist2023; these direct input contracts are not represented by the frozen 62 dependency IDs. They are recorded as requirements without inventing checklist IDs.
- ISS-COUNTY-CROSSWALK-SPECS [unresolved; full_pipeline]: The county crosswalk files are required by visible Stata merges, but their prepared variable definitions, FIPS representation, transformations, release/vintage and local file paths are not supplied. Public pages identify candidate products only and do not establish these prepared-file contracts.
- ISS-GSS-FIELD-COMPATIBILITY [unresolved; full_pipeline]: NORC documents the 2021 individual-year Stata data, but the exact variable names, labels and missing-value handling required by the supplied Stata survey source are not confirmed against the downloaded file.
- R-REPRISK-NEWS [undetermined]: RepRisk U.S. ESG-news records are a raw input to the SAS sample builder; reconcile the exact issue, severity, reach, identifier and date fields against the complete consumer chain.
- R-SAFEGRAPH-DAILY [undetermined]: SafeGraph daily firm-county traffic is a required raw component of the event-window panel.
- R-SAFEGRAPH-SPEND [undetermined]: The spending robustness branch requires the author-named SafeGraph Spend source, keyed to firm ticker, county and date; the exact measure fields and time span still require verification.
- R-TICNEWSDATE-MAP [undetermined]: Several preparation programs import the author-supplied ticker/GVKEY/news-date mapping needed to link events across RepRisk, CRSP and Google data.
- R-GOOGLE-SEARCH [undetermined]: The Google branch requires daily firm-level search records keyed by ticker and calendar date for the event window.
- R-CRSP-DSENAMES-IDENTIFIERS [undetermined]: CRSP DSENAMES security-name and identifier records are required to select valid name intervals and map CUSIP/NCUSIP to PERMNO in the CAR link branch; NCUSIP compatibility remains unresolved.
- R-ESG-PREF-CROSSWALK [undetermined]: The main analysis needs a 2018 county ESG-preference crosswalk containing the FIPS key and the author-derived preference measures.
- R-ACS-2018-COUNTY [undetermined]: County-level 2018 ACS demographics are required as covariates merged by county FIPS.
- R-HOUSE-2018-COUNTY [undetermined]: 2018 county-level U.S. House election returns are required as county covariates merged by FIPS.
- R-NAICS-SERVICE-CLASSIFICATION [undetermined]: A firm-quarter service-industry classification crosswalk is required for the service-industry analyses.
- R-GSS-2021-SURVEY [undetermined]: The survey robustness analysis requires the individual-year 2021 GSS microdata fields used to measure green-purchase attitudes and respondent covariates.
- SW-SAS [unverified]: Required by the nine supplied SAS programs. The registered environment metadata labels SAS unverified; the assigned audit prohibits starting SAS, so setup/runtime confirmation remains open.
- SW-WINSOR2 [preparation_required]: The supplied Stata programs actively use winsor2; the Stata 18 software check reported it unavailable, so installation/path setup is required before the included analyses can run.
- SW-HDFE [preparation_required]: The main Stata source actively calls hdfe, and the Stata 18 software check did not find it.
- SW-ASDOC [preparation_required]: The CAR/Google Stata source actively calls asdoc, and the Stata 18 software check did not find it.
- SW-TTABLE2 [preparation_required]: The Compustat comparison source actively calls ttable2, and the Stata 18 software check did not find it.
- SW-TTABLE3 [preparation_required]: The Compustat comparison source actively calls ttable3, and the Stata 18 software check did not find it.
- SW-OUTREG2 [preparation_required]: The 45-day service branch actively calls outreg2, and the Stata 18 software check did not find it.

## Review notes

- Static source review covers every registered SAS and Stata program and traces the supplied workflow from raw inputs through preparation products to the Stata consumers. Source-view masks are unread coverage and do not prove absent or inactive code.
- This checkpoint records the source-chain and raw-input contract findings. Bounded catalog field probes, software command checks, public-source compatibility, the 62-edge dependency review and specific producer/consumer handoffs remain under review.
- Route status separates verified local field/readability candidates from unresolved product equivalence, identifier, period and construction gaps. One-row probes establish columns/readability only.
- The 2018 ACS, MEDSL, LCV, Yale, AFL-CIO and GSS sources are tied to the prepared-file contracts without inferring county aggregation or field compatibility from a public page.
- Producer-first order reviewed: SAS1 main panel → main/alternative Stata; SAS2 spend → Stata3; SAS3 stacked → Stata4; SAS4 graph preparation → extension consumers; SAS5 CAR and SAS6 Google preparation → Stata6/7; SAS7 monthly/quarterly ESG products → Stata8; SAS9 Compustat comparison → Stata9; Stata10 survey is a separate GSS branch. SAS8 emits its own industry-distribution workbooks.
- The CAR path imports a prepared ticker/news-date map, joins date-valid CCM history, uploads the linked rows to rep2, runs the event-study calls, downloads car1/car2/car3 into local WORK and aggregates/exports the result. Masked source statements leave specific WORK object and file alias handoffs unresolved.
- All 62 frozen dependency IDs are reviewed once. Generated workflow products have empty target_ids; raw inputs retain their corresponding requirement links; unresolved session/alias/field edges remain explicit issues.
- Visible Stata branches require +30, +45, +48 or +60 event windows; the readable SAS4 block establishes a −21 to −11 pre-window, while the remaining producer/export source is unread. This is an unresolved product/window contract, not a finding that rows or access are absent.
