# Independent review: W2048409281, attempt 2

## Scope and source checks

I reviewed the assigned frozen `work_item.json`, implementation snapshot, Stata template, predecessor A1 code and native outputs, the original paper PDF, and the local Compustat documentation. The paper's sampling section (printed p. 6) calls for U.S.-incorporated firms listed on NYSE, AMEX, or NASDAQ from 1974–2005, excluding utilities and financial firms. Table 4 and Eq. (1) (printed pp. 14–15) define exactly six fits: h=1 and h=2 over 1974–1983, 1984–1993, and 1994–2005. No Table 3, Table 5, repurchase, or future-dividend-payer model belongs in this attempt.

For both horizons, the paper defines adjusted earnings as `E(t) = IB(#18) + 0.6*XINT(#15) - 0.6*interest income(#62)`. The dependent rate is `E(t+h)/AT(t-1)` and the current earnings rate is `E(t)/AT(t-1)`; h=2 uses the same t−1 assets denominator. DP is based on annual cash dividends (#21), coded 1 for an observed positive DVC and 0 for an observed zero. Loss firms remain in the sample, and Table 4 has no future-dividend requirement. Both rates are capped at the fixed source bounds [-1,1], equivalent to ±100%, rather than percentile-winsorized. The model is OLS with an intercept, DP, current earnings rate, and DP × current earnings rate. The source specifies separate firm and year clusters and reports standard errors in parentheses. No fixed effects are specified.

The item mapping is source-supported. The local 2004 Compustat legacy guide maps annual item 62 to IINT (physical p. 261); the 2007 Xpressfeed guide maps modern FUNDA.IDIT to Interest Income (physical p. 18), NOPIO to nonoperating income excluding interest (p. 21), and lists the IDIT combination inputs (p. 80). The exact annual catalog has IDIT but not literal IINT or the combined-item code fields; TII is the distinct financial-services interest-income item and is not used. A1's bounded complete-input check found 81,152 rows with observed IDIT and NOPI/NOPIO. Of these, 59,584 (73.4%) are exactly equal in binary representation; all differences are within floating-point rounding (mean relative error 4.27e-17; median 0; maximum 5.32e-14). The provider's combination rules and absent local codes do not establish that a missing IDIT is a measured zero, so A2 leaves it missing.

## Construction audit and repair

The final build reads the five catalog-listed sources: COMP.FUNDA, monthly and daily Compustat FX, CCM link history, and CRSP MSENAMES. It retains fiscal years 1973–2007 for support, with actual source DATADATEs from 30Jun1973 through 31May2008. It applies current-year screens at current DATADATE, matches CCM and CRSP name rows at that date, treats missing link start/end dates as open bounds, and accepts P/C LC/LU links with common share codes 10/11 on exchanges 1/2/3. The CRSP/name join is aggregated back to one current firm-year before the accounting support joins; the Stata handoff's `isid gvkey fyear` check passed. Monthly and daily GBP-origin FX keys had no duplicates.

The current incorporation screen is `FUNDA.FIC='USA'`. The field is labeled current, and the authorized catalog has no dated incorporation history, so this is a timing limitation. Valid historical `FUNDA.SICH` is primary; when it is missing or zero, the build uses a unique SICCD from a date-valid linked CRSP name row. SICH is missing/zero through most of 1974–1986. In the overlap audit, exact four-digit SICs agreed on 24.8% of 99,448 rows, while the financial/utility screen agreed on 96.1%. Because the paper does not state code cutoffs, the build uses disclosed best-effort ranges: financial 6000–6999 and utility 4900–4999. It keeps SICH primary and does not use a current header industry in place of dated evidence.

The predecessor correctly identified two duplicate GVKEY/FYEAR keys (four rows for GVKEY 006557, FY1982 and FY1983), all missing IDIT. A1 excluded the full keys from both earnings and lagged-asset support. A2 repairs the role-specific asset input without selecting a whole statement: the build admits an AT value from a duplicate key only if exactly one row has observed positive AT and that same row has a positive USD conversion using its own DATADATE and CURCD. Current-year and future earnings remain restricted to unique GVKEY/FYEAR source periods, and no interest value is filled in.

The bounded check confirmed the two duplicate keys each have one observed positive AT and one blank row. The observed AT rows are 251.360 CAD at 31Aug1982 and 328.891 CAD at 31Aug1983. Unique daily GBP-to-CAD and GBP-to-USD rates exist on those exact dates; the bridge factors are 0.806972240 and 0.810372771, giving converted assets of 202.8405 and 266.5243 USD. A2's native build reports 334,853 unique earnings periods and 334,855 lag-asset support keys, including both duplicate keys. The GVKEY has no observed IDIT in any 1974–2005 current-year record, so this repair restores source-required lag-asset support but has zero effect on the six estimation samples and estimates. It does not choose a fiscal-year row or claim that missing interest income is zero.

IB, XINT, and IDIT use each row's own reporting currency and DATADATE with the documented 12-month GBP-intermediary FX rate. DP uses the sign of the observed raw DVC amount; a positive currency-conversion factor does not change its positive-versus-zero classification. AT uses its own DATADATE and daily GBP-intermediary rate. USD amounts use the identity rate; absent or nonpositive legs remain unavailable. This preserves the source flow/stock timing and avoids converting from header CURNCD. Daily and monthly FX duplicate-key checks passed.

## Table 4 results compared with the paper

The table compares the interaction slope β3. Coefficients and standard errors are on the paper's fraction scale: the interaction is the difference in future-earnings persistence per unit change in current earnings/lagged assets. Paper parentheses are standard errors. A2 exports p-values in parentheses under the frozen template, so the values below are taken from the native Stata logs; the reported p-values are two-sided cluster-robust tests. The paper's stars use its stated 10%, 5%, and 1% thresholds.

| Fit | N: paper / A2 (difference) | β3: paper (SE) | β3: A2 (SE), two-sided p | Adj. R²: paper / A2 |
| --- | ---: | ---: | ---: | ---: |
| Panel A, h=1, 1974–1983 | 23,042 / 16,378 (−6,664) | .0314 (.0110)*** | .0772 (.0496), .154 | .63 / .5155 |
| Panel A, h=1, 1984–1993 | 30,938 / 23,208 (−7,730) | .0795 (.0084)*** | −.0490 (.0709), .507 | .70 / .5070 |
| Panel A, h=1, 1994–2005 | 42,619 / 27,813 (−14,806) | .0643 (.0068)*** | −.0910 (.0459), .073* | .70 / .5714 |
| Panel B, h=2, 1974–1983 | 18,950 / 14,647 (−4,303) | .0245 (.0190) | .1436 (.0851), .126 | .43 / .2849 |
| Panel B, h=2, 1984–1993 | 27,769 / 20,661 (−7,108) | .0985 (.0120)*** | .0038 (.0787), .963 | .53 / .3414 |
| Panel B, h=2, 1994–2005 | 38,579 / 24,343 (−14,236) | .0992 (.0100)*** | −.1116 (.0890), .236 | .54 / .3866 |

The source interaction estimates are positive in all six fits and significant at 1% in five. In A2, only the 1994–2005 Panel A interaction is significant at 10%, and it is negative; no A2 interaction is significant at 5%. The 1974–1983 Panel B inference is nonsignificant in both, but the coefficient magnitudes differ. A2's adjusted R² values are below the source in all six cells. These are substantial discrepancies, not a numerical match.

Across these six fits, A2 has 22.7%–36.9% fewer observations than the paper. In the bounded dated-screen population of 128,290 current-year firm-years, 81,152 have observed IDIT (63.3%), so IDIT coverage is material. That diagnostic is before other accounting, FX, lag, and lead completeness and is not the same population as any Table 4 fit. It does not support attributing the full per-fit N gap to IDIT, or to a vintage effect. The reported samples and coefficients are retained without tuning.

## Descriptive statistics for actual fit samples

The A2 descriptive cells use `estpost tabstat` on the exact complete-case observations used in each regression. Each cell below is `mean (SD); p25/p50/p75`, rounded to the three decimals in the exported tables. Y is the corresponding one- or two-year-ahead earnings rate; E is current adjusted earnings/lagged assets; DP×E is their interaction.

| Fit | N | Y: mean (SD); quartiles | DP: mean (SD); quartiles | E: mean (SD); quartiles | DP×E: mean (SD); quartiles |
| --- | ---: | --- | --- | --- | --- |
| Panel A, h=1, 1974–1983 | 16,378 | .062 (.166); .033/.077/.124 | .578 (.494); 0/1/1 | .057 (.139); .035/.072/.110 | .051 (.064); 0/.039/.091 |
| Panel A, h=1, 1984–1993 | 23,208 | −.020 (.275); −.060/.042/.102 | .295 (.456); 0/0/1 | −.021 (.247); −.049/.044/.094 | .023 (.057); 0/0/.024 |
| Panel A, h=1, 1994–2005 | 27,813 | −.052 (.320); −.102/.038/.104 | .232 (.422); 0/0/0 | −.053 (.291); −.090/.039/.094 | .018 (.060); 0/0/0 |
| Panel B, h=2, 1974–1983 | 14,647 | .070 (.186); .030/.082/.138 | .579 (.494); 0/1/1 | .058 (.137); .036/.073/.110 | .051 (.064); 0/.040/.091 |
| Panel B, h=2, 1984–1993 | 20,661 | −.005 (.290); −.050/.044/.114 | .304 (.460); 0/0/1 | −.016 (.241); −.041/.045/.095 | .023 (.057); 0/0/.029 |
| Panel B, h=2, 1994–2005 | 24,343 | −.040 (.337); −.092/.041/.116 | .243 (.429); 0/0/0 | −.047 (.286); −.078/.041/.096 | .019 (.059); 0/0/0 |

## Code, execution, and remaining limitations

I checked the generated Stata cells against the assigned template. Each fit uses Stata 18, loads `reg.dta`, runs direct `reghdfe` OLS with `noabsorb` and separate firm/fiscal-year clusters, retains the intercept, and exports `.md`, `.rtf`, `.csv`, and `.tex` using `cells(b(star fmt(3)) p(par))`. The cells use no authored program, Mata, postfile, coefficient-dump, or `clear all`. Six matching `estpost` descriptive cells export the same four formats for the actual fit observations. `sync` and `validate` passed without warnings. The native SAS and handoff stages returned 0, and all six fit plus six descriptive Stata cells completed successfully. The build and native logs are in `runtime/20261103T064545819994Z/` and `runtime/20261103T064558563417Z/`.

Remaining source limits are the current-year FIC proxy for historical incorporation, best-effort SIC cutoffs and CRSP SICCD fallback where SICH is unavailable, the exchange-history interpretation described above, and missing observed IDIT. The catalog-listed FX files begin in January/February 1982; earlier non-USD firm-years without required date/currency legs remain unavailable rather than being assigned USD values. None of these limits establishes a specific cause for the full sample or estimate differences. Table 1 aggregates are unadjusted earnings (#18) for a different aggregate population and are not substituted for the Table 4 interest-adjusted outcome.
