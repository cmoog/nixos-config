set --export EDITOR vim

# Golang
set --export GOPATH ~/go
set --export GO111MODULE on

fish_add_path \
  $GOPATH/bin \
  ~/.cargo/bin \
  ~/.bin \
  ~/bin \
  ~/.deno/bin

if [ (uname) = "Darwin" ]
  # use GNU/Linux utils on macOS
  set --local brew_prefix (brew --prefix)
  fish_add_path $brew_prefix/opt/coreutils/libexec/gnubin \
    $brew_prefix/opt/findutils/libexec/gnubin \
    $brew_prefix/opt/make/libexec/gnubin \
    $brew_prefix/opt/gnu-tar/libexec/gnubin \
    $brew_prefix/opt/gnu-sed/libexec/gnubin \
    $brew_prefix/opt/gawk/libexec/gnubin \
    $brew_prefix/opt/curl/bin
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
else
  fish_add_path \
    /home/linuxbrew/.linuxbrew/bin \
    /usr/local/gcloud/google-cloud-sdk/bin
end

# convenience abbreviations
abbr --add --global g 'git'
abbr --add --global kube 'kubectl'
abbr --add --global kub 'kubectl'

# prefer "exa" to "ls" when available
if type -q exa
  abbr --add --global ls 'exa'
  abbr --add --global lss 'ls'
end

# lazygit and lazydocker
abbr --add --global lg 'lazygit'
abbr --add --global ld 'lazydocker'

# fzf configuration
# respect .gitignore
set --export FZF_DEFAULT_COMMAND fd --type f
set --export FZF_CTRL_T_COMMAND '$FZF_DEFAULT_COMMAND'

set --export GPG_TTY (tty)

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
