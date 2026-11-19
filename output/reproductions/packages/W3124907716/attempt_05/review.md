# Independent review: W3124907716, attempt 05

## Scope and execution

This repair preserves the nine assigned pooled probit scopes, six SAS handoffs, source screens, estimators, target definitions, and earlier accounting corrections from A4. It fixes two specific provider-field semantics in the currency construction: daily exchange-rate provenance is not a quote key, and the annual PRCC_F historical price issue is FUNDA.HIID rather than FUNDA.IID.

The attempt package synchronized and validated with nine scopes and no pre-run warnings. Native SAS completed in `runtime/20261102T224626612023Z`; all six handoffs and the Stata data conversions completed. There are 74,603 Compustat rows after the source screens, no duplicate GVKEY-fiscal-year keys, 1,150 modified-Jones groups, 976 forward-looking `k` groups, and 942 forward-accrual groups. IBES linking retained 52,359 last-summary rows, 49,693 ticker/PERMNO links, 49,256 CCM/GVKEY links, and 37,061 unique forecast company-years; there were no ambiguous forecast keys.

Stata reran all nine cells on the new handoffs in `runtime/20261102T224710477438Z`. Eight converged and produced all four template exports (`.md`, `.rtf`, `.csv`, `.tex`). The corrected Table 2 target-2 fit was attempted on all 3,144 SAS rows. Stata removed 1 observation in SIC2 14, 11 in SIC2 45, and 4 in SIC2 75 for perfect prediction, leaving 3,128. The likelihood flattened at −1,254.5605 by iteration 5 and remained there through iteration 300; Stata reported 48 failures and 41 successes completely determined, printed “convergence not achieved,” and returned `r(430)`. It has no valid estimate or exports. I did not alter the estimator, tune the sample, or substitute an optimizer.

## Evidence checked and construction changes

The original article’s construction, sample screens, and formulas were checked against printed pp. 502–504 (PDF pp. 12–14), Table 1 (printed p. 511 / PDF p. 21), and the assigned results in Tables 2–4 (printed pp. 513–515 / PDF pp. 23–25). The 2011 Xpressfeed documentation identifies annual `CURCD` separately from security-price currencies `CURCDD` and `CURCDM`; it directs `EXRATD` for stocks and prices and `EXRAT12M` for annual flows. Its GBP conversion is `rate(GBP→target)/rate(GBP→source)` (physical guide pp. 84–88, printed pp. 76–80). The 2004 Research Insight guide defines A199/`PRCC_F` as the fiscal-year-end close, says it includes within-year split and stock-dividend adjustments, reports Canadian `$T` prices in CAD, and notes the last-trading-day close for suspended securities (physical pp. 674–675, printed pp. 624–625).

The local catalog labels `FUNDA.IID` as Header Primary Global Issue ID and `FUNDA.HIID` as Historic Primary Global Issue ID. A4 joined `PRCC_F` through `IID` and its daily fallback selected prior same-header-IID quotes. This attempt keys annual price currency to `HIID`. A same-GVKEY/HIID `SEC_MTHPRC` quote in the fiscal month is accepted only with a single row/date, a unique known `CURCDM`, and nonmissing `PRCCM` agreeing with nonmissing `PRCC_F` at tolerance `max(1e−8, abs(PRCC_F)×1e−6)`. A dated `SEC_MTH.PRIMISS='P'` marker corroborates the route when present; an absent marker alone is not a contradiction. An explicit non-P or ambiguous marker blocks the route.

For monthly-unresolved keys, the daily fallback uses only `SEC_DPRC` records for the same GVKEY and historical HIID. It accepts an exact annual date or a prior quote no more than seven calendar days earlier, with one known `CURCDD`, `PRCCD` agreeing with `PRCC_F`, and zero intervening exchange sessions in `CRSP.DSI`. Missing monthly primary markers do not invalidate a matching same-HIID/date/price quote. Explicit conflicting marker evidence, ambiguous currencies, and mismatched prices remain unavailable. The actual matched monthly or daily price date supplies the daily FX join. A4’s hundreds of days or years old quotes are not transferred.

