#!/bin/bash

# Script para actualizar dotfiles existentes

DOTFILES_DIR="$HOME/dotfiles"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo "🔄 Actualizando dotfiles..."

# Verificar que el directorio de dotfiles existe
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${RED}❌ Directorio $DOTFILES_DIR no existe${NC}"
    echo "Ejecuta primero el script de setup inicial"
    exit 1
fi

cd "$DOTFILES_DIR"

# Función para comparar y actualizar archivos
update_config() {
    local source_path="$1"
    local dest_dir="$2"
    local config_name="$3"
    
    if [[ -e "$source_path" ]]; then
        if [[ -d "$source_path" ]]; then
            # Es un directorio
            rsync -av --delete "$source_path/" "$dest_dir/"
        else
            # Es un archivo
            cp "$source_path" "$dest_dir/"
        fi
        echo -e "${GREEN}✓ Actualizado $config_name${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ $config_name no encontrado en $source_path${NC}"
        return 1
    fi
}

# Crear backup de fecha actual
backup_dir="backups/$(date +%Y%m%d_%H%M%S)"
echo -e "${BLUE}📦 Creando backup en $backup_dir${NC}"
mkdir -p "$backup_dir"

# Hacer backup de configuraciones actuales
[[ -d "nvim" ]] && cp -r nvim "$backup_dir/"
[[ -d "tmux" ]] && cp -r tmux "$backup_dir/"
[[ -f "git/.gitconfig" ]] && cp git/.gitconfig "$backup_dir/"
[[ -f "starship/starship.toml" ]] && cp starship/starship.toml "$backup_dir/"
[[ -d "github-copilot" ]] && cp -r github-copilot "$backup_dir/"
[[ -d "gh" ]] && cp -r gh "$backup_dir/"
[[ -f "fish/config.fish" ]] && cp fish/config.fish "$backup_dir/"
[[ -f "kitty/kitty.conf" ]] && cp kitty/kitty.conf "$backup_dir/"
[[ -d "hypr" ]] && cp -r hypr "$backup_dir/"
[[ -d "hyde/themes" ]] && cp -r hyde/themes "$backup_dir/"

echo -e "${BLUE}🔄 Actualizando configuraciones...${NC}"

# Actualizar Neovim
update_config "$HOME/.config/nvim" "nvim" "Neovim"

# Actualizar Tmux (verificar ambas ubicaciones)
if [[ -f "$HOME/.config/tmux/tmux.conf" ]]; then
    update_config "$HOME/.config/tmux/tmux.conf" "tmux" "Tmux (XDG)"
    # Actualizar plugins si existen
    if [[ -d "$HOME/.config/tmux/plugins" ]]; then
        update_config "$HOME/.config/tmux/plugins" "tmux" "Tmux plugins"
    fi
elif [[ -f "$HOME/.tmux.conf" ]]; then
    update_config "$HOME/.tmux.conf" "tmux" "Tmux (tradicional)"
    # Renombrar para mantener consistencia
    [[ -f "tmux/.tmux.conf" ]] && mv "tmux/.tmux.conf" "tmux/tmux.conf"
fi

# Actualizar Git
update_config "$HOME/.gitconfig" "git" "Git"

# Actualizar Starship
update_config "$HOME/.config/starship.toml" "starship" "Starship"

# Actualizar GitHub Copilot
update_config "$HOME/.config/github-copilot" "github-copilot" "GitHub Copilot"

# Actualizar GitHub CLI
update_config "$HOME/.config/gh" "gh" "GitHub CLI"

# Actualizar Fish
mkdir -p "fish"
update_config "$HOME/.config/fish/config.fish" "fish" "Fish"

# Actualizar Kitty
mkdir -p "kitty"
update_config "$HOME/.config/kitty/kitty.conf" "kitty" "Kitty"

# Actualizar Hyprland
update_config "$HOME/.config/hypr" "hypr" "Hyprland"

# Actualizar HyDE themes
mkdir -p "hyde/themes"
update_config "$HOME/.config/hyde/themes" "hyde/themes" "HyDE Themes"

# Mostrar diferencias si git está inicializado
if [[ -d ".git" ]]; then
    echo -e "\n${BLUE}📊 Cambios detectados:${NC}"
    if git diff --quiet; then
        echo -e "${GREEN}✓ No hay cambios nuevos${NC}"
    else
        echo -e "${YELLOW}Archivos modificados:${NC}"
        git diff --name-only
        
        echo -e "\n${BLUE}¿Quieres ver las diferencias detalladas? (y/N)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            git diff
        fi
        
        echo -e "\n${BLUE}¿Quieres hacer commit de los cambios? (y/N)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Ingresa el mensaje del commit:${NC}"
            read -r commit_message
            git add .
            git commit -m "$commit_message"
            echo -e "${GREEN}✅ Commit realizado${NC}"
            
            echo -e "\n${BLUE}¿Quieres hacer push? (y/N)${NC}"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                git push
                echo -e "${GREEN}✅ Push realizado${NC}"
            fi
        fi
    fi
else
    echo -e "\n${YELLOW}⚠ No hay repositorio git inicializado${NC}"
    echo -e "Considera ejecutar: git init && git add . && git commit -m 'Update dotfiles'"
fi

echo -e "\n${GREEN}✅ Actualización completada!${NC}"
echo -e "${BLUE}💾 Backup guardado en: $backup_dir${NC}"

# Mostrar resumen
echo -e "\n${BLUE}📋 Resumen:${NC}"
echo -e "- Backup creado: ✅"
echo -e "- Configuraciones actualizadas desde ~/.config"
echo -e "- Diferencias mostradas (si existen)"
echo -e "\nPara deshacer cambios: cp -r $backup_dir/* ."
