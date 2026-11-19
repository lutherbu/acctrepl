"""Safe, bounded author-package preparation. Never executes package code."""
from __future__ import annotations
import csv
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import shutil
import stat
import subprocess
import sys
import zipfile
import xml.etree.ElementTree as ET

CODE = {'.sas','.do','.ado','.r','.rmd','.qmd','.py','.ipynb','.m','.jl','.sh','.sps','.sql','.bat'}
DOC = {'.md','.txt','.pdf','.docx','.tex','.log','.lst','.smcl'}
DATA = {'.dta','.sas7bdat','.csv','.tsv','.xlsx','.xls','.parquet','.rds','.rdata','.mat','.pkl','.dat'}


def sha(path):
    h=hashlib.sha256()
    with Path(path).open('rb') as f:
        for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
    return h.hexdigest()


def save(path,obj):
    path=Path(path);path.parent.mkdir(parents=True,exist_ok=True)
    temp=path.with_suffix(path.suffix+'.tmp')
    temp.write_text(json.dumps(obj,indent=2,ensure_ascii=False)+'\n');temp.replace(path)


def safe(root,relative):
    relative=str(relative).replace('\\','/');p=PurePosixPath(relative)
    if p.is_absolute() or '..' in p.parts or re.match(r'^[A-Za-z]:',relative):raise ValueError('Escaping package path')
    dest=Path(root)
    for part in p.parts:
        dest=dest/part
        if dest.is_symlink():raise ValueError('Symlink package path')
    return dest


def extract(archive,dest,state=None,depth=0):
    state=state or {'bytes':0,'members':0,'issues':[],'members_index':[]}
    if depth>3:raise ValueError('Nested ZIP depth exceeds three')
    dest=Path(dest);dest.mkdir(parents=True,exist_ok=True)
    with zipfile.ZipFile(archive) as z:
        for i in z.infolist():
            n=i.filename.replace('\\','/')
            if '__MACOSX' in PurePosixPath(n).parts or Path(n).name=='.DS_Store':continue
            if i.is_dir() and n.strip('/') in {'','.'}:
                state['issues'].append('Ignored ZIP root directory marker');continue
            p=safe(dest,n);mode=i.external_attr>>16
            if stat.S_IFMT(mode) not in {0,stat.S_IFREG,stat.S_IFDIR} or i.flag_bits&1:raise ValueError('Link, special or encrypted member')
            if i.is_dir():p.mkdir(parents=True,exist_ok=True);continue
            state['members']+=1
            if state['members']>100000 or state['bytes']+i.file_size>10*1024**3:raise ValueError('ZIP extraction resource limit')
            if p.exists():raise ValueError('ZIP overwrite collision: '+n)
            p.parent.mkdir(parents=True,exist_ok=True)
            with z.open(i) as src,p.open('xb') as out:
                for block in iter(lambda:src.read(1024*1024),b''):
                    state['bytes']+=len(block)
                    if state['bytes']>10*1024**3:raise ValueError('Actual extraction byte limit')
                    out.write(block)
            state['members_index'].append({'archive':str(archive),'member':i.filename,'crc32':i.CRC,'bytes':i.file_size,'depth':depth})
    for p in sorted(dest.rglob('*')):
        if p.suffix.lower()=='.zip' and not any(x.startswith('_nested_') for x in p.relative_to(dest).parts):
            child=p.parent/('_nested_'+p.stem)
            if child.exists():raise ValueError('Nested extraction collision')
            try:extract(p,child,state,depth+1)
            except (ValueError,zipfile.BadZipFile,NotImplementedError) as exc:state['issues'].append(str(exc))
        elif p.suffix.lower() in {'.rar','.7z','.gz','.tar'}:state['issues'].append('Unsupported nested archive: '+str(p.relative_to(dest)))
    return state


def _docx_paragraph_text(paragraph):
    """Join formatting runs without inventing breaks inside words or paths."""
    word = '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'

    def inline(node):
        if node.tag.endswith('}t'):
            return node.text or ''
        if node.tag == word + 'tab':
            return '\t'
        if node.tag in {word + 'br', word + 'cr'}:
            return '\n'
        # Nested text-box paragraphs are visited separately by the outer walk.
        return ''.join(inline(child) for child in node if child.tag != word + 'p')

    return inline(paragraph)


