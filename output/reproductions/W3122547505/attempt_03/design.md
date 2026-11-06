# Design and implementation decisions

## Source and target

The original paper PDF controls over inherited extraction text. Equation (5) is on physical PDF p. 6 (printed p. 40): it regresses working-capital accrual changes in year *t* on past, current, and future operating cash flow, with an intercept. The accompanying text says the residual standard deviation is a firm-level accrual-quality measure and that higher values mean lower quality. The paper does not name the estimator; ordinary least squares (OLS) is used as a best-effort interpretation of “firm-level time-series regression.”

Table 1 and the sample discussion are on physical PDF pp. 7–8 (printed pp. 41–42). The paper names Compustat annual industrial and research files for 1987–1999, requires complete assets, earnings, operating cash flow, and receivables/inventory changes, trims the most extreme 1% of operating cash flow, earnings, and working-capital changes, then requires both leading and lagged cash flows and earnings. The prose on physical p. 8 is broader than Table 1's row label, which names only lead/lag cash from operations. Page 8 defines both constructed Earn (CFO + ΔWC) and Prof (Compustat item 123), and Table 2 includes Earn(t+1). For the firm-specific baseline, I follow the broader sample prose and require CFO and constructed Earn at t−1 and t+1; this source-based interpretation remains uncertain because Table 1 names CFO alone. The paper then requires at least eight usable annual observations per firm. Table 1 reports 59,360 initially available firm-years, 55,850 after trimming, 30,317 after the lead/lag screen, and 15,234 firm-years for 1,725 firms after the eight-observation screen. Those counts are comparison outcomes, not construction targets.

Table 3 Panel A is on physical PDF p. 10 (printed p. 44). Its target is the distribution across firm-specific estimates: mean, t-statistic, and lower quartile/median/upper quartile for each coefficient, plus the corresponding adjusted-R-squared distribution. The table note explicitly says the Panel A t-statistics are based on the distribution of the 1,725 firm-level coefficients. They are not pooled-regression statistics or averages of firm-specific t-statistics. The paper does not specify the individual-fit standard-error correction; none is needed for these cross-firm t-statistics.

## Local data and item mappings

The read-only source is `COMP.FUNDA` (`/storage/sas/base/comp/d_na/funda.sas7bdat`), the catalog-listed merged annual fundamentals file. Local candidate fields and labels were checked against the catalog. The current vintage is not confirmed to reproduce the paper’s historical Compustat population.

The 2004 S&P Research Insight North America Data Guide is the provider documentation in `git/output/reproduction_runs/reference_documents/compustat_research_insight_2004.pdf`; the relevant CURRTR entry extract is retained in `documentation/compustat_2004_p71.txt`. The guide identifies the paper’s legacy annual items as follows:

| Paper item | Provider mnemonic | Local `COMP.FUNDA` field | Provider evidence |
| --- | --- | --- | --- |
| 302, receivables decrease/(increase) | RECCH | `recch` | physical guide p. 875 |
| 303, inventory decrease/(increase) | INVCH | `invch` | physical guide p. 858 |
| 304, accounts payable and accrued liabilities increase/(decrease) | APALCH | `apalch` | physical guide p. 813 |
| 305, income taxes accrued increase/(decrease) | TXACH | `txach` | physical guide p. 851 |
| 307, assets and liabilities—other, net change | AOLOCH | `aoloch` | physical guide p. 818 |
| 308, operating activities—net cash flow | OANCF | `oancf` | physical guide p. 871 |
| 123, income before extraordinary items (cash flow/statement of changes) | IBC | `ibc` | physical guide p. 850 |

The signed working-capital measure follows the paper literally: `-(recch + invch + apalch + txach + aoloch)`. The provider definitions describe these as signed cash-flow statement changes. No sign is reversed a second time. Item 304 is AP and accrued liabilities, not AP alone. Item 307 maps to `aoloch`; the similarly named `uaoloch` is not substituted. Item 123 maps to `ibc` (income before extraordinary items, cash flow/statement of changes), not the local `ib` field. These mappings correct the inherited feasibility note’s uncertainty about the item-to-field crosswalk; they do not prove current-vintage equivalence.

