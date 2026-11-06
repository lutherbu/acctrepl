options errorabend nofmterr msglevel=i mprint mlogic symbolgen;

libname comp '/storage/sas/base/comp/d_na' access=readonly;
libname sec  '/storage/sas/base/comp/d_na/security' access=readonly;
libname crsp '/storage/sas/base/crsp/a_stock' access=readonly;
libname ccm  '/storage/sas/base/crsp/a_ccm' access=readonly;
libname out  './data';

title 'W2065676679 Beaver and Ryan: Annual source population';
data work.funda0;
  set comp.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt
                      curcd fic hiid iid ceq ibcom mkvalt csho prcc_f sich
                 where=(popsrc='D' and consol='C' and datafmt='STD'
                        and indfmt in ('INDL','FS')
                        and fyear >= 1974 and fyear <= 1993));
  if indfmt='INDL' then fmt_rank=0;
  else fmt_rank=1;
run;

proc freq data=work.funda0;
  tables indfmt*fyear / missing list;
  tables curcd*fic / missing list;
run;

proc sql;
  title 'Format selection and duplicate audit';
  create table work.year_format as
  select gvkey, fyear, count(*) as n_source,
         sum(indfmt='INDL') as n_indl,
         sum(indfmt='FS') as n_fs,
         count(distinct datadate) as n_dates
  from work.funda0
  group by gvkey, fyear;
  select count(*) as source_rows,
         sum(n_indl>0 and n_fs>0) as dual_format_years,
         sum(n_indl=0 and n_fs>0) as fs_only_years,
         sum(n_indl>1) as multiple_indl_years,
         sum(n_fs>1) as multiple_fs_years
  from work.year_format;

  create table work.preferred as
  select a.*
  from work.funda0 as a inner join
       (select gvkey, fyear, min(fmt_rank) as fmt_rank
        from work.funda0 group by gvkey, fyear) as p
    on a.gvkey=p.gvkey and a.fyear=p.fyear and a.fmt_rank=p.fmt_rank;
  create table work.latestdate as
  select gvkey, fyear, max(datadate) as datadate
  from work.preferred group by gvkey, fyear;
  create table work.latestraw as
  select distinct a.*
  from work.preferred as a inner join work.latestdate as d
    on a.gvkey=d.gvkey and a.fyear=d.fyear and a.datadate=d.datadate;
  create table work.latest_count as
  select gvkey, fyear, count(*) as n_latest
  from work.latestraw group by gvkey, fyear;
  create table work.selected0 as
  select a.*
  from work.latestraw as a inner join work.latest_count as c
    on a.gvkey=c.gvkey and a.fyear=c.fyear
  where c.n_latest=1;
  create table work.unresolved_years as
  select * from work.latest_count where n_latest>1;
  title 'Unresolved latest-report ties after INDL preference';
  select * from work.unresolved_years order by gvkey, fyear;
quit;

proc sort data=work.selected0; by gvkey fyear; run;

data work.link0;
  set ccm.ccmxpf_linktable(keep=gvkey liid linkprim linktype lpermno
                                linkdt linkenddt usedflag);
  where usedflag=1 and linktype in ('LC','LU')
        and linkprim in ('P','C');
  if linktype='LC' then link_rank=0;
  else link_rank=1;
run;

proc sql;
  title 'Fiscal-close primary price and currency validation';
  create table work.price_links0 as
  select distinct s.gvkey, s.fyear, s.datadate, s.hiid, s.curcd, s.fic,
         s.prcc_f, l.liid as map_iid,
         (strip(s.hiid)=strip(l.liid)) as direct_iid,
         l.lpermno,
         l.linktype, l.link_rank
  from work.selected0 as s inner join work.link0 as l
    on s.gvkey=l.gvkey and l.linkprim='P'
       and (missing(l.linkdt) or l.linkdt<=s.datadate)
       and (missing(l.linkenddt) or l.linkenddt>=s.datadate)
       and (strip(s.hiid)=strip(l.liid)
            or (length(strip(s.hiid))=length(strip(l.liid))+1
                and substr(strip(s.hiid),1,length(strip(l.liid)))=strip(l.liid)
                and substr(strip(s.hiid),length(strip(l.liid))+1,1)='C'));
  create table work.price_link_counts as
  select gvkey, fyear, count(distinct lpermno) as n_perm,
         count(distinct map_iid) as n_issue
  from work.price_links0 group by gvkey, fyear;
