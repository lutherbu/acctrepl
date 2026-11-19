from pathlib import Path
import sys

import pytest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
import extended_replication_runs as r


@pytest.mark.parametrize('end,n,expected', [('1992',5,'1997'),('2017-06',5,'2022-06'),
                                            ('2020-02-29',1,'2021-02-28'),('2019-03-31',3,'2022-03-31')])
def test_observation_clock(end,n,expected):
    assert r.extend(end,n) == expected


def test_fit_proof_requires_native_counts_and_same_stage(tmp_path):
    log=tmp_path/'runtime.log';log.write_text('  . display "EXT_SAMPLE fit 50 5 2019"\n')
    table=tmp_path/'table.csv';table.write_text('term,b\nx,1.2\n')
    scope={'scope_id':'A','cell':'a','worked':True}
    row=r.initial_row(scope,1)
    row.update(key='fit',status='extended_partial',reason='Coverage ends one year early.',source_evidence=['source SAS line 21'],
               sample_ids=['s'],count_unit='firm-year',original_begin='2000',original_end='2015',requested_end='2020',
               supported_end='2019',last_added='2019',original_n=50,added_n=5,
               native_log='runtime.log',artifacts=['table.csv'],comparison='Archived table reports 1.4 and extended table 1.2.')
    def proof():
        return {'a':({'runtime.log':r.sha(log)},{'table.csv':r.sha(table)})}
    with pytest.raises(ValueError,match='native log'):
        r.check_row(row,scope,{'s'},5,proof(),tmp_path,True)
    log.write_text('EXT_SAMPLE fit 50 5 2019\n')
    r.check_row(row,scope,{'s'},5,proof(),tmp_path,True)
    for field,value in [('status','extended_full'),('added_n',0),('last_added','2015'),('requested_end','2021')]:
        with pytest.raises(ValueError):
            r.check_row(dict(row,**{field:value}),scope,{'s'},5,proof(),tmp_path,True)
    with pytest.raises(ValueError,match='did not succeed'):
        r.check_row(row,dict(scope,cell='another'),{'s'},5,proof(),tmp_path,True)
    old=proof();table.write_text('tampered\n')
    with pytest.raises(ValueError,match='fresh hash'):
        r.check_row(row,scope,{'s'},5,old,tmp_path,True)


def test_notebook_runtime_output_is_excluded_from_code_hash(tmp_path):
    p=tmp_path/'stata.ipynb'
    cell={'id':'fit','cell_type':'code','source':['regress y x'],'outputs':[],'execution_count':None}
    r.write(p,{'cells':[cell]}); before=r.code_digest(p)
    cell.update(outputs=[{'text':'native stdout'}],execution_count=1);r.write(p,{'cells':[cell]})
    assert r.code_digest(p)==before
    assert b'native stdout' not in r.sanitized_notebook(p)
    cell['source']=['regress x y'];r.write(p,{'cells':[cell]})
    assert r.code_digest(p)!=before


def test_author_native_stage_uses_actual_runner_id_and_hashes(tmp_path,monkeypatch):
    table=tmp_path/'work'/'table.csv'
    table.parent.mkdir();table.write_text('term,estimate\nx,2\n')
    log=tmp_path/'stdout.bin';log.write_text('EXT_SAMPLE main 35 9 2017\n')
    state=tmp_path/'run.json'
    r.write(state,{'original_inputs_unchanged':True,'stages':[{
        'id':'table3','status':'succeeded','stdout':{'path':str(log),'sha256':r.sha(log)},
        'outputs':[{'path':str(table),'fresh':True,'after_sha256':r.sha(table)}]}]})
    r.write(tmp_path/'launch.json',{'code':{}})
    monkeypatch.setattr(r,'payloads',lambda *args:{})
    receipt={'state':'run.json','state_sha256':r.sha(state),'launch_sha256':r.sha(tmp_path/'launch.json'),
             'code_unchanged':True,'inputs_unchanged':True}
    proofs=r.native_proofs(tmp_path,{'route':'author'},receipt)
    assert proofs=={'table3':[{'stdout.bin':r.sha(log)},{'work/table.csv':r.sha(table)}]}
    log.write_text('changed after the run\n')
    with pytest.raises(ValueError,match='Native log changed'):
        r.native_proofs(tmp_path,{'route':'author'},receipt)


