#!/usr/bin/bash

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
copy-all-to-all() {
  # ask if sure to run in this folder
  read -pr "Are you sure? (don't do it in a large folder/root) (y/n)" ANSWER
  case ${ANSWER:0:1} in
    y|Y )
        echo "Copying all files to ./All_Files..."; exit 0 ;;
    * )
        echo "Canceling..."; exit 1 ;;
  esac

  # test if folder already exist, if not make one
  [ ! -d ./All_Files ] && mkdir ./All_Files

  # find all files type of f, execute copy
  # The '{}' and ";" executes the copy on each file.
  find ./ -type f -exec cp -prv {} './All_Files' ';'
}


# print files in folders in a tree
print-tree() {
  if [ "$1" = "--write" ]; then
    find . | sed -e 's/:$//' -e 's/[^-][^\/]*\// /g' -e 's/^/ /' > Tree_listing-"$(date +'%Y_%m_%d')".txt
    echo "Tree written to file Tree_listing-$(date +'%Y_%m_%d').txt"
  else
    find . | sed -e 's/:$//' -e 's/[^-][^\/]*\// /g' -e 's/^/ /'
	fi
}
