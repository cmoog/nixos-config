#!/usr/bin/env bash

echo "-- Setup starting"

echo "-- Setting default shell"
chsh -s $(which zsh)

echo "-- Installing zsh autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions > /dev/null

echo "-- Installing zsh pure theme"
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

echo "-- Done!"