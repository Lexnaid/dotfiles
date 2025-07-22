-- init.lua
-- Configuración principal de Neovim



-- Cargar configuraciones del core primero
require('core.options')
require('core.keymaps')

-- Configurar lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configurar plugins
require('lazy').setup('plugins')


-- Inicializar gestor de temas
require('themes').setup()
