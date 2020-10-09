
# for Coder dev deployments 
set -x NAMESPACE coder-charlie

## Golang
set -x GOPATH ~/go
set -x PATH $GOPATH/bin $PATH
set -x GO111MODULE on

# Rust
set -x PATH ~/.cargo/bin $PATH

# for linux utils
set -x PATH ~/.bin $PATH
set -x PATH (brew --prefix)/opt/coreutils/libexec/gnubin $PATH
set -x PATH (brew --prefix)/opt/findutils/libexec/gnubin $PATH
set -x PATH (brew --prefix)/opt/make/libexec/gnubin $PATH

# convenience abbreviations
abbr g 'git'
abbr kube 'kubectl'
abbr kub 'kubectl'

# personal bin utils
set -x PATH ~/bin $PATH

set -x EDITOR vim