quit;

proc sort data=work.price_links0; by gvkey fyear link_rank lpermno map_iid; run;
proc sort data=work.price_link_counts; by gvkey fyear; run;
data work.price_links;
  merge work.price_links0(in=a) work.price_link_counts(in=c);
  by gvkey fyear;
  if a and c and n_perm=1 and n_issue=1 and first.fyear;
run;

proc sql;
  create table work.pricecheck0 as
  select s.*, p.map_iid, p.direct_iid, p.lpermno as price_permno,
         m.datadate as price_date, m.curcdm as price_curcd, m.prccm,
         abs(s.datadate-m.datadate) as price_date_gap,
         abs(s.prcc_f-m.prccm) as price_abs_gap
  from work.selected0 as s left join work.price_links as p
    on s.gvkey=p.gvkey and s.fyear=p.fyear
  left join sec.sec_mthprc as m
    on p.gvkey=m.gvkey and p.map_iid=m.iid and s.datadate=m.datadate;
quit;

proc sql;
  title 'Exact fiscal-close date check, bounded 1984-1988 audit';
  select count(*) as annual_rows,
         sum(not missing(price_date)) as exact_date_quotes,
         sum(not missing(price_date) and price_date_gap ne 0) as nonzero_day_gaps,
         min(datadate) as first_fiscal_date format=date9.,
         max(datadate) as last_fiscal_date format=date9.,
         min(price_date) as first_quote_date format=date9.,
         max(price_date) as last_quote_date format=date9.
  from work.pricecheck0
  where fyear between 1984 and 1988;
quit;
proc means data=work.pricecheck0 n nmiss min p1 p5 p50 p95 p99 max;
  where fyear between 1984 and 1988 and not missing(price_date);
  class curcd price_curcd;
  var price_date_gap price_abs_gap;
run;

data work.annual1;
  set work.pricecheck0;
  length price_method $24;
  price_ok=0;
  price_method='UNSUPPORTED';
  if not missing(curcd) and not missing(price_curcd)
     and not missing(price_date) and not missing(price_abs_gap)
     and curcd=price_curcd and price_abs_gap<=.005 then do;
    price_ok=1;
    price_method='DATED_PRICE_MATCH';
  end;
  else if missing(price_date) and fic='USA' and curcd='USD' then do;
    price_ok=1;
    price_method='GUIDE_USA_USD';
  end;
  else if missing(price_date) and fic='CAN' and curcd='CAD' then do;
    price_ok=1;
    price_method='GUIDE_CANADIAN_CAD';
  end;

  return_id_ok=0;
  if price_ok=1 and direct_iid=1 then return_id_ok=1;
  else if price_ok=1 and price_method='DATED_PRICE_MATCH'
          and not missing(map_iid) then return_id_ok=1;

  market_eq=.;
  if price_ok=1 and csho>0 and prcc_f>0 then market_eq=csho*prcc_f;
  btm_raw=.;
  btm=.;
  if not missing(ceq) and market_eq>0 then do;
    btm_raw=ceq/market_eq;
    if btm_raw<0 then btm=0;
    else if btm_raw>4 then btm=4;
    else btm=btm_raw;
  end;
  label market_eq='Fiscal-year primary price x company shares, millions'
        btm_raw='Uncapped common book-to-market ratio'
        btm='Book-to-market, fixed cap [0,4]'
        price_ok='Fiscal-close price currency supported'
        return_id_ok='Dated primary issue mapping supported for CRSP return'
        price_method='Price currency evidence';
run;

proc freq data=work.annual1;
  tables price_method*curcd / missing list;
run;
proc means data=work.annual1 n nmiss;
  var ceq ibcom csho prcc_f mkvalt market_eq btm_raw btm;
  class indfmt;
run;

proc sort data=work.annual1; by gvkey fyear; run;
data work.annual2;
  set work.annual1;
  by gvkey fyear;
  prior_ceq=lag(ceq);
  prior_curcd=lag(curcd);
  prior_fyear=lag(fyear);
  if first.gvkey then call missing(prior_ceq,prior_curcd,prior_fyear);
  roe_raw=.;
  roe=.;
  if fyear=prior_fyear+1 and not missing(curcd) and
     not missing(prior_curcd) and curcd=prior_curcd and
     not missing(ibcom) and not missing(prior_ceq) and prior_ceq ne 0 then do;
    roe_raw=ibcom/prior_ceq;
    if roe_raw < -1 then roe=-1;
    else if roe_raw > 1 then roe=1;
    else roe=roe_raw;
  end;
  label roe_raw='IBCOM divided by prior-year CEQ before fixed cap'
        roe='Return on common equity, fixed cap [-1,1]';
