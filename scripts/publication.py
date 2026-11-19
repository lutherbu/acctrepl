"""Prepare portable public copies and verify their retained byte identities."""
import contextlib
import ctypes
import errno
import fcntl
import hashlib
import json
import os
from pathlib import Path, PurePosixPath, PureWindowsPath
import re
import shutil
import tempfile

TEXT = {'.json', '.ipynb', '.md', '.do', '.sas', '.m', '.r', '.ado', '.py', '.log',
        '.lst', '.rtf', '.csv', '.tsv', '.tex', '.txt', '.html', '.sh', '.smcl'}
CODE = {'.do', '.sas', '.r', '.m', '.ado', '.py', '.sh'}
SYSTEM = ('Users|Volumes|Applications|Library|System|home|root|usr|bin|sbin|lib|lib64|opt|'
          'etc|dev|proc|sys|var|run|tmp|private|mnt|media|storage|sastmp|scratch|wrds|'
          'homedir|wrdslin|ifs|nvme|data|XXX|YOUR_DIRECTORY|path')
START = re.compile(
    r'(?P<url>(?:https?|ftp)://[^\s"\'<>`]+)|'
    r'(?<![\w.~/\\$@%}\])>-])(?P<path>file:/{2,3}|[a-zA-Z]:[\\/](?!/)|~[/\\]|'
    r'\\\\[\w.-]+\\(?=[A-Za-z0-9_$])|(?P<unc>//[\w.-]+/(?=[A-Za-z0-9_$]))|/(?:' + SYSTEM + r')(?=/|\b)|(?P<generic>/[\w.-]+(?=/[\w.-])))',
    re.IGNORECASE)
# A quoted absolute filename may contain blanks. Relative code fragments joined
# to a variable, URI paths, regexes, and mathematical division have different meaning.
SEGMENT = re.compile(r"""[^\s"'`<>|,;!?()[\]{}=*]+""")
DRIVE_OR_FILE = re.compile(r'^(?:file:|[A-Za-z]:|\\\\|//|~[/\\])', re.I)
MARK = re.compile(r'\[redacted-path-[0-9a-f]{12}\]')
AGENT = re.compile(r'/root/[\w.-]+(?:/[\w.-]+)*\Z')


def sha(file):
    with Path(file).open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()


def byte_hash(data):
    return hashlib.sha256(data).hexdigest()


def encode(doc):
    return (json.dumps(doc, indent=2, ensure_ascii=False, allow_nan=False) + '\n').encode()


def relative(value):
    p = PurePosixPath(value)
    if (not value or p.is_absolute() or PureWindowsPath(value).drive or '\\' in value
            or '..' in p.parts or not p.parts or '\x00' in value):
        raise ValueError(f'Expected a repository-relative path: {value}')
    return p.as_posix()


def inside(root, value):
    root = Path(root).resolve()
    path = root / relative(value)
    if path.resolve() != path:
        raise ValueError(f'Unexpected symlink in publication: {value}')
    return path


def _path_end(value, match):
    start, end = match.span('path')
    prefix = value[:start]
    quote = prefix[-1:] if prefix.endswith(("'", '"', '`')) else ''
    if quote:
        close = value.find(quote, end)
        if close >= 0 and '\n' not in value[end:close] and '\r' not in value[end:close]:
            return close
    rest = SEGMENT.match(value, end)
    if rest:
        end = rest.end()
    # In prose an unquoted directory component can have spaces, for example on
    # a mounted volume. Continue to the next separator within that component.
    while end < len(value) and value[end] in ' \t':
        extra = re.match(r'[ \t]+(?!(?:and|or|with|from|to|then|is|was|under)\b)(?:[\w.-]+[ \t]+){0,3}[\w.-]+[/\\][^\s"`\x27<>|,;!?()[\]{}=*]+',value[end:],re.I)
        if extra is None:
            break
        end += extra.end()
    while end > match.end() and value[end - 1] in '.:':
        end -= 1
    return end


