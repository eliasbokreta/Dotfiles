# dotfiles

## Dotfiles
- **bash** : .bash_aliases & .bashrc
- **git** : .gitconfig
- **tmux** : .tmux.conf
- **vim** : .vimrc

## Script usage
The `dotfile.sh` script is used to backup / import dotfiles.
`./dotfile.sh <action> [email]`
action :
  - --backup, -b : Backup dotfiles to current directory
  - --import, -i : Import current directory dotfiles to homedir
  - [email]      : Used when importing, to replace the hidden email address in the gitconfig file
