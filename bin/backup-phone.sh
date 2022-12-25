#!/usr/bin/env bash
#shellcheck disable=2091
#
# script to backup phone photos etc. to computer with adb
# use last_update.log to compare time & copy newer files from phone

# folders to copy files from
declare -a folders=(DCIM Download Pictures)

# adb doesnt work well with wsl, run from windows side
adb="/c/Program Files/platform-tools/adb.exe"

temp_dir=$(mktemp -d --suffix="_$(basename "${0%.*}")")
bc_dir="/d/Aza/Phone/backup"
log_name="last_update.log"
log_path="$bc_dir/$log_name"

if [[ -n "$1" ]]; then
  if [[ "$1" == "all" ]]; then
    printf "\nsetting last_update.log mtime '24 months ago'\n\n"
    touch -d "24 months ago" "$log_path"
  else
    printf "usage: %s [all]\n  all - backup everything newer than 24 months\n\n" "$(basename "$0")"
  fi
fi

# start server in a subshell, otherwise hangs wsl forever
$("$adb" start-server)
# connect to phone or fail straight up
IFS=' : ' read -ra gateway < <(ipconfig.exe | tail -1)
int_ip=${gateway[-1]}
phone_ip=${int_ip%.*}.3 # dont forget 3
"$adb" connect "$phone_ip:5555" || exit 1

if [[ ! -e $log_path ]]; then
  printf "\n%s missing... creating it & setting mtime '6 months ago'" "$log_name"
  touch -d "6 months ago" "$log_path"
fi

printf "\n>>> %s mtime - %s\n" "$log_name" "$(stat -c %y "$log_path" | cut -d'.' -f1)"

for folder in "${folders[@]}"; do
  # -a preserve timestamps, create folders to temp_dir for checking before copying
  "$adb" pull -a "/sdcard/$folder" "$temp_dir/${folder#*/}" || exit 1

  files_to_copy=()
  while IFS= read -r -d $'\0'; do
    files_to_copy+=("$REPLY")
  done < <(find "$temp_dir" -type f -not -path "*thumbnail*" -newer "$log_path" -print0)

  counter=0
  for file in "${files_to_copy[@]}"; do
    if [[ ! -e "$bc_dir/$(basename "$file")" ]]; then
      cp -np "$file" "$bc_dir/$(basename "$file")"
      ((counter += 1))
    fi
  done

  printf "\n%d files copied to %s..." "$counter" "$bc_dir"
  printf "\n-------------------------------------\n"

done

rm -rf "$temp_dir" &&
  echo "Removed $temp_dir" ||
  echo "Err, couldn't remove $temp_dir"

printf "\n>>> %s mtime now at - %s" "$log_name" "$(date +'%F %T')" | tee -a "$log_path"

# "$adb" kill-server
