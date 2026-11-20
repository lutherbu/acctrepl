"""Only trusted synthetic programs run here; no author paper or native runtime."""
import copy
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import signal
import sys
import time

import pytest

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('author_analysis_runner_tests',ROOT/'skills/execute-author-analysis/scripts/runner.py')
r=importlib.util.module_from_spec(spec);spec.loader.exec_module(r)


def digest(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path,value):
    path.parent.mkdir(parents=True,exist_ok=True)
    path.write_text(json.dumps(value,indent=2)+'\n')


@pytest.fixture
def case(tmp_path,monkeypatch):
    attempt=tmp_path/'attempt';(attempt/'work').mkdir(parents=True)
    script=attempt/'work/analysis.R'
    script.write_text("from pathlib import Path\nPath('table.txt').write_text('fictional results')\n")
    # These executable markers identify distinct approved paths. Only the synthetic
    # Python backend below launches a process in these tests.
    tools = {}
    for name in ('bwrap', 'Rscript', 'stata'):
        executable = tmp_path / name
        executable.touch(mode=0o700)
        tools[name] = str(executable)
    monkeypatch.setattr(r, 'BWRAP', tools['bwrap'])
    plan={'schema_version':'1.0','attempt_id':'fixture-attempt-01',
          'sandbox':{'profile':'bwrap','executable':r.BWRAP,'read_only_paths':[]},
          'limits':{'wall_seconds':10,'memory_bytes':512*1024**2,'threads':2},'inputs':[],
          'stages':[{'id':'analysis','language':'r','executable':tools['Rscript'],
                     'script':'work/analysis.R','script_sha256':digest(script),'cwd':'work',
                     'args':[],'depends_on':[],'expected_outputs':['work/table.txt'],
                     'native_logs':[],'source_entry_points':['author analysis.R']}]}
    path=attempt/'frozen/plan.json';save(path,plan)
    policy_path=attempt/'frozen/runtime_policy.json'
    save(policy_path,{'schema_version':'1.0','sandbox_profile':'bwrap','allowed_read_only_roots':[],
                     'runtime_paths':{'stata':[tools['stata']],'r':[tools['Rscript']],'matlab':[]},
                     'limits':plan['limits'],'stata_ado_paths':[]})
    save(attempt/'work_item.json',{'runtime_policy':{'path':str(policy_path),'sha256':digest(policy_path)}})
    def fixture_sandbox(attempt,plan,argv,readonly,**kwargs):
        # A test-local replacement runs ONLY the saved fictional Python fixture.
        if argv==[r.SANDBOX_PROBE]:return [sys.executable,'-I','-c','pass']
        if argv[0]==tools['Rscript']:return [sys.executable,'-I',argv[2],*argv[3:]]
        return argv
    monkeypatch.setattr(r,'sandbox_command',fixture_sandbox)
    return {'attempt':attempt,'script':script,'plan':plan,'path':path,'sandbox':fixture_sandbox,'policy':policy_path,'stata':tools['stata']}


def update(case,code=None):
    if code is not None:
        case['script'].write_text(code)
        case['plan']['stages'][0]['script_sha256']=digest(case['script'])
    save(case['path'],case['plan'])


def test_complete_fixture_records_native_command_streams_fresh_outputs(case):
    report=r.run(case['attempt'],case['path'])
    assert report['status']=='completed' and report['execution_verified']
    stage=report['stages'][0]
    assert stage['status']=='succeeded' and stage['returncode']==0 and not stage['timeout']
    assert stage['outputs'][0]['fresh'] and stage['outputs'][0]['after_sha256']==digest(case['attempt']/'work/table.txt')
    assert stage['source_entry_points']==['author analysis.R']
    assert stage['process']['pid']>0
    for name in ('stdout','stderr'):assert digest(stage[name]['path'])==stage[name]['sha256']
    assert digest(report['intent']['path'])==report['intent']['sha256']


def test_second_scientific_launch_refused_even_after_failure(case):
    update(case,"raise SystemExit(7)\n")
    first=r.run(case['attempt'],case['path']);original=(case['attempt']/'runtime/run.json').read_bytes()
    assert first['status']=='failed' and first['stages'][0]['returncode']==7
    with pytest.raises(ValueError,match='already launched'):r.run(case['attempt'],case['path'])
    assert (case['attempt']/'runtime/run.json').read_bytes()==original


def test_stale_reference_output_cannot_satisfy_run(case):
    output=case['attempt']/'work/table.txt';output.write_text('old author reference')
    old=output.read_bytes();update(case,'pass\n')
    report=r.run(case['attempt'],case['path'])
    assert report['status']=='failed' and not report['stages'][0]['outputs'][0]['fresh']
    old_record=report['stages'][0]['preexisting_artifacts'][0]
    assert Path(old_record['path']).read_bytes()==old
    assert not output.exists()


def test_rewritten_identical_bytes_are_fresh_after_quarantine(case):
    output=case['attempt']/'work/table.txt';output.write_text('fictional results')
    report=r.run(case['attempt'],case['path'])
    item=report['stages'][0]['outputs'][0]
    assert item['before_sha256']==item['after_sha256'] and item['fresh']
    assert report['execution_verified']


