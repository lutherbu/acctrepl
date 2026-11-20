"""Behavioral checks for immutable author-package preparation."""
from pathlib import Path
import importlib.util
import json
import stat
import sys
from zipfile import ZipFile,ZipInfo
import pytest

SCRIPTS=Path(__file__).resolve().parents[1]/'skills/check-execution-feasibility/scripts'
sys.path.insert(0,str(SCRIPTS))
from packages import extract, safe, text, bounded_metadata, sha


def makezip(path,entries):
    with ZipFile(path,'w') as z:
        for k,v in entries:z.writestr(k,v)
    return path


@pytest.mark.parametrize('name',['../x','/x','C:/x','a/../../x'])
def test_extraction_rejects_escape(tmp_path,name):
    z=makezip(tmp_path/'x.zip',[(name,'bad')])
    with pytest.raises(ValueError):extract(z,tmp_path/'out')
    assert not (tmp_path/'x').exists()


def test_extraction_rejects_link(tmp_path):
    i=ZipInfo('link');i.external_attr=(stat.S_IFLNK|0o777)<<16
    z=makezip(tmp_path/'x.zip',[(i,'elsewhere')])
    with pytest.raises(ValueError):extract(z,tmp_path/'out')


def test_marker_and_copy_integrity(tmp_path):
    z=makezip(tmp_path/'x.zip',[('/',''),('analysis.do','regress y x')]);before=sha(z)
    s=extract(z,tmp_path/'out')
    assert s['issues'] and (tmp_path/'out/analysis.do').read_text()=='regress y x'
    assert sha(z)==before


def test_notebook_text_keeps_cell_locations(tmp_path):
    p=tmp_path/'analysis.ipynb';p.write_text(json.dumps({'metadata':{'kernelspec':{'name':'stata'}},'cells':[{'id':'fit','cell_type':'code','source':['regress y x\n','esttab using "tables/x.csv"']}]}))
    data,locations,warnings=text(p)
    assert data.startswith('regress y x') and locations['2']['cell_id']=='fit' and locations['2']['cell_line']==2


@pytest.mark.parametrize('suffix',['.docx','.sas'])
def test_docx_preserves_program_tokens_across_runs_and_layout(tmp_path,suffix):
    xml = r'''<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
      <w:body><w:p>
        <w:r><w:t>a</w:t></w:r><w:r><w:t>ppend using "G:\JA</w:t></w:r>
        <w:r><w:t>R\opinion.dta", force</w:t></w:r>
      </w:p><w:p>
        <w:r><w:tab/><w:t>generate x=1</w:t><w:br/><w:t>replace x=2</w:t>
        <w:cr/><w:t>display x</w:t></w:r>
      </w:p></w:body></w:document>'''
    p=makezip(tmp_path/('program'+suffix),[('word/document.xml',xml)])
    before=sha(p)
    data,locations,warnings=text(p)
    assert data == 'append using "G:\\JAR\\opinion.dta", force\n\tgenerate x=1\nreplace x=2\ndisplay x'
    assert locations == {} and sha(p) == before
    assert warnings == ([] if suffix=='.docx' else [
        'Word OOXML container detected despite .sas suffix; extracted text is not a native source file'])


def test_metadata_is_bounded_and_immutable(tmp_path):
    p=tmp_path/'data.csv';p.write_text('x,y\n1,2\n3,4\n');before=sha(p)
    out=tmp_path/'probe.json';r=bounded_metadata(tmp_path,'data.csv',out)
    assert r['status']=='ok' and r['result']['rows_read']==1 and r['result']['columns']==['x','y']
    assert r['result']['coverage_verified'] is False and sha(p)==before


def test_metadata_no_traversal(tmp_path):
    with pytest.raises(ValueError):bounded_metadata(tmp_path,'../secret.csv',tmp_path/'probe.json')


def test_safe_path_rejects_symlink(tmp_path):
    (tmp_path/'link').symlink_to(tmp_path/'other')
    with pytest.raises(ValueError):safe(tmp_path,'link')


def test_source_is_never_executed(tmp_path):
    p=tmp_path/'analysis.py';sentinel=tmp_path/'marker';p.write_text(f'from pathlib import Path\nPath({str(sentinel)!r}).touch()')
    text(p)
    assert not sentinel.exists()


