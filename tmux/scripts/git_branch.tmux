#!/bin/bash

function git_branch() {
    current_path=$1
    local tmux_output branch

    if [ $(git -C "${current_path}" rev-parse 2>/dev/null; echo $?) -eq 0 ]; then
        tmux_output+="  "
        tmux_output+="#[fg=yellow] \uf09b "
        branch=$(git -C "${current_path}" branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')
        tmux_output+="$(echo "${branch}" | awk '{$1=$1};1')"
    fi

    echo "${tmux_output}"
}

git_branch "$@"
