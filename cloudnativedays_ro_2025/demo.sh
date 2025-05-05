### prerequisites

# create a kind cluster
kind create cluster --name vespa

# if you're using podman, make sure it allows enough pids
podman update --pids-limit 16384 \
    $(podman ps --filter label=io.x-k8s.kind.cluster=vespa -q)

# create the namespace
kubectl create namespace vespa

### Here we go!

# start the configserver
kubectl apply \
  -f config/configmap.yml \
  -f config/configserver.yml \
  -f config/headless.yml

# make sure they're good
watch kubectl get pods -n vespa

# port forward the configserver
kubectl port-forward -n vespa pod/vespa-configserver-0 19071

# check health
curl http://localhost:19071/state/v1/health

# start the other nodes
kubectl apply \
  -f config/service-container.yml \
  -f config/admin.yml \
  -f config/container.yml \
  -f config/content.yml

# make sure they're good
watch kubectl get pods -n vespa

# deploy the application
vespa deploy

# port forward the container nodes
kubectl port-forward -n vespa svc/vespa-container 8080 

# check health
curl http://localhost:8080/state/v1/health

# put a doc
curl -X POST -H "Content-Type:application/json" --data '
  {
      "fields": {
          "artist": "Coldplay",
          "album": "A Head Full of Dreams",
          "year": 2015
      }
  }' \
  http://localhost:8080/document/v1/mynamespace/music/docid/a-head-full-of-dreams

# query
vespa query 'select * from music where album contains "dreams"'