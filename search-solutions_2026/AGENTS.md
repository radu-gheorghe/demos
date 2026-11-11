# Vespa corpus

The index is on Vespa Cloud, application `training1.searchsolutions.default`. Search `passage`. `source_file` is one document per file and has no text index.

The Vespa skills are installed (`vespa-cli`, `query-builder`, `schema-authoring`, and the others). Use them for CLI flags, YQL, and schema syntax. This file is the corpus: where the files are, how a passage is cut, and queries that work here.

## Reach the index

`vespa config get` must show `target = cloud` and `application = training1.searchsolutions.default`. If either value differs:

```bash
vespa config set target cloud
vespa config set application training1.searchsolutions.default
```

Leave the target on cloud. A localhost URL is a different index.

Connectivity check:

```bash
vespa query 'select * from sources * where true' hits=1
```

`vespa query -v` prints the curl command in front of the same response.

When that query fails because the CLI is not authenticated (the error tells you to run `vespa auth login`), log in with `--batch` and leave the command running. It prints two lines and then waits until the browser login finishes:

```text
code=ABCD-EFGH
url=https://login.console.vespa-cloud.com/activate?user_code=ABCD-EFGH
```

Tell the user to open that `url`. Wait until the command exits, then run the query again. Plain `vespa auth login` tries to open a browser itself; use `--batch` so the URL is visible and the command blocks until login completes.

## Where a hit's file is

The clones in this workspace are `git-checkouts/vespa`, `git-checkouts/sample-apps`, and `git-checkouts/documentation`. A hit's `path` is relative to that repo directory. Open `git-checkouts/{repo}/{path}` and start at `start_line`. For HTML, that line is only the heading. Stay inside this workspace.

Answer from the index first. Open the file when the passage is not enough.

## What is in each repo

| `repo` | What it is |
|---|---|
| `vespa` | Engine source. Mostly C++ and Java, tests included. This is where behavior is implemented. |
| `documentation` | English docs only (`en/`). Guides and reference pages. No schemas. |
| `sample-apps` | Worked application packages: schemas, `services.xml`, Java/Python, READMEs. |

`kind` is derived from the file, not from the repo. A README in `vespa` or `sample-apps` is `kind` `doc`.

| Question | Filter |
|---|---|
| What does a feature mean, how do I configure it? | `repo contains "documentation"` |
| Where is it implemented, what does the code do? | `repo contains "vespa"` and `kind contains "code"` |
| Show a working application package | `repo contains "sample-apps"` |

### Documentation (`path` under `en/`)

Guides are one file per topic. Reference material is under `en/reference/`.

| Path | Use it for |
|---|---|
| `en/basics/` | Short introductions: application, schema, deploy, query, ranking, feed |
| `en/querying/` | Query API, YQL guide, grouping, nearest neighbor, geo, summaries |
| `en/schemas/` | Documents, structs, parent/child, inheritance, predicate fields |
| `en/ranking/` | Ranking intro, BM25, nativeRank, tensors, ONNX, XGBoost, LightGBM, phased ranking |
| `en/writing/` | Document v1, indexing, partial updates, visiting, batch feed |
| `en/applications/` | Containers, searchers, document processors, bundles, components |
| `en/content/` | Proton, buckets, attributes, consistency |
| `en/operations/`, `en/performance/`, `en/security/` | Self-managed, Kubernetes, sizing, mTLS |
| `en/rag/`, `en/learn/` | RAG, tutorials, glossary, FAQ |
| `en/reference/schemas/schemas.html` | Schema reference. Old URL `schema-reference.html` redirects here. Headings are element names (`field`, `rank-profile`, `rank`). |
| `en/reference/querying/yql.html` | YQL reference |
| `en/reference/ranking/rank-features.html`, `ranking-expressions.html` | Rank features and ranking-expression reference |
| `en/reference/writing/indexing-language.html` | Indexing-language reference |
| `en/reference/schemas/document-json-format.html` | Document JSON and document id |
| `en/reference/applications/services/` | `services.xml`: `services.html`, `container.html`, `content.html`, `search.html`, `docproc.html` |
| `en/reference/api/` | HTTP APIs: `query.html`, `document-v1.html`, deploy, config, metrics |
| `en/reference/clients/vespa-cli/` | One page per CLI command |

### Engine modules worth naming

The `vespa` tree is flat, about 160 top-level directories.

| Path prefix | What lives there |
|---|---|
| `searchlib/` | Matching, attributes, index, rank features, ranking expressions (C++ and Java) |
| `searchcore/` | Proton: content node, disk/memory index, flush, matching |
| `vespalib/` | C++ utilities |
| `eval/` | Tensor implementation and ranking-expression evaluation |
| `container-search/` | Searchers, YQL, query profiles, grouping, dispatch |
| `container-disc/`, `jdisc_core/` | jDisc container and core |
| `document/`, `documentapi/` | Document model and document operations |
| `vespaclient-container-plugin/`, `vespa-feed-client/` | document/v1 and the feed client |
| `indexinglanguage/`, `docproc/`, `docprocs/` | Indexing language and document processors |
| `config-model/`, `configserver/`, `config/` | Application model, config server, config subscription |
| `storage/` | Distributor and storage |
| `linguistics/` | Linguistics components |
| `model-integration/`, `model-evaluation/` | ONNX and model import |