def test_preflight_failure_never_starts_study_and_history_is_preserved(case,monkeypatch):
    def unavailable(*args,**kwargs):return [sys.executable,'-I','-c','raise SystemExit(3)']
    monkeypatch.setattr(r,'sandbox_command',unavailable)
    first=r.run(case['attempt'],case['path'])
    old=(case['attempt']/'runtime/run.json').read_bytes()
    assert first['status']=='blocked' and first['reason']=='sandbox_setup_unavailable'
    assert first['sandbox']['filesystem_isolation'] is False
    assert first['sandbox']['network_isolation'] is False
    assert not (case['attempt']/'runtime/intent.json').exists()
    assert not (case['attempt']/'work/table.txt').exists()
    monkeypatch.setattr(r,'sandbox_command',case['sandbox'])
    second=r.run(case['attempt'],case['path'])
    assert second['status']=='completed'
    copies=list((case['attempt']/'runtime/preflight_history').glob('*.json'))
    assert len(copies)==1 and copies[0].read_bytes()==old


def test_changed_script_refused_before_any_launch(case):
    case['script'].write_text('print("changed")\n')
    with pytest.raises(ValueError,match='script'):r.run(case['attempt'],case['path'])
    assert not (case['attempt']/'runtime/intent.json').exists()


def test_changed_immutable_input_refused(case):
    p=case['attempt']/'inputs/data.txt';p.parent.mkdir();p.write_text('old')
    case['plan']['inputs']=[{'path':'inputs/data.txt','sha256':digest(p)}];update(case)
    p.write_text('changed')
    with pytest.raises(ValueError,match='input changed'):r.run(case['attempt'],case['path'])


def test_fixture_input_mutation_invalidates_result(case):
    p=case['attempt']/'inputs/data.txt';p.parent.mkdir();p.write_text('old')
    case['plan']['inputs']=[{'path':'inputs/data.txt','sha256':digest(p)}]
    # Production bwrap makes this file readonly; this intentionally bad test
    # backend demonstrates that a mutation also fails the post-run guard.
    update(case,"from pathlib import Path\nPath('../inputs/data.txt').write_text('changed')\nPath('table.txt').write_text('fixture')\n")
    report=r.run(case['attempt'],case['path'])
    assert not report['original_inputs_unchanged'] and not report['execution_verified']
    assert report['status']=='failed'


@pytest.mark.parametrize('field,value',[('script','../outside.R'),('cwd','../outside'),('expected_outputs',['../outside.txt'])])
def test_stage_path_escape_refused(case,field,value):
    case['plan']['stages'][0][field]=value;update(case)
    with pytest.raises(ValueError):r.run(case['attempt'],case['path'])


def test_source_symlink_and_hardlink_refused(case,tmp_path):
    real=tmp_path/'real.R';real.write_bytes(case['script'].read_bytes())
    case['script'].unlink();case['script'].symlink_to(real)
    with pytest.raises(ValueError,match='symlink'):r.run(case['attempt'],case['path'])
    case['script'].unlink();os.link(real,case['script'])
    with pytest.raises(ValueError,match='hardlinked'):r.run(case['attempt'],case['path'])


def test_writable_home_symlink_refused(case,tmp_path):
    external=tmp_path/'private';external.mkdir();(case['attempt']/'home').symlink_to(external)
    with pytest.raises(ValueError,match='symlink'):r.run(case['attempt'],case['path'])


def test_plan_cannot_replace_trusted_sandbox_with_another_executable(case):
    case['plan']['sandbox']['executable'] = case['stata']
    update(case)
    with pytest.raises(ValueError, match='Trusted bubblewrap'):
        r.run(case['attempt'], case['path'])
    assert not (case['attempt']/'runtime/intent.json').exists()


def test_runtime_cannot_be_arbitrary_shell(case):
    case['plan']['stages'][0]['executable']='/bin/sh';update(case)
    with pytest.raises(ValueError,match='native language'):r.run(case['attempt'],case['path'])


@pytest.mark.parametrize('replacement',[{'profile':'none'},{'profile':'bwrap','read_only_paths':['/']}])
def test_no_unsandboxed_or_host_root_mount_fallback(case,replacement):
    case['plan']['sandbox']=replacement;update(case)
    with pytest.raises(ValueError):r.run(case['attempt'],case['path'])


def test_declared_output_cannot_replace_input(case):
    p=case['attempt']/'work/table.txt';p.write_text('input')
    case['plan']['inputs']=[{'path':'work/table.txt','sha256':digest(p)}];update(case)
    with pytest.raises(ValueError,match='immutable'):r.run(case['attempt'],case['path'])


def test_failed_parent_skips_dependent_but_runs_predeclared_independent(case):
    update(case,'raise SystemExit(2)\n')
    for sid,deps in [('dependent',['analysis']),('independent',[])]:
        p=case['attempt']/f'work/{sid}.R';p.write_text(f"from pathlib import Path\nPath('{sid}.txt').write_text('fixture')\n")
        stage=copy.deepcopy(case['plan']['stages'][0]);stage.update(id=sid,script=f'work/{sid}.R',
            script_sha256=digest(p),depends_on=deps,expected_outputs=[f'work/{sid}.txt'])
        case['plan']['stages'].append(stage)
    update(case);report=r.run(case['attempt'],case['path'])
    assert [x['status'] for x in report['stages']]==['failed','skipped','succeeded']
    assert report['status']=='partial' and not report['execution_verified']
    assert not (case['attempt']/'work/dependent.txt').exists()


