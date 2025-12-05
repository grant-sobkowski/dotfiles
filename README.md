# dotfiles

This is my collection of dotfiles, there are many dotfiles like them - but these are my own.

## Use dotfiles with stow

```sh
# Install stow - Arch (btw)
sudo pacman -S stow

cd ~
git clone https://github.com/grant-sobkowski/dotfiles.git && cd dotfiles
# nvim/.config/nvim is a git submodule pointing to my fork of kickstart-nvim
git submodule update --init --recursive

stow nvim
stow bash
stow zshrc
```

Note: the above setup only works if you clone the repo from HOME.

