#!/usr/bin/env python3
"""Convert JSON/JSONL layouts, or publish/audit the project's schema-3 view."""
import argparse
from copy import deepcopy
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
from pathlib import Path

# Resolve frozen artifact locations without rewriting research records.
_layout_root = Path(__file__).resolve().parents[1]
_layout = None
if (_layout_root / "project_layout.py").is_file():
    import sys as _layout_sys
    _layout_sys.path.insert(0, str(_layout_root))
    import project_layout as _layout
    Path = _layout.path_class(_layout_root)
import re
import shutil
import tempfile


ROOT = Path(__file__).resolve().parents[1]
SKILL_REL = Path('skills/extract-accounting-models')
MIGRATION_REL = Path('output/model_results_migration')
V2_PATHS = {'aggregate': 'output/model_results.v2.jsonl',
            'directory': 'output/model_results_v2', 'index': 'output/model_results_index.v2.json',
            'review_queue': 'output/model_results_review_queue.v2.json'}
V3_PATHS = {'aggregate': 'output/model_results.jsonl', 'directory': 'output/model_results',
            'index': 'output/model_results_index.json', 'review_queue': 'output/model_results_review_queue.json'}


def load_module(path):
    spec = importlib.util.spec_from_file_location('conversion_' + hashlib.sha256(str(path).encode()).hexdigest()[:12], path)
    module = importlib.util.module_from_spec(spec); spec.loader.exec_module(module)
    return module


def modules(skill):
    return (load_module(skill / 'scripts/convert_schema.py'),
            load_module(skill / 'scripts/validate_results.py'))


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    return json.loads(Path(path).read_text())


def records(path):
    path = Path(path)
    if path.suffix == '.jsonl':
        with path.open() as stream:
            for line in stream:
                if line.strip():
                    yield json.loads(line)
    else:
        yield read(path)


def write(path, value):
    path = Path(path); path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + '.tmp')
    temporary.write_text(json.dumps(value, indent=2, ensure_ascii=False, allow_nan=False) + '\n')
    temporary.replace(path)


def checked_convert(record, layout, validator, reverse=False):
    source_version, schema = ('3.0', 'output.schema.json') if reverse else ('2.0', 'output.v2.schema.json')
    if record.get('schema_version') != source_version:
        raise ValueError(f'Expected schema {source_version}, got {record.get("schema_version")}')
    errors = validator.schema_errors(record, schema)
    if errors:
        raise ValueError(f'{record.get("paper_id")}: {errors[0]}')
    converted = layout.to_v2(record) if reverse else layout.to_v3(record)
    if not reverse and layout.canonical(layout.to_v2(converted)) != layout.canonical(record):
        raise ValueError(f'{record["paper_id"]}: conversion failed lossless round-trip')
    errors = validator.schema_errors(converted, 'output.v2.schema.json' if reverse else 'output.schema.json')
    if errors:
        raise ValueError(f'{record["paper_id"]}: {errors[0]}')
    return converted


def convert_file(source, output, reverse=False, skill=None):
    source, output = Path(source), Path(output)
    if source.resolve() == output.resolve():
        raise ValueError('Input and output must differ')
    layout, validator = modules(skill or ROOT / SKILL_REL)
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = output.with_suffix(output.suffix + '.tmp')
    count, ids = 0, set()
    try:
        with temporary.open('w') as stream:
            for record in records(source):
                if not isinstance(record, dict) or not record.get('paper_id'):
                    raise ValueError('Each record needs a paper_id')
                if record['paper_id'] in ids:
                    raise ValueError('Duplicate paper_id in input')
                ids.add(record['paper_id'])
                data = checked_convert(record, layout, validator, reverse)
                count += 1
                if output.suffix != '.jsonl' and count > 1:
                    raise ValueError('Multiple records require a .jsonl output')
                stream.write(json.dumps(data, ensure_ascii=False, allow_nan=False,
                                        indent=None if output.suffix == '.jsonl' else 2) + '\n')
        if not count:
            raise ValueError('Input contains no records')
        temporary.replace(output)
    finally:
        temporary.unlink(missing_ok=True)
    return {'records': count, 'output': str(output), 'sha256': sha(output)}


def confined(root, relative):
    path = (root / relative).resolve()
    if not path.is_relative_to(root.resolve()):
        raise ValueError('Migration path is outside the workspace')
    return path