def test_shared_id_rejected_across_two_jobs(tmp_path,monkeypatch):
    monkeypatch.setattr(r,'BASE',tmp_path)
    for pid in ('W1','W2'):
        d=tmp_path/'years_5/pilot'/pid
        (d/'skill').mkdir(parents=True)
        r.write(d/'task.json',{'phase':'pilot','years':5,'paper_id':pid,'skill_files':{}})
        r.write(d/'identity.json',{'task_sha256':r.sha(d/'task.json'),'skill_files':{}})
    a,b=(tmp_path/'years_5/pilot'/pid for pid in ('W1','W2'))
    r.register(a,'thread_1',r.MODEL,'max')
    with pytest.raises(ValueError,match='already uses'):
        r.register(b,'thread_1',r.MODEL,'max')
    with pytest.raises(ValueError,match='gpt-6-luna'):
        r.register(b,'thread_2',r.MODEL,'high')
    r.write(a/'launch.json',{'started_at':'a previous launch'})
    with pytest.raises(ValueError,match='already reserved'):
        r.execute(a)


def test_only_working_and_currently_eligible_cells_are_selected(tmp_path):
    task={'scopes':[{'cell':'fit_a','worked':True},{'cell':None,'worked':False},
                    {'cell':'fit_c','worked':True}]}
    r.write(tmp_path/'work/submission.json',{'fits':[{'cell_id':'fit_a','blocked_reason':None},
            {'cell_id':'fit_unused','blocked_reason':None},{'cell_id':None,'blocked_reason':'Unavailable'}]})
    assert r.selected_cells(tmp_path,task)=={'fit_a'}




def test_setup_preflight_rejects_moved_ado_and_identifies_handoff_case(tmp_path,monkeypatch):
    pyreadstat=pytest.importorskip('pyreadstat')
    pd=pytest.importorskip('pandas')
    monkeypatch.setattr(r,'ROOT',tmp_path)
    ado=tmp_path/'checkout with spaces/output/reproductions/resources/ado';ado.mkdir(parents=True)
    monkeypatch.setattr(r.layout,'active_path',lambda key:ado)
    prior=tmp_path/'accepted';prior.mkdir()
    work=tmp_path/'job/work';work.mkdir(parents=True)
    task={'sources':{'predecessor':'accepted/outcome.json'}}
    samples={'samples':[{'sample_id':'s','dta_file':'data/reg.dta'}]}
    for p in (prior,work):r.write(p/'submission.json',samples)
    (prior/'data').mkdir()
    pyreadstat.write_dta(pd.DataFrame({'ACTDATS':[1000]}),prior/'data/reg.dta')
    lines=['use "data/reg.dta", clear\n','quietly count if e(sample) & year(actdats)>2000\n',
           'display "EXT_SAMPLE key " r(N)\n']
    bad={'id':'analysis','source':['adopath ++ "../git/output/reproduction/ado"\n',*lines]}
    with pytest.raises(ValueError,match='wrong shared ado path'):
        r.preflight_stata_setup(work,task,[bad])
    missing={'id':'analysis','source':['adopath ++ "missing/output/reproductions/resources/ado"\n',*lines]}
    with pytest.raises(ValueError,match='wrong shared ado path'):
        r.preflight_stata_setup(work,task,[missing])
    good={'id':'analysis','source':[f'adopath ++ "{ado}"\n',*lines]}
    assert any('ACTDATS' in w for w in r.preflight_stata_setup(work,task,[good]))