def test_unknown_or_forward_dependency_refused(case):
    case['plan']['stages'][0]['depends_on']=['future'];update(case)
    with pytest.raises(ValueError,match='dependency order'):r.run(case['attempt'],case['path'])


def test_timeout_kills_process_group_and_preserves_streams(case,monkeypatch):
    case['plan']['limits']['wall_seconds']=1
    update(case,"import subprocess,sys,time\nsubprocess.Popen([sys.executable,'-c',\"import time;from pathlib import Path;time.sleep(2);Path('escaped-child.txt').write_text('bad')\"])\nprint('before timeout',flush=True)\ntime.sleep(20)\n")
    signals=[];original=r.os.killpg
    def checked(pid,sig):signals.append((pid,sig));return original(pid,sig)
    monkeypatch.setattr(r.os,'killpg',checked)
    report=r.run(case['attempt'],case['path']);stage=report['stages'][0]
    assert stage['timeout'] and report['status']=='failed'
    assert (stage['process']['process_group'],signal.SIGTERM) in signals
    assert b'before timeout' in Path(stage['stdout']['path']).read_bytes()
    time.sleep(1.2)
    assert not (case['attempt']/'work/escaped-child.txt').exists()


def test_r_native_error_with_zero_host_exit_is_failure(case):
    update(case,"from pathlib import Path\nimport sys\nPath('table.txt').write_text('partial')\nprint('Error in model : fictional failure',file=sys.stderr)\n")
    report=r.run(case['attempt'],case['path'])
    assert report['stages'][0]['returncode']==0
    assert report['stages'][0]['native_error_detected'] and report['status']=='failed'


def test_stata_marker_failure_detected_without_stata_execution(case,monkeypatch):
    case['plan']['stages'][0].update(language='stata',executable=case['stata'],native_logs=['work/native.log'])
    update(case,"from pathlib import Path\nPath('table.txt').write_text('partial')\nPath('native.log').write_text('r(198);\\n__AUTHOR_ANALYSIS_RC__ 198\\n')\n")
    monkeypatch.setattr(r,'_native_command',lambda stage,attempt,folder,limits:([sys.executable,'-I',str(stage['_script'])],None,None))
    report=r.run(case['attempt'],case['path'])
    assert report['stages'][0]['stata_completion_code']==198
    assert report['stages'][0]['returncode']==0 and report['status']=='failed'


def test_stata_caught_error_is_recorded_without_overriding_success_marker(case,monkeypatch):
    case['plan']['stages'][0].update(language='stata',executable=case['stata'],native_logs=['work/native.log'])
    update(case,"from pathlib import Path\nPath('table.txt').write_text('complete fixture')\nPath('native.log').write_text('r(111);\\n__AUTHOR_ANALYSIS_RC__ 0\\n')\n")
    monkeypatch.setattr(r,'_native_command',lambda stage,attempt,folder,limits:([sys.executable,'-I',str(stage['_script'])],None,None))
    report=r.run(case['attempt'],case['path'])
    assert report['stages'][0]['stata_reported_error_codes']==[111]
    assert report['status']=='completed'


def test_diagnostic_candidate_window_is_withheld(case):
    update(case,"from pathlib import Path\nimport sys\nPath('table.txt').write_text('fixture')\nprint('password = FICTIONAL_TEST_VALUE',file=sys.stderr)\nprint('continuation value',file=sys.stderr)\n")
    report=r.run(case['attempt'],case['path'])
    assert 'FICTIONAL_TEST_VALUE' not in json.dumps(report)
    assert 'continuation value' not in report['stages'][0]['diagnostic_view']
    assert b'FICTIONAL_TEST_VALUE' in Path(report['stages'][0]['stderr']['path']).read_bytes()


def test_output_symlink_is_not_followed_into_host_file(case,tmp_path):
    external=tmp_path/'outside.txt';external.write_text('FICTIONAL_PRIVATE')
    update(case,f"from pathlib import Path\nPath('table.txt').symlink_to({str(external)!r})\n")
    report=r.run(case['attempt'],case['path'])
    assert report['status']=='failed' and 'FICTIONAL_PRIVATE' not in json.dumps(report)
    assert external.read_text()=='FICTIONAL_PRIVATE'


def test_native_log_symlink_is_not_followed(case,tmp_path):
    external=tmp_path/'outside.txt';external.write_text('FICTIONAL_PRIVATE')
    case['plan']['stages'][0]['native_logs']=['work/native.log']
    update(case,f"from pathlib import Path\nPath('table.txt').write_text('fixture')\nPath('native.log').symlink_to({str(external)!r})\n")
    report=r.run(case['attempt'],case['path'])
    assert report['status']=='failed' and not report['stages'][0]['native_logs']


