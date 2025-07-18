vim.wo.number = true -- Make line numbers visible
vim.o.clipboard = 'unnamedplus'
vim.o.wrap = false -- Display line as one long line (default = true)
vim.o.linebreak = true --Companion to wrap, dont split words (default = false)
vim.o.autoindent = true 
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shiftwidth = 4 
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true -- conver tabs to spaces.

vim.opt.updatetime = 250 -- Respuesta más rápida
vim.opt.timeoutlen = 300 -- Timeout para keymaps

-- Configurar colores para ghost text (opcional)
vim.api.nvim_set_hl(0, "CopilotSuggestion", {
  fg = "#6b7280", -- Color gris sutil
  italic = true,
})

-- Pedir sudo cuando sea necesario.
vim.api.nvim_create_user_command('W', 'w !sudo tee % > /dev/null', {})


