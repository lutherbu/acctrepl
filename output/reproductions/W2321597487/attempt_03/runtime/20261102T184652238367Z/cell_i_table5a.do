version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear
est clear
preserve
keep if sample_t5a_cf==1 & industry_t5a_cf==1
asreg acc cf abnret dcf dcf_cf dabnret dabnret_abnret, by(sic3) minimum(30)
egen byte __industry_tag=tag(sic3)
quietly count if __industry_tag==1
local __nind=r(N)
quietly summarize _R2 if __industry_tag==1
local __r2=r(mean)*100
quietly summarize _adjR2 if __industry_tag==1
local __ar2=r(mean)*100
estpost summarize _b_cons _b_cf _b_abnret _b_dcf _b_dcf_cf _b_dabnret _b_dabnret_abnret if __industry_tag==1
matrix __p=e(mean)
local __j=1
foreach __v of varlist _b_cons _b_cf _b_abnret _b_dcf _b_dcf_cf _b_dabnret _b_dabnret_abnret {
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
keep if sample_t5a_dd==1 & industry_t5a_dd==1
asreg acc cf cf_lag cf_lead abnret dcf dcf_cf dabnret dabnret_abnret, by(sic3) minimum(30)
egen byte __industry_tag=tag(sic3)
quietly count if __industry_tag==1
local __nind=r(N)
quietly summarize _R2 if __industry_tag==1
local __r2=r(mean)*100
quietly summarize _adjR2 if __industry_tag==1
local __ar2=r(mean)*100
estpost summarize _b_cons _b_cf _b_cf_lag _b_cf_lead _b_abnret _b_dcf _b_dcf_cf _b_dabnret _b_dabnret_abnret if __industry_tag==1
matrix __p=e(mean)
local __j=1
foreach __v of varlist _b_cons _b_cf _b_cf_lag _b_cf_lead _b_abnret _b_dcf _b_dcf_cf _b_dabnret _b_dabnret_abnret {
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
keep if sample_t5a_jones==1 & industry_t5a_jones==1
asreg acc cf drev gppe abnret dcf dcf_cf dabnret dabnret_abnret, by(sic3) minimum(30)
egen byte __industry_tag=tag(sic3)
quietly count if __industry_tag==1
local __nind=r(N)
quietly summarize _R2 if __industry_tag==1
local __r2=r(mean)*100
quietly summarize _adjR2 if __industry_tag==1
local __ar2=r(mean)*100
estpost summarize _b_cons _b_cf _b_drev _b_gppe _b_abnret _b_dcf _b_dcf_cf _b_dabnret _b_dabnret_abnret if __industry_tag==1
matrix __p=e(mean)
local __j=1
foreach __v of varlist _b_cons _b_cf _b_drev _b_gppe _b_abnret _b_dcf _b_dcf_cf _b_dabnret _b_dabnret_abnret {
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
esttab i_cf i_dd i_jones using "tables/table5_panelA_industry.md", main(mean) aux(p 3) starlevels(* 0.1 ** 0.05 *** 0.01) noobs stats(N r2 r2_a, labels("Industry regressions" "Mean R-squared (%)" "Mean adjusted R-squared (%)") fmt(0 3 3)) coeflabels(_b_abnret "ABNRET_t" _b_cf "CF_t" _b_cf_lag "CF_{t-1}" _b_cf_lead "CF_{t+1}" _b_cons "Intercept" _b_dabnret "DABNRET_t" _b_dabnret_abnret "DABNRET_t x ABNRET_t" _b_dcf "DCF_t" _b_dcf_cf "DCF_t x CF_t" _b_drev "DeltaREV_t" _b_gppe "GPPE_t") addnotes("R-squared and adjusted R-squared are percent.") replace label
esttab i_cf i_dd i_jones using "tables/table5_panelA_industry.rtf", main(mean) aux(p 3) starlevels(* 0.1 ** 0.05 *** 0.01) noobs stats(N r2 r2_a, labels("Industry regressions" "Mean R-squared (%)" "Mean adjusted R-squared (%)") fmt(0 3 3)) coeflabels(_b_abnret "ABNRET_t" _b_cf "CF_t" _b_cf_lag "CF_{t-1}" _b_cf_lead "CF_{t+1}" _b_cons "Intercept" _b_dabnret "DABNRET_t" _b_dabnret_abnret "DABNRET_t x ABNRET_t" _b_dcf "DCF_t" _b_dcf_cf "DCF_t x CF_t" _b_drev "DeltaREV_t" _b_gppe "GPPE_t") addnotes("R-squared and adjusted R-squared are percent.") replace label
esttab i_cf i_dd i_jones using "tables/table5_panelA_industry.csv", main(mean) aux(p 3) starlevels(* 0.1 ** 0.05 *** 0.01) noobs stats(N r2 r2_a, labels("Industry regressions" "Mean R-squared (%)" "Mean adjusted R-squared (%)") fmt(0 3 3)) coeflabels(_b_abnret "ABNRET_t" _b_cf "CF_t" _b_cf_lag "CF_{t-1}" _b_cf_lead "CF_{t+1}" _b_cons "Intercept" _b_dabnret "DABNRET_t" _b_dabnret_abnret "DABNRET_t x ABNRET_t" _b_dcf "DCF_t" _b_dcf_cf "DCF_t x CF_t" _b_drev "DeltaREV_t" _b_gppe "GPPE_t") addnotes("R-squared and adjusted R-squared are percent.") replace label
esttab i_cf i_dd i_jones using "tables/table5_panelA_industry.tex", main(mean) aux(p 3) starlevels(* 0.1 ** 0.05 *** 0.01) noobs stats(N r2 r2_a, labels("Industry regressions" "Mean R-squared (%)" "Mean adjusted R-squared (%)") fmt(0 3 3)) coeflabels(_b_abnret "ABNRET_t" _b_cf "CF_t" _b_cf_lag "CF_{t-1}" _b_cf_lead "CF_{t+1}" _b_cons "Intercept" _b_dabnret "DABNRET_t" _b_dabnret_abnret "DABNRET_t x ABNRET_t" _b_dcf "DCF_t" _b_dcf_cf "DCF_t x CF_t" _b_drev "DeltaREV_t" _b_gppe "GPPE_t") addnotes("R-squared and adjusted R-squared are percent.") replace label
est clear
exit, clear
