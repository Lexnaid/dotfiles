-- lua/themes/init.lua
-- Gestor de temas para Neovim - ULTRA ROBUST

local M = {}

-- Configuración del gestor de temas
M.config = {
  default_theme = "rose-pine-moon",
  themes_dir = "themes",
}

-- Lista de temas disponibles
M.available_themes = {
  ["poimandres-purple"] = {
    name = "Poimandres Purple",
    description = "Poimandres con fondo púrpura sutil",
    module = "poimandres-purple",
  },
  ["poimandres-original"] = {
    name = "Poimandres Original", 
    description = "Poimandres sin modificaciones",
    module = "poimandres-original",
  },
  ["rose-pine-moon"] = {
    name = "Rose Pine Moon",
    description = "Rose Pine Moon Scheme",
    module = "rose-pine-moon",
    },
}

-- Función para limpiar nombre de tema (quitar espacios, etc.)
local function clean_theme_name(name)
  if not name then return nil end
  return vim.trim(tostring(name))
end

-- Función para buscar tema de forma flexible
local function find_theme_config(theme_name)
  local clean_name = clean_theme_name(theme_name)
  if not clean_name then return nil end
  
  -- Búsqueda exacta primero
  if M.available_themes[clean_name] then
    return M.available_themes[clean_name], clean_name
  end
  
  -- Búsqueda case-insensitive
  local lower_name = clean_name:lower()
  for key, config in pairs(M.available_themes) do
    if key:lower() == lower_name then
      return config, key
    end
  end
  
  -- Búsqueda parcial
  for key, config in pairs(M.available_themes) do
    if key:find(clean_name, 1, true) or clean_name:find(key, 1, true) then
      return config, key
    end
  end
  
  return nil, nil
end

-- Función para cargar un tema específico
function M.load_theme(theme_name)
  theme_name = clean_theme_name(theme_name) or M.config.default_theme
  
  local theme_config, actual_key = find_theme_config(theme_name)
  if not theme_config then
    vim.notify("❌ Tema no encontrado: '" .. theme_name .. "'", vim.log.levels.ERROR)
    M.list_themes()
    return false
  end
  
  -- Si encontramos el tema con una key diferente, usamos la correcta
  if actual_key ~= theme_name then
    print("🔄 Usando key correcta: '" .. actual_key .. "' para '" .. theme_name .. "'")
    theme_name = actual_key
  end
  
  -- Construir la ruta del módulo
  local module_name = theme_config.module
  local theme_module_path = "themes." .. module_name
  
  -- Limpiar cache si existe
  package.loaded[theme_module_path] = nil
  
  -- Cargar módulo
  local ok, theme_module = pcall(require, theme_module_path)
  if not ok then
    vim.notify("❌ Error cargando módulo: " .. theme_module, vim.log.levels.ERROR)
    return false
  end
  
  -- Aplicar el tema
  if type(theme_module) == "table" and theme_module.setup then
    local setup_ok, setup_err = pcall(theme_module.setup)
    if not setup_ok then
      vim.notify("❌ Error en setup del tema: " .. setup_err, vim.log.levels.ERROR)
      return false
    end
  else
    vim.notify("❌ Módulo inválido para tema: " .. theme_name, vim.log.levels.ERROR)
    return false
  end
  
  -- Guardar estado
  vim.g.current_theme = theme_name
  return true
end

-- Función para listar temas disponibles
function M.list_themes()
  print("\n📋 Temas disponibles:")
  local current = vim.g.current_theme
  for key, theme in pairs(M.available_themes) do
    local markers = {}
    if key == M.config.default_theme then table.insert(markers, "[DEFAULT]") end
    if key == current then table.insert(markers, "[ACTUAL]") end
    local marker_str = #markers > 0 and " " .. table.concat(markers, " ") or ""
    
    print("  🎨 " .. key .. " - " .. theme.name .. marker_str)
    print("     " .. theme.description)
  end
  print()
end

-- Función para cambiar tema
function M.change_theme(theme_name)
  if not theme_name or theme_name == "" then
    vim.notify("⚠️  Especifica un nombre de tema", vim.log.levels.WARN)
    M.list_themes()
    return false
  end
  
  return M.load_theme(theme_name)
end

-- Función de completado mejorada
function M.complete_themes(arg_lead, cmd_line, cursor_pos)
  local themes = {}
  local clean_lead = clean_theme_name(arg_lead) or ""
  
  for key, _ in pairs(M.available_themes) do
    -- Coincidencia al inicio
    if key:find("^" .. vim.pesc(clean_lead)) then
      table.insert(themes, key)
    end
  end
  
  -- Si no hay coincidencias exactas, buscar parciales
  if #themes == 0 then
    for key, _ in pairs(M.available_themes) do
      if key:find(vim.pesc(clean_lead)) then
        table.insert(themes, key)
      end
    end
  end
  
  return themes
end

-- Función para recargar tema actual
function M.reload_current_theme()
  local current = vim.g.current_theme or M.config.default_theme
  M.load_theme(current)
end

-- Función de diagnóstico mejorada
function M.diagnose()
  print("\n🔍 DIAGNÓSTICO DEL GESTOR DE TEMAS")
  print("================================")
  
  print("📁 Directorio de config:", vim.fn.stdpath('config'))
  local themes_dir = vim.fn.stdpath('config') .. '/lua/themes/'
  print("📁 Directorio de temas:", themes_dir)
  
  local dir_exists = vim.fn.isdirectory(themes_dir) == 1
  print("📂 Directorio existe:", dir_exists and "✅ SÍ" or "❌ NO")
  
  print("\n📋 Verificando temas registrados:")
  for key, config in pairs(M.available_themes) do
    print("  🔍 Key: '" .. key .. "'")
    print("    📝 Nombre: " .. config.name)
    print("    📦 Módulo: " .. config.module)
    
    local file_path = themes_dir .. config.module .. '.lua'
    local exists = vim.fn.filereadable(file_path) == 1
    print("    📄 Archivo: " .. (exists and "✅" or "❌") .. " " .. file_path)
    
    -- Probar carga del módulo
    local module_path = "themes." .. config.module
    package.loaded[module_path] = nil -- Limpiar cache
    local ok, result = pcall(require, module_path)
    print("    🔧 Módulo: " .. (ok and "✅ CARGA OK" or "❌ ERROR: " .. result))
    
    if ok and result.setup then
      print("    ⚙️  Setup: ✅ DISPONIBLE")
    else
      print("    ⚙️  Setup: ❌ NO DISPONIBLE")
    end
    print()
  end
  
  print("🎨 Tema actual:", vim.g.current_theme or "ninguno")
  print("🎨 Tema por defecto:", M.config.default_theme)
  
  -- Test de búsqueda
  print("\n🔎 Test de búsqueda:")
  local test_names = {"poimandres-original", "POIMANDRES-ORIGINAL", "original", "purple"}
  for _, test_name in ipairs(test_names) do
    local config, key = find_theme_config(test_name)
    print("  '" .. test_name .. "' -> " .. (config and ("✅ " .. key) or "❌ NO ENCONTRADO"))
  end
  print()
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
    M.reload_current_theme()
  end, {
    desc = 'Recargar tema actual'
  })
  
  vim.api.nvim_create_user_command('ThemeDiagnose', function()
    M.diagnose()
  end, {
    desc = 'Diagnosticar problemas con temas'
  })
end

return M
