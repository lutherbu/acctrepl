"""Synthetic fixtures only: no author source, native program or data is loaded."""
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('author_analysis_view', ROOT/'skills/execute-author-analysis/scripts/view.py')
v = importlib.util.module_from_spec(spec); spec.loader.exec_module(v)


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value), encoding='utf-8')


class ViewTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(); self.addCleanup(self.tmp.cleanup)
        self.base = Path(self.tmp.name)
        self.package = self.base/'old/package'; self.package.mkdir(parents=True)
        self.cache = self.base/'old/reading'; self.cache.mkdir()
        self.campaign = self.base/'campaign'; self.campaign.mkdir()
        self.attempt = self.campaign/'attempts/pilot_01.fixture.a01'; self.attempt.mkdir(parents=True)
        (self.attempt/'work').mkdir(); (self.attempt/'frozen').mkdir()
        (self.attempt/'skill_snapshot').mkdir()
        (self.attempt/'skill_snapshot/SKILL.md').write_text('Synthetic frozen skill.\n')
        self.record_source('analysis.do', 'clear\nregress y x\n')

    def record_source(self, name, text, *, kind='code', original=None):
        self.name = name
        path = self.package/name; path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(original if original is not None else text.encode())
        parsed = self.cache/(name+'.txt'); parsed.parent.mkdir(parents=True, exist_ok=True)
        parsed.write_text(text, encoding='utf-8')
        source = {'path':name, 'original_path':str(path), 'sha256':v.digest(path),
                  'content_path':str(parsed), 'content_sha256':v.digest(parsed), 'kind':kind, 'lines':len(text.splitlines())}
        self.source = source
        old = self.attempt/'frozen/source_work_item.json'
        write(old, {'package_root':str(self.package), 'sources':[source]})
        self.unit = {'package_id':'fixture', 'package_root':str(self.package), 'source_records':[source],
                     'analysis_scope':{'entry_points':[name]}}
        unit = self.attempt/'frozen/unit.json'; write(unit, self.unit)
        self.item = {'attempt_id':self.attempt.name, 'package_id':'fixture', 'directory':str(self.attempt),
                     'campaign_root':str(self.campaign), 'input_root':str(self.package), 'unit':self.unit,
                     'source_work_item':{'path':str(old), 'sha256':v.digest(old)},
                     'frozen_files':[{'path':str(old), 'sha256':v.digest(old)}, {'path':str(unit), 'sha256':v.digest(unit)}]}
        self.registry = {'directory':str(self.attempt), 'skill_sha256':v.tree_hash(self.attempt/'skill_snapshot'),
                         'plan_reviews':[{'plan':{'sha256':'f'*64}}]}
        self.save()

    def save(self):
        write(self.attempt/'work_item.json', self.item)
        self.registry['work_item_sha256'] = v.digest(self.attempt/'work_item.json')
        write(self.campaign/'campaign.json', {'attempts':{self.attempt.name:self.registry}})

    def source_view(self, **kwargs):
        return v.view('source', item=self.attempt/'work_item.json', file=self.name, **kwargs)

    def test_source_bounded_rows_and_hash(self):
        result = self.source_view(begin=2, end=2)
        self.assertEqual(result['rows'], [{'line':2, 'text':'regress y x', 'withheld':False}])
        self.assertEqual(result['original_sha256'], self.source['sha256'])
        self.assertEqual(result['sha256'], self.source['content_sha256'])

    def test_original_pdf_body_is_never_decoded(self):
        self.record_source('paper.pdf', 'Fictional parsed section.\n', kind='document', original=b'%PDF\x00\xff')
        self.assertEqual(self.source_view()['rows'][0]['text'], 'Fictional parsed section.')

    def test_source_tamper(self):
        (self.package/self.name).write_text('changed')
        with self.assertRaises(v.ViewError): self.source_view()

    def test_cache_tamper(self):
        Path(self.source['content_path']).write_text('changed')
        with self.assertRaises(v.ViewError): self.source_view()

    def test_work_item_tamper(self):
        (self.attempt/'work_item.json').write_text('{}')
        with self.assertRaises(v.ViewError): self.source_view()

    def test_frozen_unit_tamper(self):
        write(self.attempt/'frozen/unit.json', {})
        with self.assertRaises(v.ViewError): self.source_view()

    def test_snapshot_tamper(self):
        (self.attempt/'skill_snapshot/SKILL.md').write_text('changed')
        with self.assertRaises(v.ViewError): self.source_view()

    def test_no_traversal_absolute_backslash_or_non_inventory(self):
        for selector in ('../analysis.do', '/analysis.do', r'folder\analysis.do', 'unknown.do', './analysis.do'):
            with self.subTest(selector=selector), self.assertRaises(v.ViewError):
                v.view('source', item=self.attempt/'work_item.json', file=selector)

    def test_symlink_rejected(self):
        source = self.package/self.name; source.unlink(); source.symlink_to(self.cache/(self.name+'.txt'))
        with self.assertRaises(v.ViewError): self.source_view()

    def test_nul_rejected(self):
        self.record_source('analysis.do', 'clear\x00password="fake"\n')
        with self.assertRaises(v.ViewError): self.source_view()

    def test_byte_and_line_bounds(self):
        for kwargs in ({'begin':0}, {'begin':1,'end':201}, {'begin':3,'end':1}):
            with self.subTest(kwargs=kwargs), self.assertRaises(v.ViewError): self.source_view(**kwargs)
        self.record_source('analysis.do', 'x'*(v.MAX_BYTES+1))
        with self.assertRaises(v.ViewError): self.source_view()

    def test_long_line_is_withheld_without_truncating_into_secret(self):
        self.record_source('analysis.do', 'x'*(v.MAX_LINE+1)+'\nclear\n')
        rows = self.source_view()['rows']
        self.assertTrue(rows[0]['withheld']); self.assertEqual(rows[1]['text'], 'clear')

    def test_assignment_token_url_and_license_are_redacted(self):
        cases = ['password = "fictional-password"', 'global api_token "fictional-token"',
                 'Authorization: Bearer FICTIONALTOKEN12345', 'url = "https://user:fictional@host/path"',
                 'url = "https://host/path?api_key=fictional"', 'Serial number: 123-FAKE',
                 'Licensed to: Fictional Person', 'Licensee: Fictional Lab']
        for line in cases:
            with self.subTest(line=line):
                masks, _ = v.screen([line], '.do')
                self.assertIn(1, masks)

    def test_multiline_context_is_all_withheld(self):
        text = 'safe()\nconfig = {\n "password":\n "fictional-secret",\n "host": "example.invalid"\n}\nsafe_again()\n'
        self.record_source('analysis.py', text)
        rows = self.source_view(begin=4, end=7)['rows']
        self.assertEqual([r['withheld'] for r in rows], [True, True, True, False])
        self.assertNotIn('fictional-secret', json.dumps(rows))

    def test_multiline_comment_and_triple_string(self):
        for text in ('/*\npassword = fake\ncontinued private notes\n*/\nclear\n',
                     'notes = """\npassword = fake\ncontinued private notes\n"""\nclear\n'):
            masks, _ = v.screen(text.splitlines(), '.py')
            self.assertEqual(set(masks), {1,2,3,4})

    def test_unclosed_context_is_withheld_and_limitation_reported(self):
        self.record_source('analysis.py', 'config = {\n"password": "fictional"\nrest = 1\n')
        result = self.source_view(begin=3, end=3)
        self.assertTrue(result['rows'][0]['withheld']); self.assertTrue(result['coverage_limits'])

    def test_unbracketed_assignment_continuation(self):
        masks, _ = v.screen(['password <-', '  "fictional-secret"', 'safe()'], '.r')
        self.assertEqual(set(masks), {1,2})

    def test_stata_license_institution_continuation(self):
        masks, _ = v.screen(['  Licensed to: Fictional Person', '               Fictional Institution',
                             '', 'Notes:', '  1. Stata/MP'], '.txt')
        self.assertEqual(set(masks), {1,2})

    def test_paths_and_connection_word_are_preserved(self):
        text = 'global root "C:\\Research\\project"\ncd "/home/author/project"\n* connection requires local data\n'
        self.record_source('analysis.do', text)
        rows = self.source_view()['rows']
        self.assertEqual([r['text'] for r in rows], text.splitlines())
        self.assertFalse(any(r['withheld'] for r in rows))

    def test_explicit_denied_ranges_and_additive_cli_range(self):
        self.item['reader_denied_ranges'] = [{'mode':'source','file':self.name,'begin':1,'end':1}]; self.save()
        rows = self.source_view(deny=[(2,2)])['rows']
        self.assertTrue(all(r['withheld'] for r in rows))

    def test_work_allows_code_but_not_data_or_old_views(self):
        code = self.attempt/'work/analysis.do'; code.write_text('regress y x\n')
        self.assertEqual(v.view('work',attempt=self.attempt,file='work/analysis.do')['rows'][0]['text'], 'regress y x')
        for filename in ('work/data.csv', 'work/data.txt', 'output/notes.md'):
            p = self.attempt/filename; p.parent.mkdir(parents=True,exist_ok=True); p.write_text('fictional')
            with self.subTest(filename=filename), self.assertRaises(v.ViewError):
                v.view('work',attempt=self.attempt,file=filename)

    def runtime(self):
        runtime = self.attempt/'runtime'; runtime.mkdir(exist_ok=True)
        log = runtime/'stages/main/stdout.bin'; log.parent.mkdir(parents=True,exist_ok=True)
        log.write_text('Fictional native result\nLicensee: Fictional Person\n')
        saved = runtime/'stages/main/native_000.log'; saved.write_text('Fictional native log\n')
        write(runtime/'run.json', {'attempt_id':self.attempt.name,'plan_sha256':'f'*64,
              'stages':[{'stdout':{'path':str(log),'sha256':v.digest(log)},
                         'native_logs':[{'path':str(saved),'sha256':v.digest(saved)}],
                         'outputs':[{'path':str(runtime/'data.bin'),'sha256':'x'}]}]})
        self.registry['runtime_receipt']={'path':str(runtime/'run.json'),'sha256':v.digest(runtime/'run.json')}; self.save()
        return log, saved

    def test_log_only_exact_receipt_captures_with_hash_and_redaction(self):
        log, saved = self.runtime()
        result = v.view('log',attempt=self.attempt,file=str(log.relative_to(self.attempt)))
        self.assertTrue(result['rows'][1]['withheld']); self.assertIn('receipt_sha256',result)
        self.assertEqual(v.view('log',attempt=self.attempt,file=str(saved.relative_to(self.attempt)))['rows'][0]['text'], 'Fictional native log')

    def test_log_capture_tamper_and_arbitrary_runtime_files_rejected(self):
        log, _ = self.runtime(); log.write_text('changed')
        with self.assertRaises(v.ViewError): v.view('log',attempt=self.attempt,file=str(log.relative_to(self.attempt)))
        (self.attempt/'runtime/data.bin').write_text('fictional data')
        with self.assertRaises(v.ViewError): v.view('log',attempt=self.attempt,file='runtime/data.bin')

    def test_receipt_and_approved_plan_binding(self):
        log, _ = self.runtime()
        self.registry['plan_reviews'][0]['plan']['sha256']='e'*64; self.save()
        with self.assertRaises(v.ViewError): v.view('log',attempt=self.attempt,file=str(log.relative_to(self.attempt)))

    def test_legacy_reading_view_cannot_be_substituted(self):
        elsewhere = self.base/'old/probes/screened_sources/analysis.do.txt'
        elsewhere.parent.mkdir(parents=True); elsewhere.write_text('legacy view')
        self.source['content_path']=str(elsewhere); self.source['content_sha256']=v.digest(elsewhere)
        write(self.attempt/'frozen/source_work_item.json',{'package_root':str(self.package),'sources':[self.source]})
        write(self.attempt/'frozen/unit.json',self.unit)
        for ref in self.item['frozen_files']: ref['sha256']=v.digest(ref['path'])
        self.item['source_work_item']['sha256']=v.digest(self.attempt/'frozen/source_work_item.json'); self.save()
        with self.assertRaises(v.ViewError): self.source_view()


if __name__ == '__main__':
    unittest.main()
