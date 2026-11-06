"""Behavioral checks for lossless variable-centered layouts and publication."""
import contextlib
from copy import deepcopy
import importlib.util
import io
import json
from pathlib import Path
import sys
import tempfile
import unittest
import subprocess

from test_model_results import fixture, SCRIPTS, EVIDENCE
import test_model_results_runs as campaign_tests

manager = campaign_tests.manager

sys.path.insert(0, str(SCRIPTS))
import convert_schema as layout
import derive_statistics as calculator
import validate_variable_results as validator

spec = importlib.util.spec_from_file_location('model_conversion_cli', Path(__file__).resolve().parents[1] / 'scripts/convert_model_results.py')
cli = importlib.util.module_from_spec(spec); spec.loader.exec_module(cli)


class ConversionTests(unittest.TestCase):
    def setUp(self):
        self.base, self.raw, self.data, self.paper = fixture()

    def assert_roundtrip(self, record):
        converted = layout.to_v3(record)
        self.assertEqual(layout.canonical(record), layout.canonical(layout.to_v2(converted)))
        return converted

    def test_values_evidence_roles_and_fits_survive(self):
        data = self.assert_roundtrip(self.data)
        self.assertEqual([], validator.validate(data, self.paper, base=self.base))
        model = data['models'][0]; v = model['independent_variables'][0]
        self.assertEqual(self.data['models'][0]['independent_variables'][0]['definition'], v['definition'])
        self.assertTrue(v['is_research_interest'])
        self.assertEqual('r1', v['results'][0]['result_set_id'])
        self.assertEqual('0.20', v['results'][0]['reported']['estimate']['text'])
        self.assertEqual(33.3, v['statistics'][0]['values'][2]['percentile'])
        self.assertEqual('a', model['intercept_results'][0]['parameter_id'])
        self.assertNotIn('parameters', model['result_sets'][0])

    def test_shared_descriptions_keep_both_models_and_link_order(self):
        data = deepcopy(self.data); second = deepcopy(data['models'][0]); second['model_id'] = 'M2'; data['models'].append(second)
        group = data['descriptive_statistics'][0]; group['model_ids'].append('M2')
        group['variables'][0]['variable_links'].insert(0, {'model_id': 'M2', 'variable_id': 'iv_001', 'relation': 'raw_version'})
        new = self.assert_roundtrip(data)
        self.assertEqual('raw_version', new['models'][1]['independent_variables'][0]['statistics'][0]['variable_relation'])
        new['models'][1]['independent_variables'][0]['statistics'][0]['values'][0]['cell']['value'] = 99
        with self.assertRaisesRegex(ValueError, 'conflicting shared descriptive'):
            layout.to_v2(new)

    def test_shared_parameter_copies_are_checked(self):
        data = deepcopy(self.data); model = data['models'][0]
        another = deepcopy(model['independent_variables'][0]); another['variable_id'] = 'iv_002'; another['name'] = 'Z'; model['independent_variables'].append(another)
        model['results']['result_sets'][0]['parameters'][0]['variable_ids'].append('iv_002')
        new = self.assert_roundtrip(data)
        new['models'][0]['independent_variables'][1]['results'][0]['reported']['estimate']['value'] = 8
        with self.assertRaisesRegex(ValueError, 'conflicting shared parameter'):
            layout.to_v2(new)

    def test_joint_tests_stay_model_level_single_variable_tests_move(self):
        data = deepcopy(self.data); pars = data['models'][0]['results']['result_sets'][0]['parameters']
        one = deepcopy(pars[0]); one.update(parameter_id='test_x', target_kind='auxiliary'); pars.append(one)
        joint = deepcopy(one); joint.update(parameter_id='joint', variable_ids=['dv', 'iv_001']); pars.append(joint)
        new = self.assert_roundtrip(data); model = new['models'][0]
        self.assertEqual(['x', 'test_x'], [p['parameter_id'] for p in model['independent_variables'][0]['results']])
        self.assertEqual(['joint'], [p['parameter_id'] for p in model['auxiliary_results']])

    def test_missing_or_misplaced_results_and_descriptions_are_rejected(self):
        new = layout.to_v3(self.data); new['models'][0]['independent_variables'][0]['results'] = []
        self.assertTrue(validator.validate(new))
        new = layout.to_v3(self.data); new['models'][0]['dependent_variable']['results'] = new['models'][0]['independent_variables'][0]['results']; new['models'][0]['independent_variables'][0]['results'] = []
        self.assertTrue(validator.validate(new))
        new = layout.to_v3(self.data); new['models'][0]['independent_variables'][0]['statistics'] = []
        self.assertTrue(validator.validate(new))

    def test_multiple_horizons_and_descriptive_samples_survive(self):
        data = deepcopy(self.data); rs = deepcopy(data['models'][0]['results']['result_sets'][0]); rs['result_set_id'] = 'h2'; rs['horizon'] = 'two years'; data['models'][0]['results']['result_sets'].append(rs)
        group = deepcopy(data['descriptive_statistics'][0]); group.update(group_id='other', period='1990–2000', sample_relation='broader'); group['variables'][0]['units'] = 'percent'; data['descriptive_statistics'].append(group)
        new = self.assert_roundtrip(data); v = new['models'][0]['independent_variables'][0]
        self.assertEqual(['r1', 'h2'], [p['result_set_id'] for p in v['results']])
        self.assertEqual(['d1', 'other'], [p['source_group_id'] for p in v['statistics']])

    def test_recalculation_preserves_numerics_and_detects_manual_changes(self):
        new = layout.to_v3(self.data)
        self.assertEqual(layout.canonical(new), layout.canonical(calculator.calculate(new)))
        new['models'][0]['independent_variables'][0]['results'][0]['derived']['standard_error'] = 99
        self.assertTrue(any('derived statistics differ' in e for e in validator.validate(new)))

    def test_supporting_empty_and_no_baseline_records_survive(self):
        data = deepcopy(self.data); model = deepcopy(data['models'][0]); model.update(model_id='support', model_role='supporting'); model['results'].update(status='not_requested', result_sets=[]); data['models'].append(model)
        self.assert_roundtrip(data)
        data.update(models=[], descriptive_statistics=[], status='no_baseline_regression', results_status='no_baseline_regression', descriptive_status='not_applicable')
        self.assert_roundtrip(data)

    def test_jsonl_cli_order_reverse_and_failed_conversion_preserve_files(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); source = root/'input.jsonl'; target = root/'output.jsonl'; reverse = root/'reverse.jsonl'
            second = deepcopy(self.data); second['paper_id'] = 'W2'
            source.write_text(''.join(json.dumps(d)+'\n' for d in [second, self.data])); before = source.read_bytes()
            cli.convert_file(source, target); cli.convert_file(target, reverse, reverse=True)
            self.assertEqual([layout.canonical(d) for d in cli.records(source)], [layout.canonical(d) for d in cli.records(reverse)])
            self.assertEqual(before, source.read_bytes()); saved = target.read_bytes()
            source.write_text('{}\n')
            with self.assertRaises(ValueError): cli.convert_file(source, target)
            self.assertEqual(saved, target.read_bytes())

    def test_calculator_cli_accepts_variable_layout_and_defaults_enrichment_to_v3(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); source = root/'v3.json'; target = root/'recalculated.json'
            original = layout.to_v3(self.data); source.write_text(json.dumps(original))
            subprocess.run([sys.executable, str(SCRIPTS/'derive_statistics.py'), str(source), '--output', str(target)], check=True, capture_output=True)
            self.assertEqual(layout.canonical(original), layout.canonical(json.loads(target.read_text())))
            raw, base = root/'raw.json', root/'base.json'; raw.write_text(json.dumps(self.raw)); base.write_text(json.dumps(self.base))
            subprocess.run([sys.executable, str(SCRIPTS/'derive_statistics.py'), str(raw), '--specifications', str(base), '--output', str(target)], check=True, capture_output=True)
            self.assertEqual('3.0', json.loads(target.read_text())['schema_version'])
            subprocess.run([sys.executable, str(SCRIPTS/'derive_statistics.py'), str(raw), '--specifications', str(base), '--schema-version', '2.0', '--output', str(target)], check=True, capture_output=True)
            self.assertEqual('2.0', json.loads(target.read_text())['schema_version'])


