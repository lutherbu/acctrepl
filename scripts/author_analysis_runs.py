#!/usr/bin/env python3
"""Freeze, assign, execute and review fresh-agent author-analysis attempts.

Only the attempt's frozen runner executes native programs. This controller never
starts a model, installs software, downloads data or changes source packages.
"""
from __future__ import annotations

import argparse
from collections import Counter
from contextlib import contextmanager
from datetime import datetime, timezone
import fcntl
import hashlib
import importlib.util
import json
import math
import os
import pathlib
from pathlib import Path
import re
import shutil
import sys
import uuid

from jsonschema.validators import validator_for

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
import project_layout as layout

# Resolve filesystem IO without editing paths inside hash-bound legacy records.
Path = layout.path_class(ROOT)
WORKSPACE = ROOT
BASE = ROOT/'.local/runs/author_analysis_execution'
DEFAULT_MANIFEST = BASE/'manifest.json'
SKILL = ROOT/'skills/execute-author-analysis'
PUBLICATION = layout.active_path('execution',ROOT)
LIMITS = {'pilot_cases':6, 'attempts_per_pilot':2, 'full_waves':3, 'attempts_per_unit_wave':1}
CONFIG = {'model':'gpt-6-luna','reasoning_effort':'max','fork_turns':'none'}
DEFAULT_POLICY = {
    'scope_id':'analysis_only', 'network':False, 'package_installation':False,
    'raw_data_pipeline':False, 'source_credentials':False, 'sandbox_profiles':['bwrap'],
    'max_wall_seconds':3600, 'max_memory_bytes':16*1024**3, 'max_threads':2,
    'max_staging_bytes':8*1024**3, 'allowed_library_roots':[],
    'allowed_executables':{'stata':[], 'r':[], 'matlab':[]}
}
TERMINAL = {'accepted'}
CODE_SUFFIXES = {'.do','.ado','.r','.rmd','.m','.py','.sps','.txt','.md','.json'}
PUBLISH_CODE_SUFFIXES = {'.do','.ado','.r','.rmd','.m','.py','.sps'}
PUBLISH_RESULT_SUFFIXES = {'.csv','.tsv','.txt','.rtf','.tex','.html','.htm','.pdf','.svg','.png','.jpg','.jpeg','.eps'}
HOST_HOME = str(Path.home())
HOST_VISIBILITY_NOTE = ('Host MATLAB execution has normal user filesystem and network access; '
                        'filesystem and network isolation are not provided.')


def now():
    return datetime.now(timezone.utc).isoformat()


def sha(path):
    h=hashlib.sha256()
    with Path(path).open('rb') as source:
        for block in iter(lambda:source.read(1048576),b''):h.update(block)
    return h.hexdigest()


def read(path):
    def pairs(items):
        result={}
        for k,v in items:
            if k in result:raise ValueError('Duplicate JSON key')
            result[k]=v
        return result
    def constant(_):raise ValueError('Non-finite JSON number')
    return json.loads(Path(path).read_text(encoding='utf-8'),object_pairs_hook=pairs,parse_constant=constant)


def write(path,value,*,exclusive=False):
    path=Path(path);path.parent.mkdir(parents=True,exist_ok=True)
    data=json.dumps(value,ensure_ascii=False,sort_keys=True,indent=2,allow_nan=False)+'\n'
    if exclusive:
        with path.open('x',encoding='utf-8') as stream:
            stream.write(data);stream.flush();os.fsync(stream.fileno())
        return
    temporary=path.with_name(path.name+'.'+uuid.uuid4().hex+'.tmp')
    try:
        with temporary.open('x',encoding='utf-8') as stream:
            stream.write(data);stream.flush();os.fsync(stream.fileno())
        os.replace(temporary,path)
    finally:
        if temporary.exists():temporary.unlink()


def plain(path,*,file=False,directory=False):
    path=Path(path).absolute()
    if any(p.is_symlink() for p in (path,*path.parents)):
        raise ValueError('Paths must not use symbolic links')
    path=path.resolve()
    if file and not path.is_file():raise ValueError('Expected a plain file')
    if directory and not path.is_dir():raise ValueError('Expected a plain directory')
    return path


def inside(root,value,*,file=False):
    root=plain(root,directory=True);path=Path(value)
    path=plain(path if path.is_absolute() else root/path,file=file)
    if not path.is_relative_to(root):raise ValueError('Path escapes its assigned directory')
    return path


def assert_file(path,digest):
    path=plain(path,file=True)
    if sha(path)!=digest:raise ValueError('Frozen file changed')
    return path


def tree_hash(root):
    root=plain(root,directory=True);h=hashlib.sha256()
    for p in sorted(root.rglob('*')):
        if p.is_symlink():raise ValueError('Snapshot contains a symbolic link')
        if p.is_file() and '__pycache__' not in p.parts and p.suffix!='.pyc':
            h.update(str(p.relative_to(root)).encode());h.update(b'\0');h.update(sha(p).encode());h.update(b'\n')
    return h.hexdigest()


def publication_tree_hash(root):
    """Hash immutable publication files, excluding only local run overlays.

    Work/software payloads are pruned without reading them. Package overlays
    belong only to IDs in the hashed index; unrelated files remain protected.
    Frozen skill snapshots continue to use the stricter tree_hash above.
    """
    # Hash the files physically present, including any file reintroduced at a
    # former summary path. Historical path aliases must not redirect these reads.
    root=pathlib.Path(plain(root,directory=True));index=root/'index.json';package_ids=set()
    if index.exists():
        if index.is_symlink() or not index.is_file():raise ValueError('Publication index must be a plain file')
        packages=json.loads(index.read_bytes()).get('packages',{})
        if not isinstance(packages,dict):raise ValueError('Publication index needs package IDs')
        package_ids=set(packages)
    def failed(error):raise error
    files=[]
    for directory,dirs,names in os.walk(root,followlinks=False,onerror=failed):
        directory=pathlib.Path(directory)
        for name in list(dirs):
            path=directory/name;parts=path.relative_to(root).parts
            if path.is_symlink():raise ValueError('Publication contains a symbolic link')
            if parts==('software',) or (len(parts)==3 and parts[0]=='packages' and parts[1] in package_ids and parts[2]=='work'):
                dirs.remove(name)
        for name in names:
            path=directory/name;parts=path.relative_to(root).parts
            if path.is_symlink() or not path.is_file():raise ValueError('Publication needs plain files')
            if len(parts)==3 and parts[0]=='packages' and parts[1] in package_ids and parts[2] in {'local_inputs.json','RUN_LOCAL.md'}:
                continue
            files.append(path)
    digests={path.relative_to(root):layout.sha(path) for path in files}
    # The original signed tree included cohort files. Its index identifies
    # their verified historical digests; every retained file is still read above.
    legacy=layout.manifest(ROOT).get('execution_summary_relocation',{})
    if legacy and digests.get(pathlib.Path('index.json'))==legacy['index_sha256']:
        for name,digest in legacy['files'].items():
            digests.setdefault(pathlib.Path(name),digest)
    h=hashlib.sha256()
    for name,digest in sorted(digests.items()):
        h.update(str(name).encode());h.update(b'\0');h.update(digest.encode());h.update(b'\n')
    return h.hexdigest()


@contextmanager
def locked(root):
    root=plain(root);root.mkdir(parents=True,exist_ok=True)
    path=root/'.campaign.lock'
    if path.is_symlink():raise ValueError('Lock must not be a symbolic link')
    with path.open('a') as handle:
        fcntl.flock(handle,fcntl.LOCK_EX)
        try:yield
        finally:fcntl.flock(handle,fcntl.LOCK_UN)


def _ref(source,destination):
    source=plain(source,file=True);digest=sha(source)
    destination.parent.mkdir(parents=True,exist_ok=True)
    if destination.exists():raise ValueError('Frozen destination already exists')
    shutil.copy2(source,destination);assert_file(destination,digest);destination.chmod(0o444)
    return {'path':str(destination),'sha256':digest,'source_path':str(source)}


def _host_authorization(reference):
    if not isinstance(reference,dict) or not reference.get('path') or not reference.get('sha256'):
        raise ValueError('Host execution needs an explicit authorization file and hash')
    record=read(assert_file(reference['path'],reference['sha256']))
    if (record.get('approved') is not True or record.get('approved_by')!='user' or record.get('execution_profile')!='host'
            or record.get('languages')!=['matlab'] or record.get('host_home')!=HOST_HOME
            or not isinstance(record.get('user_instruction'),str) or not record['user_instruction'].strip()):
        raise ValueError('Host authorization must explicitly approve MATLAB with normal host access')
    try:
        timestamp=datetime.fromisoformat(record['approved_at'].replace('Z','+00:00'))
        if timestamp.tzinfo is None:raise ValueError('Timezone is required')
    except (KeyError,AttributeError,TypeError,ValueError):
        raise ValueError('Host authorization needs a timezone-qualified approval timestamp') from None
    return record


def _policy(path=None):
    value=read(plain(path,file=True)) if path else json.loads(json.dumps(DEFAULT_POLICY))
    if path is None:
        for language in ('stata', 'r'):
            executable = layout.runtime_executable(language, required=False)
            if executable:
                value['allowed_executables'][language] = [executable]
    for key in ('network','package_installation','source_credentials'):
        if value.get(key) is not False:raise ValueError('Execution policy cannot enable excluded actions')
    if value.get('scope_id') not in {'analysis_only', 'full_pipeline'} or value.get('sandbox_profiles') not in (['bwrap'],['host']):
        raise ValueError('Policy must declare an assessed scope and runtime profile')
    if type(value.get('raw_data_pipeline')) is not bool or (value['raw_data_pipeline'] and value['scope_id'] != 'full_pipeline'):
        raise ValueError('Raw input preparation requires an assigned full pipeline')
    for key in ('max_wall_seconds','max_memory_bytes','max_threads','max_staging_bytes'):
        if type(value.get(key)) is not int or value[key]<=0:raise ValueError('Invalid resource policy')
    if not isinstance(value.get('allowed_library_roots'),list) or not isinstance(value.get('allowed_executables'),dict):
        raise ValueError('Policy must declare library roots and executable names')
    if not isinstance(value.get('stata_ado_paths',[]),list):raise ValueError('Stata ado paths must be explicitly listed')
    if value['sandbox_profiles']==['host']:
        if value.get('host_home')!=HOST_HOME:raise ValueError('Approved MATLAB host mode requires its normal user HOME')
        _host_authorization(value.get('host_execution_authorization'))
        executables=value['allowed_executables']
        matlab=executables.get('matlab')
        if (any(paths for language,paths in executables.items() if language!='matlab')
                or not isinstance(matlab,list) or not matlab
                or any(not isinstance(x,str) or not Path(x).is_absolute() for x in matlab)
                or value.get('stata_ado_paths')):
            raise ValueError('Host execution approval permits only explicit MATLAB executables')
    return value


