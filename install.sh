#!/bin/bash

# Load environment variables
if [[ -f "$DOTFILES_DIR/.env" ]]; then
    source "$DOTFILES_DIR/.env"
    echo -e "${GREEN}✓ Environment variables loaded${NC}"
else
    echo -e "${RED}✗ .env file not found. Copy .env.example to .env and configure it.${NC}"
    exit 1
fi

# Function to substitute environment variables in template files
substitute_env_vars() {
    local template_file="$1"
    local output_file="$2"
    
    if [[ -f "$template_file" ]]; then
        envsubst < "$template_file" > "$output_file"
        echo -e "${GREEN}✓ Generated: $output_file${NC}"
    else
        echo -e "${RED}✗ Template not found: $template_file${NC}"
    fi
}

# GitHub CLI configuration
echo -e "\n🐙 Configuring GitHub CLI..."
if [[ -d "$DOTFILES_DIR/gh" ]]; then
    backup_if_exists "$HOME/.config/gh"
    mkdir -p "$HOME/.config/gh"
    
    # Copy static config
    if [[ -f "$DOTFILES_DIR/gh/config.yml" ]]; then
        cp "$DOTFILES_DIR/gh/config.yml" "$HOME/.config/gh/"
    fi
    
    # Generate hosts.yml from template
    substitute_env_vars "$DOTFILES_DIR/gh/hosts.yml.template" "$HOME/.config/gh/hosts.yml"
    
    echo -e "${GREEN}✓ GitHub CLI configured with environment variables${NC}"
fi

# GitHub Copilot configuration  
echo -e "\n🤖 Configuring GitHub Copilot..."
if [[ -d "$DOTFILES_DIR/github-copilot" ]]; then
    backup_if_exists "$HOME/.config/github-copilot"
    mkdir -p "$HOME/.config/github-copilot"
    
    # Copy versions.json (not sensitive)
    if [[ -f "$DOTFILES_DIR/github-copilot/versions.json" ]]; then
        cp "$DOTFILES_DIR/github-copilot/versions.json" "$HOME/.config/github-copilot/"
    fi
    
    # Generate apps.json from template
    substitute_env_vars "$DOTFILES_DIR/github-copilot/apps.json.template" "$HOME/.config/github-copilot/apps.json"
    
    echo -e "${GREEN}✓ GitHub Copilot configured with environment variables${NC}"
fi

# Git configuration with environment variables
echo -e "\n🌿 Configuring Git..."
if [[ -f "$DOTFILES_DIR/git/.gitconfig.template" ]]; then
    substitute_env_vars "$DOTFILES_DIR/git/.gitconfig.template" "$HOME/.gitconfig"
else
    # Fallback to existing .gitconfig
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
fi
