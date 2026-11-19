options errorabend msglevel=i;
libname out "data";

data work.sample_vars;
    length gvkey $6;
    input gvkey $ fyear datadate :date9. startmonth :date9. full_year
          mve4month :date9. mve4_date :date9. permco_mve4 nco_mve4 mve4
          ceq_usd txditc_usd rdasset ret_permno;
    endmonth=intnx("month",datadate,16,"beginning");
    format datadate startmonth endmonth mve4month mve4_date date9.;
datalines;
000001 1998 31AUG1998 01JAN1999 1 01DEC1998 31DEC1998 101 1 300 20 5 15 10001
000002 1998 28FEB1998 01JUL1998 1 01JUN1998 30JUN1998 102 1 50 20 0 5 10002
000003 1998 31AUG1998 01JAN1999 1 01DEC1998 31DEC1998 103 1 300 20 5 15 10003
;
run;

data work.cutoffs;
    input formyear sz_q20 sz_q40 sz_q60 sz_q80 bm_q20 bm_q40 bm_q60 bm_q80;
datalines;
1998 100 200 400 800 .05 .10 .20 .40
1999 200 350 600 1000 .08 .15 .25 .50
;
run;

data work.links;
    length gvkey $6;
    input gvkey $ lpermco linkdt linkenddt;
datalines;
000001 101 .B .E
000002 102 .B .E
000003 103 .B .E
;
run;

data work.company_me;
    input permco monthkey :date9. last_trade_date :date9. me_co;
    format monthkey last_trade_date date9.;
datalines;
101 01JUN1999 30JUN1999 800
;
run;

data work.fund_hist;
    length gvkey $6;
    input gvkey $ datadate :date9. fyear full_year ceq_usd txditc_usd rdasset;
    format datadate date9.;
datalines;
000001 31DEC1998 1998 1 20 5 15
000001 31JAN1999 1999 1 60 0 40
000001 31MAR1999 1999 1 200 0 100
000003 31DEC1998 1998 1 20 5 15
000003 31JAN1999 1999 1 60 0 40
;
run;

data work.delist_month;
    input permno dlmonth :date9. dlstdt :date9.;
    format dlmonth dlstdt date9.;
datalines;
10003 01MAR1999 15MAR1999
;
run;

data work.window0;
    set work.sample_vars;
    if month(startmonth)>=7 then initial_formyear=year(startmonth);
    else initial_formyear=year(startmonth)-1;
    do month_offset=5 to 16;
        monthkey=intnx("month",datadate,month_offset,"beginning");
        if month(monthkey)>=7 then formyear=year(monthkey);
        else formyear=year(monthkey)-1;
        output;
    end;
    format monthkey date9.;
run;

/* Match targets separately from the benchmark constituents. At the initial
   investment date, use current MVE4 and the sample-year adjusted book value
   against the preceding June cutoffs. If the return window extends beyond a
   subsequent June 30, refresh the target match with June market equity and
   the latest annual statement whose assumed four-month availability date has
   arrived by June 30. */
proc sql;
    create table work.target_initial_key as
    select distinct gvkey, fyear, initial_formyear
    from work.window0;
    create table work.target_update_candidate0 as
    select w.gvkey, w.fyear, w.formyear, d.dlstdt
    from work.window0 as w
    inner join work.sample_vars as s
      on w.gvkey=s.gvkey and w.fyear=s.fyear
    left join work.delist_month as d
      on s.ret_permno=d.permno and d.dlmonth>=s.startmonth and d.dlmonth<=s.endmonth
    where w.formyear>initial_formyear;
    create table work.target_update_candidate as
    select gvkey, fyear, formyear,
           min(dlstdt) as first_dl_date format=date9.
    from work.target_update_candidate0
    group by gvkey, fyear, formyear;
    create table work.target_update_key0 as
    select gvkey, fyear, formyear, first_dl_date
    from work.target_update_candidate
    where missing(first_dl_date) or first_dl_date>mdy(6,30,formyear);
quit;

data work.target_update_key;
    set work.target_update_key0;
    update_date=mdy(6,30,formyear);
    update_month=intnx("month",update_date,0,"beginning");
    format update_date update_month date9.;
run;

