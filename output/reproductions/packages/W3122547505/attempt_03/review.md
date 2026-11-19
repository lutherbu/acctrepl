# Independent review: W3122547505, attempt 03

## Scope and source checks

Reviewed the only assigned scope: Equation (5) and Table 3 Panel A, the firm-specific regression of ΔWC_t on CFO_(t−1), CFO_t, and CFO_(t+1). The source pages checked include physical PDF p. 8 (printed p. 42) for the signed ΔWC item formula, Earn = CFO + ΔWC, Prof/item 123, and the statement that all variables are scaled by average total assets; physical PDF p. 10 (printed p. 44) for Table 3 Panel A and its coefficient-distribution t-statistic note. The paper does not specify the denominator date for lagged and leading CFO, so A3 preserves A2's own-CFO-year average-assets assumption. It also preserves A2's broader p. 8 prose reading that past and future CFO and Earn must be available, Prof/item 123 for the current earnings trimming input, the 1987–1999 outcome window with 1986/2000 supporting history, and pooled 1st/99th percentile trimming. The Table 1 lead/lag row names CFO alone; that source ambiguity remains.

The source and local field crosswalk is unchanged from A2: the signed working-capital item construction uses `recch`, `invch`, `apalch`, `txach`, and `aoloch`; CFO is `oancf`; item 123 is `ibc`. The frozen work item, implementation rules, assigned Stata template, predecessor A2 code/review, local catalog entry for `COMP.FUNDA`, and original paper were checked. The local catalog labels `curcd` as “ISO Currency Code” and `currtr` as “Currency Translation Rate.” The 2004 S&P Research Insight guide's CURRTR entry (physical PDF p. 71, printed p. 21; screenshot and text extract are retained under `scratch/` and `documentation/`) says the rate is used to translate foreign-currency amounts into U.S. dollars and is the rate in effect at the balance-sheet date. It does not say whether to multiply or divide, or how to apply the rate to these annual flow amounts and adjacent-year asset denominators.

## Currency repair

A2 did not retain or compare currency codes before averaging assets. The coordinator's handoff audit found four invalid adjacent currency pairs among its 14,350 retained firm-years: one t/t−1 pair, two t−1/t−2 pairs, and one t/t+1 pair. The final A3 construction now forms each average-assets denominator only when both assets have known, identical CURCD. It checks the current denominator (t and t−1), the past CFO/Earn denominator (t−1 and t−2), and the future CFO/Earn denominator (t+1 and t). It uses exact `gvkey`/`fyear` joins and carries the adjacent CURCDs into the final handoff for inspection. A mismatched or unknown currency makes that scaled construction unavailable; no unlike-currency sum or average is formed. Same-currency USD and CAD records remain eligible.

The check covers raw auxiliary years beyond the final fit sample. The filtered source had 173,871 rows from 1985–2000, with 14,365 CAD and 159,506 USD records and no missing CURCD. For each scale year 1986–2000, the SAS log reports the same-CURCD and mismatched pairs, valid average-assets denominators, and available scaled CFO and Earn; the complete 15-year table is in `design.md` and `runtime/20261102T162826914614Z/build.lst`. Within the 144,162 outcome-year candidates, mismatches numbered 143 for t/t−1, 107 for t−1/t−2, and 145 for t+1/t. In the retained A3 sample, all three pairs match for all 14,346 rows. It includes 14,257 USD firm-years for 1,456 firms and 89 CAD firm-years for 10 firms.

CURRTR was not used to convert any values. Its local range was 1.0000–2.5566 for CAD-coded records and 0.000101698–1.6995 for USD-coded records; the latter is not consistent with treating every local value as an obvious conversion factor. Together with the source's missing arithmetic direction, this is not enough evidence to choose a conversion formula. The repair therefore leaves unlike-currency denominators unavailable and records this as a construction limitation.

## Construction and sample results

