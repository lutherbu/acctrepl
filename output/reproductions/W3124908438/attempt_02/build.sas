options errorabend;

libname comp '/storage/sas/base/comp/d_na' access=readonly;
libname secmth '/storage/sas/base/comp/d_na/security' access=readonly;
libname crsp '/storage/sas/base/crsp/a_stock' access=readonly;
libname ccm '/storage/sas/base/crsp/a_ccm' access=readonly;
libname ibes '/storage/sas/base/ibes' access=readonly;
libname wrdsapps '/storage/sas/base/wrdsapps/linking/iclink' access=readonly;
libname out 'data';

/* The market calendar provides the trading-day sequence for event windows. */
data mkt0;
    set crsp.dsi(keep=date vwretd);
    where date between '01JAN1980'd and '31DEC2008'd;
    if vwretd in (-66,-77,-88,-99) then vwretd=.;
run;
proc sort data=mkt0; by date; run;
data market;
    set mkt0;
    if not missing(date);
    mseq+1;
    format date date9.;
run;

/* Use final, domestic, consolidated industrial annual rows, FYEAR 1982-2003.
   Item 6 AT cancels from the source NOA identity and is not required here. */
data fundraw;
    set comp.funda(keep=gvkey iid datadate fyear fyr indfmt consol popsrc datafmt upd
        sich curcd curncd dltt dlc ceq pstk mib che ivao oiadp sale epspx ajex prcc_f
        where=(fyear between 1982 and 2003 and indfmt='INDL' and consol='C'
        and popsrc='D' and datafmt='STD' and upd=3));
run;
proc sql;
    create table fcnt as
    select gvkey,fyear,count(*) as nrow
    from fundraw group by gvkey,fyear;
    create table fdup as select * from fcnt where nrow ne 1;
    select count(*) into :n_fraw trimmed from fundraw;
    select count(*) into :n_fdup trimmed from fdup;
    select sum(lengthn(strip(gvkey))>6),sum(missing(gvkey))
      into :n_gvlong trimmed,:n_gvmiss trimmed from fundraw;
    select put(min(datadate),date9.),put(max(datadate),date9.),
           min(fyear),max(fyear),min(year(datadate)),max(year(datadate))
      into :fmin trimmed,:fmax trimmed,:fymin trimmed,:fymax trimmed,
           :calmin trimmed,:calmax trimmed
      from fundraw;
quit;
%put NOTE: COMP rows=&n_fraw duplicate GVKEY-FYEAR keys=&n_fdup FYEAR=&fymin to &fymax actual DATADATE=&fmin to &fmax calendar-year endpoints=&calmin to &calmax.;
%put NOTE: selected COMP GVKEY source width=7 characters, observed key values longer than 6=&n_gvlong missing keys=&n_gvmiss.;
proc freq data=fundraw;
    tables curcd*curncd / missing;
run;
proc sql;
    select sum(not missing(curcd) and not missing(curncd) and curcd ne curncd),
           sum(missing(curncd))
      into :n_native_diff trimmed,:n_native_miss trimmed from fundraw;
quit;
%put NOTE: selected COMP reporting/native currency descriptor differences=&n_native_diff missing native codes=&n_native_miss.;
proc sql;
    create table fundone as
    select a.* from fundraw as a inner join fcnt as b
      on a.gvkey=b.gvkey and a.fyear=b.fyear
    where b.nrow=1;
quit;
data fundbase;
    set fundone;
    gvkey=strip(gvkey);
    iid=upcase(strip(iid));
    if nmiss(dltt,dlc,ceq,pstk,mib,che,ivao)=0 then
        noa=dltt+dlc+ceq+pstk+mib-che-ivao;
    else noa=.;
    label noa='Net operating assets';
run;

/* Verify the fiscal-year-end PRCC_F security price and its own currency on the
   same Compustat issue. Monthly matches use the same fiscal month and require
   the security close to equal PRCC_F; unresolved rows use only a close within
   seven calendar days, with the same GVKEY/IID and a unique daily currency. */
data pricekey;
    set fundbase(keep=gvkey iid fyear datadate prcc_f);
    where fyear between 1983 and 2001 and not missing(prcc_f)
       and not missing(iid);
run;
data secmonth;
    set secmth.sec_mthprc(keep=gvkey iid datadate prccm curcdm);
    where datadate between '01JAN1983'd and '31DEC2002'd;
    gvkey=strip(gvkey); iid=upcase(strip(iid)); curcdm=upcase(strip(curcdm));
run;
proc sql;
    create table pricem0 as
    select a.gvkey,a.iid,a.fyear,a.datadate,a.prcc_f,
           count(b.datadate) as mth_rows,
           count(distinct upcase(strip(b.curcdm))) as mth_ccy_n,
           min(upcase(strip(b.curcdm))) as mth_cur length=3,
           max(b.datadate) as mth_date format=date9.,
           min(abs(b.prccm-a.prcc_f)) as mth_gap
    from pricekey as a left join secmonth as b
      on a.gvkey=b.gvkey and a.iid=b.iid
     and b.datadate between intnx('month',a.datadate,0,'b')
                        and intnx('month',a.datadate,0,'e')
     and b.datadate<=a.datadate
    group by a.gvkey,a.iid,a.fyear,a.datadate,a.prcc_f;
    create table pricem as
    select *,case when mth_rows=1 and mth_ccy_n=1
                       and mth_gap<=max(1e-8,abs(prcc_f)*1e-6)
                  then 1 else 0 end as mth_ok
    from pricem0;
quit;
proc sql;
    select count(*) into :n_pricekey trimmed from pricekey;
    select sum(mth_ok=1),sum(mth_rows=0),sum(mth_rows>0 and mth_ok ne 1)
      into :n_pricem trimmed,:n_pricenom trimmed,:n_pricemiss trimmed
    from pricem;
quit;
%put NOTE: prior-year PRCC_F security price keys=&n_pricekey monthly price/currency matches=&n_pricem no monthly price row=&n_pricenom monthly price/currency unresolved=&n_pricemiss.;

/* CCM links are matched at the fiscal-year report date. Exact duplicate
   rows for the same PERMNO are collapsed before applying a priority rule;
   multiple highest-priority PERMNOs remain ambiguous and are not selected. */
proc sql;
    create table lraw as
    select f.gvkey,f.fyear,l.lpermno as permno,
           case when l.linkprim='P' then 4 else 0 end+
           case when l.linktype='LC' then 2 else 1 end as score
    from fundbase as f inner join ccm.ccmxpf_lnkhist as l
      on f.gvkey=l.gvkey
    where l.linktype in ('LC','LU') and l.linkprim in ('P','C')
      and not missing(l.lpermno) and l.linkdt<=f.datadate
      and (missing(l.linkenddt) or l.linkenddt>=f.datadate);
    create table lperm as
    select gvkey,fyear,permno,max(score) as score
    from lraw group by gvkey,fyear,permno;
    create table lbest as
    select gvkey,fyear,max(score) as score
    from lperm group by gvkey,fyear;
    create table lcnt as
    select a.gvkey,a.fyear,count(*) as nbest
    from lperm as a inner join lbest as b
      on a.gvkey=b.gvkey and a.fyear=b.fyear and a.score=b.score
    group by a.gvkey,a.fyear;
    create table linkone as
    select a.gvkey,a.fyear,a.permno
    from lperm as a inner join lbest as b
      on a.gvkey=b.gvkey and a.fyear=b.fyear and a.score=b.score
    inner join lcnt as c on a.gvkey=c.gvkey and a.fyear=c.fyear
    where c.nbest=1;
    select count(*) into :n_link trimmed from linkone;
    select count(*) into :n_lamb trimmed from lcnt where nbest>1;
