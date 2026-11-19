# Independent review and repair: W3121620818

## Source checks

I reviewed the predecessor A1 `build.sas`, `design.md`, handoff, Stata cells, native logs, and exports against the original paper. I inspected physical PDF pages 6–8, 11–12, 14, and 20–22, including the saved image of physical page 21 (`attempt_01/source_pages/physical-21.png`).

Table 7 on physical page 21 gives one table-level sample count, “qualified = 173, unqualified = 173,” above the four Table 7 model blocks. The page 22 continuation adds the probability footnote but prints no model-specific Ns. The source therefore supports a shared Table 7 sample and gives no evidence for model-specific Ns. It does not state the precise joint missing-data rule used to obtain the 173 pairs. Table 1 on physical page 11 screens qualified firms for discretionary-accrual data, control-variable data, and a classifiable industry before reporting 173 firms with a matched pair. The Table 1 footnote says controls are selected on event year, industry, auditor type, and nearest total assets.

The Jones equations and fitting windows agree with the corrected construction: physical pages 6–7 use a no-intercept Jones estimation, with inverse lagged assets, revenue change, and gross PPE; time-series coefficients use the eight consecutive years ending before the event year; and Modified Jones uses the original Jones estimates while adjusting only event-year revenue change for receivables. Cross-sectional estimates use the full event-year/two-digit-SIC population. Total accruals use the page 8 equation. Table 7 page 22 defines PERFORM as absolute change in continuing-operations income over prior-year assets, while Table 3 page 14 cites income item 18 and calls it income from operations. The existing item-18-to-`IB` mapping is retained and this wording conflict remains disclosed.

The source lists one-sided slope tests and two-sided intercept/model tests on physical page 22. The native Stata logit uses model-based maximum-likelihood standard errors; the paper does not specify a different covariance estimator. Table 7's fourth block repeats “Cross-sectional Jones Model”; the model sequence and surrounding text identify it as Cross-sectional Modified Jones, which is the specification implemented and labeled in the generated file.

## Finding and repair

The predecessor's handoff had 477 matched pairs, but its Stata cells used different post-match flags: 325 pairs for each time-series logit and 459 for each cross-sectional logit. The source's single Table 7 count did not support that split. More importantly, the predecessor chose each nearest control before checking whether the control had every DA measure. Intersecting the old flags after matching kept only 325 pairs and could discard a case whose nearest control was incomplete even when another complete control was eligible.

I repaired A2's construction order. First-qualified opinions are still identified before completeness screens. Cases and candidate AUOP=1 controls must now have the four controls and all four DA measures before nearest-assets matching. The Jones support fits use the same eight prior years, and the cross-sectional coefficients continue to use the full eligible event-year/SIC2 population. Matching still uses year, historical SIC2, Big Six type, nearest USD-converted assets, ascending case GVKEY, lowest-GVKEY tie breaks, no control reuse within an event year, and reuse across years. These tie and replacement choices remain best-effort because the source does not specify them.

The pre-match diagnostics show 478 qualified cases with all four DA measures, controls, and classifiable SIC; 17,879 candidate controls pass the four control-variable screen, and 10,367 also pass the four-DA screen. The eligible case-control combinations cover 475 cases. The declared greedy rule produces 475 pairs (950 rows). For comparison, a naïve intersection of the predecessor's already-matched flags retained 325 pairs; pre-match screening and rematching recovers 150 additional complete pairs, while the total is two below the predecessor's initial 477-pair match. All four A2 fit flags and `fit_common` equal one for each of the 950 rows. Winsorization cutoffs are recomputed over this common rematched sample, consistent with the source's three-standard-deviation rule.

## Table 7 results

All four A2 native Stata fits completed on 950 observations (475 qualified cases and 475 unqualified controls). The paper reports 173 per side (346 rows) for Table 7. The local excess of 302 pairs remains unexplained; I do not attribute it to a vintage effect or target the published count. The local first-qualified event count is 3,033, compared with 869 distinct qualified firms in Table 1. The proportion with available time-series Jones DA is similar (725/3,033 = 23.9% locally versus 201/869 = 23.1% in the paper), but this does not explain the difference in the initial populations or later screens.

The focal DA regressor is an unstandardized absolute accrual ratio scaled by prior-year assets. Its coefficient is the log-odds change per one full unit in that ratio; the odds ratio is on the same scale. Local Stata p-values below are two-sided Wald probabilities. Because all local DA estimates are positive and the paper's expected DA sign is positive, the one-sided local p-value is half the two-sided value for comparison.

