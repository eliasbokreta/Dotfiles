#!/bin/zsh


#############
# Git stuff #
#############

function gdiff() {
    # Git interactibe diff
    [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ] || return
    PREVIEW="git diff $@ --color=always -- {-1}"
    FILE=$(git diff $@ --name-only | fzf -m --ansi --preview $PREVIEW --info=inline --border --preview-window 'up,90%,border-bottom,+{2}+3/3,~3')
    if [[ $? -eq 0 ]]; then
        git add $FILE && echo "git added '$FILE'"
    fi
}

function gico() {
    # Git interactive checkout
    git branch | grep -v "^\*" | fzf --height=20% --reverse --info=inline | xargs git checkout
}

function tf_rm_ws() {
    # Remove empty terraform workspaces
    tws default
    for WS in $(twl | cut -c3-); do
        if [ $WS != "default" ]; then
            echo "[INFO] Removing ${WS} workspace"
            t workspace delete $WS
        fi
    done
}


###################
# Terraform stuff #
###################

function tf_fmta() {
    # Terraform format & lint recursively. $1 optional path
    DIR=$1
    for TF_DIR in $(fd -H -p --type=f "\.(tf?)$" --exclude ".terraform" $DIR | sed -E 's|/[^/]+$|/|' | uniq); do
        (
            {
                echo "[INFO] Formating $TF_DIR" && \
                cd "$TF_DIR" &&  \
                rm -rf .terraform && \
                t init > /dev/null && \
                tfmt
            } &
        )
    done

    for TF_VAR in $(fd -H -p --type=f "\.(vars?)$" --exclude ".terraform" $DIR | sed -E 's|/[^/]+$|/|' | uniq); do
        (
            {
                echo "[INFO] Formating $TF_VAR" && \
                cd "$TF_VAR" && \
                terraform fmt -recursive .
            } &
        )
    done
}

function tf_init() {
    # Terraform init recursively. $1 optional path
    DIR=$1
    for TF_DIR in $(fd -H -p --type=f "\.(tf?)$" --exclude ".terraform" $DIR | sed -E 's|/[^/]+$|/|' | uniq); do
        if [[ -d "$TF_DIR" ]]; then
            (
                {
                    echo "[INFO] Init $TF_DIR" && \
                    cd "$TF_DIR" && \
                    rm -rf .terraform && \
                    rm -rf .terraform.lock.hcl && \
                    t init > /dev/null && \
                    tlock
                } &
            )
        else
            {
                echo "[INFO] Init current directory" && \
                rm -rf .terraform && \
                rm -rf .terraform.lock.hcl && \
                t init > /dev/null && \
                tlock
            } &
            break
        fi
    done
}


####################
# Kubernetes stuff #
####################

function k_nv() {
    # Print all different Kubelet versions in all contexts grouped by labels nodegroup/agentpool (eks/aks)
    for KCTX in $(kubie ctx | sort); do
        (
          kubie ctx $KCTX 2> /dev/null
          echo $KCTX
          kubectl get nodes -o jsonpath="{range .items[*]}{.status.nodeInfo.kubeletVersion}{' - '}{.metadata.labels.nodegroup}{.metadata.labels.agentpool}{'\n'}{end}" | sort | uniq -c
        )
    done
}
