# Vespa golden Q&A

Progress: **100/100** accepted. Last update: 2026-11-05.

Append-only. Each accepted pair is added under `## Accepted` and the slot table is marked `done`. Resume from the first slot that is not `done`.

## Slots

| # | Status | Band | Topic |
| ---: | --- | --- | --- |
| 1 | done | concept | What is an application package? |
| 2 | done | concept | What is a schema? |
| 3 | done | concept | What is services.xml for? |
| 4 | done | concept | Document id format |
| 5 | done | concept | Container cluster vs content cluster |
| 6 | done | concept | What is a rank profile? |
| 7 | done | concept | What is YQL? |
| 8 | done | concept | What does feeding a document mean? |
| 9 | done | concept | index, attribute, and summary |
| 10 | done | concept | What is a document summary? |
| 11 | done | concept | What is a query profile? |
| 12 | done | concept | Smallest deployable package |
| 13 | done | concept | What happens at deploy |
| 14 | done | concept | Schema name vs document type |
| 15 | done | concept | Default summary |
| 16 | done | schema | match: text, word, exact |
| 17 | done | schema | Indexing statements |
| 18 | done | schema | array, weightedset, map |
| 19 | done | schema | Struct fields |
| 20 | done | schema | Tensor types |
| 21 | done | schema | Stemming modes |
| 22 | done | schema | Fieldsets |
| 23 | done | schema | Rank-profile inheritance |
| 24 | done | schema | First-phase vs second-phase |
| 25 | done | schema | bm25 rank feature |
| 26 | done | schema | nativeRank |
| 27 | done | schema | Rank expressions |
| 28 | done | schema | filter rank type |
| 29 | done | schema | Bolding |
| 30 | done | schema | Which indexing modes make a field searchable |
| 31 | done | schema | Attribute fast-search and fast-access |
| 32 | done | schema | Position / geo fields |
| 33 | done | query | YQL select form |
| 34 | done | query | userInput |
| 35 | done | query | weakAnd |
| 36 | done | query | nearestNeighbor arguments |
| 37 | done | query | Grouping |
| 38 | done | query | Sorting |
| 39 | done | query | Query timeout and softtimeout |
| 40 | done | query | Choosing a rank profile |
| 41 | done | query | presentation.summary |
| 42 | done | query | hits and offset |
| 43 | done | query | Trace |
| 44 | done | query | Coverage in the response |
| 45 | done | query | Degraded results |
| 46 | done | query | Partial updates |
| 47 | done | query | Conditional writes |
| 48 | done | query | Document visit / selection |
| 49 | done | query | Imported fields (parent/child) |
| 50 | done | query | Query profiles and types |
| 51 | done | product | Streaming vs indexed search |
| 52 | done | product | HNSW index settings |
| 53 | done | product | targetHits and exploreAdditionalHits |
| 54 | done | product | Exact nearest neighbor |
| 55 | done | product | Global-phase ranking |
| 56 | done | product | Match-phase degradation and diversity |
| 57 | done | product | ONNX in a rank profile |
| 58 | done | product | Embedders |
| 59 | done | product | Significance / IDF |
| 60 | done | product | Linguistics pipeline |
| 61 | done | product | N-gram indexing |
| 62 | done | product | Searcher chains |
| 63 | done | product | Document processors |
| 64 | done | product | Reindexing |
| 65 | done | product | Adding a field vs changing a field type |
| 66 | done | product | Predicate fields |
| 67 | done | product | Grouping continuation |
| 68 | done | product | Phased summary fill |
| 69 | done | precise | BM25 parameters and formula as implemented |
| 70 | done | precise | What BM25 document frequency counts |
| 71 | done | precise | nativeRank components |
| 72 | done | precise | How weakAnd differs from AND |
| 73 | done | precise | filter annotation vs ranking |
| 74 | done | precise | Field presence (exists / missing), current mechanism only |
| 75 | done | precise | Sorting by a rank feature |
| 76 | done | precise | Field paths into map and struct |
| 77 | done | precise | Weighted-set matching |
| 78 | done | precise | match-features vs summary-features |
| 79 | done | precise | How an application package becomes config |
| 80 | done | precise | fast-search attribute posting lists |
| 81 | done | precise | Ranking labels |
| 82 | done | precise | Tokenization boundary between linguistics and the index |
| 83 | done | precise | Query-tensor inputs |
| 84 | done | precise | Rank-profile constants and functions |
| 85 | done | internal | HNSW filter strategy cutoffs (verify in code first) |
| 86 | done | internal | Memory-index flush trigger |
| 87 | done | internal | Rank-property defaults vs YQL annotation defaults for HNSW filters |
| 88 | done | internal | Proton local document id |
| 89 | done | internal | BM25 df and average field length source |
| 90 | done | internal | Struct-leaf text indexing, current blocker only |
| 91 | done | internal | vespa.eval.use_fast_forest |
| 92 | done | internal | YQL parser entry point |
| 93 | done | internal | Global filter bitvector handed to HNSW |
| 94 | done | precise | When a fed document becomes visible to search |
| 95 | done | internal | Lucene linguistics vs C++ matching |
| 96 | done | internal | Ranking label storage / item-label features that actually exist |
| 97 | done | precise | near and onear distance |
| 98 | done | internal | Document-frequency request path if it exists in select or ranking |
| 99 | done | internal | Index fusion / sub-databases a query reads |
| 100 | done | internal | One stable proton matching detail confirmed in current code |

## Accepted

### 4. What is the format of a Vespa document id?

A Vespa document id is a URI string. The only defined scheme is `id:<namespace>:<document-type>:<key/value-pair>:<user-specified>`. The string may contain only text characters, as defined by `isTextCharacter` in `com.yahoo.text.Text`.

- **namespace** (required): separates document collections. The same user-specified part in two namespaces is two documents, as in `id:first_namespace:my_doc_type::shakespeare`. It is independent of the schema and `services.xml`. Document selection can match `id.namespace`. A query cannot use the namespace except as part of the full id.
- **document-type** (required): the document type declared in the schema and in `services.xml`.
- **key/value-pair** (optional): a bucket-distribution modifier. When it is empty, the id has two consecutive colons and documents are placed uniformly, as in `id:mynamespace:mydoctype::user-defined-id`. When set, it is exactly one of `n=<number>` (an integer in `[0, 2^63-1]`, only for testing abnormal bucket distributions) or `g=<groupname>` (hashed to choose the storage location). These modifiers are only useful for document types with `mode=streaming` or `mode=store-only`. Do not use them for indexed documents: feeding performance becomes unpredictable, and search dispatch cannot limit the search to those buckets.
- **user-specified** (required): the application’s own id string.

- **Sources:** `documentation/en/schemas/documents.html` (Document IDs, id scheme, Namespace)
- **Review:** Accepted from [document id](94684d95-2340-45cb-a559-37de159aaeb4) after checking that page. Tightened the modifier sentence to include the indexed-mode warning, which the page states next to the streaming/store-only note. JSON examples such as `id:mynamespace:cakes:tasty_chocolate_cake` in `document-json-format.html` drop the empty key/value field; the scheme on the Documents page keeps that field, empty or `n=` / `g=`.

### 2. What is a schema?

A Vespa schema describes a type of data and what should be computed over it. The `schema` element is the root of a schema file. Inheritance is optional: a schema that inherits another includes that schema’s constructs, except the parent document type, which the child document type must inherit itself. An application package can contain many schemas.

A schema declares one document type: a named collection of fields, and optionally struct types and storage compression. Outside the document it may declare synthetic fields, fieldsets, rank profiles, constant tensors, ONNX models, document summaries, and imported fields. It may also set the default stemming, whether document ids are stored on disk only or as an attribute, and whether raw fields are Base64-encoded in summaries (the default is true).

Each schema is a file named the same as the schema, ending in `.sd`, in the application package’s `schemas/` directory. Rank profiles may instead be `[profile-name].profile` files in any directory below `schemas/[schema-name]/`. Each content cluster in `services.xml` refers to the schemas stored in that cluster.

- **Sources:** `documentation/en/basics/schemas.html` (opening); `documentation/en/reference/schemas/schemas.html` (`schema`, `document`, `rank-profile`); `documentation/en/reference/applications/application-packages.html` (`schemas/` and `schemas/[schema]/`)
- **Review:** Accepted from [schema](30ebb380-acf0-41f1-baff-d65fa517cf49). Checked the schema-body table and the document-body table. The basics page says content clusters refer to schemas that should be “stored an indexed”; the answer says stored, because a content cluster can also be `streaming` or `store-only`. A `.sd` file may use `document` as the root when that document is not queried directly; this answer describes the `schema` element.

### 3. What is services.xml for?

`services.xml` sits at the root of an application package and specifies the clusters the application runs. The root element is `services`, and its `version` attribute is required (`1.0` in this version of Vespa). A `container` element specifies a stateless container cluster. A `content` element specifies a content cluster, which stores data, maintains indexes, and runs the distributed part of queries. At least one of `container` or `content` is required. `admin` (control-plane configuration) and `routing` (how content is routed) are allowed and rarely needed.

Document types and the computations over them, such as ranking, are described by schema files under `schemas/`. A content cluster names the types it keeps with a `document` element inside `documents`: `type` is the document type name, and `mode` is `index`, `store-only`, or `streaming`. The container cluster loads the middleware for querying and feeding those documents, such as `search` and `document-api`.

- **Sources:** `documentation/en/reference/applications/services/services.html` (`services.xml`, `<services>`); `documentation/en/basics/applications.html` (A minimal application package); `documentation/en/reference/applications/services/content.html` (`document`)
- **Review:** Accepted from [services.xml](83c97844-6ade-49cb-a5ce-0564b85dbc03). “Stateless” is the word the minimal-application section uses for a container cluster. `search` and `document-api` are the middleware in that example, not the full list of container components.

### 6. What is a rank profile?

A rank profile is a named set of ranking expressions, functions, and settings that score documents matching a query. It is declared with `rank-profile` inside a schema, or as `[profile-name].profile` in any directory below `schemas/[schema-name]/`. A schema can contain many profiles. The query selects one with `ranking.profile`, or through a query profile. If the request does not name a profile, Vespa uses the profile named `default`; if the schema does not define that profile, ranking uses the `nativeRank` feature. The built-in profile `unranked` is always available.

`first-phase` is the expression applied to every match and defaults to `nativeRank`. Optional `second-phase` reranks the top hits on the content node. Optional `global-phase` reranks the top hits in the container after hits from the content nodes are merged. The same profile can declare helper functions, query inputs, constants, and models used by those expressions, and it can inherit other profiles in this schema or in a schema it inherits.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`rank-profile`, `first-phase`, `second-phase`, `global-phase`); `documentation/en/basics/ranking.html` (Rank profiles, Phased ranking)
- **Review:** Accepted from [rank profile](25b71893-cc8a-47ab-abdf-5e1ab0c9020a). Phase defaults and where each phase runs match those sections. The basics page shows `.profile` files directly under `schemas/[schema-name]/`; the schema reference allows any directory below that, which is the wording kept here. The answer does not say what happens when a query names a profile the schema does not contain.

### 5. What is the difference between a container cluster and a content cluster?

A container cluster is a stateless Java cluster. It receives client traffic, runs components that process that traffic, and passes queries and writes on to the content nodes that hold the documents. A content cluster stores the documents, maintains distributed indexes, and runs queries and inference over that data, including matching, ranking, and grouping. Both are declared in `services.xml`. One container cluster can feed and query, or those jobs can be split across container clusters.

At feed time, clients send puts, updates, and removes to a container with the document API enabled, using the document/v1 HTTP API. The container runs indexing transformations, including the built-in indexing document processors and any configured custom ones, then the document API forwards the operation to distributors on the content nodes. When the write is acknowledged, it is persisted, fully processed, and visible in later queries.

At query time, clients send the query to a container with search enabled. Search chains on the container normalize, rewrite, and enrich the query, then dispatch matching, ranking, and grouping to the content nodes. The container then does result processing and rendering. Summary fields for the top hits are fetched from the content nodes that produced those hits, not held on the container. A get by document id also goes through the container to the content cluster.

- **Sources:** `documentation/en/learn/overview.html` (Container clusters, Content clusters); `documentation/en/basics/operations.html` (Performance and scaling); `documentation/en/basics/writing.html` (Writes are streamed and realtime); `documentation/en/writing/reads-and-writes.html`; `documentation/en/writing/document-routing.html` (`chain.indexing`); `documentation/en/querying/query-api.html` (Query execution, Result processing)
- **Review:** Accepted from [container vs content](8d8a0abe-1939-404b-870c-c6438f6f4c27) with two corrections. Summary fetch is a request back to the content nodes that produced the hits. `search.visibility-delay` does not delay ordinary write visibility; it is the TTL cache for parent-child imported fields, so that caveat was dropped. A get is forwarded to distributors on content nodes, not described here as a direct hop to the storing node.

### 1. What is an application package?

An application package is a directory of files that specifies a Vespa application. It is the deployment unit, and it contains everything needed to run the application: configuration, schemas, components, and machine-learned models. The only way to change the running application is to change the package and deploy it again. Vespa then changes the running system to match the new revision without impacting queries, writes, or data, and rejects invalid or destructive changes before they take effect.

`services.xml` is required. A package can consist of only that file. Document types, and how they are queried and ranked, are `schemas/*.sd` files. Other files are added when the application uses them, including `models/`, `components/` (jars with searchers), `search/query-profiles/`, `constants/`, and `tests/`. `hosts.xml` maps logical nodes to hosts for self-managed Vespa and is not used on Vespa Cloud, which takes node counts from `services.xml`. The application-package reference marks `security/clients.pem` required for Vespa Cloud. `deployment.xml` is required for a production deployment, where it names environments, regions, and instances; the same reference says it is ignored, with some exceptions, when deploying to dev.

Deploying to the dev zone or a self-managed cluster sets up a single instance. Production can set up multiple instances in one or more regions. Deploy the directory with `vespa deploy` (current directory, to the current target and the default dev zone) or `vespa prod deploy` for production. The same tree can be zipped and deployed as that zip, or submitted through the deploy API. Tests in the package can verify the application before a production deployment.

- **Sources:** `documentation/en/basics/applications.html` (Vespa applications, A minimal application package, Deploying applications); `documentation/en/reference/applications/application-packages.html` (file table, Deploy)
- **Review:** Accepted from [application package](6320880f-66a2-4373-9985-d561447265cb). Left out whether `clients.pem` is the only allowed certificate filename: the package reference lists that file as required for Vespa Cloud, while `certificate@file` is a path. Also left out the unnamed dev exceptions for `deployment.xml`. `tar`/`gzip` is not the documented archive form; zip is.

### 7. What is YQL?

YQL is Vespa’s query language. A query is a YQL string sent as the `yql` request parameter. For structured data the language matches SQL, with additions for vector and full-text search. Vespa accepts unstructured human input and structured application queries separately, then combines them for execution. The application query is the YQL.

The basic form is `select … from … where …`. `select` lists the summary fields to return, and Vespa hides the other fields of matching documents. `select *` requests all fields. `from sources` chooses the content sources: `sources *` queries all of them, `sources source1, source2` queries a set, a single source can omit the `sources` keyword (`from music`), and `source1.schema1` names one document type in a source. `where` is the match condition, for example `where title contains "madonna"`. `where true` matches all documents.

`limit` and `offset` paginate, and a value in YQL overrides the `hits` and `offset` request parameters, including values set in a query profile. `limit` here is the last hit to return, not a count: `limit 31 offset 29` skips the first 29 hits and returns two. `select * from doc where true limit 15 offset 5` returns hits 6–15. The YQL reference says these are limited by `maxHits` (default 400) and `maxOffset` (default 1000).

- **Sources:** `documentation/en/basics/querying.html` (Queries); `documentation/en/reference/querying/yql.html` (`select`, `from sources`, `limit / offset`); `documentation/en/querying/query-language.html` (Live query examples)
- **Review:** Accepted from [YQL](2dcdac21-47a1-4922-b0cf-34c007807ef9). The guide’s “hits 6–15” matches the reference example, where `limit 31 offset 29` returns two hits. That is not SQL `LIMIT`/`OFFSET`. The request parameter `hits` is a count (default 10) and is a different control from YQL `limit`.

### 8. What does feeding a document mean in Vespa?

Feeding is how you write data into a Vespa application. A document is a JSON object of field values with an id such as `id:my-namespace:my-documenttype::my-id-string`. The write operations are put, update, and remove. Writing a document again fully replaces the existing one. An update changes selected fields of an existing document, for example by assigning a new value, and leaves the other fields in place. A remove deletes the document by id.

These operations go to the application’s write endpoint through the `/document/v1` HTTP API. The container that accepts them must have `<document-api>` in `services.xml`. For one document, the id is in the path `/document/v1/<namespace>/<document-type>/docid/<user-specified>`, and each request is one operation. HTTP POST puts the document (`fields` holds values), HTTP PUT sends a partial update (each field holds an operation such as `assign`), and HTTP DELETE removes it. `vespa feed`, pyvespa, and the Java feed client submit the same operations. A feed file names them `"put"`, `"update"`, or `"remove"` and includes the document id.

Writes are streamed over HTTP/2 and processed asynchronously. When a write is acknowledged, it has been persisted and fully processed, and the result is visible in later queries.

- **Sources:** `documentation/en/basics/writing.html` (Documents, Writing documents, Updating documents, Writes are streamed and realtime); `documentation/en/writing/document-v1-api-guide.html` (POST, PUT, DELETE); `documentation/en/reference/api/document-v1.html` (POST Put, PUT, request body); `documentation/en/reference/schemas/document-json-format.html` (Document operations)
- **Review:** Accepted from [feeding](df90622d-90c1-4430-a72e-fc878cd3cfc1). The HTTP verbs are easy to swap and were checked: POST is put, PUT is partial update, DELETE is remove. “Fully replaced” is the writing page’s wording for writing the document again.

### 9. What do index, attribute, and summary mean on a Vespa field?

`summary`, `attribute`, and `index` are indexing modes. `summary` includes the field in document summaries, so it can be returned in query responses. `attribute` stores the value in the in-memory column store. It is available for structured search (exact, range, regexp, and similar), ranking, sorting, grouping, and aggregation, and it is searched with match mode `word`. `index` creates a full-text on-disk index for a string, searched with match mode `text`, and an HNSW vector index for a tensor. A tensor index also requires `attribute`.

A field can combine modes in one statement, separated by a pipe, which passes the value to the next expression, as in `indexing: summary | attribute | index`. When both `index` and `attribute` are set, the field’s match mode becomes `text`, and searches use the index rather than the attribute.

- **Sources:** `documentation/en/basics/schemas.html` (Document fields); `documentation/en/reference/schemas/schemas.html` (`indexing`)
- **Review:** Accepted from [index, attribute, and summary](482aa45c-524a-49d7-87d3-3ad664d13435). Added the attribute match mode `word`, which is in the same indexing table as the index/attribute combination rule. `fast-search` is a later slot.

### 11. What is a query profile?

A query profile is a named set of query parameters defined in the application package. It is an XML file of parameter names and values. When a request names the profile, those parameters are applied as if they had been set on the request. If the same parameter is set in both the request and the profile, the request value wins by default.

Profile files live in `search/query-profiles/` at the application package root. That directory is optional. A file is named after the profile, with any `/` in the name replaced by `_`, for example `search/query-profiles/MyProfile.xml`. A query selects a profile with the `queryProfile` parameter. If the request does not name one, the profile named `default` is used. If there is no `default` profile, no profile is used. If `queryProfile` names a profile that does not exist, the request returns an error.

A query profile can reference a query profile type, which turns on type checking. The type lists which parameters the profile can contain and whether other parameters are allowed. Type files are XML files in `search/query-profiles/types/`.

- **Sources:** `documentation/en/querying/query-profiles.html` (Query Profiles, Using a Query Profile, Query Profile Types); `documentation/en/reference/applications/application-packages.html` (`search/query-profiles/`)
- **Review:** Accepted from [query profile](1c5bc169-ce70-4dfe-8792-b4d41e05f5ba). The type sentence now matches the page: a type lists which parameters a profile can contain and whether others are allowed. `overridable="false"` can reverse the request-wins default and is not part of this answer.

### 12. What is the smallest application package that can store and query documents?

The package that stores documents and serves text, vector, and hybrid search with filtering is two files, `services.xml` and `schemas/myschema.sd`. The container, id `queryfeedendpoint`, includes `search` and `document-api`. The content cluster, id `mydocs`, sets `min-redundancy` to 2 and declares document type `myschema` with `mode="index"`. The schema lists three fields: `text`, type `string`, `indexing: summary | index`; `embedding`, type `tensor<bfloat16>(x[384])`, `indexing: attribute | index`; and `popularity`, type `double`, `indexing: summary | attribute`.

- **Sources:** `documentation/en/basics/applications.html` (A minimal application package)
- **Review:** Accepted from [smallest package](5d91036c-f700-4339-b282-40a806284143). The page assigns text, vector, and hybrid search with filtering to those two files together, not to one field each. A container-only `services.xml` is a smaller package and does not store data; that case is in slot 1.

### 10. What is a document summary?

A document summary is the information shown for each document in a query result. A document summary class, declared with `document-summary` in the schema, is a named set of fields and the configuration for what each field contains. A class named `default` is always present and is used when the query does not choose another. It contains every field whose indexing statement says the field may be included in summaries, every field named in any document summary, plus `sddocname` and `documentid`.

The query selects the class with `presentation.summary`. That parameter defaults to the schema’s default summary class, which is `default`. In YQL, `select *` returns every field of the chosen class. Listing fields in `select` filters which of those fields the container puts in the response. The content nodes still produce the whole chosen summary class, so a shorter `select` list does not reduce what is fetched.

`summary` in the indexing statement is what puts a field value into a summary. `index` and `attribute` are separate outputs for matching, ranking, sorting, and grouping. Attribute fields requested in a summary are read from memory. Other summary fields are blobs in the document store, so requesting them can require a disk access. `documentid` is in the `default` summary and is stored only in the document store unless the schema sets `documentid: attribute`, so the `default` summary reads the document store.

- **Sources:** `documentation/en/querying/document-summaries.html` (Document Summaries, Selecting summary fields in YQL, Performance); `documentation/en/reference/schemas/schemas.html` (`document-summary`); `documentation/en/reference/api/query.html` (`presentation.summary`)
- **Review:** Accepted from [document summary](2f207b27-56f2-470c-b210-07b4b18aae01). The `default` membership list matches that page, including fields named only in some other summary class. Added the document-store cost of `documentid`, which the performance note states next to the `default` class.

### 15. What does Vespa return when a query does not name a document summary?

Vespa fills each hit from the document summary class named `default`. That class is always present. The query selects another class with `presentation.summary`; when that parameter is omitted, the default is the schema’s default summary class.

`default` contains every field whose indexing statement says the field may be included in summaries, every field specified in any document summary, and the fields `sddocname` and `documentid`. A `summary` field with no `to` list goes to `default`. `to` can be set on a field, not inside an explicit `document-summary`. Fields with summary indexing stay in `default` even if the deprecated `summary-to` names other summary classes.

- **Sources:** `documentation/en/querying/document-summaries.html` (Document Summaries); `documentation/en/reference/schemas/schemas.html` (`document-summary`, `summary`, `summary-to`); `documentation/en/reference/api/query.html` (`presentation.summary`)
- **Review:** Accepted from [default summary](91611b84-e7c7-492f-abeb-bf577079df69). The `to` sentence matches the `summary` reference: when `to` is omitted, the field goes to `default`. `summary-to` is deprecated and does not remove a summary field from `default`. How `select` filters the class, and the document-store cost of `documentid`, are in slot 10.

### 14. What is the difference between a schema name and a document type?

A schema name identifies a `schema`: a type of data and what Vespa computes over it. The schema must live in a file named `[schema-name].sd`. A document type is the name of the `document` element, the fields that can be written and read. Inside a schema that name is optional and defaults to the schema name. If it is written, it must match the schema name. In the schema reference, “document type” means that document name.

A `document` element can be the root of the file when that document is not queried directly. With no enclosing `schema`, the document name is required. Inheriting a schema includes the parent’s constructs except the parent document type, so the child `document` must itself `inherit` the parent document type. A document type’s `inherits` is an optional comma-separated list of other document types whose fields it includes. If none are listed, the document inherits the generic `document` type.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`schema`, `document`)
- **Review:** Accepted from [schema vs document type](430efddb-16f9-4249-a06a-100cd0ff1215). The name rules match that reference: optional inside a schema, required as the file root, and required to match the schema name when both are written.

### 13. What happens when you deploy an application package?

Deploying an application package creates a running instance, or makes a change to an existing one take effect. A deployment to the dev zone or a self-managed cluster sets up one instance. A production deployment can set up multiple instances in one or more regions, and the package must include `deployment.xml`. A change is generally safe at any time: it does not disrupt queries and writes, and invalid or destructive changes are rejected before they take effect. `validation-overrides.xml` can allow a package to deploy even when validation fails.

Deploy runs prepare, then activate. Prepare checks that a config server is up, uploads the package into a session stored on the config server and in ZooKeeper (which distributes it to the other config servers), writes deploy metadata, checks that the required files are present and consistent, and validates the XML config files. It compares the prepared package with the active one and returns actions such as restart or re-feed. It also distributes constant tensors and component bundles to the nodes. Activate waits for prepare to finish, activates the new configuration version, and signals containers to load new bundles.

- **Sources:** `documentation/en/basics/applications.html` (Deploying applications); `documentation/en/reference/applications/application-packages.html` (Deploy, `validation-overrides.xml`)
- **Review:** Accepted from [deploy](6254b3d3-a8b9-4b33-992b-37d0a5629d4d). The prepare and activate steps match that Deploy table. “Rejected” is the applications page’s word; the Deploy table says prepare returns the restart or re-feed actions and points at validation overrides, which is why that file is named here.

### 17. What is an indexing statement?

An indexing statement is a sequence of indexing expressions separated by `|`, executed from left to right. The pipe passes the execution value from each expression to the next, as in a UNIX pipe. That value is `null` before the statement runs. In the indexing language a statement ends with `;`. A field’s one-line `indexing:` form is the same pipeline without that terminator; the block form `indexing { ...; ...; }` uses semicolons between statements.

`input year | attribute year` sets the execution value to the document’s `year` field and writes it to the attribute `year`. `index` and `summary` also write the current execution value. An output expression both writes the value and declares the field structure. One statement cannot assign different values to the same field: `attribute | lowercase | index` does not deploy.

For a field inside a document, the field value enters the pipeline. If the statement does not already read an input, Vespa uses `input` of that field. A field outside the document must start with an expression that outputs a value, such as `input [fieldname]` or a literal. `input <fieldName>` reads that field; a name containing `.` reads a nested struct field.

