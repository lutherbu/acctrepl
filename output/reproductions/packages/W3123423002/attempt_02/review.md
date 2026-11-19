# Independent review

## Scope and source checks

This attempt covers only the two assigned baseline fits: Table 2, column 6, Panel A (OPACC) and Panel B (TACC), ordinary least squares for fiscal years 1988–2002. The original article's sample, variable, trimming, delisting, and model descriptions were checked on physical PDF pp. 7–9, 13–14, and 19–20. No later stock-return, Mishkin, analyst, institutional-holdings, or stepwise tests are included.

The variable mapping was checked against the local Compustat research-insight guide and `COMP.FUNDA` labels. Legacy item A123 maps to `IBC`, not `IB` (item 18); A308 maps to `OANCF`; A311 maps to signed `IVNCF`; A313 maps to `FINCF`; and item 17 maps to `SPI`. Earnings is `IBC`; CFO is `OANCF` without the item-124 `XIDOC` subtraction (the paper calls that a robustness definition); CFI is signed `IVNCF`; FCF is CFO + CFI; OPACC is IBC − CFO; and TACC is IBC − FCF. All current ratios use `(AT_t + AT_{t-1})/2`. Missing SPI is set to zero as the paper expressly directs; no other blanket imputation is made. `SI=1` at `SPI/average assets <= -0.02`, following the Table 2 note's inclusive cutoff. SPI itself is excluded from trimming.

Equation (6) contains only the intercept, current cash flow, current accrual, earnings × low accrual, and earnings × low accrual × SI. The code does not add an earnings main effect, low-decile main effect, SI main effect, or other lower-order interactions. Panel B replaces CFO/OPACC with FCF/TACC. Stata `regress` uses conventional OLS standard errors because the article gives no clustering or covariance rule.

The annual source records use the domestic, industrial, standard, consolidated, cash-flow-statement-format-7 gates. Current years are 1988–2002; actual 1987 records supply the lag and 2003 records supply future values, including actual `DATADATE`s into 2004. Financial SIC 6000–6999 is excluded. Historical Compustat `SICH` is used first; dated CRSP `SICCD` from the valid stock-name interval is used when `SICH` is missing or zero. The paper's sample is not limited to NYSE/AMEX. The build uses dated CCM links (`P` preferred, then `C`; `LC`/`LU`) valid on the Compustat `DATADATE`, and requires CRSP name/price coverage on that date. It treats CCM `.E` end dates as open-ended while respecting recorded bounds.

## Cutoff populations, outcome support, and annual ranks

The paper says to trim the 1% tails of financial-statement variables other than SPI but does not specify the cutoff pool, annual versus pooled cutoffs, or the complete variable list. Attempt 2 therefore uses this declared pooled rule:

- The current cutoff pool is all 80,597 eligible 1988–2002 firm-years after the source-format, link, SIC, date, currency, and positive-assets gates, before trimming. Variable-specific SAS `PROC MEANS` P1/P99 cutoffs are computed for earnings, CFO, CFI, observed CFF, FCF, OPACC, and TACC. Missing values are ignored. All 80,597 eligible rows have observed FINCF in this build. A row is excluded from Table 1 if any observed current variable is outside its own cutoff; values are dropped, not winsorized.
- The future-earnings cutoff pool is `work.outcomes` for the same 80,597 pre-trim rows. P1/P99 are computed on nonmissing scaled future earnings or qualifying delisting replacements; `PROC MEANS` ignores missing future outcomes. These cutoffs are computed before current trimming, then applied only to usable future outcomes in the current-trimmed Table 1 pool.
- Annual accrual ranks use the final common Table 2 pool after both current and future tail trims. `PROC RANK` makes ten groups separately by fiscal year with `TIES=MEAN`; SAS rank 0 is the bottom decile. The article's Figure 1 states annual ascending ranks for its 61,989-firm-year sample, with decile 1 most negative, but does not describe tie handling.

The chosen cutoff values, reported to six decimals, are:

| Ratio | P1 | P99 |
| --- | ---: | ---: |
| Earnings | −1.356840 | 0.286020 |
| CFO | −0.985555 | 0.369357 |
| CFI | −0.916968 | 0.417471 |
| CFF | −0.294965 | 1.766615 |
| FCF | −1.372127 | 0.363651 |
| OPACC | −0.753597 | 0.322538 |
| TACC | −0.780758 | 0.873272 |
| Future earnings outcome | −1.369043 | 0.275278 |

The current eligible pool is 80,597. Current trimming removes 5,749 and leaves 74,848 Table 1 observations. Within this trimmed current pool, 4,040 observations lack a usable lead before future-outcome trimming: 3,984 have missing raw next-year IBC without a qualifying performance-delisting event, and 56 have observed next-year IBC that cannot be scaled. The 56 count is the full unscalable set; the 50 count reported in the currency audit is its subset with missing or mismatched lead `CURCD`. The remaining six fail the positive next-period-assets gate. These 50 and 6 together account for the 56; none is a Table 2 row and none receives an imputed outcome. Of the remaining 70,808 usable leads, 724 fall outside the future-earnings cutoffs, leaving 70,084 common Table 2 observations.

