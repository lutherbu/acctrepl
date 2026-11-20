options errorabend mprint mlogic;

%let srcroot=%sysget(ACCTREPL_SAS_ROOT);
libname trws "&srcroot/tfn/worldscope" access=readonly;
libname dsref "&srcroot/tfn/ds_eq/reference_tables" access=readonly;
libname wslnk "&srcroot/wrdsapps/linking/wsds2link" access=readonly;

proc import datafile="input/ias_data_dhlv_jar_2013.dta"
    out=work.author_data dbms=dta replace;
run;

data work.target;
    set work.author_data(keep=dscd isin year ias ias_firm ias_swyr
                         ias_serious_em ias_serious_cov ias_serious_fac
                         usgaap usgaap_firm country);
    where year ge 1990 and year le 2005;
run;

proc sql;
    select freq, count(*) as rows
      from trws.wrds_ws_funda
     where year_ ge 1989 and year_ le 2005
     group by freq;

    select count(*), count(distinct dscd), min(year), max(year),
           sum(ias=1), sum(usgaap=1)
      into :n_target, :n_target_firms, :min_year, :max_year,
           :n_ias, :n_usgaap
      from work.target;
    select sum(not missing(ias_serious_em)),
           sum(not missing(ias_serious_cov)),
           sum(not missing(ias_serious_fac))
      into :n_em, :n_cov, :n_fac
      from work.target;
quit;

%put NOTE: Target rows=&n_target distinct_datastream_ids=&n_target_firms years=&min_year-&max_year IAS_rows=&n_ias USGAAP_rows=&n_usgaap serious_nonmissing_behavior=&n_em serious_nonmissing_environment=&n_cov serious_nonmissing_incentives=&n_fac;

proc sort data=work.target(keep=dscd) out=work.ids nodupkey;
    by dscd;
run;

%macro audit_id(var=,tag=);
    proc sql;
        create table work.map_&tag as
        select distinct a.dscd, b.infocode
        from work.ids as a
        left join dsref.wrds_ds_names as b
          on not missing(a.dscd) and not missing(b.&var)
         and upcase(strip(a.dscd))=upcase(strip(b.&var));
        select count(distinct case when not missing(infocode) then dscd end),
               count(distinct infocode),
               sum(not missing(infocode))
          into :match_&tag, :codes_&tag, :pairs_&tag
          from work.map_&tag;
    quit;
    %put NOTE: Datastream ID match via &var: matched_firms=&&match_&tag distinct_info_codes=&&codes_&tag id_code_pairs=&&pairs_&tag;
%mend;

%audit_id(var=DsCode,tag=dscode);
%audit_id(var=DsCompCode,tag=compcode);
%audit_id(var=DsSctyCode,tag=sctycode);
%audit_id(var=DsLocalCode,tag=localcode);

proc sql;
    create table work.ws_match as
    select distinct a.dscd, a.isin, a.year, b.code, b.year_ as ws_year,
           b.item5350 as fiscal_end, b.item2999 as total_assets,
           b.item3351 as total_liabilities, b.item1551 as net_income,
           b.item4860 as operating_cash_flow, b.item1001 as sales,
           b.item7210 as market_cap_usd, b.item7220 as common_equity_usd,
           b.item8326 as roa, b.item6038 as ibes_ticker
    from work.target as a
    left join trws.wrds_ws_funda as b
      on not missing(a.isin) and not missing(b.item6008)
      and not missing(b.code)
     and upcase(strip(a.isin))=upcase(strip(b.item6008))
     and a.year=b.year_ and b.freq='A';

    create table work.ws_key_counts as
    select dscd, year, count(distinct code) as ws_codes,
           count(distinct fiscal_end) as fiscal_dates,
           max(not missing(total_assets)) as has_assets,
           max(not missing(total_liabilities)) as has_liabilities,
           max(not missing(net_income)) as has_ni,
           max(not missing(operating_cash_flow)) as has_cfo,
           max(not missing(sales)) as has_sales,
           max(not missing(market_cap_usd)) as has_mktcap,
           max(not missing(common_equity_usd)) as has_equity,
           max(not missing(roa)) as has_roa,
           max(not missing(ibes_ticker)) as has_ibes
    from work.ws_match
    group by dscd, year;

    select count(*), count(distinct dscd),
           sum(ws_codes > 0), sum(ws_codes > 1),
           sum(fiscal_dates > 0), sum(has_assets), sum(has_liabilities),
           sum(has_ni), sum(has_cfo), sum(has_sales), sum(has_mktcap),
           sum(has_equity), sum(has_roa), sum(has_ibes)
      into :ws_rows, :ws_ids, :ws_matched, :ws_ambiguous,
           :ws_date_rows, :ws_assets, :ws_liabs, :ws_ni, :ws_cfo, :ws_sales,
           :ws_mktcap, :ws_equity, :ws_roa, :ws_ibes
      from work.ws_key_counts;
quit;

%put NOTE: Worldscope Funda ISIN-year match firm_years=&ws_rows firms=&ws_ids matched=&ws_matched ambiguous=&ws_ambiguous fiscal_end_rows=&ws_date_rows assets=&ws_assets liabilities=&ws_liabs net_income=&ws_ni cfo=&ws_cfo sales=&ws_sales USD_market_cap=&ws_mktcap common_equity=&ws_equity roa=&ws_roa IBES_ticker=&ws_ibes;

