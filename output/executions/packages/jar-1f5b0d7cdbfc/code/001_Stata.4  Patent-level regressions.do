adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
/*****************************************************
* Run the files in the following order
	Stata.1) Creating_index.do
	Stata.2) Computing forward citations.do
	Stata.3) Firm-level regressions.do
	Stata.4) Patent-level regressions.do
	Stata.5) Extracting_distance_to_DOJ_offices.do 
	Stata.6) Validating indexes.do
 
 The data needed for each step is contained in this replication dataset. For example,
 STEP 1 produces the file indexes.dta, which is used in Steps 3 and 6. This step can 
 be skipped since the file is also in the replication dataset.

 Before running the code: adjust the path.
 
 This file corresponds to Stata.4. It produces the tables from the patent-level 
 regressions.
*****************************************************/
log using "outputs/Stata 4. Patent-level regressions_logfile.log", replace

clear all
set more off
* ACTION REQUIRED: SET THE PATH WHERE YOU DOWNLOAD THE REPLICATION PACKAGE DATA
global pathMAIN "@@ACCTREPL_WORK@@/DATA"

set processors 2
*ssc install reghdfe

*****************************************************
* LOAD AND MERGE DATASETS
*****************************************************
* Load the forward citations dataset produced in step 2)
	use "$pathMAIN/forward_citations_collapsed", clear
	gen i_date = date(idate, "MDY")
	format i_date %td
	gen fyear=year(i_date)
	keep if permno!=. & fyear>1990
	destring class subclass, replace force
		
	* Add Funk et al. (2016) data on technological change (variable cd and mcd; var i_# means #-years forward citations)
	gen patent_number=patnum
	joinby patent_number using "$pathMAIN/cdindex_cross_20190513", unmatched(master)
		tab _merge
		drop _merge
	* Add Kelly et al. (2021) data on breakthrough innovation
	joinby patnum using "$pathMAIN/KPST_Breakthrough_v201912", unmatched(master)
		tab _merge
		drop _merge
	* Add cleaned dataset from firm-level regressions dataset (contains the firm-level controls and treatment variables)
	joinby gvkey fyear using "$pathMAIN/annual_cleaned", unmatched(master)
		tab _merge
		drop _merge

	
*****************************************************
* TABLES 1, 4, AND 5
*****************************************************
	* KEY DEPENDENT AND INDEPENDENT VARIABLES
	capture drop conditionAIPA
	gen conditionAIPA=(fyear>(2000-5) & fyear<=(2000+5)) 
	keep if conditionAIPA==1
	* Winsorize log and non-log citation variables
	foreach yr in 3 5 7 10{
		foreach var in ncites forward_cites_`yr'yr_all  {
			capture winsor `var',g(w`var') p(0.01)
			capture gen ln`var'=ln(1+`var')
			capture winsor ln`var',g(wln`var') p(0.01)
		}
	}
	label variable break_p95_rrfsim05 "top_5%_in_terms_of_fsim5/bsim5"
	label variable break_p90_rrfsim05 "top_10%_in_terms_of_fsim5/bsim5"

* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* ADD TO TABLE 1: DESCRIPTIVE STATISTICS (CITATION VARIABLES)
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	tabstat wlnncites wlnforward_cites_3yr_all wlnforward_cites_5yr_all wlnforward_cites_7yr_all  wlnforward_cites_10yr_all mcd_5 mcd_10 break_p95_rrfsim05 break_p90_rrfsim05 if conditionAIPA==1, stats(mean median sd N) column(stats)
	
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* TABLES 4: CITATION REGRESSIONS (POISSON REGRESSIONS IN THE ONLINE APPENDIX)
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
		global xcontrol wxsga_sale wlnsale wlnsale4dmed 
		global xvar wpAIPA_x_logdelay  $xcontrol  
		global clustervar sic4d
		global absorbvar fyear##class gvkey

		eststo clear
		foreach yvar in  wlnncites wlnforward_cites_3yr_all wlnforward_cites_5yr_all wlnforward_cites_7yr_all  wlnforward_cites_10yr_all {
			quiet: eststo: reghdfe `yvar' $xvar if conditionAIPA==1 , vce(cluster $clustervar) absorb($absorbvar)
		}
		esttab, b(3) varwidth(30) order(wpAIPA*) se(3) ar2 drop(_cons)  star(* 0.10 ** 0.05 *** 0.01) nogap label
	
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* TABLES 5: BREAKTHROUGH INNOVATION
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		eststo clear
		foreach yvar in  mcd_5 mcd_10 break_p95_rrfsim05 break_p90_rrfsim05 {
			quiet: eststo: reghdfe `yvar' $xvar if conditionAIPA==1 , vce(cluster $clustervar) absorb($absorbvar)
		}
		esttab, b(3) varwidth(30) order(wpAIPA*) se(3) ar2 drop(_cons)  star(* 0.10 ** 0.05 *** 0.01) nogap label

* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* FIGURES 4 AND 5: PRE-TRENDS / DYNAMIC TREATMENT EFFECT
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* INTERACT TREATMENT WITH DUMMY FOR EACH YEAR
		capture drop *lambda* treat_*
		forvalues t=1997(1)2005 {
			gen lambda`t'=(fyear==`t') 
			gen treat_`t'=logdelay*lambda`t'
		}
* REGRESSIONS PRODUCING THE FIGURES
	global xvar treat_*  $xcontrol
	foreach yvar in  wlnncites wlnforward_cites_3yr_all mcd_5 break_p95_rrfsim05 {
		reghdfe `yvar' $xvar if conditionAIPA==1 , vce(cluster $clustervar) absorb(fyear##class gvkey) level(90)
		* To generate the figures, use the coefficient estimates of treat_1997-treat_2005 and their 90% confidence intervals
		coefplot , vertical keep(treat_1997 treat_1998 treat_1999 treat_2000 treat_2001 treat_2002 treat_2003 treat_2004 treat_2005)	
	}
log close