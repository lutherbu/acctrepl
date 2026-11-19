adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
**************************H2: Operational Hedge
*Import Table 5B data
use "Table 5B.dta", clear

*Reverse the sign for depth
replace l4depth=l4depth*-1

*Demean interactions (FCD)
summarize avgftr l4ln_breadth l4depth
gen ftr_dm=avgftr+.13478
gen l4ln_breadth_dm=l4ln_breadth-2.475034
gen ftr_breadth_dm=ftr_dm*l4ln_breadth_dm
gen l4depth_dm=l4depth+.4328131
gen ftr_depth_dm=ftr_dm*l4depth_dm

*Regressions
reg avgfros avgftr l4ln_breadth ftr_breadth_dm avgros l4rd_at l4ads_at l4intan_at l4cash_at ///
    l4debt_at l4size i.sic2 i.fyear, vce(cluster gvkey)
reg avgfros avgftr l4depth ftr_depth_dm avgros l4rd_at l4ads_at l4intan_at l4cash_at l4debt_at ///
    l4size i.sic2 i.fyear, vce(cluster gvkey)

*Summary Statistics
tabstat l4ln_breadth l4depth, stat(n mean p25 median p75 sd) col(stat)
