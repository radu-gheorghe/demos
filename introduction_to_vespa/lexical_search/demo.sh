# Vespa container

podman run --name vespa-lexical-search --hostname vespa-lexical-search \
  --publish 8080:8080 --publish 19071:19071 \
  vespaengine/vespa
