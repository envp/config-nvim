local utils = require("./utils")
local EXPORTS = {}

EXPORTS.setup = function()
  vim.g.vimwiki_global_ext = 0
  vim.g.vimwiki_ext2syntax = vim.empty_dict()
  vim.g.vimwiki_list = {
    {
      path = "$HOME/vimwiki/",
      template_path = "$HOME/vimwiki/templates/",
      automatic_nested_syntaxes = 1,
      nested_syntaxes = {
        ["language-python"] = "python",
      },
      syntax = "markdown",
      ext = ".wiki.md",
      template_default = "default",
      template_ext = ".html",
      auto_tags = 1,
      auto_toc = 1,
      auto_generate_tags = 1,
      auto_generate_links = 1,
    },
  }
  vim.g.vimwiki_dir_link = "index"
  utils.create_keymap_for_cmd({
    modes = { "n", "v", "o" },
    cmd = "VimwikiAll2HTML",
    keystrokes = "<leader>wea",
    extra = {
      desc = "Export All Wiki files to HTML",
    },
  })
end

return EXPORTS
