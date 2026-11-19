# Patch proposal: jar-5ffbb72d91ed

Beyond Old Boys' Clubs: Financial Analysts' Utliization of Professional Connections

DOI: 10.1111/1475-679X.70044

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow for preparing CIQ experience and transcript measures, constructing analyst/executive connections and running the supplied analyses.

Entry points: `_DZ_2026_data/analyses_code_log_Stata/DZ_Stata_code.do`, `_DZ_2026_data/professional_experience/gather_experience.sas`, `_DZ_2026_data/professional_experience/linktable_01_gather_financial_analysts_from_ciq.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 4/70044 - Beyond-Old-Boys-Clubs-Financial-Analysts-Utliization-of-Professional-Connections/dz-datasheet-code-identifier-and-log-files.zip",
      "sha256": "3a77f39fb55bdb098b8b966566d75fc516ba00e5454bea6728ae66cd40007870"
    },
    {
      "path": "JAR-Volume 64/Issue 4/70044 - Beyond-Old-Boys-Clubs-Financial-Analysts-Utliization-of-Professional-Connections/dz-2026-online-appendix.pdf",
      "sha256": "31051017264e22f3c8e3045be8c4d7adb05f47d74f5118bffc32353baa180251"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "5f82381a00a0622488022c39899c4023fdb1e7cfa8397f6fde4042622021c997"
}
```

## Proposed actions

### ACT_STATA_INPUTS: Obtain the author-named Stata inputs and update workbooks, then verify schemas, join keys and date/history coverage before running the driver.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_CRSP_COMPUSTAT_QTR, REQ_IBES_CRSP_LINK, REQ_IBES_ACTUALS, REQ_CONF_SCHEDULE, REQ_CONF_PARTICIPANTS, REQ_SCHOOL_TIES, REQ_CIQ_EARNINGS_CALL, REQ_INVESTOR_ENGAGEMENT, REQ_EXEC_FIRM, REQ_IBES_ANNUAL_EPS, REQ_IBES_RECOMMENDATIONS, REQ_IBES_FORECAST_HISTORY, REQ_GENDER_BASE, REQ_GENDER_2016, REQ_GENDER_SUMMARY_20201125, REQ_GENDER_2020_2022, REQ_CRSP_PRICE_HISTORY, REQ_DGTW_REVISION_CAR, REQ_OWNERSHIP_13F, REQ_ALLSTAR
Evidence: EV_README_IBES, EV_README_IBES_LINK, EV_README_IBES_ACTUALS, EV_README_IBES_RECS, EV_README_GENDER, EV_README_EXEC_FIRM, EV_README_QTR_PANEL, EV_README_CRSP_PRICE, EV_README_DGTW, EV_README_SCHOOL_TIES, EV_README_OWNERSHIP, EV_README_ALLSTAR, EV_README_CONF_SCHEDULE, EV_README_CONF_PARTICIPANTS, EV_README_INVESTOR_ENGAGEMENT, EV_SUBSCRIPTION_CONDITION, EV_CAT_COMP_FUNDQ_LOOKUP, EV_CAT_CRSP_LINK_LOOKUP, EV_CAT_CRSP_DSF_LOOKUP, EV_CAT_CRSP_MSF_LOOKUP, EV_CAT_IBES_DET_LOOKUP, EV_CAT_IBES_DETU_LOOKUP, EV_CAT_IBES_REC_MISS, EV_CAT_IBES_RECS_MISS, EV_CAT_13F_LOOKUP, EV_CAT_BOARDEX_LOOKUP

Preparation / proposed procedure:

