# All retained model/result-set comparisons

239 scope rows below. These are reviewed focal comparisons, not a complete term-by-term equivalence test. Read each paper’s sample/estimator qualifications with its model findings. Published parameter reference records are in fits.jsonl; the accepted source-checked review controls over that earlier extraction.

## W3122547505: The Quality of Accruals and Earnings: The Role of Accrual Estimation Errors

[TAR; accepted attempt 3 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122547505/attempt_03/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122547505/attempt_03/design.md)

14,346 firm-years and 1,465 firm regressions versus 15,234 and 1,725. Firm-specific OLS and CFO denominator/lead-lag screening interpretations; historical population not recovered.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `firm_specific_accrual_quality` / `table3_panel_a_firm_specific` | executed | All three CFO slopes retain their signs and strong significance. Magnitudes and fit differ: lag/current/lead CFO 0.143/-0.548/0.122 versus 0.17/-0.62/0.09; mean adjusted R2 0.447 versus 0.47. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122547505/attempt_03/tables/table3_panel_a_crossfirm_means.md) |

## W3125677029: Real and Accrual-Based Earnings Management in the Pre- and Post-Sarbanes-Oxley Periods

[TAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125677029/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125677029/attempt_02/design.md)

93,508 common firm-years versus 87,217 paper-wide; published model-specific N unavailable. Extreme tails and small asset denominators dominate local moments; the paper does not specify trimming or the RM standardization population. Source test sidedness is unknown.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `table2_abs_da` / `table2_panel_a` | executed | SOX +3.327 (p<.001) versus -.015***; Time .085 (p=.056) versus .003***. Source test sidedness is unknown; tails/standardization remain unresolved. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125677029/attempt_02/tables/table2_panel_a.md) |
| `table2_positive_da` / `table2_panel_a` | executed | SOX +3.288 (p<.001) versus -.019**; Time .097 (p=.061) versus .002***. Source test sidedness is unknown; tails/standardization remain unresolved. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125677029/attempt_02/tables/table2_panel_a.md) |
| `table2_negative_da` / `table2_panel_a` | executed | SOX -3.381 (p<.001) versus +.006***; Time -.071 (p=.343) versus -.003***. Source test sidedness is unknown; tails/standardization remain unresolved. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125677029/attempt_02/tables/table2_panel_a.md) |
| `table2_r_prod` / `table2_panel_a` | executed | SOX -.266 (p<.001) versus +.032***; Time -.006 (p=.199) versus -.002, both nonsignificant. Source test sidedness is unknown; tails/standardization remain unresolved. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125677029/attempt_02/tables/table2_panel_a.md) |
| `table2_r_cfo` / `table2_panel_a` | executed | SOX -.326 (p=.002) versus +.007**; Time and SCA also reverse sign and lose significance. Source test sidedness is unknown; tails/standardization remain unresolved. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125677029/attempt_02/tables/table2_panel_a.md) |
| `table2_r_disx` / `table2_panel_a` | executed | SOX +.872 (p=.014) versus -.011***; Time reverses and loses significance; SCA loses significance. Source test sidedness is unknown; tails/standardization remain unresolved. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125677029/attempt_02/tables/table2_panel_a.md) |
| `table2_rm_proxy` / `table2_panel_a` | executed | SOX -.080 (p<.001) versus +.041***; Time and SCA lose significance. Source test sidedness is unknown; tails/standardization remain unresolved. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125677029/attempt_02/tables/table2_panel_a.md) |

**Supporting construction models** (no separate campaign comparison scope): `modified_jones`, `normal_cfo`, `normal_production`, `normal_discretionary_expenses`. See linked design/native logs for their internal fit coverage.

## W3126118385: Cash Flow Patterns as a Proxy for Firm Life Cycle

[TAR; accepted attempt 5 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126118385/attempt_05/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126118385/attempt_05/design.md)

CF 26,242; A&R 17,713; age 26,438, each versus 48,369. Legacy IINT replaced by unverified IDIT proxy; source estimator unspecified; CF and A&R require the installed covariance adjustment.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `table5_model1_cf_pattern` / `table5_table5_model1_cf_pattern_model1` | executed | All four stage increments remain negative/significant. Stage totals -.150/-.028/-.033/-.212 versus -.121/-.031/-.001/-.142. N 26,242 versus 48,369. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126118385/attempt_05/tables/table5_model1_cf_pattern.md) |
| `table5_model1_ar` / `table5_table5_model1_ar_model1` | executed | None of four stage contrasts is significant at 5% (p=.151/.547/.433/.253), unlike published introduction/shake-out/decline contrasts. N 17,713 versus 48,369. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126118385/attempt_05/tables/table5_model1_ar.md) |
| `table5_model1_age_quintiles` / `table5_table5_model1_age_quintiles_model1` | executed | Stage contrasts retain signs/significance, but total levels differ, including negative local shake-out total (-.009 versus +.026). N 26,438 versus 48,369. Do not confuse total-level tests with reference-group contrasts. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126118385/attempt_05/tables/table5_model1_age_quintiles.md) |

## W2152596199: Exploring the Term of the Auditor-Client Relationship and the Quality of Earnings: A Case for Mandatory Auditor Rotation?

[TAR; accepted attempt 4 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2152596199/attempt_04/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2152596199/attempt_04/design.md)

Main N 27,414 versus 41,250; signed subsets differ separately. Historical auditor/M&A coverage and cash mapping differ; three native truncated-MLE convergence failures.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `abs_da` / `abs_da` | executed | Tenure -.0003001, p=.334 versus -.00037, p=.0041: loses significance. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2152596199/attempt_04/tables/table2_panelA.md) |
| `abs_ca` / `abs_ca` | executed | Tenure -.0003052, p=.001 versus -.00142, p=.0004: same negative/significant finding, much smaller magnitude. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2152596199/attempt_04/tables/table2_panelA.md) |
| `pos_da` / `pos_da` | blocked | No converged estimate to compare. The renewed Stata 18 lower-truncated regression on the repaired 16,112 positive discretionary-accrual observations used the same-sample OLS-based full-model start and the original controls/fixed effects. The native BHHH-to-NR attempt with model-based OIM inference exited r(430) before a valid full-model estimate. No coefficient or valid inference is reported; all observations remain in the sample. Attempt 03 records earlier documented native starts and optimizer retries on its prior sample. | No converged estimate |
| `neg_da` / `neg_da` | blocked | No converged estimate to compare. The renewed Stata 18 upper-truncated regression on the repaired 11,302 negative discretionary-accrual observations used the same-sample OLS-based full-model start and the original controls/fixed effects. The native BHHH-to-NR attempt with model-based OIM inference exited r(430) in a nonconcave region before a valid full-model estimate. No coefficient or valid inference is reported; all observations remain in the sample. Attempt 03 records earlier documented native starts and optimizer retries on its prior sample. | No converged estimate |
| `pos_ca` / `pos_ca` | executed | Tenure -.0195236, p<.001 versus -.0293, p<.0001: same negative/significant finding. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2152596199/attempt_04/tables/table2_panelB_posCA.md) |
| `neg_ca` / `neg_ca` | blocked | No converged estimate to compare. The renewed Stata 18 upper-truncated regression on the repaired 12,964 negative Current Accrual observations used the same-sample OLS-based full-model start and the original controls/fixed effects. The native BHHH-to-NR attempt with model-based OIM inference exited r(430) in a nonconcave region before a valid full-model estimate. No coefficient or valid inference is reported; all observations remain in the sample. Attempt 03 records earlier documented native starts and optimizer retries on its prior sample. | No converged estimate |
| `raw_da` / `raw_da` | executed | Tenure -.0003607, p=.290 versus +.00038, p=.0330: reverses sign and loses significance. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2152596199/attempt_04/tables/table2_panelC.md) |
| `raw_ca` / `raw_ca` | executed | Tenure -.0001831, p=.144 versus -.00043, p=.3359: negative/nonsignificant in both. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2152596199/attempt_04/tables/table2_panelC.md) |

**Supporting construction models** (no separate campaign comparison scope): `jones_fit`. See linked design/native logs for their internal fit coverage.

## W1990806291: The Mispricing of Abnormal Accruals

[TAR; accepted attempt 4 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1990806291/attempt_04/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1990806291/attempt_04/design.md)

55,064 system observations versus 51,579. Conditional Gaussian likelihood with independent equation errors is an explicit identification approximation to the source's unspecified GLS/weighted-SSR method.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `mishkin_forecast` / `table2_panel_a_forecasting` | executed | CFO/NAC/ABNAC forecast slopes .8113/.7831/.6786 versus .73/.70/.57: all positive, larger locally; persistence ordering retained. Shared system NAC pricing equality fails to reject (p=.1624 versus <.001). | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1990806291/attempt_04/tables/table2_mishkin.md) |
| `mishkin_valuation` / `table2_panel_a_valuation` | executed | Valuation slopes .6068/.8704/1.1530 versus .67/.78/.69. CFO/ABNAC and both joint equality rejections persist; NAC equality does not (p=.1624 versus <.001). These are shared-system tests under an approximate conditional likelihood. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1990806291/attempt_04/tables/table2_mishkin.md) |

**Supporting construction models** (no separate campaign comparison scope): `jones_accruals`. See linked design/native logs for their internal fit coverage.

## W3122987060: Accruals and the Prediction of Future Cash Flows

[TAR; accepted attempt 3 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122987060/attempt_03/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122987060/attempt_03/design.md)

