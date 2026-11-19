# Patch proposal: jar-829e66fdd476

Common Investor Relations Representation

DOI: 10.1111/1475-679X.12619

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete supplied Python construction pipeline, its separate source-measure handoffs required by downstream consumers, and all five Stata analysis/table drivers.

Entry points: `python/run_all.py`, `stata/main_panel.do`, `stata/textual_analysis.do`, `stata/economic_characteristics.do`, `stata/dissipation.do`, `stata/determinants.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 3/12619 - Common-Investor-Relations-Representation/volant-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "e312c330c8a29db0788b442062361147edc5559c253f910a8b13f51d65f6464d"
    },
    {
      "path": "JAR-Volume 63/Issue 3/12619 - Common-Investor-Relations-Representation/volant-online-appendix.pdf",
      "sha256": "35b6466c80bb47764030140b86ea1e88e41883e1107f58134bffd709f59be952"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "d92b3fff979f5a7a2753016cbd69d9d3d20e0d913907ed23cb33e6c80c4c4742"
}
```

## Proposed actions

### ACT_STAGE_LOCAL_PRODUCTS: Stage the locally readable source products in their distinct author-configured Parquet inputs using ordinary format, path and case normalization.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_COMP, REQ_COMP_QUARTERLY, REQ_CRSP, REQ_CRSP_MONTHLY, REQ_CRSP_DSI, REQ_CRSP_STOCKNAMES, REQ_IBES, REQ_IBES_INTL, REQ_IBES_GUIDANCE, REQ_SEC_FILINGS, REQ_ITEMS8K, REQ_IBES_CRSP_LINK, REQ_CRSP_COMP_LINK
Evidence: E_CONFIG_WRDS_PRODUCTS, E_CONFIG_AUTHOR_DATAFILES, P_COMP_FUNDA, P_COMP_FUNDQ, P_CRSP_DSF, P_CRSP_MSF, P_CRSP_DSI, P_CRSP_DSENAMES, P_IBES_EPSUS, P_IBES_EPSINT, P_IBES_GUIDANCE, P_IBCRSPHIST, P_WRDSSEC_EXHIBITS, P_WRDSSEC_ITEMS8K, P_CRSP_CCMXPF

Preparation / proposed procedure:

1. Use the readable COMP.FUNDA and COMP.FUNDQ products separately for the annual and quarterly configured files; keep COMP_ADJ separate until its formula and dated SIC rule are confirmed.
2. Stage CRSP.DSF, CRSP.MSF, CRSP.DSI, and CRSP.DSENAMES as separate daily, monthly, calendar, and time-valid name-history inputs; preserve PERMNO/date keys and effective-date bounds.
3. Stage I/B/E/S DET_EPSUS, DET_EPSINT, and DET_GUIDANCE separately, with WRDSAPPS.IBCRSPHIST as the dated ticker/PERMNO link.
4. Stage WRDSSEC.EXHIBITS and WRDSSEC.ITEMS8K as distinct filing metadata and item tables, and stage CRSP.CCMXPF_LINKTABLE separately for its date-valid GVKEY/PERMNO link.
5. Map local products to the configured Parquet names in python/config.py and preserve the author pipeline's independent table contracts.

Validation to perform later:

- After authorized staging, compare each Parquet schema to its cited source fields and the exact columns read by its author stage.
- Check required sample dates, effective-date keys and lookback history during later preparation; the one-row probes establish fields/readability, not population or vintage.

### ACT_ACQUIRE_SEC_RELEASES: Acquire the required 8-K earnings-announcement exhibits from the documented public EDGAR filing/document route and stage the resulting text corpus.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_PRESS_RELEASES
Evidence: E_SEC_PUBLIC_ACCESS, E_SEC_PUBLIC_TEXT, E002, E_S00_INPUTS

Preparation / proposed procedure:

1. Acquire the in-scope public 8-K submissions and submitted exhibit documents through SEC EDGAR's documented public filing paths; retain CIK, filing date, form and source-document identity.
2. Apply the author-specified earnings-announcement/exhibit selection and text extraction, then stage the raw corpus under the configured press_release_exhibits path.
3. Keep the SEC text corpus separate from WRDSSEC filing metadata and from the unresolved EIGHTK_META file-path map.