def _manifest(path,fixture):
    path=plain(path,file=True);document=read(path)
    units=document.get('units',document.get('packages'))
    if not isinstance(units,list) or not units:raise ValueError('Manifest needs units')
    if fixture and len(units)>3:
        raise ValueError('Fixture collections support up to three units')
    ids=[]
    for unit in units:
        pid=unit.get('package_id')
        if not isinstance(pid,str) or not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9_.:-]*',pid):
            raise ValueError('Unsafe package identity')
        ids.append(pid)
        scope=unit.get('analysis_scope',{})
        allowed = {'analysis_only', 'full_pipeline'} if unit.get('baseline_targets') else {'analysis_only'}
        if scope.get('id') not in allowed or unit.get('scope_id', scope['id']) != scope['id']:
            raise ValueError('Every unit must identify its frozen assessed scope')
        entries=scope.get('entry_points')
        if not isinstance(entries,list) or not entries or any(not isinstance(x,str) or not x for x in entries):
            raise ValueError('Analysis scope needs source entrypoints')
        plain(unit['package_root'],directory=True)
        for key in ('source_assessment','source_work_item','source_proposal'):
            if key not in unit:continue
            reference=unit[key];assert_file(reference['path'],reference['sha256'])
        assessment=read(unit['source_assessment']['path'])
        if assessment.get('package_id')!=pid or scope not in assessment.get('scopes',[]):
            raise ValueError('Analysis scope differs from its accepted source assessment')
        source_item=read(unit['source_work_item']['path'])
        original_id=source_item.get('output_header',{}).get('package_id',source_item.get('package',{}).get('package_id'))
        if original_id!=pid or plain(source_item['package_root'],directory=True)!=plain(unit['package_root'],directory=True):
            raise ValueError('Package root differs from its frozen source work item')
    if len(set(ids))!=len(ids):raise ValueError('Duplicate package identity')
    return path,units


def initialize_paper(item_path, assessment_path, targets_path=None):
    item_path=plain(item_path,file=True)
    assessment_path=plain(assessment_path,file=True)
    item, assessment=read(item_path),read(assessment_path)
    pid=assessment['package_id']
    if not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9_-]*',pid):
        raise ValueError('Invalid package ID')
    scopes = {scope['id']: scope for scope in assessment['scopes']}
    scope = scopes.get('analysis_only', scopes.get('full_pipeline'))
    if not scope:
        raise ValueError('Assessment has no reviewed execution scope')
    targets = None
    if 'execution_readiness' in scope:
        from scripts.feasibility_verdict import execution_verdict
        _, route = execution_verdict(scope['data_status'], scope['execution_readiness'])
        if route not in {'execute', 'prepare_and_execute'}:
            raise ValueError('The selected scope has no Ready author-code route')
        if not targets_path:
            raise ValueError('Provide --baseline-targets before the one author-code attempt')
    if targets_path:
        targets = read(plain(targets_path, file=True))
        if not isinstance(targets, dict) or not targets or not all(
                isinstance(k, str) and k.strip() and isinstance(v, str) and v.strip()
                for k, v in targets.items()):
            raise ValueError('Baseline targets must map each target ID to its expected numerical output')
    campaign=BASE/pid
    unit={'package_id':pid,'analysis_scope':scope,'package_root':item['package_root'],
          'source_assessment':{'path':str(assessment_path),'sha256':sha(assessment_path)},
          'source_work_item':{'path':str(item_path),'sha256':sha(item_path)}}
    if targets is not None:
        unit['baseline_targets'] = targets
    proposal=assessment_path.parent/'patch_proposal.md'
    if proposal.is_file():
        unit['source_proposal']={'path':str(proposal),'sha256':sha(proposal)}
    manifest=campaign/'source.json'
    with locked(campaign):
        if manifest.is_file():
            if read(manifest) != {'units': [unit]}:
                raise ValueError('An existing assignment uses different source material')
        else:
            write(manifest, {'units': [unit]})
    return initialize(manifest,campaign)


def initialize(manifest=DEFAULT_MANIFEST,campaign=BASE,*,fixture=False):
    campaign=plain(campaign)
    if not fixture and not campaign.is_relative_to(BASE.resolve()):raise ValueError('Production campaign has one fixed root')
    source,units=_manifest(manifest,fixture)
    with locked(campaign):
        target=campaign/'campaign.json'
        if target.exists():
            _,state=resolve(campaign)
            if state['manifest']['sha256']!=sha(source) or state['fixture']!=fixture:
                raise ValueError('Existing campaign identity differs; do not reset it')
            return {'campaign':str(campaign),'status':'existing','unit_count':len(units)}
        if any((campaign/'attempts').glob('*')):raise ValueError('Attempt history exists without a registry')
        frozen=_ref(source,campaign/'frozen/manifest.json')
        state={'schema_version':'1.0','campaign_root':str(campaign),'fixture':fixture,
               'created_at':now(),'updated_at':now(),'limits':dict(LIMITS),'manifest':frozen,
               'units':{u['package_id']:u for u in units},'attempts':{},'pilot_cases':{},
               'full_waves':{},'publication':None,'assignment_configuration':dict(CONFIG)}
        write(target,state,exclusive=True)
    return {'campaign':str(campaign),'status':'initialized','unit_count':len(units)}


def resolve(campaign=BASE):
    campaign=plain(campaign,directory=True);state=read(campaign/'campaign.json')
    if state.get('campaign_root')!=str(campaign) or state.get('limits')!=LIMITS or state.get('assignment_configuration')!=CONFIG:
        raise ValueError('Campaign identity or authorized limits changed')
    if not state.get('fixture') and not campaign.is_relative_to(BASE.resolve()):raise ValueError('Production root differs')
    assert_file(state['manifest']['path'],state['manifest']['sha256'])
    expected={u['package_id']:u for u in read(state['manifest']['path']).get('units',read(state['manifest']['path']).get('packages',[]))}
    if state.get('units')!=expected:raise ValueError('Frozen unit inventory changed')
    return campaign,state


def _save(campaign,state):
    state['updated_at']=now();write(campaign/'campaign.json',state)


def _attempt(attempt):
    attempt=plain(attempt,directory=True)
    item=read(attempt/'work_item.json');campaign,state=resolve(item['campaign_root'])
    record=state['attempts'].get(item.get('attempt_id'))
    if not record or record['directory']!=str(attempt):raise ValueError('Attempt is not registered')
    assert_file(attempt/'work_item.json',record['work_item_sha256'])
    if tree_hash(attempt/'skill_snapshot')!=record['skill_sha256']:raise ValueError('Frozen skill changed')
    for reference in item['frozen_files']:assert_file(reference['path'],reference['sha256'])
    return attempt,campaign,state,record,item


def _latest(state,*,full_only=True):
    chosen={}
    for record in state['attempts'].values():
        if record['status']=='accepted' and (not full_only or record['phase']=='full'):
            prior=chosen.get(record['package_id'])
            if prior is None or record['ordinal']>prior['ordinal']:chosen[record['package_id']]=record
    return chosen


