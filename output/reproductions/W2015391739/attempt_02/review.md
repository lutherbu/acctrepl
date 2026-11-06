# Independent review and execution

## Scope and execution

The review covers the four frozen Table 2 fits for the 1963–1990 sample: bad-news and good-news regressions using actual and simulated returns. The source is the original paper, *Asymmetric timeliness tests of accounting conservatism*, especially PDF p. 12 (printed p. 106) and PDF p. 20 (printed p. 114). All four retained fits ran successfully in the fresh A2 Stata sessions. SAS construction, SAS-to-Stata handoff, and all four Stata cells passed in runtime `20261103T061021336319Z`. The regression and descriptive tables each have `.md`, `.rtf`, `.csv`, and `.tex` exports.

The frozen template constraints were followed: direct Stata `reg` estimates, `estpost` descriptives, and `esttab` exports with `cells(b(star fmt(3)) p(par))`, the frozen star levels, `r2`, `ar2`, `replace`, and `label`. The notebook has no authored programs, Mata code, metadata/coefficients dumps, or `clear all`.

## Source checks and repair

Table 2, paper PDF p. 20, defines `X` as Compustat item 18 earnings divided by firm market value nine months before fiscal year-end. It defines returns over the twelve-month interval beginning nine months before fiscal year-end. The build uses company market equity in the FYE−9 month and compounds the twelve CRSP monthly returns for FYE−8 through FYE+3. The sample is selected by Compustat fiscal-year labels 1963–1990; the required CRSP date range includes actual 1991 observations. In the final FY1990 rows, the latest return period is August 1991. Table 1, paper PDF p. 12, describes the sample as all firm-years with CRSP monthly returns and necessary Compustat Annual Industrial and Research data. No exchange or NYSE-only screen is imposed.

The material A1 defect was its currency translation. A1 averaged twelve `EXRAT1M` GBP cross-rate ratios and required twelve monthly quotes. The cached Compustat Xpressfeed *Using the Data* guide, PDF pp. 87–88 (printed pp. 79–80), specifies `EXRAT12M` for annual income and cash-flow translation at the statement reporting month. It specifies conversion from reporting currency to the GBP primary currency by dividing by the GBP-to-reporting-currency rate, followed by multiplication by the GBP-to-target-currency rate. The catalog confirms that `COMP.G_EXRT_MTH` contains `FROMCURM`, `TOCURM`, and numeric `EXRAT12M`.

A2 now translates non-USD `IB` from the record's own `CURCD` using the two `EXRAT12M` legs in the statement's month. GBP reporting currency uses the GBP-to-USD leg; USD is an identity conversion. A2 has no twelve-month quote gate. The prior monthly-average reconstruction remains in the build only as an audit and does not feed the model data.

The quote audit found 75,838 report-month/currency pairs, with one quote row per pair and no conflicting rates. Among the selected annual Compustat rows, A2 translates 4,844 of 12,110 CAD records using the provider period rate, compared with 4,722 CAD records that passed A1's twelve-month monthly-quote requirement. This adds 122 currency-eligible source rows and yields no A1-only rows. All 4,722 CAD factors that were complete under A1 differ numerically from the corresponding `EXRAT12M` factors. After market-data joins and trimming, the final dataset contains 89,988 rows, seven more than A1's 89,981.

The requested CAD firm-year audit shows the rate and value effect directly:

| Key | Statement month | IB in CAD millions | GBP→CAD `EXRAT12M` | GBP→USD `EXRAT12M` | USD factor | IB in USD thousands | A1 1-month quote audit |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| GVKEY 006557, FY1982 | Aug. 1982 | 14.500 | 2.210873 | 1.790666 | 0.809936 | 11,744.08 | 8 monthly quotes; A1's 12-month rule left IB untranslated |
| GVKEY 006557, FY1983 | Aug. 1983 | 20.618 | 1.939847 | 1.575897 | 0.812382 | 16,749.69 | 12 monthly quotes; A1 factor 0.812359 and translated IB 16,749.22 |

Neither key appears in the final A2 handoff after the downstream market-data joins. The provider conversion is therefore repaired and audited, while these two examples do not drive the retained fits.

## Construction audit

