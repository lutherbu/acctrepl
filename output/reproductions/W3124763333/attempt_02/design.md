# W3124763333, Attempt 02

## Frozen scope and source evidence

This attempt reconstructs the two jointly estimated baseline equations in Table 2 for fiscal years 1981–1999. The paper ([W3124763333.pdf](../../../papers/pdf/W3124763333.pdf)) reports 21,891 firm-years from 3,170 firms and removes 465 firm-years in the extreme upper and lower 1% of order backlog (pp. 7–8). The equations, asymptotic standard errors, and LR restrictions are on pp. 13–14. The reported sample size is a comparison point; this attempt uses the available local Compustat and CRSP vintages and does not tune the sample to 21,891.

The paper maps annual Compustat item 98 to order backlog. Research Insight 2004, physical p. 91, verifies Annual item A98 as the backlog field; the current annual Compustat source exposes it as `OB` ([cached provider guide](../../../output/reproduction_runs/reference_documents/compustat_research_insight_2004.pdf)). The construction uses `IB` (item 18), `AT`, `OB`, and each period's `CURCD` from `COMP.FUNDA`. The paper's later IBES, operating-cash-flow, and control-variable analyses are outside this assignment.

## Accounting measures and currency basis

For each GVKEY and fiscal year *t*, require actual adjacent fiscal-year rows *t−1*, *t*, and *t+1*, with strictly increasing DATADATEs. Use:

\[
EARN_t = IB_t / ((AT_{t-1}+AT_t)/2),\qquad
BKLG_t = OB_t / ((AT_{t-1}+AT_t)/2),
\]

and the separate forward outcome denominator

\[
EARN_{t+1} = IB_{t+1} / ((AT_t+AT_{t+1})/2).
\]

Require nonzero observed `OB`, nonmissing inputs, and nonzero average-asset denominators. Determine currency compatibility separately for each ratio: `EARN_t` and `BKLG_t` use the t−1/t statements, while `EARN_t+1` uses t/t+1. If the two relevant reporting currencies agree and are known, calculate that ratio in native units, so an unrelated adjacent-period currency change does not alter its basis. If they differ, translate the amounts used for that ratio to USD with the provider's documented GBP-intermediary cross-rate: reported amount / GBP-to-reporting-currency rate × GBP-to-USD rate. Assets use the daily rate on their DATADATE; annual income `IB` uses `EXRAT12M` for its statement's reporting month; `OB` is an order-backlog stock at fiscal-year-end and uses the current DATADATE daily rate. These field-specific conversions follow the Xpressfeed guide's cross-rate formula (physical p. 87) and distinction between dated daily rates and actual/carried provenance (pp. 86, 89; [cached Xpressfeed guide](../../../output/reproduction_runs/reference_documents/compustat_xpressfeed_2011.pdf)). `EXRATTPD` is retained as actual/carried provenance and does not determine currency compatibility. Rates must be positive, matched by currency and date, and unique. Unsupported mixed-currency ratios remain unavailable and are counted separately from native ratios and missing currency codes. The accounting values in these statements share the provider's reporting units; market capitalization below is a separate CRSP security-level USD construct.

## Historical security links and return construction

Select date-valid CCM links at fiscal year-end and at the benchmark formation date, preserving open-ended link dates. Prefer `LINKPRIM=P` to `C`, then `LINKTYPE=LC` to `LU`; exclude ties that still map to more than one PERMNO/PERMCO at the best rank. Compustat header IID/HIID fields are not used as historical identifiers. The event security return uses the unique FYE PERMNO.

The first monthly holding period is month four after DATADATE (`INTNX('MONTH', DATADATE, 4, 'B')`). Compound that month and the next eleven CRSP monthly total returns. Combine a valid month-specific DLRET with RET as `(1+RET)*(1+DLRET)-1`; when the delisting file has a unique valid terminal delisting return, carry its proceeds as cash with zero later returns. Delisting-only months are admitted and counted. A delisting before the holding window cannot create an investable zero-return series; missing/ambiguous delisting proceeds and any missing monthly stock or benchmark return leave the window incomplete. FY1999 therefore requires market data into 2001.

For the size benchmark, use `CRSP.MSIX` monthly `DECRET1`–`DECRET10`, not daily `DSIX`. The CRSP Stock and Index Data Descriptions Guide, physical p. 106 (printed p. 102), section C, documents annual stock-file capitalization deciles formed from prior-year-end capitalization, all selected-exchange securities except ADRs, smallest=1 through largest=10, and value-weighted total returns ([cached CRSP guide](../../../output/reproduction_runs/reference_documents/crsp_stock_data_descriptions.pdf)). Physical p. 107 describes a distinct quarterly product with reversed decile order; it is not used. `MSIX` provides portfolio returns but no dated security-to-decile assignment, so target assignments are reconstructed approximately from CRSP price × shares outstanding and dated names on NYSE/AMEX/NASDAQ, excluding ADR share types. Securities use their prior calendar-year-end capitalization; when unavailable, the guide's first eligible capitalization in the return year is the fallback. To avoid applying a later-month size observation to an already-started return window, use that fallback only when its date precedes the holding start or is in the holding-start month (the monthly endpoint is the available proxy). A first eligible cap in a later holding month leaves the target decile unavailable for that window; no later value is backdated. `PROC RANK` groups eligible values into ten ascending groups; tied ranks share a group. The SAS listing reports formation-cap date classes and unavailable late fallback counts.

