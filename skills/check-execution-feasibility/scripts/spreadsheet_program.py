"""Bounded OOXML program inspection; never evaluates cells or refreshes pivots.

Only formula text, locations, pivot definitions and source-range metadata are
emitted. Cell values, shared strings/items and pivot-cache records are not output.
No relationship target is dereferenced outside the ZIP container.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import stat
import xml.etree.ElementTree as ET
import zipfile

DEFAULT_LIMITS = {
    'archive_bytes': 32 * 1024**2,
    'members': 10000,
    'archive_declared_bytes': 256 * 1024**2,
    'member_bytes': 16 * 1024**2,
    'selected_xml_bytes': 64 * 1024**2,
    'formulas': 25000,
    'pivots': 500,
    'output_chars': 2 * 1024**2,
}


class InspectionLimit(ValueError):
    pass


def _local(tag):
    return tag.rsplit('}', 1)[-1]


def _relationship_id(node):
    return next((v for k, v in node.attrib.items() if _local(k) == 'id'), None)


def _part(owner, target):
    """Resolve an internal OOXML part name without opening a filesystem path."""
    if (not isinstance(target, str) or '\\' in target or target.startswith('//')
            or re.match(r'^[A-Za-z][A-Za-z0-9+.-]*:', target)):
        raise ValueError('Unsupported OOXML relationship target')
    start = [] if target.startswith('/') else list(PurePosixPath(owner).parent.parts)
    for piece in target.split('/'):
        if piece in ('', '.'):
            continue
        if piece == '..':
            if not start:
                raise ValueError('OOXML relationship escapes container')
            start.pop()
        else:
            start.append(piece)
    return '/'.join(start)


def spreadsheet_text(path, limits=None):
    """Return static reading text, per-line program locations, and limitations.

    A plain data-only workbook yields a negative inspection summary, not program
    locations. Partial inspection is explicitly marked; zero extracted formulas
    after an error is not proof that the workbook has no program.
    """
    path = Path(path)
    if set(limits or {}) - set(DEFAULT_LIMITS):
        raise ValueError('Unknown workbook inspection limit')
    bounds = {**DEFAULT_LIMITS, **(limits or {})}
    if any(not isinstance(v, int) or v < 1 for v in bounds.values()):
        raise ValueError('Workbook inspection limits must be positive integers')
    if bounds['output_chars'] < 2048:
        raise ValueError('Workbook output limit must reserve at least 2048 characters')
    lines = []
    locations = {}
    warnings = []
    size = 0
    consumed = 0
    counts = {'formulas': 0, 'pivots': 0}
    partial = False
    relationship_types = {}
    inspected_pivots = set()

    def emit(kind, payload, location=None):
        nonlocal size
        line = kind + ' ' + json.dumps(payload, ensure_ascii=False, sort_keys=True)
        if size + len(line) + 1 > bounds['output_chars'] - 1024:
            raise InspectionLimit('Workbook reading text limit reached')
        lines.append(line)
        size += len(line) + 1
        if location:
            locations[str(len(lines))] = location

    try:
        if path.stat().st_size > bounds['archive_bytes']:
            raise InspectionLimit('Workbook archive file-size limit reached')
        emit('XLSX_STATIC_INSPECTION', {
            'original_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
            'method': 'Static formula and pivot-definition XML only; no evaluation or refresh',
            'omitted': 'Cached cell values, shared-string values/items and pivot-cache records',
            'external_links': 'Never dereferenced',
        })
        with zipfile.ZipFile(path) as archive:
            infos = archive.infolist()
            if len(infos) > bounds['members']:
                raise InspectionLimit('Workbook ZIP member-count limit reached')
            if sum(i.file_size for i in infos) > bounds['archive_declared_bytes']:
                raise InspectionLimit('Workbook ZIP declared-byte limit reached')
            index = {}
            for info in infos:
                if info.filename in index:
                    raise ValueError('Duplicate workbook ZIP member')
                mode = info.external_attr >> 16
                if (stat.S_IFMT(mode) not in (0, stat.S_IFREG, stat.S_IFDIR)
                        or info.flag_bits & 1):
                    raise ValueError('Link, special or encrypted workbook member')
                if info.filename.startswith('/') or '..' in PurePosixPath(info.filename).parts or '\\' in info.filename:
                    raise ValueError('Unsafe workbook ZIP member name')
                index[info.filename] = info

            def xml(part):
                nonlocal consumed
                if re.search(r'(?:^|/)pivotCacheRecords[^/]*\.xml$', part, re.I):
                    raise ValueError('Pivot-cache row records are never read')
                info = index.get(part)
                if info is None:
                    raise ValueError('Referenced workbook XML part is absent')
                if info.file_size > bounds['member_bytes']:
                    raise InspectionLimit('Workbook XML member-size limit reached')
                if consumed + info.file_size > bounds['selected_xml_bytes']:
                    raise InspectionLimit('Workbook selected-XML byte limit reached')
                with archive.open(info) as stream:
                    raw = stream.read(bounds['member_bytes'] + 1)
                if len(raw) > bounds['member_bytes']:
                    raise InspectionLimit('Workbook actual XML member-size limit reached')
                consumed += len(raw)
                if consumed > bounds['selected_xml_bytes']:
                    raise InspectionLimit('Workbook actual selected-XML byte limit reached')
                # OOXML is normally UTF-8. Reject alternate NUL-based encodings
                # and all DTD/entity declarations before the XML parser sees them.
                if b'\x00' in raw or re.search(br'<!\s*(?:DOCTYPE|ENTITY)\b', raw, re.I):
                    raise ValueError('Unsupported XML encoding or DTD/entity declaration')
                return ET.fromstring(raw)

            def relationships(owner):
                name = str(PurePosixPath(owner).parent / '_rels' / (PurePosixPath(owner).name + '.rels'))
                if name not in index:
                    return {}
                result = {}
                for node in xml(name):
                    if _local(node.tag) != 'Relationship':
                        continue
                    if node.get('TargetMode', '').lower() == 'external':
                        continue
                    rid = node.get('Id')
                    if not rid or rid in result:
                        raise ValueError('Invalid or duplicate workbook relationship ID')
                    result[rid] = _part(owner, node.get('Target', ''))
                    relationship_types[(owner, rid)] = node.get('Type', '')
                return result

            workbook = xml('xl/workbook.xml')
            if _local(workbook.tag) != 'workbook':
                raise ValueError('Workbook root XML is not a workbook')
            rels = relationships('xl/workbook.xml')
            caches = {node.get('cacheId'): rels.get(_relationship_id(node))
                      for node in workbook.iter() if _local(node.tag) == 'pivotCache'}
            cache_sources = {}
            for sheet in (x for x in workbook.iter() if _local(x.tag) == 'sheet'):
                sheet_name = sheet.get('name', '')
                part = rels.get(_relationship_id(sheet))
                if not part:
                    raise ValueError('Worksheet relationship is absent or external')
                tree = xml(part)
                if _local(tree.tag) != 'worksheet':
                    warnings.append('Non-worksheet sheet part was not inspected for formulas')
                    partial = True
                    continue
                for cell in (x for x in tree.iter() if _local(x.tag) == 'c'):
                    formula = next((x for x in cell if _local(x.tag) == 'f'), None)
                    if formula is None:
                        continue
                    if counts['formulas'] >= bounds['formulas']:
                        raise InspectionLimit('Workbook formula-count limit reached')
                    emit('FORMULA', {'sheet': sheet_name, 'cell': cell.get('r'),
                                     'formula_attributes': dict(formula.attrib),
                                     'expression': formula.text or ''},
                         {'program_kind': 'formula', 'sheet': sheet_name,
                          'cell': cell.get('r'), 'part': part})
                    counts['formulas'] += 1
                sheet_rels = relationships(part)
                pivot_parts = []
                for node in (x for x in tree.iter() if _local(x.tag) == 'pivotTablePart'):
                    pivot_part = sheet_rels.get(_relationship_id(node))
                    if not pivot_part:
                        raise ValueError('Pivot-table relationship is absent or external')
                    pivot_parts.append(pivot_part)
                # Excel commonly links pivots solely through worksheet .rels,
                # without a pivotTablePart element in the worksheet body.
                pivot_parts.extend(target for rid,target in sheet_rels.items()
                                   if relationship_types.get((part,rid),'').endswith('/pivotTable'))
                for pivot_part in dict.fromkeys(pivot_parts):
                    if counts['pivots'] >= bounds['pivots']:
                        raise InspectionLimit('Workbook pivot-count limit reached')
                    pivot = xml(pivot_part)
                    if _local(pivot.tag) != 'pivotTableDefinition':
                        raise ValueError('Pivot part has no pivot-table definition')
                    fields = []
                    location = {}
                    for child in pivot:
                        name = _local(child.tag)
                        if name == 'location':
                            location = dict(child.attrib)
                        elif name in {'rowFields', 'colFields', 'dataFields', 'pageFields'}:
                            fields.extend({'group': name, 'attributes': dict(field.attrib)} for field in child)
                    cache_id = pivot.get('cacheId')
                    cache_part = caches.get(cache_id)
                    if cache_id not in cache_sources and cache_part:
                        definition = xml(cache_part)
                        source = next((x for x in definition if _local(x.tag) == 'cacheSource'), None)
                        cache_sources[cache_id] = (None if source is None else {
                            'attributes': dict(source.attrib),
                            'worksheet_sources': [dict(x.attrib) for x in source
                                                  if _local(x.tag) == 'worksheetSource']})
                    emit('PIVOT_DEFINITION', {'sheet': sheet_name, 'part': pivot_part,
                         'name': pivot.get('name'), 'cache_id': cache_id, 'location': location,
                         'fields': fields, 'cache_source': cache_sources.get(cache_id)},
                         {'program_kind': 'pivot_table', 'sheet': sheet_name,
                          'part': pivot_part, 'pivot_name': pivot.get('name'),
                          'cell_range': location.get('ref')})
                    counts['pivots'] += 1
                    inspected_pivots.add(pivot_part)
            known_pivots = {name for name in index if name.startswith('xl/pivotTables/')
                            and name.endswith('.xml') and '/_rels/' not in name}
            if known_pivots - inspected_pivots:
                partial = True
                warnings.append('Unlinked pivot-definition parts remain uninspected; code presence/closure is uncertain')
    except (InspectionLimit, ValueError, OSError, KeyError, ET.ParseError, zipfile.BadZipFile,
            NotImplementedError, RuntimeError) as exc:
        partial = True
        # Generic parser errors must not echo cell values or XML payloads.
        warnings.append(str(exc) if isinstance(exc, InspectionLimit) else
                        type(exc).__name__ + ': incomplete workbook program inspection')
    summary = {'extracted_formulas': counts['formulas'], 'extracted_pivots': counts['pivots'],
               'partial': partial, 'count_scope': 'inspected parts only' if partial else 'all worksheet formula/pivot parts',
               'shared_array_formulas': 'Original attributes retained; never expanded or evaluated',
               'omitted': 'Cached values, cache items/records, external-link dereferencing and calculation'}
    # A bounded final status is essential even when the ordinary output limit hit.
    status = 'INSPECTION_STATUS ' + json.dumps(summary, sort_keys=True)
    assert len(status) + 1 <= 1024
    lines.append(status)
    return '\n'.join(lines) + '\n', locations, warnings
