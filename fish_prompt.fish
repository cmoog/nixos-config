# This prompt shows:
# - green lines if the last return command is OK, red otherwise
# - user name, in red if root or yellow otherwise
# - hostname, in cyan if ssh or blue otherwise
# - the current path (with prompt_pwd)
# - the current git status, if any, with fish_git_prompt
# - the nix shell state, impure or pure
# - current background jobs, if any

# It goes from:
# ┬─[charlie@mac:~]
# ╰─>$ echo here

# To:
# ┬─[charlie@mac:~/C/core]─[master↑1|●1✚1…1]─[impure]
# │ 2       15054   0%      running sleep 100000
# │ 1       15048   0%      running sleep 100000
# ╰─>$ echo there

set -l return_color red
test $status = 0; and set return_color green

set -q __fish_git_prompt_showupstream
or set -g __fish_git_prompt_showupstream auto

set -g __fish_git_prompt_show_informative_status auto
set -g __fish_git_prompt_showdirtystate auto
set -g __fish_git_prompt_showuntrackedfiles auto

function _nim_prompt_wrapper
    set field_color $argv[1]
    set field_name $argv[2]
    set field_value $argv[3]

    set_color normal
    echo -n '─'
    set_color -o normal
    echo -n '['
    set_color normal
    test -n $field_name
    and echo -n $field_name:
    set_color -o $field_color
    echo -n $field_value
    set_color -o normal
    echo -n ']'
end

set_color $return_color
echo -n '┬─'
set_color -o normal
echo -n [
if test "$USER" = root -o "$USER" = toor
    set_color -o red
else
    set_color -o yellow
end
echo -n $USER
set_color -o white
echo -n @
if [ -z "$SSH_CLIENT" ]
    set_color -o blue
else
    set_color -o cyan
end
echo -n (prompt_hostname)
set_color -o white
echo -n :(prompt_pwd)
set_color -o normal
echo -n ']'

# git
set -l git_orange "#e25a38"
set prompt_git (fish_git_prompt | string trim -c ' ()')
test -n "$prompt_git"
and _nim_prompt_wrapper $git_orange "" $prompt_git

# nix shell
if [ "$IN_NIX_SHELL" != "" ]
    set -l nix_purple "#7e7eff"
    _nim_prompt_wrapper $nix_purple "" $IN_NIX_SHELL
end

# New line
echo

# Background jobs
set_color normal
for job in (jobs)
    set_color $return_color
    echo -n '│ '
    set_color brown
    echo $job
end
set_color normal
set_color $return_color
echo -n '╰─>'
set_color -o $return_color
echo -n '$ '
set_color normal
