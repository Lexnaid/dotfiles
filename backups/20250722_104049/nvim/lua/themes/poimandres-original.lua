local M = {}

-- Función para configurar el tema original
function M.setup()
  -- Asegurarse de que poimandres esté instalado
  local poimandres_ok, poimandres = pcall(require, 'poimandres')
  if not poimandres_ok then
    vim.notify("poimandres.nvim no está instalado", vim.log.levels.ERROR)
    return
  end
  
  -- Configurar poimandres con ajustes estándar
  poimandres.setup {
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = true,
    disable_float_background = false,
    disable_italics = false,
  }
  
  -- Aplicar el colorscheme
  vim.cmd("colorscheme poimandres")
  
  -- Tema cargado silenciosamente
end

return M




