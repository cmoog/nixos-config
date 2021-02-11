set -gx EDITOR vim

# for Coder dev deployments 
set -x NAMESPACE coder-charlie

## Golang
set -gx GOPATH ~/go
set -gx GO111MODULE on

set -x WASMTIME_HOME ~/.wasmtime

for p in $GOPATH/bin ~/.cargo/bin $WASMTIME_HOME/bin ~/.bin ~/bin
  if test -d $p
    set -gx PATH $p $PATH;
  end
end

if [ (uname) = "Darwin" ]
  # for Linux utils
  set -x PATH (brew --prefix)/opt/coreutils/libexec/gnubin $PATH
  set -x PATH (brew --prefix)/opt/findutils/libexec/gnubin $PATH
  set -x PATH (brew --prefix)/opt/make/libexec/gnubin $PATH
  set -x PATH (brew --prefix)/opt/gnu-tar/libexec/gnubin $PATH
  set -x PATH (brew --prefix)/opt/gnu-sed/libexec/gnubin $PATH
  set -x PATH (brew --prefix)/opt/gawk/libexec/gnubin $PATH
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
end

# convenience abbreviations
abbr g 'git'
abbr kube 'kubectl'
abbr kub 'kubectl'
abbr c 'clear'
abbr v 'vim'

# prefer "exa" to "ls"
abbr ls 'exa'
abbr lss 'ls'

# lazygit and lazydocker
abbr lg 'lazygit'
abbr ld 'lazydocker'

# fzf configuration
# respect .gitignore
set -x FZF_DEFAULT_COMMAND fd --type f
set -x FZF_CTRL_T_COMMAND '$FZF_DEFAULT_COMMAND'

set -gx GPG_TTY (tty)

# quickly navigate to the root of a git project
function r;
  cd (git rev-parse --show-toplevel)
end

# commit a branch and create then open a pull-request to master
function cpr;
  git c

  set -x branch (git rev-parse --abbrev-ref HEAD)
  git push; or git push --set-upstream origin "$branch"

  gh pr create --fill
  gh pr view --web
end

# create then open a pull-request to master
function pr;
  gh pr create --fill
  gh pr view --web
end
