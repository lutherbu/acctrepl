# Patch proposal: jar-015981c65311

Freedom of Expression Protection and Corporate Concealment of Bad News: Evidence from State Anti-SLAPP Laws

DOI: 10.1111/1475-679X.70012

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete README/datasheet workflow across supplied SAS sample and source construction, Stata firm-year/state-panel preparation, FJC/Table 1 preparation, three cohort outputs and the separate analyses. The SAS source constructs WORK.SAMPLE and README identifies that same program output as sample.dta; persisting this same data in Stata format at the consuming $db path is ordinary staging under I_SAS_LIBREFS. Historical-HQ lineage, exact prepared-input contracts and SAS library/runtime setup remain unresolved.

Entry points: `Sample Construction/Index.sas`, `Sample Construction/Controls.sas`, `Sample Construction/Crash.sas`, `Sample Construction/FScore.sas`, `Sample Construction/NegPR.sas`, `Sample Construction/NonGAAP.sas`, `Sample Construction/construct_historicalhq.sas`, `Sample Construction/fjc_construct_dismissed.sas`, `Sample Construction/SAS_Sample Construction_JAR.sas`, `Sample Construction/construct_mainsample.do`, `Sample Construction/construct_sample_Table1.do`, `Analysis/Regression_F Score Sample_JAR.do`, `Analysis/Regression_Neg PR Sample_JAR.do`, `Analysis/Regression_Stock Crash Sample_JAR.do`, `Analysis/Table1.do`, `Analysis/Table5.do`, `Analysis/Table6B.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70012 - Freedom-of-Expression-Protection-and-Corporate-Concealment-of-Bad-News-Evidence-from-State-Anti-SLAPP-Laws/lnyz-datasheet-code-identifiers-and-log-file.zip",
      "sha256": "a523ac89475afb0923f6391897157acf42cfca1a6ff989ac2b593b8009e9342a"
    },
    {
      "path": "JAR-Volume 64/Issue 1/70012 - Freedom-of-Expression-Protection-and-Corporate-Concealment-of-Bad-News-Evidence-from-State-Anti-SLAPP-Laws/lnyz-online-appendix.pdf",
      "sha256": "a0085bbdbac179770afe12604b9bf6372f213a51bca3d3a6c46405a06aa218ae"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "65ae861f34aea1307a4459b3ee28623e956201718a4dea4af0bf3422fe95f833"
}
```

## Proposed actions

### A_COMP_AUDIT: Obtain the exact Compustat auditor product needed by FScore.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R_COMP_CO_AUDIT
Evidence: E_SRC_CO_AUDIT, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Confirm the provider/library and provide an extract containing GVKEY, DATADATE, CONSOL, INDFMT, DATAFMT, POPSRC and AU.
2. Preserve the source's annual date join and domestic/consolidated/industrial filters; do not replace AU with another audit measure.

Validation to perform later:

- Check native field names/types, key uniqueness, source history and required fiscal-year coverage before a later run.

### A_CRSP_ERDPORT: Confirm the CRSP event-return portfolio input used by Crash.sas.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R_CRSP_ERDPORT1
Evidence: E_SRC_CRSP_ERDPORT1, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Identify the exact CRSP product containing PERMNO, DATE and DECRET and provide its permitted local/library route.
2. Retain the source join and fiscal-period matching logic.

Validation to perform later:

- Verify the three fields, key/date meaning and coverage of the event-return observations without running the study program.

### A_IBES_ICLINK: Confirm the PERMNO-to-IBES ticker-link file and its score rule.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R_IBES_ICLINK
Evidence: E_SRC_ICLINK, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Provide the ICLINK schema with PERMNO, TICKER and SCORE and identify the matching release/source.
2. Preserve the supplied lower-score duplicate selection; do not substitute another link file without confirming the scoring definition.

Validation to perform later:

- Check keys, score coding and history before generating the NonGAAP measures.

