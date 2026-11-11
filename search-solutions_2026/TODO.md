# Retrieval improvements

Proposals only. `vespa-corpus/` and `AGENTS.md` are unchanged.

The index already answers "where is this written?" with BM25 and "what is this about?" with hybrid search. Graphify-style tools answer a third question: "what is this connected to?" An agent can answer that with a short loop of `vespa query` calls, because this corpus is about 19,000 files and 113,000 passages. The work is to store relations as filterable documents, and to tell the agent when to stop ranking and start walking.

Do the items in order. Later items depend on earlier ones. Leave Leiden communities, god-node degree, and model-inferred edges out of the first feed.

## 1. Teach the definition lookup that the fields already support

`AGENTS.md` sends an identifier query to `code contains text(@q)`. That finds every mention. The definition, when the chunker saw one, is `symbol` on `passage` and `symbols` on `source_file`.

`symbol` is the first name from `DECL_RE` in `vespa-corpus/scripts/chunk.py`: `class`, `interface`, `enum`, `record`, `rank-profile`, `document-summary`, `field`, `struct`, then `def`. `source_file.symbols` keeps up to 64 of those names for the whole file. Both are exact attributes. Neither has `attribute: fast-search`. `symbols` also lacks `rank: filter`.

Add a short procedure to `AGENTS.md`, ahead of the `code contains text(@q)` example:

1. Look up the definition with `symbol contains "PartialBitVector"` on `passage`, and `symbols contains "PartialBitVector"` on `source_file`.
2. Rank mentions separately with `code contains text(@q)` and `ranking=default`.
3. Lead the answer with the definition hit. Use the mention query for callers-in-text and comments.

Add `attribute: fast-search` to both fields when that lookup is part of the normal path. Keep them case-sensitive. Do not set `match: word` on `symbol`: the `in` operator lowercases, and `PartialBitVector` must not collide with a lowercase name.

State the limit in the same section. `DECL_RE` does not see C++ functions, Java methods, or constructors, and the engine tree is mostly those files. A function with an empty `symbol` still has to be found through `code`. Fixing that is item 4, not a prompt change.

## 2. Add an `edge` document and point `AGENTS.md` at a walk

File relations already exist, but they are stored on the passage that happened to contain them. `resolve_links` in `chunk.py` keeps includes, Java imports, Markdown links, and `<document type="...">`, drops HTTP targets, and stops at 24. Each passage resolves links from its own window, so an include in the header is invisible from a later window. The array is not `fast-search`, and it has no relation label. Incoming lookup ("who includes this header?") has no field to filter on.

Add `schema edge` and register `<document type="edge" mode="index"/>` in `vespa-corpus/services.xml`. One document per relation, extracted once from the whole file:

| Field | Role |
|---|---|
| `source` | `source_file` id of the file that contains the reference. String attribute, `match: word`, `attribute: fast-search`, `rank: filter`. |
| `target` | `source_file` id of the resolved file. Same settings as `source`. |
| `relation` | `includes`, `imports`, `links`, or `declares`. Same settings. |
| `confidence` | `EXTRACTED` for this feed. Same settings. Present so a later feed can add other values without a new field. |
| `repo`, `path` | Copied from the source file, so a hop can skip `src/test` the way passage queries already do. |

`match: word` is required on the fields used with `in`. That operator lowercases and does not tokenize. Store the document ids in their real form; the index and the query fold case the same way. Two paths that differ only by case collapse. That is acceptable here and should be one line in `AGENTS.md`.

Give each edge a stable id, `id:corpus:edge::{repo}/{path}#{relation}#{n}`, with `n` unique per source file. Do not embed edges. Do not copy them onto passages.

Extract from the whole file, not from each passage window, and drop the cap of 24. Keep the same resolvers. `IMPORT_RE` only matches a Java import that ends in `;`. Python `import` and `from ... import` are a separate item. Map the four current resolvers to `includes`, `imports`, `links`, and `declares`.

`AGENTS.md` gets a "Following a relation" section with a procedure and one command that was actually run:

1. Seed with the existing identifier or hybrid query. Take the `file` id, `id:corpus:source_file::{repo}/{path}`, from the hit. Walk from that id, not from the passage text.
2. Expand with `ranking=unranked` and an explicit `hits` cap (50). A filter-only query scores 0, and the default of 10 hits silently cuts the neighborhood.
3. Outgoing: `where source in (@ids) and relation in (@rels)`. Incoming: `where target in (@ids) and relation in (@rels)`. Pass the lists as request parameters.
4. Keep a visited set in the agent. Stop at 4 hops, or sooner when the goal id appears.
5. Rank only the seed, and the final passages fetched by id. Do not run `hybrid` on the frontier.
6. Select `source`, `target`, `relation`, and `confidence` only.

