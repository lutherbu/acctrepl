# Design and implementation notes

## Scope and paper evidence

This attempt reviews the three Table 5, Model 1 targets: cash-flow patterns,
the Anthony–Ramesh (A&R) proxy, and age quintiles. The source is Dickinson
(2011), *The Accounting Review* 86(6), 1969–1994. The main design and sample
are on physical pp. 7–9; Table 5 and its notes are on physical pp. 17–19;
Appendix A definitions are on physical pp. 25–26. The paper uses 1989–2005
and reports 48,369 firm-years for Table 5.

## Data, IDs, and temporal coverage

The read-only sources are `COMP.FUNDA`, `COMP.G_EXRT_DLY`,
`COMP.G_EXRT_MTH`, `CRSP.CCMXPF_LINKTABLE`, `CRSP.MSENAMES`, and `CRSP.MSF`.
Current field availability and labels were checked in the local SAS catalog.
The Compustat population uses `INDL`, `C`, `D`, and `STD`. The retained panel
is 1984–2006: 1984 supplies the sales-growth input for the A&R t−4 year;
1985–2005 supply the five-year ranking window; and 2006 supplies the lead in
the outcome. Duplicate `GVKEY`–`FYEAR` rows after standard filters stop the
build rather than selecting a report vintage.

Legacy item mappings were checked in the cached 2004 S&P Research Insight
guide and item index. Appendix A inputs map as follows: #1 `CHE`, #9 `DLTT`,
#12 `SALE`, #15 `XINT`, #19 `DVP`, #21 `DVC`, #32 `IVAO`, #34 `DLC`, #38
`MIB`, #60 `CEQ`, #62 interest income, #130 `PSTK`, #172 `NI`, #227 `TSTKP`,
#230 `RECTA`, #238 `MSA`, and #242 `DVPA`. Current `CAPX` is used for
capital expenditures; legacy A30 is `CAPXV` (Schedule V PP&E), so it is not
treated as the paper's capital-expenditure measure. The guide gives item #62
mnemonic `IINT`, but that field is absent from the current catalog. Current
`IDIT` is labeled “Interest and Related Income - Total.” I use `IDIT` as a
best-effort semantic proxy, not a verified mnemonic crosswalk. The 2004 guide
defines `IINT` as revenue from interest-bearing obligations and excludes
capitalized interest, dividend income, and interest charged to construction.
The mapping remains uncertain. References are in
`../../../output/reproduction_runs/reference_documents/compustat_research_insight_2004.pdf`,
`../../../output/reproduction_runs/reference_documents/compustat_legacy_item_index.json`,
and `../../../output/reproduction_runs/reference_documents/crsp_compustat_merged_2013.pdf`.

## Currency translation and market equity

Compustat annual `CURCD` is the reporting currency for each fiscal period.
The Xpressfeed 2011 manual says security price currency can differ from
fundamental reporting currency (printed p. 77), lists daily `EXRATD` for
balance-sheet and daily-price data, monthly `EXRAT1M` for monthly-price data,
and 12-month average `EXRAT12M` for income and cash-flow data (printed p. 78,
Table 33). Translation uses primary currency GBP (printed p. 79). For a
reported-currency amount, the implemented USD factor is
`GBP→USD / GBP→CURCD`; multiply each period's amount by that factor before
cross-year differences or ratios. This avoids using `CURRTR` as a presumed
multiplier. `CURRTR` is retained only as a direction/coverage diagnostic
against the provider cross-rate. The data-source tables are the catalog-listed
`COMP.G_EXRT_DLY` and `COMP.G_EXRT_MTH`; only positive rates with
`FROMCURD` / `FROMCURM = GBP` are used. Daily `EXRATD` translates annual
balance-sheet amounts and the annual fiscal-close `PRCC_F` comparison uses a
point-date conversion; the guide also permits `EXRAT1M` for monthly price data.
Monthly `EXRAT12M` translates annual flows. The provider states that daily
quotes may be actual or carried forward (printed p. 78) and uses `EXRATTPD`
to describe that provenance. A type value of `AR`, `CF`, or blank does not
change the known GBP/target currency units and does not by itself invalidate a
positive observed quote.

