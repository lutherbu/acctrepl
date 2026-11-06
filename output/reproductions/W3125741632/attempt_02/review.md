# Independent review: W3125741632

## Review scope and execution

I reviewed the frozen specification and implementation snapshot, the assigned strict Stata template, the paper PDF, the paper-specific `build_focus` note, and attempt 01's final SAS construction, design, run logs, exports, and handoff data. The source paper is `papers/pdf/W3125741632.pdf`; relevant printed pages are 14–20 for the sample, Table 1, Equation (2), and Table 4A, and 21–23 for Equation (3) and Table 5A.

Attempt 02's `build.sas`, `design.md`, and declared sample are unchanged from the repaired attempt 01. The coordinator's `reuse` command verified that construction and sample declarations match, then copied only `reg.sas7bdat` and `reg.dta` into this attempt. The copied hashes are `948acaeb4024a44e9bd11047c8110d93b6a985ae4f74539858a0e9b70d60b205` and `5ec3fe6e525018498bb47a6cb9a86d3c9b4213be3f376ab0109df97482c84e3b`. The native A2 baseline cells completed in runtime `20261103T022052708091Z`; each produced `.md`, `.rtf`, `.csv`, and `.tex` exports whose hashes match attempt 01. I also added two source-reported adjacent-horizon contrast cells in runtime `20261103T023143300190Z`. They use installed `asreg, by(fyear)` to form annual coefficient series in memory, verify those 28-year means against the baseline `xtfmb` estimates, then regress paired same-year coefficient differences on a constant. The contrast cells also produced the four required formats. Logs are `runtime/20261103T022052708091Z/cell_w312_forward.log`, `cell_w312_backward.log`, `runtime/20261103T023143300190Z/cell_w312_forward_contrasts.log`, and `cell_w312_backward_contrasts.log`. The A1 native SAS provenance is in `attempt_01/runtime/20261103T021228933649Z/build.log` and `build.lst`. No production data construction or sample declarations changed, so I did not rerun the unchanged SAS build.

No new production-code repair was demonstrated by this review. I retained the repaired final A1 construction, not its superseded empty-sample attempts, and recorded the unresolved sample and descriptive differences below.

## Construction checks

