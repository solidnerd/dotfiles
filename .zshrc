#!/bin/env zsh
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export TERM=xterm-256color
ZSH_TMUX_AUTOSTART='true'

ZSH_THEME="spaceship"

[ -f ~/.spaceship.zsh ] && [ "$ZSH_THEME" = "spaceship" ] && source ~/.spaceship.zsh 
[ -f ~/.powerlevel9k.zsh ] && [ "$ZSH_THEME" = "powerlevel9k/powerlevel9k" ] && source ~/.powerlevel9k.zsh

plugins=(iterm2 aws)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# GOPATH
export GOPATH=$HOME/go/
export PATH=$PATH:${GOPATH//://bin:}/bin

source $ZSH/oh-my-zsh.sh

source $HOME/.exports
source $HOME/.alias
source $HOME/.functions
export PATH=$PATH:/Users/niclas/bin
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

[ -f ~/.ktx-completion.sh ] && source "${HOME}"/.ktx-completion.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source <(hcloud completion zsh)
source <(helm completion zsh | sed -E 's/\["(.+)"\]/\[\1\]/g')
