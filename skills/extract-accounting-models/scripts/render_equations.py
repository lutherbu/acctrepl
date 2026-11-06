#!/usr/bin/env python3
"""Render embedded equation-image candidates from selected physical PDF pages.

No OCR or transcription is performed. Inspect the crops and verify the formula.
"""
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

import fitz


def render(pdf, pages, output_dir, scale=5):
    pdf, output_dir = Path(pdf), Path(output_dir)
    with fitz.open(pdf) as doc:
        if not pages or any(p < 1 or p > len(doc) for p in pages):
            raise ValueError('Pages must be one-based physical pages within this PDF')
        if scale <= 0:
            raise ValueError('Scale must be positive')
        output_dir.mkdir(parents=True, exist_ok=True)
        inventory = {'pdf_file': str(pdf.resolve()),
                     'pdf_sha256': hashlib.sha256(pdf.read_bytes()).hexdigest(),
                     'note': 'Wide embedded images are candidates, not guaranteed equations. Text/vector formulas may have no candidate. No mathematical text was inferred.',
                     'pages': []}
        for number in sorted(set(pages)):
            page = doc[number - 1]
            candidates = []
            seen = set()
            for info in sorted(page.get_image_info(), key=lambda r: (r['bbox'][1], r['bbox'][0])):
                w, h = info['width'], info['height']
                bbox = tuple(info['bbox'])
                if w < 60 or h < 8 or w / h < 4 or bbox in seen:
                    continue
                seen.add(bbox)
                box = fitz.Rect(bbox)
                box = fitz.Rect(box.x0 - 4, box.y0 - 4, box.x1 + 4, box.y1 + 4) & page.rect
                if box.is_empty:
                    continue
                path = output_dir / f'{pdf.stem}_p{number:04}_equation{len(candidates)+1:02}.png'
                page.get_pixmap(matrix=fitz.Matrix(scale, scale), colorspace=fitz.csGRAY,
                                clip=box).save(path)
                candidates.append({'image_file': path.name, 'bbox_pdf_points': list(bbox),
                                   'source_image_width': w, 'source_image_height': h,
                                   'render_scale': scale})
            inventory['pages'].append({'page': number, 'candidates': candidates})
    target = output_dir / f'{pdf.stem}_equation_images.json'
    target.write_text(json.dumps(inventory, ensure_ascii=False, indent=2) + '\n')
    return inventory


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('pdf', type=Path)
    parser.add_argument('--pages', type=int, nargs='+', required=True,
                        help='One-based physical PDF pages, including covers.')
    parser.add_argument('--output-dir', type=Path, required=True)
    parser.add_argument('--scale', type=float, default=5,
                        help='Rendering scale in PDF points (default: 5, about 360 DPI).')
    args = parser.parse_args()
    try:
        result = render(args.pdf, args.pages, args.output_dir, args.scale)
    except (OSError, ValueError, RuntimeError) as exc:
        parser.exit(1, f'{exc}\n')
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
