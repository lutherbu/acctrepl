"""Bounded SPSS Workbook syntax projection; stored output strings stay opaque.

This is a static reader for the observed workbookViewer.json layout, not an SPSS
interpreter. Only document[].paragraph.syntax.content strings are unescaped.
The original .spwb remains the program and native edit target.
"""
from __future__ import annotations

import hashlib
import io
from pathlib import Path, PurePosixPath
import re
import stat
import zipfile
import zlib

MAX_ARCHIVE_BYTES = 64 * 1024 * 1024
MAX_JSON_BYTES = 16 * 1024 * 1024
MAX_SYNTAX_BYTES = 4 * 1024 * 1024
MAX_MEMBERS = 1000
MAX_NODES = 200000
MAX_DEPTH = 64
MEMBER = 'workbookViewer.json'
LAYOUT = 'document[].paragraph.syntax.content'

# A whole native syntax paragraph is withheld on a credential/remote-command
# candidate. That deliberately avoids guessing multiline statement/comment ends.
# This conservative screen is not a certification that all other text is secret-free.
AUTH_CANDIDATE = re.compile(
    rb'(?i)\b(?:password|passwd|pwd|secret|api[_-]?key|access[_-]?token|refresh[_-]?token|'
    rb'authorization|credentials?|user[_-]?name)\b\s*(?:=|:|\()|'
    rb'\b(?:connect|connection|signon|rsubmit|ssh|scp|rsync|curl|wget)\b|'
    rb'https?://[^\s/@:]+:[^\s/@]+@')
HTML_MARKUP = re.compile(rb'(?i)<\s*/?\s*(?:html|body|head|pre|p|div|span|br)\b|&lt;')
NUMBER = re.compile(rb'-?(?:0|[1-9][0-9]*)(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?')


def _sha(data):
    return hashlib.sha256(data).hexdigest()


class _Node:
    __slots__ = ('kind', 'start', 'end', 'children')
    def __init__(self, kind, start, end, children=None):
        self.kind, self.start, self.end, self.children = kind, start, end, children


class _ByteJson:
    """Validate JSON structure while retaining string tokens as opaque spans."""
    def __init__(self, data):
        self.data = data
        self.position = 3 if data.startswith(b'\xef\xbb\xbf') else 0
        self.nodes = 0

    def _space(self):
        while self.position < len(self.data) and self.data[self.position] in b' \r\n\t':
            self.position += 1

    def _peek(self):
        if self.position >= len(self.data):
            raise ValueError('Incomplete workbook JSON structure')
        return self.data[self.position]

    def _string(self):
        start = self.position
        if self._peek() != 34:
            raise ValueError('Workbook JSON key/string type mismatch')
        self.position += 1
        while self.position < len(self.data):
            c = self.data[self.position]
            self.position += 1
            if c == 34:
                return _Node('string', start, self.position)
            if c == 92:
                c = self._peek()
                self.position += 1
                if c == 117:
                    if not re.fullmatch(rb'[0-9a-fA-F]{4}', self.data[self.position:self.position+4]):
                        raise ValueError('Invalid workbook JSON Unicode escape')
                    self.position += 4
                elif c not in b'"\\/bfnrt':
                    raise ValueError('Invalid workbook JSON string escape')
            elif c < 32:
                raise ValueError('Invalid workbook JSON string control byte')
        raise ValueError('Unterminated workbook JSON string')

    def _value(self, depth=0):
        if depth > MAX_DEPTH:
            raise ValueError('Workbook JSON depth limit')
        self.nodes += 1
        if self.nodes > MAX_NODES:
            raise ValueError('Workbook JSON node limit')
        self._space()
        start, c = self.position, self._peek()
        if c == 34:
            return self._string()
        if c == 123:
            self.position += 1
            self._space()
            children = {}
            if self._peek() != 125:
                while True:
                    self._space()
                    token = self._string()
                    key = self.data[token.start+1:token.end-1]
                    # Literal keys make selection unambiguous. In particular,
                    # escaped duplicate aliases cannot smuggle a second syntax key.
                    if len(key) > 256 or b'\\' in key or key in children:
                        raise ValueError('Ambiguous or oversized workbook JSON key')
                    self._space()
                    if self._peek() != 58:
                        raise ValueError('Invalid workbook JSON object separator')
                    self.position += 1
                    children[key] = self._value(depth+1)
                    self._space()
                    if self._peek() == 125:
                        break
                    if self._peek() != 44:
                        raise ValueError('Invalid workbook JSON object separator')
                    self.position += 1
            self.position += 1
            return _Node('object', start, self.position, children)
        if c == 91:
            self.position += 1
            self._space()
            children = []
            if self._peek() != 93:
                while True:
                    children.append(self._value(depth+1))
                    self._space()
                    if self._peek() == 93:
                        break
                    if self._peek() != 44:
                        raise ValueError('Invalid workbook JSON array separator')
                    self.position += 1
            self.position += 1
            return _Node('array', start, self.position, children)
        while self.position < len(self.data) and self.data[self.position] not in b',]} \r\n\t':
            self.position += 1
        raw = self.data[start:self.position]
        if raw not in (b'true', b'false', b'null') and not NUMBER.fullmatch(raw):
            raise ValueError('Invalid workbook JSON scalar')
        return _Node('scalar', start, self.position)

    def parse(self):
        node = self._value()
        self._space()
        if self.position != len(self.data):
            raise ValueError('Trailing workbook JSON content')
        return node


