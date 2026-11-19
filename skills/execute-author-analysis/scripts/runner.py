#!/usr/bin/env python3
"""Run one reviewed author-analysis plan in its explicitly authorized profile.

The runner never estimates a model itself. It records the actual interpreter
processes, preserves their streams, and refuses a second scientific launch in
the same attempt. Bwrap is isolated; explicit MATLAB host mode is not isolated.
A sandbox setup failure never falls back to host execution.
"""
from __future__ import annotations

import argparse
from contextlib import contextmanager
from datetime import datetime, timezone
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import resource
import shutil
import signal
import stat
import subprocess
import sys
import time

SYSTEM_ROOTS = ('/usr', '/bin', '/sbin', '/lib', '/lib64', '/etc')
RUNTIMES = {'stata': ('/usr/local/bin/stata',), 'r': ('/usr/bin/Rscript',), 'matlab': ()}
WRITABLE_DIRS = ('work', 'home', 'tmp', 'outputs')
ENV_KEYS = {'R_LIBS', 'R_LIBS_USER', 'JAVA_HOME', 'LANG', 'LC_ALL', 'TZ'}
ID = re.compile(r'^[A-Za-z0-9][A-Za-z0-9_.-]{0,79}$')
STATA_MARKER = re.compile(rb'(?m)^\s*__AUTHOR_ANALYSIS_RC__\s*([0-9]+)\s*$')
STATA_ERROR = re.compile(rb'(?m)^\s*r\(([0-9]+)\);\s*$')
SENSITIVE = re.compile(rb'(?i)(?:password|passwd|secret|token|api[_-]?key|authorization|serial\s*(?:number|no)|license\s*(?:number|key))')


def now():
    return datetime.now(timezone.utc).isoformat()


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def _plain(path, *, exists=True):
    path = Path(path).absolute()
    if any(p.is_symlink() for p in (path, *path.parents)):
        raise ValueError('Runner paths must not contain symlinks')
    if exists and not path.exists():
        raise ValueError('Required runner path is missing')
    return path.resolve()


def _inside(attempt, relative, *, exists=False, writable=False):
    relative = Path(relative)
    if relative.is_absolute() or '..' in relative.parts or any(c in str(relative) for c in '\x00\n\r'):
        raise ValueError('Expected a relative in-attempt path')
    target = _plain(attempt / relative, exists=exists)
    if not target.is_relative_to(attempt):
        raise ValueError('Path escapes the attempt')
    if writable and not any(target.is_relative_to(attempt / name) for name in ('work', 'outputs')):
        raise ValueError('Study paths must stay in work/ or outputs/')
    return target


def _json(path):
    def pairs(items):
        value = {}
        for key, item in items:
            if key in value:
                raise ValueError('Duplicate plan key')
            value[key] = item
        return value
    return json.loads(Path(path).read_text(encoding='utf-8'), object_pairs_hook=pairs,
                      parse_constant=lambda _: (_ for _ in ()).throw(ValueError('Non-finite plan value')))


def _write(path, value, *, exclusive=False):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    data = json.dumps(value, ensure_ascii=False, indent=2, allow_nan=False) + '\n'
    if exclusive:
        with path.open('x', encoding='utf-8') as stream:
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
    else:
        temp = path.with_name(path.name + f'.{os.getpid()}.tmp')
        try:
            with temp.open('x', encoding='utf-8') as stream:
                stream.write(data)
                stream.flush()
                os.fsync(stream.fileno())
            os.replace(temp, path)
        finally:
            if temp.exists():
                temp.unlink()
    return sha(path)


@contextmanager
def _lock(runtime):
    path = runtime / '.runner.lock'
    if path.is_symlink():
        raise ValueError('Runner lock must not be a symlink')
    with path.open('a') as stream:
        fcntl.flock(stream, fcntl.LOCK_EX)
        yield


def _record_file(path):
    path = _plain(path)
    return {'path': str(path), 'sha256': sha(path), 'bytes': path.stat().st_size}


def _identity(path):
    p = _plain(path,exists=False)
    if not p.exists():
        return None
    if not p.is_file() or p.is_symlink():
        raise ValueError('Expected a plain study artifact')
    s = p.stat()
    return {'sha256': sha(p), 'bytes': s.st_size, 'device': s.st_dev, 'inode': s.st_ino,
            'mtime_ns': s.st_mtime_ns, 'ctime_ns': s.st_ctime_ns}


def _positive_int(value, name, maximum):
    if type(value) is not int or not 0 < value <= maximum:
        raise ValueError(f'Invalid {name} limit')
    return value


def _runtime_path(stage, policy):
    language = stage['language']
    if not isinstance(stage.get('executable'),str) or not Path(stage['executable']).is_absolute():
        raise ValueError('Native runtime paths must be explicit absolute paths')
    # Installed PATH entrypoints may themselves be symlinks (Stata is one on
    # this host). Resolve only against the fixed trusted runtime identities.
    path = Path(stage['executable']).absolute().resolve()
    if not path.is_file() or not os.access(path, os.X_OK):
        raise ValueError('Runtime executable is unavailable')
    allowed=policy.get('runtime_paths',{}).get(language,[])
    if not isinstance(allowed,list) or any(not isinstance(p,str) for p in allowed):
        raise ValueError('Invalid runtime policy entrypoints')
    if path not in {Path(p).absolute().resolve() for p in allowed}:
        raise ValueError('Runtime path does not match the approved native language')
    return str(path)


