#         _       _    __ _ _          #
#        | |     | |  / _(_) |         #
#      __| | ___ | |_| |_ _| | ___     #
#     / _` |/ _ \| __|  _| | |/ _ \    #
#    | (_| | (_) | |_| | | | |  __/    #
#     \__,_|\___/ \__|_| |_|_|\___|    #
#                                      #
# Author : Elias BOKRETA               #
########################################

#!/usr/bin/env bash

set -e

function usage {
    echo "Usage : $0 <action> [email]"
    echo "  --backup, -b  : Backup dotfiles to current folder"
    echo "  --import, -i : Import current file dotfiles to homedir"
    echo "  [email]       : Replace the hidden email from the gitconfig file"
}

if [[ "$#" -eq 0 ]]; then
    echo "[ERROR] At least one argument is required"
    usage
    exit 1
fi

action=$1

case $action in
    "--help" | "-h")
        usage
        exit 0
        ;;
    "--backup" | "-b")
        cp --verbose ~/.bashrc ./bashrc
        cp --verbose ~/.bash_aliases ./bash_aliases
        cp --verbose ~/.gitconfig ./gitconfig
        cp --verbose ~/.vimrc ./vimrc
        cp --verbose ~/.tmux.conf ./tmux.conf
        echo "Backup done"
        sed -i -E "s/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}/<YOUR EMAIL HERE>/g" ./gitconfig
        ;;
    "--import" | "-i")
        cp --verbose ./bashrc ~/.bashrc
        cp --verbose ./bash_aliases ~/.bash_aliases
        cp --verbose ./gitconfig ~/.gitconfig
        cp --verbose ./vimrc ~/.vimrc
        cp --verbose ./tmux.conf ~/.tmux.conf
        echo "Import done"
        if [[ "$2" =~ [A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6} ]]; then
            sed -i -E "s/<YOUR EMAIL HERE>/$2/g" ~/.gitconfig           
        fi
        ;;
    *)
        echo "[ERROR] '$1' is not a valid argument"
        usage
        exit 1
        ;;
esac
