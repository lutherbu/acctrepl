#!/usr/bin/env python3
"""Export common labels from saved feasibility assessments without reassessment.

The default JSONLs can be rebuilt from the indexed per-paper assessments.
"""
from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import shutil
import sys
import tempfile
import uuid

from jsonschema.validators import validator_for

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
import project_layout as layout
from scripts.feasibility_verdict import execution_verdict, reproduction_verdict
DEFAULT_REPLICATION = layout.resolve_path('output/feasibility_reproduction/feasibility_checks.jsonl',ROOT)
DEFAULT_EXECUTION = layout.resolve_path('output/feasibility_execution/assessments.jsonl',ROOT)
DEFAULT_SCHEMA = ROOT/'skills/check-replication-feasibility/references/feasibility_classification.schema.json'
DEFAULT_OUTPUT = ROOT/'.local/reports/classification'
DEFAULT_ARCHIVE = ROOT/'.local/archive/classification'
APPROACHES = ('independent_reconstruction', 'author_package')


def sha256(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1048576), b''):
            h.update(block)
    return h.hexdigest()


def _plain_path(path, *, file=False):
    path = Path(path).absolute()
    if any(p.is_symlink() for p in (path, *path.parents)):
        raise ValueError('Input and output paths must not use symlinks')
    path = path.resolve()
    if file and not path.is_file():
        raise ValueError(f'Expected an existing input file: {path}')
    return path


def _json(data):
    def pairs(items):
        result = {}
        for key, value in items:
            if key in result:
                raise ValueError('Duplicate JSON object key')
            result[key] = value
        return result
    def constant(_):
        raise ValueError('Non-finite JSON number')
    return json.loads(data, object_pairs_hook=pairs, parse_constant=constant)


def _dump(value):
    return json.dumps(value, ensure_ascii=False, sort_keys=True, indent=2, allow_nan=False)+'\n'


def load_schema(path):
    path = _plain_path(path, file=True)
    raw = path.read_bytes()
    schema = _json(raw)
    def local_refs(value):
        if isinstance(value, dict):
            for key, item in value.items():
                if key == '$ref' and (not isinstance(item, str) or not item.startswith('#')):
                    raise ValueError('Common schema references must be local; no network resolution is allowed')
                local_refs(item)
        elif isinstance(value, list):
            for item in value:
                local_refs(item)
    local_refs(schema)
    validator_class = validator_for(schema)
    validator_class.check_schema(schema)
    labels = schema['$defs']['data_status']['enum']
    mappings = schema['x_status_mappings']
    if (not isinstance(mappings, dict) or set(mappings) != set(APPROACHES)
            or not isinstance(labels, list) or not labels or any(not isinstance(x,str) for x in labels)
            or len(set(labels)) != len(labels)):
        raise ValueError('Common schema has invalid approaches or data labels')
    if not isinstance(schema['x_data_labels'],dict) or set(schema['x_data_labels']) != set(labels):
        raise ValueError('Every common data label needs one definition')
    for mapping in mappings.values():
        if (not isinstance(mapping, dict) or not mapping or any(not isinstance(x,str) for x in mapping.values())
                or not set(mapping.values()) <= set(labels)):
            raise ValueError('Common schema mapping targets must be declared data labels')
    classes = set(schema['$defs']['classification']['enum'])
    if set(schema['x_class_labels']) != classes:
        raise ValueError('Every shared verdict needs a display label')
    matrix = schema['x_execution_matrix']
    codes = set(schema['$defs']['execution_readiness']['enum']) - {'not_assessed'}
    if (set(matrix) != set(labels) or any(set(row) != codes or not set(row.values()) <= classes
                                          for row in matrix.values())):
        raise ValueError('Invalid execution feasibility matrix')
    routed_codes = {code for row in matrix.values() for code, verdict in row.items() if verdict == 'ready'}
    if set(schema['x_ready_routes']) != routed_codes:
        raise ValueError('Every Ready code disposition needs a route')
    reconstruction = schema['x_reproduction_classes']
    if set(reconstruction) != set(labels) or not set(reconstruction.values()) <= classes:
        raise ValueError('Invalid reconstruction verdict mapping')
    return path, raw, schema, validator_class(schema)


