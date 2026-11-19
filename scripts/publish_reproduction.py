"""Publish one completed SAS/Stata attempt from its frozen working directory."""
import json
import os
from pathlib import Path
import re

from scripts import publication as pub


def _read(path):
    return json.loads(path.read_bytes())


def _prior_attempt(path, pid):
    p = Path(path)
    if p.parent.name != pid or not re.fullmatch(r'attempt_\d+',p.name):
        raise ValueError('Unexpected historical attempt identity')
    return {'paper_id':pid, 'attempt':int(p.name.split('_')[-1])}


def install(project, attempt):
    root, attempt = Path(project).resolve(), Path(attempt).resolve()
    work = _read(attempt/'work_item.json')
    pid = work['paper_id']
    if attempt.name != f"attempt_{work['attempt']:02d}" or attempt.parent.name != pid:
        raise ValueError('Assigned and published attempt identity differ')
    from scripts.reproduction_runs import tree_hash, digest as signature
    if tree_hash(attempt/'skill_snapshot') != work['skill_sha256']:
        raise ValueError('Frozen skill snapshot changed')
    outcome = _read(attempt/'outcome.json')
    if (outcome['paper_id'],outcome['attempt']) != (pid,work['attempt']):
        raise ValueError('Outcome and work item differ')
    base = Path('output/reproductions/packages')/pid/attempt.name
    destination = root/base
    if attempt == destination:
        raise ValueError('Acceptance requires the frozen working attempt')
    shared = root/'output/reproductions/resources/ado'
    public_dirs = [(root/name,name) for name in ('output','papers','skills','scripts','docs')]
    paths = pub.PublicPaths(pid,[(attempt,base),*public_dirs])
    # Code runs from the attempt. JSON locators are relative to the checkout.
    codepaths = pub.PublicPaths(pid,[(attempt,'.'),(shared,os.path.relpath(shared,destination)),
                                      (root,os.path.relpath(root,destination))])
    with pub.staged_package(root,'reproductions',pid) as package:
        out = package/attempt.name
        out.mkdir()
        original = {}
        def copy(name, expected=None):
            source = pub.safe_regular(pub.inside(attempt,name))
            digest = pub.sha(source)
            if expected and expected != digest:
                raise ValueError(f'Changed native artifact: {name}')
            target = pub.inside(out,name)
            policy = codepaths if source.suffix.lower() in pub.CODE else paths
            if source.suffix == '.ipynb':
                doc = _read(source)
                for cell in doc['cells']:
                    if cell.get('cell_type')=='code':
                        src = cell['source']
                        clean = codepaths.document(src)
                        pub.verify_code(src,clean,name)
                        cell['source'] = clean
                target.parent.mkdir(parents=True,exist_ok=True)
                target.write_bytes(pub.encode(paths.document(doc)) if doc != _read(source) or paths.document(doc)!=doc
                                   else source.read_bytes())
            else:
                pub.transform_file(source,target,policy)
            original[name] = digest
            return target
        files = outcome['files']
        for name,digest in files.items():
            copy(name,digest)
        copy('work_item.json')
        copy('stata.template.ipynb',work['template_sha256'])
        for f in sorted((attempt/'skill_snapshot').rglob('*')):
            if f.is_file() and '__pycache__' not in f.parts:
                copy(f.relative_to(attempt).as_posix())
        item = paths.document(work)
        for key in ('reading_json','pdf_path','feasibility_path','catalog_path','template_path','skill_path','ado_path'):
            if work.get(key):
                absolute = (root/work[key]).resolve()
                absolute = destination/absolute.relative_to(attempt) if absolute.is_relative_to(attempt) else absolute
                item[key] = absolute.relative_to(root).as_posix()
        item['source_hashes'] = {}
        for locator,digest in work['source_hashes'].items():
            source = (root/locator).resolve()
            name = source.relative_to(root).as_posix()
            if name.startswith('.local/'):
                raise ValueError('Publish the frozen paper input under its portable locator first')
            if pub.sha(pub.inside(root,name))!=digest:
                raise ValueError(f'Frozen source changed: {name}')
            item['source_hashes'][name] = digest
        if work.get('predecessor'):
            item['historical_predecessor'] = _prior_attempt(work['predecessor'],pid)
            item['predecessor'] = None
        item['skill_sha256'] = tree_hash(out/'skill_snapshot')
        item['template_sha256'] = pub.sha(out/'stata.template.ipynb')
        (out/'work_item.json').write_bytes(pub.encode(item))
        statefile = attempt/'runtime/latest.json'
        state = _read(statefile) if statefile.is_file() else {'cells':{}}
        submission = _read(attempt/'submission.json')
        for sample in submission['samples']:
            for key in ('sas_file','dta_file'):
                name = sample[key]
                if name in (state.get('sas') or {}).get('outputs',{}):
                    copy(name,state['sas']['outputs'][name])
        for cell in state['cells'].values():
            for name,digest in cell.get('outputs',{}).items():
                copy(name,digest)
        def local_log(stage):
            if not stage or not stage.get('log'):
                return
            log = (root/stage['log']).resolve()
            if log.is_relative_to(attempt):
                name = log.relative_to(attempt).as_posix()
                copy(name)
                for suffix in ('.do','.sas','.lst'):
                    companion = log.with_suffix(suffix)
                    if companion.is_file():
                        copy(companion.relative_to(attempt).as_posix())
            else:
                if not log.is_relative_to(root) or log.suffix!='.log':
                    raise ValueError('Reused log is outside the project')
                name = 'runtime/reused/'+pub.sha(log)[:16]+'-'+log.name
                pub.transform_file(log,out/name,paths)
                original[name] = pub.sha(log)
            stage['log'] = (base/name).as_posix()
        sas = state.get('sas') or {}
        if sas.get('reused_from'):
            sas['historical_predecessor'] = _prior_attempt(sas.pop('reused_from'),pid)
        for step in (sas,sas.get('handoff'),*state['cells'].values()):
            local_log(step)
        if any(c.get('ok') for c in state['cells'].values()):
            def cells(folder):
                return {c['id']:''.join(c['source']) for c in _read(folder/'stata.ipynb')['cells'] if c['cell_type']=='code'}
            native,public = cells(attempt),cells(out)
            hashes = {s['dta_file']:sas['outputs'][s['dta_file']] for s in submission['samples']}
            for cid,cell in state['cells'].items():
                if cell.get('ok') and native[cid]!=public[cid]:
                    if signature([native[cid],hashes])!=cell['signature']:
                        raise ValueError('Executed cell signature changed')
                    state.setdefault('portable_cell_bindings',{})[cid] = {
                        'native_signature':cell['signature'],'data_sha256':hashes,
                        'executed_source_sha256':pub.byte_hash(native[cid].encode()),
                        'source_sha256':pub.byte_hash(public[cid].encode())}
        (out/'runtime').mkdir(exist_ok=True)
        (out/'runtime/latest.json').write_bytes(pub.encode(paths.document(state)))
        if statefile.is_file():
            original['runtime/latest.json'] = pub.sha(statefile)
        result = paths.document(outcome)
        result['files'] = {name:pub.sha(out/name) for name in files}
        result['skill_sha256'] = item['skill_sha256']
        (out/'outcome.json').write_bytes(pub.encode(result))
        original['outcome.json'] = pub.sha(attempt/'outcome.json')
        (package/'accepted.json').write_bytes(pub.encode({'attempt':work['attempt'],'path':base.as_posix(),
                                                           'outcome_sha256':pub.sha(out/'outcome.json')}))
        pub.receipt(package,{attempt.name+'/'+k:v for k,v in original.items()})
    return destination