def publish(root=ROOT):
    root = Path(root); migration = root / MIGRATION_REL
    if (migration / 'manifest.json').exists():
        return audit_migration(root)
    source = {k: root / v for k, v in V3_PATHS.items()}
    index = read(source['index'])
    if sha(source['aggregate']) != index['aggregate_sha256']:
        raise ValueError('Current aggregate differs from its index')
    if any((root / p).exists() for p in V2_PATHS.values()) or migration.exists():
        raise ValueError('Migration backup paths already exist; inspect before replacing them')
    layout, validator = modules(root / SKILL_REL)
    paper_ids = [r['paper_id'] for r in index['records']]
    if len(paper_ids) != len(set(paper_ids)) or any(not re.fullmatch(r'[A-Za-z0-9_-]+', pid) for pid in paper_ids):
        raise ValueError('Invalid or duplicate publication paper IDs')
    if {p.stem for p in source['directory'].glob('*.json')} != set(paper_ids):
        raise ValueError('Per-paper publication set differs from index')
    indexed = {r['paper_id']: r for r in index['records']}
    for pid in paper_ids:
        if sha(source['directory'] / f'{pid}.json') != indexed[pid]['result_sha256']:
            raise ValueError(f'Per-paper hash differs: {pid}')
    with tempfile.TemporaryDirectory(prefix='schema3-', dir=root / 'output') as tmp:
        staging = Path(tmp); (staging / 'papers').mkdir()
        out = staging / 'aggregate.jsonl'; converted_index = deepcopy(index)
        seen, per_paper = [], []
        with out.open('w') as stream:
            for old in records(source['aggregate']):
                pid = old['paper_id']; seen.append(pid)
                if layout.canonical(read(source['directory'] / f'{pid}.json')) != layout.canonical(old):
                    raise ValueError(f'Aggregate/per-paper content differs: {pid}')
                new = checked_convert(old, layout, validator)
                write(staging / 'papers' / f'{pid}.json', new)
                stream.write(json.dumps(new, ensure_ascii=False, allow_nan=False) + '\n')
                per_paper.append({'paper_id': pid, 'source_sha256': indexed[pid]['result_sha256'],
                                  'result_sha256': sha(staging / 'papers' / f'{pid}.json'),
                                  'source_record_sha256': layout.digest(old), 'lossless_roundtrip': True})
        if seen != paper_ids:
            raise ValueError('Aggregate order differs from index')
        converted_index.update(schema_version='3.0', source_schema_version='2.0',
                               source_aggregate_sha256=index['aggregate_sha256'],
                               aggregate_sha256=sha(out), migration_manifest=str(MIGRATION_REL / 'manifest.json'))
        for item, detail in zip(converted_index['records'], per_paper):
            item['source_v2_sha256'] = detail['source_sha256']; item['result_sha256'] = detail['result_sha256']
        write(staging / 'index.json', converted_index)
        migration.mkdir()
        shutil.copytree(root / SKILL_REL, migration / 'skill_snapshot', ignore=shutil.ignore_patterns('__pycache__', '*.pyc'))
        backup = {k: root / v for k, v in V2_PATHS.items()}
        for key in ('aggregate', 'index', 'review_queue'):
            shutil.copy2(source[key], backup[key])
        shutil.copytree(source['directory'], backup['directory'])
        previous_audit = root / 'output/model_results_runs/final_audit.json'
        if previous_audit.exists():
            shutil.copy2(previous_audit, migration / 'source_v2_audit.json')
        source_hashes = {str(p.relative_to(root)): sha(p) for p in backup['directory'].glob('*.json')}
        source_hashes.update({str(backup[k].relative_to(root)): sha(backup[k]) for k in ('aggregate', 'index', 'review_queue')})
        try:
            for pid in paper_ids:
                (staging / 'papers' / f'{pid}.json').replace(source['directory'] / f'{pid}.json')
            out.replace(source['aggregate']); (staging / 'index.json').replace(source['index'])
            target_hashes = {str(p.relative_to(root)): sha(p) for p in source['directory'].glob('*.json')}
            target_hashes.update({str(source[k].relative_to(root)): sha(source[k]) for k in ('aggregate', 'index', 'review_queue')})
            snapshot = migration / 'skill_snapshot'
            manifest = {'schema_version': 'model-results-migration-1', 'source_schema_version': '2.0',
                        'target_schema_version': '3.0', 'converted_at': datetime.now(timezone.utc).isoformat(),
                        'source_paths': V2_PATHS, 'target_paths': V3_PATHS, 'paper_ids': paper_ids,
                        'source_files': source_hashes, 'target_files': target_hashes,
                        'snapshot_sha256': {str(p.relative_to(snapshot)): sha(p) for p in snapshot.rglob('*') if p.is_file()},
                        'records': per_paper, 'review_queue_policy': 'Unchanged stable model/result-set/parameter/group IDs; review content is byte-preserved.',
                        'ai_runs': 0, 'numerical_changes': 0}
            write(migration / 'manifest.json', manifest)
        except Exception:
            # All original bytes have already been backed up; restore on failed publication.
            for key in ('aggregate', 'index', 'review_queue'):
                shutil.copy2(backup[key], source[key])
            for pid in paper_ids:
                shutil.copy2(backup['directory'] / f'{pid}.json', source['directory'] / f'{pid}.json')
            raise
    return audit_migration(root)


