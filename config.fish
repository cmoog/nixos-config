set -gx EDITOR vim

# for Coder dev deployments 
set -x NAMESPACE coder-charlie

## Golang
set -gx GOPATH ~/go
set -gx GO111MODULE on

for p in $GOPATH/bin ~/.cargo/bin $WASMTIME_HOME/bin ~/.bin ~/bin
  if test -d $p
    set -gx PATH $p $PATH;
  end
end

set -x WASMTIME_HOME ~/.wasmtime

if [ (uname) = "Darwin" ]
  # for Linux utils
  set -x PATH (brew --prefix)/opt/coreutils/libexec/gnubin $PATH
  set -x PATH (brew --prefix)/opt/findutils/libexec/gnubin $PATH
  set -x PATH (brew --prefix)/opt/make/libexec/gnubin $PATH
end

# convenience abbreviations
abbr g 'git'
abbr kube 'kubectl'
abbr kub 'kubectl'
abbr c 'clear'
abbr v 'vim'
abbr ls 'exa'
abbr lss 'ls'

# fzf configuration
# respect .gitignore
set -x FZF_DEFAULT_COMMAND fd --type f
set -x FZF_CTRL_T_COMMAND '$FZF_DEFAULT_COMMAND'

set -gx GPG_TTY (tty)
