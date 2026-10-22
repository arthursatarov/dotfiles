-- Completion: blink.cmp (fast, built-in snippet + path + buffer sources).

return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- use a release tag so the prebuilt fuzzy-matcher binary is downloaded
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- "enter": <CR> accepts, <C-n>/<C-p> or <Tab>/<S-Tab> navigate, <C-e> hides, <C-space> opens.
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { border = "rounded", draw = { treesitter = { "lsp" } } },
        documentation = { auto_show = true, auto_show_delay_ms = 250, window = { border = "rounded" } },
        ghost_text = { enabled = false },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
          lsp = {
            -- PHP files mix PHP and HTML: emmet only makes sense outside <?php ?>, otherwise
            -- every identifier turns into a `<foo></foo>` suggestion. Treesitter knows the region.
            transform_items = function(ctx, items)
              if vim.bo[ctx.bufnr].filetype ~= "php" then return items end
              local ok, parser = pcall(vim.treesitter.get_parser, ctx.bufnr)
              if not ok or not parser then return items end
              local row, col = ctx.cursor[1] - 1, math.max(ctx.cursor[2] - 1, 0)
              parser:parse({ row, row + 1 }) -- make sure the HTML injection for this line is parsed
              if parser:language_for_range({ row, col, row, col }):lang() == "html" then return items end
              return vim.tbl_filter(function(item) return item.client_name ~= "emmet_language_server" end, items)
            end,
          },
        },
      },
      cmdline = { enabled = true },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },

  -- Obsidian note links (`[[`) are served by obsidian.nvim's built-in in-process LSP,
  -- so they show up through the normal "lsp" source above: no extra config needed.

  -- Surround / pairs ---------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true },
  },
}
