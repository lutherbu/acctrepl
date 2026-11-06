# Design: W3125558500, attempt 02

## Source and scope

The assigned scopes are Table 4 Panel A (Equation 1) and Panel B (Equation 2). I use current local `COMP.FUNDA` as the available proxy for the paper's Annual Industrial and Research Compustat files. To identify one consolidated standard industrial-company annual record from the current North America file, the source pull uses `INDFMT='INDL'`, `CONSOL='C'`, `POPSRC='D'`, and `DATAFMT='STD'`. The study-year label is Compustat `FYEAR` 1976–2001; 1975 is retained only to construct the beginning-of-period market value for 1976. The source vintage and exact product equivalence to the 2007 paper are not established.

The original paper defines NI as item 172, PRETAX as item 170, and PRESPC as item 170 less special items item 17 (physical PDF pp. 12–13). I map these to `FUNDA.NI`, `FUNDA.PI`, and `FUNDA.SPI`; PRESPC is `PI-SPI`. The paper excludes SIC 6000–6500 and 4400–5000 (physical PDF p. 12). The build first uses valid dated `FUNDA.SICH`. When it is missing or invalid, it uses CRSP SICCD only through a date-active CCM link (`USEDFLAG=1`, `LINKPRIM` P/C, and `LINKTYPE` LC/LU) and date-effective `STOCKNAMES`. CRSP header SIC is not used. A single valid dated SIC fills the exact code. If multiple codes remain, exact industry stays unresolved; a shared exclude/include decision is used only when all candidates fall on the same side of the paper's two ranges. Conflicting or missing screen status is reported and is not turned into a broad CRSP-coverage screen. Zero and other invalid FUNDA SICH values are distinguished from valid codes in the build diagnostics.

## Currency and beginning market value

The paper scales annual NI, PRETAX, and PRESPC by beginning-of-year market value of common equity, Compustat items 25 × 199 (physical PDF p. 12). Item 25 is `CSHO`, common shares outstanding in millions at fiscal year end; item 199 is `PRCC_F`, the fiscal-year closing price. I take both from the same prior-fiscal-year (`FYEAR-1`) company annual record. This operationalizes beginning of the next fiscal year; actual `DATADATE` and the elapsed days are retained and summarized so the fiscal-date alignment can be inspected. A missing intervening fiscal-year record is not filled from another year.

An annual company price is not assumed to use the accounting reporting currency. The prior annual `HIID` is matched to its date-effective `COMP.SEC_HISTORY` primary record (`ITEM` `PRIHISTUSA` or `PRIHISTCAN`, with issue ID in `ITEMVALUE`). An ordinary missing `THRUDATE` is treated as an open interval. When no matching primary-history item is available, a unique same-HIID monthly `COMP.SECM` row marked `PRIMISS='P'` can verify the historical issue, provided the row is not marked `J`; company-wide uniqueness of `P` is not required because a U.S. and Canadian issue may each be marked primary. The current header `IID` is not substituted for historical `HIID`. `PRCC_F` and `CSHO` remain the annual Compustat denominator inputs; same-issue daily/monthly prices are audit evidence, not a condition that redefines or replaces `PRCC_F`. The daily same-issue `CURCDD` identifies price currency when available; otherwise the same historical issue's `CURCDM` is used. There is no annual `CURCD` price fallback. Price mismatches, exact daily/monthly price pairs, factor/date diagnostics, and FX support are counted in the SAS audit.

The provider guide identifies `NI`, `PI`, and `SPI` as millions of reported-currency dollars (Research Insight 2004, physical p. 231 for NI, p. 238 for PI, and p. 310 for SPI); `CSHO` is millions of shares at year end (physical p. 196 / printed p. 146), and `PRCC_F` is the actual fiscal-year closing price (physical pp. 674–675 / printed pp. 624–625). Xpressfeed explains that current Canadian company fundamentals are presented in reported currency and recommends provider exchange-rate translation for cross-currency comparisons (2011 guide, physical pp. 82–89). I therefore retain supported non-USD observations and translate annual flow values into USD using same-month GBP-to-reporting and GBP-to-USD `EXRAT12M` rates. The annual PRCC_F remains the price input. Its dated security currency uses GBP-based `EXRATD` at the daily quote date when available; if denomination is evidenced only by monthly `CURCDM`, `EXRATD` is joined at the annual fiscal-close date. Monthly `EXRAT1M` is not used to convert the annual price. The provider's formula is `reported value / (GBP-to-reporting rate) * (GBP-to-target rate)` (2011 guide, physical p. 87 / printed p. 79). Duplicate identical FX rows are collapsed; conflicting rates are unavailable and counted. Raw pooled regression amounts are USD millions when supported. The same-currency classifier uses native ratios, so a point-date price FX rate is not needed just to form an already common-currency ratio.