- The current period's `CURCD` is used; `CURNCD` is not substituted. `IB` is converted from millions into USD thousands before division by USD market equity in thousands.
- The return-window boundaries and return completeness checks are date-based. Fiscal year 1990 rows may use 1991 CRSP dates. Each final firm-year has one `GVKEY`/`FYEAR` key.
- The paper's within-year exclusion of each variable's top and bottom 1% is implemented as P1/P99 tail exclusion on `X` and actual `R` before the actual and simulated sign partitions. Simulated `R` is not trimmed again.
- The pooled supporting generator is `R_actual = b0 + b1*X + residual` on the full trimmed actual sample. Each simulated return uses its target firm's `X`, the pooled generator coefficients, and one residual from a different firm in the same fiscal year. A seeded random ordering followed by a one-position cyclic rotation is a bijection with zero self-assignments in all 28 years. One deterministic baseline draw is reported; the paper's additional simulations are outside the frozen scope.
- The selected anchor link ranks `P` ahead of `C` and `LC` ahead of `LU`, preserves open CCM endpoints, and omits tied top-ranked firm-year routes. The audit found zero ambiguous top-ranked anchors.
- Company market equity sums each distinct CRSP monthly `PERMNO` once within the date-valid CCM `PERMCO` at the anchor month. If any included issue has missing or nonpositive price-times-shares, the firm-year is excluded instead of using a partial sum. Company market equity differs from the selected primary issue value in 669 of 93,512 complete pre-trim firm-years; the company/primary ratio averages 1.006592 and ranges from 1 to 16.06438. Although `MSF` has no `SHRCD`, catalog-listed `MSENAMES` has date-effective `SHRCD` with `NAMEDT`/`NAMEENDT` and `PERMNO`. The bounded final-input audit matched every one of 90,615 constituent issue-months to exactly one effective name-history row at the actual `MSF.DATE`, with no missing or ambiguous match, missing share code, or PERMCO mismatch. Rebuilt constituent sums match all 89,977 stored company-month totals.
- The date-qualified audit finds codes 20/21 (certificates/Americus) and 30/31 (ADRs) in 437 issue-months across 431 company-months. Four company-months also have a code 10/11/12 ordinary-common or code 18 REIT issue: code 21 coexists with code 11 in three company-months, and code 31 with code 12 in one. In those four issue pairs, `NCUSIP`, CUSIP header, MSF CUSIP, and `SHRCLS` do not match. The remaining 427 certificate/ADR company-months have no code 10/11/12/18 issue recorded. This shows dated security-type co-occurrence, not duplicated valuation; PERMCO membership and the available identifiers do not establish ADR conversion ratios or claim equivalence. The source does not specify an ADR/certificate exclusion, so A2 retains all distinct PERMNOs and treats issue-type composition as a company-MVE limitation. The CRSP Stock and Index Data Description Guide (physical PDF p. 115; printed p. 111) identifies codes 14/15 and 74 as closed-end fund/UIT subtypes; these account for 80 final issue-months, including two code 74 issue-months. No 44/45 issues occur in the final inputs. The paper does not explicitly exclude these classes or funds, so no such screen was added.
- The final sample is larger than the paper's 49,951 firm-years. The A1-to-A2 change adds only seven final observations. The observed difference is not attributed to the currency repair alone, and no screen was added to approach the paper's count.

## Results against the paper

The paper reports the Table 2 slopes, t-statistics, R-squared, and N. Local regressions are native Stata OLS with intercepts and ordinary two-sided inference. Slopes are changes in scaled earnings `X` per unit of decimal return; coefficients and R-squared are rounded to three decimals here, and local t-statistics to two decimals. Parenthesized export values are local two-sided p-values rounded to three decimals. All four local p-values print as 0.000; the source reports t-statistics rather than p-values, so p-value sidedness cannot be directly compared.

| Fit | Paper slope / t / R² / N | A2 slope / t / R² / N |
| --- | --- | --- |
| Bad news, actual | 0.284 / 44.060 / 0.086 / 20,618 | 0.329 / 63.61 / 0.094 / 39,201 |
| Bad news, simulated | 0.493 / 81.170 / 0.243 / 20,498 | 0.460 / 97.42 / 0.195 / 39,140 |
| Good news, actual | 0.025 / 13.640 / 0.006 / 29,333 | 0.032 / 19.17 / 0.007 / 50,787 |
| Good news, simulated | 0.009 / 5.920 / 0.001 / 29,453 | 0.035 / 22.01 / 0.009 / 50,848 |

The supporting full-sample generator is also directionally consistent with Table 2 Panel C's `R` on `X` equation. Its A2 slope is 0.71513, t=87.93, R²=0.0791, N=89,988; the paper reports 0.852, t=64.720, R²=0.077, N=49,951. These are comparison results, not an additional retained fit.

Table 1 reports variances, not standard deviations. The full-sample A2 descriptive table reports variances for the same three variables; its sample is the actual trimmed estimation base and corresponding simulated returns. The local figures are:

| Variable | Paper mean / median / variance / min / max (N) | A2 mean / median / variance / min / max (N) |
| --- | --- | --- |
| Actual return | 0.164 / 0.081 / 0.276 / −0.835 / 4.595 (49,951) | 0.121 / 0.059 / 0.236 / −0.863 / 4.429 (89,988) |
| Simulated return | 0.164 / 0.085 / 0.277 / −2.627 / 5.034 (49,951) | 0.121 / 0.058 / 0.238 / −2.948 / 4.822 (89,988) |
| `X` | 0.063 / 0.081 / 0.029 / −2.521 / 0.715 (49,951) | 0.059 / 0.079 / 0.037 / −2.553 / 4.160 (89,988) |

The partition descriptives separately cover the four actual model input populations: actual bad news, simulated bad news, actual good news, and simulated good news. They report the count and mean/standard deviation of `X`, actual `R`, and simulated `R` within each partition.

## Remaining limitations

The provider crosswalk maps current `IB` to annual item A18. Historical vintage, restatement, and definition equivalence to the authors' item 18 data remains uncertain. The source also does not specify exchange-rate handling, a simulation seed, or a covariance correction. A2 uses the provider-documented exchange-rate method, current Compustat/CRSP/CCM vintages, ordinary OLS inference, and seed 20261103. The paper/local sample and regression discrepancies remain substantial, especially for N and the simulated good-news slope. Available construction diagnostics do not isolate the cause of the full sample-size or coefficient differences; possible contributors include vintage, Compustat row coverage and historical links, security-company mapping, and market-equity availability. No sample changes were made to improve numerical agreement.

The paper does not specify the share-code composition of company market equity. Date-effective codes are available through `MSENAMES`; all distinct issues remain included because the audit does not establish duplicate equity claims or a source-supported share-type screen. The lack of ADR ratios leaves cross-security valuation equivalence unresolved. Only the four frozen baseline regressions and one same-year simulated-return draw were executed; later sample years, repeated simulations, and robustness analyses are outside this assignment.
