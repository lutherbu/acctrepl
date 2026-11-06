# Independent review and repairs

## Frozen scope and execution

This review covers the single frozen baseline, `ferc_primary` / `table3_panel_c_primary` (Regression (4), Table 3 Panel C). The model, result-set, sample IDs, and `GVKEY`–fiscal-year key remain unchanged. The supporting accrual regression is only used to construct `DAP` and `IS`. Attempt 01 was inspected as read-only evidence. Its final SAS and Stata cells both used the same build and Stata code initially present in attempt 02, but the corrected attempt did not reuse its data: source construction and the sample screens changed, so A2 rebuilt from the catalog-listed sources.

The final SAS build and handoff passed with return code 0 in `runtime/20261102T183028054904Z`. Both Stata cells passed with return code 0 in `runtime/20261102T183416852421Z`. `validate` reports valid, no warnings, one scope, zero blocked scopes. The regression and descriptive exports each exist as `.md`, `.rtf`, `.csv`, and `.tex`. `esttab` and `estpost` were found in the Stata handoff. The unchanged Stata template is followed directly; the regression cell uses pooled `reg` and the descriptive cell uses `estpost tabstat`.

## Source and data checks

I checked the original PDF `papers/pdf/W3121570881.pdf` directly. Physical page 8 (printed p. 257) gives Regression (4), its pooled cross-sectional/time-series description, and the positive predicted sign on `IS × X_t3`. Physical page 9 (printed p. 258) specifies the 1993–2000 primary period, the 1988–2000 accrual-fit window, the 10-observation minimum, annual 3-SD winsorization, five-observation smoothing history, missing-data requirements, 1% trimming, and the separate magnitude exclusions. Physical page 10 (printed p. 259) contains Table 1 definitions and footnote 10, which says the results are similar when EPS is deflated by the beginning-of-year price. Physical page 11 (printed p. 260) gives Table 2 Panel A and the primary variable definitions. Physical page 12 (printed p. 261) gives Table 3 Panel C, N = 17,019, `b7 = 0.681` (`t = 4.08`), and `b8 = 0.308` (`t = 4.99`), and defines `R_t` as the ex-dividend fiscal-year return and `R_t3` as the annually compounded return over `t+1` through `t+3`.

The local SAS catalog `/storage/sas/data_description.txt` confirms every raw field used by the build in `COMP.FUNDA`, `COMP.G_EXRT_MTH`, `COMP.G_EXRT_DLY`, `CRSP.CCMXPF_LINKTABLE`, `CRSP.DSENAMES`, and `CRSP.DSF`. Relevant current `COMP.FUNDA` fields are `IB`, `OANCF`, `AT`, `SALE`, `PPEGT`, `EPSPX`, and `AJEX`; CRSP fields are `RETX`, `PRC`, `SHROUT`, `CFACPR`, name dates/share code, and link dates/type/primary/use flags. The selected Compustat product screens left 117,921 rows with zero duplicate `GVKEY`–`FYEAR` groups.

Provider-guide checks support the variable map: the cached 2004 Research Insight guide maps Data 6/A6 to `AT` (physical p. 136), Data 7/A7 to `PPEGT` (p. 170), Data 12/A12 to `SALE` (p. 270), Data 18/A18 to `IB` (p. 250), Data 58/A58 to `EPSPX` (p. 660), and Data 308/A308 to `OANCF` (p. 871). Its AJEX definition and split example are on p. 647. The Xpressfeed guide states that split-adjusted basic EPS excluding extraordinary items is `EPSPX/AJEX` (physical p. 29) and that current Xpressfeed price/share items are delivered unadjusted (pp. 107–108). The cached CRSP stock guide defines ordinary common share codes 10/11 (physical p. 115); the CRSP/Compustat guide documents date-valid link fields and link codes (physical pp. 9 and 23). These checks confirm that A1's original EPS formula, which treated raw `EPSPX` as fully adjusted and divided by a raw CRSP price, was a share-basis defect.

## Construction review and repairs

The corrected build assigns `AJEX_anchor` from fiscal year `t−1` at `build.sas:548`. It defines `X_{t−1}`, `X_t`, and `X_{t3}` once at `build.sas:602–607` as the USD-converted EPS for each source year multiplied by `AJEX_{t−1}/AJEX_s`, summed where appropriate, and divided by raw `abs(PRC)` at the beginning-`t` anchor. The `t−1` ratio cancels by construction. Later steps only form interactions and labels; they do not overwrite any `X` variable. The code does not combine Compustat AJEX with CRSP CFACPR endpoints.

