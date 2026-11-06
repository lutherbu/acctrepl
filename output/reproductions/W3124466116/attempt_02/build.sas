options errorabend msglevel=i;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname compseg "/storage/sas/base/comp/d_seghist" access=readonly;
libname out "data";

/* Standard annual company records, restricted to the paper's fiscal years. */
data work.funda0;
    set comp.funda(
        keep=gvkey datadate fyear indfmt consol popsrc datafmt fic curcd
             sich sale pi pidom pifo txfed txfo txc txdi txt at seq
        where=(fyear ge 1990 and fyear le 1997)
    );
    if upcase(strip(indfmt)) ne 'INDL' then delete;
    if upcase(strip(consol)) ne 'C' then delete;
    if upcase(strip(popsrc)) ne 'D' then delete;
    if upcase(strip(datafmt)) ne 'STD' then delete;
    if missing(gvkey) or missing(datadate) then delete;
run;

proc sql;
    create table work.funddup as
    select gvkey, datadate, count(*) as n
    from work.funda0
    group by gvkey, datadate
    having calculated n gt 1;
    select count(*) into :funddup trimmed from work.funddup;
quit;
data _null_;
    if &funddup gt 0 then do;
        put "ERROR: Duplicate standard Funda GVKEY-DATADATE keys require a source-supported selection rule.";
        abort cancel;
    end;
run;

/* Record source currency and tax-component diagnostics before sample screens. */
title "Funda reporting currency among standard 1990-1997 records";
proc freq data=work.funda0;
    tables curcd / missing;
run;
title "Minimum-data field availability in standard annual records";
proc means data=work.funda0 n nmiss;
    var sale pi pidom pifo txfed txfo at seq sich;
run;
proc sql;
    select count(*) as standard_rows,
           sum(case when not missing(sale) and not missing(pi) and
                         not missing(txfed) and not missing(txfo) and
                         not missing(at) and not missing(seq) then 1 else 0 end)
               as complete_etr_inputs,
           sum(case when not missing(sale) and not missing(pi) and
                         not missing(pidom) and not missing(pifo) and
                         not missing(txfed) and not missing(txfo) and
                         not missing(at) and not missing(seq) then 1 else 0 end)
               as complete_all_tax_variables,
           sum(case when not missing(sale) and not missing(pi) and
                         not missing(pidom) and not missing(pifo) and
                         not missing(txfed) and not missing(txfo) and
                         not missing(at) and not missing(seq) and
                         not missing(sich) then 1 else 0 end)
               as complete_all_variables_and_sic
    from work.funda0;
quit;

title "Current tax component availability and crosswalk check";
data work.tax_audit;
    set work.funda0;
    if not missing(txfed) and not missing(txfo) and not missing(txc) then do;
        taxdiff = txfed + txfo - txc;
        taxboth = 1;
    end;
    else do;
        taxdiff = .;
        taxboth = 0;
    end;
run;
proc means data=work.tax_audit n nmiss mean std min p50 max;
    var txfed txfo txc txdi txt taxdiff;
run;
proc freq data=work.tax_audit;
    tables taxboth / missing;
run;

/* Paper ETR-pool exclusions, kept as sequential populations for attrition. */
data work.funda_us;
    set work.funda0;
    if upcase(strip(fic))='USA';
run;

data work.funda_usd;
    set work.funda_us;
    if upcase(strip(curcd))='USD';
run;

data work.funda_nonzero;
    set work.funda_usd;
    if missing(at) or missing(pi) then delete;
    if at=0 or pi=0 then delete;
run;

data work.funda_equity;
    set work.funda_nonzero;
    if missing(seq) or at lt 0 or seq lt 0 then delete;
run;

data work.funda_etr;
    set work.funda_equity;
    if missing(txfed) or missing(txfo) then delete;
    ctax = txfed + txfo;
    if missing(ctax) then delete;
run;

