# Independent review — W3121262606, attempt 02

## Scope and execution

This review covers the 12 frozen full-sample cash-flow regressions in Table 3 Panels A–B and Table 4 Panels A–B: CFO and FCF outcomes, total exclusions and special/other components, and 4-, 8-, and 12-quarter horizons. The implementation and specifications are in [design.md](design.md), [build.sas](build.sas), and [stata.ipynb](stata.ipynb).

The final native SAS build is `20261103T042038694282Z` and the fresh native Stata run is `20261103T042259775463Z`. SAS built and handed off 233,822 unique GVKEY/DATADATE rows. All 12 Stata cells completed; every fit used 48 calendar-quarter cross-sections, and each produced CSV, Markdown, RTF, and TeX exports. The one-quarter adjusted-R² values were calculated in memory with `asreg` on each identical fit sample and averaged equally across quarters. No intermediate coefficient file was saved. A standalone native SAS `PROC REG` audit found all 48 quarterly regressions full rank in each scope, with no rank-deficient quarters. The audit is in `runtime/postbuild_audit_20261103T042300/`.

## Source interpretation and sample repair

### I/B/E/S period dates

The 2009 I/B/E/S Detail History User Guide defines the Actuals-file Period End Date (`PENDS`) at `YYMM` precision (printed p. 22); the local WRDS SAS catalog stores that monthly field as a SAS `DATE9.` date. I therefore match by ticker and year/month, not by requiring literal day equality. The build audits the representation and within-month ambiguity: among 234,340 candidate month keys, none maps to more than one Compustat DATADATE in the month, and all 234,340 rows have an encoded PENDS day equal to the Compustat DATADATE day (minimum and maximum gap are both zero). Thus, this sample contains no observed month-end-versus-fiscal-end disagreement, but the join still follows the provider's documented precision and excludes genuinely ambiguous period mappings.

### One report per firm/calendar quarter

The paper says there is “still only one firm observation per calendar quarter” (original PDF physical p. 11, printed p. 155) in the return-test discussion. That location leaves its application to the cash-flow cross-sections uncertain. I applied it as a panel-level observation constraint: among unambiguously matched, dated reports for each GVKEY and DATADATE calendar quarter, retain the latest DATADATE before checking horizon completeness. This is deterministic and does not select on future outcomes or published estimates. The build audit found 47 duplicated firm/calendar-quarter groups and 47 excess reports among 234,271 linked firm-period rows.

A native SAS key comparison of the saved A1 and A2 samples found 233,822 shared GVKEY/DATADATE keys, 47 A1-only keys, and no A2-only keys. The latest-date rule removed exactly those 47 earlier report keys. The 12 horizon flags on all shared keys are identical. Of the removed reports, one is eligible in every one of the 12 fits; the other 46 are not eligible for any retained fit. Consequently each fitted N falls by one, and no calendar-quarter support is lost. The aggregate audit is in `runtime/a1_a2_comparison_20261103T043000/`.

The jointly eligible report pair identified in A1 is dated 1996-02-29 and 1996-03-31. A2 retains 1996-03-31 under the prespecified latest-DATADATE rule. The 4/8/12-quarter endpoint spans for that retained report are 365/730/1,095 days, compared with 306/671/1,036 days for the removed February report. The specification counts consecutive future fiscal quarters and does not impose an unsupported elapsed-day cutoff. The source sentence's scope remains a limitation; the source text does not state which of two distinct period reports in the same calendar quarter should be kept.

### Future-flow split basis

The local Xpressfeed guide defines quarterly cash-flow-per-share items using `CSHPRQ × AJEXQ` (physical pp. 48–49, printed pp. 40–41), describes the raw feed as unadjusted (physical pp. 107–108, printed pp. 99–100), and describes later split/dividend adjustment factors. The Research Insight 2004 guide defines `AJEXQ` as a cumulative factor for later splits and stock dividends (physical pp. 647, 649, printed pp. 597, 599). I use the within-Compustat relative ratio `AJEXQ_t/AJEXQ_k` to express each future per-share flow from quarter `k` on the initial quarter `t` share basis, preserving each quarter's `CSHPRQ` so non-split share-count changes remain in the flow denominator. This avoids combining per-share flows stated on different split bases; it does not use a cross-provider terminal factor and does not alter the unadjusted I/B/E/S actual EPS.

There are no missing `AJEXQ` values in the 234,271 linked current reports: 125,584 have a unit cumulative factor and 108,687 (46.39%) have a non-unit factor. Among complete future-outcome rows, the number with at least one non-unit future relative factor is:

| Outcome horizon | Rows with a future factor change | Complete outcome rows | Share of complete rows |
| --- | ---: | ---: | ---: |
| CFO, 4 quarters | 17,783 | 172,513 | 10.31% |
| CFO, 8 quarters | 28,643 | 158,108 | 18.12% |
| CFO, 12 quarters | 35,970 | 144,880 | 24.83% |
| FCF, 4 quarters | 17,160 | 166,806 | 10.29% |
| FCF, 8 quarters | 27,420 | 151,390 | 18.11% |
| FCF, 12 quarters | 34,215 | 137,543 | 24.88% |

