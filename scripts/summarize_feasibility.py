#!/usr/bin/env python3
"""Export paper metadata and readable resource candidates alongside strict outcomes."""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

# Resolve frozen artifact locations without rewriting research records.
_layout_root = Path(__file__).resolve().parents[1]
_layout = None
if (_layout_root / "project_layout.py").is_file():
    import sys as _layout_sys
    _layout_sys.path.insert(0, str(_layout_root))
    import project_layout as _layout
    Path = _layout.path_class(_layout_root)


def read(path):
    return json.loads(Path(path).read_text())


def export(run, manifest, output, require_complete=False):
    run, output = Path(run).resolve(), Path(output).resolve()
    info = read(run / "run.json")
    meta = {r["paper_id"]: r for r in
            (json.loads(line) for line in Path(manifest).read_text().splitlines() if line.strip())}
    published = info["publication_status"] == "published"
    if require_complete and not published:
        raise ValueError("Publish and validate the complete round before final export")
    records = {}
    if published:
        raw = (run / "assessments.jsonl").read_bytes()
        if hashlib.sha256(raw).hexdigest() != info["aggregate_sha256"]:
            raise ValueError("Published JSONL checksum mismatch")
        values = [json.loads(line) for line in raw.decode().splitlines() if line.strip()]
        if [d["paper_id"] for d in values] != [p["paper_id"] for p in info["papers"]]:
            raise ValueError("Published paper order/completeness mismatch")
        records = {d["paper_id"]: d for d in values}
    else:
        for p in info["papers"]:
            try:
                value = read(p["output"])
                if value.get("paper_id") == p["paper_id"] and "summary" in value:
                    records[p["paper_id"]] = value
            except (OSError, ValueError):
                pass
    rows, requirement_rows, fit_rows = [], [], []
    for paper in info["papers"]:
        pid = paper["paper_id"]
        m = meta[pid]
        row = {"paper_id": pid, "title": m["title"], "journal": m["journal"],
               "publication_year": m["publication_year"], "doi": m["doi"],
               "assessment_path": paper["output"]}
        if pid not in records:
            rows.append(row | {"eligibility": "pending", "outcome": "pending"})
            continue
        d = records[pid]
        reqs, assessments = d["requirements"], d["assessments"]
        readability = {}
        local = mapped_local = public = any_readable = any_mapped = no_route = 0
        source_names, datasets = set(), set()
        for req in reqs:
            readable_local = any(
                r["route_type"] != "public_raw" and r["verification"]["access"] == "verified"
                and r["verification"]["fields"] in ("verified", "not_applicable")
                for r in req["routes"])
            mapped = any(
                r["route_type"] != "public_raw" and r["verification"]["access"] == "verified"
                and r["verification"]["fields"] in ("verified", "not_applicable")
                and r["verification"]["mapping"] == "verified" for r in req["routes"])
            local += readable_local
            mapped_local += mapped
            readable_public = any(
                r["route_type"] == "public_raw" and r["verification"]["access"] == "verified"
                and r["verification"]["fields"] in ("verified", "not_applicable")
                for r in req["routes"])
            mapped_any = any(r["verification"]["access"] == "verified"
                             and r["verification"]["fields"] in ("verified", "not_applicable")
                             and r["verification"]["mapping"] == "verified" for r in req["routes"])
            public += readable_public
            any_readable += readable_local or readable_public
            any_mapped += mapped_any
            readability[req["requirement_id"]] = {
                "local": readable_local, "public": readable_public, "mapped_any": mapped_any,
            }
            no_route += not req["routes"]
            source_names.update(r["source_name"] for r in req["routes"])
            datasets.update(r["dataset"] for r in req["routes"] if r["dataset"])
            c = req["required_coverage"]
            requirement_rows.append({
                "paper_id": pid, "title": m["title"], "journal": m["journal"],
                "publication_year": m["publication_year"],
                "requirement_id": req["requirement_id"], "kind": req["kind"],
                "description": req["description"], "data_status": req["data_status"],
                "begin": c["begin"], "end": c["end"],
                "years": "; ".join(map(str, c["years"])), "frequency": c["frequency"],
                "population": c["population"], "coverage_detail": c["detail"],
                "readable_local_candidate": readable_local,
                "readable_public_candidate": readable_public,
                "mapped_readable_local_candidate": mapped,
                "mapped_readable_local_or_public_candidate": mapped_any,
                "source_names": "; ".join(sorted({r["source_name"] for r in req["routes"]})),
                "datasets": "; ".join(sorted({r["dataset"] for r in req["routes"] if r["dataset"]})),
                "unresolved_reason": req["unresolved_reason"], "blocked_reason": req["blocked_reason"],
                "route_verifications": json.dumps([
                    {"route_id": r["route_id"], "route_type": r["route_type"],
                     "location": r["location"], **r["verification"]} for r in req["routes"]],
                    ensure_ascii=False), "assessment_path": paper["output"],
            })
        models = {model["model_id"]: model for model in read(paper["item"])["models"]}
        by_requirement = {q["requirement_id"]: q for q in reqs}
        for a in assessments:
            inputs = [readability[rid] for rid in a["requirement_ids"]]
            model = models[a["model_id"]]
            result = next((v for v in model["result_sets"]
                           if v["result_set_id"] == a["result_set_id"]), {})
            fit_rows.append({
                "paper_id": pid, "title": m["title"], "journal": m["journal"],
                "publication_year": m["publication_year"], "doi": m["doi"],
                "model_id": a["model_id"], "model_label": model["model_label"],
                "result_set_id": a["result_set_id"], "result_set_label": result.get("label", ""),
                "data_mode": a.get("data_mode", "observed"),
                "data_mode_reason": a.get("data_mode_reason"),
                "data_status": a["data_status"], "attempt_ready": a["attempt_ready"],
                "required_models": len(a["required_model_ids"]), "requirements": len(inputs),
                "requirements_with_readable_local_candidate": sum(v["local"] for v in inputs),
                "all_inputs_have_readable_local_candidates": bool(inputs and all(v["local"] for v in inputs)),
                "all_inputs_have_readable_local_or_public_candidates": bool(
                    inputs and all(v["local"] or v["public"] for v in inputs)),
                "all_inputs_have_mapped_readable_local_or_public_candidates": bool(
                    inputs and all(v["mapped_any"] for v in inputs)),
                "requirements_with_unknown_period": sum(
                    by_requirement[rid]["required_coverage"]["begin"] is None
                    or by_requirement[rid]["required_coverage"]["end"] is None for rid in a["requirement_ids"]),
                "blocking_implementation_issues": sum(i["blocking"] for i in a["implementation_issues"]),
                "requirement_ids": "; ".join(a["requirement_ids"]),
                "blocking_issue_details": json.dumps([
                    {"kind": i["kind"], "description": i["description"]}
                    for i in a["implementation_issues"] if i["blocking"]], ensure_ascii=False),
                "assessment_path": paper["output"],
            })
        counts = Counter(r["data_status"] for r in reqs)
        issues = {(i["kind"], i["description"]) for a in assessments
                  for i in a["implementation_issues"] if i["blocking"]}
        row.update(
            eligibility=d["eligibility"], outcome=d["summary"]["outcome"],
            baseline_models=d["summary"]["baseline_models"], baseline_fit_checks=len(assessments),
            synthetic_only_fits=sum(a.get("data_mode") == "synthetic_only" for a in assessments),
            requirements=len(reqs), requirements_with_readable_local_candidate=local,
            requirements_with_mapped_readable_local_candidate=mapped_local,
            requirements_with_public_candidate=public,
            all_requirements_have_readable_local_candidates=bool(reqs and local == len(reqs)),
            all_requirements_have_readable_local_or_public_candidates=bool(reqs and any_readable == len(reqs)),
            all_requirements_have_mapped_readable_local_or_public_candidates=bool(reqs and any_mapped == len(reqs)),
            requirements_without_any_route=no_route,
            confirmed_local_ready_requirements=counts["local_ready"],
            confirmed_public_acquisition_requirements=counts["public_acquisition_required"],
            blocked_requirements=counts["access_blocked"], undetermined_requirements=counts["undetermined"],
            requirements_with_unknown_period=sum(r["required_coverage"]["begin"] is None
                                                 or r["required_coverage"]["end"] is None for r in reqs),
            unique_blocking_implementation_issues=len(issues),
            attempt_ready_fits=d["summary"]["attempt_ready_count"],
            source_names="; ".join(sorted(source_names)), datasets="; ".join(sorted(datasets)),
        )
        rows.append(row)
    output.mkdir(parents=True, exist_ok=True)
    fields = ["paper_id", "title", "journal", "publication_year", "doi", "eligibility", "outcome",
              "baseline_models", "baseline_fit_checks", "synthetic_only_fits", "requirements",
              "requirements_with_readable_local_candidate", "requirements_with_public_candidate",
              "requirements_with_mapped_readable_local_candidate",
              "all_requirements_have_readable_local_candidates", "requirements_without_any_route",
              "all_requirements_have_readable_local_or_public_candidates",
              "all_requirements_have_mapped_readable_local_or_public_candidates",
              "confirmed_local_ready_requirements", "confirmed_public_acquisition_requirements",
              "blocked_requirements", "undetermined_requirements", "requirements_with_unknown_period",
              "unique_blocking_implementation_issues", "attempt_ready_fits", "source_names", "datasets",
              "assessment_path"]
    with (output / "papers_summary.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)
    requirement_fields = ["paper_id", "title", "journal", "publication_year", "requirement_id",
                          "kind", "description", "data_status", "begin", "end", "years",
                          "frequency", "population", "coverage_detail", "readable_local_candidate",
                          "readable_public_candidate", "mapped_readable_local_candidate",
                          "mapped_readable_local_or_public_candidate", "source_names", "datasets",
                          "unresolved_reason", "blocked_reason", "route_verifications", "assessment_path"]
    with (output / "requirements_summary.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=requirement_fields)
        writer.writeheader()
        writer.writerows(requirement_rows)
    fit_fields = ["paper_id", "title", "journal", "publication_year", "doi", "model_id", "model_label",
                  "result_set_id", "result_set_label", "data_mode", "data_mode_reason", "data_status", "attempt_ready", "required_models",
                  "requirements", "requirements_with_readable_local_candidate",
                  "all_inputs_have_readable_local_candidates", "all_inputs_have_readable_local_or_public_candidates",
                  "all_inputs_have_mapped_readable_local_or_public_candidates", "requirements_with_unknown_period",
                  "blocking_implementation_issues", "requirement_ids", "blocking_issue_details", "assessment_path"]
    with (output / "fits_summary.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=fit_fields)
        writer.writeheader()
        writer.writerows(fit_rows)
    completed = [r for r in rows if r["outcome"] != "pending"]
    report = {
        "generated_at": datetime.now(timezone.utc).isoformat(), "run": str(run),
        "publication_status": info["publication_status"], "expected_papers": len(rows),
        "completed_papers": len(completed), "pending_papers": len(rows) - len(completed),
        "outcomes": dict(Counter(r["outcome"] for r in rows)),
        "papers_with_all_inputs_having_readable_local_candidates": sum(
            r.get("all_requirements_have_readable_local_candidates", False) for r in completed),
        "papers_with_all_inputs_having_readable_local_or_public_candidates": sum(
            r.get("all_requirements_have_readable_local_or_public_candidates", False) for r in completed),
        "papers_with_all_inputs_having_mapped_readable_local_or_public_candidates": sum(
            r.get("all_requirements_have_mapped_readable_local_or_public_candidates", False) for r in completed),
        "baseline_fit_checks": sum(r.get("baseline_fit_checks", 0) for r in completed),
        "fit_data_statuses": dict(Counter(r["data_status"] for r in fit_rows)),
        "synthetic_only_fits": sum(r["data_mode"] == "synthetic_only" for r in fit_rows),
        "requirements": len(requirement_rows),
        "requirement_statuses": dict(Counter(r["data_status"] for r in requirement_rows)),
        "readable_local_candidate_requirements": sum(r["readable_local_candidate"] for r in requirement_rows),
        "mapped_readable_local_candidate_requirements": sum(r["mapped_readable_local_candidate"] for r in requirement_rows),
        "fit_checks_with_all_inputs_having_readable_local_candidates": sum(
            r["all_inputs_have_readable_local_candidates"] for r in fit_rows),
        "fit_checks_with_all_inputs_having_readable_local_or_public_candidates": sum(
            r["all_inputs_have_readable_local_or_public_candidates"] for r in fit_rows),
        "fit_checks_with_all_inputs_having_mapped_readable_local_or_public_candidates": sum(
            r["all_inputs_have_mapped_readable_local_or_public_candidates"] for r in fit_rows),
        "candidate_warning": "Readable candidates establish access/columns only. They do not assert semantic mapping, historical/population coverage, a fully specified estimator, or replicated results.",
    }
    (output / "papers_summary.json").write_text(json.dumps(report, indent=2) + "\n")
    return report


def main():
    project = Path(__file__).resolve().parents[1]
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--run", required=True)
    p.add_argument("--manifest", default=str(project / "papers.jsonl"))
    p.add_argument("--output", required=True)
    p.add_argument("--require-complete", action="store_true")
    args = p.parse_args()
    print(json.dumps(export(args.run, args.manifest, args.output, args.require_complete), indent=2))


if __name__ == "__main__":
    main()
