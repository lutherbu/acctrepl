# Patch proposal: jar-ed989b9069c9

The Determinants of ESG Ratings: Rater Ownership Matters

DOI: 10.1111/1475-679X.70016

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete README-ordered cleaning workflow and sequential analysis programs for the supplied replication package.

Entry points: `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Sister firms1.sas`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Sister firms2.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/ESG ratings1.sas`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/ESG ratings2.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Other ESG ratings1.sas`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Other ESG ratings2.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Controls.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Merge.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/DiD 1 year.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/DiD 2 year.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Rating disagreement.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Business complexity measures.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Blockholder aum1.sas`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Blockholder aum2.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Change in holdings1.sas`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Change in holdings2.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/SRI proposals1.sas`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/SRI proposals2.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/ESG incidents.do`, `TYY-datasheet-code-identifiers-and-log-files/data cleaning code/Violation indicators.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/01.Summary statistics.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/02.Baseline regressions.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/03.Alternative blockholders.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/04.Alternative sisters.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/05.Alternative connection measure.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/06.Matching.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/07.DiD regression 1 year.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/08.DiD regression 2 year.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/09.Relative ESG ratings.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/10.ESG rating disagreement.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/11.Business complexity.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/12.Materiality.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/13.Size and scale.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/14.Subsequent change in holdings.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/15.Departed sisters.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/16.Ownership size_SRI proposals.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/17.Ownership size_UNPRI.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/18.ESG risk incidents.do`, `TYY-datasheet-code-identifiers-and-log-files/analysis code/19.Regulatory violations.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 2/70016 - The-Determinants-of-ESG-Ratings-Rater-Ownership-Matters/tyy-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "0db5d67626060213f425038e9743c3b412208b9fd1e25c4c1eec75ef278b654f"
    },
    {
      "path": "JAR-Volume 64/Issue 2/70016 - The-Determinants-of-ESG-Ratings-Rater-Ownership-Matters/tyy-online-appendix.pdf",
      "sha256": "77219e8f2491042c9941887dd34725ccdcc6ca19f7511535295a599107092097"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "d97cd7500b66951c69dba6b9c33ffcdcfea23e52a34b9bc24288b9f008629ad2"
}
```

## Proposed actions

### ACT_req_crsp_monthly: Confirm the CRSP monthly input window and prepare the author-named input from the compatible local CRSP monthly product.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_crsp_monthly
Evidence: PROBE_CRSP_MSF

Preparation / proposed procedure:

1. Use the exact source-filter and rolling/history requirements in the ownership programs to determine the required start and end dates.
2. Prepare the `crsp_m.sas7bdat` alias from the local monthly product without dropping adjusted-price or share fields.

Validation to perform later:

- Compare the full consumed columns and the required date range against the author program before a future run.
- Check PERMNO and date uniqueness/coverage and retain the source product and extract date.

### ACT_req_thomson13f: Resolve the separate S34 Type 1 manager/filing contract and author alias. Native catalog fields match, but no successful live probe or complete historical contract is established.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_thomson13f
Evidence: SRC_e0d657cde075, CAT_TFN_S34_SCHEMA

Preparation / proposed procedure:

1. Confirm the Type 1 product vintage/filter and source-required report date, filing date, manager number/name, and type code fields.
2. Confirm the author `input.s34type1` alias and full filing-period coverage using the existing authorized source; do not treat the Type 3 holdings alias as interchangeable.

Validation to perform later:

- Compare the Type 1 selection, native field meanings, manager/report-date grain, and filing-history coverage to the source contract.

### ACT_req_crsp_msenames: Verify the CRSP name-history window and prepare the author-named security-name input.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_crsp_msenames
Evidence: PROBE_CRSP_MSENAMES

Preparation / proposed procedure:

1. Retain CRSP name-history rows for the full required ownership period, including effective-date transitions.

Validation to perform later:

- Confirm PERMNO/NCUSIP field compatibility and that the join uses the source-required historical observation.

### ACT_req_permno_gvkey: Resolve the author-compatible PERMNO-to-GVKEY link input and its effective-date rule.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_permno_gvkey
Evidence: PROBE_CRSP_CCMXPF_LINKTABLE

Preparation / proposed procedure:

1. Confirm how the author-created `link_permno_gvkey` table is derived from CCM and how invalid/overlapping links are handled.
2. Map local `lpermno` to the author-required `permno` only after confirming the native key and retain link start/end dates.

Validation to perform later:

- Compare the prepared fields, names, link dates, and PERMNO/GVKEY assignments with the supplied join.

### ACT_req_compustat_segments: Prepare and verify the author-named Compustat segment-history input from the local segment-history product.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_compustat_segments
Evidence: PROBE_COMPSEG_WRDS_SEGMERGED

Preparation / proposed procedure:

1. Retain business-segment observations (`stype`) and the full period used by the source program.
2. Create the author alias from the local segment-history product only after checking native date and segment identifiers.

Validation to perform later:

- Check `gvkey`, `stype`, `sid`, `datadate`, and `sics1`, and verify historical coverage and duplicate handling.

### ACT_req_lm_complexity: Acquire the official Loughran–McDonald complexity file and prepare the same data in the author-required workbook format.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_lm_complexity
Evidence: PUB_LM_COMPLEXITY

Preparation / proposed procedure:

1. Download the published CSV from the Notre Dame SRFA complexity page.
2. Convert the same rows to the author workbook format without changing CIK, filing date, complexity, or log file-size fields.

Validation to perform later:

- Verify the four named fields and the required filing-year coverage against the 1996–2021 repository statement.
- Confirm the CIK/date join and resulting file name before a future run.

