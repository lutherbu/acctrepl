#!/usr/bin/env python3
"""Build complete JSONL exports from the current per-paper publications."""
import argparse
import json
import os
from pathlib import Path
import sys
import tempfile

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT))
from scripts import rebuild_indexes as indexes

EXPORTS = {'samples': 'samples/sample_extractions.jsonl', 'models': 'models/model_results.jsonl',
           'feasibility_reproduction': 'feasibility_reproduction/feasibility_checks.jsonl',
           'feasibility_execution': 'feasibility_execution/assessments.jsonl',
           'executions': 'executions/attempts.jsonl'}


def export_directory(project):
    return Path(project).resolve() / '.local' / 'exports'


def rebuild(project, names, destination, *, check=False):
    project = Path(project).resolve()
    destination = Path(destination)
    selected = list(dict.fromkeys(names))
    unknown = set(selected) - EXPORTS.keys()
    if unknown:
        raise ValueError('Unknown workflow: ' + ', '.join(sorted(unknown)))
    documents = indexes.scan(project) if check else indexes.rebuild(project)
    targets = {name: destination / EXPORTS[name] for name in selected}
    if not check:
        destination.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=None if check else destination) as temporary:
        for name, target in targets.items():
            index = documents.get(f'output/{name}/index.json')
            if index is None:
                raise ValueError(f'Missing workflow: {name}')
            draft = Path(temporary) / name
            with draft.open('wb') as out:
                for item in index['records']:
                    record, digest = indexes.payload(project / item['path'])
                    if digest != item['sha256']:
                        raise ValueError(f"Record changed while exporting: {item['path']}")
                    out.write((json.dumps(record, ensure_ascii=False, allow_nan=False) + '\n').encode())
            if check and (not target.is_file() or indexes.sha(target) != indexes.sha(draft)):
                raise ValueError(f'Missing or stale export: {target}')
        if not check:
            for name, target in targets.items():
                target.parent.mkdir(parents=True, exist_ok=True)
                draft = Path(temporary) / name
                if not target.is_file() or indexes.sha(target) != indexes.sha(draft):
                    os.replace(draft, target)
    return targets


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('exports', nargs='*', metavar='WORKFLOW', help=', '.join(EXPORTS))
    parser.add_argument('--output-dir', type=Path, default=export_directory(PROJECT))
    parser.add_argument('--check', action='store_true', help='Verify the exports without writing to the project.')
    args = parser.parse_args()
    try:
        for path in rebuild(PROJECT, args.exports or EXPORTS, args.output_dir, check=args.check).values():
            print(path)
    except (ValueError, OSError) as error:
        parser.exit(1, f'{error}\n')


if __name__ == '__main__':
    main()