def test_prepare_without_data_still_stages_environment(tmp_path):
    import subprocess
    base=tmp_path/'imports';base.mkdir();z=makezip(base/'source.zip',[('analysis.do','regress y x')])
    manifest={'destination_root':str(base),'files':[{'destination_path':'source.zip','sha256':sha(z)}],
              'packages':[{'package_id':'synthetic','package_path':'source.zip','material_files':[], 'directory_path':'paper','doi':'same-doi'},
                          {'package_id':'original','package_path':'original.zip','material_files':[], 'directory_path':'paper','doi':'same-doi'},
                          {'package_id':'unrelated','package_path':'unrelated.zip','material_files':[], 'directory_path':'different-paper','doi':'same-doi'}]}
    m=tmp_path/'manifest.json';m.write_text(json.dumps(manifest));c=tmp_path/'catalog.json';c.write_text('{}')
    env=tmp_path/'env.json';env.write_text('{"status":"ok","result":{"software":{}}}')
    out=tmp_path/'work';cmd=[sys.executable,str(SCRIPTS/'feasibility.py'),'prepare','--manifest',str(m),'--package-id','synthetic','--catalog',str(c),'--environment',str(env),'--output',str(out)]
    result=subprocess.run(cmd,capture_output=True,text=True)
    assert result.returncode==0,result.stderr
    assert (out/'probes/environment.json').is_file() and (out/'work_item.json').is_file()
    item=json.loads((out/'work_item.json').read_text())
    helper=out/'frozen_resources/resources.py'
    assert item['resource_helper']=={'path':str(helper),'sha256':sha(helper)}
    assert item['resource_helper'] in item['frozen_files']
    assert [x['package_id'] for x in item['related_packages']]==['original']
    assert item['related_packages'][0]['discovery_only'] is True


def test_single_column_csv_metadata(tmp_path):
    (tmp_path/'ids.csv').write_text('firm_id\n001\n002\n')
    r=bounded_metadata(tmp_path,'ids.csv',tmp_path/'probe.json')
    assert r['status']=='ok' and r['result']['columns']==['firm_id'] and r['result']['rows_read']==1


def test_dta_file_count_is_distinct_from_one_row_probe(tmp_path):
    import pandas as pd
    import pyreadstat
    pyreadstat.write_dta(pd.DataFrame({'x':[1,2,3],'y':[3,4,5]}),str(tmp_path/'data.dta'))
    before=sha(tmp_path/'data.dta')
    r=bounded_metadata(tmp_path,'data.dta',tmp_path/'probe.json')['result']
    assert r['rows_read']==1 and r['catalog_observations']==3
    assert r['observation_count_scope']=='file_metadata'
    assert r['coverage_verified'] is False and sha(tmp_path/'data.dta')==before


def test_sas_metadata_never_requests_whole_file_scan(tmp_path,monkeypatch):
    from types import SimpleNamespace
    import packages
    import pyreadstat
    import pandas as pd
    source=tmp_path/'large.sas7bdat';source.write_bytes(b'fixture')
    calls=[]
    def fake_read(path,**kwargs):
        calls.append(kwargs)
        assert kwargs=={'row_limit':1,'disable_datetime_conversion':True}
        return pd.DataFrame({'firm_id':[1]}),SimpleNamespace(
            column_names=['firm_id'],column_labels=['Firm'],number_rows=1)
    monkeypatch.setattr(pyreadstat,'read_sas7bdat',fake_read)
    result=packages.metadata(source,'large.sas7bdat')
    assert len(calls)==1 and result['rows_read']==1
    assert result['catalog_observations'] is None
    assert result['observation_count_scope']=='unknown'
    assert result['coverage_verified'] is False


def test_software_command_cannot_inject_code(tmp_path):
    from packages import stata_software
    for name in ['grstyle; do author.do','regsave\nregress y x','../script','x"','_gxtile; do author.do']:
        with pytest.raises(ValueError):stata_software(name,tmp_path/'probe.json')
    assert not list(tmp_path.iterdir())


def test_software_probe_accepts_internal_extension_name(tmp_path,monkeypatch):
    import packages
    from types import SimpleNamespace
    output=tmp_path/'egen_xtile.json'
    monkeypatch.setattr(packages.shutil,'which',lambda name:str(tmp_path/'fixture-bin'/name))
    def fake_run(command,**kwargs):
        script=Path(command[-1]).read_text()
        assert 'capture which _gxtile\n' in script
        output.with_suffix('.log').write_text('__EF_VERSION__ 18\n__EF_RC__ 0\n')
        return SimpleNamespace(returncode=0,stdout='',stderr='')
    monkeypatch.setattr(packages.subprocess,'run',fake_run)
    result=packages.stata_software('_gxtile',output)
    assert result['status']=='ok' and result['result']['available'] is True
    assert result['result']['location']=='software:_gxtile'


def test_excel_blank_header_preserves_column_position(tmp_path):
    from openpyxl import Workbook
    book=Workbook();sheet=book.active
    sheet.append(['firm_id',None,'value']);sheet.append([1,'unlabelled',2])
    book.save(tmp_path/'data.xlsx');book.close()
    result=bounded_metadata(tmp_path,'data.xlsx',tmp_path/'probe.json')['result']
    assert result['excel_columns'][1]=={'column':'B','header':None}
    assert 'not necessarily' in result['header_semantics']
    assert result['rows_read']==1 and result['coverage_verified'] is False
