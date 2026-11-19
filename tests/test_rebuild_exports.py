"""Checks for the checkout-derived index, manifest and export formats."""
import hashlib
import json
from pathlib import Path

import pytest

from scripts import rebuild_exports as exports
from scripts import rebuild_indexes as indexes


def put(p, record):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_bytes(indexes.encoded(record))
    return p


def test_indexes_and_exports_are_complete_and_ordered(tmp_path):
    records = tmp_path / 'output/samples/records'
    for pid in ('W3','W1','W2'):
        put(records / (pid + '.json'), {'paper_id':pid,'text':'\u2028café'})
    cache = tmp_path / '.local/exports'
    docs = indexes.rebuild(tmp_path)
    assert list(docs) == ['output/samples/index.json','output/manifest.json']
    index = docs['output/samples/index.json']['records']
    assert [row['id'] for row in index] == ['W1','W2','W3']
    assert all(set(row) == {'id','path','sha256'} for row in index)
    output = exports.rebuild(tmp_path, ['samples'], cache)['samples']
    with output.open() as f:
        assert [json.loads(line)['paper_id'] for line in f] == ['W1','W2','W3']
    initial = output.read_bytes()
    put(records / 'W3.json', {'paper_id':'wrong'})
    with pytest.raises(ValueError):
        exports.rebuild(tmp_path,['samples'],cache)
    assert output.read_bytes() == initial


def test_checked_accepted_pointer_and_digest(tmp_path):
    package = tmp_path / 'output/reproductions/packages/W1'
    result = put(package/'attempt_02/outcome.json', {'paper_id':'W1','attempt':2})
    receipt = {'attempt':2,'path':'output/reproductions/packages/W1/attempt_02','outcome_sha256':indexes.sha(result)}
    put(package/'accepted.json',receipt)
    indexes.rebuild(tmp_path)
    indexes.rebuild(tmp_path,check=True)
    result.write_text('{"paper_id":"W1","attempt":2}')
    with pytest.raises(ValueError,match='receipt'):
        indexes.rebuild(tmp_path,check=True)
    receipt['path'] = '../private'
    put(package/'accepted.json',receipt)
    with pytest.raises(ValueError,match='directory mismatch'):
        indexes.rebuild(tmp_path)


def test_read_only_check_does_not_create_missing_indexes(tmp_path):
    put(tmp_path/'output/executions/packages/jar-1/report.json', {'package_id':'jar-1'})
    with pytest.raises(ValueError,match='Missing or stale'):
        indexes.rebuild(tmp_path,check=True)
    assert not (tmp_path/'output/manifest.json').exists()
