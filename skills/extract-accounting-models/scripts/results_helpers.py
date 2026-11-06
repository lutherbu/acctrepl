"""Construct compact reported-value enrichments; no statistical arithmetic."""
from copy import deepcopy

from derive_statistics import context, number_cell, p_cell, variable_id


def new_enrichment(base):
    return {'schema_version': '2.0-enrichment', 'paper_id': base['paper_id'],
            'models': [{'model_id': m['model_id'],
                        'research_roles': [{'variable_id': variable_id(i), 'is_research_interest': None,
                                            'evidence': [], 'reason': None}
                                           for i, _ in enumerate(m['independent_variables'])],
                        'results': {'status': 'needs_review', 'reason': None, 'result_sets': [],
                                    'missing_fields': {}, 'review_notes': [], 'evidence': []}}
                       for m in base['models'] if m['model_role'] == 'baseline'],
            'descriptive_statistics': [], 'descriptive_status': 'needs_review',
            'descriptive_reason': None, 'review_notes': []}


def new_result_set(result_set_id, label, statistic_kind=None, alternative='unknown', df=None):
    return {'result_set_id': result_set_id, 'label': label, 'locations': [],
            'horizon': None, 'period': None, 'population': None, 'aggregation': 'single_fit',
            'test_context': context(statistic_kind, alternative, df),
            'significance_legend': [], 'parameters': [], 'evidence': [], 'review_notes': []}


def new_parameter(parameter_id, label, variable_ids=None, target_kind='predictor',
                  estimate=None, statistic=None, statistic_kind='t', standard_error=None,
                  p_value=None, marker=None, evidence=None, estimate_kind='coefficient'):
    return {'parameter_id': parameter_id, 'label': label, 'target_kind': target_kind,
            'variable_ids': list(variable_ids or []), 'estimate_kind': estimate_kind,
            'reported': {'estimate': number_cell(estimate) if estimate is not None else None,
                         'statistic': {'kind': statistic_kind, 'cell': number_cell(statistic)} if statistic is not None else None,
                         'standard_error': number_cell(standard_error) if standard_error is not None else None,
                         'p_value': p_cell(p_value) if p_value is not None else None,
                         'significance_marker': marker},
            'test': None, 'estimate_multiplier': 1, 'standard_error_multiplier': 1,
            'scale_evidence': [], 'evidence': deepcopy(evidence or []),
            'missing_fields': {}, 'review_notes': [], 'reported_distribution': [], 'derived': {}}


def new_descriptive_group(group_id, label, model_ids=None):
    return {'group_id': group_id, 'label': label, 'sample_description': None,
            'period': None, 'sample_relation': 'unclear', 'model_ids': list(model_ids or []),
            'locations': [], 'variables': [], 'evidence': [], 'review_notes': []}


def new_descriptive_variable(name, links=None, units=None, evidence=None):
    return {'name': name, 'statistics_about': 'data_values', 'variable_links': deepcopy(links or []), 'units': units,
            'statistics': [], 'evidence': deepcopy(evidence or []), 'review_notes': []}


def statistic(name, value, evidence=None, percentile=None, reported_label=None):
    return {'name': name, 'percentile': percentile, 'reported_label': reported_label or name,
            'cell': number_cell(value), 'evidence': deepcopy(evidence or [])}


def variable_link(model_id, variable_id, relation='exact'):
    return {'model_id': model_id, 'variable_id': variable_id, 'relation': relation}


def location(page, table, panel=None, column=None, page_end=None):
    return {'table': table, 'panel': panel, 'columns': [column] if column else [],
            'equation': None, 'page_begin': page, 'page_end': page_end or page}