Primary and k=0–2 N 10,500 versus 10,164; k=3–6 local Ns 9,868/9,311/8,755/8,166 versus 9,250/8,491/7,821/7,213. Unspecified source tail convention and percentile details; higher-lag discrepancies are supporting-model results.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `baseline_cf_components` / `table3_panel_a_unrestricted` | executed | All seven component slopes retain signs/significance. DEPR .278 versus .42; AMORT .261 versus .47. N 10,500 versus 10,164; adjusted R2 .3769 versus .35. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122987060/attempt_03/tables/table3_cf_components.md) |
| `aggregate_earnings_benchmark` / `aggregate_earnings_k0` | executed | Current EARN .459 versus .42; positive/significant. N 10,500 versus 10,164. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122987060/attempt_03/tables/table2_aggregate_earnings.md) |
| `aggregate_earnings_benchmark` / `aggregate_earnings_k1` | executed | Current/lag EARN .390/.106 versus .35/.12; both positive/significant. N 10,500 versus 10,164. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122987060/attempt_03/tables/table2_aggregate_earnings.md) |
| `aggregate_earnings_benchmark` / `aggregate_earnings_k2` | executed | EARN terms .379/.080/.058 versus .33/.07/.10; all positive/significant. N 10,500 versus 10,164. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122987060/attempt_03/tables/table2_aggregate_earnings.md) |
| `aggregate_earnings_benchmark` / `aggregate_earnings_k3` | executed | EARN terms .375/.079/.042/.041 versus .33/.08/.07/.06; all positive/significant. N 9,868 versus 9,250. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122987060/attempt_03/tables/table2_aggregate_earnings.md) |
| `aggregate_earnings_benchmark` / `aggregate_earnings_k4` | executed | EARN terms .373/.081/.038/.036/.021 versus .33/.08/.07/.05/.03; all positive/significant. N 9,311 versus 8,491. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122987060/attempt_03/tables/table2_aggregate_earnings.md) |
| `aggregate_earnings_benchmark` / `aggregate_earnings_k5` | executed | Current and lags 1–3/5 remain positive/significant; lag 4 nonsignificant in both. N 8,755 versus 7,821. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122987060/attempt_03/tables/table2_aggregate_earnings.md) |
| `aggregate_earnings_benchmark` / `aggregate_earnings_k6` | executed | All signs positive; lag 5 loses significance (p=.175 versus source t=2.51), lag 6 gains conventional two-sided 5% significance (p<.001 versus source t=1.94). N 8,166 versus 7,213. Source test sidedness unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122987060/attempt_03/tables/table2_aggregate_earnings.md) |

## W1997012386: The Role of Accounting Conservatism in Mitigating Bondholder-Shareholder Conflicts over Dividend Policy and in Reducing Debt Costs

[TAR; accepted attempt 3 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1997012386/attempt_03/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1997012386/attempt_03/design.md)

Both local models N 140 versus 704 and 632. Severe R&D/advertising coverage loss, legacy rating/depreciation proxies; source predicted tests are one-tailed and exports are two-tailed.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `conflict_conmkt_1993_98` / `table3_panel_a_levels_1993_98` | executed | STDROA/DIV/LEV remain positive/significant: 3.343/7.963/1.776 versus 2.079/3.557/.316. N 140 versus 704. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1997012386/attempt_03/tables/table3_panel_a_levels_1993_98.md) |
| `conflict_conacc_1993_98` / `table3_panel_b_levels_1993_98` | executed | STDROA stays positive/significant; DIV loses significance (.115, p=.466 versus .404, p=.001); LEV remains nonsignificant with sign change. N 140 versus 632. Source predicted tests one-tailed, local tests two-tailed. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1997012386/attempt_03/tables/table3_panel_b_levels_1993_98.md) |

**Supporting construction models** (no separate campaign comparison scope): `conmkt_fit`. See linked design/native logs for their internal fit coverage.

## W3121570881: Does Income Smoothing Improve Earnings Informativeness?

[TAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121570881/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121570881/attempt_02/design.md)

12,712 versus 17,019 (-25.3%). Source covariance and price/return-date details unspecified; narrower local return/EPS spreads.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `ferc_primary` / `table3_panel_c_primary` | executed | Both smoothing interactions remain positive and significant: .8120/.3759 versus .681/.308; magnitudes are larger locally. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121570881/attempt_02/tables/table3_panel_c_primary.md) |

**Supporting construction models** (no separate campaign comparison scope): `discretionary_accruals`. See linked design/native logs for their internal fit coverage.

## W3121890812: The Persistence and Pricing of Earnings, Accruals, and Cash Flows When Firms Have Large Book-Tax Differences

[TAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121890812/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121890812/attempt_02/design.md)

15,609 versus 14,106. Broader source missing-variable screen not fully recoverable; unknown TLCF/current-tax statuses retained according to stated screen.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `h1_pretax_earnings_persistence` / `table3_panel_b` | executed | Both large-BTD persistence interactions remain negative/significant, -.0904/-.2239 versus -.100/-.212; their equality is rejected in both. The local intercept becomes significant. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121890812/attempt_02/tables/table3_panel_b.md) |

## W1994228146: Accrued Earnings and Growth: Implications for Future Profitability and Market Mispricing

[TAR; accepted attempt 3 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1994228146/attempt_03/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1994228146/attempt_03/design.md)

67,585 versus 32,961; 30 annual fits. Goodwill legacy-item proxy, missing accounting-change footnote detail, and unresolved population difference.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `table3_eq2_h1` / `table3_eq2_panel_a` | executed | GrLTNOA and ACC retain negative significant slopes, but their equality is rejected locally (p=.00001554) versus nonrejection in the paper (p=.11). Adjusted R2 .624 versus .62. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1994228146/attempt_03/tables/table3_eq2.md) |

## W3124907716: Earnings Management: New Evidence Based on Deferred Tax Expense

[TAR; accepted attempt 5 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124907716/attempt_05/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124907716/attempt_05/design.md)

Executed Ns 4,995/4,077; 4,995/3,128/4,077; 4,106/2,542/3,207, all above published Ns. Published one-tailed wording conflicts with table labeling; exports are two-sided. IBES split screen unavailable and linkage is approximate.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `tacc_t1` / `table_2_t1` | executed | DTE 3.718 (p=.026) versus 3.7785 (.0153), TAcc 1.406 versus .9583: both positive/significant. N 4,995 versus 4,139. Source p-value convention is ambiguous; local p-values are two-sided. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124907716/attempt_05/tables/table2_t1.md) |
| `tacc_t2` / `table_2_t2` | blocked | No converged estimate to compare. Stata executed the corrected handoff (3,144 SAS rows; 3,128 after perfect-prediction deletions) but failed to converge after 300 iterations, returning r(430). SIC2 14 removed 1 row, SIC2 45 removed 11, and SIC2 75 removed 4; Stata reported 48 failures and 41 successes completely determined. No valid estimate or exports are retained. | No converged estimate |
| `tacc_t3` / `table_2_t3` | executed | DTE nonsignificant in both; TAcc .068 (p=.732) versus .6160 (.0422) loses significance. N 4,077 versus 2,530. Source p-value convention is ambiguous; local p-values are two-sided. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124907716/attempt_05/tables/table2_t3.md) |
| `abaccmj_t1` / `table_3_t1` | executed | DTE positive/significant in both; AbAccMJ .176 (p=.089) versus .1423 (.2506), both nonsignificant at 5% but differ at 10%. N 4,995 versus 4,139. Source p-value convention is ambiguous; local p-values are two-sided. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124907716/attempt_05/tables/table3_t1.md) |
| `abaccmj_t2` / `table_3_t2` | executed | DTE and AbAccMJ positive/significant in both: 9.549/.595 versus 8.8055/.8854. N 3,128 versus 2,785. Source p-value convention is ambiguous; local p-values are two-sided. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124907716/attempt_05/tables/table3_t2.md) |
| `abaccmj_t3` / `table_3_t3` | executed | DTE nonsignificant in both; AbAccMJ changes sign (+.117 versus -.0730), nonsignificant in both. N 4,077 versus 2,530. Source p-value convention is ambiguous; local p-values are two-sided. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124907716/attempt_05/tables/table3_t3.md) |
| `abaccfl_t1` / `table_4_t1` | executed | DTE gains significance: 4.167, p=.025 versus 2.7257, p=.1157. AbAccFL remains positive/significant. N 4,106 versus 3,352. Source p-value convention is ambiguous; local p-values are two-sided. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124907716/attempt_05/tables/table4_t1.md) |
| `abaccfl_t2` / `table_4_t2` | executed | DTE and AbAccFL remain positive/significant: 11.446/1.148 versus 10.2743/.6174. N 2,542 versus 2,254. Source p-value convention is ambiguous; local p-values are two-sided. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124907716/attempt_05/tables/table4_t2.md) |
| `abaccfl_t3` / `table_4_t3` | executed | DTE nonsignificant in both; AbAccFL changes sign (+.239 versus -.0039), nonsignificant in both. N 3,207 versus 2,279. Source p-value convention is ambiguous; local p-values are two-sided. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124907716/attempt_05/tables/table4_t3.md) |

**Supporting construction models** (no separate campaign comparison scope): `mj_fit_decline`, `mj_fit_loss`, `mj_fit_forecast`, `fl_fit_decline`, `fl_fit_loss`, `fl_fit_forecast`, `k_slope_fit`. See linked design/native logs for their internal fit coverage.

## W2028237122: A Temporal Analysis of Quarterly Earnings Thresholds: Propensities and Valuation Consequences

[TAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2028237122/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2028237122/attempt_02/design.md)

18 annual observations per regression; underlying observations differ from the paper. Exact split-adjusted primary construction unavailable; these are documented approximation results, not an exact baseline replication.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `propensity_loss_trend` / `figure1_loss_trend` | executed | Slope -.0344, p=.274 versus -.0361, t=-1.63; same negative/nonsignificant pattern at two-sided 5%. 18 annual observations; exact split-adjusted baseline unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2028237122/attempt_02/tables/figure1_trend_ols.md) |
| `propensity_decrease_trend` / `figure1_decrease_trend` | executed | Slope -.0960, p=.081 versus -.1024, t=-1.62; both nonsignificant at two-sided 5%, but differ at 10%. 18 annual observations; exact split-adjusted baseline unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2028237122/attempt_02/tables/figure1_trend_ols.md) |
| `propensity_surprise_trend` / `figure1_surprise_trend` | executed | Slope -.9758, p<.001 versus -1.218, t=-13.91; same negative/significant pattern. 18 annual observations; exact split-adjusted baseline unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2028237122/attempt_02/tables/figure1_trend_ols.md) |

## W3124908438: The Use of DuPont Analysis by Market Participants

[TAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124908438/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124908438/attempt_02/design.md)

