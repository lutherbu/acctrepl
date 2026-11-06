options errorabend mprint source2;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname crspst "/storage/sas/base/crsp/a_stock" access=readonly;
libname out "./data";

title "W3121890812 Table 3 Panel B construction diagnostics";

data work.comp_all;
    set comp.funda(
        keep=gvkey datadate fyear fic sich indfmt consol popsrc datafmt
             curcd upd fdate pdate pi mii at txc txt tlcf txdfed txdfo txdi
        where=(fyear >= 1993 and fyear <= 2001 and
               indfmt = 'INDL' and consol = 'C' and popsrc = 'D' and
               datafmt = 'STD')
    );
    if missing(gvkey) or missing(datadate) or missing(fyear) then delete;
    format datadate fdate pdate yymmdd10.;
run;

proc freq data=work.comp_all;
    title "Update-code distribution before final-report filter";
    tables fyear*upd / missing;
run;

proc sql;
    title "Effect of selecting final Compustat updates";
    select count(*) as standard_rows,
           sum(case when upd = 3 then 1 else 0 end) as upd3_rows,
           sum(case when upd ne 3 or missing(upd) then 1 else 0 end) as other_upd_rows
      from work.comp_all;
quit;

data work.comp0;
    set work.comp_all;
    if upd ne 3 then delete;
run;

proc sql;
    title "Compustat final standard annual report keys";
    select count(*) as report_rows from work.comp0;
    select count(*) as duplicate_gvkey_fyear_groups
      from (select gvkey, fyear from work.comp0
            group by gvkey, fyear having count(*) > 1) as d;
    select count(*) as dup_vintage_ties
      from (select gvkey, fyear, datadate, fdate, pdate
              from work.comp0
              group by gvkey, fyear, datadate, fdate, pdate
              having count(*) > 1) as d;
quit;

proc sort data=work.comp0 out=work.comp_order;
    by gvkey fyear descending datadate descending fdate descending pdate;
run;

data work.comp_year;
    set work.comp_order;
    by gvkey fyear;
    if first.fyear;
run;

data work.tax_compare;
    set work.comp_year;
    if nmiss(txc, txt, txdi) = 0;
    current_tax_from_items = txt - txdi;
    tax_diff = txc - current_tax_from_items;
    tax_match = (abs(tax_diff) <= 0.0001);
run;

proc freq data=work.tax_compare;
    title "Direct current-tax field versus paper item formula";
    tables tax_match / missing;
run;

proc means data=work.tax_compare n mean min p25 median p75 max;
    var tax_diff;
run;

data work.t_base;
    set work.comp_year;
    if fyear < 1994 or fyear > 2000 then delete;
    if fic ne 'USA' then delete;
    if missing(sich) or missing(at) then delete;
    if (sich >= 4900 and sich <= 4999) or
       (sich >= 6000 and sich <= 6999) then delete;
    crsp_start = intnx('year', datadate, -1, 'same') + 1;
    crsp_end = datadate;
    format crsp_start crsp_end yymmdd10.;
run;

proc sql;
    title "Source starting population before CRSP intersection";
    select count(*) as init_us_nonfin_n,
           count(distinct gvkey) as companies
      from work.t_base;
quit;

proc sql;
    create table work.link_fy as
    select a.gvkey, a.fyear, a.datadate, a.crsp_start, a.crsp_end,
           b.lpermno, b.linkprim, b.linktype, b.linkdt, b.linkenddt
      from work.t_base as a
      inner join ccm.ccmxpf_linktable(
          keep=gvkey linkprim linktype lpermno linkdt linkenddt
          where=((missing(linkdt) or linkdt <= '31DEC2001'd) and
                 (missing(linkenddt) or linkenddt >= '01JAN1993'd))
      ) as b
        on a.gvkey = b.gvkey
     where b.lpermno > 0 and b.linkprim in ('P', 'C') and
           b.linktype in ('LC', 'LU') and
           (missing(b.linkdt) or b.linkdt <= a.crsp_end) and
           (missing(b.linkenddt) or b.linkenddt >= a.crsp_start);

    create table work.link_perm as
    select distinct lpermno as permno from work.link_fy;

    title "CRSP link multiplicity before daily-date intersection";
    select count(*) as primary_window_link_rows,
           count(distinct lpermno) as distinct_permnos
      from work.link_fy;
    select count(*) as multi_link_years
      from (select gvkey, fyear from work.link_fy
            group by gvkey, fyear having count(*) > 1) as d;
    select count(*) as multi_permno_years
      from (select gvkey, fyear from work.link_fy
            group by gvkey, fyear having count(distinct lpermno) > 1) as d;