def _runtime_policy(attempt):
    item_path=_plain(attempt/'work_item.json')
    item=_json(item_path)
    record=item.get('runtime_policy')
    if not isinstance(record,dict) or not re.fullmatch(r'[0-9a-f]{64}',str(record.get('sha256',''))):
        raise ValueError('A frozen controller runtime policy is required')
    path=_plain(record.get('path',''))
    if not path.is_file() or not path.is_relative_to(attempt/'frozen') or sha(path)!=record['sha256']:
        raise ValueError('Frozen runtime policy changed or is outside frozen/')
    policy=_json(path)
    if policy.get('schema_version')!='1.0' or policy.get('sandbox_profile') not in {'bwrap','host'}:
        raise ValueError('Unsupported runtime isolation policy')
    roots=policy.get('allowed_read_only_roots')
    if not isinstance(roots,list) or any(not isinstance(x,str) or not Path(x).is_absolute() for x in roots):
        raise ValueError('Runtime policy needs explicit readonly roots')
    if policy['sandbox_profile']=='host':
        auth_record=policy.get('host_execution_authorization')
        if policy.get('host_home')!=str(Path.home()) or not isinstance(auth_record,dict) or not re.fullmatch(r'[0-9a-f]{64}',str(auth_record.get('sha256',''))):
            raise ValueError('Host mode requires the frozen explicit user authorization and exact user HOME')
        auth_path=_plain(auth_record.get('path',''))
        if not auth_path.is_file() or not auth_path.is_relative_to(attempt/'frozen') or sha(auth_path)!=auth_record['sha256']:
            raise ValueError('Frozen host authorization changed or is outside frozen/')
        auth=_json(auth_path)
        if (auth.get('approved') is not True or auth.get('approved_by')!='user' or auth.get('execution_profile')!='host'
                or auth.get('languages')!=['matlab'] or auth.get('host_home')!=str(Path.home())
                or not isinstance(auth.get('user_instruction'),str) or not auth['user_instruction'].strip()):
            raise ValueError('Explicit user authorization must approve MATLAB-only host execution')
        try:approved_at=datetime.fromisoformat(auth.get('approved_at','').replace('Z','+00:00'))
        except (ValueError,TypeError,AttributeError):raise ValueError('Host authorization needs the actual ISO approval time')
        if approved_at.tzinfo is None:raise ValueError('Host approval time must include its timezone')
        policy['_host_authorization_record']={'path':str(auth_path),'sha256':auth_record['sha256']}
    return policy,{'path':str(path),'sha256':record['sha256']}


