-- lua/plugins/copilot.lua
return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_enabled = true
    -- NO agregues vim.g.copilot_no_tab_map = true
  end
}
