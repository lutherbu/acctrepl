"""Optional local Playwright checks for utils/filter.html; no network needed."""
import copy
import json
from pathlib import Path
import re
import tempfile
import unittest

from test_reviewer import BROWSER, HAS_PLAYWRIGHT, ROOT, FULL_SWEEP, record

CATEGORIES = ('commercial_standardized', 'commercial_nonstandardized', 'public',
              'proprietary', 'primary_collection', 'unresolved')


def paper(paper_id, **sources):
    r = record(paper_id)
    r['samples'][0]['data_sources'] = {k: {} if k == 'public' else [] for k in CATEGORIES}
    r['samples'][0]['data_sources'].update(sources)
    return r


@unittest.skipUnless(HAS_PLAYWRIGHT and BROWSER, 'Optional Playwright/Chromium unavailable')
class FilterTests(unittest.TestCase):
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
        self.tmp = tempfile.TemporaryDirectory(prefix='accounting-filter-')
        self.folder = Path(self.tmp.name)
        self.context = self.browser.new_context(accept_downloads=True, viewport={'width': 1500, 'height': 1000})
        self.page = self.context.new_page()
        self.errors, self.network = [], []
        self.page.on('pageerror', lambda error: self.errors.append(str(error)))
        self.page.on('request', lambda req: self.network.append(req.url) if req.url.startswith(('http:', 'https:')) else None)
        self.page.on('dialog', lambda dialog: dialog.accept())
        self.page.goto((ROOT / 'utils/filter.html').as_uri())
        self.rows = [
            paper('A', commercial_standardized=['Compustat']),
            paper('B', commercial_standardized=['Compustat', 'CRSP']),
            paper('C'),
            paper('D', commercial_standardized=['Compustat']),
            paper('E', public={'SEC EDGAR': None}),
            paper('F', commercial_standardized=['Compustat'], unresolved=['Unidentified vendor']),
            paper('G', commercial_standardized=['Compustat']),
            paper('H'),
            paper('I', commercial_standardized=['Compustat']),
            paper('J', commercial_standardized=['Compustat'], proprietary=['Confidential data under NDA']),
            paper('K', commercial_standardized=['Compustat']),
        ]
        self.rows[0]['extra_metadata'] = {'preserved': True}
        self.rows[2].update(status='no_empirical_sample', samples=[])
        second = copy.deepcopy(self.rows[3]['samples'][0])
        second['sample_id'] = 'second'
        second['data_sources']['commercial_standardized'] = ['Worldscope']
        self.rows[3]['samples'].append(second)
        self.rows[6]['status'] = 'no_empirical_sample'  # Even contradictory leftover sources cannot include it.
        del self.rows[8]['samples'][0]['data_sources']['proprietary']
        repeated = copy.deepcopy(self.rows[10]['samples'][0])
        repeated['sample_id'] = 'second'
        self.rows[10]['samples'].append(repeated)
        self.fixture = self.folder / 'fixture.jsonl'
        self.write_fixture()

    def tearDown(self):
        self.context.close()
        self.tmp.cleanup()
        self.assertEqual(self.errors, [])
        self.assertEqual(self.network, [])

    def write_fixture(self):
        self.fixture.write_text(''.join(json.dumps(r, ensure_ascii=False) + '\n' for r in self.rows))

    def load(self, path=None):
        path = path or self.fixture
        self.page.locator('#load-jsonl').set_input_files(str(path))
        self.page.wait_for_function('(name) => document.getElementById("file-name").textContent.startsWith(name)', arg=path.name)

    def download(self, selector):
        if not self.page.locator(selector).is_visible():
            self.page.locator('.tools > summary').click()
        with self.page.expect_download() as event:
            self.page.locator(selector).click()
        path = self.folder / event.value.suggested_filename
        event.value.save_as(str(path))
        return path

    def export(self):
        return [json.loads(line) for line in self.download('#export-papers').read_text().splitlines()]

    def category(self, label):
        self.page.locator('#categories').get_by_role('button', name=re.compile('^' + re.escape(label))).click()

    def test_strict_subset_across_samples_and_automatic_exclusions(self):
        self.load()
        self.assertEqual(self.page.locator('#included-count').inner_text(), '0')
        self.page.get_by_role('checkbox', name='Compustat', exact=True).check()
        self.assertEqual([r['paper_id'] for r in self.export()], ['A', 'K'])
        self.page.get_by_role('checkbox', name='CRSP', exact=True).check()
        self.assertEqual([r['paper_id'] for r in self.export()], ['A', 'B', 'K'])
        self.page.get_by_role('checkbox', name='Worldscope', exact=True).check()
        self.assertEqual([r['paper_id'] for r in self.export()], ['A', 'B', 'D', 'K'])
        self.page.locator('#check-all').click()
        output = self.export()
        self.assertEqual([r['paper_id'] for r in output], ['A', 'B', 'D', 'E', 'F', 'J', 'K'])
        self.assertEqual(output, [self.rows[i] for i in (0, 1, 3, 4, 5, 9, 10)])
        self.assertEqual(self.page.locator('#no-data-count').inner_text(), '3')
        self.assertEqual(self.page.locator('#incomplete-count').inner_text(), '1')

    def test_catalog_counts_deduplicate_samples_and_public_urls(self):
        self.rows[4]['samples'].append(copy.deepcopy(self.rows[4]['samples'][0]))
        self.rows[4]['samples'][1]['data_sources']['public']['SEC EDGAR'] = 'https://www.sec.gov/archives/'
        self.write_fixture()
        self.load()
        catalog = json.loads(self.download('#export-catalog').read_text())
        standardized = catalog['categories']['commercial_standardized']
        compustat = next(s for s in standardized if s['source_name'] == 'Compustat')
        self.assertEqual(compustat['paper_count'], 8)
        self.assertEqual(compustat['paper_ids'].count('K'), 1)
        self.assertEqual(catalog['categories']['public'], [{
            'source_name': 'SEC EDGAR', 'urls': ['https://www.sec.gov/archives/'],
            'paper_count': 1, 'paper_ids': ['E'], 'checked': False,
        }])

    def test_visible_selection_and_preview_search_do_not_change_export_scope(self):
        self.rows[1]['title'] = 'Unique needle paper'
        self.write_fixture()
        self.load()
        self.page.locator('#source-search').fill('compu')
        self.page.locator('#check-visible').click()
        self.assertEqual([r['paper_id'] for r in self.export()], ['A', 'K'])
        self.page.locator('#check-all').click()
        self.page.locator('#paper-search').fill('needle')
        self.assertEqual(self.page.locator('.paper-row').count(), 1)
        self.assertEqual(len(self.export()), 7)
        self.page.locator('#uncheck-visible').click()  # Only Compustat matches the source search.
        self.assertEqual([r['paper_id'] for r in self.export()], ['E'])

    def test_same_name_in_different_categories_requires_separate_choices(self):
        self.rows = [paper('Commercial', commercial_nonstandardized=['Shared name']),
                     paper('Public', public={'Shared name': None})]
        self.write_fixture()
        self.load()
        self.category('Public')
        self.page.get_by_role('checkbox', name='Shared name', exact=True).check()
        self.assertEqual([r['paper_id'] for r in self.export()], ['Public'])

    def test_additional_category_is_not_silently_ignored(self):
        self.rows = [paper('Custom', commercial_standardized=['Compustat'])]
        self.rows[0]['samples'][0]['data_sources']['custom_category'] = ['Custom vendor']
        self.write_fixture()
        self.load()
        self.page.get_by_role('checkbox', name='Compustat', exact=True).check()
        self.assertEqual(self.page.locator('#included-count').inner_text(), '0')
        self.page.get_by_role('checkbox', name='Allow all custom category sources', exact=True).check()
        self.assertEqual([r['paper_id'] for r in self.export()], ['Custom'])

    def test_saved_choices_and_failed_load_preserve_selection(self):
        self.load()
        self.page.get_by_role('checkbox', name='Compustat', exact=True).check()
        choices = self.download('#save-choices')
        self.page.locator('#uncheck-all').click()
        self.page.locator('#load-choices').set_input_files(str(choices))
        self.page.wait_for_function("document.getElementById('message').textContent.startsWith('Applied 1')")
        self.assertEqual([r['paper_id'] for r in self.export()], ['A', 'K'])
        broken = self.folder / 'broken.jsonl'
        broken.write_text('{broken}\n')
        self.page.locator('#load-jsonl').set_input_files(str(broken))
        self.page.wait_for_function("document.getElementById('message').textContent.includes('Line 1')")
        self.assertEqual([r['paper_id'] for r in self.export()], ['A', 'K'])

    def test_literal_html_titles_and_mobile_layout(self):
        self.rows[0]['title'] = '<img src=x onerror="window.filterXSS=true">'
        self.write_fixture()
        self.load()
        self.page.locator('#check-all').click()
        self.assertIsNone(self.page.evaluate('window.filterXSS'))
        self.assertIn('<img', self.page.locator('.paper-row').first.inner_text())
        self.page.set_viewport_size({'width': 390, 'height': 844})
        self.assertLessEqual(self.page.evaluate('document.documentElement.scrollWidth'), 390)

    @unittest.skipUnless(FULL_SWEEP.exists(), 'Full-sweep dataset is not part of the portable utility')
    def test_actual_500_matches_independent_standardized_and_public_source_filter(self):
        original = [json.loads(line) for line in FULL_SWEEP.read_text().splitlines()]
        allowed = {'commercial_standardized', 'public'}
        expected = []
        for r in original:
            if r['status'] == 'no_empirical_sample' or not r['samples']:
                continue
            eligible = True
            for sample in r['samples']:
                sources = sample['data_sources']
                if not all(c in sources for c in CATEGORIES) or not any(sources.values()):
                    eligible = False
                if any(items for c, items in sources.items() if c not in allowed):
                    eligible = False
            if eligible:
                expected.append(r)
        self.load(FULL_SWEEP)
        self.page.get_by_role('checkbox', name='Allow all Commercial · standardized sources', exact=True).check()
        self.page.get_by_role('checkbox', name='Allow all Public sources', exact=True).check()
        output = self.export()
        self.assertEqual(output, expected)
        self.assertGreater(len(output), 0)
        self.assertLess(len(output), 500)


if __name__ == '__main__':
    unittest.main()
