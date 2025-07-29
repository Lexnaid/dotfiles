-- lua/themes/poimandres-original.lua
-- Tema poimandres original - FIXED

local M = {}

-- Función para limpiar highlights personalizados
local function clear_custom_highlights()
  -- Lista de highlights que el tema púrpura modifica
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

-- Función para configurar el tema original
function M.setup()
  -- Asegurarse de que poimandres esté instalado
  local poimandres_ok, poimandres = pcall(require, 'poimandres')
  if not poimandres_ok then
    vim.notify("poimandres.nvim no está instalado", vim.log.levels.ERROR)
    return
  end
  
  -- IMPORTANTE: Limpiar modificaciones previas
  clear_custom_highlights()
  
  -- Configurar poimandres con ajustes estándar
  poimandres.setup {
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = true,
    disable_float_background = false,
    disable_italics = false,
  }
  
  -- Aplicar el colorscheme base
  vim.cmd("colorscheme poimandres")
  
  -- Forzar recarga completa del colorscheme
  vim.defer_fn(function()
    vim.cmd("colorscheme poimandres")
  end, 10)
end

return M
