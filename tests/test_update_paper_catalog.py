"""Synthetic metadata fixtures; no paper/package content, APIs or parsing."""
import csv
import importlib.util
import io
import json
from pathlib import Path
import tempfile

import pytest

SPEC = importlib.util.spec_from_file_location('update_paper_catalog', Path(__file__).parents[1] / 'scripts/update_paper_catalog.py')
c = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(c)


def sample_catalog():
    rows = []
    for pid, links in [('W1', ['jar-overlap']), ('W2', []), ('jar-first', ['jar-first']), ('jar-second', ['jar-second'])]:
        row = {field: None for field in c.FIELDS}
        row.update(paper_id=pid, doi='10/example', cohorts=['jar_package'],
                   jar_packages=[{'package_id': link} for link in links])
        rows.append(row)
    return rows


def put_json(root, relative, value):
    path = root / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False) + '\n')
    return path


def test_csv_jsonl_semantics_round_trip_and_original_column_order():
    records = sample_catalog()
    encoded, csv_bytes = c.serialize_catalog(records)
    assert csv_bytes.startswith(b'\xef\xbb\xbf')
    parsed_csv = list(csv.DictReader(io.StringIO(csv_bytes.decode('utf-8-sig'), newline='')))
    assert list(parsed_csv[0]) == list(c.FIELDS)
    assert [r['paper_id'] for r in parsed_csv] == [r['paper_id'] for r in records]
    with tempfile.TemporaryDirectory() as temporary:
        path = Path(temporary) / 'rows.jsonl'; path.write_bytes(encoded)
        assert c.read_jsonl(path) == records
    for record, csv_row in zip(records, parsed_csv):
        for key, value in record.items():
            if isinstance(value, (list, dict)):
                assert json.loads(csv_row[key]) == value
            elif value is None:
                assert csv_row[key] == ''
            else:
                assert csv_row[key] == str(value)


def test_jsonl_reader_preserves_literal_unicode_line_separator_in_abstract(tmp_path):
    path = tmp_path / 'cache.jsonl'
    original = {'id': 'https://openalex.org/W1', 'abstract_inverted_index': {'a\u2028b': [0]}}
    path.write_text(json.dumps(original, ensure_ascii=False) + '\n')
    assert c.read_jsonl(path) == [original]


def test_paper_links_use_unambiguous_ids_and_package_links_never_use_doi(tmp_path):
    catalog = sample_catalog()
    by_id = {row['paper_id']: row for row in catalog}
    by_id['jar-first']['openalex_id'] = 'https://openalex.org/W99'
    by_id['jar-second']['openalex_id'] = 'https://openalex.org/W99'
    model = 'output/models/records/W99.json'; put_json(tmp_path, model, {'paper_id': 'W99'})
    package = 'output/executions/packages/jar-first/report.json'; put_json(tmp_path, package, {'package_id': 'jar-first'})
    inventory = {'model_path': [{'paper_id': 'W99', 'path': model}],
                 'execution_path': [{'package_id': 'jar-first', 'path': package}]}
    linked, summary = c.link_results(catalog, inventory, tmp_path); mapped = {row['paper_id']: row for row in linked}
    assert mapped['jar-first']['model_path'] == mapped['jar-second']['model_path'] == model
    assert mapped['jar-first']['execution_path'] == package
    assert mapped['jar-second']['execution_path'] is None
    other = 'output/models/records/another.json'; put_json(tmp_path, other, {'paper_id': 'another'})
    inventory['model_path'].append({'paper_id': 'another', 'openalex_id': 'https://openalex.org/W99', 'path': other})
    linked, summary = c.link_results(catalog, inventory, tmp_path)
    assert next(row for row in linked if row['paper_id'] == 'jar-first')['model_path'] is None
    assert len(summary['ambiguous_result_links']) == 2


def test_multiple_package_results_remain_null_when_single_catalog_cell_is_ambiguous(tmp_path):
    catalog = sample_catalog(); catalog[0]['jar_packages'].append(catalog[2]['jar_packages'][0])
    inventory = {'feasibility_execution_path': []}
    for pid in ['jar-overlap', 'jar-first']:
        relative = f'output/feasibility_execution/packages/{pid}/assessment.json'
        put_json(tmp_path, relative, {'package_id': pid})
        inventory['feasibility_execution_path'].append({'package_id': pid, 'path': relative})
    linked, summary = c.link_results(catalog, inventory, tmp_path)
    assert linked[0]['feasibility_execution_path'] is None
    assert summary['ambiguous_result_links'][0]['paper_id'] == 'W1'


def test_missing_result_files_and_unrun_units_reset_to_null(tmp_path):
    catalog = sample_catalog()
    for row in catalog:
        row.update({field: 'output/models/stale.json' for field in c.RESULT_FIELDS})
    linked, summary = c.link_results(catalog, {'model_path': [{'paper_id': 'W1', 'path': 'output/models/missing.json'}]}, tmp_path)
    assert all(row[field] is None for row in linked for field in c.RESULT_FIELDS)
    assert set(summary['result_link_counts'].values()) == {0}


def test_catalog_defaults_prefer_docs_and_preserve_legacy_root_fixtures(tmp_path):
    assert c.catalog_paths(tmp_path) == (tmp_path / 'docs/papers.jsonl', tmp_path / 'docs/papers.csv')
    (tmp_path / 'papers.jsonl').write_text('{}\n')
    assert c.catalog_paths(tmp_path) == (tmp_path / 'papers.jsonl', tmp_path / 'papers.csv')
    (tmp_path / 'docs').mkdir(); (tmp_path / 'docs/papers.jsonl').write_text('{}\n')
    assert c.catalog_paths(tmp_path) == (tmp_path / 'docs/papers.jsonl', tmp_path / 'docs/papers.csv')


def test_cli_relinks_public_inputs_without_an_index_or_a_private_catalog(tmp_path):
    records = sample_catalog()
    root = tmp_path / 'renamed project'
    docs = root / 'docs'
    docs.mkdir(parents=True)
    metadata = docs / 'papers.jsonl'
    metadata.write_bytes(c.serialize_catalog(records)[0])
    folder = root / 'output/models/records'
    folder.mkdir(parents=True)
    (folder/'W1.json').write_text('{"paper_id":"W1"}')
    assert c.main(['--project-root',str(root)]) == 0
    assert c.main(['--project-root',str(root),'--check']) == 0
    row=next(r for r in c.read_jsonl(metadata) if r['paper_id']=='W1')
    assert row['model_path']=='output/models/records/W1.json'
    assert not (root/'output/manifest.json').exists()
