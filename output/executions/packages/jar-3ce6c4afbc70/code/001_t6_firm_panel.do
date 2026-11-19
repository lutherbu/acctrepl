adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
cd "@@ACCTREPL_WORK@@/data"
use "firm_complaint_long_panel_treat_control.dta", clear
winsor2 complaints_percapita nonwhite_pct_zip3 percapitaincome_zip3 elderly_pct_zip3 bachelordegree_pct_zip3 unemploymentrate_zip3_l1yr, cuts(1 99)

gen change = 1 if d_treat72  >0
replace change = 0 if d_treat72 == 0
replace change = -1 if d_treat72 < 0

gen delta_div_size = d_treat72/boardsize
replace delta_div_size = 0 if delta_div_size == . 

capture drop eventyear eventtime
gen eventyear = int(yearmonth/100)
gen eventtime = int(yearmonth_U/100) - eventyear
	
gen d_pre1 = (eventtime == -1)
gen d_post1 = (eventtime == 1)

egen firm_id = group(yearmonth company_alternative)
tab firm_id
egen firm_month_state = group(firm_id state yearmonth_U)

**#T6
reghdfe complaints_percapita_w c.change##ib0.d_pre1##c.nonwhite_pct_zip3_w c.change##ib0.d_post1##c.nonwhite_pct_zip3_w percapitaincome_zip3_w elderly_pct_zip3_w bachelordegree_pct_zip3_w nonwhite_pct_zip3_w unemploymentrate_zip3_l1yr_w, absorb(zip3 firm_month_state) cluster(firm_id)
reghdfe complaints_percapita_w c.delta_div_size##ib0.d_pre1##c.nonwhite_pct_zip3_w c.delta_div_size##ib0.d_post1##c.nonwhite_pct_zip3_w percapitaincome_zip3_w elderly_pct_zip3_w bachelordegree_pct_zip3_w nonwhite_pct_zip3_w unemploymentrate_zip3_l1yr_w, absorb(zip3 firm_month_state) cluster(firm_id)