def _text(value, label, *, nullable=False):
    if nullable and value is None:
        return value
    if not isinstance(value, str) or not value:
        raise ValueError(f'{label} must be a nonempty string')
    return value


def _list(value, label):
    if not isinstance(value, list):
        raise ValueError(f'{label} must be a list')
    return value


def _bool(value, label):
    if type(value) is not bool:
        raise ValueError(f'{label} must be a boolean')
    return value


def _status(value, approach, schema):
    mapping = schema['x_status_mappings'][approach]
    if not isinstance(value, str) or value not in mapping:
        raise ValueError(f'Unknown saved data status for {approach}')
    return mapping[value]


def _base(document, approach, provenance, schema):
    subject_key = 'paper_id' if approach == APPROACHES[0] else 'package_id'
    subject = _text(document.get(subject_key), subject_key)
    doi = document.get('doi')
    if doi is not None and not isinstance(doi, str):
        raise ValueError('doi must be a string or null')
    return {'classification_version': schema['properties']['classification_version']['const'],
            'approach': approach, 'subject_id': subject,
            'paper_id': subject if approach == APPROACHES[0] else None,
            'package_id': subject if approach == APPROACHES[1] else None,
            'doi': doi, 'model_id': None, 'result_set_id': None,
            'scope': None, 'eligibility': 'in_scope', 'data_status': None,
            'classification': None, 'route': None, 'na_reason': None,
            'execution_readiness': 'not_assessed', 'execution_verified': None,
            'independent_attempt_ready': None,
            'evidence_profile': ('reconstruction_dimensions' if approach == APPROACHES[0]
                                 else 'author_workflow_compatibility'),
            'original': {'data_status': None, 'execution_readiness': None,
                         'attempt_ready': None, 'paper_outcome': None},
            'source': provenance}


def _replication_rows(document, provenance, schema):
    base = _base(document, APPROACHES[0], provenance, schema)
    eligibility = document.get('eligibility')
    fits = _list(document.get('assessments'), 'assessments')
    requirements = _list(document.get('requirements'), 'requirements')
    summary = document.get('summary')
    if not isinstance(summary, dict):
        raise ValueError('Replication document requires its saved summary')
    paper_outcome = _text(summary.get('outcome'), 'paper summary outcome')
    if eligibility == 'no_baseline':
        if fits or requirements or paper_outcome != 'not_applicable':
            raise ValueError('No-baseline document must have no fits/data requirements and its eligibility summary')
        return [{**base, 'scope': 'paper_eligibility', 'eligibility': 'no_baseline',
                 'classification': 'not_applicable', 'na_reason': 'no_baseline',
                 'original': {**base['original'], 'paper_outcome': paper_outcome}}]
    if eligibility != 'eligible' or not fits or paper_outcome == 'not_applicable':
        raise ValueError('Eligible replication document requires baseline fits')
    rows = []
    for fit in fits:
        if not isinstance(fit, dict):
            raise ValueError('A saved baseline fit must be an object')
        model = _text(fit.get('model_id'), 'model_id')
        result = _text(fit.get('result_set_id'), 'result_set_id', nullable=True)
        status = fit.get('data_status')
        attempt = _bool(fit.get('attempt_ready'), 'attempt_ready')
        mode = fit.get('data_mode', 'observed')
        if not isinstance(mode,str) or mode not in {'observed', 'synthetic_only'}:
            raise ValueError('Unknown saved data mode')
        if (status == 'no_observed_data_required') != (mode == 'synthetic_only'):
            raise ValueError('No-observed-data status conflicts with saved data mode')
        rows.append({**base, 'model_id': model, 'result_set_id': result, 'scope': 'baseline_fit',
                     'data_status': _status(status, APPROACHES[0], schema),
                     'classification': reproduction_verdict(status, schema),
                     'na_reason': 'synthetic_only' if mode == 'synthetic_only' else None,
                     'independent_attempt_ready': attempt,
                     'original': {'data_status': status, 'execution_readiness': None,
                                  'attempt_ready': attempt, 'paper_outcome': paper_outcome}})
    return rows


