#!/usr/bin/env bash
#shellcheck disable=2091
#
# script to backup phone photos etc. to computer with adb
# use last_update.log to compare time & copy newer files from phone

command -v adb >/dev/null 2>&1 || { printf >&2 "This script requires adb, which was not found in path. Aborting.\n"; exit 1; }
command -v nmap >/dev/null 2>&1 || { printf >&2 "This script requires nmap, which was not found in path. Aborting.\n"; exit 1; }

printf "  Just a reminder...
  connect to router wifi, turn wireless debugging on & see that computer is still paired...\n\n"

# folders to copy files from
declare -a folders=(DCIM Download Pictures)

temp_dir=$(mktemp -d --suffix="_$(basename "${0%.*}")")
bc_dir="/d/Fraasi/backups/phone/backup"
log_name="last_update.log"
log_path="$bc_dir/$log_name"
if [[ ! -e $log_path ]]; then
    printf "\n%s missing... creating it & setting mtime '6 months ago'" "$log_name"
    touch -d "6 months ago" "$log_path"
fi

if [[ -n "$1" ]]; then
    if [[ "$1" == "all" ]]; then
        printf "\nsetting last_update.log mtime '24 months ago'\n\n"
        touch -d "24 months ago" "$log_path"
    else
        printf "usage: %s [all]\n  all - backup everything newer than 24 months\n\n" "$(basename "$0")"
    fi
fi

# TODO: find unix aternative to ipconfig
# get phone ip, sort so longest grep with ip is last
IFS=' : ' read -ra gateway < <(ipconfig.exe | grep Default | sort | tail -1)
int_ip=${gateway[-1]}
phone_ip=${int_ip%.*}.3 # static 3 for my phone

# scan for the everchanging port
# port range android randomly assigns when turning debugging on
port_range='30000-47000'
port=$(nmap -p "$port_range" "$phone_ip" | grep open | cut -d'/' -f 1)
if [[ -z $port ]]; then
    printf "  could not find an open port, aborting...
  check port from phone under wireless debugging and adjust port_range variable"
    exit 1
fi

# connect to phone
adb start-server
adb connect "$phone_ip:$port"

printf "\n>>> %s mtime - %s\n" "$log_name" "$(stat -c %y "$log_path" | cut -d'.' -f1)"

for folder in "${folders[@]}"; do
    # this is where adb errors if there was no connection
    # create folders to temp_dir for checking before copying, -a preserve timestamps,
    adb pull -a "/sdcard/$folder" "$temp_dir/${folder#*/}" || {
        adb kill-server
        exit 1
    }

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
    printf "\nRemoved %s" "$temp_dir" ||
    printf "\nErr, couldn't remove %s" "$temp_dir"

printf "\n>>> %s mtime now at - %s" "$log_name" "$(date +'%F %T')" | tee -a "$log_path"

adb kill-server
