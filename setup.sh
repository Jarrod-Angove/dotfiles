#! /bin/sh

# remove the empty nix config from etc so symlink can be created from dotfiles directory
sudo rm -f /etc/nixos/configuration.nix

# remove the hardware config in the dotfiles if it exists because  we don't want hardware on 
# another machine to be configured to another system
sudo rm -f ~/dotfiles/hardware-configuration.nix

# hardware config is the only config I am leaving in its original place
sudo ln -fs /etc/nixos/hardware-configuration.nix ~/dotfiles/hardware-configuration.nix

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

sudo nixos-rebuild switch
