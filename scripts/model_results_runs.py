#!/usr/bin/env python3
"""Freeze, assign, validate and export the bounded results-enrichment campaign.

This program makes no AI calls. The existing specification campaign is read-only.
"""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import sys
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import project_layout as layout
import os
Path = layout.path_class(ROOT)
ROOT = Path(str(ROOT))
RUNS = Path(layout.work_root('model_results', ROOT))
WORKFLOW = RUNS / 'workflow.json'
SKILL = ROOT / 'skills/extract-accounting-models'


def now():
    return datetime.now(timezone.utc).isoformat()


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    return json.loads(Path(path).read_text())


def lines(path):
    return [json.loads(line) for line in Path(path).read_text().splitlines() if line.strip()]


def write(path, data):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + '.tmp')
    temporary.write_text(json.dumps(data, ensure_ascii=False, indent=2, allow_nan=False) + '\n')
    temporary.replace(path)


def load_module(path):
    name = 'results_run_' + hashlib.sha256(str(path).encode()).hexdigest()[:16]
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    layout.relocate_module(module, ROOT)
    return module


def relative(path):
    return os.path.relpath(Path(path).resolve(), ROOT.resolve())


def stage_path(name):
    if Path(name).name != name or name in {'.', '..'}:
        raise ValueError('Stage must be a direct child of the results campaign')
    return Path(layout.stage_path('model_results', name, ROOT))


def assert_file(path, expected, label):
    path = (ROOT / path).resolve()
    allowed = path.is_relative_to(ROOT.resolve()) or (layout.manifest(ROOT) and path.is_relative_to(ROOT.parent / 'candidate_search'))
    if not allowed or not path.is_file() or sha(path) != expected:
        raise ValueError(f'Frozen {label} changed: {path}')


def sync(stage, run):
    layout.writable_path(stage,ROOT)
    write(stage / 'run.json', run)
    workflow = read(WORKFLOW)
    key = 'pilot_rounds' if stage.name.startswith('pilot_') else 'full_sweeps'
    matches = [i for i, item in enumerate(workflow[key]) if item['stage'] == stage.name]
    if matches:
        workflow[key][matches[0]] = run
    else:
        workflow[key].append(run)
    workflow['updated_at'] = now()
    if run['status'] == 'running':
        workflow['status'] = 'piloting' if key == 'pilot_rounds' else 'extracting'
    write(WORKFLOW, workflow)