run;

title 'Dated primary daily return windows';
proc sql;
  create table work.win0 as
  select c.gvkey, c.fyear, c.datadate as end_date format=yymmddn8.,
         p.datadate as start_date format=yymmddn8.,
         c.hiid as hiid_cur, p.hiid as hiid_prev,
         c.curcd as curcd_cur, p.curcd as curcd_prev,
         c.price_ok as price_ok_cur, p.price_ok as price_ok_prev,
         c.return_id_ok as return_id_ok_cur,
         p.return_id_ok as return_id_ok_prev
  from work.annual2 as c inner join work.annual2 as p
    on c.gvkey=p.gvkey and p.fyear=c.fyear-1
  where c.fyear between 1975 and 1993
    and c.curcd='USD' and p.curcd='USD'
    and c.price_ok=1 and p.price_ok=1
    and c.return_id_ok=1 and p.return_id_ok=1;
quit;
proc sort data=work.win0; by gvkey fyear; run;
data work.win0;
  set work.win0;
  window_id=_n_;
run;

proc sql;
  create table work.pret_candidates as
  select w.window_id, w.gvkey, w.fyear, w.start_date, w.end_date,
         l.lpermno as permno, l.liid, l.linkprim, l.linktype,
         l.link_rank
  from work.win0 as w inner join work.link0 as l
    on w.gvkey=l.gvkey and l.linkprim='P'
       and (missing(l.linkdt) or l.linkdt<=w.start_date)
       and (missing(l.linkenddt) or l.linkenddt>=w.end_date)
       and (strip(w.hiid_cur)=strip(l.liid)
            or (length(strip(w.hiid_cur))=length(strip(l.liid))+1
                and substr(strip(w.hiid_cur),1,length(strip(l.liid)))=strip(l.liid)
                and substr(strip(w.hiid_cur),length(strip(l.liid))+1,1)='C'))
       and (strip(w.hiid_prev)=strip(l.liid)
            or (length(strip(w.hiid_prev))=length(strip(l.liid))+1
                and substr(strip(w.hiid_prev),1,length(strip(l.liid)))=strip(l.liid)
                and substr(strip(w.hiid_prev),length(strip(l.liid))+1,1)='C'));
  create table work.pret_counts as
  select window_id, count(distinct permno) as n_perm
  from work.pret_candidates group by window_id;
  create table work.pret_unique as
  select a.*
  from work.pret_candidates as a inner join work.pret_counts as c
    on a.window_id=c.window_id
  where c.n_perm=1;

  create table work.creturn_candidates as
  select w.window_id, w.gvkey, w.fyear, w.start_date, w.end_date,
         l.lpermno as permno, l.liid, l.linkprim, l.linktype,
         l.link_rank
  from work.win0 as w inner join work.link0 as l
    on w.gvkey=l.gvkey and l.linkprim='C'
       and length(strip(l.liid))=3 and substr(strip(l.liid),3,1)='X'
       and (missing(l.linkdt) or l.linkdt<=w.start_date)
       and (missing(l.linkenddt) or l.linkenddt>=w.end_date)
  where not exists (select 1 from work.pret_candidates as p
                    where p.window_id=w.window_id);
  create table work.creturn_counts as
  select window_id, count(distinct permno) as n_perm
  from work.creturn_candidates group by window_id;
  create table work.creturn_unique as
  select a.*
  from work.creturn_candidates as a inner join work.creturn_counts as c
    on a.window_id=c.window_id
  where c.n_perm=1;
quit;

proc sort data=work.pret_unique; by window_id link_rank permno; run;
data work.pret_one;
  set work.pret_unique;
  by window_id;
  if first.window_id;
  route='P';
run;
proc sort data=work.creturn_unique; by window_id link_rank permno; run;
data work.creturn_one;
  set work.creturn_unique;
  by window_id;
  if first.window_id;
  route='C_DUMMY_X';
run;
data work.return_windows;
  length route $9;
  set work.pret_one work.creturn_one;
run;
proc sort data=work.return_windows; by window_id; run;

