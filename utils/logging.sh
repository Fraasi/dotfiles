#!/bin/bash
# shellcheck disable=SC2059,SC1091

source ./utils/colors.sh  # relative to install.sh, 'root' script


log_info() {
  printf "\r  [ $CYAN!!$RESTORE ] $1\n"
}

log_user() {
  printf "\r  [ $YELLOW??$RESTORE ] $1\n"
}

log_success() {
  printf "\r  [ ${GREEN}OK$RESTORE ] $1\n\n"
}

log_fail() {
  printf "\r\033[2K  [ ${RED}FAIL$RESTORE ] $1\n"
  echo ''
  exit
}
