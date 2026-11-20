#!/usr/bin/env python3
"""Freeze a JAR deposit and publish an independently reviewed reproduction using newly written code."""
import argparse
import csv
import json
import os
from pathlib import Path
import re
import tempfile

if __package__:
    from . import publication as pub
    from .feasibility_verdict import execution_verdict
    from .rebuild_indexes import PROJECT, rebuild
else:
    import publication as pub
    from feasibility_verdict import execution_verdict
    from rebuild_indexes import PROJECT, rebuild


ROUTE = 'author_deposit'
META = {'work_item.json', 'result.json', 'review.json', 'outcome.json', 'accepted.json'}
CODE = {'.sas', '.do', '.ipynb', '.py', '.r', '.m'}
TABLE = {'.csv', '.tsv', '.tex', '.rtf', '.md', '.txt', '.json'}
PRIVATE = {'data', 'inputs', 'work', '.work', 'runtime', 'logs', 'scratch', 'private'}


def read(path):
    return json.loads(Path(path).read_bytes())


def match_hash(path, expected):
    if not isinstance(expected, str) or not re.fullmatch('[a-f0-9]{64}', expected) or pub.sha(pub.safe_regular(path)) != expected:
        raise ValueError(f'Checksum mismatch: {path}')


def catalog_unit(root, package_id):
    if not re.fullmatch('[A-Za-z0-9][A-Za-z0-9_-]*', package_id):
        raise ValueError('Invalid package ID')
    with (root / 'docs/papers.jsonl').open(encoding='utf-8') as stream:
        units = [(paper, unit) for paper in map(json.loads, filter(str.strip, stream))
                 for unit in paper['jar_packages'] if unit['package_id'] == package_id]
    if len(units) != 1:
        raise ValueError(f'Expected one catalog entry for {package_id}, found {len(units)}')
    paper, unit = units[0]
    if not re.fullmatch('[A-Za-z0-9][A-Za-z0-9_-]*', paper['paper_id']):
        raise ValueError('Invalid catalog paper ID')
    deposit = pub.inside(root, unit['package_path'])
    if not deposit.is_relative_to(root / 'papers/packages') or deposit == root / 'papers/packages':
        raise ValueError('Catalog deposit must resolve inside papers/packages/')
    return paper, unit, deposit


def input_hashes(root, deposit):
    if deposit.is_file():
        files = [deposit]
    elif deposit.is_dir():
        files = []
        for path in sorted(deposit.rglob('*')):
            if path.is_symlink():
                raise ValueError(f'Symlink in deposit: {path}')
            if not path.is_dir():
                files.append(path)
    else:
        raise FileNotFoundError(deposit)
    if not files:
        raise ValueError('The package has no input files')
    return {p.relative_to(root).as_posix(): pub.sha(pub.safe_regular(p)) for p in files}


def execution_handoff(review_path, report_path, pid, scope):
    review, report = read(review_path), read(report_path)
    match_hash(report_path, review['report']['sha256'])
    handoff = review.get('handoff', {})
    missing = handoff.get('uncovered_baselines')
    coverage = handoff.get('coverage')
    if report.get('outcome') == 'not_run':
        raise ValueError('An unlaunched not_run draft cannot trigger reproduction')
    if (not review.get('reviewer') or report.get('package_id') != pid or report.get('scope_id') != scope
            or report.get('outcome') not in {'blocked', 'failed', 'partial', 'completed'}
            or report.get('outcome') != review.get('outcome')
            or handoff.get('next_skill') != 'reproduce-accounting-models'
            or not isinstance(missing, list) or not missing or not isinstance(coverage, dict)):
        raise ValueError('A reviewed execution with unresolved baseline targets is required')
    verified = {stage['stage_id'] for stage in report['stage_results']
                if stage['status'] == 'succeeded' and stage['log_check'] == 'passed'}
    for target, item in coverage.items():
        if (not target.strip() or type(item.get('verified')) is not bool or not item.get('evidence')
                or (item['verified'] and item.get('stage_id') not in verified)):
            raise ValueError(f'Invalid reviewed numerical coverage for {target}')
    if len(missing) != len(set(missing)) or set(missing) != {k for k, v in coverage.items() if not v['verified']}:
        raise ValueError('The execution handoff must include exactly its unresolved baseline targets')
    return {'review_sha256': pub.sha(review_path), 'report_sha256': pub.sha(report_path),
            'uncovered_baselines': missing}


