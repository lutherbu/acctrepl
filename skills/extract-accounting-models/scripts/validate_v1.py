#!/usr/bin/env python3
"""Validate model extractions and literal page evidence; makes no model calls."""
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


def evidence_items(value, path=''):
    if isinstance(value, dict):
        if set(value) == {'page', 'quote'}:
            yield path, value
        else:
            for key, child in value.items():
                yield from evidence_items(child, f'{path}/{key}')
    elif isinstance(value, list):
        for i, child in enumerate(value):
            yield from evidence_items(child, f'{path}/{i}')


def validate(data, paper=None, sample_record=None):
    sp = SKILL / 'references/output.v1.schema.json'
    mp = SKILL / 'references/regression_methods.json'
    schema = json.loads(sp.read_text())
    schema['$id'] = sp.as_uri()
    registry = Registry().with_resource(mp.as_uri(), Resource.from_contents(json.loads(mp.read_text())))
    errors = [f"{'/'.join(map(str, e.absolute_path))}: {e.message}" for e in
              jsonschema.Draft202012Validator(schema, registry=registry).iter_errors(data)]
    if errors:
        return errors
    models = data['models']
    ids = [m['model_id'] for m in models]
    if len(ids) != len(set(ids)):
        errors.append('model_id must be unique within paper')
    by_id = {m['model_id']: m for m in models}
    empty_status = data['status'] in ('no_baseline_regression', 'text_unavailable')
    if empty_status and models:
        errors.append('No-baseline/unavailable status requires models=[]')
    if not empty_status and not any(m['model_role'] == 'baseline' for m in models):
        errors.append('An extraction requires at least one baseline model')
    if empty_status and not data['review_notes']:
        errors.append('Empty result needs a review note explaining what was unavailable or checked')
    sample_ids = None
    if sample_record is not None:
        if sample_record['paper_id'] != data['paper_id']:
            errors.append('Sample record paper_id mismatch')
        sample_ids = {s['sample_id'] for s in sample_record['samples']}
    needs_review = False
    for m in models:
        mid = m['model_id']
        ev = m['evidence']
        missing = m['missing_fields']
        if 'equation_coverage' in missing:
            needs_review = True
        if not ev['scope']:
            errors.append(f'{mid}: scope requires evidence')
        if sample_ids is not None and m['sample_id'] is not None and m['sample_id'] not in sample_ids:
            errors.append(f'{mid}: unknown sample_id')
        for key in ('method', 'sample_description', 'sample_size'):
            if m[key] is None and key not in missing:
                errors.append(f'{mid}: missing {key} needs a reason')
        if m['method'] is None:
            needs_review = True
        elif not ev['method']:
            errors.append(f'{mid}: method requires evidence')
        if m['method'] == 'other' and not (m['method_reported'] and m['method_details'].strip()):
            errors.append(f'{mid}: other method requires reported name and details')
        if m['equation_text'] is not None and not ev['equation']:
            errors.append(f'{mid}: equation requires evidence')
        if (m['sample_description'] is not None or m['sample_size'] is not None) and not ev['sample']:
            errors.append(f'{mid}: sample requires evidence')
        if m['sample_size'] is not None:
            q = ' '.join(e['quote'] for e in ev['sample'])
            q = re.sub(r'(?<=\d)\s*,\s*(?=\d{3}(?:\D|$))', '', q)
            if not re.search(r'(?<!\d)' + str(m['sample_size']) + r'(?!\d)', q):
                errors.append(f'{mid}: sample_size not found as a numeral in sample evidence')
        terms = [('dependent_variable', m['dependent_variable'])] + [
            (f'independent_variables[{i}]', v) for i, v in enumerate(m['independent_variables'])]
        names = [flat(v['name']) for v in m['independent_variables']]
        if len(names) != len(set(names)):
            errors.append(f'{mid}: duplicate RHS term name')
        for path, v in terms:
            if v['name'] == 'UNKNOWN':
                errors.append(f'{mid}/{path}: unfinished variable name')
            if v['definition'] is None:
                needs_review = True
                if f'{path}.definition' not in missing:
                    errors.append(f'{mid}: missing {path}.definition needs a reason')
            if not v['evidence']:
                errors.append(f'{mid}/{path}: variable requires evidence even if its definition is missing')
        s = m['specifications']
        for key in ('fixed_effects', 'standard_errors', 'intercept', 'weights'):
            block = s[key]
            status = block['status']
            if status == 'unclear':
                needs_review = True
                if not (m['review_notes'] or any(k.startswith(f'specifications.{key}') for k in missing)):
                    errors.append(f'{mid}: unclear {key} needs explanation')
            if status in ('reported', 'none') and not block['evidence']:
                errors.append(f'{mid}/{key}: reported/explicitly absent setting requires evidence')
        fe = s['fixed_effects']
        if bool(fe['groups']) != (fe['status'] == 'reported'):
            errors.append(f'{mid}: fixed-effect groups inconsistent with status')
        se = s['standard_errors']
        if (se['method'] is not None) != (se['status'] == 'reported'):
            errors.append(f'{mid}: standard-error method inconsistent with status')
        if se['cluster_groups'] and se['method'] not in ('cluster_robust', 'bootstrap', 'other'):
            errors.append(f'{mid}: cluster groups require an applicable inference method')
        if se['method'] == 'cluster_robust' and not se['cluster_groups']:
            if 'specifications.standard_errors.cluster_groups' not in missing:
                errors.append(f'{mid}: unspecified cluster dimension needs a missing_fields reason')
            needs_review = True
        intercept = s['intercept']
        if (intercept['included'] is not None) != (intercept['status'] == 'reported'):
            errors.append(f'{mid}: intercept value inconsistent with status')
        weights = s['weights']
        if (weights['description'] is not None) != (weights['status'] == 'reported'):
            errors.append(f'{mid}: weighting description inconsistent with status')
        proc = s['estimation_procedure']
        if (proc['description'] is not None or proc['grouping_variables']) and not proc['evidence']:
            errors.append(f'{mid}: estimation procedure requires evidence')
        if proc['grouping_variables'] and proc['description'] is None:
            errors.append(f'{mid}: estimation grouping needs description')
        for category in ('preprocessing', 'other'):
            for statement in s[category]:
                if not statement['evidence']:
                    errors.append(f'{mid}/{category}: statement requires evidence')
        for loc in m['locations']:
            if loc['page_end'] < loc['page_begin']:
                errors.append(f'{mid}: reversed location pages')
            if not (loc['table'] or loc['equation']):
                errors.append(f'{mid}: location must identify a table or equation (use a descriptive identifier if unnumbered)')
        dep_ids = [d['model_id'] for d in m['dependencies']]
        if len(dep_ids) != len(set(dep_ids)):
            errors.append(f'{mid}: duplicate dependency')
        if dep_ids and not ev['dependencies']:
            errors.append(f'{mid}: dependencies require evidence')
        for dep in dep_ids:
            if dep not in by_id or dep == mid:
                errors.append(f'{mid}: invalid dependency {dep}')
    visited, active, reached = set(), set(), set()
    def visit(mid):
        if mid in active:
            errors.append('Model dependencies contain a cycle')
            return
        if mid in visited or mid not in by_id:
            return
        active.add(mid)
        reached.add(mid)
        for d in by_id[mid]['dependencies']:
            visit(d['model_id'])
        active.remove(mid)
        visited.add(mid)
    for m in models:
        if m['model_role'] == 'baseline':
            visit(m['model_id'])
    for m in models:
        if m['model_role'] == 'supporting' and m['model_id'] not in reached:
            errors.append(f"{m['model_id']}: supporting model is not required by a baseline")
    if needs_review and data['status'] == 'complete':
        errors.append('Unresolved method, variable definition or unclear setting requires needs_review')
    if paper is not None:
        if data['paper_id'] != paper['paper_id']:
            errors.append('Paper ID differs from reading copy')
        pages = {p['page']: flat(p['text']) for p in paper['pages']}
        for path, ev in evidence_items(data):
            if ev['page'] not in pages or flat(ev['quote']) not in pages[ev['page']]:
                errors.append(f'{path}: quote not found on physical page {ev["page"]}')
        for m in models:
            for loc in m['locations']:
                if loc['page_begin'] not in pages or loc['page_end'] not in pages:
                    errors.append(f"{m['model_id']}: location page absent from reading copy")
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('result', type=Path)
    parser.add_argument('--paper-text', type=Path)
    parser.add_argument('--samples', type=Path, help='Original sample-extraction JSON or JSONL; validates sample links.')
    args = parser.parse_args()
    try:
        data = json.loads(args.result.read_text())
        paper = json.loads(args.paper_text.read_text()) if args.paper_text else None
        sample = None
        if args.samples:
            content = args.samples.read_text()
            if args.samples.suffix == '.jsonl':
                matches = [r for line in content.splitlines() if line.strip()
                           if (r := json.loads(line)).get('paper_id') == data['paper_id']]
            else:
                matches = [json.loads(content)]
            if len(matches) != 1:
                raise ValueError('Expected exactly one matching sample-extraction record')
            sample = matches[0]
        errors = validate(data, paper, sample)
    except (OSError, ValueError, KeyError, TypeError) as exc:
        errors = [str(exc)]
    print(json.dumps({'valid': not errors, 'errors': errors}, ensure_ascii=False, indent=2))
    return 1 if errors else 0


if __name__ == '__main__':
    sys.exit(main())