Outgoing example to run and paste back in the style of the existing samples:

```bash
vespa query \
  'select source, target, relation, confidence from edge where source in (@ids) and relation in (@rels)' \
  'ids=id:corpus:source_file::vespa/searchlib/src/vespa/searchlib/common/bitvector.h' \
  'rels=includes,imports' \
  ranking=unranked hits=50
```

Use a source id that the feed actually produced. If that header has no outgoing includes, pick one that does and say which.

After edges exist, tell the agent that `passage.links` is a partial copy of the same facts and is the wrong field to walk. Leave the field in place until a later cleanup.

## 3. Land the walk on a passage

An edge ends at a file. The agent still needs a passage and a line. `AGENTS.md` should say: take `target`, strip the `id:corpus:source_file::` prefix into `repo` and `path`, then run the file query that is already documented (`path contains "..."` on `passage`, `order by start_line` when the whole file matters). Open `git-checkouts/{repo}/{path}` at `start_line` as today.

Prefer the passage whose `symbol` equals the name the user asked for, when one exists. That is the definition window from item 1.

## 4. Widen declarations, then add symbol-level edges

File edges answer "which file includes this header?" They do not answer "which function calls this?" That second question is the one graphify's code pass is built for. Two steps, still deterministic, still no model:

1. Teach `symbols_in` to record function and method definitions in C, C++, Java, and Python, and write those names into `symbol` / `symbols`. Keep the preferred-declaration order. A window that is a function should carry that function's name, not only the enclosing class when the class keyword happened to appear first.
2. Add relations `extends`, `implements`, and `calls`, but only where a parser can see the target in the same file or as a resolved import. Point `target` at a symbol key, `id:corpus:source_file::{repo}/{path}#{name}`, and keep the file id in a separate field so the file hop from item 3 still works. Skip a call the parser cannot bind. Do not guess. Tree-sitter is the right parser; a broader regex will invent calls from comments and strings.

`confidence` stays `EXTRACTED`. Names that occur in two files stay two symbol keys. The walk distinguishes them. Text search cannot.

Document the new relations and the symbol-key form in the same `AGENTS.md` section as item 2. Add a second worked query: incoming `calls` for one symbol that the feed contains.

## 5. Later, and only if a real query needs them

Do not build these in the first change.

- **Doc-to-code edges.** Hybrid search already returns the guide and the implementation for a phrase. An edge is worth adding only for the hop "I am on this doc passage, open the type it describes" when the page never spells the identifier. Those edges are `INFERRED`. Keep them out of the default hop (`relation in (@rels)` lists the structural relations only).
- **A community id on `source_file`.** Compute it offline from the edge set and store an integer. Useful for "other files in this cluster," not for the path. Do not cluster inside the query loop.
- **Degree.** A high edge count marks headers that everything includes. It is a poor ranking boost for definitions. Skip it.

## What stays as it is

Lexical and hybrid passage search stay available. The agent chooses the profile. The graph walk is for a relation a ranked query cannot name. Parent/child references stay the one `file` field: a reference array does not deploy on this application, parents are global, and cycles are rejected. Passage embeddings stay on passages. Edges do not get a vector.

## Passage ranking

Independent of the edge work above. The score is the judged fact rate: claims in the reference body that the written answer states, pooled across the 100 training questions. MRR is not the decision. File identity is not the decision. A frozen claim list has to be written once, from `vespa-training-qa.md`, and both rounds scored against it. Two judges who invent their own claims do not share a denominator.

Round 3 is the baseline. Against the frozen claim list it scores 813/1935 (42.0%). The earlier judge figure, 815/1648, is a different exam. The harness allows more than one `vespa query`, and allows `WebSearch` and `WebFetch(docs.vespa.ai)`. Rounds 1 and 2 used the one-query harness. A partial round that sent meaning questions to `dense` was cancelled, and that edit was reverted.

A cloud retrieval check, `targetHits` 20, put dense at MRR 0.577 and the hybrid query at 0.415. Forcing `dense` for every meaning question did not raise the fact rate on the one-query harness. That check does not decide the items below.

Do these in order. Each one is a fact-rate comparison against the previous round. Keep a change only when the pooled rate rises.

### 1. Let the agent choose the query

One addition to `AGENTS.md`. No schema change, no refeed. The Vespa skills stay the query manual. This paragraph only says the agent may judge.

Name the three deployed profiles. `default` is BM25 on `prose` and `code`. `dense` is cosine only. `hybrid` is both, and it is the one to use when the question is not clearly one or the other. An exact name can use `default`. A meaning question with no rare name can use `dense`.