quit;
%put NOTE: unique effective CCM matches=&n_link firm-years with tied top links=&n_lamb.;

proc sql;
    create table price_link as
    select a.*,l.permno
    from pricem as a left join linkone as l
      on a.gvkey=l.gvkey and a.fyear=l.fyear;
quit;
data price_unres;
    set price_link;
    if mth_ok ne 1 and not missing(permno);
    gv_bucket=substr(gvkey,1,1);
run;
proc sql noprint;
    select count(distinct gvkey) into :n_price_gv trimmed from price_unres;
    %let price_gv0=;
    %let price_gv1=;
    %let price_gv2=;
    %let price_gv3=;
    %let price_gv4=;
    %let price_gv5=;
    %let price_gv6=;
    %let price_gv7=;
    %let price_gv8=;
    %let price_gv9=;
    %macro price_lists;
      %do j=0 %to 9;
        select distinct quote(strip(gvkey)) into :price_gv&j separated by ','
        from price_unres where gv_bucket="&j";
      %end;
    %mend;
    %price_lists;
quit;
%put NOTE: indexed daily security-price fallback limited to &n_price_gv unresolved GVKEYs and seven prior calendar days.;
options msglevel=i;
%macro read_price_index;
  %do j=0 %to 9;
    %let keylist=&&price_gv&j;
    %if %length(%superq(keylist)) > 0 %then %do;
      data pricepart;
        set secmth.sec_dprc(keep=gvkey iid datadate curcdd prccd
            where=(gvkey in (&keylist)
              and datadate between '01JAN1983'd and '31DEC2002'd)
            idxname=gvkey);
        gvkey=strip(gvkey); iid=upcase(strip(iid)); curcdd=upcase(strip(curcdd));
      run;
      %if &j=0 %then %do;
        data price_day;
          set pricepart;
        run;
      %end;
      %else %do;
        proc append base=price_day data=pricepart force; run;
      %end;
    %end;
  %end;
%mend;
data price_day;
    length gvkey $7 iid $4 curcdd $4 datadate prccd 8;
    stop;
run;
%read_price_index;
options msglevel=n;
proc sql;
    create table pricedate0 as
    select a.gvkey,a.iid,a.fyear,a.datadate,a.prcc_f,
           max(b.datadate) as price_date format=date9.
    from price_unres as a left join price_day as b
      on a.gvkey=b.gvkey and a.iid=b.iid
     and b.datadate between a.datadate-7 and a.datadate
    group by a.gvkey,a.iid,a.fyear,a.datadate,a.prcc_f;
    create table priceday as
    select a.gvkey,a.iid,a.fyear,a.datadate,a.prcc_f,p.price_date,
           count(b.datadate) as day_rows,
           count(distinct upcase(strip(b.curcdd))) as day_ccy_n,
           min(upcase(strip(b.curcdd))) as day_cur length=3,
           min(abs(b.prccd-a.prcc_f)) as day_gap,
           a.datadate-p.price_date as price_age
    from price_unres as a left join pricedate0 as p
      on a.gvkey=p.gvkey and a.iid=p.iid and a.fyear=p.fyear
       and a.datadate=p.datadate
    left join price_day as b
      on a.gvkey=b.gvkey and a.iid=b.iid and p.price_date=b.datadate
    group by a.gvkey,a.iid,a.fyear,a.datadate,a.prcc_f,p.price_date;
    create table price_final as
    select a.gvkey,a.iid,a.fyear,a.datadate,a.prcc_f,
       case when a.mth_ok=1 then a.mth_cur
            when b.day_rows=1 and b.day_ccy_n=1 and b.price_age between 0 and 7
             and b.day_gap<=max(1e-8,abs(a.prcc_f)*1e-6) then b.day_cur
            else '' end as price_cur length=3,
       case when a.mth_ok=1 then 1
            when b.day_rows=1 and b.day_ccy_n=1 and b.price_age between 0 and 7
             and b.day_gap<=max(1e-8,abs(a.prcc_f)*1e-6) then 1
            else 0 end as price_ok,
       case when a.mth_ok=1 then a.mth_date else b.price_date end as price_date format=date9.,
       case when a.mth_ok=1 then 'MONTH'
            when b.day_rows=1 and b.day_ccy_n=1 and b.price_age between 0 and 7
             and b.day_gap<=max(1e-8,abs(a.prcc_f)*1e-6) then 'DAY_7'
            when missing(b.day_rows) or b.day_rows=0 then 'NO_DAILY_7'
            when b.day_ccy_n ne 1 then 'AMBIG_DAILY'
            when b.day_gap>max(1e-8,abs(a.prcc_f)*1e-6) then 'PRICE_MISMATCH'
            else 'UNRESOLVED' end as price_status length=16,
       case when a.mth_ok=1 then . else b.price_age end as price_age,
       a.mth_rows,a.mth_ccy_n,a.mth_gap,b.day_rows,b.day_ccy_n,b.day_gap
    from pricem as a left join priceday as b
      on a.gvkey=b.gvkey and a.iid=b.iid and a.fyear=b.fyear
       and a.datadate=b.datadate;
    create table fundprice as
    select a.*,p.price_cur,p.price_ok,p.price_date,p.price_status,p.price_age
    from fundbase as a left join price_final as p
      on a.gvkey=p.gvkey and a.iid=p.iid and a.fyear=p.fyear
       and a.datadate=p.datadate;
    select count(*) into :n_price_verified trimmed from price_final where price_ok=1;
    select count(*) into :n_price_unverified trimmed from price_final where price_ok ne 1;
quit;
%put NOTE: fiscal-year-end security prices verified=&n_price_verified unverified=&n_price_unverified, with monthly price/currency or same-issue daily price/currency within seven days.;
proc freq data=price_final;
    tables price_status*price_cur / missing;
run;

/* Exact FYEAR joins preserve gaps and retain the two-year lag and one-year
   lead needed for changes and future DuPont levels. */
proc sql;
    create table panel0 as
    select a.gvkey,a.fyear,a.datadate,a.sich,a.curcd,a.curncd,a.noa,a.sale,a.oiadp,
           a.iid as iid0,a.epspx,a.ajex,a.prcc_f,
           p.iid as iidm1,p.prcc_f as prccm1,p.price_cur as prccm1_cur,
           p.price_ok as prccm1_verified,p.price_date as prccm1_date,
           p.price_status as prccm1_price_status,p.price_age as prccm1_price_age,
           p.datadate as datam1,p.noa as noam1,p.sale as salem1,
           p.oiadp as opm1,p.epspx as epsm1,p.ajex as ajexm1,
           p.curcd as curm1,p.curncd as curnm1,
           q.datadate as datam2,q.noa as noam2,q.curcd as curm2,q.curncd as curnm2,
           n.datadate as datap1,n.noa as noap1,n.sale as salep1,
           n.oiadp as opp1,n.curcd as curp1,n.curncd as curnp1,
           l.permno,lp.permno as permm1
    from fundprice as a
    left join fundprice as p on a.gvkey=p.gvkey and p.fyear=a.fyear-1
    left join fundprice as q on a.gvkey=q.gvkey and q.fyear=a.fyear-2
    left join fundprice as n on a.gvkey=n.gvkey and n.fyear=a.fyear+1
    left join linkone as l on a.gvkey=l.gvkey and a.fyear=l.fyear
    left join linkone as lp on a.gvkey=lp.gvkey and lp.fyear=a.fyear-1
    where a.fyear between 1984 and 2002;
    select count(*) into :n_panel trimmed from panel0;
    select sum(missing(datam2)),sum(missing(datam1)),sum(missing(datap1)),
           put(min(datadate),date9.),put(max(datadate),date9.),
           put(min(datap1),date9.),put(max(datap1),date9.),
           min(fyear),max(fyear)
      into :n_m2 trimmed,:n_m1 trimmed,:n_p1 trimmed,
           :pmin trimmed,:pmax trimmed,:leadmin trimmed,:leadmax trimmed,
           :pyearmin trimmed,:pyearmax trimmed from panel0;