quit;

data work.dsf_match(keep=permno date);
    length permno 8;
    if _n_ = 1 then do;
        declare hash h(dataset:"work.link_perm");
        h.defineKey("permno");
        h.defineDone();
    end;
    set crspst.dsf(
        keep=permno date
        where=(date >= '01JAN1993'd and date <= '31DEC2001'd)
    );
    if h.check(key:permno) = 0;
    format date yymmdd10.;
run;

proc sql;
    create table work.crsp_fy as
    select distinct a.gvkey, a.fyear
      from work.link_fy as a
      inner join work.dsf_match as d
        on a.lpermno = d.permno and
           d.date >= a.crsp_start and d.date <= a.crsp_end and
           (missing(a.linkdt) or d.date >= a.linkdt) and
           (missing(a.linkenddt) or d.date <= a.linkenddt);

    title "CRSP daily records and unique firm-year intersection";
    select count(*) as candidate_permno_dates from work.dsf_match;
    select count(*) as crsp_intersection_firmyears from work.crsp_fy;
quit;

proc sort data=work.t_base out=work.t_base_s;
    by gvkey fyear;
run;
proc sort data=work.crsp_fy out=work.crsp_fy_s;
    by gvkey fyear;
run;

data work.base;
    merge work.t_base_s(in=in_base) work.crsp_fy_s(in=in_crsp);
    by gvkey fyear;
    if in_base and in_crsp;
    crsp_ok = 1;
run;

proc sql;
    title "Initial sample after date-valid CRSP/Compustat intersection";
    select count(*) as initial_firmyears,
           count(distinct gvkey) as initial_companies
      from work.base;
quit;

proc sql;
    create table work.panel as
    select t.gvkey, t.fyear, t.datadate, t.sich, t.curcd as cur_t,
           t.pi as pi_t, t.mii as mii_t, t.at as at_t,
           t.txt as txt_t, t.tlcf as tlcf_t,
           t.txdfed as txdfed_t, t.txdfo as txdfo_t, t.txdi as txdi_t,
           p.at as at_tm1, p.curcd as cur_tm1,
           n.pi as pi_tp1, n.mii as mii_tp1, n.at as at_tp1,
           n.curcd as cur_tp1
      from work.base as t
      left join work.comp_year as p
        on t.gvkey = p.gvkey and p.fyear = t.fyear - 1
      left join work.comp_year as n
        on t.gvkey = n.gvkey and n.fyear = t.fyear + 1;
quit;