class MigrationPublicationTests(unittest.TestCase):
    def setUp(self):
        self.campaign = campaign_tests.CampaignTests(); self.campaign.setUp()

    def tearDown(self):
        self.campaign.tearDown()

    def test_publication_preserves_sources_and_campaign_audit(self):
        import argparse
        stage = self.campaign.prepare(); self.campaign.populate(stage)
        with contextlib.redirect_stdout(io.StringIO()): manager.finish(argparse.Namespace(stage=stage.name, accept_pilot=False, publish=True))
        root = self.campaign.root; original = (root/'output/model_results.jsonl').read_bytes()
        report = cli.publish(root)
        self.assertEqual(6, report['lossless_roundtrip_records'])
        self.assertEqual(original, (root/'output/model_results.v2.jsonl').read_bytes())
        self.assertEqual('3.0', next(cli.records(root/'output/model_results.jsonl'))['schema_version'])
        with contextlib.redirect_stdout(io.StringIO()): manager.audit(None)
        self.assertEqual('3.0', manager.read(manager.RUNS/'final_audit.json')['schema_version'])
        self.assertEqual(6, cli.publish(root)['records'])
        with self.assertRaisesRegex(ValueError, 'converted to schema 3'):
            manager.finish(argparse.Namespace(stage=stage.name, accept_pilot=False, publish=True))
        (root/'output/model_results/W1.json').write_text('{}')
        with self.assertRaisesRegex(ValueError, 'publication file changed'): cli.audit_migration(root)


if __name__ == '__main__':
    unittest.main()