The local merged annual file is restricted to `indfmt='INDL'`, `datafmt='STD'`, `consol='C'`, and `popsrc='D'` as a defensible local definition of the paper’s annual industrial/research population. The source does not report these modern merged-file codes; this population translation is best effort. Raw years 1985–2000 are retained to construct and scale the 1987–1999 outcome window. The analysis key is `gvkey` by `fyear`; duplicate firm-year records and field coverage are checked before any estimation, with no silent `NODUPKEY` resolution.

For currency, the local catalog labels `COMP.FUNDA.curcd` “ISO Currency Code.” The S&P Research Insight guide’s CURRTR entry (physical PDF p. 71; printed p. 21) says the rate is used to translate foreign-currency amounts to U.S. dollars and is the rate in effect at the balance-sheet date. It does not state whether to multiply or divide, nor how that rate should be applied to annual cash-flow items and a two-year average-assets denominator. I therefore do not infer CURRTR arithmetic. The build requires the two source `CURCD` values to be known and identical before it forms any average-assets denominator. Same-currency USD and non-USD observations remain eligible; a denominator spanning unlike or unknown currencies is unavailable. The raw source audit records CURRTR summaries but does not use CURRTR to alter amounts.

## Scaling, timing, and sample screens

The paper states on physical PDF p. 8 that all variables are scaled by average total assets, but it does not explicitly state the denominator date for the lagged and leading CFO terms. This implementation uses each cash-flow observation’s own fiscal-year average assets: `(at_s + at_(s−1))/2` for CFO in fiscal year *s*. Therefore the dependent change in working capital for year *t* and current CFO use the *t* denominator; CFO at *t−1* uses the *t−1* denominator; and CFO at *t+1* uses the *t+1* denominator. This is the natural variable-by-fiscal-year interpretation, but remains an assumption rather than a source-explicit denominator-date rule. Adjacent years are joined by exact `gvkey` and `fyear`; a gap does not count as a lag or lead. A nonpositive or missing average-assets denominator makes the scaled value unavailable. Currency consistency is checked within each denominator: `CURCD_t = CURCD_(t−1)` for the current outcome and CFO(t), `CURCD_(t−1) = CURCD_(t−2)` for CFO(t−1) and Earn(t−1), and `CURCD_(t+1) = CURCD_t` for CFO(t+1) and Earn(t+1). Thus each numerator and the assets used to scale it share one reported currency. The checks cover all supporting fiscal years 1986–2000, including the raw 1985/2000 asset records needed at the period boundaries. No conversion is attempted where CURCD differs or is missing.

The outcome-year sample remains 1987–1999, while source history is read from 1985–2000. At the 1987 boundary, scaling CFO(t−1) and Earn(t−1) by their own-year average assets reaches total assets in 1985. At the 1999 boundary, CFO(t+1) and Earn(t+1) use 2000 data. The paper describes the sampled outcomes as 1987–1999 and does not say that lead/lag data must lie within those years, so the baseline keeps t=1987 and t=1999 when adjacent source years are available. As a boundary diagnostic, restricting the outcome to t=1988–1998 (so all lead/lag observations also lie in 1987–1999) leaves 29,300 trimmed rows with currency-valid CFO and Earn available, before the eight-observation screen; the baseline does not impose that narrower window.

