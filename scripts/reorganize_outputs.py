#!/usr/bin/env python3
"""Inventory, archive, and relocate current publications without re-estimation.

Use `plan`, inspect the resulting inventory, then `apply --archive PATH`.
The journal and idempotent moves support recovery after interruption. Large
datasets are renamed on the same filesystem, never copied or reconstructed.
"""
import argparse
import csv
import hashlib
import json
import os
import shutil
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from project_layout import migrated_notebook, sha

ACTIVE = {
    'samples':'output/samples/sample_extractions.jsonl',
    'shortlist':'output/samples/sample_extractions.filtered.jsonl',
    'models':'output/models/model_results.jsonl',
    'model_records':'output/models/model_results',
    'model_index':'output/models/model_results_index.json',
    'model_queue':'output/models/model_results_review_queue.json',
    'model_manifest':'output/models/input_manifest.jsonl',
    'feasibility':'output/feasibility/feasibility_checks.jsonl',
    'feasibility_records':'output/feasibility/feasibility_checks',
    'feasibility_index':'output/feasibility/feasibility_checks.index.json',
    'feasibility_summary':'output/feasibility/summary',
    'catalog':'output/feasibility/resources/catalog.json',
    'reproductions':'output/reproductions',
    'reproduction_summary':'output/reproductions',
    'ado':'output/reproductions/ado',
}
CURRENT = {
    'sample_extractions.jsonl':ACTIVE['samples'],
    'sample_extractions.filtered.jsonl':ACTIVE['shortlist'],
    'model_results.jsonl':ACTIVE['models'],
    'model_results':ACTIVE['model_records'],
    'model_results_index.json':ACTIVE['model_index'],
    'model_results_review_queue.json':ACTIVE['model_queue'],
    'model_results_runs/input_manifest.jsonl':ACTIVE['model_manifest'],
    'feasibility_checks.jsonl':ACTIVE['feasibility'],
    'feasibility_checks':ACTIVE['feasibility_records'],
    'feasibility_checks.index.json':ACTIVE['feasibility_index'],
    'feasibility_summary':ACTIVE['feasibility_summary'],
    'feasibility_runs/resources/catalog.json':ACTIVE['catalog'],
    'feasibility_runs/resources/final_validation.json':'output/feasibility/validation.json',
    'reproduction_runs/ado':ACTIVE['ado'],
    'reproduction_runs/comparison':'output/reproductions/comparison',
    **{'reproduction_runs/'+name:'output/reproductions/'+name for name in
       ['summary.json','summary.csv','summary.md','currency_audit.json','follow_up_issues.json','resource_documentation.json']},
}


def now():
    return datetime.now(timezone.utc).isoformat()


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    temp=path.with_name(path.name+'.tmp')
    temp.write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n')
    temp.replace(path)


def records(path):
    with path.open() as stream:
        return [json.loads(l) for l in stream if l.strip()]


def inventory(root):
    entries=[]
    for name in ['output','reproductions']:
        for rt,ds,fs in os.walk(root/name,followlinks=False):
            for fn in sorted(fs):
                p=Path(rt)/fn;s=p.lstat()
                raw=(p.suffix.lower() in {'.dta','.sas7bdat','.sas7bndx','.sas7bvew','.xpt'} or
                     any(x in p.relative_to(root).parts for x in ['data','.work','saswork','sasuser','scratch']))
                entry=dict(path=str(p.relative_to(root)),size=s.st_size,mtime_ns=s.st_mtime_ns,
                           device=s.st_dev,inode=s.st_ino,raw_data=raw)
                if p.is_symlink():
                    raise ValueError('Inventory requires explicit handling of symlink: '+str(p))
                if not raw:
                    entry['sha256']=sha(p)
                entries.append(entry)
    return entries


