options errorabend nonumber nodate;

libname ibes "/storage/sas/base/ibes" access=readonly;
libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname compsec "/storage/sas/base/comp/d_na/security" access=readonly;
libname compfx "/storage/sas/base/comp/d_global/currency" access=readonly;
libname wrdsapps "/storage/sas/base/wrdsapps/linking/iclink" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname outlib "data/revisions";

%let d0 = '01jan1987'd;
%let d1 = '31dec1997'd;
%let sample0 = '01jan1990'd;
%let sample1 = '31dec1994'd;
%let max_factor_age = 5;

/* Detail rows retain the support period and two years of boundary events. */
data det_raw;
    set ibes.detu_epsus
        (keep=ticker cusip actdats estimator analys currfl pdf fpi measure value
              curr usfirm fpedats acttims revdats revtims anndats anntims report_curr
         where=(actdats >= &d0 and actdats <= &d1 and measure='EPS'));
    rowid + 1;
    ticker = upcase(strip(ticker));
    cusip = upcase(strip(cusip));
    report_curr = upcase(strip(report_curr));
    curr = upcase(strip(curr));
    fpi = upcase(strip(fpi));
    pdf = upcase(strip(pdf));
    format actdats fpedats revdats anndats date9.;
run;
proc sql;
    select count(*) as n_detail_rows,
           sum(missing(analys)) as n_missing_analys,
           sum(not missing(analys) and analys=0) as n_zero_analys,
           sum(not missing(analys) and analys<0) as n_negative_analys,
           sum(missing(estimator)) as n_missing_estimator
    from det_raw;
quit;

/* Currency and annual-fundamental populations are loaded before rate construction. */
data funda0;
    set comp.funda
        (keep=gvkey datadate fyear fyr epspx curcd indfmt consol popsrc datafmt
         where=(datadate >= &d0 and datadate <= &d1 and indfmt='INDL'
                and consol='C' and popsrc='D' and datafmt='STD'));
    gvkey=strip(gvkey);
    curcd=upcase(strip(curcd));
    format datadate date9.;
run;
proc sql;
    create table summ_raw as
    select ticker, fpedats, statpers, fpi, fiscalp, estflag,
           upcase(strip(curcode)) as curcode length=3, medest
    from ibes.statsumu_epsus
    where statpers >= &d0 and statpers <= &d1 and measure='EPS'
      and fpi='1' and fiscalp='ANN' and estflag='P' and not missing(medest)
      and not missing(curcode);
quit;

proc sql;
    create table links_raw as
    select distinct upcase(strip(ticker)) as ticker length=8,
           permno, sdate, edate
    from wrdsapps.ibcrsphist
    where not missing(ticker) and not missing(permno);
quit;

/* Preserve ambiguous ticker/date links for the cardinality audit, then use unique links. */
proc sql;
    create table det_link_candidates as
    select distinct d.rowid, l.permno
    from det_raw as d inner join links_raw as l
      on d.ticker=l.ticker
     and (missing(l.sdate) or l.sdate <= d.actdats)
     and (missing(l.edate) or l.edate >= d.actdats);

    create table det_link_counts as
    select rowid, count(distinct permno) as n_permno
    from det_link_candidates group by rowid;

    create table det_linked0 as
    select d.*, l.permno, c.n_permno
    from det_raw as d
      inner join det_link_candidates as l on d.rowid=l.rowid
      inner join det_link_counts as c on d.rowid=c.rowid
    where c.n_permno=1;

    create table permno_set as
    select distinct permno from det_linked0;
quit;

/* CRSP market sessions define the event calendar and stock/market return alignment. */
data market0;
    set crsp.dsi (keep=date vwretd where=(date >= &d0 and date <= &d1));
    format date date9.;
run;
proc sort data=market0; by date; run;
data market;
    set market0;
    session + 1;
run;

data caldays;
    do caldate = &d0 to &d1;
        output;
    end;
    format caldate date9.;
run;
proc sql;
    create table calmap0 as
    select c.caldate, min(m.date) as trade_date format=date9.
    from caldays as c left join market as m on m.date >= c.caldate
    group by c.caldate;

    create table calmap as
    select c.caldate, c.trade_date, m.session
    from calmap0 as c left join market as m on c.trade_date=m.date;
quit;

/* Build documented GBP cross-rates only for currencies used by these source products. */
data fx_curr_detail;
    set det_raw (keep=report_curr);
    length curr $3;
    curr=upcase(strip(report_curr));
    if not missing(curr);
    keep curr;
run;
data fx_curr_comp;
    set funda0 (keep=curcd);
    length curr $3;
    curr=upcase(strip(curcd));
    if not missing(curr);
    keep curr;
run;
data fx_curr_summary;
    set summ_raw (keep=curcode);
    length curr $3;
    curr=upcase(strip(curcode));
    if not missing(curr);
    keep curr;
run;
data fx_curr_exp;
    length curr $3;
    set fx_curr_detail fx_curr_comp fx_curr_summary end=eof;
    if lengthn(strip(curr))=3 then output;
    if eof then do;
        curr='USD'; output;
        curr='GBP'; output;
    end;
    keep curr;
run;
proc sort data=fx_curr_exp out=fx_currency_set nodupkey;
    by curr;
run;

proc sql;
    create table fx_dly_gbp0 as
    select e.datadate as fxdate format=date9.,
           upcase(strip(e.tocurd)) as curr length=3, e.exratd
    from compfx.g_exrt_dly as e inner join fx_currency_set as c
      on upcase(strip(e.tocurd))=c.curr
    where upcase(strip(e.fromcurd))='GBP' and e.datadate<=&d1;

    create table fx_dly_card as
    select fxdate, curr, count(*) as n_rows
    from fx_dly_gbp0 group by fxdate, curr;

    create table fx_dly_unique as
    select r.fxdate, r.curr, r.exratd
    from fx_dly_gbp0 as r inner join fx_dly_card as c
      on r.fxdate=c.fxdate and r.curr=c.curr
    where c.n_rows=1 and not missing(r.exratd) and r.exratd>0;

    create table fx_dly_cross0 as
    select a.fxdate, a.curr, u.exratd/a.exratd as usd_rate
    from fx_dly_unique as a inner join fx_dly_unique as u
      on a.fxdate=u.fxdate and u.curr='USD'
    where a.exratd>0 and u.exratd>0;

    create table fx_grid0 as
    select d.caldate as fxdate format=date9., c.curr
    from caldays as d, fx_currency_set as c;