def _execution_rows(document, provenance, schema):
    base = _base(document, APPROACHES[1], provenance, schema)
    scopes = _list(document.get('scopes'), 'scopes')
    if not scopes:
        raise ValueError('An execution assessment needs at least one scope')
    ready_values = set(schema['$defs']['execution_readiness']['enum'])-{'not_assessed'}
    rows = []
    for scope in scopes:
        if (not isinstance(scope, dict) or not isinstance(scope.get('id'),str)
                or scope['id'] not in {'full_pipeline', 'analysis_only'}):
            raise ValueError('Unknown author workflow scope')
        status = scope.get('data_status')
        data_required = _bool(scope.get('data_required'), 'data_required')
        if (status == 'not_applicable') != (not data_required):
            raise ValueError('No-observed-data status conflicts with saved data_required')
        readiness = scope.get('execution_readiness')
        if not isinstance(readiness,str) or readiness not in ready_values:
            raise ValueError('Unknown saved execution readiness')
        has_code = _bool(scope.get('has_code'), 'has_code')
        if (readiness == 'no_runnable_code') != (not has_code):
            raise ValueError('No-code readiness conflicts with saved code presence')
        if scope.get('execution_verified') is not False:
            raise ValueError('Static author-package assessments must retain execution_verified=false')
        classification, route = execution_verdict(_status(status, APPROACHES[1], schema), readiness, schema)
        rows.append({**base, 'scope': scope['id'], 'classification': classification, 'route': route,
                     'na_reason': 'no_observed_data_required' if not data_required else None,
                     'data_status': _status(status, APPROACHES[1], schema),
                     'execution_readiness': readiness, 'execution_verified': False,
                     'original': {'data_status': status, 'execution_readiness': readiness,
                                  'attempt_ready': None, 'paper_outcome': None}})
    return rows


def read_source(path, approach, schema, validator):
    if approach not in APPROACHES:
        raise ValueError('Unknown classification approach')
    path = _plain_path(path, file=True)
    raw = path.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    rows, documents, subjects, identities = [], 0, set(), set()
    for lineno, line in enumerate(raw.splitlines(keepends=True), 1):
        if not line.strip():
            continue
        try:
            document = _json(line.decode('utf-8-sig'))
        except (UnicodeError, ValueError) as exc:
            raise ValueError(f'Invalid saved JSON at {path}:{lineno}') from exc
        if not isinstance(document, dict):
            raise ValueError('Saved assessment document must be an object')
        provenance = {'path': str(path), 'sha256': digest, 'line': lineno,
                      'line_sha256': hashlib.sha256(line).hexdigest()}
        current = (_replication_rows(document, provenance, schema) if approach == APPROACHES[0]
                   else _execution_rows(document, provenance, schema))
        subject = current[0]['subject_id']
        if subject in subjects:
            raise ValueError('Duplicate saved paper or package document')
        subjects.add(subject)
        documents += 1
        for row in current:
            identity = (row['subject_id'], row['model_id'], row['result_set_id']) if approach == APPROACHES[0] else (row['subject_id'], row['scope'])
            if identity in identities:
                raise ValueError('Duplicate saved assessment identity')
            identities.add(identity)
            error = next(validator.iter_errors(row), None)
            if error is not None:
                location = '/'.join(map(str, error.absolute_path))
                raise ValueError(f'Normalized row violates common schema at {location}')
            rows.append(row)
    if not documents:
        raise ValueError('Saved assessment file contains no documents')
    if sha256(path) != digest:
        raise ValueError('Saved assessment input changed during conversion')
    return rows, {'approach': approach, 'path': str(path), 'sha256': digest,
                  'documents': documents, 'normalized_records': len(rows)}