### ACT_req_comp_all: Resolve the annual Compustat panel construction and missing SIC/state history before preparing `comp_all.dta`.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_comp_all
Evidence: PROBE_COMP_FUNDA_COMPLETE

Preparation / proposed procedure:

1. Confirm the author-specific annual panel fields, date rules, sample period, and source for SIC/state history.
2. Use local Compustat annual and company records as candidates only after establishing date-effective firm history; do not substitute current identifiers without confirmation.

Validation to perform later:

- Compare all source-consumed variables and years with the author contract, including SIC/state and derived measures.
- Check the annual key and historical identifier continuity.

### ACT_req_comp_crsp_annual: Confirm the WRDS CRSP/Compustat annual product and prepare the matching firm-year file.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_comp_crsp_annual
Evidence: SRC_ebdcb78b251c

Preparation / proposed procedure:

1. Confirm the author’s firm-year convention and required `prc`, `shrout`, and `ret` definitions.
2. Obtain/prepare the WRDS merge covering the Compustat panel period with the author-required gvkey/year keys.

Validation to perform later:

- Verify the three consumed fields, gvkey/year uniqueness, and required history against the source merge.

### ACT_req_ibes_detail: Resolve the IBES detail product and source-to-native variable mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_ibes_detail
Evidence: PROBE_IBES_DETU_EPSUS

Preparation / proposed procedure:

1. Confirm the IBES file/version and the intended source fields `analy` and `curr_act` against the local IBES schema.
2. Apply only documented aliases and retain the requested currencies, analyst, forecast value, and announcement timing.

Validation to perform later:

- Check field semantics, not just case or spelling, plus the sample period and ticker/date key coverage.

### ACT_req_comp_ibes_ticker: Obtain or verify the author-compatible Compustat–IBES ticker linking file.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_comp_ibes_ticker
Evidence: SRC_4798badb39ec

Preparation / proposed procedure:

1. Confirm the expected gvkey/IBES ticker fields, validity dates, and treatment of ticker changes.
2. Prepare the author-named file for the full forecast-analysis period.

Validation to perform later:

- Check the gvkey/ticker join and historical validity intervals before constructing analyst coverage.

### ACT_req_io_timeseries: Verify access to the quarterly WRDS institutional-ownership product and prepare the author input.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_io_timeseries
Evidence: SRC_64524495ad0b, SRC_a84fc3e8ef16

Preparation / proposed procedure:

1. Confirm the exact ownership series, firm identifier, quarter date, and required coverage in the author code.
2. Obtain an authorized WRDS extract and prepare the `io_timeseries.dta` alias.

Validation to perform later:

- Check quarterly key uniqueness and source-consumed fields, then compare period coverage with Controls.

### ACT_req_red_blue: Confirm the author `red_blue.xlsx` classification input and its source/field contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_red_blue
Evidence: INS_DEPENDENCIES

Preparation / proposed procedure:

1. Confirm whether the author workbook is provided elsewhere and identify the fields, identifier, and period used to define the Red/Blue classification.
2. If supplied, inspect its workbook metadata through a bounded approved reader and prepare the exact author alias.

Validation to perform later:

- Verify the imported Blue/Red variable against the source program and its firm-year keys.

### ACT_req_s34type3: Resolve the distinct S34 Type 3 holdings contract and author alias; the native catalog fields match but Type 3 grain, vintage, and history remain unverified.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_s34type3
Evidence: SRC_18a9dae158d9, CAT_TFN_S34_SCHEMA

Preparation / proposed procedure:

1. Confirm the Type 3 product vintage/filter and source-required filing date, manager number, CUSIP, and shares fields for the holdings join.
2. Confirm how the author `input.s34type3` alias selects Type 3 observations separately from the Type 1 manager/filing stage.

Validation to perform later:

- Compare the Type 3 selection, manager/filing keys, holdings grain, duplicates, and full-period coverage to the supplied SQL join.

### ACT_req_type4_holdings: Verify and obtain the author-compatible Type 4 changes-in-holdings input.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_type4_holdings
Evidence: SRC_a0618be0d6a3, INS_DEPENDENCIES

Preparation / proposed procedure:

1. Confirm the Type 4 product/vintage and the manager/date/security/share fields used by the supplied SAS stage.
2. Obtain an authorized input for the study period, then apply the supplied manager selection.

Validation to perform later:

- Check native fields, manager/date coverage, and the generated author output before downstream use.

### ACT_req_reprisk_news: Resolve the RepRisk news input and its GVKEY assignment.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_reprisk_news
Evidence: PROBE_REPRISK_PM_NEWS_DATA

Preparation / proposed procedure:

1. Confirm the RepRisk product/vintage and how the author’s `reprisk_news.dta` assigns GVKEY to PM news items.
2. Use the local PM news table only with an identified, date-valid RepRisk-to-firm mapping.

Validation to perform later:

- Verify GVKEY, news date, substory identifier, and issue fields and the study-period coverage.

### ACT_req_kld_esg_raw: Verify the KLD release and author-required total-score schema.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_kld_esg_raw
Evidence: PROBE_KLD_HISTORY

Preparation / proposed procedure:

1. Confirm the KLD version and exact raw indicator/strength/concern totals required by ESG ratings1.sas.
2. Map the firm identifiers using the historical author crosswalk only after validating its period and key definitions.

Validation to perform later:

- Compare every consumed TOTAL field and the year/CUSIP keys with the local candidate and author input contract.

### ACT_req_bloomberg_year_files: Verify authorized access to the Bloomberg ESG annual workbooks and prepare all 2004–2017 inputs.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_bloomberg_year_files
Evidence: SRC_458e5d983026, INS_DEPENDENCIES

