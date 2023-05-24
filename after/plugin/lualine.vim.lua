-- lualine.nvim
function statusline()
  local ts_statusline = vim.fn["nvim_treesitter#statusline"]()
  if ts_statusline == vim.NIL then
    return ""
  end
  return ts_statusline
end

require("lualine").setup({
  options = {
    icons_enabled = false,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {
      {
        "statusline()",
        color = "DiagnosticVirtualTextInfo",
        separator = { right = "" },
      },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location", "searchcount" },
  },
  tabline = {
    lualine_a = {
      {
        "buffers",
        mode = 4,
        use_mode_colors = true,
        symbols = {
          modified = " ●", -- Text to show when the buffer is modified
          alternate_file = "# ", -- Text to show to identify the alternate file
          directory = "[D]", -- Text to show when the buffer is a directory
        },
        buffers_color = {
          active = "lualine_a_normal",
        },
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        "tabs",
        mode = 2,
      },
    },
  },
  extensions = {
    "nerdtree",
    "fugitive",
  },
})