def test_minimal_sandbox_builder_keeps_host_home_storage_unmounted(tmp_path):
    attempt=tmp_path/'attempt';attempt.mkdir()
    for name in r.WRITABLE_DIRS:(attempt/name).mkdir()
    data=tmp_path/'package';data.mkdir()
    immutable=attempt/'work/data.txt';immutable.write_text('fixture')
    plan={'sandbox':{'profile':'bwrap','executable':r.BWRAP},'limits':{'threads':2}}
    argv=r.sandbox_command(attempt,plan,[r.SANDBOX_PROBE],[data,immutable])
    assert '--unshare-net' in argv and '--unshare-pid' in argv and '--clearenv' in argv
    mounts=[tuple(argv[i+1:i+3]) for i,x in enumerate(argv) if x=='--ro-bind']
    assert ('/','/') not in mounts and ('/home','/home') not in mounts and ('/storage','/storage') not in mounts
    assert (str(data),str(data)) in mounts and (str(immutable),str(immutable)) in mounts
    write_index=max(i for i,x in enumerate(argv) if x=='--bind')
    immutable_index=next(i for i,x in enumerate(argv) if x=='--ro-bind' and argv[i+1]==str(immutable))
    assert immutable_index>write_index
    assert argv[argv.index('--chdir')+1]==str(attempt/'work')


def test_native_tempdir_is_short_private_sandbox_tmpfs(tmp_path):
    attempt=tmp_path/'long-attempt-path-to-exercise-native-unix-socket-limits';attempt.mkdir()
    for name in r.WRITABLE_DIRS:(attempt/name).mkdir()
    plan={'sandbox':{'profile':'bwrap','executable':r.BWRAP},'limits':{'threads':2}}
    argv=r.sandbox_command(attempt,plan,[r.SANDBOX_PROBE],[])
    assert any(argv[i:i+2]==['--tmpfs','/tmp'] for i in range(len(argv)-1))
    environment={argv[i+1]:argv[i+2] for i,item in enumerate(argv) if item=='--setenv'}
    assert environment['TMPDIR']=='/tmp'
    assert ('/tmp','/tmp') not in [tuple(argv[i+1:i+3]) for i,item in enumerate(argv) if item=='--bind']


def test_bad_environment_injection_refused(case):
    case['plan']['environment']={'LD_PRELOAD':'/tmp/not-permitted.so'};update(case)
    with pytest.raises(ValueError,match='environment'):r.run(case['attempt'],case['path'])


def test_status_is_metadata_only_and_unrun_is_explicit(case):
    assert r.status(case['attempt'])=={'status':'not_run','launch_reserved':False}
    r.run(case['attempt'],case['path'])
    value=r.status(case['attempt'])
    assert value['status']=='completed' and 'stages' not in value


def test_trusted_stata_launcher_preserves_author_script_and_checks_completion(case):
    case['plan']['stages'][0].update(language='stata',executable=case['stata'])
    update(case);validated=r.validate_plan(case['attempt'],case['path'])
    folder=case['attempt']/'runtime/stages/analysis';folder.mkdir(parents=True)
    before=case['script'].read_bytes()
    argv,log,record=r._native_command(validated[3][0],case['attempt'],folder,validated[-1])
    text=Path(record['path']).read_text()
    assert '__AUTHOR_ANALYSIS_RC__' in text and 'capture noisily do' in text
    assert log==case['attempt']/'work/analysis__author_analysis.log'
    assert argv[1:3]==['-b','do'] and case['script'].read_bytes()==before


def test_stata_macro_in_argument_refused(case):
    case['plan']['stages'][0].update(language='stata',executable=case['stata'],args=['$danger'])
    update(case)
    with pytest.raises(ValueError,match='quoting or macros'):r.validate_plan(case['attempt'],case['path'])


def test_changed_frozen_runtime_policy_is_refused(case):
    case['policy'].write_text('{}')
    with pytest.raises(ValueError,match='policy changed'):r.run(case['attempt'],case['path'])


def test_plan_cannot_self_authorize_external_readonly_root(case,tmp_path):
    external=tmp_path/'other-package';external.mkdir()
    case['plan']['sandbox']['read_only_paths']=[str(external)];update(case)
    with pytest.raises(ValueError,match='outside the frozen'):r.run(case['attempt'],case['path'])


def test_plan_cannot_raise_resource_limits_above_frozen_policy(case):
    case['plan']['limits']['wall_seconds']=11;update(case)
    with pytest.raises(ValueError,match='exceeds the frozen'):r.run(case['attempt'],case['path'])


def test_incomplete_scope_stays_partial_even_if_declared_stages_succeed(case):
    case['plan']['scope_gaps']=[{'source_entry_points':['other-author-analysis.do'],'reason':'required runtime unavailable'}];update(case)
    report=r.run(case['attempt'],case['path'])
    assert report['declared_stages_verified'] and not report['execution_verified']
    assert report['status']=='partial'


def test_no_required_study_stage_refused(case):
    case['plan']['stages'][0]['required']=False;update(case)
    with pytest.raises(ValueError,match='required native'):r.run(case['attempt'],case['path'])


