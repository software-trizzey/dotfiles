# Git branch function for prompt
git_branch() {
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo " %F{yellow}($branch)%f"
  fi
}

export EDITOR=vim
export VISUAL=$EDITOR   

# Custom colorful prompt with git branch
setopt PROMPT_SUBST
PROMPT='%F{cyan}%n%f%F{white}@%f%F{green}%m%f %F{magenta}%1~%f$(git_branch) '

# Enable colors for common commands
# ls with colors (macOS uses -G flag)
alias ls='ls -G'
alias ll='ls -lG'
alias la='ls -laG'

# grep with colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enable colors for diff
alias diff='diff --color=auto'

# Enable colors for less
export LESS='-R'

# Enable colors in man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'


# Project swap shortcuts
alias nimble="cd /Users/tristan/Work/nimble"
alias nimble-mono="cd /Users/tristan/Work/monorepo"
alias nimble-data="cd /Users/tristan/Work/data"
alias skills="cd ~/.agents/skills/"
alias td-site="cd ~/Projects/site"
alias stumphero="cd ~/Work/stumphero"

# General Shortcuts
alias dc="docker compose"
alias dcu="docker compose up"

# Project shortcuts
alias nimble-manage="docker compose exec app poetry run python manage.py"
alias nimble-test="docker compose exec app poetry run python manage.py test"

alias alchemized="cd ~/Work/alchemized-site"
alias alchemized-mono="cd ~/Projects/alchemized-monorepo"

# ============================================
# Zsh Autocomplete Configuration
# ============================================

# Initialize completion system
autoload -Uz compinit
# Only regenerate completion cache once per day (faster startup)
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Enable completion menu
zstyle ':completion:*' menu select

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group matches and describe
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Show colors in completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Better completion for kill command
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

# Cache completion results
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

# Ignore completion functions for commands you don't have
zstyle ':completion:*:functions' ignored-patterns '_*'

# More verbose completion
zstyle ':completion:*' verbose yes

# Show all options when ambiguous
setopt AUTO_LIST
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# History-based completion
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Bind arrow keys for history search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# Create cache directory if it doesn't exist
[[ -d ~/.zsh/cache ]] || mkdir -p ~/.zsh/cache

# ============================================
# Zsh Autosuggestions
# ============================================
# Suggests commands as you type based on history
# Press right arrow (→) or End key to accept suggestion
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Optional: Customize the suggestion color (default is gray)
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'


eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc



# PostgreSQL 16 as default (for new projects)
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# pyenv - Python version management
# pyenv stores Python versions in ~/.pyenv/versions
export PYENV_ROOT="$HOME/.pyenv"
export PATH="/opt/homebrew/opt/pyenv/bin:$PATH"
eval "$(pyenv init - zsh)"

# pnpm
export PNPM_HOME="/Users/tristan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# opencode
export PATH=/Users/tristan/.opencode/bin:$PATH

# Created by `pipx` on 2026-01-27 20:19:34
export PATH="$PATH:/Users/tristan/.local/bin"

# bun completions
[ -s "/Users/tristan/.bun/_bun" ] && source "/Users/tristan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Add clerk completions
eval "$(clerk completion zsh)"
