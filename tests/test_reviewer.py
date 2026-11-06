"""Optional local browser checks; no network or changes to research outputs.

Requires the already-installed Python Playwright package and Chromium. HTML use
itself has no dependencies. Run: python -m unittest discover -s tests -p test_reviewer.py -v
"""
import copy
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
FULL_SWEEP = ROOT / 'output/samples/sample_extractions.jsonl'
BROWSER = shutil.which('chromium') or shutil.which('google-chrome')
if BROWSER is None and Path('/usr/bin/chromium').exists():
    BROWSER = '/usr/bin/chromium'
HAS_PLAYWRIGHT = importlib.util.find_spec('playwright') is not None


def record(paper_id='W1'):
    sample = {
        'sample_id': 'main', 'sample_label': 'Main Table 2', 'sample_role': 'main',
        'sample_size': 11, 'sample_unit': 'firm-year', 'sample_unit_detail': '',
        'sample_period': {'begin': 2001, 'end': 2004, 'years': []},
        'period_detail': '', 'analysis_sizes': [],
        'data_sources': {'commercial_standardized': ['Compustat'],
                         'commercial_nonstandardized': [], 'public': {'SEC EDGAR': None},
                         'proprietary': [], 'primary_collection': [], 'unresolved': []},
        'evidence': {k: [{'page': 1, 'quote': 'Sample of 11 firm-years.'}]
                     for k in ('sample_size', 'sample_unit', 'sample_period', 'data_sources')},
        'missing_fields': {}, 'review_notes': [],
    }
    return {
        'schema_version': '1.0', 'paper_id': paper_id, 'doi': None,
        'status': 'needs_review', 'paper_text_file': f'{paper_id}.json',
        'primary_sample_id': 'main', 'samples': [sample],
        'data_section_full_text': 'Sample of 11 firm-years.',
        'data_section_spans': [{'heading': 'Sample', 'page_begin': 1, 'page_end': 1,
                                'start_anchor': 'Sample', 'end_anchor': 'firm-years.'}],
        'data_section_status': 'complete', 'review_notes': [],
    }


