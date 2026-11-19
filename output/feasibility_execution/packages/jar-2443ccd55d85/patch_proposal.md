# Patch proposal: jar-2443ccd55d85

Reciprocity in Corporate Tax Compliance– Evidence from Ozone Pollution

DOI: 10.1111/1475-679X.12500

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author workflow: native SAS preparation and its Stata consumers. The archive contains substantial programs but no prepared full analysis panel; Stata consumes SAS-produced handoffs, so no analysis_only scope is supported.

Entry points: `CFHLL_sas.sas`, `CFHLL_stata.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 5/12500 - Reciprocity-in-Corporate-Tax-Compliance-Evidence-from-Ozone-Pollution/cfhll-datasheet-code-and-identifiers.zip",
      "sha256": "1a2dd2056bfa083f2134c2fe4da49bfae6f640c41bfe8e1244617d2d64768be5"
    },
    {
      "path": "JAR-Volume 61/Issue 5/12500 - Reciprocity-in-Corporate-Tax-Compliance-Evidence-from-Ozone-Pollution/cfhll-online-appendix.pdf",
      "sha256": "59a3f93d4a702dc755f6269982eb279b7efc277bfa74604c8ea856a09030a6a7"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "74b527843a866c146ba9db07b1dc3e7e4944a84427c67e27fb2cf4635aabb26d"
}
```

## Proposed actions

### A_OZONE_PACKAGE: Reuse the 29 supplied ozone CSVs as the primary input and preserve the authored county/year timing.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: OZONE_PANEL
Evidence: E_DOC_OZONE, E_OZONE_ALL_PROBES, E_ETR_FORWARD_WINDOW, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the supplied conreport1990.csv through conreport2018.csv without redownloading.
2. In a later authorized run, confirm the configured relative root and imported County Code/Ozone 4th Max 8-hr fields.
3. Treat the 29 one-row probes as header/readability evidence only; check county-year coverage during that authorized run.

Validation to perform later:

- Confirm the input root and source fields without changing the t, t−1, t+1 joins.

### A_CENSUS_COUNTY_RAW: Identify or acquire the exact documented source for CENSUS_COUNTY_RAW, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: CENSUS_COUNTY_RAW
Evidence: E_DOC_CENSUS, E_PUBLIC_CENSUS_AGE, E_PUBLIC_CENSUS_1990, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_RELIGION_INPUT: Identify or acquire the exact documented source for RELIGION_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: RELIGION_INPUT
Evidence: E_DOC_ARDA, E_PUBLIC_ARDA, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_SOCIAL_CAPITAL_INPUT: Identify or acquire the exact documented source for SOCIAL_CAPITAL_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: SOCIAL_CAPITAL_INPUT
Evidence: E_DOC_SOCIAL, E_PUBLIC_NERCRD, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_RESPONSE_RATE_INPUT: Confirm the exact author-provided source/schema/history for RESPONSE_RATE_INPUT; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: RESPONSE_RATE_INPUT
Evidence: E_DOC_SOCIAL, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_NOAA_HOURLY_INPUT: Identify or acquire the exact documented source for NOAA_HOURLY_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: NOAA_HOURLY_INPUT
Evidence: E_DOC_NOAA, E_PUBLIC_NOAA, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_WEATHER_STATION_LOOKUP: Identify or acquire the exact documented source for WEATHER_STATION_LOOKUP, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: WEATHER_STATION_LOOKUP
Evidence: E_DOC_NOAA, E_PUBLIC_NOAA, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_COUNTY_CENTROID_INPUT: Confirm the exact author-provided source/schema/history for COUNTY_CENTROID_INPUT; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: COUNTY_CENTROID_INPUT
Evidence: E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_CITY_COUNTY_LINK: Identify or acquire the exact documented source for CITY_COUNTY_LINK, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: CITY_COUNTY_LINK
Evidence: E_DOC_SIMPLEMAPS, E_PUBLIC_SIMPLEMAPS, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_GOOGLE_TRENDS_INPUT: Identify or acquire the exact documented source for GOOGLE_TRENDS_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: GOOGLE_TRENDS_INPUT
Evidence: E_DOC_TRENDS, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_FEC_INPUTS: Identify or acquire the exact documented source for FEC_INPUTS, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: FEC_INPUTS
Evidence: E_DOC_FEC, E_PUBLIC_FEC, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_EXECUCOMP_INPUT: Identify the exact author-provided source contract for EXECUCOMP_INPUT before choosing an acquisition route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: EXECUCOMP_INPUT
Evidence: E_DOC_EXEC, E_EXEC_PROBE, E_CATALOG_FIELDS, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Locate the author file/table through the described replication-kit materials.
2. Confirm schema, identifiers, years, transformations and delivery terms; do not independently reconstruct undocumented input.

