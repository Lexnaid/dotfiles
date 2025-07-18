#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directorio de dotfiles
DOTFILES_DIR="$HOME/dotfiles"

# Función para crear backup
backup_if_exists() {
    if [[ -e "$1" ]]; then
        echo -e "${YELLOW}Creando backup de $1${NC}"
        mv "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
    fi
}

# Función para crear symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ -f "$source" ]]; then
        # Crear directorio padre si no existe
        mkdir -p "$(dirname "$target")"
        
        # Hacer backup del archivo existente
        backup_if_exists "$target"
        
        # Crear symlink
        ln -sf "$source" "$target"
        echo -e "${GREEN}✓ Symlink creado: $target -> $source${NC}"
    else
        echo -e "${RED}✗ No se encontró: $source${NC}"
    fi
}

echo "🔧 Instalando dotfiles..."
echo "Directorio de dotfiles: $DOTFILES_DIR"

# Verificar que estamos en el directorio correcto
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${RED}Error: No se encontró el directorio $DOTFILES_DIR${NC}"
    exit 1
fi

# Neovim - copiar toda la carpeta
echo -e "\n📝 Configurando Neovim..."
if [[ -d "$DOTFILES_DIR/nvim" ]]; then
    backup_if_exists "$HOME/.config/nvim"
    mkdir -p "$HOME/.config/nvim"
    cp -r "$DOTFILES_DIR/nvim"/* "$HOME/.config/nvim/"
    echo -e "${GREEN}✓ Configuración de Neovim copiada${NC}"
fi

# Tmux - soportar formato XDG
echo -e "\n🖥️  Configurando Tmux..."
if [[ -f "$DOTFILES_DIR/tmux/tmux.conf" ]]; then
    # Formato XDG
    mkdir -p "$HOME/.config/tmux"
    backup_if_exists "$HOME/.config/tmux/tmux.conf"
    cp "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/"
    
    # Copiar plugins si existen
    if [[ -d "$DOTFILES_DIR/tmux/plugins" ]]; then
        cp -r "$DOTFILES_DIR/tmux/plugins" "$HOME/.config/tmux/"
        echo -e "${GREEN}✓ Configuración de Tmux (XDG) con plugins copiada${NC}"
    else
        echo -e "${GREEN}✓ Configuración de Tmux (XDG) copiada${NC}"
    fi
elif [[ -f "$DOTFILES_DIR/tmux/.tmux.conf" ]]; then
    # Formato tradicional
    create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

# Git
echo -e "\n🌿 Configurando Git..."
create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Starship (funciona en WSL, Linux, macOS)
echo -e "\n🚀 Configurando Starship..."
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# GitHub Copilot
echo -e "\n🤖 Configurando GitHub Copilot..."
if [[ -d "$DOTFILES_DIR/github-copilot" ]]; then
    backup_if_exists "$HOME/.config/github-copilot"
    mkdir -p "$HOME/.config/github-copilot"
    cp -r "$DOTFILES_DIR/github-copilot"/* "$HOME/.config/github-copilot/"
    echo -e "${GREEN}✓ Configuración de GitHub Copilot copiada${NC}"
fi

# GitHub CLI
echo -e "\n🐙 Configurando GitHub CLI..."
if [[ -d "$DOTFILES_DIR/gh" ]]; then
    backup_if_exists "$HOME/.config/gh"
    mkdir -p "$HOME/.config/gh"
    cp -r "$DOTFILES_DIR/gh"/* "$HOME/.config/gh/"
    echo -e "${GREEN}✓ Configuración de GitHub CLI copiada${NC}"
fi

echo -e "\n🖥️  Configurando WezTerm..."
if [[ -d "$DOTFILES_DIR/wezterm" ]]; then
    mkdir -p "$HOME/.config/wezterm"
    cp -r "$DOTFILES_DIR/wezterm"/* "$HOME/.config/wezterm/"
    echo -e "${GREEN}✓ Configuración de WezTerm copiada${NC}"
fi

echo -e "\n${GREEN}✅ Instalación completada!${NC}"
echo -e "\nPara aplicar los cambios:"
echo -e "  - Reinicia tu terminal o ejecuta: source ~/.bashrc (o ~/.zshrc)"
echo -e "  - Para tmux: tmux source-file ~/.tmux.conf"
echo -e "  - Para nvim: Los cambios se aplicarán al reiniciar"
echo -e "  - Wezterm deberia actualizarse por su cuenta"

# Verificar instalaciones
echo -e "\n🔍 Verificando instalaciones..."
command -v nvim >/dev/null 2>&1 && echo -e "${GREEN}✓ Neovim instalado${NC}" || echo -e "${RED}✗ Neovim no encontrado${NC}"
command -v tmux >/dev/null 2>&1 && echo -e "${GREEN}✓ Tmux instalado${NC}" || echo -e "${RED}✗ Tmux no encontrado${NC}"
command -v git >/dev/null 2>&1 && echo -e "${GREEN}✓ Git instalado${NC}" || echo -e "${RED}✗ Git no encontrado${NC}"
command -v starship >/dev/null 2>&1 && echo -e "${GREEN}✓ Starship instalado${NC}" || echo -e "${RED}✗ Starship no encontrado${NC}"
command -v gh >/dev/null 2>&1 && echo -e "${GREEN}✓ GitHub CLI instalado${NC}" || echo -e "${RED}✗ GitHub CLI no encontrado${NC}"
command -v wezterm >/dev/null 2>&1 && echo -e "${GREEN} Wezterm instalado${NC}" || echo -e "${RED}x Wezterm no encontrado ${NC}"                        

# Verificar GitHub Copilot
if [[ -f "$HOME/.config/github-copilot/apps.json" ]]; then
    echo -e "${GREEN}✓ GitHub Copilot configurado${NC}"
else
    echo -e "${YELLOW}⚠ GitHub Copilot no configurado${NC}"
fi
