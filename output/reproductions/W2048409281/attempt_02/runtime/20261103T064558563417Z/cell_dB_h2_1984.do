version 18
set more off
global y "y_h2"
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
estpost tabstat $vars if use_h2==1 & fyear>=1984 & fyear<=1993, stat(N mean sd p25 p50 p75) columns(statistics)
esttab using "tables/descriptives_panelB_h2_1984.md", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace title("Table 4 Panel B, h=2, 1984-1993: actual regression sample")
esttab using "tables/descriptives_panelB_h2_1984.rtf", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace title("Table 4 Panel B, h=2, 1984-1993: actual regression sample")
esttab using "tables/descriptives_panelB_h2_1984.csv", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace title("Table 4 Panel B, h=2, 1984-1993: actual regression sample")
esttab using "tables/descriptives_panelB_h2_1984.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") label noobs replace title("Table 4 Panel B, h=2, 1984-1993: actual regression sample")
est clear
exit, clear
