"""Selected-page equation crops preserve source identity and physical pages."""
import hashlib
import importlib.util
from pathlib import Path
import tempfile
import unittest

import fitz

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('equation_rendering', ROOT / 'skills/extract-accounting-models/scripts/render_equations.py')
renderer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(renderer)


class EquationRenderingTests(unittest.TestCase):
    def test_targeted_crop_preserves_source_and_physical_page(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / 'paper.pdf'
            picture = fitz.Pixmap(fitz.csRGB, fitz.IRect(0, 0, 400, 20), False)
            picture.clear_with(128)
            doc = fitz.open()
            doc.new_page()
            page = doc.new_page()
            page.insert_image(fitz.Rect(50, 100, 450, 120), stream=picture.tobytes('png'))
            doc.save(source); doc.close()
            before = hashlib.sha256(source.read_bytes()).hexdigest()
            result = renderer.render(source, [2, 2], root / 'crops')
            self.assertEqual([2], [p['page'] for p in result['pages']])
            candidates = result['pages'][0]['candidates']
            self.assertEqual(1, len(candidates))
            self.assertTrue((root / 'crops' / candidates[0]['image_file']).is_file())
            self.assertEqual(before, hashlib.sha256(source.read_bytes()).hexdigest())
            self.assertEqual(before, result['pdf_sha256'])

    def test_invalid_page_is_rejected_without_creating_output(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            doc = fitz.open(); doc.new_page(); doc.save(root / 'paper.pdf'); doc.close()
            with self.assertRaises(ValueError):
                renderer.render(root / 'paper.pdf', [0], root / 'crops')
            self.assertFalse((root / 'crops').exists())

    def test_vector_only_page_does_not_invent_equation_images(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            doc = fitz.open(); page = doc.new_page(); page.insert_text((50, 50), 'Y = a + b X')
            doc.save(root / 'paper.pdf'); doc.close()
            result = renderer.render(root / 'paper.pdf', [1], root / 'crops')
            self.assertEqual([], result['pages'][0]['candidates'])


if __name__ == '__main__':
    unittest.main()