def test_stata_ado_paths_require_mount_and_launcher_uses_frozen_order(case,tmp_path):
    library=tmp_path/'ado';library.mkdir()
    policy=json.loads(case['policy'].read_text());policy['allowed_read_only_roots']=[str(library)];policy['stata_ado_paths']=[str(library)]
    save(case['policy'],policy)
    save(case['attempt']/'work_item.json',{'runtime_policy':{'path':str(case['policy']),'sha256':digest(case['policy'])}})
    case['plan']['stages'][0].update(language='stata',executable=case['stata']);update(case)
    with pytest.raises(ValueError,match='ado path'):r.validate_plan(case['attempt'],case['path'])
    case['plan']['sandbox']['read_only_paths']=[str(library)];update(case)
    validated=r.validate_plan(case['attempt'],case['path'])
    folder=case['attempt']/'runtime/stages/analysis';folder.mkdir(parents=True)
    _,_,record=r._native_command(validated[3][0],case['attempt'],folder,validated[-1])
    assert f'adopath ++ "{library}"' in Path(record['path']).read_text()


def test_unfrozen_plan_path_refused(case):
    other=case['attempt']/'work/mutable-plan.json';save(other,case['plan'])
    with pytest.raises(ValueError,match='frozen/'):r.run(case['attempt'],other)


def test_missing_policy_record_never_falls_back(case):
    save(case['attempt']/'work_item.json',{})
    with pytest.raises(ValueError,match='runtime policy'):r.run(case['attempt'],case['path'])


def test_library_environment_cannot_expose_unmounted_home(case,tmp_path):
    foreign=tmp_path/'outside-library';foreign.mkdir()
    case['plan']['environment']={'R_LIBS_USER':str(foreign)};update(case)
    with pytest.raises(ValueError,match='outside the reviewed'):r.run(case['attempt'],case['path'])


def test_missing_input_after_native_fixture_is_failed_not_unfinished(case):
    p=case['attempt']/'inputs/data.txt';p.parent.mkdir();p.write_text('old')
    case['plan']['inputs']=[{'path':'inputs/data.txt','sha256':digest(p)}]
    update(case,"from pathlib import Path\nPath('../inputs/data.txt').unlink()\nPath('table.txt').write_text('fixture')\n")
    report=r.run(case['attempt'],case['path'])
    assert report['status']=='failed' and not report['original_inputs_unchanged']
    assert r.status(case['attempt'])['status']=='failed'


def test_bad_scope_gap_metadata_refused_before_launch(case):
    case['plan']['scope_gaps']=[{'reason':'ambiguous','source_entry_points':'not-a-list'}];update(case)
    with pytest.raises(ValueError,match='Scope gaps'):r.run(case['attempt'],case['path'])


def configure_log_only(case,code):
    case['plan']['stages'][0].update(log_only=True,expected_outputs=[],
        success_markers=['Number of obs = 123','R-squared = 0.456'])
    update(case,code)


def test_log_only_actual_result_stdout_is_fresh_output(case):
    configure_log_only(case,"print('Number of obs = 123')\nprint('R-squared = 0.456')\n")
    report=r.run(case['attempt'],case['path']);stage=report['stages'][0]
    assert report['execution_verified'] and stage['log_only_verified']
    assert stage['outputs'][0]['kind']=='native_result_log' and stage['outputs'][0]['fresh']
    assert stage['outputs'][0]['path']==stage['stdout']['path']


def test_log_only_missing_result_marker_cannot_pass(case):
    configure_log_only(case,"print('Number of obs = 123')\n")
    report=r.run(case['attempt'],case['path']);stage=report['stages'][0]
    assert report['status']=='failed' and not stage['log_only_verified']
    assert stage['result_log_markers']['missing']==['R-squared = 0.456']


@pytest.mark.parametrize('markers',[['Stata','copyright'],['Number of obs = 123'],
    ['Number of obs = 123','number of obs = 123'],['__AUTHOR_ANALYSIS_RC__ 0','Number of obs = 123']])
def test_startup_or_control_text_cannot_be_log_only_results(case,markers):
    configure_log_only(case,'pass\n');case['plan']['stages'][0]['success_markers']=markers;update(case)
    with pytest.raises(ValueError):r.run(case['attempt'],case['path'])
    assert not (case['attempt']/'runtime/intent.json').exists()


def test_stata_command_echo_is_not_a_result_marker(case,monkeypatch):
    configure_log_only(case,"from pathlib import Path\nPath('native.log').write_text('. display Number of obs = 123\\n. display R-squared = 0.456\\n__AUTHOR_ANALYSIS_RC__ 0\\n')\n")
    case['plan']['stages'][0].update(language='stata',executable=case['stata'],native_logs=['work/native.log']);update(case)
    monkeypatch.setattr(r,'_native_command',lambda stage,attempt,folder,limits:([sys.executable,'-I',str(stage['_script'])],None,None))
    report=r.run(case['attempt'],case['path']);stage=report['stages'][0]
    assert report['status']=='failed' and not stage['log_only_verified']
    assert stage['result_log_markers']['matched']==[]


def test_stata_fresh_estimation_log_can_be_sole_result(case,monkeypatch):
    configure_log_only(case,"from pathlib import Path\nPath('native.log').write_text('Number of obs = 123\\nR-squared = 0.456\\n__AUTHOR_ANALYSIS_RC__ 0\\n')\n")
    case['plan']['stages'][0].update(language='stata',executable=case['stata'],native_logs=['work/native.log']);update(case)
    monkeypatch.setattr(r,'_native_command',lambda stage,attempt,folder,limits:([sys.executable,'-I',str(stage['_script'])],None,None))
    report=r.run(case['attempt'],case['path']);stage=report['stages'][0]
    assert report['execution_verified'] and stage['log_only_verified']
    assert stage['outputs'][0]['kind']=='native_result_log'
    assert Path(stage['outputs'][0]['path']).parent==case['attempt']/'runtime/stages/analysis'


