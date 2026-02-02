#!/bin/bash

# Script para instalar paquetes necesarios para Hyprland + Caelestia
# Ejecutar con: ./packages-hyprland.sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Instalando paquetes para Hyprland + Caelestia...${NC}\n"

# Verificar si es Arch Linux
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}❌ Este script es solo para Arch Linux (pacman)${NC}"
    exit 1
fi

# Verificar si yay está instalado
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}⚠ yay no está instalado. Instalando...${NC}"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si
    cd -
fi

echo -e "${BLUE}📦 Instalando paquetes base de Hyprland...${NC}"
sudo pacman -S --needed \
    hyprland \
    kitty \
    firefox \
    swww \
    wl-clipboard \
    cliphist \
    polkit-gnome \
    grim \
    slurp \
    hyprpicker

echo -e "\n${BLUE}📦 Instalando Caelestia Shell (AUR)...${NC}"
yay -S --needed \
    quickshell-git \
    caelestia-shell \
    caelestia-cli

echo -e "\n${BLUE}📦 Instalando herramientas de temas...${NC}"
sudo pacman -S --needed \
    qt5ct \
    qt6ct \
    adw-gtk-theme \
    papirus-icon-theme

echo -e "\n${BLUE}📦 Instalando file manager y utilidades...${NC}"
sudo pacman -S --needed \
    thunar \
    thunar-volman \
    gvfs \
    tumbler \
    ffmpegthumbnailer

echo -e "\n${BLUE}📦 Instalando fuentes...${NC}"
sudo pacman -S --needed \
    ttf-jetbrains-mono-nerd \
    noto-fonts \
    noto-fonts-emoji

echo -e "\n${GREEN}✅ Paquetes instalados!${NC}"
echo -e "\n${YELLOW}Próximos pasos:${NC}"
echo -e "1. Ejecuta ./install.sh para crear los symlinks"
echo -e "2. Reinicia o inicia sesión en Hyprland"
echo -e "3. El shell de Caelestia debería iniciar automáticamente"
