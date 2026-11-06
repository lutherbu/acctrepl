options errorabend;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname ibes "/storage/sas/base/ibes" access=readonly;
libname wrds "/storage/sas/base/wrdsapps/linking/iclink" access=readonly;
libname crsp "/storage/sas/base/crsp/a_ccm" access=readonly;
libname out "data/full_sample";

/* Compustat rows include the 1987 lag history and 2002 future history. */
data work.compq0;
    set comp.fundq(keep=gvkey datadate fyearq fqtr indfmt consol popsrc datafmt
                        curcdq atq saleq epspxq epsfxq opepsq cshprq ajexq
                        oancfy capxy);
    where datadate >= '01jan1987'd and datadate <= '31dec2002'd
      and indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'
      and not missing(gvkey) and not missing(datadate)
      and not missing(fyearq) and fqtr in (1,2,3,4);
    fseq = fyearq*4 + fqtr;
    cal_year = year(datadate);
    fmb_q = cal_year*4 + qtr(datadate);
    format datadate rdq date9.;
    label fseq = 'Fiscal year and quarter sequence'
          fmb_q = 'Calendar quarter sequence'
          cal_year = 'Calendar year of fiscal quarter end';
run;

proc sql;
    title "Compustat quarterly source and key audit";
    select count(*) as source_rows,
           count(distinct gvkey) as companies,
           min(datadate) as first_date format=date9.,
           max(datadate) as last_date format=date9.
    from work.compq0;
    create table work.compq_distinct as
    select distinct gvkey, datadate, fyearq, fqtr, curcdq,
           atq, saleq, epspxq, epsfxq, opepsq, cshprq, ajexq,
           oancfy, capxy,
           fseq, fmb_q, cal_year
    from work.compq0;
    create table work.compq_keyn as
    select gvkey, datadate, count(*) as n_distinct_rows
    from work.compq_distinct
    group by gvkey, datadate;
    select sum(n_distinct_rows>1) as ambiguous_firm_dates,
           sum(n_distinct_rows-1) as ambiguous_analysis_rows
    from work.compq_keyn;
    select a.raw_rows-b.distinct_rows as exactdup_rows
    from (select count(*) as raw_rows from work.compq0) as a,
         (select count(*) as distinct_rows from work.compq_distinct) as b;
    create table work.compq as
    select d.*
    from work.compq_distinct as d inner join work.compq_keyn as k
      on d.gvkey=k.gvkey and d.datadate=k.datadate
    where k.n_distinct_rows=1;
quit;

proc sort data=work.compq out=work.compq_s;
    by gvkey fseq datadate;
run;

/* Cash flow items OANCFY and CAPXY are YTD, not quarterly flows. */
data work.qflow;
    set work.compq_s;
    by gvkey;
    length prev_curcd $4;
    retain prev_fyear prev_fqtr prev_oancfy prev_capxy prev_curcd;
    if first.gvkey then call missing(prev_fyear, prev_fqtr, prev_oancfy,
                                     prev_capxy, prev_curcd);

    cfo_q = .;
    capex_q = .;
    if fqtr=1 then do;
        cfo_q = oancfy;
        capex_q = capxy;
    end;
    else if fyearq=prev_fyear and fqtr=prev_fqtr+1
         and not missing(curcdq) and curcdq=prev_curcd then do;
        if nmiss(oancfy, prev_oancfy)=0 then cfo_q=oancfy-prev_oancfy;
        if nmiss(capxy, prev_capxy)=0 then capex_q=capxy-prev_capxy;
    end;

    if not missing(cfo_q) and not missing(cshprq) and cshprq>0
        then cfo_ps=cfo_q/cshprq;
    else cfo_ps=.;
    if not missing(cfo_q) and not missing(capex_q)
       and not missing(cshprq) and cshprq>0
        then fcf_ps=(cfo_q-capex_q)/cshprq;
    else fcf_ps=.;

    prev_fyear=fyearq;
    prev_fqtr=fqtr;
    prev_oancfy=oancfy;
    prev_capxy=capxy;
    prev_curcd=curcdq;
    label cfo_q = 'Quarter cash from operations; YTD difference'
          capex_q = 'Quarter capital expenditures; YTD difference'
          cfo_ps = 'Quarter CFO per basic weighted-average share'
          fcf_ps = 'Quarter free cash flow per basic weighted-average share';