Preparation / proposed procedure:

1. Confirm whether the referenced annual workbooks are present in an authorized companion release or must be exported from Bloomberg.
2. Obtain the author-compatible 2004–2017 extracts and retain identifier, year, and ESG/governance/social/environment fields.

Validation to perform later:

- Check each annual workbook import, year assignment, and the concatenated fields before joining identifiers.

### ACT_req_refinitiv_asset4: Verify the Refinitiv/Asset4 release and prepare the author input workbook.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_refinitiv_asset4
Evidence: SRC_95876d07333d, INS_DEPENDENCIES

Preparation / proposed procedure:

1. Confirm the referenced source release, workbook fields, identifier basis, and period.
2. Obtain an authorized copy/export and preserve the source header and workbook version.

Validation to perform later:

- Check `Year`, `TR_ESGC`, `LOC_OFF__CODE`, and the identifier mapping used by the source joins.

### ACT_req_sustainalytics_raw: Verify authorized access to the Sustainalytics historical weighted ESG product and prepare its author-compatible workbook.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_sustainalytics_raw
Evidence: SRC_6b47190e7cbb, INS_DEPENDENCIES

Preparation / proposed procedure:

1. Confirm the historical weighted product, quarterly date and Capital IQ identifier fields, and required years.
2. Obtain an authorized workbook/export and preserve its source date and version.

Validation to perform later:

- Check quarterly coverage, the four score fields, CapitalIQ_ID, country, and period before aggregation.

### ACT_req_tv_quarterly: Verify authorized access to the quarterly TruValue ranks and prepare the author input.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_tv_quarterly
Evidence: SRC_1b213f5911b2, INS_DEPENDENCIES

Preparation / proposed procedure:

1. Confirm the source release, quarterly PERMNO/date fields, and the two insight measures used by the program.
2. Obtain an authorized extract for the full study period.

Validation to perform later:

- Check PERMNO/date keys, both insight fields, and annualization coverage before constructing the gvkey-linked score.

### ACT_req_legacy_shareholder_proposals: Verify and obtain the author-compatible legacy shareholder-proposal records.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_legacy_shareholder_proposals
Evidence: SRC_a46a6d2491fc, SRC_e9a8e99ce1fb, PUB_ISS

Preparation / proposed procedure:

1. Confirm the legacy product, fields, and available identifier history through January 16, 2006.
2. Use the supplied source filters to retain only the legacy interval.

Validation to perform later:

- Check meeting dates, SRI resolution type, CUSIP mapping, and overlap with the post-2006 product.

### ACT_req_voting_analytics: Verify authorized access to the post-2006 Voting Analytics input.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_voting_analytics
Evidence: SRC_6b8518632cef, PUB_ISS

Preparation / proposed procedure:

1. Confirm the product edition, exact SRI proposal fields, and identifiers expected by the supplied SAS branch.
2. Obtain an authorized extract for the years used by the study.

Validation to perform later:

- Check meeting date, resolution type, CUSIP/GVKEY link, and continuity at the 2006 handoff.

### ACT_req_cusip_gvkey: Resolve the author’s CUSIP-to-GVKEY sample link and validity rule.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_cusip_gvkey
Evidence: PROBE_CRSP_CCMXPF_LINKTABLE

Preparation / proposed procedure:

1. Confirm the author-specific sample and security-history rules for `cusip_gvkey_link.dta`.
2. Use CCM/Compustat links only after confirming the required CUSIP key and effective-date semantics.

Validation to perform later:

- Compare CUSIP/GVKEY/date fields and sampled issuer assignments against the source merge.

### ACT_req_gvkey_cik: Verify historical Compustat GVKEY–CIK links before preparing `comp_gvkey_cik_link.dta`.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_gvkey_cik
Evidence: PROBE_COMP_COMPANY

Preparation / proposed procedure:

1. Confirm the author-required CIK/GVKEY validity dates and period-specific mapping.
2. Prepare the author alias from a date-valid Compustat link source rather than assuming current company identifiers.

Validation to perform later:

- Check CIK/GVKEY/year uniqueness and historical changes for the filing and violation periods.

### ACT_req_esg_materiality: Verify authorized SASB Materiality Map access and prepare the author’s four-field mapping.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_esg_materiality
Evidence: SRC_01c2d72527bf, PUB_IFRS

Preparation / proposed procedure:

1. Confirm the SASB sector standard and indicator-to-material/immaterial decisions used by the authors.
2. Prepare `ESG_materiality.dta` with all four named fields and GVKEY/year keys.

Validation to perform later:

- Compare the four fields and sector assignments with the supplied merge and retain the version/source of the manual mapping.

### ACT_req_pri_dates: Resolve the PRI signatory-date source and its mapping to the author manager IDs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_pri_dates
Evidence: PUB_PRI

Preparation / proposed procedure:

1. Confirm the exact directory/export that produced `PRI_date.xlsx` and the manager-name/identifier crosswalk used by the authors.
2. Prepare join dates without inferring unmatched managers or backdating status.

Validation to perform later:

- Check signatory identifiers, join dates, manager mapping, and the study-period PRI flag logic.

### ACT_req_parent_violation: Verify authorized access to the historical parent data and prepare the author parent crosswalk.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_parent_violation
Evidence: SRC_6267fcb57863, PUB_GOODJOBS

Preparation / proposed procedure:

1. Confirm the historical parent-at-time fields and product vintage used to produce `parent_violation.dta`.
2. Obtain only an authorized export or other permitted documented route; do not infer historical parent assignments from current parents.

