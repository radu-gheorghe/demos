# Training-question runs

This file is the procedure for one scored run of `vespa-training-questions.md`. An agent following it creates `tuning/training/roundN`, has `cursor-agent` answer each question, then has a second `cursor-agent` judge those answers against `vespa-training-qa.md`.

The score is how many questions match the reference, plus a fact hit count from the judge. Use it to compare changes to `AGENTS.md` and the indexed corpus. A run whose Vespa query fails is not a score.

Default model for both agents is `composer-2.5-fast`. Override with the environment variables below. Sub-agents inherit the coordinator's `--model`. The Task tool used in the smoke test took `description` and `prompt` only, so set the model on the coordinator command.

## Why the flags look like this

These were checked with Cursor CLI `2026.11.05-86047df` in `--print` mode:

- `--force` and `--yolo` auto-approve every tool. Do not pass them. WebSearch and WebFetch are allowed by name in the round's `cli.json` instead.
- `Shell(vespa query)` lets each query through without a prompt. The prefix matches every invocation, so the agent may run it more than once. A piped command, `vespa config set`, and any other shell command are rejected. How many queries to run is `AGENTS.md`'s decision.
- That file's `permissions.allow` and `permissions.deny` replace the arrays from `~/.cursor/cli-config.json` for this process. The user config allows `WebFetch(docs.vespa.ai)`. The round file must set both arrays, or the CLI rejects the file (`deny` is required when `permissions` is present).
- A `Read(/absolute/path/to/file)` deny blocks Read of that file and drops it out of a directory Grep. `--workspace` does not. An agent given only the round directory and `git-checkouts` could still Read `AGENTS.md` and Grep the questions file by absolute path.
- cli.json is loaded from the git root (`/Users/radu/gits/demos`) down to the process's working directory. Start the answer agent in `roundN`, and the judge agent in `roundN/judge`. `--workspace` does not choose this file.
- A child `.cursor/cli.json` with `"deny": []` replaces the parent's deny list. That is how the judge is allowed to open the reference.
- The Task result field `success.durationMs` is the sub-agent's wall time. It has no token counts. `result.usage` on the coordinator log is the coordinator only.

## 1. Check Vespa before spending a round

`vespa config get` must show `target = cloud` and `application = training1.searchsolutions.default`. Then:

```bash
vespa query 'select * from sources * where true' hits=1
```

A hit means the run can start. `no endpoints found` means this application is not deployed in the default dev zone; fix that before a scored run. Answers written from `git-checkouts` alone are not comparable to a run that used the index. If the error says to run `vespa auth login`, run `vespa auth login --batch`, give the printed URL to the user, and wait until that command exits. `cursor-agent status` must show a logged-in user.

Do not run `vespa config set` as part of this procedure. The answer agent is also told not to.

## 2. Create the round

From the repo root `/Users/radu/gits/demos/search-solutions_2026`:

```bash
REPO=/Users/radu/gits/demos/search-solutions_2026
cd "$REPO"
N=$(python3 - << 'PY'
from pathlib import Path
nums = []
for p in Path("tuning/training").glob("round*"):
    suffix = p.name.removeprefix("round")
    if p.is_dir() and suffix.isdigit():
        nums.append(int(suffix))
print(max(nums, default=0) + 1)
PY
)
ROUND="$REPO/tuning/training/round$N"
mkdir -p "$ROUND/judge/judgments"
cp "$REPO/tuning/training/vespa-training-questions.md" "$ROUND/vespa-training-questions.md"
ANSWER_MODEL="${ANSWER_MODEL:-composer-2.5-fast}"
JUDGE_MODEL="${JUDGE_MODEL:-composer-2.5-fast}"
```

Write `$ROUND/.cursor/cli.json`. Keep the absolute paths. The answer agent is started with this directory as its working directory.

```json
{
  "permissions": {
    "allow": [
      "Shell(vespa query)",
      "WebSearch",
      "WebFetch(docs.vespa.ai)"
    ],
    "deny": [
      "Read(/Users/radu/gits/demos/search-solutions_2026/tuning/training/vespa-training-qa.md)",
      "Read(/Users/radu/gits/demos/search-solutions_2026/tuning/training/facts)",
      "Read(/Users/radu/gits/demos/search-solutions_2026/tuning/validation/vespa-golden-qa.md)",
      "Read(/Users/radu/gits/demos/search-solutions_2026/tuning/validation/vespa-golden-questions.md)"
    ]
  }
}
```

