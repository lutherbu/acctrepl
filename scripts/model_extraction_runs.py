#!/usr/bin/env python3
"""Prepare, validate and publish bounded model-extraction runs; no AI calls."""
import argparse
from collections import Counter
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import project_layout as layout
Path = layout.path_class(ROOT)
ROOT = Path(str(ROOT))
RUNS = Path(layout.work_root('model_extraction', ROOT))
WORKFLOW = RUNS / 'workflow.json'


def now():
    return datetime.now(timezone.utc).isoformat()


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read_json(path):
    return json.loads(Path(path).read_text())


def read_lines(path):
    return [json.loads(s) for s in Path(path).read_text().splitlines() if s.strip()]


def write_json(path, data):
    tmp = path.with_suffix(path.suffix + '.tmp')
    tmp.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    tmp.replace(path)


def stage_path(name):
    if Path(name).name != name or name in {'.', '..'}:
        raise ValueError('Stage must be a direct child of model_extraction_runs')
    return Path(layout.stage_path('model_extraction', name, ROOT))


def synchronize(stage, run):
    layout.writable_path(stage,ROOT)
    write_json(stage / 'run.json', run)
    workflow = read_json(WORKFLOW)
    key = 'pilot_rounds' if stage.name.startswith('pilot_') else 'full_sweeps'
    entries = workflow[key]
    for i, prior in enumerate(entries):
        if prior['output_directory'] == run['output_directory']:
            entries[i] = run
            break
    else:
        entries.append(run)
    if run['status'] == 'running':
        workflow['status'] = 'piloting' if key == 'pilot_rounds' else 'extracting'
    workflow['updated_at'] = now()
    write_json(WORKFLOW, workflow)


def prepare(args):
    workflow = read_json(WORKFLOW)
    if sha(ROOT / workflow['input_file']) != workflow['input_sha256']:
        raise ValueError('Shortlist changed; do not silently change the run population')
    manifest = read_lines(RUNS / 'input_manifest.jsonl')
    key = 'pilot_rounds' if args.kind == 'pilot' else 'full_sweeps'
    limit = workflow['maximum_pilot_rounds' if args.kind == 'pilot' else 'maximum_full_sweeps']
    number = len(workflow[key]) + 1
    if number > limit:
        raise ValueError(f'Authorized {args.kind} limit reached; further user authorization required')
    if args.kind == 'pilot':
        ids = args.ids or []
        if len(ids) != 6 or len(set(ids)) != 6:
            raise ValueError('Pilot requires exactly six distinct --ids')
        by_id = {r['paper_id']: r for r in manifest}
        selected = [by_id[i] for i in ids]
    else:
        if not workflow.get('pilot_accepted'):
            raise ValueError('Parent must record an accepted final pilot before the first sweep')
        selected = manifest
        ids = [r['paper_id'] for r in selected]
    previous_inputs = {}
    previous_name = getattr(args, 'previous_stage', None)
    if previous_name:
        if args.kind != 'sweep' or not previous_name.startswith('sweep_'):
            raise ValueError('Previous results must come from a completed full sweep')
        previous = stage_path(previous_name)
        previous_run, previous_check, _ = check_stage(previous)
        if previous_run['status'] != 'complete' or previous_check['valid'] != len(ids) or previous_check['extra_result_files']:
            raise ValueError('Previous sweep must be complete and fully valid')
        if previous_run['paper_ids'] != ids:
            raise ValueError('Previous sweep population/order differs')
        previous_inputs = {
            pid: {'path': str((previous / 'results' / f'{pid}.json').relative_to(ROOT)),
                  'sha256': sha(previous / 'results' / f'{pid}.json')}
            for pid in ids
        }
    notes_source = getattr(args, 'review_notes', None)
    notes = {}
    if notes_source:
        if not previous_name:
            raise ValueError('Coordinator notes are only for full-sweep verification')
        notes_path = (ROOT / notes_source).resolve()
        if not notes_path.is_relative_to(ROOT):
            raise ValueError('Coordinator notes must be within the git workspace')
        notes = read_json(notes_path)
        if not isinstance(notes, dict) or set(notes) - set(ids):
            raise ValueError('Coordinator notes must map selected paper IDs to review guidance')
        if any(not isinstance(value, (dict, list)) for value in notes.values()):
            raise ValueError('Each paper note must be a JSON object or array')
    name = f'{args.kind}_{number:02}'
    stage = stage_path(name)
    stage.mkdir()
    for directory in ('results', 'reading_derivatives', 'previews'):
        (stage / directory).mkdir()
    shutil.copytree(ROOT / 'skills/extract-accounting-models', stage / 'skill_snapshot',
                    ignore=shutil.ignore_patterns('__pycache__', '*.pyc'))
    (stage / 'manifest.jsonl').write_text(''.join(json.dumps(r, ensure_ascii=False) + '\n' for r in selected))
    run = {'round': number, 'kind': args.label, 'status': 'running', 'started_at': now(),
           'model': 'gpt-6-luna', 'reasoning_effort': 'max', 'paper_ids': ids,
           'skill_sha256': {str(p.relative_to(stage / 'skill_snapshot')): sha(p)
                           for p in (stage / 'skill_snapshot').rglob('*') if p.is_file()},
           'output_directory': str(stage.relative_to(ROOT)), 'batches': []}
    if previous_name:
        run.update(previous_stage=previous_name, previous_results=previous_inputs)
    if notes_source:
        directory = stage / 'coordinator_notes'
        directory.mkdir()
        run['coordinator_notes_source'] = {'path': str(notes_path.relative_to(ROOT)),
                                           'sha256': sha(notes_path)}
        run['coordinator_notes'] = {}
        for pid, guidance in notes.items():
            path = directory / f'{pid}.json'
            write_json(path, guidance)
            run['coordinator_notes'][pid] = {'path': str(path.relative_to(ROOT)),
                                               'sha256': sha(path)}
    run['reading_policy'] = 'supplied_only'
    run['reading_overrides'] = {}
    registry_path = RUNS / 'verified_readings.json'
    if registry_path.is_file():
        registry = read_json(registry_path)
        originals = {r['paper_id']: r for r in manifest}
        for pid in ids:
            if pid not in registry:
                continue
            entry = registry[pid]
            path = (ROOT / entry['path']).resolve()
            if not path.is_relative_to(ROOT) or sha(path) != entry['sha256']:
                raise ValueError(f'Invalid verified reading for {pid}')
            if entry['original_reading_sha256'] != originals[pid]['reading_json_sha256'] or entry['pdf_sha256'] != originals[pid]['pdf_sha256']:
                raise ValueError(f'Verified reading provenance mismatch for {pid}')
            run['reading_overrides'][pid] = entry
    synchronize(stage, run)
    print(json.dumps({'stage': name, 'papers': len(ids)}))


