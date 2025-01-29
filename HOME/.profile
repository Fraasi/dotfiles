#!/usr/bin/env bash
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022
# shellcheck disable=SC1090,SC2012,SC2010,2034,1091

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

#git bash prompt env variables to show
# needs completion
# curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
# echo 'source ~/.git-prompt.sh' >> ~/.bashrc

export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto verbose"
# https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Git-in-Bash
# export PS1='\w$(__git_ps1 " (%s)")\$ '

TITLEPREFIX=''
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
PS1="$PS1"'\n'                         # new line
PS1="$PS1"'\[\033[35m\]'               # change to purple
PS1="$PS1"'[\t] '                      # show time in 24 hour
# PS1="$PS1""($(ls -1ah | wc -l) files, $(ls -lah | grep -m 1 total | sed 's/total //')b)\n" # filecount
PS1="$PS1"'\[\033[32m\]' # change to green
PS1="$PS1"'\u@\h '       # user@host<space>
# PS1="$PS1"'\[\033[35m\]'       # change to purple
# PS1="$PS1"'$MSYSTEM '          # show MSYSTEM
PS1="$PS1"'\[\033[33m\]' # change to brownish yellow
PS1="$PS1"'\w'           # current working directory

# git completions
if test -f /usr/share/bash-completion/completions/git; then
    source /usr/share/bash-completion/completions/git
fi
PS1="$PS1"'\[\033[36m\]' # change color to cyan
PS1="$PS1"'`__git_ps1`'  # add git repo info

PS1="$PS1"'\n'                               # new line
PS1="$PS1""\[\033[90m\][\${PIPESTATUS[-1]}]" # exit status of last executed foreground pipeline
PS1="$PS1""\[\033[0m\]--> "                  # reset color & prompt sign

# Evaluate all user-specific Bash completion scripts (if any)
for c in "$HOME"/bash_completion.d/*.bash; do
    # Handle absence of any scripts (or the folder) gracefully
    test ! -f "$c" ||
        . "$c"
done
if test -f "$HOME/.cargo/env"; then
    source "$HOME/.cargo/env"
fi

