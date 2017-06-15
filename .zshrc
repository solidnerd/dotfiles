# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_MODE='awesome-patched'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(rvm go_version)

plugins=(git brew)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# GOPATH
export GOPATH=$HOME/go/
export PATH=$PATH:${GOPATH//://bin:}/bin

source $ZSH/oh-my-zsh.sh

source $HOME/.exports
source $HOME/.alias