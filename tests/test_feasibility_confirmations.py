"""Coordinator confirmation artifact validation."""
import hashlib
import json
from pathlib import Path
import tempfile
import unittest

import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'skills/check-replication-feasibility/scripts'))
from confirmations import confirmation_refs


class ConfirmationInputTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)

    def write(self, name, value):
        path = self.root / name
        path.write_text(json.dumps(value))
        return {"path": name, "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}

    def coverage(self, **overrides):
        value = {"kind": "coverage_confirmation", "verification": "verified",
                 "location": "/documented/source", "basis": "Reviewed test fixture, not real data.",
                 "coverage": {"begin": 1990, "end": 2000, "years": [],
                              "population": "Test population", "frequency": "annual"}}
        value.update(overrides)
        return value

    def test_default_and_selected_scope(self):
        self.assertEqual(confirmation_refs(None, ["W1"], self.root),
                         {"W1": {"coverage_confirmations": [], "access_confirmations": []}})
        ref = self.write("coverage.json", self.coverage())
        self.write("index.json", {"W1": {"coverage_confirmations": [ref]},
                                  "W2": {"coverage_confirmations": [{"path": "not-read"}]}})
        out = confirmation_refs("index.json", ["W1"], self.root, ["W1", "W2"])
        self.assertEqual(out["W1"]["coverage_confirmations"],
                         [{"path": str(self.root / "coverage.json"), "sha256": ref["sha256"]}])

    def test_access_and_wrong_artifact_type(self):
        ref = self.write("access.json", {"kind": "access_confirmation", "verification": "blocked",
                                         "requirement_id": "private_input", "basis": "Reviewed test fixture."})
        self.write("index.json", {"W1": {"access_confirmations": [ref]}})
        self.assertEqual(len(confirmation_refs("index.json", ["W1"], self.root)["W1"]["access_confirmations"]), 1)
        self.write("index.json", {"W1": {"coverage_confirmations": [ref]}})
        with self.assertRaisesRegex(ValueError, "typed coverage_confirmation"):
            confirmation_refs("index.json", ["W1"], self.root)

    def test_tampering_unknown_ids_and_duplicates(self):
        ref = self.write("proof.json", self.coverage())
        self.write("index.json", {"W1": {"coverage_confirmations": [ref]}})
        (self.root / "proof.json").write_text("{}")
        with self.assertRaisesRegex(ValueError, "checksum"):
            confirmation_refs("index.json", ["W1"], self.root)
        self.write("index.json", {"W9": {}})
        with self.assertRaisesRegex(ValueError, "known paper"):
            confirmation_refs("index.json", ["W1"], self.root)
        ref = self.write("proof.json", self.coverage())
        self.write("index.json", {"W1": {"coverage_confirmations": [ref, ref]}})
        with self.assertRaisesRegex(ValueError, "duplicate"):
            confirmation_refs("index.json", ["W1"], self.root)

    def test_coverage_bounds_and_required_basis(self):
        for change in [None, True, 2001]:
            value = self.coverage()
            value["coverage"]["begin"] = change
            ref = self.write("proof.json", value)
            self.write("index.json", {"W1": {"coverage_confirmations": [ref]}})
            with self.assertRaises(ValueError):
                confirmation_refs("index.json", ["W1"], self.root)
        ref = self.write("proof.json", self.coverage(basis=""))
        self.write("index.json", {"W1": {"coverage_confirmations": [ref]}})
        with self.assertRaisesRegex(ValueError, "reviewed basis"):
            confirmation_refs("index.json", ["W1"], self.root)

    def test_external_confirmation_is_rejected_before_reading(self):
        ref = {"path": "../unopened-external-proof.json", "sha256": "0" * 64}
        self.write("index.json", {"W1": {"coverage_confirmations": [ref]}})
        with self.assertRaisesRegex(ValueError, "project workspace"):
            confirmation_refs("index.json", ["W1"], self.root)


if __name__ == "__main__":
    unittest.main()
