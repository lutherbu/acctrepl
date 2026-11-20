"""Regression tests for fresh campaigns, publication receipts and relocatable paths."""
from concurrent.futures import ThreadPoolExecutor
import importlib.util
import json
from pathlib import Path

import pytest

from scripts import publication as pub, publish_record, publish_reproduction
from scripts import reproduction_runs as runs, update_paper_catalog as catalog
from project_layout import runtime_executable


def write(path, value):
    path.parent.mkdir(parents=True,exist_ok=True)
    path.write_bytes(pub.encode(value))
    return path


def test_new_campaign_adds_papers_and_publishes_only_the_accepted_attempt(tmp_path, monkeypatch):
    root=tmp_path/'checkout with spaces'
    private=root/'.local/runs/reproduction'
    monkeypatch.setattr(runs,'PROJECT',root)
    monkeypatch.setattr(runs,'RUNS',private)
    monkeypatch.setattr(runs,'CAMPAIGN',private/'campaign.json')
    skill=root/'skills/reproduce-accounting-models'
    monkeypatch.setattr(runs,'SKILL',skill)
    template={'cells':[]}
    write(skill/'references/stata.template.ipynb',template)
    (skill/'SKILL.md').write_text('Fixture skill.')
    write(root/'output/feasibility_reproduction/resources/catalog.json',{})
    metadata=[]
    for pid in ('W1','W2'):
        reading=write(root/'papers/parsed'/f'{pid}.json',{})
        pdf=write(root/'papers/pdf'/f'{pid}.pdf',{})
        metadata.append({'paper_id':pid,'title':pid,'journal':'JAR','publication_year':2018})
        write(root/'output/models/records'/f'{pid}.json',{'paper_id':pid,'models':[],'source_inputs':
              {key:{'path':str(p.relative_to(root)),'sha256':pub.sha(p)} for key,p in [('reading',reading),('pdf',pdf)]}})
        write(root/'output/samples/records'/f'{pid}.json',{'paper_id':pid,'samples':[]})
        write(root/'output/feasibility_reproduction/records'/f'{pid}.json',{'paper_id':pid,'requirements':[],
              'assessments':[],'summary':{'baseline_models':0}})
    docs=root/'docs';docs.mkdir()
    (docs/'papers.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in metadata))
    runs.prepare('W1')
    with pytest.raises(ValueError,match='(?i)prepare'):runs.assign('W2','build')
    with ThreadPoolExecutor(2) as pool:
        list(pool.map(runs.prepare,['W2','W2']))
    assert [r['paper_id'] for r in json.loads(runs.CAMPAIGN.read_bytes())['papers']]==['W1','W2']
    resource_catalog = root/'output/feasibility_reproduction/resources/catalog.json'
    resource_catalog.unlink()
    with pytest.raises(ValueError,match='local resource catalog'):
        runs.assign('W2','build')
    assert not (private/'papers/W2/attempt_01').exists()
    write(resource_catalog,{})
    first=Path(runs.assign('W2','build')['path'])
    attempt=Path(runs.assign('W2','review')['path'])
    assert (first/'work_item.json').is_file()
    work=attempt/'work_item.json';original=pub.sha(work)
    write(attempt/'stata.ipynb',template)
    (attempt/'review.md').write_text(f'Reviewed sources in {attempt}.\n')
    (attempt/'irrelevant.txt').write_text('Stay private.')
    names=['submission.json','stata.ipynb','review.md']
    outcome={'paper_id':'W2','attempt':2,'files':{k:pub.sha(attempt/k) for k in names}}
    write(attempt/'outcome.json',outcome)
    dest=publish_reproduction.install(root,attempt)
    assert dest.parent.parent.name=='packages'
    assert not (dest/'irrelevant.txt').exists()
    item=json.loads((dest/'work_item.json').read_bytes())
    assert item['historical_predecessor']=={'paper_id':'W2','attempt':1}
    assert item['predecessor'] is None
    assert all(not Path(k).is_absolute() for k in item['source_hashes'])
    assert all(str(root) not in p.read_text() for p in dest.rglob('*') if p.is_file())
    assert pub.sha(work)==original
    pub.verify_receipt(dest.parent)
    receipt=pub.sha(dest.parent/'accepted.json')
    assert publish_reproduction.install(root,attempt)==dest
    (attempt/'review.md').write_text('Unreviewed change.')
    with pytest.raises(ValueError,match='Changed native artifact'):publish_reproduction.install(root,attempt)
    assert pub.sha(dest.parent/'accepted.json')==receipt
    new=tmp_path/'second checkout';root.rename(new)
    pointer=json.loads((new/'output/reproductions/packages/W2/accepted.json').read_bytes())
    assert (new/pointer['path']/'work_item.json').is_file()


def test_verify_a_blocked_paper_before_any_native_data_exist(tmp_path):
    from scripts.verify_current_outputs import verify
    package=tmp_path/'output/reproductions/packages/W1'
    attempt=package/'attempt_02'
    locator = 'output/feasibility_reproduction/resources/catalog.json'
    (tmp_path/'output/feasibility_reproduction/records').mkdir(parents=True)
    snapshot = write(tmp_path/locator, {'site':'original'})
    write(attempt/'work_item.json',{'catalog_path':locator,'source_hashes':{locator:pub.sha(snapshot)}})
    write(attempt/'stata.ipynb',{'cells':[]})
    write(attempt/'runtime/latest.json',{'cells':{}})
    write(attempt/'submission.json',{'samples':[{'dta_file':'data/unbuilt.dta'}]})
    result=write(attempt/'outcome.json',{'paper_id':'W1','attempt':2,'files':{},'fits':[{'execution_status':'blocked'}]})
    write(package/'accepted.json',{'attempt':2,'path':attempt.relative_to(tmp_path).as_posix(),'outcome_sha256':pub.sha(result)})
    docs=tmp_path/'docs';docs.mkdir()
    jsonl,csv=catalog.serialize_catalog([])
    (docs/'papers.jsonl').write_bytes(jsonl);(docs/'papers.csv').write_bytes(csv)
    assert verify(tmp_path,with_data=True)['reproduction_blocked']==1
    retained = tmp_path/'original catalog.json'
    snapshot.rename(retained)
    assert verify(tmp_path)['reproduction_blocked']==1
    with pytest.raises(ValueError,match='original resource catalog'):
        verify(tmp_path,with_data=True)
    assert verify(tmp_path,with_data=True,catalog_snapshots=[retained])['reproduction_blocked']==1
    with pytest.raises(ValueError,match='requires --with-data'):
        verify(tmp_path,catalog_snapshots=[retained])
    write(snapshot,{'site':'another installation','path':'/local-library/holdings'})
    assert verify(tmp_path)['reproduction_blocked']==1
    with pytest.raises(ValueError,match='original resource catalog'):
        verify(tmp_path,with_data=True,catalog_snapshots=[snapshot])
    assert verify(tmp_path,with_data=True,catalog_snapshots=[snapshot,retained])['reproduction_blocked']==1


def test_failed_replacement_keeps_previous_package(tmp_path, monkeypatch):
    root=tmp_path/'checkout'
    dest=root/'output/replications/packages/p'
    with pub.staged_package(root,'replications','p') as stage:
        (stage/'report.json').write_text('one')
    with pub.staged_package(root,'replications','p') as stage:
        (stage/'report.json').write_text('two')
    assert (dest/'report.json').read_text()=='two'
    assert (root/'.local/publications/replications/p/previous/report.json').read_text()=='one'
    monkeypatch.setattr(pub,'exchange',lambda a,b:False)
    swap=pub.os.replace
    def interrupt(old,new):
        if new==dest and old.name=='package':
            raise OSError('Interrupted install')
        return swap(old,new)
    monkeypatch.setattr(pub.os,'replace',interrupt)
    with pytest.raises(OSError,match='Interrupted'):
        with pub.staged_package(root,'replications','p') as stage:
            (stage/'report.json').write_text('three')
    assert (dest/'report.json').read_text()=='two'


def test_paths_quotes_and_verified_review(tmp_path):
    policy=pub.PublicPaths('paper')
    text=r'//Mac/Dropbox/My Projects/data/observations.csv'
    assert policy.text(text)==pub.PublicPaths('paper').text(text)
    assert pub.MARK.fullmatch(policy.text(text))
    assert pub.MARK.fullmatch(policy.text(r'\\client\share\input.csv'))
    assert pub.MARK.fullmatch(policy.document({'path':'//researchnode/share/input.csv'})['path'])
    assert pub.MARK.search(policy.text('Stored in /custom-volume/author/input.csv'))
    assert policy.text('//line//comment')=='//line//comment'
    assert pub.MARK.fullmatch(policy.document({'path':'/another-volume/studies/x'})['path'])
    assert policy.text('https://archive.example/data/t.csv')=='https://archive.example/data/t.csv'
    assert policy.document({'reviewer':'/root/review_agent'})['reviewer']=='/root/review_agent'
    with pytest.raises(ValueError,match='executable'):policy.data('worker.do',b'cd "C:/Users/owner/data"\n')
    with pytest.raises(ValueError,match='executable'):policy.data('worker.do',b'/* end */ cd "/externaldisk/secret"\n')
    source=tmp_path/'source.do';source.write_text('first\ncd "C:/Users/owner/data"\n')
    ref={'path':'main.do','content_path':str(source),'content_sha256':pub.sha(source)}
    item=write(tmp_path/'item.json',{'output_header':{'package_id':'p'},'sources':[ref]})
    proposal=tmp_path/'patch_proposal.md';proposal.write_text('Switch away from ~/private/input.csv.')
    ev={'id':'one','file':'main.do','line_begin':2,'line_end':2,'quote':source.read_text().splitlines()[1],'kind':'source'}
    scope={'id':'full_pipeline','data_status':'local_available','execution_readiness':'preparation_required'}
    assessment=write(tmp_path/'assessment.json',{'package_id':'p','scopes':[scope],'evidence':[ev],
                                                'patch_proposal':{'sha256':pub.sha(proposal)}})
    review=write(tmp_path/'review.json',{'package_id':'p','accepted':True,'assessment_sha256':pub.sha(assessment),
        'proposal_sha256':pub.sha(proposal),'work_item_sha256':pub.sha(item)})
    root=tmp_path/'public';publish_record.publish(root,'feasibility_execution',assessment,item=item,review=review)
    package=root/'output/feasibility_execution/packages/p';pub.verify_receipt(package)
    released=json.loads((package/'assessment.json').read_bytes())
    assert (released['classification'], released['route']) == ('ready', 'prepare_and_execute')
    proof=json.loads((package/'publication_receipt.json').read_bytes())['source_quotes'][0]
    assert proof['source_sha256']==ref['content_sha256']
    assert proof['quote_sha256']!=proof['public_quote_sha256']
    source.write_text('other text')
    with pytest.raises(ValueError,match='Frozen evidence changed'):
        publish_record.publish(root,'feasibility_execution',assessment,item=item,review=review)


def test_explicit_runtime_and_sashelp_roots(tmp_path,monkeypatch):
    fake=tmp_path/'stata fixture';fake.touch();fake.chmod(0o700)
    monkeypatch.setenv('ACCTREPL_STATA',str(fake))
    assert runtime_executable('stata')==str(fake)
    monkeypatch.setenv('ACCTREPL_STATA',str(tmp_path/'absent'))
    with pytest.raises(ValueError,match='ACCTREPL_STATA'):runtime_executable('stata',required=False)
    script=Path(__file__).resolve().parents[1]/'skills/check-replication-feasibility/scripts/resources.py'
    spec=importlib.util.spec_from_file_location('sashelp_resources',script)
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
    report=tmp_path/'contents.txt'
    report.write_text(
        'Data Set Name SASHELP.ZIPCODE   Observations 10\nVariables 1\n'
        'Filename C:/SAS install/sashelp/zipcode.sas7bdat\n'
        ' # Variable    Type Len   Label\n 1 ZIP         Num    8   Postal code\n'
        '                          ====================\n'
        '                          METADATA REPORT FOR LIBRARY: NEXT\n'
        '                          Physical Name C:/some location\n')
    field=mod.parse_catalog(report)['datasets'][0]
    assert field['path'].endswith('SAS install/sashelp/zipcode.sas7bdat')
    assert field['variables'][0]['label']=='Postal code'
    root=tmp_path/'multiple libraries';research=root/'research';helpdir=root/'installed SASHELP'
    for d in (research,helpdir):d.mkdir(parents=True)
    monkeypatch.setenv('ACCTREPL_SAS_ROOT',str(research))
    monkeypatch.setenv('ACCTREPL_SASHELP_ROOT',str(helpdir))
    rows=[{'dataset':'SASHELP.ZIPCODE','path':'${ACCTREPL_SASHELP_ROOT}/zipcode.sas7bdat','variables':[{'name':'ZIP'}]}]
    with pytest.raises(FileNotFoundError) as e:
        mod._sas_probe({'datasets':rows},{'dataset':'SASHELP.ZIPCODE'})
    assert Path(e.value.filename)==helpdir/'zipcode.sas7bdat'
    rows[0]['path']='${ACCTREPL_SAS_ROOT}/zipcode.sas7bdat'
    with pytest.raises(ValueError,match='configured root differ'):mod._sas_probe({'datasets':rows},{'dataset':'SASHELP.ZIPCODE'})
    rows[0]['path']='${ACCTREPL_SASHELP_ROOT}/../research/zipcode.sas7bdat'
    with pytest.raises(ValueError,match='outside'):mod._sas_probe({'datasets':rows},{'dataset':'SASHELP.ZIPCODE'})


def test_catalog_refuses_absolute_escape_and_link(tmp_path):
    for name in (str(tmp_path/'output/models/record.json'),'../output/models/x.json',r'C:\private\data.json'):
        with pytest.raises(ValueError):catalog._result_path(tmp_path,name)
    (tmp_path/'output/models').mkdir(parents=True)
    (tmp_path/'output/models/escape.json').symlink_to(tmp_path/'outside.json')
    with pytest.raises(ValueError,match='symbolic'):catalog._result_path(tmp_path,'output/models/escape.json')
