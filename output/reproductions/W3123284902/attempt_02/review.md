# Independent review: W3123284902, attempt 02

## Scope and source interpretation

This attempt covers Table 5, Model 4, Panels A, B, and C. The paper describes monthly Fama–MacBeth regressions from July 1966 through December 2002, or 438 monthly cross-sections (physical p. 24 / printed p. 320). Each includes an intercept, annual log size and log book-to-market, the three monthly return controls, and both accounting predictors. The panels use the latest annual NOA/Accruals record, then the prior fiscal year, then two prior years. The paper does not report a firm-month N for these regressions or specify the first-stage estimator; the builder’s OLS rank audit and Stata’s `xtfmb` are appropriate best-effort implementations.

I read the original PDF pages against the builder. The NOA definition and legacy item numbers are on physical pp. 10–12 (printed pp. 306–308); simplifying operating assets minus operating liabilities gives `(DLC + DLTT + MIB + PSTK + CEQ − CHE) / prior-year AT`. Accruals follow Eq. (7) on physical p. 11 (printed p. 307): `(ΔACT − ΔCHE − ΔLCT + ΔDLC + ΔTXP − DP) / prior-year AT`. The code requires an actual prior fiscal-year record, positive prior assets, and consistent current/prior `CURCD`; only DLC, DLTT, MIB, PSTK, and TXP are zero-filled where the paper instructs. Required non-imputed items remain missing. The operating-asset and operating-liability AT terms cancel, but the prior-year denominator is still required.

Table 1’s note reports 141,254 firm-years for fiscal 1963–2000 alongside a broader monthly range (physical p. 12 / printed p. 308). That note does not state that FY2000 caps Table 5. The fiscal 1965–2000 window on physical p. 30 / printed p. 326 is explicitly for the separate Mishkin test. Table 5 instead specifies 438 monthly tests through December 2002 and at least a four-month fiscal-year-end gap; the paper also says the accounting characteristics refresh annually (physical p. 13 / printed p. 309). I interpret those Table 5 instructions as an as-of rule: the latest annual statement becomes eligible four calendar months after its fiscal year-end, is held for at most 12 months, and is replaced when the next annual statement becomes eligible. The local current vintage supports years through 2002. This does not use a future statement or extend FY2000 values past the refresh interval. The authors do not provide historical filing dates or explicitly reconcile the Table 1 range with the Table 5 end date, so the exact release timing remains an assumption.

The reused handoff confirms how this rule operates in the actual regression samples. Counts below are complete-case firm-months in calendar 2002 by the current annual snapshot year (`fyear_asof`); Panels B/C use that same snapshot for size/book-to-market and their one-/two-year older fiscal-year values for the accounting predictors.

| Panel | As-of FY2000 / FY2001 / FY2002 in calendar 2002 | December 2002 as-of FY2001 / FY2002 |
| --- | ---: | ---: |
| A | 9,098 / 29,379 / 965 | 2,914 / 379 |
| B | 9,029 / 29,047 / 953 | 2,881 / 375 |
| C | 8,928 / 28,742 / 947 | 2,852 / 373 |

Thus the executed specification uses FY2001 for most 2002 observations and a small FY2002 subset only after the four-month eligibility rule. This is a defensible reading of the monthly model, not a claim that the paper explicitly reports these years or counts.

## Construction and identifier review

The A2 `build.sas` is byte-identical to the final A1 builder; the sample declaration is also unchanged. I reviewed the final code, not the earlier development route described in the queue note. It correctly prefers INDL across industries, falls back to FS only for GVKEY/FYEAR keys with no INDL row, and retains financial firms. The final source audit reports 21,830 INDL/FS overlap groups, including 5,820 with financial SIC, with 73 FS-only keys. On audited core and price fields, INDL is more complete in the overlap. This resolves the earlier SIC-based FS selection issue; no generic financial-company exclusion, $5 screen, or trimming was reintroduced.

