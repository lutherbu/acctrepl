# Independent review: W2065676679, attempt 2

## Status and scope

All ten frozen Table 5 scopes executed: Panel A horizons 1–5 and Panel B horizons 1–5. The results are marked `best_effort`; no scope is blocked. The predecessor, `attempt_01`, and the original paper files were left unchanged. Final data are from the corrected attempt-2 construction, with native Stata outputs in CSV, Markdown, RTF, and TeX.

## Source checks

I checked Beaver and Ryan (2000), *Journal of Accounting Research* 38, against the supplied PDF at `git/papers/pdf/W2065676679.pdf`:

- Printed pages 133–134 define the 1974–1993 Annual PST period, fiscal-year-end market value, net income available to common, annual security return, ROE denominator, fixed caps, and the survivor-bias note. Pages 134–136 specify Eq. (4), firm/year effects, the rolling estimates, and at least four observations per firm.
- Printed page 137 gives the lag component as the sum of slopes times double-demeaned returns and describes the component centering. I use the exact two-way FWL residual for each return in the unbalanced rolling samples; it agrees with literal double demeaning in a balanced panel and is the fixed-effect projection in the observed unbalanced panel.
- Printed pages 142–143 describe the component regression and Table 5. Each horizon uses the same 6,044-observation sample because each formation record requires all five subsequent ROEs. The paper reports White-adjusted t-statistics. Table 5 does not name an estimator, so I use OLS with Stata robust standard errors. The reported incremental F has 3 numerator degrees of freedom; I report the analogous native robust Wald test of three component-equality restrictions.
- I rendered and inspected physical page 18 (printed page 143). The four-year Panel B row visibly prints `c=-.077`, `d=-.075`, and `c-d=-.020`; the displayed coefficients imply `-.002`. This is a source-table arithmetic inconsistency. I report the contrast computed from the fitted coefficients and do not tune it to the printed contrast. A second source conflict concerns the three-year Panel B ROE t-statistic: it is `(.05)` in the table on printed page 143 and `.5` in the prose on printed page 142.

## Construction review and repairs

The current `COMP.FUNDA` history uses `POPSRC='D'`, `CONSOL='C'`, `DATAFMT='STD'`, and both `INDL` and `FS` records. For same-GVKEY/year duplicate formats I select INDL because it carries IBCOM and CSHO in the bounded comparison; FS-only years remain. Among preferred-format duplicates the latest actual `DATADATE` is selected, and conflicting exact-date ties are left analytically unavailable. This is a current-vintage selection rule, not a reconstruction of the original PST tape.

The attempt-2 run first reused attempt-1 handoff data only after the coordinator verified identical build code, sample declarations, and data hashes. After the Eq. (4) macro guard was corrected, attempt 2 rebuilt native SAS history and main samples. The initial attempt-2 build log is preserved at `runtime/20261102T233151188848Z/`; it exposed a macro-scope bug that left `rankok` at zero. The correction declares each horizon-specific macro variable global before initializing it. The successful corrected SAS build is `runtime/20261102T233353943853Z/` (79.358 seconds). All five horizons then passed the component identity, with maximum absolute BTM reconstruction error `4.7e-11` and zero formula or decomposition failures.

The SAS variable named `rankok` is a coefficient-completeness guard only: it checks that all seven return-slope estimates are nonmissing. It does not establish model rank. I separately ran native Stata `reghdfe` regressions on the exact five rolling samples, absorbing firm and year effects. The exported model degrees of freedom are 7 in every fit, with observations 4,372, 5,587, 6,935, 8,279, and 9,754. This is the rank evidence for the seven return slopes after absorption. See `tables/eq4_rank_audit.*` and the native log under `runtime/20261102T233639421617Z/`.

### Data and alignment limits

- The paper's item wording does not resolve extraordinary and discontinued items. IBCOM (Compustat A237) is the closest available common-income measure, but it excludes those items. I do not substitute IB or NI. In the bounded 1984–1988 audit, IBCOM is missing on FS rows; duplicate INDL rows can supply it.
- Market equity is `CSHO × PRCC_F`, the documented primary fiscal-close price times company shares concept. Historical `MKVALT` is missing for 1984–1988 and `SEC_MSHARE` begins in 1998, so the code cannot establish a period-wide sum across common share classes. This is a supported approximation, not a verified multi-class total.
- The bounded same-actual-date quote check selected 44,433 annual rows; 21,818 had a dated security-month quote and every matched pair had a zero-day gap. Of 21,454 USD/USD matches, 21,452 were within $0.005; the largest gap was $2.50. The 364 CAD-accounting/USD-price matches were kept unavailable as currency mismatches. Observed currency or price conflicts are not overwritten by a FIC fallback. HIID-to-LIID suffix-`C` mappings are accepted only when exact-date quote evidence supports the issue mapping; header IID is not used as a historical identifier.
- The frozen catalog has no usable annual PST return table. Returns are a current-vintage CRSP daily `RET`/`DLRET` reconstruction over `(prior Compustat DATADATE, current DATADATE]`, restricted to eligible dated CCM links, USD routes, and complete DSI market sessions. The bounded build found 69,322 windows, 65,377 complete, and 3,945 incomplete; missing sessions are not filled with zero. Foreign-market returns and unsupported links remain unavailable.
- No historical 1993 PST membership flag is reconstructed from current `COSTAT`. FY1993 records have actual dates from June 30, 1993 through May 31, 1994; 1,721 fall in calendar 1994. Retaining by fiscal year preserves the 1988 formation record's fifth future ROE. The FY1993 history has 8,008 nonmissing ROEs.

