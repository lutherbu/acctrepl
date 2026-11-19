# Patch proposal: jar-fc2b281c185c

Asymmetric Cost Behavior and Dividend Policy

DOI: 10.1111/1475-679X.12328

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Supplied mixed Stata/SAS workflow that prepares annual Compustat variables, estimates quarterly cost stickiness and runs baseline Table 3 with two reghdfe specifications, then writes the final firm identifier list.

Entry points: `Codes for JAR.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 4/12328 - Asymmetric-Cost-Behavior-and-Dividend-Policy/htyz-datasheet-and-code.zip",
      "sha256": "7a1497ed2d2eaa9954437986cfe672b96b665ae21755253bc6a6a32b335812db"
    },
    {
      "path": "JAR-Volume 58/Issue 4/12328 - Asymmetric-Cost-Behavior-and-Dividend-Policy/htyz-online-appendix.pdf",
      "sha256": "76cd4b25da10b3bddb9c9052e0ea31cd12027d5c43b14608dba279e418a609da"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "25cb037ed990627ae0937a86996bb1cdb9061bee96e64fb83daf60c376fabc54"
}
```

## Proposed actions

### A_DATA_ROUTE: Use the readable local COMP.FUNDA and COMP.FUNDQ candidates as starting routes, then verify the source field mapping and complete history needed by the supplied workflow. Record the actual product vintage for later output-comparison context; do not require matching the datasheet-reported 2017/2020 downloads.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_ANNUAL, R_QUARTERLY, I_HISTORY
Evidence: E_DOC_COMP, E_COMP_CATALOG, E_FUNDA_PROBE, E_FUNDQ_PROBE, E_APP_WINDOW, E_ASREG_DOC, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Assign SAS input libraries to the existing ${ACCTREPL_SAS_ROOT}/comp/d_na product paths and keep generated datasets in a writable task execution library; do not add a separate entitlement or author-approval gate for the already-readable local candidates.
2. Confirm COMP.FUNDA and COMP.FUNDQ coverage for the actual annual and quarterly construction history; one-row samples and catalog observation counts do not establish full history. The May 2017/April 2020 datasheet dates are context only: any current product that satisfies the source fields and history may be used, without matching those snapshots.
3. Stage the same compatible annual product under the Stata input name compa_all.dta and as a SAS COMP.COMPA_ALL input alias. Preserve the supplied field names/case, gvkey as a 7-character string including leading zeros, numeric daily datadate, numeric fyear, missing values and every source field required by the code. Resolve sic/state separately through A_FIELD_MAPPING before treating the annual route as compatible.
4. Stage COMP.FUNDQ as the SAS WORK.COMPQ input expected by the supplied join, preserving the supplied field names/case, gvkey as a 7-character string including leading zeros, numeric daily datadate, character datacqtr/datafqtr, numeric fiscal-quarter fields, missing values and all selected quarterly fields.
5. Retain the exact author filters and construction windows: USD and industry exclusions, final fyear 1978–2016, t+1 DPS, annual ROA lags, the 16-year persistence window, 60-row next-observation SICH fill, and quarterly order_q_dist 0–20/0–15 stages.

Validation to perform later:

- Before a separately authorized full run, verify complete annual/quarterly date and firm coverage against the windows in expected_period and all required source columns/types. Record the available product version/download context for later output comparisons; do not make a 2017/2020 snapshot match a run prerequisite.
- Use explicit column types/formats when staging annual or quarterly CSV inputs; do not rely on automatic type guessing. Preserve exact source names/case, gvkey string width and leading zeros, missing values, numeric date/quarter units and each field’s display format. Compare schema, key/date values and bounded row/key summaries across the staged inputs.

### A_FIELD_MAPPING: Resolve the actual author-specified source/mapping for sic and state in the annual Compustat export before preparing compa_all.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_ANNUAL_FIELDS
Evidence: E_SRC_ANNUAL_READ, E_SRC_ANNUAL_FIELDS, E_COMP_CATALOG, E_FUNDA_PROBE, E_COMPANY_PROBE

Preparation / proposed procedure:

1. Retain both fields required by the supplied Stata keep/read statements. The local annual fundamentals candidate lacks them; the local company table has gvkey/sic/state but no year/date key, and the author code does not specify joining it.
2. Use an author-prepared annual export or its documented input mapping if available. If the company table is the intended source, establish its intended join and current-versus-historical meaning before using its sic as the missing-sich fallback; do not infer a time-series join from a current company record.

Validation to perform later:

- Check the resulting annual input contains sic and state with documented meanings, types and matching rules before any Table 3 run.

### A_ORDERED_DRIVER: Split the supplied mixed-language source in a working copy into the documented Stata/SAS stages. Run both host wrappers from one job execution directory and use explicit typed CSV bridges that preserve the variables’ original units and formats.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_FORMAT_HANDOFFS
Evidence: E_SRC_ANNUAL_READ, E_SRC_ANNUAL_FIELDS, E_SRC_SAS_STEP1, E_SRC_STATA_Q_KEYS, E_SRC_STATA_Q_LAGS, E_SRC_SAS_REG, E_SRC_FINAL_MERGE, E_SRC_FINAL_MODELS, E_SRC_IDENTIFIER_OUTPUT, E_SAS_CSV_DOC, E_STATA_CSV_DOC, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Create/use one writable job execution directory under output/reproductions, for example output/reproductions/jar-fc2b281c185c, and launch both Stata and SAS batch wrappers with that same directory as their current working directory. Keep Stata outputs, DTA files and CSV bridges relative to it; configure SAS WORK separately (recommended [redacted-path-d256559989d4]) and point COMP/RAW read-only libraries at the approved [redacted-path-5426644c0bed] paths. Do not embed absolute Dropbox workspace paths. Verify host input visibility and output writability before a separately authorized run.
2. Run Stata annual preparation (Codes for JAR.do lines 9–135): compa_all.dta -> compa_sich.dta -> compa_from_Huan_final_JAR.dta. Preserve the complete pre-filter SIC fill and authored annual variable construction. Stage/import with explicit types: gvkey is a 7-character string including leading zeros, datadate is a numeric daily date count, fyear is numeric, and names, case and missing values follow the supplied schema.
3. Run SAS Step 1 (lines 142–161): COMP.COMPA_ALL + WORK.COMPQ -> WORK.COMPA_Q. Export WORK.COMPA_Q to relative compa_q.csv with Base SAS PROC EXPORT; import it in Stata with an explicit column schema and save compa_q.dta before line 165. Preserve exact source names/case, gvkey as character width 7 with leading zeros, missing values, and daily datadate/datadateq as unchanged numeric day counts; datacqtr/datafqtr remain character strings.
4. Run Stata Step 2 (lines 165–195): compa_q.dta -> compa_q1.dta. Preserve the author’s quarterly date fallback, duplicate handling and hardcoded gvkey_datadate==392684/fyr==12 rule. datadate_qdate is a numeric quarter index created by quarterly()/qofd(), not a daily date; retain its quarter unit and Stata %tq format. Export compa_q1.dta to relative compa_q1.csv with explicit column types; import it into SAS as WORK.COMPA_Q1 without changing names/case, GVKEY width/leading zeros, values or missingness.
5. Run SAS Step 3 (lines 199–221): WORK.COMPA_Q1 -> WORK.B_DEC_16. After the supported line-207 spelling repair, export gvkey, datadate, b, b_dec and n to relative b_dec_16.csv using explicit types; keep gvkey character width 7, datadate as a numeric daily day count, and b/b_dec/n numeric. Import/save as Stata b_dec_16.dta before line 228. These identically named SAS and Stata objects are distinct datasets/formats.
6. Run the final Stata block (lines 226–256): merge compa_from_Huan_final_JAR.dta with b_dec_16.dta on gvkey/datadate, retain both reghdfe specifications and the authored sample, then save identifier_gvkey.dta. Capture the two model outputs in the Stata batch log because no table-file export command is supplied.

Validation to perform later:

