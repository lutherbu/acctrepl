# A4 targeted estimator review and repair

## Currency construction

The accepted A2 build carried no selected-record currency into the accounting calculations. A3 now carries the currency from each chosen `FUNDA` record and translates the current, prior, and lead amounts using that record's own `DATADATE` and `CURCD`. The local Xpressfeed guide specifies daily `EXRATD` for balance-sheet values and 12-month `EXRAT12M` for income and cash-flow values (physical PDF pp. 86–87; printed pp. 78–79). For a non-USD reporting currency, the implemented conversion is reported amount / GBP-to-reporting quote × GBP-to-USD quote. Both quote legs must be positive, unique, and matched to the source date. USD is left at its identity scale. `CURRTR` is not used because the local label does not establish its direction; `EXRATTPD` is retained as provenance and does not screen valid quotes.

The rate tables have no duplicate exact-date/currency groups. The local monthly series starts 31 January 1982 and the daily series starts 1 February 1982. The linked annual panel before sample screens has 99,701 rows: 99,362 USD and 339 CAD. Among CAD rows, current flow FX is unavailable for 264 rows and current stock FX for 281. For present source amounts, the corresponding unavailable conversions are: IB 260, OANCF 0, FOPT 257, SALE 260, AT 278, PPEGT 270, ACT 276, CHE 278, LCT 276, and DLC 278. The early CAD gaps precede the local quote history. These unavailable values propagate through dependent amounts and screens; they are not filled with a guessed currency or rate.

The guarded final panel has 59,585 observations. Its current-record currencies are 59,567 USD and 18 CAD; its selected prior-record currencies are 59,566 USD and 19 CAD. In the 55,064-row Table 2 sample, current currencies are 55,053 USD and 11 CAD, prior currencies are 55,052 USD and 12 CAD, and lead-record currencies are 55,053 USD and 11 CAD. There is one known current/prior currency mismatch in both the final panel and Table 2; the amounts are independently translated at their own dates before they enter a difference or ratio. No current/lead mismatch occurs. Prior-year currency is present for every retained row; a second-prior currency descriptor is blank for 2,198 final rows (2,123 Table 2 rows), but that descriptor is not needed by the selected equations.

All final rows have valid current and prior flow/stock FX flags, and all Table 2 rows have valid lead-flow FX. Three CAD lead-record stock conversions are unavailable (including in Table 2); the lead stock amount is not used for lead earnings, whose denominator is the current-year assets already translated on the current record. No Table 2 observation has a missing current, prior, or lead currency code. Among final CAD rows, three have blank daily rate-type descriptors and 15 have `AR`/`AR`; the Table 2 CAD subset has three blank and eight `AR`/`AR`. Each retained conversion has valid positive same-date quote legs. No actual-only or equal-type rule was added.

The final-path USD identity checks cover all 59,585 retained rows. Maximum absolute numerator errors are 9.09e-13 for earnings, 1.82e-12 for CFO, 1.82e-12 for accruals, 1.11e-16 for inverse assets, 1.82e-12 for change in sales, and 1.46e-11 for PPE.

## Jones fit rank repair

Before the repair, the separate exchange Jones fits admitted one four-row group whose native no-intercept Stata regression had rank 2 and residual df 2. A bounded `PROC REG OUTEST= ... EDF` probe on the existing constructed four-row panel returned the same residual df; the fit rank is therefore `N - residual_df = 2`, below the three-regressor requirement. The build now obtains model df from native `PROC REG` output and only carries NAC/ABNAC from groups with rank 3. The source's minimum-six rule remains at combined SIC-year level. No six-per-exchange minimum was added.

The post-outlier Jones sample has 59,663 rows in 1,802 exchange-specific groups. Thirty-seven two-row groups (74 rows) are underidentified before `PROC REG` and have no model-df output. Of the 1,765 groups with at least three rows, 1,764 are full rank; 41 full-rank three-row exact-fit groups (123 rows) remain with zero residual df. One four-row rank-2 group is excluded, dropping four observations from the handoff. The other 118 groups with four or five rows remain. In total, the EDF audit marks 38 groups/78 rows as not full rank when the 37 pre-fit underidentified groups are included; only the four-row group is an additional exclusion from the previously fitted handoff. Every final panel row has model rank 3. The combined SIC-year screen excluded 185 cells below six; 197 exchange groups (724 rows) within otherwise eligible SIC-years have fewer than six observations, so the exchange-level ambiguity remains visible.