def initialize(args):
    if WORKFLOW.exists():
        raise ValueError('Results campaign already exists; its quota cannot be reset')
    pending = Path(layout.work_root('model_extraction', ROOT)) / 'publication'
    specs_root = pending if (pending / 'model_extractions.jsonl').is_file() else ROOT / 'output'
    source = specs_root / 'model_extractions.jsonl'
    sample = Path(layout.active_path('shortlist', ROOT))
    index = read(specs_root / 'model_extraction_index.json')
    if sha(source) != index['aggregate_sha256']:
        raise ValueError('Specification aggregate does not match its index')
    old_manifest = {r['paper_id']: r for r in lines(ROOT / 'output/model_extraction_runs/input_manifest.jsonl')}
    indexed = {r['paper_id']: r for r in index['records']}
    specs = lines(source)
    if [r['paper_id'] for r in specs] != [r['paper_id'] for r in lines(sample)]:
        raise ValueError('Specification and shortlist order differ')
    records = []
    for base in specs:
        pid = base['paper_id']
        path = specs_root / 'model_extractions' / f'{pid}.json'
        if read(path) != base or sha(path) != indexed[pid]['result_sha256']:
            raise ValueError(f'Per-paper specification/index differs: {pid}')
        metadata = old_manifest[pid]
        reading, pdf = ROOT / base['paper_text_file'], ROOT / metadata['pdf_path']
        if sha(pdf) != metadata['pdf_sha256']:
            raise ValueError(f'Original PDF changed: {pid}')
        records.append({**{k: metadata[k] for k in ('paper_id', 'doi', 'title', 'journal', 'pdf_path', 'pdf_sha256')},
                        'specification_json': relative(path), 'specification_sha256': sha(path),
                        'reading_json': relative(reading), 'reading_json_sha256': sha(reading),
                        'baseline_models': sum(m['model_role'] == 'baseline' for m in base['models']),
                        'baseline_terms': sum(len(m['independent_variables']) for m in base['models'] if m['model_role'] == 'baseline')})
    RUNS.mkdir(exist_ok=True)
    manifest = RUNS / 'input_manifest.jsonl'
    manifest.write_text(''.join(json.dumps(r, ensure_ascii=False) + '\n' for r in records))
    write(WORKFLOW, {'status': 'initialized', 'created_at': now(), 'model': 'gpt-6-luna',
                     'reasoning_effort': 'max', 'schema_version': '2.0', 'results_scope': 'baseline_only',
                     'specification_file': relative(source), 'specification_sha256': sha(source),
                     'sample_file': relative(sample), 'sample_sha256': sha(sample),
                     'manifest_sha256': sha(manifest), 'paper_count': len(records),
                     'baseline_model_count': sum(r['baseline_models'] for r in records),
                     'maximum_pilot_rounds': 7, 'maximum_full_sweeps': 2,
                     'pilot_rounds': [], 'full_sweeps': [], 'pilot_accepted': None,
                     'authorization': 'User: update results schema/skill; Luna Max testing with seven pilot rounds plus two full sweeps. Independent new quota; prior campaign unchanged.'})
    print(json.dumps({'initialized': True, 'papers': len(records), 'baseline_models': sum(r['baseline_models'] for r in records)}))


def frozen_inputs():
    workflow = read(WORKFLOW)
    assert_file(workflow['specification_file'], workflow['specification_sha256'], 'specification aggregate')
    assert_file(workflow['sample_file'], workflow['sample_sha256'], 'sample shortlist')
    if sha(RUNS / 'input_manifest.jsonl') != workflow['manifest_sha256']:
        raise ValueError('Frozen input manifest changed')
    return workflow, {r['paper_id']: r for r in lines(RUNS / 'input_manifest.jsonl')}


def inventory(base):
    models = []
    for m in base['models']:
        if m['model_role'] != 'baseline':
            continue
        models.append({'model_id': m['model_id'], 'label': m['model_label'], 'locations': m['locations'],
                       'method': m['method'], 'procedure': m['specifications']['estimation_procedure']['description'],
                       'dependent_variable': {'variable_id': 'dv', 'name': m['dependent_variable']['name'],
                                              'definition_preview': (m['dependent_variable']['definition'] or '')[:1200]},
                       'independent_variables': [{'variable_id': f'iv_{i+1:03}', 'name': v['name'],
                                                  'definition_preview': (v['definition'] or '')[:1200]}
                                                 for i, v in enumerate(m['independent_variables'])],
                       'intercept': m['specifications']['intercept'], 'specification_gaps': m['missing_fields']})
    return {'paper_id': base['paper_id'], 'doi': base['doi'], 'models': models,
            'note': 'Navigation inventory only. Definitions can be truncated; inspect the assigned full specification/source as needed.'}


def live_skill_hashes():
    return {str(p.relative_to(SKILL)): sha(p) for p in SKILL.rglob('*')
            if p.is_file() and '__pycache__' not in p.parts and p.suffix != '.pyc'}


