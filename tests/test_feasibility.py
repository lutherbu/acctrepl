"""Behavioral checks for evidence-backed availability and frozen campaign scopes."""
import argparse
import copy
import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / 'skills/check-replication-feasibility/scripts'
sys.path.insert(0, str(SCRIPTS))
from assessment import (ASPECTS, aggregate, calculate_summary, dependency_closure, expected_scopes,
                        finalize, output_header, year_envelope, temporal_template, WINDOW_STAGES)
from resources import parse_catalog, probe, save, sha256, build_catalog, lookup, _pg_probe
import feasibility
feasibility.PROJECT = ROOT


class AssessmentTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.project = Path(self.temp.name)
        self.reading = self.project / "reading.json"
        self.pdf = self.project / "paper.pdf"
        self.pdf.write_bytes(b"test-pdf-source")
        save(self.reading, {"paper_id": "W1", "pages": [{"page": 1, "text": "The sample uses annual earnings for US firms from 2000 to 2005."}]})
        self.model = {
            "model_id": "base", "model_role": "baseline", "method": "ols",
            "dependent_variable": {"variable_id": "dv", "name": "Earnings", "definition": "Annual earnings"},
            "independent_variables": [], "dependencies": [], "estimation_group_id": None,
            "result_sets": [{"result_set_id": "fit1"}],
        }
        self.catalog = {"catalog_sha256": "a" * 64, "datasets": [{
            "dataset": "COMP.FUNDA", "path": "/storage/sas/base/comp/funda.sas7bdat",
            "variables": [{"name": "ib"}, {"name": "gvkey"}, {"name": "fyear"}],
        }]}
        self.item = {"paper_id": "W1", "doi": None, "models": [self.model],
                     "reading_json": str(self.reading), "pdf_path": str(self.pdf),
                     "coverage_confirmations": [], "access_confirmations": [],
                     "input_hashes": {"catalog_sha256": "a" * 64, "reading_sha256": sha256(self.reading),
                                      "pdf_sha256": sha256(self.pdf), "models_inventory_sha256": "b" * 64,
                                      "samples_inventory_sha256": "c" * 64, "skill_sha256": "d" * 64}}
        self.item_path = self.project / "item.json"
        save(self.item_path, self.item)
        self.coverage = {"begin": 2000, "end": 2005, "years": [], "frequency": "annual",
                         "population": "US firms", "detail": "Original sample period"}
        self.doc = output_header(self.item, self.item_path)
        self.doc["evidence"] = [{
            "evidence_id": "p1", "kind": "paper", "locator": str(self.reading), "page": 1,
            "quote": "The sample uses annual earnings for US firms from 2000 to 2005.",
            "description": "Sample statement", "sha256": None, "verified_at": None,
        }]
        self.doc["requirements"] = [{
            "requirement_id": "earnings", "kind": "raw_measure", "description": "Annual earnings and sample",
            "required_coverage": self.coverage, "routes": [], "blocked_reason": None,
            "blocked_evidence_ids": [], "unresolved_reason": "Source coverage not yet verified.",
            "evidence_ids": ["p1"], "data_status": "undetermined",
        }]
        self.doc["assessments"] = [{
            "model_id": "base", "result_set_id": "fit1", "required_model_ids": ["base"],
            "requirement_ids": ["earnings"],
            "variable_coverage": [{"model_id": "base", "variable_id": "dv", "requirement_ids": ["earnings"],
                                   "construction": "Use annual earnings.", "non_data_reason": None}],
            "design_coverage": [{"aspect": a, "requirement_ids": ["earnings"] if a in ("sampling", "identifiers") else [],
                                 "reason": None if a in ("sampling", "identifiers") else "No additional raw input in this fixture.",
                                 "evidence_ids": ["p1"]} for a in sorted(ASPECTS)],
            "implementation_issues": [], "data_status": "undetermined", "attempt_ready": False,
            "review_notes": [],
        }]

    def check(self, doc=None):
        return finalize(doc or self.doc, self.item_path, self.catalog, self.project)

    def audit_row(self, mid="base", vid="dv"):
        return {"model_id": mid, "variable_id": vid, "requirement_ids": ["earnings"],
                "anchor_begin": 2000, "anchor_end": 2005, "anchor_basis": "Synthetic sample-year anchor",
                "components": {s: {"lookback_months": 0, "lead_months": 0,
                                   "reason": "No additional offset in this synthetic fixture."}
                               for s in WINDOW_STAGES},
                "evidence_ids": ["p1"], "non_data_reason": None}

    def write_audit(self, rows):
        path = self.project / "temporal_audit.json"
        self.item["temporal_audit_path"] = str(path)
        save(self.item_path, self.item)
        save(path, {"paper_id": "W1", "baseline_timing_review": "Review of synthetic observation dates.",
                    "records": rows})
        return path

    def test_eligible_work_item_requires_its_temporal_audit(self):
        self.item["temporal_audit_path"] = str(self.project / "missing.json")
        save(self.item_path, self.item)
        with self.assertRaisesRegex(ValueError, "temporal audit missing"):
            self.check()

    def test_temporal_offsets_reject_a_narrow_raw_requirement(self):
        row = self.audit_row()
        row["anchor_begin"] = 2004
        row["components"]["sample_offset"]["lookback_months"] = 24
        row["components"]["support_fit_window"]["lookback_months"] = 120
        row["components"]["variable_lag_or_lead"]["lookback_months"] = 12
        self.write_audit([row])
        with self.assertRaisesRegex(ValueError, "raw bound 1991"):
            self.check()
        self.doc["requirements"][0]["required_coverage"]["begin"] = 1991
        result = self.check()
        self.assertIn("temporal_audit_sha256", result["provenance"])

    def test_temporal_unknown_bound_cannot_become_a_finite_claim(self):
        row = self.audit_row()
        row["components"]["variable_lag_or_lead"]["lookback_months"] = None
        self.write_audit([row])
        with self.assertRaisesRegex(ValueError, "finite begin despite an unknown raw window"):
            self.check()

    def test_temporal_provenance_changes_when_the_audit_changes(self):
        path = self.write_audit([self.audit_row()])
        first = self.check()
        value = json.loads(path.read_text())
        value["baseline_timing_review"] += " Additional source review."
        save(path, value)
        second = self.check(first)
        self.assertNotEqual(first["provenance"]["temporal_audit_sha256"],
                            second["provenance"]["temporal_audit_sha256"])

    def test_temporal_audit_requires_each_supporting_predictor(self):
        support = {"model_id": "support", "model_role": "supporting", "dependencies": [],
                   "estimation_group_id": None, "dependent_variable": {"variable_id": "dv"},
                   "independent_variables": [{"variable_id": "iv1"}], "result_sets": []}
        self.model["dependencies"] = [{"model_id": "support"}]
        self.item["models"].append(support)
        a = self.doc["assessments"][0]
        a["required_model_ids"].append("support")
        for vid in ("dv", "iv1"):
            a["variable_coverage"].append({"model_id": "support", "variable_id": vid,
                                           "requirement_ids": ["earnings"], "construction": "Synthetic input",
                                           "non_data_reason": None})
        self.write_audit([self.audit_row("support", "dv")])
        with self.assertRaisesRegex(ValueError, "omits supporting outcomes/predictors"):
            self.check()
        self.assertEqual(len(temporal_template(self.item)["records"]), 2)

    def add_probe(self, coverage=False):
        path = self.project / "probe.json"
        save(path, {"catalog_sha256": "a" * 64, "status": "ok", "result": {
            "location": self.catalog["datasets"][0]["path"], "columns": ["ib", "gvkey", "fyear"],
            "rows_read": 1, "readable": True, "coverage_verified": coverage}})
        self.doc["evidence"].append({"evidence_id": "probe1", "kind": "probe", "locator": str(path),
                                     "page": None, "quote": None, "description": "Bounded live probe",
                                     "sha256": sha256(path), "verified_at": "2026-10-27T00:00:00Z"})
        return path

    def add_local(self, complete=False):
        self.add_probe()
        route = {"route_id": "local1", "route_type": "local_sas", "source_name": "Compustat",
                 "dataset": "COMP.FUNDA", "location": self.catalog["datasets"][0]["path"],
                 "fields": ["ib", "gvkey", "fyear"], "mapping_notes": "ib is annual earnings.",
                 "verification": {"access": "verified", "fields": "verified",
                                  "mapping": "verified",
                                  "coverage": "verified" if complete else "unverified",
                                  "identifiers": "not_applicable"},
                 "coverage_notes": "Coverage requires separate confirmation.", "evidence_ids": ["probe1"]}
        self.doc["requirements"][0]["routes"].append(route)
        if complete:
            self.doc["requirements"][0]["unresolved_reason"] = None
            path = self.project / "coverage.json"
            save(path, {"kind": "coverage_confirmation", "verification": "verified",
                        "location": route["location"], "basis": "Synthetic reviewed coverage fixture",
                        "coverage": self.coverage})
            self.item["coverage_confirmations"].append({"path": str(path), "sha256": sha256(path)})
            save(self.item_path, self.item)
            self.doc["evidence"].append({"evidence_id": "coverage1", "kind": "coverage_confirmation",
                                         "locator": str(path), "page": None, "quote": None,
                                         "description": "Reviewed coverage", "sha256": sha256(path),
                                         "verified_at": "2026-10-27T00:00:00Z"})
            route["evidence_ids"].append("coverage1")
        return route

    def add_public(self):
        self.doc["evidence"].append({"evidence_id": "web1", "kind": "public",
                                     "locator": "https://example.gov/raw-data",
                                     "page": None, "quote": "Annual earnings, 2000–2005.",
                                     "description": "Synthetic official raw-data availability fixture",
                                     "sha256": None, "verified_at": "2026-10-27T00:00:00Z"})
        route = {"route_id": "public1", "route_type": "public_raw", "source_name": "Public raw records",
                 "dataset": None, "location": "https://example.gov/raw-data", "fields": ["earnings"],
                 "mapping_notes": "Independent reconstruction from raw records",
                 "verification": {"access": "verified", "fields": "verified", "coverage": "verified",
                                  "mapping": "verified",
                                  "identifiers": "not_applicable"},
                 "coverage_notes": "Official history covers this fixture", "evidence_ids": ["web1"]}
        self.doc["requirements"][0]["routes"].append(route)
        self.doc["requirements"][0]["unresolved_reason"] = None
        return route

    def test_field_presence_is_separate_from_semantic_mapping(self):
        route = self.add_local(True)
        route["verification"]["mapping"] = "unverified"
        self.doc["requirements"][0]["unresolved_reason"] = "Column exists; original measure mapping unresolved."
        result = self.check()
        self.assertEqual(result["requirements"][0]["data_status"], "undetermined")
        self.assertFalse(result["assessments"][0]["attempt_ready"])

    def test_public_coverage_cannot_be_verified_for_unknown_event_years(self):
        self.add_public()
        self.doc["requirements"][0]["required_coverage"]["begin"] = None
        with self.assertRaisesRegex(ValueError, "unknown required calendar bounds"):
            self.check()

    def test_confirmation_cannot_be_disguised_as_a_probe(self):
        route = self.add_local(True)
        evidence = self.doc["evidence"][-1]
        path = Path(evidence["locator"])
        artifact = json.loads(path.read_text())
        artifact["catalog_sha256"] = "a" * 64
        save(path, artifact)
        evidence["kind"], evidence["sha256"] = "probe", sha256(path)
        with self.assertRaisesRegex(ValueError, "coverage confirmation"):
            self.check()

    def test_access_barrier_cannot_be_self_approved_as_a_probe(self):
        path = self.project / "self_approved.json"
        save(path, {"kind": "access_confirmation", "verification": "blocked",
                    "requirement_id": "earnings", "catalog_sha256": "a" * 64,
                    "basis": "Not a coordinator-authorized confirmation"})
        self.doc["evidence"].append({
            "evidence_id": "fake_block", "kind": "probe", "locator": str(path),
            "page": None, "quote": None, "description": "Typed as a probe, not an approved access decision.",
            "sha256": sha256(path), "verified_at": "2026-10-27T00:00:00Z"})
        self.doc["requirements"][0].update(
            blocked_reason="Candidate missing resource", blocked_evidence_ids=["fake_block"])
        with self.assertRaisesRegex(ValueError, "frozen access confirmation"):
            self.check()

    def test_unknown_not_blocked_when_catalog_or_access_missing(self):
        self.assertEqual(self.check()["summary"]["outcome"], "undetermined")

    def test_complete_local_route_and_separate_specification_issue(self):
        self.add_local(True)
        d = self.check()
        self.assertTrue(d["assessments"][0]["attempt_ready"])
        self.doc["assessments"][0]["implementation_issues"].append({
            "kind": "specification", "description": "Estimator unidentified.", "blocking": True, "evidence_ids": ["p1"]})
        d = self.check()
        self.assertEqual(d["assessments"][0]["data_status"], "local_ready")
        self.assertFalse(d["assessments"][0]["attempt_ready"])

    def test_sampled_rows_do_not_verify_coverage(self):
        route = self.add_local()
        self.assertEqual(self.check()["assessments"][0]["data_status"], "undetermined")
        route["verification"]["coverage"] = "verified"
        with self.assertRaisesRegex(ValueError, "coverage confirmation"):
            self.check()

    def test_public_acquisition_and_local_alternative_precedence(self):
        self.add_public()
        self.assertEqual(self.check()["assessments"][0]["data_status"], "public_acquisition_required")
        self.add_local(True)
        self.assertEqual(self.check()["assessments"][0]["data_status"], "local_ready")

    def test_public_route_needs_checked_url_and_timestamp(self):
        r = self.add_public()
        self.doc["evidence"][-1]["verified_at"] = None
        with self.assertRaisesRegex(ValueError, "access timestamp"):
            self.check()

    def test_unknown_dominates_public_mandatory_input(self):
        self.add_public()
        other = copy.deepcopy(self.doc["requirements"][0])
        other.update(requirement_id="other", routes=[], unresolved_reason="Another required data source unknown.")
        self.doc["requirements"].append(other)
        self.doc["assessments"][0]["requirement_ids"].append("other")
        self.assertEqual(self.check()["assessments"][0]["data_status"], "undetermined")

    def test_confirmed_blocker_requires_frozen_confirmation(self):
        r = self.doc["requirements"][0]
        r["blocked_reason"] = "Private confidential raw data confirmed unavailable under current resources."
        with self.assertRaisesRegex(ValueError, "frozen access confirmation"):
            self.check()
        path = self.project / "access.json"
        save(path, {"kind": "access_confirmation", "verification": "blocked", "requirement_id": "earnings",
                    "basis": "Synthetic explicit denied-access fixture"})
        self.item["access_confirmations"].append({"path": str(path), "sha256": sha256(path)})
        save(self.item_path, self.item)
        self.doc["evidence"].append({"evidence_id": "access1", "kind": "access_confirmation",
                                     "locator": str(path), "page": None, "quote": None,
                                     "description": "Access denied", "sha256": sha256(path),
                                     "verified_at": "2026-10-27T00:00:00Z"})
        r["blocked_evidence_ids"] = ["access1"]
        self.assertEqual(self.check()["summary"]["outcome"], "access_blocked")

    def test_probe_failure_is_not_missing_data(self):
        path = self.add_probe()
        save(path, {"catalog_sha256": "a" * 64, "status": "unverified",
                    "error": {"type": "TimeoutExpired", "detail": "Timed out"}})
        self.doc["evidence"][-1]["sha256"] = sha256(path)
        self.assertEqual(self.check()["summary"]["outcome"], "undetermined")

    def test_verified_local_access_and_fields_need_exact_live_probe(self):
        r = self.add_local()
        r["evidence_ids"] = []
        with self.assertRaisesRegex(ValueError, "successful exact-resource probe"):
            self.check()

    def test_wrong_field_or_changed_probe_rejected(self):
        r = self.add_local()
        r["fields"] = ["nonexistent_field"]
        with self.assertRaisesRegex(ValueError, "absent from catalog"):
            self.check()
        r["fields"] = ["ib"]
        (self.project / "probe.json").write_text("{}")
        with self.assertRaisesRegex(ValueError, "checksum mismatch"):
            self.check()

    def test_unapproved_coverage_confirmation_rejected(self):
        self.add_local(True)
        self.item["coverage_confirmations"] = []
        save(self.item_path, self.item)
        with self.assertRaisesRegex(ValueError, "frozen coordinator"):
            self.check()

    def test_coverage_confirmation_must_cover_original_population_and_lags(self):
        self.add_local(True)
        self.doc["requirements"][0]["required_coverage"]["begin"] = 1999
        # Deepcopy prevents accidental mutation of the independent confirmation fixture.
        with self.assertRaisesRegex(ValueError, "coverage confirmation"):
            self.check()

    def test_variable_and_design_omissions_rejected(self):
        self.doc["assessments"][0]["variable_coverage"] = []
        with self.assertRaisesRegex(ValueError, "variable coverage"):
            self.check()
        self.doc["assessments"][0]["variable_coverage"] = [{
            "model_id": "base", "variable_id": "dv", "requirement_ids": ["earnings"],
            "construction": "Use earnings", "non_data_reason": None}]
        self.doc["assessments"][0]["design_coverage"] = []
        with self.assertRaisesRegex(ValueError, "seven design aspects"):
            self.check()

    def test_unknown_fit_or_unreferenced_requirement_rejected(self):
        self.doc["assessments"][0]["result_set_id"] = "robustness_fit"
        with self.assertRaisesRegex(ValueError, "assigned baseline fit IDs"):
            self.check()

    def test_source_quote_page_and_source_hash_verified(self):
        self.doc["evidence"][0]["quote"] = "A sentence not present in the paper."
        with self.assertRaisesRegex(ValueError, "quote not found"):
            self.check()
        self.pdf.write_bytes(b"changed")
        with self.assertRaisesRegex(ValueError, "pdf_path changed"):
            self.check()

    def test_no_baseline_is_not_applicable(self):
        self.item["models"] = []
        save(self.item_path, self.item)
        doc = output_header(self.item, self.item_path)
        result = self.check(doc)
        self.assertEqual(result["summary"]["outcome"], "not_applicable")
        self.assertFalse(result["summary"]["all_data_feasible"])


