#%%markdown
#H1 Agenda
# Agenda

1. Introduction
2. Example use-case
3. Using LLMs for everything
4. Using agents
#%%markdown
#H1 Theme
![Pipeline](./svg/Evolution-of-Search.svg)
#%%markdown
#H1 Example use-case
## Extract people and their bios from SEC filings.

## Extract qualifications from these bios.
Which qualifications?
# ¯\ (°_o)/¯ 

## Let's explore!
#%%python
#H1 Can we solve this with an LLM?
print(
    "\n".join(
        "".join(
            " #"[
                (x < 7 and not x * (x - 6) * (x - y))
                or (x > 8 and ((x - 9) * (x - 15) == 0) != (y * (y - 6) == 0))
            ]
            for x in range(16)
        )
        for y in range(7)
    )
)
#%%markdown
#H1 Can we solve this with an agent?
# Sounds like a great fit!
Deterministic (consistent), iterative -> code -> agent
#%%markdown
#H2 The journey
**Given** existing parser that generates contextual fragments:

🗺️ Agent 1: **make a plan**. You have some raw data, Vespa, how would you do it?

🔎 Agent 2: **criticize**

🤝 Agent 1: **integrate feedback**, disagree, discuss with human

🔁 **Repeat critique + integration** until happy

🚀 **Go at it**. Spawn sub-agents for different tasks. Make sure every task has a builder and a reviewer
#%%markdown
#H2 The result
💰  3 months worth of tokens across 4 providers

🗓️ one week of machine + human unblocker/handholder

✅️ It kinda worked, we got biographies!

![pipeline snippet](agents_pipeline_snippet.png)

BUT:
- a ton of bespoke code
- a ton of regexes
#%%markdown
#H2 Better tools help?
Asked to replan the remaining work to use tools like:
- term vector similarity (already built!)
- significant terms (also already built)
- grouping/facets on Vespa
- build models for e.g. entity extraction

=> within a day and 2 weeks of token budgets, we had education backgrounds extracted
#%%markdown
#H2 Some takeaways
🥊 Helps to use adversarial agents to criticize planning and implementation.

🔨 Some models are better builders, some are better critics. Depends on version, but typically Claude builds better and Codex reviews better.

🎯 If all is equal, use the smarter model to critique.

🔁 Implementation bumps should loop back into plan.

⚖️ Challenging to balance multiple objectives: simplicity, performance, correctness. Can have specialized reviewers for each.

❓ How to not vibe-code without micro-managing agents? Visualizations (pipeline, data)?
#%%markdown
![Pipeline](./svg/Typical-Index-Construction.svg)
#%%markdown
![Pipeline](./svg/LLM_Struggles.svg)
#%%markdown
![Enhanced Pipeline](./svg/Enhanced-Index-Construction.svg) 