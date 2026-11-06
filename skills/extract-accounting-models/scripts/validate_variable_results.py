"""Validate schema 3, shared-copy consistency and the original source semantics."""
import hashlib
import importlib.util
from pathlib import Path

# Resolve frozen artifact locations without rewriting research records.
_layout_root = Path(__file__).resolve().parents[3]
_layout = None
if (_layout_root / "project_layout.py").is_file():
    import sys as _layout_sys
    _layout_sys.path.insert(0, str(_layout_root))
    import project_layout as _layout
    Path = _layout.path_class(_layout_root)


def sibling(name):
    path = Path(__file__).with_name(name + '.py')
    spec = importlib.util.spec_from_file_location(name + hashlib.sha256(str(path).encode()).hexdigest()[:12], path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


layout = sibling('convert_schema')
legacy = sibling('validate_results')


def validate(data, paper=None, sample_record=None, base=None, pdf_path=None, workspace=None):
    errors = legacy.schema_errors(data, 'output.schema.json')
    if errors:
        return errors
    try:
        restored = layout.to_v2(data)
    except (ValueError, KeyError, TypeError, IndexError) as exc:
        return [str(exc)]
    return legacy.validate(restored, paper, sample_record, base, pdf_path, workspace)
