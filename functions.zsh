#!/bin/zsh


#############
# Git stuff #
#############

# Git interactibe diff
function gdiff() {
    [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ] || return
    PREVIEW="git diff $@ --color=always -- {-1}"
    FILE=$(git diff $@ --name-only | fzf -m --ansi --preview $PREVIEW --info=inline --border --preview-window 'up,90%,border-bottom,+{2}+3/3,~3')
    if [[ $? -eq 0 ]]; then
        git add $FILE && echo "git added '$FILE'"
    fi
}

# Git interactive checkout
function gico() {
    git branch --sort=-committerdate | grep -v "^\*" | fzf --height=20% --reverse --info=inline | xargs git checkout
}

# Remove empty terraform workspaces
function tf_rm_ws() {
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

# Terraform format & lint recursively. $1 optional path
function tf_fmta() {
    DIR=$1
    for TF_DIR in $(fd -H -p --type=f "\.(tf?)$" --exclude ".terraform" $DIR | sed -E 's|/[^/]+$|/|' | uniq); do
        (
            echo "[INFO] Formating $TF_DIR" && \
            cd "$TF_DIR" &&  \
            rm -rf .terraform && \
            t init > /dev/null && \
            tlock && \
            tfmt
        )
    done

    for TF_VAR in $(fd -H -p --type=f "\.(vars?)$" --exclude ".terraform" $DIR | sed -E 's|/[^/]+$|/|' | uniq); do
        (
            echo "[INFO] Formating $TF_VAR" && \
            cd "$TF_VAR" && \
            terraform fmt -recursive .
        )
    done
}

# Init terraform modules recursively. $1 optional path
function tf_init() {
    DIR=$1
    for TF_DIR in $(fd -H -p --type=f "\.(tf?)$" --exclude ".terraform" $DIR | sed -E 's|/[^/]+$|/|' | uniq); do
        if [[ -d "$TF_DIR" ]]; then
            (
                echo "[INFO] Init $TF_DIR" && \
                cd "$TF_DIR" && \
                rm -rf .terraform && \
                rm -rf .terraform.lock.hcl && \
                t init > /dev/null && \
                tlock
            )
        else
            echo "[INFO] Init current directory" && \
            rm -rf .terraform && \
            rm -rf .terraform.lock.hcl && \
            t init > /dev/null && \
            tlock
            break
        fi
    done
}

# Show resource in state and describe it
function tf_sl() {
  t state list | fzf -m --preview "terraform state show {}" | xargs -0 -I {} terraform state show '{}'
}

# Allow to terraform target a single file inside a module (terrafrom plan $(tf_target_file <filename>)
function tf_target_file() {
    cat $1 | hcledit block list | sed 's/resource\.//' | sed 's/^#\?/-target=/' | tr '\n' ' ' | sed '$s/ $/\n/'
}

# Stolen from https://github.com/hashicorp/terraform-provider-helm/issues/1121#issuecomment-1719642465
function terraform-diff () {
    TEMP=$(mktemp -d)
    RESOURCE=$1
    TF_VAR=$2

    echo "Generating a diff of '$1' in '$TEMP'"

    terraform plan -var-file=$TF_VAR -out=$TEMP/tfplan >/dev/null
    terraform show -json $TEMP/tfplan | jq -r '.resource_changes[] | select(.address=="'"$RESOURCE"'") | .change.before.values | add' > $TEMP/before.txt
    terraform show -json $TEMP/tfplan | jq -r '.resource_changes[] | select(.address=="'"$RESOURCE"'") | .change.after.values | add' > $TEMP/after.txt

    /usr/bin/diff -u --color=always $TEMP/before.txt $TEMP/after.txt | sed -e '1,2d'
}


####################
# Kubernetes stuff #
####################

# Print all different Kubelet versions in all contexts grouped by labels nodegroup/agentpool (eks/aks)
function k_nv() {
    all=false
    while getopts "ha" option; do
      case ${option} in
        a)
          all=true;;
        \?)
          echo "Error: Invalid option"
          return;;
      esac
    done

    cmd="kubectl get nodes -o jsonpath=\"{range .items[*]}{.status.nodeInfo.kubeletVersion}{' - '}{.metadata.labels.nodegroup}{.metadata.labels.agentpool}{'\n'}{end}\" | sort | uniq -c"


    if [[ "$all" == true ]]; then
      for KCTX in $(kubie ctx | sort); do
          (
            kubie ctx $KCTX 2> /dev/null
            echo $KCTX
            eval $cmd
          )
      done
    else
      eval $cmd
    fi
}

function describe_zsh_func() {
    perl -0777 -ne '
    use Term::ANSIColor;
    while (/^((?:[ \t]*\#.*\n)*)               # preceding comments
             [ \t]*(?:(\w+)[ \t]*\(\)|         # foo ()
                      function[ \t]+(\w+).*)   # function foo
             ((?:\n[ \t]+\#.*)*)               # following comments
           /mgx) {
        $name = "$2$3";
        $comments = "$1$4";
        $comments =~ s/^[ \t]*#+//mg;
        chomp($comments);
        print color("bold red");
        print "$name():";
        print color("reset");
        print color("italic green");
        print "$comments\n";
        print color("reset");
    }' ~/.functions.zsh
}

function klogs() {
  pod="$(kubectl get pods -o wide | tail -n+2 | fzf -n1 --reverse --tac --preview='kubectl logs --tail=20 --all-containers=true {1}' --preview-window=down:50%:hidden --bind=ctrl-p:toggle-preview --header="^P: Preview Logs" | awk '{print $1}')"
  if [[ -n $pod ]]; then
    kubectl logs --all-containers=true $pod
  fi
}

function kg() {
    kubectl get $1 -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}' | fzf --preview="echo '{}' | xargs kubectl get $1 -o yaml -n | bat --color=always -l yaml --style plain" | xargs kubectl get $1 -n
}

#############
# AWS stuff #
#############

function awsp() {
    _SSO=$(yq '.SSOConfig | keys | .[]' ~/.aws-sso/config.yaml |fzf)
    eval $(aws-sso eval -p $(aws-sso list --sso "${_SSO}" Profile --csv |fzf))
}

function awsconsole () {
    _SSO=$(yq '.SSOConfig | keys | .[]' ~/.aws-sso/config.yaml |fzf)
    aws-sso console -u open-url-in-container -p "$(aws-sso list --sso "${_SSO}" Profile --csv |fzf)"
}
