#!/usr/bin/env python3
"""CLI for source inventory, feasibility work items, probes, and publication."""
from __future__ import annotations

import argparse
import csv
import fcntl
import json
import shutil
import sys
from collections import Counter
from pathlib import Path

# Resolve frozen artifact locations without rewriting research records.
_layout_root = Path(__file__).resolve().parents[3]
_layout = None
if (_layout_root / "project_layout.py").is_file():
    import sys as _layout_sys
    _layout_sys.path.insert(0, str(_layout_root))
    import project_layout as _layout
    Path = _layout.path_class(_layout_root)

from assessment import (SKILL_ROOT, canonical_hash, compact_model, dependency_closure,
                        expected_scopes, finalize, output_header, skill_hash, year_envelope, temporal_template)
from resources import build_catalog, load, lookup, now, probe, save, sha256
from confirmations import confirmation_refs

PROJECT = SKILL_ROOT.parents[1]
DEFAULT_MODELS = Path(_layout.active_path("models", PROJECT)) if _layout else PROJECT / "output/model_results.jsonl"
DEFAULT_SAMPLES = Path(_layout.active_path("shortlist", PROJECT)) if _layout else PROJECT / "output/sample_extractions.filtered.jsonl"
DEFAULT_MANIFEST = Path(_layout.active_path("model_manifest", PROJECT)) if _layout else PROJECT / "output/model_results_runs/input_manifest.jsonl"


def read_jsonl(path):
    values = [json.loads(line) for line in Path(path).read_text().splitlines() if line.strip()]
    ids = [v["paper_id"] for v in values]
    if len(ids) != len(set(ids)):
        raise ValueError(f"Duplicate paper IDs in {path}")
    return values


def _resolve_source(path):
    path = Path(path)
    if not path.is_absolute():
        path = PROJECT / path
    return path.resolve()