quit;
%put NOTE: target panel=&n_panel absent FYEAR-2 rows=&n_m2 FYEAR-1=&n_m1 FYEAR+1=&n_p1.;
%put NOTE: target actual DATADATE=&pmin to &pmax, final lead DATADATE=&leadmin to &leadmax for FYEAR=&pyearmin to &pyearmax.;
proc sql;
    create table permset as select distinct permno from panel0 where not missing(permno);
quit;

/* Preserve product-specific I/B/E/S currency fields and inspect their raw
   values before requiring exact currency matches. USFIRM is a source flag,
   not a domicile or currency code. */
data actraw;
    set ibes.actu_epsus(keep=ticker pends measure pdicity anndats actdats value
        curr_act usfirm
        where=(measure='EPS' and pdicity='ANN' and usfirm=1
        and pends between '01JAN1982'd and '31DEC2005'd));
run;
proc freq data=actraw;
    tables curr_act*usfirm / missing;
run;
proc sql;
    create table ticset as
    select distinct h.ticker
    from wrdsapps.ibcrsphist as h inner join permset as p on h.permno=p.permno
    where h.sdate<='31DEC2005'd and (missing(h.edate) or h.edate>='01JAN1980'd);
    select count(*) into :n_tics trimmed from ticset;
    create table sumraw as
    select s.ticker,s.statpers,s.measure,s.fiscalp,s.fpi,s.curcode,
           s.medest,s.fpedats,s.usfirm
    from ibes.statsumu_epsus as s
    where s.ticker in (select t.ticker from ticset as t)
      and s.measure='EPS' and s.fiscalp='ANN' and s.fpi in ('1','2')
      and s.usfirm=1 and s.statpers between '01JAN1980'd and '31DEC2005'd
      and s.fpedats between '01JAN1982'd and '31DEC2005'd;
    select count(*) into :n_sraw trimmed from sumraw;
quit;
%put NOTE: sample-linked I/B/E/S tickers=&n_tics summary rows=&n_sraw.;
proc freq data=sumraw;
    tables curcode*fpi / missing;
run;
proc datasets lib=work nolist;
    delete ticset;
quit;

/* Actual event rows: link the smaller actual table to active PERMNOs first,
   then match exact period end and the same CCM PERMNO. */
proc sql;
    create table actlinked as
    select distinct a.ticker,a.pends,a.anndats,a.actdats,a.value,a.curr_act,h.permno
    from actraw as a inner join wrdsapps.ibcrsphist as h on a.ticker=h.ticker
      and h.sdate<=a.anndats and (missing(h.edate) or h.edate>=a.anndats)
    where not missing(a.anndats) and not missing(a.actdats)
      and not missing(a.value);
    create table actmap as
    select distinct p.gvkey,p.fyear,p.curcd,p.permno,a.ticker,a.pends,
           a.anndats,a.actdats,a.value,a.curr_act
    from panel0 as p inner join actlinked as a
      on p.datadate=a.pends and p.permno=a.permno;
quit;
data actmatch;
    set actmap;
    if not missing(curr_act) and not missing(curcd) and
       upcase(strip(curr_act))=upcase(strip(curcd));
run;
proc sql;
    create table annpick as
    select gvkey,fyear,min(anndats) as ann_date
    from actmatch group by gvkey,fyear;
    create table actpick as
    select a.gvkey,a.fyear,a.ann_date,min(m.actdats) as actdate
    from annpick as a inner join actmatch as m
      on a.gvkey=m.gvkey and a.fyear=m.fyear and a.ann_date=m.anndats
    where m.actdats>=a.ann_date
    group by a.gvkey,a.fyear,a.ann_date;
    create table actsel0 as
    select m.* from actmatch as m inner join actpick as p
      on m.gvkey=p.gvkey and m.fyear=p.fyear and m.anndats=p.ann_date
      and m.actdats=p.actdate;
    create table actcnt as
    select gvkey,fyear,count(*) as nact
    from actsel0 group by gvkey,fyear;
    create table actsel as
    select a.*,a.anndats as ann_date from actsel0 as a inner join actcnt as c
      on a.gvkey=c.gvkey and a.fyear=c.fyear
    where c.nact=1;
    select count(*) into :n_act trimmed from actsel;
    select count(*) into :n_actamb trimmed from actcnt where nact>1;
quit;
%put NOTE: unique currency-matched I/B/E/S actual-event rows=&n_act ambiguous selected actuals=&n_actamb.;
proc datasets lib=work nolist;
    delete actraw actlinked actmap actmatch annpick actpick actsel0 actcnt;
quit;

/* Forecast period ends, rather than a fixed FPI rank around a report, identify
   the fiscal year. FPI is retained for diagnostics because its rank rolls after
   the current year is reported. */