def prepare(package_id,phase,case,*,campaign=BASE,policy_path=None):
    campaign,_=resolve(campaign)
    if phase not in {'pilot','full'} or type(case) is not int or case<1:
        raise ValueError('A valid pilot/full case number is required')
    policy=_policy(policy_path)
    with locked(campaign):
        campaign,state=resolve(campaign)
        if state['publication'] and phase=='full' and case<state['publication']['last_full_wave']:
            raise ValueError('After publication, an earlier full wave cannot reopen')
        if package_id not in state['units']:raise ValueError('Package is outside the frozen 17-scope inventory')
        unit=state['units'][package_id]
        if policy_path and policy['scope_id'] != unit['analysis_scope']['id']:
            raise ValueError('Execution policy must match the selected scope')
        if 'baseline_targets' in unit:
            if phase != 'full' or case != 1 or any(r['package_id'] == package_id for r in state['attempts'].values()):
                raise ValueError('One author-code attempt is allowed for this Ready package')
            policy['scope_id'] = unit['analysis_scope']['id']
            if not policy_path:
                policy['raw_data_pipeline'] = policy['scope_id'] == 'full_pipeline'
        if phase=='pilot':
            if case>LIMITS['pilot_cases']:raise ValueError('Six pilot tests are the authorized maximum')
            prior=state['pilot_cases'].get(str(case))
            if prior and prior['package_id']!=package_id:raise ValueError('A pilot case retains one package')
            records=[r for r in state['attempts'].values() if r['phase']=='pilot' and r['case']==case]
            if len(records)>=LIMITS['attempts_per_pilot']:raise ValueError('Two attempts per pilot are the authorized maximum')
        else:
            if case>LIMITS['full_waves']:raise ValueError('Three full sweeps are the authorized maximum')
            previous=[r for r in state['attempts'].values() if r['phase']=='full' and r['case']<case]
            if case>1 and (len(_latest(state))!=len(state['units']) or any(r['status']!='accepted' for r in previous)):
                raise ValueError('Finish and review the preceding full coverage before another wave')
            records=[r for r in state['attempts'].values() if r['phase']=='full' and r['case']==case and r['package_id']==package_id]
            if records:raise ValueError('Each package has one attempt per full sweep')
        if records and any(r['status']!='accepted' for r in records):
            raise ValueError('Finish the prior attempt before reserving another')
        ordinal=len(state['attempts'])+1;number=len(records)+1
        aid=f'{phase}_{case:02d}.{package_id}.a{number:02d}'
        if len(aid)>80 or ':' in aid:raise ValueError('Attempt identity exceeds the native runner limit')
        directory=campaign/'attempts'/aid
        if directory.exists():raise ValueError('Attempt path already exists; never overwrite it')
        directory.mkdir(parents=True)
        try:
            (directory/'work').mkdir();(directory/'output').mkdir();(directory/'frozen/plans').mkdir(parents=True)
            snapshot=directory/'skill_snapshot'
            shutil.copytree(SKILL,snapshot,ignore=shutil.ignore_patterns('__pycache__','*.pyc'))
            frozen=[]
            source_refs={}
            for key in ('source_assessment','source_work_item','source_proposal'):
                if key not in unit:continue
                reference=unit[key];assert_file(reference['path'],reference['sha256'])
                source_refs[key]=_ref(reference['path'],directory/'frozen'/f'{key}.json')
                frozen.append(source_refs[key])
            unit_path=directory/'frozen/unit.json';write(unit_path,unit,exclusive=True);unit_path.chmod(0o444)
            host_authorization=None
            if policy['sandbox_profiles']==['host']:
                authorization=policy['host_execution_authorization'];_host_authorization(authorization)
                frozen_authorization=_ref(authorization['path'],directory/'frozen/host_execution_authorization.json')
                assert_file(frozen_authorization['path'],authorization['sha256'])
                frozen.append(frozen_authorization)
                host_authorization={k:frozen_authorization[k] for k in ('path','sha256')}
                policy=json.loads(json.dumps(policy));policy['host_execution_authorization']=host_authorization
            policy_file=directory/'frozen/policy.json';write(policy_file,policy,exclusive=True);policy_file.chmod(0o444)
            read_roots=[str(plain(unit['package_root'],directory=True)),
                        *[str(plain(p,directory=True)) for p in policy['allowed_library_roots']]]
            for path in policy.get('stata_ado_paths',[]):
                path=plain(path,directory=True)
                if not any(path.is_relative_to(Path(p)) for p in read_roots):
                    raise ValueError('Stata ado paths must be inside approved read-only roots')
            runtime_policy={'schema_version':'1.0','sandbox_profile':policy['sandbox_profiles'][0],
                'allowed_read_only_roots':read_roots,'runtime_paths':policy['allowed_executables'],
                'limits':{'wall_seconds':policy['max_wall_seconds'],'memory_bytes':policy['max_memory_bytes'],
                          'threads':policy['max_threads']},'stata_ado_paths':policy.get('stata_ado_paths',[])}
            if host_authorization is not None:
                runtime_policy.update(host_home=HOST_HOME,host_execution_authorization=host_authorization)
            runtime_file=directory/'frozen/runtime_policy.json';write(runtime_file,runtime_policy,exclusive=True);runtime_file.chmod(0o444)
            frozen.extend([{'path':str(unit_path),'sha256':sha(unit_path)}, {'path':str(policy_file),'sha256':sha(policy_file)},
                           {'path':str(runtime_file),'sha256':sha(runtime_file)}])
            item={'schema_version':'1.0','attempt_id':aid,'campaign_root':str(campaign),
                  'package_id':package_id,'scope_id':unit['analysis_scope']['id'],'phase':phase,'case':case,
                  'attempt_number':number,'directory':str(directory),'working_directory':str(directory/'work'),
                  'input_root':str(plain(unit['package_root'],directory=True)),'analysis_scope':unit['analysis_scope'],
                  'unit':unit,'frozen_files':frozen,'policy':{'path':str(policy_file),'sha256':sha(policy_file)},
                  'runtime_policy':{'path':str(runtime_file),'sha256':sha(runtime_file)},
                  'skill_sha256':tree_hash(snapshot),'skill_path':str(snapshot/'SKILL.md'),
                  'output_schema':str(snapshot/'references/output.schema.json'),
                  'runner_path':str(snapshot/'scripts/runner.py'),'required_configuration':dict(CONFIG),
                  'source_reader_path':str(snapshot/'scripts/view.py'),
                  'previous_attempts':[{'attempt_id':r['attempt_id'],'directory':r['directory'],'status':r['status']}
                      for r in state['attempts'].values() if r['package_id']==package_id],
                  'report_template':str(directory/'report_template.json'),**source_refs}
            if host_authorization is not None:
                item.update(execution_profile='host',host_home=HOST_HOME,host_execution_authorization=host_authorization)
            write(directory/'work_item.json',item,exclusive=True);(directory/'work_item.json').chmod(0o444)
            write(directory/'report_template.json',{
                **output_header(item,directory/'work_item.json'),'outcome':'not_run','execution_verified':False,
                'method_fidelity':'author_native','plan':None,'run_receipt':None,'inputs':[],
                'patches':[],'stage_results':[],'artifacts':[],
                'comparison':{'status':'not_assessed','references':[],'metrics':[],
                              'notes':['Execution and reference comparison have not yet been performed.']},
                'gaps':[{'id':'G_NOT_RUN','kind':'scope','description':'The selected analysis has not yet been executed.',
                         'source_entry_points':unit['analysis_scope']['entry_points'],'stage_ids':[],'references':[]}],
                'review_notes':[HOST_VISIBILITY_NOTE] if host_authorization is not None else []},exclusive=True)
            record={'attempt_id':aid,'package_id':package_id,'phase':phase,'case':case,'attempt_number':number,
                    'ordinal':ordinal,'directory':str(directory),'prepared_at':now(),'status':'prepared',
                    'work_item_sha256':sha(directory/'work_item.json'),'skill_sha256':item['skill_sha256'],
                    'agent':None,'plan_reviews':[],'report_trials':[],'execution_history':[]}
            state['attempts'][aid]=record
            if phase=='pilot':state['pilot_cases'].setdefault(str(case),{'package_id':package_id})
            else:state['full_waves'].setdefault(str(case),{'created_at':now()})
            _save(campaign,state)
        except Exception:
            # Unregistered staging is not an attempt and contains no execution.
            if aid not in state['attempts']:shutil.rmtree(directory)
            raise
    return {'attempt':str(directory),'attempt_id':aid,'work_item':str(directory/'work_item.json')}


def assign(attempt,agent,*,model=None,reasoning_effort=None,fork_turns=None):
    attempt,campaign,_,_,_=_attempt(attempt)
    configuration={'model':model,'reasoning_effort':reasoning_effort,'fork_turns':fork_turns}
    if configuration!=CONFIG:raise ValueError('Each attempt requires explicit fresh Luna Max fork-none configuration')
    if not isinstance(agent,str) or not agent.startswith('/root/') or len(agent)>300:
        raise ValueError('An exact canonical fresh agent name is required')
    with locked(campaign):
        attempt,campaign,state,record,item=_attempt(attempt)
        if record['status']!='prepared':raise ValueError('Only a prepared unassigned attempt can be assigned')
        if any(r.get('agent')==agent for r in state['attempts'].values()):
            raise ValueError('A fresh agent is required for every attempt')
        if any(r['package_id']==record['package_id'] and r['attempt_id']!=record['attempt_id']
               and r['status'] not in TERMINAL|{'prepared'} for r in state['attempts'].values()):
            raise ValueError('Another assignment for this package is unfinished')
        record.update(agent=agent,configuration=configuration,assigned_at=now(),status='assigned')
        _save(campaign,state)
    return {'attempt_id':record['attempt_id'],'agent':agent,'status':'assigned'}


def stage(attempt,paths):
    attempt,campaign,state,record,item=_attempt(attempt)
    if record['status'] not in {'assigned','prepared','finalization_failed'} or (attempt/'runtime/intent.json').exists():
        raise ValueError('Input staging belongs before native execution')
    policy=read(item['policy']['path']);root=plain(item['input_root'],directory=True)
    existing_path=attempt/'staging.json';existing=read(existing_path) if existing_path.exists() else {'files':[]}
    by_target={r['staged_path']:r for r in existing['files']};total=sum(r['bytes'] for r in by_target.values())
    for relative in paths:
        if Path(relative).is_absolute():raise ValueError('Stage package-relative files only')
        source=inside(root,relative,file=True);destination=inside(attempt/'work',relative)
        digest=sha(source)
        if str(destination) not in by_target:
            total+=source.stat().st_size
            if total>policy['max_staging_bytes']:raise ValueError('Selective staging exceeds the attempt byte budget')
        if destination.exists():
            if not destination.is_file() or sha(destination)!=digest:
                raise ValueError('Refusing to overwrite a staged or edited working file')
        else:
            destination.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,destination)
            destination.chmod(0o644)
        assert_file(source,digest);assert_file(destination,digest)
        if (source.stat().st_dev,source.stat().st_ino)==(destination.stat().st_dev,destination.stat().st_ino):
            raise ValueError('Working files must never hardlink original inputs')
        by_target[str(destination)]={'original_path':str(source),'original_sha256':digest,
                                    'staged_path':str(destination),'staged_sha256':digest,'bytes':source.stat().st_size}
        write(existing_path,{'files':list(by_target.values())})
    return {'attempt_id':item['attempt_id'],'staged_files':len(by_target),'bytes':sum(r['bytes'] for r in by_target.values())}


def _has_launch(attempt):
    path=attempt/'runtime/intent.json'
    return path.exists() or path.is_symlink()