class GraphAndSummaryTests(unittest.TestCase):
    def test_nested_windows_and_unknown_endpoints(self):
        value = year_envelope(2004, None, [24, 120, 12])
        self.assertEqual(value["begin"], 1991)
        self.assertIsNone(value["end"])
        self.assertEqual(year_envelope(2000, 2005, [1], [16])["end"], 2007)
        self.assertEqual(year_envelope(2000, 2005, [1], [16])["begin"], 1999)
        self.assertEqual(year_envelope(None, None)["begin"], None)
        with self.assertRaises(ValueError):
            year_envelope(2000, 2005, [-1])
    def test_supporting_and_joint_transitive_closure(self):
        models = [
            {"model_id": "b", "dependencies": [{"model_id": "s"}], "estimation_group_id": "joint"},
            {"model_id": "other", "dependencies": [{"model_id": "t"}], "estimation_group_id": "joint"},
            {"model_id": "s", "dependencies": [], "estimation_group_id": None},
            {"model_id": "t", "dependencies": [], "estimation_group_id": None},
        ]
        self.assertEqual(dependency_closure(models, "b"), ["b", "other", "s", "t"])
        models[-1]["dependencies"] = [{"model_id": "b"}]
        # This is not an explicit dependency cycle until s also reaches b.
        models[2]["dependencies"] = [{"model_id": "b"}]
        with self.assertRaisesRegex(ValueError, "cycle"):
            dependency_closure(models, "b")

    def test_blocker_precedence_and_partial_paper(self):
        self.assertEqual(aggregate(["local_ready", "undetermined", "access_blocked"]), "access_blocked")
        d = {"eligibility": "eligible", "assessments": [
            {"model_id": "a", "data_status": "local_ready", "attempt_ready": True},
            {"model_id": "b", "data_status": "undetermined", "attempt_ready": False},
        ]}
        self.assertEqual(calculate_summary(d)["outcome"], "partially_feasible")
        self.assertTrue(calculate_summary(d)["any_data_feasible"])
        self.assertFalse(calculate_summary(d)["all_data_feasible"])


