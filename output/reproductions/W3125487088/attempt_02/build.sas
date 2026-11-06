options errorabend nodate nonumber;
libname comp '/storage/sas/base/comp/d_na' access=readonly;
libname compsec '/storage/sas/base/comp/d_na/security' access=readonly;
libname crsp '/storage/sas/base/crsp/a_ccm' access=readonly;
libname crspstk '/storage/sas/base/crsp/a_stock' access=readonly;
libname out 'data';

data work.funda_raw;
    length pref_fmt $4;
    set comp.funda(keep=gvkey datadate fyear indfmt datafmt consol popsrc
                   iid hiid curcd epspx ajex prcc_f sich naicsh
                   where=(fyear >= 1950 and fyear <= 2001
                          and popsrc='D' and datafmt='STD' and consol='C'
                          and indfmt in ('INDL','FS')));
    sich_valid=(not missing(sich) and 100<=sich and sich<=9999);
    sich_zero=(sich=0);
    naicsh_zero=(naicsh=0);
    naics_sector=.;
    if not missing(naicsh) and naicsh>=10 then do;
        naics_digits=floor(log10(naicsh))+1;
        naics_sector=floor(naicsh/(10**(naics_digits-2)));
    end;
    if sich_valid and 6000 <= sich and sich <= 6999 then pref_fmt='FS';
    else if sich_valid then pref_fmt='INDL';
    else if naics_sector=52 then pref_fmt='FS';
    else if not missing(naics_sector) then pref_fmt='INDL';
    else pref_fmt='';
    if indfmt=pref_fmt and not missing(pref_fmt) then fmtmatch=1;
    else fmtmatch=0;
run;

proc sql;
    create table work.rawcounts as
    select count(*) as filtered_source_rows,
           max(lengthn(strip(gvkey))) as max_gvkey_chars
    from work.funda_raw;
quit;

proc sort data=work.funda_raw out=work.funda_uniq nodupkey;
    by gvkey fyear datadate iid hiid curcd indfmt epspx ajex prcc_f sich naicsh;
run;
proc sort data=work.funda_raw out=work.valrows nodupkey;
    by gvkey fyear datadate iid hiid curcd epspx ajex prcc_f sich naicsh;
run;
data work.prefrows;
    set work.funda_uniq;
    if fmtmatch=1;
run;
proc sort data=work.prefrows nodupkey;
    by gvkey fyear datadate iid hiid curcd epspx ajex prcc_f sich naicsh;
run;

proc sql;
    create table work.prefstats as
    select gvkey, fyear, count(*) as preferred_rows
    from work.prefrows
    group by gvkey, fyear;

    create table work.fystats as
    select v.gvkey, v.fyear, min(v.datadate) as firstdate,
           max(v.datadate) as lastdate, count(*) as candidates,
           coalesce(p.preferred_rows,0) as preferred_rows
    from work.valrows as v
    left join work.prefstats as p
      on v.gvkey=p.gvkey and v.fyear=p.fyear
    group by v.gvkey, v.fyear, p.preferred_rows;

    create table work.annual0 as
    select v.*
    from work.valrows as v
    inner join work.fystats as s
      on v.gvkey=s.gvkey and v.fyear=s.fyear
    where s.candidates=1
    union corr
    select p.*
    from work.prefrows as p
    inner join work.fystats as s
      on p.gvkey=s.gvkey and p.fyear=s.fyear
    where s.candidates>1 and s.firstdate=s.lastdate
      and s.preferred_rows=1;

    create table work.fycounts as
    select count(*) as firmyears_selected
    from work.annual0;

    create table work.ambig as
    select count(*) as firmyears_ambiguous
    from work.fystats
    where candidates>1 and
          (firstdate ne lastdate or preferred_rows ne 1);

    create table work.ambigyr as
    select fyear, count(*) as ambiguous_firmyears
    from work.fystats
    where candidates>1 and
          (firstdate ne lastdate or preferred_rows ne 1)
    group by fyear
    order by fyear;

    create table work.indcov as
    select fyear, count(*) as source_rows,
           sum(sich_valid) as valid_sich_rows,
           sum(sich_zero) as zero_sich_rows,
           sum(not missing(sich) and sich_valid=0 and sich_zero=0)
               as other_invalid_sich_rows,
           sum(not missing(naicsh) and naicsh>0) as positive_naicsh_rows,
           sum(naicsh_zero) as zero_naicsh_rows,
           sum(naics_sector=52) as naics_finance_sector_rows
    from work.valrows
    group by fyear
    order by fyear;