The sample screens follow the paper’s Table 1 order: (1) fiscal years 1987–1999 with complete current-year assets/scaling inputs, item-123 earnings, CFO, and all five signed working-capital change fields; (2) remove observations outside pooled 1st/99th percentile cutoffs for scaled CFO, item-123 earnings, and scaled change in working capital; (3) require scaled CFO and constructed Earn (CFO + ΔWC) at both *t−1* and *t+1*; and (4) retain firms with at least eight eligible regression observations. “Earnings” in the initial completeness and trimming screens is interpreted as item 123, which the variable definitions identify as Prof; the paper does not explicitly identify that field in the sample-selection paragraph or say whether the trim variable is Prof or constructed Earn. The lead/lag prose is interpreted as requiring constructed Earn because that is the paper's named earnings measure and Table 2 reports Earn(t+1); Table 1's explicit CFO-only row leaves the issue unresolved. These are best-effort interpretations. Percentiles are pooled over eligible 1987–1999 observations because the paper does not state year-specific cutoffs; SAS percentile interpolation defines the cutoff. Missing source fields are not filled with zero. Lead/lag values come from raw adjacent fiscal years; those neighboring years need not independently survive the current-year trims.

## Estimation, aggregation, and unresolved points

The fit is separately estimated by firm using OLS on each firm’s eligible 1987–1999 observations, with a minimum of eight rows. `asreg` is used directly for its established by-group regression and in-memory coefficient results. Firm coefficients and adjusted R-squared are then summarized across firms. Cross-firm t-statistics use the sample standard deviation of the firm estimates divided by the square root of the number of firms, with *N−1* degrees of freedom. No pooled model replaces this coefficient-distribution target. Stata exports the means and p-values using the template format; built-in `ttest` output in the ordinary log retains the paper-reported t statistics with N−1 degrees of freedom.

Unresolved differences include the current local Compustat vintage versus the historical research file, the modern population-code mapping, the precise earnings variable used for truncation, SAS’s percentile interpolation versus the authors’ unstated rule, the unstated estimator and lag/lead denominator dates, and the absence of documented CURRTR arithmetic direction for converting unlike-currency amounts. We will report the realized counts, distributions, and any missing/singular fits without tuning sample choices to match published Table 1 or Table 3 values.

## Execution comparison

The final read-only source scan contained 173,871 `COMP.FUNDA` rows for 1985–2000 and no duplicate `gvkey`–`fyear` keys. The local currency field was nonmissing on every row: 14,365 CAD and 159,506 USD. The 1987–1999 outcome window had 144,162 candidate rows. Of these, 85,486 had nonmissing assets, item-123 earnings, item-308 CFO, and items 302/303. Requiring all five signed working-capital inputs, a positive own-period average-assets denominator, and matching known CURCD for the current denominator yielded 51,955 complete model-input rows; pooled trimming left 49,853.

The currency audit of the raw auxiliary population checked every source-year average-assets pair from 1986 through 2000. The following table gives counts with exact same CURCD, different CURCD, a valid positive same-currency average-assets denominator, scaled CFO, and constructed Earn available. CFO and Earn counts also require their corresponding raw cash-flow inputs.

| Fiscal year scaled | Same CURCD | Different CURCD | Valid average assets | CFO available | Earn available |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1986 | 8,084 | 5 | 7,162 | 0 | 0 |
| 1987 | 8,491 | 7 | 7,513 | 1,176 | 583 |
| 1988 | 8,607 | 8 | 7,472 | 6,175 | 3,503 |
| 1989 | 8,723 | 5 | 7,374 | 6,500 | 3,718 |
| 1990 | 8,847 | 6 | 7,330 | 6,501 | 3,690 |
| 1991 | 9,126 | 3 | 7,420 | 6,636 | 3,754 |
| 1992 | 9,580 | 11 | 7,624 | 6,879 | 3,840 |
| 1993 | 10,322 | 8 | 8,044 | 7,298 | 4,091 |
| 1994 | 10,881 | 11 | 9,087 | 7,718 | 4,264 |
| 1995 | 11,206 | 15 | 9,476 | 8,209 | 4,422 |
| 1996 | 11,835 | 14 | 10,456 | 9,203 | 4,971 |
| 1997 | 11,825 | 18 | 10,489 | 9,237 | 5,002 |
| 1998 | 11,404 | 13 | 10,060 | 8,942 | 4,805 |
| 1999 | 11,487 | 24 | 10,467 | 9,635 | 5,314 |
| 2000 | 11,339 | 9 | 10,461 | 9,534 | 5,183 |

