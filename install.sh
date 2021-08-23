#!/bin/bash

cd "$(dirname "$0")" || exit 1

info() {
  echo "$(tput setaf 6)-- $*$(tput sgr0)"
}

warn() {
  echo "$(tput setaf 3)-- $*$(tput sgr0)"
}

install() {
  local src
  src="$(pwd)/$1"
  local dst=${2:-"$HOME/$1"}
  info "linking $src -> $dst"
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

warn "linking files"

install config.fish ~/.config/fish/config.fish
install functions/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
install .gitconfig
install .vimrc
install alacritty.yml ~/.config/alacritty/alacritty.yml
install init.vim ~/.config/nvim/init.vim

if [ "$(uname)" = "Darwin" ]; then
  install lazygit_config.yml "$HOME/Library/Application Support/jesseduffield/lazygit/config.yml"
else
  install lazygit_config.yml ~/.config/jesseduffield/lazygit/config.yml
  install functions/code.py ~/bin/code.py
fi

info "downloading vim-plug for vim"
curl -fLso ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

info "downloading vim-plug for neovim"
curl -fLso "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

info "installing vim plugins"
echo "" | vim +PlugInstall +qall

info "installing neovim plugins"
echo "" | nvim +PlugInstall +qall
