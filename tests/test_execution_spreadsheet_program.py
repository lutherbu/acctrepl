"""Static workbook program evidence: no calculation, refresh or cached data."""
import json
from pathlib import Path
import subprocess
import sys
from zipfile import ZipFile

import pytest

SCRIPTS=Path(__file__).resolve().parents[1]/'skills/check-execution-feasibility/scripts'
sys.path.insert(0,str(SCRIPTS))
from packages import sha,text
from spreadsheet_program import spreadsheet_text

MAIN='http://schemas.openxmlformats.org/spreadsheetml/2006/main'
REL='http://schemas.openxmlformats.org/officeDocument/2006/relationships'
PKG='http://schemas.openxmlformats.org/package/2006/relationships'


def workbook(path, *, formulas=True, pivots=True, sheet_xml=None, extra=()):
    sheet_xml=sheet_xml or f'''<worksheet xmlns="{MAIN}" xmlns:r="{REL}"><sheetData>
      <row r="1"><c r="A1"><f>IF(Data!B2&gt;0,1,0)</f><v>PRIVATE_CELL_VALUE</v></c></row>
      <row r="2"><c r="A2"><f t="shared" si="0" ref="A2:A3">SUM(B2:C2)</f><v>PRIVATE_SHARED_RESULT</v></c></row>
      <row r="3"><c r="A3"><f t="shared" si="0"/><v>PRIVATE_FOLLOWER_RESULT</v></c></row>
      </sheetData>{'<pivotTableParts count="1"><pivotTablePart r:id="p1"/></pivotTableParts>' if pivots else ''}</worksheet>'''
    if not formulas and sheet_xml:
        sheet_xml=f'<worksheet xmlns="{MAIN}"><sheetData><row><c r="A1"><v>PRIVATE_DATA_ONLY_VALUE</v></c></row></sheetData></worksheet>'
    entries={
      'xl/workbook.xml':f'<workbook xmlns="{MAIN}" xmlns:r="{REL}"><sheets><sheet name="Results" sheetId="1" r:id="s1"/></sheets><pivotCaches><pivotCache cacheId="0" r:id="c1"/></pivotCaches></workbook>',
      'xl/_rels/workbook.xml.rels':f'<Relationships xmlns="{PKG}"><Relationship Id="s1" Target="worksheets/sheet1.xml"/><Relationship Id="c1" Target="pivotCache/pivotCacheDefinition1.xml"/><Relationship Id="e1" TargetMode="External" Target="https://invalid.example/DO_NOT_FETCH"/></Relationships>',
      'xl/worksheets/sheet1.xml':sheet_xml,
      'xl/worksheets/_rels/sheet1.xml.rels':f'<Relationships xmlns="{PKG}"><Relationship Id="p1" Type="{REL}/pivotTable" Target="../pivotTables/pivotTable1.xml"/></Relationships>',
      'xl/pivotTables/pivotTable1.xml':f'<pivotTableDefinition xmlns="{MAIN}" name="StudyCounts" cacheId="0"><location ref="D1:F5"/><rowFields><field x="0"/></rowFields><dataFields><dataField name="Count of response" fld="1" subtotal="count"/></dataFields></pivotTableDefinition>',
      'xl/pivotCache/pivotCacheDefinition1.xml':f'<pivotCacheDefinition xmlns="{MAIN}"><cacheSource type="worksheet"><worksheetSource ref="A1:B8" sheet="Raw Data"/></cacheSource><cacheFields><cacheField name="unused"><sharedItems><s v="PRIVATE_CACHE_ITEM"/></sharedItems></cacheField></cacheFields></pivotCacheDefinition>',
      'xl/pivotCache/pivotCacheRecords1.xml':'THIS IS NOT XML: PRIVATE_CACHE_ROW_RECORD',
      'xl/sharedStrings.xml':'THIS IS NOT XML: PRIVATE_SHARED_STRING',
    }
    if not pivots:
        entries={k:v for k,v in entries.items() if not k.startswith('xl/pivotTables/')
                 and not k.startswith('xl/pivotCache/') and k!='xl/worksheets/_rels/sheet1.xml.rels'}
    entries.update(dict(extra))
    with ZipFile(path,'w') as z:
        for name,value in entries.items():z.writestr(name,value)
    return path


def status(raw):
    return json.loads(raw.splitlines()[-1].removeprefix('INSPECTION_STATUS '))


def test_formula_and_pivot_locations_without_evaluation_or_cached_values(tmp_path,monkeypatch):
    path=workbook(tmp_path/'study.xlsx');before=path.read_bytes();opened=[]
    original=ZipFile.open
    def track(self,name,*args,**kwargs):
        opened.append(name.filename if hasattr(name,'filename') else name)
        return original(self,name,*args,**kwargs)
    monkeypatch.setattr(ZipFile,'open',track)
    monkeypatch.setattr(subprocess,'run',lambda *a,**k:pytest.fail('No subprocess may run for static workbook reading'))
    raw,locations,warnings=text(path)
    assert not warnings and status(raw)['partial'] is False
    assert status(raw)['extracted_formulas']==3 and status(raw)['extracted_pivots']==1
    assert 'PRIVATE_' not in raw and 'DO_NOT_FETCH' not in raw
    assert 'IF(Data!B2>0,1,0)' in raw and 'SUM(B2:C2)' in raw
    formulas=[x for x in locations.values() if x['program_kind']=='formula']
    assert [x['cell'] for x in formulas]==['A1','A2','A3']
    pivot=next(x for x in locations.values() if x['program_kind']=='pivot_table')
    assert pivot['sheet']=='Results' and pivot['cell_range']=='D1:F5'
    assert 'Raw Data' in raw and 'Count of response' in raw
    assert 'xl/pivotCache/pivotCacheRecords1.xml' not in opened
    assert 'xl/sharedStrings.xml' not in opened
    assert sha(path) in raw and path.read_bytes()==before