Validation to perform later:

- Check parent name keys, historical dates, and the `parent_name` merge against the author code.

### ACT_req_violationtracker_basic: Verify authorized access to the 2021 basic Violation Tracker workbook and its author-compatible fields.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_violationtracker_basic
Evidence: INS_DEPENDENCIES, PUB_GOODJOBS

Preparation / proposed procedure:

1. Confirm user entitlement and the exact 19 March 2021 workbook vintage.
2. Obtain the documented authorized download and preserve the original workbook and headers.

Validation to perform later:

- Check offense group, penalty year, CIK, case identifier, and required historical rows against the source program.

### ACT_req_violationtracker_parents: Verify authorized access to the Violation Tracker parent workbook and its historical parent fields.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_violationtracker_parents
Evidence: INS_DEPENDENCIES, PUB_GOODJOBS

Preparation / proposed procedure:

1. Confirm user entitlement, workbook vintage, parent-history semantics, and the author mapping to `parent_violation.dta`.
2. Obtain the documented authorized export and retain its original fields.

Validation to perform later:

- Check parent-history dates, company identifiers, and the parent-name keys used by the program.

### ACT_req_isin_capitaliqid: Prepare the author ISIN-to-COMPANYID alias from the verified local native link route and resolve historical validity for the provider years.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_isin_capitaliqid
Evidence: PROBE_CIQ_WRDS_ISIN

Preparation / proposed procedure:

1. Use the confirmed native ISIN and COMPANYID fields from the local route.
2. Confirm identifier validity dates, duplicate policy, and study-year assignments before preparing the author alias.

Validation to perform later:

- Check native key mapping, historical coverage, duplicates, and yearly continuity.

### ACT_req_capitaliq_gvkey: Prepare the author COMPANYID-to-GVKEY alias from the verified local native link route and resolve historical validity for the provider years.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_capitaliq_gvkey
Evidence: PROBE_CIQ_WRDS_GVKEY

Preparation / proposed procedure:

1. Use the confirmed native COMPANYID and GVKEY fields from the local route.
2. Confirm whether the source mapping is static or period-effective before preparing the author alias.

Validation to perform later:

- Check native key mapping, effective-date behavior, historical assignments, and full provider-period coverage.

### ACT_req_cc_id: Resolve the author CRSP/Compustat CUSIP-to-GVKEY crosswalk and history rules.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_cc_id
Evidence: PROBE_CRSP_CCMXPF_LINKTABLE

Preparation / proposed procedure:

1. Confirm the exact input columns used by each ESG/proposal branch, including Compustat and CRSP CUSIP variants and the assignment year.
2. Use the local CCM route only after verifying security identifiers and effective dates.

Validation to perform later:

- Check CUSIP widths, PERMNO/GVKEY history, year-specific joins, and duplicate handling for each branch.

### ACT_issue_alternative_samples: Confirm how the two alternative regression samples are supplied or constructed from the documented robustness branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_alternative_samples
Evidence: INS_DEPENDENCIES, SRC_16bdcec741f1, SRC_791d7fd0f8a2

Preparation / proposed procedure:

1. Ask for the author-prepared alternative samples or a source-supported producer and exact sample/field construction.
2. Keep the 4% blockholder branch and 5% sister cutoff distinct from the baseline 5% shareholder / 0.25% investee settings.

Validation to perform later:

- Verify each alternative file’s consumed fields, key, and sample criteria against its analysis entry point.

### ACT_issue_10k_complexity_producer: Confirm the `10k_firm_complexity.dta` producer and required construction fields while preserving the supplied source workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_10k_complexity_producer
Evidence: SRC_8367a98ec498, SRC_05051959ea48, INS_DEPENDENCIES

Preparation / proposed procedure:

1. Confirm the existing producer or author-prepared intermediate schema and generation instructions.
2. Confirm how CIK, filing date/year, complexity, and log file size are joined to Compustat GVKEY.

Validation to perform later:

- Verify fields, filing/financial year alignment, duplicate CIK/year handling, and the final `_` output handoff used by analysis 11.

### ACT_issue_violation_basic_producer: Resolve the author construction and field contract for `violation_basic.dta` and its relationship to the raw workbooks.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_violation_basic_producer
Evidence: SRC_ec111f1420d9, INS_DEPENDENCIES

Preparation / proposed procedure:

1. Obtain the author-prepared intermediate or source-supported import/cleaning specification for violation_basic.
2. Confirm whether it preserves current/historical parent identifiers, offense groups, CIK, penalty year, and case identifiers.

Validation to perform later:

- Check the prepared fields against the downstream merge/classification and verify annual CIK/GVKEY links.

### ACT_issue_identifier_history: Resolve the remaining historical identifier construction for the distinct CCM/PERMNO, CUSIP/GVKEY, GVKEY/CIK, and multi-provider firm/security crosswalks.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_identifier_history, req_permno_gvkey, req_cusip_gvkey, req_gvkey_cik, req_cc_id
Evidence: PROBE_CRSP_CCMXPF_LINKTABLE, PROBE_COMP_COMPANY, INS_DEPENDENCIES

Preparation / proposed procedure:

1. For each remaining author alias, confirm the source-required identifier variant, effective dates, sample period, and duplicate policy.
2. Use CCM and Compustat native fields only where their source semantics match; keep PERMNO, LPERMNO, CUSIP variants, GVKEY, CIK, and Compustat name mappings distinct until the source contract supports a join.

Validation to perform later:

- Check historical links, date-effective assignments, unmatched keys, and duplicates for each separate source join; do not infer population or use current identifiers as historical mappings.

