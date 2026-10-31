# <Feature name>

Copy this file to `docs/specs/<feature-name>.md`, fill it in, and run `/feature docs/specs/<feature-name>.md`. Delete sections that do not apply. Short is fine; the "Done when" list matters most, because the agents treat it as the definition of done.

## Goal

What changes for the user, and why. One or two sentences.

## Where

The modules, folders, or pages this touches. Name anything that must not change.

## Done when

- [ ] A check anyone can run: an action and the result that proves it works.
- [ ] Failure cases: bad input, no permission, nothing to show.

## Limits

- Patterns to use or avoid ("use the existing `orders` interface", "no new dependencies").
- Work that must not slow down the request.
- Security or privacy rules.

## Scale

Expected volume (rows per customer, requests per minute, file sizes) when it affects the design.

## AI

Only if the feature calls an LLM.

- Example inputs and what a good answer must contain. These become the eval cases.
- Budget per request: tokens, cost, or latency.

## Out of scope

What this feature deliberately does not do.

## Open questions

Anything not decided yet. The architect raises these before planning.
