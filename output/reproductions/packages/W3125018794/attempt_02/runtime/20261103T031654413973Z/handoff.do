version 18
set more off
adopath ++ "historical artifact ado"
which esttab
which estpost
which estadd
import sas using "data/equity_offerings/equity_offerings.sas7bdat", clear
assert _N > 0
isid offer_id
save "data/equity_offerings/reg.dta", replace
exit, clear
