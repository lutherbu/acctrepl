version 18
set more off
use "data/icw_loan_facilities/reg.dta", clear

gen double loan_size_usd_m=exp(loan_size) if !missing(loan_size)
label var loan_size_usd_m "Loan Size (USD millions)"
gen double assets_usd_m=exp(firm_size) if !missing(firm_size)
label var assets_usd_m "Firm Size (USD millions)"

global descvars "interest_rate financial_covenants general_covenants num_lenders loan_size_usd_m maturity pp_indicator secured assets_usd_m credit_rating profitability leverage tangibility"
est clear
estpost tabstat $descvars, stat(n mean sd p25 p50 p75) c(s)
esttab using "tables/descriptive_statistics.md", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") replace label addnotes("Main complete-case facility population; PP Ratio uses the separate rated pre/post sample.")
esttab using "tables/descriptive_statistics.rtf", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") replace label addnotes("Main complete-case facility population; PP Ratio uses the separate rated pre/post sample.")
esttab using "tables/descriptive_statistics.csv", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") replace label addnotes("Main complete-case facility population; PP Ratio uses the separate rated pre/post sample.")
esttab using "tables/descriptive_statistics.tex", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") replace label addnotes("Main complete-case facility population; PP Ratio uses the separate rated pre/post sample.")
est clear
exit, clear