def prepare(args):
    workflow, manifest = frozen_inputs()
    key = 'pilot_rounds' if args.kind == 'pilot' else 'full_sweeps'
    number = len(workflow[key]) + 1
    if number > workflow['maximum_pilot_rounds' if args.kind == 'pilot' else 'maximum_full_sweeps']:
        raise ValueError('Authorized quota exhausted; additional user authorization is required')
    ids = args.ids if args.kind == 'pilot' else list(manifest)
    if args.kind == 'pilot' and (not ids or len(ids) != 6 or len(set(ids)) != 6):
        raise ValueError('Pilot requires six distinct paper IDs')
    if set(ids) - set(manifest):
        raise ValueError('Unknown selected paper IDs')
    if args.kind == 'sweep' and not workflow['pilot_accepted']:
        raise ValueError('A completed accepted holdout pilot is required before production')
    if args.kind == 'sweep':
        accepted = stage_path(workflow['pilot_accepted']['stage'])
        tested = read(accepted / 'run.json')
        parent = read(accepted / 'parent_review.json')
        if (tested['kind'] != 'pilot' or tested['status'] != 'complete'
                or not parent.get('accepted_for_production')
                or sha(accepted / 'parent_review.json') != workflow['pilot_accepted']['review_sha256']):
            raise ValueError('Pilot production acceptance is missing or changed')
        if live_skill_hashes() != tested['skill_sha256']:
            raise ValueError('Live skill differs from accepted pilot; validate the revised version in a new authorized pilot')
    previous = None
    if args.previous_stage:
        previous = stage_path(args.previous_stage)
        old_run, report, _ = check_stage(previous)
        if args.kind != 'sweep' or old_run['kind'] != 'sweep' or old_run['status'] != 'complete' or report['valid'] != len(ids) or old_run['paper_ids'] != ids:
            raise ValueError('Verification requires a complete valid full sweep with identical population/order')
    stage = stage_path(f'{args.kind}_{number:02}')
    stage.mkdir()
    for directory in ('reported', 'results', 'evidence', 'inventories', 'worker_reports'):
        (stage / directory).mkdir()
    shutil.copytree(SKILL, stage / 'skill_snapshot', ignore=shutil.ignore_patterns('__pycache__', '*.pyc'))
    skill_hashes = {str(p.relative_to(stage / 'skill_snapshot')): sha(p) for p in (stage / 'skill_snapshot').rglob('*') if p.is_file()}
    rows = []
    for pid in ids:
        row = dict(manifest[pid])
        path = stage / 'inventories' / f'{pid}.json'
        write(path, inventory(read(ROOT / row['specification_json'])))
        row.update(inventory_json=relative(path), inventory_sha256=sha(path),
                   reported_json=relative(stage / 'reported' / f'{pid}.json'),
                   result_json=relative(stage / 'results' / f'{pid}.json'),
                   evidence_directory=relative(stage / 'evidence' / pid))
        if previous:
            row.update(previous_reported=relative(previous / 'reported' / f'{pid}.json'),
                       previous_reported_sha256=sha(previous / 'reported' / f'{pid}.json'))
        rows.append(row)
    path = stage / 'manifest.jsonl'
    path.write_text(''.join(json.dumps(r, ensure_ascii=False) + '\n' for r in rows))
    run = {'stage': stage.name, 'kind': args.kind, 'status': 'running', 'started_at': now(),
           'model': 'gpt-6-luna', 'reasoning_effort': 'max', 'paper_ids': ids,
           'skill_sha256': skill_hashes, 'manifest_sha256': sha(path), 'batches': [],
           'previous_stage': args.previous_stage}
    sync(stage, run)
    print(json.dumps({'stage': stage.name, 'papers': len(ids)}))


def guard(stage):
    workflow, manifest = frozen_inputs()
    run = read(stage / 'run.json')
    if sha(stage / 'manifest.jsonl') != run['manifest_sha256']:
        raise ValueError('Frozen stage manifest changed')
    for rel, expected in run['skill_sha256'].items():
        if sha(stage / 'skill_snapshot' / rel) != expected:
            raise ValueError(f'Frozen skill changed: {rel}')
    for batch in run['batches']:
        assert_file(batch['worklist'], batch['sha256'], 'worklist')
    rows = lines(stage / 'manifest.jsonl')
    for row in rows:
        for p, h in [('specification_json', 'specification_sha256'), ('reading_json', 'reading_json_sha256'),
                     ('pdf_path', 'pdf_sha256'), ('inventory_json', 'inventory_sha256'),
                     ('previous_reported', 'previous_reported_sha256')]:
            if p in row:
                assert_file(row[p], row[h], p)
    return run, rows


