# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

################################################################################
# PATH Configuration
################################################################################
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

################################################################################
# Oh My Zsh Configuration
################################################################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

################################################################################
# Aliases
################################################################################
alias k="kubectl"
alias gl="watch -n 5 -c git -c color.ui=always log --decorate --graph --oneline --branches={'*elookpotts*','*main*'}"
alias gs="watch -n 5 -c git -c color.ui=always status -s"
alias vim="nvim"
alias vi="nvim"
alias ff="nvim -c 'Telescope find_files hidden=true'"
alias cheat="open https://ethanlookpotts.github.io/dotfiles/"

export EDITOR=nvim

################################################################################
# Tool Completions (Cached for Performance)
################################################################################

# Cached kubectl completion
if command -v kubectl &> /dev/null; then
  kubectl_completion_cache="$HOME/.cache/zsh/kubectl_completion.zsh"
  if [[ ! -f "$kubectl_completion_cache" ]] || [[ $(find "$kubectl_completion_cache" -mtime +7 2>/dev/null) ]]; then
    mkdir -p "$(dirname "$kubectl_completion_cache")"
    kubectl completion zsh > "$kubectl_completion_cache" 2>/dev/null
  fi
  [[ -f "$kubectl_completion_cache" ]] && source "$kubectl_completion_cache"
fi

# Cached kind completion
if command -v kind &> /dev/null; then
  kind_completion="${fpath[1]}/_kind"
  if [[ ! -f "$kind_completion" ]] || [[ "$(command -v kind)" -nt "$kind_completion" ]]; then
    kind completion zsh > "$kind_completion" 2>/dev/null
  fi
fi

# FZF
command -v fzf &> /dev/null && source <(fzf --zsh)

# Docker CLI completions
if [[ -d "/Users/elookpotts/.docker/completions" ]]; then
  fpath=(/Users/elookpotts/.docker/completions $fpath)
  autoload -Uz compinit
  compinit
fi

################################################################################
# Lazy-Loaded Tools
################################################################################

# Lazy load NVM
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  nvm() {
    unset -f nvm node npm npx
    source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
    nvm "$@"
  }
  node() { nvm > /dev/null 2>&1; command node "$@"; }
  npm() { nvm > /dev/null 2>&1; command npm "$@"; }
  npx() { nvm > /dev/null 2>&1; command npx "$@"; }
fi

# Lazy load pyenv
if command -v pyenv &> /dev/null; then
  pyenv() {
    unset -f pyenv python pip
    eval "$(command pyenv init - zsh)"
    pyenv "$@"
  }
  python() { pyenv > /dev/null 2>&1; command python "$@"; }
  pip() { pyenv > /dev/null 2>&1; command pip "$@"; }
fi

# Lazy load thefuck
if command -v thefuck &> /dev/null; then
  fuck() {
    unset -f fuck
    eval "$(thefuck --alias)"
    fuck "$@"
  }
fi

################################################################################
# Custom Functions
################################################################################

# Improved killport function with validation and graceful shutdown
killport() {
  if [[ -z "$1" ]]; then
    echo "Usage: killport <port>" >&2
    return 1
  fi

  # Validate port number
  if ! [[ "$1" =~ ^[0-9]+$ ]] || [[ "$1" -lt 1 ]] || [[ "$1" -gt 65535 ]]; then
    echo "Error: Invalid port number. Must be between 1-65535" >&2
    return 1
  fi

  local port="$1"
  local pid
  pid=$(lsof -ti ":$port" 2>/dev/null)

  if [[ -z "$pid" ]]; then
    echo "No process found running on port $port" >&2
    return 1
  fi

  echo "Found process $pid on port $port:"
  ps -p "$pid" -o pid,comm,args 2>/dev/null | tail -n +2

  # Confirm for privileged ports
  if [[ "$port" -lt 1024 ]]; then
    echo -n "This is a privileged port. Continue? [y/N] "
    read -r confirm
    [[ "$confirm" != "y" ]] && return 0
  fi

  echo "Attempting graceful shutdown..."
  kill "$pid" 2>/dev/null
  sleep 2

  if kill -0 "$pid" 2>/dev/null; then
    echo "Process didn't terminate, forcing with SIGKILL..."
    kill -9 "$pid" 2>/dev/null
  fi

  if kill -0 "$pid" 2>/dev/null; then
    echo "Failed to kill process $pid" >&2
    return 1
  else
    echo "Successfully killed process on port $port"
  fi
}

# Function to get host IP address
sethostip() {
  local echo_output=${1:-true}
  local ip

  ip=$(ifconfig 2>/dev/null | grep "inet " | grep -Fv 127.0.0.1 | grep -E " (10|172\.(1[6-9]|2[0-9]|3[0-1])|192\.168)\." | awk '{print $2}' | head -1)

  if [[ -z "$ip" ]]; then
    if [[ "$echo_output" == "true" ]]; then
      echo "Warning: Could not determine host IP address" >&2
    fi
    return 1
  fi

  export HOST_IP_ADDRESS="$ip"

  if [[ "$echo_output" == "true" ]]; then
    echo "HOST_IP_ADDRESS: $HOST_IP_ADDRESS"
  fi
}

sethostip false

# Create-or-attach a tmux session. With no arg, names the session after the
# current directory's basename. With an arg matching ~/src/<name>, cd there
# first. Works inside or outside an existing tmux client.
work() {
  if ! command -v tmux &>/dev/null; then
    echo "work: tmux not installed" >&2
    return 1
  fi

  local target="${1:-$(basename "$PWD")}"
  local sname="${target//[.:]/_}"
  local dir="$HOME/src/$target"

  [[ -d "$dir" ]] && cd "$dir"

  if [[ -n "$TMUX" ]]; then
    tmux has-session -t "$sname" 2>/dev/null || tmux new-session -d -s "$sname"
    tmux switch-client -t "$sname"
  else
    tmux new-session -A -s "$sname"
  fi
}

_work() { _path_files -W ~/src -/ }
compdef _work work

################################################################################
# Keybindings
################################################################################

# Remap kill-to-end-of-line from Ctrl+K to Ctrl+] (since Ctrl+K is used for tmux/nvim navigation)
# Note: Use Ctrl+Y to yank (paste) the killed text back
bindkey '^]' kill-line

################################################################################
# Powerlevel10k
################################################################################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

################################################################################
# Local Configuration (gitignored - for credentials, work-specific settings)
################################################################################
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
