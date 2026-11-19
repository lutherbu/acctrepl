# W1559083449: Table 2, Model 3

## Scope and period

The retained fit is the paper’s pooled in-sample regression for the one-year-ahead change in RNOA (Table 2, Model 3). The paper’s prose says the Table 2 regressions use 1978–1986 observations (physical PDF p. 6; printed p. 376); the Table 2 caption says 1976–1986 (physical PDF p. 8; printed p. 378). I implement the body-described 1978–1986 period and report the caption conflict. The paper’s 9,147 observations are a comparison point, not a fixed-size target. No additional models or out-of-sample forecasts are part of this attempt.

## Source fields and constructions

The sources are the catalog-listed COMP.FUNDA, CRSP.CCMXPF_LINKTABLE, and CRSP.MSENAMES files. Compustat annual rows are restricted to INDFMT=INDL, DATAFMT=STD, POPSRC=D, and CONSOL=C. Selected fields are GVKEY, DATADATE, FYEAR, FYR, SICH, CURCD, CURNCD, AT, CHE, LT, DLTT, DLC, OIADP, and SALE. The catalog labels CURCD as ISO Currency Code and CURNCD as Native Currency Code, so CURCD governs accounting-data units. Historical SICH is used when positive. Missing or zero SICH is treated as unavailable. For those dates, I use CRSP MSENAMES.SICCD matched at the actual Compustat DATADATE through effective CCM link intervals. Candidate links require LINKTYPE LC or LU, LINKPRIM P or C, and a positive LPERMNO; .E and other missing LINKENDDT values are treated as open-ended. The MSENAMES match uses SICCD and its NAMEDT/NAMEENDT interval, never header HSICCD. Only a unique positive SIC across all qualifying candidates supplies the fallback. Multiple SIC codes are treated as a conflict; no unique fallback remains unclassified. This uses no current company header SIC. The date/effectivity definitions and link codes are documented in the provider guides (CRSP/Compustat Merged Database Guide, physical PDF pp. 8–9, 21, 23; CRSP Stock and Index Data Descriptions Guide, physical PDF pp. 85–86, 125).

Net operating assets are NOA=(AT−CHE)−(LT−DLTT−DLC), following the assets/liabilities definition and Table 1 (physical PDF pp. 4–5; printed pp. 374–375). Average NOA in year t is (NOA_t+NOA_(t−1))/2. RNOA is OIADP/average NOA, ATO is SALE/average NOA, and PM is OIADP/SALE (physical PDF p. 5; printed p. 375). The profitability numerator is annual Compustat OIADP, Operating Income After Depreciation (Research Insight North America Data Guide, physical PDF p. 266 / printed p. 216, annual item A178). The guide describes the item as operating income after COGS, SG&A, and depreciation; its adjacent expense definitions place R&D and bad debt within the operating expense components (physical PDF pp. 267–268 / printed pp. 217–218). I therefore do not subtract R&D or bad-debt expense again. SALE is net sales, which is the numerator for ATO and denominator for PM.

The predictor definitions follow the algebra on physical PDF p. 5 (printed p. 375): ΔNOA_t=(NOA_t−NOA_(t−1))/NOA_(t−1); weighted ΔATO_t=(ATO_t−ATO_(t−1))*PM_(t−1); weighted ΔPM_t=(PM_t−PM_(t−1))*ATO_(t−1); and ΔINT_t=(ATO_t−ATO_(t−1))*(PM_t−PM_(t−1)). The interaction uses raw changes, not the product of the weighted regressors. The identity ΔRNOA_t=weighted ΔATO_t+weighted ΔPM_t+ΔINT_t is checked row by row before the handoff. There is no positive-NOA screen. Zero denominators make the relevant derived measure unavailable; missing source values remain missing.

## Temporal alignment, currency, and screens

I join annual records by GVKEY and exact FYEAR offsets, never row order. The current year t is 1978–1986. The required history starts at FY1976 because lagged RNOA_(t−1) and ATO_(t−1) use average NOA and therefore FY(t−2) balances. The future endpoint is FY1987; its source DATADATE is retained even when it falls in calendar 1988. Actual dates must be strictly increasing across FY(t−2), FY(t−1), FY(t), and FY(t+1).

