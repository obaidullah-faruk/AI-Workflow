---
name: bugfix
description: Fix a bug test-first: reproduce, fix, verify, review. Run manually with /bugfix <bug description or issue>.
argument-hint: [bug description, error message, or issue link]
disable-model-invocation: true
---

Fix this bug: $ARGUMENTS

Follow these steps in order.

1. **Reproduce.** Find the code path that causes the bug. Use the `test-engineer` subagent to write a test that fails because of this bug, and confirm it fails for the right reason. If you cannot reproduce it, stop and tell the user what you tried.
2. **Fix.** Use the matching engineer subagent (`frontend-engineer`, `backend-engineer`, or `devops-engineer`) to make the smallest change that fixes the root cause. Do not fix symptoms or refactor nearby code.
3. **Verify.** Run the new test and the full test suite. Both must pass.
4. **Review.** Use the `code-reviewer` subagent. Fix any "Must fix" items and re-verify.
5. **Report.**
   - Root cause in one or two sentences.
   - The fix and the files changed.
   - The test that now covers it, and the commands you ran with results.

Do not commit or push. Leave that to the user.
