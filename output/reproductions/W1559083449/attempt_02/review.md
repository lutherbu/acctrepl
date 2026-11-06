# Independent review — attempt 2

## Scope and disposition

Reviewed the retained Table 2, Model 3 pooled regression for the one-year-ahead change in RNOA. I checked the original PDF, the predecessor SAS construction and Stata cells, the predecessor native logs/listing and exports, and the two focus notes for this paper. I found no demonstrated defect that warrants changing the construction or model. The A2 construction code, design, declared sample, and Stata cells match A1. The helper verified and reused A1’s SAS handoff files; A2 then ran the Stata cells in a fresh process. This preserves the existing construction evidence while providing A2-specific estimation and export records.

## Source definitions and implementation checks

- Physical PDF p. 4 defines operating income after depreciation and describes the operating expense components; p. 5 defines RNOA, ATO, PM, average NOA, NOA growth, and the decomposition identity. The implementation uses `OIADP` for operating income and does not subtract R&D a second time. It calculates `NOA=(AT−CHE)−(LT−DLTT−DLC)`, then average NOA as `(NOA_t+NOA_(t−1))/2`; RNOA=`OIADP/average NOA`, ATO=`SALE/average NOA`, and PM=`OIADP/SALE`.
- Physical PDF p. 5 first writes the decomposition in raw changes and then identifies the table predictors as lag-weighted changes: weighted ΔATO=`(ATO_t−ATO_(t−1))*PM_(t−1)` and weighted ΔPM=`(PM_t−PM_(t−1))*ATO_(t−1)`. The interaction is the product of the two raw changes. The code follows that identity; it does not multiply the weighted predictors together.
- Physical PDF p. 6 states the nonfinancial SIC restriction, nonnegative prior PM requirement, the current-period limits (`|RNOA_t|≤1` and absolute current ΔRNOA, weighted ΔATO, and weighted ΔPM no greater than 0.5), and the additional in-sample `|ΔRNOA_(t+1)|≤0.5` limit. Those limits appear in the construction. There is no added positive-NOA rule or direct growth-in-NOA trim.
- Physical PDF p. 6 describes the Table 2 estimation period as 1978–1986. The Table 2 caption on physical p. 8 prints 1976–1986. The code uses the body period and retains the conflict in `design.md` and the sample declaration.
- The time alignment uses keyed fiscal-year joins, keeps FY(t−2) for the lagged average-NOA measures and FY(t+1) for the future outcome, and requires strictly increasing actual dates. The source row selection resolves the two duplicate GVKEY/FYEAR keys only where one row has a unique maximum completeness score across the selected fields; tied maxima stop the build.
- The industry screen uses current-role `SICH` where positive and a dated CCM-to-MSENAMES SIC fallback when it is missing or zero. The join applies the effective link/name dates and treats open end dates as open. Unknown classification is counted and excluded; header SIC is not substituted. Direct Compustat/CRSP disagreements are counted while the direct Compustat value is retained. No additional industry screen is applied to lagged accounting history.
- `CURCD` is required and stable over t−2 through t+1 to maintain common units across ratios and changes. This guard is not in the paper; it excludes 27 of 54,389 joined periods. Stable USD and CAD periods are both retained. The remaining uncertainty from this paper-unspecified guard is disclosed rather than resolved by an assumed currency conversion.

## Construction evidence and actual sample

The predecessor SAS build completed with return code 0, and its handoff log imports the SAS dataset, asserts a nonempty sample and unique `(gvkey,t_year)` key, then saves `reg.dta`. The listing shows 91,914 filtered FUNDA rows and 91,912 rows after duplicate resolution. The two duplicated keys are GVKEY 006557 in FY1982 and FY1983: the August CAD rows each have 11 of 12 selected fields observed, versus 4 for the December USD companions. Both maxima are unique and no duplicate key remains.

For t=1978–1986, the joined history contains 54,389 firm-years; the actual dates are ordered for all of them. Currency is stable for 54,362. Historical SICH is absent/zero for all joined observations in 1978–1981, so the dated fallback matters: it resolves 3,440 observations in 1978, leaving 2,557 unclassified; in 1986, 4,732 unique dated CRSP SIC fallbacks are available, with 1,832 still unclassified. There are no multicode candidate conflicts in any year; the 58–79 annual Compustat-versus-CRSP disagreements from 1982–1986 are counted and direct SICH is kept.