Validation to perform later:

- Compare the confirmed contract with exact source reads before execution.

### A_SASHELP_ZIPCODE: Confirm SASHELP.ZIPCODE is present with the ZIP/MSA columns in the configured SAS installation.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SASHELP_ZIPCODE
Evidence: E_DOC_SASHELP, E_ENVIRONMENT, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use permitted static installation metadata only; do not start SAS or run startup files.
2. If unavailable, resolve the author-specified SASHELP table source.

Validation to perform later:

- Confirm ZIP and MSA columns and table vintage before execution.

### A_TTI_TRAFFIC_INPUT: Identify or acquire the exact documented source for TTI_TRAFFIC_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: TTI_TRAFFIC_INPUT
Evidence: E_DOC_TTI, E_PUBLIC_TTI, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_MSA_COUNTY_CROSSWALK: Identify or acquire the exact documented source for MSA_COUNTY_CROSSWALK, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: MSA_COUNTY_CROSSWALK
Evidence: E_SAS_MSA, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_VIOLATION_TRACKER_INPUT: Identify or acquire the exact documented source for VIOLATION_TRACKER_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: VIOLATION_TRACKER_INPUT
Evidence: E_DOC_GJF, E_PUBLIC_GJF, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_AGE_CENSUS_INPUT: Identify or acquire the exact documented source for AGE_CENSUS_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: AGE_CENSUS_INPUT
Evidence: E_DOC_CENSUS, E_PUBLIC_CENSUS_AGE, E_PUBLIC_CENSUS_1990, E_SAS_AGE, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_BRFSS_INPUT: Identify or acquire the exact documented source for BRFSS_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: BRFSS_INPUT
Evidence: E_DOC_BRFSS, E_PUBLIC_BRFSS, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_QCEW_INPUT: Identify or acquire the exact documented source for QCEW_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: QCEW_INPUT
Evidence: E_DOC_QCEW, E_PUBLIC_QCEW_LAYOUT, E_PUBLIC_QCEW_FILES, E_SAS_QCEW, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_BEA_COUNTY_INPUT: Identify or acquire the exact documented source for BEA_COUNTY_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: BEA_COUNTY_INPUT
Evidence: E_DOC_BEA, E_PUBLIC_BEA, E_SAS_BEA, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_COMPUSTAT_SNAPSHOT: Confirm the exact author-provided source/schema/history for COMPUSTAT_SNAPSHOT; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: COMPUSTAT_SNAPSHOT
Evidence: E_DOC_COMP, E_COMP_SNAPSHOT_MISS, E_CATALOG_FIELDS, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_COMPUSTAT_FUNDA: Confirm the exact author-provided source/schema/history for COMPUSTAT_FUNDA; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: COMPUSTAT_FUNDA
Evidence: E_DOC_COMP, E_COMP_FUND_PROBE22, E_ETR_FORWARD_WINDOW, E_CATALOG_FIELDS, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_SIC_CLASSIFICATION_INPUT: Confirm the exact author-provided source/schema/history for SIC_CLASSIFICATION_INPUT; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SIC_CLASSIFICATION_INPUT
Evidence: E_DOC_COMP, E_SAS_SIC, E_COMP_FUND_PROBE22, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_STATUTORY_TAX_INPUT: Identify or acquire the exact documented source for STATUTORY_TAX_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: STATUTORY_TAX_INPUT
Evidence: E_DOC_CSG, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_PERMNO_CUSIP_LINK: Confirm the exact author-provided source/schema/history for PERMNO_CUSIP_LINK; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: PERMNO_CUSIP_LINK
Evidence: E_DOC_COMP, E_SAS_OWNERSHIP, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_INSTITUTIONAL_OWNERSHIP: Confirm the exact author-provided source/schema/history for INSTITUTIONAL_OWNERSHIP; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: INSTITUTIONAL_OWNERSHIP
Evidence: E_DOC_13F, E_SAS_OWNERSHIP, E_TFN_TIMEOUT, E_CATALOG_FIELDS, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_GVKEY_CIK_LINK: Confirm the exact author-provided source/schema/history for GVKEY_CIK_LINK; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: GVKEY_CIK_LINK
Evidence: E_SAS_GVKEY_CIK, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_CORPORATE_CULTURE: Confirm the exact author-provided source/schema/history for CORPORATE_CULTURE; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: CORPORATE_CULTURE
Evidence: E_DOC_CULTURE, E_SAS_CULTURE_CEO, E_DOC_OTHER_DATA, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_CEO_BIRTHPLACE: Confirm the exact author-provided source/schema/history for CEO_BIRTHPLACE; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: CEO_BIRTHPLACE
Evidence: E_DOC_CEO, E_SAS_CULTURE_CEO, E_DOC_OTHER_DATA, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_COUNTY_FINANCE_INPUT: Identify or acquire the exact documented source for COUNTY_FINANCE_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: COUNTY_FINANCE_INPUT
Evidence: E_DOC_FINANCE, E_PUBLIC_WILLAMETTE, E_SAS_FINANCE, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_NONATTAINMENT_INPUT: Identify or acquire the exact documented source for NONATTAINMENT_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: NONATTAINMENT_INPUT
Evidence: E_DOC_OZONE, E_PUBLIC_GREENBOOK, E_SAS_NONATT, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_CCES_INPUT: Identify or acquire the exact documented source for CCES_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: CCES_INPUT
Evidence: E_DOC_SURVEYS, E_PUBLIC_CCES, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_CCES_COUNTY_FIPS_LOOKUP: Confirm the exact author-provided source/schema/history for CCES_COUNTY_FIPS_LOOKUP; local candidates and catalog hits are not compatibility proof.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: CCES_COUNTY_FIPS_LOOKUP
Evidence: E_SAS_FIPS, E_DOC_CENSUS, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact table/file, library mapping, field names, identifiers and full history used by the supplied code.
2. Keep prepared tables distinct from raw candidates and validate date/key semantics; do not infer licensing or absence from catalog misses, a field request or a timeout.

