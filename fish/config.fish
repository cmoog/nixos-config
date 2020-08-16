function nvm
   bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
   export PATH="$HOME/.cargo/bin:$PATH"
end

set -x NVM_DIR ~/.nvm
set PATH /usr/local/bin $PATH
set PATH /Users/charlesmoog/.local/bin $PATH

nvm use default --silent

abbr g 'git'
abbr kube 'kubectl'
abbr kub 'kubectl'

abbr acp 'git a && git c && git push'