def summarize(rows, sources, schema):
    grouped = defaultdict(list)
    for row in rows:
        grouped[(row['approach'], row['scope'])].append(row)
    labels = schema['$defs']['data_status']['enum']
    readiness = schema['$defs']['execution_readiness']['enum']
    groups = []
    for (approach, scope), values in sorted(grouped.items()):
        data = Counter(v['data_status'] for v in values if v['data_status'] is not None)
        ready = Counter(v['execution_readiness'] for v in values)
        attempts = Counter('not_assessed' if v['independent_attempt_ready'] is None
                           else str(v['independent_attempt_ready']).lower() for v in values)
        groups.append({'approach': approach, 'scope': scope, 'records': len(values),
                       'subjects': len({v['subject_id'] for v in values}),
                       'eligibility': dict(sorted(Counter(v['eligibility'] for v in values).items())),
                       'classification': dict(Counter(v['classification'] for v in values)),
                       'data_status': {label: data[label] for label in labels},
                       'execution_readiness': {label: ready[label] for label in readiness},
                       'independent_attempt_ready': {k: attempts[k] for k in ('true','false','not_assessed')}})
    return {'classification_version': schema['properties']['classification_version']['const'],
            'normalized_records': len(rows), 'source_documents': sources, 'groups': groups,
            'classification_labels': schema['x_class_labels'],
            'data_status_order': labels,
            'data_labels': schema['x_data_labels'], 'evidence_profiles': schema['x_evidence_profiles'],
            'notes': ['Labels are harmonized from saved verdicts; no paper, evidence, probe or model was reassessed.',
                      'Approaches and scopes have different units and evidence profiles; their denominators are kept separate.',
                      'Paper eligibility no_baseline has no data verdict and is excluded from data-status counts.',
                      'Independent attempt readiness is retained separately and does not certify author-code execution readiness.']}


def _summary_markdown(summary):
    columns = ['Approach','Scope','Records','Subjects']+[k.replace('_',' ') for k in summary['data_status_order']]
    separators = ['---','---','---:','---:']+['---:']*len(summary['data_status_order'])
    lines = ['# Common feasibility classifications', '', *summary['notes'], '',
             '| '+' | '.join(columns)+' |',
             '| '+' | '.join(separators)+' |']
    for group in summary['groups']:
        c = group['data_status']
        values = ['—']*len(summary['data_status_order']) if group['scope'] == 'paper_eligibility' else [str(c[k]) for k in summary['data_status_order']]
        lines.append('| '+' | '.join([group['approach'],group['scope'],str(group['records']),str(group['subjects']),*values])+' |')
    labels = summary['classification_labels']
    lines += ['', '## Feasibility verdicts', '',
              '| Approach | Scope | ' + ' | '.join(labels.values()) + ' |',
              '|---|---|' + '---:|' * len(labels)]
    for group in summary['groups']:
        counts = [str(group['classification'].get(k, 0)) for k in labels]
        lines.append('| ' + ' | '.join([group['approach'], group['scope'], *counts]) + ' |')
    lines += ['', '## Shared data labels', '']
    for label, definition in summary['data_labels'].items():
        lines.append(f'- `{label}`: {definition}')
    lines += ['', '## Preserved evidence profiles', '']
    for profile, definition in summary['evidence_profiles'].items():
        lines.append(f'- `{profile}`: {definition}')
    lines += ['', 'The source paths, physical JSONL line numbers and original checksums are recorded in each row.',
              'Original assessments and their classifications remain unchanged.']
    return '\n'.join(lines)+'\n'


def _safe_output(output, inputs, *, classification_child=False):
    output = _plain_path(output)
    if output.exists() and not output.is_dir():
        raise ValueError('Output must be a directory')
    for number,source in enumerate(inputs):
        # Keep the complete authoritative publication directories untouched,
        # including their ancillary indexes/proposals/schema files.
        reserved_child = (classification_child and number==0
                          and output==source.parent/'classification')
        if output == source or source.is_relative_to(output) or (output.is_relative_to(source.parent) and not reserved_child):
            raise ValueError('Output must be separate from authoritative input directories')
    return output


def _same_tree(left, right):
    left_files, right_files = {}, {}
    for root, result in ((left,left_files),(right,right_files)):
        for path in root.rglob('*'):
            if path.is_symlink():
                raise ValueError('Derived output must not contain symlinks')
            if path.is_file():
                result[str(path.relative_to(root))] = sha256(path)
    return left_files == right_files


