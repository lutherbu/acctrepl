# Patch proposal: jar-060b20d42b1c

Tax Policy Expectations and Investment

DOI: 10.1111/1475-679X.12577

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied Stata workflow from data preparation through the main paper and online-appendix outputs, retaining all source preparation, producer stages, and both Appendix A.5 variants.

Entry points: `code/0_data_preparation.do`, `code/1_data_merge.do`, `code/2_rank_variables.do`, `code/3_data_for_regression.do`, `code/4_paper_figures_and_tables.do`, `code/5_online_appendix_figures_and_tables.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 1/12577 - Tax-Policy-Expectations-and-Investment/ghjz-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "1a971e7155bd935ab65649769a3a2f24bb3645d0fd3805291165c6b608eca1a6"
    },
    {
      "path": "JAR-Volume 63/Issue 1/12577 - Tax-Policy-Expectations-and-Investment/ghjz-online-appendix.pdf",
      "sha256": "4d3e69db8895970e74c86a30de4b30c0c52b72d233e7c0f7404985c99622c8a5"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "85d964cfc5c6368cec749bfb2ce69a2521e0fb3caa7dcfcef69faf8a99aa6ab0"
}
```

## Proposed actions

### A_AUTHOR_INPUTS: Resolve each named author input to its exact prepared file or a documented compatible route, and confirm the fields, join keys, periods, workbook sheets, and construction required by the supplied code. Keep joint datasets separate and do not independently rebuild missing author inputs.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: D_TAX_SENT, D_POLRISK, D_REDEPLOY, D_WRDS_SUBS, D_MANUAL_SUBS, D_SEC_97_05, D_SEC_06_18, D_SEC_19, D_SEC_CROSSWALK, D_FUNDAMENTALS, D_TOBINQ, D_GUO, D_GVKEY_TICKER, D_AMADEUS_PANELS, D_SIC_FULL, D_SIC_NAICS_PARTS, D_IDS_MAP, D_QUARTERLY_FUNDAMENTALS, D_TAXFOOTNOTE_SCORES, D_MDA_SCORES, D_CATEGORICAL_EPU, D_GNP, D_COMPUSTAT_QTR_2020, D_UNION_STATE, D_COMPUSTAT_ANN_2020, D_FUNDAMENTALS_SEP, D_AQC_COMPUSTAT, D_DEFERRED_TAX, D_ADDITIONAL_COMPUSTAT, D_ADDITIONAL_TAX, D_INCOME_TAX_NOTE, D_HISTORICAL_SEGMENT, D_BEA_INDUSTRY_CODES, D_ORBIS_GVKEY, D_FIRM_AGE, D_CEO_OPTIMISM, D_STATE_EMPLOYMENT, D_TOPIC_RISK, D_OFFSHORING_ALL, D_OFFSHORING_COVERAGE, D_TPS_BIGRAMS, D_TPU_BIGRAMS, D_CONFERENCE_CALL_IDS, D_BEA_CAPEX_2014, D_BEA_CAPEX_2015, D_BEA_CAPEX_2016_2019, D_BEA_SALES_2014, D_BEA_SALES_2015, D_BEA_SALES_2016_2019, D_BEA_ASSETS_2014, D_BEA_ASSETS_2015, D_BEA_ASSETS_2016_2019, D_BEA_EMPLOYMENT_2014, D_BEA_EMPLOYMENT_2015, D_BEA_EMPLOYMENT_2016_2019, D_BEA_TOTAL_2014, D_BEA_TOTAL_2015, D_BEA_TOTAL_2016_2019, I_DATA_CLOSURE
Evidence: E_PACKAGE_INVENTORY, E0_TAX_SENT, E0_WRDS_SUBS_READ, E0_MANUAL_SUBS_READ, E1_QTR_FUND, E3_FUND_SEP, E3_BEA_CODES, E5_OFFSHORING_ALL, E5_TPS_BIGRAMS, E_COMMON_CATALOG_290, E_COMMON_SAS_PROBE_290, E_SEC_CROSSWALK_PROBE_290, E_BEA_PUBLIC_290, E_LM10X_PUBLIC_290, E_SEC_PUBLIC_290

Preparation / proposed procedure:

1. Resolve each author-named input in the intended runtime tree or obtain its documented author-prepared counterpart.
2. For observed common-source candidates, confirm complete consumed fields, key and date semantics, source period, and any known conversion before using them; retain unresolved history and author-specific construction as explicit gaps.
3. Preserve code 0 through code 3 producer stages before main outputs, and keep the 2014–2019 BEA source workbooks as separate required inputs.

Validation to perform later:

- After a separately authorized run, verify the imported fields and join keys for each exact source and confirm generated intermediates appear at their authored paths.

### A_STATA_EXTENSIONS: Prepare the Stata extensions not found by the exact which checks and retain the separately unavailable outreg2/winsor2 setup; preserve the commands already located in Stata 18.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_STATA, SW_REGHDFE, SW_FTOOLS, SW_OUTREG2, SW_WINSOR2, SW_FRAMEAPPEND, SW_GCOLLAPSE, SW_GDUPLICATES, SW_RANGESTAT, SW_WINSOR, SW_ASROL, SW_EBALANCE, SW_ANYTHINGTODATE, SW_EGEN_XTILE, I_SOFTWARE_CLOSURE
Evidence: E_README_STATA, E_ENVIRONMENT, E0_MANUAL_SUBS_READ, E1_EPU_SOURCE, E4_T3_SAVE, E5_FUND_SEP, E_STATA_WHICH_290, E_STATA_RAW_WHICH_290

Preparation / proposed procedure:

1. Use the author-stated Stata 18 environment and install or configure outreg2 and winsor2 only in an authorized execution environment.
2. The metadata check found rangestat, winsor, ebalance, and the _gxtile provider; prepare frameappend, gcollapse, gduplicates, asrol, and anythingtodate, and separately prepare outreg2/winsor2.
3. After setup, confirm the exact providers with version/which-only checks. Treat _gxtile as the provider entrypoint for egen xtile(); do not call the extensions as part of this metadata assessment.

Validation to perform later:

- Before any separately authorized source run, confirm the exact Stata version and command-location metadata for each required extension.

### A_VARIANT_ORDER: Follow the source-level producer-consumer order through the main paper and online appendix, and keep both Appendix A.5 data variants as separate passes from the unchanged upstream regression intermediate.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I_VARIANT_BRANCH
Evidence: E_README_ORDER, E_README_FOUR_BEFORE_FIVE, E5_NOSIZE_CALL, E5_NOFYR_CALL, EVAR_SHARED_UPSTREAM, EVAR_NOFYR_OUTPUT, EVAR_NOSIZE_OUTPUT

Preparation / proposed procedure:

1. Run code 0, code 1, code 2, and code 3 in order, retaining each named upstream producer.
2. Within code 4 and code 5, follow the marked sections and source-level producer-consumer edges. Create the Table 3, Table 4, Table 5, Table 7, quarterly, and BEA intermediates before later figures or appendix sections that consume them; complete the main paper program before starting the online appendix.
3. At Appendix A.5, run the supplied no-size-limit and no-fiscal-year-limit variants in separate passes from the unchanged regression-quarterly intermediate, retaining their distinct investment-test outputs.

Validation to perform later:

- Before a separately authorized run, confirm the working directory supports the authored relative paths and that each variant output is distinct from the main baseline output.


## Remaining issues and prerequisites

