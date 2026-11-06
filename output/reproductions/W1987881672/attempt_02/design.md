# Design — W1987881672, attempt 02

## Source definition and sample

The paper's Table 1 uses quarterly I/B/E/S earnings events from fiscal years 1984–1999 and forms annual distributions (paper physical pp. 5–6, printed pp. 225–226; Table 1 and note, physical p. 10 / printed p. 230). It requires a quarterly earnings report date and at least one analyst forecast before that date. Surprise is reported actual EPS less the single most timely individual forecast, not a consensus and not a forecast from a specified analyst. The paper excludes forecasts dated after the earnings number is known (footnote 7, physical p. 6 / printed p. 226).

The source is the catalog-listed `IBES.DET_EPSUS` (I/B/E/S U.S. Detail History EPS file with actuals). `TICKER` is the provider's persistent I/B/E/S firm key; `FPEDATS` is the fiscal-period end date; `USFIRM=1` selects the U.S. file; `MEASURE='EPS'` selects earnings per share; and `FPI` identifies a quarterly horizon. The I/B/E/S Detail History User Guide (December 2009, appendix pp. 40–41) defines `6`–`9` as quarters 1–4, `N`–`Q` as quarters 5–8, and `Y` as a quarter more than eight quarters in the future. All are retained because they denote quarter periods; no additional FPI screen is imposed. The source table has no separate historical fiscal-year label, so `year(FPEDATS)` is the operational year assigned to each quarter. This matches the paper's fiscal-year grouping as closely as the available descriptor permits; it is not proof of the original I/B/E/S fiscal-year assignment.

The screen order is:

1. Keep U.S. Detail EPS quarterly-period rows with `FPEDATS` from 1 January 1984 through 31 December 1999.
2. Require nonmissing `TICKER`, `FPEDATS`, `ACTUAL`, `ANNDATS_ACT`, `VALUE`, and `ANNDATS`.
3. Require `ANNDATS < ANNDATS_ACT`, a strictly earlier calendar date. Times do not make same-day forecasts eligible; `ANNTIMS` only ranks forecasts among eligible earlier dates.
4. For each `TICKER × FPEDATS × ANNDATS_ACT`, select the row with the latest `ANNDATS`, then latest `ANNTIMS`. At a latest-date/time tie, order by ascending analyst code, estimator code, and forecast value. The paper requires one most timely individual forecast but gives no tie rule, so this deterministic rule is a best-effort choice. No forecast-age cap is applied.
5. Retain events where `report_curr='USD'` and `CURR_ACT='USD'`. The selected-row audit found 47 records with USD report currency but CAD actual-file currency; the actual and forecast units would not be demonstrably comparable, and no approved currency-conversion input is assigned. These records are excluded after forecast selection so an earlier estimate cannot replace the most timely one. The 571 rows with `CURRFL='C'` and USD report currency remain: the guide defines `CURRFL` as the currency received by the analyst, while Detail estimates received in a different currency are converted to the company default currency. `CURR_ACT` is the currency from the Detail Actuals file and is checked against the report currency. The common-USD filter is a unit-compatibility choice, not a target-count rule.

## Variable construction and aggregation

The selected row's `ACTUAL` is reported quarterly EPS and `VALUE` is the latest individual EPS forecast. `ANNDATS_ACT` is the explicit actual announce-date field; `ACTDATS_ACT` is retained for comparison. Forecast announcement date/time are `ANNDATS`/`ANNTIMS`. `REVDATS`/`REVTIMS` are the most recent date/time an estimate was confirmed accurate (guide glossary p. 52); they are not used to decide which forecast was announced latest. The guide says Detail estimates are completely adjusted to the company-level currency and primary/diluted basis; estimate-level `CURRFL` and `PDF` describe the received basis (pp. 18, 52–53). Thus neither flag is treated as the stored forecast denomination or an eligibility screen. `PDF` and `REVDATS` are included in descriptive diagnostics only.

Surprise is `(ACTUAL - VALUE) × 100`, in cents per share. The Detail History guide (pp. 10–14 and glossary p. 52) describes the adjusted per-share product and historical split adjustments; I preserve the adjusted source values as delivered and do not round them to whole cents. Because both actual and forecast are retained only in USD, the difference has a common dollar-per-share unit. The threshold tolerance of `1e-10` cents addresses binary floating representation only; exact zero remains exact equality, with no economic rounding or near-zero smoothing. A five-case synthetic arithmetic check covers exact zero, the +3-cent cutoff, values just outside the cutoff, and the −25-cent cutoff.

Within each `year(FPEDATS)`:

- The all-earnings median uses every retained actual, including `ACTUAL=0`.
- Profit and loss medians use `ACTUAL>0` and `ACTUAL<0`; zero actuals are omitted from both.
- Zero-surprise and positive-surprise rates use all observations in the corresponding reported-profit or reported-loss group as denominator; surprises are exact zero or strictly positive.
- Small positive profit surprise is `(0, 3]` cents, conditional on a positive surprise among positive-actual observations.
- Extreme negative loss surprise is `≤−25` cents, conditional on a negative surprise among negative-actual observations.

The annual file is explicitly gridded to 1984–1999, with one record per year. It includes the quarter count, counts by actual sign, all nine annual outcomes, and date/currency diagnostics. These firm-quarter counts are distinct from each trend regression's 16 annual observations.

## Estimation

Each of the nine Table 1 outcomes is fit separately as `regress outcome fiscal_year` with a constant and conventional OLS standard error. The paper specifies univariate regressions and reports trend, slope t-value, and adjusted R-square, but it does not name the estimator or covariance convention (Table 1 note, physical p. 10 / printed p. 230). OLS and conventional inference are therefore labeled best-effort assumptions. Stata reports a signed, two-sided t-test; the paper's printed t-values are positive magnitudes even for the negative extreme-loss trend. No published estimates or sample counts enter construction.

## Date, revision, and currency limitations

The 2009 Detail History guide says its Actuals-file date was the activation date before January 1999 and the announce date thereafter (p. 16), and distinguishes announcement from activation dates in its glossary (p. 52). This source provides both `ANNDATS_ACT` and `ACTDATS_ACT`; I use the explicit announce-date variable to implement Brown's report-date condition and inspect its differences from activation date and `FPEDATS`. The older-date convention means true announcement-date semantics are not established for every historical row in this current vintage. The source has no separate version timestamp or historical release snapshot, so this review cannot recover Brown's contemporaneous vendor vintage or prove that every currently stored historical value is the original unrevised value. Restated actuals are a separate provider product; no restated series is added.

The guide documents estimate currency conversion to company default currency and notes that actuals around company-level currency changes can remain on different historical bases (pp. 11–12, 17–18, 36–39). Therefore `CURRFL` is not used as the stored estimate denomination, and a mismatching USD-report/CAD-actual event is excluded rather than silently converted. The paper does not separately document a USD-only screen, so the common-USD population is an explicit best-effort choice needed to interpret the stated cents-per-share thresholds consistently. The remaining sample is compared with the published 176,519 quarterly observations; published counts are outcomes, not targets.
