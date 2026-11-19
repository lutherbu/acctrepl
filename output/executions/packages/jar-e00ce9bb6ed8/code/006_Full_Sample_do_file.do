adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
clear
use "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Full_Sample.dta", clear
adopath ++ "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Personal"

* Install steps are omitted; use only commands already available in approved read-only ado paths.
* Install steps are omitted; use only commands already available in approved read-only ado paths.
* Install steps are omitted; use only commands already available in approved read-only ado paths.
* Install steps are omitted; use only commands already available in approved read-only ado paths.
* Install steps are omitted; use only commands already available in approved read-only ado paths.
* Install steps are omitted; xtpsse remains a declared branch gap.
* Install steps are omitted; _gwtmean has no selected caller in this entrypoint.
* Install steps are omitted; network access is disabled by the frozen policy.


egen cid = group(GRID_CEN)
egen nid = group(iso)
egen yid = group(year)
egen nyid = group(nid yid)

gen mine_around_x_yr2010 = mines_around*yr2010
gen mine_around_x_yr2011 = mines_around*yr2011
gen mine_around_x_yr2012 = mines_around*yr2012
gen mine_around_x_yr2013 = mines_around*yr2013
gen mine_around_x_yr2014 = mines_around*yr2014
gen mine_around_x_yr2015 = mines_around*yr2015
gen mine_around_x_yr2016 = mines_around*yr2016
gen mine_around_x_yr2017 = mines_around*yr2017
gen mine_around_x_yr2018 = mines_around*yr2018
gen mine_around_x_yr2019 = mines_around*yr2019

gen constant = 1

/* Table 5: DiDiD 3-way */

eststo clear

eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_post_x_m_around_x_cc mine_around_x_yr2010 mine_around_x_yr2011 mine_around_x_yr2012 mine_around_x_yr2013 mine_around_x_yr2015 mine_around_x_yr2016 mine_around_x_yr2017 mine_around_x_yr2018 mine_around_x_yr2019 , timevar(nyid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(500) lagcutoff(100000) 

/* Table 5: Poisson regression */

* Scope gap: xtpsse Poisson estimator unavailable; no substitute estimator is used.

esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_5_spatial_only.csv", append ar2 star(* 0.10 ** 0.05 *** 0.01) keep (iv_post_x_m_around_x_cc)

/* Table IA-6 DiDiD 3-way: Standard Errors */

eststo clear

eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_post_x_m_around_x_cc mine_around_x_yr2010 mine_around_x_yr2011 mine_around_x_yr2012 mine_around_x_yr2013 mine_around_x_yr2015 mine_around_x_yr2016 mine_around_x_yr2017 mine_around_x_yr2018 mine_around_x_yr2019 , timevar(nyid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(100) lagcutoff(100000) 


eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_post_x_m_around_x_cc mine_around_x_yr2010 mine_around_x_yr2011 mine_around_x_yr2012 mine_around_x_yr2013 mine_around_x_yr2015 mine_around_x_yr2016 mine_around_x_yr2017 mine_around_x_yr2018 mine_around_x_yr2019 , timevar(nyid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(1000) lagcutoff(100000) 


eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_post_x_m_around_x_cc mine_around_x_yr2010 mine_around_x_yr2011 mine_around_x_yr2012 mine_around_x_yr2013 mine_around_x_yr2015 mine_around_x_yr2016 mine_around_x_yr2017 mine_around_x_yr2018 mine_around_x_yr2019 , timevar(nyid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(100) lagcutoff(1) 


eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_post_x_m_around_x_cc mine_around_x_yr2010 mine_around_x_yr2011 mine_around_x_yr2012 mine_around_x_yr2013 mine_around_x_yr2015 mine_around_x_yr2016 mine_around_x_yr2017 mine_around_x_yr2018 mine_around_x_yr2019 , timevar(nyid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(100) lagcutoff(5) 


eststo: quietly reghdfe dv_cell_dum_conflict iv_post_x_m_around_x_cc mine_around_x_yr2010 mine_around_x_yr2011 mine_around_x_yr2012 mine_around_x_yr2013 mine_around_x_yr2015 mine_around_x_yr2016 mine_around_x_yr2017 mine_around_x_yr2018 mine_around_x_yr2019 , absorb(cid nyid) vce(cluster nid)

esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_IA-6.csv", replace b(%6.3f) se(%6.3f) star(* 0.1 ** 0.05 *** 0.01) keep (iv_post_x_m_around_x_cc)


/* Table 6: Role of Political Institutions 3-way */

eststo clear

eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_post_x_m_around_x_cc iv_post_x_m_around if non_democracy_2010 == 0, timevar(nyid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(500) lagcutoff(100000)


eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_post_x_m_around_x_cc iv_post_x_m_around if non_democracy_2010 == 1, timevar(nyid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(500) lagcutoff(100000)


esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_6.csv", ar2 star(* 0.10 ** 0.05 *** 0.01) keep (iv_post_x_m_around_x_cc)


reghdfe dv_cell_dum_conflict i.democracy_2010##(c.iv_post_x_m_around_x_cc c.iv_post_x_m_around), a(i.democracy_2010##cid democracy_2010##nyid) cluster(democracy_2010##cid)
outreg2 using Table_6_F_test, append excel tstat dec(3) tdec(2) addtext(Cell Fixed Effects, Yes, Mine_x_Year Fixed Effects, Yes, Country_x_Year Fixed Effects, Yes, Cluster by Cell, Yes) nocons adjr2