- **Sources:** `documentation/en/reference/writing/indexing-language.html` (lead, Indexing script, Indexing statement, Outputs, `input`); `documentation/en/reference/schemas/schemas.html` (`indexing`)
- **Review:** Accepted from [indexing statement](9e069fbf-7798-4220-81f4-68ca57c4a918). Split the semicolon rule: the language reference terminates statements with `;`, while the schema’s `indexing:` line does not. The illegal `attribute | lowercase | index` example is in the Outputs section and was missing from the draft. The implicit `input` for a document field, and the required leading output for a synthetic field, are separate sentences in the schema reference.

### 16. What do the field match settings text, word, and exact do?

`text`, `word`, and `exact` are match modes for a string field. `match: cased` turns off the default lowercasing. `uncased` is the default.

`text` is the default for a string field with an index, including a field that has both `index` and `attribute`. It matches per token. Indexed text goes through tokenization, lowercasing, normalizing (for example `für` becomes `fur`), and stemming. The default stemming setting is `best`.

`word` is the default for a string attribute with no index. The whole value is one term, including spaces, with no tokenization. `word` and `exact` both turn stemming off and lowercase without accent removal, so an attribute value keeps `für`. `word` still parses ordinary query syntax. Quotes are required to include a space, a star, or an exclamation mark. `exact` takes the query text as written and stops at the exact-match terminator, which defaults to `@@`.

The schema reference says an `exact` field is implicitly `rank: filter`, because there is one term per value (or per element of a multivalue field). `rank: normal` turns that off. The config processor sets the filter flag only when the exact field is indexed. An attribute-only `exact` field does not get it.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`match`, `stemming`, `normalizing`); `documentation/en/querying/text-matching.html` (Index and attribute); `config-model/src/main/java/com/yahoo/schema/processing/ExactMatch.java`; `config-model/src/main/java/com/yahoo/schema/document/NormalizeLevel.java` (`inferLowercase`)
- **Review:** Accepted from [match modes](1ffce230-f130-470b-9852-f1fb438d6ef0). The match section’s opening sentence says all three modes match after normalization and lowercasing. The text-matching guide’s attribute example keeps `für` and calls lowercasing the only transformation, and `ExactMatch` sets stemming to none and normalization to lowercase for both `word` and `exact`. The implicit filter flag is set only in `exactMatchSettingsForField`, which runs when `field.doesIndexing()` is true.

### 18. How do array, weightedset, and map field types differ?

An `array<type>` holds elements of one primitive type or one struct type. It has no key and no weight. The field-type reference says an `array<struct>` maintains order and can contain the same element more than once; that is the ordered alternative to a map. Every array is fed as a JSON array.

A `weightedset<element-type>` holds elements of type `byte`, `int`, `long`, or `string`. Each element has a signed 32-bit integer weight. In JSON the field is an object from element to weight, so each element is a key and appears once. Partial updates address that key. The field-type reference does not define an element order. A weighted set cannot filter on the weight.

A `map<key-type, value-type>` holds one value for each unique key. The key type is any primitive and the value type is a primitive or a struct. Each entry is a struct with `key` and `value` fields.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`array`, `weightedset`, `map`); `documentation/en/reference/schemas/document-json-format.html` (array, weightedset, map)
- **Review:** Accepted from [array, weightedset, and map](9306f3f0-c5ec-4aa3-9317-b84fd2177709). Order and repeated elements are stated for `array<struct>`, not for primitive arrays. Weighted-set uniqueness is the JSON object and the update “key” wording, not a separate uniqueness sentence. `weightedset<uri>` was not added; the field-type paragraph lists byte, int, long, and string.

### 21. What are the stemming settings, and which is the default?

`stemming: [stemming-type]` sets how a field or an index is stemmed, or the schema default. The schema reference places it on a field, on the schema, or on an index. The types are `none` (keep words unchanged), `best` (the best stem of each word by a heuristic score), `shortest` (the shortest stem), `all-stems` (every token from the linguistics component, but not the original word), and `multiple` (the original word and every token from the linguistics component). The default is `best`.

Stemming is symmetric: words are converted to stems both when indexing and when searching. Fields combined in a fieldset should use the same stemming type.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`stemming`); `documentation/en/linguistics/linguistics-opennlp.html` (Stemming)
- **Review:** Accepted from [stemming](9ef81e7f-ca7b-4a42-b387-e8eb168019af). The linguistics page says the setting can be placed on a field, a fieldset, or as a default for all fields. The schema reference places it on field, schema, and index, and only says fields in a fieldset should share a type. `word` and `exact` forcing `none` is in slot 16, not here.

### 20. What is the difference between a dense, sparse, and mixed tensor?

Each tensor dimension is either indexed, written `dimension-name[size]`, or mapped, written `dimension-name{}`. Indexed dimensions use integer labels from 0 inclusive up to the declared size exclusive. Mapped dimensions use string labels and are sparse. A dense tensor has indexed dimensions only, a sparse tensor has mapped dimensions only, and a mixed tensor has both.

A dense tensor’s dimensions all have a declared size, so the number of cells is fixed, as in the matrix `tensor<float>(x[3],y[2])`. A sparse tensor stores the cells that have labels, as in `tensor<float>(x{},y{})`. In a mixed tensor, such as `tensor<double>(key{},x[2])` or `tensor<bfloat16>(word_id{},vec[300])`, each mapped address holds a block of values over the indexed dimensions.

The cell type is separate. It is `float` (32-bit IEEE 754), `double` (64-bit IEEE 754), `int8` (signed 8-bit integer), or `bfloat16` (the first 16 bits of a 32-bit IEEE 754 float). Omitting the value type defaults to `double`.

- **Sources:** `documentation/en/reference/ranking/tensor.html` (Tensor type spec, Tensor literal form); `documentation/en/reference/ranking/constant-tensor-json-format.html` (Dense, Sparse, Mixed tensors); `documentation/en/ranking/tensor-user-guide.html` (Tensor concepts)
- **Review:** Accepted from [tensor types](cf617b6a-7768-4f3f-b2ae-9804ecbc5845). The three class names are the constant-tensor JSON headings. The mixed “block of values for each address” wording is that page’s, not a second storage model. The default cell type `double` is stated for a tensor literal that omits the value type.

### 19. What is a struct field, and what can be indexed on it?

A struct is a composite type defined in a document. It has zero or more fields that are accessed together, and it must be defined before it is used as a field type. A struct-field is a subfield of a field whose type is that struct, or an array or map of structs. A map entry is a struct with `key` and `value`. The struct-field says how that subfield is stored, indexed, and searched.

In indexed search, a struct-field supports only `attribute`, and only for a primitive leaf of an array or map: `bool`, `string`, `int`, `long`, `byte`, `float`, or `double`. The leaf is searchable when it is declared as an attribute. The struct may still contain non-primitive fields when those are not attributes. A map value may be a primitive or a struct, with that same limit on which fields are attributes. A field of a single struct type cannot be searched in indexed search, and attributes are not supported on it. A struct-field whose own type is a struct may specify only `indexing: summary`.

In streaming search, a struct-field may use `index` and `summary` as well as `attribute`. `index` on the top-level struct or array-of-struct field makes all of its parts searchable. `index` on the top-level map field makes all struct fields in that map searchable. Indexed search searches the primitive attribute leaves described above.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`struct`, field type `struct`, `array`, `map`, `struct-field`)
- **Review:** Accepted from [struct fields](1ffed5d2-5d49-4941-a26b-e3ee1348d535). The single-struct row forbids indexed-search matching and attributes; `struct-field` allows `attribute` for indexed search, and that applies to primitive array and map leaves. Streaming `index` means those parts are searchable. The page does not call struct leaves full-text indexes. Primitive type rows still say `index` is unsupported for `bool` and numbers.

### 22. What is a fieldset?

A fieldset is declared in a schema and groups fields so a query can search them together. It is a mapping onto those fields and does not add index structures in memory or on disk. A query uses the fieldset name where it would use a field name, as in `where text_content contains text(@q)`. A fieldset named `default` is the one used when the query does not name a fieldset. You declare that fieldset; it is not built in.

Fields in a fieldset should be as similar as possible in indexing clause and match mode. Different match modes produce a warning at deployment. Fields in a fieldset should use the same stemming type. They must use the same tokens at search time, whether that comes from `tokens` or from stemming. If those differ and at least one field sets `tokens`, deployment fails. When matching a fieldset, document frequency is aggregated across the member fields. That changes BM25 and significance, and it can make `weakAnd` drop a common term that is frequent in one member and rare in another.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`fieldset`, `stemming`, `linguistics`); `documentation/en/querying/query-api.html` (Fieldset)
- **Review:** Accepted from [fieldset](afc0359f-71a0-4929-80fb-bf877fe50efb). The query API says member fields must share match modes; the schema reference says a difference warns at deployment, which is the wording kept here. Added the fieldset section’s document-frequency aggregation, which the draft left out.

### 24. Where do first-phase, second-phase, and global-phase ranking run, and what are their default rerank counts?

First-phase ranking runs on the content nodes and scores every matching document. Its default expression is `nativeRank`. This phase has no rerank count. Second-phase ranking is optional and runs on each content node. If the rank profile has no `second-phase` block, that phase is skipped. Global-phase ranking is optional and runs in the container after hits from the content nodes are merged. If the rank profile has no `global-phase` block, that phase is skipped.

When a second-phase expression is set and no count is given, the phased-ranking guide says the 100 best first-phase hits are reranked per content node. The schema reference names that control `total-rerank-count` and says its default is 100 per node. `rerank-count` is the per-node alternative and has no numeric default in the reference; prefer `total-rerank-count`. When a global-phase expression is set, `rerank-count` defaults to 100. That count is applied per schema, so a query over several schemas can rerank 100 hits in each schema.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`first-phase`, `second-phase`, `global-phase`); `documentation/en/ranking/phased-ranking.html` (Two-phase ranking on content nodes, Using a global-phase expression)
- **Review:** Accepted from [ranking phases](1b31a02a-423b-4652-aaad-2c1784e88352). The sample `total-rerank-count: 1000` and `rerank-count: 20` in the basics page are examples, not defaults. The schema text calls `total-rerank-count` a total across the nodes in a group and also says the default is 100 per node; the phased-ranking page states the default as 100 best hits per content node, which is the wording kept here.

### 26. What does nativeRank combine?

`nativeRank` is a linear combination of `nativeFieldMatch`, `nativeProximity`, and `nativeAttributeMatch`. The score is `(fieldMatchWeight × nativeFieldMatch + proximityWeight × nativeProximity + attributeMatchWeight × nativeAttributeMatch)` divided by the sum of those three weights. The default weights are `fieldMatchWeight` 100.0, `proximityWeight` 25.0, and `attributeMatchWeight` 100.0. Table normalization is on by default. If it is turned off, the default `proximityWeight` is 100.0.

- **Sources:** `documentation/en/ranking/nativerank.html` (The nativeRank rank feature); `documentation/en/reference/ranking/nativerank.html` (`nativeRank`, Configuration properties)
- **Review:** Accepted from [nativeRank](f5c80411-025f-4c4c-8630-986dae463a04). The formula and the three weights match the reference table, including `useTableNormalization` defaulting to true and the proximity weight of 100.0 when that property is false. `nativeAttributeMatch` is an attribute-match feature, so the answer does not call all three text-match features.

### 27. What is a ranking expression?

A ranking expression configures an application-specific ranking function. It is a small language in ordinary functional notation. Its atoms are rank features and constants. A rank feature is a named value Vespa calculates or looks up for each query and document. A constant is a floating-point number, a boolean, or a quoted string. Expressions work only on scalars and tensors, so `true` becomes 1.0, `false` becomes 0.0, and a string becomes its hash. A string can be used only in an equality comparison. Those atoms are combined with arithmetic and other built-in functions. Arithmetic is infix and applies to tensors as well as scalars. Tensor functions are part of the same language.

In a schema, `expression` is set on `first-phase`, `second-phase`, or `global-phase`, and a rank-profile `function` also holds one. It can be written directly or loaded with `expression: file:[path]`. The path is relative to the schema file, the file name must end in `.expression`, that suffix may be omitted in the schema, and the path cannot contain a directory.

- **Sources:** `documentation/en/reference/ranking/ranking-expressions.html` (Ranking Expressions, Arithmetic operations, Tensor functions); `documentation/en/reference/schemas/schemas.html` (`expression`, `function`)
- **Review:** Accepted from [ranking expressions](6c63ef6d-1d24-4a2d-979d-4cb45d47694f). Added the string-hash rule and the file-path limits from those sections. Functions also contain expressions; the `expression` element reference lists only the three phases.

### 25. What does the bm25 rank feature compute, and what does a field need for it?

`bm25(field)` is Okapi BM25 over the query terms that match one indexed string field. For each term it adds `IDF(q_i) * f(q_i, D) * (k1 + 1) / (f(q_i, D) + k1 * (1 - b + b * field_len / avg_field_len))`. `f(q_i, D)` is the number of occurrences of the term in that field, and `field_len` is the field length in words. For a multi-value field both are summed over the elements. `avg_field_len` is the average length of that field among the documents on the content node. `IDF` is `log(1 + (N - n(q_i) + 0.5) / (n(q_i) + 0.5))`. `N` is the number of documents on the content node. `n(q_i)` is the number of documents that contain the term in that field, computed per index, and the maximum of those values is used, typically from the largest disk index. Because that IDF is local to the content node and the index, setting `significance` on a query term supplies the IDF used for that term. `k1` defaults to 1.2 and `b` to 0.75.

The field must be an indexed string field with `enable-bm25` set in its `index` section. If that flag is turned on after documents have already been fed, Proton flushes the memory index and then fuses the disk index to prepare the posting lists.

- **Sources:** `documentation/en/ranking/bm25.html` (Ranking function, Example); `documentation/en/reference/ranking/rank-features.html` (`bm25(field)`); `documentation/en/reference/ranking/rank-feature-configuration.html` (`bm25` `k1` and `b`)
- **Review:** Accepted from [bm25](4c148164-618e-46b3-b5e9-9d48cca31e96). The formula, the 1.2 and 0.75 defaults, the per-index maximum document frequency, and the flush-then-fusion step match the BM25 page. The `0` in the rank-feature table is the feature's fallback score, not `k1` or `b`. Significance is described as the IDF to use for that term, which is what the page says when the local value should be the same on every content node.

### 23. How does rank-profile inheritance work?

A rank profile may name other rank profiles in an optional `inherits` list. Those profiles may be in the same schema, or in another schema when this document inherits that schema's document. Elements the child does not define, including ranking phases and functions, come from those profiles. A child can therefore call a parent function such as `title_score` and supply its own `first-phase`. An inner rank profile must explicitly inherit the profile that contains it. Its query name is `containing-profile-name.inner-profile-name`.

If two inherited profiles define the same element, deployment fails.

Inputs are inherited, and inputs declared in the child are added to the parent's. Constants are inherited from parent profiles and from the schema, and a sub-profile can override them. ONNX models are inherited from parent profiles and from the schema. Omitted `summary-features` and `match-features` come from the parent. A local list is the child's list, and `inherits` on that block keeps the named parents' features and adds the local ones. `match-features {}` disables match features inherited from parents. Omitted `sort-features` are inherited. A local declaration replaces the list, and `sort-features {}` clears it. `sort-features` has no `inherits` clause. When multiple parents declare different non-empty lists, the child must declare its own list.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`rank-profile`, `rank-profile (inner)`, `inputs`, `constants`, `onnx-model`, `summary-features`, `match-features`, `sort-features`); `documentation/en/schemas/inheritance-in-schemas.html` (Rank profile inheritance); `documentation/en/ranking/ranking-expressions-features.html` (Using constants)
- **Review:** Accepted from [rank-profile inheritance](44334191-75ee-4241-beaa-84cf17fb1df0). The clash rule, the inner-profile name, cumulative inputs, and the summary-feature, match-feature, and sort-feature merge rules match those sections. `sort-features` is the documented exception to the general clash: different non-empty parent lists must be resolved by a local list, and the block has no `inherits` clause.

### 28. What does rank: filter do?

`rank: filter` makes Vespa match the field using fast bit-vector data structures only. That saves CPU during matching, but only a few simple ranking features are available for the field. It is appropriate for fields used to filter or to apply a simple boost, such as the language of the document. On an index field it leaves the index format unchanged and selects the most compact representation when matching. On an attribute field with `fast-search` it builds additional bit-vector posting lists, which can significantly speed up query evaluation.

Vespa sets this implicitly on an indexed field with `match: exact`, because such a field has one word per field, or one word per element of a multivalue type such as `array<string>`, and therefore little ranking information. `rank: normal` is the reverse: matching uses normal data structures and normal match information for ranking, and it turns that implicit filter off. If both `filter` and `normal` are set, the effect is as if only `normal` were specified.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`rank` filter and normal, `match` exact); `config-model/src/main/java/com/yahoo/schema/processing/ExactMatch.java` (`exactMatchSettingsForField`)
- **Review:** Accepted from [rank filter](2b5927c8-22a9-4dbe-a0df-d721ce94b885). The bit-vector description, the index and fast-search effects, and the `filter` plus `normal` rule match the rank section. The implicit filter is limited to an indexed exact field, which is what `ExactMatch` does. The match section's broader sentence is not used. The rank section does not say the score becomes zero.

### 29. How does bolding work?

Bolding highlights matching query terms in a summary. It is off by default. Set `bolding: on` on a field or inside a summary to enable it. The reference supports it for index fields of type string or `array<string>`. `summary: dynamic` overrides it: if both are set, bolding is ignored. A dynamic summary returns a query-dependent abstract and highlights matches, while bolding only highlights. A bolded field value larger than 64 MB is returned as a snippet, as with `summary: dynamic`.

Matched terms are wrapped in `<hi>` and `</hi>`. Change those tags with the `container.qr-searchers` configuration (`tag.bold.open` and `tag.bold.close`). The query parameter `presentation.bolding`, alias `bolding`, is a boolean and defaults to true. It controls whether those highlight tags are written for fields with `bolding: on` and for `summary: dynamic`. Turning it off omits the tags. A dynamic summary is still produced, and its separator becomes an ellipsis.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`bolding`, `summary`); `documentation/en/reference/api/query.html` (`presentation.bolding`); `container-search/src/main/java/com/yahoo/prelude/searcher/JuniperSearcher.java` (`highlight`, `addBolding`, `addSeparator`)
- **Review:** Accepted from [bolding](229dda30-db63-4f55-89ad-e8f05e998d09). The 64 MB limit is the bolding field-value limit. The summary section says dynamic highlighting is not affected by the `bolding` query argument. `JuniperSearcher` uses the same flag for both `bolding: on` and `summary: dynamic`, which matches the query API, so that is the behavior kept here. The deploy type check also allows `uri` and does not itself require the field to be indexed. The reference's supported set is the one stated.

### 30. Which indexing modes make a field searchable?

`index` and `attribute` make a field searchable. `index` creates a searchable index: full text for a string, or an HNSW index for a supported tensor, which also requires `attribute`. `attribute` makes the value available for structured search with match mode `word`. When both are set, the match mode is `text` and searches use the index. `summary` only includes the field in the document summary, so a summary-only field is not searchable.

In indexed search, a plain struct field cannot be searched. `attribute` is not supported on it, and `index` is only supported in streaming search. A `raw` field cannot be indexed, and as an attribute it is stored as raw data and is not searchable. For `byte`, `double`, `float`, `int`, and `long`, `index` is not supported and an attribute is used instead, so those fields stay searchable as attributes.

- **Sources:** `documentation/en/basics/schemas.html` (Document fields); `documentation/en/reference/schemas/schemas.html` (`indexing`, field types `struct`, `raw`, `byte`, `double`, `float`, `int`, `long`)
- **Review:** Accepted from [searchable fields](edee1af1-613a-440a-90ec-223b56f647eb). The index, attribute, and both-set rules match the indexing section and the basics page. The struct, raw, and numeric-type rows match the field-type tables. The automatic-attribute sentence is only on those five numeric types, so bool, position, and predicate are not included in it.

### 36. What arguments does nearestNeighbor take?

`nearestNeighbor` takes two positional arguments and optional annotations: `{...}nearestNeighbor(field, queryTensor)`. The first argument is the tensor field attribute that holds the document vectors. That attribute has one indexed dimension of size N, or one or more mapped dimensions plus one indexed dimension of size N. The second argument is the name of the query tensor. The request sends it as `input.query(<name>)`. It must have one indexed dimension of size N, and its type must be declared in the rank profile. If the type is missing, the request fails.

`totalTargetHits` is required and has no default on `nearestNeighbor`. It is the number of hits to expose to ranking in total over the content nodes evaluating the query. More or fewer hits may actually be produced. The annotations-catalog default of 100 applies to `wand` and `weakAnd`. `minTargetHits` defaults to 100. Each content node resolves its per-node target as `max(minTargetHits, ceil(totalTargetHits × share))`, where `share` is that node's share of the active documents in the group serving the query. `targetHits` is the target per content node. Prefer `totalTargetHits`. The annotations catalog lists its default as 100. `approximate` defaults to true when the field has an HNSW index, and is otherwise false. False disallows the approximate HNSW index. `hnsw.exploreAdditionalHits` defaults to 0 in the operator table. It is how many extra HNSW graph nodes to explore, in addition to `totalTargetHits`, before selecting the best hits. `label` names this operator for the `closeness` and `distance` rank features when one query has several `nearestNeighbor` operators. `distanceThreshold` defaults to `+infinity`. Hits with a greater distance are removed. The units are those of the field's distance metric. Setting it never returns more hits. Retrieving more hits also means raising `totalTargetHits`.

- **Sources:** `documentation/en/reference/querying/yql.html` (`nearestNeighbor`; annotations `totalTargetHits`, `minTargetHits`, `targetHits`, `approximate`, `hnsw.exploreAdditionalHits`, `label`, `distanceThreshold`)
- **Review:** Accepted from [nearestNeighbor](9ea9811a-b6ce-4ddf-a282-f85130ddbc83). The required `totalTargetHits`, the missing default on this operator, the `minTargetHits` formula, and the other annotation defaults match the YQL reference. The nearest-neighbor guide still says `targetHits` is required. That guide is not used here. The catalog default of 100 on `totalTargetHits` is the `wand` and `weakAnd` default. The operator table's default of 0 for `hnsw.exploreAdditionalHits` is the one kept. The catalog cell for that annotation is empty.

### 34. What does userInput do?

`userInput()` parses one string from an end user or a model. That text may itself contain query syntax for choosing fields, phrases, and negative terms. The argument is a literal, `userInput('some text')`, or a parameter reference, `userInput(@text)`. Because the text can name fields, it is not written as `field contains userInput(...)`. With no annotations, both of those examples become `weakAnd(default contains "some", default contains "text")`.

The `grammar` annotation defaults to `weakAnd`. That `model.type` value means composite `weakAnd`, tokenization `internal`, and syntax `simple`. `defaultIndex` defaults to `default` and is the field for terms that do not name one. `grammar` may also be `raw`, `segment`, or any other `model.type` value. `raw` matches the input string with no processing. `segment` runs it through the linguistic libraries first. Any other value parses it as a query. For `raw` and `segment`, `defaultIndex` is the field searched. The pieces can be set separately as `grammar.syntax`, `grammar.tokenization`, `grammar.composite`, and `grammar.profile`. `allowEmpty` defaults to false: empty or unparseable input fails the query, and true inserts a NullItem. `language` sets the linguistics language for this call. Its annotation default cell is empty.

For every grammar other than `raw` or `segment`, including the default `weakAnd`, the reference says only these annotations are applied: `defaultIndex`, `totalTargetHits` and `targetHits` (for weakAnd), `distance` (for near/oNear), `ranked`, `filter`, `stem`, `normalizeCase`, `accentDrop`, and `usePositionData`. Annotating `userInput` with `phrase` makes `filter` take effect and `language` not. The following sentence says `stem` and `ranked` take effect as normal, and both are already in that list.

`userQuery()` does not take this text. It reads `model.queryString`, parses that with the simple query language, and if `model.filter` is set, combines the filter with the query string before parsing. The parsed tree is inserted where `userQuery()` stands. Terms that do not name a field use `model.defaultIndex`, whose default is `default`. The reference example passes `query="abc def -ghi"` and `type=all`, so `abc` and `def` must occur in the default index and `ghi` must not.

`text()` is the field-scoped form: `field contains text("...")`. It supports the same annotations, and by default it also tokenizes into a `weakAnd`.

- **Sources:** `documentation/en/reference/querying/yql.html` (`userInput`, `userQuery`, `text`; annotations `grammar`, `defaultIndex`, `allowEmpty`, `language`); `documentation/en/reference/api/query.html` (`model.type`, `model.defaultIndex`, `model.queryString`, `model.filter`)
- **Review:** Accepted from [userInput](774c01e9-205f-4224-82e7-ec18f9a8c301). The unannotated rewrite, the `weakAnd` grammar mapping, and the `userQuery` example match those sections. `stem` and `ranked` are already in the "only these annotations" list, so the later sentence does not add annotations beyond it. `model.type.isYqlDefault` changes the default grammar for `userQuery`, and the page does not say it changes `userInput`'s own default. The query API examples linked from `userInput` use `text()`.

### 35. What does weakAnd do?

`weakAnd`, also called Vespa Wand, is an optimized `or`. It is not boolean `and`. It returns a limited number of documents for ranking. The default is 100, and it does not guarantee the best k hits. A document matches when it matches at least one query token and its internal score is greater than the worst score in the current top-k heap. Documents that fail that test are skipped, including documents that match several tokens. Hits the operator evaluates are still passed to first-phase ranking, so it typically matches more than k documents.

The internal score is query-term weight times term significance. Significance is the term annotation, or otherwise a corpus formula loosely based on inverse document frequency. How often the term occurs in the document is not used, and this score is not available as a rank feature. Matched terms are exposed as they are for `and` and `or`. Documented starting points for the ranking expression are `bm25`, `nativeFieldMatch`, and `nativeDotProduct`. The YQL reference says it searches multiple fields of all types, attribute or index. The WAND guide describes it as designed for indexed string fields and fieldsets, and says it applies tokenization and stemming and accepts `and` and `or` children.

`totalTargetHits` defaults to 100. It is the wanted number of hits exposed to first-phase ranking in total over the content nodes in the group evaluating the query. `targetHits` defaults to 100 and is that limit per content node. Prefer `totalTargetHits`.

A rank-profile `weakand` block can drop more, using content-node-local document frequencies. Global significance does not apply, so nodes can disagree. `stopword-limit` is optional, in [0, 1], and has no numeric default. A term whose normalized document frequency is above the limit is removed from the `weakAnd` evaluation and is not exposed to ranking. The schema reference says this makes matching faster at the cost of potentially producing more hits, and the `weakand` overview says the tuning can reduce recall. The example `stopword-limit: 0.60` drops terms that occur in at least 60% of documents. That value is an example. Unless `allow-drop-all` is true, at least the least common term is kept. `allow-drop-all` defaults to false. If it is true and every term is above the limit, `weakAnd` produces no hits. `adjust-target` is optional, in [0, 1], and has no numeric default. Documents scoring below the score of the query term whose normalized document frequency is closest to the setting are not considered, which reduces the hit count. The example `adjust-target: 0.01` is an example. On a fieldset, document frequency is aggregated across member fields, which can prune a common term such as "the".

