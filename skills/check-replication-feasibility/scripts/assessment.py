"""Freeze model scopes, validate evidence, and calculate availability outcomes."""
from __future__ import annotations

import copy
import hashlib
import json
import re
import unicodedata
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
from urllib.parse import urlparse

from resources import load, sha256

STATUSES = ("local_ready", "public_acquisition_required", "access_blocked", "undetermined",
            "no_observed_data_required")
ASPECTS = {"sampling", "identifiers", "fixed_effects", "clusters", "weights", "estimation", "preprocessing"}
WINDOW_STAGES = ("sample_offset", "support_fit_window", "variable_lag_or_lead", "scaling_or_fiscal_alignment")
SKILL_ROOT = Path(__file__).resolve().parents[1]


def canonical_hash(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, ensure_ascii=False,
                                     separators=(",", ":")).encode()).hexdigest()


def skill_hash():
    paths = [p for p in SKILL_ROOT.rglob("*") if p.is_file() and "__pycache__" not in p.parts]
    return canonical_hash({str(p.relative_to(SKILL_ROOT)): sha256(p) for p in sorted(paths)})


def variables(model):
    return [model["dependent_variable"]] + model["independent_variables"]


def dependency_closure(models, target):
    byid = {m["model_id"]: m for m in models}
    if len(byid) != len(models):
        raise ValueError("Duplicate model IDs")
    done, active = set(), set()

    def cycle_check(mid):
        if mid not in byid:
            raise ValueError(f"Unknown dependency {mid}")
        if mid in active:
            raise ValueError(f"Dependency cycle at {mid}")
        if mid in done:
            return
        active.add(mid)
        for dep in byid[mid].get("dependencies", []):
            cycle_check(dep["model_id"])
        active.remove(mid)
        done.add(mid)

    for mid in byid:
        cycle_check(mid)
    selected, pending = set(), [target]
    while pending:
        mid = pending.pop()
        if mid in selected:
            continue
        if mid not in byid:
            raise ValueError(f"Unknown model {mid}")
        selected.add(mid)
        model = byid[mid]
        pending.extend(d["model_id"] for d in model.get("dependencies", []))
        group = model.get("estimation_group_id")
        if group:
            pending.extend(m["model_id"] for m in models if m.get("estimation_group_id") == group)
    return sorted(selected)


def expected_scopes(models):
    scopes = []
    for model in models:
        if model["model_role"] == "baseline":
            for fit in model.get("result_sets", []) or [None]:
                scopes.append((model["model_id"], fit["result_set_id"] if fit else None))
    if len(scopes) != len(set(scopes)):
        raise ValueError("Duplicate baseline fit IDs")
    return scopes


def compact_model(model):
    keys = ("model_id", "model_role", "model_label", "locations", "sample_id", "sample_description",
            "sample_size", "method", "method_reported", "method_details", "equation_text",
            "specifications", "dependencies", "estimation_group_id", "review_notes", "missing_fields")
    result = {k: model.get(k) for k in keys}
    for key in ("dependent_variable", "independent_variables"):
        value = model[key]
        def compact(v):
            return {k: v.get(k) for k in ("variable_id", "name", "definition", "formula", "evidence")}
        result[key] = [compact(v) for v in value] if isinstance(value, list) else compact(value)
    fitkeys = ("result_set_id", "label", "locations", "horizon", "period", "population", "aggregation", "review_notes")
    result["result_sets"] = [{k: fit.get(k) for k in fitkeys} for fit in model.get("result_sets", [])]
    return result