## Results and sample comparison

Every Table 5 regression uses the same 4,409 observations across 1,103 firms; the paper reports 6,044. Formation-year counts are 830, 825, 859, 914, and 981 for 1984–1988. In the actual pooled Table 5 sample, median BTM is 0.692, formation ROE 0.137, and ROE at horizons 1–5 is 0.133, 0.130, 0.124, 0.121, and 0.117. Full by-year counts and medians are in `tables/table5_sample_desc.*`.

Panel A reports coefficient and R-squared comparisons. The paper's common N is shown once above; each listed fit has that N.

| Horizon | A2 ROE0 | A2 BTM | A2 R² | Paper ROE0 | Paper BTM | Paper R² |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 0.313 | -0.119 | 0.211 | 0.183 | -0.119 | 0.134 |
| 2 | 0.170 | -0.098 | 0.090 | 0.122 | -0.089 | 0.066 |
| 3 | 0.214 | -0.065 | 0.066 | 0.030 | -0.088 | 0.040 |
| 4 | 0.180 | -0.060 | 0.048 | 0.053 | -0.077 | 0.027 |
| 5 | 0.150 | -0.079 | 0.051 | 0.092 | -0.048 | 0.020 |

Panel B's coefficient vector is ROE0, BC, LC, time effect, and Eq. (4) residual. The final two columns compare the bias-minus-lag contrast and the incremental test.

| Horizon | A2 coefficient vector | Paper coefficient vector | A2 BC−LC | Paper BC−LC | A2 robust Wald F (p) | Paper F |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| 1 | 0.296, -0.109, -0.206, 0.005, -0.135 | 0.165, -0.096, -0.231, -0.149, -0.127 | 0.097 | 0.135 | 10.40 (.000) | 37.6 |
| 2 | 0.127, -0.111, -0.203, -0.152, -0.048 | 0.095, -0.081, -0.211, -0.134, -0.061 | 0.092 | 0.130 | 6.89 (.000) | 33.0 |
| 3 | 0.187, -0.089, -0.080, -0.034, -0.011 | 0.016, -0.086, -0.160, -0.099, -0.075 | -0.009 | 0.074 | 2.43 (.064) | 10.3 |
| 4 | 0.143, -0.088, -0.094, 0.205, -0.009 | 0.053, -0.077, -0.075, -0.062, -0.051 | 0.006 | -0.020 | 10.34 (.000) | 2.7 |
| 5 | 0.129, -0.101, -0.081, 0.056, -0.038 | 0.087, -0.060, -0.056, -0.048, -0.021 | -0.020 | -0.004 | 4.33 (.005) | 5.1 |

The Table 5 outputs also report two-sided robust p-values and the native robust `lincom` t-statistic for BC−LC. The robust Wald denominator df is 4,403; the paper reports (3, 6,065). The robust incremental test is significant at 5% in horizons 1, 2, 4, and 5, but not horizon 3 (p=.064). It is not the paper's classical partial-F calculation. These inference differences and coefficient gaps are results of the best-effort reconstruction, not grounds to choose alternative coefficients.

For the history descriptives, the paper reports pooled N=36,980 for BTM, 35,987 for ROE, and 37,599 for returns, with medians 0.75, 0.13, and 0.15. Attempt 2 has N=108,386, 129,050, and 65,377, with medians 0.731, 0.107, and 0.128. The historical-year medians also differ: for 1984 the source gives BTM/ROE/return 0.76/0.14/0.01 versus 0.703/0.112/−0.041; for 1987 it gives 0.74/0.13/−0.05 versus 0.634/0.086/−0.068. The larger pooled coverage and different medians do not identify a single cause; current source population, return route, security coverage, and variable-item ambiguities all matter.

## Output and execution evidence

`runtime/latest.json` records a successful corrected SAS stage and six successful Stata cells (`panel-a`, `panel-b`, `table5-sample`, `eq4-rank-audit`, `table1-pooled`, and `table1-medians`). The primary outputs are `tables/table5_panel_a.*` and `tables/table5_panel_b.*`; component tests, native rank evidence, and actual analysis-sample descriptives are separately available as `tables/table5_panel_b_tests.*`, `tables/eq4_rank_audit.*`, and `tables/table5_sample_desc.*`. History comparisons are in `tables/table1_pooled.*` and `tables/table1_medians.*`. Each basename has nonempty CSV, Markdown, RTF, and TeX files.

I ran coordinator `sync` and `validate` after editing the design; validation is clean with 10 scopes and no blocked scope. The first isolated SAS smoke-harness log is preserved at `runtime/sas_scope_guard_smoke/smoke.log`; SAS confirmed the global macro variable returned `1`, then the harness stopped because its test-only `%IF` statements were written at top level rather than inside a macro. The corrected production build itself successfully exercised all five horizons. This harness error does not affect the production run or its results.


Coordinator documentation check: the Research Insight 2004 locator for CSHO/A25 is physical PDF page 196 (printed146), correcting design.md's physical156 reference. Its stated end-year common-share meaning and implemented CSHO field are unchanged. The separate EPS-share item A54 is CSHPRI and is not used as the market-equity share count here.
