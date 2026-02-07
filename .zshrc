#!/bin/env zsh

export LC_ALL=en_US.UTF-8


ZSH_TMUX_AUTOSTART='true'

ZSH_THEME="spaceship"

# Set up PATH with system directories and $HOME/bin
export PATH="$PATH:$HOME/bin"

# golang
export GOPATH=$HOME/go

export PATH="$PATH:$GOPATH/bin"

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
plugins=(gcloud brew dotenv virtualenv uv)

export VIRTUAL_ENV_DISABLE_PROMPT=false

source $ZSH/oh-my-zsh.sh

# ASDF Data Directory
export ASDF_DATA_DIR=/Users/nmietz/.asdf
# Add ASDF shims to PATH
export PATH="$PATH:$ASDF_DATA_DIR/shims"

source $HOME/.exports
source $HOME/.aliases
source $HOME/.functions

[ -f ~/.functions-work ] && source ~/.functions-work

# VSCode
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Krew
export PATH="$PATH:$HOME/.krew/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.zsh-hooks.zsh ] && source ~/.zsh-hooks.zsh

[ -f ~/.iterm2_statusbar.zsh ] && source ~/.iterm2_statusbar.zsh

# Load Helm Access
[ -f ~/.helmrc ] && source ~/.helmrc

# source <(hcloud completion zsh)
[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Rust - Cargo
export PATH="$PATH:$HOME/.cargo/bin"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

#FPATH Exentsions for Auto-Completion
export fpath=(${HOMEBREW_PREFIX}/share/zsh-completions $fpath)
export fpath=(${HOME}/.oh-my-zsh/custom/completions $fpath)

# Load Autocompletions from fpath
autoload -U compinit && compinit -u

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/vault vault

. ~/.asdf/plugins/golang/set-env.zsh

# Istioctl
export PATH="$PATH:$HOME/.istioctl/bin"

# Flutter
export PATH="$PATH:$HOME/dev/flutter/bin"

eval "$(/opt/homebrew/bin/brew shellenv)"

export KUBE_EDITOR="code --wait"
export PATH="$HOME/.local/bin:$PATH"
