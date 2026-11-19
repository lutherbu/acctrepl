# Design: W3121345849, Table 1 baseline fits

## Target and source evidence

The target is Table 1, Panels A–C, horizons t+1, t+2, and t+3: nine rolling cross-sectional fits. The inherited extraction's 119,653 observations for 1969–2008 describe later forecast-error/ICC evaluation (Table 2, physical p. 10), not these coefficient fits. Table 1 instead summarizes 44 annual fits for each model and horizon from 1969–2012 (physical p. 9). I use no CRSP, IBES, forecast-evaluation, or ICC eligibility screens.

The paper defines the HVZ equation at the dollar level in Eq. (1), physical p. 4, and EP/Richardson residual-income equations in Eqs. (3) and (7), physical pp. 5–6. Its earnings measure is IB−SPI (physical p. 6, footnote 4). Estimation is as of June 30; statements with fiscal year ends from April of the prior year through March of the current year are available, and the rolling estimation window has ten years (physical p. 7). Appendix 1 gives the field formulas and base-year share denominator for future per-share earnings (physical pp. 30–31). Table 1 footnotes state annual estimates and report coefficient means, time-series t statistics, and adjusted R-squared means (physical p. 9).

## Data and timing

I read COMP.FUNDA, COMP.G_EXRT_DLY, and COMP.G_EXRT_MTH, all read-only. The source population is Compustat North America annual standard industrial, consolidated, domestic records (INDFMT=INDL, DATAFMT=STD, CONSOL=C, POPSRC=D). This is a best-effort operationalization of “all firms on the Compustat fundamentals annual file”; the paper does not list these descriptor filters. I retain observed reporting currencies and convert monetary inputs to USD, rather than limiting observations by currency.

A statement ending April–December in calendar year y maps to availability year y+1; January–March in y maps to availability year y. This implements the stated April-prior-year through March-current-year window. Raw history spans availability years 1956–2012, corresponding to actual DATADATE from 1 April 1955 through 31 March 2012. For estimation year T and horizon h, the base years are T−9−h through T−h; the outcome is base year+h, so its latest availability year is T. The first h=3 window is 1957–1966 and requires 1956 for base-year changes. The handoff has base-year observations 1957–2011 and leads through availability year 2012.

If a GVKEY has multiple annual records in one availability year after the descriptor filters, the retained record is the one with the latest actual DATADATE; FDATE breaks same-date ties by latest date. The build reports affected group and row counts. Missing firm-years remain gaps in lag and lead joins.

## Currency and variables

CURCD is the reporting currency for each Funda period; CURNCD is not used as a reporting-currency substitute. The Xpressfeed 2011 currency chapter (physical pp. 82–89; formula and rate-use table on physical pp. 87–88) names GBP as the primary currency. For an observed non-USD reporting currency, the conversion factor is GBP-to-USD divided by GBP-to-CURCD. I use exact-date EXRATD legs for balance-sheet items and same-reporting-month EXRAT12M legs for income-statement/cash-flow items, consistent with the provider's stock/flow rate guidance. USD amounts use an identity factor regardless of CURNCD. Rates must be positive; missing or conflicting legs leave the converted item unavailable. Daily exchange-rate type labels (actual/carried-forward) are retained as provenance counts and are not used as compatibility or eligibility screens. Security-price conversion conventions are not relevant to Table 1.

HVZ variables are USD millions: E=(IB−SPI), AT, DVC, DD=1 when observed DVC>0 (otherwise 0), NegE=1 when observed E<0 (otherwise 0), and AC=Δ(ACT−CHE)−Δ(LCT−DLC−TXP)−DP. For EP and RI, E and future earnings are USD per share. Future E uses current/base-year CSHO in every horizon; the future-year share count is kept only for a bounded denominator audit. RI B=CEQ/CSHO and TACC is per share. The source-defined TACC identity simplifies exactly to Δ(AT−CHE−LT+IVST−PSTK)/CSHO; ACT, IVAO, LCT, DLC, and DLTT cancel. I audit the simplified numerator against the Appendix 1 composite on complete converted observations. This avoids requiring source fields that cancel algebraically. No lagged book-value term is added because Table 1 Eq. (7) omits it.

Only AC and TACC receive the paper's explicit missing-to-zero treatment (physical p. 7). Missing IB, SPI, DVC, shares, book value, or other source inputs are not filled. All model-specific estimation samples use ordinary complete-case OLS. Binary DD and NegE remain unwinsorized. I form all final continuous levels and NegE interactions first, then winsorize each at the 1st/99th percentiles within the base availability year; future per-share outcomes are grouped by their base year and horizon. This is the documented annual winsorization (physical p. 6) with an explicit best-effort timing choice.

## Estimation and reporting

For each model/horizon, `asreg` estimates one OLS regression per estimation year. Native `regress` checks all 132 model-year/horizon groups for residual degrees of freedom and full requested rank. The analysis keeps complete cases before calling `asreg`, then retains one in-memory vector and one `_adjR2` per full-rank annual fit. Native `mean` supplies the unweighted coefficient means and time-series t tests; average adjusted R-squared is attached in percentage points. No Newey–West correction is added because Table 1 does not specify one. The regression tables use the frozen template's two-sided p-value presentation; source Table 1 reports signed time-series t statistics.

