version 18
/*****************************************************
* Step 4 patent-level extended-sample replay.
* Inputs are the exact locally accepted Step 4 prepared datasets.
* Period caps preserve documented outcome measurement support.
*****************************************************/
capture log close
log using "outputs/Stata 4. Patent-level regressions_logfile.log", replace text

clear all
set more off
* Controller sets the cwd to work; all data and outputs remain within this job.
global pathMAIN "DATA"
set processors 2

capture program drop _record_ext
program define _record_ext
    syntax, KEY(string) TABLE(string) OUTCOME(string) TERM(string) HANDLE(name)
    quietly count if e(sample) & fyear <= 2005
    local original_n = r(N)
    quietly count if e(sample) & fyear > 2005
    local added_n = r(N)
    quietly summarize fyear if e(sample) & fyear > 2005, meanonly
    local last_added = r(max)
    if `original_n' <= 0 | `added_n' <= 0 | missing(`last_added') {
        di as error "No pooled e(sample) support for `key'"
        exit 459
    }
    local last_txt : display %04.0f `last_added'
    local estimate = _b[`term']
    local se = _se[`term']
    local estimate_txt : display %12.6f `estimate'
    local se_txt : display %12.6f `se'
    local estimate_txt = strtrim("`estimate_txt'")
    local se_txt = strtrim("`se_txt'")
    di as text "EXT_SAMPLE `key' `original_n' `added_n' `last_txt'"
    file write `handle' "`key',`table',`outcome',patent_e_sample,`original_n',`added_n',`last_txt',`term',`estimate_txt',`se_txt'" _n
end

file open fitout using "outputs/fit_summary.csv", write replace
file write fitout "key,table,outcome,count_unit,original_n,added_n,last_added,focal_term,estimate,se" _n

*****************************************************
* LOAD AND MERGE DATASETS (accepted Step 4 construction)
*****************************************************
use "$pathMAIN/forward_citations_collapsed", clear
gen i_date = date(idate, "MDY")
format i_date %td
gen fyear=year(i_date)
keep if permno!=. & fyear>1990
destring class subclass, replace force

gen patent_number=patnum
joinby patent_number using "$pathMAIN/cdindex_cross_20190513", unmatched(master)
tab _merge
drop _merge
joinby patnum using "$pathMAIN/KPST_Breakthrough_v201912", unmatched(master)
tab _merge
drop _merge
joinby gvkey fyear using "$pathMAIN/annual_cleaned", unmatched(master)
tab _merge
drop _merge

*****************************************************
* Outcome transformations and the pooled 1996-2010 clock
*****************************************************
capture drop conditionAIPA
gen conditionAIPA=(fyear>(2000-5) & fyear<=(2000+10))
* Retain the accepted winsorization/transformation route and its scope.
foreach yr in 3 5 7 10 {
    foreach var in ncites forward_cites_`yr'yr_all {
        capture winsor `var',g(w`var') p(0.01)
        capture gen ln`var'=ln(1+`var')
        capture winsor ln`var',g(wln`var') p(0.01)
    }
}
label variable break_p95_rrfsim05 "top_5%_in_terms_of_fsim5/bsim5"
label variable break_p90_rrfsim05 "top_10%_in_terms_of_fsim5/bsim5"

* Descriptive statistics respect the measurement horizon of each outcome.
tabstat wlnncites if conditionAIPA==1, stats(mean median sd N) column(stats)
tabstat wlnforward_cites_3yr_all if fyear>1995 & fyear<=2006, stats(mean median sd N) column(stats)
tabstat wlnforward_cites_5yr_all if fyear>1995 & fyear<=2004, stats(mean median sd N) column(stats)
tabstat wlnforward_cites_7yr_all if fyear>1995 & fyear<=2002, stats(mean median sd N) column(stats)
tabstat wlnforward_cites_10yr_all if fyear>1995 & fyear<=1999, stats(mean median sd N) column(stats)
tabstat mcd_5 break_p95_rrfsim05 break_p90_rrfsim05 if fyear>1995 & fyear<=2010, stats(mean median sd N) column(stats)
tabstat mcd_10 if fyear>1995 & fyear<=2008, stats(mean median sd N) column(stats)

*****************************************************
* TABLE 4: fitted outcomes with verified added support
*****************************************************
global xcontrol wxsga_sale wlnsale wlnsale4dmed
global xvar wpAIPA_x_logdelay $xcontrol
global clustervar sic4d
global absorbvar fyear##class gvkey

