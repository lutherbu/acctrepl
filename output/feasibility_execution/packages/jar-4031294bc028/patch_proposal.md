# Patch proposal: jar-4031294bc028

What are You Saying? Using topic to Detect Financial Misreporting

DOI: 10.1111/1475-679X.12294

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Complete supplied 10-K topic workflow in z_log/main.sh: parsing, all four word-count dictionary branches, stopword generation, LDA, conversion, four-branch convergence comparisons, manual parameter sweeps and the final 10-Ks model. Paper-wide financial regressions and word-intrusion studies are not supplied as active entry stages.

Entry points: `_nested_Code_transfer/Code_transfer/z_log/main.sh`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 1/12294 - What-are-You-Saying-Using-topic-to-Detect-Financial-Misreporting/bce-datasheet-code-and-identifiers.zip",
      "sha256": "16b4be2781c46364ff8e0651a56638bba50ea8c8674eb8580c39ce22c4cd45c0"
    },
    {
      "path": "JAR-Volume 58/Issue 1/12294 - What-are-You-Saying-Using-topic-to-Detect-Financial-Misreporting/bce-online-appendix.pdf",
      "sha256": "d8666ff00344a9c39cec17fde7508f1aeb59f67e7fc69669c75be87d229e311b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "bd6e2d05a6a1d2b704a93378df851293cf19a2310c3ccc9debb403d1c52f00a9"
}
```

## Proposed actions

### A0001: Use the official SEC EDGAR archive or a verified local raw corpus to provide the complete author-compatible 10-K input under the parser actual PROC_PATH tree.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R0001, I0001
Evidence: E0001, E0003, E0035, E0036, E0038, E0039, E0026

Preparation / proposed procedure:

1. Use EDGAR filing indexes to identify 10-K filings in the author period 1994–2012 and retrieve complete raw filing text within the SEC declared-user-agent and 10 requests/second fair-access rules.
2. Verify annual coverage and document how SEC filenames map to the accession-like Filing key expected downstream; the sampled LM file is not confirmed as a compatible substitute.
3. Stage raw files under <PROC_PATH>/Documents_Raw/10-K/<year>/ following Parse.pyx; do not follow the stale main.sh comment additional Data_Files subpath.

Validation to perform later:

- Verify exact period coverage, raw SEC text/container format and representative edge-year files.
- Confirm parser output Filing values align with the LDA and restatement joins.

### A0002: Supply the author-used style-characteristics table or its complete producer and inputs; clarify its role in the active comparisons.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R0002, I0002
Evidence: E0004, E0005, E0031, E0039, E0040

Preparation / proposed procedure:

1. Request 10-K_style_characteristics.csv with its original schema and Filing key, or the complete author source and inputs that generate it.
2. Keep Topic_Model_Compare2 in the target until the required table or compatible producer is supplied.

Validation to perform later:

- Check Filing compatibility with LDA and restatement inputs.
- After separately authorized execution, confirm the year-by-year pseudo-R2 output.

### A0003: Supply compatible Unix wordlists for the three active dictionary branches and confirm their line and case semantics.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R0003, R0004, R0005, I0003
Evidence: E0011, E0039, E0042

Preparation / proposed procedure:

1. Provide compatible wordlists named american-english, american-english-huge and american-english-insane; exact author bytes/source/version are not required if the code contract is met.
2. Stage each under Code_transfer/Libraries/Dictionaries with the basename used by Word_Counts.pyx.

Validation to perform later:

- Check each file has one uppercase token per newline-terminated row, matching the code comparison of token plus newline.
- Preserve the intended standard, huge and largest vocabulary branches as distinct inputs.

### A0004: Make every tuning loop consume the same 10-Ks branch that its preceding stopword step generated.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I0004
Evidence: E0006, E0007, E0021, E0022, E0043, E0044

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:158–158`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA.py 6 10-K 5 $arg-0-500-100 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA.py 6 10-Ks 5 $arg-0-500-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:159–159`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA_Convert.py 6 10-K 5 $arg-0-500-100 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA_Convert.py 6 10-Ks 5 $arg-0-500-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:160–160`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python Topic_Model_Compare2.py 10-K 5 $arg-0-500-100 20 1994 2012 1000
```

Proposed replacement:
```
  python Topic_Model_Compare2.py 10-Ks 5 $arg-0-500-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:168–168`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA.py 6 10-K 5 $arg-0-500-100 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA.py 6 10-Ks 5 $arg-0-500-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:169–169`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA_Convert.py 6 10-K 5 $arg-0-500-100 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA_Convert.py 6 10-Ks 5 $arg-0-500-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:170–170`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python Topic_Model_Compare2.py 10-K 5 $arg-0-500-100 20 1994 2012 1000
```