def audit_migration(root=ROOT):
    root = Path(root); migration = root / MIGRATION_REL; manifest = read(migration / 'manifest.json')
    snapshot = migration / 'skill_snapshot'
    for rel, digest in manifest['snapshot_sha256'].items():
        if sha(confined(snapshot, rel)) != digest:
            raise ValueError(f'Migration snapshot changed: {rel}')
    for field in ('source_files', 'target_files'):
        for rel, digest in manifest[field].items():
            if sha(confined(root, rel)) != digest:
                raise ValueError(f'Migration publication file changed: {rel}')
    layout, validator = modules(snapshot)
    source = {k: confined(root, v) for k, v in manifest['source_paths'].items()}
    target = {k: confined(root, v) for k, v in manifest['target_paths'].items()}
    if any({p.stem for p in paths['directory'].glob('*.json')} != set(manifest['paper_ids']) for paths in [source, target]):
        raise ValueError('Migration per-paper set changed')
    new_rows = iter(records(target['aggregate'])); ids = []
    for old in records(source['aggregate']):
        new = next(new_rows, None)
        if new is None or old['paper_id'] != new['paper_id']:
            raise ValueError('Migration record order changed')
        pid = old['paper_id']; ids.append(pid)
        errors = validator.schema_errors(new, 'output.schema.json')
        if errors or layout.canonical(layout.to_v2(new)) != layout.canonical(old):
            raise ValueError(f'{pid}: migration lost/changed source content or links: {errors[:1]}')
        if new['migration_provenance']['source_record_sha256'] != layout.digest(old):
            raise ValueError(f'{pid}: source-record fingerprint differs')
        if layout.canonical(read(target['directory'] / f'{pid}.json')) != layout.canonical(new):
            raise ValueError(f'{pid}: converted aggregate/per-paper content differs')
    if next(new_rows, None) is not None or ids != manifest['paper_ids']:
        raise ValueError('Migration record set changed')
    index = read(target['index']); source_index = read(source['index'])
    if index['schema_version'] != '3.0' or index['aggregate_sha256'] != sha(target['aggregate']):
        raise ValueError('Converted index/aggregate differs')
    if index['counts'] != source_index['counts'] or [r['paper_id'] for r in index['records']] != ids:
        raise ValueError('Converted index source counts/order differs')
    for item, detail in zip(index['records'], manifest['records']):
        if item['result_sha256'] != detail['result_sha256'] or item['source_v2_sha256'] != detail['source_sha256']:
            raise ValueError('Converted index per-paper hashes differ')
    if sha(source['review_queue']) != sha(target['review_queue']):
        raise ValueError('Review queue changed during format-only migration')
    report = {'valid': True, 'schema_version': '3.0', 'records': len(ids), 'lossless_roundtrip_records': len(ids),
              'aggregate_sha256': sha(target['aggregate']), 'source_v2_aggregate_sha256': sha(source['aggregate']),
              'ai_runs': 0, 'numerical_changes': 0,
              'checks': ['Frozen conversion/schema snapshot', 'Source and target byte hashes',
                         'Schema-3 shape, routing, shared copies and exact inverse reconstruction',
                         'Paper order, individual records, index and unchanged review queue'],
              'limitation': 'Lossless reorganization preserves existing extraction caveats; it does not establish new source accuracy.'}
    write(migration / 'audit.json', report)
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', nargs='?', type=Path)
    parser.add_argument('--output', '-o', type=Path)
    parser.add_argument('--reverse', action='store_true', help='Convert schema 3 back to schema 2.')
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument('--publish', action='store_true', help='Convert the current project publication, preserving schema-2 backups.')
    modes.add_argument('--audit', action='store_true', help='Audit the completed project migration.')
    args = parser.parse_args()
    try:
        if args.publish or args.audit:
            if args.input or args.output or args.reverse:
                raise ValueError('Publication/audit modes do not accept input/output/reverse arguments')
            result = publish() if args.publish else audit_migration()
        else:
            if not args.input or not args.output:
                raise ValueError('Provide INPUT and --output, or use --publish/--audit')
            result = convert_file(args.input, args.output, args.reverse)
    except (OSError, ValueError, KeyError, TypeError) as exc:
        parser.exit(1, f'{exc}\n')
    print(json.dumps(result, ensure_ascii=False))


if __name__ == '__main__':
    main()
