#!/usr/bin/env bash

echo "-- Setup starting"

echo "-- Setting default shell"
chsh -s $(which zsh)

echo "-- Installing zsh autosuggestions"
zsh_complete() {
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions > /dev/null
}

ls $HOME/.zsh/zsh-autosuggestions || zsh_complete

echo "-- Installing zsh pure theme"
zsh_theme(){
  mkdir -p "$HOME/.zsh"
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh/zsh-syntax-highlighting"
}
ls $HOME/.zsh/pure || zsh_theme

echo "-- Installing kubectl"
kubectl_install() {
  sudo apt-get install -y kubectl
}
which kubectl || kubectl_install

echo "-- Installing Go"
go_install(){
  GO_VERSION=1.14
  wget https://dl.google.com/go/go$(echo $GO_VERSION).linux-amd64.tar.gz
  sudo tar -xvf go$(echo $GO_VERSION).linux-amd64.tar.gz
  sudo mv go /usr/local
}
# which go || go_install
go_install

echo "-- Installing Rust"
rust_install(){
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}
which cargo || rust_install

echo "-- Linking dotfiles"
ln -s $(pwd)/.vimrc ~/.vimrc
ln -s $(pwd)/.gitconfig ~/.gitconfig
ln -s $(pwd)/.zshrc ~/.zshrc

echo "-- Done!"
