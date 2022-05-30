#!/usr/bin/bash
# shellcheck disable=SC2012,SC2010

# Changing directory to Code/
function cdir() {
  echo "$@"
  cd "G:\Code\\$1" || exit
}

# Open PDTapp project
function pdtapp() {
  cd /g/Code/GitHub/PDTapp/ || exit
  code .
  npm start
}

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
  curl -s ifconfig.me
}

# show filecount total size
function dir-size() {
  echo "$(ls -1ah | wc -l) files, $(ls -lah | grep -m 1 total | sed 's/total //')b"
}

function showHiddenFilesAndFoldersOnly() {
  ls -Ap | grep "^\."
}

# open man website for $1
function man() {
  if [[ -z $1 ]]; then
    echo "Usage: man [-w] <bash command>"
  elif [[ $1 == '-w' ]]; then
    start "https://ss64.com/bash/$2.html"
  elif ( builtin "$1" >/dev/null 2>&1 ); then
    help $1 | less
  elif ( "$1" --help >/dev/null 2>&1 ); then
    "$1" --help | less
  else
    start "https://ss64.com/bash/$1.html"
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
