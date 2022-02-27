set fish_greeting ""
set --export EDITOR vim

# Go toolchain configuration
set --export GOPATH ~/go
set --export GO111MODULE on

fish_add_path \
  ~/bin \
  ~/.bin \
  $GOPATH/bin \
  ~/.cargo/bin \
  ~/.deno/bin

# fzf configuration
# respect .gitignore
set --export FZF_DEFAULT_COMMAND fd --type f
set --export FZF_CTRL_T_COMMAND '$FZF_DEFAULT_COMMAND'

# convenience abbreviations
abbr --add --global g 'git'
abbr --add --global kube 'kubectl'
abbr --add --global kub 'kubectl'
abbr --add --global lg 'lazygit'
abbr --add --global ld 'lazydocker'

# prefer "exa" to "ls" when available
if type -q exa
  abbr --add --global ls 'exa'
  abbr --add --global lss 'ls'
end

if [ (uname) = "Darwin" ]
  # use GNU/Linux utils on macOS
  set --local brew_prefix (brew --prefix)
  fish_add_path $brew_prefix/opt/coreutils/libexec/gnubin \
    $brew_prefix/opt/gnu-tar/libexec/gnubin \
    $brew_prefix/opt/curl/bin

  # alias Tailscale CLI
  alias tailscale /Applications/Tailscale.app/Contents/MacOS/Tailscale

  # use Secretive for SSH authentication with the secure enclave
  set --export SSH_AUTH_SOCK ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
end

# zoxide is a smarter cd command
if type -q zoxide
  zoxide init fish | source
end

# quickly navigate to the root of a git project
function groot;
  set --local gitroot (git rev-parse --show-toplevel)
  if [ "$gitroot" = "" ]
    return -1
  end
  cd "$gitroot"
end

# create then open a pull request to the default branch
function pr;
  gh pr create --fill
  gh pr view --web
end