def test_log_only_native_error_still_fails(case):
    configure_log_only(case,"import sys\nprint('Number of obs = 123')\nprint('R-squared = 0.456')\nprint('Error in analysis : fictional failure',file=sys.stderr)\n")
    report=r.run(case['attempt'],case['path'])
    assert report['status']=='failed' and not report['stages'][0]['log_only_verified']


def test_generated_stata_log_cannot_quarantine_genuine_input(case):
    p=case['attempt']/'work/analysis__author_capture.log';p.write_text('genuine warmstart input')
    case['plan']['inputs']=[{'path':'work/analysis__author_capture.log','sha256':digest(p)}]
    case['plan']['stages'][0].update(language='stata',executable=case['stata']);update(case)
    with pytest.raises(ValueError,match='immutable'):r.run(case['attempt'],case['path'])
    assert p.read_text()=='genuine warmstart input' and not (case['attempt']/'runtime/intent.json').exists()


def test_empty_file_is_not_a_verified_result(case):
    update(case,"from pathlib import Path\nPath('table.txt').touch()\n")
    report=r.run(case['attempt'],case['path'])
    assert report['status']=='failed' and report['stages'][0]['outputs'][0]['bytes']==0


def pin_host_policy(case,policy=None):
    if policy is not None:save(case['policy'],policy)
    save(case['attempt']/'work_item.json',{'runtime_policy':{'path':str(case['policy']),'sha256':digest(case['policy'])}})


@pytest.fixture
def host_case(case,monkeypatch):
    # The approved native identity is a trusted Python fixture in this test only.
    # No MATLAB runtime, author code or real HOME file is executed/read.
    auth=case['attempt']/'frozen/host_execution_authorization.json'
    save(auth,{'approved':True,'approved_by':'user','execution_profile':'host','languages':['matlab'],
        'host_home':str(Path.home()),'user_instruction':'Synthetic fixture authorizes host MATLAB profile',
        'approved_at':'2026-11-17T01:00:00+00:00'})
    policy=json.loads(case['policy'].read_text());policy.update(sandbox_profile='host',host_home=str(Path.home()),
        runtime_paths={'matlab':[sys.executable],'r':[],'stata':[]},
        host_execution_authorization={'path':str(auth),'sha256':digest(auth)})
    pin_host_policy(case,policy)
    case['plan']['sandbox']={'profile':'host','read_only_paths':[]}
    case['plan']['stages'][0].update(language='matlab',executable=sys.executable)
    update(case)
    def forbidden(*args,**kwargs):raise AssertionError('Host profile must never invoke bwrap or a native preflight')
    monkeypatch.setattr(r,'sandbox_command',forbidden)
    monkeypatch.setattr(r,'_native_command',lambda stage,attempt,folder,limits:([sys.executable,'-I',str(stage['_script'])],None,None))
    case['authorization']=auth
    return case


def test_explicit_host_profile_runs_fixture_with_truthful_environment_and_receipt(host_case,monkeypatch):
    monkeypatch.setenv('UNDECLARED_FIXTURE_VALUE','not inherited')
    update(host_case,"import json,os\nfrom pathlib import Path\nPath('table.txt').write_text(json.dumps({k:os.environ.get(k) for k in ['HOME','TMPDIR','PATH','OMP_NUM_THREADS','UNDECLARED_FIXTURE_VALUE']}))\n")
    report=r.run(host_case['attempt'],host_case['path']);stage=report['stages'][0]
    env=json.loads((host_case['attempt']/'work/table.txt').read_text())
    assert report['status']=='completed' and report['execution_verified']
    assert report['host_execution_authorization']=={'path':str(host_case['authorization']),'sha256':digest(host_case['authorization'])}
    assert report['host_execution_authorization_unchanged'] and report['runtime_policy_unchanged']
    assert report['sandbox']['profile']=='host' and report['sandbox']['host_home']==str(Path.home())
    for key in ['filesystem_isolation','network_isolation','network_disabled','network_isolation_requested']:assert report['sandbox'][key] is False
    assert report['sandbox']['host_home_exposed'] and report['sandbox']['full_user_filesystem_visibility']
    assert report['sandbox']['host_writable_roots'] is None
    assert 'sandbox_preflight' not in report and report['host_profile_validation']['native_preflight_subprocess'] is False
    assert 'sandbox_argv' not in stage and stage['execution_profile']=='host'
    assert stage['argv']==[sys.executable,'-I',str(host_case['script'])]
    assert env['HOME']==str(Path.home()) and env['TMPDIR']=='/tmp' and env['OMP_NUM_THREADS']=='2'
    assert env['PATH']=='/usr/local/bin:/usr/bin:/bin' and env['UNDECLARED_FIXTURE_VALUE'] is None
    assert stage['environment']==r.host_environment(host_case['plan'])
    intent=json.loads((host_case['attempt']/'runtime/intent.json').read_text())
    assert intent['execution_profile']=='host' and intent['host_execution_authorization']==report['host_execution_authorization']


