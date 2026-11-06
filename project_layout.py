"""Current publications, working runs, and relocation of frozen artifact paths.

Research records retain their original bytes and provenance hashes. This module
resolves their old locations through output/manifest.json rather than rewriting
source records. Without that manifest it supports the original layout, including
small standalone test workspaces.
"""
from __future__ import annotations

import hashlib
import importlib.util
import json
import os
from functools import lru_cache
from pathlib import Path

PROJECT = Path(__file__).resolve().parent
_loaded = {}
_mapped = {}
OLD = {
    'samples': 'output/sample_extractions.jsonl',
    'shortlist': 'output/sample_extractions.filtered.jsonl',
    'models': 'output/model_results.jsonl',
    'model_records': 'output/model_results',
    'model_index': 'output/model_results_index.json',
    'model_queue': 'output/model_results_review_queue.json',
    'model_manifest': 'output/model_results_runs/input_manifest.jsonl',
    'feasibility': 'output/feasibility_checks.jsonl',
    'feasibility_records': 'output/feasibility_checks',
    'feasibility_index': 'output/feasibility_checks.index.json',
    'feasibility_summary': 'output/feasibility_summary',
    'catalog': 'output/feasibility_runs/resources/catalog.json',
    'reproductions': 'reproductions',
    'reproduction_summary': 'output/reproduction_runs',
    'ado': 'output/reproduction_runs/ado',
}


@lru_cache(maxsize=8)
def _manifest(filename, mtime, size):
    return json.loads(Path(filename).read_text())


def manifest(root=None):
    key=os.path.abspath(str(root or PROJECT))
    if key in _loaded:return _loaded[key]
    p = Path(key) / 'output/manifest.json'
    if not p.is_file():
        return {}
    s = p.stat()
    data=_manifest(str(p), s.st_mtime_ns, s.st_size)
    _loaded[key]=data
    _mapped[key]=_compiled(key,str(p),s.st_mtime_ns,s.st_size)
    return data


def active_path(key, root=None):
    root = Path(root or PROJECT)
    return root / manifest(root).get('active', {}).get(key, OLD[key])


def work_root(stage, root=None):
    root = Path(root or PROJECT)
    configured = manifest(root).get('workflows', {}).get(stage)
    return Path(os.path.abspath(root / configured)) if configured else root / ('output/' + stage + '_runs')


@lru_cache(maxsize=8)
def _compiled(root, filename, mtime, size):
    data=_manifest(filename,mtime,size)
    result=[]
    for i,item in enumerate(data.get('relocations', [])):
        source=Path(item['old']);target=Path(item['new'])
        source=Path(os.path.abspath(source if source.is_absolute() else Path(root)/source))
        target=Path(os.path.abspath(target if target.is_absolute() else Path(root)/target))
        result.append((len(source.parts),i,source,target,item.get('prefix',True)))
    return sorted(result,key=lambda x:(x[0],x[1]),reverse=True)


def resolve_path(value, root=None):
    """Map a project-local logical path to its current or archived artifact."""
    root = Path(os.path.abspath(str(root or PROJECT)))
    value = Path(str(value))
    p = Path(os.path.abspath(value if value.is_absolute() else root / value))
    # No external source-data paths are remapped.
    if not manifest(root):return p
    mappings=_mapped[str(root)]
    for _ in range(12):
        match = None
        for _,_,source,target,prefix in mappings:
            if p == source or (prefix and p.is_relative_to(source)):
                match = source,target
                break
        if match is None:
            return p
        source,target = match
        target = target / p.relative_to(source)
        if target == p:
            return p
        p = target
    raise ValueError(f'Relocation cycle or excessive chain: {value}')


def stage_path(stage, name, root=None):
    p = work_root(stage, root) / name
    if p.exists():
        return p
    archived = resolve_path(Path('output') / (stage + '_runs') / name, root)
    return archived if archived.exists() else p


def manages_run(stage, run, root=None):
    """Automatic promotion is restricted to this project's registered runs."""
    root=Path(os.path.abspath(str(root or PROJECT)))
    return bool(manifest(root)) and resolve_path(run,root).resolve().is_relative_to(work_root(stage,root).resolve())


def writable_path(value, root=None):
    root=Path(os.path.abspath(str(root or PROJECT)))
    path=resolve_path(value,root)
    data=manifest(root)
    if data and path.is_relative_to((root/data['archive_root']).resolve()):
        raise ValueError('Archived artifacts are immutable; restore a working copy before editing or executing')
    return path


