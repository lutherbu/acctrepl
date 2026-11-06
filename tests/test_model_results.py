"""Behavioral tests for numerical derivation and linked result extraction."""
import copy
import importlib.util
import json
import math
from pathlib import Path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / 'skills/extract-accounting-models/scripts'
sys.path.insert(0, str(SCRIPTS))
import derive_statistics as calc
import results_helpers as helpers
import validate_results as validator
from model_result import new_model, new_paper, quote, variable


TEXT = ('Table 2. Main OLS Y on X, N = 100. X is the research variable. '
        'X coefficient 0.20, t-statistic 2.0. Intercept 1.0, t-statistic 5.0. '
        'Two-sided tests of zero coefficients. '
        'Table 1 main sample: X mean 10, SD 3, 33.3 percentile 8.')
EVIDENCE = [quote(1, TEXT)]


def fixture():
    base = new_paper('W1', None, 'paper.json')
    base['status'] = 'complete'
    model = new_model('M1', 'Main')
    model.update(locations=[helpers.location(1, 'Table 2', column='1')], sample_description='Main',
                 sample_size=100, method='ols', method_reported='OLS',
                 dependent_variable=variable('Y', 'Outcome', evidence=EVIDENCE),
                 independent_variables=[variable('X', 'Research variable', evidence=EVIDENCE)])
    model['evidence'].update(scope=EVIDENCE, method=EVIDENCE, sample=EVIDENCE)
    model['specifications']['intercept'].update(status='reported', included=True, evidence=EVIDENCE)
    base['models'] = [model]
    raw = helpers.new_enrichment(base)
    raw.update(descriptive_status='complete', descriptive_reason=None)
    part = raw['models'][0]
    part['research_roles'][0].update(is_research_interest=True, evidence=EVIDENCE)
    rs = helpers.new_result_set('r1', 'Full', 't', 'two_sided')
    rs.update(locations=[helpers.location(1, 'Table 2', column='1')], evidence=EVIDENCE)
    rs['test_context']['evidence'] = EVIDENCE
    rs['parameters'] = [helpers.new_parameter('x', 'X', ['iv_001'], estimate='0.20', statistic='2.0', evidence=EVIDENCE),
                        helpers.new_parameter('a', 'Intercept', [], 'intercept', estimate='1.0', statistic='5.0', evidence=EVIDENCE)]
    part['results'].update(status='complete', result_sets=[rs], evidence=EVIDENCE)
    group = helpers.new_descriptive_group('d1', 'Main sample', ['M1'])
    group.update(sample_description='Main sample', sample_relation='exact', locations=[helpers.location(1, 'Table 1')], evidence=EVIDENCE)
    v = helpers.new_descriptive_variable('X', [helpers.variable_link('M1', 'iv_001')], evidence=EVIDENCE)
    v['statistics'] = [helpers.statistic('mean', '10', EVIDENCE), helpers.statistic('sd', '3', EVIDENCE),
                       helpers.statistic('percentile', '8', EVIDENCE, percentile=33.3, reported_label='33.3 percentile')]
    group['variables'] = [v]
    raw['descriptive_statistics'] = [group]
    data = calc.merge_enrichment(base, raw, 'base.json', '0' * 64)
    return base, raw, data, {'paper_id': 'W1', 'pages': [{'page': 1, 'text': TEXT}]}