run;

/* In descending order the arrays contain later fiscal quarters. Express each
   future per-share flow on t's reported share basis with AJEXQ_t/AJEXQ_k. */
proc sort data=work.qflow out=work.qdesc;
    by gvkey descending fseq;
run;

data work.qout;
    set work.qdesc;
    by gvkey;
    array futseq[12] _temporary_;
    array futcfo[12] _temporary_;
    array futfcf[12] _temporary_;
    array futshr[12] _temporary_;
    array futadj[12] _temporary_;
    array futcur[12] $4 _temporary_;
    if first.gvkey then do i=1 to 12;
        futseq[i]=.; futcfo[i]=.; futfcf[i]=.; futshr[i]=.;
        futadj[i]=.; futcur[i]='';
    end;

    cfo_sum1_ps=.; cfo_sum2_ps=.; cfo_sum3_ps=.;
    fcf_sum1_ps=.; fcf_sum2_ps=.; fcf_sum3_ps=.;
    split1=0; split2=0; split3=0;
    ok=1; total=0;
    do i=1 to 4;
        if futseq[i] ne fseq+i or missing(futcfo[i]) or missing(futshr[i])
           or futshr[i]<=0 or missing(ajexq) or ajexq<=0
           or missing(futadj[i]) or futadj[i]<=0 or futcur[i] ne curcdq then ok=0;
        else do;
            total=total+(futcfo[i]/futshr[i])*(ajexq/futadj[i]);
            if ajexq ne futadj[i] then split1=1;
        end;
    end;
    if ok then cfo_sum1_ps=total;
    ok=1; total=0;
    do i=1 to 4;
        if futseq[i] ne fseq+i or missing(futfcf[i]) or missing(futshr[i])
           or futshr[i]<=0 or missing(ajexq) or ajexq<=0
           or missing(futadj[i]) or futadj[i]<=0 or futcur[i] ne curcdq then ok=0;
        else total=total+(futfcf[i]/futshr[i])*(ajexq/futadj[i]);
    end;
    if ok then fcf_sum1_ps=total;

    ok=1; total=0;
    do i=1 to 8;
        if futseq[i] ne fseq+i or missing(futcfo[i]) or missing(futshr[i])
           or futshr[i]<=0 or missing(ajexq) or ajexq<=0
           or missing(futadj[i]) or futadj[i]<=0 or futcur[i] ne curcdq then ok=0;
        else do;
            total=total+(futcfo[i]/futshr[i])*(ajexq/futadj[i]);
            if ajexq ne futadj[i] then split2=1;
        end;
    end;
    if ok then cfo_sum2_ps=total;
    ok=1; total=0;
    do i=1 to 8;
        if futseq[i] ne fseq+i or missing(futfcf[i]) or missing(futshr[i])
           or futshr[i]<=0 or missing(ajexq) or ajexq<=0
           or missing(futadj[i]) or futadj[i]<=0 or futcur[i] ne curcdq then ok=0;
        else total=total+(futfcf[i]/futshr[i])*(ajexq/futadj[i]);
    end;
    if ok then fcf_sum2_ps=total;

    ok=1; total=0;
    do i=1 to 12;
        if futseq[i] ne fseq+i or missing(futcfo[i]) or missing(futshr[i])
           or futshr[i]<=0 or missing(ajexq) or ajexq<=0
           or missing(futadj[i]) or futadj[i]<=0 or futcur[i] ne curcdq then ok=0;
        else do;
            total=total+(futcfo[i]/futshr[i])*(ajexq/futadj[i]);
            if ajexq ne futadj[i] then split3=1;
        end;
    end;
    if ok then cfo_sum3_ps=total;
    ok=1; total=0;
    do i=1 to 12;
        if futseq[i] ne fseq+i or missing(futfcf[i]) or missing(futshr[i])
           or futshr[i]<=0 or missing(ajexq) or ajexq<=0
           or missing(futadj[i]) or futadj[i]<=0 or futcur[i] ne curcdq then ok=0;
        else total=total+(futfcf[i]/futshr[i])*(ajexq/futadj[i]);
    end;
    if ok then fcf_sum3_ps=total;

    do i=12 to 2 by -1;
        futseq[i]=futseq[i-1];
        futcfo[i]=futcfo[i-1];
        futfcf[i]=futfcf[i-1];
        futshr[i]=futshr[i-1];
        futadj[i]=futadj[i-1];
        futcur[i]=futcur[i-1];
    end;
    futseq[1]=fseq;
    futcfo[1]=cfo_q;
    if not missing(cfo_q) and not missing(capex_q) then
        futfcf[1]=cfo_q-capex_q;
    else futfcf[1]=.;
    futshr[1]=cshprq;
    futadj[1]=ajexq;
    futcur[1]=curcdq;
    drop i ok total;
    label cfo_sum1_ps = 'CFO summed on initial-quarter share basis over next 4 fiscal quarters'
          cfo_sum2_ps = 'CFO summed on initial-quarter share basis over next 8 fiscal quarters'
          cfo_sum3_ps = 'CFO summed on initial-quarter share basis over next 12 fiscal quarters'
          fcf_sum1_ps = 'FCF summed on initial-quarter share basis over next 4 fiscal quarters'
          fcf_sum2_ps = 'FCF summed on initial-quarter share basis over next 8 fiscal quarters'
          fcf_sum3_ps = 'FCF summed on initial-quarter share basis over next 12 fiscal quarters';
