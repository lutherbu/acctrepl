#!/usr/bin/env python3
"""Read bounded, screened text from a registered frozen author-analysis attempt.

Read-only. This is a practical credential screen, not proof that a file is public.
Source selectors are original package-relative paths; work/log selectors are
attempt-relative paths. No data-file or arbitrary historical-log interface exists.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import sys

MAX_BYTES = 8 * 1024 * 1024
MAX_ROWS = 200
MAX_LINE = 65536
TEXT_SUFFIXES = {'.do', '.ado', '.r', '.rmd', '.m', '.py', '.md', '.txt',
                 '.tex', '.html', '.htm', '.rst', '.sh', '.sas'}
SOURCE_SUFFIXES = TEXT_SUFFIXES | {'.pdf', '.doc', '.docx', '.rtf', '.ipynb'}
SECRET = re.compile(
    r'(?i)(?:\b(?:password|passwd|pwd|secret|api[_-]?key|access[_-]?token|'
    r'refresh[_-]?token|client[_-]?secret|auth[_-]?token|authorization)\b'
    r'[\s\"\']*(?:=|:|<-)|'
    r'\b(?:global|local|%let)\s+\w*(?:password|passwd|secret|token|api_key)\w*\s+|'
    r'\b(?:bearer|basic)\s+[A-Za-z0-9+/_.=-]{8,}|'
    r'https?://[^\s/@:]+:[^\s/@]+@|'
    r'https?://\S*[?&](?:token|key|api_key|password|secret|access_token)=|'
    r'\b(?:sk-[A-Za-z0-9_-]{12,}|gh[pousr]_[A-Za-z0-9_]{15,})\b)')
LICENSE = re.compile(r'(?i)^\s*(?:\*\s*)?(?:serial(?:\s+number)?|license[ -]?(?:key|id|number)|'
                     r'licensee|licensed\s+to|registered\s+to)\s*[:=]')


class ViewError(ValueError):
    pass


def plain(path, *, directory=False):
    path = Path(path).absolute()
    if any(p.is_symlink() for p in (path, *path.parents)):
        raise ViewError('Symbolic links are not permitted')
    path = path.resolve()
    if directory and not path.is_dir():
        raise ViewError('Expected a plain directory')
    if not directory and not path.is_file():
        raise ViewError('Expected a plain file')
    return path


def digest(path):
    h = hashlib.sha256()
    with plain(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1048576), b''):
            h.update(block)
    return h.hexdigest()


def pinned(ref):
    path = plain(ref['path'])
    if digest(path) != ref.get('sha256'):
        raise ViewError('Pinned file hash changed')
    return path


def metadata(path):
    path = plain(path)
    if path.stat().st_size > MAX_BYTES:
        raise ViewError('Metadata exceeds byte limit')
    def pairs(rows):
        out = {}
        for key, value in rows:
            if key in out:
                raise ViewError('Duplicate metadata key')
            out[key] = value
        return out
    return json.loads(path.read_text(encoding='utf-8'), object_pairs_hook=pairs)


def relative(value):
    if not isinstance(value, str) or not value or '\\' in value or any(ord(c) < 32 for c in value):
        raise ViewError('Use an unambiguous relative selector')
    p = Path(value)
    if p.is_absolute() or '..' in p.parts or '.' in p.parts or str(p) != value:
        raise ViewError('Use a normalized relative selector')
    return p


def inside(root, value):
    root = plain(root, directory=True)
    path = plain(root / relative(value))
    if not path.is_relative_to(root):
        raise ViewError('File escapes assigned root')
    return path


def tree_hash(root):
    root = plain(root, directory=True)
    h = hashlib.sha256()
    for p in sorted(root.rglob('*')):
        if p.is_symlink():
            raise ViewError('Snapshot contains a symbolic link')
        if p.is_file() and '__pycache__' not in p.parts and p.suffix != '.pyc':
            h.update(str(p.relative_to(root)).encode()); h.update(b'\0')
            h.update(digest(p).encode()); h.update(b'\n')
    return h.hexdigest()


def context(attempt):
    attempt = plain(attempt, directory=True)
    item_path = plain(attempt / 'work_item.json')
    item = metadata(item_path)
    if not isinstance(item, dict) or not item.get('campaign_root') or not item.get('attempt_id'):
        raise ViewError('Invalid frozen work item identity')
    campaign = metadata(Path(item['campaign_root']) / 'campaign.json')
    record = campaign.get('attempts', {}).get(item.get('attempt_id'), {})
    if record.get('directory') != str(attempt) or item.get('directory') != str(attempt):
        raise ViewError('Attempt is not registered at this directory')
    if digest(item_path) != record.get('work_item_sha256'):
        raise ViewError('Frozen work item changed')
    if tree_hash(attempt / 'skill_snapshot') != record.get('skill_sha256'):
        raise ViewError('Frozen reader skill changed')
    refs = item.get('frozen_files', [])
    for ref in refs:
        p = pinned(ref)
        if not p.is_relative_to(attempt / 'frozen'):
            raise ViewError('Frozen metadata must be inside this attempt')
    unit_path = attempt / 'frozen/unit.json'
    if str(unit_path) not in {r['path'] for r in refs} or metadata(unit_path) != item.get('unit'):
        raise ViewError('Frozen unit does not match the work item')
    unit = item['unit']
    if unit.get('package_id') != item.get('package_id') or unit.get('package_root') != item.get('input_root'):
        raise ViewError('Package identity does not match')
    return attempt, item, record


def source_file(item_path, selector):
    item_path = plain(item_path)
    if item_path.name != 'work_item.json':
        raise ViewError('Source requires the frozen work_item.json')
    attempt, item, record = context(item_path.parent)
    relative(selector)
    matches = [r for r in item['unit'].get('source_records', []) if r.get('path') == selector]
    if len(matches) != 1:
        raise ViewError('Source is not in the frozen source inventory')
    source = matches[0]
    if source.get('kind') not in {'code', 'document'} or Path(selector).suffix.lower() not in SOURCE_SUFFIXES:
        raise ViewError('Source is not an allowed code/document type')
    original = inside(item['input_root'], selector)
    if str(original) != source.get('original_path') or digest(original) != source.get('sha256'):
        raise ViewError('Original source identity or hash changed')
    source_item_ref = item.get('source_work_item', {})
    if source_item_ref not in item.get('frozen_files', []):
        raise ViewError('Source metadata is not frozen')
    old = metadata(pinned(source_item_ref))
    if old.get('package_root') != item['input_root']:
        raise ViewError('Source metadata belongs to a different package')
    old_records = [r for r in old.get('sources', []) if r.get('path') == selector]
    keys = ('path', 'sha256', 'original_path', 'content_path', 'content_sha256', 'kind')
    if len(old_records) != 1 or any(old_records[0].get(k) != source.get(k) for k in keys):
        raise ViewError('Source inventory pins disagree')
    cache_root = plain(Path(item['input_root']).parent / 'reading', directory=True)
    cached = plain(source['content_path'])
    expected = cache_root / (selector + '.txt')
    if cached != expected or not cached.is_relative_to(cache_root):
        raise ViewError('Only the original parsed-text cache is permitted')
    if digest(cached) != source.get('content_sha256'):
        raise ViewError('Cached source hash changed')
    return attempt, item, cached, {'original_sha256': source['sha256']}


def selected_file(mode, attempt, selector):
    attempt, item, record = context(attempt)
    path = inside(attempt, selector)
    if mode == 'work':
        if not path.is_relative_to(attempt / 'work') or path.suffix.lower() not in TEXT_SUFFIXES:
            raise ViewError('Working view permits only text code/documents under work')
        if path.suffix.lower() == '.txt':
            staged_path = attempt / 'staging.json'
            staged = metadata(staged_path).get('files', []) if staged_path.exists() else []
            sources = {r['original_path'] for r in item['unit'].get('source_records', [])
                       if r.get('kind') in {'code', 'document'}}
            if not any(r.get('staged_path') == str(path) and r.get('original_path') in sources for r in staged):
                raise ViewError('Unregistered text data are not source code')
        return attempt, item, path, {}
    if not path.is_relative_to(attempt / 'runtime'):
        raise ViewError('Log view is confined to this attempt runtime')
    receipt_path = plain(attempt / 'runtime/run.json')
    if record.get('runtime_receipt'):
        if pinned(record['runtime_receipt']) != receipt_path:
            raise ViewError('Runtime receipt belongs to a different attempt')
    receipt = metadata(receipt_path)
    if receipt.get('attempt_id') != item['attempt_id']:
        raise ViewError('Runtime receipt identity mismatch')
    reviews = record.get('plan_reviews', [])
    if not reviews or receipt.get('plan_sha256') != reviews[-1].get('plan', {}).get('sha256'):
        raise ViewError('Runtime log requires the approved plan receipt')
    candidates = []
    for stage in receipt.get('stages', []):
        candidates.extend(stage.get(k) for k in ('stdout', 'stderr') if isinstance(stage.get(k), dict))
        candidates.extend(stage.get('native_logs', []))
    preflight = receipt.get('sandbox_preflight', {})
    candidates.extend(preflight.get(k) for k in ('stdout', 'stderr') if isinstance(preflight.get(k), dict))
    matches = [r for r in candidates if r.get('path') == str(path)]
    if not matches or any(r.get('sha256') != digest(path) for r in matches):
        raise ViewError('File is not an unchanged captured runtime log')
    return attempt, item, path, {'receipt_sha256': digest(receipt_path)}


def screen(lines, suffix):
    """Mask complete logical contexts containing clear credential/license signals.

    A deliberately conservative small lexer extends candidates across balanced
    brackets, multiline quoted strings/comments and explicit continuations.
    Unclosed contexts are withheld through EOF and identified as uncertain.
    """
    masks = {}; limits = []; start = 1; quote = None; block = False; brackets = []
    candidate = False; uncertain = False
    single_quotes = suffix.lower() not in {'.do', '.ado', '.sas'}
    for number, line in enumerate(lines, 1):
        candidate = candidate or bool(SECRET.search(line) or LICENSE.search(line))
        i = 0
        while i < len(line):
            tail = line[i:]
            if block:
                if tail.startswith('*/'): block = False; i += 2
                else: i += 1
                continue
            if quote:
                if tail.startswith(quote): i += len(quote); quote = None
                elif line[i] == '\\' and suffix.lower() in {'.py', '.r', '.rmd'}: i += 2
                else: i += 1
                continue
            if tail.startswith('/*'): block = True; i += 2; continue
            if tail.startswith('"""') or (single_quotes and tail.startswith("'''")):
                quote = tail[:3]; i += 3; continue
            c = line[i]
            if c == '"' or (c == "'" and single_quotes): quote = c
            elif c in '([{': brackets.append(c)
            elif c in ')]}':
                if brackets and '([{'.index(brackets[-1]) == ')]}'.index(c): brackets.pop()
            elif c == '#' and suffix.lower() in {'.py', '.r', '.rmd'}: break
            elif c == '%' and suffix.lower() == '.m': break
            i += 1
        continuation = line.rstrip().endswith(('\\', '///', '...')) or (
            candidate and line.rstrip().endswith(('=', ':', '<-', '+', ',')))
        if not quote and not block and not brackets and not continuation:
            if candidate:
                for n in range(start, number + 1): masks[n] = 'credential_or_personal_license_context'
            start = number + 1; candidate = False
    if candidate:
        for n in range(start, len(lines) + 1): masks[n] = 'credential_context_uncertain_end'
        uncertain = True
    # Stata licenses commonly print a second, deeply indented institution line.
    # Withhold that continuation as part of the personal-license context.
    for index, line in enumerate(lines):
        if re.match(r'(?i)^\s*(?:licensed\s+to|licensee|registered\s+to)\s*[:=]', line):
            indent = len(line) - len(line.lstrip())
            for next_index in range(index + 1, len(lines)):
                next_line = lines[next_index]
                if not next_line.strip() or len(next_line) - len(next_line.lstrip()) <= indent:
                    break
                masks[next_index + 1] = 'personal_license_continuation'
    if uncertain: limits.append('Unclosed credential context was withheld through end of text; its complete boundary is uncertain.')
    return masks, limits


