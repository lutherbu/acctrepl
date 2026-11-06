# Independent currency repair review — attempt 04

## Materials and scope checked

I read the frozen work item and skill snapshots, the assigned Stata template, the original paper, and the predecessor attempt 03 source, design, review, submission, runtime, and output tables. I checked the paper’s sample and construction description on physical PDF pp. 6–7, equation (1) and controls on pp. 11–12, Table 2 on pp. 13–14, and its truncated-regression note on p. 14. I also checked the cached Xpressfeed currency chapter (physical pp. 83, 86–87), the 2004 Compustat auditor codebook (physical p. 68 / printed p. 18), the CRSP guide, and exact field entries in the local catalog. No author code or prepared data were accessed.

The currency defect was material even though few final rows changed reporting currency. A3’s handoff had 12 current/prior and 19 prior/prior2 code changes; these were audit counts, not guaranteed counts in its auxiliary populations. Attempt 04 carried the exact `COMP.FUNDA.CURCD` code through the full supporting population and used the catalog-listed rate groups. I preserved A3’s paper screens, auditor identity and merger mapping, local M&A proxy, Jones regression, native estimators, fixed effects, and common complete-case sample design.

## Currency and unit checks

The provider identifies `CURCD` as the period-specific reporting currency and directs users to use daily `EXRATD` for balance-sheet data and monthly `EXRAT12M` for income-statement and cash-flow data (Xpressfeed physical p. 86). Its two-step GBP-primary formula supports the translation to USD; the build applies each rate to the exact annual `datadate` (physical p. 87). It does not use `CURRTR` arithmetic.

| Construct | Source periods and units | Attempt 04 treatment |
| --- | --- | --- |
| Average total assets and Current Accruals | Balance-sheet stocks at fiscal year *t* and *t−1* | Keep reported values when `CURCD_t=CURCD_t−1`; when they differ, convert each period’s stocks at its own exact-date daily rate, then take the change and average. |
| Total Accruals and Cash Flow | `oiadp`, `oancf` for fiscal year *t*; average assets for *t* and *t−1* | Keep native, currency-homogeneous ratios when codes match; for a currency switch, translate the current flows with exact-date `EXRAT12M` and stocks with their own daily rates before scaling. |
| Revenue change and Jones inputs | Sales flows at *t* and *t−1*, current PPE stock, average assets | Preserve same-code ratios; translate each unlike-currency period with its matching flow/stock rate before changes and scaling. Jones OLS remains annual, two-digit SIC, with the inherited eight-firm minimum. |
| Size | Current total-assets stock at *t* | Translate `at` to USD for all firms before taking log, including every CAD observation, even when its reporting currency is stable. |
| Industry Growth | Sum of sales across the full SIC-year support, then *t* divided by *t−1* | Translate each observed sales flow to USD before aggregation; leave a group-year unavailable if any observed sales amount cannot be translated. |
| Fixed-dollar thresholds or market value | Table 2 assigned scopes | None is used. The positive-assets check is sign-invariant under the positive rate. Table 1 MVE descriptives are outside the eight assigned scopes; no CRSP merge is part of this build. |

The read-only source audit and native SAS build agree that all 156,255 selected annual rows for fiscal years 1987–2000 have known USD or CAD codes (143,131 USD; 13,124 CAD), with month-end reporting dates. The build matched every row to both daily and monthly rates. Its USD/CAD rate candidates had 10,958 daily rows dated January 1, 1987 through December 31, 2001 and 360 monthly rows dated January 31, 1987 through December 31, 2001. All included rates were GBP-primary, positive, and unique by currency-date; there were zero unmatched source rows, unsupported currencies, nonpositive/missing rates, or duplicate rate keys. The daily type code was `AR` on 155,549 matched source rows; 706 matched rows used one positive, unique currency-date rate with a blank `EXRATTPD` subtype. The cached provider chapter does not explain that blank value, so its rate is retained as a source row and the subtype is disclosed as unknown.

The currency-transition counts below come from the SAS build’s actual stages. `current/prior` switches directly affect year-*t* accounting changes and average assets. `prior/prior2` is reported as a second-lag audit; it is not an additional year-*t* input beyond the treatment of each adjacent pair in its own year.

