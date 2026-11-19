# Patch proposal: jar-fec8a8c34483

Macroeconomic Information Acquisition around Earnings Clusters

DOI: 10.1111/1475-679X.70020

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied compensation peer-group/network workflow: SAS preparation, Stata sample and analyses, Figure 1 notebook, manual UCINET steps and inventoried native GUI figures. Package attribution, prepared data and handoff gaps remain unresolved.

Entry points: `code, identifiers, and log files/analysis code/Analysis_competition.do`, `code, identifiers, and log files/analysis code/Analysis_hopping.do`, `code, identifiers, and log files/analysis code/Table 1A.do`, `code, identifiers, and log files/analysis code/Table 1B.do`, `code, identifiers, and log files/analysis code/Figure 1.ipynb`, `code, identifiers, and log files/cleaning code/ConstructSample_competition.do`, `code, identifiers, and log files/cleaning code/clustering coefficient.do`, `code, identifiers, and log files/cleaning code/hopping.sas`, `code, identifiers, and log files/cleaning code/pay for luck.sas`, `code, identifiers, and log files/cleaning code/peer selection summary stats.sas`, `code, identifiers, and log files/cleaning code/tournament.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 2/70020 - Macroeconomic-Information-Acquisition-around-Earnings-Clusters/gl-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "19959bf5ed0158a69eb147b4389b090cb222e95a506d5b5118ddf26caf2ac693"
    },
    {
      "path": "JAR-Volume 64/Issue 2/70020 - Macroeconomic-Information-Acquisition-around-Earnings-Clusters/gl_online-appendix-may-2026.pdf",
      "sha256": "1878c0aecb30556d6c7eb67a1526729d443cd1dc8877739fe4b454d34c6d483a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "f2edf02e661a8dd00a70da3838868667c67a7410d81e21831dc8d63fe794e44c"
}
```

## Proposed actions

### ACT-HOPPING-PANEL: Compare the actual WORK.hopping19 producer with the Stata hopping panel contract before persisting a handoff.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-HOPPING-PANEL
Evidence: E-HOP-HANDOFF, E-README-WORKFLOW

Preparation / proposed procedure:

1. At the supplied final WORK.hopping19 create/sort writer, compare the actual columns and transition/year keys with GVKEY, YEAR, EXECID, GVKEY_NEW and YEAR_NEW and the Stata consumer selection.
2. If the same object contains the complete required fields and row population, export that object to the configured Stata-readable path before any WORK reset or SAS session end; preserve its deduplication and source-defined rows.
3. If the schema or sample does not align, retain the exact missing field, selection or producer mapping question; do not request a byte-identical author file or invent a transformation.

Validation to perform later:

- Read back the persisted output with a bounded metadata reader and compare all five fields, GVKEY/executive/year transition keys, sample years and deduplication to the live producer contract.
- Confirm the Stata input path and format resolve to this same output before the hopping analysis branch.

### ACT-FIG1-WORKBOOK: Resolve this specific required input: Figure 1 workbook read from Sheet1/Category.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-FIG1-WORKBOOK
Evidence: E-FIG1-WB, E-FIG1-CAT, E-WORKITEM

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-FIG1-WORKBOOK; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: Category. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-FIG1-WORKBOOK before any author-code run.
- Compare exact required columns and row keys against Category.

### ACT-PEERPAY-PANEL: Resolve this specific required input: Author-prepared newpaypeer panel shared by peer summary and Table 1A/1B.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-PEERPAY-PANEL
Evidence: E-PEER-FUNDA, E-PEER-TNIC, E-PEER-STATS, E-SAS-10, E-SAS-16

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-PEERPAY-PANEL; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, GVKEY_PEER, FYEAR, TDC1, TDC1_PEER, CIK, CIK_PEER. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-PEERPAY-PANEL before any author-code run.
- Compare exact required columns and row keys against GVKEY, GVKEY_PEER, FYEAR, TDC1, TDC1_PEER, CIK, CIK_PEER.

### ACT-PEER-SUMMARY: Persist the supplied WORK.SUMMARY result as summary.dta at the path consumed by Table 1B, preserving the source-defined rows and six fields.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: ISS-HANDOFF
Evidence: E-PEER-PRODUCER, E-TABLE1B-GENERATED, E-TABLE1B-FIELDS, E-HOP-HANDOFF, E-RPE-HANDOFF, E-TOUR-HANDOFF

Preparation / proposed procedure:

1. Run the supplied peer-selection preparation through its existing paypeer4 input and create WORK.SUMMARY with the source-defined grouping and statistics.
2. Configure the output destination and save that same WORK.SUMMARY dataset as summary.dta for Table 1B.
3. Preserve FYEAR, GVKEY, benchmarking, interlock, same_sic2, same_hp2, same_size, and pay_dif.

Validation to perform later:

- Compare summary.dta variable names, rows, and values with the WORK.SUMMARY dataset produced by the same SAS source.
- Confirm Table1B.do reads the configured summary.dta path.
- Treat this as persistence/path preparation; do not reconstruct the six measures as a separate raw input or require separate author approval for the same-data export.

### ACT-FINCONTROLS: Resolve this specific required input: temp_financialcontrols.dta starting input to competition sample builder.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-FINCONTROLS
Evidence: E-SAMPLE-PRODUCER, E-SAMPLE-SAVE, E-SAS-15

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-FINCONTROLS; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, CIK, FYEAR. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-FINCONTROLS before any author-code run.
- Compare exact required columns and row keys against GVKEY, CIK, FYEAR.

### ACT-CLUSTER-EDGES: Resolve this specific required input: Prepared data_paypeer20062018.dta read by clustering coefficient code; producer absent.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CLUSTER-EDGES
Evidence: E-CLUSTER, E-SAS-10

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-CLUSTER-EDGES; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CIK, CIK_PEER, FYEAR. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-CLUSTER-EDGES before any author-code run.
- Compare exact required columns and row keys against CIK, CIK_PEER, FYEAR.

### ACT-CLUSTERS-CSV: Resolve this specific required input: clusters.csv imported by hopping.sas; exact source/producer/schema unresolved.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CLUSTERS-CSV
Evidence: E-HOP-NETWORK-IMPORT, E-HOP-NETWORK-CONSUME, E-WORKITEM

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-CLUSTERS-CSV; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CIK, YEAR, LOUVAIN, LOUVAIN_SMALL, DISCLOSE. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-CLUSTERS-CSV before any author-code run.
- Compare exact required columns and row keys against CIK, YEAR, LOUVAIN, LOUVAIN_SMALL, DISCLOSE.