25,469 common observations versus reported all-tests-common 38,716; 19 annual fits. Unassigned tests not rebuilt for source common sample; Newey-West lag 1 is assumed and source covariance wording conflicts.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `long_window_future_components` / `table5_full_future_components` | executed | Delta-ATO -.01967 (p=.103) versus +.087 (t=5.88); future ATO -.00302 (p=.589) versus +.017 (t=3.44). Both published positive findings absent; EARN and other terms also differ. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124908438/attempt_02/tables/table5_full_future_components.md) |
| `short_window_announcement_returns` / `table6_model3` | executed | Delta-ATO .000881 (p=.301) versus .002 (t=2.01): loses published significance. SUR stays positive/significant; delta-PM changes nonsignificant sign. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124908438/attempt_02/tables/table6_model3.md) |
| `analyst_forecast_revisions` / `table8_model3` | executed | Delta-ATO .000109 (p=.245) versus .001 (t=2.44): loses significance. Delta-PM .00824 (p=.002) versus .001 (t=.94): gains significance. SUR remains positive/significant. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124908438/attempt_02/tables/table8_model3.md) |

## W3125487088: Measuring Reporting Conservatism

[TAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125487088/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125487088/attempt_02/design.md)

139,737 versus 131,920. Other source coefficients and focal standard error/test unavailable; direction/magnitude comparison only.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `annual_pooled_dt` / `annual_pooled_eq1` | executed | The one reported focal interaction is positive, .2837306 versus .302 (-6.0%); local p<.001. Source supplies no comparable inference for that estimate. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125487088/attempt_02/tables/annual_pooled_eq1.md) |

## W2067475882: Are Selling, General, and Administrative Costs “Sticky”?

[JAR; accepted attempt 3 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2067475882/attempt_03/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2067475882/attempt_03/design.md)

107,562 versus 63,958. Historical source population and item-number mapping unresolved; qualitative agreement does not imply a close numerical match.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `model_i_one_year` / `table2_model_i_one_year` | executed | Stickiness remains negative and strongly significant, but interaction magnitude is about 69.5% smaller: -.05844 versus -.1914. Sales slope .5813 versus .5459. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2067475882/attempt_03/tables/table2_model_i_one_year.md) |

## W2321597487: The Role of Accruals in Asymmetrically Timely Gain and Loss Recognition

[JAR; accepted attempt 3 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/design.md)

Table 3A pooled CF/DD/Jones: 78,963/66,210/75,590 versus 57,362/46,821/54,838. Separate industry counts and all other scopes documented in review. Joint Table 5D is multicollinear per source; historical populations and several scaling/median/trim conventions unspecified.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `a_cf_pooled` / `a_cf_pooled__reported` | executed | Focal book-proxy interaction 1.053 versus published 0.53; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelA_pooled.md) |
| `a_cf_industry` / `a_cf_industry__reported` | executed | Focal book-proxy interaction 0.732 versus published 0.49; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelA_industry.md) |
| `a_dd_pooled` / `a_dd_pooled__reported` | executed | Focal book-proxy interaction 0.822 versus published 0.45; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelA_pooled.md) |
| `a_dd_industry` / `a_dd_industry__reported` | executed | Focal book-proxy interaction 0.504 versus published 0.46; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelA_industry.md) |
| `a_jones_pooled` / `a_jones_pooled__reported` | executed | Focal book-proxy interaction 1.097 versus published 0.58; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelA_pooled.md) |
| `a_jones_industry` / `a_jones_industry__reported` | executed | Focal book-proxy interaction 0.797 versus published 0.46; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelA_industry.md) |
| `b_cf_pooled` / `b_cf_pooled__reported` | executed | Focal book-proxy interaction 0.528 versus published 0.25; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelB_pooled.md) |
| `b_cf_industry` / `b_cf_industry__reported` | executed | Focal book-proxy interaction 0.432 versus published 0.15; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelB_industry.md) |
| `b_dd_pooled` / `b_dd_pooled__reported` | executed | Focal book-proxy interaction 0.386 versus published 0.17; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelB_pooled.md) |
| `b_dd_industry` / `b_dd_industry__reported` | executed | Focal book-proxy interaction 0.332 versus published 0.12; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelB_industry.md) |
| `b_jones_pooled` / `b_jones_pooled__reported` | executed | Focal book-proxy interaction 1.279 versus published 0.38; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelB_pooled.md) |
| `b_jones_industry` / `b_jones_industry__reported` | executed | Focal book-proxy interaction 0.809 versus published 0.11; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelB_industry.md) |
| `c_cf_pooled` / `c_cf_pooled__reported` | executed | Focal book-proxy interaction 0.823 versus published 0.34; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelC_pooled.md) |
| `c_cf_industry` / `c_cf_industry__reported` | executed | Focal book-proxy interaction 0.614 versus published 0.31; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelC_industry.md) |
| `c_dd_pooled` / `c_dd_pooled__reported` | executed | Focal book-proxy interaction 0.783 versus published 0.34; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelC_pooled.md) |
| `c_dd_industry` / `c_dd_industry__reported` | executed | Focal book-proxy interaction 0.381 versus published 0.23; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelC_industry.md) |
| `c_jones_pooled` / `c_jones_pooled__reported` | executed | Focal book-proxy interaction 1.043 versus published 0.48; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelC_pooled.md) |
| `c_jones_industry` / `c_jones_industry__reported` | executed | Focal book-proxy interaction 0.72 versus published 0.35; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table3_panelC_industry.md) |
| `m_cf_pooled` / `m_cf_pooled__reported` | executed | Focal market-return interaction 0.113 versus published 0.13; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table4_pooled.md) |
| `m_cf_industry` / `m_cf_industry__reported` | executed | Focal market-return interaction 0.102 versus published 0.1; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table4_industry.md) |
| `m_dd_pooled` / `m_dd_pooled__reported` | executed | Focal market-return interaction 0.098 versus published 0.12; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table4_pooled.md) |
| `m_dd_industry` / `m_dd_industry__reported` | executed | Focal market-return interaction 0.0841 versus published 0.1; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table4_industry.md) |
| `m_jones_pooled` / `m_jones_pooled__reported` | executed | Focal market-return interaction 0.105 versus published 0.11; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table4_pooled.md) |
| `m_jones_industry` / `m_jones_industry__reported` | executed | Focal market-return interaction 0.0777 versus published 0.07; positive locally with p<.001. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table4_industry.md) |
| `t5_a_cf_pooled` / `t5_a_cf_pooled__reported` | executed | Focal book-proxy interaction 0.7 versus published 0.59; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelA_pooled.md) |
| `t5_a_cf_industry` / `t5_a_cf_industry__reported` | executed | Focal book-proxy interaction 0.476 versus published 0.3; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelA_industry.md) |
| `t5_a_dd_pooled` / `t5_a_dd_pooled__reported` | executed | Focal book-proxy interaction 0.568 versus published 0.5; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelA_pooled.md) |
| `t5_a_dd_industry` / `t5_a_dd_industry__reported` | executed | Focal book-proxy interaction 0.356 versus published 0.3; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelA_industry.md) |
| `t5_a_jones_pooled` / `t5_a_jones_pooled__reported` | executed | Focal book-proxy interaction 0.715 versus published 0.61; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelA_pooled.md) |
| `t5_a_jones_industry` / `t5_a_jones_industry__reported` | executed | Focal book-proxy interaction 0.503 versus published 0.31; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelA_industry.md) |
| `t5_b_cf_pooled` / `t5_b_cf_pooled__reported` | executed | Focal book-proxy interaction 0.272 versus published 0.23; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelB_pooled.md) |
| `t5_b_cf_industry` / `t5_b_cf_industry__reported` | executed | Focal book-proxy interaction 0.204 versus published 0.13; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelB_industry.md) |
| `t5_b_dd_pooled` / `t5_b_dd_pooled__reported` | executed | Focal book-proxy interaction 0.213 versus published 0.14; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelB_pooled.md) |
| `t5_b_dd_industry` / `t5_b_dd_industry__reported` | executed | Focal book-proxy interaction 0.125 versus published 0.1; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelB_industry.md) |
| `t5_b_jones_pooled` / `t5_b_jones_pooled__reported` | executed | Focal book-proxy interaction 0.391 versus published 0.28; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelB_pooled.md) |
| `t5_b_jones_industry` / `t5_b_jones_industry__reported` | executed | Focal book-proxy interaction 0.187 versus published 0.05; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelB_industry.md) |
| `t5_c_cf_pooled` / `t5_c_cf_pooled__reported` | executed | Focal book-proxy interaction 0.419 versus published 0.37; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelC_pooled.md) |
| `t5_c_cf_industry` / `t5_c_cf_industry__reported` | executed | Focal book-proxy interaction 0.315 versus published 0.29; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelC_industry.md) |
| `t5_c_dd_pooled` / `t5_c_dd_pooled__reported` | executed | Focal book-proxy interaction 0.379 versus published 0.36; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelC_pooled.md) |
| `t5_c_dd_industry` / `t5_c_dd_industry__reported` | executed | Focal book-proxy interaction 0.244 versus published 0.22; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelC_industry.md) |
| `t5_c_jones_pooled` / `t5_c_jones_pooled__reported` | executed | Focal book-proxy interaction 0.502 versus published 0.45; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelC_pooled.md) |
| `t5_c_jones_industry` / `t5_c_jones_industry__reported` | executed | Focal book-proxy interaction 0.331 versus published 0.31; positive locally with p<.001. The additional market-return interaction also remains positive with local p<.001; full vectors and source tests are linked. Magnitude agreement varies; source test sidedness is unspecified. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelC_industry.md) |
| `t5_d_cf_pooled` / `t5_d_cf_pooled__reported` | executed | All four joint-model interaction signs positive as in source; local p<=.001. Magnitudes and some source inference differ; source Table 5D notes multicollinearity. See all four interaction rows in the review. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelD_pooled.md) |
| `t5_d_cf_industry` / `t5_d_cf_industry__reported` | executed | Joint model industry-adjusted CF interaction -0.29 published versus 0.00922 local (p=.872): sign reversal. DCF and delta-CF interactions remain positive locally; market interaction positive/significant. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelD_industry.md) |
| `t5_d_dd_pooled` / `t5_d_dd_pooled__reported` | executed | All four joint-model interaction signs positive as in source; local p<=.001. Magnitudes and some source inference differ; source Table 5D notes multicollinearity. See all four interaction rows in the review. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelD_pooled.md) |
| `t5_d_dd_industry` / `t5_d_dd_industry__reported` | executed | Joint model industry-adjusted CF interaction -0.27 published versus 0.0453 local (p=.448): sign reversal. Delta-CF interaction local p=.237; market interaction positive/significant. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelD_industry.md) |
| `t5_d_jones_pooled` / `t5_d_jones_pooled__reported` | executed | All four joint-model interaction signs positive as in source; local p<=.001. Magnitudes and some source inference differ; source Table 5D notes multicollinearity. See all four interaction rows in the review. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelD_pooled.md) |
| `t5_d_jones_industry` / `t5_d_jones_industry__reported` | executed | Joint model industry-adjusted CF interaction -0.15 published versus 0.208 local (p<.001): sign reversal. DCF interaction local p=.125; delta-CF p=.039; market interaction positive/significant. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2321597487/attempt_03/tables/table5_panelD_industry.md) |

