version 18
set more off
global y "y_h1"
global d "dp"
global vars "$y $d e_rate dp_e"
use "reg.dta", clear
label variable dp "Regular dividend indicator"
label variable e_rate "Current adjusted earnings / lagged assets"
label variable y_h1 "One-year-ahead earnings / lagged assets"
label variable y_h2 "Two-year-ahead earnings / lagged assets"
gen double dp_e = dp*e_rate
label variable dp_e "DP x current earnings rate"
est clear
estpost tabstat $vars if use_h1==1 & fyear>=1994 & fyear<=2005, stat(N mean sd p25 p50 p75) columns(statistics)
esttab using "tables/descriptives_panelA_h1_1994.md", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace title("Table 4 Panel A, h=1, 1994-2005: actual regression sample")
esttab using "tables/descriptives_panelA_h1_1994.rtf", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace title("Table 4 Panel A, h=1, 1994-2005: actual regression sample")
esttab using "tables/descriptives_panelA_h1_1994.csv", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace title("Table 4 Panel A, h=1, 1994-2005: actual regression sample")
esttab using "tables/descriptives_panelA_h1_1994.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace title("Table 4 Panel A, h=1, 1994-2005: actual regression sample")
est clear
exit, clear
