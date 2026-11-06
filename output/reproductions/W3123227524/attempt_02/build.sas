options errorabend;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname compsec "/storage/sas/base/comp/d_na/security" access=readonly;
libname sdc "/storage/sas/base/tfn/sdc_ni" access=readonly;
libname out "./data";

/* Read the event universe and derive only observed, source-based SDC flags. */
data sdc_raw;
    set sdc.wrds_ni_details(
        keep=master_deal_no master_deal_date year filingdate postponed_date
             withdrawn_date withdrawn_date2 registration_status
             registration_status_long security ipo nation currency listmain
             offerpric lowfileprice midfileprice highfileprice description
             businesss regrights spinninames spinafter spinbefore simoffcus
             package_id tranche_id main_tranche sicp cusip cusip9
    );
    if '01JAN1987'd <= master_deal_date and master_deal_date <= '31DEC2006'd;
    length offer_price_num 8 sdc_offer_year issue_year price_parse_fail 8
           offer_cusip $20 sdc_cusip6 $6 sdc_cusip9 $9;
    offer_price_num = input(compress(strip(offerpric), '$, '), ?? best32.);
    sdc_offer_year = input(strip(year), ?? 4.);
    issue_year = year(master_deal_date);
    price_parse_fail = (not missing(offerpric) and missing(offer_price_num));
    offer_cusip = compress(strip(cusip), ' -');
    if lengthn(offer_cusip) >= 6 then sdc_cusip6 = substr(offer_cusip, 1, 6);
    else call missing(sdc_cusip6);
    offer_cusip = compress(strip(cusip9), ' -');
    if lengthn(offer_cusip) = 9 then sdc_cusip9 = offer_cusip;
    else call missing(sdc_cusip9);
    format master_deal_date filingdate postponed_date withdrawn_date withdrawn_date2 date9.;
run;

data sdc_events;
    set sdc_raw;
    length issue_status 8 has_spin has_simul has_rights has_reverse_lbo 8;
    issue_status = (not missing(master_deal_date)
                     and missing(postponed_date)
                     and missing(withdrawn_date)
                     and missing(withdrawn_date2));
    has_spin = (not missing(spinninames) or not missing(spinafter)
                or not missing(spinbefore));
    has_simul = not missing(simoffcus);
    has_rights = (index(upcase(description), 'RIGHT') > 0
                  or index(upcase(description), 'STANDBY') > 0
                  or index(upcase(description), 'UNIT') > 0);
    has_reverse_lbo = (index(upcase(description), 'REVERSE LBO') > 0
                       or index(upcase(description), 'REVERSE LEVERAGED') > 0
                       or index(upcase(businesss), 'REVERSE LBO') > 0);
    is_fund_text = (index(upcase(description), 'CLOSED-END') > 0
                    or index(upcase(description), 'CLOSED END') > 0
                    or index(upcase(description), 'UNIT TRUST') > 0
                    or index(upcase(description), 'LIMITED PARTNERSHIP') > 0
                    or index(upcase(description), 'REIT') > 0
                    or index(upcase(businesss), 'UNIT TRUST') > 0
                    or index(upcase(businesss), 'LIMITED PARTNERSHIP') > 0
                    or index(upcase(businesss), 'REAL ESTATE INVESTMENT TRUST') > 0);
    sdc_offer_year_missing = missing(sdc_offer_year);
    sdc_offer_year_mismatch = (not missing(sdc_offer_year)
                               and sdc_offer_year ne issue_year);
    target_base = (security = 'Common Shares'
                   and ipo = 'No'
                   and nation = 'United States');
    target_market = (currency = 'US'
                     and listmain in ('NYSE','NASDQ','AMEX'));
    target_price = (offer_price_num >= 5);
    target_exclusion_free = (issue_status and not has_spin and not has_simul
                             and not has_rights and not has_reverse_lbo
                             and not is_fund_text
                             and not missing(filingdate)
                             and not missing(sdc_cusip6));
    target_event = (target_base and target_market and target_price
                    and target_exclusion_free);
    any_equity_issue = (security = 'Common Shares'
                        and nation = 'United States'
                        and ipo in ('Yes','No')
                        and issue_status
                        and not missing(master_deal_no)
                        and not missing(sdc_cusip6));
run;

/* Audits preserve the observed values; REGISTRATION_STATUS is not used as completion status. */
title "Observed SDC values for 1987-2006 common-share issues";
proc freq data=sdc_events;
    tables security ipo nation currency listmain registration_status
           registration_status_long regrights / missing;