## W1987881672: A Temporal Analysis of Earnings Surprises: Profits versus Losses

[JAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/design.md)

16 annual observations per trend; 190,006 underlying events versus 176,519. Fiscal-year proxy and adjusted IBES vintage; source regression covariance unspecified.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `median_surprise_earnings` / `median_surprise_earnings_table1` | executed | This annual trend retains the published direction and significance under conventional two-sided local OLS. N=16 annual observations; magnitude and source annual medians/rates differ. Full nine-fit comparison: source_result_comparison.md in the accepted attempt. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/tables/median_surprise_earnings.md) |
| `median_surprise_profits` / `median_surprise_profits_table1` | executed | This annual trend retains the published direction and significance under conventional two-sided local OLS. N=16 annual observations; magnitude and source annual medians/rates differ. Full nine-fit comparison: source_result_comparison.md in the accepted attempt. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/tables/median_surprise_profits.md) |
| `median_surprise_losses` / `median_surprise_losses_table1` | executed | This annual trend retains the published direction and significance under conventional two-sided local OLS. N=16 annual observations; magnitude and source annual medians/rates differ. Full nine-fit comparison: source_result_comparison.md in the accepted attempt. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/tables/median_surprise_losses.md) |
| `zero_surprise_profits` / `zero_surprise_profits_table1` | executed | This annual trend retains the published direction and significance under conventional two-sided local OLS. N=16 annual observations; magnitude and source annual medians/rates differ. Full nine-fit comparison: source_result_comparison.md in the accepted attempt. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/tables/zero_surprise_profits.md) |
| `zero_surprise_losses` / `zero_surprise_losses_table1` | executed | This annual trend retains the published direction and significance under conventional two-sided local OLS. N=16 annual observations; magnitude and source annual medians/rates differ. Full nine-fit comparison: source_result_comparison.md in the accepted attempt. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/tables/zero_surprise_losses.md) |
| `positive_surprise_profits` / `positive_surprise_profits_table1` | executed | This annual trend retains the published direction and significance under conventional two-sided local OLS. N=16 annual observations; magnitude and source annual medians/rates differ. Full nine-fit comparison: source_result_comparison.md in the accepted attempt. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/tables/positive_surprise_profits.md) |
| `positive_surprise_losses` / `positive_surprise_losses_table1` | executed | This annual trend retains the published direction and significance under conventional two-sided local OLS. N=16 annual observations; magnitude and source annual medians/rates differ. Full nine-fit comparison: source_result_comparison.md in the accepted attempt. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/tables/positive_surprise_losses.md) |
| `small_positive_profit_surprise` / `small_positive_profit_surprise_table1` | executed | This annual trend retains the published direction and significance under conventional two-sided local OLS. N=16 annual observations; magnitude and source annual medians/rates differ. Full nine-fit comparison: source_result_comparison.md in the accepted attempt. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/tables/small_positive_profit_surprise.md) |
| `extreme_negative_loss_surprise` / `extreme_negative_loss_surprise_table1` | executed | This annual trend retains the published direction and significance under conventional two-sided local OLS. N=16 annual observations; magnitude and source annual medians/rates differ. Full nine-fit comparison: source_result_comparison.md in the accepted attempt. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1987881672/attempt_02/tables/extreme_negative_loss_surprise.md) |

## W3126000559: The Impact of Financial Reporting Quality on Debt Contracting: Evidence from Internal Control Weakness Reports

[JAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126000559/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126000559/attempt_02/design.md)

Main 223 versus 2,828; secured 212; general covenants 37; PP probit 88 versus 2,045. Severe borrower/rating linkage loss and small-cluster/separation limits; not an equivalent source population.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `icw_financial_covenants` / `icw_financial_covenants_primary_col_1` | executed | Uncorrected/corrected -.537/-.146, p=.141/.672 versus -.362/-.500, source p=.00/.00: both lose significance. N 223 versus 2,828. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126000559/attempt_02/tables/table3_financial_covenants.md) |
| `icw_interest_rate` / `icw_interest_rate_primary_col_1` | executed | Uncorrected/corrected -5.732/+8.629, p=.856/.701 versus +28.959/-.386, p=.04/.98: both reverse signs; uncorrected significance lost. N 223 versus 2,828. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126000559/attempt_02/tables/table4_interest_rate.md) |
| `icw_secured` / `icw_secured_primary_col_1` | executed | Uncorrected/corrected -1.170/-1.767, p=.066/.001 versus +.282/+.494, p=.04/.00: both reverse signs. N 212 versus 2,828; perfect-prediction removals. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126000559/attempt_02/tables/table5_loan_mechanisms.md) |
| `icw_general_covenants` / `icw_general_covenants_primary_col_2` | executed | Uncorrected/corrected -.946/-.811, p=.291/.250 versus -.050/+.121, p=.88/.75: both nonsignificant, corrected sign changes. N 37 versus 2,828; omnibus cluster test unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126000559/attempt_02/tables/table5_loan_mechanisms.md) |
| `icw_maturity` / `icw_maturity_primary_col_3` | executed | Uncorrected/corrected +.186/+.148, p=.215/.217 versus -.003/+.095, p=.94/.15: both nonsignificant, uncorrected sign changes. N 223 versus 2,828. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126000559/attempt_02/tables/table5_loan_mechanisms.md) |
| `icw_pp_ratio` / `icw_pp_ratio_primary_col_1` | executed | Uncorrected/corrected -9.127/-4.217, p=.003/.052 versus -.507/-.067, p=.02/.79: 5% decisions agree but magnitudes differ greatly and corrected result is marginal at 10%. N 88 versus 2,045; separation note. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3126000559/attempt_02/tables/table6_pp_ratio.md) |

## W2065676679: Biases and Lags in Book Value and Their Effects on the Ability of the Book-to-Market Ratio to Predict Book Return on Equity

[JAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/design.md)

4,409 versus 6,044 in each of ten fits. Robust Wald is not source classical partial F; common-income and primary-share market-value proxies; historical PST returns unavailable.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `roe_btm_benchmark` / `panel_a_h1` | executed | ROE0 0.313 versus 0.183; BTM -0.119 versus -0.119. Directions agree. N 4,409 versus 6,044; see native table for individual inference. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/tables/table5_panel_a.md) |
| `roe_btm_benchmark` / `panel_a_h2` | executed | ROE0 0.17 versus 0.122; BTM -0.098 versus -0.089. Directions agree. N 4,409 versus 6,044; see native table for individual inference. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/tables/table5_panel_a.md) |
| `roe_btm_benchmark` / `panel_a_h3` | executed | ROE0 0.214 versus 0.03; BTM -0.065 versus -0.088. Directions agree. N 4,409 versus 6,044; see native table for individual inference. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/tables/table5_panel_a.md) |
| `roe_btm_benchmark` / `panel_a_h4` | executed | ROE0 0.18 versus 0.053; BTM -0.06 versus -0.077. Directions agree. N 4,409 versus 6,044; see native table for individual inference. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/tables/table5_panel_a.md) |
| `roe_btm_benchmark` / `panel_a_h5` | executed | ROE0 0.15 versus 0.092; BTM -0.079 versus -0.048. Directions agree. N 4,409 versus 6,044; see native table for individual inference. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/tables/table5_panel_a.md) |
| `roe_components_full` / `panel_b_h1` | executed | Bias-minus-lag contrast 0.097 versus 0.135. Incremental robust Wald p=<.001 versus source classical F=37.6. These test procedures differ. N 4,409 versus 6,044. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/tables/table5_panel_b.md) |
| `roe_components_full` / `panel_b_h2` | executed | Bias-minus-lag contrast 0.092 versus 0.13. Incremental robust Wald p=<.001 versus source classical F=33.0. These test procedures differ. N 4,409 versus 6,044. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/tables/table5_panel_b.md) |
| `roe_components_full` / `panel_b_h3` | executed | Bias-minus-lag contrast -0.009 versus 0.074. Incremental robust Wald p=.064 versus source classical F=10.3. These test procedures differ. N 4,409 versus 6,044. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/tables/table5_panel_b.md) |
| `roe_components_full` / `panel_b_h4` | executed | Bias-minus-lag contrast 0.006 versus -0.02. Incremental robust Wald p=<.001 versus source classical F=2.7. These test procedures differ. N 4,409 versus 6,044. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/tables/table5_panel_b.md) |
| `roe_components_full` / `panel_b_h5` | executed | Bias-minus-lag contrast -0.02 versus -0.004. Incremental robust Wald p=.005 versus source classical F=5.1. These test procedures differ. N 4,409 versus 6,044. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2065676679/attempt_02/tables/table5_panel_b.md) |

**Supporting construction models** (no separate campaign comparison scope): `btm_components_eq4`. See linked design/native logs for their internal fit coverage.

## W3124170598: Performance matched discretionary accrual measures

[JAE; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124170598/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124170598/attempt_02/design.md)

