# Independent review — W3124908438, attempt 02

## Scope and source checks

I reviewed the assigned Table 5 full Equation (4), Table 6 Model 3, and Table 8 Model 3 against the original paper and local source catalog. The source locations are PDF p. 10 / journal p. 832 n. 23 for the future-return interval and delisting treatment; PDF p. 11 / journal p. 833 for the event window and month-before/after forecast language; PDF p. 12 / journal p. 834 for the first post-announcement and last pre-announcement medians; PDF p. 13 / journal p. 835 for sample statements; and PDF pp. 22, 23, and 26 / journal pp. 844, 845, and 848 for the three assigned tables. The paper reports 38,716 observations and 19 annual Fama–MacBeth regressions. Its general method section (PDF p. 7 / journal p. 829) calls for Newey–West adjustment but does not report a lag order.

The inherited build's main timing defects were corrected in A2. The first A2 runner attempt failed on an unused diagnostic write to a nonexistent `.work/audit` library; that run is preserved. Removing only the unused write allowed the build and all analysis cells to complete. The final build and sample declarations were not changed after the successful native run.

## Demonstrated repairs and temporal checks

1. **Future-return availability window.** The paper says that future returns start four months after fiscal year-end and ties the delay to filing availability, but gives no calendar example. A1 used `INTNX(month,DATADATE,4,'b')`, which starts April 1 for a December 31 year-end. A2 treats four months as four complete calendar months elapsed, an operational interpretation: December 31 maps to May 1–April 30. The bounded date smoke test covers this and other month ends. The source supports the four-month delay; the precise day is not uniquely specified.

   The change affects the actual common keys as follows: A1 final had 25,904 keys and A2 has 25,469; 25,467 keys are common, 437 are A1-only, and 2 are A2-only. Of the A1-only keys, 424 fail A2's adjacent-month forecast rule and 13 lose complete CRSP coverage under the corrected future-return interval. The two restored keys had missing future-return coverage under A1's earlier interval. Thus the net count falls by 435, but that net masks both the 424 forecast-window removals, the 13 new return-coverage losses, and the 2 restored keys. `RT` and `UR` are unchanged on the 25,467 common keys; `RFUT` changes on all 25,467 because its dates changed. Updated annual winsorization cutoffs change values on common keys for EARN 287, ΔEARN 178, RNOA 192, ΔRNOA 207, PM 248, ATO 150, ΔPM 236, ΔATO 180, future RNOA 192, future PM 186, future ATO 218, SUR 379, and ANREV 468.

   The final future-window start dates range from 01NOV1984 to 01OCT2003, with end dates from 31OCT1985 to 30SEP2004. All final observations have complete stock and market return coverage; the completed windows contain 246–255 market sessions. The source's delisting footnote is implemented with CRSP delisting returns and the specified −35% / −55% imputations for eligible missing DLRET codes. After delisting, proceeds are reinvested in the market return for the remainder of the future interval. The same adjustment is carried into contemporaneous/event returns as a best effort; the paper's explicit delisting detail is for the future window. The number of imputed DLRET rows is not separately logged.

2. **Next-year analyst forecast window.** A1 could choose a nearest year-(t+1) summary many months from the announcement. A2 first aligns `FPEDATS` exactly to the Compustat next fiscal-year end, then selects the nearest strictly pre/post `STATPERS` within the same or adjacent calendar month as `ANNDATS`. This is an operational implementation of PDF p. 11's “month immediately before/after” wording and PDF p. 12's first-median-after / last-median-before definition; the paper does not uniquely define a calendar-day cutoff.

   A2 pre-announcement forecast ages are 1–46 days (median 14, p90 28, p95 33, p99 35); 11,705 selected records are in the same calendar month and 13,764 in the adjacent month. Post-announcement ages are 1–49 days (median 16, p90 28, p95 29, p99 35); 12,432 are in the same month and 13,037 in the adjacent month. No selected year-(t+1) forecast exceeds the declared boundary.

   Current-year SUR uses the exact year-t `FPEDATS` and the latest median with `STATPERS < ANNDATS`, as the paper's “most recent” wording implies. It is strictly pre-announcement, but there is no source-specified maximum age, so I did not add one. On the final keys its forecast age is 1–690 days (median 15, p90 28, p95 33, p99 35); 85 are beyond one adjacent calendar-month boundary and 1,790 are more than 31 days old. This is a documented timing limit rather than an additional screen.