### ACT-DOW-NASDAQ: Resolve this specific required input: Dow/Nasdaq membership interval table joined by GVKEY and datadate.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-DOW-NASDAQ
Evidence: E-HOP-INDEX

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-DOW-NASDAQ; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, FROM, THRU, INDEXCAT, CONM. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-DOW-NASDAQ before any author-code run.
- Compare exact required columns and row keys against GVKEY, FROM, THRU, INDEXCAT, CONM.

### ACT-CIK-GVKEY-LINK: Resolve this specific required input: Historical CIK/GVKEY interval crosswalk with FNDATE/LNDATE used in the hopping network merge.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CIK-GVKEY-LINK
Evidence: E-HOP-NETWORK-CONSUME, E-SAS-15

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-CIK-GVKEY-LINK; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CIK, GVKEY, FNDATE, LNDATE. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-CIK-GVKEY-LINK before any author-code run.
- Compare exact required columns and row keys against CIK, GVKEY, FNDATE, LNDATE.

### ACT-PEER-WORKBOOK: Resolve this specific required input: network1212.xlsx imported by hopping and tournament SAS as the annual peer workbook.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-PEER-WORKBOOK
Evidence: E-HOP-PEER-WB, E-TOUR-PEER, E-WORKITEM

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-PEER-WORKBOOK; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: FYEAR, CIK_OWN, GVKEY_OWN, TDC_OWN, CIK_PEER, GVKEY_PEER, TDC_PEER. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-PEER-WORKBOOK before any author-code run.
- Compare exact required columns and row keys against FYEAR, CIK_OWN, GVKEY_OWN, TDC_OWN, CIK_PEER, GVKEY_PEER, TDC_PEER.

### ACT-IBES-LINK-DATA: Resolve this specific required input: IBES.CIBESLNK ticker-to-GVKEY effective-date link used against ANNDATS.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-IBES-LINK
Evidence: E-IBES-LINK, E-SAS-09

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-IBES-LINK; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: TICKER, GVKEY, FDATE, LDATE. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-IBES-LINK before any author-code run.
- Compare exact required columns and row keys against TICKER, GVKEY, FDATE, LDATE.

### ACT-EUCLID-C: Resolve this specific required input: Year-specific C-distance Excel matrices for 2006–2018.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-EUCLID-C
Evidence: E-HOP-EUC-C-IN, E-HOP-EUC-C-LONG, E-HOP-EUC-C-STACK, E-WORKITEM

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-EUCLID-C; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: ID, peer CIK headers, distance cells. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-EUCLID-C before any author-code run.
- Compare exact required columns and row keys against ID, peer CIK headers, distance cells.

### ACT-EUCLID-R: Resolve this specific required input: Year-specific R-distance Excel matrices for 2006–2018.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-EUCLID-R
Evidence: E-HOP-EUC-R-IN, E-HOP-EUC-R-LONG, E-HOP-EUC-R-STACK, E-WORKITEM

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-EUCLID-R; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: ID, peer CIK headers, distance cells. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-EUCLID-R before any author-code run.
- Compare exact required columns and row keys against ID, peer CIK headers, distance cells.

### ACT-CRSP-INFLATION: Resolve this specific required input: CRSP inflation series used to deflate returns, with CALDT and CPIRET.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CRSP-INFLATION
Evidence: E-PAY-FUNDA

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-CRSP-INFLATION; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CALDT, CPIRET. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-CRSP-INFLATION before any author-code run.
- Compare exact required columns and row keys against CALDT, CPIRET.

### ACT-CCMFUNDA-PAY: Resolve this specific required input: Prepared ccmfunda_0428 pay-for-luck panel, including LPERMNO/FYRC/SIC/NAICS plus annual financials.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CCMFUNDA-PAY
Evidence: E-PAY-FUNDA, E-SAS-15, E-SAS-07

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-CCMFUNDA-PAY; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, LPERMNO, DATADATE, FYEAR, FYRC, SIC, NAICS, SALE, MKVALT, PRCC_F, CSHO, IB, AT. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-CCMFUNDA-PAY before any author-code run.
- Compare exact required columns and row keys against GVKEY, LPERMNO, DATADATE, FYEAR, FYRC, SIC, NAICS, SALE, MKVALT, PRCC_F, CSHO, IB, AT.

### ACT-CCMFUNDA-HOP: Resolve this specific required input: Prepared merged Compustat panel for hopping; includes SIC, CEQ, LPERMNO, GSECTOR and STATE.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CCMFUNDA-HOP
Evidence: E-HOP-NETWORK-CONSUME, E-SAS-15, E-SAS-07

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-CCMFUNDA-HOP; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, SALE, MKVALT, SIC, PRCC_F, CSHO, AT, CEQ, IB, DATADATE, LPERMNO, GSECTOR, STATE. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-CCMFUNDA-HOP before any author-code run.
- Compare exact required columns and row keys against GVKEY, SALE, MKVALT, SIC, PRCC_F, CSHO, AT, CEQ, IB, DATADATE, LPERMNO, GSECTOR, STATE.

### ACT-TOURN-COMP-DTA: Resolve this specific required input: Separate Data_Compustat_raw_2004-2019.dta used for tournament construction.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-TOURN-COMP-DTA
Evidence: E-TOUR-COMP, E-SAS-15

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-TOURN-COMP-DTA; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, FYEAR, SIC, SALE, MKVALT, AT, NI, STATE. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-TOURN-COMP-DTA before any author-code run.
- Compare exact required columns and row keys against GVKEY, FYEAR, SIC, SALE, MKVALT, AT, NI, STATE.

### ACT-TOURN-FUNDA: Resolve this specific required input: Compustat FUNDA input to tournament requiring GVKEY/FYEAR/SIC/SALE/STATE.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-TOURN-FUNDA
Evidence: E-TOUR-FUNDA, E-SAS-15

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-TOURN-FUNDA; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, FYEAR, SIC, SALE, STATE. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-TOURN-FUNDA before any author-code run.
- Compare exact required columns and row keys against GVKEY, FYEAR, SIC, SALE, STATE.

