#!/usr/bin/env python3
"""Calculate supported inference in schema 2 or variable-centered schema 3."""
import argparse
import importlib.util
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


def sibling(name):
    path = Path(__file__).with_name(name + '.py')
    spec = importlib.util.spec_from_file_location(name + hashlib.sha256(str(path).encode()).hexdigest()[:12], path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


core = sibling('derive_statistics_v2')
layout = sibling('convert_schema')
# Keep the existing constructor/API interface and numerical core provenance.
sha, parse_number, number_cell = core.sha, core.parse_number, core.number_cell
printed_half_width, p_cell, context = core.printed_half_width, core.p_cell, core.context
derive_parameter, variable_id = core.derive_parameter, core.variable_id
merge_enrichment, load_records = core.merge_enrichment, core.load_records


def calculate(data):
    if data.get('schema_version') == '3.0':
        return layout.to_v3(core.calculate(layout.to_v2(data)))
    return core.calculate(data)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', type=Path)
    parser.add_argument('--output', '-o', type=Path, required=True)
    parser.add_argument('--specifications', type=Path)
    parser.add_argument('--schema-version', choices=['2.0', '3.0'],
                        help='Default: preserve full input format; raw enrichments emit 3.0.')
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
                record = layout.to_v3(record) if args.schema_version != '2.0' else record
            else:
                record = calculate(record)
                if args.schema_version == '3.0':
                    record = layout.to_v3(record)
                elif args.schema_version == '2.0':
                    record = layout.to_v2(record)
            output.append(record)
        if args.output.suffix != '.jsonl' and len(output) != 1:
            raise ValueError('Multiple records require a .jsonl output')
        args.output.parent.mkdir(parents=True, exist_ok=True)
        payload = ''.join(json.dumps(r, ensure_ascii=False, allow_nan=False) + '\n' for r in output) if args.output.suffix == '.jsonl' else json.dumps(output[0], ensure_ascii=False, indent=2, allow_nan=False) + '\n'
        temporary = args.output.with_suffix(args.output.suffix + '.tmp')
        temporary.write_text(payload); temporary.replace(args.output)
    except (ValueError, OSError, KeyError, TypeError, ZeroDivisionError) as exc:
        parser.exit(1, f'{exc}\n')
    print(json.dumps({'records': len(output), 'output': str(args.output)}))


if __name__ == '__main__':
    main()
