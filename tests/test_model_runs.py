"""Run accounting, source immutability and publication integrity checks."""
import argparse
import contextlib
import importlib.util
import io
import json
from pathlib import Path
import shutil
import tempfile
import unittest

REAL_ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('model_runs', REAL_ROOT / 'scripts/model_extraction_runs.py')
manager = importlib.util.module_from_spec(spec)
spec.loader.exec_module(manager)


class RunTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.old = manager.ROOT, manager.RUNS, manager.WORKFLOW
        manager.ROOT = self.root
        manager.RUNS = self.root / 'output/model_extraction_runs'
        manager.WORKFLOW = manager.RUNS / 'workflow.json'
        manager.RUNS.mkdir(parents=True)
        shutil.copytree(REAL_ROOT / 'skills/extract-accounting-models', self.root / 'skills/extract-accounting-models', ignore=shutil.ignore_patterns('__pycache__'))
        (self.root / 'papers').mkdir()
        manifest, samples = [], []
        for pid in ('W2', 'W1'):
            reading = self.root / 'papers' / f'{pid}.json'
            reading.write_text(json.dumps({'paper_id': pid, 'pages': [{'page': 1, 'text': 'Main empirical analysis uses portfolio sorts.'}]}))
            pdf = self.root / 'papers' / f'{pid}.pdf'
            pdf.write_bytes(b'fixture-pdf')
            manifest.append({'paper_id': pid, 'doi': None, 'reading_json': str(reading.relative_to(self.root)), 'pdf_path': str(pdf.relative_to(self.root)), 'reading_json_sha256': manager.sha(reading), 'pdf_sha256': manager.sha(pdf)})
            samples.append({'paper_id': pid, 'samples': [{'sample_id': 'S1'}]})
        (manager.RUNS / 'input_manifest.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in manifest))
        source = self.root / 'output/shortlist.jsonl'
        source.write_text(''.join(json.dumps(r)+'\n' for r in samples))
        manager.write_json(manager.WORKFLOW, {'status': 'piloting', 'input_file': 'output/shortlist.jsonl', 'input_sha256': manager.sha(source), 'pilot_rounds': [], 'full_sweeps': [], 'maximum_pilot_rounds': 5, 'maximum_full_sweeps': 2, 'pilot_accepted': True})

    def tearDown(self):
        manager.ROOT, manager.RUNS, manager.WORKFLOW = self.old
        self.temp.cleanup()

    def prepare(self):
        with contextlib.redirect_stdout(io.StringIO()):
            manager.prepare(argparse.Namespace(kind='sweep', label='extraction', ids=None))
        return manager.RUNS / 'sweep_01'

    def populate(self, stage):
        for pid in ('W1', 'W2'):
            manager.write_json(stage / 'results' / f'{pid}.json', {'schema_version': '1.0', 'paper_id': pid, 'doi': None, 'status': 'no_baseline_regression', 'paper_text_file': f'papers/{pid}.json', 'models': [], 'review_notes': ['The main empirical analysis uses portfolio sorts.']})
        manager.write_json(stage / 'parent_review.json', {'reviewed': ['W1', 'W2']})

    def test_sweep_limit_and_pilot_acceptance_gate(self):
        d = manager.read_json(manager.WORKFLOW)
        d['pilot_accepted'] = False
        manager.write_json(manager.WORKFLOW, d)
        with self.assertRaisesRegex(ValueError, 'accepted final pilot'):
            self.prepare()
        d.update(pilot_accepted=True, full_sweeps=[{}, {}])
        manager.write_json(manager.WORKFLOW, d)
        with self.assertRaisesRegex(ValueError, 'limit reached'):
            self.prepare()

    def test_assignments_disjoint_preserve_order(self):
        stage = self.prepare()
        for worker in ('one', 'two'):
            with contextlib.redirect_stdout(io.StringIO()):
                manager.assign(argparse.Namespace(stage='sweep_01', worker=worker, count=1))
        batches = manager.read_json(stage / 'run.json')['batches']
        self.assertEqual([['W2'], ['W1']], [b['paper_ids'] for b in batches])
        for batch in batches:
            row = manager.read_lines(self.root / batch['worklist'])[0]
            self.assertEqual(stage / 'results' / f"{row['paper_id']}.json",
                             self.root / row['result_json'])

    def test_source_change_is_detected(self):
        stage = self.prepare(); self.populate(stage)
        (self.root / 'papers/W1.pdf').write_bytes(b'changed')
        _, report, _ = manager.check_stage(stage)
        self.assertEqual(1, report['valid'])
        self.assertIn('Original input changed: pdf_path', report['records'][1]['errors'])

    def test_protocol_and_clarifications_are_assigned_and_immutable(self):
        stage = self.prepare(); self.populate(stage)
        protocol = stage / 'protocol.md'; protocol.write_text('Verify from source.\n')
        clarification = stage / 'clarification.md'; clarification.write_text('Choose the principal question.\n')
        run = manager.read_json(stage / 'run.json')
        run['verification_protocol'] = {'path': str(protocol.relative_to(self.root)),
                                        'sha256': manager.sha(protocol)}
        run['clarifications'] = [{'path': str(clarification.relative_to(self.root)),
                                  'sha256': manager.sha(clarification)}]
        manager.write_json(stage / 'run.json', run)
        with contextlib.redirect_stdout(io.StringIO()):
            manager.assign(argparse.Namespace(stage='sweep_01', worker='one', count=2))
        row = manager.read_lines(stage / 'batch_001.jsonl')[0]
        self.assertEqual(run['verification_protocol']['path'], row['verification_protocol'])
        self.assertEqual(run['clarifications'], row['scope_clarifications'])
        manager.check_stage(stage)
        original = clarification.read_bytes(); clarification.write_text('Changed rule.\n')
        with self.assertRaisesRegex(ValueError, 'Frozen clarification changed'):
            manager.check_stage(stage)
        clarification.write_bytes(original); protocol.write_text('Changed protocol.\n')
        with self.assertRaisesRegex(ValueError, 'Frozen verification protocol changed'):
            manager.finish(argparse.Namespace(stage='sweep_01', publish=True))
        self.assertFalse((self.root / 'output/model_extractions.jsonl').exists())

    def test_overwritten_assignment_blocks_validation_and_publication(self):
        stage = self.prepare(); self.populate(stage)
        with contextlib.redirect_stdout(io.StringIO()):
            manager.assign(argparse.Namespace(stage='sweep_01', worker='one', count=2))
        batch = manager.read_json(stage / 'run.json')['batches'][0]
        worklist = self.root / batch['worklist']
        original = worklist.read_bytes()
        worklist.write_text((stage / 'results/W1.json').read_text() + '\n')
        with self.assertRaisesRegex(ValueError, 'Frozen worklist changed'):
            manager.check_stage(stage)
        with self.assertRaisesRegex(ValueError, 'Frozen worklist changed'):
            manager.finish(argparse.Namespace(stage='sweep_01', publish=True))
        self.assertFalse((self.root / 'output/model_extractions.jsonl').exists())
        worklist.write_bytes(original)
        _, report, _ = manager.check_stage(stage)
        self.assertEqual(2, report['valid'])

    def test_missing_record_blocks_publish(self):
        stage = self.prepare(); self.populate(stage)
        (stage / 'results/W1.json').unlink()
        with self.assertRaisesRegex(ValueError, 'All expected records'):
            manager.finish(argparse.Namespace(stage='sweep_01', publish=True))
        self.assertFalse((self.root / 'output/model_extractions.jsonl').exists())

    def test_publication_keeps_shortlist_order_and_all_records(self):
        stage = self.prepare(); self.populate(stage)
        before = manager.sha(self.root / 'output/shortlist.jsonl')
        with contextlib.redirect_stdout(io.StringIO()):
            manager.finish(argparse.Namespace(stage='sweep_01', publish=True))
        output = manager.read_lines(self.root / 'output/model_extractions.jsonl')
        self.assertEqual(['W2', 'W1'], [r['paper_id'] for r in output])
        self.assertEqual(before, manager.sha(self.root / 'output/shortlist.jsonl'))
        self.assertEqual(2, len(list((self.root / 'output/model_extractions').glob('*.json'))))

    def test_self_authored_reading_cannot_become_verified_evidence(self):
        stage = self.prepare(); self.populate(stage)
        extra = self.root / 'papers/W1_edited.json'
        shutil.copyfile(self.root / 'papers/W1.json', extra)
        result = manager.read_json(stage / 'results/W1.json')
        result['paper_text_file'] = 'papers/W1_edited.json'
        manager.write_json(stage / 'results/W1.json', result)
        _, report, _ = manager.check_stage(stage)
        self.assertTrue(any('not the frozen supplied input' in e for e in report['records'][1]['errors']))

    def test_coordinator_verified_reading_is_frozen_and_assigned(self):
        verified = self.root / 'papers/W1_verified.json'
        shutil.copyfile(self.root / 'papers/W1.json', verified)
        original = manager.read_lines(manager.RUNS / 'input_manifest.jsonl')[1]
        entry = {'path': 'papers/W1_verified.json', 'sha256': manager.sha(verified),
                 'original_reading_sha256': original['reading_json_sha256'], 'pdf_sha256': original['pdf_sha256']}
        manager.write_json(manager.RUNS / 'verified_readings.json', {'W1': entry})
        stage = self.prepare(); self.populate(stage)
        result = manager.read_json(stage / 'results/W1.json')
        result['paper_text_file'] = entry['path']
        manager.write_json(stage / 'results/W1.json', result)
        _, report, _ = manager.check_stage(stage)
        self.assertEqual(2, report['valid'])

    def test_verification_freezes_and_assigns_previous_results(self):
        stage = self.prepare(); self.populate(stage)
        with contextlib.redirect_stdout(io.StringIO()):
            manager.finish(argparse.Namespace(stage='sweep_01', publish=False))
            manager.prepare(argparse.Namespace(kind='sweep', label='verification', ids=None,
                                               previous_stage='sweep_01'))
            manager.assign(argparse.Namespace(stage='sweep_02', worker='verify', count=2))
        verification = manager.RUNS / 'sweep_02'
        rows = manager.read_lines(verification / 'batch_001.jsonl')
        self.assertEqual(['W2', 'W1'], [r['paper_id'] for r in rows])
        for row in rows:
            self.assertEqual(manager.sha(manager.ROOT / row['previous_result']), row['previous_result_sha256'])
        prior = stage / 'results/W1.json'
        prior.write_text(prior.read_text() + '\n')
        with self.assertRaisesRegex(ValueError, 'Frozen previous result changed'):
            manager.check_stage(verification)

    def test_reading_amendment_preserves_and_checks_both_source_versions(self):
        stage = self.prepare(); self.populate(stage)
        old = self.root / 'papers/W1.json'
        new = self.root / 'papers/W1_corrected.json'
        new.write_bytes(old.read_bytes())
        snapshot = stage / 'run_before_amendment.json'
        shutil.copyfile(stage / 'run.json', snapshot)
        manifest = manager.read_lines(manager.RUNS / 'input_manifest.jsonl')[1]
        entry = {'path': str(new.relative_to(self.root)), 'sha256': manager.sha(new),
                 'original_reading_sha256': manifest['reading_json_sha256'],
                 'pdf_sha256': manifest['pdf_sha256']}
        run = manager.read_json(stage / 'run.json')
        run['reading_overrides']['W1'] = entry
        run['reading_input_amendments'] = [{
            'previous_reading': {'path': str(old.relative_to(self.root)), 'sha256': manager.sha(old)},
            'new_reading': entry,
            'previous_run_snapshot': {'path': str(snapshot.relative_to(self.root)),
                                      'sha256': manager.sha(snapshot)}}]
        manager.write_json(stage / 'run.json', run)
        _, report, _ = manager.check_stage(stage)
        self.assertTrue(any('not the frozen supplied input' in e
                            for e in report['records'][1]['errors']))
        result = manager.read_json(stage / 'results/W1.json')
        result['paper_text_file'] = entry['path']
        manager.write_json(stage / 'results/W1.json', result)
        _, report, _ = manager.check_stage(stage)
        self.assertEqual(2, report['valid'])
        for target in (old, new, snapshot):
            original = target.read_bytes()
            target.write_bytes(original + b'\n')
            with self.assertRaisesRegex(ValueError, 'Frozen reading amendment'):
                manager.check_stage(stage)
            target.write_bytes(original)

    def test_running_or_incomplete_sweep_cannot_supply_previous_results(self):
        self.prepare()
        with self.assertRaisesRegex(ValueError, 'complete and fully valid'):
            with contextlib.redirect_stdout(io.StringIO()):
                manager.prepare(argparse.Namespace(kind='sweep', label='verification', ids=None,
                                                   previous_stage='sweep_01'))
        self.assertFalse((manager.RUNS / 'sweep_02').exists())

    def test_verification_supplies_only_matching_frozen_coordinator_notes(self):
        stage = self.prepare(); self.populate(stage)
        notes = self.root / 'output/review_notes.json'
        manager.write_json(notes, {'W1': {'issue': 'Check the per-fit count against the source.'}})
        with contextlib.redirect_stdout(io.StringIO()):
            manager.finish(argparse.Namespace(stage='sweep_01', publish=False))
            manager.prepare(argparse.Namespace(kind='sweep', label='verification', ids=None,
                                               previous_stage='sweep_01',
                                               review_notes='output/review_notes.json'))
            manager.assign(argparse.Namespace(stage='sweep_02', worker='verify', count=2))
        verification = manager.RUNS / 'sweep_02'
        rows = manager.read_lines(verification / 'batch_001.jsonl')
        self.assertNotIn('coordinator_notes', rows[0])
        supplied = self.root / rows[1]['coordinator_notes']
        self.assertEqual({'issue': 'Check the per-fit count against the source.'}, manager.read_json(supplied))
        notes.write_text('{}\n')  # Editing the source does not change the frozen copy.
        manager.check_stage(verification)
        supplied.write_text('{}\n')
        with self.assertRaisesRegex(ValueError, 'Frozen coordinator notes changed'):
            manager.check_stage(verification)

    def test_notes_rejected_before_stage_creation_without_verification(self):
        with self.assertRaisesRegex(ValueError, 'only for full-sweep verification'):
            manager.prepare(argparse.Namespace(kind='sweep', label='extraction', ids=None,
                                               review_notes='output/notes.json'))
        self.assertFalse((manager.RUNS / 'sweep_01').exists())


if __name__ == '__main__':
    unittest.main()
