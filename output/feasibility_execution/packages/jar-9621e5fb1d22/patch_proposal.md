# Patch proposal: jar-9621e5fb1d22

Does Consumer Protection Enhance Disclosure Credibility in Reward Crowdfunding?

DOI: 10.1111/1475-679X.12289

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow including R text preparation, SAS dataset construction, and Stata analyses.

Entry points: `CCT-Datasheet-and-Code/R/cct_jar_readfiles_r_code.r`, `CCT-Datasheet-and-Code/R/cct_jar_textual_analysis_r_code.r`, `CCT-Datasheet-and-Code/SAS/cct_jar_sas_code.sas`, `CCT-Datasheet-and-Code/STATA/cct_jar_stata_code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 5/12289 - Does-Consumer-Protection-Enhance-Disclosure-Credibility-in-Reward-Crowdfunding/cct-datasheet-and-code.zip",
      "sha256": "6683e5ea51b4e8a150c60f07f5c90c2eb53430abaff5511f18be67d9493e82e7"
    },
    {
      "path": "JAR-Volume 57/Issue 5/12289 - Does-Consumer-Protection-Enhance-Disclosure-Credibility-in-Reward-Crowdfunding/cct-online-appendix.pdf",
      "sha256": "bbfad01052dd4b5499e783c8f0bcd702ef9696d2c9cc0f046b56b728b33d0741"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "2aa173b3ba1b4e4695ccdd03d56b421eb9733ad906e3aef2d7f20c149a6ddafe"
}
```

## Proposed actions

### ACT_KICKSTARTER_RAW: Obtain the five required Kickstarter raw tabs and preserve the author’s project-link coverage and 2017 collection window. The Web Robots archive is a candidate supplement only until it matches the author fields and full historical/tab coverage.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_CAM, REQ_CRE, REQ_COM, REQ_COT, REQ_UPD
Evidence: E001, E013, E014, E015, E016, E037, E045

Preparation / proposed procedure:

1. Request or locate the author’s original CAM, CRE, COM, COT, and UPD data plus their field/schema notes and scrape date.
2. If using the documented Web Robots material, select a specific historical snapshot only after matching the required fields in each tab and checking project launches across the reported 2009–2017 period; retain the author scrape and Web Robots component provenance separately.
3. Stage the campaign, creator, community, comments, and updates sources under the selected project raw-data tree; preserve Link values and the full COT Transcript needed for fraud text analysis.

Validation to perform later:

- Confirm each required table exposes the fields used by the supplied R and SAS source and has the documented campaign/sample coverage.
- Check Link-key completeness and the comments transcript/date coverage before any metric generation; do not infer coverage from a single row count.

### ACT_SAMPLE_LINKS: Convert the supplied final-sample identifier text into the Link-only table consumed by the R fraud merge.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_SAMPLE
Evidence: E001, E004, E017, E044

Preparation / proposed procedure:

1. Skip the title line in CCT-Datasheet-and-Code/IDENTIFIERS/cct_jar_identifiers.txt and import each following URL as one Link value in the sample object required by the fraud stage.
2. Keep the source text unchanged and record the row count/hash used for the conversion; do not treat this list as a substitute for campaign, creator, community, comments, or updates data.

Validation to perform later:

- Verify the imported object exposes Link and that the R fraud merge keys match the URL text exactly.
- Check empty/duplicate identifier handling and preserve the supplied sample without comparing its count to the R campaign batch endpoint.

### ACT_CAMDATE_SOURCE: Resolve a compatible project date table for the R fraud stage and document how it is produced and transferred.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CAMDATE, ISS_CAMDATE_PRODUCER
Evidence: E003, E017, E049

Preparation / proposed procedure:

1. Provide a Link/beg_date/end_date table from the campaign source with documented date formats and coverage; the package includes campaign identifiers and SAS code that derives dates, but no camdate.RData producer.
2. Treat SAS data.cam as a candidate only after confirming the cleaned dates can be extracted into the Link/date shape consumed by R. A separately prepared compatible date table is also sufficient; author confirmation is optional when the field and coverage mapping is demonstrated.
3. Do not assume the SAS-to-R transfer or stage order until its exact procedure is documented.

