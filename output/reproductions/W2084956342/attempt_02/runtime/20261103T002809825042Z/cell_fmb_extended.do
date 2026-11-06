version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/compustat_108617/reg.dta", clear

egen firm_id=group(gvkey)
xtset firm_id year

global dep "roa_tp1"
global rhs "roa_t dcoa ndcol dncoa ndncol dsti dlti ndfinl"
local required_rank=9
levelsof year, local(years)
local full_years ""
local n_full=0
local n_years : word count `years'
local sum_ar2=0
foreach yy of local years {
    regress $dep $rhs if year==`yy'
    local rank=e(rank)
    local residual_df=e(df_r)
    local nobs=e(N)
    display as text "Annual fit `yy': N=`nobs', rank `rank'/9, residual df=`residual_df'."
    if `rank'==`required_rank' & `residual_df'>0 {
        local full_years "`full_years',`yy'"
        local ++n_full
        local sum_ar2=`sum_ar2'+e(r2_a)
    }
    else {
        display as error "Excluding underidentified year `yy': rank `rank', residual df `residual_df'."
    }
}
local yearlist=substr("`full_years'",2,.)
display as text "Full-rank annual OLS fits: `n_full' of `n_years'; required rank=9 and positive residual df."
if `n_full'==0 exit 498
local mean_ar2=`sum_ar2'/`n_full'

xtfmb $dep $rhs if inlist(year,`yearlist')
est store fmb
estadd scalar r2_a=`mean_ar2'

esttab fmb using "tables/table5c_final.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label addnotes("Annual OLS cross-sections summarized by Fama–MacBeth; t=1962–2001 where estimable." "P-values are two-sided under the assigned table template; the paper reports t-statistics only for accrual components.")
esttab fmb using "tables/table5c_final.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label addnotes("Annual OLS cross-sections summarized by Fama–MacBeth; t=1962–2001 where estimable." "P-values are two-sided under the assigned table template; the paper reports t-statistics only for accrual components.")
esttab fmb using "tables/table5c_final.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label addnotes("Annual OLS cross-sections summarized by Fama–MacBeth; t=1962–2001 where estimable." "P-values are two-sided under the assigned table template; the paper reports t-statistics only for accrual components.")
esttab fmb using "tables/table5c_final.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label addnotes("Annual OLS cross-sections summarized by Fama–MacBeth; t=1962–2001 where estimable." "P-values are two-sided under the assigned table template; the paper reports t-statistics only for accrual components.")
est clear
exit, clear
