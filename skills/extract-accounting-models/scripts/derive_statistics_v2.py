#!/usr/bin/env python3
"""Merge reported results and calculate supported inference; no model calls.

JSON and JSONL are supported. Input files are never changed. A compact
2.0-enrichment input also requires --specifications (matching JSON or JSONL).
"""
from __future__ import annotations

import argparse
from copy import deepcopy
from decimal import Decimal, InvalidOperation
import hashlib
import json
import math
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

import scipy
from scipy.stats import norm, t


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def parse_number(text):
    value = unicodedata.normalize('NFKC', text).strip()
    value = value.replace('−', '-').replace('–', '-').replace('﹣', '-')
    value = re.sub(r'\s+', '', value)
    if value.startswith('(') and value.endswith(')'):
        value = value[1:-1]  # Statistical parentheses are enclosure, not a sign.
    value = value.rstrip('%*†‡')
    value = re.sub(r'(?<=\d),(?=\d{3}(?:\D|$))', '', value)
    value = re.sub(r'[×x]10\^?\(?([+-]?\d+)\)?$', r'e\1', value)
    if not re.fullmatch(r'[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?', value):
        raise ValueError(f'Not an unambiguous numeric cell: {text!r}')
    result = float(value)
    if not math.isfinite(result):
        raise ValueError('Numeric cells must be finite')
    return result


def number_cell(text):
    return {'text': str(text), 'value': parse_number(str(text))}


def printed_half_width(cell):
    value = unicodedata.normalize('NFKC', cell['text']).strip(' ()%*†‡').replace('−', '-').replace(',', '')
    try:
        return float(Decimal(10) ** Decimal(Decimal(value).as_tuple().exponent)) / 2
    except (InvalidOperation, ValueError):
        return 0.0


def p_cell(text):
    raw = str(text).strip()
    cleaned = raw.lower().replace('p', '').replace('≤', '<=').replace('≥', '>=')
    cleaned = cleaned.strip(' ()')
    match = re.fullmatch(r'(<=|>=|<|>|=)?\s*([\d.eE+-]+)', cleaned)
    if not match:
        raise ValueError('Use explicit lower/upper fields for a p-value interval')
    relation = {'<': 'lt', '<=': 'le', '>': 'gt', '>=': 'ge', '=': 'eq', None: 'eq'}[match[1]]
    value = parse_number(match[2])
    if not 0 <= value <= 1:
        raise ValueError('P-value outside [0,1]')
    if relation == 'eq' and value in (0, 1):
        relation = 'rounded_boundary'
    return {'text': raw, 'value': value, 'relation': relation, 'lower': None, 'upper': None}


def context(kind=None, alternative='unknown', df=None, null_value=0,
            null_basis='standard_zero_coefficient_test', evidence=None):
    is_wald = kind in ('t', 'z', 'wald_ratio')
    return {'type': 'wald' if is_wald else 'unknown',
            'null_value': null_value if is_wald else None,
            'null_basis': null_basis if is_wald else 'unknown',
            'alternative': alternative,
            'reference': {'t': 'student_t', 'z': 'normal'}.get(kind, 'unknown'),
            'degrees_of_freedom': df, 'wald_on_reported_scale': is_wald,
            'evidence': deepcopy(evidence or []), 'notes': ''}


