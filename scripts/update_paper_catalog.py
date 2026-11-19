#!/usr/bin/env python3
"""Relink existing catalog rows to current per-paper results."""
from __future__ import annotations

import argparse
from collections import defaultdict
import copy
import csv
import io
import json
import os
from pathlib import Path, PurePosixPath
import re
import sys
import tempfile

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT))
from scripts.rebuild_indexes import scan, WORKFLOWS
CORE_FIELDS = (
    'journal', 'journal_name', 'rank_in_journal', 'rank_all_works', 'title',
    'authors', 'publication_year', 'year_basis', 'openalex_publication_year',
    'cited_by_count', 'fwci', 'doi', 'doi_url', 'openalex_id', 'paper_id',
    'pdf_path', 'reading_json', 'pdf_sha256', 'reading_json_sha256',
    'total_pdf_pages', 'cached_pages', 'omitted_blank_pages',
    'omitted_nonblank_pages', 'needs_text_review', 'original_pdf_filename',
    'selection_pdf_version_differs',
)
ADDED_FIELDS = ('cohorts', 'jar_packages')
RESULT_FIELDS = ('sample_path', 'model_path', 'feasibility_reproduction_path',
                 'feasibility_execution_path', 'reproduction_path', 'execution_path', 'replication_path')
PAPER_RESULT_FIELDS = {'sample_path', 'model_path', 'feasibility_reproduction_path', 'reproduction_path', 'replication_path'}
FIELDS = CORE_FIELDS + ADDED_FIELDS + RESULT_FIELDS
SAFE_ID = re.compile(r'[A-Za-z0-9_-]+\Z')


def read_jsonl(path):
    """Iterate physical JSONL lines: Unicode U+2028 can occur inside abstracts."""
    with Path(path).open(encoding='utf-8-sig') as stream:
        return [json.loads(line) for line in stream if line.strip()]


def _result_path(project, value):
    """Admit only project-local files under recognized result folders."""
    raw = str(value).replace('\\', '/')
    relative = PurePosixPath(raw)
    folders = set(WORKFLOWS)
    if (relative.is_absolute() or '..' in relative.parts or len(relative.parts) < 3
            or relative.parts[0] != 'output' or relative.parts[1] not in folders):
        raise ValueError('Result paths must be project-relative files in a recognized output folder')
    root = Path(project).resolve()
    candidate = root / relative.as_posix()
    if any(path.is_symlink() for path in (candidate, *candidate.parents)) or not candidate.resolve().is_relative_to(root):
        raise ValueError('Result links cannot escape through symbolic links')
    return relative.as_posix(), candidate


def _work_id(value):
    if not isinstance(value, str):
        return None
    match = re.fullmatch(r'(?:https://openalex\.org/)?(W\d+)', value)
    return match.group(1) if match else None


def link_results(records, inventory, project):
    """Reset derived result fields and match exact IDs; never use a DOI join.

    Each inventory field is a list of {paper_id|package_id, path, optional
    openalex_id}. Planned sample derivatives may set `planned=True`; all other
    populated paths must already be actual files. Ambiguous matches remain null.
    """
    output = copy.deepcopy(records)
    counts, ambiguities = {}, []
    for field in RESULT_FIELDS:
        direct, openalex = defaultdict(set), defaultdict(set)
        for entry in inventory.get(field, []):
            relative, path = _result_path(project, entry['path'])
            if not path.is_file() and not (field == 'sample_path' and entry.get('planned') is True):
                continue
            identifier = entry.get('paper_id') if field in PAPER_RESULT_FIELDS else entry.get('package_id')
            if not isinstance(identifier, str) or not SAFE_ID.fullmatch(identifier):
                raise ValueError('Result inventories need safe paper/package IDs')
            direct[identifier].add(relative)
            if field in PAPER_RESULT_FIELDS:
                wid = _work_id(entry.get('openalex_id')) or _work_id(identifier)
                if wid:
                    openalex[wid].add(relative)
        for row in output:
            if field in PAPER_RESULT_FIELDS:
                candidates = direct.get(row['paper_id'], set())
                if not candidates:
                    candidates = openalex.get(_work_id(row.get('openalex_id')), set())
            else:
                candidates = {path for package in row['jar_packages']
                              for path in direct.get(package['package_id'], set())}
            row[field] = next(iter(candidates)) if len(candidates) == 1 else None
            if len(candidates) > 1:
                ambiguities.append({'paper_id': row['paper_id'], 'field': field, 'paths': sorted(candidates)})
        counts[field] = sum(row[field] is not None for row in output)
    return output, {'result_link_counts': counts, 'ambiguous_result_links': ambiguities}


