set --export EDITOR vim

# for Coder dev deployments 
set --export NAMESPACE coder-charlie

## Golang
set --export GOPATH ~/go
set --export GO111MODULE on

set --export WASMTIME_HOME ~/.wasmtime

function path;
  for p in $argv;
    if test -d $p
      and not contains $p $PATH
      set --export PATH $p $PATH;
    end
  end
end

path \
  $GOPATH/bin \
  ~/.cargo/bin \
  $WASMTIME_HOME/bin \
  ~/.bin \
  ~/bin

if [ (uname) = "Darwin" ]
  # for Linux utils
  set --local brew_prefix (brew --prefix)
  path $brew_prefix/opt/coreutils/libexec/gnubin \
    $brew_prefix/opt/findutils/libexec/gnubin \
    $brew_prefix/opt/make/libexec/gnubin \
    $brew_prefix/opt/gnu-tar/libexec/gnubin \
    $brew_prefix/opt/gnu-sed/libexec/gnubin \
    $brew_prefix/opt/gawk/libexec/gnubin
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
else
  path (brew --prefix)/bin
  if not type --no-functions --quiet code
    alias code="$HOME/bin/code.py"
  end
end

functions --erase path

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
set --export FZF_DEFAULT_COMMAND fd --type f
set --export FZF_CTRL_T_COMMAND '$FZF_DEFAULT_COMMAND'

set --export GPG_TTY (tty)

# quickly navigate to the root of a git project
function r;
  cd (git rev-parse --show-toplevel)
end

# commit a branch and create then open a pull-request to master
function cpr;
  git c

  set --export branch (git rev-parse --abbrev-ref HEAD)
  git push; or git push --set-upstream origin "$branch"

  gh pr create --fill
  gh pr view --web
end

# create then open a pull-request to master
function pr;
  gh pr create --fill
  gh pr view --web
end
