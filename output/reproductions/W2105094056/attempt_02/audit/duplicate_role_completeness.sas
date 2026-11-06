libname fund "/storage/sas/base/comp/d_na" access=readonly;

title "Bounded role-completeness audit for duplicate GVKEY/FYEAR records";
proc sql;
  create table work.dup_roles as
  select f.fyear, f.datadate format=date9., upcase(strip(f.curcd)) as curcd length=3,
         (not missing(f.gdwl)) as has_gdwl,
         (not missing(f.gdwlip)) as has_gdwlip,
         (not missing(f.spi)) as has_spi,
         (not missing(f.at)) as has_at,
         (not missing(f.oiadp)) as has_oiadp,
         (not missing(f.ceq)) as has_ceq,
         (not missing(f.prcc_f)) as has_prccf,
         (not missing(f.csho)) as has_csho
  from fund.funda as f
  where f.gvkey="066552"
    and f.fyear between 2008 and 2011
    and f.indfmt="INDL" and f.datafmt="STD"
    and f.consol="C" and f.popsrc="D"
  order by f.fyear, f.datadate;

  select fyear, datadate, curcd, has_gdwl, has_gdwlip, has_spi,
         has_at, has_oiadp, has_ceq, has_prccf, has_csho
  from work.dup_roles
  order by fyear, datadate;
quit;
title;