Validation to perform later:

- Compare the confirmed source contract with the exact source joins before any authorized run.

### A_PEW_WAVE33: Identify or acquire the exact documented source for PEW_WAVE33, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: PEW_WAVE33
Evidence: E_DOC_SURVEYS, E_PUBLIC_PEW, E_PUBLIC_PEW_INDEX, E_SAS_PEW_IMPORT, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_ANES_SENSITIVE: Resolve exact ANES wave/geocode products through the documented authorized ICPSR process.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: ANES_SENSITIVE
Evidence: E_DOC_ANES, E_PUBLIC_ANES, E_STATA_ANES, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the exact sensitive waves, county geocodes and variables required by source.
2. Use the applicable authorized ICPSR/VDE process; this audit did not submit a request or contact anyone.
3. Keep the authorized data in its approved environment.

Validation to perform later:

- Before any authorized run, verify approved access, waves, fields and county/year mapping.

### A_NPL_INPUT: Identify or acquire the exact documented source for NPL_INPUT, then verify its fields, years, identifiers and format against the supplied program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: NPL_INPUT
Evidence: E_DOC_NPL, E_PUBLIC_NPL_LIST, E_PUBLIC_NPL_DELETE, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Use the official or author-named route; no dataset payload was requested in this assessment.
2. Confirm product vintage, field names, identifiers, history and population for every required year; make only documented import/name normalization.
3. Keep source-product gaps unresolved when a page documents only a subset or delivery method.

Validation to perform later:

- In a later authorized run, verify files, fields and county/state/year joins while retaining author timing and analysis.

### A_OPEN_INPUT_ROOTS: Resolve remaining raw input roots and author-prepared source tables while using the supported shared-root or copy route for the generated county weather/control handoffs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: OPEN_INPUT_ROOTS
Evidence: E_DOC_OTHER_DATA, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Map each unresolved raw read to a compatible source file/library and actual working directory; do not require separate scientific identities for the same-name generated handoffs.
2. Keep source tables distinct from generated intermediates, retain trace order, and configure the county weather/control aliases or copies through A_LIBREF_ALIASES.
3. Do not infer access restrictions from a source label or catalog miss.

Validation to perform later:

- Check each unresolved raw source mapping against the producer/read order; closure remains incomplete for independent source, field or history contracts that are still unknown.

