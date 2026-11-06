"""Results-campaign quota, immutable-input and publication behavior."""
import argparse
import contextlib
import copy
import importlib.util
import io
import json
from pathlib import Path
import shutil
import tempfile
import unittest

from test_model_results import fixture

REAL_ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('results_campaign', REAL_ROOT / 'scripts/model_results_runs.py')
manager = importlib.util.module_from_spec(spec); spec.loader.exec_module(manager)


class CampaignTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(); self.root = Path(self.temp.name)
        self.old = manager.ROOT, manager.RUNS, manager.WORKFLOW, manager.SKILL
        manager.ROOT=self.root;manager.RUNS=self.root/'output/model_results_runs';manager.WORKFLOW=manager.RUNS/'workflow.json';manager.SKILL=self.root/'skills/extract-accounting-models'
        shutil.copytree(REAL_ROOT/'skills/extract-accounting-models',manager.SKILL,ignore=shutil.ignore_patterns('__pycache__'))
        oldruns=self.root/'output/model_extraction_runs';oldruns.mkdir(parents=True)
        per=self.root/'output/model_extractions';per.mkdir();(self.root/'papers').mkdir()
        bases=[];manifest=[];index=[];samples=[]
        for pid in ('W2','W1','W3','W4','W5','W6'):
            base,raw,data,paper=fixture();base['paper_id']=pid;paper['paper_id']=pid;base['paper_text_file']=f'papers/{pid}.json'
            path=per/f'{pid}.json';manager.write(path,base);manager.write(self.root/base['paper_text_file'],paper)
            pdf=self.root/'papers'/f'{pid}.pdf';pdf.write_bytes(b'fixture-pdf')
            bases.append(base);samples.append({'paper_id':pid,'samples':[]})
            manifest.append({'paper_id':pid,'doi':None,'title':'Fixture','journal':'TAR','pdf_path':f'papers/{pid}.pdf','pdf_sha256':manager.sha(pdf)})
            index.append({'paper_id':pid,'result_sha256':manager.sha(path)})
        source=self.root/'output/model_extractions.jsonl';source.write_text(''.join(json.dumps(r)+'\n' for r in bases))
        (self.root/'output/sample_extractions.filtered.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in samples))
        (oldruns/'input_manifest.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in manifest))
        manager.write(self.root/'output/model_extraction_index.json',{'aggregate_sha256':manager.sha(source),'records':index})
        with contextlib.redirect_stdout(io.StringIO()):manager.initialize(None)

    def tearDown(self):
        manager.ROOT,manager.RUNS,manager.WORKFLOW,manager.SKILL=self.old;self.temp.cleanup()

    def prepare(self,kind='sweep',previous=None):
        if kind=='sweep':
            accepted=manager.RUNS/'accepted_fixture';accepted.mkdir(exist_ok=True)
            manager.write(accepted/'run.json',{'kind':'pilot','status':'complete','skill_sha256':manager.live_skill_hashes()})
            manager.write(accepted/'parent_review.json',{'accepted_for_production':True})
            w=manager.read(manager.WORKFLOW);w['pilot_accepted']={'stage':'accepted_fixture','review_sha256':manager.sha(accepted/'parent_review.json')};manager.write(manager.WORKFLOW,w)
        with contextlib.redirect_stdout(io.StringIO()):manager.prepare(argparse.Namespace(kind=kind,ids=['W2','W1','W3','W4','W5','W6'] if kind=='pilot' else None,previous_stage=previous))
        return manager.RUNS/(f'{kind}_01' if previous is None else f'{kind}_02')

    def populate(self,stage):
        run,rows=manager.guard(stage)
        with contextlib.redirect_stdout(io.StringIO()):manager.assign(argparse.Namespace(stage=stage.name,worker='one',count=6,max_terms=999))
        run=manager.read(stage/'run.json');report=[]
        for row in rows:
            base=manager.read(self.root/row['specification_json']);_,raw,_,_=fixture();raw['paper_id']=row['paper_id']
            manager.write(self.root/row['reported_json'],raw)
            calculator=manager.load_module(stage/'skill_snapshot/scripts/derive_statistics.py')
            result=calculator.merge_enrichment(base,raw,row['specification_json'],row['specification_sha256'])
            manager.write(self.root/row['result_json'],result)
            report.append({'paper_id':row['paper_id'],'reported_sha256':manager.sha(self.root/row['reported_json']),'result_sha256':manager.sha(self.root/row['result_json'])})
        manager.write(self.root/run['batches'][0]['report_json'],{'papers':report})
        manager.write(stage/'parent_review.json',{'accepted_for_archival':True,'accepted_for_publication':True,'accepted_for_production':True})

    def test_fresh_quota_and_no_reset(self):
        w=manager.read(manager.WORKFLOW);self.assertEqual(7,w['maximum_pilot_rounds']);self.assertEqual(2,w['maximum_full_sweeps'])
        with self.assertRaisesRegex(ValueError,'cannot be reset'):manager.initialize(None)
        w['pilot_rounds']=[{}]*7;manager.write(manager.WORKFLOW,w)
        with self.assertRaisesRegex(ValueError,'quota exhausted'):self.prepare('pilot')

    def test_holdout_acceptance_gates_full_run(self):
        with self.assertRaisesRegex(ValueError,'holdout pilot'):manager.prepare(argparse.Namespace(kind='sweep',ids=None,previous_stage=None))

    def test_frozen_base_and_worklist_changes_are_detected(self):
        stage=self.prepare();self.populate(stage);run=manager.read(stage/'run.json');path=self.root/run['batches'][0]['worklist'];original=path.read_bytes();path.write_text('wrong')
        with self.assertRaisesRegex(ValueError,'worklist'):manager.check_stage(stage)
        path.write_bytes(original)
        base=self.root/'output/model_extractions/W1.json';base.write_text('{}')
        with self.assertRaisesRegex(ValueError,'specification_json'):manager.check_stage(stage)

    def test_full_validation_and_original_order_export(self):
        stage=self.prepare();self.populate(stage);before=manager.sha(self.root/'output/model_extractions.jsonl')
        _,summary,_=manager.check_stage(stage);self.assertEqual(6,summary['valid'])
        with contextlib.redirect_stdout(io.StringIO()):manager.finish(argparse.Namespace(stage=stage.name,accept_pilot=False,publish=True))
        out=manager.lines(self.root/'output/model_results.jsonl');self.assertEqual(['W2','W1','W3','W4','W5','W6'],[r['paper_id'] for r in out])
        self.assertEqual(before,manager.sha(self.root/'output/model_extractions.jsonl'))
        self.assertTrue((stage/'raw_luna_archive/manifest.json').is_file())

    def test_missing_result_or_worker_hash_blocks_publication(self):
        stage=self.prepare();self.populate(stage);target=stage/'results/W1.json';saved=target.read_bytes();target.unlink()
        with self.assertRaisesRegex(ValueError,'Every selected'):manager.finish(argparse.Namespace(stage=stage.name,accept_pilot=False,publish=True))
        target.write_bytes(saved)
        run=manager.read(stage/'run.json');report=self.root/run['batches'][0]['report_json'];data=manager.read(report);data['papers'][0]['reported_sha256']='0'*64;manager.write(report,data)
        with self.assertRaisesRegex(ValueError,'hashes do not match'):manager.finish(argparse.Namespace(stage=stage.name,accept_pilot=False,publish=True))
        self.assertFalse((self.root/'output/model_results.jsonl').exists())

    def test_second_sweep_freezes_prior_raw_records(self):
        first=self.prepare();self.populate(first)
        with contextlib.redirect_stdout(io.StringIO()):manager.finish(argparse.Namespace(stage=first.name,accept_pilot=False,publish=False))
        second=self.prepare(previous='sweep_01');rows=manager.lines(second/'manifest.jsonl');prior=self.root/rows[0]['previous_reported'];prior.write_text('{}')
        with self.assertRaisesRegex(ValueError,'previous_reported'):manager.guard(second)

    def test_final_audit_detects_changed_publication(self):
        stage=self.prepare();self.populate(stage)
        with contextlib.redirect_stdout(io.StringIO()):
            manager.finish(argparse.Namespace(stage=stage.name,accept_pilot=False,publish=True))
            manager.audit(None)
        self.assertTrue(manager.read(manager.RUNS/'final_audit.json')['valid'])
        (self.root/'output/model_results/W1.json').write_text('{}')
        with self.assertRaisesRegex(ValueError,'per-paper result differs'):manager.audit(None)

    def test_complete_results_with_source_caveats_enter_review_queue(self):
        _,_,data,_=fixture()
        self.assertEqual([],manager.review_queue([data]))
        data['models'][0]['results']['result_sets'][0]['review_notes']=['Printed star legend conflicts with direct p-value.']
        queue=manager.review_queue([data])
        self.assertEqual(1,len(queue));self.assertFalse(queue[0]['has_new_result_issues'])
        self.assertIn('star legend',queue[0]['models'][0]['result_sets'][0]['review_notes'][0])

    def test_production_requires_the_exact_tested_skill(self):
        self.prepare()
        (manager.SKILL/'SKILL.md').write_text('changed instructions')
        with self.assertRaisesRegex(ValueError,'differs from accepted pilot'):
            manager.prepare(argparse.Namespace(kind='sweep',ids=None,previous_stage=None))


if __name__=='__main__':unittest.main()
