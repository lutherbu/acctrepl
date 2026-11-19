"""Fictional metadata/run receipts only; no paper or native runtime is executed."""
import copy
from contextlib import contextmanager
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest
from unittest.mock import patch

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('author_analysis_runs',ROOT/'scripts/author_analysis_runs.py')
c=importlib.util.module_from_spec(spec);spec.loader.exec_module(c)

FAKE_RUNNER = '''
from pathlib import Path
import hashlib,json
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def validate_plan(attempt,plan_path):
 plan=json.loads(Path(plan_path).read_text())
 if plan.get('fixture_validation_failure'):raise ValueError('Fictional missing reviewed ado mount')
 return plan
def run(attempt,plan_path):
 attempt=Path(attempt);plan=json.loads(Path(plan_path).read_text());runtime=attempt/'runtime';runtime.mkdir(exist_ok=True)
 if plan.get('fixture_preflight_block'):
  result={'attempt_id':plan['attempt_id'],'status':'blocked','execution_verified':False,'plan_sha256':sha(plan_path),'original_inputs_unchanged':True,'stages':[]}
 else:
  with (runtime/'intent.json').open('x') as stream:json.dump({'plan_sha256':sha(plan_path)},stream)
  stages=[];states={}
  for stage in plan['stages']:
   failure=stage.get('fixture_failure',False);skipped=any(states[x]!='succeeded' for x in stage.get('depends_on',[]))
   status='skipped' if skipped else 'failed' if failure else 'succeeded';states[stage['id']]=status
   outputs=[]
   for relative in ([] if skipped else stage.get('expected_outputs',[])):
    path=attempt/relative;before=sha(path) if path.exists() else None
    if status=='succeeded':path.parent.mkdir(parents=True,exist_ok=True);path.write_text('NEW FIXTURE RESULT '+stage['id'])
    after=sha(path) if path.exists() else None
    outputs.append({'path':str(path),'before_sha256':before,'after_sha256':after,'fresh':after is not None and after!=before})
   if stage.get('log_only') and status=='succeeded':
    path=runtime/(stage['id']+'.native.log');path.write_text('\\n'.join(stage['success_markers']))
    outputs.append({'path':str(path),'before_sha256':None,'after_sha256':sha(path),'fresh':True})
   stages.append({'id':stage['id'],'required':stage.get('required',True),'status':status,'returncode':None if skipped else 1 if failure else 0,'timeout':False,'native_error_detected':failure,'outputs':outputs,'log_only_verified':stage.get('log_only',False) and not stage.get('fixture_log_only_unverified',False)})
  successful=sum(s['status']=='succeeded' for s in stages);complete=all(s['status']=='succeeded' for s in stages if s['required'])
  result={'attempt_id':plan['attempt_id'],'status':'completed' if complete else 'partial' if successful else 'failed','execution_verified':complete,'plan_sha256':sha(plan_path),'original_inputs_unchanged':True,'stages':stages}
 item=json.loads((attempt/'work_item.json').read_text());policy=json.loads(Path(item['runtime_policy']['path']).read_text())
 if policy['sandbox_profile']=='host':
  result.update(sandbox={'profile':'host','filesystem_isolation':False,'network_isolation':False,'network_disabled':False,'network_isolation_requested':False,'setup_verified':True,'host_home_exposed':True,'host_home':str(Path.home()),'full_user_filesystem_visibility':True,'host_writable_roots':None},host_execution_authorization=policy['host_execution_authorization'],host_execution_authorization_unchanged=True)
 (runtime/'run.json').write_text(json.dumps(result));return result
'''


