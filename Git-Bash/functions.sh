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
  read -rp "Are you sure? (don't do it in a large folder/root) (Y/n) " ANSWER
  case ${ANSWER:0:1} in
    Y )
        echo "Copying all files to ./All_Files..."
        # test if folder already exist, if not make one
        [ ! -d ./All_Files ] && mkdir ./All_Files

        # The '{}' and ";" executes the copy on each file.
        # FIXME: tries to copy already copied files from All-Files to All-Files
        find ./ -type f -exec cp -pr {} './All_Files' ';' 2> /dev/null
        echo "done."
        ;;
    * )
        echo "Canceling...";;
  esac
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