- **Source population and screens.** The paper says it starts from the Compustat–CRSP intersection with sufficient accounting, market-equity, book-value, and fiscal-return data, then requires the full (t-4) through (t+3) history, excludes negative book equity, and truncates the specified annual and long-horizon earnings/return tails (printed pp. 14–15). I found no paper-based SIC, size, or generic financial-firm exclusion. The build uses standard consolidated domestic Compustat industrial rows (`INDFMT=INDL`, `DATAFMT=STD`, `CONSOL=C`, `POPSRC=D`), with one latest-publication/actual-date row per GVKEY–fiscal-year; the source audit found only two duplicate firm-year keys among 305,296 selected rows. CRSP common shares use share codes 10 and 11. No additional SIC or size filter is applied.
- **Support and fiscal alignment.** The build retains accounting support for fiscal-year labels 1967–2002 and monthly CRSP data through December 2003; the selected Compustat actual dates reach 31 May 2003. This covers (t-5) market equity for annual deflation and (t+3) accounting/return outcomes for the 1972–1999 formation years. History is joined by GVKEY and fiscal-year label, with missing periods left missing. The eight earnings/return outcomes and the annual price-deflated earnings used for trimming must all be present; market equity is required for (t-5) through (t+2). The final sample also requires positive book equity so MTB is defined.
- **Market equity, links, and units.** CRSP price times shares outstanding is expressed in USD millions (`abs(PRC)*SHROUT/1000`) and summed across date-valid common share classes at the PERMCO grain. The build requires complete issue-level market values and valid dated company links rather than substituting a primary-issue proxy. Known non-dummy HIIDs use exact CCM issue links. For 2,639 firm-years with a real HIID but only a documented dummy-X link, the build admits a dated P/C link only when it is unique, there is no exact-HIID route or own-issue evidence, and no actual alternative link exists. The audited missing/dummy-HIID unique P/C fallback covers 53 firm-years; there are zero ambiguous return links. The audit also records 2,345,688 normalized common security-month rows, zero duplicate PERMNO-months, zero duplicate return PERMNO-months, and 17,603 unique security-month delists. Effective-name and link checks use actual CRSP/CCM dates, and open CCM link ends are retained.
- **Currency.** The code uses the Xpressfeed GBP-primary formula with matching currencies and dates: annual IB flows use `EXRAT12M` at the fiscal month, while CEQ stocks use `EXRATD` at the actual statement date; USD is the identity currency. Daily quote provenance is retained without requiring equal type codes. The audited selected Compustat population contains USD and CAD rows. The catalog-listed monthly/daily rate histories begin in January/February 1982; earlier CAD amounts without dated conversion legs remain unavailable rather than being imputed. The source logs show 24,363 CAD rows in the support population, of which 5,741 lack a valid USD flow conversion and 6,280 lack a valid USD point conversion. Those are support-population counts, not counts of final sample deletions.
- **Annual returns and delisting.** Monthly CRSP trading dates are retained for name eligibility and normalized to calendar-month keys for monthly joins. Each annual return requires the intended twelve consecutive month periods, complete observed returns, and both interval boundaries; an observed delisting return is compounded with the same-month return when present. The build does not fill missing live-period returns or invent post-delisting returns. The twelve-month fiscal-year windows are adjacent, so forward (k=1) and backward (j=0) each use one fiscal-year return; longer horizons compound adjacent annual returns.
- **MTB and regressors.** MTB is company MVE divided by USD-converted Compustat common equity (legacy item 60 / `CEQ`) at formation year `t`. Annual rank is assigned within year after the common trim, with ranks 1–5. `PROC RANK` produces five nearly equal groups in every year. Equation (2) uses cumulative USD IB (item 18 / `IB`) for fiscal years `t+1` through `t+k`, divided by `MVE_t`; Equation (3) uses fiscal years `t−j` through `t`, divided by `MVE_(t−j−1)`. All seven nonconstant regressors are present, including rank × DR and the rank × return × DR triple interaction.
- **Trim and sample.** The implementation applies a common firm-year rule: within each formation year it ranks the eight annual price-deflated earnings and returns and all eight horizon-specific earnings and returns into 200 groups, then deletes a firm-year in either tail of any variable. This yields 56,313 complete-history candidates and 49,354 rows after the union of tail deletions; MTB rank is then formed on those 49,354 rows. The paper does not specify the trimming reference population, tie handling, or trim/rank order, so year-specific 200-group trimming and ranking afterward remain explicit best-effort choices. No extra outlier, industry, size, or loss-firm restriction was added.

## Native estimates and source comparison

Every baseline fit has 28 annual cross-sections. The native Stata logs show all annual OLS fits are full rank 8 (intercept plus seven regressors), with positive residual degrees of freedom. Each `xtfmb` fit uses the common 49,354 firm-years. The paper's focal coefficients are `b1` (MTB rank × return: good-news association), `g1` (MTB rank × return × DR: asymmetric-timeliness association), and `b1+g1` (bad-news association). The `rank × DR` term and all return terms are included in every fit. Native standard errors, t-statistics, and two-sided p-values below come from the A2 Stata logs and native `lincom` results; the paper prints t-statistics and 5%/10% stars.

### Table 4A: future horizons

| Horizon | Source b1 (t) | A2 b1 (SE; t; p) | Source g1 (t) | A2 g1 (SE; t; p) |
| --- | ---: | ---: | ---: | ---: |
| k=1 | −0.0203 (−6.28) | −0.0142428 (0.0028807; −4.94; <0.001) | −0.0911 (−6.54) | −0.0627823 (0.0108470; −5.79; <0.001) |
| k=2 | −0.0265 (−10.23) | −0.0214917 (0.0027849; −7.72; <0.001) | −0.1458 (−5.09) | −0.1018838 (0.0181975; −5.60; <0.001) |
| k=3 | −0.0280 (−4.11) | −0.0274665 (0.0026873; −10.22; <0.001) | −0.1508 (−5.85) | −0.1132640 (0.0172782; −6.56; <0.001) |

