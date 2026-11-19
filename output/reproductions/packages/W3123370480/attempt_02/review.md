# Independent review: W3123370480, attempt 02

## Scope and source evidence

This review covers the three assigned Table 1, Panel B Eq. (1) results: the one-, two-, and three-year-ahead earnings regressions. It does not add the four- or five-year horizons, analyst forecasts, or any ICC valuation fit.

The original paper defines Compustat earnings as income before extraordinary items, describes the pooled regression and yearly winsorization on physical PDF p. 4 (printed p. 507), sets the three-month reporting lag and June formation window on physical p. 5 (printed p. 508), and reports Table 1A/B on physical p. 6 (printed p. 509). Figure 1 on physical p. 5 places the latest predictor fiscal year end in April of year `t−1` through March of year `t` and says the coefficients used at June `t` are assumed known then. The paper never states the exact ten-year endpoint convention or the Newey–West bandwidth.

The inherited implementation uses unweighted pooled OLS for each horizon and forecast-origin year, then equally averages annual coefficients. It retains an intercept and all six Eq. (1) regressors; it has no firm or industry fixed effects, financial/utility exclusions, or firm-history minimum. Annual level variables are winsorized at 1/99; `DD` and `Neg E` remain indicators. The source describes `D` as a dividend payment without an item number. `DVC` is kept as a best-effort common-dividend amount because the local S&P guide documents it as Cash Dividends—Common (item A21); missing DVC remains missing and only observed positive DVC sets `DD=1`.

## Construction and data checks

The exact local sources in the frozen submission are `COMP.FUNDA`, `COMP.G_EXRT_DLY`, `COMP.G_EXRT_MTH`, `CRSP.CCMXPF_LINKTABLE`, `CRSP.DSENAMES`, and `CRSP.MSF`. The build uses the core `INDL/C/D/STD` annual Compustat records and keeps financial firms and utilities, as required for the baseline. Historical security eligibility is CRSP share codes 10/11 and exchange codes 1/2/3 at the June formation date. It selects dated LC/LU P/C links, treats missing and special open link ends as open, resolves the dated CRSP name interval, and rejects ambiguous GVKEY/security mappings rather than duplicating observations. The predecessor SAS output reported zero tied latest-date groups, zero multi-security GVKEY-years, zero multi-GVKEY PERMNO-years, and zero conflicting effective June name rows.

The accrual construction follows the source switch: before FY1988 it computes `Δ(ACT−CHE) − Δ(LCT−DLC−TXP) − DP` from current and previous fiscal-year balance sheets; from FY1988 it uses `IB−OANCF`. The required TXP term is present. The code uses exact adjacent fiscal-year joins, preserves missing inputs, and does not substitute cash-flow accruals before the source switch or zero-fill unavailable fields.

I checked the local Xpressfeed currency documentation (Currency Data chapter, annual balance-sheet and annual income/cash-flow translation tables, printed pp. 80–81) against the code. It specifies the GBP bridge formula `reported amount ÷ GBP-to-reporting rate × GBP-to-target rate`; annual balance-sheet amounts use dated `EXRATD`, while income/cash-flow amounts use `EXRAT12M`. The build applies each row's own `DATADATE`, converts the prior balance sheet at its own date before differencing, and retains the daily quote-type descriptor as provenance rather than an eligibility filter. Local quote diagnostics in the predecessor SAS listing show GBP/USD support from 1 Feb 1982 daily (9,148 unique positive dates) and 31 Jan 1982 monthly (315 unique positive dates). Among 33,410 CAD annual rows, 25,331 have both exact-date daily legs and 25,903 have both monthly legs. Monthly CAD matching is complete from 1983 onward; daily matches are intermittent through 1986 and complete from 1987 onward. In the final training pool, 303 rows are CAD-converted and 3,552,070 are USD. Unavailable dated quotes remain unavailable.

### Early accrual availability

A bounded SAS audit in `runtime/audit/early_accrual.sas` reconstructed the same five earliest June CRSP/Compustat cross-sections and the exact current/prior fields needed by the balance-sheet method. For formation 1964 it reproduced the predecessor's 1,076-row share sample: 1,068 current USD rows and 8 current CAD rows. Fifty-one rows have every raw current and prior accrual input observed; 45 are USD/USD pairs and exactly match the 45 computed 1964 accruals in the production listing. The six complete raw CAD rows have no supporting 1964 rates and therefore remain unavailable.

