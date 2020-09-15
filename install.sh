#!/usr/bin/env bash

#for file in $(find ./Git-Bash -type f -exec basename {} "$_" ';')
for file in $(find ./Git-Bash -type f)
do
  filename=$(basename "$file")
  echo $filename
  # cp --interactive "$file" "$HOME/$filename"                   #
done

echo Restarting bash
# exec bash
echo Restarted bash
