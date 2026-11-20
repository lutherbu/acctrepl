#!/usr/bin/env python3
"""Import and verify JAR issue volumes 51–58 (2013–2020) from a download collection."""
from __future__ import annotations

import argparse
from collections import defaultdict
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import tempfile

PROJECT = Path(__file__).resolve().parents[1]
VOLUME_DIRS = {f"Volume {number}" for number in range(51, 59)}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def metadata(path: Path) -> tuple[int, int, int, int, int]:
    st = path.stat()
    return st.st_size, st.st_mtime_ns, st.st_ctime_ns, st.st_dev, st.st_ino


def relative_path(value: str | Path) -> Path:
    raw = str(value).replace("\\", "/")
    parts = PurePosixPath(raw).parts
    if not parts or raw.startswith("/") or re.match(r"^[A-Za-z]:", raw) or ".." in parts:
        raise ValueError(f"Unsafe relative path: {value}")
    return Path(*parts)


def destination_relative(value: str | Path) -> Path:
    rel = relative_path(value)
    if rel.parts[0] not in VOLUME_DIRS:
        raise ValueError(f"Outside the selected JAR issue volumes: {rel}")
    return Path("JAR-" + rel.parts[0], *rel.parts[1:])


def plain_target(root: Path, relative: Path) -> Path:
    path = root
    for part in relative.parts:
        path = path / part
        if path.is_symlink():
            raise ValueError(f"Destination contains a symlink: {path}")
    return path


def copy_verified(source: Path, target: Path, verify_only: bool = False) -> tuple[str, bool]:
    """Publish an independently copied inode without replacing an existing destination."""
    before = metadata(source)
    expected = sha256(source)
    if metadata(source) != before:
        raise RuntimeError(f"Source changed while hashing: {source}")
    copied = False
    if target.exists():
        if not target.is_file() or target.is_symlink() or sha256(target) != expected:
            raise FileExistsError(f"Destination contents conflict; nothing overwritten: {target}")
    elif verify_only:
        raise FileNotFoundError(f"Copied file is missing: {target}")
    else:
        target.parent.mkdir(parents=True, exist_ok=True)
        descriptor, temporary = tempfile.mkstemp(prefix=".jar-import-", suffix=".copying", dir=target.parent)
        os.close(descriptor)
        temp = Path(temporary)
        try:
            shutil.copy2(source, temp)
            if sha256(temp) != expected:
                raise RuntimeError(f"Copy checksum mismatch: {source}")
            # The temporary file is a real copy, never a link to the source. Publishing
            # its inode exclusively avoids overwriting a concurrently created target.
            # Removing the temporary name leaves a normal file with one link.
            os.link(temp, target)
            copied = True
        finally:
            temp.unlink(missing_ok=True)
    if sha256(target) != expected or metadata(source) != before or sha256(source) != expected:
        raise RuntimeError(f"Copy/source verification failed: {source}")
    if source.stat().st_dev == target.stat().st_dev and source.stat().st_ino == target.stat().st_ino:
        raise RuntimeError(f"Destination is not an independent copy: {target}")
    return expected, copied


def package_index(source: Path, audit_manifest: Path) -> list[dict]:
    raw = json.loads(audit_manifest.read_text(encoding="utf-8"))
    units = [u for u in raw["units"] if u.get("collection") == "jar"
             and relative_path(u["paper"]).parts[0] in VOLUME_DIRS]
    if not units:
        raise ValueError("The audit manifest has no JAR package units in volumes 51–58.")
    by_doi: dict[str, set[str]] = defaultdict(set)
    titles: dict[str, set[str]] = defaultdict(set)
    for unit in units:
        by_doi[unit.get("doi", "")].add(unit["paper"])
        titles[unit.get("doi", "")].add(unit.get("title", ""))
    result = []
    for unit in units:
        original = relative_path(Path(unit["path"]).relative_to(source))
        directory = relative_path(unit["paper"])
        if not original.is_relative_to(directory):
            raise ValueError(f"Audit unit is outside its paper directory: {original}")
        if not (source / original).exists():
            raise FileNotFoundError(f"Audit unit no longer exists: {original}")
        material_files = [destination_relative(p.relative_to(source)).as_posix()
                          for p in sorted((source / directory).iterdir())
                          if p.is_file() and not p.is_symlink()
                          and p.suffix.lower() not in {".zip", ".rar", ".7z"}]
        notes = []
        doi = unit.get("doi", "")
        if doi and len(by_doi[doi]) > 1:
            notes.append("The same source DOI is associated with multiple paper folders; no folders were merged.")
            if len(titles[doi]) > 1:
                notes.append("Source titles conflict for this DOI; original publication metadata is retained for review.")
        if len(list((source / directory).glob("*.zip"))) > 1:
            notes.append("Multiple original archive variants share this paper folder; each retains its own package ID.")
        result.append({
            "package_id": unit["id"], "original_relative_path": original.as_posix(),
            "package_path": destination_relative(original).as_posix(),
            "directory_path": destination_relative(directory).as_posix(),
            "archive": bool(unit["archive"]), "doi": doi,
            "title": unit.get("title", ""), "material_files": material_files,
            "identity_notes": notes,
        })
    if len({p["package_id"] for p in result}) != len(result):
        raise ValueError("Duplicate source package IDs")
    return result


