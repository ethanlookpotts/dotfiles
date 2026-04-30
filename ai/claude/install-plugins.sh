#!/usr/bin/env bash
set -euo pipefail

# Marketplaces (idempotent — re-running is a no-op)
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add VoltAgent/awesome-claude-code-subagents
claude plugin marketplace add forrestchang/andrej-karpathy-skills

# Official plugins
for p in superpowers frontend-design code-simplifier playwright \
         skill-creator claude-md-management context7; do
  claude plugin install "$p@claude-plugins-official"
done

# VoltAgent subset (5 of 9: core-dev, lang, infra, qa-sec, dev-exp)
for p in voltagent-core-dev voltagent-lang voltagent-infra \
         voltagent-qa-sec voltagent-dev-exp; do
  claude plugin install "$p@voltagent-subagents"
done

# Karpathy guidelines plugin
claude plugin install andrej-karpathy-skills@karpathy-skills

# Humanizer: no plugin form available upstream. Skill-clone fallback.
# (Documented exception to the "always plugins" rule. If upstream adds a
#  .claude-plugin/marketplace.json, switch to plugin install and remove this.)
mkdir -p ~/.claude/skills
[[ -d ~/.claude/skills/humanizer ]] || \
  git clone https://github.com/blader/humanizer ~/.claude/skills/humanizer

echo "Done. Restart Claude Code to pick up enabled plugins."