class PublicPaths:
    def __init__(self, package, substitutes=()):
        self.package = package
        self.substitutes = sorted(((str(a).rstrip('/'), str(b).rstrip('/')) for a,b in substitutes),
                                  key=lambda pair: -len(pair[0]))

    def text(self, value, *, field='', literal=False):
        if field in ('agent','reviewer','review_agent','assigned_agent','approved_by') and AGENT.fullmatch(value):
            return value
        for old, new in self.substitutes:
            # Match a whole prefix, including occurrences in quoted commands.
            value = re.sub(re.escape(old) + r'(?=/|[\s"\'`),;]|$)', lambda _: new, value)
        if literal and re.fullmatch(r'/[\w.-]+(?:/[^\n\r]*)?',value) and not START.match(value):
            return '[redacted-path-' + byte_hash((self.package+'\0'+value).encode())[:12] + ']'
        result = []
        end = 0
        for m in START.finditer(value):
            if m.start() < end or m.lastgroup == 'url':
                continue
            start = m.start()
            pre = value[:start]
            if m.group('unc'):
                host = m.group('unc').split('/')[2]
                # Stata comments and protocol-relative web URLs share the double slash.
                if not (literal and start==0 or pre.endswith(('"',"'",'`')) or re.match(r'(?i)^(mac|client|server|nas|fileserver)',host)):
                    continue
            if m.group('generic') and not (literal and start==0 or re.search(
                    r"""(?:\b(?:cd|chdir|directory|folder|filename|file|located\s+(?:at|in)|stored\s+(?:at|in|under)|loaded\s+from|libname\s+\w+|use|open|read_csv|read_dta)|\bpath\s*[:=]?)\s*[(=:]?\s*["'`]?$""",pre[-160:],re.I)):
                continue
            if pre.endswith(':') and value[start:start+2]=='//':
                continue
            if (value[start]=='/' and not value[start:start+2]=='//' and
                    re.search(r"""(?:\+|paste0?\([^)\n]*,|\$[\w.]+|\`\w+')\s*["']?$""", pre[-160:], re.I)):
                continue
            # Forward slashes within ordinary protocol-relative web links.
            if not literal and value.startswith('//', start) and '.' in m.group().split('/')[2] and '/H$/' not in value[start:start+100]:
                continue
            stop = _path_end(value,m)
            if literal and start==0 and '\n' not in value and '\r' not in value:
                stop = len(value)
            raw = value[start:stop]
            spelling = raw.replace('\\','/')
            if DRIVE_OR_FILE.match(raw):
                spelling = spelling.rstrip('/').casefold()
            token = byte_hash((self.package + '\0' + spelling).encode())[:12]
            result.extend((value[end:start], '[redacted-path-' + token + ']'))
            end = stop
        return ''.join(result) + value[end:]

    def document(self, obj, field=''):
        if isinstance(obj, list):
            return [self.document(v,field) for v in obj]
        if isinstance(obj, dict):
            result = {}
            for k,v in obj.items():
                key = self.text(k, literal=(field in ('source_hashes','input_hashes','outputs')))
                if key in result:
                    raise ValueError('Path normalization produced duplicate JSON keys')
                result[key] = self.document(v,k)
            return result
        if isinstance(obj,str):
            return self.text(obj,field=field,literal=field in ('path','location','directory','artifact_path'))
        return obj

    def data(self, name, raw):
        suffix = Path(name).suffix.lower()
        if suffix not in TEXT:
            return raw
        if suffix in ('.json','.ipynb'):
            doc = json.loads(raw)
            clean = self.document(doc)
            if clean == doc:
                return raw
            if suffix=='.ipynb':
                for old,new in zip(doc['cells'],clean['cells']):
                    if old.get('cell_type')=='code':
                        verify_code(old['source'],new['source'],name)
            return encode(clean)
        text = raw.decode('utf-8', errors='surrogateescape')
        clean = self.text(text)
        if suffix in CODE:
            verify_code(text,clean,name)
        return clean.encode('utf-8', errors='surrogateescape')


def verify_code(original, public, name):
    # Redaction tokens are evidence annotations and must never become inputs to executable code.
    if original == public:
        return
    def lines(value):
        return (value if isinstance(value,str) else ''.join(value)).splitlines()
    suffix = Path(name).suffix.lower()
    stata = suffix in ('.ado','.do','.ipynb')
    sas = suffix=='.sas' or Path(name).name=='sas.ipynb'
    if sas:
        stata = False
    block_end = None
    for old,new in zip(lines(original),lines(public),strict=True):
        executable = []
        pos = 0
        quote = ''
        while pos < len(new):
            if block_end:
                stop = new.find(block_end,pos)
                if stop < 0:
                    break
                pos,block_end = stop+len(block_end),None
            elif quote:
                executable.append(new[pos])
                if new[pos]==quote:
                    quote = ''
                pos += 1
            elif new.startswith('/*',pos):
                block_end,pos = '*/', pos+2
            elif suffix=='.m' and new[pos:].startswith('%{') and not new[:pos].strip():
                block_end,pos = '%}', pos+2
            elif sas and new[pos]=='*' and not ''.join(executable).strip():
                block_end,pos = ';', pos+1
            elif ((stata and (new.startswith('//',pos) or new[pos]=='*' and not new[:pos].strip()))
                  or suffix in ('.r','.py','.sh') and new[pos]=='#' or suffix=='.m' and new[pos]=='%'):
                break
            else:
                char = new[pos]
                if char=='"' or char=="'" and not stata:
                    quote = char
                executable.append(char)
                pos += 1
        if old!=new and MARK.search(''.join(executable)):
            raise ValueError(f'Configure the executable path or supply a portable template: {name}: {old[:120]}')


