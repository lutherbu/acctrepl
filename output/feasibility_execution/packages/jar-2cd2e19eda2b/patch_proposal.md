# Patch proposal: jar-2cd2e19eda2b

Financial Reporting Quality, Turnover Risk, and Wage Differentials: Evidence from Worker-level Data

DOI: 10.1111/1475-679X.12477

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Full author-documented workflow: manually construct employee-firm-state-year and firm-state-year panels, then run the documented analyses with companion inputs. The supplied PDFs provide substantive procedures but no executable preparation or analysis program and no prepared analysis dataset.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 4/12477 - Financial-Reporting-Quality-Turnover-Risk-and-Wage-Differentials-Evidence-from-Worker-level-Data/cgm-datasheet-and-detailed-steps-document.zip",
      "sha256": "02d4d3ff1c9ee906e8c5b90764bedb5267815df344796314ace441c759102e0d"
    },
    {
      "path": "JAR-Volume 61/Issue 4/12477 - Financial-Reporting-Quality-Turnover-Risk-and-Wage-Differentials-Evidence-from-Worker-level-Data/cgm-online-appendix.pdf",
      "sha256": "900b76c2df4b6be7a84dda56a085804f621ba30b7c64943b64cc41c8f3ba836e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "b349dce35181abe5a850f2061c9d0828a95cdc62281b3f28e20d7cdaf3411095"
}
```

## Proposed actions

### action_census_access_and_contract: Before the Census-dependent preparation stages, verify that the target researchers have an approved RDC project and an authorized execution location. In that approved setting, identify the exact LEHD ECF/EHF/ICF/QWI, CSB, and SSEL file versions and their allowed years/fields; document the project-specific join keys, source-variable mapping, and approved manual sequence without moving restricted records outside the enclosure.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: issue_census_contract_and_access, req_lehd_icf, req_lehd_ecf, req_lehd_ehf, req_lehd_qwi, req_csb, req_ssel
Evidence: src_census_restriction, src_census_inventory, src_datasheet_sources, src_employee_recipe, src_qwi_recipe

Preparation / proposed procedure:

1. Verify current project approval and the permitted Census execution environment through the approved project channel.
2. Inventory only the authorized LEHD, CSB, and SSEL inputs inside that environment; record native fields, identifiers, years, and file/schema versions.
3. Resolve the documented order: sample/prepare ICF; prepare the ECF establishment-state-year-firm map; merge EHF to ICF then to the firm map; match firms to Compustat through CSB/CUSIP/year, then SSEL/EIN and the documented name-industry-location fallback; prepare the QWI firm-state-year branch using the same establishment map.
4. Keep all restricted data and resulting confidential microdata within the approved Census environment.

Validation to perform later:

- In a separately authorized run, validate source access, schema/identifier compatibility, year coverage, and the exact generated-panel keys within the approved enclosure.

### action_measure_mapping: Resolve the financial and real-wage field contract using the named annual Compustat and CRSP products, the readable local candidates where compatible, and an identified 2010-base CPI source. Verify the WRDS/SAS acquisition route only for the needed products; do not require the historical vendor byte versions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_measure_construction, req_compustat_funda, req_crsp_stock, req_cpi_series, sw_sas, sw_wrds
Evidence: src_vendor_inventory, src_financial_recipe, src_employee_recipe, src_appendix_cpi, src_datasheet_sources, cat_comp_funda, cat_crsp_msf, probe_comp_funda, probe_crsp_msf, pub_wrds_access

Preparation / proposed procedure:

1. For the local COMP.FUNDA and CRSP.MSF candidates, identify the exact author-consumed source fields, identifiers, reporting units, frequency, and observation years; determine whether the readable local files satisfy those contracts.
2. Map cash-flow accruals, earnings, accrual/cash-flow levels and changes, firm controls, M&A activity, and returns volatility to source fields and documented transformations.
3. Identify the actual CPI series/product and field used for the appendix’s 2010-base annual real-wage calculation, with required years and frequency.
4. If a compatible local route is unavailable, verify the permitted WRDS/provider subscription route and the SAS download path required by the datasheet. Treat acquisition dates as provenance rather than a byte-identity gate.

Validation to perform later:

- In a separately authorized run, check exact field, identifier, period, currency, frequency, CPI-base-year, and construction mappings against the confirmed source files without changing definitions or estimators.

### action_program_availability: The package's author workflow is prose-only. Identify the approved in-project location and permitted runnable form of the preparation and table-analysis programs, if available under the applicable Census/project policy; do not assume program transfer is permitted.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_no_executable_programs
Evidence: src_no_programs, src_datasheet_sources

Preparation / proposed procedure:

1. Retain the detailed memo as the documented manual sequence and identify which project-approved programs or in-facility steps actually materialize the two panels and each documented analysis.
2. Confirm that any program is available and authorized in the same approved project context; the datasheet says program transfer between project drives is restricted unless an author is on both projects.
3. If no executable program can be made available, retain the package as a manual specification and do not mark it runnable.

Validation to perform later:

- A future approved attempt must inventory the exact executable entry points and versions, then execute only within the authorized project environment.

### action_companion_products: Resolve the author-specific Audit Analytics, Bloomberg, and Refinitiv inputs and their identifiers, histories, product versions, and permitted access routes. Use local table candidates only after confirming their exact field/product compatibility.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_companion_contract, req_audit_analytics_opinion, req_audit_analytics_sox404, req_bloomberg_esg, req_refinitiv_esg, sw_wrds, sw_bloomberg_terminal, sw_refinitiv_workplace
Evidence: src_companions_recipe, src_vendor_inventory, cat_audit_candidates, cat_refinitiv_candidates, probe_audit_feed11, probe_audit_feed34, probe_tresg_summary, probe_tresg_company_info, pub_audit_analytics_pricing, pub_audit_analytics_feeds, pub_bloomberg_scores, pub_refinitiv_history, pub_refinitiv_entitlement

Preparation / proposed procedure:

1. Identify the exact Audit Analytics Auditor Opinion source for fiscal year ending 2001 and document how its auditor classification and CIK merge key are represented; do not substitute Compustat AUOP/AUOPIC without author evidence.
2. For the 2004–2012 internal-control-weakness sample, determine which local/provider fields encode report announcement, weakness classification, one-time report, later remediation, fiscal year, and the company-to-CIK crosswalk.
3. Identify the author-matching Bloomberg disclosure-quality score field/version and firm-year history from 2008, and verify the CIK-first/CUSIP-fallback merge and current authorized Terminal/Data License route.
4. Identify the Refinitiv Workplace summary score field and company/year mapping from 2002; verify the ticker match and current authorized local/Workplace route.
5. Verify only the project’s current subscriptions or permissions through its authorized account context; do not infer them from local catalog matches or vendor terms.

Validation to perform later:

- In a separately authorized run, confirm the selected product fields, score variants, identifier crosswalks, required year coverage, nonmissing-score rules, and the author’s Table 8/Table 9 sample rules.

### action_psid_public_inputs: Use the official PSID public-use data and documentation route after registration, then identify the exact 1976–2013 files, codebooks, and variables needed for the author’s Table 5 job-history specification.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: issue_companion_contract, req_psid_data, req_psid_codebooks
Evidence: src_psid_recipe, pub_psid_access, pub_psid_docs

Preparation / proposed procedure:

1. Register for the PSID Public Data Center and accept its Conditions of Use when a future acquisition is authorized.
2. Select the author-required 1976–2013 records and the two described codebook periods, 1976–2001 and 2003–2013.
3. Map the actual employment/job, household-head, non-sample, and education variables to the documented rules and resolve the every-other-year job-history assumptions before building Table 5 inputs.

Validation to perform later:

- In a separately authorized run, confirm the downloaded file versions, years, variables, codebook mappings, and person/job construction against the author recipe.

### action_software_setup: Verify the named manual acquisition interfaces and runtime only in the appropriate project account or authorized execution environment. Their present user-level availability is not established.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_sas, sw_wrds, sw_bloomberg_terminal, sw_refinitiv_workplace
Evidence: src_datasheet_sources, src_companions_recipe, probe_environment_software, pub_wrds_access, pub_bloomberg_scores, pub_refinitiv_entitlement

Preparation / proposed procedure:

1. In a future authorized setup check, verify the SAS runtime used for WRDS downloads; the existing startup error leaves it unverified and does not establish license absence.
2. Verify the current WRDS database subscription for Compustat/CRSP if the local compatible files cannot be used.
3. Verify an authorized Bloomberg Terminal/Data License route and Refinitiv Workplace entitlement for the exact required ESG scores.

Validation to perform later:

- Record runtime/interface versions and account entitlements for each product route before beginning the manual preparation sequence; keep restricted Census work in its approved setting.


## Remaining issues and prerequisites

- issue_no_executable_programs [blocking; full_pipeline]: The release contains detailed prose recipes but no executable preparation or analysis program, runnable driver, or complete machine-readable variable-construction implementation. The full author-documented workflow cannot be launched from this release.
- issue_census_contract_and_access [unresolved; full_pipeline]: The author workflow requires restricted Census LEHD/CSB/SSEL inputs in an approved RDC setting. Current project authorization and exact source files, fields, observation years, and match contracts are not established; historical author access/server transfer does not establish current user access.
- issue_measure_construction [unresolved; full_pipeline]: The memo names Compustat/CRSP, sample controls, accrual/cash-flow/earnings measures, return volatility, and an annual real-wage CPI adjustment, but it does not map all native fields, frequencies, identifiers, transformations, source histories, or the CPI product. Local annual Compustat and monthly CRSP metadata are candidates only and do not close these gaps.
- issue_companion_contract [unresolved; full_pipeline]: The author recipe names Audit Analytics auditor-opinion/SOX 404, PSID, Bloomberg disclosure scores, and Refinitiv ESG performance scores, but exact table/file selections, source fields/history, score variants, CIK/CUSIP/ticker crosswalks, and compatible PSID variables remain incomplete. Readable local FEED11/FEED34 and TRESG tables are candidates, not verified substitutes for the author inputs.
- req_lehd_icf [undetermined]: LEHD Individual Characteristics Files used for employee-level sex, date of birth, education, and worker dummy construction; the memo reports sampling 1% of employees. Current source schema, version-specific fields, and available study years are not supplied.
- req_lehd_ecf [undetermined]: LEHD Employer Characteristics Files used for establishment industry/location and internal establishment/firm identifiers to build the establishment-state-year-firm map; exact source fields and version/year coverage remain unspecified.
- req_lehd_ehf [undetermined]: LEHD Employment History Files with establishment-employee-state-year wage observations, used with ICF to build the employee-firm-state-year panel. The exact observation years and source schema are not supplied.
- req_lehd_qwi [undetermined]: LEHD Quarterly Workforce Indicators inputs for full-time accessions/separations and employment at the beginning and end of each year, used to construct establishment-level turnover and then a firm-state-year panel. Exact QWI measure names and source-year coverage are unspecified.
- req_csb [undetermined]: Compustat–SSEL Bridge, used for year-specific links between CUSIP and Census internal firm identifiers; exact bridge fields, period coverage, and join contract are not supplied.
- req_ssel [undetermined]: Standard Statistical Establishment List/Business Register data used for establishment EIN and internal firm identifiers, plus name/industry/location matching to Compustat for unmatched records; exact files, keys, and period coverage are not supplied.
- req_compustat_funda [undetermined]: Compustat Fundamentals Annual records used to link public firms and supply financial-reporting-quality measures and firm controls, including size, Tobin's Q, leverage, return on assets, tangible assets, M&A activity, and returns volatility. Exact native variables and construction mappings are not supplied.
- req_crsp_stock [undetermined]: CRSP Stock Security Files are named as an input source. Their specific consumed fields, role in the supplied manual workflow, join identifiers, and needed history are not mapped in the available documents; the memo lists returns volatility among required firm controls.
- req_audit_analytics_opinion [undetermined]: Audit Analytics auditor-opinion records used to identify former Arthur Andersen clients for fiscal years ending in 2001; CIK is the documented merge key. Exact native table/flag fields remain unspecified.
- req_audit_analytics_sox404 [undetermined]: Audit Analytics SOX 404 internal-control records used to identify weaknesses announced in 2004–2012, firms reporting once and resolving in a subsequent year, merged by CIK. Exact native fields and announcement/remediation mapping remain unspecified.
- req_psid_data [undetermined]: PSID data used for Table 5, spanning 1976–2013; the memo applies job-history, household-head, non-sample, and education-variable rules. Exact downloaded files and consumed variables remain unspecified.
- req_psid_codebooks [undetermined]: PSID code books used to interpret the 1976–2001 and 2003–2013 variables; the required code books are not included in this package.
- req_bloomberg_esg [undetermined]: Bloomberg ESG disclosure scores by firm-year from 2008, joined by CIK and then CUSIP for unmatched observations; observations require a nonmissing score. Exact historical coverage and vendor fields are unspecified.
- req_refinitiv_esg [undetermined]: Refinitiv ESG performance summary scores by firm-year starting in 2002, joined to the worker-firm panel using ticker; observations require nonmissing relevant scores. Exact score field and coverage are unspecified.
- req_cpi_series [undetermined]: A Consumer Price Index series with base year 2010 is needed to construct the documented inflation-adjusted annual wage. The memo and appendix do not name the CPI source, product, native field, frequency, or year coverage; no replacement series is inferred.
- sw_sas [unverified]: The datasheet says WRDS public data were downloaded through SAS. The assigned shared environment snapshot records a SAS startup initialization error and marks runtime availability unverified; it does not establish absence of a license or user access.
- sw_wrds [unverified]: WRDS is the named route for public Compustat/CRSP data; the current project subscription and database entitlements are unknown.
- sw_bloomberg_terminal [unverified]: The memo says authors accessed Bloomberg ESG scores through a Bloomberg terminal. Current terminal availability, account access, and matching score product are unknown.
- sw_refinitiv_workplace [unverified]: The memo says authors accessed Refinitiv ESG data through Workplace. Current product, account entitlement, and author-specific score field are unknown.

## Review notes

- The three supplied PDFs were read in full. The detailed memo provides substantive ordered manual recipes for an employee-firm-state-year panel and a firm-state-year turnover panel, the PSID sequence, vendor merge rules, and table/figure inputs. The appendix confirms annual real wages use CPI (2010), but names no CPI series. The datasheet says preparation and analysis programs are unavailable because they contain proprietary information.
- No executable program or prepared analysis dataset is supplied. The package is assessed as literal no_runnable_code while crediting its detailed manual workflow; the analysis-only scope is not supported.
- One-row metadata checks established readable local candidates COMP.FUNDA, CRSP.MSF, Audit Analytics FEED11/FEED34, and Refinitiv TRESG summary/company-info tables. Their product/version, historical coverage, exact author fields, identifiers, transformations, and crosswalk compatibility remain unverified. A catalog miss for LEHD/CSB/SSEL, PSID, or Bloomberg is not evidence that the user lacks project approval or a license.
- Historical vendor acquisition/access dates are provenance only. The assessment does not require byte-identical 2017/2019/2020/2022 vendor files; each route remains conditioned on documented fields, history, identifiers, and compatibility.
- Official static product/access pages were checked on 2026-11-11. They describe general FSRDC, registration, subscriber, or product conditions, but do not establish this user’s Census approval, WRDS/vendor subscription, Bloomberg Terminal, or Refinitiv Workplace access.
- Process-only failures are preserved under probes: the initial secret-safe reader call failed before displaying source text and was corrected; a frozen-snapshot lookup CLI lacked a sibling module and was replaced with direct read-only catalog metadata searches; metadata-history logging first used an incorrect frozen-module path and a relative output directory, then was corrected. These failures did not execute author code, query source data, or supply assessment evidence.
