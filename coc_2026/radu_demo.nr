#%%markdown
#H1 TODO: Agenda
# Agenda

1. Introduction
2. Example use-case
3. Using LLMs for everything
4. Using agents
#%%markdown
#H1 Introduction/angle
# Tools shape wishes

![Google example](search-evolution-flowchart.svg)

Persona:
- index at the back of the book
- checking the summary on the back of a book
- talk to a librarian
- hire a librarian. Or a team of librarians. Or a toolsmith to give librarians better tools. Or?
#%%markdown
#H2 Which tools should we use?
![welcome to the exploration journey](https://i.kym-cdn.com/entries/icons/facebook/000/000/341/i-dunno-lol_1_.jpg)
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
🔁 Implementation bumps should loop back into plan.

🥊 Helps to use adversarial agents to criticize planning and implementation.

🔨 Some models are better builders, some are better critics. Depends on version, but typically Claude builds better and Codex reviews better.

🎯 If all is equal, use the smarter model to critique.

⚖️ Challenging to balance multiple objectives: simplicity, performance, correctness. Can have specialized reviewers for each.

🧑 (opinionated) Complex stuff needs a human to be on top of things and make the calls. Often the human (me) is the bottleneck, because agents can implement faster than I can understand. Visualizations help with understanding.