def validate_plan(attempt, plan_path):
    attempt = _plain(attempt)
    if not attempt.is_dir():
        raise ValueError('Attempt directory is required')
    policy,policy_record=_runtime_policy(attempt)
    plan_path = _plain(plan_path)
    if not plan_path.is_file() or not plan_path.is_relative_to(attempt/'frozen'):
        raise ValueError('Reviewed plan must be a plain file in frozen/')
    plan = _json(plan_path)
    if plan.get('schema_version') != '1.0' or not isinstance(plan.get('attempt_id'), str) or not ID.fullmatch(plan['attempt_id']):
        raise ValueError('Unknown or invalid execution plan identity')
    sandbox = plan.get('sandbox', {})
    profile=sandbox.get('profile')
    if profile not in {'bwrap','host'} or profile!=policy['sandbox_profile']:
        raise ValueError('Plan profile must match the frozen runtime policy; no host fallback')
    if profile=='bwrap':
        bwrap = _plain(sandbox.get('executable', '/usr/bin/bwrap'))
        if bwrap != _plain('/usr/bin/bwrap') or not bwrap.is_file() or not os.access(bwrap, os.X_OK):
            raise ValueError('Trusted bubblewrap executable is unavailable')
    elif set(sandbox)!={'profile','read_only_paths'}:
        raise ValueError('Host profile requires only profile and an explicit empty read_only_paths list; no executable/isolation claims')
    mounts = sandbox.get('read_only_paths', [])
    if not isinstance(mounts, list):
        raise ValueError('Readonly paths must be a list')
    if profile=='host' and mounts:
        raise ValueError('Host mode cannot claim read-only mounts or filesystem confinement')
    approved = []
    policy_roots=[_plain(p,exists=False) for p in policy['allowed_read_only_roots']]
    for name in mounts:
        p = _plain(name)
        if attempt.is_relative_to(p) or p.is_relative_to(attempt):
            raise ValueError('Readonly external mounts must be separate from the attempt')
        if p == Path('/') or any(Path(root).is_relative_to(p) for root in SYSTEM_ROOTS):
            raise ValueError('An external mount must not replace a system root')
        if not any(p==root or p.is_relative_to(root) for root in policy_roots):
            raise ValueError('Readonly mount is outside the frozen runtime policy')
        approved.append(p)
    if len(set(approved)) != len(approved):
        raise ValueError('Duplicate readonly mount')
    limits = plan.get('limits', {})
    wall = _positive_int(limits.get('wall_seconds', 3600), 'wall-time', 86400)
    memory = _positive_int(limits.get('memory_bytes', 8 * 1024 ** 3), 'per-process memory', 128 * 1024 ** 3)
    threads = _positive_int(limits.get('threads', 2), 'thread', 32)
    maxima=policy.get('limits',{})
    for name,value in [('wall_seconds',wall),('memory_bytes',memory),('threads',threads)]:
        if type(maxima.get(name)) is not int or value>maxima[name]:
            raise ValueError('Plan resource limit exceeds the frozen runtime policy')
    env = plan.get('environment', {})
    if not isinstance(env, dict) or not set(env) <= ENV_KEYS or any(not isinstance(v, str) or '\x00' in v for v in env.values()):
        raise ValueError('Only declared library/locale environment settings are permitted')
    for name in ('R_LIBS','R_LIBS_USER','JAVA_HOME'):
        for value in env.get(name,'').split(os.pathsep):
            if not value:continue
            if not Path(value).is_absolute():raise ValueError('Library environment paths must be explicit')
            p=_plain(value,exists=False)
            if not any(p==root or p.is_relative_to(root) for root in [attempt,*approved,*[Path(x) for x in SYSTEM_ROOTS]]):
                raise ValueError('Library environment path is outside the reviewed sandbox')
    inputs = plan.get('inputs', [])
    if not isinstance(inputs, list):
        raise ValueError('Inputs must be a list of path/hash records')
    bindings = []
    for item in inputs:
        if not isinstance(item, dict) or not isinstance(item.get('path'), str):
            raise ValueError('Invalid immutable input binding')
        p = Path(item['path'])
        p = _plain(p if p.is_absolute() else attempt / p)
        if not p.is_file() or not re.fullmatch(r'[0-9a-f]{64}', str(item.get('sha256', ''))):
            raise ValueError('An input needs a plain file and SHA-256')
        input_roots=approved if profile=='bwrap' else policy_roots
        if not p.is_relative_to(attempt) and not any(p == root or p.is_relative_to(root) for root in input_roots):
            raise ValueError('External input is outside the frozen approved input roots')
        if p.is_relative_to(attempt) and p.stat().st_nlink > 1:
            raise ValueError('Hardlinked study inputs are not permitted')
        if sha(p) != item['sha256']:
            raise ValueError('Immutable input changed before execution')
        bindings.append({'path': str(p), 'sha256': item['sha256']})
    if len({x['path'] for x in bindings}) != len(bindings):
        raise ValueError('Duplicate immutable input')
    stages = plan.get('stages')
    if not isinstance(stages, list) or not stages:
        raise ValueError('A run plan requires native stages')
    seen, outputs, normalized = set(), set(), []
    for stage in stages:
        if not isinstance(stage, dict) or not isinstance(stage.get('id'), str) or not ID.fullmatch(stage['id']) or stage['id'] in seen:
            raise ValueError('Stage IDs must be unique safe names')
        sid = stage['id']
        if stage.get('language') not in RUNTIMES:
            raise ValueError('Unsupported native stage language')
        if profile=='host' and stage['language']!='matlab':
            raise ValueError('Host execution is authorized only for MATLAB stages; never Stata or R')
        required = stage.get('required', True)
        if type(required) is not bool:
            raise ValueError('Stage required must be boolean')
        script = _inside(attempt, stage['script'], exists=True, writable=True)
        if not script.is_file() or script.stat().st_nlink > 1 or sha(script) != stage.get('script_sha256'):
            raise ValueError('Native working script is missing, hardlinked or changed')
        cwd = _inside(attempt, stage.get('cwd', 'work'), exists=True, writable=True)
        if not cwd.is_dir():
            raise ValueError('Native stage cwd must be a working directory')
        args = stage.get('args', [])
        if not isinstance(args, list) or any(not isinstance(x, str) or any(c in x for c in '\x00\n\r') for x in args):
            raise ValueError('Native arguments must be a string list')
        if stage['language'] == 'matlab' and args:
            raise ValueError('MATLAB batch scripts accept no unreviewed argument expressions')
        if stage['language']=='stata' and any(any(c in x for c in '\"`$') for x in args):
            raise ValueError('Stata script arguments must not contain executable quoting or macros')
        dependencies = stage.get('depends_on', [])
        if not isinstance(dependencies, list) or len(set(dependencies)) != len(dependencies) or not set(dependencies) <= seen:
            raise ValueError('Stages must be in dependency order with known predecessors')
        expected = stage.get('expected_outputs', [])
        logs = stage.get('native_logs', [])
        if not isinstance(expected, list) or not isinstance(logs, list):
            raise ValueError('Expected outputs/native logs must be path lists')
        log_only=stage.get('log_only',False)
        markers=stage.get('success_markers',[])
        if type(log_only) is not bool or not isinstance(markers,list):
            raise ValueError('Invalid native result-log declaration')
        if log_only:
            if expected or len(markers)<2 or any(not isinstance(x,str) or not 3<=len(x)<=200
                    or any(c in x for c in '\r\n\x00') for x in markers):
                raise ValueError('Log-only stages need distinct reviewed result markers and no invented file outputs')
            normalized_markers={re.sub(r'\s+',' ',x).strip().casefold() for x in markers}
            if len(normalized_markers)!=len(markers) or any(x in {'stata','copyright','license','end of do-file','r version','r is free software'}
                    or '__author_analysis_rc__' in x or SENSITIVE.search(x.encode()) for x in normalized_markers):
                raise ValueError('Startup/control/credential text cannot establish estimation results')
        elif not expected or markers:
            raise ValueError('A native stage needs expected outputs or an explicit reviewed log-only result')
        expected_paths, log_paths = [], []
        for name in expected:
            p = _inside(attempt, name, writable=True)
            if p in outputs or str(p) in {x['path'] for x in bindings} or p == script:
                raise ValueError('Output names must be unique and separate from immutable inputs/scripts')
            outputs.add(p); expected_paths.append(p)
        for name in logs:
            p = _inside(attempt, name, writable=True)
            if str(p) in {x['path'] for x in bindings} or p == script:
                raise ValueError('Native log collides with an immutable input/script')
            log_paths.append(p)
        entry_points = stage.get('source_entry_points', [])
        if not isinstance(entry_points, list) or any(not isinstance(x, str) for x in entry_points):
            raise ValueError('Source entrypoints must be metadata strings')
        ado_paths=[]
        if stage['language']=='stata':
            declared=policy.get('stata_ado_paths',[])
            if not isinstance(declared,list) or any(not isinstance(x,str) for x in declared):
                raise ValueError('Invalid frozen Stata ado paths')
            for path in declared:
                if not Path(path).is_absolute():raise ValueError('Frozen Stata ado paths must be absolute')
                p=_plain(path,exists=False)
                if not p.exists():continue
                if not p.is_dir() or not any(p==root or p.is_relative_to(root) for root in [*approved,*[Path(x) for x in SYSTEM_ROOTS],attempt]):
                    raise ValueError('Stata ado path is not in the reviewed sandbox mounts')
                if any(c in str(p) for c in '\"`$\r\n'):
                    raise ValueError('Stata ado path has unsupported executable quoting')
                ado_paths.append(str(p))
        normalized.append({**stage, 'id': sid, 'required': required, 'executable': _runtime_path(stage,policy),
                           '_script': script, '_cwd': cwd, '_outputs': expected_paths, '_logs': log_paths,
                           '_ado_paths':ado_paths,'depends_on': dependencies, 'source_entry_points': entry_points, 'args': args,
                           'log_only':log_only,'success_markers':markers})
        seen.add(sid)
    # The trusted native launcher owns these files too. Never quarantine a
    # genuine input, script or another stage's result under a generated name.
    protected={Path(x['path']) for x in bindings}|{x['_script'] for x in normalized}
    artifact_owners={}
    for stage in normalized:
        generated=[]
        if stage['language']=='stata':
            generated=[stage['_cwd']/(stage['id']+suffix) for suffix in
                ('__author_analysis.log','__author_receipt.log','__author_capture.log')]
        for path in dict.fromkeys([*stage['_outputs'],*stage['_logs'],*generated]):
            if path in protected:
                raise ValueError('Native artifact collides with an immutable input/script')
            if path in artifact_owners and artifact_owners[path]!=stage['id']:
                raise ValueError('Native artifacts must not be shared between stages')
            artifact_owners[path]=stage['id']
    if not any(stage['required'] for stage in normalized):
        raise ValueError('At least one required native analysis stage is needed')
    gaps=plan.get('scope_gaps',[])
    if not isinstance(gaps,list) or any(not isinstance(x,dict) or not isinstance(x.get('reason'),str) or not x['reason'].strip()
            or not isinstance(x.get('source_entry_points'),list) or any(not isinstance(y,str) for y in x['source_entry_points']) for x in gaps):
        raise ValueError('Scope gaps need explicit entrypoint lists and reasons')
    plan['_runtime_policy_record']=policy_record
    plan['_profile']=profile
    if profile=='host':
        plan['_host_home']=policy['host_home']
        plan['_host_authorization_record']=policy['_host_authorization_record']
    return attempt, plan_path, plan, normalized, bindings, approved, {'wall_seconds': wall, 'memory_bytes': memory, 'threads': threads}