This is an explicit best-effort match, not exact vendor membership: the vendor's tie handling and new-entrant implementation cannot be recovered from the local monthly portfolio returns. The first-cap rule is applied only where the dated capitalization is available by the start month; a same-month month-end cap is a monthly proxy, while a later-month cap is unavailable at event start. Calendar-year-end formation may differ from the paper's phrase “at the end of year t” for non-December fiscal year ends. The vendor portfolio is value-weighted and annually rebalanced; the paper describes the benchmark as a buy-and-hold “mean return” for a size-matched decile portfolio. The local benchmark therefore compounds the vendor's monthly value-weighted decile total returns over the 12 months, and that weighting/rebalancing difference is retained as a limitation.

## Eligibility and trimming

Keep current and adjacent annual statements, nonzero OB, a unique dated FYE CCM link, usable benchmark decile, and complete 12-month stock and benchmark returns. Do not add an industry restriction, IBES forecast completeness, OANCF, or controls. On that common pre-trim system sample, calculate pooled empirical 1st and 99th percentiles of scaled `BKLG` and drop observations strictly outside them; observations equal to a cutoff are retained. This is trimming, not winsorization. The build logs report annual counts, FX/link/return attrition, cutoffs, and final distributions.

## Identification and estimation

Table 2's forecast equation is

\[
EARN_{t+1}=\omega_0+\omega_1 EARN_t+\omega_2 BKLG_t+\epsilon_{t+1}.
\]

The returns equation uses the same \(\omega_0\) listed for the forecasting equation, with \(\omega_1^*\) and \(\omega_2^*\). The paper body on p. 13 stars the return-equation intercept, while Table 2 on p. 14 and its parameter list have one shared unstarred \(\omega_0\); this implementation follows the table and does not add a redundant second intercept.

With unrestricted cross-equation error covariance, numerical convergence of a recursive nonlinear system does not by itself identify the structural return slope. In the reduced-form return regression on `EARN_{t+1}`, `EARN_t`, and `BKLG_t`, the coefficients confound \(\beta_1\) with the forecast/return error covariance. This attempt therefore uses the allowed, explicitly labeled independent-error conditional Gaussian likelihood in native Stata `mlexp`, with separate positive error standard deviations parameterized as exponentials. Under that identifying assumption, the unrestricted likelihood is equivalent to the forecasting OLS plus conditional return OLS: the latter coefficients are \(\beta_1\), \(-\beta_1\omega_1^*\), \(-\beta_1\omega_2^*\), and \(\beta_0-\beta_1\omega_0\). For nonzero \(\beta_1\), this maps back to the seven structural mean parameters. The Stata cell checks this mapping directly on the realized common sample and checks both estimated standard deviations.

The source reports iterative weighted nonlinear least squares and calls Table 2 nonlinear generalized least squares, but it does not specify observation weights or the cross-equation covariance restriction. The independent-error Gaussian maximum likelihood is a documented best-effort departure, not an exact recovery of the source weighting. The two native likelihood-ratio tests compare the unrestricted likelihood with directly estimated one-restriction nested likelihoods for \(\omega_1=\omega_1^*\) and \(\omega_2=\omega_2^*\). They are not ratios of unweighted residual sums of squares. Their results are compared with the source's reported 3.81 and 12.06 statistics.

## Realized results

The final fresh SAS build and SAS-to-Stata handoff succeeded with return code 0. The build log/listing and handoff log are under `runtime/20261104T124650670262Z/`; neither the SAS log nor listing contains an `ERROR:` or `WARNING:`. FX rate date/currency keys had no duplicates. Of 33,422 nonzero-OB records, 29,771 had complete usable accounting ratios. Ratio-specific mixed-currency inputs were 6 current-ratio cases and 129 lead-ratio cases, all with supported rates; there were no missing currency codes among complete ratio inputs.

