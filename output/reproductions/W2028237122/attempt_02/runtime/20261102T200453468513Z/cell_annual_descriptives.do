version 18
set more off
use "data/reg.dta", clear
quietly summarize n_firmquarter, meanonly
local fq_total = r(sum)
est clear
estpost summarize n_firmquarter z_loss z_decrease z_surprise
estadd scalar underlying_fq = `fq_total'
esttab using "tables/figure1_annual_descriptives.md", cells("count mean sd min max") stats(underlying_fq, fmt(0) labels("Total firm-quarter observations")) replace label nonumbers noobs
esttab using "tables/figure1_annual_descriptives.rtf", cells("count mean sd min max") stats(underlying_fq, fmt(0) labels("Total firm-quarter observations")) replace label nonumbers noobs
esttab using "tables/figure1_annual_descriptives.csv", cells("count mean sd min max") stats(underlying_fq, fmt(0) labels("Total firm-quarter observations")) replace label nonumbers noobs
esttab using "tables/figure1_annual_descriptives.tex", cells("count mean sd min max") stats(underlying_fq, fmt(0) labels("Total firm-quarter observations")) replace label nonumbers noobs
est clear
exit, clear
