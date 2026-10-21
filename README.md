# Accounting paper candidates and sample extraction

This directory contains **500 empirical papers: 100 each from TAR, JAR, JAE,
CAR and RAST**, published in journal issue years 2000–2020 inclusive. Selection
uses total OpenAlex citations within each journal, after empirical screening;
FWCI is retained separately. The set includes archival, experimental, survey,
interview and quantitative meta-analysis research. It is not restricted to US
Compustat studies. Citation counts are the saved search snapshot, not live values.

## Files

| Path | Contents |
| --- | --- |
| `papers.csv`, `papers.jsonl` | Same 500-paper manifest: journal, rank, title, authors, DOI, year, citations, FWCI, relative file paths and SHA-256 checksums. |
| `papers/pdf/<OpenAlex-ID>.pdf` | 500 copied PDFs. |
| `papers/parsed/<OpenAlex-ID>.json` | 500 existing page-addressable reading copies, preserved byte for byte. |
| `scripts/pdf_to_json.py` | Single-file converter for a PDF or directory; independent of OpenAlexAEF. |
| `skills/extract-accounting-samples/` | Sample-extraction skill, schema, editable database list, observation-unit vocabulary and validators. |
| `tests/test_pdf_to_json.py` | Local integrity tests using small synthetic PDFs. |

Manifest paths are relative to this directory. Existing reading JSONs retain
historical absolute provenance paths because changing them would break byte
identity. Use the manifest's `pdf_path` and `reading_json` to locate each local
pair. Five pairs use a different PDF version from the original selection
manifest, specifically the version named by the cached reading copy. Nine
legacy copies omit a blank trailing page; all nine were checked to be blank.
No omitted page with visible content was found. The manifest records version choices and any omitted pages; page numbers have
not been shifted.

## Environment

Use Python 3.12 or later with the pinned requirements (NumPy requires 3.12).
The tested environment is Python 3.12.14; `requirements.txt` records the tested
package versions. They are already
installed on the current machine. On another machine, use an isolated environment:

```bash
python -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
```

The examples below run from this directory. On this machine, `python` can be
replaced with `/opt/tljh/user/bin/python`.

## Convert PDFs

Convert one PDF:

```bash
python scripts/pdf_to_json.py /path/to/paper.pdf -o new_parse/paper.json
```

Convert the PDFs directly inside a directory. Subdirectories are skipped.
`--workers` starts separate processes; the default is one.

```bash
python scripts/pdf_to_json.py /path/to/incoming_pdfs -o new_parse \
  --workers 2
```

The default `--ocr auto` extracts healthy selectable text as Markdown, including
tables, and uses local RapidOCR for pages with sparse or damaged text layers.
The checks and OCR settings are adapted from
`OpenAlexAEF/gcloud/build_index.py` and `clean_cache.py`; the converter does not
import their indexing, embedding or LangChain code. It does not send document
content to a service. First OCR use downloads missing model weights into
`OUTPUT_DIRECTORY/.ocr_models`; `--model-dir /path/to/models` selects another
writable cache. Later use of those cached weights works offline.

To extract selectable text with **no OCR**:

```bash
python scripts/pdf_to_json.py /path/to/paper.pdf -o new_parse/paper.json \
  --ocr never --verbose
```

`--format text` uses plain selectable text instead of Markdown.
`--ocr always` renders and OCRs every nonblank page.
`--min-selectable-chars` defaults to **400 characters per page**. In automatic
mode, shorter nonblank pages use OCR. Other checks also detect damaged text
layers. Disabling OCR retains the available text and flags suspect pages for
review. Every conversion processes the full PDF, including blank physical pages.
PDF tables and OCR errors can still require visual inspection.

**Existing JSON files are overwritten by default.** Use `--no-overwrite` to skip
existing files as they are, without parsing the PDF or verifying the old JSON:

```bash
python scripts/pdf_to_json.py papers/pdf -o papers/parsed --no-overwrite
```

Writes replace the destination only after conversion succeeds. A failed PDF
does not stop the other files in a directory, and the process exits with code 1
when any file fails (0 for successful conversion/skipping, 2 for invalid
arguments). Per-file outcomes and a final summary are printed as JSON lines on
stdout; use shell redirection to save them if needed. Inspect each reading JSON's
`status` and `warnings` for review needs.

Fresh parsing can change text order, OCR output and provenance metadata. It is
not guaranteed to reproduce an older JSON byte for byte. Manifest hashes describe
the original imported files; regenerating a JSON changes its checksum.

## Reading JSON and the extraction skill

The common input interface is:

```json
{
  "paper_id": "W123456789",
  "title": "Paper title",
  "doi": null,
  "pdf_path": "../pdf/W123456789.pdf",
  "pages": [{"page": 1, "text": "Full text of PDF page 1"}]
}
```

`page` is the one-based physical PDF page, including cover pages. Fresh output
also records PDF SHA-256, page extraction methods, warnings, converter settings
and package versions. Its `pdf_path` is relative to the JSON file's directory.
The paper ID comes from the PDF filename stem; the title comes from PDF metadata
or falls back to that stem. Fresh output leaves `doi` null; known bibliographic
metadata remain in `papers.jsonl`. This reading JSON is the **input** to an agent, not an
automatically completed sample-extraction result.

Give an agent `skills/extract-accounting-samples/SKILL.md`, the chosen reading
JSON and its paired PDF. The skill directs it to find the baseline/main test or
table and return its sample size, standardized unit, period, data sources,
complete relevant data-section text and page-linked evidence. It stops once that
information is supported. Auxiliary pilots, robustness checks and secondary
comparisons are excluded; rare co-primary samples retain separate entries.
Missing information stays explicit. Save results separately, for example as
`extractions/<OpenAlex-ID>.json`. Validate one result with:

```bash
python skills/extract-accounting-samples/scripts/validate_extraction.py \
  extractions/W2023709878.json --paper-text papers/parsed/W2023709878.json
```

Edit the `enum` array in
`skills/extract-accounting-samples/references/databases.json` to change the
standardized database list. Optional spellings go in that file's `x-aliases`.
The schema and validator use this one file, so no code or schema changes are
needed. Other named commercial products belong in `commercial_nonstandardized`.
The original full SAS data catalog is not required to run the skill.

## Validation performed

At import, all 500 copied PDFs and all 500 copied JSONs were checksum-verified.
The text/OCR extraction was checked on two native-text pages and one forced-OCR
page. No full conversion or OCR sweep was run.

Nine current synthetic integrity tests cover full-PDF extraction, blank pages,
default overwriting, skipping existing files, preservation after conversion
failure, directory multiprocessing, corrupt-file isolation, output collisions
and the simplified help message:

```bash
python -m unittest discover -s tests -v
```

Package/API references: [PyMuPDF4LLM](https://pymupdf.readthedocs.io/en/latest/pymupdf4llm/api.html)
and [RapidOCR parameters](https://rapidai.github.io/RapidOCRDocs/main/install_usage/rapidocr/parameters/).