def plan(root, archive):
    if (root/'output/manifest.json').exists():
        raise ValueError('Current layout already installed; use verify, not a new migration')
    if archive.exists():
        raise FileExistsError('Archive destination already exists: '+str(archive))
    if not archive.is_relative_to(root.parent/'candidate_search'):
        raise ValueError('Archive must be under this workspace candidate_search')
    if root.stat().st_dev != archive.parent.stat().st_dev:
        raise ValueError('Use a destination on the same filesystem for atomic dataset moves')
    summary=json.loads((root/'output/reproduction_runs/summary.json').read_text())
    accepted=[]
    for p in sorted((root/'reproductions').iterdir()):
        if not p.is_dir():continue
        a=json.loads((p/'accepted.json').read_text())
        source=Path(a['path'])
        if not source.is_relative_to(p) or not source.is_dir():
            raise ValueError('Invalid accepted attempt: '+str(source))
        if sha(source/'outcome.json') != a['outcome_sha256']:
            raise ValueError('Accepted outcome changed: '+p.name)
        accepted.append(dict(paper_id=p.name,attempt=a['attempt'],source=str(source.relative_to(root)),
                             target=f'output/reproductions/{p.name}/{source.name}',accepted=a))
    for old,new in CURRENT.items():
        if not (root/'output'/old).exists():raise FileNotFoundError(old)
        if (root/new).exists():raise FileExistsError(new)
    publications={name:dict(records=len(records(root/'output'/name)),sha256=sha(root/'output'/name))
                  for name in ['sample_extractions.jsonl','sample_extractions.filtered.jsonl','model_results.jsonl','feasibility_checks.jsonl']}
    readings=sorted({d['paper_text_file'] for d in records(root/'output/model_results.jsonl')
                     if d['paper_text_file'].startswith('output/')})
    for old in readings:
        dest=root/'papers/parsed/verified'/Path(old).name
        if not (root/old).is_file():raise FileNotFoundError(old)
        if dest.exists() and sha(dest)!=sha(root/old):raise FileExistsError(dest)
    data=dict(schema_version=1,created_at=now(),project=str(root),archive=str(archive),
              selected=accepted,current=CURRENT,readings=readings,publications=publications,
              expected={k:summary[k] for k in ['papers','accepted_papers','assignments','expected_scopes','executed_scopes']},
              consistency=json.loads((root/'output/reproduction_runs/comparison/model_consistency_summary.json').read_text())['counts'],
              inventory=inventory(root))
    archive.mkdir(parents=True)
    write(archive/'plan.json',data)
    print(json.dumps(dict(archive=str(archive),papers=len(accepted),files=len(data['inventory']),
                          bytes=sum(x['size'] for x in data['inventory']),readings=len(readings)),indent=2))
    return data


