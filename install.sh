#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/src/dotfiles}"

# (target_path, source_in_dotfiles) pairs, separated by ':'.
MANAGED_LINKS=(
  "$HOME/.zshrc:$DOTFILES/.zshrc"
  "$HOME/.tmux.conf:$DOTFILES/.tmux.conf"
  "$HOME/.p10k.zsh:$DOTFILES/.p10k.zsh"
  "$HOME/.config/nvim:$DOTFILES/.config/nvim"
  "$HOME/.claude/CLAUDE.md:$DOTFILES/ai/AGENTS.md"
  "$HOME/.claude/settings.json:$DOTFILES/ai/claude/settings.json"
)

link() {
  local dst="$1" src="$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then return; fi
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    echo "conflict: $dst exists and is not a symlink — refusing to clobber"
    echo "        back it up manually (mv \"$dst\" \"$dst.bak\") and re-run."
    exit 1
  fi
  if [[ -L "$dst" ]]; then rm "$dst"; fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
}

stale_warn() {
  for entry in "${MANAGED_LINKS[@]}"; do
    local dst="${entry%%:*}"
    local expected="${entry##*:}"
    if [[ -L "$dst" ]]; then
      local target
      target="$(readlink "$dst")"
      if [[ "$target" != "$expected" && "$target" == "$DOTFILES"/* ]]; then
        echo "warning: $dst -> $target (expected $expected). Remove it manually if intentional."
      fi
    fi
  done
}

# 1. Brew packages (no-op if brew missing — work-laptop friendly)
if command -v brew &>/dev/null; then
  brew install --quiet tmux thefuck neovim ripgrep fzf watch gh
  command -v bun &>/dev/null || brew install --quiet bun
  command -v ccusage &>/dev/null || bun install -g ccusage
else
  echo "warning: brew not found — skipping package installs"
fi

# 2. Symlinks
for entry in "${MANAGED_LINKS[@]}"; do
  link "${entry%%:*}" "${entry##*:}"
done

stale_warn

# 3. Stubs (only if missing — never overwrite)
if [[ ! -f "$HOME/AGENTS.local.md" ]]; then
  cat > "$HOME/AGENTS.local.md" <<'EOF'
# Environment-specific overrides
# (Empty by default. Add machine-specific differences here:
#  - username on this machine if different from dotfiles default
#  - branch-naming conventions for this environment
#  - work-vs-personal repo URLs
#  - anything else that should override AGENTS.md on this machine.)
EOF
  echo "created stub: $HOME/AGENTS.local.md"
fi

if [[ ! -f "$HOME/.claude/settings.local.json" ]]; then
  mkdir -p "$HOME/.claude"
  cat > "$HOME/.claude/settings.local.json" <<'EOF'
{
  "permissions": { "allow": [] }
}
EOF
  echo "created stub: $HOME/.claude/settings.local.json"
fi

# 4. Non-identity git config
git config --global core.editor nvim

# 5. Post-install checklist
cat <<'EOF'

Done. Manual steps remaining:
  1. git config --global user.name "..." && git config --global user.email "..."
     (per-machine identity)
  2. Add SSH key to GitHub:
     https://docs.github.com/en/authentication/connecting-to-github-with-ssh
  3. claude /login
  4. ~/src/dotfiles/ai/claude/install-plugins.sh
  5. gh auth login
  6. iTerm color theme (moonfly) + MesloLGS NF font (see TERMIUS.md for font URL)
  7. If this is a work or environment-specific machine:
     edit ~/AGENTS.local.md and ~/.claude/settings.local.json
EOF
