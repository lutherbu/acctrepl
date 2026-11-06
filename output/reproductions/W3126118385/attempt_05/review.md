# Independent review and daily FX repair: W3126118385, attempt 05

## Source and prior-attempt review

I checked Dickinson (2011), *The Accounting Review* 86(6), against the assigned
PDF. Physical pp. 7–8 give the NYSE/AMEX/NASDAQ, non-ADR population, 1989–2005
period, four $1 million screens, financial-firm exclusion, and reported
48,369 firm-years. Physical pp. 17–19 state Model 1, separate firm and year
clustering, two-tailed tests, and the convention that displayed life-cycle
levels are the reference intercept plus the stage increment while the table
t-statistics test increments. Appendix A, physical pp. 25–26, supports the
inherited reduced formulas for NOA and OI. The three frozen Model 1 scopes,
the FY1984–2006 support horizon, A3 NOA/OI algebra, and the 31 May 2007 FX
source endpoint remain unchanged.

Attempt 04 had two daily FX assumptions that the provider evidence does not
support: it retained only `EXRATTPD='AR'` quotes and selected the GBP-to-local
and GBP-to-USD legs independently. The Xpressfeed 2011 guide says `EXRATTPD`
describes actual versus carried-forward provenance (physical p. 86 / printed
p. 78); its cross-rate formula requires the same primary currency and aligned
rate basis (physical p. 87 / printed p. 79). The root exact-source audit at
`../../../output/reproduction_runs/preflight/fx_rate_types.json` confirms that
both positive GBP-to-CAD and GBP-to-USD quotes are present on all 261 dates in
1984 despite blank descriptors, on 260 dates in 1985 with both descriptors
blank, and on all 365 dates in 1999, including dates with blank or mismatched descriptors.
The exact 31 December 1999 quote pair is CAD blank / USD `AR`. The source audit
finds no duplicate date-currency keys in this slice. A missing or unequal type
descriptor does not remove the observed quote or change its currency units.

## Repair and execution

The A5 build keeps every positive daily quote with known GBP/target currencies,
then selects the latest nonfuture date within seven days for which both the
reported-currency and USD legs exist on that same date. If no such pair exists,
the daily factor remains missing. It carries each leg's quote date, rate, and
original type into the final handoff. Monthly `EXRAT12M` flow matching is
unchanged. The fiscal-close price conversion remains an explicit daily
point-date choice; the guide also lists `EXRAT1M` for monthly-price data.

The native SAS-to-Stata smoke under `.work/` used unequal rates and mixed or
blank descriptors. It passed exact-pair, prior-date fallback, and
mismatched-legs-with-no-shared-date assertions. Native Stata imported the SAS
file and confirmed the factors, statuses, equal leg dates, and original type
strings.

The final SAS audit reads 1,072,834 GBP daily records, including 170,473 blank,
876,490 `AR`, and 25,871 `CF` type descriptors. Across the annual panel's
23,307 CAD firm-years, the repaired method uses 23,165 exact-date pairs and
142 prior-date pairs; none are missing. Rebuilding A4's AR-only independent
selection reproduces all 694 prior CAD misses. Of those, 552 now use exact-date
pairs and 142 use bounded fallback pairs; none remain missing, and no former
A4 factor is rejected for violating the shared-date rule. All 694 gaps occur
in FY1984–1985: 563 in FY1984 (478 exact, 85 fallback) and 131 in FY1985 (74
exact, 57 fallback). No A4 CAD daily miss occurred in FY1986–2006.

SAS reports zero duplicate Compustat GVKEY/FYEAR keys. The handoff succeeds in
native Stata and verifies the unique GVKEY/FYEAR key for all 63,193 screened
rows. The final analysis file retains seven audit fields for daily leg dates,
values, types, and match status. A5 and A4 have identical 63,193 GVKEY/FYEAR
keys and exact-equal values in all 90 shared fields. None of the three proxy
eligibility flags changes. In the 1989–2005 handoff, all 1,233 CAD firm-years
use exact-date pairs (55 blank/`AR`, 1,178 `AR`/`AR`). The 694 restored missing
factors are outside the analysis period. Within the analysis period, the repair
also permits the 55 blank/`AR` exact pairs that A4's filter could not select;
this is distinct from restoring missing factors. The exact comparison of all
90 shared fields establishes that the changed quote-selection rule does not
alter analysis values. Across the full history, the reduced-NOA recovery
count increases from 21,410 in A4 to 21,438 in A5; 17,155 of those recoveries
remain in 1989–2005. OI recovery is unchanged at 532 overall and 477 in the
analysis period. The twelve exported table files are byte-identical to A4; no
sample size, coefficient, p-value, or fit statistic changes.

## Table 5 Model 1 comparison

The A5 observation counts remain below the paper's 48,369 in all three
specifications. The daily FX repair explains none of these remaining sample
gaps; their cause remains unresolved and is not attributed to a data vintage.
Adjusted R-squared values are from the native exported tables.

