# .zshrc configuration
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
export PATH=/usr/local/bin:$PATH

# theme
autoload -U promptinit; promptinit

# change the path color
zstyle :prompt:pure:path color '#79b8ff'
zstyle ':prompt:pure:prompt:success' color '#79b8ff'
zstyle ':prompt:pure:prompt:error' color '#eb0000'

# turn on git stash status
zstyle :prompt:pure:git:stash show yes
zstyle :prompt:pure:git:arrow show yes
zstyle :prompt:pure:git:action show yes

zstyle :prompt:pure:git:dirty show yes
zstyle :prompt:pure:host show yes

PROMPT="$fg[cyan]%}$USER@%{$fg[blue]%}%m ${PROMPT}"
prompt pure

# personal bin utils
export PATH=$HOME/bin:$PATH

# node
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
nvm use default > /dev/null

# golang
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

export GOROOT="$(brew --prefix golang)/libexec"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# gomodules
export GO111MODULE=on
export GOPROXY=direct
export GOSUMDB=off

export GOROOT=/usr/local/opt/go/libexec

# Python alias
alias python="python3"
alias python2="command python"

# Rust and Cargo
export PATH=$PATH:/Users/charlesmoog/.cargo/bin
export PATH=$HOME/.cargo/bin:$PATH

# autocompletions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export GPG_TTY=$(tty)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/charlesmoog/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/charlesmoog/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/charlesmoog/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/charlesmoog/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Kubernetes CLI
alias kub="command kubectl"
alias kube="command kubectl"
source <(kubectl completion zsh)
complete -F __start_kubectl kube
complete -F __start_kubectl kub

# Deno
export DENO_INSTALL="/Users/charlesmoog/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# coder namespace
export NAMESPACE=coder-charlie7
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH=$PATH:$HOME/coder/enterprise/devbin

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
