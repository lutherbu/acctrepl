"""Install a reviewed author analysis and its minimal replay inputs."""
from pathlib import Path
import json

from scripts import materialize_execution_inputs as inputs
from scripts import publication as public


def _refs(document, published):
    """Keep reviewed references verifiable after their working directory moves."""
    if isinstance(document, list):
        return [_refs(item, published) for item in document]
    if isinstance(document, dict):
        out = {k: _refs(v, published) for k, v in document.items()}
        if isinstance(document.get('path'), str) and document.get('sha256'):
            name = document['path']
            if name in published:
                out['path'], out['sha256'] = published[name]
            elif Path(name).is_absolute() or name.startswith(('frozen/', 'runtime/', 'output/')):
                out['path'] = 'urn:sha256:' + document['sha256']
        return out
    return document


def check_plan(recipe, plan, attempt, report, resources):
    expected = [{k:v for k,v in s.items() if k not in ('executable','script_sha256','note')}
                for s in plan['stages']]
    if recipe['stages'] != expected or recipe['limits'] != plan['limits'] or recipe['scope_gaps'] != plan.get('scope_gaps', []):
        raise ValueError('Replay stages, limits or scope differ from the reviewed native plan')
    raw_env = plan.get('environment', {})
    if set(recipe['environment']) != set(raw_env):
        raise ValueError('Replay environment differs from native plan')
    for key, value in recipe['environment'].items():
        if key not in ('R_LIBS', 'R_LIBS_USER') or value != 'output/executions/resources/R' or Path(raw_env[key]).resolve() != resources/'R':
            raise ValueError('Reviewed environment needs a verified project-local dependency')
    staged = {str((attempt/i['path']).resolve()):i['sha256'] for i in plan['inputs']}
    consumed = {i['id']:i for i in report['inputs']}
    omitted = set()
    for row in recipe.get('omitted_inputs', []):
        key = row.get('id') or row.get('input_id')
        if key not in consumed or key in omitted or not str(row.get('reason','')).strip():
            raise ValueError('Omitted input needs a unique reviewed ID and a reason')
        omitted.add(key)
    selected = set()
    for entry in recipe['files']:
        target = public.inside(attempt, entry['path'])
        if not target.is_relative_to(attempt/'work'):
            raise ValueError('Inputs must be within the working directory')
        if entry['role'] == 'code':
            if str(target) in staged and staged[str(target)] != entry['executed_sha256']:
                raise ValueError('Working code differs from reviewed plan')
            continue
        key = entry['input_id']
        if key in omitted:
            raise ValueError('A selected input is also omitted')
        selected.add(key)
        row = consumed.get(key, {})
        refs = [ref for ref in (row.get('original'), row.get('staged')) if ref]
        if (entry['role'] not in ('data','reference') or row.get('role') not in ('data','reference')
                or not any(ref['sha256'] == entry['sha256'] for ref in refs)
                or not any(staged.get(str((attempt/p).resolve())) == entry['sha256']
                           for p in [entry['path'], *(r['path'] for r in refs)])):
            raise ValueError('Replay input is absent from the reviewed plan and report')
    if {k for k,v in consumed.items() if v['role'] in ('data','reference')} - selected - omitted:
        raise ValueError('Unaccounted reviewed inputs')
    code = {entry['path']:entry['executed_sha256'] for entry in recipe['files'] if entry['role']=='code'}
    if any(code.get(s['script']) != s['script_sha256'] for s in plan['stages']):
        raise ValueError('A reviewed stage script is missing from the recipe')


