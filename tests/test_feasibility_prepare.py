"""Freeze supplied evidence before a run is charged; never silently certify it."""
import argparse
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import test_feasibility
import feasibility
from resources import load, save, sha256


class ConfirmationPreparationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        p = self.root
        (p / "paper.pdf").write_bytes(b"paired-source")
        save(p / "reading.json", {"paper_id": "W1", "pages": []})
        rows = {
            "models.jsonl": {"paper_id": "W1", "doi": None, "paper_text_file": str(p / "reading.json"), "models": []},
            "samples.jsonl": {"paper_id": "W1", "samples": []},
            "manifest.jsonl": {"paper_id": "W1", "pdf_path": str(p / "paper.pdf"),
                               "pdf_sha256": sha256(p / "paper.pdf"), "reading_json": str(p / "reading.json"),
                               "reading_json_sha256": sha256(p / "reading.json")},
        }
        for name, row in rows.items():
            (p / name).write_text(json.dumps(row) + "\n")
        save(p / "catalog.json", {"catalog_sha256": "a" * 64})
        save(p / "proof.json", {"kind": "coverage_confirmation", "verification": "verified",
                               "basis": "Coordinator reviewed field-year/population diagnostics.",
                               "location": "/storage/sas/base/fixture.sas7bdat",
                               "coverage": {"begin": 2000, "end": 2005, "years": [],
                                            "population": "US firms", "frequency": "annual"}})
        self.ref = {"path": "proof.json", "sha256": sha256(p / "proof.json")}
        save(p / "index.json", {"W1": {"coverage_confirmations": [self.ref]}})
        self.args = argparse.Namespace(root=str(p / "campaign"), catalog=str(p / "catalog.json"),
                                       models=str(p / "models.jsonl"), samples=str(p / "samples.jsonl"),
                                       manifest=str(p / "manifest.jsonl"), kind="pilot", paper_id=["W1"],
                                       shared_evidence=None, confirmations="index.json")

    def test_selected_confirmation_references_are_frozen(self):
        with patch.object(feasibility, "PROJECT", self.root):
            result = feasibility.prepare(self.args)
        item = load(Path(result["run"]) / "items/W1.json")
        self.assertEqual(item["coverage_confirmations"],
                         [{"path": str(self.root / "proof.json"), "sha256": self.ref["sha256"]}])
        self.assertEqual(item["access_confirmations"], [])
        self.assertEqual(result["quota_used"], {"pilot": 1, "full": 0})

    def test_bad_confirmation_does_not_charge_or_create_a_round(self):
        self.ref["sha256"] = "0" * 64
        save(self.root / "index.json", {"W1": {"coverage_confirmations": [self.ref]}})
        with patch.object(feasibility, "PROJECT", self.root):
            with self.assertRaisesRegex(ValueError, "checksum mismatch"):
                feasibility.prepare(self.args)
        self.assertFalse((self.root / "campaign/campaign.json").exists())
        self.assertFalse((self.root / "campaign/pilot_01").exists())


if __name__ == "__main__":
    unittest.main()