def assign(args):
    layout.writable_path(stage_path(args.stage),ROOT)
    stage = stage_path(args.stage)
    run, rows = guard(stage)
    if run['status'] != 'running':
        raise ValueError('Cannot assign a completed stage')
    if args.count < 1 or args.max_terms < 1:
        raise ValueError('Batch bounds must be positive')
    used = {pid for b in run['batches'] for pid in b['paper_ids']}
    pending = [r for r in rows if r['paper_id'] not in used]
    chosen, terms = [], 0
    for row in pending:
        if chosen and (len(chosen) >= args.count or terms + row['baseline_terms'] > args.max_terms):
            break
        chosen.append(row); terms += row['baseline_terms']
    if not chosen:
        print(json.dumps({'assigned': 0})); return
    n = len(run['batches']) + 1
    path = stage / f'batch_{n:03}.jsonl'
    path.write_text(''.join(json.dumps(r, ensure_ascii=False) + '\n' for r in chosen))
    batch = {'number': n, 'worker': args.worker, 'paper_ids': [r['paper_id'] for r in chosen],
             'worklist': relative(path), 'sha256': sha(path), 'assigned_at': now(),
             'report_json': relative(stage / 'worker_reports' / f'batch_{n:03}.json')}
    run['batches'].append(batch); sync(stage, run)
    print(json.dumps(batch))


def check_stage(stage):
    run, rows = guard(stage)
    validator = load_module(stage / 'skill_snapshot/scripts/validate_extraction.py')
    calculator = load_module(stage / 'skill_snapshot/scripts/derive_statistics.py')
    samples = {r['paper_id']: r for r in lines(ROOT / read(WORKFLOW)['sample_file'])}
    reports, records = [], []
    for row in rows:
        pid = row['paper_id']; path = ROOT / row['result_json']; raw_path = ROOT / row['reported_json']
        report = {'paper_id': pid, 'present': path.is_file(), 'valid': False}
        if path.exists():
            try:
                raw, data, base = read(raw_path), read(path), read(ROOT / row['specification_json'])
                errors = validator.validate_enrichment(raw)
                if not errors:
                    expected = calculator.merge_enrichment(base, raw, row['specification_json'], row['specification_sha256'])
                    if data != expected:
                        errors.append('Result differs from deterministic merge/calculation of the raw enrichment')
                    errors += validator.validate(data, read(ROOT / row['reading_json']), samples[pid],
                                                 base, ROOT / row['pdf_path'], ROOT)
                parameters = [p for m in data['models'] for rs in m['results']['result_sets'] for p in rs['parameters']]
                report.update(valid=not errors, errors=errors, reported_sha256=sha(raw_path), result_sha256=sha(path),
                              results_status=data['results_status'], legacy_status=data['status'],
                              baseline_models=sum(m['model_role'] == 'baseline' for m in data['models']),
                              result_sets=sum(len(m['results']['result_sets']) for m in data['models']),
                              parameters=len(parameters), reported_estimates=sum(p['reported']['estimate'] is not None for p in parameters),
                              descriptive_groups=len(data['descriptive_statistics']),
                              descriptive_values=sum(len(v['statistics']) for g in data['descriptive_statistics'] for v in g['variables']))
                records.append(data)
            except (ValueError, OSError, KeyError, TypeError) as exc:
                report['errors'] = [str(exc)]
        reports.append(report)
    ids = set(run['paper_ids'])
    extras = [p.name for p in (stage / 'results').glob('*.json') if p.stem not in ids]
    summary = {'checked_at': now(), 'expected': len(rows), 'present': sum(r['present'] for r in reports),
               'valid': sum(r['valid'] for r in reports), 'extra_results': extras,
               'results_status_counts': dict(Counter(r.get('results_status') for r in reports if r['present'])),
               **{key: sum(r.get(key, 0) for r in reports) for key in
                  ('baseline_models', 'result_sets', 'parameters', 'reported_estimates', 'descriptive_groups', 'descriptive_values')},
               'records': reports}
    write(stage / 'validation.json', summary)
    return run, summary, records