### ACT-TOURN-GAP: Resolve the specific WORK.tournament_final to PAYGAP_INfirm/N_FF48CEOYR field mapping required by the competition analysis.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-TOURN-GAP
Evidence: E-TOUR-HANDOFF, E-TOUR-OPTIONAL

Preparation / proposed procedure:

1. Compare the supplied WORK.tournament_final output fields, keys and source definitions with GVKEY, FYEAR, PAYGAP_INfirm and N_FF48CEOYR; the current source map establishes the WORK producer but not the two analysis target fields.
2. If the exact target fields already exist in the final table with the required definitions and sample, persist the same object before the first WORK reset or session end; otherwise retain the exact missing producer/definition question before the Stata analysis.
3. Keep the commented FF30 call optional and the missing FF48 classification macro separate from the public FF48 return data.

Validation to perform later:

- Check target field presence and definitions, GVKEY/FYEAR keys, peer-group count and sample against the Stata consumer before use.
- Read back any supported same-object export and confirm it is the final tournament table, not a substituted proxy.

### ACT-PEER-BENCHMARK: Resolve this specific required input: Prepared peer-pay benchmark fields merged into competition sample.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-PEER-BENCHMARK
Evidence: E-SAMPLE-PRODUCER, E-SAS-10, E-SAS-16

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-PEER-BENCHMARK; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, FYEAR, PEER_PAY, N_PPEER_ORI, N_PPEER_NMISSPEERTDC. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-PEER-BENCHMARK before any author-code run.
- Compare exact required columns and row keys against GVKEY, FYEAR, PEER_PAY, N_PPEER_ORI, N_PPEER_NMISSPEERTDC.

### ACT-SIZE-PEERS: Resolve this specific required input: Prepared FF/SIC/TNIC/geography size-peer pay and peer counts.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-SIZE-PEERS
Evidence: E-SAMPLE-PRODUCER

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-SIZE-PEERS; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, FYEAR, NAIVE_PAY_FF, PEER_NUM_FF, NAIVE_PAY_SIC, PEER_NUM_SIC, NAIVE_PAY_HP, PEER_NUM_HP, NAIVE_PAY_GEO, PEER_NUM_GEO. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-SIZE-PEERS before any author-code run.
- Compare exact required columns and row keys against GVKEY, FYEAR, NAIVE_PAY_FF, PEER_NUM_FF, NAIVE_PAY_SIC, PEER_NUM_SIC, NAIVE_PAY_HP, PEER_NUM_HP, NAIVE_PAY_GEO, PEER_NUM_GEO.

### ACT-DURATION: Resolve this specific required input: Prepared CEO duration control merged by GVKEY/FYEAR.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-DURATION
Evidence: E-SAMPLE-PRODUCER

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-DURATION; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, FYEAR, DURATION_CEO0. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-DURATION before any author-code run.
- Compare exact required columns and row keys against GVKEY, FYEAR, DURATION_CEO0.

### ACT-CEO-TENURE: Resolve this specific required input: Prepared CEO tenure control ceo_tenure2 with source timing/missing-date adjustment.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CEO-TENURE
Evidence: E-SAMPLE-PRODUCER

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-CEO-TENURE; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, FYEAR, CEO_TENURE2. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-CEO-TENURE before any author-code run.
- Compare exact required columns and row keys against GVKEY, FYEAR, CEO_TENURE2.

### ACT-DELTA-VEGA: Resolve this specific required input: Executive-firm/year delta incentive panel merged into competition sample.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-DELTA-VEGA
Evidence: E-SAS-16

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-DELTA-VEGA; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CO_PER_ROL, FYEAR, DELTA. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-DELTA-VEGA before any author-code run.
- Compare exact required columns and row keys against CO_PER_ROL, FYEAR, DELTA.

### ACT-INDVOL: Resolve the upstream source and construction for analysis-consumed lag_volatility12.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-INDVOL
Evidence: E-ADDONS-MODEL

Preparation / proposed procedure:

1. Treat lag_volatility12 as the only directly observed volatility consumer name in the admitted competition model excerpt.
2. Request the documented upstream dataset and producer for lag_volatility12, including its source field, time definition, identifier keys and merge path.
3. Keep the route unverified until the producer and mapping are supported; do not infer an upstream native field or complete history from the consumer name.

Validation to perform later:

- Confirm that the supplied author pipeline creates the exact lag_volatility12 consumed by Analysis_competition.do.
- Check the documented producer, type, fiscal timing, join keys and sample coverage before changing route status.

### ACT-RPE-PANEL: Compare the final WORK.rpe3 object with the Stata RPE fields and persist it only if its inherited schema and rows match.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-RPE-PANEL
Evidence: E-RPE-HANDOFF, E-ANALYSIS-RPE

Preparation / proposed procedure:

1. Use the supplied final WORK.rpe3 writer; trace its inherited rpe2 columns and full-join keys, then compare GVKEY/FYEAR, SKILL, LUCK, RET_ANNUAL_HP, PEER_RET_ANNUAL_HP, IDIO_VAR and CORR with the Stata consumers.
2. If those fields, units, keys and sample align, export the same WORK.rpe3 object before the first WORK reset or SAS session end to the configured Stata-readable path.
3. If inherited rpe2 fields or population differ, preserve that specific schema/selection gap; keep the required raw Compustat/CRSP inputs separate and do not request an independent raw RPE panel merely because the WORK table is not persistent.

Validation to perform later:

- Compare the persisted column names, GVKEY/FYEAR keys, return units, row population and analysis-variable definitions with the final WORK.rpe3 producer and Stata consumers.
- Confirm the consumer path resolves to this export before the competition sample and analyses.

### ACT-IDIO-CORR: Resolve this specific required input: Prepared firm-year idiosyncratic variance and peer correlation controls.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-IDIO-CORR
Evidence: E-ANALYSIS-IDIO

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-IDIO-CORR; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, FYEAR, IDIO_VAR, CORR. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-IDIO-CORR before any author-code run.
- Compare exact required columns and row keys against GVKEY, FYEAR, IDIO_VAR, CORR.

### ACT-HHI: Resolve this specific required input: Prepared firm-year HHI control used in competition analysis.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-HHI
Evidence: E-ANALYSIS-IDIO

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-HHI; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, FYEAR, HHI. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-HHI before any author-code run.
- Compare exact required columns and row keys against GVKEY, FYEAR, HHI.

