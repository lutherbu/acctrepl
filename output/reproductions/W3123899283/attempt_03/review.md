# Independent review: W3123899283, attempt 03

## Review result

A3 repairs the two demonstrated currency defects in A2 and retains the paper's 21 assigned baseline scopes. The final native run is `runtime/20261103T003721727466Z`: SAS completed successfully, the SAS-to-Stata handoff completed, and all five Stata cells returned 0. The 21 scopes are executed with none blocked. Each of the five tables has `.md`, `.rtf`, `.csv`, and `.tex` exports. The final `build.log` and Stata logs contain no emitted errors or warnings; the SAS listing contains the ordinary procedure output and all requested counts.

Three complete helper runs are retained. The first A3 run produced the full baseline; the next added by-year and ratio-validity counts; the final clarified that missing/nonpositive `AT` is distinct from an unavailable FX quote and printed own-date FX leg coverage. Those later changes affect audit labels and handoff provenance fields, not eligibility or regression inputs. All 20 Stata table files have identical hashes across the three runs; the final handoff is the current one.

## Source checks and A3 repairs

- **Paper scope and formulas.** I checked the PDF's sample description and Table 1 (PDF pp. 4–5; journal pp. 163–164), Table 2's h=1 persistence regressions and Q1/Q5 tests (PDF p. 6; journal p. 165), Table 3's separate horizon/group counts (PDF p. 8; journal p. 167), and Table 4's five-year sum and tests (PDF p. 11; journal p. 170). A3 retains current plus four prior scaled earnings/CFO years, December year-end, the $100 million USD asset screen, pooled 1st/99th percentile trimming, a firm-level half-split, current plus four prior years for volatility, exact fiscal-year leads, all five future earnings for the sum outcome, and separate horizon Ns.
- **Item mapping.** The read-only `COMP.FUNDA` catalog lists `AT`, `IBC`, `OANCF`, `CURCD`, `DATADATE`, and the annual filters used. The Compustat Research Insight guide maps Item 6 to `AT`, Item 123 to `IBC` (physical p. 850), and Item 308 to `OANCF` (physical p. 871). `IBC` is the cash-flow-statement version of Item 123; A3 does not substitute the similar `IB` field.
- **USD asset threshold.** A2's `AT*CURRTR` direction was not established by its generic field label. The 2011 Xpressfeed provider guide's cross-rate instructions define GBP as the primary currency and say to divide the reporting-currency amount by the quote from GBP to reporting currency, then multiply by the quote from GBP to target currency. For balance-sheet amounts the guide specifies daily `EXRATD` matched to `DATADATE` (printed pp. 77–80; local PDF pp. 85–88). A3 therefore reads the exact catalog-listed `COMP.G_EXRT_DLY` file at `/storage/sas/base/comp/d_global/currency/g_exrt_dly.sas7bdat`, joins both `FROMCURD='GBP'` legs on the FUNDA row's own `DATADATE`, uses USD identity, uses GBP-to-USD for GBP, and uses `AT / GBP-to-source × GBP-to-USD` for other source currencies. Rates must be positive and unique. The annual row's own `CURCD` is retained.
- **FX uniqueness, provenance, and fixture.** The build audited 908,994 GBP date/currency quote groups from 1983–2004: 908,994 were positive and unique, with zero duplicate groups and zero unique missing/nonpositive quotes. The selected 1984–2004 FUNDA panel has 12,528 CAD rows; every one has a positive unique own-date GBP-to-CAD source quote and GBP-to-USD target quote. The 126,733 USD rows use identity. The bounded 31-Dec-1999 fixture reads actual unique positive quotes with different descriptors: GBP→CAD 2.3391 with blank `EXRATTPD`, and GBP→USD 1.6117 with `AR`. Converting 100 CAD gives 68.9026 USD; the reciprocal direction gives 145.132, and the fixture passes. A3 does not filter blank or unequal quote-type descriptors. It carries the used source- and target-leg descriptors to the handoff. In the final exploratory handoff, all 588 CAD rows have both positive unique legs; 37 have a blank source-leg descriptor and are retained, while the USD target descriptor is `AR` for all 588. These are provenance labels, not different currency units.
- **A2 threshold movement.** The SAS audit compares the old A2 multiplication with the documented A3 conversion without using the A2 value in the screen. Among all 1984–2004 CAD rows, 6,130 meet $100 million under A2 and 5,477 under dated FX: 653 are A2-only and none are A3-only. Among 5,731 rows with complete valid same-currency earnings/CFO ratios, A2 admits 3,207 while A3 admits 2,835: 372 A2-only and none A3-only. USD eligibility is unchanged (45,351 rows with complete scaled ratios under either route). Only 106 of the 372 moved rows also pass the four-year history requirement, so the candidate count falls from 27,440 in A2 to 27,334 in A3. These are observed population changes, not a new sample target.
- **Current/prior and lead currencies.** The new `AVG_AT`, earnings, and CFO guards require positive current and prior assets plus both own-row currency codes present and equal. In 1984–2004 the native frequency table reports 126,650 compatible currency pairs, 123 known currency changes, 12,488 absent exact prior-year rows, and no unknown currency-code pairs. Missing prior code on an absent prior row is not treated as a valid denominator. As in A2, the 123 known mismatches have unavailable scaled ratios. Future earnings remain internally valid dimensionless ratios and are not required to have the same currency as current earnings; A3 adds no cross-period currency screen. The sampled h=1 audit found zero invalid lead ratios and zero current/lead currency changes in this realized split.

