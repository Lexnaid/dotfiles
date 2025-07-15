-- lua/themes/poimandres-purple.lua
-- Tema poimandres con fondo púrpura personalizado

local M = {}

-- Configuración del tema púrpura
M.config = {
  purple_intensity = 0.15,
  base_colors = {
    bg_base = "#1e1e2e",
    purple_tint = "#6c5ce7",
  }
}

-- Función para mezclar colores
function M.blend_colors(color1, color2, ratio)
  local function hex_to_rgb(hex)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    return r, g, b
  end
  
  local function rgb_to_hex(r, g, b)
    return string.format("#%02x%02x%02x", 
      math.floor(r + 0.5), 
      math.floor(g + 0.5), 
      math.floor(b + 0.5))
  end
  
  local r1, g1, b1 = hex_to_rgb(color1)
  local r2, g2, b2 = hex_to_rgb(color2)
  
  local r = r1 + (r2 - r1) * ratio
  local g = g1 + (g2 - g1) * ratio
  local b = b1 + (b2 - b1) * ratio
  
  return rgb_to_hex(r, g, b)
end

-- Función para aplicar el tema púrpura
function M.apply_purple_highlights()
  local base_bg = M.config.base_colors.bg_base
  local purple_tint = M.config.base_colors.purple_tint
  local intensity = M.config.purple_intensity
  
  -- Generar colores púrpura
  local colors = {
    bg_primary = M.blend_colors(base_bg, purple_tint, intensity),
    bg_secondary = M.blend_colors(base_bg, purple_tint, intensity * 0.7),
    bg_float = M.blend_colors(base_bg, purple_tint, intensity * 1.2),
    bg_sidebar = M.blend_colors(base_bg, purple_tint, intensity * 0.9),
  }
  
  -- Definir highlights personalizados
  local highlights = {
    -- Fondos principales
    Normal = { bg = colors.bg_primary },
    NormalNC = { bg = colors.bg_primary },
    SignColumn = { bg = colors.bg_primary },
    EndOfBuffer = { bg = colors.bg_primary },
    
    -- Barras de estado y tabs
    StatusLine = { bg = colors.bg_secondary },
    StatusLineNC = { bg = colors.bg_secondary },
    TabLine = { bg = colors.bg_secondary },
    TabLineFill = { bg = colors.bg_secondary },
    
    -- Ventanas flotantes
    NormalFloat = { bg = colors.bg_float },
    FloatBorder = { bg = colors.bg_float },
    
    -- Sidebar
    NvimTreeNormal = { bg = colors.bg_sidebar },
    NvimTreeEndOfBuffer = { bg = colors.bg_sidebar },
    
    -- Telescope
    TelescopeNormal = { bg = colors.bg_float },
    TelescopeBorder = { bg = colors.bg_float },
    TelescopePromptNormal = { bg = colors.bg_float },
    TelescopeResultsNormal = { bg = colors.bg_float },
    TelescopePreviewNormal = { bg = colors.bg_float },
    
    -- Popup menus
    Pmenu = { bg = colors.bg_float },
    PmenuSel = { bg = colors.bg_secondary },
    
    -- Otros elementos
    Folded = { bg = colors.bg_secondary },
    FoldColumn = { bg = colors.bg_primary },
  }
  
  -- Aplicar highlights
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

-- Función para ajustar la intensidad del púrpura
function M.set_purple_intensity(intensity)
  if intensity and intensity >= 0 and intensity <= 1 then
    M.config.purple_intensity = intensity
    M.apply_purple_highlights()
    vim.notify("Intensidad púrpura ajustada a: " .. intensity, vim.log.levels.INFO)
  else
    vim.notify("Uso: intensidad debe estar entre 0.0 y 1.0", vim.log.levels.ERROR)
  end
end

-- Función principal para configurar el tema
function M.setup()
  -- Asegurarse de que poimandres esté instalado
  local poimandres_ok, poimandres = pcall(require, 'poimandres')
  if not poimandres_ok then
    vim.notify("poimandres.nvim no está instalado", vim.log.levels.ERROR)
    return
  end
  
  -- Configurar poimandres
  poimandres.setup {
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = false,
    disable_float_background = false,
    disable_italics = false,
  }
  
  -- Aplicar el colorscheme base
  vim.cmd("colorscheme poimandres")
  
  -- Esperar un poco para que se cargue completamente
  vim.defer_fn(function()
    M.apply_purple_highlights()
  end, 50)
  
  -- Crear autocmd para replicar en recarga
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "poimandres",
    callback = function()
      M.apply_purple_highlights()
    end,
  })
  
  -- Comando para ajustar púrpura
  vim.api.nvim_create_user_command('PurpleIntensity', function(opts)
    local intensity = tonumber(opts.args)
    M.set_purple_intensity(intensity)
  end, {
    nargs = 1,
    desc = 'Ajustar intensidad del púrpura (0.0-1.0)'
  })
end

return M