| Stage | Rows | Current/prior known | Current/prior different | Prior/prior2 known | Prior/prior2 different | Current CAD rows | Cross-rate ratio rows |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Source annual lags, FY 1988–2000 | 147,030 | 135,327 | 145 | 123,714 | 127 | 12,438 | 145 |
| Six-year/M&A-proxy candidates | 52,827 | 52,827 | 40 | 52,827 | 47 | 3,822 | 40 |
| Complete Jones/current-accrual support | 39,723 | 39,723 | 26 | 39,723 | 36 | 1,324 | 26 |
| Jones-fit population | 38,909 | 38,909 | 25 | 38,909 | 36 | 1,303 | 25 |
| Pre-relationship/outlier trimmed support | 39,723 | 39,723 | 26 | 39,723 | 36 | 1,324 | 26 |
| Final Table 2 sample | 27,414 | 27,414 | 12 | 27,414 | 19 | 897 | 12 |

The 12 final cross-code rows had valid daily and monthly conversion rates and were translated rather than excluded. The 897 final CAD rows have USD-denominated Size. The industry sales build covered 124,632 observed source sales rows (115,077 USD, 9,555 CAD); 831 of its 1,001 SIC-year groups contained both currencies, and no group-year had unconverted observed sales. The source report confirms there is no Table 2 CRSP market-value combination or fixed-dollar filter to repair.

Currency changes in the measures were checked by firm-year key against A3. Both handoffs have 27,414 rows, with 27,412 shared firm-years, two A3-only and two attempt-04-only firm-years. On the shared keys, `current_accrual` and `cash_flow` changed for the 12 directly converted rows; discretionary-accrual residuals changed for 1,381 rows after the Jones cell coefficients/residuals were re-estimated; Size changed for 897 CAD rows; and Industry Growth changed for 27,024 rows after USD aggregation. There were four sign flips in each accrual measure on shared keys. The final sample N is unchanged, but two observations leave and two enter after the input and annual trimming calculations are rebuilt. No row-level exclusion rule, cutoff, or estimator was tuned to preserve N.

The inherited M&A proxy is still only a proxy. In 30,755 annual rows for fiscal years 1988–2000, all six acquisition/merger financial-item fields were missing; this does not prove that no merger or acquisition occurred. Those rows are not positive evidence in the proxy and are not separately screened out, preserving A3’s local best-effort rule while recording its uncertainty. The paper’s exact M&A footnote codes remain unavailable.

## Native estimates and published comparison

The attempt 04 SAS build and Stata handoff completed successfully. The deduplicated source count, 52,827 candidates, 39,723 supporting rows, 38,909 Jones-fit rows, 814 unavailable Jones residuals, 27,414 final rows, and zero duplicate final keys match the predecessor’s build counts. All eight frozen model/result-set scopes were re-executed on the repaired handoff. The Panel A, positive Current Accruals, and Panel C cells produced four-format exports. Positive DA, negative DA, and negative CA produced no valid full-model truncated estimate; the renewed native calls exited r(430). Their OLS starting regressions are initial values only and are not reported as fit estimates. The predecessor’s documented default, feasible-start, and optimizer retries remain in attempt 03; no sample or estimator change was made here.

Coefficients are for Tenure. Local p-values are two-sided Stata values. The paper does not identify Table 2’s covariance estimator or p-value sidedness, so model-based errors are used as a best-effort choice and no sidedness adjustment is applied. Local OLS and positive-current truncated-regression estimates below are unrounded values from the ordinary Stata logs. Stata `truncreg` does not store a pseudo-R²; its `r2` and adjusted `r2` table entries remain blank, and no alternative pseudo-R² was manufactured.

