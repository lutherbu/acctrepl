#!/usr/bin/env python3
"""Build the GitHub Pages file browser inventory from the Git index."""
import argparse
import json
from pathlib import Path
import subprocess

if __package__:
    from .rebuild_indexes import PROJECT, WORKFLOWS
    from .update_paper_catalog import _atomic_write
else:
    from rebuild_indexes import PROJECT, WORKFLOWS
    from update_paper_catalog import _atomic_write


def inventory(root):
    package_dirs = [f'output/{name}/packages/' for name, (subdir, *_) in WORKFLOWS.items()
                    if subdir == 'packages']
    docs = ['README.md', 'LICENSE', 'docs/requirements.txt', 'skills/*/SKILL.md',
            'skills/*/references/*', 'skills/*/scripts/*.py']
    tracked = subprocess.check_output(
        ['git', 'ls-files', '--stage', '-z', '--', *package_dirs, *docs], cwd=root)
    packages, documents = {}, []
    for entry in tracked.decode('utf-8').split('\0'):
        if not entry:
            continue
        metadata, path = entry.split('\t', 1)
        mode, _, stage = metadata.split()
        if mode not in {'100644', '100755'} or stage != '0':
            raise ValueError(f'Expected a regular tracked file without merge conflicts: {path}')
        if not path.startswith('output/'):
            documents.append(path)
            continue
        parts = path.split('/')
        if len(parts) < 5 or parts[-1] == '.gitkeep':
            continue
        package = '/'.join(parts[:4])
        packages.setdefault(package, []).append('/'.join(parts[4:]))
    return {'documents': documents, 'packages': packages}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Report a stale inventory without writing.')
    args = parser.parse_args()
    target = PROJECT / 'site/files.json'
    try:
        result = inventory(PROJECT)
        data = (json.dumps(result, ensure_ascii=False, indent=2) + '\n').encode()
        if args.check:
            if not target.is_file() or target.read_bytes() != data:
                parser.exit(1, 'Site inventory is stale. Run scripts/rebuild_site_inventory.py.\n')
        else:
            _atomic_write(target, data)
    except (OSError, ValueError, subprocess.CalledProcessError) as exc:
        parser.exit(1, f'{exc}\n')
    packages = result['packages']
    print(f'{len(packages)} packages, {sum(map(len, packages.values()))} package files, '
          f'{len(result["documents"])} documentation and reference files.')


if __name__ == '__main__':
    main()