proc sql;
  title 'Daily-session return coverage';
  create table work.session_calendar as
  select date as session_date format=yymmddn8.
  from crsp.dsi
  where date >= '01jan1974'd and date <= '31dec1994'd;
  create table work.return_days as
  select w.window_id, w.gvkey, w.fyear, w.permno, w.route,
         w.linktype, w.start_date, w.end_date,
         c.session_date
  from work.return_windows as w inner join work.session_calendar as c
    on c.session_date>w.start_date and c.session_date<=w.end_date;

  create table work.delist0 as
  select permno, dlstdt, count(*) as n_event,
         sum(not missing(dlret) and dlret>=-1) as n_valid,
         min(case when not missing(dlret) and dlret>=-1 then dlret end) as min_dlret,
         max(case when not missing(dlret) and dlret>=-1 then dlret end) as max_dlret
  from crsp.dsedelist
  where not missing(dlstdt)
  group by permno, dlstdt;
  create table work.delist1 as
  select e.*, d.date as dsi_date
  from work.delist0 as e left join crsp.dsi as d
    on e.dlstdt=d.date;
quit;

data work.delist;
  set work.delist1;
  has_event=1;
  dlret=.;
  if n_valid=n_event and min_dlret=max_dlret then dlret=min_dlret;
  on_session=not missing(dsi_date);
run;

proc sql;
  create table work.offcalendar_event as
  select w.window_id, count(*) as n_event
  from work.return_windows as w inner join work.delist as e
    on w.permno=e.permno and e.dlstdt>w.start_date and e.dlstdt<=w.end_date
  where e.on_session=0
  group by w.window_id;

  create table work.daily_returns0 as
  select s.window_id, s.gvkey, s.fyear, s.permno, s.route,
         s.start_date, s.end_date, s.session_date,
         d.ret as daily_ret, e.has_event, e.dlret,
         case when e.has_event=1 and not missing(e.dlret)
                    and e.dlret>=-1 and d.ret>=-1
                then (1+d.ret)*(1+e.dlret)-1
              when e.has_event=1 and not missing(e.dlret)
                    and e.dlret>=-1 then e.dlret
              when e.has_event=1 then .
              when d.ret>=-1 then d.ret
              else . end as total_ret
  from work.return_days as s
    left join crsp.dsf as d
      on s.permno=d.permno and s.session_date=d.date
    left join work.delist as e
      on s.permno=e.permno and s.session_date=e.dlstdt;
quit;

proc sort data=work.daily_returns0; by window_id session_date; run;
data work.annual_returns0;
  set work.daily_returns0;
  by window_id;
  retain n_expected n_valid n_missing compound_log total_loss
         first_session last_session n_dsf n_delist;
  if first.window_id then do;
    n_expected=0; n_valid=0; n_missing=0; compound_log=0;
    total_loss=0; n_dsf=0; n_delist=0;
    first_session=session_date;
  end;
  n_expected+1;
  last_session=session_date;
  if not missing(daily_ret) and daily_ret>=-1 then n_dsf+1;
  if has_event=1 then n_delist+1;
  if not missing(total_ret) and total_ret>=-1 then do;
    n_valid+1;
    if total_ret=-1 then total_loss=1;
    else if total_loss=0 then compound_log+log(1+total_ret);
  end;
  else n_missing+1;
  if last.window_id then do;
    annual_ret=.;
    if n_valid=n_expected and n_missing=0 then do;
      if total_loss=1 then annual_ret=-1;
      else annual_ret=exp(compound_log)-1;
    end;
    output;
  end;
  keep window_id gvkey fyear permno route start_date end_date
       first_session last_session n_expected n_valid n_missing n_dsf
       n_delist annual_ret;
run;

proc sort data=work.annual_returns0; by window_id; run;
proc sort data=work.offcalendar_event; by window_id; run;
data work.annual_returns;
  merge work.annual_returns0(in=a) work.offcalendar_event(in=b);
  by window_id;
  if a;
  if b then call missing(annual_ret);
  ret_complete=not missing(annual_ret);
  label annual_ret='Compounded annual CRSP total return, complete sessions'
        ret_complete='Every expected CRSP session has a valid total return';
run;

proc means data=work.annual_returns n nmiss min p1 p50 p99 max;
  var n_expected n_valid n_missing n_dsf n_delist annual_ret;
  class route ret_complete;
