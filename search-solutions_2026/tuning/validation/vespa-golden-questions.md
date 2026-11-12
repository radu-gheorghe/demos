1. What is an application package?
2. What is a schema?
3. What is services.xml for?
4. What is the format of a Vespa document id?
5. What is the difference between a container cluster and a content cluster?
6. What is a rank profile?
7. What is YQL?
8. What does feeding a document mean in Vespa?
9. What do index, attribute, and summary mean on a Vespa field?
10. What is a document summary?
11. What is a query profile?
12. What is the smallest application package that can store and query documents?
13. What happens when you deploy an application package?
14. What is the difference between a schema name and a document type?
15. What does Vespa return when a query does not name a document summary?
16. What do the field match settings text, word, and exact do?
17. What is an indexing statement?
18. How do array, weightedset, and map field types differ?
19. What is a struct field, and what can be indexed on it?
20. What is the difference between a dense, sparse, and mixed tensor?
21. What are the stemming settings, and which is the default?
22. What is a fieldset?
23. How does rank-profile inheritance work?
24. Where do first-phase, second-phase, and global-phase ranking run, and what are their default rerank counts?
25. What does the bm25 rank feature compute, and what does a field need for it?
26. What does nativeRank combine?
27. What is a ranking expression?
28. What does rank: filter do?
29. How does bolding work?
30. Which indexing modes make a field searchable?
31. What do attribute fast-search and fast-access do?
32. How is a position field stored and queried?
33. What are the parts of a YQL select statement?
34. What does userInput do?
35. What does weakAnd do?
36. What arguments does nearestNeighbor take?
37. What does a Vespa grouping expression do?
38. How does Vespa sort hits?
39. What do timeout and softtimeout do?
40. How does a query choose a rank profile?
41. What does presentation.summary select?
42. What are the aliases for hits and offset, and what other limit combines the caps?
43. What does the trace query parameter do?
44. What does the coverage object in a query response mean?
45. What do the coverage.degraded flags mean?
46. How does a partial document update work?
47. How does a conditional document write work?
48. How does document visit selection work?
49. What is an imported field, and what can a query do with it?
50. What is a query profile type, and how does it constrain a query profile?
51. How does streaming search differ from indexed search?
52. Which settings control an HNSW index on a tensor field?
53. How do targetHits, totalTargetHits, and hnsw.exploreAdditionalHits limit nearest-neighbor search?
54. What does nearestNeighbor approximate:false do?
55. What does global-phase ranking do, and what is its rerank-count?
56. What does match-phase degradation do, and how does a diversity block change which documents it keeps?
57. How does a rank profile evaluate an ONNX model?
58. What is an embedder, and how does a schema use it?
59. In indexed search, where does Vespa get term significance, and do BM25 and weakAnd read the same value?
60. What does the linguistics pipeline do to a string field at feed time and at query time?
61. What does n-gram indexing do, and which match modes use it?
62. What is a searcher chain, and which chain runs by default?
63. What is a document processor, and when does it run?
64. What does reindexing do, and which schema changes require it?
65. What is the difference between adding a field and changing a field's type?
66. What is a predicate field, and how does a query match it?
67. What does a grouping continuation do, and when is one returned?
68. When does Vespa fetch document summaries relative to matching and ranking?
69. Where are BM25 k1 and b set, and which BM25 features exist besides bm25(field)?
70. What does BM25 count as a term's document frequency?
71. What do nativeFieldMatch, nativeProximity, and nativeAttributeMatch each measure?
72. How does the and operator differ from weakAnd?
73. What does the filter annotation on a query term do, and how does it differ from ranked?
74. How does a query test that a field is present or missing?
75. Where does Vespa read a rank feature that is used as a sort key?
76. How does a field path address a map entry or a struct field?
77. How does matching a weighted set differ from matching an array of strings?
78. What do match-features and summary-features return, and when is each calculated?
79. After activate, how does an application package become the configuration a node uses?
80. When does a fast-search attribute posting list gain a stored bitvector, and when is that bitvector removed?
81. What is a query item label, and which rank features read it?
82. After linguistics, which form of a word is written into the text index?
83. How does a rank profile declare a query tensor, and what happens if the query omits it?
84. What is a rank-profile constant, and how is a rank-profile function called?
85. When does filtered nearestNeighbor search use exact search, filter-first, or distance-first?
86. What causes Proton to flush the memory index into a new disk index?
87. Do the nearestNeighbor filter annotations use the same defaults as the rank-profile HNSW filter properties?
88. What is a Proton local document id, and when is one assigned or reused?
89. Which index does BM25 read for document frequency and average field length?
90. Why does an indexed struct-field string not become a searchable text index?
91. What does vespa.eval.use_fast_forest change, and what is its default?
92. Which class turns a YQL select string into the query tree?
93. What object does HNSW receive as the global filter, and what does a check of one document do?
94. When does a successfully fed document become visible to a query?
95. Does Lucene linguistics change how the C++ index matches a term?
96. Where is a query item label stored on the way from YQL to ranking?
97. What do near and onear require, and what distance is used when the query does not set one?
98. Can a query supply the document frequency BM25 uses?
99. After fusion replaces flushed disk indexes, which sources does a query read?
100. When a proton match thread is ranking, does it unpack a hit before or after that hit can enter the rank heap?
