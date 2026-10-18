-- Formatting (conform.nvim) and linting (nvim-lint).
--
-- Division of labour:
--   * ESLint and Stylelint run as LSP servers (see lsp.lua), they report diagnostics themselves.
--   * nvim-lint covers what has no LSP: phpcs (PHP) and hadolint (Dockerfile).
--   * conform formats on save. Project-local binaries (node_modules/.bin, vendor/bin)
--     are preferred over the Mason ones, and project configs (.prettierrc, .editorconfig,
--     phpcs.xml, .php-cs-fixer.php) always win.

local phpcs_markers = { "phpcs.xml", "phpcs.xml.dist", ".phpcs.xml", ".phpcs.xml.dist", "phpcs.ruleset.xml" }
local php_cs_fixer_markers = { ".php-cs-fixer.php", ".php-cs-fixer.dist.php" }

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "x" },
        desc = "Format buffer / selection",
      },
      {
        "<leader>uf",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Format on save: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
        end,
        desc = "Toggle format on save",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        -- PHP: use whatever the project is configured for. With neither config present,
        -- PHP is left untouched (no surprise reformatting of WordPress / Drupal core code).
        php = function(bufnr)
          if vim.fs.root(bufnr, php_cs_fixer_markers) then return { "php_cs_fixer" } end
          if vim.fs.root(bufnr, phpcs_markers) then return { "phpcbf" } end
          return {}
        end,
        -- twig / htmldjango (nunjucks): no reliable formatter, intentionally left alone.
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        -- Don't auto-format vendored / dependency code
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name:match("/node_modules/") or name:match("/vendor/") then return end
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
      formatters = {
        prettier = { prepend_args = {} },
      },
    },
    init = function()
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
      end, { desc = "Disable format on save (! = this buffer only)", bang = true })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Re-enable format on save" })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        php = { "phpcs" },
        dockerfile = { "hadolint" },
      }

      -- Prefer the project's own phpcs (it knows the WordPress / Drupal standards installed via composer).
      lint.linters.phpcs.cmd = function()
        local root = vim.fs.root(0, phpcs_markers) or vim.fn.getcwd()
        local local_bin = root .. "/vendor/bin/phpcs"
        return vim.fn.executable(local_bin) == 1 and local_bin or "phpcs"
      end

      local function try_lint()
        -- Only run phpcs when the project actually defines a standard; otherwise
        -- phpcs falls back to PEAR rules and floods you with irrelevant warnings.
        if vim.bo.filetype == "php" and not vim.fs.root(0, phpcs_markers) then return end
        lint.try_lint()
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
        callback = try_lint,
      })
    end,
  },
}
