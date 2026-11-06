version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
global forward_y "y_f1 y_f2 y_f3"
global forward_d "d_f1 d_f2 d_f3"
global forward_r "r_f1 r_f2 r_f3"
use "data/basu_mtb/reg.dta", clear
summarize mtb y_f1 y_f2 y_f3 r_f1 r_f2 r_f3 y_b0 y_b1 y_b2 y_b3 y_b4 r_b0 r_b1 r_b2 r_b3 r_b4, detail
encode gvkey, gen(firm_id)
xtset firm_id fyear
label variable mtbrank "MTB quintile rank (1–5)"
est clear
forvalues i=1/3 {
    local y : word `i' of $forward_y
    local d : word `i' of $forward_d
    local r : word `i' of $forward_r
    capture drop dr ret mdr mr rdr mrdr
    generate double dr = `d'
    generate double ret = `r'
    generate double mdr = mtbrank*dr
    generate double mr = mtbrank*ret
    generate double rdr = ret*dr
    generate double mrdr = mtbrank*ret*dr
    label variable dr "Negative-return indicator"
    label variable mdr "MTB rank × DR"
    label variable ret "Buy-and-hold return"
    label variable mr "MTB rank × return"
    label variable rdr "Return × DR"
    label variable mrdr "MTB rank × return × DR"
    local fullrank = 0
    forvalues yr=1972/1999 {
        regress `y' mtbrank dr mdr ret mr rdr mrdr if fyear==`yr'
        display as text "ANNUAL_RANK forward_k`i' year=`yr' " as result "N=" %8.0f e(N) " rank=" %2.0f e(rank) " residual_df=" %8.0f e(df_r)
        if e(rank)==8 local ++fullrank
    }
    display as text "FULL_RANK_YEARS forward_k`i'=" as result %2.0f `fullrank'
    xtfmb `y' mtbrank dr mdr ret mr rdr mrdr
    display as text "FMB forward_k`i' total_N=" as result %9.0f e(N) " years=" %2.0f e(N_g) " average_annual_R2_decimal=" %7.4f e(r2)
    lincom mrdr
    lincom mr + mrdr
    est store f`i'
}
esttab f1 f2 f3 using "tables/table4a_forward.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label addnotes("Fama–MacBeth means of annual OLS coefficients, 1972–1999. P-values are two-sided. R-squared is average annual first-stage R-squared in decimal units; adjusted R-squared is unavailable from xtfmb.")
esttab f1 f2 f3 using "tables/table4a_forward.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label addnotes("Fama–MacBeth means of annual OLS coefficients, 1972–1999. P-values are two-sided. R-squared is average annual first-stage R-squared in decimal units; adjusted R-squared is unavailable from xtfmb.")
esttab f1 f2 f3 using "tables/table4a_forward.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label addnotes("Fama–MacBeth means of annual OLS coefficients, 1972–1999. P-values are two-sided. R-squared is average annual first-stage R-squared in decimal units; adjusted R-squared is unavailable from xtfmb.")
esttab f1 f2 f3 using "tables/table4a_forward.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label addnotes("Fama–MacBeth means of annual OLS coefficients, 1972–1999. P-values are two-sided. R-squared is average annual first-stage R-squared in decimal units; adjusted R-squared is unavailable from xtfmb.")
est clear
exit, clear
