#!/usr/bin/env python3
"""Convert one PDF or a directory of PDFs to page-addressable reading-copy JSON.

Examples (run from git/):
    python scripts/pdf_to_json.py paper.pdf -o papers/parsed/
    python scripts/pdf_to_json.py papers/pdf -o papers/parsed --workers 4
    python scripts/pdf_to_json.py papers/pdf -o new_parse --ocr never

Self-contained: no imports from OpenAlexAEF, LangChain, a vector index, or an LLM.
The adaptive text/OCR checks are adapted from OpenAlexAEF/gcloud/build_index.py
and clean_cache.py. RapidOCR downloads missing weights on first use into
--model-dir (by default OUTPUT_DIRECTORY/.ocr_models). Document content stays local.
"""
from __future__ import annotations

import argparse
from collections import Counter
from concurrent.futures import ProcessPoolExecutor, as_completed
import contextlib
from datetime import datetime, timezone
import hashlib
import importlib.metadata
import io
import json
import multiprocessing
import os
from pathlib import Path
import sys
import tempfile
import time
import unicodedata

VERSION = '1.1.0'
STOPWORDS = frozenset(('the', 'of', 'and', 'to', 'in', 'is', 'a', 'that', 'this', 'with', 'for', 'on', 'by'))
CONTROL_CHARS = set(range(32)) - {9, 10, 13}
LIGATURES = str.maketrans({'\ufb00':'ff', '\ufb01':'fi', '\ufb02':'fl', '\ufb03':'ffi', '\ufb04':'ffl'})
_OCR = None
_OCR_INIT_LOCK = None


def normalize(text):
    # Preserve numbers, fractions, equations, Markdown, line breaks and footnotes.
    return unicodedata.normalize('NFC', text).translate(LIGATURES).replace('\u00ad', '').replace('\r\n', '\n').strip()


def sha256(path):
    digest = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(block)
    return digest.hexdigest()


def stutter_ratio(text):
    """Detect repeated text layers using the original parser's within-line rate."""
    duplicates = total = 0
    for line in text.splitlines():
        words = line.split()
        if len(words) < 2:
            continue
        total += len(words)
        for first, second in zip(words, words[1:]):
            if not first.endswith('-') and not second.endswith('-') and first == second and first.lower() in STOPWORDS:
                duplicates += 1
    return duplicates / total if total >= 40 else 0.0


def suspect_text(text, minimum):
    reasons = []
    if len(text.strip()) < minimum:
        reasons.append('insufficient_selectable_text')
    words = text.split()
    if len(words) > 20 and sum(len(w) == 1 and w.isalnum() for w in words) / len(words) > 0.5:
        reasons.append('spaced_letters')
    if text and sum(ord(c) in CONTROL_CHARS for c in text) / len(text) > 0.1:
        reasons.append('undecodable_text_layer')
    if text.count('\ufffd') / max(1, len(text)) > 0.05:
        reasons.append('replacement_characters')
    if stutter_ratio(text) > 0.01:
        reasons.append('duplicated_text_layer')
    return reasons


def dependencies():
    found = {}
    for name in ('PyMuPDF', 'pymupdf4llm', 'rapidocr', 'onnxruntime', 'Pillow', 'numpy'):
        try:
            found[name] = importlib.metadata.version(name)
        except importlib.metadata.PackageNotFoundError:
            found[name] = None
    return found


def relative_path(source, output):
    try:
        return Path(os.path.relpath(source, output.parent)).as_posix()
    except ValueError:  # Different Windows drives.
        return str(source)


def is_blank_page(page, text):
    if text.strip():
        return False
    if not page.get_images() and not page.get_drawings():
        return True
    # Some publisher PDFs end with a white rectangle covering an empty page.
    # Exact white pixels avoid classifying faint text or scan noise as blank.
    import fitz
    return min(page.get_pixmap(dpi=72, colorspace=fitz.csGRAY, alpha=False).samples) == 255


def get_ocr(model_dir):
    global _OCR
    if _OCR is not None:
        return _OCR
    try:
        from rapidocr import LangRec, RapidOCR
    except ImportError as error:
        raise RuntimeError('OCR requires rapidocr and onnxruntime; install requirements.txt or use --ocr never.') from error
    model_dir.mkdir(parents=True, exist_ok=True)
    params = {
        'Global.log_level':'WARNING', 'Global.text_score':0.6,
        'Global.model_root_dir':str(model_dir), 'Rec.lang_type':LangRec.EN,
        'Det.limit_side_len':960,
        'EngineConfig.onnxruntime.intra_op_num_threads':1,
        'EngineConfig.onnxruntime.inter_op_num_threads':1,
    }
    # Avoid simultaneous weight downloads by workers in the same batch.
    with _OCR_INIT_LOCK if _OCR_INIT_LOCK is not None else contextlib.nullcontext():
        try:
            with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
                _OCR = RapidOCR(params=params)
        except Exception as error:
            raise RuntimeError(f'Cannot initialize RapidOCR ({type(error).__name__}). '
                               f'Missing weights need a first download into {model_dir}; '
                               'use a writable model directory with network access or cached weights.') from None
    return _OCR