run;

/* Sales growth is a dollar change per share, not a percentage change.
   Compustat can assign two DATADATEs to the same fiscal year/quarter when a
   firm changes its year-end. Keep the t-4 fiscal-quarter candidate closest
   to the same calendar date one year earlier; omit only unresolved ties. */
data work.qout_target;
    set work.qout;
    lag_target=intnx('year',datadate,-1,'same');
    format lag_target date9.;
run;

proc sql;
    create table work.lag_candidates as
    select a.gvkey, a.datadate, a.fseq, a.lag_target,
           p.datadate as lag_date, p.saleq as sale4, p.curcdq as curcd4,
           abs(p.datadate-a.lag_target) as lag_distance
    from work.qout_target as a inner join work.qout as p
      on a.gvkey=p.gvkey and p.fseq=a.fseq-4 and p.datadate<a.datadate;

    create table work.lag_min as
    select gvkey, datadate, min(lag_distance) as lag_distance
    from work.lag_candidates
    group by gvkey, datadate;

    create table work.lag_best as
    select c.*
    from work.lag_candidates as c inner join work.lag_min as m
      on c.gvkey=m.gvkey and c.datadate=m.datadate
     and c.lag_distance=m.lag_distance;

    create table work.lag_best_n as
    select gvkey, datadate, count(*) as n_best
    from work.lag_best
    group by gvkey, datadate;

    create table work.lag_unique as
    select b.*
    from work.lag_best as b inner join work.lag_best_n as n
      on b.gvkey=n.gvkey and b.datadate=n.datadate
    where n.n_best=1;

    create table work.qwithlag as
    select a.*, p.sale4, p.curcd4, p.lag_date, p.lag_distance
    from work.qout_target as a left join work.lag_unique as p
      on a.gvkey=p.gvkey and a.datadate=p.datadate;

    select count(*) as fiscal_lag_keys_with_tie
    from work.lag_best_n where n_best>1;

    create table work.qwithlag_dups as
    select gvkey, datadate, count(*) as n_rows,
           count(distinct sale4) as n_sale4, count(distinct curcd4) as n_curcd4
    from work.qwithlag
    group by gvkey, datadate
    having calculated n_rows>1;
    select count(*) as duplicate_qwithlag_keys,
           sum(n_rows-1) as excess_qwithlag_rows
    from work.qwithlag_dups;