title "Historical SIC availability and industry codes before industry exclusions";
proc sql;
    select fyear,
           sum(missing(sich)) as missing_sic_n,
           sum(sich=0) as sic_zero_n,
           sum(4900 le sich and sich le 4999) as utility_sic_n,
           sum(6000 le sich and sich le 6099) as bank_sic_n,
           sum(6300 le sich and sich le 6399) as insurance_carrier_sic_n,
           sum(6100 le sich and sich le 6299) as other_finance_6100_6299_n,
           sum(6400 le sich and sich le 6999) as other_finance_6400_6999_n
    from work.funda_etr
    group by fyear
    order by fyear;
quit;

data work.funda_industry;
    set work.funda_etr;
    if not missing(sich) and
       ((4900 le sich and sich le 4999) or
        (6000 le sich and sich le 6099) or
        (6300 le sich and sich le 6399)) then delete;
run;

data work.funda_positive;
    set work.funda_industry;
    if pi le 0 or ctax le 0 then delete;
    wwetr = ctax / pi;
    if wwetr gt 1 then wwetr=1;
    roa = pi / at;
    if not missing(sale) and sale gt -1 then size=log(1+sale);
    else size=.;
    pti = log(1+pi);
run;

proc means data=work.funda_positive noprint;
    var roa;
    output out=work.roa_cut p1=roa_p1 p99=roa_p99;
run;
data work.etrpool;
    if _n_=1 then set work.roa_cut;
    set work.funda_positive;
    if roa lt roa_p1 or roa gt roa_p99 then delete;
    drop _TYPE_ _FREQ_ roa_p1 roa_p99;
    etrpool=1;
run;

title "Sequential ETR-pool counts";
proc sql;
    select "standard annual records" as step length=32, count(*) as n from work.funda0
    union all select "US-incorporated" as step, count(*) as n from work.funda_us
    union all select "USD reporting currency" as step, count(*) as n from work.funda_usd
    union all select "nonzero observed PI and AT" as step, count(*) as n from work.funda_nonzero
    union all select "nonnegative observed AT and SEQ" as step, count(*) as n from work.funda_equity
    union all select "observed TXFED and TXFO" as step, count(*) as n from work.funda_etr
    union all select "exclude banks carriers utilities" as step, count(*) as n from work.funda_industry
    union all select "positive PI and current taxes" as step, count(*) as n from work.funda_positive
    union all select "after pooled ROA tail trim" as step, count(*) as n from work.etrpool;
quit;
data work.etr_sic;
    set work.etrpool;
    if missing(sich) then sicgrp=.;
    else if 0 le sich and sich lt 2000 then sicgrp=1;
    else if 2000 le sich and sich lt 3000 then sicgrp=2;
    else if 3000 le sich and sich lt 4000 then sicgrp=3;
    else if 4000 le sich and sich lt 5000 then sicgrp=4;
    else if 5000 le sich and sich lt 6000 then sicgrp=5;
    else if 6000 le sich and sich le 8000 then sicgrp=6;
    else if sich gt 8000 then sicgrp=7;
run;
title "Broad ETR pool by fiscal year and reconstructed SIC group";
proc freq data=work.etr_sic;
    tables fyear*sicgrp / missing;
run;
proc freq data=work.etrpool;
    tables fyear / missing;
run;
title "Broad ETR pool outcome and core input distributions";
proc means data=work.etrpool n nmiss mean std p1 p25 p50 p75 p99 min max;
    var wwetr sale pi at roa size pti pifo txfed txfo;
run;

/* Restrict the only catalog-listed geographic operating-segment table to
   exact firm-date keys in the ETR pool and the necessary fields. */
proc sql;
    create table work.segraw as
    select s.gvkey, s.datadate, s.stype, s.sid, s.geotp, s.snms,
           s.ias, s.curcds, s.isosrc, s.srcdate
    from compseg.wrds_segmerged as s
    inner join work.etrpool as f
      on s.gvkey=f.gvkey and s.datadate=f.datadate;
quit;

title "Observed segment method and geographic type";
proc freq data=work.segraw;
    tables stype*geotp / missing;
