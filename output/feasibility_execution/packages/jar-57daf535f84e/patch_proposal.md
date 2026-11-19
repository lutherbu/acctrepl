# Patch proposal: jar-57daf535f84e

Limits to Political Capture: Evidence from Patent Grants, Disclosures, and Litigation

DOI: 10.1111/1475-679X.12607

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full CMZ_Code.do pipeline: raw-data construction, joins, master-panel creation, descriptive tables and regression results. No analysis-only route is supported by the supplied inventory.

Entry points: `CMZ_Code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 4/12607 - Limits-to-Political-Capture-Evidence-from-Patent-Grants-Disclosures-and-Litigation/cmz-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "fe11f8ff341f582de54b8a10e3b78ddac9a07e95acc7169ee96b0ec6d596a8e7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "106988fa116a2a31a4635c2fd083676989b6c931d7223d3c89197b967d2d2d3f"
}
```

## Proposed actions

### A_PATVIEW_RAW: Acquire the required PatentsView table products and prepare the files named by the do-file.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_PG_PUBLISHED_APP, R_PG_CROSSWALK, R_PG_APPLICANTS, R_PG_INVENTORS, R_PG_LOCATIONS, R_CITATIONS, R_PATENT_APPROVAL
Evidence: E_PATVIEW, E_PATVIEW_TABLES, E_CODE_PG_APP, E_CODE_PG_CROSSWALK, E_CODE_APPLICANTS, E_CODE_LOCATIONS, E_CODE_CITATIONS, E_CODE_PATENT_DATE

Preparation / proposed procedure:

1. Use the official PatentsView download catalog and its table mapping to obtain the listed pre-grant, granted-patent, citation and g_patent products.
2. Keep the release date and source filenames; convert/rename only where the do-file expects TSV or DTA names.
3. Retain required application/grant identifiers and date columns, and preserve the code’s 2023 citation-date cap.

Validation to perform later:

- Run bounded metadata checks on each downloaded source for its required columns and actual year coverage.
- After complete inputs are present, run the author pipeline and check the generated Raw_Application, patent citation, approval-date and applicant-location intermediates.

### A_PATEX: Obtain the PatEx/Public PAIR application_data and transactions DTA releases that match the author’s 2023 snapshot.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_PATEX_APPLICATION, R_PATEX_TRANSACTIONS
Evidence: E_PATEX, E_CODE_PATEX_APP, E_CODE_TRANSACTIONS, E_DOC_SOURCES_1

Preparation / proposed procedure:

1. Select a USPTO PatEx release whose schema matches the author’s expected application, examiner and transaction fields; do not assume the 2022 release is byte/schema-identical to the author’s 2023 files.
2. Prepare DTA files under application_data.dta and transactions.dta in the project data directory.
3. Resolve the transaction application/mail key names against the selected release before running the construction stage.

Validation to perform later:

- Inspect each DTA header with a bounded metadata reader and confirm application number, examiner/class, event-code, record and mailing-date fields.
- Confirm required filing-period coverage before constructing examiner and duration measures.

### A_OFFICE_ACTIONS: Acquire the official 2017 office_actions DTA file and confirm the code’s expected schema.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_OFFICE_ACTIONS
Evidence: E_OFFICE_ACTION, E_CODE_OFFICE_ACTIONS

Preparation / proposed procedure:

1. Use the USPTO Office Action Research Dataset 2017 DTA product.
2. Place the file as office_actions.dta beside the do-file inputs.

Validation to perform later:

- Check app_id, mail_dt, header_missing and fp_missing with bounded metadata.
- Confirm data for the analysis application years are covered by the 2008–mid-2017 release.

### A_LITIGATION: Acquire the 2020 USPTO litigation patents DTA product used by the code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_LITIGATION
Evidence: E_LITIGATION, E_CODE_LITIGATION

Preparation / proposed procedure:

1. Use the 2020 patents DTA file, not an unrelated cases table.
2. Place it as patents.dta in the project data directory.

Validation to perform later:

- Check case_row_id and patent identifiers with bounded metadata.
- Confirm the 1963–2020 coverage is adequate for the analysis period before building patents_litigation.dta.

### A_KPSS_VERSION: Resolve the exact KPSS_2022 vintage used by the code before choosing a current repository release.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_KPSS
Evidence: E_KPSS, E_CODE_KPSS, E_CODE_KPSS_MERGE

