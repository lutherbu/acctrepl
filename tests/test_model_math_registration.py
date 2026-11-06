"""Checked reading versions must remain stable while later reviews are registered."""
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location(
    'math_registry', Path(__file__).resolve().parents[1] / 'scripts/register_model_math.py')
registry = importlib.util.module_from_spec(spec)
spec.loader.exec_module(registry)


class MathRegistryTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.old = registry.ROOT, registry.RUNS
        registry.ROOT = self.root
        registry.RUNS = self.root / 'output/model_extraction_runs'
        registry.RUNS.mkdir(parents=True)
        reading = self.root / 'paper.json'
        reading.write_text(json.dumps({'pages': [{'page': 1, 'text': 'Original text.'}]}))
        pdf = self.root / 'paper.pdf'; pdf.write_bytes(b'PDF fixture')
        crop = self.root / 'crop.png'; crop.write_bytes(b'Image fixture')
        entry = {'paper_id': 'W1', 'reading_json': 'paper.json', 'pdf_path': 'paper.pdf',
                 'reading_json_sha256': registry.sha(reading), 'pdf_sha256': registry.sha(pdf)}
        (registry.RUNS / 'input_manifest.jsonl').write_text(json.dumps(entry) + '\n')
        self.source = self.root / 'review.json'

    def tearDown(self):
        registry.ROOT, registry.RUNS = self.old
        self.temp.cleanup()

    def register(self, text):
        self.source.write_text(json.dumps({'paper_id': 'W1', 'reviewer': 'Test reviewer',
            'blocks': [{'page': 1, 'label': 'Eq. 1', 'text': text, 'images': ['crop.png']}]}))
        return registry.register(self.source)

    def test_later_review_keeps_frozen_reading_and_transcription(self):
        first = self.register('Y = a + b X + e.')
        reading_path = self.root / first['path']; payload = reading_path.read_bytes()
        metadata = json.loads(payload)['model_math_review']
        archived = self.root / metadata['transcription_file']; archived_payload = archived.read_bytes()
        second = self.register('Y = a + b X + c Z + e.')
        self.assertNotEqual(first['path'], second['path'])
        self.assertEqual(payload, reading_path.read_bytes())
        self.assertEqual(archived_payload, archived.read_bytes())
        self.assertEqual(first['sha256'], registry.sha(reading_path))
        current = json.loads((registry.RUNS / 'verified_readings.json').read_text())
        self.assertEqual(second, current['W1'])

    def test_original_pages_and_files_preserved(self):
        original = (self.root / 'paper.json').read_bytes()
        result = self.register('Y = a + b X + e.')
        reading = json.loads((self.root / result['path']).read_text())
        self.assertEqual(original, (self.root / 'paper.json').read_bytes())
        self.assertEqual([1], [p['page'] for p in reading['pages']])
        self.assertTrue(reading['pages'][0]['text'].startswith('Original text.'))


if __name__ == '__main__':
    unittest.main()