Proposed replacement:
```
  python Topic_Model_Compare2.py 10-Ks 5 $arg-0-500-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:180–180`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA.py 6 10-K 5 60-0-$arg-100 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA.py 6 10-Ks 5 60-0-$arg-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:181–181`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA_Convert.py 6 10-K 5 60-0-$arg-100 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA_Convert.py 6 10-Ks 5 60-0-$arg-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:182–182`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python Topic_Model_Compare2.py 10-K 5 60-0-$arg-100 20 1994 2012 1000
```

Proposed replacement:
```
  python Topic_Model_Compare2.py 10-Ks 5 60-0-$arg-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:190–190`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA.py 6 10-K 5 60-0-$arg-100 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA.py 6 10-Ks 5 60-0-$arg-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:191–191`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA_Convert.py 6 10-K 5 60-0-$arg-100 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA_Convert.py 6 10-Ks 5 60-0-$arg-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:192–192`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python Topic_Model_Compare2.py 10-K 5 60-0-$arg-100 20 1994 2012 1000
```

Proposed replacement:
```
  python Topic_Model_Compare2.py 10-Ks 5 60-0-$arg-100 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:202–202`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA.py 6 10-K 5 60-0-1100-$arg 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA.py 6 10-Ks 5 60-0-1100-$arg 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:203–203`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA_Convert.py 6 10-K 5 60-0-1100-$arg 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA_Convert.py 6 10-Ks 5 60-0-1100-$arg 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:204–204`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python Topic_Model_Compare2.py 10-K 5 60-0-1100-$arg 20 1994 2012 1000
```

Proposed replacement:
```
  python Topic_Model_Compare2.py 10-Ks 5 60-0-1100-$arg 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:212–212`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA.py 6 10-K 5 60-0-1100-$arg 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA.py 6 10-Ks 5 60-0-1100-$arg 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:213–213`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA_Convert.py 6 10-K 5 60-0-1100-$arg 20 1994 2012 1000
```

Proposed replacement:
```
  python LDA_Convert.py 6 10-Ks 5 60-0-1100-$arg 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:214–214`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python Topic_Model_Compare2.py 10-K 5 60-0-1100-$arg 20 1994 2012 1000
```

Proposed replacement:
```
  python Topic_Model_Compare2.py 10-Ks 5 60-0-1100-$arg 20 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:224–224`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA.py 6 10-K 5 60-0-1100-100 $arg 1994 2012 1000
```

Proposed replacement:
```
  python LDA.py 6 10-Ks 5 60-0-1100-100 $arg 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:225–225`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA_Convert.py 6 10-K 5 60-0-1100-100 $arg 1994 2012 1000
```

Proposed replacement:
```
  python LDA_Convert.py 6 10-Ks 5 60-0-1100-100 $arg 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:226–226`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python Topic_Model_Compare2.py 10-K 5 60-0-1100-100 $arg 1994 2012 1000
```

Proposed replacement:
```
  python Topic_Model_Compare2.py 10-Ks 5 60-0-1100-100 $arg 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:233–233`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA.py 6 10-K 5 60-0-1100-100 $arg 1994 2012 1000
```

Proposed replacement:
```
  python LDA.py 6 10-Ks 5 60-0-1100-100 $arg 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:234–234`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python LDA_Convert.py 6 10-K 5 60-0-1100-100 $arg 1994 2012 1000
```

Proposed replacement:
```
  python LDA_Convert.py 6 10-Ks 5 60-0-1100-100 $arg 1994 2012 1000
```

**Proposed edit:** `_nested_Code_transfer/Code_transfer/z_log/main.sh:235–235`
Source SHA-256: `6779d06e045fec271b43c6acbd156f0a9388db6de45a169dca4f0687e7b19a7f`

The preceding Stopword_Generator_Run call writes the 10-Ks branch; the consumer must use that same branch path.

Current text:
```
  python Topic_Model_Compare2.py 10-K 5 60-0-1100-100 $arg 1994 2012 1000
```

Proposed replacement:
```
  python Topic_Model_Compare2.py 10-Ks 5 60-0-1100-100 $arg 1994 2012 1000
