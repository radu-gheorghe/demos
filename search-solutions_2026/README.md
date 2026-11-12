# Agentic Search with Vespa

## Objective

Use Vespa as a backend for a search agent. Our corpus will be Vespa data (code, documentation, sample applications).

We'll index the corpus and instruct agents to search it, to help us learn about Vespa.

## High Level Steps

1. Set up Vespa on Vespa Cloud. The application package from [vespa-corpus](vespa-corpus) uses a GPU for faster embedding.
2. Clone the Vespa code, documentation and sample apps from GitHub.
3. Index the corpus.
4. Agents will use [AGENTS.md](AGENTS.md) to understand how to search the corpus when answering questions about Vespa.

## How?

1. Download the [Search Navigator](https://sites.google.com/search-navigator.org/navigator-for-solr/download).
2. Open [recipe.nr](recipe.nr) with it.
3. Follow the instructions in the recipe.