Validation to perform later:

- Confirm one valid beg_date/end_date record per required Link and matching coverage for the sample and comment transcripts.
- Verify the fraud branch classifies comments relative to project end dates after a future authorized run.

### ACT_CAMPAIGN_HISTORY: Document the raw campaign coverage needed for SAS’s prior-calendar-year state aggregation while preserving its explicit missing-to-zero rule.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CAM, ISS_CAM_HISTORY
Evidence: E045, E050

Preparation / proposed procedure:

1. After obtaining the original CAM source and analysis sample bounds, record the actual begin-year range and whether source campaign rows supply the prior-year state aggregate for each included project year.
2. Preserve the SAS merge on beg_year-1 and the explicit assignment of zero when the merged ratio is missing; do not fabricate earlier observations or infer a defect from the listed sample identifiers.

Validation to perform later:

- Confirm the source year range and report which prior-year state aggregates are present for the included sample.
- Keep the authored zero fill unchanged and compare the resulting nonmissing aggregate coverage in a future authorized run.

### ACT_GSS: Obtain a compatible cumulative GSS SAS source and retain the year-selection behavior in the author’s SAS code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_GSS
Evidence: E018, E019, E038, E046, E051, E052

Preparation / proposed procedure:

1. Prefer the author-named gss7216_r1a file or an official NORC cumulative SAS release only after confirming the required id, year, region, trust, comphome, and courts fields and their meanings.
2. Record the selected release/version; ensure the history includes the survey years needed for the project’s earlier/equal-year matches and the nearest-year computer-at-home calculation.

Validation to perform later:

- Verify the required fields, survey-year coverage, region coding, and missing-value semantics against the SAS codebook expectations.
- Confirm selected trust/courts observations are no later than project begin years and computer-at-home matching follows the authored nearest-year rule.

### ACT_FX: Resolve an accessible daily Datastream currency-to-USD series or demonstrate a compatible alternative source.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_FX
Evidence: E020, E046, E048, E057

Preparation / proposed procedure:

1. Check the available Datastream route or request the author’s FX export and series/conversion notes; the catalog search miss does not establish that data or a license are absent.
2. Acquire daily currency/date/exchange_rate observations needed for non-USD campaign goals and preserve the documented USD conversion convention.
3. A different public series can be used only after its currency coverage, date coverage, units, and conversion convention are shown compatible with the author input.

Validation to perform later:

- Check required currency codes and daily date coverage for the campaign begin dates.
- Verify the SAS join selects the most recent rate dated zero to ten days before beg_date and leaves USD projects unchanged.

### ACT_GDP: Acquire the author’s BEA per-capita GDP series and preserve its stated vintage and units.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_GDP
Evidence: E021, E039, E046

Preparation / proposed procedure:

1. Locate the BEA state series matching per-capita GDP in chained 2012 dollars and the February 2019 vintage, or obtain the author’s source file.
2. Prepare the state plus v1998–v2017 wide table expected by SAS without changing the unit or revising historical values silently.

Validation to perform later:

- Verify all 50 states and the District of Columbia where present, the 1998–2017 annual fields, units, vintage, and state-name alignment.
- Confirm SAS transpose yields the expected state-year keys and project-year matches.

### ACT_COURTS: Obtain a state-year Court Statistics Project series compatible with the author’s total incoming caseload per capita measure.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_COURTS
Evidence: E022, E043, E047, E053

Preparation / proposed procedure:

1. Use the NCSC Court Statistics Project source or the author’s file; the 2017 report is a PDF candidate, not yet the required SAS table.
2. Confirm the measure sums incoming newly filed, reopened, and reactivated cases across civil, domestic relations, criminal, juvenile, and traffic cases and retains the author’s per-capita denominator.
3. Prepare state_code, year, and total_caseload_pc fields for project start-year matching, including any prior-year observations required by the code.

Validation to perform later:

- Verify 2008–2017 history (or the exact supported sample bounds), state coverage, category totals, per-capita units, and keys.
- Confirm the SAS merge uses the closest prior-or-equal survey year and preserves missing values as authored.