run;
proc sql;
    select count(*) as issue_period_rows,
           sum(target_base) as us_nonipo_common,
           sum(target_base and target_market) as exchange_currency_candidates,
           sum(target_base and target_market and issue_status) as completed_candidates,
           sum(target_base and target_market and target_price) as price_ge_5,
           sum(target_event) as sdc_screened_offers,
           sum(price_parse_fail) as price_parse_failures,
           sum(sdc_offer_year_missing) as missing_sdc_year,
           sum(sdc_offer_year_mismatch) as year_mismatch,
           sum(missing(filingdate)) as missing_filing_date,
           sum(missing(sdc_cusip6)) as missing_sdc_cusip6,
           sum(missing(sdc_cusip9)) as nonexact_sdc_cusip9,
           sum(has_spin) as spin_flags,
           sum(has_simul) as simultaneous_flags,
           sum(has_rights) as rights_standby_unit_flags,
           sum(has_reverse_lbo) as reverse_lbo_text_flags,
           sum(is_fund_text) as fund_text_flags
    from sdc_events;
    select master_deal_no, count(*) as n_rows
    from sdc_events
    where target_event
    group by master_deal_no
    having count(*) > 1;
quit;

/* Read full annual support and keep a date-valid raw Compustat crosswalk. */
data comp_std_raw;
    set comp.funda(
        keep=gvkey datadate fyear indfmt consol datafmt popsrc fic scf curcd
             sich at ib ibc oancf xidoc cogs invt xad xrd xsga capx ppegt
             sale pddur fyr fdate final upd
    );
    if fyear >= 1981 and fyear <= 2007;
    if strip(upcase(indfmt)) ne 'INDL'
       or strip(upcase(consol)) ne 'C'
       or strip(upcase(datafmt)) ne 'STD'
       or strip(upcase(popsrc)) ne 'D'
       or strip(upcase(fic)) ne 'USA' then delete;
    format datadate fdate date9.;
run;

/* Select the latest dated observation within rare duplicate firm-year keys. */
proc sql;
    select count(*) as duplicate_gvkey_fyear_groups,
           sum(n_rows - 1) as duplicate_extra_rows
    from (select gvkey, fyear, count(*) as n_rows
          from comp_std_raw group by gvkey, fyear having count(*) > 1);
    select gvkey, fyear, count(*) as n_rows,
           min(datadate) format=date9. as first_date,
           max(datadate) format=date9. as selected_date
    from comp_std_raw
    group by gvkey, fyear
    having count(*) > 1;
quit;
proc sort data=comp_std_raw out=comp_std_sorted;
    by gvkey fyear datadate;
run;
data comp_statements;
    set comp_std_sorted;
    by gvkey fyear datadate;
    if last.fyear;
run;

/* Statement history for the filing-date screen does not require usable SIC. */
data comp_annual;
    set comp_statements;
    length sic2 8;
    if not missing(sich) and sich >= 100 and sich <= 9999
       and not (sich >= 6000 and sich <= 6999);
    sic2 = int(sich / 100);
run;

title "Compustat annual period and currency coverage";
proc sql;
    select count(*) as rows_81_07,
           count(distinct gvkey) as gvkeys_81_07,
           min(fyear) as min_fyear, max(fyear) as max_fyear,
           min(datadate) format=date9. as min_datadate,
           max(datadate) format=date9. as max_datadate
    from comp_annual;
quit;
proc freq data=comp_annual;
    tables curcd scf / missing;
run;

/* Build annual lags from explicit fiscal-year joins, never row-position LAG queues. */
proc sql;
    create table comp_lags as
    select t.*,
           p.at as at_lag, p.sale as sale_lag, p.invt as invt_lag,
           p.capx as capx_lag, p.ib as ib_lag, p.curcd as curcd_lag,
           p.datadate as datadate_lag,
           q.sale as sale_lag2, q.curcd as curcd_lag2,
           q.datadate as datadate_lag2
    from comp_annual as t
    left join comp_statements as p
      on p.gvkey=t.gvkey and p.fyear=t.fyear-1
    left join comp_statements as q
      on q.gvkey=t.gvkey and q.fyear=t.fyear-2;
quit;

data aux_inputs;
    set comp_lags;
    length inv_at dsale dsale_lag cfo ta prod disx 8;
    if curcd = curcd_lag and not missing(curcd)
       and not missing(at_lag) and at_lag > 0;
    inv_at = 1 / at_lag;
    if not missing(sale) and not missing(sale_lag) then dsale = sale - sale_lag;
    if curcd_lag = curcd_lag2 and not missing(curcd_lag2)
       and not missing(sale_lag) and not missing(sale_lag2)
       then dsale_lag = sale_lag - sale_lag2;
    if not missing(oancf) and not missing(xidoc) then cfo = oancf - xidoc;
    if not missing(ibc) and not missing(cfo) then ta = ibc - cfo;
    if not missing(cogs) and not missing(invt) and not missing(invt_lag)
       then prod = cogs + (invt - invt_lag);
    if not missing(xsga) then do;
        if missing(xad) then xad_use = 0; else xad_use = xad;
        if missing(xrd) then xrd_use = 0; else xrd_use = xrd;
        disx = xad_use + xrd_use + xsga;
    end;
    if not missing(ta) and not missing(dsale) and not missing(ppegt) then do;
        da_y = ta / at_lag;
        da_x1 = inv_at;
        da_x2 = dsale / at_lag;
        da_x3 = ppegt / at_lag;
    end;
    if not missing(cfo) and not missing(sale) and not missing(dsale) then do;
        cfo_y = cfo / at_lag;
        cfo_x1 = inv_at;
        cfo_x2 = sale / at_lag;
        cfo_x3 = dsale / at_lag;
    end;
    if not missing(prod) and not missing(sale) and not missing(dsale)
       and not missing(dsale_lag) then do;
        prod_y = prod / at_lag;
        prod_x1 = inv_at;
        prod_x2 = sale / at_lag;
        prod_x3 = dsale / at_lag;
        prod_x4 = dsale_lag / at_lag;
    end;
    if not missing(disx) and not missing(sale_lag) then do;
        disx_y = disx / at_lag;
        disx_x1 = inv_at;
        disx_x2 = sale_lag / at_lag;
    end;
