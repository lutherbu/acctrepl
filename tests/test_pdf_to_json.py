"""Small, local integrity tests. Synthetic PDFs only; no OCR or network."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

import fitz

SCRIPT = Path(__file__).resolve().parents[1] / 'scripts/pdf_to_json.py'


class ConverterTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)

    def tearDown(self):
        self.temp.cleanup()

    def pdf(self, name='paper.pdf', blank=False):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        with fitz.open() as doc:
            page = doc.new_page()
            page.insert_textbox(fitz.Rect(40,40,550,700), (
                'DATA AND SAMPLE\nThe final sample contains 1234 firm-year observations. '
                'The sample period is 2001 to 2005. Data are from Compustat and CRSP.\n' * 8))
            if blank:
                page = doc.new_page()
                page.draw_rect(page.rect, color=(1,1,1), fill=(1,1,1))
            doc.save(path)
        return path

    def cli(self, *args, code=0):
        result = subprocess.run([sys.executable,str(SCRIPT),*map(str,args)], capture_output=True, text=True)
        self.assertEqual(result.returncode,code,result.stdout+'\n'+result.stderr)
        return result

    def test_text_pages_and_relative_pdf_path(self):
        pdf = self.pdf(blank=True);out = self.root/'parsed/paper.json'
        self.cli(pdf,'-o',out,'--format','text','--ocr','never')
        data = json.loads(out.read_text())
        self.assertEqual([p['page'] for p in data['pages']],[1,2])
        self.assertIn('1234 firm-year',data['pages'][0]['text'])
        self.assertEqual(data['pages'][1]['extraction_method'],'blank')
        self.assertEqual(data['source_sha256'],hashlib.sha256(pdf.read_bytes()).hexdigest())
        self.assertEqual((out.parent/data['pdf_path']).resolve(),pdf)
        self.assertFalse(data['truncated'])

    def test_full_pdf_includes_final_data_page(self):
        pdf = self.pdf();out = self.root/'full.json'
        with fitz.open(pdf) as doc:
            page = doc.new_page()
            page.insert_text((40,40),'Final data page: 5678 firm-years.')
            doc.save(pdf,incremental=True,encryption=fitz.PDF_ENCRYPT_KEEP)
        self.cli(pdf,'-o',out,'--format','text','--ocr','never')
        data = json.loads(out.read_text())
        self.assertFalse(data['truncated'])
        self.assertEqual((data['processed_pages'],data['total_pdf_pages']),(2,2))
        self.assertIn('5678 firm-years',data['pages'][-1]['text'])

    def test_overwrite_is_enabled_by_default(self):
        pdf = self.pdf();out = self.root/'out.json';out.write_text('old result')
        result = self.cli(pdf,'-o',out,'--format','text','--ocr','never')
        self.assertEqual(json.loads(result.stdout.splitlines()[0])['status'],'converted')
        self.assertEqual(json.loads(out.read_text())['source_sha256'],hashlib.sha256(pdf.read_bytes()).hexdigest())

    def test_no_overwrite_skips_existing_and_explicit_overwrite_replaces(self):
        pdf = self.pdf();out = self.root/'out.json';out.write_bytes(b'Original cached JSON\n')
        before = out.read_bytes()
        args = [pdf,'-o',out,'--format','text','--ocr','never']
        result = self.cli(*args,'--no-overwrite')
        self.assertEqual(json.loads(result.stdout.splitlines()[0])['status'],'skipped')
        self.assertEqual(out.read_bytes(),before)
        self.cli(*args,'--overwrite')
        self.assertEqual(json.loads(out.read_text())['paper_id'],'paper')

    def test_failed_conversion_preserves_existing_output(self):
        pdf = self.root/'bad.pdf';pdf.write_text('not a PDF')
        out = self.root/'out.json';out.write_bytes(b'Existing result\n')
        self.cli(pdf,'-o',out,'--format','text','--ocr','never',code=1)
        self.assertEqual(out.read_bytes(),b'Existing result\n')

    def test_parallel_directory_ignores_subdirectories(self):
        self.pdf('input/first.pdf');self.pdf('input/second.PDF');self.pdf('input/nested/ignored.pdf')
        self.cli(self.root/'input','-o',self.root/'out','-j',2,'--format','text','--ocr','never')
        self.assertEqual(sorted(p.name for p in (self.root/'out').iterdir()),['first.json','second.json'])

    def test_corrupt_pdf_does_not_stop_directory_batch(self):
        self.pdf('input/good.pdf');(self.root/'input/bad.pdf').write_text('not a PDF')
        result = self.cli(self.root/'input','-o',self.root/'out','--format','text','--ocr','never',code=1)
        rows = [json.loads(x) for x in result.stdout.splitlines()[:-1]]
        self.assertEqual(sorted(x['status'] for x in rows),['converted','error'])
        self.assertTrue((self.root/'out/good.json').exists())

    def test_duplicate_target_paths_fail_before_conversion(self):
        self.pdf('input/paper.pdf');self.pdf('input/paper.PDF')
        self.cli(self.root/'input','-o',self.root/'out','--ocr','never',code=2)
        self.assertFalse((self.root/'out').exists())

    def test_help_documents_defaults_and_omits_removed_options(self):
        help_text = self.cli('--help').stdout
        self.assertIn('default: 400',help_text)
        self.assertIn('default: true',help_text)
        for option in ('--recursive','--reuse-json','--require-reuse','--doi','--title','--paper-id','--report','--max-pages'):
            self.assertNotIn(option,help_text)


if __name__ == '__main__':
    unittest.main()
