version 18
set more off
use "data/dd_firm_years/reg.dta", clear
global rhs "time t_eq t_frev2a t_ret2 t_nanal t_inst t_cfo_tp1 t_cfo_tm1 t_vcfo eq_lag frev2a_lag ret2_lag nanal_lag inst_lag cfo_tp1 cfo_tm1 vcfo_lag bm size lev ret"
egen long firmid = group(gvkey)
xtset firmid fyear
misstable summarize var_ffadj $rhs
ivreg2 var_ffadj $rhs, robust bw(4) kernel(bartlett)
estadd local inference "Linear exact-ID GMM-equivalent; panel Bartlett HAC, 3 lags"
est store m1
summarize var_ffadj $rhs if e(sample)
tabulate fyear if e(sample)
esttab m1 using "tables/table3_dd.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label stats(N r2 r2_a inference, labels("Observations" "R-squared" "Adjusted R-squared" "Inference"))
esttab m1 using "tables/table3_dd.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label stats(N r2 r2_a inference, labels("Observations" "R-squared" "Adjusted R-squared" "Inference"))
esttab m1 using "tables/table3_dd.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label stats(N r2 r2_a inference, labels("Observations" "R-squared" "Adjusted R-squared" "Inference"))
esttab m1 using "tables/table3_dd.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label stats(N r2 r2_a inference, labels("Observations" "R-squared" "Adjusted R-squared" "Inference"))
est clear
exit, clear
