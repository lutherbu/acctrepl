#!/usr/bin/env python3
"""Build GitHub Pages cohort counts from the catalog and published feasibility and run records."""
import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import sys

if __package__:
    from .feasibility_verdict import LABELS, execution_verdict, reproduction_verdict
    from .rebuild_indexes import PROJECT, encoded, index_workflow
    from .update_paper_catalog import _atomic_write
else:
    from feasibility_verdict import LABELS, execution_verdict, reproduction_verdict
    from rebuild_indexes import PROJECT, encoded, index_workflow
    from update_paper_catalog import _atomic_write


def _publications(root, name):
    if not (root / 'output' / name).exists():
        return {}
    return {entry['id']: root / entry['path'] for entry in index_workflow(root, name)['records']}


def _record(paths, identity):
    path = paths.get(identity)
    return json.loads(path.read_bytes()) if path is not None else None


def _paper_class(assessment, mapping):
    """Cover every selected fit. A mandatory barrier precedes uncertainty, then public, then local."""
    if assessment is None:
        return 'unassessed'
    if assessment['eligibility'] == 'no_baseline':
        return 'no_baseline'
    if assessment['eligibility'] != 'eligible' or not assessment['assessments']:
        raise ValueError(f"Missing eligible baseline fits for {assessment['paper_id']}")
    statuses = {mapping[fit['data_status']] for fit in assessment['assessments']}
    # Synthetic fits add no observed-data requirement to a mixed observed/synthetic paper.
    for status in ('access_blocked', 'undetermined', 'public_acquisition_required',
                   'local_available', 'no_observed_data_required'):
        if status in statuses:
            return status
    raise ValueError(f"Invalid fit verdicts for {assessment['paper_id']}: {statuses}")


def _reconstruction_ran(outcome):
    if outcome is None:
        return False
    ran, total = outcome['executed_scopes'], outcome['total_scopes']
    if type(ran) is not int or type(total) is not int or not 0 <= ran <= total:
        raise ValueError(f"Invalid executed scope count for {outcome['paper_id']}")
    expected = 'executed' if ran == total else 'partial' if ran else 'blocked'
    if outcome['status'] != expected:
        raise ValueError(f"Inconsistent reconstruction status for {outcome['paper_id']}")
    return ran > 0


def _author_ran(report):
    if report is None:
        return False
    outcome = report['outcome']
    if outcome not in {'completed', 'partial', 'failed', 'blocked', 'not_run'}:
        raise ValueError(f"Unknown execution outcome for {report['package_id']}: {outcome}")
    if outcome not in {'completed', 'partial'}:
        return False
    successful = [stage for stage in report['stage_results']
                  if stage['required'] and stage['status'] == 'succeeded' and stage['log_check'] == 'passed']
    if not report['run_receipt'] or not successful:
        raise ValueError(f"Missing successful execution stage for {report['package_id']}")
    if outcome == 'completed':
        return True
    # A partial run can finish data preparation before failing its first analysis.
    outputs = {(stage['stage_id'], output_id) for stage in successful for output_id in stage['output_ids']}
    return any((item['stage_id'], item['id']) in outputs
               and item['kind'] in {'result_table', 'model_result', 'figure', 'native_result_log'}
               and item['freshness'] in {'new', 'changed'} for item in report['artifacts'])


def _package_inputs(assessment, report, mapping):
    if assessment is None:
        return None
    scopes = {scope['id']: scope for scope in assessment['scopes']}
    if len(scopes) != len(assessment['scopes']) or 'full_pipeline' not in scopes:
        raise ValueError(f"Invalid feasibility scopes for {assessment['package_id']}")
    scope = report['scope_id'] if report else ('analysis_only' if 'analysis_only' in scopes else 'full_pipeline')
    if scope not in scopes:
        raise ValueError(f"Missing assessment for execution scope {scope} in {assessment['package_id']}")
    selected = scopes[scope]
    return mapping[selected['data_status']], selected['execution_readiness']