def output_header(item, item_path):
    result = {
        "schema_version": "1.2", "paper_id": item["paper_id"], "doi": item["doi"],
        "eligibility": "eligible" if expected_scopes(item["models"]) else "no_baseline",
        "provenance": {**item["input_hashes"], "work_item_sha256": sha256(item_path)},
        "requirements": [], "assessments": [], "evidence": [],
        "author_alternatives": [], "review_notes": [],
    }
    audit = item.get("temporal_audit_path")
    for key, value in item.get("review_source", {}).items():
        if key in {"aggregate_sha256", "assessment_sha256", "work_item_sha256", "converter_sha256",
                   "decisions_sha256"} and isinstance(value, str):
            result["provenance"]["review_source_" + key] = value
    if audit and Path(audit).exists():
        result["provenance"]["temporal_audit_file"] = str(audit)
        result["provenance"]["temporal_audit_sha256"] = sha256(audit)
    byid = {m["model_id"]: m for m in item["models"]}
    for mid, fit in expected_scopes(item["models"]):
        closure = dependency_closure(item["models"], mid)
        result["assessments"].append({
            "model_id": mid, "result_set_id": fit, "required_model_ids": closure,
            "data_mode": "observed", "data_mode_reason": None, "data_mode_evidence_ids": [],
            "requirement_ids": [],
            "variable_coverage": [
                {"model_id": m, "variable_id": v["variable_id"], "requirement_ids": [],
                 "construction": "", "non_data_reason": None}
                for m in closure for v in variables(byid[m])],
            "design_coverage": [
                {"aspect": aspect, "requirement_ids": [], "reason": None, "evidence_ids": []}
                for aspect in sorted(ASPECTS)],
            "implementation_issues": [], "data_status": "undetermined",
            "attempt_ready": False, "review_notes": [],
        })
    return result


def _local_path(locator, project):
    if _layout and _layout.manifest(project):
        return Path(str(_layout.artifact_path(locator, project)))
    path = Path(locator)
    if not path.is_absolute():
        path = project / path
    path = path.resolve()
    if not path.is_relative_to(project.resolve()):
        raise ValueError("Evidence artifacts must be in the project workspace")
    return path


def _normalize(text):
    return re.sub(r"\s+", "", unicodedata.normalize("NFKC", text))


def _evidence_records(document, item, project, errors):
    result = {}
    reading = load(item["reading_json"])
    pages = {int(p["page"]): p.get("text", "") for p in reading["pages"]}
    allowed_confirmations = {
        kind: {str(_local_path(x["path"], project)): x["sha256"] for x in item.get(kind, [])}
        for kind in ("coverage_confirmations", "access_confirmations")
    }
    for evidence in document["evidence"]:
        eid = evidence["evidence_id"]
        if eid in result:
            errors.append(f"Duplicate evidence ID {eid}")
        entry = {"evidence": evidence, "artifact": None}
        result[eid] = entry
        kind = evidence["kind"]
        if kind == "paper":
            if evidence["page"] not in pages:
                errors.append(f"{eid}: source page absent")
            if not evidence["quote"] or _normalize(evidence["quote"]) not in _normalize(pages.get(evidence["page"], "")):
                errors.append(f"{eid}: quote not found on assigned source page")
            if Path(evidence["locator"]).resolve() != Path(item["reading_json"]).resolve():
                errors.append(f"{eid}: paper locator must be the assigned literal reading path")
        elif kind == "public":
            if urlparse(evidence["locator"]).scheme not in ("http", "https") or not evidence["verified_at"]:
                errors.append(f"{eid}: public evidence requires URL and access timestamp")
        elif kind in ("probe", "coverage_confirmation", "access_confirmation"):
            try:
                path = _local_path(evidence["locator"], project)
                if sha256(path) != evidence["sha256"]:
                    raise ValueError("artifact checksum mismatch")
                entry["artifact"] = load(path)
                if kind != "probe":
                    listname = "coverage_confirmations" if kind == "coverage_confirmation" else "access_confirmations"
                    if allowed_confirmations[listname].get(str(path)) != evidence["sha256"]:
                        raise ValueError("confirmation is not in frozen coordinator-supplied work item")
                elif entry["artifact"].get("catalog_sha256") != item["input_hashes"]["catalog_sha256"]:
                    raise ValueError("probe uses a different catalog snapshot")
            except (OSError, ValueError, KeyError) as exc:
                errors.append(f"{eid}: invalid {kind}: {exc}")
    return result