The first grouped-output diagnostic returned 78 of 132 visible `asreg` result rows and table Ns of 30/26/22. Native fits found observations in all 132 groups. The final raw-row audit established a row-selection error: in each horizon, `asreg` populated result fields on complete cases, while the first code tagged `_n==1` from all raw rows before filtering. Incomplete raw first-row counts were HVZ 14/18/22 and EP/RI 13/17/21 for horizons 1/2/3. After retaining complete cases before `asreg` and tagging, the tagged-incomplete count is zero and all 44 annual `asreg` vectors, `_R2`, and `_adjR2` values are present per horizon. This count loss was a code-side tagging issue, not missing estimation years or evidence of a package defect. The original diagnostic runs remain in `runtime/`.

Native rank screening finds 132/132 full-rank fits for HVZ and EP, and 131/132 for RI. For RI horizon 3, estimation year 1969 has 4,575 complete rows but `ritacc` is omitted for collinearity: TACC is exactly zero across its 1957–1966 base-year window after the source's explicit missing-to-zero rule. I do not average this underidentified coefficient vector. RI horizon 3 therefore reports 43 qualifying annual fits; its other two horizons report 44. All nonmissing `asreg` endpoint vectors were checked against the native `regress` vectors from the same baseline rank-check fits. Maximum absolute coefficient differences are below 5.6e−12 and N differences are zero; the rank-deficient RI 1969/h=3 endpoint is excluded from that comparison.

The regression Ns below are mean observations per annual fit with the minimum and maximum annual N in parentheses. They are not the table's annual-fit N. The last column is a different quantity: unique complete-case GVKEY-by-availability-year inputs appearing in at least one qualifying training window. `desc01` exports these model/horizon-specific window-union descriptives to `tables/{hvz,ep,ri}_input_union.{md,rtf,csv,tex}` using native `estpost tabstat`. The union ranges are HVZ/EP h=1: 1959–2011, h=2: 1958–2010, h=3: 1957–2009; RI h=1: 1959–2011, h=2: 1958–2010, h=3: 1958–2009 because T=1969 is not full rank. These are Table 1 fit inputs, not the later Table 2 forecast-evaluation sample.

| Model | Horizon | Annual full-rank fits | Underlying N: mean (min–max) | Unique input rows in window union |
|---|---:|---:|---:|---:|
| HVZ | 1 | 44 | 60,530 (16,637–96,059) | 308,732 |
| HVZ | 2 | 44 | 54,927 (14,875–87,942) | 281,115 |
| HVZ | 3 | 44 | 49,783 (13,269–80,279) | 255,945 |
| EP | 1 | 44 | 59,899 (16,753–94,430) | 305,554 |
| EP | 2 | 44 | 54,339 (15,019–86,315) | 278,058 |
| EP | 3 | 44 | 49,279 (13,424–78,808) | 253,301 |
| RI | 1 | 44 | 58,778 (8,681–94,324) | 296,384 |
| RI | 2 | 44 | 53,062 (6,487–86,215) | 268,326 |
| RI | 3 | 43 | 48,855 (6,487–78,716) | 243,085 |

Published Table 1 coefficients and adjusted R-squared are from physical p. 9. The reproduced adjusted R-squared is the native mean of `_adjR2` across qualifying annual fits. E and interaction t statistics below are native mean estimates divided by their standard errors; other estimates, adjusted R-squared values, and p-values are in the exported model tables.

| Model/horizon | Adjusted R², source → build (%) | E coefficient, source → build (t, source → build) | Other focal coefficient, source → build (t, source → build) |
|---|---:|---:|---:|
| HVZ h=1 | 89.6 → 90.034 | 0.8715 → 0.9079 (84.03 → 118.70) | AC −0.0405 → −0.0585 (−6.37 → −6.48) |
| HVZ h=2 | 84.0 → 84.171 | 0.8365 → 0.8496 (46.48 → 92.45) | AC −0.0549 → −0.0857 (−5.01 → −4.41) |
| HVZ h=3 | 80.1 → 80.641 | 0.8378 → 0.8358 (29.11 → 68.69) | AC −0.0585 → −0.0853 (−4.39 → −2.84) |
| EP h=1 | 68.1 → 66.400 | 0.9614 → 0.8658 (204.78 → 21.61) | NegE×E −0.7096 → −2.7905 (−19.77 → −9.66) |
| EP h=2 | 51.5 → 61.799 | 0.9846 → 0.8444 (154.65 → 18.50) | NegE×E −1.1451 → −3.6720 (−17.03 → −10.44) |
| EP h=3 | 41.5 → 56.853 | 0.9992 → 0.8559 (118.66 → 17.12) | NegE×E −1.4155 → −3.9841 (−19.97 → −9.68) |
| RI h=1 | 68.1 → 70.743 | 0.8649 → 0.6161 (109.26 → 13.66) | B 0.0167 → 0.0379 (15.66 → 6.79); TACC −0.0034 → 0.1766 (−2.28 → 3.19) |
| RI h=2 | 52.1 → 66.273 | 0.8280 → 0.5711 (86.93 → 12.41) | B 0.0294 → 0.0377 (20.70 → 8.83); TACC −0.0217 → 0.0573 (−10.07 → 0.37) |
| RI h=3 | 42.5 → 61.574 | 0.8105 → 0.5443 (69.57 → 11.32) | B 0.0409 → 0.0408 (21.94 → 9.39); TACC −0.0413 → −0.0288 (−13.38 → −0.12) |

The HVZ E slopes are close to Table 1, while HVZ AC differs more. EP and RI horizon-2/3 adjusted R-squared and focal coefficients differ materially from the published table. RI TACC changes sign and is statistically indistinguishable from zero at h=2/3, unlike the source t statistics. I found no evidence that justifies changing the frozen population, window, formula, or currency rules to improve agreement; the remaining differences are unresolved and should not be attributed to a data vintage without further evidence. The native table p-values are two-sided and rounded to three decimals, while Table 1 presents signed t statistics.