| Fiscal year | Table 2 rank pool | Low OPACC | Low TACC |
| ---: | ---: | ---: | ---: |
| 1988 | 3,790 | 379 | 379 |
| 1989 | 4,035 | 403 | 403 |
| 1990 | 4,112 | 411 | 411 |
| 1991 | 4,238 | 423 | 423 |
| 1992 | 4,394 | 439 | 439 |
| 1993 | 4,699 | 469 | 469 |
| 1994 | 4,895 | 489 | 489 |
| 1995 | 5,129 | 512 | 512 |
| 1996 | 5,404 | 540 | 540 |
| 1997 | 5,485 | 548 | 548 |
| 1998 | 5,183 | 518 | 518 |
| 1999 | 4,904 | 490 | 490 |
| 2000 | 4,869 | 486 | 486 |
| 2001 | 4,593 | 459 | 459 |
| 2002 | 4,354 | 435 | 435 |
| **Total** | **70,084** | **7,001** | **7,001** |

## Delisting date repair and event audit

The original footnote on physical PDF p. 13 requires a missing future-earnings substitution after a performance-related delisting: use negative book equity, or zero when book equity is negative. It does not identify the exact book-equity date, assets deflator, event window, or CRSP delisting-code list. The implementation uses a dated CRSP event after current `DATADATE` and no later than the observed next statement date; if no next statement exists, the chosen interval ends on the one-year anniversary of current `DATADATE`. The code-set choice is the standard Shumway performance category `DLSTCD=500` or `520–584`, disclosed as an assumption rather than a paper-specified rule.

The A1 audit identified 12 of 1,008 Table 2 replacements that used next-year CEQ and next-year average assets even though the next-year statement date was after the actual delisting date. Attempt 2 enforces the chosen event-date information rule: book equity and assets must be from the latest annual statement observations dated on or before `DLSTDT`. Those 12 now use current-year CEQ and current-period average assets. Across the 1,008 replacements, the final handoff has zero book dates or deflator dates after the event; all events are after current `DATADATE` and within the selected interval. Forty-four events precede an observed next-year statement; 964 have no next-year statement and use the anniversary boundary. No row has multiple qualifying events. Current CEQ and current-period average assets come from the latest observed annual statements dated on or before each event; this audit does not establish their public release dates.

Eleven of the twelve repaired replacement values change numerically. One remains zero because book equity is negative under both the post-event and event-date observations. In the repaired Table 2 outcome, 762 nonnegative CEQ observations map to `−CEQ` and 246 negative CEQ observations map to zero; none is exactly zero. Relative to A1, the current and future percentile cutoffs are unchanged, Table 1 and Table 2 membership flags are unchanged, and no annual low-decile assignment changes. The repair therefore changes 11 outcome values but no sample count, cutoff, or rank membership.

The 1,008 is the final Table 2 replacement population. A single additional replacement remains in the current-trimmed Table 1 output but falls outside Table 2 after future trimming. For every included Table 2 replacement, raw future IBC is missing; an observed-but-unscalable IBC is never replaced with a delisting value.

## Link, SIC, period-role, and currency audit

The annual Funda source has no duplicate `GVKEY`/fiscal-year or `GVKEY`/`DATADATE` keys. The dated link filter retains 33,324 acceptable primary/fallback CCM rows, including 6,383 rows with `.E` end dates. No selected Compustat year has an ambiguous chosen P/C CCM link or an ambiguous CRSP name interval. Dated CRSP SIC provides the fallback for 254 Table 1 observations; zero retained Table 1 rows lack both a usable Compustat and CRSP SIC. Thus the financial-firm screen is supported by historical codes rather than current SIC alone.

The current and prior periods must have positive observed assets and the same known `CURCD` before current ratios can be formed. The future reported-IBC ratio requires positive next-period assets and a known next `CURCD` matching current `CURCD`. No `CURNCD` proxy or unverified FX conversion is used. The 56 observed but unscalable leads in the trimmed Table 1 pool consist of 50 missing/mismatched-currency cases and six missing/nonpositive-assets cases; these were kept out of Table 2. Retained current, prior, and present lead dates are actual annual Compustat dates and correctly ordered. This handles reporting-currency coherence conservatively; source-specific historical currency conversion details are not supplied in the article.

## Source comparison

The source reports 63,875 Table 1 observations (article p. 262) and 61,989 Table 2 observations (article p. 271). Attempt 2 has 74,848 and 70,084, respectively: +10,973 (+17.18%) for Table 1 and +8,095 (+13.06%) for Table 2. Table 1 values below are `(mean, median, SD, p25, p75, min, max)` and are rounded to three decimals.

