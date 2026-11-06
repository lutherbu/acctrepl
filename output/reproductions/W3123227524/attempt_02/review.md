# Review and repair record

## Source passages reviewed

The sample restrictions and financial-data eligibility statement appear on printed p. 6 (PDF p. 5). The measurement equations and Compustat item definitions are on printed pp. 7–9 (PDF pp. 6–8). Table 6 and its notes are on printed pp. 16–17 (PDF pp. 15–16). Rendered source pages are retained under `audit/source_pages/`.

The sample text requires statements for the four years before the SEO filing, the offer year, and the next year. It also says each firm-year observation must support the discretionary-accrual and real-earnings-management measures. A2 interprets the filing-history clause as four consecutive latest FYEAR labels with DATADATE before FILINGDATE, and the metric clause as a common issuer year-0 sample with all six DA/CFO/PROD/DISX/RM proxies available. This rule is applied at the issuer event-year. The nonissuer match needs ROA and prior assets only. The auxiliary regressions still use the broad nonfinancial Compustat population with equation-specific complete inputs, N≥8, and a full-rank check.

## Repairs to attempt 01

Attempt 01 counted pre-filing statements from a Compustat table already filtered to valid nonfinancial SICH. The filing-date statement screen does not require SIC. In a bounded 1987–1989 audit, 113/173, 42/70, and 92/130 uniquely linked offers had at least four pre-filing annual rows after standard file/country selection, but the SICH-filtered counts fell to zero, 0.87, and 1.69 rows on average. Removing the unrelated historical-SIC restriction restored the statement history. The final A2 read starts in FY1981 for this screen; observed nonfinancial analysis rows begin in FY1982.

The initial A2 rebuild exposed a second ordering defect: t−1 and t−2 accounting lags came from the SICH-filtered analysis table, and t+1 outcome IB came from a proxy table. Lag inputs and next-year IB do not require prior/next-year industry classifications or proxy residuals. A2 now takes prior and subsequent statements from the standard, SIC-free annual table while keeping valid nonfinancial SICH on the year-0 support and issuer populations. This restores 1987 year-0/year-1 panel coverage. The matched event data retain separate offers by `MASTER_DEAL_NO`.

Other reviewed construction choices include item 123=`IBC`; CFO=`OANCF−XIDOC`; source RM signs; no ordinary constant in auxiliary support models; minimum eight complete rows and ANOVA-rank checks; date-effective `SEC_IDHIST` CUSIP links for target issuers and the full-period IPO/SEO nonissuer screen; and no use of undated `FUNDA.CUSIP` as historical linkage. Table 6 D/E/F no longer drop 1990: after the sample repairs each 1990 cross-section has enough variation, and all 20 Table 6 years are full rank.

## Filing-history and early-year diagnostics

The first bounded audit finds valid filing dates and plausible filing-to-issue intervals for the early offers: median issue-minus-filing age is 23, 22, and 28 days in 1987, 1988, and 1989; no target filing date is after the issue date. The A2 production listing compares “any four earlier” with the four latest consecutive pre-filing FYEARs. These counts are identical in 1987–1989 (113, 42, 92); the oldest of the four latest statements is 1,108–1,457 days before filing in 1987, 1,135–1,450 days in 1988, and 996–1,453 days in 1989. No four-year window is older than five years. Across all cohorts only one 2001, three 2005, and three 2006 offers with any four earlier rows fail the consecutive-four screen.

| Offer year | Unique dated links | Four latest consecutive statements | Year-0/year-1 panel rows | After history | All six proxies | Table 6 complete cases |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1987 | 173 | 113 | 140 | 91 | 12 | 12 |
| 1988 | 70 | 42 | 59 | 40 | 26 | 25 |
| 1989 | 130 | 92 | 109 | 78 | 51 | 51 |

The zero 1987 panel rows in the earlier build were not caused by filing dates or lack of pre-filing history. The production stage counts show that 165/173 linked 1987 issuers have a standard year-0 record, 157 have year-1, 147 have nonfinancial year-0 SIC, and 147 have USD positive prior assets after the lag join is repaired; 140 then have year-0/year-1 ROA rows. Requiring four prior rows, all proxies, and a successful match reduces this to 12 Table 6 complete cases. The 1988 cohort similarly falls from 59 panel rows to 40 after history, 26 with all proxies, and 25 complete Table 6 cases. These losses are reported rather than replaced with assumed vintage effects.