### A_YEAR_DIRECTORY: Resolve the separate lib.year source/setup contract and working-directory context.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: UNKNOWN_YEAR_DIRECTORY
Evidence: E_TRACE_CHECKPOINT, E_SAS_TOC

Preparation / proposed procedure:

1. Identify whether lib.year is an input or setup product and record its actual keys and history.
2. Document the working directory needed for lib.year; treat generated same-name weather/control aliases as the separate preparation route in A_LIBREF_ALIASES.

Validation to perform later:

- Verify year-table resolution and fiscal/calendar joins before execution.

### A_LIBREF_ALIASES: Configure shared-root aliases or copies for the same-name county weather and county control handoffs; no separate author identity confirmation is needed solely because the library references differ.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: LIBREF_ALIAS_CONTRACTS
Evidence: E_SAS_WEATHER_PRODUCER, E_SAS_WEATHER_CONSUMER, E_SAS_COUNTY_CONTROL_CONSUMER, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. For weather, point air to the working root used by lib or copy lib.county_weather_ann before the line 1650 consumer.
2. For county_control, point mylocal to the working root used by lib or copy lib.county_control before the line 2557 consumer.
3. Preserve the producer and consumer dataset names and order; do not infer schema, key, history or coverage compatibility from matching names alone.

Validation to perform later:

- In a later authorized preparation check, compare exact fields/schema, county/year keys, row coverage and required history for each producer/consumer pair.

### A_WINSORIZE: Resolve the missing winsorize.sas source without substituting an assumed implementation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: MISSING_WINSORIZE_SOURCE
Evidence: E_SAS_INCLUDE, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Locate the exact author include/macro definition.
2. Preserve both variable lists and 1st/99th percentile arguments.

Validation to perform later:

- Check include path and macro behavior at both call sites before execution.

### A_PEW_HANDOFF: Add a persisted Pew export after lib.pew is constructed in the portable working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: PEW_DTA_HANDOFF
Evidence: E_SAS_PEW_OUTPUT, E_STATA_PEW, E_TRACE_CHECKPOINT

**Proposed edit:** `CFHLL_sas.sas:4747–4747`
Source SHA-256: `bab724a103d59978fcb5fd7d717de179d376bf4226a48d02aaec690c9b1be6bd`

SAS constructs lib.pew but Stata reads a persisted pew.dta.

Current text:
```
run;	
```

Proposed replacement:
```
run;	
proc export data=lib.pew outfile='...\pew.dta' dbms=dta replace; run;
```

Preparation / proposed procedure:

1. Place the proposed export after the completed lib.pew DATA step.
2. Match the Stata-relative path and preserve all Panel B fields.

Validation to perform later:

- On a later authorized run, confirm pew.dta exists before Panel B and its columns match the reads.

### A_CCES_CASE: Normalize the CCES output filename to match the Stata consumer on case-sensitive filesystems.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: CCES_FILENAME_CASE
Evidence: E_SAS_CCES_OUT, E_STATA_CCES, E_TRACE_CHECKPOINT

**Proposed edit:** `CFHLL_sas.sas:4724–4724`
Source SHA-256: `bab724a103d59978fcb5fd7d717de179d376bf4226a48d02aaec690c9b1be6bd`

Use the same case-sensitive filename as the Stata consumer.

Current text:
```
proc export data=lib.cces outfile='...\cces.dta' dbms=dta replace; run;
```

Proposed replacement:
```
proc export data=lib.cces outfile='...\CCES.dta' dbms=dta replace; run;
```

Preparation / proposed procedure:

1. Apply the one-line proposed filename correction only in a working copy.
2. Keep CCES construction and Stata analysis unchanged.

Validation to perform later:

- Verify producer and consumer resolve to the same filename.

### A_ID_CONTRACTS: Identify the exact county FIPS and SIC source tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: COUNTY_FIPS_SIC_CONTRACTS
Evidence: E_SAS_FIPS, E_SAS_SIC, E_COMP_FUND_PROBE22, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Confirm county lookup source, field width/type and year keys.
2. Confirm lib.sic source/table and gvkey/fyear/sic2/sic3 meanings.
3. Do not infer physical sic absence from the Funda request that omitted it.

Validation to perform later:

- Check both confirmed identifier contracts against the exact CCES and main-panel joins.

