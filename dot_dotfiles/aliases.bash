# alias
alias la="ls -al --color=auto"
alias ll=la
alias g="cd ~/git/"

alias ..="cd .."
alias ...="cd ../../"

# tmux
alias tmux="tmux -2u"
alias tm="tmux attach || tmux new-session"

# Midnight Commander
alias mc="mc -x"

# Git related
alias gam="git commit --amend --no-edit"
alias gs="git status -sb"
alias gc="git fetch --all --prune && gs"
alias gl="git log --oneline"
alias gp="git remote prune origin"
alias gor="git branch -vv | grep 'origin/.*: gone'"
alias gcount="git diff --stat"
alias gu="git stash && git pull && git stash pop"

# Python 2 or 3, lesgo!
# alias python="/usr/bin/python2.7"
alias py3="/usr/bin/python3.9"
# alias pip="/usr/bin/pip"
alias pip3="/usr/bin/pip3"


man() {
    env \
        LESS_TERMCAP_mb=$(tput bold; tput setaf 1) \
        LESS_TERMCAP_md=$(tput bold; tput setaf 1) \
        LESS_TERMCAP_me=$(tput sgr0) \
        LESS_TERMCAP_se=$(tput sgr0) \
        LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) \
        LESS_TERMCAP_ue=$(tput sgr0) \
        LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2) \
        LESS_TERMCAP_mr=$(tput rev) \
        LESS_TERMCAP_mh=$(tput dim) \
        GROFF_NO_SGR=1 \
        man "$@"
}