Daily conversion uses a coherent pair: the GBP-to-reported-currency and
GBP-to-USD quotes must both be positive and use the same source `DATADATE`.
Select the latest such shared date no later than the actual Compustat fiscal
date and within seven calendar days; if no shared-date pair is available, the
balance-sheet factor remains missing. The chosen date and each leg's original
`EXRATTPD` are retained separately through the translation audit. Coverage
reports exact-date pairs, prior-date fallback pairs, and missing pairs, plus a
row-level comparison with A4's AR-only, independently selected legs. The
monthly flow path keeps the existing nonfuture `EXRAT12M` matching rule of at
most one prior month-end. USD reporters use factor 1. Missing or nonpositive
rates remain missing.

Price currency can differ from `CURCD`, so Compustat `PRCC_F × CSHO` is not
used for the USD market-equity screen or CAPX/MVE ratio. The paper does not
state a specific market-equity field, so this is an explicit source
substitution: date-valid CCM selects the focal firm's CRSP PERMCO, and the
build sums US-dollar `abs(PRC) × SHROUT / 1,000` at the latest CRSP month-end
no later than `DATADATE` and no earlier than the prior month-end. It starts
with ordinary common-share PERMNOs (share codes 10/11/12) under the selected
PERMCO. The CCM guide (physical pp. 8–9, 21, and 23) says `LS` is
security-only and other PERMNOs of the same PERMCO may link to other GVKEYs.
Accordingly, the build audits active `USEDFLAG=1` mappings for those classes,
including P/C primary and J/N secondary markers and LC/LU/LS link types. The
all-PERMCO class value is used only when no included class has a
contemporaneous mapping to a different GVKEY and every class is priced;
company-date market equity is otherwise missing for the size screen and
CAPX/MVE ratio. Same-GVKEY, other-GVKEY, J/N, LS, unlinked, multi-class,
unpriced, missing, duplicate, and market-date diagnostics are retained. This
is an explicit CRSP source substitution and company-level aggregation
assumption; it is not asserted to match the paper's Compustat measure.
`CSHO`/`PRCC_F` converted by the annual balance-sheet
cross-rate is retained for comparison only. Both calculations are in USD
millions: CRSP `SHROUT` is thousands of shares, and dividing the CRSP product
by 1,000 converts thousand dollars to millions.

For Compustat-to-CRSP sample links, the build uses date-valid CCM rows with
`USEDFLAG=1`, `LINKPRIM` P/C, and `LINKTYPE` LC/LU, then matches the CRSP name
history at the actual fiscal date. It keeps ordinary common shares 10/11/12
and NYSE/AMEX/NASDAQ exchanges 1/2/3. The CRSP Data Descriptions Guide
(physical p. 115 / printed p. 111) identifies share codes beginning with 1 as
ordinary common and codes 10/11/12 as non-ADR common classes. ADRs are
excluded. Foreign-incorporated ordinary common shares remain because the
paper excludes ADRs but does not exclude foreign incorporation. Multiple
qualifying links are counted; one is selected by P before C, LC before LU,
latest valid link start, then LIID/PERMNO. Age is calendar years since the
first monthly CRSP record across the firm's selected, date-valid PERMNOs.

## Measures, screens, and timing