### A_BEAGDP: Resolve the author’s early county-GDP history, including the 1992 baseline needed for 1993 growth.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: BEA_EARLY_GDP_HISTORY
Evidence: E_PUBLIC_BEA, E_SAS_BEA, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify the actual author county_data release and documented year history.
2. Clarify any distinct documented early GDP input; do not assume the 2001+ public product and imputation fill all counties/years.
3. Keep GDP history separate from population history.

Validation to perform later:

- Verify each county has required GDP/population rows for growth joins before execution.

### A_13F_SUMMARY: Resolve the author-prepared 13F ownership-summary contract; keep raw TFN.S34 as an unverified candidate only.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: INSTITUTIONAL_SUMMARY_CONTRACT
Evidence: E_DOC_13F, E_SAS_OWNERSHIP, E_TFN_TIMEOUT, E_TRACE_CHECKPOINT

Preparation / proposed procedure:

1. Identify source/construction of lib.inst_sum_07312019, including CUSIP, report date, denominator and INSTOWN_PERC.
2. Preserve the timeout without concluding unavailability; do not substitute raw 13F without documented rules.

Validation to perform later:

- Compare the confirmed summary with the nearest report within the preceding 100-day join.

### A_SAS_RUNTIME: Prepare the SAS 9.4 runtime and verify required SAS/STAT procedure support before any authorized run; no runtime or product availability check was performed here.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SAS
Evidence: E_ENVIRONMENT, E_SAS_TOC, E_SAS_INCLUDE, E_SAS_STAT_FACTOR_DOC, E_SAS_STAT_REG_DOC

Preparation / proposed procedure:

1. Treat SAS/STAT support for the source's PROC FACTOR and PROC REG calls as required but unverified; do not infer installation or license status from SAS 9.4 documentation.
2. Before an authorized run, verify the batch runtime and required procedure support without starting author code during this assessment.
3. Keep the missing winsorize include as a separate gap.

Validation to perform later:

- Before an authorized run, verify batch runtime and required procedures, then prepare SAS outputs before Stata.

### A_CENTER_SETUP: Prepare the exact Stata center command before any authorized analysis.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: center
Evidence: E_STATA_CENTER, E_STATA_CENTER_SRC

Preparation / proposed procedure:

1. Resolve center through the approved Stata package source and user adopath; do not install during this assessment.

Validation to perform later:

- Use the exact-command lookup in the configured Stata environment before running the author program.

### A_PSACALC_SETUP: Prepare the exact Stata psacalc command before any authorized analysis.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: psacalc
Evidence: E_STATA_PSACALC, E_STATA_PSACALC_SRC

Preparation / proposed procedure:

1. Resolve psacalc through the approved Stata package source and user adopath; do not install during this assessment.

Validation to perform later:

- Use the exact-command lookup in the configured Stata environment before running the author program.


## Remaining issues and prerequisites