def _coverage_confirmed(route, requirement, evidence):
    for eid in route["evidence_ids"]:
        e = evidence.get(eid, {})
        if e.get("evidence", {}).get("kind") != "coverage_confirmation":
            continue
        artifact = e.get("artifact") or {}
        if artifact.get("kind") != "coverage_confirmation" or artifact.get("verification") != "verified":
            continue
        if artifact.get("location") != route["location"] or not artifact.get("basis"):
            continue
        required = requirement["required_coverage"]
        actual = artifact.get("coverage", {})
        # Confirmations explicitly state the population/frequency they support.
        if actual.get("population") != required["population"] or actual.get("frequency") != required["frequency"]:
            continue
        if required["begin"] is None or required["end"] is None:
            continue
        if actual.get("begin") is None or actual.get("end") is None:
            continue
        if actual["begin"] > required["begin"] or actual["end"] < required["end"]:
            continue
        needed = set(required["years"] or range(required["begin"], required["end"] + 1))
        available = set(actual.get("years") or range(actual["begin"], actual["end"] + 1))
        if needed <= available:
            return True
    return False


def _route_ready(route, requirement, evidence, catalog, errors):
    v = route["verification"]
    local = route["route_type"] != "public_raw"
    if route["route_type"] == "local_sas":
        dataset = next((d for d in catalog["datasets"] if d["dataset"] == (route["dataset"] or "").upper()), None)
        if not dataset:
            errors.append(f"{route['route_id']}: local SAS dataset absent from catalog")
        elif route["location"] != dataset["path"]:
            errors.append(f"{route['route_id']}: local SAS location disagrees with catalog")
        elif any(f.casefold() not in {x["name"].casefold() for x in dataset["variables"]} for f in route["fields"]):
            errors.append(f"{route['route_id']}: mapped field absent from catalog")
    if route["route_type"] in ("local_sas", "local_postgres") and v["fields"] == "not_applicable":
        errors.append(f"{route['route_id']}: structured table fields cannot be not_applicable")
    if v["mapping"] == "verified" and not route["mapping_notes"].strip():
        errors.append(f"{route['route_id']}: semantic mapping needs an explanation")
    if v["coverage"] == "verified" and any(requirement["required_coverage"][x] is None for x in ("begin", "end")):
        errors.append(f"{route['route_id']}: unknown required calendar bounds cannot have verified coverage")
    probes = [evidence[x]["artifact"] for x in route["evidence_ids"]
              if x in evidence and evidence[x]["evidence"]["kind"] == "probe" and evidence[x]["artifact"]]
    goodprobes = [p for p in probes if p.get("status") == "ok"
                  and p.get("result", {}).get("location") == route["location"]]
    if local and v["access"] == "verified" and not any(
            p["result"].get("readable", not p["result"].get("is_directory", False)) for p in goodprobes):
        errors.append(f"{route['route_id']}: verified local access lacks a successful exact-resource probe")
    if local and v["fields"] == "verified":
        checked = {x.casefold() for p in goodprobes for x in p["result"].get("columns", [])}
        if not route["fields"] or not {x.casefold() for x in route["fields"]} <= checked:
            errors.append(f"{route['route_id']}: verified fields lack matching live field probes")
    if local and v["coverage"] == "verified" and not _coverage_confirmed(route, requirement, evidence):
        errors.append(f"{route['route_id']}: verified local coverage lacks a frozen coverage confirmation")
    if not local:
        if urlparse(route["location"]).scheme not in ("http", "https"):
            errors.append(f"{route['route_id']}: public route needs an HTTP(S) location")
        if not any(evidence.get(e, {}).get("evidence", {}).get("kind") == "public" for e in route["evidence_ids"]):
            errors.append(f"{route['route_id']}: public route needs checked public evidence")
    return (v["access"] == "verified" and v["fields"] in ("verified", "not_applicable")
            and v["mapping"] == "verified"
            and v["coverage"] == "verified" and v["identifiers"] in ("verified", "not_applicable"))


