#!/bin/bash

set -e

function usage() {
    echo "Usage : $0 <action> [email]"
    echo "  --backup, -b  : Backup dotfiles to current folder"
    echo "  --install, -i : Import dotfiles to homedir"
}

if [[ "$#" -eq 0 ]]; then
    echo "[ERROR] You must specify backup or import"
    usage
    exit 1
fi

function install() {
    [[ -f zshrc ]] && cp zshrc $HOME/.zshrc
    [[ -f aliases.zsh ]] && cp aliases.zsh $HOME/.aliases.zsh
    [[ -f functions.zsh ]] && cp functions.zsh $HOME/.functions.zsh

    [[ -f p10k.zsh ]] && cp functions.zsh $HOME/.p10k.zsh

    [[ -f iterm2.json ]] && cp iterm2.json $HOME/.iterm2.json

    [[ -f bashrc ]] && cp bashrc $HOME/.bashrc
    [[ -f bash_aliases ]] && cp bash_aliases $HOME/.bash_aliases

    mkdir -p $HOME/.config
    [[ -d config ]] && cp -r config/* $HOME/.config/

    [[ -f gitconfig ]] && cp gitconfig $HOME/.gitconfig

    [[ -f terraformrc ]] && cp terraformrc $HOME/.terraformrc
    [[ -f tflint.hcl ]] && cp tflint.hcl $HOME/.tflint.hcl

    [[ -f tmux.conf ]] && cp tmux.conf $HOME/.tmux.conf
    mkdir -p $HOME/.tmux
    [[ -d tmux ]] && cp -r tmux/* $HOME/.tmux/

    [[ -f tmux ]] && cp vimrc $HOME/.vimrc
}

function backup() {
    [[ -f $HOME/.zshrc ]] && cp $HOME/.zshrc zshrc
    [[ -f $HOME/.aliases.zsh ]] && cp $HOME/.aliases.zsh aliases.zsh
    [[ -f $HOME/.functions.zsh ]] && cp $HOME/.functions.zsh functions.zsh

    [[ -f $HOME/.p10k.zsh ]] && cp $HOME/.p10k.zsh p10k.zsh

    [[ -f $HOME/.iterm2.json ]] && cp $HOME/.iterm2.json iterm2.json

    [[ -f $HOME/.bashrc ]] && cp $HOME/.bashrc bashrc
    [[ -f $HOME/.bash_aliases ]] && cp $HOME/.bash_aliases bash_aliases

    mkdir -p config
    [[ -d $HOME/.config/bat ]] && cp -r $HOME/.config/bat config/

    [[ -f $HOME/.gitconfig ]] && cp $HOME/.gitconfig gitconfig

    [[ -f $HOME/.terraformrc ]] && cp $HOME/.terraformrc terraformrc
    [[ -f $HOME/.tflint.hcl ]] && cp $HOME/.tflint.hcl tflint.hcl

    [[ -f $HOME/.tmux.conf ]] && cp $HOME/.tmux.conf tmux.conf
    [[ -d $HOME/.tmux ]] && cp -r $HOME/.tmux tmux

    [[ -f $HOME/.vimrc ]] && cp $HOME/.vimrc vimrc

    sed -i 's/signingkey =.*/signinkey = <to_replace>/' gitconfig
    sed -i 's/name =.*/name = <to_replace>/' gitconfig
    sed -i 's/email =.*/email = <to_replace>/' gitconfig
}


action=$1

case $action in
    "--help" | "-h")
        usage
        exit 0
        ;;
    "--backup" | "-b")
        backup
        echo "Backup done"
        ;;
    "--install" | "-i")
        install
        echo "Dotfiles imported"
        ;;
    *)
        echo "[ERROR] '$1' is not a valid argument"
        usage
        exit 1
        ;;
esac
