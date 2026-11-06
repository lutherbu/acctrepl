options errorabend;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname out "./data";

/* Keep the complete lag/lead support window before selecting regression years. */
data work.funda_raw;
    set comp.funda(
        keep=gvkey datadate fyear indfmt consol popsrc datafmt curcd
             oiadp at rect invt aco ap lco dp ppent intan ao lo gdwl
             acctchg bspr final fdate
        where=(fyear>=1963 and fyear<=1994 and indfmt='INDL'
               and consol='C' and popsrc='D' and datafmt='STD'));
    format datadate yymmdd10.;
run;

proc sql;
    create table work.funda_key_n as
    select gvkey, fyear, count(*) as nkey
    from work.funda_raw
    group by gvkey, fyear;

    create table work.funda_unique as
    select a.*
    from work.funda_raw as a
    inner join work.funda_key_n as k
      on a.gvkey=k.gvkey and a.fyear=k.fyear
    where k.nkey=1;

    select count(*) as funda_rows,
           count(distinct gvkey) as funda_gvkeys
    from work.funda_raw;
    select count(*) as ambiguous_firm_years,
           sum(nkey-1) as ambiguous_extra_rows
    from work.funda_key_n
    where nkey>1;
    select count(*) as unique_rows
    from work.funda_unique;
quit;

/* Documented BSPR=GB is the unclassified-balance-sheet code; ACCTCHG is unavailable here. */
proc freq data=work.funda_raw;
    tables bspr acctchg curcd final / missing;
run;

/* CRSP monthly price and shares for every fiscal-year point in the support window. */
data work.msf_support;
    set crsp.msf(keep=permno date prc shrout);
    where date>='01DEC1962'd and date<='31DEC1994'd;
run;

/* Primary effective links to actual CRSP securities across the support dates.
   CCM uses missing endpoints, including .B and .E, for open intervals. SAS
   sorts special missings below ordinary dates, so date bounds are explicit. */
data work.link_support;
    set ccm.ccmxpf_linktable(keep=gvkey lpermno linkdt linkenddt linkprim linktype);
    where linkprim in ('P','C') and linktype in ('LC','LU')
      and (missing(linkdt) or linkdt<='31DEC1994'd)
      and (missing(linkenddt) or linkenddt>='01JAN1963'd);
run;

/* Presence screen only; collapse multiple securities at each firm-period key. */
proc sql;
    create table work.price_key as
    select a.gvkey, a.fyear, a.datadate, max(1) as hasprice
    from work.funda_unique as a
    inner join work.link_support as l
      on a.gvkey=l.gvkey
     and (missing(l.linkdt) or l.linkdt<=a.datadate)
     and (missing(l.linkenddt) or l.linkenddt>=a.datadate)
    inner join work.msf_support as m
      on l.lpermno=m.permno
     and m.date<=a.datadate
     and m.date>=intnx('month',a.datadate,-1,'end')
     and (missing(l.linkdt) or m.date>=l.linkdt)
     and (missing(l.linkenddt) or m.date<=l.linkenddt)
     and not missing(m.prc) and not missing(m.shrout)
    where a.fyear between 1963 and 1994
    group by a.gvkey, a.fyear, a.datadate;

    create table work.fy_pairs as
    select a.*,
           p.datadate as datadate_l format=yymmdd10.,
           p.curcd as curcd_l,
           p.at as at_l,
           p.rect as rect_l, p.invt as invt_l, p.aco as aco_l,
           p.ap as ap_l, p.lco as lco_l,
           p.ppent as ppent_l, p.intan as intan_l,
           p.ao as ao_l, p.lo as lo_l, p.gdwl as gdwl_l,
           n.datadate as datadate_f format=yymmdd10.,
           n.curcd as curcd_f,
           n.oiadp as oiadp_f, n.at as at_f
    from work.funda_unique as a
    left join work.funda_unique as p
      on a.gvkey=p.gvkey and p.fyear=a.fyear-1 and p.datadate<a.datadate
    left join work.funda_unique as n
      on a.gvkey=n.gvkey and n.fyear=a.fyear+1 and n.datadate>a.datadate
    where a.fyear between 1964 and 1993;

    create table work.pairs_price as
    select a.*,
           coalesce(pl.hasprice,0) as hasprice_l,
           coalesce(pc.hasprice,0) as hasprice,
           coalesce(pf.hasprice,0) as hasprice_f
    from work.fy_pairs as a
    left join work.price_key as pl
      on a.gvkey=pl.gvkey and pl.fyear=a.fyear-1 and pl.datadate=a.datadate_l
    left join work.price_key as pc
      on a.gvkey=pc.gvkey and pc.fyear=a.fyear and pc.datadate=a.datadate
    left join work.price_key as pf
      on a.gvkey=pf.gvkey and pf.fyear=a.fyear+1 and pf.datadate=a.datadate_f;