### A_RAVENPACK: Acquire the two jointly required RavenPack products through the documented WRDS route if institutionally available.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R_RAVENPACK, R_RP_MAPPING
Evidence: PUB_WRDS_RAVENPACK, E_SRC_RAVENPACK, E_SRC_RP_MAPPING, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Confirm access and identify the release/files for press-release fields RP_ENTITY_ID, RPNA_DATE_UTC, ENTITY_NAME, GROUP, COUNTRY_CODE, RELEVANCE, ESS and NIP.
2. Obtain the separate RP_MAPPING fields RP_ENTITY_ID, ENTITY_TYPE, DATA_TYPE, RANGE_START, RANGE_END and DATA_VALUE.
3. Preserve effective-range mapping, country/type filters and source's negative-press calculations.

Validation to perform later:

- Compare field meanings, time zones, identifiers, mapping ranges and historical coverage against the supplied filters before building rpsample.

### A_SLAPP_FUNDAMENTALS: Resolve the distinct author-prepared SLAPP library inputs and the source mappings needed to build the main sample.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_SLAPP_FUNDA, R_SLAPP_COMP_HQINC, R_SLAPP_SIC, R_SLAPP_DATES, R_SLAPP_STATECONTROLS
Evidence: E_SRC_SLAPP_FUNDA, E_SRC_SLAPP_COMP_HQINC, E_SRC_SLAPP_SIC, E_SRC_SLAPP_DATES, E_SRC_STATECONTROLS, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Provide the exact prepared SLAPP.FUNDA query/file schema, including FOPO, PPE and SIC, and document any derivation of fields that are not in the local native COMP.FUNDA schema. GVKEY2/CIK2 are created in the supplied DATA step and should not be required from raw input.
2. Provide separate schemas/producers for SLAPP.COMP_HQINC (GVKEY/DATADATE/STATE), SLAPP.SIC (GVKEY/DATADATE/SIC), SLAPP.SLAPP (ST/YEAR), and SLAPP.STATECONTROLS (ABB_/YEAR/POPULATION/INCOME_PER_CAPITA).
3. Identify annual periods, source vintages, state abbreviations and the order/library location used by SAS_Sample Construction_JAR.sas.

Validation to perform later:

- Check each file's exact native fields, keys, date ranges and join cardinality separately; confirm year/state normalization before running the sample construction.

### A_SLAPP_EPS_ESTIMATES: Supply the actual prepared GVKEY/PENDS/MEDest estimate input used by the sample merge.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_SLAPP_ACTU_EPSUS4
Evidence: E_SRC_ACTU_EPSUS4, E_SRC_IBES_ACT_EPSUS, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Confirm the source and field construction for GVKEY, PENDS, MEDEST and VALUE.
2. Keep this estimate measure distinct from the verified IBES ACT_EPSUS actual EPS table; do not replace MEDest with actual EPS or invent a ticker-to-GVKEY rule.

Validation to perform later:

- Verify estimate definition, currency/period meaning, GVKEY/date keys and sample coverage.

### A_LABORSKILL: Acquire the author-cited industry-level labor-skill product and verify its merge contract.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_SLAPP_LABORSKILL
Evidence: PUB_BELO_LABOR, E_DATASHEET_LABOR, E_SRC_LABORSKILL

Preparation / proposed procedure:

1. Use the documented Belo author route to identify the required YEAR/IND/SKILL file and permitted delivery.
2. Preserve the source's industry construction and do not substitute a different skill index.

Validation to perform later:

- Confirm year coverage, industry-code vintage and field meaning before merging.

### A_SHORTINT: Confirm the prepared short-interest series and its date adjustment rules.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_SLAPP_SHORTINT
Evidence: E_SRC_SHORTINT, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Provide the GVKEY/SPLITADJDATE/SHORTINTADJ/SHORTINT schema, source and historical coverage.
2. Preserve the source's preceding-365-day matching rule and annual aggregation.

Validation to perform later:

- Check adjustment definition, GVKEY key and date range required for each fiscal year.

### A_SENTIMENT: Verify the author's Factiva/news route for the two separate annual sentiment products.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_SLAPP_SENTIMENT, R_SLAPP_SENTIMENT2
Evidence: E_DATASHEET_FACTIVA, E_SRC_SENTIMENT, E_SRC_SENTIMENT2

Preparation / proposed procedure:

1. Confirm whether the author-listed ZIP supplies both the PERMNO/YEAR/NEWSTONE_NONSTD score panel and the separate PERMNO/YEAR/NEWSCOUNT_NONSTD count panel.
2. If the ZIP does not contain either prepared contract, request the exact author-derived inputs and selection rules; do not substitute the RavenPack press-release measure.