quit;

data work.annual;
    set work.annual0;
    source_fmt=indfmt;
    keep gvkey fyear datadate iid hiid curcd indfmt source_fmt sich naicsh
         epspx ajex prcc_f;
run;

proc sql;
    create table work.period0 as
    select a.gvkey, a.fyear, a.datadate, a.iid, a.hiid, a.curcd,
           a.indfmt, a.sich, a.naicsh, a.epspx, a.ajex, a.prcc_f,
           b.datadate as prevdate, b.iid as previid, b.hiid as prevhiid,
           b.curcd as prevcur, b.ajex as prevajex,
           b.prcc_f as prevprcc
    from work.annual as a
    left join work.annual as b
      on a.gvkey=b.gvkey and a.fyear=b.fyear+1
    where a.fyear between 1951 and 2001;
quit;

data work.period0;
    set work.period0;
    lagok=(not missing(prevdate));
    dateok=(lagok and prevdate<datadate);
    iidok=(lagok and strip(iid)=strip(previid));
    hiidok=(lagok and not missing(hiid) and not missing(prevhiid)
            and strip(hiid)=strip(prevhiid));
    epsok=(not missing(epspx) and not missing(ajex) and ajex>0
           and not missing(prevajex) and prevajex>0);
    ret_days=datadate-prevdate;
    eps_prior_basis=.;
    if epsok then eps_prior_basis=epspx*prevajex/ajex;
run;

data work.issues;
    length iid $4;
    set work.period0(keep=gvkey hiid lagok dateok hiidok);
    if lagok and dateok and hiidok;
    iid=hiid;
    keep gvkey iid;
run;
proc sort data=work.issues nodupkey;
    by gvkey iid;
run;

data work.links;
    length iid $4 sdate edate 8 is_x 8;
    set crsp.ccmxpf_linktable(keep=gvkey liid lpermno linkdt linkenddt
                              linkprim linktype USEDFLAG);
    if USEDFLAG ne 1 or linkprim not in ('P','C')
       or linktype not in ('LC','LU')
       or missing(lpermno) then delete;
    iid=liid;
    is_x=0;
    if not missing(iid)
       and substr(strip(upcase(iid)),lengthn(strip(upcase(iid))),1)='X'
       then is_x=1;
    if linkdt=.B then sdate=-1000000;
    else if not missing(linkdt) then sdate=linkdt;
    else delete;
    if linkenddt=.E or linkenddt=. then edate=1000000;
    else if not missing(linkenddt) then edate=linkenddt;
    else delete;
    if edate<sdate then delete;
    keep gvkey iid lpermno linkdt linkenddt linkprim linktype USEDFLAG
         sdate edate is_x;
run;
proc sql;
    create table work.linkintervals as
    select distinct p.gvkey, p.fyear, p.hiid, p.prevdate, p.datadate,
           l.lpermno as permno, l.sdate, l.edate, l.is_x,
           (l.iid=p.hiid) as direct_id
    from work.period0 as p
    inner join work.links as l
      on p.gvkey=l.gvkey and (l.iid=p.hiid or l.is_x=1)
    where p.lagok=1 and p.dateok=1 and p.hiidok=1;

    create table work.rowcand as
    select distinct p.gvkey, p.fyear, l.lpermno as permno
    from work.period0 as p
    inner join work.links as l
      on p.gvkey=l.gvkey and (l.iid=p.hiid or l.is_x=1)
    where p.lagok=1 and p.dateok=1 and p.hiidok=1
      and l.sdate<=p.prevdate and l.edate>=p.datadate;
quit;

proc sort data=work.linkintervals;
    by gvkey fyear hiid permno sdate edate;