def year_envelope(begin=None, end=None, lookback_months=(), lead_months=()):
    """Conservative calendar-year envelope; source choices are not inferred."""
    for value in (begin, end):
        if value is not None and (isinstance(value, bool) or not isinstance(value, int)):
            raise ValueError("Anchor years must be integers or null")
    if begin is not None and end is not None and begin > end:
        raise ValueError("Anchor begin exceeds end")
    for value in list(lookback_months) + list(lead_months):
        if isinstance(value, bool) or not isinstance(value, int) or value < 0:
            raise ValueError("Window components must be nonnegative integer months")
    return {"begin": None if begin is None else begin - (sum(lookback_months) + 11) // 12,
            "end": None if end is None else end + (sum(lead_months) + 11) // 12,
            "anchor_begin": begin, "anchor_end": end,
            "lookback_months": list(lookback_months), "lead_months": list(lead_months),
            "note": "Conservative year envelope, not exact observation dates. All offsets must be supported by the paper; unknown endpoints remain null."}


def temporal_template(item, include_baseline=False):
    used = {mid for model, _ in expected_scopes(item["models"])
            for mid in dependency_closure(item["models"], model)}
    return {
        "paper_id": item["paper_id"], "baseline_timing_review": "",
        "records": [
            {"model_id": m["model_id"], "variable_id": v["variable_id"],
             "requirement_ids": [], "anchor_begin": None, "anchor_end": None, "anchor_basis": "",
             "components": {stage: {"lookback_months": 0, "lead_months": 0, "reason": ""}
                            for stage in WINDOW_STAGES},
             "evidence_ids": [], "non_data_reason": None}
            for m in item["models"] if m["model_id"] in used
            and (include_baseline or m["model_role"] == "supporting") for v in variables(m)],
    }


def validate_temporal_audit(document, item, requirements, evidence, errors):
    """Check supplied source choices and interval composition; never infer lags."""
    if not item.get("temporal_audit_path") or document["eligibility"] == "no_baseline":
        return
    try:
        audit = load(item["temporal_audit_path"])
    except (OSError, ValueError) as exc:
        errors.append(f"Required per-variable temporal audit missing/invalid: {exc}")
        return
    if not isinstance(audit, dict) or not isinstance(audit.get("records"), list):
        errors.append("Temporal audit must be an object with a records array")
        return
    review = audit.get("baseline_timing_review")
    if audit.get("paper_id") != item["paper_id"] or not isinstance(review, str) or not review.strip():
        errors.append("Temporal audit needs matching paper_id and a baseline timing review")
    bymodel = {m["model_id"]: m for m in item["models"]}
    links = {}
    exemptions = {}
    for assessment in document["assessments"]:
        for v in assessment["variable_coverage"]:
            pair = (v["model_id"], v["variable_id"])
            links.setdefault(pair, set()).update(v["requirement_ids"])
            exemptions[pair] = exemptions.get(pair, True) and bool(v["non_data_reason"])
    expected = {pair for pair in links if pair[0] in bymodel
                and bymodel[pair[0]]["model_role"] == "supporting" and not exemptions[pair]}
    covered = set()
    for i, record in enumerate(audit.get("records", [])):
        label = f"Temporal row {i + 1}"
        if not isinstance(record, dict):
            errors.append(f"{label}: record must be an object")
            continue
        pair = (record.get("model_id"), record.get("variable_id"))
        if pair not in links:
            errors.append(f"{label}: variable is not in the assigned baseline dependency closure")
            continue
        covered.add(pair)
        refs = record.get("requirement_ids", [])
        if not isinstance(refs, list):
            errors.append(f"{label}: requirement_ids must be an array")
            continue
        if not set(refs) <= links[pair]:
            errors.append(f"{label}: raw requirement is not linked to this variable")
        if record.get("non_data_reason"):
            if not exemptions[pair]:
                errors.append(f"{label}: observed input cannot be exempted from timing")
            continue
        if not refs or not isinstance(record.get("anchor_basis"), str) or not record["anchor_basis"].strip():
            errors.append(f"{label}: observed input needs raw requirements and an anchor explanation")
        if (not isinstance(record.get("evidence_ids"), list) or not record["evidence_ids"]
                or any(e not in evidence for e in record["evidence_ids"])):
            errors.append(f"{label}: source evidence needed")
        components = record.get("components", {})
        if not isinstance(components, dict) or set(components) != set(WINDOW_STAGES):
            errors.append(f"{label}: explicitly review all four offset stages")
            continue
        try:
            if any(not isinstance(c, dict) or not isinstance(c.get("reason"), str)
                   or not c["reason"].strip() for c in components.values()):
                raise ValueError("explain zero, known and unknown offsets at each stage")
            for c in components.values():
                for k in ("lookback_months", "lead_months"):
                    value = c.get(k)
                    if value is not None and (isinstance(value, bool) or not isinstance(value, int) or value < 0):
                        raise ValueError("offsets must be nonnegative integer months or null")
            backs = [components[s].get("lookback_months") for s in WINDOW_STAGES]
            leads = [components[s].get("lead_months") for s in WINDOW_STAGES]
            bounds = year_envelope(record.get("anchor_begin"), record.get("anchor_end"),
                                   [x for x in backs if x is not None], [x for x in leads if x is not None])
            if None in backs: bounds["begin"] = None
            if None in leads: bounds["end"] = None
            for rid in refs:
                if rid not in requirements:
                    continue
                req = requirements[rid]["required_coverage"]
                for bound in ("begin", "end"):
                    if req[bound] is None:
                        continue
                    if bounds[bound] is None:
                        errors.append(f"{label}/{rid}: requirement has a finite {bound} despite an unknown raw window")
                    elif ((bound == "begin" and req[bound] > bounds[bound])
                          or (bound == "end" and req[bound] < bounds[bound])):
                        errors.append(f"{label}/{rid}: requirement {bound} does not cover computed raw bound {bounds[bound]}")
        except (ValueError, TypeError, KeyError) as exc:
            errors.append(f"{label}: {exc}")
    if not expected <= covered:
        errors.append("Temporal audit omits supporting outcomes/predictors: " + str(sorted(expected - covered)))