Most `.sd` files in `vespa` are test fixtures (`music.sd` and similar), not product schemas. For a schema example, use `sample-apps`.

### Sample apps

Top-level directories are apps. `examples/` holds smaller ones: `joins`, `predicate-fields`, `bm25f`, `reranker`, `lucene-linguistics`, `document-processing`, `operations`, and others.

| App | What it demonstrates |
|---|---|
| `news/` | Getting-started sequence: feed, search, recommendation, parent/child |
| `text-search/` | Plain text search |
| `use-case-shopping/` | Shopping search with a site |
| `rag-blueprint/`, `retrieval-augmented-generation/` | RAG |
| `billion-scale-vector-search/`, `billion-scale-image-search/` | Large vector and image search |
| `colbert/`, `colbert-long/`, `splade/`, `multi-vector-indexing/` | Multi-vector and sparse retrieval |
| `visual-retrieval-colpali/`, `text-image-search/`, `text-video-search/` | Multimodal |
| `model-inference/`, `commerce-product-ranking/`, `msmarco-ranking/` | Ranking models |
| `album-recommendation/`, `album-recommendation-java/` | Recommendation |

## What was left out

Indexed extensions: `.java`, `.cpp`, `.cc`, `.cxx`, `.c`, `.h`, `.hpp`, `.hh`, `.py`, `.sd`, `.profile`, `.def`, `.xml`, `.md`, plus `.html` and `.htm` in `documentation` only.

Not indexed: JSON, YAML, `.properties`, Gradle, shell, JavaScript, CSS, Go, images, and HTML inside `vespa` or `sample-apps`. Files over 1 MB. Files with a NUL byte. Hidden directories and build trees (`.git`, `target`, `build`, `node_modules`, `graphify-out`, `_site`, `vendor`). Documentation outside `en/`.

Tests are indexed (`src/test`, `src/tests`). To prefer implementation:

```yql
and !(path matches ".*/src/tests?/.*")
```

## How a file is split

A passage is a window of at most about 1,600 characters and 80 lines, not a whole file. Long units overlap by 8 lines, and later windows repeat the unit's first line.

| File | Split |
|---|---|
| Markdown | On headings. Fenced code goes to `code`, the rest to `prose`. The heading breadcrumb is prepended to `prose`. |
| HTML | On `h1`–`h3`. `pre` and `code` go to `code`. `script` and `style` are dropped. `start_line` and `end_line` are both the heading line, so they are not a span. |
| Java, C, C++ | On top-level `{` `}` blocks. Comments go to `prose`, the rest to `code`. |
| Python, `.sd` | On top-level `class`/`def`, or on schema blocks (`field`, `rank-profile`, `document-summary`, `struct`, `fieldset`, `annotation`, `constant`). `#` comments go to `prose`. |
| XML | Whole file, then windows. `<!-- -->` goes to `prose`. |
| `.def` | Windows of the whole file. `#` comments stay in `code`. |

`code` is prefixed with `{repo}/{path}` and the symbol, so a filename token is searchable. Document ids are `id:corpus:source_file::{repo}/{path}` and `id:corpus:passage::{repo}/{path}#{n}` with `n` starting at 0.

## Fields

`repo`, `source_language`, and `kind` are fast-search attributes. Filter with `contains` and an exact value.

| Field | What it holds |
|---|---|
| `repo` | `vespa`, `sample-apps`, or `documentation` |
| `path` | Path inside that checkout. `contains` is the whole path. `matches` is a regex. |
| `source_language` | `java`, `cpp`, `c`, `python`, `sd` (includes `.profile`), `def`, `xml`, `markdown`, `html` |
| `kind` | `doc` (markdown, html), `schema` (`.sd`, `.profile`), `config` (xml, def), otherwise `code` |
| `symbol` | Preferred declaration in that window: class, interface, enum, record, rank-profile, document-summary, field, struct, then def. Exact attribute. Empty when the regex found nothing. On code and schemas, `heading` is a copy of `symbol`. |
| `heading`, `heading_path` | Doc heading and its parents. On code, a one-element copy of `symbol` when one was found. |
| `start_line`, `end_line` | Lines in the source file. Real spans for markdown and code. HTML is a single approximate line. |
| `prose` | Doc text, or comments pulled out of code. Indexed with the `prose` Lucene profile. |
| `code` | Code, or fenced/HTML code, prefixed with repo, path, and symbol. Indexed with the `code` Lucene profile. |
| `file` | Reference to `id:corpus:source_file::{repo}/{path}` |
| `parents` | That same file id, as a string |
| `links` | Resolved `source_file` ids from includes, Java imports, markdown links, and `<document type="...">`. At most 24. |
| `link_paths` | Those raw target strings, resolved or not. HTTP links are dropped. |
| `language` | Always `en`. This is the linguistics language, not `source_language`. |

