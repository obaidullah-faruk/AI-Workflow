# AGENTS.md

## Engineering standards

Read `docs/standards/general.md` before any task, then the file for the layer you are touching. Follow them over your own defaults.

- `docs/standards/frontend.md`: UI code.
- `docs/standards/backend.md`: APIs, module boundaries, background jobs.
- `docs/standards/database.md`: queries, N+1, indexing, migrations, database portability.
- `docs/standards/infrastructure.md`: Docker, Terraform, CI/CD.
- `docs/standards/testing.md`: writing and running tests.

## Code quality

- Use meaningful names: functions are verbs, booleans read as questions, no abbreviations or names like `data` and `temp`.
- Comment where a reader would otherwise have to guess: the reason for a non-obvious choice, a business rule, a workaround, an assumption. Never narrate what the code does. Remove commented-out code. Decide this yourself while writing; do not wait to be asked.
- Use a design pattern (strategy, factory, repository, adapter, observer) when it solves a real problem, and name it. Otherwise use a plain function.

Details are in `docs/standards/general.md`.

## Specialized agents

Subagents live in `.claude/agents/`. Delegate to them instead of doing everything in the main session.

- `architect`: plans non-trivial work before any code is written.
- `frontend-engineer`, `backend-engineer`, `devops-engineer`: implement in their own area only.
- `test-engineer`: writes tests, and reproduces bugs with a failing test.
- `code-reviewer`: reviews every change before it is committed.
- `pr-creator`: opens a GitHub pull request for the current branch (uses `gh`).
- `pr-reviewer`: reviews a GitHub pull request and its CI checks (uses `gh`).

## Routing a task

When the user gives a task without a slash command, choose the path by size:

- **Question or explanation**: answer directly. Do not use agents.
- **Small edit** (a typo, a rename, a one-file tweak with no new behavior): do it directly, then run the project's lint and tests.
- **Bug fix**: delegate to `test-engineer` for a failing test first, then to the matching engineer, then `code-reviewer`.
- **Non-trivial change** (new behavior, several files, a schema change, or a new module or service): delegate to `architect` first and show the plan before any code is written. Then delegate each task to the matching engineer, then `test-engineer`, then `code-reviewer`.

Fix any "Must fix" finding before reporting the work as done. Open or review a pull request only when the user asks for it.

## Workflows

Run these as slash commands. They are in `.claude/skills/`.

- `/feature <description or spec path>`: plan, implement, test, review.
- `/bugfix <bug description>`: reproduce with a test, fix, verify, review.
- `/review`: review uncommitted changes before committing.
- `/pr [issue number]`: review the branch, then open a draft pull request.
- `/pr-review <number or URL> [post]`: review a pull request; posts to GitHub only if `post` is given.

Never commit or push unless the user asks. Never merge a pull request.

## Explaining in chat

Use these when they fit the question, not on every answer.

- Answer first in one or two sentences, then the why, then details.
- Write full sentences. Use arrows only in diagrams.
- Define a new term in one short clause the first time it appears.
- For how something works, say which component does what, in order.
- When the user should check something, give the command and say what correct output looks like.
