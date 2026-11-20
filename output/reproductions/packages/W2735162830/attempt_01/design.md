# Daske et al. (2013): Table 6 reproduction assessment

## Scope and decision

The primary target is Table 6, which reports the nine heterogeneity regressions in the paper's equation (1): three economic-consequence outcomes, each paired with three firm-level serious-adopter classifications. The deposit provides author-prepared IAS/IFRS and serious-adopter indicators, but no analysis program. This build therefore uses new SAS code only for bounded, aggregate input and crosswalk checks; it does not infer author code or fill missing variables.

No Table 6 regression was run. The exact specification requires common controls that are not in the deposit and whose firm-year realization or source vintage could not be verified in the local inputs. The cross-referenced Daske et al. (2008) paper supplies the New Markets venue list and states that Worldscope Index Member is a time-invariant latest-fiscal-year field; therefore, an annual index history is not required. The remaining issue for Index Member is whether the current local header matches the authors' original data vintage. For New Markets and U.S. Listing, the deposit and locally checked annual inputs do not provide historical firm-year exchange/listing statuses. These common RHS gaps block all nine exact baselines. The required contemporaneous or pre-adoption reporting-variable levels and the paper's sample screens were also not constructed in this bounded preflight.

The cost-of-capital recipe is documented in the local Hail and Leuz (2006) appendix; it is not treated as unavailable. Its I/B/E/S forecast, Worldscope book value and payout, month +10 price, and country-inflation inputs have not been assembled or coverage-checked for this sample. No replacement cost-of-capital measure was used.

## Table 6 targets

Equation (1) is `EconCon = a0 + a1 IAS + a2 Serious Adopters + controls + fixed effects + error`. In the deposited data, `ias_serious_fac`, `ias_serious_em`, and `ias_serious_cov` are firm indicators, so the corresponding regression exposure is the IAS-year indicator interacted with the applicable firm classification. The mappings are:

| Deposited firm indicator | Paper partition |
| --- | --- |
| `ias_serious_fac` | Reporting Incentives |
| `ias_serious_em` | Reporting Behavior |
| `ias_serious_cov` | Reporting Environment |

The outcomes are (1) log yearly median Amihud price impact, omitting zero-return days; (2) log yearly median quoted bid-ask spread; and (3) mean implied cost of equity from Claus–Thomas, Gebhardt–Lee–Swaminathan, Easton, and Ohlson–Juettner-Nauroth. For outcomes computed over a year, the paper uses the fiscal-year window from month -2 through month +10 and measures the consequence at month +10. The local Hail and Leuz (2006) appendix specifies the four cost-of-capital models and the month +10 price/forecast timing, with required I/B/E/S forecasts, Worldscope book value and payout inputs, and country inflation. Table 6 multiplies reported coefficients by 100, includes country, year, and industry fixed effects, clusters standard errors by firm, and limits IAS observations to the first five adoption years. For IAS adopters the reporting-variable level control is the pre-adoption mean; otherwise it is the contemporaneous value.

The published Table 6 column Ns, in incentives / behavior / environment order, are:

| Outcome | Published N |
| --- | ---: |
| Price Impact | 65,752 / 58,739 / 67,390 |
| Bid-Ask Spread | 46,055 / 41,272 / 47,277 |
| Cost of Capital | 24,253 / 22,914 / 24,984 |

Table 3 reports average-adoption regressions and is a distinct target. It is not substituted for Table 6's serious-versus-label heterogeneity analysis.

## Deposit and sample checks

The archive inventory contains the author data-description PDF, coding-appendix PDF, and one Stata dataset; no executable author code is present. The staged dataset has 293,815 firm-year rows and 18 variables. Its author labels identify the serious variables as firm indicators. In the 1990–2005 paper window, the file has 255,229 rows and 31,596 distinct Datastream company codes (`dscd`), with 10,015 IAS-reporting rows and 4,155 U.S.-GAAP-reporting rows. The three serious indicators are nonmissing on 7,191 behavior, 9,176 environment, and 8,037 incentives rows in that window. These are input counts, not regression samples.

The author package ZIP is `iasdatadhlv2013.zip` (SHA256 `4acc0010bc0bd737ed533205d551fca28bb1ac02f0b1bbf8dc7b8c85763bfdc5`); it contains the staged `ias_data_dhlv_jar_2013.dta` (SHA256 `0dc88a4f796bfd5a64d6870c1675b3b741e740978024d4fbfccda224835d3a8e`).

## Identifier and annual-input evidence

`preflight.sas` imports the staged DTA into WORK, reads only the catalog-listed Worldscope, Datastream names, and DS–Worldscope link tables, and prints aggregates only. It checks nonmissing keys on both sides of ISIN and Datastream joins. The aggregate results are also recorded in `tables/input_coverage.csv`.

- Exact string match from DTA `dscd` to `TR_DS.WRDS_DS_NAMES.DsCode` finds 29,374 DTA firms and 29,374 distinct InfoCodes. This is an ID-level candidate map; name-table date validity is not applied, so it is not treated as a dated market-data link.
- A non-date-valid DTA ISIN to Datastream-name ISIN match finds 29,525 firms and 29,699 firm–InfoCode pairs. Multiple InfoCodes and the table's StartDate/EndDate validity mean this cannot be used as an unfiltered firm-year crosswalk.
- A direct annual Worldscope Funda ISIN/year join (`freq='A'`) finds a match for 204,065 target firm-years, but 25,147 matched keys map to more than one distinct Worldscope code. Those ambiguous keys are not resolved by choosing one code.
- The WRDS DS–Worldscope link table maps InfoCodes to Worldscope codes. Its catalog labels `startdate` and `enddate` as Datastream price start/end dates, not explicit identifier-vintage fields. Requiring a nonmissing annual fiscal end within those price-coverage bounds yields 192,997 target firm-years with a dated annual match. Of these, 192,837 have exactly one Worldscope code and one fiscal-end date; 160 have multiple Worldscope codes and 24 have multiple fiscal-end dates. This supports annual-input feasibility for many firms but does not establish historical listing, exchange-class, or index-membership controls.