run;
data work.linkseg;
    set work.linkintervals;
    by gvkey fyear hiid permno;
    retain segstart segend dummy_x_history direct_id_history;
    if first.permno then do;
        segstart=sdate;
        segend=edate;
        dummy_x_history=is_x;
        direct_id_history=direct_id;
    end;
    else if sdate<=segend+1 then do;
        if edate>segend then segend=edate;
        dummy_x_history=max(dummy_x_history,is_x);
        direct_id_history=max(direct_id_history,direct_id);
    end;
    else do;
        output;
        segstart=sdate;
        segend=edate;
        dummy_x_history=is_x;
        direct_id_history=direct_id;
    end;
    if last.permno then output;
    keep gvkey fyear hiid permno segstart segend
         dummy_x_history direct_id_history;
run;

proc sql;
    create table work.linkcand0 as
    select p.gvkey, p.fyear, l.permno,
           l.dummy_x_history, l.direct_id_history,
           max(k.is_x) as dummy_x_used,
           max(case when k.iid=p.hiid then 1 else 0 end) as direct_id_used
    from work.period0 as p
    inner join work.linkseg as l
      on p.gvkey=l.gvkey and p.fyear=l.fyear and p.hiid=l.hiid
    inner join work.links as k
      on p.gvkey=k.gvkey and l.permno=k.lpermno
     and (k.iid=p.hiid or k.is_x=1)
     and k.sdate<=p.datadate and k.edate>=p.prevdate
    where p.lagok=1 and p.dateok=1 and p.hiidok=1
      and l.segstart<=p.prevdate and l.segend>=p.datadate
    group by p.gvkey, p.fyear, l.permno,
             l.dummy_x_history, l.direct_id_history;

    create table work.rowlinkstats as
    select gvkey, fyear, count(*) as rowlinkcnt
    from work.rowcand
    group by gvkey, fyear;

    create table work.linkcand as
    select gvkey, fyear, permno, max(dummy_x_used) as dummy_x_used,
           max(direct_id_used) as direct_id_used,
           max(dummy_x_history) as dummy_x_history,
           max(direct_id_history) as direct_id_history
    from work.linkcand0
    group by gvkey, fyear, permno;

    create table work.linkstats as
    select gvkey, fyear, count(*) as linkcnt, max(permno) as permno,
           max(dummy_x_used) as dummy_x_used,
           max(direct_id_used) as direct_id_used,
           max(dummy_x_history) as dummy_x_history,
           max(direct_id_history) as direct_id_history
    from work.linkcand
    group by gvkey, fyear;
quit;

proc sql;
    create table work.periodlink as
    select p.*, coalesce(l.linkcnt,0) as linkcnt,
           coalesce(r.rowlinkcnt,0) as rowlinkcnt,
           coalesce(l.dummy_x_used,0) as dummy_x_used,
           coalesce(l.direct_id_used,0) as direct_id_used,
           coalesce(l.dummy_x_history,0) as dummy_x_history,
           coalesce(l.direct_id_history,0) as direct_id_history,
           l.permno as permno
    from work.period0 as p
    left join work.linkstats as l
      on p.gvkey=l.gvkey and p.fyear=l.fyear
    left join work.rowlinkstats as r
      on p.gvkey=r.gvkey and p.fyear=r.fyear;
quit;

data work.win;
    set work.periodlink;
    if lagok and dateok and hiidok and linkcnt=1;
    keep gvkey fyear iid hiid curcd prevdate datadate ret_days permno;
run;
proc sort data=work.win;
    by gvkey fyear;
run;

data work.marketcal;
    length date 8;
    set crspstk.dsi(keep=date
                    where=(date >= '01JAN1948'd
                           and date <= '31DEC2003'd));
run;
proc sort data=work.marketcal nodupkey;
    by date;
run;
data work.marketcal;
    set work.marketcal;
    mktday+1;
run;

data work.events;
    length date 8;
    set work.win;
    which=1;
    date=prevdate;
    output;
    which=2;
    date=datadate;
    output;
    keep gvkey fyear which date;
run;
proc sort data=work.events;
    by date;