`source_file` fields: `repo`, `path`, `source_language`, `symbols` (up to 64 declaration names), `byte_size`. Use it to find a file. `symbols contains "BitVector"` is an exact element match. Then read that file's passages.

`embedding` is a schema-level `tensor<float>(x[384])` from `prose + " " + code`, bge-small-en-v1.5, L2-normalized. It is not returned in the document summary.

## Queries

`userQuery()` searches the `default` fieldset, which is `prose` only, and it stems with the platform stemmer. `userInput()` does not run the code tokenizer, so a camelCase identifier stays one token.

Use `text()`. That runs the field's Lucene profile. `prose` lowercases, folds ASCII, and applies an English minimal stem (plurals, not `-ing`). `code` splits camelCase, keeps the original token, lowercases, and does not stem. A camelCase `text()` query is a weakAnd of those parts.

Pass the text as `q` and `ranking=default`. Add `prose` and `code` to the select list when you need the passage text. A filter-only query has no BM25, so `default` relevance is 0. Raise `hits` above the default of 10 when you need more than the first page.

| Looking for | Where |
|---|---|
| An identifier, class, config name, filename | `code contains text(@q)`, `ranking=default` |
| Prose in a guide or in comments | `prose contains text(@q)` |
| Either | both |

`default` is `2 * atan((bm25(prose) + bm25(code)) / 8) / pi`. No query tensor.

`hybrid` adds cosine. Distance is `prenormalized-angular`, so cosine is `1 - distance(field, embedding)`. The same `input.query(q)` is required. Leave the BGE prefix off; the embedder adds `Represent this sentence for searching relevant passages: ` on queries. `dense` is cosine only and needs that same input.

`default` is BM25 of `prose` and `code`. `dense` is cosine only. `hybrid` is both. Use `hybrid` when the question is not clearly one or the other. A question that turns on an exact name can use `default` and `code contains text(@q)`. A question about meaning, with no rare name, can use `dense`. Common code words (`visit`, `document`, `field`, and the pieces of a short camelCase name such as `BitVector`) outrank the concept under `default`. A longer identifier such as `PartialBitVector` stays on the right file.

You may run another query when the passages do not state what was asked. Change the question, the filters, the rank profile, or `hits`. A large `hits` value is hard to read and crowds the context.

If several hits are the same file, you can keep one passage from that file.

Tests are indexed under `src/test` and `src/tests`. Leave them in to see how something is used. Filter them out with `!(path matches ".*/src/tests?/.*")` when they are in the way.

`path contains "searchlib/src/vespa/searchlib/common/bitvector.h"` is the whole path. A prefix matches nothing. `path matches "searchlib/.*bitvector"` is the regex. `symbol contains "PartialBitVector"` is the whole symbol.

These commands were run against this application and returned hits.

Identifier in engine code, with tests filtered out. First hits are `partialbitvector.cpp` and `partialbitvector.h`:

```bash
vespa query \
  'select path, symbol, start_line, repo, kind from passage where code contains text(@q) and repo contains "vespa" and kind contains "code" and !(path matches ".*/src/tests?/.*")' \
  q=PartialBitVector ranking=default hits=3
```

Concept phrase. First hit is `en/querying/nearest-neighbor-search-guide.md`, with `approximate-nn-hnsw.md` also on the first page:

```bash
vespa query \
  'select path, heading, symbol, start_line, repo, kind from passage where ({targetHits:20}nearestNeighbor(embedding, q)) or prose contains text(@userq) or code contains text(@userq)' \
  'userq=HNSW nearest neighbor search' \
  'input.query(q)=embed(bge, "HNSW nearest neighbor search")' \
  ranking=hybrid hits=3
```

Schema reference, docs only. First hit is the `rank-profile` heading in `en/reference/schemas/schemas.html`:

```bash
vespa query \
  'select path, heading, symbol, start_line, repo, kind from passage where (prose contains text(@q) or code contains text(@q)) and repo contains "documentation" and path matches "en/reference/schemas/.*"' \
  q=rank-profile ranking=default hits=3
```

A worked schema in the news sample app. First hits are `news.sd` rank-profile `recommendation`:

```bash
vespa query \
  'select path, symbol, heading, start_line, repo, kind from passage where repo contains "sample-apps" and path matches "news/.*" and (prose contains text(@q) or code contains text(@q))' \
  q=recommendation ranking=default hits=3
```

One file, in order. Relevance stays 0; `order by start_line` is what sequences the page:

```bash
vespa query \
  'select heading, symbol, start_line, end_line, prose, code from passage where path contains "en/reference/querying/yql.html" order by start_line' \
  hits=5
```

The file document for a known path, then the declaration list. `symbols contains "PartialBitVector"` hits `bitvector.h` and `partialbitvector.h`:

```bash
vespa query \
  'select path, repo, source_language, byte_size from source_file where path contains "searchlib/src/vespa/searchlib/common/bitvector.h"'

vespa query \
  'select path, repo from source_file where symbols contains "PartialBitVector"'
```

When the passage is not enough, open `git-checkouts/{repo}/{path}` at `start_line`. For HTML, that line is only the heading.
