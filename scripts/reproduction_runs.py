#!/usr/bin/env python3
"""Coordinate frozen per-paper assignments and ordinary SAS/Stata executions.

This module never constructs research variables or estimates a model itself.
"""
from __future__ import annotations

import argparse
import contextlib
import csv
import fcntl
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT))
import project_layout as layout
Path = layout.path_class(PROJECT)
PROJECT = Path(str(PROJECT))
RUNS = Path(layout.work_root('reproduction', PROJECT))
CAMPAIGN = RUNS / "campaign.json"
SKILL = PROJECT / "skills/reproduce-accounting-models"
PAPERS = Path(layout.active_path('reproductions', PROJECT))
SAS = "/usr/local/SAS/SASFoundation/9.4/bin/sas_u8"
STATA = "/usr/local/bin/stata"
FORMATS = ("md", "rtf", "csv", "tex")
PILOTS = ["W2067475882", "W3124365414", "W2152596199", "W3124907716",
          "W1990806291", "W2015142764"]


def now():
    return datetime.now(timezone.utc).isoformat()


def read(path):
    return json.loads(Path(path).read_text())


def write(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_name(path.name + f".{os.getpid()}.tmp")
    temp.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")
    temp.replace(path)


def sha(path):
    h = hashlib.sha256()
    with Path(path).open("rb") as f:
        for chunk in iter(lambda: f.read(4 * 1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, ensure_ascii=False).encode()).hexdigest()


def tree_hash(root):
    return digest({str(p.relative_to(root)): sha(p) for p in sorted(Path(root).rglob("*"))
                   if p.is_file() and "__pycache__" not in p.parts})


@contextlib.contextmanager
def lock(path):
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    with Path(path).open("a") as f:
        fcntl.flock(f, fcntl.LOCK_EX)
        yield


def inside(root, relative):
    if any(c in str(relative) for c in ['"', "\n", "\r"]):
        raise ValueError("Path contains unsupported quoting/control characters")
    p = Path(relative)
    if p.is_absolute() or ".." in p.parts:
        raise ValueError(f"Expected a relative in-attempt path: {relative}")
    target = (Path(root) / p).resolve()
    if not target.is_relative_to(Path(root).resolve()):
        raise ValueError(f"Path escapes attempt: {relative}")
    return target


def records(path):
    return [json.loads(line) for line in Path(path).read_text().splitlines() if line.strip()]


def prepare():
    if CAMPAIGN.exists():
        return {"campaign": str(CAMPAIGN), "existing": True}
    index = read(layout.active_path('feasibility_index', PROJECT))
    assessment_path = PROJECT / index["aggregate"]["path"]
    if sha(assessment_path) != index["aggregate"]["sha256"]:
        raise ValueError("Canonical feasibility checksum mismatch")
    assessments = {r["paper_id"]: r for r in records(assessment_path)}
    summary_path = Path(layout.active_path('feasibility_summary', PROJECT)) / 'papers_summary.csv'
    rows = list(csv.DictReader(summary_path.open()))
    selected = []
    for row in rows:
        a = assessments[row["paper_id"]]
        qualifies = bool(a["requirements"]) and all(any(
            t["route_type"] != "public_raw" and t["verification"]["access"] == "verified"
            and t["verification"]["fields"] in ("verified", "not_applicable")
            for t in r["routes"]) for r in a["requirements"])
        if qualifies != (row["all_requirements_have_readable_local_candidates"] == "True"):
            raise ValueError("Selection summary disagrees with canonical assessment")
        if qualifies:
            selected.append({k: row[k] for k in ("paper_id", "title", "journal", "publication_year")} |
                            {"expected_scopes": int(row["baseline_fit_checks"]),
                             "baseline_models": int(row["baseline_models"])})
    if len(selected) != 47:
        raise ValueError(f"Expected 47 selected papers, found {len(selected)}")
    c = {"schema_version": "1.0", "created_at": now(), "status": "active",
         "model": "gpt-6-luna", "reasoning_effort": "max",
         "limit_per_paper": 6, "limit_total": 282, "pilots": PILOTS,
         "selection_field": "all_requirements_have_readable_local_candidates",
         "inputs": {str(p.relative_to(PROJECT)): sha(p) for p in [assessment_path, summary_path,
             Path(layout.active_path('models', PROJECT)), Path(layout.active_path('shortlist', PROJECT))]},
         "papers": [p | {"assignments": [], "accepted_attempt": None} for p in selected]}
    write(CAMPAIGN, c)
    return {"campaign": str(CAMPAIGN), "papers": len(selected)}


def assign(paper_id, role):
    with lock(RUNS / "campaign.lock"):
        c = read(CAMPAIGN)
        p = next(p for p in c["papers"] if p["paper_id"] == paper_id)
        if p.get("paused"):
            raise ValueError(f"Paper {paper_id} is paused by the user; resume authorization is required")
        n = len(p["assignments"]) + 1
        if n > c["limit_per_paper"]:
            raise ValueError(f"Configured per-paper quota exhausted for {paper_id}")
        if sum(len(p["assignments"]) for p in c["papers"]) >= c["limit_total"]:
            raise ValueError("Total assignment quota exhausted")
        for relative, expected in c.get("inputs", {}).items():
            path = PROJECT / relative
            if not path.is_file() or sha(path) != expected:
                raise ValueError("Frozen campaign input changed: " + relative)
        if (n == 1) != (role == "build"):
            raise ValueError("First assignment must build; subsequent assignments review or repair")
        attempt_root = RUNS / 'papers' if layout.manifest(PROJECT) else PAPERS
        attempt = attempt_root / paper_id / f"attempt_{n:02d}"
        attempt.mkdir(parents=True, exist_ok=False)
        snapshot = attempt / "skill_snapshot"
        shutil.copytree(SKILL, snapshot, ignore=shutil.ignore_patterns("__pycache__"))
        template = PROJECT.parent / "common/stata.template.ipynb"
        shutil.copy2(template, attempt / "stata.template.ipynb")
        published_index=read(layout.active_path('feasibility_index',PROJECT))
        reviewed=published_index.get('reviewed_run',{}).get('directory')
        src = (Path(reviewed)/'items'/f'{paper_id}.json') if reviewed else PROJECT / f"output/feasibility_runs/full_01_reviewed/items/{paper_id}.json"
        old = read(src)
        assessment = Path(layout.active_path('feasibility_records', PROJECT)) / f'{paper_id}.json'
        audit = Path(old["temporal_audit_path"])
        catalog = Path(layout.active_path('catalog', PROJECT))
        sources = [src, assessment, audit, catalog, Path(old["reading_json"]), Path(old["pdf_path"])]
        predecessor = Path(p["assignments"][-1]["path"]) if n > 1 else None
        work = {"schema_version": "1.0", "paper_id": paper_id, "attempt": n, "role": role,
                "title": old["title"], "journal": old["journal"], "doi": old["doi"],
                "models": old["models"], "sample_extraction": old["sample_extraction"],
                "expected_scopes": old["expected_scopes"],
                "reading_json": old["reading_json"], "pdf_path": old["pdf_path"],
                "feasibility_path": str(assessment), "temporal_audit_path": str(audit),
                "catalog_path": str(catalog), "template_path": str(attempt / "stata.template.ipynb"),
                "skill_path": str(snapshot / "SKILL.md"), "skill_sha256": tree_hash(snapshot),
                "source_hashes": {str(q): sha(q) for q in sources}, "template_sha256": sha(template),
                "predecessor": str(predecessor) if predecessor else None,
                 "ado_path": str(layout.active_path('ado', PROJECT)),
                "authorized": {"full_reconstruction": True, "best_effort": True,
                    "source_data_read_only": True, "agent_delegation": False,
                    "package_installation": False}}
        write(attempt / "work_item.json", work)
        if predecessor:
            for name in ["build.sas", "stata.ipynb", "design.md", "submission.json"]:
                if (predecessor / name).exists():
                    shutil.copy2(predecessor / name, attempt / name)
            sub = read(attempt / "submission.json") if (attempt / "submission.json").exists() else None
        else:
            sub = None
        if sub is None:
            sub = {"paper_id": paper_id, "attempt": n, "required_commands": ["esttab", "estpost", "estadd"],
                   "samples": [], "fits": [s | {"cell_id": None, "table_basename": None,
                       "fidelity": "best_effort", "assumptions": [],
                       "blocked_reason": "Not implemented yet"} for s in old["expected_scopes"]],
                   "limitations": []}
        sub["attempt"] = n
        write(attempt / "submission.json", sub)
        entry = {"attempt": n, "role": role, "path": str(attempt), "reserved_at": now(),
                 "agent": None, "status": "assigned", "skill_sha256": work["skill_sha256"],
                 "work_item_sha256": sha(attempt / "work_item.json")}
        p["assignments"].append(entry)
        write(CAMPAIGN, c)
    return entry | {"expected_scopes": len(work["expected_scopes"])}


def register(attempt, agent):
    layout.writable_path(attempt,PROJECT)
    work = read(Path(attempt) / "work_item.json")
    with lock(RUNS / "campaign.lock"):
        c = read(CAMPAIGN)
        p = next(p for p in c["papers"] if p["paper_id"] == work["paper_id"])
        a = p["assignments"][work["attempt"] - 1]
        if a["agent"] and a["agent"] != agent:
            raise ValueError("Assignment already has another agent")
        a["agent"] = agent
        a["status"] = "running"
        write(CAMPAIGN, c)
    return a


def source(cell):
    s = cell.get("source", [])
    return s if isinstance(s, str) else "".join(s)


def notebook(cells, language):
    return {"nbformat": 4, "nbformat_minor": 5,
            "metadata": {"kernelspec": {"name": language, "display_name": language.capitalize(),
                                        "language": language}}, "cells": cells}


def sync(attempt):
    layout.writable_path(attempt,PROJECT)
    attempt = Path(attempt).resolve()
    cells = [{"cell_type": "markdown", "id": "construction-notes", "metadata": {},
              "source": (attempt / "design.md").read_text().splitlines(keepends=True)},
             {"cell_type": "code", "id": "sas-construction", "metadata": {}, "outputs": [],
              "execution_count": None, "source": (attempt / "build.sas").read_text().splitlines(keepends=True)}]
    write(attempt / "sas.ipynb", notebook(cells, "sas"))
    return {"notebook": str(attempt / "sas.ipynb")}


def clean_code(code):
    # Preserve strings for file/option checks, remove Stata's comments.
    code = re.sub(r"/\*.*?\*/", "", code, flags=re.S)
    return "\n".join(line.split("//")[0] for line in code.splitlines()
                     if not line.lstrip().startswith("*"))


def code_issues(code):
    text = clean_code(code)
    issues = []
    banned = [r"(?im)^\s*(?:qui(?:etly)?\s+|cap(?:ture)?\s+)*(?:program\s+(?:define|drop)|mata\b|postfile\b|postclose\b|post\s|file\s+(?:open|write)|ereturn\s+(?:post|repost)|putexcel\b|putdocx\b|python\b|shell\b|!|ssc\s+install|net\s+install|cd\s|do\s|run\s|include\s|save\s|import\s)",
              r"(?i)\b(?:estimates\s+save|svmat|mkmat|statsby)\b", r"(?i)\.ster\b"]
    if any(re.search(p, text) for p in banned):
        issues.append("Forbidden authored wrapper/metadata/dump/install/external-code command")
    if not re.search(r"(?im)^\s*version\s+18(?:\.0)?\s*$", text):
        issues.append("Cell must declare version 18")
    if not re.search(r"(?im)^\s*set\s+more\s+off\s*$", text):
        issues.append("Cell must set more off")
    if not re.search(r'(?im)^\s*use\s+["\']?[^\n]*reg\.dta["\']?\s*,\s*clear', text):
        issues.append("Cell must load its own reg.dta with clear")
    refs = set(re.findall(r"\$\{?(\w+)", text))
    definitions = set(re.findall(r"(?im)^\s*global\s+(\w+)\b", text))
    if refs - definitions:
        issues.append("Undefined cell globals: " + ", ".join(sorted(refs - definitions)))
    if re.search(r"(?im)^\s*(?:cap(?:ture)?|qui(?:etly)?)\s+.*(?:regress|reghdfe|probit|logit|gmm|nlsur)", text):
        issues.append("Do not suppress baseline estimator errors/output")
    return issues


def sas_library_issues(code, attempt):
    issues = []
    root = Path(attempt).resolve()
    text = re.sub(r"/\*.*?\*/", "", code, flags=re.S)
    for statement in re.findall(r"\blibname\b[^;]+;", text, re.I):
        if re.search(r"access\s*=\s*readonly", statement, re.I):
            continue
        for _, location in re.findall(r"(['\"])(.*?)\1", statement):
            if '&' in location or '%' in location:
                issues.append("Writable SAS libraries require literal in-attempt paths")
            elif not (root / location).resolve().is_relative_to(root):
                issues.append("Writable SAS library escapes this attempt: " + location)
    return issues


def sas_name_warnings(code):
    # Advisory only: unquoted %PUT text can also contain long words.
    # Ignore quoted labels/paths and ordinary block or statement comments.
    text = re.sub(
        r"/\*[\s\S]*?\*/|'(?:''|[^'])*'|\"(?:\"\"|[^\"])*\"|(?m:^\s*\*[^;]*;)",
        " ", code)
    names = sorted(set(re.findall(r"\b[A-Za-z_][A-Za-z0-9_]{32,}\b", text)))
    return (["Possible SAS identifiers exceed 32 characters: " + ", ".join(names)]
            if names else [])


def sas_diagnostic_warnings(code):
    # Advisory: a semicolon inside unquoted %PUT prose terminates the macro
    # statement and leaves the remaining prose to be parsed as SAS code.
    # Multiple intentional statements on a line are legal, so do not reject.
    text = re.sub(r"/\*[\s\S]*?\*/", lambda m: re.sub(r"[^\n]", " ", m[0]), code)
    warnings = []
    for number, line in enumerate(text.splitlines(), 1):
        if re.match(r"\s*%put\b", line, re.I) and line.partition(";")[2].strip():
            warnings.append(f"SAS line {number}: text follows a %PUT semicolon; inspect for an unintended statement terminator")
    return warnings


def sas_source_path_warnings(code, declared_sources, catalog):
    # Compare literal declarations to the catalog without probing source folders.
    text = re.sub(r"/\*[\s\S]*?\*/|(?m:^\s*\*[^;]*;)", " ", code)
    libraries = {}
    for statement in re.findall(r"\blibname\b[^;]+;", text, re.I):
        match = re.search(r"\blibname\s+(\w+)\s+(['\"])(.*?)\2", statement, re.I)
        if match and re.search(r"access\s*=\s*readonly", statement, re.I):
            libraries[match[1].lower()] = Path(match[3])
    expected = {}
    for item in catalog["datasets"]:
        if item["dataset"] in declared_sources:
            expected.setdefault(Path(item["path"]).stem.lower(), set()).add(Path(item["path"]))
    code_only = re.sub(r"'(?:''|[^'])*'|\"(?:\"\"|[^\"])*\"", " ", text)
    warnings = set()
    for lib, name in re.findall(r"\b([A-Za-z_]\w*)\.([A-Za-z_]\w*)\b", code_only):
        lib, name = lib.lower(), name.lower()
        if lib in libraries and name in expected:
            path = libraries[lib] / (name + ".sas7bdat")
            if path not in expected[name]:
                warnings.add(f"SAS source {lib}.{name} resolves to {path}, not its declared catalog path")
    return sorted(warnings)


def validate(attempt, verify_sources=True):
    attempt = Path(attempt).resolve()
    work = read(attempt / "work_item.json")
    sub = read(attempt / "submission.json")
    errors, warnings = [], []
    if CAMPAIGN.exists():
        campaign = read(CAMPAIGN)
        matching = [a for p in campaign["papers"] for a in p["assignments"] if a["path"] == str(attempt)]
        if matching and sha(attempt / "work_item.json") != matching[0]["work_item_sha256"]:
            errors.append("Assigned work item changed")
    if sub.get("paper_id") != work["paper_id"] or sub.get("attempt") != work["attempt"]:
        errors.append("Submission identity mismatch")
    if tree_hash(attempt / "skill_snapshot") != work["skill_sha256"]:
        errors.append("Assigned skill snapshot changed")
    if sha(attempt / "stata.template.ipynb") != work["template_sha256"]:
        errors.append("Assigned template changed")
    if verify_sources:
        for p, expected in work["source_hashes"].items():
            if not Path(p).exists() or sha(p) != expected:
                errors.append("Input changed: " + p)
    expected = {(s["model_id"], s["result_set_id"]) for s in work["expected_scopes"]}
    fits = sub.get("fits", [])
    keys = [(s.get("model_id"), s.get("result_set_id")) for s in fits]
    if len(keys) != len(set(keys)) or set(keys) != expected:
        errors.append("Fit inventory does not exactly match assigned scopes")
    samples = sub.get("samples", [])
    if len({s["sample_id"] for s in samples}) != len(samples):
        errors.append("Duplicate sample IDs")
    for s in samples:
        for k in ["sas_file", "dta_file"]:
            inside(attempt, s[k])
        if Path(s["dta_file"]).name != "reg.dta":
            errors.append("Samples require reg.dta")
        key = s.get("key")
        if (not isinstance(key, list) or not key or
                any(not isinstance(k, str) or not re.fullmatch(r"[A-Za-z_]\w*", k) for k in key)):
            errors.append(f"Sample {s['sample_id']} key must be a nonempty list of variable names")
        elif len(key) != len(set(key)):
            errors.append(f"Sample {s['sample_id']} key contains duplicate variable names")
    nb_path = attempt / "stata.ipynb"
    nb = read(nb_path) if nb_path.exists() else {"cells": []}
    cells = {c.get("id"): c for c in nb["cells"] if c["cell_type"] == "code"}
    if len(cells) != sum(c["cell_type"] == "code" for c in nb["cells"]) or None in cells:
        errors.append("Code cells require unique IDs")
    referenced = set()
    for fit in fits:
        if fit.get("fidelity") not in ["source_supported", "best_effort"]:
            errors.append("Invalid fidelity value")
        if fit.get("blocked_reason"):
            if fit.get("cell_id") or fit.get("table_basename"):
                errors.append("Blocked fit must have null cell/table")
            continue
        cid = fit.get("cell_id")
        referenced.add(cid)
        if cid not in cells:
            errors.append(f"Fit references absent cell {cid}")
        if not fit.get("table_basename"):
            errors.append("Executable fit requires a table basename")
        else:
            inside(attempt, fit["table_basename"])
    for cid, cell in cells.items():
        errors.extend(f"{cid}: {e}" for e in code_issues(source(cell)))
        if not re.fullmatch(r"[A-Za-z0-9_-]{1,64}", cid or ""):
            errors.append("Invalid cell ID")
        text = source(cell)
        if "esttab" in text:
            for ext in FORMATS:
                if f".{ext}" not in text:
                    errors.append(f"{cid}: missing {ext} table export")
        if cid in referenced:
            for required in ["cells(b(star fmt(3)) p(par))", "starlevels(* 0.1 ** 0.05 *** 0.01)"]:
                if required not in re.sub(r"\s+", " ", text):
                    # Coefficient-distribution targets legitimately use estpost summaries.
                    if "estpost" not in text:
                        errors.append(f"{cid}: missing template regression export options")
    if any(not f.get("blocked_reason") for f in fits):
        for name in ["build.sas", "sas.ipynb", "design.md", "stata.ipynb"]:
            if not (attempt / name).exists():
                errors.append("Missing " + name)
        if not samples:
            errors.append("Executable fits require declared samples")
    if (attempt / "build.sas").exists():
        sas = (attempt / "build.sas").read_text()
        if re.search(r"\bobs\s*=\s*\d", sas, re.I):
            errors.append("Final SAS construction must not use an arbitrary OBS limit")
        errors.extend(sas_library_issues(sas, attempt))
        warnings.extend(sas_name_warnings(sas))
        warnings.extend(sas_diagnostic_warnings(sas))
        if sub.get("source_datasets") and work.get("catalog_path"):
            warnings.extend(sas_source_path_warnings(sas, sub["source_datasets"], read(work["catalog_path"])))
        if (attempt / "sas.ipynb").exists():
            codes = "".join(source(c) for c in read(attempt / "sas.ipynb")["cells"] if c["cell_type"] == "code")
            if codes != sas:
                errors.append("SAS notebook is not synchronized to build.sas")
    return {"valid": not errors, "errors": errors, "warnings": warnings,
            "paper_id": work["paper_id"], "attempt": work["attempt"],
            "scopes": len(fits), "blocked_scopes": sum(bool(f.get("blocked_reason")) for f in fits)}


def stata_failed(log):
    return bool(re.search(r"(?m)^\s*r\(\d+\);\s*$", log) or
                re.search(r"(?im)^\s*(?:warning:\s*)?convergence not (?:achieved|reached)\b", log) or
                "unrecognized command" in log)


def cell_log_valid(state):
    path = Path(state.get("log", ""))
    return path.is_file() and not stata_failed(path.read_text(errors="replace"))


def exec_stata(code, attempt, runtime, name, timeout):
    script = runtime / (name + ".do")
    # Stata creates the batch log in cwd, named after the do-file basename.
    script.write_text(code.rstrip() + "\nexit, clear\n")
    local_log = attempt / (name + ".log")
    started = time.monotonic()
    result = subprocess.run([STATA, "-b", "do", str(script)], cwd=attempt,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=timeout)
    if local_log.exists():
        shutil.move(local_log, runtime / (name + ".log"))
    logfile = runtime / (name + ".log")
    log = logfile.read_text(errors="replace") if logfile.exists() else result.stdout
    return {"ok": result.returncode == 0 and bool(log) and not stata_failed(log),
            "returncode": result.returncode, "seconds": round(time.monotonic() - started, 3),
            "log": str(logfile), "stdout": result.stdout[-2000:]}


def outputs_fingerprint(attempt, names):
    return {n: sha(inside(attempt, n)) for n in names if inside(attempt, n).is_file()}


def construction_signature(attempt, sub):
    work = read(Path(attempt) / "work_item.json")
    resources = {}
    if work.get("feasibility_path"):
        assessment = read(work["feasibility_path"])
        for requirement in assessment["requirements"]:
            for route in requirement["routes"]:
                if route["route_type"] == "local_sas":
                    p = Path(route["location"])
                    try:
                        stat = p.stat()
                        resources[str(p)] = {"size": stat.st_size, "mtime_ns": stat.st_mtime_ns}
                    except OSError:
                        resources[str(p)] = None
    if sub.get("source_datasets"):
        catalog = read(work["catalog_path"])
        paths = {d["dataset"]: d["path"] for d in catalog["datasets"]}
        for name in sub["source_datasets"]:
            if name not in paths:
                raise ValueError(f"Unlisted source dataset: {name}")
            p = Path(paths[name])
            try:
                stat = p.stat()
                resources[str(p)] = {"size": stat.st_size, "mtime_ns": stat.st_mtime_ns}
            except OSError:
                resources[str(p)] = None
    return digest([sha(Path(attempt) / "build.sas"), sub["samples"], resources])


def cache_valid(attempt, state, signature, outputs):
    return bool(state and state.get("ok") and state.get("signature") == signature
                and set(state.get("outputs", {})) == set(outputs)
                and state["outputs"] == outputs_fingerprint(attempt, outputs))


def reuse_data(attempt, predecessor):
    attempt, predecessor = Path(attempt).resolve(), Path(predecessor).resolve()
    sub, prior = read(attempt / "submission.json"), read(predecessor / "submission.json")
    if sha(attempt / "build.sas") != sha(predecessor / "build.sas") or sub["samples"] != prior["samples"]:
        raise ValueError("Construction or sample declarations changed; rebuild instead")
    state = read(predecessor / "runtime/latest.json")
    sas = state.get("sas")
    if not sas or not sas.get("ok"):
        raise ValueError("Predecessor has no successful SAS stage")
    for name, expected in sas["outputs"].items():
        source_path = inside(predecessor, name)
        if sha(source_path) != expected:
            raise ValueError("Predecessor dataset checksum changed")
        target = inside(attempt, name)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source_path, target)
    newstate = {"sas": sas | {"reused_from": str(predecessor), "reused_at": now()}, "cells": {}}
    write(attempt / "runtime/latest.json", newstate)
    return {"datasets_reused": len(sas["outputs"]), "from": str(predecessor)}