The Appendix A formulas are implemented in USD millions. Optional components
are not replaced by zero: each final construct requires every uncancelled
source input to be observed. Appendix A defines `NFO=FO−FA`,
`NOA=NFO+CSE+MIB`, `FO=DLC+DLTT+PSTK−TSTKP+DVPA`,
`FA=CHE+IVAO`, and `CSE=CEQ+TSTKP−DVPA`. Substitution gives the exact
reduced final input requirement
`NOA=DLC+DLTT+PSTK−CHE−IVAO+CEQ+MIB`; the common `TSTKP` and `DVPA`
terms cancel. The strict original `FO`, `FA`, `CSE`, and `NFO` intermediates
remain separately constructed with missing values whenever any of their own
inputs is missing. The reduced NOA still requires `CEQ` (#60), which is also
the paper's separate absolute book-equity size screen. That screen does not
use `CSE`.

Appendix A also gives `CNI=NI−DVP+ΔMSA+ΔRECTA` and
`NFE=XINT(1−MTR)+DVP−IDIT(1−MTR)+lag(MSA)−MSA`. Substitution gives
`OI=NI+(XINT−IDIT)(1−MTR)+RECTA_t−RECTA_(t−1)`: `DVP` and the current/lagged
`MSA` terms cancel. Strict `CNI` and `NFE` intermediates still require their
original inputs and stay missing when those inputs are missing; final OI
requires `NI`, `XINT`, `IDIT` (the uncertain #62 proxy), `RECTA_t`,
`RECTA_(t−1)`, and the applicable nonmissing `MTR`. Thus missing `IDIT`,
`XINT`, or either required `RECTA` value still makes final OI missing, while
missing `DVP` or `MSA` alone does not. `MTR` includes the 2% state
approximation: 36% in 1989–1992 and 37% in 1993–2005; those rates are also
used in 1988/2006 only as needed to construct lagged/current or future
profitability. Raw component missingness and eligible-sample attrition are
logged by SAS.

`RNOA=OI/average NOA`, `ATO=SALE/average NOA`, and `PM=OI/SALE`; average NOA
is the arithmetic mean of current and prior fiscal-year NOA. This averaging
interval is not specified by the paper.
`GrNOA = NOA / lag(NOA) − 1`, with exact GVKEY/fiscal-year joins and no
bridging across missing fiscal years. The outcome is
`ΔRNOA_(t+1) = RNOA_(t+1) − RNOA_t`; the control is
`ΔRNOA_t = RNOA_t − RNOA_(t−1)`.

The analysis dates are 1989–2005. Screening uses a date-valid common-stock
listing on NYSE/AMEX/NASDAQ excluding ADRs, excludes financial SIC 6000–6999
using historical `SICH`, and requires average NOA, sales, absolute book
equity (`CEQ`, item #60), and USD market equity of at least $1 million.
Missing historical SIC or a missing screen quantity cannot pass the
applicable screen. The paper
does not specify zero cash-flow treatment; zero is classified as nonpositive.
Cash-flow patterns follow Table 1: introduction (−,−,+), growth (+,−,+),
mature (+,−,−), and decline (−,+,+) or (−,+,−); remaining signs are
shake-out. Missing cash-flow items remain unclassified.

The A&R proxy uses trailing medians from t through t−4 for dividend payout
(`DVC/NI`), sales growth, and CAPX/MVE, and current CRSP age. Within fiscal
year, the components are scored 1–3: low-to-high payout, high-to-low sales
growth, high-to-low CAPX/MVE, and young-to-old age. Footnote 12 names all four
inputs but says the composite range is 3–9; four 1–3 inputs sum to 4–12. All
four named inputs are retained. Annual quintiles of the composite are labeled
growth, growth/mature, mature, mature/stagnant, and stagnant. Ties are split
by GVKEY for near-equal group sizes because the paper gives no tie rule. Age
quintiles are youngest to oldest; the middle group is the reference. Table 5
footnote 18 aligns the schemes as introduction/growth/young,
growth/growth-mature/mid-young, mature/mature/middle,
shake-out/mature-stagnant/mid-old, and decline/stagnant/old.

All six continuous Model 1 fields are winsorized at pooled 1st/99th
percentiles among screened firm-years complete on the outcome and five
controls. The paper does not specify the percentile pool; stage indicators
are not winsorized. Proxy-specific eligibility flags preserve otherwise
eligible observations across the three fits. SAS verifies that the reduced
NOA and OI equal the original intermediate-based constructions on rows where
the strict formulas are complete, and reports aggregate counts of constructs,
screen rows, and proxy-specific Model 1 eligibility recovered only because
the algebraically cancelled terms are no longer input requirements. The
algebraic simplification itself changes no units, thresholds, sample rule,
or estimator; the A4 FX date-bound and A5 FX provenance/pair repairs are
described below.

The A4 SAS checks found zero unequal values on 173,069 strict-complete NOA
rows and 97,373 strict-complete OI rows. The largest absolute differences
were 5.82e-11 and 7.28e-12 USD millions, respectively, below the 1e-8
equality tolerance. Direct reduced inputs recovered 21,410 NOA and 532 OI
values over the retained 1984–2006 history; within 1989–2005, the counts
were 17,155 and 477. The screens admitted 63,193 rows under reduced NOA
inputs versus 61,078 under the original strict NOA requirements, recovering
2,115 screen passes. Proxy-specific strict-input versus reduced-input
eligibility was CF 25,902 to 26,242 (+340), A&R 17,482 to 17,713 (+231),
and age 26,098 to 26,438 (+340). Compared with A3, the separate FX repair
adds one eligible observation to CF and age; the cancellation-recovery
counts are otherwise unchanged. No sample-size target was used.

## Attempt 04 FX coverage repair

A3 restricted both raw FX source tables to dates through 31 December 2006,
while FY2006 accounting rows can have actual DATADATEs in 2007. The A4 bound
is derived from the latest non-USD FY2006 record for a GVKEY that also has a
FY2005 row, the only annual lead needed for the stated analysis period. The
bound resolves to 31 May 2007. It extends only G_EXRT_DLY and G_EXRT_MTH;
the Compustat support remains FY1984–2006, the analyzed years remain
FY1989–2005, and the CRSP date windows remain unchanged. The GBP-to-USD
bridge rate is available through the same date for the non-USD conversions.

The bounded calendar audit found 1,240 FY2006 Compustat rows dated after
31 December 2006 (1,041 USD and 199 CAD), with the latest date 31 May 2007.
The rebuilt FY2006 rate audit shows zero daily or 12-month flow rate misses
for CAD and exact-date rates for all 1,670 CAD FY2006 rows. All 199
post-calendar CAD rows now have exact-date daily AR and monthly EXRAT12M
quotes, with no prior-date quote substitution. By comparison, A3's all-year
CAD audit recorded 893 daily misses, 162 flow-rate misses, 706 daily
prior-date quotes within the existing seven-day limit, and 37 prior-month
flow quotes. A4 has 694 daily misses, no flow-rate misses, the same 706
bounded prior-date daily quotes, and no prior-month flow quotes. Thus the
historical daily-rate gaps remain; the FY2007 cutoff misses and stale
monthly fallback are repaired.

After current-year listing and size screens, 34 FY2005 rows have a matched
CAD FY2006 lead dated 31 August 2006 through 31 March 2007. Two of those
lead dates are after 2006; both now have exact daily and monthly rates. One
post-2006 lead has a complete Model 1 outcome and controls and adds one
observation to the CF and age fits. The other remains ineligible because a
required outcome/control is incomplete. A&R adds no observation because its
portfolio classification is unavailable for the recovered case.

## Attempt 05 daily FX provenance and pair repair

The assigned root exact-source audit at
`../../../output/reproduction_runs/preflight/fx_rate_types.json` reports that
the daily source has positive GBP-to-CAD and GBP-to-USD quotes on all 261 dates
in 1984 even though every type descriptor is blank; on 260 dates in 1985 both
descriptors are blank; and on all 365 dates in 1999 both currency quotes are
positive while descriptors vary, including the exact 31 December row with
CAD blank and USD `AR`. The audit records zero duplicate date-currency rows
for this source slice. These observations establish that missing or unequal
type descriptors do not imply a missing quote. The Xpressfeed guide's printed
p. 78 describes `EXRATTPD` as actual versus carried-forward provenance and
does not define a filter that excludes positive quotes with blank or differing
types.

Attempt 04 therefore discarded observed rate values by requiring `AR` and
could also divide two GBP cross-rates selected from different dates. Attempt
05 removes the unsupported `AR` restriction and retains each selected leg's
type and date. It chooses the latest nonfuture shared date for both daily
cross-rate legs, with the existing seven-day bound. If no shared-date pair is
available, conversion stays missing. The final SAS log reports exact and
fallback pair coverage, compares the repaired result with all A4 AR-only
misses (including the 694 previously reported CAD gaps), and counts any A4
independently matched factor that fails the shared-date condition. These are
coverage diagnostics, not targets. The A4 endpoint of 31 May 2007, FY1984–2006
accounting support, FY1989–2005 analysis period, A3 NOA/OI algebra, CRSP
company-level market equity, and all three frozen model scopes remain fixed.

## Estimation and interpretation

Model 1 uses OLS with controls `RNOA_t`, `ΔRNOA_t`, `GrNOA_t`, `ΔATO_t`, and
`ΔPM_t`, and four life-cycle indicators with the source reference group
omitted. No fixed effects are described in the paper, so the direct OLS call
uses two-way firm/year clustered inference without absorbed effects. Tests
are two-sided, as stated in the paper. The exported indicator coefficients
are increments from the reference category; total effects are `constant +
indicator` and are reported with native `lincom` in the Stata log, matching
Table 5's coefficient convention while preserving the paper's contrast
tests.

Assumptions about finite FX matching, market-equity
source, the reduced exact input requirements, age dating, fiscal average, A&R window,
portfolio timing/ties, zero signs, and winsorization pool are explicit
best-effort choices. No sample or specification is tuned to published
estimates.
