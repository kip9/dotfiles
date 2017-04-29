#!/usr/bin/env bash
export DOTFILES_LOCATION=~/.dotfiles
backup_dir=$DOTFILES_LOCATION/backups/$(date "+%Y_%m_%d-%H_%M_%S")/

function print_info() {
  echo "$1"
}

function link_file() {
  print_info "Linking $1"
  ln -sf ${1#$HOME/} ~/
}

function process_files() {
  local filename destination
  local files=($DOTFILES_LOCATION/links/*)
  if (( ${#files[@]} == 0 )); then return; fi
  for file in "${files[@]}"; do
    filename="$(basename $file)"
    destination="$HOME/$filename"
    if [[ -e "$destination" ]]; then
      if [[ "$file" -ef "$destination" ]] ; then
        print_info "$file already exists, skipping"
        continue
      fi
      print_info "Making backup of $destination"
      [[ -e "$backup_dir" ]] || mkdir -p "$backup_dir"
      # Backup file / link / whatever.
      mv "$destination" "$backup_dir"
    fi
    link_file "$file"
  done
}

# Main code

while true; do sudo -n true; sleep 10; kill -0 "$$" || exit; done 2>/dev/null &

shopt -s dotglob
shopt -s nullglob

process_files
