#!/usr/bin/bash
# ~/.bashrc
# shellcheck disable=SC1091,SC1090

# bash-jump starter folder
export BASH_JUMP="G:\\Code"

# run cowsay with random quote at start
# bash "cowsay.sh"

# aliases
alias desktop="cd '~\Desktop'"
alias np++="start notepad++"

#git bash prompt env variables to show
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto verbose"

# https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Git-in-Bash
# export PS1='\w$(__git_ps1 " (%s)")\$ '

# put functions to enviroment
source ~/functions.sh
