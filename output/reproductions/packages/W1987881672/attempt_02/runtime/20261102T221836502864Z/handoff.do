version 18
set more off
adopath ++ "historical artifact ado"
which esttab
import sas using "data/ibes_surprises/ibes_surprises.sas7bdat", clear
assert _N > 0
isid fiscal_year
save "data/ibes_surprises/reg.dta", replace
exit, clear
