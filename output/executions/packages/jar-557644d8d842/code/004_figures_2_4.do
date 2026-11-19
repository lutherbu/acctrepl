adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
*=================================================================*
*Figure 2-Figure 4
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
global enforce dum_discover dum_investigate dum_resolve dum_review
global inspect dum_prepare dum_inspect dum_postinspect
global rule dum_preparerule dum_publishrule dum_postrule

label variable dum_discover "Discovery"
label variable dum_investigate "Investigation"
label variable dum_resolve "Resolution"
label variable dum_review "Review"
label variable dum_prepare "Pre"
label variable dum_inspect "Inspection"
label variable dum_postinspect "Post"
label variable dum_preparerule "Pre"
label variable dum_publishrule "Proposal"
label variable dum_postrule "Post"


*Figure 2
ppmlhdfe edgar $enforce $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store m1
coefplot (m1, recast(connected) lpattern(dash) levels(90) ciopts(recast(rcap))), label vertical drop(_cons $controls) yline(0) ytitle("Coefficient")ylabel(-0.2(0.1)0.4, angle(0) grid)
graph export "../Figure2_enforcement_PPML.pdf", as(pdf) replace

reghdfe log_total $enforce $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store m1
coefplot (m1, recast(connected) lpattern(dash) levels(90) ciopts(recast(rcap))), label vertical drop(_cons $controls) yline(0) ytitle("Coefficient")ylabel(-0.02(0.02)0.06, angle(0) grid)
graph export "../Figure2_enforcement_reghdfe.pdf", as(pdf) replace

*Figure 3
ppmlhdfe edgar $inspect $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store m2
coefplot (m2, recast(connected) lpattern(dash) levels(90) ciopts(recast(rcap))), label vertical drop(_cons $controls) yline(0) ytitle("Coefficient")ylabel(-0.2(0.1)0.4, angle(0) grid)
graph export "../Figure3_inspection_PPML.pdf", as(pdf) replace

reghdfe log_total $inspect $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store m2
coefplot (m2, recast(connected) lpattern(dash) levels(90) ciopts(recast(rcap))), label vertical drop(_cons $controls) yline(0) ytitle("Coefficient") ylabel(-0.02(0.02)0.06, angle(0) grid)
graph export "../Figure3_inspection_reghdfe.pdf", as(pdf) replace

*Figure 4
ppmlhdfe edgar $rule $controls, a(gvkey date_monthly) cl(gvkey date_monthly) separation(simplex)
estimates store m3
coefplot (m3, recast(connected) lpattern(dash) levels(90) ciopts(recast(rcap))), label vertical drop(_cons $controls) yline(0) ytitle("Coefficient")ylabel(-0.2(0.1)0.4, angle(0) grid)
graph export "../Figure4_rule_PPML.pdf", as(pdf) replace

reghdfe log_total $rule $controls, a(gvkey date_monthly) cl(gvkey date_monthly)
estimates store m3
coefplot (m3, recast(connected) lpattern(dash) levels(90) ciopts(recast(rcap))), label vertical drop(_cons $controls) yline(0) ytitle("Coefficient") ylabel(-0.02(0.02)0.06, angle(0) grid)
graph export "../Figure4_rule_reghdfe.pdf", as(pdf) replace