def path_class(root=None):
    """Path-compatible IO bridge for tools reading immutable legacy records.

    String paths in frozen records are not edited. File-system operations use
    their manifest destinations. This also lets archived skill snapshots be
    replayed without modifying the snapshot source code.
    """
    project = Path(root or PROJECT)

    class ArtifactPath(type(Path())):
        def physical(self):
            return resolve_path(str(self), project)

        def __fspath__(self):
            return str(self.physical())

        def open(self, *args, **kwargs):
            mode=args[0] if args else kwargs.get('mode','r')
            if any(flag in mode for flag in 'wax+'):
                writable_path(str(self),project)
            return self.physical().open(*args, **kwargs)

        def stat(self, *args, **kwargs):
            return self.physical().stat(*args, **kwargs)

        def lstat(self, *args, **kwargs):
            return self.physical().lstat(*args, **kwargs)

        def resolve(self, strict=False):
            return type(self)(str(self.physical().resolve(strict=strict)))

    return ArtifactPath


def relocate_module(module, root=None):
    """Enable legacy-path IO in an imported, hash-verified frozen helper."""
    if hasattr(module, 'Path'):
        module.Path = path_class(root)
    if hasattr(module, '_local_path'):
        module._local_path = lambda locator, project: path_class(project)(str(artifact_path(locator, project)))
    for name in ('results_validator', 'load_module'):
        function=getattr(module,name,None)
        if callable(function) and not getattr(function,'_relocated',False):
            def wrapped(*args, _function=function, **kwargs):
                return relocate_module(_function(*args,**kwargs),root)
            wrapped._relocated=True
            setattr(module,name,wrapped)
    return module


