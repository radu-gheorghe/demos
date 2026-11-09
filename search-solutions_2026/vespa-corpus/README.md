# Vespa corpus

Local index of the Vespa engine tree, the sample apps, and the English docs. Search the `passage` document type. `source_file` is one document per file. Each passage points at its file with the reference field `file`. `parents` and `links` are arrays of document ids. Reference arrays do not deploy on this Vespa: attribute setup drops the target type and activation fails with "Referenced document type is not set".

The checkouts are `git-checkouts/vespa`, `git-checkouts/sample-apps`, and `git-checkouts/documentation`, next to `vespa-corpus`. That directory is gitignored. Nothing in those trees is modified.

## Generate

From the repo root:

```bash
mkdir -p git-checkouts
git clone --depth 1 https://github.com/vespa-engine/vespa git-checkouts/vespa
git clone --depth 1 https://github.com/vespa-engine/sample-apps git-checkouts/sample-apps
git clone --depth 1 https://github.com/vespa-engine/documentation git-checkouts/documentation

python3 vespa-corpus/scripts/select_files.py --out vespa-corpus/out/files.jsonl
python3 vespa-corpus/scripts/chunk.py \
  --files vespa-corpus/out/files.jsonl \
  --sources vespa-corpus/out/source_file.jsonl \
  --passages vespa-corpus/out/passage.jsonl
```

`select_files.py` walks the three checkouts and writes `out/files.jsonl`. `chunk.py` reads that list and writes `out/source_file.jsonl` and `out/passage.jsonl`. Each line is already a feed operation (`"id"` is a put). `--limit N` on `select_files.py` cuts a smoke run. Files over 1 MB are skipped, and so are build trees, `graphify-out`, and `_site`.

Passages are capped around 1,600 characters because the model context is 512 tokens. Docs split on headings. Code splits on top-level braces (Python on top-level `class`/`def`, schemas on field and rank-profile blocks) and then windows long units. The signature is repeated on later windows.

## Deploy

```bash
vespa deploy vespa-corpus --wait 300
```

The container embedder is `BAAI/bge-small-en-v1.5` (384 dimensions, CLS pooling, `normalize=true`). Docker on macOS cannot pass Metal into the Linux VM, so the ONNX model runs on CPU. Index and query vectors share that embedder, which is what `prenormalized-angular` requires.

## Index

Feed the file documents first: each passage's `file` field is a reference to one. `--progress 3` prints a summary every 3 seconds. Passage feeding stays at two connections because the container embedder runs on CPU.

```bash
vespa feed --progress 3 vespa-corpus/out/source_file.jsonl
vespa feed --progress 3 vespa-corpus/out/passage.jsonl
```

## Query

Lexical, no query tensor (`rank-profile default`). Search each field with `text()`. That operator defaults to grammar `linguistics`, so the query runs through the field's Lucene profile and the tokens are already stemmed. `userQuery()` uses the platform stemmer instead: on this index `connections` became `connect` and `running` became `run`, while `text()` produced `connection` and `running`. `userInput()` on `code` does not run the word-delimiter profile: `wordDelimiterGraph` stayed one token (2 hits) and `text()` split it (617 hits). `userQuery()` also searches `prose` only.

```bash
vespa query \
  'yql=select path, heading, symbol, start_line from passage where prose contains text(@q) or code contains text(@q)' \
  'q=nearestNeighbor' 'ranking=default'
```

Hybrid. BM25 of `prose` and `code` is summed, then mapped with `2 * atan(x / 8) / pi`, then added to cosine. The embedding distance metric is `prenormalized-angular`, so cosine is `1 - distance(field, embedding)`.

```bash
vespa query \
  'yql=select path, heading, symbol, start_line from passage where ({targetHits:20}nearestNeighbor(embedding, q)) or prose contains text(@userq) or code contains text(@userq)' \
  'userq=how does HNSW visit documents' \
  'input.query(q)=embed(bge, "how does HNSW visit documents")' \
  'ranking=hybrid'
```

Do not add the BGE query prefix yourself. The embedder prepends `Represent this sentence for searching relevant passages: ` on queries only.

Filter with `repo`, `source_language`, `kind` (`doc`, `code`, `schema`, `config`), and `path`. `path contains "..."` is an exact attribute match. `path matches "searchlib/.*"` is a prefix. `dense` ranks by cosine alone and needs the same `embed(bge, ...)` input.

`prose` uses the Lucene `prose` profile (standard tokenizer, lowercase, ASCII folding, English minimal stem). `code` uses `code` (standard tokenizer, `wordDelimiterGraph` with case splits and the original token kept, lowercase, no stemmer). `symbol` is an exact attribute.
