adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
use "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Eastern_DRC.dta", clear
adopath ++ "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Personal"
	
	xtset id_3 yyyymm	
	sort id_3 yyyymm
	
gen DF_Rule = iv_a_post_cmd*df_terr
gen DF_3T_ = iv_a_post_cmd*df_terr*t3terr_t
gen DF_G_ = iv_a_post_cmd*df_terr*goldterr_t

gen CMD_Rule = iv_post_cmd*df_terr
gen CMD_3T_ = iv_post_cmd*df_terr*t3terr_t
gen CMD_G_ = iv_post_cmd*df_terr*goldterr_t


**********************************************************
*** Table IA-8: Placebo Test
**********************************************************

eststo clear

eststo: xi: quietly my_reg2hdfespatial dv_terr_dum_conflict DF_Rule DF_3T_ DF_G_ wet dry if year < 2015, timevar(yyyymm) panelvar(id_3) lat(point_y) lon(point_x) distcutoff(500) lagcutoff(100000) 

esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_IA-8.csv", ar2 star(* 0.10 ** 0.05 *** 0.01)


*******************************************************************
*** Table IA-10: Including 12-month Dynamic Conflict Lags
*******************************************************************

xtset id_3 yyyymm
	sort id_3 yyyymm
	

	* create lagged conflict dummy
		forvalues v=1(1)12{
		bysort id_3: gen l`v'dv_terr_dum_conflict=dv_terr_dum_conflict[_n-`v']
		}	

eststo clear
	
eststo: xi: my_reg2hdfespatial dv_terr_dum_conflict CMD_Rule CMD_3T_ CMD_G_ l1dv_terr_dum_conflict l2dv_terr_dum_conflict l3dv_terr_dum_conflict l4dv_terr_dum_conflict l5dv_terr_dum_conflict l6dv_terr_dum_conflict l7dv_terr_dum_conflict l8dv_terr_dum_conflict l9dv_terr_dum_conflict l10dv_terr_dum_conflict l11dv_terr_dum_conflict l12dv_terr_dum_conflict wet dry if year > 2009, timevar(yyyymm) panelvar(id_3) lat(point_y) lon(point_x) distcutoff(500) lagcutoff(100000) 

esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_IA-10.csv", ar2 star(* 0.10 ** 0.05 *** 0.01)	

*******************************************************************
*** Table IA-13: Territory-specific Time Trends
*******************************************************************	

egen yrmth = group(id_3 yyyymm)

xtset id_3 yrmth	
	sort id_3 yrmth

	* gen territory specific time trends (linear)
		* Batch setup: omit interactive browse display; no variables or model input are changed.
		
		forvalues v=79(1)150{
		gen yrmth`v'=yrmth if id_3==`v'
		replace yrmth`v'=0 if id_3!=`v'
		}

		local trends "yrmth79-yrmth150"
	

eststo clear
	
eststo: xi: my_reg2hdfespatial dv_terr_dum_conflict CMD_Rule CMD_3T_ CMD_G_ l1dv_terr_dum_conflict l2dv_terr_dum_conflict l3dv_terr_dum_conflict l4dv_terr_dum_conflict l5dv_terr_dum_conflict l6dv_terr_dum_conflict l7dv_terr_dum_conflict l8dv_terr_dum_conflict l9dv_terr_dum_conflict l10dv_terr_dum_conflict l11dv_terr_dum_conflict l12dv_terr_dum_conflict yrmth79-yrmth150 wet dry if year > 2009, timevar(yyyymm) panelvar(id_3) lat(point_y) lon(point_x) distcutoff(500) lagcutoff(100000) 

esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_IA-13.csv", ar2 star(* 0.10 ** 0.05 *** 0.01)		

**********************************************************
*** Table 8: Summary Statistics
**********************************************************

drop if year < 2010

* Time varying variables

	* Conflicts and the CMD Rule
	sum dv_terr_sum_conflict dv_terr_dum_conflict CMD_Rule , detail 

* Time invariant variables 
	
	* mines (full sample)
	sum t3terr_t cassterr_t coltterr_t wolfterr_t goldterr_t, detail
	
	* wet & dry months
	sum dry wet, detail

	
	* mines (DF territories = 1)
	sum t3terr_t cassterr_t coltterr_t wolfterr_t goldterr_t if df_terr == 1, detail

	* mines (DF territories = 0)
	sum t3terr_t cassterr_t coltterr_t wolfterr_t goldterr_t if df_terr ==0, detail	
	
