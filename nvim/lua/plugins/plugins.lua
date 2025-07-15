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
  
  -- Neo-tree para explorador de archivos
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    lazy = false,
    opts = {
      -- Configuración básica de neo-tree
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
    },
  },
}
