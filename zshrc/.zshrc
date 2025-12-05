#############################
### KICKSTART-WSL CONFIGS ###
#############################

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Oh My Zsh
export ZSH="${HOME}/.oh-my-zsh"
export ZOXIDE_CMD_OVERRIDE="cd"
# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings#disable_magic_functions
export DISABLE_MAGIC_FUNCTIONS=true

export STARSHIP_CONFIG=${HOME}/.config/starship.toml

plugins=(aws chezmoi direnv eza git starship zoxide zsh-autosuggestions fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export AWS_CA_BUNDLE="${HOME}/.aws/combined_aws_zscaler_ca.pem"

eval "$(atuin init zsh)"

######################
### CUSTOM CONFIGS ###
######################

alias rhlogin="python ~/.gss-ansible-utils/keycloak/keycloak_cli_client.py"

source ~/.rhlogins

function jwt-decode() {
  sed 's/\./\n/g' <<< $(cut -d. -f1,2 <<< $1) | base64 --decode | jq
}

# BUILD SETTINGS FOR GLUE 5
export PATH="/home/linuxbrew/.linuxbrew/opt/openjdk@17/bin:$PATH"

# Jfrog credentials
source ~/.jfrog.sh

export EDITOR=nvim

# Gitlab CLI Configurations

export GITLAB_HOST=gitlab.ops.studentaid.gov

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

