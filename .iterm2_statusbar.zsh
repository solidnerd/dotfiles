#!/bin/zsh
source $HOME/.iterm2_shell_integration.zsh


iterm2_print_user_vars() {
    iterm2_set_user_var awsProfile $AWS_PROFILE

    KUBECONTEXT=$(CTX=$(kubectl config current-context) 2> /dev/null;if [ $? -eq 0 ]; then echo $CTX;fi)
    iterm2_set_user_var kubeContext $KUBECONTEXT
}

