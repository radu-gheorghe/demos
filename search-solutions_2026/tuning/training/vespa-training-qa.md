# Vespa training Q&A

Progress: **100/100** accepted. Last update: 2026-11-09.

## Slots

| # | Status | Band | Topic |
| ---: | --- | --- | --- |
| 1 | done | concept | redundancy and searchable-copies |
| 2 | done | concept | bucket |
| 3 | done | concept | deployment.xml |
| 4 | done | concept | config server vs config proxy |
| 5 | done | concept | document/v1 GET vs search |
| 6 | done | concept | global document type |
| 7 | done | concept | reference field |
| 8 | done | concept | store-only mode |
| 9 | done | concept | validation-overrides.xml |
| 10 | done | concept | document store |
| 11 | done | concept | transaction log |
| 12 | done | concept | ideal state |
| 13 | done | concept | content cluster group |
| 14 | done | concept | cluster controller |
| 15 | done | concept | distributor |
| 16 | done | schema | normalizing |
| 17 | done | schema | paged attributes |
| 18 | done | schema | attribute match: cased |
| 19 | done | schema | schema-level constant tensor |
| 20 | done | schema | num-threads-per-search |
| 21 | done | schema | rank-score-drop-limit |
| 22 | done | schema | dynamic summary |
| 23 | done | schema | summary field source |
| 24 | done | schema | URI field |
| 25 | done | schema | hamming distance cell type |
| 26 | done | schema | indexing: input |
| 27 | done | schema | matched-elements-only |
| 28 | done | schema | firstPhaseRank |
| 29 | done | schema | termwise-limit |
| 30 | done | schema | predicate field bounds |
| 31 | done | schema | attribute sorting block |
| 32 | done | schema | bm25 averageFieldLength override |
| 33 | done | query | phrase |
| 34 | done | query | equiv |
| 35 | done | query | rank query operator |
| 36 | done | query | dotProduct |
| 37 | done | query | fuzzy |
| 38 | done | query | numeric range endpoints |
| 39 | done | query | model.defaultIndex |
| 40 | done | query | model.restrict |
| 41 | done | query | model.locale |
| 42 | done | query | model.sources |
| 43 | done | query | ranking.listFeatures |
| 44 | done | query | where true in indexed search |
| 45 | done | query | grouping max and precision |
| 46 | done | query | model.filter |
| 47 | done | query | cluster document selection |
| 48 | done | query | rank-profile strict |
| 49 | done | query | freshness |
| 50 | done | query | closeness vs distance |
| 51 | done | product | attribute flush |
| 52 | done | product | lid-space compaction |
| 53 | done | product | flush-on-shutdown |
| 54 | done | product | log data store |
| 55 | done | product | bucket split |
| 56 | done | product | maintenance state |
| 57 | done | product | coverage minimum |
| 58 | done | product | default redundancy |
| 59 | done | product | reindexing vs reprocessing |
| 60 | done | product | feed write filter |
| 61 | done | product | min-redundancy |
| 62 | done | product | garbage-collection selection |
| 63 | done | product | search group dispatch |
| 64 | done | product | sync-transactionlog |
| 65 | done | product | bucket merge |
| 66 | done | product | distribution bits change |
| 67 | done | product | hierarchical distribution |
| 68 | done | product | bucket split trigger |
| 69 | done | precise | sameElement |
| 70 | done | precise | weightedSet query operator |
| 71 | done | precise | in operator |
| 72 | done | precise | negated query term |
| 73 | done | precise | default query term weight |
| 74 | done | precise | connectivity |
| 75 | done | precise | userQuery |
| 76 | done | precise | language annotation |
| 77 | done | precise | distanceThreshold |
| 78 | done | precise | target-hits-max-adjustment-factor |
| 79 | done | precise | ranking.rerankCount |
| 80 | done | precise | presentation.timing |
| 81 | done | precise | trace.timestamps |
| 82 | done | precise | grouping session cache |
| 83 | done | internal | source selector |
| 84 | done | internal | active document state |
| 85 | done | internal | equal relevance hit order |
| 86 | done | internal | default threads per query |
| 87 | done | internal | Juniper snippet |
| 88 | done | internal | string attribute enum store |
| 89 | done | internal | omitted feed timestamp |
| 90 | done | internal | ready, not-ready, removed |
| 91 | done | internal | bucket database during query |
| 92 | done | internal | config generation |
| 93 | done | internal | failed write response |
| 94 | done | internal | default maxHits and maxOffset |
| 95 | done | internal | anntimebudget |
| 96 | done | internal | wand scoreThreshold |
| 97 | done | internal | interleaved posting features |
| 98 | done | internal | memory index insert vs commit |
| 99 | done | internal | fusion warmup sources |
| 100 | done | internal | global-phase vs summary fetch |

## Accepted

### 3. What does deployment.xml control?

`deployment.xml` controls how an application is deployed. It sits in the root of the application package. The reference applies to Vespa Cloud. The application-package reference marks the file required for Vespa Cloud, and required when deploying to the prod environment. It is ignored, with some exceptions, when deploying to the dev environment.

It specifies which environments and regions the application is deployed to during automated application deployment, and as which application instances. Deployment progresses through the test and staging environments to the prod environments listed in the file. If no `instance` is specified, the children of the root belong to an instance with id `default`.

The same reference also declares cloud account and empty-host TTL, production block windows, scheduled backups of production content clusters, Enclave resource tags, upgrade rollout, delays and parallel or serial steps, production tests, tester container resources, global and private endpoints, and which zones take over for which others in a BCP group. The `dev` element can set a different cloud account, tags, private endpoints, and availability zones per region. A `region` under `dev` does not cause a deployment to that zone; it applies only when deploying to that dev zone. The endpoints section for dev says private endpoints are only supported in prod. `empty-host-ttl` has no effect without a cloud account.

Tests are always run regardless of `deployment.xml`. Deploying without testing is done by removing the test files from the application package. Production tests are optional and are configured in the file.

Sources: `documentation/en/reference/applications/deployment.html`, `documentation/en/reference/applications/application-packages.html`, `documentation/en/basics/applications.html`, `documentation/en/operations/production-deployment.html`, `documentation/en/operations/automated-deployments.html`, `documentation/en/learn/tenant-apps-instances.html`.

Review: Accepted from [deployment.xml](6db5c078-fa21-4068-8cff-370b1cfef614). The `dev` section names private endpoints among the settings it can change, and the endpoints section for dev says private endpoints are only supported in prod. No page said a self-hosted install skips the file; the reference is marked for Vespa Cloud.

### 2. What is a Vespa bucket?

A bucket is the set of documents that share a chosen number of least significant bits of a 58-bit numeric location derived from the document id. Content nodes store replicas of a bucket. In the document API a bucket is a bucket space plus a bucket id. The spaces are named `default` and `global`. Documents of different schemas normally share the default space. Document types marked global are stored in the global space.

A bucket id is a 64-bit value. The high 6 bits count how many of the other bits are in use, from 1 through 58. One bucket id contains another when the other uses at least as many bits and those bits match.

`BucketIdFactory` assigns each document an id that uses 58 bits: the low 32 bits of the id scheme's location, and 26 bits taken from the document global id after its first 4 bytes. The location is the `n=` number when that key is set, an MD5 of the `g=` value when that key is set, and otherwise an MD5 of the namespace-specific part. The global id is an MD5 of the full document id string, with its first 4 bytes replaced by the low 32 bits of that location. The buckets page says a 58-bit location is typically an MD5 of the whole identifier, and that current schemes let the 32 least significant bits be overridden while the remaining 26 come from the MD5.

The cluster distribution bit count is how many of those location bits define the buckets mapped to distributors. The default distribution type is `loose`. In loose mode the count is 8 for 1–4 nodes, 16 for 5–199 nodes, and 24 from 200 nodes upward. The same table is what `DistributionBitCalculator` returns for loose mode. Vespa Cloud locks the count at 16. The config model also uses 16 when the zone environment is dev, perf, or prod and the zone is not the default zone. Otherwise it uses the calculator for the configured mode. If a previous model had a higher count, the model keeps that higher count.

Sources: `documentation/en/content/buckets.html`, `documentation/en/content/idealstate.html`, `documentation/en/reference/applications/services/content.html`, `documentation/en/writing/visiting.html`, `document/src/vespa/document/bucket/bucketid.h`, `document/src/vespa/document/bucket/bucketid.cpp`, `document/src/vespa/document/bucket/bucketidfactory.cpp`, `document/src/vespa/document/base/idstring.cpp`, `document/src/main/java/com/yahoo/document/GlobalId.java`, `document/src/main/java/com/yahoo/document/FixedBucketSpaces.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/DistributionBitCalculator.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/cluster/ContentCluster.java`.

Review: Accepted from [Vespa bucket](b7cff3ff-2749-483c-bee2-db6039497f84). The loose-mode counts match the ideal-state table and `DistributionBitCalculator` for loose mode. `bucketid.h` still describes a legacy layout with 28 global-id bits; the factory and the buckets page use 26. The 16-bit config-model path is the zone check in `ContentCluster.distributionBits`, not a separate hosted flag in that `if`. Split and merge are left for later questions.

### 4. What does the config server do that the config proxy on a node does not?

The config server cluster is where an application package becomes the live system. Its deploy API, port 19071, accepts upload, prepare, and activate. Prepare stores the package under `$VESPA_HOME/var/db/vespa/config_server/serverdb/tenants/default/sessions/[sessionid]` and in ZooKeeper at `/config/v2/tenants/default/sessions/[sessionid]/userapp`. It validates the package, assembles the system model, and returns required actions. The deploy API groups those actions as restart, reindex, and refeed. Activate publishes the session by writing its session id to `/config/v2/tenants/default/applications/default:default:default`. A write returns once a majority of the config servers have persisted the change. Each config server embeds ZooKeeper on ports 2181–2183. Config servers redistribute application data to a config server that is added later. On a minor upgrade the config server translates between config definition versions when the requested definition and the model that produced it differ. The config server process itself keeps file-based configuration at generation 0. Packages it deploys are configuration for the other Vespa nodes.

On every node the config proxy is the liaison to that cluster. Clients on the node ask it for config on localhost port 19090. It caches config in memory, picks a config server from `VESPA_CONFIGSERVERS`, and switches to another if that host is unavailable or returns an error. It also runs the node-local file-distribution and URL-download RPC servers and downloads those files from a config source. In `memorycache` mode it serves only the in-memory cache and does not contact a config server. That cache is dropped when the proxy process restarts. Deploying a package, assembling the model, and keeping the replicated application data stay with the config servers.

Sources: `documentation/en/applications/config-system.html`, `documentation/en/operations/self-managed/configuration-server.html`, `documentation/en/operations/self-managed/config-proxy.html`, `documentation/en/operations/self-managed/files-processes-and-ports.html`, `documentation/en/reference/api/deploy-v2.html`, `documentation/en/reference/applications/application-packages.html`, `config-proxy/src/main/java/com/yahoo/vespa/config/proxy/ProxyServer.java`, `config-proxy/src/main/java/com/yahoo/vespa/config/proxy/filedistribution/FileDistributionAndUrlDownload.java`.

Review: Accepted from [Config server versus proxy](427232e4-6083-4f75-9bb1-b4df7ba5bff5). The application-package page names restart and refeed as examples of prepare actions, and the deploy API lists restart, reindex, and refeed. The ZooKeeper userapp path is the configuration-server page; the application-package page stores the session directory one level above `userapp`. The post-activate subscription path is already in the test set and is not repeated.

### 5. How does a document/v1 GET differ from a search query?

A single-document read is an HTTP GET to `/document/v1/<namespace>/<document-type>/docid/<document-id>`. The same reference also lists `group` and `number` paths for ids that use those keys. The container cluster needs `document-api`. Optional parameters on this GET are `cluster`, `fieldSet`, `timeout`, and `tracelevel`. The handler dispatches a get for that document id. It does not build a query or run a search chain, so this request does not match or rank. If `fieldSet` is omitted, the handler asks for `<document-type>:[document]`. The reference describes the default `[document]` fieldset as all document fields. A found document is HTTP 200 JSON with `pathId`, the document `id`, and a `fields` object. A missing document is HTTP 404. The reference says 404 is only used when getting documents. `pathId` is always present, `id` is present for a single-document operation, `fields` is present for a successful get, and a failed response includes a `message`. On the same page, a GET whose path has no document id is a visit, described there as a linear scan over a selection.

A search is a GET or POST to `/search/`. The search handler builds a query and runs the search chain, including fill. That request matches, ranks, and can group. Vespa searches every content cluster unless the query names sources. The default JSON result is a `root` tree. Each hit has a `relevance` value, the rank score, and `fields` from the requested document summary. For a document hit, `id` is the full document id when the filled summary includes the `documentid` field. Otherwise it is an internally generated id of the form `index:[source]/[node-index]/[hex-gid]`.

Reads are consistent on a best-effort basis and are not guaranteed to be linearizable. On a get, the client does not observe a partially updated document: for that read, writes behave as atomic. If replicas diverge, the distributor read-repairs and the client receives the version with the newest timestamp. A search can observe a partial update after a write has started and before it has finished, because updates are not atomic across index structures. Once the write is complete, the index updates are visible. A search can also observe a transient loss of coverage while nodes are down.

Sources: `documentation/en/reference/api/document-v1.html`, `documentation/en/content/consistency.md`, `documentation/en/querying/query-api.html`, `documentation/en/reference/querying/default-result-format.html`, `vespaclient-container-plugin/src/main/java/com/yahoo/document/restapi/resource/DocumentV1ApiHandler.java`, `container-search/src/main/java/com/yahoo/search/handler/SearchHandler.java`.

Review: Accepted from [Document GET versus search](12fb6ed4-4ce7-4678-aa87-aa00b8d1fb4a). The omitted `fieldSet` becomes `<document-type>:[document]` in `DocumentV1ApiHandler`; the reference names the default fieldset `[document]`. A 404 still carries `pathId`, `id`, and `message`. Read-repair and partial-update visibility are the consistency page, not a trace through the distributor. Visit is only the path contrast on that GET section.

### 1. What do redundancy and searchable-copies each control, and what are their defaults?

`redundancy` is set on the content cluster in `services.xml`. On Vespa Cloud it is the number of stored copies of each document per group. Self-managed, it is the total number of copies the cluster keeps. A redundancy of 2 allows one node to fail before data is unavailable, until replicas are created elsewhere. It can be changed without restarting nodes. The content reference states no numeric default. The config model rejects a cluster that sets neither `redundancy` nor `min-redundancy`. When `min-redundancy` is set, the redundancy other settings see is at least `ceil(min-redundancy / groups)` per group on Vespa Cloud, and a total of at least `min-redundancy` when self-managed.

`searchable-copies` is optional under `proton` in that content cluster. It sets how many of the stored copies are indexed and therefore searchable. On Vespa Cloud the count is per group and capped at redundancy. Self-managed, it is a total split evenly across groups and must divide evenly by the number of groups. A value below redundancy leaves some stored copies not ready, so a node failure makes those documents unsearchable until another copy is indexed. It can be changed without a node restart. A reduction does not free resources until the content nodes restart.

If `searchable-copies` is omitted, a streaming-only cluster defaults it to redundancy. Otherwise `RedundancyBuilder` matches the content reference: on Vespa Cloud, 1 per group when there is more than one group, and otherwise 2, or redundancy when redundancy is lower. Self-managed, the total is 1 when redundancy is 1, and otherwise the greater of 2 and the number of subgroups. A cluster with both indexed and streaming schemas takes that non-streaming default. The schema reference instead calls equality with redundancy the default, in the sentence that says `fast-access` is then a no-op.

Sources: `documentation/en/reference/applications/services/content.html`, `documentation/en/reference/schemas/schemas.html`, `config-model/src/main/java/com/yahoo/vespa/model/content/cluster/RedundancyBuilder.java`.

Review: Accepted from [Redundancy and searchable copies](4d410a5d-818e-42d2-b951-60614336c599). The omitted searchable-copies numbers are `RedundancyBuilder.build`, and they match the content reference. The schema page's "(default)" is the equality case, which is not what the builder installs. The self-managed count uses `storageGroup.subgroups.size()`.

### 6. What does global="true" on a document type mean?

`global="true"` is an optional attribute on a `document` element in a content cluster in `services.xml`. The default is false. It marks that document type as globally distributed. The services reference says this is supported only for `mode="index"`.

Documents of that type are stored in the global bucket space. The global distribution sets redundancy and ready copies to the number of leaf storage nodes, so a bucket's ideal replicas are the storage nodes that are up, across groups. A write of such a document runs on all content nodes, and each content node must be sized to hold all of these documents plus its share of ordinary documents. Ordinary document types stay in the default bucket space. On a cluster change, global documents are merged to a new or outdated node before ordinary documents. Until that finishes, the node is put in maintenance in the default bucket space and does not serve queries.

A reference can target only a document type that is globally distributed. Deployment fails if the target type is absent from that cluster's `services.xml`, or is declared there without `global="true"`. The parent-child example has the global type `campaign` reference the global type `advertiser`. A reference cannot be a self-reference, and two types cannot reference each other.

Sources: `documentation/en/reference/applications/services/content.html`, `documentation/en/schemas/parent-child.html`, `documentation/en/reference/schemas/schemas.html`, `documentation/en/writing/visiting.html`, `vdslib/src/vespa/vdslib/distribution/global_bucket_space_distribution_converter.cpp`, `vdslib/src/tests/distribution/global_bucket_space_distribution_test.cpp`, `config-model/src/main/java/com/yahoo/vespa/model/content/GlobalDistributionValidator.java`, `clustercontroller-core/src/main/java/com/yahoo/vespa/clustercontroller/core/MaintenanceWhenPendingGlobalMerges.java`.

Review: Accepted from [Global document type](9f30dda9-b3df-4c41-a50c-37302754c922). The converter sets redundancy and ready copies to the leaf storage-node count. The distribution test drops a node marked down from the ideal set. `GlobalDistributionValidator` checks that a reference target is listed and global. Its class comment mentions a redundancy check that the method body does not perform. Import-field syntax is already in the test set.

### 9. What is validation-overrides.xml for?

`validation-overrides.xml` is an optional file at the root of an application package, next to `services.xml`. It names deployment validations that may proceed for a limited time. Those validations protect against inadvertently corrupting a production instance.

The file is a `validation-overrides` element with any number of `allow` elements. Each `allow` contains one validation id. `until` is mandatory: the last day the override applies, as an ISO-8601 date in UTC. The reference allows a date at most 30 days ahead. `ValidationOverrides` keeps the override in force through that UTC day, until 00:00 UTC on the next day, and rejects an `until` when now plus 30 days is still before that end. Entries with a past `until` are ignored. Entries with unknown ids are ignored. `comment` is optional.

The ids in `ValidationId`, with the description stored on each, are: `access-control` (internal, zones where there should be no access control); `certificate-removal`; `cluster-size-reduction` (marked not used); `config-model-version-mismatch` (internal); `content-cluster-removal` (removal or id change of content clusters); `schema-removal` (removal of a schema deletes its documents); `data-plane-token-removal`; `deployment-removal` (removal of production zones from `deployment.xml`); `field-type-change`; `global-document-change`; `global-endpoint-change`; `hnsw-settings-change`; `indexing-change`; `indexing-mode-change` (streaming, indexed, or store-only); `paged-setting-removal`; `redundancy-increase` (marked not in use); `redundancy-one` (redundancy 1 on first deployment); `minimum-node-count` (fewer than 2 nodes in production on first deployment); `resources-reduction` (a reduction greater than 50% of the current max total resources); `skip-old-config-models` (internal); `tensor-type-change` (marked not used); `zone-endpoint-change`. `ValidationId.from` also accepts `content-type-removal` and maps it to `schema-removal`.

Sources: `documentation/en/reference/applications/validation-overrides.html`, `config-model-api/src/main/java/com/yahoo/config/application/api/ValidationId.java`, `config-model-api/src/main/java/com/yahoo/config/application/api/ValidationOverrides.java`.

Review: Accepted from [validation-overrides.xml](6a949370-9164-48ea-9eab-35ecefd730e3). The id list is the enum, including the three constants whose descriptions say they are unused. `content-type-removal` is an alias in `from`, not a separate constant. Call sites that raise each validation were not traced.

### 12. What is ideal state?

A bucket's ideal state is the set of content nodes that should store it. The distribution algorithm, also called the ideal state algorithm, takes the bucket id, which nodes are available, and their capacities, and returns those nodes in preference order. Redundancy decides how many of the highest-order content nodes should hold copies. The cluster controller maintains the cluster state and broadcasts a new state to the nodes. Distributors use that state and the algorithm to decide which content nodes should have which bucket.

The cluster is in ideal state when every bucket is located that way and no maintenance operation is still required. On each distributor, `IdealStateManager` checks buckets against that target and schedules a correcting operation. The checkers it registers are `BucketStateStateChecker`, `SplitBucketStateChecker`, `SplitInconsistentStateChecker`, `SynchronizeAndMoveStateChecker`, `JoinBucketsStateChecker`, `DeleteExtraCopiesStateChecker`, and `GarbageCollectionStateChecker`. The content-nodes page describes the same end state as enough consistent replicas and no extra or overlapping buckets: missing replicas are created, differing replicas are merged, extra replicas are deleted, and buckets that overlap or are the wrong size are split or joined.

Sources: `documentation/en/content/idealstate.html`, `documentation/en/content/content-nodes.html`, `storage/src/vespa/storage/distributor/idealstatemanager.cpp`.

Review: Accepted from [Ideal state](4d029385-bff3-45be-9dc4-eeb81b6f46de). The checker names are the seven classes `IdealStateManager` registers. The first is `BucketStateStateChecker`, not a class named `SetBucketState`. The query-response non-ideal-state bit is already in the test set.

### 7. What is a reference field?

A reference field, declared as `reference<document-type>`, stores one document id of that type. It is fed as a document-id string, and the summary value is that string. The id's document type must be exactly the referenced type. An id of another type is rejected. The field must be an attribute, and the attribute stores the id's global id. The schema reference says indexing a reference is invalid and that deployment fails.

The attribute may be an empty string or may name a document that is absent. A self-reference and a cycle between document types are rejected. The schema says reference fields are not supported in streaming search, and the streaming page says parent/child relationships are not supported there.

A query uses the target document id as the term. `ReferenceAttribute::getSearch` parses the term as a document id and matches when its global id equals the stored global id. A term that does not parse matches no documents. The schema says this search is a linear scan because fast-search is not supported.

Sources: `documentation/en/reference/schemas/schemas.html`, `documentation/en/performance/streaming-search.html`, `document/src/main/java/com/yahoo/document/datatypes/ReferenceFieldValue.java`, `searchlib/src/vespa/searchlib/attribute/reference_attribute.cpp`, `config-model/src/main/java/com/yahoo/schema/DocumentGraphValidator.java`, `config-model/src/test/java/com/yahoo/schema/DocumentGraphValidatorTest.java`.

Review: Accepted from [Reference field](9c8cbe63-8a5a-4708-ab5e-05120ea0930c). `DocumentGraphValidator`'s class comment says a self-reference is allowed. `validateDocument` throws when the walk returns to the starting type, and `self_reference_is_forbidden` expects `ad->ad`. The schema page says indexing a reference fails deployment. That validator was not re-read, so the answer keeps the schema sentence. Import syntax is already in the test set.

### 10. What is the document store?

The document store holds each document as a serialized blob, addressed by local id. The proton page says those blobs are compressed. `DocumentStore::Config` defaults to LZ4. Each proton sub-database has its own store, and the summary manager writes it as a `LogDocumentStore`.

A get of only the document id, or an empty field set, does not read the store. A get of the whole document reads the store unless every field can be rebuilt from an authoritative attribute. A field is authoritative when it is an attribute, it is not an index field, and it is not a predicate, a reference, or a quantized tensor. A requested subset reads the store when any field in the subset is not such an attribute.

An update rewrites the stored document when it changes an indexed field, a field with no attribute, or an attribute that is not updateable in memory only. Predicate, reference, and quantized-tensor attributes are not updateable in memory only, and neither is a struct-field attribute, whose name contains a dot. A field-path update marks the stored document for rewrite as soon as the update contains one. The feed view then reads the stored document, applies the update, and writes the serialized document back. A field update that only touches an attribute which is updateable in memory leaves the stored blob unchanged.