A bounded provider audit covered 53,605 annual price keys. It verified 44,362 monthly HIID routes and 24 daily HIID routes (15 exact date, 9 short market-closure lags), for 44,386 supported annual price currencies and 9,219 unsupported. A small aggregate follow-up confirmed that every one of the 44,362 verified monthly quotes had the same `DATADATE` as annual `FUNDA.DATADATE` (no earlier same-month matches); all had a same-date `PRIMISS='P'` marker. Production status classes include 2 monthly price-diff keys and 235 daily price-diff keys; the separate daily mismatch indicator is 237 because it also counts the two monthly-diff keys when daily quotes were checked. Four additional unresolved keys received the production status label `DAILY_MARKET_GAP`, whose status predicate does not require a PRCCD/PRCC_F match. The bounded route audit’s price-agreement predicate found zero short-lag price-agreeing quotes spanning CRSP market sessions, so these four are treated as unverified candidates, not as supported or confirmed price contradictions. Another 115 price-agreeing daily quotes were 8–366 days old; none is transferred. The mutually exclusive unresolved status counts are 2,275 missing HIID, 6,586 generic unsupported, 2 monthly price-diff, 2 monthly price-missing, 235 daily price-diff, 115 stale daily, and four `DAILY_MARKET_GAP` labels, totaling 9,219.

The independent A4 route comparison found 42,443 strict header-IID monthly verifications. The corrected HIID routes recover 1,944 keys versus that strict route, leave one header-only match unconfirmed, and have no currency disagreements in their verified overlap. Nine verified overlaps use different header and historic issue IDs but have matching currencies. A4 also had ten legacy header-route flags with missing `PRCC_F` and missing price gaps. These are false source-key verification flags; they could not enter final target-1 or target-2 samples because positive market value is needed for EM classification. Target 3 classifies from IBES forecast error and does not use price.

The other correction removes `EXRATTPD` equality from the GBP quote join. It is retained separately for the source and target rate legs. In the bounded provider record for 31 Dec 1999, the CAD quote’s descriptor is blank and the USD quote’s is `AR`; A4’s equality join produced no pair. The corrected same-date CAD→USD and USD→CAD factors are 0.68902569 and 1.45132469, and the monthly flow factors are 0.67326229 and 1.48530522. The production source contains 521,084 positive daily quotes over 3,653 dates and 17,732 positive monthly quotes over 120 dates, with no missing/nonpositive rates or duplicate source currency-date keys. Pairing the required currencies yields 7,306 daily and 240 monthly date/rate factors, including 44 daily factors with a blank descriptor on at least one leg and 20 with mixed descriptors. The code preserves separate leg descriptors in the rate-pair data and in model support.

All money conversions remain at the source item’s own date. The panel joins prior assets at prior annual `DATADATE`, lagged sales/NI/CFO at the same prior date using `EXRAT12M`, t−2 assets at the t−2 date, future sales at the lead date using `EXRAT12M`, and lagged price at its actual matched price date using `EXRATD`. Exact fiscal-year joins preserve missing years; same-currency amounts pass through unchanged. In the production complete-case support there are no missing required stock or flow cross-rates. At final handoff grain, accounting/price currency switches occur only in Table 2/3 targets 1 and 2 (one each); their required daily and monthly factors are present. Table 4 handoffs have no cross-currency switches. The historical-price route summary at final handoff grain is:

| Handoff | Monthly | Exact daily | Closure daily | Unresolved price currency |
|---|---:|---:|---:|---:|
| Tables 2–3, target 1 | 4,996 | 0 | 0 | 0 |
| Tables 2–3, target 2 | 3,142 | 1 | 1 | 0 |
| Tables 2–3, target 3 | 3,811 | 0 | 0 | 282 |
| Table 4, target 1 | 4,106 | 0 | 0 | 0 |
| Table 4, target 2 | 2,557 | 1 | 1 | 0 |
| Table 4, target 3 | 3,155 | 0 | 0 | 77 |

The unsupported price statuses appear in target 3 handoffs only, where the paper’s forecast-error target does not use price. The counts above are at each final analysis handoff, distinct from the 53,605 source price keys.

## Earlier accounting and sample decisions retained

The provider mapping supports item #123 as `IBC` (item #18 is `IB`); #6 `AT`, #7 `PPEGT`, #12 `SALE`, #25 `CSHO`, #50 `TXDI`, #124 `XIDOC`, #172 `NI`, #199 `PRCC_F`, #302 `RECCH`, and #308 `OANCF` remain as in A4. Continuing cash flow is `OANCF−XIDOC`, so `TAcc=[IBC−(OANCF−XIDOC)]/AT(t−1)`, `DTE=TXDI/AT(t−1)`, and `CFO=(OANCF−XIDOC)/AT(t−1)`. `RECCH` is “Accounts Receivable - Decrease (Increase),” so `ΔAR=−RECCH/AT(t−1)`. No missing source component is set to zero.