def test_data_only_workbook_is_not_automatically_program_code(tmp_path):
    path=workbook(tmp_path/'data.xlsx',formulas=False,pivots=False)
    raw,locations,warnings=text(path)
    assert locations=={} and not warnings
    assert status(raw)['extracted_formulas']==status(raw)['extracted_pivots']==0
    assert status(raw)['partial'] is False and 'PRIVATE_' not in raw


def test_pivots_linked_only_by_sheet_relationships_are_program_sources(tmp_path):
    sheet=f'<worksheet xmlns="{MAIN}"><sheetData/></worksheet>'
    path=workbook(tmp_path/'relationship_only.xlsx',sheet_xml=sheet)
    raw,locations,warnings=spreadsheet_text(path)
    assert not warnings and status(raw)['partial'] is False
    assert status(raw)['extracted_pivots']==1
    assert any(x['program_kind']=='pivot_table' for x in locations.values())


def test_unlinked_pivot_definitions_cannot_silently_establish_absent_code(tmp_path):
    sheet=f'<worksheet xmlns="{MAIN}"><sheetData/></worksheet>'
    path=workbook(tmp_path/'unlinked.xlsx',sheet_xml=sheet,
        extra=[('xl/worksheets/_rels/sheet1.xml.rels',f'<Relationships xmlns="{PKG}"/>')])
    raw,locations,warnings=spreadsheet_text(path)
    assert warnings and status(raw)['partial'] is True
    assert not locations and status(raw)['extracted_pivots']==0


@pytest.mark.parametrize('limit',[
    {'members':1}, {'archive_declared_bytes':1}, {'member_bytes':1},
    {'selected_xml_bytes':1}, {'archive_bytes':1}, {'formulas':1},
])
def test_limits_are_explicit_and_never_infer_absent_code(tmp_path,limit):
    path=workbook(tmp_path/'study.xlsx');before=path.read_bytes()
    raw,locations,warnings=spreadsheet_text(path,limit)
    assert warnings and status(raw)['partial'] is True
    assert status(raw)['count_scope']=='inspected parts only'
    if limit=={'formulas':1}:
        assert status(raw)['extracted_formulas']==1 and locations
    assert path.read_bytes()==before and 'PRIVATE_' not in raw


def test_text_limit_preserves_partial_status_and_total_bound(tmp_path):
    sheet=f'<worksheet xmlns="{MAIN}"><sheetData><row><c r="A1"><f>SUM({"A1,"*1200}A1)</f><v>PRIVATE_RESULT</v></c></row></sheetData></worksheet>'
    path=workbook(tmp_path/'long.xlsx',sheet_xml=sheet,pivots=False)
    raw,locations,warnings=spreadsheet_text(path,{'output_chars':2048})
    assert len(raw)<=2048 and warnings and status(raw)['partial'] is True
    assert not locations and 'PRIVATE_RESULT' not in raw


@pytest.mark.parametrize('payload',[
    '<!DOCTYPE workbook [<!ENTITY x "PRIVATE_ENTITY">]><workbook>&x;</workbook>',
    '<?xml version="1.0"?><workbook/>'.encode('utf-16'),
])
def test_dtd_entities_and_nul_encodings_are_not_parsed(tmp_path,payload):
    path=workbook(tmp_path/'unsafe.xlsx',extra=[('xl/workbook.xml',payload)])
    raw,locations,warnings=spreadsheet_text(path)
    assert warnings and status(raw)['partial'] is True and not locations
    assert 'PRIVATE_ENTITY' not in raw


def test_relationship_escape_is_explicit_without_external_access(tmp_path):
    path=workbook(tmp_path/'escape.xlsx',extra=[('xl/_rels/workbook.xml.rels',
        f'<Relationships xmlns="{PKG}"><Relationship Id="s1" Target="../../outside.xml"/></Relationships>')])
    raw,locations,warnings=spreadsheet_text(path)
    assert warnings and status(raw)['partial'] is True and not locations


def test_preparation_binds_static_workbook_reading_to_original_bytes(tmp_path):
    imports=tmp_path/'imports';imports.mkdir()
    program=workbook(tmp_path/'program.xlsx');data=workbook(tmp_path/'data.xlsx',formulas=False,pivots=False)
    archive=imports/'source.zip'
    with ZipFile(archive,'w') as z:
        z.writestr('program.xlsx',program.read_bytes());z.writestr('data.xlsx',data.read_bytes())
    manifest={'destination_root':str(imports),'files':[{'destination_path':'source.zip','sha256':sha(archive)}],
              'packages':[{'package_id':'book-test','package_path':'source.zip','material_files':[]}]}
    m=tmp_path/'manifest.json';m.write_text(json.dumps(manifest));c=tmp_path/'catalog.json';c.write_text('{}')
    out=tmp_path/'work'
    p=subprocess.run([sys.executable,str(SCRIPTS/'feasibility.py'),'prepare','--manifest',str(m),
                      '--package-id','book-test','--catalog',str(c),'--output',str(out)],capture_output=True,text=True)
    assert p.returncode==0,p.stderr
    item=json.loads((out/'work_item.json').read_text());sources={x['path']:x for x in item['sources']}
    assert sources['program.xlsx']['kind']=='code' and sources['data.xlsx']['kind']=='data'
    for name,source in sources.items():
        assert source['sha256']==sha(out/'package'/name)
        assert source['content_sha256']==sha(source['content_path'])
        assert source['content_format']=='xlsx_static_program_inspection'
    assert sha(program)==sha(out/'package/program.xlsx')
