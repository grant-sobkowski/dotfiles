#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

#######################
### Custom Settings ###
#######################

# Run yazi with support for changing dir in terminal on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


# nvim configurations
alias vim=nvim
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

# add go cli tools to PATH
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# claude auth stuff
source ~/.claude.sh
