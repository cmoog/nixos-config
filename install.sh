#!/bin/bash

cd "$(dirname "$0")"

info() {
  echo "-- $@"
}

warn() {
  echo "$(tput setaf 1)-- $@$(tput sgr0)"
}

install() {
  local src="$(pwd)/$1"
  local dst=${2:-"$HOME/$1"}
  info "linking $src to $dst"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
}

gitstall() {
  if [ -d "$2" ]; then
    rm -rf "$2"
  fi
  git clone "$1" "$2"
  info "cloning $1 to $2"
}

warn "Linking files"

install config.fish ~/.config/fish/config.fish
install fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
install dev_instance.fish ~/.config/fish/functions/dev.fish
install .gitconfig
install .vimrc

if [ "$(uname)" = "Darwin" ]; then
  install lazygit_config.yml "$HOME/Library/Application Support/jesseduffield/lazygit/config.yml"
else
  install lazygit_config.yml ~/.config/jesseduffield/lazygit/config.yml
fi

gitstall https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

info "Installing vim plugins"
vim +PluginInstall +qall
