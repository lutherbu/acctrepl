version 18
set more off
global y "wwetr"
global x "size pti foroper foroper2 mnc mncsize mncpti"
global loc "africa asia japan middeast europe uk france germany oceania samerica canada mexico"
global ind "indus1 indus2 indus3 indus4 indus5 indus6"
global yr "yr1991 yr1992 yr1993 yr1994 yr1995 yr1996 yr1997"
use "data/mnc_etr_regressions/reg.dta", clear
label variable wwetr "WWETR"
label variable size "SIZE"
label variable pti "PTI"
label variable foroper "FOROPER"
label variable foroper2 "FOROPER^2"
label variable mnc "MNC"
label variable mncsize "MNC x SIZE"
label variable mncpti "MNC x PTI"
label variable africa "AFRICA"
label variable asia "ASIA"
label variable japan "JAPAN"
label variable middeast "MIDDEAST"
label variable europe "EUROPE"
label variable uk "UK"
label variable france "FRANCE"
label variable germany "GERMANY"
label variable oceania "OCEANIA"
label variable samerica "SAMERICA"
label variable canada "CANADA"
label variable mexico "MEXICO"
est clear
regress $y $x $loc $ind $yr if table4==1
est store table4_eq2
esttab table4_eq2 using "tables/table4_col2.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(indus* yr*) varlabels(_cons "Intercept" size "SIZE" pti "PTI" foroper "FOROPER" foroper2 "FOROPER^2" mnc "MNC" mncsize "MNC x SIZE" mncpti "MNC x PTI" africa "AFRICA" asia "ASIA" japan "JAPAN" middeast "MIDDEAST" europe "EUROPE" uk "UK" france "FRANCE" germany "GERMANY" oceania "OCEANIA" samerica "SAMERICA" canada "CANADA" mexico "MEXICO")
esttab table4_eq2 using "tables/table4_col2.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(indus* yr*) varlabels(_cons "Intercept" size "SIZE" pti "PTI" foroper "FOROPER" foroper2 "FOROPER^2" mnc "MNC" mncsize "MNC x SIZE" mncpti "MNC x PTI" africa "AFRICA" asia "ASIA" japan "JAPAN" middeast "MIDDEAST" europe "EUROPE" uk "UK" france "FRANCE" germany "GERMANY" oceania "OCEANIA" samerica "SAMERICA" canada "CANADA" mexico "MEXICO")
esttab table4_eq2 using "tables/table4_col2.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(indus* yr*) varlabels(_cons "Intercept" size "SIZE" pti "PTI" foroper "FOROPER" foroper2 "FOROPER^2" mnc "MNC" mncsize "MNC x SIZE" mncpti "MNC x PTI" africa "AFRICA" asia "ASIA" japan "JAPAN" middeast "MIDDEAST" europe "EUROPE" uk "UK" france "FRANCE" germany "GERMANY" oceania "OCEANIA" samerica "SAMERICA" canada "CANADA" mexico "MEXICO")
esttab table4_eq2 using "tables/table4_col2.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(indus* yr*) varlabels(_cons "Intercept" size "SIZE" pti "PTI" foroper "FOROPER" foroper2 "FOROPER^2" mnc "MNC" mncsize "MNC x SIZE" mncpti "MNC x PTI" africa "AFRICA" asia "ASIA" japan "JAPAN" middeast "MIDDEAST" europe "EUROPE" uk "UK" france "FRANCE" germany "GERMANY" oceania "OCEANIA" samerica "SAMERICA" canada "CANADA" mexico "MEXICO")
est clear
exit, clear