def ocr_page(page, options):
    import numpy as np
    from PIL import Image
    engine = get_ocr(Path(options['model_dir']))
    pixmap = page.get_pixmap(dpi=options['dpi'], alpha=False)
    with Image.open(io.BytesIO(pixmap.tobytes('png'))) as image:
        result = engine(np.asarray(image.convert('RGB')))
    if result is None or result.txts is None or len(result.txts) == 0:
        return '', None
    scores = getattr(result, 'scores', None)
    confidence = None
    if scores is not None and len(scores):
        confidence = {'mean':round(float(np.mean(scores)), 4), 'minimum':round(float(np.min(scores)), 4)}
    return '\n'.join(result.txts), confidence


def atomic_write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    name = None
    try:
        with tempfile.NamedTemporaryFile('w', encoding='utf-8', dir=path.parent,
                                         prefix='.' + path.name + '.', suffix='.tmp', delete=False) as stream:
            name = stream.name
            json.dump(data, stream, ensure_ascii=False, indent=2, allow_nan=False)
            stream.write('\n')
        os.replace(name, path)
    finally:
        if name is not None and os.path.exists(name):
            os.unlink(name)


def convert_pdf(source, output, options):
    source, output = Path(source).resolve(), Path(output).resolve()
    if source == output:
        raise ValueError('Output must differ from the source PDF.')
    if output.exists() and not options['overwrite']:
        return {'status':'skipped', 'input':str(source), 'output':str(output)}
    import fitz
    versions = dependencies()
    settings = {k:options[k] for k in ('ocr', 'format', 'min_selectable_chars', 'dpi')}
    digest = sha256(source)
    pdf_path = relative_path(source, output)
    markdown = None
    if options['format'] == 'markdown':
        try:
            with contextlib.redirect_stdout(io.StringIO()):
                import pymupdf4llm as markdown
        except ImportError:
            raise RuntimeError('Markdown extraction requires pymupdf4llm; install requirements.txt or use --format text.') from None
    pages, methods, warnings = [], Counter(), []
    with fitz.open(source) as document:
        if document.needs_pass:
            raise ValueError('The PDF is encrypted; supply an unlocked copy.')
        total = len(document)
        if not total:
            raise ValueError('The PDF contains no pages.')
        header_info = None
        title = ((document.metadata or {}).get('title') or '').strip() or source.stem
        for n in range(total):
            page = document[n]
            raw = page.get_text(sort=True).strip()
            reasons = suspect_text(raw, options['min_selectable_chars'])
            blank = is_blank_page(page,raw)
            needs_ocr = options['ocr'] == 'always' or bool(reasons)
            entry = {'page':n+1, 'text':'', 'extraction_method':'blank' if blank else 'text', 'warnings':[]}
            if blank:
                text = ''
            elif needs_ocr and options['ocr'] != 'never':
                text, confidence = ocr_page(page, options)
                entry.update(extraction_method='ocr', ocr_reason=reasons or ['forced'], ocr_confidence=confidence)
                if not text.strip():
                    # Retain a sparse healthy original rather than discard a heading or page number.
                    if raw and reasons == ['insufficient_selectable_text']:
                        text = raw
                        entry['extraction_method'] = 'text'
                    entry['warnings'].append('OCR returned no usable text; inspect the PDF page.')
            else:
                text = raw
                if reasons:
                    entry['warnings'].append('OCR disabled for a suspect text layer: ' + ', '.join(reasons))
                if markdown is not None and not reasons:
                    try:
                        # Match the original O(N) header scan, rather than scanning the whole PDF per page.
                        with contextlib.redirect_stdout(io.StringIO()):
                            if header_info is None:
                                header_info = markdown.IdentifyHeaders(document)
                            rendered = markdown.to_markdown(document, pages=[n], hdr_info=header_info,
                                                            use_ocr=False, show_progress=False)
                        if len(rendered.strip()) < 0.5 * len(raw) or rendered.count('\ufffd') / max(1, len(rendered)) > 0.05:
                            entry['markdown_fallback'] = 'Markdown omitted too much text or had damaged encoding; retained native text.'
                        else:
                            text, entry['extraction_method'] = rendered, 'markdown'
                    except Exception as error:
                        entry['markdown_fallback'] = f'Markdown extraction failed ({type(error).__name__}); retained native text.'
            entry['text'] = normalize(text)
            methods[entry['extraction_method']] += 1
            if entry['warnings']:
                warnings.append(f'PDF page {n+1}: ' + ' '.join(entry['warnings']))
            pages.append(entry)
            if options['verbose']:
                print(f'{source.name}: page {n+1}/{total} [{entry["extraction_method"]}]', file=sys.stderr, flush=True)
    data = {
        'reading_copy_version':'1.0', 'paper_id':source.stem,
        'title':title, 'doi':None, 'pdf_path':pdf_path,
        'text_source':pdf_path, 'text_origin':'pdf_adaptive_text_ocr', 'source_sha256':digest,
        'created_at':datetime.now(timezone.utc).isoformat(), 'total_pdf_pages':total,
        'processed_pages':total, 'truncated':False,
        'status':'needs_review' if warnings else 'complete', 'warnings':warnings,
        'converter':{'name':'pdf_to_json', 'version':VERSION, 'settings':settings, 'dependencies':versions},
        'pages':pages,
    }
    atomic_write(output, data)
    return {'status':'converted', 'input':str(source), 'output':str(output),
            'pages':total, 'methods':dict(methods), 'needs_review':bool(warnings)}