Sources: `documentation/en/content/proton.html`, `searchlib/src/vespa/searchlib/docstore/documentstore.h`, `searchcore/src/vespa/searchcore/proton/docsummary/summarymanager.cpp`, `searchcore/src/vespa/searchcore/proton/server/documentretriever.cpp`, `searchcore/src/vespa/searchcore/proton/server/storeonlyfeedview.cpp`, `searchlib/src/vespa/searchcommon/attribute/attribute_utils.cpp`.

Review: Accepted from [Document store](57c47cf6-212b-4704-8b78-0c5d993955b0). A whole-document get does not always read the store. `DocumentRetriever::need_fetch_from_doc_store` skips it when every field is an authoritative attribute. The per-summary-writer catalog was not re-read, so it is not in the answer. `DocumentStore::Config` defaults to LZ4. A proton.def override of that default was not checked.

### 11. What is the transaction log for?

Each content node keeps a transaction log. It is an append-only record of mutating operations. The proton page says put, update, and remove are written there before the document store is updated. The replay handler also receives bucket split, join, and delete, document moves, config changes, pruning of removed documents, and lid-space compaction. Noop and create-bucket entries are ignored on replay. Each entry has a serial number.

When a document database starts, Proton replays the operations still in the log. That restores operations that were appended and not yet flushed. By default Proton flushes attributes and the memory index on shutdown, so the next start has less of the log to replay.

The log is local to the content node. Proton's base directory is `$VESPA_HOME/var/db/vespa/search/cluster.<cluster>/n<distributionKey>`, and Proton sets that directory as its working directory. The transaction-log server name defaults to `tls` and its configured base directory is `tls`, so the server directory is `tls/tls` under the Proton base directory. There is one domain per document type, named with the document type. A part file is `<document-type>-` plus a 16-digit zero-padded serial number. `VESPA_HOME` defaults to `/opt/vespa` when unset.

Sources: `documentation/en/content/proton.html`, `searchcore/src/vespa/searchcore/proton/server/proton.cpp`, `searchcore/src/vespa/searchcore/proton/server/ireplaypackethandler.h`, `searchcore/src/vespa/searchcore/proton/server/feedstates.cpp`, `searchcore/src/vespa/searchcore/proton/server/feedhandler.cpp`, `searchlib/src/vespa/searchlib/transactionlog/translogserver.h`, `searchlib/src/vespa/searchlib/transactionlog/translogserver.cpp`, `searchlib/src/vespa/searchlib/transactionlog/domainpart.cpp`, `searchlib/src/vespa/searchlib/config/config-translogserver.cpp`, `config-model/src/main/java/com/yahoo/vespa/model/search/SearchNode.java`, `defaults/src/main/java/com/yahoo/vespa/defaults/Defaults.java`.

Review: Accepted from [Transaction log](e9745903-2709-450a-9093-6707611b2623). The `tls/tls` directory is Proton's working directory, the configured base directory `tls`, and the server name `tls`. The draft's claim that shutdown flush prunes the log was not re-read, so the answer says the flush leaves less to replay. Acknowledgement timing and the flush-size threshold are already in the test set.

### 8. What is store-only mode?

Store-only is one of the three document modes on a content cluster. It is selected by `mode="store-only"` on that type's `document` element in `services.xml`. The services reference marks `mode` required and lists `index`, `store-only`, and `streaming`. The default cell is empty. Changing the mode later requires an `indexing-mode-change` validation override, and the documents must be re-fed.

The content reference says store-only documents are stored the same way as in streaming mode. Streaming search stores the raw document data and searches it by streaming. The feeding guide says every indexing mode writes the document to the document store, and that this is the persisted copy. Proton stores those copies as compressed serialized blobs.

In the config model, a store-only document database is given Proton mode `STORE_ONLY` and keeps the content cluster config id. Indexed and streaming databases get the per-schema config id. The model test for a schema with a fast-access attribute expects no attribute config at the store-only config id.

Search does not build a backend for a store-only type. `ClusterSearcher` registers a backend only for document databases in `INDEX` or `STREAMING` mode. If every schema in the content cluster is store-only, the indexed search cluster is not added, and `Content.getSearchClusters` skips a null search cluster. No page read for this question says the words "not searchable."

Get is separate from that query path. A document/v1 GET fetches one document by id. On the content node, `PersistenceEngine::get` walks the document databases and their retrievers and returns the stored document when it finds the id. That lookup does not check the store-only mode.

Sources: `documentation/en/reference/applications/services/content.html`, `documentation/en/performance/streaming-search.html`, `documentation/en/performance/sizing-feeding.html`, `documentation/en/content/proton.html`, `config-model/src/main/java/com/yahoo/vespa/model/content/ContentSearchCluster.java`, `config-model/src/main/java/com/yahoo/vespa/model/builder/xml/dom/DomContentSearchClusterBuilder.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/Content.java`, `container-search/src/main/java/com/yahoo/prelude/cluster/ClusterSearcher.java`, `config-model/src/test/java/com/yahoo/vespa/model/search/test/DocumentDatabaseTestCase.java`, `searchcore/src/vespa/searchcore/proton/persistenceengine/persistenceengine.cpp`.

Review: Accepted from [Store-only mode](35e9f4e0-14fe-47cb-bc0e-7c4c85b6b40d). `SchemaInfo.indexMode` maps a null mode string to `INDEX` and any other unrecognized string to `STORE_ONLY`. The services reference requires the attribute, so that mapping is not a default. Proton's removed-document sub-database is a different mechanism and is not this mode. The get path does not consult the mode flag.

### 13. What is a content cluster group?

A content cluster group is a `group` element in `services.xml`, under `content` or under another `group`. It defines the hierarchical structure of that content cluster. Use either a `group` tree or a `nodes` list. The reference lists `name` and `distribution-key` as required on `group`. A distribution key only has to be unique among groups that share the same parent.

A group's children are all groups or all nodes. There is only one level of leaf groups under the top group. A group that has subgroups must contain a `distribution` element. A leaf group contains the content nodes, and `distribution` is not used there. Each group holds one or more complete replicas of the whole document corpus. On Vespa Cloud, `groups` or `group-size` on `nodes` divides the content nodes into groups with an equal share of the nodes, without a nested `group` tree. If neither is set, all nodes belong to one group.

A query is dispatched to one group and run on the nodes in that group. `dispatch-policy` chooses the group. The default, `adaptive`, prefers groups with lower latency. Multiphase requests that need the same group in every phase are hashed to one group. By default a group serves queries when its active-document count is at least 97% of the median across groups. With the default coverage policy `group`, maintenance and upgrades may take one group down at a time. The cluster controller's default is also to allow only one group down at a time. If a node inside a group fails, the remaining nodes in that group take over its buckets.

Sources: `documentation/en/reference/applications/services/content.html`, `documentation/en/reference/applications/services/services.html`, `documentation/en/content/elasticity.html`, `documentation/en/content/idealstate.html`.

Review: Accepted from [Content cluster group](c535fce4-e151-4637-8d34-6a6ef0c16089). The 97% figure is `min-active-docs-coverage`. The within-group takeover is the ideal-state page, not the general node-failure drawing. Per-group redundancy defaults are already in an earlier training answer.

### 14. What is a cluster controller?

A cluster controller manages distributor and content-node availability. Vespa can run one. Reads and writes still work if that controller is down, but a change such as a content node going down is not handled until a master is back. The controllers elect a master. Each votes for the lowest index that says it is ready, and a candidate becomes master only with more than half of the votes. Only the master polls nodes and publishes cluster state. The others stay in the election and can take over. A new master waits through a transition period before broadcasting. Because the election needs a majority, the documented recommendation is an odd count of 3 or greater. The `/cluster/v2` API says only the master responds, and that the master is the alive controller with the lowest index.

When `services.xml` does not list controllers, a self-hosted model starts one on each config server. If there is more than one config server, deploy logs a recommendation to configure the controllers explicitly. When the hosted model creates the shared set, it requests 3 nodes in production and 1 otherwise. Each controller container gets a component for that content cluster.

The controller publishes cluster state. It does not store documents. Its ZooKeeper root is `/vespa/fleetcontroller/<cluster>`. If wanted states cannot be read from ZooKeeper, the controller assumes up for every node.

Sources: `documentation/en/content/content-nodes.html`, `documentation/en/reference/api/cluster-v2.html`, `config-model/src/main/java/com/yahoo/vespa/model/content/cluster/ContentCluster.java`, `clustercontroller-core/src/main/java/com/yahoo/vespa/clustercontroller/core/database/ZooKeeperPaths.java`, `clustercontroller-core/src/main/java/com/yahoo/vespa/clustercontroller/core/database/DatabaseHandler.java`.

Review: Accepted from [Cluster controller](5e1f6bc2-f463-4128-bee0-52a89050ff36). The counts 3 and 1 are the hosted provisioning request, not a `services.xml` default. The unit-state table, the premature-crash rule, and the full ZooKeeper record list were not re-read, so they are not in the answer. Ideal-state maintenance is already in an earlier training answer.

### 16. What does normalizing do, and what is its default?

The indexing word `normalize` drops accents. `SimpleTransformer.accentDrop` applies Unicode NFD and then deletes combining diacritical marks. Case is unchanged. The linguistics page's example is à to a, and it says normalization preserves case and is applied the same way to documents and queries.

The field default is on. An omitted `normalizing` setting is level `ACCENT`. The schema reference says the default is to normalize and documents only the value `none`. The field converter also accepts `codepoint`, `lowercase`, `accent`, and `all`. `all` is stored as `ACCENT`. Only an accent level puts `normalize` on the generated index commands. `NormalizeLevel`'s comment says accent removal also implies codepoint and case normalizing. The accent-drop implementation does not change case.

Tokenizing always runs `SimpleNormalizer`, which is NFKC, whether or not `normalize` is set. Accent removal and lowercasing are separate flags on that token. In the tokenizer, accent removal happens before stemming. The query `NormalizingSearcher` is ordered after stemming, and it skips attribute fields. In streaming mode the deployed indexing script drops `tokenize`, and `IndexInfo` does not emit a query `normalize` command.

Sources: `documentation/en/reference/schemas/schemas.html`, `documentation/en/linguistics/linguistics-opennlp.html`, `linguistics/src/main/java/com/yahoo/language/simple/SimpleTransformer.java`, `linguistics/src/main/java/com/yahoo/language/simple/SimpleNormalizer.java`, `linguistics/src/main/java/com/yahoo/language/simple/SimpleTokenizer.java`, `config-model/src/main/java/com/yahoo/schema/document/NormalizeLevel.java`, `config-model/src/main/java/com/yahoo/schema/parser/ConvertParsedFields.java`, `config-model/src/main/java/com/yahoo/schema/derived/IndexInfo.java`, `config-model/src/main/java/com/yahoo/schema/derived/IndexingScript.java`, `container-search/src/main/java/com/yahoo/prelude/querytransform/NormalizingSearcher.java`.

Review: Accepted from [Normalizing](b24d3774-c6df-44e0-8b6e-d29fc838d81a). The schema reference lists only `none`. The converter accepts four more names, and `all` is the same level as `accent`. A bare `normalize` statement was not compared with the tokenizer's NFKC step beyond `SimpleTokenizer.processToken`. Stemming language coverage is already in the test set.

### 15. What is a distributor?

A distributor is a content-cluster process, alongside the cluster controller and proton. It owns buckets. Content nodes store the replicas. The ideal-state algorithm maps a bucket to exactly one distributor. The distributor keeps an in-memory bucket database of which content nodes store each bucket, with the document count, the persisted size, and a metadata checksum. That database is rebuilt by polling the content nodes at distributor start and when the cluster state changes. There is no centralized bucket directory.

A client put, update, get, or remove is sent to the distributor that owns the document's bucket. With no cached cluster state, the client sends the request to a random distributor. If that distributor does not own the bucket, it returns `WRONG_DISTRIBUTION` and the current cluster state, and the client resends. That reply is expected at cold start and after a cluster-state change. A mutation for a bucket the distributor does not own in a pending cluster state is rejected as `BUSY`, so the client does not bounce between two state versions. A put, update, or remove that arrives with no timestamp is given one that is unique within the bucket. Another mutation of the same document is rejected as `BUSY` while one is already in progress.

A query does not go through a distributor. The container sends queries to content nodes.

Sources: `documentation/en/content/content-nodes.html`, `documentation/en/content/proton.html`, `storage/src/vespa/storage/distributor/externaloperationhandler.cpp`.

Review: Accepted from [Distributor](72a9d591-1f79-407b-9734-ac1c9f439ae2). The bucket database stores document count, persisted size, and a metadata checksum. The page does not say meta-entry counts. A write's wait for every replica was not found in the put path that was read, so it is not stated. Ideal-state maintenance and get read-repair are already in other answers.

### 17. Which attributes can be paged, and what does paged change?

`paged` is off unless the schema sets it. The schema attribute object and the C++ attribute config both default it to false.

The schema accepts `paged` on an attribute unless the type is predicate or a tensor with `fast-rank`. An HNSW index with `paged` still deploys, and the deploy log warns that the combination is strongly discouraged. `fast-rank` is written into the attribute config as the fast-search flag.

At runtime the file-backed allocator is used only when `paged` is set and `allow_paged` is true. That is false for a predicate. For a tensor it is true only when the tensor type is valid and the tensor is dense, or the tensor is not dense and the fast-search flag is off. A non-dense tensor with that flag therefore stays in ordinary memory. A non-dense tensor written with `attribute: fast-search` and `paged` still passes the schema check, because that check looks at `fast-rank`, not at `fast-search`.

The file allocator is an `MmapFileAllocator` over a `swapfile`, mapped with `MAP_SHARED`. Large mappings are also advised `MADV_RANDOM`. The kernel can drop those pages. The attributes page says a regular attribute stays in memory, the dictionary and index structures of a fast-search attribute are never paged out, reported attribute memory is the size of the attribute data, and `paged` doubles attribute disk usage.

Sources: `documentation/en/content/attributes.html`, `config-model/src/main/java/com/yahoo/schema/processing/PagedAttributeValidator.java`, `config-model/src/main/java/com/yahoo/schema/derived/AttributeFields.java`, `searchlib/src/vespa/searchlib/attribute/attributevector.cpp`, `vespalib/src/vespa/vespalib/util/mmap_file_allocator.cpp`.

Review: Accepted from [Paged attributes](a6d5a2d7-f8f2-467d-b1c1-c3bb144f3c5f). The schema ban is predicate and `fast-rank`. The runtime also refuses the file allocator for a non-dense tensor whose fast-search flag is set, which is how `fast-rank` is exported. The per-structure list of what the allocator covers was not re-read past `allow_paged` and the attributes page. The "doubles disk" sentence is the attributes page.

### 18. What does match: cased do on a string attribute?

The default case setting is uncased, so matching is case-insensitive. A string field that is an attribute and not an index, and whose match type was not set in the schema, is given word matching. The whole value, including spaces, is then one term.

`match: cased` keeps case in the comparison. `IndexInfo` emits a lowercase command for an attribute string only when the case is uncased, and for an indexed field when the case is not cased. When the match is cased, `StringSearchHelper` compares the query bytes with the stored string using `strncmp`. A prefix matches when the stored value continues past that prefix. When the match is uncased, the same helper lowercases each stored character and compares it with the query. The text matching guide says query terms and attribute data are lowercased before matching unless the field match setting is cased.

The schema reference does not say this in one place. Its string field table says attribute searches are case-insensitive, and that a query for `BritneY.spears` matches a document containing `BrItNeY.SpEars`, with no cased exception. The introduction of the match section says text, word, and exact matching all run after normalization and locale-independent lowercasing, again with no exception. The exact row says lowercasing still happens unless `match: cased` is also set. The cased row says the match is case-sensitive. The text matching guide agrees with that exception.

Sources: `documentation/en/reference/schemas/schemas.html`, `documentation/en/querying/text-matching.html`, `config-model/src/main/java/com/yahoo/schema/document/Matching.java`, `config-model/src/main/java/com/yahoo/schema/processing/AttributesImplicitWord.java`, `config-model/src/main/java/com/yahoo/schema/derived/IndexInfo.java`, `searchlib/src/vespa/searchlib/attribute/string_search_helper.cpp`.

Review: Accepted from [Attribute match cased](3e2e0198-b196-414c-bf74-43d12d692803). The string table and the match introduction omit the cased exception that the exact row, the cased row, and the text matching guide state. The streaming exact-mode lowercasing note and the weighted-set `strcmp` path were not re-read, so they are not in the answer. The `matches` regex case split is already in the test set.

### 20. What is num-threads-per-search, and what is its default?

`num-threads-per-search` is an optional rank-profile setting. The schema reference says it overrides the content node's global `requestthreads` `persearch` value to a lower number. When it is set to a value greater than 0, the rank profile writes `vespa.matching.numthreadspersearch`. Until then the rank-profile field is `-1`, and the property is not written. The schema reference gives this setting no numeric default.

The content-node `persearch` default is 1, in both the services reference and `proton.def`. The serving guide says the number of threads per search is one by default. Proton sizes the per-search thread bundle from `min(cpu cores, numthreadspersearch)`.

A query can set `ranking.matching.numThreadsPerSearch`. The setter rejects a value below 1. The query field starts unset, and the query API leaves the default cell empty. If the property is absent, `NumThreadsPerSearch::DEFAULT_VALUE` is the maximum `uint32`. `RankSetup` stores that lookup when the property is missing. That maximum is not the number of threads a query gets. The match path asks for that many threads, and the thread bundle is still the one sized from `persearch`.

Sources: `documentation/en/reference/schemas/schemas.html`, `documentation/en/reference/applications/services/content.html`, `documentation/en/performance/sizing-search.html`, `documentation/en/reference/api/query.html`, `config-model/src/main/java/com/yahoo/schema/RankProfile.java`, `config-model/src/main/java/com/yahoo/schema/derived/RawRankProfile.java`, `searchlib/src/vespa/searchlib/fef/indexproperties.cpp`, `searchlib/src/vespa/searchlib/fef/ranksetup.cpp`, `searchcore/src/vespa/searchcore/proton/matching/matcher.cpp`, `searchcore/src/vespa/searchcore/proton/server/proton.cpp`, `searchcore/src/vespa/searchcore/proton/matchengine/matchengine.cpp`, `container-search/src/main/java/com/yahoo/search/query/ranking/Matching.java`, `configdefinitions/src/vespa/proton.def`.

Review: Accepted from [num-threads-per-search default](ae42252b-f341-41cc-8dd6-046c7cba827d). The rank-profile setting has no numeric default. The value 1 is `persearch`. The `uint32` maximum is the property lookup when the property is absent, and the search thread bundle is still sized from `persearch`, capped by the CPU core count. `min-hits-per-thread` can lower the request further and is not this setting.

### 19. What is a schema-level constant tensor?

A schema-level constant tensor is a `constant` element in the schema body. The parser still accepts the older `search` keyword as that root. The element's name is an identifier. Its body must contain a tensor type and a `file:` path. The path is relative to the application package root, and a path containing `..` is rejected. The file is tensor JSON and must end in `.json` or `.json.lz4`. A `.json` file whose type has no dimensions is rejected: only tensors with dimensions can be stored as file constants.

The schema stores the constant under the reference `constant(name)`. A schema that inherits another schema also exposes the parent's constants. Every rank profile of the schema includes those constants. A ranking expression reads the value with the rank feature `constant(name)`. On deploy, the schema reference says the files are sent to the content nodes before the new configuration is used. A later change replaces the file and redeploys, or uses a new constant name and a new file. Incremental changes to the tensor are not supported.

The schema reference still documents this element and says to prefer constants declared in the rank profiles that need them. The parser marks the schema-level form deprecated, and the comment says a warning is still to be emitted.

Sources: `documentation/en/reference/schemas/schemas.html`, `config-model/src/main/javacc/SchemaParser.jj`, `config-model/src/main/java/com/yahoo/schema/Schema.java`, `config-model/src/main/java/com/yahoo/schema/RankProfile.java`, `vespajlib/src/main/java/com/yahoo/path/Path.java`, `config-model/src/main/java/com/yahoo/vespa/model/application/validation/ConstantTensorJsonValidator.java`, `searchlib/src/main/java/com/yahoo/searchlib/ranking/features/FeatureNames.java`.

Review: Accepted from [Schema constant tensor](17ed7f5a-0a80-478c-91b5-c9a8aa3543d1). The deprecation is a parser comment. The warning is not emitted yet. A requirement that every indexed dimension have a size was not what the JSON validator enforces, so it is not stated. The rank-profile `constants` block is a different element.

### 21. What is rank-score-drop-limit?

`rank-score-drop-limit` is a floating-point cutoff in a rank profile. The schema parser accepts it inside `first-phase`, `second-phase`, and `global-phase`. A hit from that phase is kept only when its rank score is greater than the limit. A score less than or equal to the limit is dropped. First phase compares the first-phase score. Second phase compares the second-phase score, including a score that was rescored. Global phase compares the hit relevance after global-phase ranking, including a rescored score.

On the rank profile, all three fields start at `-Double.MAX_VALUE`. That value is the unset sentinel. `vespa.hitcollector.rankscoredroplimit`, `vespa.hitcollector.secondphase.rankscoredroplimit`, and `vespa.globalphase.rankscoredroplimit` are written only when the configured value is greater than `-Double.MAX_VALUE`. An unset value can be inherited from a parent rank profile. With the property absent, the first- and second-phase lookups stay an empty optional and no drop is applied. Global phase also skips removal while the limit is still `-Double.MAX_VALUE`.

The first-phase schema row prints `-Double.MAX_VALUE` as the default. The second-phase and global-phase rows say the value is not set. Both describe the same sentinel.

A query overrides the rank-profile value only when the corresponding field is set: `ranking.rankScoreDropLimit`, `ranking.secondPhase.rankScoreDropLimit`, or `ranking.globalPhase.rankScoreDropLimit`.

Proton's first-phase match rewrites a NaN or infinite score to negative infinity before the greater-than test, so those scores are dropped when a limit is set. Streaming search uses `!(score <= limit)` and therefore keeps a NaN score. For a finite score, both drop a score equal to the limit.

Sources: `documentation/en/reference/schemas/schemas.html`, `config-model/src/main/java/com/yahoo/schema/RankProfile.java`, `config-model/src/main/java/com/yahoo/schema/derived/RawRankProfile.java`, `searchlib/src/vespa/searchlib/fef/indexproperties.cpp`, `searchcore/src/vespa/searchcore/proton/matching/match_thread.cpp`, `searchlib/src/vespa/searchlib/queryeval/hitcollector.cpp`, `container-search/src/main/java/com/yahoo/search/ranking/GlobalPhaseRanker.java`, `container-search/src/main/java/com/yahoo/search/query/Ranking.java`, `streamingvisitors/src/vespa/searchvisitor/searchvisitor.cpp`.

Review: Accepted from [rank-score-drop-limit](7b04931a-158d-4749-8067-b74baf3dc149). The first-phase page prints the sentinel as the default. The other two pages say the value is not set. The comparison is greater-than in Proton and global phase, and `!(score <= limit)` in streaming. Equal finite scores are dropped in both.

### 23. What does a summary field's source select?

A summary field's `source` names the field or fields from which that summary field's value is fetched. The schema reference writes it as `source: [field-name], [field-name], …`. The parser accepts `source:` followed by one identifier and further identifiers separated by commas. If several names are listed, the reference says the value is taken from the first field that has a value, and from the next when the earlier one is empty. The summary-field model stores those names in that order and describes the next name as used when the previous one yields no result.

When `source` is omitted, the source is the field with the same name as the summary field. In a `document-summary` the source list stays empty and is resolved to that name. Deployment rejects it when that name is not a document field and is not `documentid`. A summary named `cox` with an empty body fails with `there is no valid source 'cox'`. That empty-list check is skipped for the `rankfeatures` and `summaryfeatures` transforms. An explicit source may name a document field, `documentid`, or another summary field. A summary that names itself, as in `summary w { source: w }` when `w` is not a document field, is rejected. A summary declared inside a document field is recorded differently: if its source list is empty, the converter stores the enclosing document field's name, including when the summary has a different name.