def verify_source_quote(ev, sources):
    """Check an edited author quotation against its frozen, checksum-bound reading."""
    record = sources[ev['file']]
    path = Path(record['content_path'])
    if sha(path) != record['content_sha256']:
        raise ValueError(f"Frozen evidence changed: {ev['file']}")
    lines = path.read_text(encoding='utf-8').splitlines()
    begin, end = ev['line_begin'], ev['line_end']
    passage = ' '.join(' '.join(lines[begin-1:end]).split())
    if not (1 <= begin <= end <= len(lines)) or ' '.join(ev['quote'].split()) not in passage:
        raise ValueError(f"Evidence does not match its source lines: {ev['id']}")
    return {'id':ev['id'], 'source_sha256':record['content_sha256'],
            'quote_sha256':byte_hash(ev['quote'].encode()), 'line_begin':begin, 'line_end':end}


def receipt(folder, originals, *, quotes=()):
    """Bind original bytes and distributed copies without publishing private locators."""
    entries = {}
    for name,digest in sorted(originals.items()):
        current = sha(inside(folder,name))
        if current != digest:
            entries[name] = {'original_sha256':digest, 'public_sha256':current}
    if entries:
        doc = {'version':1, 'files':entries}
        if quotes:
            doc['source_quotes'] = list(quotes)
        (folder/'publication_receipt.json').write_bytes(encode(doc))


def exchange(left, right):
    """Use an atomic directory exchange when the host filesystem supports it."""
    rename = getattr(ctypes.CDLL(None,use_errno=True),'renameat2',None)
    if rename is None:
        return False
    rename.argtypes = (ctypes.c_int,ctypes.c_char_p,ctypes.c_int,ctypes.c_char_p,ctypes.c_uint)
    rename.restype = ctypes.c_int
    if rename(-100,os.fsencode(left),-100,os.fsencode(right),2)==0:  # AT_FDCWD, RENAME_EXCHANGE
        return True
    code = ctypes.get_errno()
    if code in (errno.ENOSYS,errno.EINVAL,errno.EOPNOTSUPP):
        return False
    raise OSError(code,os.strerror(code))


@contextlib.contextmanager
def staged_package(project, workflow, pid):
    """Serialize replacements, recover interrupted swaps, and retain previous versions privately."""
    if not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9_-]*',pid) or workflow not in ('executions','reproductions','replications','feasibility_execution'):
        raise ValueError('Invalid publication destination')
    root = Path(project).resolve()
    dest = inside(root,f'output/{workflow}/packages/{pid}')
    dest.parent.mkdir(parents=True,exist_ok=True)
    private = inside(root,f'.local/publications/{workflow}/{pid}')
    private.mkdir(parents=True,exist_ok=True)
    with (private/'publish.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        backup = private/'previous'
        if backup.exists() and not dest.exists():
            os.replace(backup,dest)
        with tempfile.TemporaryDirectory(prefix='stage-',dir=private) as tmp:
            stage = Path(tmp)/'package'
            stage.mkdir()
            yield stage
            verify_receipt(stage)
            if dest.exists() and same_tree(stage, dest):
                return
            if dest.exists():
                if backup.exists():
                    history = Path(tempfile.mkdtemp(prefix='superseded-',dir=private))
                    os.replace(backup,history/'package')
                if exchange(stage,dest):
                    try:
                        os.replace(stage,backup)
                    except BaseException:
                        exchange(stage,dest)
                        raise
                    return
                os.replace(dest,backup)
            try:
                os.replace(stage,dest)
            except BaseException:
                if backup.exists() and not dest.exists():
                    os.replace(backup,dest)
                raise



def same_tree(a, b):
    def files(root):
        return {(p.relative_to(root),p.is_dir()) for p in root.rglob('*')}
    current = files(a)
    return current == files(b) and all(sha(a/p) == sha(b/p) for p,is_dir in current if not is_dir)


def safe_regular(path):
    path = Path(path)
    if path.resolve() != path or not path.is_file():
        raise ValueError(f'Expected a regular, symlink-free source: {path}')
    return path


def transform_file(source, target, paths):
    safe_regular(source)
    target.parent.mkdir(parents=True, exist_ok=True)
    if source.suffix.lower() in TEXT:
        target.write_bytes(paths.data(source.name, source.read_bytes()))
    else:
        shutil.copyfile(source,target)


def verify_receipt(folder):
    path = folder/'publication_receipt.json'
    if path.exists():
        doc = json.loads(path.read_bytes())
        if doc.get('version') != 1 or not doc.get('files'):
            raise ValueError(f'Invalid publication receipt: {path}')
        quotes = doc.get('source_quotes',[])
        evidence = {r['id']:r for r in json.loads((folder/'assessment.json').read_bytes())['evidence']} if quotes else {}
        for proof in quotes:
            if (proof['id'] not in evidence or
                    byte_hash(evidence[proof['id']]['quote'].encode()) != proof['public_quote_sha256'] or
                    not re.fullmatch('[0-9a-f]{64}',proof['quote_sha256'])):
                raise ValueError(f'Published evidence quotation changed: {proof["id"]}')
        for name, entry in doc['files'].items():
            if (not re.fullmatch('[0-9a-f]{64}',entry['original_sha256'])
                    or sha(inside(folder,name)) != entry['public_sha256']):
                raise ValueError(f'Publication receipt mismatch: {path}, {name}')
