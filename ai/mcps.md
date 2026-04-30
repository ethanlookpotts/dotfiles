# MCP servers

## Active

| MCP | Source | Notes |
|---|---|---|
| Playwright | bundled with `playwright@claude-plugins-official` plugin | Browser automation. Starts on session demand. |

## Removed (intentionally)

- claude.ai Google Drive, Calendar, Gmail — left unauth'd, contributed noise to startup. Re-add only if used regularly.

## Per-tool registration syntax

For MCPs not bundled with a plugin, register manually:

- **Claude Code:** `claude mcp add <name> -- <command...>`
  Example: `claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking`
- **Codex CLI / Gemini CLI:** TBD when adopted.

## Cap

Keep active MCPs ≤ 5. Each one starts a subprocess and burns context with tool schemas at session start.
