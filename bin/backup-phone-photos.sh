#!/usr/bin/env bash
#shellcheck disable=
#
# use last_update.log to compare time & copy newer files from phone

bc_dir="/g/Aza/Phone/backup"
temp_dir="./temp"
last_update_log="$bc_dir/last_update.log"
declare -a folders=(DCIM Download Pictures) # folders to copy files from

# adb not in path, run here & clean up old junk
cd ~/.android/platform-tools/ || {
  echo 'no adb in ~/.android/platform-tools/'
  exit 1
}
rm -rf "$temp_dir" && mkdir "$temp_dir"

# connect to phone or fail straight up
IFS=' : ' read -ra gateway < <(ipconfig | tail -1)
int_ip=${gateway[-1]}
phone_ip=${int_ip%.*}.3
cmd.exe /c "adb connect $phone_ip:5555" || exit 1

if [[ ! -e $last_update_log ]]; then
  echo -e "\n$last_update_log missing... creating it & setting mtime '6 months ago'"
  touch -d "6 months ago" "$last_update_log"
fi

echo -e "\n>>> $(basename "$last_update_log") mtime - $(stat -c %y "$last_update_log" | cut -d'.' -f1)\n"

for folder in "${folders[@]}"; do
  # adb doesnt work straight from script in git-bash
  # -a preserve timestamps, creates folders to temp_dir
  cmd.exe /c "adb pull -a /sdcard/$folder $temp_dir/${folder#*/}" || exit 1

  files_to_copy=()
  while IFS= read -r -d $'\0'; do
    files_to_copy+=("$REPLY")
  done < <(find "$temp_dir" -type f -not -path "*thumbnail*" -newer "$last_update_log" -print0)

  counter=0
  for file in "${files_to_copy[@]}"; do
    if [[ ! -e "$bc_dir/$(basename "$file")" ]]; then
      cp -np "$file" "$bc_dir/$(basename "$file")"
      ((counter += 1))
    fi
  done

  echo -e "\n$counter files copied to $bc_dir..."
  echo -e "-------------------------------------\n"

done

rm -rf "$temp_dir" &&
  echo "Removed ~/.android/platform-tools/temp folder" ||
  echo "Couldn't remove ~/.android/platform-tools/temp folder"

echo -e "\n>>> $(basename "$last_update_log") mtime now at - $(date +'%F %T')" | tee -a "$last_update_log"