def check(args):
    _, summary, _ = check_stage(stage_path(args.stage))
    print(json.dumps({k: v for k, v in summary.items() if k != 'records'}))
    invalid = [r for r in summary['records'] if r['present'] and not r['valid']]
    if invalid:
        print(json.dumps({'invalid': invalid}, ensure_ascii=False))
    return bool(invalid or summary['extra_results'])


def worker_hashes(stage, run, summary):
    entries = {}
    for batch in run['batches']:
        path = ROOT / batch['report_json']
        if not path.is_file():
            raise ValueError(f'Missing worker report: {path}')
        report = read(path)
        for row in report['papers']:
            if row['paper_id'] in entries:
                raise ValueError('Duplicate worker-report paper ID')
            entries[row['paper_id']] = row
    for actual in summary['records']:
        reported = entries.get(actual['paper_id'])
        if not reported or any(reported.get(k) != actual[k] for k in ('reported_sha256', 'result_sha256')):
            raise ValueError(f'Worker raw/result hashes do not match: {actual["paper_id"]}')


def review_entry(record):
    """Keep numerical caveats visible even when every printed cell was covered."""
    models = []
    for model in record['models']:
        if model['model_role'] != 'baseline':
            continue
        block = model['results']
        parameters = [{'result_set_id': rs['result_set_id'], 'parameter_id': p['parameter_id'],
                       'missing_fields': p['missing_fields'], 'review_notes': p['review_notes'],
                       'calculation_issues': p['derived']['issues']}
                      for rs in block['result_sets'] for p in rs['parameters']
                      if p['missing_fields'] or p['review_notes'] or p['derived']['issues']]
        sets = [{'result_set_id': rs['result_set_id'], 'review_notes': rs['review_notes']}
                for rs in block['result_sets'] if rs['review_notes']]
        unknown = [v['variable_id'] for v in model['independent_variables'] if v['is_research_interest'] is None]
        if block['status'] != 'complete' or block['review_notes'] or block['missing_fields'] or parameters or sets or unknown:
            models.append({'model_id': model['model_id'], 'results_status': block['status'],
                           'reason': block['reason'], 'missing_fields': block['missing_fields'],
                           'review_notes': block['review_notes'], 'unknown_roles': unknown,
                           'result_sets': sets, 'parameters': parameters})
    descriptives = [{'group_id': g['group_id'], 'review_notes': g['review_notes'],
                     'variables': [{'name': v['name'], 'review_notes': v['review_notes'],
                                    'unclear_links': [link for link in v['variable_links'] if link['relation'] == 'unclear']}
                                   for v in g['variables'] if v['review_notes'] or any(link['relation'] == 'unclear' for link in v['variable_links'])]}
                    for g in record['descriptive_statistics']]
    descriptives = [g for g in descriptives if g['review_notes'] or g['variables']]
    return {'paper_id': record['paper_id'], 'legacy_status': record['status'],
            'results_status': record['results_status'],
            'has_legacy_specification_issues': record['status'] == 'needs_review',
            'has_new_result_issues': record['results_status'] == 'needs_review',
            'results_review_notes': record['results_review_notes'], 'models': models,
            'descriptive_status': record['descriptive_status'], 'descriptive_reason': record['descriptive_reason'],
            'descriptive_notes': descriptives}


def review_queue(records):
    entries = [review_entry(record) for record in records]
    return [r for r in entries if r['legacy_status'] != 'complete' or r['results_status'] != 'complete'
            or r['results_review_notes'] or r['models'] or r['descriptive_notes']]