### ACT_issue_ibes_field_aliases: Confirm IBES native field semantics and source aliases before preparing the detail input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_ibes_field_aliases, req_ibes_detail
Evidence: PROBE_IBES_DETU_EPSUS, SRC_da44a87e0e2f, INS_DEPENDENCIES

Preparation / proposed procedure:

1. Compare the source’s analyst and actual-currency field definitions with the local IBES schema.
2. Apply only a documented mapping from ANALYS/CURR to analy/curr_act if the product definition supports it.

Validation to perform later:

- Check analyst identifier, currency semantics, forecast/value fields, and date coverage.

### ACT_issue_reprisk_gvkey: Resolve the RepRisk event-to-GVKEY mapping and effective-date rule.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_reprisk_gvkey, req_reprisk_news
Evidence: PROBE_REPRISK_PM_NEWS_DATA, SRC_2268b327ce9b

Preparation / proposed procedure:

1. Identify a date-valid RepRisk company identifier link for each news item.
2. Retain the event date/substory identifiers and avoid assigning current GVKEYs without historical support.

Validation to perform later:

- Check event dates, firm assignments, substory deduplication, and full study-period coverage.

### ACT_issue_materiality_mapping: Confirm the authors’ materiality indicator mapping and licensed SASB sector standard.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_materiality_mapping, req_esg_materiality
Evidence: SRC_57816ad3f5c0, PUB_IFRS

Preparation / proposed procedure:

1. Obtain the author mapping or a source-supported construction specification for all four rating fields.
2. Confirm authorized access to the Map and preserve the sector/version used.

Validation to perform later:

- Verify GVKEY/year keys, sector assignment, and all four fields against the analysis merge.

### ACT_issue_pri_manager_link: Confirm how PRI signatories and join dates map to the source manager identifiers.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_pri_manager_link, req_pri_dates
Evidence: PUB_PRI, INS_DEPENDENCIES

Preparation / proposed procedure:

1. Obtain the author’s manager-number/signatory crosswalk or a source-supported matching rule.
2. Preserve join dates and avoid backdating a signatory’s status.

Validation to perform later:

- Check manager identity, signatory name changes, join dates, and annual PRI flags.

### ACT_issue_violation_parent_history: Verify an authorized route to the required historical violation and parent records, then resolve the author crosswalk.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: issue_violation_parent_history, req_parent_violation, req_violationtracker_basic, req_violationtracker_parents
Evidence: PUB_GOODJOBS, SRC_6267fcb57863, INS_DEPENDENCIES

Preparation / proposed procedure:

1. Confirm subscriber entitlement or another documented permitted route to the exact Violation Tracker vintage.
2. Obtain the author’s parent-at-time and basic violation construction rules before preparing either intermediate.

Validation to perform later:

- Check parent history, offense group, penalty year, CIK, and downstream parent_name/GVKEY joins.

### ACT_SOFT_winsor2: Resolve the winsor2 software dependency for the supplied workflow.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: winsor2
Evidence: INS_EXISTING_SOFTWARE, SRC_a0b03f6fdb7a

Preparation / proposed procedure:

1. Install/configure the free Stata add-on from an approved source if it is not available in the authorized runtime.

Validation to perform later:

- Confirm the command is available in the intended Stata/SAS runtime and record its exact version/configuration before a future authorized execution.

### ACT_SOFT_psmatch2: Resolve the psmatch2 software dependency for the supplied workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: psmatch2
Evidence: SRC_f69ef4f54ae5

Preparation / proposed procedure:

1. Verify exact command availability and version in the intended runtime using the approved software helper.
2. If unavailable, use the approved installation/configuration process only after the assessment; do not change the author code or estimator.

Validation to perform later:

- Confirm the command is available in the intended Stata/SAS runtime and record its exact version/configuration before a future authorized execution.

### ACT_SOFT_eststo: Resolve the eststo software dependency for the supplied workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: eststo
Evidence: SRC_e692312f9e83

Preparation / proposed procedure:

1. Verify exact command availability and version in the intended runtime using the approved software helper.
2. If unavailable, use the approved installation/configuration process only after the assessment; do not change the author code or estimator.

Validation to perform later:

- Confirm the command is available in the intended Stata/SAS runtime and record its exact version/configuration before a future authorized execution.

### ACT_SOFT_SAS: Resolve the SAS software dependency for the supplied workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SAS
Evidence: INS_EXISTING_SOFTWARE, SRC_3c4b8dd79f37

Preparation / proposed procedure:

1. Verify exact command availability and version in the intended runtime using the approved software helper.
2. If unavailable, use the approved installation/configuration process only after the assessment; do not change the author code or estimator.

Validation to perform later:

- Confirm the command is available in the intended Stata/SAS runtime and record its exact version/configuration before a future authorized execution.