Write `$ROUND/judge/.cursor/cli.json`. The empty deny list is what lets the judge open the reference. The answer agent must not be started from `roundN/judge`.

## How many at once

Launch 20 sub-agents, then wait for that wave. A question is finished only when its output file exists and is non-empty. For a judgment, the file must also contain a `VERDICT:` line. Retry a question whose sub-agent errors or whose file is missing or empty. Do not leave the gap, and do not write the answer or the judgment yourself.

A Cursor rate limit is HTTP 429 or the text "rate limit", "too many requests", or "resource exhausted". When one sub-agent in a wave hits that, set the wave size to 10 for the rest of that phase and retry every question from the wave that has no finished file. Stay at 10. A later rate limit does not drop the width again.

After the last wave, retry any question that still has no finished file, at the current width. Three failures of the same question for a reason other than a rate limit stop that question. Record its number. Do not invent its file.

```json
{
  "permissions": {
    "allow": ["Shell(vespa query)"],
    "deny": []
  }
}
```

## 3. Answer

Save the prompt below as `$ROUND/answer-prompt.md`, with `ROUND` replaced by the absolute round path. Then start the coordinator from that round directory:

```bash
cd "$ROUND"
cursor-agent --print --trust \
  --model "$ANSWER_MODEL" \
  --output-format stream-json \
  --workspace "$REPO" \
  "$(cat answer-prompt.md)" \
  > answer-stream.jsonl
```

Prompt:

```text
You coordinate a Vespa answer run. The repo is /Users/radu/gits/demos/search-solutions_2026. This run's directory is ROUND.

Questions are in ROUND/vespa-training-questions.md. For each question, spawn one sub-agent. Pass it the question text and the absolute output path ROUND/<n>.md, where <n> is the question number. Launch 20 sub-agents at a time and wait for that wave before the next. Do not answer a question yourself. Do not open the reference answers.

A question is done only when ROUND/<n>.md exists and is non-empty. If a sub-agent errors, or the file is missing or empty, retry that question. Do not leave a gap.

If any sub-agent reports a rate limit (HTTP 429, "rate limit", "too many requests", or "resource exhausted"), set the wave size to 10 for the rest of this run and retry every question from that wave that has no finished file. Stay at 10. A later rate limit does not drop the width again. After the last wave, retry any question that still has no finished file, at the current wave size. If the same question fails three times for a reason other than a rate limit, stop retrying it and list its number in ROUND/metrics.md. Do not invent an answer.

Tell every sub-agent:

- Read /Users/radu/gits/demos/search-solutions_2026/AGENTS.md and follow it. That file decides how to query, how many queries to run, and whether to use the web.
- Shell may run `vespa query` as many times as that file says. No pipes, no semicolons, no &&, and no vespa config set. If a query fails, say so in the answer and continue from git-checkouts. Do not switch zone or application.
- Do not Read, Grep, or otherwise open tuning/training/vespa-training-qa.md, tuning/training/facts, anything under tuning/validation, or any round directory other than this one. Do not search the repo root for the question text. When a hit names a file, open git-checkouts/{repo}/{path}.
- Write only ROUND/<n>.md. Start with the question as a heading, then the answer, then a Sources list of repo-relative paths you actually opened.

After each sub-agent finishes, copy success.durationMs from its Task result into ROUND/metrics.md. The Task result does not include token counts. Write "tokens: unknown" rather than guessing.
```

When it exits:

```bash
python3 "$REPO/tuning/training/collect_metrics.py" "$ROUND/answer-stream.jsonl" \
  > "$ROUND/metrics-from-log.md"
```

`metrics-from-log.md` is the duration record. The coordinator's token line in that output is not the sum of the sub-agents. Per-question token counts are not in the CLI result.

Check that every question has a non-empty `<n>.md` and that `metrics.md` does not contain a made-up token count. A missing or empty file is a failed sub-agent, not a wrong answer. Rerun those questions before judging. If `answer-stream.jsonl` shows a rate limit, rerun the missing ones 10 at a time. Do not start the judge while any answer file is missing, unless that question failed three times for a reason other than a rate limit and its number is listed in `metrics.md`.

