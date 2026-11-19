# Patch proposal: jar-5421b84ab413

Standard Error Biases When Using Generated Regressors in Accounting Research

DOI: 10.1111/1475-679X.12470

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied workflow: MATLAB Figure 4 simulation → SAS2 bootstrap → MATLAB3/4 plots; a separate MATLAB Table 2 simulation; and SAS Table 1, staged Table 3 Compustat/litigation → IBES → regression, and Table 4 applications. The three packaged XLSX files are PERMNO/DATADATE sample identifiers, not full analytic panels. Figure 4 producer/export statements are commented, so scope closure remains incomplete for that specific edge pending the three supported unapplied edits.

Entry points: `Codes/Figure 4/Simulation_figure4_1.m`, `Codes/Figure 4/Fig4C Bootstrapping_2.sas`, `Codes/Figure 4/Figure4A_3.m`, `Codes/Figure 4/Figure4B4C_4.m`, `Codes/Table 1/1 - discretionary accruals.sas`, `Codes/Table 2/Table2.m`, `Codes/Table 3/1 - compustat and litigation.sas`, `Codes/Table 3/2 - IBES.sas`, `Codes/Table 3/3 - regression.sas`, `Codes/Table 4/1 - conservatism and investment.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 2/12470 - Standard-Error-Biases-When-Using-Generated-Regressors-in-Accounting-Research/chm2023-datasheet-code-and-identifiers.zip",
      "sha256": "49f1343cc5a2992f0ee0c85b2ac6f7628e37f7bb7a6c89275d690fbe36724512"
    },
    {
      "path": "JAR-Volume 61/Issue 2/12470 - Standard-Error-Biases-When-Using-Generated-Regressors-in-Accounting-Research/chm2023-online-appendix.pdf",
      "sha256": "921c7836576c675cd7c910532135e169f851121001ab9ec6fdd6f9157d73ea3b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "17a3435662001657f2a187e78e6716b2b431981d3b64e7bad4c907585e413a52"
}
```

## Proposed actions

### A_CHECK_ROUTES: Resolve the compatible prepared input panels and source contracts for the supplied empirical branches while preserving author variables, samples and filters.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_COMPUSTAT, R_CRSP, R_IBES_GUIDANCE, R_IBES_LINK, R_IBES_DETAIL, R_LITIGATION, I_DATA_ROUTES
Evidence: E_CATALOG_DIRECT, E_CATALOG_DIRECT_LINKS, E_DATASHEET_DATES, E_DATASHEET_PRODUCTS, E_PROBE_CCM_LINK, E_PROBE_COMP_FUNDA, E_PROBE_CRSP_MSENAMES, E_PROBE_CRSP_MSF, E_PROBE_CRSP_MSI, E_PROBE_IBES_DETAIL, E_PROBE_IBES_GUIDANCE, E_PROBE_IBES_LINK, E_PUBLIC_COMPUSTAT, E_PUBLIC_CRSP_FIZ_CIZ, E_PUBLIC_CRSP_PRODUCT, E_PUBLIC_IBES_ACTUALS_FIELDS, E_PUBLIC_IBES_ACTUALS_HISTORY, E_PUBLIC_IBES_GUIDANCE_FIELDS, E_PUBLIC_IBES_GUIDANCE_HISTORY

Preparation / proposed procedure:

1. For Compustat, confirm the prepared cleandat.compustat contract and a documented GVKEY-to-PERMNO link selection with effective dates; resolve the actual SIC/SICH mapping without assuming that SICH substitutes for the code-consumed SIC field.
2. For CRSP, document a time-valid build of the prepared monthly panel from MSF, MSENAMES and the required index series; confirm return/adjustment units, name-date joins, product vintage and authored sample/rolling-window history.
3. For IBES, confirm the local DET_GUIDANCE, DET_EPSUS and IBCRSPHIST candidates' exact versions, date coverage, field semantics, score/date rules and prepared aliases against the supplied Table 3 stages; use a documented authorized product route if these candidates do not match.
4. Keep Table 3's Stanford SCC input as its own requirement and resolve its academic data request and exact ticker/exchange/month-date contract through the separate access action below.

Validation to perform later:

- Before any future author-code run, record only the authorized product/file version and confirm expected columns, identifiers, units, date coverage and authored lag/lead/rolling joins for each input panel.

### A_REQUEST_SCC: Use Stanford's published academic noncommercial SCAC contact route to confirm access terms and request the documented Excel dataset under its NDA; no request or case-level query was made in this assessment.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_LITIGATION, I_DATA_ROUTES
Evidence: E_PUBLIC_STANFORD_POPULATION, E_PUBLIC_STANFORD_NDA, E_PUBLIC_STANFORD_CURRENT_STATUS, E_TABLE3_LITIGATION_READ

