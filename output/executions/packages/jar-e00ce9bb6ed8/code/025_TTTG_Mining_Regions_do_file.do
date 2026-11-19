adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
* Standalone compile initialization omitted for installed reghdfe 6.12.3; estimation commands remain unchanged.
egen cid = group(GRID_CEN)
egen yid = group(year)


eststo clear

**********************************************************
*** Table 7: Mineral Price, Regulation, and Conflicts
**********************************************************

eststo: quietly my_reg2hdfespatial dv_cell_dum_conflict iv_post_x_cc_x_p ln_price constant, timevar(yid) panelvar(cid) lat(lat_centroid) lon(long_centroid) distcutoff(100) lagcutoff(100000)

esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_7.csv", ar2 star(* 0.10 ** 0.05 *** 0.01)
