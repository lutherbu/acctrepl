adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
*=================================================================*
*F-statistics  for Tables 4, 6, 8
cd "@@ACCTREPL_WORK@@/Output"

clear
set more off
use sample.dta

*=================================================================*
rename *, lower
destring gvkey, replace
destring sic, replace
duplicates drop gvkey date_monthly,force
sort gvkey date_monthly
tsset gvkey date_monthly  
global controls log_resolve_3yr log_mve btm cash tangibility lev zscore_qtl roa sg filings log_filings 
  

  
*Table 4
gen interact=dum_investigate*facase
global fa1 dum_discover dum_investigate dum_resolve dum_review 1.dum_discover#1.facase interact 1.dum_resolve#1.facase 1.dum_review#1.facase facase 


ppmlhdfe edgar $fa1 $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
test interact+dum_investigate=0
reghdfe log_total $fa1 $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
test interact+dum_investigate=0


drop interact
gen interact=dum_investigate*highcc
global highcc1 dum_discover dum_investigate dum_resolve dum_review 1.dum_discover#1.highcc interact 1.dum_resolve#1.highcc 1.dum_review#1.highcc 1.highcc

ppmlhdfe edgar $highcc1 $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
test interact+dum_investigate=0
reghdfe log_total $highcc1 $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
test interact+dum_investigate=0


drop interact
gen interact=dum_investigate*highp
global highp1 dum_discover dum_investigate dum_resolve dum_review 1.dum_discover#1.highp interact 1.dum_resolve#1.highp 1.dum_review#1.highp 1.highp

ppmlhdfe edgar $highp1 $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
test interact+dum_investigate=0
reghdfe log_total $highp1 $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
test interact+dum_investigate=0




*Table 6 Financial review Inspection
drop interact
gen interact=dum_inspect*fr_inspect
global frinspect1 dum_prepare dum_inspect dum_postinspect 1.dum_prepare#1.fr_inspect interact 1.dum_postinspect#1.fr_inspect fr_inspect


ppmlhdfe edgar $frinspect1 $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
test interact+dum_inspect=0
reghdfe log_total $frinspect1 $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
test interact+dum_inspect=0




*Table 8 financial consideration rule post month
drop interact
gen interact=dum_postrule*finrule
global fin1 dum_preparerule dum_publishrule dum_postrule 1.dum_preparerule#1.finrule 1.dum_publishrule#1.finrule interact finrule


ppmlhdfe edgar $fin1 $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
test interact+dum_postrule=0
reghdfe log_total $fin1 $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
test interact+dum_postrule=0