Common descriptive sample 124,351 versus 122,798 (+1.26%). These are descriptive-distribution comparisons, not baseline coefficient or hypothesis-test matches.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `jones_eq6` / `no_published_coefficient_set` | executed | No published coefficient target for this regression family. Residual SD 14.65% of assets versus 9.98%; distributions differ. Common residual comparison N 124,351 versus 122,798; these are descriptive targets, not coefficient tests. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124170598/attempt_02/tables/table1_panel_a.md) |
| `modified_jones_eq6` / `no_published_coefficient_set` | executed | No published coefficient target for this regression family. Residual SD 14.91% of assets versus 10.33%; distributions differ. Common residual comparison N 124,351 versus 122,798; these are descriptive targets, not coefficient tests. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124170598/attempt_02/tables/table1_panel_a.md) |
| `jones_roa_lag_eq7` / `no_published_coefficient_set` | executed | No published coefficient target for this regression family. Residual SD 14.58% of assets versus 9.62%; distributions differ. Common residual comparison N 124,351 versus 122,798; these are descriptive targets, not coefficient tests. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124170598/attempt_02/tables/table1_panel_a.md) |
| `jones_roa_current_eq7` / `no_published_coefficient_set` | executed | No published coefficient target for this regression family. Residual SD 13.95% of assets versus 10.65%; distributions differ. Common residual comparison N 124,351 versus 122,798; these are descriptive targets, not coefficient tests. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124170598/attempt_02/tables/table1_panel_a.md) |
| `modified_jones_roa_lag_eq7` / `no_published_coefficient_set` | executed | No published coefficient target for this regression family. Residual SD 14.82% of assets versus 9.94%; distributions differ. Common residual comparison N 124,351 versus 122,798; these are descriptive targets, not coefficient tests. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124170598/attempt_02/tables/table1_panel_a.md) |
| `modified_jones_roa_current_eq7` / `no_published_coefficient_set` | executed | No published coefficient target for this regression family. Residual SD 14.31% of assets versus 10.98%; distributions differ. Common residual comparison N 124,351 versus 122,798; these are descriptive targets, not coefficient tests. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124170598/attempt_02/tables/table1_panel_a.md) |

## W3124365414: Earnings Management through Real Activities Manipulation

[JAE; accepted attempt 4 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124365414/attempt_04/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124365414/attempt_04/design.md)

50,520 versus 21,758; 15 annual fits. Newey-West bandwidth assumed; source discretion-expense wording conflicts. Review statement about unchanged significance refers to A3-to-A4, not source agreement.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `abnormal_cfo_eq6` / `abnormal_cfo_eq6_table4` | executed | Suspect coefficient -.0129535, p=.056 versus -.0200, t=-3.05: same sign, loses two-sided 5% significance. N 50,520 versus 21,758; Newey-West bandwidth assumed. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124365414/attempt_04/tables/table4_main.md) |
| `abnormal_disexp_eq6` / `abnormal_disexp_eq6_table4` | executed | Suspect coefficient -.0668535, p<.001 versus -.0591, t=-4.35: same negative/significant finding. N 50,520 versus 21,758; Newey-West bandwidth assumed. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124365414/attempt_04/tables/table4_main.md) |
| `abnormal_prod_eq6` / `abnormal_prod_eq6_table4` | executed | Suspect coefficient +.0460897, p<.001 versus +.0497, t=4.99: same positive/significant finding. N 50,520 versus 21,758; Newey-West bandwidth assumed. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124365414/attempt_04/tables/table4_main.md) |

**Supporting construction models** (no separate campaign comparison scope): `normal_cfo_eq1`, `normal_prod_eq4`, `normal_disexp_eq5`. See linked design/native logs for their internal fit coverage.

## W3123227524: Accrual-Based and Real Earnings Management Activities Around Seasoned Equity Offerings

[JAE; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123227524/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123227524/attempt_02/design.md)

2,030 local model observations; published Table 6 N unavailable. Paper-wide offers 1,511 versus 2,070 local. SDC categories and matching/event-year rules approximate. Corrects review prose saying RM1 was insignificant at 10%; its printed .093 is below .10.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `t6_da` / `table6_a_col_6` | executed | Focal coefficient -0.066, p=0.313 versus -0.126 (source significant). Negative sign retained, 5% significance lost. N 2,030; source model N not reported. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123227524/attempt_02/tables/table6_a_col6.md) |
| `t6_cfo` / `table6_b_col_7` | executed | Focal coefficient -0.09, p=0.111 versus -0.158 (source significant). Negative sign retained, 5% significance lost. N 2,030; source model N not reported. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123227524/attempt_02/tables/table6_b_col7.md) |
| `t6_prod` / `table6_c_col_7` | executed | Focal coefficient 0.023, p=0.532 versus -0.256 (source significant). Sign reverses. N 2,030; source model N not reported. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123227524/attempt_02/tables/table6_c_col7.md) |
| `t6_disx` / `table6_d_col_7` | executed | Focal coefficient 0.076, p=0.045 versus -0.167 (source significant). Sign reverses. N 2,030; source model N not reported. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123227524/attempt_02/tables/table6_d_col7.md) |
| `t6_rm1` / `table6_e_col_7` | executed | Focal coefficient -0.036, p=0.093 versus -0.237 (source significant). Negative sign retained, 5% significance lost. N 2,030; source model N not reported. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123227524/attempt_02/tables/table6_e_col7.md) |
| `t6_rm2` / `table6_f_col_7` | executed | Focal coefficient -0.029, p=0.24 versus -0.221 (source significant). Negative sign retained, 5% significance lost. N 2,030; source model N not reported. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123227524/attempt_02/tables/table6_f_col7.md) |

**Supporting construction models** (no separate campaign comparison scope): `s_da_jones`, `s_cfo`, `s_prod`, `s_disx`. See linked design/native logs for their internal fit coverage.

## W2084956342: Accrual reliability, earnings persistence and stock prices

[JAE; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2084956342/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2084956342/attempt_02/design.md)

127,722 versus 108,617; 40 annual fits. Historical population/SIC/link choices unresolved; source descriptive winsorization status unstated. A2 reuses unchanged A1 construction and independently reruns Stata.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `table5_panel_c_extended_multivariate` / `table5_panel_c_final_multivariate` | executed | All seven accrual-component directions and significance patterns agree: six negative/significant and DSTI positive/nonsignificant. ROA .8099 versus .801; adjusted R2 .637 versus .595. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2084956342/attempt_02/tables/table5c_final.md) |

## W3121620818: Discretionary-accruals models and audit qualifications

[JAE; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121620818/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121620818/attempt_02/design.md)

950 observations / 475 pairs versus 346 / 173 pairs. Source one-sided comparisons checked separately from two-sided exports; qualification population, Big Six crosswalk, and matching conventions unresolved.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `t7_ts_jones` / `t7_ts_jones_table7` | executed | DA .912 (two-sided p=.200; one-sided .100) versus 1.734 (source one-sided p=.179): both positive/nonsignificant at 5%. N 950 versus 346. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121620818/attempt_02/tables/table7_ts_jones.md) |
| `t7_ts_modified_jones` / `t7_ts_modified_jones_table7` | executed | DA 1.051 (two-sided p=.128; one-sided .064) versus 1.849 (source one-sided p=.156): both positive/nonsignificant at 5%. N 950 versus 346. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121620818/attempt_02/tables/table7_ts_modified_jones.md) |
| `t7_cs_jones` / `t7_cs_jones_table7` | executed | DA 3.705 (two-sided p=.0006) versus 4.737 (source one-sided p=.007): both positive/significant. N 950 versus 346. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121620818/attempt_02/tables/table7_cs_jones.md) |
| `t7_cs_modified_jones` / `t7_cs_modified_jones_table7` | executed | DA 3.718 (two-sided p=.0003) versus 3.938 (source one-sided p=.016): both positive/significant. N 950 versus 346. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121620818/attempt_02/tables/table7_cs_modified_jones.md) |

**Supporting construction models** (no separate campaign comparison scope): `construction_ts_jones`, `construction_cs_jones`. See linked design/native logs for their internal fit coverage.

## W3123284902: Do investors overvalue firms with bloated balance sheets?

[JAE; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123284902/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123284902/attempt_02/design.md)

438 monthly fits each; 1,174,665/1,153,631/1,122,680 local firm-months. Comparable source firm-month N not reported. Historical information timing and raw-return/FX conventions remain assumptions.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `table5_model4_panels_a_c` / `t5_model4_panel_a` | executed | Accruals/NOA -.009226/-.005742 versus -.0079/-.0058: both negative/significant. 438 monthly estimates; local firm-month N 1,174,665. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123284902/attempt_02/tables/table5_panel_a_model4.md) |
| `table5_model4_panels_a_c` / `t5_model4_panel_b` | executed | Accruals/NOA -.004268/-.004429 versus -.0062/-.0023: both negative/significant, NOA more negative. 438 monthly estimates; local N 1,153,631. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123284902/attempt_02/tables/table5_panel_b_model4.md) |
| `table5_model4_panels_a_c` / `t5_model4_panel_c` | executed | Accruals -.001822 versus -.0019, nonsignificant in both; NOA -.002063 versus -.0024, significant in both. 438 monthly estimates; local N 1,122,680. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123284902/attempt_02/tables/table5_panel_c_model4.md) |

## W3123899283: Earnings volatility and earnings predictability

[JAE; accepted attempt 3 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/design.md)