The accrual fit uses 1988–2000 data, separate historical two-digit-SIC × year fits, no intercept, and groups of at least 10 observations. The build uses the locally documented current `INDL/C/D/STD` Compustat rows, USD-converted values, and the paper's Data 18 earnings basis. It winsorizes each regression input at its annual mean ±3 SD before fitting. It forms DAP from original accruals less fitted values evaluated on original predictors; this fitted-value treatment is a best-effort reading because the paper does not provide implementation detail. The local build had 720 eligible industry-years, 609 with at least 10 observations and 111 below 10, versus 650 fits and 110 excluded groups in the paper. Of 76,912 support rows, 521 had no fitted DAP after the group-size/singularity requirements. The current-vintage population differs from the 2004 version, so the group-count gap is not attributed to one cause.

The income-smoothing measure uses the Pearson correlation between five consecutive changes in DAP and pre-managed income, with six consecutive annual levels for the changes, then descending fractional ranking within historical two-digit SIC × year. The joins preserve gaps. This follows printed pp. 255, 258–259, and Table 3 definitions on p. 261. Tied ranks use average rank because the paper is silent on tie treatment.

The source says to trim the top and bottom 1% for earnings, CFO, accruals, and returns after required-data deletion, but it does not define the currency/scale, pooled versus year-specific cutoff population, or weighting convention (physical p. 9 / printed p. 258). A2 applies joint-complete-case pooled cutoffs to each `IB`, `OANCF`, and total-accrual amount in `t−3…t+3`, divided by baseline `ME_t`, and to annual returns `R_t…R_{t+3}`. The same underlying annual observation may recur in multiple overlapping baseline windows in this long cutoff population. This is a documented best-effort pooling choice. The phrase “earnings” is ambiguous about whether it includes the regression's EPS/price values; A2 removes A1's extra percentile cutoffs on `X_{t−1}`, `X_t`, and `X_{t3}` because separate EPS/price screens are not stated clearly by the source.

I also corrected the separate ±10×market-equity screen. A1 applied it to all seven accounting years `t−3…t+3`; the source's magnitude rule is for current/future three years, so A2 applies it only to `t…t+3` (`build.sas:685`). The future compounded `R_t3` cutoff remains ±10. The separate 1% screen still covers the stated past/current/future accounting window. Cutoffs are computed after the required-data screen and before the separate magnitude exclusion.

## Return coverage and beginning-price audit

The first A2 diagnostic execution (`runtime/20261102T182303730526Z`) evaluated the final 13,021-row sample before changing the return rule. Across its 52,084 required annual periods (`t` through `t+3`), 201 had only partial date-valid linked common-share coverage: offsets 0–3 had 3, 2, 3, and 193 periods, respectively. Every one had at least one nonmissing observed `RETX`, and there were zero explicit missing `RETX` values and zero missing rows on dates the link/name history marked active. Some partial periods had only two observed sessions, while their fiscal periods had many more CRSP market sessions. Thus A1's `nret>0` and `nmiss=0` condition mistook a partial fiscal-period return for a full annual return.

The source defines a fiscal-year return but does not spell out a daily coverage algorithm. I interpreted the annual-return construct to require a unique linked common-share row and nonmissing `RETX` on every CRSP trading-session date in `(prior Compustat fiscal-year end, current fiscal-year end]`. The build compares exact period session counts and leaves returns unavailable when an expected calendar row is absent or `RETX` is explicitly missing (`build.sas:439–477`). This imposes no arbitrary minimum-day threshold. The corrected final support contains 50,848 annual periods (12,712 × four), all classified as full-period coverage, with zero explicit missing returns. The initial support audit distinguished partial linked intervals from explicit missing `RETX`; the final audit confirms that the first and last observed dates align with the session boundaries for all retained periods.

