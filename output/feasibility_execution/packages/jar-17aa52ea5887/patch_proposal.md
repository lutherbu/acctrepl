# Patch proposal: jar-17aa52ea5887

Perceptions and Price: Evidence from CEO Presentations at IPO Roadshows

DOI: 10.1111/1475-679X.12164

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: prepare the author IPO.* inputs, combine them in the supplied SAS source, and reproduce the paper analyses/outputs once the missing workflow components are supplied.

Entry points: `Datasheet - Code Submit.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 2/12164 - Perceptions-and-Price-Evidence-from-CEO-Presentations-at-IPO-Roadshows/blankespoor-hendricks-miller-datasheet-and-code.zip",
      "sha256": "ada4f512619f9a57f6682d1090fe951b1ddd1180d160e1f5fbc0dbca5a7b1504"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "0280afeeca618cb0bb3dc20882d8ef60b887e1481ece848158e6a766604bb96c"
}
```

## Proposed actions

### A_VENDOR_INPUTS: Obtain the exact author-prepared IPO.Linking, IPO.SDC, IPO.Ritter, IPO.Compustat, IPO.Market, IPO.CRSP and IPO.Compustat_Post inputs or a verified compatible route, together with their SAS field mappings, identifiers, periods and source/version details.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_LINK, R_SDC, R_RITTER, R_COMP_PRE, R_MARKET, R_CRSP, R_COMP_POST
Evidence: E_LINK_DESC, E_SDC_DESC, E_RITTER_DESC, E_COMP_DESC, E_MARKET_DESC, E_CRSP_DESC, E_COMPPOST_DESC, E_CCM_PROBE, E_SDC_PROBE, E_FUNDA_PROBE, E_FUNDQ_PROBE, E_DSF_PROBE, E_DELIST_PROBE

Preparation / proposed procedure:

1. For IPO.Linking, provide the author table and confirm the manually researched supplements beyond the CRSP/Compustat base link table and the CUSIP/name/LPERMNO/PERMNO/GVKEY/CIK mappings.
2. For IPO.SDC, confirm whether the local SDC.WRDS_NI_DETAILS product matches the author SDC Platinum Global New Issues extract; document its U.S. IPO population, dates, CUSIP edits, and mappings to issuer, issue_date, filing_amount, primary_shares, filing_shares, offer_price and mid_range.
3. For IPO.Ritter, provide the merged author table or the exact version/fields and merge steps for founding year, Carter-Manaster prestige and post-IPO shares.
4. For IPO.Compustat, provide the author IPO table or the exact quarterly/annual input and construction rules for the p1* fields, including pre-IPO selection, fallback and trailing-twelve-month periods.
5. For IPO.Compustat_Post, confirm the author table or local Compustat route covers the final sample for 2011-2015 with GVKEY, DATADATE, ATQ and NIQ.
6. For IPO.CRSP, provide the author table or confirm the daily CRSP construction, including how DLRET/DLSTCD are attached, identifiers and coverage through 2015.
7. For IPO.Market, provide the author table or exact Yahoo historical series/file format and the adjusted-close-to-RETD definition.

Validation to perform later:

- Once supplied, use bounded metadata checks to confirm the required raw columns and compare the documented sample periods/identifiers; one-row reads do not establish full coverage.
- Keep all author-specific manual additions and data transformations explicit; do not substitute the local candidate files without product, period and field confirmation.

### A_FF_INPUTS: Acquire the verified official French public files for monthly ME breakpoints, annual BE/ME breakpoints and daily 100 size/book-to-market portfolios, then resolve the remaining source-to-SAS mappings.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FF_MVE, R_FF_BTM, R_FF_RET, I_FF_MAPPING
Evidence: E_FF_DESC, E_CODE_FF, E_FF_PROBE, E_FF_ME_LIST, E_FF_ME_PERIOD, E_FF_ME_PCTL, E_FF_BEME_LIST, E_FF_BEME_PERIOD, E_FF_BEME_PCTL, E_FF_100_LIST, E_FF_100_PERIOD, E_FF_100_METHOD, E_FF_VINTAGE, E_FF_REVISION

Preparation / proposed procedure:

1. Acquire the official ME Breakpoints CSV/TXT and use the 10th, 20th, ..., 90th percentile cuts to form the nine monthly MV thresholds; inspect the published headers and document the ME unit before mapping them to mv1-mv9.
2. Acquire the official BE/ME Breakpoints CSV/TXT and use the 10th, 20th, ..., 90th percentile cuts to form the nine annual BTM thresholds; inspect the published headers and document the scale before mapping them to btm1-btm9.
3. Acquire the official daily 100 Portfolios Formed on Size and Book-to-Market file; map its exact size/book-to-market labels into the SAS P00-P99 convention and retain the documented daily return units.
4. Compare the current French file vintage with the authors' March 2016 data pull and assess the official site's note about CRSP CIZ and monthly history revisions; do not claim byte-identical history without a verified archive.

