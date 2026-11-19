#!/usr/bin/env python3
"""Index the per-paper publications in this checkout. Uses only the Python standard library."""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import tempfile


PROJECT = Path(__file__).resolve().parents[1]
# A record filename is its paper ID. A package directory is its package or paper ID.
WORKFLOWS = {
    'samples': ('records', None, 'paper_id'),
    'models': ('records', None, 'paper_id'),
    'feasibility_reproduction': ('records', None, 'paper_id'),
    'feasibility_execution': ('packages', 'assessment.json', 'package_id'),
    'executions': ('packages', 'report.json', 'package_id'),
    'reproductions': ('packages', 'accepted.json', 'paper_id'),
    'replications': ('packages', 'report.json', 'paper_id'),
}
ID = re.compile(r'[A-Za-z0-9][A-Za-z0-9_.-]*\Z')


def sha(path):
    with path.open('rb') as source:
        return hashlib.file_digest(source, 'sha256').hexdigest()


def encoded(value):
    return (json.dumps(value, indent=2, ensure_ascii=False, allow_nan=False) + '\n').encode()


def plain(root, path):
    if path.resolve() != path or not path.is_relative_to(root):
        raise ValueError(f'Expected a project-local path without symlinks: {path}')
    return path


def payload(path):
    try:
        raw = path.read_bytes()
        record = json.loads(raw)
        if not isinstance(record, dict):
            raise ValueError('expected a JSON object')
        return record, hashlib.sha256(raw).hexdigest()
    except (ValueError, OSError) as error:
        raise ValueError(f'{path}: {error}') from error


def index_workflow(project, name):
    project = Path(project).resolve()
    subdir, filename, identity = WORKFLOWS[name]
    source = plain(project, project / 'output' / name / subdir)
    entries = []
    for child in sorted(source.iterdir(), key=lambda path: path.name):
        if child.name.startswith('.'):
            continue
        plain(project, child)
        if filename is None:
            if child.suffix != '.json' or not child.is_file():
                raise ValueError(f'Unexpected entry in records: {child}')
            pid, primary = child.stem, child
        else:
            if not child.is_dir():
                raise ValueError(f'Expected a package directory: {child}')
            pid, primary = child.name, plain(project, child / filename)
        if not ID.fullmatch(pid):
            raise ValueError(f'Invalid paper/package ID: {pid}')
        record, digest = payload(primary)
        if name == 'reproductions':
            receipt = record
            attempt = receipt.get('attempt')
            if type(attempt) is not int or attempt < 1:
                raise ValueError(f'Invalid accepted attempt: {primary}')
            target = plain(project, child / f'attempt_{attempt:02d}')
            if receipt.get('path') != target.relative_to(project).as_posix():
                raise ValueError(f'Accepted attempt directory mismatch: {primary}')
            primary = plain(project, target / 'outcome.json')
            record, digest = payload(primary)
            if digest != receipt.get('outcome_sha256') or record.get('attempt') != attempt:
                raise ValueError(f'Accepted outcome does not match receipt: {primary}')
        if record.get(identity) != pid:
            raise ValueError(f'{identity} does not match {pid}: {primary}')
        entries.append({'id': pid, 'path': primary.relative_to(project).as_posix(), 'sha256': digest})
    return {'workflow': name, 'records': entries}


def scan(project):
    project = Path(project).resolve()
    indexes = {}
    workflows = {}
    for name in WORKFLOWS:
        folder = plain(project, project / 'output' / name)
        if not folder.exists():
            continue
        index = index_workflow(project, name)
        path = (folder / 'index.json').relative_to(project).as_posix()
        indexes[path] = index
        workflows[name] = {'directory': folder.relative_to(project).as_posix(),
                           'index': path, 'count': len(index['records'])}
    indexes['output/manifest.json'] = {'workflows': workflows}
    return indexes


def rebuild(project=PROJECT, *, check=False):
    project = Path(project).resolve()
    output = plain(project, project / 'output')
    # Lock the existing directory so a read-only check creates no lock or cache file.
    lock = os.open(output, os.O_RDONLY)
    try:
        fcntl.flock(lock, fcntl.LOCK_SH if check else fcntl.LOCK_EX)
        documents = scan(project)
        pending = {}
        for relative, value in documents.items():
            target = plain(project, project / relative)
            data = encoded(value)
            if not target.is_file() or target.read_bytes() != data:
                pending[target] = data
        if pending and check:
            raise ValueError('Missing or stale: ' + ', '.join(str(p.relative_to(project)) for p in pending))
        if pending:
            with tempfile.TemporaryDirectory(dir=output, prefix='.indexes-') as temporary:
                staged = []
                for number, (target, data) in enumerate(pending.items()):
                    draft = Path(temporary) / str(number)
                    draft.write_bytes(data)
                    staged.append((draft, target))
                for draft, target in staged:
                    os.replace(draft, target)
        return documents
    finally:
        os.close(lock)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project-root', type=Path, default=PROJECT)
    parser.add_argument('--check', action='store_true', help='Compare with a fresh scan without writing.')
    args = parser.parse_args()
    try:
        manifest = rebuild(args.project_root, check=args.check)['output/manifest.json']
    except (OSError, ValueError) as error:
        parser.exit(1, f'{error}\n')
    for name, item in manifest['workflows'].items():
        print(f"{name}: {item['count']}")
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