- I_DATA_CLOSURE [unresolved; full_pipeline]: The registered inventory does not include the named author inputs. Bounded checks found readable common candidates for annual/quarterly Compustat fields, segment fields, a subsidiary relationship table, dated CRSP security links, and a CIK–GVKEY link; these remain unverified for full period, definitions, and author construction. BEA metadata identifies a relevant annual product family but not the imported workbooks or code mapping. SEC/LM metadata covers filing identifiers but not the registrant address columns consumed by the author SEC pipeline. Owner-product catalog terms returned no selected record, which is not evidence of absence or entitlement. No complete local substitute is verified for all 58 logical inputs; this is not a license or access-barrier finding.
- I_SOFTWARE_CLOSURE [preparation; full_pipeline]: The fixed typed environment projection records Stata 18 and reports outreg2/winsor2 unavailable. The version/which-only check found rangestat, winsor, ebalance, and the _gxtile provider; frameappend, gcollapse, gduplicates, asrol, and anythingtodate were not found in the checked ado path. Resolve these ordinary Stata add-on preparation needs before a source run. No author source or command body was executed.
- I_VARIANT_BRANCH [preparation; full_pipeline]: Appendix Table A.5 calls both supplied data variants and reads separate outputs. Preserve the original upstream regression intermediate and execute each variant in its own pass before consuming its output.
- D_TAX_SENT [undetermined]: Author input PSentimentT_tax_updated.csv for firm/date tax-reform risk and sentiment.
- D_POLRISK [undetermined]: Author quarterly earnings-call political-risk panel UpdatedRaw_2020q2.dta, including transcript, firm, and quarter fields aggregated by the supplied code.
- D_REDEPLOY [undetermined]: Author redeployability workbook, Firm-years sheet, used to form the 2014 intermediate.
- D_WRDS_SUBS [undetermined]: Author subsidiary table subsidiary_200901_202201.dta, used for firm/report-date country, subsidiary, and Delaware counts.
- D_MANUAL_SUBS [undetermined]: Numbered author workbooks under missing_subsidiaries used for the Exhibit 21 supplement; retain the exact authored file-number ranges and A-E column mapping.
- D_SEC_97_05 [undetermined]: SEC filing panel partition Edgar_10KQ_97_05.dta, appended into the firm/year filing panel.
- D_SEC_06_18 [undetermined]: SEC filing panel partition Edgar_10KQ_06_18.dta, required alongside the other authored year partitions.
- D_SEC_19 [undetermined]: SEC filing panel partition Edgar_10KQ_19.dta, required alongside the other authored year partitions.
- D_SEC_CROSSWALK [undetermined]: SEC issuer/Compustat link file Edgar_comp_name_Apr2020.dta used in a CIK join and filing-date validity filter.
- D_FUNDAMENTALS [undetermined]: Author annual fundamentals file firm_fundamental_Apr.dta used to attach assets, net income, and domestic-firm status.
- D_TOBINQ [undetermined]: Author quarterly fundamentals file tobinsq.dta used to derive Tobin's Q at 2017Q3.
- D_GUO [undetermined]: Amadeus Global Ultimate Owner CSV used to build owner and share variables.
- D_GVKEY_TICKER [undetermined]: Ticker-to-gvkey crosswalk joined to Amadeus global-owner records.
- D_AMADEUS_PANELS [undetermined]: Joint set of Amadeus raw yearly panels 13 through 19, iterated and matched to the owner mapping.
- D_SIC_FULL [undetermined]: Amadeus full SIC panel reduced to an idnr and primary-SIC mapping.
- D_SIC_NAICS_PARTS [undetermined]: Joint set of numbered SIC-NAICS source parts 1 through 101, appended before linking to ids.dta.
- D_IDS_MAP [undetermined]: Identifier mapping ids.dta used to link the SIC-NAICS input to author identifiers; its producer is not yet traced.
- D_QUARTERLY_FUNDAMENTALS [undetermined]: Author quarterly Compustat fundamentals file used for quarterly investment and risk panels.
- D_TAXFOOTNOTE_SCORES [undetermined]: Author tax-footnote uncertainty and sentiment score file used by the main and variant regressions.
- D_MDA_SCORES [undetermined]: Author MD&A uncertainty and sentiment score file used by the main and variant regressions.
- D_CATEGORICAL_EPU [undetermined]: Author categorical EPU workbook, Indices sheet, used to form rolling policy-uncertainty measures.
- D_GNP [undetermined]: GNP series joined by year and quarter to construct the durability measure.
- D_COMPUSTAT_QTR_2020 [undetermined]: Author quarterly Compustat extract used to construct payout flexibility.
- D_UNION_STATE [undetermined]: State union-density dataset used to construct the 2016 density classification.
- D_COMPUSTAT_ANN_2020 [undetermined]: Author annual Compustat extract used to construct target leverage deviation.
- D_FUNDAMENTALS_SEP [undetermined]: Author annual fundamentals file used as the main firm-level input and by the supplied appendix variants.
- D_AQC_COMPUSTAT [undetermined]: Author AQC Compustat supplement merged into the annual fundamentals file.
- D_DEFERRED_TAX [undetermined]: Author deferred-tax supplement merged into the annual fundamentals file.
- D_ADDITIONAL_COMPUSTAT [undetermined]: Author additional Compustat supplement merged into the annual fundamentals file.
- D_ADDITIONAL_TAX [undetermined]: Author additional tax-variable supplement merged into the annual fundamentals file.
- D_INCOME_TAX_NOTE [undetermined]: Author income-tax-note extract used to link un-repatriated foreign earnings by CIK and date.
- D_HISTORICAL_SEGMENT [undetermined]: Historical Compustat segment file used to construct firm-year foreign-sales measures.
- D_BEA_INDUSTRY_CODES [undetermined]: BEA industry-code table consumed by the BEA workbook import stage.
- D_ORBIS_GVKEY [undetermined]: Author Orbis-to-GVKEY and top-listed-owner crosswalk used for the Table 7 panel.
- D_FIRM_AGE [undetermined]: Author Compustat price file used to derive first-observed firm age.
- D_CEO_OPTIMISM [undetermined]: Author CEO/CFO option-holdings dataset used for appendix optimism measures.
- D_STATE_EMPLOYMENT [undetermined]: Author state employment file merged by state and year in appendix construction.
- D_TOPIC_RISK [undetermined]: Author firm-year topic-risk file merged into appendix construction.
- D_OFFSHORING_ALL [undetermined]: Full offshoring database text input used in appendix construction.
- D_OFFSHORING_COVERAGE [undetermined]: Separate offshoring database coverage text input used in appendix construction.
- D_TPS_BIGRAMS [undetermined]: Full-sample TPS bigram-occurrence workbook consumed by Figure A.5.
- D_TPU_BIGRAMS [undetermined]: Full-sample TPU bigram-occurrence workbook consumed by Figure A.5.
- D_CONFERENCE_CALL_IDS [undetermined]: Conference-call identifier workbook joined to the two Figure A.5 bigram sources.
- D_BEA_CAPEX_2014 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_CAPEX_2015 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_CAPEX_2016_2019 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_SALES_2014 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_SALES_2015 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_SALES_2016_2019 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_ASSETS_2014 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_ASSETS_2015 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_ASSETS_2016_2019 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_EMPLOYMENT_2014 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_EMPLOYMENT_2015 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_EMPLOYMENT_2016_2019 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_TOTAL_2014 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_TOTAL_2015 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- D_BEA_TOTAL_2016_2019 [undetermined]: Required BEA workbook source used by stage 3 to build the industry-year analysis panel; worksheet layout has not been inspected.
- SW_OUTREG2 [preparation_required]: The registered typed probe reports available=false, available_with_configuration=false, and both which return codes 111; author code writes tables with outreg2.
- SW_WINSOR2 [preparation_required]: The registered typed probe reports available=false, available_with_configuration=false, and both which return codes 111; author code uses winsor2 for staged winsorization.
- SW_FRAMEAPPEND [preparation_required]: The exact Stata 18 `which frameappend` metadata check returned 111; the command was not found in the checked ado path. Prepare the author-specified provider before a source run; no command body was executed.
- SW_GCOLLAPSE [preparation_required]: The exact Stata 18 `which gcollapse` metadata check returned 111; the command was not found in the checked ado path. Prepare the author-specified provider before a source run; no command body was executed.
- SW_GDUPLICATES [preparation_required]: The exact Stata 18 `which gduplicates` metadata check returned 111; the command was not found in the checked ado path. Prepare the author-specified provider before a source run; no command body was executed.
- SW_ASROL [preparation_required]: The exact Stata 18 `which asrol` metadata check returned 111; the command was not found in the checked ado path. Prepare the author-specified provider before a source run; no command body was executed.
- SW_ANYTHINGTODATE [preparation_required]: The exact Stata 18 `which anythingtodate` metadata check returned 111; the command was not found in the checked ado path. Prepare the author-specified provider before a source run; no command body was executed.