def _plan_coverage(item,plan):
    expected=set(item['analysis_scope']['entry_points']);covered=set();all_entries=set();gapped=set()
    for stage in plan.get('stages',[]):
        entries=stage.get('source_entry_points')
        if not isinstance(entries,list) or any(not isinstance(e,str) for e in entries):
            raise ValueError('Every stage needs original source-entrypoint metadata')
        all_entries.update(entries)
        if stage.get('required',True):covered.update(entries)
    for gap in plan.get('scope_gaps',[]):
        if not isinstance(gap,dict) or not gap.get('reason') or not isinstance(gap.get('source_entry_points'),list):
            raise ValueError('Unexecuted source entrypoints need explicit gap reasons')
        gapped.update(gap['source_entry_points'])
    if (covered|gapped)!=expected or all_entries-expected or gapped-expected:
        raise ValueError('Plan must account for every selected source entrypoint and no other scope')
    return {'expected':sorted(expected),'staged':sorted(covered),'gapped':sorted(gapped)}


def _validate_plan(attempt,item,plan):
    if plan.get('schema_version')!='1.0' or plan.get('attempt_id')!=item['attempt_id']:
        raise ValueError('Plan identity differs from the assigned attempt')
    policy=_policy(item['policy']['path']);sandbox=plan.get('sandbox',{})
    if sandbox.get('profile') not in policy['sandbox_profiles']:
        raise ValueError('Plan must use its approved sandbox profile')
    if policy['sandbox_profiles']==['host']:
        if sandbox.get('read_only_paths')!=[] or sandbox.get('executable') is not None:
            raise ValueError('MATLAB host plans cannot claim read-only mounts or a sandbox executable')
        runtime=read(item['runtime_policy']['path'])
        authorization=policy['host_execution_authorization']
        if (item.get('execution_profile')!='host' or item.get('host_home')!=HOST_HOME
                or item.get('host_execution_authorization')!=authorization
                or runtime.get('sandbox_profile')!='host' or runtime.get('host_home')!=HOST_HOME
                or runtime.get('host_execution_authorization')!=authorization):
            raise ValueError('Host plan policy must bind the same frozen user authorization')
    limits=plan.get('limits',{})
    for key,maximum in [('wall_seconds','max_wall_seconds'),('memory_bytes','max_memory_bytes'),('threads','max_threads')]:
        if type(limits.get(key)) is not int or not 0<limits[key]<=policy[maximum]:
            raise ValueError('Plan exceeds an approved resource limit')
    allowed=[plain(item['input_root'],directory=True),attempt]
    allowed.extend(plain(p,directory=True) for p in policy['allowed_library_roots'])
    for value in sandbox.get('read_only_paths',[]):
        path=plain(value)
        if not path.exists() or not any(path.is_relative_to(root) for root in allowed):
            raise ValueError('Sandbox mount exceeds the declared inputs and software libraries')
    pins=[];seen=set()
    for reference in plan.get('inputs',[]):
        path=Path(reference['path']);path=plain(path if path.is_absolute() else attempt/path,file=True)
        if not any(path.is_relative_to(root) for root in allowed):raise ValueError('Plan input is outside assigned resources')
        assert_file(path,reference['sha256'])
        if str(path) in seen:raise ValueError('Duplicate plan input path')
        seen.add(str(path));pins.append({'path':str(path),'sha256':reference['sha256']})
    stages=plan.get('stages')
    if not isinstance(stages,list) or not stages:raise ValueError('An executable plan needs native stages')
    ids=set()
    for entry in stages:
        sid=entry.get('id')
        if not isinstance(sid,str) or not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9_.:-]*',sid) or sid in ids:
            raise ValueError('Plan stage IDs must be unique safe strings')
        ids.add(sid)
        executable=entry.get('executable');language=entry.get('language')
        if policy['sandbox_profiles']==['host'] and language!='matlab':
            raise ValueError('Host plans may execute only MATLAB stages')
        if executable not in policy['allowed_executables'].get(language,[]):raise ValueError('Native executable is not approved')
        script=inside(attempt,entry['script'],file=True)
        if not script.is_relative_to(attempt/'work'):raise ValueError('Execute only a staged working-copy script')
        assert_file(script,entry['script_sha256']);pins.append({'path':str(script),'sha256':entry['script_sha256']})
        cwd=inside(attempt,entry.get('cwd','work'))
        if not cwd.is_dir() or not cwd.is_relative_to(attempt/'work'):raise ValueError('Native cwd must stay inside the work directory')
        if not isinstance(entry.get('args',[]),list) or any(not isinstance(x,str) for x in entry.get('args',[])):
            raise ValueError('Native arguments must be a string list')
        outputs=entry.get('expected_outputs',[])
        if not isinstance(outputs,list) or not isinstance(entry.get('native_logs',[]),list):
            raise ValueError('Expected native files must be lists')
        if entry.get('log_only',False):
            markers=entry.get('success_markers',[])
            if outputs or not isinstance(markers,list) or any(not isinstance(x,str) or not x.strip() for x in markers) or len(set(markers))<2:
                raise ValueError('Log-only estimation needs two distinct reviewed result markers and no invented outputs')
        elif not outputs:
            raise ValueError('A native stage needs expected outputs or explicit log-only estimation evidence')
        for value in entry.get('expected_outputs',[])+entry.get('native_logs',[]):
            path=inside(attempt,value)
            if not path.is_relative_to(attempt/'work') or str(path) in seen:
                raise ValueError('Output must stay in the work tree and cannot overwrite an input')
    for entry in stages:
        if any(x not in ids for x in entry.get('depends_on',[])):raise ValueError('Unknown native dependency')
    pending=list(stages);ordered=set()
    while pending:
        ready=[entry for entry in pending if set(entry.get('depends_on',[]))<=ordered]
        if not ready:raise ValueError('Native stage dependencies contain a cycle')
        for entry in ready:pending.remove(entry);ordered.add(entry['id'])
    return _plan_coverage(item,plan),pins


def approve_plan(attempt,plan_path,reviewer,*,source_reviewed=False):
    attempt,campaign,_,_,_=_attempt(attempt)
    with locked(campaign):
        attempt,campaign,state,record,item=_attempt(attempt)
        if record['status'] not in {'assigned','preflight_blocked','finalization_failed'} or _has_launch(attempt):
            raise ValueError('A new plan is allowed only before the first native launch')
        if source_reviewed is not True or not reviewer or reviewer==record['agent']:
            raise ValueError('A separate coordinator must review the native source and plan')
        source=inside(attempt,plan_path,file=True);plan=read(source)
        coverage,pins=_validate_plan(attempt,item,plan)
        number=len(record['plan_reviews'])+1;directory=attempt/'frozen/plans'/f'plan_{number:03d}'
        directory.mkdir()
        frozen=_ref(source,directory/'plan.json')
        # Preserve exact scripts selected for the actual reviewed run.
        code=[]
        for entry in plan['stages']:
            script=inside(attempt,entry['script'],file=True)
            target=directory/'code'/script.relative_to(attempt/'work')
            if target.exists():assert_file(target,entry['script_sha256'])
            else:code.append(_ref(script,target))
        review={'reviewed_at':now(),'reviewer':reviewer,'source_reviewed':True,'plan':frozen,
                'coverage':coverage,'files':pins,'code':code}
        try:
            _runner(item).validate_plan(attempt,Path(frozen['path']))
            review['runner_validation']={'valid':True}
        except Exception as exc:
            review['runner_validation']={'valid':False,'error_type':type(exc).__name__,'error_message':str(exc)[:1000]}
            write(directory/'review.json',review,exclusive=True)
            record['plan_reviews'].append({'path':str(directory/'review.json'),'sha256':sha(directory/'review.json'),**review})
            record['status']='preflight_blocked';_save(campaign,state)
            raise ValueError('Frozen runner rejected the proposed plan before native execution: '+str(exc)) from None
        write(directory/'review.json',review,exclusive=True)
        record['plan_reviews'].append({'path':str(directory/'review.json'),'sha256':sha(directory/'review.json'),**review})
        record['status']='assigned';_save(campaign,state)
    return {'attempt_id':item['attempt_id'],'plan':frozen,'coverage':coverage}


def _approved(attempt,record,item):
    if not record['plan_reviews']:raise ValueError('A coordinator-approved plan is required')
    review=record['plan_reviews'][-1]
    if review.get('runner_validation',{}).get('valid') is False:
        raise ValueError('Latest plan failed frozen runner validation; amend and approve a new plan')
    assert_file(review['path'],review['sha256']);assert_file(review['plan']['path'],review['plan']['sha256'])
    for reference in review['files']+review['code']:assert_file(reference['path'],reference['sha256'])
    plan=read(review['plan']['path']);_validate_plan(attempt,item,plan)
    return review,plan


def _runner(item):
    path=Path(item['runner_path']);name='author_runner_'+hashlib.sha256(str(path).encode()).hexdigest()[:20]
    spec=importlib.util.spec_from_file_location(name,path);module=importlib.util.module_from_spec(spec)
    sys.modules[name]=module;spec.loader.exec_module(module)
    return layout.relocate_module(module,ROOT)


def execute(attempt,plan_path=None):
    attempt,campaign,_,_,_=_attempt(attempt)
    with locked(campaign):
        attempt,campaign,state,record,item=_attempt(attempt)
        if record['status'] not in {'assigned','preflight_blocked','finalization_failed'} or _has_launch(attempt):
            raise ValueError('Native execution cannot be repeated in this assignment')
        review,plan=_approved(attempt,record,item)
        if plan_path is not None and sha(inside(attempt,plan_path,file=True))!=review['plan']['sha256']:
            raise ValueError('Execution input differs from the approved plan')
        record.update(status='running',execution_started_at=now());_save(campaign,state)
    try:
        _runner(item).run(attempt,Path(review['plan']['path']))
    except Exception as exc:
        with locked(campaign):
            _,_,state,record,_=_attempt(attempt)
            record['status']='execution_interrupted'
            record['execution_history'].append({'recorded_at':now(),'plan_sha256':review['plan']['sha256'],
                                                'error_type':type(exc).__name__,'error_message':str(exc)[:1000],
                                                'receipt_present':(attempt/'runtime/run.json').exists() or (attempt/'runtime/run.json').is_symlink()})
            _save(campaign,state)
        raise RuntimeError('Runner interrupted; preserve runtime evidence and reconcile before proceeding') from None
    return reconcile(attempt)