def text(path):
    path=Path(path);ext=path.suffix.lower();locations={};warnings=[]
    if path.stat().st_size>32*1024**2:return '',{},['Source exceeds text extraction limit']
    if ext=='.xlsx':
        from spreadsheet_program import spreadsheet_text
        return spreadsheet_text(path)
    if ext=='.spwb':
        from spss_workbook import read_spwb
        content,locations,warnings,_=read_spwb(path)
        return content,locations,warnings
    try:
        word_container=False
        if ext=='.docx' or zipfile.is_zipfile(path):
            with zipfile.ZipFile(path) as z:
                if ext=='.docx' or 'word/document.xml' in z.namelist():
                    info=z.getinfo('word/document.xml')
                    if info.file_size>32*1024**2:return '',{},['Oversized DOCX XML']
                    tree=ET.fromstring(z.read(info))
                    paragraphs=tree.iter('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}p')
                    raw='\n'.join(_docx_paragraph_text(p) for p in paragraphs)
                    word_container=True
                    if ext!='.docx':
                        warnings.append('Word OOXML container detected despite '+ext+' suffix; extracted text is not a native source file')
        if word_container:
            pass
        elif ext=='.pdf':
            exe=shutil.which('pdftotext')
            if not exe:return '',{},['pdftotext unavailable']
            proc=subprocess.run([exe,'-layout',str(path),'-'],capture_output=True,text=True,timeout=20)
            if proc.returncode:return '',{},['PDF has no readable text']
            raw=proc.stdout
        elif ext=='.ipynb':
            nb=json.loads(path.read_text());kernel=nb.get('metadata',{}).get('kernelspec',{})
            lines=[]
            for index,c in enumerate(nb.get('cells',[])):
                src=c.get('source','');src=''.join(src) if isinstance(src,list) else src
                for lineno,line in enumerate(src.splitlines(),1):
                    locations[str(len(lines)+1)]={'cell_index':index,'cell_id':c.get('id'),'cell_line':lineno,'cell_type':c.get('cell_type')}
                    lines.append(line if c.get('cell_type')=='code' else '# '+line)
                lines.append('')
            raw='\n'.join(lines)
            if not kernel:warnings.append('Notebook kernel metadata is absent')
        else:
            data=path.read_bytes()
            try:raw=data.decode('utf-8-sig')
            except UnicodeDecodeError:raw=data.decode('cp1252',errors='replace');warnings.append('Decoded using cp1252 fallback')
        raw=raw.replace('\f','\n')
        if not raw.strip():warnings.append('Empty or unreadable text')
        return raw,locations,warnings
    except (OSError,ValueError,KeyError,ET.ParseError,zipfile.BadZipFile,subprocess.TimeoutExpired) as e:
        return '',{},[type(e).__name__+': text extraction failed']


