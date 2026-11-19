#!/usr/bin/env python3
"""Read-only replay of a published round with its exact frozen skill/schema."""
from __future__ import annotations

import argparse
import importlib.util
import json
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


def check_review_lineage(info, run, helper):
    """Verify retained source files and the recorded coordinator conversion."""
    if info.get("kind") != "review":
        return
    lineage = info["review_source"]
    for key in ("run_manifest", "aggregate", "decisions", "converter"):
        ref = lineage[key]
        if helper.sha256(ref["path"]) != ref["sha256"]:
            raise ValueError(f"Review source lineage changed: {key}")
    source = helper.load(lineage["run_manifest"]["path"])
    helper.check_run_inputs(source)
    if source["publication_status"] != "published" or source["aggregate_sha256"] != lineage["aggregate"]["sha256"]:
        raise ValueError("Review source is not the bound published aggregate")
    source_records = [json.loads(s) for s in Path(lineage["aggregate"]["path"]).read_text().splitlines() if s.strip()]
    if [p["paper_id"] for p in info["papers"]] != [p["paper_id"] for p in source["papers"]]:
        raise ValueError("Review changed the source paper inventory/order")
    if [r["paper_id"] for r in source_records] != [p["paper_id"] for p in source["papers"]]:
        raise ValueError("Source aggregate inventory/order changed")
    for key in ("models_inventory_sha256", "samples_inventory_sha256", "catalog_sha256", "catalog_artifact_sha256"):
        if source["input_hashes"][key] != info["input_hashes"][key]:
            raise ValueError(f"Review changed original input: {key}")
    for old, new, record in zip(source["papers"], info["papers"], source_records):
        if helper.load(old["output"]) != record:
            raise ValueError("Source per-paper output differs from its aggregate")
        item, original = helper.load(new["item"]), helper.load(old["item"])
        expected = {"aggregate_sha256": lineage["aggregate"]["sha256"],
                    "assessment_sha256": helper.sha256(old["output"]),
                    "work_item_sha256": old["sha256"],
                    "converter_sha256": lineage["converter"]["sha256"],
                    "decisions_sha256": lineage["decisions"]["sha256"]}
        if item.get("review_source") != expected:
            raise ValueError(f"{new['paper_id']}: review source hashes differ")
        unchanged = dict(item)
        unchanged.pop("review_source")
        unchanged["temporal_audit_path"] = original["temporal_audit_path"]
        unchanged["input_hashes"] = dict(unchanged["input_hashes"], skill_sha256=original["input_hashes"]["skill_sha256"])
        if unchanged != original:
            raise ValueError(f"{new['paper_id']}: review changed frozen specifications/source references")
    decisions = helper.load(lineage["decisions"]["path"])
    if decisions.get("source_aggregate_sha256") != lineage["aggregate"]["sha256"]:
        raise ValueError("Coordinator decisions name a different source aggregate")


def replay(run, project):
    run, project = Path(run).resolve(), Path(project).resolve()
    scripts = run / "skill_snapshot/scripts"
    # Each CLI replay is a fresh interpreter, so the frozen sibling imports cannot
    # accidentally resolve to the current skill's newer resources/assessment code.
    if "resources" in sys.modules or "assessment" in sys.modules:
        raise ValueError("Run this audit in a fresh interpreter")
    sys.path.insert(0, str(scripts))
    spec = importlib.util.spec_from_file_location("frozen_feasibility", scripts / "feasibility.py")
    helper = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(helper)
    if _layout:
        for name in ('resources', 'assessment', 'confirmations'):
            if name in sys.modules:
                _layout.relocate_module(sys.modules[name], project)
        _layout.relocate_module(helper, project)
    helper.PROJECT = project
    info = helper.load(run / "run.json")
    if info["publication_status"] != "published":
        raise ValueError("Round is not published")
    if helper.skill_hash() != info["input_hashes"]["skill_sha256"]:
        raise ValueError("Frozen skill snapshot changed")
    helper.check_run_inputs(info)
    check_review_lineage(info, run, helper)
    catalog = helper.load(info["catalog_path"])
    aggregate = run / "assessments.jsonl"
    if helper.sha256(aggregate) != info["aggregate_sha256"]:
        raise ValueError("Published aggregate changed")
    records = [json.loads(line) for line in aggregate.read_text().splitlines() if line.strip()]
    if [r["paper_id"] for r in records] != [p["paper_id"] for p in info["papers"]]:
        raise ValueError("Published aggregate is incomplete, duplicated or reordered")
    schemas = set()
    for paper, record in zip(info["papers"], records):
        saved = helper.load(paper["output"])
        checked = helper.finalize(saved, paper["item"], catalog, project)
        if checked != saved or saved != record:
            raise ValueError(f"{paper['paper_id']}: per-paper result or calculated fields changed")
        schemas.add(record["schema_version"])
    return {"valid": True, "run": str(run), "papers": len(records),
            "schema_versions": sorted(schemas), "aggregate_sha256": info["aggregate_sha256"]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run", required=True)
    parser.add_argument("--project-root", default=str(Path(__file__).resolve().parents[1]))
    args = parser.parse_args()
    print(json.dumps(replay(args.run, args.project_root), indent=2))


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, KeyError) as exc:
        print(str(exc), file=sys.stderr)
        sys.exit(1)