run;
proc sql;
  select count(*) as return_windows,
         sum(ret_complete=1) as complete_windows,
         sum(n_missing>0) as windows_with_missing_daily
  from work.annual_returns;
  select count(*) as offcalendar_delist_windows
  from work.offcalendar_event;
quit;

proc sort data=work.annual_returns; by gvkey fyear; run;
proc sort data=work.annual2; by gvkey fyear; run;
data work.history0;
  merge work.annual2(in=a) work.annual_returns(in=r
        keep=gvkey fyear annual_ret ret_complete permno route
             start_date end_date n_expected n_valid n_missing);
  by gvkey fyear;
  if a;
  ret_raw=annual_ret;
  ret=.;
  if not missing(ret_raw) then do;
    if ret_raw>3 then ret=3;
    else ret=ret_raw;
  end;
  label ret_raw='Annual total return before upper cap'
        ret='Annual fiscal-year total return, fixed upper cap 3';
run;

proc means data=work.history0 n nmiss min p1 p50 p99 max;
  var ceq market_eq btm_raw btm ibcom roe_raw roe ret_raw ret;
  class fyear;
run;

data out.history;
  set work.history0;
  keep gvkey fyear datadate indfmt popsrc consol datafmt curcd fic sich
       hiid iid ceq ibcom csho prcc_f mkvalt market_eq price_ok price_method
       return_id_ok
       btm_raw btm roe_raw roe prior_ceq prior_curcd ret_raw ret ret_complete
       permno route start_date end_date n_expected n_valid n_missing;
run;

proc sql;
  create table work.eqhist as
  select a.gvkey, a.fyear, a.btm,
         r0.ret as r0, r1.ret as r1, r2.ret as r2, r3.ret as r3,
         r4.ret as r4, r5.ret as r5, r6.ret as r6
  from work.history0 as a
    left join work.history0 as r0 on a.gvkey=r0.gvkey and a.fyear=r0.fyear
    left join work.history0 as r1 on a.gvkey=r1.gvkey and a.fyear=r1.fyear+1
    left join work.history0 as r2 on a.gvkey=r2.gvkey and a.fyear=r2.fyear+2
    left join work.history0 as r3 on a.gvkey=r3.gvkey and a.fyear=r3.fyear+3
    left join work.history0 as r4 on a.gvkey=r4.gvkey and a.fyear=r4.fyear+4
    left join work.history0 as r5 on a.gvkey=r5.gvkey and a.fyear=r5.fyear+5
    left join work.history0 as r6 on a.gvkey=r6.gvkey and a.fyear=r6.fyear+6
  where a.fyear between 1981 and 1988;
quit;

data work.compstack;
  length gvkey $7 formation fyear n_fit obs_id btm bc lc timefx eps rankok
         recon_error lc_formula_error 8;
  stop;
run;