## 4. Judge

Save the prompt below as `$ROUND/judge/judge-prompt.md`. Start this agent in `roundN/judge`, so its cli.json is the one with the empty deny list:

```bash
cd "$ROUND/judge"
cursor-agent --print --trust \
  --model "$JUDGE_MODEL" \
  --output-format stream-json \
  --workspace "$REPO" \
  "$(cat judge-prompt.md)" \
  > judge-stream.jsonl
```

Prompt:

```text
You coordinate a review of Vespa answers. The repo is /Users/radu/gits/demos/search-solutions_2026. This run's directory is ROUND. Judge files go in ROUND/judge/judgments.

Questions: ROUND/vespa-training-questions.md
Candidate answers: ROUND/<n>.md
Reference: /Users/radu/gits/demos/search-solutions_2026/tuning/training/vespa-training-qa.md

Spawn one sub-agent per question, 20 at a time, and wait for that wave before the next. Pass it the question number, the candidate path, and the reference path. Do not judge an answer yourself.

A question is judged only when ROUND/judge/judgments/<n>.md exists and contains a VERDICT line. If a sub-agent errors, or the file is missing or has no verdict, retry that question. Do not leave a gap and do not write the judgment yourself.

If any sub-agent reports a rate limit (HTTP 429, "rate limit", "too many requests", or "resource exhausted"), set the wave size to 10 for the rest of this run and retry every question from that wave that has no finished judgment. Stay at 10. A later rate limit does not drop the width again. After the last wave, retry any question that still has no finished judgment, at the current wave size. If the same question fails three times for a reason other than a rate limit, stop retrying it and list its number at the top of ROUND/judge/score.md. Leave it out of the counts. Do not invent a verdict.

Tell every sub-agent:

You are an impartial judge. Compare the candidate answer with the ground truth for this question. The ground truth is the section "### <n>." in the reference. Use the answer body. Do not require the candidate to repeat the "Review:" paragraph. A missing source path is not an error by itself.

1. Does the candidate convey the same core factual meaning as the ground truth?
2. Penalize factual contradictions, incorrect facts, and omissions of constraints the ground truth states.
3. Do not penalize differences in wording, tone, or formatting.
4. Extra true context that does not contradict the ground truth is acceptable.

Write ROUND/judge/judgments/<n>.md with:

- A step-by-step comparison of the facts
- FACTS: <hit>/<total>, counting constraints in the ground-truth body
- one verdict line, exactly one of: VERDICT: CORRECT, VERDICT: INCORRECT, VERDICT: PARTIALLY_CORRECT

Do not use WebSearch or WebFetch. Do not modify the candidate or the reference.

After the retries above, write ROUND/judge/score.md with one row per finished question: number, verdict, FACTS, and success.durationMs from that Task result. Tokens are unknown. Then count CORRECT, PARTIALLY_CORRECT, and INCORRECT, and sum the FACTS hits and totals. Questions still unfinished after three non-rate-limit failures are listed at the top and left out of those counts.
```

Then:

```bash
python3 "$REPO/tuning/training/collect_metrics.py" "$ROUND/judge/judge-stream.jsonl" \
  > "$ROUND/judge/metrics-from-log.md"
```

Check that every question has a judgment file with a `VERDICT:` line before treating `score.md` as the result. Rerun any question whose judgment is missing or has no verdict. If `judge-stream.jsonl` shows a rate limit, those retries run 10 at a time. A question listed at the top of `score.md` after three non-rate-limit failures stays out of the counts.

The score for the round is the verdict counts and the FACTS fraction in `score.md`. `PARTIALLY_CORRECT` is not a full hit. Keep `answer-stream.jsonl` and `judge-stream.jsonl` so a later change to `AGENTS.md` can be compared with the same durations.

## What not to treat as a result

A smoke of this harness under `tuning/training/_smoke` is not a round. The first answer sub-agent, before the Read deny existed, Grepped the repo and received lines from `vespa-training-qa.md`. Its verdict cannot be used. Do not copy that directory into `round1`.