Preparation / proposed procedure:

1. Confirm the current academic/noncommercial request route and NDA terms with SCAC, then obtain the authorized aggregate dataset only if approved.
2. On receipt, verify the source's field definitions and date grain for ticker, exchange code, filing date and month date against the exact Table 3 join; do not infer a case-level mapping from the product page.

Validation to perform later:

- Confirm the authorized file's documented coverage includes the authored 1996–2010 analysis period and that its ticker/exchange/month-date fields match the code's join keys.

### A_VERIFY_SOFTWARE: Confirm future MATLAB/SAS runtime and required component availability. The MATLAB PATH-only observation and inherited SAS TKELS startup snapshot leave local availability unverified; neither is a license finding, and no new runtime probe is part of this correction.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_MATLAB, SW_SAS
Evidence: E_MATLAB_PATH_CHECK, E_PUBLIC_MATLAB_REGSTATS, E_PUBLIC_MATLAB_TOOLBOX, E_SAS_ENVIRONMENT, E_PUBLIC_SAS_STAT, E_PUBLIC_SAS_IML

Preparation / proposed procedure:

1. Confirm a supported MATLAB installation and the Statistics and Machine Learning Toolbox function required by regstats through an authorized software/admin inventory; do not launch author simulations during this assessment.
2. Confirm SAS 9.4 startup and SAS/STAT and SAS/IML component entitlement through the authorized software administrator; preserve the existing TKELS initialization failure and do not infer a missing license from it.

Validation to perform later:

- Before a later separately authorized run, record runtime/product availability with non-author-code software queries and confirm regstats and the SAS procedures used by this package are supported.

### A_FIG4_HANDOFFS: Propose a reviewable working-copy edit that activates the supplied Figure 4 MATLAB outputs and SAS export, then uses the same relative CSV paths under one Figure 4 working directory.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_FIG4_HANDOFF
Evidence: E_FIG4_SIM_OUTPUTS, E_FIG4_SAS_INPUT, E_FIG4_SAS_EXPORT, E_FIG4_MATLAB_READS, E_FIG4_MATLAB_PLOT_READS

**Proposed edit:** `Codes/Figure 4/Simulation_figure4_1.m:67–69`
Source SHA-256: `16c67d13feb92706f5953d65b27e069a5f91813564c53030fc0c64143ab0bfc7`

The Figure 4 SAS stage consumes x1, x2, e1 and e2 from Bootstrapping.csv, and MATLAB stages 3/4 load MTSolution.mat; the supplied producer statements already define those outputs.

Current text:
```
% save MTSolution.mat;  
% T1 = [x1 x2 e1 e2];
% writematrix(T1,'Bootstrapping.csv');
```

Proposed replacement:
```
save MTSolution.mat;
T1 = [x1 x2 e1 e2];
writematrix(T1,'Bootstrapping.csv');
```

**Proposed edit:** `Codes/Figure 4/Fig4C Bootstrapping_2.sas:2–2`
Source SHA-256: `cb65f52a4168a1ef596f1332f0d28a1fd03ec719f82ec36d7708b7558b625ae2`

Use the same working-directory-relative input file that the MATLAB producer writes, rather than a host-specific C: path.

Current text:
```
infile "[redacted-path-c1db3a688d85]" dlm=',' truncover lrecl=500 firstobs=1 dsd;
```

Proposed replacement:
```
infile "Bootstrapping.csv" dlm=',' truncover lrecl=500 firstobs=1 dsd;
```

**Proposed edit:** `Codes/Figure 4/Fig4C Bootstrapping_2.sas:49–52`
Source SHA-256: `cb65f52a4168a1ef596f1332f0d28a1fd03ec719f82ec36d7708b7558b625ae2`

The Figure 4 MATLAB consumer reads estcoef.csv; the supplied PROC EXPORT is commented and points to a host-specific C: path.

Current text:
```
/*PROC EXPORT DATA = estcoef*/
/*            OUTFILE = "[redacted-path-0f9f8297df46]" */
/*            DBMS = csv REPLACE;*/
/*RUN;*/
```

Proposed replacement:
```
PROC EXPORT DATA = estcoef
            OUTFILE = "estcoef.csv"
            DBMS = csv REPLACE;
RUN;
```

Preparation / proposed procedure:

1. Run each supplied Figure 4 stage with `Codes/Figure 4` as its working directory so MATLAB1 writes Bootstrapping.csv and MTSolution.mat, SAS2 reads the four generated columns and exports estcoef.csv, and MATLAB3/4 read those same files.
2. Keep the authors' parameters and estimators intact; apply these edits only to a reviewable working copy, without changing the simulation or bootstrap design.