%macro eqfit(fy=);
  data work.eqraw;
    set work.eqhist;
    where fyear between 1981 and &fy;
    if nmiss(of btm r0-r6)=0;
  run;
  proc sort data=work.eqraw; by gvkey fyear; run;
  proc sql;
    create table work.eqnfirm as
    select gvkey, count(*) as n_fit
    from work.eqraw group by gvkey
    having count(*)>=4;
  quit;
  proc sort data=work.eqnfirm; by gvkey; run;
  data work.eqkeep;
    merge work.eqraw(in=a) work.eqnfirm(in=b);
    by gvkey;
    if a and b;
  run;
  data work.eq&fy;
    set work.eqkeep;
    obs_id=_n_;
  run;

  proc sql;
    title "Eq. (4) rolling fit through &fy";
    select count(*) as n_fit, count(distinct gvkey) as n_firms,
           min(n_fit) as minimum_firm_observations
    from work.eq&fy;
  quit;

  ods listing close;
  ods output ParameterEstimates=work.pe&fy;
  proc glm data=work.eq&fy;
    class gvkey fyear;
    model btm=gvkey fyear / solution;
    output out=work.febase&fy(keep=obs_id fe_fit rb) p=fe_fit r=rb;
  quit;
  ods output close;
  ods listing;

  data work.firmpe&fy work.yearpe&fy;
    set work.pe&fy;
    length pname $12 pvalue $12;
    pname=upcase(scan(strip(Parameter),1,' '));
    pvalue=strip(scan(strip(Parameter),2,' '));
    if pname='GVKEY' then do;
      gvkey=pvalue;
      firm_est=Estimate;
      output work.firmpe&fy;
    end;
    else if pname='FYEAR' then do;
      fyear=input(pvalue,best32.);
      year_est=Estimate;
      output work.yearpe&fy;
    end;
  run;
  data _null_;
    set work.pe&fy;
    if upcase(strip(Parameter))='INTERCEPT' then
      call symputx(cats('int',"&fy"),Estimate,'G');
  run;

  proc sql;
    create table work.fcount&fy as
    select gvkey, count(*) as n_i
    from work.eq&fy group by gvkey;
    create table work.firmweighted&fy as
    select p.gvkey, p.firm_est, c.n_i
    from work.firmpe&fy as p inner join work.fcount&fy as c
      on p.gvkey=c.gvkey;
  quit;
  proc means data=work.firmweighted&fy noprint;
    weight n_i;
    var firm_est;
    output out=work.meanfirm&fy mean=mu;
  run;
  data _null_;
    set work.meanfirm&fy;
    call symputx(cats('mu',"&fy"),mu,'G');
  run;

  proc sort data=work.eq&fy; by obs_id; run;
  proc sort data=work.febase&fy; by obs_id; run;
  %do j=0 %to 6;
    proc glm data=work.eq&fy noprint;
      class gvkey fyear;
      model r&j=gvkey fyear;
      output out=work.projr&j._&fy(keep=obs_id prj&j) r=prj&j;
    quit;
    proc sort data=work.projr&j._&fy; by obs_id; run;
  %end;
  data work.proj&fy;
    merge work.eq&fy(in=a keep=obs_id gvkey fyear btm n_fit r0-r6)
          work.febase&fy(keep=obs_id fe_fit rb)
          %do j=0 %to 6; work.projr&j._&fy(keep=obs_id prj&j) %end;;
    by obs_id;
    if a;
  run;

  proc reg data=work.proj&fy noprint outest=work.coef&fy;
    model rb=prj0-prj6 / noint;
    output out=work.regout&fy p=lc r=eps;
  quit;
  %global rankok&fy;
  %let rankok&fy=0;
  data _null_;
    set work.coef&fy;
    if _TYPE_='PARMS' then
      call symputx(cats('rankok',"&fy"),
                   nmiss(prj0,prj1,prj2,prj3,prj4,prj5,prj6)=0,'G');
  run;
  data _null_;
    set work.coef&fy;
    if _TYPE_='PARMS' then do;
      call symputx(cats('b0',"&fy"),prj0,'G');
      call symputx(cats('b1',"&fy"),prj1,'G');
      call symputx(cats('b2',"&fy"),prj2,'G');
      call symputx(cats('b3',"&fy"),prj3,'G');
      call symputx(cats('b4',"&fy"),prj4,'G');
      call symputx(cats('b5',"&fy"),prj5,'G');
      call symputx(cats('b6',"&fy"),prj6,'G');
    end;
  run;

  proc sort data=work.regout&fy; by gvkey fyear; run;
  proc sql;
    create table work.components0&fy as
    select r.*, f.firm_est, y.year_est
    from work.regout&fy as r
      inner join work.firmweighted&fy as f on r.gvkey=f.gvkey
      inner join work.yearpe&fy as y on r.fyear=y.fyear;
  quit;
  data work.components&fy;
    set work.components0&fy;
    formation=&fy;
    bc=firm_est-&&mu&fy;
    timefx=year_est+&&int&fy+&&mu&fy;
    rankok=&&rankok&fy;
    lc_formula=&&b0&fy*prj0 + &&b1&fy*prj1 + &&b2&fy*prj2 +
               &&b3&fy*prj3 + &&b4&fy*prj4 + &&b5&fy*prj5 +
               &&b6&fy*prj6;
    recon_error=btm-(bc+timefx+lc+eps);
    lc_formula_error=lc-lc_formula;
    keep gvkey formation fyear n_fit obs_id btm bc lc timefx eps
         rankok recon_error lc_formula_error;
  run;

  proc sql;
    title "Eq. (4) component identity check, formation &fy";
    select count(*) as n, max(rankok) as rankok,
           sum(rankok ne 1) as n_rank_fail,
           sum(missing(lc_formula_error)) as n_lc_formula_missing,
           mean(bc) as mean_bc, mean(lc) as mean_lc,
           max(abs(recon_error)) as max_abs_btm_error,
           sum(abs(recon_error)>1e-8) as n_btm_fail,
           max(abs(lc_formula_error)) as max_lc_formula_error,
           sum(abs(lc_formula_error)>1e-8) as n_lc_fail
    from work.components&fy;
  quit;
  proc append base=work.compstack data=work.components&fy; run;
