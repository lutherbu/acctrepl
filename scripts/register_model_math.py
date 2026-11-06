#!/usr/bin/env python3
"""Register independently checked mathematical transcriptions as reading input.

This copies supplied text; it does not verify mathematics or call an AI model.
The reviewer must inspect every referenced source crop before registration.
"""
import argparse
from datetime import datetime, timezone
import hashlib
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

ROOT = Path(__file__).resolve().parents[1]
RUNS = Path(_layout.work_root('model_extraction', ROOT)) if _layout else ROOT / 'output/model_extraction_runs'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def register(source):
    record = json.loads(Path(source).read_text())
    if not record.get('reviewer') or not record.get('blocks'):
        raise ValueError('Reviewer and independently checked blocks are required')
    manifest = {r['paper_id']: r for line in (RUNS / 'input_manifest.jsonl').read_text().splitlines()
                if line.strip() for r in [json.loads(line)]}
    original = manifest[record['paper_id']]
    reading_path = ROOT / original['reading_json']
    pdf_path = ROOT / original['pdf_path']
    if sha(reading_path) != original['reading_json_sha256'] or sha(pdf_path) != original['pdf_sha256']:
        raise ValueError('Original source hash changed')
    data = json.loads(reading_path.read_text())
    source_hash = sha(Path(source))
    archive = RUNS / 'verified_transcriptions'
    archive.mkdir(exist_ok=True)
    archived_source = archive / f"{record['paper_id']}_{source_hash[:16]}.json"
    if archived_source.exists() and sha(archived_source) != source_hash:
        raise ValueError('Archived transcription hash collision')
    if not archived_source.exists():
        archived_source.write_bytes(Path(source).read_bytes())
    pages = {p['page']: p for p in data['pages']}
    image_hashes = {}
    seen = set()
    for block in record['blocks']:
        key = block['page'], block['label']
        if key in seen or block['page'] not in pages or not block['text'].strip():
            raise ValueError(f'Invalid or repeated block: {key}')
        seen.add(key)
        if not block.get('images'):
            raise ValueError(f'Source crop required for {key}')
        for relative in block['images']:
            image_path = (ROOT / relative).resolve()
            if not image_path.is_relative_to(ROOT):
                raise ValueError('Source image must be within the git workspace')
            image_hashes[relative] = sha(image_path)
        pages[block['page']]['text'] += ('\n\nCOORDINATOR-VERIFIED MATHEMATICAL TRANSCRIPTION '
            f"({block['label']}, physical PDF page {block['page']}):\n{block['text']}\n")
    data['model_math_review'] = {
        'reviewer': record['reviewer'], 'reviewed_at': datetime.now(timezone.utc).isoformat(),
        'original_reading_file': original['reading_json'],
        'original_reading_sha256': original['reading_json_sha256'],
        'pdf_file': original['pdf_path'], 'pdf_sha256': original['pdf_sha256'],
        'transcription_file': str(archived_source.relative_to(ROOT)),
        'transcription_sha256': source_hash, 'source_crop_sha256': image_hashes,
        'verified_blocks': [{'page': b['page'], 'label': b['label']} for b in record['blocks']],
        'notes': record.get('notes', []),
    }
    directory = RUNS / 'verified_readings'
    directory.mkdir(exist_ok=True)
    payload = (json.dumps(data, ensure_ascii=False, indent=2) + '\n').encode()
    reading_hash = hashlib.sha256(payload).hexdigest()
    output = directory / f"{record['paper_id']}_{reading_hash[:16]}.json"
    if output.exists() and sha(output) != reading_hash:
        raise ValueError('Verified reading hash collision')
    if not output.exists():
        output.write_bytes(payload)
    registry_path = RUNS / 'verified_readings.json'
    registry = json.loads(registry_path.read_text()) if registry_path.exists() else {}
    registry[record['paper_id']] = {
        'path': str(output.relative_to(ROOT)), 'sha256': sha(output),
        'original_reading_sha256': original['reading_json_sha256'],
        'pdf_sha256': original['pdf_sha256'],
        'verification': 'Independent coordinator review of source PDF crops; normalized math appended, original text preserved.',
        'verified_blocks': data['model_math_review']['verified_blocks'],
    }
    temporary = registry_path.with_suffix('.json.tmp')
    temporary.write_text(json.dumps(registry, ensure_ascii=False, indent=2) + '\n')
    temporary.replace(registry_path)
    return registry[record['paper_id']]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('transcription_json', type=Path)
    args = parser.parse_args()
    try:
        print(json.dumps(register(args.transcription_json), ensure_ascii=False, indent=2))
    except (OSError, ValueError, KeyError) as exc:
        parser.exit(1, f'{exc}\n')


if __name__ == '__main__':
    main()