proc sql;
    create table sumlink as
    select s.ticker,s.statpers,s.measure,s.fiscalp,s.fpi,s.curcode,
           s.medest,s.fpedats,s.usfirm,h.permno
    from sumraw as s inner join wrdsapps.ibcrsphist as h on s.ticker=h.ticker
      and h.sdate<=s.statpers and (missing(h.edate) or h.edate>=s.statpers);
    create table smap0 as
    select distinct p.gvkey,p.fyear,p.permno,p.curcd,a.ann_date,
           case when s.fpedats=p.datadate then 'T' else 'N' end as target length=1,
           s.ticker,s.statpers,s.fpedats,s.fpi,s.curcode,s.medest
    from panel0 as p inner join actsel as a
      on p.gvkey=a.gvkey and p.fyear=a.fyear
    inner join sumlink as s on s.permno=p.permno
      and (s.fpedats=p.datadate or (not missing(p.datap1) and s.fpedats=p.datap1))
    where not missing(s.statpers) and not missing(s.medest)
      and not missing(s.curcode) and not missing(p.curcd)
      and upcase(strip(s.curcode))=upcase(strip(p.curcd));
    create table smapcnt as
    select gvkey,fyear,target,statpers,count(*) as nsum
    from smap0 group by gvkey,fyear,target,statpers;
    create table smap as
    select a.* from smap0 as a inner join smapcnt as b
      on a.gvkey=b.gvkey and a.fyear=b.fyear and a.target=b.target
      and a.statpers=b.statpers
    where b.nsum=1;
    /* Table 8 describes consensus in the month immediately before and after
       ANNDATS. STATPERS is monthly, so for year t+1 only retain the nearest
       strictly pre/post summary within one calendar-month boundary. Current
       year consensus for SUR remains the most recent pre-announcement record. */
    create table spre as
    select s.gvkey,s.fyear,s.target,max(s.statpers) as statpers
    from smap as s inner join actsel as a
      on s.gvkey=a.gvkey and s.fyear=a.fyear
    where s.statpers<a.ann_date
      and (s.target='T' or intck('month',s.statpers,a.ann_date)<=1)
    group by s.gvkey,s.fyear,s.target;
    create table spost as
    select s.gvkey,s.fyear,min(s.statpers) as statpers
    from smap as s inner join actsel as a
      on s.gvkey=a.gvkey and s.fyear=a.fyear
    where s.target='N' and s.statpers>a.ann_date
      and intck('month',a.ann_date,s.statpers)<=1
    group by s.gvkey,s.fyear;
    create table spreval as
    select p.gvkey,p.fyear,p.target,p.statpers,s.medest,s.curcode,s.fpi
    from spre as p inner join smap as s
      on p.gvkey=s.gvkey and p.fyear=s.fyear and p.target=s.target
      and p.statpers=s.statpers;
    create table spostval as
    select p.gvkey,p.fyear,p.statpers,s.medest,s.curcode,s.fpi
    from spost as p inner join smap as s
      on p.gvkey=s.gvkey and p.fyear=s.fyear and s.target='N'
      and p.statpers=s.statpers;
    create table forewide as
    select p.gvkey,p.fyear,
      max(case when x.target='T' then x.medest end) as med_t,
      max(case when x.target='T' then x.statpers end) as stat_t,
      max(case when x.target='T' then x.curcode end) as cur_t length=3,
      max(case when x.target='N' then x.medest end) as med_npre,
      max(case when x.target='N' then x.statpers end) as stat_npre,
      max(case when x.target='N' then x.curcode end) as cur_npre length=3,
      max(y.medest) as med_npost,max(y.statpers) as stat_npost,
      max(y.curcode) as cur_npost length=3
    from panel0 as p left join spreval as x
      on p.gvkey=x.gvkey and p.fyear=x.fyear
    left join spostval as y on p.gvkey=y.gvkey and p.fyear=y.fyear
    group by p.gvkey,p.fyear;
    select count(*) into :n_samb trimmed from smapcnt where nsum>1;
quit;
%put NOTE: I/B/E/S selected period-date duplicates excluded=&n_samb.;
proc datasets lib=work nolist;
    delete sumraw sumlink smap0 smapcnt smap spre spost spreval spostval;
quit;

/* Build the sampled PERMNO population and retain raw daily factor rows for
   returns, event dating, and relative I/B/E/S adjustment factors. */
proc sql;
    create table dsfsub as
    select d.permno,d.date,d.ret,d.cfacshr,d.hexcd
    from crsp.dsf as d inner join permset as p on d.permno=p.permno
    where d.date between '01JAN1980'd and '31DEC2008'd;
    create table delraw as
    select d.permno,d.dlstdt,d.dlret,d.dlstcd,d.hexcd
    from crsp.dsedelist as d inner join permset as p on d.permno=p.permno
    where d.dlstdt between '01JAN1980'd and '31DEC2008'd;
    create table delcnt as
    select permno,dlstdt,count(*) as ndel
    from delraw group by permno,dlstdt;
    create table deluniq as
    select a.* from delraw as a inner join delcnt as b
      on a.permno=b.permno and a.dlstdt=b.dlstdt where b.ndel=1;
    select count(*) into :n_dsf trimmed from dsfsub;
    select count(*) into :n_delamb trimmed from delcnt where ndel>1;
    select put(min(date),date9.),put(max(date),date9.),
           min(year(date)),max(year(date))
      into :dmin trimmed,:dmax trimmed,:dcalmin trimmed,:dcalmax trimmed
      from dsfsub;
quit;
%put NOTE: sampled CRSP DSF rows=&n_dsf delisting-date duplicates=&n_delamb actual date range=&dmin to &dmax calendar years=&dcalmin to &dcalmax.;

/* CRSP special missing codes are unavailable, not returns. When CRSP omits a
   delisting return for the paper's specified poor-performance codes, use its
   NYSE/AMEX and Nasdaq imputation; other missing delisting returns stay missing. */
proc sql;
    create table ret0 as
    select d.permno,d.date,d.ret,d.cfacshr,
           l.dlret,l.dlstcd,l.dlstdt,d.hexcd as hexcd,
           case when not missing(l.dlstdt) then 1 else 0 end as isdel
    from dsfsub as d left join deluniq as l
      on d.permno=l.permno and d.date=l.dlstdt
    union corr
    select l.permno,l.dlstdt as date,.
           as ret, . as cfacshr,l.dlret,l.dlstcd,l.dlstdt,l.hexcd as hexcd,1 as isdel
    from deluniq as l left join dsfsub as d
      on l.permno=d.permno and l.dlstdt=d.date
    where missing(d.permno);
quit;
data retbase;
    set ret0;
    badret=(ret in (-66,-77,-88,-99));
    baddel=(dlret in (-66,-77,-88,-99));
    if badret then ret=.;
    if baddel then dlret=.;
    if missing(dlret) and (dlstcd=500 or (dlstcd>=520 and dlstcd<=584)) then do;
        if hexcd in (1,2) then dlret=-0.35;
        else if hexcd=3 then dlret=-0.55;
    end;
    if not missing(ret) and not missing(dlret) then
        retadj=(1+ret)*(1+dlret)-1;
    else if missing(ret) and not missing(dlret) then retadj=dlret;
    else if not missing(ret) then retadj=ret;
    else retadj=.;
    format date dlstdt date9.;
run;
proc sql;
    create table retday as
    select r.*,m.vwretd
    from retbase as r left join market as m on r.date=m.date;
    select put(min(date),date9.),put(max(date),date9.),
           sum(badret),sum(baddel),sum(missing(cfacshr))
      into :rmin trimmed,:rmax trimmed,:nbadret trimmed,:nbaddel trimmed,
           :nfacmiss trimmed from retbase;
quit;
%put NOTE: CRSP return-date support=&rmin to &rmax special DSF returns=&nbadret special DLRET values=&nbaddel missing share factors=&nfacmiss.;
proc sort data=retday; by permno date; run;

/* Annual R_t and the common future-CRSP eligibility window. A delisted
   security's proceeds are reinvested in the value-weighted market return after
   the delisting date, as described in the paper's future-return footnote. */
data win0;
    set panel0(keep=gvkey fyear permno datadate);
    length wid 8;
    wid=1; wstart=intnx('month',datadate,-11,'b'); wend=datadate; output;
    /* Four complete calendar months elapse after FY end before the
       one-year future return window begins. For 31DEC, start is 01MAY. */
    wid=2; wstart=intnx('month',datadate,5,'b');
    wend=intnx('month',wstart,11,'e'); output;
    format wstart wend date9.;
    keep gvkey fyear permno wid wstart wend;
run;
proc sql;
    create table windays as
    select w.gvkey,w.fyear,w.permno,w.wid,m.date,m.vwretd,
           r.retadj,r.isdel
    from win0 as w inner join market as m
      on m.date between w.wstart and w.wend
    left join retday as r on w.permno=r.permno and m.date=r.date;
