version 18
set more off
use "data/icw_loan_facilities/reg.dta", clear

global rhs "uncorrected corrected inst_investor revolver financial_covenants loan_size maturity credit_rating num_lenders pp_indicator firm_size profitability leverage"
global fe "i.loan_year"
est clear
regress interest_rate $rhs $fe, vce(cluster firmid)
tempvar clustertag
egen byte `clustertag'=tag(firmid) if e(sample)
quietly count if `clustertag'==1
local nclusters=r(N)
estadd scalar nclusters=`nclusters'
est store m1
esttab m1 using "tables/table4_interest_rate.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("nclusters Borrower clusters") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
esttab m1 using "tables/table4_interest_rate.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("nclusters Borrower clusters") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
esttab m1 using "tables/table4_interest_rate.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("nclusters Borrower clusters") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
esttab m1 using "tables/table4_interest_rate.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("nclusters Borrower clusters") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
est clear
exit, clear