## Review notes

- The full author program set and the non-log source documents were reviewed through the v2 byte-first reader with original source line numbering. No author program, model, regression, parser, or statistical trial was executed.
- The fixed source-reader mask withheld the registered private-path block at code/0_data_preparation.do original lines 1–2. The value-free privacy_display_limit_290.json process record remains intentionally unused as scientific evidence; no author data barrier or exhaustive effects claim is inferred from that display limit.
- README order is 0–3, then the main paper output program, then the online appendix. Within stages 4 and 5, retain each native producer before its consumers, including figures or appendix sections that use samples made in later table sections; stage 5 calls both supplied Table A.5 variants.
- All 105 frozen checklist IDs are mapped exactly once. Repeated edges to the same author input are grouped; stage outputs are marked generated only where an active producer is cited. Additional mandatory inputs found in the supplied programs are recorded even when they are not checklist edges.
- The three packaged CSV files are identifier lists, not substitutes for the separate full author datasets named in the programs. No endpoint, credential, license, or access validity claim is made.
- Bounded common-source checks identified candidate local Compustat annual/quarterly, Compustat segment, subsidiary relationship, CRSP security-link, and CIK–GVKEY resources. These were kept as unverified route candidates because full history, field semantics, and author-specific construction were not established; all 58 logical inputs remain separate.
- The checked public BEA page documents annual input-output data and historical archives, but not the specific author workbook sheets or industry-code mapping. The SEC/LM product metadata identifies filing-level keys and periods but not the registrant address columns consumed by the author filing pipeline. Owner-product catalog queries yielded no selected metadata record; no absence, licensing, or access conclusion follows.
- A Stata 18 version/which-only probe found rangestat, winsor, ebalance, and _gxtile; frameappend, gcollapse, gduplicates, asrol, and anythingtodate returned which code 111. No author code, statistical procedure, or extension command was executed.