Validation to perform later:

- After data/software readiness and a separately authorized run, confirm each stage creates the exact filename and consumed columns before reviewing Figure 4 plots.

### A_RECONCILE_WORKFLOW: Configure the observed SAS librefs cleandat/result and supplied macro include targets in a working copy, then preserve the explicit branch separation and Table 3 stage order. Use locally selected input/output roots; the authors’ original physical roots are not required.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_HOST_CONFIGURATION, I_WORKFLOW_CLOSURE
Evidence: E_SETUP_STRUCTURE_INSPECTION, E_TABLE3_REG_INPUT, E_TABLE3_STAGE1_OUTPUT, E_TABLE3_STAGE2_OUTPUT, E_TWOWAY_INCLUDE_TABLE3, E_WINSOR_INCLUDE_TABLE1, E_WINSOR_INCLUDE_TABLE3, E_WINSOR_INCLUDE_TABLE4

Preparation / proposed procedure:

1. In a working copy, map cleandat to the selected prepared-input library and result to a writable output library; redirect the Windows include statements to the supplied winsorize.sas and TwoWayClusteredSE.sas files. These are supported path remaps, not requests to recover the authors’ original physical roots.
2. Keep Figure 4 as MATLAB1 → SAS2 → MATLAB3/4 with the separate supported handoff edits in A_FIG4_HANDOFFS; keep Table 2 as its own MATLAB simulation and Tables 1, 3 and 4 as separate SAS branches.
3. Preserve the explicit Table 3 sequence: stage 1 result.compustat_lg → stage 2 result.IBES → stage 3 result.IBES. Keep source data identity, prepared-panel fields and software readiness in their separate requirement records.

Validation to perform later:

- Before any separately authorized run, statically confirm that each local libref resolves to the selected input or writable output root and every include resolves to the supplied macro file.
- After data contracts and software prerequisites are resolved, verify the Figure 4 files at each consumer, the named Table 3 producer-consumer datasets, and the separation of Table 1, Table 2 and Table 4 branches.


## Remaining issues and prerequisites

- I_DATA_ROUTES [unresolved; full_pipeline]: No full analytic panels are included in this code/data release: the authors describe the XLSX files as sample PERMNO/DATADATE identifiers. Readable local Compustat, CRSP and IBES source candidates exist, but product/file identity, prepared-panel construction, identifier links, coverage and required histories are not fully verified. Stanford SCC offers a documented academic NDA request route; receipt and its exact Table 3 join fields are unverified. Author download dates are provenance, not an automatic byte-vintage requirement.
- I_FIG4_HANDOFF [unresolved; full_pipeline]: Figure 4 is the sole disabled producer-consumer edge in the supplied workflow: MATLAB1 save/write statements and the SAS2 estcoef export are commented, while downstream MATLAB scripts read those files. The three source edits in A_FIG4_HANDOFFS are supported but unapplied; scope closure remains incomplete until those explicit edges are activated and later verified.
- I_HOST_CONFIGURATION [preparation; full_pipeline]: The five empirical SAS drivers declare librefs cleandat and result to quoted, host-specific roots, and their macro includes use Windows absolute paths. The supplied winsorize and TwoWayClusteredSE files are present; a credential-safe structural view confirms their interfaces and visible bodies. These roots and include paths are ordinary host configuration that can be remapped in a working copy; original physical path values and author confirmation are not prerequisites.
- I_WORKFLOW_CLOSURE [preparation; full_pipeline]: The branch topology is explicit: Table 3 stage 1 writes result.compustat_lg, stage 2 reads it and writes result.IBES, and stage 3 reads result.IBES; Table 2 is a separate MATLAB simulation and Tables 1, 3 and 4 are SAS branches. Figure 4 is the only observed disabled producer-consumer edge and is tracked separately in I_FIG4_HANDOFF. Unknown data routes and runtime availability do not create additional workflow-closure claims.
- R_COMPUSTAT [undetermined]: Compustat North America Fundamentals Annual panel required by Table 1, Table 3 and Table 4. The prepared `cleandat.compustat` input must supply PERMNO, DATADATE, annual accounting fields and the exact SIC/SICH variables used by the code. Required history follows the 2015 Table 1 joins and the 1996–2010 Table 3/Table 4 samples with authored lags/leads; exact edge observations are unverified.
- R_CRSP [undetermined]: Prepared CRSP equity panel required by Table 1, Table 3 and Table 4 with PERMNO/date, price and adjustment, return, volume, shares outstanding, ticker, share/exchange codes and the market-index return fields actually read by each branch. Required history follows the 2015 joins, Table 3 event/rolling windows and the 1996–2010 Table 4 sample; exact local coverage is unverified.
- R_IBES_GUIDANCE [undetermined]: IBES management guidance detail (`det_guidance`) required by Table 3, including ticker, periodicity, EPS measure, announcement/activation dates, period year/month and guidance values/range fields used by the code.
- R_IBES_LINK [undetermined]: IBES-to-CRSP identifier link (`ICLINK`) required by Table 3 with TICKER, PERMNO, score and effective SDATE/EDATE fields; the code filters score=1 and joins on ticker and active date.
- R_IBES_DETAIL [undetermined]: IBES U.S. detail/actual input (`det_epsus`) required by Table 3 with ticker, EPS measure, forecast period, value, USFIRM, announcement/revision dates, actual value and actual announcement dates used by the code.
- R_LITIGATION [undetermined]: Stanford Securities Class Action Clearinghouse input required by Table 3 with TICKER, exchange code, filing date and month-date fields used by the supplied CRSP join; the official academic-data route exists, but access, exact file schema and join compatibility remain unverified.
- SW_MATLAB [unverified]: Required for Figure 4 and the independent Table 2 simulation. The supplied programs call `regstats`, which MathWorks documents in Statistics and Machine Learning Toolbox. A saved PATH-only check found no MATLAB executable on PATH; MATLAB was not launched and toolbox/runtime availability is unverified.
- SW_SAS [unverified]: Required for the Figure 4 bootstrap and Table 1/Table 3/Table 4 applications. The visible code uses PROC REG, LOGISTIC, SURVEYSELECT, SURVEYREG and PROC IML through the supplied macros. The existing SAS startup record failed to initialize TKELS; compatible SAS/STAT/IML components and entitlement remain unverified, and the failure is not treated as a missing license.