proc sql;
    create table work.target_initial0 as
    select k.gvkey, k.fyear, k.initial_formyear as formyear,
           "INITIAL" as assignment_type length=7,
           s.startmonth as assignment_date format=date9.,
           s.datadate as target_acct_date format=date9.,
           s.startmonth as available_date format=date9.,
           s.fyear as target_acct_fyear,
           s.full_year as target_acct_full,
           s.mve4month as target_me_month format=date9.,
           s.mve4_date as target_me_date format=date9.,
           s.permco_mve4 as target_permco,
           s.nco_mve4 as target_link_count,
           s.mve4 as target_size,
           s.ceq_usd+s.txditc_usd+s.rdasset as target_book,
           (s.ceq_usd+s.txditc_usd+s.rdasset)/s.mve4 as target_bm,
           c.formyear as cutoff_formyear,
           c.sz_q20, c.sz_q40, c.sz_q60, c.sz_q80,
           c.bm_q20, c.bm_q40, c.bm_q60, c.bm_q80
    from work.target_initial_key as k
    inner join work.sample_vars as s
      on k.gvkey=s.gvkey and k.fyear=s.fyear
    left join work.cutoffs as c
      on k.initial_formyear=c.formyear;

    create table work.target_update_link0 as
    select k.gvkey, k.fyear, k.formyear, k.update_date, k.update_month,
           count(distinct l.lpermco) as target_link_count,
           min(l.lpermco) as target_permco
    from work.target_update_key as k
    left join work.links as l
      on k.gvkey=l.gvkey
     and (l.linkdt=.B or (not missing(l.linkdt) and l.linkdt<=k.update_date))
     and (l.linkenddt=.E or (not missing(l.linkenddt) and l.linkenddt>=k.update_date))
    group by k.gvkey, k.fyear, k.formyear, k.update_date, k.update_month;

    create table work.target_update_acct0 as
    select k.gvkey, k.fyear, k.formyear, k.update_date,
           h.datadate as target_acct_date format=date9.,
           intnx("month",h.datadate,5,"beginning") as available_date format=date9.,
           h.fyear as target_acct_fyear,
           h.full_year as target_acct_full,
           h.ceq_usd, h.txditc_usd, h.rdasset
    from work.target_update_key as k
    inner join work.fund_hist as h
      on k.gvkey=h.gvkey
    where calculated available_date<=k.update_date;
quit;

proc sort data=work.target_update_acct0 out=work.target_update_acct_sort;
    by gvkey fyear formyear descending available_date descending target_acct_date
       descending target_acct_full descending target_acct_fyear;
run;

data work.target_update_acct;
    set work.target_update_acct_sort;
    by gvkey fyear formyear;
    if first.formyear;
    target_book=ceq_usd+txditc_usd+rdasset;
run;

proc sql;
    create table work.target_update0 as
    select k.gvkey, k.fyear, k.formyear,
           "JUNE" as assignment_type length=7,
           k.update_date as assignment_date format=date9.,
           a.target_acct_date,
           a.available_date,
           a.target_acct_fyear,
           a.target_acct_full,
           k.update_month as target_me_month format=date9.,
           m.last_trade_date as target_me_date format=date9.,
           l.target_permco,
           l.target_link_count,
           m.me_co as target_size,
           a.target_book,
           a.target_book/m.me_co as target_bm,
           c.formyear as cutoff_formyear,
           c.sz_q20, c.sz_q40, c.sz_q60, c.sz_q80,
           c.bm_q20, c.bm_q40, c.bm_q60, c.bm_q80
    from work.target_update_key as k
    left join work.target_update_link0 as l
      on k.gvkey=l.gvkey and k.fyear=l.fyear and k.formyear=l.formyear
    left join work.target_update_acct as a
      on k.gvkey=a.gvkey and k.fyear=a.fyear and k.formyear=a.formyear
    left join work.company_me as m
      on l.target_permco=m.permco and k.update_month=m.monthkey
    left join work.cutoffs as c
      on k.formyear=c.formyear;

quit;