Validation to perform later:

- Check the staged document keys and text-file paths against the author corpus/file-location contract and the sample period before running s00.
- Confirm the selected exhibits and filing coverage for the intended sample; a public route does not itself establish the author corpus's exact coverage or cleaning.

### ACT_ACQUIRE_TNIC: Acquire the authors' current annual TNIC pairwise similarity product and stage its two separately configured branch files.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_TNIC
Evidence: E_TNIC_PUBLIC_PAIR, E_TNIC_PUBLIC_COVERAGE, E_S05C_TNIC, E_S08D_TNIC

Preparation / proposed procedure:

1. Acquire the annual pairwise TNIC score product from the official Hoberg-Phillips Data Library after the required data access is available.
2. Normalize its pair identifiers, year and continuous score to the supplied main and dissipation consumers, and save separate configured copies at TNIC_SCORE_MAIN and TNIC_SCORE_DISSI.
3. Preserve the author sample and current source vintage; do not substitute a different TNIC/Doc2Vec series.

Validation to perform later:

- Confirm the downloaded product is the annual pairwise similarity series and compare its fields, pair/year keys and sample-year coverage with both author stages.
- Record any source-vintage differences for the study's sample years before the full pipeline run.

### ACT_CONFIRM_COMP_ADJ: Obtain the author's COMP_ADJ prepared file or its exact calculation and dated SIC merge rule before constructing this panel from the readable Compustat base tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMP_ADJ
Evidence: E_CONFIG_AUTHOR_DATAFILES, E_S02C_COMP_ADJ, P_COMP_FUNDA, P_COMP_FUNDQ

Preparation / proposed procedure:

1. Confirm the meaning and unit of MVEQ, its quarter-date calculation, the SIC source/as-of date, and how duplicate firm-quarter links are resolved.
2. If the prepared file is available, stage it as configured; otherwise use only the confirmed rule with the separately identified FUNDA/FUNDQ inputs.

Validation to perform later:

- Check the final gvkey/datadate/MVEQ/sich schema and author sample dates without changing the documented measure definition.

### ACT_CONFIRM_QUARTERLY_LINK: Obtain the author-prepared QUARTERLY_LINKFILE or its exact dated join and duplicate-link selection rule.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_QUARTERLY_LINKFILE
Evidence: E_CONFIG_AUTHOR_DATAFILES, E_S02A_LINKS_AND_FORMS, P_COMP_FUNDQ, P_WRDSSEC_WCIKLINK, P_CRSP_CCMXPF, P_CRSP_DSENAMES, P_IBCRSPHIST

Preparation / proposed procedure:

1. Specify how quarterly datadate maps to CIK/GVKEY/PERMNO/CUSIP/ticker, including effective dates and primary-link filters.
2. Use the individually verified local product ingredients only under that rule; do not infer a row selection from filenames or database family.

Validation to perform later:

- Check the prepared map's six required fields, unique firm-quarter keys, date validity and retained study-period coverage.

### ACT_CONFIRM_EIGHTK_META: Obtain the EIGHTK_META prepared file or a reviewable producer specification for its filing-to-corpus path and identifier mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_EIGHTK_META
Evidence: E_CONFIG_AUTHOR_DATAFILES, E_S00_INPUTS, E_S01_IR_AND_METADATA, E_SOURCE_MEASURES_HELPERS, P_WRDSSEC_EXHIBITS, P_WRDSSEC_ITEMS8K, P_WRDSSEC_WCIKLINK, P_CRSP_CCMXPF

Preparation / proposed procedure:

1. Specify how OUTFILE_LOCATION and FILE_LOCATION correspond to the raw SEC exhibit text and how CIK/FDATE are linked to GVKEY/LPERMNO.
2. Check that any proposed WRDSSEC link query uses fields present in the selected date-valid link product and supports the required CIK/FDATE-to-GVKEY/PERMNO mapping.
3. Do not infer a complete producer from the manual helper's presence while its connection/download blocks remain masked.