Validation to perform later:

- After acquisition, verify the required 2011-2013 monthly/annual cutoff rows and daily return history through 2015, then confirm field labels and date keys against the SAS join conditions.
- Confirm how author shares_post units map to the French ME scale and that all P00-P99 portfolio labels are generated in the same size/B/M order before joining returns.

### A_MANUAL_INPUTS: Request the author-prepared hand-collected, survey-derived and image/text measures, or exact supported source materials and collection specifications for those inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EDGAR, R_ROADSHOW, R_PERCEPTION, R_TEXT, R_WHR, I_CEO_DATE_SOURCE
Evidence: E_EDGAR_DESC, E_ROADSHOW_DESC, E_PERCEPTION_DESC, E_TEXT_DESC, E_WHR_DESC, E_SURVEY_INSTR, E_VIDEO_RESTRICT, E_SEC_RAW_PROBE, E_SEC_PARSED_PROBE, E_LM11_PROBE, E_LM12_PROBE, E_LM13_PROBE

Preparation / proposed procedure:

1. Provide IPO.Edgar with a sample filing/identifier map, field definitions and coding rules for CEO variables, employee ownership and CEO last date; confirm which SEC form/sections and years are in scope.
2. Provide IPO.Roadshow derived coding data or a permitted route to the 2011-2013 sample recordings and the manual coding instructions; clarify whether coded rows can be shared even though underlying video outtakes cannot.
3. Provide IPO.Perception table or qualifying Qualtrics response extract and the aggregation/exclusion rules needed for the six video/image rating variables; if rebuilding the video inputs, specify Adobe Premiere Pro high-/low-pass filter settings and clip selection.
4. Provide IPO.Text counts or the exact filing-section and roadshow transcript sources, transcript availability, Python HTML-removal/LM-count code and settings, dictionary version, and text-processing rules.
5. Provide IPO.WHR measurements or image-to-PERMNO mapping, ImageJ version and measurement procedure.
6. For SEC/LM local candidates, provide CIK/accession/sample identifiers and compatibility criteria before any file-level checks; the current probes only confirm documented roots/year directories exist.
7. Identify which prepared input table supplies CEO_LAST_DATE and define the date used for turnover indicators.

Validation to perform later:

- After the author materials are supplied, check expected identifiers and fields, sample period, and data provenance; confirm that any manual/survey/image transformations reproduce the documented measures before SAS construction.

### A_LIBREF: Obtain the missing IPO library mapping and output location required by the SAS program.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_LIBREF
Evidence: E_CODE_LINK_SDC, E_CODE_CRSP_PRODUCER, E_CODE_CRSP_CONSUMER, E_INV

Preparation / proposed procedure:

1. Ask for the exact SAS LIBNAME assignment or approved configuration that exposes the prepared IPO.* tables.
2. Confirm where IPO.CRSP2 and IPO.DELIST should persist and that both are writable; preserve the source order in which CRSP2 is created, DELIST is derived from CRSP2, and later joins/returns consume them.

Validation to perform later:

- Before an authorized full run, verify the configured libref resolves to the confirmed prepared inputs and that the generated CRSP2/DELIST producer-consumer order is available.

### A_SAS_RUNTIME: Resolve the SAS runtime startup issue in a licensed environment and confirm a working SAS version compatible with the supplied source.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_ENV

Preparation / proposed procedure:

1. Use the existing TKELS startup diagnostic to resolve the SAS launch/runtime initialization issue, or move the task to a working licensed SAS environment.
2. Do not infer missing entitlement from the TKELS failure; verify that SAS can start and report its version without reading study data or executing author code.

Validation to perform later:

- Repeat a bounded runtime/version probe after setup; only then consider a separately authorized source run with the confirmed data and libref configuration.

### A_FULL_WORKFLOW: Obtain the completed data-construction source and any downstream analysis entry points required to reproduce the paper outputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_ANALYSIS
Evidence: E_CODE_END, E_INV, E_NECESSARY

Preparation / proposed procedure:

1. Ask the authors whether the supplied SAS file is intentionally data-preparation-only and request the completed 1%/99% by IPO-year winsorization step if it is omitted.
2. Request any regression/table/figure programs and a map from reported paper outputs to each entry point, required input and output.
3. Do not infer analytical code from the 224-CUSIP identifier list or from the survey instrument.

Validation to perform later:

- After the complete entry points and outputs are identified, check that every reported table/figure has an assigned program and required input before any authorized execution.