run;
data work.anchor_rank;
    merge work.marketcal(in=im) work.events(in=ie);
    by date;
    retain lastday lastdate;
    if im then do;
        lastday=mktday;
        lastdate=date;
    end;
    if ie then do;
        eventrank=lastday;
        eventmkt=lastdate;
        output;
    end;
    keep gvkey fyear which eventrank eventmkt;
run;
proc sort data=work.anchor_rank;
    by gvkey fyear which;
run;
data work.marketcnt;
    set work.anchor_rank;
    by gvkey fyear;
    retain rprev rcurr dprev dcurr;
    if first.fyear then call missing(rprev,rcurr,dprev,dcurr);
    if which=1 then do;
        rprev=eventrank;
        dprev=eventmkt;
    end;
    else do;
        rcurr=eventrank;
        dcurr=eventmkt;
    end;
    if last.fyear then do;
        expdays=rcurr-rprev;
        output;
    end;
    keep gvkey fyear rprev rcurr dprev dcurr expdays;
run;
proc sql;
    create table work.marketwin as
    select m.*, a.date as exp_first, b.date as exp_last
    from work.marketcnt as m
    left join work.marketcal as a
      on a.mktday=m.rprev+1
    left join work.marketcal as b
      on b.mktday=m.rcurr;
quit;

data work.permnos;
    set work.win(keep=permno);
run;
proc sort data=work.permnos nodupkey;
    by permno;
run;

data work.dsf0;
    if _n_=1 then do;
        declare hash hp(dataset:'work.permnos');
        hp.defineKey('permno');
        hp.defineDone();
    end;
    set crspstk.dsf(keep=permno date prc ret
                    where=(date >= '01JAN1948'd
                           and date <= '31DEC2003'd));
    if hp.check()=0;
run;
proc sort data=work.dsf0;
    by permno date;
run;
data work.dsfuniq work.dsfdup;
    set work.dsf0;
    by permno date;
    if first.date and last.date then output work.dsfuniq;
    else if first.date then output work.dsfdup;
run;

data work.dayret;
    length gvkey $7 fyear 8 prevdate datadate 8 rc 8;
    if _n_=1 then do;
        declare hash hw(dataset:'work.win',multidata:'y');
        hw.defineKey('permno');
        hw.defineData('gvkey','fyear','prevdate','datadate');
        hw.defineDone();
    end;
    set work.dsfuniq(keep=permno date ret);
    rc=hw.find();
    do while (rc=0);
        if date>prevdate and date<=datadate then output;
        rc=hw.find_next();
    end;
    keep gvkey fyear permno date ret;
run;
proc sort data=work.dayret;
    by gvkey fyear date;
run;

data work.retagg;
    set work.dayret;
    by gvkey fyear;
    retain nday ret_bad logret zero_ret first_obs last_obs;
    if first.fyear then do;
        nday=0;
        ret_bad=0;
        logret=0;
        zero_ret=0;
        first_obs=date;
    end;
    last_obs=date;
    nday+1;
    if missing(ret) or ret < -1 then ret_bad=1;
    else if ret=-1 then zero_ret=1;
    else logret=logret+log(1+ret);
    if last.fyear then do;
        ret_annual=.;
        if nday>0 and ret_bad=0 then do;
            if zero_ret=1 then ret_annual=-1;
            else ret_annual=exp(logret)-1;
        end;
        output;
    end;
    keep gvkey fyear nday ret_bad ret_annual first_obs last_obs;
run;
proc sort data=work.retagg;
    by gvkey fyear;
run;
proc sort data=work.marketwin;
    by gvkey fyear;
run;
data work.retagg2;
    merge work.retagg(in=a) work.marketwin(in=b);
    by gvkey fyear;
    if a or b;
    ret=.;
    retok=0;
    if a and b and not missing(expdays) and expdays>0
       and nday=expdays and first_obs=exp_first
       and last_obs=exp_last and ret_bad=0 then do;
        ret=ret_annual;
        retok=1;
    end;
    keep gvkey fyear ret nday ret_bad retok expdays exp_first exp_last
         first_obs last_obs;
run;

data work.qwin;
    set work.win;
    if strip(upcase(curcd))='USD';
    keep gvkey fyear permno prevdate;
