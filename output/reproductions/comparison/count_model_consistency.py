#!/usr/bin/env python3
"""Apply explicit, reviewed qualitative consistency decisions to every fit.

No estimation, downloads, or changes to accepted reproductions. The 239 rows
are model/result-set scopes, not 239 independent papers or scientific tests.
This is a descriptive post-hoc classification, not statistical equivalence.
"""
import csv
import hashlib
import json
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
import sys
sys.path.insert(0, str(ROOT))
import project_layout as layout
Path = layout.path_class(ROOT)
ROOT = Path(str(ROOT))

# C: all assessed focal signs and 5% decisions agree.
# D: at least one assessed focal sign, 5% decision, or key comparison differs.
# U: no sufficient published focal coefficient/inference comparison.
# Blocked fits override these paper-specific rules below.
# Every paper is explicitly enumerated. Overrides use exact model/result IDs.
RULES = {
    'W3122547505': ('C', {}),
    'W3125677029': ('D', {}),
    'W3126118385': ('C', {'table5_model1_ar': 'D'}),
    'W2152596199': ('C', {'abs_da':'D', 'raw_da':'D'}),
    'W1990806291': ('D', {}),
    'W3122987060': ('C', {'aggregate_earnings_k6':'D'}),
    'W1997012386': ('C', {'conflict_conacc_1993_98':'D'}),
    'W3121570881': ('C', {}),
    'W3121890812': ('C', {}),
    'W1994228146': ('D', {}),
    'W3124907716': ('C', {'tacc_t3':'D','abaccmj_t3':'D','abaccfl_t1':'D','abaccfl_t3':'D'}),
    'W2028237122': ('C', {}),
    'W3124908438': ('D', {}),
    'W3125487088': ('U', {}),
    'W2067475882': ('C', {}),
    'W2321597487': ('C', {
        'b_cf_industry':'D', 'm_cf_pooled':'D', 't5_b_cf_pooled':'D',
        't5_b_jones_industry':'D', 't5_d_dd_pooled':'D',
        't5_d_cf_industry':'D', 't5_d_dd_industry':'D', 't5_d_jones_industry':'D',
    }),
    'W1987881672': ('C', {}),
    'W3126000559': ('D', {'icw_pp_ratio':'C'}),
    'W2065676679': ('C', {'panel_b_h3':'D'}),
    'W3124170598': ('U', {}),
    'W3124365414': ('C', {'abnormal_cfo_eq6':'D'}),
    'W3123227524': ('D', {}),
    'W2084956342': ('C', {}),
    'W3121620818': ('C', {}),
    'W3123284902': ('C', {}),
    'W3123899283': ('C', {}),
    'W3125741632': ('C', {'forward_k1':'D','forward_k2':'D','forward_k3':'D','historical_j4':'D'}),
    'W3123370480': ('D', {}),
    'W2015142764': ('C', {}),
    'W3124466116': ('D', {}),
    'W3125018794': ('D', {}),
    'W3125232597': ('D', {}),
    'W11897853': ('C', {}),
    'W3121262606': ('C', {}),
    'W1559083449': ('D', {}),
    'W3123423002': ('C', {}),
    'W2015391739': ('C', {}),
    'W3124580969': ('D', {}),
    'W3122432337': ('D', {}),
    'W2048409281': ('D', {'earnings_persistence_h2_1974':'C'}),
    'W3124301289': ('C', {}),
    'W2105094056': ('C', {'eq1_pre142_estimated':'D'}),
    'W3125558500': ('C', {}),
    'W3121345849': ('C', {'hvz_forecast_t_3':'D','ri_forecast':'D'}),
    'W2898309145': ('D', {}),
    'W3124763333': ('D', {}),
    'W1509613660': ('D', {}),
}

