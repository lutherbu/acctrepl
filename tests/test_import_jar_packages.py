from pathlib import Path
import importlib.util
import json
import os

import pytest

spec = importlib.util.spec_from_file_location('import_jar_packages', Path(__file__).parents[1] / 'scripts/import_jar_packages.py')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


def fixture(tmp_path):
    source = tmp_path / 'source'
    paper = source / 'Volume 51/Issue 3/paper'
    paper.mkdir(parents=True)
    (paper / 'code.zip').write_bytes(b'archive bytes')
    (paper / 'datasheet.pdf').write_bytes(b'pdf bytes')
    (source / '.download_tasks.json').write_text('{}')
    (source / 'download_manifest.csv').write_text('header\n')
    audit = tmp_path / 'audit.json'
    audit.write_text(json.dumps({'units': [{'id': 'jar-existing-id', 'collection': 'jar', 'path': str(paper / 'code.zip'),
                                          'archive': True, 'paper': 'Volume 51/Issue 3/paper', 'doi': '10/test', 'title': 'Title'}]}))
    return source, tmp_path / 'destination', audit


def test_copy_and_repeat_are_verified(tmp_path):
    source, destination, audit = fixture(tmp_path)
    first = module.import_packages(source, destination, audit)
    assert first['verification']['files'] == first['verification']['copied'] == 4
    assert first['packages'][0]['package_id'] == 'jar-existing-id'
    assert first['packages'][0]['package_path'] == 'JAR-Volume 51/Issue 3/paper/code.zip'
    assert first['packages'][0]['material_files'] == ['JAR-Volume 51/Issue 3/paper/datasheet.pdf']
    assert (destination / '_provenance/JAR/.download_tasks.json').is_file()
    assert (destination / '.gitkeep').is_file()
    copied = destination / 'JAR-Volume 51/Issue 3/paper/code.zip'
    original = source / 'Volume 51/Issue 3/paper/code.zip'
    assert copied.read_bytes() == original.read_bytes()
    assert copied.stat().st_ino != original.stat().st_ino
    assert copied.stat().st_nlink == 1
    assert copied.stat().st_mtime_ns == original.stat().st_mtime_ns
    second = module.import_packages(source, destination, audit)
    assert second['verification']['copied'] == 0
    assert second['verification']['skipped_identical'] == 4
    before = (destination / '_provenance/JAR/import_manifest.json').read_bytes()
    verified = module.import_packages(source, destination, audit, verify_only=True)
    assert verified['verification']['sha256_verified'] == 4
    assert (destination / '_provenance/JAR/import_manifest.json').read_bytes() == before


def test_conflict_never_overwritten(tmp_path):
    source, destination, audit = fixture(tmp_path)
    module.import_packages(source, destination, audit)
    conflict = destination / 'JAR-Volume 51/Issue 3/paper/code.zip'
    conflict.write_bytes(b'user contents')
    with pytest.raises(FileExistsError):
        module.import_packages(source, destination, audit)
    assert conflict.read_bytes() == b'user contents'


def test_missing_copy_in_verify_only_fails(tmp_path):
    source, destination, audit = fixture(tmp_path)
    with pytest.raises(FileNotFoundError):
        module.import_packages(source, destination, audit, verify_only=True)
    assert not destination.exists()


@pytest.mark.parametrize('name', ['../outside', '/absolute', 'C:/absolute'])
def test_traversal_rejected(name):
    with pytest.raises(ValueError): module.destination_relative(name)


def test_source_symlink_rejected(tmp_path):
    source, destination, audit = fixture(tmp_path)
    (source / 'link').symlink_to(source / 'download_manifest.csv')
    with pytest.raises(ValueError): module.import_packages(source, destination, audit)
    assert not destination.exists()


def test_destination_symlink_rejected(tmp_path):
    source, destination, audit = fixture(tmp_path)
    destination.mkdir()
    (destination / 'JAR-Volume 51').symlink_to(tmp_path / 'outside', target_is_directory=True)
    with pytest.raises(ValueError): module.import_packages(source, destination, audit)
    assert not (tmp_path / 'outside').exists()


def test_duplicate_doi_folders_are_retained(tmp_path):
    source, destination, audit = fixture(tmp_path)
    other = source / 'Volume 51/Issue 3/other paper'
    other.mkdir(); (other / 'code.zip').write_bytes(b'other')
    raw = json.loads(audit.read_text())
    raw['units'].append({'id': 'jar-other-id', 'collection': 'jar', 'path': str(other / 'code.zip'),
                         'archive': True, 'paper': 'Volume 51/Issue 3/other paper', 'doi': '10/test', 'title': 'Other title'})
    audit.write_text(json.dumps(raw))
    result = module.import_packages(source, destination, audit)
    assert len(result['packages']) == 2
    assert all(len(p['identity_notes']) == 2 for p in result['packages'])
    assert result['verification']['paper_directories'] == 2
    assert result['verification']['unique_dois'] == 1
