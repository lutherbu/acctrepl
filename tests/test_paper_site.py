"""Check the public Pages inventory and its reader under a project-site URL."""
from collections import defaultdict
import csv
from datetime import datetime
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import subprocess
import tempfile
from threading import Thread
import unittest
from unittest.mock import patch
from urllib.parse import parse_qs, quote, unquote, urlencode, urlsplit

from scripts.rebuild_site_inventory import inventory
from scripts import site_progress
from scripts.site_progress import cohort_progress
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

    def test_catalog_publication_windows(self):
        jar_volumes = {f'JAR-Volume {v}' for v in range(51, 59)}
        rows = read_jsonl(ROOT/'docs/papers.jsonl')
        for row in rows:
            if 'top_100_cited' in row['cohorts']:
                self.assertIn(row['publication_year'], range(2000, 2021), row['paper_id'])
            for package in row['jar_packages']:
                directory = Path(package['directory_path'])
                self.assertIn(directory.parts[2], jar_volumes, package['package_id'])

    def test_site_progress_matches_publications(self):
        progress = json.loads((ROOT/'site/progress.json').read_bytes())
        stamp = progress.pop('updated_at')
        self.assertEqual(datetime.fromisoformat(stamp).isoformat(timespec='seconds'), stamp.removesuffix('Z') + '+00:00')
        self.assertEqual(progress, cohort_progress(ROOT))
        rows = read_jsonl(ROOT/'docs/papers.jsonl')
        totals = {'cited': sum('top_100_cited' in row['cohorts'] for row in rows),
                  'jar': len({p['package_id'] for row in rows for p in row['jar_packages']})}
        schema = ROOT/'skills/check-replication-feasibility/references/feasibility_classification.schema.json'
        categories = set(json.loads(schema.read_bytes())['$defs']['classification']['enum'])
        for cohort, total in totals.items():
            data = progress[cohort]
            self.assertEqual(set(data['classes']), categories | {'unclassified'})
            self.assertEqual(data['total'], total)
            self.assertEqual(sum(sum(counts.values()) for counts in data['classes'].values()), total)
            for category, assignments in data['manual_verdicts'].items():
                self.assertIn(category, categories)
                self.assertLessEqual(assignments, sum(data['classes'][category].values()))

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


