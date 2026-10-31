# Decision records

One short file per decision that shapes the codebase and is expensive to reverse: moving a module into its own service, choosing a database, queue, or LLM provider, adopting a pattern across the codebase, or deliberately breaking a standard. Small choices do not need one.

Agents list the file names here before planning and open only the relevant ones, so make the title state the decision.

## Format

Name each file `NNNN-decision-title.md`, for example `0003-move-notifications-to-own-service.md`. Do not rewrite an accepted decision. Write a new record that supersedes it, and change the old one's status.

```markdown
# NNNN. Decision as a title ("Use pgvector for embeddings")

Status: accepted | superseded by NNNN
Date: YYYY-MM-DD

## Context
The problem and the constraints, in a few sentences.

## Decision
What we chose.

## Consequences
What gets easier, what gets harder, and what would make us revisit it.
```
