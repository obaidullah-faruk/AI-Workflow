---
name: feature
description: Build a feature end to end: plan, implement, test, review. Run manually with /feature <description or spec path>.
argument-hint: [feature description or path to a spec file]
disable-model-invocation: true
---

Build this feature: $ARGUMENTS

If the argument is a file path, read it and treat its acceptance criteria as the definition of done. Otherwise, if the request is ambiguous, ask the user up to three clarifying questions before step 1.

Follow these steps in order. Do not skip any.

1. **Plan.** Use the `architect` subagent to produce an approach and an ordered task list. Show the plan to the user and wait for approval before changing any code.
2. **Implement.** For each task, use the subagent named in the plan (`frontend-engineer`, `backend-engineer`, or `devops-engineer`). Run tasks one at a time unless they touch different files and do not depend on each other.
3. **Test.** Use the `test-engineer` subagent to add tests for the new behavior and run the full test suite.
4. **Review.** Use the `code-reviewer` subagent on the full change.
5. **Fix.** If the review lists "Must fix" items or tests fail, send them back to the right engineer subagent, then repeat steps 3 and 4. Stop and ask the user after two rounds.
6. **Report.** Summarize in this shape:
   - What was built, in 2 to 3 sentences.
   - Files changed.
   - Test and lint results, with the commands run.
   - Any remaining review notes or open questions.

Do not commit or push. Leave that to the user.