def view(mode, *, item=None, attempt=None, file, begin=1, end=None, deny=()):
    end = begin + 79 if end is None else end
    if type(begin) is not int or type(end) is not int or begin < 1 or end < begin or end - begin + 1 > MAX_ROWS:
        raise ViewError('Line window must contain 1 to 200 rows with positive bounds')
    if mode == 'source':
        attempt, frozen, path, extra = source_file(item, file)
        suffix = Path(file).suffix
    elif mode in {'work', 'log'}:
        attempt, frozen, path, extra = selected_file(mode, attempt, file)
        suffix = path.suffix if mode == 'work' else '.txt'
    else:
        raise ViewError('Unknown view mode')
    if path.stat().st_size > MAX_BYTES:
        raise ViewError('Text exceeds 8 MiB reader limit')
    data = path.read_bytes()
    if b'\0' in data:
        raise ViewError('Binary/NUL text is not displayed')
    try: text = data.decode('utf-8-sig')
    except UnicodeDecodeError:
        # Original parsers may preserve legacy Stata/R byte encodings.
        text = data.decode('cp1252', errors='replace')
    lines = text.splitlines()
    masks, limits = screen(lines, suffix)
    fixed = [r for r in frozen.get('reader_denied_ranges', []) if r.get('mode') == mode and r.get('file') == file]
    intervals = [(r.get('begin'), r.get('end')) for r in fixed] + list(deny)
    for lo, hi in intervals:
        if type(lo) is not int or type(hi) is not int or lo < 1 or hi < lo:
            raise ViewError('Invalid denied line range')
        for number in range(max(lo, begin), min(hi, end, len(lines)) + 1):
            masks[number] = 'coordinator_denied_range'
    rows = []
    for number in range(begin, min(end, len(lines)) + 1):
        line = lines[number - 1]
        reason = masks.get(number)
        if len(line.encode('utf-8')) > MAX_LINE: reason = 'line_exceeds_64_KiB_limit'
        rows.append({'line': number, 'text': '[WITHHELD]' if reason else line,
                     'withheld': bool(reason), **({'reason': reason} if reason else {})})
    return {'mode': mode, 'attempt_id': frozen['attempt_id'], 'package_id': frozen['package_id'],
            'file': file, 'sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data),
            'requested_range': {'begin': begin, 'end': end}, 'total_lines': len(lines),
            'rows': rows, 'coverage_limits': limits,
            'screening_note': 'Clear credential/license contexts are withheld; ordinary paths are retained. Withholding does not prove a statement is inactive. This screen is not a public-release determination.', **extra}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_subparsers(dest='mode', required=True)
    for mode in ('source', 'work', 'log'):
        p = modes.add_parser(mode)
        p.add_argument('--item' if mode == 'source' else '--attempt', required=True)
        p.add_argument('--file', required=True)
        p.add_argument('--begin', type=int, default=1)
        p.add_argument('--end', type=int, help='Last row inclusive; default begin+79, maximum 200 rows')
        p.add_argument('--deny', action='append', default=[], metavar='BEGIN:END', help='Additional range to withhold')
    args = vars(parser.parse_args(argv))
    try:
        args['deny'] = [tuple(int(x) for x in value.split(':')) for value in args['deny']]
        if any(len(pair) != 2 for pair in args['deny']): raise ViewError('Invalid denied range')
        result = view(**args)
    except (ValueError, KeyError, TypeError, OSError) as exc:
        # Do not echo arbitrary path/metadata/parser content in error messages.
        message = str(exc) if isinstance(exc, ViewError) else 'Invalid or unavailable reader metadata/file'
        print(json.dumps({'error': message})); return 2
    print(json.dumps(result, ensure_ascii=True)); return 0


if __name__ == '__main__':
    sys.exit(main())
