#!/bin/bash

function tf_workspace() {
    current_path=$1
    local tmux_output


    if [ -d "${current_path}/.terraform" ]; then
        tmux_output+="  "
        tmux_output+="#[fg=green] \uF1BB "
        tmux_output+=$( (cd "$1" && terraform workspace show 2>/dev/null) )
    fi

    echo "${tmux_output}"
}

tf_workspace "$@"
