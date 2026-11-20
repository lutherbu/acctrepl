#!/usr/bin/env python3
"""Coordinate fresh Luna assignments and one extended-period workflow per package."""
from __future__ import annotations

import argparse
import calendar
from collections import Counter
from contextlib import contextmanager
from datetime import date, datetime, timezone
import fcntl
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import project_layout as layout
from scripts import reproduction_runs as reproduction
from scripts import deposit_reproduction
from scripts.feasibility_verdict import matches_frozen_input

BASE = ROOT / '.local/runs/extended_replications'
SKILL = ROOT / 'skills/replicate-extended-samples'
PUBLIC = ROOT / 'output/replications/packages'
WORKER = {'model': 'gpt-6-luna', 'reasoning_effort': 'max', 'fresh_context': True}
MODEL = WORKER['model']
ID = re.compile(r'[A-Za-z0-9][A-Za-z0-9_-]*\Z')
KEY = re.compile(r'[A-Za-z][A-Za-z0-9_]{0,63}\Z')
STATUS = {'extended_full', 'extended_partial', 'no_added_observations', 'not_applicable',
          'blocked', 'prior_unexecuted', 'failed', 'unverified'}
EXTENDED = {'extended_full', 'extended_partial'}
CODE_FILES = ('build.sas', 'stata.ipynb', 'design.md', 'submission.json', 'work_item.json', 'stata.template.ipynb')


def now():
    return datetime.now(timezone.utc).isoformat()


def need(condition, message):
    if not condition:
        raise ValueError(message)


def read(path):
    return json.loads(Path(path).read_bytes())


def encode(obj):
    return (json.dumps(obj, indent=2, ensure_ascii=False, allow_nan=False) + '\n').encode()


def write(path, obj):
    write_bytes(path, encode(obj))


def write_bytes(path, data):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.is_file() and path.read_bytes() == data:
        return
    with tempfile.NamedTemporaryFile(dir=path.parent, delete=False) as f:
        temporary = Path(f.name)
        f.write(data)
        f.flush()
        os.fsync(f.fileno())
    temporary.replace(path)


def sha(path):
    return layout.sha(path)


def tree(root):
    return {p.relative_to(root).as_posix(): sha(p) for p in sorted(root.rglob('*'))
            if p.is_file() and '__pycache__' not in p.parts}


def inside(root, relative):
    name = Path(relative)
    need(not name.is_absolute() and '..' not in name.parts and name.parts, 'Expected a relative file path')
    result = root / name
    need(result.resolve().is_relative_to(root.resolve()) and not any(p.is_symlink() for p in (result,*result.parents)),
         f'Untrusted path: {relative}')
    return result


def bounded_years(value):
    n = int(value)
    need(n > 0, 'years must be a positive integer')
    return n


def root_for(years):
    return BASE / f'years_{bounded_years(years)}'


@contextmanager
def locked(path):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('a') as stream:
        fcntl.flock(stream, fcntl.LOCK_EX)
        yield


def inventory(paper=None):
    with layout.active_path('papers_jsonl').open('rb') as f:
        selected = [row for row in map(json.loads, f)
                    if (paper is None or row['paper_id'] == paper)
                    and (row.get('reproduction_path') or row.get('execution_path'))]
    ids = [row['paper_id'] for row in selected]
    need(len(ids) == len(set(ids)) and all(ID.fullmatch(x) for x in ids), 'Expected distinct paper IDs')
    result = []
    for row in selected:
        pid = row['paper_id']
        previous = read(inside(ROOT, row['reproduction_path'])) if row['reproduction_path'] else None
        # Keep separate deposit follow-ups out of the historical batch inventory.
        deposit = previous is not None and previous.get('route') == 'author_deposit'
        rebuilt = previous is not None and (not deposit or paper is not None)
        if not rebuilt and not row['execution_path']:
            continue
        need(not (rebuilt and row['execution_path'] and not deposit), 'Expected one historical route per package')
        paths = {'sample': row['sample_path'], 'models': row['model_path'],
                 'predecessor': row['reproduction_path'] if rebuilt else row['execution_path'],
                 'feasibility': row['feasibility_reproduction_path'] if rebuilt and not deposit else row['feasibility_execution_path']}
        need(all(paths.values()), f'Missing sample, model or feasibility record for {pid}')
        hashes = {key: sha(inside(ROOT, rel)) for key, rel in paths.items()}
        if rebuilt:
            need(previous['paper_id'] == pid, 'Reconstruction ID mismatch')
            accepted = read((ROOT / paths['predecessor']).parents[1] / 'accepted.json')
            need(hashes['predecessor'] == accepted['outcome_sha256'], 'Accepted reconstruction hash changed')
            if deposit:
                scopes = [{'scope_id': f"{f['model_id']} / {f['result_set_id']}", 'cell': None,
                           'table': f.get('evidence_path'), 'worked': f['execution_status'] == 'executed',
                           'previous_note': f['execution_detail']} for f in previous['fits']]
                work_item = Path(paths['predecessor']).with_name('work_item.json')
                paths['deposit_inventory'] = work_item.as_posix()
                hashes['deposit_inventory'] = previous['files']['work_item.json']
            else:
                scopes = [{'scope_id': f"{f['model_id']} / {f['result_set_id']}", 'cell': f['cell_id'],
                           'table': f['table_basename'], 'worked': f['execution_status'] == 'executed',
                           'previous_note': f.get('blocked_reason') or None} for f in previous['fits']]
        else:
            previous = read(ROOT / paths['predecessor'])
            need(previous['package_id'] == pid, 'Execution ID mismatch')
            review = read((ROOT / paths['predecessor']).parent / 'review.json')
            need(hashes['predecessor'] == review['report']['sha256'], 'Accepted author report hash changed')
            paths['local_inputs'] = (Path(paths['predecessor']).parent / 'local_inputs.json').as_posix()
            hashes['local_inputs'] = sha(ROOT / paths['local_inputs'])
            scopes = [{'scope_id': s['stage_id'], 'cell': s['stage_id'], 'worked': s['status'] == 'succeeded',
                       'previous_note': s.get('note')} for s in previous['stage_results']]
        need(scopes and len({s['scope_id'] for s in scopes}) == len(scopes), 'Missing or duplicate predecessor scope')
        route = ('author_deposit' if deposit else 'reconstruction') if rebuilt else 'author'
        result.append({'paper_id': pid, 'doi': row['doi'], 'title': row['title'], 'route': route,
                       'sources': paths, 'hashes': hashes, 'scopes': scopes,
                       'prior_gaps': previous.get('limitations' if route == 'author_deposit' else 'gaps', [])})
    return sorted(result, key=lambda row: row['paper_id'])


