set -x EDITOR vim

# for Coder dev deployments 
set -x NAMESPACE coder-charlie

## Golang
set -x GOPATH ~/go
set -x GO111MODULE on

set -x WASMTIME_HOME ~/.wasmtime

function path;
  for p in $argv;
    if test -d $p
      and not contains $p $PATH
      set -x PATH $p $PATH;
    end
  end
end

path $GOPATH/bin
path ~/.cargo/bin
path $WASMTIME_HOME/bin
path ~/.bin
path ~/bin

if [ (uname) = "Darwin" ]
  # for Linux utils
  path (brew --prefix)/opt/coreutils/libexec/gnubin
  path (brew --prefix)/opt/findutils/libexec/gnubin
  path (brew --prefix)/opt/make/libexec/gnubin
  path (brew --prefix)/opt/gnu-tar/libexec/gnubin
  path (brew --prefix)/opt/gnu-sed/libexec/gnubin
  path (brew --prefix)/opt/gawk/libexec/gnubin
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
set -x FZF_DEFAULT_COMMAND fd --type f
set -x FZF_CTRL_T_COMMAND '$FZF_DEFAULT_COMMAND'

set -x GPG_TTY (tty)

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