### ACT_full_pipeline_conditional_run: Conditional execution procedure for the complete 39-program package workflow after the listed data contracts, software dependencies, author aliases, and historical constructions are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: req_crsp_monthly, req_thomson13f, req_crsp_msenames, req_permno_gvkey, req_compustat_segments, req_lm_complexity, req_comp_all, req_comp_crsp_annual, req_ibes_detail, req_comp_ibes_ticker, req_io_timeseries, req_red_blue, req_s34type3, req_type4_holdings, req_reprisk_news, req_kld_esg_raw, req_bloomberg_year_files, req_refinitiv_asset4, req_sustainalytics_raw, req_tv_quarterly, req_legacy_shareholder_proposals, req_voting_analytics, req_cusip_gvkey, req_gvkey_cik, req_esg_materiality, req_pri_dates, req_parent_violation, req_violationtracker_basic, req_violationtracker_parents, req_isin_capitaliqid, req_capitaliq_gvkey, req_cc_id, Stata, reghdfe, ftools, winsor2, psmatch2, eststo, SAS, issue_alternative_samples, issue_10k_complexity_producer, issue_violation_basic_producer, issue_identifier_history, issue_ibes_field_aliases, issue_reprisk_gvkey, issue_materiality_mapping, issue_pri_manager_link, issue_violation_parent_history
Evidence: INS_README_WORKFLOW, INS_WORKFLOW_TRACE, INS_DEPENDENCIES, SRC_3c4b8dd79f37, SRC_e0d657cde075, SRC_18a9dae158d9, SRC_003563fdf855, SRC_4101014327a2, SRC_e807b793b38b, SRC_8367a98ec498, SRC_05051959ea48, SRC_65389829b6d9, SRC_fd7b12ef81c3, SRC_ebdcb78b251c, SRC_7f23edce3d90, SRC_4798badb39ec, SRC_64524495ad0b, SRC_a84fc3e8ef16, SRC_a0618be0d6a3, SRC_582f34306f27, SRC_a22482a59913, SRC_458e5d983026, SRC_95876d07333d, SRC_6b47190e7cbb, SRC_1b213f5911b2, SRC_a46a6d2491fc, SRC_e9a8e99ce1fb, SRC_6b8518632cef, SRC_fec51c5971ce, SRC_ce255c98611a, SRC_445727457b21, SRC_df27e619e184, SRC_09c5bcca4fa0, SRC_adb781c1e3cc, SRC_01c2d72527bf, SRC_f7de69f71942, SRC_ec111f1420d9, SRC_6267fcb57863, SRC_16bdcec741f1, SRC_791d7fd0f8a2, SRC_f87e970f03e3, SRC_a42612f39c13, SRC_b157599b88c3, SRC_cae603960c2c, SRC_7962ab0f43eb, SRC_aa490d1a177d, SRC_6fed4c7c75d7, SRC_b447d9ab944c, SRC_25805d108469, SRC_f5a9d825eb92, SRC_74a309b8b827, SRC_fc3564ae00dc, SRC_94437fcf3435, SRC_9f66c6937b6b, SRC_0f745aa5c314, SRC_93b9d4899e07, SRC_45dced4747cd, SRC_d4a1e97ed24a, SRC_e3eaaf177603, SRC_28a54dc98518, SRC_16ca83137bcc, SRC_7dcd5cdabbf7, SRC_a396821dc08b, SRC_bc4af45e04af, SRC_7312b8f3f41c, SRC_4f8e28759619, SRC_7e0b5011846a, SRC_8645a88c0272, SRC_efb33bd1cf79, SRC_1ad456f0749a, SRC_310658f40b42, SRC_5e7f8031749e, SRC_3d6d5948a36f, SRC_4030f81dd6df, SRC_db359270d06b, SRC_76d80309b565, SRC_daa8d38f2194, SRC_78f05965c59d, SRC_e11a5ddf11c4, SRC_72e14d0ae84a, SRC_ee8ec7ba3ab3, SRC_c60f8738b457, SRC_55f91b53b296, SRC_5ccdffb66c6b, SRC_b117c35fe375, SRC_91a8c36a044c, SRC_630448f738ce, SRC_9a29c2b2052a, SRC_97de6fa8a3b4, SRC_08d38e0ae629, SRC_fbbc88a7b3b0, SRC_072094fdf7b3, SRC_fe46ec4e5776, SRC_6188a2323ec4, SRC_51d947df45be, SRC_2cf7c0955b6b, SRC_ca583f8b19ec, SRC_1eff0ab0cfda, SRC_26848b548fc9, SRC_b62375620595, SRC_bc9e59e0ba20, SRC_796213c85ed1, SRC_b336b3e6bdad, SRC_169ff2cbef85, SRC_59a06d57b32a, SRC_098c5d06bebd, SRC_1cdc3bcbed36, SRC_941d2c15ecef, SRC_b946aaabb4dc, SRC_98696f5926f0, SRC_afc84550851f, SRC_9f4e081a9c0b, SRC_f2682ac4f468, SRC_d9b1fb105041, SRC_9ac0ed734890, SRC_f28edfca4895, SRC_2ba2dc12c112, SRC_c560f3312093, SRC_c53c03fadc73, SRC_05595f199416, SRC_156e325f261b, SRC_07cac7c25ef5, SRC_7f369e7c8cd2, SRC_58539fc2610c, SRC_624842012270, SRC_05af2a65561e, SRC_687ede1c96fd, SRC_2c4d24110f12, SRC_d1eb1dfb0b13, SRC_60a5ba77bd93, SRC_c6315387ab5b, SRC_da44a87e0e2f, SRC_2268b327ce9b, SRC_57816ad3f5c0, SRC_e692312f9e83, SRC_a0b03f6fdb7a, SRC_f69ef4f54ae5

Preparation / proposed procedure:

1. Resolve the assessment requirements, unresolved source producers, and non-available software dependencies before running; configure the working directory, SAS librefs, Stata paths/globals, and SAS-to-Stata export handoffs with portable paths that preserve the supplied aliases.
2. Run the source-owned baseline in this order: Sister firms1.sas → Sister firms2.do → ESG ratings1.sas → ESG ratings2.do → Other ESG ratings1.sas → Other ESG ratings2.do → Controls.do → Merge.do.
3. After baseline inputs are ready, run each extension producer before its downstream analysis: DiD 1 year.do → 07.DiD regression 1 year.do; DiD 2 year.do → 08.DiD regression 2 year.do; Rating disagreement.do → 10.ESG rating disagreement.do; Business complexity measures.do → 11.Business complexity.do; Blockholder aum1.sas → Blockholder aum2.do before 13.Size and scale.do, 16.Ownership size_SRI proposals.do, and 17.Ownership size_UNPRI.do; Change in holdings1.sas → Change in holdings2.do → 14.Subsequent change in holdings.do; SRI proposals1.sas → SRI proposals2.do → 16.Ownership size_SRI proposals.do; ESG incidents.do → 18.ESG risk incidents.do; Violation indicators.do → 19.Regulatory violations.do.
4. Prepare and validate the manual four-field materiality crosswalk before 12.Materiality.do, and resolve PRI dates plus manager-number linking before 17.Ownership size_UNPRI.do; preserve these as source-specific inputs rather than inventing code or aliases.
5. Run all 19 analysis entrypoints after their required baseline and branch inputs are ready: 01.Summary statistics.do; 02.Baseline regressions.do; 03.Alternative blockholders.do; 04.Alternative sisters.do; 05.Alternative connection measure.do; 06.Matching.do; 07.DiD regression 1 year.do; 08.DiD regression 2 year.do; 09.Relative ESG ratings.do; 10.ESG rating disagreement.do; 11.Business complexity.do; 12.Materiality.do; 13.Size and scale.do; 14.Subsequent change in holdings.do; 15.Departed sisters.do; 16.Ownership size_SRI proposals.do; 17.Ownership size_UNPRI.do; 18.ESG risk incidents.do; 19.Regulatory violations.do. Respect only the producer-before-consumer dependencies above and leave independent branches unordered.
6. Hold 03.Alternative blockholders.do and 04.Alternative sisters.do until their exact author sample producers or supplied aliases and cutoffs are established; preserve the documented 4% blockholder and 5% sister alternatives separately from baseline settings.
7. At each SAS-to-Stata handoff, compare the actual exported alias, native fields, identifier/date keys, and effective-date coverage against the downstream source contract; verify portable cwd/librefs and expected output location before continuing.

Validation to perform later:

- Confirm the portable working directory, SAS librefs, Stata path configuration, software versions/availability, and each source-owned alias before a future authorized run.
- For all 39 exact entrypoints, confirm producer outputs and SAS-to-Stata exports exist with source-consumed fields and keys; check date/identifier history and branch-specific constructions without inventing transformations.
- Verify each of the 19 analysis programs consumes the intended baseline or branch output, and document unresolved alternative-sample or manual-input contracts rather than silently substituting data.
- Record actual execution results only after a separately authorized future run; this proposal itself is conditional and makes no execution claim.


## Remaining issues and prerequisites