class InferenceTests(unittest.TestCase):
    def parameter(self, **kwargs):
        return helpers.new_parameter('p', 'X', ['iv_001'], **kwargs)

    def test_t_unknown_df_still_derives_se_but_not_p(self):
        p = self.parameter(estimate='0.20', statistic='2.0')
        d = calc.derive_parameter(p, calc.context('t', 'two_sided'))
        self.assertEqual(0.1, d['standard_error'])
        self.assertIsNone(d['p_value'])
        self.assertIn('degrees of freedom', d['unavailable_reasons']['p_value'])

    def test_known_t_df_and_normal_reference_differ(self):
        p = self.parameter(estimate='0.20', statistic='2.0')
        dt = calc.derive_parameter(p, calc.context('t', 'two_sided', 20))
        dz = calc.derive_parameter(p, calc.context('z', 'two_sided'))
        self.assertAlmostEqual(0.05926553544657044, dt['p_value'])
        self.assertAlmostEqual(0.04550026389635839, dz['p_value'])

    def test_se_derives_signed_statistic(self):
        p = self.parameter(estimate='-0.20', standard_error='0.10')
        d = calc.derive_parameter(p, calc.context('z', 'two_sided'))
        self.assertEqual(-2, d['statistic'])
        self.assertEqual('z', d['statistic_kind'])

    def test_se_only_conventional_ratio_does_not_invent_reference(self):
        p = self.parameter(estimate='-0.20', standard_error='0.10')
        c = calc.context('wald_ratio', 'two_sided')
        d = calc.derive_parameter(p, c)
        self.assertEqual(-2, d['statistic'])
        self.assertEqual('wald_ratio', d['statistic_kind'])
        self.assertEqual('unknown', c['reference'])
        self.assertIsNone(d['p_value'])
        self.assertIn('reference distribution is unknown', d['unavailable_reasons']['p_value'])
        self.assertIsNone(p['reported']['statistic'])

    def test_se_only_rule_does_not_enable_zero_se_or_ratio_effect(self):
        c = calc.context('wald_ratio', 'two_sided')
        zero = self.parameter(estimate='0.20', standard_error='0.000')
        transformed = self.parameter(estimate='1.50', standard_error='0.10', estimate_kind='odds_ratio')
        self.assertIsNone(calc.derive_parameter(zero, c)['statistic'])
        self.assertIsNone(calc.derive_parameter(transformed, c)['statistic'])

    def test_exact_p_inversion_uses_coefficient_sign(self):
        p = self.parameter(estimate='-0.20', p_value='0.04550026389635839')
        d = calc.derive_parameter(p, calc.context('z', 'two_sided'))
        self.assertAlmostEqual(-2, d['statistic'])
        self.assertAlmostEqual(0.1, d['standard_error'])

    def test_one_sided_direction_is_not_observed_sign(self):
        p = self.parameter(estimate='-0.20', statistic='-2.0')
        upper = calc.derive_parameter(p, calc.context('z', 'greater'))
        lower = calc.derive_parameter(p, calc.context('z', 'less'))
        self.assertGreater(upper['p_value'], 0.97)
        self.assertLess(lower['p_value'], 0.03)

    def test_unknown_tail_blocks_p(self):
        p = self.parameter(estimate='0.20', statistic='2.0')
        d = calc.derive_parameter(p, calc.context('z'))
        self.assertIsNone(d['p_value'])
        self.assertEqual(0.1, d['standard_error'])

    def test_bounded_and_rounded_p_cannot_invert(self):
        for pv in ('<0.01', '0.000', '1.000'):
            p = self.parameter(estimate='0.20', p_value=pv)
            d = calc.derive_parameter(p, calc.context('z', 'two_sided'))
            self.assertIsNone(d['statistic'])
            self.assertIsNone(d['standard_error'])

    def test_marker_uses_only_its_source_legend(self):
        p = self.parameter(estimate='0.20', marker='**')
        d = calc.derive_parameter(p, calc.context(), [{'marker': '**', 'p_threshold': 0.01, 'relation': 'lt', 'evidence': EVIDENCE}])
        self.assertEqual(0.01, d['p_value_bound']['value'])
        self.assertIsNone(d['p_value'])
        self.assertIsNone(d['statistic'])

    def test_display_scales_do_not_change_test_statistic(self):
        p = self.parameter(estimate='20', standard_error='10')
        p.update(estimate_multiplier=100, standard_error_multiplier=100)
        d = calc.derive_parameter(p, calc.context('z', 'two_sided'))
        self.assertEqual(0.2, d['normalized_estimate'])
        self.assertEqual(2, d['statistic'])

    def test_statistic_sign_conflict_is_not_hidden_by_absolute_value(self):
        p = self.parameter(estimate='0.20', statistic='-2.0')
        d = calc.derive_parameter(p, calc.context('z', 'two_sided'))
        self.assertTrue(d['issues'])
        self.assertIsNone(d['standard_error'])

    def test_unsigned_statistics_can_identify_se(self):
        p = self.parameter(estimate='-0.20', statistic='2.0')
        c = calc.context('t', 'two_sided'); c['notes'] = 'Absolute t-statistics.'
        d = calc.derive_parameter(p, c)
        self.assertAlmostEqual(0.1, d['standard_error'])
        self.assertFalse(d['issues'])

    def test_zero_inverse_and_non_wald_are_blocked(self):
        for p in (self.parameter(estimate='0', statistic='2'), self.parameter(estimate='0.2', statistic='0')):
            self.assertIsNone(calc.derive_parameter(p, calc.context('t'))['standard_error'])
        p = self.parameter(estimate='0.2', statistic='2')
        c = calc.context('z'); c['type'] = 'likelihood_ratio'
        self.assertIsNone(calc.derive_parameter(p, c)['standard_error'])

    def test_ratio_estimate_not_assumed_on_wald_scale(self):
        p = self.parameter(estimate='1.5', statistic='2', estimate_kind='odds_ratio')
        self.assertIsNone(calc.derive_parameter(p, calc.context('z'))['standard_error'])

    def test_marginal_effect_requires_explicit_reported_scale(self):
        p = self.parameter(estimate='0.02', statistic='2', estimate_kind='marginal_effect')
        c = calc.context('z', 'two_sided')
        self.assertIsNone(calc.derive_parameter(p, c)['standard_error'])
        c['null_basis'] = 'reported'
        self.assertAlmostEqual(0.01, calc.derive_parameter(p, c)['standard_error'])

    def test_other_statistic_never_enters_estimate_se_identity(self):
        p = self.parameter(estimate='0.50', statistic='9', statistic_kind='other')
        d = calc.derive_parameter(p, calc.context('z', 'two_sided'))
        self.assertIsNone(d['standard_error'])
        self.assertIsNone(d['p_value'])
        self.assertIn('not a signed', d['unavailable_reasons']['statistic_identity'])

    def test_extreme_tail_retains_log_probability(self):
        p = self.parameter(estimate='1', statistic='50')
        d = calc.derive_parameter(p, calc.context('z', 'two_sided'))
        self.assertIsNone(d['p_value'])
        self.assertTrue(math.isfinite(d['log_p_value']))

    def test_parser_preserves_sign_scale_and_scientific_notation(self):
        self.assertEqual(-1234.5, calc.parse_number('−1,234.5'))
        self.assertEqual(5.7, calc.parse_number('5.7%'))
        self.assertEqual(0.0012, calc.parse_number('1.2×10^-3'))
        with self.assertRaises(ValueError):calc.parse_number('--')