run;
title "Geographic segment currency and source currency";
proc freq data=work.segraw;
    where index(upcase(strip(stype)), 'GEO') gt 0;
    tables curcds*isosrc / missing;
run;

data work.seg_vintage;
    set work.segraw;
    if upcase(strip(stype)) ne 'GEOSEG' then delete;
    datayr=year(datadate);
    srcyr=year(srcdate);
    vintage_gap=srcyr-datayr;
run;
title "Geographic segment source-date vintages";
proc means data=work.seg_vintage n nmiss min p25 median p75 max;
    var datayr srcyr vintage_gap;
run;
proc freq data=work.seg_vintage;
    tables srcyr / missing;
run;

proc sql;
    create table work.snms_counts_all as
    select upcase(compbl(strip(snms))) as snms length=256,
           count(*) as n,
           min(datadate) as min_data format=date9.,
           max(datadate) as max_data format=date9.,
           min(srcdate) as min_src format=date9.,
           max(srcdate) as max_src format=date9.
    from work.seg_vintage
    group by calculated snms
    order by n desc, calculated snms;
quit;
proc sort data=work.snms_counts_all;
    by descending n snms;
run;
data work.snms_counts_ranked;
    set work.snms_counts_all;
    diagnostic_rank=_n_;
run;
data work.snms_counts;
    set work.snms_counts_ranked;
    if diagnostic_rank gt 120 then delete;
run;
title "Most frequent reported geographic segment names";
proc print data=work.snms_counts noobs;
run;

proc sql;
    create table work.geotp_audit as
    select stype, geotp, count(*) as n,
           sum(case when missing(strip(snms)) then 1 else 0 end) as snms_missing,
           sum(case when missing(ias) then 1 else 0 end) as ias_missing,
           sum(case when ias gt 0 then 1 else 0 end) as ias_positive,
           sum(case when upcase(strip(curcds)) ne 'USD' or missing(curcds)
                    then 1 else 0 end) as nonusd_rows
    from work.segraw
    where index(upcase(strip(stype)), 'GEO') gt 0
    group by stype, geotp
    order by stype, geotp;
quit;
title "Geographic type, name, asset, and currency audit";
proc print data=work.geotp_audit noobs;
run;

/* Select the latest source date within each firm-date geographic report.
   Keep only the current provider's GeoSeg records; do not interpret GEOTP as
   a legacy country code. */
proc sql;
    create table work.segmaxsrc as
    select gvkey, datadate, stype, max(srcdate) as maxsrc format=date9.
    from work.seg_vintage
    group by gvkey, datadate, stype;
    create table work.seglatest as
    select s.*
    from work.seg_vintage as s
    inner join work.segmaxsrc as m
      on s.gvkey=m.gvkey and s.datadate=m.datadate and
         s.stype=m.stype and s.srcdate=m.maxsrc;
quit;

proc sql;
    create table work.sid_vintage as
    select gvkey, datadate, stype, sid,
           count(*) as source_rows,
           count(distinct srcdate) as source_dates,
           count(distinct geotp) as type_values,
           count(distinct curcds) as currency_values
    from work.seg_vintage
    group by gvkey, datadate, stype, sid;
    select count(*) as sid_group_n,
           sum(source_dates gt 1) as multi_vintage_sid_n,
           sum(source_rows gt 1) as repeated_sid_row_n,
           sum(type_values gt 1) as type_change_sid_n,
           sum(currency_values gt 1) as currency_change_sid_n
    from work.sid_vintage;

quit;

/* Parse observed descriptions into the paper's location indicators and into
   canonical geographic tokens. The token table supports a pairwise audit of
   repeated countries and broad-region/country hierarchy overlap. */