def reconcile(attempt):
    attempt,campaign,_,_,_=_attempt(attempt)
    with locked(campaign):
        attempt,campaign,state,record,item=_attempt(attempt)
        if record['status'] not in {'running','execution_interrupted'}:
            raise ValueError('Reconcile only an unfinished execution record')
        review,plan=_approved(attempt,record,item)
        receipt_path=attempt/'runtime/run.json'
        if not receipt_path.exists() and not receipt_path.is_symlink() and not _has_launch(attempt):
            history=record['execution_history']
            if (record['status']!='execution_interrupted' or record.get('runtime_receipt')
                    or not history or not history[-1].get('error_type') or history[-1].get('receipt_present') is not False):
                raise ValueError('No finished receipt; an active or unverified preflight cannot be retried')
            record['execution_history'].append({'recorded_at':now(),'recovery':'prelaunch_runner_error',
                'native_intent_present':False,'receipt_present':False,'preserved_error_event':len(history)-1})
            record['status']='preflight_blocked';_save(campaign,state)
            return {'attempt_id':item['attempt_id'],'status':'preflight_blocked','run_receipt':None,
                    'runtime_status':'blocked','recovery':'prelaunch_runner_error'}
        receipt=inside(attempt,'runtime/run.json',file=True);run=read(receipt)
        if run.get('plan_sha256')!=review['plan']['sha256'] or run.get('attempt_id',item['attempt_id'])!=item['attempt_id']:
            raise ValueError('Runtime receipt belongs to another plan or attempt')
        if run.get('status') not in {'completed','partial','failed','blocked'}:
            raise ValueError('Runtime is not finished; do not classify an active process')
        reference={'path':str(receipt),'sha256':sha(receipt)}
        record['runtime_receipt']=reference
        record['execution_history'].append({'recorded_at':now(),'plan_sha256':review['plan']['sha256'],
                                            'receipt':reference,'native_intent_present':_has_launch(attempt)})
        record['status']='preflight_blocked' if run.get('status')=='blocked' and not _has_launch(attempt) else 'executed'
        _save(campaign,state)
    return {'attempt_id':item['attempt_id'],'status':record['status'],'run_receipt':reference,'runtime_status':run.get('status')}


def _file_ref(attempt,reference,expected=None):
    if not isinstance(reference,dict):raise ValueError('Expected a file reference')
    path=inside(attempt,reference['path'],file=True);assert_file(path,reference['sha256'])
    if expected and (str(path)!=expected['path'] or reference['sha256']!=expected['sha256']):
        raise ValueError('Report file reference differs from its actual evidence')
    return path


def output_header(item,work_item_path):
    header={'schema_version':'1.0','attempt_id':item['attempt_id'],'package_id':item['package_id'],
            'scope_id':item['scope_id'],'phase':item['phase'],'case':item['case'],'attempt_number':item['attempt_number'],
            'provenance':{'work_item_sha256':sha(work_item_path),'skill_sha256':item['skill_sha256'],
                          'policy_sha256':item['policy']['sha256'],
                          'source_assessment_sha256':item['unit']['source_assessment']['sha256'],
                          'source_work_item_sha256':item['unit']['source_work_item']['sha256']}}
    if item.get('execution_profile')=='host':
        header['provenance'].update(execution_profile='host',
            host_execution_authorization_sha256=item['host_execution_authorization']['sha256'])
    return header


def _comparison(draft):
    comparison=draft['comparison'];references={r['id']:r for r in comparison['references']}
    if len(references)!=len(comparison['references']):raise ValueError('Duplicate comparison reference')
    checks=[]
    for metric in comparison['metrics']:
        if metric['reference_id'] not in references:raise ValueError('Comparison metric lacks its reference')
        observed,target=metric['observed'],metric['reference'];claim=metric['matches']
        if claim is None:continue
        if observed is None or target is None or (metric['absolute_tolerance'] is None and metric['relative_tolerance'] is None):
            raise ValueError('A numerical agreement claim needs numbers and explicit tolerances')
        if not all(math.isfinite(v) for v in (observed,target)):
            raise ValueError('Non-finite numerical comparison')
        tolerance=(metric['absolute_tolerance'] or 0)+(metric['relative_tolerance'] or 0)*abs(target)
        actual=abs(observed-target)<=tolerance
        if claim is not actual:raise ValueError('Numerical comparison disagrees with its stated tolerance')
        checks.append(actual)
    if comparison['status']=='matches' and (not checks or not all(checks)):
        raise ValueError('Matches requires checked numerical agreement')
    if comparison['status']=='differs' and checks and not any(c is False for c in checks):
        raise ValueError('Differs requires at least one checked discrepancy')


def _validate_report(attempt,item,record,draft):
    schema=read(item['output_schema']);validator_class=validator_for(schema);validator_class.check_schema(schema)
    error=next(validator_class(schema).iter_errors(draft),None)
    if error is not None:raise ValueError('Report violates its frozen schema at '+('/'.join(map(str,error.absolute_path)) or 'root'))
    header=output_header(item,attempt/'work_item.json')
    for key,value in header.items():
        if draft.get(key)!=value:raise ValueError('Report header differs from its assigned frozen header')
    if item.get('execution_profile')=='host' and HOST_VISIBILITY_NOTE not in draft['review_notes']:
        raise ValueError('Host reports must retain their explicit normal filesystem/network visibility note')
    root=plain(item['input_root'],directory=True)
    policy=read(item['policy']['path']);input_bindings=set()
    for entry in draft['inputs']:
        original=plain(entry['original']['path'],file=True)
        permitted=[root]
        if entry['role'] in {'code','dependency'}:
            permitted.extend([attempt,*[plain(p,directory=True) for p in policy['allowed_library_roots']]])
        if not any(original.is_relative_to(p) for p in permitted):raise ValueError('Report original input exceeds its assigned resources')
        assert_file(original,entry['original']['sha256'])
        input_bindings.add(str(original))
        if entry['staged'] is not None:input_bindings.add(str(_file_ref(attempt,entry['staged'])))
    for patch in draft['patches']:
        working=inside(attempt,patch['working_path'],file=True)
        if not working.is_relative_to(attempt/'work'):raise ValueError('Patches belong to working copies')
        assert_file(working,patch['after_sha256'])
        if patch['original_path'] is not None:
            original=inside(root,patch['original_path'],file=True);assert_file(original,patch['before_sha256'])
        if patch['approval'] is not None:_file_ref(attempt,patch['approval'])
        if patch['kind']=='source_supported_repair' and patch['approval'] is None:
            raise ValueError('Numerically consequential source repair needs explicit approval evidence')
        if patch['kind']=='source_supported_repair':
            approvals={(r['path'],r['sha256']) for r in record['plan_reviews']}
            approved_path=str(inside(attempt,patch['approval']['path'],file=True))
            if (approved_path,patch['approval']['sha256']) not in approvals:
                raise ValueError('Source repair approval must be an actual coordinator plan review')
    _comparison(draft)
    expected=set(item['analysis_scope']['entry_points'])
    gap_entries={e for gap in draft['gaps'] for e in gap['source_entry_points']}
    if gap_entries-expected:raise ValueError('Report gap belongs to another workflow')
    if not record.get('runtime_receipt'):
        if draft['outcome'] not in {'blocked','not_run'} or draft['execution_verified']:
            raise ValueError('An execution claim requires an actual runtime receipt')
        if draft['run_receipt'] is not None or draft['stage_results'] or draft['artifacts']:
            raise ValueError('An unexecuted attempt cannot claim runtime evidence')
        if gap_entries!=expected:raise ValueError('A pre-execution block must account for every entrypoint')
        return
    _file_ref(attempt,draft['run_receipt'],record['runtime_receipt'])
    review,plan=_approved(attempt,record,item)
    _file_ref(attempt,draft['plan'],{'path':review['plan']['path'],'sha256':review['plan']['sha256']})
    run=read(record['runtime_receipt']['path'])
    native_sandbox=run.get('sandbox',{})
    if policy['sandbox_profiles']==['host']:
        expected_host={'profile':'host','filesystem_isolation':False,'network_isolation':False,
                       'network_disabled':False,'network_isolation_requested':False,'setup_verified':True,
                       'host_home_exposed':True,'host_home':HOST_HOME,'full_user_filesystem_visibility':True,
                       'host_writable_roots':None}
        if (any(k not in native_sandbox or type(native_sandbox[k]) is not type(v) or native_sandbox[k]!=v for k,v in expected_host.items())
                or run.get('host_execution_authorization')!=policy['host_execution_authorization']
                or run.get('host_execution_authorization_unchanged') is not True):
            raise ValueError('Host runtime receipt must truthfully bind authorization and normal host visibility')
    elif native_sandbox.get('profile','bwrap')!='bwrap':
        raise ValueError('A bwrap attempt cannot accept a host runtime receipt')
    if run.get('plan_sha256')!=review['plan']['sha256'] or run.get('attempt_id',item['attempt_id'])!=item['attempt_id']:
        raise ValueError('Report runtime evidence differs from the approved plan')
    if run.get('original_inputs_unchanged') is not True:raise ValueError('Native input integrity is not verified')
    for reference in plan.get('inputs',[]):
        path=Path(reference['path']);path=plain(path if path.is_absolute() else attempt/path,file=True)
        if str(path) not in input_bindings:raise ValueError('Report omits a declared native input binding')
    code_bindings=input_bindings|{str(inside(attempt,p['working_path'])) for p in draft['patches']}
    if any(str(inside(attempt,p['script'])) not in code_bindings for p in plan['stages']):
        raise ValueError('Report omits the executed working-code provenance')
    stages=run.get('stages',[])
    if not isinstance(stages,list):raise ValueError('Runtime stages must be a list')
    if run.get('status')=='blocked' and not _has_launch(attempt) and not stages:
        if draft['outcome']!='blocked' or draft['execution_verified'] or draft['stage_results'] or draft['artifacts']:
            raise ValueError('A blocked sandbox preflight is not an executed analysis')
        if gap_entries!=expected:raise ValueError('Blocked preflight must account for every selected entrypoint')
        return
    actual={r['id']:r for r in stages};planned={r['id']:r for r in plan['stages']}
    if any(g['stage_ids'] and not set(g['stage_ids'])<=set(planned) for g in draft['gaps']):
        raise ValueError('Report gap references an unknown native stage')
    if any(m['stage_id'] not in planned for m in draft['comparison']['metrics']):
        raise ValueError('Comparison references an unknown native stage')
    reported={r['stage_id']:r for r in draft['stage_results']}
    if len(actual)!=len(stages) or set(reported)!=set(planned) or len(reported)!=len(draft['stage_results']):
        raise ValueError('Report must account for every planned stage exactly once')
    if set(actual)!=set(planned):raise ValueError('Runtime receipt omits planned stages')
    succeeded=0;failed=0;all_required=True
    output_records={}
    for sid,p in planned.items():
        a=actual[sid];r=reported[sid];required=p.get('required',True)
        if r['required'] is not required or r['source_entry_points']!=p['source_entry_points']:
            raise ValueError('Stage requirement/source coverage changed after execution')
        if r['status']!=a['status'] or r['returncode']!=a.get('returncode'):
            raise ValueError('Stage claim differs from its actual runtime result')
        ok=(a['status']=='succeeded' and a.get('returncode')==0 and a.get('timeout') is False
            and a.get('native_error_detected') is False)
        if r['log_check']!=('passed' if ok else 'failed' if a['status']=='failed' else 'not_assessed'):
            raise ValueError('Stage log-check claim differs from native execution checks')
        if r['receipt'] is not None:_file_ref(attempt,r['receipt'],record['runtime_receipt'])
        if ok and r['receipt'] is None:raise ValueError('Successful stage needs its actual runtime receipt')
        outputs=a.get('outputs',[])
        by_path={str(inside(attempt,x['path'])):x for x in outputs}
        if p.get('log_only',False) and (a.get('log_only_verified') is not True or not any(x.get('fresh') is True for x in outputs)):
            ok=False
        for expected_output in p.get('expected_outputs',[]):
            path=str(inside(attempt,expected_output));proof=by_path.get(path)
            if proof is None or proof.get('fresh') is not True:ok=False
        for path,proof in by_path.items():output_records[(sid,path)]=proof
        if required:
            all_required=all_required and ok
            succeeded+=bool(ok);failed+=a['status']=='failed'
    artifacts={a['id']:a for a in draft['artifacts']}
    if len(artifacts)!=len(draft['artifacts']):raise ValueError('Duplicate report artifact')
    for artifact in artifacts.values():
        path=str(inside(attempt,artifact['path']));proof=output_records.get((artifact['stage_id'],path))
        if proof is None:raise ValueError('Artifact lacks its own native output evidence')
        digest=proof.get('after_sha256')
        if planned[artifact['stage_id']].get('log_only',False) and artifact['kind']!='native_result_log':
            raise ValueError('Log-only scientific evidence must be identified as a native result log')
        if artifact['sha256']!=digest:raise ValueError('Artifact checksum differs from native evidence')
        freshness='missing' if digest is None else 'unchanged' if not proof.get('fresh') else 'new' if proof.get('before_sha256') is None else 'changed'
        if artifact['freshness']!=freshness:raise ValueError('Artifact freshness differs from its before/after evidence')
        if digest is not None:assert_file(path,digest)
    for sid,p in planned.items():
        used=set(reported[sid]['output_ids'])
        if not used<=set(artifacts) or any(artifacts[i]['stage_id']!=sid for i in used):
            raise ValueError('Stage output IDs reference another stage')
        if actual[sid]['status']=='skipped':
            if used or actual[sid].get('outputs'):
                raise ValueError('A skipped stage cannot claim native output evidence')
            continue
        for value in p.get('expected_outputs',[]):
            path=str(inside(attempt,value))
            if not any(str(inside(attempt,artifacts[i]['path']))==path for i in used):
                raise ValueError('Report omits an expected native output')
        if p.get('log_only',False) and actual[sid]['status']=='succeeded' and not any(
                artifacts[i]['kind']=='native_result_log' and artifacts[i]['freshness'] in {'new','changed'} for i in used):
            raise ValueError('Log-only estimation requires its fresh native result log artifact')
    coverage=_plan_coverage(item,plan)
    complete=bool(all_required and succeeded and not coverage['gapped']
                  and run.get('status')=='completed' and run.get('execution_verified') is True)
    outcome='completed' if complete else 'partial' if succeeded else 'failed' if failed else 'blocked' if run.get('status')=='blocked' else 'not_run'
    if draft['outcome']!=outcome or draft['execution_verified'] is not complete:
        raise ValueError('Overall execution claim differs from full-scope native evidence')


