# ~/.bashrc

export BASH_JUMP="G:\\Code"

# bash "cowsay.sh"

alias codedir="cd G:\Code"
alias desktop="cd '~\Desktop'"
alias np++="start notepad++"

#git bash prompt env variables to show
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUPSTREAM="auto verbose"


# export PS1='\w$(__git_ps1 " (%s)")\$ '


# changing directory to code project
function cdir {
	echo $@;
	cd "G:\Code\\$1";
}
