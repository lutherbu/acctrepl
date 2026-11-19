adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
**************************H2: Financial Hedge
*Import Table 5A data
use "Table 5A.dta", clear

*Demean interactions (FCD)
summarize avgftr
gen ftr_dm=avgftr+.1368157
gen ftr_hedge_dm=ftr_dm*l4hedge

*Regression
reg avgfros avgftr l4hedge ftr_hedge_dm avgros l4rd_at l4ads_at l4intan_at l4cash_at l4debt_at ///
    l4size i.sic2 i.fyear, vce(cluster gvkey)

clear
*Import Table 5A data again
use "Table 5A.dta", clear

*Demean interactions (FCD_at)
summarize avgftr l4fcd_at
gen ftr_dm=avgftr+.1368157
gen l4fcd_at_dm=l4fcd_at-.0439293
gen ftr_l4fcd_at_dm=ftr_dm*l4fcd_at_dm

*Regression
reg avgfros avgftr l4fcd_at ftr_l4fcd_at_dm avgros l4rd_at l4ads_at l4intan_at l4cash_at ///
    l4debt_at l4size i.sic2 i.fyear, vce(cluster gvkey)

*descriptives
tabstat l4hedge l4fcd_at, stat(n mean p25 median p75 sd) col(stat)