| Horizon | Source b1+g1 (t) | A2 b1+g1 (SE; t; p) |
| --- | ---: | ---: |
| k=1 | −0.1114 (+7.97 in table; −7.97 in text) | −0.0770251 (0.0102450; −7.52; <0.001) |
| k=2 | −0.1724 (−5.95) | −0.1233755 (0.0197065; −6.26; <0.001) |
| k=3 | −0.1788 (−7.24) | −0.1407305 (0.0175739; −8.01; <0.001) |

The paper's Table 4A reports `b1`, `g1`, and `b1+g1` as negative and significant at all horizons; A2 matches those level signs and significance, with smaller slopes. For k=1, the paper table prints a positive t-statistic (+7.97) next to the negative `b1+g1` estimate; the accompanying discussion gives −7.97, but has a decimal typo in the estimate (−0.0114 rather than the table's −0.1114). For the changes across k, A2 finds `b1` significantly more negative at both steps (p=0.005 and 0.010), while the source reports the k3−k2 change as insignificant. The source's k2−k1 `g1` change is significant; A2's estimate has the same negative direction but p=0.087. The k3−k2 `g1` and `b1+g1` changes are insignificant in both. The k2−k1 `b1+g1` change is significant in both, subject to the source table's positive t-statistic beside a negative estimate. The paper reports 45,664 firm-years and 925 firms in 1972 rising to 1,622 in 1999. A2 uses 49,354 firm-years, with annual final counts 1,055 and 2,124 in those endpoint years. This is 3,690 additional rows (8.1% above the source total); the annual endpoint counts are also larger. The source does not report per-fit annual N. I found no extra industry/size filter or unreported negative-income screen in the build, so the discrepancy remains unresolved and is not attributed to vintage or timing without supporting diagnostics.

### Table 5A: historical horizons

| Horizon | Source b1 (t) | A2 b1 (SE; t; p) | Source g1 (t) | A2 g1 (SE; t; p) |
| --- | ---: | ---: | ---: | ---: |
| j=0 | −0.0142 (−5.49) | −0.0113218 (0.0025558; −4.43; <0.001) | −0.0242 (−2.94) | −0.0210394 (0.0071203; −2.95; 0.006) |
| j=1 | −0.0316 (−7.97) | −0.0353988 (0.0050905; −6.95; <0.001) | 0.0001 (0.50) | 0.0046294 (0.0104867; 0.44; 0.662) |
| j=2 | −0.0442 (−10.02) | −0.0499244 (0.0030763; −16.23; <0.001) | 0.0328 (3.72) | 0.0412645 (0.0107078; 3.85; 0.001) |
| j=3 | −0.0651 (−14.37) | −0.0706445 (0.0032828; −21.52; <0.001) | 0.0455 (3.29) | 0.0661360 (0.0164560; 4.02; <0.001) |
| j=4 | −0.0822 (−14.37) | −0.0860062 (0.0041117; −20.92; <0.001) | 0.0605 (3.08) | 0.0425570 (0.0195090; 2.18; 0.038) |

| Horizon | Source b1+g1 (t) | A2 b1+g1 (SE; t; p) |
| --- | ---: | ---: |
| j=0 | −0.0383 (−4.87) | −0.0323612 (0.0064933; −4.98; <0.001) |
| j=1 | −0.0315 (−3.19) | −0.0307694 (0.0104253; −2.95; 0.006) |
| j=2 | −0.0114 (−1.12) | −0.0086599 (0.0110859; −0.78; 0.442) |
| j=3 | −0.0196 (−1.57) | −0.0045085 (0.0161122; −0.28; 0.782) |
| j=4 | −0.0217 (−1.00) | −0.0434492 (0.0185741; −2.34; 0.027) |