Validation to perform later:

- Check each panel's key, nonstandard measure definition, year coverage and vendor delivery terms.

### A_KURT_NONGAAP: Acquire the author-cited manager Non-GAAP input used by NonGAAP.sas.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_KURT_NONGAAP
Evidence: PUB_KURT_GEE, E_README_NONGAAP, E_SRC_KURT_NONGAAP

Preparation / proposed procedure:

1. Use the author page as a candidate route for the 2003-2020 Manager Non-GAAP EPS dataset.
2. Confirm the GVKEY/DATADATE key and MGR_EXCLUDE/MGR_NG_EPS fields without replacing the four-quarter construction.

Validation to perform later:

- Verify exact release/schema, fiscal-date alignment and coverage before constructing the generated SLAPP.NONGAAP output.

### A_HQ_HISTORY: Resolve the documented 10-K header source and the separate DB.STATEHIS prepared producer.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_LM_HEADER, R_STATEHIS, I_STATEHIS_LINEAGE
Evidence: PUB_SRAF_10X, E_README_HISTORY, E_DATASHEET_FINANCIAL, E_SRC_STATEHIS, E_SRC_STATEHIS_KEEP, E_SRC_HQCHANGE_OUTPUT, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Identify the exact permitted LM header CSV release and schema; the public 10-X page is only a candidate product family.
2. Provide the DB.STATEHIS producer and its F_CIK/CIK, F_FDATE, CONF_PER_RPT, FYE, F_FTYPE, BA_STATE, STATE_OF_INCORP and SIC_NUM mapping.
3. Trace the supplied interval construction into DB.HQ_CHANGE without changing its history logic.

Validation to perform later:

- Confirm the first/last filing years, report-date semantics, state-code rules and interval output against the supplied joins.

### A_FJC_INPUTS: Confirm the FJC civil-case extract and independent district/state crosswalk.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R_FJC, R_DISTRICT_KEY
Evidence: PUB_WRDS_FJC, E_SRC_FJC_RAW, E_SRC_DISTRICT_KEY, E_DATASHEET_KURT_FJC, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Confirm institution access to the FJC route and provide the exact civil-case release containing the source's fields and NOS filter.
2. Provide the separate CODE/JURISDICTION/STATE district crosswalk and its vintage; retain docket/office/district grouping and year normalization.

Validation to perform later:

- Check the NOS and disposition coding, district coverage, keys and 1985-2021 Table 1 period before the supplied FJC construction.

### A_REVIEWS: Confirm the authorized Revelio Labs Glassdoor review extract and the author's firm-year source fields.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: R_REVIEWS
Evidence: E_README_MAIN, E_DATASHEET_ANALYSIS, E_SRC_REVIEWS_PATH, E_SRC_REVIEWS_FIELDS, E_SRC_REVIEWS_KEY, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Identify the delivered CSV/XLSX/DTA and exact header mapping for GVKEY, review_date_time, rating_overall, review_pros, review_cons, review_summary, review_advice and rating_business_outlook.
2. Preserve the supplied date parsing, no-rating filter, outlook coding and firm-year aggregation.

Validation to perform later:

- Confirm data-use permission, date coverage, GVKEY representation and all required text/outlook fields before aggregation.

### A_BEA_GDP: Acquire the two distinct BEA state real-output panels and retain the supplied growth/append sequence.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_REAL_GSP_1977_1997, R_REAL_GSP_1997_2017
Evidence: PUB_BEA_GDP_STATE, E_DATASHEET_STATE, E_SRC_GSP_1977_1997, E_SRC_GSP_1997_2017

Preparation / proposed procedure:

1. Use the BEA state GDP product page as a candidate route, then identify the exact real-GSP 1977-1997 and real-GDP 1997-2017 releases/files.
2. Preserve HQ/CYEAR keys, the source rename/growth calculations, removal of the duplicate 1997 boundary, and the append order.

Validation to perform later:

- Confirm real-dollar basis, units, state coding, year continuity and source vintages before deriving lagged growth.

### A_BLS_UR: Acquire the required unadjusted BLS state unemployment series.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_UR
Evidence: PUB_BLS_LAUS, E_DATASHEET_STATE, E_SRC_UR

