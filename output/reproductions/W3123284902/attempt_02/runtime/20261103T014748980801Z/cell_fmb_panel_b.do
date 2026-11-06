version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"

global y "ret"
global x "lnsize lnbm retm1 ret12_2 ret36_13"
global acc "accr2"
global noa "noa2"
global elig "fit_b"

use "data/noa_firm_month/reg.dta", clear
format mdate %tm
tsset firmid mdate

est clear
xtfmb $y $x $acc $noa if $elig==1
estadd scalar fmb_months = e(N_g)
est store m_b
esttab m_b using "tables/table5_panel_b_model4.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N fmb_months r2, fmt(0 0 3) labels("Firm-month observations" "FMB months" "Average monthly R-squared")) r2 ar2 replace label mtitles("Panel B: 2-year lag")
esttab m_b using "tables/table5_panel_b_model4.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N fmb_months r2, fmt(0 0 3) labels("Firm-month observations" "FMB months" "Average monthly R-squared")) r2 ar2 replace label mtitles("Panel B: 2-year lag")
esttab m_b using "tables/table5_panel_b_model4.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N fmb_months r2, fmt(0 0 3) labels("Firm-month observations" "FMB months" "Average monthly R-squared")) r2 ar2 replace label mtitles("Panel B: 2-year lag")
esttab m_b using "tables/table5_panel_b_model4.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N fmb_months r2, fmt(0 0 3) labels("Firm-month observations" "FMB months" "Average monthly R-squared")) r2 ar2 replace label mtitles("Panel B: 2-year lag")
est clear
exit, clear
