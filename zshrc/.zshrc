export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export EDITOR=nvim

eval "$(atuin init zsh)"

# Shell wrapper which allows you to change workdir when exiting yazi.
# Use y instead of yazi to start, then press q to quit.
# If you don't want to change dirs on exit, use Q instead.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

source ~/.jfrog.sh
