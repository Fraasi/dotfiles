#!/bin/bash
#shellcheck disable=SC2012
#
# find newest file already backed up &
# compare it to phones photos & copy newer
#
# TODO: find better way to copy/sync files


# adb not in path, run here
cd ~/.android/platform-tools/ || exit 1
rm -rf ./temp && mkdir ./temp

declare -a folders=(dcim/Camera Download Pictures)

for folder in "${folders[@]}"; do
  # adb doesnt work straight from script in git-bash
  # -a preserve timestamps, creates folders to ./temp
  cmd.exe /c "adb pull -a /sdcard/$folder ./temp/${folder#*/}" || exit 1

  temp_dir="./temp/$folder"
  bc_dir="/g/Aza/N3/${folder#*/}"
  [[ ! -e "$bc_dir" ]] && mkdir "$bc_dir"
  newest_backed_up_file=$(ls -rt "$bc_dir" | tail -1)
  if [[ -z $newest_backed_up_file ]]; then
    newest_backed_up_file=$(ls -rt "$temp_dir" | head -1)
    echo -e "\nno files in $bc_dir, using $temp_dir/$newest_backed_up_file"
    use_temp_dir=true
  fi

  check_file="$bc_dir/$newest_backed_up_file"
  if [[ $use_temp_dir ]]; then
    check_file="$temp_dir/$newest_backed_up_file"
  fi
  echo -e "\n$newest_backed_up_file - $(stat -c %y "$check_file" | cut -d'.' -f1) <<< newest_backed_up_file"

  counter=0
  for file in "$temp_dir"/*; do
    if [[ $file -nt $check_file ]]; then
      ((counter += 1))
      echo "$(basename "$file") - $(stat -c %y "$file" | cut -d'.' -f1)"
      cp -np --recursive "$file" "$bc_dir"/"$(basename "$file")"
    fi
  done
  echo -e "\n$counter new files copied to $bc_dir"
  echo -e "------------------------------------\n"

done

rm -rf ./temp \
  && echo "Removed ~/.android/platform-tools/temp folder" \
  || echo "Couldn't remove ~/.android/platform-tools/temp folder"
