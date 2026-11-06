import importlib.util
import json
import sys
import tempfile
import unittest
from unittest.mock import patch
import contextlib
import io
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
import project_layout as layout
spec=importlib.util.spec_from_file_location('layout_migration',ROOT/'scripts/reorganize_outputs.py')
migration=importlib.util.module_from_spec(spec);spec.loader.exec_module(migration)


class LayoutTests(unittest.TestCase):
    def setUp(self):
        self.quiet=contextlib.redirect_stdout(io.StringIO());self.quiet.__enter__()
        self.temp=tempfile.TemporaryDirectory();self.ws=Path(self.temp.name)
        self.root=self.ws/'git';self.root.mkdir()
        self.archive=self.ws/'candidate_search/archive/test';self.archive.parent.mkdir(parents=True)

    def tearDown(self):
        self.temp.cleanup();self.quiet.__exit__(None,None,None)

    def put(self,path,value):
        p=self.root/path;p.parent.mkdir(parents=True,exist_ok=True)
        p.write_text(json.dumps(value) if not isinstance(value,str) else value);return p

    def seed(self):
        for stage in ['model_extraction','model_results','feasibility','reproduction']:
            self.put('output/'+stage+'_runs/workflow.json',{})
        for old in migration.CURRENT:
            if old in {'model_results','feasibility_checks','feasibility_summary','reproduction_runs/ado','reproduction_runs/comparison'}:
                self.put('output/'+old+'/example.json',{})
            else:self.put('output/'+old,{})
        row=dict(paper_id='W1',paper_text_file='papers/parsed/W1.json')
        for name in ['sample_extractions.jsonl','sample_extractions.filtered.jsonl','model_results.jsonl','feasibility_checks.jsonl']:
            self.put('output/'+name,json.dumps(row)+'\n')
        summary=dict(papers=1,accepted_papers=1,assignments=2,expected_scopes=1,executed_scopes=1)
        self.put('output/reproduction_runs/summary.json',summary)
        self.put('output/reproduction_runs/comparison/model_consistency_summary.json',{'counts':{'consistent':1}})
        self.put('output/model_results_runs/pilot_01/run.json',{'status':'complete'})
        self.put('reproductions/W1/attempt_01/old.txt','old')
        base='reproductions/W1/attempt_02'
        nb={'cells':[{'cell_type':'code','id':'fit','source':['adopath ++ "../../../output/reproduction_runs/ado"\n','regress y x\n'],
                      'outputs':[{'text':'old output stays intact'}]}]}
        self.put(base+'/stata.ipynb',nb)
        self.put(base+'/data/reg.dta','unmodified raw bytes')
        self.put(base+'/runtime/production/cell.log','result')
        self.put(base+'/runtime/obsolete/debug.log','earlier failure')
        self.put(base+'/runtime/latest.json',{'cells':{'fit':{'log':str(self.root/base/'runtime/production/cell.log')}}})
        outcome=self.put(base+'/outcome.json',{'status':'executed'})
        self.put('reproductions/W1/accepted.json',{'attempt':2,'path':str(self.root/base),'outcome_sha256':layout.sha(outcome)})
        self.put('output/reproduction_runs/campaign.json',{'papers':[{'paper_id':'W1','assignments':[
            {'path':str(self.root/'reproductions/W1/attempt_01')},{'path':str(self.root/base)}]}]})
        return nb

    def test_archive_integrity_references_and_no_overwrite(self):
        oldnb=self.seed()
        migration.plan(self.root,self.archive);migration.apply(self.archive)
        result=migration.verify(self.root,self.archive)
        self.assertTrue(result['valid'])
        self.assertTrue(migration.apply(self.archive)['valid'])
        with self.assertRaises(ValueError):migration.plan(self.root,self.archive/'other')

    def test_paths_datasets_and_notebook_proof(self):
        oldnb=self.seed();migration.plan(self.root,self.archive);migration.apply(self.archive)
        base=self.root/'output/reproductions/W1/attempt_02'
        self.assertEqual('unmodified raw bytes',(base/'data/reg.dta').read_text())
        self.assertFalse((base/'runtime/obsolete').exists())
        old=self.root/'reproductions/W1/attempt_02/runtime/obsolete/debug.log'
        self.assertEqual('earlier failure',layout.resolve_path(old,self.root).read_text())
        P=layout.path_class(self.root)
        self.assertEqual('earlier failure',P(old).read_text())
        newnb=json.loads((base/'stata.ipynb').read_text())
        self.assertEqual(oldnb['cells'][0]['outputs'],newnb['cells'][0]['outputs'])
        current=''.join(newnb['cells'][0]['source'])
        self.assertEqual(''.join(oldnb['cells'][0]['source']),layout.executed_cell_source(base,'fit',current,self.root))
        newnb['cells'][0]['source'].append('regress y z\n');(base/'stata.ipynb').write_text(json.dumps(newnb))
        edited=''.join(newnb['cells'][0]['source'])
        self.assertEqual(edited,layout.executed_cell_source(base,'fit',edited,self.root))
        self.assertEqual(self.archive/'output/model_results_runs/pilot_01',layout.stage_path('model_results','pilot_01',self.root))
        self.assertEqual(self.ws/'candidate_search/runs/model_results/pilot_02',layout.stage_path('model_results','pilot_02',self.root))
        self.assertEqual(layout.resolve_path(old,self.root),layout.artifact_path(old,self.root))
        with self.assertRaises(ValueError):layout.artifact_path('/storage/sas/base/comp/funda.sas7bdat',self.root)
        self.assertFalse(layout.manages_run('feasibility',self.ws/'unrelated_fixture',self.root))
        self.assertFalse(layout.manages_run('model_results',self.archive/'output/model_results_runs/pilot_01',self.root))
        self.assertTrue(layout.manages_run('feasibility',self.ws/'candidate_search/runs/feasibility/full_02',self.root))
        with self.assertRaises(ValueError):layout.writable_path(old,self.root)
        with self.assertRaises(ValueError):P(old).write_text('overwrite history')

    def test_external_paths_and_missing_manifest(self):
        outside=Path('/storage/sas/base/comp/funda.sas7bdat')
        self.assertEqual(outside,layout.resolve_path(outside,self.root))
        self.assertEqual(self.root/'output/model_results.jsonl',layout.active_path('models',self.root))

    def test_current_model_publication_is_schema3_and_archives_previous(self):
        self.seed();migration.plan(self.root,self.archive);migration.apply(self.archive)
        before=layout.active_path('models',self.root).read_bytes()
        record={'paper_id':'W2','schema_version':'3.0','models':[], 'description':'new accepted result'}
        layout.publish_models([record],{'records':[{'paper_id':'W2'}]},[],self.root)
        current=layout.active_path('models',self.root)
        self.assertEqual(record,json.loads(current.read_text()))
        self.assertFalse((current.parent/'model_results.v2.jsonl').exists())
        self.assertEqual(before,layout.resolve_path('output/model_results.jsonl',self.root).read_bytes())

    def test_interrupted_apply_can_resume_without_losing_data(self):
        self.seed();migration.plan(self.root,self.archive)
        original=migration.shutil.copy2
        def interrupted(source,dest,*args,**kwargs):
            if str(dest).endswith('original_current/W1/attempt_02/stata.ipynb'):
                raise OSError('simulated interruption')
            return original(source,dest,*args,**kwargs)
        with patch.object(migration.shutil,'copy2',interrupted):
            with self.assertRaises(OSError):migration.apply(self.archive)
        migration.apply(self.archive)
        self.assertTrue(migration.verify(self.root,self.archive)['valid'])


if __name__=='__main__':unittest.main()