quit;
proc sort data=fx_grid0; by curr fxdate; run;
proc sort data=fx_dly_cross0; by curr fxdate; run;
data fx_dly_carry;
    merge fx_grid0(in=ingrid) fx_dly_cross0(in=inrate);
    by curr fxdate;
    retain last_usd_rate last_quote_date;
    if first.curr then do;
        last_usd_rate=.; last_quote_date=.;
    end;
    if inrate and not missing(usd_rate) and usd_rate>0 then do;
        last_usd_rate=usd_rate;
        last_quote_date=fxdate;
    end;
    if ingrid then do;
        fxrate=last_usd_rate;
        quote_date=last_quote_date;
        output;
    end;
    format fxdate quote_date date9.;
    keep curr fxdate fxrate quote_date;
run;

proc sql;
    create table fx_mth_gbp0 as
    select year(e.datadate)*100+month(e.datadate) as monthkey,
           upcase(strip(e.tocurm)) as curr length=3, e.exrat12m
    from compfx.g_exrt_mth as e inner join fx_currency_set as c
      on upcase(strip(e.tocurm))=c.curr
    where upcase(strip(e.fromcurm))='GBP' and e.datadate<=&d1;

    create table fx_mth_card as
    select monthkey, curr, count(*) as n_rows
    from fx_mth_gbp0 group by monthkey, curr;

    create table fx_mth_unique as
    select r.monthkey, r.curr, r.exrat12m
    from fx_mth_gbp0 as r inner join fx_mth_card as c
      on r.monthkey=c.monthkey and r.curr=c.curr
    where c.n_rows=1 and not missing(r.exrat12m) and r.exrat12m>0;

    create table fx_mth_cross0 as
    select a.monthkey, a.curr, u.exrat12m/a.exrat12m as usd_rate
    from fx_mth_unique as a inner join fx_mth_unique as u
      on a.monthkey=u.monthkey and u.curr='USD'
    where a.exrat12m>0 and u.exrat12m>0;

    create table fx_mth_cross_card as
    select monthkey, curr, count(*) as n_rows
    from fx_mth_cross0 group by monthkey, curr;

    create table fx_mth_usd as
    select r.monthkey, r.curr, r.usd_rate
    from fx_mth_cross0 as r inner join fx_mth_cross_card as c
      on r.monthkey=c.monthkey and r.curr=c.curr
    where c.n_rows=1;
quit;
proc sql;
    select count(*) as n_fx_currencies from fx_currency_set;
    select count(*) as n_daily_rate_keys, sum(n_rows>1) as n_duplicate_daily_rate_keys
    from fx_dly_card;
    select curr, count(*) as n_calendar_days, sum(missing(fxrate)) as n_no_daily_rate,
           max(fxdate-quote_date) as max_quote_age
    from fx_dly_carry group by curr;
    select count(*) as n_monthly_rate_keys, sum(n_rows>1) as n_duplicate_monthly_rate_keys
    from fx_mth_card;
    select curr, count(*) as n_monthly_unique_rates
    from fx_mth_usd group by curr;
quit;

/* Read only CRSP daily rows for PERMNOs present in the dated I/B/E/S link table. */
data crsp_small;
    if _n_=1 then do;
        declare hash hp(dataset:"work.permno_set");
        hp.defineKey('permno');
        hp.defineDone();
    end;
    set crsp.dsf (keep=permno permco date ret prc cfacshr
                  where=(date >= &d0 and date <= &d1));
    if hp.check()=0;
    format date date9.;
run;
proc sql;
    create table daily as
    select d.permno, d.permco, d.date, m.session, d.ret, d.prc,
           d.cfacshr, m.vwretd
    from crsp_small as d inner join market as m on d.date=m.date;

    create table daily_key_card as
    select permno, date, count(*) as n_rows
    from daily group by permno, date;

    select count(*) as n_daily_keys,
           sum(n_rows>1) as n_duplicate_daily_keys
    from daily_key_card;
quit;
data _null_;
    set daily_key_card;
    if n_rows>1 then do;
        put 'ERROR: Duplicate PERMNO/date key in daily CRSP input.';
        abort cancel;
    end;
run;

/* Detail VALUE uses ANNDATS (ACTDATS only when ANNDATS is absent). Build
   source-date factors from the last supported observation for that PERMNO. */
proc sql;
    create table det_basis_req as
    select distinct permno,
           case when not missing(anndats) and anndats>0 then anndats
                else actdats end as basis_date format=date9.
    from det_linked0;

    create table det_basis_feed0 as
    select permno, date, cfacshr, 0 as req_flag
    from daily
    union all
    select permno, basis_date as date, . as cfacshr, 1 as req_flag
    from det_basis_req;

    create table det_basis_feed as
    select permno, date, max(cfacshr) as cfacshr,
           max(req_flag) as req_flag
    from det_basis_feed0
    group by permno, date;
quit;
proc sort data=det_basis_feed; by permno date; run;
data det_basis_asof;
    set det_basis_feed;
    by permno;
    retain last_date last_cf;
    if first.permno then call missing(last_date,last_cf);
    if not missing(cfacshr) and cfacshr>0 then do;
        last_date=date;
        last_cf=cfacshr;
    end;
    if req_flag=1 then do;
        basis_date=date;
        valcf=last_cf;
        valcf_date=last_date;
        valcf_age=basis_date-valcf_date;
        if missing(valcf) or missing(valcf_age) or valcf_age>&max_factor_age
            then valcf=.;
        output;
    end;
    keep permno basis_date valcf valcf_date valcf_age;
    format basis_date valcf_date date9.;
run;
proc sql;
    create table det_basis_card as
    select permno, basis_date, count(*) as n_rows
    from det_basis_asof group by permno, basis_date;
    select count(*) as n_detail_basis_keys,
           sum(n_rows>1) as n_duplicate_detail_basis_keys
    from det_basis_card;
quit;
data _null_;
    set det_basis_card;
    if n_rows>1 then do;
        put 'ERROR: Duplicate PERMNO/date key in Detail basis map.';
        abort cancel;
    end;
run;