Sources: `documentation/en/reference/schemas/schemas.html`, `config-model/src/main/javacc/SchemaParser.jj`, `config-model/src/main/java/com/yahoo/vespa/documentmodel/SummaryField.java`, `config-model/src/main/java/com/yahoo/schema/parser/ConvertParsedFields.java`, `config-model/src/main/java/com/yahoo/schema/processing/SummaryFieldsMustHaveValidSource.java`, `config-model/src/test/java/com/yahoo/schema/processing/SummaryFieldsMustHaveValidSourceTestCase.java`, `config-model/src/test/examples/invalidselfreferringsummary.sd`.

Review: Accepted from [Summary field source](348a703b-9e89-4ec7-9e48-7c500738213e). The multi-name fallback is the schema reference and the summary-field comment. The code that reads the stored value was not opened. Dotted source names appear in tests, and the parser production that was read accepts only identifiers, so that form is not stated.

### 22. What is a dynamic summary?

A dynamic summary is a summary field that returns a dynamic abstract of a source field: fragments of that field around query terms that match it. The default summary property is `full`, which returns the whole field value. Declare the dynamic form on the field as `summary: dynamic`, as in the documented `indexing: summary | index`. A named form on that field, `summary <name>: dynamic`, adds another summary field. Inside the field or a `document-summary`, the block form is `summary <name> { dynamic }`.

The schema reference says `dynamic` is only supported for index fields of type string or array of string. An array of string produces one abstract per element. A config-model example also writes `summary: dynamic` on a string field whose indexing is only `summary`. The dynamic-transform helper also treats a URI type as supported. The schema reference does not.

The source text is that summary field's source. Which field a omitted source names is already answered. The content node keeps a query term when its index is the source field, or a fieldset that contains that field. If those views include a fieldset named `default`, the filter also accepts the empty view. `presentation.summary`, also written `summary`, selects the summary class that is fetched. The default is the schema's default summary class.

The generated abstract is configured with `vespa.config.search.summary.juniperrc`. Its `length` parameter defaults to 256, and the config definition describes that length as characters. The document-summaries page says the numbers in its juniperrc example are bytes. In the config definition, `min_length` and `surround_max` are described as bytes.

Sources: `documentation/en/reference/schemas/schemas.html`, `documentation/en/querying/document-summaries.html`, `documentation/en/reference/api/query.html`, `config-model/src/test/examples/simple.sd`, `config-model/src/main/java/com/yahoo/schema/processing/DynamicSummaryTransformUtils.java`, `searchsummary/src/vespa/searchsummary/docsummary/query_term_filter.cpp`, `searchsummary/src/vespa/searchsummary/docsummary/query_term_filter_factory.cpp`, `searchsummary/src/vespa/searchsummary/config/juniperrc.def`.

Review: Accepted from [Dynamic summary](53c3fdff-a833-4c68-b44d-43b5581f9a36). The schema reference limits `dynamic` to indexed string and array-of-string fields. The helper also accepts URI, and a test schema puts `summary: dynamic` on a summary-only string field. `length` is characters in `juniperrc.def` and the example page calls its numbers bytes. Bolding and Juniper's window walk are not this answer. The summary `source` fallback is already accepted.

### 24. What is a URI field, and how is it queried?

A `uri` field is a deprecated document type for URL matching. The schema reference says to use `string` instead. The value is stored as a string in the summary. It cannot be an attribute. Setting the type forces stemming off. When the field is indexed, including an array or weighted set of `uri`, the config model also builds parts named `scheme`, `host`, `port`, `path`, `query`, `fragment`, and `hostname`.

The schema reference splits an indexed URL into scheme, hostname, port, path, query, and fragment. The example `http://mysite.mydomain.com:8080/path/shop?d=hab&id=1804905709&cat=100#frag1` indexes the hostname as the labels `mysite`, `mydomain`, and `com`, the path as `path` and `shop`, and the query as its separate tokens. Ports `80` and `443` are not indexed. A URI field cannot be put into a common index with other fields.

The field itself, `field.path`, and `field.query` get the full-URL query command. `field.hostname` gets the host command. In the simple query language, a search for the whole URL is not an exact string match: `myurlfield:http://www.mydomain.com/` also matches a longer URL that contains those tokens, including one that only has that URL inside a query string. A hostname search is anchored at the end by default, so `mydomain.com` matches `www.mydomain.com` and not `mydomain.com.au`. A leading `^` also anchors the start, and a trailing `*` turns the end anchor off.

In YQL the operator is `contains uri("...")` on the field or on a part name. `startAnchor` defaults to false. The annotation table lists `endAnchor` default true. The parser uses that default only when the index is a host index. On the other indexes the end-anchor default is false. `{startAnchor: true}` and `{endAnchor: false}` override it. An alias of a component, such as `alias hostname: site`, searches that part. An alias of the field searches the whole URL.

Sources: `documentation/en/reference/schemas/schemas.html`, `documentation/en/reference/querying/simple-query-language.html`, `documentation/en/reference/querying/yql.html`, `config-model/src/main/java/com/yahoo/schema/processing/UriHack.java`, `config-model/src/main/java/com/yahoo/schema/processing/UrlFieldValidator.java`, `config-model/src/main/java/com/yahoo/schema/derived/IndexInfo.java`, `searchlib/src/vespa/searchlib/memoryindex/url_field_inverter.cpp`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`.

Review: Accepted from [URI field](2e054036-de93-40b4-a6fc-c9dc2b3df881). The token-character list and the claim that `field.host` has the hostname labels without the anchor markers were not re-read, so they are not stated. The YQL table says `endAnchor` defaults to true. The parser applies that default only to a host index. Streaming search is already in the test set.

### 27. What does matched-elements-only do?

`matched-elements-only` is a summary-field setting. On a document field the short form is `summary: matched-elements-only`. In a summary block on that field, or on a `summary` field inside `document-summary`, the statement is `matched-elements-only`. Specifying it together with `select-elements-by` is rejected.

Omitting it leaves the summary field's element selector as select-all, so the summary includes every element. The schema reference says it returns only the matched elements of a searchable array of primitive, weighted set, array of struct, or map. For an array of struct or a map, it says this is typically used with `sameElement`, and that a search directly on a sub-struct field also selects elements.

Deploy accepts the setting on an array of primitive, a weighted set of primitive, an array of simple struct, a map of primitive to simple struct, or a map of primitive to primitive. Those primitives are bool, byte, int, long, float, double, and string. A simple struct is a struct other than a position. A struct-field attribute on it must be a primitive type, and a nested struct-field attribute is rejected unless that struct field is imported.

The returned summary contains only the elements whose indexes matched the query for that field. When the field has no matched element ids, or the last selected id is past the end of the field, the attribute summary writer returns without inserting a value.

Sources: `documentation/en/reference/schemas/schemas.html`, `config-model/src/main/java/com/yahoo/schema/parser/ConvertParsedFields.java`, `config-model/src/main/java/com/yahoo/vespa/documentmodel/SummaryField.java`, `config-model/src/main/java/com/yahoo/schema/processing/SummaryElementsSelectorValidator.java`, `config-model/src/main/java/com/yahoo/schema/document/ComplexAttributeFieldUtils.java`, `searchsummary/src/vespa/searchsummary/docsummary/attributedfw.cpp`.

Review: Accepted from [matched-elements-only](684dc2ab-412c-4941-bd19-1af0549d13ca). The schema page says searchable array, weighted set, array of struct, or map. The deploy check is the type list above. Imported-field support is already in the test set. The `full` summary default is a different setting.

### 25. What tensor cell type does distance-metric: hamming require?

The schema reference says hamming is only useful for binary tensors that use the int8 cell type. Each int8 cell is an 8-bit pattern. The distance header says int8 hamming is the number of bits that differ. For the other implemented cell types it is the number of cells whose values differ. The schema note says counting coordinates that differ is not useful for floating-point data.

The distance factory builds a hamming function for double, int8, bfloat16, and float. Any other cell type uses the float factory. No cell-type check in that factory or in the quantized-tensor validator rejects a non-int8 tensor. Deploy does reject hamming when the attribute is quantized. The message is that distance metric `hamming` is not supported for quantized tensors. That check does not look at the cell type.

Sources: `documentation/en/reference/schemas/schemas.html`, `searchlib/src/vespa/searchlib/tensor/distance_function_factory.cpp`, `searchlib/src/vespa/searchlib/tensor/hamming_distance.h`, `searchlib/src/vespa/searchlib/tensor/hamming_distance.cpp`, `config-model/src/main/java/com/yahoo/vespa/model/application/validation/QuantizedTensorValidator.java`.

Review: Accepted from [Hamming cell type](26ce37b7-9430-46c6-9a54-3af2c8d24fb3). The schema says int8. The factory still builds hamming for double, bfloat16, and float, and falls back to float for any other cell type. The popcount formula and the range `[0, 8*n]` were not re-read, so they are not stated. The other distance metrics are already in the test set.

### 29. What is termwise-limit?

`termwise-limit` is a rank-profile setting. If this profile does not set it, the value is taken from the inherited profile that defines it. When no profile in that chain sets it, config compilation uses 1.0. The compiled value is written to `vespa.matching.termwise_limit` only when it is below 1.0. `RankSetup` starts at 1.0, and `configure()` replaces that with a lookup of the same property, whose default is 1.0. The schema reference says the current default is 1.0, which turns the feature off, and that a value between 0.05 and 0.20 can be a starting point. It describes the effect as a TAAT pass, before DAAT, over terms not needed for ranking, when the estimated number of hits is greater than the corpus times this limit.

A query can set `ranking.matching.termwiseLimit`. The setter requires a value in `[0.0, 1.0]`, and it writes the property when the parameter is present. First-phase search, including first phase together with sorting, uses that property and falls back to the rank-setup value. Second phase, match-features, summary, and dump setup call the setup helper without a limit, so the helper's default of 1.0 is used.

AND, OR, and ANDNOT use the stored limit when they create their iterators. Termwise evaluation is skipped when the root hit ratio is less than or equal to the limit. Hit ratio is the estimated hit count divided by the larger of that estimate and the docid limit. When the ratio is above the limit, the node still has to have more than one termwise child. At the default 1.0 the hit-ratio check fails.

Sources: `documentation/en/reference/schemas/schemas.html`, `documentation/en/reference/api/query.html`, `config-model/src/main/java/com/yahoo/schema/RankProfile.java`, `config-model/src/main/java/com/yahoo/schema/derived/RawRankProfile.java`, `searchlib/src/vespa/searchlib/fef/indexproperties.cpp`, `searchlib/src/vespa/searchlib/fef/ranksetup.cpp`, `container-search/src/main/java/com/yahoo/search/query/ranking/Matching.java`, `searchcore/src/vespa/searchcore/proton/matching/match_tools.cpp`, `searchcore/src/vespa/searchcore/proton/matching/match_tools.h`, `searchlib/src/vespa/searchlib/queryeval/blueprint.cpp`, `searchlib/src/vespa/searchlib/queryeval/blueprint.h`, `searchlib/src/vespa/searchlib/queryeval/intermediate_blueprints.cpp`.

Review: Accepted from [termwise-limit default](9a71c985-0695-4ba9-ab07-259e240f490d). The default 1.0 is both the schema page and the property lookup. The property is omitted when the compiled value is 1.0. The query setter checks the range. The schema parser's store of the number was not re-read for a range check. The body of the termwise wrapper was not opened.

### 26. What is indexing: input for?

`input <name>` reads that field from the document being indexed and sets the execution value to its value. A `.` in the name is a path into a nested struct field. A statement runs when all of its required inputs are available, on a full document or a partial update. `input` must be given a field name. The expression constructor rejects a null name.

If a statement still needs an input and this expression is left out, a field declared inside the document is rewritten to begin with `input` of that field's name. The same rewrite applies to a field declared outside the document when that field is a mutable attribute. Any other field outside the document keeps the statement as written. An `input` that names a field which is neither a document field nor a mutable attribute fails deployment with that reason.

Sources: `documentation/en/reference/writing/indexing-language.html`, `indexinglanguage/src/main/java/com/yahoo/vespa/indexinglanguage/expressions/InputExpression.java`, `config-model/src/main/java/com/yahoo/schema/processing/IndexingInputs.java`.

Review: Accepted from [indexing input expression](317868a1-4300-49f9-94fb-abf609d19dba). The omitted-input rewrite is `IndexingInputs`. A bare `input` is rejected by the expression constructor, so the converter that would fill a null name does not see one from that constructor. The failure text that was read is the missing-field check, not a separate "expression expected an input" message.

### 30. What bounds does a predicate field declaration take?

A predicate field takes `arity`, `lower-bound`, and `upper-bound` in its index block. `arity` is mandatory for a predicate field. A predicate attribute index with no boolean-index definition, or no arity, fails validation with `Missing arity value in predicate field.` A declared arity must be greater than 1. `lower-bound` and `upper-bound` are optional. These three settings are accepted only when the field type is `predicate`.

If a bound is left out, `getLowerBound()` and `getUpperBound()` return `Long.MIN_VALUE` and `Long.MAX_VALUE`. The processor copies those values onto the attribute. `PersistentPredicateParams` is constructed with the int64 minimum, the int64 maximum, and arity 8. `BooleanIndexDefinition.DEFAULT_ARITY` and the attribute's initial arity are also 8. That 8 is the unset constructor value. `getArity()` reads only a declared arity, and validation rejects a predicate index that omits it. The guide values `arity: 2`, `lower-bound: 3`, and `upper-bound: 200` are an example.

The two bounds are the range the predicate index is built for. Queries with values outside that range are rejected. Changing the bounds requires the index to be rebuilt. `arity` sets how finely the range is expanded into sub-ranges. A lower arity makes a smaller index and needs more query terms. A higher arity makes a larger index. The indexing script writes `lower_bound` and `upper_bound` only when that bound was declared. The `predicate-bounds` index command is emitted only when at least one bound was declared, and a side that was not declared is left blank in `[lower..upper]`.

Sources: `documentation/en/schemas/predicate-fields.html`, `documentation/en/reference/schemas/schemas.html`, `config-model/src/main/java/com/yahoo/schema/document/BooleanIndexDefinition.java`, `config-model/src/main/java/com/yahoo/schema/processing/PredicateProcessor.java`, `config-model/src/main/java/com/yahoo/schema/derived/IndexInfo.java`, `searchlib/src/vespa/searchcommon/attribute/persistent_predicate_params.h`.

Review: Accepted from [Predicate field bounds](740056e5-bb37-419b-a021-a8e5767baa66). Arity is mandatory. The value 8 is a constructor default, not the value used when arity is omitted. Omitted bounds become the 64-bit minimum and maximum. No check that the lower bound is less than or equal to the upper bound was found. How a query matches a predicate is already in the test set.

### 28. What does the firstPhaseRank feature return?

On indexed search, `firstPhaseRank` is the document's rank on that content node after first-phase scoring, assigned while choosing which hits to rerank in second phase. The best hit is 1, the next is 2, and so on, stored as a double. The lookup is filled in that selection step, so a second-phase expression can read it.

A document id with no stored rank returns the maximum double. That is `std::numeric_limits<double>::max()`. The rank-features page lists that as the default, including a document not selected for second phase. It also lists streaming search, summary features, and first-phase expressions as cases that return the default. The same constant is used when the shared lookup was never created. A missing lookup entry is the maximum double. There is no separate value for a document that has no first-phase score.

If a diversifier rejects a hit, the rank counter still advances and that document is not stored. It then reads as the maximum double, and later accepted hits keep the skipped numbers. The rank is local to the content node, so the same number can occur on more than one node. A sort feature that depends on `firstPhaseRank` or `firstPhaseMax` is rejected when the rank profile is compiled.

Sources: `documentation/en/reference/ranking/rank-features.html`, `searchlib/src/vespa/searchlib/features/first_phase_rank_lookup.cpp`, `searchlib/src/vespa/searchlib/features/first_phase_rank_feature.cpp`, `searchlib/src/vespa/searchlib/common/feature.h`, `searchlib/src/vespa/searchlib/fef/ranksetup.cpp`, `searchcore/src/vespa/searchcore/proton/matching/match_loop_communicator.cpp`.

Review: Accepted from [firstPhaseRank feature](876e3ea2-a35d-4717-b577-f55c8a704744). The missing-id result is the maximum double on indexed search as well. The page lists streaming as one of the cases that returns that default. A reused search session was not re-read, so it is not stated. The rank is assigned during second-phase selection, which is why a first-phase expression sees the default.

### 35. What does the rank query operator do?

The YQL `rank` operator matches only on its first operand. The YQL reference says only that argument determines whether a document is a match, and that all arguments are used when calculating rank features. Later operands do not change which documents match. They supply match data for ranking the hits the first operand already retrieved.

`RankSearch::doSeek` seeks the first child and accepts a document only when that child matches. Element ids come from that first child. The hit estimate is the first child's estimate. The filter iterator is the first child's filter. `RankFlow` gives the first child the incoming match flow and then sets the flow for every later child to zero.

When the search iterator is built, a later child is kept only if its match data must be unpacked. A rank node that has only the first child left is replaced by that child. On the first optimize pass, a later child whose hit estimate is empty can be removed unless children are preserved.

Sources: `documentation/en/reference/querying/yql.html`, `searchlib/src/vespa/searchlib/queryeval/ranksearch.cpp`, `searchlib/src/vespa/searchlib/queryeval/intermediate_blueprints.cpp`, `searchlib/src/vespa/searchlib/queryeval/flow.h`.

Review: Accepted from [rank query operator](4aaba713-d4a6-42c9-b5cc-74b14c77f322). The match set, the estimate, the filter, and the element ids all come from the first child. Later children are kept for unpacking match data. This is the query operator, not a rank profile.

### 36. What does dotProduct require of the field and the query?

`dotProduct` takes a weighted-set field and a weighted set from the query. The YQL reference specifies a weighted-set attribute with `fast-search`. A regular attribute or an index field is also accepted, with much weaker performance. A weighted set's elements are `byte`, `int`, `long`, or `string`, and each element has a signed 32-bit integer weight.

The query supplies `{token, weight}` pairs. In YQL the second argument can be an inline map, `dotProduct(description, {"a":1, "b":2})`. Those keys must be single- or double-quoted. The same weighted set can be passed by parameter substitution, `dotProduct(description, @myterms)`. The search implementation stores the query weights as 32-bit integers.

A document matches when the field contains at least one of the query tokens. The score stored for that document is the sum, over the tokens present in both the query and the field, of the query weight times the field weight.

Sources: `documentation/en/reference/querying/yql.html`, `documentation/en/reference/schemas/schemas.html`, `searchlib/src/vespa/searchlib/queryeval/dot_product_search.cpp`.

Review: Accepted from [dotProduct field and query](31a48c2b-211f-41a7-95e9-4abd2377b3fa). The field type and the "at least one token" match are the YQL table. The product sum is the unpack path. The inline integer-token array and the JSON wire form were not re-read, so they are not stated. The rank feature of the same name is not this operator.

### 34. What does equiv do?

`equiv` is the YQL operator for alternatives that should count as the same term. `where fieldName contains equiv("A","B")` matches when any alternative occurs in the field. Matching is the same as OR. The children are searched with an OR iterator, and the filter is an OR filter.

Ranking sees one term, not one term per alternative. Term extraction records the `equiv` node and does not record its children. The YQL reference says the group counts as only +1 for `queryTermCount`, counts as one word for completeness, and that proximity does not distinguish the words inside it. Connectivity can be set on the whole `equiv`. The children are not themselves visible to ranking features, so a weight or connectivity on a child has no effect. A phrase inside `equiv` ranks as if it has size 1. `equiv` may not appear inside a phrase, and it may only contain terms and phrases.

Positions from the children are merged into that single term. After the positions are sorted, a later position with the same key as the previous one is not appended.

Sources: `documentation/en/reference/querying/yql.html`, `searchcore/src/vespa/searchcore/proton/matching/termdataextractor.cpp`, `searchcore/src/vespa/searchcore/proton/matching/blueprintbuilder.cpp`, `searchlib/src/vespa/searchlib/queryeval/equivsearch.cpp`, `searchlib/src/vespa/searchlib/queryeval/equiv_blueprint.cpp`, `searchlib/src/vespa/searchlib/fef/termmatchdatamerger.cpp`.

Review: Accepted from [equiv operator](a8bc8286-229b-44ec-b519-76c289e512e7). The +1 `queryTermCount` sentence is the YQL reference. The extractor records the `equiv` node and skips its children. The parser's minimum of two arguments was not re-read. The child's weight divided by the `equiv` weight is passed into the blueprint, and that quotient was not followed into the stored exactness.

### 31. What does an attribute sorting block set, and what is the default sort function?

An attribute `sorting` block stores that attribute's sort specification. The same block may be written on a field, and it is applied to that field's attribute, creating the attribute if it does not exist yet. The settings are direction (`ascending` or `descending`), `function` (`uca`, `lowercase`, or `raw`), UCA `strength` (`primary`, `secondary`, `tertiary`, `quaternary`, or `identical`), and UCA `locale`. When a query sorts on the attribute and leaves the order or the function unset, the stored value is used.

The default direction is ascending, the default function is `uca`, the default strength is `primary`, and the default locale is an empty string. Those are the defaults on the attribute's `Sorting` object and in the attribute config. A function other than `uca` with a non-primary strength, or with a non-empty locale, produces a deploy warning that the setting only works for `uca`.

For a string attribute, that `uca` default is kept when a locale is available from the attribute or from the query model locale. If neither is set, the function used is `lowercase`. A query that has already selected `uca` and still has no locale after those two lookups uses `en_US`. That is not the schema locale default. The schema reference says `lowercase` is used when no language or locale is specified in the query, the field, or generally for the query. The searcher path that was read checks the attribute `sortlocale` and the query model locale.

Sources: `documentation/en/reference/schemas/schemas.html`, `config-model/src/main/java/com/yahoo/schema/document/Sorting.java`, `config-model/src/main/java/com/yahoo/schema/parser/ConvertParsedFields.java`, `config-model/src/main/java/com/yahoo/schema/processing/SortingSettings.java`, `config-model/src/main/java/com/yahoo/schema/derived/AttributeFields.java`, `configdefinitions/src/vespa/attributes.def`, `container-search/src/main/java/com/yahoo/prelude/searcher/ValidateSortingSearcher.java`.

Review: Accepted from [Attribute sorting block](f3d95ed5-d59b-439e-b4e8-681da1304595). The stored default function is `uca`. A string attribute with no attribute locale and no query-model locale is sorted with `lowercase`. An explicit query `uca` with no locale falls back to `en_US`. The strength warning is for a non-primary strength, not for the default `primary`. The query sorting language is already in the test set.

### 32. What is the rank-profile averageFieldLength setting for bm25, and when is it used?

The setting is the rank property `bm25(<field>).averageFieldLength`. The reference example is `bm25(title).averageFieldLength: 200`. The value is a double and is documented as an explicit average field length in number of words. A value that does not parse as a double fails feature setup. `k1` and `b` have constants 1.2 and 0.75. This property has no numeric constant.

`bm25(<field>)` and a labeled `bm25` read `bm25(<field>).averageFieldLength`. The label is not part of the key. `bm25_for_labels(<field>)` reads that same key. When the property is present, that double is used as the divisor of the matched field length in the BM25 term score, field length divided by the average. The resolved value is cached under `bm25.afl.<field>`.

When the property is omitted, the optional stays empty. Scoring then uses `get_field_length_info(<field>).get_average_field_length()`. The configuration table describes that omitted indexed-search value as the average calculated per field per content node. The `averageFieldLength(name)` rank feature returns that field-length statistic. The same page says `bm25(<field>).averageFieldLength` is also a fallback before the default for `averageElementLength`.

Sources: `documentation/en/reference/ranking/rank-feature-configuration.html`, `searchlib/src/vespa/searchlib/features/bm25_feature.cpp`, `searchlib/src/vespa/searchlib/features/bm25_utils.cpp`, `searchlib/src/vespa/searchlib/features/bm25_for_labels_feature.cpp`.

Review: Accepted from [BM25 averageFieldLength override](720585bb-9573-49f8-9f6a-3ce4a7c187a9). There is no numeric default in the feature. An omitted property uses the field-length-info average. How that average is computed, and the streaming value, are already in the test set. The elementwise blueprint's own lookup was not re-read. The page says the field-length property is a fallback for `averageElementLength`.

### 33. What does the phrase operator require?

A phrase matches when every term is present in the same field element, in the order given, at consecutive positions. Term k must occur at position P+k, where P is the position of the first term, so the step to the next term is 1. The query API states this as all terms present in the given order with no gaps. `phrase()` does not read a distance annotation. A `phrase()` call sets `explicit` to true.

A phrase of one term matches when that term matches. The indexed matcher returns a match for a one-term phrase without a relative-position check.

Sources: `documentation/en/reference/api/query.html`, `searchlib/src/vespa/searchlib/queryeval/simple_phrase_search.cpp`, `searchlib/src/vespa/searchlib/query/streaming/phrase_query_node.cpp`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`.