Construction produced 25,997 unique FYE-linked accounting rows. There were 25,784 prior-December formation-link rows and 213 FYE-link fallback rows. Before target-window completeness, 25,286 target ranks used prior-December capitalization, 239 used an eligible first-in-year capitalization dated before the holding-start month, 10 used a same-month endpoint proxy, and 50 later-month first-cap assignments were marked unavailable. Another 412 rows had no approximate target decile. The 50 late-cap rows are a linked-accounting-stage count: 666 target return windows were incomplete, and 462 benchmark windows lacked a usable decile. The complete pretrim sample is 25,198 rows. The same pooled strict 1st/99th percentile BKLG trim was recalculated on that sample; its cutoffs were 0.008822 and 4.050839, and 502 rows were removed. The final sample is 24,696 firm-years from 3,561 firms with no duplicate GVKEY/FYEAR key. An aggregate comparison with A1 shows exactly one old key removed, no new keys, identical earnings and backlog ratios on all 24,696 common keys, and a maximum SAR difference of 2.49×10⁻¹⁴ from floating-point recomputation. The one removed key was otherwise retained in A1's final sample. The resulting local N is 2,805 (12.8%) above the paper's 21,891; that difference is not used as a target.

The final A2 handoff retains `rank_cap_date`, `cap_date_usable`, and `cap_date_class`; every final row has usable cap timing. Final cap classes are 24,468 prior-December, 227 before-start first-cap, and 1 same-month proxy. The CRSP/CCM audit found one formation/event PERMNO and PERMCO change across link dates, without evidence establishing its specific cause. Eight FYE CCM links had expired before holding start; four rows had another active link for the same PERMCO and four had no active CCM link. All eight had complete CRSP return windows. No broad CCM-at-start screen was added. Final DATADATEs span 30 June 1981–31 May 2000; all required adjacent fiscal statements were present, including 155 lead DATADATEs in 2001 for FY1999 rows. Every 12-month return window was covered through 31 August 2001.

Both required Stata cells completed successfully in the fresh run at `runtime/20261104T125009715611Z/`. The unrestricted and two nested likelihoods converged on the same N=24,696; standard errors were finite and both error SD estimates were positive. The maximum absolute gap between the unrestricted structural estimates and their forecast-OLS/conditional-return-OLS mapping was 3.83×10⁻⁶, and the maximum scale-relative gap was 2.10×10⁻⁶. Estimated error SDs were 0.237086 for forecast earnings and 0.972162 for returns. The native one-restriction LR tests were 4.37 (p=0.0366) for \(\omega_1=\omega_1^*\) and 0.00 at the exported two-decimal precision (p=0.9631) for \(\omega_2=\omega_2^*\). All 12 regression/descriptive exports exist in `.md`, `.rtf`, `.csv`, and `.tex`. The regression exports show estimates with two-tailed p-values in parentheses; they do not fabricate an R².

| Parameter or test | Paper Table 2 | Local independent-error likelihood |
| --- | ---: | ---: |
| \(\omega_0\) | −0.001 (0.001) | −0.01983 (0.00201) |
| \(\omega_1\) | 0.581 (0.005) | 0.68478 (0.00819) |
| \(\omega_1^*\) | 0.536 (0.023) | 0.82821 (0.06853) |
| \(\omega_2\) | 0.008 (0.002) | 0.01459 (0.00266) |
| \(\omega_2^*\) | 0.039 (0.009) | 0.01356 (0.02217) |
| \(\beta_0\) | 0.027 (0.007) | 0.01346 (0.00831) |
| \(\beta_1\) | 1.088 (0.033) | 0.49288 (0.02609) |
| LR: \(\omega_1=\omega_1^*\) | 3.81, p=0.05 | 4.37, p=0.0366 |
| LR: \(\omega_2=\omega_2^*\) | 12.06, p<0.001 | 0.00 at two-decimal precision, p=0.9631 |

Coefficient and LR results differ materially, particularly for the backlog efficiency restriction. The source reports iterative weighted nonlinear least squares but does not specify weights or the cross-equation covariance restriction. The local independent-error conditional Gaussian likelihood is an identified best-effort departure, not an exact recovery of that estimator. The local sample is larger and uses reconstructed approximate deciles and CRSP's value-weighted, annually rebalanced MSIX portfolio returns. The paper describes a mean-return buy-and-hold size portfolio. These estimator, membership, weighting, and formation differences limit numerical comparability. The local stars use two-tailed normal-ML p-values and the template's 10%, 5%, and 1% levels; the paper marks 5% and 1% significance and reports asymptotic standard errors.

The descriptive cell uses the actual 24,696-row regression sample. Mean (SD), median are 0.0060 (0.1847), 0.0416 for `EARN_t`; −0.0084 (0.2691), 0.0364 for `EARN_t+1`; 0.5005 (0.5675), 0.3120 for `BKLG_t`; and 0.0133 (0.9793), −0.1026 for `SAR`. The source's Table 1 gives approximate overall mean/median values of 0.00/0.04 for EARN and 0.46/0.30 for BKLG. The maximum SAR is 57.576 and remains because the source trims BKLG, not returns.