class AuthorAnalysisControllerTests(unittest.TestCase):
    @contextmanager
    def relocated_publication(self, old, new):
        project=self.base/'git';(project/'output').mkdir(exist_ok=True)
        (project/'output/manifest.json').write_text(json.dumps({
            'archive_root':'../layout_archive','workflows':{'author_analysis':str(self.campaign)},
            'relocations':[{'old':str(old),'new':str(new),'prefix':True}]}))
        with patch.object(c,'Path',c.layout.path_class(project)):
            yield

    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.addCleanup(self.temp.cleanup)
        self.base=Path(self.temp.name);self.campaign=self.base/'campaign'
        self.skill=self.base/'git/skills/execute-author-analysis'
        (self.skill/'references').mkdir(parents=True);(self.skill/'scripts').mkdir()
        (self.skill/'SKILL.md').write_text('Fictional execution fixture skill.\n')
        shutil.copy2(ROOT/'skills/execute-author-analysis/references/output.schema.json',self.skill/'references/output.schema.json')
        (self.skill/'scripts/runner.py').write_text(FAKE_RUNNER)
        self.patch=patch.object(c,'SKILL',self.skill);self.patch.start();self.addCleanup(self.patch.stop)
        self.units=[]
        for n in range(2):
            pid=f'pkg-{n}';package=self.base/pid;package.mkdir()
            (package/'analysis.R').write_text('Fictional source; not executed.\n')
            (package/'data.txt').write_text('Fictional observed fixture input.\n')
            scope={'id':'analysis_only','entry_points':['analysis.R']}
            assessment=self.base/f'assessment-{n}.json';c.write(assessment,{'package_id':pid,'scopes':[scope]})
            item=self.base/f'item-{n}.json';c.write(item,{'output_header':{'package_id':pid},'package_root':str(package)})
            self.units.append({'package_id':pid,'scope_id':'analysis_only','analysis_scope':scope,
                'package_root':str(package),'title':'Fictional package',
                'source_assessment':{'path':str(assessment),'sha256':c.sha(assessment)},
                'source_work_item':{'path':str(item),'sha256':c.sha(item)}})
        self.manifest=self.base/'manifest.json';c.write(self.manifest,{'units':self.units})
        c.initialize(self.manifest,self.campaign,fixture=True)
        self.policy=self.base/'policy.json';p=copy.deepcopy(c.DEFAULT_POLICY)
        p['allowed_executables']['r']=['fixture-Rscript'];c.write(self.policy,p)
        self.agent_count=0

    def prepare(self,pid='pkg-0',phase='pilot',case=1):
        return Path(c.prepare(pid,phase,case,campaign=self.campaign,policy_path=self.policy)['attempt'])

    def host_policy(self):
        authorization=self.base/'user-host-authorization.json'
        c.write(authorization,{'approved':True,'approved_by':'user','execution_profile':'host','languages':['matlab'],
            'host_home':str(Path.home()),'user_instruction':'Use host mode for MATLAB with normal user access.',
            'approved_at':'2026-11-17T00:00:00+00:00'})
        policy=copy.deepcopy(c.DEFAULT_POLICY)
        policy.update(sandbox_profiles=['host'],host_home=str(Path.home()),
            host_execution_authorization={'path':str(authorization),'sha256':c.sha(authorization)},
            allowed_executables={'stata':[],'r':[],'matlab':['/fixture/matlab']})
        c.write(self.policy,policy);return authorization,policy

    def host_ready(self):
        self.host_policy();attempt,plan=self.ready()
        plan['sandbox']={'profile':'host','read_only_paths':[]}
        plan['stages'][0].update(language='matlab',executable='/fixture/matlab')
        c.write(attempt/'plan.json',plan);return attempt,plan

    def assign(self,attempt,agent=None):
        self.agent_count+=1
        return c.assign(attempt,agent or f'/root/fixture-agent-{self.agent_count}',**c.CONFIG)

    def ready(self,pid='pkg-0',phase='pilot',case=1):
        attempt=self.prepare(pid,phase,case);self.assign(attempt)
        c.stage(attempt,['analysis.R','data.txt'])
        item=c.read(attempt/'work_item.json')
        plan={'schema_version':'1.0','attempt_id':item['attempt_id'],
              'sandbox':{'profile':'bwrap','read_only_paths':[item['input_root']]},
              'limits':{'wall_seconds':60,'memory_bytes':1024**3,'threads':1},
              'inputs':[{'path':'work/data.txt','sha256':c.sha(attempt/'work/data.txt')}],
              'stages':[{'id':'table','language':'r','executable':'fixture-Rscript',
                  'script':'work/analysis.R','script_sha256':c.sha(attempt/'work/analysis.R'),
                  'args':[],'cwd':'work','depends_on':[],'required':True,
                  'source_entry_points':['analysis.R'],'expected_outputs':['work/result.txt'],'native_logs':[]}],
              'scope_gaps':[]}
        c.write(attempt/'plan.json',plan)
        return attempt,plan

    def approve(self,attempt,plan=None):
        if plan is not None:c.write(attempt/'plan.json',plan)
        return c.approve_plan(attempt,'plan.json','/root/coordinator',source_reviewed=True)

    def report(self,attempt,outcome=None):
        item=c.read(attempt/'work_item.json');record=c.read(self.campaign/'campaign.json')['attempts'][item['attempt_id']]
        report=c.read(attempt/'report_template.json')
        staging=c.read(attempt/'staging.json')
        report['inputs']=[{'id':f'input{i}','role':'code' if r['original_path'].endswith('.R') else 'data',
            'original':{'path':r['original_path'],'sha256':r['original_sha256']},
            'staged':{'path':r['staged_path'],'sha256':c.sha(r['staged_path'])}} for i,r in enumerate(staging['files'])]
        receipt=record.get('runtime_receipt')
        if receipt:
            run=c.read(receipt['path']);report['run_receipt']=receipt
            plan_review=record['plan_reviews'][-1];report['plan']={k:plan_review['plan'][k] for k in ('path','sha256')}
            plan=c.read(plan_review['plan']['path']);byid={s['id']:s for s in plan['stages']}
            report['stage_results']=[];report['artifacts']=[]
            for s in run['stages']:
                ids=[]
                for i,a in enumerate(s['outputs']):
                    aid=f'{s["id"]}-output{i}';ids.append(aid)
                    freshness='missing' if a['after_sha256'] is None else 'unchanged' if not a['fresh'] else 'new' if a['before_sha256'] is None else 'changed'
                    report['artifacts'].append({'id':aid,'path':a['path'],'sha256':a['after_sha256'],
                        'kind':'native_result_log' if byid[s['id']].get('log_only') else 'result_table','freshness':freshness,'stage_id':s['id']})
                ok=s['status']=='succeeded'
                report['stage_results'].append({'stage_id':s['id'],'source_entry_points':byid[s['id']]['source_entry_points'],
                    'required':s['required'],'status':s['status'],'returncode':s['returncode'],
                    'receipt':receipt,'log_check':'passed' if ok else 'failed' if s['status']=='failed' else 'not_assessed',
                    'output_ids':ids,'note':'Trusted fictional fixture receipt.'})
            expected=outcome or ('blocked' if run['status']=='blocked' else run['status'])
            report['outcome']=expected;report['execution_verified']=expected=='completed'
            if expected=='completed':report['gaps']=[]
            else:report['gaps'][0]['description']='Actual fixture failure, blocked stage or scope gap.'
        return report

    def finish(self,attempt,report=None):
        if report is None:report=self.report(attempt)
        c.write(attempt/'draft_report.json',report);c.finalize(attempt,'draft_report.json')
        c.write(attempt/'review_note.json',{'source_checked':True,'execution_checked':True,
            'comparison_checked':False,'notes':['Independently checked fictional metadata and runtime evidence.']})
        return c.review(attempt,'/root/reviewer','review_note.json')

    def completed(self,pid='pkg-0',phase='pilot',case=1):
        attempt,plan=self.ready(pid,phase,case);self.approve(attempt);c.execute(attempt);self.finish(attempt)
        return attempt

    def test_promote_one_accepted_package_replays_nested_inputs(self):
        import io
        import zipfile
        sha = c.sha
        from scripts import materialize_execution_inputs as restore
        project=self.base/'relocated checkout with spaces'
        archive=project/'papers/packages/paper.zip'
        archive.parent.mkdir(parents=True)
        data=(self.base/'pkg-0/data.txt').read_bytes()
        inner=io.BytesIO()
        with zipfile.ZipFile(inner,'w') as z:z.writestr('reported/data.txt',data)
        with zipfile.ZipFile(archive,'w') as z:z.writestr('supplement.zip',inner.getvalue())
        unit=self.units[0];file=Path(unit['source_work_item']['path'])
        src=c.read(file);src['output_header']['provenance']={'package_files':[{'path':'paper.zip','sha256':sha(archive)}]}
        c.write(file,src);unit['source_work_item']['sha256']=sha(file)
        c.write(self.manifest,{'units':self.units})
        self.campaign=self.base/'promotion campaign'
        c.initialize(self.manifest,self.campaign,fixture=True)
        attempt,plan=self.ready('pkg-0','full',1);self.approve(attempt);c.execute(attempt)
        report=self.report(attempt);c.write(attempt/'draft.json',report);c.finalize(attempt,'draft.json')
        items=[{'path':str(attempt/'work'/name),'sha256':sha(attempt/'work'/name),'kind':kind}
               for name,kind in [('analysis.R','code'),('result.txt','result')]]
        c.write(attempt/'note.json',{'source_checked':True,'execution_checked':True,'notes':['Test review.'],'publish_files':items})
        c.review(attempt,'/root/reviewer','note.json')
        template=self.base/'recipe/code/main.R';template.parent.mkdir(parents=True)
        shutil.copyfile(attempt/'work/analysis.R',template)
        recipe=template.parent.parent/'local_inputs.json'
        r={'schema_version':'2.0','package_id':'pkg-0','scope_id':'analysis_only','attempt_id':report['attempt_id'],
           'accepted_outcome':report['outcome'],'archive':{'path':archive.relative_to(project).as_posix(),
           'bytes':archive.stat().st_size,'sha256':sha(archive)},'files':[
           {'role':'data','path':'work/data.txt','input_id':next(i['id'] for i in report['inputs'] if i['role']=='data'),
            'members':['supplement.zip','reported/data.txt'],'bytes':len(data),'sha256':sha(attempt/'work/data.txt')},
           {'role':'code','path':'work/analysis.R','template':'code/main.R','template_sha256':sha(template),
            'executed_sha256':sha(attempt/'work/analysis.R')}],
           'stages':[{k:v for k,v in plan['stages'][0].items() if k not in ('executable','script_sha256')}],
           'limits':plan['limits'],'scope_gaps':[],'environment':{},'empty_directories':['work']}
        c.write(recipe,r)
        with patch.object(c,'ROOT',project):
            dest=project/c.promote(self.campaign,'pkg-0',recipe)['path']
            self.assertEqual((dest/'work/data.txt').read_bytes(),data)
            self.assertEqual(restore.prepare(project,'pkg-0',check=True,verify_archive=True),2)
            before=c.tree_hash(dest)
            c.promote(self.campaign,'pkg-0',recipe)
            self.assertEqual(c.tree_hash(dest),before)
            self.assertNotIn(str(self.base),(dest/'report.json').read_text())
            r['files'][0]['members']=['supplement.zip','bad.txt'];c.write(recipe,r)
            with self.assertRaisesRegex(ValueError,'Missing or ambiguous'):c.promote(self.campaign,'pkg-0',recipe)
            self.assertEqual(c.tree_hash(dest),before)
            r['stages'][0]['required']=False;c.write(recipe,r)
            with self.assertRaisesRegex(ValueError,'Replay stages'):c.promote(self.campaign,'pkg-0',recipe)

    def publication_with_code(self):
        attempt,plan=self.ready('pkg-0','full',1);self.approve(attempt);c.execute(attempt)
        c.write(attempt/'draft_report.json',self.report(attempt));c.finalize(attempt,'draft_report.json')
        c.write(attempt/'review_note.json',{'source_checked':True,'execution_checked':True,
            'notes':['Fictional source and result independently reviewed.'],
            'publish_files':[{'path':str(attempt/'work/analysis.R'),'sha256':c.sha(attempt/'work/analysis.R'),'kind':'code'}]})
        c.review(attempt,'/root/reviewer','review_note.json')
        self.completed('pkg-1','full',1)
        publication=c.publish(self.campaign)
        return publication,Path(publication['path'])

    def add_local_overlay(self, publication):
        paths={'software/library/package.ado':'Fictional local software.',
               'packages/pkg-0/work/inputs/sample.dta':'Fictional local data.',
               'packages/pkg-0/local_inputs.json':'{"local": true}',
               'packages/pkg-0/RUN_LOCAL.md':'Fictional local run instructions.'}
        for relative,body in paths.items():
            path=publication/relative;path.parent.mkdir(parents=True,exist_ok=True);path.write_text(body)

    def test_initialization_is_idempotent_but_never_resets_scope_or_limits(self):
        self.assertEqual(c.initialize(self.manifest,self.campaign,fixture=True)['status'],'existing')
        state=c.read(self.campaign/'campaign.json');state['limits']['pilot_cases']=99;c.write(self.campaign/'campaign.json',state)
        with self.assertRaisesRegex(ValueError,'limits'):c.resolve(self.campaign)

    def test_missing_registry_with_attempt_history_cannot_reset(self):
        self.prepare();(self.campaign/'campaign.json').unlink()
        with self.assertRaisesRegex(ValueError,'history'):c.initialize(self.manifest,self.campaign,fixture=True)

    def test_pilot_six_case_two_attempt_budget_and_fixed_package(self):
        a=self.prepare();self.assign(a);self.finish(a,c.read(a/'report_template.json'))
        with self.assertRaisesRegex(ValueError,'one package'):self.prepare('pkg-1',case=1)
        b=self.prepare();self.assign(b);self.finish(b,c.read(b/'report_template.json'))
        with self.assertRaisesRegex(ValueError,'Two attempts'):self.prepare()
        with self.assertRaisesRegex(ValueError,'Six pilot'):self.prepare(case=7)

    def test_fresh_model_context_required_for_every_attempt(self):
        first=self.prepare();self.assign(first,'/root/fresh')
        self.finish(first,c.read(first/'report_template.json'))
        second=self.prepare()
        with self.assertRaisesRegex(ValueError,'fresh agent'):self.assign(second,'/root/fresh')
        for key in c.CONFIG:
            config=dict(c.CONFIG);config[key]='wrong'
            with self.assertRaisesRegex(ValueError,'configuration'):c.assign(second,'/root/new',**config)
        self.assign(second,'/root/actually-new')

    def test_blocked_before_execution_still_consumes_assignment(self):
        a=self.prepare();self.assign(a);self.finish(a,c.read(a/'report_template.json'))
        self.assertEqual(c.status(self.campaign)['assigned_attempts'],1)
        self.assertEqual(c.status(self.campaign)['attempt_statuses'],{'accepted':1})

    def test_scope_source_and_frozen_skill_tampering_refused(self):
        a=self.prepare();(a/'skill_snapshot/SKILL.md').write_text('changed')
        with self.assertRaisesRegex(ValueError,'skill changed'):self.assign(a)

    def test_staging_is_distinct_and_cannot_overwrite_edited_copy(self):
        a=self.prepare();self.assign(a);source=Path(self.units[0]['package_root'])/'analysis.R';before=source.read_bytes()
        c.stage(a,['analysis.R']);self.assertNotEqual(source.stat().st_ino,(a/'work/analysis.R').stat().st_ino)
        (a/'work/analysis.R').write_text('a supported working edit')
        self.assertEqual(source.read_bytes(),before)
        with self.assertRaisesRegex(ValueError,'overwrite'):c.stage(a,['analysis.R'])
        with self.assertRaises(ValueError):c.stage(a,['../assessment-0.json'])

    def test_plan_requires_independent_review_and_all_entrypoints(self):
        a,p=self.ready()
        with self.assertRaisesRegex(ValueError,'coordinator'):c.approve_plan(a,'plan.json',c.read(self.campaign/'campaign.json')['attempts'][p['attempt_id']]['agent'],source_reviewed=True)
        p['stages'][0]['source_entry_points']=[]
        with self.assertRaisesRegex(ValueError,'every selected'):self.approve(a,p)
        p['stages'][0]['source_entry_points']=['analysis.R'];p['stages'][0]['required']=False
        with self.assertRaisesRegex(ValueError,'every selected'):self.approve(a,p)

    def test_plan_rejects_other_inputs_runtime_and_resource_expansion(self):
        a,p=self.ready()
        for mutate in [lambda d:d['sandbox']['read_only_paths'].append(str(self.base)),
                       lambda d:d['stages'][0].update(executable='/bin/sh'),
                       lambda d:d['limits'].update(threads=99),
                       lambda d:d['stages'][0].update(depends_on=['table'])]:
            changed=copy.deepcopy(p);mutate(changed)
            with self.assertRaises(ValueError):self.approve(a,changed)

    def test_changed_approved_code_refuses_launch(self):
        a,p=self.ready();self.approve(a);(a/'work/analysis.R').write_text('changed after approval')
        with self.assertRaisesRegex(ValueError,'Frozen file changed'):c.execute(a)
        self.assertFalse((a/'runtime/intent.json').exists())

    def test_one_native_launch_and_real_receipt_required(self):
        a,p=self.ready();self.approve(a);c.execute(a)
        with self.assertRaisesRegex(ValueError,'cannot be repeated'):c.execute(a)
        self.assertEqual(self.finish(a)['outcome'],'completed')
        with self.assertRaisesRegex(ValueError,'not ready'):c.finalize(a,'draft_report.json')

    def test_no_fake_completion_or_stale_output_claim(self):
        a,p=self.ready();report=c.read(a/'report_template.json');report.update(outcome='completed',execution_verified=True)
        c.write(a/'draft.json',report)
        with self.assertRaises(ValueError):c.finalize(a,'draft.json')
        self.approve(a);c.execute(a)
        report=self.report(a);report['artifacts'][0]['freshness']='unchanged';c.write(a/'bad.json',report)
        with self.assertRaises(ValueError):c.finalize(a,'bad.json')

    def test_failed_runtime_cannot_be_called_completed(self):
        a,p=self.ready();p['stages'][0]['fixture_failure']=True;self.approve(a,p);c.execute(a)
        report=self.report(a,'failed');self.finish(a,report)
        self.assertEqual(c.read(self.campaign/'campaign.json')['attempts'][p['attempt_id']]['outcome'],'failed')

    def test_partial_scope_and_comparison_gaps_do_not_confuse_execution(self):
        a,p=self.ready();self.approve(a);c.execute(a)
        report=self.report(a)
        report['gaps']=[{'id':'G_REFERENCE','kind':'comparison','description':'Published reference unavailable.',
                        'source_entry_points':['analysis.R'],'stage_ids':[],'references':[]}]
        self.assertEqual(self.finish(a,report)['outcome'],'completed')

    def test_one_failed_required_stage_preserves_partial_success(self):
        a,p=self.ready()
        second=copy.deepcopy(p['stages'][0]);second.update(id='second',depends_on=['table'],
            expected_outputs=['work/second.txt'],fixture_failure=True)
        p['stages'].append(second);self.approve(a,p);c.execute(a)
        report=self.report(a,'partial')
        self.assertEqual(self.finish(a,report)['outcome'],'partial')

    def test_failed_first_stage_reports_skipped_chain_without_fictitious_artifacts(self):
        a,p=self.ready();p['stages'][0]['fixture_failure']=True
        for name in ['second','third']:
            stage=copy.deepcopy(p['stages'][0]);stage.pop('fixture_failure')
            stage.update(id=name,depends_on=[p['stages'][-1]['id']],expected_outputs=[f'work/{name}.txt'])
            p['stages'].append(stage)
        self.approve(a,p);c.execute(a);report=self.report(a,'failed')
        self.assertEqual([s['status'] for s in report['stage_results']],['failed','skipped','skipped'])
        self.assertEqual([s['output_ids'] for s in report['stage_results'][1:]],[[],[]])
        self.assertEqual(len(report['artifacts']),1)
        invented=copy.deepcopy(report);invented['artifacts'].append({'id':'fake-skipped-output',
            'path':'work/second.txt','stage_id':'second','kind':'result_table','sha256':None,'freshness':'missing'})
        invented['stage_results'][1]['output_ids']=['fake-skipped-output']
        c.write(a/'invented.json',invented)
        with self.assertRaisesRegex(ValueError,'own native output evidence'):c.finalize(a,'invented.json')
        self.assertEqual(self.finish(a,report)['outcome'],'failed')
        self.assertFalse(c.read(a/'output/report.json')['execution_verified'])

    def test_sandbox_preflight_block_without_intent_can_be_replanned(self):
        a,p=self.ready();p['fixture_preflight_block']=True;self.approve(a,p);result=c.execute(a)
        self.assertEqual(result['status'],'preflight_blocked');self.assertFalse((a/'runtime/intent.json').exists())
        old=c.read(self.campaign/'campaign.json')['attempts'][p['attempt_id']]['runtime_receipt']
        p.pop('fixture_preflight_block');self.approve(a,p);c.execute(a);self.finish(a)
        self.assertEqual(len(c.read(self.campaign/'campaign.json')['attempts'][p['attempt_id']]['plan_reviews']),2)
        self.assertNotEqual(c.sha(a/'runtime/run.json'),old['sha256'])

    def test_interrupted_wrapper_reconciles_saved_receipt_without_rerun(self):
        a,p=self.ready();self.approve(a)
        module=c._runner(c.read(a/'work_item.json'))
        def interrupted(attempt,plan):module.run(attempt,plan);raise RuntimeError('fictional wrapper interruption')
        with patch.object(c,'_runner',return_value=type('Runner',(),{'run':staticmethod(interrupted)})):
            with self.assertRaisesRegex(RuntimeError,'reconcile'):c.execute(a)
        self.assertEqual(c.reconcile(a)['status'],'executed');self.finish(a)

    def test_numeric_match_is_calculated_not_trusted(self):
        a,p=self.ready();self.approve(a);c.execute(a);report=self.report(a)
        report['comparison']={'status':'matches','references':[{'id':'REF','source':'reference.pdf','sha256':None,'location':'Table 1','description':'Fictional numeric target'}],
            'metrics':[{'id':'M1','label':'coefficient','stage_id':'table','observed':2,'reference':1,'reference_id':'REF',
                        'absolute_tolerance':0.01,'relative_tolerance':0,'tolerance_basis':'Reported rounding','matches':True}], 'notes':[]}
        c.write(a/'bad_comparison.json',report)
        with self.assertRaisesRegex(ValueError,'tolerance'):c.finalize(a,'bad_comparison.json')

    def test_unaccepted_report_revision_preserves_original_and_native_receipt(self):
        a,p=self.ready();self.approve(a);c.execute(a)
        c.write(a/'draft.json',self.report(a));c.finalize(a,'draft.json')
        original=(a/'output/report.json').read_bytes();native=(a/'runtime/run.json').read_bytes()
        revised=c.read(a/'output/report.json');revised['review_notes'].append('Corrected reporting limitation.')
        c.write(a/'revised.json',revised);c.finalize(a,'revised.json')
        self.assertEqual((a/'output_history/report_001.json').read_bytes(),original)
        self.assertEqual((a/'runtime/run.json').read_bytes(),native)
        self.assertEqual(len(c.read(self.campaign/'campaign.json')['attempts']),1)
        self.assertEqual(c.read(a/'output/report.json')['review_notes'],revised['review_notes'])

    def test_report_recovery_quarantines_altered_bytes_then_allows_new_draft(self):
        a,p=self.ready();self.approve(a);c.execute(a)
        c.write(a/'draft.json',self.report(a));c.finalize(a,'draft.json')
        original=(a/'output/report.json').read_bytes();native=(a/'runtime/run.json').read_bytes()
        changed=c.read(a/'output/report.json');changed['review_notes'].append('Unregistered edit.')
        (a/'output/report.json').chmod(0o644);c.write(a/'output/report.json',changed)
        altered=(a/'output/report.json').read_bytes();c.write(a/'revised.json',changed)
        with self.assertRaises(ValueError):c.finalize(a,'revised.json')
        recovered=c.reconcile_report(a,'/root/coordinator','Preserve and restore an unregistered report edit.')
        event=c.read(recovered['recovery']['path'])
        self.assertEqual(Path(event['observed']['saved']['path']).read_bytes(),altered)
        self.assertEqual((a/'output/report.json').read_bytes(),original)
        self.assertEqual((a/'output/report.json').stat().st_mode & 0o777,0o444)
        self.assertEqual((a/'runtime/run.json').read_bytes(),native)
        c.finalize(a,'revised.json');self.assertEqual(len(c.read(self.campaign/'campaign.json')['attempts']),1)

    def test_report_recovery_rejects_accepted_or_changed_frozen_input(self):
        accepted=self.completed()
        with self.assertRaisesRegex(ValueError,'unaccepted'):c.reconcile_report(accepted,'/root/coordinator','No accepted rewrites.')
        a,p=self.ready('pkg-1',case=2);self.approve(a);c.execute(a)
        c.write(a/'draft.json',self.report(a));c.finalize(a,'draft.json')
        state=c.read(self.campaign/'campaign.json');record=state['attempts'][a.name]
        frozen=Path(record['report_trials'][-1]['input']['path']);frozen.chmod(0o644);frozen.write_text('{}')
        official=(a/'output/report.json').read_bytes()
        with self.assertRaises(ValueError):c.reconcile_report(a,'/root/coordinator','Invalid recovery proof.')
        self.assertEqual((a/'output/report.json').read_bytes(),official)

    def test_report_revision_never_overwrites_existing_history(self):
        a,p=self.ready();self.approve(a);c.execute(a)
        c.write(a/'draft.json',self.report(a));c.finalize(a,'draft.json')
        official=(a/'output/report.json').read_bytes()
        history=a/'output_history/report_001.json';history.parent.mkdir();history.write_bytes(b'Preserved preexisting archive')
        revised=c.read(a/'output/report.json');revised['review_notes'].append('New note.')
        c.write(a/'revised.json',revised)
        with self.assertRaisesRegex(ValueError,'history already exists'):c.finalize(a,'revised.json')
        self.assertEqual(history.read_bytes(),b'Preserved preexisting archive')
        self.assertEqual((a/'output/report.json').read_bytes(),official)

    def test_full_wave_coverage_and_latest_publication_preserve_prior_bytes(self):
        with self.assertRaisesRegex(ValueError,'every selected'):c.publish(self.campaign)
        first=self.completed('pkg-0','full',1);self.completed('pkg-1','full',1)
        self.prepare('pkg-0','pilot',1)  # Prepared metadata is not an agent assignment.
        result=c.publish(self.campaign);published=Path(result['path']);old=(published/'attempts.jsonl').read_bytes()
        self.assertIn('2 fresh-agent assignments.',(published/'summary.md').read_text())
        self.assertEqual(c.read(published/'summary.json')['attempts'],3)
        summary=c.read(published/'summary.json')['publication']
        self.assertEqual(summary['aggregate_sha256'],c.sha(published/'attempts.jsonl'))
        self.assertEqual(summary['index_sha256'],c.sha(published/'index.json'))
        self.assertEqual(summary['state'],'this_publication')
        with self.assertRaises(ValueError):self.prepare('pkg-0','full',1)
        second=self.completed('pkg-0','full',2);result2=c.publish(self.campaign)
        self.assertEqual(Path(result2['archive']).joinpath('attempts.jsonl').read_bytes(),old)
        docs=[json.loads(x) for x in (published/'attempts.jsonl').read_text().splitlines()]
        self.assertEqual(next(x for x in docs if x['package_id']=='pkg-0')['attempt_id'],second.name)
        self.assertEqual(c.read(published/'summary.json')['publication']['aggregate_sha256'],result2['aggregate_sha256'])
        self.assertNotEqual(first,second)
        self.completed('pkg-0','full',3)
        with self.assertRaisesRegex(ValueError,'Three full'):self.prepare('pkg-0','full',4)

    def test_publication_keeps_unused_current_wave_slots_and_archives_incrementally(self):
        self.completed('pkg-0','full',1);self.completed('pkg-1','full',1);c.publish(self.campaign)
        for wave in (2,3):
            first=self.completed('pkg-0','full',wave);before=c.publish(self.campaign)
            published=Path(before['path']);old=(published/'attempts.jsonl').read_bytes()
            old_item=(first/'work_item.json').read_bytes()
            second=self.completed('pkg-1','full',wave)
            unchanged=c.read(self.campaign/'campaign.json')['publication']
            self.assertEqual(unchanged,before)
            self.assertEqual((published/'attempts.jsonl').read_bytes(),old)
            self.assertEqual((first/'work_item.json').read_bytes(),old_item)
            with self.assertRaisesRegex(ValueError,'one attempt per full'):self.prepare('pkg-0','full',wave)
            after=c.publish(self.campaign)
            self.assertEqual(Path(after['archive']).joinpath('attempts.jsonl').read_bytes(),old)
            self.assertEqual(after['latest_attempts']['pkg-0'],first.name)
            self.assertEqual(after['latest_attempts']['pkg-1'],second.name)
            self.assertEqual(after['last_full_wave'],wave)
        with self.assertRaisesRegex(ValueError,'earlier full wave'):self.prepare('pkg-1','full',2)
        with self.assertRaisesRegex(ValueError,'Three full'):self.prepare('pkg-1','full',4)

    def test_publication_keeps_unused_pilot_quota_without_replacing_full_bindings(self):
        self.completed('pkg-0','full',1);self.completed('pkg-1','full',1)
        published=c.publish(self.campaign);aggregate=Path(published['path'])/'attempts.jsonl';old=aggregate.read_bytes()
        for number in (1,2):
            attempt=self.prepare('pkg-0','pilot',5);self.assign(attempt)
            self.finish(attempt,c.read(attempt/'report_template.json'))
            self.assertEqual(c.read(self.campaign/'campaign.json')['publication'],published)
            if number==1:
                with self.assertRaisesRegex(ValueError,'one package'):self.prepare('pkg-1','pilot',5)
        with self.assertRaisesRegex(ValueError,'Two attempts'):self.prepare('pkg-0','pilot',5)
        unused=self.prepare('pkg-1','pilot',6);self.assign(unused);self.finish(unused,c.read(unused/'report_template.json'))
        with self.assertRaisesRegex(ValueError,'Six pilot'):self.prepare('pkg-1','pilot',7)
        self.assertEqual(c.publish(self.campaign),published)
        self.assertEqual(aggregate.read_bytes(),old)

    def test_runtime_policy_and_report_header_are_frozen(self):
        a=self.prepare();item=c.read(a/'work_item.json')
        runtime=c.read(item['runtime_policy']['path'])
        self.assertEqual(runtime['allowed_read_only_roots'],[item['input_root']])
        self.assertEqual(c.read(a/'report_template.json')['provenance']['work_item_sha256'],c.sha(a/'work_item.json'))
        Path(item['runtime_policy']['path']).chmod(0o644);c.write(item['runtime_policy']['path'],{})
        with self.assertRaisesRegex(ValueError,'Frozen file'):self.assign(a)

    def test_log_only_estimation_requires_reviewed_tokens_and_fresh_native_evidence(self):
        a,p=self.ready();p['stages'][0].update(log_only=True,expected_outputs=[],success_markers=['Number of obs','Coefficient'])
        self.approve(a,p);c.execute(a);self.assertEqual(self.finish(a)['outcome'],'completed')
        report=c.read(a/'output/report.json');self.assertEqual(report['artifacts'][0]['kind'],'native_result_log')
        b,p2=self.ready(case=2);p2['stages'][0].update(log_only=True,expected_outputs=[],success_markers=['Number of obs','Number of obs'])
        with self.assertRaisesRegex(ValueError,'two distinct'):self.approve(b,p2)

    def test_log_only_claim_cannot_bypass_runner_verification(self):
        a,p=self.ready();p['stages'][0].update(log_only=True,expected_outputs=[],
            success_markers=['Number of obs','Coefficient'],fixture_log_only_unverified=True)
        self.approve(a,p);c.execute(a);c.write(a/'draft.json',self.report(a))
        with self.assertRaisesRegex(ValueError,'native evidence'):c.finalize(a,'draft.json')

    def test_explicit_publication_list_copies_code_and_results_without_data(self):
        a,p=self.ready('pkg-0','full',1);self.approve(a);c.execute(a)
        report=self.report(a);c.write(a/'draft.json',report);c.finalize(a,'draft.json')
        note={'source_checked':True,'execution_checked':True,'notes':['Fictional source and table verified.'],
              'publish_files':[{'path':str(a/'work/analysis.R'),'sha256':c.sha(a/'work/analysis.R'),'kind':'code'},
                               {'path':str(a/'work/result.txt'),'sha256':c.sha(a/'work/result.txt'),'kind':'result'}]}
        c.write(a/'note.json',note);c.review(a,'/root/reviewer','note.json')
        self.completed('pkg-1','full',1);publication=Path(c.publish(self.campaign)['path'])
        index=c.read(publication/'index.json')['packages']['pkg-0']['files']
        self.assertEqual(len(index),2)
        for entry in index:self.assertEqual(c.sha(publication/entry['published_path']),entry['sha256'])
        self.assertFalse(any(x.name=='data.txt' for x in publication.rglob('*')))
        self.assertEqual(c.publish(self.campaign)['path'],str(publication))
        (publication/index[0]['published_path']).write_text('tampered')
        with self.assertRaisesRegex(ValueError,'Published files changed'):c.publish(self.campaign)

    def test_publication_list_rejects_raw_data_and_logs_before_acceptance(self):
        a,p=self.ready();self.approve(a);c.execute(a);report=self.report(a)
        c.write(a/'draft.json',report);c.finalize(a,'draft.json')
        note={'source_checked':True,'execution_checked':True,'notes':['Fictional review.'],
              'publish_files':[{'path':str(a/'work/data.txt'),'sha256':c.sha(a/'work/data.txt'),'kind':'result'}]}
        c.write(a/'note.json',note)
        with self.assertRaisesRegex(ValueError,'raw logs and datasets'):c.review(a,'/root/reviewer','note.json')
        self.assertFalse((a/'output/source_review.json').exists())
        note['publish_files']=[];c.write(a/'note.json',note);c.review(a,'/root/reviewer','note.json')

    def test_all_seventeen_production_scopes_required_for_full_publication(self):
        units=[]
        for n in range(17):
            unit=copy.deepcopy(self.units[n%2]);unit['package_id']=f'scope-{n}'
            assessment=self.base/f'full-assessment-{n}.json';c.write(assessment,{'package_id':unit['package_id'],'scopes':[unit['analysis_scope']]})
            item=self.base/f'full-item-{n}.json';c.write(item,{'output_header':{'package_id':unit['package_id']},'package_root':unit['package_root']})
            unit['source_assessment']={'path':str(assessment),'sha256':c.sha(assessment)}
            unit['source_work_item']={'path':str(item),'sha256':c.sha(item)};units.append(unit)
        manifest=self.base/'full-manifest.json';c.write(manifest,{'units':units});campaign=self.base/'seventeen'
        project=self.base/'git'
        public=project/'output/execution'
        c.write(project/'output/manifest.json',{'archive_root':'../archive',
                'active':{'execution':'output/execution'},'workflows':{'combined_exports':'.local/exports'}})
        with patch.object(c,'ROOT',project),patch.object(c,'BASE',campaign),patch.object(c,'PUBLICATION',public):
            c.initialize(manifest,campaign)
            for n,unit in enumerate(units):
                a=Path(c.prepare(unit['package_id'],'full',1,campaign=campaign,policy_path=self.policy)['attempt'])
                self.assign(a);c.finalize(a,'report_template.json')
                c.write(a/'note.json',{'source_checked':True,'execution_checked':True,'notes':['Synthetic no-run case.']})
                c.review(a,'/root/reviewer','note.json')
                if n==15:
                    with self.assertRaisesRegex(ValueError,'every selected'):c.publish(campaign)
            published=c.publish(campaign);self.assertEqual(published['packages'],17)
            public=Path(published['path'])
            reports=c.layout.batch_reports('execution',c.ROOT)/c.sha(public/'index.json')
            self.assertTrue((reports/'summary.md').is_file())
            self.assertFalse((public/'summary.md').exists())
            self.assertTrue((public/'attempts.jsonl').is_file())
            self.assertEqual(c.sha(public/'attempts.jsonl'),published['aggregate_sha256'])
            self.assertEqual(c.publish(campaign),published)

    def test_publication_restart_recovers_swap_before_campaign_save(self):
        self.completed('pkg-0','full',1);self.completed('pkg-1','full',1)
        with patch.object(c,'_save',side_effect=RuntimeError('fictional interruption after atomic swap')):
            with self.assertRaisesRegex(RuntimeError,'interruption'):c.publish(self.campaign)
        self.assertIsNone(c.read(self.campaign/'campaign.json')['publication'])
        self.assertEqual(c.publish(self.campaign)['packages'],2)
        self.assertEqual(c.read(self.campaign/'publication_transaction.json')['status'],'published')



    def test_local_overlay_preserves_publication_hash_and_read_only_verification(self):
        first,publication=self.publication_with_code()
        state=(self.campaign/'campaign.json').read_bytes()
        journal=(self.campaign/'publication_transaction.json').read_bytes()
        index=(publication/'index.json').read_bytes()
        self.add_local_overlay(publication)
        self.assertNotEqual(c.tree_hash(publication),first['tree_sha256'])
        original_scandir=c.os.scandir
        def protected_scandir(path):
            if Path(path).resolve() in {publication/'software',publication/'packages/pkg-0/work'}:
                raise AssertionError('Publication verification must not traverse local payloads')
            return original_scandir(path)
        with patch.object(c.os,'scandir',side_effect=protected_scandir):
            self.assertEqual(c.publication_tree_hash(publication),first['tree_sha256'])
            self.assertEqual(c.publish(self.campaign),first)
        self.assertEqual((self.campaign/'campaign.json').read_bytes(),state)
        self.assertEqual((self.campaign/'publication_transaction.json').read_bytes(),journal)
        self.assertEqual((publication/'index.json').read_bytes(),index)

    def test_local_overlay_does_not_exempt_protected_code_or_reports(self):
        first,publication=self.publication_with_code();self.add_local_overlay(publication)
        index=c.read(publication/'index.json')
        code=publication/index['packages']['pkg-0']['files'][0]['published_path']
        for path in (code,publication/'packages/pkg-0/report.json'):
            with self.subTest(path=path.name):
                original=path.read_bytes();path.chmod(0o644);path.write_text('tampered protected bytes')
                with self.assertRaisesRegex(ValueError,'Published files changed'):c.publish(self.campaign)
                path.write_bytes(original)
        self.assertEqual(c.publication_tree_hash(publication),first['tree_sha256'])

    def test_local_overlay_exclusions_do_not_accept_unexpected_files(self):
        first,publication=self.publication_with_code();self.add_local_overlay(publication)
        for relative in ('unexpected.txt','packages/unregistered/work/data.csv',
                         'packages/pkg-0/nested/local_inputs.json','packages/pkg-0/local_inputs.json.bak',
                         'packages/pkg-0/software/dependency.ado','__pycache__/unexpected.pyc'):
            with self.subTest(path=relative):
                path=publication/relative;path.parent.mkdir(parents=True,exist_ok=True);path.write_text('unexpected')
                with self.assertRaisesRegex(ValueError,'Published files changed'):c.publish(self.campaign)
                path.unlink()
        self.assertEqual(c.publication_tree_hash(publication),first['tree_sha256'])

    def test_future_publication_archives_overlay_without_rebuilding_it(self):
        first,publication=self.publication_with_code();self.add_local_overlay(publication)
        self.completed('pkg-0','full',2)
        second=c.publish(self.campaign);archive=Path(second['archive'])
        self.assertEqual(c.publication_tree_hash(archive),first['tree_sha256'])
        self.assertEqual((archive/'packages/pkg-0/work/inputs/sample.dta').read_text(),'Fictional local data.')
        self.assertTrue((archive/'software/library/package.ado').is_file())
        self.assertFalse((publication/'software').exists())
        self.assertFalse((publication/'packages/pkg-0/work').exists())
        self.assertFalse((publication/'packages/pkg-0/local_inputs.json').exists())

    def test_overlay_after_interrupted_swap_allows_verified_recovery(self):
        first,publication=self.publication_with_code();self.add_local_overlay(publication)
        self.completed('pkg-0','full',2);original=c._save
        def interrupted(campaign,state):
            if state.get('publication',{}).get('last_full_wave')==2:raise RuntimeError('fixture interrupted swap')
            return original(campaign,state)
        with patch.object(c,'_save',side_effect=interrupted):
            with self.assertRaisesRegex(RuntimeError,'fixture interrupted swap'):c.publish(self.campaign)
        self.add_local_overlay(publication)
        second=c.publish(self.campaign)
        self.assertEqual(second['last_full_wave'],2)
        self.assertEqual(c.publication_tree_hash(second['archive']),first['tree_sha256'])

    def test_local_overlay_names_remain_strict_inside_frozen_skill(self):
        attempt=self.prepare();snapshot=attempt/'skill_snapshot';before=c.tree_hash(snapshot)
        path=snapshot/'work/unregistered.txt';path.parent.mkdir();path.write_text('Not a publication overlay.')
        self.assertNotEqual(c.tree_hash(snapshot),before)
        with self.assertRaisesRegex(ValueError,'Frozen skill changed'):c._attempt(attempt)




    def test_frozen_runner_validation_is_preserved_before_running_status(self):
        a,p=self.ready();p['fixture_validation_failure']=True
        with self.assertRaisesRegex(ValueError,'missing reviewed ado mount'):self.approve(a,p)
        record=c.read(self.campaign/'campaign.json')['attempts'][p['attempt_id']]
        self.assertEqual(record['status'],'preflight_blocked')
        self.assertFalse(record['plan_reviews'][0]['runner_validation']['valid'])
        self.assertFalse((a/'runtime').exists())
        with self.assertRaisesRegex(ValueError,'failed frozen runner'):c.execute(a)
        p.pop('fixture_validation_failure');self.approve(a,p);c.execute(a);self.finish(a)
        self.assertEqual(len(c.read(self.campaign/'campaign.json')['attempts'][p['attempt_id']]['plan_reviews']),2)

    def test_prelaunch_runner_exception_can_reconcile_without_losing_error(self):
        a,p=self.ready();self.approve(a)
        def fail_before_launch(*args):raise ValueError('Fictional runtime policy setup failure')
        with patch.object(c,'_runner',return_value=type('Runner',(),{'run':staticmethod(fail_before_launch)})):
            with self.assertRaisesRegex(RuntimeError,'reconcile'):c.execute(a)
        self.assertFalse((a/'runtime/intent.json').exists());self.assertFalse((a/'runtime/run.json').exists())
        result=c.reconcile(a);self.assertEqual(result['recovery'],'prelaunch_runner_error')
        record=c.read(self.campaign/'campaign.json')['attempts'][p['attempt_id']]
        self.assertEqual(record['execution_history'][0]['error_type'],'ValueError')
        self.assertEqual(record['execution_history'][1]['preserved_error_event'],0)
        self.approve(a,p);c.execute(a);self.finish(a)

    def test_missing_receipt_after_native_intent_cannot_enable_retry(self):
        a,p=self.ready();self.approve(a)
        def fail_after_intent(attempt,plan):
            runtime=Path(attempt)/'runtime';runtime.mkdir();c.write(runtime/'intent.json',{'fixture':'native launch reserved'})
            raise ValueError('Fictional native failure before receipt')
        with patch.object(c,'_runner',return_value=type('Runner',(),{'run':staticmethod(fail_after_intent)})):
            with self.assertRaisesRegex(RuntimeError,'reconcile'):c.execute(a)
        with self.assertRaises(ValueError):c.reconcile(a)
        with self.assertRaisesRegex(ValueError,'first native launch'):self.approve(a,p)
        with self.assertRaisesRegex(ValueError,'cannot be repeated'):c.execute(a)
        self.assertTrue((a/'runtime/intent.json').exists())

    def test_host_policy_requires_explicit_exact_matlab_user_authorization(self):
        authorization,policy=self.host_policy();self.assertEqual(c._policy(self.policy),policy)
        original=c.read(authorization)
        for change in [{'approved':False},{'approved_by':None},{'approved_by':'agent'},{'languages':['r']},{'host_home':'/tmp'},
                       {'user_instruction':''},{'approved_at':'2026-11-17'}]:
            value=copy.deepcopy(original);value.update(change)
            if change.get('approved_by','user') is None:value.pop('approved_by')
            c.write(authorization,value)
            candidate=copy.deepcopy(policy);candidate['host_execution_authorization']['sha256']=c.sha(authorization)
            c.write(self.policy,candidate)
            with self.assertRaisesRegex(ValueError,'Host authorization'):c._policy(self.policy)
        c.write(authorization,original);c.write(self.policy,policy)
        for mutate in [lambda p:p.pop('host_execution_authorization'),
                       lambda p:p['allowed_executables'].update(r=['/usr/bin/Rscript']),
                       lambda p:p.update(sandbox_profiles=['bwrap','host']),
                       lambda p:p.update(network=True),lambda p:p.update(host_home='/tmp')]:
            candidate=copy.deepcopy(policy);mutate(candidate);c.write(self.policy,candidate)
            with self.assertRaises(ValueError):c._policy(self.policy)

    def test_host_prepare_freezes_authorization_and_truthful_provenance(self):
        source,policy=self.host_policy();original=source.read_bytes();attempt=self.prepare()
        item=c.read(attempt/'work_item.json');frozen=item['host_execution_authorization']
        self.assertEqual(Path(frozen['path']).read_bytes(),original)
        self.assertEqual(frozen['sha256'],policy['host_execution_authorization']['sha256'])
        runtime=c.read(item['runtime_policy']['path']);self.assertEqual(runtime['sandbox_profile'],'host')
        self.assertEqual(runtime['host_execution_authorization'],frozen)
        self.assertEqual(c.read(item['policy']['path'])['host_execution_authorization'],frozen)
        report=c.read(attempt/'report_template.json');self.assertIn(c.HOST_VISIBILITY_NOTE,report['review_notes'])
        self.assertEqual(report['provenance']['execution_profile'],'host')
        self.assertEqual(report['provenance']['host_execution_authorization_sha256'],frozen['sha256'])
        source.write_text('changed external record after authorized freezing');self.assign(attempt)
        Path(frozen['path']).chmod(0o644);Path(frozen['path']).write_text('{}')
        with self.assertRaisesRegex(ValueError,'Frozen file'):c.stage(attempt,['analysis.R'])

    def test_host_plan_rejects_mount_claims_bwrap_and_non_matlab_stages(self):
        attempt,plan=self.host_ready()
        for mutate in [lambda p:p['sandbox'].update(read_only_paths=[str(self.base)]),
                       lambda p:p['sandbox'].update(executable='/usr/bin/bwrap'),
                       lambda p:p['sandbox'].update(profile='bwrap'),
                       lambda p:p['stages'][0].update(language='r',executable='/usr/bin/Rscript')]:
            candidate=copy.deepcopy(plan);mutate(candidate)
            with self.assertRaises(ValueError):self.approve(attempt,candidate)
        self.approve(attempt,plan)

    def test_host_matlab_receipt_and_reports_must_describe_actual_visibility(self):
        attempt,plan=self.host_ready();self.approve(attempt);c.execute(attempt)
        report=self.report(attempt);self.assertEqual(self.finish(attempt,report)['outcome'],'completed')
        self.assertEqual(c.read(attempt/'runtime/run.json')['sandbox']['profile'],'host')

    def test_host_receipt_cannot_claim_false_isolation_or_lose_authorization(self):
        attempt,plan=self.host_ready();self.approve(attempt);c.execute(attempt)
        item=c.read(attempt/'work_item.json');record=c.read(self.campaign/'campaign.json')['attempts'][plan['attempt_id']]
        original=c.read(attempt/'runtime/run.json')
        for mutate in [lambda r:r['sandbox'].update(profile='bwrap'),
                       lambda r:r['sandbox'].update(network_disabled=True),
                       lambda r:r['sandbox'].update(filesystem_isolation=True),
                       lambda r:r.update(host_execution_authorization_unchanged=False),
                       lambda r:r['host_execution_authorization'].update(sha256='0'*64)]:
            changed=copy.deepcopy(original);mutate(changed);c.write(attempt/'runtime/run.json',changed)
            current=copy.deepcopy(record);current['runtime_receipt']['sha256']=c.sha(attempt/'runtime/run.json')
            report=self.report(attempt);report['run_receipt']=current['runtime_receipt']
            for stage in report['stage_results']:stage['receipt']=current['runtime_receipt']
            with self.assertRaisesRegex(ValueError,'truthfully bind'):c._validate_report(attempt,item,current,report)
        c.write(attempt/'runtime/run.json',original)
        report=self.report(attempt);report['review_notes']=[]
        with self.assertRaisesRegex(ValueError,'visibility note'):c._validate_report(attempt,item,record,report)

    def test_existing_bwrap_header_unchanged_and_host_receipts_rejected(self):
        attempt,plan=self.ready();self.approve(attempt);c.execute(attempt)
        item=c.read(attempt/'work_item.json');record=c.read(self.campaign/'campaign.json')['attempts'][plan['attempt_id']]
        self.assertNotIn('execution_profile',self.report(attempt)['provenance'])
        receipt=c.read(attempt/'runtime/run.json');receipt['sandbox']={'profile':'host'};c.write(attempt/'runtime/run.json',receipt)
        record['runtime_receipt']['sha256']=c.sha(attempt/'runtime/run.json');report=self.report(attempt)
        report['run_receipt']=record['runtime_receipt']
        for stage in report['stage_results']:stage['receipt']=record['runtime_receipt']
        with self.assertRaisesRegex(ValueError,'bwrap attempt'):c._validate_report(attempt,item,record,report)


if __name__=='__main__':unittest.main()