def finish(args):
    layout.writable_path(stage_path(args.stage),ROOT)
    stage = stage_path(args.stage)
    if args.publish and not layout.manifest(ROOT) and (ROOT / 'output/model_results_migration/manifest.json').exists():
        raise ValueError('The publication has been converted to schema 3; audit it instead of republishing schema 2')
    run, summary, records = check_stage(stage)
    if summary['valid'] != summary['expected'] or summary['extra_results']:
        raise ValueError('Every selected record must validate before completion')
    parent = read(stage / 'parent_review.json')
    if not parent.get('accepted_for_archival'):
        raise ValueError('Explicit parent source review acceptance is required')
    worker_hashes(stage, run, summary)
    archive = stage / 'raw_luna_archive'
    if not archive.exists():
        archive.mkdir()
        for name in ('reported', 'results', 'worker_reports'):
            shutil.copytree(stage / name, archive / name)
        manifest = {str(p.relative_to(archive)): sha(p) for p in archive.rglob('*') if p.is_file()}
        write(archive / 'manifest.json', {'archived_at': now(), 'files': manifest})
    else:
        for rel, value in read(archive / 'manifest.json')['files'].items():
            if sha(archive / rel) != value:
                raise ValueError('Archived raw worker file changed')
    if args.accept_pilot:
        if run['kind'] != 'pilot' or not parent.get('accepted_for_production'):
            raise ValueError('Pilot production acceptance must be documented')
    if args.publish and (run['kind'] != 'sweep' or not parent.get('accepted_for_publication')):
        raise ValueError('Publication requires an accepted full sweep')
    run.update(status='complete', completed_at=now(), final_counts={k:v for k,v in summary.items() if k not in ('records','checked_at')})
    sync(stage, run)
    workflow = read(WORKFLOW)
    if args.accept_pilot:
        workflow['pilot_accepted'] = {'stage': stage.name, 'review_sha256': sha(stage / 'parent_review.json')}
    if args.publish:
        publication = RUNS / 'publication_v2' if layout.manifest(ROOT) else ROOT / 'output'
        publication.mkdir(parents=True,exist_ok=True)
        target = publication / 'model_results'; target.mkdir(exist_ok=True)
        for record in records:
            shutil.copyfile(stage / 'results' / f'{record["paper_id"]}.json', target / f'{record["paper_id"]}.json')
        output = publication / 'model_results.jsonl'
        temp = output.with_suffix('.jsonl.tmp')
        temp.write_text(''.join(json.dumps(r, ensure_ascii=False, allow_nan=False)+'\n' for r in records));temp.replace(output)
        write(publication / 'model_results_index.json', {'stage':stage.name,'published_at':now(),
              'aggregate_sha256':sha(output),'specification_sha256':workflow['specification_sha256'],
              'sample_sha256':workflow['sample_sha256'],'counts':run['final_counts'],'records':summary['records']})
        write(publication / 'model_results_review_queue.json', review_queue(records))
        if layout.manages_run('model_results', stage, ROOT):
            layout.publish_models(records,read(publication/'model_results_index.json'),review_queue(records),ROOT)
        workflow.update(status='complete',published_stage=stage.name,completed_at=now())
    else:
        workflow['status'] = 'pilot_complete' if run['kind']=='pilot' else 'sweep_complete'
    write(WORKFLOW,workflow)
    print(json.dumps({'stage':stage.name,'complete':True,'published':args.publish,**run['final_counts']}))