def prepare_inventory(years):
    root = root_for(years)
    with locked(root / 'control.lock'):
        p = root / 'inventory.json'
        data = inventory()
        if p.is_file():
            need(read(p) == data, 'Pinned input inventory differs from current catalog or predecessor')
        else:
            write(p, data)
    return data


def runtime_hashes():
    files = ('scripts/extended_replication_runs.py', 'scripts/reproduction_runs.py',
             'skills/execute-author-analysis/scripts/runner.py', 'project_layout.py')
    return {name: sha(ROOT/name) for name in files}


def freeze(years):
    root = root_for(years)
    prepare_inventory(years)
    with locked(root / 'control.lock'):
        for job in (root / 'pilot').glob('*/task.json'):
            need((job.parent / 'report.json').is_file(), 'Finish and evaluate reserved pilots before freezing')
        target = root / 'sweep_skill'
        if target.exists():
            need(tree(target) == tree(SKILL), 'Full sweep skill is already frozen at another revision')
        else:
            shutil.copytree(SKILL, target, ignore=shutil.ignore_patterns('__pycache__'))
        record = {'skill': tree(target), 'inventory_sha256': sha(root / 'inventory.json'),
                  'runtime_files': runtime_hashes(), 'worker': WORKER, 'years': years}
        manifest = root / 'freeze.json'
        if manifest.exists():
            existing = read(manifest)
            need(all(existing.get(k)==v for k,v in record.items()),'The frozen sweep protocol has changed')
        else:
            write(manifest, record)
    return str(target)


def stage_reconstruction(working, predecessor):
    for name in CODE_FILES:
        shutil.copy2(predecessor / name, working / name)
    shutil.copytree(predecessor / 'skill_snapshot', working / 'skill_snapshot', ignore=shutil.ignore_patterns('__pycache__'))
    # Only the published notebook's relative reference changes when copied here.
    nb = read(working / 'stata.ipynb')
    for cell in nb['cells']:
        if cell['cell_type'] != 'code':
            continue
        text = reproduction.source(cell)
        ado = os.path.relpath(layout.active_path('ado'), working)
        text = re.sub(r'(?m)^([ \t]*adopath\s+\+\+\s+)"[^"\n]*/ado"',
                      lambda m: m[1] + '"' + ado + '"', text)
        cell['source'] = text.splitlines(keepends=True)
        cell['outputs'] = []
        cell['execution_count'] = None
    write(working / 'stata.ipynb', nb)
    for name in ['audit', 'scratch', 'data', 'tables', 'figures', '.work']:
        (working / name).mkdir(exist_ok=True)
    reproduction.sync(working)


def stage_author(job, predecessor, previous):
    from scripts import prepare_author_replay
    from scripts import materialize_execution_inputs
    materialize_execution_inputs.prepare(ROOT, predecessor.name)
    plan = prepare_author_replay.stage(predecessor, job, authorization=os.environ.get('ACCTREPL_MATLAB_AUTHORIZATION'))
    shutil.copyfile(plan, job / 'author_plan.json')


def initial_row(scope, i):
    return {'scope_id': scope['scope_id'], 'key': f's{i}', 'label': scope['scope_id'],
            'sample_ids': [], 'status': 'pending' if scope['worked'] else 'prior_unexecuted',
            'reason': scope.get('previous_note') if not scope['worked'] else '', 'source_evidence': [],
            'original_begin': None, 'original_end': None, 'requested_end': None, 'supported_end': None,
            'last_added': None, 'count_unit': None, 'original_n': None, 'added_n': None,
            'native_log': None, 'artifacts': [], 'comparison': None}