def accepted_handoff(root, review_path, pid, scope):
    review_path = pub.safe_regular(Path(review_path).absolute())
    report_path = pub.safe_regular(review_path.with_name('report.json'))
    reviewed = execution_handoff(review_path, report_path, pid, scope)
    report, review = read(report_path), read(review_path)
    public = pub.inside(root, f'output/executions/packages/{pid}')
    if review_path == public / 'review.json':
        recipe = read(pub.safe_regular(public / 'local_inputs.json'))
        if (not report.get('attempt_id') or recipe.get('schema_version') != '2.0'
                or any(recipe.get(k) != report.get(k) for k in ('package_id', 'scope_id', 'attempt_id'))
                or recipe.get('accepted_outcome') != report['outcome']
                or review['report']['path'] != report_path.relative_to(root).as_posix()):
            raise ValueError('Published recipe and review must identify the same execution attempt')
        pub.verify_receipt(public)
        source_review = review['source_review']
        if (not re.fullmatch('[a-f0-9]{64}', source_review['sha256'])
                or source_review['path'] != 'urn:sha256:' + source_review['sha256']):
            raise ValueError('Invalid published source review binding')
        for item in review['publish_files']:
            artifact = pub.inside(root, item['path'])
            if not artifact.is_relative_to(public):
                raise ValueError('Reviewed artifact outside the published execution')
            match_hash(artifact, item['sha256'])
        return reviewed

    from scripts import author_analysis_runs as runs
    attempt = review_path.parent.parent
    base = root / '.local/runs/author_analysis_execution'
    if (review_path != attempt / 'output/review.json' or attempt.parent.name != 'attempts'
            or not attempt.is_relative_to(base)):
        raise ValueError('Use a retained public review or a registered private execution review')
    _, campaign, state, record, item = runs._attempt(attempt)
    if (state.get('fixture') or campaign != attempt.parent.parent or record.get('status') != 'accepted'
            or record.get('package_id') != pid or record.get('outcome') != report['outcome']
            or review['reviewer'] == record.get('agent') or record.get('attempt_id') != attempt.name
            or report.get('attempt_id') != attempt.name or item['analysis_scope']['id'] != scope):
        raise ValueError('Private execution has no accepted matching controller record')
    if record['report'] != review['report']:
        raise ValueError('Execution review does not bind the registered report')
    for key, path in [('report', report_path), ('review', review_path)]:
        reference = record[key]
        if Path(reference['path']) != path:
            raise ValueError('Controller reference belongs to a different attempt')
        match_hash(path, reference['sha256'])
    if set(item['unit']['baseline_targets']) != set(review['handoff']['coverage']):
        raise ValueError('Review coverage differs from the frozen execution targets')
    return reviewed


def freeze(root, package_id, execution_review=None):
    paper, unit, deposit = catalog_unit(root, package_id)
    assessment_path = f'output/feasibility_execution/packages/{package_id}/assessment.json'
    assessment = pub.inside(root, assessment_path)
    record = read(assessment)
    scopes = {s['id']: s for s in record['scopes']}
    scope = scopes.get('analysis_only', scopes.get('full_pipeline'))
    if record['package_id'] != package_id or not scope:
        raise ValueError('The deposit and feasibility assessment must describe the same package')
    verdict, route = execution_verdict(scope['data_status'], scope['execution_readiness'])
    handoff = None
    if verdict != 'ready':
        raise ValueError('The reviewed package is outside the Ready class')
    if execution_review is not None:
        if route != 'prepare_and_execute':
            raise ValueError('Execution fallback requires the prepare-and-execute route')
        handoff = accepted_handoff(root, execution_review, package_id, scope['id'])
    elif route != 'reproduce':
        raise ValueError('This package needs a reviewed author-code attempt before reproduction')
    return {'version': 1, 'route': ROUTE, 'paper_id': paper['paper_id'], 'package_id': package_id,
            'title': paper['title'], 'doi': paper['doi'], 'scope_id': scope['id'],
            'assessment_path': assessment_path, 'assessment_sha256': pub.sha(assessment),
            'deposit_path': unit['package_path'], 'input_hashes': input_hashes(root, deposit), 'handoff': handoff}


