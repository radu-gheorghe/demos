# Freeze the training facts

One run. It reads `vespa-training-qa.md` and writes a numbered claim list to `tuning/training/facts/<n>.md`. Later rounds are scored against that list by `CHECK_FACTS.md`. Do not freeze again to compare two rounds. A second freeze is a different exam.

The model is `composer-2.5-fast`, the same as `RUN.md`. Sub-agents inherit the coordinator's `--model`.

## 1. Create the run directory

From `/Users/radu/gits/demos/search-solutions_2026`:

```bash
REPO=/Users/radu/gits/demos/search-solutions_2026
mkdir -p "$REPO/tuning/training/facts" "$REPO/tuning/training/freeze/.cursor"
```

Write `$REPO/tuning/training/freeze/.cursor/cli.json`. The freeze agent must read the reference, so this deny list is empty. Do not start it inside a round directory.

```json
{
  "permissions": {
    "allow": [],
    "deny": []
  }
}
```

## 2. Freeze

Save the prompt below as `$REPO/tuning/training/freeze/freeze-prompt.md`, then:

```bash
cd "$REPO/tuning/training/freeze"
cursor-agent --print --trust \
  --model composer-2.5-fast \
  --output-format stream-json \
  --workspace "$REPO" \
  "$(cat freeze-prompt.md)" \
  > freeze-stream.jsonl
```

Prompt:

```text
You coordinate a freeze of the training facts. The repo is /Users/radu/gits/demos/search-solutions_2026. Write one file per question to /Users/radu/gits/demos/search-solutions_2026/tuning/training/facts/<n>.md.

The reference is /Users/radu/gits/demos/search-solutions_2026/tuning/training/vespa-training-qa.md. Question numbers are 1 to 100. The section for question <n> starts at the heading "### <n>." and ends at the next "### " heading.

Spawn one sub-agent per question, 20 at a time, and wait for that wave before the next. Pass the question number and the output path. Do not write a fact file yourself.

A file is done only when it exists, is non-empty, and contains at least one line that starts with a number and a period. If a sub-agent errors, or the file is missing or empty, retry that question. Do not leave a gap.

If any sub-agent reports a rate limit (HTTP 429, "rate limit", "too many requests", or "resource exhausted"), set the wave size to 10 for the rest of this run and retry every question from that wave that has no finished file. Stay at 10. A later rate limit does not drop the width again. After the last wave, retry any question that still has no finished file, at the current wave size. If the same question fails three times for a reason other than a rate limit, stop retrying it and list its number in /Users/radu/gits/demos/search-solutions_2026/tuning/training/freeze/gaps.md. Do not invent its claims.

Tell every sub-agent:

Read only the body of "### <n>." in the reference. Stop at the next "### " heading. Ignore the slots table. Do not turn a Sources line or a Review paragraph into claims.

Split that body into claims a later reader can mark stated or not stated. One claim is one constraint that can be missed on its own. Keep a default, a name, a bound, and a contrast with another mechanism as separate claims. Do not paste a whole paragraph as one claim. Do not split one constraint into synonyms.

Write only /Users/radu/gits/demos/search-solutions_2026/tuning/training/facts/<n>.md. Start with a heading "# <n>. <question text>". Then a numbered list, "1. ...", "2. ...", one claim per line. No verdict and no match column.

Do not use WebSearch or WebFetch. Do not open tuning/validation, any round directory, or an existing facts file for a different question.

When every question has a finished file, or the gaps are listed, stop. Do not score any answer.
```

A finished `facts/<n>.md` is the claim list for that question. Count the numbered lines. That count is the denominator `CHECK_FACTS.md` must keep.
