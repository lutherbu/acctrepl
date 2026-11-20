options errorabend validvarname=any;

/* Input workbook is private build material; do not include it in the deposit. */
proc import datafile="input/chen-et-al-dataset.xlsx"
    out=work.raw
    dbms=xlsx
    replace;
    sheet="dataset60_ID.JOAR-2014-074.R2";
    getnames=yes;
run;

/* Keep one record per supplied participant and only the analysis fields.
   The temporary row index replaces the workbook's participant code. */
data work.analysis;
    set work.raw;
    if missing(Subject) then delete;
    pid=_n_;
    decision_match=Match;
    link_ratio=LinkFixationRatio;
    nonlink_ratio=NonLinkFixationRatio;
    presentation=PresentationFormat;
    experience_years=Experience;
    gender01=Gender;
    keep pid decision_match link_ratio nonlink_ratio presentation experience_years gender01;
    label pid="Anonymized analysis row"
          decision_match="Decision consistent with SBU strategic achievement"
          link_ratio="Proportion of fixation time on linked measures"
          nonlink_ratio="Proportion of fixation time on nonlinked measures"
          presentation="Presentation format (1 benchmark, 2 narrative, 3 strategy map)"
          experience_years="Working experience in years"
          gender01="Gender (0 female, 1 male)";
run;

/* Aggregate-only input checks: record count, field coverage, treatment cells,
   and the supplied ratios' observed arithmetic. Do not print participant rows. */
proc sql;
    select count(*) as participant_rows,
           count(distinct Subject) as unique_subjects
    from work.raw
    where not missing(Subject);

    select sum(missing(decision_match)) as missing_match,
           sum(missing(link_ratio)) as missing_link_ratio,
           sum(missing(nonlink_ratio)) as missing_nonlink_ratio,
           sum(missing(presentation)) as missing_presentation,
           sum(missing(experience_years)) as missing_experience,
           sum(missing(gender01)) as missing_gender
    from work.analysis;
quit;

proc freq data=work.analysis;
    tables presentation gender01 decision_match / missing;
run;

data work.ratio_audit;
    set work.analysis;
    ratio_sum=link_ratio+nonlink_ratio;
    length ratio_status $12;
    if missing(ratio_sum) then ratio_status="missing";
    else if abs(ratio_sum-1)<1e-9 then ratio_status="sum_to_one";
    else if ratio_sum=0 then ratio_status="both_zero";
    else ratio_status="other";
run;

proc freq data=work.ratio_audit;
    tables ratio_status / missing;
run;

proc means data=work.analysis n mean std min p50 max maxdec=6;
    class presentation;
    var link_ratio nonlink_ratio experience_years;
run;

/* Native SAS export is the data handoff to Stata. The participant-level DTA
   stays in the private build directory and is excluded from publication. */
proc export data=work.analysis
    outfile="data/reg.dta"
    dbms=dta
    replace;
run;
