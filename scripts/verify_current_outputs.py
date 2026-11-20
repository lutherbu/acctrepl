#!/usr/bin/env python3
"""Verify the public paper results and their links. No statistical programs are launched."""
import argparse
import hashlib
from collections import Counter
from functools import lru_cache
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from scripts import rebuild_indexes as ix
from scripts import update_paper_catalog as catalog
from scripts import publication as pub
from scripts.feasibility_verdict import reviewed_bytes, classify, matches_frozen_input
from project_layout import PATHS


def read(p):
    return json.loads(p.read_bytes())


def verify(project=ROOT, *, with_data=False, catalog_snapshots=()):
    root = Path(project).resolve()
    docs = ix.scan(root)
    counts = Counter()
    @lru_cache(maxsize=8000)
    def digest(p):
        return ix.sha(p)
    def check(p, expected):
        p = ix.plain(root, p)
        if not p.is_file() or digest(p) != expected:
            raise ValueError(f'File differs from its recorded checksum: {p}')
    def check_frozen_input(path, expected):
        path = ix.plain(root, path)
        if not matches_frozen_input(path, expected, root, digest):
            raise ValueError(f'Pinned study input changed: {path}')

    def portable_file(file, pid):
        if file.suffix.lower() in pub.TEXT:
            data = file.read_bytes()
            if data != pub.PublicPaths(pid).data(file.name,data):
                raise ValueError(f'Saved publication contains a filesystem location: {file}')
    def verify_package(folder, pid):
        pub.verify_receipt(folder)
        # Working inputs and operator-installed software are local, generated artifacts.
        pending = [folder]
        while pending:
            for p in pending.pop().iterdir():
                if p.is_symlink():
                    raise ValueError(f'Symlink in published package: {p}')
                if p.is_dir():
                    if p.name not in ('work','data','scratch','.work','sasuser','__pycache__'):
                        pending.append(p)
                else:
                    portable_file(p, pid)
    resource_catalog = PATHS['catalog']
    if catalog_snapshots and not with_data:
        raise ValueError('--catalog-snapshot requires --with-data')
    supplied_hashes = {digest(Path(p)) for p in catalog_snapshots}
    for wf in ix.WORKFLOWS:
        for item in docs.get(f'output/{wf}/index.json', {}).get('records', []):
            f = root / item['path']
            d = read(f)
            parent = f.parent
            counts[wf] += 1
            if ix.WORKFLOWS[wf][0]=='records':
                portable_file(f,item['id'])
            else:
                verify_package(parent.parent if wf=='reproductions' else parent,item['id'])
            if wf in ('feasibility_execution', 'feasibility_reproduction'):
                if 'preclassification_sha256' in d:
                    reviewed_bytes(d)
                elif classify(read(f)) != d:
                    raise ValueError(f'Missing or inconsistent published feasibility verdict: {f}')
            if wf == 'models':
                for key in ('reading','pdf'):
                    source = d['source_inputs'][key]
                    p = pub.inside(root,source['path'])
                    if with_data:
                        check(p, source['sha256'])
            elif wf == 'feasibility_execution':
                check(parent / 'patch_proposal.md', d['patch_proposal']['sha256'])
                review = read(parent / 'review.json')
                check(f, review['assessment_sha256'])
                check(parent / 'patch_proposal.md', review['proposal_sha256'])
            elif wf == 'reproductions':
                if d.get('route') == 'author_deposit':
                    from scripts.deposit_reproduction import verify_publication
                    verify_publication(root, parent, d, with_data=with_data)
                    counts['deposit_reproductions'] += 1
                    for fit in d['fits']:
                        counts['deposit_' + fit['execution_status']] += 1
                    continue
                work = read(parent/'work_item.json')
                for name, expected in work['source_hashes'].items():
                    if name == resource_catalog:
                        if not isinstance(expected, str) or not re.fullmatch(r'[0-9a-f]{64}', expected):
                            raise ValueError(f"Invalid resource catalog checksum for {item['id']}")
                        if with_data and expected not in supplied_hashes:
                            snapshot = pub.inside(root, name)
                            if not snapshot.is_file() or digest(snapshot) != expected:
                                raise ValueError(
                                    f"{item['id']}: --with-data requires the original resource catalog "
                                    f"with SHA-256 {expected}. Supply it at {name} or via --catalog-snapshot."
                                )
                        continue
                    path = pub.inside(root,name)
                    if with_data or not name.startswith('papers/'):
                        check_frozen_input(path,expected)
                for key in ('template_path','skill_path','catalog_path','feasibility_path','ado_path','pdf_path','reading_json'):
                    if key == 'catalog_path' and work.get(key) == resource_catalog:
                        if resource_catalog not in work['source_hashes']:
                            raise ValueError(f"Missing resource catalog checksum for {item['id']}")
                    elif work.get(key):
                        pub.inside(root,work[key])
                for name, expected in d['files'].items():
                    check(pub.inside(parent,name), expected)
                state = read(parent / 'runtime/latest.json')
                if with_data:
                    for name, expected in (state.get('sas') or {}).get('outputs',{}).items():
                        check(pub.inside(parent,name),expected)
                        counts['verified_local_reproduction_files'] += 1
                cells = {c['id']:''.join(c['source']) for c in read(parent/'stata.ipynb')['cells'] if c['cell_type']=='code'}
                samples = read(parent/'submission.json')['samples']
                executed = any(fit['execution_status']=='executed' for fit in d['fits'])
                data_hashes = {s['dta_file']:state['sas']['outputs'][s['dta_file']] for s in samples} if executed else {}
                for fit in d['fits']:
                    counts['reproduction_' + fit['execution_status']] += 1
                    if fit['execution_status'] == 'executed':
                        result = state['cells'][fit['cell_id']]
                        if not result['ok']:
                            raise ValueError(f'Unsuccessful native cell in {f}')
                        code = cells[fit['cell_id']]
                        raw = json.dumps([code,data_hashes],sort_keys=True,ensure_ascii=False).encode()
                        if hashlib.sha256(raw).hexdigest() != result['signature']:
                            proof = state.get('portable_cell_bindings',{}).get(fit['cell_id'],{})
                            if (proof.get('native_signature') != result['signature'] or proof.get('data_sha256') != data_hashes
                                    or proof.get('source_sha256') != hashlib.sha256(code.encode()).hexdigest()):
                                raise ValueError(f'Native source/data binding mismatch in {f}: {fit["cell_id"]}')
                        for ext in ('.csv','.md','.rtf','.tex'):
                            name = fit['table_basename'] + ext
                            check(parent / name, result['outputs'][name])
                            counts['fit_table_checks'] += 1
            elif wf == 'executions':
                recipe = read(parent / 'local_inputs.json')
                review = read(parent / 'review.json')
                check(f,review['report']['sha256'])
                pub.inside(root,recipe['archive']['path'])
                for ref in review['publish_files']:
                    if not ref['path'].startswith('urn:'):
                        check(pub.inside(root,ref['path']),ref['sha256'])
                for entry in recipe['files']:
                    if entry['role'] == 'code':
                        check(pub.inside(parent,entry['template']),entry['template_sha256'])
                    elif with_data:
                        check(pub.inside(parent,entry['path']),entry['sha256'])
            elif wf == 'replications':
                for key, relative in d['inputs'].items():
                    check_frozen_input(pub.inside(root,relative),d['input_hashes'][key])
                for row in d.get('replay_code',[]):
                    check(pub.inside(parent,row['path']),row['sha256'])
                for row in d.get('independent_evidence_review',{}).get('fits',[]):
                    check(pub.inside(root,row['table_path']), row['table_sha256'])
                for row in d.get('completed_tables_before_export_failure',[]):
                    if 'table_path' in row:
                        check(pub.inside(root,row['table_path']),row['table_sha256'])
    rows = catalog.read_jsonl(root / 'docs/papers.jsonl')
    linked, summary = catalog.link_results(rows,catalog.result_inventory(root)[0],root)
    if rows != linked or catalog.serialize_catalog(rows)[1] != (root/'docs/papers.csv').read_bytes():
        raise ValueError('Run scripts/update_paper_catalog.py to repair the paper catalog')
    return dict(counts, catalog_rows=len(rows), catalog_links=sum(summary['result_link_counts'].values()))


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--with-data', action='store_true', help='Also verify the original resource catalog, paper sources and retained datasets against their recorded hashes.')
    ap.add_argument('--catalog-snapshot', type=Path, action='append', default=[], metavar='FILE',
                    help='Historical resource catalog for --with-data. Repeat to supply several snapshots.')
    args = ap.parse_args()
    try:
        print(json.dumps(verify(with_data=args.with_data, catalog_snapshots=args.catalog_snapshot), indent=2))
    except (ValueError,OSError) as error:
        ap.exit(1,str(error)+'\n')