- issue_alternative_samples [unresolved; full_pipeline]: The two alternative regression sample files are required by alternative analyses, but no supplied producer or documented same-data alias is established. Source comments document 4% large-shareholder and 5% sister cutoffs; do not infer a missing-data or access barrier.
- issue_10k_complexity_producer [unresolved; full_pipeline]: The program consumes `10k_firm_complexity.dta` and later saves the suffixed `_` output, but the upstream producer fields and construction handoff are not confirmed in the reviewed source evidence. Do not infer that code is absent or invent the transformation.
- issue_violation_basic_producer [unresolved; full_pipeline]: `violation_basic.dta` is consumed, but its exact producer, field construction, and relation to the raw Violation Tracker workbooks are unresolved. This remains an unresolved contract, not a conclusion that code or data are absent.
- issue_identifier_history [unresolved; full_pipeline]: The remaining author-specific CCM/PERMNO, CUSIP/GVKEY, GVKEY/CIK, and multi-provider CRSP/Compustat aliases require historical firm/security assignments and source-specific join rules. Bounded native probes establish only the listed local schemas, not the required populations, effective dates, or duplicate policies.
- issue_ibes_field_aliases [unresolved; full_pipeline]: The local IBES candidate exposes ANALYS/CURR while Controls uses analy/curr_act. They may be aliases, but the source semantics and current product mapping have not been inspected.
- issue_reprisk_gvkey [unresolved; full_pipeline]: The local RepRisk PM news candidate has no native GVKEY field, while ESG incidents consumes GVKEY; an identifier crosswalk and history rule are unresolved.
- issue_materiality_mapping [unresolved; full_pipeline]: The supplied code requires four manually mapped materiality fields by firm-year; the source does not provide the mapping table or assignments, and license/indicator coverage are unknown.
- issue_pri_manager_link [unresolved; full_pipeline]: The public PRI source identifies join dates but the author manager-number crosswalk, name changes, and historical status assignment remain unknown.
- issue_violation_parent_history [unresolved; full_pipeline]: Good Jobs First download access is subscriber-only; entitlement is unknown. The historical parent fields and construction of author `parent_violation.dta`/`violation_basic.dta` are not established by the available excerpt.
- req_thomson13f [undetermined]: S34 Type 1 manager/filing input referenced by the supplied SAS source. The frozen TFN.S34 catalog schema includes the source-required report date, filing date, manager number/name, and type code fields; the Type 1 alias/filter, product vintage, filing history, and live local access remain unverified.
- req_permno_gvkey [undetermined]: Author-prepared PERMNO-to-GVKEY/Compustat-name crosswalk used by the ownership join; effective-date logic and construction are unresolved.
- req_lm_complexity [public_acquisition_required]: Loughran–McDonald 10-K filing-complexity observations with CIK, filing date, complexity, and log file size. The official repository describes the compatible CSV product and 1996–2021 coverage; workbook conversion is ordinary preparation.
- req_comp_all [undetermined]: Author-prepared annual Compustat panel consumed as `comp_all.dta`; the local annual fundamentals candidate lacks native SIC/state and the package-specific history/derived fields need confirmation.
- req_comp_crsp_annual [undetermined]: Author-prepared firm-year Compustat/CRSP merged annual inputs (`prc`, `shrout`, `ret`) used to construct Controls; source and date-history rules remain unverified.
- req_ibes_detail [undetermined]: IBES detail forecasts used to construct analyst coverage; local IBES candidate field aliases differ from source names, and mapping/history coverage remain unresolved.
- req_comp_ibes_ticker [undetermined]: WRDS gvkey-to-IBES ticker crosswalk used to map annual firm records to forecast coverage; period-effective ticker mapping is not verified.
- req_io_timeseries [undetermined]: Quarterly firm-level institutional ownership input required to build controls; exact WRDS extract, field definitions, identifier, and period are unverified.
- req_red_blue [undetermined]: Author `red_blue.xlsx` classification input used by the controls/analysis workflow; its producer, fields, identifier, and period remain unresolved.
- req_s34type3 [undetermined]: S34 Type 3 holdings input is a distinct contract directly read by Sister firms1.sas, not a duplicate requirement for Type 1. The frozen TFN.S34 catalog schema includes the source-consumed filing date, manager number, CUSIP, and shares fields; the Type 3 filter, holdings grain, vintage, and full history remain unresolved.
- req_type4_holdings [undetermined]: Thomson Reuters Type 4 changes-in-holdings data used by the Change in holdings branch.
- req_reprisk_news [undetermined]: RepRisk negative ESG news input used to create annual ESG incident counts; the local news candidate lacks source-expected GVKEY, so identifier linking is unresolved.
- req_kld_esg_raw [undetermined]: Author KLD ESG input with indicator-strength/concern total fields; local KLD.HISTORY exposes only a limited native schema and does not establish author TOTAL-field compatibility.
- req_bloomberg_year_files [undetermined]: Raw Bloomberg ESG annual Excel inputs for 2004–2017, which the supplied SAS program imports and then concatenates; exact workbook vintage, fields, and authorized access remain unverified.
- req_refinitiv_asset4 [undetermined]: Refinitiv/Asset4 raw ESG product input used by the author import stage; exact source workbook, vintage, identifier fields, and access remain unverified.
- req_sustainalytics_raw [undetermined]: Sustainalytics historical weighted ESG workbook used for quarterly observations; product vintage, date coverage, and authorized access are unverified.
- req_tv_quarterly [undetermined]: Quarterly TruValue Labs ESG ranks consumed to construct annual insight scores; product vintage, fields, and access are unverified.
- req_legacy_shareholder_proposals [undetermined]: Legacy shareholder-proposal records retained through January 16, 2006; exact author file/version, fields, identifier mapping, and access are unverified.
- req_voting_analytics [undetermined]: Post-2006 Voting Analytics shareholder-proposal input; the brochure confirms product-era coverage and proposal fields, while exact file/version, fields, and access are unverified.
- req_cusip_gvkey [undetermined]: WRDS CUSIP-to-GVKEY link table used in the changes-in-holdings branch; historical link dates and sample-specific construction remain unresolved.
- req_gvkey_cik [undetermined]: Compustat GVKEY–CIK link used to join filing complexity and regulatory violations; the local company file lacks demonstrated year-effective history.
- req_esg_materiality [undetermined]: Manual SASB-sector materiality crosswalk with four author-consumed rating sets; the local mapping file and indicator assignments are not present as a verified route.
- req_pri_dates [undetermined]: PRI signatory join-date spreadsheet needed to construct manager PRI status; the official directory offers join dates, but the source’s manager-number mapping and full historical coverage are unresolved.
- req_parent_violation [undetermined]: Parent-violation crosswalk consumed by Violation indicators.do; author fields and at-time parent assignment are unresolved.
- req_violationtracker_basic [undetermined]: Good Jobs First Violation Tracker basic workbook named by the author package; download eligibility, exact 2021 vintage, and consumed fields are not verified.
- req_violationtracker_parents [undetermined]: Good Jobs First Violation Tracker parent workbook named by the author package; download eligibility, historical parent fields, and exact author use remain unverified.
- req_cc_id [undetermined]: CRSP/Compustat identifier crosswalk used by KLD, Refinitiv, Sustainalytics, TruValue, and proposal joins; exact CUSIP/PERMNO/GVKEY history and duplicate rules remain unresolved.
- winsor2 [preparation_required]: Existing typed metadata records winsor2 unavailable; source calls it in Controls and Change in holdings2.
- psmatch2 [unverified]: The source calls psmatch2; current software metadata contains no availability result for this exact command.
- eststo [unverified]: The source calls eststo; current software metadata contains no availability result for this exact command.
- SAS [unverified]: Existing typed metadata reports SAS as unverified; no SAS startup or source execution was performed.

## Review notes

- This is a static feasibility assessment of the complete 39-entry README-ordered workflow. It does not report execution success.
- Readme.rtf is a bounded inspected document but is not a registered source; the saved workflow trace preserves its observed order and all entrypoint hashes.
- All 177 frozen dependency IDs are covered. Generated classifications cite direct source producers; unknown producers remain unresolved issues rather than presumed outputs.
- One-row local probes establish only the recorded native schema/readability and result location, not full population, historical coverage, or semantic compatibility.
- No source code, data, SAS, Stata, or author program was executed; no data was downloaded and no access entitlement was inferred.
