# Independent review and currency repair — attempt 03

## Scope and source evidence

I reviewed all 48 frozen result-set scopes across Tables 3–5 against the original paper, attempt 02, the frozen implementation rules and Stata template, the local `COMP.FUNDA` catalog, and the cached provider guides. The paper's general model and the CF, DD, and Jones equations are on physical PDF p. 8 (printed p. 214); the period and sample screens are on p. 9 (p. 215); variable definitions and notes are on pp. 9–12 (pp. 215–218); Table 3 is on pp. 13–14 (pp. 219–220); Table 4 is on pp. 15–16 (pp. 221–222); and Table 5 is on pp. 18–20 (pp. 224–226). The Table 2 note scales CF and ΔCF in year t (p. 12), and Table 9 states that the lagged CFO predictor is also scaled in period t (p. 31, p. 237).

The item mappings remain source-supported: A123 = IBC, A308 = OANCF, A6 = AT, A12 = SALE, and A7 = PPEGT, checked against the 2004 Research Insight guide and `COMP.FUNDA` labels. I retained the corrected A2 definitions: `ACC=(IBC−OANCF)/average assets`, the year-t average-assets denominator for DD lag and lead CFO, SIC3 industry medians, and each table's fit-specific sample and dummy requirements.

The cached *Compustat Xpressfeed: Using the Data* guide defines annual `CURCD` as the period's ISO reporting currency, explains the native-currency presentation, and warns that reporting currency can change over time (2011 guide physical pp. 83, 85–88). The code reads `CURCD` from the same latest-date annual record as each accounting amount. It does not transfer a descriptor from a separate `DATADATE` record. The year-t/current-prior currency pair is required for average assets, ACC, current CF, GPPE, ΔCF, ΔREV, and DD lag CFO. The year-t/current-following pair is required only for DD lead CFO. A missing, malformed, or different required code makes that construct unavailable. Checks happen in the supporting annual panel before the SIC3 median and within-year tail ranks, so invalid currency rows cannot influence those cutoffs. No prior-to-prior2 condition is imposed.

I checked every monetary input and any accounting/market combination in the assigned equations. Tables 3–5 contain ratios of accounting amounts with average assets; the cross-year differences are CFO or sales differences; and the DD model uses lag/lead CFO over year-t average assets. There is no USD dollar cutoff or absolute-dollar regressor in these tables. AQC enters only as a zero/nonzero acquisition screen. The market measure is a difference of stock and equal-weighted market returns, both dimensionless rates; it does not combine a CRSP dollar price or market value with Compustat amounts. I therefore leave unlike or unknown monetary inputs unavailable, retain valid same-currency ratios in their native currency, and do not apply unverified FX rates.

## Repairs and currency audit

The first bounded synthetic SAS smoke exercised the currency compatibility logic through a scratch handoff: a valid same-currency observation retained all measures; a current/prior mismatch or unknown code made average-assets-dependent measures unavailable; a current/following mismatch left current CF and the non-DD measures available while making only the DD lead unavailable. A second bounded SAS check tested the selected-row rule and malformed-code handling. Both completed without SAS errors.

The source-date cutoff in A2 also censored part of the required FY2004 lead support. A bounded read-only source query found 10,901 selected FY2004 annual rows; 1,280 have `DATADATE` after 31 December 2004, and selected FY2004 dates run through 31 May 2005. Among 5,343 retained FY2003 firm keys, 4,989 have a selected FY2004 record: 4,359 within the inherited cutoff and 630 after it. All 630 late records have selected-row `CURCD` (588 USD, 42 CAD), with none missing. The other 354 FY2003 keys have no selected FY2004 record. The bounded FY1985 check found 8,599 selected rows and none dated before 1 January 1985. I widened the source window through 31 December 2005 while retaining fiscal-year support 1985–2004 and exact `GVKEY`/`FYEAR` joins. This restores actual next-year records; it does not infer or backfill their currency.

The 630-row difference between the initial row-selected build and the root's key-level currency audit is therefore a date-support distinction: the inherited date bound omitted selected next-year rows before currency could be checked. The final build uses the selected rows directly. Its handoff reproduces the audit's 99,526-row count, with 92,520 current USD rows and 7,006 current CAD rows, but the agreement is a check, not a fitting target.

| Currency or key check | Full selected annual support | Screened 1987–2003 handoff |
|---|---:|---:|
| Rows / unique GVKEY–FY keys | 218,676 / 218,676 | 99,526 / 99,526 |
| Duplicate GVKEY–FY keys | 0 | 0 |
| Current CURCD unknown or malformed | 0 | 0 |
| Prior currency pair unknown | 24,355 | 5,376 |
| Current/prior known pairs with different CURCD | 209 | 103 |
| Following currency pair unknown | 24,355 | 7,123 |
| Current/following known pairs with different CURCD | 209 | 120 |