def artifact_path(locator, root=None):
    """Bound evidence to the project and its explicitly registered archive/runs."""
    root=Path(os.path.abspath(str(root or PROJECT)))
    path=resolve_path(locator,root).resolve()
    data=manifest(root)
    allowed=[root]
    if data:
        allowed.append((root/data['archive_root']).resolve())
        allowed.extend((root/p).resolve() for p in data.get('workflows',{}).values())
    if not any(path.is_relative_to(p) for p in allowed):
        raise ValueError('Evidence artifacts must be in the project or its registered archive/work roots')
    return path


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for block in iter(lambda: f.read(4 * 1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def migrated_notebook(original, ado_path):
    result = json.loads(json.dumps(original))
    for cell in result.get('cells', []):
        if cell.get('cell_type') != 'code':
            continue
        source = cell.get('source', [])
        text = ''.join(source) if isinstance(source, list) else source
        text = text.replace('../../../output/reproduction_runs/ado', ado_path)
        cell['source'] = text.splitlines(keepends=True) if isinstance(source, list) else text
    return result


def executed_cell_source(attempt, cell_id, current_code, root=None):
    """Use original executed source only for an exact, recorded path-only move.

    A change to any current notebook byte disables this compatibility proof.
    Runtime signatures still include the unchanged analysis-dataset hashes.
    """
    root = Path(root or PROJECT)
    notebook = Path(str(attempt)) / 'stata.ipynb'
    if not notebook.is_file():
        return current_code
    for proof in manifest(root).get('notebook_relocations', []):
        if resolve_path(notebook,root) != resolve_path(root / proof['current'],root):
            continue
        original = root / proof['original']
        if sha(notebook) != proof['current_sha256'] or sha(original) != proof['original_sha256']:
            return current_code
        old = json.loads(original.read_text())
        current = json.loads(notebook.read_text())
        if migrated_notebook(old, proof['ado_path']) != current:
            raise ValueError('Notebook relocation includes an unapproved change')
        cell = next((c for c in old['cells'] if c.get('id') == cell_id), None)
        if cell is not None:
            text = cell.get('source', [])
            return ''.join(text) if isinstance(text, list) else text
    return current_code


@lru_cache(maxsize=2)
def converter(root=None):
    path = Path(root or PROJECT) / 'skills/extract-accounting-models/scripts/convert_schema.py'
    spec = importlib.util.spec_from_file_location('layout_model_converter', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def legacy_model(record, root=None):
    """A transient adapter for tools comparing the former parameter layout."""
    return converter(str(root or PROJECT)).to_v2(record) if record.get('schema_version') == '3.0' else record


def archive_publication(stage, root=None):
    """Archive a prior publication before a newly accepted stage replaces it."""
    from datetime import datetime, timezone
    import shutil
    root=Path(root or PROJECT)
    current=root/'output'/stage
    backup=work_root({'models':'model_results','feasibility':'feasibility','samples':'samples'}.get(stage,stage),root)/'publications'/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
    if current.exists() and any(current.iterdir()):
        # Historical logical names must keep identifying their frozen bytes.
        # The explicit active path remains the new publication's interface.
        updates={}
        for item in manifest(root).get('relocations',[]):
            logical=Path(item['old']);logical=logical if logical.is_absolute() else root/logical
            resolved=resolve_path(logical,root)
            if resolved.is_relative_to(current) and not logical.is_relative_to(current):
                updates[item['old']]=str(backup/resolved.relative_to(current))
        backup.parent.mkdir(parents=True,exist_ok=True)
        shutil.move(current,backup)
        if updates:refresh_relocations(updates,root)
    current.mkdir(parents=True,exist_ok=True)
    return current,backup


def publish_models(records, index, review_queue, root=None):
    """Publish only schema 3; keep the worker's schema-2 stage in its work root."""
    root=Path(root or PROJECT)
    current,backup=archive_publication('models',root)
    converted=[converter(str(root)).to_v3(r) if r.get('schema_version')=='2.0' else r for r in records]
    per=current/'model_results';per.mkdir()
    for record in converted:
        (per/(record['paper_id']+'.json')).write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n')
    aggregate=current/'model_results.jsonl'
    aggregate.write_text(''.join(json.dumps(r,ensure_ascii=False)+'\n' for r in converted))
    published=dict(index,schema_version='3.0',source_schema_version='2.0',aggregate_sha256=sha(aggregate))
    for entry in published.get('records',[]):
        p=per/(entry['paper_id']+'.json')
        if p.is_file():entry['result_sha256']=sha(p)
    (current/'model_results_index.json').write_text(json.dumps(published,ensure_ascii=False,indent=2)+'\n')
    (current/'model_results_review_queue.json').write_text(json.dumps(review_queue,ensure_ascii=False,indent=2)+'\n')
    # Carry stable paper metadata, not an older result version.
    metadata=backup/'input_manifest.jsonl'
    if metadata.is_file():
        import shutil
        shutil.copy2(metadata,current/metadata.name)
    return current


def publish_feasibility(documents, info, summary, run, root=None):
    """Promote an accepted assessment publication, leaving its run in history."""
    root=Path(root or PROJECT)
    catalog=resolve_path(info['catalog_path'],root).read_bytes()
    current,backup=archive_publication('feasibility',root)
    per=current/'feasibility_checks';per.mkdir()
    individual=[]
    for document in documents:
        p=per/(document['paper_id']+'.json')
        p.write_text(json.dumps(document,ensure_ascii=False,indent=2)+'\n')
        individual.append(dict(paper_id=document['paper_id'],path=os.path.relpath(p,root),sha256=sha(p)))
    aggregate=current/'feasibility_checks.jsonl'
    aggregate.write_text(''.join(json.dumps(d,ensure_ascii=False)+'\n' for d in documents))
    resource=current/'resources/catalog.json';resource.parent.mkdir();resource.write_bytes(catalog)
    index=dict(schema_version='1.0',assessment_schema_version='1.2',papers=len(documents),
               aggregate=dict(path=os.path.relpath(aggregate,root),sha256=sha(aggregate)),
               reviewed_run=dict(directory=str(run),path=str(run/'run.json')),
               individual_files=individual,paper_order=[d['paper_id'] for d in documents],
               input_hashes=info['input_hashes'],summary=summary)
    (current/'feasibility_checks.index.json').write_text(json.dumps(index,ensure_ascii=False,indent=2)+'\n')
    spec=importlib.util.spec_from_file_location('layout_feasibility_summary',root/'scripts/summarize_feasibility.py')
    helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
    helper.summarize(run,current/'summary',active_path('model_manifest',root))
    return current


def refresh_relocations(updates, root=None):
    root = Path(root or PROJECT)
    p = root / 'output/manifest.json'
    data = json.loads(p.read_text())
    by_old = {item['old']: item for item in data['relocations']}
    for old, new in updates.items():
        by_old[str(old)] = {'old': str(old), 'new': str(new), 'prefix': True}
    data['relocations'] = list(by_old.values())
    temp = p.with_suffix('.json.tmp')
    temp.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    temp.replace(p)
    _loaded.pop(os.path.abspath(str(root)),None)
    _mapped.pop(os.path.abspath(str(root)),None)