quit;

data work.constructed;
    set work.pairs_price;
    length year 8;
    year=fyear;

    date_order=not missing(datadate_l) and not missing(datadate_f)
        and datadate_l<datadate and datadate_f>datadate;
    same_currency=not missing(curcd) and not missing(curcd_l) and not missing(curcd_f)
        and curcd_l=curcd and curcd_f=curcd;
    complete_inputs=(nmiss(oiadp,oiadp_f,at,at_l,at_f,
        rect,rect_l,invt,invt_l,aco,aco_l,ap,ap_l,lco,lco_l,dp,
        ppent,ppent_l,intan,intan_l,ao,ao_l,lo,lo_l)=0);

    goodwill_observed=(not missing(gdwl) and not missing(gdwl_l));
    goodwill_increase=(goodwill_observed and gdwl>gdwl_l);

    avgta=(at_l+at)/2;
    avgta_f=(at+at_f)/2;
    if complete_inputs and avgta>0 and avgta_f>0 then do;
        roa=oiadp/avgta;
        roa_f1=oiadp_f/avgta_f;
        grwc_raw=(rect-rect_l)+(invt-invt_l)+(aco-aco_l)
                 -(ap-ap_l)-(lco-lco_l);
        grwc=grwc_raw/avgta;
        depamort=-dp/avgta;
        acc=(grwc_raw-dp)/avgta;
        cfo=roa-acc;
        noa=rect+invt+aco+ppent+intan+ao-ap-lco-lo;
        noa_l=rect_l+invt_l+aco_l+ppent_l+intan_l+ao_l-ap_l-lco_l-lo_l;
        grnoa=(noa-noa_l)/avgta;
        grltnoa_full=grnoa-acc;
        grltnoa=((ppent-ppent_l)+(intan-intan_l)+(ao-ao_l)
                -(lo-lo_l)+dp)/avgta;
        grlt_check=grltnoa_full-grltnoa;
    end;
    else call missing(roa,roa_f1,grwc,depamort,acc,cfo,noa,noa_l,
                      grnoa,grltnoa_full,grltnoa,grlt_check);

    model_complete=complete_inputs and avgta>0 and avgta_f>0
        and not missing(roa) and not missing(roa_f1)
        and not missing(acc) and not missing(grltnoa)
        and not missing(grnoa);
    unclassified_bspr=(bspr='GB');
    prices_complete=(hasprice_l=1 and hasprice=1 and hasprice_f=1);
    baseline=(date_order and same_currency and prices_complete
              and model_complete and not goodwill_increase
              and not unclassified_bspr);
    label roa_f1='One-year-ahead ROA'
          roa='Current ROA'
          acc='Operating accruals'
          cfo='Cash flows from operations'
          grltnoa='Growth in long-term net operating assets'
          grnoa='Growth in net operating assets'
          grwc='Growth in working capital'
          depamort='Depreciation and amortization (negative)';
run;

proc sql;
    select count(*) as anchor_rows,
           sum(date_order=1) as with_ordered_lag_lead,
           sum(same_currency=1) as same_currency_rows,
           sum(hasprice_l=1) as with_lag_crsp_price_shares,
           sum(hasprice=1) as with_current_crsp_price_shares,
           sum(hasprice_f=1) as with_lead_crsp_price_shares,
           sum(prices_complete=1) as crsp_price_3period,
           sum(model_complete=1) as complete_model_rows,
           sum(unclassified_bspr=1) as unclassified_balance_sheets,
           sum(goodwill_increase=1) as observed_goodwill_increases,
           sum(goodwill_observed=0) as missing_goodwill_comparisons,
           sum(baseline=1) as final_baseline_rows
    from work.constructed;
    select year, count(*) as n
    from work.constructed
    where baseline=1
    group by year
    order by year;
    select count(*) as formula_check_n,
           max(abs(grlt_check)) as max_abs_formula_difference
    from work.constructed
    where model_complete=1;
quit;

proc means data=work.constructed n nmiss mean std p25 median p75 min max maxdec=6;
    where baseline=1;
    var roa_f1 roa acc cfo grltnoa grnoa grwc depamort;
run;

data out.main;
    set work.constructed;
    where baseline=1;
    keep gvkey year datadate curcd roa_f1 roa acc cfo grltnoa grnoa grwc depamort
         hasprice_l hasprice hasprice_f same_currency date_order goodwill_increase
         goodwill_observed bspr acctchg;
run;
