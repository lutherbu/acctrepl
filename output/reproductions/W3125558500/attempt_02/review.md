# Independent review: W3125558500, attempt 02

## Scope and disposition

Reviewed the two assigned scopes only: Table 4 Panel A and Panel B, with their native equality tests and actual-sample descriptives. The repaired handoff is built by SAS and the four Stata cells complete successfully. The resulting tables and current design are under this attempt's `tables/`, [design.md](design.md), and [submission.json](submission.json). The attempt documents material gaps from the publication; the results were not tuned to its N or coefficients.

## Corrections established by source evidence

- **Historical industry:** FUNDA SICH is preferred when it contains a valid code. The original source has 114,646 missing SICH rows out of 250,528; every row in FYEAR 1976–81 lacks SICH, and further missing values occur later. The code fills only missing/invalid SICH from a unique dated CRSP SIC reached through the explicit CCM link policy and date-effective STOCKNAMES record. It does not use CRSP header SIC. This finds 64,261 unique dated fallbacks in the full source, leaving 50,385 source records unclassified; no zero or other invalid nonmissing SICH occurs. The final sample has 79,764 FUNDA codes, 36,142 CRSP fallbacks, and 8,666 unresolved industries. Exact-SIC disagreements (73,227 source rows) are reported separately from disagreements about the paper's two exclusion ranges (5,416 source rows). On final records these counts are 52,499 and 1,305. The 1,305 cases show an unresolved provider/classification disagreement; the cause is not established, and valid FUNDA SICH remains the primary classification.

- **Historical primary issue:** The active Compustat history rows must be `PRIHISTUSA` or `PRIHISTCAN`, with the issue ID in `ITEMVALUE`; ordinary missing `THRUDATE` means the record remains active. Across the full SEC_HISTORY table, 177,600 rows have ordinary missing `THRUDATE`; IID/ITEMVALUE agree on every primary-item row. All 124,572 final rows have dated issue evidence: 124,221 agree with same-HIID monthly SECM evidence and 351 have the SEC_HISTORY primary item alone. There are 2,533 retained observations with two company-month P markers, demonstrating why uniqueness across all company issues is not a valid restriction once the annual HIID is known. None of the final rows is contradicted by a same-HIID J marker.

- **Price denomination and price level:** Final price currency is supported by same-issue daily CURCDD on 92,388 rows and same-issue monthly CURCDM on 32,184; the annual reporting-currency fallback is removed. All 91,978 final rows with both daily and monthly currency codes agree. Production continues to use annual FUNDA PRCC_F in CSHO×PRCC_F. Annual-vs-daily mismatches occur on 18,216 of 92,388 comparable final rows, but 17,855 of those match same-issue monthly PRCCM within $0.0001. Annual PRCC_F and monthly PRCCM match within $0.0001 on 124,091 of 124,116 comparable rows. Daily and monthly price levels match within $0.0001 on 74,117 of 91,978 pairs, despite full currency-code agreement. Quote age is zero at the median and 3 days at the 99th percentile. This is strong evidence of a daily/monthly product-basis difference for most discrepancies; it does not identify a definitive cause. Adjusted-price checks use the documented division direction PRCCD/AJEXDI and PRCCM/AJEXM. Those adjustments yield fewer near matches than the corresponding raw prices, so they do not justify replacing annual PRCC_F. The exact local annual product basis and the remaining price differences are unresolved.

## Final estimates compared with Table 4

| Model/result | Attempt 02 | Published | Model/result | Attempt 02 | Published |
| --- | ---: | ---: | --- | ---: | ---: |
| **Panel A** | | | **Panel B** | | |
| Intercept | −0.461 | 0.07 | Intercept | 0.549 | 0.50 |
| Loss slope | 0.970 | 0.98 | Loss slope | 2.200 | 2.03 |
| Small-loss slope | 1.017 | 1.04 | Small-loss slope | 2.207 | 1.94 |
| Small-profit slope | 0.698 | 0.67 | Small-profit slope | 0.892 | 0.94 |
| Profit slope | 0.619 | 0.62 | Profit slope | 0.967 | 0.99 |
| N | 124,572 | 113,113 | N | 124,572 | 113,356 |
| Adjusted R-squared | 0.926 | 0.99 | Adjusted R-squared | 0.864 | 0.99 |
| F: small-loss = small-profit | 229.28 | 2,679.10 | F: small-loss = small-profit | 854.20 | 4,125.23 |
| F: loss = profit | 61,787.61 | 215,474.00 | F: loss = profit | 28,519.26 | 56,802.70 |

Published values are from the original paper's physical p. 21. Both local equality tests reject equality at p<0.001. The published paper has different N across the panels; the assigned construction uses one common handoff, so both local regressions use 124,572 rows. The paper reports 114,177 before its Table 4 statistical-outlier deletion, but footnote 17 does not define the deletion. This build does not invent that rule, and the available evidence does not assign the N gap to one cause. A1-to-A2 key comparison finds 5,858 A1-only keys and 3,037 A2-only keys; the eight core monetary and scaled inputs are exactly unchanged on the 121,535 common keys.

The actual-estimation-sample descriptives also export all four required formats. Panel A net income has mean $32.320m, median $1.506m, and SD $352.427m. Panel B pretax income has mean $58.047m, median $2.341m, and SD $479.470m.

## Execution and remaining limitations

The clean SAS build and handoff returned 0; all four Stata cells (`eq1_panel_a`, `eq2_panel_b`, `desc_panel_a`, and `desc_panel_b`) returned 0. Each regression and descriptive table has `.md`, `.rtf`, `.csv`, and `.tex` exports. The earlier SAS run remains preserved at `runtime/20261104T124812980477Z/`; it exposed nonfatal missing-date and zero-length SUBSTR diagnostics. The corrected production run is `runtime/20261104T125222255297Z/`; it has no such YEAR/MONTH or SUBSTR diagnostics. The Stata run is `runtime/20261104T130017071965Z/`.

Remaining material limits are the current FUNDA vintage's imperfect match to the paper's 2007 source files, 8,666 final records with unresolved SIC screen status, 1,305 valid-SICH/CRSP alternative exclusion disagreements, unexplained price-basis differences outside the annual/monthly match pattern, the unspecified Table 4 outlier rule, and the unpublished covariance method. Percentile quantile and bin-endpoint rules are explicitly best-effort conventions. These limits qualify the local results but do not establish why the published N and coefficients differ.