1. Locate the exact author-prepared files named in the Stata readme, including four gender updates, both conference workbooks, CRSP/Compustat and price panels, I/B/E/S inputs, DGTW returns, 13F ownership and the all-star panel.
2. For each file, record physical path, native fields, join keys and date coverage; verify 2004–2022 sample coverage and any pre-sample experience or lag history separately.
3. Confirm necessary commercial subscriptions described in the datasheet where a source product must be reacquired, and retain the authors' preparation/filtering choices.
4. If rebuilding from native products, treat COMP.FUNDQ plus CRSP.CCMXPF_LINKTABLE and daily CRSP.DSF plus monthly CRSP.MSF as joint candidates; treat I/B/E/S DET_EPSUS/DETU_EPSUS and TFN.S34 as product candidates only. Preserve unresolved annual/horizon filters, all-time history, panel/link construction, Top10InstOwn and BoardEx matching until the author contract is documented.
5. Exact IBES.REC/RECS and ccmlink_qtr_202212 catalog lookups returned no matching leaves; request the author product identity or an exact supported route without inferring data or licensing absence.

Validation to perform later:

- Probe bounded metadata on exact files and compare every consumed field/key against code; document full date/history coverage separately because one-row probes cannot establish it.
- Do not credit any candidate table as a complete input until exact native keys/fields, selection rules and required history have been verified.

### ACT_CIQ_INPUTS: Provide the CIQ/WRDS source tables and manual mapping files read by the registered SAS preparation sources.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_ANALYS_PERSONID_LINK, REQ_CIQ_WRDS_PROFESSIONAL, REQ_CIQ_COUNTRY_GEO, REQ_CIQ_BROKER_MATCH, REQ_CIQ_WRDS_GVKEY, REQ_CIQ_TRANSCRIPT_PERSON, REQ_CIQ_WRDS_TRANSCRIPT_PERSON, REQ_CIQ_WRDS_TRANSCRIPT_DETAIL, REQ_CCM_LINK_QTR
Evidence: EV_SAS_ID_LINK, EV_SAS_PROF_EXPERIENCE, EV_SAS_COUNTRY_EXPERIENCE, EV_SAS_BROKER_EXPERIENCE, EV_SAS_GVKEY, EV_SAS_CIQ_PERSON, EV_SAS_PROF_LINK, EV_SAS_COUNTRY_LINK, EV_SAS_BROKER_LINK, EV_SAS_TRANSCRIPT_PERSON, EV_SAS_TRANSCRIPT_DETAIL, EV_SAS_CCM_LINK, EV_SUBSCRIPTION_CONDITION

Preparation / proposed procedure:

1. Obtain 02_ANALYSPERSONID_LINK.csv and 01_brokers_matched_20230507.csv with the authors' mapping rules.
2. For each CIQ/WRDS table, record exact physical file, native columns and extraction period; include the CIQ country/geography map and ccmlink_qtr_202212 input named by the SAS source.
3. Compare fields, keys and year coverage across repeated uses in both SAS sources before treating one table as a complete input.

Validation to perform later:

- Use bounded one-row probes only on exact catalog-listed files under the approved root; verify manually supplied CSV headers and keys without executing study code.

### ACT_CIQ_CAREER_HANDOFF: Resolve how the registered CIQ preparation outputs produce the Stata career-indicator input.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ_CIQ_CAREER_INDICATORS, ISS_CIQ_CAREER_HANDOFF
Evidence: EV_DEP_CIQ_CAREER_MERGE, EV_DEP_CIQ_CAREER_FIELDS, EV_README_CIQ_CAREER, EV_SAS_CAREER_OUTPUT, EV_SAS_LINK_OUTPUT_PERSONDATE, EV_SAS_LINK_OUTPUT_ROLE, EV_PROF_EXPERIENCE_README

Preparation / proposed procedure:

1. Obtain a registered, screened source view for linktable_02_link_with_ibes_analys.py and identify the exact writer for ciq_career_indicators.dta.
2. Record the complete output schema, analyst-ID mapping, GVKEY career fields and date/history selection linking the SAS outputs to the Stata merge.

Validation to perform later:

- Confirm a source-backed producer chain and compare each Stata-consumed field/key with a bounded metadata probe of the exact prepared input.

### ACT_UNREGISTERED_PROGRAMS: Complete the registered-source review for the conference and earnings-call preparation branches.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS_SOURCE_COVERAGE
Evidence: EV_DATASHEET_PROGRAMS, EV_INVESTOR_README, EV_EARNINGS_README, EV_PROF_EXPERIENCE_README, EV_ITEM_METADATA

Preparation / proposed procedure:

1. Register screened text views for the inventoried investor-conference and earnings-call HTML programs and the referenced Python linkage program.
2. Trace their exact data inputs, outputs and handoffs into the Stata datasets, retaining any remaining unregistered source or handoff gap explicitly.

Validation to perform later:

- Confirm each source has an exact registered package path and hash before relying on its code or treating the workflow as closed.

### ACT_MASKED_INPUTS: Resolve the additional Stata inputs keyed by executive or transcript IDs.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ_EXEC_BOARDEX_LINK, REQ_TRANSCRIPT_QN_WORDCOUNT, ISS_MASKED_INPUTS
Evidence: EV_DEP_BOARDEx_JOIN, EV_README_EXEC_BOARDEX, EV_DEP_TRANSCRIPT_LOOKUP, EV_STATA_TRANSCRIPT_WORDS, EV_CAT_BOARDEX_LOOKUP

Preparation / proposed procedure:

1. Provide exec_boardex_link.dta and its director/executive mapping fields, and identify the transcriptid-keyed input that supplies nwords_qn.
2. For both inputs, document exact file identity, full join keys and expected coverage.
3. The broad BoardEx lookup found local region-specific profile-detail candidates; obtain the authors’ exact executive/director link file or documented mapping process before substitution.

Validation to perform later:

- Verify each input's native fields against the Stata join/merge statements with a bounded metadata check.

### ACT_STATA_ADDONS: Resolve the three Stata add-ons used by the driver but not found by the bounded environment checks.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_RANGEJOIN, SW_XFILL, SW_WINSOR2
Evidence: EV_SW_RANGEJOIN, EV_SW_XFILL, EV_ENVIRONMENT

Preparation / proposed procedure:

1. Install or configure rangejoin, xfill and winsor2 for Stata 18 from an approved Stata package source.

Validation to perform later:

- Rerun bounded software metadata checks for each exact command and record installed versions/locations.

### ACT_SAS_RUNTIME: Establish the SAS runtime status for the registered preparation sources after input requirements are assembled.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: SW_SAS
Evidence: EV_ENVIRONMENT, EV_DATASHEET_PROGRAMS

Preparation / proposed procedure:

1. Confirm an authorized SAS 9.4 runtime and required library configuration through the project's approved operational process.

Validation to perform later:

- Record a supported runtime/version and library-availability check before any later author-code run; this assessment did not start SAS.

### ACT_PATH_CONFIGURATION: Configure the Stata input and output directories after the named data inputs are present.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: REQ_CRSP_COMPUSTAT_QTR, REQ_IBES_CRSP_LINK, REQ_IBES_ACTUALS, REQ_CONF_SCHEDULE, REQ_CONF_PARTICIPANTS, REQ_SCHOOL_TIES, REQ_CIQ_EARNINGS_CALL, REQ_INVESTOR_ENGAGEMENT, REQ_EXEC_FIRM, REQ_IBES_ANNUAL_EPS, REQ_IBES_RECOMMENDATIONS, REQ_IBES_FORECAST_HISTORY, REQ_GENDER_BASE, REQ_GENDER_2016, REQ_GENDER_SUMMARY_20201125, REQ_GENDER_2020_2022, REQ_CRSP_PRICE_HISTORY, REQ_DGTW_REVISION_CAR, REQ_OWNERSHIP_13F, REQ_ALLSTAR, REQ_CIQ_CAREER_INDICATORS, REQ_EXEC_BOARDEX_LINK, REQ_TRANSCRIPT_QN_WORDCOUNT, REQ_ANALYS_PERSONID_LINK, REQ_CIQ_WRDS_PROFESSIONAL, REQ_CIQ_COUNTRY_GEO, REQ_CIQ_BROKER_MATCH, REQ_CIQ_WRDS_GVKEY, REQ_CIQ_TRANSCRIPT_PERSON, REQ_CIQ_WRDS_TRANSCRIPT_PERSON, REQ_CIQ_WRDS_TRANSCRIPT_DETAIL, REQ_CCM_LINK_QTR
Evidence: EV_STATA_INPATH, EV_STATA_DRIVER

