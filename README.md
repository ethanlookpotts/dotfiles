# dotfiles

Personal dev environment: terminal, editor, AI tools.

## Prerequisites

Run these once on a fresh machine before `./install.sh`. None of them are idempotent in a way that's safe to re-run automatically, so they live here, not in the install script.

1. Xcode Command Line Tools:
   ```
   xcode-select --install
   ```
2. Homebrew:
   ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. iTerm2:
   ```
   brew install --cask iterm2
   ```
4. Oh My Zsh:
   ```
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
   ```
5. Powerlevel10k theme:
   ```
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
     ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   ```
6. Zsh plugins (referenced by `.zshrc`):
   ```
   git clone https://github.com/zsh-users/zsh-autosuggestions \
     ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting \
     ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   ```

## Setup

```
git clone git@github.com:ethanlookpotts/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
./install.sh
```

Then follow the post-install checklist that `install.sh` prints.

## Updating

```
git -C ~/src/dotfiles pull
~/src/dotfiles/install.sh
```

`install.sh` is idempotent — safe to re-run any time.

## Per-machine overrides

Three files in `$HOME` are gitignored and per-machine. `install.sh` creates empty stubs where needed; edit them to override anything from the shared dotfiles:

- `~/.zshrc.local` — shell-level overrides (credentials, aliases)
- `~/AGENTS.local.md` — AI-tool conventions (username, branch naming, environment-specific rules)
- `~/.claude/settings.local.json` — Claude Code settings overrides (disable plugins, allowlist additions)

## Mobile

iPhone setup via Termius is documented separately: [TERMIUS.md](TERMIUS.md).