def result_inventory(project):
    fields = dict(samples='sample_path', models='model_path', feasibility_reproduction='feasibility_reproduction_path',
                  feasibility_execution='feasibility_execution_path', reproductions='reproduction_path',
                  executions='execution_path', replications='replication_path')
    documents = scan(project)
    result = {}
    for name, field in fields.items():
        key = 'paper_id' if field in PAPER_RESULT_FIELDS else 'package_id'
        index = documents.get(f'output/{name}/index.json', {'records': []})
        result[field] = [{key: row['id'], 'path': row['path']} for row in index['records']]
    return result, []


def serialize_catalog(records):
    """Return deterministic JSONL and BOM-encoded CSV bytes with semantic parity."""
    jsonl = ''.join(json.dumps(row, ensure_ascii=False, allow_nan=False) + '\n' for row in records).encode('utf-8')
    output = io.StringIO(newline='')
    writer = csv.DictWriter(output, fieldnames=FIELDS, lineterminator='\n')
    writer.writeheader()
    for row in records:
        writer.writerow({key: json.dumps(value, ensure_ascii=False, allow_nan=False)
                         if isinstance(value, (list, dict)) else value for key, value in row.items()})
    return jsonl, output.getvalue().encode('utf-8-sig')


def _atomic_write(path, value):
    path = Path(path)
    if path.exists() and path.read_bytes() == value:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    descriptor, name = tempfile.mkstemp(prefix='.' + path.name + '.', dir=path.parent)
    try:
        with os.fdopen(descriptor, 'wb') as stream:
            stream.write(value)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(name, path)
    finally:
        if os.path.exists(name):
            os.unlink(name)


def catalog_paths(project):
    """Prefer docs catalogs; support older portable projects with root catalogs."""
    project = Path(project)
    modern = project / 'docs'
    if (modern / 'papers.jsonl').is_file() or (modern / 'papers.csv').is_file():
        directory = modern
    elif (project / 'papers.jsonl').is_file() or (project / 'papers.csv').is_file():
        directory = project
    else:
        directory = modern
    return directory / 'papers.jsonl', directory / 'papers.csv'


def main(argv=None):
    parser = argparse.ArgumentParser(description='Relink the two paper catalogs to the current per-paper results.')
    parser.add_argument('--project-root', type=Path, default=PROJECT)
    parser.add_argument('--baseline', type=Path, help='Catalog metadata source (default: docs/papers.jsonl).')
    parser.add_argument('--output-jsonl', type=Path)
    parser.add_argument('--output-csv', type=Path)
    parser.add_argument('--check', action='store_true', help='Verify both catalogs without writing.')
    args = parser.parse_args(argv)
    project = args.project_root.resolve()
    canonical, csv_path = catalog_paths(project)
    json_target, csv_target = args.output_jsonl or canonical, args.output_csv or csv_path
    if json_target.resolve() == csv_target.resolve():
        parser.error('JSONL and CSV need different destinations')
    catalog = read_jsonl(args.baseline or canonical)
    ids = [row['paper_id'] for row in catalog]
    if len(set(ids)) != len(ids) or any(not SAFE_ID.fullmatch(pid) for pid in ids):
        parser.error('Catalog requires unique safe paper IDs')
    linked, counts = link_results(catalog, result_inventory(project)[0], project)
    outputs = zip((json_target, csv_target), serialize_catalog(linked))
    stale = []
    for path, data in outputs:
        if args.check:
            if not path.is_file() or path.read_bytes() != data:
                stale.append(str(path))
        else:
            _atomic_write(path, data)
    print(json.dumps({'papers': len(linked), **counts, 'stale': stale}, indent=2))
    return int(bool(stale))


if __name__ == '__main__':
    raise SystemExit(main())