data work.target_assignment0;
    set work.target_initial0 work.target_update0;
    length reason $34;
    sizegrp=.; bmgrp=.;
    if missing(cutoff_formyear) then reason="NO_JUNE_CUTOFFS";
    else if nmiss(sz_q20,sz_q40,sz_q60,sz_q80,
                  bm_q20,bm_q40,bm_q60,bm_q80)>0 then reason="INCOMPLETE_JUNE_CUTOFFS";
    else if target_link_count ne 1 then reason="NO_UNIQUE_TARGET_LINK";
    else if missing(target_acct_date) or missing(target_book) then reason="NO_ASOF_ADJUSTED_BOOK";
    else if missing(target_size) or target_size<=0 then reason="NO_CURRENT_MARKET_EQUITY";
    else if missing(target_bm) then reason="NO_CURRENT_BOOK_MARKET";
    else do;
        if target_size<=sz_q20 then sizegrp=1;
        else if target_size<=sz_q40 then sizegrp=2;
        else if target_size<=sz_q60 then sizegrp=3;
        else if target_size<=sz_q80 then sizegrp=4;
        else sizegrp=5;
        if target_bm<=bm_q20 then bmgrp=1;
        else if target_bm<=bm_q40 then bmgrp=2;
        else if target_bm<=bm_q60 then bmgrp=3;
        else if target_bm<=bm_q80 then bmgrp=4;
        else bmgrp=5;
        if missing(sizegrp) or missing(bmgrp) then reason="INCOMPLETE_TARGET_GROUP";
        else reason="ASSIGNED";
    end;
    drop sz_q20 sz_q40 sz_q60 sz_q80 bm_q20 bm_q40 bm_q60 bm_q80;
run;

proc sort data=work.target_assignment0 out=work.target_assignment;
    by gvkey fyear formyear;
run;

proc sql;
    create table work.target_assignment_summary as
    select i.gvkey, i.fyear,
           i.formyear as target_init_cutoff,
           i.assignment_date as target_init_date format=date9.,
           i.target_acct_date as target_init_acct_date format=date9.,
           i.available_date as target_init_avail_date format=date9.,
           i.target_me_date as target_init_me_date format=date9.,
           i.target_size as target_init_size,
           i.target_book as target_init_book,
           i.target_bm as target_init_bm,
           i.sizegrp as target_init_sizegrp,
           i.bmgrp as target_init_bmgrp,
           i.reason as target_init_reason,
           u.formyear as target_update_formyear,
           u.assignment_date as target_update_date format=date9.,
           u.target_acct_date as target_update_acct_date format=date9.,
           u.available_date as target_update_avail_date format=date9.,
           u.target_me_date as target_update_me_date format=date9.,
           u.target_size as target_update_size,
           u.target_book as target_update_book,
           u.target_bm as target_update_bm,
           u.sizegrp as target_update_sizegrp,
           u.bmgrp as target_update_bmgrp,
           u.reason as target_update_reason
    from work.target_assignment as i
    left join work.target_assignment as u
      on i.gvkey=u.gvkey and i.fyear=u.fyear and u.assignment_type="JUNE"
    where i.assignment_type="INITIAL";
    title "Target investment-date and June reassignment support";
    select assignment_type, formyear, count(*) as assignments,
           sum(reason="ASSIGNED") as assigned,
           min(target_acct_date) as first_account_date format=date9.,
           max(target_acct_date) as last_account_date format=date9.,
           min(available_date) as first_assumed_available format=date9.,
           max(available_date) as last_assumed_available format=date9.,
           min(target_me_date) as first_market_date format=date9.,
           max(target_me_date) as last_market_date format=date9.,
           min(cutoff_formyear) as first_cutoff_year,
           max(cutoff_formyear) as last_cutoff_year
    from work.target_assignment
    group by assignment_type, formyear
    order by assignment_type, formyear;
    select assignment_type, reason, count(*) as assignments
    from work.target_assignment
    where reason ne "ASSIGNED"
    group by assignment_type, reason
    order by assignment_type, reason;
    title "Target June updates suppressed after delisting";
    select formyear, count(*) as candidate_updates,
           sum(not missing(first_dl_date) and first_dl_date<=mdy(6,30,formyear)) as delisted_by_update,
           sum(missing(first_dl_date) or first_dl_date>mdy(6,30,formyear)) as active_at_update
    from work.target_update_candidate
    group by formyear
    order by formyear;
quit;


