# Claude Code plugins

The full plugin set is configured in [`settings.json`](settings.json) under `enabledPlugins`. This file documents what each plugin does and how to override the set on specific machines.

## Plugins (alphabetical)

| Plugin | Why |
|---|---|
| `andrej-karpathy-skills@karpathy-skills` | Behavioral guidelines to reduce common LLM coding mistakes (Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution) |
| `claude-md-management@claude-plugins-official` | Auditing and improving CLAUDE.md / AGENTS.md across repos |
| `code-simplifier@claude-plugins-official` | On-demand cleanup passes |
| `context7@claude-plugins-official` | Injects up-to-date library docs into the session — kills API hallucination |
| `frontend-design@claude-plugins-official` | Distinctive UI generation, avoids generic AI aesthetics |
| `playwright@claude-plugins-official` | Browser automation MCP bundled |
| `skill-creator@claude-plugins-official` | For writing/maintaining custom skills |
| `superpowers@claude-plugins-official` | Brainstorming, writing-plans, executing-plans, TDD, debugging, etc. |
| `voltagent-core-dev@voltagent-subagents` | API/backend/frontend/fullstack/UI subagents |
| `voltagent-dev-exp@voltagent-subagents` | Refactoring, git-workflow, dx-optimizer, mcp-developer, readme-generator |
| `voltagent-infra@voltagent-subagents` | K8s, Terraform, Docker, cloud, devops |
| `voltagent-lang@voltagent-subagents` | Per-language specialists (TS, Python, Go, etc.) |
| `voltagent-qa-sec@voltagent-subagents` | code-reviewer, debugger, test-automator, security-auditor |

## Skill exception: humanizer

Humanizer (https://github.com/blader/humanizer) has no `.claude-plugin/` metadata upstream as of 2026-04-30, so it's installed via `git clone` into `~/.claude/skills/humanizer` instead of the plugin pipeline. `install-plugins.sh` handles this. If upstream adds plugin metadata later, switch to `claude plugin install` and remove the clone fallback.

## Per-machine overrides

`~/.claude/settings.local.json` (gitignored, NOT symlinked from dotfiles) is merged on top of the shared `settings.json` with local taking precedence. Use it to:

- Disable plugins on a specific machine:
  ```json
  { "enabledPlugins": { "voltagent-infra@voltagent-subagents": false } }
  ```
- Add machine-specific allowlist entries:
  ```json
  { "permissions": { "allow": ["Bash(kubectl get:*)"] } }
  ```

`install.sh` creates an empty stub at `~/.claude/settings.local.json` if missing.

## Maintenance

Run `/fewer-permission-prompts` quarterly to expand the allowlist based on real usage. Re-run `~/src/dotfiles/ai/claude/install-plugins.sh` after edits to that script.