data work.segnorm(keep=gvkey datadate stype sid geotp snms ias curcds isosrc srcdate
                        datayr srcyr vintage_gap segment_row_id gcode geotp_up name_up
                        loc_africa loc_asia loc_japan loc_middeast loc_europe loc_uk
                        loc_france loc_germany loc_oceania loc_samerica loc_canada loc_mexico
                        row_unknown row_aggregate row_scope_gap loc_bad broad_europe broad_asia
                        broad_namerica)
     work.segtokens(keep=gvkey datadate segment_row_id token_canon token_group
                         token_broad token_aggregate token_unknown);
    set work.seglatest;
    length geotp_up $32 name_up $256 tok $128 token_canon $128 token_group $8;
    segment_row_id=_n_;
    geotp_up=upcase(compbl(strip(geotp)));
    name_up=upcase(compbl(strip(snms)));
    gcode=.;
    if index(geotp_up,'TOTAL FOREIGN') gt 0 then gcode=1;
    else if index(geotp_up,'NONDOMESTIC') gt 0 or
            index(geotp_up,'NON-DOMESTIC') gt 0 or
            index(geotp_up,'NON DOMESTIC') gt 0 then gcode=3;
    else if geotp_up='DOMESTIC' then gcode=2;
    else do;
        geotp_num=input(strip(geotp),?? best32.);
        if geotp_num in (1,2,3) then gcode=geotp_num;
    end;
    loc_africa=0; loc_asia=0; loc_japan=0; loc_middeast=0;
    loc_europe=0; loc_uk=0; loc_france=0; loc_germany=0;
    loc_oceania=0; loc_samerica=0; loc_canada=0; loc_mexico=0;
    row_unknown=0; row_aggregate=0; row_scope_gap=0; loc_bad=0;
    broad_europe=0; broad_asia=0; broad_namerica=0;
    if gcode=3 then do;
        if missing(name_up) then do;
            row_unknown=1;
            row_aggregate=1;
        end;
        else do ti=1 to countw(name_up,',');
            tok=upcase(compbl(strip(scan(name_up,ti,','))));
            token_canon=tok; token_group=''; token_broad=0; token_aggregate=0;
            token_unknown=0;
            if tok in ('AFRICA') then do;
                loc_africa=1; token_group='AF'; token_broad=1;
            end;
            else if tok in ('SOUTH AFRICA','REPUBLIC OF SOUTH AFRICA') then do;
                loc_africa=1; token_canon='SOUTH AFRICA'; token_group='AF';
            end;
            else if tok in ('ASIA','FAR EAST') then do;
                loc_asia=1; token_group='ASIA'; token_broad=1;
                broad_asia=1;
            end;
            else if tok in ('PHILIPPINES','CHINA','INDIA','TAIWAN','HONG KONG',
                            'SINGAPORE','KOREA','SOUTH KOREA','NORTH KOREA',
                            'THAILAND','MALAYSIA','INDONESIA','PAKISTAN',
                            'BANGLADESH','SRI LANKA','VIETNAM') then do;
                loc_asia=1; token_group='ASIA';
            end;
            else if tok='JAPAN' then do;
                loc_japan=1; token_group='ASIA';
            end;
            else if tok in ('MIDDLE EAST','MIDEAST') then do;
                loc_middeast=1; token_group='ME'; token_broad=1;
            end;
            else if tok in ('UNITED ARAB EMIRATES','UAE','SAUDI ARABIA',
                            'ISRAEL','JORDAN','KUWAIT','BAHRAIN','QATAR',
                            'OMAN','IRAQ','IRAN','LEBANON','SYRIA','YEMEN') then do;
                loc_middeast=1; token_group='ME';
            end;
            else if tok in ('EUROPE','WESTERN EUROPE','EASTERN EUROPE') then do;
                loc_europe=1; token_group='EU'; token_broad=1;
                broad_europe=1;
            end;
            else if tok in ('UNITED KINGDOM','GREAT BRITAIN','BRITAIN','UK','U.K.',
                            'ENGLAND','SCOTLAND','WALES') then do;
                loc_uk=1; token_canon='UK'; token_group='EU';
            end;
            else if tok='FRANCE' then do; loc_france=1; token_group='EU'; end;
            else if tok='GERMANY' then do; loc_germany=1; token_group='EU'; end;
            else if tok in ('ITALY','SPAIN','PORTUGAL','NETHERLANDS','BELGIUM',
                            'SWITZERLAND','SWEDEN','NORWAY','DENMARK','FINLAND',
                            'IRELAND','AUSTRIA','GREECE','POLAND','RUSSIA',
                            'CZECH REPUBLIC','LUXEMBOURG','HUNGARY','ROMANIA',
                            'TURKEY','ICELAND') then do;
                loc_europe=1; token_group='EU';
            end;
            else if tok in ('OCEANIA','PACIFIC') then do;
                loc_oceania=1; token_group='OC'; token_broad=1;
            end;
            else if tok in ('AUSTRALIA','NEW ZEALAND') then do;
                loc_oceania=1; token_group='OC';
            end;
            else if tok in ('SOUTH AMERICA','SAMERICA') then do;
                loc_samerica=1; token_group='SA'; token_broad=1;
            end;
            else if tok in ('BRAZIL','ARGENTINA','CHILE','COLOMBIA','VENEZUELA',
                            'PERU','ECUADOR','URUGUAY','BOLIVIA','PARAGUAY') then do;
                loc_samerica=1; token_group='SA';
            end;
            else if tok='CANADA' then do; loc_canada=1; token_group='NA'; end;
            else if tok='MEXICO' then do; loc_mexico=1; token_group='NA'; end;
            else if tok='NORTH AMERICA' then do;
                token_group='NA'; token_broad=1; broad_namerica=1;
                row_unknown=1;
            end;
            else if tok in ('OTHER FOREIGN','OTHER COUNTRIES','OTHER REGIONS',
                            'REST OF WORLD','REST OF THE WORLD','WORLDWIDE',
                            'INTERNATIONAL','FOREIGN','OTHER') then do;
                token_aggregate=1; row_aggregate=1; row_unknown=1;
            end;
            else if tok in ('DOMESTIC','UNITED STATES','USA','U.S.A.') then do;
                row_unknown=1; loc_bad=1;
            end;
            else do;
                row_unknown=1; token_unknown=1;
            end;
            output work.segtokens;
        end;
    end;
    if broad_europe=1 and (loc_uk=0 or loc_france=0 or loc_germany=0) then row_scope_gap=1;
    if broad_asia=1 and loc_japan=0 then row_scope_gap=1;
    if broad_namerica=1 and (loc_canada=0 or loc_mexico=0) then row_scope_gap=1;
    if gcode=3 and (missing(curcds) or upcase(strip(curcds)) ne 'USD') then loc_bad=1;
    output work.segnorm;