## Links, supporting population, and eligibility

The SDC target screen yields 5,249 offers; 5,114 link to one GVKEY using dated CUSIP history, one remains ambiguous, and 134 have no dated link. The full 15,571-deal U.S. common IPO/SEO pool used to exclude nonissuers links 13,677 deals to one GVKEY, has two ambiguous deals, and 1,892 with no dated match. The selected Compustat annual rows contain 135,561 nonfinancial firm-years for FY1982–FY2007 (30NOV1982–31MAY2008); 135,378 are USD and 183 CAD. The latest DATADATE is retained for two duplicate GVKEY–FYEAR groups. USD is required for prior-asset size matching, and adjacent years used in differenced/scaled accounting quantities must agree in currency.

Across the full nonfinancial supporting population, 1,128 DA and 1,136 DISX SIC-year groups meet N≥8 and all are full rank; CFO has 1,129 such groups, 1,128 full rank; PROD has 1,138, 1,137 full rank. Singular groups do not contribute residuals. The 1987–2006 Table 6 sample contains 2,070 separate offers from 1,551 issuer GVKEYs and 1,334 distinct matched controls. All six year-0 proxy measures are observed for each retained issuer event. Model complete-case counts can still differ when outcome or growth controls are missing.

## Published versus reproduced Table 6

| Table 6 fit | Published coefficient (t) | Reproduced coefficient (t; two-sided p) | N | Full-rank years | Published mean adjusted R² (%) | Reproduced mean annual adjusted R² (%) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| A[6], DA | −0.126 (−3.74) | −0.066 (−1.04; p=.313) | 2,030 | 20 | 26.79 | 13.34 |
| B[7], CFO | −0.158 (−4.11) | −0.090 (−1.67; p=.111) | 2,030 | 20 | 35.13 | 14.72 |
| C[7], production | −0.256 (−3.59) | 0.023 (0.64; p=.532) | 2,030 | 20 | 38.31 | 14.20 |
| D[7], DISX | −0.167 (−3.49) | 0.076 (2.15; p=.045) | 2,030 | 20 | 36.83 | 16.20 |
| E[7], RM1 | −0.237 (−3.42) | −0.036 (−1.77; p=.093) | 2,030 | 20 | 41.39 | 15.14 |
| F[7], RM2 | −0.221 (−3.09) | −0.029 (−1.21; p=.240) | 2,030 | 20 | 39.04 | 15.68 |

Table 6 does not report regression N. Table 1 describes 1,511 SEO offers overall; the local completed event-grain output has 2,070 offers, with 1,551 distinct issuer GVKEYs. Published Table 1 year counts for 1987–1989 are 86, 49, and 59; local Table 6 complete-case counts are 12, 25, and 51. Table 1's asset note on physical p. 6 defines assets as beginning-of-period total assets, matching the local prior-asset timing. Published assets have mean $422.10 million and median $118.62 million; the local matched prior-asset population has mean $949.25 million and median $154.50 million. These populations differ in event count and sample composition; the comparison does not imply a timing mismatch. No sample screen was selected to target the published count or coefficients. The local DA, CFO, RM1, and RM2 coefficients retain the published negative direction but are much smaller and not statistically significant at 10%; local production and DISX coefficients are positive, reversing the published negative signs. DISX is positive and nominally significant at p=.045. Local average adjusted R² values are 13.34–16.20%, versus 26.79–41.39% published. The six current Stata cells completed, and all six exported `.md`, `.rtf`, `.csv`, and `.tex` tables contain coefficient, p-value, observation, unadjusted R², and mean annual adjusted R² (%) rows; the separate `R-squared` row remains the `xtfmb` fraction.

## Remaining limits

The catalog does not supply exact SDC category codes for several paper exclusions, so completion is proxied by observed issue date/no postponed or withdrawn dates and rights, units, funds, and reverse LBOs use description/business text. The paper leaves growth formulas, event-to-FYEAR mapping, Table 6 constant convention, matching year/tie/reuse rules unspecified. A2 uses same-calendar-year FYEAR 0, year-0 ROA matching, ascending-GVKEY ties, and reusable controls. The installed `xtfmb` default supplies Fama–MacBeth inference without a HAC lag; exported p-values are two-sided while the paper reports t-statistics. Published annual fit Ns are not reported, so annual coverage is compared through local complete-case counts and ranks.
