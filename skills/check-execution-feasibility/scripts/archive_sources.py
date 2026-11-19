"""Bounded, source-only RAR inspection. Never executes an archive member."""
from __future__ import annotations
import hashlib
import json
from pathlib import Path
import resource
import shutil
import stat
import subprocess
import tempfile
import zlib

from packages import CODE, safe, sha

SOURCE_EXTENSIONS=CODE|{'.txt','.md','.tex'}
MAX_MEMBER_BYTES=8*1024*1024
MAX_SOURCE_BYTES=32*1024*1024
MAX_MEMBERS=1000


class StaticArchiveError(ValueError):
    def __init__(self,message,record):
        super().__init__(message);self.record=record


def _run(argv,scratch,limit,timeout=15):
    """Limit native-tool output on disk before reading it into Python memory."""
    def bound():resource.setrlimit(resource.RLIMIT_FSIZE,(limit+1,limit+1))
    record={'argv':list(map(str,argv)),'cwd':str(Path(scratch).resolve()),
            'timeout_seconds':timeout,'output_byte_limit':limit,
            'capture_limit':'Stream hashes/lengths only; no source or stderr body in provenance.'}
    with tempfile.TemporaryFile(dir=scratch) as out,tempfile.TemporaryFile(dir=scratch) as err:
        try:
            child=subprocess.run(argv,cwd=scratch,stdin=subprocess.DEVNULL,stdout=out,stderr=err,
                                 timeout=timeout,preexec_fn=bound,check=False)
            record['return_code']=child.returncode
        except subprocess.TimeoutExpired:
            record.update(return_code=None,timed_out=True)
        lengths=[]
        for label,stream in [('stdout',out),('stderr',err)]:
            length=stream.seek(0,2);lengths.append(length);stream.seek(0)
            h=hashlib.sha256()
            for block in iter(lambda:stream.read(65536),b''):h.update(block)
            record[label+'_bytes']=length;record[label+'_sha256']=h.hexdigest()
        if record.get('timed_out') or max(lengths)>limit or record['return_code']!=0:
            raise StaticArchiveError('Bounded archive tool did not complete successfully',record)
        out.seek(0)
        return out.read(),record


def _members(listing,destination):
    entries=listing.get('lsarContents')
    if not isinstance(entries,list) or len(entries)>MAX_MEMBERS:
        raise ValueError('Archive member-count/listing limit')
    selected=[];seen=set();indexes=set();total=0
    for entry in entries:
        name=entry.get('XADFileName')
        if not isinstance(name,str) or not name or '\0' in name:
            raise ValueError('Invalid archive member name')
        target=safe(destination,name)
        normalized=str(target.relative_to(destination))
        if normalized in seen:raise ValueError('Duplicate archive member path')
        seen.add(normalized)
        if any(entry.get(k) for k in ('XADIsEncrypted','XADIsLink','XADIsSymbolicLink','XADIsHardLink','XADLinkDestination')):
            raise ValueError('Encrypted/link archive member')
        mode=entry.get('XADPosixPermissions',0)
        if isinstance(mode,int) and stat.S_IFMT(mode) not in (0,stat.S_IFREG,stat.S_IFDIR):
            raise ValueError('Special archive member')
        if entry.get('XADIsDirectory'):continue
        if target.suffix.lower() not in SOURCE_EXTENSIONS:continue
        size=entry.get('XADFileSize');index=entry.get('XADIndex')
        if (isinstance(size,bool) or not isinstance(size,int) or not 0<=size<=MAX_MEMBER_BYTES
                or isinstance(index,bool) or not isinstance(index,int) or index<0 or index in indexes):
            raise ValueError('Invalid/oversized source member')
        indexes.add(index);total+=size
        if total>MAX_SOURCE_BYTES:raise ValueError('Archive source-byte limit')
        selected.append((entry,target))
    return selected


def inspect_rar_sources(root):
    """Extract only bounded static source candidates to managed package paths."""
    root=Path(root).resolve()
    archives=[p for p in sorted(root.rglob('*')) if p.suffix.lower()=='.rar']
    report={'method':'lsar_metadata_and_individual_unar_stdout_no_recursion',
            'archives':[],'issues':[],'members':[]}
    for candidate in archives:
        relative=str(candidate.relative_to(root));archive=safe(root,relative)
        entry={'archive':relative,'archive_sha256':sha(archive),'status':'unverified',
               'tool_runs':[],'members':[]}
        report['archives'].append(entry)
        dest=archive.parent/('_rar_static_'+archive.stem)
        try:
            if archive.stat().st_size>64*1024*1024:raise ValueError('RAR input-size limit')
            lsar,unar=shutil.which('lsar'),shutil.which('unar')
            if not lsar or not unar:raise ValueError('Static RAR reader unavailable')
            if dest.exists():raise ValueError('RAR source destination already exists')
            raw,run=_run([lsar,'-j','-nr',str(archive)],root,2*1024*1024)
            entry['tool_runs'].append(run)
            listing=json.loads(raw)
            selected=_members(listing,dest)
            entry['unextracted_non_source_members']=sum(not e.get('XADIsDirectory') for e in listing['lsarContents'])-len(selected)
            if entry['unextracted_non_source_members']:
                report['issues'].append(relative+': non-source members remain unextracted; static source inspection is not full data inspection')
            if not selected:raise ValueError('No bounded source-extension members found')
            for member,target in selected:
                data,run=_run([unar,'-q','-nr','-i','-o','-',str(archive),str(member['XADIndex'])],
                              root,MAX_MEMBER_BYTES)
                entry['tool_runs'].append(run)
                if len(data)!=member['XADFileSize']:raise ValueError('RAR member-size mismatch')
                crc=member.get('XADCRC32',member.get('RAR5CRC32'))
                if crc is not None:
                    expected=crc if isinstance(crc,int) else int(str(crc),16)
                    if zlib.crc32(data)&0xffffffff!=expected:raise ValueError('RAR member-CRC mismatch')
                # safe() is checked again immediately before our own exclusive write.
                target=safe(dest,member['XADFileName']);target.parent.mkdir(parents=True,exist_ok=True)
                with target.open('xb') as stream:stream.write(data)
                info={'archive':relative,'archive_sha256':entry['archive_sha256'],
                      'member':member['XADFileName'],'path':str(target.relative_to(root)),
                      'sha256':sha(target),'bytes':len(data),'crc32':crc,
                      'interpretation':'Static source candidate, not executed; text extension alone does not establish a complete program.'}
                entry['members'].append(info);report['members'].append(info)
            if sha(archive)!=entry['archive_sha256']:raise ValueError('RAR changed during inspection')
            entry['status']='ok'
        except (ValueError,OSError,subprocess.SubprocessError) as exc:
            if isinstance(exc,StaticArchiveError):entry['tool_runs'].append(exc.record)
            entry['error']=type(exc).__name__+': '+str(exc)
            report['issues'].append(relative+': static source extraction incomplete; see frozen archive provenance')
            # Partial outputs stay preserved and explicitly labelled; no source deletion.
            for member in entry['members']:member['partial_archive_inspection']=True
    return report