def test_host_native_failure_is_recorded_and_cannot_rerun(host_case):
    update(host_case,"print('fictional native failure')\nraise SystemExit(9)\n")
    report=r.run(host_case['attempt'],host_case['path'])
    assert report['status']=='failed' and report['stages'][0]['returncode']==9
    assert report['stages'][0]['process']['pid']>0
    with pytest.raises(ValueError,match='already launched'):r.run(host_case['attempt'],host_case['path'])


def test_host_matlab_error_with_zero_process_exit_cannot_pass(host_case):
    update(host_case,"from pathlib import Path\nPath('table.txt').write_text('partial fixture')\nprint('Error using fictional_model')\n")
    report=r.run(host_case['attempt'],host_case['path'])
    assert report['status']=='failed' and report['stages'][0]['returncode']==0
    assert report['stages'][0]['native_error_detected']


@pytest.mark.parametrize('language',['r','stata'])
def test_host_profile_refuses_non_matlab_stages(host_case,language):
    host_case['plan']['stages'][0]['language']=language;update(host_case)
    with pytest.raises(ValueError,match='only for MATLAB'):r.run(host_case['attempt'],host_case['path'])
    assert not (host_case['attempt']/'runtime/intent.json').exists()


@pytest.mark.parametrize('sandbox',[{'profile':'host','read_only_paths':['/tmp']},
    {'profile':'host','read_only_paths':[],'executable':'fixture-bwrap'},
    {'profile':'host','read_only_paths':[],'filesystem_isolation':True},{'profile':'host'}])
def test_host_profile_refuses_mount_or_isolation_claims(host_case,sandbox):
    host_case['plan']['sandbox']=sandbox;update(host_case)
    with pytest.raises(ValueError):r.run(host_case['attempt'],host_case['path'])


def test_host_requires_independent_frozen_user_authorization(host_case):
    policy=json.loads(host_case['policy'].read_text());policy.pop('host_execution_authorization');pin_host_policy(host_case,policy)
    with pytest.raises(ValueError,match='explicit user authorization'):r.run(host_case['attempt'],host_case['path'])


def test_host_authorization_content_hash_must_match(host_case):
    host_case['authorization'].write_text('{}')
    with pytest.raises(ValueError,match='authorization changed'):r.run(host_case['attempt'],host_case['path'])


def test_host_authorization_cannot_live_in_mutable_work(host_case):
    path=host_case['attempt']/'work/authorization.json';save(path,json.loads(host_case['authorization'].read_text()))
    policy=json.loads(host_case['policy'].read_text());policy['host_execution_authorization']={'path':str(path),'sha256':digest(path)};pin_host_policy(host_case,policy)
    with pytest.raises(ValueError,match='outside frozen/'):r.run(host_case['attempt'],host_case['path'])


@pytest.mark.parametrize('key,value',[('approved',False),('approved_by',None),('approved_by','agent'),('execution_profile','bwrap'),('languages',['matlab','r']),
    ('host_home','/tmp/home'),('user_instruction',''),('approved_at','not a date'),('approved_at','2026-11-17T01:00:00')])
def test_host_authorization_must_match_exact_explicit_scope(host_case,key,value):
    auth=json.loads(host_case['authorization'].read_text());auth[key]=value;save(host_case['authorization'],auth)
    policy=json.loads(host_case['policy'].read_text());policy['host_execution_authorization']['sha256']=digest(host_case['authorization']);pin_host_policy(host_case,policy)
    with pytest.raises(ValueError):r.run(host_case['attempt'],host_case['path'])


def test_host_approved_runtime_identity_cannot_be_changed(host_case):
    host_case['plan']['stages'][0]['executable']='/bin/sh';update(host_case)
    with pytest.raises(ValueError,match='native language'):r.run(host_case['attempt'],host_case['path'])


def test_host_authorization_mutation_during_fixture_fails_final_integrity(host_case):
    update(host_case,"from pathlib import Path\nPath('../frozen/host_execution_authorization.json').write_text('{}')\nPath('table.txt').write_text('fictional result')\n")
    report=r.run(host_case['attempt'],host_case['path'])
    assert report['status']=='failed' and not report['host_execution_authorization_unchanged']
    assert not report['execution_verified']


def test_bwrap_policy_cannot_be_reinterpreted_as_host(case):
    case['plan']['sandbox']={'profile':'host','read_only_paths':[]};update(case)
    with pytest.raises(ValueError,match='no host fallback'):r.run(case['attempt'],case['path'])
    assert not (case['attempt']/'runtime/intent.json').exists()


def test_bwrap_builder_refuses_explicit_host_profile_without_launching():
    with pytest.raises(ValueError,match='cannot execute a host profile'):
        r.sandbox_command(Path('/fictional/attempt'),{'sandbox':{'profile':'host'}},[r.SANDBOX_PROBE],[])


