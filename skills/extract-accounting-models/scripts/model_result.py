"""Optional constructors; defaults express unknowns, never inferred settings."""
from copy import deepcopy
import re
import unicodedata


def quote(page, text):
    return {'page': page, 'quote': text}


def source_quote(paper, page, needle):
    """Locate a quotation and return source capitalization, not supplied wording.

    Normalize Unicode/whitespace as the validator does. Case-insensitive lookup
    avoids assembly failures; the returned quote retains the source's case.
    Punctuation, words, numbers and mathematical signs must still match.
    """
    def normalized(value):
        return re.sub(r'\s+', ' ', unicodedata.normalize('NFKC', value)).strip()
    source = normalized(next(p['text'] for p in paper['pages'] if p['page'] == page))
    wanted = normalized(needle)
    if not wanted:
        raise ValueError('Quotation search must not be empty')
    match = re.search(re.escape(wanted), source, re.IGNORECASE)
    if match is None:
        raise ValueError(f'Quote not found on physical page {page}: {wanted[:160]}')
    return quote(page, source[match.start():match.end()])


def variable(name, definition=None, formula=None, evidence=None):
    return {'name': name, 'definition': definition, 'formula': formula,
            'evidence': deepcopy(evidence or [])}


def new_paper(paper_id, doi, paper_text_file):
    return {'schema_version': '1.0', 'paper_id': paper_id, 'doi': doi,
            'status': 'needs_review', 'paper_text_file': paper_text_file,
            'models': [], 'review_notes': []}


def new_model(model_id, label, role='baseline'):
    return {
        'model_id': model_id, 'model_role': role, 'model_label': label,
        'locations': [], 'sample_id': None, 'sample_description': None,
        'sample_size': None, 'method': None, 'method_reported': None,
        'method_details': '', 'dependent_variable': variable('UNKNOWN'),
        'independent_variables': [], 'equation_text': None,
        'specifications': {
            'fixed_effects': {'status': 'not_reported', 'groups': [], 'details': '', 'evidence': []},
            'standard_errors': {'status': 'not_reported', 'method': None, 'cluster_groups': [], 'details': '', 'evidence': []},
            'intercept': {'status': 'not_reported', 'included': None, 'evidence': []},
            'weights': {'status': 'not_reported', 'description': None, 'evidence': []},
            'estimation_procedure': {'description': None, 'grouping_variables': [], 'evidence': []},
            'preprocessing': [], 'other': [],
        },
        'dependencies': [], 'estimation_group_id': None,
        'evidence': {k: [] for k in ('scope', 'method', 'equation', 'sample', 'dependencies')},
        'missing_fields': {}, 'review_notes': [],
    }