Full sample 26,236 versus 22,113; exploratory 13,175 versus 11,061. Fit-specific Ns differ by horizon/quintile. Original split seed unknown; required early OANCF coverage missing, so local complete history excludes target 1988–1990. Simulation tail 0/1,000 is finite-resolution evidence.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `earnings_persistence_horizons_1_5` / `full_h1` | executed | Persistence slope 0.722 versus 0.652, positive/significant. N 11137 versus 9102. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h1.md) |
| `earnings_persistence_horizons_1_5` / `vol_q1_h1` | executed | Persistence slope 0.927 versus 0.934, positive/significant. N 2329 versus 1899. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h1.md) |
| `earnings_persistence_horizons_1_5` / `vol_q2_h1` | executed | Persistence slope 0.873 versus 0.888, positive/significant. N 2261 versus unreported. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h1.md) |
| `earnings_persistence_horizons_1_5` / `vol_q3_h1` | executed | Persistence slope 0.838 versus 0.838, positive/significant. N 2260 versus unreported. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h1.md) |
| `earnings_persistence_horizons_1_5` / `vol_q4_h1` | executed | Persistence slope 0.715 versus 0.755, positive/significant. N 2190 versus unreported. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h1.md) |
| `earnings_persistence_horizons_1_5` / `vol_q5_h1` | executed | Persistence slope 0.632 versus 0.507, positive/significant. N 2097 versus 1682. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h1.md) |
| `earnings_persistence_horizons_1_5` / `full_h2` | executed | Persistence slope 0.524 versus 0.484, positive/significant. N 9336 versus 7502. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `full_h3` | executed | Persistence slope 0.455 versus 0.449, positive/significant. N 7803 versus 6147. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `full_h4` | executed | Persistence slope 0.387 versus 0.421, positive/significant. N 6440 versus 5011. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `full_h5` | executed | Persistence slope 0.381 versus 0.381, positive/significant. N 5214 versus 4032. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `high_vol_h2` | executed | Persistence slope 0.369 versus 0.287, positive/significant. N 1643 versus 1314. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `high_vol_h3` | executed | Persistence slope 0.301 versus 0.261, positive/significant. N 1276 versus 1029. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `high_vol_h4` | executed | Persistence slope 0.192 versus 0.241, positive/significant. N 968 versus 822. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `high_vol_h5` | executed | Persistence slope 0.235 versus 0.177, positive/significant. N 732 versus 659. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `low_vol_h2` | executed | Persistence slope 0.872 versus 0.867, positive/significant. N 2042 versus 1620. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `low_vol_h3` | executed | Persistence slope 0.8 versus 0.774, positive/significant. N 1790 versus 1365. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `low_vol_h4` | executed | Persistence slope 0.751 versus 0.812, positive/significant. N 1562 versus 1140. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `earnings_persistence_horizons_1_5` / `low_vol_h5` | executed | Persistence slope 0.782 versus 0.805, positive/significant. N 1309 versus 922. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/persistence_h2_h5.md) |
| `five_year_sum_earnings` / `five_year_sum_full` | executed | Persistence slope 2.457 versus 2.359, positive/significant. N 5186 versus 4032. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/five_year_sum.md) |
| `five_year_sum_earnings` / `five_year_sum_high_vol` | executed | Persistence slope 1.599 versus 1.372, positive/significant. N 726 versus 659. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/five_year_sum.md) |
| `five_year_sum_earnings` / `five_year_sum_low_vol` | executed | Persistence slope 4.306 versus 4.205, positive/significant. N 1306 versus 922. Lower persistence at higher volatility and reported Q1-Q5 rejections persist; R2 differs. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123899283/attempt_03/tables/five_year_sum.md) |

## W3125741632: Asymmetric timeliness of earnings, market-to-book and conservatism in financial reporting

[JAE; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125741632/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125741632/attempt_02/design.md)

49,354 versus 45,664; 28 annual fits per scope. Source contains sign/decimal typos; reviewed original tables/prose control. Tests of level, sum, and change are distinct.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `beginning_mtb_future_timeliness` / `forward_k1` | executed | b1/g1/combined levels retain negative significance at k=1. Combined slope -0.0770251 versus -0.1114. Adjacent tests differ: k2-k1 g1 loses 5% significance; k3-k2 b1 gains it. Shared contrast findings, not additional fits. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125741632/attempt_02/tables/table4a_forward.md) |
| `beginning_mtb_future_timeliness` / `forward_k2` | executed | b1/g1/combined levels retain negative significance at k=2. Combined slope -0.1233755 versus -0.1724. Adjacent tests differ: k2-k1 g1 loses 5% significance; k3-k2 b1 gains it. Shared contrast findings, not additional fits. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125741632/attempt_02/tables/table4a_forward.md) |
| `beginning_mtb_future_timeliness` / `forward_k3` | executed | b1/g1/combined levels retain negative significance at k=3. Combined slope -0.1407305 versus -0.1788. Adjacent tests differ: k2-k1 g1 loses 5% significance; k3-k2 b1 gains it. Shared contrast findings, not additional fits. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125741632/attempt_02/tables/table4a_forward.md) |
| `ending_mtb_historical_timeliness` / `historical_j0` | executed | Historical j=0: b1/g1 signs and 5% decisions agree. Combined bad-news slope -0.0323612 versus -0.0383; combined-level inference agrees; adjacent-change discrepancies are documented separately. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125741632/attempt_02/tables/table5a_backward.md) |
| `ending_mtb_historical_timeliness` / `historical_j1` | executed | Historical j=1: b1/g1 signs and 5% decisions agree. Combined bad-news slope -0.0307694 versus -0.0315; combined-level inference agrees; adjacent-change discrepancies are documented separately. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125741632/attempt_02/tables/table5a_backward.md) |
| `ending_mtb_historical_timeliness` / `historical_j2` | executed | Historical j=2: b1/g1 signs and 5% decisions agree. Combined bad-news slope -0.0086599 versus -0.0114; combined-level inference agrees; adjacent-change discrepancies are documented separately. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125741632/attempt_02/tables/table5a_backward.md) |
| `ending_mtb_historical_timeliness` / `historical_j3` | executed | Historical j=3: b1/g1 signs and 5% decisions agree. Combined bad-news slope -0.0045085 versus -0.0196; combined-level inference agrees; adjacent-change discrepancies are documented separately. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125741632/attempt_02/tables/table5a_backward.md) |
| `ending_mtb_historical_timeliness` / `historical_j4` | executed | Historical j=4: b1/g1 signs and 5% decisions agree. Combined bad-news slope -0.0434492 versus -0.0217; local p=.027 gains significance versus source t=-1.00. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125741632/attempt_02/tables/table5a_backward.md) |

## W3123370480: The implied cost of capital: A new approach

[JAE; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123370480/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123370480/attempt_02/design.md)

41 rolling fits per horizon; overlapping local training-row Ns are not comparable to source forecast-coverage counts. Newey-West lag 3 and training-window interpretation assumed; installed lag covariance supports individual tests, not a full joint HAC test.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `earnings_forecast_eq1` / `table1_1yr` | executed | Earnings 0.7841 versus 0.8304 remains positive/significant. Accruals -0.0488 versus -0.0725: negative/significant. Dividend dummy gains significance; negative-earnings dummy loses 5% significance. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123370480/attempt_02/tables/table1_panel_b_eq1.md) |
| `earnings_forecast_eq1` / `table1_2yr` | executed | Earnings 0.7175 versus 0.7924 remains positive/significant. Accruals -0.0485 versus -0.0848: negative/significant. Dividend dummy gains significance; negative-earnings dummy loses 5% significance. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123370480/attempt_02/tables/table1_panel_b_eq1.md) |
| `earnings_forecast_eq1` / `table1_3yr` | executed | Earnings 0.7225 versus 0.7871 remains positive/significant. Accruals -0.0455 versus -0.0932: loses two-sided 5% significance (t=-1.93). Dividend dummy gains significance; negative-earnings dummy remains significant. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123370480/attempt_02/tables/table1_panel_b_eq1.md) |

## W2015142764: Financial reporting quality and idiosyncratic return volatility

[JAE; accepted attempt 3 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2015142764/attempt_03/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2015142764/attempt_03/design.md)

27,363/30,594 versus 95,270/99,643. Severe sample shortfall; unspecified GMM instruments replaced by RHS self-instruments, producing OLS point estimates with panel HAC inference.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `baseline_dd` / `table3_col_1` | executed | TIME x DD .0058138, p=.008 versus .017, t=10.51; positive/significant but much smaller. N 27,363 versus 95,270. GMM moment specification is approximate. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2015142764/attempt_03/tables/table3_dd.md) |
| `baseline_abacc2` / `table3_col_2` | executed | TIME x ABACC2 .0095975, p=.008 versus .012, t=4.62; positive/significant. N 30,594 versus 99,643. GMM moment specification is approximate. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2015142764/attempt_03/tables/table3_abacc2.md) |

**Supporting construction models** (no separate campaign comparison scope): `construct_dd`, `construct_abacc`, `construct_ff3_daily`. See linked design/native logs for their internal fit coverage.

## W3124466116: Tax‐Avoidance Activities of U.S. Multinational Corporations*

[CAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124466116/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124466116/attempt_02/design.md)

182 versus 16,750; only 38 local domestic and 144 multinational observations. Severe geographic-segment and MNC-status coverage/semantic limits; source mixes one-sided and two-sided tests.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `table4_eq2` / `table4_col2` | executed | MNC reverses from -.0633 to +.3265 (local p=.004); its SIZE/PTI interactions also reverse and lose significance. Most other published focal effects are absent. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124466116/attempt_02/tables/table4_col2.md) |

## W3125018794: The Relation between Analysts' Forecasts of Long‐Term Earnings Growth and Stock Price Performance Following Equity Offerings*

[CAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125018794/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125018794/attempt_02/design.md)

818 versus 1,179. Independent-error conditional Gaussian likelihood is an identification approximation to unspecified source WLS; source growth-start date conflicts.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `table7_all_deals_forecast_error` / `table7_panel_a_all_deals_forecast_error` | executed | Forecast alpha0 changes from -.058 to +.0323; alpha1 remains negative/significant (-.6072 versus -.329). Shared system tests change: efficiency p=.0601 versus .001; naive expectations p=5.50e-20 versus .516. Approximate conditional likelihood. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125018794/attempt_02/tables/table7_joint_system.md) |
| `table7_all_deals_abnormal_returns` / `table7_panel_a_all_deals_abnormal_returns` | executed | Return-equation alpha1* reverses from +.138/nonsignificant to -.7245/significant; beta1 3.480 versus 1.163. Shared system tests change: efficiency p=.0601 versus .001; naive expectations p=5.50e-20 versus .516. Approximate conditional likelihood. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125018794/attempt_02/tables/table7_joint_system.md) |

**Supporting construction models** (no separate campaign comparison scope): `realized_growth_line`. See linked design/native logs for their internal fit coverage.

## W3125232597: Financial Statement Comparability and the Efficiency of Acquisition Decisions

[CAR; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125232597/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125232597/attempt_02/design.md)

1,334/1,332/1,041 versus 1,307/1,277/1,042. Source focal inference one-sided; even corresponding expected-direction tests do not restore significance. Deal-value proxy and comparability coverage remain limits. Uses final A2, not earlier A1 counts.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `table3_acq_car` / `table3_acq_car_main` | executed | Comparability -.005 (p=.616) versus +.017 (t=2.04): sign reverses, significance lost. N 1,334 versus 1,307. Published focal tests are one-sided; local expected-sign tests also do not reach 5%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125232597/attempt_02/tables/table3_acq_car.md) |
| `table3_synergy` / `table3_synergy_main` | executed | Comparability +.003 (p=.753) versus +.018 (t=2.22): significance lost. N 1,332 versus 1,277. Published focal tests are one-sided; local expected-sign tests also do not reach 5%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125232597/attempt_02/tables/table3_synergy.md) |
| `table3_delta_roa` / `table3_delta_roa_main` | executed | Comparability +.010 (p=.313) versus +.025 (t=2.51): significance lost. N 1,041 versus 1,042. Published focal tests are one-sided; local expected-sign tests also do not reach 5%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125232597/attempt_02/tables/table3_delta_roa.md) |