Validation to perform later:

- Check the resulting metadata field names, document paths, identifier dates and one-to-one/multiple-link policy before s00/s01.

### ACT_AUTHOR_IR_FILES: Obtain the two fixed author-specific inputs and their source vintage; neither is included in the package inventory.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IR_CODE_KEY, REQ_DISS_TEXT_TERMS
Evidence: E_CONFIG_IR_INPUTS, E_S00_INPUTS, E_S01_IR_AND_METADATA, E_SOURCE_MEASURES_HELPERS

Preparation / proposed procedure:

1. Supply IR_CODE_KEY_28OCT2021.xlsx with its original domain-to-firm assignments and DISS_TEXT_TERMS_14OCT2021.txt with the original term list.
2. Keep the two inputs separate and stage them at the configured paths; do not substitute a newly inferred key or generic term vocabulary.

Validation to perform later:

- Check that the workbook and term-list paths resolve and that the s01/s00 readers receive their expected columns and encoding.

### ACT_CONFIRM_TFN_S34: Confirm that the documented TFN.S34 13F source is readable and covers the study's required report dates in the authorized project environment.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_13F
Evidence: E_CATALOG_TFN_S34, E_S03B_NAMES_AND_13F

Preparation / proposed procedure:

1. Use the existing local catalog candidate and author field contract to confirm product access and period during authorized preparation; keep the earlier timeout as an unverified read limit.

Validation to perform later:

- After access is confirmed, verify mgrno/cusip/rdate/fdate and the full required date range; do not infer availability from the catalog alone.

### ACT_CONFIRM_RAVENPACK_PRODUCTS: Identify the distinct RavenPack mapping and Dow Jones story products, their delivery paths and the author-specific prepared schema.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_RAVENPACK, REQ_RAVENPACK_STORIES
Evidence: E_CONFIG_WRDS_PRODUCTS, E_S09_RPA_MAPPINGS, E_S09_RPA_STORIES, E_CATALOG_RPA

Preparation / proposed procedure:

1. Confirm a time-valid entity mapping product with the required identifier/type/value/range fields.
2. Separately confirm a story product with entity/date/news-type/story-ID/year fields and the required press-release/article selection.
3. Do not use the RavenPack category codebook as a substitute for either row-level product.

Validation to perform later:

- Check distinct source contracts, permitted access, study-period coverage and exact keys before producing s09_rpa inputs.

### ACT_CONFIRM_RUSSELL_MEMBERSHIP: Obtain the historical Russell 2000 PERMNO/year membership panel or confirm a documented mapping from the local Datastream constituent identifiers to CRSP PERMNO.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_RUSSELL
Evidence: E_S05A_RUSSELL, P_RUSSELL_CANDIDATE, E_CATALOG_RUSSELL, E_RUSSELL_HISTORY, E_RUSSELL_RECONSTITUTION

Preparation / proposed procedure:

1. Confirm how constituent codes and validity dates map to PERMNO and annual membership, including additions and removals.
2. Preserve membership history and the author's sample years; do not substitute a current factsheet or current-constituent list.

Validation to perform later:

- Check PERMNO/year output keys and sample-period constituent changes against the documented Russell membership source.

### ACT_CONFIRM_MERGER_MAP: Obtain the author-prepared MA_MERGERS panel or its deal-selection, firm-role, GVKEY-link and fiscal-year construction rule.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_MERGER
Evidence: E_S05B_MERGER, E_S09B_MERGER, P_SDC_DETAILS, P_SDC_EVENTS, E_CATALOG_SDC

Preparation / proposed procedure:

1. Specify included SDC deal status/type, whether target/acquiror or both firms are flagged, and how announcement/event dates map to GVKEY and Compustat fiscal year.
2. Use the local SDC details/events products only as candidates for the confirmed construction; do not infer GVKEY/FYEAR from names alone.

Validation to perform later:

- Check the prepared gvkey/fyear keys, deal-period coverage and role-specific output against the supplied merger stage.