**********************************************************
*** Table 9: Eastern DRC Test
**********************************************************

eststo clear

eststo: xi: quietly my_reg2hdfespatial dv_terr_dum_conflict CMD_Rule CMD_3T_ CMD_G_ wet dry if year > 2009, timevar(yyyymm) panelvar(id_3) lat(point_y) lon(point_x) distcutoff(500) lagcutoff(100000) 

esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_9.csv", ar2 star(* 0.10 ** 0.05 *** 0.01)

*******************************************************************
*** Table IA-9: Standard Errors
*******************************************************************

eststo clear

eststo: xi: quietly my_reg2hdfespatial dv_terr_dum_conflict CMD_Rule CMD_3T_ CMD_G_ wet dry if year > 2009, timevar(yyyymm) panelvar(id_3) lat(point_y) lon(point_x) distcutoff(1000) lagcutoff(100000) 


eststo: xi: quietly my_reg2hdfespatial dv_terr_dum_conflict CMD_Rule CMD_3T_ CMD_G_ wet dry if year > 2009, timevar(yyyymm) panelvar(id_3) lat(point_y) lon(point_x) distcutoff(100) lagcutoff(100000) 


eststo: xi: quietly my_reg2hdfespatial dv_terr_dum_conflict CMD_Rule CMD_3T_ CMD_G_ wet dry if year > 2009, timevar(yyyymm) panelvar(id_3) lat(point_y) lon(point_x) distcutoff(100) lagcutoff(60) 


eststo: xi: quietly my_reg2hdfespatial dv_terr_dum_conflict CMD_Rule CMD_3T_ CMD_G_ wet dry if year > 2009, timevar(yyyymm) panelvar(id_3) lat(point_y) lon(point_x) distcutoff(100) lagcutoff(12) 

xtset id_3 yyyymm

eststo: xi: quietly xtreg dv_terr_dum_conflict CMD_Rule CMD_3T_ CMD_G_ wet dry `trends' if year > 2009, fe cluster(id_3)

	esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_IA-9.csv",replace b(%6.3f) se(%6.3f) star(* 0.1 ** 0.05 *** 0.01) keep (CMD_Rule CMD_3T_ CMD_G_)


*******************************************************************
*** Table IA-11: Summary statistics on territory-share of mines
*******************************************************************

	xtset id_3 yyyymm	
	sort id_3 yyyymm
	
	* gen share of mining sites
		sum asmterr_t goldterr_t t3terr_t
		bysort yyyymm:egen goldtot=total(goldterr_t)
		bysort yyyymm:egen t3tot=total(t3terr_t)
		
		gen sgold=goldterr_t/goldtot
		gen st3=t3terr_t/t3tot
	
	* gen interaction DF & mining share
		gen df_sgold=CMD_Rule*sgold
		gen df_st3=CMD_Rule*st3


		
			bysort id_3:gen x=_n
		sum st3 sgold if df_terr==1 & x==1
		sum st3 sgold if df_terr==0 & x==1

		
*******************************************************************
*** Table IA-12: Territory-share of 3T and Gold Mines
*******************************************************************		
				
eststo clear

eststo:xi: my_reg2hdfespatial dv_terr_dum_conflict CMD_Rule df_st3 df_sgold l1dv_terr_dum_conflict l2dv_terr_dum_conflict l3dv_terr_dum_conflict l4dv_terr_dum_conflict l5dv_terr_dum_conflict l6dv_terr_dum_conflict l7dv_terr_dum_conflict l8dv_terr_dum_conflict l9dv_terr_dum_conflict l10dv_terr_dum_conflict l11dv_terr_dum_conflict l12dv_terr_dum_conflict wet dry if year > 2009, timevar(yyyymm) panelvar(id_3) lat(point_y) lon(point_x) distcutoff(500) lagcutoff(100000)  

		
esttab using "@@ACCTREPL_WORK@@/2_Conflict_Minerals/Conflict_Minerals/Exports/Results/Table_IA-12.csv", ar2 star(* 0.10 ** 0.05 *** 0.01)

**********************************************************
*** Table IA-14: Eastern DRC Test - Poisson
**********************************************************

* Scope gap: xtpsse dependency is unavailable; this Poisson estimator is not substituted.