**Supporting construction models** (no separate campaign comparison scope): `comparability_map`, `sync_fit`, `market_model_returns`. See linked design/native logs for their internal fit coverage.

## W11897853: Capitalization versus Expensing: Evidence on the Uncertainty of Future Earnings from Capital Expenditures versus R&D Outlays

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W11897853/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W11897853/attempt_02/design.md)

22,951/21,929/14,817 versus 42,776/40,569/29,408. Large sample shortfall, advertising availability, and share/asset-timing source ambiguities; numerical match not achieved.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `current_outlays_bve` / `current_outlays_bve_selected_table` | executed | R&D/CapEx .196/.097 versus .067/.021; both positive/significant, R&D larger. Local R&D-minus-CapEx NW t=7.55. N 22,951 versus 42,776. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W11897853/attempt_02/tables/table3_panel_a.md) |
| `current_outlays_price` / `current_outlays_price_selected_table` | executed | R&D/CapEx .257/.094 versus .072/.028; both positive/significant, R&D larger. N 21,929 versus 40,569. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W11897853/attempt_02/tables/table3_panel_b.md) |
| `capitalized_investments_bve` / `capitalized_investments_bve_selected_table` | executed | Capitalized R&D/PPE .080/.018 versus .041/.009; both positive/significant, R&D larger. N 14,817 versus 29,408. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W11897853/attempt_02/tables/table4_panel_b.md) |

## W3121262606: The Predictive Value of Expenses Excluded from Pro Forma Earnings

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/design.md)

Local Ns range 133,147–172,513; source reports parent N 143,462 but no like-for-like horizon-specific regression Ns. IBES basic/diluted actual flag missing; cash-flow mappings and split bases approximate; printed variance formula differs from standard package formula.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `cfo_total` / `cfo_total_cfo_sum1` | executed | 4-quarter total-exclusion slope -1.254 versus -1.12; negative/significant in both. Magnitude larger locally, especially FCF. Published fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/cfo_total_cfo_sum1.md) |
| `cfo_total` / `cfo_total_cfo_sum2` | executed | 8-quarter total-exclusion slope -2.452 versus -2.21; negative/significant in both. Magnitude larger locally, especially FCF. Published fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/cfo_total_cfo_sum2.md) |
| `cfo_total` / `cfo_total_cfo_sum3` | executed | 12-quarter total-exclusion slope -3.577 versus -3.328; negative/significant in both. Magnitude larger locally, especially FCF. Published fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/cfo_total_cfo_sum3.md) |
| `cfo_components` / `cfo_components_cfo_sum1` | executed | 4-quarter components: special items positive/nonsignificant, other exclusions negative/significant in both. See review for both coefficient magnitudes; source fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/cfo_components_cfo_sum1.md) |
| `cfo_components` / `cfo_components_cfo_sum2` | executed | 8-quarter components: special items positive/nonsignificant, other exclusions negative/significant in both. See review for both coefficient magnitudes; source fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/cfo_components_cfo_sum2.md) |
| `cfo_components` / `cfo_components_cfo_sum3` | executed | 12-quarter components: special items positive/nonsignificant, other exclusions negative/significant in both. See review for both coefficient magnitudes; source fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/cfo_components_cfo_sum3.md) |
| `fcf_total` / `fcf_total_fcf_sum1` | executed | 4-quarter total-exclusion slope -0.955 versus -0.665; negative/significant in both. Magnitude larger locally, especially FCF. Published fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/fcf_total_fcf_sum1.md) |
| `fcf_total` / `fcf_total_fcf_sum2` | executed | 8-quarter total-exclusion slope -1.768 versus -1.255; negative/significant in both. Magnitude larger locally, especially FCF. Published fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/fcf_total_fcf_sum2.md) |
| `fcf_total` / `fcf_total_fcf_sum3` | executed | 12-quarter total-exclusion slope -2.502 versus -1.66; negative/significant in both. Magnitude larger locally, especially FCF. Published fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/fcf_total_fcf_sum3.md) |
| `fcf_components` / `fcf_components_fcf_sum1` | executed | 4-quarter components: special items positive/significant and other exclusions negative/significant in both. See review for both coefficient magnitudes; source fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/fcf_components_fcf_sum1.md) |
| `fcf_components` / `fcf_components_fcf_sum2` | executed | 8-quarter components: special items positive/significant and other exclusions negative/significant in both. See review for both coefficient magnitudes; source fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/fcf_components_fcf_sum2.md) |
| `fcf_components` / `fcf_components_fcf_sum3` | executed | 12-quarter components: special items positive/significant and other exclusions negative/significant in both. See review for both coefficient magnitudes; source fit-specific N unavailable. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121262606/attempt_02/tables/fcf_components_fcf_sum3.md) |

## W1559083449: Using Asset Turnover and Profit Margin to Forecast Changes in Profitability

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1559083449/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1559083449/attempt_02/design.md)

23,425 versus 9,147 for the training regression. Unspecified source estimator/covariance; extreme NOA-growth tail retained because no direct source cutoff exists.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `rnoa_change_model3` / `model3_in_sample` | executed | Weighted delta-ATO remains positive/significant and delta-PM nonsignificant. Published NOA-growth and ATO x PM interaction effects disappear (local p=.458/.905). | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1559083449/attempt_02/tables/table2_model3.md) |

## W3123423002: The persistence of earnings and cash flows and the role of special items: Implications for the accrual anomaly

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123423002/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123423002/attempt_02/design.md)

70,084 versus 61,989 in both models. Source and template use different star legends; inference comparison uses the stated thresholds, not star counts.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `earnings_persistence_opacc_m6` / `opacc_column6` | executed | Low-OPACC interaction -.128 versus -.137; additional special-item interaction -.172 versus -.197: both negative/significant. N 70,084 versus 61,989. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123423002/attempt_02/tables/table2_panel_a.md) |
| `earnings_persistence_tacc_m6` / `tacc_column6` | executed | Low-TACC interaction -.066 versus -.026; additional special-item interaction -.247 versus -.300: both negative/significant. N 70,084 versus 61,989. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3123423002/attempt_02/tables/table2_panel_b.md) |

## W2015391739: Asymmetric timeliness tests of accounting conservatism

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2015391739/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2015391739/attempt_02/design.md)

Actual bad/good 39,201/50,787 versus 20,618/29,333; simulated 39,140/50,848 versus 20,498/29,453. Original simulation seed unknown; only the retained single-draw regressions are assessed, not an equivalence test or repeated-simulation result.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `bad_news_actual` / `bad_news_actual_table2_col2` | executed | Slope .329 versus .284; positive/significant. N 39,201 versus 20,618; R2 .094 versus .086. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2015391739/attempt_02/tables/table2_panelA.md) |
| `bad_news_simulated` / `bad_news_simulated_table2_col3` | executed | Slope .460 versus .493; positive/significant. N 39,140 versus 20,498; R2 .195 versus .243. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2015391739/attempt_02/tables/table2_panelA.md) |
| `good_news_actual` / `good_news_actual_table2_col2` | executed | Slope .032 versus .025; positive/significant. N 50,787 versus 29,333; R2 .007 versus .006. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2015391739/attempt_02/tables/table2_panelB.md) |
| `good_news_simulated` / `good_news_simulated_table2_col3` | executed | Slope .035 versus .009; positive/significant but about four times source magnitude. N 50,848 versus 29,453; R2 .009 versus .001. Unlike source point estimates, local simulated good-news slope exceeds actual good-news slope. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2015391739/attempt_02/tables/table2_panelB.md) |

**Supporting construction models** (no separate campaign comparison scope): `simulation_generator`. See linked design/native logs for their internal fit coverage.

## W3124580969: Separating Winners from Losers among LowBook-to-Market Stocks using Financial Statement Analysis

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124580969/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124580969/attempt_02/design.md)

3,782 versus 21,253 complete regression observations. Large signal missingness and raw-expense availability losses; source variable-description conflicts and covariance approximation.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `table7_full_controls` / `table7_col2_full_controls` | executed | The focal GSCORE effect loses significance: .0134, p=.124 versus .034, t=5.53. Separate Bernard-adjusted t=1.573 is also nonsignificant. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124580969/attempt_02/tables/table7_col2_fmb.md) |

## W3122432337: Comparing the Value Relevance of Two Operating Income Measures

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122432337/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122432337/attempt_02/design.md)

48,306 versus 22,024 for valuation; 33,602 versus 22,092 for information. Paired slope/Vuong tests were not reproduced; separate p-values cannot establish paired inference. Unresolved IBES EPS basis and extreme STREET tails.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `valuation_street` / `table2_all_groups_street` | executed | STREET slope 2.297 versus 19.28; adjusted R2 .4582 versus .4269. Local EPSOP slope/R2 exceed STREET, opposite the source ranking. N 48,306 versus 22,024. Paired slope-difference/Vuong tests not reproduced. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122432337/attempt_02/tables/table2_valuation_street.md) |
| `valuation_epsop` / `table2_all_groups_epsop` | executed | EPSOP slope 7.185 versus 17.31; adjusted R2 .4904 versus .4205. Local EPSOP slope/R2 exceed STREET, opposite the source ranking. N 48,306 versus 22,024. Paired slope-difference/Vuong tests not reproduced. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122432337/attempt_02/tables/table2_valuation_epsop.md) |
| `information_3day_street` / `table3_three_day_all_groups_street` | executed | ERC .018248 versus 1.3451, significant locally; adjusted R2 .0021 versus .0290. Local ERC/R2 below EPSOP, opposite source. N 33,602 versus 22,092. Paired slope-difference/Vuong tests not reproduced. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122432337/attempt_02/tables/table3_information_street.md) |
| `information_3day_epsop` / `table3_three_day_all_groups_epsop` | executed | ERC .057194 versus .8707, significant locally; adjusted R2 .0072 versus .0228. Local ERC/R2 above STREET, opposite source. N 33,602 versus 22,092. Paired slope-difference/Vuong tests not reproduced. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3122432337/attempt_02/tables/table3_information_epsop.md) |

