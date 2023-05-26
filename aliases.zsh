# BASE
alias c='clear'
alias vi='nvim'
alias vim='nvim'
alias l='ls -ltrah'

if type lsd >/dev/null 2>&1; then;
    alias ls='lsd'
fi

if type gawk >/dev/null 2>&1; then;
    alias awk='gawk'
fi

if type icdiff >/dev/null 2>&1; then;
    alias diff='icdiff'
fi

if type fzf >/dev/null 2>&1; then;
    alias preview='fzf --preview "bat {-1} --color=always"'
fi

if type bat >/dev/null 2>&1; then;
    alias cat="bat --style='header'"
    alias catn="bat --style='numbers'"
fi

# TERRAFORM
if type simple-tfswitch >/dev/null 2>&1; then;
    alias t='simple-tfswitch'
    alias tlock='t providers lock -platform=linux_amd64 -platform=windows_amd64 -platform=darwin_amd64 -platform=darwin_arm64 -platform=linux_arm64'
    alias tfmt='t fmt -recursive -diff . && tflint && t validate'
    alias twl='t workspace list'
    alias tws='t workspace select'
    alias twselect='tws $(twl | cut -c3- | fzf --height=20% --reverse)'
    alias twc='t workspace new'
    alias tsp='t state pull > $(t workspace show)_state.json'
fi

# KUBERNETES
if type kubie >/dev/null 2>&1; then;
 alias kctx='kubie ctx'
 alias kns='kubie ns'
fi
if type kubectl >/dev/null 2>&1; then;
    alias k='kubectl'
    alias kevents='k get events --sort-by=".lastTimestamp"'
    alias kgp='k get pods -o wide'
    alias kgn='k get nodes -o wide'
    alias kgd='k get deployments -o wide'
    alias kgs='k get svc -o wide'
    alias kgi='k get ingress'
    alias kgctn="k get po -o jsonpath='{range .items[*]}{\"pod: \"}{.metadata.name}{\"\n\"}{range .spec.containers[*]}{\"\tname: \"}{.name}{\"\n\timage: \"}{.image}{\"\n\"}{end}'"
fi

# GITHUB
alias ghstatus="curl -fsSL https://www.githubstatus.com/api/v2/summary.json | jq -r '.incidents[] | \"\(.name) \(.shortlink)\"'"

# TMUX
alias tma='tmux attach'
alias tmka='tmux kill-session -a'
alias tmls='tmux ls'

# Cheatsheet
alias cheatsheet='glow $(fd --glob "*.md" "$HOME/dev/docs" | fzf --header "Choose documentation:" --preview "bat --color=always --style=header {}") --pager'
