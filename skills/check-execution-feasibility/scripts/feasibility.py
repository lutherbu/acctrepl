#!/usr/bin/env python3
"""Prepare evidence and finalize author-package execution-feasibility proposals."""
from __future__ import annotations
import argparse
from datetime import datetime,timezone
import importlib.util
import json
from pathlib import Path
import shutil
import sys
import jsonschema

from packages import CODE,DOC,DATA,sha,save,safe,extract,text,bounded_metadata,stata_software
from archive_sources import inspect_rar_sources
from spss_workbook import read_spwb
ROOT=Path(__file__).resolve().parents[3]
WORKSPACE=ROOT
SKILL=Path(__file__).resolve().parents[1]


def load(path):return json.loads(Path(path).read_text())
def resource_module():
    item_path=SKILL.parent/'work_item.json'
    if item_path.is_file():
        item=load(item_path)
        file=safe(item_path.parent,'frozen_resources/resources.py')
        record=item.get('resource_helper',{})
        if record.get('path')!=str(file) or record.get('sha256')!=sha(file):
            raise ValueError('Frozen resource helper path/hash does not match work item')
        if record not in item.get('frozen_files',[]):
            raise ValueError('Resource helper is not registered as a frozen input')
    else:
        file=ROOT/'skills/check-replication-feasibility/scripts/resources.py'
    spec=importlib.util.spec_from_file_location('execution_resources',file);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m