Preparation / proposed procedure:

1. Obtain the author-compatible 2022 patent valuation file or have the authors confirm a supported alternative.
2. Do not substitute the repository’s 2025 re-estimated values without an explicit version decision.
3. Prepare the patent-number key and xi_nominal field expected by the merge.

Validation to perform later:

- Check the selected file’s version, patent-number field, xi_nominal units and year coverage with bounded metadata.
- Confirm merge uniqueness on patent number before running the master build.

### A_ZIP_DISTRICT_HISTORY: Obtain a ZIP-to-congressional-district crosswalk compatible with the study’s historical Congress-year joins.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ZIP_DISTRICT
Evidence: E_ZIP_DISTRICT, E_CODE_ZIP_DISTRICT, E_CODE_HOUSE

Preparation / proposed procedure:

1. Confirm whether the authors’ 2021 crosswalk version remains available and which Congress years it covers.
2. If using a current repository release, establish historical district assignments rather than applying 118th-Congress boundaries retrospectively.
3. Prepare zip district github.dta with the code’s ZIP, state and cd keys.

Validation to perform later:

- Check ZIP/state/cd fields and year/congress coverage before joining committee members to cities.
- Confirm the single-district-state cd=0 normalization remains applicable to the chosen version.

### A_MIT_COMMITTEE_DATA: Obtain and verify the three distinct House/Senate committee workbooks used by seniority and turnover stages.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MIT_HOUSE, R_MIT_SENATE, R_MIT_HOUSE_TURNOVER
Evidence: E_MIT, E_CODE_HOUSE, E_CODE_SENATE, E_CODE_HOUSE_TURNOVER, E_CODE_SENATE_TURNOVER

Preparation / proposed procedure:

1. Retrieve the House data.xls, Senate data.xls and separate House data.xlsx products from the author-linked data source or obtain the compatible author copies.
2. Confirm committee codes, member identifiers, seniority, district/state fields and sheet names separately for each workbook.
3. Confirm congressional coverage against congress-year.dta and the study period; observe the page’s academic-use condition.

Validation to perform later:

- Inspect workbook sheets and headers without refreshing or modifying files.
- Verify each workbook’s required Congress-year range and join keys before building seniority and turnover intermediates.

### A_HUD_CROSSWALK: Confirm a compatible ZIP-to-city/state crosswalk and its current access method.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HUD_ZIP_CITY
Evidence: E_HUD, E_CODE_HOUSE

Preparation / proposed procedure:

1. Compare the author’s August 2023 zip city.dta with the HUD product documented on its current page.
2. Confirm the selected crosswalk provides the city/state fields required by the House and turnover joins; obtain permitted account/API access only if needed.
3. Do not treat an API landing page as proof of the old DTA schema.

Validation to perform later:

- Check ZIP/city/state fields, crosswalk version and coverage before merging committee data.

### A_STATE_OP: Acquire or obtain the author-compatible Garcia–Norli state operations file.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_STATE_OP
Evidence: E_GARCIA, E_CODE_STATE_OP

Preparation / proposed procedure:

1. Use the author page’s geographic-dispersion data product or obtain the processed gvkey state op.dta used by the paper.
2. Prepare the gvkey, statename, year and state_op fields; retain the 1994–2008 limitation and identify any later-year coverage separately.

Validation to perform later:

- Check join-key uniqueness and year/state coverage before merging into the firm-state panel.

### A_WRDS_PRODUCTS: Resolve the WRDS-derived linking and firm-factor files using the catalog candidates and exact code contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CRSP_GVKEY_LINK, R_COMP_FIRM_FACTORS, R_CIK_GVKEY
Evidence: E_DOC_SOURCES_1, E_DOC_SOURCES_2, E_CODE_FIRM_LINK, E_CODE_CIK_LINK, E_CODE_FIRM_FACTORS, E_COMP_FUNDA, E_CRSP_LINK

Preparation / proposed procedure:

1. Use the existing one-row COMP.FUNDA and CRSP.CCMXPF_LNKHIST probes only as candidates; they do not establish period coverage or all expected columns.
2. Confirm the author’s gvkey permno link.dta fields, including usable company/ticker identifiers and link dates, and produce the firm factor.dta GVKEY-year panel.
3. Obtain gvkey-cik.dta with the source/coname mapping used to resolve duplicate CIK-GVKEY matches.
4. Confirm current institutional access or request the exact exports; the catalog results do not establish license/access status.