run;
data work.quotehit;
    length gvkey $7 fyear 8 prevdate 8 qdate 8 qgap 8 qprice 8 rc 8;
    if _n_=1 then do;
        declare hash hq(dataset:'work.qwin',multidata:'y');
        hq.defineKey('permno');
        hq.defineData('gvkey','fyear','prevdate');
        hq.defineDone();
    end;
    set work.dsfuniq(keep=permno date prc);
    rc=hq.find();
    do while (rc=0);
        if date<=prevdate and date>=prevdate-7 and not missing(prc) then do;
            qdate=date;
            qgap=prevdate-date;
            qprice=abs(prc);
            output;
        end;
        rc=hq.find_next();
    end;
    keep gvkey fyear qdate qgap qprice;
run;
proc sort data=work.quotehit;
    by gvkey fyear descending qdate;
run;
data work.qbest;
    set work.quotehit;
    by gvkey fyear;
    if first.fyear;
    rename qdate=crsp_date qgap=crsp_gap qprice=crsp_price;
run;

proc sql;
    create table work.dupflag as
    select w.gvkey, w.fyear,
           max(case when d.date>w.prevdate and d.date<=w.datadate
                    then 1 else 0 end) as retdup,
           max(case when d.date<=w.prevdate and d.date>=w.prevdate-7
                    then 1 else 0 end) as pricedup
    from work.win as w
    inner join work.dsfdup as d
      on w.permno=d.permno
    group by w.gvkey, w.fyear;
quit;

data work.dcur0;
    if _n_=1 then do;
        declare hash hi(dataset:'work.issues');
        hi.defineKey('gvkey','iid');
        hi.defineDone();
    end;
    set compsec.sec_dprc(keep=gvkey iid datadate curcdd
                         where=(datadate >= '01JAN1948'd
                                and datadate <= '31DEC2003'd));
    if hi.check()=0 and not missing(curcdd);
run;
proc sort data=work.dcur0 out=work.dcur1 nodupkey;
    by gvkey iid datadate curcdd;
run;
proc sql;
    create table work.dcurcnt as
    select gvkey, iid, datadate, count(*) as ncur
    from work.dcur1
    group by gvkey, iid, datadate;

    create table work.dcur as
    select a.gvkey, a.iid, a.datadate, a.curcdd
    from work.dcur1 as a
    inner join work.dcurcnt as c
      on a.gvkey=c.gvkey and a.iid=c.iid and a.datadate=c.datadate
    where c.ncur=1;
quit;

data work.dreq;
    length iid $4;
    set work.period0;
    if lagok and dateok and hiidok;
    iid=hiid;
    do doff=0 to 7;
        datadate=prevdate-doff;
        output;
    end;
    keep gvkey iid fyear prevdate doff datadate;
run;
proc sort data=work.dreq;
    by gvkey iid datadate;
run;
proc sort data=work.dcur;
    by gvkey iid datadate;
run;
data work.dhit;
    merge work.dreq(in=a) work.dcur(in=b);
    by gvkey iid datadate;
    if a and b;
run;
proc sort data=work.dhit;
    by gvkey fyear doff;
run;
data work.dbest;
    set work.dhit;
    by gvkey fyear;
    if first.fyear;
    rename datadate=secday_date curcdd=daycur doff=secday_gap;
run;

data work.mcur0;
    if _n_=1 then do;
        declare hash hi(dataset:'work.issues');
        hi.defineKey('gvkey','iid');
        hi.defineDone();
    end;
    set compsec.sec_mthprc(keep=gvkey iid datadate curcdm
                           where=(datadate >= '01JAN1948'd
                                  and datadate <= '31DEC2003'd));
    if hi.check()=0 and not missing(curcdm);
    monid=intck('month','01JAN1948'd,datadate);
run;
proc sort data=work.mcur0 out=work.mcur1 nodupkey;
    by gvkey iid monid datadate curcdm;
