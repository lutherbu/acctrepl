adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
clear
use "@@ACCTREPL_WORK@@/1_Responsible_Sourcing/Smelters/Export/smelters.dta"

egen sid = group(Entity_ID)
egen nyid = group(Country_Location year)


/* Table 3 Panel B */

reghdfe sum_sec_issuers conflict_free, absorb(nyid sid) vce(cluster sid)
outreg2 using Table_3, replace excel tstat dec(3) tdec(2) nocons adjr2

reghdfe chg_sum_sec_issuers chg_conflict_free, absorb(nyid sid) vce(cluster sid)
outreg2 using Table_3, append excel tstat dec(3) tdec(2) nocons adjr2

