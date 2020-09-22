#!/usr/bin/bash
# shellcheck disable=SC2044,SC2059

echo ''

info() {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n\n"
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_gitconfig() {
  info 'setup gitconfig, press enter to keep old ones\n'

  old_git_username=$(git config user.name)
  old_git_useremail=$(git config user.email)

  user "- New github user name? [$old_git_username]"
  read -re new_git_username
  user "- New github user email? [$old_git_useremail]"
  read -re new_git_useremail

  git config --global user.name "${new_git_username:=$old_git_username}"
  git config --global user.email "${new_git_useremail:=$old_git_useremail}"

  success 'gitconfig'
}

copy_files_to_HOME() {
  info 'copy Git-Bash/ files to  ~/\n'

  for file in $(find ./Git-Bash -type f); do
    filename=$(basename "$file")
    cp -v --interactive "$file" "$HOME/$filename"
  done
  echo ''
  success 'copy files'
}

select choise in exit setup_gitconfig copy_files_to_HOME
do
  case $REPLY in
    1) user "$choise"; break ;;
    2) ( "$choise" ) ;;
    3) ( "$choise" ) ;;
  esac
done

info "All done, run 'exec bash' to reflash current shell."