/* A non-unit CRSP split-factor change should remove the split from daily prices. */
proc sort data=daily out=daily_ordered; by permno date; run;
data split_audit;
    set daily_ordered;
    by permno;
    retain prior_date prior_prc prior_cfac;
    if first.permno then do;
        prior_date=.; prior_prc=.; prior_cfac=.;
    end;
    else if not missing(prior_cfac) and not missing(cfacshr) then do;
        if prior_cfac>0 and cfacshr>0 and cfacshr ne prior_cfac then do;
            if not missing(prior_prc) and not missing(prc) then do;
                if abs(prior_prc)>0 and abs(prc)>0 then do;
                    factor_ratio=cfacshr/prior_cfac;
                    raw_price_ratio=abs(prior_prc)/abs(prc);
                    adjusted_price_ratio=raw_price_ratio*factor_ratio;
                    output;
                end;
            end;
        end;
    end;
    prior_date=date; prior_prc=prc; prior_cfac=cfacshr;
    format prior_date date9.;
    keep permno prior_date date prior_prc prc prior_cfac cfacshr
         factor_ratio raw_price_ratio adjusted_price_ratio;
run;
proc sql;
    select count(*) as n_cfac_changes,
           sum(abs(factor_ratio-1)>1e-8) as n_nonunit_cfac_changes,
           min(factor_ratio) as min_cfac_ratio,
           max(factor_ratio) as max_cfac_ratio,
           min(adjusted_price_ratio) as min_split_adj_price_ratio,
           max(adjusted_price_ratio) as max_split_adj_price_ratio
    from split_audit;
quit;
proc means data=split_audit n mean median min max;
    var factor_ratio raw_price_ratio adjusted_price_ratio;
run;
data split_synthetic;
    pre_price=100; post_price=50; pre_cfac=2; post_cfac=1;
    factor_ratio=post_cfac/pre_cfac;
    raw_price_ratio=pre_price/post_price;
    adjusted_price_ratio=raw_price_ratio*factor_ratio;
    rebased_pre_price=pre_price*post_cfac/pre_cfac;
    output;
run;
proc print data=split_synthetic noobs;
run;

/* Event centers remain on/after ACTDATS. Only source VALUE factors use as-of. */
proc sql;
    create table det_evt0 as
    select d.*, c.trade_date, c.session as evsess,
           x.permco, x.cfacshr as evcf,
           case when not missing(d.analys) and d.analys>0 then d.analys
                else -d.rowid end as seq_analys,
           (not missing(d.analys) and d.analys>0) as analys_valid,
           case when not missing(d.anndats) and d.anndats>0 then d.anndats
                else d.actdats end as value_date format=date9.,
           v.trade_date as value_trade_date,
           z.cfacshr as legacy_valcf,
           y.valcf, y.valcf_date, y.valcf_age,
           fx.fxrate as fx_event,
           fx.quote_date as fx_event_quote
    from det_linked0 as d
      left join calmap as c on d.actdats=c.caldate
      left join daily as x on d.permno=x.permno and c.trade_date=x.date
      left join calmap as v
        on (case when not missing(d.anndats) and d.anndats>0 then d.anndats
                 else d.actdats end)=v.caldate
      left join daily as z on d.permno=z.permno and v.trade_date=z.date
      left join det_basis_asof as y
        on d.permno=y.permno
       and y.basis_date=(case when not missing(d.anndats) and d.anndats>0
                              then d.anndats else d.actdats end)
      left join fx_dly_carry as fx on fx.curr=d.report_curr and fx.fxdate=d.actdats;
quit;

proc sql;
    select count(*) as n_detail_source_basis_rows,
           sum(value_date ne value_trade_date) as n_detail_nontrading_basis,
           sum(not missing(legacy_valcf) and not missing(valcf)
               and abs(legacy_valcf/valcf-1)>1e-8)
               as n_det_nextcf_diff,
           sum(value_date ne value_trade_date and not missing(legacy_valcf)
               and not missing(valcf) and abs(legacy_valcf/valcf-1)>1e-8)
               as n_det_nontrade_diff,
           sum(missing(valcf)) as n_detail_missing_asof_factors,
           max(valcf_age) as max_detail_factor_age
    from det_evt0;
quit;

/* ANALYS identifies the analyst; ESTIMATOR remains the brokerage-house unit. */
proc sort data=det_evt0 out=det_ord;
    by ticker seq_analys fpi fpedats pdf actdats acttims rowid;
run;
data det_seq0;
    length last_curr prev_curr $3;
    set det_ord;
    by ticker seq_analys fpi fpedats pdf;
    retain last_value last_vcf last_row last_date last_time last_curr
           last_estimator last_permno;
    if first.pdf then do;
        has_prev=0;
        prev_value=.; prev_valcf=.; prev_row=.; prev_date=.; prev_time=.;
        prev_curr=''; prev_estimator=.; prev_permno=.;
    end;
    else do;
        has_prev=1;
        prev_value=last_value; prev_valcf=last_vcf; prev_row=last_row;
        prev_date=last_date; prev_time=last_time;
        prev_curr=last_curr; prev_estimator=last_estimator;
        prev_permno=last_permno;
    end;
    last_value=value; last_vcf=valcf; last_row=rowid;
    last_date=actdats; last_time=acttims; last_curr=report_curr;
    last_estimator=estimator; last_permno=permno;
    format prev_date date9.;
run;
proc sql;
    create table det_seq_fx as
    select s.*, fx.fxrate as prev_fx_event,
           fx.quote_date as prev_fx_event_quote
    from det_seq0 as s
      left join fx_dly_carry as fx
        on fx.curr=s.prev_curr and fx.fxdate=s.actdats;
quit;
data det_seq;
    set det_seq_fx;
    changed=.;
    if analys_valid and has_prev and permno=prev_permno
       and not missing(value) and not missing(prev_value)
       and not missing(evcf) and evcf>0
       and not missing(valcf) and valcf>0
       and not missing(prev_valcf) and prev_valcf>0 then do;
        if report_curr=prev_curr then
            changed=(value ne prev_value*valcf/prev_valcf);
        else if not missing(fx_event) and fx_event>0
             and not missing(prev_fx_event) and prev_fx_event>0 then
            changed=(value*evcf/valcf*fx_event
                     ne prev_value*evcf/prev_valcf*prev_fx_event);
    end;
    hist_forecast=(analys_valid and (not has_prev or changed=1));
    revision_unknown=(not analys_valid or (has_prev and missing(changed)));