run;
proc sql;
    create table work.mcurmax as
    select gvkey, iid, monid, max(datadate) as datadate
    from work.mcur1
    group by gvkey, iid, monid;

    create table work.mcurcnt as
    select a.gvkey, a.iid, a.monid, a.datadate, count(*) as ncur
    from work.mcur1 as a
    inner join work.mcurmax as m
      on a.gvkey=m.gvkey and a.iid=m.iid
     and a.monid=m.monid and a.datadate=m.datadate
    group by a.gvkey, a.iid, a.monid, a.datadate;

    create table work.mcur as
    select a.gvkey, a.iid, a.monid, a.datadate, a.curcdm
    from work.mcur1 as a
    inner join work.mcurcnt as c
      on a.gvkey=c.gvkey and a.iid=c.iid and a.monid=c.monid
     and a.datadate=c.datadate
    where c.ncur=1;
quit;

data work.mreq;
    length iid $4;
    set work.period0;
    if lagok and dateok and hiidok;
    iid=hiid;
    targetmon=intck('month','01JAN1948'd,prevdate);
    do moff=0 to 1;
        monid=targetmon-moff;
        output;
    end;
    keep gvkey iid fyear prevdate moff monid;
run;
proc sort data=work.mreq;
    by gvkey iid monid;
run;
proc sort data=work.mcur;
    by gvkey iid monid;
run;
data work.mhit;
    merge work.mreq(in=a) work.mcur(in=b);
    by gvkey iid monid;
    if a and b and datadate<=prevdate
       and prevdate-datadate<=45;
    mth_gap=prevdate-datadate;
run;
proc sort data=work.mhit;
    by gvkey fyear moff;
run;
data work.mbest;
    set work.mhit;
    by gvkey fyear;
    if first.fyear;
    rename datadate=secmth_date curcdm=mthcur;
run;

proc sql;
    create table work.stage0 as
    select p.*, coalesce(l.linkcnt,0) as linkcnt,
           coalesce(rl.rowlinkcnt,0) as rowlinkcnt,
           coalesce(l.dummy_x_used,0) as dummy_x_used,
           coalesce(l.direct_id_used,0) as direct_id_used,
           coalesce(l.dummy_x_history,0) as dummy_x_history,
           coalesce(l.direct_id_history,0) as direct_id_history,
           l.permno, r.nday, r.ret_bad, r.ret, r.retok,
           r.expdays, r.exp_first, r.exp_last, r.first_obs, r.last_obs,
           q.crsp_date, q.crsp_gap, q.crsp_price,
           x.retdup, x.pricedup,
           d.secday_date, d.secday_gap, d.daycur,
           m.secmth_date, m.mth_gap, m.mthcur
    from work.period0 as p
    left join work.linkstats as l
      on p.gvkey=l.gvkey and p.fyear=l.fyear
    left join work.rowlinkstats as rl
      on p.gvkey=rl.gvkey and p.fyear=rl.fyear
    left join work.retagg2 as r
      on p.gvkey=r.gvkey and p.fyear=r.fyear
    left join work.qbest as q
      on p.gvkey=q.gvkey and p.fyear=q.fyear
    left join work.dupflag as x
      on p.gvkey=x.gvkey and p.fyear=x.fyear
    left join work.dbest as d
      on p.gvkey=d.gvkey and p.fyear=d.fyear
    left join work.mbest as m
      on p.gvkey=m.gvkey and p.fyear=m.fyear;
quit;