- At each handoff, verify the named producer’s schema against the exact consumer: compa_q fields used by Stata Step 2; compa_q1 fields used by SAS PROC REG; b_dec_16 keys and b/b_dec/n fields used by the final Stata merge. Keep exact variable names and case, and verify bounded row/key counts.
- Define CSV import types/formats explicitly on both sides; do not rely on automatic type guessing. Keep gvkey character width 7 and preserve leading zeros; preserve native missing values (including distinct SAS missing codes if present); retain datadate and datadateq as numeric day counts on the shared 1960 epoch and restore their matching SAS/Stata daily display formats. Keep datacqtr/datafqtr character. Keep Stata datadate_qdate as its numeric quarter index with %tq on the Stata side; never convert it to days. Preserve every other variable’s existing type/unit and reapply its matching display format after each bridge.

### A_SAS_SORT_FIX: Correct the misspelled SAS BY-sort direction in a working copy so PROC SORT can apply the intended descending order to order_q_dist.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_SAS_SORT
Evidence: E_SRC_SAS_SORT, E_SAS_SORT_DOC, E_SRC_STATA_Q_LAGS

**Proposed edit:** `Codes for JAR.do:207–207`
Source SHA-256: `5f7770f48f60d5afcd89aef4682d2b000fbf1ad508112aa13560727134a95a30`

SAS PROC SORT documents DESCENDING as the BY-key modifier; the source’s preceding constructed compa_q1 schema contains no desending variable. Correct only the spelling, retaining the specified sort variables and order.

Current text:
```
by gvkey datadate desending order_q_dist;
```

Proposed replacement:
```
by gvkey datadate descending order_q_dist;
```

Preparation / proposed procedure:

1. Apply this one-line correction only in the staged working copy used for the future SAS Step 3.

Validation to perform later:

- In a separately authorized SAS run, confirm PROC SORT accepts the corrected BY statement on the generated compa_q1_16 dataset and preserves the intended order_q_dist ordering.

### A_SOFTWARE_SETUP: Configure the verified Stata add-ons and recheck the SAS runtime/component state before a separately authorized run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_ASREG, SW_SAS, SW_SASSTAT, I_SAS_RUNTIME
Evidence: E_ENV, E_WINSOR, E_SRC_ANNUAL_HISTORY, E_SRC_FINAL_MODELS, E_SRC_SAS_REG, E_SAS_STAT_DOC

Preparation / proposed procedure:

1. Launch Stata from the same job execution directory used by the data stages: output/reproductions/jar-fc2b281c185c. Add the existing reproductions ado directory with adopath ++ "../ado" from that current directory, or stage the already-available asreg ado in that job-relative ../ado directory; no new install is needed. The exact winsor, reghdfe and ftools commands were already found in Stata 18.
2. Use the documented host SAS batch wrapper settings (-nodms, -work [redacted-path-d256559989d4], -autoexec operator SAS autoexec) for any future runtime check. The supplied environment probe failed at TKELS initialization; establish successful SAS startup and PROC REG/SAS/STAT availability before an authorized full run. Do not infer a missing license from the startup error.

Validation to perform later:

- From the shared job execution directory, confirm Stata reports version 18 and finds asreg after the relative ../ado setup, and that winsor, reghdfe and ftools resolve in that environment.
- After SAS initialization succeeds, confirm the required DATA steps, PROC SQL, PROC SORT, PROC REG and SAS/STAT component are available; retain the exact SAS version and initialization log.


## Remaining issues and prerequisites

