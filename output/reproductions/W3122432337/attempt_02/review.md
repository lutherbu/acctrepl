# Independent review — W3122432337, attempt 02

## Scope and source checks

The four retained fits are the all-groups Table 2 valuation models and all-groups three-day Table 3 information-content models, using STREET and EPSOP separately. I checked the equations and sample language against the assigned PDF: sample and data requirements, physical p.2; valuation equation and definitions, physical pp.5–6; Table 2 targets, physical p.6; information-content equation, physical p.7; Table 3 targets, physical p.8; primary-EPS qualification, footnote 8 on physical p.11. Predictive-ability models, group-specific columns, and the 63-day window are outside the assigned scope.

The implementation uses the source-defined items: Q59/Q15 is `CEQQ/CSHPRQ`; bottom-line NI is per-share Q11=`EPSPIQ`; disagreement groups use Q19=`EPSPXQ`; operating income is Q177=`OPEPSQ` or I/B/E/S STREET. It does not substitute NIQ dollars, Q11 for the GAAP group definition, or a GAAP-minus-special-items reconstruction for Q177. Values are put on compatible currency and quarter-end share bases before the three groups are formed; the source does not state equality precision, so cent rounding is a disclosed best-effort choice. Model values are not rounded.

The sample paragraph ties t−4 availability to seasonal-random-walk predictive tests, but does not expressly say that no other analysis requires it. The retained fits therefore omit t−4 under a best-effort scope interpretation. The paper explicitly imposes CRSP data only for information-content tests; Table 2 has no CRSP gate. Calendar-date `DATADATE` bounds 1989–1997 are applied because the paper does not specify whether its period refers to calendar dates or `FYEARQ`. The resulting handoffs include 948 Table 2 and 673 Table 3 rows with `FYEARQ` labels 1988 or 1998; this is a documented period interpretation, not a result-driven screen.

## Repair and construction review

The A2 repair changes consensus selection order in `build.sas`: it first selects the latest mapped ticker/quarter `STATPERS` strictly before RDQ and then checks uniqueness of mean, currency, and issue. An ambiguous latest date is unsupported rather than replaced by an older mean. The old code filtered ambiguous dates before sorting, which could have selected an earlier forecast contrary to the paper's “last mean” wording (physical p.7). In the A2 data, all 111,302 latest mapped dates were unambiguous, so this correction did not change the selected forecasts or samples. A2 was rebuilt and handed off because the construction code changed; A1 handoffs were not reused.

ACTU actuals are matched on exact `PENDS=DATADATE` and effective-dated CUSIP at the actual source date. The selected ACTU vintage is the earliest mapped `ANNDATS`, then earliest `ACTDATS`; ambiguous value/currency/issue rows are excluded. Summary means use exact `FPEDATS=DATADATE`, match the ticker and dated CUSIP/issue, and use `STATPERS<RDQ`. These selection and link rules are auditable in the SAS source and listing. ACTU products do not expose a company-level basic-versus-diluted flag. Consequently, the primary-EPS requirement in footnote 8 cannot be verified for the actuals, and STREET remains a material approximation; `ESTFLAG='P'` only selects the primary consensus series.

I checked factor direction and final handoffs. The quarterly `AJEXQ` anchor must agree with same-GVKEY/IID `SEC_DPRC.AJEXDI`; source-date and quote-date factors are dated on or before the source row, within seven days. Every retained Table 2 and Table 3 price has a supported same-IID ratio, and raw price × quote-date FX × anchor/quote factor equals the stored price exactly in the handoff. The corresponding ACTU and Table 3 forecast factor identities also pass. There are 1,913 non-unit t+3 price ratios and 1,086 non-unit t−3 ratios using `|ratio−1|>1e−8`. The A2 bounded audit is `runtime/20261103T070054614771Z/price_basis_audit.log`.

The SAS listing records 377,374 unique quarterly keys after rejecting 340 duplicate GVKEY/date keys. There are 32,394 group-1, 9,828 group-2 and 7,366 group-3 quarters; 94,390 are agreement group 0 and 233,396 lack a full classification. The all-groups Table 2 common complete-case sample contains 48,306 unique keys, with no CRSP or t−4 condition. The event build records 195,246 unique RDQ links, no ambiguous top-ranked PERMNO links, and 194,658 event-stat rows, of which 115 have incomplete observed returns. All final Table 3 rows have three stock and market sessions and complete model inputs. The final key counts are 48,306 for Table 2 and 33,602 for Table 3. The aggregate event and factor checks are in `runtime/20261103T065656197890Z/build.lst`; the bounded handoff audit is in `runtime/20261103T070054614771Z/price_basis_audit.log`.

The final Table 3 rows show a cross-provider event-date discrepancy: selected ACTU `ANNDATS` is later than Compustat RDQ in 5,139 of 33,602 observations; 899 are later by more than 7 days, 443 by more than 30 days, and 146 by more than 90 days. Among positive lags, the median is 1 day, p90 25 days, p99 149 days, and the maximum 924 days. `ANNDATS` equals RDQ in 18,497 rows and precedes it in 9,966. The source gives no cross-provider ACTU-to-RDQ reconciliation rule, so I added no equality or age screen. Event-time availability of selected STREET actuals is unverified in the later-dated rows; Table 3 is a best-effort point-in-time reconstruction.