Preparation / proposed procedure:

1. Set the driver's inpath/outpath macros to accessible directories containing verified author inputs and writable outputs while preserving expected basenames.
2. Resolve every use/import/merge target to one exact prepared file before attempting the driver.

Validation to perform later:

- Check path resolution for each required source file and confirm the output directory is writable.


## Remaining issues and prerequisites

- ISS_SOURCE_COVERAGE [unresolved; full_pipeline]: The datasheet and readmes describe investor-conference, earnings-call and analyst-linkage stages, while the frozen work-item source registration does not provide screened text for the inventoried HTML and referenced Python program bodies. Their detailed field handoffs and production steps remain unreviewed; this is a coverage limit, not evidence that the code or outputs are absent.
- ISS_CIQ_CAREER_HANDOFF [unresolved; full_pipeline]: The Stata driver requires ciq_career_indicators.dta and fields including gvkey_collector_after, but the registered SAS sources visibly write CIQ_FAexperience.dta and analyst linkage CSVs. The referenced linktable_02 Python source and exact producer from those outputs to the Stata input are not registered, so this handoff and the full schema remain unresolved.
- ISS_MASKED_INPUTS [unresolved; full_pipeline]: The Stata source contains an additional join by execid and a transcriptid merge whose exact input contracts are not established in the registered review. The README names exec_boardex_link.dta, while the transcriptid input identity remains unresolved; nwords_qn is consumed after that merge.
- REQ_CRSP_COMPUSTAT_QTR [undetermined]: Prepared CRSP/Compustat quarterly panel CRSP_Compustat.dta. The driver constructs quarterly firm controls from dates, CRSP identifiers and Compustat fundamentals, then merges those controls into the forecast sample. Required fields include datadate, lpermno, cusip, tic, gvkey, sic, fyear, CRSP/Compustat identifiers, and the quarterly measures used in the code. Period/history: The sample forecast period is 2004–2022; quarterly input/history beyond the estimation sample is not established.
- REQ_IBES_CRSP_LINK [undetermined]: IBES_CRSP_Link.dta supplies validity-window links used both for forecast fiscal-period ends and investor-conference engagement records. Across reads, the contract includes ticker, fpedats/date, permno, ncusip, score, sdate and edate. Period/history: Link dates must cover forecast and conference observations; exact bounds are unknown.
- REQ_IBES_ACTUALS [undetermined]: IBES_actuals.dta is used to order firm earnings-announcement dates by ticker and construct the previous announcement date. Period/history: Announcement history must cover forecast windows; no complete interval was verified.
- REQ_CONF_SCHEDULE [undetermined]: DZ_01_transcripts_20230412.xlsx supplies the conference schedule keyed by transcriptid and later date/gvkey attributes.
- REQ_CONF_PARTICIPANTS [undetermined]: DZ_02_TranscriptParticipants_20230412.xlsx supplies conference analyst and executive participants. It joins by transcriptid and the driver uses analyst, executive, ticker, name and gender fields.
- REQ_SCHOOL_TIES [undetermined]: related_bdex_analyst.sas7bdat supplies analyst/director school-tie flags and relation_start_year; its records are joined to executive-director links.
- REQ_CIQ_EARNINGS_CALL [undetermined]: transcript_analys_20240611 supplies earnings-call analyst observations joined to forecasts by gvkey and date. The driver consumes year, analys, gvkey, transcriptid, mostimportantdateutc and n_words. Period/history: Capital IQ transcript downloads were in 2024; linked sample dates and coverage remain unverified.
- REQ_INVESTOR_ENGAGEMENT [undetermined]: DZ_03_analyst_engagement_20240618.xlsx supplies investor-conference analyst engagement observations. The driver imports the named worksheet and uses analyst/ticker/date, transcript and question-number fields; the full workbook schema and construction are unreviewed.
- REQ_EXEC_FIRM [undetermined]: exec_firm.dta provides executive-firm-year records. The driver consumes GVKEY, EXECID, YEAR, CUSIP, TICKER, CEOANN, CFOANN, TITLEANN, GENDER and AGE. Period/history: Must cover analyst-firm connections in the 2004–2022 forecast sample; full year coverage was not checked.
- REQ_IBES_ANNUAL_EPS [undetermined]: IBES_annual_eps.dta is read repeatedly for forecast, consensus, revision, forecast-error and analyst-connection measures. Across reads the source uses analyst/name, ticker, announcement/activation/actual dates, fiscal-period end, value, estimator, announcement time, actual, OFTIC and CUSIP fields. Period/history: Forecast announcements are filtered to 2004–2022; earlier history is used for analyst experience and forecast lags, with no complete lower bound established.
- REQ_IBES_RECOMMENDATIONS [undetermined]: IBES_recommendation_alltime.dta is used for concurrent recommendation and analyst-history measures. The driver references AMASKCD, analyst, estimid, anndats, ticker, actdats, acttims, ireccd and oftic. Period/history: Concurrent recommendations are filtered from 2000 while experience uses all-time history; the lower history bound is not stated.
- REQ_IBES_FORECAST_HISTORY [undetermined]: IBES_eps_annual_all_time supplies analyst/ticker/announcement-date history used to calculate first observed analyst and analyst-firm forecast years. Period/history: All-time history is required for minimum-year measures; no lower bound is documented.
- REQ_GENDER_BASE [undetermined]: gender.dta is the first analyst-gender update merged by analyst ID; the source uses afemale and name fields during cleanup.
- REQ_GENDER_2016 [undetermined]: gender_2016.dta is a sequential analyst-gender update merged by analyst ID with update semantics.
- REQ_GENDER_SUMMARY_20201125 [undetermined]: analyst_gender_summary_20201125.dta is a sequential analyst-gender update merged by analyst ID with update/replace semantics.
- REQ_GENDER_2020_2022 [undetermined]: analyst_gender_2020-2022.dta is the final analyst-gender update merged by analyst ID.
- REQ_CRSP_PRICE_HISTORY [undetermined]: CRSP_2000_2022.dta is merged by CUSIP/year. The driver uses prc, shrout and prc_q1/prc_q2/prc_q3 in forecast-price and ownership scaling. Period/history: The author-named file spans 2000–2022; actual coverage and quarterly-price construction are unverified.
- REQ_DGTW_REVISION_CAR [undetermined]: Firm_date_revision_car_20230414 supplies four event-window DGTW returns matched by ticker and recommendation dates.
- REQ_OWNERSHIP_13F [undetermined]: ownership_13f.dta is merged by CUSIP/year and supplies Top10InstOwn, which the driver scales by market value. Period/history: Annual ownership must cover analyst-year observations; history and Top10 construction are unverified.
- REQ_ALLSTAR [undetermined]: The allstar_1972-2022 input is merged 1:1 by analyst/year to create the analyst-year all-star indicator. Period/history: The author-named coverage is 1972–2022; contents and analyst-year coverage are unverified.
- REQ_CIQ_CAREER_INDICATORS [undetermined]: ciq_career_indicators.dta is merged by analyst ID. The driver splits gvkey_collector_after and several executive-status GVKEY collections; the complete producer schema and career coverage are unresolved. Period/history: Career observations must support analyst after-employment history; exact observation window is not documented.
- REQ_EXEC_BOARDEX_LINK [undetermined]: exec_boardex_link.dta joins executive IDs to BoardEx director IDs and name-match fields; the driver consumes director/name components and match scores after the execid join.
- REQ_TRANSCRIPT_QN_WORDCOUNT [undetermined]: An additional transcriptid-keyed input is merged during investor-conference construction; the driver later consumes nwords_qn. The input identity and full field contract remain unresolved.
- REQ_ANALYS_PERSONID_LINK [undetermined]: 02_ANALYSPERSONID_LINK.csv is a manually created analyst-to-CIQ-person map used in professional-experience and linkage preparation.
- REQ_CIQ_WRDS_PROFESSIONAL [undetermined]: The CIQ WRDS professional table is consumed by both registered SAS sources and supplies person, company, role/function and career fields. Period/history: Career history must cover the analyst experience measures; extract period is unstated.
- REQ_CIQ_COUNTRY_GEO [undetermined]: The SAS sources join countryid to a CIQ geography map and use country, isocountry3 and region. The exact map file and field contract are unresolved.
- REQ_CIQ_BROKER_MATCH [undetermined]: 01_brokers_matched_20230507.csv is a manual broker-match input used in both CIQ preparation sources. Exact matching fields and rows are not described.
- REQ_CIQ_WRDS_GVKEY [undetermined]: The career-preparation source reads the CIQ company-to-GVKEY mapping.
- REQ_CIQ_TRANSCRIPT_PERSON [undetermined]: The CIQ analyst-linkage source reads transcript participants and filters analyst speaker types with nonmissing proid.
- REQ_CIQ_WRDS_TRANSCRIPT_PERSON [undetermined]: The CIQ analyst-linkage source reads WRDS transcript-person details; complete field and history contract remains unverified.
- REQ_CIQ_WRDS_TRANSCRIPT_DETAIL [undetermined]: The CIQ analyst-linkage source reads transcript details, including transcript/company and most-important-date fields.
- REQ_CCM_LINK_QTR [undetermined]: The CIQ analyst-linkage SAS source reads data.ccmlink_qtr_202212. The frozen exact alias lookup returned no catalog leaf; the physical author file, consumed columns and coverage remain unresolved.
- SW_SAS [unverified]: The typed environment metadata does not verify a SAS runtime. No SAS process was started, as required.
- SW_RANGEJOIN [preparation_required]: The Stata source uses rangejoin for date-window joins; the bounded Stata metadata probe did not find it.
- SW_XFILL [preparation_required]: The Stata source uses xfill to fill panel-group values; the bounded Stata metadata probe did not find it.
- SW_WINSOR2 [preparation_required]: The Stata source uses winsor2 for winsorization; typed environment metadata reports it unavailable.

## Review notes

- Full-pipeline scope uses the registered Stata driver and both registered SAS preparation sources; inventoried HTML bodies and the README-referenced Python source remain outside the registered text-source set.
- All 35 frozen dependency IDs are assigned exactly once. Generated intermediates cite their supplied producer; direct source reads discovered beyond the frozen list are represented as separate mandatory requirements.
- Repeated I/B/E/S annual forecast reads were reconciled across filters, dates, keys and consumed fields. The author-prepared annual extract's complete schema and history remain unresolved.
- The two successful one-row probes establish readability and requested columns only. ExecuComp year coverage and I/B/E/S actual-announcement history remain unverified; no SAS process was started.
- Local CIQ catalog candidates remain unverified without bounded data probes. Catalog hits do not establish the author-prepared career, transcript or country-map contracts.
- No capture index, mask/process/method manifest, raw environment body, or author execution log is cited as scientific evidence.