run;
proc sql;
    select count(*) as n_sequences,
           sum(has_prev and permno ne prev_permno) as n_permno_transitions,
           sum(has_prev and permno ne prev_permno and fpi='1' and pdf='P')
               as n_fy1primary_permno_transitions,
           sum(has_prev and permno ne prev_permno and actdats between
               '01jan1990'd and '31dec1994'd) as n_test_period_permno_transitions,
           sum(revision_unknown=1) as n_unknown_after_guards
    from det_seq;
quit;

/* Standardized North American industrial annual fundamentals, including support actuals. */
proc sql;
    create table funda_card as
    select gvkey, datadate, count(*) as n_rows
    from funda0 group by gvkey, datadate;

    create table funda_unique as
    select f.*
    from funda0 as f inner join funda_card as c
      on f.gvkey=c.gvkey and f.datadate=c.datadate
    where c.n_rows=1;

    create table sec_cusip0 as
    select strip(gvkey) as gvkey, strip(iid) as iid,
           upcase(substr(strip(itemvalue),1,8)) as hist_cusip length=8,
           efffrom, effthru
    from compsec.sec_idhist
    where upcase(strip(item))='CUSIP' and not missing(itemvalue);

    create table sec_primary0 as
    select strip(gvkey) as gvkey, strip(itemvalue) as primary_iid length=4,
           effdate, thrudate
    from compsec.sec_history
    where upcase(strip(item))='PRIHISTUSA' and not missing(itemvalue);

    create table crsp_names0 as
    select permno, permco, namedt, nameendt,
           upcase(strip(ncusip)) as ncusip length=8
    from crsp.dsenames
    where not missing(ncusip);

    create table funda_issue0 as
    select f.*, i.iid, i.hist_cusip, n.permno, n.permco
    from funda_unique as f inner join sec_cusip0 as i
      on f.gvkey=i.gvkey
     and (missing(i.efffrom) or i.efffrom<=f.datadate)
     and (missing(i.effthru) or i.effthru>=f.datadate)
      inner join sec_primary0 as p
      on i.gvkey=p.gvkey and i.iid=p.primary_iid
     and (missing(p.effdate) or p.effdate<=f.datadate)
     and (missing(p.thrudate) or p.thrudate>=f.datadate)
      inner join crsp_names0 as n
      on i.hist_cusip=n.ncusip
     and (missing(n.namedt) or n.namedt<=f.datadate)
     and (missing(n.nameendt) or n.nameendt>=f.datadate);

    create table funda_issue_key as
    select gvkey, datadate, iid, hist_cusip,
           count(*) as n_rows, count(distinct permno) as n_permno
    from funda_issue0
    group by gvkey, datadate, iid, hist_cusip;

    create table funda_issue_card as
    select gvkey, datadate, count(distinct iid) as n_iid,
           count(distinct hist_cusip) as n_cusip
    from funda_issue0
    group by gvkey, datadate;

    create table funda_sec_unique as
    select i.*
    from funda_issue0 as i inner join funda_issue_key as k
      on i.gvkey=k.gvkey and i.datadate=k.datadate
     and i.iid=k.iid and i.hist_cusip=k.hist_cusip
      inner join funda_issue_card as c
      on i.gvkey=c.gvkey and i.datadate=c.datadate
    where k.n_rows=k.n_permno and c.n_iid=1 and c.n_cusip=1;

    create table funda_perm_card as
    select permno, datadate, count(*) as n_rows,
           count(distinct gvkey) as n_gvkey
    from funda_sec_unique group by permno, datadate;

    create table funda_linked as
    select f.*
    from funda_sec_unique as f inner join funda_perm_card as c
      on f.permno=c.permno and f.datadate=c.datadate
    where c.n_rows=1 and c.n_gvkey=1;

    create table fyr_card as
    select gvkey, min(fyr) as fyr, count(distinct fyr) as n_fyr, count(*) as n_periods
    from funda_unique
    where year(datadate) between 1988 and 1994 and not missing(fyr)
    group by gvkey;

    create table stable_fyr as
    select gvkey, fyr, n_periods
    from fyr_card where n_fyr=1;
quit;

