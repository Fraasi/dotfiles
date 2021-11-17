#!/usr/bin/bash
# shellcheck disable=SC2012,SC2010

# Changing directory to Code/
function cdir() {
	echo "$@";
	cd "G:\Code\\$1" || exit;
}

# Open PDTapp project
function pdtapp() {
  cd /g/Code/GitHub/PDTapp/ || exit;
  code .;
  npm start;
}

# print all color codes in color (max NUM=255), can pipe to column. https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
function print-colors() {
  NUM=${1:-15}
  for (( c=0; c<="$NUM"; c++ ))
  do
    tput setaf "$c"
    tput setaf "$c" | cat -v
    tput sgr0
    echo " #$c"
  done
}

# show my ip address
function show-ip() {
  echo
  curl -s ifconfig.me
  echo
}

# show filecount total size
function dir-size() {
  echo "$(ls -1ah | wc -l) files, $(ls -lah | grep -m 1 total | sed 's/total //')b"
}

function showHiddenFilesAndFoldersOnly() {
  ls -Ap | grep "^\."
}

# open man website for $1
function b-man() {
  if [[ -z $1 ]]; then
    echo "Usage: b-man <bash command>"
  else
    start "https://ss64.com/bash/$1.html"
  fi
}
