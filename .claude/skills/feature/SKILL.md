---
name: feature
description: Build a feature end to end: plan, implement, test, review. Run manually with /feature <description or spec path>.
argument-hint: [feature description or path to a spec file]
disable-model-invocation: true
---

Build this feature: $ARGUMENTS

If the argument is a file path, read it and treat its acceptance criteria as the definition of done. Otherwise, if the request is ambiguous, ask the user up to three clarifying questions before step 1.

Follow these steps in order. Do not skip any.

1. **Plan.** Use the `architect` subagent to produce an approach and an ordered task list. Show the plan to the user and wait for approval before changing any code. If the plan includes a decision record, save it to `docs/decisions/` with the next free number once the user approves.
2. **Implement.** For each task, use the subagent named in the plan (`frontend-engineer`, `backend-engineer`, `ai-engineer`, or `devops-engineer`). Run tasks one at a time unless they touch different files and do not depend on each other.
3. **Test.** Use the `test-engineer` subagent to add tests for the new behavior and run the full test suite.
4. **Review.** Use the `code-reviewer` subagent on the full change, including new untracked files. Tell it the tests were already run in step 3, so it does not run them again.
5. **Fix.** If the review lists "Must fix" items or tests fail, send them back to the right engineer subagent. Then rerun the tests, and have `code-reviewer` check only the files changed by the fix and whether each earlier "Must fix" item is resolved, not the whole change again. Stop and ask the user after two rounds.
6. **Report.** Summarize in this shape:
   - What was built, in 2 to 3 sentences.
   - Files changed.
   - Test and lint results, with the commands run.
   - Any remaining review notes or open questions.

Do not commit or push. Leave that to the user.
