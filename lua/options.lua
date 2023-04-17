local EXPORTS = {}

EXPORTS.setup = function(opts)
  opts = opts or {}
  -- Pick python3 from virtual env or pick system python3
  if vim.env.VIRTUAL_ENV then
    vim.g.python3_host_prog = vim.fn.resolve(vim.env.VIRTUAL_ENV .. "/bin/python3")
  else
    vim.g.python3_host_prog = vim.fn.exepath("python3") or "python3"
  end

  -- All the set <THING>s
  vim.opt.mouse = "a"
  vim.opt.cindent = true
  vim.opt.hidden = true
  vim.opt.showmode = false
  vim.opt.swapfile = false
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
  vim.opt.number = true
  vim.opt.laststatus = 2

  -- Draw a line at the 80th column
  vim.opt.colorcolumn = "80"

  -- Address text wrapping
  vim.opt.textwidth = 0
  vim.opt.wrapmargin = 0

  -- For linting / git plugins
  vim.opt.signcolumn = "yes:2"

  -- Search related
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.inccommand = "nosplit"
  vim.opt.incsearch = true
  vim.opt.hlsearch = true
  vim.opt.showmatch = true
  vim.opt.wildignore = {
    "*.o",
    "*.pyc",
    "*/.git/*",
    "*/__pycache__/*",
    "*/build/*",
    "*/tmp/*",
    "nohup.out",
  }
  vim.opt.wildmenu = true
  vim.opt.wildmode = { "longest:full", "full" }
  vim.opt.scrolloff = 8
  vim.opt.cmdheight = 1

  -- Visuals-ish related
  vim.opt.termguicolors = true
  vim.opt.lazyredraw = true
  vim.opt.list = true
  vim.opt.background = opts.background or "light"
end

return EXPORTS
