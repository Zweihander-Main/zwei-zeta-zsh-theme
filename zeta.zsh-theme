# Zwei version of Zeta theme for oh-my-zsh
# Copyright: Zweihänder, 2023
# Copyright: Skyler Lee, 2015

ZETA_SYMBOL='λ'
ZETA_SSH_OR_LOCAL="$(([ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]) && echo 'ssh' || echo 'local')"

# Machine name, cyan if local, red if SSH
function get_box_name {
    local box_name
    if [[ $ZETA_SSH_OR_LOCAL == "ssh" ]]; then
        box_name="%{$fg_bold[red]%}"
    else
        box_name="%{$fg_bold[cyan]%}"
    fi
    if [[ -f ~/.box-name ]]; then
        box_name+="$(cat ~/.box-name)"
    else
        box_name+="${HOST}"
    fi
    echo "$box_name%F{reset}"
}

# User name.
function get_usr_name {
    local name="%n"
    if [[ "$USER" == 'root' ]]; then
        name="%{$bg[red]%}%{$fg_bold[white]%}$name%{$reset_color%}"
    fi
    echo $name
}

# Directory info.
function get_current_dir {
    echo "${PWD/#$HOME/~}"
}

function get_git_prompt {
    if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        local git_status="$(git_prompt_status)"
        if [[ -n $git_status ]]; then
            git_status="[$git_status%{$reset_color%}]"
        fi
        local git_prompt=" <$(git_prompt_info)$git_status>"
        echo $git_prompt
    fi
}

function get_time_stamp {
    echo "%*"
}

function get_space {
    local str=$1$2
    local zero='%([BSUbfksu]|([FB]|){*})'
    local len=${#${(S%%)str//$~zero/}}
    local size=$(( $COLUMNS - $len - 1 ))
    local space=$(printf "%${size}s")
    echo $space
}

# Prompt: USER@MACHINE: DIRECTORY <BRANCH [STATUS]> --- (TIME_STAMP)
# > command
function print_prompt_head {
    local left_prompt="\
%{$fg_bold[green]%}$(get_usr_name)\
%{$fg[blue]%}@\
$(get_box_name): \
%{$fg_bold[yellow]%}$(get_current_dir)%{$reset_color%}\
$(get_git_prompt) "
    local right_prompt="%{$fg[blue]%}($(get_time_stamp))%{$reset_color%} "
    print -r "$left_prompt$(get_space $left_prompt $right_prompt)$right_prompt"
}

function get_prompt_indicator {
    if [[ $? -eq 0 ]]; then
        echo "%{$fg_bold[magenta]%}${ZETA_SYMBOL} %{$reset_color%}"
    else
        echo "%{$fg_bold[red]%}${ZETA_SYMBOL} %{$reset_color%}"
    fi
}

# Git info.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✔ "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} ✘ "

# Git status.
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[magenta]%}*"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[blue]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[cyan]%}="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[yellow]%}?"

# Git sha.
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="[%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}]"

RPROMPT='$(git_prompt_short_sha) '

PROMPT='$(print_prompt_head)
$(get_prompt_indicator)'
PROMPT2='%{$fg_bold[magenta]%}↠ %{$reset_color%}'

# Enable prompt substition.
setopt prompt_subst