def check_frozen_instructions(run):
    entries = []
    if run.get('verification_protocol'):
        entries.append(('verification protocol', run['verification_protocol']))
    entries.extend(('clarification', entry) for entry in run.get('clarifications', []))
    for amendment in run.get('reading_input_amendments', []):
        for field in ('previous_reading', 'new_reading', 'previous_run_snapshot'):
            entries.append((f'reading amendment {field}', amendment[field]))
    for label, entry in entries:
        path = (ROOT / entry['path']).resolve()
        if not path.is_relative_to(ROOT) or sha(path) != entry['sha256']:
            raise ValueError(f"Frozen {label} changed: {entry['path']}")


def assign(args):
    layout.writable_path(stage_path(args.stage),ROOT)
    if args.count < 1:
        raise ValueError('Batch count must be positive')
    stage = stage_path(args.stage)
    run = read_json(stage / 'run.json')
    check_frozen_instructions(run)
    manifest = {r['paper_id']: r for r in read_lines(RUNS / 'input_manifest.jsonl')}
    assigned = {pid for b in run.get('batches', []) for pid in b['paper_ids']}
    remaining = [pid for pid in run['paper_ids'] if pid not in assigned]
    ids = remaining[:args.count]
    if not ids:
        print(json.dumps({'assigned': 0}))
        return
    n = len(run.setdefault('batches', [])) + 1
    worklist = stage / f'batch_{n:03}.jsonl'
    batch_rows = []
    for pid in ids:
        row = dict(manifest[pid])
        row['result_json'] = str((stage / 'results' / f'{pid}.json').relative_to(ROOT))
        override = run.get('reading_overrides', {}).get(pid)
        if override:
            row.update(original_reading_json=row['reading_json'],
                       original_reading_json_sha256=row['reading_json_sha256'],
                       reading_json=override['path'], reading_json_sha256=override['sha256'],
                       reading_verification=override.get('verification', 'Coordinator-verified source transcription'))
        prior = run.get('previous_results', {}).get(pid)
        if prior:
            if sha(ROOT / prior['path']) != prior['sha256']:
                raise ValueError(f'Previous result changed for {pid}')
            row.update(previous_result=prior['path'], previous_result_sha256=prior['sha256'])
        note = run.get('coordinator_notes', {}).get(pid)
        if note:
            if sha(ROOT / note['path']) != note['sha256']:
                raise ValueError(f'Coordinator notes changed for {pid}')
            row.update(coordinator_notes=note['path'], coordinator_notes_sha256=note['sha256'])
        protocol = run.get('verification_protocol')
        if protocol:
            row.update(verification_protocol=protocol['path'],
                       verification_protocol_sha256=protocol['sha256'])
        if run.get('clarifications'):
            row['scope_clarifications'] = [
                {'path': entry['path'], 'sha256': entry['sha256']}
                for entry in run['clarifications']
            ]
        batch_rows.append(row)
    worklist.write_text(''.join(json.dumps(row, ensure_ascii=False) + '\n' for row in batch_rows))
    batch = {'batch': n, 'worker': args.worker, 'paper_ids': ids, 'assigned_at': now(),
             'worklist': str(worklist.relative_to(ROOT)), 'worklist_sha256': sha(worklist)}
    run['batches'].append(batch)
    synchronize(stage, run)
    print(json.dumps(batch))