### ACT-FUTURE-PERF: Resolve this specific required input: Future-performance panel with ROA/return leads, standard deviations and counts.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-FUTURE-PERF
Evidence: E-ANALYSIS-RPE

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-FUTURE-PERF; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: GVKEY, FYEAR, ROA1, ROA2, ROA3, ROA_STD, COUNT_ROA, RET1, RET2, RET3, RET_STD, COUNT_RET. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-FUTURE-PERF before any author-code run.
- Compare exact required columns and row keys against GVKEY, FYEAR, ROA1, ROA2, ROA3, ROA_STD, COUNT_ROA, RET1, RET2, RET3, RET_STD, COUNT_RET.

### ACT-BOARD-DATA: Resolve this specific required input: BoardEx-derived CUSIP6/FYEAR board size, independence, busy-director and chair/CEO measures.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-BOARD
Evidence: E-SAS-13, E-SAS-14

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-BOARD; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CUSIP6, FYEAR, BOD_SIZE, BOD_INDEPT, BOD_BUSY, BOD_CHAIRCEO. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-BOARD before any author-code run.
- Compare exact required columns and row keys against CUSIP6, FYEAR, BOD_SIZE, BOD_INDEPT, BOD_BUSY, BOD_CHAIRCEO.

### ACT-EINDEX: Resolve this specific required input: Prepared CUSIP8/FYEAR EINDEX governance panel.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-EINDEX
Evidence: E-SAS-12

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-EINDEX; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CUSIP8, FYEAR, EINDEX. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-EINDEX before any author-code run.
- Compare exact required columns and row keys against CUSIP8, FYEAR, EINDEX.

### ACT-CCO: Resolve this specific required input: Prepared CIK-own/CIK-peer/year CCO group panel.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-CCO
Evidence: E-SAS-10

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-CCO; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CIK_OWN, CIK_PEER, YEAR. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-CCO before any author-code run.
- Compare exact required columns and row keys against CIK_OWN, CIK_PEER, YEAR.

### ACT-NETWORK-MEASURES: Resolve this specific required input: network measures_1203.xlsx native/manual network output consumed by tournament SAS.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-NETWORK-MEASURES
Evidence: E-WORKITEM, E-MANUAL-NETWORK, E-MANUAL-MEMO

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-NETWORK-MEASURES; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CIK, YEAR, LOUVAIN, LOUVAIN_SMALL. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-NETWORK-MEASURES before any author-code run.
- Compare exact required columns and row keys against CIK, YEAR, LOUVAIN, LOUVAIN_SMALL.

### ACT-ISS-CONSULTANT: Resolve this specific required input: Prepared consultant-control table imported by hopping.sas.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-ISS-CONSULTANT
Evidence: E-HOP-CONSULT-IMPORT, E-SAS-11

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-ISS-CONSULTANT; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CIK, FYEAR, CONSULTANT_TYPE, CONSULTANT_ID, CONSULTANT_NAME. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-ISS-CONSULTANT before any author-code run.
- Compare exact required columns and row keys against CIK, FYEAR, CONSULTANT_TYPE, CONSULTANT_ID, CONSULTANT_NAME.

### ACT-ISS-EDGE-LIST: Resolve this specific required input: Annual ISS CIK-own/CIK-peer edge lists for UCINET manual network construction.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-ISS-EDGE-LIST
Evidence: E-MANUAL-NETWORK, E-MANUAL-MEMO, E-SAS-10

Preparation / proposed procedure:

1. Obtain the exact author-prepared input/producer for R-ISS-EDGE-LIST; retain every listed field, key and sample branch.
2. Use a local candidate only for fields and meanings directly supported by its exact metadata; keep other mappings unresolved.
3. Obtain or construct only the listed source fields: CIK_OWN, CIK_PEER. Preserve the source-defined identifiers, period and transformation.

Validation to perform later:

- Compare all listed fields, IDs, date/fiscal-year range and row keys for R-ISS-EDGE-LIST before any author-code run.
- Compare exact required columns and row keys against CIK_OWN, CIK_PEER.

### ACT-TNIC2: Acquire the official pairwise file and prepare the author import for R-TNIC2.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R-TNIC2
Evidence: E-PUB-TNIC, E-PUB-TNIC2, E-HOP-TNIC2

Preparation / proposed procedure:

1. Download the correct official product/vintage for this branch; keep TNIC2 and TNIC3 as separate files.
2. Reformat without changing year, GVKEY pair, score or self/mirror-pair treatment.

Validation to perform later:

- Verify YEAR/GVKEY1/GVKEY2/SCORE and the author years before SAS import.

### ACT-TNIC3: Acquire the official pairwise file and prepare the author import for R-TNIC3.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R-TNIC3
Evidence: E-PUB-TNIC, E-PUB-TNIC3, E-HOP-TNIC3

Preparation / proposed procedure:

1. Download the correct official product/vintage for this branch; keep TNIC2 and TNIC3 as separate files.
2. Reformat without changing year, GVKEY pair, score or self/mirror-pair treatment.

Validation to perform later:

- Verify YEAR/GVKEY1/GVKEY2/SCORE and the author years before SAS import.

### ACT-FF48: Acquire and prepare the official 48 Industry Portfolios monthly series.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R-FF48
Evidence: E-PUB-FF48, E-PUB-FF48-PERIOD, E-HOP-FF48

Preparation / proposed procedure:

1. Download the official CSV/TXT release and retain its date/vintage.
2. Map the downloaded date and 48 industry headers to the SAS import only after checking the actual header; preserve source value units/missing-value coding.

Validation to perform later:

- Verify monthly rows for study years and all required industry return columns before merging.

### ACT-ATTR: Confirm archive/title/DOI identity without changing the frozen metadata.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-ATTR
Evidence: E-README-TITLE, E-APPENDIX-TITLE

Preparation / proposed procedure:

1. Confirm whether this archive is intended for the registered DOI; if not, record the correct package as a separate variant.

Validation to perform later:

- Record title/DOI/archive consistency before attributing any result.

### ACT-CLOSURE: Resolve the complete cross-language workflow and retain all author branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-CLOSURE
Evidence: E-README-WORKFLOW, E-MANUAL-NETWORK, E-MANUAL-MEMO, E-WORKITEM

Preparation / proposed procedure:

1. Follow README cleaning branches, UCINET manual network stage, SAS builders, Stata sample/analysis, Figure 1 notebook and native GUI figure stages.
2. Use each scoped requirement action and dependency disposition to settle required data, producers, software and handoffs; no analysis-only bypass is supported.

Validation to perform later:

- Confirm input/output names, native fields, periods, keys and direct producer for each mandatory edge; keep closure incomplete until resolved.

### ACT-HANDOFF: Preserve the three remaining SAS WORK outputs at their same-object writer positions and validate each Stata handoff.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: ISS-HANDOFF
Evidence: E-HOP-HANDOFF, E-RPE-HANDOFF, E-TOUR-HANDOFF, E-PEER-PRODUCER, E-TABLE1B-GENERATED, E-TABLE1B-FIELDS

Preparation / proposed procedure:

1. For WORK.hopping19, WORK.rpe3 and WORK.tournament_final, make any supported persistent export from the final same-session table writer before the first clearing/reset or SAS session end, after its requirement-specific field and row comparison passes.
2. Configure each Stata consumer path to the generated output; do not assume a later session can recover a WORK table after it has changed or closed.
3. Retain the specific unresolved HOPPING schema, inherited RPE fields and tournament gap mapping where checks do not establish equivalence; no blanket author-confirmed or author-approved format gate is needed for a same-data export.

Validation to perform later:

- For every persisted handoff, read back native fields and compare keys, units, period and row population with its live final writer before Stata consumes it.
- Confirm exports precede the first destructive reset/session end and remain separate from each branch’s independent raw-source requirements.

### ACT-COMP-MAP: Resolve historical industry and fiscal-year native-to-analysis mappings for the prepared pay-for-luck panel.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-COMP-MAP
Evidence: E-PAY-FUNDA, E-SAS-15, E-SAS-07, E-PEER-FUNDA, E-PEER-STATS, E-CATALOG

Preparation / proposed procedure:

1. Keep SIC, NAICS and FYRC in the requirement. Confirm whether SICH (historical SIC), NAICSH (historical NAICS) and FYR (fiscal year-end month) match author meaning/period before renaming.
2. Use CRSP CCM link type, primary indicator and effective dates only under the author-approved LPERMNO mapping.

Validation to perform later:

- Compare all required financial/native fields, year definitions and link dates; do not delete NAICS or assume NAICSH equivalence.

### ACT-IBES-LINK-ISSUE: Obtain the exact IBES ticker-to-GVKEY effective-date link.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: ISS-IBES-LINK
Evidence: E-IBES-LINK, E-SAS-09

Preparation / proposed procedure:

1. Use IBES.CIBESLNK or author-confirmed data with TICKER/GVKEY/FDATE/LDATE; retain inclusive ANNDATS interval join.
2. Keep IBCRSPHIST as a separate ticker/PERMNO candidate, not a replacement.

Validation to perform later:

- Validate interval matches and source EPS/FPI filters before constructing analyst-year fields.

### ACT-FF48-MACRO: Obtain the external FF48 SAS macro source and version.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-FF48-MACRO
Evidence: E-HOP-INCLUDE, E-PUB-FF48, E-WORKITEM

Preparation / proposed procedure:

1. Request the exact included SAS source, version and caller input/output contract.
2. Keep the official return data product separate from the include.

Validation to perform later:

- Byte-screen the registered source and verify fields/year/SIC rules against the supplied caller before any execution.

### ACT-NATIVE-GUI: Retain the supplied Tableau/Gephi projects and resolve their source/refresh contracts through a supported safe registration path.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-NATIVE-GUI
Evidence: E-WORKITEM, E-README-WORKFLOW

Preparation / proposed procedure:

1. Keep Figure 2.twbx and Figure 3A/3B.gephi as present native author projects; do not classify them as absent programs or propose an author-code replacement.
2. If a structurally proven code-only projection can be registered safely, use it to identify embedded calculations, workbook source ranges, linked data and refresh/output steps; otherwise record the current inventory-only limit.
3. Before a later GUI run, verify the project data references and refresh/manual sequence through an authorized native viewer, leaving mixed outputs and cached data opaque in this assessment.

Validation to perform later:

- Confirm exact native project identity/hash and any registered code-only source projection before attributing calculations or data dependencies.
- Keep project presence distinct from unverified application PATH/version/license metadata.

### ACT-BOARD-ISSUE: Resolve BoardEx-to-CUSIP crosswalk and board metric definitions.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: ISS-BOARD
Evidence: E-SAS-13, E-SAS-14

Preparation / proposed procedure:

1. Use BoardEx local tables only as native raw candidates; request author CUSIP6/year link and definitions for size, independence, busy directors and chair/CEO.
2. Keep ISS.COMPANYFY as link context only, not metric data.

Validation to perform later:

- Verify exact prepared CUSIP6/FYEAR metric fields and director-role selection before Stata consumes the panel.

### ACT-WORDCLOUD: Make the absent WordCloud distribution available in the Figure 1 Python environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-WORDCLOUD
Evidence: E-PY-WORDCLOUD, E-FIG1-IMPORTS, E-FIG1-CAT

Preparation / proposed procedure:

1. Configure the approved Python environment with wordcloud; keep the supplied notebook algorithm.

Validation to perform later:

- Confirm distribution metadata/version before a future notebook run.

### ACT-WINSOR2: Add winsor2 to the intended Stata 18 profile.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-WINSOR2
Evidence: E-ENV, E-ANALYSIS-RPE, E-ENV-PROJECTION

Preparation / proposed procedure:

1. Install/configure from the documented Stata package source after review; retain source 1/99 replacement calls.

Validation to perform later:

- Check `which winsor2` and record its path/version without running author analysis.

### ACT-STATA-EXT: Prepare only the source-invoked Stata extensions that failed the bounded Stata 18 which check; eststo and estfe resolved.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-CORSP, S-LOGIT2, S-FIRTHLOGIT, S-ASDOC, S-RANGEJOIN, S-NWSET, S-NWCLUSTERING
Evidence: E-ADDONS-COMP, E-WHICH-CORSP, E-ADDONS-HOP, E-WHICH-LOGIT2, E-FIRTHLOGIT, E-WHICH-FIRTHLOGIT, E-ANALYSIS-RPE, E-README-WORKFLOW, E-WHICH-ASDOC, E-RANGEJOIN, E-WHICH-RANGEJOIN, E-CLUSTER, E-WHICH-NWSET, E-WHICH-NWCLUSTERING

