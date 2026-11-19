version 18
set more off
global y "y_h1"
global x "e_rate"
global d "dp"
global cl "firm_id fyear"
use "reg.dta", clear
egen long firm_id = group(gvkey)
label variable dp "Regular dividend indicator"
label variable e_rate "Current adjusted earnings / lagged assets"
label variable y_h1 "One-year-ahead earnings / lagged assets"
label variable y_h2 "Two-year-ahead earnings / lagged assets"
gen double dp_e = dp*e_rate
label variable dp_e "DP x current earnings rate"
est clear
reghdfe $y c.$x##i.$d if use_h1==1 & fyear>=1994 & fyear<=2005, vce(cluster $cl) noabsorb
est store m1
esttab m1 using "tables/table4_panelA_h1_1994.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1994-2005") addnotes("Two-way cluster-robust SE by firm and fiscal year; no fixed effects." "Template parentheses report p-values; source parentheses are standard errors.")
esttab m1 using "tables/table4_panelA_h1_1994.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1994-2005") addnotes("Two-way cluster-robust SE by firm and fiscal year; no fixed effects." "Template parentheses report p-values; source parentheses are standard errors.")
esttab m1 using "tables/table4_panelA_h1_1994.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1994-2005") addnotes("Two-way cluster-robust SE by firm and fiscal year; no fixed effects." "Template parentheses report p-values; source parentheses are standard errors.")
esttab m1 using "tables/table4_panelA_h1_1994.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1994-2005") addnotes("Two-way cluster-robust SE by firm and fiscal year; no fixed effects." "Template parentheses report p-values; source parentheses are standard errors.")
est clear
exit, clear
