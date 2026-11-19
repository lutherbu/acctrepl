#!/usr/bin/env python3
"""Publish one validated paper record or independently accepted package assessment."""
import argparse
import fcntl
import json
import os
from pathlib import Path
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from scripts import publication as pub, rebuild_indexes


def read(path):
    return json.loads(path.read_bytes())


def archive(project, workflow, pid, source):
    digest = pub.sha(source)
    dest = pub.inside(project, f'.local/publications/{workflow}/{pid}/originals/{digest}')
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists() and pub.sha(dest) != digest:
        raise ValueError('Original archive digest mismatch')
    if not dest.exists():
        atomic_write(dest, source.read_bytes())
    return dest


def atomic_write(target, data):
    target.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=target.parent, delete=False) as out:
        tmp = Path(out.name)
        try:
            out.write(data)
            out.flush()
            os.replace(tmp, target)
        finally:
            tmp.unlink(missing_ok=True)


def paper_quotes(before, after, pages):
    if isinstance(before,dict):
        if 'quote' in before and before['quote'] != after['quote']:
            page = before.get('page')
            if page not in pages or ' '.join(before['quote'].split()) not in pages[page]:
                raise ValueError('Changed quotation does not match its cited paper page')
        for key in before:
            if key in after:
                paper_quotes(before[key], after[key], pages)
    if isinstance(before,list):
        for old, new in zip(before, after, strict=True):
            paper_quotes(old, new, pages)


def publish(project, workflow, source, *, item=None, review=None):
    root = Path(project).resolve()
    source = pub.safe_regular(Path(source).absolute())
    raw = read(source)
    pid = raw['package_id' if workflow=='feasibility_execution' else 'paper_id']
    if not rebuild_indexes.ID.fullmatch(pid) or pid in ('.','..'):
        raise ValueError('Invalid publication identity')
    policy = pub.PublicPaths(pid)
    if workflow=='feasibility_execution':
        if not item or not review:
            raise ValueError('Supply the frozen work item and its accepted independent review')
        item, review = (pub.safe_regular(Path(p).absolute()) for p in (item,review))
        note, frozen = read(review), read(item)
        proposal = pub.safe_regular(source.parent/'patch_proposal.md')
        if (note.get('accepted') is not True or frozen['output_header']['package_id'] != pid
                or note['package_id'] != pid or note['work_item_sha256'] != pub.sha(item)
                or note['assessment_sha256'] != pub.sha(source)
                or note['proposal_sha256'] != pub.sha(proposal)
                or raw['patch_proposal']['sha256'] != pub.sha(proposal)):
            raise ValueError('The accepted review does not match this assessment, item and proposal')
        clean = policy.document(raw)
        sources = {row['path']:row for row in frozen['sources']}
        workdir = Path(frozen.get('work_dir',item.parent)).resolve()
        frozen_artifacts = {str(Path(r['path']).resolve()):r['sha256'] for r in frozen.get('artifacts',[])}
        for old,new in zip(raw['evidence'],clean['evidence'],strict=True):
            if old.get('artifact_path'):
                path = (workdir/old['artifact_path']).absolute()
                if not path.resolve().is_relative_to(workdir) and frozen_artifacts.get(str(path.resolve()))!=old['sha256']:
                    raise ValueError('Artifact is outside the accepted assignment')
                if pub.sha(pub.safe_regular(path))!=old['sha256']:
                    raise ValueError('Reviewed evidence artifact checksum mismatch')
                new['artifact_path'] = 'urn:sha256:'+old['sha256']
        proofs = []
        for old,new in zip(raw['evidence'],clean['evidence'],strict=True):
            if old.get('quote') != new.get('quote'):
                proof = (pub.verify_source_quote(old,sources) if old['kind']=='source' else
                         {'id':old['id'],'quote_sha256':pub.byte_hash(old['quote'].encode()),
                          'original_assessment_sha256':pub.sha(source)})
                proof['public_quote_sha256'] = pub.byte_hash(new['quote'].encode())
                proofs.append(proof)
        with pub.staged_package(root,workflow,pid) as package:
            originals = {}
            for name,file in [('assessment.json',source),('patch_proposal.md',proposal),('review.json',review)]:
                originals[name]=pub.sha(archive(root,workflow,pid,file))
            pub.transform_file(proposal,package/'patch_proposal.md',policy)
            clean['patch_proposal']['sha256'] = pub.sha(package/'patch_proposal.md')
            (package/'assessment.json').write_bytes(pub.encode(clean))
            note.update(assessment_sha256=pub.sha(package/'assessment.json'),proposal_sha256=clean['patch_proposal']['sha256'])
            (package/'review.json').write_bytes(pub.encode(policy.document(note)))
            pub.receipt(package,originals,quotes=proofs)
    elif workflow in ('samples','models'):
        target = pub.inside(root,f'output/{workflow}/records/{pid}.json')
        clean = policy.document(raw)
        if clean != raw:
            locator = raw.get('source_inputs',{}).get('reading',{})
            reading = pub.inside(root,locator.get('path') or raw['paper_text_file'])
            if locator.get('sha256') and pub.sha(reading) != locator['sha256']:
                raise ValueError('Paper reading checksum mismatch')
            pages = {p['page']:' '.join(p['text'].split()) for p in read(reading)['pages']}
            paper_quotes(raw,clean,pages)
            if (raw.get('data_section_full_text') != clean.get('data_section_full_text') and
                    ' '.join(raw['data_section_full_text'].split()) not in ' '.join(pages[k] for k in sorted(pages))):
                raise ValueError('Changed data section needs verification against paper text')
        private = archive(root,workflow,pid,source).parent.parent
        with (private/'publish.lock').open('a') as lock:
            fcntl.flock(lock,fcntl.LOCK_EX)
            if target.exists():
                archive(root,workflow,pid,target)
            atomic_write(target, pub.encode(clean) if clean!=raw else source.read_bytes())
            atomic_write(private/'receipt.json',pub.encode({'original_sha256':pub.sha(source),'public_sha256':pub.sha(target)}))
    else:
        raise ValueError('Unknown record workflow')
    rebuild_indexes.rebuild(root)


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('workflow',choices=['samples','models','feasibility_execution'])
    parser.add_argument('source',type=Path)
    parser.add_argument('--item',type=Path)
    parser.add_argument('--review',type=Path)
    args=parser.parse_args()
    try:
        publish(ROOT,args.workflow,args.source,item=args.item,review=args.review)
    except (KeyError,ValueError,OSError) as exc:
        parser.exit(1,str(exc)+'\n')