class ResultValidationTests(unittest.TestCase):
    def setUp(self):
        self.base, self.raw, self.data, self.paper = fixture()

    def errors(self):
        return validator.validate(self.data, self.paper, base=self.base)

    def test_supported_enrichment_and_fractional_percentile(self):
        self.assertEqual([], validator.schema_errors(self.raw, 'enrichment.schema.json'))
        self.assertEqual([], self.errors())
        self.assertEqual('complete', self.data['results_status'])

    def test_computation_is_idempotent_and_specifications_are_frozen(self):
        self.assertEqual(self.data, calc.calculate(self.data))
        self.assertEqual(self.base, validator.project_v1(self.data))
        self.data['models'][0]['independent_variables'][0]['name'] = 'Different'
        self.assertTrue(any('Frozen specification' in e for e in self.errors()))

    def test_manual_derived_value_is_rejected(self):
        self.data['models'][0]['results']['result_sets'][0]['parameters'][0]['derived']['standard_error'] = 999
        self.assertTrue(any('deterministic helper' in e for e in self.errors()))

    def test_number_text_and_value_must_agree(self):
        self.data['descriptive_statistics'][0]['variables'][0]['statistics'][0]['cell']['value'] = 11
        self.assertTrue(any('printed cell' in e for e in self.errors()))

    def test_unknown_roles_have_reason_and_no_default_control(self):
        self.raw['models'][0]['research_roles'][0].update(is_research_interest=None, evidence=[], reason='The source does not identify its role.')
        self.data = calc.merge_enrichment(self.base, self.raw, 'base.json', '0'*64)
        self.assertEqual([], self.errors())
        self.assertEqual('needs_review', self.data['results_status'])

    def test_raw_version_mapping_is_explicit(self):
        row = self.data['descriptive_statistics'][0]['variables'][0]
        row['name'] = 'Raw X'; row['variable_links'][0]['relation'] = 'raw_version'
        self.assertEqual([], self.errors())
        row['variable_links'][0]['variable_id'] = 'iv_999'
        self.assertTrue(any('invalid baseline variable' in e for e in self.errors()))

    def test_missing_predictor_and_intercept_need_reasons(self):
        block = self.data['models'][0]['results']; block['result_sets'][0]['parameters'] = []
        self.assertTrue(any('missing predictor' in e for e in self.errors()))
        block['missing_fields'].update(iv_001='The control coefficient is suppressed.', intercept='Intercept suppressed.')
        self.assertFalse(any('missing predictor' in e or 'unreported intercept' in e for e in self.errors()))

    def test_multiple_horizons_are_separate_sets_not_models(self):
        block = self.raw['models'][0]['results'];second=copy.deepcopy(block['result_sets'][0]);second.update(result_set_id='h2',horizon='2 years');block['result_sets'].append(second)
        self.data = calc.merge_enrichment(self.base,self.raw,'base.json','0'*64)
        self.assertEqual([],self.errors());self.assertEqual(1,len(self.data['models']))
        self.assertEqual(2,len(self.data['models'][0]['results']['result_sets']))

    def test_exact_descriptive_target_cannot_be_two_different_data_rows(self):
        group=self.data['descriptive_statistics'][0]
        other=copy.deepcopy(group['variables'][0]);other['name']='Different outcome';group['variables'].append(other)
        self.assertTrue(any('duplicate an exact' in e for e in self.errors()))

    def test_parameter_distribution_sd_is_never_inference(self):
        parameter=self.raw['models'][0]['results']['result_sets'][0]['parameters'][0]
        parameter['reported']['statistic']=None
        parameter['reported_distribution']=[helpers.statistic('sd','3',EVIDENCE)]
        parameter['missing_fields']['reported.inference']='The SD describes fitted coefficients, not their standard error.'
        self.data=calc.merge_enrichment(self.base,self.raw,'base.json','0'*64)
        self.assertIsNone(self.data['models'][0]['results']['result_sets'][0]['parameters'][0]['derived']['standard_error'])
        self.assertEqual([],self.errors())

    def test_no_baseline_remains_a_paper_record(self):
        base=copy.deepcopy(self.base);base.update(status='no_baseline_regression',models=[],review_notes=['Main tests are mean comparisons.'])
        raw=helpers.new_enrichment(base);raw.update(descriptive_status='not_applicable',descriptive_reason='No baseline variables.')
        result=calc.merge_enrichment(base,raw,'base.json','0'*64)
        self.assertEqual([],validator.validate(result,self.paper,base=base))
        self.assertEqual('no_baseline_regression',result['results_status'])


class RegionEvidenceTests(unittest.TestCase):
    def test_region_must_reproduce_from_the_original_pdf(self):
        import pymupdf
        from render_result_evidence import render
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp);pdf=root/'fixture.pdf';doc=pymupdf.open();page=doc.new_page();page.insert_text((20,30),'X coefficient -0.20, t -2.0');doc.save(pdf);doc.close()
            ev=render(pdf,1,root/'crop.png',[0,0,200,80],2,root)
            self.assertEqual([],validator.check_evidence({'evidence':[ev]},None,pdf,root))
            changed=copy.deepcopy(ev);changed['bbox'][2]=190
            self.assertTrue(any('not the recorded' in e for e in validator.check_evidence({'evidence':[changed]},None,pdf,root)))
            (root/'crop.png').write_bytes(b'forged image');ev['crop_sha256']=calc.sha(root/'crop.png')
            self.assertTrue(any('not the recorded' in e for e in validator.check_evidence({'evidence':[ev]},None,pdf,root)))


if __name__ == '__main__':
    unittest.main()