def _empty_cohort(statuses):
    return {'total': 0,
            'classes': {key: {'executed': 0, 'unexecuted': 0} for key in [*statuses, 'unclassified']},
            'manual_verdicts': {},
            'unclassified_reasons': {'unassessed': 0, 'no_baseline': 0}}


def read_overrides(root):
    path = root / 'site/progress_overrides.json'
    if not path.exists():
        return {}
    settings = json.loads(path.read_bytes())
    if not isinstance(settings, dict) or settings.keys() - {'cited', 'jar'}:
        raise ValueError(f'Invalid cohorts in {path}')
    return settings


def _overrides(settings, ids, statuses):
    if not isinstance(settings, dict) or settings.keys() - {'reclassify', 'ids_by_verdict'}:
        raise ValueError('Expected reclassify or ids_by_verdict in the manual selections.')
    rules = settings.get('reclassify', {})
    if not isinstance(rules, dict) or any(k not in statuses or v not in statuses for k, v in rules.items()):
        raise ValueError('Unknown feasibility class in a manual reclassification rule.')
    by_id = {}
    for verdict, selected in settings.get('ids_by_verdict', {}).items():
        if verdict not in {*statuses, *LABELS} or not isinstance(selected, list):
            raise ValueError(f'Invalid manual selection for {verdict}.')
        for subject in selected:
            if subject not in ids or subject in by_id:
                raise ValueError(f'Unknown or repeated ID in manual selections: {subject}')
            by_id[subject] = verdict
    return by_id, rules


def _count(cohort, category, ran, manual):
    if manual:
        counts = cohort['manual_verdicts']
        counts[category] = counts.get(category, 0) + 1
    if category in cohort['unclassified_reasons']:
        cohort['unclassified_reasons'][category] += 1
        category = 'unclassified'
    cohort['classes'][category]['executed' if ran else 'unexecuted'] += 1
    cohort['total'] += 1


def cohort_progress(root, overrides=None):
    """Summarize retained original-period attempts by paper and the two historical cohorts."""
    root = Path(root)
    if overrides is None:
        overrides = read_overrides(root)
    schema = root / 'skills/check-replication-feasibility/references/feasibility_classification.schema.json'
    contract = json.loads(schema.read_bytes())
    statuses = contract['$defs']['data_status']['enum']
    mappings = contract['x_status_mappings']
    cited_ids = set()
    papers, packages = {}, {}
    with (root / 'docs/papers.jsonl').open(encoding='utf-8') as catalog:
        for line in catalog:
            if not line.strip():
                continue
            row = json.loads(line)
            paper_id = row['paper_id']
            # A DOI can occur in more than one catalog row or more than one JAR package.
            identity = (row.get('doi') or '').strip().lower() or paper_id
            papers[paper_id] = identity
            if 'top_100_cited' in row['cohorts']:
                if row['paper_id'] in cited_ids:
                    raise ValueError(f"Duplicate citation-ranked paper {row['paper_id']}")
                cited_ids.add(row['paper_id'])
            for item in row['jar_packages']:
                package_id = item['package_id']
                if packages.setdefault(package_id, identity) != identity:
                    raise ValueError(f'Conflicting catalog identities for {package_id}')

    cited = _empty_cohort(LABELS)
    by_id, rules = _overrides(overrides.get('cited', {}), cited_ids, statuses)
    feasibility = _publications(root, 'feasibility_reproduction')
    attempted, executed, from_scratch_ran = set(), set(), set()
    for paper_id, path in _publications(root, 'reproductions').items():
        run = json.loads(path.read_bytes())
        identity = papers[paper_id]
        attempted.add(identity)
        if _reconstruction_ran(run):
            executed.add(identity)
            if run.get('route') != 'author_deposit':
                from_scratch_ran.add(paper_id)
    for paper_id in sorted(cited_ids):
        assessment = _record(feasibility, paper_id)
        status = _paper_class(assessment, mappings['independent_reconstruction'])
        override = by_id.get(paper_id, rules.get(status))
        selected = override or status
        if selected in LABELS or selected == 'unassessed':
            category = selected
        else:
            category = reproduction_verdict(selected)
        _count(cited, category, paper_id in from_scratch_ran, override is not None)

    jar = _empty_cohort(LABELS)
    by_id, rules = _overrides(overrides.get('jar', {}), packages, statuses)
    feasibility = _publications(root, 'feasibility_execution')
    executions = _publications(root, 'executions')
    if executions.keys() - packages.keys():
        raise ValueError('Author execution has no corresponding package in the catalog')
    for package_id, identity in sorted(packages.items()):
        assessment = _record(feasibility, package_id)
        report = _record(executions, package_id)
        selected = _package_inputs(assessment, report, mappings['author_package'])
        data, code = selected or ('unassessed', 'undetermined')
        individual = by_id.get(package_id)
        data_override = rules.get(data)
        if individual in LABELS:
            category = individual
        elif selected or individual:
            category, _ = execution_verdict(individual or data_override or data, code)
        else:
            category = 'unassessed'
        ran = _author_ran(report)
        if report and report['outcome'] != 'not_run':
            attempted.add(identity)
        if ran:
            executed.add(identity)
        _count(jar, category, ran, individual is not None or data_override is not None)

    return {'project': {'attempted_papers': len(attempted), 'executed_papers': len(executed)},
            'cited': cited, 'jar': jar}


