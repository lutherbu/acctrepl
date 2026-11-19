# Patch proposal: jar-2b5ebbf011ea

Truncating Optimism

DOI: 10.1111/1475-679X.12397

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied SAS workflow that constructs the EPS, GAAP/GPS, consensus and cross-sectional supporting samples/variables, including Additional_Input.sas before KMX_Code.sas and the embedded Stata median-bin preparation snippets. The datasheet’s WINSOR2 and REGHDFE analyses are contextual because their standalone scripts are not supplied.

Entry points: `Additional_Input.sas`, `KMX_Code.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 5/12397 - Truncating-Optimism/kmx-datasheet-code-and-identifiers.zip",
      "sha256": "9bb1128799968de205234442d49657c5848cd349ba00ec64424298b4a148d199"
    },
    {
      "path": "JAR-Volume 59/Issue 5/12397 - Truncating-Optimism/kmx-online-appendix.pdf",
      "sha256": "a9c2df5f706cbe40fb1842c38ac3a31f01025d8a77ddc5f81a16f1233b2234c6"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "0bf787257f7c4c8a23abb4164ef2475544e0836b60e80ff37cd6feb9b1329304"
}
```

## Proposed actions

### ACT-WRDS-DELTA-SOURCES: Obtain or stage compatible underlying inputs for Additional_Input.sas: COMP.FUNDA, CRSP.CCMXPF_LNKHIST, CRSP.MSF, FRB.RATES_DAILY and each of six distinct ExecuComp tables. The authors’ remote WRDS session is one route; a documented compatible local source can substitute with coherent library-root configuration.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ-COMPUSTAT-FUNDA-DELTA, REQ-CCMXPF-LNKHIST, REQ-CRSP-MSF-DELTA, REQ-FRB-RATES-DAILY, REQ-EXEC-ANNCOMP-DELTA, REQ-EXEC-PERSON-DELTA, REQ-EXEC-CODIRFIN-DELTA, REQ-EXEC-STGRTTAB-DELTA, REQ-EXEC-EXBLACK-DELTA, REQ-EXEC-OUTSTANDING-DELTA
Evidence: E-ADD-WRDS-SESSION, E-ADD-REMOTE-LINK-RET, E-ADD-RATES, E-ADD-ANNCOMP, E-ADD-PERSON, E-ADD-CODIRFIN, E-ADD-STGRTTAB, E-ADD-EXBLACK, E-ADD-OUTSTANDING, E-CAT-LOOKUP

Preparation / proposed procedure:

1. Confirm authentication/component access for the SIGNON/RSUBMIT route, or document a compatible local staged-source route for the named tables; remote access is not assumed.
2. For either route, establish the annual Compustat 1986–2015 filter, dated CCM link rules, CRSP MSF 1–60 month lookback, six rate fields and 1992–2015 coverage, and 1992–2015 windows for all six ExecuComp sources.
3. For catalog candidates, verify live readability, required fields, period coverage, and any transformations/root changes before substituting them into the authored workflow. Exact author-file bytes/vintage are not required when a compatible route is documented.

Validation to perform later:

- After the data route is authorized, compare actual source names, fields, fiscal/event date coverage and join keys against the cited code; catalog metadata alone does not establish a usable file.

### ACT-KMX-AUTHOR-INPUTS: Obtain or construct compatible inputs for every distinct KMX RAW source used by the EPS, non-EPS/GPS, consensus, guidance, quarterly-accounting, index, monthly-CRSP, insider, annual-compensation, IR and earnings-volatility branches. Author-prepared filenames are a useful route where available; documented compatible local sources and constructions can also satisfy the contract.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ-IBES-DETAIL-EPS, REQ-IBES-ACTUAL-EPS, REQ-CRSP-DAILY-RET, REQ-IBES-EXCLUDED-EPS, REQ-IBES-STOPPED-EPS, REQ-IBES-MGMT-GUIDE, REQ-IBES-DETAIL-NONEPS, REQ-IBES-ACTUAL-NONEPS, REQ-IBES-EXCLUDED-NONEPS, REQ-IBES-STOPPED-NONEPS, REQ-IBES-SUMMARY-EPS, REQ-COMP-QTRFIRMCHAR, REQ-COMPUSTAT-SPIDX-CST, REQ-CRSP-MONTH-CRSP, REQ-THOMSON-INSIDER, REQ-EXECU-ANNUAL-COMP, REQ-IR-OFFICERS, REQ-COMP-8920-EAVOL, REQ-MGMT-92-18, REQ-COMP-9020-QTRFIRMCHAR
Evidence: E-DOC-SOURCES, E-KMX-ENTRY, E-KMX-MAIN-DETAIL, E-KMX-GAAP-DETAIL, E-KMX-SUMMARY, E-KMX-COMPQ, E-KMX-SP500, E-KMX-MONTH-CRSP, E-KMX-INSIDER, E-KMX-EXEC-ANNUAL, E-KMX-IR, E-KMX-EAVOL-IN, E-KMX-MGMT92, E-KMX-COMP9020, E-CAT-LOOKUP, E-CAT-LOOKUP-EXTRA