def prepare(root, package_id, work_dir, execution_review=None):
    work = freeze(root, package_id, execution_review)
    work_dir = Path(work_dir).resolve()
    if work_dir.is_relative_to(root) and not work_dir.is_relative_to(root / '.local'):
        raise ValueError('Use a private work directory outside the checkout or under .local/')
    work_dir.mkdir(parents=True, exist_ok=True)
    target = work_dir / 'work_item.json'
    if execution_review:
        folder = pub.inside(work_dir, '.deposit_handoff')
        folder.mkdir(exist_ok=True)
        original = Path(execution_review).resolve()
        install_frozen(folder / 'review_path.json', pub.encode(original.relative_to(root).as_posix()))
    install_frozen(target, pub.encode(work))
    return target


def install_frozen(target, raw):
    with tempfile.NamedTemporaryFile(dir=target.parent) as tmp:
        tmp.write(raw)
        tmp.flush()
        try:
            os.link(tmp.name, target)
        except FileExistsError:
            if pub.safe_regular(target).read_bytes() != raw:
                raise ValueError('Existing assignment has different inputs')


def verify_work(root, work, with_data):
    pid = work['package_id']
    paper, unit, deposit = catalog_unit(root, pid)
    if (work['version'] != 1 or work['route'] != ROUTE or work['paper_id'] != paper['paper_id']
            or work['doi'] != paper['doi'] or work['deposit_path'] != unit['package_path']
            or work['assessment_path'] != f'output/feasibility_execution/packages/{pid}/assessment.json'):
        raise ValueError('Assignment identity or input path differs from catalog')
    assessment = pub.inside(root, work['assessment_path'])
    match_hash(assessment, work['assessment_sha256'])
    record = read(assessment)
    selected = {s['id']: s for s in record['scopes']}
    scope = selected.get('analysis_only', selected.get('full_pipeline'))
    if not scope or record['package_id'] != pid or scope['id'] != work['scope_id']:
        raise ValueError('The assigned feasibility scope differs from the retained assessment')
    verdict, route = execution_verdict(scope['data_status'], scope['execution_readiness'])
    handoff = work['handoff']
    if verdict != 'ready' or route != ('prepare_and_execute' if handoff else 'reproduce'):
        raise ValueError('The assignment differs from the assessed route')
    if handoff and (not handoff.get('uncovered_baselines') or any(not re.fullmatch('[a-f0-9]{64}', handoff[key])
                    for key in ('review_sha256', 'report_sha256'))):
        raise ValueError('Invalid execution handoff')
    hashes = work['input_hashes']
    if not hashes:
        raise ValueError('Empty deposit inventory')
    for name, digest in hashes.items():
        if not pub.inside(root, name).is_relative_to(deposit) or not re.fullmatch('[a-f0-9]{64}', digest):
            raise ValueError('Invalid input checksum or path outside the deposit')
    if with_data and hashes != input_hashes(root, deposit):
        raise ValueError('The local deposit differs from its frozen inputs')


def reviewed_files(review):
    files = review.get('publish_files')
    if (review.get('status') != 'accepted' or not isinstance(review.get('reviewer'), str)
            or not review['reviewer'].strip() or not isinstance(review.get('findings'), list)
            or not review['findings'] or not isinstance(files, dict)):
        raise ValueError('Expected an accepted independent review with findings and a file allowlist')
    selected = {}
    for name, digest in files.items():
        if name == 'result.json' and digest == review['result_sha256']:
            continue
        p = Path(pub.relative(name))
        if (p.as_posix() != name or p.parts[0] in META or any(s.startswith('.') or s in PRIVATE for s in p.parts)
                or not (p.suffix.lower() in CODE or p.suffix.lower() == '.md'
                        or (p.parts[0] == 'tables' and p.suffix.lower() in TABLE)
                        or (p.parts[0] == 'figures' and p.suffix.lower() in {'.pdf', '.png'}))):
            raise ValueError(f'Expected reviewed source, documentation or an aggregate output: {name}')
        selected[name] = digest
    return selected