Preparation / proposed procedure:

1. Configure or install only corsp, logit2, firthlogit, asdoc, rangejoin, nwset and nwclustering in the intended Stata 18 profile; the frozen safe which probes found eststo and estfe already available.
2. No package was installed during this assessment; preserve the supplied estimators and directed-network setup.

Validation to perform later:

- Before any author program runs, confirm all nine exact command names with Stata which/help in the intended profile; check the seven preparation-required names after setup.

### ACT-RUNTIME-GUI: Confirm documented runtime versions, access and project compatibility for SAS and the manual GUI stages. GUI availability was not checked in this quality revision.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: S-SAS, S-UCINET, S-GEPHI, S-TABLEAU
Evidence: E-DATASHEET-SW, E-ENV, E-ENV-PROJECTION, E-MANUAL-NETWORK, E-MANUAL-MEMO, E-WORKITEM

Preparation / proposed procedure:

1. Confirm the documented SAS 9.4 runtime and license through an authorized metadata channel; keep SAS availability unverified until that channel supports it.
2. Confirm UCINET, Gephi, and Tableau versions, license, and project compatibility through their documented interfaces.
3. Treat the supplied datasheet/manual as version requirements, not proof of current installation.

Validation to perform later:

- Record exact version and access results for each runtime in a later authorized environment review.
- Open or refresh no author project until the separate project-input and data requirements are resolved.

### ACT-FULL-WORKFLOW-PROCEDURE: Conditional full-project partial order preserving all README SAS/Stata branches, manual network work, Python Figure 1 and the native Tableau/Gephi figures.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS-CLOSURE, ISS-HANDOFF
Evidence: E-README-WORKFLOW, E-MANUAL-NETWORK, E-MANUAL-MEMO, E-WORKITEM, E-HOP-HANDOFF, E-RPE-HANDOFF, E-TOUR-HANDOFF, E-PEER-PRODUCER, E-TABLE1B-GENERATED, E-TABLE1B-FIELDS

Preparation / proposed procedure:

1. Treat this as a partial order from the README and actual producers/consumers, conditional on resolving the separate source, software and handoff requirements. Stage the distinct ISS, Compustat, CRSP, ExecuComp, TNIC2/TNIC3, FF48, CIK-GVKEY, BoardEx, workbook and prepared-panel contracts through their linked actions; do not merge joint inputs into alternatives or conflate SIC/SICH, NAICS/NAICSH, or FYR/FYRC.
2. Prepare the annual ISS CIK peer edge lists and required time-valid issuer mappings. Follow the UCINET guide and memo for each year: import the edge lists, apply the documented missing/self/duplicate-pair handling, run Louvain and the specified centrality/eigenvector/density steps, then export mapped CIK/year measures before the SAS network readers use them. Keep unsupported CIK-GVKEY and peer-population mappings explicit.
3. Run clustering coefficient.do after its required edge list is ready. Process the C/R annual distance workbooks in the supplied hopping SAS path: import wide tables, transpose to long form and stack euclid_distance_C/R before any consumer that reads those measures.
4. Run peer selection summary stats.sas after its separate newpaypeer, Compustat and TNIC inputs resolve. It creates WORK.SUMMARY grouped by FYEAR/GVKEY; persist that same table as summary.dta in the configured Table 1B data directory, then run Table 1B.do to read the six generated summary measures.
5. Run hopping.sas after its own network/consultant files, annual Compustat, CRSP, index membership, segments, TNIC and FF48 inputs are ready; resolve the external FF48 classification include separately from public FF48 returns. It creates WORK.hopping19; compare its schema and row selection with the Stata hopping DTA before any same-object export.
6. Run pay for luck.sas on its separate CRSP/Compustat panel requirements before ConstructSample_competition.do and the related competition analyses. Preserve the supplied ret1/ret5/ret22 and winsor producers, then compare final WORK.rpe3 inherited fields/keys with Stata’s RPE and idio/correlation consumers before any persistence.
7. Run tournament.sas after its separate annual_comp, Compustat and peer inputs resolve; preserve the commented FF30 branch as optional. It writes WORK.tournament_final, but the current source map does not establish PAYGAP_INfirm/N_FF48CEOYR; settle that field producer before a competition consumer uses the file.
8. After temp_financialcontrols.dta is available, run ConstructSample_competition.do; it writes sample.dta. Run Analysis_competition.do and its required companions only after sample.dta plus the required RPE, tournament, governance and network measures are ready. Run Analysis_hopping.do after its own hopping, distance and cluster inputs are ready.
9. Run Figure 1.ipynb as a separate Python branch using Sheet1 of RA_change reason.xlsx and its documented pandas/numpy/wordcloud/matplotlib stack; validate the generated word cloud against the workbook categories.
10. Keep Figure 2.twbx and Figure 3A/3B.gephi as separate, present native figure branches. Their internal data, formulas, links, refresh steps and outputs are not registered; resolve those only through a supported safe native-project inspection before a later GUI attempt. Do not infer missing author code from the current assessment-format limit.
11. Independent Python and native-figure branches have no inferred total order relative to the SAS/Stata branches beyond their own inputs. Keep the full target and all README branches; do not use this procedure to claim the unresolved inputs are ready.

Validation to perform later:

- Before each producer, confirm its separate raw/prepared inputs, exact native field names, identifiers, periods and required history using the linked requirement actions.
- For UCINET and network measures, compare yearly edge lists, CIK/year mapping and exported fields with the actual SAS readers; for the cluster and distance stages, verify their native output keys and Stata/SAS consumer paths.
- For summary.dta, verify FYEAR/GVKEY and all six fields against the same WORK.SUMMARY result, then confirm the Table 1B read resolves to that export.
- For WORK.hopping19, WORK.rpe3 and WORK.tournament_final, compare the final same-session output with the exact consumer columns, keys, units, row selection and sample before any export; persist only from the actual final writer before a destructive reset/session end.
- Keep the CIBESLNK ticker/GVKEY interval requirement separate from IBCRSPHIST ticker/PERMNO and keep the missing FF48 classification macro distinct from public FF48 return data.
- Verify ConstructSample_competition.do reads the intended temp_financialcontrols.dta and writes sample.dta, then confirm each analysis/figure output corresponds to the README target.
- For native Tableau/Gephi projects, verify only registered safe source/refresh metadata before a later GUI run; maintain the project-presence and runtime PATH/version/licensing distinctions.

