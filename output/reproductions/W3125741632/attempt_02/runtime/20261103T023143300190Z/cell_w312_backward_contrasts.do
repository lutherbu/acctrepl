version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/basu_mtb/reg.dta", clear
label variable mtbrank "MTB quintile rank (1–5)"
generate double mdr_b0 = mtbrank*d_b0
generate double mr_b0 = mtbrank*r_b0
generate double rdr_b0 = r_b0*d_b0
generate double mrdr_b0 = mtbrank*r_b0*d_b0
generate double mdr_b1 = mtbrank*d_b1
generate double mr_b1 = mtbrank*r_b1
generate double rdr_b1 = r_b1*d_b1
generate double mrdr_b1 = mtbrank*r_b1*d_b1
generate double mdr_b2 = mtbrank*d_b2
generate double mr_b2 = mtbrank*r_b2
generate double rdr_b2 = r_b2*d_b2
generate double mrdr_b2 = mtbrank*r_b2*d_b2
generate double mdr_b3 = mtbrank*d_b3
generate double mr_b3 = mtbrank*r_b3
generate double rdr_b3 = r_b3*d_b3
generate double mrdr_b3 = mtbrank*r_b3*d_b3
generate double mdr_b4 = mtbrank*d_b4
generate double mr_b4 = mtbrank*r_b4
generate double rdr_b4 = r_b4*d_b4
generate double mrdr_b4 = mtbrank*r_b4*d_b4
asreg y_b0 mtbrank d_b0 mdr_b0 r_b0 mr_b0 rdr_b0 mrdr_b0, by(fyear)
rename _b_mr_b0 b1_j0
rename _b_mrdr_b0 g1_j0
drop _b_* _Nobs _R2 _adjR2
asreg y_b1 mtbrank d_b1 mdr_b1 r_b1 mr_b1 rdr_b1 mrdr_b1, by(fyear)
rename _b_mr_b1 b1_j1
rename _b_mrdr_b1 g1_j1
drop _b_* _Nobs _R2 _adjR2
asreg y_b2 mtbrank d_b2 mdr_b2 r_b2 mr_b2 rdr_b2 mrdr_b2, by(fyear)
rename _b_mr_b2 b1_j2
rename _b_mrdr_b2 g1_j2
drop _b_* _Nobs _R2 _adjR2
asreg y_b3 mtbrank d_b3 mdr_b3 r_b3 mr_b3 rdr_b3 mrdr_b3, by(fyear)
rename _b_mr_b3 b1_j3
rename _b_mrdr_b3 g1_j3
drop _b_* _Nobs _R2 _adjR2
asreg y_b4 mtbrank d_b4 mdr_b4 r_b4 mr_b4 rdr_b4 mrdr_b4, by(fyear)
rename _b_mr_b4 b1_j4
rename _b_mrdr_b4 g1_j4
drop _b_* _Nobs _R2 _adjR2
bysort fyear: keep if _n==1
count
summarize b1_j0 b1_j1 b1_j2 b1_j3 b1_j4 g1_j0 g1_j1 g1_j2 g1_j3 g1_j4
display as text "Compare annual asreg mean coefficients above to the matching xtfmb tables in cell_w312_backward.log."
generate double diff_b1_j1j0 = b1_j1-b1_j0
generate double diff_g1_j1j0 = g1_j1-g1_j0
generate double diff_bad_j1j0 = (b1_j1+g1_j1)-(b1_j0+g1_j0)
generate double diff_b1_j2j1 = b1_j2-b1_j1
generate double diff_g1_j2j1 = g1_j2-g1_j1
generate double diff_bad_j2j1 = (b1_j2+g1_j2)-(b1_j1+g1_j1)
generate double diff_b1_j3j2 = b1_j3-b1_j2
generate double diff_g1_j3j2 = g1_j3-g1_j2
generate double diff_bad_j3j2 = (b1_j3+g1_j3)-(b1_j2+g1_j2)
generate double diff_b1_j4j3 = b1_j4-b1_j3
generate double diff_g1_j4j3 = g1_j4-g1_j3
generate double diff_bad_j4j3 = (b1_j4+g1_j4)-(b1_j3+g1_j3)
label variable diff_b1_j1j0 "Mean annual b1 change, j=1−0"
label variable diff_g1_j1j0 "Mean annual g1 change, j=1−0"
label variable diff_bad_j1j0 "Mean annual (b1+g1) change, j=1−0"
label variable diff_b1_j2j1 "Mean annual b1 change, j=2−1"
label variable diff_g1_j2j1 "Mean annual g1 change, j=2−1"
label variable diff_bad_j2j1 "Mean annual (b1+g1) change, j=2−1"
label variable diff_b1_j3j2 "Mean annual b1 change, j=3−2"
label variable diff_g1_j3j2 "Mean annual g1 change, j=3−2"
label variable diff_bad_j3j2 "Mean annual (b1+g1) change, j=3−2"
label variable diff_b1_j4j3 "Mean annual b1 change, j=4−3"
label variable diff_g1_j4j3 "Mean annual g1 change, j=4−3"
label variable diff_bad_j4j3 "Mean annual (b1+g1) change, j=4−3"
est clear
regress diff_b1_j1j0
est store c1
regress diff_g1_j1j0
est store c2
regress diff_bad_j1j0
est store c3
regress diff_b1_j2j1
est store c4
regress diff_g1_j2j1
est store c5
regress diff_bad_j2j1
est store c6
regress diff_b1_j3j2
est store c7
regress diff_g1_j3j2
est store c8
regress diff_bad_j3j2
est store c9
regress diff_b1_j4j3
est store c10
regress diff_g1_j4j3
est store c11
regress diff_bad_j4j3
est store c12
esttab c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 using "tables/table5a_backward_contrasts.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label coeflabels(_cons "Mean annual coefficient change") mtitle("b1 j1−0" "g1 j1−0" "b1+g1 j1−0" "b1 j2−1" "g1 j2−1" "b1+g1 j2−1" "b1 j3−2" "g1 j3−2" "b1+g1 j3−2" "b1 j4−3" "g1 j4−3" "b1+g1 j4−3") addnotes("Paired annual Fama–MacBeth coefficient differences; 28 common formation years. asreg annual mean coefficients are shown in the Stata log and checked against the baseline xtfmb estimates.")
esttab c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 using "tables/table5a_backward_contrasts.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label coeflabels(_cons "Mean annual coefficient change") mtitle("b1 j1−0" "g1 j1−0" "b1+g1 j1−0" "b1 j2−1" "g1 j2−1" "b1+g1 j2−1" "b1 j3−2" "g1 j3−2" "b1+g1 j3−2" "b1 j4−3" "g1 j4−3" "b1+g1 j4−3") addnotes("Paired annual Fama–MacBeth coefficient differences; 28 common formation years. asreg annual mean coefficients are shown in the Stata log and checked against the baseline xtfmb estimates.")
esttab c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 using "tables/table5a_backward_contrasts.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label coeflabels(_cons "Mean annual coefficient change") mtitle("b1 j1−0" "g1 j1−0" "b1+g1 j1−0" "b1 j2−1" "g1 j2−1" "b1+g1 j2−1" "b1 j3−2" "g1 j3−2" "b1+g1 j3−2" "b1 j4−3" "g1 j4−3" "b1+g1 j4−3") addnotes("Paired annual Fama–MacBeth coefficient differences; 28 common formation years. asreg annual mean coefficients are shown in the Stata log and checked against the baseline xtfmb estimates.")
esttab c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 using "tables/table5a_backward_contrasts.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label coeflabels(_cons "Mean annual coefficient change") mtitle("b1 j1−0" "g1 j1−0" "b1+g1 j1−0" "b1 j2−1" "g1 j2−1" "b1+g1 j2−1" "b1 j3−2" "g1 j3−2" "b1+g1 j3−2" "b1 j4−3" "g1 j4−3" "b1+g1 j4−3") addnotes("Paired annual Fama–MacBeth coefficient differences; 28 common formation years. asreg annual mean coefficients are shown in the Stata log and checked against the baseline xtfmb estimates.")
est clear
exit, clear