run;

/* Estimate four no-intercept support equations on the full nonfinancial pool. */
proc sql;
    create table n_da as select sic2, fyear, count(*) as n
    from aux_inputs where nmiss(da_y, da_x1, da_x2, da_x3)=0
    group by sic2, fyear;
    create table n_cfo as select sic2, fyear, count(*) as n
    from aux_inputs where nmiss(cfo_y, cfo_x1, cfo_x2, cfo_x3)=0
    group by sic2, fyear;
    create table n_prod as select sic2, fyear, count(*) as n
    from aux_inputs where nmiss(prod_y, prod_x1, prod_x2, prod_x3, prod_x4)=0
    group by sic2, fyear;
    create table n_disx as select sic2, fyear, count(*) as n
    from aux_inputs where nmiss(disx_y, disx_x1, disx_x2)=0
    group by sic2, fyear;
quit;

proc sort data=aux_inputs out=aux_sorted; by sic2 fyear; run;
proc sort data=n_da; by sic2 fyear; run;
proc sort data=n_cfo; by sic2 fyear; run;
proc sort data=n_prod; by sic2 fyear; run;
proc sort data=n_disx; by sic2 fyear; run;
data da_fit_input; merge aux_sorted(in=a) n_da(in=b); by sic2 fyear; if a and b and n >= 8 and nmiss(da_y, da_x1, da_x2, da_x3)=0; run;
data cfo_fit_input; merge aux_sorted(in=a) n_cfo(in=b); by sic2 fyear; if a and b and n >= 8 and nmiss(cfo_y, cfo_x1, cfo_x2, cfo_x3)=0; run;
data prod_fit_input; merge aux_sorted(in=a) n_prod(in=b); by sic2 fyear; if a and b and n >= 8 and nmiss(prod_y, prod_x1, prod_x2, prod_x3, prod_x4)=0; run;
data disx_fit_input; merge aux_sorted(in=a) n_disx(in=b); by sic2 fyear; if a and b and n >= 8 and nmiss(disx_y, disx_x1, disx_x2)=0; run;

ods listing close;
ods output ANOVA=anova_da;
proc reg data=da_fit_input;
    by sic2 fyear;
    model da_y = da_x1 da_x2 da_x3 / noint;
    output out=res_da r=da_res;
run;
quit;

ods output ANOVA=anova_cfo;
proc reg data=cfo_fit_input;
    by sic2 fyear;
    model cfo_y = cfo_x1 cfo_x2 cfo_x3 / noint;
    output out=res_cfo r=cfo_res;
run;
quit;

ods output ANOVA=anova_prod;
proc reg data=prod_fit_input;
    by sic2 fyear;
    model prod_y = prod_x1 prod_x2 prod_x3 prod_x4 / noint;
    output out=res_prod r=prod_res;
run;
quit;

ods output ANOVA=anova_disx;
proc reg data=disx_fit_input;
    by sic2 fyear;
    model disx_y = disx_x1 disx_x2 / noint;
    output out=res_disx r=disx_res;
run;
quit;
ods listing;

