#!/usr/bin/env python3
"""Copy complete anchored source sections into an existing extraction JSON file."""
import argparse
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


def assemble(result, paper):
    pages = {p['page']: p['text'] for p in paper['pages']}
    sections = []
    for span in result['data_section_spans']:
        begin, end = span['page_begin'], span['page_end']
        start_anchor, end_anchor = span['start_anchor'], span['end_anchor']
        if pages[begin].count(start_anchor) != 1 or pages[end].count(end_anchor) != 1:
            raise ValueError('Use unique literal anchors on the specified PDF pages')
        page_range = [p for p in sorted(pages) if begin <= p <= end]
        selected = []
        for n in page_range:
            text = pages[n]
            start = text.index(start_anchor) if n == begin else 0
            finish = text.index(end_anchor) + len(end_anchor) if n == end else len(text)
            if n == begin == end and finish < start:
                raise ValueError('End anchor precedes start anchor')
            selected.append(text[start:finish])
        sections.append('\n\n'.join(selected))
    result['data_section_full_text'] = '\n\n'.join(sections)
    return result


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('result', type=Path)
    ap.add_argument('--paper-text', type=Path, required=True)
    args = ap.parse_args()
    result = json.loads(args.result.read_text())
    paper = json.loads(args.paper_text.read_text())
    if result['paper_id'] != paper['paper_id']:
        raise ValueError('Paper ID mismatch')
    args.result.write_text(json.dumps(assemble(result, paper), ensure_ascii=False, indent=2) + '\n')
