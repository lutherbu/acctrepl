# Patch proposal: jar-9cb6a9d0d7b8

News Bias in Financial Journalists' Social Networks

DOI: 10.1111/1475-679X.12560

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-provided Stata workflow: sample and variable construction, panel analyses, cross-sectional analyses, and figure generation, retaining author-prepared/manual input branches.

Entry points: `ReplicationPackage/codes/0_Master.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 4/12560 - News-Bias-in-Financial-Journalists-Social-Networks/xu-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "dde729dafb3651b7c8163235c9413d6067049b34e09ba3d54095a29470576e70"
    },
    {
      "path": "JAR-Volume 62/Issue 4/12560 - News-Bias-in-Financial-Journalists-Social-Networks/xu-online-appendix.pdf",
      "sha256": "d1fe8b1342ed0fd6064f6b750741ae0757e828d9f48de9f9fc55d261750ac4cb"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "d77051dff5a4952685fd8ad898bea2f6d491bc83e7d29778cab008550a151d74"
}
```

## Proposed actions

### ACT_CONFIGURE_PATH: Prepare the runtime directory tree and set the master path in a working copy.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_PATH
Evidence: E_MASTER_PATH, E_README_LAYOUT, E_D0001, E_D0002, E_D0003, E_D0004

Preparation / proposed procedure:

1. Place the supplied four Stata programs in the `codes` folder and preserve sibling `NP`, `Manual`, and `Output` folders under the replication root.
2. Set the master `cd` value to the host-visible `codes` directory and ensure `Output` exists and is writable.

Validation to perform later:

- After data and software preparation, confirm each relative read and write resolves from the configured `codes` directory.

### ACT_AUTHOR_INPUTS: Obtain or identify authorized author-prepared NP/Manual inputs, or an evidenced compatible local/public route, and confirm exact file contracts before an attempt.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_INPUT_CLOSURE, ISS_DEPENDENCY_CLOSURE, REQ_SDC, REQ_PERMNOGVKEY, REQ_TARGET_PERMNO, REQ_CRSP, REQ_COMPUSTAT_FIN, REQ_COMPUSTAT_GEO, REQ_MEDIA_WSJ, REQ_MEDIA_FT, REQ_MEDIA_PR, REQ_TWITTER_FOLLOWS, REQ_TURNOVER_TO, REQ_WORDCOUNT, REQ_TFIDF, REQ_TARGET_CONNECT, REQ_C_FIRM, REQ_EVENT_SUITE, REQ_IBES_DETAIL, REQ_13F, REQ_BOARD_COMMITTEES, REQ_GVKEY_BOARDEX, REQ_DIRECTOR_MAIN, REQ_CONNECTNAMES_YEAR, REQ_PEERFIRM_POOL, REQ_FRAUD_ARTICLE, REQ_FRAUD_COMPUSTAT, REQ_CAR_DAILY, REQ_JOURNALIST_LIST
Evidence: E_PACKAGE_INVENTORY, E_README_LICENSE_NOTE, E_SDC_SOURCE_FIELDS, E_COMPUSTAT_FIELDS, E_CRSP_FIELDS, E_IBES_FIELDS, E_HOLDINGS_FIELDS, E_CATALOG_CANDIDATES, E_PRODUCT_REVIEW, E_PUBLIC_EDGAR, E_PUBLIC_AAER, E_PUBLIC_TEXTUAL

Preparation / proposed procedure:

1. Resolve each separate NP/Manual file requirement in the scope; confirm expected identifiers, fields, units, date coverage, product version and author cleaning/linkage rules.
2. For candidate CRSP, Compustat, SDC, IBES, 13F and BoardEx products, confirm the exact source-to-author-DTA mapping and complete required period/population; do not treat one-row reads or catalog listings as coverage.
3. Confirm the joined Compustat `CITY`/`STATE` fields and GVKEY/year alignment separately from FUNDA.
4. Obtain the prepared `director_main.dta` and `j_connectnames_year.dta` or confirm the authors' manual decision and mapping procedures, including the commented BoardEx employment branch.
5. For WSJ/FT/press-release and fraud/news inputs, confirm article selection, article-to-deal joins, text fields and journalist attributes; public SEC indexes and SRAF links are candidate components only.
6. If rebuilding text inputs, first identify the exact public Python script/version and article corpus/output fields; no external code payload has been retrieved.