def run(attempt, stage="all", cell_id=None, timeout=21600):
    layout.writable_path(attempt,PROJECT)
    attempt = Path(attempt).resolve()
    checked = validate(attempt)
    if not checked["valid"]:
        raise ValueError("Validation failed: " + "; ".join(checked["errors"]))
    sub = read(attempt / "submission.json")
    for directory in ["tables", "figures", "runtime", ".work"]:
        (attempt / directory).mkdir(exist_ok=True)
    state_path = attempt / "runtime/latest.json"
    print(json.dumps({"event": "waiting_for_heavy_job_lock", "attempt": str(attempt)}), flush=True)
    with lock(RUNS / "heavy.lock"):
        state = read(state_path) if state_path.exists() else {"cells": {}}
        serial = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
        rt = attempt / "runtime" / serial
        rt.mkdir()
        print(json.dumps({"event": "running", "runtime": str(rt)}), flush=True)
        if stage in ("sas", "all") and sub["samples"]:
            signature = construction_signature(attempt, sub)
            names = [s[k] for s in sub["samples"] for k in ["sas_file", "dta_file"]]
            if not cache_valid(attempt, state.get("sas"), signature, names):
                for s in sub["samples"]:
                    for key in ["sas_file", "dta_file"]:
                        target = inside(attempt, s[key])
                        target.parent.mkdir(parents=True, exist_ok=True)
                        target.unlink(missing_ok=True)
                for d in ["work", "sasuser"]:
                    (rt / d).mkdir()
                logfile = rt / "build.log"
                shutil.copy2(attempt / "build.sas", rt / "build.sas")
                shutil.copy2(attempt / "design.md", rt / "design.md")
                write(rt / "submission_snapshot.json", sub)
                cmd = [SAS, "-nodms", "-noterminal", "-work", str(rt / "work"),
                       "-sasuser", str(rt / "sasuser"), "-rsasuser", "-memsize", "16G",
                       "-sortsize", "2G", "-sysin", str(rt / "build.sas"),
                       "-log", str(logfile), "-print", str(rt / "build.lst")]
                t = time.monotonic()
                result = subprocess.run(cmd, cwd=attempt, stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT, text=True, timeout=timeout)
                (rt / "launcher.txt").write_text(result.stdout)
                log = logfile.read_text(errors="replace") if logfile.exists() else result.stdout
                ok = (result.returncode == 0 and logfile.exists() and
                      not re.search(r"(?m)^\s*ERROR(?:\s+\d+-\d+)?:", log) and
                      all(inside(attempt, s["sas_file"]).exists() for s in sub["samples"]))
                sas_state = {"ok": ok, "signature": signature, "log": str(logfile),
                             "returncode": result.returncode, "seconds": round(time.monotonic()-t, 3)}
                if ok:
                    bootstrap = ["version 18", "set more off", f'adopath ++ "{RUNS / "ado"}"']
                    for c in sub.get("required_commands", []):
                        if not re.fullmatch(r"[A-Za-z_]\w*", c):
                            raise ValueError("Invalid command name")
                        bootstrap.append("which " + c)
                    for s in sub["samples"]:
                        if any(not re.fullmatch(r"[A-Za-z_]\w*", k) for k in s["key"]):
                            raise ValueError("Invalid sample key")
                        bootstrap.extend([f'import sas using "{s["sas_file"]}", clear',
                                          "assert _N > 0", "isid " + " ".join(s["key"]),
                                          f'save "{s["dta_file"]}", replace'])
                    boot = exec_stata("\n".join(bootstrap), attempt, rt, "handoff", timeout)
                    sas_state["handoff"] = boot
                    sas_state["ok"] = boot["ok"] and all(inside(attempt, n).exists() for n in names)
                sas_state["outputs"] = outputs_fingerprint(attempt, names)
                state["sas"] = sas_state
                state["cells"] = {}
                write(state_path, state)
                write(rt / "execution.json", state)
            if not state["sas"]["ok"]:
                return {"ok": False, "stage": "sas", "state": str(state_path), "details": state["sas"]}
        if stage in ("stata", "all"):
            dataset_names = [s[k] for s in sub["samples"] for k in ["sas_file", "dta_file"]]
            if sub["samples"] and not cache_valid(attempt, state.get("sas"), construction_signature(attempt, sub), dataset_names):
                raise ValueError("Analysis data/construction changed; run the SAS stage before Stata")
            cells = [c for c in read(attempt / "stata.ipynb")["cells"] if c["cell_type"] == "code"]
            if cell_id and not any(c["id"] == cell_id for c in cells):
                raise ValueError("Requested cell does not exist")
            for cell in cells:
                cid = cell["id"]
                if cell_id and cid != cell_id:
                    continue
                code = source(cell)
                dta_names = [s["dta_file"] for s in sub["samples"]]
                if not all(inside(attempt, n).exists() for n in dta_names):
                    raise ValueError("Missing analysis data; run SAS stage first")
                data_hashes = outputs_fingerprint(attempt, dta_names)
                executed_code = layout.executed_cell_source(attempt, cid, code, PROJECT)
                signature = digest([executed_code, data_hashes])
                names = sorted(set(re.findall(r'using\s+"([^"\n]+\.(?:md|rtf|csv|tex))"', code, re.I)))
                if not names:
                    raise ValueError(f"Cell {cid} needs literal table output paths")
                if (cache_valid(attempt, state["cells"].get(cid), signature, names)
                        and cell_log_valid(state["cells"][cid])):
                    continue
                for name in names:
                    target = inside(attempt, name)
                    target.parent.mkdir(parents=True, exist_ok=True)
                    target.unlink(missing_ok=True)
                result = exec_stata(code, attempt, rt, "cell_" + cid, timeout)
                result["signature"] = signature
                result["outputs"] = outputs_fingerprint(attempt, names)
                result["ok"] = result["ok"] and len(result["outputs"]) == len(names)
                state["cells"][cid] = result
                # Notebook output is normal console output, not an estimate sidecar.
                log = Path(result["log"]).read_text(errors="replace") if Path(result["log"]).exists() else ""
                cell["execution_count"] = 1
                cell["outputs"] = [{"output_type": "stream", "name": "stdout", "text": log.splitlines(keepends=True)}]
                nb = read(attempt / "stata.ipynb")
                nb["cells"] = [cell if c.get("id") == cid else c for c in nb["cells"]]
                write(attempt / "stata.ipynb", nb)
                write(state_path, state)
                write(rt / "execution.json", state)
                print(json.dumps({"event": "cell_finished", "cell": cid, "ok": result["ok"]}), flush=True)
        write(rt / "execution.json", state)
    return {"ok": all(v["ok"] for v in state.get("cells", {}).values()),
            "state": str(state_path), "cells": {k: v["ok"] for k, v in state.get("cells", {}).items()}}