def _mkdir_arguments(paths):
    values = set()
    for path in paths:
        for p in (Path(path), *Path(path).parents):
            if p != Path('/') and not any(p == Path(root) or p.is_relative_to(Path(root)) for root in SYSTEM_ROOTS):
                values.add(p)
    result = []
    for path in sorted(values, key=lambda p: (len(p.parts), str(p))):
        result.extend(['--dir', str(path)])
    return result


def sandbox_command(attempt, plan, child_argv, readonly_paths, *, cwd=None):
    """Build a minimal root: no host home/storage, no network, bounded writes."""
    if plan.get('sandbox',{}).get('profile')!='bwrap':
        raise ValueError('The bwrap builder cannot execute a host profile')
    result = [plan['sandbox'].get('executable', '/usr/bin/bwrap'), '--die-with-parent', '--new-session',
              '--unshare-net', '--unshare-pid', '--unshare-ipc', '--clearenv']
    for root in SYSTEM_ROOTS:
        if Path(root).exists():
            result += ['--ro-bind', root, root]
    result += ['--proc', '/proc', '--dev', '/dev', '--tmpfs', '/tmp']
    parents = [attempt.parent, *(p if p.is_dir() else p.parent for p in readonly_paths)]
    result += _mkdir_arguments(parents)
    for path in readonly_paths:
        if path.is_relative_to(attempt):continue
        result += ['--ro-bind', str(path), str(path)]
    result += ['--ro-bind', str(attempt), str(attempt)]
    for name in WRITABLE_DIRS:
        result += ['--bind', str(attempt / name), str(attempt / name)]
    for path in readonly_paths:
        if path.is_relative_to(attempt):
            result += ['--ro-bind',str(path),str(path)]
    environment = {'PATH':'/usr/local/bin:/usr/bin:/bin', 'HOME':str(attempt/'home'),
                   'TMPDIR':'/tmp', 'LANG':'C.UTF-8', 'LC_ALL':'C.UTF-8', 'TZ':'UTC'}
    threads = str(plan.get('limits', {}).get('threads', 2))
    environment.update({name:threads for name in ('OMP_NUM_THREADS','OPENBLAS_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS')})
    environment.update(plan.get('environment', {}))
    for name, value in sorted(environment.items()):
        result += ['--setenv', name, value]
    return result + ['--chdir',str(cwd or attempt/'work'),'--', *child_argv]


def _limits(memory, wall):
    def apply():
        resource.setrlimit(resource.RLIMIT_CORE, (0,0))
        resource.setrlimit(resource.RLIMIT_AS, (memory,memory))
        cpu = int(wall)+10
        resource.setrlimit(resource.RLIMIT_CPU, (cpu,cpu))
    return apply


