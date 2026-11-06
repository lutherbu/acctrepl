options errorabend msglevel=i fullstimer;

libname COMP "/storage/sas/base/comp/d_na" access=readonly;
libname COMPIND "/storage/sas/base/comp/d_na/company" access=readonly;
libname CRSP "/storage/sas/base/crsp/a_stock" access=readonly;
libname CCM "/storage/sas/base/crsp/a_ccm" access=readonly;
libname OUT "./data";

/* Standard domestic industrial annual reports, including 1962 lag support. */
data work.raw0;
    set COMP.FUNDA(keep=gvkey datadate fyear indfmt consol popsrc datafmt curcd fic pdate fdate
        act che lct dlc dp at sale rect ppent ni ceq mkvalt oancf prcc_f csho sich
        where=(indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'));
    if fyear >= 1962 and fyear <= 1999;
    if not missing(gvkey) and not missing(fyear);
    format datadate date9.;
run;

/* The lag join requires a unique standardized GVKEY/fiscal-year row. */
proc sql noprint;
    create table work.rawdup as
    select gvkey, fyear, count(*) as n,
           count(distinct datadate) as ddate_v, count(datadate) as ddate_n,
           count(distinct pdate) as pdate_v, count(pdate) as pdate_n,
           count(distinct fdate) as fdate_v, count(fdate) as fdate_n,
           count(distinct curcd) as curcd_v, count(curcd) as curcd_n,
           count(distinct fic) as fic_v, count(fic) as fic_n,
           count(distinct at) as at_v, count(at) as at_n,
           count(distinct act) as act_v, count(act) as act_n,
           count(distinct che) as che_v, count(che) as che_n,
           count(distinct lct) as lct_v, count(lct) as lct_n,
           count(distinct dlc) as dlc_v, count(dlc) as dlc_n,
           count(distinct dp) as dp_v, count(dp) as dp_n,
           count(distinct sale) as sale_v, count(sale) as sale_n,
           count(distinct rect) as rect_v, count(rect) as rect_n,
           count(distinct ppent) as ppent_v, count(ppent) as ppent_n,
           count(distinct ni) as ni_v, count(ni) as ni_n,
           count(distinct ceq) as ceq_v, count(ceq) as ceq_n,
           count(distinct mkvalt) as mkvalt_v, count(mkvalt) as mkvalt_n,
           count(distinct oancf) as oancf_v, count(oancf) as oancf_n,
           count(distinct prcc_f) as prcc_f_v, count(prcc_f) as prcc_f_n,
           count(distinct csho) as csho_v, count(csho) as csho_n,
           count(distinct sich) as sich_v, count(sich) as sich_n
    from work.raw0
    group by gvkey, fyear
    having count(*) > 1;
    select count(*) into :n_rawdup trimmed from work.rawdup;

    create table work.rawdup_summary as
    select fyear, count(*) as duplicated_gvkeys, sum(n) as duplicate_rows,
           sum(ddate_v>1 or (ddate_n>0 and ddate_n<n)) as date_conflicts,
           sum(pdate_v>1 or (pdate_n>0 and pdate_n<n)) as pdate_conflicts,
           sum(fdate_v>1 or (fdate_n>0 and fdate_n<n)) as fdate_conflicts,
           sum(curcd_v>1 or (curcd_n>0 and curcd_n<n)) as currency_conflicts,
           sum((at_v>1 or (at_n>0 and at_n<n)) or
               (act_v>1 or (act_n>0 and act_n<n)) or
               (che_v>1 or (che_n>0 and che_n<n)) or
               (lct_v>1 or (lct_n>0 and lct_n<n)) or
               (dlc_v>1 or (dlc_n>0 and dlc_n<n)) or
               (dp_v>1 or (dp_n>0 and dp_n<n)) or
               (sale_v>1 or (sale_n>0 and sale_n<n)) or
               (rect_v>1 or (rect_n>0 and rect_n<n)) or
               (ppent_v>1 or (ppent_n>0 and ppent_n<n)) or
               (ni_v>1 or (ni_n>0 and ni_n<n))) as model_input_conflicts,
           sum((ceq_v>1 or (ceq_n>0 and ceq_n<n)) or
               (mkvalt_v>1 or (mkvalt_n>0 and mkvalt_n<n)) or
               (oancf_v>1 or (oancf_n>0 and oancf_n<n)) or
                (prcc_f_v>1 or (prcc_f_n>0 and prcc_f_n<n)) or
                (csho_v>1 or (csho_n>0 and csho_n<n)) or
                (fic_v>1 or (fic_n>0 and fic_n<n))) as stratification_field_conflicts,
           sum(sich_v>1 or (sich_n>0 and sich_n<n)) as sic_conflicts
    from work.rawdup
    group by fyear
    order by fyear;
quit;
proc print data=work.rawdup_summary noobs;
run;
%put NOTE: Duplicate standardized GVKEY/fiscal-year keys = &n_rawdup;

/* Resolve duplicated firm-years by latest period date, then latest preliminary date. */
proc sql;
    create table work.rawtop_date as
    select gvkey, fyear, max(datadate) as top_datadate
    from work.raw0 group by gvkey, fyear;
    create table work.rawtop_pdate as
    select a.gvkey, a.fyear, a.datadate, max(a.pdate) as top_pdate
    from work.raw0 as a inner join work.rawtop_date as d
      on a.gvkey=d.gvkey and a.fyear=d.fyear
     and (a.datadate=d.top_datadate or (missing(a.datadate) and missing(d.top_datadate)))
    group by a.gvkey, a.fyear, a.datadate;
    create table work.rawtop as
    select a.*
    from work.raw0 as a inner join work.rawtop_pdate as p
      on a.gvkey=p.gvkey and a.fyear=p.fyear
     and (a.datadate=p.datadate or (missing(a.datadate) and missing(p.datadate)))
     and (a.pdate=p.top_pdate or (missing(a.pdate) and missing(p.top_pdate)));
    create table work.rawtop_counts as
    select gvkey, fyear, count(*) as top_n,
           count(distinct curcd) as curcd_v, count(curcd) as curcd_n,
           count(distinct fic) as fic_v, count(fic) as fic_n,
           count(distinct act) as act_v, count(act) as act_n,
           count(distinct che) as che_v, count(che) as che_n,
           count(distinct lct) as lct_v, count(lct) as lct_n,
           count(distinct dlc) as dlc_v, count(dlc) as dlc_n,
           count(distinct dp) as dp_v, count(dp) as dp_n,
           count(distinct at) as at_v, count(at) as at_n,
           count(distinct sale) as sale_v, count(sale) as sale_n,
           count(distinct rect) as rect_v, count(rect) as rect_n,
           count(distinct ppent) as ppent_v, count(ppent) as ppent_n,
           count(distinct ni) as ni_v, count(ni) as ni_n,
           count(distinct ceq) as ceq_v, count(ceq) as ceq_n,
           count(distinct mkvalt) as mkvalt_v, count(mkvalt) as mkvalt_n,
           count(distinct oancf) as oancf_v, count(oancf) as oancf_n,
           count(distinct prcc_f) as prcc_f_v, count(prcc_f) as prcc_f_n,
           count(distinct csho) as csho_v, count(csho) as csho_n,
           count(distinct sich) as sich_v, count(sich) as sich_n
    from work.rawtop
    group by gvkey, fyear;
    create table work.rawtop_ambig as
    select * from work.rawtop_counts
    where top_n > 1 and
      (curcd_v>1 or (curcd_n>0 and curcd_n<top_n) or
       fic_v>1 or (fic_n>0 and fic_n<top_n) or
       act_v>1 or (act_n>0 and act_n<top_n) or
       che_v>1 or (che_n>0 and che_n<top_n) or
       lct_v>1 or (lct_n>0 and lct_n<top_n) or
       dlc_v>1 or (dlc_n>0 and dlc_n<top_n) or
       dp_v>1 or (dp_n>0 and dp_n<top_n) or
       at_v>1 or (at_n>0 and at_n<top_n) or
       sale_v>1 or (sale_n>0 and sale_n<top_n) or
       rect_v>1 or (rect_n>0 and rect_n<top_n) or
       ppent_v>1 or (ppent_n>0 and ppent_n<top_n) or
       ni_v>1 or (ni_n>0 and ni_n<top_n) or
       ceq_v>1 or (ceq_n>0 and ceq_n<top_n) or
       mkvalt_v>1 or (mkvalt_n>0 and mkvalt_n<top_n) or
       oancf_v>1 or (oancf_n>0 and oancf_n<top_n) or
       prcc_f_v>1 or (prcc_f_n>0 and prcc_f_n<top_n) or
       csho_v>1 or (csho_n>0 and csho_n<top_n) or
       sich_v>1 or (sich_n>0 and sich_n<top_n));
    select count(*) into :n_top_ambig trimmed from work.rawtop_ambig;
    create table work.rawtop_summary as
    select fyear, sum(top_n>1) as identical_vintage_ties
    from work.rawtop_counts
    group by fyear order by fyear;
quit;
proc print data=work.rawtop_summary noobs;
run;
%put NOTE: Conflicting tied latest-date/vintage firm-years = &n_top_ambig;
%if %sysevalf(&n_top_ambig > 0) %then %do;
    data _null_;
        put "ERROR: Tied latest Compustat date/vintage rows conflict on a model input";
        abort cancel;
    run;
%end;
proc sort data=work.raw0 out=work.raw_order;
    by gvkey fyear descending datadate descending pdate;
run;
data work.rawselect;
    set work.raw_order;
    by gvkey fyear descending datadate descending pdate;
    if first.fyear;
run;

/* CRSP support follows the last actual reporting date in the selected fiscal-year pool. */
proc sql noprint;
    select max(datadate) into :mve_end_date trimmed
    from work.rawselect;
quit;
data _null_;
    selected_end=&mve_end_date;
    put "NOTE: Actual selected-fiscal-date market-equity endpoint = " selected_end date9.;
run;

/* Date-effective CRSP USD market equity: aggregate common share classes per PERMCO. */
proc sql;
    create table work.crsp_security_month as
    select m.permno, m.date,
           case when count(distinct m.permco)=1 then max(m.permco) else . end as permco,
           count(distinct m.permco) as permco_n,
           count(n.permno) as name_rows,
           case when count(distinct n.shrcd)=1 then max(n.shrcd) else . end as shrcd,
           count(distinct n.shrcd) as shrcd_n,
           max(n.shrcd in (10,11)) as common_candidate,
           sum(case when not missing(n.permno) and
                         (missing(n.shrcd) or n.shrcd not in (10,11))
                    then 1 else 0 end) as unknown_sharecode_rows,
           case when count(distinct m.prc)=1 then max(abs(m.prc)) else . end as prc_usd,
           count(distinct m.prc) as prc_n,
           count(m.prc) as prc_obs,
           case when count(distinct m.shrout)=1 then max(m.shrout) else . end as shrout_thousands,
           count(distinct m.shrout) as shrout_n,
           count(m.shrout) as shrout_obs
    from CRSP.MSF as m
    left join CRSP.STOCKNAMES as n
      on m.permno=n.permno
     and m.date >= n.namedt
     and (missing(n.nameenddt) or m.date <= n.nameenddt)
    where m.date >= '01JAN1962'd and m.date <= &mve_end_date
    group by m.permno, m.date;

    create table work.crsp_monthly_mve_audit as
    select permco, date,
           sum(common_candidate) as common_security_count,
           sum(case when common_candidate=1 and
                     (permco_n ne 1 or unknown_sharecode_rows>0 or prc_n>1 or shrout_n>1)
                    then 1 else 0 end) as conflict_security_count,
           sum(case when common_candidate=1 and
                     (prc_obs=0 or shrout_obs=0 or missing(prc_usd) or prc_usd<=0 or
                      missing(shrout_thousands) or shrout_thousands<=0)
                    then 1 else 0 end) as incomplete_security_count,
           sum(case when common_candidate=1 and permco_n=1 and shrcd_n=1 and
                     prc_n=1 and prc_obs>0 and shrout_n=1 and shrout_obs>0 and
                     prc_usd>0 and shrout_thousands>0
                    then prc_usd*shrout_thousands else 0 end)/1000 as clean_mve
    from work.crsp_security_month
    where common_candidate=1 and permco_n=1
    group by permco, date;

    create table work.crsp_monthly_mve as
    select permco, date, common_security_count, conflict_security_count,
           incomplete_security_count,
           case when common_security_count>0 and conflict_security_count=0
                     and incomplete_security_count=0
                then clean_mve else . end as crsp_mve,
           (conflict_security_count>0) as crsp_mve_conflict
    from work.crsp_monthly_mve_audit;

    create table work.crsp_security_month_audit as
    select year(date) as crsp_year,
           count(*) as security_month_rows,
           sum(name_rows=0) as no_eff_name_rows,
           sum(name_rows>1) as multi_name_rows,
           sum(unknown_sharecode_rows>0) as bad_sharecode_rows,
           sum(common_candidate=1 and permco_n ne 1) as permco_conflicts,
           sum(common_candidate=1 and prc_obs=0) as common_price_missing,
           sum(common_candidate=1 and shrout_obs=0) as common_shares_missing,
           sum(common_candidate=1 and prc_n>1) as common_price_value_conflicts,
           sum(common_candidate=1 and shrout_n>1) as common_shares_value_conflicts,
           sum(common_candidate=1 and prc_obs>0 and (missing(prc_usd) or prc_usd<=0)) as common_price_invalid,
           sum(common_candidate=1 and shrout_obs>0 and (missing(shrout_thousands) or shrout_thousands<=0)) as common_shares_invalid
    from work.crsp_security_month
    group by calculated crsp_year
    order by calculated crsp_year;

    create table work.crsp_company_month_audit as
    select year(date) as crsp_year,
           count(*) as common_permco_months,
           sum(common_security_count>1) as multiple_common_share_classes,
           sum(conflict_security_count>0) as observed_conflict_permco_months,
           sum(incomplete_security_count>0) as incomplete_permco_months,
           sum(crsp_mve>0) as complete_permco_mve_months
    from work.crsp_monthly_mve
    group by calculated crsp_year
    order by calculated crsp_year;

    create table work.mve_links as
    select a.gvkey, a.fyear, a.datadate, l.lpermco as permco,
           case when l.linkprim='P' then 1 else 2 end as link_priority
    from work.rawselect as a
    inner join CCM.CCMXPF_LINKTABLE as l
      on a.gvkey=l.gvkey
     and l.linktype='LC'
     and l.linkprim in ('P','C')
     and not missing(l.lpermco)
     and (missing(l.linkdt) or l.linkdt <= a.datadate)
     and (l.linkenddt=.E or l.linkenddt >= a.datadate);

    create table work.mve_link_priority as
    select gvkey, fyear, datadate, min(link_priority) as best_priority
    from work.mve_links
    group by gvkey, fyear, datadate;

    create table work.mve_link as
    select l.gvkey, l.fyear, l.datadate,
           case when count(distinct l.permco)=1 then max(l.permco) else . end as permco,
           count(distinct l.permco) as permco_n,
           p.best_priority
    from work.mve_links as l
    inner join work.mve_link_priority as p
      on l.gvkey=p.gvkey and l.fyear=p.fyear and l.datadate=p.datadate
     and l.link_priority=p.best_priority
    group by l.gvkey, l.fyear, l.datadate, p.best_priority;

    create table work.mve_crsp_date as
    select l.gvkey, l.fyear, l.datadate, l.permco, max(m.date) as crsp_date
    from work.mve_link as l
    inner join work.crsp_monthly_mve as m
      on l.permco=m.permco
     and m.date <= l.datadate
     and m.date >= intnx('month',l.datadate,-1,'beginning')
    where l.permco_n=1
    group by l.gvkey, l.fyear, l.datadate, l.permco;

    create table work.mve_crsp as
    select d.gvkey, d.fyear, d.datadate, d.permco, d.crsp_date,
           m.common_security_count, m.incomplete_security_count,
           m.crsp_mve, m.crsp_mve_conflict
    from work.mve_crsp_date as d
    inner join work.crsp_monthly_mve as m
      on d.permco=m.permco and d.crsp_date=m.date;

    create table work.mve_assigned as
    select a.gvkey, a.fyear, a.datadate,
           l.permco as mve_permco, l.permco_n as mve_permco_n,
           l.best_priority as mve_link_rank,
           c.crsp_date as mve_crsp_date format=date9.,
           case when c.crsp_mve>0 then a.datadate-c.crsp_date else . end as mve_quote_age,
           c.common_security_count as mve_common_security_count,
           c.incomplete_security_count as mve_incomplete_security_count,
           case when l.permco_n > 1 then .
                when c.crsp_mve_conflict=1 then .
                when c.crsp_mve > 0 then c.crsp_mve
                when (missing(l.permco_n) or l.permco_n=1) and a.fic='USA' and a.curcd='USD'
                 and a.prcc_f > 0 and a.csho > 0 then a.prcc_f*a.csho
                else . end as mve,
           case when l.permco_n > 1 then 'LINK_CONFLICT'
                when c.crsp_mve_conflict=1 then 'CRSP_CONFLICT'
                when c.crsp_mve > 0 then 'CRSP_LC'
                when l.permco_n=1 and a.fic='USA' and a.curcd='USD'
                 and a.prcc_f > 0 and a.csho > 0 then 'COMP_US_LC'
                when missing(l.permco_n) and a.fic='USA' and a.curcd='USD'
                 and a.prcc_f > 0 and a.csho > 0 then 'COMP_US_INFERRED'
                else 'MISSING' end as mve_src length=16
    from work.rawselect as a
    left join work.mve_link as l
      on a.gvkey=l.gvkey and a.fyear=l.fyear and a.datadate=l.datadate
    left join work.mve_crsp as c
      on a.gvkey=c.gvkey and a.fyear=c.fyear and a.datadate=c.datadate;
quit;
proc print data=work.crsp_security_month_audit noobs;
run;
proc print data=work.crsp_company_month_audit noobs;
run;
proc freq data=work.mve_assigned;
    tables fyear*mve_src / nocol norow nopercent;
run;
proc means data=work.mve_assigned n min median max;
    class fyear;
    var mve_quote_age;
run;
proc freq data=work.mve_assigned;
    where fyear=1999 and datadate > '31DEC1999'd;
    tables mve_src / nocol norow nopercent;
run;
proc means data=work.mve_assigned n min median max;
    where fyear=1999 and datadate > '31DEC1999'd;
    var mve_quote_age;
run;
proc freq data=work.mve_assigned;
    where mve_src='CRSP_LC';
    tables mve_link_rank*mve_common_security_count / nocol norow nopercent;
run;

proc sql;
    select count(*) as selected_annual_rows,
           min(fyear) as min_fyear, max(fyear) as max_fyear
    from work.rawselect;
quit;

proc sql;
    select count(*) as raw_observations,
           min(fyear) as min_fyear,
           max(fyear) as max_fyear,
           min(datadate) format=date9. as min_datadate,
           max(datadate) format=date9. as max_datadate
    from work.raw0;
quit;
proc freq data=work.raw0;
    tables fyear*curcd / nocol norow nopercent;
run;

/* Exact dated Compustat industry rows are the first fallback when FUNDA.SICH is absent. */
proc sql;
    create table work.co_sic as
    select gvkey, datadate, consol, popsrc,
           case when count(distinct floor(sich/100))=1
                then max(floor(sich/100)) else . end as co_sic2,
           count(distinct floor(sich/100)) as co_sic2_n
    from COMPIND.CO_INDUSTRY
    where datadate >= '01JAN1962'd and datadate <= &mve_end_date
      and consol='C' and popsrc='D'
      and not missing(sich) and sich >= 100 and sich <= 9999
    group by gvkey, datadate, consol, popsrc;

    /* Audit exact dated and Compustat Data Year candidate matches before choosing SIC fallback. */
    create table work.co_sic_year as
    select gvkey, year, consol, popsrc,
           case when count(distinct floor(sich/100))=1
                then max(floor(sich/100)) else . end as co_sic2,
           count(distinct floor(sich/100)) as co_sic2_n
    from COMPIND.CO_INDUSTRY
    where year >= 1962 and year <= 1999
      and consol='C' and popsrc='D'
      and not missing(sich) and sich >= 100 and sich <= 9999
    group by gvkey, year, consol, popsrc;

    create table work.co_join_audit as
    select a.fyear, count(*) as funda_rows,
           sum(e.co_sic2_n=1) as exact_unique_sic_rows,
           sum(e.co_sic2_n>1) as exact_conflict_rows,
           sum(y.co_sic2_n=1) as year_unique_sic_rows,
           sum(y.co_sic2_n>1) as year_conflict_rows
    from work.rawselect as a
    left join work.co_sic as e
      on a.gvkey=e.gvkey and a.datadate=e.datadate
     and a.consol=e.consol and a.popsrc=e.popsrc
    left join work.co_sic_year as y
      on a.gvkey=y.gvkey and a.fyear=y.year
     and a.consol=y.consol and a.popsrc=y.popsrc
    group by a.fyear
    order by a.fyear;

    create table work.sicbase as
    select a.*,
           case when not missing(a.sich) and a.sich >= 100 and a.sich <= 9999
                then floor(a.sich/100)
                when c.co_sic2_n=1 then c.co_sic2
                else . end as sic2,
           case when not missing(a.sich) and a.sich >= 100 and a.sich <= 9999
                then 'FUNDA'
                when c.co_sic2_n=1 then 'CO_INDUSTRY'
                when c.co_sic2_n > 1 then 'CO_AMBIG'
                else 'MISSING' end as sic_src length=12
    from work.rawselect as a
    left join work.co_sic as c
      on a.gvkey=c.gvkey and a.datadate=c.datadate
     and a.consol=c.consol and a.popsrc=c.popsrc;
quit;
proc print data=work.co_join_audit noobs;
run;

/* Dated CRSP SIC fallback only when both period-specific Compustat sources fail. */
proc sql;
    create table work.need_crsp as
    select gvkey, fyear, datadate
    from work.sicbase
    where missing(sic2);

    create table work.crsp_links as
    select a.gvkey, a.fyear, a.datadate,
           l.lpermno as permno, l.linkprim, l.linktype,
           case when l.linktype='LC' and l.linkprim='P' then 1
                when l.linktype='LC' and l.linkprim='C' then 2
                when l.linktype='LU' and l.linkprim='P' then 3
                else 4 end as link_priority,
           floor(n.siccd/100) as crsp_sic2
    from work.need_crsp as a
    inner join CCM.CCMXPF_LINKTABLE as l
      on a.gvkey=l.gvkey
     and l.linktype in ('LC','LU')
     and l.linkprim in ('P','C')
     and (missing(l.linkdt) or l.linkdt <= a.datadate)
     and (l.linkenddt=.E or l.linkenddt >= a.datadate)
     and not missing(l.lpermno)
    inner join CRSP.STOCKNAMES as n
      on l.lpermno=n.permno
     and n.namedt <= a.datadate
     and (missing(n.nameenddt) or n.nameenddt >= a.datadate)
     and n.siccd >= 100 and n.siccd <= 9999;

    create table work.crsp_priority as
    select gvkey, fyear, datadate, min(link_priority) as best_priority
    from work.crsp_links
    group by gvkey, fyear, datadate;

    create table work.crsp_sic as
    select l.gvkey, l.fyear, l.datadate,
           case when count(distinct l.crsp_sic2)=1
                then max(l.crsp_sic2) else . end as crsp_sic2,
           count(distinct l.crsp_sic2) as crsp_sic2_n,
           p.best_priority
    from work.crsp_links as l
    inner join work.crsp_priority as p
      on l.gvkey=p.gvkey and l.fyear=p.fyear and l.datadate=p.datadate
     and l.link_priority=p.best_priority
    group by l.gvkey, l.fyear, l.datadate, p.best_priority;

    create table work.sicall as
    select a.*,
           case when missing(a.sic2) and s.crsp_sic2_n=1
                then s.crsp_sic2 else a.sic2 end as sic2_final,
           case when missing(a.sic2) and s.crsp_sic2_n=1 and s.best_priority=1
                then 'CRSP_LC_P'
                when missing(a.sic2) and s.crsp_sic2_n=1 and s.best_priority=2
                then 'CRSP_LC_C'
                when missing(a.sic2) and s.crsp_sic2_n=1 and s.best_priority=3
                then 'CRSP_LU_P'
                when missing(a.sic2) and s.crsp_sic2_n=1 and s.best_priority=4
                then 'CRSP_LU_C'
                when missing(a.sic2) and s.crsp_sic2_n > 1
                then 'CRSP_AMBIG'
                else a.sic_src end as sic_src_final length=12
    from work.sicbase as a
    left join work.crsp_sic as s
      on a.gvkey=s.gvkey and a.fyear=s.fyear and a.datadate=s.datadate;
quit;

data work.sicready;
    set work.sicall;
    sic2=sic2_final;
    sic_src=sic_src_final;
    drop sic2_final sic_src_final;
run;

proc freq data=work.sicready;
    tables fyear*sic_src / nocol norow nopercent;
run;
proc sql;
    select count(*) as all_rows,
           sum(missing(sic2)) as missing_sic_rows,
           sum(sic_src='FUNDA') as funda_sic_rows,
           sum(sic_src='CO_INDUSTRY') as co_industry_sic_rows,
           sum(sic_src='CRSP_LC_P') as crsp_primary_sic_rows,
           sum(sic_src='CRSP_LC_C') as crsp_crsp_assigned_sic_rows,
           sum(sic_src='CRSP_LU_P') as crsp_lu_primary_sic_rows,
           sum(sic_src='CRSP_LU_C') as crsp_lu_assigned_sic_rows,
           sum(sic_src='CRSP_AMBIG') as crsp_ambiguous_sic_rows,
           sum(sic_src='CO_AMBIG') as co_ambiguous_sic_rows
    from work.sicready;
quit;

/* Exact prior fiscal-year join; 1962 records provide 1963 beginning assets and changes. */
proc sql;
    create table work.lagged as
    select a.gvkey, a.datadate, a.fyear, a.curcd, a.fic, a.sich,
           a.sic2, a.sic_src,
           a.act, a.che, a.lct, a.dlc, a.dp, a.at,
           a.sale, a.rect, a.ppent, a.ni, a.ceq, a.mkvalt, a.oancf,
           a.prcc_f, a.csho, m.mve, m.mve_src,
           m.mve_permco, m.mve_permco_n, m.mve_link_rank,
           m.mve_crsp_date, m.mve_quote_age, m.mve_common_security_count,
           m.mve_incomplete_security_count,
           b.datadate as prevdate format=date9.,
           b.curcd as curcd_lag,
           b.act as act_lag, b.che as che_lag, b.lct as lct_lag,
           b.dlc as dlc_lag, b.at as at_lag, b.sale as sale_lag,
           b.rect as rect_lag, b.ni as ni_lag
    from work.sicready as a
    left join work.sicready as b
      on a.gvkey=b.gvkey and a.fyear=b.fyear+1
    left join work.mve_assigned as m
      on a.gvkey=m.gvkey and a.fyear=m.fyear and a.datadate=m.datadate
    where a.fyear >= 1963 and a.fyear <= 1999;
quit;

/* Keep incomplete components missing. Require same USD denomination in both periods. */
data work.support;
    set work.lagged;
    if curcd ne 'USD' or curcd_lag ne 'USD' then delete;
    if missing(sic2) or sic2 <= 0 then delete;

    ta=.; inv_at=.; d_sales=.; d_mj=.; ppe_n=.; roa_cur=.; roa_lag=.;
    btm=.; ep=.; sales_gr=.; ocf_at=.;
    if at_lag > 0 and nmiss(act,act_lag,che,che_lag,lct,lct_lag,dlc,dlc_lag,dp)=0 then
        ta=((act-act_lag)-(che-che_lag)-(lct-lct_lag)+(dlc-dlc_lag)-dp)/at_lag;
    if at_lag > 0 then inv_at=1/at_lag;
    if at_lag > 0 and nmiss(sale,sale_lag)=0 then d_sales=(sale-sale_lag)/at_lag;
    if at_lag > 0 and nmiss(sale,sale_lag,rect,rect_lag)=0 then
        d_mj=((sale-sale_lag)-(rect-rect_lag))/at_lag;
    if at_lag > 0 and not missing(ppent) then ppe_n=ppent/at_lag;
    if at > 0 and not missing(ni) then roa_cur=ni/at;
    if at_lag > 0 and not missing(ni_lag) then roa_lag=ni_lag/at_lag;
    if mve > 0 and not missing(ceq) then btm=ceq/mve;
    if mve > 0 and not missing(ni) then ep=ni/mve;
    if sale_lag ne 0 and nmiss(sale,sale_lag)=0 then sales_gr=(sale-sale_lag)/sale_lag;
    length ocf_src $6;
    ocf_src='MISSING';
    if at > 0 and not missing(oancf) then do;
        ocf_at=oancf/at;
        ocf_src='OANCF';
    end;
    else if at > 0 and not missing(ni) and not missing(ta) and
            not missing(at_lag) and at_lag > 0 then do;
        ocf_at=(ni-(ta*at_lag))/at;
        ocf_src='NI_TA';
    end;
    label ta='Total accruals / lagged total assets'
          inv_at='Inverse lagged total assets'
          d_sales='Change in sales / lagged total assets'
          d_mj='Change in sales less receivables / lagged total assets'
          ppe_n='Net PPE / lagged total assets'
          roa_cur='Current net income / total assets'
          roa_lag='Lagged net income / lagged total assets';
run;

proc freq data=work.lagged;
    tables curcd*curcd_lag / nocol norow nopercent;
run;
proc sql;
    select count(*) as support_firm_years,
           min(fyear) as support_min_year,
           max(fyear) as support_max_year,
           min(prevdate) format=date9. as earliest_lag_date,
           max(datadate) format=date9. as latest_current_date
    from work.support;
quit;

/* Auditable annual source coverage for direct and reconstructed stratification measures. */
proc sql;
    select fyear, count(*) as support_rows,
           sum(mkvalt>0) as n_mkvalt_positive,
           sum(mve_src='CRSP_LC') as n_crsp_mve,
           sum(mve_src='COMP_US_LC') as n_compustat_mve_lc_fallback,
           sum(mve_src='COMP_US_INFERRED') as n_compustat_mve_inferred,
           sum(fic='USA' and curcd='USD' and prcc_f>0 and csho>0) as n_comp_mve_candidates,
           sum(mve_src='LINK_CONFLICT') as n_mve_link_conflict,
           sum(mve_src='CRSP_CONFLICT') as n_crsp_mve_conflict,
           sum(mve_incomplete_security_count>0) as n_incomplete_crsp_month,
           sum(mve>0) as n_mve_measure,
           sum(not missing(btm)) as n_btm,
           sum(not missing(ep)) as n_ep,
           sum(not missing(oancf) and at>0) as n_oancf_at,
           sum(ocf_src='NI_TA') as n_ni_minus_ta_proxy,
           sum(not missing(ocf_at)) as n_ocf_measure
    from work.support group by fyear order by fyear;
quit;
proc freq data=work.support;
    where fyear=1999 and datadate > '31DEC1999'd;
    tables mve_src / nocol norow nopercent;
run;
proc means data=work.support n min median max;
    where fyear=1999 and datadate > '31DEC1999'd;
    var mve_quote_age;
run;

/* Auditable support counts by fiscal year before Stata's group-specific fit rules. */
proc sql;
    select count(*) as eligible_support_rows,
           min(fyear) as first_fyear, max(fyear) as last_fyear,
           min(prevdate) format=date9. as earliest_lag_date,
           max(datadate) format=date9. as latest_current_date,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_sales) and not missing(ppe_n))
               as n_j,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_mj) and not missing(ppe_n))
               as n_mj,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_sales) and not missing(ppe_n) and not missing(roa_lag))
               as n_j_roa_lag,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_sales) and not missing(ppe_n) and not missing(roa_cur))
               as n_j_roa_cur,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_mj) and not missing(ppe_n) and not missing(roa_lag))
               as n_mj_roa_lag,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_mj) and not missing(ppe_n) and not missing(roa_cur))
               as n_mj_roa_cur
    from work.support;

    select fyear, count(*) as support_rows,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_sales) and not missing(ppe_n)) as n_jones,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_mj) and not missing(ppe_n)) as n_modified_jones,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_sales) and not missing(ppe_n) and not missing(roa_lag)) as n_jones_roa_lag,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_sales) and not missing(ppe_n) and not missing(roa_cur)) as n_jones_roa_current,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_mj) and not missing(ppe_n) and not missing(roa_lag)) as n_modified_jones_roa_lag,
           sum(not missing(ta) and not missing(inv_at) and not missing(d_mj) and not missing(ppe_n) and not missing(roa_cur)) as n_modified_jones_roa_current
    from work.support
    group by fyear
    order by fyear;
