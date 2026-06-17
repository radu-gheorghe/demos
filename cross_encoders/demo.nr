#%%markdown
#H1 Big picture
![bi-encoders vs cross-encoders diagram](https://raw.githubusercontent.com/radu-gheorghe/demos/refs/heads/main/cross_encoders/images/bi-vs-cross.png)
#%%markdown
#H2 It's all about where the interaction
## There are middle grounds, like late interaction
![late interaction diagram](https://blog.vespa.ai/assets/2024-02-14-announcing-colbert-embedder-in-vespa/image1.png)
#%%bash
#H1 Export transformer to ONNX
# This may not work for all models => a Python script will be needed
# example from https://docs.vespa.ai/en/ranking/cross-encoders.html
# optimum-cli export onnx --task text-classification -m BAAI/bge-reranker-base ranker
#%%bash
#H1 Prepare Vespa
# local deployment
# use Vespa Cloud for easy GPU support
podman run --detach --name cross-encoders --hostname cross-encoders \
  --publish 8080:8080 --publish 19071:19071 \
  docker.io/vespaengine/vespa@$(crane digest docker.io/vespaengine/vespa)
#%%bash
#H2 Deploy app
vespa deploy vespa_app --wait 900
#%%vespa
#H2 Test docs
POST /document/v1/mynamespace/product/docid/2
{
  "fields": {
    "title": "This is a test"
  }
}
#%%vespa
POST /document/v1/mynamespace/product/docid/1
{
  "fields": {
    "title": "Sony WH-1000XM5 wireless noise cancelling headphones"
  }
}
#%%vespa
#H1 Profit :)
# BERT
POST /search/
{
  "yql": "select * from product where true",
  "input.query(q_tokens)": "embed(bert-tokenizer, \"test\")",
  "ranking": "bert",
  "timeout": 5000
}
#%%vespa
# ModernBERT
POST /search/
{
  "yql": "select * from product where true",
  "input.query(q_tokens)": "embed(modernbert-tokenizer, \"trying out things\")",
  "ranking": "modern-bert",
  "timeout": 5000
}
#%%markdown
#H1 Best practices
**TL;DR** from a [previous Maven lesson](https://notpptx.com/vespaai/choosing-finetuning-embedder)
## Finetune on your data
Use query-document pairs from relevance judgements

Mine hard negatives

## Quantize
`int8` on CPUs

`fp16` on GPUs
