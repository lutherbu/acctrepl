"""Review conversion preserves frozen sources and detects changed lineage."""
import argparse
import importlib.util
import json
import subprocess
import sys
import unittest
from pathlib import Path
from unittest.mock import patch

import test_feasibility as fixtures
import feasibility
from assessment import finalize, output_header
from resources import load, save, sha256

ROOT = fixtures.ROOT
spec = importlib.util.spec_from_file_location("review_converter", ROOT / "scripts/review_feasibility_run.py")
review = importlib.util.module_from_spec(spec)
spec.loader.exec_module(review)


class ReviewConversionTests(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.AssessmentTests()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        f, p = self.f, self.f.project
        text = "All variables are generated locally from a normal distribution."
        save(f.reading, {"paper_id": "W1", "pages": [{"page": 1, "text": text}]})
        f.model["dependent_variable"].update(name="Synthetic Y", definition="Generated normal outcome")
        for filename, record in {
            "models.jsonl": {"paper_id": "W1", "doi": None, "paper_text_file": str(f.reading), "models": [f.model]},
            "samples.jsonl": {"paper_id": "W1", "samples": []},
            "manifest.jsonl": {"paper_id": "W1", "pdf_path": str(f.pdf), "pdf_sha256": sha256(f.pdf),
                               "reading_json": str(f.reading), "reading_json_sha256": sha256(f.reading)},
        }.items():
            (p / filename).write_text(json.dumps(record) + "\n")
        save(p / "catalog.json", f.catalog)
        args = argparse.Namespace(root=str(p / "campaign"), catalog=str(p / "catalog.json"),
                                  models=str(p / "models.jsonl"), samples=str(p / "samples.jsonl"),
                                  manifest=str(p / "manifest.jsonl"), kind="pilot", paper_id=["W1"],
                                  shared_evidence=None, confirmations=None)
        with patch.object(feasibility, "PROJECT", ROOT):
            self.source = Path(feasibility.prepare(args)["run"])
            item = self.source / "items/W1.json"
            payload = load(item)
            audit = Path(payload["temporal_audit_path"])
            audit.parent.mkdir(parents=True)
            save(audit, {"paper_id": "W1", "baseline_timing_review": "Generated data have no calendar dates.", "records": []})
            doc = output_header(payload, item)
            doc["evidence"] = [dict(f.doc["evidence"][0], quote=text)]
            doc["requirements"] = [dict(f.doc["requirements"][0], description="Placeholder for locally generated inputs.")]
            a = doc["assessments"][0]
            a["requirement_ids"] = ["earnings"]
            for v in a["variable_coverage"]:
                v.update(construction="Generate the normal synthetic outcome.", non_data_reason="A generated draw, not an observed column.")
            for d in a["design_coverage"]:
                d.update(reason="Synthetic observations require no external source.", evidence_ids=["p1"])
            save(self.source / "assessments/W1.json", finalize(doc, item, f.catalog, ROOT))
            summary = feasibility.publish(self.source)
        self.before = (self.source / "assessments.jsonl").read_bytes()
        self.decisions = p / "decisions.json"
        save(self.decisions, {"source_aggregate_sha256": summary["aggregate_sha256"], "papers": [{
            "paper_id": "W1", "action": "synthetic_only", "remove_requirement_ids": ["earnings"],
            "reason": "The source generates all inputs.", "evidence_ids": ["p1"],
            "design_reason": "The design only uses synthetic observations.",
            "temporal_review": "There are no observed calendar-dated inputs.",
            "review_note": "Source-reviewed removal of a generated-input placeholder.",
        }]})

    def convert(self):
        output = self.f.project / "reviewed"
        with patch.object(feasibility, "PROJECT", ROOT):
            result = review.convert(self.source, output, self.decisions, feasibility, ROOT)
        return output, result

    def replay(self, run):
        return subprocess.run([sys.executable, str(ROOT / "scripts/validate_feasibility_run.py"),
                               "--run", str(run), "--project-root", str(ROOT)],
                              capture_output=True, text=True, timeout=20)

    def test_synthetic_conversion_preserves_source_and_replays(self):
        output, summary = self.convert()
        self.assertEqual(summary["fit_data_statuses"], {"no_observed_data_required": 1})
        self.assertEqual((self.source / "assessments.jsonl").read_bytes(), self.before)
        d = load(output / "assessments/W1.json")
        self.assertEqual(d["requirements"], [])
        self.assertEqual(d["assessments"][0]["data_mode"], "synthetic_only")
        result = self.replay(output)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(load(output / "run.json")["kind"], "review")

    def test_review_lineage_rejects_changed_decisions(self):
        output, _ = self.convert()
        path = output / "review/coordinator_decisions.json"
        path.write_text(path.read_text() + " ")
        result = self.replay(output)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("lineage changed: decisions", result.stderr)

    def test_decisions_for_another_source_are_rejected_before_output(self):
        d = load(self.decisions)
        d["source_aggregate_sha256"] = "0" * 64
        save(self.decisions, d)
        with self.assertRaisesRegex(ValueError, "not bound"):
            self.convert()
        self.assertFalse((self.f.project / "reviewed").exists())

    def test_publication_rejects_another_skill_version(self):
        with patch.object(feasibility, "skill_hash", return_value="0" * 64):
            with self.assertRaisesRegex(ValueError, "frozen skill snapshot"):
                feasibility.publish(self.source)
        self.assertEqual((self.source / "assessments.jsonl").read_bytes(), self.before)


if __name__ == "__main__":
    unittest.main()
