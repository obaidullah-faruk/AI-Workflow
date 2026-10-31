# AGENTS.md

## Engineering standards

Before you write or review code yourself, read `docs/standards/general.md` (naming, comments, design patterns, definition of done), then the file for the layer you are touching. Follow them over your own defaults. Skip this when you only answer a question or hand the work to a subagent, because each subagent reads its own standards.

- `docs/standards/frontend.md`: UI code.
- `docs/standards/backend.md`: APIs, module boundaries, background jobs.
- `docs/standards/database.md`: queries, N+1, indexing, migrations, database portability. Read it only when queries, schema, or migrations change.
- `docs/standards/ai.md`: LLM and embedding calls, prompts, RAG, agents and tools, evals.
- `docs/standards/infrastructure.md`: Docker, Terraform, CI/CD.
- `docs/standards/testing.md`: writing and running tests.

If a standards file still has `<...>` placeholders, take the real values from the repo (`package.json`, `Makefile`, `pyproject.toml`, CI config). If a command does not exist there either, say so instead of guessing.

## Library docs

Use Context7 only when you are unsure of a library API, its configuration, or version-specific behavior. Do not look up APIs you already know.

## Specialized agents

Subagents live in `.claude/agents/`. Delegate to them instead of doing everything in the main session. If your tool cannot run subagents, follow the same steps yourself in the same order, reading the agent file for each step.

- `architect`: plans non-trivial work before any code is written.
- `frontend-engineer`, `backend-engineer`, `devops-engineer`: implement in their own area only.
- `ai-engineer`: implements anything that calls an LLM or embedding API (prompts, RAG, chatbots, agents, evals).
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

- `/setup`: one-time setup that fills in the standards from the repo.
- `/feature <description or spec path>`: plan, implement, test, review. Specs follow `docs/specs/TEMPLATE.md`.
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