| Scope | Published N | A3 N | A4 N | Published Tenure b (p) | A3 Tenure b (p) | A4 Tenure b (p) / status |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| abs_da | 41,250 | 27,414 | 27,414 | −0.00037 (0.0041) | −0.0003124 (0.316) | −0.0003001 (0.334), executed OLS |
| abs_ca | 41,250 | 27,414 | 27,414 | −0.00142 (0.0004) | −0.0003104 (0.001) | −0.0003052 (0.001), executed OLS |
| pos_da | 21,449 | 16,114 | 16,112 | −0.00146 (0.0502) | —, blocked | —, blocked r(430) |
| neg_da | 19,801 | 11,300 | 11,302 | +0.0534 (<0.0001) | —, blocked | —, blocked r(430) |
| pos_ca | 21,619 | 14,444 | 14,442 | −0.0293 (<0.0001) | −0.019745 (<0.001) | −0.0195236 (<0.001), executed truncated MLE |
| neg_ca | 19,631 | 12,962 | 12,964 | +0.2463 (<0.0001) | —, blocked | —, blocked r(430) |
| raw_da | 41,250 | 27,414 | 27,414 | +0.00038 (0.0330) | −0.0003669 (0.283) | −0.0003607 (0.290), executed OLS |
| raw_ca | 41,250 | 27,414 | 27,414 | −0.00043 (0.3359) | −0.0001804 (0.150) | −0.0001831 (0.144), executed OLS |

The currency repair leaves 5/8 scopes with current valid estimates. Panel A continues to show a negative, significant Current Accruals coefficient, while absolute DA remains negative but not significant locally. Positive Current Accruals remains negative and significant, with a smaller absolute coefficient than the published estimate. Raw DA remains negative and nonsignificant locally, unlike the paper’s positive significant result. Raw Current Accruals remains negative and nonsignificant locally, like the paper’s direction and inference. The three blocked signed fits have no A4 coefficient or inference to compare. The local sample-size shortfalls from the paper are not attributed to the currency repair: the main N remains 27,414 versus the paper’s 41,250, and current data vintage, proxy M&A screening, `che` mapping, and auditor-history coverage remain unresolved population differences.

## Analysis-sample descriptives

The following means and medians are from the actual common Table 2 analysis sample, not Table 1’s separate long-relationship descriptive sample. A3 and A4 each have N=27,414.

| Variable | A3 mean (median) | A4 mean (median) |
| --- | ---: | ---: |
| Absolute Discretionary Accruals | 0.099296 (0.051709) | 0.099237 (0.051708) |
| Absolute Current Accruals | 0.063771 (0.034759) | 0.063766 (0.034759) |
| Raw Discretionary Accruals | 0.027386 (0.014081) | 0.027301 (0.014066) |
| Raw Current Accruals | −0.001428 (0.002642) | −0.001423 (0.002640) |
| Tenure | 10.4968 (9) | 10.4968 (9) |
| Age | 12.5206 (12) | 12.5208 (12) |
| Log assets, USD in A4 | 4.9041 (4.7526) | 4.8937 (4.7406) |
| Industry Growth | 1.4753 (1.0709) | 1.5400 (1.0711) |
| Cash Flow | 0.048043 (0.074709) | 0.048037 (0.074707) |

The principal descriptive changes are in currency-sensitive Size and in the Industry Growth sums; the scaled outcomes change modestly. The maximum Industry Growth remains extreme (about 1,693 in A4) under the paper’s printed sum-of-sales ratio. No extra winsorization or outlier screen was added.

## Limitations and retained assumptions

The paper’s Compustat source is its 2001 industrial/research vintage; the available annual data are a current vintage, so historical population equivalence is unverified. `che` includes short-term investments while the paper specifies cash and equivalents. The original M&A footnote codes are not present, and 30,755 of the required-period annual rows have all six proxy fields missing. AU code 0 means unaudited, 9 means other, and missing AU does not identify a spell; local histories also censor spells at source boundaries. The source does not report the Panel A/C estimator, the covariance correction, the annual percentile algorithm, or Table 2 p-value sidedness. Positive DA (N=16,112), negative DA (N=11,302), and negative CA (N=12,964) remain explicitly blocked after the renewed native truncated-regression attempts; all observations are retained. The cached rate documentation does not resolve the blank daily subtype for one matched currency-date.

Generated tables are `tables/table2_panelA`, `tables/table2_panelB_posCA`, and `tables/table2_panelC`, each in `.md`, `.rtf`, `.csv`, and `.tex`. The executed SAS log, handoff, and all Stata cell logs are retained under `runtime/20261102T165339344682Z/` and `runtime/20261102T165526709940Z/`.
