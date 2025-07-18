-- lua/plugins/copilot.lua
return {
  "github/copilot.vim",
  event = "VeryLazy",
  config = function()
    vim.g.copilot_enabled = true
    
    -- Habilitar para todos los tipos de archivo
    vim.g.copilot_filetypes = {
      ["*"] = true,
    }
    
    -- Keymaps para copilot.vim
    vim.keymap.set('i', '<C-l>', '<Plug>(copilot-accept)', { silent = true })
    vim.keymap.set('i', '<C-]>', '<Plug>(copilot-next)', { silent = true })
    vim.keymap.set('i', '<C-[>', '<Plug>(copilot-previous)', { silent = true })
    vim.keymap.set('i', '<C-h>', '<Plug>(copilot-dismiss)', { silent = true })
  end
}
