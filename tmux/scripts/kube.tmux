#!/bin/bash

# This script fetch the current kubernetes context
function kube_tmux {
    local pane_pid=$1
    local tmux_output tty kubiecfg

    if ! [ -x "$(command -v kubectl)" ]; then
        echo "#[fg=red,bold]kubectl is not installed"
        return
    fi

    if ! [ -x "$(command -v yq)" ]; then
        echo "#[fg=red,bold]yq is not installed"
        return
    fi

    tmux_output+="  "
    tmux_output+="#[fg=blue] \U2388 "

    tty=$(ps -o tty -ef "${pane_pid}" | tail -n1 | awk '{print $1}')
    kubiecfg=$(ps -E -t /dev/"${tty}" | awk '$4=="zsh"' | head -n 1 | grep -Po -- 'KUBIE_KUBECONFIG=\K[^\s]+')

    if [ -z "${kubiecfg}" ]; then
        kubecfg=$(kubectl config view --minify -o yaml)
        tmux_output+="$(echo "${kubecfg}" | yq '.contexts[0].name')/#[fg=magenta,bold]$(echo "${kubecfg}" | yq '.contexts[0].context.namespace')"
    else
        tmux_output+="$(yq '.contexts[0].name' "${kubiecfg}")/#[fg=magenta,bold]$(yq '.contexts[0].context.namespace' "${kubiecfg}")"
    fi

    echo "${tmux_output}"
}

kube_tmux "$@"