```

Preparation / proposed procedure:

1. Change the filetype argument from 10-K to 10-Ks in all LDA.py, LDA_Convert.py and Topic_Model_Compare2.py calls in the eight manual tuning loops; leave the initial four dictionary branches and final 10-Ks commands intact.

Validation to perform later:

- Review every tuning triplet’s generated stopword path, LDA input, converted CSV name and comparison read path for matching filetype and parameters.
- After a separately authorized run, confirm four-branch comparisons and all manual search rounds remain included.

### A0005: Use the current batch index in LDA.py when assembling worker input paths.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I0005
Evidence: E0008

**Proposed edit:** `_nested_Code_transfer/Code_transfer/Code_pre/LDA.py:221–221`
Source SHA-256: `14a1acf8a337af0e37506101b7ccc89e7f20be6657f058e3d85be60134c6bf80`

The surrounding loop enumerates i; using fed repeats one path and omits other files in the batch.

Current text:
```
                    textfiles.append(files[fed][0] + '/' + files[fed][1])
```

Proposed replacement:
```
                    textfiles.append(files[i][0] + '/' + files[i][1])
```

Validation to perform later:

- Confirm every generated batch path corresponds to its own index i.
- After a separately authorized run, compare processed-file counts and resulting LDA rows with the intended sample.

### A0006: Create both comparison output folders before initial branch comparisons and parameter sweeps.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I0006
Evidence: E0023, E0024, E0040

Preparation / proposed procedure:

1. With Code_transfer as project root, create Stats/Topic_Test/5 and Test/Stats/Topic_Test/5.
2. Launch main.sh from Code_transfer/z_log so cd ../Code_pre resolves correctly.

Validation to perform later:

- Confirm the process can write comparison CSVs in both roots.
- Check output basenames retain branch, yearstep, stopword and topic parameters.

### A0007: Resolve the simulation sampling-unit difference between Appendix A.2 and active test mode before selecting parameter values.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I0007
Evidence: E0006, E0013, E0039

Preparation / proposed procedure:

1. Confirm whether each simulation selects 1,000 filings per calendar year or 1,000 filings across each multi-year rolling window.
2. Obtain the author-approved sampling rule/implementation, retaining the five-year training window and test-year treatment.

Validation to perform later:

- Confirm sample counts per calendar year and window before comparing pseudo-R2 values.
- Record manual selections and final 10-Ks settings without changing the estimator or search design.

### A0008: Prepare the legacy Python/Cython environment declared in author documentation before any separately authorized run.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S0001, S0002
Evidence: E0012, E0014, E0016, E0017, E0032, E0033, E0037, E0042

Preparation / proposed procedure:

1. Provision an isolated Python 2.7 environment with requirements.txt pins, including Cython 0.29.14 and the active NumPy, SciPy, Pandas and Statsmodels stack.
2. Confirm availability of the compiler and build tooling required by the three supplied Cython extensions; toolchain availability is currently unverified.
3. Do not treat Python 3.12 as author-version compatibility.

Validation to perform later:

- Verify Python 2.7, pinned packages, Cython and compiler/build tooling in the isolated environment.
- Before separately authorized execution, confirm the extension build setup resolves; no builds were performed for this assessment.

### A0009: Set one coherent host project root and current directory for the existing relative paths.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I0008
Evidence: E0027, E0028, E0029, E0039

Preparation / proposed procedure:

1. Place Code_transfer under a writable host [redacted-path-501b907a886a] project path and set PROJECT_PATH to that Code_transfer root with a trailing slash; keep PROC_ON_SCRATCH=False so PROC_PATH resolves to its Proc subdirectory.
2. Start bash from Code_transfer/z_log; let main.sh change to Code_pre. Do not put a Dropbox workspace absolute path in executable settings.

Validation to perform later:

- Confirm raw files, parsed files, Intermediary outputs and Data_Files resolve under the same PROC_PATH.
- Confirm Topic_Model_Compare2 output paths resolve under the Code_transfer root.


## Remaining issues and prerequisites

- I0001 [unresolved; full_pipeline]: The package does not supply raw 10-K filings. Public SEC and local candidate routes exist, but complete author-compatible 1994–2012 coverage, source layout and filename mapping are not established. Parse.pyx reads PROC_PATH/Documents_Raw/10-K/<year>; the main.sh comment names a different Data_Files subpath.
- I0002 [unresolved; full_pipeline]: Every active comparison/tuning branch reads 10-K_style_characteristics.csv by Filing, but no such table or Style_Parser source is packaged and its main.sh calls are commented out. Parse.pyx writes a differently named parse-characteristics table.
- I0003 [unresolved; full_pipeline]: Active word-count branches require the three named Unix dictionaries, but none is included. Word_Counts.pyx compares each uppercase token plus newline against dictionary lines, so compatible newline-delimited uppercase wordlists can satisfy the contract; the exact author source/version is unresolved.
- I0004 [blocking; full_pipeline]: The tuning loops generate stopword files under 10-Ks and call LDA.py, LDA_Convert.py and Topic_Model_Compare2.py with 10-K. These consumers build paths from the passed filetype, so they do not read the immediately generated files. Final selected commands consistently use 10-Ks.
- I0005 [blocking; full_pipeline]: LDA.py iterates each batch index i but appends files[fed] for every item. Each batch repeats its first filing and omits the other file paths in that batch, preventing faithful topic estimation unless the index is corrected.
- I0006 [preparation; full_pipeline]: Topic_Model_Compare2 writes results beneath Stats/Topic_Test/5 for initial comparisons and Test/Stats/Topic_Test/5 for parameter sweeps. Neither folder is packaged, and the script does not create them.
- I0007 [unresolved; full_pipeline]: Appendix A.2 says the simulations select 1,000 filings per year, while each tuning pass passes test=1000 to Stopword_Generator.pyx after it has assembled and shuffled a multi-year window list; the code truncates that per-window list to 1,000. The intended sampling unit is unresolved and must not be guessed.
- I0008 [preparation; full_pipeline]: Settings retains placeholder PROJECT_PATH and README directs users to configure it. A coherent host root and current directory are required because main.sh uses cd ../Code_pre while data paths derive from PROC_PATH.
- R0001 [undetermined]: Author-compatible raw SEC EDGAR 10-K filing text for years 1994–2012, arranged for the supplied parser and rolling five-year windows. The active main workflow parses 10-Ks; it does not read 10-K/A files.
- R0002 [undetermined]: 10-K_style_characteristics.csv keyed by Filing, consumed by active Topic_Model_Compare2 comparisons and parameter sweeps.
- R0003 [undetermined]: Unix standard English dictionary american-english, required for main.sh Word_Counts dictionary selector 1.
- R0004 [undetermined]: Unix large English dictionary american-english-huge, required for main.sh Word_Counts dictionary selector 2.
- R0005 [undetermined]: Unix largest English dictionary american-english-insane, required for main.sh Word_Counts dictionary selector 3.
- S0001 [preparation_required]: README specifies Python 2.7; active sources use Python-2-era APIs, while the available command is Python 3.12.14 and python2.7 is absent. requirements.txt pins older NumPy, SciPy, Pandas and Statsmodels versions; prepare the author-documented environment before any run.
- S0002 [preparation_required]: The active workflow uses three supplied .pyx extensions; the required Cython package/command is absent from the checked environment, and compiler/build tooling availability has not been validated.

## Review notes

- The target is the supplied topic-generation and manual-tuning workflow, including its active Topic_Model_Compare2 companion. The package 10-K_Info_fix.csv and outer GVKEY/restatement files are not read by this active closure. The in-package restate_data_2.csv is read and is a distinct compatible input. Paper-wide regressions, MTurk analysis and word-intrusion workflows are not supplied as active entry stages; AAER/Compustat/AuditAnalytics source data and GloVe resources are not mandatory for this selected code path.
- No analysis-only scope is supported: no prepared LDA matrices/topics are packaged and the supplied target includes document preparation and every active dictionary/tuning branch. No author code was imported, compiled or run; no regressions, downloads or installations were attempted.
- The README and main.sh mention NLTK Brown and Punkt, but the traced active closure contains no NLTK import or corpus lookup. Those notes are retained as documentation, not promoted to empirical inputs or additional mandatory resources.
- History note for scope review: before the coordinator clarified the approved external-root boundary, runtime_resources.json recorded read-only software/dependency metadata plus fixed-path existence checks at ${NLTK_DATA}, [redacted-path-0c542fce605d], [redacted-path-fa0f39aa81eb], [redacted-path-41ac1bbfed14], [redacted-path-e92224c33732], [redacted-path-a64e86df1d46], [redacted-path-5a28176b2dda], [redacted-path-690145e1c8f3] and [redacted-path-c4695cbe8c50]. dictionary_candidate.json also records a streaming hash/line count and first/last five-line sample for [redacted-path-41ac1bbfed14]. Those system-path results are retained in assigned probes but excluded from route assessment; no further reads were made.
- Construction error preserved: an expanded-draft attempt raised KeyError for _nested_Code_transfer/Code_transfer/Code_pre/Word_Counts.pyx because this inventory-kind-other file has no sources[].content_path. Its role is supported by the hashed static inspection artifact; the frozen work_item was not modified.
