version 18
set more off
set linesize 120
adopath ++ "/home/luther/Dropbox/Research/Replication/git/output/reproduction_runs/ado"
use "data/full_sample/reg.dta", clear

global y "cfo3_w"
global x "pf_w total_w sales_w accr_w"
global sample "ok_ct3"
global nwlag "11"

preserve
asreg $y $x if $sample==1, by(fmb_q)
collapse (mean) _adjR2, by(fmb_q)
summarize _adjR2, meanonly
local avg_adj_r2 = r(mean)
local adj_r2_periods = r(N)
restore

* One report per firm/calendar quarter; retain the firm panel identifier.
egen long firmid = group(gvkey)
xtset firmid fmb_q
est clear
quietly xtfmb $y $x if $sample==1, lag($nwlag)
estadd scalar r2_a = `avg_adj_r2'
estadd scalar adj_periods = `adj_r2_periods'
est store m1

esttab m1 using "tables/cfo_total_cfo_sum3.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars("N_g Quarterly periods" "adj_periods Periods with adjusted R2") addnotes("Adjusted R-squared is the equal-weight mean of quarterly OLS adjusted R-squared values from asreg.") replace label
esttab m1 using "tables/cfo_total_cfo_sum3.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars("N_g Quarterly periods" "adj_periods Periods with adjusted R2") addnotes("Adjusted R-squared is the equal-weight mean of quarterly OLS adjusted R-squared values from asreg.") replace label
esttab m1 using "tables/cfo_total_cfo_sum3.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars("N_g Quarterly periods" "adj_periods Periods with adjusted R2") addnotes("Adjusted R-squared is the equal-weight mean of quarterly OLS adjusted R-squared values from asreg.") replace label
esttab m1 using "tables/cfo_total_cfo_sum3.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars("N_g Quarterly periods" "adj_periods Periods with adjusted R2") addnotes("Adjusted R-squared is the equal-weight mean of quarterly OLS adjusted R-squared values from asreg.") replace label
est clear
exit, clear