data rank_da; set anova_da; if Source='Model'; rank_da=DF; keep sic2 fyear rank_da; run;
data rank_cfo; set anova_cfo; if Source='Model'; rank_cfo=DF; keep sic2 fyear rank_cfo; run;
data rank_prod; set anova_prod; if Source='Model'; rank_prod=DF; keep sic2 fyear rank_prod; run;
data rank_disx; set anova_disx; if Source='Model'; rank_disx=DF; keep sic2 fyear rank_disx; run;
proc sql;
    create table valid_da as
    select n.sic2, n.fyear, n.n, r.rank_da
    from n_da as n left join rank_da as r on n.sic2=r.sic2 and n.fyear=r.fyear;
    create table valid_cfo as
    select n.sic2, n.fyear, n.n, r.rank_cfo
    from n_cfo as n left join rank_cfo as r on n.sic2=r.sic2 and n.fyear=r.fyear;
    create table valid_prod as
    select n.sic2, n.fyear, n.n, r.rank_prod
    from n_prod as n left join rank_prod as r on n.sic2=r.sic2 and n.fyear=r.fyear;
    create table valid_disx as
    select n.sic2, n.fyear, n.n, r.rank_disx
    from n_disx as n left join rank_disx as r on n.sic2=r.sic2 and n.fyear=r.fyear;
    select 'DA' as equation length=4, count(*) as groups_n8,
           sum(rank_da=3) as full_rank_groups, sum(rank_da ne 3 or missing(rank_da)) as dropped_rank_groups
    from valid_da where n >= 8;
    select 'CFO' as equation length=4, count(*) as groups_n8,
           sum(rank_cfo=3) as full_rank_groups, sum(rank_cfo ne 3 or missing(rank_cfo)) as dropped_rank_groups
    from valid_cfo where n >= 8;
    select 'PROD' as equation length=4, count(*) as groups_n8,
           sum(rank_prod=4) as full_rank_groups, sum(rank_prod ne 4 or missing(rank_prod)) as dropped_rank_groups
    from valid_prod where n >= 8;
    select 'DISX' as equation length=4, count(*) as groups_n8,
           sum(rank_disx=2) as full_rank_groups, sum(rank_disx ne 2 or missing(rank_disx)) as dropped_rank_groups
    from valid_disx where n >= 8;
quit;

proc sql;
    create table da_resid as select r.gvkey, r.fyear, r.da_res
    from res_da as r inner join valid_da as v
      on r.sic2=v.sic2 and r.fyear=v.fyear
    where v.n >= 8 and v.rank_da=3;
    create table cfo_resid as select r.gvkey, r.fyear, r.cfo_res
    from res_cfo as r inner join valid_cfo as v
      on r.sic2=v.sic2 and r.fyear=v.fyear
    where v.n >= 8 and v.rank_cfo=3;
    create table prod_resid as select r.gvkey, r.fyear, r.prod_res
    from res_prod as r inner join valid_prod as v
      on r.sic2=v.sic2 and r.fyear=v.fyear
    where v.n >= 8 and v.rank_prod=4;
    create table disx_resid as select r.gvkey, r.fyear, r.disx_res
    from res_disx as r inner join valid_disx as v
      on r.sic2=v.sic2 and r.fyear=v.fyear
    where v.n >= 8 and v.rank_disx=2;
quit;
proc sort data=comp_lags; by gvkey fyear; run;
proc sort data=da_resid; by gvkey fyear; run;
proc sort data=cfo_resid; by gvkey fyear; run;
proc sort data=prod_resid; by gvkey fyear; run;
proc sort data=disx_resid; by gvkey fyear; run;
data comp_proxy;
    merge comp_lags(in=a) da_resid cfo_resid prod_resid disx_resid;
    by gvkey fyear;
    if a;
    r_cfo = cfo_res;
    r_prod = prod_res;
    r_disx = disx_res;
    if not missing(r_prod) and not missing(r_disx) then rm1 = r_prod - r_disx;
    if not missing(r_cfo) and not missing(r_disx) then rm2 = -r_cfo - r_disx;
run;

/* Use dated Compustat security-ID history; FUNDA.CUSIP has no effective dates. */
data secid_period;
    set compsec.sec_idhist(keep=gvkey iid item itemvalue efffrom effthru);
    if (missing(efffrom) or efffrom <= '31DEC2006'd)
       and (missing(effthru) or effthru >= '01JAN1987'd);
    format efffrom effthru date9.;
run;
title "Dated Compustat security identifier items, 1987-2006";
proc freq data=secid_period;
    tables item / missing;
run;
proc sql;
    select sum(efffrom=.B) as begin_open_b,
           sum(effthru=.E) as end_open_e,
           sum(missing(efffrom) and efffrom ne .B) as other_missing_begin,
           sum(missing(effthru) and effthru ne .E) as other_missing_end
    from secid_period;
quit;
data sec_id_hist;
    length hist_cusip $20 hist_cusip6 $6;
    set secid_period;
    if strip(upcase(item)) = 'CUSIP';
    hist_cusip = compress(strip(itemvalue), ' -');
    if lengthn(hist_cusip) >= 6 then hist_cusip6 = substr(hist_cusip,1,6);
    else call missing(hist_cusip6);
run;

/* All completed U.S. common IPOs and SEOs define the nonissuer exclusion pool. */
proc sql;
    create table issue_events as
    select master_deal_no, master_deal_date, issue_year, sdc_cusip6, sdc_cusip9, ipo
    from sdc_events where any_equity_issue;
    select count(*) as issue_events, count(distinct master_deal_no) as unique_deal_ids
    from issue_events;