Preparation / proposed procedure:

1. For each KMX RAW source, document a viable author-prepared or independently compatible source route with its fields, identifiers, complete dates, source product and construction; request author details only where those facts cannot otherwise be established.
2. Preserve the separate I/B/E/S DETAIL/ACTUAL/EXCLUDED/STOPPED EPS and non-EPS/GPS branches; do not substitute EPS-only records for the GPS branch.
3. Confirm Chapman IR records and each Compustat/CRSP/Thomson construction. Keep the IR contract, daily-return NCUSIP mapping, quarterly SIC mapping, and FRB DGS/TCMNOM mapping unresolved until documented.
4. For local catalog candidates, confirm the required code fields and complete coverage before staging them. CRSP MSP500LIST is not equivalent to Compustat SPIDX_CST; COMP.FUNDQ is not an author-prepared quarterly input until its SIC mapping, period and construction are established.

Validation to perform later:

- Compare each delivered table’s product identity, source fields, units/identifiers, date ranges and linkage fields against its exact code consumer; keep unresolved cases undetermined.

### ACT-DAILY-RET-MAP: Resolve the required CRSP daily identifier contract before constructing RAW.DAILY_RET. The code joins actuals by CUSIP=NCUSIP and also needs split factors, prices, PERMNO and dates.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-CRSP-DAILY-RET, ISSUE-DAILY-RET-MAPPING
Evidence: E-ADD-EPS-DAILY, E-KMX-MAIN-ACTUAL, E-CATALOG-FULL

Preparation / proposed procedure:

1. Ask the authors to supply the prepared DAILY_RET file or document its NCUSIP creation/crosswalk and date-selection rule.
2. Do not infer NCUSIP from CRSP DSF CUSIP or silently rename the field.

Validation to perform later:

- When the documented file/mapping is available, confirm the identifiers and field names used by the announcement-date and split-adjustment joins.

### ACT-PATH-HANDOFFS: Resolve the split local RESULT roots and hardcoded D: paths through one documented output-root configuration/staging step while retaining the remote WRDS session boundary.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE-OUTPUT-HANDOFFS
Evidence: E-ADD-ENTRY, E-ADD-WRDS-SESSION, E-ADD-SE-OUT, E-ADD-DELTA-OUT, E-KMX-MAINSAMPLE, E-KMX-EXEC-ANNUAL, E-KMX-EAVOL-HANDOFF, E-KMX-EAVOL-IMPORT

Preparation / proposed procedure:

1. Set the local RAW and RESULT roots for the current machine and map every absolute Windows input/output in both entry programs to the agreed staged roots.
2. Make SE_190516 produced under RESULT available to KMX; stage or consistently rebind the downloaded delta from RESULT_202008 to the RESULT library KMX reads.
3. Preserve KMX’s native DTA export/import handoffs, including CROSS_EAVOL.DTA written before it is imported, and write all DTA outputs under one configured output root.

Validation to perform later:

- Review the complete producer and consumer paths for SE_190516, DELTA, all result SAS tables and all DTA files before any authorized run.

### ACT-SOFTWARE-METADATA: Confirm SAS runtime, SAS/CONNECT and the SAS/ACCESS PC Files capability using permitted software metadata and license/component checks. Do not treat the TKELS startup error as evidence that the license is missing.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS, SW-SASCONNECT, SW-SAS-PCFILES
Evidence: E-ENV-SOFTWARE, E-ADD-WRDS-SESSION, E-SAS-PCFILES-DOC, E-KMX-MAINSAMPLE, E-KMX-EAVOL-IMPORT

