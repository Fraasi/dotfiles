#!/usr/bin/bash
# ~/.bashrc
# shellcheck disable=SC1091,SC1090

# set EDITOR to vim
export EDITOR=vim

# bash-jump starter folder
export BASH_JUMP="G:\\Code"

# cd lookup paths, in case of trouble unset: https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/
CDPATH=".:$HOME:$HOME/Desktop:/g/Code/"

# run cowsay with random quote at start
# bash "cowsay.sh"

# aliases
alias ..="cd .."
alias desktop="cd ~/Desktop/"
alias df="df -h"
alias e="echo"
alias grep="grep --color=auto"
alias g="goto"
alias gt="goto"
alias li="ls -1AX --color=auto"
alias ll="ls -lX --color=auto"
alias ls="ls -F --color=auto"
alias mv="mv -iv"
# alias node="winpty node.exe"
alias np++="start notepad++"
alias tree="tree.com //a"

#git bash prompt env variables to show
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto verbose"

# https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Git-in-Bash
# export PS1='\w$(__git_ps1 " (%s)")\$ '

# put functions to environment
source ~/functions.sh

# put goto to environment
if [[ -f ~/goto.sh ]]; then
  source ~/goto.sh
else
  echo 'goto.sh not found in ~'
  echo 'https://github.com/iridakos/goto'
fi

# don't put duplicate lines in the history
# don't save commands which start with a space
export HISTCONTROL=ignoredups:erasedups:ignorespace

# ls colors / https://www.howtogeek.com/307899/how-to-change-the-colors-of-directories-and-files-in-the-ls-command/
# Normal Text: 0
# Bold or Light Text: 1 (It depends on the terminal emulator.)
# Dim Text: 2
# Underlined Text: 4
# Blinking Text: 5 (This does not work in most terminal emulators.)
# Reversed Text: 7 (This inverts the foreground and background colors, so you’ll see black text on a white background if the current text is white text on a black background.)
# Hidden Text: 8
LS_COLORS='rs=0:di=01;36:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'
export LS_COLORS

# fzf configuration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export FZF_ALT_C_OPTS="--preview 'tree.com //a {} | head -100'"
export FZF_DEFAULT_OPTS="
  --height 90% --multi --layout reverse --border --info inline
  --bind 'ctrl-j:preview-page-down,ctrl-k:preview-page-up'
  --no-mouse
"

# https://bluz71.github.io/2018/11/26/fuzzy-finding-in-bash-with-fzf.html
fzf_find_edit() {
    local file=$(
      fzf --query="$1" --no-multi --select-1 --exit-0 \
          --preview 'bat --color=always --line-range :500 {}'
      )
    if [[ -n $file ]]; then
        $EDITOR "$file"
    fi
}

# needs 'git config --global alias.ll 'log --graph --format="%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'
fzf_git_log() {
    local selections=$(
      git ll --color=always "$@" |
        fzf --ansi --no-sort --no-height \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if [[ -n $selections ]]; then
        local commits=$(echo "$selections" | sed 's/^[* |]*//' | cut -d' ' -f1 | tr '\n' ' ')
        # do not quote this, unquoted is needed here to work
        git show $commits
    fi
}

alias f="fzf"
alias fp="fzf \
	--color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' \
	--preview 'bat --style=numbers --color=always --line-range :300 {}'
"
alias ffe='fzf_find_edit'
alias fgl='fzf_git_log'
