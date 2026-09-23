#%%markdown
![This demo](qr-code.jpg)
#%%bash
#H1 Prerequsites
# Run latest Vespa
podman run -d --name tensors --hostname tensors \
  --publish 8080:8080 --publish 19071:19071 \
  docker.io/vespaengine/vespa@$(crane digest docker.io/vespaengine/vespa)
#%%markdown
#H1 What are tensors?
![tensor types](tensors.png)
#%%markdown
#H1 Sparse tensors
[In Tensor Playground](https://docs.vespa.ai/playground/#N4KABGBEBmkFxgNrgmUrWQPYAd5QGNIAaFDSPBdDTAF30gBkBTWgcgGcwATZ6ASwB2zMLQDuWHlgIBXALbNBtLgCdmONR0W0hAc1ESwAIwCGg7h0hlUAX2s3SGauVwNmJaxAr5nNSIIYAYSwAG24cEJMATw8aTHcESFpFDiwVAApdRU1gGwBKOGAAHUgVaQBrErgABgA6AGZiMBKcXCqwOoAOGys4uwwHa18vV0T3Rz9KNE9MAMSAWVYTEJD+AhNYuKgEqGTBVIyswRz8wpKygkr4OoBOJpa2-DqAJh6Z-tsJiGGoUcJN8hTH5eeiJAByWDEYBCrE4YBwMloogAFiIZFoVPC1NBmGpBARmFx0rwBMJuGATEiAI4yXFRUT8BR5Xo0D4QQZOGbYKaQcZcoEzLxzKByKK0EwcZIAvw7JIpNKZbKE3IFYqlCpVOoAdnuFEeCDqABZdUYQrSOO1bm8+vYvtM4tyGEQ7V4BVtdkEsHIEckwMjIWAxMwVmBgmEItEwHJKQRUVxaKiwOjcaIJclakVBJmAFTZsEAeQAKgBRXMIACSghRIjkMhCOgia0p-CwgiarZC9ITNZjyL0YAJKy4JjUA+WskiyW4cBZA1tQy5f150tdPkFUGFkBX8U94ci9OzUbFafc73nnIdS+d-LX7qSDELie4WCRGiw3BkBCR-Hjidr9f4Rt1h0VswGgUIQkhZhySMekTDADh5DALAADcU27AcvTkUDuEZFIW0EGczwGO0fkdMZt28Kh138Bhty8WVELkdIw3Cfds1FcVJWYJojk0ZliM+BdLx5a8HTdLZ70SR8fzAWTmBpfgUOWbRRCwIibRI4S-CXPlxNvSTN3o7YGDUD8CXSAArLAhBY0I2OiJpOJPJpoHSAAPYgojyDzs28vImiYgTNKEi8dNEyiJIdUEoAhKEYXYLgCC9H0REWcUVibOEOGS0cxH4BMwDUXQRwsNSUVk5MVDhLipUE9lSMXHk9MmAyHSMl0d0SJj0nS5ZVnWDjj243ilQ4YLWXPVAyKvSK2r8GLIAACX4XRURUJojGYdZkzAAADC5yj2qQ5CESlCWrBDcuYWpZ1sKbviatw5uou8Opo2U+sywbnO4u72XsFAAF0QBsIA)
#%%bash
#H2 Deploy the equivalent sample app
cd 1.sparse_tensors
vespa deploy --wait 300
#%%bash
#H2 Feed the Coldplay and Metallica tensors
vespa feed documents.jsonl
#%%vespa
POST /search/
{
  "yql": "select name, genres from band where true",
  "ranking": "genre_similarity",
  "input.query(mytaste)": {
    "cells": {
      "rock": 0.7,
      "pop": 0.4,
      "blues": 0.9
    }
  },
  "presentation.format.tensors": "short"
}
#%%markdown
#H2 Not everything is a tensor
Consider the popularity dimension: let's multiply the tensor dot product by `log10(popularity)`. Coldplay has popularity 100 while Metallica has 10, so we reverse the result order.
#%%bash
cd ../2.sparse_tensors_popularity
vespa deploy --wait 300
#%%bash
#H2 Feed the documents with popularity
vespa feed documents.jsonl
#%%vespa
POST /search/
{
  "yql": "select * from band where true",
  "ranking": "genre_similarity_with_popularity",
  "input.query(mytaste)": {
    "cells": {
      "rock": 0.7,
      "pop": 0.4,
      "blues": 0.9
    }
  },
  "presentation.format.tensors": "short"
}
#%%markdown
#H1 Dense Tensors
[In Tensor Playground](https://docs.vespa.ai/playground/#N4KABGBEBmkFxgNrgmUrWQPYAd5QGNIAaFDSPBdDTAF30gAMATLAgVwFsBTAO1sZgAhr2ZhGAR3bcATgE9BQgM5hmfJdzC11WGUriQyqAL5HjpDNXK4G3EkYgV8VmpF4NWHHv3s1MdhEhtXiVdAAoAD0QAZgBdAEo4RAAGADoAJgA2AHYsgEZ0gBY8gE484gg0gFZowqr0ooAOaMb0irA0xuS87ObcquzC2MM-UwxzIxdHG0C7C1dKNAdMd0CpWTlfPygAqGDQmUiYhKTOvMzCksyqrpLoioBaNMLk1sLWkuTCzPbn16b0p9vsNlmMTPMIFMoDNCFtyIsoY56IEACoAC00tAA7lgtDo9GA0UIAG6YjFgJRCHiqACW3iUNKwvDAvCp3CUFVCwjAnHYABtaDScHyaQQhIKmWAaSpuHzuN5aA8sdLuAZQWYIUs-NhFpA5ssnFRlo5VlA4a5dpBPFw+LQwAAqMDreQjGhgiATSwGmGQIiaxwI417BjozSsO04GRYZjsAh26VaclKLgqLCkmSJzQELCcTiS5h09SM3hq0Yaybe3X67WB7ZQU2Qc3kS3Jzhha0K+3OuTxV3jMwoWIgYxAA)
#%%markdown
#H1 Forward compatibility: Late Interaction
!["normal" vector search similarity](https://blog.vespa.ai/assets/2024-02-14-announcing-colbert-embedder-in-vespa/image5.png)
#%%markdown
![Late interaction](https://blog.vespa.ai/assets/2024-02-14-announcing-colbert-embedder-in-vespa/image1.png)

More details [here](https://blog.vespa.ai/announcing-colbert-embedder-in-vespa/)
#%%markdown
[MaxSim example](https://docs.vespa.ai/playground/#N4KABGBEBmkFxgNrgmUrWQPYAd5QGNIAaFDSPBdDTAF30gAMBHAVwFMAnATwH1auAWwDOjMAEMAdgBMwjaVgKtB7SbX5DRYAljXiAlpLC72YdoIBG7adMMBzMADd2BWlk5gcXMAM6CAdHLMtMAAvmJSsvIh4RKcpoLiOF6ytiqSwvq6wsRgAO4AFlymtEVgADbiVuXCYPrSqrT60Nw+Zb4icJBkqKE9oaQY1OS4DOwkPRAU+MM0kJIMbFx8HcITNJjjCJACGe4AFMFhuQAeiADMALoAlHDAADpGYPeQwgX6yfYvCIgAjP4ABlyAMBwMBl2IjwgL2E7HE3w2iBBQLA-xRyMuj1C3Q2fQwAx6symo2240Gc0oaEmmAW2wUSnS6lW6w2UC2UF2wgO0hipwuNzuUOekAI4k4diwCKR-gAHGCAGxggEQoUvRRwyRSkGKsAguW68GQp4vaCcVj6Wha0EGlFozGSbHUvG9ckQIlQEmEFnkSnuqb0bYAFXaQjAaVUmWyYAK4mcYea0GKajAknEKlq+xYtAiMjkPMY11yhX05VMjBOYn0tTeYusgQAsqxyk0cOV9KKmro2sVoO5TDhOFhpKwCOxauxnDwwEseABaDoAenpyka89DOkshnEnckXSd-VdVI22EpkDJ1OmVGpU1pHKEvAHQ5HtDWh-I7MgM5WmjAACow4oK5qBofhrPu+KHu6J4MEQb5QL614cgwADKyiCPYxiTt2ZiWNYtiSA44YZFkRjlmIG44KwAi1KUpgKLQniDsOrhgFYtB5OwqhmJOrRfj4oaRNxywAQyjT8X4e64gehIXp6Z7epgCGslAt47PemToZUnAWvoY4Ke+DDxMx7CHBwPAgSIf4iUBTKaLkwjKKc1w4jQzoQASQyyaesEXkprI7AwADCWDlAAQgAogASoGYD1uIJzIfoghgNAhjSDRZRWMIDGJLQBDvAR1mMuJyW9h4cL5dOZmtB0kmudJnnHnJ57Hn5x6qVl6i5flD5cLwX4WfpmyGdYI4mUZY2mcsFm1P+y6MjN9mOWAJyFmAiQnLkPLOeBLoyU13lDZeR7+QGUAAGJbuU5TcEtyW0axY45dulVlWY4iVXxHQ+FgYB2OwDEPcFYVRTFcUJUlYDCDo8R1fiDWoFBzVHW1cyqRtvAaUNUwfhNo77Hj42jfjA2rFZ82NItUPLatuQbVttBrQ5gi5MEO1SfDECXCAoRAA)
#%%markdown
#H1 Not only vectors: Elementwise BM25
1. Calculate BM25 score for every matching chunk.
2. Maximum score ranks the parent documents.
3. Return top 3 chunks of each doc by BM25 score.

See [another Maven lesson with Doug for more on chunking](https://maven.com/p/e2a6af/beyond-chunks-how-to-actually-data-model-for-rag)
#%%bash
#H2 Deploy the standalone app
cd ../3.elementwise_bm25
vespa deploy --wait 300
#%%bash
#H2 Feed two documents with six chunks each
vespa feed documents.jsonl
#%%vespa
#H2 The documents we ingested
POST /search/
{
  "yql": "select * from sources * where true",
}
#%%vespa
#H2 Rank documents by their best chunk and return their top three chunks
POST /search/
{
  "yql": "select * from wiki where chunks contains text('distributed search')",
  "ranking": "best_chunk_bm25",
  "presentation.summary": "top_3_chunks"
}
#%%bash
#H1 To tensor or not to tensor: BM25 score per label
cd ../4.bm25_for_labels
vespa deploy --wait 300
#%%vespa
#H2 Dynamic boosts with a sparse label tensor
POST /search/
{
  "yql": "select title from wiki where ({label:\"exact\"}title contains phrase(\"search\", \"engine\")) or ({label:\"synonym\"}title contains phrase(\"search\", \"platform\"))",
  "ranking": "tensor_label_boosts",
  "input.query(label_boosts)": {
    "cells": {
      "exact": 3.0,
      "synonym": 0.5,
      "vague": 0.02
    }
  },
  "presentation.format.tensors": "short"
}
#%%vespa
#H2 The same boosts written explicitly (faster)
POST /search/
{
  "yql": "select title from wiki where ({label:\"exact\"}title contains phrase(\"search\", \"engine\")) or ({label:\"synonym\"}title contains phrase(\"search\", \"platform\"))",
  "ranking": "manual_label_boosts",
  "input.query(exact_boost)": 3.0,
  "input.query(synonym_boost)": 0.5,
  "hits": 2
}
#%%markdown
#H1 Other examples
Use the [sample apps](https://github.com/vespa-engine/sample-apps), Luke!
#%%markdown
#H2 Custom scoring function: BM25F-style
[schema](https://github.com/vespa-engine/sample-apps/blob/master/examples/bm25f/app/schemas/bm25f.sd)
#%%markdown
#H2 Model integration: Cross-encoders
[schema](https://github.com/radu-gheorghe/demos/blob/main/cross_encoders/vespa_app/schemas/product.sd)

[Full Maven lesson here](https://maven.com/p/bc4193/cross-encoders-an-end-to-end-guide)
#%%markdown
#H2 Implementing a paper: Hyperencoders
[schema](https://github.com/vespa-engine/sample-apps/blob/master/hypencoder/app/schemas/doc.sd)
#%%markdown
#H2 Implementing a paper: Bayesian BM25
[schema](https://github.com/vespa-engine/sample-apps/blob/master/examples/bayesian_bm25/app/schemas/doc.sd)