The later-dated group has higher UOP_STREET dispersion and a higher fraction of large surprises, but not many extreme records: `|UOP_STREET|>1` occurs in 15/5,139 later-dated rows versus 25/28,463 rows dated on/before RDQ; `|UOP_STREET|>10` occurs in 2 rows in each group. UOP_STREET SDs are 0.343 and 0.147, respectively. Raw STREET values with absolute size above 10 occur in 5 later-dated and 9 on/before rows. These are descriptive diagnostics only, not a date sensitivity or exclusion rule. The latest summary forecast lookback in the final Table 3 sample ranges from 1 to 404 days (median 14); 357 estimates are more than 180 days old and six are more than 365 days old. The paper says “last mean” but gives no maximum age. These diagnostics are preserved in `runtime/20261103T070054614771Z/unit_audit.log`.

## Native fits and comparison with the paper

The coordinator completed the A2 SAS build and Stata handoff under runtime `20261103T065656197890Z`; all six Stata cells (four regressions and two actual-sample descriptive tables) passed in `20261103T070054614771Z`. Validation reports four executable scopes and zero blocked fits. The estimates are native pooled OLS with intercepts and conventional unclustered standard errors. The Table 2 and Table 3 regressors match the stated equations. Regression exports use the assigned template's coefficient and p-value cells and contain the expected N and R² rows in `.md`, `.rtf`, `.csv`, and `.tex`; sample descriptives use `estpost` on the actual estimation samples. The Stata logs report two-sided `P>|t|` tests.

| Fit | Published N | A2 N | Published slopes | A2 OLS coefficients (intercept included) | Published / A2 adjusted R² |
|---|---:|---:|---|---|---:|
| Table 2 STREET | 22,024 | 48,306 | BV 0.66; STREET 19.28; NI−STREET 2.44 | BV 1.133; STREET 2.297; NI−STREET 2.266; constant 10.361 | 42.69% / 45.82% |
| Table 2 EPSOP | 22,024 | 48,306 | BV 0.70; EPSOP 17.31; NI−EPSOP −1.32 | BV 0.998; EPSOP 7.185; NI−EPSOP −1.034; constant 10.290 | 42.05% / 49.04% |
| Table 3 STREET | 22,092 | 33,602 | ERC 1.3451 | UOP_STREET 0.018248; constant 0.000827 | 2.90% / 0.21% |
| Table 3 EPSOP | 22,092 | 33,602 | ERC 0.8707 | UOP_EPSOP 0.057194; constant 0.001221 | 2.28% / 0.72% |

Local Table 2 slope and intercept p-values are below .001. The Table 3 ERC p-values are below .001; intercept p-values are .046 (STREET) and .003 (EPSOP). The paper reports paired tests: Table 2 slope-difference t=5.14 and adjusted-R² Vuong Z=2.79; Table 3 t=7.31 and Z=2.54. Its significance notes are two-tailed. A2 does not calculate paired tests from separate regression p-values, so those source comparisons remain unreproduced. The local rank ordering differs: EPSOP has the larger slope and adjusted R² in both tables, whereas the paper reports larger STREET slopes and adjusted R² for the combined samples.

The sample-size gaps are +26,282 for Table 2 and +11,510 for Table 3. Local counts are results, not evidence of a vintage effect; current product availability, unresolved I/B/E/S EPS basis, dated identifier coverage, common complete-case gates, and Table 3 event timing may contribute, but the available checks do not attribute the full gaps to any one cause. There is no source-provided winsorization rule, so large STREET values were retained without trimming or winsorization.

Descriptive statistics below summarize the observations actually used by each pooled fit; amounts are USD per share and returns are decimal fractions.

| Sample / variable | N | Mean | SD |
|---|---:|---:|---:|
| Table 2: price at t+3 | 48,306 | 22.511 | 22.424 |
| Table 2: book value per share | 48,306 | 10.442 | 12.469 |
| Table 2: STREET EPS | 48,306 | 0.180 | 8.989 |
| Table 2: EPSOP | 48,306 | 0.236 | 0.777 |
| Table 2: Q11 bottom-line EPS | 48,306 | 0.140 | 1.274 |
| Table 2: Q11−STREET | 48,306 | −0.040 | 9.000 |
| Table 2: Q11−EPSOP | 48,306 | −0.096 | 0.881 |
| Table 3: three-day CAR | 33,602 | 0.001 | 0.076 |
| Table 3: UOP_STREET | 33,602 | −0.009 | 0.190 |
| Table 3: UOP_EPSOP | 33,602 | −0.010 | 0.113 |
| Table 3: STREET EPS | 33,602 | 0.314 | 1.051 |
| Table 3: EPSOP | 33,602 | 0.303 | 0.723 |
| Table 3: latest mean forecast | 33,602 | 0.364 | 0.496 |
| Table 3: beginning-quarter price | 33,602 | 24.501 | 19.862 |

## Remaining limitations

The large published-versus-local N, coefficient, and adjusted-R² differences remain unresolved. The local STREET tail is substantial (Table 2 range −530 to 1,540 USD per share; Table 3 range −130 to 68); the audit found that the differences are present in the selected ACTU product and are not explained by extreme rebasing ratios. The source does not prescribe trimming, so no values were removed. Other documented best-effort choices are the calendar-date interpretation, month-level quote timing, cent-level group comparison, CRSP value-weighted market benchmark, first-following-session convention when RDQ is not a trading day, and exclusion of cross-IID price bases without parity evidence. No paired Vuong or slope-difference test is claimed.