def export(replication=DEFAULT_REPLICATION, execution=DEFAULT_EXECUTION,
           schema_path=DEFAULT_SCHEMA, output=DEFAULT_OUTPUT, *, overwrite=False,
           archive_root=DEFAULT_ARCHIVE):
    if layout.separate_exports(ROOT):
        if Path(replication).absolute() in (DEFAULT_REPLICATION, ROOT/'output/feasibility_reproduction/feasibility_checks.jsonl'):
            replication = layout.ensure_export('feasibility_reproduction',ROOT)
        if Path(execution).absolute() in (DEFAULT_EXECUTION, ROOT/'output/feasibility_execution/assessments.jsonl'):
            execution = layout.ensure_export('feasibility_execution',ROOT)
    replication = _plain_path(replication, file=True)
    execution = _plain_path(execution, file=True)
    if replication == execution:
        raise ValueError('Replication and execution inputs must be distinct')
    schema_path, schema_raw, schema, validator = load_schema(schema_path)
    output = _safe_output(output, (replication,execution,schema_path), classification_child=True)
    rows, sources = [], []
    for path, approach in ((replication,APPROACHES[0]),(execution,APPROACHES[1])):
        values, source = read_source(path, approach, schema, validator)
        rows.extend(values); sources.append(source)
    summary = summarize(rows, sources, schema)
    output.parent.mkdir(parents=True, exist_ok=True)
    stage = Path(tempfile.mkdtemp(prefix='.'+output.name+'.stage.', dir=output.parent))
    archive = None
    try:
        aggregate = stage/'assessments.jsonl'
        with aggregate.open('w',encoding='utf-8') as stream:
            for row in rows:
                stream.write(json.dumps(row,ensure_ascii=False,sort_keys=True,allow_nan=False)+'\n')
        (stage/'summary.json').write_text(_dump(summary),encoding='utf-8')
        (stage/'summary.md').write_text(_summary_markdown(summary),encoding='utf-8')
        (stage/'classification.schema.json').write_bytes(schema_raw)
        manifest = {'classification_version': summary['classification_version'], 'sources': sources,
                    'schema': {'path': str(schema_path),'sha256': hashlib.sha256(schema_raw).hexdigest()},
                    'normalizer': {'path':str(Path(__file__).resolve()),'sha256':sha256(__file__)},
                    'records':len(rows), 'no_reassessment':True,'original_verdicts_preserved':True,
                    'artifacts':{p.name:sha256(p) for p in sorted(stage.iterdir()) if p.is_file()}}
        (stage/'manifest.json').write_text(_dump(manifest),encoding='utf-8')
        for source in sources:
            if sha256(source['path']) != source['sha256']:
                raise ValueError('Saved input changed before output publication')
        if sha256(schema_path) != manifest['schema']['sha256']:
            raise ValueError('Shared classification schema changed during export')
        if output.exists():
            if _same_tree(output,stage):
                return {'status':'unchanged','output':str(output),'records':len(rows),'sources':sources}
            if not overwrite:
                raise ValueError('Derived output differs; use --overwrite to archive and replace it')
            archive_root = _plain_path(archive_root)
            _safe_output(archive_root,(replication,execution,schema_path))
            if archive_root.is_relative_to(output) or output.is_relative_to(archive_root):
                raise ValueError('Archive and output directories must be separate')
            archive_root.mkdir(parents=True,exist_ok=True)
            archive = archive_root/(datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')+'-'+uuid.uuid4().hex[:8])
            os.replace(output,archive)
        try:
            os.replace(stage,output)
        except Exception:
            if archive is not None and archive.exists() and not output.exists():
                os.replace(archive,output)
            raise
        return {'status':'written','output':str(output),'records':len(rows),
                'archive':str(archive) if archive else None,'sources':sources}
    finally:
        if stage.exists():
            shutil.rmtree(stage)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--replication',type=Path,default=DEFAULT_REPLICATION)
    parser.add_argument('--execution',type=Path,default=DEFAULT_EXECUTION)
    parser.add_argument('--schema',type=Path,default=DEFAULT_SCHEMA)
    parser.add_argument('--output',type=Path,default=DEFAULT_OUTPUT)
    parser.add_argument('--overwrite',action='store_true',help='Archive and replace an existing derived export; authoritative inputs are never changed')
    args = parser.parse_args()
    try:
        result = export(args.replication,args.execution,args.schema,args.output,overwrite=args.overwrite)
    except (OSError,ValueError,KeyError) as exc:
        parser.exit(2,f'Error: {exc}\n')
    print(json.dumps(result,ensure_ascii=False))


if __name__ == '__main__':
    main()