quit;
proc sql;
    create table link_pairs as
    select e.master_deal_no, e.master_deal_date, e.issue_year,
           e.sdc_cusip6, e.sdc_cusip9,
           c.gvkey, c.iid, c.efffrom, c.effthru,
           (not missing(e.sdc_cusip9)
            and e.sdc_cusip9=substr(c.hist_cusip,1,9)) as exact9
    from issue_events as e inner join sec_id_hist as c
      on c.hist_cusip6=e.sdc_cusip6
     and (c.efffrom <= e.master_deal_date or c.efffrom=.B or c.efffrom=.)
     and (c.effthru >= e.master_deal_date or c.effthru=.E or c.effthru=.)
    where not missing(e.sdc_cusip6);
    create table link_exact as
    select master_deal_no, max(exact9) as has_exact9
    from link_pairs group by master_deal_no;
    create table issue_link as
    select p.master_deal_no,
           count(distinct p.gvkey) as n_gvkeys,
           min(p.gvkey) as gvkey,
           max(p.exact9) as exact9,
           min(p.efffrom) as link_efffrom format=date9.
    from link_pairs as p inner join link_exact as q
      on p.master_deal_no=q.master_deal_no
     and (q.has_exact9=0 or p.exact9=1)
    group by p.master_deal_no;
    create table issue_link_audit as
    select e.master_deal_no, l.n_gvkeys, l.exact9
    from issue_events as e left join issue_link as l
      on e.master_deal_no=l.master_deal_no;
    select count(*) as issue_events,
           count(distinct master_deal_no) as unique_deal_ids,
           sum(missing(n_gvkeys)) as no_dated_gvkey,
           sum(n_gvkeys=1) as unique_gvkey,
           sum(n_gvkeys>1) as ambiguous,
           sum(exact9) as selected_exact9
    from issue_link_audit;
quit;

proc sql;
    create table issuer_ids as
    select distinct l.gvkey
    from issue_link as l inner join issue_events as e
      on l.master_deal_no=e.master_deal_no
    where l.n_gvkeys=1;
    create table target_events as
    select * from sdc_events where target_event;
    create table target_link as
    select t.*, l.gvkey as issuer_gvkey, l.n_gvkeys as n_link_gvkeys,
           l.exact9 as link_exact9, l.link_efffrom
    from target_events as t left join issue_link as l
      on t.master_deal_no=l.master_deal_no;
    create table target_precount_base as
    select t.master_deal_no,
           count(distinct c.fyear) as n_pre_filing_years,
           max(c.fyear) as latest_pre_fyear,
           max(c.datadate) as latest_pre_datadate format=date9.
    from target_link as t left join comp_statements as c
      on c.gvkey=t.issuer_gvkey and c.datadate < t.filingdate
    group by t.master_deal_no;
    create table target_precount as
    select b.master_deal_no, b.n_pre_filing_years, b.latest_pre_fyear,
           b.latest_pre_datadate,
           count(distinct case
             when c.fyear >= b.latest_pre_fyear - 3
              and c.fyear <= b.latest_pre_fyear then c.fyear else . end)
             as n_latest_4_prior_fyears,
           min(case
             when c.fyear >= b.latest_pre_fyear - 3
              and c.fyear <= b.latest_pre_fyear then c.datadate else . end)
             as oldest_latest4_datadate format=date9.
    from target_precount_base as b
      inner join target_link as t on t.master_deal_no=b.master_deal_no
      left join comp_statements as c
        on c.gvkey=t.issuer_gvkey and c.datadate < t.filingdate
    group by b.master_deal_no, b.n_pre_filing_years, b.latest_pre_fyear,
             b.latest_pre_datadate;
    title "Filing-date history counts versus four latest consecutive fiscal years";
    select t.issue_year, count(*) as unique_linked_offers,
           sum(h.n_pre_filing_years >= 4) as any_four_prior_fy,
           sum(h.n_latest_4_prior_fyears = 4) as four_latest_consecutive_fy,
           sum(h.n_pre_filing_years >= 4 and h.n_latest_4_prior_fyears < 4)
             as any_four_but_gap_in_latest_four,
           sum(h.n_pre_filing_years >= 4
               and h.latest_pre_fyear < year(t.filingdate)-1)
             as any4_oldlatest,
           sum(h.n_latest_4_prior_fyears=4
               and t.filingdate-h.oldest_latest4_datadate > 5*365)
             as latest4_more_than_five_years_old,
           min(h.latest_pre_fyear) as min_latest_pre_fyear,
           max(h.latest_pre_fyear) as max_latest_pre_fyear,
           min(h.latest_pre_datadate) format=date9. as earliest_latest_pre_date,
           max(h.latest_pre_datadate) format=date9. as latest_pre_date,
           min(h.oldest_latest4_datadate) format=date9. as earliest_fourth_latest_date,
           max(h.oldest_latest4_datadate) format=date9. as latest_fourth_latest_date
    from target_link as t left join target_precount as h
      on t.master_deal_no=h.master_deal_no
    where t.n_link_gvkeys=1
    group by t.issue_year order by t.issue_year;
quit;
proc sql;
    create table pre_history_age as
    select t.issue_year, t.master_deal_no, t.filingdate,
           h.oldest_latest4_datadate,
           t.filingdate-h.oldest_latest4_datadate as oldest_of_four_age_days
    from target_link as t inner join target_precount as h
      on t.master_deal_no=h.master_deal_no
    where t.n_link_gvkeys=1 and h.n_latest_4_prior_fyears=4;