The final analysis sample is 23,425 observations across 4,654 firms and nine fiscal years. Native SAS counts by t are 2,696 (1978), 2,711 (1979), 2,671 (1980), 2,629 (1981), 2,641 (1982), 2,430 (1983), 2,563 (1984), 2,579 (1985), and 2,505 (1986). The row-level decomposition check covered 48,989 complete constructions: maximum absolute residual was 2 at extreme scales, maximum scaled relative residual was 2.4543e−15, and no relative failures occurred. The five rows with absolute residual above 1e−10 have near-zero NOA denominators and fail the stated current and future tail screens. This is floating-point cancellation at extreme scale, not a reason to add an exclusion.

## Table 2 Model 3 comparison

All coefficients are in the source’s ratio/growth units. The current estimates and two-sided p-values are from the A2 native Stata regression log; source estimates and t-statistics are transcribed from Table 2 on physical PDF p. 8. The paper prints t-statistics, not p-values, and does not state the covariance estimator.

| Term | A2 coefficient | A2 t-statistic (two-sided p) | Source coefficient | Source t-statistic |
| --- | ---: | ---: | ---: | ---: |
| Intercept | 0.0155 | 12.51 (<0.001) | 0.0247 | 14.53 |
| RNOA_t | −0.1752 | −35.14 (<0.001) | −0.1403 | −20.71 |
| ΔNOA_t | −0.0001 | −0.74 (0.458) | −0.0671 | −15.83 |
| Weighted ΔATO_t | 0.2803 | 19.15 (<0.001) | 0.1799 | 8.08 |
| Weighted ΔPM_t | −0.0068 | −0.70 (0.485) | 0.0042 | 0.28 |
| Raw ΔATO_t × raw ΔPM_t | 0.0037 | 0.12 (0.905) | 0.1349 | 2.47 |

The A2 sample size is 23,425 versus the source’s 9,147, and R² is 0.0756 (adjusted R² 0.0754) versus the source R² of 0.1082. Weighted ΔATO is positive and significant in both runs, while ΔPM is insignificant in both. The source’s positive, significant interaction does not reproduce: A2’s interaction estimate is small and insignificant. A2’s NOA-growth estimate is also close to zero and insignificant, unlike the source estimate. The source’s pooled estimator and error procedure are unspecified; A2 uses pooled OLS with conventional standard errors as a best-effort interpretation. A2 exports two-sided p-values per the template, while the source reports signed t-statistics and does not identify a one- or two-sided convention.

The source Table 1 reports N=23,674 for the broader 1978–1996 descriptive population, which includes both training and out-of-sample periods; it is not a like-for-like target for the Table 2 training regression. A2’s analysis-sample descriptives are exported separately. They show 23,425 observations per variable; growth in NOA has mean 0.2163, SD 4.4807, median 0.1008, p99 1.7403, and max 678.5299. This tail remains because the paper states no direct ΔNOA cutoff. It is not winsorized or trimmed here.

I cannot attribute the 14,278-observation difference to one cause from the available evidence. The implementation uses the specified filters and historical dated classification, but the unresolved classification rows, the additional currency-coherence guard, differences in the historical Compustat population/vintage, and other source-specific selection details remain possible contributors. The diagnostics do not establish which of these explains the gap, so no further filter was introduced to force agreement.

## A2 execution record

- SAS data: reused unchanged from A1 after the helper verified the handoff files. Source execution ID: `20261103T050748255897Z`; SAS and Stata handoff both succeeded. Data hashes are `reg.sas7bdat` `8f6f08c4e9a2f9286beb23f019ef67187b8f4c156c7cfe0c4827bbb879f33ed0` and `reg.dta` `50e93259995d08e09cdc101c9c363633926b2d05c4c78895794f4c6570056c89`.
- Fresh A2 Stata execution ID: `20261103T053202312321Z`. Cells `model3_table2` and `model3_descriptives` both returned 0. Regression exports and descriptive exports were produced in `.md`, `.rtf`, `.csv`, and `.tex`; their output hashes match the independently reviewed A1 exports. The Stata logs show N, year counts, regression estimates/t-statistics, and actual-sample descriptive statistics. No model metadata or coefficient dataset was added.
- The canonical template and A2 frozen template snapshot have the same SHA-256 (`f4040fb37a00a792e88e984fe692f0f280d20866b1d6f2d9572dda4a9a65ebcb`). The regression cell uses the template’s required coefficient/star and parenthesized p-value export settings; the second cell exports actual-sample descriptives.

No fit is blocked. Remaining material limitations are the source period conflict, unspecified pooled inference procedure, current-sample discrepancy, unresolved historical SIC exclusions, and the paper-unspecified currency guard.