The guard changed the pre-guard A3 panel from 59,589 to 59,585 rows and Table 2 N from 55,067 to 55,064. Four pre-guard keys disappeared and none were added. Among the 59,585 shared keys, none of the checked accounting, Jones, lead-outcome, or return inputs changed; the three removed Table 2 rows are the only system-sample difference attributable to this repair.

## Sample and input comparison

The paper reports 56,692 starting firm-years and 51,579 complete system observations (source PDF pp. 4 and 7). Final A3 has 59,585 firm-years across 8,205 firms and 55,064 Table 2 observations: respectively 2,893 and 3,485 above the paper counts. A2 had 59,832 firm-years/8,226 firms and system N=55,280. Against A2, the guarded A3 key sets share 59,567 rows; 265 A2 keys are absent and 18 A3 keys are new. Four of the 265 are the demonstrated Jones-rank exclusion; the other key changes are not individually attributed by this bounded audit. All 18 new A3 keys have USD current-record currency, so the residual key difference cannot be assigned to CAD translation alone. Link/name ambiguity and final firm-year duplicates are zero.

Among shared A2/A3 keys, 19 rows changed in each of `earn_sc`, `cfo_sc`, `accr_sc`, `oneata`, `drev_sc`, and `ppe_sc`; these are the affected current/prior monetary constructions. `earn_lead` changed on 11 rows. `sizeajr_lead`, `stock_bhr`, and `size_bhr` did not change. Re-estimation of the exchange-specific Jones regressions changed NAC and ABNAC on 5,122 shared rows each. These changes follow the translated inputs and fit recalculation; no target coefficients or published values were used.

Table 2 input descriptive statistics are mean (standard deviation):

| Input | A2, N=55,280 | Guarded A3, N=55,064 |
| --- | ---: | ---: |
| EARN | 0.027278 (0.148998) | 0.027029 (0.149068) |
| CFO | 0.066183 (0.168285) | 0.065892 (0.168318) |
| NAC | -0.038460 (0.087364) | -0.038399 (0.087428) |
| ABNAC | -0.000445 (0.096566) | -0.000464 (0.096585) |
| EARN lead | 0.018818 (0.216512) | 0.018515 (0.216771) |
| SIZEAJR lead | 0.015766 (0.585564) | 0.015488 (0.585997) |

### Published Table 1 descriptive comparison

Table 1 Panel A reports the paper's original 56,692-row sample (physical PDF p. 6). These variable definitions align with the A3 baseline fields, so the moments are comparable as a sample diagnostic. The populations differ: A3 has 59,585 rows and 8,205 firms, versus the paper's 56,692 rows and 7,506 firms. A3 statistics are from the final guarded baseline and are rounded here to the source table's three decimals.

| Variable | Published mean (SD) | A3 baseline mean (SD) |
| --- | ---: | ---: |
| EARN | 0.025 (0.138) | 0.018 (0.163) |
| CFO | 0.069 (0.141) | 0.061 (0.177) |
| ACCR | -0.044 (0.121) | -0.043 (0.136) |
| ABNAC | -0.004 (0.102) | -0.003 (0.102) |
| NAC | -0.040 (0.066) | -0.040 (0.091) |
| RETURN | 0.151 (0.638) | 0.142 (0.622) |
| SIZEAJR | 0.007 (0.592) | 0.000 (0.573) |

The matching baseline variable labels do not remove the population mismatch. Current Compustat/CRSP vintages, the larger A3 sample, USD translation, and best-effort local return breakpoints prevent attributing the moment differences to one repair alone.

## Structural identification repair and execution