Validation to perform later:

- Inspect exact fields, keys, dates and required study-year coverage in each exported file with bounded metadata.
- Check link-date joins and GVKEY-year/CIK-key uniqueness before the master build.

### A_STATE10K_HANDOFF: Obtain the active state_10Kall.csv input and its compatible producer/output contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATE10K, I_INPUT_CLOSURE
Evidence: E_CODE_STATE10K, E_CODE_CIK_LINK, E_SEC_ROOT, E_DOC_SOURCES_2

Preparation / proposed procedure:

1. Request the exact CSV consumed by CMZ_Code.do or the active producer and its run instructions, including the state-column layout and source/period.
2. Treat the local SEC corpus roots only as uninspected source-document candidates; do not infer that they contain the author’s processed CSV.
3. Keep the block-commented WRDS example separate unless the authors confirm it produces a required current input.

Validation to perform later:

- Check CIK, accession, form, filing-date/report-date and reshapeable state-count columns.
- Confirm state counts, filing years and CIK-GVKEY linkage before generating gvkey-state-year shares.

### A_FOG_AND_SCOPE: Resolve the active annual scored/scope products and their upstream scoring/model pipeline.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PG_CLAIMS_FOG, R_G_CLAIMS_FOG, R_PG_DESC_FOG, R_PG_CLAIMS_SCOPE, R_G_CLAIMS_SCOPE, I_INPUT_CLOSURE
Evidence: E_CODE_FOG_READERS, E_CODE_SCOPE_READERS, E_CODE_FOG_MERGES, E_DOC_SOURCES_2

Preparation / proposed procedure:

1. Obtain all author-prepared scored and scope DTA files required for 2004–2020, or the exact active producer code for each file family.
2. Request each product’s keys, score/count fields, file version and missing-year behavior.
3. If scoring requires a model, dictionary, package or other model resource, identify its exact name/version and permitted source; do not infer a resource from the output filenames.
4. Keep raw PatentsView claim/description downloads as upstream leads until the producer contract confirms how they create these DTA products.

Validation to perform later:

- Check each annual file’s identifiers, score/scope fields and year coverage with bounded metadata.
- Confirm the scope aggregation keys, duplicate handling and output schema before merging the summaries into CMZ master.dta.

### A_SOFTWARE_SETUP: Prepare the missing Stata add-ons invoked by the do-file.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_MATCHIT, S_WINSOR2, S_OUTREG2
Evidence: E_MATCHIT, E_ENV, E_CODE_FIRM_LINK, E_CODE_MASTER

Preparation / proposed procedure:

1. Install/configure matchit, winsor2 and outreg2 in the Stata 18 user environment from trusted package sources.
2. Record exact installed command versions and verify that Stata resolves each command.
3. Confirm the author-intended reghdfe release; the installed reghdfe 6.12.3 and ftools 2.49.1 are available, but the author version is unspecified.

Validation to perform later:

- Re-run the frozen software availability helper for matchit, winsor2 and outreg2 after setup.
- Before interpreting regression output, compare reghdfe version and cluster-SE behavior with the intended author release.

### A_WORKING_DIRECTORY: Configure the target Stata working directory so the active relative inputs resolve, including the Python output imported by the full program.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_WORKING_DIRECTORY
Evidence: E_CODE_PATH, E_CODE_STATE10K

Preparation / proposed procedure:

1. Set the active current-directory command at CMZ_Code.do line 2 to the target project directory.
2. Stage the generated state_10Kall.csv and other required relative inputs in the configured directory before the import at line 826.
3. Keep the source's commented directory alternatives inactive unless they are deliberately selected for the target environment.

Validation to perform later:

- Before a future run, confirm the intended Stata working directory resolves the required relative input names, beginning with state_10Kall.csv at line 826.
- Do not start the author program until all unresolved data, preparation, software and access prerequisites are resolved.

### A_CONDITIONAL_NATIVE_RUN: After every remaining data, preparation, coverage, access and software gap is resolved, execute the complete author program in its native top-to-bottom order. This is conditional future guidance; no author execution is claimed.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_INPUT_CLOSURE, I_WORKING_DIRECTORY
Evidence: E_CODE_PATH, E_CODE_STATE10K, E_CODE_FIRM_FACTORS, E_CODE_LINK_CONSUMER, E_CODE_MASTER

