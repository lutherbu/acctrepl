"""Behavioral checks for model schema, evidence and dependency integrity."""
import copy
import importlib.util
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / 'skills/extract-accounting-models/scripts'
sys.path.insert(0, str(SCRIPTS))
from model_result import new_model, new_paper, quote, source_quote, variable
spec = importlib.util.spec_from_file_location('model_validator', SCRIPTS / 'validate_extraction.py')
validator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(validator)


class ModelValidationTests(unittest.TestCase):
    def setUp(self):
        self.text = 'Table 2. Main OLS regression: Y = a + b X + c (X times Z). Y is annual profit divided by lagged assets. X is sales divided by lagged assets. Z is 1 for a loss, 0 otherwise. N = 1,234. Firm and year fixed effects. Standard errors clustered by firm and year.'
        self.paper = {'paper_id': 'W1', 'pages': [{'page': 3, 'text': self.text}]}
        self.data = new_paper('W1', None, 'papers/parsed/W1.json')
        self.data['status'] = 'complete'
        self.model = new_model('M1', 'Main full model')
        self.model.update(locations=[{'table': '2', 'panel': None, 'columns': ['1'], 'equation': None, 'page_begin': 3, 'page_end': 3}],
                          sample_id='S1', sample_description='Main full sample', sample_size=1234,
                          method='ols', method_reported='OLS',
                          dependent_variable=variable('Y', 'Annual profit divided by lagged assets', evidence=[quote(3, self.text)]),
                          independent_variables=[variable('X', 'Sales divided by lagged assets', evidence=[quote(3, self.text)]), variable('X times Z', 'X interacted with a loss indicator Z', evidence=[quote(3, self.text)])])
        for k in ('scope', 'method', 'sample'):
            self.model['evidence'][k] = [quote(3, self.text)]
        self.data['models'].append(self.model)
        self.samples = {'paper_id': 'W1', 'samples': [{'sample_id': 'S1'}]}

    def errors(self):
        return validator.validate(self.data, self.paper, self.samples)

    def test_supported_model_and_optional_unreported_settings(self):
        self.assertEqual([], self.errors())

    def test_methods_are_closed(self):
        self.model['method'] = 'difference_in_differences'
        self.assertTrue(self.errors())

    def test_other_method_requires_name(self):
        self.model.update(method='other', method_reported=None)
        self.assertTrue(any('other method' in e for e in self.errors()))

    def test_unknown_method_and_definition_need_reasons_and_review(self):
        self.model['method'] = None
        self.model['dependent_variable']['definition'] = None
        self.assertTrue(self.errors())
        self.model['missing_fields'] = {'method': 'Not reported.', 'dependent_variable.definition': 'Only label is reported.'}
        self.data['status'] = 'needs_review'
        self.assertEqual([], self.errors())

    def test_distinguish_separate_and_joint_dimensions(self):
        self.model['specifications']['fixed_effects'].update(status='reported', groups=[['firm'], ['year']], evidence=[quote(3, self.text)])
        self.model['specifications']['standard_errors'].update(status='reported', method='cluster_robust', cluster_groups=[['firm'], ['year']], evidence=[quote(3, self.text)])
        self.assertEqual([], self.errors())
        self.model['specifications']['fixed_effects']['groups'] = [['firm', 'year']]
        self.assertEqual([], self.errors())
        self.model['specifications']['fixed_effects']['status'] = 'not_reported'
        self.assertTrue(self.errors())

    def test_clustering_not_assumed_from_robust_standard_errors(self):
        self.model['specifications']['standard_errors'].update(status='reported', method='heteroskedasticity_robust', cluster_groups=[['firm']], evidence=[quote(3, self.text)])
        self.assertTrue(any('cluster groups' in e for e in self.errors()))

    def test_dependencies_must_exist_reach_support_and_be_acyclic(self):
        support = copy.deepcopy(self.model)
        support.update(model_id='M2', model_role='supporting')
        self.data['models'].append(support)
        self.assertTrue(any('not required' in e for e in self.errors()))
        self.model['dependencies'] = [{'model_id': 'M2', 'purpose': 'variable_construction', 'variables': ['Y']}]
        self.model['evidence']['dependencies'] = [quote(3, self.text)]
        self.assertEqual([], self.errors())
        support['dependencies'] = [{'model_id': 'M1', 'purpose': 'first_stage', 'variables': ['Y']}]
        support['evidence']['dependencies'] = [quote(3, self.text)]
        self.assertTrue(any('cycle' in e for e in self.errors()))

    def test_single_dependent_variable_and_no_duplicate_terms(self):
        self.model['dependent_variable'] = [self.model['dependent_variable']]
        self.assertTrue(self.errors())
        self.model['dependent_variable'] = self.model['dependent_variable'][0]
        self.model['independent_variables'].append(copy.deepcopy(self.model['independent_variables'][0]))
        self.assertTrue(any('duplicate RHS' in e for e in self.errors()))

    def test_quotes_preserve_math_and_physical_page(self):
        self.model['evidence']['method'] = [quote(3, self.text.replace('b X + c', 'b X - c'))]
        self.assertTrue(any('quote not found' in e for e in self.errors()))
        self.model['evidence']['method'] = [quote(2, self.text)]
        self.assertTrue(self.errors())

    def test_count_requires_numeric_evidence(self):
        self.model['sample_size'] = 999
        self.assertTrue(any('sample_size not found' in e for e in self.errors()))

    def test_invalid_sample_reference(self):
        self.model['sample_id'] = 'unrelated'
        self.assertTrue(any('unknown sample_id' in e for e in self.errors()))

    def test_no_regression_stays_a_paper_record(self):
        self.data.update(status='no_baseline_regression', models=[], review_notes=['Main analysis uses portfolio sorts.'])
        self.assertEqual([], self.errors())

    def test_source_quote_returns_actual_source_case_and_spacing(self):
        paper = {'pages': [{'page': 7, 'text': 'Table 4.\nThe OLS model uses X + Z.'}]}
        found = source_quote(paper, 7, 'the ols model uses X + Z.')
        self.assertEqual({'page': 7, 'quote': 'The OLS model uses X + Z.'}, found)
        self.assertIn(validator.flat(found['quote']), validator.flat(paper['pages'][0]['text']))

    def test_source_quote_does_not_repair_math_or_words(self):
        with self.assertRaises(ValueError):
            source_quote(self.paper, 3, 'Y = a + b X - c (X times Z).')

    def test_partial_equation_coverage_requires_review(self):
        self.model['missing_fields']['equation_coverage'] = 'Image-only control block needs independent verification.'
        self.assertTrue(any('requires needs_review' in e for e in self.errors()))
        self.data['status'] = 'needs_review'
        self.assertEqual([], self.errors())


if __name__ == '__main__':
    unittest.main()