quit;
proc sort data=pre_history_age; by issue_year; run;
title "Age of fourth-latest consecutive annual statement before filing date";
proc means data=pre_history_age n mean min p25 median p75 p95 max;
    by issue_year;
    var oldest_of_four_age_days;
run;

/* Construct year-zero and year-one ROA, plus the source-unspecified growth rates. */
proc sql;
    create table comp_panel as
    select t.gvkey, t.fyear, t.curcd, t.datadate, t.sich,
           t.at_lag, t.at, t.ib, n.ib as ib_next,
           t.sale, t.sale_lag, t.capx, t.capx_lag,
           t.da_res, t.r_cfo, t.r_prod, t.r_disx, t.rm1, t.rm2,
           case when t.at_lag > 0 and not missing(t.ib) then t.ib/t.at_lag else . end as roa0,
           case when t.at > 0 and not missing(n.ib) then n.ib/t.at else . end as roa1,
           case when t.sale_lag > 0 and not missing(t.sale) and not missing(t.sale_lag)
                then (t.sale-t.sale_lag)/t.sale_lag else . end as sale_growth,
           case when t.capx_lag > 0 and not missing(t.capx) and not missing(t.capx_lag)
                then (t.capx-t.capx_lag)/t.capx_lag else . end as capex_growth
    from comp_proxy as t inner join comp_statements as n
      on n.gvkey=t.gvkey and n.fyear=t.fyear+1
    where t.fyear >= 1987 and t.fyear <= 2006
      and t.curcd='USD' and t.curcd_lag='USD' and n.curcd='USD'
      and not missing(t.sich) and t.sich >= 100 and t.sich <= 9999
      and not (t.sich >= 6000 and t.sich <= 6999);
    title "Early and later cohort Compustat coverage at year 0 and year 1";
    select t.issue_year, count(*) as unique_linked_offers,
           sum(not missing(c.gvkey)) as has_y0_standard,
           sum(not missing(n.gvkey)) as has_y1_standard,
           sum(not missing(f.gvkey)) as has_y0_nonfinancial,
           sum(c.curcd='USD') as y0_usd,
           sum(n.curcd='USD') as y1_usd,
           sum(l.curcd_lag='USD') as y0_lag_usd,
           sum(l.at_lag>0) as positive_lag_assets,
           sum(not missing(p0.gvkey)) as has_y0_proxy_row,
           sum(not missing(p1.gvkey)) as has_y1_proxy_row,
           sum(not missing(p.gvkey)) as y0_y1_panel_row,
           sum(not missing(p.roa0)) as observed_roa0,
           sum(not missing(p.roa1)) as observed_roa1,
           sum(nmiss(p.da_res,p.r_cfo,p.r_prod,p.r_disx,p.rm1,p.rm2)=0)
             as all_year0_metrics
    from target_link as t
      left join comp_statements as c
        on c.gvkey=t.issuer_gvkey and c.fyear=t.issue_year
      left join comp_statements as n
        on n.gvkey=t.issuer_gvkey and n.fyear=t.issue_year+1
      left join comp_annual as f
        on f.gvkey=t.issuer_gvkey and f.fyear=t.issue_year
      left join comp_lags as l
        on l.gvkey=t.issuer_gvkey and l.fyear=t.issue_year
      left join comp_proxy as p0
        on p0.gvkey=t.issuer_gvkey and p0.fyear=t.issue_year
      left join comp_proxy as p1
        on p1.gvkey=t.issuer_gvkey and p1.fyear=t.issue_year+1
      left join comp_panel as p
        on p.gvkey=t.issuer_gvkey and p.fyear=t.issue_year
    where t.n_link_gvkeys=1
    group by t.issue_year order by t.issue_year;
    create table issuer_year as
    select t.master_deal_no, t.issue_year as offer_year, t.master_deal_date,
           t.filingdate, t.issuer_gvkey, t.sdc_cusip6, t.sdc_cusip9,
           t.link_efffrom, t.link_exact9, h.n_pre_filing_years,
           h.latest_pre_fyear, h.n_latest_4_prior_fyears,
           p.at_lag as issuer_at_lag, p.roa0 as issuer_roa0,
           p.roa1 as issuer_roa1, p.da_res as da, p.r_cfo, p.r_prod,
           p.r_disx, p.rm1, p.rm2, p.sale_growth, p.capex_growth,
           p.datadate as issuer_datadate
    from target_link as t inner join comp_panel as p
      on p.gvkey=t.issuer_gvkey and p.fyear=t.issue_year
    inner join target_precount as h
      on h.master_deal_no=t.master_deal_no
    where t.n_link_gvkeys=1 and h.n_latest_4_prior_fyears = 4
      and not missing(p.at_lag) and p.at_lag > 0
      and not missing(p.roa0) and not missing(p.roa1)
      and nmiss(p.da_res,p.r_cfo,p.r_prod,p.r_disx,p.rm1,p.rm2)=0;
    select t.issue_year, count(*) as screened_offers,
           sum(t.n_link_gvkeys=1) as unique_dated_links,
           sum(t.n_link_gvkeys>1) as ambiguous_links,
           sum(h.n_pre_filing_years >= 4) as four_pre_filing_years,
           sum(h.n_latest_4_prior_fyears=4) as four_consecutive_pre_fyears,
           sum(not missing(p.gvkey)) as year0_year1_rows,
           sum(not missing(p.gvkey) and h.n_latest_4_prior_fyears=4) as issuer_year_rows,
           sum(not missing(p.gvkey) and h.n_latest_4_prior_fyears=4
               and nmiss(p.da_res,p.r_cfo,p.r_prod,p.r_disx,p.rm1,p.rm2)=0)
             as issuer_year_all_metrics
    from target_link as t
    left join target_precount as h on t.master_deal_no=h.master_deal_no
    left join comp_panel as p on p.gvkey=t.issuer_gvkey and p.fyear=t.issue_year
    group by t.issue_year order by t.issue_year;