All monetary values in the ratios, averages, and changes must use comparable units. I require a nonmissing, unchanged Compustat CURCD across t−2 through t+1, which allows stable non-USD currencies and avoids treating the native currency CURNCD as a rate-table intermediary. This is a unit-coherence construction guard, not a paper-reported sample screen. I do not convert currency in this reconstruction. Observations with missing or changing reporting currency cannot be combined without a verified date-specific conversion and are omitted; the native run reports this attrition.

Using the build focus for this retained baseline and the source screens on physical PDF p. 6 (printed p. 376), I exclude historical SIC 6000–6999, negative PM_(t−1), and observations beyond the time-t cutoffs |RNOA_t|≤1, |ΔRNOA_t|≤0.5, |weighted ΔATO_t|≤0.5, and |weighted ΔPM_t|≤0.5, plus the in-sample forecast-outcome cutoff |ΔRNOA_(t+1)|≤0.5. Rows with unresolved historical SIC after the dated fallback are excluded because their financial-industry status cannot be established; the code reports direct coverage, fallback coverage, conflicting candidates, and disagreements where both sources give a unique code. Required model variables must be complete for the final regression.

The construction checks canonical row uniqueness by GVKEY/FYEAR, date ordering, currency continuity, sample counts by year and attrition stage, and final input distributions. SAS writes one handoff dataset. Stata estimates one ordinary pooled OLS model with an intercept. The paper says the table presents pooled regressions and t-statistics in parentheses (physical PDF p. 6 and p. 8; printed pp. 376 and 378), but does not specify its estimator or covariance estimator. Ordinary OLS and conventional standard errors are therefore best-effort choices. Table exports follow the assigned template’s coefficient stars and parenthesized p-values; the paper displays t-statistics.

## Results and sample diagnostics

### Native construction and classification checks

The native SAS build and Stata handoff completed successfully. The FUNDA extract contained 91,914 rows; exactly two GVKEY/FYEAR keys were duplicated. They were GVKEY 006557 in FY1982 and FY1983. For each key, the Aug CAD statement uniquely had the highest completeness across the 12 selected fields (11 observed versus 4 for the Dec USD companion); the more complete row was retained. No ties remained, yielding 91,912 keyed annual rows. This selection was based on source-field completeness and was not fitted to the published estimates.

Across 54,389 joined t-periods for 1978–1986, all actual DATADATE sequences were increasing. CURCD was stable over t−2 through t+1 for 54,362 periods; 27 periods had a currency mismatch and were omitted from constructions requiring a multi-period ratio or change. The final sample has 23,425 observations in 4,654 firms:

| Fiscal year t | Joined | Same currency | Historically classified, nonfinancial | Prior PM ≥ 0 | After current screens | After future screen | Final N |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1978 | 5,997 | 5,996 | 3,023 | 2,811 | 2,753 | 2,728 | 2,696 |
| 1979 | 5,806 | 5,806 | 3,067 | 2,860 | 2,775 | 2,752 | 2,711 |
| 1980 | 5,718 | 5,718 | 3,069 | 2,830 | 2,748 | 2,722 | 2,671 |
| 1981 | 5,705 | 5,703 | 3,183 | 2,860 | 2,772 | 2,724 | 2,629 |
| 1982 | 5,796 | 5,793 | 3,340 | 2,884 | 2,757 | 2,720 | 2,641 |
| 1983 | 5,857 | 5,854 | 3,494 | 2,745 | 2,622 | 2,583 | 2,430 |
| 1984 | 6,313 | 6,309 | 3,743 | 2,931 | 2,773 | 2,702 | 2,563 |
| 1985 | 6,495 | 6,491 | 3,880 | 2,996 | 2,797 | 2,738 | 2,579 |
| 1986 | 6,702 | 6,692 | 4,051 | 2,943 | 2,748 | 2,688 | 2,505 |

Direct positive Compustat SICH is severely incomplete early in the sample: zero of the joined periods in 1978–1981 have it; there are 546 positive SICH values in 1982–1986. Dated CCM/CRSP coverage and unresolved counts are:

| Year | Joined | Positive SICH | Valid CCM link | Effective MSENAMES | Unique positive dated CRSP SIC | SICH/CRSP disagreements | Multicode conflicts | SIC unresolved after fallback |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1978 | 5,997 | 0 | 3,907 | 3,898 | 3,440 | 0 | 0 | 2,557 |
| 1979 | 5,806 | 0 | 3,953 | 3,947 | 3,507 | 0 | 0 | 2,299 |
| 1980 | 5,718 | 0 | 3,956 | 3,947 | 3,529 | 0 | 0 | 2,189 |
| 1981 | 5,705 | 0 | 4,038 | 4,032 | 3,665 | 0 | 0 | 2,040 |
| 1982 | 5,796 | 81 | 4,179 | 4,168 | 3,763 | 58 | 0 | 1,952 |
| 1983 | 5,857 | 86 | 4,298 | 4,290 | 3,944 | 60 | 0 | 1,827 |
| 1984 | 6,313 | 114 | 4,589 | 4,584 | 4,326 | 72 | 0 | 1,873 |
| 1985 | 6,495 | 127 | 4,693 | 4,686 | 4,529 | 76 | 0 | 1,839 |
| 1986 | 6,702 | 138 | 4,870 | 4,858 | 4,732 | 79 | 0 | 1,832 |

A CRSP SIC is used only when SICH is absent or zero and exactly one valid positive dated SIC is available. When both direct SICH and unique dated CRSP SIC exist but differ, the direct Compustat value is retained and the disagreement is counted. No multicode conflicts occurred. Rows with no resolved historical SIC are excluded because their financial-industry status is unknown; no current header classification or forced link was used. Unresolved firms may include genuine gaps in early CRSP coverage.

The algebraic identity for ΔRNOA was checked on 48,989 complete rows. Maximum absolute residual was 2 at extreme scales, but maximum scaled relative residual was 2.4543×10⁻¹⁵; there were no relative failures. The five rows with large absolute residuals had near-zero NOA denominators and failed both current and future paper tail screens. No extra positive-NOA or magnitude screen was introduced.

### Estimation and descriptive results

The one retained ordinary pooled OLS fit uses N=23,425 and has R²=0.0756 (adjusted R²=0.0754). Table exports show coefficients with conventional two-sided p-values in parentheses, as required by the template; the source reports t-statistics. The source Table 2 Model 3 reports N=9,147 and R²=0.1082. Coefficients (replication estimate; source estimate) are: intercept 0.0155; 0.0247, t=12.51 versus 14.53; RNOA(t) −0.1752; −0.1403, t=−35.14 versus −20.71; growth in NOA(t) −0.0001; −0.0671, t=−0.74 versus −15.83; weighted ΔATO(t) 0.2803; 0.1799, t=19.15 versus 8.08; weighted ΔPM(t) −0.0068; 0.0042, t=−0.70 versus 0.28; and raw interaction 0.0037; 0.1349, t=0.12 versus 2.47. The sample, R², and several coefficients differ materially. The available population and screen diagnostics do not establish a single cause for the N difference; it is reported as an unresolved discrepancy, not attributed to the data vintage. No filters were added to move the result toward the paper.

The separate Stata `estpost tabstat` cell exports N, mean, standard deviation, minimum, p1, median, p99, and maximum for the outcome and all regressors to four formats. The actual analysis sample has N=23,425 for each variable. Growth in NOA has mean 0.2163, SD 4.4807, median 0.1008, p99 1.7403, and maximum 678.5299. This large tail remains because the specified screens do not trim growth in NOA directly; it is consistent with a small prior-NOA denominator and is not grounds for a new arbitrary cutoff. The raw interaction has mean 0.0061, SD 0.0261, median 0.0006, p99 0.1186, and maximum 0.3707. Other actual-sample descriptives are in [table2_model3_descriptives.md](tables/table2_model3_descriptives.md).

The paper’s Table 1 (physical PDF p. 7; printed p. 377) reports broad-sample means / standard deviations / medians for 1978–1996, combining training and out-of-sample forecast periods, not the Table 2 Model 3 sample. Its values versus this Table 2 analysis sample are: RNOA(t) 0.172 / 0.160 / 0.150 versus 0.1893 / 0.1558 / 0.1681; growth in NOA(t) 0.097 / 0.320 / 0.072 versus 0.2163 / 4.4807 / 0.1008; ΔRNOA(t+1) −0.005 / 0.094 / −0.001 versus −0.0201 / 0.1094 / −0.0091; weighted ΔATO(t) −0.005 / 0.044 / −0.0009 versus −0.0092 / 0.0499 / −0.0022; weighted ΔPM(t) −0.004 / 0.082 / 0.0004 versus −0.0208 / 0.0925 / −0.0058; and raw interaction 0.003 / 0.019 / 0.0002 versus 0.0061 / 0.0261 / 0.0006. Because the populations and periods differ, these comparisons are descriptive context rather than like-for-like validation. The narrow model N=9,147 discrepancy remains unresolved.