quit;
proc sort data=windays; by gvkey fyear wid date; run;
data winout;
    set windays;
    by gvkey fyear wid date;
    retain pstock pmkt ndays nmiss delhit;
    if first.wid then do;
        pstock=1; pmkt=1; ndays=0; nmiss=0; delhit=0;
    end;
    if delhit then rx=vwretd; else rx=retadj;
    ndays+1;
    if missing(rx) or rx < -1 then nmiss+1;
    else pstock=pstock*(1+rx);
    if missing(vwretd) or vwretd < -1 then nmiss+1;
    else pmkt=pmkt*(1+vwretd);
    if isdel=1 then delhit=1;
    if last.wid then do;
        if ndays>0 and nmiss=0 then bhm=pstock-pmkt;
        else bhm=.;
        output;
    end;
    keep gvkey fyear wid bhm ndays nmiss;
run;
proc sql;
    create table winwide as
    select gvkey,fyear,
           max(case when wid=1 then bhm end) as rt,
           max(case when wid=2 then bhm end) as rfut,
           max(case when wid=1 then ndays end) as nday_t,
           max(case when wid=2 then ndays end) as nday_f
    from winout group by gvkey,fyear;
quit;

/* Two trading sessions before through two after the first market session on
   or after ANNDATS; incomplete five-day windows remain missing. */
proc sql;
    create table evcenter as
    select a.gvkey,a.fyear,a.permno,a.ann_date,min(m.date) as cdate
    from actsel as a inner join market as m on m.date>=a.ann_date
    group by a.gvkey,a.fyear,a.permno,a.ann_date;
    create table evseq as
    select e.*,m.mseq as cseq
    from evcenter as e inner join market as m on e.cdate=m.date;
    create table evdays as
    select e.gvkey,e.fyear,e.permno,e.ann_date,m.date,m.vwretd,
           r.retadj,r.isdel
    from evseq as e inner join market as m
      on m.mseq between e.cseq-2 and e.cseq+2
    left join retday as r on e.permno=r.permno and m.date=r.date;
quit;
proc sort data=evdays; by gvkey fyear date; run;
data urout;
    set evdays;
    by gvkey fyear date;
    retain pstock pmkt ndays nmiss delhit;
    if first.fyear then do;
        pstock=1; pmkt=1; ndays=0; nmiss=0; delhit=0;
    end;
    if delhit then rx=vwretd; else rx=retadj;
    ndays+1;
    if missing(rx) or rx < -1 then nmiss+1;
    else pstock=pstock*(1+rx);
    if missing(vwretd) or vwretd < -1 then nmiss+1;
    else pmkt=pmkt*(1+vwretd);
    if isdel=1 then delhit=1;
    if last.fyear then do;
        if ndays=5 and nmiss=0 then ur=pstock-pmkt;
        else ur=.;
        output;
    end;
    keep gvkey fyear ur ndays nmiss;
run;

/* Annual accounting ratios, earnings, and changes. The denominator for EARN,
   ΔEARN, SUR, and ANREV is explicitly PRCC_F(t-1), with the Compustat prior
   issue/date and price-currency match retained on the panel. */
proc sql;
    create table stage0 as
    select p.*,a.ann_date,a.value as actual_eps,a.curr_act,
           f.med_t,f.stat_t,f.cur_t,f.med_npre,f.stat_npre,f.cur_npre,
           f.med_npost,f.stat_npost,f.cur_npost,
           w.rt,w.rfut,w.nday_t,w.nday_f,u.ur
    from panel0 as p left join actsel as a
      on p.gvkey=a.gvkey and p.fyear=a.fyear
    left join forewide as f on p.gvkey=f.gvkey and p.fyear=f.fyear
    left join winwide as w on p.gvkey=w.gvkey and p.fyear=w.fyear
    left join urout as u on p.gvkey=u.gvkey and p.fyear=u.fyear;
quit;
data stage1;
    set stage0;
    if nmiss(noa,noam1)=0 then avgt=(noa+noam1)/2;
    if not missing(avgt) and avgt ne 0 and not missing(oiadp) then rnoa=oiadp/avgt;
    if not missing(sale) and sale ne 0 and not missing(oiadp) then pm=oiadp/sale;
    if not missing(avgt) and avgt ne 0 and not missing(sale) then ato=sale/avgt;
    if nmiss(noam1,noam2)=0 then avgm1=(noam1+noam2)/2;
    if not missing(avgm1) and avgm1 ne 0 and not missing(opm1) then rnoam1=opm1/avgm1;
    if not missing(salem1) and salem1 ne 0 and not missing(opm1) then pmm1=opm1/salem1;
    if not missing(avgm1) and avgm1 ne 0 and not missing(salem1) then atom1=salem1/avgm1;
    if not missing(rnoa) and not missing(rnoam1) then drnoa=rnoa-rnoam1;
    if not missing(pm) and not missing(pmm1) then dpm=pm-pmm1;
    if not missing(ato) and not missing(atom1) then dato=ato-atom1;
    if nmiss(noa,noap1)=0 then avgp1=(noa+noap1)/2;
    if not missing(avgp1) and avgp1 ne 0 and not missing(opp1) then rnoap1=opp1/avgp1;
    if not missing(salep1) and salep1 ne 0 and not missing(opp1) then pmp1=opp1/salep1;
    if not missing(avgp1) and avgp1 ne 0 and not missing(salep1) then atop1=salep1/avgp1;
    if not missing(ajex) and ajex>0 and not missing(ajexm1) and ajexm1>0
       and not missing(epspx) and not missing(epsm1)
       and not missing(prccm1) and prccm1>0 then do;
        eps_basis=(epspx/ajex)*ajexm1;
         earn=eps_basis/prccm1;
         dearn=(eps_basis-epsm1)/prccm1;
    end;
    currency_ok=(not missing(curcd) and curcd=curm1 and curcd=curm2 and curcd=curp1 and
        not missing(prccm1_verified) and prccm1_verified=1 and
        not missing(prccm1_cur) and prccm1_cur=curm1);
    share_issue_ok=(not missing(permno) and not missing(permm1) and
        permno=permm1 and not missing(iid0) and iid0=iidm1);
    label rnoa='Return on net operating assets'
          drnoa='Change in RNOA' pm='Profit margin' ato='Asset turnover'
          dpm='Change in profit margin' dato='Change in asset turnover'
          rnoap1='Future RNOA' pmp1='Future profit margin'
          atop1='Future asset turnover' earn='Earnings scaled by prior price'
          dearn='Change in earnings scaled by prior price';
run;

/* Relative CRSP CFACSHR values place each unadjusted I/B/E/S value on the
   prior-price date's share basis. The conversion is anchor CFACSHR divided by
   source-date CFACSHR; each factor is from the same PERMNO/issue and uses the
   latest CRSP observation on or before its source date. */
data facneed;
    set stage1;
    length tag $8;
    if not missing(datam1) then do; tag='PRICE'; needdate=datam1; output; end;
    if not missing(ann_date) then do; tag='ACT'; needdate=ann_date; output; end;
    if not missing(stat_t) then do; tag='F_T'; needdate=stat_t; output; end;
    if not missing(stat_npre) then do; tag='F_NPRE'; needdate=stat_npre; output; end;
    if not missing(stat_npost) then do; tag='F_NPOST'; needdate=stat_npost; output; end;
    format needdate date9.;
    keep gvkey fyear permno tag needdate;
run;
data facstack;
    length gvkey $7 tag $8 type 8;
    set dsfsub(in=isd keep=permno date cfacshr)
        facneed(in=ist rename=(needdate=date));
    if isd then do; type=1; call missing(gvkey,fyear,tag); end;
    else type=2;
