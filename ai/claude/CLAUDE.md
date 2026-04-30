# Claude Code conventions

Tool-specific extensions for Claude Code. Imported from `ai/AGENTS.md`. Other AI CLIs (Codex, Gemini) don't load this file (or, if they honor `@imports`, see clearly-scoped sections below and ignore them by convention).

## Session naming

Early in a session, after the initial task is clear (usually within the first 1–2 turns, not on the very first reply), propose a short session name. Format the suggestion as a single line at the end of a reply:

> Suggested session name: `<name>` — run `/rename <name>` to apply.

Pick the name from the task: 1–4 words, kebab-case, lowercase, derived from what the session is actually about. Examples:

- "Refactor the auth module" → `auth-refactor`
- "Brainstorm a CC setup for my dotfiles" → `cc-dotfiles-setup`
- "Investigate flaky deploys" → `flaky-deploy-investigation`

Skip for one-shot questions, quick fixes, sessions already renamed, and follow-up turns in named sessions. Propose at most once per session.

The agent cannot invoke `/rename` programmatically — only suggest. The user types the command if they want it applied.