class ResourceTests(unittest.TestCase):
    def test_postgres_enforces_readonly_timeout_and_parameterizes_filters(self):
        try:
            import psycopg
        except ImportError:
            self.skipTest("Optional PostgreSQL adapter is not installed")
        calls = []
        class Cursor:
            def __enter__(self): return self
            def __exit__(self, *args): pass
            def execute(self, query, params=None): calls.append((query, params))
            def fetchone(self): return ("on",)
            def fetchall(self):
                return [("id", "text"), ("year", "integer")] if len(calls) == 2 else [("A", 2001)]
        class Connection:
            def __enter__(self): return self
            def __exit__(self, *args): pass
            def cursor(self): return Cursor()
        catalog = {"resources": [{"resource_id": "postgres_wrds", "database": "wrds",
                                   "host": "127.0.0.1", "port": 5432, "user": "test"}]}
        marker = "literal'; DROP TABLE example; --"
        request = {"database": "wrds", "schema": "public", "table": "records",
                   "fields": ["id", "year"], "row_limit": 3,
                   "filters": [{"field": "id", "op": "eq", "value": marker}]}
        with patch.object(psycopg, "connect", return_value=Connection()) as connect:
            result = _pg_probe(catalog, request)
        self.assertIn("default_transaction_read_only=on", connect.call_args.kwargs["options"])
        self.assertIn("statement_timeout=5000", connect.call_args.kwargs["options"])
        self.assertEqual(calls[-1][1], [marker, 3])
        self.assertNotIn(marker, str(calls[-1][0]))
        self.assertEqual(result["rows_read"], 1)
        self.assertFalse(result["coverage_verified"])

    def test_real_catalog_wrapped_names_aliases_and_declared_counts(self):
        common = ROOT.parent / "common"
        if not (common / "data_description.txt").exists():
            self.skipTest("Local common catalog not distributed with skill")
        catalog = build_catalog(common, SCRIPTS.parent / "references/resource_aliases.json")
        datasets = {d["dataset"]: d for d in catalog["datasets"]}
        for d in datasets.values():
            self.assertEqual(len(d["variables"]), d["declared_variables"])
            self.assertEqual(len({v["name"].casefold() for v in d["variables"]}), d["declared_variables"])
        self.assertIn("benchmarkSpreadHighValue", [v["name"] for v in datasets["CIQ.WRDS_DEBT"]["variables"]])
        self.assertIn("ALLOCATED_OFFERING_PRICE_OTHER", [v["name"] for v in datasets["FISD.FISD_MERGEDISSUE"]["variables"]])
        self.assertTrue(any(h["dataset"].startswith("TRWS.") for h in lookup(catalog, "Worldscope")))
        self.assertTrue(any(len(x["datasets"]) > 1 for x in catalog["physical_files"]))
        self.assertEqual(catalog["counts"]["qualified_librefs"], catalog["counts"]["research_libraries"] + 1)

    def test_bounds_and_unknown_resources_fail_without_scan(self):
        for request in ({"kind": "sas", "row_limit": 1001}, {"kind": "sas", "row_offset": -1},
                        {"kind": "files", "timeout_seconds": 16}, {"kind": "sql"}):
            with self.assertRaises(ValueError):
                probe({"datasets": []}, request)


