# Independent review

## Scope

Reviewed the assigned work item, frozen implementation rules and references, original paper, strict Stata template, the W3125232597 entry in the review-queue notes, A1's design/submission/build/native outputs, and A2's final build and Stata outputs. Work is confined to A2. No author replication code/data were used, and no package was installed.

## Main construction finding

The paper describes quarterly buy-and-hold raw returns during quarter t and quarterly earnings scaled by preceding-quarter market value. It does not say whether quarter t follows fiscal or calendar boundaries. A1 used calendar-quarter returns for every Compustat observation. A2 interprets quarter t as the reported Compustat fiscal quarter: CRSP monthly total returns end in the DATADATE month and include the preceding two months. This is a month-level approximation, not an exact daily period match. The earnings denominator is market equity from the preceding FYEARQ/FQTR. Calendar-quarter returns remain in the target-to-industry stock-correlation control, which needs common calendar periods.

The A2 peer history remains the full same-SIC2 reporting population at the event anchor calendar quarter. The source does not state whether peers should be selected or aligned on fiscal periods. Each event history uses 16 consecutive FYEARQ/FQTR slots ending at that anchor's reported quarter, with at least 14 valid earnings/return pairs. For repeated GVKEY/FYEARQ/FQTR observations in an event history, the explicit retained row is the most recent DATADATE/FDATEQ that is at or before the anchor. This prevents future information and repeated fiscal periods from entering a window. No deal-only or top-four peer restriction was added.

The final quarter audit counts 236,955 Compustat firm-quarter endpoints whose DATADATE is not a calendar quarter end. Among those off-calendar rows, 121,448 have different available calendar-quarter and fiscal-month BHR values. The two figures measure different populations and are not combined. Separately, 500 unique GVKEY/FYEARQ/FQTR keys span 1,000 quarterly source rows. The final expanded-window audit found 2,850 repeated window-quarter keys across 5,700 preselection rows. After latest-row selection, 5,765,980 history rows remain; post-anchor and out-of-window counts are both zero. None of 398,177 histories exceeds 16 quarter indices or spans more than 16 consecutive fiscal-quarter slots.

A bounded SAS smoke check exercised duplicate selection, same-key future rows, the oldest allowed quarter, an interior missing quarter, and a full 16-slot quarter index. It passed. The final production rebuild then confirmed one retained firm/fiscal quarter per window, no future-to-anchor row, and the intended consecutive-quarter horizon.

## Native comparability estimation

The final build produced 264,324 firm/event-industry groups. Exactly 177,862 have at least 14 valid earnings/fiscal-BHR pairs. Every qualifying group has positive BHR variance, native PROC REG model DF=1, and error DF of at least 12. The other 86,462 groups are below the 14-observation minimum. Full rank is taken from native ANOVA degrees of freedom, rather than counting coefficients. Earnings and BHR are centered and scaled together within each group to avoid small-range conditioning warnings; the slope and degrees of freedom are preserved, and the intercept is reconstructed on the original scale.

## Final A2 baseline and output checks

Final SAS runtime: 20261103T033633809483Z. Final native Stata runtime: 20261103T034107834265Z. SAS, handoff, and all four Stata cells completed with zero warnings/errors. The runner validates three expected scopes, no blocked scopes, and no warnings. The frozen sample declaration was unchanged.

| Outcome | Published target-comparability coefficient | A2 coefficient (two-sided p) | Published N | A2 N | A2 R-squared | A2 adjusted R-squared |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ACQ_CAR | 0.017 | −0.005 (0.616) | 1,307 | 1,334 | 0.100 | 0.086 |
| SYNERGY | 0.018 | 0.003 (0.753) | 1,277 | 1,332 | 0.124 | 0.110 |
| ΔROA | 0.025 | 0.010 (0.313) | 1,042 | 1,041 | 0.159 | 0.143 |

The paper uses one-sided inference for the target-comparability coefficient; the template output reports two-sided p-values. The focal estimates are small and not statistically significant, and were not used as construction targets. The A2 complete-case Ns differ from A1's 1,332, 1,330, and 1,037. The deal-level material sample remains 4,697; the small model-N changes accompany the A2 fiscal-quarter construction and repeated-key repair.

The exact full-control regression samples have outcome means and standard deviations of −0.0149 and 0.1009 for ACQ_CAR (N=1,334), 0.0192 and 0.0975 for SYNERGY (N=1,332), and 0.0007 and 0.1122 for ΔROA (N=1,041). Stata computes each regression-table outcome mean from that model's e(sample), and these rows appear in all four required formats. The separate descriptive table summarizes the full 4,697-deal handoff population. SAS's Table 2 comparison in the build listing provides these exact regression-sample descriptives.

A2's ACQ_CAR full-control raw comparability ratio has mean −0.0460 and median −0.0324. Multiplication by 100 would display −4.60 and −3.24, while the paper reports −3.01 and −1.89. The source does not resolve this unit convention; neither the extra multiplier nor a score correction is applied. Positive rescaling does not change the decile rank used in Table 3.

## Other audited details and limits

The local SDC catalog includes RANKVAL (ranking value including target net debt), ENTVAL (enterprise value), and EQVAL (equity value). The paper says deal value without identifying a field. A2 uses RANKVAL as a best-effort proxy, leaving 645 missing values unresolved. The 6,681 exact-code local starting rows produce 4,697 material deals, 566 below the paper's 5,263 post-materiality count; 906 otherwise value-eligible rows lack positive acquirer MVE before the relative-size test. This is a real coverage/definition discrepancy and was not tuned.

The full material sample has 4,683 acquirer CARs, 3,415 synergies, 2,622 complete six-year ΔROA values, 1,766 valid deal-level comparability ranks, 1,789 stock correlations, 2,526 synchronicity observations, and 3,474 usable target-holdings observations. Cash and stock percentages are interpreted on the observed 0–100 scale at 90%; 42 out-of-range or inconsistent rows remain unknown. S34 ownership is tested at manager level above 5%, after first-FDATE selection and dated split-basis conversion; absent holdings coverage remains unknown. Company MVE, reporting currency, date-valid CRSP links, normalized monthly delisting returns, and price/share cross-checks are documented in design.md.

The main text's below-median acquirer Tobin-Q dummy and target-side size/Q controls govern over contradictory appendix wording. SYNERGY uses prior-quarter company-MVE weights. Market-model fits use sessions −205 to −6 and the event outcome sums sessions −1 through +1. ΔROA uses completion year, fixed announcement-year SIC2 peers, and complete three-year pre/post periods because no minimum available-year rule is stated.

## Run history

A1's final native runtimes were SAS 20261103T030536156639Z and Stata 20261103T030933013886Z. A2's first fiscal-quarter build, 20261103T032904708028Z, was superseded after its quarter-window selection was audited. The bounded smoke check and corrected final SAS build preceded one fresh native Stata run. Runtime folders preserve code, logs, handoffs, and exported results for the historical and final runs.