def prepare(args):
    catalog=Path(args.catalog).resolve()
    if not catalog.is_file():
        raise ValueError(f"Supply an existing --catalog or build your local resource catalog first: {catalog}")
    catalog_sha=sha(catalog)
    classification_source=SKILL.parent/'check-replication-feasibility/references/feasibility_classification.schema.json'
    if not classification_source.is_file() or any(p.is_symlink() for p in (classification_source,*classification_source.parents)):
        raise ValueError('Missing or non-plain shared classification schema')
    classification_sha=sha(classification_source)
    if getattr(args, "archive", None):
        archive = Path(args.archive).resolve()
        if not archive.is_file() or archive.suffix.lower() != ".zip":
            raise ValueError("Supply a plain author ZIP")
        unit = {"package_id":args.package_id,"package_path":archive.name,"directory_path":".","material_files":[],
                "title":getattr(args,"title",None) or args.package_id,"doi":getattr(args,"doi",None),"identity_notes":[]}
        output = Path(args.output).resolve()
        manifest_path = output.parent / (output.name + ".source.json")
        record = {"destination_root":str(archive.parent),"packages":[unit],
                  "files":[{"destination_path":archive.name,"sha256":sha(archive),"bytes":archive.stat().st_size}]}
        if manifest_path.exists() and load(manifest_path) != record:
            raise ValueError("Input inventory already binds another archive")
        save(manifest_path, record)
    else:
        manifest_path=Path(args.manifest).resolve()
    manifest=load(manifest_path)
    unit=next(p for p in manifest['packages'] if p['package_id']==args.package_id)
    package_base=Path(manifest['destination_root'])
    if not package_base.is_absolute():package_base=(ROOT/package_base).resolve()
    original=safe(package_base,unit['package_path']);out=Path(args.output).resolve()
    if out.exists() and any(out.iterdir()):raise ValueError('Preparation output must be new or empty')
    out.mkdir(parents=True,exist_ok=True);root=out/'package';root.mkdir()
    source_files=[]
    for rel in dict.fromkeys(([unit['package_path']] if original.is_file() else [])+unit['material_files']):
        record=next(f for f in manifest['files'] if f['destination_path']==rel)
        file=safe(package_base,rel)
        if sha(file)!=record['sha256']:raise ValueError('Imported file checksum changed: '+rel)
        source_files.append({'path':rel,'sha256':record['sha256']})
    limitations=[]
    if original.is_file():
        state=extract(original,root);save(out/'extraction_provenance.json',state);limitations+=state['issues']
        for rel in unit['material_files']:
            file=safe(package_base,rel)
            if file==original or file.suffix.lower()=='.zip':continue
            dest=root/'_audit_supplements'/file.name;dest.parent.mkdir(exist_ok=True)
            if dest.exists():raise ValueError('Attachment collision')
            shutil.copy2(file,dest)
    else:
        shutil.copytree(original,root,dirs_exist_ok=True,symlinks=True)
    archive_report=inspect_rar_sources(root)
    archive_members={m['path']:m for m in archive_report['members']}
    archive_record=None
    if archive_report['archives']:
        archive_path=out/'static_archive_provenance.json';save(archive_path,archive_report)
        archive_record={'path':str(archive_path),'sha256':sha(archive_path)}
        resolved={'Unsupported nested archive: '+a['archive'] for a in archive_report['archives'] if a['status']=='ok'}
        limitations=[x for x in limitations if x not in resolved]+archive_report['issues']
    snapshot=out/'skill_snapshot'
    shutil.copytree(SKILL,snapshot,ignore=shutil.ignore_patterns('__pycache__','*.pyc'))
    classification_path=out/'check-replication-feasibility/references'/classification_source.name
    classification_path.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(classification_source,classification_path)
    if sha(classification_path)!=classification_sha or sha(classification_source)!=classification_sha:
        raise ValueError('Shared classification schema changed during freezing')
    classification_contract={'path':str(classification_path),'sha256':classification_sha}
    rules_source = classification_source.parents[1] / 'scripts/verdicts.py'
    rules_path = classification_path.parents[1] / 'scripts/verdicts.py'
    rules_hash = sha(rules_source)
    rules_path.parent.mkdir()
    shutil.copy2(rules_source, rules_path)
    if sha(rules_path) != rules_hash:
        raise ValueError('Shared classification helper changed during freezing')
    # Keep the shared probe implementation portable without altering the skill
    # tree hash or importing a mutable sibling skill from a frozen snapshot.
    resource_helper=out/'frozen_resources/resources.py'
    resource_helper.parent.mkdir()
    shutil.copy2(ROOT/'skills/check-replication-feasibility/scripts/resources.py',resource_helper)
    resource_record={'path':str(resource_helper),'sha256':sha(resource_helper)}
    sources=[];inventory=[];probes=[];spwb_inspections=[]
    for file in sorted(root.rglob('*')):
        if file.is_symlink():raise ValueError('Symlink in prepared tree')
        if not file.is_file():continue
        rel=str(file.relative_to(root));ext=file.suffix.lower();entry={'path':rel,'bytes':file.stat().st_size,'kind':'code' if ext in CODE else 'document' if ext in DOC else 'data' if ext in DATA else 'other'}
        if ext in CODE|DOC or ext in {'.xlsx','.spwb'}:
            if ext=='.spwb':
                content,locations,warnings,inspection=read_spwb(file)
                inspection={'file':rel,**inspection}
                spwb_inspections.append(inspection)
                if inspection['nonempty_syntax_paragraphs']:entry['kind']='code'
                entry['program_inspection']={'method':'static_spwb_selective_syntax_tokens',
                    'extracted_program_elements':len(inspection['syntax_paragraphs']),
                    'status':inspection['status'],'limitations':warnings}
            else:
                content,locations,warnings=text(file)
            if ext=='.xlsx':
                program_locations=[loc for loc in locations.values() if loc.get('program_kind') in {'formula','pivot_table'}]
                if program_locations:entry['kind']='code'
                entry['program_inspection']={'method':'static_formula_and_pivot_definitions',
                                             'extracted_program_elements':len(program_locations),
                                             'limitations':warnings}
            cached=out/'reading'/Path(rel+'.txt');cached.parent.mkdir(parents=True,exist_ok=True);cached.write_text(content)
            source={'path':rel,'sha256':sha(file),'original_path':str(file),'content_path':str(cached),'content_sha256':sha(cached),'kind':entry['kind'],'lines':len(content.splitlines()),'locations':locations,'warnings':warnings}
            if rel in archive_members:
                source['archive_member']=archive_members[rel]
                entry['archive_member']=archive_members[rel]
            if ext=='.xlsx':source['content_format']='xlsx_static_program_inspection'
            if ext=='.spwb':
                source['content_format']='spwb_static_syntax_projection'
                source['program_inspection']=entry['program_inspection']
            sources.append(source);entry['sha256']=source['sha256']
            limitations += [rel+': '+w for w in warnings]
        inventory.append(entry)
        if ext in {'.dta','.sas7bdat','.csv','.tsv','.xlsx','.parquet'} and len(probes)<24:
            dest=out/'probes'/('packaged_'+str(len(probes)+1)+'.json')
            bounded_metadata(root,rel,dest);probes.append({'path':str(dest),'sha256':sha(dest),'location':rel})
    report=None; audit_path=Path(args.audit) if getattr(args, 'audit', None) else None
    if audit_path and audit_path.is_file():
        candidate=load(audit_path);expected=candidate.get('collection_provenance',{}).get('archive_sha256')
        # ZIP match binds cached report; loose units match all hashed source files.
        cached_files={f['path']:f for f in candidate.get('architecture_report',{}).get('files',[])}
        matched=(bool(expected) and original.is_file() and sha(original)==expected) or (original.is_dir() and all(cached_files.get(s['path'],{}).get('sha256')==s['sha256'] for s in sources))
        if matched:
            report=out/'static_audit.json';shutil.copy2(audit_path,report)
        else:limitations.append('Existing static audit does not match this package snapshot')
    dependencies=[]
    if report:
        seen=set()
        for edge in load(report)['architecture_report']['dependency_edges']:
            if edge['edge_class'] not in {'read','include'} or edge['status']=='internal':continue
            key=(edge['from'],edge['to'],edge['kind'])
            if key in seen:continue
            seen.add(key);dependencies.append({'id':f'D{len(dependencies)+1:04d}',**edge})
    else:limitations.append('No matching static dependency report; manually derive the dependency closure')
    if args.environment:
        (out/'probes').mkdir(exist_ok=True)
        dst=out/'probes/environment.json';shutil.copy2(args.environment,dst);probes.append({'path':str(dst),'sha256':sha(dst),'location':'environment'})
    provenance={'import_manifest_sha256':sha(manifest_path),'package_files':source_files,'resource_catalog_sha256':catalog_sha,'skill_sha256':sha(snapshot/'SKILL.md')}
    if unit.get('identity_notes'):
        provenance['identity_notes']=unit['identity_notes']
    item={'output_header':{'schema_version':'1.0','package_id':unit['package_id'],'provenance':provenance},'package':unit,'project_root':str(ROOT),'workspace_root':str(WORKSPACE),'package_root':str(root),'work_dir':str(out),'catalog_path':str(catalog),'sources':sources,'inventory':inventory,'dependencies':dependencies,'probe_artifacts':probes,'limitations':limitations,'static_audit_path':str(report) if report else None,'skill_path':str(snapshot/'SKILL.md'),'tool_path':str(Path(__file__).resolve()),'output_dir':str(out/'output'),'allowed_external_checks':'Use current operator authorization for catalog-listed file metadata and bounded PostgreSQL checks.'}
    item['frozen_files']=[{'path':str(manifest_path),'sha256':sha(manifest_path)},{'path':str(catalog),'sha256':catalog_sha}]+[{'path':str(safe(package_base,f['path'])),'sha256':f['sha256']} for f in source_files]+[{'path':str(f),'sha256':sha(f)} for f in sorted(snapshot.rglob('*')) if f.is_file()]
    item['resource_helper']=resource_record
    item['frozen_files'].append(resource_record)
    item['classification_contract']=classification_contract
    item['frozen_files'].append(classification_contract)
    item['frozen_files'].append({'path':str(rules_path),'sha256':rules_hash})
    if archive_record:
        item['static_archive_inspection']=archive_record
        item['frozen_files'].append(archive_record)
        for source in sources:
            if source.get('archive_member'):
                item['frozen_files'] += [{'path':source['original_path'],'sha256':source['sha256']},
                                         {'path':source['content_path'],'sha256':source['content_sha256']}]
    if spwb_inspections:
        inspection_path=out/'static_spwb_provenance.json'
        save(inspection_path,{'method':'static_spwb_selective_syntax_tokens','workbooks':spwb_inspections})
        inspection_record={'path':str(inspection_path),'sha256':sha(inspection_path)}
        item['static_spwb_inspection']=inspection_record
        item['frozen_files'].append(inspection_record)
        for source in sources:
            if source.get('content_format')=='spwb_static_syntax_projection':
                item['frozen_files'] += [{'path':source['original_path'],'sha256':source['sha256']},
                                        {'path':source['content_path'],'sha256':source['content_sha256']}]
    item['output_header'].update({key:unit[key] for key in ('title','doi') if key in unit})
    item['related_packages']=[{**other,'local_path':str(safe(package_base,other['package_path'])),
                              'discovery_only':True}
                             for other in manifest['packages']
                             if unit.get('directory_path') and other.get('directory_path')==unit['directory_path']
                             and other['package_id']!=unit['package_id']]
    save(out/'work_item.json',item)
    save(out/'draft_template.json',{**item['output_header'],'scopes':[{'id':'full_pipeline','description':'Complete author-documented workflow','entry_points':[],'requirement_ids':[],'software_ids':[],'issue_ids':[],'has_code':False,'closure_complete':False,'data_required':False,'evidence_ids':[]}],'requirements':[],'software':[],'issues':[],'evidence':[],'dependency_review':[],'actions':[],'review_notes':[]})
    print(json.dumps({'work_item':str(out/'work_item.json'),'sources':len(sources),'dependencies':len(dependencies),'probes':len(probes),'limitations':len(limitations)}))


