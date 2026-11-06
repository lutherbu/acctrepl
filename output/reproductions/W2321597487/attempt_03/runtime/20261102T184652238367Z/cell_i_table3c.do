version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear
est clear
preserve
keep if sample_c_cf==1 & industry_c_cf==1
asreg acc cf dind dind_indadj_cf, by(sic3) minimum(30)
egen byte __industry_tag=tag(sic3)
quietly count if __industry_tag==1
local __nind=r(N)
quietly summarize _R2 if __industry_tag==1
local __r2=r(mean)*100
quietly summarize _adjR2 if __industry_tag==1
local __ar2=r(mean)*100
estpost summarize _b_cons _b_cf _b_dind _b_dind_indadj_cf if __industry_tag==1
matrix __p=e(mean)
local __j=1
foreach __v of varlist _b_cons _b_cf _b_dind _b_dind_indadj_cf {
    capture quietly ttest `__v' = 0 if __industry_tag==1
    if !_rc matrix __p[1,`__j']=r(p)
    local ++__j
}
estadd matrix p=__p, replace
estadd scalar N=`__nind', replace
estadd scalar r2=`__r2', replace
estadd scalar r2_a=`__ar2', replace
est store i_cf
restore
preserve
keep if sample_c_dd==1 & industry_c_dd==1
asreg acc cf cf_lag cf_lead dind dind_indadj_cf, by(sic3) minimum(30)
egen byte __industry_tag=tag(sic3)
quietly count if __industry_tag==1
local __nind=r(N)
quietly summarize _R2 if __industry_tag==1
local __r2=r(mean)*100
quietly summarize _adjR2 if __industry_tag==1
local __ar2=r(mean)*100
estpost summarize _b_cons _b_cf _b_cf_lag _b_cf_lead _b_dind _b_dind_indadj_cf if __industry_tag==1
matrix __p=e(mean)
local __j=1
foreach __v of varlist _b_cons _b_cf _b_cf_lag _b_cf_lead _b_dind _b_dind_indadj_cf {
    capture quietly ttest `__v' = 0 if __industry_tag==1
    if !_rc matrix __p[1,`__j']=r(p)
    local ++__j
}
estadd matrix p=__p, replace
estadd scalar N=`__nind', replace
estadd scalar r2=`__r2', replace
estadd scalar r2_a=`__ar2', replace
est store i_dd
restore
preserve
keep if sample_c_jones==1 & industry_c_jones==1
asreg acc drev gppe indadj_cf dind dind_indadj_cf, by(sic3) minimum(30)
egen byte __industry_tag=tag(sic3)
quietly count if __industry_tag==1
local __nind=r(N)
quietly summarize _R2 if __industry_tag==1
local __r2=r(mean)*100
quietly summarize _adjR2 if __industry_tag==1
local __ar2=r(mean)*100
estpost summarize _b_cons _b_drev _b_gppe _b_indadj_cf _b_dind _b_dind_indadj_cf if __industry_tag==1
matrix __p=e(mean)
local __j=1
foreach __v of varlist _b_cons _b_drev _b_gppe _b_indadj_cf _b_dind _b_dind_indadj_cf {
    capture quietly ttest `__v' = 0 if __industry_tag==1
    if !_rc matrix __p[1,`__j']=r(p)
    local ++__j
}
estadd matrix p=__p, replace
estadd scalar N=`__nind', replace
estadd scalar r2=`__r2', replace
estadd scalar r2_a=`__ar2', replace
est store i_jones
restore
esttab i_cf i_dd i_jones using "tables/table3_panelC_industry.md", main(mean) aux(p 3) starlevels(* 0.1 ** 0.05 *** 0.01) noobs stats(N r2 r2_a, labels("Industry regressions" "Mean R-squared (%)" "Mean adjusted R-squared (%)") fmt(0 3 3)) coeflabels(_b_cf "CF_t" _b_cf_lag "CF_{t-1}" _b_cf_lead "CF_{t+1}" _b_cons "Intercept" _b_dind "DIND_t" _b_dind_indadj_cf "DIND_t x INDADJ_CF_t" _b_drev "DeltaREV_t" _b_gppe "GPPE_t" _b_indadj_cf "INDADJ_CF_t") addnotes("R-squared and adjusted R-squared are percent.") replace label
esttab i_cf i_dd i_jones using "tables/table3_panelC_industry.rtf", main(mean) aux(p 3) starlevels(* 0.1 ** 0.05 *** 0.01) noobs stats(N r2 r2_a, labels("Industry regressions" "Mean R-squared (%)" "Mean adjusted R-squared (%)") fmt(0 3 3)) coeflabels(_b_cf "CF_t" _b_cf_lag "CF_{t-1}" _b_cf_lead "CF_{t+1}" _b_cons "Intercept" _b_dind "DIND_t" _b_dind_indadj_cf "DIND_t x INDADJ_CF_t" _b_drev "DeltaREV_t" _b_gppe "GPPE_t" _b_indadj_cf "INDADJ_CF_t") addnotes("R-squared and adjusted R-squared are percent.") replace label
esttab i_cf i_dd i_jones using "tables/table3_panelC_industry.csv", main(mean) aux(p 3) starlevels(* 0.1 ** 0.05 *** 0.01) noobs stats(N r2 r2_a, labels("Industry regressions" "Mean R-squared (%)" "Mean adjusted R-squared (%)") fmt(0 3 3)) coeflabels(_b_cf "CF_t" _b_cf_lag "CF_{t-1}" _b_cf_lead "CF_{t+1}" _b_cons "Intercept" _b_dind "DIND_t" _b_dind_indadj_cf "DIND_t x INDADJ_CF_t" _b_drev "DeltaREV_t" _b_gppe "GPPE_t" _b_indadj_cf "INDADJ_CF_t") addnotes("R-squared and adjusted R-squared are percent.") replace label
esttab i_cf i_dd i_jones using "tables/table3_panelC_industry.tex", main(mean) aux(p 3) starlevels(* 0.1 ** 0.05 *** 0.01) noobs stats(N r2 r2_a, labels("Industry regressions" "Mean R-squared (%)" "Mean adjusted R-squared (%)") fmt(0 3 3)) coeflabels(_b_cf "CF_t" _b_cf_lag "CF_{t-1}" _b_cf_lead "CF_{t+1}" _b_cons "Intercept" _b_dind "DIND_t" _b_dind_indadj_cf "DIND_t x INDADJ_CF_t" _b_drev "DeltaREV_t" _b_gppe "GPPE_t" _b_indadj_cf "INDADJ_CF_t") addnotes("R-squared and adjusted R-squared are percent.") replace label
est clear
exit, clear
