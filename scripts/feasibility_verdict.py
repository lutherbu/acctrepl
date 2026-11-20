"""Shared verdicts and checksum verification for historical feasibility publications."""
from copy import deepcopy
import hashlib
from importlib import import_module
import json
from pathlib import Path
import sys

# Also support scripts invoked directly from the repository root.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
_rules = import_module('skills.check-replication-feasibility.scripts.verdicts')
execution_verdict = _rules.execution_verdict
reproduction_verdict = _rules.reproduction_verdict
classify = _rules.classify
LABELS = _rules.contract()['x_class_labels']


def reviewed_bytes(document):
    """Verify added reporting fields and recover the exact pre-migration publication."""
    original = deepcopy(document)
    expected = original.pop('preclassification_sha256')
    if 'scopes' in document:
        top, nested, rows = ('classification', 'classification_scope', 'route'), ('classification', 'route'), 'scopes'
    else:
        top, nested, rows = ('classification', 'na_reason'), ('classification', 'na_reason'), 'assessments'
    for key in top:
        del original[key]
    for row in original[rows]:
        for key in nested:
            del row[key]
    raw = (json.dumps(original, ensure_ascii=False, indent=2, allow_nan=False) + '\n').encode()
    if hashlib.sha256(raw).hexdigest() != expected:
        raise ValueError('Feasibility evidence differs from its preclassification checksum')
    classified = classify(original)
    classified['preclassification_sha256'] = expected
    if classified != document:
        raise ValueError('Published feasibility verdict disagrees with its saved evidence')
    return raw


def matches_frozen_input(path, expected, project, digest):
    """Accept a pinned source or its byte-exact, evidence-preserving feasibility migration."""
    if not path.is_file():
        return False
    if digest(path) == expected:
        return True
    records = project / 'output/feasibility_reproduction/records'
    packages = project / 'output/feasibility_execution/packages'
    if not (path.parent == records or (path.name == 'assessment.json' and path.parent.parent == packages)):
        return False
    document = json.loads(path.read_bytes())
    if document.get('preclassification_sha256') != expected:
        return False
    # This recalculates the verdict and checksum over the original evidence.
    reviewed_bytes(document)
    return True
