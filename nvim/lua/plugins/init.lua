-- lua/plugins.lua
-- Configuración de plugins para lazy.nvim

return {
  -- Tema poimandres
  {
    'olivercederborg/poimandres.nvim',
    lazy = false,
    priority = 1000,
    -- No configuramos aquí el tema, lo manejará el gestor de temas
  },
  -- Tema Rose Pine
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    -- No configuramos aquí el tema, lo manejará el gestor de temas
  }, 
  
  -- Window picker para cambio rápido entre ventanas
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require('window-picker').setup()
    end,
  },

    -- Neo-tree - configuración en archivo separado
    require('plugins.neotree'),
  
    -- Bufferline
    require('plugins.bufferline'),
 
    -- Lua line module
    require('plugins.lualine'),
 
    -- Treesitter module
    require('plugins.treesitter'),
    
    -- Telescope module
    require('plugins.telescope'),

    -- LSP Module
    require('plugins.lsp'),

    -- Autocompletion Module
    require('plugins.autocompletion'),
    
    -- Git Signs 
    require('plugins.gitsigns'),
    
    -- Alpha Art
    require('plugins.alpha'),
    
    -- Blankline Indent
    require('plugins.indent-blankline'),
    
    -- Lazy Git
    require('plugins.lazygit')
}
