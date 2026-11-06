version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"

global vars "acq_car synergy delta_roa trg_comprnk acq_size acq_lev acq_tobin_dum acq_roa acq_fcf acq_q_fcf trg_size trg_lev trg_tobin trg_roa stock_corr sync block all_cash all_stock tender_d hostile diffind rel_size"
use "data/us_acquisitions_1307/reg.dta", clear
est clear
estpost tabstat $vars, statistics(n mean sd p25 p50 p75) columns(statistics)
esttab using "tables/table3_descriptive.md", replace cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label
esttab using "tables/table3_descriptive.rtf", replace cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label
esttab using "tables/table3_descriptive.csv", replace cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label
esttab using "tables/table3_descriptive.tex", replace cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label
est clear
exit, clear
