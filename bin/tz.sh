#!/usr/bin/bash

timezone=$(timedatectl list-timezones | fzf)
curl -s --location "https://script.google.com/macros/s/AKfycbyd5AcbAnWi2Yn0xhFRbyzS4qMq1VucMVgVvhul5XqS9HkAyJY/exec?tz=$timezone" | jq -j '.timezone + " " + .fulldate'
