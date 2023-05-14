#!/usr/bin/env bash
# shellcheck disable=SC2012,SC2010

# print all color codes in color (max NUM=255), can pipe to column. https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
function print-colors() {
    NUM=${1:-15}
    for ((c = 0; c <= "$NUM"; c++)); do
        tput setaf "$c"
        tput setaf "$c" | cat -v
        tput sgr0
        echo " #$c"
    done
}

# show my ip address
function show-ip() {
    # curl -s ifconfig.me
    dig +short myip.opendns.com @resolver1.opendns.com
}

# show filecount total size
function dir-size() {
    echo "$(ls -1ah | wc -l) files, $(ls -lah | grep -m 1 total | sed 's/total //')b"
}

function showHiddenFilesAndFoldersOnly() {
    ls -Ap | grep "^\."
}

# open man website for $1
function win-man() {
    if [[ -z $1 ]]; then
        echo "Usage: man [-w] <bash command>"
    elif [[ $1 == '-w' ]]; then
        explorer.exe "https://ss64.com/bash/$2.html"
    elif (builtin "$1" >/dev/null 2>&1); then
        help "$1" | less
    elif ("$1" --help >/dev/null 2>&1); then
        "$1" --help | less
    else
        explorer.exe "https://ss64.com/bash/$1.html"
    fi
}

# -r: recursive and download all links on page
# -l1: only one level link
# -H: span host, visit other hosts
# -t1: numbers of retries
# -nd: don't make new directories, download to here
# -N: turn on timestamp
# -np: no parent
# -A: type (separate by ,)
# -e robots=off: ignore the robots.txt file which stop wget from crashing the site, sorry example.com
# -nv --no-verbose
function wget-images() {
    if [[ -z $1 ]]; then
        echo "Usage: wget-images <url>"
    else
        wget -r -l1 -H -t1 -nd -N -np -nv -e robots=off -P /g/Downs/wget/ -A jpeg,jpg,bmp,gif,png,webp "$1"
    fi
}

# fetch britannica historic event of the day
function on-this-day() {
    if [[ "$1" == '--month' ]]; then
        month="$(date +'%B')"
        day_count=$(date -d "$(date +%Y%m01) +1 month -1 day" +'%d')
        for day in $(seq -f '%02.f' "$day_count"); do
            html=$(curl -s https://www.britannica.com/on-this-day/"$month"-"$day")
            event=$(echo "$html" | grep "title font-18 font-weight-bold mb-10" | cut -d ">" -f2 | cut -d "<" -f1)
            echo "The event on $month $day is $event"
        done
    else
        month="$(date +'%B')"
        day="$(date +'%d')"
        html=$(curl -s https://www.britannica.com/on-this-day/"$month"-"$day")
        event=$(echo "$html" | grep "title font-18 font-weight-bold mb-10" | cut -d ">" -f2 | cut -d "<" -f1)
        echo "$month $day - $event"
    fi
}

# list & count different filetypes in .
function filetypes-in-dir() {
    file -bi ./* | sort | uniq -c | cut -d';' -f1
}

# encrypt file passed to func
function encrypt-file() {
    extension="${1##*.}"
    filename="${1%.*}"
    SAVE_FILE="${filename}_$(date '+%F').$extension.gpg"
    gpg -iv --symmetric --no-symkey-cache -o "$SAVE_FILE" "$1"
}

# https://superuser.com/questions/144772/finding-the-definition-of-a-bash-function
function whereisfunc() {
    shopt -s extdebug
    declare -F "$1"
    shopt -u extdebug
}

# print date & time for use in logging
function log-datetime() {
    if [[ -z "$1" ]]; then
        date "+%F %T"
    else
        case "$1" in
        -t)
            date "+%T"
            ;;
        -d)
            date "+%F"
            ;;
        *)
            printf "Usage: %s [-t | -d]
  Display the current date & time in Y-m-d H:M:S format

  -t  print only time
  -d  print only date" "${FUNCNAME[0]}"
            ;;
        esac
    fi
}

# https://github.com/mathiasbynens/dotfiles/blob/master/.functions
# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# better du
# du-xh <directory> [max-depth]
function du-xh() {
    du -xh --max-depth="${2:-1}" "$1"
}

# https://github.com/stuartleeks/wsl-notify-send
function notify-send() {
    wsl-notify-send.exe --category "$WSL_DISTRO_NAME" "${@}"
}

function wacl() {
    command wac "$@" | less -R
}

function wacp() {
    command wac "$@" | column -t -s'|' | less -R
}

function f-rq() {
    uri_encoded="$( jq -rn --arg uri "$*" '$uri | @uri' )"
    curl -s https:/f-rq.cyclic.app/"$uri_encoded"
}