def check_stage(stage):
    run = read_json(stage / 'run.json')
    check_frozen_instructions(run)
    for batch in run.get('batches', []):
        worklist = (ROOT / batch['worklist']).resolve()
        if not worklist.is_relative_to(ROOT) or sha(worklist) != batch['worklist_sha256']:
            raise ValueError(f"Frozen worklist changed: {batch['worklist']}")
    for rel, expected in run['skill_sha256'].items():
        if sha(stage / 'skill_snapshot' / rel) != expected:
            raise ValueError(f'Frozen skill changed: {rel}')
    for pid, entry in run.get('previous_results', {}).items():
        prior = (ROOT / entry['path']).resolve()
        if not prior.is_relative_to(ROOT) or sha(prior) != entry['sha256']:
            raise ValueError(f'Frozen previous result changed: {pid}')
    for pid, entry in run.get('coordinator_notes', {}).items():
        note = (ROOT / entry['path']).resolve()
        if not note.is_relative_to(ROOT) or sha(note) != entry['sha256']:
            raise ValueError(f'Frozen coordinator notes changed: {pid}')
    spec = importlib.util.spec_from_file_location('run_model_validator', stage / 'skill_snapshot/scripts/validate_extraction.py')
    validator = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(validator)
    workflow = read_json(WORKFLOW)
    if sha(ROOT / workflow['input_file']) != workflow['input_sha256']:
        raise ValueError('Shortlist changed')
    samples = {r['paper_id']: r for r in read_lines(ROOT / workflow['input_file'])}
    manifest = {r['paper_id']: r for r in read_lines(RUNS / 'input_manifest.jsonl')}
    reports = []
    records = []
    for pid in run['paper_ids']:
        path = stage / 'results' / f'{pid}.json'
        report = {'paper_id': pid, 'present': path.is_file(), 'valid': False}
        if path.is_file():
            try:
                data = read_json(path)
                reading = (ROOT / data['paper_text_file']).resolve() if data.get('paper_text_file') else None
                if reading and not reading.is_relative_to(ROOT):
                    raise ValueError('Reading copy is outside git workspace')
                paper = read_json(reading) if reading else None
                errors = validator.validate(data, paper, samples[pid])
                if data['paper_id'] != pid:
                    errors.append('Filename/paper ID mismatch')
                if paper is None and data['status'] != 'text_unavailable':
                    errors.append('Source-aware validation requires a reading copy')
                original = manifest[pid]
                if run.get('reading_policy') == 'supplied_only' and reading:
                    override = run.get('reading_overrides', {}).get(pid)
                    expected_path = (ROOT / (override['path'] if override else original['reading_json'])).resolve()
                    expected_sha = override['sha256'] if override else original['reading_json_sha256']
                    if reading != expected_path or sha(reading) != expected_sha:
                        errors.append('Reading copy is not the frozen supplied input; self-authored mathematical evidence is not permitted')
                if (data.get('doi') or '').lower() != (original.get('doi') or '').lower():
                    errors.append('DOI differs from input manifest')
                for field, hash_field in [('reading_json', 'reading_json_sha256'), ('pdf_path', 'pdf_sha256')]:
                    if sha(ROOT / original[field]) != original[hash_field]:
                        errors.append(f'Original input changed: {field}')
                report.update(valid=not errors, errors=errors, result_sha256=sha(path),
                              reading_json_sha256=sha(reading) if reading else None,
                              paper_text_file=data['paper_text_file'], status=data['status'],
                              models=len(data['models']), baseline_models=sum(m['model_role'] == 'baseline' for m in data['models']),
                              supporting_models=sum(m['model_role'] == 'supporting' for m in data['models']))
                records.append(data)
            except (OSError, ValueError, KeyError, TypeError) as exc:
                report['errors'] = [str(exc)]
        reports.append(report)
    expected = set(run['paper_ids'])
    extras = [p.name for p in (stage / 'results').glob('*.json') if p.stem not in expected]
    summary = {'checked_at': now(), 'expected': len(reports), 'present': sum(r['present'] for r in reports),
               'valid': sum(r['valid'] for r in reports), 'extra_result_files': extras,
               'status_counts': dict(Counter(r.get('status') for r in reports if r['present'])),
               'models': sum(r.get('models', 0) for r in reports),
               'baseline_models': sum(r.get('baseline_models', 0) for r in reports),
               'supporting_models': sum(r.get('supporting_models', 0) for r in reports), 'records': reports}
    write_json(stage / 'validation.json', summary)
    return run, summary, records