The agent may run another query when the passages do not state what was asked. It may change the question, the filters, the rank profile, or `hits`. A large `hits` value is hard to read and crowds the context. There is no required starting value and no cap.

If several hits are the same file, the agent can keep one passage from it. That is a choice, not a rule.

Tests are indexed under `src/test` and `src/tests`. Leave them in to see how something is used. Filter them with `!(path matches ".*/src/tests?/.*")` when they are in the way. Do not drop them by default.

Written into `AGENTS.md` and kept. Round 4 scores 1098/1935 (56.7%) on the same frozen list. Round 3 was 813/1935 (42.0%).

### 2. See whether `dense` for meaning questions raises the fact rate

Only after item 1. Same text as item 1, except a meaning question uses `dense` instead of leaving the choice open. Compare facts to the item 1 round. Revert the profile line if the rate does not rise. The earlier MRR gain is not a reason to keep it.

### 3. See whether `nativeRank` helps

Only after the profile choice in item 2 is settled. Add a rank profile whose first phase is `nativeRank(prose) + nativeRank(code)`. Tell the agent it exists, and when proximity of the words matters. Do not strip question words in the prompt, and do not union it with `dense` in the instructions. Compare facts. Drop the profile if the rate does not rise.

On an earlier lexical check, full-question BM25 was MRR 0.27 and nativeRank on the content words was MRR 0.43. That was file rank, not facts.

### 4. Keep compounds as tokens, and give heading and symbol their own BM25

The standard tokenizer splits on hyphens and dots before `wordDelimiterGraph` runs, so `preserveOriginal` never sees `rank-score-drop-limit` or `model.defaultIndex`. `text("rank-score-drop-limit")` ranked `ranksetup.h` ahead of the schema reference. nativeRank recovers some of this because the parts sit next to each other. It does not recover the compound.

Switch `code` and `prose` to a whitespace tokenizer, then `wordDelimiterGraph` with the original token and the catenated form both kept. Stem the parts only. Query and index change together, so this is a refeed.

`heading` is pasted into `prose` and `symbol` into `code`, so a short name competes at the length of the whole window. Add both as their own BM25 fields and weight them above the body. "What is a Vespa bucket?" should score the buckets-page heading above every C++ file that says bucket. Dense's top hit for that question was `FixedBucketSpaces.java`, which the accepted answer cites, followed by the metrics `Bucket` class, which is a different type.

### 5. Embed prose and code with separate models, and stop embedding the path

The chunker caps each field at 1,600 characters so bge-small's 512 tokens see the whole passage. They do not. Of 102,579 passages, 23,019 (22.4%) exceed 512 tokens. Code is 21.8% over (19,600 of 89,954), config 63.3% (3,006 of 4,748, piled up at about 809 tokens), docs 6.4% (407 of 6,374), schemas 0.4% (6 of 1,503). Median length is 383 tokens, p90 is 589, p99 is 810, the longest is 1,348. Truncation drops 111 tokens on average, and 6,315 passages lose more than a fifth of their tokens. 93% of all tokens survive.

19,385 passages have `code` alone over 512. Only 3,478 overflow solely because `prose` and `code` are concatenated. The long context belongs on the code model. Docs and schemas already fit in 512, so the prose model stays there.

Replace the one `embedding` field, built from `prose + " " + code` by bge-small. Two fields, each with its own model. Do not embed `{repo}/{path}`, and do not give the path a vector of its own.

`embedding_prose` is `MongoDB/mdbr-leaf-ir`, component id `leaf`. 23M, 6-layer BERT, 512 tokens. On that model's BEIR table, nDCG@10 is 53.55, against 51.65 for bge-small-en-v1.5, 51.98 for snowflake-arctic-embed-s, and 50.15 for Arctic XS. The stored vector is 768. The pipeline mean-pools a 384-wide hidden state, applies a linear layer to 768, and L2-normalizes. The ONNX in the repo is the encoder only, and Vespa will not apply the linear layer. Export the full pipeline, set `pooling-strategy` to `none`, and set `normalize` true. Distance stays `prenormalized-angular`. Tensor `tensor<float>(x[768])`. Indexing is `input prose | embed leaf`. Prepend `Represent this sentence for searching relevant passages: ` on queries only. Encode documents with this same model. The asymmetric setup, documents through `snowflake-arctic-embed-m-v1.5`, is a 110M model and stays out.

