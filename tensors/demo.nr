#%%bash
#H1 Prerequsites
# Run latest Vespa
podman run -d --name tensors --hostname tensors \
  --publish 8080:8080 --publish 19071:19071 \
  docker.io/vespaengine/vespa@$(crane digest docker.io/vespaengine/vespa)
#%%markdown
#H1 What are tensors?
![tensor types](tensors.png)