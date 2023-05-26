local utils = require("./utils")
local EXPORTS = {}

EXPORTS.setup = function()
  vim.g.vimwiki_global_ext = 0
  vim.g.vimwiki_ext2syntax = vim.empty_dict()
  vim.g.vimwiki_list = {
    {
      custom_wiki2html = "$HOME/.config/nvim/scripts/vimwiki_md2html.sh",
      path = "$HOME/vimwiki/",
      automatic_nested_syntaxes = 1,
      nested_syntaxes = {
        ["language-python"] = "python",
      },
      -- css_name = "static/css/style.css",
      syntax = "markdown",
      ext = ".wiki.md",
      auto_tags = 1,
      auto_toc = 1,
      auto_generate_tags = 1,
      auto_generate_links = 1,
      -- template_path = "$HOME/vimwiki/templates/",
      -- template_default = "default",
      -- template_ext = ".html",
    },
  }
  vim.g.vimwiki_dir_link = "index"

  -- Setup export keymap
  utils.create_keymap_for_cmd({
    modes = { "n", "v", "o" },
    cmd = "VimwikiAll2HTML",
    keystrokes = "<leader>wea",
    extra = {
      desc = "Export All Wiki files to HTML",
    },
  })
  -- Setup keymap to open
  utils.create_keymap_for_cmd({
    modes = { "n", "v", "o" },
    cmd = "VimwikiIndex",
    keystrokes = "<leader>ww",
    extra = {
      desc = "Open the Wiki Index",
    },
  })
end

return EXPORTS