All other A2 sample and estimation choices remain in place. The currency rule reduces current complete inputs from A2's 52,015 to 51,955 firm-years; after current-variable trimming, the count is 49,853 versus A2's 49,907. The CFO+Earn lead/lag screen retains 32,357 firm-years for 7,127 firms before the minimum-eight-observation filter, compared with A2's 32,428. The final fit sample is 14,346 firm-years for 1,465 firms, four fewer rows than A2 with the same number of fitted firms. The observed per-firm fit-length distribution changes from A2's 364/261/248/495/97 firms at 8/9/10/11/12 years to A3's 366/260/248/494/97. Thus every retained firm still has 8–12 observations; no fit was capped or omitted. The published target remains 15,234 firm-years for 1,725 firms. The current local missingness and population-vintage differences remain unresolved; the published count was not used as a screen.

The SAS handoff reports 14,346 unique `gvkey`–`fyear` keys. The final Stata cell uses native `asreg` with `minimum(8)`, keeps one record per firm, reports native `mean` and one-sample `ttest` results, and exports the cross-firm mean/p table and coefficient/adjusted-R-squared descriptive table in `.md`, `.rtf`, `.csv`, and `.tex`. All 1,465 firm estimates have nonmissing coefficients and adjusted R-squared. The Stata cell returned 0; its log and all eight table files are retained under `runtime/` and `tables/`.

## Results and comparison

Mean coefficients are in regression coefficient units. All cross-firm tests have N=1,465 and 1,464 degrees of freedom. A2 and A3 means match at three decimals, and all four two-sided p-values remain below 0.001; the template output shows `0.000` after rounding. Native test statistics and the published Table 3 Panel A values compare as follows:

| Statistic | A2 mean | A2 t | A3 mean | A3 t | Published mean | Published t |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Intercept | 0.030543 | 14.4998 | 0.0306623 | 14.5600 | 0.04 | 23.03 |
| CFO(t−1) | 0.1429617 | 17.4765 | 0.1431706 | 17.5007 | 0.17 | 19.38 |
| CFO(t) | −0.5477646 | −47.6361 | −0.5478894 | −47.6562 | −0.62 | −57.06 |
| CFO(t+1) | 0.1221412 | 14.2776 | 0.1222322 | 14.2894 | 0.09 | 10.38 |
| Mean adjusted R-squared | 0.4467695 | — | 0.4471583 | — | 0.47 | — |

The A3 three-decimal coefficient and adjusted-R-squared means remain 0.031, 0.143, −0.548, 0.122, and 0.447. Distributional changes are small: the reported upper quartile changes from 0.307 to 0.308 for CFO(t−1), −0.269 to −0.270 for CFO(t), the median for CFO(t+1) changes from 0.117 to 0.118, and the adjusted-R-squared lower quartile changes from 0.184 to 0.185. The other coefficient distribution cells are unchanged at three decimals. A3's adjusted-R-squared quartiles are 0.185/0.523/0.751; Table 3 reports 0.23/0.55/0.80. The local intercept, lagged-CFO, and current-CFO t-statistics remain smaller in magnitude than the published statistics; the future-CFO t-statistic remains larger. The paper reports the t-statistics without a stated one-sided alternative; A3 preserves the template's two-sided p-values and the native t-statistics.

## Execution record and limits

The initial A3 SAS execution stopped at a diagnostic variable name longer than SAS's 32-character limit. That log is preserved. The diagnostic names were shortened, the exact SAS runner was resynced, and the final native SAS build and Stata handoff completed successfully; no model or sample choice changed in that repair. The final SAS log has only the site warning that `VALIDVARNAME` is restricted, with no execution error.

The correction does not resolve the paper's silent CURRTR arithmetic direction, the Compustat vintage or historical population mapping, the denominator date for lead/lag CFO, which earnings series is used in trimming and the broad prose screen, or the individual-fit estimator. These limits are explicit in the source discussion and `design.md`. A3 reproduces the assigned runnable scope and documents the observed differences; it does not claim an exact historical sample match.