- **Sources:** `documentation/en/reference/querying/yql.html` (`weakAnd`; annotations `totalTargetHits` and `targetHits`); `documentation/en/ranking/wand.html` (WAND, `weakAnd`, weakAnd inner scoring); `documentation/en/reference/schemas/schemas.html` (`weakand`, `stopword-limit`, `adjust-target`, `allow-drop-all`, fieldset document frequency)
- **Review:** Accepted from [weakAnd](dc77ebff-5387-4bcf-b1ff-93da43628fbc). The match rule, the default of 100, and the inner score match the YQL operator and the WAND inner-scoring section. The WAND guide's example sets `totalTargetHits: 200` and then says that number is used per content node. The YQL definitions of `totalTargetHits` and `targetHits` are the ones kept. The schema states both "more hits" and "reduced recall" for `stopword-limit`. Both sentences are kept. The YQL field-type row and the guide's indexed-string description are both stated.

### 32. How is a position field stored and queried?

A `position` field, or an `array<position>`, stores a geographical point. In document JSON the value is a `lat`/`lng` object in degrees, such as `{ "lat": 37.4181488, "lng": -122.0256157 }`. Positive latitude is north and negative is south. Positive longitude is east and negative is west.

The field is an attribute. `index` is not supported. The attribute is an interleaved 64-bit integer on a Z-order curve, with `fast-search` set implicitly, and position queries are range searches over that attribute. Each position field also has a `<fieldName>_zcurve` attribute.

A circle is `geoLocation(field, latitude, longitude, radius)`. Example: `where geoLocation(myfieldname, 63.5, 10.5, "200 km")`. The radius suffixes are `km`, `m`, `miles`, `mi`, `deg`, and `d`. A negative radius such as `"-1 m"` matches every position. A rectangle is `geoBoundingBox(field, southLatitude, westLongitude, northLatitude, eastLongitude)`, in degrees. Example: `where geoBoundingBox(myfieldname, 63.25, 10.01, 63.45, 10.61)`.

`distance(name)` is the Euclidean distance from the query position to that attribute, in millionths of degrees (about 10 cm). `distance(name).km` is that distance in kilometers. If several query items search the field, or the field is an array of positions, the closest distance is returned. The YQL reference also names `closeness(name)` for ranking. `geoLocation` uses simpler distance calculations and is not a great-circle distance. In grouping, `geo_distance(attribute(location), latitude, longitude).km` or `.miles` is the great-circle distance, and for an array it is the minimum.

The removed query parameters `pos.ll`, `pos.radius`, `pos.attribute`, and `pos.bb` are replaced by a `geoLocation` item. A rectangle in current YQL is `geoBoundingBox`.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`position`); `documentation/en/querying/geo-search.html` (Sample schema and document); `documentation/en/reference/querying/yql.html` (`geoLocation`, `geoBoundingBox`); `documentation/en/reference/ranking/rank-features.html` (`distance(name)`); `documentation/en/reference/querying/grouping-language.html` (`geo_distance`, `zcurve.x`); `documentation/en/reference/release-notes/vespa8.html` (removed HTTP API parameters)
- **Review:** Accepted from [position](19005721-4c7a-4548-8edb-985588f50d87). The Z-order attribute, the circle and rectangle arguments, the millionths-of-degrees distance, and the great-circle grouping function match those sections. The Vespa 8 notes replace `pos.bb` with a `geoLocation` item. The current rectangle operator is `geoBoundingBox`.

### 31. What do attribute fast-search and fast-access do?

They are separate attribute properties. `fast-search` adds a search structure. `fast-access` decides which replicas keep the attribute in memory.

Without `fast-search`, a match is a memory lookup and can scan every value. There is no hit-count estimate, so the planner treats the term as matching every document and evaluates it late. A query whose only term searches that field is a linear scan. Setting `fast-search` builds an in-memory dictionary of values and posting lists of local document ids. The default dictionary is a b-tree. Frequent values also get a bitvector beside the posting list. `dictionary: hash` uses a hash table, and short posting lists are arrays. If both are set, btree serves range and prefix lookup and hash serves exact lookup. With hash alone, string prefix search and numeric range search fall back to a full scan. A `dictionary` block applies only to a `fast-search` attribute. A string hash dictionary requires `match: cased` and `cased` in the dictionary block.

Use `fast-search` when the attribute is searched with no other query terms, or when that term can cut the hit set. When it is AND-ed with a more selective term, that other term dominates. Attribute search is not tokenized, normalized, or stemmed. On a string field that is both `index` and `attribute`, default `match: text` searches the index. The dictionary and posting-list memory for a `fast-search` attribute is not paged out. The setting shows up on disk only as a larger file. Empty single-value fields still cost memory, because the undefined value has a posting list. Updates use more CPU. Steady-state memory rises for every attribute type, and numeric types also pay initialization overhead. The sizing model counts a posting entry as 4 bytes for a single-value field and 8 bytes for an array or weighted set, and a 4-byte enum index when `fast-search` is set. String attributes, and any attribute with `fast-search`, are limited to about 2 billion unique values per node. A `reference` field cannot use `fast-search`, so a parent-id search is a linear scan. Adding or removing `fast-search` does not require refeeding. It does require a restart. When the field is not used for term ranking, `rank: filter` is the documented companion.

`fast-access` loads the attribute into memory on every node that stores a replica, so partial updates and a document-selection garbage-collection scan can use it there. The schema reference says the property is a no-op when `searchable-copies` equals `redundancy`, and it calls that equality the default. An imported field inherits the parent attribute properties except `fast-access`. Changing `fast-access` is in the same restart-without-refeed list as `fast-search`.

- **Sources:** `documentation/en/content/attributes.html` (`fast-search`, `fast-access`, Index structures, Paged attributes, Attribute memory usage); `documentation/en/reference/schemas/schemas.html` (`attribute`, `dictionary`, `reference`, `import field`, changes that require restart but not re-feed); `documentation/en/performance/feature-tuning.html` (When to use fast-search)
- **Review:** Accepted from [fast-search](6ba52dbd-1e78-40d0-a97d-65b86ee623df). The dictionary, the scan behavior, the memory costs, and the `fast-access` no-op match those pages. The content reference gives other `searchable-copies` defaults, so the no-op depends on the configured counts. The schema calls equality with `redundancy` the default. Factory fallbacks for unsupported types, the tensor `fast-search` path, and the deploy ban on `fast-access` for predicate, tensor, and reference were not re-checked, so they are not stated here.

### 33. What are the parts of a YQL select statement?

The YQL reference defines `select`, `from`, `where`, `order by`, `limit`, `offset`, and `timeout`. A grouping expression may follow after `|`.

`select` lists the summary fields to return, or `*` for every field of the chosen document summary class. That class is `default` unless another class is chosen. The content nodes still return the whole class, and Vespa hides the other fields.

`from` specifies which content sources to query. `sources *` queries all sources. `sources source1, source2` queries a set. `from source1` queries one source, and the `sources` keyword can be dropped for a single source. `from source1.schema1` queries one document type in a source.

`where` is a tree of operators that decides which documents match.

`order by` sorts the hits. Ascending is the default, and `desc` reverses one key. Another attribute is a tiebreaker. This ordering overrides the rank profile's rank-score order. A rank feature can be a sort key when its name is listed in `sort-features` and the key uses `function: "feature"`.

`limit` and `offset` slice the hits. `timeout` sets the query timeout as a number of milliseconds with no unit. A timeout written in YQL takes precedence over the request parameter `timeout`, which is in seconds.

A grouping expression after `|` groups or aggregates the results.

- **Sources:** `documentation/en/reference/querying/yql.html` (`select`, `from sources`, `where`, `order by`, `limit / offset`, `timeout`, Grouping); `documentation/en/querying/document-summaries.html` (Selecting summary fields in YQL)
- **Review:** Accepted from [YQL select](0e08f2c2-a24c-423c-95f0-aa5c9613fbf1). The clause list, the source forms, the millisecond timeout, and the pipe for grouping match the YQL reference. `select *` is every field of the chosen summary class, and the container hides the rest after the content nodes return the whole class. Rank-feature sorting is included because the same `order by` section defines it. The hit-window rules for `limit` and `offset` are already in an earlier answer. The parser also allows forms the reference does not define as clauses, so those are not stated.

### 42. What are the aliases for hits and offset, and what other limit combines the caps?

`hits` and `offset` are native execution parameters. The alias for `hits` is `count`, and the alias for `offset` is `start`. The full name and the alias can both be used in a request or a query profile. Aliases are case-insensitive in requests. Each value is a positive integer, including 0. `hits` is the maximum number of hits to return from the result set. `offset` is the number of hits to skip when returning the result, for pagination, and it defaults to 0.

`sorting.degrading` defaults to true. When the primary sort key is a single-value numeric attribute with `fast-search`, Vespa returns early and the total-hits count can be inaccurate. That optimization uses the primary sort attribute as the match-phase attribute and sets match-phase `maxHits` to `max(10000, maxHits + maxOffset)`. `maxHits` and `maxOffset` are the query-profile caps. The optimization is not activated when the primary sort key is `feature(...)`. Set `sorting.degrading` to false to disable it.

- **Sources:** `documentation/en/reference/api/query.html` (parameter aliases; `hits`; `offset`; `sorting.degrading`)
- **Review:** Accepted from [hits and offset](bd790cec-ff3d-4a7e-9a2b-60a5dc24086d). The aliases, the skip count, and the `sorting.degrading` formula match that page. Ordinary pagination has no separate rule that `hits` plus `offset` must stay under another ceiling. The combined cap is the match-phase `maxHits` used by this optimization.

### 38. How does Vespa sort hits?

With no sort specification, Vespa orders hits by the relevance score of the rank profile selected for the query. The request names that profile. Otherwise the schema profile `default` is used, and if the schema does not define it, a default profile ranks by `nativeRank`. That score is the special sort key `[relevance]`. `[rank]` is a legacy alias. Both default to descending order, so the highest score comes first. An explicit sort replaces this order.

Set the sort in YQL with `order by`, or with `ranking.sorting` (alias `sorting`). The sorting language separates expressions with a single space. YQL `order by` separates them with commas. The first expression is the primary key. Each later expression orders documents that tied on the previous key. With no further key, order inside a tie group is not deterministic. In a URL, `+` must be encoded as `%2B`.

If the direction is omitted, the default is ascending: lowest numeric values first. `sorting { order: descending }` on that attribute in the schema replaces the ascending default until the query sets a direction. `[relevance]` and `[rank]` still default to descending. `feature(name)` defaults to ascending, and the schema's attribute sorting settings do not change that.

Attribute sorting uses an attribute name. An index or summary field with no attribute cannot be an attribute sort key. For a map, the key may be `name`, `name.key`, or `name.value`. Strings use a sort function. The default is `uca` with strength `PRIMARY`. If no locale is specified in the query, on the field, or generally for the query, Vespa uses `lowercase` instead of `uca`. `raw` orders strings by UTF-8 bytes. Query `function`, `locale`, and `strength` override the schema settings. The sorting-language forms are `lowercase(attr)`, `raw(attr)`, and `uca(attr[, locale[, strength]])`.

For a multivalue attribute, ascending order uses the lowest value and descending order uses the highest. By default, a missing single-value attribute sorts before documents that have a value when the order is ascending, and after them when the attribute is multivalued or the order is descending. `missing(attr,first)`, `missing(attr,last)`, and `missing(attr,as,value)` force first, last, or a substitute value. If that value cannot be converted to the attribute type, indexed search aborts the query and streaming search ignores part of the sort specification. A missing policy can wrap a sort function. It cannot wrap `feature(...)`.

For a query that sorts only by attributes, the built-in `unranked` rank profile avoids computing a rank score and then ignoring it. Sorting on attributes can enable match-phase automatically. When the primary key is a single-value numeric attribute with `fast-search`, `sorting.degrading` can also return early with an inaccurate total-hit count. Neither optimization is activated when the primary key is `feature(...)`.

`feature(name)`, written in YQL as `{function: "feature"}name`, sorts by one numeric rank feature or one rank-profile function with no arguments. The name must be listed in `sort-features` on the rank profile the query selects. No features are allowed until they are listed. Each name is a bare identifier matching `[A-Za-z_][A-Za-z0-9_]*`. The result must be a numeric scalar. A sort feature cannot use or depend on `firstPhaseRank`, `firstPhaseMax`, or cross-hit normalization. `NaN` and infinite values become negative infinity. Every schema searched must use indexed mode. Streaming search does not support feature sorting. A query that uses feature sorting is rejected when global-phase reranking is enabled, unless `ranking.globalPhase.rerankCount=0`. An invalid or disallowed name is a query error. If a content node cannot obtain the requested values, it fails the query on that node.

Selecting a sort feature keeps the selected rank profile and does not itself run first-phase or second-phase ranking. If the query does not otherwise require ranking, hits have `relevance: 0`. Include `[relevance]` or `[rank]` to compute those scores. In YQL the special keys must be quoted. Listing a name in `sort-features` does not put the value in the response.

`[source]` sorts by source name when several sources are queried. `[docid]` sorts by the document's id in the search backend, which typically follows indexing order on that node. The id is unique only on that backend node.

- **Sources:** `documentation/en/reference/querying/sorting-language.html` (sort specification, default direction, missing policies, feature sorting, special keys); `documentation/en/reference/querying/yql.html` (`order by`); `documentation/en/reference/schemas/schemas.html` (`sort-features`, attribute `sorting`); `documentation/en/reference/api/query.html` (`ranking.sorting`); `documentation/en/basics/ranking.html` (which rank profile supplies the score)
- **Review:** Accepted from [sorting](2b68e2b1-dfc9-45a2-abda-ce49e794c843). The default relevance order, the missing-value rules, the space-separated sorting language, and the feature-sort restrictions match those pages. The fallback profile is the one the ranking overview calls a default profile ranking by `nativeRank`. The `sorting.degrading` formula is already in the hits-and-offset answer, so it is not repeated here.

### 39. What do timeout and softtimeout do?

`timeout` is the overall time budget for one query. It covers container processing and content-node processing, and it is one budget for the entire search chain. As a request parameter it is a positive floating-point number with an optional unit. The default unit is seconds. Documented units include `ms` and `s`, and a space before the unit is optional, so one minute is `60 s`. The default is `0.5s`. The same budget can be set in a query profile. In YQL, `timeout` is a literal number of milliseconds and takes precedence over the request parameter.

Container enforcement is cooperative. Most searchers do not check the deadline. A searcher that does heavy work should use `Query.getTimeLeft()`. If a searcher sleeps for twice the timeout, the caller is timed out after 2 × timeout plus some more. A searcher running several chains can set a different `timeout` on each cloned query and can set the timeout used while waiting for them.

Soft timeout is `ranking.softtimeout.enable`, default true, and `ranking.softtimeout.factor`, default 0.7. Content nodes treat timeout times that factor as the point where the latency budget is almost used. They then return the documents recalled and ranked with the first-phase function in the time used. The rest of the budget is for later ranking phases. `timeout=0.5` with `ranking.softtimeout.factor=0.6` gives first-phase ranking 300 ms. The factor is adaptive per rank profile and is adjusted from the time remaining after all ranking phases, unless the query sets `ranking.softtimeout.factor`.

When the query reaches the timeout with soft timeout enabled, Vespa returns the hits matched and ranked so far, HTTP 200, and the reason the result set was degraded. `coverage.degraded.timeout` is true when soft timeout was enabled and not every document could be matched and ranked within the timeout. Coverage is the percentage of the total corpus searched. Under 100 it is an approximation and a lower bound, because nothing is known about nodes that are down. Soft timeout allows coverage below 100% and still above 0% when the query is approaching the timeout. A soft timeout during an approximate nearest-neighbor search can leave no time for matching, in which case no hits are returned.

With `ranking.softtimeout.enable=false`, the container returns HTTP 504 and no results. The container can also return HTTP 504 while soft timeout is enabled, if the timeout is so low that the query never reaches the content nodes, or if input and query processing leave no time to dispatch.

- **Sources:** `documentation/en/reference/api/query.html` (`timeout`, `ranking.softtimeout.enable`, `ranking.softtimeout.factor`); `documentation/en/querying/query-api.html` (Timeout); `documentation/en/performance/graceful-degradation.html` (Soft Timeout, Detection, Early termination of approximate nearest neighbor search); `documentation/en/reference/querying/yql.html` (`timeout`); `documentation/en/reference/querying/default-result-format.html` (`coverage`, `coverage.degraded.timeout`)
- **Review:** Accepted from [timeout](c9a183b3-d4e0-4d35-9b8e-bded103688a4). The `0.5s` default, the 0.7 factor, the HTTP 200 and 504 outcomes, and the ANN early-termination case match those pages. The pages say the factor adapts per rank profile and do not give the adjustment formula. `coverage.degraded.adaptive-timeout` is a different flag: a node produced no result. It is not the soft-timeout flag.

### 41. What does presentation.summary select?

`presentation.summary` is a string whose alias is `summary`. The full name and the alias can both be used in a request or a query profile, and aliases are case-insensitive in requests. Its value is the name of the document summary class used to select fields in results. A document summary class is a named set of fields, with config on which information they should contain, and that class determines the information shown for each document. For example, `presentation.summary=my-short-summary` selects the schema class `document-summary my-short-summary`. The documented default is the default summary class of the schema. The query API and the document-summaries page do not say what happens when the named class is missing.

- **Sources:** `documentation/en/reference/api/query.html` (`presentation.summary`, parameter aliases); `documentation/en/querying/document-summaries.html` (document summary class)
- **Review:** Accepted from [presentation.summary](225dd4af-7a17-47e6-9139-83e247a30687). The alias, the default class, and the class definition match those pages. The Default cell is empty, and the description states the default. A missing class is not described, so that outcome is not stated. What the `default` class contains is already in an earlier answer.

### 40. How does a query choose a rank profile?

A query chooses a rank profile by name with `ranking.profile`. The alias is `ranking`. Both names can be used in the request and in a query profile, and aliases are case-insensitive in requests. If the parameter is omitted, the profile named `default` is used. If the schema does not define that profile, the ranking overview says a default profile ranks by `nativeRank`.

The query API says a backend that does not have the named rank profile uses `default`. Before dispatch, `VespaBackend` rejects the query when the schema does not contain that name. The error is an invalid query parameter: the schema does not contain the requested rank profile. If a request naming an unknown profile still reaches the content node, and a default matcher exists, `Matchers::lookup` falls back to it.

- **Sources:** `documentation/en/reference/api/query.html` (`ranking.profile`); `documentation/en/basics/ranking.html` (Rank profiles); `container-search/src/main/java/com/yahoo/prelude/fastsearch/VespaBackend.java` (`search`); `searchcore/src/vespa/searchcore/proton/server/matchers.cpp` (`Matchers::lookup`); `container-search/src/main/java/com/yahoo/search/query/Ranking.java` (`getProfile`)
- **Review:** Accepted from [rank profile](cf2e62b9-a76c-4052-bcc6-c47dd98b734c). The parameter, the alias, and the omitted-profile default match the query API and the ranking overview. The query API's backend fallback is what the content node does when a default matcher exists. Indexed and streaming search share `VespaBackend.search`, so the container rejection is not limited to indexed search. The `nativeRank` fallback is the case where the request names no profile and the schema has no `default`. It is not the missing-name case.

### 37. What does a Vespa grouping expression do?

A grouping expression describes how the documents that matched a query are grouped and aggregated. It takes that match list as input. Execution is distributed: content nodes run the expression over the matches they hold, and the container merges the results. The cost follows the number of matched documents, not the number of groups returned. Every field the expression reads must be an attribute. Tensors cannot be used.

In YQL the expression is the text after `|`. The same expression string is the `select` query parameter, whose default is no grouping. A JSON select request puts one or more of the same statements in a `grouping` array. `limit 0`, also `hits=0`, returns the grouping output without fetching document summaries.

A request has the form `all(...)`. `group(expression)` splits the current list into groups. `each` runs its statement on every element. `output` emits aggregators such as `count`, `sum`, `avg`, `min`, `max`, `xor`, `stddev`, `quantiles`, `argmin`, and `argmax`, and `summary()` for hits. The basic shape is `all(group(...) each(output(...)))`. A `group` inside `each` nests another level. Several top-level `all(...)` expressions separated by `|` run in parallel. `order` sorts groups, with `-` for descending. It orders groups. Hits inside a group follow the query rank profile. `max` limits how many groups or hits that level keeps. `precision` is how many groups each content node returns for the merge. For a multivalue attribute, elements are handled as separate values. For an array of structs or a map, one document can contribute to more than one group.

When a level omits `max`, Vespa uses `grouping.defaultMaxGroups` for groups and `grouping.defaultMaxHits` for hits. Both default to 10. `max(inf)` requests every group or hit at that level. When `precision` is omitted, it is the effective `max` multiplied by `grouping.defaultPrecisionFactor`, which defaults to 2.0. With no `order` clause the default group order is `-max(relevance())`. That order is unchanged by the merge. `order` on `count`, `avg`, or `sum` can change group order again at merge time. `order` on `max` or `min` does not. `grouping.globalMaxGroups` defaults to 10000. The container rejects a query whose worst-case number of groups plus document summaries may exceed that budget. It can be changed only in a query profile. A grouping without `max` combined with `defaultMaxGroups=-1` or `defaultMaxHits=-1` is rejected unless `globalMaxGroups` is also `-1`.

`groupingSessionCache` defaults to true and applies to expressions that use the default order. With `max` set, aggregates such as `count` can be inaccurate. `quantiles` are approximate. Grouping favors performance, so a non-default `order` can return an approximate set of groups.

The result is a tree of groups, group lists, and hit lists under `root.children`. With `hits=0` and one `all(...)`, that child is a root group whose `id` is `group:root:0`. `root.fields.totalCount` is the number of documents that matched the query.

- **Sources:** `documentation/en/querying/grouping.html` (Grouping and aggregation, ordering, global limit, performance); `documentation/en/reference/querying/grouping-language.html` (order, aggregators, session cache); `documentation/en/reference/api/query.html` (`select`, `grouping.defaultMaxGroups`, `grouping.defaultMaxHits`, `grouping.globalMaxGroups`, `grouping.defaultPrecisionFactor`, `groupingSessionCache`); `documentation/en/reference/querying/json-query-language.md` (grouping); `documentation/en/querying/query-api.html` (grouping result)
- **Review:** Accepted from [grouping](f6a630f8-1565-4d49-abb9-bb8a211f1048). The shape, the 10, 10, 10000, and 2.0 defaults, and the result id match those pages. The guide's sample query profile uses other numbers. Those are examples. `count()` inside `each` is the per-group hit count. `count()` on the group list is a HyperLogLog++ estimate of the number of groups and is independent of `max`. Continuation is left for a later answer.

### 43. What does the trace query parameter do?

`trace.level`, alias `tracelevel`, collects trace information for debugging a query. The default is 0, which is no tracing. A positive value turns tracing on. Higher numbers give progressively more detail on query transformations, searcher execution, and content-node query execution. The reference says tracing is subject to change and gives this guide: 1 is basic tracing in the container; 2 is basic tracing with more detail; 3 is basic tracing with even more detail; 4 includes timing from content nodes; 5 includes more of that timing; 6 includes the query execution plan; 7 includes the query execution tree. The query API guide says to enable tracing with `trace.level=1` or higher, to set `trace.level=2` to inspect the search chain components, and that `trace.level=4` or higher emits the components invoked in the query.

In the guide's example for `/search/?query=blues&hits=3&trace.level=2`, the trace is a top-level `trace` object beside `root`. Its `children` carry `message` text and nested `children`.

`trace.query` is a separate boolean. It defaults to true and controls whether trace messages include the query.

- **Sources:** `documentation/en/reference/api/query.html` (`trace.level`, `trace.query`); `documentation/en/querying/query-api.html` (Query tracing, result example)
- **Review:** Accepted from [trace](203a725a-f333-4149-831c-788ff8bfaee5). The alias, the default of 0, and the level table match the query API reference. The guide's remarks about levels 2 and 4 are kept as that page states them. The example places `trace` beside `root`.

### 44. What does the coverage object in a query response mean?

In the default JSON response, `root.coverage` reports how much of the total corpus was searched. `degraded` is optional and is present when the result is degraded.

`coverage` is the percentage of the total corpus searched. Below 100 it is an approximation and a lower bound, because nothing is known about nodes that are down. `documents` is the number of active documents searched. `full` is whether the full corpus was searched. `nodes` is the number of search nodes that returned results. `results` is the number of result sets merged into the rendered result. `resultsFull` is how many of those merged result sets were full, for example when several sources or clusters contribute.

`degraded` names the reasons. `match-phase` means match-phase degradation occurred. `timeout` means the query timed out before completion. With soft timeout, that is the case where not every document was matched and ranked in time. `adaptive-timeout` means adaptive node timeout stopped waiting and one or more nodes produced no result. `anntimeout` means an approximate nearest-neighbor search stopped early because the ANN timeout was reached. `non-ideal-state` means the content cluster is not in ideal state. The graceful-degradation page calls that case rare.

- **Sources:** `documentation/en/reference/querying/default-result-format.html` (`coverage` and `degraded`); `documentation/en/performance/graceful-degradation.html` (Coverage, Detection)
- **Review:** Accepted from [coverage](58c39d0e-39ca-4d3e-b7e2-7901e7b6c770). The field names and the percentage rule match the result-format table. The result-format page links `adaptive-timeout` to soft timeout. Soft timeout is the `timeout` flag. `adaptive-timeout` is a node that produced no result. The result-format sentence for `non-ideal-state` does not state the polarity. The graceful-degradation page says the flag is true when the cluster is not in ideal state, and that wording is kept. Renderer rules that force `full` or `coverage` in special timeout cases were not re-checked, so they are not stated.

### 48. How does document visit selection work?

A Document V1 visit is a GET that scans the documents in one content cluster and returns them in chunks. The API calls a visit a linear scan. The path is `/document/v1/`, or `/document/v1/<namespace>/<document-type>/docid`. `/group/<group>` or `/number/<number>` limits the visit to that group. `cluster` is required for a root `/document/v1/` visit, and when the target cluster is ambiguous. The root path requires it even when the application has only one content cluster.

`selection` is optional. It is a document-selector string. That language is parsed into a tree that decides whether a document is in the subset. `music and music.artistname == "Coldplay"` selects `music` documents whose `artistname` equals that string. `==` matches only when both sides have the same type and are equal. `music.author and music.length <= 1000` requires type `music` and an existing `author` field, and requires `length` to be set and at most 1000.

By default a visit reads non-global documents in the `default` bucket space. If the path names a document type, the bucket space is deduced from that type. From the root path, `bucketSpace=global` visits global documents.

