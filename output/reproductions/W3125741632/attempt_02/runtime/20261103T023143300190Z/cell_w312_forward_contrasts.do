version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/basu_mtb/reg.dta", clear
label variable mtbrank "MTB quintile rank (1–5)"
generate double mdr_f1 = mtbrank*d_f1
generate double mr_f1 = mtbrank*r_f1
generate double rdr_f1 = r_f1*d_f1
generate double mrdr_f1 = mtbrank*r_f1*d_f1
generate double mdr_f2 = mtbrank*d_f2
generate double mr_f2 = mtbrank*r_f2
generate double rdr_f2 = r_f2*d_f2
generate double mrdr_f2 = mtbrank*r_f2*d_f2
generate double mdr_f3 = mtbrank*d_f3
generate double mr_f3 = mtbrank*r_f3
generate double rdr_f3 = r_f3*d_f3
generate double mrdr_f3 = mtbrank*r_f3*d_f3
asreg y_f1 mtbrank d_f1 mdr_f1 r_f1 mr_f1 rdr_f1 mrdr_f1, by(fyear)
rename _b_mr_f1 b1_k1
rename _b_mrdr_f1 g1_k1
drop _b_* _Nobs _R2 _adjR2
asreg y_f2 mtbrank d_f2 mdr_f2 r_f2 mr_f2 rdr_f2 mrdr_f2, by(fyear)
rename _b_mr_f2 b1_k2
rename _b_mrdr_f2 g1_k2
drop _b_* _Nobs _R2 _adjR2
asreg y_f3 mtbrank d_f3 mdr_f3 r_f3 mr_f3 rdr_f3 mrdr_f3, by(fyear)
rename _b_mr_f3 b1_k3
rename _b_mrdr_f3 g1_k3
drop _b_* _Nobs _R2 _adjR2
bysort fyear: keep if _n==1
count
summarize b1_k1 b1_k2 b1_k3 g1_k1 g1_k2 g1_k3
display as text "Compare annual asreg mean coefficients above to the matching xtfmb tables in cell_w312_forward.log."
generate double diff_b1_k2k1 = b1_k2-b1_k1
generate double diff_g1_k2k1 = g1_k2-g1_k1
generate double diff_bad_k2k1 = (b1_k2+g1_k2)-(b1_k1+g1_k1)
generate double diff_b1_k3k2 = b1_k3-b1_k2
generate double diff_g1_k3k2 = g1_k3-g1_k2
generate double diff_bad_k3k2 = (b1_k3+g1_k3)-(b1_k2+g1_k2)
label variable diff_b1_k2k1 "Mean annual b1 change, k=2−1"
label variable diff_g1_k2k1 "Mean annual g1 change, k=2−1"
label variable diff_bad_k2k1 "Mean annual (b1+g1) change, k=2−1"
label variable diff_b1_k3k2 "Mean annual b1 change, k=3−2"
label variable diff_g1_k3k2 "Mean annual g1 change, k=3−2"
label variable diff_bad_k3k2 "Mean annual (b1+g1) change, k=3−2"
est clear
regress diff_b1_k2k1
est store c1
regress diff_g1_k2k1
est store c2
regress diff_bad_k2k1
est store c3
regress diff_b1_k3k2
est store c4
regress diff_g1_k3k2
est store c5
regress diff_bad_k3k2
est store c6
esttab c1 c2 c3 c4 c5 c6 using "tables/table4a_forward_contrasts.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label coeflabels(_cons "Mean annual coefficient change") mtitle("b1 k2−1" "g1 k2−1" "b1+g1 k2−1" "b1 k3−2" "g1 k3−2" "b1+g1 k3−2") addnotes("Paired annual Fama–MacBeth coefficient differences; 28 common formation years. asreg annual mean coefficients are shown in the Stata log and checked against the baseline xtfmb estimates.")
esttab c1 c2 c3 c4 c5 c6 using "tables/table4a_forward_contrasts.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label coeflabels(_cons "Mean annual coefficient change") mtitle("b1 k2−1" "g1 k2−1" "b1+g1 k2−1" "b1 k3−2" "g1 k3−2" "b1+g1 k3−2") addnotes("Paired annual Fama–MacBeth coefficient differences; 28 common formation years. asreg annual mean coefficients are shown in the Stata log and checked against the baseline xtfmb estimates.")
esttab c1 c2 c3 c4 c5 c6 using "tables/table4a_forward_contrasts.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label coeflabels(_cons "Mean annual coefficient change") mtitle("b1 k2−1" "g1 k2−1" "b1+g1 k2−1" "b1 k3−2" "g1 k3−2" "b1+g1 k3−2") addnotes("Paired annual Fama–MacBeth coefficient differences; 28 common formation years. asreg annual mean coefficients are shown in the Stata log and checked against the baseline xtfmb estimates.")
esttab c1 c2 c3 c4 c5 c6 using "tables/table4a_forward_contrasts.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label coeflabels(_cons "Mean annual coefficient change") mtitle("b1 k2−1" "g1 k2−1" "b1+g1 k2−1" "b1 k3−2" "g1 k3−2" "b1+g1 k3−2") addnotes("Paired annual Fama–MacBeth coefficient differences; 28 common formation years. asreg annual mean coefficients are shown in the Stata log and checked against the baseline xtfmb estimates.")
est clear
exit, clear
