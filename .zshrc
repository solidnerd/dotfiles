#!/bin/env zsh

export LC_ALL=en_US.UTF-8

# Homebrew (static exports, no subprocess)
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Core paths
export PATH="$PATH:$HOME/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:$HOME/.krew/bin"
export PATH="$PATH:$HOME/.istioctl/bin"
export PATH="$PATH:$HOME/dev/flutter/bin"
export PATH="$PATH:$HOME/.cargo/bin"

# Go
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"

# ASDF
export ASDF_DATA_DIR=/Users/nmietz/.asdf
export PATH="$PATH:$ASDF_DATA_DIR/shims"

export KUBE_EDITOR="code --wait"

# ZSH cache dir (replaces oh-my-zsh's $ZSH_CACHE_DIR)
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d "$ZSH_CACHE_DIR/completions" ]] || mkdir -p "$ZSH_CACHE_DIR/completions"

source $HOME/.exports
source $HOME/.aliases
source $HOME/.functions
[ -f ~/.functions-work ] && source ~/.functions-work

# ===========================================================
# Antidote plugin manager
# ===========================================================

# Point dotenv plugin at our cache dir (no oh-my-zsh $ZSH_CACHE_DIR)
export ZSH_DOTENV_ALLOWED_LIST="$ZSH_CACHE_DIR/dotenv-allowed.list"
export ZSH_DOTENV_DISALLOWED_LIST="$ZSH_CACHE_DIR/dotenv-disallowed.list"

# Virtualenv: let Spaceship handle display
export VIRTUAL_ENV_DISABLE_PROMPT=1

source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# ===========================================================
# Completions (single compinit run)
# ===========================================================
fpath=(
  "$HOMEBREW_PREFIX/share/zsh/site-functions"
  "$HOMEBREW_PREFIX/share/zsh-completions"
  "$ZSH_CACHE_DIR/completions"
  $fpath
)

autoload -U compinit
_zcompdump="$ZSH_CACHE_DIR/.zcompdump"
if [[ -n $_zcompdump(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/vault vault
complete -o nospace -C /Users/nmietz/.asdf/shims/terraform terraform
complete -o nospace -C /Users/nmietz/.asdf/shims/terraform tf
complete -o nospace -C /Users/nmietz/.asdf/shims/terraform tfw

# kubectl completion + extend it to the k alias
# Cache the completion script; regenerate if kubectl is newer than the cache
_kubectl_completion="$ZSH_CACHE_DIR/completions/_kubectl"
if [[ ! -f "$_kubectl_completion" || /opt/homebrew/bin/kubectl -nt "$_kubectl_completion" ]]; then
  kubectl completion zsh >| "$_kubectl_completion"
fi
source "$_kubectl_completion"
compdef k=kubectl
unset _kubectl_completion

# ===========================================================
# Prompt: Spaceship
# ===========================================================
# Strip any inherited SPACESHIP_ROOT (could be stale from a parent shell)
typeset +r SPACESHIP_ROOT 2>/dev/null; unset SPACESHIP_ROOT 2>/dev/null
autoload -U promptinit; promptinit
prompt spaceship

# ===========================================================
# Tools
# ===========================================================

. ~/.asdf/plugins/golang/set-env.zsh

# Zoxide (replaces cd with smart frecency-based jumping)
# Generated via: zoxide init zsh --cmd cd
function __zoxide_pwd() { \builtin pwd -L }
function __zoxide_cd() { \builtin cd -- "$@" }
function __zoxide_hook() { \command zoxide add -- "$(__zoxide_pwd)" }
\builtin typeset -ga precmd_functions
\builtin typeset -ga chpwd_functions
precmd_functions=("${(@)precmd_functions:#__zoxide_hook}")
chpwd_functions=("${(@)chpwd_functions:#__zoxide_hook}")
chpwd_functions+=(__zoxide_hook)
function __zoxide_z() {
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]+$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$#" -eq 2 ]] && [[ "$1" = "--" ]]; then
        __zoxide_cd "$2"
    else
        \builtin local result
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" && __zoxide_cd "${result}"
    fi
}
function __zoxide_zi() {
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}
function cd()  { __zoxide_z  "$@" }
function cdi() { __zoxide_zi "$@" }
if [[ -o zle ]]; then
    __zoxide_result=''
    function __zoxide_z_complete() {
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0
        if [[ "${#words[@]}" -eq 2 ]]; then
            _cd -/
        elif [[ "${words[-1]}" == '' ]]; then
            __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''
            compadd -Q ""
            \builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
            \builtin printf '\e[5n'
            return 0
        fi
    }
    function __zoxide_z_complete_helper() {
        if [[ -n "${__zoxide_result}" ]]; then
            BUFFER="cd ${(q-)__zoxide_result}"
            __zoxide_result=''
            \builtin zle reset-prompt
            \builtin zle accept-line
        else
            \builtin zle reset-prompt
        fi
    }
    \builtin zle -N __zoxide_z_complete_helper
    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete cd
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh-hooks.zsh ] && source ~/.zsh-hooks.zsh
[ -f ~/.iterm2_statusbar.zsh ] && source ~/.iterm2_statusbar.zsh
[ -f ~/.helmrc ] && source ~/.helmrc
[ -f ~/.jira-cli ] && source ~/.jira-cli
[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ===========================================================
# NVM (lazy-loaded)
# ===========================================================
export NVM_DIR="$HOME/.nvm"

__nvm_load() {
  unset -f nvm node npm npx yarn pnpm __nvm_load
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}
nvm()  { __nvm_load; nvm "$@"; }
node() { __nvm_load; node "$@"; }
npm()  { __nvm_load; npm "$@"; }
npx()  { __nvm_load; npx "$@"; }
yarn() { __nvm_load; yarn "$@"; }
pnpm() { __nvm_load; pnpm "$@"; }
