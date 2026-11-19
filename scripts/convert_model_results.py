#!/usr/bin/env python3
"""Convert model results between JSON/JSONL schema versions."""
import argparse
from copy import deepcopy
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
from pathlib import Path

# Resolve frozen artifact locations without rewriting research records.
_layout_root = Path(__file__).resolve().parents[1]
_layout = None
if (_layout_root / "project_layout.py").is_file():
    import sys as _layout_sys
    _layout_sys.path.insert(0, str(_layout_root))
    import project_layout as _layout
    Path = _layout.path_class(_layout_root)
import re
import shutil
import tempfile


ROOT = Path(__file__).resolve().parents[1]
SKILL_REL = Path('skills/extract-accounting-models')
def load_module(path):
    spec = importlib.util.spec_from_file_location('conversion_' + hashlib.sha256(str(path).encode()).hexdigest()[:12], path)
    module = importlib.util.module_from_spec(spec); spec.loader.exec_module(module)
    return module


def modules(skill):
    return (load_module(skill / 'scripts/convert_schema.py'),
            load_module(skill / 'scripts/validate_results.py'))


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    return json.loads(Path(path).read_text())


def records(path):
    path = Path(path)
    if path.suffix == '.jsonl':
        with path.open() as stream:
            for line in stream:
                if line.strip():
                    yield json.loads(line)
    else:
        yield read(path)


def write(path, value):
    path = Path(path); path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + '.tmp')
    temporary.write_text(json.dumps(value, indent=2, ensure_ascii=False, allow_nan=False) + '\n')
    temporary.replace(path)


def checked_convert(record, layout, validator, reverse=False):
    source_version, schema = ('3.0', 'output.schema.json') if reverse else ('2.0', 'output.v2.schema.json')
    if record.get('schema_version') != source_version:
        raise ValueError(f'Expected schema {source_version}, got {record.get("schema_version")}')
    errors = validator.schema_errors(record, schema)
    if errors:
        raise ValueError(f'{record.get("paper_id")}: {errors[0]}')
    converted = layout.to_v2(record) if reverse else layout.to_v3(record)
    if not reverse and layout.canonical(layout.to_v2(converted)) != layout.canonical(record):
        raise ValueError(f'{record["paper_id"]}: conversion failed lossless round-trip')
    errors = validator.schema_errors(converted, 'output.v2.schema.json' if reverse else 'output.schema.json')
    if errors:
        raise ValueError(f'{record["paper_id"]}: {errors[0]}')
    return converted


def convert_file(source, output, reverse=False, skill=None):
    source, output = Path(source), Path(output)
    if source.resolve() == output.resolve():
        raise ValueError('Input and output must differ')
    layout, validator = modules(skill or ROOT / SKILL_REL)
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = output.with_suffix(output.suffix + '.tmp')
    count, ids = 0, set()
    try:
        with temporary.open('w') as stream:
            for record in records(source):
                if not isinstance(record, dict) or not record.get('paper_id'):
                    raise ValueError('Each record needs a paper_id')
                if record['paper_id'] in ids:
                    raise ValueError('Duplicate paper_id in input')
                ids.add(record['paper_id'])
                data = checked_convert(record, layout, validator, reverse)
                count += 1
                if output.suffix != '.jsonl' and count > 1:
                    raise ValueError('Multiple records require a .jsonl output')
                stream.write(json.dumps(data, ensure_ascii=False, allow_nan=False,
                                        indent=None if output.suffix == '.jsonl' else 2) + '\n')
        if not count:
            raise ValueError('Input contains no records')
        temporary.replace(output)
    finally:
        temporary.unlink(missing_ok=True)
    return {'records': count, 'output': str(output), 'sha256': sha(output)}


def main():
    parser=argparse.ArgumentParser(description='Convert one model JSON or JSONL file between schema versions.')
    parser.add_argument('input',type=Path)
    parser.add_argument('--output','-o',type=Path,required=True)
    parser.add_argument('--reverse',action='store_true',help='Convert schema 3 to schema 2.')
    args=parser.parse_args()
    try:
        print(json.dumps(convert_file(args.input,args.output,args.reverse),ensure_ascii=False))
    except (OSError,ValueError,KeyError,TypeError) as error:
        parser.exit(1,str(error)+'\n')


if __name__=='__main__':
    main()