Review: Accepted from [Phrase operator positions](ee933ef0-2230-42a8-a04e-b83860eee14c). The position rule is the indexed matcher and the streaming matcher, and the query API's "no gaps" sentence. The list of leaf annotations was not re-read past `setExplicit(true)`. The onear equivalence is already in the test set.

### 37. What does fuzzy match, and what is the default maximum edit distance?

`fuzzy` matches one query string against a string attribute by Levenshtein edit distance. A value matches when the distance is less than or equal to `maxEditDistance`. A distance above that bound is not a match.

The default `maxEditDistance` is 2. `FuzzyItem.DEFAULT_MAX_EDIT_DISTANCE` is 2. The YQL parser and the select parser use that value when the annotation is omitted. The YQL annotation table lists the same default and calls it an inclusive upper bound. `FuzzyMatcher::DefaultMaxEditDistance` is also 2.

`prefix` defaults to false, so the whole attribute value is compared with the whole query string. `prefix: true` matches when a prefix of the value can be edited into the query string within the bound. `prefixLength` defaults to 0. A nonzero value requires that many leading characters to match exactly, and only the remainder is compared.

The YQL page's overview line says a string or an array of string. The same page's note says a single string, an array, or a weighted set. `ValidateFuzzySearcher` accepts a field that is a string attribute and rejects anything else. The text-matching guide says character normalization is not performed. The matcher still lowercases the term unless it is constructed as cased.

Sources: `documentation/en/reference/querying/yql.html`, `documentation/en/querying/text-matching.html`, `container-search/src/main/java/com/yahoo/prelude/query/FuzzyItem.java`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `container-search/src/main/java/com/yahoo/search/query/SelectParser.java`, `container-search/src/main/java/com/yahoo/search/searchers/ValidateFuzzySearcher.java`, `vespalib/src/vespa/vespalib/fuzzy/fuzzy_matcher.cpp`, `vespalib/src/vespa/vespalib/fuzzy/levenshtein_distance.h`.

Review: Accepted from [Fuzzy default edit distance](d41179d6-d3e0-41a1-a07a-a991cfa923db). The default 2 is the fuzzy constant, and the comparison keeps a distance equal to the bound. Who sets the cased flag on the matcher was not traced. The near operator's distance is a different setting.

### 39. What is model.defaultIndex?

`model.defaultIndex`, alias `default-index`, names the index searched for terms that do not name an index. The query API default is `default`. The YQL reference says that value may be a field or a fieldset. `userQuery()` parses `model.queryString` with this setting.

The Java field starts as null. `Parsable` copies that value into the parser. A null name is not written onto items by `assignDefaultIndex`. `IndexFacts.getIndex` treats a null or empty name as the index named `default`. The parser writes the default index only onto items whose index name is still empty. A term that already names an index keeps that name. If the text before a colon is a known index, that index is used. If it is not a known index, the tokenizer uses the default index.

`userInput()` has its own `defaultIndex` annotation. When that annotation is omitted, the parser uses the literal `default`, or null when the call is inside `sameElement`. That path does not read `Model.getDefaultIndex()`.

