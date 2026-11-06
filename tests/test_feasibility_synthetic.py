"""Observed-input guards and source-backed synthetic-only feasibility."""
import unittest

import test_feasibility as fixtures
from assessment import calculate_summary
from resources import save, sha256


class SyntheticFeasibilityTests(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.AssessmentTests()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)

    def synthetic(self):
        f = self.f
        text = "All variables are randomly generated from normal distributions; no observed dataset is used."
        save(f.reading, {"paper_id": "W1", "pages": [{"page": 1, "text": text}]})
        f.item["input_hashes"]["reading_sha256"] = sha256(f.reading)
        save(f.item_path, f.item)
        f.doc["evidence"][0].update(quote=text, description="Synthetic data-generating process")
        f.doc["requirements"] = []
        a = f.doc["assessments"][0]
        a.update(data_mode="synthetic_only", data_mode_reason="Source explicitly generates all variables.",
                 data_mode_evidence_ids=["p1"], requirement_ids=[])
        for v in a["variable_coverage"]:
            v.update(requirement_ids=[], construction="Generate the stated normal DGP locally.",
                     non_data_reason="A synthetic DGP variable rather than an observed data column.")
        for d in a["design_coverage"]:
            d.update(requirement_ids=[], reason="The design uses generated local observations.")
        f.write_audit([])
        return a

    def test_no_external_inputs_are_not_a_missing_dataset(self):
        self.synthetic()
        d = self.f.check()
        self.assertEqual(d["schema_version"], "1.2")
        self.assertEqual(d["assessments"][0]["data_status"], "no_observed_data_required")
        self.assertEqual(d["summary"]["outcome"], "no_observed_data_required")
        self.assertTrue(d["assessments"][0]["attempt_ready"])

    def test_synthetic_specification_issue_still_blocks_attempt(self):
        a = self.synthetic()
        a["implementation_issues"].append({"kind": "specification", "description": "DGP parameter omitted.",
                                            "blocking": True, "evidence_ids": ["p1"]})
        d = self.f.check()
        self.assertEqual(d["assessments"][0]["data_status"], "no_observed_data_required")
        self.assertFalse(d["assessments"][0]["attempt_ready"])

    def test_source_and_variable_explanations_are_required(self):
        a = self.synthetic()
        a["data_mode_evidence_ids"] = []
        with self.assertRaisesRegex(ValueError, "original-paper evidence"):
            self.f.check()
        a["data_mode_evidence_ids"] = ["p1"]
        a["variable_coverage"][0]["non_data_reason"] = None
        with self.assertRaisesRegex(ValueError, "unexplained variables"):
            self.f.check()

    def test_observed_inputs_cannot_be_waived(self):
        f = self.f
        a = f.doc["assessments"][0]
        a.update(data_mode="synthetic_only", data_mode_reason="Unjustified waiver.", data_mode_evidence_ids=["p1"])
        with self.assertRaisesRegex(ValueError, "cannot retain observed inputs"):
            f.check()
        a.update(data_mode="observed", data_mode_reason=None, data_mode_evidence_ids=[], requirement_ids=[])
        with self.assertRaisesRegex(ValueError, "observed baseline has no data"):
            f.check()

    def test_mixed_paper_and_no_baseline_remain_distinct(self):
        doc = {"eligibility": "eligible", "assessments": [
            {"model_id": "s", "data_status": "no_observed_data_required", "attempt_ready": True},
            {"model_id": "o", "data_status": "undetermined", "attempt_ready": False}]}
        s = calculate_summary(doc)
        self.assertEqual(s["outcome"], "partially_feasible")
        self.assertTrue(s["any_data_feasible"])
        self.assertFalse(s["all_data_feasible"])
        self.assertEqual(calculate_summary({"eligibility": "no_baseline", "assessments": []})["outcome"],
                         "not_applicable")


if __name__ == "__main__":
    unittest.main()
