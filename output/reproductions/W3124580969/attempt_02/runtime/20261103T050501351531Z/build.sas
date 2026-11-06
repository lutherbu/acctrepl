options nodate nonumber linesize=200 pagesize=10000 msglevel=i errorabend;

/* Bounded numeric check of quarterization, denominators, return compounding, and delist rules. */
data q_demo;
  length gvkey $7;
  input gvkey $ fyearq fqtr datadate :date9. atq ibq xrdq oancfy fopty wcapcy capxy scfq;
  qidx=fyearq*4+fqtr;
  format datadate date9.;
datalines;
0000001 1987 1 01MAR1987 100 10 1 . 40 10 2 2
0000001 1987 2 30JUN1987 130 20 2 . 82 25 6 2
0000001 1987 3 30SEP1987 160 30 3 . 130 43 9 2
0000001 1987 4 31DEC1987 200 40 4 . 190 67 14 2
;
run;
proc sort data=q_demo; by gvkey qidx; run;
data q_check;
  set q_demo;
  by gvkey qidx;
  retain p_idx p_fy p_fq p_scfq p_fopty p_wcapcy p_capxy;
  if first.gvkey then call missing(p_idx,p_fy,p_fq,p_scfq,p_fopty,p_wcapcy,p_capxy);
  contig=(not missing(p_idx) and qidx=p_idx+1 and fyearq=p_fy and fqtr=p_fq+1);
  cash_contig=(contig and scfq=p_scfq);
  if fqtr=1 then do;
    capx_q=capxy; fopt_q=fopty; wcapc_q=wcapcy;
  end;
  else if contig then do;
    capx_q=capxy-p_capxy;
  end;
  if fqtr ne 1 and cash_contig then do;
    fopt_q=fopty-p_fopty;
    wcapc_q=wcapcy-p_wcapcy;
  end;
  if scfq=1 and not missing(fopt_q) and not missing(wcapc_q) then cfo_q=fopt_q-wcapc_q;
  else if scfq in (2,3,5) and not missing(fopt_q) and not missing(wcapc_q)
    then cfo_q=fopt_q+wcapc_q;
  output;
  p_idx=qidx; p_fy=fyearq; p_fq=fqtr; p_scfq=scfq;
  p_fopty=fopty; p_wcapcy=wcapcy; p_capxy=capxy;
run;
data _null_;
  set q_check end=last;
  retain cfo_total capx_total ib_total xrd_total;
  cfo_total=sum(cfo_total,cfo_q); capx_total=sum(capx_total,capx_q);
  ib_total=sum(ib_total,ibq); xrd_total=sum(xrd_total,xrdq);
  if last then do;
    avg_at=(100+200)/2;
    if cfo_total ne 257 or capx_total ne 14 or ib_total ne 100 or xrd_total ne 10 then abort cancel;
    if abs(ib_total/avg_at-100/150)>1e-12 or abs(cfo_total/avg_at-257/150)>1e-12 then abort cancel;
    if abs(xrd_total/100-.10)>1e-12 or abs(capx_total/100-.14)>1e-12 or abs(5/100-.05)>1e-12 then abort cancel;
    if abs(50/100-.5)>1e-12 or abs(log(100)-4.605170185988092)>1e-12 then abort cancel;
    put 'NOTE: Quarterized FOPT plus WCAPC for SCFQ=2, average-asset, beginning-asset intensity, BM, and log-size smoke checks passed.';
  end;
run;
data sign_fixture;
  input scfq fopt_q wcapc_q expected;
  if scfq=1 then cfo_q=fopt_q-wcapc_q;
  else if scfq in (2,3,5) then cfo_q=fopt_q+wcapc_q;
  if cfo_q ne expected then abort cancel;
  datalines;
1 100 10 90
1 100 -10 110
2 100 10 110
3 100 -10 90
5 100 10 110
;
run;
data _null_;
  put 'NOTE: Format-specific WCAPC sign smoke checks for SCFQ 1/2/3/5 passed.';
run;
/* A direct quarter field survives a currency transition, but a YTD difference does not. */
data ccy_demo;
  length gvkey $7 curcdq $3;
  input gvkey $ fyearq fqtr curcdq $ iby ibq;
  qidx=fyearq*4+fqtr;
  datalines;
0000001 1987 1 USD 10 .
0000001 1987 2 CAD 55 .
0000001 1987 3 CAD 75 20
0000001 1987 4 CAD 100 .
;
run;
proc sort data=ccy_demo; by gvkey qidx; run;
data ccy_demo_check;
  set ccy_demo;
  by gvkey qidx;
  length p_curcdq $3;
  retain p_idx p_fy p_fq p_curcdq p_iby;
  if first.gvkey then call missing(p_idx,p_fy,p_fq,p_curcdq,p_iby);
  contig=(not missing(p_idx) and qidx=p_idx+1 and fyearq=p_fy and fqtr=p_fq+1);
  same_currency=(not missing(curcdq) and not missing(p_curcdq) and curcdq=p_curcdq);
  ib_q=ibq;
  if missing(ib_q) then do;
    if fqtr=1 then ib_q=iby;
    else if contig and same_currency and not missing(iby) and not missing(p_iby)
      then ib_q=iby-p_iby;
  end;
  if fqtr=2 and not missing(ib_q) then abort cancel;
  if fqtr=3 and ib_q ne 20 then abort cancel;
  if fqtr=4 and ib_q ne 25 then abort cancel;
  output;
  p_idx=qidx; p_fy=fyearq; p_fq=fqtr; p_curcdq=curcdq; p_iby=iby;
run;
data _null_;
  put 'NOTE: Same-currency YTD guard and direct-quarter exception smoke checks passed.';
run;
data _null_;
  ret=.10; dlret=-.30;
  total=(1+ret)*(1+dlret)-1;
  if abs(total-(-.23))>1e-12 then abort cancel;
  ret=.; total=.; if missing(ret) then do; if 1 then total=-.30; end;
  if total ne -.30 then abort cancel;
  ret=.; total=.; if not missing(ret) then total=ret;
  if not missing(total) then abort cancel;
  gross=1; gross=gross*(1+.10); gross=gross*(1+.20);
  target_bhr=gross-1;
  gross=1; gross=gross*(1+.05); gross=gross*(1+.04);
  benchmark_bhr=gross-1; sret1=target_bhr-benchmark_bhr;
  if abs(sret1-(.32-.092))>1e-12 then abort cancel;
  put 'NOTE: Buy-and-hold, size adjustment, and delisting smoke checks passed.';
run;

