version 18
set more off
use "data/icw_loan_facilities/reg.dta", clear

global fe "i.loan_year"
global cl "firmid"
est clear
probit secured uncorrected corrected inst_investor revolver loan_size maturity credit_rating num_lenders firm_size profitability leverage tangibility $fe, vce(cluster $cl)
tempvar clustertag1
egen byte `clustertag1'=tag($cl) if e(sample)
quietly count if `clustertag1'==1
local nclusters=r(N)
estadd scalar nclusters=`nclusters'
est store m_sec
regress general_covenants uncorrected corrected inst_investor revolver interest_rate secured loan_size maturity credit_rating num_lenders pp_indicator firm_size profitability leverage $fe, vce(cluster $cl)
tempvar clustertag2
egen byte `clustertag2'=tag($cl) if e(sample)
quietly count if `clustertag2'==1
local nclusters=r(N)
estadd scalar nclusters=`nclusters'
est store m_gen
regress ln_maturity uncorrected corrected inst_investor interest_rate financial_covenants secured loan_size credit_rating credit_rating_sq num_lenders pp_indicator firm_size profitability leverage tangibility $fe, vce(cluster $cl)
tempvar clustertag3
egen byte `clustertag3'=tag($cl) if e(sample)
quietly count if `clustertag3'==1
local nclusters=r(N)
estadd scalar nclusters=`nclusters'
est store m_mat
esttab m_sec m_gen m_mat using "tables/table5_loan_mechanisms.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("r2_p Pseudo R-squared" "nclusters Borrower clusters") mtitles("Secured" "General covenants" "Log maturity") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
esttab m_sec m_gen m_mat using "tables/table5_loan_mechanisms.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("r2_p Pseudo R-squared" "nclusters Borrower clusters") mtitles("Secured" "General covenants" "Log maturity") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
esttab m_sec m_gen m_mat using "tables/table5_loan_mechanisms.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("r2_p Pseudo R-squared" "nclusters Borrower clusters") mtitles("Secured" "General covenants" "Log maturity") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
esttab m_sec m_gen m_mat using "tables/table5_loan_mechanisms.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.loan_year) scalars("r2_p Pseudo R-squared" "nclusters Borrower clusters") mtitles("Secured" "General covenants" "Log maturity") addnotes("Loan-year fixed effects included." "Standard errors clustered by borrower.")
est clear
exit, clear
