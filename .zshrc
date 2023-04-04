#!/bin/env zsh

export LC_ALL=en_US.UTF-8
export TERM=xterm-256color

ZSH_TMUX_AUTOSTART='true'

ZSH_THEME="spaceship"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# eval "$(starship init zsh)"

# $HOME/bin configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"

# golang
export GOPATH=$HOME/go/
export PATH=$PATH:${GOPATH//://bin:}/bin

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
plugins=(aws brew dotenv virtualenv)

export VIRTUAL_ENV_DISABLE_PROMPT=false

source $ZSH/oh-my-zsh.sh


# ASDF
export ASDF_DIR="$(brew --prefix asdf)/libexec"
source $ASDF_DIR/asdf.sh
#source $ASDF_DIR/etc/bash_completion.d/asdf.bash

source $HOME/.exports
source $HOME/.aliases
source $HOME/.functions

[ -f ~/.functions-work] && source ~/.functions-work

export PATH=$PATH:/Users/niclas/bin
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export PATH="${PATH}:${HOME}/.krew/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.zsh-hooks.zsh ] && source ~/.zsh-hooks.zsh
[ -f ~/.iterm2_statusbar.zsh ] && source ~/.iterm2_statusbar.zsh

# Load Helm Access 
[ -f ~/.helmrc ] && source ~/.helmrc


# source <(hcloud completion zsh)
[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# source <(terraform-docs completion zsh)
export PATH="/usr/local/sbin:$PATH"
# source <(k3d completion zsh)

export PATH="/usr/local/opt/mongodb-community@4.0/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"




PATH="/Users/niclas/.local/share/solana/install/active_release/bin:$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

. ~/.asdf/plugins/java/set-java-home.zsh

# zprof
