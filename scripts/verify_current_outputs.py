#!/usr/bin/env python3
"""Verify relocated publications, accepted datasets and existing native results.

Does not open external source datasets, launch SAS/Stata, or alter accepted runs.
"""
import importlib.util
import json
import sys
from collections import Counter
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
import project_layout as layout


def read(path):return json.loads(layout.resolve_path(path).read_text())
def rows(path):return [json.loads(l) for l in layout.resolve_path(path).read_text().splitlines() if l.strip()]


def main():
    manifest=layout.manifest(ROOT)
    archive=ROOT/manifest['archive_root']
    plan=json.loads((archive/'plan.json').read_text())
    baseline={x['path']:x for x in plan['inventory']}
    publications={}
    for name,expected in manifest['publications'].items():
        p=layout.resolve_path('output/'+name)
        assert layout.sha(p)==expected['sha256'],name
        publications[name]=len(rows(p))
    models=rows(layout.active_path('models'))
    previous=rows('output/model_results.v2.jsonl')
    assert [layout.legacy_model(r) for r in models]==previous,'schema-3 lossless comparison'
    for r in models:
        p=layout.active_path('model_records')/(r['paper_id']+'.json')
        assert read(p)==r
        assert layout.resolve_path(r['paper_text_file']).is_file()
    feasibility=rows(layout.active_path('feasibility'))
    for r in feasibility:
        assert read(layout.active_path('feasibility_records')/(r['paper_id']+'.json'))==r
    spec=importlib.util.spec_from_file_location('current_reproduction_helper',ROOT/'scripts/reproduction_runs.py')
    helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
    hashes={}
    def sha(path):
        path=layout.resolve_path(path)
        if path not in hashes:hashes[path]=layout.sha(path)
        return hashes[path]
    executed=blocked=table_outputs=dataset_outputs=0
    native_tables=set();known_review_differences=[]
    for item in plan['selected']:
        p=ROOT/item['target']
        assert helper.validate(p)['valid'],str(p)
        accepted=read(p.parent/'accepted.json');outcome=read(p/'outcome.json')
        assert sha(p/'outcome.json')==accepted['outcome_sha256']
        assert layout.resolve_path(accepted['path'])==p
        work=read(p/'work_item.json');sub=read(p/'submission.json');state=read(p/'runtime/latest.json')
        nb=read(p/'stata.ipynb');cells={c['id']:c for c in nb['cells'] if c['cell_type']=='code'}
        for name,expected in state['sas']['outputs'].items():
            assert sha(p/name)==expected,(p,name,'dataset hash')
            dataset_outputs+=1
        data_hashes={s['dta_file']:sha(p/s['dta_file']) for s in sub['samples']}
        for fit in outcome['fits']:
            if fit['execution_status']!='executed':blocked+=1;continue
            executed+=1
            cell=state['cells'][fit['cell_id']]
            assert cell['ok'] and helper.cell_log_valid(cell),(p,fit['cell_id'],'native log')
            code=helper.source(cells[fit['cell_id']])
            original=layout.executed_cell_source(p,fit['cell_id'],code)
            assert helper.digest([original,data_hashes])==cell['signature'],(p,fit['cell_id'],'executed signature')
            for ext in ['md','csv','rtf','tex']:
                name=fit['table_basename']+'.'+ext
                assert sha(p/name)==cell['outputs'][name],(p,name,'table hash')
                native_tables.add(str(p/name));table_outputs+=1
        for name,expected in outcome['files'].items():
            before=baseline[item['source']+'/'+name]['sha256']
            if name=='stata.ipynb':
                proof=next((x for x in manifest['notebook_relocations'] if ROOT/x['current']==p/name),None)
                if proof:
                    assert sha(p/name)==proof['current_sha256']
                    assert sha(ROOT/proof['original'])==before
                    continue
            assert sha(p/name)==before,(p,name,'unexplained post-move change')
            if before!=expected:known_review_differences.append([item['paper_id'],name])
        print(json.dumps({'verified_paper':item['paper_id'],'executed':outcome['executed_scopes'],'scopes':outcome['total_scopes']}),flush=True)
    assert len(plan['selected'])==47 and executed==235 and blocked==4
    consistency=read(layout.active_path('reproductions')/'comparison/model_consistency_summary.json')
    assert consistency['counts']==manifest['consistency']
    result=dict(valid=True,publications=publications,model_schema='3.0',lossless_model_roundtrips=len(models),
                accepted_papers=len(plan['selected']),executed_scopes=executed,blocked_scopes=blocked,
                dataset_hashes_verified=dataset_outputs,unique_native_table_files_verified=len(native_tables),
                native_table_references_verified=table_outputs,consistency=consistency['counts'],
                preexisting_documentation_hash_differences=known_review_differences,
                notebook_path_only_relocations=len(manifest['notebook_relocations']),
                sas_stata_jobs_run=0)
    (archive/'current_validation.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':main()