def metadata(path,location):
    """Read at most one row. Does not establish population/history completeness."""
    path=Path(path);ext=path.suffix.lower();result={'location':location,'readable':False,'columns':[],'rows_read':0,'size_bytes':path.stat().st_size,'coverage_verified':False}
    if ext in {'.dta','.sas7bdat'}:
        import pyreadstat
        reader=pyreadstat.read_dta if ext=='.dta' else pyreadstat.read_sas7bdat
        data,meta=reader(str(path),row_limit=1,disable_datetime_conversion=True)
        result.update(readable=True,columns=list(data.columns),rows_read=len(data),column_labels=dict(zip(meta.column_names,meta.column_labels)))
        if ext=='.dta':
            _,header=reader(str(path),metadataonly=True,disable_datetime_conversion=True)
            result.update(catalog_observations=header.number_rows,observation_count_scope='file_metadata')
        else:
            # ReadStat's metadata-only SAS reader can traverse a large file.
            # The row-limited metadata count describes only the sample read.
            result.update(catalog_observations=None,observation_count_scope='unknown',
                          observation_count_limitation='Whole-file SAS count not inspected; the one-row sample count is not the file count.')
    elif ext in {'.csv','.tsv'}:
        with path.open(encoding='utf-8-sig',errors='replace') as f:
            sample=f.read(65536);f.seek(0)
            try: dialect=csv.Sniffer().sniff(sample,delimiters=',;\t|') if sample.strip() else csv.excel
            except csv.Error: dialect=csv.excel_tab if ext=='.tsv' else csv.excel
            rows=csv.reader(f,dialect);header=next(rows,[]);first=next(rows,None)
            result.update(readable=bool(header),columns=header,rows_read=int(first is not None))
    elif ext=='.parquet':
        import pyarrow.parquet as pq
        p=pq.ParquetFile(path);result.update(readable=True,columns=p.schema.names,catalog_observations=p.metadata.num_rows)
    elif ext=='.xlsx':
        import openpyxl
        b=openpyxl.load_workbook(path,read_only=True,data_only=False)
        try:
            sh=b.worksheets[0];rows=sh.iter_rows(values_only=True);header=next(rows,[]);first=next(rows,None)
            result.update(readable=True,columns=[str(x) for x in header],rows_read=int(first is not None),sheet_names=b.sheetnames,
                          header_semantics='Raw first-sheet cell values; not necessarily the variable names created by the author-prescribed import.',
                          excel_columns=[{'column':openpyxl.utils.get_column_letter(i),'header':str(x) if x is not None else None}
                                         for i,x in enumerate(header,1)])
        finally:b.close()
    else:result['limitation']='No bounded metadata reader for this format; file presence alone is not verified compatibility'
    return result


def bounded_metadata(root,relative,output):
    path=safe(root,relative)
    if not path.is_file():raise ValueError('Not a package file')
    command=[sys.executable,str(Path(__file__).resolve()),'_metadata_worker',str(path),relative]
    record={'status':'unverified','checked_at':__import__('datetime').datetime.now(__import__('datetime').timezone.utc).isoformat()}
    try:
        proc=subprocess.run(command,capture_output=True,text=True,timeout=15)
        if proc.returncode:raise ValueError(proc.stderr[-400:])
        result=json.loads(proc.stdout);record.update(status='ok' if result['readable'] else 'unverified',result=result)
    except (ValueError,OSError,subprocess.TimeoutExpired) as e:record['error']=str(e)[:600]
    save(output,record);return record


if __name__=='__main__' and sys.argv[1]=='_metadata_worker':
    print(json.dumps(metadata(sys.argv[2],sys.argv[3])))


def stata_software(name,output):
    """Run only a self-written version/which query, never a package entry point."""
    if not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*',name):raise ValueError('Invalid Stata command identifier')
    output=Path(output);output.parent.mkdir(parents=True,exist_ok=True)
    if output.exists():raise ValueError('Use a new software probe output path')
    script=output.with_suffix('.do');log=output.with_suffix('.log')
    if script.exists() or log.exists():raise ValueError('Software probe sibling files already exist')
    if '"' in str(log):raise ValueError('Unsupported quote in probe path')
    script.write_text(f'capture log close _all\nlog using "{log}", text replace\ndisplay "__EF_VERSION__ " c(version)\ncapture which {name}\nlocal found = _rc\ndisplay "__EF_RC__ `found\'"\nlog close\nexit, clear\n')
    record={'status':'unverified','checked_at':__import__('datetime').datetime.now(__import__('datetime').timezone.utc).isoformat()}
    try:
        binary=shutil.which('stata')
        if not binary:raise ValueError('Stata executable not found on PATH')
        proc=subprocess.run([binary,'-b','do',str(script)],cwd=output.parent,capture_output=True,text=True,timeout=30)
        raw=log.read_text(errors='replace') if log.exists() else proc.stdout+'\n'+proc.stderr
        found=re.search(r'^__EF_RC__\s+(\d+)',raw,re.M)
        version=re.search(r'^__EF_VERSION__\s+(\S+)',raw,re.M)
        if proc.returncode or not found or not version:raise ValueError('Runtime/which query did not complete; see probe log')
        record.update(status='ok',result={'location':'software:'+name,'available':int(found[1])==0,'which_returncode':int(found[1]),'runtime_version':version[1],'script_path':str(script),'script_sha256':sha(script),'log_path':str(log),'log_sha256':sha(log)})
    except (OSError,ValueError,subprocess.TimeoutExpired) as e:record['error']=str(e)
    save(output,record);return record