data work.stage1;
    length price_cur epscur $3 price_source $4;
    set work.stage0;
    if missing(linkcnt) then linkcnt=0;
    if missing(dummy_x_used) then dummy_x_used=0;
    if missing(direct_id_used) then direct_id_used=0;
    if missing(dummy_x_history) then dummy_x_history=0;
    if missing(direct_id_history) then direct_id_history=0;
    if missing(retdup) then retdup=0;
    if missing(pricedup) then pricedup=0;
    if retdup=1 then ret=.;
    if missing(ret_bad) then ret_bad=0;
    retok=(retok=1 and not missing(ret) and ret_bad=0 and retdup=0
           and nday=expdays and first_obs=exp_first
           and last_obs=exp_last);
    price_cur='';
    price=.;
    price_date=.;
    price_gap=.;
    price_source='';
    cur_conflict=0;
    curmatch=0;
    if not missing(curcd) then do;
        epscur=strip(upcase(curcd));
        daycur=strip(upcase(daycur));
        mthcur=strip(upcase(mthcur));
        if not missing(daycur) and not missing(mthcur)
           and daycur ne mthcur then cur_conflict=1;
        if not missing(daycur) and not missing(mthcur)
           and daycur=mthcur then price_cur=daycur;
        else if not missing(daycur) and missing(mthcur) then price_cur=daycur;
        else if missing(daycur) and not missing(mthcur) then price_cur=mthcur;
        if epscur='USD' then do;
            price_source='CRSP';
            price_cur='USD';
            if pricedup=0 and not missing(crsp_price) and crsp_price>0 then do;
                price=crsp_price;
                price_date=crsp_date;
                price_gap=crsp_gap;
                curmatch=1;
            end;
        end;
        else if cur_conflict=0 and not missing(price_cur)
             and price_cur=epscur and not missing(prevprcc)
             and prevprcc>0 then do;
            price_source='COMP';
            price=prevprcc;
            price_date=prevdate;
            price_gap=0;
            curmatch=1;
        end;
    end;
    priceok=(curmatch=1 and not missing(price) and price>0
             and not missing(eps_prior_basis));
    eps_price=.;
    if priceok then eps_price=eps_prior_basis/price;
    dum=.;
    dum_return=.;
    if not missing(ret) then do;
        dum=(ret<0);
        dum_return=dum*ret;
    end;
    complete=(not missing(eps_price) and not missing(ret)
              and not missing(dum) and not missing(dum_return));
run;

proc sort data=work.stage1;
    by fyear;
run;
proc univariate data=work.stage1 noprint;
    where complete=1;
    by fyear;
    var eps_price ret;
    output out=work.cutoffs pctlpts=1 99 pctlpre=eps_ ret_;
run;
data work.final0;
    merge work.stage1(in=a) work.cutoffs;
    by fyear;
    if a and complete=1;
    if eps_1<=eps_price and eps_price<=eps_99
       and ret_1<=ret and ret<=ret_99;
run;
data work.final;
    set work.final0;
    keep gvkey fyear iid previid hiid prevhiid hiidok curcd prevcur indfmt sich naicsh
         datadate prevdate ret_days epspx ajex prevajex eps_prior_basis
         prevprcc price price_source price_cur price_date price_gap
         secday_date secday_gap secmth_date mth_gap crsp_date
         crsp_gap linkcnt rowlinkcnt dummy_x_used direct_id_used
         dummy_x_history direct_id_history permno
         nday expdays exp_first exp_last
         first_obs last_obs ret_bad ret retok retdup pricedup
         cur_conflict curmatch eps_price dum dum_return;
run;

proc sql;
    create table work.attrsum as
    select count(*) as source_firmyears,
           sum(lagok) as adjacent_lags,
           sum(dateok) as ordered_actual_dates,
           sum(iidok) as stable_header_iid,
           sum(hiidok) as stable_historical_primary_hiid,
           sum(epsok) as eps_and_split_inputs,
           sum(linkcnt=1) as unique_crsp_links,
           sum(rowlinkcnt=1) as unique_single_row_links,
           sum(linkcnt=1 and rowlinkcnt=0) as segment_only_unique_links,
           sum(linkcnt=1 and dummy_x_used=1) as unique_links_using_dummy_x,
           sum(linkcnt=1 and direct_id_used=1) as unique_links_using_hiid,
           sum(linkcnt=1 and dummy_x_history=1) as unique_links_x_history,
           sum(linkcnt=1 and direct_id_history=1) as unique_links_hiid_history,
           sum(retok) as complete_daily_returns,
           sum(curmatch=1) as matched_currency_and_price,
           sum(complete) as complete_regression_rows
    from work.stage1;

    create table work.attryear as
    select fyear, count(*) as source_rows,
           sum(lagok) as lag_rows,
           sum(iidok) as same_header_iid,
           sum(hiidok) as same_historical_primary_hiid,
           sum(linkcnt=1) as unique_links,
           sum(rowlinkcnt=1) as unique_single_row_links,
           sum(linkcnt=1 and rowlinkcnt=0) as segment_only_unique_links,
           sum(linkcnt=1 and dummy_x_used=1) as unique_links_using_dummy_x,
           sum(linkcnt=1 and direct_id_used=1) as unique_links_using_hiid,
           sum(linkcnt=1 and dummy_x_history=1) as unique_links_x_history,
           sum(linkcnt=1 and direct_id_history=1) as unique_links_hiid_history,
           sum(retok) as valid_return,
           sum(priceok) as valid_price,
           sum(complete) as complete_rows
    from work.stage1
    group by fyear
    order by fyear;

    create table work.tailcount as
    select count(*) as final_firmyears
    from work.final;
