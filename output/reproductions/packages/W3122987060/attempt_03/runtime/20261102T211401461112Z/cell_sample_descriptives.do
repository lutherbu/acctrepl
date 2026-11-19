version 18
set more off
use "data/main/reg.dta", clear

label variable earn0 "EARN(t)"
label variable cf0 "CF(t)"
label variable accruals "ACCRUALS(t)"
label variable d_ar "Delta AR(t)"
label variable d_inv "Delta INV(t)"
label variable d_ap "Delta AP(t)"
label variable depr "DEPR(t)"
label variable amort "AMORT(t)"
label variable other "OTHER(t)"

est clear
estpost tabstat earn0 cf0 accruals d_ar d_inv d_ap depr amort other, stat(N mean sd p50) c(s)
esttab using "tables/table1_sample_descriptives.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p50(fmt(%9.3f))") label
esttab using "tables/table1_sample_descriptives.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p50(fmt(%9.3f))") label
esttab using "tables/table1_sample_descriptives.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p50(fmt(%9.3f))") label
esttab using "tables/table1_sample_descriptives.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p50(fmt(%9.3f))") label
est clear
exit, clear