3. **Per-share denominators and issue-price currency.** I checked the predecessor corrections for EARN/ΔEARN/SUR/ANREV using prior-year `PRCC_F`; current EPS on the prior price share basis using `(EPSPX_t/AJEX_t)×AJEX_(t−1)`; and unadjusted I/B/E/S values converted by anchor-date/source-date `CFACSHR`. The unequal-price, non-unit-factor smoke test reaches the final SAS handoff. All current and prior reporting-currency rows used in the final sample are USD; all selected I/B/E/S actual and summary currencies are USD. The native-currency descriptor differs from `CURCD` on 399 final rows, but it is not treated as a reporting-currency mismatch or screened. `USFIRM` is only a source-product flag.

   The local catalog labels `FUNDA.IID` “Header Primary Global Issue ID” and `FUNDA.HIID` “Historic Primary Global Issue ID.” I therefore bounded the check to the actual 25,469 current and 25,469 prior Compustat rows used by the A2 sample, joining by GVKEY/FYEAR/DATADATE and comparing HIID to dated `SEC_MTH.PRIMISS` and issue-level prices. HIID is present on all 25,469 required current rows and all 25,469 required prior-price rows. On the prior-price inputs, header IID differs from HIID in 13 rows. In all 13, the HIID-selected dated primary quote matches annual `PRCC_F` within the build's tolerance and has the same USD currency as A2's verified quote: 7 A2 monthly matches and 6 daily fallbacks. No final denominator value, currency, or sample key changes on those rows.

   A unique dated primary issue matching HIID is present in 25,461 prior-price rows; eight have no `SEC_MTH.PRIMISS='P'` row at the source date. In those eight, HIID equals header IID and A2's daily same-issue quote matches `PRCC_F`. One additional row has a dated HIID primary but no monthly price quote; HIID equals header IID and the verified daily fallback is same day. Overall, A2 verifies all 25,469 prior prices (25,454 monthly, 15 daily within seven days; daily ages are 0–2 days). This bounded result finds no actual price/currency or coverage effect in the final sample from the 13 header/HIID differences. It does not establish a historical primary mapping for every possible source row: the eight absent dated `P` flags and the one missing monthly quote remain dependent on the same-issue daily route.

4. **Historical industry classification.** The build preserves valid Compustat `SICH` and fills only missing/invalid values from a unique `DSENAMES.SICCD` effective on actual `DATADATE` for the matched PERMNO. It does not use a current/header SIC. Missing/invalid CRSP zero and ambiguous dates remain unavailable. All 19 years survive. The final sample uses Compustat SIC for 23,166 observations and CRSP fallback for 2,303. In the full annual panel, overlapping valid codes agree exactly on 24,125 of 100,519 records and disagree on 76,394; financial/nonfinancial class agrees on 96,839 and disagrees on 3,680. The paper does not identify the SIC source, so the Compustat-first route remains a best-effort choice.

## Execution and estimates

The final native run completed SAS, handoff, descriptive exports, and all three Stata cells. Each model has 25,469 observations, 19 annual fits, and full rank in every year: Table 5 rank 12; Tables 6 and 8 rank 5. Annual counts (1984–2002) are 676, 734, 816, 905, 1,031, 1,168, 1,184, 1,245, 1,345, 1,492, 1,659, 1,759, 1,840, 1,957, 1,838, 1,717, 1,497, 1,235, and 1,371. The original 38,716-observation count is 13,247 above A2. That difference is not attributed to data vintage: this assignment covers only these three fits and does not rebuild the paper's unassigned return-predictability controls or future forecast-error outcome, so it cannot verify the stated all-tests-common population.

The `xtfmb, lag(1)` choice is best effort because the paper does not state a lag order. There is also a source ambiguity: the general methods section calls for Newey–West adjustment, whereas Table 5's note displays the conventional mean-coefficient standard error based on the annual coefficient standard deviation divided by the square root of the number of years. This attempt follows the general methods statement; it does not claim that lag 1 reproduces the table's original inference. The reported coefficient tests use the installed command's diagonal Newey–West variances. Its printed overall F and joint contrasts do not have valid HAC off-diagonal covariances and are not used as evidence. The exported R-squared values are mean raw R² (.2962, .0174, .0568); they are not the paper's adjusted R² (16.04%, 0.24%, 1.32%). The paper reports t-statistics but not a p-value convention; the template exports two-sided p-values.

