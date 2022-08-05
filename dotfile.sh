#!/bin/bash

set -e

function usage() {
    echo "Usage : $0 <action> [email]"
    echo "  --export, -b  : Export dotfiles to script's directory"
    echo "  --import, -i  : Import dotfiles to the user's home directory"
}

if [[ "$#" -eq 0 ]]; then
    echo "[ERROR] You must specify export or import"
    usage
    exit 1
fi

function import_dotfiles() {
    echo "Importing dotfiles..."

    [[ -f zshrc ]] && cp zshrc "$HOME"/.zshrc
    [[ -f aliases.zsh ]] && cp aliases.zsh "$HOME"/.aliases.zsh
    [[ -f functions.zsh ]] && cp functions.zsh "$HOME"/.functions.zsh

    [[ -f p10k.zsh ]] && cp p10k.zsh "$HOME"/.p10k.zsh

    mkdir -p "$HOME"/.k9s
    [[ -d k9s ]] && cp -r k9s/* "$HOME"/.k9s

    [[ -f iterm2.json ]] && cp iterm2.json "$HOME"/.iterm2.json

    [[ -f bashrc ]] && cp bashrc "$HOME"/.bashrc
    [[ -f bash_aliases ]] && cp bash_aliases "$HOME"/.bash_aliases

    mkdir -p "$HOME"/.config
    [[ -d config ]] && cp -r config/* "$HOME"/.config/

    [[ -f gitconfig ]] && cp gitconfig "$HOME"/.gitconfig
    [[ -d git-templates ]] && cp -r git-templates "$HOME"/.git-templates
    [[ -f gitignore ]] && cp -r gitignore "$HOME"/.gitignore

    [[ -f terraformrc ]] && cp terraformrc "$HOME"/.terraformrc
    [[ -f tflint.hcl ]] && cp tflint.hcl "$HOME"/.tflint.hcl

    [[ -f tmux.conf ]] && cp tmux.conf "$HOME"/.tmux.conf
    mkdir -p "$HOME"/.tmux
    [[ -d tmux ]] && cp -r tmux/* "$HOME"/.tmux/ && chmod +x "$HOME"/.tmux/*

    [[ -f tmux ]] && cp vimrc "$HOME"/.vimrc

    echo "Dotfiles imported"
}

function export_dotfiles() {
    echo "Exporting dotfiles..."

    [[ -f $HOME/.zshrc ]] && cp "$HOME"/.zshrc zshrc
    [[ -f $HOME/.aliases.zsh ]] && cp "$HOME"/.aliases.zsh aliases.zsh
    [[ -f $HOME/.functions.zsh ]] && cp "$HOME"/.functions.zsh functions.zsh

    [[ -f $HOME/.p10k.zsh ]] && cp "$HOME"/.p10k.zsh p10k.zsh

    mkdir -p k9s
    [[ -d $HOME/.k9s ]] && cp -r "$HOME"/.k9s/* k9s

    [[ -f $HOME/.iterm2.json ]] && cp "$HOME"/.iterm2.json iterm2.json

    [[ -f $HOME/.bashrc ]] && cp "$HOME"/.bashrc bashrc
    [[ -f $HOME/.bash_aliases ]] && cp "$HOME"/.bash_aliases bash_aliases

    mkdir -p config
    [[ -d $HOME/.config/bat ]] && cp -r "$HOME"/.config/bat config/

    [[ -f $HOME/.gitconfig ]] && cp "$HOME"/.gitconfig gitconfig
    [[ -d $HOME/.git-templates ]] && cp -r "$HOME"/.git-templates/ git-templates
    [[ -f $HOME/.gitignore ]] && cp -r "$HOME"/.gitignore gitignore

    [[ -f $HOME/.terraformrc ]] && cp "$HOME"/.terraformrc terraformrc
    [[ -f $HOME/.tflint.hcl ]] && cp "$HOME"/.tflint.hcl tflint.hcl

    [[ -f $HOME/.tmux.conf ]] && cp "$HOME"/.tmux.conf tmux.conf
    [[ -d $HOME/.tmux ]] && cp -r "$HOME"/.tmux/ tmux

    [[ -f $HOME/.vimrc ]] && cp "$HOME"/.vimrc vimrc

    sed -i 's/signingkey =.*/signingkey = <to_replace>/' gitconfig
    sed -i 's/name =.*/name = <to_replace>/' gitconfig
    sed -i 's/email =.*/email = <to_replace>/' gitconfig

    if [[ -f k9s/config.yml ]]; then
        yq -i 'del(.k9s.clusters.*)' k9s/config.yml
        yq -i 'del(.k9s.currentContext)' k9s/config.yml
        yq -i 'del(.k9s.currentCluster)' k9s/config.yml
        yq -i 'del(.k9s.screenDumpDir)' k9s/config.yml
    fi

    echo "Dotfiles exported"
}

action=$1

case $action in
    "--help" | "-h")
        usage
        exit 0
        ;;
    "--export" | "-b")
        export_dotfiles
        ;;
    "--import" | "-i")
        import_dotfiles
        ;;
    *)
        echo "[ERROR] '$1' is not a valid argument"
        usage
        exit 1
        ;;
esac