## Review notes

- The datasheet download dates for Tables 1, 3 and 4 remain provenance only. No original-byte or historical-vintage identity requirement was inferred from those dates.
- The three workbooks were inspected statically: the bounded first-sheet headers are PERMNO/DATADATE identifiers; the assigned inventory records zero extracted formula/pivot program elements. Cached cell values, pivot-cache records and external links were not read or dereferenced; no workbook was opened or recalculated.
- All eight catalog-listed SAS source candidates were probed with the frozen Python one-row reader, not SAS. Readability is limited to rows_read=1; coverage_verified=false and whole-file counts/history remain unknown. COMP.FUNDA lacks PERMNO and SIC but includes GVKEY/DATADATE and SICH; the separate CCM candidate supplies GVKEY/LPERMNO/effective-date columns. CRSP fields are split across MSF, MSENAMES and MSI. IBES candidate headers fit the authored field families, but date coverage and exact prepared-file construction remain unverified.
- There are no related imported packages in this work item. The supplementary online appendix and datasheet were read; the semantic-precheck JSON was treated as discovery-only and is not outcome evidence. No author code, simulations, bootstrap, estimator, plotting, compiler, import, parser, syntax trial, dataset/model/archive download, install or applied edit was performed.
- The submitted draft contains no guessed computed outcomes; the frozen finalizer derives route and execution outcomes from the reviewed evidence. The prior finalized pair and submissions remain preserved in the pre-correction checkpoint.
- The catalog lookup wrapper failure is retained as an unused historical tool-limit artifact, not evidence of data or license absence. Direct frozen-catalog extraction and eight readable one-row records provide the local candidate evidence; coverage and histories remain unknown.
- The initial safe-display withholding is retained as capture history. The new credential-safe structural view is hash-bound to the supplied source copies: all five SAS table drivers declare cleandat/result to quoted roots; TwoWayClusteredSE declares REG2DSE(y, x, firm, time, multi, dataset, output); winsorize line 13 constructs internal token/low/high macro-variable lists. Physical path literals remain masked and are remappable.
- SAS host roots and macro include locations are supported preparation. The inherited SAS environment snapshot records the earlier TKELS startup failure; no new SAS startup, version, license or autoexec probe occurred during this correction. MATLAB was not launched, and the saved PATH-only lookup did not find matlab on PATH.
- Workflow closure is false specifically because the Figure 4 MATLAB save/write and SAS export statements are commented; the three supported edits remain unapplied. Table 3 stage 1 → stage 2 → stage 3 producer-consumer names are explicit, and Table 2, Table 1 and Table 4 remain separate branches. Data routes and software availability are assessed separately.
- All 33 frozen dependency IDs remain reviewed exactly once. D0001 is the disabled Figure 4 edge; Table 3 result datasets are explicit handoffs. D0027 represents the IML matrix G and visible code creates dataset b; winsorize &dsetin is supplied by the table-driver macro calls, not a separate raw-file dependency.
