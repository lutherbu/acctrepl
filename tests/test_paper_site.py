"""Check the public Pages inventory and its reader under a project-site URL."""
from collections import defaultdict
import csv
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import subprocess
import tempfile
from threading import Thread
import unittest
from urllib.parse import parse_qs, quote, unquote, urlencode, urlsplit

from scripts.rebuild_site_inventory import inventory
from scripts.update_paper_catalog import RESULT_FIELDS, read_jsonl
from test_reviewer import BROWSER, HAS_PLAYWRIGHT, ROOT


def tracked_files(root=ROOT):
    return set(subprocess.check_output(['git', 'ls-files', '-z'], cwd=root).decode().split('\0')) - {''}


class InventoryTests(unittest.TestCase):
    def test_publication_and_catalog_coverage(self):
        files = tracked_files()
        published = json.loads((ROOT/'site/files.json').read_bytes())
        self.assertEqual(published, inventory(ROOT))
        rows = read_jsonl(ROOT/'docs/papers.jsonl')
        self.assertEqual(len(rows), len({r['paper_id'] for r in rows}))
        links = {r[key] for r in rows for key in RESULT_FIELDS if r[key]}
        self.assertTrue(links <= files)
        package_roots = {'/'.join(p.split('/')[:4]) for p in links if '/packages/' in p}
        self.assertEqual(package_roots, set(published['packages']))
        package_files = {base+'/'+f for base, members in published['packages'].items() for f in members}
        self.assertEqual(package_files, {p for p in files if '/'.join(p.split('/')[:4]) in package_roots
                                        and not p.endswith('/.gitkeep')})
        for file in links | package_files | set(published['documents']):
            self.assertTrue((ROOT/file).is_file(), file)

    def test_inventory_follows_git_index(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            subprocess.run(['git', 'init', '-q'], cwd=root, check=True)
            path = 'output/executions/packages/example'
            folder = root/path
            folder.mkdir(parents=True)
            (folder/'report.json').write_text('{}')
            (folder/'data.dta').write_text('local only')
            (folder/'code with spaces.do').touch()
            subprocess.run(['git', 'add', '--', path+'/report.json', path+'/code with spaces.do'], cwd=root, check=True)
            self.assertEqual(inventory(root)['packages'], {path: ['code with spaces.do', 'report.json']})
            subprocess.run(['git', 'mv', path+'/code with spaces.do', path+'/next.do'], cwd=root, check=True)
            self.assertEqual(inventory(root)['packages'], {path: ['next.do', 'report.json']})


class PagesHandler(SimpleHTTPRequestHandler):
    """Serve the site's public files only, mounted at /acctrepl/ as on Pages."""
    def do_GET(self):
        path = unquote(urlsplit(self.path).path)
        prefix = '/acctrepl/'
        relative = path[len(prefix):] or 'index.html'
        if not path.startswith(prefix) or relative not in self.server.public_files:
            self.send_error(404)
            return
        self.path = '/' + quote(relative)
        super().do_GET()

    def log_message(self, *args):
        pass


@unittest.skipUnless(HAS_PLAYWRIGHT and BROWSER, 'Optional Playwright/Chromium unavailable')
class PaperBrowserTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from playwright.sync_api import sync_playwright
        cls.rows = read_jsonl(ROOT/'docs/papers.jsonl')
        cls.inventory = inventory(ROOT)
        cls.server = ThreadingHTTPServer(('127.0.0.1', 0), partial(PagesHandler, directory=ROOT))
        site_assets = {f.relative_to(ROOT).as_posix() for f in (ROOT/'site').rglob('*') if f.is_file()}
        files = tracked_files()
        cls.server.public_files = {p for p in files if p.startswith(('docs/', 'output/', 'skills/', 'utils/'))}
        cls.server.public_files.update(site_assets | {'index.html', 'papers.html', 'README.md'})
        cls.base = f'http://127.0.0.1:{cls.server.server_port}/acctrepl/'
        Thread(target=cls.server.serve_forever, daemon=True).start()
        cls.addClassCleanup(cls.server.server_close)
        cls.addClassCleanup(cls.server.shutdown)
        cls.pw = sync_playwright().start()
        cls.addClassCleanup(cls.pw.stop)
        cls.browser = cls.pw.chromium.launch(executable_path=BROWSER, headless=True)
        cls.addClassCleanup(cls.browser.close)

    def setUp(self):
        self.context = self.browser.new_context(viewport={'width': 1600, 'height': 960})
        self.addCleanup(self.context.close)
        self.page = self.context.new_page()
        self.page.set_default_timeout(8000)
        self.errors, self.requests = [], []
        self.page.on('pageerror', lambda e: self.errors.append(str(e)))
        self.page.on('request', lambda r: self.requests.append(r.url))

    def tearDown(self):
        self.assertEqual(self.errors, [])
        self.assertTrue(all(url.startswith(self.base) for url in self.requests), self.requests)

    def visit(self, **params):
        self.page.goto(self.base+'papers.html?'+urlencode(params))

    def test_homepage_links_and_responsive_alignment(self):
        self.page.goto(self.base)
        for width in [1600, 390]:
            self.page.set_viewport_size({'width': width, 'height': 900})
            stats = self.page.locator('#top > .stats').bounding_box()
            self.assertAlmostEqual(stats['x']*2 + stats['width'], width, delta=1)
        cards = self.page.locator('#deliverables article')
        for i, workflow, skill in [(3, 'reproductions', 'reproduce-accounting-models'),
                                   (4, 'feasibility_execution', 'check-execution-feasibility')]:
            self.assertEqual(cards.nth(i).locator('.number').inner_text(), f'{i+1:02}')
            self.assertEqual(cards.nth(i).locator('a').first.get_attribute('href'), 'papers.html?workflow='+workflow)
            self.assertIn(skill, cards.nth(i).locator('a').last.get_attribute('href'))
        self.assertEqual(self.page.locator('a[href*="github.com"]').all_text_contents(), ['GitHub ↗', 'Source repository'])
        self.page.get_by_role('link', name='Browse the paper catalog').click()
        self.page.get_by_role('heading', name=f'{len(self.rows)} papers', exact=True).wait_for()
        self.assertTrue(self.page.evaluate('document.documentElement.scrollWidth <= innerWidth'))
        self.page.get_by_role('link', name='Next page →').click()
        self.page.get_by_text('Page 2 of', exact=False).wait_for()
        self.assertFalse(any('/output/' in url or 'site/files.json' in url for url in self.requests))

    def test_filter_shared_doi_and_navigation(self):
        by_doi = defaultdict(list)
        for row in self.rows:
            by_doi[row['doi']].append(row)
        doi, matches = next((key, group) for key, group in by_doi.items() if len(group) == 2)
        self.visit()
        search = self.page.get_by_role('searchbox')
        search.fill(doi)
        self.page.get_by_role('heading', name='2 papers', exact=True).wait_for()
        variants = self.page.locator('.variant').all_text_contents()
        self.assertEqual(len(set(variants)), 2)
        self.page.get_by_label('Journal', exact=True).select_option(matches[0]['journal'])
        self.page.get_by_label('Workflow', exact=True).select_option('feasibility_execution')
        saved = self.page.url
        self.page.locator('.paper-title').first.click()
        self.page.get_by_role('heading', name='Paper overview').wait_for()
        self.assertEqual(parse_qs(urlsplit(self.page.url).query)['paper'], [matches[0]['paper_id']])
        self.page.get_by_role('link', name='Next paper →').click()
        self.page.locator('.identifiers').get_by_text(matches[1]['paper_id'], exact=True).wait_for()
        self.page.go_back()
        self.page.locator('.identifiers').get_by_text(matches[0]['paper_id'], exact=True).wait_for()
        self.page.go_back()
        self.assertEqual(self.page.url, saved)
        self.assertEqual(search.input_value(), doi)
        self.page.go_forward()
        self.page.get_by_role('heading', name='Paper overview').wait_for()

    def test_seven_workflow_summaries_and_full_json(self):
        flows = [('samples', 'sample_path'), ('models', 'model_path'),
                 ('feasibility_reproduction', 'feasibility_reproduction_path'), ('reproductions', 'reproduction_path'),
                 ('feasibility_execution', 'feasibility_execution_path'), ('executions', 'execution_path'),
                 ('replications', 'replication_path')]
        for view, field in flows:
            with self.subTest(workflow=view):
                self.visit(workflow=view)
                n = sum(bool(row[field]) for row in self.rows)
                self.page.get_by_role('heading', name=f'{n} papers', exact=True).wait_for()
                row = next(row for row in self.rows if row[field])
                self.page.locator('.output-links').first.locator('a[href*="view='+view+'"]').click()
                full = self.page.get_by_text('Full JSON', exact=True)
                full.click()
                self.page.locator('.json-leaf strong').first.wait_for()
                self.assertIn(self.base+row[field], self.requests)
                if view == 'models':
                    self.page.get_by_role('heading', name='Reported estimates').first.wait_for()
                    self.visit(paper=row['paper_id'], view='models')
                    self.page.get_by_role('link', name='Next paper →').click()
                    self.page.get_by_role('heading', name='Models & reported results', exact=True).wait_for()
                    next_id = [r['paper_id'] for r in self.rows if r[field]][1]
                    self.assertEqual(parse_qs(urlsplit(self.page.url).query)['paper'], [next_id])
                if view == 'reproductions':
                    self.page.get_by_role('link', name='accepted.json', exact=True).click()
                    self.page.get_by_text('JSON contents', exact=True).wait_for()

    def test_package_alias_nested_file_and_unknown_file(self):
        row = next(r for r in self.rows if r['paper_id'].startswith('W') and r['feasibility_execution_path'])
        self.visit(paper=row['paper_id'], view='feasibility_execution')
        self.page.get_by_role('link', name='patch_proposal.md', exact=True).click()
        self.page.locator('.reading .prose').wait_for()
        self.assertIn(self.base+row['feasibility_execution_path'].replace('assessment.json', 'patch_proposal.md'), self.requests)
        row = next(r for r in self.rows if r['execution_path'] and any(' ' in f and f.endswith('.do')
                   for f in self.inventory['packages'][r['execution_path'].rsplit('/', 1)[0]]))
        base = row['execution_path'].rsplit('/', 1)[0]
        file = next(f for f in self.inventory['packages'][base] if ' ' in f and f.endswith('.do'))
        self.visit(paper=row['paper_id'], view='executions', file=file)
        self.page.locator('pre.code').wait_for()
        self.assertEqual(self.page.locator('.file-tree [aria-current]').inner_text(), Path(file).name)
        self.page.set_viewport_size({'width': 390, 'height': 844})
        self.page.locator('.package-files:not([open])').wait_for()
        self.page.get_by_text('Package files', exact=True).click()
        self.page.locator('.file-tree [aria-current]').wait_for()
        self.visit(paper=row['paper_id'], view='executions', file='../../README.md')
        self.page.get_by_role('alert').wait_for()
        self.assertNotIn(self.base+'README.md', self.requests)

    def test_table_preview_download_and_year_filter(self):
        row = next(r for r in self.rows if r['execution_path'] and any(f.endswith('.csv')
                   for f in self.inventory['packages'][r['execution_path'].rsplit('/', 1)[0]]))
        base = row['execution_path'].rsplit('/', 1)[0]
        file = next(f for f in self.inventory['packages'][base] if f.endswith('.csv'))
        self.visit(workflow='executions')
        self.page.get_by_label('Year', exact=True).select_option(str(row['publication_year']))
        n = sum(bool(r['execution_path']) and r['publication_year'] == row['publication_year'] for r in self.rows)
        self.page.get_by_role('heading', name=f'{n} paper' + ('s' if n != 1 else ''), exact=True).wait_for()
        self.page.get_by_role('searchbox').fill('missing-paper-example-000')
        self.page.get_by_text('No papers match these filters.').wait_for()
        self.page.get_by_role('link', name='Clear filters').click()
        self.page.get_by_role('heading', name=f'{len(self.rows)} papers', exact=True).wait_for()
        self.visit(paper=row['paper_id'], view='executions', file=file)
        self.page.locator('.reading .data-table').wait_for()
        with (ROOT/base/file).open(encoding='utf-8-sig', newline='') as f:
            self.assertEqual(self.page.locator('.reading th').all_text_contents(), next(csv.reader(f)))
        with self.page.expect_download() as event:
            self.page.get_by_role('link', name='Download file', exact=True).click()
        self.assertEqual(event.value.suggested_filename, Path(file).name)

    def test_documentation_headings_and_sources(self):
        self.visit(doc='README.md')
        self.page.get_by_role('link', name='Build a local resource catalog', exact=True).click()
        self.assertEqual(urlsplit(self.page.url).fragment, 'build-a-local-resource-catalog')
        self.page.get_by_role('link', name='bundled aliases').click()
        self.page.get_by_text('JSON contents', exact=True).wait_for()
        for skill in sorted(p for p in self.inventory['documents'] if p.endswith('/SKILL.md')):
            self.visit(doc=skill)
            self.page.locator('.prose h1').wait_for()
            self.assertEqual(self.page.locator('.doc-menu a[href^="#"]').count(),
                             self.page.locator('.prose h2, .prose h3').count(), skill)
        self.visit(doc='skills/check-execution-feasibility/SKILL.md')
        self.page.get_by_role('link', name='Catalog setup').click()
        self.page.locator('#build-a-local-resource-catalog').wait_for()
        self.assertEqual(urlsplit(self.page.url).fragment, 'build-a-local-resource-catalog')
        self.page.get_by_role('link', name='Browse papers on GitHub Pages').click()
        self.page.get_by_role('heading', name='Paper catalog', exact=True).wait_for()