The paper defines EM2 as `NI_t/MVE_(t−1)` without requiring lagged NI. The 84 support rows identified in A4 with current NI/market value but missing prior NI remain eligible for EM2. The build retains the adjacent-fiscal-year joins, 1994–2000 Tables 2/3 window and 1994–1999 Table 4 window, source industry exclusions, target-specific non-EM calibration populations, N≥10 SIC2-year auxiliary fits, and the explicit p. 504 DTE-tail plus absolute scaled-accrual screen. The table-note ambiguity about percentile trimming all accrual variables remains unresolved and is documented in `design.md`.

## Sample sizes and estimates

Published Ns are from Tables 2–4. “A4 / A5 handoff” is the pre-Stata SAS sample; “A5 Stata” is the estimation N after perfect-prediction removals. The attempted N for Table 2 target 2 is not a converged estimate.

| Scope | Published N | A4 / A5 handoff | A5 Stata N / status |
|---|---:|---:|---:|
| Table 2, target 1 | 4,139 | 4,769 / 4,996 | 4,995, executed |
| Table 2, target 2 | 2,785 | 2,994 / 3,144 | 3,128 attempted, blocked `r(430)` |
| Table 2, target 3 | 2,530 | 4,093 / 4,093 | 4,077, executed |
| Table 3, target 1 | 4,139 | 4,769 / 4,996 | 4,995, executed |
| Table 3, target 2 | 2,785 | 2,994 / 3,144 | 3,128, executed |
| Table 3, target 3 | 2,530 | 4,093 / 4,093 | 4,077, executed |
| Table 4, target 1 | 3,352 | 3,900 / 4,106 | 4,106, executed |
| Table 4, target 2 | 2,254 | 2,438 / 2,559 | 2,542, executed |
| Table 4, target 3 | 2,279 | 3,232 / 3,232 | 3,207, executed |

The final handoffs grow relative to A4 for the price-sensitive targets: +227 and +150 rows for Tables 2/3 targets 1/2, and +206 and +121 rows for Table 4 targets 1/2. Target 3 is unchanged. The provider-price audit and corrected rate join demonstrate new supported routes, but I do not assign every net sample change to a single cause. All A5 handoffs remain above the published Ns.

The article describes multivariate p-values as one-tailed (physical p. 22 / printed p. 512), while Table 2 labels “Prob > chi-square” (physical p. 23 / printed p. 513). The source convention is ambiguous; published p-values below are retained as reported, and A5 two-sided Stata p-values are shown without conversion. Coefficient estimates are rounded as exported.

| Scope | DTE: published b (p); A5 b (two-sided p) | Accrual variable: published b (p); A5 b (two-sided p) |
|---|---|---|
| Table 2, target 1 | 3.7785 (.0153); 3.718 (.026) | TAcc .9583 (<.0001); 1.406 (<.001) |
| Table 2, target 2 | 5.4334 (.0129); no valid fit | TAcc 41.6193 (<.0001); no valid fit |
| Table 2, target 3 | .7243 (.7033); .986 (.466) | TAcc .6160 (.0422); .068 (.732) |
| Table 3, target 1 | 3.6868 (.0178); 3.632 (.029) | AbAccMJ .1423 (.2506); .176 (.089) |
| Table 3, target 2 | 8.8055 (<.0001); 9.549 (<.001) | AbAccMJ .8854 (<.0001); .595 (<.001) |
| Table 3, target 3 | .8058 (.6720); .913 (.501) | AbAccMJ −.0730 (.6925); .117 (.422) |
| Table 4, target 1 | 2.7257 (.1157); 4.167 (.025) | AbAccFL .6395 (.0002); .884 (<.001) |
| Table 4, target 2 | 10.2743 (<.0001); 11.446 (<.001) | AbAccFL .6174 (.0008); 1.148 (<.001) |
| Table 4, target 3 | .3648 (.8630); 1.100 (.509) | AbAccFL −.0039 (.9868); .239 (.291) |

Among the eight valid fits, DTE is significant in targets 1 and 2 and insignificant in target 3 in all three tables. Table 2 target-3 TAcc remains insignificant locally (p=.732 versus published .0422). Table 4 target-1 DTE is significant locally (p=.025) while the published p is .1157. Tables 2/3 target-1 DTE coefficients and Table 3 target-1 abnormal accrual remain close to published magnitudes; other local abnormal-accrual coefficients are generally larger. The blocked Table 2 target-2 result cannot be assessed.

