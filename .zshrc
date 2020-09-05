#!/bin/env zsh
export LC_ALL=en_US.UTF-8
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export TERM=xterm-256color
ZSH_TMUX_AUTOSTART='true'

ZSH_THEME="spaceship"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

[ -f ~/.spaceship.zsh ] && [ "$ZSH_THEME" = "spaceship" ] && source ~/.spaceship.zsh 
[ -f ~/.powerlevel9k.zsh ] && [ "$ZSH_THEME" = "powerlevel9k/powerlevel9k" ] && source ~/.powerlevel9k.zsh

plugins=(iterm2 aws brew)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"

# GOPATH
export GOPATH=$HOME/go/
export PATH=$PATH:${GOPATH//://bin:}/bin

source $ZSH/oh-my-zsh.sh

source $HOME/.exports
source $HOME/.aliases
source $HOME/.functions
export PATH=$PATH:/Users/niclas/bin
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

[ -f ~/.ktx-completion.sh ] && source "${HOME}"/.ktx-completion.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.iterm2_statusbar.zsh ] && source ~/.iterm2_statusbar.zsh

source <(hcloud completion zsh)
source <(helm completion zsh | sed -E 's/\["(.+)"\]/\[\1\]/g')
[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

source <(terraform-docs completion zsh)
autoload -U compinit && compinit
