# Independent review: Kothari et al. discretionary-accrual measures

## Review result

I reviewed attempt 01 and repaired two source-audit defects in attempt 02 before accepting its outputs for review. The native SAS build, handoff, and Stata table cell now complete successfully. The source-date horizon and CRSP market-equity routes are auditable, and the six grouped fits pass the independent rank checks. The paper's Table 1 sample size and descriptive moments are not reproduced exactly; the resulting differences are reported below without tuning the sample to the published values.

## Source and implementation checks

The paper defines total accruals from changes in current assets excluding cash, changes in current liabilities excluding current debt, and depreciation, scaled by lagged assets; equations (6) and (7) specify the Jones, modified-Jones, and ROA-augmented fits. It describes annual two-digit-SIC cross-sections, an ordinary intercept, and a minimum of ten observations per industry-year (PDF physical pp. 10–12). Table 1 reports total accruals, six model residuals, and four performance-matched measures and requires sufficient model data, `|TA| <= 1`, matching, and complete stratification data; it reports 122,798 observations and winsorization at the first and 99th percentiles (PDF physical p. 14). The paper does not identify the OLS command, all characteristic field/timing choices, or replacement and tie rules for matching; these remain best-effort implementation choices.

The inherited CRSP monthly pull ended on 31 December 1999 despite 1,292 fiscal-year 1999 support rows with actual DATADATEs from 31 January through 31 May 2000. The build now derives its CRSP and exact-date CO_INDUSTRY cutoff from the maximum selected DATADATE, which is 31 May 2000. The build listing confirms all 1,292 late-dated rows remain in the USD/SIC support file. For those rows, 275 have direct CRSP PERMCO market equity (quote-age median 0 days, maximum 2), 40 use the unique-link Compustat fallback, 790 use the inferred no-link Compustat fallback, and 187 have no MVE.

The inherited market-equity audit treated absent/nonpositive PRC or SHROUT as a contradictory price/share record. I separated incomplete monthly inputs from observed conflicts. Conflicts now mean competing security/company identity or multiple distinct price/share values; missing or nonpositive inputs make the aggregate incomplete but permit the guarded Compustat fallback when no observed link or CRSP conflict exists. The SAS listing reports security/month price and share missingness, value conflicts, effective-name coverage, PERMCO conflicts, company/month completeness, and multi-class coverage. No observed price/share conflict is present in the USD/SIC support rows in this run; the 1999 support audit counts 11 incomplete linked monthly quotes and zero CRSP conflicts. The final common sample uses 34,781 direct CRSP rows, 466 unique-link Compustat fallbacks, and 89,104 no-link Compustat fallbacks. The Compustat fallback is limited to positive `PRCC_F × CSHO` when `FIC=USA` and `CURCD=USD`, but the price currency is inferred rather than proved by those fields.

CRSP `PRC` is taken as the absolute last available monthly close and `SHROUT` is thousands of shares, converted to $ millions; all common PERMNOs linked to the PERMCO are included. In the source-wide CRSP audit, direct quotes draw on both one- and multi-class companies (1–6 common securities); the MVE source routes retain CCM priority and common-share counts. Across fiscal years, direct-route quote ages have a median between 0 and 2 days; the maximum observed is 33 days, still within the permitted same or immediately preceding calendar month. For the late FY1999 support rows specifically, all 275 direct quotes have median age 0 and maximum age 2.

Operating cash flow uses OANCF where present and otherwise `NI − TA_raw`, divided by AT. The local source has no OANCF before 1987; the final common sample uses the NI-minus-accrual proxy for 62,304 rows and OANCF for 62,047. The paper's discussion that earnings equal cash flow plus accruals supports this as a historical approximation (PDF physical p. 23), not a verified copy of the authors' exact cash-flow mnemonic.

Each of the six model-specific `asreg` fits uses complete cases and its own minimum-10 count. All 1,808 qualifying SIC/year groups have native Stata `e(rank)` equal to the expected rank (4 parameters for equation 6; 5 for equation 7). Groupwise coefficient availability is checked with any-row and all-row indicators, avoiding the former first-observation tag issue; every group has at least one coefficient-complete row. Three full-rank groups per model compare `asreg` residuals to native OLS residuals, with maximum absolute differences below `1e-15`. The `.log` also records each model's rank distribution and matched residual counts.

For performance matching, the code uses the nearest current or prior-year ROA among same-SIC/year firms with a model-specific equation (6) residual. The focal row is excluded; controls may be reused. ROA/GVKEY ordering resolves equal-distance ties deterministically, choosing the preceding sorted candidate. Matching occurs before the target firm's `|TA| <= 1` and stratification screens. The final joint sample applies the common support to all 11 Table 1 measures, then winsorizes those reported measures at pooled 1st/99th percentiles and scales them by 100.

## Sample flow and published comparison