The paper's Table 5A focal-level signs and 5% inference agree with A2 through all five `g1` horizons and all five `b1` horizons. The `b1+g1` tests also agree for j=0–3, but not at j=4: the source t-statistic (−1.00) is insignificant, while A2's native linear combination is significant at two-sided p=0.027. For the adjacent changes, A2 confirms the source's significantly more negative `b1` at every step. The source reports significant positive `g1` changes at j1−j0 and j2−j1; A2 agrees at those steps, while neither source nor A2 finds significant later changes. The point estimates differ in sign at j3−j2 for `b1+g1` and j4−j3 for `g1`, but both pairs of tests are insignificant. A2's `g1` turns down at j4, whereas the source estimate continues upward. Its `b1+g1` slope becomes more negative at j4 and is significant in level, unlike the source's j4 estimate; the j4−j3 change itself is insignificant in both. The table and variable note specify j=0–4 even though the Equation (3) body paragraph says j=0–2; all five table horizons are retained.

### Adjacent-horizon coefficient contrasts

The paper also tests adjacent changes in `b1`, `g1`, and `b1+g1` within Tables 4A and 5A. I used the standard `asreg` by-year coefficient variables in memory, kept one paired observation per formation year, and estimated each annual difference with a native constant-only OLS regression. The coefficient means from `asreg` match the baseline `xtfmb` means exactly to the displayed precision. Each contrast uses the same 28 matched years; no cross-model independence assumption is used.

| Table / contrast | Source Δb1 (t) | A2 paired Δb1 (SE; t; p) | Source Δg1 (t) | A2 paired Δg1 (SE; t; p) | Source Δ(b1+g1) (t) | A2 paired Δ(b1+g1) (SE; t; p) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 4A, k2−k1 | −0.0062 (−2.13) | −0.0072489 (0.0023931; −3.03; 0.005) | −0.0548 (−2.05) | −0.0391016 (0.0220426; −1.77; 0.087) | −0.0609 (+2.35 printed) | −0.0463504 (0.0224508; −2.06; 0.049) |
| 4A, k3−k2 | −0.0015 (−0.21) | −0.0059748 (0.0021662; −2.76; 0.010) | −0.0049 (−0.16) | −0.0113801 (0.0226819; −0.50; 0.620) | −0.0064 (−0.22) | −0.0173550 (0.0232250; −0.75; 0.461) |
| 5A, j1−j0 | −0.0174 (−5.28) | −0.0240770 (0.0057750; −4.17; <0.001) | 0.0243 (2.35) | 0.0256688 (0.0099749; 2.57; 0.016) | 0.0067 (0.64) | 0.0015918 (0.0097238; 0.16; 0.871) |
| 5A, j2−j1 | −0.0126 (−2.97) | −0.0145256 (0.0045654; −3.18; 0.004) | 0.0328 (2.74) | 0.0366351 (0.0134890; 2.72; 0.011) | 0.0202 (1.82) | 0.0221095 (0.0130967; 1.69; 0.103) |
| 5A, j3−j2 | −0.0209 (−4.65) | −0.0207201 (0.0034577; −5.99; <0.001) | 0.0127 (0.74) | 0.0248714 (0.0198372; 1.25; 0.221) | −0.0082 (−0.83) | 0.0041514 (0.0188671; 0.22; 0.828) |
| 5A, j4−j3 | −0.0171 (−4.07) | −0.0153617 (0.0044681; −3.44; 0.002) | 0.0150 (0.80) | −0.0235790 (0.0244654; −0.96; 0.344) | −0.0021 (−0.04) | −0.0389407 (0.0236395; −1.65; 0.111) |

The main inference differences in the published adjacent-contrast rows are: Table 4A's k2−k1 `g1` change is marked significant by the source but has A2 p=0.087; Table 4A's k3−k2 `b1` change is insignificant in the source but has A2 p=0.010; and Table 5A's j2−j1 bad-news change receives a 10% star in the source but A2 p=0.103. The point estimate sign also differs for Table 5A's j3−j2 `b1+g1` contrast and j4−j3 `g1` contrast, although both source and native tests are insignificant. Table 4A prints a positive t-statistic (+2.35) beside the negative k2−k1 bad-news change; the native paired estimate is negative with t=−2.06 and p=0.049.

### Table 1 descriptive comparison

These are pooled firm-year statistics for the actual 49,354-row common analysis sample, matching the grain of Table 1. Returns and earnings ratios are decimals; MTB is dimensionless. Source figures are from the paper's Table 1 (printed p. 16); sample figures are from A1's SAS `PROC MEANS` and A2's native Stata `summarize, detail` output.

