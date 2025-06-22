#!/usr/bin/env bash

if [[ -z "$*" ]]; then
  printf "Need a city name to search...\n"
  exit 1
fi

# timezone=$(timedatectl list-timezones | fzf)
# curl -s --location "https://script.google.com/macros/s/AKfycbyd5AcbAnWi2Yn0xhFRbyzS4qMq1VucMVgVvhul5XqS9HkAyJY/exec?tz=$timezone" | jq -j '.timezone + " " + .fulldate'

search=$(jq -sRr @uri <<< "$*")
json=$(curl -s -H "User-Agent: tiny_little_tz_script/1.0" \
  "https://nominatim.openstreetmap.org/search?format=json&limit=1&featureType=city&accept-language=en-en&q=$search")
if [[ $(jq '. | length' <<< "$json") == 0 ]];then
  printf "%s" "nothing found... try another search term"
  exit 0
else
  name_latlon=$(jq -j '.[] | .display_name + " " + .lat + " " + .lon' <<< "$json")
  printf "%s\n" "$name_latlon"
  lat=$(echo "$name_latlon" | rev | cut -d' ' -f2 | rev)
  lon=$(echo "$name_latlon" | rev | cut -d' ' -f1 | rev)
  curl -s "https://www.timeapi.io/api/timezone/coordinate?latitude=$lat&longitude=$lon" |\
    jq -r '
      .timeZone + " " + "\(.currentLocalTime | split(".")[0])" + " UTC" +
      if .currentUtcOffset.seconds >= 0 then "+" + "\(.currentUtcOffset.seconds / 60 / 60 )"
      else "\(.currentUtcOffset.seconds / 60 / 60)" end'
fi