The first A2 price-age audit found a median anchor age of zero calendar days and a 95th percentile of two days, but one final-support row used a close 1,576 days old. A1 selected the latest price with nonmissing `PRC`/`SHROUT` on or before the anchor and did not limit its age. A2 now selects the latest CRSP market-session date on or before the prior fiscal-year end, then requires a date-valid unique linked common-share record with `PRC` and `SHROUT` on that exact session; it does not fall back to a stale close (`build.sas:505–522`). In the corrected final sample, 9,528 anchors are on the same calendar date as the Compustat period-end anchor, 3,184 are 1–3 calendar days earlier, the median age is 0, the 95th percentile is 2, and the maximum is 3 days. This handles weekends/holidays without an arbitrary calendar-day cutoff.

## Primary results and sample comparison

The exported Table 3 Panel C regression is pooled OLS with conventional standard errors, an intercept, no weights, and no fixed effects. The paper describes pooled cross-sectional/time-series estimation but does not report the underlying estimator's covariance correction, so the inference is best effort. The outcome and regressors are in decimal return and EPS/price-ratio units, with `IS` on the source's 0–1 fractional-rank scale.

| Research-interest term | A2 coefficient | SE | t | A2 two-sided p | Paper coefficient | Paper t |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `IS × X_t` (`b7`) | 0.8120 | 0.2146 | 3.78 | <0.001 | 0.681 | 4.08 |
| `IS × X_t3` (`b8`) | 0.3759 | 0.0733 | 5.13 | <0.001 | 0.308 | 4.99 |

Both source-predicted effects remain positive and significant under two-sided conventional OLS tests. A2's `IS × X_t` estimate is 0.131 larger and its t-statistic is lower than the paper's; `IS × X_t3` is 0.068 larger and its t-statistic is slightly higher. The template reports two-sided p-values; the paper gives t-statistics and predicted signs. No inference correction is imposed to match the paper.

The corrected sample has N = 12,712 versus the paper's 17,019, a shortfall of 4,307 (25.3%). The A2 complete-case population before percentile/extreme screens had 15,292 rows; the 1/99 screens removed 2,562 and the separate extremes screen removed 18, leaving 12,712. The preceding A2 pass, before requiring full return-session and exact beginning-price support, had N = 13,021. Its audit identified 201 partial annual-return intervals and one stale price anchor. The complete-case count then fell from 15,682 to 15,292 after the return/price rules were corrected; percentile removals also changed from 2,643 to 2,562. These diagnostics demonstrate a construction effect, but the remaining N gap is not assigned to one cause. The unavailable 2004 Compustat vintage, local current-vintage selection, supporting-window availability, date-valid links, and unreported percentile details remain plausible contributors.

Available Table 2 Panel A descriptive means and standard deviations use the actual regression sample. Source values are from printed p. 260; A2 values are from `table2_panel_a_descriptives.csv`:

| Variable | A2 mean / SD | Paper mean / SD |
| --- | ---: | ---: |
| `R_t` | 0.128 / 0.534 | 0.153 / 0.688 |
| `X_{t−1}` | 0.028 / 0.097 | −0.002 / 0.185 |
| `X_t` | 0.035 / 0.097 | 0.015 / 0.145 |
| `X_{t3}` | 0.124 / 0.270 | 0.074 / 0.362 |
| `R_{t3}` | 0.351 / 1.077 | 0.335 / 1.162 |
| `ACC_t` / beginning market equity | −0.058 / 0.126 | −0.070 / 0.165 |
| `CFO_t` / beginning market equity | 0.096 / 0.126 | 0.086 / 0.151 |
| Five-change smoothing correlation | −0.758 / 0.371 | −0.709 / 0.418 |
| Asset-scaled `DAP_t` | −0.029 / 0.140 | −0.047 / 0.525 |

The `R_{t3}` mean is close to the source, while the attempt's return and EPS/price spreads are smaller. The DAP standard deviation is 0.140 versus 0.525, and its minimum is −3.915 versus −41.540. These are comparisons across differently sized achieved populations; they do not establish a specific vintage or model-construction cause.

## Remaining limits

The historical 2004 Compustat file is unavailable. The paper does not identify its CRSP source or exact price/return-date convention, its pooled-model standard-error correction, or the scaling/pooling details for 1% trimming. The daily return screen uses complete exact session coverage as a full-period interpretation of the paper's annual-return variable. The current-vintage accrual-fit population differs from the paper's reported group counts, and the paper does not fully specify the fitted-value treatment for DAP. No specification, screen, or transformation was selected to improve agreement with the published N or coefficients.
