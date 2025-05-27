# new Vespa container

podman rm -v vespa-lexical-search

podman run --name vespa-vector-search --hostname vespa-vector-search \
  --publish 8080:8080 --publish 19071:19071 \
  vespaengine/vespa

# deploy the app
cd embedder_ann
vespa deploy

# feed the data
vespa feed 1K_products.jsonl