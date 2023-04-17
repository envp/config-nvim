call plug#begin('~/.local/share/nvim/plugged')
  Plug 'dstein64/vim-startuptime', { 'on': 'StartupTime' }
  Plug 'vimwiki/vimwiki', { 'on': 'VimwikiIndex', 'for': 'vimwiki' }
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() }, 'on': [ 'Files', 'GFiles', 'Buffers' ] }
  Plug 'junegunn/fzf.vim', { 'on': [ 'Files', 'GFiles', 'Buffers' ] }
  Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'PhilRunninger/nerdtree-buffer-ops', {'on': 'NERDTreeToggle'}
  Plug 'tpope/vim-commentary', { 'on': 'Commentary' }

  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

  Plug 'nvim-lualine/lualine.nvim'

  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main'}
  Plug 'hrsh7th/cmp-buffer', { 'branch': 'main'}
  Plug 'hrsh7th/cmp-path', { 'branch': 'main'}
  Plug 'hrsh7th/cmp-cmdline', { 'branch': 'main'}
  Plug 'hrsh7th/nvim-cmp', { 'branch': 'main'}
  Plug 'L3MON4D3/LuaSnip', { 'tag': 'v1.*', 'do': 'make install_jsregexp'}
  Plug 'rafamadriz/friendly-snippets'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'j-hui/fidget.nvim'
  Plug 'folke/trouble.nvim'

  Plug 'pboettch/vim-cmake-syntax', { 'for': 'cmake' }
  Plug 'luochen1990/rainbow'
  Plug 'raimon49/requirements.txt.vim', { 'for': 'requirements' }
  Plug 'skanehira/preview-markdown.vim', {'for': 'markdown'}
  Plug 'vim-scripts/DoxygenToolkit.vim', {'for': [ 'c', 'cpp' ]}
  Plug 'cespare/vim-toml', {'for': 'toml'}
  Plug 'folke/which-key.nvim'
  Plug 'AndrewRadev/linediff.vim', { 'on': [ 'Linediff', 'LinediffAdd', 'LinediffLast', 'LinediffPick' ] }

  " Themes after here
  " Plug 'NLKNguyen/papercolor-theme'
  Plug 'EdenEast/nightfox.nvim'
call plug#end()

lua << EOF
  require('options').setup()
  -- Configure lua based LSP
  require("lsp").setup()
  require("fidget").setup({})
  require("trouble").setup({})

  -- Set up theme and overrides
  require('nightfox').setup({
    options = {
        transparent = true,
        styles = {
          comments = 'italic',
        }
    },
  })
  vim.cmd.colorscheme('dayfox')

  local mapping_opts = {noremap = true, silent = true}
  -- FZF
  vim.keymap.set('n', '<C-o>', vim.cmd.Files, {noremap = true, silent = true, desc = "Browse files in current dir"})
  vim.keymap.set('n', '<C-p>', vim.cmd.GFiles, {noremap = true, silent = true, desc = "Browse version controlled files in repo"})

  -- GitGutter
  vim.g.gitgutter_max_signs=9999

  -- Rainbow parens
  vim.g.rainbow_active = true
  vim.g.rainbow_conf = {
    separately = { cmake = 0 }
  }

  -- Add requirements-dev to our detection patterns
  vim.g['requirements#detect_filename_pattern'] = '(pip_)?requirements(-dev)?'

  -- Markdown preview
  vim.g.preview_markdown_vertical = true
  vim.g.preview_markdown_parser = '/usr/local/bin/mdcat'

  -- Configure DoxygenToolkit
  vim.g.DoxygenToolkit_commentType = "C++"
  vim.g.DoxygenToolkit_briefTag_pre = "\\brief "
  vim.g.DoxygenToolkit_templateParamTag_pre = "\\tparam "
  vim.g.DoxygenToolkit_paramTag_pre = "\\param "
  vim.g.DoxygenToolkit_returnTag = "\\return "
  vim.g.DoxygenToolkit_throwTag_pre = "\\throw "
  vim.g.DoxygenToolkit_fileTag = "\\file "
  vim.g.DoxygenToolkit_dateTag = "\\date "
  vim.g.DoxygenToolkit_authorTag = "\\author "
  vim.g.DoxygenToolkit_versionTag = "\\version "
  vim.g.DoxygenToolkit_blockTag = "\\name "
  vim.g.DoxygenToolkit_classTag = "\\class "
  vim.g.doxygen_enhanced_color = 1
  vim.g.DoxygenToolKit_startCommentBlock = "///"
  vim.g.DoxygenToolKit_interCommentBlock = "///"

  vim.g.mapleader = ','
  -- NERDTree
  vim.g.NERDTreeDirArrowExpandable = "+"
  vim.g.NERDTreeDirArrowCollapsible = "~"
  vim.cmd([[
    let NERDTreeIgnore = ['\.pyc$', '\.o$', '\.a$', '\.tsk$', '\.linux$']
  ]])
  vim.keymap.set({'n', 'v', 'o'}, '<leader>n', function() vim.cmd('NERDTreeToggle') end, { silent = true })

  -- Configure vimwiki
  require("vimwiki").setup()

  vim.keymap.set({'n', 'v', 'o'}, '<leader>wea', vim.cmd.VimwikiAll2HTML, { desc = 'Export All Wiki files to HTML' })
  vim.keymap.set({'n', 'v', 'o'}, '<leader>ww', vim.cmd.VimwikiIndex, { desc = 'Open the wiki' })

  -- General keybindings
  vim.keymap.set({'n', 'v', 'o'}, '<C-l>', vim.cmd.nohlsearch, { silent = true, desc = 'Clear search highlighting' })
  vim.keymap.set('n', '<leader>be', vim.cmd.enew, { silent = true, desc = 'Create a new buffer'})
  vim.keymap.set('n', '<leader>bl', vim.cmd.Buffers, {noremap = true, silent = true, desc = "Browse all buffers"})
  vim.keymap.set('n', '<leader>bn', vim.cmd.bnext, { silent = true, desc = 'Goto next buffer'})
  vim.keymap.set('n', '<leader>bq', vim.cmd.bdelete, { silent = true, desc = 'Discard buffer' })
  vim.keymap.set('n', '<leader>bv', vim.cmd.bprevious, { silent = true, desc = 'Goto prev buffer' })

  -- Move around selected lines in Visual mode
  vim.keymap.set('v', '<S-Up>', ":move '<-2<CR>gv=gv")
  vim.keymap.set('v', '<S-Down>', ":move '>+1<CR>gv=gv")

  -- Match trailing whitespace with error message highlight group
  vim.cmd([[
    match ExtraWhiteSpace /\s\+$/
    hi link ExtraWhiteSpace Error
  ]])


  -- Setup at the very end 'which-key'
  require("which-key").setup({})

EOF