/* Annual fourth-quarter report date is used for as-of ability accuracy. */
data q4_raw;
    set comp.fundq
        (keep=gvkey datadate fqtr rdq fyr indfmt consol popsrc datafmt
         where=(datadate >= &d0 and datadate <= &d1 and fqtr=4
                and indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'));
    format datadate rdq date9.;
run;
proc sql;
    create table q4_card as
    select gvkey, datadate, count(*) as n_rows, count(distinct rdq) as n_rdq
    from q4_raw where not missing(rdq)
    group by gvkey, datadate;

    create table q4_unique as
    select q.gvkey, q.datadate, min(q.rdq) as rdq format=date9.
    from q4_raw as q inner join q4_card as c
      on q.gvkey=c.gvkey and q.datadate=c.datadate
    where c.n_rows=1 and c.n_rdq=1
    group by q.gvkey, q.datadate;

    create table funda_actual as
    select f.*, q.rdq
    from funda_linked as f left join q4_unique as q
      on f.gvkey=q.gvkey and f.datadate=q.datadate;
quit;

/* Historical ability forecasts are scoreable only with same-period EPSPX, RDQ and consensus. */
data ib_hist;
    set det_seq;
    where fpi='1' and pdf='P' and not missing(report_curr)
          and not missing(analys) and analys>0
          and year(actdats) between 1988 and 1994 and hist_forecast=1;
run;

proc sql;
    create table hist_comp0 as
    select h.*, f.gvkey, f.datadate, f.fyr, f.epspx, f.curcd, f.rdq,
           sy.fyr as stable_fyr
    from ib_hist as h
      inner join funda_actual as f
        on h.permno=f.permno and h.fpedats=f.datadate
      left join stable_fyr as sy on f.gvkey=sy.gvkey
    where not missing(f.epspx) and not missing(f.curcd);

    create table hist_comp as
    select h.*
    from hist_comp0 as h
    where not missing(h.rdq) and not missing(h.valcf) and h.valcf>0;

    create table summ_card as
    select ticker, fpedats, statpers, fpi, fiscalp, estflag, curcode,
           count(*) as n_rows
    from summ_raw
    group by ticker, fpedats, statpers, fpi, fiscalp, estflag, curcode;

    create table summ0 as
    select s.*
    from summ_raw as s inner join summ_card as c
      on s.ticker=c.ticker and s.fpedats=c.fpedats and s.statpers=c.statpers
     and s.fpi=c.fpi and s.fiscalp=c.fiscalp and s.estflag=c.estflag
     and s.curcode=c.curcode
    where c.n_rows=1;

    create table hist_sum_date as
    select h.rowid, max(s.statpers) as statpers format=date9.
    from hist_comp as h inner join summ0 as s
      on h.ticker=s.ticker and h.fpedats=s.fpedats
     and s.statpers <= h.value_date
    group by h.rowid;

    create table hist_sum_candidates as
    select h.rowid, s.statpers, s.curcode, s.medest,
           (s.curcode=h.report_curr) as same_currency
    from hist_comp as h inner join hist_sum_date as d on h.rowid=d.rowid
      inner join summ0 as s on h.ticker=s.ticker and h.fpedats=s.fpedats
       and d.statpers=s.statpers;

    create table hist_sum_pref as
    select rowid, count(*) as n_latest_currencies,
           sum(same_currency) as n_same_currency
    from hist_sum_candidates group by rowid;

    create table hist_sum as
    select h.*, s.statpers as condate, s.medest, s.curcode,
           p.n_latest_currencies, p.n_same_currency,
           (s.curcode ne h.report_curr) as mixed_consensus_currency
    from hist_comp as h inner join hist_sum_date as d on h.rowid=d.rowid
      inner join hist_sum_pref as p on h.rowid=p.rowid
      inner join hist_sum_candidates as s
        on h.rowid=s.rowid and d.statpers=s.statpers
    where (p.n_same_currency>0 and s.same_currency=1)
       or (p.n_same_currency=0 and p.n_latest_currencies=1);
quit;

/* STATPERS and DATADATE are each mapped to their own same-PERMNO as-of factor. */
proc sql;
    create table hist_basis_req as
    select distinct permno, condate as basis_date format=date9.
    from hist_sum
    where not missing(condate)
    union
    select distinct permno, datadate as basis_date format=date9.
    from hist_sum
    where not missing(datadate);

    create table hist_basis_feed0 as
    select permno, date, cfacshr, 0 as req_flag
    from daily
    union all
    select permno, basis_date as date, . as cfacshr, 1 as req_flag
    from hist_basis_req;

    create table hist_basis_feed as
    select permno, date, max(cfacshr) as cfacshr,
           max(req_flag) as req_flag
    from hist_basis_feed0
    group by permno, date;
quit;
proc sort data=hist_basis_feed; by permno date; run;
data hist_basis_asof;
    set hist_basis_feed;
    by permno;
    retain last_date last_cf;
    if first.permno then call missing(last_date,last_cf);
    if not missing(cfacshr) and cfacshr>0 then do;
        last_date=date;
        last_cf=cfacshr;
    end;
    if req_flag=1 then do;
        basis_date=date;
        basis_cf=last_cf;
        basis_cf_date=last_date;
        basis_cf_age=basis_date-basis_cf_date;
        if missing(basis_cf) or missing(basis_cf_age)
           or basis_cf_age>&max_factor_age then basis_cf=.;
        output;
    end;
    keep permno basis_date basis_cf basis_cf_date basis_cf_age;
    format basis_date basis_cf_date date9.;
run;
proc sql;
    create table hist_factors0 as
    select h.*, cs.trade_date as constrade_date,
           sc.cfacshr as legacy_conscf,
           csf.basis_cf as conscf,
           csf.basis_cf_date as conscf_date,
           csf.basis_cf_age as conscf_age,
           fc.trade_date as fisctdate,
           fd.cfacshr as legacy_fiscf,
           faf.basis_cf as fiscf,
           faf.basis_cf_date as fiscf_date,
           faf.basis_cf_age as fiscf_age,
           fxd.fxrate as detail_usd_rate, fxd.quote_date as detail_fx_quote,
           fxs.fxrate as summary_usd_rate, fxs.quote_date as summary_fx_quote,
           fxm.usd_rate as actual_usd_rate
    from hist_sum as h
      left join calmap as cs on h.condate=cs.caldate
      left join daily as sc on h.permno=sc.permno and cs.trade_date=sc.date
      left join calmap as fc on h.datadate=fc.caldate
      left join daily as fd on h.permno=fd.permno and fc.trade_date=fd.date
      left join hist_basis_asof as csf
        on h.permno=csf.permno and h.condate=csf.basis_date
      left join hist_basis_asof as faf
        on h.permno=faf.permno and h.datadate=faf.basis_date
      left join fx_dly_carry as fxd
        on fxd.curr=h.report_curr and fxd.fxdate=h.value_date
      left join fx_dly_carry as fxs
        on fxs.curr=h.curcode and fxs.fxdate=h.condate
      left join fx_mth_usd as fxm
        on fxm.curr=h.curcd
       and fxm.monthkey=year(h.datadate)*100+month(h.datadate);
quit;
proc sql;
    select count(*) as n_history_source_basis_rows,
           sum(condate ne constrade_date) as n_summary_nontrading_basis,
           sum(datadate ne fisctdate) as n_actual_nontrading_basis,
           sum(not missing(legacy_conscf) and not missing(conscf)
               and abs(legacy_conscf/conscf-1)>1e-8)
               as n_sum_nextcf_diff,
           sum(not missing(legacy_fiscf) and not missing(fiscf)
               and abs(legacy_fiscf/fiscf-1)>1e-8)
               as n_eps_nextcf_diff,
           sum(condate ne constrade_date and not missing(legacy_conscf)
               and not missing(conscf) and abs(legacy_conscf/conscf-1)>1e-8)
               as n_sum_nontrade_diff,
           sum(datadate ne fisctdate and not missing(legacy_fiscf)
               and not missing(fiscf) and abs(legacy_fiscf/fiscf-1)>1e-8)
               as n_eps_nontrade_diff,
           sum(missing(conscf) or missing(fiscf)) as n_missing_asof_history_factors,
           max(conscf_age) as max_summary_factor_age,
           max(fiscf_age) as max_actual_factor_age
    from hist_factors0;
quit;
data hist_scored0;
    length currency_route $16;
    set hist_factors0;
    score_ok=0;
    if not missing(rdq) and not missing(valcf) and valcf>0
       and not missing(conscf) and conscf>0
       and not missing(fiscf) and fiscf>0 then do;
        if report_curr=curcode and report_curr=curcd then do;
            currency_route='same_currency';
            forecast_value=value;
            actual_at_forecast=epspx*valcf/fiscf;
            consensus_at_forecast=medest*valcf/conscf;
            score_ok=1;
        end;
        else if not missing(detail_usd_rate) and detail_usd_rate>0
             and not missing(summary_usd_rate) and summary_usd_rate>0
             and not missing(actual_usd_rate) and actual_usd_rate>0 then do;
            currency_route='mixed_currency';
            forecast_value=value*detail_usd_rate;
            actual_at_forecast=epspx*actual_usd_rate*valcf/fiscf;
            consensus_at_forecast=medest*summary_usd_rate*valcf/conscf;
            score_ok=1;
        end;
        else currency_route='fx_missing';
    end;
    if score_ok then
        useful=(abs(forecast_value-actual_at_forecast)
              < abs(consensus_at_forecast-actual_at_forecast));
    score_year=year(actdats);
run;
data hist_scored;
    set hist_scored0;
    where score_ok=1;
run;
proc sql;
    create table hist_analyst_broker_card as
    select gvkey, analys, count(distinct estimator) as n_estimators,
           count(*) as n_scoreable_history
    from hist_scored0
    where score_ok=1 and not missing(analys) and analys>0
    group by gvkey, analys;
    select count(*) as n_gvkey_analyst_pairs,
           sum(n_estimators>1) as n_pairs_multi_estimator,
           sum(case when n_estimators>1 then n_scoreable_history else 0 end)
               as n_scoreable_multi_estimator,
           max(n_estimators) as max_estimators_per_pair
    from hist_analyst_broker_card;

    select count(*) as n_scored_history_pairs,
           sum(currency_route='same_currency') as n_same_currency_scores,
           sum(currency_route='mixed_currency') as n_mixed_currency_scores,
           sum(currency_route='fx_missing') as n_fx_missing_scores,
           sum(abs(valcf/conscf-1)>1e-8) as n_consensus_rebased,
           sum(abs(valcf/fiscf-1)>1e-8) as n_epspx_rebased,
           min(valcf/conscf) as min_consensus_factor_ratio,
           max(valcf/conscf) as max_consensus_factor_ratio,
           min(valcf/fiscf) as min_epspx_factor_ratio,
           max(valcf/fiscf) as max_epspx_factor_ratio
    from hist_scored0;
    select sum(n_same_currency=0 and n_latest_currencies>1) as n_ambig_summary,
           sum(n_same_currency=0 and n_latest_currencies=1) as n_mixed_summary
    from hist_sum_pref;
quit;

/* Brokerage houses are distinct estimator codes by Compustat firm/year, before final event screens. */
proc sql;
    create table broker_year as
    select f.gvkey, year(e.actdats) as calyear,
           count(distinct e.estimator) as n_brokers
    from det_seq as e inner join funda_linked as f
      on e.permno=f.permno and e.fpedats=f.datadate
    where e.fpi='1' and e.pdf='P' and not missing(e.report_curr)
      and not missing(f.curcd)
      and year(e.actdats) between 1988 and 1994
    group by f.gvkey, calculated calyear;

    create table broker_ok as
    select gvkey, count(*) as n_years, min(n_brokers) as min_brokers
    from broker_year where n_brokers>=5
    group by gvkey having count(*)=7;

    create table main0 as
    select e.*, f.gvkey, f.epspx as target_epspx, f.curcd as target_curcd,
           sy.fyr as stable_fyr, b.n_years as broker_years,
           b.min_brokers
    from det_seq as e
      inner join funda_linked as f
        on e.permno=f.permno and e.fpedats=f.datadate
      inner join stable_fyr as sy on f.gvkey=sy.gvkey
      inner join broker_ok as b on f.gvkey=b.gvkey
    where e.changed=1 and e.fpi='1' and e.pdf='P'
      and not missing(e.report_curr) and not missing(e.analys) and e.analys>0
      and not missing(f.curcd)
      and not missing(f.epspx) and e.actdats between &sample0 and &sample1;

    create table hist_broker_audit as
    select e.rowid,
           count(h.rowid) as n_scored,
           sum(case when not missing(h.rowid) then h.useful else 0 end) as n_useful,
           sum(case when not missing(h.rowid)
                     and year(h.actdats)=year(e.actdats)-2 then 1 else 0 end) as n_y2,
           sum(case when not missing(h.rowid)
                     and year(h.actdats)=year(e.actdats)-1 then 1 else 0 end) as n_y1,
           count(distinct h.estimator) as n_history_estimators,
           sum(case when not missing(h.rowid) and h.estimator=e.estimator
                    then 1 else 0 end) as n_same_broker_scored,
           sum(case when not missing(h.rowid) and h.estimator=e.estimator
                     and year(h.actdats)=year(e.actdats)-2 then 1 else 0 end)
               as n_same_broker_y2,
           sum(case when not missing(h.rowid) and h.estimator=e.estimator
                     and year(h.actdats)=year(e.actdats)-1 then 1 else 0 end)
               as n_same_broker_y1
    from main0 as e left join hist_scored as h
      on e.gvkey=h.gvkey and e.analys=h.analys
     and h.actdats >= mdy(1,1,year(e.actdats)-2)
     and h.actdats <  mdy(1,1,year(e.actdats))
     and h.rdq <= e.actdats
    group by e.rowid;

    create table hist_score_counts as
    select * from hist_broker_audit;

    select count(*) as n_ability_windows,
           sum(n_history_estimators>1) as n_windows_multi_estimator,
           sum(n_scored>n_same_broker_scored) as n_windows_cross_broker_history,
           sum(n_scored>=5 and n_y2>=1 and n_y1>=1)
               as n_source_eligible_windows,
           sum(n_same_broker_scored>=5 and n_same_broker_y2>=1
               and n_same_broker_y1>=1) as n_broker_key_eligible_windows
    from hist_broker_audit;

    create table main_ability as
    select m.*, a.n_scored, a.n_useful, a.n_y2, a.n_y1,
           a.n_useful/a.n_scored as ability
    from main0 as m inner join hist_score_counts as a on m.rowid=a.rowid
    where a.n_scored>=5 and a.n_y2>=1 and a.n_y1>=1;
quit;

data main_class;
    set main_ability;
    superior=(ability >= .80);
    inferior=(ability <= .20);
    normal=(ability > .20 and ability < .80);
run;

/* Build broad event and company-confounder populations before analyst/final eligibility. */
data all_revisions;
    set det_seq;
    where (changed=1 or revision_unknown=1) and measure='EPS'
      and actdats between '15dec1989'd and '15jan1995'd
      and not missing(evsess);
run;
proc sql;
    create table all_rev_exact_card as
    select ticker, estimator, analys, fpi, fpedats, pdf, actdats, acttims,
           report_curr, value, count(*) as n_rows
    from all_revisions
    group by ticker, estimator, analys, fpi, fpedats, pdf, actdats, acttims,
             report_curr, value;
    select count(*) as n_revision_signatures,
           sum(n_rows>1) as n_duplicate_revision_signatures,
           sum(case when n_rows>1 then n_rows-1 else 0 end)
               as n_duplicate_revision_rows
    from all_rev_exact_card;

    create table all_rev_sim_card as
    select permco, analys, actdats, acttims,
           count(*) as n_rows, count(distinct fpi) as n_fpi,
           count(distinct fpedats) as n_fpedats,
           count(distinct estimator) as n_estimators
    from all_revisions
    where not missing(analys) and analys>0
      and not missing(actdats) and not missing(acttims)
    group by permco, analys, actdats, acttims;
    select count(*) as n_analyst_time_groups,
           sum(n_rows>1) as n_multirow_groups,
           sum(n_fpi>1) as n_multifpi_groups,
           sum(n_fpedats>1) as n_multifpedats_groups,
           sum(n_estimators>1) as n_multibroker_groups
    from all_rev_sim_card;
quit;

data earn_raw;
    set comp.fundq (keep=gvkey datadate fqtr rdq indfmt consol popsrc datafmt
                    where=(rdq >= '15dec1989'd and rdq <= '15jan1995'd
                           and indfmt='INDL' and consol='C'
                           and popsrc='D' and datafmt='STD'));
    gvkey=strip(gvkey);
    format rdq date9.;
run;
proc sql;
    create table earn_dates0 as
    select distinct e.gvkey, e.rdq, c.session
    from earn_raw as e inner join calmap as c on e.rdq=c.caldate;

    create table div_raw as
    select permno, permco, dclrdt
    from crsp.dseall
    where not missing(dclrdt) and dclrdt >= '15dec1989'd
      and dclrdt <= '15jan1995'd;

    create table div_dates0 as
    select distinct d.permco, d.dclrdt, c.session
    from div_raw as d inner join calmap as c on d.dclrdt=c.caldate;

    create table rev_overlaps as
    select e.rowid, count(r.rowid) as n_rev_centers,
           sum(case when r.rowid=e.rowid then 1 else 0 end)
               as n_self_rev_centers,
           sum(case when not missing(r.rowid) and r.rowid ne e.rowid
                    then 1 else 0 end) as n_other_rev_centers,
           sum(case when not missing(r.rowid) and r.rowid ne e.rowid
                     and r.analys=e.analys and r.actdats=e.actdats
                     and not missing(r.acttims) and r.acttims=e.acttims
                     and (r.fpi ne e.fpi or r.fpedats ne e.fpedats)
                    then 1 else 0 end) as n_same_time_other_horizon
    from main_class as e left join all_revisions as r
      on e.permco=r.permco and r.evsess between e.evsess-2 and e.evsess+2
    group by e.rowid;

    create table earn_overlaps as
    select e.rowid, count(q.rdq) as n_earn_centers
    from main_class as e left join earn_dates0 as q
      on e.gvkey=q.gvkey and q.session between e.evsess-3 and e.evsess+3
    group by e.rowid;

    create table div_overlaps as
    select e.rowid, count(d.dclrdt) as n_div_centers
    from main_class as e left join div_dates0 as d
      on e.permco=d.permco and d.session between e.evsess-3 and e.evsess+3
    group by e.rowid;

    create table main_screen0 as
    select e.*, r.n_rev_centers, r.n_self_rev_centers,
           r.n_other_rev_centers, r.n_same_time_other_horizon,
           q.n_earn_centers, v.n_div_centers
    from main_class as e
      left join rev_overlaps as r on e.rowid=r.rowid
      left join earn_overlaps as q on e.rowid=q.rowid
      left join div_overlaps as v on e.rowid=v.rowid;

    create table ret0 as
    select e.rowid,
      count(d.session) as n_sessions,
      count(d.ret) as n_stock_ret,
      count(d.vwretd) as n_market_ret,
      max(case when d.session=e.evsess-1 then d.ret end) as r_m1,
      max(case when d.session=e.evsess   then d.ret end) as r_0,
      max(case when d.session=e.evsess+1 then d.ret end) as r_p1,
      max(case when d.session=e.evsess-1 then d.vwretd end) as m_m1,
      max(case when d.session=e.evsess   then d.vwretd end) as m_0,
      max(case when d.session=e.evsess+1 then d.vwretd end) as m_p1
    from main_screen0 as e left join daily as d
      on e.permno=d.permno and d.session between e.evsess-1 and e.evsess+1
    group by e.rowid;

    create table price0 as
    select e.rowid, p.prc, p.cfacshr as price_cf
    from main_screen0 as e left join daily as p
      on e.permno=p.permno and p.session=e.evsess-2;

    create table main_screen1 as
    select e.*, r.n_sessions, r.n_stock_ret, r.n_market_ret,
           r.r_m1, r.r_0, r.r_p1, r.m_m1, r.m_0, r.m_p1,
           p.prc, p.price_cf
    from main_screen0 as e
      left join ret0 as r on e.rowid=r.rowid
      left join price0 as p on e.rowid=p.rowid;
quit;

data analysis0;
    set main_screen1;
    if missing(prc) or missing(evcf) or missing(valcf)
       or missing(prev_valcf) or missing(price_cf)
       or missing(fx_event) or missing(prev_fx_event) then delete;
    if n_self_rev_centers ne 1 or n_other_rev_centers ne 0
       or n_earn_centers ne 0 or n_div_centers ne 0
       or n_sessions ne 3 or n_stock_ret ne 3 or n_market_ret ne 3
       or abs(prc)=0 or evcf<=0 or valcf<=0
       or prev_valcf<=0 or price_cf<=0 or fx_event<=0 or prev_fx_event<=0 then delete;
    ret=(1+r_m1)*(1+r_0)*(1+r_p1)-1
        - ((1+m_m1)*(1+m_0)*(1+m_p1)-1);
    fr=(value*evcf/valcf*fx_event-prev_value*evcf/prev_valcf*prev_fx_event)
       /(abs(prc)*evcf/price_cf);
    if missing(ret) or missing(fr) then delete;
run;

/* Footnote 4: pooled 2nd/98th percentile winsorization, with no tail deletion. */
proc univariate data=analysis0 noprint;
    var ret fr;
    output out=cutoffs pctlpts=2 98 pctlpre=ret_ fr_ pctlname=p2 p98;
run;
data final0;
    if _n_=1 then set cutoffs;
    set analysis0;
    if ret < ret_p2 then ret=ret_p2;
    if ret > ret_p98 then ret=ret_p98;
    if fr < fr_p2 then fr=fr_p2;
    if fr > fr_p98 then fr=fr_p98;
    fr_sup=fr*superior;
    fr_norm=fr*normal;
    fr_inf=fr*inferior;
    event_id=rowid;
    format actdats fpedats date9.;
    label ret='Three-day market-adjusted return'
          fr='Winsorized forecast revision scaled by price'
          superior='Superior analyst (80% threshold)'
          normal='Normal analyst (80% threshold)'
          inferior='Inferior analyst (80% threshold)'
          fr_sup='Forecast revision × superior'
          fr_norm='Forecast revision × normal'
          fr_inf='Forecast revision × inferior';
    keep event_id ticker gvkey permno estimator analys actdats fpedats
         ability superior normal inferior ret fr fr_sup fr_norm fr_inf;
run;

data outlib.reg;
    set final0;
run;

/* Aggregate source coverage, join, attrition and final-input diagnostics. */
proc sql;
    select report_curr, count(*) as n_detail_rows,
           sum(missing(fx_event)) as n_missing_event_fx,
           max(actdats-fx_event_quote) as max_event_fx_age
    from det_evt0 group by report_curr;
    select count(*) as n_sequenced_rows,
           sum(changed=1) as n_changed,
           sum(revision_unknown=1) as n_revision_unknown,
           sum(has_prev=1 and report_curr ne prev_curr) as n_currency_changes
    from det_seq;
    select report_curr, prev_curr, count(*) as n_rows
    from det_seq where has_prev=1 and report_curr ne prev_curr
    group by report_curr, prev_curr;
    select count(*) as n_detail_1987_1997,
           count(distinct ticker) as n_tickers
    from det_raw;
    select count(*) as n_detail_linked,
           count(distinct rowid) as n_detail_rows,
           sum(n_permno>1) as n_ambiguous_permno_rows
    from det_linked0;
    select count(*) as n_rows_with_ambiguous_links
    from det_link_counts where n_permno>1;
    select count(*) as n_funda_standard_rows
    from funda0;
    select count(*) as n_funda_unique_company_dates,
           count(distinct gvkey) as n_gvkey
    from funda_unique;
    select count(*) as n_funda_company_date_keys,
           sum(n_rows>1) as n_duplicate_funda_keys
    from funda_card;
    select count(*) as n_funda_issue_candidate_rows,
           count(distinct gvkey) as n_funda_issue_gvkeys
    from funda_issue0;
    select count(*) as n_funda_primary_issue_rows
    from funda_sec_unique;
    select count(*) as n_funda_linked_permno_dates,
           sum(n_rows>1) as n_ambiguous_permno_dates
    from funda_perm_card;
    select count(*) as n_primary_issue_gvkey_dates,
           sum(n_iid>1 or n_cusip>1) as n_ambiguous_primary_issue_dates
    from funda_issue_card;
    select count(*) as n_summary_keys, sum(n_rows>1) as n_duplicate_summary_keys
    from summ_card;
    select count(*) as n_broker_eligible_gvkeys
    from broker_ok;
    select count(*) as n_main_comp_link_events
    from main0;
    select count(*) as n_main_with_ability
    from main_class;
    select currency_route, count(*) as n_history_rows
    from hist_scored0 group by currency_route;
    select count(*) as n_latest_summary_candidates,
           sum(n_same_currency>0) as n_with_same_currency_snapshot,
           sum(n_same_currency=0 and n_latest_currencies=1) as n_unique_mixed_currency_snapshot,
           sum(n_same_currency=0 and n_latest_currencies>1) as n_ambiguous_latest_snapshot
    from hist_sum_pref;
    select count(*) as n_after_confounds_and_market
    from analysis0;
    select count(*) as n_pre_final_criteria,
           sum(n_self_rev_centers ne 1) as n_rev_self_event_mismatch,
           sum(n_other_rev_centers>0) as n_other_revision_overlap,
           sum(n_earn_centers ne 0) as n_earn_overlap,
           sum(n_div_centers ne 0) as n_div_overlap,
           sum(n_sessions ne 3 or n_stock_ret ne 3 or n_market_ret ne 3) as n_return_gaps,
           sum(missing(prc) or missing(price_cf)) as n_missing_t2_price,
           sum(missing(evcf) or missing(valcf) or missing(prev_valcf)) as n_missing_share_factor,
           sum(missing(fx_event) or missing(prev_fx_event)) as n_missing_event_fx
    from main_screen1;
    select n_self_rev_centers, n_other_rev_centers, count(*) as n_candidates
    from main_screen1
    group by n_self_rev_centers, n_other_rev_centers
    order by n_self_rev_centers, n_other_rev_centers;
    select sum(n_same_time_other_horizon>0) as n_cand_same_time_other_horiz,
           max(n_same_time_other_horizon) as max_same_time_other_horizons
    from main_screen1;
    select count(*) as n_final
    from outlib.reg;
    select year(actdats) as event_year, count(*) as n,
           count(distinct analys) as n_analysts,
           count(distinct gvkey) as n_firms
    from outlib.reg group by calculated event_year order by calculated event_year;
    select min(ret) as ret_min, mean(ret) as ret_mean, max(ret) as ret_max,
           min(fr) as fr_min, mean(fr) as fr_mean, max(fr) as fr_max
    from outlib.reg;
    select report_curr, target_curcd, count(*) as n_analysis_rows
    from analysis0 group by report_curr, target_curcd;
quit;

proc freq data=outlib.reg;
    tables superior normal inferior / missing;
run;