### ACT_CONFIRM_INSTOWN_AGG: Obtain the author-prepared INSTIT_OWN panel or its exact ownership aggregation and block-owner definition.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_INSTIT_OWN
Evidence: E_S09A_MSF_AND_INSTOWN, E_S09B_INSTOWN, P_OWNHOLD

Preparation / proposed procedure:

1. Define how CUSIP/report-date holdings yield INSTOWN_PERC and distinct NUMINSTOWNERS, and state the threshold and owner-type rules for NUMINSTBLOCKOWNERS.
2. Keep this aggregation separate from the Thomson Reuters TFN.S34 13F manager holdings table.

Validation to perform later:

- Check the three prepared aggregate fields, report-date and CUSIP keys, time windows and the code's four-quarter ownership averaging rule.

### ACT_CONFIRM_COSINE_HANDOFF: Confirm the text-helper pair-file/corpus handoff and the masked text-cleaning transformation before relying on its output in s07_text.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COSINE_FILES, REQ_COSINE_RESULTS, ISS_TEXT_SIMILARITY_REVIEW
Evidence: E_SIM_DOC_OUTSIDE_PIPELINE, E_SIM_DOC_GENERATOR, E_SIM_CODE_CONTRACT, E_SIM_CODE_STAGE4, E_S07_COSINE, E_SCREEN_REPORT_V2

Preparation / proposed procedure:

1. Supply or identify COSINE_SIM_FILES.csv and its exact firm-pair/year/filename key producer, plus the compatible raw press-release corpus expected by stages 1–3.
2. Confirm the text-cleaning behavior in masked lines 165–168 through an allowed, reviewable specification; do not expose or infer any hidden connection/configuration text.
3. After inputs and software/data resources are prepared, run the supplied separate helper stages to create COSINE_SIM_results.csv for the configured s07_text path.

Validation to perform later:

- Check that the generated CSV contains the keys and binary/count similarity fields consumed by s07_text and covers its expected firm-quarter sample.
- Compare the helper's documented corpus selection and cleaning with the author output contract before accepting the result as compatible.

### ACT_SETUP_TEXT_SOFTWARE: Prepare the text-helper packages and NLTK corpus resources in the authorized Python environment before any separately authorized helper run.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_CHARDET, SW_CONTRACTIONS, SW_NLTK_DATA
Evidence: E_SIM_SOFTWARE_IMPORTS_A, E_SIM_SOFTWARE_IMPORTS_B, P_PY_PACKAGES

Preparation / proposed procedure:

1. Install chardet and contractions in the project Python environment using the environment owner's approved package process.
2. Make punkt, stopwords and wordnet available in the configured local NLTK data directory without invoking the author helper during this assessment.
3. Keep the already available pandas, numpy, nltk, BeautifulSoup and scikit-learn environment versions recorded.

Validation to perform later:

- Check distribution metadata for chardet/contractions and verify the NLTK resource paths with a bounded metadata-only check before any author helper execution.

### ACT_SETUP_WINSOR2: Install the required winsor2 Stata add-on in the authorized Stata environment before running the determinants driver.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2
Evidence: E_STATA_WINSOR2, P_WINSOR2, E_STATA_DETERMINANTS_INPUT

Preparation / proposed procedure:

1. Use the environment owner's approved Stata add-on setup process; no installation or command execution was performed in this assessment.

Validation to perform later:

- Run a future exact which winsor2 metadata check and confirm the determinants do-file can resolve the command.

### ACT_CLOSE_REMAINING_INPUTS: Resolve each separately listed unverified author input/producer contract and link its confirmed source or prepared file to the corresponding requirement before attempting the full run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_REVIEW_INCOMPLETE
Evidence: E_CONFIG_AUTHOR_DATAFILES, E_CONFIG_WRDS_PRODUCTS, E_S07_COSINE, E_S09_RPA_MAPPINGS, E_S09_RPA_STORIES

Preparation / proposed procedure:

1. Resolve COMP_ADJ, QUARTERLY_LINKFILE and EIGHTK_META construction; obtain the fixed IR key and term list; confirm 13F, RavenPack and Russell products; specify merger and institutional-ownership definitions; and complete the text-helper handoff.
2. Keep the separate local, public and unverified routes distinct when updating the readiness record.

