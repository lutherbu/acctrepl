"""Schema-2 validation of linkage, source regions and deterministic inference."""
from copy import deepcopy
import hashlib
import importlib.util
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

import jsonschema
from referencing import Registry, Resource

SKILL = Path(__file__).resolve().parents[1]


def module(filename):
    path = Path(__file__).parent / filename
    spec = importlib.util.spec_from_file_location('results_' + hashlib.sha256(str(path).encode()).hexdigest()[:12], path)
    obj = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(obj)
    return obj


legacy = module('validate_v1.py')
calculator = module('derive_statistics.py')


def project_v1(data):
    result = deepcopy(data)
    result['schema_version'] = '1.0'
    for key in ('results_scope', 'results_status', 'base_specification', 'descriptive_statistics',
                'descriptive_status', 'descriptive_reason', 'results_review_notes', 'calculation_provenance'):
        result.pop(key, None)
    for model in result['models']:
        model.pop('results', None)
        model['dependent_variable'].pop('variable_id', None)
        for v in model['independent_variables']:
            for key in ('variable_id', 'is_research_interest', 'research_interest_evidence', 'research_interest_reason'):
                v.pop(key, None)
    return result


def schema_errors(data, name):
    path = SKILL / 'references' / name
    schema = json.loads(path.read_text())
    schema['$id'] = path.as_uri()
    mp = SKILL / 'references/regression_methods.json'
    registry = Registry().with_resource(mp.as_uri(), Resource.from_contents(json.loads(mp.read_text())))
    return [f"{'/'.join(map(str, e.absolute_path))}: {e.message}" for e in
            jsonschema.Draft202012Validator(schema, registry=registry).iter_errors(data)]


def evidence_nodes(value, path=''):
    if isinstance(value, dict):
        if set(value) == {'page', 'quote'} or 'crop_sha256' in value:
            yield path, value
        else:
            for key, child in value.items():
                yield from evidence_nodes(child, f'{path}/{key}')
    elif isinstance(value, list):
        for i, child in enumerate(value):
            yield from evidence_nodes(child, f'{path}/{i}')


def check_evidence(data, paper, pdf_path, workspace):
    errors = []
    pages = {p['page']: legacy.flat(p['text']) for p in paper['pages']} if paper else {}
    root = Path(workspace or Path.cwd()).resolve()
    pdf_hash = calculator.sha(pdf_path) if pdf_path else None
    checked = set()
    for path, ev in evidence_nodes(data):
        if 'quote' in ev:
            if paper and (ev['page'] not in pages or legacy.flat(ev['quote']) not in pages[ev['page']]):
                errors.append(f'{path}: quote not found on physical page {ev["page"]}')
            continue
        key = (ev['page'], tuple(ev['bbox']), ev['scale'], ev['crop_path'], ev['crop_sha256'])
        if key in checked:
            continue
        checked.add(key)
        image = (root / ev['crop_path']).resolve()
        if not image.is_relative_to(root) or not image.is_file() or calculator.sha(image) != ev['crop_sha256']:
            errors.append(f'{path}: crop is missing, changed or outside workspace')
            continue
        if not pdf_path:
            errors.append(f'{path}: --pdf is required for region evidence')
            continue
        if ev['pdf_sha256'] != pdf_hash:
            errors.append(f'{path}: PDF hash differs')
            continue
        try:
            import pymupdf
            with pymupdf.open(pdf_path) as pdf:
                if not 1 <= ev['page'] <= len(pdf):
                    raise ValueError('Invalid physical page')
                page = pdf[ev['page'] - 1]
                clip = pymupdf.Rect(ev['bbox'])
                if clip.is_empty or not page.rect.contains(clip):
                    raise ValueError('Invalid PDF region')
                payload = page.get_pixmap(matrix=pymupdf.Matrix(ev['scale'], ev['scale']), clip=clip, alpha=False).tobytes('png')
                if hashlib.sha256(payload).hexdigest() != ev['crop_sha256']:
                    errors.append(f'{path}: crop is not the recorded PDF region')
        except (ValueError, IndexError, OSError) as exc:
            errors.append(f'{path}: {exc}')
    return errors