quit;
proc freq data=work.support;
    tables fyear*sic_src / nocol norow nopercent;
run;
proc sql;
    create table work.boundary_dates as
    select fyear, year(datadate) as date_year, count(*) as firm_years,
           min(datadate) as first_datadate format=date9.,
           max(datadate) as last_datadate format=date9.
    from work.support
    where fyear=1963 or fyear=1999 or year(datadate)=1962 or year(datadate)=2000
    group by fyear, calculated date_year
    order by fyear, calculated date_year;
quit;
proc print data=work.boundary_dates noobs;
run;

/* Handoff preserves the broad SIC-assigned USD support pool; Stata fits each model. */
data OUT.compustat_accrual_sim(label='Kothari et al. grouped-regression support population');
    set work.support;
    keep gvkey fyear datadate prevdate sic2 sic_src curcd curcd_lag
         ta inv_at d_sales d_mj ppe_n roa_cur roa_lag
         btm ep mve mve_src mve_permco mve_permco_n mve_link_rank
         mve_crsp_date mve_quote_age mve_common_security_count mve_incomplete_security_count
         sales_gr ocf_at ocf_src;
    label ta='Total accruals / lagged total assets'
          inv_at='Inverse lagged total assets'
          d_sales='Change in sales / lagged total assets'
          d_mj='Change in sales less receivables / lagged total assets'
          ppe_n='Net PPE / lagged total assets'
          roa_cur='Current net income / total assets'
          roa_lag='Lagged net income / lagged total assets'
          btm='Book-to-market ratio'
          ep='Earnings-to-price ratio'
          mve='Fiscal market equity from dated CRSP or guarded Compustat fallback, in $ millions'
          sales_gr='Sales growth'
          ocf_at='Operating cash flow / total assets';
    format datadate prevdate date9.;
run;

libname OUT clear;
libname CCM clear;
libname CRSP clear;
libname COMPIND clear;
libname COMP clear;