def initialize_worker(lock):
    global _OCR_INIT_LOCK
    _OCR_INIT_LOCK = lock


def run_job(job):
    source, output, options = job
    try:
        return convert_pdf(source, output, options)
    except Exception as error:
        return {'status':'error', 'input':str(source), 'output':str(output),
                'error':f'{type(error).__name__}: {error}'}


def positive_integer(value):
    result = int(value)
    if result < 1:
        raise argparse.ArgumentTypeError('Must be a positive integer.')
    return result


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('input', type=Path, help='One PDF or a directory of PDFs (case-insensitive extension).')
    parser.add_argument('-o', '--output', type=Path, default=Path('parsed'), help='Output directory; a .json filename is also accepted for one PDF. Default: ./parsed')
    parser.add_argument('-j', '--workers', type=positive_integer, default=1, help='Worker processes (1–16; default: 1).')
    parser.add_argument('--ocr', choices=('auto','always','never'), default='auto', help='Use OCR for suspect pages, every nonblank page, or no pages. Default: auto')
    parser.add_argument('--format', choices=('markdown','text'), default='markdown', help='Selectable-page text format; default: markdown (table-aware).')
    parser.add_argument('--min-selectable-chars', type=positive_integer, default=400,
                        help='Minimum selectable text characters per page; shorter nonblank pages use OCR in auto mode (default: 400).')
    parser.add_argument('--dpi', type=positive_integer, default=150, help='OCR rendering resolution; default: 150.')
    parser.add_argument('--model-dir', type=Path, help='Writable RapidOCR weight cache; default: OUTPUT_DIRECTORY/.ocr_models')
    parser.add_argument('--overwrite', action=argparse.BooleanOptionalAction, default=True,
                        help='Replace existing JSON (default: true); --no-overwrite skips existing files.')
    parser.add_argument('-v', '--verbose', action='store_true', help='Print progress for every page to stderr.')
    args = parser.parse_args(argv)
    source, output = args.input.expanduser().resolve(), args.output.expanduser().resolve()
    if args.workers > 16:
        parser.error('--workers must be between 1 and 16.')
    if not source.exists():
        parser.error(f'Input does not exist: {source}')
    if source.is_file():
        if source.suffix.lower() != '.pdf':
            parser.error('The input file must have a .pdf extension.')
        files = [source]
    else:
        files = sorted(p for p in source.iterdir() if p.is_file() and p.suffix.lower() == '.pdf')
    if not files:
        parser.error('No PDF files were found.')
    if source.is_dir() and output.suffix.lower() == '.json':
        parser.error('A directory input requires an output directory.')
    if output.suffix.lower() == '.json':
        targets, output_dir = [output], output.parent
    else:
        output_dir = output
        targets = [output / (p.stem + '.json') for p in files]
    if len(set(targets)) != len(targets):
        parser.error('Multiple PDFs would write the same JSON path (for example paper.pdf and paper.PDF).')
    options = vars(args).copy()
    options['model_dir'] = str((args.model_dir.expanduser().resolve() if args.model_dir else output_dir / '.ocr_models'))
    jobs = [(pdf, target, options) for pdf,target in zip(files,targets)]
    outcomes, started = [], time.monotonic()
    def record(result):
        outcomes.append(result)
        print(json.dumps(result, ensure_ascii=False), flush=True)
    if args.workers == 1:
        for job in jobs:
            record(run_job(job))
    else:
        context = multiprocessing.get_context('spawn')
        with ProcessPoolExecutor(max_workers=min(args.workers,len(jobs)), mp_context=context,
                                 initializer=initialize_worker, initargs=(context.Lock(),)) as pool:
            for future in as_completed([pool.submit(run_job, job) for job in jobs]):
                record(future.result())
    summary = dict(Counter(r['status'] for r in outcomes))
    summary['needs_review'] = sum(r.get('needs_review',False) for r in outcomes)
    print(json.dumps({'summary':summary, 'input_files':len(files), 'seconds':round(time.monotonic()-started,2)}),flush=True)
    return 1 if summary.get('error') else 0


if __name__ == '__main__':
    raise SystemExit(main())