### ACT_CITY: Acquire and normalize the documented public U.S. city/state/county/alias file for the SAS location match.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_CITY
Evidence: E023, E041, E047

Preparation / proposed procedure:

1. Retrieve us_cities_states_counties.csv from the author-named Grammakov repository.
2. Import the CSV and map City, State short name, County, and City Alias Mixed Case to SAS city, state_short, county, and city_alias; keep the source file and license note with the run inputs.
3. Preserve the separate manual unmatched-city crosswalk stage; the city list does not resolve that separate input.

Validation to perform later:

- Verify the four mapped fields and the expected state abbreviations/county labels before SAS matching.
- Review duplicate city/state pairs and report the unmatched count after both primary and alias joins.

### ACT_CROSSWALK: Supply the missing manual county crosswalk and its matching decisions for unmatched project locations.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CROSSWALK, ISS_CROSSWALK_PRODUCER
Evidence: E024, E041

Preparation / proposed procedure:

1. Obtain the author’s city_state_nomatch_nomatch_d SAS file and any workbook/export/import instructions.
2. If the archived file is unavailable, use only the SAS-generated unmatched city/state rows and obtain a documented county decision for each; do not guess a county or drop an unmatched location.
3. Return the table under the expected SAS libref and filename with the input fields needed by the append.

Validation to perform later:

- Check every retained unmatched city/state key maps to one documented county and that the crosswalk has no unintended duplicate keys.
- Record remaining unmatched locations and confirm the SAS append preserves all source rows.

### ACT_BORDER: Resolve how the official Census adjacency product becomes the author’s three-field border table.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_BORDER, ISS_BORDER_SCHEMA
Evidence: E025, E042, E047

Preparation / proposed procedure:

1. Obtain the author’s border_county_data file or its exact derivation from the 2010 Census adjacency file.
2. Confirm the meaning and construction of C1, C2, and C3/border_id, including county/state name mapping; do not infer a border indicator from the four raw Census fields without the author’s rule.
3. After the mapping is documented, prepare the SAS input table with the exact fields and text normalization expected by the join.

Validation to perform later:

- Verify state/county keys and border_id values against the documented adjacency definition.
- Check county matches before and after the border join and preserve all campaign rows.

### ACT_FDIC: Obtain the two author-specific bank report families independently and verify each field contract before SAS aggregation.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_FDIC1, REQ_FDIC2
Evidence: E026, E027, E028, E029, E040, E047

Preparation / proposed procedure:

1. Obtain the first SDI_download_data family plus numbered files 1–33 with fed_rssd, repdte, stalp, asset, dep, rbct1j, and the loan variables consumed by SAS.
2. Obtain the distinct second family plus numbered files 1–34 with fed_rssd, repdte, cbsa_metro, and numemp.
3. Use FFIEC/FDIC products only after the exact author family, report date coverage, and column mappings are confirmed; preserve the two inputs separately and do not assume one family replaces the other.
4. Ensure reports span the project dates plus the code’s absolute 365-day bank-report window; approximately 2008–2018 follows from the reported 2009–2017 launches, subject to the exact campaign sample bounds.

Validation to perform later:

- Check required columns, bank RSSD/report-date keys, quarterly dates, and the numbered file partitions for both families.
- Confirm the SAS join selects the nearest report within 365 days and reproduces the separate state/metro aggregates without silently changing the bank population.

### ACT_R_PACKAGES: Prepare the eight R package dependencies in the R library used for the future batch run.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_RPKG_QUANTEDA, SW_RPKG_STRINGR, SW_RPKG_DPLYR, SW_RPKG_TIDYR, SW_RPKG_SENTIMENTANALYSIS, SW_RPKG_QUESTIONR, SW_RPKG_READABILITY, SW_RPKG_PLYR
Evidence: E031, E032, E033, E036

Preparation / proposed procedure:

1. Confirm compatible package versions for R 4.5.0, then install or expose quanteda, stringr, dplyr, tidyr, SentimentAnalysis, questionr, readability, and plyr in the target R library.
2. Keep the author’s embedded legalese/novel regular-expression dictionaries unchanged; they are not external package/model artifacts.

Validation to perform later:

- In the actual batch environment, verify each package is discoverable with the intended R library paths and record the resolved versions.
- Confirm the two R scripts’ library calls resolve before any author script or study data is run.

### ACT_STATTRANSFER: Verify an available Stat/Transfer version and its supported R/SAS/Stata formats before any cross-language conversion.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_STATTRANSFER
Evidence: E001

Preparation / proposed procedure:

1. Locate the authorized Stat/Transfer installation and record its version, interface, and supported RData, SAS, and Stata formats.
2. Follow the documented input/output mapping resolved under ISS_R_SAS_HANDOFF; do not guess an RData object or output-table name.
3. If no compatible installation is available, obtain the author’s transfer settings or a permitted equivalent conversion specification.

Validation to perform later:

- Run only a metadata-level format/column check after a separately authorized data preparation, confirming Link and all SAS/Stata-required columns survive each transfer.
- Confirm final dset_final.sas7bdat maps to STATA/data/dset_final.dta.

### ACT_SAS_RUNTIME: Resolve the SAS TKELS startup initialization before future SAS execution.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E034, E058

Preparation / proposed procedure:

1. Use the existing host SAS batch interface and the documented -nodms -work [redacted-path-8047db61e466] -autoexec operator SAS autoexec flags for a runtime-only startup check.
2. If TKELS initialization still fails, resolve that environment issue before invoking the supplied SAS program; do not retry the author source during this assessment.

Validation to perform later:

- Confirm the SAS process starts and the configured WORK and project libraries are writable before a future authorized batch run.

### ACT_STATA_ADDONS: Make each invoked Stata add-on visible after the driver’s project-local PLUS reset.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2, SW_LOGIT2, SW_REGHDFE, SW_FTOOLS, SW_OUTREG2
Evidence: E008, E009, E030, E034, E035

Preparation / proposed procedure:

1. Stage compatible versions of winsor2, logit2, reghdfe, ftools, and outreg2 under the prepared STATA/ado/plus tree or document a consistent authorized adopath setup that survives the script configuration.
2. Keep Stata 18 and the specified estimators; do not replace missing commands with different estimators.

Validation to perform later:

- Before any author run, confirm `which winsor2`, `which logit2`, `which reghdfe`, `which ftools`, and `which outreg2` resolve after the do-file’s PLUS path is applied.
- Record add-on versions and verify reghdfe can find its ftools dependency.

### ACT_PATH_ROOT: Prepare one coherent host-visible relative project tree and map each existing program path to it.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_PATH_ROOT
Evidence: E002, E008, E010, E058

Preparation / proposed procedure:

1. Create a single relative project root named project_kickstarter with r/raw_data, r/data, SAS/raw_data, SAS/data, STATA/data, STATA/ado/plus, STATA/log, and STATA/empirical_analysis_output subdirectories.
2. Coordinate the hard-coded path references in both R programs, the SAS `%let path`, and the Stata `local path` to this same tree; keep producer and consumer directories aligned.
3. Run host batch commands from the mapped project working directory and use relative or [redacted-path-c86a2477fb8b] paths only, as documented.

Validation to perform later:

- Resolve each code path against the chosen root without executing the source and confirm all outputs land in the matching consumer directories.
- Check root visibility and write access in the host batch environment before future author execution.

### ACT_RUN_PROCEDURE: Respect the actual partial order between R fraud, possible SAS-derived dates, SAS final construction, the final Stat/Transfer handoff, and Stata.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS_PATH_ROOT, ISS_CAMDATE_PRODUCER, ISS_R_SAS_HANDOFF, ISS_CROSSWALK_PRODUCER, ISS_BORDER_SCHEMA
Evidence: E001, E008, E011, E058

Preparation / proposed procedure:

1. Use a separately prepared compatible camdate Link/beg_date/end_date table if one is documented; with that route, the two supplied R entry points can run on the original raw inputs before SAS final construction.
2. If camdate is to come from SAS-cleaned campaign dates, that date-producing cleaning stage must precede the R fraud branch, and SAS merge/final construction must wait until the fraud output is converted into raw_data.fraud. The supplied SAS driver calls clean, merge, and prepare sequentially and provides no documented stop/export/restart mechanism; obtain a supported stage-separation/extraction procedure before using this route. Do not invent macro calls or a runner.
3. Keep the original CAM fields Text/RiskAndChallenges available for SAS cleaning and the original COT Transcript available to R fraud; retain the separate R metric outputs and map each to its expected SAS raw_data table.
4. After the date and table handoffs are resolved, prepare all SAS raw inputs and the manual crosswalk/border tables, then run the supplied complete SAS program through the existing host batch interface with -nodms -work [redacted-path-8047db61e466] -autoexec operator SAS autoexec.
5. Convert the generated SAS/data/dset_final.sas7bdat to STATA/data/dset_final.dta with the documented Stat/Transfer interface.
6. From the prepared STATA directory, use the existing host batch command `stata -b do cct_jar_stata_code.do`; retain the author tables and logs.

Validation to perform later:

- Before each stage, confirm its exact input path and fields are supplied by a linked route or producer; no stage runs until the camdate and R-to-SAS contracts are resolved.
- After a separately authorized future run, verify SAS/Stata outputs, key variables and Link joins, and Stata tables/logs; this proposal is not execution evidence.

### ACT_R_SAS_HANDOFF: Resolve the exact raw-table and R-metric transfer contracts before the SAS macros consume their separate raw_data inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_R_SAS_HANDOFF
Evidence: E001, E002, E013, E014, E017, E054, E055

Preparation / proposed procedure:

1. Obtain the author’s mapping from the original CAM/CRE/COM/COT/UPD RData objects and the reduced *NEW objects to each SAS raw_data file; identify which source retains fields needed by each consumer.
2. Confirm the table/file/column mappings for every R metric output, especially R fraud.RData to SAS raw_data.fraud.sas7bdat, and specify Link and all required metric fields.
3. Specify Stat/Transfer import/export settings, output paths, and stage order so the CAM Text/RiskAndChallenges and COT Transcript fields remain available where used.

Validation to perform later:

- Compare the prepared SAS raw_data schemas to actual SAS set/keep/join statements and the R-generated output variables before a future author run.
- Confirm each required SAS table has the expected Link key and no source fields needed for later stages were removed.


## Remaining issues and prerequisites