def _current_timestamp(path, progress):
    """Return the published UTC timestamp when the stored counts still match."""
    try:
        saved = json.loads(path.read_bytes())
        if not isinstance(saved, dict):
            return None
        stamp = saved.pop('updated_at', None)
        if not isinstance(stamp, str) or not stamp.endswith('Z'):
            return None
        parsed = datetime.fromisoformat(stamp)
        if parsed.isoformat(timespec='seconds').replace('+00:00', 'Z') != stamp:
            return None
        # Compare JSON values strictly, including the distinction between 0 and false.
        if json.dumps(saved, sort_keys=True) == json.dumps(progress, sort_keys=True):
            return stamp
    except (FileNotFoundError, ValueError):
        pass
    return None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Report a stale snapshot without writing.')
    args = parser.parse_args()
    path = PROJECT / 'site/progress.json'
    try:
        overrides = read_overrides(PROJECT)
        progress = cohort_progress(PROJECT, overrides)
        stamp = _current_timestamp(path, progress)
        if args.check:
            if stamp is None:
                parser.exit(1, 'Site progress is stale. Run scripts/site_progress.py.\n')
        else:
            if any(s.get('reclassify') or any(s.get('ids_by_verdict', {}).values()) for s in overrides.values()):
                if not sys.stdin.isatty():
                    parser.exit(2, 'Manual verdicts require two confirmations in an interactive terminal.\n')
                for name in ('cited', 'jar'):
                    cohort = progress[name]
                    counts = ', '.join(f'{key}={n}' for key, n in sorted(cohort['manual_verdicts'].items()))
                    print(f'{name} manual verdicts: {counts or "none"}')
                for question in ('1/2 Use the manual verdicts shown above?',
                                 '2/2 Write the resulting counts to site/progress.json?'):
                    try:
                        answer = input(question + ' [yes/no] ')
                    except (EOFError, KeyboardInterrupt):
                        answer = ''
                    if answer.strip().lower() != 'yes':
                        parser.exit(1, 'Refresh cancelled.\n')
            if stamp is None:
                stamp = datetime.now(timezone.utc).isoformat(timespec='seconds').replace('+00:00', 'Z')
            _atomic_write(path, encoded({'updated_at': stamp, **progress}))
    except (OSError, ValueError, KeyError) as exc:
        parser.exit(1, f'{exc}\n')


if __name__ == '__main__':
    main()