def campaign_complete(campaign, issues):
    paper_ids = {paper["paper_id"] for paper in campaign["papers"]}
    return bool(paper_ids) and all(
        paper.get("accepted_attempt") is not None
        and not any(a.get("status") in {"assigned", "running"}
                    for a in paper.get("assignments", []))
        for paper in campaign["papers"]
    ) and not any(issue["paper_id"] in paper_ids and issue["status"] != "resolved"
                  for issue in issues)


def publish_attempt(attempt):
    """Publish one accepted package, retaining previous packages in history."""
    attempt=Path(attempt).resolve()
    if not layout.manifest(PROJECT):return attempt
    if not (attempt.is_relative_to(Path(layout.work_root('reproduction',PROJECT)).resolve())
            or attempt.is_relative_to(PAPERS.resolve())):
        return attempt
    work=read(attempt/'work_item.json')
    parent=PAPERS/work['paper_id'];parent.mkdir(parents=True,exist_ok=True)
    target=parent/attempt.name
    if attempt==target:return target
    updates={}
    for prior in parent.glob('attempt_*'):
        if prior==target:raise FileExistsError('Accepted destination already exists: '+str(target))
        archived=RUNS/'history'/work['paper_id']/(prior.name+'_'+str(time.time_ns()))
        archived.parent.mkdir(parents=True,exist_ok=True)
        shutil.move(prior,archived)
        updates[str(prior)]=str(archived)
    old=str(attempt)
    shutil.move(attempt,target)
    updates[old]=str(target)
    layout.refresh_relocations(updates,PROJECT)
    return target


