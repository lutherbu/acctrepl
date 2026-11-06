#!/usr/bin/env python3
"""Validate schema, sample semantics and source-text traceability; no model calls."""
import argparse
import json
from pathlib import Path

# Resolve frozen artifact locations without rewriting research records.
_layout_root = Path(__file__).resolve().parents[3]
_layout = None
if (_layout_root / "project_layout.py").is_file():
    import sys as _layout_sys
    _layout_sys.path.insert(0, str(_layout_root))
    import project_layout as _layout
    Path = _layout.path_class(_layout_root)
import re
import sys
import unicodedata
import jsonschema
from referencing import Registry, Resource

SKILL = Path(__file__).resolve().parents[1]


def flat(text):
    return re.sub(r'\s+', ' ', unicodedata.normalize('NFKC', text)).strip()


def letters(text):
    return re.sub(r'[^a-z0-9]', '', flat(text).lower())


def number_words(n):
    small = ['zero','one','two','three','four','five','six','seven','eight','nine',
             'ten','eleven','twelve','thirteen','fourteen','fifteen','sixteen',
             'seventeen','eighteen','nineteen']
    tens = ['', '', 'twenty','thirty','forty','fifty','sixty','seventy','eighty','ninety']
    if n < 20:
        return small[n]
    if n < 100:
        return tens[n // 10] + (number_words(n % 10) if n % 10 else '')
    if n < 1000:
        return small[n // 100] + 'hundred' + (number_words(n % 100) if n % 100 else '')
    return ''


def number_supported(n, quote):
    # PDF math layers may space commas as in "1 , 386 , 813". Keep the
    # original tokenization too: a comma-separated list can contain valid Ns.
    # Requiring space before the comma avoids joining the list "545, 439".
    spaced = re.sub(r'(?<=\d)\s+,\s*(?=\d{3}(?:\D|$))', ',', quote)
    for text in (quote, spaced):
        digits = re.sub(r'(?<=\d),(?=\d)', '', text)
        if re.search(r'(?<!\d)' + str(n) + r'(?!\d)', digits):
            return True
    # A stated single-case design explicitly counts one case, even without a
    # printed digit or the word "one". PDF layers may merge the hyphenated word.
    if n == 1 and re.search(r'\bsingle[\s\-‐‑–—]*case\b', flat(quote), re.I):
        return True
    words = number_words(n)
    normalized = re.sub(r'\band\b', '', quote, flags=re.I)
    return bool(words and words in letters(normalized))


def validate(data, paper=None):
    schema_path = SKILL / 'references/output.schema.json'
    databases_path = SKILL / 'references/databases.json'
    schema = json.loads(schema_path.read_text())
    databases = json.loads(databases_path.read_text())
    # Resolve the local reference offline; the allowed names live in one file.
    schema['$id'] = schema_path.resolve().as_uri()
    registry = Registry().with_resource(databases_path.resolve().as_uri(), Resource.from_contents(databases))
    errors = [f"{'/'.join(map(str,e.absolute_path))}: {e.message}" for e in
              jsonschema.Draft202012Validator(schema, registry=registry).iter_errors(data)]
    if errors:
        return errors
    commercial = {name:databases.get('x-aliases',{}).get(name,[]) for name in databases['enum']}
    known_spellings = {letters(alias) for name,aliases in commercial.items() for alias in [name]+aliases}
    samples = data['samples']
    ids = [s['sample_id'] for s in samples]
    if len(set(ids)) != len(ids):
        errors.append('sample_id must be unique within a paper')
    if data['primary_sample_id'] is not None and data['primary_sample_id'] not in ids:
        errors.append('primary_sample_id does not reference a sample')
    if data['status'] in ('complete', 'needs_review') and not samples:
        errors.append('An empirical extraction must contain samples')
    if data['status'] in ('text_unavailable', 'no_empirical_sample') and samples:
        errors.append('Unavailable/nonempirical paper must not contain extracted samples')
    if data['status'] == 'text_unavailable' and (data['data_section_full_text'] or data['data_section_spans']):
        errors.append('Unavailable text must not contain a claimed data section')
    if data['data_section_status'] == 'complete' and not data['data_section_full_text']:
        errors.append('Complete data section cannot be empty')
    if data['data_section_full_text'] and not data['data_section_spans']:
        errors.append('Data-section text requires page spans')
    if data['data_section_status'] == 'partial' and data['status'] != 'needs_review':
        errors.append('Partial data section requires needs_review')
    for s in samples:
        sid = s['sample_id']
        period = s['sample_period']
        begin, end, years = period['begin'], period['end'], period['years']
        if (begin is None) != (end is None):
            errors.append(f'{sid}: sample period must have both endpoints or neither')
        if begin is not None and begin > end:
            errors.append(f'{sid}: reversed sample period')
        if years:
            if begin is None or years != sorted(set(years)) or years[0] != begin or years[-1] != end:
                errors.append(f'{sid}: years must be sorted, unique, and match endpoints')
            elif years == list(range(begin, end + 1)):
                errors.append(f'{sid}: consecutive coverage requires years=[]')
        for field in ('sample_size', 'sample_unit'):
            if s[field] is None and field not in s['missing_fields']:
                errors.append(f'{sid}: missing {field} needs a reason')
            if s[field] is not None and not s['evidence'][field]:
                errors.append(f'{sid}: non-null {field} needs evidence')
        if begin is None and 'sample_period' not in s['missing_fields']:
            errors.append(f'{sid}: unknown period needs a reason')
        if begin is not None and not s['evidence']['sample_period']:
            errors.append(f'{sid}: period needs evidence')
        if begin is not None:
            period_quotes = ' '.join(e['quote'] for e in s['evidence']['sample_period'])
            supported_years = {int(y) for y in re.findall(r'\b(?:1[5-9]\d{2}|20\d{2}|2100)\b', period_quotes)}
            # Some legacy PDF fonts decode a printed en dash as a closing brace.
            for m in re.finditer(r'\b((?:1[5-9]|20)\d{2})\s*(?:[-–—}]|to|through)\s*(\d{2}|(?:1[5-9]|20)\d{2})\b', period_quotes):
                first = int(m[1])
                last = int(m[2]) if len(m[2]) == 4 else first // 100 * 100 + int(m[2])
                if last < first and len(m[2]) == 2:
                    last += 100
                if first <= last <= 2100:
                    supported_years.update(range(first, last + 1))
            if not {begin, end, *years} <= supported_years:
                errors.append(f'{sid}: sample years lack support in period evidence')
        if s['sample_unit'] == 'other' and not s['sample_unit_detail']:
            errors.append(f'{sid}: other unit requires sample_unit_detail')
        sources = s['data_sources']
        size_quotes = ' '.join(e['quote'] for e in s['evidence']['sample_size'])
        for n in ([s['sample_size']] if s['sample_size'] is not None else []) + [a['sample_size'] for a in s['analysis_sizes']]:
            if not number_supported(n, size_quotes):
                errors.append(f'{sid}: sample count {n} is not supported by a quoted numeral or English number')
        any_sources = any(bool(v) for v in sources.values())
        if any_sources and not s['evidence']['data_sources']:
            errors.append(f'{sid}: sources require evidence')
        if not any_sources and 'data_sources' not in s['missing_fields']:
            errors.append(f'{sid}: no sources requires an explanation')
        if sources['unresolved'] and data['status'] != 'needs_review':
            errors.append(f'{sid}: unresolved sources require needs_review')
        source_quotes = ' '.join(e['quote'] for e in s['evidence']['data_sources'])
        for name in sources['commercial_standardized']:
            aliases = [name] + commercial[name]
            if not any(letters(a) in letters(source_quotes) for a in aliases):
                errors.append(f'{sid}: no quoted alias supports commercial source {name}')
        for name in sources['commercial_nonstandardized']:
            if letters(name) in known_spellings:
                errors.append(f'{sid}: standardized source incorrectly in nonstandardized: {name}')
        for name, url in sources['public'].items():
            if url is not None and re.sub(r'\s+', '', url) not in re.sub(r'\s+', '', source_quotes):
                errors.append(f'{sid}: public URL lacks verbatim quoted evidence: {name}')
    if paper is not None:
        pages = {p['page']: flat(p['text']) for p in paper['pages']}
        if data['paper_id'] != paper['paper_id']:
            errors.append('Result paper_id does not match reading copy')
        paper_doi = (paper.get('doi') or '').lower()
        if (data['doi'] or '').lower() != paper_doi:
            errors.append('Result DOI does not match reading copy')
        for s in samples:
            for field, evidence in s['evidence'].items():
                for e in evidence:
                    if e['page'] not in pages or flat(e['quote']) not in pages[e['page']]:
                        errors.append(f"{s['sample_id']}/{field}: quote not found on PDF page {e['page']}")
        previous_end = 0
        joined_blocks = []
        for span in data['data_section_spans']:
            begin, end = span['page_begin'], span['page_end']
            if end < begin or begin not in pages or end not in pages:
                errors.append('Data-section span has invalid page bounds')
                continue
            if begin < previous_end:
                errors.append('Data-section spans are not in paper order')
            previous_end = end
            for name, page in [('start_anchor', begin), ('end_anchor', end)]:
                if flat(span[name]) not in pages[page]:
                    errors.append(f'{name} not found on PDF page {page}')
            block = ' '.join(pages[p] for p in sorted(pages) if begin <= p <= end)
            start = block.find(flat(span['start_anchor']))
            finish = block.rfind(flat(span['end_anchor']))
            if start >= 0 and finish >= start:
                joined_blocks.append(block[start:finish + len(flat(span['end_anchor']))])
        if data['data_section_full_text'] and flat(data['data_section_full_text']) != flat(' '.join(joined_blocks)):
            errors.append('Full data-section text differs from its anchored source blocks')
    return errors


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('result', type=Path)
    ap.add_argument('--paper-text', type=Path)
    args = ap.parse_args()
    data = json.loads(args.result.read_text())
    paper = json.loads(args.paper_text.read_text()) if args.paper_text else None
    errors = validate(data, paper)
    print(json.dumps({'valid': not errors, 'errors': errors}, ensure_ascii=False, indent=2))
    sys.exit(bool(errors))
