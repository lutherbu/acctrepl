version 18
set more off

global t1vars "earnings_t opacc_t tacc_t spi_ratio cfo_t cfi_t cff_t fcf_t"
use "data/accrual_persistence_main/reg.dta", clear
keep if table1_sample==1

label var earnings_t "Earnings"
label var opacc_t "Operating accruals"
label var tacc_t "Total accruals"
label var spi_ratio "Special items"
label var cfo_t "CFO"
label var cfi_t "CFI"
label var cff_t "CFF"
label var fcf_t "FCF"

est clear
estpost tabstat $t1vars, stat(N mean sd p25 p50 p75 min max) c(s)
esttab using "tables/table1_actual_sample.md", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") label replace
esttab using "tables/table1_actual_sample.rtf", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") label replace
esttab using "tables/table1_actual_sample.csv", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") label replace
esttab using "tables/table1_actual_sample.tex", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") label replace
est clear
correlate $t1vars
spearman $t1vars
exit, clear