The tables below compare every coefficient in the three assigned fits. Published coefficient/t-statistic pairs are transcribed from the cited original tables; A2 t-statistics and two-sided p-values come from the native Stata logs.

| Table 5, full Eq. (4) | Published β (t) | A2 β (t; p) |
|---|---:|---:|
| Intercept | −0.140 (−5.42) | −0.11734 (−2.23; .039) |
| EARN | 0.312 (1.64) | 2.18341 (14.41; <.001) |
| ΔEARN | 2.863 (2.79) | 0.84294 (5.86; <.001) |
| RNOA | 0.289 (7.58) | 0.14472 (1.78; .092) |
| ΔRNOA | −0.005 (−0.13) | 0.49362 (4.33; <.001) |
| PM | −0.086 (−0.32) | −0.29374 (−1.27; .222) |
| ATO | −0.008 (−0.68) | −0.00336 (−0.56; .585) |
| ΔPM | 0.125 (1.89) | 1.67679 (6.22; <.001) |
| ΔATO | 0.087 (5.88) | −0.01967 (−1.72; .103) |
| Future RNOA | −0.007 (−0.43) | 0.26788 (3.43; .003) |
| Future PM | 0.724 (1.83) | 0.07441 (0.39; .700) |
| Future ATO | 0.017 (3.44) | −0.00302 (−0.55; .589) |

| Table 6, Model 3 | Published β (t) | A2 β (t; p) |
|---|---:|---:|
| Intercept | 0.006 (5.21) | 0.00610 (4.94; <.001) |
| SUR | 0.144 (4.59) | 0.43670 (5.98; <.001) |
| ΔPM | −0.004 (−1.55) | 0.02928 (1.35; .192) |
| ΔATO | 0.002 (2.01) | 0.000881 (1.06; .301) |
| ΔRNOA | 0.003 (1.40) | 0.01134 (1.63; .120) |

| Table 8, Model 3 | Published β (t) | A2 β (t; p) |
|---|---:|---:|
| Intercept | −0.002 (−4.40) | −0.00124 (−8.84; <.001) |
| SUR | 0.066 (3.26) | 0.09316 (6.60; <.001) |
| ΔPM | 0.001 (0.94) | 0.00824 (3.67; .002) |
| ΔATO | 0.001 (2.44) | 0.000109 (1.20; .245) |
| ΔRNOA | 0.000 (0.01) | 0.00125 (1.81; .087) |

The clearest substantive gaps are that the published positive ΔATO association is absent in all three fits, Table 5 EARN and ΔEARN differ sharply in magnitude, and Table 8 ΔPM is positive and significant in A2 despite a small, insignificant published estimate. SUR remains positive and significant in Tables 6 and 8, with larger A2 coefficients.

Actual-sample descriptive statistics are exported for every regression input. Selected means (SDs) are `R` .089 (.762), `UR` .006 (.091), `RFUT` .011 (.623), EARN .060 (.068), ΔEARN .017 (.099), RNOA .268 (.313), ΔRNOA −.006 (.252), PM .119 (.086), ATO 2.718 (2.526), ΔPM .005 (.059), ΔATO −.160 (1.371), SUR −.002 (.020), and ANREV −.001 (.009). The full export includes count, median, minimum, and maximum.

## Remaining limits

- The adjusted versus unadjusted I/B/E/S product used in the paper is unspecified. A2 retains the unadjusted products and a relative CRSP share-factor conversion; adjusted products were not substituted without source evidence.
- Forecast timing and the four-complete-month return start are operational interpretations where the paper gives no exact date cutoff. Current-year SUR has no source-specified maximum age.
- The paper says its analyses share a 38,716-observation sample, but this assignment does not reconstruct unassigned tests; the final 25,469 is the common complete-case sample for the three assigned scopes only.
- The paper does not specify SIC source, Newey–West lag, or exact IBES forecast product. CCM and I/B/E/S ties with no paper-defined resolution are excluded when the selection is ambiguous. 10,073 GVKEY/FYEAR actual-event selections had tied rows after currency matching and announcement/actual-date selection; ambiguous cases were excluded. The summary candidate pool also has 1,466,374 duplicate period-date groups removed before nearest-date selection; this is not a final-sample attrition count. The paper does not specify tie resolution.
- A2 keeps a same-header-IID and same-PERMNO continuity requirement for prior-year scaling/factor alignment. The bounded HIID audit found no changed final price or currency input, but does not establish security identity for every source observation outside the final rows.