ADDITIONAL_EVIDENCE = {
    ('W2321597487','b_cf_industry'):
        'Table 3B industry CF slope is -0.17 (t=-8.42) in PDF p.13, versus +0.169 (p<.001) locally. CF is flagged research-interest in the extraction. The asymmetry interaction agrees, but the focal CF slope reverses.',
    ('W2321597487','m_cf_pooled'):
        'Table 4 pooled CF slope is -0.08 (t=-28.47) in PDF p.16, versus +0.011 (p=.001) locally. The market-return interaction agrees, but focal CF reverses.',
    ('W2321597487','t5_b_cf_pooled'):
        'Table 5B pooled CF slope is -0.04 (t=-13.22) in PDF p.18, versus +0.043 (p<.001) locally. The two asymmetry interactions agree, but focal CF reverses.',
    ('W2321597487','t5_b_jones_industry'):
        'Table 5B industry Jones change-CF interaction is +.05 (t=1.19) in PDF p.18, versus +.187 (p<.001) locally: gains significance.',
    ('W2321597487','t5_d_dd_pooled'):
        'Table 5D pooled DD change-CF interaction is +.01 (t=.65) in PDF p.20, versus +.048 (p=.001) locally: gains significance.',
    ('W2321597487','t5_d_cf_industry'):
        'Table 5D industry CF: DCF interaction t=1.06 and change-CF t=1.12 are nonsignificant in the source, but local p<.001/.003. Industry-adjusted interaction also reverses sign while nonsignificant in both.',
    ('W2321597487','t5_d_dd_industry'):
        'Table 5D industry DD: DCF interaction gains significance (source t=.93; local p<.001); industry-adjusted interaction reverses sign, nonsignificant in both.',
    ('W2321597487','t5_d_jones_industry'):
        'Table 5D industry Jones: change-CF interaction gains significance (source t=.58; local p=.039); industry-adjusted interaction reverses from -.15 (t=-.44) to +.208 (p<.001).',
}

