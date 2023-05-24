local EXPORTS = {}

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

EXPORTS.setup = function()
  -- Configures nvim-lspconfig, code completion and associated items
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local lspconfig = require("lspconfig")
  local lsp_signature = require("lsp_signature")

  lsp_signature.setup()

  require("luasnip.loaders.from_vscode").lazy_load()

  local select_next_item = function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end

  local select_prev_item = function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      -- Tab immediately completes. C-n/C-p to select.
      ["<Tab>"] = cmp.mapping.confirm({ select = true }),
      ["<C-n>"] = cmp.mapping(select_next_item, { "i", "s" }),
      ["<C-p>"] = cmp.mapping(select_prev_item, { "i", "s" }),
      ["<C-y>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "path" },
    }, {
      { name = "buffer" },
    }, {}),
    experimental = {
      ghost_text = true,
    },
  })

  -- Enable completing paths in :
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "cmdline" },
      { name = "path" },
    }),
  })

  -- Setup lspconfig
  local on_attach = function(_client, bufnr)
    --Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>hi", vim.lsp.buf.incoming_calls, bufopts)
    vim.keymap.set("n", "<space>ho", vim.lsp.buf.outgoing_calls, bufopts)
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, bufopts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, bufopts)
    vim.keymap.set("v", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, bufopts)

    -- Get signatures (and _only_ signatures) when in argument lists.
    lsp_signature.on_attach({
      doc_lines = 5,
      handler_opts = {
        border = "none",
      },
    })
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local lsp_setup_data = {
    rust_analyzer = {
      cmd = { "rustup", "run", "nightly", "rust-analyzer" },
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
          },
          assist = {
            importGranularity = "module",
            importPrefix = "self",
          },
          rustFmtArgs = { "+nightly" },
          procMacro = {
            enable = true,
          },
        },
      },
    },
    clangd = {
      cmd = {
        "clangd",
        "--background-index",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--header-insertion-decorators",
        "--clang-tidy",
        "--log=error",
        "--function-arg-placeholders",
        "-j=4",
      },
    },
    hls = {
      cmd = { "haskell-language-server-wrapper", "--lsp" },
    },
    pylsp = {
      plugins = {
        pylsp_mypy = {
          overrides = { "--no-pretty" },
        },
      },
    },
    cmake = {},
    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              "${3rd}/luassert/library",
              unpack(vim.api.nvim_get_runtime_file("", true)),
            },
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    },
  }

  -- Set up language server providers
  for canonical_lsp_name, server_config in pairs(lsp_setup_data) do
    local config = {
      capabilities = capabilities,
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
    }

    if server_config["cmd"] ~= nil then
      config.cmd = server_config.cmd
    end

    if server_config["settings"] ~= nil then
      config.settings = server_config.settings
    end

    lspconfig[canonical_lsp_name].setup(config)
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    loclist = true,
  })

  -- require 'nvim-treesitter.install'.compilers = { "clang" }
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "c",
      "cmake",
      "cpp",
      "fish",
      "haskell",
      "lua",
      "markdown",
      "python",
      "rust",
      "toml",
      "vim",
    },
    sync_install = false,
    highlight = {
      enable = true,
      disable = { "cmake" },
      additional_vim_regex_highlighting = false,
    },
  })
end

return EXPORTS