def finish(attempt, accept=False):
    layout.writable_path(attempt,PROJECT)
    attempt = Path(attempt).resolve()
    checked = validate(attempt)
    if not checked["valid"]:
        raise ValueError("Validation failed: " + "; ".join(checked["errors"]))
    work, sub = read(attempt / "work_item.json"), read(attempt / "submission.json")
    state_path = attempt / "runtime/latest.json"
    state = read(state_path) if state_path.exists() else {"cells": {}}
    outcomes = []
    cells = {c["id"]: c for c in read(attempt / "stata.ipynb")["cells"] if c["cell_type"] == "code"} if (attempt / "stata.ipynb").exists() else {}
    data_hashes = outputs_fingerprint(attempt, [s["dta_file"] for s in sub["samples"]])
    dataset_names = [s[k] for s in sub["samples"] for k in ["sas_file", "dta_file"]]
    current_sas = cache_valid(attempt, state.get("sas"), construction_signature(attempt, sub), dataset_names) if sub["samples"] else False
    for fit in sub["fits"]:
        status = "blocked"
        detail = fit.get("blocked_reason")
        if not detail:
            cell = state["cells"].get(fit["cell_id"], {})
            output_paths = [fit["table_basename"] + "." + ext for ext in FORMATS]
            executed_code = layout.executed_cell_source(attempt, fit['cell_id'], source(cells[fit['cell_id']]), PROJECT)
            current_signature = digest([executed_code, data_hashes])
            ok = current_sas and cell.get("ok") and cell_log_valid(cell) and cell.get("signature") == current_signature and all(name in cell.get("outputs", {}) and
                 inside(attempt, name).is_file() and sha(inside(attempt, name)) == cell["outputs"][name]
                 for name in output_paths)
            status = "executed" if ok else "failed"
            detail = None if ok else "No current successful execution with all four table files"
        outcomes.append(fit | {"execution_status": status, "execution_detail": detail})
    n = sum(f["execution_status"] == "executed" for f in outcomes)
    result = {"paper_id": work["paper_id"], "attempt": work["attempt"], "finished_at": now(),
              "status": "executed" if n == len(outcomes) else "partial" if n else "blocked",
              "executed_scopes": n, "total_scopes": len(outcomes), "fits": outcomes,
              "limitations": sub["limitations"], "skill_sha256": work["skill_sha256"],
              "files": {name: sha(attempt / name) for name in ["build.sas", "sas.ipynb", "stata.ipynb",
                         "design.md", "submission.json", "review.md"] if (attempt / name).exists()}}
    if accept and work["attempt"] < 2:
        raise ValueError("Acceptance requires an independent review assignment")
    if accept and not (attempt / "review.md").exists():
        raise ValueError("Accepted review requires review.md")
    if accept and any(f["execution_status"] == "failed" for f in outcomes):
        raise ValueError("Acceptance requires a current execution or an explicit blocked reason for every fit")
    write(attempt / "outcome.json", result)
    if accept:
        attempt=publish_attempt(attempt)
    with lock(RUNS / "campaign.lock"):
        c = read(CAMPAIGN)
        p = next(p for p in c["papers"] if p["paper_id"] == work["paper_id"])
        a = p["assignments"][work["attempt"]-1]
        if accept:
            for previous in p['assignments']:
                previous['path']=str(Path(previous['path']).resolve())
            a['path']=str(attempt)
        a.update(status="complete", outcome=result["status"], executed_scopes=n,
                 total_scopes=len(outcomes), finished_at=now(), outcome_sha256=sha(attempt / "outcome.json"))
        if accept:
            p["accepted_attempt"] = work["attempt"]
            write(PAPERS / work["paper_id"] / "accepted.json", {"attempt": work["attempt"],
                 "path": str(attempt), "outcome_sha256": sha(attempt / "outcome.json")})
        issue_path = RUNS / "follow_up_issues.json"
        issues = read(issue_path).get("issues", []) if issue_path.exists() else []
        c["status"] = "complete" if campaign_complete(c, issues) else "active"
        write(CAMPAIGN, c)
    return {k: result[k] for k in ["paper_id", "attempt", "status", "executed_scopes", "total_scopes"]}


