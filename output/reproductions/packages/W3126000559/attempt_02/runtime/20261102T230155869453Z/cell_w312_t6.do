version 18
set more off
use "data/icw_pp_ratio_eligible/reg.dta", clear

global fe "i.loan_year"
global cl "firmid"
est clear
probit pp_ratio uncorrected corrected inst_investor revolver secured loan_size maturity credit_rating num_lenders firm_size profitability leverage $fe, vce(cluster $cl)
tempvar clustertag
egen byte `clustertag'=tag($cl) if e(sample)
quietly count if `clustertag'==1
local nclusters=r(N)
estadd scalar nclusters=`nclusters'
est store m1
esttab m1 using "tables/table6_pp_ratio.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("r2_p Pseudo R-squared" "nclusters Borrower clusters") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
esttab m1 using "tables/table6_pp_ratio.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("r2_p Pseudo R-squared" "nclusters Borrower clusters") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
esttab m1 using "tables/table6_pp_ratio.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("r2_p Pseudo R-squared" "nclusters Borrower clusters") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
esttab m1 using "tables/table6_pp_ratio.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("r2_p Pseudo R-squared" "nclusters Borrower clusters") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
est clear
exit, clear