A4 changes only Table 2's estimator. The A3 SAS construction, `build.sas`, declared `mispricing_panel` sample, and `reg.dta` are unchanged. The helper verified matching construction and sample declarations and copied both handoff files from A3; the A4 execution record reports the same dataset hashes. The local Table 1 descriptive comparison above is preserved as the unchanged A3 result.

In the recursive system, substituting the forecast equation into the return equation gives `SIZEAJR = α + β(γ − γ*)X + βv + ε`. With unrestricted cross-equation covariance, the observed reduced form does not separately identify `β` and the three valuation slopes. The finite A3 full-covariance IFGNLS coefficients therefore do not support separate structural interpretation by themselves. This identification result does not invalidate every LR restriction: each component rational-pricing equality sets one observable return-mean slope to zero; the combined NAC/ABNAC null also equates both the forecasting slopes and the corresponding reduced-form return slopes. A4 retains the source's 1, 1, 1, 2, and 3 degrees of freedom.

A4 uses direct native Stata `mlexp` with two log-normal-density terms, conditioning the return equation on observed next-year earnings. It assumes independent, homoskedastic equation disturbances and estimates one constant variance per equation. The log standard deviations imply positive estimates: forecast SD 0.1815133 (SE 0.0005470) and return SD 0.5779987 (SE 0.0017417). All reported coefficient and scale-parameter standard errors are finite. Several fits showed intermediate “not concave” iteration notices, but the unrestricted and five restricted likelihoods all completed with finite estimates and no convergence-failure message; final log likelihoods stabilized at the values below. Each fit used the same N=55,064 complete-case observations. This conditional-Gaussian model is an explicit best-effort identification assumption, not the recovered author estimator, whose GLS weights/covariance are unspecified.

Native OLS mapping checks on the same sample verify the unrestricted first equation to a maximum absolute coefficient difference of 6.37×10⁻¹², as source footnote 9 requires (physical PDF p. 9). The second equation maps to OLS of `SIZEAJR` on a constant, `EARN`, CFO, NAC, and ABNAC: the maximum absolute difference in its constant and four slopes is 1.17×10⁻⁸. The transformed return coefficients are 0.0092777, 0.4971928, −0.3016786, −0.4327468, and −0.5732609, matching the direct OLS coefficients to the stated tolerance. The diagnostic OLS fits have R-squared 0.2988 and 0.0271; neither is added to the conditional-likelihood table because `mlexp` does not supply one.

All restricted fits use the same native conditional-Gaussian likelihood as the unrestricted fit. Their log likelihoods are below the unrestricted value, and the native LR outputs confirm proper nesting:

| Fit or null | Source Table 2 LR (reported p) | A3 full-covariance IFGNLS LR (p) | A4 conditional-Gaussian LR (p) | A4 log likelihood |
| --- | ---: | ---: | ---: | ---: |
| Unrestricted | — | — | — | −32,117.005 |
| CFO: γ*₁ = γ₁, df=1 | 23.15 (<0.0001) | 34.23 (<0.0001) | 34.23 (<0.0001) | −32,134.122 |
| NAC: γ*₂ = γ₂, df=1 | 11.62 (<0.001) | 1.95 (0.1624) | 1.95 (0.1624) | −32,117.981 |
| ABNAC: γ*₃ = γ₃, df=1 | 42.11 (<0.0001) | 69.41 (<0.0001) | 69.41 (<0.0001) | −32,151.710 |
| NAC and ABNAC within-equation equality, df=2 | 277.28 (<0.0001) | 92.76 (<0.0001) | 92.76 (<0.0001) | −32,163.386 |
| All three rational-pricing equalities, df=3 | 147.78 (<0.0001) | 186.11 (<0.0001) | 186.11 (<0.0001) | −32,210.061 |

The A4 Table 2 exports contain the six source-tabulated forecasting and valuation slopes, template coefficient p-values, common N, unrestricted log likelihood, and all five LR tests with degrees of freedom. Estimates and standard errors are compared with source Panel A and A3 below. The source reports `2N ln(SSRc/SSRu)` and gives one weighted-system SSR example (physical PDF pp. 7–8), but its GLS weighting and SSR normalization are not specified. A4 therefore reports conditional-likelihood LRs and does not invent an unweighted residual-ratio statistic.

