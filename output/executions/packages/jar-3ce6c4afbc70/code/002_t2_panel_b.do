adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
global datapath "@@ACCTREPL_WORK@@/data"

cd "$datapath"
use "hhi_zip3.dta",clear
sort zip3 year
tempfile zip3
save "`zip3'"

use "complaints2012.dta"
egen state_num=group(state)

sort zip3 year
merge zip3 year using "`zip3'"
gen nonwhite_pct_zip3_wXhhi=nonwhite_pct_zip3_w*hhi
gen hhi_low=(hhi<0.095)
replace hhi_low=. if hhi==.
gen nonwhite_pct_zip3_wXhhi_low=nonwhite_pct_zip3_w*hhi_low
gen aaXhhi_low= africanamerican_pct1_zip3_w*hhi_low

**#T2, Panel B, Col 3, Col 4, zip3 main results*/
reghdfe nb_bankaccount_percapita_w nonwhite_pct_zip3_w nonwhite_pct_zip3_wXhhi_low hhi_low bachelordegree_pct_zip3_w elderly_pct_zip3_w percapitaincome_zip3_w unemploymentrate_zip3_l1m_w,absorb(zip3 state_month) cluster(state_num)
reghdfe nb_bankaccount_percapita_w nonwhite_pct_zip3_w nonwhite_pct_zip3_wXhhi_low hhi_low bachelordegree_pct_zip3_w elderly_pct_zip3_w percapitaincome_zip3_w unemploymentrate_zip3_l1m_w deposit_percapita_zip3_w, absorb(zip3 state_month) cluster(state_num)
gen used = e(sample)
**#T1 Panel B
su complaints_percapita_w nonwhite_pct_zip3_w percapitaincome_zip3_w bachelordegree_pct_zip3_w elderly_pct_zip3_w unemploymentrate_zip3_l1m_w deposit_percapita_zip3 if used == 1