| Construct | Paper mean / SD | A2 sample mean / SD |
| --- | ---: | ---: |
| `MTB_t` | 2.26 / 2.47 | 2.0364 / 5.2082 |
| `R_(t+1,t+1)` | 0.1744 / 0.4234 | 0.1718 / 0.4846 |
| `R_(t+1,t+2)` | 0.3734 / 0.6589 | 0.3483 / 0.7003 |
| `R_(t+1,t+3)` | 0.6111 / 1.0095 | 0.5472 / 0.9758 |
| `E_(t+1,t+1)/P_t` | 0.0859 / 0.1358 | 0.0784 / 0.1272 |
| `E_(t+1,t+2)/P_t` | 0.1883 / 0.2494 | 0.1673 / 0.2411 |
| `E_(t+1,t+3)/P_t` | 0.3216 / 0.8015 | 0.2622 / 0.3748 |
| `R_(t,t)` | 0.1745 / 0.4106 | 0.1764 / 0.4830 |
| `R_(t−1,t)` | 0.3853 / 0.6756 | 0.3635 / 0.7203 |
| `R_(t−2,t)` | 0.6177 / 0.9917 | 0.6058 / 1.0440 |
| `R_(t−3,t)` | 0.8808 / 1.3563 | 0.8639 / 1.4045 |
| `R_(t−4,t)` | 1.1822 / 1.8115 | 1.1701 / 1.8781 |
| `E_(t,t)/P_(t−1)` | 0.0906 / 0.1101 | 0.0840 / 0.1187 |
| `E_(t−1,t)/P_(t−2)` | 0.2033 / 0.2191 | 0.1906 / 0.2247 |
| `E_(t−2,t)/P_(t−3)` | 0.3360 / 0.3506 | 0.3215 / 0.3529 |
| `E_(t−3,t)/P_(t−4)` | 0.4885 / 0.5124 | 0.4723 / 0.5094 |
| `E_(t−4,t)/P_(t−5)` | 0.6769 / 0.8183 | 0.6441 / 0.7010 |

MTB's source quartiles are 0.96, 1.52, and 2.55; the A2 sample quartiles are 0.8943, 1.3758, and 2.2068. The sample MTB distribution is sharply right-skewed (maximum 678.09, skewness 76.02); the source does not prescribe an MTB trim, so I did not add one. The largest visible descriptive mismatch is MTB dispersion, followed by the forward three-year earnings ratio's standard deviation. The handoff does not retain `MVE_t`, so the source Table 1 mean and SD for `P_t` cannot be checked from the final Stata sample file.

## Remaining assumptions and limits

1. The source has incompatible forward-return start dates and denominator dates: Equation (2) says `P_t` at year `t` and returns beginning in fiscal year `t+1`; Table 4A's variable note says `P_(t−1)` and starts returns in fiscal year `t`. Table 1 describes `P_t` at year `t`. The implementation follows Equation (2) for `P_t` and uses adjacent complete twelve-month fiscal-return periods, consistent with the general data description. The return windows are explicitly documented in `design.md`.
2. The source does not specify the estimator inside each annual cross-section beyond Fama–MacBeth. Ordinary OLS within `xtfmb`, without added clustering or HAC, is the documented best-effort implementation.
3. The paper does not state whether the 0.5% cutoffs are pooled or year-specific, how ties are handled, or whether trimming precedes ranking. The common year-specific union trim and subsequent rank are explicit assumptions.
4. The 45,664 versus 49,354 sample difference, larger annual endpoint counts, the high MTB dispersion, and several Table 1 earnings/return differences remain unexplained after checking source filters, period alignment, link logic, FX treatment, and the final sample. Current source vintage, link coverage, and exact sample implementation remain possible explanations, but none is established by these diagnostics.
5. The tables export the template-required (R^2); adjusted (R^2) is unavailable from `xtfmb` and is left blank with a note rather than manufactured. No source (R^2) benchmark is reported in Tables 4A or 5A.