def derive_parameter(parameter, default_context, legend=()):
    reported = parameter['reported']
    test = parameter['test'] or default_context
    result = {'normalized_estimate': None, 'normalized_standard_error': None,
              'standard_error': None, 'statistic': None, 'statistic_kind': None,
              'p_value': None, 'log_p_value': None, 'p_value_bound': None,
              'calculations': [], 'unavailable_reasons': {}, 'issues': [],
              'inputs_are_printed_values': True}
    missing = result['unavailable_reasons']
    b = reported['estimate']['value'] if reported['estimate'] else None
    se = reported['standard_error']['value'] if reported['standard_error'] else None
    stat = reported['statistic']['cell']['value'] if reported['statistic'] else None
    stat_kind = reported['statistic']['kind'] if reported['statistic'] else None
    p = reported['p_value']
    em, sm = parameter['estimate_multiplier'], parameter['standard_error_multiplier']
    if em <= 0 or sm <= 0:
        raise ValueError('Display multipliers must be positive')

    def calculated(field, value, formula, inputs):
        if value is not None and not math.isfinite(value):
            missing[field] = 'Calculation was nonfinite; no value was emitted.'
            return
        result[field] = value
        result['calculations'].append({'field': field, 'formula': formula, 'inputs': inputs})

    bn = b / em if b is not None else None
    sen = se / sm if se is not None else None
    if bn is not None:
        calculated('normalized_estimate', bn, 'reported_estimate / estimate_multiplier',
                   {'reported_estimate': b, 'estimate_multiplier': em})
    if sen is not None:
        if sen <= 0:
            result['issues'].append('Reported standard error is nonpositive; cannot invert it.')
            sen = None
        else:
            calculated('normalized_standard_error', sen, 'reported_standard_error / standard_error_multiplier',
                       {'reported_standard_error': se, 'standard_error_multiplier': sm})
    compatible = (test['type'] == 'wald' and test['wald_on_reported_scale']
                  and test['null_value'] is not None)
    if stat is not None and stat_kind not in ('t', 'z', 'wald_ratio'):
        compatible = False
        missing['statistic_identity'] = 'The reported statistic is not a signed t/z or Wald ratio; it cannot be used as estimate/SE.'
    if parameter['estimate_kind'] not in ('coefficient', 'standardized_coefficient'):
        compatible = compatible and test['null_basis'] == 'reported'
    delta = bn - test['null_value'] if bn is not None and test['null_value'] is not None else None
    if not compatible:
        missing['wald_identity'] = 'The Wald identity and null on this reported estimate scale are not established.'
    unsigned_stat = False
    if reported['statistic']:
        unsigned_stat = bool(re.search(r'\|.*(?:t|z).*\||absolute|unsigned',
                                      test['notes'], flags=re.I))
    sign_conflict = (compatible and delta is not None and stat is not None and delta != 0
                     and stat != 0 and delta * stat < 0 and not unsigned_stat)
    if sign_conflict:
        result['issues'].append('Estimate-minus-null and signed reported statistic have opposite signs.')
    if compatible and b is not None and se is not None and sen is not None and stat is not None:
        bw = printed_half_width(reported['estimate']) / em
        sw = printed_half_width(reported['standard_error']) / sm
        tw = printed_half_width(reported['statistic']['cell'])
        if sen > sw:
            possible = [(bn + bs * bw - test['null_value']) / (sen + ss * sw)
                        for bs in (-1, 1) for ss in (-1, 1)]
            if unsigned_stat:
                possible = [abs(x) for x in possible]
            if max(possible) < stat - tw - 1e-12 or min(possible) > stat + tw + 1e-12:
                result['issues'].append('Reported estimate, SE and statistic disagree beyond their printed rounding intervals.')
    if compatible and not sign_conflict:
        if stat is None and delta is not None and sen is not None:
            stat = delta / sen
            stat_kind = {'student_t': 't', 'normal': 'z'}.get(test['reference'], 'wald_ratio')
            calculated('statistic', stat, '(normalized_estimate - null) / normalized_standard_error',
                       {'normalized_estimate': bn, 'null': test['null_value'], 'normalized_standard_error': sen})
            result['statistic_kind'] = stat_kind
        if sen is None and delta is not None and stat is not None:
            if delta == 0 or stat == 0:
                missing['standard_error'] = 'A zero printed numerator or statistic cannot identify an inverse standard error.'
            else:
                sen = abs(delta / stat)
                calculated('normalized_standard_error', sen, 'abs((normalized_estimate - null) / statistic)',
                           {'normalized_estimate': bn, 'null': test['null_value'], 'statistic': stat})
                if reported['standard_error'] is None:
                    calculated('standard_error', sen * sm, 'normalized_standard_error * standard_error_multiplier',
                               {'normalized_standard_error': sen, 'standard_error_multiplier': sm})

    distribution = None
    if test['reference'] == 'normal':
        distribution = norm
    elif test['reference'] == 'student_t':
        df = test['degrees_of_freedom']
        if df is not None and df > 0:
            distribution = t(df)
        else:
            missing['p_value'] = 'Student-t degrees of freedom are unknown; normal approximation is disabled.'
    else:
        missing['p_value'] = 'The test reference distribution is unknown.'
    tail = test['alternative']
    if tail == 'unknown':
        missing['p_value'] = 'Test sidedness/direction is unknown.'
    marker = reported['significance_marker']
    if p is None and marker:
        matches = [entry for entry in legend if entry['marker'] == marker]
        if len(matches) == 1:
            result['p_value_bound'] = {'relation': matches[0]['relation'], 'value': matches[0]['p_threshold'],
                                     'from_marker': marker}
        else:
            missing['p_value_bound'] = 'No unique source-backed significance legend matches the marker.'
    if p is not None and p['relation'] != 'eq':
        missing['p_inversion'] = 'Bounded, interval or rounded-boundary p-values cannot identify a point statistic.'
    if (stat is None and compatible and not sign_conflict and p is not None
            and p['relation'] == 'eq' and p['value'] is not None and 0 < p['value'] < 1
            and distribution is not None and tail != 'unknown'):
        pv = p['value']
        if tail == 'two_sided':
            if delta is None or delta == 0:
                missing['statistic'] = 'A two-sided p-value does not identify statistic sign without a nonzero estimate-minus-null.'
            else:
                stat = math.copysign(float(distribution.isf(pv / 2)), delta)
        elif tail == 'greater':
            stat = float(distribution.isf(pv))
        elif tail == 'less':
            stat = float(distribution.ppf(pv))
        if stat is not None:
            stat_kind = 't' if test['reference'] == 'student_t' else 'z'
            calculated('statistic', stat, 'inverse reference CDF/SF using reported p and alternative',
                       {'p': pv, 'alternative': tail, 'reference': test['reference'],
                        'df': test['degrees_of_freedom'], 'estimate_minus_null': delta})
            result['statistic_kind'] = stat_kind
            if reported['standard_error'] is None and delta not in (None, 0) and stat != 0:
                sen = abs(delta / stat)
                calculated('normalized_standard_error', sen, 'abs((normalized_estimate - null) / statistic)',
                           {'normalized_estimate': bn, 'null': test['null_value'], 'statistic': stat})
                calculated('standard_error', sen * sm, 'normalized_standard_error * standard_error_multiplier',
                           {'normalized_standard_error': sen, 'standard_error_multiplier': sm})
    if (p is None and stat is not None and distribution is not None and tail != 'unknown'
            and not sign_conflict and test['type'] == 'wald' and stat_kind in ('t', 'z', 'wald_ratio')):
        if unsigned_stat and tail != 'two_sided':
            missing['p_value'] = 'An unsigned statistic does not establish a one-sided p-value.'
        else:
            if tail == 'two_sided':
                logp = min(0.0, math.log(2) + float(distribution.logsf(abs(stat))))
            elif tail == 'greater':
                logp = float(distribution.logsf(stat))
            else:
                logp = float(distribution.logcdf(stat))
            if math.isfinite(logp):
                calculated('log_p_value', logp, 'reference log-tail probability',
                           {'statistic': stat, 'alternative': tail, 'reference': test['reference'],
                            'df': test['degrees_of_freedom']})
                value = math.exp(logp)
                if value == 0:
                    missing['p_value'] = 'Floating-point underflow; log_p_value is retained instead of a fabricated zero.'
                else:
                    calculated('p_value', min(1.0, value), 'exp(log_p_value)', {'log_p_value': logp})
                    missing.pop('p_value', None)
            else:
                missing['p_value'] = 'Tail probability is outside the numerically representable log range.'
    return result


