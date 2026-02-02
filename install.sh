#!/bin/bash

# Dotfiles installation script

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$DOTFILES_DIR/backups/$(date +%Y%m%d_%H%M%S)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Load environment variables
if [[ -f "$DOTFILES_DIR/.env" ]]; then
    set -a
    source "$DOTFILES_DIR/.env"
    set +a
    echo -e "${GREEN}✓ Environment variables loaded${NC}"
else
    echo -e "${RED}✗ .env file not found. Copy .env.example to .env and configure it.${NC}"
    exit 1
fi

# Function to backup existing files/directories
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        local backup_name=$(basename "$target")
        mv "$target" "$BACKUP_DIR/$backup_name"
        echo -e "${YELLOW}⚠ Backed up: $target → $BACKUP_DIR/$backup_name${NC}"
    fi
}

# Function to create symlinks
create_symlink() {
    local source="$1"
    local target="$2"

    backup_if_exists "$target"

    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"

    ln -sf "$source" "$target"
    echo -e "${GREEN}✓ Linked: $source → $target${NC}"
}

# Function to substitute environment variables in template files
substitute_env_vars() {
    local template_file="$1"
    local output_file="$2"

    if [[ -f "$template_file" ]]; then
        mkdir -p "$(dirname "$output_file")"
        envsubst < "$template_file" > "$output_file"
        echo -e "${GREEN}✓ Generated: $output_file${NC}"
    else
        echo -e "${RED}✗ Template not found: $template_file${NC}"
    fi
}

echo -e "\n🚀 Installing dotfiles...\n"

# Neovim configuration
echo -e "📝 Configuring Neovim..."
if [[ -d "$DOTFILES_DIR/nvim" ]]; then
    backup_if_exists "$HOME/.config/nvim"
    mkdir -p "$HOME/.config"
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    echo -e "${GREEN}✓ Neovim configured${NC}"
fi

# Starship configuration
echo -e "\n⭐ Configuring Starship..."
if [[ -f "$DOTFILES_DIR/starship/starship.toml" ]]; then
    backup_if_exists "$HOME/.config/starship.toml"
    mkdir -p "$HOME/.config"
    ln -sf "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
    echo -e "${GREEN}✓ Starship configured${NC}"
fi

# WezTerm configuration
echo -e "\n💻 Configuring WezTerm..."
if [[ -f "$DOTFILES_DIR/wezterm/wezterm.lua" ]]; then
    backup_if_exists "$HOME/.config/wezterm"
    mkdir -p "$HOME/.config/wezterm"
    ln -sf "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
    echo -e "${GREEN}✓ WezTerm configured${NC}"
fi

# Kitty configuration
echo -e "\n🐱 Configuring Kitty..."
if [[ -f "$DOTFILES_DIR/kitty/kitty.conf" ]]; then
    backup_if_exists "$HOME/.config/kitty"
    mkdir -p "$HOME/.config/kitty"
    ln -sf "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
    echo -e "${GREEN}✓ Kitty configured${NC}"
fi

# Fish shell configuration
echo -e "\n🐟 Configuring Fish..."
if [[ -f "$DOTFILES_DIR/fish/config.fish" ]]; then
    backup_if_exists "$HOME/.config/fish"
    mkdir -p "$HOME/.config/fish"
    ln -sf "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
    echo -e "${GREEN}✓ Fish configured${NC}"
fi

# Git configuration
echo -e "\n🌿 Configuring Git..."
if [[ -f "$DOTFILES_DIR/git/.gitconfig.template" ]]; then
    backup_if_exists "$HOME/.gitconfig"
    substitute_env_vars "$DOTFILES_DIR/git/.gitconfig.template" "$HOME/.gitconfig"
elif [[ -f "$DOTFILES_DIR/git/.gitconfig" ]]; then
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
fi

# GitHub CLI configuration
echo -e "\n🐙 Configuring GitHub CLI..."
if [[ -d "$DOTFILES_DIR/gh" ]]; then
    backup_if_exists "$HOME/.config/gh"
    mkdir -p "$HOME/.config/gh"

    # Copy static config
    if [[ -f "$DOTFILES_DIR/gh/config.yml" ]]; then
        cp "$DOTFILES_DIR/gh/config.yml" "$HOME/.config/gh/"
        echo -e "${GREEN}✓ Copied gh/config.yml${NC}"
    fi

    # Generate hosts.yml from template
    if [[ -f "$DOTFILES_DIR/gh/hosts.yml.template" ]]; then
        substitute_env_vars "$DOTFILES_DIR/gh/hosts.yml.template" "$HOME/.config/gh/hosts.yml"
    fi

    echo -e "${GREEN}✓ GitHub CLI configured${NC}"
fi

# GitHub Copilot configuration
echo -e "\n🤖 Configuring GitHub Copilot..."
if [[ -d "$DOTFILES_DIR/github-copilot" ]]; then
    backup_if_exists "$HOME/.config/github-copilot"
    mkdir -p "$HOME/.config/github-copilot"

    # Copy versions.json (not sensitive)
    if [[ -f "$DOTFILES_DIR/github-copilot/versions.json" ]]; then
        cp "$DOTFILES_DIR/github-copilot/versions.json" "$HOME/.config/github-copilot/"
        echo -e "${GREEN}✓ Copied versions.json${NC}"
    fi

    # Generate apps.json from template
    if [[ -f "$DOTFILES_DIR/github-copilot/apps.json.template" ]]; then
        substitute_env_vars "$DOTFILES_DIR/github-copilot/apps.json.template" "$HOME/.config/github-copilot/apps.json"
    fi

    echo -e "${GREEN}✓ GitHub Copilot configured${NC}"
fi

echo -e "\n${GREEN}✅ Dotfiles installation complete!${NC}"

if [[ -d "$BACKUP_DIR" ]]; then
    echo -e "\n${YELLOW}Backups saved to: $BACKUP_DIR${NC}"
fi

echo -e "\nNext steps:"
echo -e "  • Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
echo -e "  • Open Neovim to let plugins install: nvim"
echo -e "  • Verify GitHub CLI: gh auth status"