## Sample and A2 comparison

Published Table 1 and local construction counts (firm-years):

| Stage | Published | A2 | A3 |
|---|---:|---:|---:|
| December-year-end observations with current `AT`, Item 123, and CFO | 121,482 | 94,766 | 94,766 |
| Complete scaled earnings/CFO/accrual inputs | 79,879 | 85,564 | 85,564 |
| Complete current ratios and assets of at least $100m | 44,519 | 48,558 | 48,186 |
| Complete current plus four prior years for volatility | 22,990 | 27,440 | 27,334 |
| After pooled 1st/99th percentile trimming | 22,113 | 26,335 | 26,236 |
| Exploratory firm-level split | 11,061 | 13,364 | 13,175 |

The local 1984–2004 panel has 139,261 rows after the documented Compustat filters. A3's 94,766 complete current-item rows exceed the 79,879 rows with deflated measures in the paper, but the current-item count is already 26,716 below the paper's first Table 1 row. Full local sample means remain close for earnings (0.029 vs. 0.031), accruals (−0.055 vs. −0.055), and CFO (0.084 vs. 0.085). A3 full-sample descriptive statistics are: earnings 0.029 (SD 0.072), accruals −0.055 (0.066), absolute accruals 0.066 (0.055), CFO 0.084 (0.074), earnings volatility 0.047 (0.172), and CFO volatility 0.045 (0.048). The paper reports 0.031, −0.055, 0.063, 0.085, 0.040, and 0.039 respectively. Local volatility ranges are wider for CFO (0.000–1.229 vs. 0.000–0.632); the unknown source vintage and population coverage remain unresolved. The first A3 split has 13,175 rows; its exported means are earnings 0.027, accruals −0.055, absolute accruals 0.066, CFO 0.082, earnings volatility 0.044, and CFO volatility 0.045. The paper gives full-sample, not exploratory-split, descriptives.

A2 and A3 use the same fixed seed, but the source-screened firm roster changes from 4,483 firms in A2 to 4,453 in A3, so the half-sample draw changes from 2,241 to 2,226 firms. Comparing the final exploratory handoffs on `(GVKEY,FYEAR)`, 6,972 keys match, 6,392 occur only in A2, and 6,203 only in A3. Among matched keys, `earn_t`, CFO, accruals, absolute accruals, both volatility measures, each of the five future earnings ratios, and the five-year sum are identical within 1e−12. `vol_q` differs for 296 matched rows because the pooled quintile cutoffs/ranks are recomputed on the changed split. Thus the changed horizon estimates reflect a changed draw and quantile population; the underlying matched accounting ratios did not change.

The build listing reports pretrim candidates, post-trim observations, split rows, and h=1–5 plus sum complete cases by fiscal year. Final exploratory outcome counts are h1=11,137, h2=9,336, h3=7,803, h4=6,440, h5=5,214, and five-year sum=5,186. The sum has 28 fewer observations than h5 because it requires all five intermediate lead ratios. The target final period begins in 1988, but the local complete current-plus-four-year candidate rows begin in 1991. A coordinator's bounded source-column audit, using the same annual selectors, confirms zero observed `OANCF` values in each of 1983–1986; 1987 has 785 observed values among 5,015 rows. The audit reproduces the SAS total of 94,766 current `AT`/`IBC`/`OANCF`-complete rows over 1984–2004. Because the source requires current plus four prior CFO years, absent 1984–1986 CFO necessarily rules out the 1988–1990 target observations. This establishes that coverage obstacle, not the cause of the entire published/local count gap. Evidence and reproducible audit code are in `output/reproduction_runs/preflight/volatility_cashflow_coverage.{json,py}` from the git root. No CFO proxy or date-filter change is introduced.

## Baseline estimates and inference

Coefficients and adjusted R² are dimensionless. N is complete firm-year regressions. The local estimates below use the three-decimal Stata CSV exports; the source values are from Tables 2–4. Table 2 does not report N for Q2–Q4.