Preparation / proposed procedure:

1. Use the BLS LAUS page as a candidate route and identify the exact annual/unadjusted 1976-2018 state series used by the author.
2. Preserve HQ/YEAR/UR keys and the supplied state-year lag construction.

Validation to perform later:

- Confirm seasonal adjustment, annual/monthly aggregation, state codes and the 1976-2018 period before merging.

### A_POP_PANEL: Identify the exact BEA population series/file behind the author-prepared 1969-2018 panel.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_POP
Evidence: E_DATASHEET_STATE, E_SRC_POP, E_SOURCE_MATRIX_V4

Preparation / proposed procedure:

1. Provide the state population series with HQ/YEAR/POPULATION fields, units, vintage and permitted file route.
2. Keep it separate from SLAPP.STATECONTROLS, which also requires income_per_capita.

Validation to perform later:

- Check state codes, population units, years and the lagged log-population construction.

### A_SAS_CONFIGURATION: Confirm SAS runtime/components and resolve the nonsecret DB/SLAPP/REP, remote WORK and Stata output-path mappings before a future conditional run.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_SAS_LIBREFS, SW_SAS, SW_SAS_CONNECT, SW_PROC_REG, SW_PROC_EXPORT_STATA
Evidence: E_DATASHEET_ANALYSIS, E_SRC_CONNECT_INDEX, E_SRC_CONNECT_CONTROLS, E_SRC_CONNECT_CRASH, E_SRC_PROC_REG, E_SRC_PROC_EXPORT_INPUT, E_SRC_PROC_EXPORT_FORMAT, E_SRC_FJC_EXPORT_INPUT, E_SRC_FJC_EXPORT_FORMAT, E_SRC_FSCORE_EXPORT_INPUT, E_SRC_FSCORE_EXPORT_FORMAT, E_SRC_NONGAAP_EXPORT_INPUT, E_SRC_NONGAAP_EXPORT_FORMAT, E_SRC_HQCHANGE_OUTPUT, E_SRC_SLAPP_FUNDA, E_SRC_SAMPLE_DTA_README, E_SRC_SAMPLE_DTA_README2, E_SRC_SAMPLE_WORK, E_SRC_SAMPLE_DTA_READ, E_SRC_SAMPLE_DTA_READ_T1, E_SRC_SAMPLE_DTA_READ_T6, E_WORK_ITEM

Preparation / proposed procedure:

1. Confirm SAS, SAS/CONNECT, SAS/STAT PROC REG and PROC EXPORT DBMS=STATA availability in the intended environment; prepare source-called Stata add-ons through the separate software-setup action.
2. Document DB/SLAPP/REP library mappings, remote WORK upload/download order and first-consumer paths. Resolve DB.HQ_CHANGE to the SLAPP.HQ_CHANGE input before the sample consumer.
3. Configure a same-data persistence step for WORK.SAMPLE: write its existing rows and variables in Stata DTA form to the $db sample path consumed by construct_mainsample.do, construct_sample_Table1.do and Table6B.do. Keep sample observations and fields unchanged.

Validation to perform later:

- Before a later authorized run, check site mappings and first-consumer paths for every handoff; confirm the sample DTA schema and row/variable preservation across the same-data export before any Stata consumer starts.
- Do not infer SAS/CONNECT, PROC REG or DBMS=STATA capability from source text; verify those components in the intended environment first.

### A_STATA_ADDONS: Prepare the five source-called Stata add-ons reported unavailable by command metadata probes.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_RANGEJOIN, SW_OUTREG2, SW_PSACALC2, SW_WINSOR2, SW_CARRYFORWARD
Evidence: P_SOFT_RANGEJOIN, P_SOFT_OUTREG2, P_SOFT_PSACALC2, P_SOFT_WINSOR2, P_SOFT_CARRYFORWARD, E_SRC_RANGEJOIN, E_SRC_OUTREG2, E_SRC_PSACALC2, E_SRC_WINSOR2, E_SRC_CARRYFORWARD

Preparation / proposed procedure:

1. Install/configure rangejoin, outreg2, psacalc2, winsor2 and carryforward through the user's approved Stata package-management route; no installation was performed during this assessment.
2. Keep Stata 18 and preserve the source scripts and estimates.

