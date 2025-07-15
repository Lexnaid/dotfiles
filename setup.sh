#!/bin/bash

# Script para configurar dotfiles por primera vez

DOTFILES_DIR="$HOME/dotfiles"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🚀 Configurando dotfiles por primera vez..."

# Crear directorio de dotfiles
mkdir -p "$DOTFILES_DIR"
cd "$DOTFILES_DIR"

# Crear estructura de directorios
echo -e "${YELLOW}Creando estructura de directorios...${NC}"
mkdir -p nvim tmux git starship github-copilot gh

# Copiar configuraciones existentes
echo -e "${YELLOW}Copiando configuraciones existentes...${NC}"

# Neovim - copiar toda la carpeta
if [[ -d "$HOME/.config/nvim" ]]; then
    cp -r "$HOME/.config/nvim"/* nvim/
    echo -e "${GREEN}✓ Copiada configuración completa de Neovim${NC}"
else
    echo "# Configuración básica de Neovim" > nvim/init.lua
    echo -e "${YELLOW}⚠ Creada configuración básica de Neovim${NC}"
fi

# Tmux - verificar ambas ubicaciones
if [[ -f "$HOME/.config/tmux/tmux.conf" ]]; then
    cp "$HOME/.config/tmux/tmux.conf" tmux/
    # Copiar plugins si existen
    if [[ -d "$HOME/.config/tmux/plugins" ]]; then
        cp -r "$HOME/.config/tmux/plugins" tmux/
        echo -e "${GREEN}✓ Copiada configuración de Tmux (XDG) con plugins${NC}"
    else
        echo -e "${GREEN}✓ Copiada configuración de Tmux (XDG)${NC}"
    fi
elif [[ -f "$HOME/.tmux.conf" ]]; then
    cp "$HOME/.tmux.conf" tmux/
    echo -e "${GREEN}✓ Copiada configuración de Tmux (tradicional)${NC}"
else
    cat > tmux/.tmux.conf << 'EOF'
# Configuración básica de Tmux
set -g default-terminal "screen-256color"
set -g mouse on
set -g base-index 1
setw -g pane-base-index 1

# Cambiar prefix a Ctrl+a
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Atajos para dividir ventanas
bind | split-window -h
bind - split-window -v

# Recarga de configuración
bind r source-file ~/.tmux.conf \; display "Configuración recargada!"
EOF
    echo -e "${YELLOW}⚠ Creada configuración básica de Tmux${NC}"
fi

# Git
if [[ -f "$HOME/.gitconfig" ]]; then
    cp "$HOME/.gitconfig" git/
    echo -e "${GREEN}✓ Copiada configuración de Git${NC}"
else
    cat > git/.gitconfig << 'EOF'
[user]
    name = Tu Nombre
    email = tu.email@ejemplo.com

[core]
    editor = nvim
    autocrlf = input

[init]
    defaultBranch = main

[push]
    default = simple

[pull]
    rebase = false

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    lg = log --oneline --graph --decorate --all
EOF
    echo -e "${YELLOW}⚠ Creada configuración básica de Git (edita tu nombre y email)${NC}"
fi

# Starship
if [[ -f "$HOME/.config/starship.toml" ]]; then
    cp "$HOME/.config/starship.toml" starship/
    echo -e "${GREEN}✓ Copiada configuración de Starship${NC}"
else
    cat > starship/starship.toml << 'EOF'
# Configuración de Starship
format = """
[](#9A348E)\
$os\
$username\
[](bg:#DA627D fg:#9A348E)\
$directory\
[](fg:#DA627D bg:#FCA17D)\
$git_branch\
$git_status\
[](fg:#FCA17D bg:#86BBD8)\
$c\
$elixir\
$elm\
$golang\
$gradle\
$haskell\
$java\
$julia\
$nodejs\
$nim\
$rust\
$scala\
[](fg:#86BBD8 bg:#06969A)\
$docker_context\
[](fg:#06969A bg:#33658A)\
$time\
[ ](fg:#33658A)\
"""

[os]
format = "[$symbol]($style)"
style = "bg:#9A348E"
disabled = false

[username]
show_always = true
style_user = "bg:#9A348E"
style_root = "bg:#9A348E"
format = '[$user ]($style)'
disabled = false

[directory]
style = "bg:#DA627D"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = ""
style = "bg:#FCA17D"
format = '[ $symbol $branch ]($style)'

[git_status]
style = "bg:#FCA17D"
format = '[$all_status$ahead_behind ]($style)'

[nodejs]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[time]
disabled = false
time_format = "%R"
style = "bg:#33658A"
format = '[ ♥ $time ]($style)'
EOF
    echo -e "${YELLOW}⚠ Creada configuración básica de Starship${NC}"
fi

# GitHub Copilot
if [[ -d "$HOME/.config/github-copilot" ]]; then
    cp -r "$HOME/.config/github-copilot"/* github-copilot/
    echo -e "${GREEN}✓ Copiada configuración de GitHub Copilot${NC}"
else
    mkdir -p github-copilot
    echo -e "${YELLOW}⚠ Directorio de GitHub Copilot creado${NC}"
fi

# GitHub CLI
if [[ -d "$HOME/.config/gh" ]]; then
    cp -r "$HOME/.config/gh"/* gh/
    echo -e "${GREEN}✓ Copiada configuración de GitHub CLI${NC}"
else
    mkdir -p gh
    echo -e "${YELLOW}⚠ Directorio de GitHub CLI creado${NC}"
fi

# Crear README
cat > README.md << 'EOF'
# Mis Dotfiles

Configuraciones personales para desarrollo.

## Contenido

- **nvim/**: Configuración de Neovim (con lazy.nvim y plugins)
- **tmux/**: Configuración de Tmux (formato XDG)
- **git/**: Configuración de Git
- **starship/**: Configuración de Starship prompt
- **github-copilot/**: Configuración de GitHub Copilot
- **gh/**: Configuración de GitHub CLI

## Instalación

```bash
git clone https://github.com/tuusuario/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## Programas requeridos

- [Neovim](https://neovim.io/)
- [Tmux](https://github.com/tmux/tmux)
- [Git](https://git-scm.com/)
- [Starship](https://starship.rs/)
- [GitHub CLI](https://cli.github.com/)
- [GitHub Copilot](https://github.com/features/copilot)

## Compatibilidad

Compatible con:
- WSL (Windows Subsystem for Linux)
- Linux (Ubuntu, Arch, etc.)
- macOS

## GitHub Copilot

Para configurar GitHub Copilot en Neovim, agrega esto a tu `init.lua`:

```lua
-- Instalar vim-plug si no existe
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug 'github/copilot.vim'
vim.call('plug#end')
```

Luego ejecuta `:PlugInstall` y `:Copilot setup` en Neovim.
EOF

echo -e "\n${GREEN}✅ Setup completado!${NC}"
echo -e "\nPróximos pasos:"
echo -e "1. cd ~/dotfiles"
echo -e "2. git init"
echo -e "3. git add ."
echo -e "4. git commit -m 'Initial dotfiles setup'"
echo -e "5. Crea un repositorio en GitHub y push"
echo -e "6. Ejecuta ./install.sh para crear los symlinks"