## Sample order and region construction

The common source sample requires observed NI, PI, and SPI; PRESPC is computed as PI−SPI. It also requires positive beginning MVE, supported USD conversion for raw regression flows, and a usable classifier currency basis. When current flow `CURCD` equals the evidenced beginning-price currency, I form NI/MVE, PRETAX/MVE, and PRESPC/MVE directly in that native currency. This preserves the source ratio without applying different-date FX rates. If the currencies differ, I translate the flow with `EXRAT12M` and beginning price with point-date `EXRATD` to a common USD basis; this is an explicit mixed-currency approximation because the paper is silent on cross-currency timing. For each fiscal year, I calculate the 1st and 99th percentile of each of NI/MVE, PRETAX/MVE, and PRESPC/MVE with SAS `PCTLDEF=5`; values strictly outside any of these six annual cutoffs are removed. This strict-boundary percentile convention is source-silent. Exact-zero NI, PRETAX, or PRESPC is excluded only after the annual trims, as the paper's footnote 10 specifies (physical PDF p. 13). The 1% winsorization of ETR and SPECIAL described for Table 2 does not apply to Table 4. Historical SIC is supplied from dated CRSP only under the explicit CCM/name-history link policy above; unsupported or conflicting industry codes are counted separately and do not create a general CRSP-coverage gate.

Table 4 uses undeflated monetary amounts, while the region indicators come from scaled values (physical PDF p. 21). In Panel A, regions use scaled PRETAX; in Panel B, they use scaled PRESPC. The small-loss interval is `[-0.03,0)`, the small-profit interval is `[0,0.03)`, loss is below `-0.03`, and profit is at or above `0.03`. These lower-inclusive, upper-exclusive boundaries implement six adjacent 0.005-wide bins on each side of zero; the paper does not state endpoint conventions. Each region-specific regressor equals the raw USD amount inside its region and zero elsewhere.

Table 4 footnote 17 says statistical outliers are deleted but gives no criterion (physical PDF p. 21). I do not invent a regression-level cutoff. The native fits therefore use the reproducible shared sample after the paper's specified annual tails and exact-zero screen, with the missing additional filter recorded as a material limitation. The published Panel A/B counts (113,113/113,356) are comparison values, not construction targets.

## Estimation and outputs

The paper reports one pooled regression per panel with a common intercept and four region-specific slopes, no region intercepts, and equality tests for small-loss versus small-profit slopes and loss versus profit slopes (physical PDF p. 21). The estimator and covariance procedure are not named. I use conventional pooled OLS with the default homoskedastic OLS covariance as an explicit best-effort choice; no fixed effects or clusters are added. Stata reports two-sided p-values, consistent with the table note. The two source equality tests are run with native `test` and exported as additional table rows.

The Stata notebook has separate self-contained cells for Panel A, Panel B, and each fit's actual estimation-sample descriptives. Regression and descriptive tables use the template's four formats. Descriptives cover raw outcome and region-masked raw regressors in the observations actually used by each model.

## Execution findings

The native SAS build completed and handed off 127,393 firm-years covering every FYEAR from 1976 through 2001 (3,065 in the smallest year, 1978; 7,269 in the largest, 2001). The common tail/zero screen removed the annual tails first and then exact-zero NI, PRETAX, or PRESPC, as shown by `tail_zero_attrition` in the native listing. The handoff key (`GVKEY,DATADATE`) is unique. Current source records have two extra `GVKEY/FYEAR` rows but no duplicate `GVKEY/DATADATE` keys; the prior-year join selects the nearest actual FYEAR−1 date before the current statement date. The mean and median fiscal gap are 365 days; the maximum is 701 days.

The source sample totals 250,528 annual observations in the study years. Historical SICH is missing in 114,646 (45.76%); missing rows are left unclassified and are not assumed to belong outside the paper's SIC exclusions. This source coverage issue is substantial, particularly in the early years:

| FYEAR | Source rows | Missing SICH |
| ---: | ---: | ---: |
| 1976 | 6,751 | 6,751 |
| 1977 | 6,788 | 6,788 |
| 1978 | 6,761 | 6,761 |
| 1979 | 6,900 | 6,900 |
| 1980 | 6,889 | 6,889 |
| 1981 | 7,058 | 7,058 |
| 1982 | 7,686 | 7,586 |
| 1983 | 7,997 | 7,886 |
| 1984 | 8,243 | 8,116 |
| 1985 | 8,599 | 8,462 |
| 1986 | 9,017 | 8,862 |
| 1987 | 9,225 | 1,362 |
| 1988 | 9,333 | 1,632 |
| 1989 | 9,343 | 1,802 |
| 1990 | 9,571 | 2,002 |
| 1991 | 9,966 | 2,246 |
| 1992 | 10,705 | 2,563 |
| 1993 | 11,482 | 2,712 |
| 1994 | 11,899 | 2,652 |
| 1995 | 12,492 | 2,267 |
| 1996 | 12,624 | 2,179 |
| 1997 | 12,437 | 2,311 |
| 1998 | 12,554 | 2,161 |
| 1999 | 12,531 | 2,076 |
| 2000 | 12,093 | 2,256 |
| 2001 | 11,584 | 2,366 |
| **Total** | **250,528** | **114,646** |

### Beginning MVE and currencies

The beginning-MVE denominator follows item 25 × item 199: prior-FYEAR annual `CSHO` (millions of shares) times annual `PRCC_F` (price per share), before conversion. Historical `HIID` maps to a unique dated monthly primary issue for every retained row; current header `IID` remains diagnostic. `PRCC_F` remains the provider's annual source price. The earlier prototype additionally required it to match the last same-month daily quote, which unintentionally made sparse daily quote coverage a sample screen. That gate was removed because the paper explicitly defines the denominator with annual Compustat items 25 and 199; the security price record supports issue/currency history and provides a price-level audit. This correction followed the source item definition and observed coverage, not published-N proximity.

For the 127,393 retained rows, price currency is directly observed from the same-issue daily quote on 93,829 rows (73.65%) and from the same-issue monthly primary record on 33,438 (26.25%). On the remaining 126 rows (0.10%), the code infers price currency from prior annual `CURCD` because neither security route supplies currency; that fallback is unverified for those individual records and is a material limitation. No retained row lacks a price-currency route. The daily-quote route has 93,829 comparable annual-price/daily-close pairs: 77,684 are within the documented tolerance and 16,145 (17.21%) disagree. All these known mismatch rows have matching prior annual and daily quote currency codes; the price-level discrepancy therefore is not explained by a reported-currency mismatch. The mismatches remain counted and are not an exclusion rule. On all retained records, 119,637 flows are USD and 7,756 are CAD; all flow conversions are supported, and 33 rows have different current-flow and beginning-price currencies. Same-currency classifiers use native ratios; the 33 mixed-currency cases use the explicit common-USD approximation. There are no duplicate or conflicting provider FX rates in the bounded source dates used by the build.

### Estimates and comparison

Both pooled OLS cells and both actual-estimation-sample descriptive cells completed. Panel A and Panel B each use 127,393 observations. Descriptive tables report all estimation variables in four formats; for example, Panel A's net income has mean $33.983m, median $1.730m, and SD $344.748m, while Panel B's pretax income has mean $60.258m, median $2.688m, and SD $477.758m. Exported regression tables include N, R-squared, adjusted R-squared, both source equality tests, and coefficient p-values.

| Estimate | Panel A: NI on PRETAX regions | Paper A | Panel B: PRETAX on PRESPC regions | Paper B |
| --- | ---: | ---: | ---: | ---: |
| Intercept | −0.337 | 0.07 | 0.296 | 0.50 |
| Loss slope | 0.966 | 0.98 | 2.130 | 2.03 |
| Small-loss slope | 0.905 | 1.04 | 2.171 | 1.94 |
| Small-profit slope | 0.701 | 0.67 | 0.891 | 0.94 |
| Profit slope | 0.617 | 0.62 | 0.969 | 0.99 |
| N | 127,393 | 113,113 | 127,393 | 113,356 |
| Adjusted R-squared | 0.923 | 0.99 | 0.867 | 0.99 |
| F: small-loss = small-profit | 74.95 | 2,679.10 | 815.31 | 4,125.23 |
| F: loss = profit | 55,081.15 | 215,474.00 | 20,694.32 | 56,802.70 |

The paper's sample section reports 114,177 observations before its Table 4 outlier step, which is not specified; the local common screen retains 127,393. Relative to Table 4, our N is larger by 14,280 in Panel A and 14,037 in Panel B. The unknown statistical-outlier rule, the current merged-vintage proxy, and missing historical SICH are unresolved explanations; the local results are not adjusted to match the paper. The slope and fit differences are likewise recorded without specification changes. The paper's estimator and covariance method are not named, while this build uses conventional OLS inference, so its F/t magnitudes are not expected to be identical if the source used a different covariance procedure.

The numerical files under `tables/` include four regression exports and four actual-sample descriptive exports per panel. The first PROC MEANS syntax failure (`SD` instead of `STDDEV`) and its listing remain in the earlier runtime directory; the subsequent native build and all required cells completed successfully.