def prepare(args):
    root, catalog_path = Path(args.root).resolve(), Path(args.catalog).resolve()
    root.mkdir(parents=True, exist_ok=True)
    with (root / ".lock").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        campaign_path = root / "campaign.json"
        campaign = load(campaign_path) if campaign_path.exists() else {
            "schema_version": "1.0", "created_at": now(),
            "limits": {"pilot": 7, "full": 1}, "runs": [], "accepted_pilot": None,
        }
        previous = [r for r in campaign["runs"] if r["kind"] == args.kind]
        if len(previous) >= campaign["limits"][args.kind]:
            raise ValueError(f"{args.kind} quota exhausted")
        if args.kind == "full" and not campaign["accepted_pilot"]:
            raise ValueError("Full sweep requires a coordinator-accepted pilot review")
        if args.kind == "full":
            accepted = campaign["accepted_pilot"]
            if sha256(accepted["review"]) != accepted["sha256"]:
                raise ValueError("Accepted pilot review changed")
            accepted_run = load(root / accepted["run_id"] / "run.json")
            if accepted_run["input_hashes"]["skill_sha256"] != skill_hash():
                raise ValueError("Skill changed after accepted pilot; test the revised version before a full sweep")
        runid = f"{args.kind}_{len(previous) + 1:02d}"
        run = root / runid
        if run.exists():
            raise ValueError("Run directory already exists; never overwrite a round")
        models_path, samples_path = Path(args.models).resolve(), Path(args.samples).resolve()
        models, samples = read_jsonl(models_path), {p["paper_id"]: p for p in read_jsonl(samples_path)}
        manifests = {p["paper_id"]: p for p in read_jsonl(args.manifest)}
        chosen = set(args.paper_id or [])
        if args.kind == "pilot" and not chosen:
            raise ValueError("A pilot needs explicit paper IDs")
        if args.kind == "full" and chosen:
            raise ValueError("A full sweep includes the complete input inventory")
        if chosen - {m["paper_id"] for m in models}:
            raise ValueError("Unknown pilot paper ID")
        selected = [m for m in models if not chosen or m["paper_id"] in chosen]
        confirmations = confirmation_refs(getattr(args, "confirmations", None),
                                          [m["paper_id"] for m in selected], PROJECT,
                                          [m["paper_id"] for m in models])
        catalog = load(catalog_path)
        frozen = {
            "models_inventory_sha256": sha256(models_path),
            "samples_inventory_sha256": sha256(samples_path),
            "catalog_sha256": catalog["catalog_sha256"],
            "catalog_artifact_sha256": sha256(catalog_path), "skill_sha256": skill_hash(),
        }
        # Validate the complete selection before creating or charging a run.
        payloads = []
        for record in selected:
            pid = record["paper_id"]
            sample, manifest = samples[pid], manifests[pid]
            reading = _resolve_source(record["paper_text_file"])
            pdf = _resolve_source(manifest["pdf_path"])
            if sha256(pdf) != manifest["pdf_sha256"]:
                raise ValueError(f"{pid}: PDF hash disagrees with source manifest")
            compact = [compact_model(m) for m in record["models"]]
            for m in compact:
                dependency_closure(compact, m["model_id"])
            reading_data = load(reading)
            if reading_data.get("paper_id") != pid:
                raise ValueError(f"{pid}: reading ID disagrees")
            # Legacy source_sha256 identifies a parsed-cache artifact, not the PDF.
            # The frozen paired manifest and explicit math-review lineage bind versions.
            if (reading != _resolve_source(manifest["reading_json"])
                    or sha256(reading) != manifest["reading_json_sha256"]):
                raise ValueError(f"{pid}: reading disagrees with the frozen paired manifest")
            reviewed_pdf_hash = (reading_data.get("model_math_review") or {}).get("pdf_sha256")
            if reviewed_pdf_hash and reviewed_pdf_hash != manifest["pdf_sha256"]:
                raise ValueError(f"{pid}: verified reading and PDF use different source versions")
            payloads.append({
                "schema_version": "1.0", "paper_id": pid, "doi": record.get("doi"),
                "title": manifest.get("title"), "journal": manifest.get("journal"),
                "reading_json": str(reading), "pdf_path": str(pdf),
                "input_hashes": {**frozen, "model_record_sha256": canonical_hash(record),
                                 "sample_record_sha256": canonical_hash(sample),
                                 "reading_sha256": sha256(reading), "pdf_sha256": sha256(pdf)},
                "models": compact, "sample_extraction": sample,
                "expected_scopes": [{"model_id": m, "result_set_id": r} for m, r in expected_scopes(compact)],
                "coverage_confirmations": confirmations[pid]["coverage_confirmations"],
                "access_confirmations": confirmations[pid]["access_confirmations"],
                "temporal_audit_path": str(run / "drafts" / pid / "temporal_audit.json"),
                "shared_evidence": str(Path(args.shared_evidence).resolve()) if args.shared_evidence else None,
                "allowed_checks": "Exact catalog SAS files under /storage/sas/base; documented SEC/LM exact paths without recursive scans; read-only PostgreSQL metadata and bounded fields/date/identifier queries. No source changes, downloads, or regressions.",
            })
        run.mkdir()
        for folder in ("items", "drafts", "assessments", "review"):
            (run / folder).mkdir()
        shutil.copytree(SKILL_ROOT, run / "skill_snapshot",
                        ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
        item_paths = []
        for payload in payloads:
            item_path = run / "items" / (payload["paper_id"] + ".json")
            save(item_path, payload)
            item_paths.append({"paper_id": payload["paper_id"], "item": str(item_path),
                               "sha256": sha256(item_path),
                               "output": str(run / "assessments" / (payload["paper_id"] + ".json"))})
        info = {
            "schema_version": "1.0", "run_id": runid, "kind": args.kind, "created_at": now(),
            "models_path": str(models_path), "samples_path": str(samples_path),
            "catalog_path": str(catalog_path), "input_hashes": frozen,
            "papers": item_paths, "worker_model": "gpt-6-luna", "reasoning_effort": "max",
            "publication_status": "pending",
        }
        save(run / "run.json", info)
        campaign["runs"].append({"run_id": runid, "kind": args.kind, "path": str(run)})
        save(campaign_path, campaign)
        return {"run": str(run), "papers": len(selected), "fits": sum(len(p["expected_scopes"]) for p in payloads),
                "quota_used": {k: sum(r["kind"] == k for r in campaign["runs"]) for k in ("pilot", "full")}}


def check_run_inputs(info):
    for key, pathkey in (("models_inventory_sha256", "models_path"), ("samples_inventory_sha256", "samples_path"),
                         ("catalog_artifact_sha256", "catalog_path")):
        if sha256(info[pathkey]) != info["input_hashes"][key]:
            raise ValueError(f"Frozen campaign input changed: {pathkey}")
    for paper in info["papers"]:
        if sha256(paper["item"]) != paper["sha256"]:
            raise ValueError(f"Frozen work item changed: {paper['paper_id']}")


def publish(run_path):
    run = Path(run_path).resolve()
    info = load(run / "run.json")
    if skill_hash() != info["input_hashes"]["skill_sha256"]:
        raise ValueError("Use the run's frozen skill snapshot; the active skill version differs")
    check_run_inputs(info)
    catalog = load(info["catalog_path"])
    documents = []
    for paper in info["papers"]:
        result = load(paper["output"])
        checked = finalize(result, paper["item"], catalog, PROJECT)
        if checked != result:
            raise ValueError(f"{paper['paper_id']}: result has stale calculated fields; finalize first")
        documents.append(checked)
    # Publication is complete, ordered, and cannot omit unknown/no-baseline cases.
    combined = run / "assessments.jsonl"
    content = "".join(json.dumps(d, ensure_ascii=False, separators=(",", ":")) + "\n" for d in documents)
    if combined.exists() and combined.read_text() != content:
        raise ValueError("Published results are immutable; use a new permitted run")
    combined.write_text(content)
    counts = Counter(d["summary"]["outcome"] for d in documents)
    fits = Counter(a["data_status"] for d in documents for a in d["assessments"])
    requirements = Counter(r["data_status"] for d in documents for r in d["requirements"])
    summary = {"papers": len(documents), "baseline_models": sum(d["summary"]["baseline_models"] for d in documents),
               "baseline_fits": sum(d["summary"]["baseline_fits"] for d in documents),
               "paper_outcomes": dict(counts), "fit_data_statuses": dict(fits),
               "requirement_statuses": dict(requirements), "aggregate_sha256": sha256(combined)}
    unknowns = [r for d in documents for r in d["requirements"] if r["data_status"] == "undetermined"]
    summary["unresolved_input_diagnostics"] = {
        "requirements_without_routes": sum(not r["routes"] for r in unknowns),
        "with_local_access_and_fields_verified": sum(any(
            t["route_type"] != "public_raw" and t["verification"]["access"] == "verified"
            and t["verification"]["fields"] in ("verified", "not_applicable") for t in r["routes"]) for r in unknowns),
        "with_unverified_local_coverage": sum(any(
            t["route_type"] != "public_raw" and t["verification"]["coverage"] != "verified" for t in r["routes"]) for r in unknowns),
        "with_unverified_semantic_mapping": sum(any(
            t["verification"]["mapping"] != "verified" for t in r["routes"]) for r in unknowns),
        "with_unknown_required_period": sum(r["required_coverage"]["begin"] is None
                                            or r["required_coverage"]["end"] is None for r in unknowns),
    }
    save(run / "summary.json", summary)
    with (run / "summary.csv").open("w", newline="") as stream:
        writer = csv.writer(stream)
        writer.writerow(["paper_id", "doi", "outcome", "baseline_models", "baseline_fits", "local_ready",
                         "public_acquisition_required", "access_blocked", "undetermined",
                         "no_observed_data_required", "attempt_ready_count"])
        for d in documents:
            s = d["summary"]
            writer.writerow([d["paper_id"], d["doi"], s["outcome"], s["baseline_models"], s["baseline_fits"],
                             *(s["assessment_counts"][k] for k in
                               ("local_ready", "public_acquisition_required", "access_blocked", "undetermined",
                                "no_observed_data_required")),
                             s["attempt_ready_count"]])
    info["publication_status"], info["aggregate_sha256"] = "published", sha256(combined)
    save(run / "run.json", info)
    if _layout and _layout.manages_run('feasibility', run, PROJECT):
        _layout.publish_feasibility(documents, info, summary, run, PROJECT)
    return summary


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    p = sub.add_parser("catalog", help="Index common's PROC CONTENTS report, aliases and documented resources")
    p.add_argument("--common", default=str(PROJECT.parent / "common"))
    p.add_argument("--aliases", default=str(SKILL_ROOT / "references/resource_aliases.json"))
    p.add_argument("--output", required=True)
    p = sub.add_parser("lookup", help="Search qualified datasets, aliases, field names and labels")
    p.add_argument("--catalog", required=True); p.add_argument("--query", required=True)
    p.add_argument("--limit", type=int, default=10)
    p = sub.add_parser("window", help="Calculate a conservative year envelope from additive source-supported month offsets")
    p.add_argument("--begin", type=int); p.add_argument("--end", type=int)
    p.add_argument("--lookback-months", type=int, action="append", default=[])
    p.add_argument("--lead-months", type=int, action="append", default=[])
    p = sub.add_parser("probe", help="Perform one bounded read-only request; failure remains unverified")
    p.add_argument("--catalog", required=True); p.add_argument("--request", required=True)
    p.add_argument("--output", required=True)
    p = sub.add_parser("prepare", help="Freeze a pilot or full run (limits: seven pilots, one full sweep)")
    p.add_argument("--root", default=str(_layout.work_root("feasibility", PROJECT) if _layout else PROJECT / "output/feasibility_runs"))
    p.add_argument("--kind", choices=["pilot", "full"], required=True)
    p.add_argument("--catalog", required=True); p.add_argument("--shared-evidence")
    p.add_argument("--confirmations", help="Coordinator JSON index of reviewed coverage/access artifacts, keyed by paper ID")
    p.add_argument("--models", default=str(DEFAULT_MODELS)); p.add_argument("--samples", default=str(DEFAULT_SAMPLES))
    p.add_argument("--manifest", default=str(DEFAULT_MANIFEST)); p.add_argument("--paper-id", action="append")
    p = sub.add_parser("template", help="Print the assigned output header (no substantive assessment)")
    p.add_argument("--item", required=True)
    p = sub.add_parser("temporal-template", help="Print separate timing stages for supporting outcomes/predictors")
    p.add_argument("--item", required=True)
    p.add_argument("--include-baseline", action="store_true",
                   help="Include baseline variables for lag/lead/scaling/fiscal-alignment review")
    for name in ("finalize", "validate"):
        p = sub.add_parser(name, help="Validate claims and IDs; calculate deterministic statuses" if name == "finalize"
                           else "Check a finalized result without writing")
        p.add_argument("--item", required=True); p.add_argument("--catalog", required=True)
        p.add_argument("--input", required=True)
        if name == "finalize": p.add_argument("--output", required=True)
    p = sub.add_parser("publish", help="Validate all assigned papers and publish a complete ordered JSONL")
    p.add_argument("--run", required=True)
    p = sub.add_parser("accept-pilot", help="Coordinator records a reviewed, published pilot for full-sweep eligibility")
    p.add_argument("--run", required=True); p.add_argument("--review", required=True)
    args = parser.parse_args(argv)
    if args.command == "catalog":
        result = build_catalog(args.common, args.aliases); save(args.output, result)
        print(json.dumps(result["counts"]))
    elif args.command == "lookup":
        print(json.dumps(lookup(load(args.catalog), args.query, args.limit), ensure_ascii=False, indent=2))
    elif args.command == "window":
        print(json.dumps(year_envelope(args.begin, args.end, args.lookback_months, args.lead_months), indent=2))
    elif args.command == "probe":
        result = probe(load(args.catalog), load(args.request)); save(args.output, result)
        print(json.dumps({"output": args.output, "status": result["status"]}))
    elif args.command == "prepare":
        print(json.dumps(prepare(args), indent=2))
    elif args.command == "template":
        print(json.dumps(output_header(load(args.item), args.item), indent=2))
    elif args.command == "temporal-template":
        print(json.dumps(temporal_template(load(args.item), args.include_baseline), indent=2))
    elif args.command in ("finalize", "validate"):
        draft = load(args.input)
        result = finalize(draft, args.item, load(args.catalog), PROJECT)
        if args.command == "finalize":
            save(args.output, result)
            print(json.dumps({"output": args.output, "summary": result["summary"]}))
        elif result != draft:
            raise ValueError("Calculated fields or provenance are stale")
        else:
            print(json.dumps({"valid": True, "summary": result["summary"]}))
    elif args.command == "publish":
        print(json.dumps(publish(args.run), indent=2))
    elif args.command == "accept-pilot":
        run = Path(args.run).resolve(); info = load(run / "run.json")
        review_path = Path(args.review).resolve(); review = load(review_path)
        if (info["kind"] != "pilot" or info["publication_status"] != "published"
                or review.get("accepted") is not True
                or review.get("aggregate_sha256") != info["aggregate_sha256"]):
            raise ValueError("Need an accepted review tied to the published pilot hash")
        check_run_inputs(info)
        campaign_path = run.parent / "campaign.json"; campaign = load(campaign_path)
        campaign["accepted_pilot"] = {"run_id": info["run_id"], "review": str(review_path), "sha256": sha256(review_path)}
        save(campaign_path, campaign)
        print(json.dumps(campaign["accepted_pilot"]))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, KeyError, OSError) as exc:
        print(str(exc), file=sys.stderr)
        sys.exit(1)
