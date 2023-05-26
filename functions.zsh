#!/bin/zsh

function gdiff() {
    [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ] || return
    preview="git diff $@ --color=always -- {-1}"
    git diff $@ --name-only | fzf -m --ansi --preview $preview --info=inline --border --preview-window 'up,90%,border-bottom,+{2}+3/3,~3'
}

function gico() {
   git branch | grep -v "^\*" | fzf --height=20% --reverse --info=inline | xargs git checkout
}

function tf_remove_empty_ws() {
    tws default
    for WS in $(twl | cut -c3-); do
        if [ $WS != "default" ]; then
            echo "[INFO] Removing ${WS} workspace"
            t workspace delete $WS
        fi
    done
}

function tfmt_all() {
    # Format all terraform files found. $1 Can be given to add another path than the current one
    for TF_DIR in $(fd -H -p --type=f "\.(tf?)$" --exclude ".terraform" $1 | sed -E 's|/[^/]+$|/|' | uniq); do
        echo "[INFO] Formating $TF_DIR"
        (
            cd "$TF_DIR" && \
            rm -rf .terraform && \
            t init && \
            tfmt
        )
    done

    for TF_VAR in $(fd -H -p --type=f "\.(vars?)$" --exclude ".terraform" . | sed -E 's|/[^/]+$|/|' | uniq); do
        echo "[INFO] Formating $TF_VAR"
        (
            cd "$TF_VAR" && \
            terraform fmt -recursive .
        )
    done
}
