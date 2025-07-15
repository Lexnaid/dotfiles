-- lua/themes/init.lua
-- Gestor de temas para Neovim

local M = {}

-- Configuración del gestor de temas
M.config = {
  default_theme = "poimandres-original", -- Tema predeterminado
  themes_dir = "themes",
}

-- Lista de temas disponibles
M.available_themes = {
  ["poimandres-purple"] = {
    name = "Poimandres Purple",
    description = "Poimandres con fondo púrpura sutil",
    file = "poimandres-purple",
  },
  ["poimandres-original"] = {
    name = "Poimandres Original",
    description = "Poimandres sin modificaciones",
    file = "poimandres-original",
  },
  -- Aquí puedes agregar más temas fácilmente
}

-- Función para cargar un tema específico
 function M.load_theme(theme_name)
  theme_name = theme_name or M.config.default_theme
  
  local theme_config = M.available_themes[theme_name]
  if not theme_config then
    vim.notify("Tema no encontrado: " .. theme_name, vim.log.levels.ERROR)
    return false
  end
  
  local theme_module = "themes." .. theme_config.file
  local ok, theme = pcall(require, theme_module)
  
  if not ok then
    vim.notify("Error cargando tema: " .. theme_name, vim.log.levels.ERROR)
    return false
  end
  
 -- Aplicar el tema
  if type(theme) == "table" and theme.setup then
    theme.setup()
  end
  
  -- Tema cargado silenciosamente
  return true
end

-- Función para listar temas disponibles
function M.list_themes()
  print("Temas disponibles:")
  for key, theme in pairs(M.available_themes) do
    local marker = key == M.config.default_theme and " [DEFAULT]" or ""
    print("  • " .. key .. " - " .. theme.name .. marker)
    print("    " .. theme.description)
  end
end

-- Función para cambiar tema con completado
function M.change_theme(theme_name)
  if M.load_theme(theme_name) then
    -- Guardar preferencia en una variable global para persistencia
    vim.g.current_theme = theme_name
  end
end

-- Función de completado para el comando
function M.complete_themes(arg_lead, cmd_line, cursor_pos)
  local themes = {}
  for key, _ in pairs(M.available_themes) do
    if key:find("^" .. arg_lead) then
      table.insert(themes, key)
    end
  end
  return themes
end

-- Inicializar el gestor de temas
function M.setup()
  -- Cargar el tema predeterminado
  local saved_theme = vim.g.current_theme or M.config.default_theme
  M.load_theme(saved_theme)
  
  -- Crear comandos
  vim.api.nvim_create_user_command('ThemeChange', function(opts)
    M.change_theme(opts.args)
  end, {
    nargs = 1,
    complete = M.complete_themes,
    desc = 'Cambiar tema'
  })
  
  vim.api.nvim_create_user_command('ThemeList', function()
    M.list_themes()
  end, {
    desc = 'Listar temas disponibles'
  })
  
  vim.api.nvim_create_user_command('ThemeReload', function()
    local current = vim.g.current_theme or M.config.default_theme
    M.load_theme(current)
  end, {
    desc = 'Recargar tema actual'
  })
end

return M