TEST_NOTES = {
    'W1990806291': 'Shared system NAC pricing-equality test changes from source p<.001 to local p=.1624; both system equations receive D. ABNAC itself and the joint all-components rejection agree.',
    'W1994228146': 'Both focal coefficient signs/inference agree; GrLTNOA=ACC changes from source p=.11 to local p=.00001554.',
    'W2065676679': 'The h3 BC=LC contrast loses rejection (source t=2.3; local t=-.39), and the incremental source F=10.3 becomes local robust p=.064. Other horizons retain the 5% test decisions. A nonsignificant contrast sign change at h4 alone is not scored as a changed equality-test decision.',
    'W3125741632': 'The future k2-k1 g1 contrast loses source 5% significance and k3-k2 b1 gains it. Both endpoints of each failed contrast are marked D, covering all three future scopes. Historical j4 combined bad-news level gains significance. Historical contrasts differing only at 10% or in the direction of an unrejected equality difference do not fail the 5% decision rule.',
    'W3125018794': 'Both equations participate in the shared efficiency and naive-expectations restrictions; both decisions change at 5%, so both scopes receive D.',
    'W3122432337': 'The paper explicitly compares STREET with EPSOP. Their slope and adjusted-R2 ranking reverses in both tables; all four related scopes receive D. The paired slope/Vuong tests were not reproduced and are not treated as if separate coefficient tests supplied them.',
    'W3124763333': 'Backlog pricing equality loses rejection (source p<.001 versus local .9631), so both system equations receive D. The return-equation backlog coefficient also loses individual significance (local p=.541).',
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    fits=list(map(json.loads,(HERE/'fits.jsonl').open()))
    pub={d['paper_id']:d for d in map(json.loads,(Path(layout.active_path('models', ROOT))).open())}
    papers={d['paper_id']:d for d in map(json.loads,(HERE/'papers.jsonl').open())}
    assert set(RULES)=={f['paper_id'] for f in fits}
    rows=[]
    for pid,(default,overrides) in RULES.items():
        local=[f for f in fits if f['paper_id']==pid]
        allowed={f['model_id'] for f in local}|{f['result_set_id'] for f in local}
        assert set(overrides)<=allowed, (pid,set(overrides)-allowed)
        for f in local:
            mid,rid=f['model_id'],f['result_set_id']
            state=overrides.get(rid,overrides.get(mid,default))
            if f['execution_status']!='executed':state='B'
            model=next(m for m in pub[pid]['models'] if m['model_id']==mid)
            targets=[v['name'] for v in model['independent_variables'] if v.get('is_research_interest')]
            extra=ADDITIONAL_EVIDENCE.get((pid,mid),'')
            note=f['comparison']
            if pid=='W3126118385':
                extra='Compare stage increments versus the reference group: the source prints stage totals alongside contrast t-statistics. Do not compare a printed total with an incremental coefficient, or test the total against zero using that contrast t.'
            if pid=='W2065676679' and rid.startswith('panel_a'):
                extra='The published focal BTM slopes have t=-15.4/-8.2/-8.9/-7.5/-5.3 in horizon order. All native BTM slopes are negative with p<.001.'
            if pid=='W3121345849' and rid=='hvz_forecast_t_2':
                extra='Native DD p=.049: retains 5% significance. Intercept changes are excluded from this focal-predictor score.'
            status={'C':'consistent','D':'at_least_one_focal_discrepancy','U':'insufficient_published_target','B':'blocked'}[state]
            rows.append(dict(paper_id=pid,title=f['title'],journal=f['journal'],
                             model_id=mid,result_set_id=rid,consistency=status,
                             focal_predictors=targets,comparison=note,
                             additional_evidence=extra,key_comparison_rule=TEST_NOTES.get(pid,''),
                             review_path=f['review_path'],native_table_path=f['reproduced_table_path'],
                             source_extraction_path=f['source_extraction_path'],
                             comparability_limits=f['comparability_limits']))
    assert len(rows)==239
    assert len({(r['paper_id'],r['model_id'],r['result_set_id']) for r in rows})==239
    counts=Counter(r['consistency'] for r in rows)
    assert counts['blocked']==4 and counts['insufficient_published_target']==7
    assessable=counts['consistent']+counts['at_least_one_focal_discrepancy']
    model_groups=defaultdict(list)
    for r in rows:model_groups[(r['paper_id'],r['model_id'])].append(r)
    model_rows=[]
    for (pid,mid),rs in model_groups.items():
        c=Counter(r['consistency'] for r in rs)
        status=next(x for x in ['at_least_one_focal_discrepancy','blocked','insufficient_published_target','consistent'] if c[x])
        model_rows.append(dict(paper_id=pid,model_id=mid,status=status,scopes=len(rs),
                               consistent_scopes=c['consistent'],discrepant_scopes=c['at_least_one_focal_discrepancy'],
                               insufficient_scopes=c['insufficient_published_target'],blocked_scopes=c['blocked']))
    assert len(model_rows)==178
    mc=Counter(r['status'] for r in model_rows)
    paper_rows=[]
    for pid,p in papers.items():
        c=Counter(r['consistency'] for r in rows if r['paper_id']==pid)
        paper_rows.append(dict(paper_id=pid,title=p['title'],journal=p['journal'],**{k:c[k] for k in counts},total=sum(c.values())))
    summary=dict(generated_at=datetime.now(timezone.utc).isoformat(),
                 unit='one retained model/result-set (table column, horizon, or subgroup)',
                 total_scopes=len(rows),counts=dict(counts),assessable_scopes=assessable,
                 consistent_percent_all=100*counts['consistent']/len(rows),
                 consistent_percent_assessable=100*counts['consistent']/assessable,
                 distinct_baseline_model_counts=dict(mc),distinct_baseline_models=len(model_rows),
                 supporting_model_definitions_excluded=33,
                 criterion='All assessed research-interest coefficient signs and 5% significance decisions agree, and key published hypothesis tests/comparisons agree. Any focal discrepancy prevents C, even if most results agree.',
                 limitations=[
                     'This is a post-hoc descriptive review score. It is not a statistical equivalence test, causal explanation, or exact numerical replication rate.',
                     'Signs of nonsignificant focal coefficients still count under this strict literal-sign rule. Equality-test differences are scored on rejection decisions rather than the direction of an unrejected contrast.',
                     'Controls and ordinary intercepts are excluded. Source-supplied research tests/rankings can span scopes; a failed shared test marks its participating scopes, not multiple independent hypothesis failures.',
                     'Research-interest flags come from the existing extraction, with source-aware interpretation of displayed totals versus increments. Partial unreported information is not invented; scopes without an adequate focal coefficient/inference target are U.',
                     'Published inference conventions and source-checked reviews control. Where sidedness is unstated, the previous review uses conventional two-sided interpretation of reported t statistics; rounded and approximate inference limits remain.',
                     'Magnitude, R2, sample-size, and estimator fidelity are not pass criteria; all accepted implementations remain best_effort.',
                     'Scopes are correlated and unequally distributed by paper. Forty-eight scopes belong to one paper; do not treat this as a paper-weighted success rate.',
                 ],
                 inputs={'fits_sha256':sha(HERE/'fits.jsonl'),'source_extraction_sha256':sha(Path(layout.active_path('models', ROOT))),'script_sha256':sha(Path(__file__))})
    (HERE/'model_consistency_summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n')
    for name,data in [('model_consistency.jsonl',rows),('baseline_model_consistency.jsonl',model_rows)]:
        (HERE/name).write_text(''.join(json.dumps(r,ensure_ascii=False)+'\n' for r in data))
    for name,data in [('model_consistency.csv',rows),('model_consistency_by_paper.csv',paper_rows),('baseline_model_consistency.csv',model_rows)]:
        with (HERE/name).open('w',newline='') as f:
            w=csv.DictWriter(f,fieldnames=list(data[0]));w.writeheader()
            for r in data:
                w.writerow({k:json.dumps(v,ensure_ascii=False) if isinstance(v,list) else v for k,v in r.items()})
    lines=['# Model-level consistency count','',
           f"**{counts['consistent']} of {len(rows)} retained model/result-set scopes ({summary['consistent_percent_all']:.1f}%) are qualitatively consistent under the rule below.** Excluding blocked or insufficient-target cases, this is {counts['consistent']}/{assessable} ({summary['consistent_percent_assessable']:.1f}%).",'',
           '| Classification | Scopes |','|---|---:|',
           f"| Consistent focal findings | {counts['consistent']} |",
           f"| At least one focal discrepancy (including mixed results) | {counts['at_least_one_focal_discrepancy']} |",
           f"| Insufficient published target | {counts['insufficient_published_target']} |",
           f"| Numerically blocked | {counts['blocked']} |",'',
           summary['criterion'],'',
           'This is stricter than the previous broad paper-level summary. It does not assign a paper’s category to every model. A model with one agreeing and one disagreeing research effect is in the discrepancy group. Ordinary intercept/control changes do not fail a model. Magnitudes, sample counts and R2 can still differ substantially in a model counted consistent.', '',
           f"Collapsing columns/horizons to the original **178 baseline model definitions**, {mc['consistent']} have every retained scope consistent; {mc['at_least_one_focal_discrepancy']} contain a focal discrepancy; {mc['insufficient_published_target']} lack a sufficient target; {mc['blocked']} are blocked. The separate 33 supporting construction definitions are not added to the comparable-regression denominator.", '',
           '## Rules and boundary cases','']
    lines += ['- '+x for x in summary['limitations']]
    lines += ['',
              'The 7 insufficient-target scopes comprise six discretionary-accrual residual-generation models in W3124170598 (published residual distributions but no construction-coefficient targets), plus the conservatism model W3125487088 (reported focal point estimate but no comparable source inference).', '',
              'The 4 blocked scopes are the three signed auditor-tenure truncated regressions and deferred-tax Table 2 target 2. They are neither agreement nor disagreement.', '',
              'The 48-scope accrual-asymmetry paper was checked against its source tables and native output: 40 meet the rule and 8 have a focal discrepancy. Three CF-level sign reversals and two additional interaction-significance changes extend the earlier interaction-focused narrative; exact source pages and coefficients are recorded in the ledger.', '',
              '## All papers, counted by scope','',
              '| Paper | Consistent | Discrepancy | Insufficient | Blocked | Total |',
              '|---|---:|---:|---:|---:|---:|']
    for r in paper_rows:
        link=papers[r['paper_id']]['review_path']
        title=r['title'].replace('|','\\|')
        lines.append(f"| [{title}]({link}) | {r['consistent']} | {r['at_least_one_focal_discrepancy']} | {r['insufficient_published_target']} | {r['blocked']} | {r['total']} |")
    lines += ['', '## Reviewable records','',
              '- [239-scope CSV](model_consistency.csv) and [JSONL](model_consistency.jsonl): decision, focal predictors, reasons and evidence paths.',
              '- [178-definition CSV](baseline_model_consistency.csv): a definition is consistent only if all its retained scopes are consistent.',
              '- [Counts by paper](model_consistency_by_paper.csv) and [machine-readable summary](model_consistency_summary.json).',
              '- Rebuild with `python output/reproductions/comparison/count_model_consistency.py` from the project git root. Decisions and exceptions are explicitly enumerated in the script; no regressions are rerun.', '']
    (HERE/'model_consistency_summary.md').write_text('\n'.join(lines))
    print(json.dumps({k:v for k,v in summary.items() if k not in ['limitations','inputs']},ensure_ascii=False,indent=2))


if __name__=='__main__':
    main()
