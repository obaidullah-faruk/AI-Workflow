# AI Workflow

My instructions and setup guides for AI coding agents (Claude Code, Cursor, VS Code). Copy the pieces you need into a new project.

## Contents

| Path | What it is |
|------|------------|
| [CLAUDE.md](CLAUDE.md) | One line, `@AGENTS.md`, so Claude Code loads the instructions file. Copy it with `AGENTS.md`. |
| [AGENTS.md](AGENTS.md) | The instructions file. Copy it into the root of a new project. |
| [docs/standards/](docs/standards/) | Engineering standards the agents follow: general, frontend, backend, database, infrastructure, testing. |
| [.claude/agents/](.claude/agents/) | Specialized subagents (architect, frontend, backend, devops, test, code reviewer, PR creator, PR reviewer). |
| [.claude/skills/](.claude/skills/) | Reusable workflows run as slash commands: `/feature`, `/bugfix`, `/review`, `/pr`, `/pr-review`. |
| [docs/context7.md](docs/context7.md) | How to install and use Context7, which gives agents up-to-date library docs. |

## How the pieces fit

`AGENTS.md` tells the agent to read the standards. The subagents each read the standards for their own area. The workflows run the subagents in a fixed order, so every feature or bug fix gets the same plan, test, and review steps.

## Using this in a new project