def numeric_cells(value, path=''):
    if isinstance(value, dict):
        if set(value) == {'text', 'value'}:
            yield path, value
        else:
            for key, child in value.items():
                if key != 'derived':
                    yield from numeric_cells(child, path + '/' + key)
    elif isinstance(value, list):
        for i, child in enumerate(value):
            yield from numeric_cells(child, f'{path}/{i}')


def validate(data, paper=None, sample_record=None, base=None, pdf_path=None, workspace=None):
    errors = schema_errors(data, 'output.v2.schema.json')
    if errors:
        return errors
    original = project_v1(data)
    errors.extend(legacy.validate(original, paper, sample_record))
    if base is not None and original != base:
        errors.append('Frozen specification fields changed during enrichment')
    for path, cell in numeric_cells(data):
        try:
            if calculator.parse_number(cell['text']) != cell['value']:
                errors.append(f'{path}: numeric value differs from printed cell text')
        except ValueError as exc:
            errors.append(f'{path}: {exc}')
    models = {m['model_id']: m for m in data['models']}
    for mid, model in models.items():
        ids = [v['variable_id'] for v in [model['dependent_variable']] + model['independent_variables']]
        if len(ids) != len(set(ids)):
            errors.append(f'{mid}: duplicate variable IDs')
        block = model['results']
        if model['model_role'] == 'supporting':
            if block['status'] != 'not_requested' or block['result_sets']:
                errors.append(f'{mid}: supporting results must be not_requested')
            continue
        if block['status'] == 'not_requested':
            errors.append(f'{mid}: baseline results cannot be not_requested')
        for v in model['independent_variables']:
            if v['is_research_interest'] is None and not v['research_interest_reason']:
                errors.append(f'{mid}/{v["variable_id"]}: unknown role needs a reason')
            if v['is_research_interest'] is not None and not v['research_interest_evidence']:
                errors.append(f'{mid}/{v["variable_id"]}: focal/control role needs evidence')
        if not block['result_sets'] and not block['reason']:
            errors.append(f'{mid}: unavailable results need a reason')
        set_ids = [s['result_set_id'] for s in block['result_sets']]
        if len(set_ids) != len(set(set_ids)):
            errors.append(f'{mid}: duplicate result-set IDs')
        for rs in block['result_sets']:
            rid = f'{mid}/{rs["result_set_id"]}'
            if not rs['evidence'] or not rs['locations']:
                errors.append(f'{rid}: result column needs location and evidence')
            parameter_ids = [p['parameter_id'] for p in rs['parameters']]
            if len(parameter_ids) != len(set(parameter_ids)):
                errors.append(f'{rid}: duplicate parameter IDs')
            covered = set()
            for parameter in rs['parameters']:
                pid = rid + '/' + parameter['parameter_id']
                links = parameter['variable_ids']
                if set(links) - set(ids):
                    errors.append(f'{pid}: unknown variable IDs')
                if parameter['target_kind'] == 'predictor' and not links:
                    errors.append(f'{pid}: predictor needs a variable link')
                covered.update(links)
                if not parameter['evidence']:
                    errors.append(f'{pid}: parameter needs source evidence')
                raw = parameter['reported']
                if raw['estimate'] is None and 'reported.estimate' not in parameter['missing_fields']:
                    errors.append(f'{pid}: unavailable estimate needs a reason')
                if not any(raw[k] is not None for k in ('statistic', 'standard_error', 'p_value')) and not raw['significance_marker']:
                    if 'reported.inference' not in parameter['missing_fields']:
                        errors.append(f'{pid}: missing inference needs a reason')
                if (parameter['estimate_multiplier'] != 1 or parameter['standard_error_multiplier'] != 1) and not parameter['scale_evidence']:
                    errors.append(f'{pid}: display multiplier needs evidence')
                test = parameter['test'] or rs['test_context']
                if test['type'] != 'unknown' and not test['evidence']:
                    errors.append(f'{pid}: test definition needs evidence')
                if raw['p_value']:
                    pv = raw['p_value']
                    if pv['value'] is not None and not 0 <= pv['value'] <= 1:
                        errors.append(f'{pid}: p-value outside [0,1]')
                    if pv['relation'] == 'eq' and pv['value'] in (0, 1):
                        errors.append(f'{pid}: boundary p-value must be marked rounded_boundary')
                    if pv['relation'] == 'interval':
                        if pv['lower'] is None or pv['upper'] is None or not 0 <= pv['lower'] < pv['upper'] <= 1:
                            errors.append(f'{pid}: invalid p-value interval')
                    else:
                        try:
                            parsed = calculator.p_cell(pv['text'])
                            if (parsed['value'], parsed['relation']) != (pv['value'], pv['relation']):
                                errors.append(f'{pid}: p-value differs from printed cell text')
                        except ValueError as exc:
                            errors.append(f'{pid}: {exc}')
                if parameter['derived'] != calculator.derive_parameter(parameter, rs['test_context'], rs['significance_legend']):
                    errors.append(f'{pid}: derived statistics differ from deterministic helper')
            expected = {v['variable_id'] for v in model['independent_variables']}
            missing = expected - covered - set(block['missing_fields'])
            if missing:
                errors.append(f'{rid}: missing predictor results need variable-ID reasons: {sorted(missing)}')
            if (model['specifications']['intercept']['included'] is True
                    and not any(p['target_kind'] == 'intercept' for p in rs['parameters'])
                    and 'intercept' not in block['missing_fields']):
                errors.append(f'{rid}: unreported intercept needs a reason')
    groups = data['descriptive_statistics']
    if len({g['group_id'] for g in groups}) != len(groups):
        errors.append('Duplicate descriptive group IDs')
    if not groups and data['descriptive_status'] != 'not_applicable' and not data['descriptive_reason']:
        errors.append('Absent descriptive statistics need a reason')
    for group in groups:
        if not group['evidence'] or not group['locations'] or not group['sample_description']:
            errors.append(f'{group["group_id"]}: descriptive group needs evidence, location and sample')
        if set(group['model_ids']) - set(models):
            errors.append(f'{group["group_id"]}: unknown descriptive model links')
        exact_targets = set()
        for variable in group['variables']:
            if not variable['variable_links'] or not variable['evidence']:
                errors.append(f'{group["group_id"]}/{variable["name"]}: descriptive row needs links and evidence')
            for link in variable['variable_links']:
                m = models.get(link['model_id'])
                allowed = {m['dependent_variable']['variable_id']} | {v['variable_id'] for v in m['independent_variables']} if m else set()
                if m is None or link['variable_id'] not in allowed or m['model_role'] != 'baseline':
                    errors.append(f'{group["group_id"]}: invalid baseline variable link')
                if link['relation'] == 'exact':
                    target = (link['model_id'], link['variable_id'])
                    if target in exact_targets:
                        errors.append(f'{group["group_id"]}: different descriptive rows duplicate an exact model-variable target')
                    exact_targets.add(target)
            for statistic in variable['statistics']:
                if (statistic['name'] == 'percentile') != (statistic['percentile'] is not None):
                    errors.append('Only percentile statistics require a percentile level')
                if not statistic['evidence']:
                    errors.append('Every descriptive statistic needs evidence')
    calculated = calculator.calculate(data)
    if calculated['calculation_provenance'] != data['calculation_provenance'] or calculated['results_status'] != data['results_status']:
        errors.append('Calculation provenance or results_status differs from helper')
    errors.extend(check_evidence(data, paper, pdf_path, workspace))
    return errors
