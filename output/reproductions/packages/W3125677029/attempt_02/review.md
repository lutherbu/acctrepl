# Review and repair: W3125677029, attempt 02

## Evidence checked

I read the assigned frozen work item, the reproduction instructions and Stata template, the predecessor's `build.sas`, generated tables and runtime logs, and the original paper PDF. I checked physical PDF pages 6–10, 11, 13–15 (printed pages 762–766, 767, 769–771) and the cited pages in the cached 2004 S&P Research Insight guide. The sample is annual nonfinancial Compustat observations with the variables needed for the reported metrics and at least eight observations per two-digit SIC-year group (paper p. 6). The paper's 1% winsorization appears on p. 13 as an outlier sensitivity analysis; it is not the baseline Table 2 Panel A specification.

## Repairs and construction audit

Attempt 02 preserves the frozen model/result IDs and the predecessor's seven-scope OLS cell. I confirmed the constructions against the original equations: Equations (1), (4), (7), and (9) use `1/Assets_(t−1)` as their scaled constant and contain no free intercept (paper pp. 7, 9–10). `PROC REG` therefore uses `/ noint`. The Jones prediction applies the receivables adjustment in Equation (2), separate from the Equation (1) fit. CFO is `OANCF−XIDOC`, and total accruals are `IBC−CFO` (paper pp. 7–8; legacy items 123, 124, and 308). The current fields were checked against the provider index/guide; the guide labels AT (item A6) in millions of dollars and CURRTR (A228) as a period-end foreign-currency-to-USD rate.

I repaired a demonstrated unit-validity defect in attempt 01. The predecessor subtracted period amounts and divided current amounts by prior assets without checking the source `CURCD`. Those operations combine unlike units when a firm's reported currency changes. Attempt 02 leaves cross-period amounts unavailable unless `CURCD_t=CURCD_(t−1)` for current-to-prior changes and current amounts scaled by prior assets. For Equation (7)'s lagged sales change it also requires `CURCD_(t−1)=CURCD_(t−2)`. I use the same-currency rule rather than convert with CURRTR because the paper gives no currency-conversion procedure. The rule is exact and does not use an outcome or magnitude cutoff.

The pre-currency, common complete-case candidate had 93,719 firm-years and 13,201 firms across 983 eligible SIC-year cells. It contained 103 current/t−1 currency mismatches and 108 t−1/t−2 mismatches, with no overlap. Across raw equation-complete inputs, current/t−1 mismatches affected 141 Jones, 150 CFO, 160 production, and 154 discretionary-expense rows; 159 production-complete rows with matching current/t−1 codes had a t−1/t−2 mismatch. After applying the rule, the final sample has 93,508 firm-years and 13,192 firms across the same 983 eligible cells (minimum cell size 8). Every included row has matched current/t−1 codes; every included production residual has matched t−1/t−2 codes. Final keys remain unique.

The auxiliary equations use their own complete-case firm-year support, with at least eight observations per SIC-year before fitting. The paper requires the final sample observations to have fields for all proxies, but does not state that every supporting equation must be estimated on the intersection of all proxy fields. Its methodology instead describes separate cross-sectional fits by SIC-year (pp. 7, 9–10). I retain equation-specific fit populations, then form the common outcome sample and reapply the eight-observation rule. After the currency repair, support rows/groups are: Jones 121,198/1,024; CFO 122,092/1,024; production 119,477/1,039; discretionary expenses 112,792/1,034. Each fit produced a complete parameter row; there were zero groups with missing required coefficients and no SAS warnings. The final sample has zero duplicate GVKEY-FYEAR keys.

The directional DA measures remain sign-restricted: Positive DA is available only for DA>0 and Negative DA only for DA<0. Their final N values sum to the common sample N. Table 1's positive 25th percentile and negative 75th percentile are strictly nonzero, and the published Table 2 coefficients would not satisfy the coefficient identity implied by zero-coding both measures on the same common sample. RM PROXY remains `z(R CFO)+z(R PROD)+z(R DISX)` with all three source signs preserved; the definition on p. 10 and positive correlations with each component in Table 2 Panel B (p. 15) support that construction.

## Sample, missingness, and tail diagnostics

The final analysis sample is larger than the paper's reported full sample by 6,291 firm-years (93,508 versus 87,217) and 5,035 firms (13,192 versus 8,157). Table 2 Panel A does not report model-specific N. The local source is the current `COMP.FUNDA` vintage with standard annual industrial/domestic/consolidated filters, valid historical SIC, nonfinancial SIC ranges, and exact GVKEY/FYEAR offset joins. The source had zero duplicate filtered GVKEY-FYEAR keys. Equation-specific missing fields reduce support before the common outcome intersection; the final outcome rows have no missing target variables. The paper's count difference is not attributed to vintage effects: exact historical universe/screen differences remain unresolved.

