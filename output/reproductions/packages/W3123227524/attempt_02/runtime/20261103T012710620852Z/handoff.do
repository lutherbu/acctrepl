version 18
set more off
adopath ++ "historical artifact ado"
which esttab
which estpost
which estadd
import sas using "data/seo_earnings_mgmt.sas7bdat", clear
assert _N > 0
isid MASTER_DEAL_NO
save "data/seo_earnings_mgmt/reg.dta", replace
exit, clear