run;
proc sort data=facstack; by permno date type; run;
data facout;
    set facstack;
    by permno;
    retain lastfac;
    if first.permno then lastfac=.;
    if type=1 then do;
        if not missing(cfacshr) then lastfac=cfacshr;
    end;
    else do;
        cfac=lastfac;
        output;
    end;
    keep gvkey fyear tag cfac;
run;
proc sql;
    create table facwide as
    select gvkey,fyear,
      max(case when tag='PRICE' then cfac end) as fac_price,
      max(case when tag='ACT' then cfac end) as fac_act,
      max(case when tag='F_T' then cfac end) as fac_t,
      max(case when tag='F_NPRE' then cfac end) as fac_npre,
      max(case when tag='F_NPOST' then cfac end) as fac_npost
    from facout group by gvkey,fyear;
quit;
proc sort data=stage1; by gvkey fyear; run;
proc sort data=facwide; by gvkey fyear; run;
data stage2raw;
    merge stage1(in=a) facwide;
    by gvkey fyear;
    if a;
    if not missing(actual_eps) and not missing(med_t) and
       not missing(fac_act) and fac_act ne 0 and not missing(fac_t) and fac_t ne 0
       and not missing(fac_price) and not missing(prccm1) and prccm1>0 then
        sur=((actual_eps*fac_price/fac_act)-(med_t*fac_price/fac_t))/prccm1;
    if not missing(med_npre) and not missing(med_npost) and
       not missing(fac_npre) and fac_npre ne 0 and not missing(fac_npost) and fac_npost ne 0
       and not missing(fac_price) and not missing(prccm1) and prccm1>0 then
        anrev=((med_npost*fac_price/fac_npost)-(med_npre*fac_price/fac_npre))/prccm1;
    label sur='Unexpected annual EPS scaled by prior price'
          anrev='Change in next-year EPS forecast scaled by prior price';
run;
/* The paper says to exclude SIC 6000-6999 but does not identify the SIC
   source. Preserve Compustat historical SIC when valid; only if it is absent,
   use the unique CRSP security-name classification effective on DATADATE for
   the same primary PERMNO. CRSP documents SICCD zero as missing and valid SIC
   codes as 100-9999. */
data sic_target;
    set stage2raw(keep=gvkey fyear datadate permno);
    where fyear between 1984 and 2002;
run;
proc sql noprint;
    select put(min(datadate),best.),put(max(datadate),best.)
      into :sicmind trimmed,:sicmaxd trimmed from sic_target;
quit;
%put NOTE: dated CRSP SIC mapping target DATADATE=&sicmind to &sicmaxd, unique PERMNO/name-period only.;
data sicnames0;
    set crsp.dsenames(keep=permno namedt nameendt siccd
                      where=(namedt<=&sicmaxd and nameendt>=&sicmind));
run;
proc sql;
    create table sic_key as
    select a.gvkey,a.fyear,a.datadate,a.permno,count(n.permno) as sic_name_rows,
       count(distinct n.siccd) as sic_name_codes,min(n.siccd) as crsp_sic
    from sic_target as a left join sicnames0 as n
      on a.permno=n.permno and a.datadate between n.namedt and n.nameendt
    group by a.gvkey,a.fyear,a.datadate,a.permno;
quit;
proc sort data=stage2raw; by gvkey fyear datadate permno; run;
proc sort data=sic_key; by gvkey fyear datadate permno; run;
data stage2;
    merge stage2raw(in=a) sic_key;
    by gvkey fyear datadate permno;
    if a;
    length sic_source $4;
    comp_sic_valid=(not missing(sich) and sich>=100 and sich<=9999);
    crsp_sic_valid=(sic_name_rows=1 and sic_name_codes=1 and not missing(crsp_sic)
                    and crsp_sic>=100 and crsp_sic<=9999);
    sic_both_valid=(comp_sic_valid and crsp_sic_valid);
    sic_exact_agree=(sic_both_valid and sich=crsp_sic);
    sic_exact_disagree=(sic_both_valid and sich ne crsp_sic);
    sic_comp_fin=(sich>=6000 and sich<=6999);
    sic_crsp_fin=(crsp_sic>=6000 and crsp_sic<=6999);
    sic_finclass_agree=(sic_both_valid and sic_comp_fin=sic_crsp_fin);
    sic_finclass_disagree=(sic_both_valid and sic_comp_fin ne sic_crsp_fin);
    if comp_sic_valid then do;
        sic_screen=sich;
        sic_source='COMP';
    end;
    else if crsp_sic_valid then do;
        sic_screen=crsp_sic;
        sic_source='CRSP';
    end;
    else do;
        sic_screen=.;
        sic_source='NONE';
    end;
run;

/* Preserve attrition and distinguish missing supporting periods from missing
   source values. The published aggregate N is a comparison only. */
proc sql;
    select count(*) into :n_stage trimmed from stage2;
    select sum(missing(permno)),sum(missing(ann_date)),sum(missing(med_t)),
            sum(missing(med_npre)),sum(missing(med_npost)),sum(missing(rt)),
             sum(missing(ur)),sum(missing(rfut)),sum(currency_ok=0),sum(share_issue_ok=0),
             sum(missing(permm1)),
             sum(not missing(permno) and not missing(permm1) and permno ne permm1),
             sum(missing(iidm1)),
             sum(not missing(iid0) and not missing(iidm1) and iid0 ne iidm1),
             sum(missing(prccm1_verified) or prccm1_verified ne 1),
             sum(not missing(prccm1_cur) and not missing(curm1) and prccm1_cur ne curm1),
             sum(not missing(curcd) and not missing(curncd) and curcd ne curncd),
           sum(noa<0),sum(oiadp<0),sum(sich>=6000 and sich<=6999),
           sum(missing(sich)),sum(sic_source='CRSP'),sum(sic_source='NONE'),
           sum(sic_name_rows=1),sum(sic_name_rows>1),sum(sic_both_valid),
           sum(sic_exact_agree),sum(sic_exact_disagree),
           sum(sic_finclass_agree),sum(sic_finclass_disagree)
      into :n_nolink trimmed,:n_noann trimmed,:n_not trimmed,
            :n_nnp trimmed,:n_npost trimmed,:n_nrt trimmed,:n_nur trimmed,
             :n_nrf trimmed,:n_cur trimmed,:n_issue trimmed,:n_prevlinkmiss trimmed,
             :n_permdiff trimmed,:n_iidmiss trimmed,:n_iiddiff trimmed,:n_priceunv trimmed,
             :n_priceccymis trimmed,:n_native_diff trimmed,:n_negnoa trimmed,:n_negop trimmed,
           :n_fin trimmed,:n_sichmiss trimmed,:n_sicfill trimmed,:n_sicunverified trimmed,
           :n_sicunique trimmed,:n_sicmulti trimmed,:n_sicboth trimmed,
           :n_sicagree trimmed,:n_sicdisagree trimmed,
           :n_sicclassagree trimmed,:n_sicclassdisagree trimmed from stage2;
