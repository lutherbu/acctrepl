adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
cd "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports"
use "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period_mining_regions.dta", clear
adopath ++ "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Personal"

egen cid = group(GRID_CEN)
egen nid = group(iso)
egen yid = group(year)

gen constant = 1

tsset cid year

/* Internet Appendix */
*------------------------------------------------------------------------------
* Figure IA-14: Event Study Plot  
*------------------------------------------------------------------------------

didregress (dv_cell_dum_conflict gdp_per_cap_real labor_force Unemploy_r_males political_stab_indx) (iv_post_x_cc), group(cid) time(year) vce(cluster cid)

estat grangerplot, verbose
graph export "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Pre_Period_mining_regions_IA14_event_study.png", replace


*------------------------------------------------------------------------------
* Figure IA-15: Generalized synthetic control method (Liu et al, 2021)  
*------------------------------------------------------------------------------

*--- Conflict
* Scope gap: fect is unavailable; the Figure IA-15 generalized synthetic-control branch is not substituted.
* Scope gap: the corresponding FECT figure export is omitted with its estimator.


*------------------------------------------------------------------------------
* Figure IA-16: Equivalence Tests (Liu et al, 2021)  
*------------------------------------------------------------------------------

*---  Conflict
* Scope gap: fect is unavailable; the Figure IA-16 equivalence-test branch is not substituted.
* Scope gap: the corresponding FECT figure export is omitted with its estimator.


*------------------------------------------------------------------------------
* Figure IA-19: Equivalence Tests (Liu et al, 2021)  
*------------------------------------------------------------------------------
keep if democracy_2010 == 1

*---  Conflict 
* Scope gap: fect is unavailable; the democratic-sample Figure IA-19 branch is not substituted.
* Scope gap: the corresponding FECT figure export is omitted with its estimator.


use "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period_mining_regions.dta", clear

egen cid = group(GRID_CEN)
egen nid = group(iso)
egen yid = group(year)

gen constant = 1

tsset cid year

keep if non_democracy_2010 == 1

*--- Conflict 
* Scope gap: fect is unavailable; the non-democratic Figure IA-19 branch is not substituted.
* Scope gap: the corresponding FECT figure export is omitted with its estimator.

use "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period_mining_regions.dta", clear

egen cid = group(GRID_CEN)
egen nid = group(iso)
egen yid = group(year)

gen constant = 1

tsset cid year

drop if year < 2010 

/* Main Analysis */
*------------------------------------------------------------------------------
* Figure 1: Event Study Plot  
*------------------------------------------------------------------------------

didregress (dv_cell_dum_conflict gdp_per_cap_real labor_force Unemploy_r_males political_stab_indx) (iv_post_x_cc), group(cid) time(year) vce(cluster cid)

estat grangerplot, verbose
graph export "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Pre_Period_mining_regions_Figure1_event_study.png", replace

*------------------------------------------------------------------------------
* Figure 2: Generalized synthetic control method (Liu et al, 2021)  
*------------------------------------------------------------------------------

*--- Conflict 
* Scope gap: fect is unavailable; the Figure 2 generalized synthetic-control branch is not substituted.

*------------------------------------------------------------------------------
* Figure IA-17: Role of Political Institutions 
*------------------------------------------------------------------------------

*--- Conflict
my_reg2hdfespatial dv_cell_dum_conflict iv_cov_country_x_yr2010 iv_cov_country_x_yr2011 iv_cov_country_x_yr2012 iv_cov_country_x_yr2013 iv_cov_country_x_yr2015 iv_cov_country_x_yr2016 iv_cov_country_x_yr2017 iv_cov_country_x_yr2018 iv_cov_country_x_yr2019 gdp_per_cap_real labor_force Unemploy_r_males political_stab_indx if democracy_2010 == 1, timevar(yid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(500) lagcutoff(100000)

eststo Democracy

my_reg2hdfespatial dv_cell_dum_conflict iv_cov_country_x_yr2010 iv_cov_country_x_yr2011 iv_cov_country_x_yr2012 iv_cov_country_x_yr2013 iv_cov_country_x_yr2015 iv_cov_country_x_yr2016 iv_cov_country_x_yr2017 iv_cov_country_x_yr2018 iv_cov_country_x_yr2019 gdp_per_cap_real labor_force Unemploy_r_males political_stab_indx if non_democracy_2010 == 1, timevar(yid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(500) lagcutoff(100000)

eststo Non_Democracy

coefplot Democracy Non_Democracy, keep(iv_cov_country_x_yr2010 iv_cov_country_x_yr2011 iv_cov_country_x_yr2012 iv_cov_country_x_yr2013 iv_cov_country_x_yr2014 iv_cov_country_x_yr2015 iv_cov_country_x_yr2016 iv_cov_country_x_yr2017 iv_cov_country_x_yr2018 iv_cov_country_x_yr2019) order(iv_cov_country_x_yr2010 iv_cov_country_x_yr2011 iv_cov_country_x_yr2012 iv_cov_country_x_yr2013 . iv_cov_country_x_yr2015 iv_cov_country_x_yr2016 iv_cov_country_x_yr2017 iv_cov_country_x_yr2018 iv_cov_country_x_yr2019)  vertical  addplot(scatter @b @at) 
graph export "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Pre_Period_mining_regions_FigureIA17_coefplot.png", replace

eststo clear


*------------------------------------------------------------------------------
* Figure IA-18: Role of Political Institutions: Generalized synthetic control method (Liu et al, 2021)  
*------------------------------------------------------------------------------

keep if democracy_2010 == 1

*--- Conflict 
* Scope gap: fect is unavailable; the democratic-sample Figure IA-18 branch is not substituted.
* Scope gap: the corresponding FECT figure export is omitted with its estimator.

use "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period_mining_regions.dta", clear

egen cid = group(GRID_CEN)
egen nid = group(iso)
egen yid = group(year)

gen constant = 1

drop if year < 2010

keep if non_democracy_2010 == 1

*--- Conflict 
* Scope gap: fect is unavailable; the non-democratic Figure IA-18 branch is not substituted.
* Scope gap: the corresponding FECT figure export is omitted with its estimator.