| Table 7 model | Local N (pairs) | Local DA coefficient | Local p, two-sided | Local p, expected-sign one-sided | Published coefficient / one-sided p | Local / published odds ratio |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Time-series Jones | 950 (475) | 0.912 | 0.200 | 0.100 | 1.734 / 0.179 | 2.490 / 5.664 |
| Time-series Modified Jones | 950 (475) | 1.051 | 0.128 | 0.064 | 1.849 / 0.156 | 2.859 / 6.355 |
| Cross-sectional Jones | 950 (475) | 3.705 | 0.0006 | 0.0003 | 4.737 / 0.007 | 40.645 / 114.078 |
| Cross-sectional Modified Jones | 950 (475) | 3.718 | 0.0003 | 0.00015 | 3.938 / 0.016 | 41.196 / 51.292 |

Both time-series DA slopes remain insignificant at 5% under the paper's one-sided comparison; both cross-sectional DA slopes remain positive and significant. Local coefficient estimates are below the published values in all four models, while local cross-sectional Wald inference is stronger. Local LR chi-square statistics are 73.84, 74.52, 84.56, and 85.80; the paper reports 66.653, 66.751, 70.894, and 69.642. Local model probabilities are below 0.0001, while Table 7 prints 0.0001. The Stata exports follow the template and retain two-sided coefficient p-values; the one-sided comparison above is interpretive only.

Table 3 reports means for BP, DE, and PERFORM for 173 qualified and 173 unqualified firms. A2's matched-sample means after pooled mean ±3 SD winsorization are:

| Variable | A2 qualified | A2 unqualified | Published qualified | Published unqualified |
| --- | ---: | ---: | ---: | ---: |
| BP | 1.142 | 0.996 | 1.164 | 0.885 |
| DE | 0.225 | 0.206 | 0.269 | 0.227 |
| PERFORM | 0.078 | 0.044 | 0.061 | 0.028 |

BP is close for qualified firms; the local unqualified mean is higher. Local DE means are lower and PERFORM means higher than the published means. The paper's Table 3 market-capitalization means are in raw millions, while Table 7 MKTCAP is log base 10 of market equity in USD millions, so I do not compare those figures directly.

## Currency, classification, and diagnostics

The repaired 950-row handoff uses direct exact-HIID/date `SEC_MTHPRC.CURCDM` for 942 rows and the explicitly inferred `FUNDA.CURCD` proxy for 8. I queried the eight inferred event-year records in `COMP.FUNDA`, `COMP.SEC_MTH`, and `COMP.SEC_MTHPRC`. All eight FUNDA `CURCD` and `CURNCD` values are USD. None has a same-date `SEC_MTH` row with an IID matching its historical `HIID`; seven have no same-date issue/price row. One row (GVKEY 003618, 1980) has a nonmatching IID 02 marked J with a USD quote of 29.0000 versus annual PRCC_F 28.99998478, a 0.00001522 difference. This is not evidence of a currency conflict for the selected HIID. No observed contradiction was found; the seven absent direct records remain unverified rather than mismatches. The bounded audit and its initial failed log (overlong SAS aliases) are retained under `scratch/`.

In the final matched handoff, SIC provenance is FUNDA.SICH for 86 rows, exact-HIID dated CRSP SIC for 858, and a unique date-valid company-link CRSP SIC for 6. The construction retains FUNDA.SICH where observed and uses the documented dated fallback hierarchy only when SICH is missing. Prior source-panel overlap checks found both agreement and disagreement between FUNDA.SICH and dated CRSP SIC; this remains a best-effort classification limitation.

The SAS log contains PROC REG range and R-square warnings on some small or ill-conditioned supporting fits. The build accepts time-series fits only at full rank with exactly eight observations and three regressors. It retains 1,187 full-rank cross-sectional year/SIC2 fits; 24 have zero residual degrees of freedom and 1,163 have positive residual degrees of freedom. No additional cutoff was used to suppress source-supported cells. The final regression inputs have plausible scales: BP and DE are ratios, PERFORM is an absolute earnings-change ratio, MKTCAP is log10 USD market equity in millions, and each DA is an absolute accrual ratio.

## Scope status and remaining limits

All four assigned fits completed in native Stata and exported `.md`, `.rtf`, `.csv`, and `.tex` tables. There are no blocked scopes. The remaining sample-size gap, exact historical Big Six crosswalk, exact match ordering/replacement rules, item-18 wording conflict, and inferred price-currency rows are documented assumptions or limits; none was resolved by tuning to published estimates.
