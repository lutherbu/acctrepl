adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
**************************H1
*Import Table 3 data
use "Table 3.dta", clear

*Demean interactions
summarize avgftr l4score
gen ftr_dm=avgftr+.13478
gen l4score_dm=l4score+9.378289
gen ftr_score_dm= ftr_dm*l4score_dm

*Regression
reg avgfros avgftr l4score ftr_score_dm avgros l4rd_at l4ads_at l4intan_at l4cash_at l4debt_at ///
    l4size i.sic2 i.fyear, vce(cluster gvkey)

*descriptives
tabstat avgfros avgftr l4score avgros l4rd_at l4ads_at l4intan_at l4cash_at l4debt_at l4at, ///
    stat(n mean p25 median p75 sd) col(stat)