data work.screen_flags;
    set work.panel;
    ptbi_amt_t = .;
    ptbi_amt_tp1 = .;
    if not missing(pi_t) then do;
        ptbi_amt_t = pi_t;
        if not missing(mii_t) then ptbi_amt_t = pi_t - mii_t;
    end;
    if not missing(pi_tp1) then do;
        ptbi_amt_tp1 = pi_tp1;
        if not missing(mii_tp1) then ptbi_amt_tp1 = pi_tp1 - mii_tp1;
    end;

    avg_at_t = .;
    avg_at_tp1 = .;
    if nmiss(at_tm1, at_t) = 0 then avg_at_t = (at_tm1 + at_t) / 2;
    if nmiss(at_t, at_tp1) = 0 then avg_at_tp1 = (at_t + at_tp1) / 2;
    if avg_at_t <= 0 then avg_at_t = .;
    if avg_at_tp1 <= 0 then avg_at_tp1 = .;

    ptbi_t = .;
    ptbi_tp1 = .;
    if not missing(ptbi_amt_t) and not missing(avg_at_t) then
        ptbi_t = ptbi_amt_t / avg_at_t;
    if not missing(ptbi_amt_tp1) and not missing(avg_at_tp1) then
        ptbi_tp1 = ptbi_amt_tp1 / avg_at_tp1;

    dte_tax = .;
    if nmiss(txdfed_t, txdfo_t) = 0 then dte_tax = txdfed_t + txdfo_t;
    else if not missing(txdi_t) then dte_tax = txdi_t;
    btd_scaled = .;
    if not missing(dte_tax) and not missing(avg_at_t) then
        btd_scaled = (dte_tax / 0.35) / avg_at_t;

    current_tax_t = .;
    current_tax_method = 0;
    if nmiss(txt_t, txdi_t) = 0 then do;
        current_tax_t = txt_t - txdi_t;
        current_tax_method = 1;
    end;
    if missing(current_tax_t) then tax_unknown = 1;
    else tax_unknown = 0;
    if not missing(current_tax_t) and current_tax_t < 0 then negtax_flag = 1;
    else negtax_flag = 0;

    cur_ok = 0;
    if not missing(cur_tm1) and not missing(cur_t) and not missing(cur_tp1) then do;
        if cur_tm1 = cur_t and cur_t = cur_tp1 then cur_ok = 1;
    end;

    miss_core = 0;
    if missing(ptbi_t) or missing(ptbi_tp1) or missing(btd_scaled) or
       missing(avg_at_t) or missing(avg_at_tp1) then miss_core = 1;

    mii_missing_t = missing(mii_t);
    mii_missing_tp1 = missing(mii_tp1);
    mii_zero_t = (not missing(mii_t) and mii_t = 0);
    if not missing(ptbi_t) and ptbi_t < 0 then loss_flag = 1;
    else loss_flag = 0;
    if not missing(pi_t) and pi_t < 0 then raw_pi_loss_flag = 1;
    else raw_pi_loss_flag = 0;
    if not missing(ptbi_amt_t) and ptbi_amt_t = 0 then zero_ptbi_flag = 1;
    else zero_ptbi_flag = 0;
    if missing(tlcf_t) then nol_unknown = 1;
    else nol_unknown = 0;
    if not missing(tlcf_t) and tlcf_t > 0 then nol_flag = 1;
    else nol_flag = 0;
run;

proc sql;
    title "Sequential sample-screen counts";
    select count(*) as crsp_intersection_firmyears,
           sum(case when miss_core = 1 then 1 else 0 end) as missing_regression_construction,
           sum(case when miss_core = 0 and cur_ok = 0 then 1 else 0 end) as currency_mismatch,
           sum(case when miss_core = 0 and cur_ok = 1 and tax_unknown = 1 then 1 else 0 end) as missing_current_tax,
           sum(case when miss_core = 0 and cur_ok = 1 then 1 else 0 end) as after_reg_cur,
           sum(case when miss_core = 0 and cur_ok = 1 and raw_pi_loss_flag = 1 then 1 else 0 end) as raw_pi_losses,
           sum(case when miss_core = 0 and cur_ok = 1 and zero_ptbi_flag = 1 then 1 else 0 end) as zero_ptbi_rows,
           sum(case when miss_core = 0 and cur_ok = 1 and loss_flag = 1 then 1 else 0 end) as current_ptbi_losses,
           sum(case when miss_core = 0 and cur_ok = 1 and loss_flag = 0 and negtax_flag = 1 then 1 else 0 end) as negative_current_tax,
           sum(case when miss_core = 0 and cur_ok = 1 and loss_flag = 0 and negtax_flag = 0 and nol_flag = 1 then 1 else 0 end) as positive_tlcf_nol,
           sum(case when miss_core = 0 and cur_ok = 1 and loss_flag = 0 and negtax_flag = 0 and nol_flag = 0 then 1 else 0 end) as final_firmyears,
           sum(case when miss_core = 0 and cur_ok = 1 and loss_flag = 0 and negtax_flag = 0 and nol_flag = 0 and nol_unknown = 1 then 1 else 0 end) as final_nol_unknown,
           sum(case when miss_core = 0 and cur_ok = 1 and loss_flag = 0 and negtax_flag = 0 and nol_flag = 0 and tax_unknown = 1 then 1 else 0 end) as final_tax_unknown
      from work.screen_flags;
quit;

data work.eligible;
    set work.screen_flags;
    if miss_core ne 0 then delete;
    if cur_ok ne 1 then delete;
    if loss_flag ne 0 then delete;
    if negtax_flag ne 0 then delete;
    if nol_flag ne 0 then delete;
run;

proc freq data=work.eligible;
    title "Annual observations available for Equation (2) BTD ranks";
    tables fyear / missing;
run;

proc sort data=work.eligible out=work.eligible_s;
    by fyear;