### ACT-PEER-SIC-MAP: Resolve the author-consumed COMP.FUNDA SIC definition and period mapping for own and peer rows before selecting a native alias or separate source.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-FUNDA-PEER, ISS-COMP-MAP
Evidence: E-PEER-FUNDA, E-PEER-STATS, E-SAS-15, E-SAS-15-HEADER, E-CATALOG, E-PAY-FUNDA, E-SAS-07

Preparation / proposed procedure:

1. Request the documented meaning, type, and period coverage of the SIC variable read as b.sic and c.sic from COMP.FUNDA.
2. Confirm that both matched records use the source condition a.fyear=matched_fyear+1, so matched Compustat FYEAR is a.fyear-1, and document how the source's floor(sic/100) comparison is preserved.
3. Treat SICH as a possible mapping only after its definition and period are supported. Consider COMP.COMPANY character SIC only as a separate candidate with a documented GVKEY/date join and period crosswalk.
4. Keep the FUNDA route unverified and retain the confirmed GVKEY/FYEAR/SALE/SICH read until a compatible source-field mapping is established.

Validation to perform later:

- Verify the exact source-consumed field, type/domain, own/peer join year, and historical definition against an authoritative schema or documented crosswalk.
- Update expected_fields and route status only when the SIC source and period mapping are supported; do not infer physical absence or equivalence from the catalog's variable list.


## Remaining issues and prerequisites

