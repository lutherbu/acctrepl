adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
*=================================================================*
*Tables 2-8 and Figures 2-4;
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


*Table 2B not run: author-compatible corrtbl unresolved; see plan proposal


*Define variable list
global controls log_resolve_3yr log_mve btm cash tangibility lev zscore_qtl roa sg filings log_filings 
global enforce dum_discover dum_investigate dum_resolve dum_review
global inspect dum_prepare dum_inspect dum_postinspect
global rule dum_preparerule dum_publishrule dum_postrule



*Table 3 Enforcement
ppmlhdfe edgar $enforce, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store model0
reghdfe log_total $enforce, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store model1
ppmlhdfe edgar $enforce $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store model2
reghdfe log_total $enforce $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store model3
esttab  model0 model1 model2 model3 using "epa.rtf", nogaps ///
  label replace star(* 0.1049 ** 0.0549 *** 0.0149) parentheses t(2) b(3) ///
  order (_cons) coeflabels(_cons "{\i INTERCEPT}") ///
  stats(MonthFE FirmFE n r2, fmt(0 0 0 3 )) keep(_cons $enforce $controls )  
esttab model0 model1 model2 model3 using "epa.rtf", ar2(4) append keep(_cons)



*Table 4 Cross sectional tests
global fa dum_discover dum_investigate dum_resolve dum_review 1.dum_discover#1.facase 1.dum_investigate#1.facase 1.dum_resolve#1.facase 1.dum_review#1.facase facase 
global highcc dum_discover dum_investigate dum_resolve dum_review 1.dum_discover#1.highcc 1.dum_investigate#1.highcc 1.dum_resolve#1.highcc 1.dum_review#1.highcc 1.highcc
global highp dum_discover dum_investigate dum_resolve dum_review 1.dum_discover#1.highp 1.dum_investigate#1.highp 1.dum_resolve#1.highp 1.dum_review#1.highp 1.highp

ppmlhdfe edgar $fa $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store m1
reghdfe log_total $fa $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store m2
ppmlhdfe edgar $highcc $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store m3
reghdfe log_total $highcc $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store m4
ppmlhdfe edgar $highp $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store m5 
reghdfe log_total $highp $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store m6
esttab  m1 m2 m3 m4 m5 m6 using "epa.rtf", nogaps ///
  label append star(* 0.1049 ** 0.0549 *** 0.0149) parentheses t(2) b(3) ///
  order (_cons) coeflabels(_cons "{\i INTERCEPT}") ///
  stats(MonthFE FirmFE n r2, fmt(0 0 0 3 )) keep(_cons $fa $highcc $highp)  
esttab m1 m2 m3 m4 m5 m6  using "epa.rtf", ar2(4) append keep(_cons)


*Table 5 Inspection
ppmlhdfe edgar $inspect, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store model0
reghdfe log_total $inspect, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store model1
ppmlhdfe edgar $inspect $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store model2
reghdfe log_total $inspect $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store model3
esttab  model0 model1 model2 model3 using "epa.rtf", nogaps ///
  label append star(* 0.1049 ** 0.0549 *** 0.0149) parentheses t(2) b(3) ///
  order (_cons) coeflabels(_cons "{\i INTERCEPT}") ///
  stats(MonthFE FirmFE n r2, fmt(0 0 0 3 )) keep(_cons $inspect $controls)  
esttab model0 model1 model2 model3 using "epa.rtf", ar2(4) append keep(_cons)

  
*Table 6 Financial review Inspection
global frinspect dum_prepare dum_inspect dum_postinspect 1.dum_prepare#1.fr_inspect 1.dum_inspect#1.fr_inspect 1.dum_postinspect#1.fr_inspect fr_inspect

ppmlhdfe edgar $frinspect $controls , a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store model2
reghdfe log_total $frinspect $controls , a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store model3
esttab  model2 model3 using "epa.rtf", nogaps ///
  label append star(* 0.1049 ** 0.0549 *** 0.0149) parentheses t(2) b(3) ///
  order (_cons) coeflabels(_cons "{\i INTERCEPT}") ///
  stats(MonthFE FirmFE n r2, fmt(0 0 0 3 )) keep(_cons $frinspect )  
esttab model0 model1 model2 model3 using "epa.rtf", ar2(4) append keep(_cons)




*Table 7 Rule making test
ppmlhdfe edgar $rule, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store model0 
reghdfe log_total $rule, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store model1
ppmlhdfe edgar $rule $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store model2
reghdfe log_total $rule $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store model3
esttab model0 model1 model2 model3 using "epa.rtf", nogaps ///
  label append star(* 0.1049 ** 0.0549 *** 0.0149) parentheses t(2) b(3) ///
  order (_cons) coeflabels(_cons "{\i INTERCEPT}") ///
  stats(MonthFE FirmFE n r2, fmt(0 0 0 3 )) keep(_cons $rule $controls)  
esttab model0 model1 model2 model3 using "epa.rtf", ar2(4) append keep(_cons)
 



*Table 8 rules with financial consideration
global fin dum_preparerule dum_publishrule dum_postrule 1.dum_preparerule#1.finrule 1.dum_publishrule#1.finrule 1.dum_postrule#1.finrule finrule

ppmlhdfe edgar $fin $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store model2
reghdfe log_total $fin $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store model3
esttab  model2 model3  using "epa.rtf", nogaps ///
  label append star(* 0.1049 ** 0.0549 *** 0.0149) parentheses t(2) b(3) ///
  order (_cons) coeflabels(_cons "{\i INTERCEPT}") ///
  stats(MonthFE FirmFE n r2, fmt(0 0 0 3 )) keep(_cons $fin)  
esttab model0 model1 model2 model3 using "epa.rtf", ar2(4) append keep(_cons)