A JSON visit result always includes `pathId`. It can include `documents` and `documentCount`. Each document has `id` and `fields`. `fieldSet` chooses those fields and defaults to `[document]`, which is all document fields. `documentCount` is the number of visited and selected documents. While more documents remain, the response includes a `continuation` string. Send that string as the `continuation` parameter to get the next chunk. If `continuation` is absent, either there are no more documents, or the visit failed and should stop. A failed response includes `message`.

- **Sources:** `documentation/en/reference/api/document-v1.html` (Visit, `cluster`, `bucketSpace`, `selection`, `continuation`, `fieldSet`, JSON response); `documentation/en/reference/writing/document-selector-language.html` (examples, `==`)
- **Review:** Accepted from [document visit](797a5e05-885e-4725-a7ca-be869c2c2662). The paths, the required `cluster`, the selector examples, and the continuation rule match those pages. JSONL streaming continuations are left out.

### 45. What do the coverage.degraded flags mean?

`root.coverage.degraded` is present when the result is degraded. The graceful-degradation page says the reasons are not mutually exclusive. Soft timeout on some nodes and a node that produces no result can make both `timeout` and `adaptive-timeout` true.

`timeout` is true when soft timeout was enabled and not every document could be matched and ranked within the query timeout. `adaptive-timeout` is true when adaptive node timeout is enabled and one or more nodes fail to produce a result within the timeout. `anntimeout` is true when the ANN timeout was enabled and an approximate nearest-neighbor search stopped early because it reached that timeout. An early stop from an explicit ANN time budget (`ranking.matching.anntimebudget`) is not reported as `anntimeout`.

The graceful-degradation page says `match-phase` is true if the rank profile defines match-phase ranking degradation. Proton sets that bit when the match-phase limiter was used. The graceful-degradation page says `non-ideal-state` is true when the system is not in ideal state, and calls that case extremely rare. In the coverage object that flag is set when the coverage percentage is not 100 and no other degraded-reason bit is set.

- **Sources:** `documentation/en/performance/graceful-degradation.html` (Detection, Early termination of approximate nearest neighbor search); `documentation/en/reference/querying/default-result-format.html` (`degraded`); `searchcore/src/vespa/searchcore/proton/matching/matcher.cpp` (`updateCoverage`); `container-disc/src/main/java/com/yahoo/container/handler/Coverage.java` (`isDegradedByNonIdealState`)
- **Review:** Accepted from [degraded flags](d7da8be8-4653-4b64-a349-d381738c59e6). The timeout, adaptive-timeout, and anntimeout sentences match the graceful-degradation page, including the time-budget exception. The result-format page links `adaptive-timeout` to soft timeout and describes `match-phase` as degradation that has occurred. The match-phase bit follows the limiter in `matcher.cpp`. The non-ideal-state bit follows `Coverage.java`.

### 47. How does a conditional document write work?

A conditional write is a test-and-set on one document. `/document/v1` accepts a `condition` string on single-document Put (HTTP POST), Update (HTTP PUT), and Remove (HTTP DELETE). The string is a document selection. The write is applied only when that condition matches the stored document. Batch update and delete use `selection` to choose which documents to visit.

Pass it as the `condition` query parameter. On Put and Update it may instead be a `"condition"` string in the JSON body. The guide uses `"condition": "music.artist==\"Warmplay\""`. When both are present, the query parameter replaces the body field. Remove has no JSON body on this API, so its condition is the query parameter.

Field references are `documenttype.fieldname`, as in `music.artist` or `music.version < 42`. `and`, `or`, `not`, `true`, `false`, `null`, and the `id` part names are case-insensitive. `and` binds tighter than `or`. Comparisons are `>`, `<`, `<=`, `>=`, `==`, `!=`, glob `=`, and regex `=~`. A bare `doctype.field` means the field is present. Only `==` and `!=` are defined when an operand is null. Any other comparison with null is invalid, and an invalid selection does not match. For arrays and maps, only equality is supported: an array matches if any element equals the other side, and a map matches if a key does. A tensor field can only be compared with null.

If the condition does not match, the API returns HTTP 412 Precondition Failed and does not apply the operation. The guide's body has `pathId`, `id`, and a `message` containing `TEST_AND_SET_CONDITION_FAILED`. A condition on a document that does not exist is also 412. An unconditional Remove or Update of a missing document is 200.

`create: true`, also the query `create=true`, changes conditional Puts and Updates. If the document exists, the condition is tested against the most recent version and the write runs only when it matches. If the document is absent, or the newest version is a tombstone, the condition is ignored and the write is applied. The guide's out-of-order example is `music.version < 42` with `create: true`. If every replica is missing, `create: true` still creates a document even when a condition was given, and that newer timestamp overwrites replicas that reappear later. `create` on a Put that has no condition does not change the write, because an unconditional Put already writes a new version whether or not the document existed. Since Vespa 8.178, `create` may be combined with a conditional Put.

Only field `assign` and field `remove` are idempotent. A resent update can apply `increment` and the other arithmetic and collection operations more than once. Conditional writes are the documented way to get stronger consistency on those updates.

- **Sources:** `documentation/en/reference/api/document-v1.html` (`condition`, HTTP status codes); `documentation/en/writing/document-v1-api-guide.html` (Conditional writes, Create if nonexistent); `documentation/en/writing/reads-and-writes.html` (Updates); `documentation/en/reference/schemas/document-json-format.html` (test-and-set, create); `documentation/en/reference/writing/document-selector-language.html` (operators, null, multivalue, tensors); `vespaclient-container-plugin/src/main/java/com/yahoo/document/restapi/resource/DocumentV1ApiHandler.java` (`postDocument`, `putDocument`, `deleteDocument`)
- **Review:** Accepted from [conditional writes](584fc11d-571c-4730-83af-f6bede98d2c7). The 412 cases, the `create` rules, and the selector limits match those pages. The query parameter replaces a body condition in `DocumentV1ApiHandler`. Imported fields in a conditional mutation, and the internal condition that update-where copies onto each mutation, are left out.

### 46. How does a partial document update work?

A partial update changes one or more fields and updates the index structures for those fields, so the effect is visible in queries. On `/document/v1` it is an update, which is HTTP PUT. The body names the document in `update` and puts one operation object per field under `fields`. Every field can be partially updated by default.

`assign` replaces a field, or one element, using the same value syntax as a put. `null` clears the field. A tensor assign replaces the whole tensor. A struct object replaces the whole struct, and a field path such as `contact.first_name` replaces one member. `field{key}` on a map inserts the key if it is absent and overwrites it if it is present. An array assign replaces the whole array, or an existing index with `field[i]` or `match`. That index must already exist. `field{key}` on a weighted set sets that element's weight and can insert the key.

`add` appends array values in the order given, sets weights on a weighted set, or adds cells on a mapped or mixed tensor. A tensor with only indexed dimensions is rejected. An existing weighted-set key or tensor cell is overwritten. A cell of a bound indexed dimension that is left out is set to `0.0`.

`remove` drops array elements equal to the given values, weighted-set elements, a map key named by a field path, or cells of a mapped or mixed tensor. A dense tensor remove is rejected. The weighted-set example is `{"item 2": 0}` and the map example is `field{key}` with `"remove": 0`.

`increment`, `decrement`, `multiply`, and `divide` change one single-value numeric field. `match` applies an operation to one weighted-set key or one array index. An increment or decrement of a weighted-set key that is not present is ignored unless the field sets `create-if-nonexistent`. `modify` changes tensor cells with `replace`, `add`, or `multiply`. A missing cell is ignored unless `"create": true` on that modify. The default for the new cell is `0.0` for `replace` and `add`, and `1.0` for `multiply`. That flag creates tensor cells. It is separate from document-level `create`.

Field paths name an element inside a composite that is not part of index or attribute data: `map{key}`, `array[index]`, and `struct.field`. Struct updates do not work for index mode.

An index or summary update reads the document store, modifies the field, and writes the document back. For an indexed field the recent changes sit in a lock-free copy-on-write memory index that is later flushed and merged. The change is searchable when the client is acknowledged. Most attribute fields update in memory and skip that read-modify-write. Array of struct, map, predicate, and reference attributes still read-modify-write the document store. A multivalue attribute is read, updated, and written back. Arrays of primitive types, weighted sets, and tensors stay in memory. An array of struct or a map is stored in the document store. Attributes in one client update are applied independently in the search core. `fast-search` also updates an in-memory posting list. Attribute operations are persisted to the transaction log and replayed after an unclean shutdown.

- **Sources:** `documentation/en/reference/schemas/document-json-format.html` (update, assign, add, remove, arithmetic, match, modify, fieldpath); `documentation/en/writing/partial-updates.html`; `documentation/en/reference/schemas/schemas.html` (`create-if-nonexistent`)
- **Review:** Accepted from [partial updates](b3d2714c-ffbd-4745-91ac-37cdc8b782b4). The operators and the attribute read-modify-write list match those pages. Document-level `create` and `condition` are already in the conditional-write answer. The JSON reader's extra limit on an unbound indexed dimension is not on the JSON page, so it is left out.

### 50. What is a query profile type, and how does it constrain a query profile?

A query profile type defines a set of valid, typed values for a query profile. It is optional. A profile selects one with `type`, whose default is no type checking. The file is `[query-profile-type-name].xml` in `search/query-profiles/types`. The root is `query-profile-type`. Optional contents are a description, `<match path="true"/>`, `<strict/>`, and repeatable `field` elements. `inherits` defaults to no inclusion. It is a space-separated list of type ids. If the same field is defined in several inherited types, the first definition in a depth-first, left-to-right search is used. A definition in this type overrides an inherited one.

A field name matches `[a-zA-Z_/][a-zA-Z0-9_/]*`. The type is `string`, `integer` (signed 32-bit), `long` (signed 64-bit), `float`, `double`, `boolean` (`true` or `false`), a tensor type spec, `query-profile`, or `query-profile:[type-id]`. If a profile field is defined in the referenced type, its value must be a valid value of that type. `mandatory` defaults to false. When true, the field must be present in the profile or in the request. `overridable` defaults to true. A query profile field's own `overridable` overrides the type field. `alias` defaults to none, and aliases are case-insensitive.

If `<strict/>` is present, the profile can only contain values explicitly defined in the profile, whether the value comes from a query profile, the request, or programmatically. A profile that inherits a strict profile is also strict. A strict sub-profile can sit in a non-strict profile, and the reverse. For a top-level strict type, the reference says the type should usually inherit the built-in `native` type so built-in parameters can be passed in. That type and the subtypes it references are always available. Non-primitive model objects may still be added when the top-level profile is strict. Primitives must be declared in the strict profile type or wrapped in a model object. Parameters of feature-specific properties such as `select` must be declared explicitly.

The Query API reference says the first four blocks of request parameters are also modeled as query profile types. `native` defines the native execution parameters.

- **Sources:** `documentation/en/reference/querying/query-profiles.html` (type, field types, strict); `documentation/en/querying/query-profiles.html` (file location, built-in types); `documentation/en/reference/api/query.html` (modeled types, `native`)
- **Review:** Accepted from [query profile types](7587a768-6608-4412-8b34-7d6f982712a8). The defaults and the field types match the reference. The guide says a strict base type must inherit a built-in type. The reference says a top-level strict type should usually inherit `native`, and that wording is kept. Neither page says what a non-strict profile does with a field the type does not declare, so that outcome is not stated.

### 54. What does nearestNeighbor approximate:false do?

`approximate:false` does not use the HNSW index. The YQL annotation table says the annotation defaults to true when the field has an HNSW index, and is otherwise always false. With an HNSW index present, false selects exact search. The nearest-neighbor page calls that exact search with perfect accuracy, and says the distance metric is calculated for every document that matches the boolean query filters. The HNSW page calls the same choice brute-force search, and says it is the comparison point for measuring approximate-search accuracy.

Setting `approximate` to false might trigger graceful query degradation, so the timeout may need to be raised. The HNSW page says the default query timeout is 500 ms, and that this is too low for an exact search over many vectors.

Extra threads can reduce latency. Exact search scales close to linearly with the number of threads, and the number of distance calculations does not change when the thread count changes. In the nearest-neighbor guide's one-node example, exact search with `totalTargetHits:10` took about 14 ms and calculated 95,666 distances. The same query with four threads reports a search time of about 8 ms, and about 101 documents were exposed to first-phase ranking.

For exact search, the nearest-neighbor page says per-node `targetHits` is a lower bound: at least that many hits are exposed to first-phase ranking when that many are found and not filtered out, and more may be exposed. The guide says exact evaluation uses a scoring heap and chunked distance calculations, and that a document placed on the top-k heap is exposed to first-phase. The HNSW page says approximate search exposes exactly `totalTargetHits` hits to first-phase, as long as that many are found and not filtered out.

- **Sources:** `documentation/en/reference/querying/yql.html` (`approximate`); `documentation/en/querying/nearest-neighbor-search.md` (exact search, `targetHits`); `documentation/en/querying/nearest-neighbor-search-guide.md` (example timings, scoring heap); `documentation/en/querying/approximate-nn-hnsw.md` (brute force, timeout, `totalTargetHits`)
- **Review:** Accepted from [exact nearest neighbor](056e412a-74b0-4447-b6b6-e61e5ec591cc). The annotation, the distance-for-every-match rule, and the 500 ms warning match those pages. The 14 ms, 8 ms, 95,666, and 101 figures are that guide's example. A later sentence in the same guide says four threads were needed to reach 20 ms. The printed timings are kept. The guide says approximate search exposes exactly `targethits`. The HNSW page says exactly `totalTargetHits`, and that wording is kept. Automatic fallback from approximate search when a filter is selective is not what `approximate:false` does, so it is left out.

### 52. Which settings control an HNSW index on a tensor field?

`index` on a supported tensor field builds an HNSW index. The optional `hnsw` block supplies graph parameters. With no block, the index uses the defaults below. The schema reference lists two parameters, both used while building the graph.

`max-links-per-node` is how many links are selected per HNSW node. The default is 16. HNSWlib calls this `M`. Changing it requires a content-node restart that rebuilds the index.

`neighbors-to-explore-at-insert` is how many neighbors are explored when a document is inserted. The default is 200. HNSWlib calls this `ef_construction`. Changing it requires a restart, and that restart does not rebuild the index.

`distance-metric` sits on the field's `attribute`. It is used to build the graph, to search it, and to produce the distance and closeness rank features. If it is omitted, the metric is euclidean. The reference metrics are euclidean, angular, dotproduct, prenormalized-angular, geodegrees, and hamming. Changing the distance metric, or `max-links-per-node`, requires a restart that rebuilds the index. With dotproduct, the index is built by adding an extra dimension and using a distance similar to prenormalized-angular.

`multi-threaded-indexing` is a boolean in the same block. The schema reference does not list it. When the property is omitted, `HnswIndexParams` uses true.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`hnsw`, `distance-metric`, restart table); `config-model/src/main/java/com/yahoo/schema/document/HnswIndexParams.java` (`multiThreadedIndexing`)
- **Review:** Accepted from [HNSW settings](d3b1f898-22bb-4736-9b4e-b5ba051df5b2). The 16 and 200 defaults and the restart rules match the schema reference. The HNSW guide says both construction parameters require a restart and does not say that changing `neighbors-to-explore-at-insert` skips a rebuild. The reference does, and that wording is kept. How the multi-threaded flag splits work between threads was not re-checked, so that scheduling is not stated.

### 49. What is an imported field, and what can a query do with it?

An imported field is declared on the child schema, outside the document type. It reads one attribute from the global parent identified by a reference. The form is `import field <reference>.<field> as <name> {}`. The reference is an attribute of type `reference<parent-type>`, and its value is the parent document id. A reference can be made only to a global document. On the document element, `global` defaults to false, so the parent type sets `global="true"`. Only attribute fields can be imported. The imported field inherits the parent attribute's properties except `fast-access`. The child uses `<name>`. The name after the dot may itself be an imported field: the parent/child guide imports `campaign_ref.advertiser_name`. The value is taken at query time. If the referenced document does not exist, the imported field has no value. Self-references and cyclic references are not supported. Parent/child is not supported in streaming search, and using it fails deployment.

A query on the child can match, rank, group, and sort on `<name>`. Feature tuning describes searching imported attributes that have `fast-search`. In a rank expression, `attribute(name)` is the value of a tensor or single-value numeric attribute. The rank-feature table lists its default as null, and the description says null/NaN if the attribute is not set. A tensor field is for ranking and nearest-neighbor search and is otherwise not searchable. To return an imported field in hits, name it in an explicit document summary. `matched-elements-only` is supported when the field is imported.

The schema reference adds limits. An array of struct can be imported when at least one struct field has an attribute, every struct field with an attribute has a primitive type, and only those struct fields are visible. A map of struct can be imported when the key has an attribute and at least one struct field has an attribute, those struct fields have primitive types, and only the key and those struct fields are visible. A map can be imported when both key and value have primitive types and attributes. A position or an array of position can be imported when it has an attribute.

Document selections can use simple imported fields, meaning top-level primitive fields, as fields of the child. Complex fields are not supported there. If the parent cannot be retrieved, the selection gets null.

One write to the parent attribute updates that value for the children that import it. A partial update of the reference field requires a read-modify-write to the document store.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`import field`, `reference`, tensor, `matched-elements-only`); `documentation/en/schemas/parent-child.html`; `documentation/en/reference/applications/services/content.html` (`global`); `documentation/en/performance/streaming-search.html`; `documentation/en/reference/writing/document-selector-language.html` (imported fields); `documentation/en/reference/ranking/rank-features.html` (`attribute(name)`)
- **Review:** Accepted from [imported fields](84cc5411-d7ba-4a4a-be91-b2b43657b77c). The syntax, the restriction table, and the selection rules match those pages. The import body is shown only as `{}`. No page states what a write to the imported name does, so that outcome is not stated. Nearest-neighbor search on an imported tensor is not stated separately from the general tensor rule.

### 51. How does streaming search differ from indexed search?

Streaming search is selected per document type in `services.xml`, on the content cluster's document element, with `mode="streaming"`. The other modes are `index` and `store-only`. Indexed mode builds indexes so queries stay cheap. Streaming search is for a corpus split into many subsets where each query searches one subset, or a few. Vespa stores the raw document data, compressed, and searches by streaming it. It is a visit operation, and no indexes are required. Attributes are stored on disk as well. The streaming page says the only memory needed is 45 bytes per document, regardless of document content. A group that is occasionally large is automatically sharded over multiple content nodes, and those shards are searched in parallel. Using streaming and indexed mode in the same cluster is discouraged.

`streaming.groupname` sets the group to stream through, the group named by `g=<groupname>` on the document id. `streaming.selection` restricts the search with a document selection. A selection of the form `id.group == "foo" or id.group == "bar" or ...` streams only those groups. Any other selection streams through all groups, which the query reference calls very costly.

A schema used in indexed mode can in most cases be used unchanged. Streaming search uses the same implementation of matching, ranking, grouping, and sorting. A field must still be an index or an attribute to be available for those uses, and the default match setting is the same as in indexed mode. Match settings for text fields can also be set at query time. A field with `indexing: index` supports suffix and substring matching. Those match modes are available only in streaming search. Substring can be set on the query without making it the field default.

Grouping works as in indexed search, with two additions. Because streaming search looks at every document matching the group name or selection, `where(true)` groups over all of those documents, including documents that do not match the query. Relevancy is not calculated for those groups. `docidnsspecific()` returns the document id without the namespace.

Streaming search does not use the linguistics module while feeding. The string fields of each streamed document are tokenized and normalized while the search runs, and query terms are normalized the same way. Stemming is not supported. The schema reference says, separately, that normalizing and tokenization are not supported for attribute fields, and that queries in attribute fields are not normalized or stemmed.

Because there are no indexes, content nodes do not collect term statistics or average field length. Term significance should come from a global significance model for text-matching features that benefit from it, including `bm25`, `nativeRank`, `nativeFieldMatch`, `nativeProximity`, and `fieldMatch`. A local significance model is not available in streaming search, and significance values are then 1. `num_docs_indexed` returns 1. `firstPhaseRank` always returns its default, which the rank-feature table lists as the maximum double value. For `bm25`, the configured `averageFieldLength` is 100 in streaming search, because the average is not calculated automatically. HNSW indexes are not supported, so a nearest-neighbor search is always exact. These approximate-search parameters have no effect: `post-filter-threshold`, `approximate-threshold`, `filter-first-threshold`, `filter-first-exploration`, `exploration-slack`, and `target-hits-max-adjustment-factor`.

Parent/child is not supported, and using it fails deployment. Predicate fields can exist as summary-only fields and are not searchable. URI fields are handled as regular string fields and do not support URI search.

- **Sources:** `documentation/en/performance/streaming-search.html`; `documentation/en/reference/applications/services/content.html` (`mode`); `documentation/en/reference/api/query.html` (`streaming.groupname`, `streaming.selection`); `documentation/en/reference/schemas/schemas.html` (substring, suffix, attribute fields); `documentation/en/ranking/significance.md`; `documentation/en/reference/ranking/rank-features.html` (`num_docs_indexed`, `firstPhaseRank`); `documentation/en/reference/ranking/rank-feature-configuration.html` (`averageFieldLength`)
- **Review:** Accepted from [streaming vs indexed](c4d0d33b-ebe1-4620-9cb1-2e91155dfbd2). The 45-byte figure, the selection rule, and the ranking defaults match those pages. The attributes page calls an attribute an in-memory structure. The streaming page says attributes are stored on disk, and that wording is kept. The streaming page also says that since Vespa 8.287 the document-processing setup can be disregarded, while a later paragraph still says indexing statements are not executed by default. That indexing-statement behavior is not stated.

### 53. How do targetHits, totalTargetHits, and hnsw.exploreAdditionalHits limit nearest-neighbor search?