- ISS-ATTR [unresolved; full_pipeline]: Frozen header is Macroeconomic Information Acquisition around Earnings Clusters (DOI 10.1111/1475-679X.70020), while the supplied README and online appendix title the compensation peer-group network study. Preserve the frozen header and assess these actual contents; resolve package-to-paper attribution before attaching results.
- ISS-CLOSURE [unresolved; full_pipeline]: The complete workflow spans SAS, Stata, Python and manual UCINET/GUI stages. Mandatory author-prepared data, interval links, several producer/handoff contracts, software checks and native figure-project inputs remain unresolved; no compatible analysis-only bypass is established.
- ISS-HANDOFF [unresolved; full_pipeline]: SAS producers create WORK.hopping19, WORK.rpe3, WORK.tournament_final and WORK.SUMMARY. Table 1B and its producer establish that WORK.SUMMARY is the same-data summary handoff; only persistence/path setup remains. Hopping and RPE inherited-field/sample contracts, and the tournament target-field mapping, remain specifically unresolved.
- ISS-COMP-MAP [unresolved; full_pipeline]: Pay-for-luck's prepared input contract requires SIC, NAICS and FYRC; its source reads ccmfunda_0428 and its native-to-analysis mappings remain unresolved. Separately, peer selection consumes b.sic/c.sic from COMP.FUNDA at matched FYEAR=a.FYEAR-1 and compares floor(sic/100). The catalog lists SICH/NAICSH as historical labels and FYR, but this metadata is not proof that physical SIC is absent or that SICH is equivalent. CCMXPF_LINKTABLE separately supplies LPERMNO/link dates; do not assume aliases.
- ISS-IBES-LINK [unresolved; full_pipeline]: Source requires IBES.CIBESLNK ticker/GVKEY/FDATE/LDATE intervals; readable IBCRSPHIST has TICKER/PERMNO/NCUSIP/SDATE/EDATE/SCORE and is not a substitute.
- ISS-FF48-MACRO [unresolved; full_pipeline]: hopping.sas contains an external FF48 classification macro include not registered as an inspected source. Public French FF48 returns are a separate product and do not replace the include.
- ISS-NATIVE-GUI [unresolved; full_pipeline]: Figure 2.twbx and Figure 3A/3B.gephi appear in the frozen package inventory as kind=other, but their mixed native contents are not registered as work_item.sources. This is a bounded inspection-format limitation, not evidence that author code or a local installation is absent; embedded data, formulas, links, refresh and output details remain unknown.
- ISS-BOARD [unresolved; full_pipeline]: Local BoardEx summary/composition records are readable positive raw data but do not directly provide the required CUSIP6/year board metrics; the BoardEx crosswalk and metric construction are not supplied.
- R-FUNDA-PEER [undetermined]: Peer selection reads SIC and SALE for both own and peer COMP.FUNDA aliases. Its joins require a.fyear=b.fyear+1 and a.fyear=c.fyear+1, so each matched Compustat FYEAR is a.fyear-1; same_sic2 then compares floor(sic/100). The readable SICH field is labeled historical SIC, but its meaning and period compatibility with source-consumed SIC remain unknown.
- R-TNIC2 [public_acquisition_required]: Official TNIC-2 pairwise yearly network input.
- R-TNIC3 [public_acquisition_required]: Official TNIC-3 pairwise yearly network input.
- R-FF48 [public_acquisition_required]: Monthly Fama/French 48 Industry returns with a date key and 48 value-weighted industry series.
- R-HOPPING-PANEL [undetermined]: Stata hopping consumer contract for GVKEY/YEAR/EXECID/GVKEY_NEW/YEAR_NEW; supplied SAS writes WORK.hopping19, but its complete consumer schema and row population are not established in the registered field map.
- R-FIG1-WORKBOOK [undetermined]: Figure 1 workbook read from Sheet1/Category.
- R-PEERPAY-PANEL [undetermined]: Author-prepared newpaypeer panel shared by peer summary and Table 1A/1B.
- R-FINCONTROLS [undetermined]: temp_financialcontrols.dta starting input to competition sample builder.
- R-CLUSTER-EDGES [undetermined]: Prepared data_paypeer20062018.dta read by clustering coefficient code; producer absent.
- R-CLUSTERS-CSV [undetermined]: clusters.csv imported by hopping.sas; exact source/producer/schema unresolved.
- R-DOW-NASDAQ [undetermined]: Dow/Nasdaq membership interval table joined by GVKEY and datadate.
- R-CIK-GVKEY-LINK [undetermined]: Historical CIK/GVKEY interval crosswalk with FNDATE/LNDATE used in the hopping network merge.
- R-PEER-WORKBOOK [undetermined]: network1212.xlsx imported by hopping and tournament SAS as the annual peer workbook.
- R-IBES-LINK [undetermined]: IBES.CIBESLNK ticker-to-GVKEY effective-date link used against ANNDATS.
- R-EUCLID-C [undetermined]: Year-specific C-distance Excel matrices for 2006–2018.
- R-EUCLID-R [undetermined]: Year-specific R-distance Excel matrices for 2006–2018.
- R-CRSP-INFLATION [undetermined]: CRSP inflation series used to deflate returns, with CALDT and CPIRET.
- R-CCMFUNDA-PAY [undetermined]: Prepared ccmfunda_0428 pay-for-luck panel, including LPERMNO/FYRC/SIC/NAICS plus annual financials.
- R-CCMFUNDA-HOP [undetermined]: Prepared merged Compustat panel for hopping; includes SIC, CEQ, LPERMNO, GSECTOR and STATE.
- R-TOURN-COMP-DTA [undetermined]: Separate Data_Compustat_raw_2004-2019.dta used for tournament construction.
- R-TOURN-FUNDA [undetermined]: Compustat FUNDA input to tournament requiring GVKEY/FYEAR/SIC/SALE/STATE.
- R-TOURN-GAP [undetermined]: Competition analysis requires PAYGAP_INfirm and N_FF48CEOYR; tournament.sas creates WORK.tournament_final, but the existing field map does not establish those target fields or their definitions.
- R-PEER-BENCHMARK [undetermined]: Prepared peer-pay benchmark fields merged into competition sample.
- R-SIZE-PEERS [undetermined]: Prepared FF/SIC/TNIC/geography size-peer pay and peer counts.
- R-DURATION [undetermined]: Prepared CEO duration control merged by GVKEY/FYEAR.
- R-CEO-TENURE [undetermined]: Prepared CEO tenure control ceo_tenure2 with source timing/missing-date adjustment.
- R-DELTA-VEGA [undetermined]: Executive-firm/year delta incentive panel merged into competition sample.
- R-INDVOL [undetermined]: The competition analysis consumes lag_volatility12. Its upstream source, definition, period timing, producer and merge keys remain unresolved.
- R-RPE-PANEL [undetermined]: Competition Stata consumer contract for GVKEY/FYEAR, skill/luck and annual own/peer return fields; WORK.rpe3 is supplied as a final writer from rpe2 plus idio_var/corr, but the inherited field schema and population are not fully mapped.
- R-IDIO-CORR [undetermined]: Prepared firm-year idiosyncratic variance and peer correlation controls.
- R-HHI [undetermined]: Prepared firm-year HHI control used in competition analysis.
- R-FUTURE-PERF [undetermined]: Future-performance panel with ROA/return leads, standard deviations and counts.
- R-BOARD [undetermined]: BoardEx-derived CUSIP6/FYEAR board size, independence, busy-director and chair/CEO measures.
- R-EINDEX [undetermined]: Prepared CUSIP8/FYEAR EINDEX governance panel.
- R-CCO [undetermined]: Prepared CIK-own/CIK-peer/year CCO group panel.
- R-NETWORK-MEASURES [undetermined]: network measures_1203.xlsx native/manual network output consumed by tournament SAS.
- R-ISS-CONSULTANT [undetermined]: Prepared consultant-control table imported by hopping.sas.
- R-ISS-EDGE-LIST [undetermined]: Annual ISS CIK-own/CIK-peer edge lists for UCINET manual network construction.
- S-SAS [unverified]: Datasheet requires SAS 9.4; local executable is documented but startup/library/license were not tested.
- S-WORDCLOUD [preparation_required]: Static distribution metadata reports WordCloud absent; notebook imports it.
- S-WINSOR2 [preparation_required]: Original registered environment viewer reports winsor2 unavailable; supplied Stata code calls it.
- S-CORSP [preparation_required]: Stata 18 bounded which query: corsp returned not-found (111); configure this extension before its source branch.
- S-LOGIT2 [preparation_required]: Stata 18 bounded which query: logit2 returned not-found (111); configure this extension before its source branch.
- S-FIRTHLOGIT [preparation_required]: Stata 18 bounded which query: firthlogit returned not-found (111); configure this extension before its source branch.
- S-ASDOC [preparation_required]: Stata 18 bounded which query: asdoc returned not-found (111); configure this extension before its source branch.
- S-RANGEJOIN [preparation_required]: Stata 18 bounded which query: rangejoin returned not-found (111); configure this extension before its source branch.
- S-NWSET [preparation_required]: Stata 18 bounded which query: nwset returned not-found (111); configure this extension before its source branch.
- S-NWCLUSTERING [preparation_required]: Stata 18 bounded which query: nwclustering returned not-found (111); configure this extension before its source branch.
- S-UCINET [unverified]: The datasheet/manual name UCINET 6.66 for the manual network stage. Availability was not checked in this quality revision; exact version, license and project compatibility remain unverified.
- S-GEPHI [unverified]: The datasheet names Gephi 0.10.1 for packaged native network projects. Availability was not checked in this quality revision; exact version, license and project compatibility remain unverified.
- S-TABLEAU [unverified]: The datasheet names Tableau 2023.2 for the packaged Figure 2 project. Availability was not checked in this quality revision; exact version, license and project compatibility remain unverified.

## Review notes

- This targeted revision preserves the full_pipeline scope and prior positive local/public/software findings; unresolved upstream data, producer, software, and manual-project gaps remain.
- Peer selection reads b.sic/c.sic from COMP.FUNDA and matches each at a.fyear=matched_fyear+1, so matched Compustat FYEAR is a.fyear-1. The first-two-digit SIC comparison is explicit; SICH meaning and period compatibility remain unknown.
- COMP.FUNDA catalog metadata lists historical SICH and a separate COMP.COMPANY character SIC, but does not establish physical SIC absence, alias equivalence, or a historical replacement. COMP.COMPANY remains a candidate only.
- Table 1B explicitly identifies summary.dta as generated by the same SAS source that creates WORK.SUMMARY. The remaining task is same-data persistence/path setup, not an independent raw-panel or separate author-approval prerequisite.
- The sanitized prior findings and evidence-location index were used only to preserve IDs, workflow context, and coverage. Current source quotations come from this generation's approved reader views; prior measurement evidence uses exact current-generation copies/projections.
- The prior R-GAI lead is not retained as a separate mandatory raw input: the frozen work item has no exact GAI source path or dependency metadata record, and none of the existing admitted source views provides a direct GAI consumer/producer contract. This coverage-limited note does not claim GAI is absent from unexamined material; reconsider only if an author-supported contract is supplied.