These counts describe rows where at least one future factor differs from the initial quarter's factor; they do not treat capital issuance or repurchases reflected in `CSHPRQ` as splits. A bounded arithmetic check confirms that a future $0.50/share flow after a 2-for-1 split converts to $1.00 per initial-period share. Since the paper does not spell out the future-flow split conversion, this is a provider-supported best-effort interpretation.

### Remaining source limits

The paper explicitly requests unadjusted I/B/E/S actuals for its comparison to Compustat (original physical pp. 6–9). The local `ACTU_EPSUS` product lacks an actual-level basic/diluted flag. Its `PDF` estimate field and `STATSUM.ESTFLAG` describe estimate properties, not the actual EPS basis. The build therefore uses basic/primary proxies (`EPSPXQ` and `OPEPSQ`) and does not infer a basis from value closeness or apply an unsupported annual dilution factor. This is a material limit.

The local catalog identifies `OANCFY` and `CAPXY` as YTD cash-flow fields; the Xpressfeed documentation confirms cumulative quarter-flow treatment. These are semantic best-effort mappings to the paper-vintage items #108 and #90. The build differences YTD amounts within fiscal years, uses #15 `CSHPRQ` rather than period-end `CSHOQ`, uses Table 1's #44/#15 assets-per-share definition, and separately checks complete 4/8/12-quarter outcomes and currency continuity.

The paper reports 143,462 parent observations with sufficient Compustat, CRSP, and I/B/E/S data (physical p. 11) but says test Ns vary with horizon and required data. It does not give exact horizon-specific regression Ns. The build requires dated I/B/E/S-to-CRSP-to-Compustat links and same-currency current/future observations, but does not require a stock-return outcome for these cash-flow tests. The local matched sample is still substantially larger than the reported parent count, and this difference is not attributable to the 47-report correction or to a known source-vintage change. The precise common-sample meaning of “sufficient CRSP data” is not operationally specified for these regressions; the remaining sample gap is unresolved and is not repaired by adding arbitrary later return covariates.

## Regression results

The source focal coefficients and t-statistics below are from Table 3 Panels A–B and Table 4 Panels A–B (original physical pp. 16–17). The source does not report exact per-fit N in these tables; `A2 N (A1 → A2)` shows the local fit counts and the exact change from A1. Source t-statistics are reported as printed. A2 p-values are two-sided `xtfmb` p-values; `0.000` in the CSV exports means `<0.001`. Adjusted R-squared compares the paper's reported value to the equal-weight A2 quarterly OLS mean. Component coefficients are ordered special items / other exclusions.

| Fit | Published β (t) | A2 β (p) | Δβ | A2 N (A1 → A2) | Mean adj. R² (paper → A2) |
| --- | --- | --- | --- | ---: | --- |
| CFO total, 4q | −1.120 (−10.37) | −1.254 (<.001) | −0.134 | 172,513 (172,514 → 172,513) | .366 → .365 |
| CFO total, 8q | −2.210 (−8.43) | −2.452 (<.001) | −0.242 | 158,108 (158,109 → 158,108) | .380 → .375 |
| CFO total, 12q | −3.328 (−6.42) | −3.577 (<.001) | −0.249 | 144,880 (144,881 → 144,880) | .351 → .361 |
| CFO components, 4q | 0.199 (0.86) / −2.185 (−25.34) | 0.158 (.262) / −2.337 (<.001) | −0.041 / −0.152 | 164,076 (164,077 → 164,076) | .374 → .386 |
| CFO components, 8q | 0.309 (0.63) / −4.263 (−22.49) | 0.374 (.231) / −4.541 (<.001) | +0.065 / −0.278 | 151,483 (151,484 → 151,483) | .387 → .398 |
| CFO components, 12q | 0.781 (0.84) / −6.422 (−13.56) | 0.538 (.300) / −6.600 (<.001) | −0.243 / −0.178 | 140,138 (140,139 → 140,138) | .358 → .381 |
| FCF total, 4q | −0.665 (−7.38) | −0.955 (<.001) | −0.290 | 166,806 (166,807 → 166,806) | .247 → .269 |
| FCF total, 8q | −1.255 (−4.88) | −1.768 (<.001) | −0.513 | 151,390 (151,391 → 151,390) | .254 → .274 |
| FCF total, 12q | −1.660 (−3.38) | −2.502 (<.001) | −0.842 | 137,543 (137,544 → 137,543) | .231 → .271 |
| FCF components, 4q | 0.746 (2.95) / −1.829 (−13.27) | 0.597 (<.001) / −2.079 (<.001) | −0.149 / −0.250 | 158,782 (158,783 → 158,782) | .257 → .290 |
| FCF components, 8q | 1.364 (3.08) / −3.431 (−14.34) | 1.358 (<.001) / −3.860 (<.001) | −0.006 / −0.429 | 145,192 (145,193 → 145,192) | .262 → .297 |
| FCF components, 12q | 2.603 (3.33) / −4.943 (−9.93) | 2.111 (<.001) / −5.548 (<.001) | −0.492 / −0.605 | 133,147 (133,148 → 133,147) | .241 → .293 |

