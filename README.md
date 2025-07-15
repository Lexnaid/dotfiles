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
