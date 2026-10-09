#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155

source ./utils/logging.sh
echo ''

home_files=$(find ./HOME -type f)
bin_files=$(find ./bin -type f)
hook_files=$(find ./git-hooks -type f)
config_files=$(find ./config -type f)
config_dirs=$(find ./config -type d)

backup_old_dotfiles() {
    local olddir=~/backup/dotfiles
    log_info "Creating $olddir for backup of any existing dotfiles in ~ ..."
    mkdir -p $olddir
    log_info "Moving any existing dotfiles from ~ to $olddir"
    for file in $home_files; do
        if [[ -e ~/$(basename "$file") ]]; then
            mv -iv ~/"$(basename "$file")" "$olddir"
        fi
    done
    log_success "${FUNCNAME[@]}"
}

cleanup_broken_symlinks() {
    log_info "Cleaning broken symlinks in ~/bin..."
    for file in ~/bin/* /home/fraasi/*; do
        if [[ ! -e $file ]]; then
            rm -iv "$file"
        fi
    done
    log_success "${FUNCNAME[@]}"
}

make_symlinks() {
    log_info "Creating symlinks..."

    # make sure ~/bin & ~/hooks exists
    mkdir ~/bin ~/hooks >/dev/null 2>&1

    for file in $bin_files $home_files $hook_files; do
        local filename=$(basename "$file")
        local link_exists=$(find ~/ ~/bin/ ~/hooks -maxdepth 1 -type l -name "$filename")
        if [[ -z $link_exists ]]; then # no link, make it
            local real_path=$(realpath "$file")
            case "$file" in
            *bin*)
                ln -siv "$real_path" ~/bin/"$filename"
                ;;
            *HOME*)
                ln -siv "$real_path" ~/"$filename"
                ;;
            *hooks*)
                ln -siv "$real_path" ~/hooks/"$filename"
                ;;
            esac
        fi
    done

    mkdir -p ~/.config/{keyd,mpv{,/scripts,/script-opts}}
    for file in $config_files; do
      local real_path=$(realpath "$file")
      # remove leading './' from path
      relative_path="${file#./config}"
      # expand ~ to full path
      dest_expanded="$HOME/.config/$relative_path"

      ln -siv "$real_path" "$dest_expanded"
    done
    log_success "${FUNCNAME[@]}"
}

link_vimrc_dir() {
	log_info "Symlinking dotfiles/.vim folder to ~"
	if [[ -d ~/.vim ]]; then
		read -p "~/.vim already exists, overwrite? " -n 1 -r
		echo    # (optional) move to a new line
		if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    			[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
		fi
	fi
	ln -s /home/fraasi/dotfiles/.vim /home/fraasi/.vim
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

symlink_mpv_files() {

  log_info "Moving files to ~/.config/mpv/..."
  if [[ ! $PWD =~ 'dotfiles' ]]; then
    log_info "make sure you run this from ~/dotfiles... exiting"
    return
  fi
  log_info "creating folders..."
  mkdir -p ~/.config/mpv/script{s,-opts}

  {
    cd "$HOME/dotfiles/config/mpv" || return

    find . -type f | while read -r file; do
    local real_path
    real_path=$(realpath "$file")
    # remove leading './' from path
    relative_path="${file#./}"
    # expand ~ to full path
    dest_expanded="$HOME/.config/mpv/$relative_path"

    ln -sivT "$real_path" "$dest_expanded" 
    done
  }
  log_success "${FUNCNAME[*]}"
}

choices='exit setup_gitconfig make_symlinks cleanup_broken_symlinks backup_old_dotfiles link_vimrc_dir symlink_mpv_files'
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
    6) ("$choise") ;;
    7) ("$choise") ;;
    esac
done