The main signs and inference patterns are reproduced: total-exclusion slopes are negative and significant in all horizons; the CFO special-item coefficient remains insignificant while CFO other exclusions are negative and significant; both FCF component coefficients remain significant with the source signs. CFO total-exclusion estimates are modestly more negative than the published values, while FCF total-exclusion slopes are materially more negative. A2 adjusted R-squared is close for CFO-total fits, moderately higher for CFO-components, and higher for both FCF specifications. These differences are not attributable to the one-row-per-fit sample correction; the A1/A2 comparison changes no other row eligibility. The basic/primary EPS proxy, broader matched population, best-effort cash-flow mapping, and split-basis implementation remain possible contributors, but the available evidence does not isolate their effects.

Inference follows native `xtfmb` with Newey–West lags 3, 7, and 11. The paper's printed footnote 9 variance expression omits the conventional factor of 2; `xtfmb` uses the standard formula. I report only individual coefficient inference and do not interpret package-wide joint tests.

## Table 1 actual-sample descriptives

The paper's Table 1 reports per-share amounts. The A2 means below are in those same unscaled units, after pooled 1st/99th-percentile winsorization on the matched sample; the regressions winsorize after initial assets-per-share scaling. Pooling/order is not stated in the paper. Local N reflects each variable's available values and can differ by row.

| Variable | Paper mean / SD / median | A2 N | A2 mean / SD / median |
| --- | --- | ---: | --- |
| Pro forma EPS | 0.29 / 0.44 / 0.25 | 233,822 | 0.223 / 0.444 / 0.190 |
| Operating EPS | 0.29 / 0.45 / 0.24 | 210,867 | 0.225 / 0.450 / 0.180 |
| GAAP EPS | 0.26 / 0.52 / 0.23 | 227,492 | 0.194 / 0.524 / 0.170 |
| Total exclusions | 0.03 / 0.23 / 0.00 | 227,492 | 0.025 / 0.223 / 0.000 |
| Special items | 0.03 / 0.15 / 0.00 | 210,866 | 0.025 / 0.139 / 0.000 |
| Other exclusions | 0.00 / 0.14 / 0.00 | 210,866 | −0.001 / 0.147 / 0.000 |
| Sales growth per share | 0.66 / 1.59 / 0.39 | 222,462 | 0.510 / 1.510 / 0.269 |
| Accruals per share | −0.28 / 1.11 / −0.12 | 187,410 | −0.252 / 1.058 / −0.101 |
| Assets per share | 50.06 / 105.99 / 17.98 | 225,367 | 42.315 / 76.557 / 15.571 |
| CFO sum, 4q | 2.11 / 3.22 / 1.38 | 176,999 | 1.702 / 2.949 / 0.997 |
| CFO sum, 8q | 4.55 / 6.31 / 3.02 | 162,208 | 3.670 / 5.766 / 2.151 |
| CFO sum, 12q | 7.45 / 9.74 / 4.99 | 148,671 | 5.932 / 8.823 / 3.520 |
| FCF sum, 4q | 0.37 / 2.84 / 0.23 | 171,120 | 0.283 / 2.558 / 0.112 |
| FCF sum, 8q | 0.93 / 5.32 / 0.53 | 155,310 | 0.723 / 4.675 / 0.274 |
| FCF sum, 12q | 1.73 / 7.86 / 0.92 | 141,131 | 1.355 / 6.793 / 0.506 |

Exclusion means and medians are close to Table 1. Local current EPS and future CFO/FCF means and medians are generally lower. This pattern is consistent with the actual-basis and population differences but cannot identify which assumption drives it. These descriptives do not serve as a model-selection or coefficient-tuning target.

## Audit paths

- Final build, handoff, and submission snapshot: `runtime/20261103T042038694282Z/`.
- Final Stata cell logs and generated output checksums: `runtime/20261103T042259775463Z/` and `runtime/latest.json`.
- All-scope native SAS quarterly rank/df and per-share descriptive audit: `runtime/postbuild_audit_20261103T042300/`.
- A1/A2 row-key and horizon-eligibility comparison: `runtime/a1_a2_comparison_20261103T043000/`.
- Source documentation reviewed: `output/reproduction_runs/reference_documents/ibes_detail_history_user_guide_2009.pdf`, `compustat_xpressfeed_2011.pdf`, and `compustat_research_insight_2004.pdf`; original paper physical pp. 6–17 and 28 (printed pp. 150–161 and 172).