run;

proc sql;
    create table work.component_overlap_pairs as
    select distinct a.gvkey, a.datadate,
           a.segment_row_id as row_a, b.segment_row_id as row_b
    from work.segtokens as a
    inner join work.segtokens as b
      on a.gvkey=b.gvkey and a.datadate=b.datadate and
         a.segment_row_id lt b.segment_row_id
    where a.token_canon=b.token_canon or
          (not missing(a.token_group) and a.token_group=b.token_group and
           (a.token_broad=1 or b.token_broad=1)) or
          a.token_aggregate=1 or b.token_aggregate=1;

    create table work.component_overlap as
    select gvkey, datadate, count(*) as overlap_pairs
    from work.component_overlap_pairs
    group by gvkey, datadate;

    create table work.latest_sid_audit as
    select gvkey, datadate, stype, sid, count(*) as latest_rows,
           count(distinct geotp) as type_values,
           count(distinct curcds) as currency_values,
           count(distinct srcdate) as source_dates,
           count(distinct snms) as name_values
    from work.seglatest
    group by gvkey, datadate, stype, sid;

    create table work.component_sid_audit as
    select gvkey, datadate, count(*) as component_rows,
           count(distinct sid) as component_distinct_sids,
           sum(missing(sid)) as component_missing_sid_n,
           sum(missing(srcdate)) as component_missing_srcdate_n
    from work.segnorm
    where gcode=3
    group by gvkey, datadate;
quit;