Validation to perform later:

- After inputs are confirmed, check that every mandatory requirement has a supported route and all frozen dependency IDs remain covered exactly once.

### ACT_RUN_SUPPLIED_WORKFLOW: After input, software and text-helper prerequisites are satisfied, run the supplied Python sequence and then every supplied Stata analysis/table driver.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS_REVIEW_INCOMPLETE
Evidence: E001, E006, E_S10_PANEL_NAMES, E_S10_EXPORT_LOOP, E_STATA_DETERMINANTS_INPUT, E_STATA_DISSIPATION_INPUT, E_STATA_ECON_INPUT, E_STATA_MAIN_INPUT, E_STATA_TEXT_INPUT

Preparation / proposed procedure:

1. Set the package root and configured data paths, then run python/run_all.py from the package's python directory so its authored construction-step order produces the five analysis panels and five Stata-ready datasets.
2. After s10_export_dta.py writes all five named DTA files, run determinants.do, dissipation.do, economic_characteristics.do, main_panel.do and textual_analysis.do with the supplied PACKAGE_DIR configuration.
3. Preserve separate input/output locations and retain the authored sample, transformations and analysis branches.

Validation to perform later:

- Before the run, confirm each configured source path, required software and unresolved data-action item is cleared.
- After the run, check that each named DTA output exists and that every Stata driver reads its corresponding file; this assessment did not execute the author programs.


## Remaining issues and prerequisites

- ISS_REVIEW_INCOMPLETE [unresolved; full_pipeline]: The full-pipeline dependency list is now dispositioned, but author-specific inputs and several producer/field contracts remain unresolved. Separate requirements and actions cover the adjusted Compustat panel, date-valid composite link maps, 8-K file metadata, curated IR key/terms, 13F read verification, institutional-ownership aggregation, RavenPack products, Russell membership mapping, merger GVKEY/fiscal-year mapping, and text-similarity input/output handoff. Execution remains unverified.
- ISS_TEXT_SIMILARITY_REVIEW [unresolved; full_pipeline]: The separate text-similarity helper is present, but its text-cleaning code at lines 165–168 is withheld from display. The exact transformation for the required cosine output therefore cannot be fully compared with the downstream input contract. This is a review limit, not evidence of absent code or inaccessible data.
- REQ_PRESS_RELEASES [public_acquisition_required]: 8-K earnings-announcement exhibit text corpus used for external-IR identification and text-similarity inputs.
- REQ_13F [undetermined]: Thomson Reuters 13-F manager holdings used to build common ownership measures.
- REQ_TNIC [public_acquisition_required]: Annual Hoberg-Phillips TNIC pairwise product-similarity scores used in the main and dissipation branches.
- REQ_RAVENPACK [undetermined]: RavenPack entity-to-firm mapping table used to attach press-release/story entities to the seed firms.
- REQ_RUSSELL [undetermined]: Russell 2000 historical membership panel required as a PERMNO/year prepared file.
- REQ_MERGER [undetermined]: SDC merger/acquisition firm-year panel required by the merger treatment construction.
- REQ_COMP_ADJ [undetermined]: Author-configured adjusted Compustat quarter file with gvkey, datadate, quarterly market value and SIC fields.
- REQ_RAVENPACK_STORIES [undetermined]: RavenPack Dow Jones Press Release/article story rows used for firm-level news and press-release counts.
- REQ_QUARTERLY_LINKFILE [undetermined]: Author-configured quarter-level crosswalk containing GVKEY, CIK, datadate, PERMNO, CUSIP and ticker.
- REQ_EIGHTK_META [undetermined]: Author-configured 8-K metadata/file-location map containing output and corpus paths plus CIK/GVKEY/PERMNO/date identifiers.
- REQ_IR_CODE_KEY [undetermined]: Hand-curated IR domain-to-firm Excel key named by the active pipeline configuration.
- REQ_DISS_TEXT_TERMS [undetermined]: Fixed IR/disclosure term list used by the active press-release parser and separate manual helper.
- REQ_INSTIT_OWN [undetermined]: Author-prepared institutional ownership panel with CUSIP/report-date ownership percentages and distinct owner/block-owner counts.
- REQ_COSINE_FILES [undetermined]: Firm-pair/release filename list consumed by the separate text-similarity helper.
- REQ_COSINE_RESULTS [undetermined]: Cosine-similarity CSV consumed by the main text-analysis construction stage.
- SW_WINSOR2 [preparation_required]: The exact Stata command lookup is unsuccessful in the registered environment; the determinants script calls winsor2 without a guard.
- SW_CHARDET [preparation_required]: The separate text-similarity helper imports chardet to detect corpus-file encodings; its distribution metadata is absent.
- SW_CONTRACTIONS [preparation_required]: The separate text-similarity helper imports contractions during text cleanup; its distribution metadata is absent.
- SW_NLTK_DATA [unverified]: The separate helper calls nltk.download for these resources during import, but their local presence was not checked and no download or import was run.

