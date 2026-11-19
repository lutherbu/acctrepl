import copy
import hashlib
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
MODULE = ROOT / 'skills/check-execution-feasibility/scripts/assessment.py'
spec = importlib.util.spec_from_file_location('execution_assessment', MODULE)
a = importlib.util.module_from_spec(spec)
spec.loader.exec_module(a)


class ExecutionAssessmentTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.code = self.root / 'package/main.do'
        self.code.parent.mkdir()
        self.code.write_text('* Private agency data cannot be publicly shared.\nuse "data.dta", clear\nregress y x\n')
        source_hash = a.sha256(self.code)
        self.probes = self.root / 'probes'; self.probes.mkdir()
        data = self.probes / 'data.json'
        data.write_text(json.dumps({'status':'ok','result':{'location':'data.dta','readable':True,'columns':['x','y'],'rows_read':1}}))
        env = self.probes / 'env.json'
        env.write_text(json.dumps({'status':'ok','result':{'software':{'Stata':{'available':True,'version':'18'}}}}))
        self.item = {'output_header': {'schema_version':'1.0','package_id':'test-package',
                        'provenance':{'package_sha256':source_hash,'skill_sha256':'f'*64}},
                     'work_dir':str(self.root),
                     'sources':[{'path':'main.do','sha256':source_hash,'original_path':str(self.code),
                                 'content_path':str(self.code),'content_sha256':source_hash}],
                     'dependencies':[{'id':'dep-data'}]}
        self.draft = {**copy.deepcopy(self.item['output_header']),
                      'requirements':[{'id':'req-data','kind':'data','description':'Author analysis input',
                                       'scopes':['full_pipeline'],'routes':[{'id':'route-packaged','type':'packaged','status':'verified',
                                         'location':'data.dta','description':'Provided analysis file','expected_fields':['x','y'],
                                         'evidence_ids':['ev-data']}]}],
                      'software':[{'id':'sw-stata','name':'Stata','status':'available','description':'Stata runtime','evidence_ids':['ev-env']}],
                      'issues':[],
                      'evidence':[{'id':'ev-code','kind':'source','file':'main.do','line_begin':2,'line_end':3,
                                   'quote':'use "data.dta", clear\nregress y x','description':'Entry point data and estimation'},
                                  {'id':'ev-data','kind':'probe','artifact_path':str(data),'sha256':a.sha256(data),'description':'Bounded packaged metadata'},
                                  {'id':'ev-env','kind':'probe','artifact_path':str(env),'sha256':a.sha256(env),'description':'Local software check'}],
                      'scopes':[{'id':'full_pipeline','description':'Full author workflow','entry_points':['main.do'],
                                 'requirement_ids':['req-data'],'software_ids':['sw-stata'],'issue_ids':[],
                                 'has_code':True,'closure_complete':True,'data_required':True,'evidence_ids':['ev-code']}],
                      'dependency_review':[{'dependency_id':'dep-data','scope_ids':['full_pipeline'],'disposition':'requirement',
                                            'target_ids':['req-data'],'evidence_ids':['ev-code'],'description':'Mandatory analysis input'}],
                      'actions':[], 'review_notes':[]}

    def tearDown(self):
        self.tmp.cleanup()

    def action(self, addresses, scopes=None, certainty='conditional', kind='clarification'):
        return {'id':'act-'+str(len(self.draft['actions'])+1),'scope_ids':scopes or ['full_pipeline'],
                'addresses':addresses,'kind':kind,'description':'Resolve the stated prerequisite',
                'certainty':certainty,'evidence_ids':['ev-code'],'edits':[],
                'steps':['Obtain the specified input or clarify its source.'],
                'validation':['Confirm the prerequisite before future author-program execution.']}

    def unknown_data(self):
        route = self.draft['requirements'][0]['routes'][0]
        route['type']='local'; route['status']='unverified'; route['evidence_ids']=['ev-code']
        self.draft['actions'].append(self.action(['req-data']))

    def test_local_ready_and_no_change_document(self):
        result = a.finalize(self.item, self.draft, self.root/'output')
        self.assertEqual(result['scopes'][0]['data_status'],'local_available')
        self.assertEqual(result['scopes'][0]['execution_readiness'],'ready_to_attempt')
        self.assertFalse(result['scopes'][0]['execution_verified'])
        text=(self.root/'output/patch_proposal.md').read_text()
        self.assertIn('No source changes',text)
        self.assertEqual(a.sha256(self.root/'output/patch_proposal.md'),result['patch_proposal']['sha256'])

    def test_proposal_does_not_modify_author_code(self):
        before = self.code.read_bytes()
        self.draft['issues']=[{'id':'issue-path','scope_ids':['full_pipeline'],'kind':'path','severity':'preparation',
                               'description':'Configure input path','evidence_ids':['ev-code']}]
        self.draft['scopes'][0]['issue_ids']=['issue-path']
        action=self.action(['issue-path'],certainty='supported',kind='source_edit')
        action['edits']=[{'file':'main.do','sha256':a.sha256(self.code),'line_begin':2,'line_end':2,
                          'before':'use "data.dta", clear','after':'use "data/data.dta", clear','reason':'Use the configured relative input path.'}]
        self.draft['actions']=[action]
        result=a.finalize(self.item,self.draft,self.root/'output')
        self.assertEqual(result['scopes'][0]['execution_readiness'],'preparation_required')
        self.assertEqual(self.code.read_bytes(),before)
        self.assertIn('Proposed replacement:',(self.root/'output/patch_proposal.md').read_text())
        self.assertEqual(sorted(p.name for p in (self.root/'output').iterdir()),['assessment.json','patch_proposal.md'])

    def workbook_entrypoint(self):
        """A tiny supplied formula fixture; the formula is never evaluated."""
        original=self.root/'package/computations.xlsx'
        with ZipFile(original,'w') as z:
            z.writestr('xl/worksheets/sheet1.xml','<worksheet><c r="A1"><f>1+1</f><v>PRIVATE_CACHED_VALUE</v></c></worksheet>')
        cached=self.root/'reading/computations.xlsx.txt';cached.parent.mkdir()
        cached.write_text('FORMULA Results!A1 1+1\n')
        self.item['sources']=[{'path':'computations.xlsx','kind':'code','sha256':a.sha256(original),
            'original_path':str(original),'content_path':str(cached),'content_sha256':a.sha256(cached),
            'locations':{'1':{'program_kind':'formula','sheet':'Results','cell':'A1'}}}]
        self.item['dependencies']=[]
        self.draft['requirements']=[];self.draft['dependency_review']=[]
        self.draft['evidence']=[{'id':'ev-code','kind':'source','file':'computations.xlsx','line_begin':1,'line_end':1,
            'quote':'FORMULA Results!A1 1+1','description':'Stored supplied formula at a workbook cell'},self.draft['evidence'][2]]
        env=self.probes/'env.json';env.write_text(json.dumps({'status':'ok','result':{'software':{'Excel':{'available':True}}}}))
        self.draft['evidence'][1]['sha256']=a.sha256(env)
        self.draft['software'][0]['name']='Excel';self.draft['software'][0]['description']='Fixture runtime metadata only'
        self.draft['scopes'][0].update(entry_points=['computations.xlsx'],requirement_ids=[],data_required=False)
        return original,cached

    def test_workbook_program_can_be_entrypoint_without_a_cli(self):
        original,_=self.workbook_entrypoint();before=original.read_bytes()
        result=a.finalize(self.item,self.draft,self.root/'output')
        self.assertEqual(result['scopes'][0]['entry_points'],['computations.xlsx'])
        self.assertEqual(result['scopes'][0]['execution_readiness'],'ready_to_attempt')
        self.assertFalse(result['scopes'][0]['execution_verified'])
        self.assertEqual(original.read_bytes(),before)

    def test_workbook_cached_text_cannot_receive_binary_source_edit(self):
        original,cached=self.workbook_entrypoint();before=original.read_bytes()
        self.draft['issues']=[{'id':'issue-cell','scope_ids':['full_pipeline'],'kind':'cell_change',
            'severity':'preparation','description':'A proposed cell change','evidence_ids':['ev-code']}]
        self.draft['scopes'][0]['issue_ids']=['issue-cell']
        action=self.action(['issue-cell'],certainty='supported',kind='source_edit')
        action['edits']=[{'file':'computations.xlsx','sha256':a.sha256(original),'line_begin':1,'line_end':1,
            'before':cached.read_text().strip(),'after':'FORMULA Results!A1 2+2','reason':'Fixture binary edit rejection'}]
        self.draft['actions']=[action]
        with self.assertRaisesRegex(ValueError,'Binary documentation'):
            a.finalize(self.item,self.draft,self.root/'output')
        self.assertEqual(original.read_bytes(),before)

    def test_word_container_with_script_suffix_cannot_receive_source_line_edit(self):
        cached = self.root/'reading/main.do.txt'
        cached.parent.mkdir()
        cached.write_bytes(self.code.read_bytes())
        with ZipFile(self.code,'w') as container:
            container.writestr('word/document.xml',
                               '<document><p>use "data.dta", clear</p></document>')
        before = self.code.read_bytes()
        source = self.item['sources'][0]
        source.update(sha256=a.sha256(self.code),content_path=str(cached),
                      content_sha256=a.sha256(cached))
        self.draft['issues']=[{'id':'issue-path','scope_ids':['full_pipeline'],'kind':'path',
                               'severity':'preparation','description':'Configure source input path',
                               'evidence_ids':['ev-code']}]
        self.draft['scopes'][0]['issue_ids']=['issue-path']
        action=self.action(['issue-path'],certainty='supported',kind='source_edit')
        action['edits']=[{'file':'main.do','sha256':a.sha256(self.code),
                          'line_begin':2,'line_end':2,'before':'use "data.dta", clear',
                          'after':'use "data/data.dta", clear',
                          'reason':'A cached text line is not a native line in the ZIP original.'}]
        self.draft['actions']=[action]
        with self.assertRaisesRegex(ValueError,'Binary documentation'):
            a.finalize(self.item,self.draft,self.root/'output')
        self.assertEqual(self.code.read_bytes(),before)
        self.assertFalse((self.root/'output').exists())

    def test_unknown_unused_alternative_does_not_defeat_local(self):
        self.draft['requirements'][0]['routes'].append({'id':'route-alt','type':'local','status':'unverified','location':'elsewhere',
                                                       'description':'Unneeded alternative','evidence_ids':['ev-code']})
        self.assertEqual(a.finalize(self.item,self.draft)['requirements'][0]['outcome'],'local_available')

    def test_grouped_dependency_review_preserves_exhaustive_coverage(self):
        self.item['dependencies'].append({'id':'dep-data-again'})
        review=self.draft['dependency_review'][0]
        del review['dependency_id']
        review['dependency_ids']=['dep-data','dep-data-again']
        self.assertEqual(a.finalize(self.item,self.draft)['scopes'][0]['data_status'],'local_available')
        review['dependency_ids']=['dep-data']
        with self.assertRaisesRegex(ValueError,'Unreviewed frozen dependencies'):
            a.finalize(self.item,self.draft)
        review['dependency_ids']=['dep-data','invented']
        with self.assertRaisesRegex(ValueError,'non-frozen dependency'):
            a.finalize(self.item,self.draft)

    def test_grouped_review_cannot_supply_both_id_forms(self):
        self.draft['dependency_review'][0]['dependency_ids']=['dep-data']
        with self.assertRaises(a.jsonschema.ValidationError):
            a.finalize(self.item,self.draft)

    def test_public_route_and_action(self):
        self.draft['evidence'].append({'id':'ev-public','kind':'public','description':'Public archive metadata',
                                       'url':'https://example.org/archive','checked_at':'2026-11-07','authority':'official',
                                       'quote':'Annual data archives are available for download.'})
        self.draft['requirements'][0]['routes']=[{'id':'route-public','type':'public','status':'verified',
                                                 'location':'https://example.org/archive','description':'Download matching archive',
                                                 'evidence_ids':['ev-public']}]
        self.draft['actions']=[self.action(['req-data'],certainty='supported',kind='data_acquisition')]
        result=a.finalize(self.item,self.draft)
        self.assertEqual(result['scopes'][0]['data_status'],'public_acquisition_required')
        self.assertEqual(result['scopes'][0]['execution_readiness'],'preparation_required')

    def test_restricted_barrier_requires_positive_evidence(self):
        self.draft['evidence'].append({'id':'ev-private','kind':'source','description':'Author states access restriction',
                                       'file':'main.do','line_begin':1,'line_end':1,
                                       'quote':'Private agency data cannot be publicly shared.','access_barrier':True})
        self.draft['requirements'][0]['routes']=[{'id':'route-private','type':'restricted','status':'blocked','location':'private agency',
                                                 'description':'Private contract required','evidence_ids':['ev-private']}]
        self.draft['actions']=[self.action(['req-data'],certainty='blocked',kind='access_request')]
        self.assertEqual(a.finalize(self.item,self.draft)['scopes'][0]['execution_readiness'],'blocked')
        self.draft['evidence'][-1]['kind']='catalog'
        with self.assertRaisesRegex(ValueError,'explicit source/public'):
            a.finalize(self.item,self.draft)

    def test_unknown_alternative_prevents_restricted_conclusion(self):
        req=self.draft['requirements'][0]
        req['routes']=[{'id':'x','type':'restricted','status':'blocked','location':'private','description':'restricted','evidence_ids':[]},
                       {'id':'y','type':'local','status':'unverified','location':'candidate','description':'unknown','evidence_ids':[]}]
        self.assertEqual(a.requirement_outcome(req),'undetermined')

    def test_analysis_only_does_not_establish_full_pipeline(self):
        self.unknown_data()
        full=self.draft['scopes'][0]
        analysis=copy.deepcopy(full);analysis['id']='analysis_only';analysis['description']='Provided analysis data only'
        self.draft['requirements'].append({'id':'req-prepared','kind':'data','description':'Provided analysis input',
                                           'scopes':['analysis_only'],'routes':[{'id':'route-prepared','type':'packaged','status':'verified',
                                             'location':'data.dta','description':'Provided input','evidence_ids':['ev-data']}]})
        analysis['requirement_ids']=['req-prepared']
        self.draft['scopes'].append(analysis)
        result=a.finalize(self.item,self.draft)
        self.assertEqual([s['execution_readiness'] for s in result['scopes']],['undetermined','ready_to_attempt'])

    def test_missing_code_is_not_a_data_access_barrier(self):
        self.item['dependencies']=[]
        self.draft['dependency_review']=[];self.draft['requirements']=[];self.draft['software']=[]
        s=self.draft['scopes'][0];s.update(entry_points=[],requirement_ids=[],software_ids=[],has_code=False,data_required=False,
                                          issue_ids=['issue-no-code'])
        self.draft['issues']=[{'id':'issue-no-code','scope_ids':['full_pipeline'],'kind':'missing_code',
                               'description':'No executable source provided','severity':'blocking','evidence_ids':['ev-code']}]
        self.draft['actions']=[self.action(['issue-no-code'])]
        result=a.finalize(self.item,self.draft)
        self.assertEqual(result['scopes'][0]['data_status'],'not_applicable')
        self.assertEqual(result['scopes'][0]['execution_readiness'],'no_runnable_code')
        self.assertIn('missing_code',str(result['issues']))

    def test_software_unknown_keeps_data_local(self):
        sw=self.draft['software'][0];sw['status']='unverified';sw['evidence_ids']=['ev-code']
        self.draft['actions']=[self.action(['sw-stata'])]
        result=a.finalize(self.item,self.draft)
        self.assertEqual(result['scopes'][0]['data_status'],'local_available')
        self.assertEqual(result['scopes'][0]['execution_readiness'],'undetermined')

    def test_forged_readiness_claim_rejected(self):
        self.unknown_data()
        self.draft['scopes'][0]['execution_readiness']='ready_to_attempt'
        with self.assertRaisesRegex(ValueError,'submitted readiness'):
            a.finalize(self.item,self.draft)

    def test_wrong_probe_fields_rejected(self):
        self.draft['requirements'][0]['routes'][0]['expected_fields'].append('absent')
        with self.assertRaisesRegex(ValueError,'matching readable probe'):
            a.finalize(self.item,self.draft)

    def test_bad_source_quote_rejected(self):
        self.draft['evidence'][0]['quote']='not in this source'
        with self.assertRaisesRegex(ValueError,'quote does not match'):
            a.finalize(self.item,self.draft)

    def test_stale_source_rejected(self):
        self.code.write_text('changed source')
        with self.assertRaisesRegex(ValueError,'Stale source'):
            a.finalize(self.item,self.draft)

    def test_stale_artifact_rejected(self):
        Path(self.draft['evidence'][1]['artifact_path']).write_text('{}')
        with self.assertRaisesRegex(ValueError,'Stale source/artifact'):
            a.finalize(self.item,self.draft)

    def test_missing_action_rejected(self):
        self.unknown_data();self.draft['actions']=[]
        with self.assertRaisesRegex(ValueError,'lack proposal actions'):
            a.finalize(self.item,self.draft)

    def test_unreviewed_dependency_rejected(self):
        self.draft['dependency_review']=[]
        with self.assertRaisesRegex(ValueError,'Unreviewed frozen'):
            a.finalize(self.item,self.draft)

    def test_catalog_cannot_prove_local_readability(self):
        self.draft['requirements'][0]['routes'][0]['evidence_ids']=['ev-code']
        with self.assertRaisesRegex(ValueError,'matching readable probe'):
            a.finalize(self.item,self.draft)

    def test_no_auto_applied_patch_claim(self):
        self.draft['patch_proposal']={'path':'patch_proposal.md','sha256':'a'*64,'applied':True}
        with self.assertRaisesRegex(ValueError,'cannot report an applied'):
            a.finalize(self.item,self.draft)

    def test_provenance_guard(self):
        self.draft['provenance']['package_sha256']='a'*64
        with self.assertRaisesRegex(ValueError,'Provenance differs'):
            a.finalize(self.item,self.draft)

    def test_output_may_not_contain_originals(self):
        with self.assertRaisesRegex(ValueError,'contains original source'):
            a.finalize(self.item,self.draft,self.root)

    def test_no_data_simulation_still_needs_runtime(self):
        self.item['dependencies']=[];self.draft['requirements']=[];self.draft['dependency_review']=[]
        self.draft['scopes'][0].update(data_required=False,requirement_ids=[])
        self.assertEqual(a.finalize(self.item,self.draft)['scopes'][0]['data_status'],'not_applicable')
        self.draft['scopes'][0]['software_ids']=[]
        with self.assertRaisesRegex(ValueError,'required runtime'):
            a.finalize(self.item,self.draft)

    def test_incomplete_closure_needs_issue(self):
        self.draft['scopes'][0]['closure_complete']=False
        with self.assertRaisesRegex(ValueError,'Incomplete closure'):
            a.finalize(self.item,self.draft)

    def test_generated_dependency_needs_source_producer(self):
        self.draft['dependency_review'][0].update(disposition='generated',target_ids=[],evidence_ids=['ev-data'])
        with self.assertRaisesRegex(ValueError,'source evidence for its producer'):
            a.finalize(self.item,self.draft)

    def test_cell_edit_guard(self):
        self.item['sources'][0]['path']='main.ipynb'
        self.item['sources'][0]['locations']={'2':{'cell_id':'one'}}
        self.draft['evidence'][0]['file']='main.ipynb'
        self.draft['scopes'][0]['entry_points']=['main.ipynb']
        self.draft['issues']=[{'id':'issue-path','scope_ids':['full_pipeline'],'kind':'path','severity':'preparation',
                               'description':'Configure path','evidence_ids':['ev-code']}]
        self.draft['scopes'][0]['issue_ids']=['issue-path']
        action=self.action(['issue-path'],certainty='supported',kind='source_edit')
        action['edits']=[{'file':'main.ipynb','sha256':a.sha256(self.code),'line_begin':2,'line_end':2,'cell_id':'wrong',
                          'before':'use "data.dta", clear','after':'use "data/data.dta", clear','reason':'Relative path'}]
        self.draft['actions']=[action]
        with self.assertRaisesRegex(ValueError,'mismatches a frozen cell'):
            a.finalize(self.item,self.draft)


    def test_outputs_stay_inside_assigned_directory(self):
        self.item['package_root']=str(self.code.parent)
        self.item['output_dir']=str(self.root/'output')
        with self.assertRaisesRegex(ValueError,'assigned work directory'):
            a.finalize(self.item,self.draft,self.root.parent/'outside-output')
        with self.assertRaisesRegex(ValueError,'assigned output directory'):
            a.finalize(self.item,self.draft,self.root/'elsewhere')
        self.item.pop('output_dir')
        with self.assertRaisesRegex(ValueError,'protected'):
            a.finalize(self.item,self.draft,self.code.parent/'nested-output')
        a.finalize(self.item,self.draft,self.root/'output')


if __name__ == '__main__':
    unittest.main()
