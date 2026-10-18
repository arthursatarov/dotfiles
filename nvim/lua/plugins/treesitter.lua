-- Treesitter (main branch, the rewrite used with Neovim 0.11+).
-- Requirements: a C compiler (Xcode CLT) and the tree-sitter CLI:  brew install tree-sitter-cli

local parsers = {
  "bash", "css", "diff", "dockerfile", "git_config", "git_rebase", "gitcommit",
  "gitignore", "html", "ini", "javascript", "jsdoc", "json", "lua",
  "luadoc", "markdown", "markdown_inline", "php", "query", "regex", "scss",
  "sql", "toml", "tsx", "twig", "typescript", "vim", "vimdoc", "xml", "yaml",
}

-- Filetypes where treesitter indentation is better than the built-in one.
local ts_indent = {
  css = true, javascript = true, javascriptreact = true, json = true, lua = true,
  scss = true, tsx = true, typescript = true, typescriptreact = true,
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- the main branch does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})

      -- jsonc (JSON with comments: tsconfig, .eslintrc, ...) is handled by the json parser.
      vim.treesitter.language.register("json", "jsonc")

      -- Install missing parsers in the background.
      local installed = ts.get_installed()
      local missing = vim.tbl_filter(function(p) return not vim.tbl_contains(installed, p) end, parsers)
      if #missing > 0 then ts.install(missing) end

      -- Enable highlighting / folds / indent for every filetype that has a parser.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
          if not pcall(vim.treesitter.start, ev.buf, lang) then return end
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          if ts_indent[ev.match] then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Auto close / rename HTML & Twig tags
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- Smarter `gc` comments for embedded languages (JSX, Twig, HTML in PHP, ...)
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
