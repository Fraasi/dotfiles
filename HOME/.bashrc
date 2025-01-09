#!/usr/bin/env bash

# export LANGUAGE=en_UKB # fixes vims C$C6 problem, kind of...

# ~/.bashrc: executed by bash(1) for non-login shells.
# shellcheck disable=SC1091,SC1090,SC2155

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# When running commands like cat dirname/test, have the shell fix minor typos
shopt -s dirspell
# Allow us to use Ctrl+S[ito perform forward search, by disabling the start and
# stop output control signals, which are not needed on modern systems.
stty -ixon

bind '"\e[6~": menu-complete' # Pg Dn to select the first completion or change to the next one.
bind '"\e[5~": menu-complete-backward' # Pg Up to select the last completion or change to the previous one.
bind '"\eh": history-expand-line' # change M-^ to M-h to expand history line

# cd lookup paths, in case of trouble unset: https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/
# CDPATH=".:$HOME:$HOME/Desktop:/g/Code/"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# set EDITOR to vim
export EDITOR=vim

export SOAPER_DOWNLOAD_PATH=/d/Videos

# run cowsay with random quote at start
# cowmoo

# .bash_{aliases,functions}
if [ -f ~/.bash_aliases ]; then
    source  ~/.bash_aliases
fi
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi

# goto
if [[ -f /usr/local/bin/goto.sh ]]; then
    source /usr/local/bin/goto.sh
else
    echo 'goto.sh not found'
    echo 'https://github.com/iridakos/goto'
fi


# don't put duplicate lines in the history
# don't save commands which start with a space
export HISTCONTROL=ignoredups:erasedups:ignorespace
# append to history
shopt -s histappend
# increase history size
export HISTSIZE=1000
export HISTFILESIZE=2000

# colorize man pages
export MANPAGER="less -R --use-color -Dd+r -Du+b"
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"


# fzf
[ -f ~/.fzfrc ] && source ~/.fzfrc
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# notes
# completion for n alias, _notes is the completion function name
# for some reason, needs to run notes <completion> before working with alias n
complete -F _notes n