### Descriptive comparison

SAS means below use the final handoffs, before Stata’s perfect-prediction deletions. Each ordered pair is EM=1 / EM=0. Published means are from Table 1 (printed pp. 509–510); Table 4’s published AbAccFL group sizes are the shorter forward-accrual samples, as discussed in A4. Local values compare A4 to A5 in parentheses where useful.

| Sample / target | EM group N, A4 → A5 (published) | DTE means A5 (A4; published) | TAcc means A5 (A4; published) | Abnormal-accrual means A5 (A4; published) |
|---|---|---|---|---|
| Tables 2–3, target 1 | 2,983/1,786 → 3,126/1,870 (2,495/1,644) | .00155/.00082 (.00149/.00064; .0015/.0005) | −.03419/−.04298 (−.03291/−.04211; −.0443/−.0500) | AbAccMJ .05500/.05485 (.05471/.05870; −.0126/−.0110) |
| Tables 2–3, target 2 | 1,948/1,046 → 2,043/1,101 (1,794/991) | −.00325/−.00629 (−.00329/−.00645; −.0027/−.0056) | −.02640/−.04976 (−.02383/−.04782; −.0332/−.0530) | AbAccMJ .06311/.05354 (.06718/.05457; .0049/−.0053) |
| Tables 2–3, target 3 | 3,242/851 → 3,242/851 (2,021/509) | −.00015/−.00043 (−.00015/−.00043; .0007/.0002) | −.03351/−.03551 (−.03351/−.03551; −.0285/−.0358) | AbAccMJ .02968/.02573 (.02968/.02573; −.0060/.0001) |
| Table 4, target 1 | 2,509/1,391 → 2,638/1,468 (2,057/1,295*) | .00159/.00081 (.00147/.00066; .0015/.0005) | −.03136/−.04104 (−.03038/−.04011; −.0443/−.0500) | AbAccFL .03938/.03176 (.03875/.03028; −.0009/−.0071) |
| Table 4, target 2 | 1,601/837 → 1,675/884 (1,473/781*) | −.00319/−.00675 (−.00320/−.00688; −.0027/−.0056) | −.02876/−.05029 (−.02676/−.04877; −.0332/−.0530) | AbAccFL .04166/.03168 (.04282/.03043; .0047/−.0008) |
| Table 4, target 3 | 2,529/703 → 2,529/703 (1,743/436*) | .00011/−.00034 (.00011/−.00034; .0007/.0002) | −.03304/−.03379 (−.03304/−.03379; −.0285/−.0358) | AbAccFL .02450/.02103 (.02450/.02103; −.0013/.0031) |

`*` Published Table 4 group counts for AbAccFL. Table 4 reports 2,279 target-3 observations while the Table 1 AbAccFL groups sum to 2,179; this source discrepancy is retained. Descriptive DTE and TAcc levels stay close to A4 and the paper, with modest shifts in targets 1/2 as eligible price/currency support changes. Abnormal-accrual means remain positive locally across all EM groups, unlike the mostly zero or negative published means; the currency repairs do not resolve that discrepancy.

## Remaining limitations

The current Compustat and IBES vintages do not establish historical-vintage equivalence or full study-population coverage. The price audit leaves 9,219 annual keys unsupported, including missing historical issue identifiers, price disagreements, ambiguous provider routes, stale daily matches, and market-session gaps. Only the 24 exact/short-gap daily routes with direct same-HIID, date, price, and currency evidence are retained. No SEC_DPRC field identifies suspended status, so the documented short closure rule is an evidence-based approximation, not a universal suspension test. The ten A4 missing-price flags are described only as source-key misclassifications, not as attrition in final model samples.

The paper’s IBES split adjustment-factor screen is unavailable in the selected local fields. Ticker/company linkage, forecast vintage, and the 62-day fiscal-period match remain best effort. The source is silent on pooled versus target-specific DTE cutoffs, the `k` fit population and minimum group size, and probit covariance; this build retains the target-specific cutoff, N≥10 stability rule, and Stata default covariance. Table 1’s percentile note conflicts with the explicit p. 504 narrative, and Table 1’s EM1 timing conflicts with the primary Tables 2–4 notes; the choices and source evidence are documented in `design.md`. All nine scopes were executed or honestly recorded as blocked; no output was selected or altered to improve agreement with published results.
