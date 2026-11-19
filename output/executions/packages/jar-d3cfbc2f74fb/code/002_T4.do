adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
**************************Functional Currency Test
*Import Table 4 data
use "Table 4.dta", clear

*Demean interactions
summarize avgftr l4score
gen ftr_dm=avgftr+.13478
gen l4score_dm=l4score+9.378289
gen ftr_score_dm= ftr_dm*l4score_dm
gen ftr_funcur_dm= ftr_dm* l4foreign_funcur
gen score_funcur_dm= l4score_dm* l4foreign_funcur
gen ftr_score_funcur_dm= ftr_dm* l4score_dm* l4foreign_funcur

*Regression
reg avgfros avgftr l4score l4foreign_funcur ftr_score_dm ftr_funcur_dm score_funcur_dm ///
    ftr_score_funcur_dm avgros l4rd_at l4ads_at l4intan_at l4cash_at l4debt_at l4size i.sic2 i.fyear, ///
    vce(cluster gvkey)

*descriptives
tabstat l4foreign_funcur, stat(n mean p25 median p75 sd) col(stat)
