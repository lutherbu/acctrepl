adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
*Table 9B
cd "@@ACCTREPL_WORK@@/Output"
clear
set more off
use case.dta
*==============================================================================*

rename *, lower
duplicates drop case_number,force
keep if edgar==1
global controls log_filings p_distance


*Table 9B
reghdfe log_total liquid1 $controls, absorb(primary_law) vce(r)
est store m1
reghdfe log_total liquid2 $controls, absorb(primary_law) vce(r)
est store m2
reghdfe log_total solv1 $controls, absorb(primary_law) vce(r)
est store m3
reghdfe log_total solv2 $controls, absorb(primary_law) vce(r)
est store m4
reghdfe log_total solv3 $controls, absorb(primary_law) vce(r)
est store m5
reghdfe log_total prof1 $controls, absorb(primary_law) vce(r)
est store m6
reghdfe log_total prof2 $controls, absorb(primary_law) vce(r)
est store m7
esttab  m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", nogaps ///
  label replace star(* 0.1049 ** 0.0549 *** 0.0149) parentheses t(2) b(3) ///
  order (_cons liquid1 liquid2 solv1 solv2 solv3 prof1 prof2) coeflabels(_cons "{\i INTERCEPT}") ///
  stats(NoFE n r2, fmt(0 0 3 )) 
esttab m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", ar2(4) append keep(_cons)



*==============================================================================*
*Table 9C
cd "@@ACCTREPL_WORK@@/Output"
clear
set more off
use inspect.dta
*==============================================================================*


rename *, lower
duplicates drop activity_id,force
keep if edgar==1
global controls log_filings

*Table 9C
reghdfe log_total liquid1 $controls, absorb(statute_code) vce(r)
est store m1
reghdfe log_total liquid2 $controls, absorb(statute_code) vce(r)
est store m2
reghdfe log_total solv1 $controls, absorb(statute_code) vce(r)
est store m3
reghdfe log_total solv2 $controls, absorb(statute_code) vce(r)
est store m4
reghdfe log_total solv3 $controls, absorb(statute_code) vce(r)
est store m5
reghdfe log_total prof1 $controls, absorb(statute_code) vce(r)
est store m6
reghdfe log_total prof2 $controls, absorb(statute_code) vce(r)
est store m7
esttab  m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", nogaps ///
  label append star(* 0.1049 ** 0.0549 *** 0.0149) parentheses t(2) b(3) ///
  order (_cons liquid1 liquid2 solv1 solv2 solv3 prof1 prof2) coeflabels(_cons "{\i INTERCEPT}") ///
  stats(NoFE n r2, fmt(0 0 3 )) 
esttab m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", ar2(4) append keep(_cons)



*==============================================================================*
*Table 9
cd "@@ACCTREPL_WORK@@/Output"
clear
set more off
use rule.dta
*==============================================================================*

rename *, lower
duplicates drop id gvkey,force
keep if edgar==1
global controls log_filings


*Table 9D
reghdfe log_total liquid1 $controls, absorb(primary_law) vce(r)
est store m1
reghdfe log_total liquid2 $controls, absorb(primary_law) vce(r)
est store m2
reghdfe log_total solv1 $controls, absorb(primary_law) vce(r)
est store m3
reghdfe log_total solv2 $controls, absorb(primary_law) vce(r)
est store m4
reghdfe log_total solv3 $controls, absorb(primary_law) vce(r)
est store m5
reghdfe log_total prof1 $controls, absorb(primary_law) vce(r)
est store m6
reghdfe log_total prof2 $controls, absorb(primary_law) vce(r)
est store m7
esttab  m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", nogaps ///
  label append star(* 0.1049 ** 0.0549 *** 0.0149) parentheses t(2) b(3) ///
  order (_cons liquid1 liquid2 solv1 solv2 solv3 prof1 prof2) coeflabels(_cons "{\i INTERCEPT}") ///
  stats(NoFE n r2, fmt(0 0 3 )) 
esttab m1 m2 m3 m4 m5 m6 m7 using "ratio.rtf", ar2(4) append keep(_cons)