Validation to perform later:

- In a later authorized setup, run `which` for each exact command and verify Stata reports the intended installation paths before author programs are run.

### A_CONDITIONAL_RUN_PROCEDURE: After required input contracts, software components and site paths are confirmed, use the supplied program dependencies as a partial order. This is a conditional run plan across all 17 entry programs; independent source branches need not be forced into an unsupported single total order.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I_SAS_LIBREFS
Evidence: E_WORK_ITEM, E_SRC_WORK_INDEX_DOWNLOAD, E_SRC_WORK_INDEX_CONTROL_UPLOAD, E_SRC_WORK_INDEX_CRASH_UPLOAD, E_SRC_CONNECT_INDEX, E_SRC_CONNECT_CONTROLS, E_SRC_CONNECT_CRASH, E_SRC_CRASH_OUTPUT, E_SRC_RET_OUTPUT, E_SRC_DTURN_OUTPUT, E_SRC_RETURNS_OUTPUT, E_SRC_STATEHIS, E_SRC_HQCHANGE_OUTPUT, E_SRC_FUNDA_HQ_OUTPUT, E_SRC_FSCORE_OUTPUT, E_SRC_FSCORE_EXPORT_INPUT, E_SRC_FSCORE_EXPORT_FORMAT, E_SRC_RPSAMPLE_OUTPUT, E_SRC_RPSAMPLE_EXPORT_FORMAT, E_SRC_NONGAAP_OUTPUT, E_SRC_NONGAAP_EXPORT_INPUT, E_SRC_NONGAAP_EXPORT_FORMAT, E_SRC_SLAPP_NONGAAP, E_SRC_FJC_RAW, E_SRC_FJC_DISMISSED_OUTPUT, E_SRC_FJC_NEW1_OUTPUT, E_SRC_FJC_EXPORT_INPUT, E_SRC_FJC_EXPORT_FORMAT, E_SRC_SAMPLE_DTA_README, E_SRC_SAMPLE_DTA_README2, E_SRC_SAMPLE_WORK, E_SRC_SAMPLE_DTA_READ, E_SRC_SAMPLE_DTA_READ_T1, E_SRC_SAMPLE_DTA_READ_T6, E_SRC_REVIEWS_PATH, E_SRC_REVIEWS_FIELDS, E_SRC_REVIEWS_KEY, E_SRC_GSP_1977_1997, E_SRC_GSP_1997_2017, E_SRC_UR, E_SRC_POP, E_SRC_COHORT_BASE, E_SRC_COHORT_CRASH, E_SRC_COHORT_FSCORE, E_SRC_COHORT_NEGPR, E_SRC_TABLE1_OUTPUT, E_SRC_REghdfe, E_SRC_ESTSTO, E_SRC_ESTTAB, E_SRC_OUTREG2, E_SRC_COEFPLOT, E_SRC_PSACALC2, E_SRC_RANGEJOIN, E_SRC_WINSOR2, E_SRC_CARRYFORWARD

Preparation / proposed procedure:

1. First confirm the separate access, prepared-input, runtime and Stata add-on actions, and set DB/SLAPP/REP plus the Stata $db root and each remote WORK transfer path. Do not start a consumer before its source-owned input and output mapping are confirmed.
2. Run Sample Construction/Index.sas first to construct and return INDEX. Then run Sample Construction/Controls.sas and Sample Construction/Crash.sas as dependent branches after their remote INDEX upload paths are configured; confirm the distinct controls, returns, dturn and crash outputs before their consumers.
3. Run Sample Construction/construct_historicalhq.sas after its DB.STATEHIS input is prepared, then resolve DB.HQ_CHANGE to the SLAPP.HQ_CHANGE location before Sample Construction/SAS_Sample Construction_JAR.sas reads it. Run Sample Construction/FScore.sas, Sample Construction/NegPR.sas and Sample Construction/NonGAAP.sas as separate source-product branches with their own required inputs and preserved outputs. Run Sample Construction/fjc_construct_dismissed.sas with the separate FJC and district-key inputs before the Table 1/FJC consumer branch.
4. After all source-required sample inputs and library bindings are ready, run Sample Construction/SAS_Sample Construction_JAR.sas. Its final DATA step creates WORK.SAMPLE; README names that same program output as sample.dta. Persist that same table, without adding or dropping rows or variables, in Stata DTA form at the configured $db path read by the Stata consumers.
5. After the sample handoff and separate review/state panels are staged, run Sample Construction/construct_mainsample.do to produce its main/state and cohort outputs. In the Table 1 branch, run Sample Construction/construct_sample_Table1.do after the sample and FJC outputs, then run Analysis/Table1.do. Keep these branches conditional on their own exact source inputs.
6. After the relevant cohort outputs exist, run Analysis/Regression_F Score Sample_JAR.do for the F-score cohort, Analysis/Regression_Neg PR Sample_JAR.do for the negative-press cohort, and Analysis/Regression_Stock Crash Sample_JAR.do for the crash cohort. Run Analysis/Table5.do after its required cohort outputs, and Analysis/Table6B.do after its sample/FJC/state inputs and rangejoin setup are ready.
7. Preserve the source-supported edges above, but do not infer an order among independent producers or invent a hidden transformer/library alias where the supplied sources do not specify one.