## W2048409281: What do dividends tell us about earnings quality?

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2048409281/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2048409281/attempt_02/design.md)

Local Ns 16,378/23,208/27,813 and 14,647/20,661/24,343, 22.7%–36.9% below source. IDIT coverage and historical incorporation/FX limits; their contribution to the entire discrepancy is not established.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `earnings_persistence_h1` / `earnings_persistence_h1_1974` | executed | Dividend-persistence interaction 0.0772, p=0.154 versus 0.0314. Published positive/significant finding absent at 5%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2048409281/attempt_02/tables/table4_panelA_h1_1974.md) |
| `earnings_persistence_h1` / `earnings_persistence_h1_1984` | executed | Dividend-persistence interaction -0.049, p=0.507 versus 0.0795. Published positive/significant finding absent at 5%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2048409281/attempt_02/tables/table4_panelA_h1_1984.md) |
| `earnings_persistence_h1` / `earnings_persistence_h1_1994` | executed | Dividend-persistence interaction -0.091, p=0.073 versus 0.0643. Published positive/significant finding absent at 5%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2048409281/attempt_02/tables/table4_panelA_h1_1994.md) |
| `earnings_persistence_h2` / `earnings_persistence_h2_1974` | executed | Dividend-persistence interaction 0.1436, p=0.126 versus 0.0245. Nonsignificant at 5% in both, with different magnitudes. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2048409281/attempt_02/tables/table4_panelB_h2_1974.md) |
| `earnings_persistence_h2` / `earnings_persistence_h2_1984` | executed | Dividend-persistence interaction 0.0038, p=0.963 versus 0.0985. Published positive/significant finding absent at 5%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2048409281/attempt_02/tables/table4_panelB_h2_1984.md) |
| `earnings_persistence_h2` / `earnings_persistence_h2_1994` | executed | Dividend-persistence interaction -0.1116, p=0.236 versus 0.0992. Published positive/significant finding absent at 5%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2048409281/attempt_02/tables/table4_panelB_h2_1994.md) |

## W3124301289: Excess Returns to R&D-Intensive Firms

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124301289/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124301289/attempt_02/design.md)

24,922 regression observations; comparable published regression N not reported (35,841 is a parent count). Source estimator/covariance and some denominator timing unspecified; no exact numerical match claimed.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `W312_s5_eq1_xret` / `section5_eq1` | executed | All three R&D/ARNOA rank slopes remain positive and strongly significant: .102/.262/.464 versus .073/.168/.421; local magnitudes are larger. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124301289/attempt_02/tables/eq1.md) |

## W2105094056: Has goodwill accounting gone bad?

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2105094056/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2105094056/attempt_02/design.md)

Conditional Ns 2,325/9,973/9,140; published Table 1 counts are parent populations, not comparable conditional-fit Ns. Firm strata are assumed because source conditional-logit strata are unspecified; conditional selection is substantial.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `eq1_pre142_estimated` / `table3_panel_a_1` | executed | IMPI gains significance (.256, p=.040 versus .162, z=1.24); BTMG1 remains positive/significant (.560 versus .509). Conditional N 2,325; source fit N unavailable. Firm strata assumed; pseudo-R2 higher locally. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2105094056/attempt_02/tables/table3a_pre_estimated.md) |
| `eq1_post142_estimated` / `table3_panel_a_2` | executed | IMPI/BTMG1 .500/1.127 versus .604/1.114: both positive/significant. Conditional N 9,973; source fit N unavailable. Firm strata assumed; pseudo-R2 higher locally. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2105094056/attempt_02/tables/table3a_post_estimated.md) |
| `eq1_post142_compustat` / `table3_panel_a_3` | executed | IMPI/BTMG1 .431/1.220 versus .494/1.207: both positive/significant. Conditional N 9,140; source fit N unavailable. Firm strata assumed; pseudo-R2 higher locally. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2105094056/attempt_02/tables/table3a_post_compustat.md) |

## W3125558500: An Alternative Interpretation of the Discontinuity in Earnings Distributions

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125558500/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125558500/attempt_02/design.md)

124,572 in each versus 113,113/113,356. Source extra-outlier deletion unspecified; 8,666 unresolved industry classifications retained. Common local sample differs from source panel-specific samples.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `eq1_ni_pretax_regions` / `table4_panel_a` | executed | Four regional slopes .970/1.017/.698/.619 versus .98/1.04/.67/.62; both equality tests reject at p<.001. Adjusted R2 .926 versus .99; N 124,572 versus 113,113. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125558500/attempt_02/tables/table4_panel_a.md) |
| `eq2_pretax_prespc_regions` / `table4_panel_b` | executed | Four regional slopes 2.200/2.207/.892/.967 versus 2.03/1.94/.94/.99; both equality tests reject at p<.001. Adjusted R2 .864 versus .99; N 124,572 versus 113,356. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3125558500/attempt_02/tables/table4_panel_b.md) |

## W3121345849: Evaluating cross-sectional forecasting models for implied cost of capital

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/design.md)

44 annual vectors except RI h3 with 43 identified vectors; source fit-row Ns not reported. First RI h3 annual fit rank deficient; missing-accrual zero rule extended to FX-only construction gaps, explicitly approximate.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `hvz_forecast` / `hvz_forecast_t_1` | executed | Earnings slope 0.9079 versus 0.8715; adjusted R2 90.034% versus 89.6%. Intercept reverses sign and remains significant; other focal slope signs retained. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/tables/hvz_forecast.md) |
| `hvz_forecast` / `hvz_forecast_t_2` | executed | Earnings slope 0.8496 versus 0.8365; adjusted R2 84.171% versus 84.0%. Dividend dummy remains significant but near the cutoff (native p=.049, t=2.03 versus source t=6.58). Intercept loses significance. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/tables/hvz_forecast.md) |
| `hvz_forecast` / `hvz_forecast_t_3` | executed | Earnings slope 0.8358 versus 0.8378; adjusted R2 80.641% versus 80.1%. Dividend dummy loses significance (.0627, t=.10 versus 2.6674, t=8.79); intercept also loses significance. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/tables/hvz_forecast.md) |
| `ep_forecast` / `ep_forecast_t_1` | executed | All predictor directions and significance patterns retained, but magnitudes differ substantially. Adjusted R2 66.4% versus 68.1%. Earnings and negative-earnings interaction values are in the review. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/tables/ep_forecast.md) |
| `ep_forecast` / `ep_forecast_t_2` | executed | All predictor directions and significance patterns retained, but magnitudes differ substantially. Adjusted R2 61.799% versus 51.5%. Earnings and negative-earnings interaction values are in the review. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/tables/ep_forecast.md) |
| `ep_forecast` / `ep_forecast_t_3` | executed | All predictor directions and significance patterns retained, but magnitudes differ substantially. Adjusted R2 56.853% versus 41.5%. Earnings and negative-earnings interaction values are in the review. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/tables/ep_forecast.md) |
| `ri_forecast` / `ri_forecast_t_1` | executed | TACC reverses from -.0034 (t=-2.28) to +.1766 (t=3.19, p=.003); other predictor signs retained. Adjusted R2 70.743% versus 68.1%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/tables/ri_forecast.md) |
| `ri_forecast` / `ri_forecast_t_2` | executed | TACC reverses and loses significance: +.0573 (p=.717) versus -.0217 (t=-10.07). Adjusted R2 66.273% versus 52.1%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/tables/ri_forecast.md) |
| `ri_forecast` / `ri_forecast_t_3` | executed | TACC loses significance: -.0288 (p=.904) versus -.0413 (t=-13.38). 43 identified annual vectors; first requested fit rank deficient. Adjusted R2 61.574% versus 42.5%. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3121345849/attempt_02/tables/ri_forecast.md) |

## W2898309145: Corporate tax avoidance: data truncation and loss firms

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2898309145/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2898309145/attempt_02/design.md)

106,162 versus 111,558 (-4.8%). Historical entity flags and finite-sample two-way covariance choices are approximate; broader descriptive populations are not regression-sample targets.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `full_sample_delta_trend` / `table6_panel_c_all_firms` | executed | The time trend becomes positive/significant: .000244, t=2.25, p=.0335 versus .0001, t=1.15. Effect is about 2.44 times the source estimate. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W2898309145/attempt_02/tables/table6c_all.md) |

## W3124763333: Does the Stock Market Fully Appreciate the Implications of Leading Indicators for Future Earnings? Evidence from Order Backlog

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124763333/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124763333/attempt_02/design.md)

24,696 versus 21,891 (+12.8%). Approximate size-return benchmark and independent-error conditional Gaussian estimator; not a like-for-like rejection of the original study.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `mishkin_forecast` / `table2_forecasting_equation` | executed | Forecast EARN and backlog slopes remain positive; coefficients differ. Shared joint-system backlog equality p=.9631 versus <.001; earnings equality p=.0366 versus .05. N 24,696 versus 21,891. Approximate benchmark and conditional likelihood qualify comparison. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124763333/attempt_02/tables/table2_forecasting_equation.md) |
| `mishkin_returns` / `table2_returns_equation` | executed | Valuation backlog slope nearly equals forecast counterpart locally, unlike source. Shared joint-system backlog equality p=.9631 versus <.001; earnings equality p=.0366 versus .05. N 24,696 versus 21,891. Approximate benchmark and conditional likelihood qualify comparison. | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W3124763333/attempt_02/tables/table2_returns_equation.md) |

## W1509613660: Analyst Forecasting Ability and the Stock Price Reaction to Forecast Revisions

[RAST; accepted attempt 2 review](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1509613660/attempt_02/review.md) · [construction and estimation design](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1509613660/attempt_02/design.md)

4,223 versus 15,446. Large overlapping-event exclusions, consensus/availability conventions, and return benchmark/covariance approximations; normal-versus-inferior remains nonsignificant.

| Model / result set | Execution | Reviewed comparison | Native table |
|---|---|---|---|
| `table4_80_threshold` / `table4_80_threshold` | executed | Superior analyst slope loses significance (.0866, p=.213 versus .2355, t=3.957); normal slope rises to .2384 versus .0890. Superior-normal and superior-inferior equality tests lose 5% rejection (.0784/.5279 versus .025/.015). | [Table](/home/luther/Dropbox/Research/Replication/git/output/reproductions/W1509613660/attempt_02/tables/table4_80_threshold.md) |
