#!/usr/bin/env python3
"""Stage one retained author recipe and validate its native execution plan."""
import argparse
from datetime import datetime, timezone
import importlib.util
import json
import os
from pathlib import Path
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from project_layout import runtime_executable
from scripts import materialize_execution_inputs as inputs


def runner():
    path = ROOT / 'skills/execute-author-analysis/scripts/runner.py'
    spec = importlib.util.spec_from_file_location('native_author_runner', path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + '\n')


def stage(package, attempt, *, authorization=None):
    recipe = json.loads((package / 'local_inputs.json').read_bytes())
    if (attempt / 'work_item.json').exists() or (attempt / 'frozen').exists():
        raise ValueError('Use a fresh attempt directory')
    if not attempt.resolve().is_relative_to(ROOT / '.local'):
        raise ValueError('Choose a working directory under .local')
    work = attempt / 'work'
    work.mkdir(parents=True, exist_ok=True)
    frozen = attempt / 'frozen'
    frozen.mkdir()
    languages = {s['language'] for s in recipe['stages']}
    host = 'matlab' in languages
    if host and languages != {'matlab'}:
        raise ValueError('Review mixed-language packages as separate runtime scopes')
    executables = {lang: runtime_executable(lang) for lang in languages}
    resources = ROOT / 'output/executions/resources'
    mounts = [] if host else [str(resources)]
    policy = {'schema_version':'1.0','sandbox_profile':'host' if host else 'bwrap',
              'allowed_read_only_roots':mounts,'limits':recipe['limits'],
              'runtime_paths':{key:[value] for key,value in executables.items()}}
    ado = resources / 'stata/plus'
    if 'stata' in languages and ado.is_dir():
        policy['stata_ado_paths'] = [str(ado)]
    if host:
        if not authorization:
            raise ValueError('Set --matlab-authorization to explicit approval from the current operator')
        doc = json.loads(Path(authorization).read_bytes())
        authpath = frozen / 'matlab_authorization.json'
        write(authpath, doc)
        policy.update(host_home=str(Path.home()), host_execution_authorization={'path':str(authpath),'sha256':inputs.sha(authpath)})
    freezes = frozen / 'runtime_policy.json'
    write(freezes, policy)
    write(attempt / 'work_item.json', {'runtime_policy':{'path':str(freezes),'sha256':inputs.sha(freezes)}})
    bound = []
    for entry in recipe['files']:
        target = inputs.inside(attempt, entry['path'])
        target.parent.mkdir(parents=True, exist_ok=True)
        if entry['role'] == 'code':
            target.write_bytes(inputs.rendered(ROOT, package, entry, attempt))
        else:
            src = inputs.inside(package, entry['path'])
            if not src.is_file() or inputs.sha(src) != entry['sha256']:
                raise ValueError(f"Restore the pinned working input first: {entry['path']}")
            shutil.copyfile(src, target)
        bound.append({'path':entry['path'], 'sha256':inputs.sha(target)})
    for directory in recipe['empty_directories']:
        inputs.inside(attempt, directory).mkdir(exist_ok=True, parents=True)
    stages = []
    for original in recipe['stages']:
        s = dict(original)
        inputs.inside(attempt, s['cwd']).mkdir(exist_ok=True, parents=True)
        for relative in s['expected_outputs'] + s.get('native_logs', []):
            inputs.inside(attempt, relative).parent.mkdir(exist_ok=True, parents=True)
        s.update(executable=executables[s['language']], script_sha256=inputs.sha(inputs.inside(attempt,s['script'])))
        stages.append(s)
    environment = {k:str(inputs.inside(ROOT,v)) for k,v in recipe['environment'].items()}
    plan = {'schema_version':'1.0','attempt_id':recipe['package_id'],
            'sandbox':{'profile':policy['sandbox_profile'],'read_only_paths':mounts},
            'limits':recipe['limits'],'environment':environment,'stages':stages,'inputs':bound,
            'scope_gaps':recipe['scope_gaps']}
    path = frozen / 'original_plan.json'
    write(path, plan)
    runner().validate_plan(attempt, path)
    return path


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('package_id')
    ap.add_argument('--attempt', type=Path)
    ap.add_argument('--matlab-authorization', type=Path)
    args = ap.parse_args()
    package = inputs.inside(ROOT, f'output/executions/packages/{args.package_id}')
    stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
    attempt = (args.attempt or ROOT / '.local/author_replays' / args.package_id / stamp).resolve()
    try:
        inputs.prepare(ROOT,args.package_id)
        print(stage(package,attempt,authorization=args.matlab_authorization))
    except (ValueError,OSError) as error:
        ap.exit(1,str(error)+'\n')


if __name__ == '__main__':
    main()