Validation to perform later:

- Before each later stage, verify exact input fields, keys, history and first-consumer path using the linked source contracts and existing local-probe matrix; keep unverified prepared/public routes and historical coverage unresolved until supported.
- For each generated handoff, record its source producer, target location and first consuming program. Confirm the sample DATA-to-DTA staging preserves the source-created observations and variables and that all three named Stata readers resolve the same file.
- Check that each regression/table/figure branch reads the specific cohort or prepared output it requires; verify Stata add-on and SAS component availability before running those programs. No author program is executed by this proposal.


## Remaining issues and prerequisites

- I_STATEHIS_LINEAGE [unresolved; full_pipeline]: README/datasheet identify 10-K/10-X header data, while construct_historicalhq reads prepared DB.STATEHIS and creates DB.HQ_CHANGE. The producer, exact header-to-STATEHIS field mapping and source history are not supplied or verified. The CSV import rows are withheld as a complete quoted path block under the preventive byte-screen rule; this is not evidence of a credential or access incident.
- I_SAS_LIBREFS [unresolved; full_pipeline]: SAS sources use DB, SLAPP and REP library aliases, remote submission, and WORK upload/download/export stages, but the supplied sources do not define their full physical mappings and transfer order. DB.HQ_CHANGE is later consumed as SLAPP.HQ_CHANGE; other generated tables move between WORK and SLAPP inputs. The README identifies WORK.SAMPLE from the supplied SAS sample program as sample.dta for three Stata consumers; persisting the same rows and fields in Stata format at their $db path is an ordinary output staging step. Resolve those path/format/remote handoffs as configuration; they are not separate raw-data gaps, missing-license claims or secret-exposure claims.
- R_COMP_CO_AUDIT [undetermined]: Compustat annual auditor input joined by GVKEY and DATADATE; source consumes AU under consolidated/industrial/standard/domestic filters to derive the Big4 measure.
- R_CRSP_ERDPORT1 [undetermined]: CRSP event-return portfolio input used by Crash.sas, keyed by PERMNO/DATE and consuming DECRET.
- R_IBES_ICLINK [undetermined]: I/B/E/S ticker-link input required to map PERMNO to TICKER; source keeps the lower SCORE when a GVKEY has multiple ticker candidates.
- R_RAVENPACK [undetermined]: RavenPack press-release observations used to construct negative-press measures; required entity ID, timestamp, name/group/country and RELEVANCE/ESS/NIP fields.
- R_RP_MAPPING [undetermined]: RavenPack entity mapping input required jointly with RavenPack releases; source uses entity/data type, effective range and data value to resolve CUSIP.
- R_SLAPP_FUNDA [undetermined]: Author-prepared SLAPP.FUNDA annual input used to construct the sample. Source requires the corrected 48-field raw contract; GVKEY2/CIK2 are generated from GVKEY/CIK in the supplied step. The local raw COMP.FUNDA candidate does not establish this prepared product: its full native schema lacks PPE and SIC and its existing selected-column probe omitted other required fields.
- R_SLAPP_COMP_HQINC [undetermined]: Prepared current headquarters-state input joined by GVKEY and DATADATE to fill missing historical headquarters states.
- R_SLAPP_SIC [undetermined]: Prepared SIC history joined by GVKEY/DATADATE in sample construction. The raw COMP.NAMES product is locally available but has effective year1/year2 bounds rather than the source's date-keyed prepared contract; the conversion and resolution rule are not established.
- R_SLAPP_DATES [undetermined]: State-level anti-SLAPP enactment-year input keyed by state abbreviation and year; this table supplies the treatment year used in the stacked cohorts.
- R_SLAPP_STATECONTROLS [undetermined]: Prepared state-year population and income-per-capita table joined by HQ state and year. This is separate from the population-only panel used in Stata and cannot be inferred from it.
- R_SLAPP_ACTU_EPSUS4 [undetermined]: Prepared estimate input used in the sample merge; source requires GVKEY/PENDS/MEDest/VALUE. This is not interchangeable with the locally readable IBES ACT_EPSUS actual EPS table, which is keyed by TICKER and records actual EPS rather than the source's MEDest estimate measure.
- R_SLAPP_LABORSKILL [undetermined]: Industry-year skill measure merged by YEAR/IND; source data sheet identifies the Belo et al. labor-skill product but not the exact file schema or covered years.
- R_SLAPP_SHORTINT [undetermined]: Prepared short-interest panel keyed by GVKEY and split-adjusted date; source matches observations within a preceding 365-day interval and consumes SHORTINTADJ/SHORTINT.
- R_SLAPP_SENTIMENT [undetermined]: Prepared annual sentiment-score panel keyed by PERMNO/YEAR and carrying NEWSTONE_NONSTD; this is distinct from the RavenPack press-release construction.
- R_SLAPP_SENTIMENT2 [undetermined]: Prepared annual news-count panel keyed by PERMNO/YEAR and carrying NEWSCOUNT_NONSTD; this is distinct from the RavenPack press-release construction and from the sentiment-score panel.
- R_KURT_NONGAAP [undetermined]: Separately downloaded manager Non-GAAP dataset joined by GVKEY/DATADATE; the supplied source consumes MGR_EXCLUDE and MGR_NG_EPS to construct quarterly/yearly non-GAAP measures. This is a raw input to the generated SLAPP.NONGAAP output.
- R_LM_HEADER [undetermined]: Manual Loughran-McDonald 10-K/10-X header data input used by the historical-HQ preparation. The source's quoted CSV/import block is withheld by preventive path screening, so its exact CSV schema and relation to the prepared statehis table remain unknown.
- R_STATEHIS [undetermined]: Prepared DB.STATEHIS historical filer/report table used by construct_historicalhq. Source compares F_CIK to CIK, derives filing/report dates and retains F_FTYPE, BA_STATE, state of incorporation and SIC_NUM. Its producer/mapping from the 10-K header source is not supplied or verified.
- R_FJC [undetermined]: FJC Civil Court Case input used to classify libel cases by NOS, judgment/disposition, dates, district, docket, office and parties. Source filters NOS=320 and derives annual state-year aggregates.
- R_DISTRICT_KEY [undetermined]: Independent district-code crosswalk required to add jurisdiction/state to FJC civil cases; keyed by source CODE and providing jurisdiction/state.
- R_REVIEWS [undetermined]: Author-described Glassdoor reviews from Revelio Labs, consumed as a prepared firm-review input. Required fields include GVKEY, timestamp, overall rating, review text/pros/cons/advice and business outlook; source aggregates to firm-year. This does not substitute for the separate annual state panels.
- R_REAL_GSP_1977_1997 [undetermined]: Prepared state real-GSP panel keyed by HQ state/CYEAR with REAL_GSP. Stata derives the within-state lagged growth rate; this is a distinct 1977-1997 input window.
- R_REAL_GSP_1997_2017 [undetermined]: Prepared state real-GDP panel keyed by HQ state/CYEAR with REAL_GDP. Stata renames GDP to GSP, derives within-state lagged growth, drops the duplicate 1997 boundary, then appends to the prior distinct panel.
- R_UR [undetermined]: Prepared unadjusted state unemployment panel keyed by HQ/YEAR with UR; Stata merges this to the combined real-GSP growth panel and constructs a lag.
- R_POP [undetermined]: Separate prepared state population panel keyed by HQ/YEAR with POPULATION. Stata merges it with unemployment and state growth, then forms lagged log population; it is not the combined SLAPP.STATECONTROLS input.
- SW_SAS [unverified]: SAS program files are required; the environment proof does not confirm SAS availability/version and no SAS session was started.
- SW_SAS_CONNECT [unverified]: SAS source uses remote submission and upload/download stages; CONNECT availability and site configuration are unverified.
- SW_PROC_REG [unverified]: Crash source calls PROC REG, which requires the SAS/STAT capability; no SAS startup or procedure probe was run.
- SW_PROC_EXPORT_STATA [unverified]: SAS source exports outputs through DBMS=STATA; component/version availability is unverified.
- SW_RANGEJOIN [preparation_required]: The source uses rangejoin and the Stata 18 command metadata probe reports it unavailable; installation is ordinary preparation, not a data barrier.
- SW_OUTREG2 [preparation_required]: The source uses outreg2 and the Stata 18 command metadata probe reports it unavailable; installation is ordinary preparation, not a data barrier.
- SW_PSACALC2 [preparation_required]: The source uses psacalc2 and the Stata 18 command metadata probe reports it unavailable; installation is ordinary preparation, not a data barrier.
- SW_WINSOR2 [preparation_required]: Construction and analysis sources use winsor2 and the Stata 18 command metadata probe reports it unavailable; installation is ordinary preparation, not a data barrier.
- SW_CARRYFORWARD [preparation_required]: Stock-crash analysis uses carryforward and the Stata 18 command metadata probe reports it unavailable; installation is ordinary preparation, not a data barrier.