proc sql;
    create table work.ds_id_info as
    select distinct a.dscd, a.isin, a.year, b.infocode
    from work.target as a
    left join dsref.wrds_ds_names as b
      on not missing(a.dscd) and not missing(b.dscode)
     and upcase(strip(a.dscd))=upcase(strip(b.dscode));

    create table work.link_candidates as
    select distinct a.dscd, a.year, a.infocode, l.code,
           l.startdate, l.enddate, l.coderank, l.inforank,
           f.item5350 as fiscal_end, f.item2999 as total_assets,
           f.item3351 as total_liabilities, f.item1551 as net_income,
           f.item4860 as operating_cash_flow, f.item1001 as sales,
           f.item7210 as market_cap_usd, f.item7220 as common_equity_usd,
           f.item8326 as roa, f.item6038 as ibes_ticker
    from work.ds_id_info as a
    left join wslnk.ds2ws_linktable as l
       on not missing(a.infocode) and not missing(l.infocode)
      and a.infocode=l.infocode
    left join trws.wrds_ws_funda as f
       on not missing(l.code) and not missing(f.code)
      and l.code=f.code and a.year=f.year_ and f.freq='A'
      and not missing(f.item5350)
     and (missing(l.startdate) or l.startdate <= f.item5350)
     and (missing(l.enddate) or l.enddate >= f.item5350);

    create table work.link_key_counts as
    select dscd, year,
            count(distinct infocode) as candidate_ds_codes,
            count(distinct case when not missing(fiscal_end) then infocode end) as ds_codes,
            count(distinct case when not missing(fiscal_end) then code end) as ws_codes,
           count(distinct fiscal_end) as fiscal_dates,
           max(not missing(total_assets)) as has_assets,
           max(not missing(total_liabilities)) as has_liabilities,
           max(not missing(net_income)) as has_ni,
           max(not missing(operating_cash_flow)) as has_cfo,
           max(not missing(sales)) as has_sales,
           max(not missing(market_cap_usd)) as has_mktcap,
           max(not missing(common_equity_usd)) as has_equity,
           max(not missing(roa)) as has_roa,
           max(not missing(ibes_ticker)) as has_ibes
    from work.link_candidates
    group by dscd, year;

    select count(*), count(distinct dscd),
            sum(candidate_ds_codes > 0), sum(ds_codes > 0),
            sum(ws_codes=1 and fiscal_dates=1), sum(ws_codes > 1),
            sum(fiscal_dates=1), sum(fiscal_dates > 1),
            sum((ws_codes=1 and fiscal_dates=1) and has_assets),
            sum((ws_codes=1 and fiscal_dates=1) and has_liabilities),
            sum((ws_codes=1 and fiscal_dates=1) and has_ni),
            sum((ws_codes=1 and fiscal_dates=1) and has_cfo),
            sum((ws_codes=1 and fiscal_dates=1) and has_sales),
            sum((ws_codes=1 and fiscal_dates=1) and has_mktcap),
            sum((ws_codes=1 and fiscal_dates=1) and has_equity),
            sum((ws_codes=1 and fiscal_dates=1) and has_roa),
            sum((ws_codes=1 and fiscal_dates=1) and has_ibes)
       into :lnk_rows, :lnk_ids, :lnk_candidates, :lnk_ds,
            :lnk_unique, :lnk_ambig, :lnk_fye, :lnk_multi_fye,
            :lnk_assets, :lnk_liabs, :lnk_ni, :lnk_cfo,
            :lnk_sales, :lnk_mktcap, :lnk_equity, :lnk_roa, :lnk_ibes
      from work.link_key_counts;
quit;

%put NOTE: DS-to-WS dated link firm_years=&lnk_rows firms=&lnk_ids candidate_DS_info_matches=&lnk_candidates dated_DS_info_matches=&lnk_ds unique_WS_and_fiscal_end=&lnk_unique multiple_WS_code=&lnk_ambig fiscal_end=&lnk_fye multiple_fiscal_end=&lnk_multi_fye assets=&lnk_assets liabilities=&lnk_liabs net_income=&lnk_ni cfo=&lnk_cfo sales=&lnk_sales USD_market_cap=&lnk_mktcap common_equity=&lnk_equity roa=&lnk_roa IBES_ticker=&lnk_ibes;

proc sql;
    create table work.isin_map as
    select distinct a.dscd, b.infocode
    from work.target as a
    left join dsref.wrds_ds_names as b
      on not missing(a.isin) and not missing(b.isin)
     and upcase(strip(a.isin))=upcase(strip(b.isin));
    select count(distinct case when not missing(infocode) then dscd end),
           count(distinct infocode), sum(not missing(infocode))
      into :isin_firms, :isin_codes, :isin_pairs
      from work.isin_map;
quit;

%put NOTE: Datastream ISIN match: matched_firms=&isin_firms distinct_info_codes=&isin_codes id_code_pairs=&isin_pairs;

proc sql;
    select count(*), count(distinct dscd),
           sum(not missing(ias_serious_em)),
           sum(not missing(ias_serious_cov)),
           sum(not missing(ias_serious_fac))
      from work.target;
quit;
