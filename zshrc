# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# My favourite aliases :) 
alias vim="lvim"
alias clc="clear"
alias nix-edit="sudo lvim ~/dotfiles/configuration.nix"
alias nix-reload="sudo nixos-rebuild switch"
alias ls="eza"
alias tree="eza -T"
alias lsl="eza -l"
alias lsa="eza -a"

# Environment variables
export EZA_ICONS_AUTO='always'

# Enable zoxide
eval "$(zoxide init zsh)"

# This lets yazi exit into the directory you are in
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