def aggregate(statuses):
    if "access_blocked" in statuses:
        return "access_blocked"
    if not statuses or "undetermined" in statuses:
        return "undetermined"
    if "public_acquisition_required" in statuses:
        return "public_acquisition_required"
    if all(s == "no_observed_data_required" for s in statuses):
        return "no_observed_data_required"
    return "local_ready"


def calculate_summary(document):
    counts = dict.fromkeys(STATUSES, 0)
    for a in document["assessments"]:
        counts[a["data_status"]] += 1
    n = sum(counts.values())
    feasible = counts["local_ready"] + counts["public_acquisition_required"] + counts["no_observed_data_required"]
    if document["eligibility"] == "no_baseline":
        outcome = "not_applicable"
    elif n and counts["no_observed_data_required"] == n:
        outcome = "no_observed_data_required"
    elif feasible == n and n:
        outcome = "public_acquisition_required" if counts["public_acquisition_required"] else "all_local_ready"
    elif feasible:
        outcome = "partially_feasible"
    else:
        outcome = "undetermined" if counts["undetermined"] else "access_blocked"
    return {
        "outcome": outcome, "assessment_counts": counts,
        "baseline_models": len({a["model_id"] for a in document["assessments"]}), "baseline_fits": n,
        "any_data_feasible": bool(feasible), "all_data_feasible": bool(n and feasible == n),
        "partially_data_feasible": bool(0 < feasible < n),
        "attempt_ready_count": sum(a["attempt_ready"] for a in document["assessments"]),
    }