def _utf8(codepoint):
    """Encode an integer codepoint directly, without decoding source text."""
    if codepoint <= 0x7f:
        return bytes([codepoint])
    if codepoint <= 0x7ff:
        return bytes([0xc0 | codepoint >> 6, 0x80 | codepoint & 0x3f])
    if codepoint <= 0xffff:
        return bytes([0xe0 | codepoint >> 12, 0x80 | codepoint >> 6 & 0x3f, 0x80 | codepoint & 0x3f])
    return bytes([0xf0 | codepoint >> 18, 0x80 | codepoint >> 12 & 0x3f,
                  0x80 | codepoint >> 6 & 0x3f, 0x80 | codepoint & 0x3f])


def _syntax_bytes(data, node):
    """Unescape ONLY a structurally selected syntax token into screenable bytes."""
    raw = data[node.start+1:node.end-1]
    result = bytearray()
    short = {34:b'"', 92:b'\\', 47:b'/', 98:b'\b', 102:b'\f', 110:b'\n', 114:b'\r', 116:b'\t'}
    i = 0
    while i < len(raw):
        if raw[i] != 92:
            result.append(raw[i]); i += 1
            continue
        i += 1
        code = raw[i]; i += 1
        if code != 117:
            result.extend(short[code])
            continue
        cp = int(raw[i:i+4], 16); i += 4
        if 0xd800 <= cp <= 0xdbff:
            if raw[i:i+2] != b'\\u':
                raise ValueError('Unpaired syntax Unicode surrogate')
            second = int(raw[i+2:i+6], 16); i += 6
            if not 0xdc00 <= second <= 0xdfff:
                raise ValueError('Unpaired syntax Unicode surrogate')
            cp = 0x10000 + ((cp-0xd800) << 10) + second-0xdc00
        elif 0xdc00 <= cp <= 0xdfff:
            raise ValueError('Unpaired syntax Unicode surrogate')
        result.extend(_utf8(cp))
    return bytes(result)


def _viewer_member(archive_bytes):
    """Check all member metadata, decompress only the named JSON member."""
    with zipfile.ZipFile(io.BytesIO(archive_bytes)) as zipped:
        infos = zipped.infolist()
        if len(infos) > MAX_MEMBERS:
            raise ValueError('Workbook archive member limit')
        seen, total = set(), 0
        selected = None
        for info in infos:
            name = info.filename.replace('\\', '/')
            parts = PurePosixPath(name)
            mode = info.external_attr >> 16
            if (not name or parts.is_absolute() or '..' in parts.parts or '\0' in name
                    or re.match(r'^[A-Za-z]:', name) or name in seen):
                raise ValueError('Unsafe or duplicate workbook archive member')
            if stat.S_IFMT(mode) not in (0, stat.S_IFREG, stat.S_IFDIR) or info.flag_bits & 1:
                raise ValueError('Encrypted, linked or special workbook member')
            seen.add(name)
            total += info.file_size
            if total > MAX_ARCHIVE_BYTES:
                raise ValueError('Workbook declared uncompressed-byte limit')
            if name == MEMBER:
                selected = info
        if selected is None or selected.file_size > MAX_JSON_BYTES:
            raise ValueError('Missing or oversized workbook viewer member')
        with zipped.open(selected) as source:
            data = source.read(MAX_JSON_BYTES+1)
        if len(data) != selected.file_size or len(data) > MAX_JSON_BYTES:
            raise ValueError('Workbook viewer actual size mismatch')
        if zlib.crc32(data) & 0xffffffff != selected.CRC:
            raise ValueError('Workbook viewer CRC mismatch')
        return data, {'member': MEMBER, 'bytes': len(data), 'sha256': _sha(data), 'crc32': selected.CRC,
                      'archive_members': len(infos), 'unread_other_members': len(infos)-1}