def summarize():
    issue_path = RUNS / "follow_up_issues.json"
    issues = read(issue_path).get("issues", []) if issue_path.exists() else []
    with lock(RUNS / "campaign.lock"):
        c = read(CAMPAIGN)
        status = "complete" if campaign_complete(c, issues) else "active"
        if (status != "complete" and any(p.get("paused") for p in c["papers"])
                and not any(i["status"] != "resolved" for i in issues)
                and all((p.get("paused") or p.get("accepted_attempt"))
                        and not any(a["status"] in ("assigned", "running") for a in p["assignments"])
                        for p in c["papers"])):
            status = "paused"
        if c.get("status") != status:
            c["status"] = status
            write(CAMPAIGN, c)
    open_issues = {i["paper_id"]: i["status"] for i in issues if i["status"] != "resolved"}
    rows = []
    for p in c["papers"]:
        completed = [a for a in p["assignments"] if a["status"] == "complete"]
        a = p["assignments"][p["accepted_attempt"]-1] if p["accepted_attempt"] else completed[-1] if completed else p["assignments"][-1] if p["assignments"] else {}
        active = [a["attempt"] for a in p["assignments"] if a["status"] in ["running", "assigned"]]
        rows.append({"paper_id": p["paper_id"], "title": p["title"], "journal": p["journal"],
            "assignments": len(p["assignments"]), "accepted_attempt": p["accepted_attempt"],
            "active_attempt": active[-1] if active else None,
            "status": "paused" if p.get("paused") else a.get("outcome", a.get("status", "pending")),
            "executed_scopes": a.get("executed_scopes", 0), "total_scopes": a.get("total_scopes", p.get("expected_scopes")),
            "path": a.get("path"), "follow_up": open_issues.get(p["paper_id"])})
    reports = Path(layout.active_path('reproduction_summary', PROJECT)) if (
        layout.manifest(PROJECT) and RUNS == Path(layout.work_root('reproduction', PROJECT))) else RUNS
    reports.mkdir(parents=True, exist_ok=True)
    path = reports / "summary.csv"
    with path.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
    summary = {"generated_at": now(), "campaign_status": status,
               "papers": len(rows), "assignments": sum(r["assignments"] for r in rows),
               "paused_papers": sum(r["status"] == "paused" for r in rows),
               "paused_scopes": sum(r["total_scopes"] or 0 for r in rows if r["status"] == "paused"),
               "accepted_papers": sum(r["accepted_attempt"] is not None for r in rows),
               "papers_with_closed_review": sum(r["accepted_attempt"] is not None
                   and r["follow_up"] is None and r["active_attempt"] is None for r in rows),
               "reviewed_papers_with_open_follow_up": sum(r["accepted_attempt"] is not None
                   and r["follow_up"] is not None for r in rows),
               "expected_scopes": sum(r["total_scopes"] or 0 for r in rows),
               "reviewed_executed_scopes": sum(r["executed_scopes"] for r in rows if r["accepted_attempt"] is not None),
                "papers_with_open_follow_up": len(open_issues),
                "follow_ups_awaiting_approval": sum(v == "awaiting_approval" for v in open_issues.values()),
               "executed_scopes": sum(r["executed_scopes"] for r in rows), "rows": rows}
    write(reports / "summary.json", summary)
    lines = ["# Reproduction progress", "", f"Updated {summary['generated_at']}", "",
             f"{summary['accepted_papers']} of {summary['papers']} papers reviewed; "
             f"{summary['assignments']} of {c['limit_total']} allowed assignments used. "
             f"Reviewed attempts have executed {summary['reviewed_executed_scopes']} of "
             f"{summary['expected_scopes']} assigned fit scopes.", "",
             f"Paused by the user: {summary['paused_papers']} papers "
             f"({summary['paused_scopes']} fit scopes).", "",
              f"{summary['papers_with_closed_review']} papers have a completed review with no active "
              f"assignment or open follow-up; {summary['reviewed_papers_with_open_follow_up']} "
              "reviewed papers have later findings still to resolve.", "",
             "Execution confirms that the specified code ran. It does not establish numerical "
             "agreement with the paper or historical data equivalence. Read each design and review "
             "for assumptions, comparisons, and unresolved differences.", "",
               f"Open follow-ups: {summary['papers_with_open_follow_up']}; "
              f"awaiting a per-paper budget extension: {summary['follow_ups_awaiting_approval']}. "
              "Earlier review does not close these later findings. "
              "See [audit](currency_audit.json) and [follow-up ledger](follow_up_issues.json).", "",
             "| Paper | Journal | Review | Executed fits | Outcome / state | Files |",
             "| --- | --- | --- | ---: | --- | --- |"]
    for row in rows:
        title = row['title'].replace('|', '\\|').replace('\n', ' ')
        links = []
        if row['path']:
            root = Path(row['path'])
            for name, label in [('design.md', 'design'), ('sas.ipynb', 'SAS'),
                                ('stata.ipynb', 'Stata'), ('review.md', 'review'),
                                ('outcome.json', 'outcome')]:
                if (root / name).exists():
                    target = os.path.relpath(root / name, reports)
                    links.append(f"[{label}]({target})")
        review = f"attempt {row['accepted_attempt']} reviewed" if row['accepted_attempt'] else ('paused' if row['status'] == 'paused' else 'pending')
        if row['active_attempt']:
            review += f"; attempt {row['active_attempt']} active"
        if row['follow_up']:
            review += f"; follow-up {row['follow_up']}"
        lines.append(f"| {title} ({row['paper_id']}) | {row['journal']} | {review} | "
                     f"{row['executed_scopes']}/{row['total_scopes']} | {row['status']} | "
                     f"{' · '.join(links)} |")
    (reports / "summary.md").write_text('\n'.join(lines) + '\n')
    return {k: v for k, v in summary.items() if k != "rows"}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    s = ap.add_subparsers(dest="command", required=True)
    s.add_parser("prepare"); s.add_parser("summarize")
    a = s.add_parser("assign"); a.add_argument("--paper", required=True); a.add_argument("--role", required=True, choices=["build", "review", "repair"])
    a = s.add_parser("register"); a.add_argument("--attempt", required=True); a.add_argument("--agent", required=True)
    for name in ["sync", "validate", "run", "finish", "reuse"]:
        a = s.add_parser(name); a.add_argument("--attempt", required=True)
        if name == "run":
            a.add_argument("--stage", choices=["sas", "stata", "all"], default="all")
            a.add_argument("--cell"); a.add_argument("--timeout", type=int, default=21600)
        if name == "finish": a.add_argument("--accept", action="store_true")
        if name == "reuse": a.add_argument("--from-attempt", required=True)
    args = ap.parse_args()
    try:
        if args.command == "prepare": result = prepare()
        elif args.command == "assign": result = assign(args.paper, args.role)
        elif args.command == "register": result = register(args.attempt, args.agent)
        elif args.command == "sync": result = sync(args.attempt)
        elif args.command == "validate": result = validate(args.attempt)
        elif args.command == "run": result = run(args.attempt, args.stage, args.cell, args.timeout)
        elif args.command == "reuse": result = reuse_data(args.attempt, args.from_attempt)
        elif args.command == "finish": result = finish(args.attempt, args.accept)
        elif args.command == "summarize": result = summarize()
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 1 if result.get("valid") is False or result.get("ok") is False else 0
    except Exception as exc:
        print(json.dumps({"error": type(exc).__name__, "message": str(exc)}), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