1. Copy `CLAUDE.md`, `AGENTS.md`, `docs/standards/`, and `.claude/` into the project root.
2. Fill in the `<...>` placeholders in each `docs/standards/` file, and delete files for layers you do not have.
3. Claude Code reads `CLAUDE.md`, not `AGENTS.md`. The included `CLAUDE.md` contains the single line `@AGENTS.md`, which loads `AGENTS.md`. If your project already has a `CLAUDE.md`, add that line to it instead.
4. Check it worked: run `claude`, then `/agents`. You should see the eight agents listed as project agents. Typing `/` should show `feature`, `bugfix`, `review`, `pr`, and `pr-review`.
5. For the PR agents, install the [GitHub CLI](https://cli.github.com) and run `gh auth login`. Check with `gh auth status`; it should say you are logged in to github.com.

## What the standards enforce

- **Loose coupling.** Code is split into modules by business capability. Modules talk only through small interfaces and events, and never touch each other's tables. Business logic depends on interfaces, not on the framework, the ORM, or a vendor SDK.
- **Monolith or microservices.** Start as a modular monolith. Because of the module rules, a module can be moved into its own service later without rewriting its callers. The architect agent recommends a separate service only for a concrete need.
- **Easy database migration.** All database access sits behind repositories. Vendor-specific SQL is isolated and marked `DB-SPECIFIC:`. Schema changes use expand, migrate, contract.
- **Fast queries.** No N+1 queries, no unbounded lists, an index for every new query, and `EXPLAIN` before merging. Tests assert query counts.
- **Background workers.** Slow, unreliable, or retryable work goes to idempotent jobs behind a queue interface.

- **Readable code.** Meaningful names, no comments that restate the code, and a named design pattern (strategy, factory, repository, adapter, observer) only where it solves a real problem.

Reviewers (`code-reviewer`, `pr-reviewer`) treat coupling, N+1, and missing-index violations as "Must fix", and naming, comment, and pattern issues as "Should fix".

## How to use the workflows

### Which one do I run?

| I want to... | Run | What happens |
|--------------|-----|--------------|
| Build something new | `/feature <what to build>` | Architect plans, you approve, engineers build, tests are added, reviewer checks. |
| Fix a bug | `/bugfix <the bug>` | A failing test is written first, then the fix, then review. |
| Check my work before committing | `/review` | Reviewer and lint/tests run on your uncommitted changes. Nothing is edited. |
| Open a pull request | `/pr [issue number]` | Reviewer checks the branch, then a draft PR is opened. |
| Review someone's pull request | `/pr-review <number or URL>` | Reviewer reads the PR and its CI results and reports. Add `post` to post it to GitHub. |

### What makes a prompt work well

A good prompt answers four questions. The more of them you answer, the less the agent has to guess.

1. **What** do you want, and why? One sentence of purpose.
2. **Where** does it go? Name the module, folder, or file.
3. **How will we know it's done?** List acceptance criteria you can check.
4. **What are the limits?** Name what to leave alone, which pattern to use, and what to avoid.

Also:

- Ask for one thing per run. Split big goals into several `/feature` runs.
- Name design patterns instead of explaining them: "use the strategy pattern", "put this behind a repository interface".
- Say what correct looks like, such as an example input and the output you expect.
- Mention scale when it matters: "about 50,000 orders per customer" changes the indexing and pagination choices.

### Weak versus strong prompts

Weak:

```text
/feature add comments
```

Strong:

```text
/feature Let users comment on a task so teammates can discuss it.

Where: a new `comments` module in the backend, and a comment list on the task page in the frontend.

Done when:
- A signed-in user can add a comment to a task they can see (max 2000 characters).
- Comments show newest first, 20 per page, with the author's name.
- Only the author or a task admin can delete a comment.
- Task owners get an email when someone else comments.

Limits:
- Do not change the `tasks` module. The comments module reaches it only through its public interface.
- Sending the email must not slow down the request.
- A task can have thousands of comments.
```

Why this works: the module name and the "do not change `tasks`" line make the architect keep the modules separate. "Must not slow down the request" and "thousands of comments" lead it to a background job, pagination, and an index on `(task_id, created_at)`.

### Sample prompts

**Build a feature with `/feature`**

```text
/feature Add a CSV export of a customer's orders.

Done when:
- The user clicks "Export" and gets an email with a download link when the file is ready.
- Exports with 100,000+ rows must work without timing out.
- The link expires after 24 hours.

Limits: do not load all orders into memory; use the existing `orders` module interface.
```

You can also point `/feature` at a written spec: `/feature docs/specs/export-orders.md`. Put the acceptance criteria in that file, and the agents will treat them as the definition of done.

**Ask for a plan only**

```text
Use the architect agent to plan how to add multi-tenant support. Do not write any code yet.
I want to know: which modules change, how the database migration stays safe for the running app,
and whether this is still fine as one monolith. Stop after the plan.
```

**Decide monolith or microservice**

```text
Use the architect agent. Our `notifications` module sends 2 million emails a day and is slowing down
the main app. Should it become its own service? Compare keeping it in the monolith with a background
worker against splitting it out, and recommend one.
```

**Fix a bug with `/bugfix`**

```text
/bugfix The orders list page takes 12 seconds for customers with many orders.
The endpoint is GET /api/orders. It was fast with 20 orders and is slow with 5,000.
```

Giving the symptom, the place, and the size lets the agent suspect an N+1 query or a missing index and prove it with a test.

```text
/bugfix Users sometimes get two confirmation emails after checkout.
Happens about once in 50 orders. Look at the checkout job and make it safe to run twice.
```

**Review before committing with `/review`**

```text
/review
```

No arguments needed. To focus the review, ask in plain words first: "Review my changes, paying extra attention to the new queries in `orders/repository`."

**Open a pull request with `/pr`**

```text
/pr 142
```

This links the PR to issue 142 (`Closes #142`). Run `/pr` with no number if there is no issue.

**Review a pull request with `/pr-review`**

```text
/pr-review 87
```

```text
/pr-review https://github.com/your-org/your-repo/pull/87 post
```

The first one only shows you the findings. The second posts the review to GitHub. Read the findings before you post.

**Call one agent directly**

You do not need a workflow for small jobs. Name the agent in your prompt:

```text
Use the test-engineer agent to add tests for the discount rules in `billing/discounts`.
Cover the edge cases: zero quantity, expired code, and two codes at once.
```

```text
Use the devops-engineer agent to write a multi-stage Dockerfile for the API and a separate
entry point for the background worker. Do not deploy anything.
```

```text
Use the backend-engineer agent to add an index for the slow query in `orders/repository.findByCustomer`.
Show me the EXPLAIN output before and after.
```

### A typical day

1. Write a short spec or a strong `/feature` prompt. Read the architect's plan and correct it before approving. This is the cheapest place to catch a wrong design.
2. Let the engineers build. Skim the final report: files changed and the test results.
3. Run `/review` before you commit, and commit yourself.
4. Run `/pr` to open a draft PR. Teammates (or you) run `/pr-review <number>`.
5. Always read the code yourself before merging. The agents catch common problems but do not replace your review.

## Notes

- Keep the standards short. Agents read them every task, so each extra line costs tokens.
- Agents use different models on purpose: `opus` for planning and review, `sonnet` for implementation. Change the `model:` line in an agent file to trade cost for quality.

## Adding a guide

Put new guides in `docs/` and add a row to the table above.

## Reference

[10 Advanced Techniques for Agentic Development with Claude Code](https://www.callibrity.com/articles/10-advanced-techniques-for-agentic-development-with-claude-code)