The limiting fields are visible in the aggregate missingness counts, not just the warm-up boundary: TXP is missing for 940 of the 1,076 current records and 1,019 prior records. Other current fields are missing as well (ACT 11, CHE 106, LCT 12, DLC 108, and DP 28); prior ACT/CHE/LCT/DLC are missing on 30/127/30/130 rows. These counts overlap. The available source evidence supports retaining those records as missing; it does not support replacing TXP or other inputs with zero. The observed accrual counts for the linked June cross-sections rise from 45 in 1964 to 116, 186, 223, and 285 in 1965–68. This explains the small earliest complete-case pools without attributing the gap solely to the ten-year warm-up or asserting an unverified vintage cause.

## Timing and rolling-window interpretation

The implemented formation label is `year(DATADATE) + 1` for April–December dates and `year(DATADATE)` for January–March dates, consistent with the June information set in Fig. 1. For fit origin `t`, training outcomes use formation years `t−10` through `t−1`; their predictors are the same firm's records exactly `τ` formation years earlier. The build excludes every target dated after March 31 of the outcome formation year, and the SAS diagnostic found zero outcome records after `t−1` for a fitted origin.

The window endpoint remains a best-effort choice. The phrase “previous ten years” supports ending at `t−1`; Fig. 1 also says the March-`t` fiscal-year data and the coefficients used at June `t` are assumed available by then, so inclusion of outcome formation year `t` is not ruled out. This implementation deliberately uses the previous-formation-year endpoint and does not test alternative endpoints. At the 1968 fit, the observed horizon-1 outcome years are 1965–67 (predictors 1964–66), and the horizon-3 pool has only outcome year 1967 (predictor 1964). The local first formation year is 1964, so those are shortened early windows, not ten complete years. For the 2008 fit, outcomes run through 2007 for every horizon. No post-origin outcome was introduced to fill the early windows.

The 1968–2008 fit-year boundary is distinct from the raw source's overall availability. The original sample paragraph (physical p. 3 / printed p. 506) states Compustat coverage 1963–2009 and CRSP monthly coverage July 1963–June 2009; those are study-data ranges, not the whole local CRSP file. The build's year-to-date accounting restrictions cover the required fit-pool dates, and no forecast-outcome or future accounting observations are used to complete a warm-up.

## Table 1A descriptive check

Table 1A reports time-series averages of annual cross-sectional moments over 1968–2008. The predecessor build listing's broad summary averaged 45 years (1964–2008), including four pre-study warm-up years. I therefore did not use that broad summary as a Table 1A comparison. The bounded audit `runtime/audit/table1a_41years.sas` reuses the source construction through the current-year population and averages one annual cross-section per study year. Each statistic below has `N=41`. Entries are `mean; 1st; 25th; median; 75th; 99th; SD`; paper values are from Table 1A on physical p. 6 / printed p. 509, and audit values are rounded for display.

| Variable | Paper | Local 1968–2008 audit |
|---|---|---|
| `E_t` ($m) | 49.07; −174.82; −1.33; 3.41; 22.78; 1,269.20; 184.81 | 37.47; −143.91; −0.95; 3.08; 19.25; 968.66; 136.93 |
| `A_t` ($m) | 1,529.78; 2.49; 34.18; 138.48; 607.52; 36,767.94; 5,505.94 | 1,319.74; 2.47; 32.03; 130.14; 558.66; 33,152.21; 4,329.52 |
| `D_t` ($m) | 19.11; 0.00; 0.01; 0.27; 4.32; 498.24; 69.33 | 13.30; 0.00; 0.0012; 0.2023; 3.08; 359.44; 48.73 |
| `DD_t` | 0.49; 0.00; 0.07; 0.41; 1.00; 1.00; 0.47 | 0.4713; 0.00; 0.0244; 0.3902; 1.00; 1.00; 0.4765 |
| `Neg E_t` | 0.25; 0.00; 0.00; 0.00; 0.63; 1.00; 0.41 | 0.2348; 0.00; 0.00; 0.00; 0.6341; 1.00; 0.4002 |
| `AC_t` ($m) | −43.14; −1,138.99; −17.82; −2.48; 0.67; 104.81; 157.27 | −39.83; −1,033.48; −18.66; −2.99; 0.43; 123.66; 142.78 |

