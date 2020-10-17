#!/bin/bash

cd "$(dirname "$0")"

info() {
  echo "$@"
}

warn() {
  echo "$(tput setaf 1)$@$(tput sgr0)"
}

install() {
  local src="$(pwd)/$1"
  local dst=${2:-"$HOME/$1"}
  info "linking $src to $dst"
  ln -sf $src $dst
}

warn "Linking files"

install config.fish ~/.config/fish/config.fish
install fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
install .gitconfig
install .vimrc
