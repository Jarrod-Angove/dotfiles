#! /bin/sh

# enter the following to start setup:
# sudo chmod +x ./setup.sh
# sudo ./setup.sh

# remove the empty nix config from etc so symlink can be created from dotfiles directory
sudo rm -f /etc/nixos/configuration.nix

# remove the hardware config in the dotfiles if it exists because  we don't want hardware on 
# another machine to be configured to another system
sudo rm -f ~/dotfiles/hardware-configuration.nix

sudo cp /etc/nixos/hardware-configuration.nix ~/dotfiles/hardware-configuration.nix
sudo ln -fs ~/dotfiles/hardware-configuration.nix /etc/nixos/hardware-configuration.nix

# hardware config is the only config I am leaving in its original place
sudo ln -fs 

sudo ln -fs ~/dotfiles/configuration.nix /etc/nixos/configuration.nix
sudo ln -fs ~/dotfiles/flake.nix /etc/nixos/flake.nix

mkdir -p ~/.config/alacritty/
ln -fs ~/dotfiles/alacritty.toml ~/.config/alacritty/alacritty.toml

ln -fs ~/dotfiles/zshrc ~/.zshrc

mkdir -p ~/.config/polybar/
ln -fs ~/dotfiles/polybarconfig.ini ~/.config/polybar/config.ini

mkdir -p ~/.config/i3/
ln -fs ~/dotfiles/i3config ~/.config/i3/config

ln -fs ~/dotfiles/gitconfig ~/.gitconfig

mkdir -p ~/.config/lvim/
ln -fs ~/dotfiles/lvim_conf.lua ~/.config/lvim/config.lua

ln -fs ~/dotfiles/p10k.zsh ~/.p10k.zsh

sudo nixos-rebuild switch
