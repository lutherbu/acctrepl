"""Lossless schema-2/schema-3 layout conversion. No statistical calculations."""
from copy import deepcopy
import hashlib
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


RESULT_FIELDS = ('status', 'reason', 'missing_fields', 'review_notes', 'evidence')


def canonical(value):
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(',', ':'), allow_nan=False)


def digest(value):
    return hashlib.sha256(canonical(value).encode('utf-8')).hexdigest()


def variables(model):
    return [model['dependent_variable'], *model['independent_variables']]


def routes(parameter):
    """Return variable IDs, or one model-level destination for a parameter."""
    links = parameter['variable_ids']
    if parameter['target_kind'] == 'intercept':
        return 'intercept_results', []
    if (parameter['target_kind'] == 'predictor' and links) or (
            parameter['target_kind'] == 'auxiliary' and len(links) == 1):
        return 'variables', links
    return 'auxiliary_results', []


def unique_index(items, key, label):
    result = {item[key]: item for item in items}
    if len(result) != len(items):
        raise ValueError(f'Duplicate {label}')
    return result


def to_v3(record):
    if record.get('schema_version') == '3.0':
        return deepcopy(record)
    if record.get('schema_version') != '2.0':
        raise ValueError('Conversion requires a full schema-2.0 record')
    data = deepcopy(record)
    data['schema_version'] = '3.0'
    data['migration_provenance'] = {
        'source_schema_version': '2.0', 'source_record_sha256': digest(record),
        'converter_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    models = unique_index(data['models'], 'model_id', 'model IDs')
    variable_maps = {}
    for mid, model in models.items():
        vm = unique_index(variables(model), 'variable_id', f'variable IDs in {mid}')
        variable_maps[mid] = vm
        for variable in vm.values():
            variable.update(results=[], statistics=[])
        block = model.pop('results')
        for key in RESULT_FIELDS:
            model['results_' + key] = block[key]
        model.update(result_sets=[], intercept_results=[], auxiliary_results=[])
        unique_index(block['result_sets'], 'result_set_id', f'result sets in {mid}')
        for old_set in block['result_sets']:
            result_set = deepcopy(old_set)
            parameters = result_set.pop('parameters')
            unique_index(parameters, 'parameter_id', f'parameters in {mid}/{old_set["result_set_id"]}')
            result_set['parameter_order'] = [p['parameter_id'] for p in parameters]
            model['result_sets'].append(result_set)
            for parameter in parameters:
                destination, ids = routes(parameter)
                item = {'result_set_id': result_set['result_set_id'], **deepcopy(parameter)}
                if destination == 'variables':
                    for vid in ids:
                        if vid not in vm:
                            raise ValueError(f'{mid}: unknown parameter variable {vid}')
                        vm[vid]['results'].append(deepcopy(item))
                else:
                    model[destination].append(item)
    groups = data.pop('descriptive_statistics')
    unique_index(groups, 'group_id', 'descriptive group IDs')
    data['descriptive_groups'] = []
    for group in groups:
        context = deepcopy(group)
        rows = context.pop('variables')
        context['variable_count'] = len(rows)
        data['descriptive_groups'].append(context)
        for row_index, row in enumerate(rows):
            if not row['variable_links']:
                raise ValueError(f'{group["group_id"]}: descriptive row has no variable link')
            payload = {k: deepcopy(v) for k, v in row.items() if k not in ('name', 'statistics', 'variable_links')}
            payload.update(reported_variable_name=row['name'], values=deepcopy(row['statistics']),
                           source_group_id=group['group_id'], source_row_index=row_index)
            for link_index, link in enumerate(row['variable_links']):
                mid, vid = link['model_id'], link['variable_id']
                if mid not in variable_maps or vid not in variable_maps[mid]:
                    raise ValueError(f'{group["group_id"]}: unknown descriptive target {mid}/{vid}')
                item = {**deepcopy(payload), 'source_link_index': link_index,
                        'variable_relation': link['relation']}
                variable_maps[mid][vid]['statistics'].append(item)
    return data


def to_v2(record):
    if record.get('schema_version') == '2.0':
        return deepcopy(record)
    if record.get('schema_version') != '3.0':
        raise ValueError('Reverse conversion requires schema 3.0')
    data = deepcopy(record)
    data['schema_version'] = '2.0'
    data.pop('migration_provenance')
    groups = unique_index(data.pop('descriptive_groups'), 'group_id', 'descriptive group IDs')
    # Keep one canonical descriptive row and reconstruct original link ordering.
    rows = {gid: {} for gid in groups}
    for model in data['models']:
        mid = model['model_id']
        vm = unique_index(variables(model), 'variable_id', f'variable IDs in {mid}')
        sets = model.pop('result_sets')
        by_set = unique_index(sets, 'result_set_id', f'result sets in {mid}')
        parameters, owners = {}, {}

        def add_parameter(item, owner):
            p = deepcopy(item)
            sid = p.pop('result_set_id')
            if sid not in by_set:
                raise ValueError(f'{mid}: unknown result_set_id {sid}')
            destination, vids = routes(p)
            if (owner[0] == 'variables' and (destination != 'variables' or owner[1] not in vids)
                    or owner[0] != 'variables' and destination != owner[0]):
                raise ValueError(f'{mid}/{sid}/{p["parameter_id"]}: parameter is attached to the wrong owner')
            key = (sid, p['parameter_id'])
            if key in parameters and canonical(parameters[key]) != canonical(p):
                raise ValueError(f'{mid}/{sid}/{p["parameter_id"]}: conflicting shared parameter copies')
            parameters[key] = p
            if owner in owners.setdefault(key, []):
                raise ValueError(f'{mid}/{sid}: duplicate parameter copy in one owner')
            owners[key].append(owner)

        for destination in ('intercept_results', 'auxiliary_results'):
            for item in model.pop(destination):
                add_parameter(item, (destination, None))
        for vid, variable in vm.items():
            for item in variable.pop('results'):
                add_parameter(item, ('variables', vid))
            for item in variable.pop('statistics'):
                item = deepcopy(item)
                gid = item.pop('source_group_id')
                ri = item.pop('source_row_index')
                li = item.pop('source_link_index')
                relation = item.pop('variable_relation')
                if gid not in groups or not 0 <= ri < groups[gid]['variable_count']:
                    raise ValueError(f'{mid}/{vid}: unknown descriptive group/row {gid}/{ri}')
                item['name'] = item.pop('reported_variable_name')
                item['statistics'] = item.pop('values')
                original = rows[gid].setdefault(ri, {'payload': item, 'links': {}})
                if canonical(original['payload']) != canonical(item):
                    raise ValueError(f'{gid}/{ri}: conflicting shared descriptive copies')
                if li in original['links']:
                    raise ValueError(f'{gid}/{ri}: duplicate descriptive link index {li}')
                original['links'][li] = {'model_id': mid, 'variable_id': vid, 'relation': relation}
        for key, parameter in parameters.items():
            destination, vids = routes(parameter)
            expected = [('variables', vid) for vid in vids] if destination == 'variables' else [(destination, None)]
            if set(owners[key]) != set(expected) or len(owners[key]) != len(expected):
                raise ValueError(f'{mid}/{key}: missing shared parameter copies')
        used = set()
        for result_set in sets:
            sid = result_set['result_set_id']
            order = result_set.pop('parameter_order')
            if len(order) != len(set(order)):
                raise ValueError(f'{mid}/{sid}: duplicate parameter order entries')
            result_set['parameters'] = []
            for pid in order:
                key = (sid, pid)
                if key not in parameters:
                    raise ValueError(f'{mid}/{sid}/{pid}: missing ordered parameter')
                result_set['parameters'].append(parameters[key]); used.add(key)
        if used != set(parameters):
            raise ValueError(f'{mid}: parameter_order does not cover all results')
        model['results'] = {key: model.pop('results_' + key) for key in RESULT_FIELDS}
        model['results']['result_sets'] = sets
    data['descriptive_statistics'] = []
    for gid, group in groups.items():
        count = group.pop('variable_count')
        if set(rows[gid]) != set(range(count)):
            raise ValueError(f'{gid}: missing descriptive source rows')
        group['variables'] = []
        for ri in range(count):
            row = rows[gid][ri]
            links = row['links']
            if set(links) != set(range(len(links))):
                raise ValueError(f'{gid}/{ri}: noncontiguous descriptive link order')
            group['variables'].append({**row['payload'], 'variable_links': [links[i] for i in range(len(links))]})
        data['descriptive_statistics'].append(group)
    return data
