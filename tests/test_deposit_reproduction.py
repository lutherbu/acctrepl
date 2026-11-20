"""Verify direct publication and the reviewed fallback from author-code execution."""
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from scripts import deposit_reproduction as deposit
from scripts import author_analysis_runs as controller
from scripts import publication as pub


def save(path, doc):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(pub.encode(doc))


class DepositReproductionTests(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.root = Path(directory.name) / 'project'
        self.case = Path(directory.name) / 'case'
        self.pid = 'jar-test'
        self.paper = 'W1234'
        self.folder = self.root / 'papers/packages/JAR-Volume 55/Issue 1/example'
        self.folder.mkdir(parents=True)
        self.raw = self.folder / 'participant.xlsx'
        self.raw.write_bytes(b'private workbook')
        self.assessment = self.root / f'output/feasibility_execution/packages/{self.pid}/assessment.json'
        self.catalog(self.folder)
        self.scope('no_runnable_code')
        self.review_file = self.case.parent / 'independent-review.json'

    def catalog(self, location):
        paper = {'paper_id': self.paper, 'title': 'Study', 'doi': '10.1111/example',
                 'jar_packages': [{'package_id': self.pid, 'package_path': location.relative_to(self.root).as_posix()}]}
        path = self.root / 'docs/papers.jsonl'
        path.parent.mkdir(exist_ok=True)
        path.write_text(json.dumps(paper) + '\n')

    def scope(self, readiness):
        save(self.assessment, {'package_id': self.pid, 'scopes': [
            {'id': 'full_pipeline', 'data_status': 'local_available', 'execution_readiness': readiness}]})

    def results(self):
        (self.case / 'analysis.do').write_text('version 18\nregress y x\n')
        tables = self.case / 'tables'
        tables.mkdir(exist_ok=True)
        (tables / 'main.csv').write_text('term,estimate\nx,0.61\n')
        self.result = self.case / 'result.json'
        save(self.result, {'paper_id': self.paper, 'package_id': self.pid,
                           'fits': [{'model_id': 'main', 'result_set_id': 'published', 'execution_status': 'executed',
                                     'execution_detail': 'Native fit with ten observations.', 'evidence_path': 'tables/main.csv',
                                     'fidelity': 'source_supported'}],
                           'limitations': ['Published standard errors are unavailable.']})
        self.review = {'reviewer': 'independent-reader', 'status': 'accepted', 'result_sha256': pub.sha(self.result),
                       'findings': ['Checked native output.'], 'publish_files': {
                           'analysis.do': pub.sha(self.case/'analysis.do'),
                           'tables/main.csv': pub.sha(tables/'main.csv')}}
        save(self.review_file, self.review)

    def test_loose_deposit_overlap_and_hash_verified_offline_publication(self):
        frozen = deposit.prepare(self.root, self.pid, self.case)
        self.assertEqual(deposit.prepare(self.root, self.pid, self.case), frozen)
        self.assertEqual(deposit.read(frozen)['input_hashes'], {self.raw.relative_to(self.root).as_posix(): pub.sha(self.raw)})
        self.results()
        installed = deposit.publish(self.root, self.case, self.review_file)
        self.assertEqual(installed.parent.parent.name, self.paper)
        self.assertEqual(deposit.verify(self.root, self.paper, True), installed)
        self.assertEqual(installed, deposit.publish(self.root, self.case, self.review_file))
        self.assertEqual(deposit.read(installed)['executed_scopes'], 1)
        self.assertFalse((installed.parent / self.raw.name).exists())
        self.raw.unlink()
        self.assertEqual(deposit.verify(self.root, self.paper, False), installed)
        with self.assertRaisesRegex(ValueError, 'no input files'):
            deposit.verify(self.root, self.paper, True)
        (installed.parent / 'analysis.do').write_text('regress y z\n')
        with self.assertRaisesRegex(ValueError, 'Checksum mismatch'):
            deposit.verify(self.root, self.paper, False)

    def test_review_rejects_changed_results_secrets_and_existing_publication(self):
        self.catalog(self.raw)
        deposit.prepare(self.root, self.pid, self.case)
        self.results()
        self.review['result_sha256'] = '1' * 64
        save(self.review_file, self.review)
        with self.assertRaisesRegex(ValueError, 'Checksum mismatch'):
            deposit.publish(self.root, self.case, self.review_file)
        self.review['result_sha256'] = pub.sha(self.result)
        self.review['publish_files']['raw.xlsx'] = pub.sha(self.raw)
        save(self.review_file, self.review)
        with self.assertRaisesRegex(ValueError, 'aggregate output'):
            deposit.publish(self.root, self.case, self.review_file)
        self.review['publish_files'].pop('raw.xlsx')
        save(self.review_file, self.review)
        original = self.root / f'output/reproductions/packages/{self.paper}/accepted.json'
        save(original, {'existing': 'from scratch'})
        with self.assertRaisesRegex(ValueError, 'different published reproduction'):
            deposit.publish(self.root, self.case, self.review_file)
        self.assertEqual(deposit.read(original), {'existing': 'from scratch'})

    def test_executed_fits_require_independently_reviewed_code_and_numerical_table(self):
        deposit.prepare(self.root, self.pid, self.case)
        self.results()
        allowed = self.review['publish_files'].copy()
        for names in [[], ['analysis.do'], ['tables/main.csv']]:
            self.review['publish_files'] = {name: allowed[name] for name in names}
            save(self.review_file, self.review)
            with self.assertRaisesRegex(ValueError, 'reviewed numerical table|reviewed source code'):
                deposit.publish(self.root, self.case, self.review_file)
        table = self.case/'tables/main.csv'
        numerical = table.read_bytes()
        table.write_text('term,estimate\nmodel_1,missing\n')
        self.review['publish_files'] = {**allowed, 'tables/main.csv': pub.sha(table)}
        save(self.review_file, self.review)
        with self.assertRaisesRegex(ValueError, 'no numerical result'):
            deposit.publish(self.root, self.case, self.review_file)
        table.write_bytes(numerical)
        self.review['publish_files'] = allowed
        result = deposit.read(self.result)
        result['builder'] = self.review['reviewer']
        save(self.result, result)
        self.review['result_sha256'] = pub.sha(self.result)
        save(self.review_file, self.review)
        with self.assertRaisesRegex(ValueError, 'independent reviewer'):
            deposit.publish(self.root, self.case, self.review_file)

    def test_fallback_requires_review_and_limits_work_to_uncovered_targets(self):
        self.scope('preparation_required')
        with self.assertRaisesRegex(ValueError, 'needs a reviewed'):
            deposit.prepare(self.root, self.pid, self.case)
        history = self.root / f'output/executions/packages/{self.pid}'
        report = history / 'report.json'
        save(report, {'attempt_id': 'full-001', 'package_id': self.pid, 'scope_id': 'full_pipeline', 'outcome': 'partial',
                      'stage_results': [{'stage_id': 'table1', 'status': 'succeeded', 'log_check': 'passed'}]})
        save(history / 'local_inputs.json', {'schema_version': '2.0', 'attempt_id': 'full-001', 'package_id': self.pid,
                                             'scope_id': 'full_pipeline', 'accepted_outcome': 'partial'})
        review = history / 'review.json'
        save(review, {'reviewer': 'author-reviewer', 'outcome': 'partial', 'publish_files': [],
                      'report': {'path': report.relative_to(self.root).as_posix(), 'sha256': pub.sha(report)},
                      'source_review': {'path': 'urn:sha256:' + 'a'*64, 'sha256': 'a'*64},
                      'handoff': {'next_skill': 'reproduce-accounting-models', 'uncovered_baselines': ['main'],
                                  'coverage': {'done': {'verified': True, 'stage_id': 'table1', 'evidence': 'Verified rows.'},
                                               'main': {'verified': False, 'evidence': 'Required output missing.'}}}})
        other = self.root/'.local/unregistered'
        save(other/'review.json', deposit.read(review))
        save(other/'report.json', deposit.read(report))
        with self.assertRaisesRegex(ValueError, 'registered private execution review'):
            deposit.prepare(self.root, self.pid, self.case, other/'review.json')
        frozen = deposit.prepare(self.root, self.pid, self.case, review)
        self.results()
        good = deposit.read(self.result)
        bad = {**good, 'fits': [{**good['fits'][0], 'target_id': 'done'}]}
        save(self.result, bad)
        self.review['result_sha256'] = pub.sha(self.result)
        save(self.review_file, self.review)
        with self.assertRaisesRegex(ValueError, 'unresolved baselines'):
            deposit.publish(self.root, self.case, self.review_file)
        work = deposit.read(frozen)
        work['handoff']['uncovered_baselines'] = ['done']
        save(frozen, work)
        with self.assertRaisesRegex(ValueError, 'archived execution review'):
            deposit.publish(self.root, self.case, self.review_file)
        work['handoff']['uncovered_baselines'] = ['main']
        save(frozen, work)
        self.results()
        path = deposit.publish(self.root, self.case, self.review_file)
        self.assertEqual(deposit.verify(self.root, self.paper, True), path)

    def test_unlaunched_draft_cannot_trigger_fallback_but_an_accepted_block_can(self):
        self.scope('preparation_required')
        base = self.root / '.local/runs/author_analysis_execution'
        campaign, aid = base / self.pid, 'full-001'
        attempt = campaign / 'attempts' / aid
        folder = attempt / 'output'
        report, review = folder / 'report.json', folder / 'review.json'
        (attempt/'skill_snapshot').mkdir(parents=True)
        unit = {'package_id': self.pid, 'baseline_targets': {'main': 'Published baseline statistic'}}
        save(campaign / 'manifest.json', {'units': [unit]})
        save(attempt / 'work_item.json', {'attempt_id': aid, 'campaign_root': str(campaign), 'unit': unit,
                                          'analysis_scope': {'id': 'full_pipeline'}, 'frozen_files': []})
        def reference(path):
            return {'path': str(path), 'sha256': pub.sha(path)}

        for outcome in ('not_run', 'blocked'):
            save(report, {'attempt_id': aid, 'package_id': self.pid, 'scope_id': 'full_pipeline', 'outcome': outcome,
                          'stage_results': [], 'gaps': [{'reason': 'Required native runtime is unavailable.'}]})
            save(review, {'reviewer': 'reviewer', 'outcome': outcome, 'report': reference(report),
                          'handoff': {'next_skill': 'reproduce-accounting-models', 'uncovered_baselines': ['main'],
                                      'coverage': {'main': {'verified': False, 'evidence': 'Runtime unavailable.'}}}})
            if outcome == 'not_run':
                with self.assertRaisesRegex(ValueError, 'unlaunched'):
                    deposit.prepare(self.root, self.pid, self.case, review)
            else:
                record = {'attempt_id': aid, 'directory': str(attempt), 'package_id': self.pid, 'status': 'finalized',
                          'outcome': outcome, 'report': reference(report), 'review': reference(review),
                          'agent': 'author-builder', 'work_item_sha256': pub.sha(attempt/'work_item.json'),
                          'skill_sha256': controller.tree_hash(attempt/'skill_snapshot')}
                registry = {'campaign_root': str(campaign), 'fixture': False, 'units': {self.pid: unit},
                            'limits': controller.LIMITS, 'assignment_configuration': controller.CONFIG,
                            'manifest': reference(campaign/'manifest.json'), 'attempts': {aid: record}}
                save(campaign/'campaign.json', registry)
                with patch.object(controller, 'BASE', base):
                    with self.assertRaisesRegex(ValueError, 'no accepted matching controller record'):
                        deposit.prepare(self.root, self.pid, self.case, review)
                    record['status'] = 'accepted'
                    save(campaign/'campaign.json', registry)
                    work = deposit.read(deposit.prepare(self.root, self.pid, self.case, review))
                self.assertEqual(work['handoff']['uncovered_baselines'], ['main'])
