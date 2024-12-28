#!/usr/bin/env bash

dest="/home/fraasi/dotfiles/configs/mpv/"

cp -uv /c/Users/fraasi/AppData/Roaming/mpv/input.conf "$dest"
cp -uv /c/Users/fraasi/AppData/Roaming/mpv/mpv.conf "$dest"

cp -uv /c/Users/fraasi/AppData/Roaming/mpv/script-opts/uosc.conf "$dest"script-opts/
cp -uv /c/Users/fraasi/AppData/Roaming/mpv/script-opts/console.conf "$dest"script-opts/
cp -uv /c/Users/fraasi/AppData/Roaming/mpv/script-opts/stats.conf "$dest"script-opts/

cp -uv /c/Users/fraasi/AppData/Roaming/mpv/scripts/copyto_clipboard.lua "$dest"scripts/
cp -uv /c/Users/fraasi/AppData/Roaming/mpv/scripts/single_instance.lua "$dest"scripts/

