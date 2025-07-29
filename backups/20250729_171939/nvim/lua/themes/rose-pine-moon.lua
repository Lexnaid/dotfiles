-- lua/themes/rose-pine-moon.lua
-- Tema Rose Pine Moon con background completamente transparente

local M = {}

-- Función para limpiar highlights personalizados de otros temas
local function clear_custom_highlights()
  -- Lista de highlights que otros temas pueden haber modificado
  local highlights_to_reset = {
    "Normal",
    "NormalNC", 
    "SignColumn",
    "EndOfBuffer",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
    "NormalFloat",
    "FloatBorder",
    "NvimTreeNormal",
    "NvimTreeEndOfBuffer",
    "TelescopeNormal",
    "TelescopeBorder", 
    "TelescopePromptNormal",
    "TelescopeResultsNormal",
    "TelescopePreviewNormal",
    "Pmenu",
    "PmenuSel",
    "Folded",
    "FoldColumn",
  }
  
  -- Limpiar highlights personalizados
  for _, group in ipairs(highlights_to_reset) do
    vim.api.nvim_set_hl(0, group, {})
  end
end

-- Función para forzar transparencia completa
local function force_transparency()
  -- Highlights principales que necesitan ser transparentes
  local transparent_groups = {
    "Normal",
    "NormalNC",
    "SignColumn", 
    "EndOfBuffer",
    "NormalFloat",
    "FloatBorder",
    "Pmenu",
    "PmenuSbar",
    "PmenuThumb",
    "TabLine",
    "TabLineFill",
    "TabLineSel",
    "StatusLine",
    "StatusLineNC",
    "WinSeparator",
    "VertSplit",
    
    -- Neo-tree / NvimTree
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeEndOfBuffer",
    "NvimTreeNormal",
    "NvimTreeEndOfBuffer",
    "NvimTreeWinSeparator",
    
    -- Telescope
    "TelescopeNormal",
    "TelescopePromptNormal",
    "TelescopeResultsNormal",
    "TelescopePreviewNormal",
    
    -- Folding
    "Folded",
    "FoldColumn",
    
    -- Bufferline
    "BufferLineBackground",
    "BufferLineFill",
    "BufferLineTab",
    "BufferLineTabClose",
    "BufferLineTabSelected",
    "BufferLineSeparator",
    "BufferLineSeparatorSelected",
    "BufferLineSeparatorVisible",
  }
  
  -- Aplicar background transparente a todos los grupos
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
  end
  
  -- Algunos grupos especiales que necesitan configuración específica
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
end

-- Función para configurar el tema Rose Pine Moon
function M.setup()
  -- Asegurarse de que rose-pine esté instalado
  local rose_pine_ok, rose_pine = pcall(require, 'rose-pine')
  if not rose_pine_ok then
    vim.notify("rose-pine no está instalado", vim.log.levels.ERROR)
    return
  end
  
  -- IMPORTANTE: Limpiar modificaciones previas de otros temas
  clear_custom_highlights()
  
  -- Configurar Rose Pine
  rose_pine.setup({
    variant = 'moon', -- auto, main, moon, or dawn
    dark_variant = 'moon',
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = true,
    disable_float_background = true,
    disable_italics = false,
    
    -- Personalización de grupos de highlight
    groups = {
      background = 'base',
      background_nc = '_experimental_nc',
      panel = 'surface',
      panel_nc = 'base',
      border = 'highlight_med',
      comment = 'muted',
      link = 'iris',
      punctuation = 'subtle',
      error = 'love',
      hint = 'iris',
      info = 'foam',
      warn = 'gold',
      headings = {
        h1 = 'iris',
        h2 = 'foam',
        h3 = 'rose',
        h4 = 'gold',
        h5 = 'pine',
        h6 = 'foam',
      }
    },
    
    -- Personalizar highlights específicos para mantener transparencia
    highlight_groups = {
      -- Forzar transparencia en elementos principales
      Normal = { bg = 'none' },
      NormalNC = { bg = 'none' },
      NormalFloat = { bg = 'none' },
      FloatBorder = { fg = 'highlight_high', bg = 'none' },
      SignColumn = { bg = 'none' },
      EndOfBuffer = { bg = 'none' },
      
      -- Telescope
      TelescopeBorder = { fg = 'highlight_high', bg = 'none' },
      TelescopeNormal = { bg = 'none' },
      TelescopePromptNormal = { bg = 'none' },
      TelescopeResultsNormal = { fg = 'subtle', bg = 'none' },
      TelescopePreviewNormal = { bg = 'none' },
      TelescopeSelection = { fg = 'text', bg = 'highlight_low' },
      TelescopeSelectionCaret = { fg = 'rose', bg = 'highlight_low' },
      
      -- Neo-tree
      NeoTreeNormal = { bg = 'none' },
      NeoTreeNormalNC = { bg = 'none' },
      NeoTreeEndOfBuffer = { bg = 'none' },
      
      -- Bufferline
      BufferLineBackground = { fg = 'muted', bg = 'none' },
      BufferLineFill = { bg = 'none' },
      
      -- Status line
      StatusLine = { fg = 'subtle', bg = 'none' },
      StatusLineNC = { fg = 'muted', bg = 'none' },
      
      -- Tabs
      TabLine = { fg = 'muted', bg = 'none' },
      TabLineFill = { bg = 'none' },
      TabLineSel = { fg = 'text', bg = 'highlight_low' },
      
      -- Pmenu (completion menu)
      Pmenu = { fg = 'text', bg = 'surface' },
      PmenuSel = { fg = 'text', bg = 'highlight_med' },
      PmenuSbar = { bg = 'highlight_low' },
      PmenuThumb = { bg = 'highlight_high' },
      
      -- Folding
      Folded = { fg = 'muted', bg = 'none' },
      FoldColumn = { fg = 'muted', bg = 'none' },
      
      -- Window separators
      WinSeparator = { fg = 'highlight_med', bg = 'none' },
      VertSplit = { fg = 'highlight_med', bg = 'none' },
    }
  })
  
  -- Aplicar el colorscheme
  vim.cmd("colorscheme rose-pine-moon")
  
  -- Forzar transparencia después de cargar el tema
  vim.defer_fn(function()
    force_transparency()
    vim.notify("🌙 Rose Pine Moon con fondo transparente", vim.log.levels.INFO)
  end, 50)
  
  -- También forzar transparencia en eventos de colorscheme
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      if vim.g.colors_name == "rose-pine-moon" then
        vim.defer_fn(force_transparency, 10)
      end
    end,
  })
end

return M