## Coefficients and uncertainty compared with Table 2 Panel A

Source estimates and asymptotic standard errors are from Table 2 (physical PDF p. 7); the source omits `γ₀`, `α`, and `β` by footnote 8 (physical PDF p. 8). A3 and A4 rows use Stata's native coefficient standard errors. The main table's parenthetical values are coefficient p-values under the assigned template; these source comparisons use standard errors directly.

| Parameter | Published estimate (SE) | A3 estimate (SE) | A4 estimate (SE) |
| --- | ---: | ---: | ---: |
| Forecast intercept γ₀ | Not reported | −0.0045587 (0.0008700) | −0.0045587 (0.0008700) |
| Forecast CFO γ₁ | 0.73 (0.004) | 0.8113177 (0.0053925) | 0.8113177 (0.0053925) |
| Forecast NAC γ₂ | 0.70 (0.007) | 0.7831063 (0.0096379) | 0.7831063 (0.0096379) |
| Forecast ABNAC γ₃ | 0.57 (0.005) | 0.6785713 (0.0087820) | 0.6785713 (0.0087820) |
| Valuation intercept α | Not reported | 0.0070111 (0.0028039) | 0.0070111 (0.0028039) |
| Valuation β | Not reported | 0.4971928 (0.0135702) | 0.4971928 (0.0135702) |
| Valuation CFO γ*₁ | 0.67 (0.013) | 0.6067638 (0.0349852) | 0.6067638 (0.0349852) |
| Valuation NAC γ*₂ | 0.78 (0.024) | 0.8703802 (0.0617729) | 0.8703802 (0.0617729) |
| Valuation ABNAC γ*₃ | 0.69 (0.018) | 1.1529950 (0.0577167) | 1.1529950 (0.0577167) |

A4's coefficients and standard errors match the prior A3 outputs at the displayed precision, but their interpretation changes: A4 identifies the structural valuation parameters only under its disclosed conditional independence assumption. The source/A4 directions agree—CFO is valued below its forecast persistence, while NAC and ABNAC are valued above theirs—but the A4 estimates are farther from the published values for several slopes. The A4 LR tests reject CFO and ABNAC rational pricing, fail to reject NAC equality, and reject both the joint NAC/ABNAC equality and all-component equality. The source rejects all three individual rational-pricing nulls. In particular, the source's NAC result (χ²(1)=11.62, p<0.001) differs from the local conditional result (χ²(1)=1.95, p=0.1624). No sample or specification was changed to move estimates toward the source.

The source Table 2 uses 51,579 system observations, while A3/A4 use 55,064, a difference of 3,485. The sample is reused unchanged from A3; the broader population/vintage and construction limits documented above remain unresolved. The source's starting sample is 56,692, versus 59,585 local baseline rows. The A3 and A4 outputs both preserve the local Table 1 descriptive comparison rather than tuning screens to match those counts.

A4's fresh Stata cell is recorded at `runtime/20261103T033219766614Z/cell_mishkin-system.log`; the helper reports `ok=true`, exit code 0, and four verified exports at `tables/table2_mishkin.{md,csv,rtf,tex}`. The A3 runtime logs were retained. No custom Stata program, Mata code, postfile, coefficient dump, or `.ster` file is used.

## Remaining limits

The original paper's 1995 data vintage is unavailable, and A4's 55,064 observations exceed the source system N of 51,579. A3 documents local-link, coverage, currency, Jones-fit-rank, size-breakpoint, and sample-construction details; this targeted estimator repair makes no new data audit and leaves those data choices unchanged. The source's exact GLS weighting and equation-error covariance are unreported. Independent, homoskedastic conditional errors are therefore a disclosed identification assumption, not evidence that the source used that covariance. Conditional-Gaussian likelihood ratios are valid for the nested model under that assumption but are not numerically equated to the source's weighted-SSR formula. Source coefficient standard errors and local conditional standard errors may reflect different weighting/covariance rules. The paper reports no coefficient p-values; the exported table follows the template's two-sided coefficient tests and reports the source's LR restrictions separately.