- OPEN_INPUT_ROOTS [unresolved; full_pipeline]: SAS has no included LIBNAME/root setup for ellipsis-rooted raw inputs and many pre-existing source tables. Their source mappings and working roots remain unestablished, so dependency closure is incomplete. The same-name generated county weather/control handoffs are covered separately as preparation and do not by themselves require author confirmation.
- UNKNOWN_YEAR_DIRECTORY [unresolved; full_pipeline]: The trace leaves lib.year and working-directory/library resolution unresolved. Identify the author setup; do not guess a replacement table or assume same-basename paths coincide.
- LIBREF_ALIAS_CONTRACTS [preparation; full_pipeline]: SAS writes county_weather_ann under lib at line 1643 and later reads the same-name table under air at line 1650; it creates lib.county_control at lines 171–172 and later reads mylocal.county_control at line 2557. These are same-data producer/consumer handoffs. Use a shared-root alias or copy configuration as preparation; different libref names alone do not imply a separate scientific source. Future schema, field, county/year-key and coverage validation remains.
- MISSING_WINSORIZE_SOURCE [unresolved; full_pipeline]: The SAS driver includes winsorize.sas at main and Superfund branches, but the include is absent; its body/percentile behavior cannot be inferred from call sites.
- PEW_DTA_HANDOFF [preparation; full_pipeline]: SAS constructs lib.pew but does not export pew.dta; Stata Table 10 Panel B reads pew.dta.
- CCES_FILENAME_CASE [preparation; full_pipeline]: SAS exports cces.dta lowercase, while Stata requests CCES.dta uppercase; this can fail on a case-sensitive filesystem.
- COUNTY_FIPS_SIC_CONTRACTS [unresolved; full_pipeline]: The author county_fips lookup and separate lib.sic contract are unestablished. The Funda request explicitly omitted sic; that does not prove the underlying file lacks the field.
- BEA_EARLY_GDP_HISTORY [unresolved; full_pipeline]: The firm panel begins in 1993 and uses one-year GDP growth; the cited official county GDP product begins in 2001. The regression step does not prove every county has usable 1993–2000 GDP observations.
- INSTITUTIONAL_SUMMARY_CONTRACT [unresolved; full_pipeline]: Code expects prepared lib.inst_sum_07312019 with INSTOWN_PERC. Local TFN.S34 has raw fields and its bounded probe timed out; neither proves the prepared table or an equivalent transformation.
- CENSUS_COUNTY_RAW [undetermined]: Pre-existing county_raw used to construct demographic controls. Exact author file, columns and coverage are absent; code maps selected education values to 1990/2000/2010.
- RELIGION_INPUT [undetermined]: County religion workbooks for 1980, 1990, 2000, 2010, combined by county/year. Exact historical fields and denominators unverified.
- SOCIAL_CAPITAL_INPUT [undetermined]: NERCRD county social-capital data used for 1990/1997/2005/2009/2014; exact library schemas remain unknown.
- RESPONSE_RATE_INPUT [undetermined]: Separate 1990 state response-rate lookup joined into social-capital construction.
- NOAA_HOURLY_INPUT [undetermined]: Hourly NOAA station CSVs 1990–2019; SAS reads station/date/hour and weather fields, applies filters and aggregates by station/year.
- WEATHER_STATION_LOOKUP [undetermined]: Separate station information CSV supplies station coordinates and identifiers for county proximity matching.
- COUNTY_CENTROID_INPUT [undetermined]: lib.countydistance_01252020 supplies county centroid coordinates for weather-station assignment; exact source/key/vintage unresolved.
- CITY_COUNTY_LINK [undetermined]: City/county lookup used for weather and Compustat location assignment; author names Simplemaps, exact 2019 workbook is unverified.
- GOOGLE_TRENDS_INPUT [undetermined]: Google Trends workbook consumed to construct state-year air/ozone searches; exact query, export fields and required years unresolved.
- FEC_INPUTS [undetermined]: FEC candidate, committee and itemized transaction files used for executive political matching across even election years 1980–2018.
- EXECUCOMP_INPUT [undetermined]: ExecuComp manager-year data. Local EXECCOMP.ANNCOMP one-row probe reads expected fields; sample year 1992 is not a history check.
- SASHELP_ZIPCODE [undetermined]: SASHELP.ZIPCODE ZIP-to-MSA lookup required by political and manager matching; no table probe performed.
- TTI_TRAFFIC_INPUT [undetermined]: Texas A&M TTI 2019 urban mobility workbook used to construct county traffic exposure.
- MSA_COUNTY_CROSSWALK [undetermined]: Census MSA/county geography crosswalk named by the SAS comment; no file is packaged and keys remain unverified.
- VIOLATION_TRACKER_INPUT [undetermined]: Good Jobs First basic and parent workbooks feed penalties. Bulk spreadsheet delivery has a subscription condition; this does not bar all permitted routes.
- AGE_CENSUS_INPUT [undetermined]: Census age workbook builds child/senior county controls using age fields for 1990/2000/2010.
- BRFSS_INPUT [undetermined]: County BRFSS CDBRFS01–10 and LLCP2011/2012 files feed county-year asthma measures. Exact year-specific fields and coverage unverified.
- QCEW_INPUT [undetermined]: BLS annual county employment workbooks allhlcn90–allhlcn20; code selects county/nonfarm rows and uses area/year/annual average employment.
- BEA_COUNTY_INPUT [undetermined]: BEA county GDP/population raw table feeds GDP imputation and one-year growth. Main panel begins in 1993 and requires a 1992 growth baseline; early GDP history unresolved.
- COMPUSTAT_SNAPSHOT [undetermined]: Compustat Snapshot firm/location input. WRDS is the author source; exact local candidate not verified; exact catalog miss does not prove absence.
- COMPUSTAT_FUNDA [undetermined]: Raw Compustat tax/financial fields. Local Funda probe reads 22 fields except sic, one row at 1961; no author table/history compatibility established.
- SIC_CLASSIFICATION_INPUT [undetermined]: Separate lib.sic table provides SIC/SIC2/SIC3 by GVKEY/fiscal year. Physical source and exact field contract remain unresolved.
- STATUTORY_TAX_INPUT [undetermined]: State-year statutory tax-rate table from author-named CSG Knowledge Center; exact product, dates and rate conventions unverified.
- PERMNO_CUSIP_LINK [undetermined]: Separate WRDS PERMNO-to-CUSIP crosswalk used before ownership matching; date and history contract absent.
- INSTITUTIONAL_OWNERSHIP [undetermined]: Author lib.inst_sum_07312019 prepared ownership summary with INSTOWN_PERC and report dates. Local TFN.S34 is a raw candidate whose 15-second probe timed out, not a verified substitute.
- GVKEY_CIK_LINK [undetermined]: Separate WRDS GVKEY-to-CIK table used in penalty matching; link_05062021 library input is not supplied.
- CORPORATE_CULTURE [undetermined]: Corporate-culture input obtained from Rui Shen; code joins by GVKEY/year. Data dictionary and compatible author copy are absent.
- CEO_BIRTHPLACE [undetermined]: CEO birthplace/identity input obtained from Shufang Lai; code joins by GVKEY, EXECID and year. Data dictionary/copy absent.
- COUNTY_FINANCE_INPUT [undetermined]: County government expenditure input, joined by FIPS_Combined/Year4 and used in same/forward-year branches.
- NONATTAINMENT_INPUT [undetermined]: EPA county nonattainment raw history used in DiD branches; author table schema and year-field mapping unresolved.
- CCES_INPUT [undetermined]: CCES year-specific files 2005–2018 in CSV/TAB/DTA/SAV formats; SAS uses varying mappings and county joins.
- CCES_COUNTY_FIPS_LOOKUP [undetermined]: Separate lib.county_fips lookup used to attach county identifiers to CCES records; no producer or exact source is supplied.
- PEW_WAVE33 [undetermined]: Pew American Trends Panel Wave 33 input used to construct lib.pew; raw survey input is not in archive.
- ANES_SENSITIVE [undetermined]: Sensitive ANES survey/geocode input for Table 10 Panel C; selected waves 1990–2016 are named in code and exact wave/geocode mapping is unresolved.
- NPL_INPUT [undetermined]: EPA Superfund/NPL listing and deletion raw inputs for the Superfund DiD; exact site fields, completion dates and county match remain unverified.
- SAS [unverified]: Native SAS 9.4 preparation directly uses PROC FACTOR and PROC REG, which require SAS/STAT support, as well as PROC IMPORT, SQL, TRANSPOSE, RANK and EXPORT; SAS/STAT capability is unverified. The missing custom winsorize include remains a separate gap. Audit did not start SAS or inspect startup state.
- center [preparation_required]: Exact center command was not found in checked Stata adopath; supplied code invokes it. No install attempted.
- psacalc [preparation_required]: Exact psacalc command was not found in checked Stata adopath; supplied code invokes it. No install attempted.

## Review notes

- Static execution-feasibility assessment only. Neither author SAS or Stata programs, macros, models, estimators, regressions, nor datasets were executed/imported/compiled.
- All 209 frozen dependency IDs are reviewed exactly once. Generated edges are credited only where a supplied producer appears in the ordered trace; unresolved raw inputs, author tables, aliases and missing producers remain explicit.
- The 29 supplied annual ozone CSVs are the primary route and each has a bounded one-row probe. This verifies headers/readability only, not county population or annual coverage.
- Ozone uses t−1/t/t+1. Separately, the cash ETR join uses Compustat t+1/t+2; main fiscal years 1993–2016 therefore require fundamentals through 2018. These windows are not interchangeable.
- COMP.FUNDA and EXECCOMP.ANNCOMP are local candidates only. The Funda sic contract is unestablished; a COMP.SNAPSHOT catalog miss is not proof of absence; the TFN.S34 timeout is not proof of unavailability or lack of license.
- The identifier XLSX is not a full analysis panel. Stata depends on SAS-produced inputs, so no analysis_only route is credited.
- Tooling failures/corrections are recorded in probes/tool_error_log.json as process history, not as scientific or access evidence. Static public pages only were checked; no dataset payloads, API calls or external contacts were used.