def main():
    ap=argparse.ArgumentParser(description=__doc__);sub=ap.add_subparsers(dest='command',required=True)
    p=sub.add_parser('prepare');p.add_argument('--manifest',default=str(ROOT/'papers/packages/_provenance/JAR/import_manifest.json'));p.add_argument('--package-id',required=True);p.add_argument('--archive');p.add_argument('--title');p.add_argument('--doi');p.add_argument('--catalog',default=str(ROOT/'output/feasibility_reproduction/resources/catalog.json'));p.add_argument('--audit',help='Optional matching static-audit JSON');p.add_argument('--environment');p.add_argument('--output',required=True)
    p=sub.add_parser('lookup');p.add_argument('--catalog',required=True);p.add_argument('--query',required=True);p.add_argument('--limit',type=int,default=10)
    p=sub.add_parser('probe');p.add_argument('--catalog',required=True);p.add_argument('--request',required=True);p.add_argument('--output',required=True)
    p=sub.add_parser('metadata');p.add_argument('--item',required=True);p.add_argument('--file',required=True);p.add_argument('--output',required=True)
    p=sub.add_parser('software');p.add_argument('--item',required=True);p.add_argument('--name',required=True);p.add_argument('--output',required=True)
    p=sub.add_parser('finalize');p.add_argument('--item',required=True);p.add_argument('--input',required=True);p.add_argument('--output',required=True)
    p=sub.add_parser('summarize');p.add_argument('--assessments',nargs='+',required=True);p.add_argument('--output',required=True)
    args=ap.parse_args()
    if args.command=='prepare':prepare(args)
    elif args.command=='lookup':print(json.dumps(resource_module().lookup(load(args.catalog),args.query,args.limit),indent=2))
    elif args.command=='probe':save(args.output,resource_module().probe(load(args.catalog),load(args.request)));print(args.output)
    elif args.command=='metadata':
        item=load(args.item);out=Path(args.output).resolve();work=Path(args.item).resolve().parent
        if not out.is_relative_to(work/'probes'):raise ValueError('Probe output must be inside assigned probes directory')
        bounded_metadata(item['package_root'],args.file,out);print(out)
    elif args.command=='software':
        item=load(args.item);out=Path(args.output).resolve();work=Path(args.item).resolve().parent
        if not out.is_relative_to(work/'probes'):raise ValueError('Software probe output must be inside assigned probes directory')
        stata_software(args.name,out);print(out)
    elif args.command=='finalize':
        from assessment import finalize
        result=finalize(args.item,args.input,args.output);print(json.dumps(result.get('summary',{'package_id':result['package_id']}),indent=2))
    else:
        records=[load(p) for p in args.assessments];out=Path(args.output);out.mkdir(parents=True,exist_ok=True)
        (out/'assessments.jsonl').write_text(''.join(json.dumps(r,ensure_ascii=False)+'\n' for r in records))
        counts={}
        for r in records:
            for s in r['scopes']:
                key=s['id']+':'+s['data_status']+':'+s['execution_readiness'];counts[key]=counts.get(key,0)+1
        save(out/'summary.json',{'packages':len(records),'outcomes':counts})


if __name__=='__main__':
    try:main()
    except (ValueError,OSError,KeyError,StopIteration,jsonschema.ValidationError) as exc:
        detail=exc.message+' at '+'.'.join(map(str,exc.absolute_path)) if isinstance(exc,jsonschema.ValidationError) else str(exc)
        print(f'ERROR: {detail}',file=sys.stderr);raise SystemExit(2)
