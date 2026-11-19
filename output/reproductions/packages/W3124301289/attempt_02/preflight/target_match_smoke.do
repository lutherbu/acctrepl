version 18
set more off
log using "preflight/target_match_smoke_stata.log", text replace
import sas using "data/rd_smoke.sas7bdat", clear
assert _N==2
assert target_init_sizegrp==3 if gvkey=="000001"
assert target_init_bmgrp==3 if gvkey=="000001"
assert target_update_formyear==1999 if gvkey=="000001"
assert target_update_acct_date==td(31jan1999) if gvkey=="000001"
assert target_update_avail_date==td(01jun1999) if gvkey=="000001"
assert target_update_me_date==td(30jun1999) if gvkey=="000001"
assert target_update_sizegrp==4 if gvkey=="000001"
assert target_update_bmgrp==2 if gvkey=="000001"
assert missing(target_update_formyear) if gvkey=="000003"
assert target_init_sizegrp==3 if gvkey=="000003"
import sas using "data/win_smoke.sas7bdat", clear
assert _N==12
assert sizegrp==3 if monthkey==td(01apr1999)
assert bmgrp==3 if monthkey==td(01apr1999)
assert abs(portret-.002)<1e-9 if monthkey==td(01jul1999)
assert abs(use_ret-.002)<1e-9 if monthkey==td(01jul1999)
assert post_delist==1 if monthkey==td(01jul1999)
log close