title "Latest-source component SID, vintage, and hierarchy-overlap audit";
proc sql;
    select count(*) as component_report_n,
           sum(component_rows ne component_distinct_sids) as bad_component_sid_report_n,
           sum(component_missing_srcdate_n gt 0) as missing_vintage_report_n
    from work.component_sid_audit;
    select count(*) as latest_sid_group_n,
           sum(latest_rows gt 1) as duplicate_latest_sid_n,
           sum(type_values gt 1) as latest_sid_type_change_n,
           sum(currency_values gt 1) as latest_sid_currency_change_n,
           sum(source_dates gt 1) as latest_sid_date_change_n
    from work.latest_sid_audit;
    select count(*) as overlap_report_n,
           sum(overlap_pairs) as overlap_segment_pair_n
    from work.component_overlap;
quit;

proc sql;
    create table work.component_names_all as
    select name_up as snms length=256, count(*) as n,
           min(datadate) as min_data format=date9.,
           max(datadate) as max_data format=date9.
    from work.segnorm
    where gcode=3
    group by name_up
    order by n desc, name_up;
quit;
proc sort data=work.component_names_all;
    by descending n snms;
run;
data work.component_names_ranked;
    set work.component_names_all;
    diagnostic_rank=_n_;
run;
data work.component_names_top;
    set work.component_names_ranked;
    if diagnostic_rank gt 120 then delete;
run;
title "Most frequent NonDomestic segment descriptions";
proc print data=work.component_names_top noobs;
run;

/* Aggregate at the firm-date level. A Total Foreign amount is used alone.
   Without it, observed NonDomestic IAS rows are summed only when their SIDs,
   USD currency, source dates, amounts, and token-level non-overlap audit
   support an unambiguous component sum. A domestic row is not required to
   sum foreign components; an explicit Domestic-only report is required for
   an asset zero. */
proc sql;
    create table work.segsum0 as
    select gvkey, datadate,
           count(*) as geo_rows,
           sum(case when gcode=1 then 1 else 0 end) as n_total,
           sum(case when gcode=2 then 1 else 0 end) as n_domestic,
           sum(case when gcode=3 then 1 else 0 end) as n_nondom,
           sum(case when missing(gcode) then 1 else 0 end) as n_unknown_type,
           max(case when gcode=1 then ias else . end) as foreign_total,
           max(case when gcode=1 and not missing(ias) and
                         upcase(strip(curcds))='USD' and not missing(sid) and
                         not missing(srcdate) then 1 else 0 end) as total_ok,
           sum(case when gcode=3 then ias else 0 end) as component_asset_sum,
           sum(case when gcode=3 and ias gt 0 then 1 else 0 end) as component_positive_n,
           sum(case when gcode=3 and missing(ias) then 1 else 0 end) as component_missing_n,
           sum(case when gcode=3 and
                         (missing(curcds) or upcase(strip(curcds)) ne 'USD')
                    then 1 else 0 end) as component_nonusd_n,
           sum(case when gcode=3 and missing(srcdate) then 1 else 0 end) as component_missing_srcdate_n,
           sum(case when gcode=3 and missing(sid) then 1 else 0 end) as component_missing_sid_n,
           sum(case when gcode=3 then row_unknown else 0 end) as component_unknown_n,
           sum(case when gcode=3 then row_aggregate else 0 end) as component_aggregate_n,
           max(case when gcode=3 then row_scope_gap else 0 end) as location_scope_gap,
           max(loc_africa) as loc_africa,
           max(loc_asia) as loc_asia,
           max(loc_japan) as loc_japan,
           max(loc_middeast) as loc_middeast,
           max(loc_europe) as loc_europe,
           max(loc_uk) as loc_uk,
           max(loc_france) as loc_france,
           max(loc_germany) as loc_germany,
           max(loc_oceania) as loc_oceania,
           max(loc_samerica) as loc_samerica,
           max(loc_canada) as loc_canada,
           max(loc_mexico) as loc_mexico,
           max(loc_bad) as loc_bad,
           max(case when gcode in (1,3) and ias gt 0 then 1 else 0 end) as foreign_positive,
           sum(case when gcode=1 and missing(srcdate) then 1 else 0 end) as total_missing_srcdate_n,
           sum(case when gcode=1 and missing(sid) then 1 else 0 end) as total_missing_sid_n,
           sum(case when gcode=2 and missing(srcdate) then 1 else 0 end) as domestic_missing_srcdate_n
    from work.segnorm
    group by gvkey, datadate;

    create table work.segsum as
    select a.*,
           coalesce(s.component_rows,0) as component_rows,
           coalesce(s.component_distinct_sids,0) as component_distinct_sids,
           coalesce(s.component_missing_srcdate_n,0) as component_sid_vintage_missing_n,
           coalesce(o.overlap_pairs,0) as component_overlap_pairs
    from work.segsum0 as a
    left join work.component_sid_audit as s
      on a.gvkey=s.gvkey and a.datadate=s.datadate
    left join work.component_overlap as o
      on a.gvkey=o.gvkey and a.datadate=o.datadate;