def host_environment(plan, host_home=str(Path.home())):
    """Controlled native environment; HOME reuses activation with full host access."""
    if host_home!=str(Path.home()):raise ValueError('Host HOME must match the explicitly approved user')
    extra=plan.get('environment',{})
    if not isinstance(extra,dict) or not set(extra)<=ENV_KEYS or any(not isinstance(v,str) or '\x00' in v for v in extra.values()):
        raise ValueError('Only declared library/locale environment settings are permitted')
    threads=str(_positive_int(plan.get('limits',{}).get('threads',2),'thread',32))
    environment={'PATH':'/usr/local/bin:/usr/bin:/bin','HOME':host_home,'TMPDIR':'/tmp',
                 'LANG':'C.UTF-8','LC_ALL':'C.UTF-8','TZ':'UTC'}
    environment.update({key:threads for key in ('OMP_NUM_THREADS','OPENBLAS_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS')})
    environment.update(extra)
    return environment


def _spawn(argv, cwd, stdout, stderr, timeout, memory, on_start=None, environment=None):
    """Capture actual bytes and kill the whole new process group on timeout."""
    started = time.monotonic()
    with Path(stdout).open('xb') as out, Path(stderr).open('xb') as err:
        process = subprocess.Popen(argv, cwd=cwd, stdin=subprocess.DEVNULL, stdout=out, stderr=err,
                                   env=environment if environment is not None else {'PATH':'/usr/local/bin:/usr/bin:/bin','LANG':'C.UTF-8'},
                                   start_new_session=True, preexec_fn=_limits(memory, timeout))
        if on_start is not None:
            try:on_start({'pid':process.pid,'process_group':process.pid,'started_at':now()})
            except Exception:
                try:os.killpg(process.pid,signal.SIGKILL)
                except ProcessLookupError:pass
                process.wait()
                raise
        timed_out = False
        try:
            code = process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            timed_out = True
            grace_deadline=time.monotonic()+2
            try: os.killpg(process.pid, signal.SIGTERM)
            except ProcessLookupError: pass
            try: code = process.wait(timeout=2)
            except subprocess.TimeoutExpired: pass
            # A leader can exit on TERM while a descendant ignores it. Keep the
            # grace bounded, then kill the remaining group even after wait()
            # already reaped the leader. Never leave host-mode children alive.
            time.sleep(max(0,grace_deadline-time.monotonic()))
            try: os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError: pass
            code = process.wait()
    return {'returncode':code,'timeout':timed_out,'seconds':round(time.monotonic()-started,3),
            'stdout':_record_file(stdout),'stderr':_record_file(stderr)}


def _native_command(stage, attempt, stage_dir, limits):
    script = str(stage['_script'])
    if stage['language'] == 'stata':
        if '"' in script or '`' in script or '$' in script:
            raise ValueError('Working script path contains unsupported Stata quoting')
        basename=stage['id']+'__author_analysis'
        launcher = stage_dir/(basename+'.do')
        receipt=stage['_cwd']/(stage['id']+'__author_receipt.log')
        capture=stage['_cwd']/(stage['id']+'__author_capture.log')
        if any(c in str(receipt) for c in '\"`$'):
            raise ValueError('Native receipt path has unsupported Stata quoting')
        code = ('version 18\nset more off\n'
                f'capture set processors {limits["threads"]}\n'
                +''.join(f'adopath ++ "{path}"\n' for path in reversed(stage['_ado_paths']))+
                'capture log close AA_RUNNER\n'
                f'log using "{capture}", text name(AA_RUNNER) replace\n'
                f'capture noisily do "{script}"' + ''.join(' "'+a.replace('"','""')+'"' for a in stage['args']) + '\n'
                'local author_analysis_rc = _rc\n'
                'capture log close AA_RECEIPT\n'
                f'log using "{receipt}", text name(AA_RECEIPT) replace\n'
                'display "__AUTHOR_ANALYSIS_RC__ `author_analysis_rc\'"\n'
                'log close AA_RECEIPT\n'
                'capture log close AA_RUNNER\n'
                'exit `author_analysis_rc\', clear\n')
        launcher.write_text(code, encoding='utf-8')
        return [stage['executable'], '-b', 'do', str(launcher)], stage['_cwd']/(basename+'.log'), {
            **_record_file(launcher),'receipt_log':str(receipt),'capture_log':str(capture)}
    if stage['language'] == 'r':
        return [stage['executable'],'--vanilla',script,*stage['args']], None, None
    escaped = script.replace("'", "''")
    return [stage['executable'],'-batch',f"run('{escaped}')"], None, None


def _safe_tail(path, limit=8192):
    """Bounded human-readable diagnostic view; original streams remain separate."""
    with Path(path).open('rb') as stream:
        stream.seek(max(0,Path(path).stat().st_size-limit))
        data = stream.read(limit)
    if SENSITIVE.search(data):
        return '[WITHHELD diagnostic window: credential/license candidate]'
    rows = []
    for line in data.splitlines()[-40:]:
        rows.append('[WITHHELD credential/license candidate]' if SENSITIVE.search(line)
                    else line.decode('utf-8',errors='replace'))
    return '\n'.join(rows)


def _error_in_stream(path, pattern):
    """Inspect line prefixes with bounded memory, including very long lines."""
    at_start=True
    with Path(path).open('rb') as stream:
        for piece in iter(lambda:stream.readline(65536),b''):
            if at_start and pattern.match(piece):return True
            at_start=piece.endswith(b'\n')
    return False