@unittest.skipUnless(HAS_PLAYWRIGHT and BROWSER, 'Optional Playwright/Chromium unavailable')
class ReviewerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from playwright.sync_api import sync_playwright
        cls.pw = sync_playwright().start()
        cls.browser = cls.pw.chromium.launch(executable_path=BROWSER, headless=True, timeout=20000)

    @classmethod
    def tearDownClass(cls):
        cls.browser.close()
        cls.pw.stop()

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='accounting-review-')
        self.folder = Path(self.tmp.name)
        self.context = self.browser.new_context(accept_downloads=True, viewport={'width': 1500, 'height': 1000})
        self.page = self.context.new_page()
        self.errors = []
        self.page.on('pageerror', lambda e: self.errors.append(str(e)))
        self.page.on('dialog', lambda dialog: dialog.accept())
        self.network = []
        self.page.on('request', lambda req: self.network.append(req.url) if req.url.startswith(('http:', 'https:')) else None)
        self.page.goto((ROOT / 'utils/review.html').as_uri(), wait_until='load')
        self.rows = [record('W1'), record('W2'), record('W3')]
        self.rows[1]['status'] = 'complete'
        self.rows[2]['samples'].append(copy.deepcopy(self.rows[2]['samples'][0]))
        self.rows[2]['samples'][1]['sample_id'] = 'second'
        self.fixture = self.folder / 'fixture.jsonl'
        self.fixture.write_text(''.join(json.dumps(r, ensure_ascii=False) + '\n' for r in self.rows))

    def tearDown(self):
        self.context.close()
        self.tmp.cleanup()
        self.assertEqual(self.errors, [])
        self.assertEqual(self.network, [])

    def load(self, path=None):
        self.page.locator('#load-jsonl').set_input_files(str(path or self.fixture))
        self.page.locator('#workspace').wait_for(state='visible')
        self.page.wait_for_function("!document.getElementById('export').disabled")

    def download(self, selector):
        with self.page.expect_download() as event:
            self.page.locator(selector).click()
        path = self.folder / event.value.suggested_filename
        event.value.save_as(str(path))
        return path

    def test_edit_filtered_export_preserves_all_records_and_fields(self):
        self.load()
        self.page.locator('#field-samples-0-sample_size').fill('25')
        self.page.locator('#field-samples-0-sample_unit').select_option(json.dumps('firm-quarter'))
        self.page.locator('#field-samples-0-sample_period-begin').fill('2000')
        self.page.locator('#save-paper').click()
        self.page.locator('#status-filter').select_option('complete')
        self.assertEqual(self.page.locator('.paper-row').count(), 1)
        exported = [json.loads(line) for line in self.download('#export').read_text().splitlines()]
        expected = copy.deepcopy(self.rows)
        expected[0]['samples'][0].update(sample_size=25, sample_unit='firm-quarter')
        expected[0]['samples'][0]['sample_period']['begin'] = 2000
        self.assertEqual(exported, expected)
        self.assertEqual(self.fixture.read_text(), ''.join(json.dumps(r, ensure_ascii=False) + '\n' for r in self.rows))

    def test_validation_nulls_and_failed_import_preserve_current_work(self):
        self.load()
        size = self.page.locator('#field-samples-0-sample_size')
        size.fill('1.5')
        self.page.locator('#next').click()
        self.assertEqual(self.page.locator('#paper-id').inner_text(), 'W1')
        self.assertIn('integer', self.page.locator('#errors').inner_text())
        size.fill('')
        self.page.locator('#save-paper').click()
        malformed = self.folder / 'broken.jsonl'
        malformed.write_text('{not json}\n')
        self.page.locator('#load-jsonl').set_input_files(str(malformed))
        self.page.wait_for_function("document.getElementById('message').textContent.includes('Line 1')")
        exported = [json.loads(line) for line in self.download('#export').read_text().splitlines()]
        self.assertIsNone(exported[0]['samples'][0]['sample_size'])
        self.assertEqual(len(exported), 3)
        self.page.locator('#raw-tab').click()
        self.page.locator('#raw-json').fill('null')
        self.page.locator('#apply-raw').click()
        self.assertIn('expected object', self.page.locator('#errors').inner_text())
        self.page.locator('#raw-json').fill(json.dumps(exported[0]))
        self.page.locator('#apply-raw').click()

    def test_session_restore_and_reset_do_not_add_review_fields(self):
        self.load()
        self.page.locator('#field-samples-0-sample_size').fill('44')
        self.page.locator('#reviewed').check()
        session = self.download('#backup')
        self.page.locator('#reset').click()
        self.assertEqual(self.page.locator('#field-samples-0-sample_size').input_value(), '11')
        self.page.locator('summary').filter(has_text='Optional files').click()
        self.page.locator('#load-session').set_input_files(str(session))
        self.page.wait_for_function("document.getElementById('field-samples-0-sample_size').value==='44'")
        self.assertTrue(self.page.locator('#reviewed').is_checked())
        output = [json.loads(line) for line in self.download('#export').read_text().splitlines()]
        self.assertEqual(output[0]['samples'][0]['sample_size'], 44)
        self.assertEqual(set(output[0]), set(self.rows[0]))

    def test_add_analysis_size_and_public_source_without_fabricated_defaults(self):
        self.load()
        analysis = self.page.locator('label[for="field-samples-0-analysis_sizes"]').locator('..')
        analysis.get_by_role('button', name='Add item', exact=True).click()
        count = self.page.locator('#field-samples-0-analysis_sizes-0-sample_size')
        self.assertEqual(count.input_value(), '')
        self.page.locator('#field-samples-0-analysis_sizes-0-label').fill('Main model B')
        count.fill('77')
        public = self.page.locator('label[for="field-samples-0-data_sources-public"]').locator('..')
        public.get_by_role('button', name='Add entry', exact=True).click()
        public.get_by_role('textbox', name='Source or field name: ', exact=True).fill('New public archive')
        public.get_by_role('textbox', name='Source or field name: ', exact=True).press('Tab')
        output = [json.loads(line) for line in self.download('#export').read_text().splitlines()]
        self.assertEqual(output[0]['samples'][0]['analysis_sizes'], [{'label': 'Main model B', 'sample_size': 77}])
        self.assertIsNone(output[0]['samples'][0]['data_sources']['public']['New public archive'])

    def test_raw_edits_preserve_multiline_text_and_reject_duplicate_ids(self):
        self.load()
        changed = copy.deepcopy(self.rows[0])
        changed['data_section_full_text'] = 'First paragraph.\n\nSecond paragraph with Unicode: α, β.'
        changed['review_notes'] = ['Manual correction.']
        self.page.locator('#raw-tab').click()
        self.page.locator('#raw-json').fill(json.dumps(changed))
        self.page.locator('#apply-raw').click()
        output = [json.loads(line) for line in self.download('#export').read_text().splitlines()]
        self.assertEqual(output[0], changed)
        changed['paper_id'] = 'W2'
        self.page.locator('#raw-json').fill(json.dumps(changed))
        self.page.locator('#apply-raw').click()
        self.assertIn('another record', self.page.locator('#errors').inner_text())

    def test_corrupt_session_cannot_replace_existing_edits(self):
        self.load()
        self.page.locator('#field-samples-0-sample_size').fill('32')
        self.page.locator('#save-paper').click()
        path = self.download('#backup')
        saved = json.loads(path.read_text())
        saved['originalLines'][0] = 'null'
        path.write_text(json.dumps(saved))
        self.page.locator('summary').filter(has_text='Optional files').click()
        self.page.locator('#load-session').set_input_files(str(path))
        self.page.wait_for_function("document.getElementById('message').textContent.includes('original records are invalid')")
        output = [json.loads(line) for line in self.download('#export').read_text().splitlines()]
        self.assertEqual(output[0]['samples'][0]['sample_size'], 32)
        self.assertEqual(len(output), 3)

    def test_evidence_reading_titles_database_list_and_literal_html(self):
        self.rows[0]['review_notes'] = ['<img src=x onerror="window.reviewXSS=true">']
        self.fixture.write_text(''.join(json.dumps(r) + '\n' for r in self.rows))
        self.load()
        self.assertIsNone(self.page.evaluate('window.reviewXSS'))
        self.page.locator('summary').filter(has_text='Optional files').click()
        bibliography = self.folder / 'papers.jsonl'
        bibliography.write_text(json.dumps({'paper_id': 'W1', 'title': 'A useful paper title'}) + '\n')
        self.page.locator('#load-bibliography').set_input_files(str(bibliography))
        self.page.wait_for_function("document.getElementById('paper-title').textContent==='A useful paper title'")
        self.page.locator('#load-databases').set_input_files(str(ROOT / 'skills/extract-accounting-samples/references/databases.json'))
        source = self.page.locator('#field-samples-0-data_sources-commercial_standardized-0')
        source.wait_for()
        self.page.wait_for_function("document.getElementById('field-samples-0-data_sources-commercial_standardized-0').tagName==='SELECT'")
        source.select_option(json.dumps('CRSP'))
        self.page.locator('#save-paper').click()
        reading = self.folder / 'reading.json'
        reading.write_text(json.dumps({'paper_id': 'W1', 'pages': [{'page': 1, 'text': 'Full source page <script>unsafe()</script>'}]}))
        self.page.locator('#load-reading').set_input_files(str(reading))
        self.page.wait_for_function("document.querySelector('.reading-page')!==null")
        self.assertIn('<script>unsafe()</script>', self.page.locator('.reading-page').inner_text())
        self.page.locator('#next').click()
        self.assertIn('Attach the matching', self.page.locator('#reference-body').inner_text())
        self.page.locator('#load-reading').set_input_files(str(reading))
        self.page.wait_for_function("document.getElementById('message').textContent.includes('does not match')")
        self.page.set_viewport_size({'width': 390, 'height': 844})
        self.assertLessEqual(self.page.evaluate('document.documentElement.scrollWidth'), 390)

    @unittest.skipUnless(FULL_SWEEP.exists(), 'Full-sweep dataset is not part of the portable utility')
    def test_actual_500_papers_unchanged_round_trip(self):
        self.load(FULL_SWEEP)
        self.assertEqual(self.page.locator('.paper-row').count(), 500)
        downloaded = self.download('#export')
        self.assertEqual(downloaded.read_bytes(), FULL_SWEEP.read_bytes())


if __name__ == '__main__':
    unittest.main()