quit;

title 'Annual source selection and construction attrition';
proc print data=work.rawcounts noobs;
run;
proc print data=work.fycounts noobs;
run;
proc print data=work.ambig noobs;
run;
proc print data=work.ambigyr noobs;
run;
proc print data=work.indcov noobs;
run;
proc print data=work.attrsum noobs;
run;
proc print data=work.tailcount noobs;
run;
proc print data=work.attryear noobs;
run;
title 'Retained source paths and currencies';
proc freq data=work.final;
    tables fyear*price_source curcd*price_cur / missing;
    tables dummy_x_used*direct_id_used
           dummy_x_history*direct_id_history / missing;
run;
title 'Currency and prior-price availability before annual trimming';
proc freq data=work.stage1;
    tables curcd*curmatch curcd*price_source cur_conflict / missing;
run;
title 'Actual prior-to-current return-window lengths before annual trimming';
data work.span_pre;
    length span_class $16;
    set work.stage1;
    if complete=1;
    if ret_days<300 then span_class='short (<300d)';
    else if ret_days>400 then span_class='long (>400d)';
    else span_class='300-400d';
run;
proc freq data=work.span_pre;
    tables span_class / missing;
run;
title 'Actual prior-to-current return-window lengths after annual trimming';
data work.span_final;
    length span_class $16;
    set work.final0;
    if ret_days<300 then span_class='short (<300d)';
    else if ret_days>400 then span_class='long (>400d)';
    else span_class='300-400d';
run;
proc freq data=work.span_final;
    tables span_class / missing;
run;
title 'Return-window coverage and missing or invalid daily returns';
data work.return_audit;
    length return_status $38;
    set work.stage1;
    if linkcnt ne 1 then return_status='No unique date-valid PERMNO';
    else if missing(expdays) or expdays<=0 then return_status='No valid DSI window';
    else if missing(nday) then return_status='No DSF daily observations';
    else if retdup=1 then return_status='Duplicate DSF PERMNO-date';
    else if last_obs ne exp_last then return_status='No DSF at last expected day';
    else if first_obs ne exp_first then return_status='No DSF at first expected day';
    else if nday<expdays then return_status='Interior DSI-session gap';
    else if nday>expdays then return_status='Extra DSF session in window';
    else if ret_bad=1 then return_status='Missing or invalid daily RET';
    else if retok=1 then return_status='Complete daily RET window';
    else return_status='Other incomplete return window';
run;
proc freq data=work.return_audit;
    tables return_status / missing;
run;
title 'Final analysis variable and return coverage distributions';
proc means data=work.final n nmiss mean std min p1 p50 p99 max maxdec=6;
    var epspx ajex prevajex eps_prior_basis prevprcc price eps_price
        ret ret_days nday expdays price_gap crsp_gap secday_gap mth_gap;
run;
title 'SAS output sample structure';
proc contents data=work.final;
run;
title;

data out.reg;
    set work.final;
    label eps_price='EPSPX rebased to prior share basis / prior price'
          ret='Compounded raw CRSP daily total return'
          dum='Indicator for negative Return'
          dum_return='DUM times Return'
          ret_days='Days between actual adjacent DATADATEs';
    format datadate prevdate price_date crsp_date
           secday_date secmth_date exp_first exp_last
           first_obs last_obs yymmdd10.;
run;

%put FULL_BUILD_DONE;
