"""Static archive boundaries, no author-code execution or source-body display."""
from pathlib import Path
import importlib.util
import json
import os
import sys
import zlib

import pytest

SCRIPTS=Path(__file__).resolve().parents[1]/'skills/check-execution-feasibility/scripts'
sys.path.insert(0,str(SCRIPTS))
file=Path(os.environ.get('EXECUTION_ARCHIVE_MODULE',SCRIPTS/'archive_sources.py'))
spec=importlib.util.spec_from_file_location('execution_archive_sources',file)
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)


@pytest.fixture
def archive(tmp_path,monkeypatch):
    p=tmp_path/'Code.rar';p.write_bytes(b'archive fixture')
    source=b'display "static source only"\n'
    listing={'lsarContents':[{'XADFileName':'Code/main.do','XADIndex':0,'XADFileSize':len(source),
                              'RAR5CRC32':zlib.crc32(source)&0xffffffff},
                             {'XADFileName':'Code/observations.csv','XADIndex':1,'XADFileSize':100}]}
    calls=[]
    def run(argv,scratch,limit,timeout=15):
        calls.append(argv)
        return (json.dumps(listing).encode() if '-j' in argv else source),{'argv':argv,'return_code':0}
    monkeypatch.setattr(module.shutil,'which',lambda name:'/usr/bin/'+name)
    monkeypatch.setattr(module,'_run',run)
    return tmp_path,p,source,listing,calls


def test_extracts_only_static_source_with_provenance(archive):
    root,p,source,listing,calls=archive
    result=module.inspect_rar_sources(root)
    assert result['archives'][0]['status']=='ok'
    assert len(result['members'])==1 and len(calls)==2
    member=result['members'][0]
    assert (root/member['path']).read_bytes()==source
    assert member['archive_sha256']==module.sha(p) and member['member']=='Code/main.do'
    assert not list(root.rglob('observations.csv'))
    assert '-nr' in calls[1] and '-i' in calls[1] and calls[1][-1]=='0'


@pytest.mark.parametrize('name',['../escape.do','/escape.do','C:/escape.do','x/../../escape.do'])
def test_rejects_traversal_before_extract(archive,name):
    root,p,source,listing,calls=archive;listing['lsarContents'][0]['XADFileName']=name
    result=module.inspect_rar_sources(root)
    assert result['archives'][0]['status']=='unverified' and not result['members']
    assert len(calls)==1


@pytest.mark.parametrize('flag',['XADIsEncrypted','XADIsLink','XADIsSymbolicLink','XADIsHardLink','XADLinkDestination'])
def test_rejects_protected_or_link_members(archive,flag):
    root,p,source,listing,calls=archive;listing['lsarContents'][0][flag]=True
    result=module.inspect_rar_sources(root)
    assert not result['members'] and len(calls)==1


def test_declared_size_limit_prevents_extract(archive):
    root,p,source,listing,calls=archive;listing['lsarContents'][0]['XADFileSize']=module.MAX_MEMBER_BYTES+1
    result=module.inspect_rar_sources(root)
    assert not result['members'] and len(calls)==1


def test_bad_crc_never_registers_member(archive):
    root,p,source,listing,calls=archive;listing['lsarContents'][0]['RAR5CRC32']=0
    result=module.inspect_rar_sources(root)
    assert not result['members'] and 'CRC' in result['archives'][0]['error']


def test_duplicate_paths_refused(archive):
    root,p,source,listing,calls=archive
    listing['lsarContents'].append(dict(listing['lsarContents'][0]))
    result=module.inspect_rar_sources(root)
    assert not result['members'] and len(calls)==1


def test_bounded_tool_output_is_rejected_before_reading(tmp_path):
    with pytest.raises(module.StaticArchiveError) as caught:
        module._run([sys.executable,'-c','import sys;sys.stdout.buffer.write(b"x"*1000)'],tmp_path,20)
    assert caught.value.record['stdout_bytes']<=21


def test_bounded_tool_deadline(tmp_path):
    with pytest.raises(module.StaticArchiveError) as caught:
        module._run([sys.executable,'-c','import time;time.sleep(2)'],tmp_path,1024,timeout=0.05)
    assert caught.value.record['timed_out'] is True


def test_preparation_registers_member_cache_and_frozen_provenance(tmp_path,monkeypatch):
    spec=importlib.util.spec_from_file_location('execution_package_feasibility',SCRIPTS/'feasibility.py')
    feasibility=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(feasibility)
    from types import SimpleNamespace
    from zipfile import ZipFile
    imports=tmp_path/'imports';imports.mkdir();archive=imports/'source.zip'
    with ZipFile(archive,'w') as zipped:zipped.writestr('Code.rar',b'RAR fixture')
    manifest=tmp_path/'manifest.json';manifest.write_text(json.dumps({
        'destination_root':str(imports),
        'files':[{'destination_path':'source.zip','sha256':module.sha(archive)}],
        'packages':[{'package_id':'static-source-fixture','package_path':'source.zip','material_files':[]}]}))
    catalog=tmp_path/'catalog.json';catalog.write_text('{}')
    def inspected(root):
        member=root/'_rar_static_Code/main.do';member.parent.mkdir();member.write_bytes(b'version 18\n')
        info={'archive':'Code.rar','archive_sha256':module.sha(root/'Code.rar'),
              'member':'main.do','path':'_rar_static_Code/main.do','sha256':module.sha(member),'bytes':11}
        return {'archives':[{'archive':'Code.rar','status':'ok','members':[info]}],'members':[info],'issues':[]}
    monkeypatch.setattr(feasibility,'inspect_rar_sources',inspected)
    work=tmp_path/'work'
    feasibility.prepare(SimpleNamespace(manifest=str(manifest),package_id='static-source-fixture',
                                        output=str(work),catalog=str(catalog),environment=None))
    item=json.loads((work/'work_item.json').read_text())
    source=next(s for s in item['sources'] if s['path']=='_rar_static_Code/main.do')
    assert source['kind']=='code' and source['archive_member']['member']=='main.do'
    assert Path(source['content_path']).read_bytes()==b'version 18\n'
    for pathkey,hashkey in [('original_path','sha256'),('content_path','content_sha256')]:
        assert {'path':source[pathkey],'sha256':source[hashkey]} in item['frozen_files']
    assert item['static_archive_inspection'] in item['frozen_files']
    assert not any('Unsupported nested archive' in x for x in item['limitations'])