| Table 1 Panel A variable | Source | Attempt 2 |
| --- | --- | --- |
| Earnings | −0.031, 0.028, 0.199, −0.051, 0.071, −2.056, 0.304 | −0.034, 0.027, 0.201, −0.057, 0.071, −1.350, 0.286 |
| Operating accruals | −0.064, −0.051, 0.125, −0.105, −0.004, −1.312, 0.343 | −0.062, −0.050, 0.124, −0.106, −0.002, −0.754, 0.323 |
| Total accruals | 0.025, 0.025, 0.184, −0.052, 0.112, −1.325, 0.808 | 0.041, 0.030, 0.192, −0.047, 0.123, −0.781, 0.873 |
| Special items | −0.018, 0.000, 0.070, −0.009, 0.000, −1.459, 1.128 | −0.017, 0.000, 0.065, −0.008, 0.000, −1.035, 1.309 |
| CFO | 0.033, 0.065, 0.164, −0.011, 0.124, −1.232, 0.394 | 0.029, 0.063, 0.168, −0.015, 0.123, −0.986, 0.369 |
| CFI | −0.090, −0.066, 0.136, −0.137, −0.022, −0.862, 0.539 | −0.103, −0.069, 0.153, −0.147, −0.024, −0.917, 0.417 |
| CFF | 0.053, 0.003, 0.184, −0.037, 0.080, −0.379, 1.521 | 0.088, 0.007, 0.255, −0.035, 0.106, −0.295, 1.767 |
| FCF | −0.056, −0.012, 0.189, −0.114, 0.052, −1.305, 0.432 | −0.074, −0.018, 0.211, −0.131, 0.048, −1.372, 0.363 |

The Table 2 actual-sample descriptive export contains 70,084 observations for each model input; the article gives no directly comparable equation-(6) descriptive panel. Selected means (SDs) are: earnings at t −0.030 (0.195), earnings at t+1 −0.042 (0.213), CFO 0.032 (0.164), OPACC −0.061 (0.122), FCF −0.072 (0.208), TACC 0.042 (0.190), SPI ratio −0.016 (0.064), SI share 0.183 (0.387), and each low-decile indicator 0.100 (0.300). Actual-sample descriptive exports are present for both Table 1 and Table 2 in `.md`, `.rtf`, `.csv`, and `.tex`; Table 1 Pearson and Spearman matrices are also in the native Stata log.

| Table 2 column 6, Panel A | Source | Attempt 2 |
| --- | ---: | ---: |
| CFO | 0.913** | 0.930*** |
| OPACC | 0.683** | 0.694*** |
| Earnings × Low OPACC | −0.137** | −0.128*** |
| Earnings × Low OPACC × SI | −0.197** | −0.172*** |
| Constant | −0.057** | −0.037*** |
| Adjusted R² | 0.3737 | 0.4905 |
| N | 61,989 | 70,084 |

| Table 2 column 6, Panel B | Source | Attempt 2 |
| --- | ---: | ---: |
| FCF | 0.843** | 0.870*** |
| TACC | 0.763** | 0.780*** |
| Earnings × Low TACC | −0.026* | −0.066*** |
| Earnings × Low TACC × SI | −0.300** | −0.247*** |
| Constant | −0.041** | −0.019*** |
| Adjusted R² | 0.3590 | 0.4779 |
| N | 61,989 | 70,084 |

All regression variables are ratios scaled by average assets, so the coefficients are ratio-on-ratio slopes. The native Stata logs report two-sided coefficient tests with `P>|t|` below 0.001 for each displayed term (the table files show `0.000` at three decimal places). The paper supplies coefficient stars only, not exact t-statistics, p-values, or enough information to determine whether its significance tests are one- or two-sided. Its legend maps `*` to 5% and `**` to 1%; the assigned template maps `*`, `**`, and `***` to 10%, 5%, and 1%. The displayed stars therefore follow their respective legends, not an inferred common convention. The sample, several descriptive moments, and adjusted R-squared differ materially; no published number was used to tune construction.

## Execution evidence and remaining limits

The SAS construction and handoff ran successfully under `20261103T054140505239Z`; both returned code 0, with zero formula errors and a unique `GVKEY`/fiscal-year handoff key. All four required Stata cells (the two actual-sample descriptive cells and both regression panels) then ran successfully against that repaired handoff under `20261103T054234305137Z`. Each returned code 0 and exported `.md`, `.rtf`, `.csv`, and `.tex`. After the design synchronization, the helper's `20261103T055250289892Z` execution record reused the unchanged, hash-verified construction and all four cells; their underlying fresh logs remain in the two run directories above. Final validation returned `valid=true`, two fit scopes, zero blocked scopes, and no errors or warnings. The native SAS, handoff, and Stata logs/listing were reviewed and contain no execution errors or warnings.

The most important unresolved choices are the paper's unspecified percentile population and annual/pooled cutoff order, the full set of variables meant by “all financial-statement variables,” exact book-equity and deflator dates after delisting, event window when no lead statement exists, and CRSP delisting codes. Attempt 2 has declared reproducible choices for each. The 12-case event-date repair does not explain the sample-size gap: it changes 11 future values and no cutoff, sample, or rank membership. The larger sample and coefficient differences remain unexplained by the available paper detail and provider vintage; they should not be attributed to a single cause.
