#!/bin/bash
# shellcheck disable=SC2044,SC1091

source ./utils/logging.sh
echo ''


setup_gitconfig() {
  log_info 'setup gitconfig, press enter to keep old ones\n'

  old_git_username=$(git config --global user.name)
  old_git_useremail=$(git config --global user.email)

  log_user "- New github user name? [$old_git_username]"
  read -re new_git_username
  log_user "- New github user email? [$old_git_useremail]"
  read -re new_git_useremail

  git config --global user.name "${new_git_username:=$old_git_username}"
  git config --global user.email "${new_git_useremail:=$old_git_useremail}"

  log_success "${FUNCNAME[@]}"
}

copy_HOME_to_HOME() {
  echo ''
  log_info 'copy HOME/ files to ~/'
  log_info 'copying .gitconfig will reset your [user] field\n'

  for file in $(find ./HOME -type f); do
    filename=$(basename "$file")
    cp -v --interactive "$file" "$HOME/$filename"
  done

  echo ''
  log_success "${FUNCNAME[@]}"
}

copy_bin_to_HOME_bin() {
  echo ''
  log_info 'copy bin/ files to ~/bin to put them in PATH\n'

  if ! [[ -e ~/bin && -d ~/bin ]]; then
    log_info 'No ~/bin folder, creating one...'
    echo ''
    mkdir ~/bin
  fi

  for file in $(find ./bin -type f); do
    filename=$(basename "$file")
    if cmp "$file" "$HOME/bin/$filename" &>/dev/null; then
      echo "$filename hasn't changed, skipping..."
    else
      cp -v --interactive "$file" "$HOME/bin/$filename"
    fi
  done
  echo ''
  log_success "${FUNCNAME[@]}"
}

choices='exit setup_gitconfig copy_HOME_to_HOME copy_bin_to_HOME_bin'

select choise in ${choices}; do
  case $REPLY in
    1)
      log_user "$choise"
      break
      ;;
    2) ("$choise") ;;
    3) ("$choise") ;;
    4) ("$choise") ;;
  esac
done

log_info "All done, run 'exec bash' to update shell PATH & functions."
log_info "Or 'source ~/.profile' to reflash current prompt."
