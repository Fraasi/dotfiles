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

# Copy all files from subdirs to ./All-Files/
function copy-all-to-all() {
  read -rp "Are you sure? (don't do it in a large folder/root) (Y/n) " ANSWER
  case ${ANSWER:0:1} in
    Y )
        # test if folder already exist, if not make one
        if [ ! -d ./All_Files ]; then
          mkdir ./All_Files
          echo 'No folder, created ./All_Files'
        else
          echo 'Folder already exist, canceling...'
          return 1
        fi

        echo 'Copying ´./ -type f´ to ./All_Files...'
        # The '{}' and ";" executes the copy on each file.
        find ./ -type f -exec cp -pr {} './All_Files' ';' 2> /dev/null
        echo 'Done, files copied.'
        ;;
    * )
        echo 'Canceling...';;
  esac
}


# print files in folders in a tree
function print-tree() {
  if [ "$1" = "--write" ]; then
    find . -not -path './node_modules/*' -not -path './.git/*' | sed -e 's/:$//' -e 's/[^-][^\/]*\// /g' -e 's/^/ /' > Tree_listing-"$(date +'%Y_%m_%d')".txt
    echo "Tree written to file Tree_listing-$(date +'%Y_%m_%d').txt"
  else
    find . -not -path './node_modules/*' -not -path './.git/*' | sed -e 's/:$//' -e 's/[^-][^\/]*\// /g' -e 's/^/ /'
	fi
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
  curl ifconfig.me
}

# show filecount total size
function dir-size() {
  echo "$(ls -1ah | wc -l) files, $(ls -lah | grep -m 1 total | sed 's/total //')b"
}

function showHiddenFilesAndFoldersOnly() {
  ls -Ap | grep "^\."
}