- ISS_CAMDATE_PRODUCER [unresolved; full_pipeline]: The R fraud branch loads camdate.RData containing Link/beg_date/end_date, but neither supplied R program produces it. SAS cleaning does derive beg_date/end_date from CAM fundingperiod and endedon fields, but no SAS-to-R export or interleaving is specified.
- ISS_R_SAS_HANDOFF [unresolved; full_pipeline]: The R preparation program saves reduced CAMNEW/CRENEW/COMNEW/COTNEW/UPDNEW RData, while SAS reads separate raw_data SAS tables. CAMNEW drops Text/RiskAndChallenges that SAS cleaning uses; COTNEW drops Transcript required by R fraud. The datasheet names Stat/Transfer generically but does not map original versus reduced inputs, output names/paths, column preservation, or the exact metric-to-SAS table contracts.
- ISS_CROSSWALK_PRODUCER [unresolved; full_pipeline]: SAS expects raw_data.city_state_nomatch_nomatch_d after programmatic matching. The source comments say unmatched rows are exported for manual matching, but the crosswalk file, field schema, matching decisions, and return/import procedure are not supplied.
- ISS_BORDER_SCHEMA [unresolved; full_pipeline]: The official Census adjacency file has four named fields, while SAS reads a separate three-field C1/C2/C3 table and treats C3 as border_id. The derivation, state-name mapping, and border_id semantics are not supplied.
- ISS_PATH_ROOT [preparation; full_pipeline]: The supplied R, SAS, and Stata code use hard-coded [redacted-path-0aa1c7d5614f] paths, while the documented host batch workflow supports relative or [redacted-path-c86a2477fb8b] paths. A coordinated host-visible project tree must preserve the existing R raw_data/data, SAS raw_data/data, and Stata data/ado/log/output roles.
- ISS_CAM_HISTORY [unresolved; full_pipeline]: SAS creates a prior-calendar-year state pledge ratio from beg_year-1 and explicitly sets a missing resulting ratio to zero. The datasheet reports campaign coverage of 2009–2017, but the exact analysis-sample lower bound and available pre-sample campaign history cannot be quantified without the raw input. Preserve the source zero fill and do not infer a sample defect from the identifier count or R batch bound.
- REQ_CAM [undetermined]: Kickstarter campaign-tab raw data for the author scrape; R text analysis requires Link/Text/RiskAndChallenges and SAS cleaning requires campaign dates, location, funding, status, category, and backer fields. Author reports projects launched 2009–2017, scraped July–September 2017.
- REQ_CRE [undetermined]: Kickstarter creator-tab raw data joined by Link; SAS derives creator state/country, foreign status, Facebook count, biography lengths, projects backed/created, last login, and author/name fields.
- REQ_COM [undetermined]: Kickstarter community-tab raw data joined by Link; SAS uses new and returning backer counts.
- REQ_COT [undetermined]: Kickstarter comments-tab raw data joined by Link; R fraud analysis needs the full comment Transcript and SAS uses comment and reply counts/lengths.
- REQ_UPD [undetermined]: Kickstarter updates-tab raw data joined by Link; SAS uses launched date and project-of-the-day fields.
- REQ_CAMDATE [undetermined]: Date table consumed by the R fraud branch, keyed by Link and containing beg_date and end_date; it determines each project’s pre/post comments.
- REQ_GSS [undetermined]: NORC General Social Survey cumulative cross-sectional file; SAS uses id, year, region, trust, comphome, and courts to derive region-year measures matched to project start years.
- REQ_FX [undetermined]: Daily currency exchange rates to USD from Datastream; SAS needs date, currency, and exchange_rate for non-USD project goal currencies.
- REQ_GDP [undetermined]: BEA state GDP per capita, chained 2012 dollars; SAS expects one state row with annual columns v1998 through v2017.
- REQ_COURTS [undetermined]: National Center for State Courts Court Statistics Project total incoming caseload per capita by state and year; SAS expects state_code, year, total_caseload_pc.
- REQ_CITY [public_acquisition_required]: U.S. city/state/county lookup used to map project location cities to counties, including city aliases.
- REQ_CROSSWALK [undetermined]: Manual county assignments for city/state pairs still unmatched after city and alias joins; SAS requires raw_data.city_state_nomatch_nomatch_d.
- REQ_BORDER [undetermined]: Census county adjacency-derived border classification joined by state and county; SAS expects raw_data.border_county_data fields C1/C2/C3, then county_name/state_name/border_id.
- REQ_FDIC1 [undetermined]: First bank call-report family (SDI_download_data plus numbered files 1–33) used for state/report-date bank assets, deposits, capital, and loan-composition measures.
- REQ_FDIC2 [undetermined]: Second, distinct bank data family (SDI_download_data plus numbered files 1–34), joined to the first by bank RSSD id and report date to supply CBSA metro and employee count.
- SW_RPKG_QUANTEDA [preparation_required]: The supplied R code calls library(quanteda). The vanilla installed-package metadata probe found it absent from the checked default library paths; no namespace or study data was loaded and the author does not pin a release.
- SW_RPKG_STRINGR [preparation_required]: The supplied R code calls library(stringr). The vanilla installed-package metadata probe found it absent from the checked default library paths; no namespace or study data was loaded and the author does not pin a release.
- SW_RPKG_DPLYR [preparation_required]: The supplied R code calls library(dplyr). The vanilla installed-package metadata probe found it absent from the checked default library paths; no namespace or study data was loaded and the author does not pin a release.
- SW_RPKG_TIDYR [preparation_required]: The supplied R code calls library(tidyr). The vanilla installed-package metadata probe found it absent from the checked default library paths; no namespace or study data was loaded and the author does not pin a release.
- SW_RPKG_SENTIMENTANALYSIS [preparation_required]: The supplied R code calls library(SentimentAnalysis). The vanilla installed-package metadata probe found it absent from the checked default library paths; no namespace or study data was loaded and the author does not pin a release.
- SW_RPKG_QUESTIONR [preparation_required]: The supplied R code calls library(questionr). The vanilla installed-package metadata probe found it absent from the checked default library paths; no namespace or study data was loaded and the author does not pin a release.
- SW_RPKG_READABILITY [preparation_required]: The supplied R code calls library(readability). The vanilla installed-package metadata probe found it absent from the checked default library paths; no namespace or study data was loaded and the author does not pin a release.
- SW_RPKG_PLYR [preparation_required]: The supplied R code calls library(plyr). The vanilla installed-package metadata probe found it absent from the checked default library paths; no namespace or study data was loaded and the author does not pin a release.
- SW_STATTRANSFER [unverified]: The datasheet prescribes Stat/Transfer for raw/project/R-output to SAS conversions and the final SAS-to-Stata conversion; version and executable availability are unverified.
- SW_SAS [unverified]: SAS 9.4 TS1M8 executable path is present, but the assigned startup probe failed during TKELS initialization. Runtime availability is unverified, not confirmed absent.
- SW_WINSOR2 [preparation_required]: Invoked by the Stata driver; not found in checked adopaths, and the driver resets PLUS to the package-local STATA/ado/plus directory.
- SW_LOGIT2 [preparation_required]: Invoked by the Stata driver; not found in checked adopaths, including the bounded software probe; the package-local PLUS directory is not included.
- SW_REGHDFE [preparation_required]: Available in the host default PLUS directory, but the driver resets PLUS to a package-local directory not included in the package; availability after that reset is not established.
- SW_FTOOLS [preparation_required]: Required dependency of the available host reghdfe release; it resides in the host default PLUS directory that the driver replaces with a package-local directory.
- SW_OUTREG2 [preparation_required]: Invoked by the Stata driver and not found in the checked default/shared adopaths; the package-local PLUS directory is not included.