| Scope | Published β / Adj. R² / N | A3 β / Adj. R² / N |
|---|---:|---:|
| Table 2 h1, full | 0.652 / 0.398 / 9,102 | 0.722 / 0.269 / 11,137 |
| Table 2 h1, Q1 | 0.934 / 0.704 / 1,899 | 0.927 / 0.681 / 2,329 |
| Table 2 h1, Q2 | 0.888 / 0.570 / n.r. | 0.873 / 0.401 / 2,261 |
| Table 2 h1, Q3 | 0.838 / 0.463 / n.r. | 0.838 / 0.338 / 2,260 |
| Table 2 h1, Q4 | 0.755 / 0.414 / n.r. | 0.715 / 0.306 / 2,190 |
| Table 2 h1, Q5 | 0.507 / 0.296 / 1,682 | 0.632 / 0.169 / 2,097 |
| Table 3 h2, full | 0.484 / 0.211 / 7,502 | 0.524 / 0.142 / 9,336 |
| Table 3 h2, Q5 | 0.287 / 0.104 / 1,314 | 0.369 / 0.067 / 1,643 |
| Table 3 h2, Q1 | 0.867 / 0.561 / 1,620 | 0.872 / 0.549 / 2,042 |
| Table 3 h3, full | 0.449 / 0.168 / 6,147 | 0.455 / 0.104 / 7,803 |
| Table 3 h3, Q5 | 0.261 / 0.088 / 1,029 | 0.301 / 0.041 / 1,276 |
| Table 3 h3, Q1 | 0.774 / 0.359 / 1,365 | 0.800 / 0.440 / 1,790 |
| Table 3 h4, full | 0.421 / 0.139 / 5,011 | 0.387 / 0.069 / 6,440 |
| Table 3 h4, Q5 | 0.241 / 0.069 / 822 | 0.192 / 0.017 / 968 |
| Table 3 h4, Q1 | 0.812 / 0.387 / 1,140 | 0.751 / 0.319 / 1,562 |
| Table 3 h5, full | 0.381 / 0.106 / 4,032 | 0.381 / 0.064 / 5,214 |
| Table 3 h5, Q5 | 0.177 / 0.031 / 659 | 0.235 / 0.027 / 732 |
| Table 3 h5, Q1 | 0.805 / 0.315 / 922 | 0.782 / 0.300 / 1,309 |
| Table 4 five-year sum, full | 2.359 / 0.311 / 4,032 | 2.457 / 0.268 / 5,186 |
| Table 4 five-year sum, Q5 | 1.372 / 0.172 / 659 | 1.599 / 0.132 / 726 |
| Table 4 five-year sum, Q1 | 4.205 / 0.633 / 922 | 4.306 / 0.664 / 1,306 |

The pattern of weaker persistence at higher earnings volatility remains. All 21 local slope p-values display as 0.000 in the three-decimal exports, which means below the display precision, not literally zero; source Table 3 states all β are significant at p<0.001. The paper does not specify covariance corrections, so these are native OLS conventional two-sided p-values.

For the Q1–Q5 slope contrast, the A3 pooled Table 2 interaction gives β difference 0.295868 and two-sided p=0.000259; the published difference is 0.427 with p<0.001. For the five-year sum, A3 gives β difference 2.707700 and two-sided p=5.713e−21; the published difference is 2.933 with p<0.001. The paper does not state the Table 2 test sidedness. Table 4's body describes a t-test for the persistence difference and bootstrap for the R² difference, but its footnote says both differences use a bootstrap; A3 follows the body text for the slope test and the described simulation for adjusted R².

Both row-level pseudo-quintile simulations have a finite observed gap and 1,000/1,000 valid repetitions. Table 2: observed Q1 adjusted R²=0.681243, Q5=0.168962, gap=0.512281, zero one-sided and two-sided tail hits. Table 4: Q1=0.663677, Q5=0.132450, gap=0.531227, zero one-sided and two-sided tail hits. The raw empirical tails are 0/1,000 in both cases; this finite-resolution result is not evidence that the true probability is literally zero. The paper reports p<0.001 for each adjusted-R² comparison.

## Remaining limitations

The current local Compustat vintage and the paper's original firm-level split seed are unavailable. The unexplained current-item count gap begins before the asset and volatility screens; the audited field mappings, exact joins, currencies, annual counts, and lead availability do not identify a single cause. A source-vintage or population-coverage difference is plausible but not established. A3's fixed-seed draw is an explicit best-effort reconstruction, not the original assignment. The source does not specify percentile implementation, volatility-tie handling, or the main-regression covariance correction. Table 4's inference description conflicts between the body and footnote. No screen or transformation was altered to target the published coefficients or Ns.