def _stata_status(paths):
    codes=[];errors=[]
    for path in paths:
        at_start=True
        with Path(path).open('rb') as stream:
            for piece in iter(lambda:stream.readline(65536),b''):
                clean=re.sub(rb'\{[^}\r\n]*\}',b'',piece)
                if at_start:
                    codes.extend(int(x) for x in STATA_MARKER.findall(clean))
                    errors.extend(int(x) for x in STATA_ERROR.findall(clean))
                at_start=piece.endswith(b'\n')
    return codes,errors


def _result_markers(paths, markers):
    wanted={value:re.sub(rb'\s+',b' ',value.encode()).strip().lower() for value in markers}
    found=set();contributing=[]
    for path in paths:
        matched_here=False;at_start=True;skip=False
        with Path(path).open('rb') as stream:
            for piece in iter(lambda:stream.readline(65536),b''):
                clean=re.sub(rb'\{[^}\r\n]*\}',b'',piece).strip()
                if at_start:skip=clean.startswith((b'. ',b'> '))
                if not skip:
                    text=re.sub(rb'\s+',b' ',clean).lower()
                    for label,needle in wanted.items():
                        if needle in text:found.add(label);matched_here=True
                at_start=piece.endswith(b'\n')
        if matched_here:contributing.append(Path(path))
    return {'matched':[m for m in markers if m in found],'missing':[m for m in markers if m not in found]},contributing


def _report(runtime, value):
    value['updated_at'] = now()
    _write(runtime/'run.json',value)
    return value


def _matches(record):
    try:
        path=_plain(record['path'])
        return path.is_file() and sha(path)==record['sha256']
    except (OSError,ValueError):return False