quit;

/* Match the nearest year-zero ROA among nonissuers with prior assets +/- 10%. */
proc sql;
    create table match_pairs as
    select i.master_deal_no, i.issuer_gvkey, i.offer_year,
           i.issuer_at_lag,
           c.gvkey as control_gvkey, c.roa0 as control_roa0,
           c.roa1 as control_roa1, c.at_lag as control_at_lag,
           abs(c.roa0-i.issuer_roa0) as roa_gap
    from issuer_year as i, comp_panel as c
    where c.fyear=i.offer_year
      and c.gvkey ne i.issuer_gvkey
      and c.gvkey not in (select gvkey from issuer_ids)
      and c.at_lag >= 0.90*i.issuer_at_lag
      and c.at_lag <= 1.10*i.issuer_at_lag
      and not missing(c.roa0) and not missing(c.roa1);
    create table match_counts as
    select master_deal_no, count(*) as candidate_controls,
           min(roa_gap) as closest_roa_gap
    from match_pairs group by master_deal_no;
quit;
proc sort data=match_pairs out=match_pairs_sorted;
    by master_deal_no roa_gap control_gvkey;
run;
data match_one;
    set match_pairs_sorted;
    by master_deal_no;
    if first.master_deal_no;
run;
title "Year-zero prior assets for selected issuer-control matches, USD millions";
proc means data=match_one n mean min p1 p25 median p75 p99 max;
    var issuer_at_lag control_at_lag;
run;

proc sql;
    create table final_events as
    select i.master_deal_no, i.offer_year, i.master_deal_date,
           i.filingdate, i.issuer_gvkey, m.control_gvkey,
           i.sdc_cusip6, i.link_exact9, i.link_efffrom,
           i.n_pre_filing_years, m.roa_gap as match_roa_gap,
           i.da, i.r_cfo, i.r_prod, i.r_disx, i.rm1, i.rm2,
           i.sale_growth, i.capex_growth,
           (i.issuer_roa1-i.issuer_roa0)-(m.control_roa1-m.control_roa0) as droa1
    from issuer_year as i inner join match_one as m
      on i.master_deal_no=m.master_deal_no;
quit;

data out.seo_earnings_mgmt;
    set final_events;
    label droa1='Adjusted change in ROA in year 1'
          da='Discretionary accruals'
          r_cfo='Abnormal CFO'
          r_prod='Abnormal production costs'
          r_disx='Abnormal discretionary expenses'
          rm1='RM_1'
          rm2='RM_2'
          sale_growth='Sales growth'
          capex_growth='Capex growth';
run;

/* Count target-stage attrition, model complete cases, and annual rank support. */
proc sql;
    select count(*) as sdc_offers,
           sum(n_link_gvkeys=0 or missing(n_link_gvkeys)) as no_dated_comp_link,
           sum(n_link_gvkeys=1) as unique_dated_comp_link,
           sum(n_link_gvkeys>1) as ambiguous_dated_comp_link,
           sum(n_pre_filing_years>=4) as four_prior_statements,
           count(*) as events_before_comp_screen
    from target_link as t left join target_precount as h
      on t.master_deal_no=h.master_deal_no;
    select count(*) as final_events,
           count(distinct master_deal_no) as unique_event_keys,
           count(distinct issuer_gvkey) as issuer_gvkeys,
           count(distinct control_gvkey) as control_gvkeys,
           min(offer_year) as first_offer_year,
           max(offer_year) as last_offer_year,
           sum(not missing(da)) as da_observed,
           sum(not missing(r_cfo)) as cfo_observed,
           sum(not missing(r_prod)) as prod_observed,
           sum(not missing(r_disx)) as disx_observed,
           sum(not missing(rm1)) as rm1_observed,
           sum(not missing(rm2)) as rm2_observed,
           sum(not missing(sale_growth)) as sales_growth_observed,
           sum(not missing(capex_growth)) as capex_growth_observed
    from out.seo_earnings_mgmt;
    create table t6_counts as
    select offer_year, count(*) as n_events,
           sum(nmiss(droa1,da,sale_growth,capex_growth)=0) as n_da,
           sum(nmiss(droa1,r_cfo,da,sale_growth,capex_growth)=0) as n_cfo,
           sum(nmiss(droa1,r_prod,da,sale_growth,capex_growth)=0) as n_prod,
           sum(nmiss(droa1,r_disx,da,sale_growth,capex_growth)=0) as n_disx,
           sum(nmiss(droa1,rm1,da,sale_growth,capex_growth)=0) as n_rm1,
           sum(nmiss(droa1,rm2,da,sale_growth,capex_growth)=0) as n_rm2
    from out.seo_earnings_mgmt group by offer_year order by offer_year;
