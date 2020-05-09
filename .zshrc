## .zshrc configuration

# Extension Marketplace cli env
# source ~/coder/extension-marketplace/env.sh

autoload -Uz compinit
compinit

# Coder Enterprise development cluster
export NAMESPACE=charlie-remote-dev
export PATH=$PATH:$HOME/coder/enterprise/devbin

fpath+=$HOME/.zsh/pure
fpath+=$HOME/.zsh/pure

# General binary utils
export PATH=$PATH:$HOME/bin
export PATH=$PATH:/usr/local/bin

# Rust and Cargo
export PATH=$PATH:$HOME/.cargo/bin

# Go config options
export PATH=$PATH:$HOME/go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOPATH

export VISUAL=vim
export EDITOR="$VISUAL"

# nvm and node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Deno
export DENO_INSTALL=$HOME/.deno
export PATH=$DENO_INSTALL/bin:$PATH

# Linuxbrew
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info${INFOPATH+:$INFOPATH}";

# Theme
autoload -U promptinit; promptinit
zstyle :prompt:pure:host color green
zstyle :prompt:pure:user color green
prompt pure

# Autocompletion
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export GPG_TTY=$(tty)

# Kubectl
alias kub="command kubectl"
alias kube="command kubectl"
source <(kubectl completion zsh)
complete -F __start_kubectl kub
complete -F __start_kubectl kube