`totalTargetHits` is required on `nearestNeighbor` and has no default on that operator. The annotation catalog's default of 100 is for `wand` and `weakAnd`. It is the number of hits to expose to first-phase ranking across the content nodes in the group. YQL says more or fewer hits may be produced. Each node uses `max(minTargetHits, ceil(totalTargetHits × that node's share of active documents))`. `minTargetHits` defaults to 100. `targetHits` sets the per-node target directly. Its catalog default is 100, and YQL says to prefer `totalTargetHits`. The nearest-neighbor page still says `targetHits` is required. For exact search, that page says `targetHits` is a lower bound per content node.

`hnsw.exploreAdditionalHits` is how many extra nodes in the HNSW graph are explored before the best hits are selected. The operator table says this is in addition to `totalTargetHits`, and its default is 0. A greater value improves approximate-search accuracy and does more distance computations. In the annotations catalog, the Default cell for this annotation is empty. The schema reference and the `ranking.matching` query parameters do not include this annotation. `exploration-slack` is a different rank-profile setting and defaults to 0.0.

The search adds the extra count to the per-node target, `k + explore_additional_hits`, where `k` is the share-based target after the `minTargetHits` floor. Approximate search exposes exactly `totalTargetHits` hits to first-phase when that many are found and not filtered out. With pre-filtering, `geoLocation` and `predicate` are evaluated after the approximate neighbors are retrieved, and that can expose fewer hits than `totalTargetHits`. The nearest-neighbor guide says post-filtering without raising `totalTargetHits` also returns fewer hits.

- **Sources:** `documentation/en/reference/querying/yql.html` (`totalTargetHits`, `hnsw.exploreAdditionalHits`); `documentation/en/querying/approximate-nn-hnsw.md` (exposure, `geoLocation`, `predicate`); `documentation/en/querying/nearest-neighbor-search.md` (`targetHits`); `documentation/en/querying/nearest-neighbor-search-guide.md` (post-filtering); `searchlib/src/vespa/searchlib/queryeval/nearest_neighbor_blueprint.cpp` (`find_top_k`)
- **Review:** Accepted from [targetHits](d16a5dd2-27ea-4c74-a079-ebe9eb90c0d8). The operator-table default of 0 and the empty catalog Default cell match the YQL reference. The guide says approximate search exposes exactly `targethits`. The HNSW page says exactly `totalTargetHits`, and that wording is kept. The extra exploration is added to the per-node `k` in `nearest_neighbor_blueprint.cpp`, which is the share-based target after the `minTargetHits` floor.

### 58. What is an embedder, and how does a schema use it?

An embedder produces embedding vectors inside Vespa. Clients can send the vectors themselves, or send text and let the component map it. The component is declared in `services.xml`, inside a container element, with an id and a type. Components are shared and can be used from more than one schema. You can write your own, or use one of the kinds the embedding guide documents: `hugging-face-embedder`, `bert-embedder` (deprecated there, in favor of the Huggingface embedder), `colbert-embedder`, `splade-embedder`, `voyage-ai-embedder`, `openai-embedder` (since 8.678), and `mistral-embedder` (since 8.678). The page does not name a default kind.

A schema calls it with the indexing expression `embed`. The generated tensor field sits outside the document block. The guide's pattern is `input title | embed embedderId | attribute | index`. Arguments are space-separated. The first is the component id, and further arguments are passed to that implementation. If only one embedder is configured, the id may be omitted. The indexing-language reference types the input as a string and the output as the tensor type required by the next expression, as far as that embedder supports it. The guide also shows an array of strings as input, and that example stores a rank-two tensor. The indexing script runs as the document is fed to the search cluster, and again when the document is reindexed.

The same component can be used at query time. Where the request would pass a tensor, it can pass text, such as `input.query(q)=embed(myEmbedderId, "...")`. Single or double quotes are allowed. With only one embedder, the id and the quotes may be omitted, and the text may be a parameter, as in `embed(@text)`. Query input tensors must still be declared in the rank profile. A Huggingface embedder may prepend different text for a query and a document. The VoyageAI embedder sets its input type from whether the call is feed or query processing.

- **Sources:** `documentation/en/rag/embedding.html` (embedders, schema and query syntax); `documentation/en/reference/writing/indexing-language.html` (`embed`, indexing script)
- **Review:** Accepted from [embedders](9dbce2c1-7a10-41f4-9bc4-d6ce8a485324). The component declaration, the `embed` expression, and the listed kinds match those pages. Example model names and dimensions are examples. The indexing-language sentence about a repeated chunk expression being computed once is on `embed` as well as on `chunk`. It is not stated as a separate embedder rule.

### 57. How does a rank profile evaluate an ONNX model?

An ONNX model is declared as `onnx-model [name]` in a rank profile or in the schema. The reference says to prefer the rank profile. The body requires `file`, a path relative to the application package that contains the schema. The ranking page's example is `files/my_model.onnx`. The ranking expression uses the declared name.

Bind each ONNX input with `input "<onnx-input-name>": <source>`. The source is `attribute(field_name)`, `query(query_param)`, `constant(name)`, or a rank-profile function name. Inputs must be tensors. Scalars are not supported. Dimension names start at `d0` and then `d1`, `d2`, and so on. Query tensor types are declared in the profile's `inputs` block. Map an output with `output "<onnx-output-name>": <vespa-name>`. If no output is defined and the rank feature does not refer to one, the schema reference says the first output defined in the model is used. The ranking page says that if the output mapping is omitted, the first output in the ONNX file is used.

The expression calls the `onnx` rank feature. The ranking page also names it `onnxModel`. The form is `onnx(my_onnx_model).output_name`. The result is a tensor named `d0`, `d1`, and so on. The rank score must be one scalar, so the expression reduces it, as in `sum(onnx(my_onnx_model).output_name)`, or reads one cell, as in `onnx(my_onnx_model).output_name{d0:0,d1:0}`. During ONNX inference in ranking, Vespa uses batch size 1.

The ranking page's example evaluates the model in `first-phase`, and says these models are in general more suitable in `second-phase` or `global-phase`. For ranking, the model must be self-contained, with no external data files, and below 2 GB. `gpu-device` must be an Nvidia CUDA-enabled GPU, and only models used in global-phase can use GPU acceleration.

- **Sources:** `documentation/en/ranking/onnx.md` (inputs, `onnx`, batch size, size limit); `documentation/en/reference/schemas/schemas.html` (`onnx-model`, `gpu-device`)
- **Review:** Accepted from [ONNX](4260ed9c-434e-417d-afcc-f9e33c3de83a). The file path, the input sources, and the GPU limit match those pages. The schema reference only names the `onnx` rank feature. `onnxModel` is the ranking page's alias. The unnamed-output rule follows the schema reference. Thread counts and `execution-mode` have no defaults in that table, so they are not stated.

### 55. What does global-phase ranking do, and what is its rerank-count?

Global-phase is an optional rank-profile phase. If the block is absent, it is not run. When configured, it re-ranks in the stateless container after hits from the content nodes are merged. The candidates are the hits scored by the first-phase expression, or by the second-phase expression when one is specified. It can be used instead of second-phase or in addition to it.

`rerank-count` is how many of those hits are re-ranked. The default is 100, applied to one schema at a time, so a query that searches several schemas may re-rank 100 hits per schema. The phased-ranking page calls those the 100 globally best hits for that schema. A query can override the count with `ranking.globalPhase.rerankCount`.

The block's expression is the global-phase ranking expression. The phase is optimized for ONNX models and is typically used for large models such as cross-encoders. Large expressions that are not ONNX models, including xgboost and lightgbm, and sub-expressions that need a lot of vector data, are more efficient in second-phase on the content nodes. A function listed in `match-features` is evaluated on the content nodes so the global-phase expression can reuse it.

The expression may combine scores with cross-hit normalization over only the hits this phase re-ranks. `normalize_linear(x)` takes a rank feature or a function name and scales it to [0, 1] as `(input - min) / (max - min)`. `reciprocal_rank(x)` and `reciprocal_rank(x, k)` sort the inputs, give the highest rank 1, and return `1.0 / (k + rank)`. `k` defaults to 60.0. `reciprocal_rank_fusion` takes at least two arguments and is the sum of `reciprocal_rank` on each. Each input is computed for every hit being re-ranked, then normalized, and the global-phase expression uses the normalized values.

If `rank-score-drop-limit` is set, hits whose global-phase rank score is less than or equal to that value are dropped. It is unset by default and can also be set on the query. The reference calls this score possibly a re-scored rank score. Sort features cannot use or depend on cross-hit normalization, `firstPhaseRank`, or `firstPhaseMax`.

- **Sources:** `documentation/en/ranking/phased-ranking.html` (global-phase, cross-hit normalization); `documentation/en/reference/schemas/schemas.html` (`global-phase`, `rerank-count`, `rank-score-drop-limit`, `sort-features`)
- **Review:** Accepted from [global-phase](e1f9b721-6b07-471b-918d-eb16b31ee9a7). The default of 100 per schema and the normalizer formulas match those pages. Neither page says the global-phase expression replaces the first- or second-phase score for hits outside the count. The drop-limit text says "possibly a re-scored rank score" and links to the global-phase section, which does not define that re-score. Example counts such as 200 are examples.

### 60. What does the linguistics pipeline do to a string field at feed time and at query time?

In indexed mode, a string field with `indexing: index` is processed when the document is written and again when a query term targets that field. The linguistics page lists the operations as tokenization, then normalization, then stemming or lemmatization. Text matching shows the generated indexing script for a default indexed string field as `tokenize normalize stem:"BEST"`. The resulting terms are added to the index. The content node stores those terms and does not store the language. A query is processed in a similar fashion, usually with the same linguistics profile, so the same text is meant to produce the same terms. Streaming search is the exception: it does not stem, and it tokenizes string fields at search time.

At feed time, the language is the one set earlier in the indexing script with `set_language`. If none has been set when the field is tokenized, Vespa detects it from that field's text. Detection is per field. Fields with little text default to English. On the OpenNLP page, tokenization removes non-word characters and splits the string on each word boundary. Normalization maps accents to the same form in documents and queries, using `java.text.Normalizer`, and it preserves case. The schema reference says the default is to normalize. Stemming is symmetric: words are converted to stems both when indexing and when searching, so "reports" is indexed and searched as "report".

At query time, the language is detected unless `model.locale` or a `language` annotation sets it. The linguistics page says that with the current 0.02 confidence cutoff, queries with 3 terms or fewer default to English. The content nodes evaluate the processed query, and it matches as expected only when the document and the query produced the same terms. A field can name one linguistics profile for indexing and another for searching. Without that split, both sides use the same processing.

The default linguistics implementation is OpenNLP. Other languages fall back to English. English uses the kStem stemmer by default. OpenNLP language detection is used by default even with a different linguistics implementation.

- **Sources:** `documentation/en/linguistics/linguistics.html` (order, language detection); `documentation/en/linguistics/linguistics-opennlp.html` (OpenNLP, kStem, normalization); `documentation/en/querying/text-matching.html` (`tokenize normalize stem:"BEST"`); `documentation/en/reference/schemas/schemas.html` (normalizing)
- **Review:** Accepted from [linguistics](19b28e02-df46-42c7-af63-22e1b765e60a). The feed-time order follows the text-matching script and the linguistics page's list. A later sentence says the detector runs if no language parameter is used, or if the query terms are annotated. The overview says detection runs unless `model.locale` or a `language` annotation is set, and that wording is kept. One reindex example prints `stem:"SHORTEST"` for a field with no stemming setting. The stemming default is `best`, and the text-matching script prints `stem:"BEST"`. The OpenNLP detector configuration example is not the 0.02 cutoff, so that config number is not stated.

### 56. What does match-phase degradation do, and how does a diversity block change which documents it keeps?

A rank-profile `match-phase` block limits which matches are exposed to first-phase ranking, keeping one end of a quality attribute. After collecting a reasonable amount of hits, Vespa estimates the hit count. If the estimate is higher than the node's share of `total-max-hits`, an extra limitation is added so only the preferred end of the attribute can become hits. The kept subset is sized so the query is estimated to produce that per-node share. Documents with no value of the attribute are taken as 0. Hits already collected for the estimate mean the number returned is usually higher than `total-max-hits`. An uneven distribution can return fewer. The same limit reduces grouping and the reported total hit count. Queries that match few documents can become slower. A selective filter can be much slower, because matching walks documents in internal document-id order.

`attribute` is the quality attribute. It must be single-value numeric with `fast-search`. The reference says there is no default. `order` defaults to `descending`, which prefers high values. `ascending` prefers low values. `total-max-hits` is the total hits the match phase should produce across the nodes in the group. The reference says to prefer it over `max-hits`, and that it should be larger when the attribute correlates poorly with the first-phase function. The reference does not give it a number. On the query API, `ranking.matchPhase.totalMaxHits` set to 0 disables match-phase early termination, and that Default cell is empty. `max-hits` is what each content node should attempt to produce. The reference does not give it a number. For diversity, that per-node max is the node's share of `total-max-hits`.

A `diversity` block names another attribute used to diversify the matches that match-phase passes to first-phase. That attribute must be a single-valued numeric, string, or reference. The phase still returns no more than the per-node max, and the result is guaranteed at least `min-groups` unique values when those values exist. A document is a candidate while the phase has not yet produced max-hits documents and that document's group has not yet reached max-hits divided by `min-groups`. The reference does not give defaults for the diversity attribute or for `min-groups`. The same block also diversifies from first-phase to second-phase when a second phase is configured. Query `ranking.matchPhase` parameters override the rank profile.

`max-filter-coverage` is not in the schema match-phase table. An example that sets it to 1.0 does not define it. Automatic sorting degradation is a different path: when the primary sort key is a single-value numeric attribute with fast-search, `sorting.degrading` can also set a match-phase maxHits.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`match-phase`, `diversity`); `documentation/en/performance/graceful-degradation.html` (Match phase degradation); `documentation/en/reference/api/query.html` (`ranking.matchPhase`)
- **Review:** Accepted from [match-phase](28134315-01b8-4595-bee1-0c10772017c7). The trigger, the descending default, and the diversity candidate rule match those pages. The schema compiler initializes `max-filter-coverage` to 0.2. That is not a reference default, so it is not stated. The coverage flag is already in an earlier answer.

### 59. In indexed search, where does Vespa get term significance, and do BM25 and weakAnd read the same value?

Significance is a measure of how rare a term is. The significance page says it is often calculated as inverse document frequency, `IDF(t, N) = log(N / n_t)`, where `N` is the number of documents in the collection and `n_t` is the number that contain the term. A significance model supplies `n_t` for each term and `N` for the collection. The same page says variations of IDF are used in `bm25` and `nativeRank`. A significance annotation is used instead of the computed IDF. The BM25 page says to set that IDF as the significance annotation when every content node should share one IDF.

Indexed search otherwise uses a local significance model. A local model is node-specific. For string fields indexed with `bm25` or `nativeRank`, each content node builds it from the documents on that node. The significance page says that for each query term, the document frequency is computed by aggregating the per-field document frequencies across all fields being searched. The same term can have different significance on different nodes. Those counts change when documents are added, when the cluster redistributes documents, and when grouped distribution runs the query on another group.

A global model replaces those node-local counts with values shared across nodes. They do not change when new documents are added. The page lists three ways to supply them: significance or document frequency on the query, the same values set by a searcher, and models declared in `services.xml`. For a services.xml model, the rank profile must set `significance { use-model: true }`. That model applies to query terms that do not already have significance values from the query. The query form is `documentFrequency: {frequency, count}` or a `significance` number.

BM25 and weakAnd start from document frequency and then differ. BM25 uses its IDF variation of the frequency. `queryTermDocumentFrequency` exposes the significance-model override when a model is present, otherwise the local content-node statistic, which the rank-feature page calls the same value BM25 uses. For a term that searches several fields, that feature's cell holds the frequency for the named field. `term(n).significance` is a normalized number between 0.0 and 1.0. With no annotation, the fallback is Robertson-Sparck-Jones weighting, logarithmic from 1.0 for rare terms, defined as a document frequency of 0.000001 or less, down to 0.5 for a term that occurs in every document. The weakAnd page calls that corpus calculation a formula loosely based on inverse document frequency. A significance annotation is the case where both are given the same number: BM25 uses it instead of the computed IDF, and weakAnd uses it as the term's significance.

Rank-profile `weakand` pruning uses content-node-local document frequencies. A global significance model has no effect there.

- **Sources:** `documentation/en/ranking/significance.md`; `documentation/en/ranking/bm25.html`; `documentation/en/ranking/wand.html`; `documentation/en/reference/ranking/rank-features.html` (`term(n).significance`, `queryTermDocumentFrequency`); `documentation/en/reference/schemas/schemas.html` (`weakand`)
- **Review:** Accepted from [significance](c35831ab-e519-4d96-841b-af4231ea77fc). The IDF quote, the local and global models, and the `use-model` switch match the significance page. That page says there are two ways to provide a global model and then lists three. The three listed ways are kept. The significance page aggregates document frequency across every field being searched. `queryTermDocumentFrequency` keeps a per-field frequency. Both statements are kept. Streaming search, where significance is 1, is already in an earlier answer.

### 64. What does reindexing do, and which schema changes require it?

Reindexing re-runs a content cluster's indexing chain on documents Vespa already stores. A component in each content cluster visits the indicated document types and re-feeds the document fields through that cluster's indexing chain. Derived fields the pipeline produces are recomputed. It runs one document type at a time, in parallel across content clusters, and can run while feeding and serving continue. A fraction of concurrent writes can see higher latency. General throughput is unchanged. Until it finishes, affected fields can be empty or hold annotations that do not match query processing. On Vespa Cloud it is enabled and started automatically on deployment. On self-managed Vespa it starts after reindexing is marked ready and the application is deployed again.

The schema reference requires reindexing of all documents for these changes:

- Changing the index aspect of a document field. Only documents fed after the index aspect was added have annotations and are present in the reverse index. Only documents fed after it was removed avoid disk bloat from unneeded annotations.
- Switching stemming or normalizing on or off. That changes the annotations produced for an indexed field. Serving still works if this is skipped, but recall is undefined, because the index was produced with a different setting than the one used to stem or normalize the query terms. That warning says "re-feeding" even though the row is in the reindexing table.
- Adding, changing, or removing a field's match settings, for example `match: word`. Serving still works if reindexing is skipped, but recall is undefined, because the index was built with one match mode and queries use another.
- Adding or removing a new non-attribute document field from a document summary. The body only spells out the add: an index or summary field with no attribute, under a new name in a summary class, using `source`.
- Adding a fast-search map field to a map or array field. The reference treats that as adding a synthetic field outside the document, so reindexing has to fill it.

- **Sources:** `documentation/en/operations/reindexing.html` (visit, indexing chain, one document type at a time); `documentation/en/reference/schemas/schemas.html` (changes that require reindexing)
- **Review:** Accepted from [reindexing](997a55d3-b359-4d3e-aa86-f6bb38ca6859). The five rows match the schema reference. The stemming warning says "re-feeding" inside the reindexing table, and that wording is kept. The summary row's title includes removal. Its body only describes adding a field through `source`. The operations page also names indexing-script edits and a content cluster's document indexing mode as pipeline changes reindexing covers. Those are not rows in the schema table. The schema page says a change not listed in the earlier sections should be treated as a re-feed, so those two are not stated as required reindexing. Attribute `fast-search`, `fast-access`, and the HNSW restart rows are already in earlier answers.

### 61. What does n-gram indexing do, and which match modes use it?

N-gram indexing is the field match setting `gram` on a string field with `index`. `text` is the default match mode for a string field with `index`. `gram` is valid with `index`. The field text is split into subword tokens of length `gram-size`, and that same tokenization is used in the index and in queries to the index. With the default gram size 2, the schema reference tokenizes `"hi blue"` to `"hi bl lu ue"`.

`gram-size` is a positive, nonzero number. The default is 2. A block that sets `gram-size: 3` is an example. The text-matching page shows `gram-size: 2` only inside an example and does not state a default.

The schema reference describes `gram` mainly as an alternative to CJK segmentation. Recall typically goes up and precision goes down. Proximity in ranking may limit how much that precision drop matters. Grams cost more than other matching methods because indexes and queries contain more terms, and those terms repeat the same letters. CPU-intensive CJK segmentation is avoided. The same page says grams may also be used for substring matching in general. The text-matching page names the same two uses: CJK text that has no spaces, and substring matching in text indexes.

By default, Vespa combines the grams it creates from query text into an AND item, so every gram must match. The query parameter `gram.match` overrides that. It names a composite query item: `all` (default), `any`, `weakAnd`, `phrase`, `near`, or `onear`. The schema reference does not mention `gram.match`.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`gram`, `gram-size`, `text`); `documentation/en/querying/text-matching.html` (N-Gram match, `gram.match`)
- **Review:** Accepted from [n-gram](ba4e4a6b-487f-4abe-8183-e1a2e8044085). The default gram size 2 and the `"hi blue"` tokenization match the schema reference. `gram.match` default `all` matches the text-matching page. That page's example says any query containing at least two tokens from `"滿腦子的夢想"` matches. The same section says query grams are ANDed by default, so that sentence is not stated as the matching rule. The match introduction says normalization and lowercasing apply for `text`, `word`, and `exact`. It does not say whether a `gram` field gets that treatment. Streaming `substring` and `suffix` are already in an earlier answer.

### 66. What is a predicate field, and how does a query match it?

In indexed search, a predicate field stores a boolean constraint that the query's concrete attribute values must satisfy. The fed value is a string, such as `gender in ['male'] and age in [30..40] and income in [200..50000]`. The schema reference marks Index as not supported. With `indexing: attribute`, the value is kept in memory in a variable-size binary format optimized for application during query evaluation. The summary value is that string added as-is. Predicate fields are not supported in streaming search on the schema reference and the predicate guide. Streaming search, where a predicate field can exist as a summary-only field and is not searchable, is already in an earlier answer.

The field's `index` block must set `arity`. The schema reference marks it mandatory for a predicate field and gives no numeric default or maximum. A low arity makes a smaller index and requires more query terms. A high arity makes a larger index and fewer query terms. The shared `arity: 2` is an example. Optional `lower-bound` and `upper-bound` restrict range-attribute values. Queries with values outside that range are rejected. No default bounds are given. Changing the bounds requires the index to be rebuilt. `dense-posting-list-threshold` defaults to 0.40. The valid range is (0, 1].

A query matches with the YQL+ operator `predicate(field, attributes, rangeAttributes)`. The second argument maps regular attributes, each a string with one or more values. The third maps range attributes, each one integer, written in the examples with an `L` suffix such as `20L`. `hobby in [Music, Hiking]` is true if the query assigns `hobby` to either value, or both. Range bounds are inclusive: `age in [10..15]`, or an open end such as `age in [10..]`. `and`, `or`, and `not` combine tests. The expression `true` always matches. `false` never matches. Example: `where predicate(predicate_field, {"gender":"Female"}, {"age":20L})`.

- **Sources:** `documentation/en/schemas/predicate-fields.html` (constraint language, `predicate()`, arity, bounds, default 0.40); `documentation/en/reference/schemas/schemas.html` (predicate type, arity mandatory); `documentation/en/reference/querying/yql.html` (`predicate()`)
- **Review:** Accepted from [predicate fields](249b8932-8393-42db-9e23-8438709ac255). The in-memory attribute format, the mandatory arity, and the 0.40 default match those pages. The predicate guide writes an empty attribute map as `{}`. The YQL reference says an empty map cannot be parsed and that `0` must be used instead, so neither form is stated. The guide's first document requires `age`, and the query printed beside it does not supply `age`. No rule for an omitted attribute is stated, so that pair is not claimed as a match. Subquery bitmaps are omitted. No predicate-expression size limit is documented.

### 65. What is the difference between adding a field and changing a field's type?

Adding a field is in the "Valid changes without restart or re-feed" table. Changing a field's data type or collection type is in the "Changes that require re-feed" table. That re-feed table also has a row "Change a tensor attribute's tensor type," and that cell has no description.

For an added field, the reference says to add it as index, attribute, summary, or any combination. Existing documents implicitly get the new field with no content. Documents fed after the change can specify the new field. If the field has existed with the same type earlier, old content may or may not reappear. The procedure for that table is `vespa prepare`, then `vespa activate`. The change takes effect immediately.

For a data-type or collection-type change, existing documents no longer have any content for that field. Populating it means re-feeding the existing documents using the new type. There is no automatic conversion from the old type. If the re-feed is skipped, serving works, and searching this field will not give any results. The procedure is `vespa prepare`, whose output names the re-feed, then stop feeding and wait until it finishes, `vespa activate`, then re-feed all documents. Until the re-feed is complete, affected fields will be empty or have potentially wrong annotations that do not match query processing.

The reference's example changes `f1` from `string` to `int`. `vespa prepare` warns that document type `test` in cluster `mycluster` must be re-fed because field `f1` changed data type from `string` to `int`.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (valid changes without restart or re-feed; changes that require re-feed)
- **Review:** Accepted from [field changes](8f81f24a-295e-4b66-9821-0e03c435b63b). The no-content rule for an added field and the re-feed rule for a type change match those tables. A rename has no row of its own. The re-feed section says an unlisted change should be treated as a re-feed, and both adding and removing a field are listed in the no-restart table, so a rename is not assigned to either table. The remove-field row says the field data is not completely removed from the search node. That sentence stays with removal. The tensor-type row does not say what existing tensor values become.

### 63. What is a document processor, and when does it run?

A document processor is a container component that extends `com.yahoo.docproc.DocumentProcessor` and implements `process()`. It reads and modifies document operations. The chain is declared in `services.xml` under the container's `document-processing` element. The content cluster's `documents` / `document-processing` element selects the container cluster and chain used for index preprocessing. That element's `chain` defaults to `indexing`, and a chain that replaces it must inherit `indexing`. If a chain with id `default` exists, it is included in the default feed route and runs before the indexing chain. The document-processing guide calls a chain an ordered list, and it also says the execution order inside a chain comes from ordering constraints rather than an explicit sequence.

When the container receives a document operation, it creates a `Processing` and adds the `DocumentPut`, `DocumentUpdate`, or `DocumentRemove` operations to `Processing.getDocumentOperations()`. `process()` should loop through that list. The default feed route delivers the operation to the container's indexing chain, shown in the routing trace as `container/chain.indexing`, and that trace then sends it to the content cluster's distributor and on to storage. The processor therefore runs in the container before the operation reaches the content cluster. A processor annotated `before` `indexingStart` or `after` `indexingEnd` is placed in that same container chain.

The indexing script runs in that container chain as well. As a document is fed to a search cluster, it passes through the corresponding indexing cluster, which runs the script, and the same run happens again on reindex. `IndexingProcessor` in `chain.indexing` annotates the document from that script. A custom document processor is another component in this chain. It is not itself the indexing script.

- **Sources:** `documentation/en/applications/document-processors.html` (component, `Processing`, `default` chain); `documentation/en/reference/applications/services/content.html` (`document-processing`, default chain `indexing`); `documentation/en/writing/document-routing.html` (default route, `chain.indexing`, feed trace); `documentation/en/reference/writing/indexing-language.html` (indexing script)
- **Review:** Accepted from [document processors](85973592-e0ba-4109-8335-2127284524ca). The `indexing` default, the `default` chain before indexing, and the container-then-distributor trace match those pages. The indexing script is applied by `IndexingProcessor` inside the container chain, so it is not stated as a stage after the document reaches the content cluster. The content reference says an omitted cluster is the container cluster on the content node. The routing page says that if no `document-processing` is configured, it defaults to a container cluster named `default`. Neither default cluster name is stated. Progress codes, asynchronous retry, and a later `vespa-visit` reprocessing pass are omitted.

### 62. What is a searcher chain, and which chain runs by default?

A searcher is a search-container component, usually deployed in an OSGi bundle, that extends `com.yahoo.search.Searcher` and implements `Result search(Query query, Execution execution)`. The container builds a `Query` for the request and calls `search()` on the first searcher. That searcher continues by calling `execution.search(query)`. The `Result` is returned up the call chain, and the container turns it into the response.

A search chain is a configured list of searcher instances with an id. Declare it in `services.xml` under the container `search` element. `inherits` and `excludes` are optional space-separated lists. The chain includes the components of the inherited chains, drops the excluded names, and adds the searchers nested in the chain. A nested `<searcher id="...">` is a definition. If `class` is missing, it is copied from `id`. If no bundle is specified, the search reference says it defaults to the bundle containing the searchers bundled with Vespa. A searcher defined outside the chain is referenced with `idref`. Searchers declare `provides`, `before`, and `after` constraints. The chain element is a set ordered by those dependencies.

The chaining page names two built-in chains. `native` is a basic search chain and is always present. `vespa` inherits `native` and adds searchers for installations that contain Vespa backends. The searchers-page example is a chain with `id="default"` and `inherits="vespa"`. That page says a chain with that id is used when no other chain is explicitly specified. The chaining page also says custom chains will usually inherit `native`. Its examples, and the searchers page, declare `inherits="vespa"`.

A request selects a chain with `searchChain`, or by setting that property in a query profile. The query API gives `searchChain` the default value `default` and the form `name:version`, where the version can be omitted or partially specified. The chaining page says that if no chain is selected, the chain called `default` is used, and that if no chain called `default` has been configured, the chain called `native` is used. `SearchHandler` looks up `default` when the `searchChain` property is absent. If that chain is not registered, its fallback name is `vespa`. An explicit name that is not registered does not use that fallback. The handler returns the invalid query parameter `No search chain named '<name>' was found`.

- **Sources:** `documentation/en/applications/searchers.html` (searcher, `search()`, chain `default`); `documentation/en/applications/chaining.html` (`native`, `vespa`, `searchChain`); `documentation/en/reference/applications/services/search.html` (`class`, bundle, `idref`); `documentation/en/reference/api/query.html` (`searchChain`); `container-search/src/main/java/com/yahoo/search/handler/SearchHandler.java` (`resolveChain`)
- **Review:** Accepted from [searcher chains](485a639e-da27-4c2c-91b2-c94c3ad92aa5). The searcher method, the `default` parameter value, and the built-in `native` and `vespa` chains match those pages. The chaining page says the fallback is `native`. `SearchHandler` falls back to `vespa`, and only when the property is absent. Both statements are kept. Config also creates a built-in chain named `vespaPhases`, which those pages do not name, so it is not part of the documented pair. The processing-chain reference also says an incoming request invokes the chain named `default`. Trace levels are omitted.

### 67. What does a grouping continuation do, and when is one returned?

A grouping continuation is an opaque string that paginates a grouping result. The result returns it, and the next request resubmits it in the `continuations` annotation on the grouping step of the original select. That annotation is an ordered list of zero or more continuation strings.

Every root group contains a single `this` continuation per select. In the result JSON it is the `this` property of `continuation`. The grouping guide shows it on `group:root:0`. It represents the current view. Submitted as the sole continuation, it reproduces the exact same result that contained it. Each group list and each hit list has zero or one `prev` and zero or one `next`, returned as `continuation.prev` and `continuation.next`. Those strings ask for the previous or next page of that list. The pages do not say when a list omits `prev` or `next`.

The first string must be the root `this` continuation. Continuations for different lists may be combined in one request, so one list can move to its next page while another moves to its previous page. The strings are processed in the order given. If more than one continuation refers to the same group list or hit list, the later one takes effect and replaces the one it collides with. The guide's example tokens are `BGAAABEBCA` for `this`, `BGAAABEBEBC` for the customer list's `next`, and `BGAAABEABC` for that list's `prev`. Those strings belong to that example result.

The grouping guide says continuations work best when hit ordering is stable, which ranking or grouping `order` can provide. If several documents would otherwise get the same rank score or the same order value, a tie-breaker may be needed, such as `random.match` or a random double stored in each document. The pages do not say the token survives changes to the feed.

In the Java grouping API, these are `Continuation` objects on `RootGroup`, `GroupList`, and `HitList`, added back to the continuation list of the `GroupingRequest`.

- **Sources:** `documentation/en/reference/querying/grouping-language.html` (Continuations); `documentation/en/querying/grouping.html` (Pagination)
- **Review:** Accepted from [grouping continuation](ba8f3834-26c4-4dc4-8e5d-7905b5a73ced). The `this` token, the zero-or-one `prev` and `next` per list, and the first-must-be-`this` rule match the grouping-language reference. The guide says a later continuation replaces any shared state of an earlier one. The reference says that for the same group list or hit list, the last one takes effect. The reference wording is kept. The reference says a sole `this` reproduces the exact same result. The guide says the same result and adds the stable-ordering note. Both are kept. The example tokens are the guide's example. The query API reference names no continuation parameter.

### 69. Where are BM25 k1 and b set, and which BM25 features exist besides bm25(field)?

`k1` and `b` are rank properties inside a rank profile, set per field on the `bm25` feature. The defaults are `k1` 1.2 and `b` 0.75. Rank properties are inherited like the other content of a rank profile. The configuration example sets `bm25(title).k1: 1.5` and `bm25(title).b: 0.85`. Those numbers are examples. The same `bm25(fieldname).k1` and `bm25(fieldname).b` properties are also used by `bm25(field: fieldname, label: label)` and by `bm25_for_labels(fieldname)`. The same block can set `bm25(fieldname).averageFieldLength`. For indexed search that length is calculated per field per content node, and for streaming search the documented value is 100.

Besides `bm25(field)`, the rank-feature reference names three siblings:

- `bm25(field: name, label: label)` is the `bm25(name)` score using only query terms that carry that label and search the field. The feature-table default is 0, and the text says the score is 0 when no such term matches. A label that is not an identifier or an integer must be quoted, as in `bm25(field: myfield, label: "title-terms")`. The field must have `enable-bm25`, because this feature is that score restricted to a label.
- `bm25_for_labels(name)` returns a `tensor<float>(label{})`. The feature-table default is `tensor<float>(label{}):{}`. Each cell is one query-item label and holds the sum of the BM25 scores of that label's terms in the indexed string field. The field must have `enable-bm25`. A cell exists only when at least one term carrying the label searches the field and matches the document. Terms without a label are omitted, so `reduce(bm25_for_labels(name), sum, label)` equals `bm25(name)` only when every scoring term carries exactly one label.
- `elementwise(bm25(field),dimension,cell_type)` computes BM25 per element of a multi-valued indexed string field. Matching element indexes, starting at 0, are the labels of one mapped dimension. The feature-table default is `tensor<cell_type>(dimension{}):{}`. It does not need `enable-bm25`. `cell_type` may be omitted and then defaults to `double`, except when setting rank properties, where the feature name must include `cell_type`. Its own properties are `elementwise(bm25(field),dimension,cell_type).k1` and `.b`, with defaults 1.2 and 0.75. `bm25(field).k1` and `bm25(field).b` are the fallback before those defaults. For this feature, `b` controls element length compared with the average element length. The configuration example `elementwise(bm25(content),x,float).k1: 1.4` is an example.

- **Sources:** `documentation/en/ranking/bm25.html` (k1, b, labeled features); `documentation/en/reference/ranking/rank-feature-configuration.html` (rank properties); `documentation/en/reference/ranking/rank-features.html` (`bm25(field: name, label: label)`, `bm25_for_labels`, `elementwise`)
- **Review:** Accepted from [BM25 parameters](db209651-53d0-4d18-bdf2-3a2ae3bfa320). The 1.2 and 0.75 defaults, the shared properties for the labeled features, and the elementwise fallback match those pages. The configuration page's link text writes `elementwise(bm25(fieldname,x,celltype))`. The rank-features table and the configuration example use `elementwise(bm25(field),dimension,cell_type)`. That form is kept. The BM25 formula, `enable-bm25` flush and fusion, and the streaming length of 100 are already in an earlier answer. `averageElementLength` is in the same elementwise property row and is not stated here. The note that picking one label out of `bm25_for_labels` is slower than the labeled `bm25` feature is omitted.

### 70. What does BM25 count as a term's document frequency?

BM25's document frequency `n(q_i)` is the number of documents that contain query term `i` in the field being scored. The BM25 page says that count is calculated for each index of that field, and that BM25 uses the maximum of those per-index counts. That maximum typically comes from the largest disk index.

`queryTermDocumentFrequency(name)` is a `tensor<float>(term{})` with one cell per query term that searches the named index field. The feature-table default is an empty tensor, and the tensor is empty when no query term searches the field. Each cell is labeled with the term's original index in the query, as a string starting at 0, and those labels are not renumbered. The cell is the number of documents that contain the term. When a significance model is present, the cell is the query-provided document-frequency override from that model. Otherwise it is the local content-node index statistic, which the rank-feature reference calls the same value BM25 uses. If the term searches several fields, that cell holds the frequency for the named field. In streaming search, a value that is not overridden is 0.

The significance page describes the local model differently. For each query term, it says document frequency is computed by aggregating the per-field document frequencies across all fields being searched. That account and the per-field account above are both in the docs.

- **Sources:** `documentation/en/ranking/bm25.html` (`n(q_i)`); `documentation/en/reference/ranking/rank-features.html` (`queryTermDocumentFrequency`); `documentation/en/ranking/significance.md` (local model)
- **Review:** Accepted from [BM25 document frequency](a10e82a3-f8dc-4767-93fd-19134052a9b9). The per-index maximum and the largest disk index are on the BM25 page. The rank-feature page calls the non-override cell the same value BM25 uses, and it keeps that cell per named field. The significance page aggregates across fields being searched and does not say whether that aggregate is a sum, a maximum, or a union. Both accounts are kept. The feature description types the tensor as `tensor<float>(term{})`. Its example prints `tensor<double>(term{})`. The description's type is kept. Streaming significance of 1 is already in an earlier answer. The 0 here is the non-overridden document frequency of this feature.

### 71. What do nativeFieldMatch, nativeProximity, and nativeAttributeMatch each measure?

The rank-feature reference gives each a one-line definition, lists the default as 0, and says the feature is used by `nativeRank`. The nativeRank reference is the page that describes the score.

`nativeFieldMatch` captures how well query terms match in index fields. The reference says it looks at how many times a term occurs in a searched index field and how early in the field it occurs. Term significance and term weight are included, so an unusual term contributes more than a common one. `nativeFieldMatch(field,...)` uses only the named index fields. By default, query terms searching in all index fields are considered.

`nativeProximity` captures how near matched query terms occur in index fields. The reference measures the word distance between query terms in pairs. Two terms that are close score higher than two terms that are far apart. For each field, the terms searched in that field are formed into pairs, and `slidingWindowSize` determines how many pairs are generated. The reference's example, a window of size 3 over the terms `a b c d`, produces the pairs `ab`, `ac`, `bc`, `bd`, and `cd`. `nativeProximity(field,...)` uses only the named index fields. For a multi-value field, setting `element-gap` for the field in the rank profile enables distance calculation between adjacent elements. If table normalization is off, the proximity maximum used in the denominator is 1.

`nativeAttributeMatch` captures how well query terms match in attribute fields. The value that enters the boost table depends on the attribute type. For a weighted set it is the weight of the key, the query term, in that attribute. For an array it is the number of occurrences of the query term. For a single-value attribute it is 1. `nativeAttributeMatch(field,...)` uses only the named attribute fields. The printed score sums over query terms and refers to one attribute index with no sum over attributes.

- **Sources:** `documentation/en/reference/ranking/rank-features.html` (`nativeFieldMatch`, `nativeProximity`, `nativeAttributeMatch`); `documentation/en/reference/ranking/nativerank.html` (the three feature sections)
- **Review:** Accepted from [nativeRank components](bdbbc66f-cb88-4aba-88f8-df5e31bf958e). The one-line definitions and the default of 0 match the rank-feature rows. The occurrence and position rule, the term-pair distance rule, the sliding-window pairs, and the three attribute-type values match the nativeRank reference. The full score equations are on that page. They are not copied here. The attribute equation leaves the attribute index unbound. The `nativeRank` combination and its weights are already in an earlier answer.

### 72. How does the and operator differ from weakAnd?

`and` is boolean conjunction. Each argument must match. The YQL `and` row says the arguments are other `and` statements, `or` statements, `userQuery`, logically inverted statements, and contains statements, as in `where title contains "madonna" and title contains "saint"`. An `or` argument is true under the `or` rule. The `and` row states no hit limit, no `targetHits`, and no internal score.

The WAND guide's example of the same retrieval under boolean AND returned 2 documents and missed the relevant ones. OR retrieval of that example returned 7,926,256 documents. Those counts belong to that example. `weakAnd` does not require every child to match. Matched terms are exposed to ranking for `and` and `or` in the same way the `weakAnd` row describes.

- **Sources:** `documentation/en/reference/querying/yql.html` (`and`, `weakAnd`); `documentation/en/ranking/wand.html` (boolean AND versus OR)
- **Review:** Accepted from [weakAnd versus and](4023630a-12da-4543-895d-2bc0f30fad72). The `and` row lists the argument kinds and the example. It does not itself write "each argument must match." That is the boolean-AND reading of the row and of the WAND guide's contrast, and it is kept. The `and` row has no annotation table, so it is not given a hit limit. The `weakAnd` heap, the default of 100, and the rank-profile knobs are already in an earlier answer. The example counts are that guide's MS MARCO example.

### 68. When does Vespa fetch document summaries relative to matching and ranking?

Vespa fetches document summaries after matching and ranking, and only for the global best hits.

The first protocol phase runs the query in parallel on the content nodes and finds the global top hits. By default, matching and first-phase score calculation are interleaved. Inside that phase, the search threads complete first-phase ranking and agree which hits continue to second-phase ranking when the rank profile enables it. The threads share a heap of the global top-ranking hits. Each thread then completes second-phase ranking and grouping, aggregation, and sorting. The thread results are merged and returned to the container. The only per-hit data at that point is the internal global document id and the ranking score. Result metadata such as coverage and the total hit count is also available. Field contents are not.

After the container merges those hits, and blends them when more than one content cluster is involved, the second protocol phase fetches summary data for the global best hits from the content nodes that produced them. The sizing page's examples are summary snippets, the original field contents, and ranking features. The fetch is lazy. It does not run before rendering unless a custom searcher requests it earlier. A searcher can filter the unfilled hits and call `fill()` more than once, interleaved with that filtering. Each fill loads summary data for the hits still in the result.

- **Sources:** `documentation/en/querying/query-api.html` (query execution, fill phase); `documentation/en/performance/sizing-search.html` (life of a query); `documentation/en/querying/document-summaries.html` (`fill()`); `documentation/en/applications/searchers.html` (multiphase searching)
- **Review:** Accepted from [summary fill](eb5e35af-32fe-4391-a4ef-32048b213951). The two protocol phases, the gid-and-score hit, and the lazy fill match those pages. The sizing list says each thread completes second phase and grouping, aggregation, and sorting, so that is the order kept. These pages do not name global-phase relative to the summary fetch. The sizing page lists summary fetch and then "possible top-k re-ranking" without naming global-phase, so that re-ranking is not stated as the global-phase. Select-list filtering, the default summary class, and `hits=0` are already in earlier answers.

### 76. How does a field path address a map entry or a struct field?

A field path selects an element inside a composite field. The document JSON reference writes a map entry as the field name plus the key in braces, `mymap{mykey}`, a struct field as the field name, a dot, and the subfield, `mystruct.value1`, and an array element as the field name plus the index in brackets, `myarray[3]`. The field-path reference uses the same three examples. A subscript of a map, a weighted set, or an array is a number or a string. The same `{key}` form addresses a weighted set, and the value it refers to is the weight of that item.

The selectors combine. A map of map to array of struct is addressed as `nested_structure{firstMapKey}{secondMapKey}[4].title`. On an array of structs, a bare dot such as `mystructarray.value1` returns that subfield from each struct.

A partial update uses the same path as the name under `fields`. The JSON reference assigns a struct subfield with `contact.first_name`, one field inside a map entry with `contact{0}.first_name` where `{0}` is the map key, and one array slot with `ingredients[3]` or `people[34]`. For the `ingredients[3]` assign, the page says index element 3 needs to exist. A quoted map key is written as `contacts{"Uncle Scrooge"}`. The fieldpath section says this direct access is for structures that are not part of an index or attribute, and that struct updates do not work in index mode.

- **Sources:** `documentation/en/reference/schemas/document-json-format.html` (fieldpath, assign examples); `documentation/en/reference/schemas/document-field-path.html` (map, array, struct); `documentation/en/reference/schemas/schemas.html` (`my_map{my_key}`)
- **Review:** Accepted from [field paths](69462109-3229-4303-ac81-7a178ef1e759). The three forms and the nested path match those pages. The struct table writes `<structfield>{.<subfield>}`. The examples on both pages use `mystruct.value1`, with no braces, so that is the syntax kept. `.key`, `.value`, and the deprecated `$variable` paths are omitted. Struct updates in index mode are already in an earlier answer. The index-element note is the one attached to `ingredients[3]`.

### 73. What does the filter annotation on a query term do, and how does it differ from ranked?

`filter` is a boolean annotation on a query term. The default is false. `filter:true` regards the term as a filter term and not a term from the end user. Terms annotated that way are not bolded. Whether bolding is enabled is the schema `bolding` setting. The YQL reference does not describe a change to whether the term matches or to its score. The text-search tutorial also says `filter:true` keeps the term out of bolding, highlighting, and dynamic snippeting.

`ranked` is the annotation that includes the term in the ranking calculation. It defaults to true. Setting it to false omits the term from that calculation and can speed up query evaluation. The text-search tutorial sets `filter:true` and `ranked:false` together and attributes an unchanged relevance score to `ranked:false`.

- **Sources:** `documentation/en/reference/querying/yql.html` (`filter`, `ranked`); `documentation/en/learn/tutorials/text-search.md` (filter and ranked together); `documentation/en/learn/faq.md` (filter terms are not highlighted)
- **Review:** Accepted from [filter annotation](83f9a36c-bf6d-4ec4-8998-26a7f646c3dd). The defaults and the bolding sentence match the YQL annotation table. That table does not say `filter` changes matching or the score, so no such effect is stated. The tutorial's snippet sentence is kept beside the reference's bolding sentence. Schema `rank: filter` is already in an earlier answer. `model.filter` is a different query parameter.

### 75. Where does Vespa read a rank feature that is used as a sort key?

The sorting reference says sort features are computed during matching on the content nodes, for each hit considered for sorting, and that only the features the query selected are evaluated.

In the matching code, `MatchTools::setup_first_phase_and_sort` builds a separate sort `RankProgram` and resolves the selected seeds as `LazyValue`s. `MatchThread::inner_match_loop` calls `MatchThread::Context::record_sort` for a hit. That method evaluates each seed with `LazyValue::as_number(docId)` and stores the doubles in the thread's `SortFeatureStore`. When matching is also ranking, the iterator is unpacked and `record_sort` runs only for a hit that `rankHit` accepts. When it is not ranking, `record_sort` runs for every match, and the iterator is unpacked only if the sort features need match data. The sort program is released before second phase. Result sorting reads the stored numbers through `FastS_SortSpec::feature_value`, which calls `SortFeatureStore::get`, and does not evaluate the rank feature again.

- **Sources:** `documentation/en/reference/querying/sorting-language.html` (computed during matching); `searchcore/src/vespa/searchcore/proton/matching/match_thread.cpp` (`record_sort`); `searchcore/src/vespa/searchcore/proton/matching/match_tools.cpp` (`setup_first_phase_and_sort`); `searchlib/src/vespa/searchlib/common/sortresults.cpp` (`feature_value`)
- **Review:** Accepted from [feature sort](94c05e14-1b67-470c-826d-18cb9ae68024). The sorting page places the computation during matching. The separate sort program, the store, and the release before second phase match the matching code. Unpacking is unconditional on the ranking path. It is conditional on sort match data only when the hit is not being ranked. The user-visible `feature(name)` rules are already in an earlier answer.

### 79. After activate, how does an application package become the configuration a node uses?

Activate switches the config server cluster to the new system model. The servers then respond on any active subscription whose config that model changed, so a small package change produces the corresponding config updates.

A subscription is the config definition's name and namespace plus the config id of that component instance. The in-process library forwards it to the config proxy on the same node. Clients reach that proxy at `localhost:19090`. The proxy keeps a memory cache and is the fan-in for the processes on the node. It always starts in default mode: it uses a config source, serves from the cache when it can, and holds an outstanding request to a config server. That request returns when the config changes to a new generation. The proxy updates its cache and responds to its clients with the changed config. A restart of the proxy drops the memory cache. Those subscriptions are long-timeout gets, sent again as soon as they time out, and the config system describes them as push. Each config server has a copy of the system model and resolves the request by querying that model. With more than one config server, the proxy picks one at random and switches if that server is unavailable or the configuration it returns is in error. Config is not stored as files on the node. The same page also says application code and config are generally pulled from the config server.

The generation is the number of the config that is active in the application. It increases each time an application is deployed with `vespa deploy`. The container metrics call the live application config generation the session id. A successful activate is logged with the same number for both, as in "Session 2 activated" and "Config generation 2". Every config held by one `ConfigSubscriber` is of that same generation. The config server itself runs from file-based configuration, and its own `/state/v1/config` stays at generation 0. The deployed package is what it serves to the other nodes.

A component either subscribes and reads the config when its handle has changed, or, in the Java container, receives it by constructor injection. Injection builds a new instance when a changed config is available. On a container, changes to components, configuration, or data are applied without disrupting request serving and without a process restart. Changed bundles are copied to the nodes that need them, and a query runs entirely on the previous component versions or entirely on the new ones. A bundle that contains JNI cannot reload. If the native library is loaded in the constructor, the new bundle does not load and a later restart loads it. For document processing, chain ids, components in a chain, component configuration, and schema mapping take effect after deployment with no restart. Changing the container id requires a restart of docproc services after `vespa activate`. A document processor that was unknown when the cluster started requires a container restart. The config-proxy page says a restart can also be required for some config changes, in the proton generation check. When new components or files named in config are distributed, the container gets a new file reference, waits until those files are available, and then switches to the new config.

- **Sources:** `documentation/en/applications/config-system.html` (activate, subscription, proxy); `documentation/en/operations/self-managed/config-proxy.html` (`localhost:19090`, default mode); `documentation/en/operations/self-managed/configuration-server.html` (generation 0, failover); `documentation/en/applications/containers.html` (no restart); `documentation/en/applications/components.html` (bundle switch, JNI); `documentation/en/applications/document-processors.html` (docproc restart cases)
- **Review:** Accepted from [config generation](c3df9679-1e7c-42ae-a445-2e13659866cb). The activate switch, the long-timeout gets, and the generation number match those pages. The same config-system page calls the delivery push and also says application code and config are generally pulled. Both wordings are kept. Prepare and activate themselves are already in an earlier answer. The pages do not say whether a prepared session that was never activated counts as a generation.

### 74. How does a query test that a field is present or missing?

A string attribute is tested for a non-empty value with `matches` and the regular expression `^.`, which matches any value of at least one character: `select * from music where album matches "^."`. The text-matching guide says this works on any string attribute field. The YQL reference says `matches` is a case-insensitive POSIX extended regular expression, supported only on an attribute field, and that a field that is both an attribute and an index is not compatible. Without `fast-search`, the expression is evaluated over every document. With `fast-search`, a prefix-anchored pattern such as `^abc.*` runs only over values that can start with that prefix. Regular-expression matching does not perform character normalization.

The text-matching guide does not give an operator that selects documents where a string field is absent. For that complementary query it points to grouping's count of fields with NaN. That example buckets a numeric attribute, and the low bucket is unset or less than 0.

For a numeric field, `range(field, -Infinity, Infinity)` matches every document that has a value set. Documents where the field is unset are not matched. The same range does not test presence of a single-value string. An absent value is the empty string, so the range would match every document.

When a field is both an index and an attribute, the index environment replaces the attribute field with an index field and keeps the attribute only for ranking. A regexp term on that index field is a dictionary lookup of the pattern text. It is not evaluated as an attribute regular expression. Attribute string search is case-sensitive when the attribute match setting is cased. The YQL page states that `matches` is case-insensitive and does not mention that setting.

- **Sources:** `documentation/en/querying/text-matching.html` (`matches "^."`); `documentation/en/reference/querying/yql.html` (`matches`, `range`); `documentation/en/querying/grouping.html` (count fields with NaN); `searchcore/src/vespa/searchcore/proton/matching/indexenvironment.cpp` (index field replaces the attribute)
- **Review:** Accepted from [field presence](55655191-d76a-4079-897f-f2216a265541). The non-empty string pattern and the numeric range match those pages. The numeric range is included because the YQL reference states it as the presence test. The text-matching page points at the NaN grouping example for a missing value, and that example is a numeric bucket. A field that is both an index and an attribute is registered as an index field, so the YQL incompatibility sentence is the one kept for that case. Tensors, structs, arrays, and weighted sets are not given a presence operator on these pages.

### 77. How does matching a weighted set differ from matching an array of strings?

A weighted set is a multivalue field whose keys are `byte`, `int`, `long`, or `string`, and each key has a signed 32-bit integer weight. The fed value is a JSON object from key to weight. A key that is not a string is still written as a JSON string, for example `"123": 2` or `"item 1": 143`. An array of strings is a JSON array. The schema indexes each array element separately. On an indexed weighted set, each token is indexed with the element number, the element weight, and the token positions in that element, and queries match across elements in the set.

With `indexing: index` and `match: text`, the multivalue guide's example matches a token inside a key. Matching is partial, so `clear` matches the key `clear sky`, and `sky` matches it as well. A multi-term query matches across keys, so `black sky` matches when those tokens are in different elements, such as `black and white` and `clear sky`. Those keys belong to that example.

Positional distance is a separate rule. `element-gap` is the gap between positions in adjacent elements of a multi-value field. The default is `infinity`, so distance is calculated only within an element. The schema's example is an array of strings. The setting affects `nativeProximity`, `near`, and `onear`. `sameElement` requires its conditions to match inside one element. For an array of strings the example is `chunks contains sameElement("one" and "two")`.

A weighted set does not support filtering on the weight. A numeric condition uses a map and `sameElement`, as in `my_map contains sameElement(key contains "Coldplay", value > 10)` on a `map<string, int>`. The weight is what ranking reads after a match. `elementSimilarity` multiplies by the element weight, which is 1 for an array element and the supplied weight for an indexed weighted set. As an attribute, the weighted set is a multivalue weighted attribute. Attribute fields are not tokenized. Queries in attribute fields are not normalized or stemmed. `attribute(name,key).contains` is 1 when the key is present and otherwise 0. `attribute(name,key).weight` is the weight at that key, and its feature-table default is 0. The string attribute row says attribute searches are case-insensitive.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`weightedset`, `array`, `element-gap`, attribute queries); `documentation/en/reference/schemas/document-json-format.html` (weightedset JSON); `documentation/en/querying/searching-multivalue-fields.md` (partial and cross-element match); `documentation/en/reference/ranking/rank-features.html` (`elementSimilarity`, `attribute(name,key)`); `documentation/en/querying/query-language.html` (map `sameElement`)
- **Review:** Accepted from [weighted sets](7985b05b-2244-47c5-9c78-dd62f026f272). The key types, the index record, and the no-filter-on-weight sentence match the schema reference. The pages do not say a different weight includes or excludes the document. Cross-element matching is stated for an indexed weighted set with `match: text`. The infinite `element-gap` is the distance rule for multi-value fields, and the schema's distance example is an array of strings. The pages do not say an array `and` cannot draw terms from different elements. `match: cased` is already in an earlier answer. The string attribute table's case-insensitive sentence is kept as that table states it. `nativeAttributeMatch` and `create-if-nonexistent` are already in earlier answers.

### 82. After linguistics, which form of a word is written into the text index?

By default Vespa uses one token per word, both when indexing and when searching. That token is the alternative the linguistics implementation considers best, which is the first alternative it produces for most implementations. The setting is `tokens: first-alternative`, and it is equivalent to `stemming: best`. The linguistics page lists that alternative separately from the original word.

`tokens: original` uses the original word only and disregards alternatives. It is equivalent to `stemming: none`. `tokens: alternatives` uses every alternative and not the original word. `tokens: original-and-alternatives` uses the original word and every alternative. It is equivalent to `stemming: multiple`. The page describes those alternatives as the stems of a word, the parts of a compound, its n-grams, or synonyms. It does not define the original word as the raw surface string.

The text-matching example prints the field summary and the tokens used for indexing as different results. `Liebe ist für alle da` is summarized as that string, and its indexing tokens are `lieb`, `ist`, `fur`, `all`, `da`. `A Head Full of Dreams` indexes as `a`, `head`, `full`, `of`, `dream`. `Hardwired...To Self-Destruct` indexes as `hardwire`, `to`, `self`, `destruct`. The same table names lowercasing, normalizing, and stemming as transformations before the data is indexed. The generated script writes `summary album` and `index album` as separate steps. These pages do not say the original surface form is stored in the index, and they do not say it can be reconstructed from the index terms. They also do not call the field summary a read-back of the index.

The tokens are stored in the same way in the underlying index for every linguistics implementation. With Lucene linguistics, Vespa does not store positions in Lucene segment files. Storage is the same as with OpenNLP, and only the resulting tokens might differ.

- **Sources:** `documentation/en/linguistics/linguistics.html` (`tokens` modes; storage note); `documentation/en/querying/text-matching.html` (album summary versus `album_tokens`)
- **Review:** Accepted from [tokenization boundary](db0bf540-e691-499d-a1e6-fea7911c12f1). The token modes and the printed indexing tokens match those pages. `A Head Full of Dreams` keeps the other tokens and stems `dreams` to `dream`. The printed indexing tokens are lowercase, and the text-matching table names lowercasing as a transformation before indexing. The pages do not say the surface string is recoverable from the index. The language is already recorded as not stored on the content node. `stemming: best` is already the default in an earlier answer.

### 84. What is a rank-profile constant, and how is a rank-profile function called?

A rank-profile constant is a named value in that profile's `constants` clause, available to ranking expressions. The schema reference says the list is resolved and optimized at configuration time. The ranking-expressions page says the constants are applied to the expressions then, and the constant parts of those expressions are calculated, which can reduce execution cost, especially with tensor constants. It says to prefer constants to query variables whenever the values can be enumerated in a set of rank profiles.

The name is written as `constant(myName)` or as `name`. The type is `double` or a tensor type. If the type is omitted, it is double. The value is a number, a tensor literal, or `file:` followed by a path from the application package root. The file must be tensor JSON and end with `.json`, or `.json.lz4` when it is lz4-compressed. A phase expression uses the name from the clause. The ranking-expressions example is `myConst1 + myConst2`.

A rank-profile function is a named function in the profile. It accepts any number of arguments, and the parentheses after the name are required. A phase expression calls it by name. In the schema reference, `first-phase` uses a no-argument function as `myfeature * 10`, and `second-phase` uses `otherfeature(title) * myfeature`, where the function is declared `otherfeature(foo)` and its expression refers to `foo`. A function with no arguments can also be used as a feature. The function section says summary features cannot include a function that accepts arguments. The rank-profile table says a function without arguments can be part of match-features and summary-features. The ranking-expressions page says zero-argument functions can be used as summary-features and rank-features. The `inline` modifier inlines the function in the calling expression when the function has no arguments. That is faster for small, cheap functions and more expensive for others.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`constants`, `function (inline)? [name]`); `documentation/en/ranking/ranking-expressions-features.html` (using constants, function snippets)
- **Review:** Accepted from [rank constants](52d46db4-280b-4749-9e33-9c8ee34fce1c). The clause syntax, the default double type, and the `otherfeature(title)` call match the schema reference. Inheritance of constants is already in an earlier answer. The schema also has a schema-level `constant` element, a named tensor file with a required type. That declaration is not this clause, so it is not stated here. The function section forbids argument-taking functions in summary features. The rank-profile table and the ranking-expressions page also say a zero-argument function can be a match-feature or a rank-feature. Those sentences are kept.

### 81. What is a query item label, and which rank features read it?

A query item label is a symbolic name attached to a query item so ranking can refer to that item. In the search container query API, call `setLabel` on the query item. In YQL, write the annotation in braces and scope it with parentheses, as in `({label:"must"}content contains "vespa")`. The YQL reference says the label is carried by a single term or by an operator such as `and`, `or`, or `nearestNeighbor`, and that a sub-clause inherits its parent's label and can override it. `labeled(subQuery, "mylabel", 4.25)` wraps a sub-query with a label and a score. If that sub-query matches, `itemRawScore` reads the score.

`itemRawScore(label)` is the raw score produced by the query item with that label. The rank-feature table lists its default as 0. `rawScore(field)` is a different feature: the sum of raw scores produced by match operators for that field, also listed as 0, and it does not take a label.

`matches_for_labels(name)` is a `tensor<float>(label{})`. The table default is `tensor<float>(label{}):{}`. A cell is 1.0 for each query item label that searched the named field and matched the document. A label that did not match has no cell. `matches_for_labels` is the same tensor without regard to field: a label gets a cell of 1.0 if any query item carrying it matched the document. `closest(name, label)` is the closest document vector for the `nearestNeighbor` operator that carries that label. Its table default is `{}`.

The YQL label annotation lists `itemRawScore(label)`, `closeness(label, name)`, `distance(label, name)`, `closest(field, label)`, `bm25(field: field, label: label)`, and `bm25_for_labels(field)`. It does not list `matches_for_labels`. The rank-feature reference is the list kept for that feature. The labeled BM25 features and the `nearestNeighbor` closeness and distance features are already in earlier answers.

- **Sources:** `documentation/en/ranking/multivalue-query-operators.html` (`setLabel`, `itemRawScore`); `documentation/en/reference/ranking/rank-features.html` (`itemRawScore`, `matches_for_labels`, `closest(name, label)`); `documentation/en/reference/querying/yql.html` (`label`, `labeled`); `documentation/en/ranking/bm25.html` (YQL label example)
- **Review:** Accepted from [ranking labels](d9a4a4c2-594f-4f08-8622-7094c39a1167). `itemRawScore` and its default of 0 match the rank-feature table. The answer also includes `matches_for_labels` and `closest(name, label)`, which that table keys by query item label and which the draft left in its notes. The YQL annotation list does not name `matches_for_labels`. Label inheritance and the labeled BM25 features are already in earlier answers.

### 83. How does a rank profile declare a query tensor, and what happens if the query omits it?

A rank profile declares query inputs as `name [type]? (: value)?`. The name is `query(myName)` or `name`. The type is `double` or a tensor type. If the type is omitted, the schema reference says the type is double, so a tensor declaration includes a tensor type. The optional value is a number or a tensor literal. The schema reference calls that value an optional default module and says it is used if the input is not set in the query. Its examples are `query(myArray) tensor(x[3])` and `query(myMap) tensor(key{}):{key1: 1.0, key2: 2.0}`. The tensor user guide's example uses `tensor<float>(x[4])`.

The query sends the value as `ranking.features.<featurename>`. The documented aliases are `input.<featurename>` and `rankfeature.<featurename>`. The key must be a query feature, `query(anyname)`. The query API says the value must be a double, a string to be hashed to a double, or a tensor matching the declared input type, on tensor literal form. Its examples are `input.query(myIndexedTensor)=[1.0, 2.0, 3.0]` and `input.query(myMappedTensor)={"Tablet Keyboard Cases": 0.8, "Keyboards":0.3}`. A Searcher sets the same value with `query.getRanking().getFeatures().put("query(myInput)", myValue)`. A JSON POST request puts the tensor under `input`, with the key `query(q_embedding)`.

If the declaration includes a default, that default is used when the query does not set the input. The schema reference does not say what happens when a tensor input is omitted and no default is declared. The query API's default cell for `ranking.features` is empty. The rank-feature table lists the default of `query(value)` as 0 and does not give a default tensor. The ranking page says the default type of features is scalar. It does not name a tensor used when a declared tensor input is missing.

For a value whose type does not match a declared tensor input, the query API says the value must match the declared type and does not give the outcome. The ranking page gives an outcome only when the tensor type is not declared correctly: the passed feature is handled as a string converted to a scalar, which does not produce an error and produces incorrect results.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`inputs`); `documentation/en/reference/api/query.html` (`ranking.features`); `documentation/en/ranking/tensor-user-guide.html` (query tensors); `documentation/en/ranking/ranking-expressions-features.html` (query feature types); `documentation/en/reference/ranking/rank-features.html` (`query(value)`)
- **Review:** Accepted from [query tensors](1bfe6c41-13e9-497e-853f-393fc9c0f3e3). The inputs syntax and the optional default match the schema reference, including its wording "default module." No page states a tensor used when a declared tensor input is omitted and has no default, so none is stated. The scalar default 0 is the `query(value)` row and is not applied to that case. A `nearestNeighbor` query tensor that is not declared fails the request. That failure is already in an earlier answer. The ranking page's "no error, incorrect scalar" sentence is the case where the tensor type is not declared correctly. The JSON request nests the tensor under `input`. Inheritance of inputs is already in an earlier answer.

### 80. When does a fast-search attribute posting list gain a stored bitvector, and when is that bitvector removed?

A stored bitvector is created when the posting list's document count is at least `max(S / 64, 128)`, and removed when the count falls below `max(S / 128, 64)`. Both divisions are integer divisions. `S` is the size passed into `resizeBitVectors`, rounded up to a multiple of 64. If that rounded size is at least the capacity also passed in, `S` is the capacity instead. On load and on shrink, the size and the capacity are both the document-id limit. When a document is added, they are the requested size and capacity, raised to that document id plus one if the document is at or past them.

The posting store starts with the create limit at the maximum 32-bit unsigned value, so no bitvector is created until `resizeBitVectors` replaces that limit. The attributes page only says a bitvector is generated when a value occurs in many documents, and that it is generated in addition to the occurrence b-tree. It gives no number.

With `rank: filter`, the posting store does not keep that b-tree beside the bitvector. Creating the bitvector from an existing tree clears the tree. Creating a new bitvector skips building a tree. The schema reference says this setting builds additional bitvector representations for a fast-search attribute. It does not say the b-tree is removed. When the count later falls below the removal limit and no tree is stored, the bitvector is turned back into a tree.

- **Sources:** `searchlib/src/vespa/searchlib/attribute/postingstore.cpp` (`resizeBitVectors`, `makeBitVector`, `applyNewBitVector`, `dropBitVector`); `searchlib/src/vespa/searchlib/attribute/postinglistattribute.cpp` (size and capacity passed in); `config-model/src/main/java/com/yahoo/schema/derived/AttributeFields.java` (`rank: filter` sets the bitvector-only flag); `documentation/en/content/attributes.html` (many documents); `documentation/en/reference/schemas/schemas.html` (`rank: filter`)
- **Review:** Accepted from [posting lists](e98e2f07-9da2-47a0-a10f-ea3af7cf4866). The create and remove comparisons match the header comments: at least the create limit, and below the remove limit. Rounding uses `>=` against capacity, so a size that lands on the capacity is the capacity. The attributes page's "in addition to the b-tree" sentence is the non-filter case. The schema's "additional" wording is kept beside the filter-mode code, which does not store the tree. Posting-entry widths and the short-list array form are already in an earlier answer. A query-time 0.0025 ratio chooses a temporary array or bitvector while merging a range. That is not this stored threshold.

### 91. What does vespa.eval.use_fast_forest change, and what is its default?

The default is false. `UseFastForest::DEFAULT_VALUE` is `false`, and `UseFastForest::check` passes that value to `lookupBool`. If the property is absent, `lookupBool` returns that default. If it is present, the check is true only when the value is the string `true`.

The flag is read in `RankingExpressionBlueprint::setup`, from the index-environment properties. The XGBoost page says this is a rank-profile setting applied when the model is compiled, so it cannot be toggled per query. `_fast_forest` starts empty. The flag is consulted only when the motivation is not `FeatureMotivation::VERIFY_SETUP` and `do_compile` is still true. `do_compile` stays true when no input is an object, every node type is double, and compilation is not turned off because the expression has compile issues and no interpret issues.

When the check is true, setup assigns `_fast_forest` from `FastForest::try_convert`. The default limits are `min_fixed` 8 and `max_fixed` 64. `try_convert` returns a forest only if the root `is_forest()` and `total_in_checks` is 0. `is_forest()` is true for an `Add` whose two children are each a tree or a forest. `total_in_checks` counts `in` set checks such as `foo in [1, 2, 3]`. A `<` check and an inverted `!(>=)` check do not increment it. Conversion then tries a fixed-width forest for `uint8_t`, `uint16_t`, `uint32_t`, and `uint64_t`, in that order. A type is used when its leaf capacity, `sizeof(T) * 8`, is inside `[min_fixed, max_fixed]` and the widest tree has at most that many leaves, so the capacities are 8, 16, 32, and 64. If none fit, and the host is little-endian and the widest tree has at most `8 * 256` (2048) leaves, it builds a multi-word forest. Otherwise it returns an empty pointer.

When the check is false, setup does not call `try_convert`. If `_fast_forest` is empty, including after a failed conversion, setup compiles the function with `CompileCache::compile`: `PassParams::LAZY` when `LazyExpressions::check` is true, and `PassParams::ARRAY` otherwise. `createExecutor` uses `FastForestExecutor` when `_fast_forest` is set. That executor copies numeric inputs into a float span and calls `FastForest::eval`. If `do_compile` is false, setup does not read the flag and stores an `InterpretedFunction` instead.

The XGBoost and LightGBM pages say the evaluator reduces cost and that models with at most 64 leaves per tree benefit the most. In this code, 64 is the largest fixed-width leaf capacity. On a little-endian host, a widest tree of 65 to 2048 leaves still converts through `MultiWordForest`. The same XGBoost note says the root must be the bare sum of trees, every split must be numeric, and no tree may have more than 2048 leaves. It also says a UBJ model is never eligible because the importer appends `base_score`. That importer was not opened.

- **Sources:** `searchlib/src/vespa/searchlib/fef/indexproperties.cpp` (`UseFastForest`); `searchlib/src/vespa/searchlib/features/rankingexpressionfeature.cpp` (`setup`, `FastForestExecutor`); `eval/src/vespa/eval/eval/fast_forest.cpp` (`try_convert`); `documentation/en/ranking/xgboost.md` (fast-forest note)
- **Review:** Accepted from [fast forest](f2db0e2a-5dc4-4f7d-9ee6-a4afc3ce07c1). The default `false`, the `true`-only string check, and the `try_convert` limits match those files. A single tree, or a sum wrapped in another call, is not `is_forest()`, so conversion returns empty and setup compiles. No speedup was measured. The documented 64-leaf benefit is the fixed-width cap. The 2048-leaf cap is the little-endian multi-word limit. The UBJ `base_score` sentence is the page's claim. The only `UseFastForest::check` call found is this setup.

### 92. Which class turns a YQL select string into the query tree?

`com.yahoo.search.yql.YqlParser.parse(Parsable)` returns the query tree, a `com.yahoo.search.query.QueryTree`. `ParserFactory.newInstance` returns a `YqlParser` when the syntax is `yql`. `Model.parse` calls that parser with `Parsable.fromQueryModel`, and that parsable copies `Model.getQueryString()`.

The select string is parsed by `ProgramParser.parse(String, String)`. `YqlParser.parse` calls `parseYqlProgram()`, which calls `new ProgramParser().parse("query", currentlyParsing.getQuery())`. `ProgramParser` is package-private. Its `parse` method lexes the string with `yqlplusLexer`, parses `yqlplusParser.program()`, and `convertProgram` walks that tree. A select statement goes through `convertQuery` to `convertSelect`. There the where expression is `convertExpr`, and `convertExpr` returns `OperatorNode<ExpressionOperator>`. When a where clause is present, `convertSelect` passes that node as the second argument of `OperatorNode.create(SequenceOperator.FILTER, source, filter)`. `SequenceOperator.FILTER` is declared as taking a `SequenceOperator` and an `ExpressionOperator`.

`parseYqlProgram` peels grouping, timeout, summary fields, offset, hits, and sorting, then requires the remaining node to be `SequenceOperator.FILTER`. `YqlParser.buildTree` reads argument 1 as `OperatorNode<ExpressionOperator>`, and `convertExpression` returns a `com.yahoo.prelude.query.Item`. `new QueryTree(root)` uses that `Item` as the tree root. `QueryTree` extends `RootItem`.

The where-clause's next type is `OperatorNode<ExpressionOperator>`. The query-tree root is an `Item`. `convertSelect` builds `FILTER` only when a where expression is present. The comment on `convertSelect` marks `where` as optional, so a select with no where clause does not follow this path. The documentation does not name a parser class. It says YQL is parsed into a query tree, and that the same tree can be built with the JSON `where` parameter. That JSON input is `SelectParser`, chosen when the syntax is `json`.

- **Sources:** `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java` (`parse`, `buildTree`, `parseYqlProgram`); `container-search/src/main/java/com/yahoo/search/yql/ProgramParser.java` (`parse`, `convertSelect`); `container-search/src/main/java/com/yahoo/search/query/parser/ParserFactory.java`; `documentation/en/reference/querying/json-query-language.md`
- **Review:** Accepted from [YQL parser](0ed83ccb-3431-4504-9cf1-ac92c55fa939). The return type, the `FILTER` argument, and the `Item` root match those methods. Grouping and the other peeled clauses are not part of the where expression. Individual where operators are omitted. `ProgramParser.parse` has one caller, `YqlParser.parseYqlProgram`.

### 87. Do the nearestNeighbor filter annotations use the same defaults as the rank-profile HNSW filter properties?

When the annotation is absent, the value used is the rank-profile default. The four annotation fields on `NearestNeighborItem` start as null. `assignAnnotationAsDoubleIfNotNull` writes a field only when the annotation is present. The protobuf field is set only when that value is non-null, and the C++ converter copies it only when `has_*` is true. The HNSW blueprint then uses `value_or` of the rank-setup limit.

If the rank profile also leaves the property unset, those limits are approximate-threshold 0.02, filter-first-threshold 0.2, filter-first-exploration 0.01, and post-filter-threshold 1.0. The rank profile emits `vespa.matching.global_filter.lower_limit`, `vespa.matching.nns.filter_first_upper_limit`, `vespa.matching.nns.filter_first_exploration`, and `vespa.matching.global_filter.upper_limit` only when the corresponding property is set. `RankSetup::configure` loads the index-property defaults for the unset case. The schema reference and the query API list the same four numbers.

Comments in `YqlParser` list 0.05 for `hnsw.approximateThreshold`, 0.0 for `hnsw.filterFirstThreshold`, 0.3 for `hnsw.filterFirstExploration`, and 1.0 for `hnsw.postFilterThreshold`. Those comments are not written into the annotation when it is absent. The first three differ from the rank-profile defaults. The post-filter comment is 1.0, the same number as the rank-profile default, and the parser still does not write 1.0 when the annotation is absent. The YQL reference does not document these four annotations.

`RankSetup`'s constructor starts the global-filter lower limit at 0.0. `configure()` then replaces it with the 0.02 index-property default. The constructor's other three values already match 1.0, 0.2, and 0.01.

- **Sources:** `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java` (comment numbers, `assignAnnotationAsDoubleIfNotNull`); `searchlib/src/vespa/searchlib/fef/indexproperties.cpp` (0.02, 1.0, 0.2, 0.01); `searchlib/src/vespa/searchlib/attribute/attribute_blueprint_factory.cpp` (`value_or`); `documentation/en/reference/schemas/schemas.html` (the four rank-profile defaults)
- **Review:** Accepted from [HNSW annotation defaults](8d36cf40-e808-4bef-a514-7ece2b4b0502). The comment numbers and the index-property defaults match those files, and they are not the same three thresholds. The query API's `ranking.matching` cells list the rank-profile numbers. `Matching` starts those fields at null and writes a rank property only when one is set. `Matching.prepare` writes `filter_first_exploration` only inside a `filterFirstThreshold != null` check. That is the query-parameter path, not the annotation path. Which ratio selects exact search, filter-first, or post-filter is a separate question.

### 90. Why does an indexed struct-field string not become a searchable text index?

Text-index derivation never emits an index field for it. `IndexSchema.derive` returns immediately when the field `usesStructOrMap()`. That is true when the field's type, after unwrapping a collection, is a struct or a map. Derivation visits document fields, extra fields, and imported fields. It does not visit a struct-field as its own field, so `indexing: index` on a string inside the struct never becomes an `indexschema` field. The derived-config fixture shows this: `f10` is `array<part>` with `struct-field text { indexing: index | summary }`, and `indexschema.cfg` contains neither `f10` nor `f10.text`. The schema reference states the same limit: for indexed search, a struct-field indexing statement supports only `attribute`.

`IndexingScript` returns on the same struct or map test, except for a position field, so that `index` statement is also absent from the indexing script. `index-info.cfg` still records `f10.text` with commands such as `lowercase`. Those are query commands, not an `indexschema` text index.

On an indexed-search cluster, deployment rejects a struct field configured with `indexing: index` when `fail-when-configuring-indexed-map-of-array` is true. That flag defaults to true and expires on 2026-11-13. When the flag is false, deployment logs a warning that the setting is unsupported and has no effect. The missing text index is the deriver.

- **Sources:** `config-model/src/main/java/com/yahoo/schema/derived/IndexSchema.java` (`usesStructOrMap` return); `config-model/src/main/java/com/yahoo/schema/document/SDField.java` (`getFirstStructOrMapRecursive`); `config-model/src/test/derived/indexschema/indexschema.sd` and `indexschema.cfg`; `documentation/en/reference/schemas/schemas.html` (struct-field indexing); `config-model/src/main/java/com/yahoo/vespa/model/application/validation/ComplexFieldsWithStructFieldIndexesValidator.java`
- **Review:** Accepted from [struct-field index](90fa0e74-b13c-4fd6-a54b-f08c57200cd5). The early return and the missing `f10` index match the current deriver and fixture. The schema's attribute-only sentence is the indexed-search limit. Streaming search, which the same sentence says can use `index` and `summary`, is already in an earlier answer. Proton's rejection of a dotted index name was not used as this reason.

### 85. When does filtered nearestNeighbor search use exact search, filter-first, or distance-first?

Two ratios are compared, and both cutoffs use strict less-than. The estimate is the root blueprint hit ratio, `estimateHits / max(estimateHits, docid_limit)`, or 0 when that denominator is 0. The counted ratio exists only after a global filter is built and `is_active()`: `global_filter->count() / attribute.get_num_docs()`.

The comparisons use the rank-property defaults unless that one value is overridden: lower limit 0.02, filter-first upper limit 0.2, and post-filter upper limit 1.0. The upper limit passed into the decision is that 1.0 multiplied by `min(active_docids + 1, docid_limit) / docid_limit`. A present `hnsw.postFilterThreshold` annotation replaces that upper limit and is not multiplied. The YQL comment numbers are already recorded as not being the values used when the annotation is absent.

If the estimate is less than the lower limit, no global filter is calculated. Nearest-neighbor blueprints are moved to the expensive cost tier, and the algorithm stays `EXACT`. If a global filter is active and the counted ratio is less than the lower limit, the algorithm is `EXACT_FALLBACK`. Both exact algorithms create an `ExactNearestNeighborIterator`. When the filter is active, `doSeek` checks the filter and then computes the distance.

A global filter is calculated when the estimate is less than or equal to the effective upper limit. Above that limit, the filter is a match-everything filter. Filter-first and distance-first run when the filter is active and the counted ratio is not below the lower limit. Levels above 0 are searched with `find_nearest_in_layer`, which has no filter. At level 0, `FilterSearchStrategy::Auto` chooses filter-first when the counted ratio is less than the filter-first limit. That walk checks the filter in `exploreNeighborhoodByOneHop` before a distance is computed. A counted ratio equal to the filter-first limit, and every larger ratio, uses distance-first: `search_layer` computes the distance and then checks the filter before keeping the neighbor. `PathSeer` is a separate level-0 function and is not selected by `Auto`.

The schema reference says exact search and the filter-first heuristic are chosen when the estimated filter hit ratio is less than the threshold, and post-filtering when it is larger. Those directions match the comparisons. The code's second exact check uses the counted ratio, and the code scales the upper limit by the active-document ratio. The schema page does not state either of those.

- **Sources:** `searchcore/src/vespa/searchcore/proton/matching/query.cpp` (estimate comparisons); `searchlib/src/vespa/searchlib/queryeval/nearest_neighbor_blueprint.cpp` (counted ratio and `EXACT_FALLBACK`); `searchlib/src/vespa/searchlib/tensor/hnsw_index.cpp` (`Auto`); `searchcore/src/vespa/searchcore/proton/matching/match_tools.cpp` (active-document scaling); `documentation/en/reference/schemas/schemas.html` (0.02, 0.2, 1.0)
- **Review:** Accepted from [HNSW cutoffs](108fcf16-f45c-4487-aa10-336ae6f82379). The `<` tests for exact and filter-first, and the `<=` test for calculating the filter, match those functions. Equality with the filter-first limit stays on the distance-first walk. The annotation-comment mismatch is already in an earlier answer. `filter-first-exploration` tunes the filter-first walk and does not choose the strategy. With more than one `nearestNeighbor`, the first child that wants a global filter supplies the estimate used to build it. Each operator then applies its own limits to the counted ratio.

### 89. Which index does BM25 read for document frequency and average field length?

Document frequency and average field length come from different selectors. Neither selector picks the largest disk index. The BM25 page says the document-frequency maximum typically comes from the largest disk index. The code takes the greatest hit estimate and does not compare index sizes.

For indexed search, document frequency is that maximum when the query does not supply a document-frequency override and does not replace the IDF with a significance value. `IndexCollection` builds one blueprint per source, the disk indexes and the memory index, in source order. A disk term sets the estimate to that index's dictionary `counts._numDocs`, the number of documents for the word. A memory term sets it to the posting-list size. `SourceBlenderBlueprint::combine` returns `Blueprint::max`. That keeps the greatest `estHits`. An equal positive count keeps the earlier source, because the comparison is strict less-than. `BlueprintBuilder::buildTerm` stores that `estHits` with `ProtonTermData::setDocumentFrequency`, and that count is copied onto every field of the term. If one source searches several index fields, those fields are combined with `OrBlueprint`, whose estimate is a saturated sum, and a single field is unwrapped. The blender then takes the maximum of those per-source estimates.

Average field length is not that maximum. When `bm25(field).averageFieldLength` is unset, `Bm25Blueprint` asks the index collection. `IndexCollection::get_field_length_info` returns `_sources.back()`, the last added searchable. `IndexMaintainer` appends the disk indexes and then appends the current memory index, so the last source is the memory index. The comment on `get_field_length_info` says it returns the newest disk index. The function returns the last source. Streaming search has no index. Its query environment returns average length 100 and does not set a corpus document frequency.

- **Sources:** `documentation/en/ranking/bm25.html` (maximum, typically the largest disk index); `searchlib/src/vespa/searchlib/queryeval/blueprint.cpp` (`Blueprint::max`); `searchlib/src/vespa/searchlib/diskindex/disktermblueprint.cpp` (`counts._numDocs`); `searchlib/src/vespa/searchlib/memoryindex/field_index.cpp` (posting-list size); `searchcore/src/vespa/searchcorespi/index/indexcollection.cpp` (`_sources.back()`); `searchcore/src/vespa/searchcorespi/index/indexmaintainer.cpp` (memory index appended last); `streamingvisitors/src/vespa/searchvisitor/queryenvironment.h` (average 100)
- **Review:** Accepted from [BM25 index source](816d9695-f05b-4894-a6be-64ee97841403). The page's "largest disk index" sentence is kept, and the selector in the code is `Blueprint::max` of the per-index hit estimates. The header comment says newest disk index. After startup the last source is the memory index, so that is the calculator BM25 reads. Fusion is inserted at the front of the collection and is not `_sources.back()`. The per-field maximum and the streaming length of 100 are already in an earlier answer. The new fact is which index supplies each number.

### 100. When a proton match thread is ranking, does it unpack a hit before or after that hit can enter the rank heap?

Before. In `MatchThread::inner_match_loop`, the `do_rank` branch calls `search->unpack(docId)` and then `Context::rankHit`. `rankHit` is what calls `HitCollector::addHit`. `do_rank` is true only when `match_with_ranking` is true. That is `MatchToolsFactory::has_first_phase_rank()`, a non-empty first-phase rank expression, and `MatchParams::save_rank_scores()`, which is `arraySize != 0`.

If a first-phase rank-score drop limit is set, `rankHit` calls `addHit` only when the score is greater than that limit. NaN and infinity scores are converted to negative infinity before that test. `RankedHitCollector::collect` appends while `_hits.size()` is less than `_maxHitsSize`. The call that finds the vector already full heapifies `_hits`. The comparator is a min-heap, so `_hits[0]` is the lowest score. `considerForHitVector` keeps that hit in the ranked vector only when `score > _hits[0].second`. That same call still records the document in the doc-id vector or the bitvector before the heap test.

- **Sources:** `searchcore/src/vespa/searchcore/proton/matching/match_thread.cpp` (`inner_match_loop`, `rankHit`); `searchlib/src/vespa/searchlib/queryeval/hitcollector.cpp` (`collect`, `collectAndChangeCollector`); `searchlib/src/vespa/searchlib/queryeval/hitcollector.h` (`considerForHitVector`, min-heap comparator)
- **Review:** Accepted from [match thread](d4bcf4e7-6859-4125-b37b-cc3104a714ce). The unpack call is ahead of `rankHit` in the ranking branch. Sort-feature recording, which runs only for a hit `rankHit` accepts, is already in an earlier answer. The first `arraySize` ranked hits are appended. The strict greater-than test against the lowest score starts with the hit that finds the vector already full. An equal score does not replace that lowest hit.

### 96. Where is a query item label stored on the way from YQL to ranking?

The label string is `Item.label`, a private `String` in `com.yahoo.prelude.query.Item`. `setLabel` writes that field and marks the item as having a unique id. The query-tree protobuf does not carry the string. `ItemLabelWrapper` has `child`, `unique_id`, and `score`. Its comment says the label is mapped to that id by the rank property `vespa.label.<label>.id`. `LabelWrapperItem.toProtobuf` sets those three fields and does not send `getLabel()`. The C++ `LabelWrapper` stores `_id` and `_score`.

`Model.addLabels` copies the string into the rank-property key `vespa.label.` plus the label plus `.id`. The value is the item's unique id. Unique ids are assigned from 1 during prepare. `RankProperties.put` keeps the key and appends the value. On the wire the key is `StringProperty.name` inside `SearchRequest.rank_properties`. `StringProperty.values` holds the unique id. `MapConverter` calls `StringProperty.newBuilder().setName(key)`, and `mergeToSearchRequestFromRanking` adds those properties. `ProtoConverter::add_multi_props` then calls `dst.add(entry.name(), entry.values(i))`, so the same string is the key in `search::fef::Properties`. Ranking looks the label up as `vespa.label.<label>.id`.

The protobuf member that carries the label string is `StringProperty.name`. No protobuf field's value is the label by itself.

- **Sources:** `container-search/src/main/java/com/yahoo/prelude/query/Item.java` (`label`, `setLabel`); `container-search/src/main/java/com/yahoo/search/query/Model.java` (`addLabels`); `searchlib/src/protobuf/search_protocol.proto` (`StringProperty`, `ItemLabelWrapper`); `searchlib/src/vespa/searchlib/features/utils.cpp` (`getTermByLabel`)
- **Review:** Accepted from [label storage](631b29b2-d4ba-462e-8654-c34f03300c84). The `Item` field, the wrapper's three protobuf fields, and the rank-property key match those files. The features that read a label are already in an earlier answer. `DocsumRequest.rank_properties` is filled by the same merge. The binary item encoding writes the unique id and the wrapper score and does not write the label string.

### 98. Can a query supply the document frequency BM25 uses?

Yes. `bm25`, elementwise BM25, and `bm25` for labels all take inverse document frequency from `Bm25Utils::get_inverse_document_frequency`. That function first calls `lookup_document_frequency`. When the term's unique id is not 0, the lookup reads the ranking property `vespa.term.` plus that id plus `.docfreq`. The property is used only when it has exactly two values. The first is the number of documents containing the term. The second is the document count. BM25 then computes IDF as `log(1 + ((count - frequency + 0.5) / (frequency + 0.5)))`, after clamping `count` to at least 1 and `frequency` into `[1, count]`.

Query preparation writes that property from an explicit document frequency on the term. `Model.addDocumentFrequencies` puts the frequency and then the count under `vespa.term.<uniqueId>.docfreq`. YQL fills those numbers from the annotation `documentFrequency`, a map with keys `frequency` and `count`. The significance page's example is `({documentFrequency: {frequency: 13, count: 101}}"colors")`.

A second property, `vespa.term.<uniqueId>.significance`, is written only when the term has an explicit significance. The YQL annotation name is `significance`. When the document-frequency lookup returns no value, BM25 computes IDF from the term field and then `lookupSignificance` returns this property's number in place of that IDF. When the document-frequency property is used, `get_inverse_document_frequency` returns the IDF from those two numbers and does not read the significance property.

The ranking-property strings are not in the documentation. The documented forms are the annotations. The significance page shows both `documentFrequency` and `significance`. The BM25 page says to set the same IDF across content nodes as the `significance` annotation. The YQL annotation table documents `significance`. It does not document `documentFrequency`.

- **Sources:** `searchlib/src/vespa/searchlib/features/bm25_utils.cpp` (`get_inverse_document_frequency`); `searchlib/src/vespa/searchlib/features/utils.cpp` (`lookup_document_frequency`, `lookupSignificance`); `container-search/src/main/java/com/yahoo/search/query/Model.java` (`addDocumentFrequencies`); `documentation/en/ranking/significance.md` (the two annotations)
- **Review:** Accepted from [document-frequency override](e0c713ef-3f12-410f-980c-1d10db4fea6d). Both property names and the two-value `docfreq` lookup match the current code. A `docfreq` property with unique id 0, or with a value count other than 2, is ignored. Which index supplies the frequency when the property is absent is already in an earlier answer. The significance page lists three ways to provide a global model under a sentence that says two. That count is not part of this answer.

### 93. What object does HNSW receive as the global filter, and what does a check of one document do?

HNSW receives a `const search::queryeval::GlobalFilter&`. `HnswIndex::find_top_k_with_filter` passes the address of that reference into the search, which stores it in `GlobalFilterWrapper`. A null pointer makes the wrapper return true. `find_top_k_with_filter` always passes a pointer. From the nearest-neighbor blueprint the reference is the active global filter, or a `FallbackFilter` when a lazy filter is active too.

A check of one document calls `GlobalFilter::check(docid)`. For a single-vector index that is the filter's own check. For a multi-vector index it is `docid < filter->size()` and then that check. `BitVectorFilter` owns one `BitVector`, and `check` returns `testBit(docid)`. `MultiBitVectorFilter` walks its split points until it finds the vector whose range contains `docid`, then calls `testBit` with that same docid. `testBit` relaxed-loads one `uint64_t` word, `_words[docid >> 6]`, and tests bit `docid % 64`. The `GlobalFilter` comment says the bitvector is a whitelist: a set bit means the document may become a hit, and a cleared bit means it is filtered out.

`EmptyFilter::check` returns false and does not load a word. `Inactive::check` aborts. `FallbackFilter::check` returns the global-filter check and the fallback check.

- **Sources:** `searchlib/src/vespa/searchlib/tensor/hnsw_index.h` (`GlobalFilterWrapper`); `searchlib/src/vespa/searchlib/queryeval/global_filter.cpp` (`BitVectorFilter`, `EmptyFilter`, `Inactive`); `searchlib/src/vespa/searchlib/common/bitvector.h` (`testBit`); `searchlib/src/vespa/searchlib/queryeval/global_filter.h` (whitelist comment)
- **Review:** Accepted from [global filter](fd69cade-c25d-428e-8c63-86b62992da99). The reference type, both wrappers, and `testBit` match those files. When the filter is calculated, and which walk calls `check`, are already in an earlier answer. `LocationLazyFilter` reads stored location values. It is reached as the fallback side of `FallbackFilter`.

### 95. Does Lucene linguistics change how the C++ index matches a term?

No. Lucene linguistics changes which tokens are produced. After that, a term is still matched through Vespa's dictionary and posting lists.

`LuceneLinguistics` extends `SimpleLinguistics` and overrides `getTokenizer()`. It also overrides `equals` and `toString`. `LuceneTokenizer` runs a Lucene analyzer token stream and builds Vespa tokens. The analyzer field name `"F"` is there to satisfy the Lucene API. Query text is tokenized with the same `getTokenizer()`. On write, `TokenExtractor` reads `TERM` annotations from the linguistics span tree, and the memory-index field inverter inserts those words. The C++ sources under `searchlib` do not mention Lucene. The linguistics page says every implementation stores its tokens the same way in the underlying index, and that Lucene linguistics does not store positions in Lucene segment files. The Proton index page says a text index is a per-field dictionary mapped to posting lists, `posocc` with positions by default and `boolocc` when `rank: filter` is set. The pages and this code do not describe a second matcher.

- **Sources:** `lucene-linguistics/src/main/java/com/yahoo/language/lucene/LuceneLinguistics.java`; `searchlib/src/vespa/searchlib/util/token_extractor.cpp`; `searchlib/src/vespa/searchlib/memoryindex/field_inverter.cpp`; `documentation/en/linguistics/linguistics.html`; `documentation/en/content/proton.html` (dictionary and posting lists)
- **Review:** Accepted from [Lucene matching](8fb281be-2924-4b35-8da6-f33f70eed23e). The tokenizer override and the `TERM` extraction match those files. The same-storage sentence and the Lucene segment-file sentence are already in an earlier answer. The disk-index dictionary class itself was not opened. The query path named here is the shared tokenizer and the Proton dictionary.

### 99. After fusion replaces flushed disk indexes, which sources does a query read?

A query term's blueprint is built from the collection `IndexCollection::replaceAndRenumber` installs. `IndexMaintainer::doneFusion` calls it with the new fused disk index and `id_diff`, which is the new fusion id minus the previous fusion id. The function appends the fused index as source id 0. It then copies a previous source only when that source's id is greater than `id_diff`, and renumbers it to `id - id_diff`. A source whose id is less than or equal to `id_diff` is left out.

`FusionRunner::fuse` reads those inputs. When the previous fusion id is not 0, it reads that fusion at relative source 0. It reads each flush in the spec at relative source `flush_id - last_fusion_id`. The new fusion id is the last flush id, so every input's relative id is at most `id_diff`. `IndexCollection::createBlueprint` then builds one child blueprint from every source still in the new collection and mixes them in a `SourceBlenderBlueprint`.

- **Sources:** `searchcore/src/vespa/searchcorespi/index/indexcollection.cpp` (`replaceAndRenumber`, `CreateBlueprintVisitor`); `searchcore/src/vespa/searchcorespi/index/indexmaintainer.cpp` (`doneFusion`); `searchcore/src/vespa/searchcorespi/index/fusionrunner.cpp` (`fuse`)
- **Review:** Accepted from [index fusion](24e93c05-58a2-4174-a631-b73efab27943). The append-at-0 rule and the `id > id_diff` copy match `replaceAndRenumber`. Document frequency and average field length, which read that same collection, are already in an earlier answer. A warmup collection that keeps the previous sources until warmup ends was not opened, so no warmup duration is stated.

### 88. What is a Proton local document id, and when is one assigned or reused?

A Proton local document id (lid) is a `uint32_t` inside one document sub-database. It is not the user-facing document id URI. `DocumentMetaStore` stores `<lid, metadata>` pairs, and the metadata includes the global id. `_gidToLidMap` is a btree from that global id to the lid. `DbDocumentId` stores the lid as `search::DocumentIdT`, which is `unsigned`, and `valid()` is `_lid != 0`. The feed view names the same value `Lid`.

Lid 0 is reserved. The `DocumentMetaStore` constructor calls `ensureSpace(0)` and `setCommittedDocIdLimit(1u)` with that comment. `constructFreeList` scans from lid 1. `holdLids` rejects lid 0, and `move` rejects a from-lid or a to-lid of 0.

A put of a global id that is not already in the store receives a lid only after the free list has been built. `inspect` checks that the free list exists. When the global id is absent, it returns `peekFreeLid`: the lowest free lid, or the metadata-store size when that lowest value is at or past the size. `preparePut` writes that lid onto the operation. `putMetadata` then calls `put`. If the free list is constructed, `put` takes the same lid with `getFreeLid` and inserts the mapping. If the global id is already present and the lid matches the stored one, `put` keeps that lid and updates its metadata.

`StoreOnlyDocSubDB::onReplayDone` calls `constructFreeList`. Before that, `put` stores the lid it was given and does not call `getFreeLid`. The comment on `put` says that use is transaction-log replay, where the lids are already in the log. The same `put` is also the normal feed path after the free list exists.

A removed document's lid can be reused later. `remove` drops the global-id mapping and unregisters the lid. The feed view's remove path then calls `LidReuseDelayer::delayReuse`, which queues the lid. That class comment says reuse waits until references are purged from the memory index and attribute vectors, that the meta-store hold list also blocks queries started before that purge, and that this currently works correctly only when visibility delay is 0. On a force commit, `internalForceCommit` takes those queued lids and `ForceCommitContext` stores them on the `ForceCommitDoneTask`. When that context is destroyed, the task's `run` calls `removes_complete`, which places the lids on `LidHoldList` at the current generation. `LidHoldList::reclaim_memory` sets the free bit once the stored generation is strictly older than `oldest_used_gen`. `getFreeLid` can then return that lid.

Matching uses the lid. `ISearchContext::getDocIdLimit` is the local document id limit, larger than every lid currently in use, and it terminates matching. `FeatureExecutor::execute` takes that local document id. A search iterator seeks by a `uint32_t` docid, and `_endid` is the first docid outside that iterator's legal range.

- **Sources:** `searchcore/src/vespa/searchcore/proton/documentmetastore/documentmetastore.h`; `searchcore/src/vespa/searchcore/proton/documentmetastore/documentmetastore.cpp` (`inspect`, `put`, `remove`, `removes_complete`, `move`); `searchcore/src/vespa/searchcore/proton/documentmetastore/lid_allocator.cpp`; `searchcore/src/vespa/searchcore/proton/documentmetastore/lid_hold_list.cpp`; `searchcore/src/vespa/searchcore/proton/documentmetastore/lidreusedelayer.h`; `searchcore/src/vespa/searchcore/proton/server/storeonlyfeedview.cpp`; `searchcore/src/vespa/searchcore/proton/server/storeonlydocsubdb.cpp` (`onReplayDone`); `searchcore/src/vespa/searchcore/proton/server/forcecommitdonetask.cpp`; `searchcore/src/vespa/searchcore/proton/common/dbdocumentid.h`; `searchcore/src/vespa/searchcore/proton/matching/isearchcontext.h`; `searchlib/src/vespa/searchlib/fef/featureexecutor.h`
- **Review:** Accepted from [Proton local document id](18dc8ca2-56c1-45c1-93ba-48d7636c27cd). `delayReuse` is the feed-view remove path, not `DocumentMetaStore::remove` itself. The `put` comment says the function should only be called before `constructFreeList`, and the code also calls it after the free list exists. `_endid` is the first docid outside the iterator range. The replay caller that supplies lids before `constructFreeList` was not opened. The user-facing document id URI is already in an earlier answer.

### 97. What do near and onear require, and what distance is used when the query does not set one?

`near` and `onear` are used as `field contains near(...)` and `field contains onear(...)`. Both match only when every positive term occurs in that field within the distance. `near` accepts the terms in any order. `onear` requires the query order. A negative term is written `!"term"`, must follow the positive terms, and excludes a match when that term appears within `exclusionDistance`. That annotation defaults to `(distance + 1) / 2`. The YQL parser writes that default only when a negative term is present and the query does not set `exclusionDistance`.

Distance is the maximum indexed position difference. The distance annotation says every matching term must fit in `[P, P + distance]`, where `P` is the first term's position, so a difference equal to `distance` matches. The documented default is 2. `NearItem.defaultDistance` is 2, and both `new NearItem()` and `new ONearItem()` set 2. `populateNearItem` replaces that value only when a `distance` annotation is present.

The unordered matcher treats the window end as the earliest position plus the distance, and a term at that end still matches. The ordered matcher anchors on the first argument. Each later argument must occur at a strictly later position, and a position equal to the window end still matches. The reference says `onear` with distance equal to the number of terms minus one is equivalent to `phrase`. On a multi-value field, the reference says distance is calculated between adjacent elements when the rank profile sets `element-gap`.

- **Sources:** `documentation/en/reference/querying/yql.html` (`near`, `onear`, `distance`); `container-search/src/main/java/com/yahoo/prelude/query/NearItem.java`; `container-search/src/main/java/com/yahoo/prelude/query/ONearItem.java`; `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java` (`populateNearItem`); `searchlib/src/vespa/searchlib/queryeval/nearsearch.cpp`; `searchlib/src/vespa/searchlib/query/streaming/onear_query_node.h`
- **Review:** Accepted from [Near and onear distance](0470de93-d923-4d8b-876d-98d7c76efbea). The default of 2 and the inclusive window match the YQL distance annotation and `!(lastAllowed < maxOccurrence)` in `nearsearch.cpp`. The ordered scan advances while the previous position is not strictly earlier. A streaming test that accepts positions 0, 2, and 4 at distance 4 was not copied into the answer. A claimed simple-query rewrite of distance 0 to 2 was not found, so it is not stated. `element-gap` is already in an earlier answer.

### 86. What causes Proton to flush the memory index into a new disk index?

The default flush strategy is `MEMORY`. `Proton` installs `MemoryFlush` from `flush.memory` through `MemoryFlushConfigUpdater::convertConfig`. The memory index is the flush target named `memoryindex.flush`. `can_flush` is true only when the handler's current serial is greater than the flushed serial.

`MemoryFlush::getFlushTargets` asks for a flush when an eligible target crosses a threshold, or when the first target after sorting needs an urgent flush. Urgent targets sort first. Otherwise one reason is chosen, and a stronger reason replaces a weaker one: memory gain, then transaction-log size, then disk bloat, then age. The memory index is written when it sorts first and `initFlush` returns a task. `initFlush` returns no task when the current memory index has not received a document insert, there are no source-selector changes, there is no frozen memory index to write, and `_flush_empty_current_index` is false.

The thresholds in `proton.def` and the content reference are:

- One component's memory gain is at least `flush.memory.each.maxmemory`, default 1073741824 bytes. In services.xml that is `component/maxmemorygain`. This target's gain is the current memory index's used bytes minus its static footprint, plus each frozen memory index's used bytes, plus one source-selector size per frozen index. Its disk gain is always 0, so it does not trip the per-component disk-bloat test.
- The sum of memory gain over eligible targets is at least `flush.memory.maxmemory`, default 4294967296 bytes (`total/maxmemorygain`). The largest memory gain is then flushed.
- Unflushed age is at least `flush.memory.maxage.time`, default 111600 seconds. Age is now minus the last flush time, or minus the `MemoryFlush` start time when that last flush time is not after the epoch. The oldest last flush time is then flushed.
- Summed transaction-log size is above `flush.memory.maxtlssize`, default 21474836480 bytes, when there is no active flush for that handler or this target's last flush time is strictly earlier than that flush's start. The largest estimated unflushed transaction-log tail is then flushed.

`convertConfig` caps both memory thresholds at one quarter of the machine's memory size. In conservative memory mode the updater multiplies both by `flush.memory.conservative.memorylimitfactor`, default 0.5. The high watermark that enters that mode defaults to 0.95, and the low watermark that leaves it defaults to 0.9.

`needUrgentFlush` is true when frozen memory indexes are more than `_maxFrozen` of 10, or the memory gain is greater than 16 GiB, or `urgent_memory_index_flush` is true. That flag is set when a schema change leaves an index field with mismatched interleaved features. `MemoryIndex::freeze` only sets `_frozen`. A non-empty current memory index is moved onto the frozen list when the schema is set, and the later flush writes it.

`MemoryFlush::Config()` defaults to 4000 MiB global memory, 1000 MiB per component, a disk-bloat factor of 0.2, and 24 hours. `Proton` does not use that constructor. The installed disk-bloat factor is 0.25.

`initFlush` creates a new memory index, and `doneInitFlush` installs it as the current index before the write. `flushMemoryIndex` calls `MemoryIndexWrapper::flushToDisk`, which builds an `IndexBuilder` for `index.flush.{id}` and `MemoryIndex::dump` writes into it. `doneFlush` replaces that source with the loaded disk index. `dump` does not empty the memory index. A frozen index is released after it is written, and the dumped current index is released when the flush arguments are destroyed. The proton page says this job shrinks memory by writing a disk index and then triggers fusion.

The content reference says flush-on-shutdown defaults to true. `DomContentSearchClusterBuilder.getFlushOnShutdown` uses true only when the deploy is not hosted, when the element is omitted.

- **Sources:** `configdefinitions/src/vespa/proton.def` (`flush.strategy`, `flush.memory`); `documentation/en/reference/applications/services/content.html` (`maxmemorygain`, `maxage`, `maxsize`, `flush-on-shutdown`); `documentation/en/content/proton.html` (memory index flush); `searchcore/src/vespa/searchcore/proton/server/proton.cpp`; `searchcore/src/vespa/searchcore/proton/server/memoryflush.cpp`; `searchcore/src/vespa/searchcore/proton/server/memory_flush_config_updater.cpp`; `searchcore/src/vespa/searchcorespi/index/indexflushtarget.cpp`; `searchcore/src/vespa/searchcorespi/index/indexmaintainer.cpp`; `searchcore/src/vespa/searchcore/proton/index/memoryindexwrapper.cpp`; `searchlib/src/vespa/searchlib/memoryindex/memory_index.cpp`; `config-model/src/main/java/com/yahoo/vespa/model/builder/xml/dom/DomContentSearchClusterBuilder.java`
- **Review:** Accepted from [Memory index flush](4c41813a-a745-4517-bb8a-201295a4adf0). The installed thresholds are the `proton.def` defaults. `MemoryFlush::Config()` is a different set and is not what `Proton` installs. The memory index's disk gain of 0 is `IndexFlushTarget::getApproxDiskGain`. No document-count threshold was in the checks that were read. `proton.triggerFlush` and the prepare-restart cost subset were not opened, so they are not stated. Which sources a query reads after fusion is already in an earlier answer.

### 78. What do match-features and summary-features return, and when is each calculated?

Both lists are rank features declared in a rank profile, either as a colon list or as a brace block, with an optional `inherits` clause. With no local list, the profile takes the single non-empty list inherited from its parent profiles, or an empty set. Two inherited profiles that define different non-empty lists make deployment throw from `uniquelyInherited`. An `inherits` clause unions the named parents' lists with the local entries. The schema reference says `match-features {}` drops inherited match features. An empty `summary-features` block is parsed by the same form and stored as a local list. A compound expression must be wrapped in a function to be listed. A function that takes arguments cannot be a summary feature, and a function with no arguments can be either list.

In the default JSON result, a hit's `fields` object contains `matchfeatures` and `summaryfeatures`. A scalar is stored as a double. Any other tensor is stored as tensor data. The schema reference says match-features are computed in the match protocol phase, and summary-features are computed in the fill phase and re-calculated for the global top hits. The ranking-expressions page says match-features are computed for every hit returned in the first phase, before fill, and summary-features only for the hits that are filled.

On an indexed node, `MatchMaster` puts `ExtractFeatures::get_match_features` on the search reply, in phase `MATCH_FEATURES`. Summary features come from `DocsumMatcher::get_summary_features`, in phase `SUMMARY_FEATURES`, for the document ids in that docsum request. A document summary with `omit-summary-features` omits them. The summary writer also sets `vespa.summaryFeatures.cached` to `0.0`. The pages read here do not mention that key.

Streaming search calculates both at the end of the same visit. `fillSearchResult` adds the match features for the hits kept by the visitor. `onCompletedVisiting` calculates the summary features. `StreamingBackend.doPartialFill` ignores a later fill and traces that streaming is single-pass.

A listed function is deployed as `rankingExpression(name)` and renamed back to the name written in the profile. The result-format page says Vespa 8 renders that written name, and that putting `rankingExpression(name)` in the list keeps the old key. Some examples still show a `rankingExpression(...)` key.

- **Sources:** `documentation/en/reference/schemas/schemas.html` (`match-features`, `summary-features`, `omit-summary-features`); `documentation/en/reference/querying/default-result-format.html` (`matchfeatures`, `summaryfeatures`); `documentation/en/ranking/ranking-expressions-features.html` (accessing feature values); `config-model/src/main/java/com/yahoo/schema/RankProfile.java`; `searchcore/src/vespa/searchcore/proton/matching/match_master.cpp`; `searchcore/src/vespa/searchcore/proton/matching/docsum_matcher.cpp`; `searchsummary/src/vespa/searchsummary/docsummary/summaryfeaturesdfw.cpp`; `streamingvisitors/src/vespa/searchvisitor/searchvisitor.cpp`; `streamingvisitors/src/vespa/searchvisitor/rankprocessor.cpp`; `container-search/src/main/java/com/yahoo/vespa/streamingvisitors/StreamingBackend.java`
- **Review:** Accepted from [Match and summary features](936a36dd-45df-43d4-9534-9444af81b7e9). The match-phase and fill-phase split matches the schema reference and `MATCH_FEATURES` / `SUMMARY_FEATURES`. `vespa.summaryFeatures.cached` is written by the summary writer and is not in the pages that were read. The function-with-arguments limit and the document-summary fetch are already in earlier answers.

### 94. When does a successfully fed document become visible to a query?

A successful write is visible to later queries when the client is acknowledged. The feed sizing guide says a reply is sent only after the operation is written to the transaction log and applied, and it calls that point visible in search and get. The writing guide says an asynchronously acknowledged write is persisted, fully processed, and visible in subsequent queries. The features page says writes are acknowledged when they are durable and visible in queries, in a few milliseconds. That timing is the page's statement, not a configured delay. The consistency page says that after a successful response, search-index changes are immediately visible by default, and that once a write is complete every index update is visible. It also says a search can observe a partial update after the write has started and before it is complete. By default the write is sent to every available replica before the response.

Queries are passed to the ready sub-database, and only active documents produce results. A not-ready copy is stored and not indexed.

`visibility-delay` defaults to 0 and has a max of 1 second. The services reference says it controls TTL caching for parent-child imported fields. The feature-tuning page says a value greater than 0 enables a cache for the child-to-parent indirection. Neither page describes it as a wait before a put or remove can match. `proton.def` comments that `documentdb[].visibilitydelay`, default 0.0, is how many seconds are allowed from when a document is received until it is visible in the index, and `maxvisibilitydelay` defaults to 1.0. The configured value is clamped by that maximum. A global document type is given visibility delay 0. A value greater than 0 enables the imported-attribute search cache, and a job that clears that cache. If the delay is below 100 ms and not 0, that job's interval is raised to 100 ms. Each sub-database constructs `PendingLidTracker`. Its comment says that tracker is for visibility delay 0 and an implicit commit. The feed path does not use the number to postpone that commit.

A memory-index `commit()` makes inserts and removes searchable. Attribute commit runs in the same force-commit. The client reply is sent when the feed token is destroyed. A put, and a remove that has a previous document id, passes that token to the transaction-log append. `startCommit` keeps those append callbacks in `CommitResult`, and `initiateCommit` holds that result until the force-commit context is destroyed, so the reply is not sent before that commit. A remove with no previous document id and no valid id in this database sets the result and returns without that append.

- **Sources:** `documentation/en/performance/sizing-feeding.html` (transaction log and reply); `documentation/en/basics/writing.html` (acknowledged writes); `documentation/en/content/consistency.md` (write visibility); `documentation/en/reference/applications/services/content.html` (`visibility-delay`); `documentation/en/performance/feature-tuning.html` (parent-child cache); `documentation/en/content/proton.html` (ready sub-database); `configdefinitions/src/vespa/proton.def` (`visibilitydelay`, `maxvisibilitydelay`); `searchcore/src/vespa/searchcore/proton/server/documentdbconfigmanager.cpp`; `searchcore/src/vespa/searchcore/proton/server/maintenance_jobs_injector.cpp`; `searchcore/src/vespa/searchcore/proton/server/feedhandler.cpp`; `searchlib/src/vespa/searchlib/memoryindex/memory_index.h` (`commit`); `searchlib/src/vespa/searchlib/transactionlog/common.h` (`CommitResult`)
- **Review:** Accepted from [Feed visibility to search](e1e7bf58-9029-4bae-a226-802e9e2edb05). The services reference and the feature-tuning page describe `visibility-delay` as the parent-child cache. The `proton.def` comment still describes an index-visibility delay, and the feed path that was read does not postpone commit by that number. A remove that has a document type and a valid id in this database still goes through append, so only the branch with neither a previous id nor a valid id skips it. Partial-update operators are already in an earlier answer. No container was started.


























