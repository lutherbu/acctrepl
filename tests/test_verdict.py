"""Exercise the manual verdict editor against a disposable local checkout."""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import re
import shutil
import tempfile
from threading import Thread
import unittest

from scripts.site_progress import cohort_progress
from test_reviewer import BROWSER, HAS_PLAYWRIGHT, ROOT


SCHEMA = Path('skills/check-replication-feasibility/references/feasibility_classification.schema.json')
PAPER = 'W100'
PACKAGE = 'jar-111111111111'
SECOND = 'jar-222222222222'


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value), encoding='utf-8')


def make_checkout(root):
    (root/'utils').mkdir(parents=True)
    shutil.copy(ROOT/'utils/verdict.html', root/'utils/verdict.html')
    shutil.copytree(ROOT/'site', root/'site')
    (root/SCHEMA.parent).mkdir(parents=True)
    shutil.copy(ROOT/SCHEMA, root/SCHEMA)
    (root/'docs').mkdir()
    rows = []
    for n in range(100, 129):
        pid = SECOND if n == 101 else f'W{n}'
        row = {'paper_id': pid, 'title': f'Firm investment {n}', 'authors': 'Author One; Author Two',
               'journal': 'JAR' if n < 102 else 'TAR', 'publication_year': 2019,
               'doi': f'10.1000/study{n}', 'cohorts': ['top_100_cited'], 'jar_packages': [],
               'pdf_path': None}
        if n < 102:
            pkg = PACKAGE if n == 100 else SECOND
            path = f'output/feasibility_execution/packages/{pkg}/assessment.json'
            row.update({'cohorts': ['top_100_cited', 'jar_package'] if n == 100 else ['jar_package'],
                        'jar_packages': [{'package_id': pkg}], 'feasibility_execution_path': path})
            write_json(root/path, {'package_id': pkg, 'scopes': [
                {'id': 'full_pipeline', 'data_status': 'local_available'},
                {'id': 'analysis_only', 'data_status': 'undetermined'}]})
        if n == 100:
            path = f'output/feasibility_reproduction/records/{pid}.json'
            row.update({'feasibility_reproduction_path': path, 'pdf_path': f'papers/pdf/{pid}.pdf'})
            write_json(root/path, {'paper_id': pid, 'eligibility': 'eligible',
                                   'assessments': [{'data_status': 'local_ready'}]})
            (root/'papers/pdf').mkdir(parents=True)
            (root/row['pdf_path']).write_bytes(b'%PDF-1.4\n%%EOF\n')
        rows.append(row)
    (root/'docs/papers.jsonl').write_text(''.join(json.dumps(r) + '\n' for r in rows))
    write_json(root/'site/progress_overrides.json', {
        'cited': {'ids_by_verdict': {'access_blocked': [PAPER, 'W128']}},
        'jar': {'reclassify': {'undetermined': 'public_acquisition_required'}}})


class QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, *args):
        pass


