"""Catalog lookup and bounded, read-only resource probes. No dataset downloads."""
from __future__ import annotations

import hashlib
import json
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

# Resolve frozen artifact locations without rewriting research records.
_layout_root = Path(__file__).resolve().parents[3]
_layout = None
if (_layout_root / "project_layout.py").is_file():
    import sys as _layout_sys
    _layout_sys.path.insert(0, str(_layout_root))
    import project_layout as _layout
    Path = _layout.path_class(_layout_root)


def sha256(path):
    h = hashlib.sha256()
    with Path(path).open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def now():
    return datetime.now(timezone.utc).isoformat()


def load(path):
    return json.loads(Path(path).read_text())


def save(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")


def decode_catalog(raw):
    try:
        return raw.decode("utf-8"), "utf-8"
    except UnicodeDecodeError:
        return raw.decode("cp1252"), "cp1252"


def parse_catalog(path):
    """Parse PROC CONTENTS fixed-width rows, including wrapped SAS names."""
    path = Path(path)
    text, encoding = decode_catalog(path.read_bytes())
    lines = text.splitlines()
    starts = []
    for i, line in enumerate(lines):
        match = re.search(r"Data Set Name\s+([A-Za-z0-9_]+\.[A-Za-z0-9_]+)", line)
        if match:
            starts.append((i, match[1].upper()))
    datasets = []
    for ix, (start, name) in enumerate(starts):
        end = starts[ix + 1][0] if ix + 1 < len(starts) else len(lines)
        block = "\n".join(lines[start:end])
        filename = re.search(r"^\s*Filename\s+(\S+\.sas7bdat)\s*$", block, re.M)
        nvars = re.search(r"\bVariables\s+(\d+)", block)
        nobs = re.search(r"\bObservations\s+(\d+)", lines[start])
        label = re.search(r"^\s*Label\s+(.*?)\s*$", "\n".join(lines[start:start + 12]), re.M)
        fields, positions, current = {}, None, None
        for lineno in range(start, end):
            line = lines[lineno]
            if re.search(r"Alphabetic List of Indexes|Sort Information|Alphabetic List of Integrity", line):
                positions, current = None, None
            header = re.search(r"\bVariable\s+Type\s+Len\b", line)
            if header and "#" in line[:header.start()]:
                positions = {
                    key: (re.search(r"\b" + key + r"\b", line).start()
                          if re.search(r"\b" + key + r"\b", line) else None)
                    for key in ("Variable", "Type", "Len", "Format", "Informat", "Label")
                }
                continue
            if positions is None:
                continue
            row = re.match(r"^\s*(\d+)\s+(\S+)\s+(Num|Char)\s+(\d+)\b", line)
            if row:
                ordinal = int(row[1])
                if ordinal in fields:
                    raise ValueError(f"{name}: repeated variable ordinal {ordinal}")
                label_start = positions["Label"]
                field = {
                    "ordinal": ordinal, "name": row[2], "type": row[3],
                    "length": int(row[4]),
                    "label": line[label_start:].strip() if label_start is not None else "",
                    "line_begin": lineno + 1, "line_end": lineno + 1,
                }
                for key in ("Format", "Informat"):
                    pos = positions[key]
                    later = [x for x in positions.values() if x is not None and pos is not None and x > pos]
                    field[key.lower()] = line[pos:min(later) if later else None].strip() if pos is not None else ""
                fields[ordinal], current = field, field
                continue
            if current is None:
                continue
            vpos, tpos, lpos = positions["Variable"], positions["Type"], positions["Label"]
            suffix = line[vpos:tpos].strip()
            # PROC CONTENTS wraps a long name inside its fixed-width name column.
            name_cont = (not line[:vpos].strip()
                         and re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", suffix)
                         and not line[tpos:lpos].strip())
            label_cont = (lpos is not None and not line[:lpos].strip()
                          and bool(line[lpos:].strip()))
            if name_cont:
                current["name"] += suffix
            if (name_cont or label_cont) and lpos is not None and line[lpos:].strip():
                current["label"] += " " + line[lpos:].strip()
            if name_cont or label_cont:
                current["line_end"] = lineno + 1
        declared = int(nvars[1]) if nvars else None
        names = [v["name"].casefold() for v in fields.values()]
        if declared is None or set(fields) != set(range(1, declared + 1)) or len(set(names)) != declared:
            raise ValueError(f"{name}: parsed {len(fields)} ordinals/{len(set(names))} unique names, expected {declared}")
        if not filename:
            raise ValueError(f"{name}: no physical SAS filename")
        datasets.append({
            "dataset": name, "libref": name.split(".")[0], "path": filename[1],
            "label": label[1] if label else "",
            "catalog_observations": int(nobs[1]) if nobs else None,
            "declared_variables": declared, "line_begin": start + 1, "line_end": end,
            "variables": sorted(fields.values(), key=lambda v: v["ordinal"]),
        })
    if len({d["dataset"] for d in datasets}) != len(datasets):
        raise ValueError("Duplicate qualified dataset names")
    return {
        "catalog_path": str(path.resolve()), "catalog_sha256": sha256(path),
        "encoding": encoding, "datasets": datasets,
        "report_libraries": sorted(set(re.findall(r"METADATA REPORT FOR LIBRARY:\s+(\w+)", text))),
    }


def build_catalog(common, aliases_path):
    common = Path(common).resolve()
    result = parse_catalog(common / "data_description.txt")
    readme = (common / "README.md").read_text()
    result.update({
        "schema_version": "1.0", "generated_at": now(), "common_root": str(common),
        "common_readme_sha256": sha256(common / "README.md"),
        "aliases_sha256": sha256(aliases_path), "sources": load(aliases_path)["sources"],
        "resources": [],
        "coverage_warning": "Snapshot metadata, not verified access, license entitlement, or historical field coverage.",
    })
    documented = [
        ("sec_raw", "/storage/share/exhibits/downloads", "SEC EDGAR raw filings"),
        ("sec_parsed", "/storage/share/exhibits/exhibits", "SEC EDGAR parsed filings"),
        ("lm10x", "/storage/share/lm10x", "Loughran-McDonald cleaned 10-X"),
        ("ndacan", "/storage/share/ndacan", "NDACAN restricted data"),
    ]
    for resource_id, path, name in documented:
        if path in readme:
            result["resources"].append({"resource_id": resource_id, "kind": "local_files",
                                        "path": path, "name": name})
    if "192.168.140.1" in readme:
        for database in ("wrds", "data_store_api"):
            result["resources"].append({
                "resource_id": "postgres_" + database, "kind": "local_postgres",
                "host": "192.168.140.1", "port": 5432, "user": "postgres", "database": database,
                "name": "Capital IQ transcripts" if database == "wrds" else "USASpending June 2025",
            })
    bypath = {}
    for dataset in result["datasets"]:
        bypath.setdefault(dataset["path"], []).append(dataset["dataset"])
    result["physical_files"] = [{"path": p, "datasets": names} for p, names in sorted(bypath.items())]
    result["counts"] = {"datasets": len(result["datasets"]), "physical_files": len(bypath),
                        "research_libraries": len(result["report_libraries"]),
                        "qualified_librefs": len({d["libref"] for d in result["datasets"]})}
    return result


def lookup(catalog, query, limit=10):
    q = query.casefold().strip()
    librefs = set()
    for source in catalog["sources"]:
        if q in [s.casefold() for s in [source["name"]] + source["aliases"]]:
            librefs.update(source["librefs"])
    hits = []
    for d in catalog["datasets"]:
        direct = q in d["dataset"].casefold()
        field_hits = [v for v in d["variables"] if q in (v["name"] + " " + v["label"]).casefold()]
        score = (100 if q == d["dataset"].casefold() else 30 if direct else 0)
        score += 15 if d["libref"] in librefs else 0
        score += 5 if q in d["label"].casefold() else 0
        score += min(len(field_hits), 5)
        if score:
            hits.append((score, {
                k: d[k] for k in ("dataset", "path", "label", "catalog_observations", "declared_variables", "line_begin")
            } | {"field_matches": field_hits[:20]}))
    hits.sort(key=lambda item: (-item[0], item[1]["dataset"]))
    return [h[1] for h in hits[:limit]]


def _sas_probe(catalog, request):
    dataset = next((d for d in catalog["datasets"] if d["dataset"] == request["dataset"].upper()), None)
    if dataset is None:
        raise ValueError("Dataset not in catalog")
    fields = request.get("fields", [])
    known = {v["name"].casefold(): v["name"] for v in dataset["variables"]}
    if any(f.casefold() not in known for f in fields):
        raise ValueError("Requested field absent from catalog; use lookup first")
    fields = [known[f.casefold()] for f in fields] or [v["name"] for v in dataset["variables"][:10]]
    path = Path(dataset["path"])
    if not path.resolve().is_relative_to(Path("/storage/sas/base")):
        raise ValueError("Only catalog-listed files under the approved /storage/sas/base root may be probed")
    info = path.stat()
    # metadataonly=True can traverse a huge file; row_limit stops after a bounded slice.
    import pyreadstat
    import pandas as pd
    # This function already runs in the probe's sole bounded child. Avoid an
    # inner reader process that could outlive its parent when the deadline fires.
    data, meta = pyreadstat.read_sas7bdat(
        str(path), usecols=fields, row_limit=request.get("row_limit", 1),
        row_offset=request.get("row_offset", 0), disable_datetime_conversion=True)
    ranges = {}
    for column in request.get("date_fields", []):
        if column in data.columns:
            values = pd.to_numeric(data[column], errors="coerce").dropna()
            if len(values):
                ranges[column] = {"sample_min": float(values.min()), "sample_max": float(values.max()),
                                  "format": meta.original_variable_types.get(column)}
    return {
        "resource": dataset["dataset"], "location": str(path), "size_bytes": info.st_size,
        "mtime_ns": info.st_mtime_ns, "catalog_observations": dataset["catalog_observations"],
        "columns": list(data.columns), "rows_read": len(data),
        "nonmissing_counts": {c: int(data[c].notna().sum()) for c in data.columns},
        "sample_ranges": ranges, "readable": True, "coverage_verified": False,
        "coverage_note": "A bounded slice cannot establish required historical/population coverage. rows_read is not the dataset total.",
    }


def _pg_probe(catalog, request):
    import psycopg
    from psycopg import sql
    resource = next((r for r in catalog["resources"]
                     if r.get("resource_id") == "postgres_" + request["database"]), None)
    if resource is None:
        raise ValueError("Database not documented in common")
    params = {k: resource[k] for k in ("host", "port", "user")}
    with psycopg.connect(**params, dbname=resource["database"], connect_timeout=3,
                         options="-c default_transaction_read_only=on -c statement_timeout=5000") as conn:
        with conn.cursor() as cur:
            cur.execute("show transaction_read_only")
            if cur.fetchone()[0] != "on":
                raise RuntimeError("Read-only transaction not enforced")
            if "table" not in request:
                cur.execute("select table_schema,table_name from information_schema.tables "
                            "where table_schema not in ('pg_catalog','information_schema') "
                            "order by 1,2 limit %s", (request.get("row_limit", 100),))
                return {"resource": resource["resource_id"], "location": resource["database"],
                        "tables": cur.fetchall(), "coverage_verified": False}
            schema, table = request.get("schema", "public"), request["table"]
            cur.execute("select column_name,data_type from information_schema.columns "
                        "where table_schema=%s and table_name=%s order by ordinal_position",
                        (schema, table))
            columns = dict(cur.fetchall())
            if not columns:
                raise ValueError("Table unavailable in information_schema")
            fields = request.get("fields", []) or list(columns)[:10]
            if any(f not in columns for f in fields):
                raise ValueError("Unknown PostgreSQL field")
            conditions, values = [], []
            operators = {"eq": "=", "ge": ">=", "le": "<="}
            for f in request.get("filters", []):
                if f["field"] not in columns or f["op"] not in operators:
                    raise ValueError("Invalid bounded filter")
                conditions.append(sql.SQL("{} {} %s").format(sql.Identifier(f["field"]), sql.SQL(operators[f["op"]])))
                values.append(f["value"])
            query = sql.SQL("select {} from {}.{}").format(
                sql.SQL(",").join(map(sql.Identifier, fields)), sql.Identifier(schema), sql.Identifier(table))
            if conditions:
                query += sql.SQL(" where ") + sql.SQL(" and ").join(conditions)
            query += sql.SQL(" limit %s")
            cur.execute(query, values + [request.get("row_limit", 1)])
            rows = cur.fetchall()
            return {
                "resource": resource["resource_id"] + "." + schema + "." + table,
                "location": resource["database"] + "." + schema + "." + table,
                "columns": fields, "column_types": {f: columns[f] for f in fields},
                "rows_read": len(rows),
                "readable": True,
                "nonmissing_counts": {f: sum(row[i] is not None for row in rows) for i, f in enumerate(fields)},
                "coverage_verified": False,
                "coverage_note": "LIMIT bounds returned rows, not coverage. Query statement timeout enforced.",
            }


def _file_probe(catalog, request):
    resource = next((r for r in catalog["resources"] if r["resource_id"] == request["resource_id"]), None)
    if resource is None or resource["kind"] != "local_files":
        raise ValueError("Unknown file resource")
    if resource["resource_id"] == "ndacan":
        raise ValueError("NDACAN is inventoried, but not within this campaign's approved external checks")
    base = Path(resource["path"])
    relative = Path(request.get("relative_path", "."))
    if relative.is_absolute() or ".." in relative.parts:
        raise ValueError("Use an exact relative path within the documented resource; no traversal")
    path = base / relative
    resolved_base, resolved_path = base.resolve(), path.resolve()
    if not resolved_path.is_relative_to(resolved_base):
        raise ValueError("Symlink escapes documented resource")
    st = path.stat()
    readable, prefix_sha256 = False, None
    if path.is_file():
        with path.open("rb") as source:
            prefix_sha256 = hashlib.sha256(source.read(256)).hexdigest()
        readable = True
    return {"resource": resource["resource_id"], "location": str(path),
            "is_directory": path.is_dir(), "size_bytes": st.st_size, "mtime_ns": st.st_mtime_ns,
            "readable": readable, "prefix_sha256": prefix_sha256,
            "coverage_verified": False,
            "coverage_note": "Existence only; no directory listing or recursive discovery was performed."}


def probe(catalog, request):
    for key, default, maximum in (("row_limit", 1, 1000), ("row_offset", 0, 1000),
                                   ("timeout_seconds", 15, 15)):
        value = request.get(key, default)
        if isinstance(value, bool) or not isinstance(value, int) or value < (0 if key == "row_offset" else 1) or value > maximum:
            raise ValueError(f"{key} exceeds bounded probe limits")
    dispatch = {"sas": _sas_probe, "postgres": _pg_probe, "files": _file_probe}
    if request.get("kind") not in dispatch:
        raise ValueError("Probe kind must be sas, postgres, or files")
    result = {"schema_version": "1.0", "checked_at": now(), "request": request,
              "catalog_sha256": catalog["catalog_sha256"], "status": "unverified"}
    try:
        # Also bound connection, stat and metadata work outside database-level timeouts.
        code = """import json,sys
sys.path.insert(0,sys.argv[1])
from resources import _sas_probe,_pg_probe,_file_probe
payload=json.load(sys.stdin)
print(json.dumps({'sas':_sas_probe,'postgres':_pg_probe,'files':_file_probe}[payload['request']['kind']](payload['catalog'],payload['request'])))
"""
        child = subprocess.run([sys.executable, "-c", code, str(Path(__file__).parent.resolve())],
                               input=json.dumps({"catalog": catalog, "request": request}),
                               capture_output=True, text=True, timeout=request.get("timeout_seconds", 15))
        if child.returncode:
            raise RuntimeError(child.stderr[-700:])
        result.update(status="ok", result=json.loads(child.stdout))
    except Exception as exc:
        result["error"] = {"type": type(exc).__name__, "detail": str(exc)[:800]}
        result["interpretation"] = "Probe did not verify access. This is not evidence of missing data or an absent license."
    return result
