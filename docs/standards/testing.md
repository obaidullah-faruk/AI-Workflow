# Testing standards

Fill in the `<...>` placeholders for your project, then delete this line.

## Tools

- Unit/integration: `<Vitest / Jest / pytest / JUnit>`. End-to-end: `<Playwright / Cypress>`.

## Commands

- All tests: `<npm test>`. One file: `<npm test -- path/to/file>`. End-to-end: `<npx playwright test>`.

## What to test

- **Unit tests** for business logic and pure functions. Fast, no network or database.
- **Integration tests** for API endpoints and repositories against a real test database.
- **End-to-end tests** only for the few critical user flows.
- Every bug fix starts with a test that fails for that bug.
- List endpoints and repository methods that load related data get a query-count test, so an N+1 fails the build.
- Background jobs get a test that runs the same job twice and checks the result is the same.
- Code that calls an LLM uses a fake client in tests and gets eval cases; see the Evals section of [ai.md](ai.md).

## Rules

- Test behavior, not implementation details. Do not assert on private functions.
- Name tests as sentences: `returns 404 when the user does not exist`.
- Structure each test as arrange, act, assert. One reason to fail per test.
- Tests must not depend on each other or on run order. No shared mutable state.
- Mock only at system boundaries (network, clock, third-party APIs), never your own modules.
- Never delete or weaken a failing test to make a build pass. Fix the code or ask.
- No flaky tests: a test that fails intermittently gets fixed or removed the same day.