quit;
%put NOTE: stage2 rows=&n_stage no CCM link=&n_nolink no actual event=&n_noann no current forecast=&n_not no future-period pre/post forecasts=&n_nnp/&n_npost missing R/UR/future CRSP=&n_nrt/&n_nur/&n_nrf currency mismatch=&n_cur share-issue screen failures=&n_issue prior-link missing=&n_prevlinkmiss PERMNO changes=&n_permdiff prior-IID missing=&n_iidmiss IID changes=&n_iiddiff unverified prior price=&n_priceunv prior price/reporting-currency mismatch=&n_priceccymis reporting/native currency descriptor differs=&n_native_diff negative current NOA/operating income=&n_negnoa/&n_negop missing SICH=&n_sichmiss CRSP SIC fallback=&n_sicfill SIC unavailable=&n_sicunverified unique names=&n_sicunique multiple names=&n_sicmulti overlap=&n_sicboth exact agreement/disagreement=&n_sicagree/&n_sicdisagree financial-class agreement/disagreement=&n_sicclassagree/&n_sicclassdisagree.;
/* Diagnose the sparse first cohorts before deciding which annual cross-sections
   the installed Newey-West Fama-MacBeth command can estimate. */
proc sql;
    create table year_support as
    select fyear, count(*) as n_stage2,
      sum(not missing(ann_date)) as n_announcement,
      sum(not missing(actual_eps)) as n_actual,
      sum(not missing(curr_act)) as n_actual_currency,
      sum(not missing(actual_eps) and not missing(curcd) and
          upcase(strip(curr_act))=upcase(strip(curcd))) as n_actual_currency_match,
      sum(not missing(med_t)) as n_current_median,
      sum(not missing(cur_t)) as n_current_currency,
      sum(not missing(med_t) and not missing(curcd) and
          upcase(strip(cur_t))=upcase(strip(curcd))) as n_current_currency_match,
      sum(not missing(med_npre)) as n_next_pre_median,
      sum(not missing(cur_npre)) as n_next_pre_currency,
      sum(not missing(med_npost)) as n_next_post_median,
      sum(not missing(cur_npost)) as n_next_post_currency,
      sum(not missing(permno)) as n_ccm_link,
      sum(not missing(permm1)) as n_prior_ccm_link,
      sum(not missing(prccm1_verified) and prccm1_verified=1) as n_prior_price_verified,
      sum(currency_ok=1) as n_currency_ok,
      sum(share_issue_ok=1) as n_share_issue_ok,
      sum(not missing(rt)) as n_rt,
      sum(not missing(ur)) as n_ur,
      sum(not missing(rfut)) as n_rfut,
      sum(not missing(earn)) as n_earn,
      sum(not missing(sur)) as n_sur,
      sum(not missing(anrev)) as n_anrev,
      sum(nmiss(rnoa,drnoa,pm,ato,dpm,dato,rnoap1,pmp1,atop1)=0) as n_du_pont_complete,
      sum(missing(sich)) as n_sich_missing,
      sum(sic_source='CRSP') as n_crsp_sic_filled,
      sum(sic_source='NONE') as n_sic_unavailable,
      sum(sic_both_valid) as n_sic_overlap,
      sum(sic_exact_agree) as n_sic_exact_agree,
      sum(sic_exact_disagree) as n_sic_exact_disagree,
      sum(sic_finclass_agree) as n_sic_class_agree,
      sum(sic_finclass_disagree) as n_sic_class_disagree
    from stage2 where fyear between 1984 and 2002
    group by fyear order by fyear;
quit;
data _null_;
    set year_support;
    putlog 'SOURCE FYEAR=' fyear 4. ' stage2=' n_stage2 8.
       ' announcement=' n_announcement 8. ' actual=' n_actual 8.
       ' actual_currency=' n_actual_currency 8. ' actual_currency_match=' n_actual_currency_match 8.;
    putlog 'FORECAST FYEAR=' fyear 4. ' current_mean=' n_current_median 8.
       ' current_currency=' n_current_currency 8. ' current_currency_match=' n_current_currency_match 8.
       ' next_pre_mean=' n_next_pre_median 8. ' next_pre_currency=' n_next_pre_currency 8.
       ' next_post_mean=' n_next_post_median 8. ' next_post_currency=' n_next_post_currency 8.;
    putlog 'LINK FYEAR=' fyear 4. ' current_CCM=' n_ccm_link 8. ' prior_CCM=' n_prior_ccm_link 8.
       ' verified_prior_price=' n_prior_price_verified 8. ' currency_ok=' n_currency_ok 8.
       ' share_issue_ok=' n_share_issue_ok 8. ' DuPont_complete=' n_du_pont_complete 8.;
    putlog 'SIC FYEAR=' fyear 4. ' SICH_missing=' n_sich_missing 8.
       ' CRSP_filled=' n_crsp_sic_filled 8. ' SIC_unavailable=' n_sic_unavailable 8.
       ' overlap=' n_sic_overlap 8. ' exact_agree=' n_sic_exact_agree 8.
       ' exact_disagree=' n_sic_exact_disagree 8.;
    putlog 'SIC_CLASS FYEAR=' fyear 4. ' agree=' n_sic_class_agree 8.
       ' disagree=' n_sic_class_disagree 8.;
    putlog 'OUTCOME FYEAR=' fyear 4. ' rt=' n_rt 8. ' ur=' n_ur 8. ' rfut=' n_rfut 8.
       ' earn=' n_earn 8. ' sur=' n_sur 8. ' anrev=' n_anrev 8.;
run;
proc sql;
    create table year_screen as
    select fyear,
      sum(not missing(sic_screen) and not (sic_screen>=6000 and sic_screen<=6999)) as n_nonfinancial_sic,
      sum(not missing(sich) and not (sich>=6000 and sich<=6999)) as n_comp_nonfinancial_sic,
      sum(sic_source='CRSP' and not (sic_screen>=6000 and sic_screen<=6999)) as n_crsp_nonfinancial_fill,
      sum(not missing(sic_screen) and not (sic_screen>=6000 and sic_screen<=6999) and
          not missing(noa) and noa>=0) as n_after_noa,
      sum(not missing(sic_screen) and not (sic_screen>=6000 and sic_screen<=6999) and
          not missing(noa) and noa>=0 and not missing(oiadp) and oiadp>=0) as n_after_opincome,
      sum(not missing(sic_screen) and not (sic_screen>=6000 and sic_screen<=6999) and
          not missing(noa) and noa>=0 and not missing(oiadp) and oiadp>=0 and
          currency_ok=1) as n_after_currency,
      sum(not missing(sic_screen) and not (sic_screen>=6000 and sic_screen<=6999) and
          not missing(noa) and noa>=0 and not missing(oiadp) and oiadp>=0 and
          currency_ok=1 and share_issue_ok=1) as n_after_issue,
      sum(nmiss(rnoa,drnoa,pm,ato,dpm,dato,rnoap1,pmp1,atop1)=0) as n_dupont_complete,
      sum(nmiss(rt,ur,rfut)=0) as n_return_complete,
      sum(nmiss(earn,dearn)=0) as n_compustat_eps_complete,
      sum(nmiss(sur,anrev)=0) as n_ibes_complete,
      sum(not missing(sic_screen) and not (sic_screen>=6000 and sic_screen<=6999) and
          not missing(noa) and noa>=0 and not missing(oiadp) and oiadp>=0 and
          currency_ok=1 and share_issue_ok=1 and
          nmiss(rt,ur,rfut,earn,dearn,rnoa,drnoa,pm,ato,dpm,dato,
             rnoap1,pmp1,atop1,sur,anrev)=0) as n_common
    from stage2 where fyear between 1984 and 2002
    group by fyear order by fyear;