- I_ANNUAL_FIELDS [unresolved; full_pipeline]: The author code requires sic as a fallback when sich is missing and keeps state in its annual import. The local readable COMP.FUNDA table lacks both fields. COMP.COMPANY has gvkey/sic/state columns but is a current company dimension without datadate/fyear, and no join or temporal field-mapping rule is supplied. Do not remove source fields or silently assume the company-table join.
- I_HISTORY [unresolved; full_pipeline]: The bounded probes verify candidate readability and columns, not complete annual/quarterly coverage. The target’s annual construction needs a t+1 DPS lead, ROAVol lags and prior assets, a 16-year asreg rolling window on CoreEarn/lag_earn, and the pre-filter 60-row future SICH fill; quarterly construction joins through 20 quarters earlier and uses lagged quarterly fields for a 16-quarter regression window. Full history and per-firm coverage remain unresolved. The datasheet reports May 2017 and April 2020 downloads as provenance context, but current compatible products may be used and matching those pulls is not a prerequisite.
- I_FORMAT_HANDOFFS [preparation; full_pipeline]: The single .do file interleaves Stata and SAS. SAS WORK.COMPA_Q must be exported/imported as compa_q.dta before Stata Step 2; Stata compa_q1.dta must be imported as SAS WORK.COMPA_Q1; SAS WORK.B_DEC_16 must be exported/imported as b_dec_16.dta before the final Stata merge. The source contains no directory/library setup or bridge commands. These are known workflow-preparation steps; the result table itself is not explicitly written to a table file, so capture both regressions in the batch log.
- I_SAS_SORT [preparation; full_pipeline]: SAS PROC SORT line 207 uses `desending`, which is not the documented DESCENDING keyword. The preceding SAS/Stata stage creates compa_q1 from the listed fields and does not create a desending variable. Correct this spelling in the working copy to preserve the intended order_q_dist sort.
- I_SAS_RUNTIME [unresolved; full_pipeline]: The provided SAS startup probe fails with a TKELS initialization error, so Base SAS and SAS/STAT PROC REG capability could not be verified in this environment. This is an unresolved initialization/runtime state, not evidence of a missing license.
- R_ANNUAL [undetermined]: Compustat annual input used both as compa_all.dta in Stata and COMP.COMPA_ALL in SAS. Actual source fields include gvkey/datadate/sich/sic plus fyear, at, mkvalt, csho, prcc_f, xrd, dvc, oibdp, ppegt, ppent, dltt, dlc, capx, txdb, ceq, pstkrv, prstkc, ib, dp, seq, dvp, che, invt, emp, aqc, aqs, rect, sale, state, ibcom, xint, txt, act, lct, idit, dvpsx_f, ajex, spi and curcd. The readable COMP.FUNDA candidate covers the financial/fiscal fields and sich but not sic/state; author export mapping and annual-history coverage remain unresolved. The datasheet-reported download dates are provenance context only; a compatible current product can be used.
- R_QUARTERLY [undetermined]: Compustat quarterly input read as compq in SAS WORK. It must include gvkey, datadate, fyearq, fqtr, fyr, datacqtr, datafqtr, saleq, xsgaq, atq, cogsq, oiadpq and xrdq. The readable COMP.FUNDQ candidate has these fields, but complete history and per-firm quarter coverage remain unverified. The datasheet-reported download dates are provenance context only; a compatible current product can be used.
- SW_ASREG [preparation_required]: The actual invoked rolling-regression command is available only after Stata adds the existing project reproductions ado directory; it is not found on the default adopath. From the shared job execution directory output/reproductions/jar-fc2b281c185c, configure the relative path ../ado before the annual Stata stage.
- SW_SAS [unverified]: The supplied SAS stages use DATA steps, PROC SQL, PROC SORT and PROC REG. The environment startup probe failed while initializing TKELS; runtime availability and version therefore remain unverified, with no license conclusion.
- SW_SASSTAT [unverified]: The supplied PROC REG stage requires SAS/STAT capability; the local SAS startup failure prevents verification of the component.

## Review notes

- The entire supplied 256-line source was read. Despite its .do extension and a static language inventory that lists only Stata, the source interleaves Stata and SAS preparation, regression and merge stages; it is substantive code, not a no-code release.
- The two package-specific semantic_prechecks files were used as discovery leads only. Independent counting of cached source lines 12–71 confirms 60 repeated SICH-fill passes, not 70.
- The only assessed target is the supplied baseline Table 3 workflow. The datasheet also mentions union election sources, but this supplied code does not read them; no union-data requirement is added. The appendix reports Tables A1–A7 without a corresponding supplied code branch.
- The packaged identifier_gvkey.dta and streamed identifier_gvkey.txt contain firm keys only, as the datasheet says; they are final outputs/lookup data, not a prepared analysis panel or an analysis-only route.
- The two regression results are not written to a table file in the supplied program; the future host batch run should capture the Stata log for review. The source’s hardcoded duplicate-resolution rule is preserved without firm/year substitution.
- A readable local Compustat candidate is treated as an available route candidate without a separate current-entitlement/author-approval prerequisite. Its unresolved annual fields and full history remain explicit. The datasheet-reported May 2017 and April 2020 downloads are provenance context for later output comparisons, not required source matches; compatible current products can be used.
