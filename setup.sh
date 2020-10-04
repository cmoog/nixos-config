#!/usr/bin/env bash

cd "$(dirname $0)"

echo "-- Setup starting"

echo "-- Setting default shell"
chsh -s $(which zsh)

echo "-- Linking dotfiles"
ln -s $(pwd)/.vimrc ~/.vimrc
ln -s $(pwd)/.gitconfig ~/.gitconfig
ln -s $(pwd)/.zshrc ~/.zshrc
ln -s $(pwd)/fish ~/.config/fish

echo "-- Done!"
