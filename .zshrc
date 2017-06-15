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


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# docker-compose aliases
alias dcd="docker-compose down"
alias dcup="docker-compose up"
alias dcupd="docker-compose up -d"
alias dcl="docker-compose logs"
alias dclf="docker-compose logs -f"
alias dcs="docker-compose stop"
alias dcrm="docker-compose rm"

# docker-machine aliases
alias dm="docker-machine"