quit;

proc sort data=work.etrpool; by gvkey datadate; run;
proc sort data=work.segsum; by gvkey datadate; run;
data out.mnc_etr_regressions;
    merge work.etrpool(in=inpool) work.segsum;
    by gvkey datadate;
    if inpool;

    foreign_assets=.;
    asset_source=.;
    if n_total=1 and total_ok=1 and not missing(foreign_total) then do;
        foreign_assets=foreign_total;
        asset_source=1;
    end;
    else if n_total=0 and n_nondom gt 0 and
            n_unknown_type=0 and component_missing_n=0 and
            component_nonusd_n=0 and component_missing_srcdate_n=0 and
            domestic_missing_srcdate_n=0 and
            component_missing_sid_n=0 and
            component_rows=component_distinct_sids and
            component_overlap_pairs=0 and
            (n_nondom=1 or (component_unknown_n=0 and component_aggregate_n=0)) then do;
        foreign_assets=component_asset_sum;
        asset_source=2;
    end;
    else if n_total=0 and n_nondom=0 and n_domestic gt 0 and
            n_unknown_type=0 and geo_rows gt 0 and
            domestic_missing_srcdate_n=0 then do;
        foreign_assets=0;
        asset_source=3;
    end;
    if not missing(foreign_assets) and at gt 0 then foroper=foreign_assets/at;
    else foroper=.;
    foroper2=foroper*foroper;

    if not missing(pifo) and pifo gt 0 then mnc=1;
    else if not missing(foreign_assets) and foreign_assets gt 0 then mnc=1;
    else if not missing(pifo) and pifo le 0 and
            not missing(foreign_assets) and foreign_assets le 0 then mnc=0;
    else mnc=.;
    if not missing(mnc) then do;
        mncsize=mnc*size;
        mncpti=mnc*pti;
    end;
    else do;
        mncsize=.; mncpti=.;
    end;

    geo_reported=(geo_rows gt 0);
    geo_unclassified=0;
    if component_unknown_n gt 0 or component_aggregate_n gt 0 or
       location_scope_gap=1 or n_unknown_type gt 0 then geo_unclassified=1;
    geo_aggregate_only=0;
    if n_total gt 0 and n_nondom=0 and foreign_total gt 0 then geo_aggregate_only=1;
    if component_aggregate_n gt 0 then geo_aggregate_only=1;
    if geo_aggregate_only=1 then geo_unclassified=1;

    loc_ready=0;
    if n_unknown_type=0 and loc_bad=0 then do;
        if n_nondom gt 0 and component_unknown_n=0 and
           component_aggregate_n=0 and location_scope_gap=0 and
           component_missing_srcdate_n=0 then loc_ready=1;
        else if n_total=1 and n_nondom=0 and total_ok=1 and
                not missing(foreign_total) and foreign_total=0 then loc_ready=1;
        else if n_total=0 and n_nondom=0 and n_domestic gt 0 and
                geo_rows gt 0 and domestic_missing_srcdate_n=0 then loc_ready=1;
    end;
    if n_total gt 0 and n_nondom gt 0 and foreign_total le 0 then loc_ready=0;
    geo_absence_observed=loc_ready;

    if loc_ready=1 then do;
        africa=loc_africa; asia=loc_asia; japan=loc_japan;
        middeast=loc_middeast; europe=loc_europe; uk=loc_uk;
        france=loc_france; germany=loc_germany; oceania=loc_oceania;
        samerica=loc_samerica; canada=loc_canada; mexico=loc_mexico;
    end;
    else do;
        africa=.; asia=.; japan=.; middeast=.; europe=.; uk=.;
        france=.; germany=.; oceania=.; samerica=.; canada=.; mexico=. ;
    end;

    indus1=0; indus2=0; indus3=0; indus4=0; indus5=0; indus6=0;
    if not missing(sich) then do;
        if 0 le sich and sich lt 2000 then indus1=1;
        else if 2000 le sich and sich lt 3000 then indus2=1;
        else if 3000 le sich and sich lt 4000 then indus3=1;
        else if 4000 le sich and sich lt 5000 then indus4=1;
        else if 5000 le sich and sich lt 6000 then indus5=1;
        else if 6000 le sich and sich le 8000 then indus6=1;
        else if sich le 0 then do;
            indus1=.; indus2=.; indus3=.; indus4=.; indus5=.; indus6=.;
        end;
    end;
    yr1991=(fyear=1991); yr1992=(fyear=1992); yr1993=(fyear=1993);
    yr1994=(fyear=1994); yr1995=(fyear=1995); yr1996=(fyear=1996);
    yr1997=(fyear=1997);

    table4=0;
    if not missing(sich) and not missing(size) and not missing(pti) and
       not missing(wwetr) and not missing(foroper) and not missing(mnc) and
       not missing(africa) and not missing(asia) and not missing(japan) and
       not missing(middeast) and not missing(europe) and not missing(uk) and
       not missing(france) and not missing(germany) and not missing(oceania) and
       not missing(samerica) and not missing(canada) and not missing(mexico) and
       not missing(indus1) then table4=1;

    label wwetr='Worldwide current ETR';
    label size='ln(1 + net sales, USD millions)';
    label pti='ln(1 + pretax income, USD millions)';
    label foroper='Foreign assets / total assets';
    label foreign_assets='Foreign assets (USD millions)';
    label asset_source='Foreign asset construction source';
    label mnc='Multinational indicator';
    label datadate='Fiscal year-end date';
