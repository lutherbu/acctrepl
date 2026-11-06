#!/usr/bin/env python3
"""Preserve a published Luna run and derive a source-reviewed schema conversion.

This makes no model calls and consumes no pilot/full-sweep quota. Every substantive
conversion must be listed in a coordinator decision file bound to the source JSONL.
"""
from __future__ import annotations

import argparse
import copy
import importlib.util
import json
import shutil
import subprocess
import sys
from pathlib import Path

# Resolve frozen artifact locations without rewriting research records.
_layout_root = Path(__file__).resolve().parents[1]
_layout = None
if (_layout_root / "project_layout.py").is_file():
    import sys as _layout_sys
    _layout_sys.path.insert(0, str(_layout_root))
    import project_layout as _layout
    Path = _layout.path_class(_layout_root)


def convert(source, output, decisions_path, helper, project):
    source, output = Path(source).resolve(), Path(output).resolve()
    decisions_path, project = Path(decisions_path).resolve(), Path(project).resolve()
    if output.exists():
        raise ValueError("Review output already exists; preserve prior artifacts")
    info = helper.load(source / "run.json")
    if info["publication_status"] != "published":
        raise ValueError("Publish and replay the source round first")
    checked = subprocess.run(
        [sys.executable, str(project / "scripts/validate_feasibility_run.py"),
         "--run", str(source), "--project-root", str(project)],
        capture_output=True, text=True, timeout=180)
    if checked.returncode:
        raise ValueError("Source replay failed: " + checked.stderr)
    decision_doc = helper.load(decisions_path)
    if decision_doc.get("source_aggregate_sha256") != info["aggregate_sha256"]:
        raise ValueError("Decisions are not bound to this source aggregate")
    decisions = {}
    for decision in decision_doc.get("papers", []):
        pid = decision["paper_id"]
        if pid in decisions or decision.get("action") != "synthetic_only":
            raise ValueError("Unsupported or duplicate source-review action")
        for key in ("reason", "temporal_review", "design_reason", "review_note"):
            if not isinstance(decision.get(key), str) or not decision[key].strip():
                raise ValueError(f"{pid}: decision needs {key}")
        if not decision.get("evidence_ids") or not decision.get("remove_requirement_ids"):
            raise ValueError(f"{pid}: decision needs evidence and explicit requirements to remove")
        decisions[pid] = decision
    if set(decisions) - {p["paper_id"] for p in info["papers"]}:
        raise ValueError("Review decision names a paper outside the source run")
    output.mkdir(parents=True)
    for folder in ("items", "drafts", "assessments", "review"):
        (output / folder).mkdir()
    shutil.copytree(helper.SKILL_ROOT, output / "skill_snapshot",
                    ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
    saved_decisions = output / "review/coordinator_decisions.json"
    shutil.copyfile(decisions_path, saved_decisions)
    converter = output / "review/converter.py"
    shutil.copyfile(Path(__file__).resolve(), converter)
    lineage = {
        "run_manifest": {"path": str(source / "run.json"), "sha256": helper.sha256(source / "run.json")},
        "aggregate": {"path": str(source / "assessments.jsonl"), "sha256": info["aggregate_sha256"]},
        "decisions": {"path": str(saved_decisions), "sha256": helper.sha256(saved_decisions)},
        "converter": {"path": str(converter), "sha256": helper.sha256(converter)},
    }
    papers = []
    catalog = helper.load(info["catalog_path"])
    for source_paper in info["papers"]:
        pid = source_paper["paper_id"]
        item = copy.deepcopy(helper.load(source_paper["item"]))
        doc = copy.deepcopy(helper.load(source_paper["output"]))
        item["input_hashes"]["skill_sha256"] = helper.skill_hash()
        item["review_source"] = {
            "aggregate_sha256": lineage["aggregate"]["sha256"],
            "assessment_sha256": helper.sha256(source_paper["output"]),
            "work_item_sha256": helper.sha256(source_paper["item"]),
            "converter_sha256": lineage["converter"]["sha256"],
            "decisions_sha256": lineage["decisions"]["sha256"],
        }
        audit = None
        if item.get("temporal_audit_path") and Path(item["temporal_audit_path"]).exists():
            audit = helper.load(item["temporal_audit_path"])
        item["temporal_audit_path"] = str(output / "drafts" / pid / "temporal_audit.json")
        doc["schema_version"] = "1.2"
        for a in doc["assessments"]:
            a.update(data_mode="observed", data_mode_reason=None, data_mode_evidence_ids=[])
        decision = decisions.get(pid)
        if decision:
            old_ids = {r["requirement_id"] for r in doc["requirements"]}
            if set(decision["remove_requirement_ids"]) != old_ids or not doc["assessments"]:
                raise ValueError(f"{pid}: synthetic-only decision must explicitly cover all existing requirements/fits")
            doc["requirements"] = []
            for a in doc["assessments"]:
                a.update(data_mode="synthetic_only", data_mode_reason=decision["reason"],
                         data_mode_evidence_ids=decision["evidence_ids"], requirement_ids=[])
                for v in a["variable_coverage"]:
                    if v["requirement_ids"] or not v["non_data_reason"]:
                        raise ValueError(f"{pid}: generated-variable explanations must already be source reviewed")
                for design in a["design_coverage"]:
                    design.update(requirement_ids=[], reason=decision["design_reason"],
                                  evidence_ids=decision["evidence_ids"])
                a["review_notes"].append(decision["review_note"])
            doc["review_notes"].append(decision["review_note"])
            audit = {"paper_id": pid, "baseline_timing_review": decision["temporal_review"], "records": []}
        if audit is not None:
            audit_path = Path(item["temporal_audit_path"])
            audit_path.parent.mkdir(parents=True, exist_ok=True)
            helper.save(audit_path, audit)
        item_path = output / "items" / f"{pid}.json"
        output_path = output / "assessments" / f"{pid}.json"
        helper.save(item_path, item)
        helper.save(output_path, helper.finalize(doc, item_path, catalog, project))
        papers.append({"paper_id": pid, "item": str(item_path), "sha256": helper.sha256(item_path),
                       "output": str(output_path)})
    reviewed = copy.deepcopy(info)
    reviewed.update(run_id=output.name, kind="review", created_at=helper.now(),
                    publication_status="pending", papers=papers, review_source=lineage,
                    worker_model=None, reasoning_effort=None,
                    review_method="Deterministic schema conversion plus explicit source-reviewed decisions; no new model calls.")
    reviewed.pop("aggregate_sha256", None)
    reviewed["input_hashes"]["skill_sha256"] = helper.skill_hash()
    helper.save(output / "run.json", reviewed)
    return helper.publish(output)


def main():
    project = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-run", required=True)
    parser.add_argument("--output-run", required=True)
    parser.add_argument("--decisions", required=True)
    parser.add_argument("--skill-root", default=str(project / "skills/check-replication-feasibility"))
    args = parser.parse_args()
    scripts = Path(args.skill_root).resolve() / "scripts"
    sys.path.insert(0, str(scripts))
    spec = importlib.util.spec_from_file_location("review_helper", scripts / "feasibility.py")
    helper = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(helper)
    helper.PROJECT = project
    print(json.dumps(convert(args.source_run, args.output_run, args.decisions, helper, project), indent=2))


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, KeyError) as exc:
        print(str(exc), file=sys.stderr)
        sys.exit(1)