data work.dl_window;
    length gvkey $6;
    input gvkey $ fyear dlmonth :date9. dl_ambiguous dl_formyear;
    format dlmonth date9.;
datalines;
000003 1998 01MAR1999 0 1998
;
run;

data work.port_ret0;
    base=mdy(1,1,1999);
    do i=0 to 5;
        formyear=1998; sizegrp=3; bmgrp=3;
        monthkey=intnx("month",base,i,"beginning"); portret=.001; output;
    end;
    do i=6 to 11;
        formyear=1999; monthkey=intnx("month",base,i,"beginning");
        sizegrp=3; bmgrp=3; portret=.002; output;
        sizegrp=4; bmgrp=2; portret=.009; output;
    end;
    format monthkey date9.;
    drop base i;
run;

data work.stock_full;
    input permno monthkey :date9. ret_adj me_sec;
    format monthkey date9.;
datalines;
10003 01JAN1999 .01 100
10003 01FEB1999 .02 100
10003 01MAR1999 .03 100
;
run;

proc sql;
    create table work.dl_group_year as
    select d.gvkey, d.fyear, max(a.formyear) as last_formyear
    from work.dl_window as d
    left join work.target_assignment as a
      on d.gvkey=a.gvkey and a.formyear<=d.dl_formyear
     and a.fyear=d.fyear and a.reason="ASSIGNED"
    where d.dl_ambiguous=0 and not missing(d.dlmonth)
    group by d.gvkey, d.fyear;
    create table work.dl_group as
    select y.gvkey, y.fyear, y.last_formyear,
           a.sizegrp, a.bmgrp
    from work.dl_group_year as y
    left join work.target_assignment as a
      on y.gvkey=a.gvkey and y.fyear=a.fyear and y.last_formyear=a.formyear
     and a.reason="ASSIGNED";
    create table work.window1 as
    select w.*, s.ret_adj, s.me_sec,
           d.dlmonth, d.dl_ambiguous,
           case when d.dl_ambiguous=0 and not missing(d.dlmonth) and
                          w.monthkey>d.dlmonth then g.sizegrp
                else a.sizegrp end as sizegrp,
           case when d.dl_ambiguous=0 and not missing(d.dlmonth) and
                          w.monthkey>d.dlmonth then g.bmgrp
                else a.bmgrp end as bmgrp,
           case when d.dl_ambiguous=0 and not missing(d.dlmonth) and
                          w.monthkey>d.dlmonth then pg.portret
                else p.portret end as portret
    from work.window0 as w
    left join work.stock_full as s
      on w.ret_permno=s.permno and w.monthkey=s.monthkey
    left join work.dl_window as d
      on w.gvkey=d.gvkey and w.fyear=d.fyear
    left join work.target_assignment as a
      on w.gvkey=a.gvkey and w.fyear=a.fyear and w.formyear=a.formyear
    left join work.port_ret0 as p
      on a.formyear=p.formyear and a.sizegrp=p.sizegrp and a.bmgrp=p.bmgrp
     and w.monthkey=p.monthkey
    left join work.dl_group as g
      on w.gvkey=g.gvkey and w.fyear=g.fyear
    left join work.port_ret0 as pg
      on w.formyear=pg.formyear and g.sizegrp=pg.sizegrp and g.bmgrp=pg.bmgrp
     and w.monthkey=pg.monthkey;
quit;


data work.window3;
    set work.window1;
    use_ret=.;
    if dl_ambiguous=0 and not missing(dlmonth) and monthkey>dlmonth then use_ret=portret;
    else use_ret=ret_adj;
    actual_return=(not missing(ret_adj));
    post_delist=(dl_ambiguous=0 and not missing(dlmonth) and monthkey>dlmonth);
    group_missing=(missing(sizegrp) or missing(bmgrp));
    benchmark_missing=missing(portret);
run;


data out.rd_smoke;
    set work.target_assignment_summary;
    where gvkey="000001" or gvkey="000003";
run;

data out.win_smoke;
    set work.window3;
    where gvkey="000003";
    keep gvkey fyear monthkey formyear sizegrp bmgrp portret use_ret
         post_delist actual_return group_missing benchmark_missing;
run;

proc print data=out.rd_smoke; run;
proc print data=out.win_smoke; run;
