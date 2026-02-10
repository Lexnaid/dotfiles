# Fish Shell Configuration

# Suppress greeting
set -g fish_greeting

# Initialize Starship prompt
if type -q starship
    starship init fish | source
end

# Environment variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Aliases
alias vim="nvim"
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"
alias gs="git status"
alias gp="git push"
alias gl="git pull"
alias gc="git commit"
alias ga="git add"
alias gd="git diff"
alias gco="git checkout"
alias cls="clear"

# Better directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Colorful man pages
set -gx LESS_TERMCAP_mb (printf '\e[1;32m')
set -gx LESS_TERMCAP_md (printf '\e[1;32m')
set -gx LESS_TERMCAP_me (printf '\e[0m')
set -gx LESS_TERMCAP_se (printf '\e[0m')
set -gx LESS_TERMCAP_so (printf '\e[01;33m')
set -gx LESS_TERMCAP_ue (printf '\e[0m')
set -gx LESS_TERMCAP_us (printf '\e[1;4;31m')

# Path additions (if needed)
fish_add_path ~/.local/bin

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish

# Bootdev Path
fish_add_path ~/go/bin
