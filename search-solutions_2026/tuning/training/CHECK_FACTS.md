# Check answers against the frozen facts

Scores one round's answers against `tuning/training/facts/<n>.md`. The checker marks those claims. It does not add claims, drop claims, or open the reference. The rate is the sum of hits over the sum of the frozen counts.

The model is `composer-2.5-fast`, the same as `RUN.md`. Sub-agents inherit the coordinator's `--model`. Run this only after `FREEZE_FACTS.md` has a file for every question you will score.

## 1. Create the checker directory

From `/Users/radu/gits/demos/search-solutions_2026`, with `ROUND` the absolute path of the round (`.../tuning/training/round3`):

```bash
REPO=/Users/radu/gits/demos/search-solutions_2026
mkdir -p "$REPO/tuning/training/check/.cursor" "$ROUND/fact-check"
```

Write `$REPO/tuning/training/check/.cursor/cli.json`. The empty parent deny must not be the one in force. This deny list is what keeps the checker off the reference.

```json
{
  "permissions": {
    "allow": [],
    "deny": [
      "Read(/Users/radu/gits/demos/search-solutions_2026/tuning/training/vespa-training-qa.md)",
      "Read(/Users/radu/gits/demos/search-solutions_2026/tuning/validation/vespa-golden-qa.md)",
      "Read(/Users/radu/gits/demos/search-solutions_2026/tuning/validation/vespa-golden-questions.md)"
    ]
  }
}
```

Start the agent in `tuning/training/check`, not in the round and not in `freeze`.

## 2. Check

Save the prompt below as `$REPO/tuning/training/check/check-prompt.md`, with `ROUND` replaced by the absolute round path. Then:

```bash
cd "$REPO/tuning/training/check"
cursor-agent --print --trust \
  --model composer-2.5-fast \
  --output-format stream-json \
  --workspace "$REPO" \
  "$(cat check-prompt.md)" \
  > "$ROUND/fact-check/check-stream.jsonl"
```

Prompt:

```text
You coordinate a fact check. The repo is /Users/radu/gits/demos/search-solutions_2026. The round is ROUND. Frozen claims are /Users/radu/gits/demos/search-solutions_2026/tuning/training/facts/<n>.md. Candidate answers are ROUND/<n>.md. Write ROUND/fact-check/<n>.md.

Spawn one sub-agent per question, 20 at a time, and wait for that wave before the next. Pass the question number, the frozen-claim path, the candidate path, and the output path. Do not mark a claim yourself.

A file is done only when it exists and contains one line "FACTS: <hit>/<total>". If a sub-agent errors, or the file is missing or has no FACTS line, retry that question. Do not leave a gap and do not write the check yourself.

If any sub-agent reports a rate limit (HTTP 429, "rate limit", "too many requests", or "resource exhausted"), set the wave size to 10 for the rest of this run and retry every question from that wave that has no finished file. Stay at 10. A later rate limit does not drop the width again. After the last wave, retry any question that still has no finished file, at the current wave size. If the same question fails three times for a reason other than a rate limit, stop retrying it and list its number at the top of ROUND/fact-check/score.md. Leave it out of the sums. Do not invent a FACTS line.

Tell every sub-agent:

Read the frozen claim file and the candidate answer. Do not open vespa-training-qa.md, anything under tuning/validation, or any other round. Do not use WebSearch or WebFetch.

The numbered lines in the frozen file are the only claims. Do not add one. Do not drop one. For each number, mark stated or not stated. Stated means the candidate says that constraint. Wording may differ. A contradiction is not stated. Extra true sentences do not become claims.

Write only ROUND/fact-check/<n>.md. A table with the claim number and stated or not stated, then one line FACTS: <hit>/<total>. The total is the number of numbered claims in the frozen file. If your total is different, you added or dropped a claim. Fix the table before writing the line.

After the retries, write ROUND/fact-check/score.md. One row per finished question: number, FACTS, and success.durationMs from that Task result. Tokens are unknown. Then sum the hits and the totals. The rate is that fraction. Questions unfinished after three non-rate-limit failures are listed at the top and left out of the sum.
```

The comparison between two rounds is the two rates from this procedure, not the `FACTS:` lines written by `RUN.md`'s judge.