All retained lagged-asset denominators are positive and nonmissing. The minimum is 0.001 source units, the 1st percentile is 0.183, and the median is 82.47. (The provider guide labels AT in millions of dollars, with `CURCD` identifying the currency.) There are 3,064 observations with prior assets below one source unit (3.28% of the sample); their mean/SD of ABS DA are 27.43/213.61, compared with 0.524/2.94 for the other observations. The untrimmed upper 1% rank bucket (935 observations) contributes 70.28% of total absolute DA and 99.90% of squared DA; the analogous squared-magnitude shares are 99.46% for R CFO, 99.16% for R PROD, 99.56% for R DISX, and 99.12% for RM PROXY. `P99(|DA|)` is 13.01 and the maximum is 7,168.86. The largest yearly extremes occur in 1998–2005, including the maxima for ABS DA in 2004 and R DISX in 2005. Currency-screening changed N by 211 and left these tail diagnostics materially unchanged. These aggregates show that very small denominators and extreme tails dominate moments and fit variation; they do not establish that the records are invalid. I apply no asset threshold, trimming, or winsorization because the paper gives no such primary-sample rule.

## Table 2 Panel A results

The source reports coefficient estimates to three decimals and stars, with adjusted R-squared, but no model-specific N, standard errors, or exact p-values. The paper's stars denote 10%, 5%, and 1% levels, but it does not state whether its tests are one- or two-sided. Attempt 02 uses unweighted OLS with conventional standard errors as a best-effort estimator, reports two-sided p-values, and uses the same star cutoffs; exact star comparisons therefore retain this one-/two-sided uncertainty. Continuous earnings measures are ratios to lagged assets reported as decimals (e.g. 0.11 is 11%); the trend slope is per fiscal-year step and SCA/SOX coefficients are level shifts. RM PROXY is a sum of standardized measures.

| Outcome | A2 N | Published (a, b, c, d) | A2 (a; b, c, d), two-sided p-values | Adjusted R², paper / A2 |
|---|---:|---|---|---:|
| ABS DA | 93,508 | (.053***, .003***, .027***, −.015***) | −.255 (.460); .085 (.056); .500 (.311); 3.327 (<.001) | .024 / .002 |
| Positive DA | 49,573 | (.028***, .002***, .026***, −.019**) | −.313 (.443); .097 (.061); .153 (.779); 3.288 (<.001) | .029 / .003 |
| Negative DA | 43,935 | (−.040***, −.003***, −.012***, .006***) | .183 (.747); −.071 (.343); −1.003 (.256); −3.381 (<.001) | .015 / .001 |
| R PROD | 93,508 | (−.040***, −.002, .008, .032***) | −.026 (.439); −.006 (.199); .000 (.992); −.266 (<.001) | .009 / .001 |
| R CFO | 93,508 | (.022***, −.003**, −.007***, .007**) | −.006 (.934); .003 (.693); .057 (.554); −.326 (.002) | .007 / .000 |
| R DISX | 93,508 | (.028***, .005***, .008***, −.011***) | .076 (.745); −.012 (.686); .186 (.576); .872 (.014) | .010 / .000 |
| RM PROXY | 93,508 | (−.018***, −.005**, .033**, .041***) | .031 (.017); −.001 (.378); .015 (.428); −.080 (<.001) | .011 / .001 |

Here `b` is Time, `c` is SCA, and `d` is SOX. Every A2 SOX estimate has the opposite sign to its published counterpart. Other estimates also differ in size/significance; no Table 2 row is numerically close at the displayed precision. A2 conventional two-sided significance is weaker than the paper's stars for the Time and SCA effects, while large opposite-sign SOX effects are highly significant. These are unreconciled results, not grounds to change samples or transformations.

Table 1 Panel A supplies descriptive benchmarks for the same seven outcomes. The table below compares its mean, standard deviation, median, and 75th percentile with the final A2 common sample; Positive/Negative DA use their sign-specific observations.

| Outcome | Paper (mean, SD, median, p75) | A2 (mean, SD, median, p75) |
|---|---|---|
| DA (construction check) | (0.00, 0.20, 0.00, 0.05) | (0.132, 39.089, 0.008, 0.114) |
| ABS DA | (0.11, 0.17, 0.06, 0.12) | (1.406, 39.064, 0.097, 0.265) |
| Positive DA | (0.09, 0.09, 0.06, 0.11) | (1.450, 32.720, 0.102, 0.304) |
| Negative DA | (−0.05, 0.18, −0.02, −0.01) | (−1.355, 45.165, −0.091, −0.035) |
| R CFO | (−0.02, 0.35, 0.01, 0.08) | (−0.039, 7.662, 0.015, 0.110) |
| R PROD | (−0.06, 0.31, 0.04, 0.06) | (−0.141, 3.796, −0.051, 0.061) |
| R DISX | (0.08, 0.58, 0.01, 0.18) | (0.177, 26.361, 0.025, 0.244) |
| RM PROXY | (0.01, 0.35, −0.01, 0.06) | (0.000, 1.465, 0.023, 0.051) |

The central real-activity percentiles are closer than the means/standard deviations, which are highly tail-sensitive. RM PROXY's full-sample z-score sum has SD 1.465 versus the paper's reported 0.35; the source does not identify the standardization population or any further scaling, so this remains unresolved.

## Execution and remaining limits

The assigned Stata cell executed successfully for all seven scopes after the currency repair. The four template exports are present: `tables/table2_panel_a.md`, `.rtf`, `.csv`, and `.tex`. No scopes are blocked. Remaining limits are the unexplained sample-count gap, outcome and trend-coefficient discrepancies, exact RM PROXY scaling, the unspecified Table 2 estimator/standard-error procedure, and use of a current Compustat vintage.
