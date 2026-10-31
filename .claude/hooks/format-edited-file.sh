#!/usr/bin/env bash
# PostToolUse hook: formats the file Claude just edited, so agents never spend turns
# on formatting fixes. It must never block an edit, so it always exits 0 silently.

set -u

file_path=$(jq -r '.tool_input.file_path // .tool_response.filePath // empty' 2>/dev/null) || exit 0
[ -n "$file_path" ] && [ -f "$file_path" ] || exit 0

project_dir="${CLAUDE_PROJECT_DIR:-$PWD}"
case "$file_path" in
  "$project_dir"/*) ;;
  *) exit 0 ;; # Never rewrite files outside this project.
esac

node_bin="$project_dir/node_modules/.bin"
PATH="$project_dir/.venv/bin:$PATH"

# Prettier, Biome, Ruff, and Black run only when the project installs or configures
# them; otherwise a file would be restyled against the project's own conventions.
is_configured_in_pyproject() {
  [ -f "$project_dir/pyproject.toml" ] && grep -q "^\[tool\.$1" "$project_dir/pyproject.toml"
}

case "$file_path" in
  *.js|*.jsx|*.ts|*.tsx|*.mjs|*.cjs|*.json|*.css|*.scss|*.html|*.vue|*.svelte|*.md|*.yml|*.yaml)
    if [ -x "$node_bin/biome" ]; then
      "$node_bin/biome" format --write "$file_path"
    elif [ -x "$node_bin/prettier" ]; then
      "$node_bin/prettier" --write --ignore-unknown "$file_path"
    fi
    ;;
  *.py)
    if command -v ruff && { [ -f "$project_dir/ruff.toml" ] || [ -f "$project_dir/.ruff.toml" ] || is_configured_in_pyproject ruff; }; then
      ruff format "$file_path"
    elif command -v black && is_configured_in_pyproject black; then
      black --quiet "$file_path"
    fi
    ;;
  # These languages have one standard style, so no project opt-in is needed.
  *.go) command -v gofmt && gofmt -w "$file_path" ;;
  *.tf|*.tfvars) command -v terraform && terraform fmt "$file_path" ;;
  *.rs) command -v rustfmt && rustfmt "$file_path" ;;
esac >/dev/null 2>&1

exit 0