## Review notes

- The full scope is the README/datasheet workflow across all 17 supplied SAS/Stata programs, including historical HQ preparation, Index, controls/crash/FScore/NegPR/NonGAAP construction, SAS sample construction, FJC/Table 1 preparation, main-sample and three cohort construction, and the listed analyses. The three packaged DTA probes are GVKEY/FYEAR/COHORT identifier lists only; no analysis_only scope is supported.
- The corrected v4 source-field matrix preserves v3 and corrects the raw contracts: SLAPP.FUNDA adds FOPO and excludes source-generated GVKEY2/CIK2; DB.STATEHIS adds retained F_FTYPE; Nongaap_data_2003to2020 is a separate raw manager input; SLAPP.NONGAAP is a generated output. The full native COMP.FUNDA schema lacks PPE and SIC required by SLAPP.FUNDA, and the current selected probe omits additional fields. This candidate-specific mismatch is not a claim about the separate author-prepared SLAPP.FUNDA file.
- The prior COMP.FUNDQ probe omitted FQTR and RDQ. The supplemental source-driven one-row probe reads the exact source-owned field set and has a successful readable schema result at the native location; the prior proof is preserved. Neither probe verifies full history or coverage.
- All ten local raw routes classified verified have complete source-consumed field sets matched case-insensitively to their exact successful selected probes and full native schemas; expected_fields records the exact native probe column case. One-row schema/readability does not establish population, endpoint history or original author vintage. Catalog misses remain discovery limits, never absence or licensing evidence.
- The 10-X header product, BLS/BEA series, WRDS products, Kurt Gee and Belo pages are candidate sources only. Public pages support product families; they do not verify the exact author release, fields, periods or local access. No route is marked blocked and no access barrier is inferred.
- The original registered environment JSON was referenced by hash and inspected only through the pinned typed viewer. Raw environment diagnostics/license fields, software-probe logs, SAS logs and sample values were not displayed. SAS was not started; no author code was executed/imported/parsed/compiled and no statistical trial or dataset download/install was performed.
- Preventive byte screening returned normal withheld markers for complete quoted paths and remote/configuration blocks. Those markers were not treated as incidents, data-absence claims or new approval gates. The value-free method note retains the one unintended bounded sweep-directory search command/scope/capture limits; no foreign content was re-opened, copied or used as scientific evidence.
- Supported sample output: README lines 45-48 and 61-68 identify sample.dta as the output of SAS_Sample Construction_JAR; its supplied final DATA steps create WORK.SAMPLE, while three Stata sources read the sample name/path. The remaining DTA persistence, format and $db path work is same-data staging under I_SAS_LIBREFS, not a separate raw sample-data requirement. No export or field transformation was executed.
