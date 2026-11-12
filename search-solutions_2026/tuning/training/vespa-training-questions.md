1. What do redundancy and searchable-copies each control, and what are their defaults?
2. What is a Vespa bucket?
3. What does deployment.xml control?
4. What does the config server do that the config proxy on a node does not?
5. How does a document/v1 GET differ from a search query?
6. What does global="true" on a document type mean?
7. What is a reference field?
8. What is store-only mode?
9. What is validation-overrides.xml for?
10. What is the document store?
11. What is the transaction log for?
12. What is ideal state?
13. What is a content cluster group?
14. What is a cluster controller?
15. What is a distributor?
16. What does normalizing do, and what is its default?
17. Which attributes can be paged, and what does paged change?
18. What does match: cased do on a string attribute?
19. What is a schema-level constant tensor?
20. What is num-threads-per-search, and what is its default?
21. What is rank-score-drop-limit?
22. What is a dynamic summary?
23. What does a summary field's source select?
24. What is a URI field, and how is it queried?
25. What tensor cell type does distance-metric: hamming require?
26. What is indexing: input for?
27. What does matched-elements-only do?
28. What does the firstPhaseRank feature return?
29. What is termwise-limit?
30. What bounds does a predicate field declaration take?
31. What does an attribute sorting block set, and what is the default sort function?
32. What is the rank-profile averageFieldLength setting for bm25, and when is it used?
33. What does the phrase operator require?
34. What does equiv do?
35. What does the rank query operator do?
36. What does dotProduct require of the field and the query?
37. What does fuzzy match, and what is the default maximum edit distance?
38. Are the endpoints of a numeric range query inclusive?
39. What is model.defaultIndex?
40. What is model.restrict?
41. What is model.locale, and what does it change?
42. What is model.sources?
43. What does ranking.listFeatures return?
44. What does where true match in indexed search?
45. What do grouping max and precision default to?
46. What is model.filter?
47. What is a document selection on a content cluster, as distinct from a visit selection?
48. What does rank-profile strict do?
49. What does the freshness rank feature compute?
50. How do closeness(field) and distance(field) differ?
51. What does an attribute flush write, as distinct from a memory-index flush?
52. What is lid-space compaction, and what triggers it?
53. What does flush-on-shutdown flush, and what is its default for a hosted deploy?
54. What data lives in the log data store?
55. What does a bucket split do?
56. What does maintenance state mean for a content node?
57. What is the search coverage minimum setting?
58. What is the default redundancy when services.xml omits it?
59. What is the difference between reindexing and reprocessing?
60. What happens to a feed write when a content node is above its resource limit?
61. What is min-redundancy?
62. What is a garbage-collection selection?
63. How does the container choose which content group receives a query?
64. What does sync-transactionlog do, and what is its default?
65. What does a bucket merge do?
66. What changes when the distribution bit count changes?
67. What is hierarchical content distribution?
68. What document count or size triggers a bucket split?
69. What is sameElement's match scope?
70. What does the weightedSet query operator match?
71. What does the in operator match?
72. What does a leading ! on a query term do?
73. What is the default weight of a query term?
74. What is the connectivity annotation?
75. What does the userQuery operator expand to?
76. What does a language annotation on a query term do?
77. What is distanceThreshold on nearestNeighbor, and what is its default?
78. What is target-hits-max-adjustment-factor, and what is its default?
79. What does the query parameter ranking.rerankCount override?
80. What does presentation.timing add to the response?
81. What does trace.timestamps add?
82. What is the grouping session cache?
83. What does the source selector store for each document?
84. Which document meta store state makes a document eligible to match?
85. How are hits ordered when they have the same relevance?
86. How many threads does one indexed query use on a content node by default?
87. How does Juniper choose the text of a dynamic summary?
88. What does a string attribute's enum store map?
89. Who assigns a feed timestamp when the client does not set one?
90. What do the ready, not-ready, and removed sub-databases hold?
91. What is the bucket database used for during a query?
92. What is a config generation?
93. What may have happened when a client receives a failed write response?
94. What are the default maxHits and maxOffset?
95. What does ranking.matching.anntimebudget do, and is that stop reported as coverage.degraded.anntimeout?
96. What is a wand scoreThreshold, and what is its default?
97. What are interleaved posting-list features, and when are they stored?
98. Does MemoryIndex insertDocument make a document searchable before commit?
99. During fusion warmup, which disk indexes can a query still read, and for how long?
100. Does global-phase ranking run before or after document summaries are fetched?
