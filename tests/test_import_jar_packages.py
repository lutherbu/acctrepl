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
    assert first['verification']['files'] == first['verification']['copied'] == 2
    assert first['packages'][0]['package_id'] == 'jar-existing-id'
    assert first['packages'][0]['package_path'] == 'JAR-Volume 51/Issue 3/paper/code.zip'
    assert first['packages'][0]['material_files'] == ['JAR-Volume 51/Issue 3/paper/datasheet.pdf']
    assert {p.name for p in (destination / '_provenance/JAR').iterdir()} == {'import_manifest.json'}
    assert (destination / '.gitkeep').is_file()
    copied = destination / 'JAR-Volume 51/Issue 3/paper/code.zip'
    original = source / 'Volume 51/Issue 3/paper/code.zip'
    assert copied.read_bytes() == original.read_bytes()
    assert copied.stat().st_ino != original.stat().st_ino
    assert copied.stat().st_nlink == 1
    assert copied.stat().st_mtime_ns == original.stat().st_mtime_ns
    second = module.import_packages(source, destination, audit)
    assert second['verification']['copied'] == 0
    assert second['verification']['skipped_identical'] == 2
    before = (destination / '_provenance/JAR/import_manifest.json').read_bytes()
    verified = module.import_packages(source, destination, audit, verify_only=True)
    assert verified['verification']['sha256_verified'] == 2
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


def test_volume_cutoff_preserves_variants_and_excludes_later_materials(tmp_path):
    source, destination, audit = fixture(tmp_path)
    raw = json.loads(audit.read_bytes())
    for volume in (50, 58, 59):
        directory = Path(f'Volume {volume}/Issue 1/variants')
        paper = source / directory
        paper.mkdir(parents=True)
        for variant in ('original', 'correction'):
            archive = paper / f'{variant}.zip'
            archive.write_bytes(variant.encode())
            raw['units'].append({'id': f'jar-{volume}-{variant}', 'collection': 'jar', 'path': str(archive),
                                 'archive': True, 'paper': str(directory), 'doi': '10/variants', 'title': 'Study'})
    audit.write_text(json.dumps(raw))
    report = module.import_packages(source, destination, audit)
    assert {u['package_id'] for u in report['packages']} == {'jar-existing-id', 'jar-58-original', 'jar-58-correction'}
    assert {p.name for p in destination.glob('JAR-Volume *')} == {'JAR-Volume 51', 'JAR-Volume 58'}
    assert {f['destination_path'] for f in report['files']} == {
        f.relative_to(destination).as_posix() for root in destination.glob('JAR-Volume *') for f in root.rglob('*') if f.is_file()
    }
    assert report['verification']['files'] == 4
    assert report['verification']['paper_directories'] == report['verification']['unique_dois'] == 2
    variants = [u for u in report['packages'] if u['doi'] == '10/variants']
    assert all(len(u['identity_notes']) == 1 and 'archive variants' in u['identity_notes'][0] for u in variants)


def test_audit_path_must_belong_to_its_paper_directory(tmp_path):
    source, destination, audit = fixture(tmp_path)
    raw = json.loads(audit.read_bytes())
    raw['units'][0]['path'] = str(source / 'Volume 59/Issue 3/foreign.zip')
    audit.write_text(json.dumps(raw))
    with pytest.raises(ValueError, match='outside its paper directory'):
        module.import_packages(source, destination, audit)
    assert not destination.exists()