def apply(archive):
    data=json.loads((archive/'plan.json').read_text());root=Path(data['project'])
    if (archive/'applied.json').exists():
        return verify(root,archive)
    for name in ['output','reproductions']:
        src=root/name;dst=archive/name
        if not dst.exists():
            if not src.exists():raise FileNotFoundError(src)
            src.rename(dst)
    for name in ['samples','models','feasibility','reproductions']:
        (root/'output'/name).mkdir(parents=True,exist_ok=True)
    # Map the old children, not the whole output root: the latter would also
    # redirect the new stage folders back into the archive.
    relocations=[dict(old='output/'+name,new=os.path.relpath(archive/'output'/name,root),prefix=True)
                 for name in sorted({Path(e['path']).parts[1] for e in data['inventory'] if e['path'].startswith('output/')})]
    relocations.append(dict(old='reproductions',new=os.path.relpath(archive/'reproductions',root),prefix=True))
    operations=[]

    def alias(old,new,prefix=True):
        relocations.append(dict(old=str(old),new=str(new),prefix=prefix))

    def move(src,dst,old):
        dst.parent.mkdir(parents=True,exist_ok=True)
        if src.exists():
            if dst.exists():raise FileExistsError('Refusing overwrite: '+str(dst))
            src.rename(dst)
        elif not dst.exists():raise FileNotFoundError(src)
        alias(old,os.path.relpath(dst,root))
        alias(os.path.relpath(src,root),os.path.relpath(dst,root))
        operations.append(dict(old=str(old),new=os.path.relpath(dst,root)))
        with (archive/'moves.jsonl').open('a') as f:f.write(json.dumps(operations[-1])+'\n')

    for old,new in data['current'].items():
        if old=='reproduction_runs/comparison' or old in {'reproduction_runs/summary.json','reproduction_runs/summary.csv','reproduction_runs/summary.md'}:
            original=archive/'output'/old
            backup=archive/'original_publications'/'output'/old
            if original.exists() and not backup.exists():
                backup.parent.mkdir(parents=True,exist_ok=True)
                if original.is_dir():shutil.copytree(original,backup)
                else:shutil.copy2(original,backup)
        move(archive/'output'/old,root/new,'output/'+old)
    for old in data['readings']:
        dest=root/'papers/parsed/verified'/Path(old).name
        source=archive/old
        if source.exists() and dest.exists() and sha(source)==sha(dest):
            alias(old,str(dest.relative_to(root)));alias(os.path.relpath(source,root),str(dest.relative_to(root)))
        else:move(source,dest,old)
    proofs=[]
    for item in data['selected']:
        original=archive/item['source'];target=root/item['target']
        move(original,target,item['source'])
        old_pointer=archive/'reproductions'/item['paper_id']/'accepted.json'
        new_pointer=root/'output/reproductions'/item['paper_id']/'accepted.json'
        accepted=item['accepted']|{'path':str(target)}
        write(new_pointer,accepted)
        alias('reproductions/'+item['paper_id']+'/accepted.json',str(new_pointer.relative_to(root)),False)
        backup=archive/'original_current'/item['paper_id']/target.name/'stata.ipynb'
        notebook=target/'stata.ipynb'
        if not backup.exists():
            backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(notebook,backup)
        old=json.loads(backup.read_text());updated=migrated_notebook(old,'../../ado')
        if old!=updated:
            notebook.write_text(json.dumps(updated,ensure_ascii=False,indent=2)+'\n')
            proofs.append(dict(current=str(notebook.relative_to(root)),original=os.path.relpath(backup,root),
                               original_sha256=sha(backup),current_sha256=sha(notebook),ado_path='../../ado',
                               scope='Code-cell ado path only; all outputs and other notebook fields preserved'))
        # Keep only runtime directories used by the latest state. Earlier logs
        # remain accessible through exact relocation entries in the archive.
        latest=json.loads((target/'runtime/latest.json').read_text())
        keep={'latest.json'}
        def referenced(value):
            if isinstance(value,dict):
                for x in value.values():referenced(x)
            elif isinstance(value,list):
                for x in value:referenced(x)
            elif isinstance(value,str):
                prefix=str(root/item['source'])+'/runtime/'
                if value.startswith(prefix):keep.add(value[len(prefix):].split('/')[0])
        referenced(latest)
        for f in list((target/'runtime').iterdir()):
            if f.name in keep:continue
            retired=archive/'retired_runtime'/item['paper_id']/target.name/f.name
            retired.parent.mkdir(parents=True,exist_ok=True)
            if retired.exists():raise FileExistsError(retired)
            f.rename(retired)
            rel='runtime/'+f.name
            alias(item['source']+'/'+rel,os.path.relpath(retired,root))
            alias(item['target']+'/'+rel,os.path.relpath(retired,root))
    workflows={}
    for stage in ['model_extraction','model_results','feasibility','reproduction']:
        working=root.parent/'candidate_search/runs'/stage
        working.mkdir(parents=True,exist_ok=True)
        workflows[stage]=os.path.relpath(working,root)
        original=archive/'output'/(stage+'_runs')
        for f in original.iterdir():
            if f.is_file() and f.suffix in {'.json','.jsonl'}:
                dest=working/f.name
                if not dest.exists():shutil.copy2(f,dest)
            elif f.is_dir():
                # Read-only access to already completed stages; new stages
                # have no such mapping and are created in the working root.
                alias(os.path.relpath(working/f.name,root),os.path.relpath(f,root))
        for f in ['workflow.json','campaign.json','WORK_STATE.json']:
            if (working/f).exists():alias('output/'+stage+'_runs/'+f,os.path.relpath(working/f,root),False)
    # Current campaign paths are administrative locations, not frozen inputs.
    campaign_path=root/workflows['reproduction']/'campaign.json'
    campaign=json.loads((archive/'output/reproduction_runs/campaign.json').read_text())
    by_source={str(root/x['source']):str(root/x['target']) for x in data['selected']}
    for paper in campaign['papers']:
        for assignment in paper['assignments']:
            assignment['path']=by_source.get(assignment['path'],str(archive/Path(assignment['path']).relative_to(root)))
    write(campaign_path,campaign)
    current=dict(layout_version=1,created_at=now(),status='relocated',archive_root=os.path.relpath(archive,root),
                 active=ACTIVE,workflows=workflows,relocations=relocations,notebook_relocations=proofs,
                 publications=data['publications'],expected=data['expected'],consistency=data['consistency'],
                 provenance='Published research records and native logs remain byte-preserved. Notebook changes are exclusively recorded ado-path relocations; no estimation was rerun.')
    write(root/'output/manifest.json',current)
    write(archive/'applied.json',dict(applied_at=now(),manifest=str(root/'output/manifest.json')))
    print(json.dumps(dict(archive=str(archive),moved=len(operations),notebook_path_changes=len(proofs)),indent=2))


