"""Fictional preparation metadata only; no paper assessments or resource probes."""
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys

import pytest


ROOT = Path(__file__).resolve().parents[1]
FILENAME = 'feasibility_classification.schema.json'


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


@pytest.fixture(params=['replication', 'execution'])
def prepared_case(tmp_path, request):
    kind = request.param
    project = tmp_path/'git'
    skills = project/'skills'
    for name in ['check-replication-feasibility', 'check-execution-feasibility']:
        shutil.copytree(ROOT/'skills'/name, skills/name,
                        ignore=shutil.ignore_patterns('__pycache__', '*.pyc'))
    contract = skills/'check-replication-feasibility/references'/FILENAME
    contract.write_text(json.dumps({'type':'object','title':'Fictional classification contract'}))
    skill = skills/f'check-{kind}-feasibility'
    script = skill/'scripts/feasibility.py'
    catalog = tmp_path/'catalog.json'
    catalog.write_text(json.dumps({'catalog_sha256':'a'*64,'datasets':[]}))
    if kind == 'replication':
        pdf = tmp_path/'fixture.pdf'; pdf.write_bytes(b'fictional paired-source bytes')
        reading = tmp_path/'reading.json'; reading.write_text(json.dumps({'paper_id':'W-fixture','pages':[]}))
        payloads = {
            'models':{'paper_id':'W-fixture','paper_text_file':str(reading),'models':[]},
            'samples':{'paper_id':'W-fixture','samples':[]},
            'manifest':{'paper_id':'W-fixture','pdf_path':str(pdf),'pdf_sha256':digest(pdf),
                        'reading_json':str(reading),'reading_json_sha256':digest(reading)}
        }
        paths = {}
        for name,data in payloads.items():
            path = tmp_path/(name+'.jsonl'); path.write_text(json.dumps(data)+'\n');paths[name]=path
        output = tmp_path/'campaign'
        args = ['prepare','--root',str(output),'--catalog',str(catalog),'--models',str(paths['models']),
                '--samples',str(paths['samples']),'--manifest',str(paths['manifest']),
                '--kind','pilot','--paper-id','W-fixture']
        run = output/'pilot_01'
        item = run/'items/W-fixture.json'
    else:
        package = tmp_path/'imports/fixture'; package.mkdir(parents=True)
        document = package/'README.txt';document.write_text('Fictional static fixture.\n')
        manifest = tmp_path/'manifest.json'
        manifest.write_text(json.dumps({'destination_root':str(package.parent),
            'files':[{'destination_path':'fixture/README.txt','sha256':digest(document)}],
            'packages':[{'package_id':'fixture-package','package_path':'fixture',
                         'material_files':['fixture/README.txt']}]}))
        output = tmp_path/'work';run = output;item=output/'work_item.json'
        args = ['prepare','--manifest',str(manifest),'--package-id','fixture-package',
                '--catalog',str(catalog),'--output',str(output)]
    return {'kind':kind,'script':script,'args':args,'contract':contract,'output':output,
            'run':run,'item':item,'project':project,'cwd':tmp_path}


def invoke(case, code=None):
    command = ([sys.executable,str(case['script']),*case['args']] if code is None else
               [sys.executable,'-c',code,str(case['script'].parent),json.dumps(case['args'])])
    return subprocess.run(command,cwd=case['cwd'],capture_output=True,text=True,check=False)


def test_future_snapshot_resolves_and_pins_shared_contract(prepared_case):
    case=prepared_case; result=invoke(case)
    assert result.returncode==0, result.stderr
    item=json.loads(case['item'].read_text());record=item['classification_contract']
    target=(case['run']/('skill_snapshot/references' if case['kind']=='replication'
                         else 'check-replication-feasibility/references')/FILENAME)
    assert record=={'path':str(target),'sha256':digest(case['contract'])}
    assert target.read_bytes()==case['contract'].read_bytes()
    snapshot=case['run']/'skill_snapshot'
    for document in [snapshot/'SKILL.md',snapshot/'references/assessment_rules.md']:
        links=re.findall(r'\(([^)]*feasibility_classification\.schema\.json)\)',document.read_text())
        assert links and all((document.parent/link).resolve()==target for link in links)
    if case['kind']=='replication':
        assert json.loads((case['run']/'run.json').read_text())['classification_contract']==record
        assert 'classification_contract' not in item['input_hashes']
    else:
        assert record in item['frozen_files']
        assert 'classification_contract' not in item['output_header']['provenance']


def test_missing_contract_fails_before_preparation_metadata_or_quota(prepared_case):
    case=prepared_case;case['contract'].unlink();result=invoke(case)
    assert result.returncode!=0 and 'shared classification schema' in result.stderr
    assert not case['item'].exists()
    assert not case['output'].exists()


def test_frozen_contract_drift_is_refused(prepared_case):
    case=prepared_case;assert invoke(case).returncode==0
    item=json.loads(case['item'].read_text());record=item['classification_contract']
    Path(record['path']).write_text('{}')
    if case['kind']=='replication':
        code='''import json,sys
sys.path.insert(0,sys.argv[1])
import feasibility
args=json.loads(sys.argv[2]);run=args[args.index('--root')+1]+'/pilot_01/run.json'
feasibility.check_run_inputs(json.load(open(run)))
'''
    else:
        code='''import json,sys
sys.path.insert(0,sys.argv[1])
from assessment import _guard_file
args=json.loads(sys.argv[2]);item=json.load(open(args[args.index('--output')+1]+'/work_item.json'))
record=item['classification_contract'];_guard_file(record['path'],record['sha256'])
'''
    result=invoke(case,code)
    assert result.returncode!=0 and ('changed' in result.stderr.lower() or 'frozen' in result.stderr.lower())


def test_copy_time_contract_mutation_never_saves_success_metadata(prepared_case):
    case=prepared_case
    code='''import json,sys
sys.path.insert(0,sys.argv[1])
import feasibility
original=feasibility.shutil.copy2
def corrupt(source,target,*args,**kwargs):
 result=original(source,target,*args,**kwargs)
 if str(target).endswith('feasibility_classification.schema.json'):
  open(target,'w').write('{}')
 return result
feasibility.shutil.copy2=corrupt
sys.argv=[feasibility.__file__,*json.loads(sys.argv[2])]
feasibility.main()
'''
    result=invoke(case,code)
    assert result.returncode!=0 and 'changed during freezing' in result.stderr
    assert not case['item'].exists()
    if case['kind']=='replication':assert not (case['output']/'campaign.json').exists()


def test_legacy_replication_run_without_contract_remains_valid(prepared_case):
    case=prepared_case
    if case['kind']!='replication':pytest.skip('Only reconstruction has check_run_inputs')
    assert invoke(case).returncode==0
    code='''import json,sys
sys.path.insert(0,sys.argv[1])
import feasibility
args=json.loads(sys.argv[2]);run=args[args.index('--root')+1]+'/pilot_01/run.json'
info=json.load(open(run));record=info.pop('classification_contract')
from pathlib import Path
Path(record['path']).unlink()
feasibility.check_run_inputs(info)
'''
    assert invoke(case,code).returncode==0