def check(args):
    _, summary, _ = check_stage(stage_path(args.stage))
    print(json.dumps({k: v for k, v in summary.items() if k != 'records'}))
    bad = [r for r in summary['records'] if r['present'] and not r['valid']]
    if bad:
        print(json.dumps({'invalid': bad}, ensure_ascii=False))
    return bool(bad or summary['extra_result_files'])


def finish(args):
    layout.writable_path(stage_path(args.stage),ROOT)
    stage = stage_path(args.stage)
    run, summary, records = check_stage(stage)
    if summary['valid'] != summary['expected'] or summary['extra_result_files']:
        raise ValueError('All expected records must validate before completion')
    if not (stage / 'parent_review.json').is_file():
        raise ValueError('Parent review report required before completion')
    run.update(status='complete', completed_at=now(), final_counts={k: summary[k] for k in
               ('expected', 'valid', 'models', 'baseline_models', 'supporting_models', 'status_counts')})
    synchronize(stage, run)
    if args.publish:
        if not args.stage.startswith('sweep_'):
            raise ValueError('Publish only a full sweep')
        publication = RUNS / 'publication' if layout.manifest(ROOT) else ROOT / 'output'
        publication.mkdir(parents=True, exist_ok=True)
        target = publication / 'model_extractions'
        target.mkdir(exist_ok=True)
        for r in records:
            shutil.copyfile(stage / 'results' / f"{r['paper_id']}.json", target / f"{r['paper_id']}.json")
        aggregate = publication / 'model_extractions.jsonl'
        tmp = aggregate.with_suffix('.jsonl.tmp')
        tmp.write_text(''.join(json.dumps(r, ensure_ascii=False) + '\n' for r in records))
        tmp.replace(aggregate)
        queue = [{'paper_id': r['paper_id'], 'status': r['status'], 'review_notes': r['review_notes'],
                  'models': [{'model_id': m['model_id'], 'missing_fields': m['missing_fields'], 'review_notes': m['review_notes']}
                             for m in r['models'] if m['missing_fields'] or m['review_notes']]}
                 for r in records if r['status'] != 'complete']
        write_json(publication / 'model_review_queue.json', queue)
        write_json(publication / 'model_extraction_index.json', {'stage': args.stage, 'published_at': now(),
                   'aggregate_sha256': sha(aggregate), 'input_sha256': read_json(WORKFLOW)['input_sha256'],
                   'counts': run['final_counts'], 'records': summary['records']})
        workflow = read_json(WORKFLOW)
        workflow.update(status='complete', completed_at=now(), published_stage=args.stage)
        write_json(WORKFLOW, workflow)
    print(json.dumps({'stage': args.stage, 'status': 'complete', 'published': args.publish, **run['final_counts']}))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    sub = p.add_subparsers(dest='command', required=True)
    s = sub.add_parser('prepare'); s.add_argument('kind', choices=['pilot', 'sweep']); s.add_argument('--label', required=True); s.add_argument('--ids', nargs='+'); s.add_argument('--previous-stage', help='Completed full sweep whose frozen results may be inspected during verification'); s.add_argument('--review-notes', help='Paper-ID-to-guidance JSON mapping to freeze for verification'); s.set_defaults(func=prepare)
    s = sub.add_parser('assign'); s.add_argument('stage'); s.add_argument('--worker', required=True); s.add_argument('--count', type=int, default=3); s.set_defaults(func=assign)
    s = sub.add_parser('check'); s.add_argument('stage'); s.set_defaults(func=check)
    s = sub.add_parser('finish'); s.add_argument('stage'); s.add_argument('--publish', action='store_true'); s.set_defaults(func=finish)
    args = p.parse_args()
    try:
        return int(bool(args.func(args)))
    except (OSError, ValueError, KeyError) as exc:
        p.exit(1, f'{exc}\n')


if __name__ == '__main__':
    sys.exit(main())