def audit(args):
    """Recheck publication lineage against immutable inputs and worker archives."""
    workflow, _ = frozen_inputs()
    if workflow.get('status') != 'complete' or not workflow.get('published_stage'):
        raise ValueError('No completed results publication')
    stage = stage_path(workflow['published_stage'])
    run, summary, records = check_stage(stage)
    if run['status'] != 'complete' or summary['valid'] != summary['expected'] or summary['extra_results']:
        raise ValueError('Published stage is incomplete or invalid')
    worker_hashes(stage, run, summary)
    for completed in workflow['pilot_rounds'] + workflow['full_sweeps']:
        if completed['status'] != 'complete':
            raise ValueError('An unfinished campaign stage remains')
        directory = stage_path(completed['stage'])
        guard(directory)
        archive = directory / 'raw_luna_archive'
        for rel, expected in read(archive / 'manifest.json')['files'].items():
            if sha(archive / rel) != expected or sha(directory / rel) != expected:
                raise ValueError(f'Worker archive/current output differs: {completed["stage"]}/{rel}')
    converted = (ROOT / 'output/model_results_migration/manifest.json').exists()
    output = ROOT / ('output/model_results.v2.jsonl' if converted else 'output/model_results.jsonl')
    index = read(ROOT / ('output/model_results_index.v2.json' if converted else 'output/model_results_index.json'))
    if index['stage'] != stage.name or index['aggregate_sha256'] != sha(output) or lines(output) != records:
        raise ValueError('Published aggregate/index differs from accepted stage')
    if index['specification_sha256'] != workflow['specification_sha256'] or index['sample_sha256'] != workflow['sample_sha256']:
        raise ValueError('Publication input lineage differs')
    if index['records'] != summary['records'] or index['counts'] != run['final_counts']:
        raise ValueError('Publication index records/counts differ')
    target = ROOT / ('output/model_results_v2' if converted else 'output/model_results')
    if {p.stem for p in target.glob('*.json')} != set(run['paper_ids']):
        raise ValueError('Per-paper publication set differs')
    for record in records:
        pid = record['paper_id']
        if sha(target / f'{pid}.json') != sha(stage / 'results' / f'{pid}.json'):
            raise ValueError(f'Published per-paper result differs: {pid}')
    queue = ROOT / ('output/model_results_review_queue.v2.json' if converted else 'output/model_results_review_queue.json')
    if read(queue) != review_queue(records):
        raise ValueError('Published review queue differs')
    report = {'audited_at': now(), 'valid': True, 'published_stage': stage.name,
              'aggregate_sha256': sha(output), 'specification_sha256': workflow['specification_sha256'],
              'sample_sha256': workflow['sample_sha256'], 'pilots_used': len(workflow['pilot_rounds']),
              'full_sweeps_used': len(workflow['full_sweeps']),
              'checks': ['Frozen input/PDF/reading/skill/worklist hashes', 'Source quotes and reproducible PDF regions',
                         'Schema and variable/model links', 'Deterministic calculations',
                         'Original specification fields preserved', 'Worker reports and raw archives',
                         'Ordered aggregate, individual files, index and review queue'],
              'counts': run['final_counts'],
              'limitation': 'Mechanical lineage checks do not establish semantic extraction accuracy.'}
    if converted:
        migration = load_module(Path(__file__).with_name('convert_model_results.py')).audit_migration(ROOT)
        report.update(schema_version='3.0', aggregate_sha256=migration['aggregate_sha256'],
                      source_v2_aggregate_sha256=migration['source_v2_aggregate_sha256'],
                      conversion_audit=migration)
        report['checks'].append('Lossless schema-3 conversion back to the accepted schema-2 publication')
    write(RUNS / 'final_audit.json', report)
    print(json.dumps(report))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command',required=True)
    p=sub.add_parser('init');p.set_defaults(func=initialize)
    p=sub.add_parser('prepare');p.add_argument('kind',choices=['pilot','sweep']);p.add_argument('--ids',nargs='+');p.add_argument('--previous-stage');p.set_defaults(func=prepare)
    p=sub.add_parser('assign');p.add_argument('stage');p.add_argument('--worker',required=True);p.add_argument('--count',type=int,default=3);p.add_argument('--max-terms',type=int,default=80);p.set_defaults(func=assign)
    p=sub.add_parser('check');p.add_argument('stage');p.set_defaults(func=check)
    p=sub.add_parser('finish');p.add_argument('stage');p.add_argument('--accept-pilot',action='store_true');p.add_argument('--publish',action='store_true');p.set_defaults(func=finish)
    p=sub.add_parser('audit');p.set_defaults(func=audit)
    args=parser.parse_args()
    try:return int(bool(args.func(args)))
    except (ValueError,OSError,KeyError,TypeError) as exc:parser.exit(1,f'{exc}\n')


if __name__=='__main__':
    sys.exit(main())