%mend;

%eqfit(fy=1984);
%eqfit(fy=1985);
%eqfit(fy=1986);
%eqfit(fy=1987);
%eqfit(fy=1988);

proc sql;
  title 'Formation-year FWL component means and decomposition checks';
  select formation, count(*) as n, max(rankok) as rankok,
         sum(rankok ne 1) as n_rank_fail,
         sum(missing(lc_formula_error)) as n_lc_formula_missing,
         mean(bc) as mean_bc,
         mean(lc) as mean_lc, max(abs(recon_error)) as max_abs_error,
         sum(abs(recon_error)>1e-8) as n_fail,
         sum(abs(lc_formula_error)>1e-8) as n_lc_fail
  from work.compstack group by formation order by formation;
  create table work.idcheck as
  select formation, max(rankok) as rankok,
         sum(rankok ne 1) as n_rank_fail,
         sum(missing(lc_formula_error)) as n_lc_formula_missing,
         mean(bc) as mean_bc, mean(lc) as mean_lc,
         max(abs(recon_error)) as max_abs_error,
         sum(abs(recon_error)>1e-8) as n_btm_fail,
         sum(abs(lc_formula_error)>1e-8) as n_lc_fail
  from work.compstack group by formation;
  select case when count(*)=5 and
       sum(rankok=1 and n_rank_fail=0 and n_lc_formula_missing=0 and
           n_btm_fail=0 and n_lc_fail=0 and
           abs(mean_bc)<=1e-8 and abs(mean_lc)<=1e-8)=count(*)
       then 1 else 0 end into :identity_global trimmed
  from work.idcheck;
quit;

proc sql;
  create table work.main0 as
  select c.gvkey, c.fyear, c.roe as roe0, c.btm,
         r1.roe as roe1, r2.roe as roe2, r3.roe as roe3,
         r4.roe as roe4, r5.roe as roe5,
         z.bc, z.lc, z.timefx, z.eps, z.recon_error,
         &identity_global as identity_pass,
         c.curcd, c.datadate, c.price_method
  from work.history0 as c
    inner join work.compstack as z
      on c.gvkey=z.gvkey and c.fyear=z.fyear and z.formation=c.fyear
    left join work.history0 as r1 on c.gvkey=r1.gvkey and r1.fyear=c.fyear+1
    left join work.history0 as r2 on c.gvkey=r2.gvkey and r2.fyear=c.fyear+2
    left join work.history0 as r3 on c.gvkey=r3.gvkey and r3.fyear=c.fyear+3
    left join work.history0 as r4 on c.gvkey=r4.gvkey and r4.fyear=c.fyear+4
    left join work.history0 as r5 on c.gvkey=r5.gvkey and r5.fyear=c.fyear+5
  where c.fyear between 1984 and 1988
    and not missing(c.roe) and not missing(c.btm)
    and not missing(r1.roe) and not missing(r2.roe)
    and not missing(r3.roe) and not missing(r4.roe)
    and not missing(r5.roe)
    and not missing(z.bc) and not missing(z.lc)
    and not missing(z.timefx) and not missing(z.eps);
  select count(*) as main_n, count(distinct gvkey) as main_firms,
         min(fyear) as first_formation, max(fyear) as last_formation,
         max(abs(recon_error)) as max_decomposition_error,
         sum(abs(recon_error)>1e-8) as n_decomposition_fail
  from work.main0;
quit;

data out.main;
  set work.main0;
  label roe0='Formation-year ROE'
        roe1='One-year-ahead ROE'
        roe2='Two-year-ahead ROE'
        roe3='Three-year-ahead ROE'
        roe4='Four-year-ahead ROE'
        roe5='Five-year-ahead ROE'
        bc='Centered firm bias component'
        lc='FWL lag component'
        timefx='Time effect component'
        eps='Equation (4) residual component';
  keep gvkey fyear roe0 btm roe1-roe5 bc lc timefx eps recon_error
       identity_pass;
run;

proc sort data=out.history; by gvkey fyear; run;
proc sort data=out.main; by gvkey fyear; run;
proc contents data=out.history varnum; run;
proc contents data=out.main varnum; run;
title;