quit;
/* The local unadjusted actuals file carries no actual-level dilution flag. */
data work.actraw;
    set ibes.actu_epsus(keep=ticker cusip pends measure pdicity anndats actdats
                             anntims acttims value curr_act usfirm);
    where usfirm=1 and measure='EPS' and pdicity='QTR'
      and pends >= '01jan1987'd and pends <= '31dec1999'd;
    actual_date=coalesce(anndats,actdats);
    ann_fallback=(missing(anndats) and not missing(actdats));
    if missing(ticker) or nmiss(pends, actual_date, value)>0 then delete;
    format pends actual_date anndats actdats date9.;
    keep ticker pends actual_date value curr_act ann_fallback;
run;

proc sql;
    title "Unadjusted I/B/E/S actual source audit";
    select count(*) as screened_actual_rows,
           count(distinct ticker) as tickers,
           sum(ann_fallback) as activation_date_fallbacks
    from work.actraw;
    create table work.actmin as
    select ticker, pends, min(actual_date) as actual_date format=date9.
    from work.actraw
    group by ticker, pends;

    create table work.actfirst as
    select a.*
    from work.actraw as a inner join work.actmin as m
      on a.ticker=m.ticker and a.pends=m.pends and a.actual_date=m.actual_date;

    create table work.actone as
    select ticker, pends, actual_date,
           min(value) as ibes_min,
           max(value) as ibes_max,
           min(curr_act) as ibes_ccy,
           max(curr_act) as ccy_max,
           max(ann_fallback) as ann_fallback,
           count(*) as duplicate_rows
    from work.actfirst
    group by ticker, pends
    having calculated ibes_min=calculated ibes_max
       and calculated ibes_ccy=calculated ccy_max;
quit;

data work.actone;
    set work.actone;
    ibes_eps=ibes_min;
    drop ibes_min ibes_max ccy_max;
    label ibes_eps='Unadjusted I/B/E/S reported actual EPS';
run;

/* Only the top two WRDS ICLINK quality scores are retained. */
data work.iblink;
    set wrds.ibcrsphist(keep=ticker permno sdate edate score);
    where score in (0,1) and not missing(ticker) and not missing(permno);
    format sdate edate date9.;
run;

proc sql;
    create table work.actperm as
    select distinct a.*, l.permno, l.score
    from work.actone as a inner join work.iblink as l
      on a.ticker=l.ticker
     and (missing(l.sdate) or l.sdate<=a.actual_date)
     and (missing(l.edate) or l.edate>=a.actual_date);
quit;

data work.ccm;
    set crsp.ccmxpf_linktable(keep=gvkey linkprim liid linktype lpermno usedflag
                                   linkdt linkenddt);
    where not missing(gvkey) and not missing(lpermno) and usedflag=1
      and linktype in ('LC','LU') and linkprim in ('P','C');
    format linkdt linkenddt date9.;
run;

