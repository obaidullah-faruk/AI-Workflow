# General standards

Rules for every task, in every language. Keep this file short; agents read it each time.

## Principles

- Make the smallest change that solves the problem. Do not refactor unrelated code.
- Match the style of the surrounding code before applying any rule here.
- Keep code loosely coupled: depend on interfaces, not concrete implementations; inject dependencies instead of creating them inside a class; keep business logic free of framework, database, and third-party SDK types.
- Never hardcode secrets. Read them from environment variables.
- Validate input at system boundaries (user input, external APIs), not between internal functions.

## Code quality

**Naming**

- Name things for what they mean, not how they are stored or used: `overdueInvoices`, not `list2` or `data`.
- Functions are verbs that say what they do (`calculateShippingCost`, `findActiveUsers`). Booleans read as questions (`isExpired`, `hasPermission`). Classes and modules are nouns.
- No abbreviations except universal ones (`id`, `url`, `http`). No single-letter names outside tiny loops or lambdas.
- A function does one thing and its name says what. If you need "and" in the name, split it.
- Keep functions short enough to read without scrolling. Replace magic numbers and repeated strings with named constants.

**Comments**

- Comment where a reader would otherwise have to guess: not more, not less. Decide this while writing the code; the user will not ask for it.
- Do comment:
  - why a choice was made when a simpler-looking alternative exists;
  - a business rule or constraint the code cannot show (a rounding rule, a legal requirement, a 30-day window);
  - a workaround, with the reason and when it can be removed;
  - a non-obvious assumption, side effect, or ordering requirement (units, time zone, "caller must hold the lock");
  - a short summary above a complex algorithm or query;
  - a `DB-SPECIFIC:` marker, and public API documentation on exported functions if the project already uses it.
- Do not comment what the code does, restate a name, add section banners, record change history, leave commented-out code, or leave a TODO without an issue number.
- Test: a developer who knows the language but not this project should understand every non-obvious decision without asking. If a comment is only needed to explain what a line does, rename or restructure the code instead.
- Keep each comment to one or two sentences, and update it in the same change as the code.

**Design patterns**

- Use a pattern to solve a problem the code actually has, and name it in the code or in the pull request. Do not add one speculatively.
- Match the problem to the pattern:
  - Behavior that varies by type or rule (pricing, payment providers, export formats): **strategy**.
  - Creating one of several implementations from input or config: **factory**.
  - Data access hidden behind an interface: **repository**.
  - Wrapping a third-party API or SDK so the rest of the code does not depend on it: **adapter**.
  - Other code reacting to something that happened: **observer** or domain events.
  - Same steps with a few different parts: **template method**.
  - Adding behavior around a call (logging, caching, retries) without changing it: **decorator**.
  - Building an object with many optional parts: **builder**.
- A long `if/else` or `switch` on a type that keeps growing is a sign to use strategy or polymorphism.
- Prefer composition and small interfaces over deep inheritance.
- If a plain function solves it, use the plain function.

## Git

- One logical change per commit. Message format: `type: short summary` (`feat`, `fix`, `refactor`, `docs`, `test`, `chore`).
- Branch names: `feat/<name>`, `fix/<name>`.
- Never commit directly to `main`. Never force-push shared branches.

## Definition of done

A task is done only when all of these are true:

1. The change meets the acceptance criteria.
2. New behavior has tests, and the full test suite passes.
3. Lint and type checks pass.
4. No debug code, commented-out code, or unrelated edits remain.
5. Docs are updated if behavior or setup changed.

## Where the other standards are

- [frontend.md](frontend.md), [backend.md](backend.md), [database.md](database.md), [ai.md](ai.md), [infrastructure.md](infrastructure.md), [testing.md](testing.md)