class CampaignTests(unittest.TestCase):
    def test_published_snapshot_replays_after_relocation(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            pdf, reading = root / "paper.pdf", root / "reading.json"
            pdf.write_bytes(b"fixture-source")
            save(reading, {"paper_id": "W1", "pages": [{"page": 1, "text": "A sample."}]})
            models, samples, manifest, catalog = [root / f for f in ("models.jsonl", "samples.jsonl", "manifest.jsonl", "catalog.json")]
            models.write_text(json.dumps({"paper_id": "W1", "doi": None, "paper_text_file": str(reading), "models": []}) + "\n")
            samples.write_text(json.dumps({"paper_id": "W1", "samples": []}) + "\n")
            manifest.write_text(json.dumps({"paper_id": "W1", "pdf_path": str(pdf), "pdf_sha256": sha256(pdf),
                                             "reading_json": str(reading), "reading_json_sha256": sha256(reading)}) + "\n")
            save(catalog, {"catalog_sha256": "a" * 64})
            args = argparse.Namespace(root=str(root / "campaign"), catalog=str(catalog), kind="pilot",
                                      models=str(models), samples=str(samples), manifest=str(manifest),
                                      paper_id=["W1"], shared_evidence=None)
            run = Path(feasibility.prepare(args)["run"])
            item = run / "items/W1.json"
            payload = json.loads(item.read_text())
            result = finalize(output_header(payload, item), item, json.loads(catalog.read_text()), root)
            save(run / "assessments/W1.json", result)
            summary = feasibility.publish(run)
            completed = subprocess.run([sys.executable, str(ROOT / "scripts/validate_feasibility_run.py"),
                                        "--run", str(run), "--project-root", str(root)],
                                       capture_output=True, text=True, timeout=15)
            self.assertEqual(completed.returncode, 0, completed.stderr)
            replayed = json.loads(completed.stdout)
            self.assertEqual(replayed["aggregate_sha256"], summary["aggregate_sha256"])
            self.assertEqual(replayed["schema_versions"], ["1.2"])

    def test_preparation_uses_paired_manifest_not_legacy_cache_hash(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            pdf, reading = root / "paper.pdf", root / "reading.json"
            pdf.write_bytes(b"paired-pdf")
            save(reading, {"paper_id": "W1", "source_sha256": "legacy-parsed-cache-hash",
                           "pages": [{"page": 1, "text": "A sample."}]})
            model = {"model_id": "b", "model_role": "baseline", "dependencies": [],
                     "dependent_variable": {"variable_id": "dv", "name": "Y", "definition": "Observed Y"},
                     "independent_variables": [], "result_sets": []}
            models, samples, manifest, catalog = [root / f for f in ("models.jsonl", "samples.jsonl", "manifest.jsonl", "catalog.json")]
            record = {"paper_id": "W1", "doi": None, "paper_text_file": str(reading), "models": [model]}
            models.write_text(json.dumps(record) + "\n")
            samples.write_text(json.dumps({"paper_id": "W1", "samples": []}) + "\n")
            manifest.write_text(json.dumps({"paper_id": "W1", "pdf_path": str(pdf), "pdf_sha256": sha256(pdf),
                                             "reading_json": str(reading), "reading_json_sha256": sha256(reading)}) + "\n")
            save(catalog, {"catalog_sha256": "a" * 64})
            args = argparse.Namespace(root=str(root / "campaign"), catalog=str(catalog), kind="pilot",
                                      models=str(models), samples=str(samples), manifest=str(manifest),
                                      paper_id=["W1"], shared_evidence=None)
            result = feasibility.prepare(args)
            self.assertEqual(result["papers"], 1)
            self.assertEqual(result["fits"], 1)
            item = json.loads((Path(result["run"]) / "items/W1.json").read_text())
            self.assertEqual(item["input_hashes"]["reading_sha256"], sha256(reading))
            self.assertNotIn("statistics", item["models"][0]["dependent_variable"])

    def test_quota_and_unaccepted_full_sweep(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            save(root / "campaign.json", {"limits": {"pilot": 7, "full": 1}, "accepted_pilot": None,
                                           "runs": [{"kind": "pilot"}] * 7})
            args = argparse.Namespace(root=str(root), catalog=str(root / "catalog.json"), kind="pilot")
            with self.assertRaisesRegex(ValueError, "quota exhausted"):
                feasibility.prepare(args)
            args.kind = "full"
            with self.assertRaisesRegex(ValueError, "accepted pilot"):
                feasibility.prepare(args)


if __name__ == "__main__":
    unittest.main()