Validation to perform later:

- Use bounded metadata checks on exact received files to verify the documented fields and format, then reconcile all producer/consumer handoffs before separately authorized execution.

### ACT_MANUAL_LINKAGES: Recover the author's manual network, journalist, and turnover crosswalks with their construction rules.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_MANUAL_CROSSWALK, REQ_GVKEY_BOARDEX, REQ_DIRECTOR_MAIN, REQ_CONNECTNAMES_YEAR, REQ_TARGET_CONNECT, REQ_TURNOVER_TO, REQ_JOURNALIST_LIST
Evidence: E_PREP_BOARD, E_PREP_DIRECT_TIES, E_EXTRA_GVKEY_BOARD_LINK, E_EXTRA_DIRECTOR_MAIN_WRITE, E_EXTRA_DIRECTOR_MAIN_READ, E_EXTRA_CONNECTNAMES_YEAR, E_APPENDIX_TURNOVER, E_EXTRA_TO_MAIN

Preparation / proposed procedure:

1. Confirm the GVKEY–BoardEx CompanyID link and year-specific journalist-name mapping.
2. Obtain the manually reviewed director-main-employer file or the source data and author decision procedure.
3. Confirm the turnover/promotion instrument and journalist-target connection definitions and time windows.

Validation to perform later:

- Check the delivered crosswalk keys, duplicate policy, effective dates and resulting join coverage against author documentation without reselecting ties.

### ACT_SOFTWARE_SETUP: Resolve missing exact Stata commands and verify package compatibility with the version-17 author workflow.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: ISS_SOFTWARE_SETUP, ISS_VERSION_COMPAT, SW_IVREGHDFE, SW_PROBIT2, SW_WINSOR2, SW_OUTREG2
Evidence: E_STATA_CHECK, E_SW_IVREGHDFE, E_SW_PROBIT2, E_SW_WINSOR2, E_SW_OUTREG2, E_SW_REGHDFE, E_SW_FFIND, E_REHDFE_COMPAT_NOTE, E_CMD_IVREGHDFE, E_CMD_PROBIT2, E_CMD_WINSOR2

Preparation / proposed procedure:

1. On the intended Stata adopath, provide compatible `ivreghdfe`, `probit2`, `winsor2`, and `outreg2` commands; preserve their exact versions and sources.
2. Verify the available `ffind`, `reghdfe`, `ivreg2`, `winsor`, `estpost`, `esttab`, and `ftools` command releases against the supplied syntax and Stata 18 runtime.
3. Check that the `ffind` source call is the available command; the earlier `fffind` name check was a mismatch and is excluded.

Validation to perform later:

- Before a separately authorized author run, confirm exact command locations and compatible syntax/package versions on the selected Stata adopath; retain the result logs without exposing license fields.


## Remaining issues and prerequisites