def install(root, attempt, record, report, review, reviewed_files, recipe_path):
    root, attempt = Path(root).resolve(), Path(attempt).resolve()
    recipe_path = public.safe_regular(Path(recipe_path).absolute())
    recipe = json.loads(recipe_path.read_bytes())
    pid = report['package_id']
    if (recipe.get('schema_version'), recipe.get('package_id'), recipe.get('scope_id'),
            recipe.get('attempt_id'), recipe.get('accepted_outcome')) != (
                '2.0', pid, 'analysis_only', record['attempt_id'], report['outcome']):
        raise ValueError('Recipe does not identify the accepted analysis')
    if not report.get('plan') or not record.get('plan_reviews'):
        raise ValueError('The selected execution has no reviewed replay plan')
    source = json.loads((attempt/'frozen/source_work_item.json').read_bytes())
    spec = recipe['archive']
    name = public.relative(spec['path'])
    archive = public.inside(root, name)
    pins = source['output_header']['provenance']['package_files']
    if not any(name == 'papers/packages/' + p['path'] and spec['sha256'] == p['sha256'] for p in pins):
        raise ValueError('The archive does not match the frozen package identity')
    resources = root/'output/executions/resources'
    plan_file = (attempt/report['plan']['path']).resolve()
    if public.sha(plan_file) != report['plan']['sha256']:
        raise ValueError('The reviewed native plan changed')
    check_plan(recipe, json.loads(plan_file.read_bytes()), attempt, report, resources)
    base = Path('output/executions/packages')/pid
    dest = root/base
    refs = {}
    policy = public.PublicPaths(pid)
    approved = {Path(f['path']).resolve():f for f in reviewed_files}
    with public.staged_package(root,'executions',pid) as stage:
        originals = {'report.json':record['report']['sha256'], 'review.json':record['review']['sha256'],
                     'local_inputs.json':public.sha(recipe_path)}
        indexed = {}
        for entry in recipe['files']:
            if entry['role'] != 'code':
                continue
            path = public.inside(attempt, entry['path'])
            original = approved.get(path)
            if not original or original['kind'] != 'code' or original['sha256'] != entry['executed_sha256']:
                raise ValueError('Executed code lacks source review and publication approval')
            template = public.inside(recipe_path.parent, entry['template'])
            if not template.is_relative_to(recipe_path.parent/'code'):
                raise ValueError('Templates must be in code/')
            body = inputs.rendered(root, recipe_path.parent, entry, attempt)
            if public.byte_hash(body) != original['sha256']:
                raise ValueError('Template does not reproduce the reviewed code in the original location')
            target = public.inside(stage,entry['template'])
            if target.exists():
                raise ValueError('Duplicate published code template')
            public.transform_file(template,target,policy)
            entry['template_sha256'] = public.sha(target)
            indexed[path] = entry['template']
            originals[entry['template']] = original['sha256']
        for n, (path, f) in enumerate(approved.items(),1):
            name = indexed.get(path)
            if not name:
                name = f'{f["kind"]}/{n:03d}_{path.name}'
                target = public.inside(stage,name)
                if target.exists():
                    raise ValueError('Duplicate public artifact')
                public.transform_file(path,target,policy)
                originals[name] = f['sha256']
            binding = ((base/name).as_posix(), public.sha(stage/name))
            refs[str(path)] = refs[path.relative_to(attempt).as_posix()] = binding
        recipe_out = policy.document(recipe)
        if recipe_out['files'] != recipe['files'] or recipe_out['archive'] != recipe['archive']:
            raise ValueError('Archive locators or replay targets require a portable recipe')
        (stage/'local_inputs.json').write_bytes(public.encode(recipe_out))
        inputs.prepare_package(root, stage, pid, archive_path=archive, verify_archive=True, destination=dest)
        # Both public work files and private attempt files refer to identical input bytes.
        portable_report = policy.document(_refs(report, refs))
        (stage/'report.json').write_bytes(public.encode(portable_report))
        binding = ((base/'report.json').as_posix(), public.sha(stage/'report.json'))
        refs[record['report']['path']] = refs['output/report.json'] = binding
        portable_review = policy.document(_refs(review, refs))
        (stage/'review.json').write_bytes(public.encode(portable_review))
        (stage/'RUN_LOCAL.md').write_text(
            '# Run the reviewed author analysis\n\nFrom the repository root, restore the checked inputs and stage the native plan.\n\n'
            f'```sh\npython3 scripts/materialize_execution_inputs.py --package-id {pid} --verify-archive\n'
            f'python3 scripts/prepare_author_replay.py {pid}\n```\n\n'
            'MATLAB stages require the operator authorization described in the [README](../../../../README.md).\n')
        public.receipt(stage,originals)
    return dest