def run(attempt, plan_path):
    attempt, plan_path, plan, stages, inputs, readonly, limits = validate_plan(attempt,plan_path)
    profile=plan['_profile']
    environment=host_environment(plan,plan['_host_home']) if profile=='host' else None
    runtime = attempt/'runtime'; runtime.mkdir(exist_ok=True)
    if runtime.is_symlink():raise ValueError('Runtime directory must be plain')
    with _lock(runtime):
        if (runtime/'intent.json').exists():
            raise ValueError('This attempt already launched; a fresh attempt and agent are required')
        for name in WRITABLE_DIRS:
            p=_plain(attempt/name,exists=False)
            p.mkdir(exist_ok=True)
            if not p.is_dir():raise ValueError('Writable sandbox roots must be directories')
        readonly=[*readonly,*dict.fromkeys([Path(x['path']) for x in inputs if Path(x['path']).is_relative_to(attempt)]
                                         +[stage['_script'] for stage in stages])]
        plan_hash = sha(plan_path)
        report = {'schema_version':'1.0','attempt_id':plan['attempt_id'],'started_at':now(),
                  'plan_path':str(plan_path),'plan_sha256':plan_hash,'status':'blocked',
                  'execution_verified':False,'stages':[],'inputs':inputs,
                  'original_inputs_unchanged':True,'scope_gaps':plan.get('scope_gaps',[]),
                  'runtime_policy':plan['_runtime_policy_record'],
                  'sandbox':{'profile':profile,'network_disabled':False,'network_isolation_requested':profile=='bwrap','network_isolation':False,
                             'filesystem_isolation':False,'setup_verified':False,'host_home_exposed':profile=='host',
                             'host_writable_roots':[str(attempt/name) for name in WRITABLE_DIRS],
                             'resource_limits_note':'Address-space/CPU limits are per process; thread settings are runtime/environment controls, not a cgroup aggregate limit.'}}
        if profile=='host':
            report['host_execution_authorization']=plan['_host_authorization_record']
            report['sandbox'].update(host_home=plan['_host_home'],full_user_filesystem_visibility=True,
                host_writable_roots=None,filesystem_isolation=False,
                input_integrity_mode='Declared input hashes only; no read-only OS enforcement.',
                isolation_note='Normal user filesystem and network access; no OS confinement. Policy network restrictions do not imply kernel network isolation.')
        report['limits']=limits
        if (runtime/'run.json').exists():
            history = runtime/'preflight_history';history.mkdir(exist_ok=True)
            old = history/f'run_{time.time_ns()}.json'
            shutil.copy2(runtime/'run.json',old);old.chmod(0o444)
        if profile=='bwrap':
            preflight = runtime/'preflights'/f'check_{time.time_ns()}';preflight.mkdir(parents=True)
            probe_argv = sandbox_command(attempt,plan,['/usr/bin/true'],readonly)
            try:
                probe = _spawn(probe_argv,attempt,preflight/'stdout.bin',preflight/'stderr.bin',15,limits['memory_bytes'])
            except OSError as error:
                report['reason'] = 'sandbox_setup_unavailable'
                report['sandbox_preflight'] = {'error_type':type(error).__name__,'argv':probe_argv}
                return _report(runtime,report)
            report['sandbox_preflight'] = {**probe,'argv':probe_argv}
            if probe['returncode'] != 0 or probe['timeout']:
                report['reason'] = 'sandbox_setup_unavailable'
                report['diagnostic_view'] = _safe_tail(preflight/'stderr.bin')
                return _report(runtime,report)
            report['sandbox'].update(network_disabled=True,network_isolation=True,filesystem_isolation=True,setup_verified=True)
        else:
            report['host_profile_validation']={'authorization_verified':True,'native_preflight_subprocess':False}
            report['sandbox']['setup_verified']=True
        # Freeze the launch binding before any study process, never overwrite it.
        for binding in inputs:
            if sha(binding['path']) != binding['sha256']:raise ValueError('Input changed during sandbox preflight')
        if sha(plan_path) != plan_hash:raise ValueError('Plan changed during sandbox preflight')
        if not _matches(report['runtime_policy']):raise ValueError('Runtime policy changed during sandbox preflight')
        if profile=='host' and not _matches(report['host_execution_authorization']):raise ValueError('Host authorization changed before launch')
        intent = {'attempt_id':plan['attempt_id'],'created_at':now(),'plan_path':str(plan_path),
                  'plan_sha256':plan_hash,'runner_sha256':sha(__file__),'inputs':inputs,'runtime_policy':plan['_runtime_policy_record'],
                  'status':'scientific_launch_sequence_reserved','scope':'One irreversible launch reservation; any later failure remains an attempt and may not be retried here.'}
        intent['execution_profile']=profile
        if profile=='host':intent['host_execution_authorization']=report['host_execution_authorization']
        intent_hash = _write(runtime/'intent.json',intent,exclusive=True)
        (runtime/'intent.json').chmod(0o444)
        report['intent'] = {'path':str(runtime/'intent.json'),'sha256':intent_hash}
        report['status']='running';_report(runtime,report)
        outcomes = {}
        deadline = time.monotonic()+limits['wall_seconds']
        for stage in stages:
            sid=stage['id'];folder=runtime/'stages'/sid;folder.mkdir(parents=True)
            current={'id':sid,'required':stage['required'],'source_entry_points':stage['source_entry_points'],
                     'status':'blocked','returncode':None,'timeout':False,'native_error_detected':False,
                     'outputs':[],'native_logs':[],'cwd':str(stage['_cwd']),
                     'script':{'path':str(stage['_script']),'sha256':stage['script_sha256']}}
            if any(outcomes.get(parent) != 'succeeded' for parent in stage['depends_on']):
                current.update(status='skipped',reason='dependency_did_not_succeed')
            elif time.monotonic() >= deadline:
                current.update(reason='attempt_wall_budget_exhausted')
            else:
                try:
                    if sha(stage['_script']) != stage['script_sha256']:
                        raise ValueError('Working script changed before native launch')
                    for binding in inputs:
                        if sha(binding['path']) != binding['sha256']:
                            raise ValueError('Immutable input changed before native launch')
                    if profile=='host' and not _matches(report['host_execution_authorization']):
                        raise ValueError('Host authorization changed before native launch')
                    argv,automatic_log,launcher = _native_command(stage,attempt,folder,limits)
                    generated_logs=[automatic_log] if automatic_log else []
                    if launcher:generated_logs += [Path(launcher[key]) for key in ('receipt_log','capture_log') if key in launcher]
                    logs=list(dict.fromkeys([*stage['_logs'],*generated_logs]))
                    targets=list(dict.fromkeys([*stage['_outputs'],*logs]))
                    previous={str(path):_identity(path) for path in targets}
                    # Quarantine only working-copy outputs, never the source inputs.
                    archived=[]
                    for number,path in enumerate(targets):
                        if previous[str(path)] is not None:
                            saved=folder/'preexisting'/f'{number:03d}_{path.name}';saved.parent.mkdir(exist_ok=True)
                            if saved.exists():raise ValueError('Unexpected prior output quarantine')
                            path.rename(saved);saved.chmod(0o444)
                            archived.append({'original_path':str(path),**_record_file(saved)})
                    current['preexisting_artifacts']=archived
                    if launcher:current['launcher']=launcher
                    sandboxed=sandbox_command(attempt,plan,argv,readonly,cwd=stage['_cwd']) if profile=='bwrap' else argv
                    current.update(argv=argv,execution_profile=profile)
                    if profile=='bwrap':current['sandbox_argv']=sandboxed
                    else:current['environment']=environment
                    _write(folder/'command.json',{**current,'recorded_at':now()},exclusive=True)
                    report['active_stage']=sid;_report(runtime,report)
                    remaining=max(0.01,deadline-time.monotonic())
                    def started(value):
                        current['process']=value
                        _write(folder/'process.json',value,exclusive=True)
                    options={'environment':environment} if profile=='host' else {}
                    process=_spawn(sandboxed,stage['_cwd'],folder/'stdout.bin',folder/'stderr.bin',remaining,limits['memory_bytes'],on_start=started,**options)
                    current.update(process)
                    for path in stage['_outputs']:
                        after=_identity(path)
                        current['outputs'].append({'path':str(path),'before_sha256':(previous[str(path)] or {}).get('sha256'),
                            'after_sha256':after['sha256'] if after else None,'bytes':after['bytes'] if after else None,
                            'fresh':after is not None})
                    for number,path in enumerate(logs):
                        if path.exists():
                            _plain(path)
                            saved=folder/f'native_{number:03d}{path.suffix or ".log"}'
                            shutil.copy2(path,saved)
                            current['native_logs'].append({'native_path':str(path),**_record_file(saved)})
                    native_failure=False
                    if stage['language']=='stata':
                        markers,error_codes=_stata_status([Path(x['path']) for x in current['native_logs']])
                        native_failure=not markers or markers[-1] != 0
                        current['stata_completion_code']=markers[-1] if markers else None
                        current['stata_reported_error_codes']=error_codes
                    elif stage['language']=='r':
                        native_failure=_error_in_stream(folder/'stderr.bin',re.compile(rb'^(?:Error(?: in\b|:)|Execution halted\b)'))
                    elif stage['language']=='matlab':
                        pattern=re.compile(rb'^(?:Error using\b|Error in\b|MATLAB:)')
                        native_failure=any(_error_in_stream(folder/name,pattern) for name in ('stdout.bin','stderr.bin'))
                    current['native_error_detected']=native_failure
                    current['log_only_verified']=False
                    if stage['log_only']:
                        candidates=[Path(x['path']) for x in current['native_logs']] if stage['language']=='stata' else [folder/'stdout.bin']
                        marker_proof,contributing=_result_markers(candidates,stage['success_markers'])
                        current['result_log_markers']=marker_proof
                        current['log_only_verified']=bool(contributing) and not marker_proof['missing'] and not native_failure and process['returncode']==0 and not process['timeout']
                        if current['log_only_verified']:
                            current['outputs'] += [{'path':str(path),'kind':'native_result_log','before_sha256':None,
                                'after_sha256':sha(path),'bytes':path.stat().st_size,'fresh':True} for path in contributing]
                    outputs_ok=bool(current['outputs']) and all(item['fresh'] and item['bytes']>0 for item in current['outputs'])
                    if stage['log_only']:outputs_ok=outputs_ok and current['log_only_verified']
                    current['status']='succeeded' if (process['returncode']==0 and not process['timeout'] and not native_failure and outputs_ok) else 'failed'
                    if not outputs_ok:current['output_failure']='missing_declared_fresh_outputs' if stage['_outputs'] else 'no_expected_outputs_declared'
                    current['diagnostic_view']=_safe_tail(folder/'stderr.bin')
                    if sha(stage['_script']) != stage['script_sha256']:
                        current.update(status='failed',reason='working_script_changed_during_run')
                except (OSError,ValueError,subprocess.SubprocessError) as error:
                    current.update(status='failed',error_type=type(error).__name__,reason='controlled_stage_failure')
                    for name in ('stdout','stderr'):
                        p=folder/(name+'.bin')
                        if p.is_file() and not p.is_symlink():current[name]=_record_file(p)
            outcomes[sid]=current['status'];report['stages'].append(current)
            report['active_stage']=None
            _write(folder/'result.json',current,exclusive=True)
            _report(runtime,report)
        report['original_inputs_unchanged']=all(_matches(x) for x in inputs)
        report['launch_intent_unchanged']=_matches({'path':str(runtime/'intent.json'),'sha256':intent_hash})
        report['plan_unchanged']=_matches({'path':str(plan_path),'sha256':plan_hash})
        report['runtime_policy_unchanged']=_matches(report['runtime_policy'])
        if profile=='host':report['host_execution_authorization_unchanged']=_matches(report['host_execution_authorization'])
        required=[item for item in report['stages'] if item['required']]
        complete=bool(required) and all(item['status']=='succeeded' for item in required)
        integrity=report['original_inputs_unchanged'] and report['launch_intent_unchanged'] and report['plan_unchanged'] and report['runtime_policy_unchanged'] and report.get('host_execution_authorization_unchanged',True)
        successes=sum(item['status']=='succeeded' for item in report['stages'])
        report['declared_stages_verified']=complete and integrity
        report['execution_verified']=complete and integrity and not report['scope_gaps']
        report['status']='completed' if report['execution_verified'] else 'partial' if successes and integrity else 'failed'
        report['finished_at']=now()
        return _report(runtime,report)


