---
name: setup
description: One-time project setup. Fills in the docs/standards placeholders from the repo, removes standards for layers the project does not have, and allows the project's test and lint commands. Run manually with /setup.
disable-model-invocation: true
---

Set up the standards for this project. Run this once after copying the files in, and again when the stack changes. Filling the values in once means agents do not have to rediscover them on every task.

1. **Detect the stack.** Read only manifest and config files, at the root and one level down: `package.json` and its lockfile, `pyproject.toml`, `requirements*.txt`, `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle`, `Gemfile`, `composer.json`, `Makefile`, `Dockerfile`, `docker-compose*`, `*.tf`, `.github/workflows/*`, and test, lint, or formatter configs. Open source files only to confirm one fact, such as which ORM or LLM SDK is imported.
2. **Fill in the placeholders.** In each `docs/standards/` file, replace every `<...>` with the real value. Write commands exactly as the project runs them (`pnpm test`, `make lint`). Change only placeholders, never the rule text. If a value cannot be found, leave its placeholder and list it in the report; do not guess. Once a file has no placeholders left, delete its "Fill in the `<...>` placeholders" line.
3. **Remove unused layers.** List the standards files for layers the project does not have, with the evidence (for example, `ai.md` when no LLM or embedding SDK is installed). Ask the user before deleting anything. For each file they approve, also delete its line in `AGENTS.md`, its link in `general.md`, and the matching agent file if the user agrees.
4. **Allow the project's commands.** Add the test, lint, type check, and eval commands to `permissions.allow` in `.claude/settings.json` (for example `Bash(pnpm test *)`), keeping the existing entries. Never allow install, migrate, deploy, or publish commands.
5. **Check the formatter hook.** If the project uses a formatter that `.claude/hooks/format-edited-file.sh` does not cover, add a branch for it in the same style, guarded so it runs only when the formatter is installed.
6. **Report.**
   - Per standards file: each placeholder, the value used, and the file it came from.
   - Values not found, which the user must fill in.
   - Files deleted, and commands added to the allow list.
