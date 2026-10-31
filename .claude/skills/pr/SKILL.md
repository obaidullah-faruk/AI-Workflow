---
name: pr
description: Open a GitHub pull request for the current branch after a pre-flight review. Run manually with /pr [issue number].
argument-hint: [issue number to close, optional]
disable-model-invocation: true
---

Open a pull request for the current branch. Issue to link (optional): $ARGUMENTS

1. **Pre-flight.** Use the `code-reviewer` subagent on the branch changes (`git diff <base>...HEAD`). If it lists "Must fix" items, show them and stop; do not open the PR.
2. **Create.** Use the `pr-creator` subagent to push the branch and open a draft PR. Pass along the issue number if one was given.
3. **Report.** Give the PR URL, the title, and any caveats the creator noted (for example, missing tests).

Do not merge the PR.