## Review notes

- Final metadata assessment for this package uses only the supplied code, screened source views, frozen catalog, registered probes and the named official/author static documentation. No author program, source-measure helper, model, statistical routine, dataset payload, installation or credential validity check was executed.
- Source screening is preserved in probes/screened_sources.json (SHA-256 d210cfc171864b25267e95d18fda5636152a50501bf7901b4ad5b7f4cb700b5d) and probes/screened_sources_v2.json (SHA-256 2464d91aa0ed088e1ed6edc0033cf51f5f477286b0ea84b36fdfb831bc95c851); the unchanged helpers are probes/screen_sources.py (02d6f7f101464882e7452d19d6a73fa2dd4e19cfe6fceeca8b89fb47c5472ba0) and probes/screen_sources_v2.py (80cea24703b54672668bc81cca3b96986cad50f9a54befd9c6e991fe622e1154). Known masked blocks remain: download_8k_filings.py lines 1–28, 34, 64–67, 78–79, 83–85, 101–107; disclosure_text_similarity.py line 38 and lines 165–168.
- The 18 successful bounded local metadata leaves are cited individually by exact artifact path/hash and bound to original helper probes/probe_local_candidates.py SHA-256 3ecd6b02140be4ce198ae62eae0e63672022ac8b545ecef90929192d5c9dd2f7 and original manifest SHA-256 8c149e2c99c3c9245ec5f0ab588bee1f408360e3d5afe1e3cf5e75007d95c07a. These one-row reads establish readability and observed columns only, not population, full historical coverage or original-vintage identity.
- TFN.S34's bounded read timed out; probes/local_candidates/tfn_s34.json (SHA-256 4a4764c4e588d172019ac609d0caa1896df6bb59bf5dfc34bc628c8ed053a18a) is unreferenced process history and is not interpreted as missing data or denied access.
- The local metadata batch's outer wrapper status capture is incorrect: probes/local_probe_capture_note.json (SHA-256 64cd48d05d178bd1c1bc42ce81b51f58b3835b92c1618a3afff353c4441f194f) records that actual child return status is null/uncaptured. The preserved probes/local_probe_batch.returncode.txt hash is 5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9 and is not used as child status. The failed source-evidence invocation and exact capture limits are documented in probes/source_evidence_expanded_capture_failure.json (SHA-256 9488109ca7b90e2f048ad50352ee73059344a11a6955c7db2ff6632e74b0f219); its later successful saved extraction supplies the cited source records.
- After the existing source-evidence expansion was saved, an additional targeted source request and reader were saved as probes/source_evidence_request_additions.json and probes/extract_source_evidence_additions.py but were never executed or used; no output from that unused request was created.
- The original registered environment probe remains at probes/environment.json (SHA-256 52959efae1466c6707313ccb7b9cce434882f91442b0e9c3ae6684b8a7182f00). Its safe viewer projection was not treated as independent software proof. No raw execution logs or raw probe diagnostics were displayed. Catalog misses and read timeouts are not treated as proof of unavailable data or access.
