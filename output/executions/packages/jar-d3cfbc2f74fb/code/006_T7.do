adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
**************************Stock Return Test
*Import Table 7 data
use "Table 7.dta", clear

*Regressions
bootstrap, reps(1000) seed(1) cluster(gvkey) :reghdfe ///
    abs_est_narrow b_ftr fsale_sale hedge size, absorb(sic2 fyear)
bootstrap, reps(1000) seed(1) cluster(gvkey) :reghdfe ///
    abs_est_broad b_ftr fsale_sale hedge size, absorb(sic2 fyear)

*Summary Statistics
tabstat abs_est_narrow abs_est_broad b_ftr, stat(n mean p25 median p75 sd) col(stat)
