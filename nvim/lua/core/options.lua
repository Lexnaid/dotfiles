vim.wo.number = true -- Make line numbers visible
vim.wo.relativenumber = true -- Relative line numbers
vim.wo.signcolumn = 'yes' -- Always show the sign column (for diagnostics, etc.)
vim.o.mouse = 'a' -- Enable mouse support
vim.o.termguicolors = true -- Enable 24-bit RGB colores
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
vim.o.smartindent = true -- Smart autoindenting on new lines
vim.o.backup = false -- No backup files
vim.o.writebackup = false -- No backup files on write 
vim.o.swapfile = false -- No swap files
vim.o.undofile = true -- Enable persistent undofile
vim.o.undolevels = 1000 -- Number of undos to keeping
vim.o.undoreload = 10000 -- Number of lines to keep in the undo history 
vim.o.scrolloff = 8 -- Keep 8 lines above/below the cursor
vim.o.sidescrolloff = 8 -- Keep 8 columns to the left/right of the cursor
vim.opt.fillchars:append({ eob = " " }) -- Hide ~ end of buffer markers

vim.opt.updatetime = 250 -- Respuesta más rápida
vim.opt.timeoutlen = 300 -- Timeout para keymaps

-- Configurar colores para ghost text (opcional)
vim.api.nvim_set_hl(0, "CopilotSuggestion", {
  fg = "#6b7280", -- Color gris sutil
  italic = true,
})

-- Pedir sudo cuando sea necesario.
vim.api.nvim_create_user_command('W', 'w !sudo tee % > /dev/null', {})