Preparation / proposed procedure:

1. Check the installed SAS 9.4 runtime/version and the presence/configuration of SAS/CONNECT for SIGNON/RSUBMIT/PROC DOWNLOAD.
2. Check whether the SAS/ACCESS Interface to PC Files license/component supports the code’s DTA export and import DBMS identifiers.
3. Use Stata 18 for the exact embedded XTILE preparation snippets only after their input DTA files have been generated.

Validation to perform later:

- Record successful version/component metadata and, after separate authorization, validate the specified handoff formats without running the author program during this assessment.

### ACT-MANUAL-STATA-PREP: Stage the supplied median-split commands from SAS comments for later Stata preparation, preserving each variable name and the source branch order; resolve command/function/option spelling before execution.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: ISSUE-MANUAL-STATA
Evidence: E-STATA-SNIPPETS-COVERAGE, E-STATA-SNIPPETS-OTHER, E-STATA-SNIPPETS-DELTA, E-STATA-SNIPPETS-DISP, E-ENV-SOFTWARE, E-STATA-SNIPPETS-NETSALE, E-SOFTWARE-GXTILE

Preparation / proposed procedure:

1. Extract the supplied EGEN XTILE and REPLACE statements for coverage, size, net sale, delta and forecast dispersion, preserving variable-name case and retaining the source token spelling in a staging copy.
2. The nested _gxtile helper is found by Stata 18 metadata, but that check does not validate the snippet. Resolve uppercase command/function/option token compatibility through primary Stata help before any later authorized run; otherwise leave compatibility unknown.
3. Run the preparation stage only after the matching SAS DTA outputs and roots are ready. Keep WINSOR2 and REGHDFE contextual to the separately unprovided final analysis scripts.

Validation to perform later:

- Compare the extracted snippets against their source comment locations and confirm input DTA/variable production order; record the primary help resolution or retain token-case compatibility as unknown before any later authorized execution.

### ACT-INPUT-CLOSURE: Reconcile every supplied branch input to a viable documented route and complete field/history/construction contract; author confirmation is needed only where a compatible route cannot be established independently.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE-INPUT-CLOSURE
Evidence: E-DOC-SOURCES, E-ADD-ENTRY, E-KMX-ENTRY, E-CAT-LOOKUP, E-CAT-LOOKUP-EXTRA, E-ID-IDENTIFIER

Preparation / proposed procedure:

1. For each RAW table read by the supplied programs, document its exact fields, identifiers, date coverage, construction and provenance from either author-prepared files or a verified compatible local/public source route.
2. Resolve only the genuinely unknown contracts: IR officer records, daily-return NCUSIP, quarterly SIC, FRB rate naming/equivalence, and the distinct alternative EPS/GPS/consensus/guidance branches.
3. Keep identifier.dta as an identifier list only; it does not replace any of the required source panels.

Validation to perform later:

- Reconcile each provided source table to the matching requirement and frozen dependency edge; mark closure only when a compatible route’s fields, history and construction are documented.

### ACT-DELTA-GVKEY-NAMESPACE: Use the already-generated WORK.DELTA table, which contains the added GVKEY_N field, as the SQL source on line 1460.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE-DELTA-GVKEY-ALIAS
Evidence: E-KMX-EXEC-ANNUAL, E-ADD-DELTA-OUT

**Proposed edit:** `KMX_Code.sas:1460–1460`
Source SHA-256: `e5eda63e4a923e82c4b7ccadf377a999c063fb22a17b6ca9eec712325bf7a4f2`

The preceding DATA DELTA step reads RESULT.DELTA and creates GVKEY_N in WORK.DELTA. The producer in Additional_Input.sas keeps only GVKEY, COPEROL, YEAR and DELTA in downloaded RESULT.DELTA, but this join refers to A.GVKEY_N. Using the generated WORK.DELTA supplies the exact already-authored key without changing formulas, samples or source records.

Current text:
```
FROM RESULT.DELTA A LEFT JOIN CEO B
```

Proposed replacement:
```
FROM DELTA A LEFT JOIN CEO B
```

Preparation / proposed procedure:

1. Apply this exact one-line reference correction after confirming the frozen KMX_Code.sas hash and line content.
2. Retain the existing numeric GVKEY_N construction from the author code and preserve the original join keys and filters.

Validation to perform later:

- Static review confirms WORK.DELTA is created at line 1455 with GVKEY_N before the SQL join and that the join no longer references a field absent from downloaded RESULT.DELTA. Any later data-run validation requires separate authorization.


## Remaining issues and prerequisites

- ISSUE-INPUT-CLOSURE [unresolved; full_pipeline]: The package contains no full author input panel. The two SAS programs read distinct EPS, non-EPS/GPS, consensus, guidance, CRSP, Compustat, ExecuComp, insider, index and IR files. Catalog matches are product candidates only; exact prepared schemas, field mapping, vintage, access and complete history remain unverified.
- ISSUE-DAILY-RET-MAPPING [unresolved; full_pipeline]: The consumed RAW.DAILY_RET requires NCUSIP for the actual announcement join. Frozen CRSP DSF metadata lists CUSIP but does not provide NCUSIP; the required source-specific crosswalk or author-prepared DAILY_RET mapping is not supplied. Do not assume CUSIP=NCUSIP.
- ISSUE-OUTPUT-HANDOFFS [preparation; full_pipeline]: Additional_Input.sas writes SE_190516 to RESULT, but its later PROC DOWNLOAD writes DELTA under the re-bound local RESULT_202008 root; KMX_Code.sas reads RESULT.SE_190516 and RESULT.DELTA. KMX SAS output roots and exported DTA roots also vary. Configure or stage these produced files consistently before KMX.
- ISSUE-MANUAL-STATA [preparation; full_pipeline]: Several cross-sectional median-split snippets are only in SAS block comments and spell EGEN, XTILE and REPLACE in uppercase. The nested _gxtile helper is found by Stata 18 metadata, but command/function/option token-case compatibility remains unknown; keep the supplied variable-name case and resolve token spelling through primary Stata help before any later authorized run.
- ISSUE-DELTA-GVKEY-ALIAS [preparation; full_pipeline]: KMX_Code.sas creates WORK.DELTA from RESULT.DELTA and adds numeric GVKEY_N, but the next SQL join reads RESULT.DELTA directly and references A.GVKEY_N. Additional_Input.sas keeps only GVKEY, COPEROL, YEAR and DELTA in the downloaded RESULT.DELTA, so A.GVKEY_N is absent from that source. The already-created WORK.DELTA is the supported source for the join.
- REQ-IBES-DETAIL-EPS [undetermined]: RAW.IBES_DETAIL_QTR is a mandatory input to the supplied branch. Code-level fields: TICKER, ANALYS, FPEDATS, VALUE, ANNDATS, REVDATS, FPI, ESTIMATOR, ANNTIMS, ACTDATS, MEASURE. Required use/period: Unadjusted quarterly EPS-detail history used for the optimism, main sample and cross-sectional branches; full required history is not specified by a packaged input..
- REQ-IBES-ACTUAL-EPS [undetermined]: RAW.ACTUAL is a mandatory input to the supplied branch. Code-level fields: TICKER, CUSIP, PENDS, PDICITY, MEASURE, VALUE, ANNDATS, USFIRM. Required use/period: Quarterly EPS actual announcements matched to forecasts and CRSP; the required sample history is not established by a row probe..
- REQ-CRSP-DAILY-RET [undetermined]: RAW.DAILY_RET is a mandatory input to the supplied branch. Code-level fields: NCUSIP, PERMNO, PRC, DATE, CFACSHR. Required use/period: Daily identifiers/prices/split factors support announcement-date PERMNO linkage and split adjustment. Local DSF metadata has CUSIP but not the code-required NCUSIP; a mapping or author-prepared source needs confirmation..
- REQ-IBES-EXCLUDED-EPS [undetermined]: RAW.EXCLUDED is a mandatory input to the supplied branch. Code-level fields: TICKER, ESTIMATOR, ANALYS, FPEDATS, FPI, MEASURE, EXCFLA, EXCDATS, ACTDATS, VALUE, EXCENDS. Required use/period: Separate EPS forecast-removal records are joined with active estimates in both optimism and main-sample branches..
- REQ-IBES-STOPPED-EPS [undetermined]: RAW.STOPPED is a mandatory input to the supplied branch. Code-level fields: TICKER, ESTIMATOR, FPEDATS, ASTPDATS, PDICITY, MEASURE. Required use/period: Separate EPS stopped-estimate history is used to screen analyst forecasts..
- REQ-COMPUSTAT-FUNDA-DELTA [undetermined]: COMP.FUNDA is a mandatory input to the supplied branch. Code-level fields: GVKEY, DATADATE, FYEAR, INDFMT, DATAFMT, POPSRC, CONSOL. Required use/period: Additional_Input filters annual records from 1986–2015 (start_year 1992 minus six) and uses fiscal dates to build annual executive compensation delta inputs..
- REQ-CCMXPF-LNKHIST [undetermined]: CRSP.CCMXPF_LNKHIST / RAW.CCMXPF_LNKHIST is a mandatory input to the supplied branch. Code-level fields: GVKEY, LPERMNO, LINKPRIM, LINKTYPE, LINKDT, LINKENDDT. Required use/period: Needed for the remote Compustat-to-CRSP link in the delta stage and for the KMX Compustat firm characteristics, S&P, IR, delta and earnings-volatility joins..
- REQ-CRSP-MSF-DELTA [undetermined]: CRSP.MSF is a mandatory input to the supplied branch. Code-level fields: PERMNO, DATE, RET. Required use/period: Additional_Input calculates rolling annual volatility using monthly returns 1–60 calendar months before fiscal-year start; the remote MSF table is not interchangeable with KMX MONTH_CRSP without a supported mapping..
- REQ-FRB-RATES-DAILY [undetermined]: FRB.RATES_DAILY is a mandatory input to the supplied branch. Code-level fields: DATE, TCMNOM_Y1, TCMNOM_Y2, TCMNOM_Y3, TCMNOM_Y5, TCMNOM_Y7, TCMNOM_Y10. Required use/period: Additional_Input uses daily rates for 1992–2015, computes annual means and interpolates the 4-, 6-, 8- and 9-year values. Frozen catalog candidate fields use DGS names, so alias/product mapping is unresolved..
- REQ-EXEC-ANNCOMP-DELTA [undetermined]: EXECCOMP.ANNCOMP is a mandatory input to the supplied branch. Code-level fields: CO_PER_ROL, YEAR, GVKEY, EXECID, SHROWN_EXCL_OPTS, SHROWN_TOT, OPT_UNEX_* fields, compensation/award fields retained by Additional_Input. Required use/period: Separate ExecuComp annual compensation table for 1992–2015; a broad exact field-level contract and vintage need author confirmation..
- REQ-EXEC-PERSON-DELTA [undetermined]: EXECCOMP.PERSON is a mandatory input to the supplied branch. Code-level fields: EXECID, EXEC_FULLNAME. Required use/period: Separate executive identity table used to construct/merge compensation records..
- REQ-EXEC-CODIRFIN-DELTA [undetermined]: EXECCOMP.CODIRFIN is a mandatory input to the supplied branch. Code-level fields: GVKEY, YEAR, BS_VOLATILITY, BS_YIELD, DIVYIELD, SHRSOUT, PRCCF, FYR, SRCDATE. Required use/period: Separate company financial/director compensation table, used in the option volatility and valuation stage..
- REQ-EXEC-STGRTTAB-DELTA [undetermined]: EXECCOMP.STGRTTAB is a mandatory input to the supplied branch. Code-level fields: CO_PER_ROL, YEAR, BLKSHVAL, EXDATE, EXPRIC, GRNTNUM, MKTPRIC, NUMSECUR. Required use/period: Separate stock-option grant table used for grant-specific compensation calculations..
- REQ-EXEC-EXBLACK-DELTA [undetermined]: EXECCOMP.EX_BLACK is a mandatory input to the supplied branch. Code-level fields: RISK_FREE_RATE, YEAR. Required use/period: Separate Black–Scholes/risk-free-rate table used by Additional_Input..
- REQ-EXEC-OUTSTANDING-DELTA [undetermined]: EXECCOMP.OUTSTANDINGAWARDS is a mandatory input to the supplied branch. Code-level fields: CO_PER_ROL, YEAR, OPTS_UNEX_EXER, OPTS_UNEX_UNEXER, OPTS_UNEX_UNEARN, EXPRIC, EIP_SHRS_UNVEST_NUM, EIP_SHRS_UNVEST_VAL, OUTAWDNUM, SHRS_UNVEST_NUM, SHRS_UNVEST_VAL, EXDATE. Required use/period: Separate outstanding-awards table contributes option awards to the delta calculation..
- REQ-IBES-MGMT-GUIDE [undetermined]: RAW.MGMT_GUIDE is a mandatory input to the supplied branch. Code-level fields: TICKER, PDICITY, MEASURE, RANGE_DESC, GUIDANCE_CODE, ACTDATS, ANNDATS, PRD_YR, PRD_MON, VAL_1, VAL_2. Required use/period: Prepared management-guidance records used for the main optimism/guidance branch..
- REQ-IBES-DETAIL-NONEPS [undetermined]: RAW.DETAIL_IBES_ALL is a mandatory input to the supplied branch. Code-level fields: TICKER, FPEDATS, VALUE, ANNDATS, REVDATS, FPI, ESTIMATOR, ANNTIMS, ACTDATS, MEASURE, ANALYS. Required use/period: Distinct non-EPS/GPS detail history for the supplied GAAP branch; do not substitute EPS-only detail records..
- REQ-IBES-ACTUAL-NONEPS [undetermined]: RAW.ACTUAL_ALL is a mandatory input to the supplied branch. Code-level fields: TICKER, CUSIP, PENDS, PDICITY, MEASURE, VALUE, ANNDATS, USFIRM. Required use/period: Distinct non-EPS/GPS actuals for the GAAP branch; do not substitute EPS-only actuals..
- REQ-IBES-EXCLUDED-NONEPS [undetermined]: RAW.EXCLUDED_ALL is a mandatory input to the supplied branch. Code-level fields: TICKER, ESTIMATOR, ANALYS, FPEDATS, FPI, MEASURE, EXCFLA, EXCDATS, ACTDATS, VALUE, EXCENDS. Required use/period: Distinct non-EPS/GPS removed-estimate records; no exact local excluded product was identified in the saved lookup..
- REQ-IBES-STOPPED-NONEPS [undetermined]: RAW.STOPPED_ALL is a mandatory input to the supplied branch. Code-level fields: TICKER, ESTIMATOR, FPEDATS, ASTPDATS, PDICITY, MEASURE. Required use/period: Distinct non-EPS/GPS stopped-estimate history; no exact local stopped product was identified in the saved lookup..
- REQ-IBES-SUMMARY-EPS [undetermined]: RAW.SUMMARY_QTR_UNADJUSTED is a mandatory input to the supplied branch. Code-level fields: TICKER, FPEDATS, FPI, MEASURE, STATPERS, NUMEST, MEANEST. Required use/period: Unadjusted quarterly EPS summary statistics used for the consensus sample..
- REQ-COMP-QTRFIRMCHAR [undetermined]: RAW.COMP_QTRFIRMCHAR supplies quarterly accounting variables for consensus/cross-section joins, lags and firm characteristics. The frozen quarterly COMP.FUNDQ candidate has neither SIC nor SICH in its catalog metadata, while this code expects SIC; use it only with a documented compatible industry-code mapping/join or a prepared source.
- REQ-COMPUSTAT-SPIDX-CST [undetermined]: RAW.SPIDX_CST is a mandatory input to the supplied branch. Code-level fields: INDEXID, CUSIPX, CONMX, DATADATE. Required use/period: Compustat index constituents for dated S&P 500 membership; code selects INDEXID="500" and joins CUSIPX/DATADATE. No direct Compustat SPIDX_CST match in the saved catalog queries..
- REQ-CRSP-MONTH-CRSP [undetermined]: RAW.MONTH_CRSP is a mandatory input to the supplied branch. Code-level fields: PERMNO, DATE, PRC, SHROUT. Required use/period: KMX size branch needs monthly stock price/shares outstanding around the prior announcement date; kept separate from Additional_Input’s CRSP.MSF volatility route..
- REQ-THOMSON-INSIDER [undetermined]: RAW.INSIDER_TRADING is a mandatory input to the supplied branch. Code-level fields: CLEANSE, TRANCODE, TRANDATE, SHARES, TPRICE, CUSIP6, ROLECODE1, TICKER, OWNER, PERSONID, DCN. Required use/period: Insider transaction data with the code’s purchase/sale, price, share, cleanse and officer-role fields. Catalog identifies Thomson Table 1 as a product candidate; completeness and matching history remain unverified..
- REQ-EXECU-ANNUAL-COMP [undetermined]: RAW.EXECU_ANNUAL_COMP is a mandatory input to the supplied branch. Code-level fields: GVKEY, YEAR, CO_PER_ROL, CEOANN. Required use/period: Separate annual compensation input to select CEOANN=2 and join generated delta; catalog ANNCOMP is only a candidate, not a proven equivalent prepared file..
- REQ-IR-OFFICERS [undetermined]: RAW.IR is a mandatory input to the supplied branch. Code-level fields: GVKEY, CONM, IR, RDQ, FYEARQ, FQTR. Required use/period: Author-shared conference-call investor-relations officer data; code limits events to 2002–2015 and joins around prior announcement date..
- REQ-COMP-8920-EAVOL [undetermined]: RAW.COMP_8920_EAVOL is a mandatory input to the supplied branch. Code-level fields: GVKEY, DATADATE, FYEARQ, FQTR, IBQ, ATQ. Required use/period: Prepared quarterly accounting table needed for earnings volatility. Code internally copies it to RAW.COMP_IBQ, then constructs and exports CROSS_EAVOL; it is not a second external input..
- REQ-MGMT-92-18 [undetermined]: RAW.MGMT_92_18 is a mandatory input to the supplied branch. Code-level fields: TICKER, ANNDATS, MEASURE, PDICITY, PRD_MON, PRD_YR, VAL_1, VAL_2, GUIDANCE_CODE. Required use/period: A separate guidance history file is consumed for the additional branch. The exact 1992–2018 author-prepared table is not included in the package..
- REQ-COMP-9020-QTRFIRMCHAR [undetermined]: RAW.COMP_9020_QTRFIRMCHAR is a mandatory input to the supplied branch. Code-level fields: GVKEY, DATADATE, FYEARQ, FQTR, ATQ, CSHOQ, PRCCQ, CEQQ, TXDBQ, PSTKQ, SEQQ, LTQ, REVTQ, COGSQ, XSGAQ, XINTQ, XRDQ, SIC. Required use/period: Separate quarterly firm-characteristics preparation input for the final earnings-volatility/firm-characteristic merge; its construction and history must be confirmed separately..
- SW-SAS [unverified]: Required to run both supplied SAS entry points. The cached startup probe failed during TKELS initialization and explicitly does not establish a missing license or a working runtime.
- SW-SASCONNECT [unverified]: Additional_Input.sas calls SIGNON, RSUBMIT, PROC DOWNLOAD and SIGNOFF to reach WRDS. Runtime/component availability and authentication are unverified.
- SW-SAS-PCFILES [unverified]: The supplied SAS program exports multiple DTA files and imports CROSS_EAVOL.DTA. Official SAS 9.4 documentation indicates the Stata DBMS path depends on SAS/ACCESS Interface to PC Files; local license/component availability was not checked.