run;

title "Segment code, source-date, and currency attrition";
proc freq data=out.mnc_etr_regressions;
    tables fyear*table4 fyear*mnc fyear*loc_ready / missing;
run;
title "Table 4 flag and unresolved geography diagnostics";
proc means data=out.mnc_etr_regressions n nmiss mean std p1 p25 p50 p75 p99 min max;
    var wwetr size pti foreign_assets foroper foroper2 mnc africa asia japan
        middeast europe uk france germany oceania samerica canada mexico;
run;
proc sql;
    select count(*) as etr_pool_n,
           sum(table4) as table4_complete_n,
           sum(missing(sich)) as missing_sic_pool_n,
           sum(missing(foroper)) as missing_foroper_n,
           sum(missing(mnc)) as missing_mnc_n,
           sum(missing(loc_ready) or loc_ready=0) as location_unavailable_n,
           sum(foroper gt 1) as foroper_above_one_n,
           sum(geo_reported=0) as no_geographic_report_n,
           sum(geo_unclassified=1) as unclassified_geography_n,
           sum(geo_aggregate_only=1) as aggregate_only_geography_n,
           sum(geo_absence_observed=1) as observed_location_absence_n,
           sum(asset_source=1) as total_foreign_asset_rows_n,
           sum(asset_source=2) as summed_component_asset_rows_n,
           sum(asset_source=3) as domestic_zero_asset_rows_n
    from out.mnc_etr_regressions;
quit;

title;