def variable_id(index=None):
    return 'dv' if index is None else f'iv_{index + 1:03}'


def merge_enrichment(base, enrichment, base_path, base_sha256):
    if enrichment['paper_id'] != base['paper_id']:
        raise ValueError('Enrichment/base paper ID mismatch')
    data = deepcopy(base)
    data.update(schema_version='2.0', results_scope='baseline_only',
                base_specification={'path': str(base_path), 'sha256': base_sha256},
                descriptive_statistics=deepcopy(enrichment['descriptive_statistics']),
                descriptive_status=enrichment['descriptive_status'],
                descriptive_reason=enrichment['descriptive_reason'],
                results_review_notes=deepcopy(enrichment['review_notes']),
                calculation_provenance={})
    parts = {m['model_id']: m for m in enrichment['models']}
    expected = {m['model_id'] for m in base['models'] if m['model_role'] == 'baseline'}
    if len(parts) != len(enrichment['models']) or set(parts) != expected:
        raise ValueError('Enrichment must account for exactly the frozen baseline models')
    for model in data['models']:
        model['dependent_variable']['variable_id'] = variable_id()
        for i, v in enumerate(model['independent_variables']):
            v.update(variable_id=variable_id(i), is_research_interest=None,
                     research_interest_evidence=[], research_interest_reason='Supporting-model roles are not requested.')
        if model['model_role'] != 'baseline':
            model['results'] = {'status': 'not_requested', 'reason': 'Supporting-model results are outside this campaign.',
                                'result_sets': [], 'missing_fields': {}, 'review_notes': [], 'evidence': []}
            continue
        part = parts[model['model_id']]
        if any(p.get('derived') for rs in part['results']['result_sets'] for p in rs['parameters']):
            raise ValueError('Raw enrichment must not contain calculated values')
        roles = {r['variable_id']: r for r in part['research_roles']}
        if len(roles) != len(part['research_roles']) or set(roles) != {v['variable_id'] for v in model['independent_variables']}:
            raise ValueError(f'Every predictor needs exactly one role: {model["model_id"]}')
        for v in model['independent_variables']:
            r = roles[v['variable_id']]
            v.update(is_research_interest=r['is_research_interest'],
                     research_interest_evidence=deepcopy(r['evidence']), research_interest_reason=r['reason'])
        model['results'] = deepcopy(part['results'])
    return calculate(data)