def make_outcome(work, result, files):
    fits = result.get('fits')
    if (not isinstance(fits, list) or not fits or not isinstance(result.get('limitations'), list)
            or ('paper_id' in result and result['paper_id'] != work['paper_id'])
            or ('package_id' in result and result['package_id'] != work['package_id'])):
        raise ValueError('Expected assigned paper, baseline fits and limitations')
    scopes = set()
    for fit in fits:
        pair = (fit.get('model_id'), fit.get('result_set_id'))
        status = fit.get('execution_status')
        detail = fit.get('execution_detail') if status == 'executed' else fit.get('blocked_reason')
        if (not all(isinstance(k, str) and k.strip() for k in pair) or pair in scopes
                or status not in {'executed', 'blocked'} or not fit.get('fidelity') or not detail):
            raise ValueError(f'Invalid, duplicate or undocumented baseline result: {pair}')
        if status == 'executed':
            evidence = fit.get('evidence_path')
            if (not isinstance(evidence, str) or evidence not in files or not evidence.startswith('tables/')
                    or Path(evidence).suffix.lower() not in TABLE):
                raise ValueError(f'Executed baseline requires a reviewed numerical table: {pair}')
            if not any(Path(name).suffix.lower() in CODE for name in files):
                raise ValueError('An executed deposit reproduction requires reviewed source code')
        scopes.add(pair)
    if work.get('handoff'):
        covered = {fit.get('target_id', fit['model_id']) for fit in fits}
        if covered != set(work['handoff']['uncovered_baselines']):
            raise ValueError('Fit coverage differs from the unresolved baselines in the execution handoff')
    count = sum(fit['execution_status'] == 'executed' for fit in fits)
    return {'paper_id': work['paper_id'], 'package_id': work['package_id'], 'doi': work['doi'],
            'attempt': 1, 'route': ROUTE, 'status': 'executed' if count == len(fits) else 'partial' if count else 'blocked',
            'executed_scopes': count, 'total_scopes': len(fits), 'fits': fits, 'limitations': result['limitations'],
            'files': files}


def verify_publication(root, parent, d, *, with_data=False):
    root, parent = Path(root).resolve(), Path(parent).resolve()
    work, review, result = [read(pub.inside(parent, name)) for name in ('work_item.json', 'review.json', 'result.json')]
    verify_work(root, work, with_data)
    for doc in (result, work):
        for name in ('builder', 'builder_id', 'agent', 'assigned_agent', 'worker'):
            identity = doc.get(name)
            if isinstance(identity, dict):
                identity = identity.get('agent') or identity.get('id') or identity.get('name')
            if isinstance(identity, str) and identity.strip() == review['reviewer'].strip():
                raise ValueError('Deposit reproduction requires an independent reviewer')
    match_hash(parent / 'result.json', review['result_sha256'])
    files = reviewed_files(review)
    files.update({name: pub.sha(parent / name) for name in ('work_item.json', 'review.json', 'result.json')})
    if make_outcome(work, result, files) != d:
        raise ValueError('Published outcome differs from its reviewed results')
    actual = {p.relative_to(parent).as_posix() for p in parent.rglob('*') if p.is_file() or p.is_symlink()}
    if actual != set(files) | {'outcome.json'}:
        raise ValueError('Attempt contains unlisted or missing files')
    for name, digest in files.items():
        path = pub.inside(parent, name)
        match_hash(path, digest)
    evidence = {fit['evidence_path'] for fit in d['fits'] if fit['execution_status'] == 'executed'}
    if evidence and not any(has_code(parent / n) for n in files if Path(n).suffix.lower() in CODE):
        raise ValueError('Published reproduction has no executable source text')
    for name in evidence:
        if not numerical_table(parent / name):
            raise ValueError(f'Reviewed table has no numerical result: {name}')


def has_code(path):
    if path.suffix.lower() == '.ipynb':
        return any(cell.get('cell_type') == 'code' and ''.join(cell.get('source', '')).strip()
                   for cell in read(path)['cells'])
    return bool(path.read_bytes().strip())


def numerical_table(path):
    if path.suffix.lower() in {'.csv', '.tsv'}:
        with path.open(encoding='utf-8-sig', newline='') as source:
            rows = csv.reader(source, delimiter='\t' if path.suffix.lower() == '.tsv' else ',')
            number = re.compile(r'[\s("=]*[-+−]?(?:\d[\d,]*(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?[%*)\s"]*')
            return any(number.fullmatch(cell) for row in rows for cell in row)
    return bool(re.search(rb'(?<![A-Za-z0-9_])[-+]?[0-9]', path.read_bytes()))