proc sql;
    create table work.actgv0 as
    select distinct a.ticker, a.pends, a.actual_date, a.ibes_eps,
           a.ibes_ccy, a.ann_fallback, c.gvkey
    from work.actperm as a inner join work.ccm as c
      on a.permno=c.lpermno
     and (missing(c.linkdt) or c.linkdt<=a.actual_date)
     and (missing(c.linkenddt) or c.linkenddt>=a.actual_date);

    create table work.actgvcount as
    select ticker, pends, actual_date, ibes_eps, ibes_ccy,
           count(distinct gvkey) as n_gvkey,
           min(gvkey) as gvkey length=6,
           max(ann_fallback) as ann_fallback
    from work.actgv0
    group by ticker, pends, actual_date, ibes_eps, ibes_ccy;

    create table work.actgv as
    select * from work.actgvcount where n_gvkey=1;

    create table work.current0 as
    select q.*, a.ticker, a.actual_date, a.ibes_eps, a.ibes_ccy,
           a.ann_fallback, a.pends
    from work.qwithlag as q inner join work.actgv as a
      on q.gvkey=a.gvkey
     and year(q.datadate)=year(a.pends)
     and month(q.datadate)=month(a.pends)
    where q.cal_year between 1988 and 1999;

    /* I/B/E/S defines ACTU Period End Date at YYYYMM precision.  Its local
       DATE9 value is a monthly representation, so report the day gap and
       omit only actuals that map to multiple Compustat dates in that month. */
    create table work.pends_map as
    select gvkey, ticker, pends, count(distinct datadate) as n_comp_dates
    from work.current0
    group by gvkey, ticker, pends;
    select count(*) as matched_month_keys,
           sum(n_comp_dates>1) as ambiguous_month_keys,
           sum(n_comp_dates-1) as extra_compustat_dates
    from work.pends_map;
    select count(*) as month_matched_rows,
           sum(datadate=pends) as same_encoded_day,
           sum(datadate ne pends) as different_encoded_day,
           min(datadate-pends) as min_day_gap,
           max(datadate-pends) as max_day_gap
    from work.current0;

    create table work.current_month_unique as
    select a.*
    from work.current0 as a inner join work.pends_map as b
      on a.gvkey=b.gvkey and a.ticker=b.ticker and a.pends=b.pends
    where b.n_comp_dates=1;

    create table work.current_stats as
    select gvkey, datadate,
           count(distinct ticker) as n_ticker,
           min(pends) as pends_min, max(pends) as pends_max,
           min(ibes_eps) as eps_min, max(ibes_eps) as eps_max,
           min(ibes_ccy) as ccy_min, max(ibes_ccy) as ccy_max,
           min(actual_date) as date_min,
           max(actual_date) as date_max
    from work.current_month_unique
    group by gvkey, datadate;

    create table work.current_unique as
    select distinct a.*
    from work.current_month_unique as a inner join work.current_stats as s
      on a.gvkey=s.gvkey and a.datadate=s.datadate
    where s.n_ticker=1 and s.pends_min=s.pends_max
      and s.eps_min=s.eps_max and s.ccy_min=s.ccy_max
      and s.date_min=s.date_max;

    /* The paper says there is one firm observation per calendar quarter.
       Among dated IBES-linked reports, retain the latest fiscal period end
       in each firm/calendar quarter before applying outcome completeness. */
    create table work.calq_counts as
    select gvkey, fmb_q, count(*) as n_reports
    from work.current_unique
    group by gvkey, fmb_q;
    select count(*) as duplicate_firm_calendar_quarters,
           sum(n_reports-1) as excess_calendar_quarter_reports
    from work.calq_counts where n_reports>1;

    create table work.calq_latest as
    select gvkey, fmb_q, max(datadate) as selected_datadate
    from work.current_unique
    group by gvkey, fmb_q;

    create table work.current_one as
    select a.*
    from work.current_unique as a inner join work.calq_latest as b
      on a.gvkey=b.gvkey and a.fmb_q=b.fmb_q
     and a.datadate=b.selected_datadate;

    select count(*) as dated_ibes_linked_firm_dates,
           count(distinct cats(gvkey,'|',put(fmb_q,12.)))
             as linked_firmcal_qs
    from work.current_unique;
    select count(*) as reports_after_calq_rule,
           count(distinct cats(gvkey,'|',put(fmb_q,12.)))
             as firmcal_qs_after_rule
    from work.current_one;

    create table work.current_dups as
    select gvkey, datadate, count(*) as n_rows,
           count(distinct sale4) as n_sale4, count(distinct curcd4) as n_curcd4
    from work.current_one
    group by gvkey, datadate
    having calculated n_rows>1;
    select count(*) as duplicate_current_keys,
           sum(n_rows-1) as excess_current_rows
    from work.current_dups;
