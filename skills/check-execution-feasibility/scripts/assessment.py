"""Validate author-package assessments and render proposals; never apply or run code."""
from __future__ import annotations

from copy import deepcopy
from datetime import datetime
import hashlib
import importlib.util
import json
from pathlib import Path
import re
from urllib.parse import urlparse
import zipfile

import jsonschema

SCHEMA = Path(__file__).resolve().parents[1] / 'references/output.schema.json'
LOCAL = {'packaged', 'local'}
DATA_STATES = {'local_available', 'public_acquisition_required', 'restricted_access_required', 'undetermined', 'not_applicable'}


def sha256(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def _read(value):
    return deepcopy(value) if isinstance(value, dict) else json.loads(Path(value).read_text())


def _index(items, name):
    result = {}
    for item in items:
        key = item['id']
        if key in result:
            raise ValueError(f'Duplicate {name} id: {key}')
        result[key] = item
    return result


def _refs(values, known, label):
    missing = set(values) - set(known)
    if missing:
        raise ValueError(f'Unknown {label}: {sorted(missing)}')


def _plain(value):
    return ' '.join(value.split())


def _guard_file(path, expected):
    path = Path(path)
    if not path.is_file() or any(p.is_symlink() for p in (path, *path.parents)):
        raise ValueError(f'Not a plain source/artifact file: {path}')
    if sha256(path) != expected:
        raise ValueError(f'Stale source/artifact hash: {path}')
    return path


def _sources(item):
    result = {}
    for source in item.get('sources', []):
        if source['path'] in result:
            raise ValueError(f"Duplicate source path: {source['path']}")
        original = source.get('original_path', source.get('content_path'))
        if original is None:
            raise ValueError(f"Source has no frozen path: {source['path']}")
        _guard_file(original, source['sha256'])
        content = source.get('content_path', original)
        content_hash = source.get('content_sha256', source['sha256'])
        _guard_file(content, content_hash)
        result[source['path']] = {**source, '_text': Path(content).read_text(encoding='utf-8', errors='replace')}
    return result


def _artifact(evidence, item, workdir):
    path = Path(evidence['artifact_path'])
    if not path.is_absolute():
        path = workdir / path
    resolved = path.resolve()
    frozen = {str(Path(a['path']).resolve()): a['sha256'] for a in item.get('artifacts', [])}
    if not resolved.is_relative_to(workdir.resolve()) and frozen.get(str(resolved)) != evidence['sha256']:
        raise ValueError('Probe/inspection artifact is outside the assigned work directory and frozen artifact registry')
    _guard_file(path, evidence['sha256'])
    value = json.loads(path.read_text())
    if not isinstance(value, dict):
        raise ValueError('Probe/inspection artifact must be a JSON object')
    return value


def _validate_evidence(evidence, sources, item, workdir):
    artifacts = {}
    for eid, ev in evidence.items():
        if ev['kind'] == 'source' or ('file' in ev and 'artifact_path' not in ev):
            if ev.get('file') not in sources:
                raise ValueError(f'{eid}: source file is not in the frozen work item')
            start, end = ev.get('line_begin'), ev.get('line_end')
            if not isinstance(start, int) or not isinstance(end, int) or start < 1 or end < start:
                raise ValueError(f'{eid}: source evidence needs a valid line range')
            lines = sources[ev['file']]['_text'].splitlines()
            if end > len(lines):
                raise ValueError(f'{eid}: source line range exceeds the cached text')
            if not ev.get('quote') or _plain(ev['quote']) not in _plain('\n'.join(lines[start-1:end])):
                raise ValueError(f'{eid}: evidence quote does not match its source lines')
        elif ev['kind'] in {'probe', 'inspection'}:
            if not all(k in ev for k in ('artifact_path', 'sha256')):
                raise ValueError(f'{eid}: probe/inspection evidence needs an artifact path and hash')
            artifacts[eid] = _artifact(ev, item, workdir)
        elif ev['kind'] == 'public':
            url = urlparse(ev.get('url', ''))
            if url.scheme not in {'http', 'https'} or not url.netloc or not ev.get('quote') or not ev.get('authority'):
                raise ValueError(f'{eid}: public evidence needs URL, authority and supporting quote')
            try:
                datetime.fromisoformat(ev.get('checked_at', '').replace('Z', '+00:00'))
            except ValueError as exc:
                raise ValueError(f'{eid}: public evidence needs an ISO access date') from exc
        elif ev['kind'] == 'catalog':
            if not ev.get('description'):
                raise ValueError(f'{eid}: missing catalog evidence description')
    return artifacts


def _probe_matches(route, evidence_ids, artifacts):
    for eid in evidence_ids:
        artifact = artifacts.get(eid, {})
        result = artifact.get('result', {})
        if artifact.get('status') != 'ok' or not result.get('readable'):
            continue
        if str(result.get('location')) != route['location']:
            continue
        if not set(x.casefold() for x in route.get('expected_fields', [])) <= set(str(x).casefold() for x in result.get('columns', [])):
            continue
        return True
    return False


def requirement_outcome(requirement):
    routes = requirement['routes']
    if any(r['status'] == 'verified' and r['type'] in LOCAL for r in routes):
        return 'local_available'
    if any(r['status'] == 'verified' and r['type'] == 'public' for r in routes):
        return 'public_acquisition_required'
    if routes and all(r['status'] == 'blocked' for r in routes) and any(r['type'] == 'restricted' for r in routes):
        return 'restricted_access_required'
    return 'undetermined'


def _data_status(scope, requirements):
    if not scope['data_required']:
        if scope['requirement_ids']:
            raise ValueError(f"{scope['id']}: data_required=false cannot bypass mandatory data requirements")
        return 'not_applicable'
    values = [requirements[r]['outcome'] for r in scope['requirement_ids']]
    if not values:
        return 'undetermined'
    for status in ('restricted_access_required', 'undetermined', 'public_acquisition_required'):
        if status in values:
            return status
    return 'local_available'


def _readiness(scope, requirements, software, issues, actions):
    if not scope['has_code']:
        return 'no_runnable_code'
    sis = [issues[i] for i in scope['issue_ids']]
    sws = [software[i] for i in scope['software_ids']]
    if scope['data_status'] == 'restricted_access_required' or any(i['severity'] == 'blocking' for i in sis) or any(s['status'] == 'blocked' for s in sws):
        return 'blocked'
    act = [a for a in actions if scope['id'] in a['scope_ids']]
    if (scope['data_status'] == 'undetermined' or not scope['closure_complete']
            or any(i['severity'] == 'unresolved' for i in sis)
            or any(s['status'] == 'unverified' for s in sws)
            or any(a['certainty'] != 'supported' and a['kind'] != 'run_procedure' for a in act)):
        return 'undetermined'
    if (scope['data_status'] == 'public_acquisition_required'
            or any(i['severity'] == 'preparation' for i in sis)
            or any(s['status'] == 'preparation_required' for s in sws)
            or any(a['kind'] != 'run_procedure' for a in act)):
        return 'preparation_required'
    return 'ready_to_attempt'


def _fence(text):
    longest = max((len(m[0]) for m in re.finditer(r'`+', text)), default=0)
    mark = '`' * max(3, longest + 1)
    return f'{mark}\n{text}\n{mark}'


def render_proposal(assessment):
    """Render only from structured records; it is a proposal, never an applied patch."""
    d = assessment
    lines = [f"# Patch proposal: {d['package_id']}", '']
    if d.get('title'):
        lines += [d['title'], '']
    if d.get('doi'):
        lines += [f"DOI: {d['doi']}", '']
    lines += ['Status: proposal only. No author code has been changed or executed.', '',
             '## Target and readiness', '',
             '| Scope | Classification | Ready route | Data access | Execution readiness |', '|---|---|---|---|---|']
    for scope in d['scopes']:
        lines.append(f"| {scope['id']} | {scope['classification']} | {scope['route'] or '—'} | {scope['data_status']} | {scope['execution_readiness']} |")
    for scope in d['scopes']:
        lines += ['', f"### {scope['id']}", '', scope['description'], '',
                  'Entry points: ' + (', '.join(f'`{p}`' for p in scope['entry_points']) or 'No runnable entry point established.'),
                  '', 'Dependency closure: ' + ('established for this scope.' if scope['closure_complete'] else 'unresolved; see the issues and actions below.')]
    lines += ['', '## Source provenance', '', _fence(json.dumps(d['provenance'], indent=2, sort_keys=True)), '', '## Proposed actions', '']
    if not d['actions']:
        lines += ['No source changes or additional preparation actions were identified within the assessed scope.',
                  'Use the recorded entry points only after a separate execution decision; successful execution remains unverified.']
    for action in d['actions']:
        lines += [f"### {action['id']}: {action['description']}", '',
                  f"Scopes: {', '.join(action['scope_ids'])}. Type: {action['kind']}. Certainty: {action['certainty']}.",
                  'Addresses: ' + (', '.join(action['addresses']) or 'run procedure'),
                  'Evidence: ' + (', '.join(action['evidence_ids']) or 'none'), '']
        for edit in action['edits']:
            loc = f"{edit['file']}:{edit['line_begin']}–{edit['line_end']}"
            if edit.get('cell_id'):
                loc += f" (cell {edit['cell_id']})"
            lines += [f'**Proposed edit:** `{loc}`', f"Source SHA-256: `{edit['sha256']}`", '', edit['reason'], '',
                      'Current text:', _fence(edit['before']), '', 'Proposed replacement:', _fence(edit['after']), '']
        if action['steps']:
            lines += ['Preparation / proposed procedure:', ''] + [f'{i}. {step}' for i, step in enumerate(action['steps'], 1)] + ['']
        if action['validation']:
            lines += ['Validation to perform later:', ''] + [f'- {step}' for step in action['validation']] + ['']
    lines += ['', '## Remaining issues and prerequisites', '']
    if not d['issues']:
        lines.append('No separate issues were identified; data and software requirements still retain their stated verification limits.')
    for issue in d['issues']:
        lines.append(f"- {issue['id']} [{issue['severity']}; {', '.join(issue['scope_ids'])}]: {issue['description']}")
    for requirement in d['requirements']:
        if requirement['outcome'] != 'local_available':
            lines.append(f"- {requirement['id']} [{requirement['outcome']}]: {requirement['description']}")
    for software in d['software']:
        if software['status'] != 'available':
            lines.append(f"- {software['id']} [{software['status']}]: {software['description']}")
    if d['review_notes']:
        lines += ['', '## Review notes', ''] + ['- ' + note for note in d['review_notes']]
    return '\n'.join(lines).rstrip() + '\n'


def finalize(item, draft, output_dir=None):
    """Return a validated assessment; optionally write assessment.json and its proposal."""
    work_item_path = None if isinstance(item, dict) else Path(item).resolve()
    raw_item = _read(item)
    d = _read(draft)
    workdir = Path(raw_item.get('work_dir', work_item_path.parent if work_item_path else '.')).resolve()
    header = raw_item.get('output_header', {})
    if d.get('package_id') != header.get('package_id', raw_item.get('package_id')):
        raise ValueError('Package identity differs from the frozen work item')
    for key, value in header.items():
        if key == 'provenance':
            continue
        if key in d and d[key] != value:
            raise ValueError(f'Frozen output_header mismatch: {key}')
        d[key] = deepcopy(value)
    provenance = header.get('provenance', {})
    if any(d.get('provenance', {}).get(k) != v for k, v in provenance.items()):
        raise ValueError('Provenance differs from the frozen output_header')
    if set(d.get('provenance', {})) - set(provenance) - {'work_item_sha256'}:
        raise ValueError('Provenance has unrecognized non-frozen fields')
    item_hash = sha256(work_item_path) if work_item_path else hashlib.sha256(json.dumps(raw_item, sort_keys=True).encode()).hexdigest()
    if d.get('provenance', {}).get('work_item_sha256', item_hash) != item_hash:
        raise ValueError('Work item changed after the draft was made')
    d['provenance'] = {**provenance, 'work_item_sha256': item_hash}
    # Computed fields may be omitted in drafts; submitted claims are recomputed below.
    if d.get('patch_proposal', {}).get('applied', False):
        raise ValueError('This skill cannot report an applied patch')
    d.pop('patch_proposal', None)
    jsonschema.Draft202012Validator(json.loads(SCHEMA.read_text())).validate(d)
    for frozen in raw_item.get('frozen_files', []):
        _guard_file(frozen['path'], frozen['sha256'])
    claimed_scopes = {s['id']: {k: s[k] for k in ('data_status', 'execution_readiness') if k in s} for s in d['scopes']}
    claimed_requirements = {r['id']: r['outcome'] for r in d['requirements'] if 'outcome' in r}
    sources = _sources(raw_item)
    evs = _index(d['evidence'], 'evidence')
    requirements = _index(d['requirements'], 'requirement')
    software = _index(d['software'], 'software')
    issues = _index(d['issues'], 'issue')
    scopes = _index(d['scopes'], 'scope')
    actions = _index(d['actions'], 'action')
    all_ids = list(evs) + list(requirements) + list(software) + list(issues) + list(actions)
    if len(set(all_ids)) != len(all_ids):
        raise ValueError('IDs must be unique across evidence, requirements, software, issues and actions')
    if 'full_pipeline' not in scopes:
        raise ValueError('A full_pipeline assessment is required')
    artifacts = _validate_evidence(evs, sources, raw_item, workdir)
    for collection in (d['software'], d['issues'], d['scopes'], d['actions'], d['dependency_review']):
        for value in collection:
            _refs(value['evidence_ids'], evs, 'evidence IDs')
    for requirement in requirements.values():
        _refs(requirement['scopes'], scopes, 'requirement scopes')
        _index(requirement['routes'], 'route')
        for route in requirement['routes']:
            _refs(route['evidence_ids'], evs, 'route evidence IDs')
            cited = [evs[e] for e in route['evidence_ids']]
            if route['status'] == 'verified':
                if route['type'] in LOCAL and not _probe_matches(route, route['evidence_ids'], artifacts):
                    raise ValueError(f"{requirement['id']}: local verification needs a matching readable probe and expected fields")
                if route['type'] == 'public' and not any(e['kind'] == 'public' for e in cited):
                    raise ValueError(f"{requirement['id']}: public verification needs authoritative dated URL evidence")
                if route['type'] == 'restricted':
                    raise ValueError('Restricted is an access-barrier route, not a verified delivery route; use local/public if access is established')
            if route['status'] == 'blocked' and route['type'] == 'restricted':
                if not any(e['kind'] in {'source', 'public'} and e.get('access_barrier') for e in cited):
                    raise ValueError('A restricted barrier needs explicit source/public access-barrier evidence, not catalog absence')
        requirement['outcome'] = requirement_outcome(requirement)
    for sw in software.values():
        if sw['status'] == 'available':
            found = False
            for eid in sw['evidence_ids']:
                a = artifacts.get(eid, {})
                result = a.get('result', {})
                local = result.get('software', {}).get(sw['name'], {})
                found |= a.get('status') == 'ok' and ((result.get('location') == 'software:' + sw['name'] and result.get('available') is True) or local.get('available') is True)
            if not found:
                raise ValueError(f"{sw['id']}: available software needs a matching successful software probe")
    addressed = set()
    for action in actions.values():
        _refs(action['scope_ids'], scopes, 'action scopes')
        _refs(action['addresses'], {**requirements, **software, **issues}, 'action targets')
        if action['kind'] != 'run_procedure' and not action['addresses']:
            raise ValueError('A preparation/edit action must address an identified requirement, software dependency or issue')
        if not action['evidence_ids']:
            raise ValueError(f"{action['id']}: actions need supporting evidence")
        if action['kind'] == 'source_edit' and not action['edits']:
            raise ValueError('A source_edit action requires exact edits; use clarification for an unresolved proposed change')
        if not action['steps'] and not action['edits']:
            raise ValueError('An action must contain concrete steps or an anchored edit')
        if not action['validation']:
            raise ValueError('Each action needs future validation steps')
        for edit in action['edits']:
            source = sources.get(edit['file'])
            if source is None or source['sha256'] != edit['sha256']:
                raise ValueError('Edit does not match a frozen source file/hash')
            original = source.get('original_path', source.get('content_path'))
            if (Path(edit['file']).suffix.lower() in {'.pdf', '.docx'}
                    or zipfile.is_zipfile(original)):
                raise ValueError('Binary documentation cannot receive a source line edit')
            lines = source['_text'].splitlines()
            start, end = edit['line_begin'], edit['line_end']
            if end < start or end > len(lines):
                raise ValueError('Edit line range is invalid')
            before = '\n'.join(lines[start-1:end])
            if before != edit['before'].rstrip('\n') or edit['before'] == edit['after']:
                raise ValueError('Edit before-text does not match, or edit makes no change')
            if Path(edit['file']).suffix.lower() == '.ipynb':
                if not edit.get('cell_id'):
                    raise ValueError('Notebook edits require a cell_id')
                locations = source.get('locations', {})
                for line in range(start, end + 1):
                    loc = locations.get(str(line), locations.get(line, {}))
                    if loc.get('cell_id') != edit['cell_id']:
                        raise ValueError('Notebook edit crosses or mismatches a frozen cell')
        addressed.update(action['addresses'])
    needed = {r['id'] for r in requirements.values() if r['outcome'] != 'local_available'}
    needed |= {s['id'] for s in software.values() if s['status'] != 'available'}
    needed |= set(issues)
    if needed - addressed:
        raise ValueError(f'Known prerequisites/issues lack proposal actions: {sorted(needed-addressed)}')
    for issue in issues.values():
        _refs(issue['scope_ids'], scopes, 'issue scopes')
    for scope in scopes.values():
        needed_here = {r['id'] for r in requirements.values() if scope['id'] in r['scopes'] and r['outcome'] != 'local_available'}
        needed_here |= {sid for sid in scope['software_ids'] if sid in software and software[sid]['status'] != 'available'}
        needed_here |= set(scope['issue_ids'])
        addressed_here = {target for a in actions.values() if scope['id'] in a['scope_ids'] for target in a['addresses']}
        if needed_here - addressed_here:
            raise ValueError(f"{scope['id']}: prerequisites lack actions for this scope: {sorted(needed_here-addressed_here)}")
        _refs(scope['entry_points'], sources, 'entry point source files')
        _refs(scope['requirement_ids'], requirements, 'scope data requirements')
        _refs(scope['software_ids'], software, 'scope software')
        _refs(scope['issue_ids'], issues, 'scope issues')
        expected = {r['id'] for r in requirements.values() if scope['id'] in r['scopes']}
        if set(scope['requirement_ids']) != expected:
            raise ValueError(f"{scope['id']}: requirement scope membership is inconsistent")
        expected_issues = {i['id'] for i in issues.values() if scope['id'] in i['scope_ids']}
        if set(scope['issue_ids']) != expected_issues:
            raise ValueError(f"{scope['id']}: issue scope membership is inconsistent")
        if scope['has_code'] and (not scope['entry_points'] or not scope['software_ids']):
            raise ValueError('Runnable scope needs explicit entry points and required runtime/software')
        if not scope['closure_complete'] and not any(issues[i]['severity'] == 'unresolved' for i in scope['issue_ids']):
            raise ValueError('Incomplete closure needs an explicit unresolved issue/action')
        if not scope['has_code'] and not scope['issue_ids']:
            raise ValueError('No-code scope needs an explicit missing-code issue/action')
        if scope['data_required'] and not scope['requirement_ids'] and not any(issues[i]['severity']=='unresolved' for i in scope['issue_ids']):
            raise ValueError('Unknown mandatory data inputs need an unresolved issue/action')
        scope['data_status'] = _data_status(scope, requirements)
        scope['execution_readiness'] = _readiness(scope, requirements, software, issues, d['actions'])
        scope['execution_verified'] = False
    expected_deps = {x['id'] for x in raw_item.get('dependencies', raw_item.get('dependency_checklist', []))}
    reviewed = set()
    for review in d['dependency_review']:
        dependency_ids = review.get('dependency_ids', [review.get('dependency_id')])
        if not set(dependency_ids) <= expected_deps:
            raise ValueError('Dependency review names a non-frozen dependency')
        _refs(review['scope_ids'], scopes, 'dependency review scopes')
        target_kind = {'requirement': requirements, 'issue': issues, 'software': software}.get(review['disposition'])
        if target_kind is not None:
            if not review['target_ids']:
                raise ValueError('Dependency disposition requires linked targets')
            _refs(review['target_ids'], target_kind, 'dependency review targets')
        elif review['target_ids']:
            raise ValueError('Generated/optional dependency reviews use evidence, not arbitrary target IDs')
        if not review['evidence_ids']:
            raise ValueError('Dependency dispositions need evidence')
        if review['disposition'] == 'generated' and not any(evs[e]['kind'] == 'source' for e in review['evidence_ids']):
            raise ValueError('Generated input needs source evidence for its producer')
        reviewed.update(dependency_ids)
    if expected_deps - reviewed:
        raise ValueError(f'Unreviewed frozen dependencies: {sorted(expected_deps-reviewed)}')
    for sid, claims in claimed_scopes.items():
        if any(scopes[sid][key] != value for key, value in claims.items()):
            raise ValueError(f'{sid}: submitted readiness claim differs from evidence-computed outcome')
    for rid, claim in claimed_requirements.items():
        if requirements[rid]['outcome'] != claim:
            raise ValueError(f'{rid}: submitted data claim differs from evidence-computed outcome')
    if 'preclassification_sha256' in d:
        raise ValueError('A new assessment cannot claim a historical publication checksum')
    # The prepared skill carries the same sibling layout as an installed checkout.
    contract_record = raw_item.get('classification_contract')
    if contract_record:
        expected = workdir / 'check-replication-feasibility/references/feasibility_classification.schema.json'
        if contract_record != {'path': str(expected), 'sha256': sha256(expected)}:
            raise ValueError('Invalid frozen classification contract')
        rules_path = expected.parents[1] / 'scripts/verdicts.py'
        if {'path': str(rules_path), 'sha256': sha256(rules_path)} not in raw_item['frozen_files']:
            raise ValueError('Missing frozen classification helper')
    else:
        rules_path = SCHEMA.parents[2] / 'check-replication-feasibility/scripts/verdicts.py'
    spec = importlib.util.spec_from_file_location('author_feasibility_verdicts', rules_path)
    rules = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(rules)
    rules.classify(d)
    proposal_text = render_proposal(d)
    d['patch_proposal'] = {'path': 'patch_proposal.md', 'sha256': hashlib.sha256(proposal_text.encode()).hexdigest(), 'applied': False}
    jsonschema.Draft202012Validator(json.loads(SCHEMA.read_text())).validate(d)
    if output_dir is not None:
        out = Path(output_dir).resolve()
        if not out.is_relative_to(workdir):
            raise ValueError('Output directory must remain within the assigned work directory')
        if raw_item.get('output_dir') and out != Path(raw_item['output_dir']).resolve():
            raise ValueError('Output directory differs from the assigned output directory')
        protected = [workdir / name for name in ('reading', 'probes', 'skill_snapshot')]
        if raw_item.get('package_root'):
            protected.append(Path(raw_item['package_root']).resolve())
        if any(out == folder or out.is_relative_to(folder) for folder in protected):
            raise ValueError('Output directory overlaps protected package/evidence inputs')
        # An assessment may write only to the task output directory, never a source tree.
        if any(Path(s.get('original_path') or s['content_path']).resolve().is_relative_to(out.resolve()) for s in raw_item.get('sources', [])):
            raise ValueError('Output directory contains original source files')
        out.mkdir(parents=True, exist_ok=True)
        (out / 'patch_proposal.md').write_text(proposal_text, encoding='utf-8')
        (out / 'assessment.json').write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    return d