### A_UPSTREAM_STAGES: Confirm whether compatible author-prepared text, perception and WHR tables bypass the documented raw-data preparation stages; otherwise obtain the missing procedures and check the required software.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_UPSTREAM, SW_PREMIERE, SW_IMAGEJ
Evidence: E_PYTHON_STAGE, E_PREMIERE_STAGE, E_IMAGEJ_STAGE, E_INV, E_ENV

Preparation / proposed procedure:

1. Ask whether IPO.Text, IPO.Perception and IPO.WHR are already prepared author inputs that bypass the documented upstream processing.
2. If IPO.Text must be recreated, request the Python HTML-removal and word-count program, its required package/version and exact filing-section/text input rules; Python 3.12.14 is available but no author script was supplied.
3. If IPO.Perception must be recreated, request the filtered thin-slice source/clip selection, Premiere Pro high-/low-pass settings and Qualtrics/MTurk response eligibility and aggregation rules; verify Premiere Pro availability only if this stage is needed.
4. If IPO.WHR must be recreated, request the source images, image-to-PERMNO mapping, ImageJ version and measurement instructions; verify ImageJ availability only if this stage is needed.

Validation to perform later:

- After receiving author-prepared outputs or procedures, confirm the required table fields, identifiers, periods and documented transformations before deciding whether each upstream application is needed.

### A_SYNTAX: Propose a narrow closing-parenthesis correction in the first PROC SQL ON predicate.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_SYNTAX
Evidence: E_SYNTAX

**Proposed edit:** `Datasheet - Code Submit.sas:74–74`
Source SHA-256: `74e116adeed2b3e989bb6cc6890906e6d33e13d924e6724f9b341af2b1059d40`

Close the unmatched opening parenthesis in the PROC SQL join predicate.

Current text:
```
		on (a.cusip_sdc = b.cusip9 and a.name_sdc = b.issuer;
```

Proposed replacement:
```
		on (a.cusip_sdc = b.cusip9 and a.name_sdc = b.issuer);
```

Preparation / proposed procedure:

1. Apply only this proposed edit after the coordinator reviews it; no source change has been applied.

Validation to perform later:

- After an authorized patch, confirm the first PROC SQL ON clause parses with the verified SAS runtime; do not execute the full workflow until the missing data and library configuration are supplied.


## Remaining issues and prerequisites