def finalize(attempt,report_path):
    attempt,campaign,_,_,_=_attempt(attempt)
    with locked(campaign):
        attempt,campaign,state,record,item=_attempt(attempt)
        if record['status'] not in {'assigned','preflight_blocked','executed','finalization_failed','finalized'}:
            raise ValueError('Attempt is not ready for report finalization')
        if not record.get('agent'):raise ValueError('Only an assigned fresh-agent attempt can submit')
        if record.get('report'):
            assert_file(record['report']['path'],record['report']['sha256'])
        source=inside(attempt,report_path,file=True)
        if 'baseline_targets' in item['unit'] and read(source).get('outcome') == 'not_run':
            raise ValueError('Preparation is open; complete the attempt or document a terminal blocker')
        number=len(record['report_trials'])+1
        frozen=_ref(source,attempt/'frozen/report_inputs'/f'report_{number:03d}.json')
        trial={'submitted_at':now(),'input':frozen}
        try:
            draft=read(frozen['path']);_validate_report(attempt,item,record,draft)
            if 'baseline_targets' in item['unit'] and draft['outcome'] == 'not_run':
                raise ValueError('Preparation is open; complete the attempt or document a terminal blocker')
            output=inside(attempt,'output/report.json')
            if output.exists():
                history=inside(attempt,Path('output_history')/f'report_{number-1:03d}.json')
                if history.exists():raise ValueError('Report history already exists; refusing to overwrite it')
                history.parent.mkdir(exist_ok=True)
                os.replace(output,history);history.chmod(0o444)
            write(output,draft,exclusive=True);output.chmod(0o444)
            trial.update(valid=True,report={'path':str(output),'sha256':sha(output)})
            record.update(status='finalized',report=trial['report'],outcome=draft['outcome'])
        except Exception as exc:
            trial.update(valid=False,error_type=type(exc).__name__)
            record['report_trials'].append(trial);record['status']='finalization_failed';_save(campaign,state)
            raise
        record['report_trials'].append(trial);_save(campaign,state)
    return {'attempt_id':item['attempt_id'],'status':'finalized','report':record['report'],'outcome':draft['outcome']}


def reconcile_report(attempt,reviewer,reason):
    """Restore an unaccepted report from its pinned valid input, preserving damage."""
    attempt,campaign,_,_,_=_attempt(attempt)
    with locked(campaign):
        attempt,campaign,state,record,item=_attempt(attempt)
        if record['status'] not in {'finalized','finalization_failed'} or not record.get('report') or record.get('review'):
            raise ValueError('Report recovery requires an unaccepted finalized report')
        if not reviewer or reviewer==record['agent'] or not reason.strip():
            raise ValueError('Report recovery requires an independent reviewer and reason')
        reference=record['report'];output=inside(attempt,'output/report.json')
        if Path(reference['path'])!=output:raise ValueError('Unexpected registered report path')
        trials=[t for t in record['report_trials'] if t.get('valid') and t.get('report')==reference]
        if len(trials)!=1:raise ValueError('Registered report needs one pinned valid input')
        frozen=trials[0]['input'];assert_file(frozen['path'],frozen['sha256'])
        draft=read(frozen['path']);_validate_report(attempt,item,record,draft)
        data=(json.dumps(draft,ensure_ascii=False,sort_keys=True,indent=2,allow_nan=False)+'\n').encode('utf-8')
        if hashlib.sha256(data).hexdigest()!=reference['sha256']:
            raise ValueError('Pinned input cannot reproduce the registered report bytes')
        observed=None
        if output.exists():
            plain(output,file=True)
            observed={'sha256':sha(output),'mode':oct(output.stat().st_mode & 0o777)}
        directory=inside(attempt,Path('report_recoveries')/uuid.uuid4().hex);directory.mkdir(parents=True)
        if observed:
            observed['saved']=_ref(output,directory/'observed_report.json')
        canonical=directory/'registered_report.json';write(canonical,draft,exclusive=True);canonical.chmod(0o444)
        assert_file(canonical,reference['sha256'])
        event={'created_at':now(),'reviewer':reviewer,'reason':reason,'status':'prepared',
               'registered_report':dict(reference),'frozen_input':dict(frozen),'observed':observed,
               'canonical_report':{'path':str(canonical),'sha256':sha(canonical)}}
        receipt=directory/'recovery.json';write(receipt,event,exclusive=True)
        temporary=output.with_name('report.recovery.'+uuid.uuid4().hex+'.json')
        try:
            shutil.copy2(canonical,temporary);assert_file(temporary,reference['sha256'])
            os.replace(temporary,output)
        finally:
            if temporary.exists():temporary.unlink()
        event.update(status='restored',restored_at=now());write(receipt,event);receipt.chmod(0o444)
        record.setdefault('report_recoveries',[]).append({'path':str(receipt),'sha256':sha(receipt)})
        _save(campaign,state)
    return {'attempt_id':item['attempt_id'],'status':record['status'],'report':reference,
            'recovery':record['report_recoveries'][-1],'native_execution_repeated':False}