The market-value construction preserves the paper’s Table 1 definition, fiscal-year-end price times company common shares (Compustat #199 × #25; physical pp. 12–13 / printed pp. 308–309). The builder uses `PRCC_F × CSHO`, not summed issue shares, and requires positive USD market value and positive USD common equity for the log controls. It translates accounting equity and market value separately. The FX bridge uses the documented GBP cross-rate, positive rate legs paired on one date, and the latest paired daily quote on or before fiscal year-end, no more than seven calendar days earlier. It retains actual/carried-forward provenance per leg without an unsupported same-type screen. `CURCD` must agree across annual records used in changes; security-price currency comes separately from the dated issue-price source. Missing FX or price-currency evidence remains unavailable rather than being assumed USD.

The corrected price route is supported by the final audit. It matches the annual historical issue ID (`FUNDA.HIID`) to the same GVKEY, issue, and fiscal-end month in `SEC_MTH` and `SEC_MTHPRC`, and takes currency only from one unique dated price with `PRIMISS='P'`. The local marker frequency contains P and J. Among the 324,906 selected annual records, 239,772 have a dated exact-HIID descriptor and all are P; none is J. Of these, 232,283 have a unique dated price. The remaining 92,623 annual rows have no exact-HIID price currency: 85,134 have no exact descriptor, and 7,489 have a P descriptor without a matching dated price. These cases are left missing. The audit found 3,415 annual dates with multiple overall primary issues; each had one exact-HIID primary price, and 3,413 agreed with `PRCC_F` within the audit’s $0.011 comparison tolerance. It also found 1,507 unique overall-primary routes to a different issue with no HIID price; the final code does not transfer those other-issue currencies. Among all 232,019 comparable HIID prices, 231,981 were within the same tolerance and all 232,019 price/report currency codes agreed. Missing `CSHO` (3,044 rows) and zero `CSHO` (40 rows) are separately counted.

For linking and timing, the builder reads CRSP returns from July 1963 to December 2002, combines observed same-month `DLRET` with `RET`, and retains a valid delisting return when `RET` is missing. Missing returns are not set to zero. The lag controls require every expected calendar month: one return at t−1, 11 compounded returns from t−12 to t−2, and 24 from t−36 to t−13. I confirmed the table note on physical p. 24 / printed p. 320 specifies t−13; the body on physical p. 13 / printed p. 309 says t−12, so the table-specific window is used. The first fit month, July 1966, has return history back to July 1963.

CRSP name records are matched at their effective dates and screened to common shares and NYSE/AMEX/Nasdaq. CCM links are restricted to LC/LU and P/C, with P prioritized, HIID/LIID agreement used as a tie-break, and remaining ambiguous GVKEY-months excluded. Missing link boundaries are treated as open in both source filtering and the dated join. The final build reports 2,747,772 CRSP monthly rows with no duplicate PERMNO-month, 17,300 delisting months with no multiple events, 2,256,093 target common-name months, and 2,084,301 uniquely linked GVKEY-months with zero ambiguous primary candidates. The final handoff has 2,084,301 rows, 17,839 firms, no duplicate GVKEY-months, and spans July 1966–December 2002.

## Execution, sample sizes, and rank

Because final A1 and A2 construction code and the frozen sample declaration are unchanged, the helper verified and reused A1’s two SAS handoff files. A2 still ran all Stata cells independently. The A2 native logs show three successful `xtfmb` estimations, each with 438 time periods, and a successful descriptive cell. No SAS rebuild was needed. `sync` and `validate` completed without errors or warnings; validation reports three scopes and zero blocked scopes. The SAS build log/listing and Stata logs report successful execution.

| Panel | Complete firm-months | Monthly N range | Fitted / full-rank months | Rank per month |
| --- | ---: | ---: | ---: | ---: |
| A | 1,174,665 | 368–3,873 | 438 / 438 | 8 |
| B | 1,153,631 | 303–3,826 | 438 / 438 | 8 |
| C | 1,122,680 | 272–3,769 | 438 / 438 | 8 |

The SAS rank check uses OLS observations minus residual degrees of freedom (with the intercept) and reports no missing rank rows. Each model has seven slopes plus the intercept. These firm-month counts are actual sample outcomes. Table 5 does not report comparable per-month or pooled firm-month Ns; its 438 count refers to monthly coefficient estimates.

The notebook follows the assigned Stata template: each panel cell starts with `version 18` and `set more off`, loads its own `reg.dta`, sets the monthly panel, calls `xtfmb` directly, stores/clears estimates, and exports literal paths in `.md`, `.rtf`, `.csv`, and `.tex`. The estimates use the package’s default conventional Fama–MacBeth covariance, with no added weights, fixed effects, clusters, or HAC option. `estadd` adds the legitimate count of FMB months and the exported tables show firm-month N plus mean monthly R-squared. The native logs retain full-precision coefficients and t-statistics; all four table formats were inspected for focal variables, sample N, FMB months, and the R-squared row. The R-squared values are 0.0513, 0.0512, and 0.0521 (rounded to 0.051, 0.051, and 0.052 in exports); adjusted R-squared is not available from the Fama–MacBeth estimator.

## Results versus Table 5

The paper reports coefficients and time-series t-statistics, not firm-month Ns (physical p. 24 / printed p. 320). Coefficients below are in decimal monthly-return units; t-statistics are in parentheses. The paper’s significance note is two-tailed, as are the exported Stata p-values.

| Panel | Predictor | Published coefficient (t) | A2 coefficient (t) | Comparison |
| --- | --- | ---: | ---: | --- |
| A | Accruals | −0.0079 (−3.73) | −0.009226 (−4.59) | More negative; both significant |
| A | NOA | −0.0058 (−6.67) | −0.005742 (−6.19) | Coefficient close; reproduced t is smaller |
| B | Accruals | −0.0062 (−3.13) | −0.004268 (−2.35) | Less negative; both significant |
| B | NOA | −0.0023 (−2.68) | −0.004429 (−5.71) | More negative; stronger inference |
| C | Accruals | −0.0019 (−1.01) | −0.001822 (−1.05) | Close; neither significant |
| C | NOA | −0.0024 (−2.72) | −0.002063 (−2.84) | Close; both significant |

The principal estimate difference is Panel B NOA; Panel A accruals is also more negative than published. The signs and 5% significance classifications of all six focal coefficients agree with Table 5. For controls, Panel A log size, log B/M, and t−1 return are −0.001118, 0.002999, and −0.071332 versus −0.0011, 0.0028, and −0.0727 in print. The reproduced long return window is less negative in all panels; for Panel A it is −0.001508 versus −0.0021. I found no source-based reason to tune the annual support or screens to improve these differences.

Descriptive tables use each panel’s actual complete-case firm-month sample, not the Table 1 NOA-decile portfolio sample. Across panels, monthly return has mean 0.014 and median 0.000; log market value means range from 4.353 to 4.388, and log B/M means range from −0.458 to −0.453. Accruals / NOA mean (SD; median) are A −0.021 (1.044; −0.033) / 0.737 (1.543; 0.723), B −0.017 (0.188; −0.030) / 0.742 (0.568; 0.730), and C −0.009 (1.788; −0.027) / 0.821 (13.451; 0.737). The large Panel C NOA spread is retained because footnote 23 explicitly excludes trimming in Fama–MacBeth tests (physical p. 30 / printed p. 326). Negative book-value firms cannot form log B/M and are excluded as the paper states (physical p. 16 / printed p. 312).

## Repairs and remaining limits

The final A1 builder already repaired the two construction defects noted in earlier development: it restores annual lag cohorts in the annual-to-monthly expansion, and selects currency from the exact dated HIID primary-price record rather than dropping all multiple-primary companies or borrowing an unverified other issue’s currency. Its R-squared export is labeled as the available mean monthly R-squared. These repairs are present in A2’s unchanged final code and verified data; I made no construction or model-code changes. I clarified the horizon interpretation and the seven-day FX quote tolerance in A2 `design.md`.

Remaining best-effort assumptions are the within-month OLS estimator, CRSP `RET` as the Table 5 stock-return measure because the paper does not say whether it uses raw or adjusted returns, the paper’s four-month rule as the annual availability date in lieu of historical filing dates, use of eligible FY2001/limited FY2002 statements under the current local vintage, and use of the latest positive paired daily FX quote up to seven days before fiscal year-end. The paper does not report firm-month Ns, cross-sectional estimator details, or the exact annual refresh month algorithm. There is no evidence here that the observed sample-size or Panel B coefficient differences arise from one specific vintage or screen.