quit;
data work.analysis;
    set work.current_one;
    unit_ok=(not missing(ibes_ccy) and not missing(curcdq)
             and ibes_ccy=curcdq);
    if unit_ok;

    if not missing(atq) and atq>0 and not missing(cshprq) and cshprq>0
        then atps=atq/cshprq;
    else atps=.;

    pf_ps=ibes_eps;
    gaap_ps=epspxq;
    op_ps=opepsq;
    if not missing(pf_ps) and not missing(gaap_ps) then total_ps=pf_ps-gaap_ps;
    else total_ps=.;
    if not missing(op_ps) and not missing(gaap_ps) then special_ps=op_ps-gaap_ps;
    else special_ps=.;
    if not missing(total_ps) and not missing(special_ps)
        then other_ps=total_ps-special_ps;
    else other_ps=.;

    if not missing(saleq) and not missing(sale4) and not missing(cshprq)
       and cshprq>0 and not missing(curcdq) and curcdq=curcd4
        then sales_ps=(saleq-sale4)/cshprq;
    else sales_ps=.;
    if not missing(gaap_ps) and not missing(cfo_ps) then accr_ps=gaap_ps-cfo_ps;
    else accr_ps=.;

    if not missing(atps) and atps>0 then do;
        pf_s=pf_ps/atps;
        total_s=total_ps/atps;
        special_s=special_ps/atps;
        other_s=other_ps/atps;
        sales_s=sales_ps/atps;
        accr_s=accr_ps/atps;
        cfo1_s=cfo_sum1_ps/atps;
        cfo2_s=cfo_sum2_ps/atps;
        cfo3_s=cfo_sum3_ps/atps;
        fcf1_s=fcf_sum1_ps/atps;
        fcf2_s=fcf_sum2_ps/atps;
        fcf3_s=fcf_sum3_ps/atps;
    end;
    else call missing(pf_s,total_s,special_s,other_s,sales_s,accr_s,
                      cfo1_s,cfo2_s,cfo3_s,fcf1_s,fcf2_s,fcf3_s);
    label pf_ps='Pro forma earnings per share, unadjusted actual'
          gaap_ps='GAAP earnings per share, basic approximation'
          op_ps='Operating income per share, primary approximation'
          total_ps='Total exclusions per share'
          special_ps='Special items per share, after-tax'
          other_ps='Other exclusions per share'
          sales_ps='Sales dollar change per share'
          accr_ps='GAAP earnings less current CFO per share'
          atps='Total assets per basic weighted-average share'
          pf_s='Pro forma earnings / assets per share'
          total_s='Total exclusions / assets per share'
          special_s='Special items / assets per share'
          other_s='Other exclusions / assets per share'
          sales_s='Sales growth / assets per share'
          accr_s='Accruals / assets per share';
run;

/* Pooled 1st/99th percentile cutoffs are calculated after asset scaling. */
proc means data=work.analysis noprint;
    var pf_s total_s special_s other_s sales_s accr_s
        cfo1_s cfo2_s cfo3_s fcf1_s fcf2_s fcf3_s;
    output out=work.cutpoints
        p1=pf_lo total_lo special_lo other_lo sales_lo accr_lo
           cfo1_lo cfo2_lo cfo3_lo fcf1_lo fcf2_lo fcf3_lo
        p99=pf_hi total_hi special_hi other_hi sales_hi accr_hi
            cfo1_hi cfo2_hi cfo3_hi fcf1_hi fcf2_hi fcf3_hi;
