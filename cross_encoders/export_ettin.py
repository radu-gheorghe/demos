#!/usr/bin/env python
"""Export cross-encoder/ettin-reranker-17m-v1 to a single-score ONNX for Vespa.

Run with the project venv:  .venv/bin/python export_ettin.py

This model is a sentence-transformers v5 *modular* CrossEncoder:

    ModernBERT backbone -> CLS pooling -> Dense(256->256, GELU, no bias)
                        -> LayerNorm(256) -> Dense(256->1, bias) -> score

`model.safetensors` holds only the backbone; the head lives in the 2_Dense /
3_LayerNorm / 4_Dense module folders. The ONNX shipped in the repo only emits
`last_hidden_state`, so we compose backbone + head into one graph that takes
(input_ids, attention_mask) and returns a single relevance score per pair --
exactly what Vespa's cross-encoder rank profile consumes as onnx(...){d0:0,d1:0}.

Correctness is gated by comparing against sentence_transformers' own
CrossEncoder.predict() -- if the composition is wrong, the assert trips.
"""
import pathlib

import numpy as np
import onnxruntime as ort
import torch
import torch.nn.functional as F
from huggingface_hub import hf_hub_download
from safetensors.torch import load_file
from sentence_transformers import CrossEncoder

MODEL_ID = "cross-encoder/ettin-reranker-17m-v1"
OUT_DIR = pathlib.Path(__file__).parent / "vespa_app" / "models"
# Vespa derives a model name from each file under models/ and requires it to be
# alphanumeric/underscore only -- so no hyphens in these filenames.
ONNX_PATH = OUT_DIR / "ettin_reranker_17m.onnx"
TOKENIZER_PATH = OUT_DIR / "ettin_tokenizer.json"
OPSET = 18
MAX_LEN = 256

OUT_DIR.mkdir(parents=True, exist_ok=True)


class EttinReranker(torch.nn.Module):
    """Backbone + ST head fused into one module emitting a [batch, 1] score."""

    def __init__(self, backbone, w_dense1, w_ln, b_ln, w_dense2, b_dense2):
        super().__init__()
        self.backbone = backbone
        self.register_buffer("w_dense1", w_dense1)  # (256, 256), no bias
        self.register_buffer("w_ln", w_ln)          # (256,)
        self.register_buffer("b_ln", b_ln)          # (256,)
        self.register_buffer("w_dense2", w_dense2)   # (1, 256)
        self.register_buffer("b_dense2", b_dense2)   # (1,)

    def forward(self, input_ids, attention_mask):
        hidden = self.backbone(input_ids=input_ids,
                               attention_mask=attention_mask).last_hidden_state
        cls = hidden[:, 0]                                   # 1_Pooling: CLS token
        x = F.gelu(F.linear(cls, self.w_dense1))             # 2_Dense + GELU
        x = F.layer_norm(x, (x.shape[-1],), self.w_ln, self.b_ln)  # 3_LayerNorm
        return F.linear(x, self.w_dense2, self.b_dense2)     # 4_Dense -> score


print(f"Loading {MODEL_ID} via sentence-transformers ...")
ce = CrossEncoder(MODEL_ID, device="cpu")
ce.max_seq_length = MAX_LEN
backbone = ce.model
backbone.eval()
# Eager attention traces to a portable ONNX graph (no flash-attn / sdpa quirks).
try:
    backbone.set_attn_implementation("eager")
except Exception as exc:  # pragma: no cover - best effort across versions
    print(f"  (could not force eager attention: {exc})")

# Pull the head weights straight from the module folders.
d2 = load_file(hf_hub_download(MODEL_ID, "2_Dense/model.safetensors"))
ln = load_file(hf_hub_download(MODEL_ID, "3_LayerNorm/model.safetensors"))
d4 = load_file(hf_hub_download(MODEL_ID, "4_Dense/model.safetensors"))
model = EttinReranker(
    backbone,
    w_dense1=d2["linear.weight"],
    w_ln=ln["norm.weight"], b_ln=ln["norm.bias"],
    w_dense2=d4["linear.weight"], b_dense2=d4["linear.bias"],
).eval()

# Representative pairs: one relevant, one irrelevant -> drives trace + verification.
pairs = [
    ["wireless noise cancelling headphones",
     "Sony WH-1000XM5 over-ear Bluetooth headphones with active noise cancellation"],
    ["wireless noise cancelling headphones",
     "Stainless steel kitchen knife set, 5 pieces"],
    ["short query",
     " ".join(["long passage about audio quality and battery life"] * 80)],
]
enc = ce.tokenizer([p[0] for p in pairs], [p[1] for p in pairs],
                   padding=True, truncation=True, max_length=MAX_LEN,
                   return_tensors="pt")
inputs = (enc["input_ids"], enc["attention_mask"])

print(f"Exporting ONNX -> {ONNX_PATH} (opset {OPSET}) ...")
torch.onnx.export(
    model,
    inputs,
    str(ONNX_PATH),
    input_names=["input_ids", "attention_mask"],
    output_names=["score"],
    dynamic_axes={
        "input_ids": {0: "batch", 1: "sequence"},
        "attention_mask": {0: "batch", 1: "sequence"},
        "score": {0: "batch"},
    },
    opset_version=OPSET,
    do_constant_folding=True,
)

# Torch's exporter externalizes weights into a sidecar .onnx.data file; Vespa wants
# a single self-contained .onnx, so re-save with all initializers inlined.
import onnx
_m = onnx.load(str(ONNX_PATH))  # pulls in the external .onnx.data
onnx.save_model(_m, str(ONNX_PATH), save_as_external_data=False)
_sidecar = ONNX_PATH.with_suffix(".onnx.data")
if _sidecar.exists():
    _sidecar.unlink()

# Vespa's `embed tokenizer` needs the raw HF tokenizer.json (ModernBERT BPE vocab).
import shutil
shutil.copyfile(hf_hub_download(MODEL_ID, "tokenizer.json"), TOKENIZER_PATH)
print(f"Wrote tokenizer -> {TOKENIZER_PATH}")

# --- Verification: ONNX must match sentence-transformers' own scores ---
print("\nVerifying ONNX vs sentence-transformers CrossEncoder.predict() ...")
ref = np.asarray(ce.predict(pairs)).ravel()
sess = ort.InferenceSession(str(ONNX_PATH), providers=["CPUExecutionProvider"])
got = sess.run(["score"], {
    "input_ids": enc["input_ids"].numpy().astype(np.int64),
    "attention_mask": enc["attention_mask"].numpy().astype(np.int64),
})[0].ravel()

max_diff = float(np.abs(ref - got).max())
print(f"  reference (ST): {ref}")
print(f"  onnx          : {got}")
print(f"  max abs diff  : {max_diff:.2e}")
print("  output shape  : [batch, 1]  ->  read in Vespa as onnx(ettin){d0:0,d1:0}")
assert max_diff < 1e-3, "ONNX scores diverge from sentence-transformers -- do NOT deploy"
print("\nOK. Artifacts ready in vespa_app/models/:")
print(f"  - {ONNX_PATH.name}")
print(f"  - {TOKENIZER_PATH.name}")