eststo clear
quietly reghdfe wlnncites $xvar if conditionAIPA==1 & fyear<=2010, vce(cluster $clustervar) absorb($absorbvar)
_record_ext, key(t4_all) table(T4) outcome(wlnncites) term(wpAIPA_x_logdelay) handle(fitout)
eststo t4_all
quietly reghdfe wlnforward_cites_3yr_all $xvar if conditionAIPA==1 & fyear<=2006, vce(cluster $clustervar) absorb($absorbvar)
_record_ext, key(t4_c3) table(T4) outcome(wlnforward_cites_3yr_all) term(wpAIPA_x_logdelay) handle(fitout)
eststo t4_c3
esttab t4_all t4_c3, b(3) varwidth(30) order(wpAIPA*) se(3) ar2 drop(_cons) star(* 0.10 ** 0.05 *** 0.01) nogap label

*****************************************************
* TABLE 5: patent disruptiveness/breakthrough outcomes
*****************************************************
eststo clear
quietly reghdfe mcd_5 $xvar if conditionAIPA==1 & fyear<=2010, vce(cluster $clustervar) absorb($absorbvar)
_record_ext, key(t5_mcd5) table(T5) outcome(mcd_5) term(wpAIPA_x_logdelay) handle(fitout)
eststo t5_mcd5
quietly reghdfe mcd_10 $xvar if conditionAIPA==1 & fyear<=2008, vce(cluster $clustervar) absorb($absorbvar)
_record_ext, key(t5_mcd10) table(T5) outcome(mcd_10) term(wpAIPA_x_logdelay) handle(fitout)
eststo t5_mcd10
quietly reghdfe break_p95_rrfsim05 $xvar if conditionAIPA==1 & fyear<=2010, vce(cluster $clustervar) absorb($absorbvar)
_record_ext, key(t5_kp95) table(T5) outcome(break_p95_rrfsim05) term(wpAIPA_x_logdelay) handle(fitout)
eststo t5_kp95
quietly reghdfe break_p90_rrfsim05 $xvar if conditionAIPA==1 & fyear<=2010, vce(cluster $clustervar) absorb($absorbvar)
_record_ext, key(t5_kp90) table(T5) outcome(break_p90_rrfsim05) term(wpAIPA_x_logdelay) handle(fitout)
eststo t5_kp90
esttab t5_mcd5 t5_mcd10 t5_kp95 t5_kp90, b(3) varwidth(30) order(wpAIPA*) se(3) ar2 drop(_cons) star(* 0.10 ** 0.05 *** 0.01) nogap label

*****************************************************
* FIGURES 4 AND 5: dynamic treatment effects
* Keep policy year 2000; add event-year terms only through each supported end.
*****************************************************
capture drop *lambda* treat_*
forvalues t=1997(1)2010 {
    gen lambda`t'=(fyear==`t')
    gen treat_`t'=logdelay*lambda`t'
}
global xvar treat_* $xcontrol

eststo clear
quietly reghdfe wlnncites $xvar if conditionAIPA==1 & fyear<=2010, vce(cluster $clustervar) absorb(fyear##class gvkey) level(90)
_record_ext, key(dyn_all) table(DYN) outcome(wlnncites) term(treat_2005) handle(fitout)
eststo dyn_all
coefplot, vertical keep(treat_1997 treat_1998 treat_1999 treat_2000 treat_2001 treat_2002 treat_2003 treat_2004 treat_2005 treat_2006 treat_2007 treat_2008 treat_2009 treat_2010)

quietly reghdfe wlnforward_cites_3yr_all $xvar if conditionAIPA==1 & fyear<=2006, vce(cluster $clustervar) absorb(fyear##class gvkey) level(90)
_record_ext, key(dyn_c3) table(DYN) outcome(wlnforward_cites_3yr_all) term(treat_2005) handle(fitout)
eststo dyn_c3
coefplot, vertical keep(treat_1997 treat_1998 treat_1999 treat_2000 treat_2001 treat_2002 treat_2003 treat_2004 treat_2005 treat_2006)

quietly reghdfe mcd_5 $xvar if conditionAIPA==1 & fyear<=2010, vce(cluster $clustervar) absorb(fyear##class gvkey) level(90)
_record_ext, key(dyn_mcd5) table(DYN) outcome(mcd_5) term(treat_2005) handle(fitout)
eststo dyn_mcd5
coefplot, vertical keep(treat_1997 treat_1998 treat_1999 treat_2000 treat_2001 treat_2002 treat_2003 treat_2004 treat_2005 treat_2006 treat_2007 treat_2008 treat_2009 treat_2010)

quietly reghdfe break_p95_rrfsim05 $xvar if conditionAIPA==1 & fyear<=2010, vce(cluster $clustervar) absorb(fyear##class gvkey) level(90)
_record_ext, key(dyn_kp95) table(DYN) outcome(break_p95_rrfsim05) term(treat_2005) handle(fitout)
eststo dyn_kp95
coefplot, vertical keep(treat_1997 treat_1998 treat_1999 treat_2000 treat_2001 treat_2002 treat_2003 treat_2004 treat_2005 treat_2006 treat_2007 treat_2008 treat_2009 treat_2010)

file close fitout
log close
