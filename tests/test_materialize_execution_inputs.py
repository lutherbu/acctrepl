import hashlib
import io
import json
from pathlib import Path
import zipfile
import pytest

from scripts import materialize_execution_inputs as files


def recipe(root):
    pkg = root / 'output/executions/packages/jar-A'
    (pkg/'code').mkdir(parents=True)
    template=pkg/'code/analysis.do'
    template.write_bytes(b'cd "@@ACCTREPL_WORK@@"\n')
    buf=io.BytesIO()
    with zipfile.ZipFile(buf,'w') as inner:
        inner.writestr('raw/value.csv',b'x\n2\n')
    archive=root/'author.zip'
    with zipfile.ZipFile(archive,'w') as outer:
        outer.writestr('Data.zip',buf.getvalue())
    rows=[{'role':'data','path':'work/value.csv','members':['Data.zip','raw/value.csv'],'bytes':4,
           'sha256':hashlib.sha256(b'x\n2\n').hexdigest()},
          {'role':'code','path':'work/program.do','template':'code/analysis.do','template_sha256':files.sha(template)}]
    spec={'package_id':'jar-A','archive':{'path':'author.zip','sha256':files.sha(archive),'bytes':archive.stat().st_size},
          'files':rows,'empty_directories':['work/results']}
    (pkg/'local_inputs.json').write_text(json.dumps(spec))
    return pkg,spec


def test_nested_archive_and_relocation(tmp_path):
    root=tmp_path/'checkout with spaces'
    pkg,spec=recipe(root)
    assert files.prepare(root,'jar-A',verify_archive=True)==2
    assert (pkg/'work/value.csv').read_bytes()==b'x\n2\n'
    assert str(pkg/'work').encode() in (pkg/'work/program.do').read_bytes()
    assert files.prepare(root,'jar-A',check=True)==2
    (root/'author.zip').unlink()
    assert files.prepare(root,'jar-A')==2


def test_bad_digest_or_unsafe_work_target_is_rejected(tmp_path):
    pkg,spec=recipe(tmp_path)
    spec['files'][0]['sha256']='0'*64
    (pkg/'local_inputs.json').write_text(json.dumps(spec))
    with pytest.raises(ValueError,match='checksum'):files.prepare(tmp_path,'jar-A')
    assert not (pkg/'work/value.csv').exists()
    spec['files'][0]['path']='../wrong.csv'
    (pkg/'local_inputs.json').write_text(json.dumps(spec))
    with pytest.raises(ValueError,match='relative path'):files.prepare(tmp_path,'jar-A')
