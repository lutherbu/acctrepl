version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear

egen long panel_id = group(gvkey)
xtset panel_id fyear

label variable ab_cfo "Abnormal CFO"
label variable ab_disexp "Abnormal discretionary expenses"
label variable ab_prod "Abnormal production costs"
label variable size "SIZE"
label variable mtb "MTB"
label variable netincome "Net income"
label variable suspect_ni "SUSPECT_NI"

est clear
xtfmb ab_cfo size mtb netincome suspect_ni, lag(1)
est store m_cfo
xtfmb ab_disexp size mtb netincome suspect_ni, lag(1)
est store m_disexp
xtfmb ab_prod size mtb netincome suspect_ni, lag(1)
est store m_prod

esttab m_cfo m_disexp m_prod using "tables/table4_main.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("Abnormal CFO" "Abnormal discretionary expenses" "Abnormal production costs") varlabels(_cons "Intercept" size "SIZE" mtb "MTB" netincome "Net income" suspect_ni "SUSPECT_NI") addnotes("Annual OLS cross-sections combined using Fama-MacBeth; Newey-West HAC lag 1." "N is the aggregate number of complete firm-years; annual counts are not reported in the source.")
esttab m_cfo m_disexp m_prod using "tables/table4_main.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("Abnormal CFO" "Abnormal discretionary expenses" "Abnormal production costs") varlabels(_cons "Intercept" size "SIZE" mtb "MTB" netincome "Net income" suspect_ni "SUSPECT_NI") addnotes("Annual OLS cross-sections combined using Fama-MacBeth; Newey-West HAC lag 1." "N is the aggregate number of complete firm-years; annual counts are not reported in the source.")
esttab m_cfo m_disexp m_prod using "tables/table4_main.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("Abnormal CFO" "Abnormal discretionary expenses" "Abnormal production costs") varlabels(_cons "Intercept" size "SIZE" mtb "MTB" netincome "Net income" suspect_ni "SUSPECT_NI") addnotes("Annual OLS cross-sections combined using Fama-MacBeth; Newey-West HAC lag 1." "N is the aggregate number of complete firm-years; annual counts are not reported in the source.")
esttab m_cfo m_disexp m_prod using "tables/table4_main.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("Abnormal CFO" "Abnormal discretionary expenses" "Abnormal production costs") varlabels(_cons "Intercept" size "SIZE" mtb "MTB" netincome "Net income" suspect_ni "SUSPECT_NI") addnotes("Annual OLS cross-sections combined using Fama-MacBeth; Newey-West HAC lag 1." "N is the aggregate number of complete firm-years; annual counts are not reported in the source.")
est clear
exit, clear