def finalize(document, item_path, catalog, project):
    """Only computed fields/provenance are filled; substantive claims are not repaired."""
    from jsonschema import Draft202012Validator, FormatChecker
    item_path, project = Path(item_path), Path(project).resolve()
    item = load(item_path)
    document = copy.deepcopy(document)
    header = output_header(item, item_path)
    for key in ("schema_version", "paper_id", "doi", "eligibility", "provenance"):
        if key in document and key != "provenance" and document[key] != header[key]:
            raise ValueError(f"{key} disagrees with frozen work item")
        document[key] = header[key]
    document.setdefault("author_alternatives", [])
    document.setdefault("review_notes", [])
    for req in document.get("requirements", []):
        req["data_status"] = "undetermined"
    for a in document.get("assessments", []):
        a.setdefault("data_mode", "observed")
        a.setdefault("data_mode_reason", None)
        a.setdefault("data_mode_evidence_ids", [])
        a["data_status"], a["attempt_ready"] = "undetermined", False
    document["summary"] = calculate_summary(document)
    schema = load(SKILL_ROOT / "references/output.schema.json")
    structural = sorted(Draft202012Validator(schema, format_checker=FormatChecker()).iter_errors(document),
                        key=lambda e: str(list(e.path)))
    if structural:
        raise ValueError("\n".join(f"{list(e.path)}: {e.message}" for e in structural[:20]))
    errors = []
    if item["input_hashes"]["catalog_sha256"] != catalog["catalog_sha256"]:
        errors.append("Catalog version disagrees with work item")
    for key, pathkey in (("reading_sha256", "reading_json"), ("pdf_sha256", "pdf_path")):
        if sha256(item[pathkey]) != item["input_hashes"][key]:
            errors.append(f"Frozen {pathkey} changed")
    evidence = _evidence_records(document, item, project, errors)

    def checkrefs(refs, label):
        for eid in refs:
            if eid not in evidence:
                errors.append(f"{label}: unknown evidence {eid}")

    requirements, routes = {}, set()
    for req in document["requirements"]:
        rid = req["requirement_id"]
        if rid in requirements:
            errors.append(f"Duplicate requirement {rid}")
        requirements[rid] = req
        checkrefs(req["evidence_ids"] + req["blocked_evidence_ids"], rid)
        if not req["evidence_ids"]:
            errors.append(f"{rid}: requirement needs source/design evidence")
        c = req["required_coverage"]
        if not c["frequency"].strip() or not c["population"].strip():
            errors.append(f"{rid}: frequency and population must be described")
        if c["begin"] is not None and c["end"] is not None:
            if c["begin"] > c["end"] or any(y < c["begin"] or y > c["end"] for y in c["years"]):
                errors.append(f"{rid}: invalid required coverage years")
        if len(c["years"]) != len(set(c["years"])):
            errors.append(f"{rid}: repeated coverage years")
        ready = []
        for route in req["routes"]:
            if route["route_id"] in routes:
                errors.append(f"Duplicate route ID {route['route_id']}")
            routes.add(route["route_id"])
            checkrefs(route["evidence_ids"], route["route_id"])
            if _route_ready(route, req, evidence, catalog, errors):
                ready.append("local_ready" if route["route_type"] != "public_raw" else "public_acquisition_required")
        # Alternate routes are OR, mandatory requirements within a fit are AND.
        if "local_ready" in ready:
            req["data_status"] = "local_ready"
        elif ready:
            req["data_status"] = "public_acquisition_required"
        elif req["blocked_reason"]:
            confirmed = any(
                evidence.get(e, {}).get("evidence", {}).get("kind") == "access_confirmation"
                and (evidence.get(e, {}).get("artifact") or {}).get("kind") == "access_confirmation"
                and (evidence[e]["artifact"].get("verification") == "blocked")
                and evidence[e]["artifact"].get("requirement_id") == rid
                for e in req["blocked_evidence_ids"])
            if not confirmed:
                errors.append(f"{rid}: blocker lacks a frozen access confirmation")
            req["data_status"] = "access_blocked"
        elif not req["unresolved_reason"]:
            errors.append(f"{rid}: unresolved requirement needs a reason")
        if req["data_status"] in ("local_ready", "public_acquisition_required") and req["unresolved_reason"]:
            errors.append(f"{rid}: complete route conflicts with unresolved_reason; distinguish construction issues from unresolved inputs")

    def reqrefs(refs, label):
        for rid in refs:
            if rid not in requirements:
                errors.append(f"{label}: unknown requirement {rid}")

    scopes = expected_scopes(item["models"])
    actual = [(a["model_id"], a["result_set_id"]) for a in document["assessments"]]
    if len(actual) != len(set(actual)) or set(actual) != set(scopes):
        errors.append("Assessments must exactly match all assigned baseline fit IDs")
    bymodel = {m["model_id"]: m for m in item["models"]}
    used = set()
    for a in document["assessments"]:
        mid = a["model_id"]
        if mid not in bymodel:
            continue
        closure = dependency_closure(item["models"], mid)
        if set(a["required_model_ids"]) != set(closure):
            errors.append(f"{mid}: missing/extra supporting or joint-estimation model")
        expected_vars = {(m, v["variable_id"]) for m in closure for v in variables(bymodel[m])}
        actual_vars = [(v["model_id"], v["variable_id"]) for v in a["variable_coverage"]]
        if len(actual_vars) != len(set(actual_vars)) or set(actual_vars) != expected_vars:
            errors.append(f"{mid}: incomplete/extra variable coverage")
        reqrefs(a["requirement_ids"], mid)
        used.update(a["requirement_ids"])
        checkrefs(a["data_mode_evidence_ids"], mid + "/data_mode")
        if a["data_mode"] == "synthetic_only":
            if not a["data_mode_reason"] or not a["data_mode_reason"].strip():
                errors.append(f"{mid}: synthetic_only needs an explicit source-supported reason")
            if not any(evidence.get(e, {}).get("evidence", {}).get("kind") == "paper"
                       for e in a["data_mode_evidence_ids"]):
                errors.append(f"{mid}: synthetic_only needs original-paper evidence")
            if a["requirement_ids"] or any(v["requirement_ids"] or not v["non_data_reason"]
                                           for v in a["variable_coverage"]):
                errors.append(f"{mid}: synthetic_only cannot retain observed inputs or unexplained variables")
        elif not a["requirement_ids"]:
            errors.append(f"{mid}: observed baseline has no data requirements")
        for v in a["variable_coverage"]:
            reqrefs(v["requirement_ids"], mid + "/" + v["variable_id"])
            if not set(v["requirement_ids"]) <= set(a["requirement_ids"]):
                errors.append(f"{mid}: variable references a requirement absent from fit")
            if not v["requirement_ids"] and not v["non_data_reason"]:
                errors.append(f"{mid}/{v['variable_id']}: needs inputs or an explicit non-data reason")
            if not v["construction"]:
                errors.append(f"{mid}/{v['variable_id']}: construction/mapping explanation required")
        aspects = [d["aspect"] for d in a["design_coverage"]]
        if len(aspects) != len(set(aspects)) or set(aspects) != ASPECTS:
            errors.append(f"{mid}: complete all seven design aspects once")
        for design in a["design_coverage"]:
            reqrefs(design["requirement_ids"], mid + "/" + design["aspect"])
            checkrefs(design["evidence_ids"], mid + "/" + design["aspect"])
            if not set(design["requirement_ids"]) <= set(a["requirement_ids"]):
                errors.append(f"{mid}: design requirement absent from fit")
            if not design["requirement_ids"] and not design["reason"]:
                errors.append(f"{mid}/{design['aspect']}: requirement or reason required")
        for issue in a["implementation_issues"]:
            checkrefs(issue["evidence_ids"], mid + "/issue")
        statuses = [requirements[r]["data_status"] for r in a["requirement_ids"] if r in requirements]
        a["data_status"] = ("no_observed_data_required" if a["data_mode"] == "synthetic_only"
                            else aggregate(statuses))
        a["attempt_ready"] = a["data_status"] in ("local_ready", "no_observed_data_required") and not any(
            i["blocking"] for i in a["implementation_issues"])
    if used != set(requirements):
        errors.append("Every mandatory requirement must belong to a baseline fit")
    for alt in document["author_alternatives"]:
        checkrefs(alt["evidence_ids"], "author alternative")
    if document["eligibility"] == "no_baseline" and (document["requirements"] or document["assessments"]):
        errors.append("No-baseline papers must have empty requirements and assessments")
    validate_temporal_audit(document, item, requirements, evidence, errors)
    if errors:
        raise ValueError("\n".join(errors[:40]))
    document["summary"] = calculate_summary(document)
    return document
