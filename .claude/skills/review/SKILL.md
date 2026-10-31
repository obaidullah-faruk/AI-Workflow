---
name: review
description: Review the current uncommitted changes against the project standards before committing. Run manually with /review.
disable-model-invocation: true
---

Review my current changes before I commit.

1. Run `git status --porcelain`. If it prints nothing, say there are no changes and stop.
2. Use the `code-reviewer` subagent on the uncommitted changes, including untracked files. Tell it you run the tests yourself, so it does not.
3. Run the project's lint, type check, and test commands (see the "Commands" section in the relevant `docs/standards/` files). Report any failures, quoting only the failing output.
4. Present the result:
   - The reviewer's findings, grouped by severity.
   - Lint, type check, and test results.
   - A final line: `ready to commit` or `not ready: <reason>`.

Do not edit files, commit, or push. Only report.
