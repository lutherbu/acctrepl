"""SPWB syntax/output separation, boundaries and native-source registration."""
from pathlib import Path
import importlib.util
import json
import stat
import sys
from types import SimpleNamespace
import warnings
import zipfile

import pytest

SCRIPTS=Path(__file__).resolve().parents[1]/'skills/check-execution-feasibility/scripts'
sys.path.insert(0,str(SCRIPTS))
spec=importlib.util.spec_from_file_location('execution_spwb',SCRIPTS/'spss_workbook.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)


def paragraph(code, output='RESULT_VALUE_SENTINEL'):
    return {'paragraph':{'syntax':{'content':code,'description':'IGNORED_DESCRIPTION','visible':True},
                         'output':[{'items':[{'table':{'content':output}}]}],
                         'summary':{'text':'IGNORED_SUMMARY'}}}


def make_workbook(tmp_path, document=None, raw=None, extras=None, name='Code.spwb'):
    path=tmp_path/name
    if raw is None:raw=json.dumps({'summary':{'doc_type':'workbook'},'document':document or []}).encode()
    with zipfile.ZipFile(path,'w',compression=zipfile.ZIP_STORED) as z:
        z.writestr('workbookViewer.json',raw)
        z.writestr('META-INF/MANIFEST.MF',b'fixture metadata')
        z.writestr('lightTableData.bin',b'PRIVATE_BINARY_ROWS_SENTINEL')
        for key,value in (extras or {}).items():z.writestr(key,value)
    return path


def test_reads_only_exact_syntax_path_and_preserves_native_locations(tmp_path,monkeypatch):
    output={'syntax':{'content':'NESTED_OUTPUT_SYNTAX_SENTINEL'},'value':'TABLE_SENTINEL'}
    source=make_workbook(tmp_path,[paragraph('GET FILE="input.sav".\nREGRESSION /DEPENDENT y /METHOD=ENTER x.',output)])
    seen=[];original=m._syntax_bytes
    def checked(data,node):
        token=data[node.start:node.end]
        assert b'TABLE_SENTINEL' not in token and b'NESTED_OUTPUT_SYNTAX_SENTINEL' not in token
        seen.append(token);return original(data,node)
    monkeypatch.setattr(m,'_syntax_bytes',checked)
    content,locations,warnings,meta=m.read_spwb(source)
    assert meta['status']=='ok' and len(seen)==1
    assert 'GET FILE="input.sav".' in content and '/DEPENDENT y' in content
    for marker in ['TABLE_SENTINEL','NESTED_OUTPUT_SYNTAX_SENTINEL','IGNORED_DESCRIPTION','IGNORED_SUMMARY','PRIVATE_BINARY_ROWS_SENTINEL']:
        assert marker not in content and marker not in json.dumps(meta)
    assert locations['2']=={'program_kind':'spss_syntax','member':'workbookViewer.json',
        'paragraph_index':0,'json_pointer':'/document/0/paragraph/syntax/content','syntax_line':1,'withheld':False}
    assert meta['excluded_output_groups']==1 and meta['output_strings_decoded'] is False
    assert len(list(tmp_path.iterdir()))==1


def test_crlf_blank_lines_paragraph_order_and_unicode(tmp_path):
    source=make_workbook(tmp_path,[paragraph('A.\r\n\r\nB.\r\n'),paragraph('COMMENT "café 😀".')])
    content,locations,_,meta=m.read_spwb(source)
    assert meta['status']=='ok' and 'café 😀' in content
    assert [meta['syntax_paragraphs'][i]['paragraph_index'] for i in range(2)]==[0,1]
    assert [locations[str(i)]['syntax_line'] for i in range(2,6)]==[1,2,3,4]
    assert content.splitlines()[2]=='' and len(locations)==len(content.splitlines())


@pytest.mark.parametrize('code',[
    'CONNECT\n /USER="fictional"\n /PASSWORD="SECRET_SENTINEL".\nAFTER.',
    '/* outer /* inner */\n api_key = "SECRET_SENTINEL"\n */\nREGRESSION.',
    'BEGIN PROGRAM Python.\naccess_token: "SECRET_SENTINEL"\nEND PROGRAM.',
    'GET DATA /URL="https://fictional:SECRET_SENTINEL@example.invalid/file".',
])
def test_whole_auth_candidate_paragraph_withheld_before_text_decode(tmp_path,code):
    source=make_workbook(tmp_path,[paragraph(code),paragraph('SAFE_SYNTAX_SENTINEL.')])
    content,locations,warnings,meta=m.read_spwb(source)
    assert meta['status']=='ok' and meta['syntax_paragraphs'][0]['withheld'] is True
    assert 'SECRET_SENTINEL' not in content and 'REGRESSION.' not in content
    assert 'SAFE_SYNTAX_SENTINEL.' in content
    assert sum(loc.get('withheld',False) for loc in locations.values())==len(code.split('\n'))
    assert any('coverage is incomplete' in w for w in warnings)


def test_escaped_auth_keyword_screened_before_utf8_decode(tmp_path):
    raw=b'{"document":[{"paragraph":{"syntax":{"content":"api\\u005fkey=\\\"SECRET_SENTINEL\\\".\\nNEXT."}}}]}'
    source=make_workbook(tmp_path,raw=raw)
    content,_,_,meta=m.read_spwb(source)
    assert meta['status']=='ok' and meta['syntax_paragraphs'][0]['withheld']
    assert 'SECRET_SENTINEL' not in content and 'NEXT.' not in content


def test_unpaired_output_unicode_never_decoded_as_syntax(tmp_path):
    raw=b'{"document":[{"paragraph":{"syntax":{"content":"REGRESSION."},"output":[{"content":"\\ud800"}]}}]}'
    source=make_workbook(tmp_path,raw=raw)
    content,_,_,meta=m.read_spwb(source)
    assert meta['status']=='ok' and 'REGRESSION.' in content


@pytest.mark.parametrize('raw',[
    b'{"document":{}}',
    b'{"document":[{"paragraph":{"syntax":{"content":123}}}]}',
    b'{"document":[{"paragraph":{"syntax":{"content":"A.","unknown_program":"B."}}}]}',
    b'{"document":[{"paragraph":{"syntax":{"content":"A."},"syntax":{"content":"B."}}}]}',
    b'{"document":[{"paragraph":{"s\\u0079ntax":{"content":"A."}}}]}',
    b'{"document":[{"paragraph":{"syntax":{"content":"\\ud800"}}}]}',
    b'{"document":[{"paragraph":{"syntax":{"content":"bad\\u0000code"}}}]}',
    b'{"document":[{"paragraph":{"syntax":{"content":"<p>HTML_CODE_SENTINEL</p>"}}}]}',
    b'{"document":[]} trailing',
])
def test_unknown_ambiguous_or_damaged_format_is_not_absent_code(tmp_path,raw):
    source=make_workbook(tmp_path,raw=raw)
    content,locations,warnings,meta=m.read_spwb(source)
    assert meta['status']=='unverified' and content=='' and locations=={}
    assert 'not proved to lack code' in warnings[0]
    assert 'HTML_CODE_SENTINEL' not in json.dumps(meta)


def test_output_only_workbook_has_no_invented_program(tmp_path):
    source=make_workbook(tmp_path,[{'paragraph':{'output':[{'text':{'content':'NOT_CODE_SENTINEL'}}]}}])
    content,_,warnings,meta=m.read_spwb(source)
    assert meta['status']=='ok' and meta['nonempty_syntax_paragraphs']==0
    assert content=='' and not meta['syntax_paragraphs']
    assert any('No syntax nodes' in w for w in warnings)


@pytest.mark.parametrize('member',['../outside','/absolute','C:/outside','x/../../outside'])
def test_unsafe_zip_paths_rejected_without_extraction(tmp_path,member):
    source=make_workbook(tmp_path,[paragraph('A.')],extras={member:b'PRIVATE_VALUE'})
    content,_,_,meta=m.read_spwb(source)
    assert meta['status']=='unverified' and content==''
    assert len(list(tmp_path.iterdir()))==1


def test_duplicate_viewer_rejected(tmp_path):
    source=make_workbook(tmp_path,[paragraph('A.')])
    with warnings.catch_warnings():
        warnings.simplefilter('ignore',UserWarning)
        with zipfile.ZipFile(source,'a') as z:z.writestr('workbookViewer.json',b'{}')
    assert m.read_spwb(source)[3]['status']=='unverified'


def test_symlink_and_special_zip_member_rejected(tmp_path):
    source=make_workbook(tmp_path,[paragraph('A.')])
    link=tmp_path/'link.spwb';link.symlink_to(source)
    assert m.read_spwb(link)[3]['status']=='unverified'
    with zipfile.ZipFile(source,'a') as z:
        info=zipfile.ZipInfo('link');info.create_system=3;info.external_attr=(stat.S_IFLNK|0o777)<<16
        z.writestr(info,b'other')
    assert m.read_spwb(source)[3]['status']=='unverified'


def test_crc_damage_is_not_registered(tmp_path):
    source=make_workbook(tmp_path,[paragraph('UNIQUE_SYNTAX_MARKER.')])
    raw=source.read_bytes();assert raw.count(b'UNIQUE_SYNTAX_MARKER')==1
    source.write_bytes(raw.replace(b'UNIQUE_SYNTAX_MARKER',b'CHANGED_SYNTAX_VALUE'))
    assert m.read_spwb(source)[3]['status']=='unverified'


def test_original_hash_mismatch_prevents_viewer_read(tmp_path,monkeypatch):
    source=make_workbook(tmp_path,[paragraph('A.')])
    monkeypatch.setattr(m,'_viewer_member',lambda p:pytest.fail('wrong original must not be parsed'))
    assert m.read_spwb(source,'0'*64)[3]['status']=='unverified'


def test_member_is_bound_to_original_snapshot_even_if_path_changes(tmp_path,monkeypatch):
    source=make_workbook(tmp_path,[paragraph('ORIGINAL_SOURCE.')])
    other=make_workbook(tmp_path,[paragraph('CHANGED_SOURCE.')],name='other.spwb')
    with zipfile.ZipFile(source) as z:expected_member=m._sha(z.read('workbookViewer.json'))
    original=m._viewer_member
    def change_path_after_snapshot(data):
        assert isinstance(data,bytes)
        source.write_bytes(other.read_bytes())
        return original(data)
    monkeypatch.setattr(m,'_viewer_member',change_path_after_snapshot)
    content,_,_,meta=m.read_spwb(source)
    assert content=='' and meta['status']=='unverified'
    assert meta['viewer_member']['sha256']==expected_member


@pytest.mark.parametrize('limit',['MAX_ARCHIVE_BYTES','MAX_JSON_BYTES','MAX_SYNTAX_BYTES','MAX_NODES','MAX_MEMBERS','MAX_DEPTH'])
def test_bounded_resource_limits(tmp_path,monkeypatch,limit):
    source=make_workbook(tmp_path,[paragraph('REGRESSION /DEPENDENT y /METHOD=ENTER x.')])
    monkeypatch.setattr(m,limit,1)
    assert m.read_spwb(source)[3]['status']=='unverified'


def test_prepare_registers_original_native_source_and_pins_only_syntax_cache(tmp_path):
    spec=importlib.util.spec_from_file_location('execution_package_feasibility',SCRIPTS/'feasibility.py')
    feasibility=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(feasibility)
    import packages
    native=make_workbook(tmp_path,[paragraph('GET FILE="input.sav".\nREGRESSION.')])
    imports=tmp_path/'imports';imports.mkdir();archive=imports/'package.zip'
    with zipfile.ZipFile(archive,'w') as z:z.write(native,'native/Code.spwb')
    manifest=tmp_path/'manifest.json';manifest.write_text(json.dumps({
        'destination_root':str(imports),'files':[{'destination_path':'package.zip','sha256':packages.sha(archive)}],
        'packages':[{'package_id':'spwb-fixture','package_path':'package.zip','material_files':[]}]}))
    catalog=tmp_path/'catalog.json';catalog.write_text('{}')
    work=tmp_path/'work'
    feasibility.prepare(SimpleNamespace(manifest=str(manifest),package_id='spwb-fixture',
        output=str(work),catalog=str(catalog),environment=None))
    item=json.loads((work/'work_item.json').read_text())
    source=next(s for s in item['sources'] if s['path']=='native/Code.spwb')
    assert source['kind']=='code' and source['original_path'].endswith('native/Code.spwb')
    assert source['content_format']=='spwb_static_syntax_projection'
    assert source['locations']['2']['paragraph_index']==0
    assert 'REGRESSION.' in Path(source['content_path']).read_text()
    assert 'RESULT_VALUE_SENTINEL' not in Path(source['content_path']).read_text()
    assert item['static_spwb_inspection'] in item['frozen_files']
    report=Path(item['static_spwb_inspection']['path']).read_text()
    assert 'RESULT_VALUE_SENTINEL' not in report and 'REGRESSION.' not in report
    for path_key,hash_key in [('original_path','sha256'),('content_path','content_sha256')]:
        assert {'path':source[path_key],'sha256':source[hash_key]} in item['frozen_files']
    assert not list(work.rglob('*.sps'))


def test_packages_text_dispatch_does_not_treat_workbook_as_plain_zip(tmp_path):
    import packages
    source=make_workbook(tmp_path,[paragraph('REGRESSION.')])
    text,locations,warnings=packages.text(source)
    assert 'REGRESSION.' in text and 'RESULT_VALUE_SENTINEL' not in text
    assert locations['2']['program_kind']=='spss_syntax'