def prepare(phase, pid, years):
    root = root_for(years)
    need(ID.fullmatch(pid) and phase in ('paper', 'pilot', 'sweep'), 'Invalid paper or phase')
    if phase == 'paper':
        items = inventory(pid)
    else:
        items = read(root / 'inventory.json') if (root / 'inventory.json').exists() else prepare_inventory(years)
    item = next((r for r in items if r['paper_id'] == pid), None)
    need(item is not None, 'Unknown package')
    job = root / phase / pid
    with locked(root / 'control.lock'):
        if (job / 'task.json').exists():
            return job
        if phase in ('paper', 'pilot'):
            need(phase == 'paper' or not (root / 'freeze.json').exists(), 'Pilot selection or quota exceeded, or sweep frozen')
            skill = SKILL
        else:
            frozen = read(root / 'freeze.json')
            skill = root / 'sweep_skill'
            need(frozen['skill'] == tree(skill) and frozen['inventory_sha256'] == sha(root/'inventory.json')
                 and frozen['runtime_files'] == runtime_hashes(), 'Invalid sweep snapshot')
        need(not job.exists(), 'Interrupted preparation: inspect before continuing')
        job.mkdir(parents=True)
        try:
            for k, p in item['sources'].items():
                need(matches_frozen_input(inside(ROOT, p), item['hashes'][k], ROOT, sha), 'Pinned source changed: ' + p)
            shutil.copytree(skill, job / 'skill', ignore=shutil.ignore_patterns('__pycache__'))
            work = job / 'work'
            work.mkdir()
            predecessor = (ROOT / item['sources']['predecessor']).parent
            previous = read(ROOT / item['sources']['predecessor'])
            base_code = {}
            if item['route'] == 'reconstruction':
                stage_reconstruction(work, predecessor)
                for name in ['build.sas', 'stata.ipynb', 'submission.json']:
                    base_code['work/'+name] = {'path': (predecessor / name).relative_to(ROOT).as_posix(), 'sha256': sha(predecessor / name)}
            elif item['route'] == 'author_deposit':
                deposit_reproduction.verify_publication(ROOT, predecessor, previous, with_data=True)
                for name, digest in previous['files'].items():
                    if Path(name).suffix.lower() in deposit_reproduction.CODE:
                        target = inside(work, name)
                        target.parent.mkdir(parents=True, exist_ok=True)
                        shutil.copy2(inside(predecessor, name), target)
                        base_code['work/'+name] = {'path': (predecessor/name).relative_to(ROOT).as_posix(), 'sha256': digest}
            else:
                stage_author(job, predecessor, previous)
                for f in read(predecessor / 'local_inputs.json')['files']:
                    if f['role'] == 'code':
                        base_code[f['path']] = {'path': (predecessor / f['template']).relative_to(ROOT).as_posix(), 'sha256': f['template_sha256']}
            samples = read(ROOT / item['sources']['sample'])
            task = dict(item, schema_version='1.0', phase=phase, years=years, repository=str(ROOT),
                        worker=WORKER, skill_files=tree(job/'skill'), base_code=base_code,
                        samples=[{k:s[k] for k in ('sample_id','sample_label','sample_unit','sample_period','period_detail')} for s in samples['samples']],
                        commands={cmd: [sys.executable,str(Path(__file__).resolve()),cmd,'--job',str(job)]
                                  for cmd in ('validate','execute','finish')})
            write(job / 'draft.json', {'paper_id': pid, 'years': years,'sources_checked': [], 'changes': [],
                                       'limitations': [], 'analyses': [initial_row(s,i) for i,s in enumerate(item['scopes'],1)]})
            write(job / 'task.json', task)
            write(job / 'identity.json', {'task_sha256': sha(job / 'task.json'), 'skill_files': tree(job/'skill')})
        except BaseException:
            # No reservation is visible before prepare returns, and nothing has been launched.
            shutil.rmtree(job)
            raise
    return job


def context(job):
    job = Path(os.path.abspath(job))
    need(job == job.resolve() and job.parents[2] == BASE and job.parent.name in ('paper','pilot','sweep')
         and ID.fullmatch(job.name), 'Expected a prepared campaign job')
    task = read(job / 'task.json')
    identity = read(job / 'identity.json')
    need(job.parents[1] == root_for(task['years']) and task['paper_id'] == job.name
         and task['phase'] == job.parent.name and identity['task_sha256'] == sha(job/'task.json')
         and identity['skill_files'] == tree(job/'skill') == task['skill_files'], 'Job identity or skill changed')
    return job, task


def register(job, agent, model, effort):
    job, task = context(job)
    need(model == MODEL and effort == 'max' and isinstance(agent,str) and agent.strip(),
         'One fresh, explicitly selected gpt-6-luna/max worker is required')
    identity = {'agent': agent, **WORKER}
    with locked(job.parents[1] / 'control.lock'):
        for p in job.parents[1].glob('*/*/worker.json'):
            if p.parent != job:
                need(read(p)['agent'] != agent, 'Another package already uses this worker')
        path = job / 'worker.json'
        need(not path.exists() or read(path) == identity, 'A worker already owns this package')
        write(path, identity)
    return identity


def source_checks(job, task):
    for key, rel in task['sources'].items():
        need(matches_frozen_input(inside(ROOT, rel), task['hashes'][key], ROOT, sha), 'Pinned source changed: '+rel)
    for source in task['base_code'].values():
        need(sha(inside(ROOT,source['path'])) == source['sha256'], 'Accepted code changed: '+source['path'])
    if task['route'] == 'author_deposit':
        deposit_reproduction.verify_work(ROOT, read(ROOT / task['sources']['deposit_inventory']), with_data=True)
    if task['phase'] == 'sweep':
        frozen = read(job.parents[1]/'freeze.json')
        need(frozen['skill'] == task['skill_files'] and frozen['runtime_files'] == runtime_hashes(),
             'Sweep protocol differs from its frozen skill or native runtime')


