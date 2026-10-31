---
name: pr-review
description: Review a GitHub pull request and check its CI status. Run manually with /pr-review <number or URL> [post].
argument-hint: [PR number or URL] [post]
disable-model-invocation: true
---

Review this pull request: $ARGUMENTS

1. Use the `pr-reviewer` subagent on the PR.
2. Present its findings grouped by severity, the CI status, and the final verdict.
3. If the arguments end with the word `post`, post the review to GitHub as the subagent describes. Otherwise do not post anything; offer to post it.

Do not merge, close, or push to the PR branch.