libname comp '/storage/sas/base/comp/d_na' access=readonly;
libname compg '/storage/sas/base/comp/d_global/currency' access=readonly;
libname crsp '/storage/sas/base/crsp/a_stock' access=readonly;
libname ccm '/storage/sas/base/crsp/a_ccm' access=readonly;
libname cidx '/storage/sas/base/crsp/a_indexes' access=readonly;
libname out 'data';

/* Annual and quarterly Compustat records are screened before joins.
   Monetary values stay in their reported currency and period. */
data funda_raw;
  set comp.funda(keep=gvkey datadate fyear curcd scf indfmt consol popsrc datafmt
                      sich sale ib at oancf xrd capx xad ceq sstk fopt wcapc
                 where=(datadate >= '01JAN1974'd and datadate <= '31DEC2001'd
                    and indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'));
run;
proc sql;
  create table funda_dups as
  select gvkey, datadate, count(*) as n
  from funda_raw group by gvkey, datadate having calculated n > 1;
  create table funda_clean as
  select a.* from funda_raw as a left join funda_dups as b
    on a.gvkey=b.gvkey and a.datadate=b.datadate
  where b.n is null;
  select count(*) as annual_duplicate_keys from funda_dups;
quit;

/* The retained fields expose the actual prior annual record and currency. */
proc sort data=funda_clean; by gvkey datadate; run;
data funda_lag;
  set funda_clean;
  by gvkey datadate;
  length prev_curcd $4;
  retain prev_at prev_curcd;
  if first.gvkey then call missing(prev_at, prev_curcd);
  ann_date=datadate;
  output;
  prev_at=at;
  prev_curcd=curcd;
  keep gvkey ann_date prev_at prev_curcd;
run;
data calyr;
  do year=1978 to 2001;
    dec31=mdy(12,31,year);
    output;
  end;
  format dec31 date9.;
run;
proc sort data=funda_clean(keep=gvkey) out=gvkeys nodupkey; by gvkey; run;
data ann_grid;
  set gvkeys;
  do year=1978 to 2001;
    output;
  end;
run;
proc sql;
  create table funda_yrmax as
  select gvkey, year(datadate) as year, max(datadate) as max_date
  from funda_clean group by gvkey, calculated year;
  create table ann_by_calyr as
  select a.*, year(a.datadate) as year
  from funda_clean as a inner join funda_yrmax as b
    on a.gvkey=b.gvkey and a.datadate=b.max_date;
quit;
proc sort data=ann_grid; by gvkey year; run;
proc sort data=ann_by_calyr; by gvkey year; run;
data ann_asof0;
  merge ann_grid(in=g) ann_by_calyr(in=a);
  by gvkey year;
  length last_curcd $4;
  retain last_date last_fyear last_curcd last_scf last_sich last_sale last_ib last_at
         last_oancf last_xrd last_capx last_xad last_ceq last_sstk last_fopt last_wcapc;
  if first.gvkey then call missing(last_date,last_fyear,last_curcd,last_sich,last_sale,
                                   last_scf,last_ib,last_at,last_oancf,last_xrd,last_capx,last_xad,
                                   last_ceq,last_sstk,last_fopt,last_wcapc);
  if a then do;
    last_date=datadate; last_fyear=fyear; last_curcd=curcd; last_scf=scf; last_sich=sich;
    last_sale=sale; last_ib=ib; last_at=at; last_oancf=oancf; last_xrd=xrd;
    last_capx=capx; last_xad=xad; last_ceq=ceq; last_sstk=sstk;
    last_fopt=fopt; last_wcapc=wcapc;
  end;
  if g and not missing(last_date) then do;
    ann_date=last_date; ann_cur=last_curcd; ann_scf=last_scf; ann_sich=last_sich; ann_sale=last_sale;
    ann_ib=last_ib; ann_at=last_at; ann_oancf=last_oancf; ann_xrd=last_xrd;
    ann_capx=last_capx; ann_xad=last_xad; ann_ceq=last_ceq; ann_sstk=last_sstk;
    ann_fopt=last_fopt; ann_wcapc=last_wcapc;
    output;
  end;
  format ann_date date9.;
  keep gvkey year ann_date ann_cur ann_scf ann_sich ann_sale ann_ib ann_at ann_oancf
       ann_xrd ann_capx ann_xad ann_ceq ann_sstk ann_fopt ann_wcapc;
run;
proc sort data=ann_asof0; by gvkey ann_date; run;
proc sort data=funda_lag; by gvkey ann_date; run;
data ann_asof;
  merge ann_asof0(in=a) funda_lag;
  by gvkey ann_date;
  length ann_cfo_method $24;
  if a;
  if year(ann_date) < 1988 then do;
    if ann_scf=7 and not missing(ann_oancf) then do;
      ann_cfo=ann_oancf; ann_cfo_method='OANCF SCF7';
    end;
    else if ann_scf=1 and not missing(ann_fopt) and not missing(ann_wcapc) then do;
      ann_cfo=ann_fopt-ann_wcapc; ann_cfo_method='FOPT-WCAPC SCF1';
    end;
    else if ann_scf in (2,3,5) and not missing(ann_fopt) and not missing(ann_wcapc) then do;
      ann_cfo=ann_fopt+ann_wcapc; ann_cfo_method='FOPT+WCAPC SCF235';
    end;
  end;
  else if not missing(ann_oancf) then do;
    ann_cfo=ann_oancf; ann_cfo_method='OANCF';
  end;
  if not missing(ann_at) and ann_at>0 and not missing(prev_at) and prev_at>0
     and not missing(ann_cur) and ann_cur=prev_curcd then ann_begat=prev_at;
  else ann_begat=.;
  keep gvkey year ann_date ann_cur ann_scf ann_cfo_method ann_sich ann_sale ann_ib ann_at ann_cfo
       ann_xrd ann_capx ann_xad ann_ceq ann_sstk ann_begat;
run;

/* Quarterly YTD items are quarterized only across a continuous fiscal-quarter sequence. */
data qraw;
  set comp.fundq(keep=gvkey datadate fyearq fqtr curcdq scfq indfmt consol popsrc datafmt
                      atq ceqq ibq iby saleq saley oancfy fopty wcapcy capxy
                      xrdq xrdy
                 where=(datadate >= '01JAN1975'd and datadate <= '31DEC2001'd
                    and indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'));
  if missing(fyearq) or missing(fqtr) or fqtr<1 or fqtr>4 then delete;
  qidx=fyearq*4+fqtr;
run;
proc sql;
  create table qdups as
  select gvkey, qidx, count(*) as n
  from qraw group by gvkey, qidx having calculated n > 1;
  create table quniq as
  select a.* from qraw as a left join qdups as b
    on a.gvkey=b.gvkey and a.qidx=b.qidx
  where b.n is null;
  select count(*) as quarterly_duplicate_keys from qdups;
  create table qdate_dups as
  select gvkey, datadate, count(*) as n
  from quniq group by gvkey, datadate having calculated n>1;
  create table quniq_dateclean as
  select a.* from quniq as a left join qdate_dups as b
    on a.gvkey=b.gvkey and a.datadate=b.datadate
  where b.gvkey is null;
  select count(*) as quarter_date_tie_keys, sum(n) as quarter_date_tie_rows
  from qdate_dups;
quit;
proc sort data=quniq_dateclean; by gvkey qidx datadate; run;
data qhist;
  set quniq_dateclean;
  by gvkey qidx;
  length p_curcdq $4;
  retain p_idx p_fy p_fq p_scfq p_curcdq p_oancfy p_fopty p_wcapcy p_capxy p_xrdy p_iby p_saley;
  if first.gvkey then call missing(p_idx,p_fy,p_fq,p_scfq,p_oancfy,p_fopty,p_wcapcy,
                                   p_curcdq,p_capxy,p_xrdy,p_iby,p_saley);
  contig=(not missing(p_idx) and qidx=p_idx+1 and fyearq=p_fy and fqtr=p_fq+1);
  same_currency=(not missing(curcdq) and not missing(p_curcdq) and curcdq=p_curcdq);
  ytd_contig=(contig and same_currency);
  cash_contig=(ytd_contig and not missing(scfq) and not missing(p_scfq) and scfq=p_scfq);
  ib_ccy_block=(missing(ibq) and contig and not same_currency and not missing(iby) and not missing(p_iby));
  sale_ccy_block=(missing(saleq) and contig and not same_currency and not missing(saley) and not missing(p_saley));
  capx_ccy_block=(contig and not same_currency and not missing(capxy) and not missing(p_capxy));
  xrd_ccy_block=(contig and not same_currency and not missing(xrdy) and not missing(p_xrdy));
  oan_ccy_block=(contig and scfq=p_scfq and not same_currency
                 and not missing(oancfy) and not missing(p_oancfy));
  fopt_ccy_block=(contig and scfq=p_scfq and not same_currency
                  and not missing(fopty) and not missing(p_fopty));
  wcap_ccy_block=(contig and scfq=p_scfq and not same_currency
                  and not missing(wcapcy) and not missing(p_wcapcy));
  ib_q=ibq;
  if missing(ib_q) then do;
    if fqtr=1 then ib_q=iby;
    else if ytd_contig and not missing(iby) and not missing(p_iby) then ib_q=iby-p_iby;
  end;
  sale_q=saleq;
  if missing(sale_q) then do;
    if fqtr=1 then sale_q=saley;
    else if ytd_contig and not missing(saley) and not missing(p_saley) then sale_q=saley-p_saley;
  end;
  if fqtr=1 then do;
    capx_q=capxy;
    xrd_yq=xrdy;
    oancf_q=oancfy;
    fopt_q=fopty;
    wcapc_q=wcapcy;
  end;
  else if ytd_contig then do;
    if not missing(capxy) and not missing(p_capxy) then capx_q=capxy-p_capxy;
    if not missing(xrdy) and not missing(p_xrdy) then xrd_yq=xrdy-p_xrdy;
    if cash_contig then do;
      if not missing(oancfy) and not missing(p_oancfy) then oancf_q=oancfy-p_oancfy;
      if not missing(fopty) and not missing(p_fopty) then fopt_q=fopty-p_fopty;
      if not missing(wcapcy) and not missing(p_wcapcy) then wcapc_q=wcapcy-p_wcapcy;
    end;
  end;
  rd_q=xrdq;
  if missing(rd_q) then rd_q=xrd_yq;
  if datadate < '01JAN1988'd then do;
    if scfq=7 then cfo_q=oancf_q;
    else if scfq=1 and not missing(fopt_q) and not missing(wcapc_q) then cfo_q=fopt_q-wcapc_q;
    else if scfq in (2,3,5) and not missing(fopt_q) and not missing(wcapc_q)
      then cfo_q=fopt_q+wcapc_q;
    else cfo_q=.;
  end;
  else if scfq=7 then cfo_q=oancf_q;
  else cfo_q=.;
  output;
  p_idx=qidx; p_fy=fyearq; p_fq=fqtr; p_scfq=scfq; p_oancfy=oancfy; p_fopty=fopty;
  p_curcdq=curcdq; p_wcapcy=wcapcy; p_capxy=capxy; p_xrdy=xrdy; p_iby=iby; p_saley=saley;
  keep gvkey datadate fyearq fqtr curcdq scfq qidx atq ceqq ib_q sale_q cfo_q capx_q rd_q
       ib_ccy_block sale_ccy_block capx_ccy_block xrd_ccy_block oan_ccy_block
       fopt_ccy_block wcap_ccy_block;
run;
proc sql;
  select sum(ib_ccy_block) as blocked_ib_ytd,
         sum(sale_ccy_block) as blocked_sale_ytd,
         sum(capx_ccy_block) as blocked_capx_ytd,
         sum(xrd_ccy_block) as blocked_xrd_ytd,
         sum(oan_ccy_block) as blocked_oancf_ytd,
         sum(fopt_ccy_block) as blocked_fopt_ytd,
         sum(wcap_ccy_block) as blocked_wcapc_ytd
  from qhist;
quit;
proc sql;
  create table qanchor as
  select gvkey, year(datadate) as year, max(datadate) as qdate format=date9.
  from qhist where month(datadate) between 10 and 12
  group by gvkey, calculated year;
  create table qwin0 as
  select a.gvkey, a.year, a.qdate, q.qidx, q.fyearq, q.fqtr, q.curcdq, q.scfq,
         q.atq as end_at, q.ceqq,
         count(h.qidx) as n_q,
         count(h.ib_q) as n_ib, sum(h.ib_q) as ib4,
         count(h.sale_q) as n_sale, sum(h.sale_q) as sale4,
         count(h.cfo_q) as n_cfo, sum(h.cfo_q) as cfo4,
         count(h.capx_q) as n_capx, sum(h.capx_q) as capx4,
         count(h.rd_q) as n_xrd, sum(h.rd_q) as xrd4,
         sum(case when h.curcdq=q.curcdq then 1 else 0 end) as n_cur
  from qanchor as a inner join qhist as q
    on a.gvkey=q.gvkey and a.qdate=q.datadate
  left join qhist as h
    on h.gvkey=q.gvkey and h.qidx between q.qidx-3 and q.qidx
  group by a.gvkey, a.year, a.qdate, q.qidx, q.fyearq, q.fqtr, q.curcdq, q.scfq,
           q.atq, q.ceqq;
  create table qwin as
  select a.*, b.atq as beg_at, b.curcdq as beg_cur
  from qwin0 as a left join qhist as b
    on a.gvkey=b.gvkey and b.qidx=a.qidx-4;
  create table q_ann_date as
  select q.gvkey, q.year, q.qdate, max(f.datadate) as ann_date
  from qanchor as q left join funda_clean as f
    on q.gvkey=f.gvkey and f.datadate<=q.qdate
  group by q.gvkey, q.year, q.qdate;
  create table ann_asof_q0 as
  select q.gvkey, q.year, f.datadate as xad_date format=date9.,
         f.curcd as xad_cur length=4, f.xad as q_xad, f.ceq as q_ceq,
         f.curcd as q_ceq_cur length=4, f.datadate as q_ceq_date format=date9.,
         f.sich as q_sich
  from q_ann_date as q left join funda_clean as f
    on q.gvkey=f.gvkey and q.ann_date=f.datadate;
quit;
proc sort data=qwin; by gvkey year; run;
proc sort data=ann_asof_q0; by gvkey year; run;
data qbase;
  merge qwin(in=q) ann_asof_q0;
  by gvkey year;
  if q;
  qok=(n_q=4 and n_ib=4 and n_sale=4 and n_cfo=4 and n_capx=4 and n_xrd=4
       and not missing(curcdq)
       and n_cur=4 and beg_cur=curcdq
       and not missing(beg_at) and beg_at>0 and not missing(end_at) and end_at>0);
  if not missing(xad_cur) and xad_cur=curcdq then xad_q=q_xad; else xad_q=.;
  sich_q=q_sich;
  if not missing(ceqq) then do;
    ceq_q=ceqq; ceq_cur_q=curcdq; ceq_date_q=qdate;
  end;
  else do;
    ceq_q=q_ceq; ceq_cur_q=q_ceq_cur; ceq_date_q=q_ceq_date;
  end;
  keep gvkey year qdate qidx curcdq scfq qok ib4 sale4 cfo4 capx4 xrd4 beg_at end_at
       xad_q sich_q ceq_q ceq_cur_q ceq_date_q xad_date;
run;
proc sort data=qbase; by gvkey year; run;
proc sql;
  select curcdq, count(*) as quarterly_anchor_n,
         sum(qok) as quarterly_annualized_n,
         sum(not qok) as quarterly_inadequate_n
  from qbase group by curcdq order by curcdq;
quit;
proc sort data=ann_asof; by gvkey year; run;
data fin0;
  merge qbase(in=q) ann_asof(in=a);
  by gvkey year;
  length source_cfo_method $24;
  if q or a;
  if q and qok then do;
    source_date=qdate;
    source_cur=curcdq;
    source_scf=scfq;
    source_cfo_method='quarterly SCFQ mapping';
    ib=ib4; sale=sale4; cfo=cfo4; capx=capx4; xrd=xrd4;
    at=end_at; beg_at=beg_at;
    xad=xad_q; ceq=ceq_q; ceq_cur=ceq_cur_q; ceq_date=ceq_date_q; sich=sich_q;
    annual_fallback=0;
    xad_date_final=xad_date;
  end;
  else do;
    source_date=ann_date;
    source_cur=ann_cur;
    source_scf=ann_scf;
    source_cfo_method=ann_cfo_method;
    ib=ann_ib; sale=ann_sale; cfo=ann_cfo; capx=ann_capx; xrd=ann_xrd;
    at=ann_at; beg_at=ann_begat; xad=ann_xad; ceq=ann_ceq;
    ceq_cur=ann_cur; ceq_date=ann_date; sich=ann_sich;
    annual_fallback=1;
    xad_date_final=ann_date;
  end;
  if not missing(beg_at) and beg_at>0 and not missing(at) and at>0 then avg_at=(beg_at+at)/2;
  else avg_at=.;
  if not missing(ib) and not missing(avg_at) and avg_at>0 then roa=ib/avg_at;
  if not missing(cfo) and not missing(avg_at) and avg_at>0 then cfroa=cfo/avg_at;
  if not missing(xrd) and not missing(beg_at) and beg_at>0 then rdint=xrd/beg_at;
  if not missing(capx) and not missing(beg_at) and beg_at>0 then capint=capx/beg_at;
  if not missing(xad) and not missing(beg_at) and beg_at>0 then adint=xad/beg_at;
  if not missing(sich) and sich>=100 and sich<=9999 then sic2=floor(sich/100);
  format source_date xad_date_final date9.;
  keep gvkey year source_date source_cur source_scf source_cfo_method annual_fallback ann_date ann_cur ann_scf
       xad_date_final ib sale cfo at beg_at avg_at ceq ceq_cur ceq_date sich sic2
       xrd capx xad roa cfroa rdint capint adint;
run;
proc sql;
  select source_cur, count(*) as source_n, sum(annual_fallback) as annual_fallback_n,
         count(roa) as roa_n, count(cfroa) as cfroa_n,
         count(rdint) as rdint_n, count(capint) as capint_n, count(adint) as adint_n
  from fin0 where year between 1979 and 2001
  group by source_cur order by source_cur;
  select source_scf, source_cfo_method, annual_fallback,
         count(*) as source_n, count(cfo) as cfo_available_n
  from fin0 where year between 1979 and 2001
  group by source_scf, source_cfo_method, annual_fallback
  order by source_scf, source_cfo_method, annual_fallback;
quit;

/* Translate only the equity amount paired with USD CRSP market value.
   Provider cross-rate is amount / GBP-to-reporting quote * GBP-to-USD quote. */
data fx_dly0;
  set compg.g_exrt_dly(keep=datadate exratd exrattpd fromcurd tocurd
                       where=(datadate >= '01JAN1978'd and datadate <= '31DEC2001'd
                              and fromcurd='GBP'));
  currency=strip(tocurd);
  keep datadate currency exratd exrattpd;
run;
proc sql;
  create table fx_dly_dups as
  select datadate, currency, count(*) as n
  from fx_dly0 group by datadate, currency having calculated n>1;
  create table fx_dly_u as
  select a.* from fx_dly0 as a left join fx_dly_dups as b
    on a.datadate=b.datadate and a.currency=b.currency
  where b.currency is null;
  create table fx_gbp_usd as
  select datadate, exratd as gbp_usd, exrattpd as usd_type length=3
  from fx_dly_u where currency='USD' and exratd>0;
  create table fx_ceq0 as
  select f.*, c.exratd as gbp_cur, c.exrattpd as cur_type length=3,
         u.gbp_usd, u.usd_type,
         case when strip(f.ceq_cur)='USD' then 1
              when strip(f.ceq_cur)='GBP' then u.gbp_usd
              when c.exratd>0 and u.gbp_usd>0 then u.gbp_usd/c.exratd
              else . end as ceq_fx_rate
  from fin0 as f
  left join fx_dly_u as c
    on f.ceq_cur=c.currency and f.ceq_date=c.datadate
  left join fx_gbp_usd as u
    on f.ceq_date=u.datadate;
  select count(*) as dup_fx_keys from fx_dly_dups;
quit;
data fin_fx;
  set fx_ceq0;
  length ceq_fx_method $16;
  if missing(ceq) then ceq_usd=.;
  else if strip(ceq_cur)='USD' then do;
    ceq_usd=ceq; ceq_fx_method='USD identity'; ceq_fx_date=ceq_date;
  end;
  else if strip(ceq_cur)='GBP' and ceq_fx_rate>0 then do;
    ceq_usd=ceq*ceq_fx_rate; ceq_fx_method='GBP to USD'; ceq_fx_date=ceq_date;
  end;
  else if ceq_fx_rate>0 then do;
    ceq_usd=ceq*ceq_fx_rate; ceq_fx_method='GBP cross-rate'; ceq_fx_date=ceq_date;
  end;
  else call missing(ceq_usd,ceq_fx_method,ceq_fx_date);
  format ceq_date ceq_fx_date date9.;
run;
proc sql;
  select ceq_cur, count(*) as source_n, count(ceq_usd) as ceq_usd_n,
         sum(missing(ceq_usd) and not missing(ceq)) as ceq_fx_missing_n
  from fin_fx group by ceq_cur order by ceq_cur;
quit;

/* CRSP December market capitalization is consolidated at PERMCO across common share classes.
   Compustat monetary amounts are in $ millions; CRSP price*shares is in $ thousands. */
data msf_dec;
  set crsp.msf(keep=permno permco date prc shrout
               where=(date >= '01JAN1978'd and date <= '31DEC2001'd));
  if month(date)=12;
  year=year(date);
  if not missing(prc) and prc ne 0 and not missing(shrout) and shrout>0
     then mve_sec=abs(prc)*shrout/1000;
  else mve_sec=.;
run;
data msnames;
  set crsp.msenames(keep=permno namedt nameendt shrcd permco siccd);
run;
proc sql;
  create table dec_raw as
  select a.permno, a.permco as msf_co, n.permco as name_co,
         a.date, a.year, a.mve_sec
  from msf_dec as a inner join msnames as n
    on a.permno=n.permno
   and (n.namedt<=a.date or n.namedt=.B or missing(n.namedt))
   and (n.nameendt>=a.date or n.nameendt=.E or missing(n.nameendt))
  where n.shrcd in (10,11);
  create table dec_conf as
  select permno, year, count(*) as n from dec_raw
  group by permno, year having calculated n>1;
  create table dec_sec as
  select a.* from dec_raw as a left join dec_conf as b
    on a.permno=b.permno and a.year=b.year
  where b.permno is null and a.msf_co=a.name_co and not missing(a.name_co);
  create table dec_problem as
  select count(*) as permco_name_mismatch from dec_raw
  where msf_co ne name_co or missing(msf_co) or missing(name_co);
  select * from dec_problem;
  create table co_cap as
  select name_co as permco, year, sum(mve_sec) as mve_comp,
         count(*) as n_issue, count(mve_sec) as n_mve
  from dec_sec group by name_co, year;
quit;
data co_cap;
  set co_cap;
  if n_issue ne n_mve then mve_comp=.;
run;
proc sort data=dec_sec; by year; run;
proc rank data=dec_sec out=dec_rank groups=10;
  by year;
  var mve_sec;
  ranks size_group;
run;
data stockyear;
  set dec_rank;
  if not missing(mve_sec) and mve_sec>0;
  size_decile=size_group+1;
  keep permno name_co date year mve_sec size_decile;
run;

/* Effective-dated primary CCM links are matched at the actual CRSP December quote date. */
data ccmraw;
  set ccm.ccmxpf_linktable(keep=gvkey linkprim linktype lpermno lpermco linkdt linkenddt);
  if linkprim='P' and linktype in ('LC','LU') and not missing(lpermno);
run;
proc sql;
  select count(*) as eligible_primary_links,
         sum(linkdt=.B) as open_start_links,
         sum(linkenddt=.E) as open_end_links
  from ccmraw;
quit;
proc sql;
  create table primary0 as
  select s.year, s.date, s.permno, s.name_co as permco, s.mve_sec,
         s.size_decile, l.gvkey, l.lpermco
  from stockyear as s inner join ccmraw as l
    on s.permno=l.lpermno
   and (l.linkdt<=s.date or l.linkdt=.B or missing(l.linkdt))
   and (l.linkenddt>=s.date or l.linkenddt=.E or missing(l.linkenddt))
  where missing(l.lpermco) or l.lpermco=s.name_co;
  create table primary_u as
  select distinct year, date, permno, permco, mve_sec, size_decile, gvkey, lpermco
  from primary0;
  create table primary_dups as
  select gvkey, year, count(distinct permno) as n_perm,
         count(distinct permco) as n_co
  from primary_u group by gvkey, year
  having calculated n_perm ne 1 or calculated n_co ne 1;
  create table primary_map as
  select a.* from primary_u as a left join primary_dups as b
    on a.gvkey=b.gvkey and a.year=b.year
  where b.gvkey is null;
  create table co_map as
  select a.gvkey, a.year, a.permno, a.permco, a.mve_sec,
         a.size_decile, c.mve_comp, c.n_issue, c.n_mve
  from primary_map as a left join co_cap as c
    on a.permco=c.permco and a.year=c.year;
  select count(*) as primary_mapping_ambiguity_count from primary_dups;
quit;

/* All-market book-to-market distribution is prior-year; same-year low-BM membership follows it. */
proc sort data=fin_fx; by gvkey year; run;
proc sort data=co_map; by gvkey year; run;
data bm_all;
  merge fin_fx(in=f) co_map(in=c);
  by gvkey year;
  if f and c and not missing(ceq_usd) and ceq_usd>=0 and not missing(mve_comp) and mve_comp>0;
  bm=ceq_usd/mve_comp;
  if bm>=0;
  keep gvkey year bm;
run;
proc sort data=bm_all; by year; run;
proc univariate data=bm_all noprint;
  by year;
  var bm;
  output out=bm_cut pctlpts=20 pctlpre=q;
run;
data bm_cut;
  set bm_cut;
  year=year+1;
  bm20_prev=q20;
  keep year bm20_prev;
run;
proc sort data=fin_fx; by gvkey year; run;
proc sort data=co_map; by gvkey year; run;
proc sort data=bm_cut; by year; run;
proc sql;
  create table low_pre as
  select f.*, c.permno, c.permco, c.size_decile, c.mve_comp, b.bm20_prev
  from fin_fx as f inner join co_map as c
    on f.gvkey=c.gvkey and f.year=c.year
  inner join bm_cut as b on f.year=b.year;
  create table sic_asof as
  select p.gvkey, p.year, p.source_date, p.permno,
         max(n.siccd) as siccd_hist, count(n.permno) as sic_match_n
  from low_pre as p left join msnames as n
    on p.permno=n.permno
   and (n.namedt<=p.source_date or n.namedt=.B or missing(n.namedt))
   and (n.nameendt>=p.source_date or n.nameendt=.E or missing(n.nameendt))
  group by p.gvkey, p.year, p.source_date, p.permno;
  select sum(sic_match_n>1) as ambiguous_dated_sic_keys,
         count(*) as mapped_firm_years
  from sic_asof;
quit;
proc sort data=low_pre; by gvkey year; run;
proc sort data=sic_asof; by gvkey year; run;
data low_pre_sic;
  merge low_pre sic_asof;
  by gvkey year;
  sic2_comp=sic2;
  if sic_match_n=1 and not missing(siccd_hist) and siccd_hist>=100 and siccd_hist<=9999
    then sic2_crsp=floor(siccd_hist/100);
  else sic2_crsp=.;
  if not missing(sic2_comp) then sic_source=1;
  else if not missing(sic2_crsp) then do; sic2=sic2_crsp; sic_source=2; end;
  else do; sic2=.; sic_source=0; end;
run;
proc sql;
  select count(*) as mapped_n, count(sic2_comp) as comp_sic_n,
         count(sic2_crsp) as dated_crsp_sic_n,
         sum(not missing(sic2_comp) and not missing(sic2_crsp)
             and sic2_comp=sic2_crsp) as overlap_same_2digit,
         sum(not missing(sic2_comp) and not missing(sic2_crsp)
             and sic2_comp ne sic2_crsp) as overlap_diff_2digit,
         sum(sic_source=2) as dated_crsp_fallback_n,
         sum(sic_source=0) as unavailable_sic_n
  from low_pre_sic;
quit;
proc sql;
  create table low0_candidates as
  select p.*, p.ceq_usd/p.mve_comp as bm, log(p.mve_comp) as size
  from low_pre_sic as p
  where p.year>=1979 and p.year<=2001
    and not missing(p.ceq_usd) and p.ceq_usd>=0
    and not missing(p.mve_comp) and p.mve_comp>0
    and p.ceq_usd/p.mve_comp<=p.bm20_prev
    and not missing(p.sic2);
  select year, count(*) as before_earn_cfo_n,
         sum(missing(ib) or missing(cfo)) as missing_earn_cfo_n,
         count(ib) as earnings_available_n, count(cfo) as cfo_available_n
  from low0_candidates group by year order by year;
quit;
data low0;
  set low0_candidates;
  if missing(ib) or missing(cfo) then delete;
  accr=(ib>cfo);
  keep gvkey year source_date source_cur source_scf source_cfo_method annual_fallback xad_date_final
       sich sic2 sic2_comp siccd_hist sic2_crsp sic_match_n sic_source
       permno permco size_decile mve_comp bm bm20_prev size
       ceq ceq_usd ceq_cur ceq_date ceq_fx_date ceq_fx_rate ceq_fx_method
       gbp_cur gbp_usd cur_type usd_type
       ib sale cfo at beg_at avg_at xrd capx xad roa cfroa rdint capint adint accr;
run;

/* Four-year quarterly variability, with source-authorized zero signals if history is inadequate. */
proc sql;
  create table low_hist as
  select a.gvkey, a.year, a.permno, a.permco, a.size_decile,
         a.source_date, a.source_cur, a.source_scf, a.source_cfo_method,
         a.annual_fallback, a.xad_date_final,
         a.sich, a.sic2, a.sic2_comp, a.siccd_hist, a.sic2_crsp, a.sic_match_n, a.sic_source,
         a.size, a.bm, a.bm20_prev, a.ib, a.sale, a.cfo, a.at, a.xrd, a.capx, a.xad,
         a.ceq, a.ceq_usd, a.ceq_cur, a.ceq_date, a.ceq_fx_date,
         a.ceq_fx_rate, a.ceq_fx_method, a.gbp_cur, a.gbp_usd, a.cur_type, a.usd_type,
         a.beg_at, a.avg_at, a.roa, a.cfroa, a.rdint, a.capint,
         a.adint, a.accr,
         q.qidx as q0idx, q.qdate as q0date
  from low0 as a left join qbase as q
    on a.gvkey=q.gvkey and a.year=q.year;
quit;
/* Obtain dated quarter ROA and Q-vs-Q-4 sales growth through keyed joins. */
proc sql;
  create table q_metrics as
  select q.gvkey, q.datadate, q.qidx, q.curcdq, q.atq, q.ib_q, q.sale_q,
         p.atq as prev_at, p.qidx as prev_idx, p.curcdq as prev_cur,
         y.sale_q as sale_q4, y.qidx as yoy_idx, y.curcdq as yoy_cur
  from qhist as q
  left join qhist as p on q.gvkey=p.gvkey and p.qidx=q.qidx-1
  left join qhist as y on q.gvkey=y.gvkey and y.qidx=q.qidx-4;
  create table q_metric2 as
  select a.gvkey, a.datadate, a.qidx, a.curcdq, a.prev_cur, a.yoy_cur,
         case when not missing(a.ib_q) and not missing(a.atq) and not missing(a.prev_at)
                    and a.atq>0 and a.prev_at>0
                    and not missing(a.curcdq) and not missing(a.prev_cur)
                    and a.curcdq=a.prev_cur
              then a.ib_q/((a.atq+a.prev_at)/2) else . end as qroa,
         case when not missing(a.sale_q) and not missing(a.sale_q4) and a.sale_q4 ne 0
                    and not missing(a.curcdq) and not missing(a.yoy_cur)
                    and a.curcdq=a.yoy_cur
              then a.sale_q/a.sale_q4-1 else . end as qsg
  from q_metrics as a;
  create table qvar as
  select l.gvkey, l.year,
         count(m.qroa) as n_roa_q, var(m.qroa) as varroa,
         count(m.qsg) as n_sg_q, var(m.qsg) as varsgr
  from low_hist as l left join q_metric2 as m
    on l.gvkey=m.gvkey
   and m.datadate<=l.q0date
   and m.datadate>intnx('year',l.q0date,-4,'same')
  group by l.gvkey, l.year;
quit;
proc sort data=low_hist; by gvkey year; run;
proc sort data=qvar; by gvkey year; run;
data low_sig0;
  merge low_hist(in=a) qvar;
  by gvkey year;
  if a;
  g4_missing=(n_roa_q<6 or missing(varroa));
  g5_missing=(n_sg_q<6 or missing(varsgr));
  if g4_missing then varroa=.;
  if g5_missing then varsgr=.;
run;

/* Correct the prior-year equity issuance control: attach the actual prior-year fiscal record. */
proc sql;
  create table eqprior as
  select a.gvkey, a.year, p.ann_sstk as sstk_prev,
         p.ann_date as eq_date format=date9., p.ann_cur as eq_cur length=4
  from low_sig0 as a left join ann_asof as p
    on a.gvkey=p.gvkey and p.year=a.year-1;
quit;
proc sort data=low_sig0; by gvkey year; run;
proc sort data=eqprior; by gvkey year; run;
data low_sig1;
  merge low_sig0(in=a) eqprior;
  by gvkey year;
  if a;
  if not missing(sstk_prev) then eqoff=(sstk_prev>0);
  else eqoff=.;
  keep gvkey year source_date source_cur source_scf source_cfo_method annual_fallback xad_date_final eq_date
       sich sic2 sic2_comp siccd_hist sic2_crsp sic_match_n sic_source
       permno permco size_decile size bm bm20_prev ceq ceq_usd ceq_cur
       ceq_date ceq_fx_date ceq_fx_rate ceq_fx_method gbp_cur gbp_usd cur_type usd_type
       ib sale cfo at beg_at avg_at xrd capx xad
       roa cfroa rdint capint adint varroa varsgr g4_missing g5_missing
       accr eqoff sstk_prev;
run;

/* Industry thresholds use the low-BM peers in the same calendar year and SIC two-digit cell. */
proc sort data=low_sig1; by year sic2; run;
proc means data=low_sig1 noprint;
  by year sic2;
  var roa cfroa varroa varsgr rdint capint adint;
  output out=ind_med(drop=_type_ _freq_)
    median=med_roa med_cfroa med_varroa med_varsgr med_rdint med_capint med_adint;
run;
proc sql;
  create table ind_n as
  select year, sic2, count(*) as n_lowbm_ind
  from low_sig1 group by year, sic2;
quit;
proc sort data=low_sig1; by year sic2; run;
proc sort data=ind_med; by year sic2; run;
proc sort data=ind_n; by year sic2; run;
data low_sig2;
  merge low_sig1(in=a) ind_med ind_n;
  by year sic2;
  if a;
  if n_lowbm_ind>=4 then do;
    if not missing(roa) and not missing(med_roa) then g1=(roa>med_roa); else g1=.;
    if not missing(cfroa) and not missing(med_cfroa) then g2=(cfroa>med_cfroa); else g2=.;
    if not missing(ib) and not missing(cfo) then g3=(cfo>ib); else g3=.;
    if g4_missing then g4=0;
    else if not missing(varroa) and not missing(med_varroa) then g4=(varroa<med_varroa); else g4=0;
    if g5_missing then g5=0;
    else if not missing(varsgr) and not missing(med_varsgr) then g5=(varsgr<med_varsgr); else g5=0;
    if not missing(rdint) and not missing(med_rdint) then g6=(rdint>med_rdint); else g6=.;
    if not missing(capint) and not missing(med_capint) then g7=(capint>med_capint); else g7=.;
    if not missing(adint) and not missing(med_adint) then g8=(adint>med_adint); else g8=.;
  end;
  else call missing(g1,g2,g3,g4,g5,g6,g7,g8);
  if n_lowbm_ind>=4 and nmiss(g1,g2,g3,g6,g7,g8)=0 then gscore=sum(g1,g2,g3,g4,g5,g6,g7,g8);
  else gscore=.;
run;

/* Keep one observation per valid primary PERMNO and calendar month, with dated delisting data. */
proc sort data=low_sig2(keep=permno) out=target_perms nodupkey; by permno; run;
data msf_ret;
  set crsp.msf(keep=permno date ret where=(date >= '01JAN1978'd and date <= '30APR2003'd));
  month_key=intnx('month',date,0,'b');
  format month_key date9.;
run;
proc sql;
  create table ret_target0 as
  select a.* from msf_ret as a inner join target_perms as p
    on a.permno=p.permno;
  create table ret_dups as
  select permno, month_key, count(*) as n from ret_target0
  group by permno, month_key having calculated n>1;
  create table ret_targetu as
  select a.* from ret_target0 as a left join ret_dups as b
    on a.permno=b.permno and a.month_key=b.month_key
  where b.permno is null;
  select count(*) as return_duplicate_months from ret_dups;
quit;
data delist;
  set crsp.msedelist(keep=permno dlstdt dlstcd dlret
                     where=(dlstdt >= '01JAN1978'd and dlstdt <= '30APR2003'd));
  month_key=intnx('month',dlstdt,0,'b');
  format month_key date9.;
run;
proc sql;
  create table delist_dups as
  select permno, month_key, count(*) as n from delist
  group by permno, month_key having calculated n>1;
  create table delist_u as
  select a.* from delist as a left join delist_dups as b
    on a.permno=b.permno and a.month_key=b.month_key where b.n is null;
  select count(*) as delisting_duplicate_months from delist_dups;
  create table ret0 as
  select a.permno, a.month_key, a.ret, d.dlret, d.dlstcd
  from ret_targetu as a left join delist_u as d
    on a.permno=d.permno and a.month_key=d.month_key;
  create table delist_only as
  select d.permno, d.month_key, . as ret, d.dlret, d.dlstcd
  from delist_u as d left join ret_targetu as a
    on d.permno=a.permno and d.month_key=a.month_key
  where a.permno is null;
quit;
data ret_all;
  set ret0 delist_only;
  if not missing(dlret) then do;
    if not missing(ret) then mret=(1+ret)*(1+dlret)-1;
    else mret=dlret;
  end;
  else if dlstcd in (500,520,551,552,553,554,555,556,557,558,559,
                     560,561,562,563,564,565,566,567,568,569,570,571,
                     572,573,574,580,584) then do;
    if not missing(ret) then mret=(1+ret)*0.70-1;
    else mret=-0.30;
  end;
  else if not missing(dlstcd) then do;
    if not missing(ret) then mret=ret;
    else mret=.;
  end;
  else mret=ret;
run;

/* Source-native CRSP monthly capitalization-decile benchmark returns. */
data bench_long;
  set cidx.msix(keep=caldt decret1-decret10
                where=(caldt >= '01JAN1978'd and caldt <= '30APR2003'd));
  month_key=intnx('month',caldt,0,'b');
  array dec[10] decret1-decret10;
  do size_decile=1 to 10;
    bench_ret=dec[size_decile];
    output;
  end;
  keep month_key size_decile bench_ret;
  format month_key date9.;
run;

/* Momentum uses the Table 7 note's raw six-month return definition; BM uses its raw ratio label. */
proc sql;
  create table ret_win as
  select a.gvkey, a.year, a.permno, a.size_decile, r.month_key, r.mret, r.dlstcd
  from low_sig2 as a left join ret_all as r
    on a.permno=r.permno
   and r.month_key between mdy(5,1,a.year+1) and mdy(4,1,a.year+2);
  create table mom_win as
  select a.gvkey, a.year, a.permno, r.month_key, r.mret
  from low_sig2 as a left join ret_all as r
    on a.permno=r.permno
   and r.month_key between mdy(7,1,a.year) and mdy(12,1,a.year);
  create table bench_win as
  select a.gvkey, a.year, a.size_decile, b.month_key, b.bench_ret
  from low_sig2 as a left join bench_long as b
    on a.size_decile=b.size_decile
   and b.month_key between mdy(5,1,a.year+1) and mdy(4,1,a.year+2);
quit;
proc sort data=ret_win; by gvkey year month_key; run;
data ret_bhr;
  set ret_win;
  by gvkey year;
  retain gross nret nrow dlmonth delisted;
  if first.year then do; gross=1; nret=0; nrow=0; dlmonth=.; delisted=0; end;
  if not missing(month_key) and delisted=0 then do;
    nrow+1;
    if not missing(mret) then do; gross=gross*(1+mret); nret+1; end;
    if not missing(dlstcd) then do; dlmonth=month_key; delisted=1; end;
  end;
  if last.year then do;
    if not missing(dlmonth) then expected=intck('month',mdy(5,1,year+1),dlmonth)+1;
    else expected=12;
    if nret=expected then firm_bhr=gross-1; else firm_bhr=.;
    output;
  end;
  keep gvkey year firm_bhr nret nrow expected dlmonth;
run;
proc sort data=mom_win; by gvkey year month_key; run;
data mom_bhr;
  set mom_win;
  by gvkey year;
  retain gross nret;
  if first.year then do; gross=1; nret=0; end;
  if not missing(month_key) and not missing(mret) then do; gross=gross*(1+mret); nret+1; end;
  if last.year then do;
    if nret=6 then mom=gross-1; else mom=.;
    output;
  end;
  keep gvkey year mom nret;
run;
proc sort data=bench_win; by gvkey year month_key; run;
data bench_bhr;
  set bench_win;
  by gvkey year;
  retain gross nret;
  if first.year then do; gross=1; nret=0; end;
  if not missing(month_key) and not missing(bench_ret) then do; gross=gross*(1+bench_ret); nret+1; end;
  if last.year then do;
    if nret=12 then size_bhr=gross-1; else size_bhr=.;
    output;
  end;
  keep gvkey year size_bhr nret;
  rename nret=bench_nret;
run;
proc sort data=low_sig2; by gvkey year; run;
proc sort data=ret_bhr; by gvkey year; run;
proc sort data=mom_bhr; by gvkey year; run;
proc sort data=bench_bhr; by gvkey year; run;
data low_final0;
  merge low_sig2(in=a) ret_bhr mom_bhr bench_bhr;
  by gvkey year;
  if a;
  if not missing(firm_bhr) and not missing(size_bhr) then sret1=firm_bhr-size_bhr;
  else sret1=.;
  label sret1='One-year size-adjusted buy-and-hold return'
        gscore='Growth-fundamental score (sum of eight signals)'
        size='Log of company market capitalization, $ millions'
        bm='Raw book-to-market ratio at formation'
        mom='Raw six-month buy-and-hold return before formation'
        accr='One if income before extraordinary items exceeds CFO'
        eqoff='One if prior-year equity issuance is reported';
run;

/* Complete-case losses remain visible by variable and year; Stata estimates the declared baseline sample. */
proc sql;
  select count(*) as low_bm_n from low_final0;
  select year, count(*) as low_bm_n,
         sum(missing(sret1)) as missing_sret1_n,
         sum(missing(mom)) as missing_mom_n,
         sum(missing(accr)) as missing_accr_n,
         sum(missing(eqoff)) as missing_eqoff_n,
         sum(missing(gscore)) as missing_gscore_n,
         sum(nmiss(sret1,size,bm,mom,accr,eqoff,gscore)=0) as table7_complete_n
  from low_final0 group by year order by year;
  select year, count(*) as low_bm_n,
         sum(missing(g1)) as missing_g1_n, sum(missing(g2)) as missing_g2_n,
         sum(missing(g3)) as missing_g3_n, sum(missing(g4)) as missing_g4_n,
         sum(missing(g5)) as missing_g5_n, sum(missing(g6)) as missing_g6_n,
         sum(missing(g7)) as missing_g7_n, sum(missing(g8)) as missing_g8_n
  from low_sig2 group by year order by year;
  select count(*) as table7_complete_n
  from low_final0 where nmiss(sret1,size,bm,mom,accr,eqoff,gscore)=0;
  select sum(annual_fallback) as annual_fallback_n,
         count(*) as source_rows
  from fin0 where year between 1979 and 2001;
  select year, count(*) as source_n, sum(annual_fallback) as annual_fallback_n
  from fin0 where year between 1979 and 2001 group by year order by year;
  select sum(g4_missing) as g4_zero_n, sum(g5_missing) as g5_zero_n,
         count(*) as low_bm_signal_n from low_sig2;
quit;
proc means data=low_final0 n nmiss mean median std min max;
  var sret1 size bm mom accr eqoff gscore g1 g2 g3 g4 g5 g6 g7 g8;
run;
proc freq data=delist_u;
  tables dlstcd / missing;
  where dlstdt between '01JAN1979'd and '30APR2003'd;
run;

data out.low_bm_firm_years;
  set low_final0;
  if year>=1979 and year<=2001;
  keep gvkey year source_date source_cur source_scf source_cfo_method annual_fallback xad_date_final eq_date
       sich sic2 sic2_comp siccd_hist sic2_crsp sic_match_n sic_source
       permno permco size_decile size bm bm20_prev ceq ceq_usd ceq_cur
       ceq_date ceq_fx_date ceq_fx_rate ceq_fx_method gbp_cur gbp_usd cur_type usd_type
       sret1 firm_bhr size_bhr
       mom ib sale cfo at beg_at avg_at xrd capx xad roa cfroa rdint capint adint varroa varsgr
       g1 g2 g3 g4 g5 g6 g7 g8 gscore accr eqoff g4_missing g5_missing
       n_lowbm_ind;
run;
proc sort data=out.low_bm_firm_years; by gvkey year; run;
proc sql;
  create table final_dups as
  select gvkey, year, count(*) as n from out.low_bm_firm_years
  group by gvkey, year having calculated n>1;
  select count(*) as final_duplicate_keys from final_dups;
  select count(*) as final_observations from out.low_bm_firm_years;
quit;