quit;
title "Table 6 analysis-sample complete cases by offer year";
proc print data=t6_counts noobs; run;
title "Table 6 analysis-variable distributions";
proc means data=out.seo_earnings_mgmt n mean std min p25 median p75 max;
    var droa1 da r_cfo r_prod r_disx rm1 rm2 sale_growth capex_growth match_roa_gap;
run;

proc sql;
    create table t6_da_input as select * from out.seo_earnings_mgmt
    where nmiss(droa1,da,sale_growth,capex_growth)=0;
    create table t6_cfo_input as select * from out.seo_earnings_mgmt
    where nmiss(droa1,r_cfo,da,sale_growth,capex_growth)=0;
    create table t6_prod_input as select * from out.seo_earnings_mgmt
    where nmiss(droa1,r_prod,da,sale_growth,capex_growth)=0;
    create table t6_disx_input as select * from out.seo_earnings_mgmt
    where nmiss(droa1,r_disx,da,sale_growth,capex_growth)=0;
    create table t6_rm1_input as select * from out.seo_earnings_mgmt
    where nmiss(droa1,rm1,da,sale_growth,capex_growth)=0;
    create table t6_rm2_input as select * from out.seo_earnings_mgmt
    where nmiss(droa1,rm2,da,sale_growth,capex_growth)=0;
quit;
proc sort data=t6_da_input; by offer_year; run;
proc sort data=t6_cfo_input; by offer_year; run;
proc sort data=t6_prod_input; by offer_year; run;
proc sort data=t6_disx_input; by offer_year; run;
proc sort data=t6_rm1_input; by offer_year; run;
proc sort data=t6_rm2_input; by offer_year; run;

ods listing close;
ods output ANOVA=t6_anova_da;
proc reg data=t6_da_input; by offer_year; model droa1=da sale_growth capex_growth; run; quit;
ods output ANOVA=t6_anova_cfo;
proc reg data=t6_cfo_input; by offer_year; model droa1=r_cfo da sale_growth capex_growth; run; quit;
ods output ANOVA=t6_anova_prod;
proc reg data=t6_prod_input; by offer_year; model droa1=r_prod da sale_growth capex_growth; run; quit;
ods output ANOVA=t6_anova_disx;
proc reg data=t6_disx_input; by offer_year; model droa1=r_disx da sale_growth capex_growth; run; quit;
ods output ANOVA=t6_anova_rm1;
proc reg data=t6_rm1_input; by offer_year; model droa1=rm1 da sale_growth capex_growth; run; quit;
ods output ANOVA=t6_anova_rm2;
proc reg data=t6_rm2_input; by offer_year; model droa1=rm2 da sale_growth capex_growth; run; quit;
ods listing;

data t6_rank_da; length fit $4; set t6_anova_da; if Source='Model'; rank=DF; fit='DA'; keep offer_year rank fit; run;
data t6_rank_cfo; length fit $4; set t6_anova_cfo; if Source='Model'; rank=DF; fit='CFO'; keep offer_year rank fit; run;
data t6_rank_prod; length fit $4; set t6_anova_prod; if Source='Model'; rank=DF; fit='PROD'; keep offer_year rank fit; run;
data t6_rank_disx; length fit $4; set t6_anova_disx; if Source='Model'; rank=DF; fit='DISX'; keep offer_year rank fit; run;
data t6_rank_rm1; length fit $4; set t6_anova_rm1; if Source='Model'; rank=DF; fit='RM1'; keep offer_year rank fit; run;
data t6_rank_rm2; length fit $4; set t6_anova_rm2; if Source='Model'; rank=DF; fit='RM2'; keep offer_year rank fit; run;
data t6_rank_all; set t6_rank_da t6_rank_cfo t6_rank_prod t6_rank_disx t6_rank_rm1 t6_rank_rm2; run;
title "Table 6 annual regressor rank; full rank requires rank equal to slope count";
proc print data=t6_rank_all noobs; run;
proc sql;
    select fit, count(*) as annual_models,
           sum((fit='DA' and rank=3) or (fit ne 'DA' and rank=4)) as full_rank_years
    from t6_rank_all group by fit;
quit;
