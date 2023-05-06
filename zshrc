typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    #git
    fzf
    #kubectl
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)

[ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ] && source $HOME/.oh-my-zsh/oh-my-zsh.sh

# DIRTY FIX FOR TERRAFORM GRPC PROVIDER ERRORS
export GODEBUG=asyncpreemptoff=1

export K9SCONFIG="$HOME/.k9s"

export KUBE_EDITOR="nvim"

export FZF_DEFAULT_OPTS='--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672'

COMPUTER_OS="$(uname -s)"
case "${COMPUTER_OS}" in
    Linux*)
        ;;
    Darwin*)
        export PATH="$(brew --prefix)/bin:$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$(brew --prefix)/opt/grep/libexec/gnubin:$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
        export JAVA_HOME=$(brew --prefix)/opt/java/libexec/openjdk.jdk/Contents/Home

        # Keybindings
        bindkey "^[[1;3D" backward-word # Option + L Arrow
        bindkey "^[[1;3C" forward-word  # Option + R Arrow
        ;;
    CYGWIN*)
        ;;
    MINGW*)
        ;;
    *)
        echo "Unknown OS : ${COMPUTER_OS}"
esac

[ -f ~/.aliases.zsh ] && source ~/.aliases.zsh
[ -f ~/.functions.zsh ] && source ~/.functions.zsh

[ -f ~/.cs_internal.zsh ] && source ~/.cs_internal.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh

eval "$(zoxide init zsh)"