The build hands off 188,911 firm-years. Stata retains 144,975 with all six residuals; 143,400 also pass `|TA| <= 1`; 124,373 have complete values for all five stratification characteristics; 143,371 have all four performance-matched measures after the TA screen; and 124,351 satisfy the common Table 1 sample. The reproduced N is 1,553 (1.26%) above the paper's 122,798. The paper describes its final size as roughly 123,000 and does not provide its row-level sample or exact missing-data field/timing choices. We do not attribute the gap to a single source or force the count to match.

The following values are percent of assets. Each sequence is mean / SD / 25th percentile / median / 75th percentile; the left column is Table 1 Panel A (PDF physical p. 14), and the right is the current common-sample output in `tables/table1_panel_a.csv`.

| Table 1 measure | Published, N = 122,798 | Reproduced, N = 124,351 |
|---|---:|---:|
| Total accruals | −3.03 / 11.62 / −8.40 / −3.46 / 1.87 | −2.48 / 13.58 / −8.54 / −3.28 / 2.61 |
| Jones model | −0.19 / 9.98 / −4.62 / 0.03 / 4.39 | 0.03 / 14.65 / −5.68 / −0.08 / 5.29 |
| Modified-Jones model | −0.29 / 10.33 / −4.86 / −0.08 / 4.37 | −0.11 / 14.91 / −6.10 / −0.26 / 5.35 |
| Jones, prior-year ROA | −0.03 / 9.62 / −4.38 / 0.07 / 4.37 | 0.00 / 14.58 / −5.61 / −0.10 / 5.26 |
| Jones, current-year ROA | 0.00 / 10.65 / −4.79 / −0.04 / 4.51 | −0.07 / 13.95 / −5.73 / −0.29 / 4.97 |
| Modified Jones, prior-year ROA | −0.04 / 9.94 / −4.55 / 0.00 / 4.42 | −0.07 / 14.82 / −6.04 / −0.27 / 5.30 |
| Modified Jones, current-year ROA | −0.03 / 10.98 / −5.01 / −0.15 / 4.52 | −0.25 / 14.31 / −6.20 / −0.49 / 4.95 |
| Performance-matched Jones, prior-year ROA | 0.08 / 14.38 / −6.88 / 0.04 / 7.07 | −0.18 / 20.79 / −8.39 / −0.06 / 8.22 |
| Performance-matched Jones, current-year ROA | −0.02 / 15.50 / −7.29 / 0.00 / 7.28 | −0.24 / 20.81 / −8.40 / −0.05 / 8.23 |
| Performance-matched Modified Jones, prior-year ROA | 0.09 / 14.83 / −7.03 / 0.04 / 7.26 | −0.19 / 21.68 / −8.71 / −0.06 / 8.55 |
| Performance-matched Modified Jones, current-year ROA | −0.02 / 15.93 / −7.45 / 0.00 / 7.43 | −0.27 / 21.69 / −8.71 / −0.03 / 8.54 |

All 11 replicated rows have the same N because the output uses one common sample. The replicated SDs and many quartiles differ materially from the published table, particularly for the raw DA and performance-matched rows. These are descriptive discrepancies, not hypothesis-test results: the paper reports no p-values or standard errors for these Table 1 distributions.

## Native run evidence

- Runner: `python scripts/reproduction_runs.py run --attempt reproductions/W3124170598/attempt_02 --stage all`.
- Runtime: `runtime/20261103T002351404434Z/`; SAS, handoff, and Stata return codes are all zero; `runtime/latest.json` reports the table cell successful.
- `build.lst` and `build.log` record actual source cutoffs, source-route audits, dates, and annual counts; `cell_table1_panel_a.log` records fit ranks, residual comparisons, match counts, sample flow, and final source composition.
- `sync` and `validate` pass: 6 scopes, zero blocked scopes, no validation errors or warnings.


## Coordinator price-currency audit

A later bounded read-only audit checks all 118,964 Compustat-fallback rows in the delivered support population (not just the 124,351-row final Table 1 sample). It reproduces each stored `PRCC_F × CSHO` value and matches exact historical `HIID`/`DATADATE` to `COMP.SEC_MTHPRC`, without a primary-marker availability gate. There are 117,368 unique monthly price matches, all quoted in USD; 117,362 agree with annual `PRCC_F` within 0.005. Thus those 117,362 support rows have direct dated price-currency corroboration. The remaining 1,596 have no exact monthly quote, and six have annual/monthly price differences above the stated diagnostic tolerance; their assumed annual price currency remains unverified. One support row lacks HIID. No matched quote supports a non-USD price. These are support-population counts, not final-sample counts, and the price tolerance is a comparison rule rather than proof of stored precision. The audit leaves construction and estimates unchanged. Reproducible script and aggregates: `output/reproduction_runs/preflight/kothari_price_currency_audit.{py,json}` from the git root.