Matched raw firm-year pairs with missing CURCD were zero; gaps in the annual key are counted separately in the SAS log. Over the full outcome-year candidate population, current t/t−1, past t−1/t−2, and future t+1/t currency mismatches numbered 143, 107, and 145, respectively. These are period-level construction diagnostics, not extra sample screens applied to unrelated amounts. Within the trimmed current sample, the explicit CFO+Earn lead/lag screen retained 32,357 rows across 7,127 firms before the minimum-eight-year requirement; the corresponding CFO-only and CFO+Prof diagnostics retained 37,957 and 37,937 rows. After the eight-year screen, 14,346 firm-years for 1,465 firms remain, with fit lengths of 8 years for 366 firms, 9 for 260, 10 for 248, 11 for 494, and 12 for 97. There are no eligible 1987 outcome rows and 1,004 eligible 1999 rows. Restricting the outcome window to 1988–1998 leaves 12,124 firm-years for 1,291 firms after the eight-year screen.

CURRTR was summarized but not used as a conversion factor. In this source vintage, its observed range was 1.0000–2.5566 for CAD-coded rows and 0.000101698–1.6995 for USD-coded rows. The latter varies even though the guide says the rate is 1.000 when a foreign company reports in U.S. dollars. Alongside the missing arithmetic direction in the provider description, this makes the local field unsuitable as a guessed conversion instruction. The final model sample preserves same-currency observations: 89 CAD firm-years for 10 firms and 14,257 USD firm-years for 1,456 firms; all three checked neighboring CURCD pairs match within every retained observation.

Table 1 reports 59,360, 55,850, 30,317, and 15,234 observations for 1,725 firms (physical PDF pp. 7–8); its footnote reports 481, 1,054, and 190 firms with 8, 9, and 10 observations. The final local fit sample remains below those reported totals. Item 304, 305, and 307 are missing in 65,633, 63,592, and 40,923 of the 144,162 outcome-window rows, respectively; these counts overlap. The local vintage/population and source-field coverage do not isolate a single explanation for the remaining discrepancy, and no sample choice was changed to target the published counts.

For the 1,465 fits, all four coefficient means have two-sided p-values below 0.001, based on 1,464 degrees of freedom. `asreg` estimates one regression per firm; the cell keeps one result per fitted firm, uses native `mean` and `ttest`, and summarizes coefficient and adjusted-R-squared distributions with `estpost tabstat`. Table 3 Panel A reports coefficient means/t-statistics at two decimals. The A3 cross-firm results are:

| Statistic | A3 mean | A3 t | Table 3 mean | Table 3 t |
| --- | ---: | ---: | ---: | ---: |
| Intercept | 0.031 | 14.56 | 0.04 | 23.03 |
| CFO(t−1) | 0.143 | 17.50 | 0.17 | 19.38 |
| CFO(t) | −0.548 | −47.66 | −0.62 | −57.06 |
| CFO(t+1) | 0.122 | 14.29 | 0.09 | 10.38 |
| Adjusted R-squared mean | 0.447 | — | 0.47 | — |

Local coefficient means, quartiles, and adjusted-R-squared distribution are in regression coefficient units. The A3 coefficient lower quartile/median/upper quartile are −0.004/0.027/0.069 for the intercept, −0.023/0.118/0.308 for CFO(t−1), −0.834/−0.569/−0.270 for CFO(t), and −0.057/0.118/0.293 for CFO(t+1). Adjusted-R-squared quartiles are 0.185/0.523/0.751, versus 0.23/0.55/0.80 in the paper. The two-sided p-values in the template export are shown as 0.000; the native tests show all four p-values below 0.001. The paper supplies t-statistics but does not state a one-sided alternative. Table outputs in `.md`, `.rtf`, `.csv`, and `.tex` formats are under `tables/`; the ordinary native logs are under `runtime/`.