The final handoff also has zero duplicate DSI dates. Among the baseline rows, 94,150 current/prior pairs have two known codes and 92,403 current/following pairs have two known codes. Incompatible pairs are not retained for the dependent measure that uses them. The original A2 handoff did not carry CURCD, so actual fit-level eligibility impact is measured as the final A3 sample change below. Currency mismatches are not a blanket screen: A3 CF and Jones fits do not require the DD lead.

The A2-to-A3 fit N changes reflect two repairs together: invalid current/prior unit combinations are unavailable, and the 630 late FY2004 source records now make potential year-t DD leads available. Only 454 additional Table 3A DD firm-years enter the final fit, for example; not every restored source row has a nonmissing CFO or survives the other sample and trimming requirements. The fit-specific N table records the net impact for all scopes.

## Execution, samples, and fit comparison

The final SAS builder selected 218,676 annual rows with zero duplicate `GVKEY`–`FYEAR` keys before and after selection; the final handoff contains 99,526 unique `GVKEY`–`FYEAR` keys. The SAS and Stata handoff succeeded. The native Stata stage completed all 16 cells for the frozen 48 scopes, with zero blocked fits. All 16 tables have the required `.md`, `.rtf`, `.csv`, and `.tex` exports (64 files). I checked 185 numeric values from CSV exports against the other three formats; none were missing. The runner validated the 48 scopes with no warnings or blocked scopes.

Pooled N tuples are ordered CF/DD/Jones. Each `published / A2 / A3` vector reports the three fit-specific firm-year Ns. Industry vectors report the number of qualifying SIC3 regressions, not firm-year N.

| Table/panel | Pooled N: published / A2 / A3 | SIC3 regressions: published / A2 / A3 |
|---|---|---|
| Table 3A | 57,362/46,821/54,838 → 79,034/65,756/75,660 → 78,963/66,210/75,590 | 186/186/186 → 221/208/219 → 221/210/219 |
| Table 3B | 53,059/46,706/51,551 → 73,109/65,499/71,160 → 73,050/65,953/71,100 | 196/197/196 → 224/217/227 → 224/217/226 |
| Table 3C | 57,284/46,779/54,787 → 78,757/65,548/75,644 → 78,686/66,000/75,574 | 197/197/196 → 230/217/231 → 230/217/231 |
| Table 4 | 51,470/42,101/50,030 → 52,774/45,110/51,962 → 52,735/45,418/51,925 | 190/190/190 → 204/198/205 → 204/198/205 |
| Table 5A | 51,470/42,101/49,400 → 52,774/45,110/51,573 → 52,735/45,418/51,536 | 180/180/180 → 193/183/192 → 193/183/189 |
| Table 5B | 47,742/42,034/46,417 → 49,197/45,039/48,524 → 49,164/45,346/48,492 | 190/190/190 → 203/198/202 → 202/198/201 |
| Table 5C | 51,417/42,073/49,334 → 52,588/44,962/51,523 → 52,549/45,270/51,486 | 190/190/190 → 204/198/204 → 204/198/204 |
| Table 5D | 47,701/42,009/45,879 → 49,029/44,895/48,155 → 48,996/45,202/48,123 | 180/180/180 → 190/183/188 → 189/183/187 |

The source interest coefficients below are reported to two decimals; A2 and A3 values are the exported coefficient precision. Each tuple is ordered CF/DD/Jones. The first vector is pooled and the second is the SIC3 coefficient mean. A3 p-values are two-sided tests from the frozen output template. The paper prints t-statistics in parentheses and does not state a one-sided convention, so those p-values do not reproduce the paper's parenthetical statistic. All interactions in Tables 3A–3C, Table 4, and Tables 5A–5C display `p=0.000` in both pooled and SIC3 tables (less than 0.0005 at the exported three-decimal precision).

