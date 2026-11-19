#!/usr/bin/env python3
"""Prepare the minimal working inputs for a published author execution."""
import argparse
from contextlib import ExitStack
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]


def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def inside(root, relative):
    name = PurePosixPath(relative)
    if name.is_absolute() or re.match(r'^[A-Za-z]:', str(name)) or not name.parts or '..' in name.parts or '\\' in str(name):
        raise ValueError(f'Invalid relative path: {relative}')
    target = root / name
    if target.resolve() != target or not target.is_relative_to(root):
        raise ValueError(f'Path escapes its directory: {relative}')
    return target


def member(archive, name):
    # Select an exact byte stream. Never interpret archive paths as local filenames.
    matches = [item for item in archive.infolist() if item.filename == name and not item.is_dir()]
    if len(matches) != 1:
        raise ValueError(f'Missing or ambiguous archive member: {name}')
    return matches[0]


def copy_member(stack, archive, entry, target):
    names = entry['members']
    if len(names) not in (1, 2):
        raise ValueError('Expected one archive member or one nested ZIP')
    if len(names) == 2:
        temporary = stack.enter_context(tempfile.TemporaryFile())
        with archive.open(member(archive, names[0])) as source:
            shutil.copyfileobj(source, temporary, 1024 * 1024)
        temporary.seek(0)
        archive = stack.enter_context(zipfile.ZipFile(temporary))
    info = member(archive, names[-1])
    if info.file_size != entry['bytes']:
        raise ValueError(f'Unexpected size: {info.filename}')
    with archive.open(info) as source, target.open('wb') as output:
        shutil.copyfileobj(source, output, 1024 * 1024)
    if sha(target) != entry['sha256']:
        raise ValueError(f'Archive member checksum mismatch: {info.filename}')


def rendered(root, package, entry, destination=None):
    template = inside(package, entry['template'])
    if not template.is_relative_to(package / 'code') or sha(template) != entry['template_sha256']:
        raise ValueError(f"Code template checksum mismatch: {entry['template']}")
    work = (destination or package) / 'work'
    resources = root / 'output/executions/resources'
    # Source-language quoted paths need a valid single-line literal.
    for path in (work, resources):
        if any(ch in str(path) for ch in ('"', "'", '\n', '\r', '`', '$', '\\')):
            raise ValueError(f'Unsupported quote or expansion character in checkout path: {path}')
    return template.read_bytes().replace(b'@@ACCTREPL_WORK@@', os.fsencode(work)).replace(
        b'@@ACCTREPL_RESOURCES@@', os.fsencode(resources))


def prepare(root, package_id, *, archive_path=None, check=False, verify_archive=False):
    if not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9_-]*', package_id):
        raise ValueError('Invalid package ID')
    package = inside(root, f'output/executions/packages/{package_id}')
    return prepare_package(root, package, package_id, archive_path=archive_path, check=check, verify_archive=verify_archive)


def prepare_package(root, package, package_id, *, archive_path=None, check=False, verify_archive=False, destination=None):
    recipe = json.loads(inside(package, 'local_inputs.json').read_bytes())
    if recipe.get('schema_version', '2.0') != '2.0' or recipe['package_id'] != package_id:
        raise ValueError('Recipe ID mismatch')
    targets = set()
    with ExitStack() as outer:
        archive = None
        def open_archive():
            spec = recipe['archive']
            stored = inside(root, spec['path'])
            path = Path(archive_path) if archive_path else stored
            if not path.is_file() or path.stat().st_size != spec['bytes'] or sha(path) != spec['sha256']:
                raise ValueError(f'Supply the authorized ZIP with SHA-256 {spec["sha256"]}: {path}')
            return outer.enter_context(zipfile.ZipFile(path))
        if verify_archive:
            archive = open_archive()
        pending = []
        # A failed extraction never replaces verified working inputs.
        tmp = Path(outer.enter_context(tempfile.TemporaryDirectory(dir=None if check else package)))
        for entry in recipe['files']:
            target = inside(package, entry['path'])
            if not target.is_relative_to(package / 'work') or target in targets:
                raise ValueError(f'Invalid or duplicate work file: {target}')
            targets.add(target)
            draft = tmp / str(len(targets))
            if entry['role'] == 'code':
                body = rendered(root, package, entry, destination)
                if target.is_file() and target.read_bytes() == body:
                    continue
                if check:
                    raise ValueError(f'Missing or stale working code: {target}')
                draft.write_bytes(body)
            elif entry['role'] in ('data', 'reference'):
                ready = target.is_file() and target.stat().st_size == entry['bytes'] and sha(target) == entry['sha256']
                if not ready and check:
                    raise ValueError(f'Missing or changed local input: {target}')
                if ready and not verify_archive:
                    continue
                if archive is None:
                    archive = open_archive()
                with ExitStack() as nested:
                    copy_member(nested, archive, entry, draft)
                if ready:
                    draft.unlink()
                    continue
            else:
                raise ValueError('Unknown input role')
            pending.append((draft, target))
        for relative in recipe['empty_directories']:
            folder = inside(package, relative)
            if not folder.is_relative_to(package / 'work'):
                raise ValueError(f'Invalid working directory: {folder}')
            if check and not folder.is_dir():
                raise ValueError(f'Missing working directory: {folder}')
            if not check:
                folder.mkdir(exist_ok=True, parents=True)
        for draft, target in pending:
            target.parent.mkdir(parents=True, exist_ok=True)
            os.replace(draft, target)
    return len(targets)


def materialize(root=ROOT, package_ids=None, *, check=False, archive_path=None, verify_archive=False):
    root = Path(root).resolve()
    ids = package_ids or [f.parent.name for f in sorted((root / 'output/executions/packages').glob('*/local_inputs.json'))]
    if archive_path and len(ids) != 1:
        raise ValueError('--archive requires one package')
    return {pid: prepare(root, pid, check=check, archive_path=archive_path, verify_archive=verify_archive) for pid in ids}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--package-id', action='append')
    ap.add_argument('--archive', type=Path, help='Alternative location for the authorized, exact ZIP.')
    ap.add_argument('--check', action='store_true', help='Verify the current working files without changing them.')
    ap.add_argument('--verify-archive', action='store_true', help='Also verify archive bytes and every selected member.')
    args = ap.parse_args()
    try:
        print(json.dumps(materialize(package_ids=args.package_id, check=args.check, archive_path=args.archive,
                                     verify_archive=args.verify_archive), indent=2))
    except (OSError, ValueError, zipfile.BadZipFile) as error:
        ap.exit(1, str(error) + '\n')


if __name__ == '__main__':
    main()
