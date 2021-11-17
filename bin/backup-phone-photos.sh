#!/bin/bash
#shellcheck disable=SC2012
#
# find newest file already backed up &
# compare it to phones photos & copy newer


cd ~/.android/platform-tools/ || exit 1
[[ -e ./Camera ]] && rm -rf ./Camera

# adb doesnt work from script in git-bash, creates Camera folder to .
cmd.exe /c "adb pull -a /sdcard/dcim/Camera/ ." || exit 1

bc_dir="/g/Aza/N3/Camera"
newest_backed_up_file=$(ls -rt $bc_dir | tail -1)

echo -e "\n$newest_backed_up_file - $(stat -c %y $bc_dir/"$newest_backed_up_file" | cut -d'.' -f1) <<< newest_backed_up_file"

counter=0
for phoneimg in ./Camera/*; do
  if [[ $phoneimg -nt $bc_dir/$newest_backed_up_file ]]; then
    ((counter += 1))
    echo "$(basename "$phoneimg") - $(stat -c %y "$phoneimg" | cut -d'.' -f1)"
    cp -np "$phoneimg" "$bc_dir"/"$(basename "$phoneimg")"
  fi
done

echo -e "\n$counter new images copied to $bc_dir"
rm -rf ./Camera \
  && echo "Removed ~/.android/platform-tools/Camera temp folder" \
  || echo "Couldn't remove ~/.android/platform-tools/Camera temp folder"
