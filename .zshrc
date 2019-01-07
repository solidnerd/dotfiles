# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export TERM=xterm-256color
ZSH_TMUX_AUTOSTART='true'

ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(rvm go_version aws kubecontext)

#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(rvm go_version aws)

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

plugins=(brew zsh-autosuggestions kubectl aws)

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
# Add doctl
source <(doctl completion zsh)

[ -f ~/.ktx-completion.sh ] && source "${HOME}"/.ktx-completion.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source <(hcloud completion zsh)
