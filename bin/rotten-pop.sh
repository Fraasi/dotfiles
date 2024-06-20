#!/usr/bin/env bash

IFS=$'\n\t'
for i in $(curl -s https://www.rottentomatoes.com/browse/movies_at_home/sort:popular | htmlq -tw '[data-qa="discovery-media-list-item-title"]' | tr -s '\n' | sed 's/^[[:space:]]*//' ); do
  if [[ -n "$i" ]]; then
    printf "%-35s - https://www.imdb.com/find/?q=%s \n" "$i" "$( echo "$i" | jq -Rr @uri )"
  fi
done
