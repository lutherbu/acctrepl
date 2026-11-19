"""Checkout-relative publications and local working directories."""
from functools import lru_cache
import hashlib
import importlib.util
import json
import os
import shutil
from pathlib import Path
import tempfile

PROJECT = Path(__file__).resolve().parent
PATHS = {
    'sample': 'output/samples', 'model': 'output/models', 'reproduction': 'output/reproductions',
    'execution': 'output/executions', 'feasibility_execution': 'output/feasibility_execution',
    'feasibility_reproduction': 'output/feasibility_reproduction',
    'model_records': 'output/models/records', 'model_index': 'output/models/index.json',
    'feasibility_records': 'output/feasibility_reproduction/records',
    'feasibility_index': 'output/feasibility_reproduction/index.json',
    'catalog': 'output/feasibility_reproduction/resources/catalog.json',
    'reproductions': 'output/reproductions/packages', 'ado': 'output/reproductions/resources/ado',
    'replications': 'output/replications/packages', 'papers_csv': 'docs/papers.csv',
    'papers_jsonl': 'docs/papers.jsonl', 'requirements': 'docs/requirements.txt',
    'classification_schema': 'skills/check-replication-feasibility/references/feasibility_classification.schema.json',
    'model_queue': '.local/reports/models/review_queue.json', 'model_manifest': '.local/models/input_manifest.jsonl',
    'reproduction_summary': '.local/reports/reproductions', 'feasibility_summary': '.local/reports/feasibility_reproduction',
    'classification': '.local/reports/classification',
}
ALIASES = {'execution_feasibility':'feasibility_execution','author_analysis_execution':'execution'}
EXPORT_NAMES = {'samples':'samples','sample':'samples','sample-author':'samples','sample-filtered':'samples',
                'shortlist':'samples','models':'models','model':'models','feasibility':'feasibility_reproduction',
                'feasibility_reproduction':'feasibility_reproduction','execution':'executions','feasibility_execution':'feasibility_execution'}


def runtime_executable(language, *, required=True):
    default = {'stata': 'stata', 'r': 'Rscript', 'matlab': 'matlab'}[language]
    variable = 'ACCTREPL_' + language.upper()
    name = os.environ.get(variable, default)
    location = shutil.which(name)
    if location:
        return str(Path(location).absolute())
    if required or variable in os.environ:
        raise ValueError(f'Supply {name} on PATH or configure {variable}')
    return None


def resolve_path(value, root=None):
    return (Path(root or PROJECT) / value).resolve()


def artifact_path(locator, root=None):
    project = Path(root or PROJECT).resolve()
    path = resolve_path(locator, project)
    if not path.is_relative_to(project):
        raise ValueError(f'Artifact is outside the project: {locator}')
    return path


def active_path(key, root=None):
    from scripts.rebuild_exports import EXPORTS, export_directory
    project = Path(root or PROJECT).resolve()
    key = ALIASES.get(key, key)
    if key in PATHS:
        return project / PATHS[key]
    return export_directory(project) / EXPORTS[EXPORT_NAMES[key]]


def work_root(stage, root=None):
    return artifact_path(Path('.local/runs') / stage, root)


def batch_reports(stage, root=None):
    return artifact_path(Path('.local/reports') / stage, root)


def stage_path(stage, name, root=None):
    return work_root(stage, root) / name


def manages_run(stage, run, root=None):
    return resolve_path(run, root).is_relative_to(work_root(stage, root))


def manifest(root=None):
    from scripts.rebuild_indexes import scan
    project = Path(root or PROJECT)
    if not (project / 'output').is_dir():
        return {}
    p = project / 'output/manifest.json'
    return json.loads(p.read_bytes()) if p.is_file() else {'workflows': {}}


def separate_exports(root=None):
    return (Path(root or PROJECT) / 'output/samples/records').is_dir()


def ensure_export(name, root=None):
    from scripts import rebuild_exports as exports
    project = Path(root or PROJECT).resolve()
    key = EXPORT_NAMES.get(name, name)
    directory = exports.export_directory(project)
    return exports.rebuild(project, [key], directory)[key]


def verify_package_export(folder, name, expected, root=None):
    from scripts.rebuild_exports import EXPORTS
    folder = Path(folder).resolve()
    key = EXPORT_NAMES.get(name, name)
    local = folder / Path(EXPORTS[key]).name
    if local.is_file():
        file = local
    else:
        file = ensure_export(key, root)
    if sha(file) != expected:
        raise ValueError(f'Aggregate checksum mismatch: {file}')


def sha(path):
    with Path(path).open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()


def write_record_export(path, records):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=path.parent) as temporary:
        draft = Path(temporary) / path.name
        with draft.open('w', encoding='utf-8') as out:
            for record in records:
                print(json.dumps(record, ensure_ascii=False, allow_nan=False), file=out)
        os.replace(draft, path)


def path_class(root=None):
    return Path


def relocate_module(module, root=None):
    return module


def writable_path(value, root=None):
    return artifact_path(value, root)


def executed_cell_source(attempt, cell_id, current_code, root=None):
    return current_code


@lru_cache(maxsize=4)
def converter(root=None):
    path = Path(root or PROJECT) / 'skills/extract-accounting-models/scripts/convert_schema.py'
    spec = importlib.util.spec_from_file_location('layout_model_converter', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def legacy_model(record, root=None):
    return converter(root).to_v2(record) if record.get('schema_version') == '3.0' else record


def publish_feasibility(documents, info, summary, run, root=None):
    """Promote the verified papers from a local run without replacing other papers."""
    from scripts import rebuild_indexes, publication
    project = Path(root or PROJECT).resolve()
    destination = active_path('feasibility_records', project)
    destination.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=destination.parent) as tmp:
        staged = []
        for doc in documents:
            pid = doc['paper_id']
            if not rebuild_indexes.ID.fullmatch(pid):
                raise ValueError(f'Invalid paper ID: {pid}')
            data = json.loads(json.dumps(doc))
            proof = data.get('provenance', {})
            if proof.get('temporal_audit_file') and proof.get('temporal_audit_sha256'):
                proof['temporal_audit_file'] = 'urn:sha256:' + proof['temporal_audit_sha256']
            draft = Path(tmp) / (pid + '.json')
            clean = publication.PublicPaths(pid).document(data)
            if clean != data:
                original = Path(run) / 'original_records' / (publication.byte_hash(publication.encode(data)) + '.json')
                original.parent.mkdir(parents=True, exist_ok=True)
                original.write_bytes(publication.encode(data))
            draft.write_bytes(rebuild_indexes.encoded(clean))
            target = destination / draft.name
            if target.is_file() and target.read_bytes() != draft.read_bytes():
                previous = Path(run) / 'previous_records' / draft.name
                previous.parent.mkdir(exist_ok=True, parents=True)
                if previous.exists() and previous.read_bytes() != target.read_bytes():
                    raise ValueError(f'Previous publication already exists: {previous}')
                previous.write_bytes(target.read_bytes())
            staged.append((draft,target))
        for draft, target in staged:
            os.replace(draft,target)
    rebuild_indexes.rebuild(project)
