# AGENTS.md

Conventions for AI coding tools (Claude Code, Codex CLI, Gemini CLI, etc.) when working in any of my repos.

## About me

- Name: Ethan Look-Potts
- Email: ethanlookpotts@gmail.com
- Editor: nvim (lua config at `~/.config/nvim/`)
- Shell: zsh
- Platform: macOS

## Communication style

- Be terse. State results and decisions directly.
- No end-of-turn filler summaries — I can read the diff.
- No emojis unless I ask for them.
- For exploratory questions ("what could we do about X?"), respond in 2–3 sentences with a recommendation and the main tradeoff.
- Match response length to the task. A simple question gets a direct answer, not headers and sections.

## Code style

- Default to writing no comments. Only add one when the WHY is non-obvious.
- Don't explain WHAT the code does — well-named identifiers do that.
- No scope creep. A bug fix doesn't need surrounding cleanup; a one-shot operation doesn't need a helper.
- Don't add error handling, fallbacks, or validation for scenarios that can't happen. Trust framework guarantees.
- Only validate at system boundaries (user input, external APIs).
- Don't add backwards-compatibility shims. If you can change the code, change it.
- No half-finished implementations. Either complete a feature or don't start it.

## Verification

- Run the actual tests/typecheck/lint before claiming done.
- Quote the actual command output in your response when reporting completion.
- For UI changes, open a browser and check the feature works.
- Type checking and test suites verify code correctness, not feature correctness.
- Never claim "should work" without evidence.

## Commit style

- Single-line conventional commit messages: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, etc.
- No co-author trailer.
- Never amend published commits.
- Never use `--no-verify`. If a hook fails, fix the underlying issue.

## Tool preferences

- Use `gh` for GitHub work (not GitHub MCP).
- Use `rg` (ripgrep) over `grep` and `find`.
- Use the dedicated Read/Write/Edit tools over `cat`/`sed`/`echo` redirects.

## Worktree workflow

Default to creating a worktree before starting substantive work.

For very small/safe changes (single-file tweak, doc fix, comment change, single-line config), ask first:

> "Small enough to do directly on `<branch>`?"

Otherwise, propose a worktree slug (short kebab-case, derived from the task) and proceed.

Steps:

1. Ensure `.git/info/exclude` contains `.worktrees/` and `.notes/` (append if missing — see "Per-repo personal-ignore setup").
2. `git worktree add .worktrees/<slug> -b <branch-name>`
3. `cd` into the worktree.
4. Work there.
5. On completion: open a PR with `gh pr create` against the appropriate base branch.
6. After PR merge: `git worktree remove .worktrees/<slug> && git branch -d <branch-name>`.

Other agents may be working in sibling `.worktrees/`. Run `git worktree list` to see them. Don't touch their files.

## Per-repo personal-ignore setup

At session start in any repo where you'll create worktrees or write notes/plans, ensure `.git/info/exclude` contains:

```
.worktrees/
.notes/
```

Append (don't replace) if either line is missing. This is per-machine, per-repo, never committed.

## Plans and personal notes

- Save design docs, specs, and implementation plans to `.notes/plans/<YYYY-MM-DD>-<topic>.md` relative to the repo root.
- Never use `docs/superpowers/specs/`, `docs/superpowers/plans/`, or any path that would commit to a shared repo.
- Create `.notes/plans/` if it doesn't exist.

## Tool-specific extensions

Import the tool-specific extension below:

- Claude: @~/src/dotfiles/ai/claude/CLAUDE.md

## Environment-specific overrides

If `~/AGENTS.local.md` exists, read it now and treat its instructions as overrides to anything above. This file is per-machine (different usernames, branch-naming conventions, environment-specific rules) and is not part of the shared dotfiles.

@~/AGENTS.local.md
