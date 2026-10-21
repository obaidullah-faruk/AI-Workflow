# Context7

Context7 is an MCP server (a plugin that gives an AI agent extra tools). It lets your agent look up current, version-specific library docs instead of relying on its training data, which may be out of date.

## When to use it

**Use it for:** library or framework APIs, setup and configuration, version upgrades, and errors specific to a library.
Examples: React, Next.js, Prisma, Tailwind, Supabase, Django.

**Skip it for:** general coding concepts, refactoring, bugs in your own logic, and code review.

## Installation

1. Get a free API key at [context7.com/dashboard](https://context7.com/dashboard). Keys start with `ctx7sk-`.
2. Add Context7 to Claude Code for all your projects:

   ```sh
   claude mcp add --scope user --transport http \
     --header "Authorization: Bearer YOUR_API_KEY" \
     context7 https://mcp.context7.com/mcp
   ```

   Or run `npx ctx7 setup --claude`, which signs you in and sets everything up for you.

3. Check that it works:

   ```sh
   claude mcp list
   ```

   You should see `context7: https://mcp.context7.com/mcp (HTTP) - ✓ Connected`.

<details>
<summary>Cursor / VS Code</summary>

Cursor: `~/.cursor/mcp.json`. VS Code: `.vscode/mcp.json`, using `"servers"` instead of `"mcpServers"`.

```json
{
  "mcpServers": {
    "context7": {
      "url": "https://mcp.context7.com/mcp",
      "headers": { "Authorization": "Bearer YOUR_API_KEY" }
    }
  }
}
```
</details>

## Usage

Add **"use context7"** to your prompt. The agent then finds the library and fetches the relevant docs before it answers.

### Example prompts

```text
use context7 to show me how to set up middleware in Next.js 15
use context7 for Prisma queries with relations
use context7 — how do I add row-level security in Supabase?
```

If you already know the library, name it by ID to skip the search:

```text
use context7 with /supabase/supabase for email login
```

Add a version to the ID to get docs for that version:

```text
use context7 with /vercel/next.js/v16.2.9 for app router caching
```

### Make it automatic

Add this line to `CLAUDE.md` or `AGENTS.md` so you don't have to type "use context7" every time:

```text
Always use Context7 when I need library/API documentation, code generation, or setup and configuration steps.
```

## Tips

- Ask one specific question at a time. "JWT auth in Express" works better than "auth".
- Say which version you're on, or the agent may use docs for the latest release.
- Never put API keys or private code in a prompt, because queries are sent to Context7's servers.
- If the agent picks the wrong library, give it the exact ID (`/org/project`).

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Not listed in `/mcp` | Re-add it with `--scope user`. |
| `✗ Failed to connect` | Check the header reads `Bearer ctx7sk-...`, or create a new key. |
| Agent ignores Context7 | Say "use context7", or add the rule above. |

[GitHub](https://github.com/upstash/context7) · [Website](https://context7.com)