def _publication_files(attempt,record,draft,items):
    """Require an explicit coordinator list; never infer publishable datasets."""
    if not isinstance(items,list):raise ValueError('Publication files must be an explicit review list')
    code={}
    for entry in draft['inputs']:
        if entry['role']=='code' and entry['staged'] is not None:
            p=_file_ref(attempt,entry['staged']);code[str(p)]=entry['staged']['sha256']
    for patch in draft['patches']:
        p=inside(attempt,patch['working_path'],file=True);code[str(p)]=patch['after_sha256']
    for plan_review in record['plan_reviews']:
        for entry in plan_review['code']:
            code[entry['path']]=entry['sha256']
    artifacts={str(inside(attempt,a['path'])):a for a in draft['artifacts']}
    selected=[];seen=set()
    for entry in items:
        if not isinstance(entry,dict) or set(entry)!={'path','sha256','kind'}:
            raise ValueError('A publication file needs only path, sha256 and code/result kind')
        p=_file_ref(attempt,entry)
        if str(p) in seen:raise ValueError('Duplicate publication file')
        seen.add(str(p));kind=entry['kind'];suffix=p.suffix.lower()
        if kind=='code':
            if str(p) not in code or code[str(p)]!=entry['sha256'] or suffix not in PUBLISH_CODE_SUFFIXES:
                raise ValueError('Publish only source-reviewed working or frozen reference code')
        elif kind=='result':
            a=artifacts.get(str(p))
            if (a is None or a['kind'] not in {'result_table','figure'} or a['sha256']!=entry['sha256']
                    or a['freshness'] not in {'new','changed'} or suffix not in PUBLISH_RESULT_SUFFIXES
                    or p.is_relative_to(attempt/'runtime')):
                raise ValueError('Publish only reviewed fresh tables/figures; raw logs and datasets stay in the attempt')
        else:raise ValueError('Publication kind must be code or result')
        selected.append({'path':str(p),'sha256':entry['sha256'],'kind':kind})
    return selected


def baseline_handoff(targets, coverage, draft):
    """Tie independently reviewed numerical coverage to the targets declared before launch."""
    if draft['outcome'] == 'not_run':
        raise ValueError('Preparation is open; complete the attempt or document a terminal blocker')
    if not isinstance(coverage, dict) or coverage.keys() != targets.keys():
        raise ValueError('Review all and only the declared baseline targets')
    passed = {s['stage_id'] for s in draft['stage_results']
              if s['status'] == 'succeeded' and s['log_check'] == 'passed'}
    missing = []
    for target, check in coverage.items():
        if not isinstance(check, dict) or not isinstance(check.get('evidence'), str) or not check['evidence'].strip():
            raise ValueError('Each baseline target needs a review finding')
        if check.get('verified') is True:
            if check.get('stage_id') not in passed:
                raise ValueError('Verified baseline output needs a successful reviewed stage')
        elif check.get('verified') is False:
            missing.append(target)
        else:
            raise ValueError('Each target needs a boolean verified status')
    return {'next_skill': 'reproduce-accounting-models' if missing else None,
            'uncovered_baselines': missing, 'coverage': coverage}


def review(attempt,reviewer,note_path):
    attempt,campaign,_,_,_=_attempt(attempt)
    with locked(campaign):
        attempt,campaign,state,record,item=_attempt(attempt)
        if record['status'] not in {'finalized','accepted'}:raise ValueError('Review requires a finalized report')
        if not reviewer or reviewer==record['agent']:raise ValueError('Review must be independent of the attempt actor')
        assert_file(record['report']['path'],record['report']['sha256'])
        draft=read(record['report']['path']);_validate_report(attempt,item,record,draft)
        note=inside(attempt,note_path,file=True);value=read(note)
        if value.get('source_checked') is not True or value.get('execution_checked') is not True or not value.get('notes'):
            raise ValueError('Review needs explicit source/execution checks and findings')
        if draft['comparison']['status'] not in {'not_assessed','no_reference'} and value.get('comparison_checked') is not True:
            raise ValueError('Numerical agreement needs its own independent review')
        if record['status']=='accepted':
            assert_file(record['review']['path'],record['review']['sha256'])
            return {'attempt_id':item['attempt_id'],'status':'accepted','outcome':record['outcome'],'unchanged':True}
        publish_files=_publication_files(attempt,record,draft,value.get('publish_files',[]))
        if 'baseline_targets' in item['unit']:
            handoff = baseline_handoff(item['unit']['baseline_targets'], value.get('baseline_coverage'), draft)
        frozen=_ref(note,attempt/'output/source_review.json')
        accepted={'reviewed_at':now(),'reviewer':reviewer,'report':record['report'],'source_review':frozen,
                  'outcome':draft['outcome'],'execution_verified':draft['execution_verified'],
                  'publish_files':publish_files}
        if 'baseline_targets' in item['unit']:
            if item['analysis_scope'].get('execution_readiness') == 'preparation_required':
                accepted['handoff'] = handoff
            else:
                accepted['baseline_coverage'] = handoff['coverage']
        path=attempt/'output/review.json';write(path,accepted,exclusive=True);path.chmod(0o444)
        record.update(status='accepted',accepted_at=now(),review={'path':str(path),'sha256':sha(path)})
        _save(campaign,state)
    return {'attempt_id':item['attempt_id'],'status':'accepted','outcome':draft['outcome']}


def _publication_view(publication):
    if publication is None:return None
    value=dict(publication)
    for key in ('path','archive'):
        if value.get(key):value[key]=str(plain(value[key]))
    return value


def status(campaign=BASE):
    campaign,state=resolve(campaign);latest=_latest(state)
    return {'campaign':str(campaign),'units':len(state['units']),'attempts':len(state['attempts']),
            'assigned_attempts':sum(r.get('agent') is not None for r in state['attempts'].values()),
            'limits':state['limits'],'pilot_cases':len(state['pilot_cases']),'full_waves':len(state['full_waves']),
            'attempt_statuses':dict(Counter(r['status'] for r in state['attempts'].values())),
            'latest_full_units':len(latest),'latest_outcomes':dict(Counter(r['outcome'] for r in latest.values())),
            'open_attempts':[{'attempt_id':r['attempt_id'],'agent':r.get('agent'),'status':r['status']}
                             for r in state['attempts'].values() if r['status']!='accepted'],
            'publication':_publication_view(state['publication'])}


def _recover_publication(campaign,state,destination):
    """Complete a previously authorized atomic swap after an interrupted process."""
    path=campaign/'publication_transaction.json'
    if not path.exists():return
    tx=read(path)
    if tx.get('status')=='rolled_back':return
    if plain(tx.get('destination',''))!=destination or tx.get('manifest_sha256')!=state['manifest']['sha256']:
        raise ValueError('Publication transaction identity changed')
    target=tx['publication'];stage=plain(tx['stage'])
    # A registered transaction may predate the directory rename. Its exact
    # recorded stage name is still valid; the tree digest remains mandatory.
    names={destination.name,Path(tx['destination']).name}
    if stage.parent!=destination.parent or not any(stage.name.startswith('.'+name+'.stage.') for name in names):
        raise ValueError('Publication staging path changed')
    archive=inside(campaign,tx['archive']) if tx.get('archive') else None
    if archive is not None and archive.parent!=campaign/'publication_history':
        raise ValueError('Publication archive path changed')
    if destination.exists() and publication_tree_hash(destination)==target['tree_sha256']:
        layout.verify_package_export(destination,'execution',target['aggregate_sha256'],ROOT)
        if state['publication']!=target:
            state['publication']=target;_save(campaign,state)
        if tx.get('status')!='published':
            tx['status']='published';write(path,tx)
        return
    if not stage.exists():
        if not destination.exists() and archive and archive.exists():os.replace(archive,destination)
        prior=state['publication']
        if destination.exists() and (not prior or publication_tree_hash(destination)!=prior['tree_sha256']):
            raise ValueError('Published files changed during an interrupted transaction')
        tx['status']='rolled_back';write(path,tx);return
    if publication_tree_hash(stage)!=target['tree_sha256']:raise ValueError('Interrupted publication staging files changed')
    if destination.exists():
        prior=state['publication']
        if not prior or publication_tree_hash(destination)!=prior['tree_sha256'] or archive is None or archive.exists():
            raise ValueError('Interrupted publication cannot replace unverified prior files')
        archive.parent.mkdir(exist_ok=True);os.replace(destination,archive)
    elif state['publication'] and (archive is None or not archive.exists() or publication_tree_hash(archive)!=state['publication']['tree_sha256']):
        raise ValueError('Interrupted publication is missing its verified prior archive')
    os.replace(stage,destination);state['publication']=target;_save(campaign,state)
    tx['status']='published';write(path,tx)