def publish(root, work_dir, review_path):
    work_dir, review_path = Path(work_dir).resolve(), Path(review_path).resolve()
    work = read(pub.safe_regular(work_dir / 'work_item.json'))
    verify_work(root, work, with_data=True)
    if work['handoff']:
        folder = pub.inside(work_dir, '.deposit_handoff')
        source = pub.inside(root, read(pub.safe_regular(folder / 'review_path.json')))
        reviewed = accepted_handoff(root, source, work['package_id'], work['scope_id'])
        if reviewed != work['handoff']:
            raise ValueError('Assigned fallback targets differ from the archived execution review')
    pid = work['paper_id']
    review = read(pub.safe_regular(review_path))
    result_path = pub.safe_regular(work_dir / 'result.json')
    match_hash(result_path, review['result_sha256'])
    result = read(result_path)
    selected = reviewed_files(review)
    sources = {name: pub.inside(work_dir, name) for name in selected}
    sources.update({'result.json': result_path, 'work_item.json': work_dir / 'work_item.json', 'review.json': review_path})
    expected = {**selected, 'result.json': review['result_sha256'], 'work_item.json': pub.byte_hash(pub.encode(work)), 'review.json': pub.sha(review_path)}
    dest = pub.inside(root, f'output/reproductions/packages/{pid}')
    with pub.staged_package(root, 'reproductions', pid) as stage:
        out = stage / 'attempt_01'
        out.mkdir()
        for name, source in sources.items():
            match_hash(source, expected[name])
            raw = source.read_bytes()
            if source.suffix.lower() in pub.TEXT and raw != pub.PublicPaths(pid).data(name, raw):
                raise ValueError(f'Use portable paths in reviewed files: {name}')
            if source.suffix.lower() == '.ipynb' and any(cell.get('outputs') or cell.get('attachments')
                    for cell in json.loads(raw)['cells']):
                raise ValueError(f'Publish clean notebook source and reviewed aggregate tables: {name}')
            target = pub.inside(out, name)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(raw)
        outcome = make_outcome(work, result, expected)
        (out / 'outcome.json').write_bytes(pub.encode(outcome))
        verify_publication(root, out, outcome)
        (stage / 'accepted.json').write_bytes(pub.encode({'attempt': 1, 'path': (dest / 'attempt_01').relative_to(root).as_posix(),
                                                          'outcome_sha256': pub.sha(out / 'outcome.json')}))
        if dest.exists() and not pub.same_tree(stage, dest):
            raise ValueError(f'This paper already has a different published reproduction: {pid}')
    rebuild(root)
    return dest / 'attempt_01/outcome.json'


def verify(root, paper_id, with_data):
    if not re.fullmatch('[A-Za-z0-9][A-Za-z0-9_-]*', paper_id):
        raise ValueError('Invalid paper ID')
    dest = pub.inside(root, f'output/reproductions/packages/{paper_id}')
    attempt = pub.inside(dest, 'attempt_01')
    receipt = read(pub.safe_regular(dest / 'accepted.json'))
    path = pub.inside(attempt, 'outcome.json')
    doc = read(path)
    if (doc['paper_id'] != paper_id or receipt != {'attempt': 1, 'path': attempt.relative_to(root).as_posix(),
                                                   'outcome_sha256': pub.sha(path)}):
        raise ValueError('Accepted pointer differs from published deposit outcome')
    verify_publication(root, attempt, doc, with_data=with_data)
    return path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    run = commands.add_parser('prepare', help='Bind the catalog identity, deposit and reviewed feasibility scope.')
    run.add_argument('--package-id', required=True)
    run.add_argument('--work-dir', type=Path, required=True)
    run.add_argument('--execution-review', type=Path, help='Accepted review.json next to its report.json, for uncovered baselines.')
    run = commands.add_parser('publish', help='Publish one reviewed deposit reproduction and refresh indexes.')
    run.add_argument('--work-dir', required=True, type=Path)
    run.add_argument('--review', required=True, type=Path)
    run = commands.add_parser('verify', help='Verify the accepted package; optionally check its original local deposit.')
    run.add_argument('--paper-id', required=True)
    run.add_argument('--with-data', action='store_true')
    args = parser.parse_args()
    try:
        if args.command == 'prepare':
            path = prepare(PROJECT, args.package_id, args.work_dir, args.execution_review)
        elif args.command == 'publish':
            path = publish(PROJECT, args.work_dir, args.review)
        else:
            path = verify(PROJECT, args.paper_id, args.with_data)
        print(path)
    except (KeyError, TypeError, ValueError, OSError) as exc:
        parser.exit(1, str(exc) + '\n')


if __name__ == '__main__':
    main()