For the unique Worldscope-code/fiscal-end keys, the preflight finds at least one value on 192,789 rows for total assets; 192,612 liabilities; 192,606 net income; 138,650 operating cash flow; 192,224 sales; 187,046 USD market capitalization; 192,321 common equity; 178,905 ROA; and 180,250 I/B/E/S tickers. These are data-availability counts, not claims that the paper's variables have been reconstructed.

## Remaining input requirements

- **Shared listing controls:** the local Daske et al. (2008) paper's Table 1 note (printed p. 1102) gives the New Markets list: Bovespa Novo Mercado; Expandi; Hercules and Mothers; Irish Enterprise Exchange; Market for Alternative Investment; Mesdaq; Neuer Markt; Nordic Growth Market; Nuevo Mercado; NZAX Market; and Sesdaq. It defines U.S. Listing as a non-U.S. firm's shares traded over the counter or listed on a U.S. exchange. These sources resolve the definitions, but the deposited 18-column file has no firm-year market-status variables. `TRWS.WRDS_WS_STOCK_HEADER.ITEM5427` is a current exchange listing snapshot (`year_` has one distinct value); no historical firm-year exchange route was validated. The Datastream daily table has exchange identifiers, but the bridge from each DTA firm to the historically relevant listing/venue for these indicators was not validated. No firm-year status was filled from a current snapshot.
- **Index Member vintage:** the Daske et al. (2008) Table 1 note says Worldscope field 05661 is available only for the most recent fiscal year and that Index Member is time-invariant. The local header has `ITEM5661`, so the paper does not require a year-by-year index panel. The local extraction is current and does not establish agreement with the original data vintage used by the 2013 authors. The Datastream index-constituent table uses a different source/definition and was not substituted.
- **Reporting-level controls:** the deposit contains firm-level serious/label classifications, not the annual continuous reporting-variable levels and pre-adoption means required by Table 6. Worldscope, segment, and I/B/E/S inputs exist locally, but their exact transformed measures and Table 6 sample coverage were not constructed in this bounded preflight. This remains an unverified requirement, separate from the historical-indicator blockers above.
- **Industry effects:** the deposit has no industry field. Worldscope Company contains industry/SIC items, but that cataloged company table is not the annual historical panel needed to verify the paper's sample-year classification. No current industry assignment was propagated backward.
- **Cost of capital:** the local Hail and Leuz (2006) paper supplies formulas (Appendix A.1, printed p. 525) and data requirements (Appendix A.2, printed pp. 527–528). Exact sample coverage still needs checking for I/B/E/S consensus forecasts at month +10, positive forecasts/growth, Worldscope book value and payout, Datastream price, and country inflation. The paper's Table 6 also requires forecast bias and inflation as controls. These inputs were not assembled here.

The daily Datastream price table has daily return, USD price, bid/ask, volume, and exchange-identifier fields needed to investigate Price Impact, Bid-Ask Spread, and listing routes. Those outcome aggregations and firm-year listing routes were not built because the faithful Table 6 common RHS could not be verified; a regression omitting those controls would be a different, partial specification. No native Stata regression or result table is claimed.

## Replay

Stage the deposit's `ias_data_dhlv_jar_2013.dta` at `input/ias_data_dhlv_jar_2013.dta`. Set `ACCTREPL_SAS_ROOT` to the local SAS data root and run `preflight.sas` with the site's standard SAS 9.4 noninteractive options. The program is self-contained and logs aggregate counts only; it does not write firm rows or raw observations. The final aggregate run completed in SAS 9.4 TS1M8 in 21.88 seconds with no SAS errors.

Native Stata was not invoked: no faithful model-ready panel could be formed without the unvalidated shared RHS inputs. The required Stata template for any later executable fit is `skills/reproduce-accounting-models/references/stata.template.ipynb`.

## Provenance

- Full paper PDF: `papers/pdf/W2735162830.pdf` (SHA256 `ccb688967903e11afd861f6e401f1635d1bfc2b4436855fd721a782a909b199e`).
- Parsed paper: `papers/parsed/W2735162830.json` (SHA256 `f69333ea439fcecec012e9a67972662b23bbddd6bdba42e70471f21e9fb6c180`).
- Daske et al. (2008) PDF and parsed text: `papers/pdf/W2050886799.pdf` and `papers/parsed/W2050886799.json` (SHA256s recorded in `result.json`); Table 1 note, printed p. 1102, defines U.S. Listing, lists New Markets venues, and states Index Member is time-invariant.
- Hail and Leuz (2006) PDF and parsed text: `papers/pdf/W2528295441.pdf` and `papers/parsed/W2528295441.json` (SHA256s recorded in `result.json`); Appendix A.1–A.2, printed pp. 525–528, specifies the four cost-of-capital methods and inputs.
- Stata execution template reviewed: `skills/reproduce-accounting-models/references/stata.template.ipynb`.
- SAS catalog metadata SHA256 at inspection: `45894893e45d56cb56150252c2ce4e85dfa88f5d891f3e547d3e9ea8003993fb`.