def publish(campaign=BASE):
    campaign,state=resolve(campaign)
    with locked(campaign):
        campaign,state=resolve(campaign)
        destination=plain(campaign/'publication')
        _recover_publication(campaign,state,destination)
        latest=_latest(state)
        if set(latest)!=set(state['units']):raise ValueError('Publication needs an accepted full result for every selected scope')
        if any(r['status']!='accepted' for r in state['attempts'].values() if r.get('agent') or r['phase']=='full'):
            raise ValueError('Finish every assigned attempt before publication')
        desired={pid:r['attempt_id'] for pid,r in latest.items()}
        if state['publication'] and state['publication'].get('latest_attempts')==desired:
            layout.verify_package_export(destination,'execution',state['publication']['aggregate_sha256'],ROOT)
            if publication_tree_hash(destination)!=state['publication']['tree_sha256']:raise ValueError('Published files changed')
            if not (destination / 'attempts.jsonl').is_file():
                layout.ensure_export('execution',ROOT)
            return _publication_view(state['publication'])
        rows=[];index={}
        for pid in state['units']:
            record=latest[pid];attempt=Path(record['directory'])
            _,_,_,_,item=_attempt(attempt)
            assert_file(record['report']['path'],record['report']['sha256'])
            assert_file(record['review']['path'],record['review']['sha256'])
            draft=read(record['report']['path']);_validate_report(attempt,item,record,draft)
            accepted=read(record['review']['path'])
            publish_files=_publication_files(attempt,record,draft,accepted.get('publish_files',[]))
            rows.append(draft);index[pid]={'attempt_id':record['attempt_id'],'attempt_directory':str(attempt),
                'report_path':f'packages/{pid}/report.json','report_sha256':record['report']['sha256'],
                'review_path':f'packages/{pid}/review.json','review_sha256':record['review']['sha256'],
                'files':[dict(entry,published_path=f'packages/{pid}/{entry["kind"]}/{n:03d}_{Path(entry["path"]).name}')
                         for n,entry in enumerate(publish_files,1)]}
        destination.parent.mkdir(parents=True,exist_ok=True)
        if destination.exists():
            if not state['publication']:raise ValueError('Unregistered output publication exists')
            layout.verify_package_export(destination,'execution',state['publication']['aggregate_sha256'],ROOT)
            if publication_tree_hash(destination)!=state['publication']['tree_sha256']:raise ValueError('Published files changed')
        stage=destination.parent/('.'+destination.name+'.stage.'+uuid.uuid4().hex)
        archive=None
        try:
            (stage/'packages').mkdir(parents=True)
            for pid,record in latest.items():
                out=stage/'packages'/pid;out.mkdir()
                for name,key in [('report.json','report'),('review.json','review')]:
                    shutil.copy2(record[key]['path'],out/name);assert_file(out/name,record[key]['sha256'])
                for entry in index[pid]['files']:
                    target=stage/entry['published_path'];target.parent.mkdir(exist_ok=True)
                    shutil.copy2(entry['path'],target);assert_file(target,entry['sha256'])
            aggregate=stage/'attempts.jsonl'
            aggregate.write_text(''.join(json.dumps(r,ensure_ascii=False,allow_nan=False)+'\n' for r in rows))
            aggregate_sha=sha(aggregate)
            publication_index={'campaign':str(campaign),'aggregate_sha256':aggregate_sha,'packages':index}
            write(stage/'index.json',publication_index)
            reports = stage if state['fixture'] else layout.batch_reports('execution',ROOT)/sha(stage/'index.json')
            write(reports/'manifest.json',{'manifest':state['manifest'],'limits':state['limits'],
                                       'assignment_configuration':CONFIG,'attempts':len(state['attempts']),
                                       'data_and_raw_logs':'Retained in the local run directory.'})
            summary=status(campaign)
            summary['publication']={'path':str(destination),'index_sha256':sha(stage/'index.json'),
                                    'aggregate_sha256':aggregate_sha,'state':'this_publication'}
            write(reports/'summary.json',summary)
            def paper_label(value):
                return str(value).replace('\\','\\\\').replace('|','\\|').replace('[','\\[').replace(']','\\]').replace('\n',' ')
            package_dir = 'packages' if reports == stage else os.path.relpath(destination/'packages',reports)
            paper_rows=''.join(f'| [{paper_label(r.get("title") or r["package_id"])}]({package_dir}/{r["package_id"]}/report.json) | '
                               f'{r["outcome"]} | {r["comparison"]["status"]} |\n' for r in rows)
            (reports/'summary.md').write_text('# Author analysis execution\n\n'+
                f'{len(rows)} selected scopes; {summary["assigned_attempts"]} fresh-agent assignments.\n\n'+
                '\n'.join(f'- {key}: {value}' for key,value in sorted(Counter(r['outcome'] for r in rows).items()))+
                '\n\nExecution completion and numerical agreement are reported separately. Raw working data/logs remain in the attempt directories.\n\n'+
                '| Paper | Execution | Comparison |\n| --- | --- | --- |\n'+paper_rows)
            if destination.exists():
                archive=campaign/'publication_history'/(datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'))
                archive.parent.mkdir(exist_ok=True)
            publication={'path':str(destination),'published_at':now(),'packages':len(rows),
                         'aggregate_sha256':aggregate_sha,'tree_sha256':publication_tree_hash(stage),
                         'latest_attempts':desired,'last_full_wave':max(r['case'] for r in latest.values()),
                         'archive':str(archive) if archive else None}
            transaction={'created_at':now(),'status':'prepared','stage':str(stage),'destination':str(destination),
                         'archive':str(archive) if archive else None,'latest_attempts':desired,
                         'manifest_sha256':state['manifest']['sha256'],'publication':publication}
            write(campaign/'publication_transaction.json',transaction)
            if archive:
                os.replace(destination,archive)
                transaction['status']='prior_archived';write(campaign/'publication_transaction.json',transaction)
            try:os.replace(stage,destination)
            except Exception:
                if archive and archive.exists() and not destination.exists():os.replace(archive,destination)
                transaction['status']='rolled_back';write(campaign/'publication_transaction.json',transaction)
                raise
            transaction['status']='published';write(campaign/'publication_transaction.json',transaction)
        finally:
            if stage.exists():shutil.rmtree(stage)
        state['publication']=publication
        _save(campaign,state)
    return _publication_view(state['publication'])


def promote(campaign, package_id, recipe):
    """Install the latest accepted full attempt for a single paper."""
    from scripts import promote_author_execution, rebuild_indexes
    campaign, _ = resolve(campaign)
    with locked(campaign):
        _, state = resolve(campaign)
        record = _latest(state).get(package_id)
        if record is None:
            raise ValueError('No accepted full attempt for this package')
        attempt, _, _, record, item = _attempt(record['directory'])
        for key in ('report', 'review'):
            assert_file(record[key]['path'], record[key]['sha256'])
        report, review = (read(record[k]['path']) for k in ('report', 'review'))
        _validate_report(attempt, item, record, report)
        selected = _publication_files(attempt, record, report, review['publish_files'])
        destination = promote_author_execution.install(ROOT, attempt, record, report, review, selected, recipe)
        rebuild_indexes.rebuild(ROOT)
    return {'package_id':package_id, 'attempt_id':record['attempt_id'], 'path':destination.relative_to(ROOT).as_posix()}


def main():
    parser=argparse.ArgumentParser(description=__doc__);sub=parser.add_subparsers(dest='command',required=True)
    p=sub.add_parser('init-paper');p.add_argument('--item',required=True);p.add_argument('--assessment',required=True);p.add_argument('--baseline-targets',help='JSON object mapping each required baseline ID to the expected numerical output')
    p=sub.add_parser('init');p.add_argument('--manifest',default=str(DEFAULT_MANIFEST));p.add_argument('--campaign',default=str(BASE));p.add_argument('--fixture',action='store_true')
    p=sub.add_parser('prepare');p.add_argument('--campaign',default=str(BASE));p.add_argument('--package-id',required=True);p.add_argument('--phase',choices=['pilot','full'],required=True);p.add_argument('--case',type=int,required=True);p.add_argument('--policy')
    p=sub.add_parser('assign');p.add_argument('--attempt',required=True);p.add_argument('--agent',required=True)
    for key in ('model','reasoning-effort','fork-turns'):p.add_argument('--'+key,required=True)
    p=sub.add_parser('stage');p.add_argument('--attempt',required=True);p.add_argument('--paths',nargs='+',required=True)
    p=sub.add_parser('approve-plan');p.add_argument('--attempt',required=True);p.add_argument('--plan',required=True);p.add_argument('--reviewer',required=True);p.add_argument('--source-reviewed',action='store_true',required=True)
    p=sub.add_parser('execute');p.add_argument('--attempt',required=True);p.add_argument('--plan')
    p=sub.add_parser('reconcile');p.add_argument('--attempt',required=True)
    p=sub.add_parser('reconcile-report');p.add_argument('--attempt',required=True);p.add_argument('--reviewer',required=True);p.add_argument('--reason',required=True)
    p=sub.add_parser('finalize');p.add_argument('--attempt',required=True);p.add_argument('--report',required=True)
    p=sub.add_parser('review');p.add_argument('--attempt',required=True);p.add_argument('--reviewer',required=True);p.add_argument('--note',required=True)
    p=sub.add_parser('promote');p.add_argument('--campaign',default=str(BASE));p.add_argument('--package-id',required=True);p.add_argument('--recipe',required=True)
    for command in ('status','publish'):
        p=sub.add_parser(command);p.add_argument('--campaign',default=str(BASE))
    a=parser.parse_args()
    if a.command=='init-paper':result=initialize_paper(a.item,a.assessment,a.baseline_targets)
    elif a.command=='init':result=initialize(a.manifest,a.campaign,fixture=a.fixture)
    elif a.command=='prepare':result=prepare(a.package_id,a.phase,a.case,campaign=a.campaign,policy_path=a.policy)
    elif a.command=='assign':result=assign(a.attempt,a.agent,model=a.model,reasoning_effort=a.reasoning_effort,fork_turns=a.fork_turns)
    elif a.command=='stage':result=stage(a.attempt,a.paths)
    elif a.command=='approve-plan':result=approve_plan(a.attempt,a.plan,a.reviewer,source_reviewed=a.source_reviewed)
    elif a.command=='execute':result=execute(a.attempt,a.plan)
    elif a.command=='reconcile':result=reconcile(a.attempt)
    elif a.command=='reconcile-report':result=reconcile_report(a.attempt,a.reviewer,a.reason)
    elif a.command=='finalize':result=finalize(a.attempt,a.report)
    elif a.command=='review':result=review(a.attempt,a.reviewer,a.note)
    elif a.command=='promote':result=promote(a.campaign,a.package_id,a.recipe)
    elif a.command=='status':result=status(a.campaign)
    else:result=publish(a.campaign)
    print(json.dumps(result,ensure_ascii=False))


if __name__=='__main__':
    try:main()
    except (ValueError,OSError,KeyError) as exc:
        print(f'Error: {exc}',file=sys.stderr);raise SystemExit(2)