- I_LIBREF [unresolved; full_pipeline]: No IPO LIBNAME assignment, autoexec or data/output directory configuration is supplied. The SAS source uses IPO.* tables and writes IPO.CRSP2 and IPO.DELIST through that unresolved libref, so the source inputs and persistent intermediate destinations are not bound.
- I_ANALYSIS [unresolved; full_pipeline]: The only supplied program visibly stops at a winsorization heading and contains no completed winsorization commands or downstream estimation/table-generation entry points. The final-sample CUSIPs are identifiers, not analysis data. Full paper-output workflow and any companion program mapping remain unresolved.
- I_SYNTAX [preparation; full_pipeline]: The first PROC SQL join predicate at line 74 opens a parenthesis but does not close it before the semicolon, so the supplied source has a supported narrow syntax defect.
- I_UPSTREAM [unresolved; full_pipeline]: If the missing prepared IPO.Text, IPO.Perception and IPO.WHR tables are not supplied, the documented upstream pipeline also needs Python-based EDGAR HTML removal/LM counting, Adobe Premiere Pro high-/low-pass video filtering before survey use, and ImageJ CEO-image measurements. The release supplies no such scripts, filtered clips, raw image mappings or survey responses, and it is unresolved which stages can be bypassed by prepared tables.
- I_CEO_DATE_SOURCE [unresolved; full_pipeline]: The code uses CEO_LAST_DATE to construct turnover indicators, but the datasheet does not identify whether IPO.Edgar or IPO.Roadshow supplies this field or define its date meaning.
- I_FF_MAPPING [unresolved; full_pipeline]: The official French products and history are verified, but their current raw headers, ME units versus the author shares_post scale, daily portfolio-label ordering into P00-P99, and historical vintage comparable to the authors' 2016 inputs are not established by the pages checked. The official site reports a 2025 move to CRSP CIZ and monthly reconstruction of portfolio history.
- R_LINK [undetermined]: Author IPO.Linking cross-database link table for US IPOs during 1997-2013; required fields include CUSIP_SDC, NAME_SDC, LPERMNO, PERMNO, GVKEY and CIK. Authors report manually researching and adding missing identifiers/links.
- R_SDC [undetermined]: Author IPO.SDC input containing US IPO dates and terms for 1997-2013; the SAS source uses CUSIP9, issuer, issue/filing/offer dates, shares, filing amount, offer price and midpoint.
- R_RITTER [undetermined]: Author IPO.Ritter input joined by LPERMNO, with founding year, underwriter prestige and post-IPO common shares outstanding; underwriter/shares are combined from Ritter, SDC and CRSP.
- R_COMP_PRE [undetermined]: Author IPO.Compustat pre-IPO financial input, combining quarterly values with annual fallback when needed and the specified trailing-twelve-month income-statement construction; the SAS source consumes constructed p1* fields.
- R_MARKET [undetermined]: Author IPO.Market daily Nasdaq Composite series using adjusted close for 1996-2013 and a RETD percentage-change field.
- R_EDGAR [undetermined]: Author IPO.Edgar hand-collected registration-statement characteristics keyed by PERMNO, including CEO founder/prior-public/foreign status, age and education, plus other CEO/roadshow characteristics.
- R_ROADSHOW [undetermined]: Author IPO.Roadshow hand-coded roadshow/video and CEO characteristics keyed by PERMNO (TAPED, CEO_FEMALE, SIT and LOGO); videos were collected during 2011-2013 and variables manually coded.
- R_CRSP [undetermined]: Author IPO.CRSP daily secondary-market pricing for IPO.Linking firms, 1997-2015, including fields consumed for PERMNO, DATE, PRC, RET, DLRET and DLSTCD.
- R_FF_MVE [public_acquisition_required]: Author IPO.Fama_MVE monthly market-value-of-equity decile cutoffs joined by IPO year and month; fields FFYEAR, FFMONTH and MV1-MV9 are consumed.
- R_FF_BTM [public_acquisition_required]: Author IPO.Fama_BTM annual book-to-market decile cutoffs joined by IPO year; fields YEAR and BTM1-BTM9 are consumed.
- R_FF_RET [public_acquisition_required]: Author IPO.Fama daily 10x10 portfolio return data in the wide format transposed by SAS; the benchmark code builds portfolios P00-P99 and uses daily returns over up to 2015.
- R_COMP_POST [undetermined]: Author IPO.Compustat_Post quarterly post-IPO financial input, 2011-2015, used to construct forward-looking ROA; SAS consumes GVKEY, DATADATE, ATQ and NIQ.
- R_PERCEPTION [undetermined]: Author IPO.Perception CIK-level averages for video and picture ratings of competent, attractive and trustworthy, derived from Qualtrics/MTurk survey responses.
- R_TEXT [undetermined]: Author IPO.Text PERMNO-level Loughran-McDonald CEO-tone and uncertainty counts from initial registration statements and manually transcribed roadshow presentations.
- R_WHR [undetermined]: Author IPO.WHR PERMNO-level CEO image width-to-height ratio measured using ImageJ from CEO images.
- SW_SAS [unverified]: The supplied SAS source requires a working SAS runtime. The existing bounded environment probe could not initialize TKELS; it does not establish absence of license entitlement or a missing install.
- SW_PREMIERE [unverified]: Author documentation uses Premiere Pro high-/low-pass filters to create video thin slices for the perception survey; local availability and exact filter settings are unverified. This stage may be bypassed if compatible author-prepared perception data are supplied.
- SW_IMAGEJ [unverified]: Author documentation uses ImageJ to measure CEO image width-to-height ratios; local availability, version and measurement settings are unverified. This stage may be bypassed if the author-prepared IPO.WHR table is supplied.

## Review notes

- No analysis_only scope is supported: the release contains no full author-prepared analysis dataset and no analysis entry program; the survey instrument and final-sample CUSIP list are not compatible analysis inputs.
- The SAS source identifies 15 direct IPO.* input tables. IPO.CRSP2 and IPO.DELIST are generated within the same SAS source; CRSP2 is produced before DELIST, and both are consumed later. All 17 frozen dependency IDs are reviewed.
- Official Ken French pages verify downloadable monthly ME breakpoints, annual BE/ME breakpoints and daily 100 size/book-to-market portfolios with sufficient public history. The 5-percentile breakpoint files support selecting decile cuts; units, column/portfolio labels and 2016-vintage mapping remain unresolved.
- The author documentation includes conditional Python HTML-removal/LM counts, Premiere Pro video filtering and ImageJ image measurement stages. Python is present, while Premiere Pro and ImageJ availability is unverified; prepared author tables may bypass those stages.
- The bounded SAS probes read one row from exact catalog-listed candidate files; the SEC/LM probes only stat documented roots or year directories. None of those checks establishes population, full historical coverage, license entitlement, or author-table compatibility.
- A one-line closing-parenthesis correction is proposed for the first SAS join predicate but was not applied. No author program, dataset download, software installation, or package change was performed; execution_verified remains false.
