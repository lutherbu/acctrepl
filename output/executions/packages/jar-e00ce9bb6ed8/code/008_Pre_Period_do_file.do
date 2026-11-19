adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
use "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period.dta", clear
adopath ++ "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Personal"

egen cid = group(GRID_CEN)
egen nid = group(iso)
egen yid = group(year)
egen nyid = group(nid yid)

gen mine_around_x_yr2007 = mines_around*yr2007
gen mine_around_x_yr2008 = mines_around*yr2008
gen mine_around_x_yr2009 = mines_around*yr2009
gen mine_around_x_yr2010 = mines_around*yr2010
gen mine_around_x_yr2011 = mines_around*yr2011
gen mine_around_x_yr2012 = mines_around*yr2012
gen mine_around_x_yr2013 = mines_around*yr2013
gen mine_around_x_yr2014 = mines_around*yr2014

/* Table IA-5 DiDiD: Placebo Test */

eststo clear

eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_a_post_x_m_around_x_cc mine_around_x_yr2007 mine_around_x_yr2008 mine_around_x_yr2009 mine_around_x_yr2011 mine_around_x_yr2012 mine_around_x_yr2013 mine_around_x_yr2014 if year < 2015, timevar(nyid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(500) lagcutoff(100000) 

esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_IA-5.csv", ar2 star(* 0.10 ** 0.05 *** 0.01) keep(iv_a_post_x_m_around_x_cc)

/* Table IA-7 DiDiD: Placebo Tests: Role of Political Institutions */

keep if democracy_2010 == 1

eststo clear

eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_a_post_x_m_around_x_cc mine_around_x_yr2007 mine_around_x_yr2008 mine_around_x_yr2009 mine_around_x_yr2011 mine_around_x_yr2012 mine_around_x_yr2013 mine_around_x_yr2014 if year < 2015, timevar(nyid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(500) lagcutoff(100000) 

use "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Pre_Period.dta", clear

egen cid = group(GRID_CEN)
egen nid = group(iso)
egen yid = group(year)
egen nyid = group(nid yid)

gen mine_around_x_yr2007 = mines_around*yr2007
gen mine_around_x_yr2008 = mines_around*yr2008
gen mine_around_x_yr2009 = mines_around*yr2009
gen mine_around_x_yr2010 = mines_around*yr2010
gen mine_around_x_yr2011 = mines_around*yr2011
gen mine_around_x_yr2012 = mines_around*yr2012
gen mine_around_x_yr2013 = mines_around*yr2013
gen mine_around_x_yr2014 = mines_around*yr2014

gen constant = 1

keep if non_democracy_2010 == 1

eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_a_post_x_m_around_x_cc mine_around_x_yr2007 mine_around_x_yr2008 mine_around_x_yr2009 mine_around_x_yr2011 mine_around_x_yr2012 mine_around_x_yr2013 mine_around_x_yr2014 if year < 2015, timevar(nyid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(500) lagcutoff(100000) 

esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_IA-7.csv", ar2 star(* 0.10 ** 0.05 *** 0.01) keep(iv_a_post_x_m_around_x_cc)
