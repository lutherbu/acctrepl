"""Frozen CLI resource lookup must work without neighboring repository skills."""
from pathlib import Path
import hashlib
import json
import shutil
import subprocess
import sys

import pytest

ROOT=Path(__file__).resolve().parents[1]
SKILL=ROOT/'skills/check-execution-feasibility'
RESOURCE=ROOT/'skills/check-replication-feasibility/scripts/resources.py'


@pytest.fixture
def frozen(tmp_path):
    work=tmp_path/'assignment'
    shutil.copytree(SKILL,work/'skill_snapshot',ignore=shutil.ignore_patterns('__pycache__','*.pyc'))
    helper=work/'frozen_resources/resources.py';helper.parent.mkdir()
    shutil.copy2(RESOURCE,helper)
    record={'path':str(helper),'sha256':hashlib.sha256(helper.read_bytes()).hexdigest()}
    item=work/'work_item.json';item.write_text(json.dumps({'resource_helper':record,'frozen_files':[record]}))
    dataset={'dataset':'COMP.FUNDA','libref':'COMP','path':'/fixture/sas/fixture.sas7bdat',
             'label':'Annual fundamentals','catalog_observations':123,'declared_variables':1,'line_begin':10,
             'variables':[{'name':'GVKEY','label':'Company key'}]}
    catalog=work/'catalog.json';catalog.write_text(json.dumps({
        'sources':[{'name':'Compustat','aliases':['COMP'],'librefs':['COMP']}],
        'datasets':[dataset]}))
    return work,item,catalog,helper


def lookup(work,catalog,query='Compustat'):
    return subprocess.run([sys.executable,str(work/'skill_snapshot/scripts/feasibility.py'),
                           'lookup','--catalog',str(catalog),'--query',query],
                          cwd=work.parent,capture_output=True,text=True,timeout=15)


def test_frozen_lookup_returns_only_matching_leaves(frozen):
    work,item,catalog,helper=frozen
    result=lookup(work,catalog)
    assert result.returncode==0,result.stderr
    hits=json.loads(result.stdout)
    assert len(hits)==1 and hits[0]['dataset']=='COMP.FUNDA'
    assert hits[0]['field_matches']==[]
    assert not {'sources','datasets','variables'}.intersection(hits[0])
    assert len(result.stdout)<1000


def test_frozen_and_repository_cli_results_match(frozen):
    work,item,catalog,helper=frozen
    old=subprocess.run([sys.executable,str(SKILL/'scripts/feasibility.py'),
                        'lookup','--catalog',str(catalog),'--query','GVKEY'],
                       capture_output=True,text=True,timeout=15)
    new=lookup(work,catalog,'GVKEY')
    assert old.returncode==new.returncode==0,(old.stderr,new.stderr)
    assert old.stdout==new.stdout
    assert json.loads(new.stdout)[0]['field_matches']==[{'name':'GVKEY','label':'Company key'}]


def test_changed_helper_is_refused_before_import(frozen):
    work,item,catalog,helper=frozen
    sentinel=work/'executed'
    helper.write_text(f'from pathlib import Path\nPath({str(sentinel)!r}).touch()\n')
    result=lookup(work,catalog)
    assert result.returncode==2 and 'path/hash' in result.stderr
    assert not sentinel.exists()


def test_unregistered_helper_is_refused(frozen):
    work,item,catalog,helper=frozen
    value=json.loads(item.read_text());value['frozen_files']=[];item.write_text(json.dumps(value))
    result=lookup(work,catalog)
    assert result.returncode==2 and 'not registered' in result.stderr


def test_helper_path_cannot_redirect_import(frozen):
    work,item,catalog,helper=frozen
    value=json.loads(item.read_text());value['resource_helper']['path']=str(RESOURCE)
    value['frozen_files']=[value['resource_helper']];item.write_text(json.dumps(value))
    result=lookup(work,catalog)
    assert result.returncode==2 and 'path/hash' in result.stderr


def test_empty_query_result_stays_empty(frozen):
    work,item,catalog,helper=frozen
    result=lookup(work,catalog,'unknown-product')
    assert result.returncode==0 and json.loads(result.stdout)==[]