class ManualVerdictTests(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.root = Path(tmp.name)
        schema = Path('skills/check-replication-feasibility/references/feasibility_classification.schema.json')
        (self.root/schema.parent).mkdir(parents=True)
        (self.root/schema).write_bytes((ROOT/schema).read_bytes())
        (self.root/'site').mkdir()
        (self.root/'docs').mkdir()
        rows = [
            {'paper_id': 'W100', 'cohorts': ['top_100_cited'], 'jar_packages': []},
            {'paper_id': 'W101', 'cohorts': ['top_100_cited'], 'jar_packages': []},
        ]
        for package_id, verdict in [('jar-111111111111', 'undetermined'), ('jar-222222222222', 'local_available')]:
            rows.append({'paper_id': package_id, 'cohorts': ['jar_package'],
                         'jar_packages': [{'package_id': package_id}]})
            folder = self.root/'output/feasibility_execution/packages'/package_id
            folder.mkdir(parents=True)
            (folder/'assessment.json').write_text(json.dumps({
                'package_id': package_id, 'scopes': [{'id': 'full_pipeline', 'data_status': verdict, 'execution_readiness': 'preparation_required'}]}))
        (self.root/'docs/papers.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in rows))
        overrides = {'cited': {'ids_by_verdict': {'access_blocked': ['W100']}},
                     'jar': {'reclassify': {'undetermined': 'public_acquisition_required'}}}
        (self.root/'site/progress_overrides.json').write_text(json.dumps(overrides))

    def test_id_assignments_and_scope_rule_are_distinct(self):
        before = {p: p.read_bytes() for p in (self.root/'output').rglob('assessment.json')}
        data = cohort_progress(self.root)
        cited, jar = data['cited'], data['jar']
        self.assertEqual(cited['classes']['blocked']['unexecuted'], 1)
        self.assertEqual(cited['classes']['unclassified']['unexecuted'], 1)
        self.assertEqual(cited['manual_verdicts']['blocked'], 1)
        self.assertEqual(jar['classes']['preparation_required']['unexecuted'], 1)
        self.assertEqual(jar['classes']['ready']['unexecuted'], 1)
        self.assertEqual(jar['manual_verdicts']['preparation_required'], 1)
        self.assertEqual(sum(jar['manual_verdicts'].values()), 1)
        self.assertEqual(before, {p: p.read_bytes() for p in before})

    def test_two_confirmations_before_writing(self):
        for responses in (['no'], [EOFError()], ['yes', 'no'], ['yes', EOFError()], ['yes', 'yes']):
            with (self.subTest(responses=responses), patch.object(site_progress, 'PROJECT', self.root),
                  patch('sys.argv', ['site_progress.py']), patch('sys.stdin.isatty', return_value=True),
                  patch('builtins.input', side_effect=responses) as ask, patch.object(site_progress, '_atomic_write') as write):
                if responses == ['yes', 'yes']:
                    site_progress.main()
                    write.assert_called_once()
                    target, raw = write.call_args.args
                    self.assertEqual(target, self.root/'site/progress.json')
                    saved = json.loads(raw)
                    self.assertRegex(saved.pop('updated_at'), r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$')
                    self.assertEqual(saved, cohort_progress(self.root))
                else:
                    with self.assertRaises(SystemExit):
                        site_progress.main()
                    write.assert_not_called()
                self.assertEqual(ask.call_count, len(responses))

    def test_noninteractive_write_refuses_before_prompting(self):
        with (patch.object(site_progress, 'PROJECT', self.root), patch('sys.argv', ['site_progress.py']),
              patch('sys.stdin.isatty', return_value=False), patch('builtins.input') as ask,
              patch.object(site_progress, '_atomic_write') as write):
            with self.assertRaises(SystemExit):
                site_progress.main()
            ask.assert_not_called()
            write.assert_not_called()

    def test_check_is_unattended_and_read_only(self):
        snapshot = self.root/'site/progress.json'
        counts = cohort_progress(self.root)
        current = {'updated_at': '2025-02-27T08:43:12Z', **counts}
        snapshot.write_bytes(site_progress.encoded(current))
        with patch.object(site_progress, 'PROJECT', self.root), patch('sys.argv', ['site_progress.py', '--check']), \
                patch('builtins.input') as ask, patch.object(site_progress, '_atomic_write') as write:
            site_progress.main()
            for invalid in (counts, {**current, 'updated_at': '2025-02-30T08:43:12Z'},
                            {**current, 'updated_at': '2025-02-27T08:43:12'}, {**current, 'cited': {}}):
                snapshot.write_bytes(site_progress.encoded(invalid))
                with self.assertRaises(SystemExit):
                    site_progress.main()
            ask.assert_not_called()
            write.assert_not_called()

    def test_update_time_changes_only_when_counts_change(self):
        path = self.root/'site/progress.json'
        old_stamp = '2020-01-15T09:20:04Z'
        old = {'updated_at': old_stamp, **cohort_progress(self.root)}
        path.write_bytes(site_progress.encoded(old))
        with (patch.object(site_progress, 'PROJECT', self.root), patch('sys.argv', ['site_progress.py']),
              patch('sys.stdin.isatty', return_value=True), patch('builtins.input', return_value='yes') as ask):
            site_progress.main()
            self.assertEqual(json.loads(path.read_bytes()), old)
            self.assertEqual(ask.call_count, 2)
            with (self.root/'docs/papers.jsonl').open('a') as catalog:
                catalog.write(json.dumps({'paper_id': 'W102', 'cohorts': ['top_100_cited'], 'jar_packages': []}) + '\n')
            site_progress.main()
            new = json.loads(path.read_bytes())
            self.assertNotEqual(new.pop('updated_at'), old_stamp)
            self.assertEqual(new, cohort_progress(self.root))
            self.assertEqual(ask.call_count, 4)


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
        cls.server.public_files.update(site_assets | {'index.html', 'README.md', 'LICENSE'})
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
        self.page.goto(self.base+'index.html?'+urlencode(params))

    def test_homepage_links_and_responsive_alignment(self):
        self.page.goto(self.base)
        papers = self.page.locator('#papers')
        papers.get_by_role('heading', name=f'{len(self.rows)} catalog records', exact=True).wait_for()
        self.assertEqual(self.page.locator('#top > section').evaluate_all('(items) => items.map(el => el.id)'),
                         ['project', 'deliverables', 'papers'])
        self.assertEqual(self.page.evaluate('scrollY'), 0)
        summary = self.page.get_by_role('group', name='Project at a glance')
        progress = json.loads((ROOT/'site/progress.json').read_bytes())
        executed = sum(counts['executed'] for key in ('cited', 'jar') for counts in progress[key]['classes'].values())
        self.assertEqual(summary.locator('strong').all_text_contents(), [str(len(self.rows)), str(executed)])
        overlap = sum('top_100_cited' in row['cohorts'] and bool(row['jar_packages']) for row in self.rows)
        self.assertIn(f"{progress['cited']['total']} top-cited papers + {progress['jar']['total']} JAR packages "
                      f"− {overlap} overlaps", summary.inner_text())
        for width in [1600, 390]:
            self.page.set_viewport_size({'width': width, 'height': 900})
            stats = summary.bounding_box()
            self.assertAlmostEqual(stats['x']*2 + stats['width'], width, delta=1)
            first, second = [box.bounding_box() for box in summary.locator('.stat').all()]
            self.assertEqual(first['y'] == second['y'], width == 1600)
        cards = self.page.locator('#deliverables article')
        for i, workflow, skill in [(3, 'reproductions', 'reproduce-accounting-models'),
                                   (4, 'feasibility_execution', 'check-execution-feasibility')]:
            self.assertEqual(cards.nth(i).locator('.number').inner_text(), f'{i+1:02}')
            self.assertEqual(cards.nth(i).locator('a').first.get_attribute('href'), 'index.html?workflow='+workflow+'#papers')
            self.assertIn(skill, cards.nth(i).locator('a').last.get_attribute('href'))
        self.assertEqual(self.page.locator('a[href*="github.com"]').all_text_contents(), ['GitHub ↗', 'Source repository'])
        self.page.get_by_role('link', name='Browse the paper catalog').click()
        self.page.wait_for_url(self.base+'#papers')
        catalog_at_top = 'Math.abs(document.querySelector("#papers").getBoundingClientRect().top) < 2'
        self.page.wait_for_function(catalog_at_top)
        self.assertEqual(self.requests.count(self.base+'docs/papers.jsonl'), 1)
        self.assertTrue(self.page.evaluate('document.documentElement.scrollWidth <= innerWidth'))
        self.page.get_by_role('link', name='Next page →').click()
        self.page.get_by_text('Page 2 of', exact=False).wait_for()
        self.page.wait_for_function(catalog_at_top)
        self.assertFalse(any('/output/' in url or 'site/files.json' in url for url in self.requests))

    def test_homepage_deep_links_open_filters_packages_and_guide_sections(self):
        row = next(r for r in self.rows if r['feasibility_execution_path'])
        package = urlencode({'paper': row['paper_id'], 'view': 'feasibility_execution', 'file': 'patch_proposal.md'})
        for suffix, selector in [
                ('#papers', '#papers .catalog-table'),
                ('?workflow=models&page=2#papers', '#papers .catalog-table'),
                ('?' + package, '.reading .prose'),
                ('?doc=README.md#build-a-local-resource-catalog', '#build-a-local-resource-catalog')]:
            with self.subTest(link=suffix):
                url = self.base+'index.html'+suffix
                self.page.goto(url)
                self.page.locator(selector).wait_for()
                self.assertEqual(self.page.url, url)
        self.assertFalse(self.page.locator('#project').is_visible())
        self.page.get_by_role('navigation', name='Main navigation').get_by_role('link', name='Papers').click()
        self.page.wait_for_url(self.base+'index.html#papers')
        self.page.locator('#papers .catalog-table').wait_for()
        self.assertTrue(self.page.locator('#project').is_visible())

    def test_footer_license_matches_published_file(self):
        self.page.goto(self.base)
        footer = self.page.locator('footer')
        self.assertIn('© 2026 Luther Bu', footer.inner_text())
        footer.get_by_role('link', name='MIT License', exact=True).click()
        self.page.get_by_role('heading', name='MIT License', exact=True).wait_for()
        license_text = (ROOT/'LICENSE').read_text()
        self.assertEqual(self.page.locator('.reading .prose').inner_text().split(), license_text.split())
        self.assertEqual(self.page.get_by_role('link', name='Download file').get_attribute('href'), 'LICENSE')
        self.assertTrue(footer.get_by_role('link', name='MIT License').is_visible())

    def test_catalog_downloads_without_javascript(self):
        context = self.browser.new_context(java_script_enabled=False)
        self.addCleanup(context.close)
        page = context.new_page()
        page.goto(self.base+'index.html#papers')
        catalog = page.locator('#papers')
        self.assertIn('Enable JavaScript', catalog.inner_text())
        for label in ['CSV', 'JSONL']:
            self.assertEqual(catalog.get_by_role('link', name=label).get_attribute('href'), 'docs/papers.'+label.lower())
        self.assertEqual(page.locator('footer [rel=license]').get_attribute('href'), 'LICENSE')
        self.assertTrue(page.locator('#project a[href="site/progress.json"]').is_visible())

    def test_cohort_composition_and_responsive_bars(self):
        self.page.goto(self.base)
        charts = self.page.locator('#project figure.cohort-chart')
        charts.first.wait_for()
        self.assertEqual(charts.count(), 2)
        progress = json.loads((ROOT/'site/progress.json').read_bytes())
        updated = self.page.locator('time#progress-updated')
        self.assertTrue(updated.is_visible())
        self.assertEqual(updated.get_attribute('datetime'), progress.pop('updated_at'))
        self.assertTrue(updated.inner_text().strip())
        self.assertEqual(self.requests.count(self.base+'site/progress.json'), 1)
        for cohort, data in progress.items():
            chart = self.page.locator(f'#project figure.cohort-chart[data-cohort="{cohort}"]')
            with self.subTest(cohort=cohort):
                self.assertTrue(chart.locator('figcaption').is_visible())
                rows = chart.locator('.cohort-table tbody tr[data-category]')
                rows.first.wait_for(state='attached')
                entries = rows.evaluate_all("""items => items.map(el => [el.dataset.category,
                    ...Array.from(el.querySelectorAll('td'), cell => Number(cell.innerText.replaceAll(',', '')))])""")
                expected = {category: [counts['executed'], counts['unexecuted']]
                            for category, counts in data['classes'].items()
                            if category != 'unclassified' or sum(counts.values())}
                self.assertEqual({category: counts for category, *counts in entries}, expected)
                self.assertEqual(rows.locator('th small').count(), int('unclassified' in expected))
                segments = {(category, state): count for category, counts in data['classes'].items()
                            for state, count in counts.items() if count}
                for width in (1600, 390):
                    self.page.set_viewport_size({'width': width, 'height': 900})
                    track = chart.locator('.cohort-track')
                    sizes = track.locator('[data-count]').evaluate_all("""items => items.map(el => [
                        el.dataset.category, el.dataset.state, Number(el.dataset.count), el.getBoundingClientRect().width,
                        getComputedStyle(el).backgroundImage])""")
                    self.assertEqual({(category, state): count for category, state, count, _, _ in sizes}, segments)
                    track_width = track.bounding_box()['width']
                    for _, state, count, size, background in sizes:
                        self.assertAlmostEqual(size, track_width * count / data['total'], delta=2)
                        self.assertEqual(background != 'none', state == 'unexecuted')
                    box = chart.bounding_box()
                    self.assertGreaterEqual(box['x'], 0)
                    self.assertLessEqual(box['x'] + box['width'], width)

    def test_filter_shared_doi_and_navigation(self):
        by_doi = defaultdict(list)
        for row in self.rows:
            by_doi[row['doi']].append(row)
        doi, matches = next((key, group) for key, group in by_doi.items() if len(group) == 2)
        self.visit()
        search = self.page.get_by_role('searchbox')
        search.fill(doi)
        self.page.get_by_role('heading', name='2 catalog records', exact=True).wait_for()
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
                self.page.get_by_role('heading', name=f'{n} catalog records', exact=True).wait_for()
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
        row = next(r for r in self.rows if r['reproduction_path'] and any(f.endswith('.csv')
                   for f in self.inventory['packages'][r['reproduction_path'].rsplit('/', 2)[0]]))
        base = row['reproduction_path'].rsplit('/', 2)[0]
        file = next(f for f in self.inventory['packages'][base] if f.endswith('.csv'))
        self.visit(workflow='reproductions')
        self.page.get_by_label('Year', exact=True).select_option(str(row['publication_year']))
        n = sum(bool(r['reproduction_path']) and r['publication_year'] == row['publication_year'] for r in self.rows)
        self.page.get_by_role('heading', name=f'{n} catalog record' + ('s' if n != 1 else ''), exact=True).wait_for()
        self.page.get_by_role('searchbox').fill('missing-paper-example-000')
        self.page.get_by_text('No catalog records match these filters.').wait_for()
        self.page.get_by_role('link', name='Clear filters').click()
        self.page.get_by_role('heading', name=f'{len(self.rows)} catalog records', exact=True).wait_for()
        self.visit(paper=row['paper_id'], view='reproductions', file=file)
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