run;

data work.final;
    if _n_=1 then set work.cutpoints(drop=_TYPE_ _FREQ_);
    set work.analysis;
    array src[12] pf_s total_s special_s other_s sales_s accr_s
                  cfo1_s cfo2_s cfo3_s fcf1_s fcf2_s fcf3_s;
    array low[12] pf_lo total_lo special_lo other_lo sales_lo accr_lo
                  cfo1_lo cfo2_lo cfo3_lo fcf1_lo fcf2_lo fcf3_lo;
    array high[12] pf_hi total_hi special_hi other_hi sales_hi accr_hi
                   cfo1_hi cfo2_hi cfo3_hi fcf1_hi fcf2_hi fcf3_hi;
    array win[12] pf_w total_w special_w other_w sales_w accr_w
                  cfo1_w cfo2_w cfo3_w fcf1_w fcf2_w fcf3_w;
    do i=1 to 12;
        if not missing(src[i]) and not missing(low[i]) and not missing(high[i])
            then win[i]=min(high[i],max(low[i],src[i]));
        else win[i]=.;
    end;
    ok_ct1=(nmiss(cfo1_w,pf_w,total_w,sales_w,accr_w)=0);
    ok_ct2=(nmiss(cfo2_w,pf_w,total_w,sales_w,accr_w)=0);
    ok_ct3=(nmiss(cfo3_w,pf_w,total_w,sales_w,accr_w)=0);
    ok_cc1=(nmiss(cfo1_w,pf_w,special_w,other_w,sales_w,accr_w)=0);
    ok_cc2=(nmiss(cfo2_w,pf_w,special_w,other_w,sales_w,accr_w)=0);
    ok_cc3=(nmiss(cfo3_w,pf_w,special_w,other_w,sales_w,accr_w)=0);
    ok_ft1=(nmiss(fcf1_w,pf_w,total_w,sales_w,accr_w)=0);
    ok_ft2=(nmiss(fcf2_w,pf_w,total_w,sales_w,accr_w)=0);
    ok_ft3=(nmiss(fcf3_w,pf_w,total_w,sales_w,accr_w)=0);
    ok_fc1=(nmiss(fcf1_w,pf_w,special_w,other_w,sales_w,accr_w)=0);
    ok_fc2=(nmiss(fcf2_w,pf_w,special_w,other_w,sales_w,accr_w)=0);
    ok_fc3=(nmiss(fcf3_w,pf_w,special_w,other_w,sales_w,accr_w)=0);
    drop i;
run;

/* Aggregate construction, sample, and unit diagnostics. */
proc sql;
    title "IBES-link-currency attrition";
    select count(*) as linked_compustat_rows,
           sum(ibes_ccy ne curcdq) as currency_mismatches,
           sum(ibes_ccy=curcdq) as same_currency_rows
    from work.current_one;
    title "Compustat cumulative split-factor coverage";
    select count(*) as linked_rows,
           sum(missing(ajexq)) as missing_split_factors,
           sum(ajexq=1) as unit_split_factors,
           sum(ajexq ne 1 and not missing(ajexq)) as nonunit_split_factors
    from work.current_one;
    title "Final 1988-1999 sample and horizon coverage";
    select count(*) as sample_rows,
           count(distinct gvkey) as companies,
           count(distinct fmb_q) as calendar_quarters,
           sum(ok_ct1) as cfo_total_h1,
           sum(ok_ct2) as cfo_total_h2,
           sum(ok_ct3) as cfo_total_h3,
           sum(ok_cc1) as cfo_components_h1,
           sum(ok_cc2) as cfo_components_h2,
           sum(ok_cc3) as cfo_components_h3,
           sum(ok_ft1) as fcf_total_h1,
           sum(ok_ft2) as fcf_total_h2,
           sum(ok_ft3) as fcf_total_h3,
           sum(ok_fc1) as fcf_components_h1,
           sum(ok_fc2) as fcf_components_h2,
           sum(ok_fc3) as fcf_components_h3,
           sum(ok_ct1 and split1) as cfo_total_h1_with_future_split,
           sum(ok_ct2 and split2) as cfo_total_h2_with_future_split,
           sum(ok_ct3 and split3) as cfo_total_h3_with_future_split,
           sum(ok_ft1 and split1) as fcf_total_h1_with_future_split,
           sum(ok_ft2 and split2) as fcf_total_h2_with_future_split,
           sum(ok_ft3 and split3) as fcf_total_h3_with_future_split
    from work.final;
    create table work.final_dups as
    select gvkey, datadate, count(*) as n_rows
    from work.final
    group by gvkey, datadate
    having calculated n_rows>1;
    select count(*) as duplicate_final_keys,
           sum(n_rows-1) as excess_final_rows
    from work.final_dups;
