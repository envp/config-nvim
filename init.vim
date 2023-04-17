call plug#begin('~/.local/share/nvim/plugged')
  Plug 'dstein64/vim-startuptime', { 'on': 'StartupTime' }
  Plug 'vimwiki/vimwiki'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() }, 'on': [ 'Files', 'GFiles', 'Buffers' ] }
  Plug 'junegunn/fzf.vim', { 'on': [ 'Files', 'GFiles', 'Buffers' ] }
  Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'PhilRunninger/nerdtree-buffer-ops', {'on': 'NERDTreeToggle'}
  Plug 'tpope/vim-commentary', { 'on': 'Commentary' }

  Plug 'tpope/vim-fugitive', { 'on': [ 'G', 'Git' ] }
  Plug 'airblade/vim-gitgutter'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

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

  Plug 'pboettch/vim-cmake-syntax', { 'for': 'cmake' }
  Plug 'luochen1990/rainbow'
  Plug 'raimon49/requirements.txt.vim', { 'for': 'requirements' }
  Plug 'lervag/vimtex', { 'for': 'latex' }
  Plug 'folke/which-key.nvim'
  Plug 'AndrewRadev/linediff.vim', { 'on': [ 'Linediff', 'LinediffAdd', 'LinediffPick' ] }

  " Colorschemes after here
  " Plug 'NLKNguyen/papercolor-theme'
  Plug 'EdenEast/nightfox.nvim'
call plug#end()

lua << EOF
  require('options').setup({background=light})
  require('nightfox').setup({
    options = {
      transparent = true,
      styles = {
        comments = "italic",
      },
    }
  })
  vim.cmd.colorscheme('dayfox')

  require("luasnip/loaders/from_vscode").lazy_load()
  -- Airline
  vim.g.airline_theme = 'papercolor'
  vim.g.airline_extensions = {'branch', 'hunks', 'tabline', 'nvimlsp'}
  vim.g.airline_symbols_ascii = true
  vim.g['airline#extensions#tabline#enabled'] = true
  vim.g['airline#extensions#branch#enabled'] = true
  vim.g['airline#extensions#hunks#enabled'] = true
  vim.g['airline#extensions#nvimlsp#enabled'] = true
  vim.g['airline#extensions#tabline#buffer_nr_show'] = true
  vim.g['airline#extensions#tabline#buffer_nr_format'] = '%s: '
  vim.g['airline#extensions#tabline#fnamemod'] =':p:.'
  vim.g['airline#extensions#tabline#fnamecollapse'] = true
  vim.g['airline#extensions#tabline#formatter'] = 'unique_tail_improved'
  vim.g.airline_highlighting_cache = true
  vim.g.airline_mode_map = {
    ['__'] = '_',
    ['n'] = 'N',
    ['i'] = 'I',
    ['R'] = 'R',
    ['c'] = 'C',
    ['v'] = 'V',
    ['V'] = 'V',
    [''] = 'V',
    ['s'] = 'S',
  }

  -- FZF
  vim.keymap.set('n', '<C-p>', vim.cmd.GFiles, {noremap = true, silent = true, desc = "Fuzzy browse files in git repo"})
  vim.keymap.set('n', '<C-o>', vim.cmd.Files, {noremap = true, silent = true, desc = "Fuzzy browse all files in cwd"})

  -- GitGutter
  vim.g.gitgutter_max_signs=9999

  -- Which key
  require("which-key").setup()

  -- Configure lua lsp
  require("lsp").setup()
  require("fidget").setup()

  -- Rainbow parens
  vim.g.rainbow_active = true
  vim.g.rainbow_conf = {
    separately = { cmake = 0 }
  }

  -- Add requirements-dev to our detection patterns
  vim.g['requirements#detect_filename_pattern'] = '(pip_)?requirements(-dev)?'

  -- vimwiki
  require("plugins/vimwiki").setup()

  vim.keymap.set({'n', 'v', 'o'}, '<leader>ww', vim.cmd.VimwikiIndex, { silent = true, desc = "Open the default wiki" })
  vim.keymap.set({'n', 'v', 'o'}, '<leader>wea', vim.cmd.VimwikiAll2HTML, { silent = true, desc = "Export the current wiki to HTML" })

  -- General keybindings
  vim.g.mapleader = ','
  vim.keymap.set({'n', 'v', 'o'}, '<C-l>', vim.cmd.nohlsearch, { silent = true, desc = "Remove search highlights"})
  vim.keymap.set('n', '<leader>n', vim.cmd.NERDTreeToggle, {silent = true})
  vim.keymap.set('n', '<leader>be', vim.cmd.Buffers, {silent = true, desc = "Open a new buffer for editing"})
  vim.keymap.set('n', '<leader>bn', vim.cmd.bnext, {silent = true, desc = "Switch to next buffer"})
  vim.keymap.set('n', '<leader>bv', vim.cmd.bprevious, {silent = true, desc = "Switch to previous buffer"})
  vim.keymap.set('n', '<leader>bq', vim.cmd.bdelete, {silent = true, desc = "Delete current buffer, jump to prev"})
  vim.keymap.set('n', '<leader>bl', vim.cmd.Buffers, {silent = true, desc = "Fuzzy browse open buffers" })

  -- Move around selected regions of text in visual mode
  vim.keymap.set('v', 'K', ":move '<-2<CR>gv=gv", {silent = true, desc = "Shift selection up"})
  vim.keymap.set('v', 'J', ":move '>+1<CR>gv=gv", {silent = true, desc = "Shift selection down"})

  vim.keymap.set({'n', 'v', 'o'}, "?", vim.cmd.WhichKey, {silent = true, desc = "Open root WhichKey menu"})

EOF
