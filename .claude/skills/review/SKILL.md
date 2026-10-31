---
name: review
description: Review the current uncommitted changes against the project standards before committing. Run manually with /review.
disable-model-invocation: true
---

Review my current changes before I commit.

1. Run `git status` and `git diff HEAD`. If there are no changes, say so and stop.
2. Use the `code-reviewer` subagent on the changes.
3. Run the project's lint, type check, and test commands (see the "Commands" section in the relevant `docs/standards/` files). Report any failures.
4. Present the result:
   - The reviewer's findings, grouped by severity.
   - Lint, type check, and test results.
   - A final line: `ready to commit` or `not ready: <reason>`.

Do not edit files, commit, or push. Only report.
