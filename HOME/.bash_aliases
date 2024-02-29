#!/usr/bin/env bash

alias ..="cd .."
alias df="df -h /d /c"
alias dot='ls .[a-zA-Z0-9_]*'
alias e="echo"
alias g="goto"
alias grep="grep --color=auto"
alias la="ls -FA"
alias ld="ls -lhd */"   # List in long format, only directories
alias lf="ls -lhA --color=always | grep --color=always -v /"  # List in long format, only files
alias lh="ls -d .*" # Show hidden files/directories only
alias li="ls -1AX "
alias ll="ls -lXhA"
alias ls="ls -F --color=auto"
alias mv="mv -iv"
alias n="notes"
alias np="node -p"
alias np++="/c/Program\ Files/Notepad++/notepad++.exe"
alias perp="explorer.exe https://www.perplexity.ai/"
alias python="$(which python3)"
# -b[rief], -d[ictionary]
alias trans="trans -t fi -b -j -no-pager"
# trans -t fi or :fi target lang, -v[iew] use pager, -j[oin-sentence]  Treat all arguments as one single sentence, -no-ansi fixes pager
alias transl="trans -t fi -v -j -no-ansi"