## Review notes

- Checkpoint: the datasheet names four stages—R project-file preparation/text analysis, Stat/Transfer conversion into SAS, three SAS macros that clean/merge/build dset_final.sas7bdat, then Stat/Transfer conversion to dset_final.dta and the Stata driver. The assessed full-pipeline entry points are the two supplied R programs, the supplied SAS program, and the supplied Stata do-file.
- The R fraud section additionally consumes camdate.RData and sample.RData with no producer found among the supplied code. Its derived fraud.RData has no documented automatic conversion to the SAS raw_data.fraud table. SAS also consumes distinct SAS files for every R-derived metric; actual conversion, paths, and column mapping remain to be reconciled.
- The identifier TXT is a 255,018-line final-sample link list, while the R program processes CAM in batches through row 332,364. The identifier file is not the raw campaign/comments/creator/community/updates inputs or the final analysis dataset; the count difference alone does not show a sample error.
- The appendix describes additional empirical analyses (FTC complaints/backer-comment aggregates, project-size partitions, additional robustness, and treatment-effect stability) without corresponding programs in this package. Keep these as context; assess all branches actually supplied in the two R files, SAS program, and Stata main-analysis driver.
- Source and package contents have not been executed or deserialized. Continue local resource, software, route, path, and all-97 dependency review before finalization.
- Coverage note: all 97 frozen dependency IDs are mapped below. D0001–D0007 are original RData inputs; D0010–D0018 are separate SAS raw inputs. Do not assume the R readfiles outputs alone are valid SAS inputs: CAMNEW drops Text/RiskAndChallenges that SAS uses, while COTNEW drops Transcript used by R fraud.
- Temporal coverage note: SAS uses GSS and court observations from years less than or equal to project begin year (nearest prior year for several series), uses a 0–10 day pre-begin FX match, uses bank reports within 365 days before or after project begin, and uses a prior-calendar-year state pledge aggregate. The broad campaign description says 2009–2017, but exact analysis filters/history bounds are unresolved; 2008 may be needed for the earliest prior-year state aggregate. The source’s R batch endpoint 332,364 and the identifier text’s 255,018 lines do not establish a sample defect.
- Input interpretation note: the NCLC UDAP state treatment coding is embedded in the supplied SAS source; no separate NCLC table is read by these programs. Embedded legalese/novel dictionaries are code literals, not missing external model artifacts. The supplied appendix has additional analyses without matching code; they remain contextual because the selected scope is the provided R/SAS/Stata workflow.