The differences are observed for the source-compatible annual cross-sectional grain. This audit does not establish whether they arise from local data vintage, historical identifiers, source-item choices, missing-field coverage, or another implementation difference, so no single cause is assigned.

## Table 1B fits and inference

The original paper reports 41 yearly coefficients but does not report any per-fit observation counts. SAS checked all 123 horizon/year pools; all 41 annual fits per horizon have six full-rank slope regressors plus the intercept. The source pool contains 3,552,373 rolling training rows across horizons. The table's `Observations` counts sum overlapping origin-year windows and are not unique firms or unique firm-years. They are not comparable to the paper's separate model-forecast coverage counts.

The paper reports the time-series Newey–West t-statistics of the annual coefficient estimates (physical p. 5–6; printed pp. 508–509), but no bandwidth. The inherited Stata cell uses `xtfmb` with lag 3 as an explicit best effort. I verified the installed `xtfmb` implementation: under `lag()` it supplies individual coefficient HAC variances but sets off-diagonal covariances to zero, so its overall F display and joint coefficient tests are not reported as valid HAC inference. The table uses the assigned template's p-value format; those p-values are two-sided, while the paper publishes t-statistics and does not state a tail convention.

| Horizon | Rows across rolling pools | Origins / full-rank fits | Earnings slope (NW t) | Paper earnings slope (t) | Accrual slope (NW t) | Paper accrual slope (t) | Mean adjusted R² | Paper adjusted R² |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 year | 1,304,760 | 41 / 41 | 0.7841 (28.59) | 0.8304 (35.09) | −0.0488 (−3.87) | −0.0725 (−6.23) | 0.8543 | 0.86 |
| 2 years | 1,181,563 | 41 / 41 | 0.7175 (20.76) | 0.7924 (25.21) | −0.0485 (−2.42) | −0.0848 (−4.09) | 0.8004 | 0.81 |
| 3 years | 1,066,050 | 41 / 41 | 0.7225 (14.22) | 0.7871 (22.89) | −0.0455 (−1.93) | −0.0932 (−3.67) | 0.7658 | 0.78 |

The coefficients, inference, counts, and nonblank adjusted R-squared row were checked in A2's current Stata log and four exports. `mean adjusted R²` is the equal mean of native annual OLS adjusted R-squared values; the row was stored from `e(r2_a)`. The Newey–West lag is an assumption, so local t-statistics are conditional on that bandwidth. The source-reported coefficient differences are retained without changing screens or transformations to improve agreement.

## A2 disposition

### Coordinator cross-check

The coordinator also checked the predictor/outcome roles directly in `build.sas`: training predictors come from the dated CRSP/Compustat population (`popw`), while realized earnings come from the broader annual table (`annw`). The outcome join requires observed outcome earnings, not outcome-year accruals, other regressors, or continued CRSP listing. It therefore does not impose those unnecessary future eligibility conditions.

The remaining Table 1B coefficients also differ materially in places. In horizon order 1/2/3, the source dividend-dummy coefficients are 0.9019/0.6430/0.0972 with t-statistics 1.51/0.66/0.08; the local coefficients are 2.2220/3.3148/4.4622 with t-statistics 5.01/5.64/7.10. Thus the local dividend dummy is significant in all three horizons whereas the source reports no significance. The source negative-earnings dummy is 1.3768/2.6787/3.9879 (t=2.14/3.43/5.18); locally it is 0.2669/1.1112/2.0297 (t=0.41/1.74/4.72), retaining the sign but losing 5% significance in the first two horizons. Total-assets slopes are 0.002624/0.004829/0.006410 versus source 0.0024/0.0051/0.0082; dividend-amount slopes are 0.3051/0.4287/0.4341 versus 0.2659/0.3799/0.4653. Both sets remain positive and significant. The local intercepts are −0.2119/−0.0637/+0.2888 (t=−0.74/−0.15/+0.68), versus −1.0311/−1.0738/−0.7876 (t=−2.27/−1.81/−1.21). These comparisons use the original Table 1B and the current A2 native log; no alternative specification was selected to improve agreement.

The production construction and frozen sample declaration are unchanged from A1. The helper verified A1 data hashes before reusing the SAS handoff, and A2 ran its own Stata stage; all four exports were regenerated and match the successful current A2 runtime record. No change to the estimator or fit sample was justified by the independent checks. The only A2 documentation corrections are the attempt label, the explicit window-endpoint limitation, the early accrual-field availability audit, and the corrected 41-year Table 1A comparison.