quit;
proc sort data=work.final out=work.byyear;
    by cal_year;
run;
proc means data=work.byyear nway noprint;
    by cal_year;
    var ok_ct1 ok_ct2 ok_ct3 ok_cc1 ok_cc2 ok_cc3
        ok_ft1 ok_ft2 ok_ft3 ok_fc1 ok_fc2 ok_fc3;
    output out=work.year_elig sum=;
run;
title "Full-sample fit eligibility by calendar year";
proc print data=work.year_elig noobs label;
    var cal_year ok_ct1 ok_ct2 ok_ct3 ok_cc1 ok_cc2 ok_cc3
        ok_ft1 ok_ft2 ok_ft3 ok_fc1 ok_fc2 ok_fc3;
run;

title "Actual-sample descriptives in unscaled per-share units";
proc means data=work.final n mean std p25 median p75;
    var pf_ps op_ps gaap_ps total_ps special_ps other_ps sales_ps accr_ps
        cfo_sum1_ps cfo_sum2_ps cfo_sum3_ps
        fcf_sum1_ps fcf_sum2_ps fcf_sum3_ps;
run;

title "Final scaled regression input distributions before and after winsorization";
proc means data=work.final n mean std min p1 p25 median p75 p99 max;
    var pf_s total_s special_s other_s sales_s accr_s
        cfo1_s cfo2_s cfo3_s fcf1_s fcf2_s fcf3_s
        pf_w total_w special_w other_w sales_w accr_w
        cfo1_w cfo2_w cfo3_w fcf1_w fcf2_w fcf3_w;
run;

data out.full_sample;
    set work.final;
    keep gvkey datadate fyearq fqtr fseq fmb_q cal_year
         curcdq ibes_ccy ticker pends actual_date ann_fallback unit_ok
         atq saleq sale4 epspxq epsfxq opepsq cshprq ajexq
         oancfy capxy cfo_q capex_q cfo_ps fcf_ps atps
         pf_ps gaap_ps op_ps total_ps special_ps other_ps sales_ps accr_ps
         cfo_sum1_ps cfo_sum2_ps cfo_sum3_ps
         fcf_sum1_ps fcf_sum2_ps fcf_sum3_ps
         pf_s total_s special_s other_s sales_s accr_s
         cfo1_s cfo2_s cfo3_s fcf1_s fcf2_s fcf3_s
         pf_w total_w special_w other_w sales_w accr_w
         cfo1_w cfo2_w cfo3_w fcf1_w fcf2_w fcf3_w
         ok_ct1 ok_ct2 ok_ct3 ok_cc1 ok_cc2 ok_cc3
         ok_ft1 ok_ft2 ok_ft3 ok_fc1 ok_fc2 ok_fc3;
    format datadate rdq actual_date date9.;
run;
title "Final SAS handoff check";
proc sql;
    select count(*) as rows,
           count(distinct cats(gvkey,'|',put(datadate,yymmddn8.))) as unique_firm_quarters
    from out.full_sample;
quit;
title;