| Table interaction | Pooled: published → A2 → A3 | SIC3 mean: published → A2 → A3 | A3 inference |
|---|---|---|---|
| 3A, DCF×CF | .53/.45/.58 → 1.052/.806/1.096 → 1.053/.822/1.097 | .49/.46/.46 → .733/.494/.799 → .732/.504/.797 | all p<.001 pooled and SIC3 |
| 3B, DΔCF×ΔCF | .25/.17/.38 → .529/.393/1.278 → .528/.386/1.279 | .15/.12/.11 → .433/.339/.817 → .432/.332/.809 | all p<.001 pooled and SIC3 |
| 3C, DIND×INDADJ_CF | .34/.34/.48 → .822/.774/1.042 → .823/.783/1.043 | .31/.23/.35 → .616/.375/.724 → .614/.381/.720 | all p<.001 pooled and SIC3 |
| 4, DABNRET×ABNRET | .13/.12/.11 → .113/.099/.105 → .113/.098/.105 | .10/.10/.07 → .102/.0847/.0780 → .102/.0841/.0777 | all p<.001 pooled and SIC3 |
| 5A, DCF×CF | .59/.50/.61 → .700/.568/.715 → .700/.568/.715 | .30/.30/.31 → .476/.356/.502 → .476/.356/.503 | all p<.001 pooled and SIC3 |
| 5A, DABNRET×ABNRET | .14/.12/.13 → .128/.112/.112 → .127/.111/.112 | .10/.10/.10 → .108/.0895/.0935 → .107/.0888/.0931 | all p<.001 pooled and SIC3 |
| 5B, DΔCF×ΔCF | .23/.14/.28 → .273/.213/.391 → .272/.213/.391 | .13/.10/.05 → .202/.128/.196 → .204/.125/.187 | all p<.001 pooled and SIC3 |
| 5B, DABNRET×ABNRET | .11/.11/.10 → .103/.097/.096 → .102/.096/.096 | .09/.09/.07 → .0868/.0815/.0694 → .0872/.0808/.0702 | all p<.001 pooled and SIC3 |
| 5C, DIND×INDADJ_CF | .37/.36/.45 → .419/.379/.501 → .419/.379/.502 | .29/.22/.31 → .316/.248/.330 → .315/.244/.331 | all p<.001 pooled and SIC3 |
| 5C, DABNRET×ABNRET | .13/.12/.12 → .122/.107/.105 → .122/.106/.104 | .10/.10/.09 → .105/.0865/.0896 → .104/.0859/.0892 | all p<.001 pooled and SIC3 |
| 5D, DCF×CF | .45/.44/.12 → .502/.474/.173 → .504/.476/.176 | .55/.48/.48 → .318/.271/.104 → .319/.280/.112 | pooled all p<.001; SIC3 CF/DD p<.001, Jones p=.125 |
| 5D, DΔCF×ΔCF | .09/.01/.11 → .119/.048/.122 → .119/.048/.122 | .04/.01/.02 → .106/.049/.0829 → .113/.0458/.0783 | pooled p<.001/.001/<.001; SIC3 p=.003/.237/.039 |
| 5D, DIND×INDADJ_CF | .03/.08/.25 → .059/.095/.228 → .057/.093/.226 | −.29/−.27/−.15 → .0076/.055/.207 → .00922/.0453/.208 | pooled all p<.001; SIC3 p=.872/.448/<.001 |
| 5D, DABNRET×ABNRET | .12/.12/.11 → .117/.111/.098 → .117/.110/.098 | .09/.09/.08 → .0941/.0886/.0762 → .0946/.0876/.0769 | all p<.001 pooled and SIC3 |

The large Table 3 pooled sample and book-proxy coefficient gaps remain after currency checks. Table 3A's pooled DCF×CF estimate is 1.053 versus 0.53 published, and its SIC3 mean is 0.732 versus 0.49; Table 3B/C show similarly larger pooled book interactions. These are not explained by the currency repair and were not used to change screens or coefficients. Market-return interactions in Table 4 remain closer to the published estimates. Table 5D's SIC3 mean DIND×INDADJ_CF estimates remain positive while the paper reports negative values; the paper itself notes multicollinearity in this specification.

SAS descriptive summaries of actual A3 samples show no missing values among the listed regression inputs. In the Table 3A CF sample (`N=78,963`), ACC mean/SD are −0.1125087/0.3983585 and CF mean/SD are −0.0298449/0.3260200. In the Table 4 CF sample (`N=52,735`), ACC mean/SD are −0.0727322/0.1643131, CF mean/SD are 0.0111861/0.2174309, and ABNRET mean/SD are −0.1654728/1.2419703 (median −0.3204292). Relative to A2, these reported summaries are stable to the shown three decimals.

## Remaining limitations

The local Compustat and CRSP vintages do not establish paper-era coverage. The paper does not specify the exact financial SIC range, the acquisition item or missing-AQC convention, the DD denominator in Tables 3–5, the annual median population, the historical CCM link filters, a pooled covariance correction, or the underlying estimator. The DD denominator follows the explicit Table 2/Table 9 period-t scaling notes. Missing `SICH` is excluded because it cannot establish nonfinancial status; SIC 6000–6999 is the best-effort financial range; missing AQC is retained as no recorded acquisition. Industry medians are SIC3-by-year, a best-effort reading. Tail trimming uses separate within-year ranks, so ties make the one-percent boundary approximate. Abnormal returns require a complete interval of daily stock and index returns under the selected CCM links; no separate delisting return is added. Pooled fits use default OLS inference and industry parentheses use two-sided tests across the industry coefficient distribution.

The final results are best-effort and do not numerically match the published Table 3 counts or book-proxy slopes. Those discrepancies remain unresolved after the source-supported item mappings, corrected year-t denominator, source date support, and currency checks; no specification was tuned to published Ns or coefficients.