Preparation / proposed procedure:

1. Resolve every outstanding full-pipeline data and software requirement, including actual producers, preparation/selection, exact annual coverage and required model versions; keep the five annual score/scope families separate.
2. Generate and stage the Python-produced state_10Kall.csv before starting the Stata program; the active import is at CMZ_Code.do line 826.
3. Configure the target working directory using the active source command at line 2 and ensure all relative inputs resolve there.
4. Only after those prerequisites are closed, run the original CMZ_Code.do from its beginning through its final master output in its authored top-to-bottom order; do not skip, cherry-pick or reorder stages.

Validation to perform later:

- Before invocation, verify each required raw and prepared product and software input separately, including the state10K producer/coverage and the company/ticker-enriched link product.
- Run only the full native program after the unresolved prerequisites and issues are closed, then confirm the expected master output is produced.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: The full-pipeline closure remains unresolved. Local SAS metadata confirms raw COMP.FUNDA fields and CCM link keys/dates, but not the prepared firm factor.dta, fyear-to-year mapping/selection, company/ticker-enriched gvkey permno link.dta, or complete historical coverage. The active program imports Python-produced state_10Kall.csv; its producer and coverage remain unresolved. The five annual score/scope product families and all other already listed data dependencies retain their separate unresolved status.
- I_WORKING_DIRECTORY [preparation; full_pipeline]: The active first command changes the working directory, while the program later imports state_10Kall.csv by relative filename. A target-specific working-directory configuration and staged relative inputs are required before any future run.
- R_PG_PUBLISHED_APP [public_acquisition_required]: PatentsView pg_published_application.tsv is the upstream application history; the do-file filters publication kinds, keeps unique applications and produces Raw_Application.dta, which then feeds applicant and patent linkage.
- R_PG_CROSSWALK [public_acquisition_required]: PatentsView pg_granted_pgpubs_crosswalk.tsv links application publication identifiers to current granted patent IDs before applicant and patent information is combined.
- R_PG_APPLICANTS [public_acquisition_required]: The raw PatentsView applicant table supplies disambiguation-free application names and applicant sequence used to create applicants.dta and names_not_disambig.dta.
- R_PG_INVENTORS [public_acquisition_required]: The raw PatentsView inventor table supplies inventor names and sequence that are appended with applicants into names_not_disambig.dta.
- R_PG_LOCATIONS [public_acquisition_required]: PatentsView applicant-location records supply raw city/state fields used to create locations_not_disambig.dta and applicant_locations.dta, which feed application_applicant_info_temp.dta.
- R_CITATIONS [public_acquisition_required]: Granted-patent citation table g_us_patent_citation.tsv is transformed by patent and citation date into patent citation.dta, capped at 2023.
- R_PATEX_APPLICATION [undetermined]: application_data.dta supplies application number, examiner name/art unit and USPC class/subclass for examiners_class.dta and later examiner-year regressors.
- R_PATEX_TRANSACTIONS [undetermined]: transactions.dta is used to create first-action dates, meeting.dta and compressed_transactions.dta, later merged by application number.
- R_OFFICE_ACTIONS [public_acquisition_required]: office_actions.dta supplies app_id, mail_dt, header_missing and fp_missing inputs used to create missing-form flags.
- R_LITIGATION [public_acquisition_required]: The 2020 USPTO patents.dta litigation file supplies case_row_id and patent identifiers for patents_litigation.dta and the litigation outcome.
- R_PATENT_APPROVAL [public_acquisition_required]: PatentsView granted patent table g_patent supplies patent_id and patent_date used to derive approvaldate.dta.
- R_KPSS [undetermined]: KPSS_2022.dta supplies patent-level innovation value xi_nominal after matching patent_number; the code derives market value from this product.
- R_ZIP_DISTRICT [undetermined]: zip district github.dta provides ZIP/state/congressional-district mapping for House committee seniority and turnover constructions; single-member district codes are normalized to 1.
- R_MIT_HOUSE [undetermined]: House data.xls supplies committee 156 membership, seniority, Congress, district and state data for city-level House judiciary seniority.
- R_MIT_SENATE [undetermined]: Senate data.xls supplies committee 358 membership and tenure information for the Senate seniority and turnover constructions.
- R_MIT_HOUSE_TURNOVER [undetermined]: House data.xlsx is a separate input to the state/city turnover construction; it is not the same workbook role as House data.xls.
- R_HUD_ZIP_CITY [undetermined]: zip city.dta provides the ZIP-to-city/state crosswalk used in the House committee and turnover joins.
- R_STATE10K [undetermined]: state_10Kall.csv is an active input to the state-by-CIK filing stage; the importer expects CIK/accession/form/file/report-date fields and reshapeable state-count columns.
- R_CIK_GVKEY [undetermined]: gvkey-cik.dta links the active CIK/state-filing records to GVKEY and includes source/coname fields used to resolve duplicate firm links.
- R_STATE_OP [undetermined]: gvkey state op.dta supplies Garcia-Norli firm/state/year operations as a supplement when the 10-K-derived state share is missing.
- R_COMP_FIRM_FACTORS [undetermined]: Raw COMP.FUNDA is a compatible source component: its one-row SAS metadata capture confirms gvkey, fyear, datadate, at, prcc_f, prcc_c, csho and ceq. The active Stata consumer instead merges the separately prepared firm factor.dta by gvkey/year, computes size from at, falls back from prcc_f to prcc_c, and computes market-to-book from csho, prcc_f and ceq. The raw fields are supported; fyear-to-year mapping, selection/preparation of firm factor.dta, observation coverage and the full study-year range remain unresolved.
- R_CRSP_GVKEY_LINK [undetermined]: Raw CRSP CCMXPF_LNKHIST metadata confirms the GVKEY/PERMNO link keys, link dates and link attributes listed in its route. The consumer joins applicant-company observations by LPERMNO and checks filing dates against link validity dates. A separate prepared gvkey permno link.dta product also needs the company/ticker fields used for disambiguation; that preparation, field coverage and full history are not established by the one-row raw capture.
- R_PG_CLAIMS_FOG [undetermined]: Annual 2004–2020 pg_claims_*_with_fog_scores.dta files are consumed to construct application-claim word and readability measures; exact producer, score field and model/software version are unresolved.
- R_G_CLAIMS_FOG [undetermined]: Annual 2004–2020 g_claims_*_with_fog_scores.dta files are consumed to construct granted-patent claim measures; exact producer, score field and model/software version are unresolved.
- R_PG_DESC_FOG [undetermined]: Annual 2004–2020 pg_detail_desc_text_*_with_fog_scores.dta files are consumed to construct application description readability measures; exact producer, score field and model/software version are unresolved.
- R_PG_CLAIMS_SCOPE [undetermined]: Annual pg_claims_*_scope.dta inputs for 2004–2020 are consumed to calculate independent application-claim scope and counts.
- R_G_CLAIMS_SCOPE [undetermined]: Annual g_claims_*_scope.dta inputs for 2004–2020 are consumed to calculate independent granted-patent claim scope.
- S_MATCHIT [preparation_required]: The do-file invokes matchit for applicant/company-name matching; Stata 18 software helper returned which code 111.
- S_WINSOR2 [preparation_required]: The do-file invokes winsor2 for the market-to-book winsorization; the original environment probe reports it unavailable.
- S_OUTREG2 [preparation_required]: The do-file invokes outreg2 to write regression result files; the original environment probe reports it unavailable.

## Review notes

- Only the full_pipeline scope is supported: the supplied Stata do-file includes preparation and result generation, while the package inventory contains no full analysis panel or independent analysis entry point.
- CMZ identifiers.dta is described in the datasheet as a unique-company CUSIP list; its bounded one-row probe exposes only application_number and does not establish a compatible panel or history.
- Code source excerpts were taken only from the coordinator-approved safe view, using exact one-based source lines outside 701–822, 936–1158 and 1200–1300. Producer status inside those excluded ranges remains unresolved; no excerpt or process artifact from those ranges is credited.
- The documented institutional WRDS subscriptions are not evidence of a current access barrier. Local one-row catalog probes are candidates only and do not establish population, year coverage or a compatible author export.
- No author program, model, import, compile, parser, statistical or descriptive trial was run; no package/source files were changed, no dataset was downloaded and execution_verified remains false.
- Earlier source-screen and path-listing incident records remain process-only and are not used as scientific evidence.
