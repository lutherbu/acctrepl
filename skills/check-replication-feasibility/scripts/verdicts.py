"""Derive the shared release verdict from the native feasibility evidence."""
from functools import lru_cache
import json
from pathlib import Path

CONTRACT = Path(__file__).resolve().parents[1] / 'references/feasibility_classification.schema.json'


@lru_cache(maxsize=1)
def contract():
    return json.loads(CONTRACT.read_bytes())


def execution_verdict(data_status, execution_readiness, policy=None):
    policy = contract() if policy is None else policy
    data = policy['x_status_mappings']['author_package'].get(data_status, data_status)
    try:
        verdict = policy['x_execution_matrix'][data][execution_readiness]
    except KeyError as error:
        raise ValueError(f'Unknown execution data or code status: {data_status}, {execution_readiness}') from error
    route = policy['x_ready_routes'][execution_readiness] if verdict == 'ready' else None
    return verdict, route


def reproduction_verdict(data_status, policy=None):
    policy = contract() if policy is None else policy
    if data_status == 'no_baseline':
        return 'not_applicable'
    data = policy['x_status_mappings']['independent_reconstruction'].get(data_status, data_status)
    try:
        return policy['x_reproduction_classes'][data]
    except KeyError as error:
        raise ValueError(f'Unknown reconstruction data status: {data_status}') from error


def classify(document, policy=None):
    """Write only deterministic fields. Scope and fit evidence remains intact."""
    if 'package_id' in document:
        scopes = {}
        for scope in document['scopes']:
            scope['classification'], scope['route'] = execution_verdict(
                scope['data_status'], scope['execution_readiness'], policy)
            if scope['id'] in scopes:
                raise ValueError(f'Duplicate scope: {scope["id"]}')
            scopes[scope['id']] = scope
        if 'full_pipeline' not in scopes:
            raise ValueError('Missing full_pipeline assessment')
        selected = scopes.get('analysis_only', scopes['full_pipeline'])
        document.update(classification=selected['classification'], classification_scope=selected['id'],
                        route=selected['route'])
    else:
        classes = set()
        for fit in document['assessments']:
            verdict = reproduction_verdict(fit['data_status'], policy)
            fit['classification'] = verdict
            fit['na_reason'] = 'synthetic_only' if verdict == 'not_applicable' else None
            classes.add(verdict)
        if document['eligibility'] == 'no_baseline' and not classes:
            document.update(classification='not_applicable', na_reason='no_baseline')
        elif document['eligibility'] == 'eligible' and classes:
            priority = ('blocked', 'undetermined', 'preparation_required', 'ready', 'not_applicable')
            verdict = next(c for c in priority if c in classes)
            document.update(classification=verdict, na_reason='synthetic_only' if verdict == 'not_applicable' else None)
        else:
            raise ValueError('Paper eligibility disagrees with its baseline fits')
    return document