Sources: `documentation/en/reference/api/query.html`, `documentation/en/reference/querying/yql.html`, `container-search/src/main/java/com/yahoo/search/query/Model.java`, `container-search/src/main/java/com/yahoo/search/query/parser/Parsable.java`, `container-search/src/main/java/com/yahoo/prelude/IndexFacts.java`, `container-search/src/main/java/com/yahoo/prelude/query/parser/AbstractParser.java`, `container-search/src/main/java/com/yahoo/prelude/query/parser/Tokenizer.java`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`.

Review: Accepted from [model.defaultIndex](775d875a-eaf2-45f4-a321-d91c89b5038a). The documented default is `default`, and the model field starts null. `userQuery()` uses the model setting. `userInput()` uses its own annotation and a literal fallback.

### 40. What is model.restrict?

`model.restrict`, alias `restrict`, is a comma-separated list of document type names. Those names are schema names. The query API says an omitted value means all schemas. The set starts empty, and an empty set is that omitted case. `model.sources` chooses content clusters or other sources.

On a cluster searcher with more than one schema, a non-empty list is filtered to names that are schemas of that searcher. A name that is not one of those schemas is dropped. If none remain, no schema query is sent. That path does not also filter by `model.sources`. When the list is empty and `model.sources` is set, the searcher uses the schemas of those sources that it knows. When both are empty, it searches every schema it has. One query is built per selected schema, with `restrict` set to that schema name. Several schemas are searched separately and the hits are merged.

A cluster searcher with one schema does not read the restrict list. It sets `restrict` to that schema's name and searches it.

Sources: `documentation/en/reference/api/query.html`, `container-search/src/main/java/com/yahoo/search/query/Model.java`, `container-search/src/main/java/com/yahoo/prelude/cluster/ClusterSearcher.java`.

Review: Accepted from [model.restrict](e54627e3-f3a5-4528-8d45-e72495a55955). An empty list means every schema of the cluster searcher. A non-empty list is not intersected with `model.sources` in `resolveSchemas`. `SchemaInfo.Session.resolveSchemas` was not re-read. A one-schema searcher overwrites `restrict` with its only schema.

### 41. What is model.locale, and what does it change?

`model.locale`, alias `locale`, is an RFC 5646 language tag, such as `en-US`. The query API says it sets the locale and the language used when parsing the query. `setLocale` stores the locale and sets the parsing language from that tag. The language subtag selects the language. `zh` is traditional Chinese unless the country is `CN` or the script or variant is `Hans`, in which case it is simplified Chinese. `no` is Norwegian Bokmål. The legacy codes `in`, `iw`, and `ji` are Indonesian, Hebrew, and Yiddish. `model.language` is a legacy alternative. Underscores in that value are replaced with dashes, and it is then stored through the same locale setter.

When the locale is set, that language is the explicit parsing language. Stemming, accent dropping, CJK rewriting, and significance use a language set on a query item, and this parsing language when the item has none. A string attribute sort that has no locale of its own reads this locale. The rest of that sort fallback is already answered for the attribute sorting block. The YQL `locale` annotation is the UCA sort annotation, not this parameter.

When `model.locale` is not set, the stored locale is null. The parsing language is then taken from the query encoding when the encoding implies one. If that does not yield a language, and there is no query text to detect from, a language already present on a query item is used. Otherwise the language is detected from the query text. English is used when that detection does not yield a language.

Sources: `documentation/en/reference/api/query.html`, `documentation/en/reference/querying/yql.html`, `container-search/src/main/java/com/yahoo/search/query/Model.java`, `linguistics/src/main/java/com/yahoo/language/Language.java`.

Review: Accepted from [model.locale effect](b0b86f76-4eb5-4ef1-aeeb-15432374ab66). Setting the parameter sets both the locale and the parsing language. The unset order is encoding, then a language already on a query item when there is no text to detect, then detection, then English. The query-profile underscore form and the CJK tokenizer rules were not re-read. The attribute sort fallback is already in the training set.

### 42. What is model.sources?

`model.sources`, aliases `sources` and `search`, is a comma-separated list of source names. The query API says an omitted value means all sources. The set starts empty, and an empty set is that omitted case. Federation sends an empty set to the targets marked to be used by default.

A name that resolves as a content cluster selects that cluster. The query API says a content-cluster name is preferred over a document type of the same name. A name that is not a search chain, and is a schema name, selects the content clusters that contain that schema. `clustername.schemaname` is a separate chain. It sets the source to the cluster and `restrict` to that schema. `model.restrict` limits schemas inside the chosen sources.

YQL `from` writes this same set. Named sources are added to names already set by the parameter. `from sources *` leaves the YQL source list empty, and that empty list clears the model source set.

Sources: `documentation/en/reference/api/query.html`, `container-search/src/main/java/com/yahoo/search/query/Model.java`, `container-search/src/main/java/com/yahoo/search/federation/FederationSearcher.java`, `container-search/src/main/java/com/yahoo/search/federation/sourceref/SourceRefResolver.java`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `container-search/src/main/java/com/yahoo/search/yql/MinimalQueryInserter.java`.

Review: Accepted from [model.sources](1b59e999-48b4-4244-a329-63e7f5d1adcd). An empty set is the default, and federation uses the targets marked for default use. `from sources *` clears sources already set by the parameter. How a non-empty restrict list interacts with sources is already answered for `model.restrict`.

### 38. Are the endpoints of a numeric range query inclusive?

Yes, unless the `bounds` annotation opens an end. The YQL reference says a numeric interval is closed by default, and the annotation default is `closed`. `leftOpen` excludes the lower bound, `rightOpen` excludes the upper bound, and `open` excludes both. With the annotation omitted, the parser builds both limits as inclusive. A present `bounds` value must be one of those three names. The parser does not accept the name `closed`.

A closed range is serialized as `[lower;upper]`. An exclusive end uses `<` or `>`. That serialization follows each limit's own inclusive flag. Parsing a range string back through `IntItem` copies the end's inclusivity from whether the string starts with `[`. A string that starts with `<` is parsed with an exclusive end even when it ends with `]`.

Attribute matching keeps a value that is greater than or equal to the lower limit and less than or equal to the upper limit. Before that comparison, an exclusive integer endpoint is moved inward by one, and an exclusive floating-point endpoint is moved to the next representable value toward the inside of the interval.

For an integer type, the undefined value is that type's minimum. A single-value numeric attribute and a single-value numeric enum attribute increment a lower limit that equals that minimum by one before matching. A multi-value numeric attribute, a multi-value numeric enum attribute, and a single small numeric attribute do not. A float or double undefined value is NaN, and the comparison does not match NaN.

The schema reference says `byte`, `int`, `long`, `float`, and `double` do not support an index. An attribute is used, and that attribute supports range searches. If a numeric range term is evaluated by the disk index or the memory index, it is a dictionary lookup of the range string. A string range term is not supported on either index.

Sources: `documentation/en/reference/querying/yql.html`, `documentation/en/reference/schemas/schemas.html`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `container-search/src/main/java/com/yahoo/prelude/query/Limit.java`, `container-search/src/main/java/com/yahoo/prelude/query/IntItem.java`, `searchlib/src/vespa/searchlib/query/query_term_simple.cpp`, `searchlib/src/vespa/searchlib/attribute/numeric_range_matcher.h`, `searchlib/src/vespa/searchlib/attribute/numeric_range_matcher.hpp`, `searchlib/src/vespa/searchlib/attribute/single_numeric_search_context.hpp`, `searchlib/src/vespa/searchlib/attribute/single_numeric_enum_search_context.hpp`, `searchlib/src/vespa/searchlib/attribute/multi_numeric_search_context.hpp`, `searchlib/src/vespa/searchlib/attribute/multi_numeric_enum_search_context.hpp`, `searchlib/src/vespa/searchlib/attribute/single_small_numeric_search_context.cpp`, `searchcommon/src/vespa/searchcommon/common/undefinedvalues.h`, `searchlib/src/vespa/searchlib/diskindex/diskindex.cpp`, `searchlib/src/vespa/searchlib/memoryindex/memory_index.cpp`.

Review: Accepted from [Numeric range endpoints](b0d926c3-0fed-4fc4-a123-081e24e6be47). Both ends are inclusive when `bounds` is omitted. The integer-minimum adjustment is on for a single-value numeric attribute and a single numeric enum attribute, and off for multi-value and single small numeric attributes. The string parser takes the end's inclusivity from the opening character. A fast-search dictionary range was not re-read.

### 43. What does ranking.listFeatures return?

`ranking.listFeatures`, alias `rankfeatures`, is a boolean. The query API default is false, and the field starts false. When it is false, the backend dump is not requested and `rankfeatures` is removed from each hit.

When it is true, the indexed backend fills a summary so the hit can carry `rankfeatures`. That field is an object. Each name is a dump feature, and the value is a double, or raw data when the value is not a double. The query API says this requests all rank features. The dumped set is the built-in default dump features plus the rank profile's `rank-features` list. `ignore-default-rank-features` drops the default set and leaves only the listed features. `match-features` and `summary-features` are separate lists, returned as `matchfeatures` and `summaryfeatures`. A YQL select list that names other fields still keeps `rankfeatures` on the hit.

While the flag is true, the backend timeout used by the query is 6 minutes.

Sources: `documentation/en/reference/api/query.html`, `documentation/en/reference/schemas/schemas.html`, `container-search/src/main/java/com/yahoo/search/query/Ranking.java`, `container-search/src/main/java/com/yahoo/search/Query.java`, `container-search/src/main/java/com/yahoo/prelude/fastsearch/IndexedBackend.java`, `container-search/src/main/java/com/yahoo/search/handler/SearchResponse.java`, `container-search/src/main/java/com/yahoo/search/dispatch/rpc/ProtobufSerialization.java`, `container-search/src/main/java/com/yahoo/search/yql/FieldFilter.java`, `searchsummary/src/vespa/searchsummary/docsummary/rankfeaturesdfw.cpp`, `searchlib/src/vespa/searchlib/fef/ranksetup.cpp`, `config-model/src/main/java/com/yahoo/schema/derived/RawRankProfile.java`.

Review: Accepted from [ranking.listFeatures](a016607d-e416-4f49-b6a8-e3b050d0801c). The default is false, and a false value removes the field. The query page's "all rank features" is the dump set: default dump features plus `rank-features`, unless `ignore-default-rank-features` is set. The names in the default dump set were not read.

### 47. What is a document selection on a content cluster, as distinct from a visit selection?

A content-cluster document selection is the `selection` attribute on the content cluster's `documents` element and on each `document` element. The builder turns each declared type into `(typename)`, or `(typename AND (that type's selection))` when that type has a selection. Those alternatives are combined with `OR`. A documents-level selection is placed in front as `(that selection) AND (the type expression)`. The documents-level expression may not name a document type. A per-type expression may name only its own type. The content reference says an omitted selection matches everything. In the builder, an omitted attribute contributes no extra expression, so the type name alone is that type's clause.

That string is the cluster's routing selector. A put is routed to the cluster only when the selector returns true. An update is routed unless the selector returns false. A remove or a get that names a document type is routed unless the selector returns false. A remove or a get with no document type is routed. If no route accepts the message, the reply is a document-ignored reply.

Garbage collection is off by default. When it is on, the distributor is configured to remove documents matching `not (that selector)`. When it is off, no removal selection is configured, even if a selection attribute is set.

A visit selection is the document-selection string on one visitor command. A non-empty string is parsed as a document selector. An empty string is not parsed. The string is passed to the persistence iterator as that visit's document selection, with the visit's from and to timestamps. It limits which stored documents that visit returns. It is not the cluster route selector and not the garbage-collection removal expression.

Both are written in the document selector language. They are separate expressions.

Sources: `documentation/en/reference/applications/services/content.html`, `config-model/src/main/java/com/yahoo/vespa/model/content/cluster/DocumentSelectionBuilder.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/DistributorCluster.java`, `documentapi/src/main/java/com/yahoo/documentapi/messagebus/protocol/DocumentRouteSelectorPolicy.java`, `storage/src/vespa/storage/visiting/visitorthread.cpp`, `storage/src/vespa/storage/visiting/visitor.cpp`.

Review: Accepted from [Document selection vs visit](74413a3c-ecf7-43c9-81f2-f18e7a1ba269). The cluster selection is the route selector. Documents are removed for not matching it only when garbage collection is on, and that default is false. A visit selection filters that visit. The persistence iterator's matcher was not re-read. No search-time use of the route selector was in the files read.

### 48. What does rank-profile strict do?

`strict` is an optional rank-profile setting. A value set on the profile is used. If it is unset, the value is taken from the inherited profiles. Two inherited profiles that set different values fail deployment. Two that set the same value use that value. If it is unset everywhere, the default is false.

False is loose checking of `query(...)` features. A feature that is used and not declared still type-checks. The config model gives it `TensorType.empty`, which is a double with no dimensions. The schema reference says the loose case assumes a float when the feature is not defined in a query profile type. If the profile uses tensors, deployment logs a warning that the inputs are not declared and will be interpreted as scalars, not tensors. If the profile does not use tensors, that warning is not logged.

`strict: true` makes the same missing declaration a deploy failure when validation is on. A `query(...)` feature is declared when this profile, or a parent profile, lists it in `inputs`, or when a query profile type has a field of that name. An `inputs` entry overrides the query profile type. The check covers functions whose arguments are all typed, and summary features and the first-phase, second-phase, global-phase, and sort-feature expressions. The failure is an `IllegalArgumentException`. The outer message names the schema and the rank profile. The cause says the rank profile is strict but is missing a declaration of those inputs. If every undeclared query feature was already recorded while an earlier rank profile of the same schema was processed, that check is skipped.

This is the rank-profile setting. A query profile type has its own `strict` flag.

Sources: `documentation/en/reference/schemas/schemas.html`, `config-model/src/main/java/com/yahoo/schema/RankProfile.java`, `config-model/src/main/java/com/yahoo/schema/MapEvaluationTypeContext.java`, `config-model/src/main/java/com/yahoo/schema/processing/RankingExpressionTypeResolver.java`, `vespajlib/src/main/java/com/yahoo/tensor/TensorType.java`.

Review: Accepted from [Rank-profile strict](fd6d0215-44a3-407e-8882-58bcb0113998). The default is false. The schema says a missing query feature is assumed to be a float. The type resolver uses `TensorType.empty`, a double. The strict failure is skipped when an earlier profile in the same schema already recorded every undeclared query feature. Query-profile `strict` is a different flag.

### 44. What does where true match in indexed search?

`where true` is the YQL literal `true`. The parser turns that literal into a `TrueItem`, which matches everything. The YQL reference says it matches all documents of any type, and that treating every document as a match is expensive. It points at `model.restrict` for limiting the search to one schema.

In indexed matching that node is an always-true blueprint. Its iterator accepts every document id in the current range and does not unpack ranking match data. Proton AND-s that blueprint with the document meta store whitelist. The whitelist is the active-lid bit vector, and the meta store describes it as the documents that should be visible. Active lids are the documents in active buckets. AND optimization then removes an always-true child, so the remaining blueprint is the whitelist. A hit is copied into the result only when its local id is a used lid.

Sources: `documentation/en/reference/querying/yql.html`, `container-search/src/main/java/com/yahoo/prelude/query/TrueItem.java`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `searchcore/src/vespa/searchcore/proton/matching/blueprintbuilder.cpp`, `searchlib/src/vespa/searchlib/queryeval/leaf_blueprints.cpp`, `searchlib/src/vespa/searchlib/queryeval/full_search.cpp`, `searchlib/src/vespa/searchlib/queryeval/intermediate_blueprints.cpp`, `searchlib/src/vespa/searchlib/common/idocumentmetastore.h`, `searchcore/src/vespa/searchcore/proton/documentmetastore/lid_allocator.cpp`, `searchcore/src/vespa/searchcore/proton/documentmetastore/documentmetastore.h`, `searchcore/src/vespa/searchcore/proton/matching/match_thread.cpp`.

Review: Accepted from [where true indexed](b01ec1e5-47e4-4249-88a1-509489cbcf53). The reference says the literal matches all documents. Indexed search AND-s it with the active-lid whitelist, and AND optimization drops the always-true child. A copied hit must also be a used lid. The streaming true node was not re-read. Which schemas are searched is already answered for `model.sources` and `model.restrict`.

### 46. What is model.filter?

`model.filter`, alias `filter`, is a simple-query-language string. The query API leaves the default cell empty. The model field starts null. It is parsed with the `any` parser even when `model.type` is something else.

The query API says `model.queryString` must be present for the filter to have any effect. The YQL inserter adds an error when the filter is set and `getQueryString()` is null. The stored query string starts as the empty string, and `setQueryString` turns a null into that empty string. When the parsed query root is null, the filter string is parsed as the query. When a query tree exists, a `+` term is AND-ed in, a `-` term is excluded, and an unprefixed term is attached with `RANK`, so it does not add matches. The reference states that split: positive terms and phrases are AND filters, negative terms are NOT filters, and unprefixed terms rank the results. Unless the query has no positive terms, the filter only restricts the query and influences ranking.

Each filter term is marked as a filter term. That mark turns off highlighting in dynamic summaries. `isRanked` stays true, so the terms are still exposed to ranking. `recall` is documented as the same combination, except its terms are not ranked. `RecallSearcher` sets ranked to false. `model.filter` does not.

Sources: `documentation/en/reference/api/query.html`, `container-search/src/main/java/com/yahoo/search/query/Model.java`, `container-search/src/main/java/com/yahoo/search/yql/MinimalQueryInserter.java`, `container-search/src/main/java/com/yahoo/prelude/query/parser/AbstractParser.java`, `container-search/src/main/java/com/yahoo/prelude/query/parser/AnyParser.java`, `container-search/src/main/java/com/yahoo/prelude/query/Item.java`, `container-search/src/main/java/com/yahoo/prelude/querytransform/RecallSearcher.java`.

Review: Accepted from [model.filter](00225cf3-9ce7-4142-9ca7-0ee74a180f48). The filter is parsed as type `any`. An existing query gets `+` as AND, `-` as NOT, and an unprefixed term as `RANK`. The null-query-string error is the inserter check. The stored query string starts empty, not null. A bare quoted phrase without `+` was not re-read. The terms stay ranked. `recall` clears that.

### 45. What do grouping max and precision default to?

When a grouping expression omits `max`, a group list uses `grouping.defaultMaxGroups` and a hit list uses `grouping.defaultMaxHits`. Both query parameters default to 10. A value of `-1` disables that default. When `precision` is omitted and a max is in effect, the value is `max(1, ceil(max × grouping.defaultPrecisionFactor))`. The factor defaults to 2.0, so the default max of 10 gives precision 20. The query page describes this as multiplying the effective max by the factor. The grouping guide's "initial factor of 3" is an example.

The request objects do not start at those numbers. `GroupingOperation` initializes `max` to -1 and `precision` to 0, and those mean unspecified. `GroupingRequest` leaves the three query values empty unless they are set. `GroupingExecutor` then supplies 10, 10, and 2.0. `RequestBuilder` starts its own defaults at -1 and fills a max or a precision only after that.

The level that is sent uses a different max. Group `maxGroups` and hit `maxHits` are the effective max plus a lookahead of 1 plus any continuation offset. With offset 0, a default max of 10 is sent as 11. Precision is the computed value plus the offset, without that extra 1, so it stays 20. `setMaxGroups` raises precision up to the sent max when the computed precision is smaller. 20 is not smaller than 11, so the default precision stays 20.

`grouping.globalMaxGroups` is a different parameter. Its default is 10000, and it is a cost limit on the total number of groups and summaries, not the number of groups returned at a level.

Sources: `documentation/en/reference/api/query.html`, `documentation/en/querying/grouping.html`, `container-search/src/main/java/com/yahoo/search/grouping/vespa/GroupingExecutor.java`, `container-search/src/main/java/com/yahoo/search/grouping/GroupingRequest.java`, `container-search/src/main/java/com/yahoo/search/grouping/request/GroupingOperation.java`, `container-search/src/main/java/com/yahoo/search/grouping/vespa/RequestBuilder.java`, `searchlib/src/main/java/com/yahoo/searchlib/aggregation/GroupingLevel.java`.

Review: Accepted from [Grouping max and precision](74c2f1f2-647c-455e-aba6-1a05fb513875). The omitted max is 10 and the omitted precision is `ceil(max × 2.0)`, which is 20. The sent group max adds a lookahead of 1. `setMaxGroups` can raise a smaller precision to that sent max. The factor of 3 in the grouping guide is an example. The grouping language overview is already in the test set.

### 49. What does the freshness rank feature compute?

`freshness(name)` maps the age of a numeric attribute to a score from 1 down to 0. The main output is `max(1 - age(name) / maxAge, 0)`. `age(name)` is `now` minus the attribute timestamp, in seconds. A negative difference is clamped to 0. If the named attribute is not available, age is 10000000000 seconds, so this output is 0. The default `maxAge` is `3*30*24*60*60` seconds, about 3 months. A configured `maxAge` below 1 is raised to 1.

`freshness(name).logscale` uses the same age. Age below 0 is treated as 0, and age above `maxAge` yields 0. The value is `(log(maxAge + scale) - log(age + scale)) / (log(maxAge + scale) - log(scale))`. `scale` is `halfResponse² / (maxAge - 2*halfResponse)`. The default `halfResponse` is `7*24*60*60` seconds, 7 days. A value below 1 becomes 1. A value greater than or equal to `maxAge / 2` becomes `(maxAge / 2) - 1`. The logscale output is 0.5 when age equals `halfResponse`. The rank-features table lists the default of both outputs as 0.

`now` is seconds since epoch. The rank property `vespa.now` supplies it when that property is set. Otherwise the content node uses its system clock. `ranking.freshness` writes `vespa.now` only when that property is absent or empty. The query API leaves its alias and default cells empty. The Java parameter also accepts the alias `datetime`. The value is an integer second-count, `now`, or `now-<seconds>`. `now` is read from a UTC calendar clock on the container. A `now-` value with an empty offset subtracts 1 second.

`age(name)` is the raw second count. `freshness(name)` is the linear or logscale map of that count.

Sources: `documentation/en/reference/ranking/rank-features.html`, `documentation/en/reference/ranking/rank-feature-configuration.html`, `documentation/en/reference/api/query.html`, `searchlib/src/vespa/searchlib/features/freshnessfeature.cpp`, `searchlib/src/vespa/searchlib/features/agefeature.cpp`, `searchlib/src/vespa/searchlib/features/nowfeature.cpp`, `searchlib/src/vespa/searchlib/features/logarithmcalculator.h`, `searchlib/src/vespa/searchlib/fef/queryproperties.cpp`, `container-search/src/main/java/com/yahoo/search/query/Ranking.java`, `container-search/src/main/java/com/yahoo/prelude/Freshness.java`.

Review: Accepted from [Freshness rank feature](f996af99-a16d-4aec-a28f-5f83be37c95c). The linear output is `max(1 - age / maxAge, 0)`, with a default max age of about 3 months. `now` is `vespa.now` when set, otherwise the content-node clock. `ranking.freshness` fills that property only when it is empty. The query API does not list the `datetime` alias. A `now-` with no offset subtracts 1 second.

### 53. What does flush-on-shutdown flush, and what is its default for a hosted deploy?

When `flush-on-shutdown` is true, the search node's pre-shutdown command is `vespa-proton-cmd <rpc-port> prepareRestart`. That RPC starts proton's prepare-restart flush. The strategy drops flush targets of type GC, groups the rest by flush handler, and flushes the subset with the lowest combined write cost, read cost, and remaining transaction-log replay cost. A target whose replay cost is already at least its write cost plus its read cost is included even when it is outside that cheapest prefix. The content reference names the memory index and attributes as examples of the components written to disk, and says the flush lets the transaction log be pruned so the next start replays less.

The content reference says the element defaults to true. When the element is omitted, a hosted deploy gets false, so the node has no `prepareRestart` command. An explicit `true` still registers the command on hosted.

Sources: `documentation/en/reference/applications/services/content.html`, `config-model/src/main/java/com/yahoo/vespa/model/search/SearchNode.java`, `config-model/src/main/java/com/yahoo/vespa/model/builder/xml/dom/DomContentSearchClusterBuilder.java`, `config-model/src/main/java/com/yahoo/config/model/deploy/DeployState.java`, `searchcore/src/vespa/searchcore/proton/server/rpc_hooks.cpp`, `searchcore/src/vespa/searchcore/proton/flushengine/prepare_restart_flush_strategy.cpp`, `searchcore/src/vespa/searchcore/proton/flushengine/flush_target_candidate.cpp`, `searchcore/src/vespa/searchcore/proton/flushengine/flush_target_candidates.cpp`.

Review: Accepted from [Flush on shutdown](ca83c52a-7257-411c-ab2f-484367f0c608). The shutdown command is `prepareRestart`. It flushes a cost-selected set of non-GC targets, and a target that is already cheaper to flush than to replay is always included. The memory index and attributes are the examples named on the content page. An omitted element is false on a hosted deploy. The builder formula that produces that false is already in the test set.

### 54. What data lives in the log data store?

The content-node log data store, `search::LogDataStore`, stores byte arrays. Each array is keyed by a local id. The class comment says a zero-sized array is a removed key. `remove` appends an empty payload for that lid and stores an empty lid record.

An entry in a chunk is the lid, a byte length, and that many payload bytes. After the entries, the chunk stores one serial number, the serial passed into that flush. A packed chunk starts with a version byte. Version 1 is what new chunks write. Version 0 can still be read. The body uses compression of none, LZ4, or zstd, and the chunk has a CRC.

Each file is a pair. The `.dat` file holds the packed chunks. The `.idx` file header includes `docIdLimit`, then one record per chunk: file offset, size, that serial, and the entry count, followed by a lid and size for every entry. A lid map in memory records the current location of each lid as a file id, a chunk id, and a size. Size 0 means the record is empty. Compaction copies an entry only while the lid map still names that file, chunk, and size.

This is not the proton transaction log.

Sources: `searchlib/src/vespa/searchlib/docstore/logdatastore.h`, `searchlib/src/vespa/searchlib/docstore/logdatastore.cpp`, `searchlib/src/vespa/searchlib/docstore/chunk.h`, `searchlib/src/vespa/searchlib/docstore/chunk.cpp`, `searchlib/src/vespa/searchlib/docstore/chunkformat.cpp`, `searchlib/src/vespa/searchlib/docstore/chunkformats.h`, `searchlib/src/vespa/searchlib/docstore/filechunk.cpp`, `searchlib/src/vespa/searchlib/docstore/lid_info.h`, `searchlib/src/vespa/searchlib/docstore/compacter.cpp`.

Review: Accepted from [Log data store](2c850661-5d3b-4b4f-8815-6a9452f95b11). The store is keyed byte arrays, and a remove writes an empty entry. The on-disk pair is `.dat` and `.idx`. Compaction copies an entry only while the lid map still names that location. The proton transaction log is already a separate answer. The document fields placed in this store by a document store were not re-read.

### 51. What does an attribute flush write, as distinct from a memory-index flush?

An attribute flush writes a snapshot of that attribute vector under `snapshot-<serial>`. The saver writes `<name>.dat`. If the header says the attribute is enumerated it also writes `.udat`. If the header needs an idx file it writes `.idx`, and a weighted set then also gets `.weight`. If the serial being flushed is already covered by an equal or newer snapshot, the task writes nothing. The Proton maintenance page says this flush writes the attribute vector to disk and also releases memory after a lid-space compaction.

A memory-index flush is the target `memoryindex.flush`. `initFlush` hands the current memory index, and any extra frozen memory indexes, to the flush task, then installs a new memory index. Each handed-over index is written as a disk index in `index.flush.<sourceId>/`, including the serial and the source selector. The current memory index is not dumped when it has received no document inserts, the source selector has no changes, and an empty flush was not forced. Extra frozen indexes are still written. Fusion of those flush directories is scheduled afterward and writes `index.fusion.<id>`. That is a separate flush.

Sources: `documentation/en/content/proton.html`, `searchcore/src/vespa/searchcore/proton/attribute/attribute_directory.cpp`, `searchcore/src/vespa/searchcore/proton/attribute/flushableattribute.cpp`, `searchlib/src/vespa/searchlib/attribute/attributefilesavetarget.cpp`, `searchcore/src/vespa/searchcorespi/index/indexflushtarget.cpp`, `searchcore/src/vespa/searchcorespi/index/indexmaintainer.cpp`, `searchcore/src/vespa/searchcorespi/index/indexdisklayout.cpp`.

Review: Accepted from [Attribute flush vs memory index](ca6fb445-0890-441d-86e1-4dee1de720e1). An attribute flush writes a snapshot of the vector. A memory-index flush writes the previous memory index as `index.flush.<id>` and leaves fusion as a later flush. The per-field posting file names were not re-read. The flush strategy's choice among targets was not re-read.

### 52. What is lid-space compaction, and what triggers it?

Lid-space compaction is a Proton maintenance job. It is registered for the ready, removed, and not-ready sub-databases. It is disabled when the document type is global. The default check interval is 10 seconds.

The job moves documents from high lids to low lids inside the same sub-database. The scan selects a document whose lid is greater than `max(lowest free lid, used-lid count)`. When the scan no longer needs another pass, the job sets the lid limit to highest used lid + 1. The maintenance page says the memory from that shrink is released on a later attribute flush. If used lids plus the allowed bloat is still below the highest used lid, and a free lid remains below that highest lid, the scan runs again instead of shrinking the limit.

A move pass starts when lid bloat is at least `allowedlidbloat` and the bloat factor is at least `allowedlidbloatfactor`, and the lid limit is still greater than the lowest free lid. The defaults are 1 and 0.01. Lid bloat is lid limit minus used lids minus 1, because lid 0 is reserved. The factor is that bloat divided by the lid limit. The services reference says the factor default is 0.01 and will be raised toward 0.50. `lidspace.max-bloat-factor` overrides the factor. The job does not run while a remove batch is ongoing or while removes are above `removeblockrate`, whose default is 100 per second. The remove-batch block rate defaults to 0.5 per second.

Sources: `documentation/en/content/proton.html`, `documentation/en/reference/applications/services/content.html`, `configdefinitions/src/vespa/proton.def`, `searchcore/src/vespa/searchcore/proton/server/lid_space_compaction_job.cpp`, `searchcore/src/vespa/searchcore/proton/server/document_scan_iterator.cpp`, `searchcore/src/vespa/searchcore/proton/server/maintenance_jobs_injector.cpp`, `searchcore/src/vespa/searchcore/proton/server/documentdbconfigmanager.cpp`, `searchlib/src/vespa/searchlib/common/lid_usage_stats.h`.

Review: Accepted from [Lid-space compaction](7d115989-f9fb-4df3-aec8-13c3b2c3fdcb). The trigger is both thresholds, bloat at least 1 and factor at least 0.01, and the lid limit still above the lowest free lid. The maintenance page's "above 1%" is the factor. The job is disabled for a global document type. What a single move writes into the summary store and the index was not re-read. Bucket move is a different job.

### 50. How do closeness(field) and distance(field) differ?

`closeness(field, name)` and `distance(field, name)` are rank features for a tensor attribute used with `nearestNeighbor`. The first argument is the literal `field` or `label`. `name` is the tensor field, or the label of the nearest-neighbor item.

`distance(field, name)` is the distance from the query vector to a document vector. It is near 0 when the vectors are close. The default metric is Euclidean. The feature's default is the maximum double value. When the field stores several vectors, the smallest distance is used.

For Euclidean, angular, and prenormalized-angular, `closeness(field, name)` is `1.0 / (1.0 + distance(field, name))`. It is near 1 when the vectors are close, and its default is 0. The same best vector is used: the feature keeps the largest raw score, and the default conversion of that score back to a distance is `(1.0 / raw score) - 1.0`. Euclidean stores the raw score as `1.0 / (1.0 + distance)`. Angular distance is in `[0, pi]`. Prenormalized-angular distance is `1.0 - (q · a) / |q|²`, in `[0, 2]`, and that is `1.0 - cos(angle)` when both vectors are unit length.

With the dotproduct metric those meanings change. Closeness is the dot product and may be negative or positive. Distance is the negative of that dot product.

The one-argument features `closeness(name)` and `distance(name)` are the position features. They are a different pair.

Sources: `documentation/en/reference/ranking/rank-features.html`, `documentation/en/reference/schemas/schemas.html`, `searchlib/src/vespa/searchlib/features/closenessfeature.cpp`, `searchlib/src/vespa/searchlib/features/distancefeature.cpp`, `searchlib/src/vespa/searchlib/tensor/distance_function.h`, `searchlib/src/vespa/searchlib/tensor/euclidean_distance.cpp`, `searchlib/src/vespa/searchlib/tensor/mips_distance_transform.cpp`.

Review: Accepted from [Closeness versus distance](ed5c8a22-8bb3-46e9-828a-68565f9b5695). The rank-features page writes closeness as `1 / (1 + distance)`. The schema page says that does not hold for dotproduct, where closeness is the dot product and distance is its negative. The code matches that exception. The position features were not answered here.

### 58. What is the default redundancy when services.xml omits it?

There is no numeric default. A content cluster that sets neither `redundancy` nor `min-redundancy` fails deploy. `RedundancyBuilder` throws `Either <redundancy> or <min-redundancy> must be set`, and the cluster wraps that as `In content cluster '<id>': Either <redundancy> or <min-redundancy> must be set`.

When only `min-redundancy` is set, that value is the redundancy. On Vespa Cloud it is `ceil(min-redundancy / leaf groups)` copies per group. A cluster with no subgroups counts as one leaf group. The content reference example is min-redundancy 2 with 3 groups: 1 copy per group, 3 copies in total. Self-managed, the total is `min-redundancy`, then divided by the number of immediate subgroups, at least 1. That subgroup count must divide the total, or deploy fails with `Expected number of leaf groups (N) to be a factor of redundancy (M), but it is not`. The redundancy written to stor-distribution is `min(node count, per-group redundancy × groups)`.

Sources: `config-model/src/main/java/com/yahoo/vespa/model/content/cluster/RedundancyBuilder.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/Redundancy.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/IndexedHierarchicDistributionValidator.java`, `config-model/src/test/java/com/yahoo/vespa/model/content/ContentClusterTest.java`, `documentation/en/reference/applications/services/content.html`.

Review: Accepted from [Omitted redundancy](2f6be115-0126-4d7b-8d5b-72bc88fc80cc). There is no numeric default, and omitting both elements fails deploy with that message. The per-group and self-managed totals were already in the redundancy answer. This one adds the rejection text and the integer split. Searchable-copies defaults were not repeated. A sentence that the Vespa Cloud dev environment has redundancy 1 was left out; no config-model path inserts that number before the builder.

### 55. What does a bucket split do?

A bucket split turns one bucket into two children at one higher used-bit count. The distributor sends a `SplitBucketCommand` to every node recorded on that bucket. The content node has the multibit split path off, so the children are the parent id with one more used bit. One child keeps that id. The other sets bit `parentUsedBits`.

A document id becomes a bucket id with 58 used bits. The low 32 bits are the location, and the rest come from the global id. The buckets page describes a bucket as the documents that share a given number of the least significant bits of that 58-bit location. Its example splits a bucket of 8 bits by the 9th bit. A split can use more bits than the cluster's distribution bit count.

Proton takes documents whose stored used-bit count matches the source, widens each document's bucket id to the children's used-bit count, and assigns it to the child that compares equal. The content-node bucket database removes the source entry. A child with no documents and no remapped operations is left out of the split reply. When a node's reply succeeds, the distributor removes that node from the parent and drops the parent once no copies remain. Each reported child is recorded on that node with trusted cleared, so the copy that finishes first does not decide which replica is trusted.

Each content node splits the replica it stores. A node that was down can still hold the bucket at another split level. The elasticity page calls that inconsistent bucket splitting: checksums cannot be compared across different split levels, and bringing the replicas back to the same level is maintenance.

Sources: `storage/src/vespa/storage/distributor/operations/idealstate/splitoperation.cpp`, `storage/src/vespa/storage/persistence/splitjoinhandler.cpp`, `storage/src/vespa/storage/persistence/filestorage/filestormanager.cpp`, `storage/src/vespa/storage/persistence/persistencehandler.cpp`, `searchcore/src/vespa/searchcore/proton/documentmetastore/documentmetastore.cpp`, `document/src/vespa/document/base/globalid.h`, `document/src/vespa/document/bucket/bucketid.h`, `documentation/en/content/buckets.html`, `documentation/en/content/elasticity.html`.

Review: Accepted from [Bucket split](a4b10740-4624-4e1e-b851-1719ec8f5514). The enabled path splits one bit: the two children differ by `parentUsedBits`. The multibit detector is not used, because the persistence handler is constructed with that flag false. The parent is removed after its copies reply, and the new children are stored with trusted cleared. The document-count and byte-size thresholds that schedule a split were left out.

### 57. What is the search coverage minimum setting?

It is the `minimum` element under `content` / `search` / `coverage` in `services.xml`. The content reference says the value is from 0 to 1, where 0 is no coverage and 1 is full coverage, and that the default is 1. A query then does not return until every search node has responded, or the query timeout expires.

The model writes that fraction times 100 into dispatch config `minSearchCoverage`. The dispatch default is 100, and an omitted `minimum` leaves that default in place. The dispatcher needs `ceil(asked nodes × minSearchCoverage / 100)` answers. While fewer nodes have answered, the timeout handler returns the time still left on the query. At 100 it uses the simple handler, which also waits for that remaining time. Below 100 it uses the adaptive handler for the same wait until the minimum count is reached. The graceful-degradation page's example is `minimum` 0.9 on a cluster of 10 nodes: the container waits until 9 of 10 have replied.

Sources: `documentation/en/reference/applications/services/content.html`, `documentation/en/performance/graceful-degradation.html`, `configdefinitions/src/vespa/dispatch.def`, `config-model/src/main/java/com/yahoo/vespa/model/search/IndexedSearchCluster.java`, `container-search/src/main/java/com/yahoo/search/dispatch/AdaptiveTimeoutHandler.java`, `container-search/src/main/java/com/yahoo/search/dispatch/SimpleTimeoutHandler.java`, `container-search/src/main/java/com/yahoo/search/dispatch/InterleavedSearchInvoker.java`.

Review: Accepted from [Coverage minimum](990607dc-0c7f-461d-8232-2712d560180f). The setting is `coverage` / `minimum`, default 1, stored as `minSearchCoverage` 100. Until that fraction of nodes has answered, the dispatcher waits out the query time. The result's coverage object is a different field. `min-redundancy` was not part of this answer.

### 60. What happens to a feed write when a content node is above its resource limit?

The write is rejected. Disk, memory, and attribute address space are separate limits, and crossing any one of them is enough. Cluster feed block is on by default.

The cluster controller puts a feed block on the cluster. A distributor then rejects every put at once with `NO_SPACE` and the message `External feed is blocked due to resource exhaustion`. An update is rejected the same way when it adds a value, maps a field, adds or modifies a tensor, assigns a value that is not a fixed-size single value, or carries a field-path update. An update that passes that check is still rejected with `NO_SPACE` if it takes the two-phase safe path while feed is blocked. Remove does not consult the feed block.

Document v1 maps that error to HTTP 507. The Java feed client retries 429 and 503. A 507 response finishes the attempt.

If a write still reaches the content node, Proton's write filter is a second gate. It blocks a put when disk, memory, or attribute address-space usage is above its own limit, and it blocks an update only when the same update check is true. The service layer maps that exhaustion to `NO_SPACE`.

When `services.xml` sets neither limit, the model installs the flag defaults: disk 0.8, memory 0.8, and attribute address space 0.80. On hosted Vespa, memory is 0.75 when the smallest content node has less than 8.1 GiB. Proton's disk and memory limits are the cluster limit plus half of the distance from that limit to 1, so 0.8 becomes 0.9. The model does not write the address-space limit into Proton config. The Proton schema default for that limit is 0.91. The feed-block page says the address-space default is 0.90.

Sources: `configdefinitions/src/vespa/fleetcontroller.def`, `flags/src/main/java/com/yahoo/vespa/flags/PermanentFlags.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/ResourceLimits.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/ClusterResourceLimits.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/cluster/ContentCluster.java`, `configdefinitions/src/vespa/proton.def`, `storage/src/vespa/storage/distributor/externaloperationhandler.cpp`, `storage/src/vespa/storage/distributor/operations/external/twophaseupdateoperation.cpp`, `document/src/vespa/document/util/feed_reject_helper.cpp`, `searchcore/src/vespa/searchcore/proton/persistenceengine/persistenceengine.cpp`, `searchcore/src/vespa/searchcore/proton/server/resource_usage_write_filter.cpp`, `storage/src/vespa/storage/persistence/persistenceutil.cpp`, `vespaclient-container-plugin/src/main/java/com/yahoo/document/restapi/resource/DocumentV1ApiHandler.java`, `vespa-feed-client/src/main/java/ai/vespa/feed/client/impl/HttpRequestStrategy.java`, `documentation/en/writing/feed-block.html`.

Review: Accepted from [Feed resource limit](c18a6f49-b642-4df2-a948-56877f4ff9ef). A blocked cluster rejects a put immediately. An update is rejected when it grows a field or takes the two-phase path. Remove is not blocked at the distributor. HTTP 507 is not retried by the feed client. The address-space default is 0.80 in the cluster-controller flag, 0.91 in the Proton schema, and 0.90 on the feed-block page. The node-state filter for which nodes are counted was not re-read.

### 56. What does maintenance state mean for a content node?

Maintenance is a state the cluster controller publishes for a storage node. It is a valid wanted state for a storage node, and it is not a state the node reports. The cluster-v2 page says distributor nodes are not in maintenance.

Operators set a storage node to maintenance for a short stop, such as a reboot or an upgrade. The controller also publishes it itself. While the wanted state is not down, a reported stopping or down state is shown as maintenance for the storage transition time. That default is 30000 milliseconds, so a restart does not immediately cause redistribution. When the time has passed, the mask is no longer applied. A node whose wanted state is retired is published as maintenance while it reports initializing, so that period does not receive feed and merges. Pending global-document merges are another cause: the node is put in maintenance in the default bucket space until those merges finish.

The distributor still counts a maintenance node in the ideal set, together with nodes that are up or initializing. If any ideal node for a bucket is in maintenance, it schedules no merge, no bucket move, no removal of extra copies, and no garbage collection for that bucket. For live work the available states are up, retired, and initializing. Maintenance is outside that set. New requests are stored on other nodes, and the distributor does not synchronize those new copies with the copies on the maintenance node. The cluster-v2 page instead says new replicas of the documents on the node will not be created. That sentence is marked for a rewrite. If a write still reaches the content node, the storage bouncer rejects an external put, update, or remove. A get is let through when the node is in maintenance and the cluster state is up.

Search continues. When every bucket space is in maintenance, the match engine keeps accepting searches. Proton does not deactivate buckets in that state, so query traffic can drain.

Up means the node is available and is in the ideal set. Retired means the node is available and serves requests, but it is left out of the ideal set, so buckets are moved to other nodes. Down means the node is not available and is left out of ideal placement.

Sources: `vdslib/src/vespa/vdslib/state/globals.cpp`, `configdefinitions/src/vespa/fleetcontroller.def`, `clustercontroller-core/src/main/java/com/yahoo/vespa/clustercontroller/core/ClusterStateGenerator.java`, `storage/src/vespa/storage/distributor/distributor_bucket_space.cpp`, `storage/src/vespa/storage/distributor/storage_node_up_states.h`, `storage/src/vespa/storage/distributor/statecheckers.cpp`, `storage/src/vespa/storage/storageserver/bouncer.cpp`, `searchcore/src/vespa/searchcore/proton/server/proton.cpp`, `searchcore/src/vespa/searchcore/proton/server/buckethandler.cpp`, `searchcore/src/vespa/searchcore/proton/matchengine/matchengine.cpp`, `documentation/en/reference/api/cluster-v2.html`, `documentation/en/content/content-nodes.html`.

Review: Accepted from [Maintenance state](28c5aa47-572f-48ed-962d-0fb235d3b7af). A maintenance node stays in the ideal set, so the distributor does not merge or move those buckets, and it is outside the set that serves live feed. Search keeps running and buckets stay active. The cluster-v2 sentence that no new replicas are created disagrees with the content-nodes page, which says new requests are stored elsewhere and are not synchronized. The C++ state flags also mark wanted maintenance as valid for a distributor. The generator comment says distributors do not support that mode, and their transition time defaults to 0.

### 59. What is the difference between reindexing and reprocessing?

Reindexing visits documents already stored in the cluster and puts them back through the indexing chain, so derived fields are recomputed from the stored document fields. It is started by `ReindexingMaintainer` in the cluster-controller containers. One maintainer holds a ZooKeeper lock and visits the content cluster. The visitor skips remove entries and sends a put for each remaining document. The reindexing page says that put is fed through the cluster's indexing chain. On a self-managed deployment the steps on that page are: change the indexing pipeline, wait until the new config has converged, POST the reindex endpoint to mark the change ready, then deploy once more to start the job.

Reprocessing is a different name for two other operations.

An external reprocess is `vespa-visit --datahandler <route>`. The visiting page's example sends selected documents to a document-processing chain and then indexing. That processor can delete documents or change a stored field. The reindexing page points at this when a stored document field itself must change.

Proton reprocessing is a content-node visit of the document store, run before the database goes online. Adding an attribute aspect populates the attribute from the stored field. Removing an attribute aspect writes the attribute back into the stored field, except a string field that was an index field, which is left unchanged so its annotations stay. The schema reference reports this as a searchnode restart, not as a reindex action. The page says the attribute is filled from stored documents during that restart, and a removed attribute updates the stored field from the attribute.

Neither of these is lid-space compaction or a bucket merge.

Sources: `documentation/en/operations/reindexing.html`, `documentation/en/writing/visiting.html`, `documentation/en/reference/schemas/schemas.html`, `clustercontroller-reindexer/src/main/java/ai/vespa/reindexing/ReindexingMaintainer.java`, `storage/src/vespa/storage/visiting/reindexing_visitor.cpp`, `searchcore/src/vespa/searchcore/proton/reprocessing/attribute_reprocessing_initializer.cpp`, `searchcore/src/vespa/searchcore/proton/reprocessing/reprocess_documents_task.cpp`.

Review: Accepted from [Reindex versus reprocess](51b41ca1-0950-428d-8c8b-c5b174b83a8e). Reindexing is the cluster-controller visit that puts stored documents back through indexing. External reprocessing is a `vespa-visit` that can rewrite the documents. Proton reprocessing fills attributes from the document store, or the document store from attributes, when an attribute aspect changes. The Vespa Cloud console path was not re-read.

### 61. What is min-redundancy?

`min-redundancy` is an element inside `content` in `services.xml`. The content reference calls it the minimum total data copies the cluster will maintain. It can be set instead of `redundancy`, or in addition to it, so a minimum number of copies is kept regardless of the other setting. The config model stores it as a value that is always global, across groups.

It can be changed without a node restart. Replicas are added or removed automatically. The elasticity page says the number is a minimum and the actual number depends on the topology. Its example keeps min-redundancy at 2 and regroups a flat cluster of 15 nodes into 3 groups of 5. The actual redundancy becomes 3, because each group holds at least one replica, and the disk and memory required on each node increase.

The per-group and self-managed numbers that this element produces are already in the redundancy answers.

Sources: `documentation/en/reference/applications/services/content.html`, `documentation/en/content/elasticity.html`, `config-model/src/main/java/com/yahoo/vespa/model/content/cluster/RedundancyBuilder.java`.

Review: Accepted from [min-redundancy meaning](5dac1df3-7c8f-4102-a787-f4fb823d608a). The element is a cluster-wide minimum, and changing it does not require a node restart. The topology example is the new part: the same min-redundancy can raise the actual copy count when groups are added. The ceil and integer-split formulas were not repeated.

### 65. What does a bucket merge do?

A bucket merge makes the replicas of one bucket hold the same timestamped document versions. The distributor schedules it when merges are enabled, the bucket is not inconsistently split, no ideal node is in maintenance, no ideal node is unavailable in the pending cluster state, and not every copy is invalid. The recorded reasons are a checksum disagreement, a missing replica, and a move onto an ideal node. The consistency page describes the same job as bringing replicas back together after a restart, a failure, or a network partition.

The replicas exchange timestamped documents. The newest timestamp of a document wins, and that version may be a remove. Tombstones are copied like documents. The resolution is the whole document, not a field-by-field merge. Two entries with the same timestamp are a collision. A remove is kept over a put. Any other unequal pair is logged, reduced to one entry, marked suspect, and the merge continues.

Ideal nodes that already have a copy are placed first and are never source-only. A copy past the redundancy count is source-only. After a successful merge the distributor deletes those source-only copies, unless a pending operation blocks the removal.

Sources: `storage/src/vespa/storage/distributor/statecheckers.cpp`, `storage/src/vespa/storage/distributor/operations/idealstate/mergeoperation.cpp`, `storage/src/vespa/storage/persistence/mergehandler.cpp`, `documentation/en/content/consistency.md`.

Review: Accepted from [Bucket merge](3acf8d22-afda-420f-80cb-34292045c7a2). A merge is scheduled for a checksum disagreement, a missing replica, or a move onto an ideal node, and it is skipped while an ideal node is in maintenance or the bucket is inconsistently split. The newest timestamp wins, including a remove. An equal-timestamp put and remove keeps the remove. The limiter that shortens a long node list was not re-read.

### 63. How does the container choose which content group receives a query?

The container does not match a `services.xml` group name. Search nodes are registered on the leaf group that contains them, and the config model maps each leaf group to a contiguous index starting at 0. That index is written into dispatch-nodes config as `node[].group`. The group's `name` and `distribution-key` stay on the group. The index is not that distribution key. A cluster may contain a `group` child or a `nodes` child, and the model rejects both. A cluster with only `nodes` is one implicit group. The query reference says the same about flat distribution.

A query can prefer an index with `model.searchGroup`, alias `searchgroup`. That preference is used when the index exists, the group still has sufficient coverage, and the group has not already been rejected. Otherwise it is dropped. `model.searchPath`, alias `path`, can name groups after `/`. The query reference examples are `7/3` (node 7 in group 3) and `*/0` (all nodes in group 0). A listed index the cluster does not have raises an invalid search path. A path containing `;` is ignored. With no search path, group choice is left to the container.

The result field `searchGroup` is that index, and it is written only when every hit reports the same group. A single group puts no group index on the hits, so the field is absent.

Sources: `documentation/en/reference/api/query.html`, `config-model/src/main/java/com/yahoo/vespa/model/content/ContentSearchCluster.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/StorageGroup.java`, `container-search/src/main/java/com/yahoo/search/dispatch/Dispatcher.java`, `container-search/src/main/java/com/yahoo/search/dispatch/SearchPath.java`, `container-search/src/main/java/com/yahoo/search/dispatch/searchcluster/Node.java`, `container-search/src/main/java/com/yahoo/search/result/HitGroup.java`.

Review: Accepted from [Query group choice](a520264f-b06e-4349-a744-00d9e0af3311). The container uses the contiguous leaf-group index, not the services.xml group name. `model.searchGroup` is a preference that is dropped when the group is missing, uncovered, or already rejected. `model.searchPath` can name that index after `/`. Adaptive coverage, the 97% cutoff, and hashing a query onto a group were not repeated. The ping rule that marks a single group sufficient was not re-read.

### 62. What is a garbage-collection selection?

A garbage-collection selection is the `selection` attribute on the `documents` element, and the `selection` attribute on each `document` element, in `services.xml`. There is no separate garbage-collection element. `garbage-collection` is a boolean attribute on `documents`. The default is false, and then garbage collection is not run. When it is true, the content nodes regularly check whether stored documents belong in the cluster and delete the ones that do not. The interval defaults to 3600 seconds.

The `documents` selection must be independent of document type. Naming a document type there fails deployment. A per-type selection may name only that type. The two are merged, and a document must match both to be kept. An omitted selection matches everything. The distributor's removal selection, when garbage collection is on, is `not` followed by that combined selector.

Sources: `documentation/en/reference/applications/services/content.html`, `config-model/src/main/java/com/yahoo/vespa/model/content/DistributorCluster.java`.

Review: Accepted from [Garbage collection selection](3257aad4-0beb-43af-a133-61e1bf50903e). The selection is the keep-set on `documents` and on each `document`. Garbage collection deletes documents that do not match it. The feed-routing rules for the same selection were not repeated. The interval default, 3600 seconds, is on the content reference.

### 64. What does sync-transactionlog do, and what is its default?

`sync-transactionlog` is a boolean under `content` / `engine` / `proton`. The content reference says the default is true. When it is true, the transaction log is synced to disk after a write, so the log can survive a power failure or a kernel panic. The sync cost is amortized over the feed operations in that commit.

The model writes the boolean to the transaction-log server's `usefsync`, whose config default is also true. On a commit, the domain writes the chunk and, when fsync-on-commit is set, calls `sync` before it releases the acknowledgements for that chunk. With the flag off, that sync is skipped.

If the element is omitted and the node's storage type is remote, the model writes `usefsync` false. An explicit element overrides that. The content page says that with the sync off, the risk of losing data depends on the kernel's writeback settings.

Sources: `documentation/en/reference/applications/services/content.html`, `searchlib/src/vespa/searchlib/config/translogserver.def`, `config-model/src/main/java/com/yahoo/vespa/model/search/SearchNode.java`, `searchlib/src/vespa/searchlib/transactionlog/translogserverapp.cpp`, `searchlib/src/vespa/searchlib/transactionlog/domain.cpp`.

Review: Accepted from [sync-transactionlog](28f234a5-839c-42fb-aa58-69c29189ce5c). The default is true, and a commit fsyncs before its acknowledgements are released. An omitted element on remote storage is written as false, and an explicit value overrides that. The feed-token destructor was not re-read. Flush-on-shutdown is a different setting.

### 66. What changes when the distribution bit count changes?

The distribution bit count in the cluster state is how many least-significant location bits define the buckets mapped to distributors. Ideal distributor placement and content-node placement both seed their node order from the bucket id masked to those bits, so a different count selects different distributors and different content nodes. The buckets page says altering the count redistributes all buckets. The ideal-state page says it changes which buckets exist and changes the distribution considerably.

The controller publishes the count. It starts from the configured ideal. A storage node that is up, initializing, or retired can lower it to that node's reported minimum used-bit count. The lowest such report wins. Nodes that are down or in maintenance are not counted. The controller remembers the lowest count it has published, starting at 16 for the process. A candidate above that remembered count and still below the ideal is held at the remembered count, so the published count does not climb through the values in between. When every counted storage node reports at least the ideal, the published count is the ideal.

On redeploy, the configured ideal is not lowered below the count in the previous application model. The comment says reducing the bit count can cause consistency problems. On hosted Vespa, outside the default zone, the configured ideal is 16 and is not computed from the node count. A distributor does not join a bucket down below the published count. The join test calls an increase one-way, because reducing the count is not handled.

Sources: `documentation/en/content/buckets.html`, `documentation/en/content/idealstate.html`, `clustercontroller-core/src/main/java/com/yahoo/vespa/clustercontroller/core/ClusterStateGenerator.java`, `clustercontroller-core/src/main/java/com/yahoo/vespa/clustercontroller/core/StateVersionTracker.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/cluster/ContentCluster.java`, `vdslib/src/vespa/vdslib/distribution/distribution.cpp`, `storage/src/tests/distributor/statecheckerstest.cpp`.

Review: Accepted from [Distribution bit change](64c24e77-47c7-4b18-ac01-37bb990b9715). A new count changes which distributors and content nodes own the buckets, and the cluster redistributes those buckets. The published count does not step upward through the values between the lowest count already published and the ideal. A redeploy does not lower the configured ideal. The default distribution table was not repeated. A restart or a refeed step was not in the files read.

### 69. What is sameElement's match scope?

`sameElement` matches when its conditions hold for one element of a multivalue field. The YQL reference says the default combination is AND: every condition must match in that same element. The search intersects the children's element ids, and the document matches when that intersection is not empty.

It applies to multivalue fields that contain structs or strings. The reference examples are an array of struct, a map, and an array of string. A map is searched as an array of a struct with `key` and `value`. An `elementFilter` annotation limits an array match to the listed indices. The example is `array<int>` with `sameElement` and `elementFilter:[2]`, which matches only index 2.

A child that names a subfield is searched as `field.subfield`. A child that does not name a subfield is the element value. The parser treats the element-value placeholder as the enclosing field, because the element has that field's type. The array-of-string examples use bare strings inside `sameElement`.

Sources: `documentation/en/reference/querying/yql.html`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `searchlib/src/vespa/searchlib/queryeval/same_element_search.cpp`.

Review: Accepted from [sameElement match scope](2b353590-b863-449a-9e5d-f58f197a411e). The default is AND inside one element, and the search keeps a document when the element-id intersection is not empty. A map is a struct of `key` and `value`. A child with no subfield is the element value. The inner-operator list for array-of-string fields was not copied.

### 71. What does the in operator match?

The YQL `in` operator matches when a field contains at least one value from a set. The YQL reference calls it a shorthand for several OR conditions on that field.

The left side is a field or a fieldset. The field is a single-value or multi-value attribute or index field of type byte, int, long, or string. A string field must use `match:word` or `match:exact`. The parser accepts an integer field or a string field, and it rejects a fieldset that mixes the two. The right side is a parenthesized, comma-separated list. Inline strings are single- or double-quoted. The same list can be passed as a parameter, as in `integer_field in (@integer_values)`.

Membership is the whole value. On an array, any element that equals any listed value is enough. The reference example is `[5, 10, 15]` matching `in (10, 20, 30)` because of 10. String values are not tokenized or stemmed. The only such processing the reference names is lowercasing. `match:text` does not fit, because the field is tokenized at index time and `in` does not tokenize its values. The operator is one term and provides no match information for text ranking features.

Sources: `documentation/en/reference/querying/yql.html`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`.

Review: Accepted from [in operator match](91882742-18ca-499a-94e0-e56e788447c9). `in` is whole-value membership, the same condition as an OR of equalities. String values are not tokenized. The shared weighted-set iterator was left out. It is not the meaning of the operator. `sameElement` and `weightedSet` were not restated.

### 67. What is hierarchical content distribution?

Hierarchical content distribution is a tree of groups in a content cluster. A group contains either child groups or content nodes. The group that contains the nodes has no partition string. Copies that reach it are placed on those nodes by the ideal-state algorithm. A group that has subgroups must set `partitions`. An indexed cluster is rejected if a child of the root has subgroups of its own, so the leaf groups sit directly under the top group.

The string is a pipe-separated list of copy counts, and it must end with `*`. A number is that slot's cap, from 1 to 255. `*` is stored as zero. For a redundancy R, the storage library expands the string into one count per receiving child. If R is at most the number of fields, the result is R ones. If R is larger, every field starts at one copy. Extra copies fill the numbered slots up to their caps, then the remainder goes to the `*` slots. The counts are sorted largest first.

The content reference defines the three strings as how many of the N child groups receive copies:

- `*` sends all copies to 1 of N groups. At redundancy 3 the expanded count is 3.
- `1|*` sends copies to 2 of N groups. At redundancy 3 the counts are 2 and 1. The written 1 is already at its cap, so the extra copy goes to `*`.
- `1|1|*` sends copies to 3 of N groups. At redundancy 3 the counts are 1, 1, and 1. At redundancy 4 they are 2, 1, and 1.

When the model fills in a missing partition string, it repeats the per-group copy count, separated by pipes, and ends with `*`. One copy in each of two groups is `1|*`. One copy in each of three groups is `1|1|*`.

Sources: `documentation/en/reference/applications/services/content.html`, `vdslib/src/vespa/vdslib/distribution/redundancygroupdistribution.cpp`, `vdslib/src/tests/state/grouptest.cpp`, `config-model/src/main/java/com/yahoo/vespa/model/content/StorageGroup.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/IndexedHierarchicDistributionValidator.java`.

Review: Accepted from [Hierarchical distribution](739d0a53-e333-4cbf-a810-0ca40e6f6cb2). The partition string decides how many child groups receive copies. `*` is the trailing wildcard. The C++ expander is what storage uses. Its test of `4|*` at redundancy 3 is 2 and 1. The score used to pick which children receive those counts was not re-read. Query dispatch and the min-redundancy formulas were not repeated.

### 70. What does the weightedSet query operator match?

`weightedSet` matches a single-value or multi-value attribute or index field when the field contains at least one token from the query's weighted set. The YQL reference says each token in the field is matched against that set, and that most uses are a single-value field. A weighted set on a single-value attribute has the same shape of match as a normal term on a weighted-set field.

Each query entry is a token and a weight. The operator is one term. Its own term weight is the weight on the operator. That starts at 100. The match weight is the largest weight among the matching tokens. The low-level match information lists every matching token's weight, heaviest first, each as an occurrence at position 0 in element 0. The operator does not produce a raw score. The reference points at `dotProduct` when a raw score is wanted.

It is ranked by default. `Item.isRanked` starts true, and the weighted-set search's `filter_search` is false.

Sources: `documentation/en/reference/querying/yql.html`, `container-search/src/main/java/com/yahoo/prelude/query/Item.java`, `searchlib/src/vespa/searchlib/queryeval/weighted_set_term_search.h`.

Review: Accepted from [weightedSet operator](91add2a3-1b03-407e-9755-97e68262675b). A document matches when the field contains at least one listed token. The match weight is the heaviest matching token, and the operator does not produce a raw score. It is ranked unless the field or an annotation makes it a filter. The filter-unpack path that stores only the document id was not re-read. `dotProduct` was not restated beyond the page's pointer.

### 68. What document count or size triggers a bucket split?

The distributor schedules a split when a bucket still has a copy, has fewer than 58 used bits, and is either over a size limit or below the minimum split level.

The size check uses the largest document count, total document size, meta count, and used file size across the replicas. Each of those four is taken separately. If that largest document count is below 2, no size split is scheduled. Otherwise a split is scheduled when the largest of these ratios is greater than 1:

- document count / `max-documents`
- total document size / `max-size`
- meta count / (2 × `max-documents`)
- used file size / (2 × `max-size`)

`max-documents` and `max-size` are attributes of `tuning` / `bucket-splitting`. The document-count default is 1024. The byte-size default in the distributor config is 16772216. The config comment calls that 16 MB, and a model test asserts 16772216 when the attribute is omitted. The services reference table lists 32MiB.

A bucket that is not over those limits is still split when its used-bit count is below the minimum split level. That level is the cluster's distribution bit count, raised to at least 8. The `minimum-bits` attribute overrides that distribution bit count. The reference leaves its default blank and says most users should not set it.

Sources: `storage/src/vespa/storage/distributor/statecheckers.cpp`, `storage/src/vespa/storage/config/stor-distributormanager.def`, `storage/src/vespa/storage/config/distributorconfiguration.cpp`, `storage/src/vespa/storage/bucketdb/bucketinfo.h`, `persistence/src/vespa/persistence/spi/bucket_limits.h`, `config-model/src/main/java/com/yahoo/vespa/model/content/BucketSplitting.java`, `config-model/src/main/java/com/yahoo/vespa/model/content/cluster/ContentCluster.java`, `config-model/src/test/java/com/yahoo/vespa/model/content/DistributorTest.java`, `documentation/en/reference/applications/services/content.html`.

Review: Accepted from [Bucket split trigger](edc58450-4fb6-4cad-acc2-d667ca21dbad). A size split is scheduled when the ratio is greater than 1, so the defaults are more than 1024 documents or more than 16772216 bytes. The reference table's 32MiB does not match the config the model emits. A bucket with fewer than 2 documents is not split for size. The minimum used-bit level is the distribution bit count, and never below 8. What the two children contain was not repeated.

### 72. What does a leading ! on a query term do?

In the simple query language, `!` is not exclusion. The prefixes that include or exclude a term are `+` and `-`. `!` is a weight suffix on the term it follows. The default weight is 100. Each extra `!` adds 50, so `foo!` is 150 and `foo!!!` is 250. `foo!200` sets the weight to 200. The same suffix applies to a phrase. The term stays in the query's normal combination. Only its relative rank importance changes.

The suffix binds only when `!` is the next token after the term. `word !` is the term `word`. `yahoo !360` is the term `yahoo` and the numeric term `360`. `a!b` is `a` at weight 150 and the term `b`. An integer that does not fit in a Java `int` is not applied: `a!12345678901234567890` becomes `a` and the numeric term `12345678901234567890`.

In YQL, `!` is negation. `!(title contains "saint")` matches documents that do not satisfy that condition. When `!` is an operand of `and`, the other operands become the positive child of one NOT and each `!` operand becomes a negative child. A NOT with no positive operand uses a true item, so every document matches except those that match the negated condition.

Inside `near()` or `onear()`, a term prefixed with `!` is a negative argument and must follow the positive terms. It does not drop every document that contains the term. It rejects a window only when the negative term occurs within the exclusion distance. That distance defaults to `(distance + 1) / 2`. The distance default is 2, so the exclusion distance defaults to 1. `near("a", "b", !"c")` is `NEAR(2,1,1)`. The same prefix is accepted on an `and` inside `sameElement`, as in `sameElement("one" and !"two")`.

Sources: `documentation/en/reference/querying/simple-query-language.html`, `documentation/en/reference/querying/yql.html`, `container-search/src/main/java/com/yahoo/prelude/query/parser/StructuredParser.java`, `container-search/src/test/java/com/yahoo/prelude/query/parser/test/ParseTestCase.java`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `container-search/src/main/java/com/yahoo/prelude/query/NotItem.java`, `container-search/src/test/java/com/yahoo/search/yql/YqlParserTestCase.java`.

Review: Accepted from [Negated query term](fed768d3-a2ed-423b-a35c-72a1137783a6). In the simple language `!` is a weight suffix. In YQL it is negation, and inside `near` or `onear` it rejects a window rather than the document. The default term weight of 100 is only the base this suffix adds to. `model.filter` was not restated.

### 78. What is target-hits-max-adjustment-factor, and what is its default?

`target-hits-max-adjustment-factor` is a rank-profile setting. It may be set once. The schema reference gives the range `[1.0, inf]` and the default 20.0. It applies when an approximate `nearestNeighbor` is evaluated with post-filtering. Setting it to 1.0 disables that auto-adjustment. It has no effect in streaming search.

The adjusted target is the smaller of `targetHits / estimatedFilterHitRatio` and `targetHits * targetHitsMaxAdjustmentFactor`. In the post-filtering branch, the blueprint writes that minimum into the adjusted target when the estimated hit ratio is greater than 0. Otherwise the adjusted target stays at the original target hits. The nearest-neighbor index search uses the adjusted target as `k`.

The query parameter `ranking.matching.targetHitsMaxAdjustmentFactor` is the same setting. Its default cell in the query reference is empty. The rank-profile default, and the C++ default when the property is absent, is 20.0. The schema text names `totalTargetHits`. The formula and the blueprint both use the operator's target hits.

Sources: `documentation/en/reference/schemas/schemas.html`, `documentation/en/reference/api/query.html`, `searchlib/src/vespa/searchlib/fef/indexproperties.cpp`, `searchlib/src/vespa/searchlib/fef/ranksetup.cpp`, `searchlib/src/vespa/searchlib/queryeval/nearest_neighbor_blueprint.cpp`.

Review: Accepted from [target-hits adjustment factor](ff156254-24d8-4737-8a2a-d7fe957ae6f8). The default is 20.0. The factor caps how far post-filtering may raise the target, and 1.0 leaves the target unraised. The per-operator annotation that can replace the factor was not re-read. `targetHits` and the filter-strategy thresholds were not restated.

### 73. What is the default weight of a query term?

The default weight is 100. It is an integer percent. 100 percent is a multiplier of 1.0.

Each query item starts with that value. `Item.DEFAULT_WEIGHT` is 100, and the item's weight field is initialized to it. The field comment calls it the relative importance of the term. The YQL `weight` annotation's default is also 100, described as the term weight used in some text ranking features. The rank feature `term(n).weight` lists the same default, 100, as the importance of matching that query term. An example of a non-default annotation is `title contains ({weight:200}"heads")`.

A filter term still carries the weight. `setFilter` only marks the item as a filter. The comment says filter terms are treated like other terms except that they are not highlighted. The YQL `filter` annotation defaults to false, and `filter:true` means the term is not bolded.

A weight on an item inside `equiv` does not reach ranking features. Those children are not directly visible, so weight and connectivity on them have no effect.

Sources: `container-search/src/main/java/com/yahoo/prelude/query/Item.java`, `searchlib/src/vespa/searchlib/query/weight.h`, `documentation/en/reference/querying/yql.html`, `documentation/en/reference/ranking/rank-features.html`.

Review: Accepted from [Default term weight](dd2d159c-e579-4447-965c-da8e1d51c246). The default is 100 on the query item, in the YQL annotation table, and on `term(n).weight`. A filter flag does not clear it. The simple-language `!` suffix was not restated. The per-feature multiplications in nativeRank were not re-read.

### 76. What does a language annotation on a query term do?

The YQL `language` annotation is an RFC 3066 language code. The reference calls it the language setting for the linguistics handling of `text` and `userInput`.

The parser reads that tag before the query's explicit language. A known tag is used as-is. A missing or unknown tag falls through to the explicit query language, then to language detection, then to English.

That language is stored on the term when the annotation is present or the resolved language is not English. A contains term with no annotation whose resolved language is English stays at the item's unset language. On `text` and `userInput`, the same condition marks the item and its children. `userInput` writes `model.language` only when that is still unset. It does not replace a language already set on the query. The items of that call still get the annotation language.

The resolved language is an argument of segmentation. When the query type tokenizes with linguistics, the tokenizer is called with that language and stemming mode `BEST`, and later stemming of that term is skipped. Otherwise the segmenter is called with that language and stemming mode `NONE`. `StemmingSearcher` then stems a term with the item's language when that language is set, and restores the previous language for the rest of the tree.

The `userInput` grammar section says that for any grammar other than `raw` or `segment`, `language` is not one of the annotations applied, and that annotating `userInput` with `phrase` does not give `language` effect. The parser still resolves the annotation and marks the items for those grammars.

Sources: `documentation/en/reference/querying/yql.html`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `container-search/src/main/java/com/yahoo/search/query/Model.java`, `container-search/src/main/java/com/yahoo/prelude/querytransform/StemmingSearcher.java`.

Review: Accepted from [Language annotation](a286a841-3798-41f5-94c3-3e3287933f68). The annotation selects the language for that term. A known tag wins over the query language, and it does not overwrite `model.language` once that is set. A contains term with no annotation is not always left unset. It stays unset only when the resolved language is English. The reference sentence that `phrase` on `userInput` ignores `language` does not match the parser.

### 74. What is the connectivity annotation?

The `connectivity` annotation is a map of `id` and `weight`. It links this query item to the item with that `id`. The annotations table leaves the default cell blank. The reference example is `connectivity: {id: 4, weight: 0.8}`. The `id` annotation is the unique id that map points at. The parser reads the map and calls `setConnectivity` with that weight. If the id is not in the query, parsing fails.

`setConnectivity` describes the weight as a value from 0 (none) to 1 (maximal). It says the default connectivity is 0.1, and that the value influences nativeRank and a subset of the fieldMatch features. Ranking uses 0.1 when no link to the previous term is stored. `lookupConnectedness` returns the stored weight only when the property names the previous term's unique id. Otherwise it returns the fallback 0.1. The rank feature `term(n).connectedness` has that same default. It is the normalized strength with which this term is connected to the previous term. The rank-features page says the value is set by the Java API or by this YQL annotation. The nativeRank page says connectedness must be set by a custom searcher and that there is no query syntax for it. The annotation and the parser are that syntax.

Sources: `documentation/en/reference/querying/yql.html`, `documentation/en/reference/ranking/rank-features.html`, `documentation/en/ranking/nativerank.html`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `container-search/src/main/java/com/yahoo/prelude/query/TaggableItem.java`, `searchlib/src/vespa/searchlib/features/utils.h`, `searchlib/src/vespa/searchlib/features/utils.cpp`.

Review: Accepted from [Connectivity annotation](16d1728f-e42a-4d3d-925d-3f7f00c7c25b). The annotation names another item and a weight. The annotation table states no default. Ranking uses 0.1 when the link to the previous term is absent. The nativeRank page's "no query syntax" does not match the YQL annotation. The fieldMatch proximity formulas were not restated. Connectivity inside `equiv` was already covered with term weight.

### 77. What is distanceThreshold on nearestNeighbor, and what is its default?

`distanceThreshold` is a double annotation on `nearestNeighbor`. The YQL default is `+infinity`. The query item starts at `Double.POSITIVE_INFINITY`, and the C++ term returns infinity when the value is unset. It filters out hits whose distance is greater than the threshold. A hit whose distance equals the threshold is kept. The annotation never returns more hits than the same search without it.

The blueprint converts the threshold into the distance function's internal units when the value is below the maximum double. `+infinity` is not converted. For Euclidean, that conversion squares the threshold, and the search compares the squared Euclidean distance with that squared limit. The nearest-neighbor guide describes the cutoff as `distance(field, embedding)`. That is the external distance. The match compares the internal value. The units depend on the distance metric.

HNSW drops a candidate when its distance is greater than the stored threshold. Exact search keeps a document when the computed distance is less than or equal to the limit. The same cutoff is used for exact and approximate search.

Sources: `documentation/en/reference/querying/yql.html`, `documentation/en/querying/nearest-neighbor-search-guide.md`, `container-search/src/main/java/com/yahoo/prelude/query/NearestNeighborItem.java`, `searchlib/src/vespa/searchlib/query/tree/termnodes.h`, `searchlib/src/vespa/searchlib/queryeval/nearest_neighbor_blueprint.cpp`, `searchlib/src/vespa/searchlib/tensor/euclidean_distance.cpp`, `searchlib/src/vespa/searchlib/tensor/hnsw_single_best_neighbors.cpp`, `searchlib/src/vespa/searchlib/queryeval/exact_nearest_neighbor_iterator.cpp`.

Review: Accepted from [distanceThreshold default](e5e8a12e-9ea5-40f8-8195-98e9ad2aa802). The default is `+infinity`. A greater distance is dropped, and an equal distance is kept. For Euclidean the threshold is squared before that comparison. The other metrics' conversion formulas were not re-read. `targetHits` and the closeness formulas were not restated.

### 75. What does the userQuery operator expand to?

`userQuery()` takes no arguments. The text is `model.queryString`, which the query API exposes as the `query` parameter. The operator is replaced by the root item of the tree produced by parsing that string. That item is inserted at the call site.

The parser is selected by `model.type`, exposed as `type`. The default is `weakAnd`. With that default, a single term becomes a `WeakAnd` item. A test query `title contains "madonna" and userQuery()` with `query=easilyRecognizedString` becomes `AND title:madonna (WEAKAND easilyRecognizedString)`.

For the simple syntax, composite `or` selects `AnyParser`, composite `phrase` selects `PhraseParser`, and the other composites select `AllParser`. That last parser covers both `weakAnd` and `and`. Syntax `none` selects `LinguisticsParser` when tokenization is `linguistics`, and `TokenizeParser` otherwise. Those parsers collect terms in the composite for the type: `weakAnd` creates a `WeakAndItem`, `and` an `AndItem`, `or` an `OrItem`, `phrase` a `PhraseItem`, `near` a `NearItem`, and `oNear` an `ONearItem`.

The YQL reference says `userQuery()` parses with the simple query language. That is the syntax used for `weakAnd` and the other simple types. Other `model.type` values select a different parser. If `model.filter` is set, it is applied to that same root after the query string is parsed, using `AnyParser`.

Sources: `documentation/en/reference/querying/yql.html`, `documentation/en/reference/api/query.html`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `container-search/src/main/java/com/yahoo/search/query/Model.java`, `container-search/src/main/java/com/yahoo/search/query/parser/ParserFactory.java`, `container-search/src/main/java/com/yahoo/prelude/query/parser/AbstractParser.java`, `container-search/src/test/java/com/yahoo/search/yql/MinimalQueryInserterTestCase.java`.

Review: Accepted from [userQuery expansion](f2640bf5-bb9c-429b-b290-3b19305fa42b). The operator is replaced by the parsed root of `model.queryString`. The default type is `weakAnd`, so a plain term becomes a `WeakAnd` item. The reference's "simple query language" sentence matches that default, and other `model.type` values select another parser. The simple-language `+`, `-`, and `!` grammar was not restated.

### 80. What does presentation.timing add to the response?

`presentation.timing` is a Boolean. The query reference default is `false`, and the presentation field starts `false`. It asks the result renderer to add timing. It does not change ranking.

When the flag is on, the JSON renderer adds a top-level `timing` object. The result reference lists three children, all in seconds:

- `querytime` is the time to execute the matching phase.
- `summaryfetchtime` is the time to fetch summaries for the globally ordered top-k hits.
- `searchtime` is approximately the sum of those two, close to what a client observes apart from network latency.

`querytime` and `summaryfetchtime` are written only when the first summary fill time is not zero, from the weighted search time and the weighted fill time. `searchtime` is written only when the search start time is not zero, as the time from that start until rendering begins. The XML renderer writes the same three names as attributes on `result`. It still writes `searchtime` whenever timing is enabled.

Timing is also rendered when `trace.profile` is true. `getTiming()` is that flag or `presentation.timing`. `trace.profile` also defaults to `false`, so with both omitted the renderer adds no timing.

Sources: `documentation/en/reference/api/query.html`, `documentation/en/reference/querying/default-result-format.html`, `container-search/src/main/java/com/yahoo/search/query/Presentation.java`, `container-search/src/main/java/com/yahoo/search/rendering/JsonRenderer.java`, `container-search/src/main/java/com/yahoo/search/rendering/XmlRenderer.java`, `container-search/src/main/java/com/yahoo/search/query/Trace.java`.

Review: Accepted from [presentation.timing](55bfb680-e8ac-4390-a51f-28f9821c1a72). The default is false. The flag adds a timing object or the same three attributes. It does not change the search. JSON omits `querytime` and `summaryfetchtime` when no summary fill has been recorded, and omits `searchtime` when the start time is zero. `trace.timestamps` was not restated.

### 82. What is the grouping session cache?

The grouping session cache stores intermediate grouping results on the content nodes for a multi-level grouping expression, so the query and the grouping expression run once. Without it, each level re-runs the search. The grouping reference says this is only useful when the expression uses default ordering, and that specifying `max` can make aggregates such as `count` inaccurate.

The query parameter `groupingSessionCache` enables it. The query reference default is `true`, and the query field starts `true`. The getter comment says the default is false. That comment does not match the field or the reference.

When the flag is on and the request carries a session id, the content node looks up a grouping session for that id. A hit removes the session from the cache and continues it. That path prunes the cached grouping to the request and copies the partial result into the request grouping. It does not run the search. If the session is not finished, it is put back for the next level.

Sources: `documentation/en/reference/querying/grouping-language.html`, `documentation/en/reference/api/query.html`, `container-search/src/main/java/com/yahoo/search/Query.java`, `searchcore/src/vespa/searchcore/proton/matching/matcher.cpp`, `searchcore/src/vespa/searchcore/proton/matching/sessionmanager.cpp`, `searchcore/src/vespa/searchcore/grouping/groupingsession.cpp`.

Review: Accepted from [grouping session cache](611e339e-22a6-4920-9d4d-093139ef9443). The cache holds the intermediate grouping so later levels of the same session do not search again. The default is true. The getter comment that says false is stale. The grouping expression language was not restated.

### 79. What does the query parameter ranking.rerankCount override?

`ranking.rerankCount` is a deprecated alias of `ranking.secondPhase.rerankCount`, marked for removal in Vespa 9. Both write the second-phase rerank count. That count is the number of hits ranked in the second phase on each node. The query reference documents the `secondPhase` name and does not name `ranking.rerankCount`.

When the value is set, it overrides the rank profile's second-phase `rerank-count`. The container writes it as the rank property `vespa.hitcollector.heapsize`. A total rerank count is turned into that per-node heap size only when the per-node property is absent, so a set `rerankCount` also overrides `totalRerankCount`.

If the parameter is omitted, the query count stays null. The rank profile's second-phase counts are copied only when both query rerank counts are empty. A set value is kept, including 0. The rank profile is not copied in that case, and 0 is written as the heap size. The query reference's sentence that 0 disables second-phase reranking is on `ranking.secondPhase.totalRerankCount`, not on this parameter.

Sources: `container-search/src/main/java/com/yahoo/search/query/Ranking.java`, `container-search/src/main/java/com/yahoo/search/query/properties/QueryProperties.java`, `container-search/src/main/java/com/yahoo/search/query/ranking/SecondPhase.java`, `container-search/src/main/java/com/yahoo/prelude/cluster/ClusterSearcher.java`, `container-search/src/main/java/com/yahoo/search/query/ranking/RankProperties.java`, `documentation/en/reference/api/query.html`.

Review: Accepted from [rerankCount override](43dc87b7-2e26-4faa-a06c-85681618d89b). The parameter is the deprecated per-node second-phase count. A set value, including 0, replaces the rank profile and blocks the total count from becoming the per-node heap size. The default phase counts were not restated. The content-node path that skips second phase when the heap is empty was not re-read.

### 83. What does the source selector store for each document?

For each local document id, the proton source selector stores one source id. That id is a `uint8_t`, stored in a single-value INT8 attribute. The document id is the index of the cell. A source must be below 254. On put and on remove, the index maintainer writes the current index id into that cell. New ids that have not been written yet are filled with the selector's default source, which the maintainer sets to the current index id. The feed serial is one field on the maintainer. It is not stored in the per-document cell.

A query uses that id to choose which index may match the document. The source blender seeks and unpacks only the child registered for the stored source.

This is not the federation `SourceSelector` searcher on the query chain.

Sources: `searchlib/src/vespa/searchlib/queryeval/isourceselector.h`, `searchlib/src/vespa/searchlib/attribute/fixedsourceselector.cpp`, `searchlib/src/vespa/searchlib/queryeval/sourceblendersearch.cpp`, `searchcore/src/vespa/searchcorespi/index/indexmaintainer.cpp`, `documentation/en/querying/federation.html`.

Review: Accepted from [source selector store](061d08ea-5cc6-4616-a4f0-aed15c6592df). Each document stores one source id, and matching uses only the index child for that id. The feed serial is not in that cell. Attribute flush file names were not restated.

### 81. What does trace.timestamps add?

`trace.timestamps` is a Boolean. The query reference default is `false`, and the trace field starts `false`. Enable it to get timing at `trace.level` 1, for latency in the container search chain, without the string data of higher trace levels.

`SearchHandler` sets `forceTimestamps` from that property. When the flag is on, each searcher invoke and return is traced at message level 1, and the trace node stores `System.currentTimeMillis()`. The rendered timestamp is that time minus the trace base time. Without the flag, a timestamp is recorded only when the level passed to `timestamp` is at least 6, and the invoke and return lines are emitted only when the execution trace level is at least 4.

`getTimestamps()` is also true when `trace.profile` is true, and the property read uses that getter. A separate startup path forces timestamps when the search log is FINE and a request counter is still positive. That path does not read `trace.timestamps`.

Sources: `documentation/en/reference/api/query.html`, `container-search/src/main/java/com/yahoo/search/query/Trace.java`, `container-search/src/main/java/com/yahoo/search/handler/SearchHandler.java`, `container-search/src/main/java/com/yahoo/search/query/properties/QueryProperties.java`, `container-disc/src/main/java/com/yahoo/processing/execution/Execution.java`.

Review: Accepted from [trace.timestamps](12162af7-d84e-40c1-baf3-022a14e6f13d). The flag adds container searcher timestamps at trace level 1. Without it, those timestamps wait until level 6. The content-node timing lines in the level table were not re-read. `presentation.timing` was not restated.

### 84. Which document meta store state makes a document eligible to match?

A document is eligible to match when its active-lid bit is set. Those lid states are separate bit vectors. Query setup builds a whitelist over `_activeLids` and ANDs it into the query. The proton page calls this a blocklist that ensures only active documents are matched. The matching code is a whitelist of the active lids.

The active bit is copied from the bucket's active flag. When every used lid is active, the filter search is a full search instead of the bit-vector iterator. Filling a partial result keeps a hit only when the used-lid bit is set. That used bit is a different vector. `getValidLids()` returns it.

The query is passed to the ready sub-database before this whitelist is applied. What the ready, not-ready, and removed sub-databases hold is a separate question.

Sources: `searchcore/src/vespa/searchcore/proton/documentmetastore/lid_allocator.cpp`, `searchcore/src/vespa/searchcore/proton/documentmetastore/documentmetastore.h`, `searchcore/src/vespa/searchcore/proton/matching/blueprintbuilder.cpp`, `searchcore/src/vespa/searchcore/proton/matching/match_thread.cpp`, `documentation/en/content/proton.html`.

Review: Accepted from [document meta store state](d259a61a-46d8-4c54-9ea5-ffd88942b20a). Matching requires the active-lid bit. The proton page's "blocklist" is a whitelist of those lids in the code. The used-lid bit is checked later, when hits are filled. The free-list and hold-list details were not re-read. Lid-space compaction was not restated.

### 89. Who assigns a feed timestamp when the client does not set one?

The distributor assigns it. For a put, update, or remove whose timestamp is 0, the distributor sets it with `generate_unique_timestamp()`. The put API says timestamp assignment should be left to the content cluster. A content node rejects a put, update, or remove that still has timestamp 0, so the storage nodes share the value the distributor chose.

The value is wall-clock time. The distributor reads the system clock in whole seconds and returns that second times 1,000,000 plus a synthetic counter. The counter is 0 when the wall-clock second moves forward. It increments when another timestamp is generated before that second advances, or when the clock reads no later than the highest second already used. The counter is not the clock's sub-second reading. If the clock is more than 120 seconds behind the highest second already used, the distributor process exits. A later merge keeps the entry with the greater timestamp.

Sources: `storage/src/vespa/storage/distributor/externaloperationhandler.cpp`, `storage/src/vespa/storage/storageserver/distributornode.cpp`, `storage/src/vespa/storage/storageserver/distributornode.h`, `storage/src/vespa/storageframework/defaultimplementation/clock/realclock.cpp`, `storage/src/vespa/storage/persistence/filestorage/filestormanager.cpp`, `documentapi/src/main/java/com/yahoo/documentapi/messagebus/protocol/PutDocumentMessage.java`.

Review: Accepted from [Omitted feed timestamp](c7b12eca-8477-4b23-81ea-21068d716779). The distributor fills a zero timestamp. The number is wall-clock seconds since the epoch, scaled to microseconds, plus a counter for extra writes in that second. A client-set non-zero timestamp is left as it is. Conditional writes were not restated.

### 88. What does a string attribute's enum store map?

It maps both ways. A string attribute's enum store is an `EnumStore` of `const char*`. The unique strings live in a `UniqueStore`, and each string is reached by a 32-bit `EntryRef`. The dictionary looks a string up and returns that index. `get_value` returns the stored string for an index.

Per document, the attribute vector stores the enum index, not the string. A single-value string attribute keeps one `AtomicEntryRef` per document. Reading the document loads that ref and calls `get_value`. `getStringFromEnum` is the same call.

Sources: `searchlib/src/vespa/searchlib/attribute/stringbase.h`, `searchlib/src/vespa/searchlib/attribute/enumstore.h`, `searchlib/src/vespa/searchlib/attribute/singleenumattribute.h`, `searchlib/src/vespa/searchlib/attribute/singlestringattribute.h`.

Review: Accepted from [String attribute enum store](03d7aa83-6e44-4cb6-9406-1dcdacd66b33). The store maps a string to an enum index and that index back to the string. The attribute vector stores the index. The multi-value mapping was not re-read. Attribute flush file names were not restated.

### 90. What do the ready, not-ready, and removed sub-databases hold?

Each document type has three sub-databases.

Ready (`0.ready`) holds the searchable documents. It keeps every attribute in memory and inserts the index fields into the memory index. The proton page says one ready copy of a document is active and produces query results. The other ready copies stay indexed so they can take over, and they do not produce results. Intermittently there may be more than one active copy.

Not ready (`2.notready`) holds the redundant documents that are not searchable. The proton page says they are stored and not indexed, and that moving one to ready takes processing. In code this sub-database also keeps fast-access attributes in memory. Attributes added with no files on disk are filled from the document store when the sub-database is initialized.

Removed (`1.removed`) keeps the id and timestamp of documents that have been removed, and only stores and retrieves those records. A merge uses that record: if the other node still has the document with a different timestamp, the most recent entry prevails. An entry is forgotten after the configured age. The `removed-db` prune age defaults to 2 weeks.

When the number of nodes changes, the maintenance controller moves documents between ready and not ready to match the new distribution. That move indexes or de-indexes them.

Sources: `documentation/en/content/proton.html`, `documentation/en/reference/applications/services/content.html`, `searchcore/src/vespa/searchcore/proton/server/documentsubdbcollection.cpp`, `searchcore/src/vespa/searchcore/proton/server/searchabledocsubdb.h`, `searchcore/src/vespa/searchcore/proton/server/fast_access_doc_subdb.h`, `searchcore/src/vespa/searchcore/proton/server/storeonlydocsubdb.h`.

Review: Accepted from [Ready not-ready removed](e9d1dda3-cdf5-46b4-9fb6-00aca1f2e0b6). Ready is searchable, not-ready is stored and not searched, and removed remembers ids and timestamps until they are pruned. The page's "only stored" for not-ready sits next to the fast-access attributes that code keeps in memory. The active-lid whitelist and the bucket-readiness calculator were not restated.

### 86. How many threads does one indexed query use on a content node by default?

One indexed query uses one matching thread on a content node by default.

That count is `tuning` / `searchnode` / `requestthreads` / `persearch`. The services reference default is 1, and it is the maximum number of threads used per search. When the element is unset, the model returns 1. Proton's `numthreadspersearch` also defaults to 1. Proton then stores the smaller of the CPU core count and that value. The match-engine pool for one search is at least one thread, so a stored 0 still runs as one thread. Approximate nearest-neighbor search stays single-threaded even when `persearch` is higher.

A rank profile can set `num-threads-per-search` to a lower value. When that property is absent, the C++ lookup default is the maximum `uint32`. The match uses the smaller of that lookup and the persearch thread bundle, so the query still uses the bundle of 1.

Sources: `documentation/en/reference/applications/services/content.html`, `configdefinitions/src/vespa/proton.def`, `config-model/src/main/java/com/yahoo/vespa/model/search/Tuning.java`, `searchcore/src/vespa/searchcore/proton/server/proton.cpp`, `searchcore/src/vespa/searchcore/proton/matchengine/matchengine.cpp`, `searchcore/src/vespa/searchcore/proton/matching/matcher.cpp`, `vespalib/src/vespa/vespalib/util/limited_thread_bundle_wrapper.cpp`.

Review: Accepted from [Threads per indexed query](9a52ef70-d489-4a89-86c7-bd46f3c602b3). The default is one matching thread. The `uint32` maximum is the lookup value used when the rank-profile property is absent, and it is then limited to the persearch bundle. `targetHits` was not restated.

### 87. How does Juniper choose the text of a dynamic summary?

Juniper keeps query-keyword match candidates in descending order of combined term weight, then smaller token distance, then earlier start position. It takes non-overlapping candidates until it has at least `max_matches` and the estimate is at least `min_length`. The defaults are 3 matches and 128 bytes. If that is still shorter than `min_length`, it keeps further non-overlapping matches.

Candidates belong to one match while they start inside the match window. That window defaults to 200. The fallback window is 10 times that size and is used until enough in-limit matches have been found.

The chosen keywords are then written in document order, with context on each side. `surround_max` defaults to 128. The summary length defaults to 256. The config comment calls that length a character hint. The document-summaries page says the numbers in that configuration are in bytes. `min_length` is documented as bytes.

If the query does not hit the field and prefix fallback is on, the summary is the leading text of the field, up to that length. Prefix fallback defaults to true.

Sources: `searchsummary/src/vespa/juniper/mcand.cpp`, `searchsummary/src/vespa/juniper/sumdesc.cpp`, `searchsummary/src/vespa/searchsummary/config/juniperrc.def`, `documentation/en/querying/document-summaries.html`.

Review: Accepted from [Juniper dynamic summary](71e894bf-c732-46c4-ae34-2f5743f9fe2c). The snippet is the best non-overlapping keyword windows: highest term weight, then tighter distance, then earlier in the field. The defaults are 3 matches, 128 bytes minimum, a window of 200, and a length of 256. The length unit is characters in the config comment and bytes on the summaries page. When the summary is fetched was not restated.

### 85. How are hits ordered when they have the same relevance?

Hits are sorted by relevance, highest first. The feeding tutorial says that when several hits have the same relevance, their internal order is undefined, and that this order does not change unless the documents are re-indexed.

The comparators that run after that are not one rule. When match-thread partial results are merged and there is no sort data, the lower local document id comes first. When the container merges replies from content nodes, equal relevance is ordered by global-id bytes: at the first byte that differs, the smaller unsigned value comes first. After a hit is added to the result, equal relevance is ordered by the lower add number, then by hit id. The add number is assigned when the hit is added, so that step follows add order.

Sources: `documentation/en/learn/tutorials/news-2-basic-feeding-and-query.md`, `searchcore/src/vespa/searchcore/proton/matching/partial_result.cpp`, `container-search/src/main/java/com/yahoo/search/dispatch/LeanHit.java`, `container-search/src/main/java/com/yahoo/search/result/Hit.java`.

Review: Accepted from [Equal relevance order](4bd1744d-4b61-4c11-ab6d-e456fbc03e6b). The tutorial calls the order undefined. The merge of partial results uses the lower local document id, the container merge uses global-id bytes, and the result list then uses add order. The single-thread radix sort was not re-read, so it is not claimed to keep document-id order. The query sorting language was not restated.

### 95. What does ranking.matching.anntimebudget do, and is that stop reported as coverage.degraded.anntimeout?

`ranking.matching.anntimebudget` limits one approximate nearest-neighbor search. The query reference says that if the search has not finished in that time, it stops and returns the best results found so far. Each `nearestNeighbor` operator gets that budget, so the total is the budget times the number of those operators. The value is a positive floating-point number with an optional unit. The Default cell is empty. The documented example is `25ms`.

A number with no unit is seconds. The container stores milliseconds: `25ms` is written as `25`, and a bare `2` is written as `2000`. If the parameter is omitted, `annTimeBudget` stays null and `prepare` does not write `vespa.matching.nns.anntimebudget`. The content node then sets the budget duration to `duration::max()`, so this parameter does not cap the search. When the property is present, that integer is read as milliseconds.

When the budget is the sooner deadline, its type is `BUDGET`. A missed deadline stops that index search. `timeout_hit` is set only when the search also ended early and the deadline type is `TIMEOUT`. A missed budget leaves `timeout_hit` false. The tensor-attribute test expects `approximate_nns_timeouts_hit` to stay 0 for a missed budget and to become 1 for a missed timeout.

`coverage.degraded.anntimeout` follows that timeout count. One timed-out query is counted when the count is greater than 0, and that calls `degrade_ann_timeout`. The query reference and the graceful-degradation page both say an early stop from this parameter is not a failure and is not reported as a degraded result. The result-format page defines `anntimeout` as an ANN search that stopped because of the ANN timeout. JSON writes that boolean as `anntimeout` under `coverage.degraded`.

Sources: `documentation/en/reference/api/query.html`, `documentation/en/performance/graceful-degradation.html`, `documentation/en/reference/querying/default-result-format.html`, `container-search/src/main/java/com/yahoo/search/query/ranking/Matching.java`, `container-search/src/main/java/com/yahoo/search/query/ParameterParser.java`, `container-search/src/test/java/com/yahoo/search/query/MatchingTestCase.java`, `searchlib/src/vespa/searchlib/fef/indexproperties.h`, `searchcore/src/vespa/searchcore/proton/matching/matcher.cpp`, `searchcore/src/vespa/searchcore/proton/matching/ann_deadline_configuration.cpp`, `searchlib/src/vespa/searchlib/queryeval/nearest_neighbor_blueprint.cpp`, `searchcore/src/vespa/searchcore/proton/matching/matching_stats.cpp`, `searchlib/src/vespa/searchlib/engine/searchreply.h`, `searchlib/src/vespa/searchlib/engine/proto_converter.cpp`, `container-search/src/main/java/com/yahoo/search/dispatch/rpc/ProtobufSerialization.java`, `container-search/src/main/java/com/yahoo/search/rendering/JsonRenderer.java`, `searchlib/src/tests/attribute/tensorattribute/tensorattribute_test.cpp`.

Review: Accepted from [ANN time budget flag](df0c429b-e2ef-4d68-ae22-1db65eceedb3). A missed budget does not set `timeout_hit`; the coverage flag follows a missed deadline whose type is `TIMEOUT`. When the parameter is omitted, the matcher uses `duration::max()`. `AnnTimeBudget::lookup` falls back to the maximum `uint32` only on the lookup path, which this query does not take when the property is absent. Query timeout and the other degraded flags were not restated. Exact nearest neighbor was not re-read.

### 91. What is the bucket database used for during a query?

While a query is matched, proton reads its bucket database for the coverage target-active document count. `MatchView::match` takes the document meta store's `BucketDBOwner` and passes it to `Matcher::match`. `initCoverage` and `updateCoverage` copy `getNumActiveDocs()` into the reply. That counter is the sum, over buckets whose state is active, of the ready count plus the not-ready count. An inactive bucket contributes 0. Removed documents are not in the sum.

The reply sends the value as `target_active_docs`. The container stores it as coverage target active. The search-result setter calls that the number of documents present in the ideal state. The handler calls it the number that will be searchable once redistribution has settled. The coverage percentage uses that total as the denominator. If the covered-document count is below it, the percentage is the rounded ratio of covered documents to that total. A zero total together with a timeout yields 0. Otherwise, when there is at least one result set, the percentage is 100. JSON writes it as `coverage.coverage`. If no other degrade reason is set and the percentage is not 100, coverage is degraded by non-ideal state.

Queries do not use the distributor. This read is the content node's bucket database.

Sources: `searchcore/src/vespa/searchcore/proton/server/matchview.cpp`, `searchcore/src/vespa/searchcore/proton/matching/matcher.cpp`, `searchcore/src/vespa/searchcore/proton/bucketdb/bucketdb.cpp`, `searchcore/src/vespa/searchcore/proton/bucketdb/bucketdb.h`, `searchcore/src/vespa/searchcore/proton/bucketdb/bucketstate.h`, `searchlib/src/vespa/searchlib/engine/proto_converter.cpp`, `container-search/src/main/java/com/yahoo/search/dispatch/rpc/ProtobufSerialization.java`, `container-search/src/main/java/com/yahoo/search/result/Coverage.java`, `container-disc/src/main/java/com/yahoo/container/handler/Coverage.java`, `container-search/src/main/java/com/yahoo/search/rendering/JsonRenderer.java`, `documentation/en/content/proton.html`, `documentation/en/reference/querying/default-result-format.html`.

Review: Accepted from [Bucket database during query](cf1c0eca-0d81-4f08-babd-d90c8505f5f4). The active-lid whitelist and what the ready sub-database holds were not restated. The distributor's bucket database was not re-read; the proton page says queries do not use the distributor.

### 92. What is a config generation?

A config generation is the number of the config that is active in the application. The config API calls it a monotonically increasing number, increased each time an application is deployed with `vespa deploy`, and says every config a `ConfigSubscriber` receives is of the same generation. It is the application session id. The container metric describes the live generation as the session id. The config server refuses to activate a session id that is older than the current active session.

The config server allocates the id. `SessionCounter.nextSessionId` increments a counter kept atomically across config servers and returns the next id. A new session is created with that id. Activation is logged with that same id as the generation. `Application` stores it as the generation of the config it is serving. At `vespa activate`, the newest application is made live by writing the session id, and that is when the other nodes get configured.

`ConfigSubscriber.nextConfig` returns true the first time, or when every subscribed config has a new generation, they all have the same generation, and at least one config changed. If the wait times out, nothing should be configured. If a generation requires restart, further config changes do not take effect until restart.

The container waits for that generation and builds a component graph for it. An unchanged node keeps its existing instance. A node whose dependency was cleared has its own instance cleared. Construction runs only for a node whose instance is empty, so that node is constructed again.

Sources: `documentation/en/applications/configapi-dev.html`, `documentation/en/reference/api/state-v1.html`, `documentation/en/reference/operations/metrics/container.html`, `documentation/en/operations/self-managed/configuration-server.html`, `configserver/src/main/java/com/yahoo/vespa/config/server/ApplicationRepository.java`, `configserver/src/main/java/com/yahoo/vespa/config/server/zookeeper/SessionCounter.java`, `configserver/src/main/java/com/yahoo/vespa/config/server/session/SessionRepository.java`, `configserver/src/main/java/com/yahoo/vespa/config/server/application/Application.java`, `config/src/main/java/com/yahoo/config/subscription/ConfigSubscriber.java`, `container-disc/src/main/java/com/yahoo/container/di/Container.java`, `container-disc/src/main/java/com/yahoo/container/di/componentgraph/core/ComponentGraph.java`, `container-disc/src/main/java/com/yahoo/container/di/componentgraph/core/Node.java`.

Review: Accepted from [Config generation](200dca30-af94-4db8-9bf6-7f9dcb368c35). The generation is the session id. `nextConfig` also requires that at least one config changed. `nextGeneration` does not, and that method was not used as the reconfigure signal here. The graph explain for `ConfigSubscriber` matched more than one node and was not used.

### 93. What may have happened when a client receives a failed write response?

A failed write response does not say the write was rejected before it landed. The consistency page says that if a client receives a failure response, the operation may or may not have taken place on a subset of the replicas. Replicas that were not all written are divergent, and Vespa reconciles them. The document API guide says the same for an update that returns an error: it may or may not have been applied, depending on where in the stack the error occurred. A successful response is the case that is pinned down: the write has been synced to durable storage before that response is sent.

Document v1 reports several of these failures as HTTP statuses. 429 means too many inflight feed operations. 503 means the document API could not produce a response at this time. 504 means it did not respond within the timeout. The default timeout is 180s. The handler maps the document-API outcome `TIMEOUT` to 504. 500 is an unspecified error while processing the request. A timeout while waiting for a reply is one of those ambiguous failures: the write may already have been applied.

The Java feed client retries 429. On that branch the retry does not consult the attempt limit. It retries 503 only while retries and time remain. It does not retry 500 or 504. The Go client retries 429. It retries 503 and a transport error while attempts are under 10. It classifies 504 as a Vespa failure and does not retry that status. If a client does re-send, only `assign` and `remove` are idempotent. Re-sending can apply other updates more than once.

Sources: `documentation/en/content/consistency.md`, `documentation/en/writing/document-api-guide.html`, `documentation/en/reference/api/document-v1.html`, `documentation/en/writing/reads-and-writes.html`, `vespaclient-container-plugin/src/main/java/com/yahoo/document/restapi/resource/DocumentV1ApiHandler.java`, `vespa-feed-client/src/main/java/ai/vespa/feed/client/impl/HttpRequestStrategy.java`, `client/go/internal/vespa/document/dispatcher.go`, `client/go/internal/vespa/document/http.go`.

Review: Accepted from [Failed write response](17b7a077-39fe-4422-be80-99627870ad25). Feed-block HTTP 507 and conditional test-and-set were not the answer. The document-processor transient-failure path was not re-read and is omitted. A timeout response does not prove the write never landed; the separate comments about where the timeout occurred were not reconciled.

### 96. What is a wand scoreThreshold, and what is its default?

`scoreThreshold` is an annotation on `wand`. The operator page calls it the minimum rank score for hits to include. In the annotations table it is a double, and the Default cell is empty. `{scoreThreshold: 0.13}` in the wand example is an example, not a default.

`WandItem` starts the value at 0. The setter says this is the initial threshold used by the backend, that a document's score must be larger than it to be a match, and that the default is 0.0. The parser applies the annotation only when it is present.

The score is the wand dot product of the query-token weight and the field-token weight, and that product is an `int64_t`. The stack carries the threshold as a double, and `addWandTerm` takes an `int64_t`, so the fractional part is dropped. The example value 0.13 is stored as 0. A document is kept only when the integer score is greater than the threshold. On each seek, that threshold is raised when the minimum score already in the hit heap is greater.

Sources: `documentation/en/reference/querying/yql.html`, `documentation/en/ranking/wand.html`, `container-search/src/main/java/com/yahoo/prelude/query/WandItem.java`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `searchlib/src/vespa/searchlib/query/tree/stackdumpquerycreator.h`, `searchlib/src/vespa/searchlib/query/tree/querybuilder.h`, `searchlib/src/vespa/searchlib/query/tree/termnodes.h`, `searchlib/src/vespa/searchlib/queryeval/wand/wand_parts.h`, `searchlib/src/vespa/searchlib/queryeval/wand/parallel_weak_and_search.cpp`, `searchlib/src/vespa/searchlib/attribute/attribute_blueprint_factory.cpp`.

Review: Accepted from [wand scoreThreshold](a79ca580-78fb-4975-bf44-c1e8b09094a5). The default is 0. The YQL table leaves the cell blank. A fractional threshold is truncated when it is stored as `int64_t`, and the match test is `score > threshold`. `weakAnd` uses a different comparator and was not used for this answer. `targetHits` was not restated.

### 94. What are the default maxHits and maxOffset?

The defaults are 400 for `maxHits` and 1000 for `maxOffset`.

They are query properties. `DefaultProperties` returns those numbers. Its comment says they are defaults meant to be customized in query profiles. When a query profile is present, it sits on the property chain ahead of `DefaultProperties`. A non-null profile value is used; otherwise the lookup continues, so a profile field replaces 400 or 1000. The query reference and the YQL limit/offset section state the same defaults and say both can be set in a query profile. The FAQ example sets `<field name="maxHits">500</field>` in `search/query-profiles/default.xml`.

A request that sends the name does not change the limit. `validateQuery` calls `requireNotPresentIn` on the request map. If `maxHits` or `maxOffset` is present, that throws `IllegalArgumentException` with `{name} must be specified in a query profile.` `SearchHandler.search` catches it and returns an unspecified error, code 5, summary `Unspecified error`, detailed message `Failed: ` plus that text. The handler test expects HTTP 500 for a GET or POST that sends `maxHits=42` or `maxOffset=42`.

These 400 and 1000 defaults live in that container property chain. `dispatch.def` has a different key, `maxHitsPerNode`, whose default is 2147483647.

Asking for more hits or a larger offset returns an error. The requested number is not reduced to the limit. `validateQuery` runs before the search chain. If `hits` is greater than `maxHits`, the result is an illegal query, code 3, summary `Illegal query`, with `{hits} hits requested, configured limit: {maxHits}.` followed by a link to the query reference. If `offset` is greater than `maxOffset`, the message is `Offset of {offset} requested, configured limit: {maxOffset}.` with the same link. A value equal to the limit is accepted. If both are over the limit, only the hits error is returned. The FAQ records the hits case as code 3, `401 hits requested, configured limit: 400.`

The reference says the values are capped. These checks return the errors above.

If that check passes and the YQL parser's offset is non-null, `MinimalQueryInserter` checks the parser values before copying them onto the query. An offset above `maxOffset`, or a hits value above `maxHits`, is an invalid query parameter, code 4, summary `Invalid query parameter`. For a YQL slice, hits is the limit argument minus the offset before that comparison. `limit 31 offset 7` becomes hits 24 and offset 7. `limit 40031 offset 40000` fails the offset check. `limit 40000 offset 7` fails the hits check. If the parser offset is null, this check is skipped.

Sources: `documentation/en/reference/api/query.html`, `documentation/en/reference/querying/yql.html`, `documentation/en/learn/faq.md`, `container-search/src/main/java/com/yahoo/search/query/properties/DefaultProperties.java`, `container-search/src/main/java/com/yahoo/search/Query.java`, `container-search/src/main/java/com/yahoo/search/query/profile/QueryProfileProperties.java`, `container-search/src/main/java/com/yahoo/search/handler/SearchHandler.java`, `container-search/src/main/java/com/yahoo/search/result/ErrorMessage.java`, `container-disc/src/main/java/com/yahoo/container/protect/Error.java`, `container-search/src/main/java/com/yahoo/search/yql/MinimalQueryInserter.java`, `container-search/src/main/java/com/yahoo/search/yql/YqlParser.java`, `container-search/src/test/java/com/yahoo/search/yql/MinimalQueryInserterTestCase.java`, `container-search/src/test/java/com/yahoo/search/handler/SearchHandlerTest.java`, `configdefinitions/src/vespa/dispatch.def`.

Review: Accepted from [Default maxHits and maxOffset](24d3b956-1ee9-4eac-a975-769683e6244a). The reference says the values are capped. The handler and the YQL inserter return errors and do not lower the requested number. What `hits` and `offset` select was not restated. `ranking.matchPhase.maxHits` is a different parameter and was not used. The content-node `SearchRequest.maxhits` field is the requested hit count, initialized to 10, not this cap.

### 98. Does MemoryIndex insertDocument make a document searchable before commit?

No. `MemoryIndex::insertDocument` does not make that document matchable. The class comment describes two steps. `insertDocument` adds invert tasks on the invert threads. `commit` adds push tasks on the push threads. The `insertDocument` comment says `commit()` must be called for changes to take effect. If the index is already frozen, `insertDocument` returns without queueing the document.

`insertDocument` does record the document id in `_indexedDocs` and increments `_numDocs` before `commit`. Term lookup does not read those. `createBlueprint` looks the term up with `FieldIndex::make_term_blueprint`, which calls `findFrozen` on the frozen dictionary and the frozen posting lists.

`commit` pushes the inserts and removes since the last commit. Its comment says that makes them searchable. It calls `pushDocuments` and then switches the active inverter. The push writes the batch through the field-index inserter and then `FieldIndex::commit`. That freezes the posting-list store and the dictionary allocator. Until that push runs, the inverted document is not in the structure term lookup reads.

Sources: `searchlib/src/vespa/searchlib/memoryindex/memory_index.h`, `searchlib/src/vespa/searchlib/memoryindex/memory_index.cpp`, `searchlib/src/vespa/searchlib/memoryindex/document_inverter.cpp`, `searchlib/src/vespa/searchlib/memoryindex/field_inverter.cpp`, `searchlib/src/vespa/searchlib/memoryindex/ordered_field_index_inserter.cpp`, `searchlib/src/vespa/searchlib/memoryindex/field_index.h`, `searchlib/src/vespa/searchlib/memoryindex/field_index.cpp`.

Review: Accepted from [Memory index insert vs commit](41418bbf-e7f3-4f2b-ad26-f1dc7b2add97). `insertDocument` queues inversion and updates the in-memory document count. The blueprint reads the frozen dictionary, which `commit`'s push freezes. When a fed document becomes visible to a query was not restated.

### 100. Does global-phase ranking run before or after document summaries are fetched?

Global-phase ranking runs before the summary fill. `ClusterSearcher.perSchemaSearch` searches, and when global-phase reranking is used it calls `rerankHits` on the hits that search returned, then returns that result. `rerankHits` rescores hits already on the result. It does not fill summaries. `SearchHandler.searchAndFill` calls `execution.fill` after `execution.search`. When `StatisticsSearcher` is first in the chain, it searches and then fills, and the handler skips a second fill. The re-ranking guide calls that fill the protocol phase that fetches summary data for the global top hits after the ranking phases.

Two paths fill summaries before that rerank. `IndexedBackend.doSearch2` fills the resolved summary class when `rankfeatures` is true. The query reference default for `ranking.listFeatures`, alias `rankfeatures`, is false. Streaming search fills summaries inside `StreamingBackend.doSearch2` before it returns, and `doPartialFill` ignores a later fill because streaming is single-pass.

When several schemas are searched, the merged result is larger than the requested window, and a hit orderer is set, `searchMultipleDocumentTypes` fills `VespaBackend.SORTABLE_ATTRIBUTES_SUMMARY_CLASS` after `perSchemaSearch`. That fetch is also after the rerank.

Sources: `container-search/src/main/java/com/yahoo/prelude/cluster/ClusterSearcher.java`, `container-search/src/main/java/com/yahoo/search/handler/SearchHandler.java`, `container-search/src/main/java/com/yahoo/prelude/statistics/StatisticsSearcher.java`, `container-search/src/main/java/com/yahoo/prelude/fastsearch/IndexedBackend.java`, `container-search/src/main/java/com/yahoo/vespa/streamingvisitors/StreamingBackend.java`, `container-search/src/main/java/com/yahoo/search/ranking/GlobalPhaseRanker.java`, `container-search/src/main/java/com/yahoo/search/ranking/ResultReranker.java`, `documentation/en/ranking/reranking-in-searcher.md`, `documentation/en/reference/api/query.html`.

Review: Accepted from [Global phase vs summary fetch](546f5ad6-3de2-4b28-9830-e012e5ab780d). The handler fill runs after the search that contains the rerank. The `rankfeatures` fill and the streaming fill happen inside the backend search, before `rerankHits`. Where global-phase runs and its rerank count were not restated.

### 97. What are interleaved posting-list features, and when are they stored?

Interleaved posting-list features are the field length and the number of occurrences for one document, stored with that document id in the posting list. The schema reference says `enable-bm25` creates posting lists with interleaved features in the document-id streams, which makes the bm25 score fast to compute.

They are stored when the index field's `interleavedfeatures` flag is true. That flag defaults to false. The schema token `enable-bm25` sets it to true, and that value is written onto the index as `interleavedfeatures`. A memory index for such a field uses `FieldIndex<true>`, whose posting-list entry stores the two values. A disk index encodes them in the document-id stream after each document id, and records `interleaved_features` in the posting-list file header.

The BM25 reference's example is an indexed string field `content` with `index: enable-bm25`, ranked with `bm25(content)`. That page says that if `enable-bm25` is turned on after documents are already fed, proton flushes the memory index and then fuses the disk index so those posting lists are prepared.

Sources: `documentation/en/reference/schemas/schemas.html`, `documentation/en/ranking/bm25.html`, `configdefinitions/src/vespa/indexschema.def`, `config-model/src/main/javacc/SchemaParser.jj`, `config-model/src/main/java/com/yahoo/schema/parser/ConvertParsedFields.java`, `config-model/src/main/java/com/yahoo/schema/Index.java`, `searchlib/src/vespa/searchlib/memoryindex/posting_list_entry.h`, `searchlib/src/vespa/searchlib/memoryindex/field_index_collection.cpp`, `searchlib/src/vespa/searchlib/diskindex/fieldwriter.cpp`, `searchlib/src/vespa/searchlib/diskindex/zc4_posting_writer_base.cpp`.

Review: Accepted from [Interleaved posting features](6e5439ac-5e95-4367-ac21-7dd1712b0a4f). The two stored values are field length and number of occurrences. The flag defaults to false, and `enable-bm25` sets it. When a fast-search attribute posting list gains a bitvector was not restated.

### 99. During fusion warmup, which disk indexes can a query still read, and for how long?

During the warmup window, the query blueprint comes from the previous index collection. `WarmupIndexCollection::createBlueprint` returns that previous collection's blueprint until warmup is done. For a fusion swap, that collection is the one that was current before the swap: the previous fusion disk index when it is one of those sources, and the flushed disk indexes this fusion combined. The new fusion index is the disk index being warmed. Its blueprint is built on a background task and is not the blueprint returned to the query.

The window is installed only when `index.warmup.time` is greater than 0 and the swapped-in source is a disk index. The config value is seconds, and the default is 0.0, which installs no warmup collection. The deadline is the warmup collection's construction time plus that duration. It ends when a later blueprint for a string term that has not been warmed yet finds the clock at or past the deadline. That posts warmup done, and later blueprints come from the next collection. The window also ends if the warmup collection is destroyed, which is logged as aborted by a new state change or application shutdown. A newer index swap while one warmup is still running logs that it will start using that index immediately and unwraps to the next collection.

While an older collection still references a disk index, `DiskIndexes::remove` refuses it because its active count is not zero, so the cleaner does not delete that directory. The disk-index comment says those indexes are removed when every older collection that references them has been destroyed.

Sources: `searchcore/src/vespa/searchcorespi/index/warmupindexcollection.cpp`, `searchcore/src/vespa/searchcorespi/index/indexmaintainer.cpp`, `searchcore/src/vespa/searchcorespi/index/indexcollection.cpp`, `searchcore/src/vespa/searchcorespi/index/fusionrunner.cpp`, `searchcore/src/vespa/searchcorespi/index/disk_indexes.cpp`, `searchcore/src/vespa/searchcorespi/index/diskindexcleaner.cpp`, `searchcore/src/vespa/searchcore/proton/server/documentdb.cpp`, `configdefinitions/src/vespa/proton.def`, `documentation/en/reference/applications/services/content.html`.

Review: Accepted from [Fusion warmup sources](54da59da-51fa-4cf4-bf7a-addac452afe6). The query reads the previous collection for `index.warmup.time` seconds, default 0.0. The services page says the index being switched in receives the queries and the results are ignored. In this code, that is the background warmup task. The blueprint returned to the query is the previous collection. Which sources a query reads after fusion has replaced the flushed indexes was not restated.

































































