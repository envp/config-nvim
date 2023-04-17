local M = {}

M.setup = function()
  vim.g.vimwiki_list = {
    {
      path = '~/vimwiki',
      syntax = 'markdown',
      ext = '.wiki.md',
      custom_wiki2html = 'md2html.sh',
      nested_syntaxes = {
        python = 'python',
        cpp = 'cpp',
        diff = 'diff',
        yaml = 'yaml',
      }
    }
  }
  vim.g.vimwiki_global_ext = 0
end

return M
