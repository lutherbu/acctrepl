#!/usr/bin/env python3
"""Render one source PDF region and save reproducible image evidence; no OCR."""
import argparse
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

import pymupdf


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def render(pdf, page, output, bbox=None, scale=3, workspace=None, description='Source table region'):
    root = Path(workspace or Path.cwd()).resolve()
    pdf, output = Path(pdf).resolve(), Path(output).resolve()
    if not pdf.is_relative_to(root) or not output.is_relative_to(root):
        raise ValueError('PDF and evidence output must be inside the workspace')
    if not 0 < scale <= 8:
        raise ValueError('Scale must be in (0,8]')
    with pymupdf.open(pdf) as doc:
        if not 1 <= page <= len(doc):
            raise ValueError('Physical PDF page is out of range')
        source = doc[page - 1]
        clip = pymupdf.Rect(bbox) if bbox else source.rect
        if clip.is_empty or not source.rect.contains(clip):
            raise ValueError('Crop must be a nonempty rectangle within the source page')
        payload = source.get_pixmap(matrix=pymupdf.Matrix(scale, scale), clip=clip, alpha=False).tobytes('png')
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(payload)
    result = {'page': page, 'pdf_sha256': sha(pdf), 'bbox': list(clip), 'scale': scale,
              'crop_path': str(output.relative_to(root)), 'crop_sha256': sha(output),
              'description': description}
    output.with_suffix('.evidence.json').write_text(json.dumps(result, indent=2) + '\n')
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('pdf', type=Path)
    parser.add_argument('--page', type=int, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--bbox', type=float, nargs=4)
    parser.add_argument('--scale', type=float, default=3, help='PDF rendering scale (default: 3)')
    parser.add_argument('--workspace', type=Path, default=Path.cwd())
    parser.add_argument('--description', default='Source table region')
    args = parser.parse_args()
    try:
        result = render(args.pdf, args.page, args.output, args.bbox, args.scale, args.workspace, args.description)
    except (ValueError, OSError) as exc:
        parser.exit(1, f'{exc}\n')
    print(json.dumps(result))


if __name__ == '__main__':
    main()