## Review notes

- Substantive full-pipeline draft saved from direct inspection of both supplied SAS programs, the datasheet, cached appendix text and frozen catalog metadata. All 88 frozen dependency IDs are classified below as source requirements or source-supported generated outputs/intermediates.
- The only packaged data file is identifier.dta. Its cached probe reports only ibes_ticker; it is not a sample panel, a prepared input table or a substitute for the consumed RAW files.
- The catalog is frozen resource metadata and saved product lookup output. It does not establish live access, file readability, complete historical coverage, author vintage or compatibility. No raw file was opened/read in this continuation.
- All supplied main, GAAP/GPS, consensus, index, size, long/short, insider, compensation delta, IR, guidance, forecast-dispersion and earnings-volatility branches are retained. COMP_IBQ and CROSS_EAVOL are internal generated handoffs, not missing external inputs.
- The datasheet describes WINSOR2 and REGHDFE in Stata, but the separate final regression scripts are not supplied. They remain contextual to this supplied data-preparation scope; no analysis-only route is claimed.
- Stata metadata check confirmed `which _gxtile` at runtime version 18 only; no generated data, XTILE computation or syntax trial was performed. The uppercase command/function/option spelling in comments remains unresolved pending primary Stata help.
- Source QA found a supported KMX delta join field-source mismatch: the author-created WORK.DELTA has GVKEY_N, while the downloaded RESULT.DELTA source does not. The proposal specifies a one-line FROM-source correction without changing the method or sample.
- Compatible local source routes can satisfy raw inputs when their field, history, construction and staging contracts are independently documented; exact author-prepared file identity is not a mandatory gate.
