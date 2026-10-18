-- LSP: servers are installed by Mason and configured with Neovim's native
-- `vim.lsp.config()` / `vim.lsp.enable()` API (Neovim 0.11+).
-- nvim-lspconfig is still needed: it ships the default config for every server.

-- lspconfig server names (mason-lspconfig translates them to Mason package names).
local servers = {
  "intelephense", -- PHP (WordPress / Drupal)
  "twiggy_language_server", -- Twig
  "vtsls", -- JavaScript / TypeScript
  "html",
  "emmet_language_server",
  "cssls",
  "somesass_ls", -- SCSS variables / mixins / @use navigation
  "eslint",
  "stylelint_lsp",
  "dockerls",
  "docker_compose_language_service",
  "marksman", -- Markdown / Obsidian-style links
  "jsonls",
  "yamlls",
  "lua_ls", -- for editing this config
  "bashls",
}

-- CLI tools (formatters / linters / debug adapter) installed through Mason.
local tools = {
  "prettier",
  "phpcs", -- needs `php` on the host (brew install php); projects usually pin their own in vendor/bin
  "phpcbf",
  "php-cs-fixer",
  "hadolint",
  "stylua",
  "shfmt",
  "php-debug-adapter",
}

return {
  { "mason-org/mason.nvim", cmd = "Mason", build = ":MasonUpdate", opts = { ui = { border = "rounded" } } },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "b0o/SchemaStore.nvim",
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim", -- Lua API completion when editing this config
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            { path = "snacks.nvim", words = { "Snacks" } },
            { path = "lazy.nvim", words = { "LazySpec" } },
          },
        },
      },
    },
    config = function()
      -- Diagnostics UI -------------------------------------------------------
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "\u{f057} ",
            [vim.diagnostic.severity.WARN] = "\u{f071} ",
            [vim.diagnostic.severity.INFO] = "\u{f05a} ",
            [vim.diagnostic.severity.HINT] = "\u{f0eb} ",
          },
        },
      })

      -- Capabilities for every server (blink.cmp adds completion capabilities)
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Buffer-local keymaps once a server attaches -----------------------------
      -- Neovim already provides: K hover, grn rename, gra code action, grr references,
      -- gri implementation, grt type definition, gO document symbols, <C-s> signature help (insert).
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(ev)
          local function m(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = ev.buf, desc = desc })
          end
          m("gd", function() Snacks.picker.lsp_definitions() end, "Goto definition")
          m("gD", vim.lsp.buf.declaration, "Goto declaration")
          m("gr", function() Snacks.picker.lsp_references() end, "References")
          m("gI", function() Snacks.picker.lsp_implementations() end, "Goto implementation")
          m("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto type definition")
          m("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          m("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          m("<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP info")
          m("<leader>cs", function() Snacks.picker.lsp_symbols() end, "Document symbols")

          -- Highlight other references of the symbol under the cursor
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client:supports_method("textDocument/documentHighlight", ev.buf) then
            local grp = vim.api.nvim_create_augroup("user_lsp_highlight_" .. ev.buf, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = grp, buffer = ev.buf, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              group = grp, buffer = ev.buf, callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Per-server settings --------------------------------------------------
      local schemastore = require("schemastore")

      vim.lsp.config("intelephense", {
        -- Premium features: put your licence key in $INTELEPHENSE_LICENCE_KEY (optional).
        init_options = { licenceKey = vim.env.INTELEPHENSE_LICENCE_KEY },
        settings = {
          intelephense = {
            -- Teach the indexer about Drupal's PHP file extensions.
            files = {
              maxSize = 5000000,
              associations = {
                "*.php", "*.phtml", "*.module", "*.theme", "*.install",
                "*.profile", "*.engine", "*.inc",
              },
            },
            -- "wordpress" stubs give you WP core functions/classes; the rest are intelephense defaults.
            stubs = {
              "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype", "curl",
              "date", "dba", "dom", "enchant", "exif", "FFI", "fileinfo", "filter", "fpm", "ftp",
              "gd", "gettext", "gmp", "hash", "iconv", "imap", "intl", "json", "ldap", "libxml",
              "mbstring", "meta", "mysqli", "oci8", "odbc", "openssl", "pcntl", "pcre", "PDO",
              "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix",
              "pspell", "readline", "Reflection", "session", "shmop", "SimpleXML", "snmp", "soap",
              "sockets", "sodium", "SPL", "sqlite3", "standard", "superglobals", "sysvmsg",
              "sysvsem", "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter",
              "Zend OPcache", "zip", "zlib", "wordpress",
            },
            environment = { phpVersion = "8.2.0" },
            format = { enable = false }, -- formatting is done by phpcbf / php-cs-fixer (see formatting.lua)
          },
        },
      })

      -- HTML + Emmet also for Twig / Nunjucks templates.
      vim.lsp.config("html", {
        filetypes = { "html", "twig", "htmldjango" },
      })
      vim.lsp.config("emmet_language_server", {
        filetypes = {
          "css", "html", "htmldjango", "javascriptreact", "less", "sass", "scss",
          "twig", "typescriptreact",
          -- add "php" here if you want emmet inside WordPress theme templates
        },
      })

      vim.lsp.config("vtsls", {
        settings = {
          typescript = { updateImportsOnFileMove = { enabled = "always" } },
          javascript = { updateImportsOnFileMove = { enabled = "always" } },
          vtsls = { enableMoveToFileCodeAction = true },
        },
      })

      vim.lsp.config("stylelint_lsp", {
        filetypes = { "css", "scss", "sass", "less" },
        settings = { stylelintplus = { autoFixOnSave = false, autoFixOnFormat = false } },
      })

      vim.lsp.config("jsonls", {
        settings = {
          json = { schemas = schemastore.json.schemas(), validate = { enable = true } },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            keyOrdering = false,
            format = { enable = true },
            validate = true,
            -- Use SchemaStore.nvim instead of the built-in catalog (includes docker-compose, GitHub Actions, ...).
            schemaStore = { enable = false, url = "" },
            schemas = schemastore.yaml.schemas(),
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim", "Snacks" } },
            telemetry = { enable = false },
          },
        },
      })

      -- Install and enable ---------------------------------------------------
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = true, -- calls vim.lsp.enable() for every installed server
      })
      require("mason-tool-installer").setup({
        ensure_installed = tools,
        run_on_start = true,
        start_delay = 3000,
      })
    end,
  },
}