def calculate(data):
    data = deepcopy(data)
    if data['schema_version'] != '2.0':
        raise ValueError('Calculation requires schema 2.0')
    needs_review = data['descriptive_status'] in ('unreadable', 'needs_review')
    for model in data['models']:
        if model['model_role'] != 'baseline':
            continue
        block = model['results']
        if block['status'] != 'complete' or block['missing_fields'] or any(v['is_research_interest'] is None for v in model['independent_variables']):
            needs_review = True
        for result_set in block['result_sets']:
            for parameter in result_set['parameters']:
                parameter['derived'] = derive_parameter(parameter, result_set['test_context'], result_set['significance_legend'])
                if parameter['derived']['issues'] or parameter['missing_fields']:
                    needs_review = True
    if data['status'] in ('no_baseline_regression', 'text_unavailable'):
        data['results_status'] = data['status']
    else:
        data['results_status'] = 'needs_review' if needs_review else 'complete'
    data['calculation_provenance'] = {'helper_sha256': sha(__file__), 'scipy_version': scipy.__version__,
                                    'policy': 'strict; no guessed degrees of freedom or normal approximations'}
    return data


def load_records(path):
    content = Path(path).read_text()
    return [json.loads(line) for line in content.splitlines() if line.strip()] if Path(path).suffix == '.jsonl' else [json.loads(content)]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', type=Path)
    parser.add_argument('--output', '-o', type=Path, required=True)
    parser.add_argument('--specifications', type=Path)
    args = parser.parse_args()
    try:
        if args.input.resolve() == args.output.resolve():
            raise ValueError('Output must differ from input')
        records = load_records(args.input)
        bases = {r['paper_id']: r for r in load_records(args.specifications)} if args.specifications else {}
        output = []
        for record in records:
            if record['schema_version'] == '2.0-enrichment':
                if record['paper_id'] not in bases:
                    raise ValueError('A matching --specifications input is required')
                resolved = args.specifications.resolve()
                base_path = str(resolved.relative_to(Path.cwd().resolve())) if resolved.is_relative_to(Path.cwd().resolve()) else str(resolved)
                record = merge_enrichment(bases[record['paper_id']], record, base_path, sha(args.specifications))
            else:
                record = calculate(record)
            output.append(record)
        if args.output.suffix != '.jsonl' and len(output) != 1:
            raise ValueError('Multiple records require a .jsonl output')
        args.output.parent.mkdir(parents=True, exist_ok=True)
        payload = ''.join(json.dumps(r, ensure_ascii=False, allow_nan=False) + '\n' for r in output) if args.output.suffix == '.jsonl' else json.dumps(output[0], ensure_ascii=False, indent=2, allow_nan=False) + '\n'
        temporary = args.output.with_suffix(args.output.suffix + '.tmp')
        temporary.write_text(payload)
        temporary.replace(args.output)
    except (ValueError, OSError, KeyError, TypeError, ZeroDivisionError) as exc:
        parser.exit(1, f'{exc}\n')
    print(json.dumps({'records': len(output), 'output': str(args.output)}))


if __name__ == '__main__':
    main()
