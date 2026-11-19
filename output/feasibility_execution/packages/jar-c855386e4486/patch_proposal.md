# Patch proposal: jar-c855386e4486

ESG Rating Competition and Rating Quality

DOI: 10.1111/1475-679X.12624

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied R workflow: code1 prepares the samples, code2 runs the main difference-in-differences analyses, and code3 runs the additional, staggered, stacked, cross-sectional, and real-activity analyses in the same session.

Entry points: `code/code1_data cleaning.R`, `code/code2_main DiD.R`, `code/code3_additional.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 5/12624 - ESG-Rating-Competition-and-Rating-Quality/cdf-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "4d35149ab0b4587fcaad1d417cda7663e80ac7ac3104a14102b0d15f2977da11"
    },
    {
      "path": "JAR-Volume 63/Issue 5/12624 - ESG-Rating-Competition-and-Rating-Quality/cdf-online-appendix.pdf",
      "sha256": "1d3b9759aad4c19be3c34e0338aebc1d6405e948cec3942656cbc4cef9b52aea"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "391d06c0bf0448e3771a8268d4d2901746f8788a78e3cd5ba5cf37bca693c259"
}
```

## Proposed actions

### ACT_author_inputs: Obtain the authors' prepared input tables or missing object-loading/preparation steps, with a provider-to-object schema for every code-consumed input. For each source, identify the exact release/file, fields, identifiers and link rules, annual key, period/history, and construction into the named objects. Treat catalog entries as candidates until those mappings and compatible coverage are confirmed. After inputs and software setup are resolved, run the supplied R stages in the documented same-session order.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_compustat_fundamentals, REQ_compustat_security, REQ_sic_by_firm_year, REQ_sic_ffi48, REQ_asset4_core, REQ_kld_core, REQ_sustan_history, REQ_asset4_details, REQ_kld_details, REQ_reprisk_news, REQ_ibes_analyst_following, REQ_thomson_ownership, REQ_bbg_disclosure, REQ_corporate_report, REQ_violation_counts, REQ_trucost_emissions, REQ_return_variable, ISSUE_upstream_construction
Evidence: E_README_ORDER, E_DATASHEET_SOURCES, E_DATASHEET_DATES, E_CODE1_BASE_JOINS, E_CODE1_CONTROLS, E_CODE1_IO_ANALYST, E_CODE1_SIC_FF48, E_CODE1_TREATMENT, E_CODE1_KLD_SCORE, E_CODE1_METRIC_OUTPUTS, E_CODE1_DETAIL_CONCERNS, E_CODE1_RRNEWS_FILTER, E_CODE1_RRNEWS_LEAD, E_CODE3_STAGGERED, E_CODE3_IO_CXS, E_CODE3_REAL_INPUTS, E_CODE3_SUSTAN_INPUT, E_CAT_COMP_FUNDA, E_PROBE_COMP_FUNDA, E_CAT_COMP_SECURITY, E_PROBE_COMP_SECURITY, E_CAT_ASSET4, E_CAT_TRESG, E_CAT_KLD, E_PROBE_KLD, E_CAT_REPRISK, E_CAT_IBES, E_CAT_THOMSON, E_CAT_BBG, E_CAT_CORPORATE_REGISTER, E_PUBLIC_VT_GUIDE, E_PUBLIC_VT_PERIOD, E_CAT_TRUCOST, E_CAT_TRUCOST_S1, E_CAT_TRUCOST_S2, E_CAT_TRUCOST_YEAR, E_CAT_FF, E_CAT_FFI48, E_IDENTIFIER_PROBE, E_CODE2_REGSUMMARY, E_CODE3_REGSUMMARY

Preparation / proposed procedure:

1. Ask for the exact author-prepared firm-year panel and other named source/derived objects, or the omitted loaders and transformations that create them; a GVKEY identifier list alone is insufficient.
2. For Compustat, confirm the 2007–2017 fundamentals, historical GVKEY/security links, and prior-year equity used for ceq_lag; identify the separate source and definition of return.
3. Identify the firm-year SIC input and the SIC-to-ffi_48/ffi_12 crosswalk and versions.
4. Map the exact ASSET4 and KLD overall-score, detailed metric, concern, net-score, and populated/output inputs to the named objects; preserve the stated ASSET4–KLD match as a separate manual prerequisite.
5. Specify the Sustainalytics coverage history and 2009 score inputs; RepRisk incident/novelty/ISIN mapping and two-year lead history; I/B/E/S analyst-count annualization; Thomson Reuters ownership and IO_n aggregation; Bloomberg score and Corporate Register report schemas; Good Jobs First snapshot/matching fields; and Trucost GVKEY link, fiscal year, and requested measures.
6. Once these inputs are loaded and the required package providers are pinned, run code/code1_data cleaning.R, then code/code2_main DiD.R and code/code3_additional.R in the same R session, preserving code1/code2 objects needed downstream.

Validation to perform later:

- Before the ordered run, confirm every consumed object and field exists with the documented GVKEY/ISIN/CUSIP/ticker keys and compatible annual dates; verify the lag and t+2 history explicitly.
- After the ordered run, confirm the three scripts complete without missing-object/function errors and reconcile outputs to the documented sample windows and analyses; no execution has been verified in this assessment.

### ACT_manual_crosswalk: Obtain the author-created detailed ASSET4–KLD match or the exact matching instructions and source inputs. The supplied code consumes ratingcomponent by ISIN and fiscal year, and the datasheet identifies this as the workflow's manual step.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_ratingcomponent_manual, ISSUE_manual_crosswalk
Evidence: E_DATASHEET_MANUAL, E_CODE1_CROSSWALK, E_CODE1_METRIC_OUTPUTS

Preparation / proposed procedure:

1. Request the versioned ratingcomponent match table and the manual match rules, including the exact output fields and the Isin/fisyear key normalization.
2. If the authors supply instructions instead of the table, have them perform and document the original match before running the dependent analysis stages; do not infer matches from vendor metadata.

Validation to perform later:

- Confirm the matched table contains the fields consumed after the code1 join and covers the sample's required firm/year rows before the ordered R run.

### ACT_R_environment: Prepare an R project library with the missing required packages and resolve the exporting packages and versions for ebalance and Winsorize from the authors' setup. Do not substitute functions or estimators.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_dplyr, SW_matrixStats, SW_lfe, SW_ebalance, SW_Winsorize, ISSUE_R_packages
Evidence: E_ENV_REGISTERED, E_R_PACKAGE_METADATA, E_CODE1_MATRIXSTATS, E_CODE1_BASE_JOINS, E_CODE2_ANALYSIS, E_CODE1_CONTROLS, E_CODE1_EBALANCE

Preparation / proposed procedure:

1. Request the author's R/package version manifest or startup instructions, especially the exporters of ebalance and Winsorize.
2. Install/configure the confirmed compatible dplyr, matrixStats, lfe, and entropy-balancing/Winsorize providers in an isolated R project library; record versions and required attachment/namespace setup.

Validation to perform later:

- In the prepared project environment, verify each required function resolves from the pinned package setup before loading data, then use the documented same-session script order.


## Remaining issues and prerequisites

