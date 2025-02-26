# Vespa container

podman run --name vespa-bigdatabu --hostname vespa-bigdatabu \
  --publish 8080:8080 --publish 19071:19071 \
  vespaengine/vespa

# lexical search application package

vespa deploy ecommerce

# semantic search application package

vespa deploy embedder_ann

# feed sample data for semantic search
# NOTE: you can also use Logstash to feed data into Vespa
#       see https://blog.vespa.ai/logstash-vespa-tutorials/

vespa feed vespa_feed-1K_no_embeddings.jsonl