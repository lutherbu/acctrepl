"""Mechanical conversion preserves verdicts, target units and input publications."""
import copy
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('normalize_feasibility',ROOT/'scripts/normalize_feasibility.py')
n = importlib.util.module_from_spec(spec)
spec.loader.exec_module(n)


def fit(status='undetermined', result='fit1', *, model='model', ready=False):
    return {'model_id':model,'result_set_id':result,'data_status':status,'attempt_ready':ready,
            'data_mode':'synthetic_only' if status=='no_observed_data_required' else 'observed'}


def replication(fits=None, *, pid='W1', eligibility='eligible'):
    fits = [fit()] if fits is None else fits
    return {'paper_id':pid,'doi':None,'eligibility':eligibility,'assessments':fits,
            'requirements':[] if eligibility=='no_baseline' else [{'requirement_id':'r1'}],
            'summary':{'outcome':'not_applicable' if eligibility=='no_baseline' else 'undetermined'}}


def scope(status='undetermined', *, sid='full_pipeline', readiness='undetermined'):
    return {'id':sid,'data_status':status,'data_required':status!='not_applicable',
            'has_code':readiness!='no_runnable_code','execution_readiness':readiness,
            'execution_verified':False}


def execution(scopes=None, *, pid='jar-1'):
    return {'package_id':pid,'doi':'10.0000/fixture','scopes':[scope()] if scopes is None else scopes}


class CommonClassificationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.rep = self.base/'replication/published.jsonl'
        self.exe = self.base/'execution/published.jsonl'
        self.schema = self.base/'policy/classification.schema.json'
        self.output = self.base/'derived/common'
        self.archive = self.base/'history'
        for path in (self.rep,self.exe,self.schema):path.parent.mkdir(parents=True)
        shutil.copy2(ROOT/'skills/check-replication-feasibility/references/feasibility_classification.schema.json',self.schema)
        self.save([replication()],[execution()])

    def save(self, rep, exe):
        self.rep.write_text(''.join(json.dumps(v)+'\n' for v in rep))
        self.exe.write_text(''.join(json.dumps(v)+'\n' for v in exe))

    def export(self, **kwargs):
        return n.export(self.rep,self.exe,self.schema,self.output,archive_root=self.archive,**kwargs)

    def rows(self):
        return [json.loads(line) for line in (self.output/'assessments.jsonl').read_text().splitlines()]

    def test_all_saved_labels_use_single_policy_mapping(self):
        schema=json.loads(self.schema.read_text())
        repkeys=list(schema['x_status_mappings']['independent_reconstruction'])
        exekeys=list(schema['x_status_mappings']['author_package'])
        self.save([replication([fit(s,str(i)) for i,s in enumerate(repkeys)])],
                  [execution([scope(s,sid='full_pipeline')],pid='jar-'+str(i)) for i,s in enumerate(exekeys)])
        original=(self.rep.read_bytes(),self.exe.read_bytes())
        self.export();rows=self.rows()
        self.assertEqual([r['data_status'] for r in rows[:len(repkeys)]],
                         list(schema['x_status_mappings']['independent_reconstruction'].values()))
        self.assertEqual([r['data_status'] for r in rows[len(repkeys):]],
                         list(schema['x_status_mappings']['author_package'].values()))
        self.assertEqual(original,(self.rep.read_bytes(),self.exe.read_bytes()))
        self.assertEqual((self.output/'classification.schema.json').read_bytes(),self.schema.read_bytes())

    def test_no_baseline_is_eligibility_not_no_observed_data(self):
        self.save([replication([],pid='W0',eligibility='no_baseline'),
                   replication([fit('no_observed_data_required')])],[execution([scope('not_applicable')])])
        self.export();rows=self.rows()
        self.assertIsNone(rows[0]['data_status']);self.assertEqual(rows[0]['eligibility'],'no_baseline')
        self.assertEqual(rows[0]['scope'],'paper_eligibility')
        self.assertEqual(rows[1]['data_status'],'no_observed_data_required')
        self.assertEqual(rows[2]['data_status'],'no_observed_data_required')
        summary=json.loads((self.output/'summary.json').read_text())
        group=next(g for g in summary['groups'] if g['scope']=='paper_eligibility')
        self.assertEqual(sum(group['data_status'].values()),0)

    def test_null_fit_identifier_is_preserved_and_distinct(self):
        self.save([replication([fit(result=None),fit(result='fit1')])],[execution()])
        self.export();rows=self.rows()
        self.assertIsNone(rows[0]['result_set_id']);self.assertEqual(rows[1]['result_set_id'],'fit1')

    def test_independent_ready_does_not_certify_execution_or_software(self):
        self.save([replication([fit('local_ready',ready=True)])],
                  [execution([scope('local_available',readiness='no_runnable_code')])])
        self.export();rep,exe=self.rows()
        self.assertEqual(rep['execution_readiness'],'not_assessed')
        self.assertIsNone(rep['execution_verified']);self.assertIs(rep['independent_attempt_ready'],True)
        self.assertEqual(exe['data_status'],'local_available')
        self.assertEqual(exe['execution_readiness'],'no_runnable_code')
        self.assertIs(exe['execution_verified'],False)

    def test_uncertainty_and_evidence_profiles_are_preserved(self):
        self.export();rep,exe=self.rows()
        self.assertEqual(rep['data_status'],'undetermined');self.assertEqual(exe['data_status'],'undetermined')
        self.assertEqual(rep['original']['data_status'],'undetermined')
        self.assertEqual(rep['evidence_profile'],'reconstruction_dimensions')
        self.assertEqual(exe['evidence_profile'],'author_workflow_compatibility')

    def test_grouped_units_and_denominators_remain_separate(self):
        self.save([replication([fit(result='a'),fit(result='b')]),
                   replication([],pid='W0',eligibility='no_baseline')],
                  [execution([scope('local_available'),scope('undetermined',sid='analysis_only')])])
        self.export();summary=json.loads((self.output/'summary.json').read_text())
        self.assertEqual(summary['normalized_records'],5)
        byscope={g['scope']:g for g in summary['groups']}
        self.assertEqual(byscope['baseline_fit']['records'],2)
        self.assertEqual(byscope['baseline_fit']['subjects'],1)
        self.assertEqual(byscope['full_pipeline']['records'],1)
        self.assertEqual(byscope['analysis_only']['records'],1)
        self.assertEqual(byscope['paper_eligibility']['records'],1)

    def test_line_numbers_and_exact_original_byte_checksums(self):
        raw=b'\n'+json.dumps(replication()).encode()+b'\r\n'
        self.rep.write_bytes(raw);self.export();row=self.rows()[0]
        self.assertEqual(row['source']['line'],2)
        self.assertEqual(row['source']['sha256'],n.sha256(self.rep))
        import hashlib
        self.assertEqual(row['source']['line_sha256'],hashlib.sha256(raw.splitlines(keepends=True)[1]).hexdigest())

    def test_unknown_labels_fail_without_output_or_input_change(self):
        for source in ('rep','exe'):
            with self.subTest(source=source):
                a=replication([fit('invented')]) if source=='rep' else replication()
                b=execution([scope('invented')]) if source=='exe' else execution()
                self.save([a],[b]);before=(self.rep.read_bytes(),self.exe.read_bytes())
                with self.assertRaisesRegex(ValueError,'Unknown saved data status'):self.export()
                self.assertFalse(self.output.exists());self.assertEqual(before,(self.rep.read_bytes(),self.exe.read_bytes()))

    def test_duplicate_fit_scope_or_document_rejected(self):
        cases=[([replication([fit(result=None),fit(result=None)])],[execution()]),
               ([replication()],[execution([scope(),scope()])]),
               ([replication(),replication()],[execution()])]
        for a,b in cases:
            self.save(a,b)
            with self.assertRaisesRegex(ValueError,'Duplicate saved'):self.export()
        self.assertFalse(self.output.exists())

    def test_no_baseline_with_fits_or_requirements_is_rejected(self):
        a=replication([],eligibility='no_baseline');a['requirements']=[{'requirement_id':'r'}]
        self.save([a],[execution()])
        with self.assertRaisesRegex(ValueError,'No-baseline'):self.export()
        a=replication([fit()],eligibility='no_baseline');self.save([a],[execution()])
        with self.assertRaisesRegex(ValueError,'No-baseline'):self.export()

    def test_na_requires_explicit_no_observed_data_and_no_code_stays_separate(self):
        b=execution([scope('not_applicable')]);b['scopes'][0]['data_required']=True
        self.save([replication()],[b])
        with self.assertRaisesRegex(ValueError,'data_required'):self.export()
        b=execution([scope('undetermined',readiness='no_runnable_code')]);self.save([replication()],[b])
        self.export();self.assertEqual(self.rows()[1]['data_status'],'undetermined')

    def test_boolean_and_fit_identity_types_are_not_coerced(self):
        for key,value in [('attempt_ready','false'),('model_id',None),('result_set_id',7)]:
            a=replication();a['assessments'][0][key]=value;self.save([a],[execution()])
            with self.assertRaises(ValueError):self.export()

    def test_invalid_container_types_are_rejected_as_validation_errors(self):
        for key,value in [('id',[]),('execution_readiness',{}),('data_required','false')]:
            b=execution();b['scopes'][0][key]=value;self.save([replication()],[b])
            with self.assertRaises(ValueError):self.export()

    def test_schema_rejects_in_scope_paper_sentinel_and_unassessed_author_code(self):
        self.save([replication([],eligibility='no_baseline')],[execution()]);self.export()
        _,_,_,validator=n.load_schema(self.schema)
        sentinel,author=self.rows()
        invalid=copy.deepcopy(sentinel);invalid['eligibility']='in_scope';invalid['data_status']='local_available'
        self.assertTrue(list(validator.iter_errors(invalid)))
        invalid=copy.deepcopy(author);invalid['execution_readiness']='not_assessed'
        self.assertTrue(list(validator.iter_errors(invalid)))
        invalid=copy.deepcopy(author);invalid['execution_verified']=None
        self.assertTrue(list(validator.iter_errors(invalid)))

    def test_execution_verification_is_not_inferred_or_accepted_from_static_input(self):
        b=execution();b['scopes'][0]['execution_verified']=True;self.save([replication()],[b])
        with self.assertRaisesRegex(ValueError,'execution_verified'):self.export()

    def test_policy_invalid_target_and_remote_reference_are_refused(self):
        original=json.loads(self.schema.read_text())
        bad=copy.deepcopy(original);bad['x_status_mappings']['author_package']['local_available']='invented'
        self.schema.write_text(json.dumps(bad))
        with self.assertRaisesRegex(ValueError,'mapping targets'):self.export()
        bad=copy.deepcopy(original);bad['properties']['subject_id']={'$ref':'https://example.invalid/no-fetch'}
        self.schema.write_text(json.dumps(bad))
        with self.assertRaisesRegex(ValueError,'no network'):self.export()

    def test_output_must_not_enter_or_replace_authoritative_input_directory(self):
        for path in (self.rep,self.rep.parent,self.rep.parent/'new',self.base):
            with self.subTest(path=path):
                with self.assertRaises(ValueError):
                    n.export(self.rep,self.exe,self.schema,path,archive_root=self.archive)

    def test_only_reserved_classification_child_can_share_replication_parent(self):
        original=(self.rep.read_bytes(),self.exe.read_bytes())
        target=self.rep.parent/'classification'
        result=n.export(self.rep,self.exe,self.schema,target,archive_root=self.archive)
        self.assertEqual(result['status'],'written')
        self.assertEqual(original,(self.rep.read_bytes(),self.exe.read_bytes()))
        for forbidden in (self.rep.parent/'resources',self.rep.parent/'classification'/'nested',
                          self.exe.parent/'classification',self.schema.parent/'classification'):
            with self.subTest(path=forbidden):
                with self.assertRaises(ValueError):
                    n.export(self.rep,self.exe,self.schema,forbidden,archive_root=self.archive)

    def test_symlink_input_and_output_refused(self):
        alias=self.base/'rep-alias.jsonl';alias.symlink_to(self.rep)
        with self.assertRaisesRegex(ValueError,'symlink'):
            n.export(alias,self.exe,self.schema,self.output)
        target=self.base/'real-output';target.mkdir();self.output.parent.mkdir(parents=True)
        self.output.symlink_to(target,target_is_directory=True)
        with self.assertRaisesRegex(ValueError,'symlink'):self.export()

    def test_identical_export_is_idempotent_and_different_output_needs_overwrite(self):
        first=self.export();before={p.name:p.read_bytes() for p in self.output.iterdir()}
        self.assertEqual(first['status'],'written')
        self.assertEqual(self.export()['status'],'unchanged')
        self.assertEqual(before,{p.name:p.read_bytes() for p in self.output.iterdir()})
        (self.output/'summary.md').write_text('changed derived report')
        with self.assertRaisesRegex(ValueError,'--overwrite'):self.export()
        self.assertEqual((self.output/'summary.md').read_text(),'changed derived report')

    def test_overwrite_preserves_previous_derived_bytes(self):
        self.export();(self.output/'summary.md').write_text('old derived bytes')
        result=self.export(overwrite=True)
        archive=Path(result['archive']);self.assertTrue(archive.is_dir())
        self.assertEqual((archive/'summary.md').read_text(),'old derived bytes')
        self.assertNotEqual((self.output/'summary.md').read_text(),'old derived bytes')

    def test_failed_new_publish_never_changes_inputs_or_leaves_partial_output(self):
        before=(self.rep.read_bytes(),self.exe.read_bytes())
        with patch.object(n.os,'replace',side_effect=OSError('fictional atomic-swap failure')):
            with self.assertRaises(OSError):self.export()
        self.assertFalse(self.output.exists())
        self.assertEqual(before,(self.rep.read_bytes(),self.exe.read_bytes()))
        self.assertEqual(list(self.output.parent.glob('.common.stage.*')),[])

    def test_failed_overwrite_restores_previous_derived_output(self):
        self.export();(self.output/'summary.md').write_text('preserve old report')
        before={p.name:p.read_bytes() for p in self.output.iterdir()};actual=n.os.replace
        def fail_stage(source,target):
            if '.stage.' in Path(source).name:raise OSError('fictional stage failure')
            return actual(source,target)
        with patch.object(n.os,'replace',side_effect=fail_stage):
            with self.assertRaises(OSError):self.export(overwrite=True)
        self.assertEqual(before,{p.name:p.read_bytes() for p in self.output.iterdir()})

    def test_modified_input_during_export_is_rejected_before_output(self):
        original=n.summarize
        def mutate(*args,**kwargs):
            result=original(*args,**kwargs);self.rep.write_text('changed source after snapshot\n');return result
        with patch.object(n,'summarize',side_effect=mutate):
            with self.assertRaisesRegex(ValueError,'changed before output'):self.export()
        self.assertFalse(self.output.exists())

    def test_metadata_schema_definition_order_cannot_swap_report_columns(self):
        schema=json.loads(self.schema.read_text())
        schema['x_data_labels']=dict(reversed(list(schema['x_data_labels'].items())))
        self.schema.write_text(json.dumps(schema))
        self.save([replication([fit('local_ready')])],[execution()]);self.export()
        text=(self.output/'summary.md').read_text()
        self.assertIn('| independent_reconstruction | baseline_fit | 1 | 1 | 1 | 0 | 0 | 0 | 0 |',text)

    def test_reordered_policy_labels_keep_header_counts_aligned(self):
        schema=json.loads(self.schema.read_text())
        schema['$defs']['data_status']['enum'].reverse()
        self.schema.write_text(json.dumps(schema))
        self.save([replication([fit('local_ready')])],[execution()]);self.export()
        table=[line for line in (self.output/'summary.md').read_text().splitlines() if line.startswith('|')]
        cells=lambda line:[x.strip() for x in line.strip('|').split('|')]
        header=cells(table[0]);row=cells(next(line for line in table if 'baseline_fit' in line))
        values=dict(zip(header,row))
        self.assertEqual(values['local available'],'1')
        self.assertEqual(values['no observed data required'],'0')
        self.assertEqual(len(header),len(cells(table[1])))


if __name__=='__main__':
    unittest.main()