def verify(root,archive):
    sys.path.insert(0,str(root));from project_layout import resolve_path,executed_cell_source
    data=json.loads((archive/'plan.json').read_text())
    counts={}
    for old,expected in data['publications'].items():
        target=resolve_path('output/'+old,root)
        if sha(target)!=expected['sha256']:raise ValueError('Publication changed: '+old)
        counts[old]=len(records(target))
    missing=[];changed=[];moved=0
    layout=json.loads((root/'output/manifest.json').read_text())
    for entry in data['inventory']:
        old=entry['path'];target=resolve_path(old,root)
        original_publication=archive/'original_publications'/old
        if original_publication.is_file():target=original_publication
        if old=='output/reproduction_runs/campaign.json':target=archive/old
        # Two explicitly edited administrative/code artifacts have originals.
        if old.endswith('/accepted.json') and old.startswith('reproductions/'):
            target=archive/old
        proof=next((p for p in layout['notebook_relocations']
                    if resolve_path(old,root)==root/p['current']),None) if old.endswith('/stata.ipynb') else None
        if proof:target=root/proof['original']
        if not target.is_file():missing.append(old);continue
        st=target.stat()
        if st.st_size!=entry['size'] or ('sha256' in entry and sha(target)!=entry['sha256']):changed.append(old)
        if entry['raw_data'] and (st.st_ino!=entry['inode'] or st.st_dev!=entry['device']):
            changed.append(old+' (dataset inode changed)')
        moved+=1
        if moved % 2000 == 0:
            print(json.dumps({'verified_files':moved,'total':len(data['inventory'])}),flush=True)
    if missing or changed:raise ValueError(json.dumps(dict(missing=missing,changed=changed),indent=2))
    report=dict(valid=True,verified_at=now(),files=moved,publication_counts=counts,
                expected=data['expected'],consistency=data['consistency'],
                note='Every inventoried file accounted for; publications and non-data bytes verified; datasets retain original inode/device/size after same-filesystem rename.')
    write(archive/'integrity.json',report)
    print(json.dumps(report,indent=2))
    return report


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('command',choices=['plan','apply','verify'])
    p.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[1])
    p.add_argument('--archive',type=Path)
    a=p.parse_args();root=a.project.absolute()
    archive=a.archive.absolute() if a.archive else root.parent/'candidate_search/archive'/('git-output-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'))
    if a.command=='plan':
        archive.parent.mkdir(parents=True,exist_ok=True);plan(root,archive)
    elif a.command=='apply':apply(archive)
    else:verify(root,archive)


if __name__=='__main__':main()