quit;
data _null_;
    set year_screen;
    putlog 'SCREEN FYEAR=' fyear 4. ' nonfinancial_SIC=' n_nonfinancial_sic 8.
       ' Compustat_nonfinancial=' n_comp_nonfinancial_sic 8.
       ' CRSP_nonfinancial_fill=' n_crsp_nonfinancial_fill 8.
       ' after_NOA=' n_after_noa 8. ' after_OI=' n_after_opincome 8.
       ' after_currency=' n_after_currency 8. ' after_IID_PERMNO=' n_after_issue 8.
       ' common=' n_common 8.;
    putlog 'GROUP_COMPLETE FYEAR=' fyear 4. ' DuPont=' n_dupont_complete 8.
       ' return=' n_return_complete 8. ' Compustat_EPS=' n_compustat_eps_complete 8.
       ' IBES_SUR_ANREV=' n_ibes_complete 8.;
run;
data sample0;
    set stage2;
    if fyear<1984 or fyear>2002 then delete;
    if missing(sic_screen) then delete;
    if sic_screen>=6000 and sic_screen<=6999 then delete;
    if missing(noa) or noa<0 then delete;
    if missing(oiadp) or oiadp<0 then delete;
    if currency_ok ne 1 then delete;
    if share_issue_ok ne 1 then delete;
    if nmiss(rt,ur,rfut,earn,dearn,rnoa,drnoa,pm,ato,dpm,dato,
       rnoap1,pmp1,atop1,sur,anrev)=0;
    pre_age_days=ann_date-stat_npre;
    post_age_days=stat_npost-ann_date;
    pre_age_months=intck('month',stat_npre,ann_date);
    post_age_months=intck('month',ann_date,stat_npost);
run;
proc sql;
    select count(*) into :n_common trimmed from sample0;
    select put(min(datap1),date9.),put(max(datap1),date9.),
           put(min(intnx('month',datadate,5,'b')),date9.),
           put(max(intnx('month',datadate,16,'e')),date9.),
           min(fyear),max(fyear)
      into :sleadmin trimmed,:sleadmax trimmed,:wstartmin trimmed,:wendmax trimmed,
           :sminyr trimmed,:smaxyr trimmed from sample0;
quit;
%put NOTE: common complete-case rows=&n_common, actual t+1 DATADATE=&sleadmin to &sleadmax, future CRSP window support=&wstartmin to &wendmax, fiscal-year labels=&sminyr to &smaxyr.;
proc freq data=sample0;
    tables fyear / missing;
run;
/* This confirms that each selected year-(t+1) forecast is in an adjacent
   monthly period and reports its actual age in days by fiscal year. */
proc means data=sample0 n min p50 p90 max;
    class fyear;
    var pre_age_days post_age_days pre_age_months post_age_months;
run;

/* Annual 1st/99th cutoffs are best effort because the paper does not state the
   percentile grouping. Returns are not classified as financial variables. */
proc sort data=sample0; by fyear; run;
proc univariate data=sample0 noprint;
    by fyear;
    var earn dearn rnoa drnoa pm ato dpm dato rnoap1 pmp1 atop1 sur anrev;
    output out=cuts pctlpts=1 99
      pctlpre=earn_ dearn_ rnoa_ drnoa_ pm_ ato_ dpm_ dato_ rnoap1_ pmp1_ atop1_ sur_ anrev_
      pctlname=p1 p99;
run;
proc sort data=cuts; by fyear; run;
data samplew;
    merge sample0(in=a) cuts;
    by fyear;
    if a;
    array x[13] earn dearn rnoa drnoa pm ato dpm dato rnoap1 pmp1 atop1 sur anrev;
    array lo[13] earn_p1 dearn_p1 rnoa_p1 drnoa_p1 pm_p1 ato_p1 dpm_p1 dato_p1
       rnoap1_p1 pmp1_p1 atop1_p1 sur_p1 anrev_p1;
    array hi[13] earn_p99 dearn_p99 rnoa_p99 drnoa_p99 pm_p99 ato_p99 dpm_p99 dato_p99
       rnoap1_p99 pmp1_p99 atop1_p99 sur_p99 anrev_p99;
    do i=1 to dim(x);
        if not missing(x[i]) and not missing(lo[i]) and x[i]<lo[i] then x[i]=lo[i];
        if not missing(x[i]) and not missing(hi[i]) and x[i]>hi[i] then x[i]=hi[i];
    end;
    drop i earn_p1 earn_p99 dearn_p1 dearn_p99 rnoa_p1 rnoa_p99 drnoa_p1 drnoa_p99
      pm_p1 pm_p99 ato_p1 ato_p99 dpm_p1 dpm_p99 dato_p1 dato_p99
      rnoap1_p1 rnoap1_p99 pmp1_p1 pmp1_p99 atop1_p1 atop1_p99
      sur_p1 sur_p99 anrev_p1 anrev_p99;
run;
proc means data=samplew n mean std min p1 p50 p99 max;
    var rt ur rfut earn dearn rnoa drnoa pm ato dpm dato rnoap1 pmp1 atop1 sur anrev;
run;
proc means data=samplew n mean std min p1 p50 p99 max;
    class fyear;
    var rt ur rfut earn dearn rnoa drnoa pm ato dpm dato rnoap1 pmp1 atop1 sur anrev;
run;

/* One common analysis file, one row per Compustat GVKEY/FYEAR. */
data out.reg(label='DuPont annual common sample');
    set samplew;
    keep gvkey fyear rt ur rfut earn dearn rnoa drnoa pm ato dpm dato
         rnoap1 pmp1 atop1 sur anrev curcd curncd curr_act cur_t cur_npre cur_npost
         sich crsp_sic sic_screen sic_source
         datadate datam1 datam2 datap1 ann_date permno permm1 iid0 iidm1
         curm1 curm2 curp1 curnm1 curnm2 curnp1
         prcc_f prccm1 prccm1_cur prccm1_verified prccm1_date
         prccm1_price_status prccm1_price_age nday_t nday_f
         pre_age_days post_age_days pre_age_months post_age_months;
    label rt='Annual market-adjusted buy-and-hold return'
          ur='Announcement-window market-adjusted return'
          rfut='Future-return CRSP eligibility measure'
          sur='Unexpected annual EPS'
          anrev='Next-year analyst forecast revision'
          fyear='Compustat fiscal year'
          curcd='Compustat reporting currency'
          curncd='Compustat native currency'
          sich='Compustat historical SIC'
          crsp_sic='CRSP SICCD effective on DATADATE'
          sic_screen='SIC used for financial-industry screen'
          sic_source='Source of SIC used for financial-industry screen'
          curr_act='I/B/E/S actual currency field'
          prccm1_cur='Verified prior security-price currency'
          prccm1_verified='Prior price and currency verified'
          prccm1_date='Date of matched prior security price'
          cur_t='I/B/E/S current-year summary currency'
          cur_npre='I/B/E/S next-year pre-announcement currency'
          cur_npost='I/B/E/S next-year post-announcement currency';
run;
proc sort data=out.reg; by gvkey fyear; run;
proc freq data=out.reg;
    tables fyear / missing;
run;
proc sql;
    select count(*) into :n_out trimmed from out.reg;
    select put(min(datadate),date9.),put(max(datadate),date9.),
           put(min(datap1),date9.),put(max(datap1),date9.)
      into :omin trimmed,:omax trimmed,:ominp1 trimmed,:omaxp1 trimmed
      from out.reg;
quit;
%put NOTE: final rows=&n_out final target DATADATE=&omin to &omax final lead DATADATE=&ominp1 to &omaxp1.;
