#%%markdown
# TODO:
 - explain schema and export script
 - Cross-encoders vs others: markdown
 - use as 2nd phase re-ranker
 - use GPU on global phase (Cloud? Different app?)
 - quantize? performance? finetuning?
#%%bash
#H1 Export transformer to ONNX
# This may not work for all models => a Python script will be needed
# example from https://docs.vespa.ai/en/ranking/cross-encoders.html
# optimum-cli export onnx --task text-classification -m BAAI/bge-reranker-base ranker
#%%bash
#H1 Run Vespa
# local deployment
# use Vespa Cloud for easy GPU support
podman run --name cross-encoders --hostname cross-encoders \      
  --publish 8080:8080 --publish 19071:19071 \
  docker.io/vespaengine/vespa@$(crane digest docker.io/vespaengine/vespa)
#%%bash
#H1 Deploy app
vespa deploy vespa_app --wait 900
#%%vespa
#H1 Test doc
POST /document/v1/mynamespace/product/docid/2
{
  "fields": {
    "title": "This is a test"
  }
}
#%%vespa
#H1 Test queries
# BERT
POST /search/
{
  "yql": "select * from product where true",
  "input.query(q_tokens)": "embed(tokenizer, \"test\")",
  "ranking": "bert-ranker",
  "timeout": 5000
}
#%%vespa
# ModernBERT
POST /search/
{
  "yql": "select * from product where true",
  "input.query(q_tokens)": "embed(ettin-tokenizer, \"trying out things\")",
  "ranking": "modern-bert",
  "timeout": 5000
}