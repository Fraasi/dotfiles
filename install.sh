#!/bin/env bash
# shellcheck disable=SC1091,SC2155

source ./utils/logging.sh
echo ''

home_files=$(find ./HOME -type f)
bin_files=$(find ./bin -type f)

log_info "This script needs to be run as administrator for symlinking to work"

# from https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh
backup_old_dotfiles() {
  local olddir=~/dotfiles_old
  log_info "Creating $olddir for backup of any existing dotfiles in ~ ..."
  mkdir -p $olddir
  log_info "Moving any existing dotfiles from ~ to $olddir"
  for file in $home_files; do
    mv -iv ~/"$(basename "$file")" "$olddir"
  done
  log_success "${FUNCNAME[@]}"
}

cleanup_broken_symlinks() {
  log_info "Cleaning broken symlinks..."
  for file in $home_files $bin_files; do
    local real_file_path=$(find ~/ ~/bin/ -maxdepth 1 -type l -name "$(basename "$file")")
    if [[ -n $real_file_path ]] && [[ ! -e $real_file_path ]]; then
      rm -iv "$real_file_path"
    fi
  done
  log_success "${FUNCNAME[@]}"
}

make_symlinks() {
  log_info "Creating symlinks..."
  # cygpath converts posix <-> win paths
  local home_win=$(cygpath -aw "$HOME")
  local repo_win=$(cygpath -aw ./)

  for file in $bin_files $home_files; do
    local filename=$(basename "$file")
    local link_exists=$(find ~/ ~/bin/ -maxdepth 1 -type l -name "$filename")
    if [[ -z $link_exists ]]; then
      case "$file" in
      *bin*)
        cmd.exe /c "mklink $home_win\\bin\\$filename $repo_win\\bin\\$filename"
        ;;
      *HOME*)
        cmd.exe /c "mklink $home_win\\$filename $repo_win\\HOME\\$filename"
        ;;
      esac
    fi
  done
  log_success "${FUNCNAME[@]}"
}

setup_gitconfig() {
  log_info 'Setup gitconfig, press enter to keep old ones\n'

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

# TODO:
copy_vscode_settings() {
  log_info ""
  log_success "${FUNCNAME[@]}"
}

choices='exit setup_gitconfig make_symlinks cleanup_broken_symlinks backup_old_dotfiles'
select choise in ${choices}; do
  case $REPLY in
  1)
    log_user "$choise"
    log_info "All done, run 'exec bash' to update shell PATH & functions"
    log_info "Or 'source ~/.profile' to reflash current prompt"
    break
    ;;
  2) ("$choise") ;;
  3) ("$choise") ;;
  4) ("$choise") ;;
  5) ("$choise") ;;
  esac
done
