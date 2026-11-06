"""Validate coordinator-supplied confirmation references before freezing a run."""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

# Resolve frozen artifact locations without rewriting research records.
_layout_root = Path(__file__).resolve().parents[3]
_layout = None
if (_layout_root / "project_layout.py").is_file():
    import sys as _layout_sys
    _layout_sys.path.insert(0, str(_layout_root))
    import project_layout as _layout
    Path = _layout.path_class(_layout_root)

KINDS = {"coverage_confirmations": ("coverage_confirmation", "verified"),
         "access_confirmations": ("access_confirmation", "blocked")}


def _nonempty(value):
    return isinstance(value, str) and bool(value.strip())


def _year(value):
    return isinstance(value, int) and not isinstance(value, bool) and 1800 <= value <= 2100


def _check_artifact(artifact, list_name):
    kind, verification = KINDS[list_name]
    if not isinstance(artifact, dict) or artifact.get("kind") != kind:
        raise ValueError(f"Expected a typed {kind}, not a probe or another artifact")
    if artifact.get("verification") != verification or not _nonempty(artifact.get("basis")):
        raise ValueError(f"{kind} needs verification={verification} and a reviewed basis")
    if list_name == "access_confirmations":
        if not _nonempty(artifact.get("requirement_id")):
            raise ValueError("Access confirmation needs its requirement_id")
        return
    c = artifact.get("coverage")
    if not _nonempty(artifact.get("location")) or not isinstance(c, dict):
        raise ValueError("Coverage confirmation needs a location and coverage object")
    if not (_year(c.get("begin")) and _year(c.get("end")) and c["begin"] <= c["end"]):
        raise ValueError("Verified coverage needs bounded, ordered integer years")
    if not _nonempty(c.get("population")) or not _nonempty(c.get("frequency")):
        raise ValueError("Coverage confirmation needs population and frequency")
    years = c.get("years")
    if (not isinstance(years, list) or any(not _year(y) for y in years)
            or len(set(years)) != len(years)
            or any(y < c["begin"] or y > c["end"] for y in years)):
        raise ValueError("Coverage years must be unique integers within the declared bounds")


def confirmation_refs(index_path, selected_ids, project, known_ids=None):
    """Return frozen path/hash lists; read only selected papers' proof artifacts.

    The index is a JSON object keyed by paper ID. Each value has optional
    coverage_confirmations and access_confirmations arrays of {path, sha256}.
    A wider known-inventory index can be reused for a selected pilot. This does
    not create confirmations, inspect data sources, or certify their substance.
    """
    project = Path(project).resolve()
    selected = list(selected_ids)
    known = set(selected if known_ids is None else known_ids)
    if not set(selected) <= known:
        raise ValueError("Selected paper IDs are absent from the known inventory")
    result = {pid: {kind: [] for kind in KINDS} for pid in selected}
    if index_path is None:
        return result
    path = (project / index_path).resolve()
    index = json.loads(path.read_text())
    if not isinstance(index, dict) or set(index) - known:
        raise ValueError("Confirmation index must be keyed by known paper IDs")
    for pid in selected:
        entry = index.get(pid, {})
        if not isinstance(entry, dict) or set(entry) - set(KINDS):
            raise ValueError(f"{pid}: unexpected confirmation lists")
        for list_name in KINDS:
            refs = entry.get(list_name, [])
            if not isinstance(refs, list):
                raise ValueError(f"{pid}/{list_name}: expected an array")
            seen = set()
            for ref in refs:
                if (not isinstance(ref, dict) or set(ref) != {"path", "sha256"}
                        or not _nonempty(ref.get("path"))
                        or not isinstance(ref.get("sha256"), str)
                        or not re.fullmatch(r"[0-9a-f]{64}", ref["sha256"])):
                    raise ValueError(f"{pid}/{list_name}: expected path and lowercase SHA-256")
                proof = (project / ref["path"]).resolve()
                if not proof.is_relative_to(project):
                    raise ValueError(f"{pid}/{list_name}: evidence artifacts must be in the project workspace")
                if proof in seen:
                    raise ValueError(f"{pid}/{list_name}: duplicate confirmation path")
                seen.add(proof)
                raw = proof.read_bytes()
                digest = hashlib.sha256(raw).hexdigest()
                if digest != ref["sha256"]:
                    raise ValueError(f"{pid}/{list_name}: confirmation checksum mismatch")
                _check_artifact(json.loads(raw), list_name)
                result[pid][list_name].append({"path": str(proof), "sha256": digest})
    return result