run;
proc rank data=work.eligible_s out=work.ranked groups=5;
    by fyear;
    var btd_scaled;
    ranks btd_rank;
run;

data work.ranked;
    set work.ranked;
    lnbtd = (btd_rank = 0);
    lpbtd = (btd_rank = 4);
run;

proc freq data=work.ranked;
    title "Annual bottom/top temporary-BTD quintile group sizes";
    tables fyear*btd_rank fyear*lnbtd fyear*lpbtd / missing;
run;

proc univariate data=work.ranked noprint;
    var ptbi_t ptbi_tp1 btd_scaled;
    output out=work.win_limits
        pctlpts=1 99
        pctlpre=ptbit_ ptbin_ btd_
        pctlname=p1 p99;
run;

proc print data=work.win_limits noobs;
    title "Pooled 1st and 99th percentile reset cutoffs";
run;

data work.final;
    if _n_ = 1 then set work.win_limits;
    set work.ranked;
    ptbi_t_raw = ptbi_t;
    ptbi_tp1_raw = ptbi_tp1;
    btd_raw = btd_scaled;
    ptbi_t = max(ptbit_p1, min(ptbi_t, ptbit_p99));
    ptbi_tp1 = max(ptbin_p1, min(ptbi_tp1, ptbin_p99));
    btd_scaled = max(btd_p1, min(btd_scaled, btd_p99));
    ptbi_lnbtd = ptbi_t * lnbtd;
    ptbi_lpbtd = ptbi_t * lpbtd;
    if missing(tlcf_t) then nol_unknown = 1;
    else nol_unknown = 0;
    mii_missing_t = missing(mii_t);
    mii_missing_tp1 = missing(mii_tp1);
    mii_zero_t = (not missing(mii_t) and mii_t = 0);
    label ptbi_t = "PTBI at t scaled by average assets"
          ptbi_tp1 = "PTBI at t+1 scaled by average assets"
          btd_scaled = "Scaled temporary book-tax difference"
          lnbtd = "Large negative temporary BTD"
          lpbtd = "Large positive temporary BTD"
          ptbi_lnbtd = "PTBI at t x LNBTD"
          ptbi_lpbtd = "PTBI at t x LPBTD"
          cur_t = "Compustat reporting currency at t"
          nol_unknown = "TLCF status missing; not coded as zero";
    label tax_unknown = "Current tax could not be computed from available items"
          current_tax_method = "1=TXT-TXDI, 0=unknown"
          mii_missing_t = "MII at t not reported"
          mii_missing_tp1 = "MII at t+1 not reported"
          mii_zero_t = "MII at t reported as zero";
    keep gvkey fyear datadate sich cur_t ptbi_t ptbi_tp1 btd_scaled
         lnbtd lpbtd ptbi_lnbtd ptbi_lpbtd btd_rank ptbi_t_raw
         ptbi_tp1_raw btd_raw nol_unknown tax_unknown current_tax_method
         mii_missing_t mii_missing_tp1 mii_zero_t;
run;

proc sort data=work.final out=out.book_tax_firm_years;
    by gvkey fyear;
run;

proc sql;
    title "Final SAS handoff checks";
    select count(*) as final_firmyears,
           count(distinct gvkey) as final_companies,
           sum(nol_unknown) as unknown_tlcf_status,
           sum(tax_unknown) as unknown_current_tax_status,
           sum(mii_missing_t) as missing_mii_t,
           sum(mii_zero_t) as observed_zero_mii_t,
           sum(case when cur_t = 'USD' then 1 else 0 end) as usd_firmyears,
           sum(case when cur_t ne 'USD' then 1 else 0 end) as nonusd_firmyears
      from out.book_tax_firm_years;
    select count(*) as dup_final_keys
      from (select gvkey, fyear from out.book_tax_firm_years
            group by gvkey, fyear having count(*) > 1) as d;
quit;

proc means data=out.book_tax_firm_years n nmiss min p1 p25 median p75 p99 max;
    title "Final analysis-variable distribution check";
    var ptbi_t ptbi_tp1 btd_scaled;
run;

proc freq data=out.book_tax_firm_years;
    title "Final analysis groups and currencies";
    tables lnbtd lpbtd cur_t nol_unknown tax_unknown current_tax_method
           mii_missing_t mii_missing_tp1 mii_zero_t / missing;
run;

title;
