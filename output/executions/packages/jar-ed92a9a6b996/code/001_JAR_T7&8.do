adopath ++ "@@ACCTREPL_RESOURCES@@/stata/plus"
use "bankfees.dta", clear

/* T7 full sample (longer horizon) */

areg nonintincpct1  c.post#c.wtrust size leverage assets_ratio opeexp i.year, absorb(rssd9001) vce(cluster rssd9001)
areg nonintincpct2  c.post#c.wtrust size leverage assets_ratio opeexp i.year, absorb(rssd9001) vce(cluster rssd9001)

/* T8 full sample (longer horizon) */

/* HHI */

summarize hhi_share2010, detail

gen competition = (hhi_share2010 < .4430112)     /* the median of hhi_share2010 is .4430112 */ 

areg nonintincpct1  c.post#c.wtrust size leverage assets_ratio opeexp i.year if hhi_share2010 < .4430112, absorb(rssd9001) vce(cluster rssd9001)
areg nonintincpct1  c.post#c.wtrust size leverage assets_ratio opeexp i.year if hhi_share2010 >= .4430112, absorb(rssd9001) vce(cluster rssd9001)
areg nonintincpct1  c.post#c.wtrust c.post#c.wtrust#c.competition c.post#c.competition size leverage assets_ratio opeexp i.year, absorb(rssd9001) vce(cluster rssd9001)

areg nonintincpct2  c.post#c.wtrust size leverage assets_ratio opeexp i.year if hhi_share2010 < .4430112, absorb(rssd9001) vce(cluster rssd9001)
areg nonintincpct2  c.post#c.wtrust size leverage assets_ratio opeexp i.year if hhi_share2010 >= .4430112, absorb(rssd9001) vce(cluster rssd9001)
areg nonintincpct2  c.post#c.wtrust c.post#c.wtrust#c.competition c.post#c.competition size leverage assets_ratio opeexp i.year, absorb(rssd9001) vce(cluster rssd9001)
