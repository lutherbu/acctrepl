import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("reproduction_runs", ROOT / "scripts/reproduction_runs.py")
r = importlib.util.module_from_spec(spec)
spec.loader.exec_module(r)


class ReproductionTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.p = Path(self.tmp.name)

    def tearDown(self):
        self.tmp.cleanup()

    def test_paths_reject_escape_and_external_symlink(self):
        for name in ["../outside", "/tmp/outside"]:
            with self.assertRaises(ValueError):
                r.inside(self.p, name)
        (self.p / "link").symlink_to("/tmp")
        with self.assertRaises(ValueError):
            r.inside(self.p, "link/outside")

    def test_stata_zero_os_exit_is_not_success(self):
        self.assertTrue(r.stata_failed(". regress y x\nno observations\nr(2000);\n"))
        self.assertFalse(r.stata_failed(". display \"r(2000) is a code\"\n"))
        self.assertTrue(r.stata_failed("Warning: Convergence not achieved.\n(output written to results.csv)\n"))
        self.assertFalse(r.stata_failed("Iteration 1: LL=-25 (not concave)\nIteration 2: LL=-20\n"))

    def test_cell_independence_and_forbidden_programs(self):
        base = 'version 18\nset more off\nuse "data/main/reg.dta", clear\n'
        self.assertEqual(r.code_issues(base + 'global x "a"\nregress y $x\n'), [])
        self.assertTrue(r.code_issues(base + 'regress y $x\n'))
        for bad in ['program define foo', 'mata: x=1', 'postfile p x using x', 'ereturn post b V', 'estimates save x.ster', 'do external.do']:
            self.assertTrue(r.code_issues(base + bad), bad)
        self.assertEqual(r.code_issues(base + '* program define forbidden\nregress y x\n'), [])

    def test_cached_native_log_is_rechecked(self):
        log = self.p / 'cell.log'
        state = {'ok': True, 'log': str(log)}
        self.assertFalse(r.cell_log_valid(state))
        log.write_text('Iteration 2: LL=-20\n(output written to table.csv)\n')
        self.assertTrue(r.cell_log_valid(state))
        log.write_text('Warning: Convergence not achieved.\n(output written to table.csv)\n')
        self.assertFalse(r.cell_log_valid(state))

    def test_writable_sas_libraries_stay_inside_attempt(self):
        self.assertEqual(r.sas_library_issues('libname out "data";', self.p), [])
        self.assertEqual(r.sas_library_issues('libname raw "/storage/sas/raw" access=readonly;', self.p), [])
        for code in ['libname out "../attempt_01/data";',
                     'libname raw "/storage/sas/raw";', 'libname out "&output";']:
            self.assertTrue(r.sas_library_issues(code, self.p))

    def test_sas_identifier_length_preflight(self):
        name = 'crsp_common_monthly_duplicate_keys'
        self.assertTrue(r.sas_name_warnings('%let ' + name + '=0;'))
        self.assertTrue(r.sas_name_warnings('select count(*) as ' + name + ' from x;'))
        self.assertFalse(r.sas_name_warnings('data x; ' + 'x' * 32 + '=1; run;'))
        self.assertFalse(r.sas_name_warnings(
            '/* ' + name + ' */\n* ' + name + ';\n'
            'title "' + name + '"; label x=\'a doubled \'\' quote ' + name + '\';'))

    def test_declared_catalog_path_matches_actual_sas_libref(self):
        catalog = {'datasets': [{'dataset': 'CRSP.MSI', 'path': '/source/stock/msi.sas7bdat'}]}
        code = 'libname crspi "/source/index" access=readonly; data x; set crspi.msi; run;'
        self.assertTrue(r.sas_source_path_warnings(code, ['CRSP.MSI'], catalog))
        self.assertFalse(r.sas_source_path_warnings(code.replace('/source/index', '/source/stock'), ['CRSP.MSI'], catalog))
        self.assertFalse(r.sas_source_path_warnings(
            'libname crspi "/source/index" access=readonly; /* crspi.msi */ title "crspi.msi";',
            ['CRSP.MSI'], catalog))

    def test_diagnostic_terminator_preflight(self):
        self.assertTrue(r.sas_diagnostic_warnings(
            '%put NOTE: common complete-case rows=&n; actual date=&d;'))
        self.assertFalse(r.sas_diagnostic_warnings(
            '/* %put NOTE: ignored; text; */\n'
            '%put NOTE: common complete-case rows=&n, actual date=&d;\n'
            '%put NOTE: next diagnostic;'))

    def test_cache_requires_all_outputs_and_exact_content(self):
        (self.p / "x").write_text("one")
        state = {"ok": True, "signature": "s", "outputs": {"x": r.sha(self.p / "x")}}
        self.assertTrue(r.cache_valid(self.p, state, "s", ["x"]))
        self.assertFalse(r.cache_valid(self.p, state, "changed", ["x"]))
        self.assertFalse(r.cache_valid(self.p, state, "s", ["x", "missing"]))
        (self.p / "x").write_text("two")
        self.assertFalse(r.cache_valid(self.p, state, "s", ["x"]))

    def test_quota_is_per_paper_and_precedes_any_mutation(self):
        campaign = self.p / "campaign.json"
        for limit in (3, 6):
            with self.subTest(limit=limit):
                data = {"limit_per_paper": limit, "limit_total": 47 * limit,
                        "papers": [{"paper_id": "W1", "assignments": [{} for _ in range(limit)]}]}
                r.write(campaign, data)
                with patch.object(r, "CAMPAIGN", campaign), patch.object(r, "RUNS", self.p):
                    with self.assertRaisesRegex(ValueError, "quota exhausted"):
                        r.assign("W1", "repair")
                self.assertEqual(r.read(campaign), data)

    def test_campaign_completion_requires_closed_reviews_and_followups(self):
        campaign = {"papers": [{"paper_id": "W1", "accepted_attempt": 2,
                                "assignments": [{"status": "complete"}]}]}
        self.assertTrue(r.campaign_complete(campaign, []))
        issue = {"paper_id": "W1", "status": "queued"}
        self.assertFalse(r.campaign_complete(campaign, [issue]))
        issue["status"] = "resolved"
        self.assertTrue(r.campaign_complete(campaign, [issue]))
        campaign["papers"][0]["assignments"].append({"status": "running"})
        self.assertFalse(r.campaign_complete(campaign, [issue]))
        campaign["papers"][0]["assignments"][-1]["status"] = "complete"
        campaign["papers"][0]["accepted_attempt"] = None
        self.assertFalse(r.campaign_complete(campaign, []))
        self.assertFalse(r.campaign_complete({"papers": []}, []))

    def test_user_pause_prevents_assignment_and_remains_visible(self):
        campaign = self.p / "campaign.json"
        data = {"status": "active", "limit_per_paper": 6, "limit_total": 282,
                "papers": [{"paper_id": "W1", "title": "Paused paper", "journal": "TAR",
                            "paused": True, "assignments": [], "accepted_attempt": None,
                            "expected_scopes": 2}]}
        r.write(campaign, data)
        with patch.object(r, "CAMPAIGN", campaign), patch.object(r, "RUNS", self.p):
            with self.assertRaisesRegex(ValueError, "paused by the user"):
                r.assign("W1", "build")
            self.assertEqual(r.read(campaign), data)
            result = r.summarize()
        self.assertEqual(result["campaign_status"], "paused")
        self.assertEqual(result["paused_papers"], 1)
        self.assertEqual(result["paused_scopes"], 2)
        self.assertEqual(result["accepted_papers"], 0)
        self.assertEqual(r.read(self.p / "summary.json")["rows"][0]["status"], "paused")

    def test_sas_notebook_is_exact_source(self):
        (self.p / "design.md").write_text("Scientific notes\n")
        sas = 'data out.reg; set raw.funda; run;\n'
        (self.p / "build.sas").write_text(sas)
        r.sync(self.p)
        code = ''.join(r.source(c) for c in r.read(self.p / "sas.ipynb")["cells"] if c["cell_type"] == "code")
        self.assertEqual(code, sas)

    def test_sample_keys_are_validated_before_native_execution(self):
        (self.p / "skill_snapshot").mkdir()
        template = self.p / "stata.template.ipynb"
        template.write_text("{}")
        r.write(self.p / "work_item.json", {
            "paper_id": "W1", "attempt": 1, "expected_scopes": [],
            "skill_sha256": r.tree_hash(self.p / "skill_snapshot"),
            "template_sha256": r.sha(template), "source_hashes": {},
        })
        for key in ["offer_id", [], None, [1], [{}], ["offer id"], ["id", "id"]]:
            with self.subTest(key=key):
                r.write(self.p / "submission.json", {
                    "paper_id": "W1", "attempt": 1, "fits": [],
                    "samples": [{"sample_id": "offers", "sas_file": "data/offers.sas7bdat",
                                 "dta_file": "data/reg.dta", "key": key}],
                })
                with patch.object(r, "CAMPAIGN", self.p / "absent_campaign.json"), \
                        patch.object(r.subprocess, "run") as native:
                    with self.assertRaisesRegex(ValueError, "Sample offers key"):
                        r.run(self.p)
                    native.assert_not_called()
        sub = r.read(self.p / "submission.json")
        for key in [["offer_id"], ["gvkey", "fyear"]]:
            sub["samples"][0]["key"] = key
            r.write(self.p / "submission.json", sub)
            with patch.object(r, "CAMPAIGN", self.p / "absent_campaign.json"):
                self.assertTrue(r.validate(self.p)["valid"])

    def test_changed_campaign_inputs_prevent_new_assignments(self):
        source = self.p / 'frozen.jsonl'; source.write_text('original')
        data = {'limit_per_paper': 3, 'limit_total': 141,
                'inputs': {'frozen.jsonl': r.sha(source)},
                'papers': [{'paper_id': 'W1', 'assignments': []}]}
        campaign = self.p / 'campaign.json'; r.write(campaign, data)
        source.write_text('changed')
        with patch.object(r, 'PROJECT', self.p), patch.object(r, 'CAMPAIGN', campaign), patch.object(r, 'RUNS', self.p):
            with self.assertRaisesRegex(ValueError, 'Frozen campaign input changed'):
                r.assign('W1', 'build')
        self.assertEqual(r.read(campaign), data)

    def test_reuse_rejects_changed_construction(self):
        previous = self.p / "previous"; current = self.p / "current"
        previous.mkdir(); current.mkdir()
        for root in [previous, current]:
            r.write(root / "submission.json", {"samples": []})
        (previous / "build.sas").write_text("previous")
        (current / "build.sas").write_text("changed")
        with self.assertRaisesRegex(ValueError, "rebuild"):
            r.reuse_data(current, previous)

    def test_actual_additional_source_invalidates_construction_cache(self):
        data = self.p / "raw.sas7bdat"; data.write_bytes(b"first")
        r.write(self.p / "catalog.json", {"datasets": [{"dataset": "CRSP.MSIX", "path": str(data)}]})
        r.write(self.p / "work_item.json", {"catalog_path": str(self.p / "catalog.json")})
        (self.p / "build.sas").write_text("data construction;")
        sub = {"samples": [], "source_datasets": ["CRSP.MSIX"]}
        signature = r.construction_signature(self.p, sub)
        data.write_bytes(b"different source vintage")
        self.assertNotEqual(signature, r.construction_signature(self.p, sub))
        sub["source_datasets"] = ["UNKNOWN.TABLE"]
        with self.assertRaisesRegex(ValueError, "Unlisted"):
            r.construction_signature(self.p, sub)


if __name__ == "__main__":
    unittest.main()