def read_spwb(path, expected_sha256=None):
    """Return syntax text, native paragraph locations, warnings and metadata only.

    Output/rich-text/summary strings are never decoded. Credential candidates
    cause an entire syntax paragraph to be withheld before UTF-8 text decoding.
    Unknown layouts are explicit incomplete inspections, never evidence of no code.
    """
    path = Path(path)
    metadata = {'method':'static_spwb_selective_syntax_tokens', 'layout':LAYOUT, 'status':'unverified',
                'syntax_paragraphs':[], 'nonempty_syntax_paragraphs':0,
                'output_strings_decoded':False, 'author_code_executed':False}
    warnings = []
    try:
        if not path.is_file() or any(p.is_symlink() for p in (path, *path.parents)):
            raise ValueError('Workbook source is not a plain file')
        if path.stat().st_size > MAX_ARCHIVE_BYTES:
            raise ValueError('Workbook archive input-byte limit')
        original = path.read_bytes()
        original_hash = _sha(original)
        metadata['source_sha256'] = original_hash
        if expected_sha256 is not None and original_hash != expected_sha256:
            raise ValueError('Workbook original hash mismatch')
        data, member = _viewer_member(original)
        metadata['viewer_member'] = member
        parser = _ByteJson(data)
        root = parser.parse()
        if root.kind != 'object':
            raise ValueError('Unsupported workbook root layout')
        document = root.children.get(b'document')
        if document is None or document.kind != 'array':
            raise ValueError('Unsupported workbook document layout')
        lines, locations, total_syntax, output_groups, skipped = [], {}, 0, 0, 0
        for index, entry in enumerate(document.children):
            if entry.kind != 'object':
                raise ValueError('Unsupported workbook document node')
            paragraph = entry.children.get(b'paragraph')
            if paragraph is None:
                skipped += 1
                continue
            if paragraph.kind != 'object':
                raise ValueError('Unsupported workbook paragraph node')
            output = paragraph.children.get(b'output')
            if output is not None:
                if output.kind != 'array':
                    raise ValueError('Unsupported workbook output layout')
                output_groups += len(output.children)
            syntax = paragraph.children.get(b'syntax')
            if syntax is None:
                skipped += 1
                continue
            if syntax.kind != 'object' or set(syntax.children)-{b'content',b'description',b'visible'}:
                raise ValueError('Unsupported workbook syntax layout')
            content = syntax.children.get(b'content')
            if content is None or content.kind != 'string':
                raise ValueError('Unsupported workbook syntax content')
            raw = _syntax_bytes(data, content)
            total_syntax += len(raw)
            if total_syntax > MAX_SYNTAX_BYTES or b'\0' in raw:
                raise ValueError('Workbook syntax byte/integrity limit')
            if HTML_MARKUP.search(raw):
                raise ValueError('Rich markup in workbook syntax needs a supported converter')
            source_lines = raw.replace(b'\r\n',b'\n').replace(b'\r',b'\n').split(b'\n')
            denied = bool(AUTH_CANDIDATE.search(raw))
            if raw.strip():
                metadata['nonempty_syntax_paragraphs'] += 1
            pointer = f'/document/{index}/paragraph/syntax/content'
            lines.append(f'[SPWB syntax paragraph {index}; native location in source metadata]')
            locations[str(len(lines))] = {'program_kind':'syntax_boundary','member':MEMBER,
                                          'paragraph_index':index,'json_pointer':pointer}
            first = len(lines)+1
            for lineno, value in enumerate(source_lines, 1):
                # Full candidate paragraph excluded BEFORE any source text decode.
                lines.append('[WITHHELD SPWB syntax paragraph: credential/remote candidate]' if denied
                             else value.decode('utf-8'))
                locations[str(len(lines))] = {'program_kind':'spss_syntax','member':MEMBER,
                    'paragraph_index':index,'json_pointer':pointer,'syntax_line':lineno,'withheld':denied}
            metadata['syntax_paragraphs'].append({'paragraph_index':index,'json_pointer':pointer,
                'json_token_sha256':_sha(data[content.start:content.end]),'syntax_bytes_sha256':_sha(raw),
                'syntax_bytes':len(raw),'syntax_lines':len(source_lines),'cache_line_begin':first,
                'cache_line_end':len(lines),'withheld':denied})
        if _sha(path.read_bytes()) != original_hash:
            raise ValueError('Workbook changed during static inspection')
        metadata.update(status='ok', json_nodes=parser.nodes, excluded_output_groups=output_groups,
                        skipped_non_syntax_document_nodes=skipped)
        if skipped:
            warnings.append('Non-syntax workbook paragraphs were excluded; no output or rich text was read as code')
        if any(p['withheld'] for p in metadata['syntax_paragraphs']):
            warnings.append('Whole syntax paragraphs containing credential/remote candidates were withheld; coverage is incomplete')
        if not metadata['syntax_paragraphs']:
            warnings.append('No syntax nodes in supported layout; other native workbook content remains uninspected')
        warnings.append('Static syntax projection only; native SPSS runtime, stored outputs and data contents are not validated')
        return ('\n'.join(lines)+'\n' if lines else ''), locations, warnings, metadata
    except (OSError, ValueError, RuntimeError, zipfile.BadZipFile, NotImplementedError, KeyError, UnicodeError) as exc:
        metadata['error_type'] = type(exc).__name__
        metadata['error'] = 'Static SPWB syntax inspection incomplete; original workbook is not proved to lack code'
        return '', {}, [metadata['error']], metadata