def author_runner():
    path = ROOT / 'skills/execute-author-analysis/scripts/runner.py'
    spec = importlib.util.spec_from_file_location('extended_author_runner', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def author_builders(job, task, plan, original):
    """Bind existing preparation programs to the focal package's screened source inventory."""
    stages = {s['id']:s for s in original['stages']}
    extra = [s for s in plan['stages'] if s['id'] not in stages]
    if not extra:
        return {}
    needed = {parent for s in plan['stages'] for parent in s['depends_on']}
    # Verify any additional source program against this paper's authorized archive.
    import zipfile
    package_dir = inside(ROOT, task['sources']['predecessor']).parent
    recipe = read(package_dir / 'local_inputs.json')
    source_zip = inside(ROOT, recipe['archive']['path'])
    need(sha(source_zip) == recipe['archive']['sha256'], 'Author archive checksum mismatch')
    package = job / 'frozen' / 'source_builders'
    package.mkdir(exist_ok=True)
    known = {}
    with zipfile.ZipFile(source_zip) as archive:
        for stage in extra:
            entries = stage.get('source_entry_points', [])
            need(len(entries) == 1, 'Identify one source program per additional stage')
            name = entries[0]
            selected = [i for i in archive.infolist() if i.filename == name and not i.is_dir()]
            need(len(selected) == 1 and selected[0].file_size <= 16 * 1024 * 1024, 'Missing, ambiguous or oversized source program')
            target = inside(package, name)
            write_bytes(target, archive.read(selected[0]))
            known[name] = sha(target)
    suffixes = {'r':'.r','matlab':'.m','stata':'.do'}
    builders = {}
    for stage in extra:
        entries = stage.get('source_entry_points',[])
        need(stage['id'].startswith('prepare_') and stage['id'] in needed and len(entries)==1,
             'Additional author stages must be dependencies tied to one existing preparation program')
        member = entries[0]
        raw_code = inside(package,member)
        need(member in known and sha(raw_code)==known[member] and
             raw_code.suffix.lower()==suffixes.get(stage['language']), 'Unsupported or unverified author builder')
        working = inside(job,stage['script'])
        need(working.is_relative_to(job/'work') and working.suffix.lower()==raw_code.suffix.lower(),
             'Stage the existing builder as reviewed source code under work/')
        builders[stage['script']] = {'path':os.path.relpath(raw_code,ROOT), 'sha256':known[member],
                                     'member':member}
    return builders


def author_plan(job):
    plan = read(job / 'author_plan.json')
    original = read(job / 'frozen/original_plan.json')
    approved = {s['id']: s for s in original['stages']}
    task = read(job/'task.json')
    author_builders(job,task,plan,original)
    need(any(s['id'] in approved for s in plan['stages']), 'Include a previously accepted analysis stage')
    for s in plan['stages']:
        prev = approved.get(s['id'])
        if prev is not None:
            need(prev['language'] == s['language'], 'Unexpected author stage language')
    need(plan['attempt_id'] == job.name, 'Author plan must use the assigned paper ID as attempt_id')
    plan_path = job / 'frozen/extension_plan.json'
    write(plan_path, plan)
    author_runner().validate_plan(job, plan_path)
    return plan_path


def selected_cells(job,task):
    original = {s['cell'] for s in task['scopes'] if s['worked']}
    fits = read(job/'work/submission.json')['fits']
    return original & {f['cell_id'] for f in fits if not f.get('blocked_reason')}


def preflight_stata_setup(work, task, cells):
    """Check setup before reserving the only workflow; inspect column metadata, never observations."""
    ado=layout.active_path('ado').resolve()
    predecessor=inside(ROOT,task['sources']['predecessor']).parent
    prior=read(predecessor/'submission.json')['samples']
    current=read(work/'submission.json')['samples']
    originals={s['sample_id']:s['dta_file'] for s in prior}
    handoffs={s['dta_file']:originals[s['sample_id']] for s in current if s['sample_id'] in originals}
    warnings=[]
    cache={}
    for cell in cells:
        source=reproduction.source(cell)
        for name in re.findall(r'(?im)^\s*adopath\s+\+\+\s+"([^"$\n]+)"',source):
            path=Path(name)
            if path.name == 'ado':
                need((work/path).resolve()==ado and ado.is_dir(),
                     f"Stata cell {cell['id']} sets the wrong shared ado path. Use {os.path.relpath(ado,work)} from this job's work directory.")
        datasets=re.findall(r'(?im)^\s*use\s+"([^"\n]+)"\s*,\s*clear\b',source)
        if len(datasets)!=1 or datasets[0] not in handoffs or re.search(r'(?im)^\s*(?:cap(?:ture)?\s+)?ren(?:ame)?\s',source):
            continue
        original=inside(predecessor,handoffs[datasets[0]])
        if not original.is_file():
            continue
        if original not in cache:
            try:
                import pyreadstat
            except ImportError:
                names=[]
            else:
                try:
                    names=pyreadstat.read_dta(original,metadataonly=True)[1].column_names
                except (OSError,ValueError,pyreadstat.ReadstatError):
                    names=[]
            cache[original]={name.lower():name for name in names}
        schema=cache[original]
        diagnostic_lines=[]
        for block in source.split('EXT_SAMPLE')[:-1]:
            diagnostic_lines.extend(line for line in block.splitlines()[-18:]
                                    if re.match(r'^\s*(?:(?:qui(?:etly)?|cap(?:ture)?)\s+)*(?:count|su(?:mm(?:arize)?)?|tab(?:ulate)?)\s',line,re.I))
        for word in sorted(set(re.findall(r'\b[A-Za-z_]\w*\b(?!\s*\()', '\n'.join(diagnostic_lines)))):
            actual=schema.get(word.lower())
            if actual and actual!=word:
                warnings.append(f"Stata cell {cell['id']} uses {word} in a sample diagnostic; the accepted handoff contains {actual}. Verify the exact Stata name or normalize it explicitly before running.")
    return warnings


def validate(job):
    job, task = context(job)
    source_checks(job,task)
    if task['route'] == 'author_deposit':
        return {'valid': True, 'route': task['route'], 'native_plan': None}
    if task['route'] == 'reconstruction':
        work = job / 'work'
        need(not (work/'runtime/latest.json').exists() or (job/'launch.json').exists(), 'Found a predecessor run in the fresh work area')
        reproduction.sync(work)
        checks = reproduction.validate(work)
        need(checks['valid'], 'Native preflight failed: ' + '; '.join(checks['errors']))
        selected = selected_cells(job,task)
        cells=[c for c in read(work/'stata.ipynb')['cells'] if c.get('id') in selected]
        for c in cells:
            need(re.search(r'using\s+"[^"\n]+\.(?:md|rtf|csv|tex)"', reproduction.source(c), re.I),
                 'A selected Stata cell needs a literal aggregate output path: '+c['id'])
        if not (job/'launch.json').exists():
            checks['warnings'].extend(preflight_stata_setup(work,task,cells))
        return {'valid': True, 'route': task['route'], 'warnings': checks['warnings']}
    if (job/'author_plan.json').exists():
        author_plan(job)
    return {'valid': True, 'route': task['route'], 'author_plan': (job/'author_plan.json').exists()}


def source_vintage(job,task):
    if task['route'] == 'author':
        plan = read(job/'author_plan.json')
        return [{'path': f['path'], 'sha256': f['sha256']} for f in plan['inputs']]
    sub = read(job / 'work/submission.json')
    item = read(job / 'work/work_item.json')
    catalog = read(layout.resolve_path(item['catalog_path']))
    paths = {d['dataset']:d['path'] for d in catalog['datasets']}
    result = []
    for name in sub.get('source_datasets', []):
        location = paths[name]
        stat = Path(os.path.expandvars(location)).stat()
        result.append({'dataset':name,'path':location,'bytes':stat.st_size,'mtime_ns':stat.st_mtime_ns})
    return result


def payloads(job,task):
    files = list(task['base_code'])
    if task['route'] == 'author':
        plan = read(job/'author_plan.json')
        files.extend(s['script'] for s in plan['stages'])
    return {p:code_digest(inside(job,p)) for p in sorted(set(files))}


def collect_receipt(job, task, **result):
    launch = read(job/'launch.json')
    state = job/('work/runtime/latest.json' if task['route']=='reconstruction' else 'runtime/run.json')
    receipt = {'finished_at':now(), 'launch_sha256':sha(job/'launch.json'), **result,
               'state':state.relative_to(job).as_posix() if state.is_file() else None,
               'state_sha256':sha(state) if state.is_file() else None, 'proofs':{}}
    try:
        receipt['code_unchanged'] = payloads(job,task)==launch['code']
        receipt['inputs_unchanged'] = source_vintage(job,task)==launch['inputs']
        # The helper verifies a saved proof set only on subsequent reads.
        receipt['proofs'] = native_proofs(job,task,{k:v for k,v in receipt.items() if k!='proofs'})
    except (ValueError,KeyError,OSError) as error:
        receipt.update(ok=False,integrity_error=str(error))
    return receipt


def execute(job):
    job, task = context(job)
    with locked(job / 'native.lock'):
        if (job / 'launch.json').exists():
            raise ValueError('Scientific launch already reserved; inspect receipt/status. No automatic retry.')
        need((job/'worker.json').is_file() and not (job/'report.json').exists(), 'A fresh assigned, unfinished job is required')
        validate(job)
        need(task['route'] != 'author_deposit',
             'This deposit outcome has no registered native stages for an extension. '
             'A runnable extension needs a reviewed replay plan binding the accepted tests to native stages.')
        if task['route'] == 'reconstruction':
            work = job / 'work'
            need(selected_cells(job,task), 'No previously executed analysis cell is eligible for a native replay')
            need(not (work/'runtime').exists() and not any((work/'data').rglob('*.dta'))
                 and not any((work/'data').rglob('*.sas7bdat')), 'Fresh reconstruction must start without datasets or prior runtime state')
        else:
            need((job/'author_plan.json').is_file(), 'A reviewed author plan is required')
        codes = payloads(job,task)
        inputs = source_vintage(job,task)
        write(job/'launch.json', {'started_at':now(),'task_sha256':sha(job/'task.json'),
                                  'code':codes,'inputs':inputs,'worker':read(job/'worker.json')})
        try:
            if task['route'] == 'reconstruction':
                native = reproduction.run(job/'work',include_cells=selected_cells(job,task))
            else:
                native = author_runner().run(job,job/'frozen/extension_plan.json')
        except BaseException as error:
            receipt = collect_receipt(job,task,ok=False,error=f'{type(error).__name__}: {error}')
            write(job/'receipt.json',receipt)
            raise
        receipt = collect_receipt(job,task,ok=bool(native.get('ok',native.get('execution_verified',False))))
        write(job/'receipt.json',receipt)
    return receipt


def parse_period(value):
    s = str(value)
    need(re.fullmatch(r'\d{4}(?:-\d{2}(?:-\d{2})?)?',s), f'Invalid period {value!r}')
    parts = list(map(int,s.split('-')))
    day = date(*(parts+[1,1])[:3])
    return day, len(parts)


def extend(value, years):
    day, precision = parse_period(value)
    year = day.year + years
    last = calendar.monthrange(year,day.month)[1]
    return day.replace(year=year, day=min(day.day,last)).isoformat()[:(4,7,10)[precision-1]]


def endpoint(value):
    day, precision = parse_period(value)
    if precision == 1:
        return date(day.year,12,31)
    if precision == 2:
        return day.replace(day=calendar.monthrange(day.year,day.month)[1])
    return day


def native_proofs(job, task, receipt):
    if not receipt or receipt.get('integrity_error') or not receipt.get('state') or receipt.get('code_unchanged') is not True or receipt.get('inputs_unchanged') is not True:
        return {}
    state = inside(job,receipt['state'])
    launch = read(job/'launch.json')
    need(sha(state) == receipt['state_sha256'] and sha(job/'launch.json') == receipt['launch_sha256']
         and payloads(job,task) == launch['code'], 'Post-run state or code changed')
    d = read(state)
    scopes = {}
    def checked_path(p):
        rel = Path(p).relative_to(job).as_posix()
        return rel, inside(job,rel)
    if task['route'] == 'reconstruction':
        for cid, cell in d.get('cells',{}).items():
            if not cell.get('ok') or not reproduction.cell_log_valid(cell):
                continue
            rel, log = checked_path(cell['log'])
            outputs = {'work/'+name: value for name,value in cell['outputs'].items()}
            scopes[cid] = ({rel:sha(log)},outputs)
    else:
        need(d.get('original_inputs_unchanged') is True, 'Author input changed')
        for s in d.get('stages',[]):
            if s['status'] != 'succeeded':
                continue
            logs, outputs = {}, {}
            for f in [*s.get('native_logs',[]),s.get('stdout',{})]:
                if f and f.get('path'):
                    rel, p = checked_path(f['path'])
                    need(sha(p)==f['sha256'],'Native log changed')
                    logs[rel] = f['sha256']
            for f in s.get('outputs',[]):
                if f.get('fresh') and f.get('after_sha256'):
                    rel, p = checked_path(f['path'])
                    outputs[rel] = f['after_sha256']
            scopes[s['id']] = (logs,outputs)
    sealed = {key:list(value) for key,value in scopes.items()}
    if 'proofs' in receipt:
        need(sealed == receipt['proofs'], 'Native evidence has changed since the replay completed')
    return sealed


def check_row(row, scope, sample_ids, years, proofs, job, launched):
    status = row['status']
    need(status in STATUS and KEY.fullmatch(row['key']), 'Invalid disposition or native proof key')
    need(bool(row['reason'].strip()) and isinstance(row['source_evidence'],list) and row['source_evidence']
         and all(isinstance(s,str) and s.strip() for s in row['source_evidence']), 'Every analysis requires a reason and source references')
    need(set(row['sample_ids']) <= sample_ids, 'Unknown extracted sample ID')
    need(scope['worked'] == (status != 'prior_unexecuted'), 'Prior execution disposition changed')
    original, target = row['original_end'], row['requested_end']
    if original is not None:
        need(target is not None and str(target)==extend(original,years), 'Requested endpoint must equal original end + configured years')
    else:
        need(target is None, 'Requested endpoint needs an established original end')
    if status in ('failed','unverified'):
        need(launched, 'A failed or unverified scientific run requires a launch')
    if status not in EXTENDED:
        need(not row['artifacts'] and row.get('added_n') in (None,0), 'Only verified fits may publish extension outputs or positive counts')
        return
    need(bool(row['sample_ids']) and bool(row['count_unit']) and bool(row['comparison']), 'A successful scope requires sample link, count unit and comparison or limits')
    need(isinstance(row['artifacts'],list) and row['artifacts'], 'Successful scope needs fresh aggregate output')
    need(type(row['original_n']) is int and row['original_n'] > 0 and type(row['added_n']) is int and row['added_n']>0,
         'A pooled extension requires original and added observations')
    need(original is not None and row['original_begin'] is not None and row['supported_end'] is not None
         and row['last_added'] is not None, 'A successful scope needs dated coverage')
    need(parse_period(row['original_begin'])[0] <= endpoint(original) < endpoint(row['last_added'])
         <= endpoint(row['supported_end']) <= endpoint(target), 'Inconsistent intended and observed extension dates')
    need((status == 'extended_full') == (endpoint(row['supported_end'])==endpoint(target)), 'Full vs partial extension contradicts supported endpoint')
    need(scope['cell'] in proofs, 'The actual native fit cell/stage did not succeed')
    logs, outputs = proofs[scope['cell']]
    log = row['native_log']
    need(log in logs and sha(inside(job,log))==logs[log], 'Native evidence must belong to the actual successful cell/stage')
    marker = f"EXT_SAMPLE {row['key']} {row['original_n']} {row['added_n']} {row['last_added']}"
    with inside(job,log).open(errors='replace') as stream:
        need(any(' '.join(line.split())==marker for line in stream), 'Cannot verify fit counts and last observation in native log: '+marker)
    for rel in row['artifacts']:
        need(rel in outputs and sha(inside(job,rel))==outputs[rel], 'Expected fresh hash-bound aggregate output of this fit')
        need(Path(rel).suffix.lower() in {'.md','.csv','.rtf','.tex','.pdf','.png','.xlsx','.xls','.xml','.txt'},
             'Publish aggregate tables/figures only')


def finish(job):
    job, task = context(job)
    with locked(job/'native.lock'):
        source_checks(job,task)
        need((job/'worker.json').is_file(), 'Register the actual fresh agent before finishing')
        draft = read(job/'draft.json')
        need(draft['paper_id']==task['paper_id'] and draft['years']==task['years'], 'Mismatched draft')
        scopes = {s['scope_id']:s for s in task['scopes']}
        rows = draft['analyses']
        ids = {s['sample_id'] for s in task['samples']}
        need(set(scopes)=={r['scope_id'] for r in rows} and len({r['key'] for r in rows})==len(rows), 'Every assigned scope must have a disposition and unique keys')
        if task['route'] in ('reconstruction', 'author_deposit'):
            need(len(rows)==len(scopes),'One row is required per reconstruction model/result-set pair')
        need(isinstance(draft['sources_checked'],list) and draft['sources_checked'], 'Record the examined inputs/source vintages')
        receipt = read(job/'receipt.json') if (job/'receipt.json').exists() else None
        need(receipt is not None or not (job/'launch.json').exists(), 'Scientific work already reserved; reconcile its native receipt first')
        proofs = native_proofs(job,task,receipt)
        native_started = (job/'runtime/intent.json').is_file() if task['route']=='author' else (
            bool(receipt and receipt.get('state')) or any((job/'work/runtime').glob('*/build.log')))
        for row in rows:
            check_row(row,scopes[row['scope_id']],ids,task['years'],proofs,job,native_started)
        status_counts = dict(sorted(Counter(r['status'] for r in rows).items()))
        eligible = set(status_counts)-{'prior_unexecuted'}
        if eligible=={'extended_full'}: outcome='extended_full'
        elif eligible & EXTENDED: outcome='extended_partial'
        elif len(eligible)==1: outcome=next(iter(eligible))
        else: outcome='no_verified_extension'
        report = {'schema_version':'1.0', 'phase':task['phase'],'title':task['title'],'doi':task['doi'],'route':task['route'],
                  **draft, 'outcome':outcome,'counts':status_counts,'prior_gaps':task['prior_gaps'],
                  'worker':read(job/'worker.json'), 'inputs':task['sources'], 'input_hashes':task['hashes'],
                  'skill_files':task['skill_files'], 'native_receipt':receipt,
                  'native_run_launched':native_started}
        final = job/'report.json'
        need(not final.exists() or read(final)==report, 'Finalized report already exists with different contents')
        write(final,report)
    return {'paper_id':job.name,'outcome':outcome,'counts':status_counts}


def sanitized_notebook(path):
    nb = read(path)
    for c in nb['cells']:
        if c['cell_type']=='code':
            c['outputs'] = []
            c['execution_count'] = None
    return encode(nb)


def code_digest(path):
    return hashlib.sha256(sanitized_notebook(path)).hexdigest() if path.suffix=='.ipynb' else sha(path)


def publish_one(job, destination):
    job, task = context(job)
    check = finish(job)
    report = read(job/'report.json')
    destination.mkdir(parents=True,exist_ok=True)
    from scripts import publication as public
    originals = {'report.json':sha(job/'report.json')}
    policy = public.PublicPaths(task['paper_id'])
    output_refs = {}
    for row in report['analyses']:
        if row['status'] not in EXTENDED:
            continue
        for rel in row['artifacts']:
            p = inside(job,rel)
            exported = 'results/' + Path(rel).relative_to('work').as_posix()
            target = inside(destination,exported)
            target.parent.mkdir(parents=True,exist_ok=True)
            if not target.exists():
                public.transform_file(p,target,policy)
            if exported in originals:
                need(originals[exported]==sha(p),'Conflicting aggregate artifact: '+exported)
            originals[exported] = sha(p)
            output_refs[rel] = exported
        row['artifacts'] = [output_refs[rel] for rel in row['artifacts']]
        log = inside(job,row['native_log'])
        row['native_evidence'] = {'path':'urn:sha256:'+sha(log),'sha256':sha(log),
                                  'marker':f"EXT_SAMPLE {row['key']} {row['original_n']} {row['added_n']} {row['last_added']}"}
        row.pop('native_log')
    report['replay_code'] = []
    origins = dict(task['base_code'])
    if task['route']=='author' and (job/'author_plan.json').is_file():
        origins.update(author_builders(job,task,read(job/'author_plan.json'),read(job/'frozen/original_plan.json')))
    for rel, origin in origins.items():
        p = inside(job,rel)
        original = (ROOT/origin['path']).resolve() if 'member' in origin else inside(ROOT,origin['path'])
        if 'member' not in origin and code_digest(p)==code_digest(original):
            continue
        target_rel = 'code/' + Path(rel).relative_to('work').as_posix()
        target = inside(destination,target_rel)
        target.parent.mkdir(parents=True,exist_ok=True)
        if p.suffix=='.ipynb':
            target.write_bytes(policy.data(p.name,sanitized_notebook(p)))
        else:
            public.transform_file(p,target,policy)
        originals[target_rel] = sha(p)
        report['replay_code'].append({'path':target_rel,'working_path':rel,'sha256':sha(target),'predecessor':origin['path'],
                                      'predecessor_sha256':origin['sha256']})
    if report.get('native_receipt'):
        receipt = report['native_receipt']
        launch = read(job/'launch.json')
        report['native_receipt'] = {'path':'urn:sha256:'+sha(job/'receipt.json'),'sha256':sha(job/'receipt.json'),
                                    **{k:receipt[k] for k in ('ok','error','integrity_error','state_sha256','code_unchanged','inputs_unchanged')
                                       if k in receipt},
                                    'source_vintages':launch['inputs'], 'working_code_hashes':launch['code']}
    if task['route']=='author' and (job/'launch.json').exists():
        plan = read(job/'frozen/extension_plan.json')
        report['author_plan'] = {'runtime_profile':plan['sandbox']['profile'], 'limits':plan['limits'],
            'stages':[{k:s[k] for k in ('id','language','script','cwd','args','depends_on','source_entry_points',
                                       'expected_outputs','script_sha256') if k in s} for s in plan['stages']]}
    write(destination/'report.json',policy.document(report))
    public.receipt(destination,originals)
    return {'paper_id':task['paper_id'],'route':task['route'],'outcome':check['outcome'],'counts':check['counts'],
            'path':f"output/replications/packages/{job.name}/report.json",'sha256':sha(destination/'report.json')}


def summary_file(years):
    return layout.batch_reports('replications',ROOT)/f'years_{years}'/'summary.md'


def worker_outcome_tables(index):
    outcomes = index['package_outcomes']
    by_route = index['analysis_outcomes_by_route']
    lines = ['| Package outcome | Packages |','| --- | ---: |',
             *[f'| {k} | {v} |' for k,v in sorted(outcomes.items())], '',
             '| Analysis outcome | Reconstruction model/result sets | Author analyses |','| --- | ---: | ---: |']
    for status in sorted(STATUS):
        lines.append(f"| {status} | {by_route.get('reconstruction',{}).get(status,0)} | {by_route.get('author',{}).get(status,0)} |")
    return lines


def publish(years, paper=None):
    """Publish completed papers separately and keep past package versions locally."""
    from scripts import publication as public, rebuild_indexes
    root = root_for(years)
    if paper:
        need(bool(ID.fullmatch(paper)), 'Invalid paper ID')
    if paper and (root/'paper'/paper/'task.json').is_file():
        items = [{'paper_id': paper}]
    else:
        items = read(root / 'inventory.json')
        if paper:
            items = [item for item in items if item['paper_id'] == paper]
    need(items, 'No matching extended-sample assignment')
    PUBLIC.mkdir(exist_ok=True, parents=True)
    with locked(BASE / 'publication.lock'):
        papers = []
        for item in items:
            pid = item['paper_id']
            standalone = root/'paper'/pid
            job = standalone if paper and (standalone/'task.json').is_file() else root/'sweep'/pid
            if paper and job != standalone and not (job/'report.json').is_file():
                job = root / 'pilot' / pid
            need((job/'report.json').is_file(), 'Finish the assigned paper before publication: ' + pid)
            with public.staged_package(ROOT,'replications',pid) as stage:
                papers.append(publish_one(job,stage))
        rebuild_indexes.rebuild(ROOT)
    return {'published':len(papers), 'package_outcomes':dict(Counter(item['outcome'] for item in papers))}


def status(years):
    root = root_for(years)
    result = {}
    for phase in ('paper','pilot','sweep'):
        states = {}
        for p in sorted((root/phase).glob('*/task.json')):
            d = p.parent
            states[d.name] = (read(d/'report.json')['outcome'] if (d/'report.json').exists() else
                              'ran' if (d/'receipt.json').exists() else 'launch_reserved' if (d/'launch.json').exists() else
                              'assigned' if (d/'worker.json').exists() else 'prepared')
        result[phase] = states
    return {'years':years,'sweep_frozen':(root/'freeze.json').is_file(),**result}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    subs = parser.add_subparsers(dest='cmd',required=True)
    for name in ('inventory','prepare','freeze','status','publish'):
        p = subs.add_parser(name)
        p.add_argument('--years',type=bounded_years,default=5)
        if name=='publish':p.add_argument('--paper')
        if name=='prepare':
            p.add_argument('--phase',choices=('paper','pilot','sweep'),required=True)
            p.add_argument('--paper',required=True)
    for name in ('register','validate','execute','finish','reconcile'):
        p = subs.add_parser(name)
        p.add_argument('--job',type=Path,required=True)
        if name=='register':
            p.add_argument('--agent',required=True)
            p.add_argument('--model',required=True)
            p.add_argument('--effort',required=True)
    a = parser.parse_args()
    if a.cmd=='inventory':
        rows = prepare_inventory(a.years)
        value = {'packages':len(rows),'routes':dict(Counter(r['route'] for r in rows)),'path':str(root_for(a.years)/'inventory.json')}
    elif a.cmd=='register':
        value = register(a.job,a.agent,a.model,a.effort)
    elif a.cmd=='prepare':
        value = {'job':str(prepare(a.phase,a.paper,a.years))}
    elif a.cmd=='publish':
        value = publish(a.years, a.paper)
    elif a.cmd in ('freeze','status'):
        value = {'freeze':freeze,'publish':publish,'status':status}[a.cmd](a.years)
    else:
        value = {'validate':validate,'execute':execute,'finish':finish,'reconcile':reconcile}[a.cmd](a.job)
    print(json.dumps(value,ensure_ascii=False,indent=2,allow_nan=False))


def reconcile(job):
    """Recover available evidence after interruption, never launch a process."""
    job, task = context(job)
    with locked(job/'native.lock'):
        prior = read(job/'receipt.json') if (job/'receipt.json').is_file() else {}
        state = job/('work/runtime/latest.json' if task['route']=='reconstruction' else 'runtime/run.json')
        if prior and (prior.get('state') or not state.is_file() or (job/'report.json').exists()):
            return prior
        receipt = collect_receipt(job,task,ok=False,recovered_after_interruption=True)
        if prior:
            write(job/'receipt_before_reconciliation.json',prior)
            receipt['previous_receipt_sha256'] = sha(job/'receipt_before_reconciliation.json')
            if prior.get('error'):
                receipt['error'] = prior['error']
        write(job/'receipt.json',receipt)
        return receipt


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, OSError) as error:
        raise SystemExit(str(error))