- ISS_PATH [preparation; full_pipeline]: The master has `cd "INSERT FOLDER PATH"`; its relative `do`, input and output paths need the runtime working directory set to the `codes` folder, with sibling `NP`, `Manual` and `Output` folders.
- ISS_INPUT_CLOSURE [unresolved; full_pipeline]: The archive contains a 700-row CUSIP identifier list but no named NP/Manual analysis inputs consumed by the supplied workflow; no analysis-only route is supported.
- ISS_DEPENDENCY_CLOSURE [unresolved; full_pipeline]: The frozen checklist omits several direct author-source reads, while generated handoffs depend on missing author-prepared inputs. Period, identifier, field and construction contracts are not closed.
- ISS_MANUAL_CROSSWALK [unresolved; full_pipeline]: The required `director_main.dta` depends on a manual main-employer decision; the workflow also needs a year-specific journalist-name mapping. The commented source block does not supply the resulting files.
- ISS_SOFTWARE_SETUP [preparation; full_pipeline]: The exact checked Stata adopath lacks `ivreghdfe`, `probit2`, `outreg2`, and `winsor2`; source calls require these commands. `ffind` itself is available.
- ISS_VERSION_COMPAT [unresolved; full_pipeline]: The master declares Stata 17 while the checked runtime is Stata 18; no model or package syntax was executed, and the datasheet warns that REGHDFE updates can affect syntax and clustered standard errors.
- REQ_SDC [undetermined]: Required `NP/sdc.dta` deal-level input. Code uses `anncdate`, deal id `v19`, and SDC fields `v201`, `v99`, and `v159`; the datasheet reports retrieval during 2016–2023 but does not define complete analysis coverage.
- REQ_PERMNOGVKEY [undetermined]: Required `NP/permnogvkey.dta` identifier crosswalk used to build permno/gvkey links; required identifier rules and historical link selection must match the author's prepared file.
- REQ_TARGET_PERMNO [undetermined]: Required author-prepared `NP/add_tgt_permno.dta` maps SDC deal id `v19` to target PERMNO for CRSP joins; source variables, mapping rules, and coverage are not established.
- REQ_CRSP [undetermined]: Required `NP/crsp.dta` stock input. Code uses PERMNO, date, price, and shares outstanding to construct acquirer market capitalization; the datasheet also lists returns. The author-prepared event/date coverage and formatting are unresolved.
- REQ_COMPUSTAT_FIN [undetermined]: Required annual accounting component of `NP/compustat.dta`, keyed by GVKEY and fiscal year, with AT, CEQ, MKVALT, DLC, DLTT, CH, CHE, and NI fields used in the supplied transforms.
- REQ_COMPUSTAT_GEO [undetermined]: The author-prepared Compustat file also retains CITY and STATE, which are listed in the datasheet and kept by the Stata code. Their GVKEY join, period and formatting must be confirmed separately from FUNDA.
- REQ_MEDIA_WSJ [undetermined]: Required manually collected `Manual/j_wsj.dta` articles for the WSJ branch, keyed to SDC `v19`; article text, authorship, sentiment and selection contract must match the supplied transformations.
- REQ_MEDIA_FT [undetermined]: Required manually collected `Manual/j_ft.dta` articles for the Financial Times branch, keyed to SDC `v19`; article text, authorship, sentiment and selection contract must match the supplied transformations.
- REQ_MEDIA_PR [undetermined]: Required manually collected `Manual/j_pr.dta` press releases for the press-release branch, keyed to SDC `v19`; fields and sample selection must match the supplied transformations.
- REQ_TWITTER_FOLLOWS [undetermined]: Required `Manual/j_twitterfollows.dta` journalist-follow/tie data merged by `v19`; time window, account linkage and indicator fields are unresolved.
- REQ_TURNOVER_TO [undetermined]: Required `Manual/to.dta` turnover/promotion instrument merged by `v19` and used by the panel/cross-sectional IV calls. The appendix describes manual journalist departure/promotion coding; exact fields and dates remain unresolved.
- REQ_WORDCOUNT [undetermined]: Required `Manual/j_wordcount-all.dta` word-count data merged on `v19` and media. The author's SRAF-linked text-analysis page is only a generic upstream-code candidate; exact inputs, code and output contract are unknown.
- REQ_TFIDF [undetermined]: Required `Manual/j_tfidf.dta` TF-IDF fields merged by `v19` and media; formula, article corpus, lexicon/version and row contract are not supplied. The SRAF page and dictionary are candidate upstream components only.
- REQ_TARGET_CONNECT [undetermined]: Required `Manual/j_target_connect.dta` journalist/target-connection data merged by `v19`; linkage definitions and period are not documented in the prepared file.
- REQ_C_FIRM [undetermined]: Required `Manual/c_firm.dta` board/firm attributes merged into the SDC sample. Datasheet describes CEO age, duality, classified-board and university variables from BoardEx/proxy filings/Bloomberg; a public SEC filing page supplies documents only, not this prepared combined DTA.
- REQ_EVENT_SUITE [undetermined]: Required `NP/essuite.dta` supplied event-study suite output used to construct CARs; the package does not define its production or required event-study version/fields.
- REQ_IBES_DETAIL [undetermined]: Required `NP/detail.dta` analyst-coverage input; datasheet lists CUSIP, ticker, forecast period end, analyst code and activation date. Market-region, date coverage and author-prepared conversion remain unresolved.
- REQ_13F [undetermined]: Required `NP/ts13f.dta` institutional-holdings input; datasheet lists filing date, CUSIP, shares held and shares outstanding. Product/history and prepared-file mapping remain unresolved.
- REQ_BOARD_COMMITTEES [undetermined]: Required `NP/BoardEx_Committees.dta` non-inside director/committee data; supplied code requires companyid, DirectorID, AnnualReportDate and BrdPosition. BoardEx regional candidates lack COMPANYID in catalog metadata.
- REQ_GVKEY_BOARDEX [undetermined]: Required `NP/add_gvkeyBoardex_link.dta` maps Compustat GVKEY to BoardEx CompanyID for board-network construction; its keys, effective dates and source mapping are unknown.
- REQ_DIRECTOR_MAIN [undetermined]: Required manually reviewed `Manual/director_main.dta` maps BoardEx directors to their main employer at each M&A date. Source documents describe a manual employer choice from BoardEx Ind_Employment; no prepared crosswalk is packaged.
- REQ_CONNECTNAMES_YEAR [undetermined]: Required `Manual/j_connectnames_year.dta` journalist-name/connection mapping merged by GVKEY and announcement year; names, mapping rules and period must be confirmed.
- REQ_PEERFIRM_POOL [undetermined]: Required `NP/peerfirm_pool.dta` author-prepared peer-firm pool used to construct `peerfirm_pool2.dta`; population, identifiers and sampling rules are not defined in the package.
- REQ_FRAUD_ARTICLE [undetermined]: Required `Manual/fraud_article.dta` fraud-news/article records, joined to Compustat by GVKEY and fiscal year. The SEC AAER page is an incomplete public source candidate, not a verified substitute for the authors' selection or article fields.
- REQ_FRAUD_COMPUSTAT [undetermined]: Required `NP/fraud_compustat.dta` annual Compustat companion merged by GVKEY and fiscal year; at least GVKEY/FYEAR/AT and the author's fraud-sample fields are needed.
- REQ_CAR_DAILY [undetermined]: Required `NP/car_daily.dta` daily event-study output used for `car_plot.dta`; raw CRSP market fields alone do not establish the event-study model, event windows or author-prepared CAR variables.
- REQ_JOURNALIST_LIST [undetermined]: Required `Manual/journalist_list.dta` is read for Table 7 journalist outcomes and characteristics (including connection type, gender, tenure, publication and media/location indicators); source and construction are not provided.
- SW_IVREGHDFE [preparation_required]: Exact `which` check not available on the checked Stata 18 adopath; this does not establish machine-wide absence.
- SW_PROBIT2 [preparation_required]: Exact `which` check not available on the checked Stata 18 adopath; source comments point to an ado URL but no payload was fetched.
- SW_WINSOR2 [preparation_required]: Exact `which` check not available on the checked Stata 18 adopath; this is a preparation item, not an access barrier.
- SW_OUTREG2 [preparation_required]: Exact `which` check not available on the checked Stata 18 adopath; source comments include an install hint, but nothing was installed.

## Review notes

- This is an expanded section checkpoint; dependency review is still being reconciled against the frozen checklist.
- The only packaged dataset is the CUSIP identifier file; no analysis-only scope is supported.
- Local product checks are bounded one-row metadata reads; none establishes period/population coverage or author-prepared DTA compatibility.
- The TFN.S34 product read timed out under the frozen 15-second bound and remains unverified.
- The first software batch checked `fffind`; the exact source call `ffind` was separately checked and found available. The mismatch result is excluded.
- The author source files were not executed; no Stata models or SAS executable were run. Raw Stata logs were preserved without display.
- All 36 frozen dependency IDs are explicitly classified once; generated intermediates are tied to screened producer lines, and additional direct source reads omitted from the checklist are represented as separate requirements.