def selected_files(source: Path) -> list[Path]:
    sources = []
    for folder, directories, names in os.walk(source, followlinks=False):
        for name in directories + names:
            if (Path(folder) / name).is_symlink():
                raise ValueError(f"Source contains a symlink: {Path(folder) / name}")
        if Path(folder) == source:
            directories[:] = [name for name in directories if name in VOLUME_DIRS]
            # Top-level download logs describe the full acquisition, including later volumes.
            continue
        sources.extend(Path(folder) / name for name in names)
    return sorted(sources)


def import_packages(source: Path, destination: Path, audit_manifest: Path, verify_only: bool = False) -> dict:
    source, destination, audit_manifest = source.resolve(), destination.resolve(), audit_manifest.resolve()
    if not source.is_dir() or destination == source or destination.is_relative_to(source) or source.is_relative_to(destination):
        raise ValueError("Source and destination must be separate directory trees")
    sources = selected_files(source)
    packages = package_index(source, audit_manifest)
    initial = {p.relative_to(source).as_posix(): metadata(p) for p in sources}
    files, copied = [], 0
    if not verify_only:
        destination.mkdir(parents=True, exist_ok=True)
        marker = plain_target(destination, Path(".gitkeep"))
        if marker.exists() and (not marker.is_file() or marker.stat().st_size):
            raise ValueError("The package .gitkeep placeholder must be an empty regular file")
        marker.touch(exist_ok=True)
    for index, path in enumerate(sources, 1):
        original = path.relative_to(source)
        rel = destination_relative(original)
        checksum, was_copied = copy_verified(path, plain_target(destination, rel), verify_only)
        copied += int(was_copied)
        files.append({"source_path": original.as_posix(), "destination_path": rel.as_posix(),
                      "bytes": initial[original.as_posix()][0], "sha256": checksum})
        if index % 100 == 0:
            print(f"Verified {index}/{len(sources)} files", flush=True)
    final = {p.relative_to(source).as_posix(): metadata(p) for p in selected_files(source)}
    if final != initial:
        raise RuntimeError("Source file inventory or metadata changed during import")
    report = {
        "schema_version": "1.0", "completed_at": datetime.now(timezone.utc).isoformat(),
        "source_root": str(source), "destination_root": str(destination),
        "files": files, "packages": packages,
        "verification": {"status": "verified", "files": len(files), "bytes": sum(f["bytes"] for f in files),
                         "copied": copied, "skipped_identical": len(files) - copied,
                         "sha256_verified": len(files), "source_metadata_unchanged": True,
                         "source_content_unchanged": True, "package_units": len(packages),
                         "paper_directories": len({p["directory_path"] for p in packages}),
                         "unique_dois": len({p["doi"] for p in packages if p["doi"]}),
                         "identity_review_package_ids": [p["package_id"] for p in packages if p["identity_notes"]]},
    }
    if not verify_only:
        manifest = plain_target(destination, Path("_provenance/JAR/import_manifest.json"))
        manifest.parent.mkdir(parents=True, exist_ok=True)
        temporary = manifest.with_suffix(".json.copying")
        with temporary.open("x", encoding="utf-8") as stream:
            json.dump(report, stream, ensure_ascii=False, indent=2)
            stream.write("\n")
        temporary.replace(manifest)
    return report


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--destination", type=Path, default=PROJECT / "papers/packages")
    parser.add_argument("--audit-manifest", type=Path, required=True)
    parser.add_argument("--verify-only", action="store_true", help="Verify existing copies without changing files.")
    args = parser.parse_args()
    result = import_packages(args.source, args.destination, args.audit_manifest, args.verify_only)
    print(json.dumps(result["verification"], indent=2))


if __name__ == "__main__":
    main()
