version 18
set more off
adopath ++ "historical artifact ado"
which esttab
which estpost
which estadd
import sas using "data/volatility_panel.sas7bdat", clear
assert _N > 0
isid gvkey fyear
save "data/reg.dta", replace
exit, clear