- ISSUE_upstream_construction [unresolved; full_pipeline]: All three scripts operate on pre-existing in-memory objects. The README describes the stage sequence, but the package lacks the input loaders/object constructors and the product-to-field/key/date mappings needed to reconstruct those objects. Several required outputs also depend on unspecified one-year equity lag, annual identity crosswalks, and a two-year RepRisk lead window. A full prepared analysis panel is absent, so no analysis_only scope is supported.
- ISSUE_manual_crosswalk [unresolved; full_pipeline]: The documented manual ASSET4–KLD detailed-metric match is required to create the ratingcomponent object consumed in code1, but its matched rows and matching rules are not included.
- ISSUE_R_packages [preparation; full_pipeline]: The R analysis calls dplyr verbs, rowSds from matrixStats, felm, ebalance, and Winsorize. R 4.5.0 is available, but a metadata-only installed-package check found dplyr, matrixStats, lfe, ebal, and DescTools absent. The package-provider/version setup for ebalance and Winsorize is not pinned in the supplied scripts.
- REQ_compustat_fundamentals [undetermined]: Annual Compustat fundamentals for the firm-year panel. The code uses GVKEY, fiscal year, assets, equity, shares, current/long-term debt, income, sales, and fiscal-year price to form market capitalization, market-to-book, leverage, and ROE; ROE needs a one-year lag of equity. The supplied COMP.FUNDA candidate has a one-row field/readability check, but full history, return data, and construction of ceq_lag are not established.
- REQ_compustat_security [undetermined]: Historical security-to-GVKEY identity fields for the code's ISIN, CUSIP, ticker, and GVKEY joins. A current field/readability probe is not evidence that historical links and selection rules match the sample years.
- REQ_sic_by_firm_year [undetermined]: The pre-existing sic_US firm-year object joined on GVKEY and fiscal year supplies SIC and is used to exclude selected industries. Its product, fields, history, and construction are not identified by the supplied sources.
- REQ_sic_ffi48 [undetermined]: The sic_ffi crosswalk must map SIC to ffi_48 for regression clusters and industry-year groups; code3 also consumes ffi_12. No compatible crosswalk source, version, or producer is identified.
- REQ_asset4_core [undetermined]: Annual ASSET4 coverage and overall-score panel consumed as asset4, including ISIN and year joins and overall_score for the rating and treatment samples. The ASSET4 product/table and field mapping are not established by the local metadata candidates.
- REQ_kld_core [undetermined]: Annual KLD rating panel consumed as kld, joined by CUSIP and year and used to construct the net rating index. The local KLD.HISTORY probe only confirms a readable candidate and sampled year/CUSIP fields; score fields, transformations, and coverage are not verified.
- REQ_sustan_history [undetermined]: Sustainalytics objects historical_score_weighted and sustan_2009 provide first-coverage treatment timing and 2009 total_esg_score. The data sheet dates a legacy shared sample to September 2019 but supplies no file, source schema, mapping, or complete historical coverage evidence.
- REQ_asset4_details [undetermined]: ASSET4 detail, output, and concern objects (asset4_detail, as4_output, asset4_con) are used to calculate populated/input/output metrics and concern ratings. Their exact input tables, identifiers, year keys, fields, and construction are not supplied.
- REQ_kld_details [undetermined]: KLD detailed concern/net and populated/output objects (kld_CC, kld_simple, KLD_output) are separately consumed to construct net and concern scores and input/output metric counts. Required score/category fields and producer steps are not identified.
- REQ_reprisk_news [undetermined]: Raw RepRisk news object RRnews must provide incident_date, novelty, and primary_isin; the code filters novel items, counts by firm/year, and derives one- and two-year leads before joining news outcomes. Exact aggregation/input mapping is absent.
- REQ_ibes_analyst_following [undetermined]: I/B/E/S analyst-following data must support the analystnum and analyst_log columns merged through compustat_io on GVKEY and fiscal year. The downloaded product, identifiers, annual aggregation, and construction are not specified.
- REQ_thomson_ownership [undetermined]: Thomson Reuters institutional ownership input must support io_perc and the separate io_cxs.IO_n firm/year measure used in cross-sectional splits. Exact holdings aggregation, firm identity mapping, and annual-period definitions are unknown.
- REQ_bbg_disclosure [undetermined]: Bloomberg ESG Disclosure score input BBG must provide ticker, year, and ESG_dis_score for the code's annual join. The local product route and input mapping are not verified.
- REQ_corporate_report [undetermined]: Corporate Register report indicator input CSR_Report must support Symbol, year2, and Report for the code's ticker/year join. The report data, year parsing from report titles, and prepared indicator construction are absent.
- REQ_violation_counts [undetermined]: The VT_exist input must supply ISIN, penalty year, and violation count for the code's annual merge. The authors say violation data were obtained from Good Jobs First as of 11 January 2022; a compatible snapshot, fields, and firm/year mapping are not established.
- REQ_trucost_emissions [undetermined]: The truecost input must contain GVKEY, fiscalyear, di_319407, and di_319408 for the emission intensity calculation. Catalog metadata confirms candidate Trucost measures and fiscalyear, but the firm-key mapping, complete source schema, and construction are not verified.
- REQ_ratingcomponent_manual [undetermined]: The manually matched ASSET4–KLD detailed-metric crosswalk embodied in ratingcomponent is joined on ISIN and fiscal-year keys and provides matched rating variables. The data sheet identifies this sole manual procedure; the crosswalk and its match rules are not present in the supplied files.
- REQ_return_variable [undetermined]: The firm-year return variable is required in the sample completeness filter and multiple regressions, but the supplied files do not identify its provider, raw field, return definition, fiscal/calendar-year mapping, or producer.
- SW_dplyr [preparation_required]: The supplied code uses dplyr joins/grouping/reshaping verbs, with some explicit dplyr:: calls and other unqualified calls. Metadata inspection reports dplyr absent from the current R library; the project must configure a compatible package version and attach or qualify it before running.
- SW_matrixStats [preparation_required]: code1 explicitly loads matrixStats and uses rowSds. Metadata inspection reports matrixStats absent from the current R library.
- SW_lfe [preparation_required]: The main and additional models call felm. Metadata inspection reports lfe absent from the current R library; the scripts do not include package setup or a pinned version.
- SW_ebalance [unverified]: The supplied preparation code calls ebalance for entropy balancing, but does not identify the exporting package/version. The checked ebal package name is absent from the current R library, which does not by itself establish the function's provider.
- SW_Winsorize [unverified]: The supplied code calls Winsorize but does not identify its exporting package/version. The checked DescTools package name is absent from the current R library, which does not by itself establish the function's provider.

## Review notes

- The frozen dependency checklist is empty. Dependencies were traced manually through all three supplied R scripts; no dependency IDs were invented.
- The packaged identifiers.csv probe sampled an identifier list (GVKEY only), not a prepared firm-year analysis panel. No analysis_only scope is supported by the supplied inputs.
- Catalog results are candidates only, and successful one-row probes establish sampled readability/fields rather than historical coverage or entitlement. The initial Compustat probe requested a field absent from the catalog; the corrected bounded probe is cited instead. Failed RepRisk/Trucost field probes and the official-site 403 open attempts are process history only, not evidence that data are absent. Violation Tracker public snippets support a restriction on one download method only; the public route remains unverified.
- The registered safe environment projection reports R 4.5.0. R package availability was checked from installed-package metadata only. No author code, data analysis, or statistical model was executed; execution_verified remains false.