def test_host_timeout_terminates_fixture_group_without_retry(host_case,monkeypatch):
    host_case['plan']['limits']['wall_seconds']=1;update(host_case,"import time\nprint('before host timeout',flush=True)\ntime.sleep(20)\n")
    calls=[];original=r.os.killpg
    def checked(pid,sig):calls.append((pid,sig));return original(pid,sig)
    monkeypatch.setattr(r.os,'killpg',checked)
    report=r.run(host_case['attempt'],host_case['path']);stage=report['stages'][0]
    assert report['status']=='failed' and stage['timeout']
    assert (stage['process']['process_group'],signal.SIGTERM) in calls
    assert b'before host timeout' in Path(stage['stdout']['path']).read_bytes()
    with pytest.raises(ValueError,match='already launched'):r.run(host_case['attempt'],host_case['path'])


def test_host_authorization_cannot_omit_user_approval_provenance(host_case):
    auth=json.loads(host_case['authorization'].read_text());auth.pop('approved_by');save(host_case['authorization'],auth)
    policy=json.loads(host_case['policy'].read_text());policy['host_execution_authorization']['sha256']=digest(host_case['authorization']);pin_host_policy(host_case,policy)
    with pytest.raises(ValueError,match='Explicit user authorization'):r.run(host_case['attempt'],host_case['path'])
    assert not (host_case['attempt']/'runtime/intent.json').exists()


def test_host_external_declared_input_is_hash_checked_without_readonly_mount_claim(host_case,tmp_path):
    source=tmp_path/'synthetic-source';source.mkdir();data=source/'input.txt';data.write_text('fictional input')
    policy=json.loads(host_case['policy'].read_text());policy['allowed_read_only_roots']=[str(source)];pin_host_policy(host_case,policy)
    host_case['plan']['inputs']=[{'path':str(data),'sha256':digest(data)}]
    update(host_case,f"from pathlib import Path\nPath({str(data)!r}).write_text('fictional mutation')\nPath('table.txt').write_text('fixture')\n")
    report=r.run(host_case['attempt'],host_case['path'])
    assert report['status']=='failed' and not report['original_inputs_unchanged']
    assert report['sandbox']['filesystem_isolation'] is False
    assert 'no read-only OS enforcement' in report['sandbox']['input_integrity_mode']


@pytest.mark.parametrize('environment',[{'HOME':'/tmp/other-home'},{'MLM_LICENSE_TOKEN':'fixture-not-an-actual-token'}])
def test_host_environment_does_not_accept_home_override_or_injected_credentials(environment):
    with pytest.raises(ValueError,match='environment'):
        r.host_environment({'limits':{'threads':2},'environment':environment})


def test_host_matlab_stderr_error_with_zero_exit_and_fresh_output_fails(host_case):
    update(host_case,"from pathlib import Path\nimport sys\nPath('table.txt').write_text('partial fictional result')\nprint('Error using fictional_model',file=sys.stderr)\n")
    report=r.run(host_case['attempt'],host_case['path']);stage=report['stages'][0]
    assert stage['returncode']==0 and stage['outputs'][0]['fresh']
    assert stage['native_error_detected'] and report['status']=='failed'
    assert not report['execution_verified']


def test_timeout_kills_term_ignoring_child_after_leader_exits(host_case,monkeypatch):
    # The synthetic leader exits zero on TERM. Its child explicitly ignores TERM
    # and would produce a delayed marker if the runner forgot the final group
    # KILL. The finally block cleans the group even when this regression fails.
    child=("import signal,time\nfrom pathlib import Path\n"
        "signal.signal(signal.SIGTERM,signal.SIG_IGN)\n"
        "print('READY',flush=True)\ntime.sleep(4)\n"
        "Path('child-survived.txt').write_text('bad fixture survival')\ntime.sleep(10)\n")
    parent=("import subprocess,sys,signal,time\nfrom pathlib import Path\n"
        "signal.signal(signal.SIGTERM,lambda *args:sys.exit(0))\n"
        f"child=subprocess.Popen([sys.executable,'-I','-c',{child!r}],stdout=subprocess.PIPE)\n"
        "assert child.stdout.readline().strip()==b'READY'\n"
        "Path('child.pid').write_text(str(child.pid))\n"
        "print('leader and child ready',flush=True)\ntime.sleep(20)\n")
    host_case['plan']['limits']['wall_seconds']=1;update(host_case,parent)
    calls=[];original=r.os.killpg;started=time.monotonic();group=None
    def checked(pid,sig):calls.append((pid,sig));return original(pid,sig)
    monkeypatch.setattr(r.os,'killpg',checked)
    try:
        report=r.run(host_case['attempt'],host_case['path']);stage=report['stages'][0]
        group=stage['process']['process_group']
        assert stage['timeout'] and stage['returncode']==0
        time.sleep(max(0,started+4.4-time.monotonic()))
        assert not (host_case['attempt']/'work/child-survived.txt').exists()
        assert (group,signal.SIGTERM) in calls and (group,signal.SIGKILL) in calls
        assert report['status']=='failed' and not report['execution_verified']
    finally:
        if group is not None:
            try:original(group,signal.SIGKILL)
            except ProcessLookupError:pass
        else:
            pid_file=host_case['attempt']/'work/child.pid'
            if pid_file.exists():
                try:r.os.kill(int(pid_file.read_text()),signal.SIGKILL)
                except ProcessLookupError:pass