@unittest.skipUnless(HAS_PLAYWRIGHT and BROWSER, 'Optional Playwright/Chromium unavailable')
class VerdictTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from playwright.sync_api import sync_playwright
        tmp = tempfile.TemporaryDirectory()
        cls.addClassCleanup(tmp.cleanup)
        cls.root = Path(tmp.name)/'acctrepl'
        make_checkout(cls.root)
        cls.server = ThreadingHTTPServer(('127.0.0.1', 0), partial(QuietHandler, directory=tmp.name))
        Thread(target=cls.server.serve_forever, daemon=True).start()
        cls.addClassCleanup(cls.server.server_close)
        cls.addClassCleanup(cls.server.shutdown)
        cls.base = f'http://127.0.0.1:{cls.server.server_port}/acctrepl/'
        pw = sync_playwright().start()
        cls.addClassCleanup(pw.stop)
        cls.browser = pw.chromium.launch(executable_path=BROWSER, headless=True)
        cls.addClassCleanup(cls.browser.close)

    def setUp(self):
        from playwright.sync_api import expect
        self.expect = expect
        self.context = self.browser.new_context(accept_downloads=True)
        self.addCleanup(self.context.close)
        self.page = self.context.new_page()
        self.page.set_default_timeout(8000)
        self.page.on('dialog', lambda dialog: dialog.accept())
        self.errors = []
        self.page.on('pageerror', lambda error: self.errors.append(str(error)))
        self.page.goto(self.base + 'utils/verdict.html')
        self.page.locator('tr[data-paper-id]').first.wait_for()

    def tearDown(self):
        self.assertEqual(self.errors, [])

    def select(self, cohort, subject):
        return self.page.locator(f'select[data-cohort="{cohort}"][data-id="{subject}"]')

    def download(self):
        with self.page.expect_download() as event:
            self.page.locator('#export-verdicts').click()
        self.assertEqual(event.value.suggested_filename, 'progress_overrides.json')
        return json.loads(event.value.path().read_bytes())

    def test_cohort_overrides_round_trip_and_restore_inheritance(self):
        self.page.locator('#search').fill(PAPER)
        cited = self.select('cited', PAPER)
        jar = self.select('jar', PACKAGE)
        self.expect(cited).to_have_value('access_blocked')
        self.expect(jar.locator('option[value=""]')).to_contain_text(re.compile('public', re.I))
        schema = json.loads((self.root/SCHEMA).read_bytes())
        options = jar.locator('option').evaluate_all('(opts) => opts.map(o => o.value).filter(Boolean)')
        self.assertEqual(set(options), set(schema['$defs']['data_status']['enum']))
        original = (self.root/'site/progress_overrides.json').read_bytes()
        cited.select_option('no_observed_data_required')
        jar.select_option('access_blocked')
        edited = self.download()
        counts = cohort_progress(self.root, edited)
        self.assertEqual(counts['cited']['classes']['no_observed_data_required']['unexecuted'], 1)
        self.assertEqual(counts['cited']['classes']['access_blocked']['unexecuted'], 1)
        self.assertEqual(counts['jar']['classes']['public_acquisition_required']['unexecuted'], 1)
        self.assertEqual(counts['jar']['classes']['access_blocked']['unexecuted'], 1)
        self.assertEqual((self.root/'site/progress_overrides.json').read_bytes(), original)
        jar.select_option('')
        self.expect(jar.locator('option:checked')).to_contain_text(re.compile('public', re.I))
        restored = self.download()
        self.assertEqual(cohort_progress(self.root, restored)['jar']['classes']
                         ['public_acquisition_required']['unexecuted'], 2)
        self.page.locator('#import-verdicts').set_input_files({
            'name': 'saved.json', 'mimeType': 'application/json', 'buffer': json.dumps(edited).encode()})
        self.page.locator('#search').fill(PAPER)
        self.expect(jar).to_have_value('access_blocked')
        self.expect(cited).to_have_value('no_observed_data_required')

    def test_catalog_navigation_and_paper_links(self):
        rows = self.page.locator('tr[data-paper-id]')
        first = rows.first.get_attribute('data-paper-id')
        self.page.locator('#next').click()
        self.expect(rows.first).not_to_have_attribute('data-paper-id', first)
        self.page.locator('#previous').click()
        self.expect(rows.first).to_have_attribute('data-paper-id', first)
        self.page.locator('#search').fill(PAPER)
        row = self.page.locator(f'tr[data-paper-id="{PAPER}"]')
        self.expect(row.locator('.paper-title')).to_have_text('Firm investment 100')
        self.assertEqual(row.get_by_role('link', name='DOI', exact=True).evaluate('a => a.href'),
                         'https://doi.org/10.1000/study100')
        pdf = row.get_by_role('link', name='Local PDF', exact=True)
        self.expect(pdf).to_be_visible()
        href = pdf.evaluate('a => a.href')
        self.assertEqual(href, self.base + f'papers/pdf/{PAPER}.pdf')
        self.assertTrue(self.context.request.get(href).body().startswith(b'%PDF-'))
        self.page.set_viewport_size({'width': 375, 'height': 820})
        self.assertTrue(self.page.evaluate('document.documentElement.scrollWidth <= innerWidth'))
        self.page.locator('#search').fill(SECOND)
        row = self.page.locator(f'tr[data-paper-id="{SECOND}"]')
        self.expect(row).to_be_visible()
        self.assertFalse(row.get_by_role('link', name='Local PDF', exact=True).count())
        with tempfile.TemporaryDirectory() as directory:
            (Path(directory)/f'{SECOND}.pdf').write_bytes(b'%PDF-1.4\n%%EOF\n')
            self.page.locator('#pdf-folder').set_input_files(directory)
            local = row.get_by_role('link', name='Local PDF', exact=True)
            self.expect(local).to_have_attribute('href', re.compile('^blob:'))

    def test_invalid_import_preserves_unsaved_verdicts(self):
        editor = self.select('cited', PAPER)
        editor.select_option('local_available')
        duplicate = {'cited': {'ids_by_verdict': {'local_available': [PAPER], 'undetermined': [PAPER]}}}
        self.page.locator('#import-verdicts').set_input_files({
            'name': 'invalid.json', 'mimeType': 'application/json', 'buffer': json.dumps(duplicate).encode()})
        self.expect(self.page.locator('#status')).to_contain_text('Could not import verdicts')
        self.expect(editor).to_have_value('local_available')
        self.assertIn(PAPER, self.download()['cited']['ids_by_verdict']['local_available'])

    def test_file_mode_reads_only_selected_checkout(self):
        paths = ['docs/papers.jsonl', 'site/progress_overrides.json', SCHEMA.as_posix(), f'papers/pdf/{PAPER}.pdf']
        files = {p: (self.root/p).read_text() for p in paths}
        self.page.add_init_script("""
          const files = %s;
          const directory = prefix => ({
            getDirectoryHandle: async name => directory(prefix + name + '/'),
            getFileHandle: async name => {
              const path = prefix + name;
              if (!(path in files)) throw new DOMException('Missing file', 'NotFoundError');
              return {getFile: async () => new File([files[path]], name)};
            },
          });
          window.showDirectoryPicker = async () => directory('');
        """ % json.dumps(files))
        self.page.goto((self.root/'utils/verdict.html').as_uri())
        self.page.get_by_role('button', name='Open local checkout').click()
        self.expect(self.select('cited', PAPER)).to_have_value('access_blocked')
        row = self.page.locator(f'tr[data-paper-id="{PAPER}"]')
        self.expect(row.get_by_role('link', name='Local PDF')).to_have_attribute('href', re.compile('^blob:'))