`embedding_code` is `ibm-granite/granite-embedding-small-english-r2`, component id `granite`. 47M ModernBERT, 384 dimensions, CLS pooling, context 8,192. The model card's comparison puts CoIR at 53.4 against bge-small 45.8, and long-document search at 61.9 against 32.1. Short English retrieval ties bge-small, which is why prose uses leaf-ir. Config is the field piled up near 809 tokens, and it lives in `code`, so this context covers it. The longest passage is 1,348 tokens. Set `max-tokens` to 2048. `pooling-strategy` `cls`, `normalize` true, no query prefix and no document prefix. ModernBERT has no token type ids: set `transformer-token-type-ids` empty. The repo ships no ONNX. Export a graph with inputs `input_ids` and `attention_mask` and output `[batch, sequence, 384]`. Tensor `tensor<float>(x[384])`.

`passages_for` writes `{repo}/{path}` and the symbol on the front of `code`. Leave that line on the indexed `code` field so the filename stays searchable. Feed granite from `code_embed`: the same window with `{repo}/{path}` removed and the symbol kept. `code_embed` is not indexed and not returned. Indexing is `input code_embed | embed granite`. An empty `prose` or an empty `code_embed` gets no vector. The embedding of an empty string is a neighbor for unrelated queries.

Remove the bge-small component. BM25 stays `lex_norm`. Replace `dense` and `hybrid`.

| Profile | First phase | Query tensor |
|---|---|---|
| `dense-prose` | cosine of `embedding_prose` | `query(q)` `tensor<float>(x[768])` |
| `hybrid-prose` | `lex_norm` plus that cosine | same |
| `dense-code` | cosine of `embedding_code` | `query(q)` `tensor<float>(x[384])` |
| `hybrid-code` | `lex_norm` plus that cosine | same |
| `hybrid` | `lex_norm` plus the max of the two cosines | `query(qp)` at 768 and `query(qc)` at 384 |

`hybrid` is the query that searches both vectors. The single-field profiles do not declare the other tensor. A missing input fails the query.

When the two fields are in the feed, replace the embedding paragraph and the `embed(bge, ...)` example in `AGENTS.md`. Do that in the same change as the feed, not before. The agent chooses the field.

`embedding_prose` is leaf-ir, from `prose`. `embedding_code` is granite, from the code window without the repo and the path. The indexed `code` field still starts with `{repo}/{path}`.

Search the prose vector, the code vector, or both. Embed the query with that field's model, `embed(leaf, "...")` or `embed(granite, "...")`. Do not add a prefix. The leaf embedder adds one on queries. Granite does not.

A guide or a comment can use the prose vector. How the code behaves can use the code vector. Use both when either field might answer. `hybrid-prose`, `hybrid-code`, and `hybrid` add BM25. `dense-prose` and `dense-code` are cosine only.

Run these against the new feed and paste the commands back in the style of the samples.

Prose:

```bash
vespa query \
  'select path, heading, symbol, start_line, repo, kind from passage where ({targetHits:20}nearestNeighbor(embedding_prose, q)) or prose contains text(@userq)' \
  'userq=what is a Vespa bucket' \
  'input.query(q)=embed(leaf, "what is a Vespa bucket")' \
  ranking=hybrid-prose hits=3
```

Code:

```bash
vespa query \
  'select path, symbol, start_line, repo, kind from passage where ({targetHits:20}nearestNeighbor(embedding_code, q)) or code contains text(@userq)' \
  'userq=how does HNSW visit documents' \
  'input.query(q)=embed(granite, "how does HNSW visit documents")' \
  ranking=hybrid-code hits=3
```

Both:

```bash
vespa query \
  'select path, heading, symbol, start_line, repo, kind from passage where ({targetHits:20}nearestNeighbor(embedding_prose, qp)) or ({targetHits:20}nearestNeighbor(embedding_code, qc)) or prose contains text(@userq) or code contains text(@userq)' \
  'userq=HNSW nearest neighbor search' \
  'input.query(qp)=embed(leaf, "HNSW nearest neighbor search")' \
  'input.query(qc)=embed(granite, "HNSW nearest neighbor search")' \
  ranking=hybrid hits=3
```

Compare facts to the previous round. This is a refeed. Keep it only when the pooled rate rises.

### 6. A reranker, only if the fact rate is still short

Do not build a LateOn or ColBERT first-phase index. LateOn-Code-edge is a 17M late-interaction model: 48-dimensional token vectors, 2,048 document tokens, 256 query tokens. Its context would cover this corpus. MaxSim over all 102,579 passages is a brute-force scan or an HNSW index per token. A few hundred tokens per passage is on the order of 5 GB of float vectors before the graph, or about 1.2 GB at int8.

If a model experiment is still worth running after the items above, rerank the passages the agent already retrieved. LateOn-Code-edge is a reasonable reranker because it is small and it was trained on code. The Vespa ColBERT sample apps score it in second phase for the same reason.