def status(attempt):
    attempt=_plain(attempt)
    path=attempt/'runtime/run.json'
    if not path.is_file():
        return {'status':'not_run','launch_reserved':(attempt/'runtime/intent.json').exists()}
    value=_json(path)
    return {key:value.get(key) for key in ('attempt_id','status','execution_verified','original_inputs_unchanged','started_at','finished_at','updated_at','reason')}


def main():
    parser=argparse.ArgumentParser(description=__doc__,formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''Plan v1 (freeze under ATTEMPT/frozen; pin runtime policy in work_item.json):
  {"schema_version":"1.0","attempt_id":"ID",
   "sandbox":{"profile":"bwrap","executable":"/usr/bin/bwrap","read_only_paths":[]},
   "limits":{"wall_seconds":3600,"memory_bytes":8589934592,"threads":2},
   "inputs":[{"path":"inputs/data","sha256":"64 lowercase hex characters"}],
   "stages":[{"id":"main","language":"r","executable":"/usr/bin/Rscript",
     "script":"work/main.R","script_sha256":"64 lowercase hex characters","cwd":"work",
     "args":[],"depends_on":[],"required":true,"source_entry_points":["original.R"],
     "expected_outputs":["work/table.txt"],"native_logs":[]}],"scope_gaps":[]}
Log-only stage: expected_outputs [], log_only true, success_markers with at least
2 distinct source-reviewed estimation-result tokens. Mandatory frozen controller
policy controls executable, readonly roots, limits and Stata ado paths. No host fallback.
Explicit MATLAB host mode instead requires sandbox {"profile":"host","read_only_paths":[]}
and a frozen user authorization; it has normal user filesystem/network access.
Commands: run --attempt ATTEMPT --plan FROZEN_PLAN; status --attempt ATTEMPT.''')
    commands=parser.add_subparsers(dest='command',required=True)
    p=commands.add_parser('run');p.add_argument('--attempt',required=True);p.add_argument('--plan',required=True)
    p=commands.add_parser('status');p.add_argument('--attempt',required=True)
    args=parser.parse_args()
    try:
        value=run(args.attempt,args.plan) if args.command=='run' else status(args.attempt)
    except (OSError,ValueError,KeyError) as error:
        parser.exit(2,f'Runner refused: {type(error).__name__}: {error}\n')
    # Raw command/stream/native log bodies remain in the attempt, not this output.
    print(json.dumps({key:value.get(key) for key in ('attempt_id','status','execution_verified','original_inputs_unchanged','reason')},ensure_ascii=False))


if __name__=='__main__':main()
