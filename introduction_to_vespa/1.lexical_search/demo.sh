# Vespa container

# make sure we start fresh
podman rm -v vespa-custom-components

podman run --name vespa-lexical-search --hostname vespa-lexical-search \
  --publish 8080:8080 --publish 19071:19071 \
  vespaengine/vespa

# deploy the app
cd ecommerce_app
vespa deploy