| Proxy | Published N | A5 N | Published adjusted R² | A5 adjusted R² | N gap |
| --- | ---: | ---: | ---: | ---: | ---: |
| Cash-flow pattern | 48,369 | 26,242 | 0.1654 | 0.1253 | 22,127 |
| A&R | 48,369 | 17,713 | 0.1609 | 0.0960 | 30,656 |
| Age quintiles | 48,369 | 26,438 | 0.1608 | 0.1176 | 21,931 |

The table below reports the paper's stage total and published contrast t-statistic,
then A5's exported stage increment and two-sided p-value, and A5's total stage
effect from native `lincom`. Coefficients are in change-in-RNOA ratio units;
the contrast p-values test each stage against its stated reference group. The
FX repair leaves the A4 results unchanged.

| Proxy | Stage | Published total | Published contrast t | A5 increment (p) | A5 total effect |
| --- | --- | ---: | ---: | ---: | ---: |
| CF | Introduction | -0.121 | -11.81 | -0.164 (<0.001) | -0.150 |
| CF | Growth | -0.031 | -7.92 | -0.042 (<0.001) | -0.028 |
| CF | Shake-Out | -0.001 | -4.42 | -0.047 (0.002) | -0.033 |
| CF | Decline | -0.142 | -8.54 | -0.226 (<0.001) | -0.212 |
| A&R | Introduction | -0.040 | -3.77 | 0.026 (0.151) | -0.015 |
| A&R | Growth | 0.001 | 1.01 | 0.012 (0.547) | -0.028 |
| A&R | Shake-Out | 0.023 | 4.52 | 0.015 (0.433) | -0.025 |
| A&R | Decline | 0.035 | 8.68 | 0.023 (0.253) | -0.017 |
| Age | Introduction | -0.030 | -4.05 | -0.049 (0.016) | -0.096 |
| Age | Growth | -0.019 | -3.18 | -0.034 (0.007) | -0.081 |
| Age | Shake-Out | 0.026 | 3.52 | 0.037 (0.006) | -0.009 |
| Age | Decline | 0.034 | 5.43 | 0.059 (<0.001) | 0.012 |

The paper's reference totals and published t-statistics are CF 0.039 (14.89),
A&R -0.007 (-1.48), and age 0.005 (0.96). A5 reference estimates are 0.014
(p=0.035), -0.040 (p=0.019), and -0.046 (p=0.001), respectively. All paper
and A5 tests are two-tailed. The A5 CF increments are all negative and
significant, consistent in direction with the paper though different in
magnitude. None of the four A&R increments is significant at 5%, unlike the
paper's significant introduction, shake-out, and decline contrasts. The A5
age increments share the paper's signs and are significant, while the
shake-out and decline total levels differ in sign and magnitude.

For total-effect tests, A5 `lincom` p-values are CF introduction <0.001,
growth 0.001, shake-out 0.019, and decline <0.001; A&R introduction 0.097,
growth 0.059, shake-out 0.014, and decline 0.108; age introduction and
growth <0.001, shake-out 0.360, and decline 0.073. These tests concern each
total level relative to zero; they are separate from the paper's reported
stage-increment tests.

## Analysis-sample descriptives

The entries are means and standard deviations of the actual winsorized
complete-case samples, in ratio units. They match A4 exactly. They are pooled
firm-year statistics, unlike the paper's stage-level annual-median
summaries.

| Variable | CF | A&R | Age |
| --- | ---: | ---: | ---: |
| Future change in RNOA | -0.0121 (0.7272) | -0.0156 (0.6028) | -0.0126 (0.7269) |
| Current RNOA | -0.1176 (0.7976) | -0.0303 (0.6096) | -0.1185 (0.7974) |
| Current change in RNOA | -0.0004 (0.7457) | -0.0136 (0.5581) | -0.0008 (0.7446) |
| Growth in NOA | 0.2922 (0.9645) | 0.1640 (0.6983) | 0.2918 (0.9631) |
| Current change in ATO | -0.0635 (1.6462) | 0.0208 (1.3615) | -0.0619 (1.6444) |
| Current change in PM | 0.0425 (0.5908) | 0.0097 (0.4073) | 0.0426 (0.5931) |

## Limits and review status

CF and A&R report a non-positive-semidefinite two-way covariance matrix; the
installed `reghdfe` Cameron–Gelbach–Miller adjustment was applied and the joint
F-statistic was omitted. Age did not require that adjustment. Each fit has 17
year clusters. All three final Stata cells ran successfully; the final SAS
build and native data handoff also succeeded.

The paper does not identify its estimator, so direct OLS remains a best-effort
choice with the reported firm/year clustered inference. The current catalog
lacks legacy item #62 `IINT`; `IDIT` remains a semantic proxy with no verified
mnemonic crosswalk. Other documented assumptions include fiscal averaging,
A&R timing and tie handling, zero cash-flow signs, and the pooled winsorization
cutoffs. No specification or sample was tuned to published results.
